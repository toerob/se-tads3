#charset "utf-8"
#include <adv3.h>
#include <sv_se.h> 
#include "../../../code/tads3/tads3-unit-test/unittest.h"

/*
"{din} hand" är en beskrivning av ett objekt (handen),
 alltså används itPossAdj (possessivt adjektiv).

→ Det är din hand → "din" beskriver "hand".
 "Handen är {din}" → då används itPossNoun, eftersom "din" står för sig själv.
*/

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
    initialPlayerChar = spelare2aPerspektivDu
    usePastTense = true
;




modify testRunner 
  verboseAboutSuccessfulTests = nil // Visa inte varje testutfall om det är OK
;


modify mainOutputStream
    hideOutput = true
    capturedOutputBuffer = nil // = static new StringBuffer()
    writeFromStream(txt) {
        if(capturedOutputBuffer == nil) {
          capturedOutputBuffer = new StringBuffer();
        }
        capturedOutputBuffer.append(txt);
        // Swallow the message
        if(!hideOutput) {
          inherited(txt);
        }
    }
;
// Shortcut to access the output without lengthy comparisons
#define o toString(mainOutputStream.capturedOutputBuffer)

// Rensa fångst-buffern varje gång samt sätt ett default gAction 
// (då det förutsätts vid bland annat gMessageParams)
beforeEachTest: BeforeEach 
    run() { 
        mainOutputStream.capturedOutputBuffer = new StringBuffer();
        gAction = ExamineAction.createInstance();
    }
;


spelare1aPerspektiv: Actor 'jag' 'jag'
  pcReferralPerson = FirstPerson
  isProperName = true
  isHim = true
;

spelare1aPerspektivVi: Actor 'vi' 'vi'
  pcReferralPerson = FirstPerson
  isHim = true
  isPlural = true
;

spelare2aPerspektivDu: Actor 'du' 'du'
  pcReferralPerson = SecondPerson
  isProperName = true
  isHim = true
;

spelare2aPerspektivNi: Actor 'ni' 'ni'
  pcReferralPerson = SecondPerson
  isPlural = true
  isHim = true
;

spelare3dePerspektivHan: Actor 'bob' 'Bob'
  pcReferralPerson = ThirdPerson
  isProperName = true
  isHim = true
;
spelare3dePerspektivHon: Actor 'alice' 'Alice'
  pcReferralPerson = ThirdPerson
  isProperName = true
  isHer = true
;
spelare3dePerspektivDen: Actor 'astronaut+en' 'astronaut'
  pcReferralPerson = ThirdPerson
  isIt = true
;
spelare3dePerspektivDet: Actor 'träd+et' 'träd'
  pcReferralPerson = ThirdPerson
  isIt = true
  isNeuter = true 
;

spelare3dePerspektivDe: Actor 'män[-nen]' 'männen'
  pcReferralPerson = ThirdPerson
  isIt = true
  isPlural = true // TODO: träd+et - uter härleds inte automatiskt. Kolla upp. Det är PGA att iSuter defaultar till true numera,m ändra i Thing
;

hus: Thing 'hus+et' 'hus' isNeuter = true;

hund: Actor 'hund+en' 'hund'
  owner = spelare1aPerspektivVi
;
katt: Actor 'katt+en' 'katt';

smyckena: Actor 'smycken[-a]' 'smycken' isPlural = true;
skrin: Thing 'skrin+et' 'skrin' isNeuter = true;
juvel: Thing 'juvel+en' 'juvel';

luta: Actor 'luta[-n]' 'luta'
  owner = spelare3dePerspektivDet
  isUter = true
;

// https://tads.dev/docs/adv3/doc/techman/t3msg.htm

UnitTest '2:a person plural (ni)' run {
  //mainOutputStream.hideOutput = nil;
  gMessageParams(hund, hus, spelare2aPerspektivNi);
  [
    '{Den dobj/han} {är} {er}.' -> ['Huset var erat.']  // itPossNoun (plural)

  ].forEachAssoc(function(msg, msgPlusResult) {
    //gActor = spelare2aPerspektivNi;
    gAction = ExamineAction.createActionInstance();
    gAction.setCurrentObjects([hus]);
    setPlayer(spelare2aPerspektivNi);

    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    "<<msg>>";
    assertThat(o).isEqualTo(msgPlusResult[1]);
  });
};


// Test Assertions
UnitTest 'satsdelar' run {
  mainOutputStream.hideOutput = nil;
  setPlayer(spelare2aPerspektivDu);
  "{Du/han actor} går hem till {ditt}";
  assertThat(o).isEqualTo('Du går hem till ditt');
} skip=true; // TODO

UnitTest 'satsdelar' run {
  gMessageParams(luta);
  //mainOutputStream.hideOutput = nil;
  [
    spelare1aPerspektiv -> ['{Du} spelar på {din} luta', 'Jag spelar på min luta'],
    spelare1aPerspektiv -> ['{Jag} spelar på {min} luta', 'Jag spelar på min luta'],
    spelare1aPerspektiv -> ['{Du/han} spelar på {sin} luta', 'Jag spelar på min luta'],
    spelare1aPerspektiv -> ['{Du/hon} spelar på {sin} luta', 'Jag spelar på min luta'],
    
    spelare2aPerspektivDu -> ['{Du} spelar på {din} luta', 'Du spelar på din luta'],
    spelare2aPerspektivDu -> ['{Jag} spelar på {din} luta', 'Du spelar på din luta'],
    spelare2aPerspektivDu -> ['{Du/han} spelar på {din} luta', 'Du spelar på din luta'],
    spelare2aPerspektivDu -> ['{Du/hon} spelar på {din} luta', 'Du spelar på din luta'],

    spelare3dePerspektivHan -> ['{Du} spelar på {min} luta', 'Bob spelar på hans luta'],
    spelare3dePerspektivHan -> ['{Jag} spelar på {min} luta', 'Bob spelar på hans luta'],
    spelare3dePerspektivHan -> ['{Du/han} spelar på {min} luta', 'Bob spelar på hans luta'],
    spelare3dePerspektivHan -> ['{Du/hon} spelar på {min} luta', 'Bob spelar på hans luta'],

    spelare3dePerspektivHon -> ['{Du} spelar på {sin} luta', 'Alice spelar på hennes luta'],
    spelare3dePerspektivHon -> ['{Jag} spelar på {sin} luta', 'Alice spelar på hennes luta'],
    spelare3dePerspektivHon -> ['{Du/han} spelar på {sin} luta', 'Alice spelar på hennes luta'],
    spelare3dePerspektivHon -> ['{Du/hon} spelar på {sin} luta', 'Alice spelar på hennes luta'],

    spelare3dePerspektivDen -> ['{Du} spelar på {min} luta', 'Astronauten spelar på sin luta'],
    spelare3dePerspektivDen -> ['{Jag} spelar på {min} luta', 'Astronauten spelar på sin luta'],
    spelare3dePerspektivDen -> ['{Du/han} spelar på {min} luta', 'Astronauten spelar på sin luta'],
    spelare3dePerspektivDen -> ['{Du/hon} spelar på {min} luta', 'Astronauten spelar på sin luta'],

  // TODO: LAGA
    spelare3dePerspektivDet -> ['{Du} spelar på {sin luta} luta', 'Trädet spelar på sin luta'],
    spelare3dePerspektivDet -> ['{Jag} spelar på {sin luta} luta', 'Trädet spelar på sin luta'],
    spelare3dePerspektivDet -> ['{Du/han} spelar på {sin luta} luta', 'Trädet spelar på sin luta'],
    spelare3dePerspektivDet -> ['{Du/hon} spelar på {sin luta} luta', 'Trädet spelar på sin luta']
  ].forEachAssoc(function(player, msgPlusResult) {
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    setPlayer(player);
    "<<msgPlusResult[1]>>";
    assertThat(o).isEqualTo(msgPlusResult[2]);
  });
};


UnitTest '1:a person singular' run {
  //mainOutputStream.hideOutput = nil;
  [
    '{Jag} {går} till staden.' -> ['Jag gick till staden.'],  // itNom
    'Han {såg} {mig} på torget.' -> ['Han såg mig på torget.'],  // itObj
    '{Min} hatt blås{er|te} bort.' -> ['Min hatt blåste bort.'],  // itPossAdj
    'Den hatten {är} {min}.' -> ['Den hatten var min.'],  // itPossNoun
    '{Jag} {såg} {migsjälv} i spegeln.' -> ['Jag såg mig själv i spegeln.']  // itReflexive

  ].forEachAssoc(function(msg, msgPlusResult) {
    setPlayer(spelare1aPerspektiv);
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    "<<msg>>";
    assertThat(o).isEqualTo(msgPlusResult[1]);
  });
};


UnitTest '1:a person plural (vi)' run {
  //mainOutputStream.hideOutput = nil;
  gMessageParams(spelare1aPerspektivVi, hund);
  [
    '{Vi} {är} trötta.'  -> ['Vi var trötta.'],  // itNom
    'De hitta{r|de} {oss} i skogen.'  -> ['De hittade oss i skogen.'], // itObj
    '{Vår} hund har rymt.'  -> ['Vår hund har rymt.'], // itPossAdj
    'Hunden {är} {vår spelare1aPerspektivVi}.'  -> ['Hunden var vår.'], // itPossNoun
    '{Vi} försvarar {osssjälv}.' -> ['Vi försvarar oss själva.'] // itReflexive
  ].forEachAssoc(function(msg, msgPlusResult) {
    setPlayer(spelare1aPerspektivVi);
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    "<<msg>>";
    assertThat(o).isEqualTo(msgPlusResult[1]);
  });
};

UnitTest '2:a person singular (du)' run {
  //mainOutputStream.hideOutput = nil;
  gMessageParams(hund);
  [
    '{Du} tappa{r|de} något.' -> ['Du tappade något.'],  // itNom
    'Jag {såg} {dig actor} vid bron.' -> ['Jag såg dig vid bron.'],  // itObj
    '{Din} bok {är} här.' -> ['Din bok var här.'],  // itPossAdj
    'Boken {är} {din}.' -> ['Boken var din.'],  // itPossNoun
    '{Du} {såg} {digsjälv} i drömmen.' -> ['Du såg dig själv i drömmen.'] // itReflexive
  ].forEachAssoc(function(msg, msgPlusResult) {
    setPlayer(spelare2aPerspektivDu);
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    "<<msg>>";
    assertThat(o).isEqualTo(msgPlusResult[1]);
  });
};


UnitTest '2:a person plural (ni)' run {
  //mainOutputStream.hideOutput = nil;
  gMessageParams(katt, hus, spelare2aPerspektivNi, spelare2aPerspektivDu);
  [
    '{Ni} {har} kommit sent.' -> ['Ni hade kommit sent.'],  // itNom (plural)
    'Hon {hör} {dem} sjunga.' -> ['Hon hörde er sjunga.'],  // itObj (plural)
    '{Er} katt jamar.' -> ['Er katt jamar.'],  // itPossAdj (plural)
    'Katten {är} {er}.' -> ['Katten var er.'],  // itPossNoun (plural)
    '{Ni} försvarar {ersjälv}.' -> ['Ni försvarar er själva.'] // itReflexive (plural)
  ].forEachAssoc(function(msg, msgPlusResult) {
    setPlayer(spelare2aPerspektivNi);
    gAction = ExamineAction.createActionInstance();
    gAction.setCurrentObjects([katt]);
    setPlayer(spelare2aPerspektivNi);
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    "<<msg>>";
    assertThat(o).isEqualTo(msgPlusResult[1]);
  });
};

tradet: Thing 'träd+et' 'träd' isNeuter = true;

UnitTest '3:e person neutrum (det)' run {
  //mainOutputStream.hideOutput = nil;
  gMessageParams(tradet);
  gMessageParams(hund);
  [
    '{Det actor/han} {var} en gång ett träd.' -> ['Det var en gång ett träd.'],  // itNom
    'Hon {såg} {det tradet/honom} falla.' -> ['Hon såg det falla.'],  // itObj
    '{Dess tradet} blad vissnar.' -> ['Dess blad vissnar.'],  // itPossAdj
    'Bladen {är} {dess tradet}.' -> ['Bladen var dess.'],  // itPossNoun
    '{Det tradet} betraktar {sigsjälv}.' -> ['Det betraktar sig självt.']  // itReflexive
  ].forEachAssoc(function(msg, msgPlusResult) {
    setPlayer(spelare3dePerspektivDet);
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    "<<msg>>";
    assertThat(o).isEqualTo(msgPlusResult[1]);
  });
};


UnitTest '3:e person maskulinum (han)' run {
  //mainOutputStream.hideOutput = nil;
  gMessageParams(spelare3dePerspektivHan);
  local bob = spelare3dePerspektivHan;
  gMessageParams(bob);

  [
    '{Han} spr{inger|ang} snabbt.' ->['Han sprang snabbt.'],   // itNom
    'Jag {hör} {honom bob} skrika.' ->['Jag hörde honom skrika.'],   // itObj
    '{Hans} sko {går} sönder.' ->['Hans sko gick sönder.'],   // itPossAdj
    'Skoavtrycket {är} {hans}.' ->['Skoavtrycket var hans.'],   // itPossNoun
    '{Han} lura{r|de} {sigsjälv}.' ->['Han lurade sig själv.']   // itReflexive
  ].forEachAssoc(function(msg, msgPlusResult) {
    setPlayer(spelare3dePerspektivHan);
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    "<<msg>>";
    assertThat(o).isEqualTo(msgPlusResult[1]);
  });
};

UnitTest '3:e person femininum (hon)' run {
  //mainOutputStream.hideOutput = nil;
  gMessageParams(spelare3dePerspektivHon);
  local bob = spelare3dePerspektivHon;
  gMessageParams(bob);
  [
    '{Hon} laga{r|de} mat.' ->['Hon lagade mat.'], // itNom
    'Vi hjälp{er|te} {henne}.' ->['Vi hjälpte henne.'], // itObj
    '{Hennes} mat {är} god.' ->['Hennes mat var god.'], // itPossAdj
    'Rätten {är} {hennes}.' ->['Rätten var hennes.'], // itPossNoun
    '{Hon} tveka{r|de} på {sigsjälv}.' ->['Hon tvekade på sig själv.'] // itReflexive
  ].forEachAssoc(function(msg, msgPlusResult) {
    setPlayer(spelare3dePerspektivHon);
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    "<<msg>>";
    assertThat(o).isEqualTo(msgPlusResult[1]);
  });
};

UnitTest '3:e person plural (de)' run {
  //mainOutputStream.hideOutput = nil;
  gMessageParams(spelare3dePerspektivDe);
  local bob = spelare3dePerspektivDe;
  gMessageParams(bob);
  [
    '{De} {går} hem.' -> ['De gick hem.'],  // itNom
    'Vi möt{te|er} {dem} på vägen.' -> ['Vi möter dem på vägen.'],  // itObj
    '{Deras} bil {står|stod} {där}.' -> ['Deras bil stod där.'],  // itPossAdj
    'Bilen {är} {deras}.' -> ['Bilen var deras.'],  // itPossNoun
    '{De} skapa{r|de} {sigsjälv}.' -> ['De skapade sig själva.']  // itReflexive
  ].forEachAssoc(function(msg, msgPlusResult) {
    setPlayer(spelare3dePerspektivDe);
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    "<<msg>>";
    assertThat(o).isEqualTo(msgPlusResult[1]);
  });
};

UnitTest 'Demonstrativa (behövs inte specialiserat thatNom / thatObj)' run {
  //mainOutputStream.hideOutput = nil;
  gMessageParams(spelare3dePerspektivDe, hund, smyckena, skrin, juvel);
  [
    '{De spelare3dePerspektivDe} {där} typerna alltså.' -> ['De där typerna alltså.'],              // thatNom
    '{Det hund} {där} spelar apa.' -> ['Den där spelar apa.'],                                      // thatNom
    '{Det skrin} {där} är dyrt.' -> ['Det där är dyrt.'],                                           // thatNom
    '{Det/han spelare3dePerspektivDe} {där} var mina gamla klasskompisar.'  
                                                       -> ['De där var mina gamla klasskompisar.'], // thatNom
    'Jag {såg} {de spelare3dePerspektivDe} {där} smitarna.' 
                                                       -> ['Jag såg de där smitarna.'],             // thatNom

    'Hon tog {den juvel/obj} {där} utan lov.'      -> ['Hon tog den där utan lov.' ],               // thatObj
    'Hon tog {det skrin/obj} {där} utan lov.'      -> ['Hon tog det där utan lov.' ],               // thatObj
    'Hon tog {dem smyckena/obj} {där} utan lov.'   -> ['Hon tog dem där utan lov.' ],               // thatObj

    'Jag hittade inte {det} {där} du pratade om.'  -> ['Jag hittade inte dem där du pratade om.' ]  // thatObj 
  ].forEachAssoc(function(msg, msgPlusResult) {
    setPlayer(spelare3dePerspektivDe);
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    "<<msg>>";
    assertThat(o).isEqualTo(msgPlusResult[1]);
  });
};









/*

  [
        // parameters that imply the actor as the target object
        ['du', &theName, 'actor', nil, true],
        ['jag', &theName, 'actor', nil, true],
        ['du/han', &theName, 'actor', nil, true],
        ['du/hon', &theName, 'actor', nil, true],
        ['du/honom', &theNameObj, 'actor', &itReflexive, nil],
        ['du/henne', &theNameObj, 'actor', &itReflexive, nil],

        ['mig', &itObj, 'actor', nil, nil],
        ['dig', &itObj, 'actor', nil, nil],
        ['sig', &itObj, 'actor', nil, nil],

        ['min', &theNamePossAdj, 'actor', nil, nil],
        ['din', &itPossAdj, 'actor', nil, nil],

        //['han', &thatNom, 'actor', nil, true],
        //['hon', &thatNom, 'actor', nil, true],


        // TODO: ta bort/ersätt rester av engelskan här:
        ['you/him', &theNameObj, 'actor', &itReflexive, nil],
        ['you/her', &theNameObj, 'actor', &itReflexive, nil],
        ['your/her', &theNamePossAdj, 'actor', nil, nil],
        
        ['your/his', &theNamePossAdj, 'actor', nil, nil],        
        ['din/hans', &theNamePossAdj, 'actor', nil, nil], // Ersätter ovan
        //['your', &theNamePossAdj, 'actor', nil, nil],

        ['mina', &theNamePossAdjPlural, 'actor', nil, nil],


        ['yours/hers', &theNamePossNoun, 'actor', nil, nil],
        ['yours/his', &theNamePossNoun, 'actor', nil, nil],
        ['yours', &theNamePossNoun, 'actor', nil, nil],
        ['yourself/himself', &itReflexive, 'actor', nil, nil],
        ['yourself/herself', &itReflexive, 'actor', nil, nil],
        ['digsjälv', &itReflexive, 'actor', nil, nil],
        ['sigsjälv', &itReflexive, 'actor', nil, nil],

        // sig själv
        ['själv', &itReflexive, 'actor', nil, nil],
        ['själva', &itReflexive, 'actor', nil, nil],

        // parameters that don't imply any target object
        ['den/han', &theName, nil, nil, true],
        ['den/hon', &theName, nil, nil, true],
        ['den/honom', &theNameObj, nil, &itReflexive, nil],
        ['den/henne', &theNameObj, nil, &itReflexive, nil],
        //TODO: ['hennes', &theNamePossAdj, nil, &itPossAdj, nil],
        //['dess/hennes', &theNamePossNoun, nil, &itPossNoun, nil], // ['the\'s/hers', &theNamePossNoun, nil, &itPossNoun, nil],
        
        ['dess/hon', &itPossAdj, nil, nil, nil],               // ['its/her', &itPossAdj, nil, nil, nil],
        ['dess/hennes', &itPossNoun, nil, nil, nil], // ['the\'s/hers', &theNamePossNoun, nil, &itPossNoun, nil],
        

        ['a/t', &endingForNounTA, 'dobj', nil, nil],
        ['a', &endingForNounA, 'dobj', nil, nil],
        ['d/t/da', &endingForNounDTDa, 'dobj', nil, nil],
        ['ad/at/na', &endingForNounAdAtNa, 'dobj', nil, nil],
        ['en/et/na', &endingForNounEnEtNa, 'dobj', nil, nil],
        ['r', &verbEndingR, nil, nil, true],
        ['t', &verbEndingT, nil, nil, true], // t ex ätbar(t)
        ['r/de', &verbEndingRDe, nil, nil, true], // SE
        ['r/?de', &verbEndingRMessageBuilder_, nil, nil, true],
        ['ar/ade', &verbEndingARDe, nil, nil, true],
        ['kan', &verbCan, nil, nil, true],
        ['are', &verbToBe, nil, nil, true],
        ['här', &verbHere, nil, nil, true],
        ['verkar', &verbToSeem, nil, nil, true],
        ['sätter', &verbToPut, nil, nil, true],
        ['tar', &verbToTake, nil, nil, true],
        ['ser', &verbToSee, nil, nil, true],
        ['er/te', &verbEndingEr, nil, nil, true],  // t ex: trycker/tryckte
        ['er/e', &verbEndingErE, nil, nil, true],  // t ex: tänder/tände
        ['är', &verbToBe, nil, nil, true],
        ['var', &verbWas, nil, nil, true],
        // TODO: {be|have been}  '{vara|varit}'
        ['hade', &verbToHave, nil, nil, true],
        ['har', &verbToHave, nil, nil, true],
        ['gör', &verbToDo, nil, nil, true],
        ['går', &verbToGo, nil, nil, true],
        ['kommer', &verbToCome, nil, nil, true],
        ['lämnar', &verbToLeave, nil, nil, true],
        ['säg', &verbToSay, nil, nil, true],
        ['måste', &verbMust, nil, nil, true],
        ['kommer', &verbWill, nil, nil, true],
        ['en/han', &aName, nil, nil, true],
        ['en/hon', &aName, nil, nil, true],
        ['en/honom', &aNameObj, nil, &itReflexive, nil],
        ['en/henne', &aNameObj, nil, &itReflexive, nil],
        
        ['ett/han', &aName, nil, nil, true],
        ['ett/hon', &aName, nil, nil, true],
        ['ett/honom', &aNameObj, nil, &itReflexive, nil],
        ['ett/henne', &aNameObj, nil, &itReflexive, nil],
        
        // TODO: hur blir det med it nominative vs that nominative i följande fall
        // (just nu krockar det med that det/han det/hon)

        //['det/han', &itNom, nil, nil, true],
        //['det/hon', &itNom, nil, nil, true],
        
        // TODO: {mig} {dig} {sig} bör räcka. 
        ['det/honom', &itObj, nil, &itReflexive, nil],
        ['det/henne', &itObj, nil, &itReflexive, nil],
        
        
        //FIXME: ['den/he', &thatNom, nil, nil, true],

        //TODO:  det/han vs den/han just nu är något otydlig.
        // Det kommer från att den/han tagit över the/he
        // Kom på ett tydligare sätt att visa att det är 
        // bestämd artikel eller är det tydligt nog?
        //  Han/hon/den/det jmf med den/han: Golvet/Mats etc..

        ['det/han', &thatNom, nil, nil, true],
        ['det/hon', &thatNom, nil, nil, true],
        //['that/he', &thatNom, nil, nil, true],
        //['that/she', &thatNom, nil, nil, true],
        ['de/honom', &thatObj, nil, &itReflexive, nil],
        ['de/henne', &thatObj, nil, &itReflexive, nil],


        //['that/him', &thatObj, nil, &itReflexive, nil],
        //['that/her', &thatObj, nil, &itReflexive, nil],

        ['that\'s', &thatIsContraction, nil, nil, true],
        ['itself', &itReflexive, nil, nil, nil],
        ['itself/himself', &itReflexive, nil, nil, nil],
        ['itself/herself', &itReflexive, nil, nil, nil],

        // default preposition for standing in/on something:
        ['på', &actorInName, nil, nil, nil],
        ['i', &actorInName, nil, nil, nil],
        //['in', &actorInName, nil, nil, nil],
        ['outof', &actorOutOfName, nil, nil, nil],
        ['avur', &actorOutOfName, nil, nil, nil],
        ['onto', &actorIntoName, nil, nil, nil],
        ['into', &actorIntoName, nil, nil, nil],
        ['subj', &dummyName, nil, nil, true]
    ]

*/





// TODO: Annan fil:
// TODO: testa av Resolver.resolvePronounAntecedent