/*
# AUTOGENERATED DO NOT EDIT

# If you edit this file, delete the AUTOGENERATED line to prevent re-generation
# BUILD api_versions [0x001]
*/

%module texture_env_dot3

#define __version__ "$Revision: 1.1.2.1 $"
#define __date__ "$Date: 2004/11/15 07:38:07 $"
#define __api_version__ API_VERSION
#define __author__ "PyOpenGL Developers <pyopengl-devel@lists.sourceforge.net>"
#define __doc__ ""

%{
/**
 *
 * GL.EXT.texture_env_dot3 Module for PyOpenGL
 * 
 * Authors: PyOpenGL Developers <pyopengl-devel@lists.sourceforge.net>
 * 
***/
%}

%include util.inc
%include gl_exception_handler.inc

%{
#ifdef CGL_PLATFORM
# include <OpenGL/glext.h>
#else
# include <GL/glext.h>
#endif

#if !EXT_DEFINES_PROTO || !defined(GL_EXT_texture_env_dot3)

#endif
%}

/* FUNCTION DECLARATIONS */


/* CONSTANT DECLARATIONS */
#define                GL_DOT3_RGB_EXT 0x8740
#define               GL_DOT3_RGBA_EXT 0x8741


%{
static char *proc_names[] =
{
#if !EXT_DEFINES_PROTO || !defined(GL_EXT_texture_env_dot3)

#endif
	NULL
};

#define glInitTextureEnvDot3EXT() InitExtension("GL_EXT_texture_env_dot3", proc_names)
%}

int glInitTextureEnvDot3EXT();
DOC(glInitTextureEnvDot3EXT, "glInitTextureEnvDot3EXT() -> bool")

%{
PyObject *__info()
{
	if (glInitTextureEnvDot3EXT())
	{
		PyObject *info = PyList_New(0);
		return info;
	}
	
	Py_INCREF(Py_None);
	return Py_None;
}
%}

PyObject *__info();

