#charset "utf-8"
#include <adv3.h>
#include <sv_se.h> 
#include "testunit.h"

// TODO: testa aNameFrom
// TODO: testa theNameFrom
// TODO: getQuestionInf(which)
// TODO: testa av Resolver.resolvePronounAntecedent

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
++hatt: Wearable 'hatt+en/kläd+er'
  wornBy = spelare2aPerspektiv 
;

++jacka: Wearable 'jacka+n/kläd+er' 
  wornBy = spelare2aPerspektiv
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


TestUnit 'Tänt ljus neutrum' run {
  assertThat(ljus.nameLit).isEqualTo('tänt ljus');
  assertThat(ljus.aNameLit()).isEqualTo('ett tänt ljus');
  assertThat(ljus.theNameLit).isEqualTo('det tända ljuset');
  assertThat(ljus.pluralNameLit).isEqualTo('tända ljus'); 

  ljus.isLit = nil;
  assertThat(ljus.nameLit).isEqualTo('otänt ljus');
  assertThat(ljus.aNameLit()).isEqualTo('ett otänt ljus');
  assertThat(ljus.theNameLit).isEqualTo('det otända ljuset');
  assertThat(ljus.pluralNameLit).isEqualTo('otända ljus'); 
  olja.isLit = true;

};

TestUnit 'Tänd ljuskrona utrum' run {
  assertThat(ljuskrona.nameLit).isEqualTo('tänd ljuskrona');
  assertThat(ljuskrona.aNameLit()).isEqualTo('en tänd ljuskrona');
  assertThat(ljuskrona.theNameLit).isEqualTo('den tända ljuskronan');
  assertThat(ljuskrona.pluralNameLit).isEqualTo('tända ljuskronor'); 

  ljuskrona.isLit = nil;
  assertThat(ljuskrona.nameLit).isEqualTo('otänd ljuskrona');
  assertThat(ljuskrona.aNameLit()).isEqualTo('en otänd ljuskrona');
  assertThat(ljuskrona.theNameLit).isEqualTo('den otända ljuskronan');
  assertThat(ljuskrona.pluralNameLit).isEqualTo('otända ljuskronor'); 
  ljuskrona.isLit = true;
};

TestUnit 'Tända gatulyktor plural' run {
  assertThat(gatulyktor.nameLit).isEqualTo('tända gatulyktor');
  assertThat(gatulyktor.aNameLit()).isEqualTo('tända gatulyktor');
  assertThat(gatulyktor.theNameLit).isEqualTo('de tända gatulyktorna');
  assertThat(gatulyktor.pluralNameLit).isEqualTo('tända gatulyktor'); 

  gatulyktor.isLit = nil;
  assertThat(gatulyktor.nameLit).isEqualTo('otända gatulyktor');
  assertThat(gatulyktor.aNameLit()).isEqualTo('otända gatulyktor');
  assertThat(gatulyktor.theNameLit).isEqualTo('de otända gatulyktorna');
  assertThat(gatulyktor.pluralNameLit).isEqualTo('otända gatulyktor'); 
  gatulyktor.isLit = true;

};


TestUnit 'Tänt virke/tänd olja (massnoun)' run {
  assertThat(virke.nameLit).isEqualTo('tänt virke');
  assertThat(virke.aNameLit()).isEqualTo('tänt virke');
  assertThat(virke.theNameLit).isEqualTo('det tända virket');
  assertThat(virke.pluralNameLit).isEqualTo('tänt virke'); 

  assertThat(olja.nameLit).isEqualTo('tänd olja');
  assertThat(olja.aNameLit()).isEqualTo('tänd olja');
  assertThat(olja.theNameLit).isEqualTo('den tända oljan');
  assertThat(olja.pluralNameLit).isEqualTo('tänd olja'); 

  olja.isLit = nil;

  assertThat(olja.nameLit).isEqualTo('otänd olja');
  assertThat(olja.aNameLit()).isEqualTo('otänd olja');
  assertThat(olja.theNameLit).isEqualTo('den otända oljan');
  assertThat(olja.pluralNameLit).isEqualTo('otänd olja'); 
  olja.isLit = true;

};

TestUnit 'spellIntOrdinalExt' run {
  [ 1 -> 'första', 2 -> 'andra', 3 -> 'tredje', 4 -> 'fjärde', 5 -> 'femte', 
    6 -> 'sjätte', 7 -> 'sjunde', 8 -> 'åttonde', 9 -> 'nionde', 10 -> 'tionde', 
    11 -> 'elfte', 12 -> 'tolfte', 13 -> 'trettonde', 14 -> 'fjortonde', 15 -> 'femtonde', 
    16 -> 'sextonde', 17 -> 'sjuttonde', 18 -> 'artonde', 19 -> 'nittonde', 
 
    20 -> 'tjugonde', 21 -> 'tjugoförsta',  22 -> 'tjugoandra',23 -> 'tjugotredje',24 -> 'tjugofjärde',
    25 -> 'tjugofemte', 26 -> 'tjugosjätte', 27 -> 'tjugosjunde', 28 -> 'tjugoåttonde', 29 -> 'tjugonionde',
    30 -> 'trettionde', 31 -> 'trettioförsta', 32 -> 'trettioandra',
    40 -> 'fyrtionde',
    50 -> 'femtionde',
    60 -> 'sextionde',
    70 -> 'sjuttionde',
    80 -> 'åttionde',
    90 -> 'nittionde',
    100 -> 'etthundrade', 
    1000 -> 'etttusende', 
    10000 -> 'tiotusende', 
    100000 -> 'etthundratusende', 
    1000000 -> 'enmiljonte',
    1111111 -> 'enmiljonetthundraelvatusenetthundraelfte' // Svenskan är galen på sammansättningar!
  ].forEachAssoc(function(n, expected) {
    local x = spellIntOrdinalExt(n, SpellIntTeenHundreds & SpellIntAndTens & SpellIntCommas);
    //tadsSay('<<x>>\n');
    assertThat(x).isEqualTo(expected);

  });
};


TestUnit 'LiteralTAction.getOtherMessageObjectPronoun' run {
  local a = LiteralTAction.createActionInstance();
  local x = a.getOtherMessageObjectPronoun(DirectObject);
  assertThat(x).isEqualTo('det');
};


TestUnit 'cmdTokenizer.buildOrigText' run {
  assertThat(cmdTokenizer.buildOrigText(cmdTokenizer.tokenize('tjugo -  ett'))).isEqualTo('tjugo-ett');
};

TestUnit 'splitWithDelimiterPattern' run {
    local result = splitWithDelimiterPattern('met|spö+et');
    assertThat(result[1]).isEqualTo(['met', '|']);
    assertThat(result[2]).isEqualTo(['spö', '+']);
    assertThat(result[3]).isEqualTo(['et', nil]);
};

TestUnit 'splitWithDelimiterPattern' run {
    local result = splitWithDelimiterPattern('ljus+krona+n');
    //tadsSay(result);
    assertThat(result[1]).isEqualTo(['ljus', '+']);
    assertThat(result[2]).isEqualTo(['krona', '+']);
    assertThat(result[3]).isEqualTo(['n', nil]);
};
