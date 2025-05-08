#charset "utf-8"
#include <adv3.h>
#include <sv_se.h> 
#include "../../../code/tads3/tads3-unit-test/unittest.h"

versionInfo: GameID
  IFID = '38da5fdf-9077-4043-bfe1-14c83c087c81'
  name = 'tester för svenska översättningen av adv3'
  byline = 'by Tomas Öberg'
  htmlByline = 'by <a href="mailto:yourmail@address.com">Tomas Öberg</a>'
  version = '1'
  authorEmail = 'Tomas Öberg yourmail@address.com'
  desc = 'enhetstester'
  htmlDesc = 'enhetstester'
;
gameMain: GameMainDef
    initialPlayerChar = spelare2aPerspektiv
    usePastTense = true
;
spelare2aPerspektiv: Actor 'du' 'du'
  pcReferralPerson = SecondPerson
  isProperName = true
  isHim = true
;

// Test arrangements
apple: Thing 'äpple[-t]' 'äpple';

t: object 
  x = nil  
;
// Test Assertions
UnitTest 'initialize' run {
    //'äpple[-t]'
    //t.x = new Thing();
    //t.x.initializeThing();
    apple.initializeVocabWith(apple.vocabWords);

    // apple.weakTokens == nil
    // cmdDict
    cmdDict.forEachWord(function(obj, str, prop) {
      if(obj == apple) {
        "word: <<obj>>: <<str>>\n";
      }
    });

};