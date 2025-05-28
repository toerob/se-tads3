#charset "utf-8"
#include <adv3.h>
#include <sv_se.h> 
#include "../../../code/tads3/tads3-unit-test/unittest.h"


/**
 * Tester för att säkerställa att olika sätt att skapa upp ett objekt med vocabWords beter sig enligt förväntat sätt.
 *   
 */
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

modify testRunner 
  verboseAboutSuccessfulTests = nil // Visa inte varje testutfall om det är OK
;

modify Thing
  construct() {  
    // For the tests that follows the constructor is disabled, so 
    // the behavior of initializeVocabWith is easier to test
   }
;


UnitTest 'initialize äpple med +notation (ett-ord)' run {

    local appleAvancerat = new Thing();
    appleAvancerat.vocabWords = 'röda smakfulla äpple+t/frukt+en*äpplen+a frukter+na';
    appleAvancerat.name = 'äpple';

    // Sut
    appleAvancerat.initializeVocabWith(appleAvancerat.vocabWords);

    // Assert
    //tadsSay(getGrammarInfoFromCmdDict(appleAvancerat));
    assertThat(cmdDict.findWord('röda', &adjective)[1]).isEqualTo(appleAvancerat);
    assertThat(cmdDict.findWord('smakfulla', &adjective)[1]).isEqualTo(appleAvancerat);  

    assertThat(cmdDict.findWord('äpple', &noun)[1]).isEqualTo(appleAvancerat);
    assertThat(cmdDict.findWord('äpplet', &noun)[1]).isEqualTo(appleAvancerat);  
    assertThat(cmdDict.findWord('äpplen', &plural)[1]).isEqualTo(appleAvancerat);
    assertThat(cmdDict.findWord('äpplena', &plural)[1]).isEqualTo(appleAvancerat);

    assertThat(cmdDict.findWord('frukt', &noun)[1]).isEqualTo(appleAvancerat);
    assertThat(cmdDict.findWord('frukten', &noun)[1]).isEqualTo(appleAvancerat);  

    // OBS: Matchar första ordet exakt och det andra mha trunkering, därav plural par i resultatet,
    // men vi kollar bara in första objektet [1] för detta slags test.
    assertThat(cmdDict.findWord('frukter', &plural)[1]).isEqualTo(appleAvancerat);
    assertThat(cmdDict.findWord('frukterna', &plural)[1]).isEqualTo(appleAvancerat);

    // Räkna antalet _förväntade_ förekomster som finns i cmdDict för detta objekt (oavsett grammatisk form)
    local count = getGrammarPartsFromCmdDict(appleAvancerat);
    assertThat(count).isEqualTo(10);

    assertThat(appleAvancerat.isNeuter).isNil(); // Härleds från den bestämda formen av äpple+t
    assertThat(appleAvancerat.isPlural).isNil(); 
    assertThat(appleAvancerat.definitiveForm).isEqualTo('äpplet'); 

};

UnitTest 'initialize dörr med +notation (en-ord)' run {
    local obj = new Thing();
    obj.vocabWords = 'rustik+a gamla gammelmodig+a dörr+en/port+en*dörrar+na portar+na';
    obj.name = 'dörr';

    // Sut
    obj.initializeVocabWith(obj.vocabWords);

    // Assert
    // tadsSay(getGrammarInfoFromCmdDict(obj));
    assertThat(cmdDict.findWord('rustik', &adjective)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('rustika', &adjective)[1]).isEqualTo(obj);

    assertThat(cmdDict.findWord('gamla', &adjective)[1]).isEqualTo(obj);  
    assertThat(cmdDict.findWord('gammelmodig', &adjective)[1]).isEqualTo(obj);  
    assertThat(cmdDict.findWord('gammelmodiga', &adjective)[1]).isEqualTo(obj);  

    assertThat(cmdDict.findWord('dörr', &noun)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('dörren', &noun)[1]).isEqualTo(obj);  

    assertThat(cmdDict.findWord('dörrar', &plural)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('dörrarna', &plural)[1]).isEqualTo(obj);

    assertThat(cmdDict.findWord('port', &noun)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('porten', &noun)[1]).isEqualTo(obj);  
    
    assertThat(cmdDict.findWord('portar', &plural)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('portarna', &plural)[1]).isEqualTo(obj);

    // Räkna antalet _förväntade_ förekomster som finns i cmdDict för detta objekt (oavsett grammatisk form)
    local count = getGrammarPartsFromCmdDict(obj); 
    assertThat(count).isEqualTo(13);

    assertThat(obj.isNeuter).isNil();   
    assertThat(obj.isPlural).isNil(); 
    assertThat(obj.definitiveForm).isEqualTo('dörren'); 

};

UnitTest 'initialize tranbärsjuice med +notation (en-ord)' run {
    local obj = new Thing();
    obj.vocabWords = 'tranbär^s+juice+n';
    obj.name = 'tranbärsjuice';

    // Sut
    obj.initializeVocabWith(obj.vocabWords);

    // Assert
    // tadsSay(getGrammarInfoFromCmdDict(obj));
    assertThat(cmdDict.findWord('tranbär', &noun)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('tranbären', &noun)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('tranbärsjuice', &noun)[1]).isEqualTo(obj);  
    assertThat(cmdDict.findWord('tranbärsjuicen', &noun)[1]).isEqualTo(obj);

    assertThat(cmdDict.findWord('juice', &noun)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('juicen', &noun)[1]).isEqualTo(obj);

    assertThat(obj.isNeuter).isNil();   
    assertThat(obj.isPlural).isNil(); 
    assertThat(obj.definitiveForm).isEqualTo('tranbärsjuicen'); 
};

// Böja adjektiv med foge-S
UnitTest 'initialize adjektiv med +notation och foge-S' run {
    local obj = new Thing();
    obj.vocabWords = 'orsak^s+analytisk+a uggla+n';
    obj.name = 'uggla';
    obj.definitiveForm = 'ugglan';

    // Sut
    obj.initializeVocabWith(obj.vocabWords);

    // Assert
    // tadsSay(getGrammarInfoFromCmdDict(obj));
    // OBS: Det ÄR frågan om vi vill böja adjektivskomponenter, men det får än så länge vara upp till användaren
    // Det är lika enkelt att låta bli uppdelningen, och bara böja till slutformen med "orsaksanalytisk-+a"
    // Känns som 
    assertThat(cmdDict.findWord('orsak', &adjective)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('orsaken', &adjective)[1]).isEqualTo(obj);

    assertThat(cmdDict.findWord('analytisk', &adjective)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('analytiska', &adjective)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('orsaksanalytisk', &adjective)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('orsaksanalytiska', &adjective)[1]).isEqualTo(obj);  

    assertThat(cmdDict.findWord('uggla', &noun)[1]).isEqualTo(obj);  
    assertThat(cmdDict.findWord('ugglan', &noun)[1]).isEqualTo(obj);  

    // Räkna antalet _förväntade_ förekomster som finns i cmdDict för detta objekt (oavsett grammatisk form)
    local count = getGrammarPartsFromCmdDict(obj);
    assertThat(count).isEqualTo(8);

    assertThat(obj.isNeuter).isNil();   
    assertThat(obj.isPlural).isNil(); 
    assertThat(obj.definitiveForm).isEqualTo('ugglan'); 
};

// Böja substantiv med foge-S
UnitTest 'initialize neutrum substantiv med +notation och foge-S' run {
    local obj = new Thing();
    obj.vocabWords = 'papper^s+flyg+plan+et';

    // Sut
    obj.initializeVocabWith(obj.vocabWords);

    // Assert
    // tadsSay(getGrammarInfoFromCmdDict(obj));
    assertThat(cmdDict.findWord('papper', &noun)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('papperet', &noun)[1]).isEqualTo(obj);
    
    assertThat(cmdDict.findWord('pappersflyg', &noun)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('pappersflygplan', &noun)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('pappersflygplanet', &noun)[1]).isEqualTo(obj);

    assertThat(cmdDict.findWord('flyg', &noun)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('flyget', &noun)[1]).isEqualTo(obj);

    assertThat(cmdDict.findWord('plan', &noun)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('planet', &noun)[1]).isEqualTo(obj);

    // Räkna antalet _förväntade_ förekomster som finns i cmdDict för detta objekt (oavsett grammatisk form)
    local count = getGrammarPartsFromCmdDict(obj);
    assertThat(count).isEqualTo(9);

    assertThat(obj.isNeuter).isNil();   
    assertThat(obj.isPlural).isNil(); 
    assertThat(obj.name).isEqualTo('pappersflygplan'); 
    assertThat(obj.definitiveForm).isEqualTo('pappersflygplanet'); 
};

// Böja substantiv med foge-S
UnitTest 'initialize utrum substantiv med +notation och foge-S' run {
    local obj = new Thing();
    obj.vocabWords = 'ansvar:et^s+känsla+n';

    // Sut
    obj.initializeVocabWith(obj.vocabWords);

    // Assert
    //tadsSay(getGrammarInfoFromCmdDict(obj));
    assertThat(cmdDict.findWord('ansvar', &noun)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('ansvaret', &noun)[1]).isEqualTo(obj);
    
    assertThat(cmdDict.findWord('ansvarskänsla', &noun)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('ansvarskänslan', &noun)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('känsla', &noun)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('känslan', &noun)[1]).isEqualTo(obj);

    // Räkna antalet _förväntade_ förekomster som finns i cmdDict för detta objekt (oavsett grammatisk form)
    local count = getGrammarPartsFromCmdDict(obj);
    assertThat(count).isEqualTo(6);

    assertThat(obj.isNeuter).isNil();   
    assertThat(obj.isPlural).isNil(); 
    assertThat(obj.name).isEqualTo('ansvarskänsla'); 
    assertThat(obj.definitiveForm).isEqualTo('ansvarskänslan'); 
};


// Böja substantiv med foge-S
UnitTest 'initialize utrum substantiv med +notation' run {
    local obj = new Thing();
    obj.vocabWords = 'cyckel+slang+en';

    // Sut
    obj.initializeVocabWith(obj.vocabWords);

    // Assert
    //tadsSay(getGrammarInfoFromCmdDict(obj));
    assertThat(cmdDict.findWord('cyckel', &noun)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('cyckeln', &noun)[1]).isEqualTo(obj);

    assertThat(cmdDict.findWord('cyckelslang', &noun)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('cyckelslangen', &noun)[1]).isEqualTo(obj);

    assertThat(cmdDict.findWord('slang', &noun)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('slangen', &noun)[1]).isEqualTo(obj);

    // Räkna antalet _förväntade_ förekomster som finns i cmdDict för detta objekt (oavsett grammatisk form)
    local count = getGrammarPartsFromCmdDict(obj);
    assertThat(count).isEqualTo(6);

    assertThat(obj.isNeuter).isNil();   
    assertThat(obj.isPlural).isNil(); 
    assertThat(obj.name).isEqualTo('cyckelslang'); 
    assertThat(obj.definitiveForm).isEqualTo('cyckelslangen'); 
};


UnitTest 'initialize plural utan +notation' run {
    local obj = new Thing();
    obj.vocabWords = 'glass';
    obj.name = 'glass';
    obj.isPlural = true;

    // Sut
    obj.initializeVocabWith(obj.vocabWords);
    //tadsSay(getGrammarInfoFromCmdDict(obj));

    // Assert
    assertThat(cmdDict.findWord('glass', &plural)[1]).isEqualTo(obj);  

    assertThat(obj.isNeuter).isNil();   
    assertThat(obj.isPlural).isTrue();
    //assertThat(obj.definitiveForm).isEqualTo('glass'); 
}; 

UnitTest 'initialize singular utan +notation' run {
    local obj = new Thing();
    obj.vocabWords = 'grävling';
    obj.name = 'grävling';
    obj.isPlural = nil;

    // Sut
    obj.initializeVocabWith(obj.vocabWords);
    //tadsSay(getGrammarInfoFromCmdDict(obj));

    // Assert
    assertThat(cmdDict.findWord('grävling', &noun)[1]).isEqualTo(obj);  

    assertThat(obj.isNeuter).isNil();   
    assertThat(obj.isPlural).isNil();
    //assertThat(obj.definitiveForm).isEqualTo('grävling'); 
}; 


UnitTest 'initialize plural med +notation' run {
    local obj = new Thing();
    obj.vocabWords = 'stolar+na';
    obj.name = 'stolarna';
    obj.isPlural = true;

    // Sut
    obj.initializeVocabWith(obj.vocabWords);
    // tadsSay(getGrammarInfoFromCmdDict(obj));

    // Assert
    assertThat(cmdDict.findWord('stolar', &plural)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('stolarna', &plural)[1]).isEqualTo(obj);  

    assertThat(obj.isNeuter).isNil();   
    assertThat(obj.isPlural).isTrue();
    assertThat(obj.definitiveForm).isEqualTo('stolarna'); 

}; 



UnitTest 'initialize stege (en-ord) utan +notation' run {

    local ladder = new Thing();
    ladder.vocabWords = 'ranglig rangliga stege/stegen*stegar';
    ladder.name = 'stege';

    // OBS: Den definitiva formen härleds inte i den enkla varianten utan +notation, det får man sätta dit själv 
    ladder.definitiveForm = 'stegen';

    // OBS: neutrum härleds inte i den enkla varianten utan +notation, det får man sätta dit själv
    ladder.isNeuter = true;

    // Sut 
    ladder.initializeVocabWith(ladder.vocabWords);
    
    // Assert
    //tadsSay(getGrammarInfoFromCmdDict(ladder));
    
    assertThat(cmdDict.findWord('ranglig', &adjective)[1]).isEqualTo(ladder);  
    assertThat(cmdDict.findWord('rangliga', &adjective)[1]).isEqualTo(ladder);  

    assertThat(cmdDict.findWord('stege', &noun)[1]).isEqualTo(ladder);  
    assertThat(cmdDict.findWord('stegen', &noun)[1]).isEqualTo(ladder);

    assertThat(cmdDict.findWord('stegar', &plural)[1]).isEqualTo(ladder);

    // Räkna antalet _förväntade_ förekomster som finns i cmdDict för detta objekt (oavsett grammatisk form)
    local count = getGrammarPartsFromCmdDict(ladder); 
    assertThat(count).isEqualTo(5);

    assertThat(ladder.isNeuter).isTrue(); 
    assertThat(ladder.isPlural).isNil(); 
    assertThat(ladder.theName).isEqualTo('stegen'); 
    assertThat(ladder.definitiveForm).isEqualTo('stegen'); 
    
};

UnitTest 'initialize äpple (ett-ord) utan +notation' run {

    local leafSimple = new Thing();
    leafSimple.vocabWords = 'gröna blad/bladet/grönsak*bladen grönsaker';
    leafSimple.name = 'blad';

    // OBS: Den definitiva formen härleds inte i den enkla varianten utan +notation, det får man sätta dit själv 
    leafSimple.definitiveForm = 'bladet';

    // OBS: neutrum härleds inte i den enkla varianten utan +notation, det får man sätta dit själv
    leafSimple.isNeuter = true;

    // Sut 
    leafSimple.initializeVocabWith(leafSimple.vocabWords);
    
    // Assert
    //tadsSay(getGrammarInfoFromCmdDict(leafSimple));
    
    assertThat(cmdDict.findWord('gröna', &adjective)[1]).isEqualTo(leafSimple);  

    assertThat(cmdDict.findWord('blad', &noun)[1]).isEqualTo(leafSimple);  
    assertThat(cmdDict.findWord('bladet', &noun)[1]).isEqualTo(leafSimple);
    assertThat(cmdDict.findWord('grönsak', &noun)[1]).isEqualTo(leafSimple);

    assertThat(cmdDict.findWord('bladen', &plural)[1]).isEqualTo(leafSimple);
    assertThat(cmdDict.findWord('grönsaker', &plural)[1]).isEqualTo(leafSimple);

    // Räkna antalet _förväntade_ förekomster som finns i cmdDict för detta objekt (oavsett grammatisk form)
    local count = getGrammarPartsFromCmdDict(leafSimple); 
    assertThat(count).isEqualTo(6);

    assertThat(leafSimple.isNeuter).isTrue(); 
    assertThat(leafSimple.isPlural).isNil(); 
    assertThat(leafSimple.theName).isEqualTo('bladet'); 
    assertThat(leafSimple.definitiveForm).isEqualTo('bladet'); 
    
};




/**
 * Returnerar en sträng med grammatiska delar av ett objekt:
 * adjektiv, substantiv och plural.
 */ 
function getGrammarInfoFromCmdDict(o) {
    local str = new StringBuffer();
    str.append('\n');
    cmdDict.forEachWord(function(obj, word, wordPart) {
        if(obj == o) {
            local grammarFunction = 'unknown';
            if(wordPart == &noun) grammarFunction = 'substantiv';
            else if(wordPart == &plural) grammarFunction = 'plural';
            else if(wordPart == &adjective) grammarFunction = 'adjektiv';
            str.append('<<word>> (<<grammarFunction>>) \n');
        }
    });
    str.append('\b');
    return toString(str);
}

/**
 * Returnerar antalet grammatiska delar av ett objekt: DVS alla förekomster av olika adjektiv,
 * substantiv och plural som refererar till detta objekt i cmdDict
 */ 
function getGrammarPartsFromCmdDict(o) {
    local count = 0;
    cmdDict.forEachWord(function(obj, word, wordPart) {
        if(obj == o) {
          count++;
        }
    });
    return count;
 }