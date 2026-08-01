#charset "utf-8"
#include <adv3.h>
#include <sv_se.h> 
#include "testunit.h"

// TODO: testa aNameFrom
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

lab: Room 'labbet' 'labbet'
  east = korridor
;
korridor: Room 'korridor' 'korridor';

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

// Objekt med +-notation — definiteForm sätts automatiskt av parsern
+stol: Thing 'stol+en';               // utrum singular
+bord: Thing 'bord+et' isNeuter = true;  // neutrum singular
+stolar: Thing 'stol+ar+na' isPlural = true;  // plural

// Objekt UTAN +-notation — definiteForm förblir nil, testar reservfall
+kattFallback: Thing 'katt' 'katt';
+husFallback: Thing 'hus' 'hus' isNeuter = true;
+katternFallback: Thing 'katter' 'katter' isPlural = true;
+bobProper: Thing 'bob' 'bob' isProperName = true isQualifiedName = true;

+ljus: LightSource 'ljus+et*ljus';
+ljuskrona: LightSource 'ljus+krona+n*ljuskronor';

// Båda dessa fungerar men inte den sista, fixa
//+gatulyktor: LightSource 'gatu+lyktor+na' isPlural = true;
+gatulyktor: LightSource 'gatu+lyktor+na*gatulyktor+na' isPlural = true;
//+gatulyktor: LightSource 'gatu+lyktor+na*gatulyktor' isPlural = true;

+virke: LightSource 'virke+t*virke' isMassNoun = true;
+olja: LightSource 'olja+n*olja' isMassNoun = true;


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



TestUnit 'objectLister.makeSimpleList' run {
    local result = objectLister.makeSimpleList([ljuskrona, ljus, hatt, jacka, tingest, skapet]);
    //tadsSay(result);
    assertThat(result).isEqualTo('en ljuskrona (avger ljus), ett ljus, en hatt (påklädd), en jacka (påklädd), en tingest, och ett skåp');
};

TestUnit 'stringLister.makeSimpleList' run {
    local result = stringLister.makeSimpleList(['ljuskrona', 'ljus', 'hatt', 'jacka', 'tingest', 'skåpet']);
    //tadsSay(result);
    assertThat(result).isEqualTo('ljuskrona, ljus, hatt, jacka, tingest, och skåpet');
};


TestUnit 'plainLister.showListAll' run {
    local lst = [ljuskrona, ljus, hatt, jacka, tingest, skapet];
    local result = mainOutputStream.captureOutput({: 
      plainLister.showListAll(lst,0, 0)
    }); 
    assertThat(result).isEqualTo('en ljuskrona (avger ljus), ett ljus, en hatt (påklädd), en jacka (påklädd), en tingest, och ett skåp');
};


TestUnit 'explicitExitLister.showListAll' run {
    local lst = [lab];

    lab.dir_ = eastDirection; // (Used in showListItem)

    local result = mainOutputStream.captureOutput({: 
      explicitExitLister.showListAll(lst, 0, 0) //lst, options, indent)
    });
    //say(result);
    assertThat(result).isEqualTo('Den enda uppenbara utgången ledde öster. ');
} 
//only=true
;


/*
TestUnit 'specialDescLister.showListAll' run {
    //ljuskrona.specialDesc = {: "sdfadf" };
    gActor = spelare2aPerspektiv;

    local infoTab = new LookupTable();
    infoTab[ljuskrona] = new SenseInfo(ljuskrona, opaque, nil, 0);
    
    //local result = mainOutputStream.captureOutput({: 
      specialDescLister.showListItem(ljuskrona, nil, gActor, infoTab);
    //}); 
    //assertThat(result).isEqualTo('en ljuskrona (avger ljus), ett ljus, en hatt (påklädd), en jacka (påklädd), en tingest, och ett skåp');
};
*/
/*
specialDescLister.showList()

actorCarryingSublister.showList();
actorWearingSublister.showList();

roomListenLister.showList();
plainActorLister.showList();
actorInventoryLister.showList();

listenActionLister.showList();
roomSmellLister.showList();
smellActionLister.showList();
inventoryListenLister.showList();
inventorySmellLister.showList();
*/

// -----------------------------------------------------------------------
// theNameFrom
// -----------------------------------------------------------------------

TestUnit 'theNameFrom - +-notation ger korrekt bestämd form' run {
  // Normalfallet: +-notation → definiteForm sätts av vokabulärparsern.
  assertThat(stol.theName).isEqualTo('stolen');        // utrum: 'stol+en'
  assertThat(bord.theName).isEqualTo('bordet');        // neutrum: 'bord+et'
  assertThat(stolar.theName).isEqualTo('stolarna');    // plural: 'stol+ar+na'

  // Befintliga objekt i testfilen:
  assertThat(tingest.theName).isEqualTo('tingesten');  // 'tingest+en'
  assertThat(skapet.theName).isEqualTo('skåpet');      // 'skåp+et'
  assertThat(gatulyktor.theName).isEqualTo('gatulyktorna'); // 'gatu+lyktor+na'
};

TestUnit 'theNameFrom - egennamn returneras utan artikel' run {
  // isQualifiedName = true → returnera str oförändrat.
  assertThat(bobProper.theName).isEqualTo('bob');
};

TestUnit 'theNameFrom - reservfall utan +-notation' run {
  // Utan +-notation är definiteForm nil.
  // Korrekt svenska kräver böjningsändelse; reservfallet ger analytisk form.
  // Notera: dessa fall genererar en __DEBUG-varning i konsolen.
  assertThat(kattFallback.theName).isEqualTo('den katt');    // utrum → "den X"
  assertThat(husFallback.theName).isEqualTo('det hus');      // neutrum → "det X"
  assertThat(katternFallback.theName).isEqualTo('de katter'); // plural → "de X"
};

// -----------------------------------------------------------------------
// aNameFrom
// -----------------------------------------------------------------------

TestUnit 'aNameFrom - utrum singular' run {
  assertThat(stol.aName).isEqualTo('en stol');         // 'stol+en'
  assertThat(tingest.aName).isEqualTo('en tingest');   // 'tingest+en'
  assertThat(ljuskrona.aName).isEqualTo('en ljuskrona'); // 'ljus+krona+n'
};

TestUnit 'aNameFrom - neutrum singular' run {
  assertThat(bord.aName).isEqualTo('ett bord');        // 'bord+et'
  assertThat(skapet.aName).isEqualTo('ett skåp');      // 'skåp+et'
  assertThat(ljus.aName).isEqualTo('ett ljus');        // 'ljus+et'
};

TestUnit 'aNameFrom - plural' run {
  assertThat(stolar.aName).isEqualTo('några stolar');         // 'stol+ar+na'
  assertThat(gatulyktor.aName).isEqualTo('några gatulyktor'); // 'gatu+lyktor+na'
};

TestUnit 'aNameFrom - massnoun (ingen artikel)' run {
  assertThat(virke.aName).isEqualTo('virke');
  assertThat(olja.aName).isEqualTo('olja');
};

TestUnit 'aNameFrom - egennamn returneras utan artikel' run {
  assertThat(bobProper.aName).isEqualTo('bob');
};
