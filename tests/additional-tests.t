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

+ljus: LightSource 'ljus+et*ljus';
+ljuskrona: LightSource 'ljus+krona+n*ljuskronor';

// Båda dessa fungerar men inte den sista, fixa
//+gatulyktor: LightSource 'gatu+lyktor+na' isPlural = true;
+gatulyktor: LightSource 'gatu+lyktor+na*gatulyktor+na' isPlural = true;
//+gatulyktor: LightSource 'gatu+lyktor+na*gatulyktor' isPlural = true;

+virke: LightSource 'virke+t*virke' isMassNoun = true;
+olja: LightSource 'olja+n*olja' isMassNoun = true;



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

UnitTest 'Tänt ljus neutrum' run {
  assertThat(ljus.nameLit).isEqualTo('tänt ljus');
  assertThat(ljus.aNameLit()).isEqualTo('ett tänt ljus');
  assertThat(ljus.theNameLit).isEqualTo('det tända ljuset');
  assertThat(ljus.pluralNameLit).isEqualTo('tända ljus'); 

};

UnitTest 'Tänd ljuskrona utrum' run {
  assertThat(ljuskrona.nameLit).isEqualTo('tänd ljuskrona');
  assertThat(ljuskrona.aNameLit()).isEqualTo('en tänd ljuskrona');
  assertThat(ljuskrona.theNameLit).isEqualTo('den tända ljuskronan');
  assertThat(ljuskrona.pluralNameLit).isEqualTo('tända ljuskronor'); 
};

UnitTest 'Tända gatulyktor plural' run {
  assertThat(gatulyktor.nameLit).isEqualTo('tända gatulyktor');
  assertThat(gatulyktor.aNameLit()).isEqualTo('tända gatulyktor');
  assertThat(gatulyktor.theNameLit).isEqualTo('de tända gatulyktorna');
  assertThat(gatulyktor.pluralNameLit).isEqualTo('tända gatulyktor'); 
};


UnitTest 'Tändt virke/olja massnoun' run {
  assertThat(virke.nameLit).isEqualTo('tänt virke');
  assertThat(virke.aNameLit()).isEqualTo('tänt virke');
  assertThat(virke.theNameLit).isEqualTo('det tända virket');
  assertThat(virke.pluralNameLit).isEqualTo('tänt virke'); 

  assertThat(olja.nameLit).isEqualTo('tänd olja');
  assertThat(olja.aNameLit()).isEqualTo('tänd olja');
  assertThat(olja.theNameLit).isEqualTo('den tända oljan');
  assertThat(olja.pluralNameLit).isEqualTo('tänd olja'); 
};


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
