#charset "utf-8"
#include <adv3.h>
#include <sv_se.h> 
#include "../../../code/tads3/tads3-unit-test/unittest.h"

// TODO: testa aNameFrom
// TODO: testa theNameFrom
// TODO: getQuestionInf(which)


versionInfo: GameID
  IFID = '38da5fdf-9077-4043-bfe1-14c83c087c81'
  name = 'Tester för svenska översättningen av adv3'
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

lab: Room 'labbet' 'labbet';
+spelare2aPerspektiv: Actor 'du' 'du'
  pcReferralPerson = SecondPerson
  isProperName = true
  isHim = true
;

+tingest: Thing 'tingest+en';
+skapet: Thing 'skåp+et';

#define __DEBUG

modify testRunner 
  verboseAboutSuccessfulTests = nil // Visa inte varje testutfall om det är OK
;

modify Thing
  construct() {  
    // For the tests that follows the constructor is disabled, so 
    // the behavior of initializeVocabWith is easier to test
   }
;

/*
UnitTest 'LiteralTAction.getOtherMessageObjectPronoun(which)' run {
  gAction = TurnToAction.createActionInstance();
  gAction.setCurrentObjects([tingest]);
  gAction.setActors([gActor]);
  setPlayer(spelare2aPerspektiv);
  assertThat(gAction.getOtherMessageObjectPronoun(DirectObject)).contains('det');
  assertThat(gAction.getQuestionInf(DirectObject)).contains('vrida');
};
*/
