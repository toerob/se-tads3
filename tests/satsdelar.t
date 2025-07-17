#charset "utf-8"
#include <adv3.h>
#include <sv_se.h> 
#include "testunit.h"

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

spelare3dePerspektivDe: Actor 'män+nen' 'männen'
  pcReferralPerson = ThirdPerson
  isIt = true
  isPlural = true // TODO: träd+et - uter härleds inte automatiskt. Kolla upp. Det är PGA att iSuter defaultar till true numera,m ändra i Thing
;

hus: Thing 'hus+et' 'hus' isNeuter = true;

hund: Actor 'hund+en' 'hund'
  owner = spelare1aPerspektivVi
;
katt: Actor 'katt+en' 'katt';

smyckena: Actor 'smycken+a' 'smycken' isPlural = true;
skrin: Thing 'skrin+et' 'skrin' isNeuter = true;
juvel: Thing 'juvel+en' 'juvel';

luta: Actor 'luta+n' 'luta'
  owner = spelare3dePerspektivDet
  isUter = true
;

// https://tads.dev/docs/adv3/doc/techman/t3msg.htm

TestUnit '2:a person plural (ni)' run {
  //mainOutputStream.hideOutput = nil;
  gMessageParams(hund, hus, spelare2aPerspektivNi);
  [
    '{Ref dobj/den} {är} {din/erat}.' -> ['Huset var erat.']  // itPossNoun (plural)

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
TestUnit 'satsdelar' run {
  mainOutputStream.hideOutput = nil;
  setPlayer(spelare2aPerspektivDu);
  "{Du/han actor} går hem till {ditt}";
  assertThat(o).isEqualTo('Du går hem till ditt');
} skip=true; // TODO

TestUnit 'satsdelar' run {
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

    spelare3dePerspektivHan -> ['{Du} spelar på {sin luta} luta', 'Bob spelar på sin luta'],
    spelare3dePerspektivHan -> ['{Jag} spelar på {sin luta} luta', 'Bob spelar på sin luta'],
    spelare3dePerspektivHan -> ['{Du/han} spelar på {sin luta} luta', 'Bob spelar på sin luta'],
    spelare3dePerspektivHan -> ['{Du/hon} spelar på {sin luta} luta', 'Bob spelar på sin luta'],

    spelare3dePerspektivHon -> ['{Du} spelar på {sin luta} luta', 'Alice spelar på sin luta'],
    spelare3dePerspektivHon -> ['{Jag} spelar på {sin luta} luta', 'Alice spelar på sin luta'],
    spelare3dePerspektivHon -> ['{Du/han} spelar på {sin luta} luta', 'Alice spelar på sin luta'],
    spelare3dePerspektivHon -> ['{Du/hon} spelar på {sin luta} luta', 'Alice spelar på sin luta'],

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


TestUnit '1:a person singular' run {
  //mainOutputStream.hideOutput = nil;
  [
    '{Jag} {går} till staden.' -> ['Jag gick till staden.'],  // itNom
    'Han {såg} {mig} på torget.' -> ['Han såg mig på torget.'],  // itObj
    '{Min} hatt blås{er|te} bort.' -> ['Min hatt blåste bort.'],  // itPossAdj
    'Den hatten {är} {min}.' -> ['Den hatten var min.'],  // itPossNoun
    '{Jag} {såg} {mig_själv} i spegeln.' -> ['Jag såg mig själv i spegeln.']  // itReflexive

  ].forEachAssoc(function(msg, msgPlusResult) {
    setPlayer(spelare1aPerspektiv);
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    "<<msg>>";
    assertThat(o).isEqualTo(msgPlusResult[1]);
  });
};


TestUnit '1:a person plural (vi)' run {
  //mainOutputStream.hideOutput = nil;
  gMessageParams(spelare1aPerspektivVi, hund);
  [
    '{Vi} {är} trötta.'  -> ['Vi var trötta.'],  // itNom
    'De hitta{r|de} {oss} i skogen.'  -> ['De hittade oss i skogen.'], // itObj
    '{Vår} hund har rymt.'  -> ['Vår hund har rymt.'], // itPossAdj
    'Hunden {är} {vår spelare1aPerspektivVi}.'  -> ['Hunden var vår.'], // itPossNoun
    '{Vi} försvarar {oss_själva}.' -> ['Vi försvarar oss själva.'] // itReflexive
  ].forEachAssoc(function(msg, msgPlusResult) {
    setPlayer(spelare1aPerspektivVi);
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    "<<msg>>";
    assertThat(o).isEqualTo(msgPlusResult[1]);
  });
};

TestUnit '2:a person singular (du)' run {
  //mainOutputStream.hideOutput = nil;
  gMessageParams(hund);
  [
    '{Du} tappa{r|de} något.' -> ['Du tappade något.'],  // itNom
    'Jag {såg} {dig actor} vid bron.' -> ['Jag såg dig vid bron.'],  // itObj
    '{Din} bok {är} här.' -> ['Din bok var här.'],  // itPossAdj
    'Boken {är} {din}.' -> ['Boken var din.'],  // itPossNoun
    '{Du} {såg} {dig_själv} i drömmen.' -> ['Du såg dig själv i drömmen.'] // itReflexive
  ].forEachAssoc(function(msg, msgPlusResult) {
    setPlayer(spelare2aPerspektivDu);
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    "<<msg>>";
    assertThat(o).isEqualTo(msgPlusResult[1]);
  });
};


TestUnit '2:a person plural (ni)' run {
  //mainOutputStream.hideOutput = nil;
  gMessageParams(katt, hus, spelare2aPerspektivNi, spelare2aPerspektivDu);
  [
    '{Ni} {har} kommit sent.' -> ['Ni hade kommit sent.'],  // itNom (plural)
    'Hon {hör} {dem} sjunga.' -> ['Hon hörde er sjunga.'],  // itObj (plural)
    '{Er} katt jamar.' -> ['Er katt jamar.'],  // itPossAdj (plural)
    'Katten {är} {er}.' -> ['Katten var er.'],  // itPossNoun (plural)
    '{Ni} försvarar {er_själva}.' -> ['Ni försvarar er själva.'] // itReflexive (plural)
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

TestUnit '3:e person neutrum (det)' run {
  //mainOutputStream.hideOutput = nil;
  gMessageParams(tradet);
  gMessageParams(hund);
  [
    '{Det actor/han} {var} en gång ett träd.' -> ['Det var en gång ett träd.'],  // itNom
    'Hon {såg} {det tradet/honom} falla.' -> ['Hon såg det falla.'],  // itObj
    '{Dess tradet} blad vissnar.' -> ['Dess blad vissnar.'],  // itPossAdj
    'Bladen {är} {dess tradet}.' -> ['Bladen var dess.'],  // itPossNoun
    '{Det tradet/han} betraktar {sig_själv}.' -> ['Det betraktar sig självt.']  // itReflexive
  ].forEachAssoc(function(msg, msgPlusResult) {
    setPlayer(spelare3dePerspektivDet);
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    "<<msg>>";
    assertThat(o).isEqualTo(msgPlusResult[1]);
  });
};


TestUnit '3:e person maskulinum (han)' run {
  //mainOutputStream.hideOutput = nil;
  gMessageParams(spelare3dePerspektivHan);
  local bob = spelare3dePerspektivHan;
  gMessageParams(bob);

  [
    '{Det/han bob} spr{inger|ang} snabbt.' ->['Han sprang snabbt.'],   // itNom
    'Jag {hör} {honom bob} skrika.' ->['Jag hörde honom skrika.'],   // itObj
    '{Ref/din} sko {går} sönder.' ->['Bobs sko gick sönder.'],   // itPossAdj
    'Skoavtrycket {är} {din/hans}.' ->['Skoavtrycket var hans.'],   // itPossNoun
    '{Han/den} lura{r|de} {sig_själv}.' ->['Han lurade sig själv.']   // itReflexive
  ].forEachAssoc(function(msg, msgPlusResult) {
    setPlayer(spelare3dePerspektivHan);
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    "<<msg>>";
    assertThat(o).isEqualTo(msgPlusResult[1]);
  });
};

TestUnit '3:e person femininum (hon)' run {
  //mainOutputStream.hideOutput = nil;
  gMessageParams(spelare3dePerspektivHon);
  local alice = spelare3dePerspektivHon;
  gMessageParams(alice);
  [
    '{Hon} laga{r|de} mat.' ->['Hon lagade mat.'], // itNom
    'Vi hjälp{er|te} {henne}.' ->['Vi hjälpte henne.'], // itObj
    '{Din/hennes} mat {är} god.' ->['Hennes mat var god.'], // itPossAdj
    'Rätten {är} {din/hennes}.' ->['Rätten var hennes.'], // itPossNoun
    '{Hon/den} tveka{r|de} på {sig_själv}.' ->['Hon tvekade på sig själv.'] // itReflexive
  ].forEachAssoc(function(msg, msgPlusResult) {
    setPlayer(spelare3dePerspektivHon);
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    "<<msg>>";
    assertThat(o).isEqualTo(msgPlusResult[1]);
  });
};

TestUnit '3:e person plural (de)' run {
  //mainOutputStream.hideOutput = nil;
  gMessageParams(spelare3dePerspektivDe);
  local bob = spelare3dePerspektivDe;
  gMessageParams(bob);
  [
    '{De} {går} hem.' -> ['De gick hem.'],  // itNom
    'Vi möt{te|er} {dem} på vägen.' -> ['Vi möter dem på vägen.'],  // itObj
    '{Deras} bil {står|stod} {där}.' -> ['Deras bil stod där.'],  // itPossAdj
    'Bilen {är} {deras}.' -> ['Bilen var deras.'],  // itPossNoun
    '{De} skapa{r|de} {sig_själv}.' -> ['De skapade sig själva.']  // itReflexive
  ].forEachAssoc(function(msg, msgPlusResult) {
    setPlayer(spelare3dePerspektivDe);
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    "<<msg>>";
    assertThat(o).isEqualTo(msgPlusResult[1]);
  });
};

TestUnit 'Demonstrativa (behövs inte specialiserat thatNom / thatObj)' run {
  //mainOutputStream.hideOutput = nil;
  gMessageParams(spelare3dePerspektivDe, hund, smyckena, skrin, juvel);
  [
    '{De spelare3dePerspektivDe} {där} typerna alltså.' -> ['De där typerna alltså.'],              // thatNom
    '{Den hund/han} {där} spelar apa.' -> ['Den där spelar apa.'],                                      // thatNom
    '{Det skrin/han} {där} är dyrt.' -> ['Det där är dyrt.'],                                           // thatNom
    '{Det/han spelare3dePerspektivDe} {där} var mina gamla klasskompisar.'  
                                                       -> ['De där var mina gamla klasskompisar.'], // thatNom
    'Jag {såg} {de spelare3dePerspektivDe} {där} smitarna.' 
                                                       -> ['Jag såg de där smitarna.'],             // thatNom

    'Hon tog {den juvel/obj} {där} utan lov.'      -> ['Hon tog den där utan lov.' ],               // thatObj
    'Hon tog {det skrin/obj} {där} utan lov.'      -> ['Hon tog det där utan lov.' ],               // thatObj
    'Hon tog {dem smyckena/obj} {där} utan lov.'   -> ['Hon tog dem där utan lov.' ],               // thatObj

    'Jag hittade inte {dem} {där} du pratade om.'  -> ['Jag hittade inte dem där du pratade om.' ]  // thatObj 
  ].forEachAssoc(function(msg, msgPlusResult) {
    setPlayer(spelare3dePerspektivDe);
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    "<<msg>>";
    assertThat(o).isEqualTo(msgPlusResult[1]);
  });
};
