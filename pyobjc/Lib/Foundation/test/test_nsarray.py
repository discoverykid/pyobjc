import unittest
import objc

from Foundation import *

class TestNSArrayInteraction( unittest.TestCase ):
    def testRepeatedAllocInit( self ):
        for i in range(1,1000):
            a = NSArray.alloc().init()

    def testIndices( self ):
        x = NSArray.arrayWithArray_( ["foo", "bar", "baz"] )

        self.assertEquals( x.indexOfObject_("bar"), 1 )

        self.assertRaises( IndexError, x.objectAtIndex_, 100)

    def testContains( self ):
        x = NSArray.arrayWithArray_( ["foo", "bar", "baz"] )
        self.assertEquals( x.count(), 3 )
        self.assertEquals( len(x), 3 )

        self.assert_( x.containsObject_("foo") )
        self.assert_( not x.containsObject_("dumbledorf") )

        self.assert_( "foo" in x )
        self.assert_( not "dumbledorf" in x )

    def testIn( self ):
        x = NSMutableArray.array()
        for i in range(0, 100):
            x.addObject_(i)

        y = []
        for i in x:
            y.append( i )

        z = []
        for i in range(0, 100):
            z.append( i )

        self.assertEquals(x, y)
        self.assertEquals(x, z)
        self.assertEquals(y, z)

        for i in range(0, 100):
            self.assert_( i in x )

        self.assert_( 101 not in x )
        self.assert_( None not in x )
        self.assert_( "foo bar" not in x )

    def assertSlicesEqual(self,  x, y, z):
        self.assertEquals( x, x[:] )
        self.assertEquals( y, y[:] )
        self.assertEquals( z, z[:] )
        
        self.assertEquals( x[25:75], y[25:75] )
        self.assertEquals( x[25:75], z[25:75] )
        self.assertEquals( y[25:75], z[25:75] )

        self.assertEquals( x[:15], y[:15] )
        self.assertEquals( x[:15], z[:15] )
        self.assertEquals( y[:15], z[:15] )

        self.assertEquals( x[15:], y[15:] )
        self.assertEquals( x[15:], z[15:] )
        self.assertEquals( y[15:], z[15:] )

        self.assertEquals( x[-15:], y[-15:] )
        self.assertEquals( x[-15:], z[-15:] )
        self.assertEquals( y[-15:], z[-15:] )

        self.assertEquals( x[-15:30], y[-15:30] )
        self.assertEquals( x[-15:30], z[-15:30] )
        self.assertEquals( y[-15:30], z[-15:30] )

        self.assertEquals( x[-15:-5], y[-15:-5] )
        self.assertEquals( x[-15:-5], z[-15:-5] )
        self.assertEquals( y[-15:-5], z[-15:-5] )

    def testSlice( self ):
        x = NSMutableArray.array()
        for i in range(0, 100):
            x.addObject_(i)

        y = []
        for i in x:
            y.append( i )

        z = []
        for i in range(0, 100):
            z.append( i )

        self.assertSlicesEqual(x, y, z)

        k = range(300, 50)
        x[20:30] = k
        y[20:30] = k
        z[20:30] = k

        self.assertSlicesEqual(x, y, z)

        # Note that x[1] = x works in python, but not for a bridged NS*Array*.
        # Not sure if there is anything we can do about that.
        x[1] = x[:]
        y[1] = y[:]
        z[1] = z[:]

        self.assertSlicesEqual(x, y, z)

        del x[-15:-5]
        del y[-15:-5]
        del z[-15:-5]

        self.assertSlicesEqual(x, y, z)


def suite():
    suite = unittest.TestSuite()
    suite.addTest( unittest.makeSuite( TestNSArrayInteraction ) )
    return suite

if __name__ == '__main__':
    unittest.main( )