/*
 * This file contains the code that is used to create proxy-classes for Python
 * classes in the objective-C runtime.
 */
#include <Python.h>
#include "pyobjc.h"
#include "objc_support.h"
#include <Foundation/NSInvocation.h>
//#include <Foundation/Foundation.h> // Needed for NSInvocation


/* We add 1 instance variable to hybrid objective-C/Python classes, this 
 * contains the reference to the python half of the class. Name should be 
 * not be used by Objective-C classes that are not managed by PyObjC... 
 */
static char pyobj_ivar[] = "__pyobjc_obj__";

/* List of instance variables, methods and class-methods that should not
 * be overridden from python
 */
static char* dont_override_methods[] = {
        pyobj_ivar,
	"alloc",
	"dealloc",
	"retain",
	"release",
	"autorelease",
	"retainCount",
	NULL
};

/* Special methods for Python subclasses of Objective-C objects */
static id class_method_alloc(id self, SEL sel);
static id class_method_allocWithZone(id self, SEL sel, NSZone* zone);

static id object_method_retain(id self, SEL sel);
static void object_method_release(id self, SEL sel);
static id object_method_autorelease(id self, SEL sel);
static unsigned object_method_retainCount(id self, SEL sel);
static BOOL object_method_respondsToSelector(id self, SEL selector, 
	SEL aSelector);
static NSMethodSignature*  object_method_methodSignatureForSelector(id self, 
	SEL selector, SEL aSelector);
static void object_method_forwardInvocation(id self, SEL selector, 
	NSInvocation* invocation);


struct class_wrapper {
	struct objc_class  class;
	struct objc_class  meta_class;
	PyObject*          python_class;
};

#define IDENT_CHARS "ABCDEFGHIJKLMNOPQSRTUVWXYZabcdefghijklmnopqrstuvwxyz_"


/*
 * Return wether the object is (partially) implemented in python
 */
int ObjC_HasPythonImplementation(id obj)
{
	Ivar var = class_getInstanceVariable(obj->isa, pyobj_ivar);

	return (var != NULL);
}

/*
 * Get the python half of the implementation.
 *
 * Returns a borrowed reference.
 */
PyObject* ObjC_GetPythonImplementation(id obj)
{
	/* 
	 * XXX: According to the docs for object_getInstanceVariable this
	 * is wrong, but if I do follow the docs the code doesn't work...
	 */
	PyObject* pyobj = NULL;
	Ivar      var   = NULL;

	var = object_getInstanceVariable(obj, pyobj_ivar, (void**)&pyobj);
	if (var == NULL) {
		ObjCErr_Set(objc_internal_error,
			"ObjC_GetPythonImplementation called for "
			"normal object of class %s", obj->isa->name);
		return NULL;
	}

	if (pyobj == NULL) {
		return Py_None;
	}
	return pyobj;
}

/*
 * Last step of the construction a python subclass of an objective-C class.
 *
 * Set reference to the python half in the objective-C half of the class.
 *
 * Return 0 on success, -1 on failure.
 */
int ObjCClass_SetClass(Class objc_class, PyObject* py_class)
{

#ifdef OBJC_PARANOIA_MODE
	if (class_getInstanceVariable(objc_class, pyobj_ivar) == NULL) {
		ObjCErr_Set(objc_internal_error, 
			"Trying to set class of non-python %s", 
			objc_class->name);
		return -1;
	}
	if (py_class == NULL || !ObjCClass_Check(py_class)) {
		ObjCErr_Set(objc_internal_error,
			"Trying to set class to of %s to invalid",
			objc_class->name);
		return -1;
	}
#endif /* OBJC_PARANOIA_MODE */

	((struct class_wrapper*)objc_class)->python_class = py_class;
	Py_INCREF(py_class);

	objc_addClass(objc_class);
	return 0;
}

/*
 * Call this when the python half of the class could not be created. Do *not*
 * use this to deconstruct an already registered class.
 */
void ObjCClass_UnbuildClass(Class objc_class)
{
	struct class_wrapper* wrapper = (struct class_wrapper*)objc_class;

#ifdef OBJC_PARANOIA_MODE
	if (class_getInstanceVariable(objc_class, pyobj_ivar) == NULL) {
		ObjCErr_Set(objc_internal_error, 
			"Trying to unregister class of non-python %s", 
			objc_class->name);
		return;
	}
#endif /* OBJC_PARANOIA_MODE */

	if (wrapper->python_class != NULL) {
		/* class already registered, fail */
		ObjCErr_Set(objc_internal_error,
			"Trying to unregister objective-C klass %s",
			objc_class->name);
		return;
	}

	if (wrapper->class.methodLists) {
		if (wrapper->class.methodLists[0]) {
			free(wrapper->class.methodLists[0]);
		}
		free(wrapper->class.methodLists);
	}
	if (wrapper->meta_class.methodLists) {
		if (wrapper->meta_class.methodLists[0]) {
			free(wrapper->meta_class.methodLists[0]);
		}
		free(wrapper->meta_class.methodLists);
	}
	free((char*)(wrapper->class.name));
	free(objc_class);
}



/*
 * First step of creating a python subclass of an objective-C class
 *
 * Returns NULL or the newly created objective-C klass. 'class_dict' may
 * be modified by this function.
 */
Class ObjCClass_BuildClass(Class super_class, 
				char* name, PyObject* class_dict)
{
	PyObject*                key_list = NULL;
	PyObject*                key = NULL;
	PyObject*                value = NULL;
	int                      i, key_count;
	int	                 ivar_count = 0;
	int                      ivar_size  = 0;
	int                      meta_method_count = 0;
	int                      method_count = 0;
	int                      first_python_gen = 0;
	struct objc_ivar_list*   ivar_list = NULL;
	struct objc_method_list* method_list = NULL;
	struct objc_method_list* meta_method_list = NULL;
	struct class_wrapper*    new_class = NULL;
	Class                    root_class;
	char**                   curname;
	PyObject*		 py_superclass;


	/* XXX: May as well directly pass this in... */
	py_superclass = ObjCClass_New(super_class);
	if (py_superclass == NULL) return NULL;


#ifdef OBJC_PARANOIA_MODE
	if (!PyDict_Check(class_dict)) {
		ObjCErr_Set(objc_internal_error, "%s", 
			"class dict not a PyDict");
		goto error_cleanup;
	}
	if (super_class == NULL) {
		ObjCErr_Set(objc_internal_error, "%s", 
			"must have super_class");
		goto error_cleanup;
	}
#endif /* OBJC_PARANOIA_MODE */

	if (objc_lookUpClass(name) != NULL) {
		ObjCErr_Set(objc_error, "class '%s' exists", name);
		goto error_cleanup;
	}
	if (strspn(name, IDENT_CHARS) != strlen(name)) {
		ObjCErr_Set(objc_error, "'%s' not a valid name", name);
		goto error_cleanup;
	}


	/* 
	 * Check for methods/variables that must not be overridden in python.
	 */
	for (curname = dont_override_methods; *curname != NULL; curname++) {
		key = PyDict_GetItemString(class_dict, *curname);
		if (key != NULL) {
			ObjCErr_Set(objc_error,
				"Cannot override %s from python", *curname);
			goto error_cleanup;
		}
	}

	key_list = PyDict_Keys(class_dict);
	if (key_list == NULL) {
		goto error_cleanup;
	}

	key_count = PyList_Size(key_list);
	if (PyErr_Occurred()) {
		Py_DECREF(key_list);
		goto error_cleanup;
	}


	if (class_getInstanceVariable(super_class, pyobj_ivar) == 0) {
		first_python_gen = 1;

		/* 
		 * This class has a super_class that is pure objective-C
		 * We'll add some instance variables and methods that are
		 * needed for the correct functioning of the class. 
		 *
		 * See the code below the next loop.
		 */
		ivar_count        += 1;
		meta_method_count += 2; 
		method_count      += 7;
	}

	/* First round, count new instance-vars and check for overridden 
	 * methods.
	 */
	for (i = 0; i < key_count; i++) {
		key = PyList_GetItem(key_list, i);
		if (PyErr_Occurred()) {
			PyErr_Clear();
			ObjCErr_Set(objc_internal_error,
				"Cannot fetch key in keylist");
			goto error_cleanup;
		}

		value = PyDict_GetItem(class_dict, key);
		if (value == NULL) {
			PyErr_Clear();
			ObjCErr_Set(objc_internal_error,
				"Cannot fetch item in keylist");
			goto error_cleanup;
		}

		if (ObjCIvar_Check(value)) {
			if (class_getInstanceVariable(super_class, 
					((ObjCIvar*)value)->name) != NULL) {
				ObjCErr_Set(objc_error,
					"Cannot replace instance variable %s",
					((ObjCIvar*)value)->name);
				goto error_cleanup;
			}

			ivar_count ++;
			ivar_size += objc_sizeof_type(((ObjCIvar*)value)->type);

		} else if (ObjCSelector_Check(value)) {
			ObjCSelector* sel = (ObjCSelector*)value;
			Method        meth;

			if (sel->sel_class_method) {
				meth = class_getClassMethod(super_class,
					sel->sel_selector);
				if (meth) {
					meta_method_count ++;
				}


			} else {
				meth = class_getInstanceMethod(super_class,
					sel->sel_selector);
				method_count ++;
			}

		} else if (PyMethod_Check(value) || PyFunction_Check(value)) {
			PyObject* pyname;
			char*     name;
			SEL	  selector;
			Method    meth;

			pyname = PyObject_GetAttrString(value, "__name__");
			if (pyname == NULL) continue;

			name = PyString_AS_STRING(pyname);
			if (name[0] == '_' && name[1] == '_') {
				/* Skip special methods */
				continue;
			}

			selector = ObjCSelector_DefaultSelector(name);

			meth = class_getInstanceMethod(super_class, selector);
			if (!meth) {
				if (!class_getClassMethod(
						super_class, selector) == NULL){
					continue;
				}
			}

			if (meth) {
				/* The function overrides a method in the 
				 * objective-C class, replace by a selector 
				 * object.
				 *
				 * Get the signature through the python wrapper,
				 * the user may have specified a more exact
				 * signature!
				 */
				PyObject* super_sel = ObjCClass_FindSelector(
					py_superclass, selector);
				if (!super_sel) goto error_cleanup;

				value = ObjCSelector_New(
					value, 
					selector, 
					ObjCSelector_Signature(super_sel),
					0);
				Py_DECREF(super_sel);
			} else {
				value = ObjCSelector_New(
					value, 
					selector, 
					NULL,
					0);
			}
			if (value == NULL) goto error_cleanup;
				
			if (PyDict_SetItem(class_dict, key, value) < 0) {
				goto error_cleanup;
			}
			method_count++;
		}			
	}

	/* Allocate space for the new instance variables and methods */

	if (ivar_count == 0)  {
		ivar_list = NULL;
	} else {
		ivar_list = malloc(sizeof(struct objc_ivar_list) +
			(ivar_count)*sizeof(struct objc_ivar));
		if (ivar_list == NULL) {
			PyErr_NoMemory();
			goto error_cleanup;
		}
		ivar_list->ivar_count = 0;
	}

	if (method_count == 0) {
		method_list = NULL;
	} else {
		method_list = malloc(sizeof(struct objc_method_list) +
			(method_count)*sizeof(struct objc_method));
		if (method_list == NULL) {
			PyErr_NoMemory();
			goto error_cleanup;
		}
		memset(method_list, 0, sizeof(struct objc_method_list) +
			(method_count)*sizeof(struct objc_method));
		method_list->method_count      = 0;
		method_list->obsolete = NULL; /* DEBUG */
	}

	if (meta_method_count == 0) {
		meta_method_list = NULL;
	} else {
		meta_method_list = malloc(sizeof(struct objc_method_list)+
			(meta_method_count)*sizeof(struct objc_method));
		if (meta_method_list == NULL) {
			PyErr_NoMemory();
			goto error_cleanup;
		}
		memset(meta_method_list, 0, sizeof(struct objc_method_list)+
			(meta_method_count)*sizeof(struct objc_method));
		meta_method_list->method_count = 0;
		meta_method_list->obsolete = NULL; /* DEBUG */
	}


	/* And fill the method_lists and ivar_list */

	/* Create new_class here, just in case we are the first python
	 * generation, in which case we need to use new_class (it must just
	 * be there, it doesn't have to be initialized)
	 */
	new_class = calloc(1, sizeof(struct class_wrapper));
	if (new_class == NULL) {
		goto error_cleanup;
	}

	ivar_size = super_class->instance_size;

	if (first_python_gen) {
		/* Our parent is a pure Objective-C class, add our magic
		 * methods and variables 
		 */
		Ivar var = ivar_list->ivar_list;
		Method meth;
		PyObject* sel;
		ivar_list->ivar_count++;

		var->ivar_name = pyobj_ivar;
		var->ivar_type = "^v";
		var->ivar_offset = ivar_size;
		ivar_size += sizeof(void*);

#		define META_METH(pyname, selector, types, imp) 		\
			meth = meta_method_list->method_list + 		\
				meta_method_list->method_count++;	\
			meth->method_name = selector;			\
			meth->method_types = types;			\
			meth->method_imp = (IMP)imp;			\
			sel = ObjCSelector_NewNative(&new_class->class, \
				selector,  types, 1);			\
			if (sel == NULL) goto error_cleanup;		\
			PyDict_SetItemString(class_dict, pyname, sel)

#		define METH(pyname, selector, types, imp) 		\
			meth = method_list->method_list + 		\
				method_list->method_count++;		\
			meth->method_name = selector;			\
			meth->method_types = types;			\
			meth->method_imp = (IMP)imp;			\
			sel = ObjCSelector_NewNative(&new_class->class, \
				selector,  types, 0);			\
			if (sel == NULL) goto error_cleanup;		\
			PyDict_SetItemString(class_dict, pyname, sel)
					

		META_METH("alloc", @selector(alloc), "@@:", class_method_alloc);
		META_METH("allocWithZone_", @selector(allocWithZone:), "@@:^{_NSZone=}", class_method_allocWithZone);

		METH("retain", @selector(retain), "@@:", object_method_retain);
		METH("release", @selector(release), "v@:", object_method_release);
		METH("retainCount", @selector(retainCount), "I@:", object_method_retainCount);
		METH("autorelease", @selector(autorelease), "@@:", object_method_autorelease);
		METH("respondsToSelector_", @selector(respondsToSelector:), "c@::", 
			object_method_respondsToSelector);
		METH("methodSignatureForSelector_", @selector(methodSignatureForSelector:), "@@::", 
			object_method_methodSignatureForSelector);
		METH("forwardInvocation_", @selector(forwardInvocation:), "v@:@", 
			object_method_forwardInvocation);

#undef		METH
#undef		META_METH
	}

	for (i = 0; i < key_count; i++) {
		key = PyList_GetItem(key_list, i);
		if (key == NULL) {
			ObjCErr_Set(objc_internal_error,
				"Cannot fetch key in keylist");
			goto error_cleanup;
		}

		value = PyDict_GetItem(class_dict, key);
		if (value == NULL)  {
			ObjCErr_Set(objc_internal_error,
				"Cannot fetch item in keylist");
			goto error_cleanup;
		}

		if (ObjCIvar_Check(value)) {
			Ivar var;

			var = ivar_list->ivar_list + ivar_list->ivar_count;
			ivar_list->ivar_count++;

			var->ivar_name = ((ObjCIvar*)value)->name;
			var->ivar_type = ((ObjCIvar*)value)->type;
			var->ivar_offset = ivar_size;

			ivar_size += objc_sizeof_type(var->ivar_type);

		} else if (ObjCSelector_Check(value)) {
			ObjCSelector* sel = (ObjCSelector*)value;
			Method        meth;
			int           is_override = 0;
			struct objc_method_list* lst;

			if (sel->sel_class_method) {
				meth = class_getClassMethod(super_class,
					sel->sel_selector);
				if (!meth) continue;
				is_override = 1;
				lst = meta_method_list;
			} else {
				meth = class_getInstanceMethod(super_class,
					sel->sel_selector);
				if (meth) is_override = 1;
				lst = method_list;
			}

			meth = lst->method_list + lst->method_count;
			meth->method_name = sel->sel_selector;
			meth->method_types = sel->sel_signature;
		
			if (is_override) {
				meth->method_imp = 
					ObjC_FindIMP(super_class, 
						sel->sel_selector);
			} else {
				meth->method_imp = 
					ObjC_FindIMPForSignature(sel->sel_signature);

			}

			if (meth->method_imp == NULL) {
				goto error_cleanup;
			}
			lst->method_count++;
		}
	}
	Py_DECREF(key_list);
	key_list = NULL;

	/* And now initialize the actual class... */

	root_class = super_class;
	while (root_class->super_class != NULL) {
		root_class = root_class->super_class;
	}

	new_class->python_class = NULL;
	new_class->class.methodLists = NULL;
	new_class->meta_class.methodLists = NULL;
	new_class->class.isa = &new_class->meta_class;
	new_class->class.info = CLS_CLASS;
	new_class->meta_class.info = CLS_META;

	new_class->class.name = strdup(name);
	new_class->meta_class.name = new_class->class.name;

	new_class->class.methodLists = 
		calloc(1, sizeof(struct objc_method_list*));
	if (new_class->class.methodLists == NULL) abort();
	new_class->class.methodLists[0] = NULL;

	new_class->meta_class.methodLists = 
		calloc(1, sizeof(struct objc_method_list*));
	if (new_class->meta_class.methodLists == NULL) abort();
	new_class->meta_class.methodLists[0] = NULL;

	new_class->class.super_class = super_class;
	new_class->meta_class.super_class = super_class->isa;
	new_class->meta_class.isa = root_class->isa;

	new_class->class.instance_size = ivar_size;
	new_class->class.ivars = ivar_list;

	/* Be explicit about clearing data, should not be necessary with
	 * 'calloc'
	 */
	new_class->class.cache = NULL;
	new_class->meta_class.cache = NULL;

	new_class->class.protocols = NULL;
	new_class->meta_class.protocols = NULL;

	if (method_list) {
		class_addMethods(&(new_class->class), method_list);
	}
	if (meta_method_list) {
		class_addMethods(&(new_class->meta_class), meta_method_list);
	}

	/* 
	 * NOTE: Class is not registered yet, we do that as lately as possible
	 * because it is impossible to remove the registration from the
	 * objective-C runtime (at least on MacOS X).
	 */
	return (Class)new_class;

error_cleanup:
	if (key_list != NULL) {
		Py_DECREF(key_list);
		key_list = NULL;
	}

	if (ivar_list) {
		free(ivar_list);
	}
	if (method_list) {
		free(method_list);
	}
	if (meta_method_list) {
		free(meta_method_list);
	}

	if (new_class != NULL) {
		if (new_class->class.methodLists) {
			free(new_class->class.methodLists);
		}
		if (new_class->meta_class.methodLists) {
			free(new_class->meta_class.methodLists);
		}
		if (new_class->class.name) {
			free((char*)(new_class->class.name));
		}
		free(new_class);
	}

	return NULL;
}

/*
 * Below here are implementations of various methods needed to correctly
 * subclass Objective-C classes from Python. 
 *
 * These are added to the new Objective-C class by  ObjCClass_BuildClass (but
 * only if the super_class is a 'pure' objective-C klass)
 *
 * The protocol for objc-python object-clusters is:
 * - +alloc calls [super alloc], then creates a new Python 'wrapper' for it
 *   (ObjCObject_New) and sets a pointer to that wrapper object in the 
 *   correct instance variable of the new object
 * - +allocWithZone: is implemented in a simular manner.
 * - the references from the python-side to the objective-c side and back
 *   do _not_ count in the reference-count of the cluster
 * - the reference-count is stored in the python-side
 * - deallocactie doen we eerst in python en dan in objective-C
 *
 * NOTE:
 * - According to the compiler these are normal function, we cannot use
 *   things like [super ...] here!
 */

/*
 * +alloc
 */
static id class_method_alloc(id self, SEL sel)
{  
   /* NSObject documentation defines +alloc as 'allocWithZone:nil' */
   return class_method_allocWithZone(self, sel, nil);
}


/* +allocWithZone: */
static id class_method_allocWithZone(id self, SEL sel, NSZone* zone)
{
   PyObject* pyclass;
   ObjCObject* pyobject;
   id          obj;
   struct objc_super super;

   pyclass = ((struct class_wrapper*)self)->python_class;

   super.class = ((Class)self)->super_class->isa; 
   super.receiver = self;

   obj = objc_msgSendSuper(&super, @selector(allocWithZone:), zone); 
   if (obj == nil) {
	   return nil;	
   }

   pyobject = (ObjCObject*)ObjCObject_New(obj);
   if (pyobject == NULL) {
       ObjCErr_ToObjC();
       return nil;
   }

   pyobject->is_paired = 1;

   /* obj->__pyobjc_obj__ = pyobjct */ 
   if (object_setInstanceVariable(obj, pyobj_ivar, pyobject) == NULL) {
	/* XXX: Leaking!, need exception */
       PySys_WriteStderr("Cannot set python reference");
       Py_DECREF(pyobject);
       return nil;
   }

#ifdef OBJC_PARANOIA_MODE
   if ([obj retainCount] != 1) {
	abort();
   }
#endif

   return obj;
}

/* -retain */
static id object_method_retain(id self, SEL sel)
{
	PyObject* pyself;

	pyself = ObjC_GetPythonImplementation(self);

	if (pyself) {
		Py_INCREF(pyself);
	} else {
		PyErr_Clear();
	}

	return self;
}

/* -autorelease */
static id object_method_autorelease(id self, SEL sel)
{
	struct objc_super super;

	super.class = self->isa->super_class;
	super.receiver = self;
	self = objc_msgSendSuper(&super, @selector(autorelease)); 
	return self;
}

/* -release */
static void object_method_release(id self, SEL sel)
{
	struct objc_super super;
	PyObject* obj;

	
	obj = ObjC_GetPythonImplementation(self);

	if (obj == NULL) {
		PyErr_Clear();
		return;
	}

	if (obj->ob_refcnt == 0) {
		printf("Release with dead python\n");
		super.class = self->isa->super_class;
		super.receiver = self;
		self = objc_msgSendSuper(&super, @selector(release)); 
		return;

	} else if (obj->ob_refcnt != 1) {
		Py_DECREF(obj);
		return;
	} 

	/* need to dealloc. protocol: we dealloc the python-side and
	 * then ourselves. We call [super release] instead of just 
	 * [self dealloc] just in case the normal release does something
	 * sneeky.
	 *
	 * Py_DECREF() causes object_dealloc with calls back into us
	 * with retainCount == 0.
	 */
	printf("Before DECREF in normal\n");
	Py_DECREF(obj);
#if 0
	printf("After DECREF in normal\n");
	super.class = self->isa->super_class;
	super.receiver = self;
        self = objc_msgSendSuper(&super, @selector(release)); 
#endif

	return;
}

/* -retainCount */
static unsigned object_method_retainCount(id self, SEL sel)
{
	return ObjC_GetPythonImplementation(self)->ob_refcnt;
}

/* -respondsToSelector: */
static BOOL 
object_method_respondsToSelector(id self, SEL selector, SEL aSelector)
{
	struct objc_super super;
	BOOL              res;
        PyObject*         pyself;
	PyObject*         pymeth;


	/* First check if we respond */
	pyself = ObjC_GetPythonImplementation(self);
	if (pyself == NULL) {
		NSLog(@"WARNING: Incomplete PyObjC object\n");
		return NO;
	}
	pymeth = ObjCObject_FindSelector(pyself, aSelector);
	if (pymeth) {
		Py_DECREF(pymeth);
		return YES;
	}
	PyErr_Clear();

	/* XXX: We currently don't respond correctly for methods we added
	 * to python/objc hybrids, below is a quick fix for some of them.
	 */
	if (aSelector == @selector(respondsToSelector:)) return YES;
      
	/* Check superclass */
	super.receiver = self;
	super.class = self->isa->super_class;

	res = (int)objc_msgSendSuper(&super, selector, aSelector);

	return res;
}

/* -methodSignatureForSelector */
static NSMethodSignature*  
object_method_methodSignatureForSelector(id self, SEL selector, SEL aSelector)
{
	NSMethodSignature* result = nil;
	struct objc_super  super;
        PyObject*          pyself;
	PyObject*          pymeth;


	super.receiver = self;
	super.class    = self->isa->super_class;

	NS_DURING
		result = objc_msgSendSuper(&super, selector, aSelector);
	NS_HANDLER
		NSLog(@"[super methodSignatureForSelector:] failed: %@ - %@",
			[localException name], [localException reason]);
		result = nil;
	NS_ENDHANDLER

	if (result != nil) {
		return result;
	}

	pyself = ObjC_GetPythonImplementation(self);
	if (pyself == NULL) {
		ObjCErr_ToObjC();
		return nil;
	}

	pymeth = ObjCObject_FindSelector(pyself, aSelector);
	if (!pymeth) {
		ObjCErr_ToObjC();
		return nil;
	}

	result =  [NSMethodSignature signatureWithObjCTypes:(
		  	(ObjCSelector*)pymeth)->sel_signature];
	[result autorelease];
	Py_DECREF(pymeth);
	return result;
}

/* -forwardInvocation: */
static void
object_method_forwardInvocation(id self, SEL selector, NSInvocation* invocation)
{
	/* TODO: error handling */
	PyObject*	args;
	PyObject* 	result;
	PyObject*       v;
	int             i;
	int 		len;
	NSMethodSignature* signature;
	char		   argbuf[1024];
	const char* 		type;
	void* arg = NULL;
	const char* err;
	int   arglen;


	signature = [invocation methodSignature];
	len = [signature numberOfArguments];

	args = PyTuple_New(len - 1);
	if (args == NULL) {
		ObjCErr_ToObjC();
	}

	i = PyTuple_SetItem(args, 0, pythonify_c_value(
					[signature getArgumentTypeAtIndex:0],
					(void*)&self));
	if (i < 0) ObjCErr_ToObjC();

	for (i = 2; i < len; i++) {
		type = [signature getArgumentTypeAtIndex:i];
		arglen = objc_sizeof_type(type);
		arg = alloca(arglen);
		
		[invocation getArgument:argbuf atIndex:i];
		v = pythonify_c_value(type, argbuf);
		if (v == NULL) {
			ObjCErr_ToObjC();
			return;
		}

		PyTuple_SetItem(args, i-1, v);
	}

	result = ObjC_call_to_python(self, [invocation selector], args);
	Py_DECREF(args);
	if (result == NULL) {
		ObjCErr_ToObjC();
		return;
	}

	type = [signature methodReturnType];
	arglen = objc_sizeof_type(type);
	arg = alloca(arglen);

	err = depythonify_c_value(type, result, arg);
	if (err != NULL) abort();
}

/*
 * XXX: Function ObjC_call_to_python should be moved
 */

PyObject*
ObjC_call_to_python(id self, SEL selector, PyObject* arglist)
{
	PyObject* pyself = NULL;
	PyObject* pymeth = NULL;
	PyObject* result;


	pyself = ObjC_GetPythonImplementation(self);
	if (pyself == NULL) {
		ObjCErr_ToObjC();
		return NULL;
	}
	pymeth = ObjCObject_FindSelector(pyself, selector);
	if (pymeth == NULL) {
		ObjCErr_ToObjC();
		return NULL;
	}

	result = PyObject_Call(pymeth, arglist, NULL);
	Py_DECREF(pymeth);

	if (result == NULL) {
		ObjCErr_ToObjC();
	}

	return result;
}