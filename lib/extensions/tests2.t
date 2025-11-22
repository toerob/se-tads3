#charset "utf8" // OBS: första ändringen för att fungera med svenska

#ifdef ADV3LITE	//(Define in your makefile) todo: needs verbs to be rewritten
	#include <tads.h>
	#include <advlite.h>
#else
	#include <adv3.h>
	#include <sv_se.h>  // OBS: andra och sista ändringen för att fungera med svenska
#endif
#include <file.h>
#include <lookup.h>

/* TEST testname / LIST TESTS / LIST TESTS FULLY
NRT: modified to use TemporaryFile for scripts. Added optional location and testHolding properties
To use this extension, which was originally written by Jim Aikin, Ben Cressey and Eric Eve,
 define Test objects like so:

foo: Test
    testName = 'foo'
    location = livingRoom	//the player character will be moved to livingRoom before the test
    testList = [ 'x me', 'i' ]
;

bar: Test
    testName = 'bar'
    testList = [ 'look', 'listen' ]
;

//you can use the normal + notation to set the location automatically
randomRoom : Room
;

+fob: Test	//location = randomRoom
	testName = 'fob'
	testHolding = [ matches, bread ]	//these items will be moved into the player character's inventory before the test.
	testList = [ 'light fire', 'toast bread' ]
;

all: Test
    testName = 'all'
    testList =
    [
        'test foo',
        'test bar',
        'test fob'
    ]
;

The tests for this module are at the end. Define the symbol TEST_TESTS to enabled them.
*/
/*
Alternatively, you can include the following lines at the head of your file of test scripts:

Test template 'testName' [testList] @location? [testHolding]?;
Test template 'testName' [testList] [testHolding]? @location?;

...and then use the template structure to create your test objects more conveniently:
    
someTest: Test 'foo' ['x me', 'i'];
someTestInBedroom: Test 'bedroom' ['x bed', 'enter bed'] @Bedroom;
someTestWithMobile: Test 'mobile' ['x mobile', 'call bob'] [mobile_phone];

Unless you're planning to refer to the Test object in some other part of your code,
you can save a bit of typing by making it an anonymous object:
    
Test 'foo' ['x me', 'i'];

*/

class Test: object
	testName = 'nil'
	testList = [ 'z' ]
	location = nil
	testHolding = []
	//shared class object (nesting is okay because setScriptFile buffers and recurses)
	_testFile = static new WeakRefLookupTable(1,1)
	getFile()
	{
		local tempFile = _testFile[0];
		if (!tempFile)
		{
			tempFile = new TemporaryFile();
			_testFile[0] = tempFile;
		}					
		return tempFile;
	}
	getHolding()
	{
		testHolding.forEach({x: x.baseMoveInto(gActor)});
	}
	run()
	{
		"Testing sequence: \"<<testName>>\". ";
		local testFile = getFile();
		local out = File.openTextFile(testFile, FileAccessWrite);
		testList.forEach({x: out.writeFile('><<x>>\n')});
		out.closeFile();
		if (location)
			gActor.moveIntoForTravel(location);	//moveInto
		getHolding();
		setScriptFile(testFile);
		
	}
;

#ifdef __DEBUG

    /*
     *   The 'list tests' and 'list tests fully' commands can be used to list 
     *   your test scripts from within the running game.
     */
    
DefineSystemAction(ListTests)
    fully = nil
    execSystemAction
    {

        if(allTests.lst.length == 0)
        {
            reportFailure('No test scripts are defined. ');
            exit;
        }
       
        foreach(local testObj in allTests.lst)
        {
            "<<testObj.testName>>";
            if(gAction.fully)               
            {
                ": ";
                foreach(local txt in testObj.testList)
                    "<<txt>>/";
                if (testObj.location)
                	" in <<testObj.location.roomName>>";
                if (testObj.testHolding.length())
                {
                	" holding "; objectLister.showSimpleList(testObj.testHolding);
                }
            }
            "\n";
        }
    }
;

VerbRule(ListTests)
    ('list' | 'l') 'tests' (| 'fully' -> fully)
    : ListTestsAction
    verbPhrase = 'list/listing test scripts'
;

    /*
     *   The 'test X' command can be used with any Test object defined in the source code:
     */
DefineLiteralAction(Test)
   execAction()
   {
      local target = getLiteral().toLower();
      local script = allTests.valWhich({x: x.testName.toLower == target});
      if (script)
         script.run();
      else
         "Test sequence not found. ";
   }
;

VerbRule(Test)
   'test' singleLiteral
   : TestAction
   verbPhrase = 'test/testing (what)'
;

allTests: object
   lst()
   {
      if (lst_ == nil)
         initLst();
      return lst_;
   }

   initLst()
   {
      lst_ = new Vector(50);
      local obj = firstObj();
      while (obj != nil)
      {
         if(obj.ofKind(Test))
            lst_.append(obj);
         obj = nextObj(obj);
      }
      lst_ = lst_.toList();
   }

   valWhich(cond)
   {
      if (lst_ == nil)
         initLst();
      return lst_.valWhich(cond);
   }

   lst_ = nil
;

#ifdef TEST_TESTS
listing: Test
	testName = 'listing'
	testList = [ 'list tests', 'list tests fully' ]
;

test_testRoom : Room 'Test Test Room' "The test test room (only for testing). Mmm meaty chunks."
;
		
inLocation: Test
	testName = 'in'
	location = test_testRoom
	testList = [ 'look' ]
;

test_test_otherRoom : Room 'Test Other Room' "This is the other test room. Other tests happen here."
;

+test_testThing : Thing 'test thing' 'test test thing'
;
+plusLocation: Test
	testName = 'plus'
	testList = [ 'look' ]
;
holding: Test
	testName = 'holding'
	testHolding = [ test_testThing ]
	testList = [ 'inventory' ]
;
test_Test : Test	//test all
	testName = 'tests'
	testList = 
	[
		'test listing',
		'test in',
		'test holding',
		'test plus'
	]
;
#endif	//TEST_TESTS
#endif	// __DEBUG