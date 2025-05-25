#charset "utf-8"
#include <adv3.h>
#include <sv_se.h> 
#include "../../../code/tads3/tads3-unit-test/unittest.h"

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
spelare2aPerspektiv: Actor 'du' 'du'
  pcReferralPerson = SecondPerson
  isProperName = true
  isHim = true
;

#define __DEBUG

// Test Assertions

modify Thing
  construct() {  
    // For the tests that follows the constructor is disabled, so 
    // the behavior of initializeVocabWith is easier to test
   }
;

UnitTest 'initialize äpple (ett-ord)' run {

    local appleAvancerat = new Thing();
    appleAvancerat.vocabWords = 'gröna smakfulla äpple+t/frukt+en*äpplen+a frukter+na';
    appleAvancerat.name = 'äpple';
    

    appleAvancerat.initializeVocabWith(appleAvancerat.vocabWords);
    tadsSay(getGrammarInfoFromCmdDict(appleAvancerat));

    assertThat(cmdDict.findWord('äpple', &noun)[1]).isEqualTo(appleAvancerat);
    assertThat(cmdDict.findWord('äpplet', &noun)[1]).isEqualTo(appleAvancerat);  
    assertThat(cmdDict.findWord('äpplen', &plural)[1]).isEqualTo(appleAvancerat);
    assertThat(cmdDict.findWord('äpplena', &plural)[1]).isEqualTo(appleAvancerat);

    assertThat(cmdDict.findWord('frukt', &noun)[1]).isEqualTo(appleAvancerat);
    assertThat(cmdDict.findWord('frukten', &noun)[1]).isEqualTo(appleAvancerat);  

    // Matchar första ordet exakt och det andra mha trunkering, därav två par i resultatet
    assertThat(cmdDict.findWord('frukter', &plural)[1]).isEqualTo(appleAvancerat);
    assertThat(cmdDict.findWord('frukterna', &plural)[1]).isEqualTo(appleAvancerat);

    assertThat(appleAvancerat.isNeuter).isNil(); // OBS: härleds ännu inte
    assertThat(appleAvancerat.isPlural).isNil(); 
    
};

UnitTest 'initialize dörr (en-ord)' run {
    local obj = new Thing();
    obj.vocabWords = 'rustik+a gammel+modig+a dörr+en/port+en*dörrar+na portar+na';
    obj.name = 'dörr';
    obj.initializeVocabWith(obj.vocabWords);
    tadsSay(getGrammarInfoFromCmdDict(obj));

    //assertThat(cmdDict.findWord('gröna', &adjective)).isEqualTo(obj);
    //assertThat(cmdDict.findWord('skrämmande', &adjective)[1]).isEqualTo(obj);  


    assertThat(cmdDict.findWord('dörr', &noun)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('dörren', &noun)[1]).isEqualTo(obj);  

    assertThat(cmdDict.findWord('port', &noun)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('porten', &noun)[1]).isEqualTo(obj);  
    
    // Matchar första ordet exakt och det andra mha trunkering, därav två par i resultatet
    assertThat(cmdDict.findWord('dörrar', &plural)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('dörrarna', &plural)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('portar', &plural)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('portarna', &plural)[1]).isEqualTo(obj);

    assertThat(obj.isNeuter).isNil();   
    assertThat(obj.isPlural).isNil(); 
};

UnitTest 'initialize tranbärsjuice (en-ord)' run {
    local obj = new Thing();
    obj.vocabWords = 'tranbär^s+juice+n';
    obj.name = 'tranbärsjuice';
    obj.initializeVocabWith(obj.vocabWords);
    tadsSay(getGrammarInfoFromCmdDict(obj));

    assertThat(cmdDict.findWord('tranbär', &noun)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('tranbären', &noun)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('tranbärsjuice', &noun)[1]).isEqualTo(obj);  
    assertThat(cmdDict.findWord('tranbärsjuicen', &noun)[1]).isEqualTo(obj);

    assertThat(cmdDict.findWord('juice', &noun)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('juicen', &noun)[1]).isEqualTo(obj);


    assertThat(obj.isNeuter).isNil();   
    assertThat(obj.isPlural).isNil(); 
    //TODO: ska inte vara juicen
    //assertThat(obj.definitiveForm).isEqualTo('tranbärsjuicen'); 
};


UnitTest 'initialize plural' run {
    local obj = new Thing();
    obj.vocabWords = 'stolar+na';
    obj.name = 'stolarna';
    obj.isPlural = true;

    obj.initializeVocabWith(obj.vocabWords);
    tadsSay(getGrammarInfoFromCmdDict(obj));

    assertThat(cmdDict.findWord('stolar', &plural)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('stolarna', &plural)[1]).isEqualTo(obj);  

    // TODO: fixa till så isNeuter sätts på ändelsen "-na"
    assertThat(obj.isNeuter).isNil();   
    assertThat(obj.isPlural).isTrue();
}; 








 
function getGrammarInfoFromCmdDict(o) {
    local str = new StringBuffer();
    cmdDict.forEachWord(function(obj, word, wordPart) {
        if(obj == o) {
            local grammarFunction = 'unknown';
            if(wordPart == &noun) grammarFunction = 'substantiv';
            else if(wordPart == &plural) grammarFunction = 'plural';
            else if(wordPart == &adjective) grammarFunction = 'adjektiv';
            str.append('<<word>> (<<grammarFunction>>) \n');
        }
    });
    return toString(str);
 }