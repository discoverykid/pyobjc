#!/usr/bin/env python
#
#
# Read the file created by extract_byref_signatures.py and define signature
# overrides for those entries where a user has added more precise signatures.
#
# The overrides are used by the runtime and allow us to correctly pass 
# pass-by-reference parameters to the objective-C runtime.
#
import sys

if len(sys.argv) != 3:
    print 'Usage: create_byref_module.py module.byref module.py'
    sys.exit(1)

fp_in = file(sys.argv[1])
fp_out = file(sys.argv[2], 'w')

fp_out.write("""
#
# This file is generated by 'create_byref_module.py'. Do not edit.
#
# Generated from '%s'.
#
#
from objc import setSignatureForSelector

"""%sys.argv[1])

for ln in fp_in:
    cls, selector, real_sign, repl_sign = ln.strip().split(ln[0])[1:]
    if not repl_sign:
        continue
    if repl_sign.startswith('%'):
        continue
    fp_out.write('setSignatureForSelector("%s", "%s", "%s")\n'%(
            cls, selector, repl_sign))
