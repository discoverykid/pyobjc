# This file was created automatically by SWIG.
# Don't modify this file, modify the SWIG interface instead.
# This file is compatible with both classic and new-style classes.

import _scalebias_hint

def _swig_setattr_nondynamic(self,class_type,name,value,static=1):
    if (name == "this"):
        if isinstance(value, class_type):
            self.__dict__[name] = value.this
            if hasattr(value,"thisown"): self.__dict__["thisown"] = value.thisown
            del value.thisown
            return
    method = class_type.__swig_setmethods__.get(name,None)
    if method: return method(self,value)
    if (not static) or hasattr(self,name) or (name == "thisown"):
        self.__dict__[name] = value
    else:
        raise AttributeError("You cannot add attributes to %s" % self)

def _swig_setattr(self,class_type,name,value):
    return _swig_setattr_nondynamic(self,class_type,name,value,0)

def _swig_getattr(self,class_type,name):
    method = class_type.__swig_getmethods__.get(name,None)
    if method: return method(self)
    raise AttributeError,name

import types
try:
    _object = types.ObjectType
    _newclass = 1
except AttributeError:
    class _object : pass
    _newclass = 0
del types


__version__ = _scalebias_hint.__version__
__date__ = _scalebias_hint.__date__
__api_version__ = _scalebias_hint.__api_version__
__author__ = _scalebias_hint.__author__
__doc__ = _scalebias_hint.__doc__
GL_SCALEBIAS_HINT_SGIX = _scalebias_hint.GL_SCALEBIAS_HINT_SGIX

glInitScalebiasHintSGIX = _scalebias_hint.glInitScalebiasHintSGIX

__info = _scalebias_hint.__info

