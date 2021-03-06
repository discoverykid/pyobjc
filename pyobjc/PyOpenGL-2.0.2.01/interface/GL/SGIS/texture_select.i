/*
# AUTOGENERATED DO NOT EDIT

# If you edit this file, delete the AUTOGENERATED line to prevent re-generation
# BUILD api_versions [0x001]
*/

%module texture_select

#define __version__ "$Revision: 1.1.2.1 $"
#define __date__ "$Date: 2004/11/15 07:38:07 $"
#define __api_version__ API_VERSION
#define __author__ "PyOpenGL Developers <pyopengl-devel@lists.sourceforge.net>"
#define __doc__ ""

%{
/**
 *
 * GL.SGIS.texture_select Module for PyOpenGL
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

#if !EXT_DEFINES_PROTO || !defined(GL_SGIS_texture_select)

#endif
%}

/* FUNCTION DECLARATIONS */


/* CONSTANT DECLARATIONS */
#define            GL_DUAL_ALPHA4_SGIS 0x8110
#define            GL_DUAL_ALPHA8_SGIS 0x8111
#define           GL_DUAL_ALPHA12_SGIS 0x8112
#define           GL_DUAL_ALPHA16_SGIS 0x8113
#define        GL_DUAL_LUMINANCE4_SGIS 0x8114
#define        GL_DUAL_LUMINANCE8_SGIS 0x8115
#define       GL_DUAL_LUMINANCE12_SGIS 0x8116
#define       GL_DUAL_LUMINANCE16_SGIS 0x8117
#define        GL_DUAL_INTENSITY4_SGIS 0x8118
#define        GL_DUAL_INTENSITY8_SGIS 0x8119
#define       GL_DUAL_INTENSITY12_SGIS 0x811A
#define       GL_DUAL_INTENSITY16_SGIS 0x811B
#define  GL_DUAL_LUMINANCE_ALPHA4_SGIS 0x811C
#define  GL_DUAL_LUMINANCE_ALPHA8_SGIS 0x811D
#define            GL_QUAD_ALPHA4_SGIS 0x811E
#define            GL_QUAD_ALPHA8_SGIS 0x811F
#define        GL_QUAD_LUMINANCE4_SGIS 0x8120
#define        GL_QUAD_LUMINANCE8_SGIS 0x8121
#define        GL_QUAD_INTENSITY4_SGIS 0x8122
#define        GL_QUAD_INTENSITY8_SGIS 0x8123
#define    GL_DUAL_TEXTURE_SELECT_SGIS 0x8124
#define    GL_QUAD_TEXTURE_SELECT_SGIS 0x8125


%{
static char *proc_names[] =
{
#if !EXT_DEFINES_PROTO || !defined(GL_SGIS_texture_select)

#endif
	NULL
};

#define glInitTextureSelectSGIS() InitExtension("GL_SGIS_texture_select", proc_names)
%}

int glInitTextureSelectSGIS();
DOC(glInitTextureSelectSGIS, "glInitTextureSelectSGIS() -> bool")

%{
PyObject *__info()
{
	if (glInitTextureSelectSGIS())
	{
		PyObject *info = PyList_New(0);
		return info;
	}
	
	Py_INCREF(Py_None);
	return Py_None;
}
%}

PyObject *__info();

