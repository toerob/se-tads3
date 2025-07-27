#charset "us-ascii"
#include <tads.h>

TestUnit template 'name';

class BeforeEach: object
    group = nil
    run() {
        throw new Exception('BeforeEach each missing implementation');
    }
;

class AfterEach: object
    group = nil
    run() {
        throw new Exception('AfterEach each missing implementation');
    }
;


class TestUnit: object
    group = nil
    skip = nil
    only = nil
    run() {
        throw new Exception('Test missing implementation');
    }
;

function assertEquals(expected, receivedValue) {
    if(expected != receivedValue) {
        reportFailure(expected, receivedValue);
        tadsSay('\bassertEquals *failed* \nreceived: <font color=red>[<<receivedValue>>]</font>\nexpected: [<<expected>>]\b');
        throw new RuntimeError('\bassertEquals *failed* \nreceived: [<<receivedValue>>]\nexpected: [<<expected>>]\b');
    }
}

function assertThat(expressionOrValue) {
    return new Assertions().assertThatValueOrExpression(expressionOrValue);
}

class Assertions: object
    receivedValue = nil
    assertThatValueOrExpression(receivedValue) {
        self.receivedValue = dataTypeXlat(receivedValue) == TypeFuncPtr? receivedValue() : receivedValue;
        //tadsSay('\n*<<receivedValue>>*\n');
        return self;
    }

    /**
     * strings starts with ...
     */
    startsWith(expectedValue) {
        if(!self.receivedValue.startsWith(expectedValue)) {
            reportFailure(expectedValue, receivedValue, ['START-WITH ASSERTION FAILED', 'RECEIVED STRING', '\ \ \ SHOULD START']);
        }
        return self;
    }
    /**
     * Contains a substring ...
     */
    contains(expectedValue) {
        if(!receivedValue.find(expectedValue)) {
            reportFailure(expectedValue, receivedValue, ['CONTAINS ASSERTION FAILED', 'RECEIVED STRING', '\ SHOULD CONTAIN']);
        }
        return self;
    }

    isEqualTo(expectedValue) {
        local expected = dataTypeXlat(expectedValue) == TypeFuncPtr? expectedValue() : expectedValue;
        if(self.receivedValue != expected) {
            reportFailure(expected,receivedValue);
        }
        return self;
    }
    is(expectedValue) {
        local expected = dataTypeXlat(expectedValue) == TypeFuncPtr? expectedValue() : expectedValue;
        if(self.receivedValue != expected) {
            reportFailure(expected,receivedValue);
        }
        return self;
    }
    isTrue() {
        if(receivedValue != true) {
            reportFailure(true, receivedValue, ['TRUE ASSERTION FAILED', 'RECEIVED', 'NOT TRUE']);
        }
        return self;
    }
    isNil() {
        if(receivedValue != nil) {
            reportFailure(nil, receivedValue, ['NIL ASSERTION FAILED', '\ RECEIVED', 'NOT FALSE']);
        }
        return self;
    }
    isNotNil() {
        if(receivedValue == nil) {
            reportFailure(nil, receivedValue, ['NON-NIL ASSERTION FAILED', '\ \ \ \ \ RECEIVED', 'NOT-FALSE/TRUE']);
        }
        return self;
    }
;

function reportFailure(expected, receivedValue, assertionMsgs=['ASSERTION FAILED', 'RECEIVED', 'EXPECTED']) {
    divider('-');
    local stringLengths = dataTypeXlat(receivedValue) == TypeSString? '(expected/received string lengths: <<expected.length>>/<<receivedValue.length>>)':'';
    local msg = '\n<font color=red><<assertionMsgs[1]>></font> \n<<assertionMsgs[2]>>: <font color=red>[<<receivedValue>>]</font>\n<<assertionMsgs[3]>>: <font color=green>[<<expected>>] <<stringLengths>></font>\b';
    tadsSay(msg);
    throw new RuntimeError(msg);
}

function divider(ch?) {
    ch = (ch == nil)? '=' : ch;
    tadsSay('\n<<makeString(ch, 64)>>\n');
}



testRunner: InitObject
    currentTest = nil
    succeeded = 0
    failed = 0
    pauseWhenDone = nil
    quitWhenDone = true
    verboseAboutSuccessfulTests = true
    execute() {
        try {
            beforeAll();
            //"Test runner starting\n";
            local beforeEachCollection = [];
            local testCollection = [];
            local afterEachCollection = [];

            forEachInstance(BeforeEach, {pt: beforeEachCollection += pt });
            forEachInstance(TestUnit, {test:testCollection += test });
            forEachInstance(AfterEach, {pt: afterEachCollection += pt });

            testCollection = testCollection.subset({t: !t.skip});
            local onlyOneTest = testCollection.subset({t: t.only == true });


            if(onlyOneTest.length>0) {
                tadsSay('\nTesting only:\n');
                runCollection(beforeEachCollection, onlyOneTest, afterEachCollection);
                return;
            } 

            tadsSay('\nTotal tests to run: <<testCollection.length>>\n');
            divider();
            runCollection(beforeEachCollection, testCollection, afterEachCollection);
            afterAll();
        } catch(Exception e) {
            failed++;
            tadsSay('\ \ <font color=red><<currentTest.name>>  -- ** TEST FAILED **</font>\n');
            tadsSay('\ \ [<<e>>: <<e.exceptionMessage>>]\n');

            e.displayException();
        } finally {
            //divider();
            tadsSay('\bAll tests have run: \n');
            divider('*');            
            tadsSay('* succeeded: \t <<succeeded>>\n');
            tadsSay('* failed: \t\t <<failed>>\n');
            divider('*');
            if(pauseWhenDone) {
                tadsSay('\b[Press any key to continue]\b');
                yesOrNo();
            }
            if(quitWhenDone) {
                throw new Exception('Tests completed');
            }

        }
    }
    beforeAll() {}
    afterAll() {}

    counter = static 0
    runTest(test) {
        currentTest = test;
        try {
            currentTest.run(); 
        } catch(Exception e) {
            throw e;
        }
        succeeded++;
        local currentTestName = currentTest.name == nil ? currentTest : currentTest.name;
        if(verboseAboutSuccessfulTests) {
            tadsSay('\n\ \ <font color=green>[OK] Test <<++counter>>: <<currentTestName>></font>\n');
        }
    }
    runCollection(beforeEachCollection, testCollection, afterEachCollection) {
        testCollection.forEach(function(test) {
            beforeEachCollection.subset({z: z.group == test.group}).forEach({pt: pt.run()});
            runTest(test);
            afterEachCollection.subset({z: z.group == test.group}).forEach({pt: pt.run()});
        });
    }
;

