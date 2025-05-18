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

// Test Assertions
UnitTest 'initialize äpple (ett-ord)' run {
    local appleAvancerat = new Thing();
    appleAvancerat.vocabWords = 'äpple[-t]/frukt[-en]*äpplen[-a] frukter[-na]';
    appleAvancerat.name = 'äpple';
    appleAvancerat.initializeVocabWith(appleAvancerat.vocabWords);

    assertThat(cmdDict.findWord('frukt', &noun)).isEqualTo([appleAvancerat, 1]);
    assertThat(cmdDict.findWord('frukten', &noun)).isEqualTo([appleAvancerat, 1]);  

    assertThat(cmdDict.findWord('äpple', &noun)).isEqualTo([appleAvancerat, 1]);
    assertThat(cmdDict.findWord('äpplet', &noun)).isEqualTo([appleAvancerat, 1]);  
    
    // TODO: fixa plural för första ordet
    //assertThat(cmdDict.findWord('äpplen', &plural)).isEqualTo([appleAvancerat, 1]);
    // TODO: fixa plural för första ordet
    //assertThat(cmdDict.findWord('frukter', &plural)).isEqualTo([appleAvancerat, 1]);

    assertThat(cmdDict.findWord('äpplena', &plural)).isEqualTo([appleAvancerat, 1]);
    assertThat(cmdDict.findWord('frukterna', &plural)).isEqualTo([appleAvancerat, 1]);

    assertThat(appleAvancerat.isUter).isNil();   
    assertThat(appleAvancerat.isPlural).isNil(); 
};

UnitTest 'initialize dörr (en-ord)' run {
    local obj = new Thing();
    obj.vocabWords = 'dörr[-en]/port[-en]*dörrar[-na] portar[-na]';
    obj.name = 'dörr';
    obj.initializeVocabWith(obj.vocabWords);

    assertThat(cmdDict.findWord('dörr', &noun)).isEqualTo([obj, 1]);
    assertThat(cmdDict.findWord('dörren', &noun)).isEqualTo([obj, 1]);  

    assertThat(cmdDict.findWord('port', &noun)).isEqualTo([obj, 1]);
    assertThat(cmdDict.findWord('porten', &noun)).isEqualTo([obj, 1]);  
    
    // TODO: fixa plural för första ordet
    //assertThat(cmdDict.findWord('äpplen', &plural)).isEqualTo([obj, 1]);
    // TODO: fixa plural för första ordet
    //assertThat(cmdDict.findWord('frukter', &plural)).isEqualTo([obj, 1]);

    assertThat(cmdDict.findWord('dörrarna', &plural)).isEqualTo([obj, 1]);
    assertThat(cmdDict.findWord('portarna', &plural)).isEqualTo([obj, 1]);

    // TODO: Fixa isUter
    //assertThat(obj.isUter).isTrue();   
    assertThat(obj.isPlural).isNil(); 
};









    /*cmdDict.forEachWord(function(obj, str, prop) {
      if(obj == apple) {
        "word: <<obj>>: <<str>>\n";
      }
    });*/
 