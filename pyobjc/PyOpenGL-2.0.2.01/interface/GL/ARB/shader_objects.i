/*
# AUTOGENERATED DO NOT EDIT

# If you edit this file, delete the AUTOGENERATED line to prevent re-generation
# BUILD api_versions [0x001]
*/

%module shader_objects

#define __version__ "$Revision: 1.1.2.1 $"
#define __date__ "$Date: 2004/11/15 07:38:07 $"
#define __api_version__ API_VERSION
#define __author__ "PyOpenGL Developers <pyopengl-devel@lists.sourceforge.net>"
#define __doc__ ""

%{
/**
 *
 * GL.ARB.shader_objects Module for PyOpenGL
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

#if !EXT_DEFINES_PROTO || !defined(GL_ARB_shader_objects)
DECLARE_VOID_EXT(glDeleteObjectARB, (GLhandleARB obj), (obj))
DECLARE_EXT(glGetHandleARB, GLhandleARB, 0, (GLenum pname), (pname))
DECLARE_VOID_EXT(glDetachObjectARB, (GLhandleARB containerObj, GLhandleARB attachedObj), (containerObj, attachedObj))
DECLARE_EXT(glCreateShaderObjectARB, GLhandleARB, 0, (GLenum shaderType), (shaderType))
DECLARE_VOID_EXT(glShaderSourceARB, (GLhandleARB shaderObj, GLsizei count, const GLcharARB* *string, const GLint *length), (shaderObj, count, string, length))
DECLARE_VOID_EXT(glCompileShaderARB, (GLhandleARB shaderObj), (shaderObj))
DECLARE_EXT(glCreateProgramObjectARB, GLhandleARB, 0, (), ())
DECLARE_VOID_EXT(glAttachObjectARB, (GLhandleARB containerObj, GLhandleARB obj), (containerObj, obj))
DECLARE_VOID_EXT(glLinkProgramARB, (GLhandleARB programObj), (programObj))
DECLARE_VOID_EXT(glUseProgramObjectARB, (GLhandleARB programObj), (programObj))
DECLARE_VOID_EXT(glValidateProgramARB, (GLhandleARB programObj), (programObj))
DECLARE_VOID_EXT(glUniform1fARB, (GLint location, GLfloat v0), (location, v0))
DECLARE_VOID_EXT(glUniform2fARB, (GLint location, GLfloat v0, GLfloat v1), (location, v0, v1))
DECLARE_VOID_EXT(glUniform3fARB, (GLint location, GLfloat v0, GLfloat v1, GLfloat v2), (location, v0, v1, v2))
DECLARE_VOID_EXT(glUniform4fARB, (GLint location, GLfloat v0, GLfloat v1, GLfloat v2, GLfloat v3), (location, v0, v1, v2, v3))
DECLARE_VOID_EXT(glUniform1iARB, (GLint location, GLint v0), (location, v0))
DECLARE_VOID_EXT(glUniform2iARB, (GLint location, GLint v0, GLint v1), (location, v0, v1))
DECLARE_VOID_EXT(glUniform3iARB, (GLint location, GLint v0, GLint v1, GLint v2), (location, v0, v1, v2))
DECLARE_VOID_EXT(glUniform4iARB, (GLint location, GLint v0, GLint v1, GLint v2, GLint v3), (location, v0, v1, v2, v3))
DECLARE_VOID_EXT(glUniform1fvARB, (GLint location, GLsizei count, const GLfloat *value), (location, count, value))
DECLARE_VOID_EXT(glUniform2fvARB, (GLint location, GLsizei count, const GLfloat *value), (location, count, value))
DECLARE_VOID_EXT(glUniform3fvARB, (GLint location, GLsizei count, const GLfloat *value), (location, count, value))
DECLARE_VOID_EXT(glUniform4fvARB, (GLint location, GLsizei count, const GLfloat *value), (location, count, value))
DECLARE_VOID_EXT(glUniform1ivARB, (GLint location, GLsizei count, const GLint *value), (location, count, value))
DECLARE_VOID_EXT(glUniform2ivARB, (GLint location, GLsizei count, const GLint *value), (location, count, value))
DECLARE_VOID_EXT(glUniform3ivARB, (GLint location, GLsizei count, const GLint *value), (location, count, value))
DECLARE_VOID_EXT(glUniform4ivARB, (GLint location, GLsizei count, const GLint *value), (location, count, value))
DECLARE_VOID_EXT(glUniformMatrix2fvARB, (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value), (location, count, transpose, value))
DECLARE_VOID_EXT(glUniformMatrix3fvARB, (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value), (location, count, transpose, value))
DECLARE_VOID_EXT(glUniformMatrix4fvARB, (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value), (location, count, transpose, value))
DECLARE_VOID_EXT(glGetObjectParameterfvARB, (GLhandleARB obj, GLenum pname, GLfloat *params), (obj, pname, params))
DECLARE_VOID_EXT(glGetObjectParameterivARB, (GLhandleARB obj, GLenum pname, GLint *params), (obj, pname, params))
DECLARE_VOID_EXT(glGetInfoLogARB, (GLhandleARB obj, GLsizei maxLength, GLsizei *length, GLcharARB *infoLog), (obj, maxLength, length, infoLog))
DECLARE_VOID_EXT(glGetAttachedObjectsARB, (GLhandleARB containerObj, GLsizei maxCount, GLsizei *count, GLhandleARB *obj), (containerObj, maxCount, count, obj))
DECLARE_EXT(glGetUniformLocationARB, GLint, 0, (GLhandleARB programObj, const GLcharARB *name), (programObj, name))
DECLARE_VOID_EXT(glGetActiveUniformARB, (GLhandleARB programObj, GLuint index, GLsizei maxLength, GLsizei *length, GLint *size, GLenum *type, GLcharARB *name), (programObj, index, maxLength, length, size, type, name))
DECLARE_VOID_EXT(glGetUniformfvARB, (GLhandleARB programObj, GLint location, GLfloat *params), (programObj, location, params))
DECLARE_VOID_EXT(glGetUniformivARB, (GLhandleARB programObj, GLint location, GLint *params), (programObj, location, params))
DECLARE_VOID_EXT(glGetShaderSourceARB, (GLhandleARB obj, GLsizei maxLength, GLsizei *length, GLcharARB *source), (obj, maxLength, length, source))
#endif
%}

/* FUNCTION DECLARATIONS */
typedef char GLcharARB;
typedef unsigned int GLhandleARB;
void glDeleteObjectARB(GLhandleARB obj);
DOC(glDeleteObjectARB, "glDeleteObjectARB(obj)")
GLhandleARB glGetHandleARB(GLenum pname);
DOC(glGetHandleARB, "glGetHandleARB(pname)")
void glDetachObjectARB(GLhandleARB containerObj, GLhandleARB attachedObj);
DOC(glDetachObjectARB, "glDetachObjectARB(containerObj, attachedObj)")
GLhandleARB glCreateShaderObjectARB(GLenum shaderType);
DOC(glCreateShaderObjectARB, "glCreateShaderObjectARB(shaderType)")
void glShaderSourceARB(GLhandleARB shaderObj, GLsizei count, const GLcharARB* *string, const GLint *length);
DOC(glShaderSourceARB, "glShaderSourceARB(shaderObj, count, string, length)")
void glCompileShaderARB(GLhandleARB shaderObj);
DOC(glCompileShaderARB, "glCompileShaderARB(shaderObj)")
GLhandleARB glCreateProgramObjectARB();
DOC(glCreateProgramObjectARB, "glCreateProgramObjectARB()")
void glAttachObjectARB(GLhandleARB containerObj, GLhandleARB obj);
DOC(glAttachObjectARB, "glAttachObjectARB(containerObj, obj)")
void glLinkProgramARB(GLhandleARB programObj);
DOC(glLinkProgramARB, "glLinkProgramARB(programObj)")
void glUseProgramObjectARB(GLhandleARB programObj);
DOC(glUseProgramObjectARB, "glUseProgramObjectARB(programObj)")
void glValidateProgramARB(GLhandleARB programObj);
DOC(glValidateProgramARB, "glValidateProgramARB(programObj)")
void glUniform1fARB(GLint location, GLfloat v0);
DOC(glUniform1fARB, "glUniform1fARB(location, v0)")
void glUniform2fARB(GLint location, GLfloat v0, GLfloat v1);
DOC(glUniform2fARB, "glUniform2fARB(location, v0, v1)")
void glUniform3fARB(GLint location, GLfloat v0, GLfloat v1, GLfloat v2);
DOC(glUniform3fARB, "glUniform3fARB(location, v0, v1, v2)")
void glUniform4fARB(GLint location, GLfloat v0, GLfloat v1, GLfloat v2, GLfloat v3);
DOC(glUniform4fARB, "glUniform4fARB(location, v0, v1, v2, v3)")
void glUniform1iARB(GLint location, GLint v0);
DOC(glUniform1iARB, "glUniform1iARB(location, v0)")
void glUniform2iARB(GLint location, GLint v0, GLint v1);
DOC(glUniform2iARB, "glUniform2iARB(location, v0, v1)")
void glUniform3iARB(GLint location, GLint v0, GLint v1, GLint v2);
DOC(glUniform3iARB, "glUniform3iARB(location, v0, v1, v2)")
void glUniform4iARB(GLint location, GLint v0, GLint v1, GLint v2, GLint v3);
DOC(glUniform4iARB, "glUniform4iARB(location, v0, v1, v2, v3)")
void glUniform1fvARB(GLint location, GLsizei count, const GLfloat *value);
DOC(glUniform1fvARB, "glUniform1fvARB(location, count, value)")
void glUniform2fvARB(GLint location, GLsizei count, const GLfloat *value);
DOC(glUniform2fvARB, "glUniform2fvARB(location, count, value)")
void glUniform3fvARB(GLint location, GLsizei count, const GLfloat *value);
DOC(glUniform3fvARB, "glUniform3fvARB(location, count, value)")
void glUniform4fvARB(GLint location, GLsizei count, const GLfloat *value);
DOC(glUniform4fvARB, "glUniform4fvARB(location, count, value)")
void glUniform1ivARB(GLint location, GLsizei count, const GLint *value);
DOC(glUniform1ivARB, "glUniform1ivARB(location, count, value)")
void glUniform2ivARB(GLint location, GLsizei count, const GLint *value);
DOC(glUniform2ivARB, "glUniform2ivARB(location, count, value)")
void glUniform3ivARB(GLint location, GLsizei count, const GLint *value);
DOC(glUniform3ivARB, "glUniform3ivARB(location, count, value)")
void glUniform4ivARB(GLint location, GLsizei count, const GLint *value);
DOC(glUniform4ivARB, "glUniform4ivARB(location, count, value)")
void glUniformMatrix2fvARB(GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
DOC(glUniformMatrix2fvARB, "glUniformMatrix2fvARB(location, count, transpose, value)")
void glUniformMatrix3fvARB(GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
DOC(glUniformMatrix3fvARB, "glUniformMatrix3fvARB(location, count, transpose, value)")
void glUniformMatrix4fvARB(GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
DOC(glUniformMatrix4fvARB, "glUniformMatrix4fvARB(location, count, transpose, value)")
void glGetObjectParameterfvARB(GLhandleARB obj, GLenum pname, GLfloat *params);
DOC(glGetObjectParameterfvARB, "glGetObjectParameterfvARB(obj, pname, params)")
void glGetObjectParameterivARB(GLhandleARB obj, GLenum pname, GLint *params);
DOC(glGetObjectParameterivARB, "glGetObjectParameterivARB(obj, pname, params)")
void glGetInfoLogARB(GLhandleARB obj, GLsizei maxLength, GLsizei *length, GLcharARB *infoLog);
DOC(glGetInfoLogARB, "glGetInfoLogARB(obj, maxLength, length, infoLog)")
void glGetAttachedObjectsARB(GLhandleARB containerObj, GLsizei maxCount, GLsizei *count, GLhandleARB *obj);
DOC(glGetAttachedObjectsARB, "glGetAttachedObjectsARB(containerObj, maxCount, count, obj)")
GLint glGetUniformLocationARB(GLhandleARB programObj, const GLcharARB *name);
DOC(glGetUniformLocationARB, "glGetUniformLocationARB(programObj, name)")
void glGetActiveUniformARB(GLhandleARB programObj, GLuint index, GLsizei maxLength, GLsizei *length, GLint *size, GLenum *type, GLcharARB *name);
DOC(glGetActiveUniformARB, "glGetActiveUniformARB(programObj, index, maxLength, length, size, type, name)")
void glGetUniformfvARB(GLhandleARB programObj, GLint location, GLfloat *params);
DOC(glGetUniformfvARB, "glGetUniformfvARB(programObj, location, params)")
void glGetUniformivARB(GLhandleARB programObj, GLint location, GLint *params);
DOC(glGetUniformivARB, "glGetUniformivARB(programObj, location, params)")
void glGetShaderSourceARB(GLhandleARB obj, GLsizei maxLength, GLsizei *length, GLcharARB *source);
DOC(glGetShaderSourceARB, "glGetShaderSourceARB(obj, maxLength, length, source)")

/* CONSTANT DECLARATIONS */
#define          GL_PROGRAM_OBJECT_ARB 0x8B40
#define           GL_SHADER_OBJECT_ARB 0x8B48
#define             GL_OBJECT_TYPE_ARB 0x8B4E
#define          GL_OBJECT_SUBTYPE_ARB 0x8B4F
#define              GL_FLOAT_VEC2_ARB 0x8B50
#define              GL_FLOAT_VEC3_ARB 0x8B51
#define              GL_FLOAT_VEC4_ARB 0x8B52
#define                GL_INT_VEC2_ARB 0x8B53
#define                GL_INT_VEC3_ARB 0x8B54
#define                GL_INT_VEC4_ARB 0x8B55
#define                    GL_BOOL_ARB 0x8B56
#define               GL_BOOL_VEC2_ARB 0x8B57
#define               GL_BOOL_VEC3_ARB 0x8B58
#define               GL_BOOL_VEC4_ARB 0x8B59
#define              GL_FLOAT_MAT2_ARB 0x8B5A
#define              GL_FLOAT_MAT3_ARB 0x8B5B
#define              GL_FLOAT_MAT4_ARB 0x8B5C
#define              GL_SAMPLER_1D_ARB 0x8B5D
#define              GL_SAMPLER_2D_ARB 0x8B5E
#define              GL_SAMPLER_3D_ARB 0x8B5F
#define            GL_SAMPLER_CUBE_ARB 0x8B60
#define       GL_SAMPLER_1D_SHADOW_ARB 0x8B61
#define       GL_SAMPLER_2D_SHADOW_ARB 0x8B62
#define         GL_SAMPLER_2D_RECT_ARB 0x8B63
#define  GL_SAMPLER_2D_RECT_SHADOW_ARB 0x8B64
#define    GL_OBJECT_DELETE_STATUS_ARB 0x8B80
#define   GL_OBJECT_COMPILE_STATUS_ARB 0x8B81
#define      GL_OBJECT_LINK_STATUS_ARB 0x8B82
#define  GL_OBJECT_VALIDATE_STATUS_ARB 0x8B83
#define  GL_OBJECT_INFO_LOG_LENGTH_ARB 0x8B84
#define GL_OBJECT_ATTACHED_OBJECTS_ARB 0x8B85
#define  GL_OBJECT_ACTIVE_UNIFORMS_ARB 0x8B86
#define GL_OBJECT_ACTIVE_UNIFORM_MAX_LENGTH_ARB 0x8B87
#define GL_OBJECT_SHADER_SOURCE_LENGTH_ARB 0x8B88


%{
static char *proc_names[] =
{
#if !EXT_DEFINES_PROTO || !defined(GL_ARB_shader_objects)
"glDeleteObjectARB",
"glGetHandleARB",
"glDetachObjectARB",
"glCreateShaderObjectARB",
"glShaderSourceARB",
"glCompileShaderARB",
"glCreateProgramObjectARB",
"glAttachObjectARB",
"glLinkProgramARB",
"glUseProgramObjectARB",
"glValidateProgramARB",
"glUniform1fARB",
"glUniform2fARB",
"glUniform3fARB",
"glUniform4fARB",
"glUniform1iARB",
"glUniform2iARB",
"glUniform3iARB",
"glUniform4iARB",
"glUniform1fvARB",
"glUniform2fvARB",
"glUniform3fvARB",
"glUniform4fvARB",
"glUniform1ivARB",
"glUniform2ivARB",
"glUniform3ivARB",
"glUniform4ivARB",
"glUniformMatrix2fvARB",
"glUniformMatrix3fvARB",
"glUniformMatrix4fvARB",
"glGetObjectParameterfvARB",
"glGetObjectParameterivARB",
"glGetInfoLogARB",
"glGetAttachedObjectsARB",
"glGetUniformLocationARB",
"glGetActiveUniformARB",
"glGetUniformfvARB",
"glGetUniformivARB",
"glGetShaderSourceARB",
#endif
	NULL
};

#define glInitShaderObjectsARB() InitExtension("GL_ARB_shader_objects", proc_names)
%}

int glInitShaderObjectsARB();
DOC(glInitShaderObjectsARB, "glInitShaderObjectsARB() -> bool")

%{
PyObject *__info()
{
	if (glInitShaderObjectsARB())
	{
		PyObject *info = PyList_New(0);
		return info;
	}
	
	Py_INCREF(Py_None);
	return Py_None;
}
%}

PyObject *__info();

