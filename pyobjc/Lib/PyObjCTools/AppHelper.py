"""AppKit helpers.

Exported functions:
* runEventLoop - run NSApplicationMain in a safer way
* endSheetMethod - set correct signature for NSSheet callbacks
"""

__all__ = ( 'runEventLoop', 'runConsoleEventLoop', 'endSheetMethod' )

from AppKit import NSApplicationMain, NSApp, NSRunAlertPanel
from Foundation import NSLog, NSRunLoop
import os
import sys
import traceback
import objc


def endSheetMethod(meth):
    """
    Return a selector that can be used as the delegate callback for
    sheet methods
    """
    return objc.selector(meth, signature='v@:@ii')



def unexpectedErrorAlertPanel():
    exceptionInfo = traceback.format_exception_only(
        *sys.exc_info()[:2])[0].strip()
    return NSRunAlertPanel("An unexpected error has occurred",
            "(%s)" % exceptionInfo,
            "Continue", "Quit", None)

def unexpectedErrorAlertPdb():
    import pdb
    traceback.print_exc()
    pdb.post_mortem(sys.exc_info()[2])
    return True

def machInterrupt(signum):
    app = NSApp()
    if app:
        app.terminate_(None)
    else:
        import os
        os._exit(1)

def installMachInterrupt():
    try:
        import signal
        from PyObjCTools import MachSignals
    except:
        return
    MachSignals.signal(signal.SIGINT, machInterrupt)

def runConsoleEventLoop(argv=None, installInterrupt=False):
    if argv is None:
        argv = sys.argv
    if installInterrupt:
        installMachInterrupt()
    NSRunLoop.currentRunLoop().run()

RAISETHESE = (SystemExit, MemoryError, KeyboardInterrupt)

def runEventLoop(argv=None, unexpectedErrorAlert=None, installInterrupt=False, pdb=None):
    """Run the event loop, ask the user if we should continue if an
    exception is caught. Use this function instead of NSApplicationMain().
    """
    if argv is None:
        argv = sys.argv

    if pdb is None:
        pdb = 'USE_PDB' in os.environ
    
    if unexpectedErrorAlert is None:
        if pdb:
            unexpectedErrorAlert = unexpectedErrorAlertPdb
        else:
            unexpectedErrorAlert = unexpectedErrorAlertPanel

    firstRun = True
    while True:
        try:
            if firstRun:
                firstRun = False
                if installInterrupt:
                    installMachInterrupt()
                NSApplicationMain(argv)
            else:
                NSApp().run()
        except RAISETHESE:
            traceback.print_exc()
            break
        except:
            if not unexpectedErrorAlert():
                NSLog("An exception has occured:")
                raise
            else:
                NSLog("An exception has occured:")
                traceback.print_exc()
        else:
            break
