/*
# AUTOGENERATED DO NOT EDIT

# If you edit this file, delete the AUTOGENERATED line to prevent re-generation
# BUILD api_versions [0x001]
*/

%module point_parameters

#define __version__ "$Revision: 1.1.2.1 $"
#define __date__ "$Date: 2004/11/15 07:38:07 $"
#define __api_version__ API_VERSION
#define __author__ "PyOpenGL Developers <pyopengl-devel@lists.sourceforge.net>"
#define __doc__ ""

%{
/**
 *
 * GL.SGIS.point_parameters Module for PyOpenGL
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

#if !EXT_DEFINES_PROTO || !defined(GL_SGIS_point_parameters)
DECLARE_VOID_EXT(glPointParameterfSGIS, (GLenum pname, GLfloat param), (pname, param))
DECLARE_VOID_EXT(glPointParameterfvSGIS, (GLenum pname, const GLfloat *params), (pname, params))
#endif
%}

/* FUNCTION DECLARATIONS */
void glPointParameterfSGIS(GLenum pname, GLfloat param);
DOC(glPointParameterfSGIS, "glPointParameterfSGIS(pname, param)")
void glPointParameterfvSGIS(GLenum pname, const GLfloat *params);
DOC(glPointParameterfvSGIS, "glPointParameterfvSGIS(pname, params)")

/* CONSTANT DECLARATIONS */
#define         GL_POINT_SIZE_MIN_SGIS 0x8126
#define         GL_POINT_SIZE_MAX_SGIS 0x8127
#define GL_POINT_FADE_THRESHOLD_SIZE_SGIS 0x8128
#define   GL_DISTANCE_ATTENUATION_SGIS 0x8129


%{
static char *proc_names[] =
{
#if !EXT_DEFINES_PROTO || !defined(GL_SGIS_point_parameters)
"glPointParameterfSGIS",
"glPointParameterfvSGIS",
#endif
	NULL
};

#define glInitPointParametersSGIS() InitExtension("GL_SGIS_point_parameters", proc_names)
%}

int glInitPointParametersSGIS();
DOC(glInitPointParametersSGIS, "glInitPointParametersSGIS() -> bool")

%{
PyObject *__info()
{
	if (glInitPointParametersSGIS())
	{
		PyObject *info = PyList_New(0);
		return info;
	}
	
	Py_INCREF(Py_None);
	return Py_None;
}
%}

PyObject *__info();

