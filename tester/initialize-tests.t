#charset "utf-8"
#include <adv3.h>
#include <sv_se.h> 
#include "testunit.h"

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


TestUnit 'initialize äpple med +notation (ett-ord)' run {

    local appleAvancerat = new Thing();
    appleAvancerat.vocabWords = 'rö:tt+da smakfull:t+a äpple+t/frukt+en*äpplen+a frukter+na';
    appleAvancerat.name = 'äpple';

    // Sut
    appleAvancerat.initializeVocabWith(appleAvancerat.vocabWords);

    // Assert
    //tadsSay(getGrammarInfoFromCmdDict(appleAvancerat));
    assertThat(cmdDict.findWord('röda', &adjective)[1]).isEqualTo(appleAvancerat);
    assertThat(cmdDict.findWord('rött', &adjective)[1]).isEqualTo(appleAvancerat);
    assertThat(cmdDict.findWord('smakfulla', &adjective)[1]).isEqualTo(appleAvancerat);  
    assertThat(cmdDict.findWord('smakfullt', &adjective)[1]).isEqualTo(appleAvancerat);  

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
    assertThat(count).isEqualTo(12);

    assertThat(appleAvancerat.isNeuter).isNil(); // Härleds från den bestämda formen av äpple+t
    assertThat(appleAvancerat.isPlural).isNil(); 
    assertThat(appleAvancerat.definiteForm).isEqualTo('äpplet'); 

};

TestUnit 'initialize dörr med +notation (en-ord)' run {
    local obj = new Thing();
    obj.vocabWords = 'rustik+a gam:malt+la gammelmodig+a dörr+en/port+en*dörrar+na portar+na';
    obj.name = 'dörr';

    // Sut
    obj.initializeVocabWith(obj.vocabWords);

    // Assert
    // tadsSay(getGrammarInfoFromCmdDict(obj));
    assertThat(cmdDict.findWord('rustik', &adjective)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('rustika', &adjective)[1]).isEqualTo(obj);

    assertThat(cmdDict.findWord('gamla', &adjective)[1]).isEqualTo(obj);  
    assertThat(cmdDict.findWord('gammalt', &adjective)[1]).isEqualTo(obj);  
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
    assertThat(count).isEqualTo(14);

    assertThat(obj.isNeuter).isNil();   
    assertThat(obj.isPlural).isNil(); 
    assertThat(obj.definiteForm).isEqualTo('dörren'); 

};

TestUnit 'initialize tranbärsjuice med +notation (en-ord)' run {
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
    assertThat(obj.definiteForm).isEqualTo('tranbärsjuicen'); 
};

// Böja adjektiv med foge-S
TestUnit 'initialize adjektiv med +notation och foge-S' run {
    local obj = new Thing();
    obj.vocabWords = 'orsak^s+analytisk+a uggla+n';
    obj.name = 'uggla';
    obj.definiteForm = 'ugglan';

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
    assertThat(obj.definiteForm).isEqualTo('ugglan'); 
};

// Böja substantiv med foge-S
TestUnit 'initialize neutrum substantiv med +notation och foge-S' run {
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
    assertThat(obj.definiteForm).isEqualTo('pappersflygplanet'); 
};

TestUnit 'initialize utrum substantiv med +notation och foge-S' run {
    local obj = new Thing();
    obj.vocabWords = 'kartong^s+låda+n*kartong:erna^s+lådor+na';

    // Sut
    obj.initializeVocabWith(obj.vocabWords);

    // Assert
    //tadsSay(getGrammarInfoFromCmdDict(obj));

    assertThat(cmdDict.findWord('låda', &noun)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('lådan', &noun)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('kartongslådan', &noun)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('kartongslåda', &noun)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('kartongen', &noun)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('kartong', &noun)[1]).isEqualTo(obj);

    assertThat(cmdDict.findWord('kartongslådorna', &plural)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('kartongslådor', &plural)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('kartongerna', &plural)[1]).isEqualTo(obj);

    assertThat(cmdDict.findWord('lådor', &plural)[1]).isEqualTo(obj);

    // Räkna antalet _förväntade_ förekomster som finns i cmdDict för detta objekt (oavsett grammatisk form)
    local count = getGrammarPartsFromCmdDict(obj);
    assertThat(count).isEqualTo(12);

    assertThat(obj.isNeuter).isNil();   
    assertThat(obj.isPlural).isNil(); 
    assertThat(obj.name).isEqualTo('kartongslåda'); 
    assertThat(obj.definiteForm).isEqualTo('kartongslådan'); 
};

/*
TestUnit 'initialize utrum substantiv med +notation och foge-S' run {
    local obj = new Thing();
    obj.vocabWords = 'schablon:en+målad+e*bokstäver+na "dei" dei';

    // Sut
    obj.initializeVocabWith(obj.vocabWords);

    // Assert
    tadsSay(getGrammarInfoFromCmdDict(obj));

    assertThat(cmdDict.findWord('bokstäver', &plural)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('bokstäverna', &plural)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('dei', &plural)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('dei', &literalAdjective)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('målad', &noun)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('målade', &noun)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('schablon', &noun)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('schablonen', &noun)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('schablonmålad', &noun)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('schablonmålade', &noun)[1]).isEqualTo(obj);

    // Räkna antalet _förväntade_ förekomster som finns i cmdDict för detta objekt (oavsett grammatisk form)
    local count = getGrammarPartsFromCmdDict(obj);
    assertThat(count).isEqualTo(10);

    assertThat(obj.isNeuter).isNil();   
    assertThat(obj.isPlural).isNil(); 
    assertThat(obj.name).isEqualTo('schablonmålad'); 
    assertThat(obj.definiteForm).isEqualTo('schablonmålade'); 
};*/


/*
+ Distant 'rundad+e svag:t+a sluttande tak+et/platta+n*plattor+na/terrakotta:n+plattor+na' 'tak'
platta (substantiv)
plattan (substantiv)
plattor (plural)
plattor (substantiv)
plattorna (plural)
plattorna (substantiv)
rundad (adjektiv)
rundade (adjektiv)
sluttande (adjektiv)
svag (adjektiv)
svaga (adjektiv)
svagt (adjektiv)
tak (substantiv)
taket (substantiv)
terrakotta (substantiv)
terrakottan (substantiv)
terrakottaplattor (substantiv)
terrakottaplattorna (substantiv)


+ khakis: AlwaysWorn 'par byxa+n*khakis:+byxor+na slacks chinos byxor+na' 'par khakis'
byxan (substantiv)
byxor (plural)
par (adjektiv)
khakisbyxor (plural)
khakisbyxorna (plural)
khakis (plural)
slacks (plural)
chinos (plural)
byxorna (plural)
byxa (substantiv)

FIXME:
+++ Component '(råtta) (docka) (handdocka) hand råttans öppning handrått:an^s+dock:an^s+öppning+en' 'handråttsdocksöppning'
theName: “handråttsdocksöppningen”
aName: “en handråttsdocksöppning”

Följande ord finns definierade:

dock (substantiv)
docka (adjektiv)
dockan (substantiv)
hand (adjektiv)
handdocka (adjektiv)
handrått (substantiv)
handråttan (substantiv)
handråttsdock (substantiv)
handråttsdocksöppning (substantiv)
handråttsdocksöppningen (substantiv)
råtta (adjektiv)
råttans (adjektiv)
öppning (adjektiv)
öppning (substantiv)
öppningen (substantiv)

*/



// TODO: se om literalAdjective går att laga till så det fungerar med combineVocabWords
// TODO: tester med "-" och "(xyzzy)"

// Böja substantiv med foge-S
TestUnit 'initialize utrum substantiv med +notation och foge-S' run {
    local obj = new Thing();
    obj.vocabWords = 'ansvar:et^s+känsla+n';

    // Sut
    obj.initializeVocabWith(obj.vocabWords);

    // Assert
    // tadsSay(getGrammarInfoFromCmdDict(obj));
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
    assertThat(obj.definiteForm).isEqualTo('ansvarskänslan'); 
};


// Böja substantiv med foge-S
TestUnit 'initialize utrum substantiv med +notation' run {
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
    assertThat(obj.definiteForm).isEqualTo('cyckelslangen'); 
};


TestUnit 'initialize plural utan +notation' run {
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
    //assertThat(obj.definiteForm).isEqualTo('glass'); 
}; 

TestUnit 'initialize singular utan +notation' run {
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
    //assertThat(obj.definiteForm).isEqualTo('grävling'); 
}; 


TestUnit 'initialize plural med +notation' run {
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
    assertThat(obj.definiteForm).isEqualTo('stolarna'); 

}; 



TestUnit 'initialize stege (en-ord) utan +notation' run {

    local ladder = new Thing();
    ladder.vocabWords = 'ranglig rangliga stege/stegen*stegar';
    ladder.name = 'stege';

    // OBS: Den definitiva formen härleds inte i den enkla varianten utan +notation, det får man sätta dit själv 
    ladder.definiteForm = 'stegen';

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
    assertThat(ladder.definiteForm).isEqualTo('stegen'); 
    
};

TestUnit 'initialize äpple (ett-ord) utan +notation' run {

    local leafSimple = new Thing();
    leafSimple.vocabWords = 'gröna blad/bladet/grönsak*bladen grönsaker';
    leafSimple.name = 'blad';

    // OBS: Den definitiva formen härleds inte i den enkla varianten utan +notation, det får man sätta dit själv 
    leafSimple.definiteForm = 'bladet';

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
    assertThat(leafSimple.definiteForm).isEqualTo('bladet');   
};

TestUnit 'initialize ord utan sammansättningar av individuella delar' run {
    // I detta exempel vill vi inte skapa upp separata ord för de individuella delarna
    // Så då används | istället +
    // Vi kommer alltså inte se: "gitarr, gitarren" som synonymer
    // utan endast: "fodral, fodralet, gitarrfodral, gitarrfodralet"

    local gitarrfodralet = new Thing();
    gitarrfodralet.vocabWords = 'gitarr|fodral+et'; 
    gitarrfodralet.name = 'gitarrfodral';
    gitarrfodralet.initializeVocabWith(gitarrfodralet.vocabWords);
    gitarrfodralet.isNeuter = true; // Härleds inte i testerna, men behöver inte sättas annars
    
    // Assert
    //tadsSay(getGrammarInfoFromCmdDict(gitarrfodralet));
    
    assertThat(cmdDict.findWord('gitarrfodral', &noun)[1]).isEqualTo(gitarrfodralet);  
    assertThat(cmdDict.findWord('gitarrfodralet', &noun)[1]).isEqualTo(gitarrfodralet);  
    assertThat(cmdDict.findWord('fodral', &noun)[1]).isEqualTo(gitarrfodralet);
    assertThat(cmdDict.findWord('fodralet', &noun)[1]).isEqualTo(gitarrfodralet);

    // Räkna antalet _förväntade_ förekomster som finns i cmdDict för detta objekt (oavsett grammatisk form)
    local count = getGrammarPartsFromCmdDict(gitarrfodralet); 
    assertThat(count).isEqualTo(4);

    assertThat(gitarrfodralet.isNeuter).isTrue(); 
    assertThat(gitarrfodralet.isPlural).isNil(); 
    assertThat(gitarrfodralet.aName).isEqualTo('ett gitarrfodral'); 
    assertThat(gitarrfodralet.theName).isEqualTo('gitarrfodralet'); 
    assertThat(gitarrfodralet.definiteForm).isEqualTo('gitarrfodralet'); 
    
};


TestUnit 'initialize vatten isMassNoun=true' run {
    local vatten = new Thing();
    vatten.vocabWords = 'vatten/vattnet*vatten';
    vatten.definiteForm = 'vattnet';
    vatten.isMassNoun = true;
    vatten.isPlural = true;
    vatten.isNeuter = true;

    // Sut 
    vatten.initializeVocabWith(vatten.vocabWords);
    
    // Assert
    //tadsSay(getGrammarInfoFromCmdDict(vatten));
    local count = getGrammarPartsFromCmdDict(vatten); 
    assertThat(count).isEqualTo(3);

    assertThat(vatten.isNeuter).isTrue(); 
    
    // Fundera på att ta bort artikeln helt och hållet vid isMassNoun = true
    assertThat(vatten.aName).isEqualTo('vatten'); 
    //assertThat(vatten.aName).isEqualTo('lite vatten'); 

    assertThat(vatten.theName).isEqualTo('vattnet'); 
    assertThat(vatten.definiteForm).isEqualTo('vattnet'); 
    
};


TestUnit 'initialize vatten isMassNoun=true' run {
    local obj = new Thing();
    obj.vocabWords = 'skor+na*skor';
    obj.definiteForm = 'skorna';
    obj.isPlural = true;

    // Sut 
    obj.initializeVocabWith(obj.vocabWords);
    
    // Assert
    //tadsSay(getGrammarInfoFromCmdDict(obj));
    local count = getGrammarPartsFromCmdDict(obj); 
    assertThat(count).isEqualTo(3);

    assertThat(obj.isNeuter).isNil(); 
    assertThat(obj.aName).isEqualTo('några skor'); 
    assertThat(obj.theName).isEqualTo('skorna'); 
    
};

TestUnit 'createCompoundWordVariations substantiv' run {
    local dummy = new Thing();
    local forms = createCompoundWordVariations(dummy, 'virke+t', &noun);
    assertThat(forms.definiteForm).isEqualTo('virket');
    assertThat(forms.standardForm).isEqualTo('virke');
    assertThat(cmdDict.findWord('virke', &noun)[1]).isEqualTo(dummy);
    assertThat(cmdDict.findWord('virket', &noun)[1]).isEqualTo(dummy);
    cleanUp(dummy);
};

TestUnit 'createCompoundWordVariations, hantera "n"-ändelse' run {
    local dummy = new Thing();
    local forms = createCompoundWordVariations(dummy, 'cykel:n+lås+et', &noun);
    //tadsSay(getGrammarInfoFromCmdDict(dummy));
    assertThat(forms.standardForm).isEqualTo('cykellås');
    assertThat(forms.definiteForm).isEqualTo('cykellåset');
    assertThat(cmdDict.findWord('cykel', &noun)[1]).isEqualTo(dummy);
    assertThat(cmdDict.findWord('cykellås', &noun)[1]).isEqualTo(dummy);
    assertThat(cmdDict.findWord('cykellåset', &noun)[1]).isEqualTo(dummy);
    assertThat(cmdDict.findWord('cykellåset', &noun)[1]).isEqualTo(dummy);
    assertThat(cmdDict.findWord('cykeln', &noun)[1]).isEqualTo(dummy);
    assertThat(cmdDict.findWord('lås', &noun)[1]).isEqualTo(dummy);
    assertThat(cmdDict.findWord('låset', &noun)[1]).isEqualTo(dummy);
    cleanUp(dummy);
};


TestUnit 'createCompoundWordVariations, hantera "er/ret"-ändelser' run {
    local dummy = new Thing();
    local forms = createCompoundWordVariations(dummy, 'fönst:er+ret', &noun);
    //tadsSay(getGrammarInfoFromCmdDict(dummy));
    assertThat(forms.standardForm).isEqualTo('fönster');
    assertThat(forms.definiteForm).isEqualTo('fönstret');
    assertThat(cmdDict.findWord('fönster', &noun)[1]).isEqualTo(dummy);
    assertThat(cmdDict.findWord('fönstret', &noun)[1]).isEqualTo(dummy);
    cleanUp(dummy);
}
;


TestUnit 'createCompoundWordVariations, hantera ": utan foge-S " ger en ändelsefri variant' run {
    local dummy = new Thing();
    local forms = createCompoundWordVariations(dummy, 'video:+förstärkare+n', &noun);
    //tadsSay(getGrammarInfoFromCmdDict(dummy));
    assertThat(forms.standardForm).isEqualTo('videoförstärkare');
    assertThat(forms.definiteForm).isEqualTo('videoförstärkaren');
    assertThat(cmdDict.findWord('video', &noun)[1]).isEqualTo(dummy);
    assertThat(cmdDict.findWord('förstärkaren', &noun)[1]).isEqualTo(dummy);
    assertThat(cmdDict.findWord('videoförstärkare', &noun)[1]).isEqualTo(dummy);
    assertThat(cmdDict.findWord('videoförstärkaren', &noun)[1]).isEqualTo(dummy);
    //TODO:  räkna samman
    cleanUp(dummy);
}
;

TestUnit 'createCompoundWordVariations, tar bort mer än tre upprepande boktstäver' run {
    local dummy = new Thing();
    local forms = createCompoundWordVariations(dummy, 'kastrull:en+lock+et', &noun);
    //tadsSay(getGrammarInfoFromCmdDict(dummy));
    assertThat(forms.definiteForm).isEqualTo('kastrullocket');
    assertThat(forms.standardForm).isEqualTo('kastrullock');
    assertThat(cmdDict.findWord('kastrull', &noun)[1]).isEqualTo(dummy);
    assertThat(cmdDict.findWord('kastrullen', &noun)[1]).isEqualTo(dummy);
    cleanUp(dummy);
};


TestUnit 'createCompoundWordVariations, ta inte bort mer än tre upprepande bokstäver' run {
    local dummy = new Thing();
    // OBS: sätts i ett spel på själva objektet enligt följande. metoden anropas med detta värde som parameter
    // dummy.enableShortenRepeatingCharacters = nil 
    local forms = createCompoundWordVariations(dummy, 'www-sida+n', &noun, nil); // Sätts direkt till nil här
    //tadsSay(getGrammarInfoFromCmdDict(dummy));
    assertThat(forms.standardForm).isEqualTo('www-sida');
    assertThat(forms.definiteForm).isEqualTo('www-sidan');
    assertThat(cmdDict.findWord('www-sida', &noun)[1]).isEqualTo(dummy);
    assertThat(cmdDict.findWord('www-sidan', &noun)[1]).isEqualTo(dummy);
    cleanUp(dummy);
};



TestUnit 'shortenRepeatingCharacters, testa att förkortningar görs så vi aldrig har mer än tre repeterande bokstäver i följd' run {
    assertThat(shortenRepeatingCharacters('bussstation')).isEqualTo('busstation');
    assertThat(shortenRepeatingCharacters('glassskopa')).isEqualTo('glasskopa');
};


TestUnit 'compundWords med literalAdjective' run {
    local obj = new Thing();
    obj.vocabWords = '"0001" (grönsak+en) (frukt+en) "först:+plockad+e"  (rot+en) "röd+a" jordgubbe+n';

    // Sut
    obj.initializeVocabWith(obj.vocabWords);

    // Assert
    // tadsSay(getGrammarInfoFromCmdDict(obj));
    assertThat(cmdDict.findWord('röd', &literalAdjective)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('röda', &literalAdjective)[1]).isEqualTo(obj);

    assertThat(cmdDict.findWord('jordgubbe', &noun)[1]).isEqualTo(obj);
    assertThat(cmdDict.findWord('jordgubben', &noun)[1]).isEqualTo(obj);
    

    // Räkna antalet _förväntade_ förekomster som finns i cmdDict för detta objekt (oavsett grammatisk form)
    //local count = getGrammarPartsFromCmdDict(obj);
    //assertThat(count).isEqualTo(4);

    //assertThat(obj.name).isEqualTo('jordgubbe'); 
    //assertThat(obj.definiteForm).isEqualTo('jordgubben'); 
};



function cleanUp(obj) {
    local a = new LookupTable();
    cmdDict.forEachWord(function(o, word, wordPart) {
        if(obj == o) {
          a[word] = wordPart;
        }
    });
    a.forEachAssoc(function(word, wordPart) {
        //tadsSay('\nTar bort association mellan <<word>> (<<wordPart>>) och <<obj>>\n');
        cmdDict.removeWord(obj, word, wordPart);
    });
}

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
            else if(wordPart == &literalAdjective) grammarFunction = 'literalAdjective';
            else if(wordPart == &adjApostS) grammarFunction = 'adjApostS';
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