# 
# This script generates part of the python-wrappers around Cocoa.
#
# This script is based on some (not to clever) regular expressions, and seems
# to work pretty well with the current version of the Cocoa headers.
#
# We recognize:
# - enum definitions
# - NSString constants (as 'extern NSString*' variables)
#
# TODO:
# - Generate stubs for function wrappers (but: will most likely need manual
#   work to get the actual function wrappers)
import enum_generator
import strconst_generator
import var_generator
import func_collector
import func_builder
import os

FRAMEWORKS="/System/Library/Frameworks"
FOUNDATION=os.path.join(FRAMEWORKS, "Foundation.framework")
APPKIT=os.path.join(FRAMEWORKS, "AppKit.framework")
FOUNDATION_HDRS=os.path.join(FOUNDATION, 'Headers')
APPKIT_HDRS=os.path.join(APPKIT, 'Headers')

enum_generator.generate(FOUNDATION_HDRS, '_Fnd_Enum.inc')
enum_generator.generate(APPKIT_HDRS, '_App_Enum.inc')

strconst_generator.generate(FOUNDATION_HDRS, '_Fnd_Str.inc')
strconst_generator.generate(APPKIT_HDRS, '_App_Str.inc')

FOUNDATION_PREFIX="FOUNDATION_EXPORT"
FOUNDATION_IGNORE_LIST=(
	# All have types that are not (yet) mapped to python
	'NSZeroPoint',
	'NSZeroSize',
	'NSZeroRect',
	"NSNonOwnedPointerHashCallBacks",
	"NSNonRetainedObjectHashCallBacks",
	"NSObjectHashCallBacks",
	"NSOwnedObjectIdentityHashCallBacks",
	"NSOwnedPointerHashCallBacks",
	"NSPointerToStructHashCallBacks",
	"NSIntMapKeyCallBacks",
	"NSNonOwnedPointerMapKeyCallBacks",
	"NSNonOwnedPointerOrNullMapKeyCallBacks",
	"NSNonRetainedObjectMapKeyCallBacks",
	"NSObjectMapKeyCallBacks",
	"NSOwnedPointerMapKeyCallBacks",
	"NSIntMapValueCallBacks", 
	"NSNonOwnedPointerMapValueCallBacks",
	"NSObjectMapValueCallBacks",
	"NSNonRetainedObjectMapValueCallBacks",
	"NSOwnedPointerMapValueCallBacks",
	"NSIntHashCallBacks",
)

var_generator.generate(FOUNDATION_HDRS, '_Fnd_Var.inc', FOUNDATION_PREFIX, FOUNDATION_IGNORE_LIST)

APPKIT_PREFIX="APPKIT_EXTERN"
APPKIT_IGNORE_LIST=(
	# First two have types that are not yet mapped
	'NSIconSize', 
	'NSTokenSize', 

	# NSApp is a 'real' variable, will probably add get/set functions
	'NSApp')

var_generator.generate(APPKIT_HDRS, '_App_Var.inc', APPKIT_PREFIX, APPKIT_IGNORE_LIST)

FOUNDATION_IGNORE_LIST=(
	# Private functions in NSException.h 
	'_NSAddHandler2',
	'_NSRemoveHandler2',
	'_NSExceptionObjectFromHandler2'
)
APPKIT_IGNORE_LIST=(
)
func_collector.generate(FOUNDATION_HDRS, 'Foundation.prototypes', 
	FOUNDATION_PREFIX, FOUNDATION_IGNORE_LIST)
func_collector.generate(APPKIT_HDRS, 'AppKit.prototypes', 
	APPKIT_PREFIX, APPKIT_IGNORE_LIST)

# Add easy to handle types in Foundation:
#func_builder.SIMPLE_TYPES['NSHashTable*'] = (
#	'\tresult = PyCObject_New(%(varname)s);\n\t if (result == NULL) return NULL;',
#	'O&',
#	'convert_NSHashtable, &%(varname)s',
#)

func_builder.INT_ALIASES.extend([
	'NSSearchPathDomainMask', 'NSCalculationError',
	'NSComparisonResult', 'NSInsertionPosition',
	'NSNotificationCoalescing', 'NSNotificationCoalescing',
	'NSRectEdge', 'NSRelativePosition',
	'NSRoundingMode', 'NSSaveOptions', 'NSSearchPathDirectory',
	'NSSearchPathDomainMask', 'NSTestComparisonOperation',
	'NSURLHandleStatus', 'NSWhoseSubelementIdentifier']
)
fd = file('_Fnd_Functions.inc', 'w')
structs = ['NSPoint', 'NSSize', 'NSRect', 'NSRange']
for s in structs:
	func_builder.SIMPLE_TYPES[s] = (
		'\tresult = ObjC_ObjCToPython(@encode(%s), (void*)&%%(varname)s); \n\tif (result == NULL) return NULL;'%s,
		'O&',
		'convert_%s, &%%(varname)s'%s
	)
	fd.write('''\
static inline int convert_%(type)s(PyObject* object, void* pvar)
{
	const char* errstr;

	errstr = ObjC_PythonToObjC(@encode(%(type)s), object, pvar);
	if (errstr) {
		PyErr_SetString(PyExc_TypeError, errstr);
		return 0;
	}
	return 1;
}
'''%{'type': s })


func_builder.process_list(fd , file('Foundation.prototypes'))
fd = None
for s in structs:
	del func_builder.SIMPLE_TYPES[s]

fd = file('_App_Functions.inc', 'w')
structs = ['NSAffineTransformStruct', 'NSRect', 'NSPoint']
for s in structs:
	func_builder.SIMPLE_TYPES[s] = (
		'\tresult = ObjC_ObjCToPython(@encode(%s), (void*)&%%(varname)s); \n\tif (result == NULL) return NULL;'%s,
		'O&',
		'convert_%s, &%%(varname)s'%s
	)
	fd.write('''\
static inline int convert_%(type)s(PyObject* object, void* pvar)
{
	const char* errstr;

	errstr = ObjC_PythonToObjC(@encode(%(type)s), object, pvar);
	if (errstr) {
		PyErr_SetString(PyExc_TypeError, errstr);
		return 0;
	}
	return 1;
}
'''%{'type': s })

func_builder.INT_ALIASES.extend([
	'NSApplicationTerminateReply', 'NSBackingStoreType',
	'NSBezelStyle', 'NSBezierPathElement',
	'NSBitmapImageFileType', 'NSBorderType', 'NSBoxType',
	'NSButtonType', 'NSCellAttribute', 'NSCellImagePosition',
	'NSCellStateValue', 'NSCellType', 'NSCompositingOperation',
	'NSControlSize', 'NSControlTint', 'NSDocumentChangeType',
	'NSDragOperation', 'NSDrawerState', 'NSEventType',
	'NSFocusRingPlacement', 'NSFontAction', 'NSFontTraitMask',
	'NSGlyph', 'NSGlyphInscription', 'NSGlyphLayoutMode',
	'NSGlyphRelation', 'NSGradientType', 'NSImageAlignment',
	'NSImageFrameStyle', 'NSImageInterpolation', 'NSImageScaling',
	'NSInterfaceStyle', 'NSLayoutDirection', 'NSLayoutStatus',
	'NSLineBreakMode', 'NSLineCapStyle', 'NSLineJoinStyle',
	'NSLineMovementDirection', 'NSLineSweepDirection',
	'NSMatrixMode', 'NSMultibyteGlyphPacking', 'NSOpenGLContextParameter',
	'NSOpenGLGlobalOption', 'NSOpenGLPixelFormatAttribute',
	'NSPopUpArrowPosition', 'NSPrinterTableStatus',
	'NSPrintingOrientation', 'NSPrintingPageOrder', 
	'NSPrintingPaginationMode', 'NSProgressIndicatorThickness',
	'NSQTMovieLoopMode', 'NSRequestUserAttentionType',
	'NSRulerOrientation', 'NSSaveOperationType',
	'NSScrollArrowPosition', 'NSScrollerArrow',
	'NSScrollerPart', 'NSSelectionAffinity',
	'NSSelectionDirection', 'NSSelectionGranularity',
	'NSTabState', 'NSTabViewState', 'NSTableViewDropOperation',
	'NSTextAlignment', 'NSTextTabType', 'NSTickMarkPosition',
	'NSTIFFCompression', 'NSTitlePosition', 'NSToolbarDisplayMode',
	'NSToolTipTag', 'NSTrackingRectTag', 'NSUsableScrollerParts',
	'NSWindingRule', 'NSWindowDepth', 'NSWindowOrderingMode',
])


func_builder.process_list(fd, file('AppKit.prototypes'))
for s in structs:
	del func_builder.SIMPLE_TYPES[s]