#charset "utf-8"

/*
 *   Copyright 2000, 2006 Michael J. Roberts.  All Rights Reserved.
 *.  Past-tense extensions written by Michel Nizette, and incorporated by
 *   permission.
 *   
 *   TADS 3 Library - English (United States variant) implementation
 *   
 *   This defines the parts of the TADS 3 library that are specific to the
 *   English language as spoken (and written) in the United States.
 *   
 *   We have attempted to isolate here the parts of the library that are
 *   language-specific, so that translations to other languages or dialects
 *   can be created by replacing this module, without changing the rest of
 *   the library.
 *   
 *   In addition to this module, a separate set of US English messages are
 *   defined in the various msg_xxx.t modules.  Those modules define
 *   messages in English for different stylistic variations.  For a given
 *   game, the author must select one of the message modules - but only
 *   one, since they all define variations of the same messages.  To
 *   translate the library, a translator must create at least one module
 *   defining those messages as well; only one message module is required
 *   per language.
 *   
 *   The past-tense system was contributed by Michel Nizette.
 *   
 *.                                  -----
 *   
 *   "Watch an immigrant struggling with a second language or a stroke
 *   patient with a first one, or deconstruct a snatch of baby talk, or try
 *   to program a computer to understand English, and ordinary speech
 *   begins to look different."
 *   
 *.         Stephen Pinker, "The Language Instinct"
 */

#include "tads.h"
#include "tok.h"
#include "adv3.h"
#include "sv_se.h"
#include <vector.h>
#include <dict.h>
#include <gramprod.h>
#include <strcomp.h>


/* ------------------------------------------------------------------------ */
/*
 *   Fill in the default language for the GameInfo metadata class.
 */
modify GameInfoModuleID
    languageCode = 'sv-SE'
;

/* ------------------------------------------------------------------------ */
/*
 *   Simple yes/no confirmation.  The caller must display a prompt; we'll
 *   read a command line response, then return true if it's an affirmative
 *   response, nil if not.
 */
yesOrNo()
{
    /* switch to no-command mode for the interactive input */
    "<.commandnone>";

    /*
     *   Read a line of input.  Do not allow real-time event processing;
     *   this type of prompt is used in the middle of a command, so we
     *   don't want any interruptions.  Note that the caller must display
     *   any desired prompt, and since we don't allow interruptions, we
     *   won't need to redisplay the prompt, so we pass nil for the prompt
     *   callback.
     */
    local str = inputManager.getInputLine(nil, nil);

    /* switch back to mid-command mode */
    "<.commandmid>";

    /*
     *   If they answered with something starting with 'Y', it's
     *   affirmative, otherwise it's negative.  In reading the response,
     *   ignore any leading whitespace.
     */
    return rexMatch('<space>*[jJ]', str) != nil;
}

/* ------------------------------------------------------------------------ */
/*
 *   During start-up, install a case-insensitive truncating comparator in
 *   the main dictionary.
 */
PreinitObject
    execute()
    {
        /* set up the main dictionary's comparator */
        languageGlobals.setStringComparator(
            new StringComparator(gameMain.parserTruncLength, nil, []));
    }

    /*
     *   Make sure we run BEFORE the main library preinitializer, so that
     *   we install the comparator in the dictionary before we add the
     *   vocabulary words to the dictionary.  This doesn't make any
     *   difference in terms of the correctness of the dictionary, since
     *   the dictionary will automatically rebuild itself whenever we
     *   install a new comparator, but it makes the preinitialization run
     *   a tiny bit faster by avoiding that rebuild step.
     */
    execAfterMe = [adv3LibPreinit]
;

/* ------------------------------------------------------------------------ */
/*
 *   Language-specific globals
 */
languageGlobals: object
    /*
     *   Set the StringComparator object for the parser.  This sets the
     *   comparator that's used in the main command parser dictionary. 
     */
    setStringComparator(sc)
    {
        /* remember it globally, and set it in the main dictionary */
        dictComparator = sc;
        cmdDict.setComparator(sc);
    }

    /*
     *   The character to use to separate groups of digits in large
     *   numbers.  US English uses commas; most Europeans use periods.
     *
     *   Note that this setting does not affect system-level BigNumber
     *   formatting, but this information can be passed when calling
     *   BigNumber formatting routines.
     */
    digitGroupSeparator = '.'

    /*
     *   The decimal point to display in floating-point numbers.  US
     *   English uses a period; most Europeans use a comma.
     *
     *   Note that this setting doesn't affect system-level BigNumber
     *   formatting, but this information can be passed when calling
     *   BigNumber formatting routines.
     */
    decimalPointCharacter = ','

    /* the main dictionary's string comparator */
    dictComparator = nil
;


/* ------------------------------------------------------------------------ */
/*
 *   Language-specific extension of the default gameMain object
 *   implementation.
 */
modify GameMainDef
    /*
     *   Option setting: the parser's truncation length for player input.
     *   As a convenience to the player, we can allow the player to
     *   truncate long words, entering only the first, say, 6 characters.
     *   For example, rather than typing "x flashlight", we could allow the
     *   player to simply type "x flashl" - truncating "flashlight" to six
     *   letters.
     *   
     *   We use a default truncation length of 6, but games can change this
     *   by overriding this property in gameMain.  We use a default of 6
     *   mostly because that's what the old Infocom games did - many
     *   long-time IF players are accustomed to six-letter truncation from
     *   those games.  Shorter lengths are superficially more convenient
     *   for the player, obviously, but there's a trade-off, which is that
     *   shorter truncation lengths create more potential for ambiguity.
     *   For some games, a longer length might actually be better for the
     *   player, because it would reduce spurious ambiguity due to the
     *   parser matching short input against long vocabulary words.
     *   
     *   If you don't want to allow the player to truncate long words at
     *   all, set this to nil.  This will require the player to type every
     *   word in its entirety.
     *   
     *   Note that changing this property dynamicaly will have no effect.
     *   The library only looks at it once, during library initialization
     *   at the very start of the game.  If you want to change the
     *   truncation length dynamically, you must instead create a new
     *   StringComparator object with the new truncation setting, and call
     *   languageGlobals.setStringComparator() to select the new object.  
     */
    parserTruncLength = 6

    /*
     *   Option: are we currently using a past tense narrative?  By
     *   default, we aren't.
     *
     *   This property can be reset at any time during the game in order to
     *   switch between the past and present tenses.  The macro
     *   setPastTense can be used for this purpose: it just provides a
     *   shorthand for setting gameMain.usePastTense directly.
     *
     *   Authors who want their game to start in the past tense can achieve
     *   this by overriding this property on their gameMain object and
     *   giving it a value of true.
     */
    usePastTense = nil
;


/* ------------------------------------------------------------------------ */
/*
 *   Language-specific modifications for ThingState.
 */
modify ThingState
    /*
     *   Our state-specific tokens.  This is a list of vocabulary words
     *   that are state-specific: that is, if a word is in this list, the
     *   word can ONLY refer to this object if the object is in a state
     *   with that word in its list.
     *   
     *   The idea is that you set up the object's "static" vocabulary with
     *   the *complete* list of words for all of its possible states.  For
     *   example:
     *   
     *.     + Matchstick 'lit unlit match';
     *   
     *   Then, you define the states: in the "lit" state, the word 'lit' is
     *   in the stateTokens list; in the "unlit" state, the word 'unlit' is
     *   in the list.  By putting the words in the state lists, you
     *   "reserve" the words to their respective states.  When the player
     *   enters a command, the parser will limit object matches so that the
     *   reserved state-specific words can only refer to objects in the
     *   corresponding states.  Hence, if the player refers to a "lit
     *   match", the word 'lit' will only match an object in the "lit"
     *   state, because 'lit' is a reserved state-specific word associated
     *   with the "lit" state.
     *   
     *   You can re-use a word in multiple states.  For example, you could
     *   have a "red painted" state and a "blue painted" state, along with
     *   an "unpainted" state.
     */
    stateTokens = []

    /*
     *   Match the name of an object in this state.  We'll check the token
     *   list for any words that apply only to *other* states the object
     *   can assume; if we find any, we'll reject the match, since the
     *   phrase must be referring to an object in a different state.
     */
    matchName(obj, origTokens, adjustedTokens, states)
    {
        /* scan each word in our adjusted token list */
        for (local i = 1, local len = adjustedTokens.length() ;
             i <= len ; i += 2)
        {
            /* get the current token */
            local cur = adjustedTokens[i];

            /*
             *   If this token is in our own state-specific token list,
             *   it's acceptable as a match to this object.  (It doesn't
             *   matter whether or not it's in any other state's token list
             *   if it's in our own, because its presence in our own makes
             *   it an acceptable matching word when we're in this state.) 
             */
            if (stateTokens.indexWhich({t: t == cur}) != nil)
                continue;

            /*
             *   It's not in our own state-specific token list.  Check to
             *   see if the word appears in ANOTHER state's token list: if
             *   it does, then this word CAN'T match an object in this
             *   state, because the token is special to that other state
             *   and thus can't refer to an object in a state without the
             *   token. 
             */
            if (states.indexWhich(
                {s: s.stateTokens.indexOf(cur) != nil}) != nil)
                return nil;
        }

        /* we didn't find any objection, so we can match this phrase */
        return obj;
    }

    /*
     *   Check a token list for any tokens matching any of our
     *   state-specific words.  Returns true if we find any such words,
     *   nil if not.
     *
     *   'toks' is the *adjusted* token list used in matchName().
     */
    findStateToken(toks)
    {
        /*
         *   Scan the token list for a match to any of our state-specific
         *   words.  Since we're using the adjusted token list, every
         *   other entry is a part of speech, so work through the list in
         *   pairs.
         */
        for (local i = 1, local len = toks.length() ; i <= len ; i += 2)
        {
            /*
             *   if this token matches any of our state tokens, indicate
             *   that we found a match
             */
            if (stateTokens.indexWhich({x: x == toks[i]}) != nil)
                return true;
        }

        /* we didn't find a match */
        return nil;
    }

    /* get our name */
    listName(lst) { return listName_; }

    /*
     *   our list name setting - we define this so that we can be easily
     *   initialized with a template (we can't initialize listName()
     *   directly in this manner because it's a method, but we define the
     *   listName() method to simply return this property value, which we
     *   can initialize with a template)
     */
    listName_ = nil
;

/* ------------------------------------------------------------------------ */
/*
 *   Language-specific modifications for VocabObject.
 */
modify VocabObject
    /*
     *   The vocabulary initializer string for the object - this string
     *   can be initialized (most conveniently via a template) to a string
     *   of this format:
     *
     *   'adj adj adj noun/noun/noun*plural plural plural'
     *
     *   The noun part of the string can be a hyphen, '-', in which case
     *   it means that the string doesn't specify a noun or plural at all.
     *   This can be useful when nouns and plurals are all inherited from
     *   base classes, and only adjectives are to be specified.  (In fact,
     *   any word that consists of a single hyphen will be ignored, but
     *   this is generally only useful for the adjective-only case.)
     *
     *   During preinitialization, we'll parse this string and generate
     *   dictionary entries and individual vocabulary properties for the
     *   parts of speech we find.
     *
     *   Note that the format described above is specific to the English
     *   version of the library.  Non-English versions will probably want
     *   to use different formats to conveniently encode appropriate
     *   language-specific information in the initializer string.  See the
     *   comments for initializeVocabWith() for more details.
     *
     *   You can use the special wildcard # to match any numeric
     *   adjective.  This only works as a wildcard when it stands alone,
     *   so a string like "7#" is matched as that literal string, not as a
     *   wildcard.  If you want to use a pound sign as a literal
     *   adjective, just put it in double quotes.
     *
     *   You can use the special wildcard "\u0001" (include the double
     *   quotes within the string) to match any literal adjective.  This
     *   is the literal adjective equivalent of the pound sign.  We use
     *   this funny character value because it is unlikely ever to be
     *   interesting in user input.
     *
     *   If you want to match any string for a noun and/or adjective, you
     *   can't do it with this property.  Instead, just add the property
     *   value noun='*' to the object.
     */
    vocabWords = ''

    /*
     *   On dynamic construction, initialize our vocabulary words and add
     *   them to the dictionary.
     */
    construct()
    {
        /* initialize our vocabulary words from vocabWords */
        initializeVocab();
        
        /* add our vocabulary words to the dictionary */
        addToDictionary(&noun);
        addToDictionary(&adjective);
        addToDictionary(&plural);
        addToDictionary(&adjApostS);
        addToDictionary(&literalAdjective);
    }

    /* add the words from a dictionary property to the global dictionary */
    addToDictionary(prop)
    {
        /* if we have any words defined, add them to the dictionary */
        if (self.(prop) != nil)
            cmdDict.addWord(self, self.(prop), prop);
    }

    /* initialize the vocabulary from vocabWords */
    initializeVocab()
    {
        local isNeuterDefinedAlready = propDefined(&isNeuter, PropDefDirectly);
        /*
        #ifdef __DEBUG
            if(isNeuterDefinedAlready) {
                tadsSay('<<self>>: isNeuter is set on directly, no override\n');
            }
        #endif
        */

        /* inherit vocabulary from this class and its superclasses */
        inheritVocab(self, new Vector(10));

        // Om neutrum inte är definierat av användaren direkt på objektet
        // så försöker vi härleda det ur den definitiva formen.
        // Om den definitiva formen slutar på -n eller -na så är det utrum,
        // vi flippar om detta till inversen för neutrum.
        if(!isNeuterDefinedAlready && definiteForm) {
            local isUterEnding = definiteForm.endsWith('n') || definiteForm.endsWith('na');
            isNeuter = !isUterEnding;
            #ifdef __DEBUG
            /*if(isNeuter) {
                tadsSay('<<self>>: <<definiteForm>> is now set to neuter\n');
            }*/
            #endif
        }
    }

    /*
     *   Inherit vocabulary from this class and its superclasses, adding
     *   the words to the given target object.  'target' is the object to
     *   which we add our vocabulary words, and 'done' is a vector of
     *   classes that have been visited so far.
     *
     *   Since a class can be inherited more than once in an inheritance
     *   tree (for example, a class can have multiple superclasses, each
     *   of which have a common base class), we keep a vector of all of
     *   the classes we've visited.  If we're already in the vector, we'll
     *   skip adding vocabulary for this class or its superclasses, since
     *   we must have already traversed this branch of the tree from
     *   another subclass.
     */
    inheritVocab(target, done)
    {
        /*
         *   if we're in the list of classes handled already, don't bother
         *   visiting me again
         */
        if (done.indexOf(self) != nil)
            return;

        /* add myself to the list of classes handled already */
        done.append(self);

        /* 
         *   add words from our own vocabWords to the target object (but
         *   only if it's our own - not if it's only inherited, as we'll
         *   pick up the inherited ones explicitly in a bit) 
         */
        if (propDefined(&vocabWords, PropDefDirectly)) {
            target.initializeVocabWith(vocabWords);
        }

        /* add vocabulary from each of our superclasses */
        foreach (local sc in getSuperclassList()) {
            sc.inheritVocab(target, done);
        }
    }

    /*
     *   Initialize our vocabulary from the given string.  This parses the
     *   given vocabulary initializer string and adds the words defined in
     *   the string to the dictionary.
     *
     *   Note that this parsing is intentionally located in the
     *   English-specific part of the library, because it is expected that
     *   other languages will want to define their own vocabulary
     *   initialization string formats.  For example, a language with
     *   gendered nouns might want to use gendered articles in the
     *   initializer string as an author-friendly way of defining noun
     *   gender; languages with inflected (declined) nouns and/or
     *   adjectives might want to encode inflected forms in the
     *   initializer.  Non-English language implementations are free to
     *   completely redefine the format - there's no need to follow the
     *   conventions of the English format in other languages where
     *   different formats would be more convenient.
     */
        
    // Tillåter sammansatt ord med '+' som avskiljare, med ändelsen sist
    // t ex: 'vit+a sten+en' blir ajektiv: vit, vita och substantiv sten, stenen
    // t ex: 'vit+a sten+en' blir ajektiv: vit, vita och substantiv sten, stenen
    combineVocabWords = true 

    // Om true, kortas 3 eller fler i följd upprepande tecken ner till 2, 
    // från alla ord som skapas med combineVocabWords
    enableShortenRepeatingCharacters = true 

    plusNotationPat = static new RexPattern('.+(<plus>.+)+')

    tripleLetterPat = static new RexPattern('.*?((<Alpha>)%2{2,}).*')

    wordPartDelPat = static new RexPattern('(.*?)(<vbar|plus>)')

    initializeVocabWith(str)
    {
        local sectPart;
        local modList = [];
        
        local foundPluralName = nil;         // Håller reda på om vi definierat det första hittade pluralName
        local foundTheDefiniteForm = nil;  // Håller reda på om vi definierat den första hittade bestämda formen

        sectPart = &adjective;              // vocabWords inleds i adjektivsektionen (adj adj adj noun/noun/noun*plural plural)

        // Kontrollera om bara ett ord skrivits in. Används för tilldela cmdDict med &plural-typ
        // och ev. tillhörande ändelser, då enbart ett ord används.
        local oneWordOnly = !(str.find(' ') || str.find('/') || str.find('*'));

        local previousSectPart;
        // Iterera igenom strängen så länge den har ett innehåll
        while (str != '') {
            local len, cur;

            // Om strängen börjar med ett citattecken, ta reda på positionen av nästkommande citattecken,
            // annars: sök redan på nästkommande avskiljningstecken
            if (str.startsWith('"')) {                
                len = str.find('"', 2);
            } else {
                len = rexMatch('<^space|star|/>*', str);
            }

            // Om ingen matchning dök upp på vare sig citationstecken eller avskiljare, 
            // använd resten av strängen som längd
            if (len == nil) {
                len = str.length();
            }

            // Om det fanns något före avskiljningstecknet, extrahera det
            if (len != 0) {
                cur = str.substr(1, len); // Extrahera allt innan skiljetecknet 

                // Om vi är i adjektivdelen och antingen är på sista tecknet 
                // ELLER ser att nästa avskiljare inte är ett mellanslag, 
                // då kan vi härleda att vi har att göra med ett substantiv 
                // och ska byta till substantivdelen
                if (sectPart == &adjective && (len == str.length() || str.substr(len + 1, 1) != ' ')) {
                    sectPart = &noun;
                } else {

                    if(sectPart == &adjective) {
                        // Om objektets plats är ett levande ting som slutar på s, 
                        // lägg även till ordet med apostrof '. 
                        // Detta på grund av en lite mer ålderdomlig svenska där apostrof läggs
                        // till possesiva namn som slutar på s.  T ex: nils' hus.
                        if(cur.endsWith('s')
                        && self.location != nil
                        && self.location.ofKind(Actor)) { 
                            cmdDict.addWord(self, cur + '\'', &adjApostS);
                            // OBS: Ett krux med detta är dock parsern, som behöver uppdateras.
                            // Just nu hanterar den bara engelska typen, t ex "nils's".
                        } 
                    }
                }

                local matchCombineVocabWordsNotation;
                // Om tecknet inte är ett bindestreck (vilket skulle vara en placeholder för ett "noll-ord", 
                // DVS: inte ett riktigt vokabulärt ord), lägg till det i sin rätta sektion samt i lexikonet
                if (cur != '-') {
                    
                    // Låt taldelen utgå från nuvarande sektion för detta ord
                    local wordPart = sectPart;

                    // Kolla efter parenteser, vilket markerar detta ord som "svagt". 
                    // Detta påverkar inget annat än att ordet läggs till i listan 
                    // för "svaga" ord.
                    if (cur.startsWith('(') && cur.endsWith(')'))
                    {
                        cur = cur.substr(2, cur.length() - 2); // ta bort parenteserna
                        if (weakTokens == nil) {
                            weakTokens = [];
                        }
                        weakTokens += cur;
                    }

                
                    // Kolla efter specialformat, strängcitat, ändelser 's' (för ägande)
                    // Dessa kan inte samexistera utan utesluter varandra
                    if (cur.startsWith('"')) {
                        //tadsSay('\n[<<cur>>] börjar med strängcitat\n');

                        // Det är ett strängcitat, så det blir ett 'literal adjective'.
                        // ta bort citationstecknen:
                        if (cur.endsWith('"')) {
                            //tadsSay('\n[<<cur>>] slutar med strängcitat\n');
                            cur = cur.substr(2, cur.length() - 2);

                            // Spara nuvarande sektion för att kunna återgå återställa den
                            previousSectPart = sectPart;                             
                            // Ändra denna del av talet 'literal adjective'
                            sectPart = &literalAdjective;
                        } else {
                            cur = cur.substr(2);
                        }
                    }

                    // Här inleds matchning av +notation för förenkla sammansättningar 
                    // av ord i svenskan (som kryllar av dem)

                    // Specialfall, om en definition är exempelvis följande: 
                    // "sakerna: Thing 'sakerna' 'sakerna' isPlural=true;"
                    //
                    //  - DVS pluralord utan inledande adjektiv eller 
                    // singular-substantiv, så vill vi tilldela nuvarande 
                    // sectPart med &plural. 
                    // 
                    // Annars behåller vi bara den delen vi hade och lägger
                    // till stam+ändelse-ordet som en sådan del.
                    sectPart = oneWordOnly && isPlural? &plural : sectPart;

                    local isPluralAndSectPartPlural = isPlural && sectPart == &plural;
                    local isNotPluralAndSectPartNoun = !isPlural && sectPart == &noun;
                    local isNounOrPluralAndCorrespondingSectPart = isPluralAndSectPartPlural || isNotPluralAndSectPartNoun;

                    if(combineVocabWords) {
                        matchCombineVocabWordsNotation = rexMatch(plusNotationPat, cur);
                        if(matchCombineVocabWordsNotation) {
                            local forms = createCompoundWordVariations(self, cur, sectPart, enableShortenRepeatingCharacters);

                            // Tilldela pluralName det första plural-ordet vi hittar i vocabWords
                            // Detta då det oftare är jobbigare att böja till pluralName med pluralNameFrom()
                            if(sectPart == &plural) {
                                if(!foundPluralName) {
                                    foundPluralName=true;   
                                    pluralName = forms.standardForm;
                                }
                            }                            

                            // Tilldela definiteForm den första definitiva formen vi hittar i vocabWords
                            // Vi gör detta enbart när +notation använts eftersom det är enbart då vi med 
                            // säkerhet vet att den definitiva formen har använts.
                            // (theNameFrom kommer att använda definiteForm om den inte är nil. )
                            if(isNounOrPluralAndCorrespondingSectPart) {
                                if(definiteForm == nil) {
                                    if(!foundTheDefiniteForm) {
                                        foundTheDefiniteForm = true;
                                        definiteForm = forms.definiteForm; 
                                    }
                                }

                                // AUTOMATISK HÄRLEDNING AV 'NAME' OM DET SAKNAS 
                                // 
                                // OBS: Gäller bara Thing(s), inte Actor(s) eller Room(s)
                                // Actor(s) får som default ett pronomen via name = (itNom), 
                                // (så som "han", "hon", "den", "det") och det beteendet får vara intakt.
                                // Om vi vill specificera namnet för en Actor bättre, så skriver vi själva det 
                                // direkt efter vocabWords, precis som vanligt.
                                if(name == '') {
                                    name = forms.standardForm;
                                }
                            }
                        } else {
                            if(sectPart == &plural) {
                                if(!foundPluralName) {
                                    foundPluralName=true;   
                                    pluralName = cur;
                                    //tadsSay('tilldelar pluralname <<pluralName>>\n');                             
                                }
                            }                            
                            if(isNounOrPluralAndCorrespondingSectPart) {
                                // wordPart blir till nuvarande sectPart. Detta eftersom
                                // ordet läggs till senare med just innehållet i wordPart
                                // och vi vill inte missa om vi i detta läge bytt från &noun till &plural t ex. 
                                wordPart = sectPart; 

                                // Härled automatiskt 'name' om det saknas, så vi slipper skriva det explicit.
                                if(name == '' ) {
                                    name = cur;
                                    //tadsSay('Tilldelar objektets namn då det saknas: <<name>> \n');
                                }
                            }
                        }
                    }

                    if(previousSectPart) {
                        sectPart = previousSectPart; 
                    }

                    // Här fortsätter den sedvanliga matchningen av vocabWords


                    // Lägg till ordet till våran egen lista för denna del av talet
                    if (self.(wordPart) == nil) {
                        self.(wordPart) = [cur];
                    } else {
                        self.(wordPart) += cur;
                    }

                    // Lägg till det till ordboken men inte om vi använt "+"-notation, 
                    // då detta redan skapat upp alla varianter som går och vi vill inte 
                    // få rå-notationen som ett keyword 
                    if(!matchCombineVocabWordsNotation) {
                        cmdDict.addWord(self, cur, wordPart);
                    }

                    if (cur.endsWith('.')) {
                        local abbr;
                        // Om order slutar på en punkt är det ett avkortat ord. 
                        // förkortningen läggs till i lexikonet både med och utan punkten.

                        // Den normala hanteringen skriver in det tillsammans 
                        // med punkten så vi behöver bara skriva in det 
                        // specifikt utan.                         
                        abbr = cur.substr(1, cur.length() - 1);
                        self.(wordPart) += abbr;
                        cmdDict.addWord(self, abbr, wordPart);
                    }

                    // note that we added to this list
                    if (modList.indexOf(wordPart) == nil) {
                        modList += wordPart;
                    }
                }
            }

            if (len + 1 < str.length()) {                   // if we have a delimiter, see what we have 
                switch(str.substr(len + 1, 1)) {
                    case ' ': break;                        // stick with the current part 
                    case '*': sectPart = &plural; break;    // start plurals 
                    case '/': sectPart = &noun; break;      // start alternative nouns 
                }
                str = str.substr(len + 2);                  // remove the part up to and including the delimiter 

                // skip any additional spaces following the delimiter 
                if ((len = rexMatch('<space>+', str)) != nil)
                    str = str.substr(len + 1);
            } else {
                break; // we've exhausted the string - we're done 
            }
        }

        // Om objektet är en namn- & vocabWordslös subContainer/subSurface som ej definierat
        // isNeuter men isNeuter har definierats i dess lexicalParent
        // använd samma genus då objektet avser samma objekt som lexicalParent.
        // Detta är inte ovanligt då man t ex skapar ett möbel med både ovansida och insida.
        // där de olika ytorna definieras i olika subComponents. T ex:
        //
        //    skap: Heavy, ComplexContainer 'skåp+et'
        //      subSurface: ComplexComponent, Surface {}
        //      subContainer: ComplexComponent, OpenableContainer {}
        //   ;
        // 
        // (I ovan fall ärver alltså en namnlös ComplexComponent isNeuter från sin ComplexContainer)
        if(self.vocabWords == ''
        && propDefined(&isNeuter)
        && ofKind(ComplexComponent)
        && lexicalParent
        && lexicalParent.ofKind(ComplexContainer)
        && lexicalParent.propDefined(&isNeuter)) {
            isNeuter = lexicalParent.isNeuter;
            //tadsSay('<<self>> ärver <<lexicalParent.isNeutrum?'neutrum':'utrum'>> från <<self.lexicalParent>>\n' );
        }

        /* uniquify each word list we updated */
        foreach (local p in modList) {
            self.(p) = self.(p).getUnique();
        }
        
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   Language-specific modifications for Thing.  This class contains the
 *   methods and properties of Thing that need to be replaced when the
 *   library is translated to another language.
 *   
 *   The properties and methods defined here should generally never be used
 *   by language-independent library code, because everything defined here
 *   is specific to English.  Translators are thus free to change the
 *   entire scheme defined here.  For example, the notions of number and
 *   gender are confined to the English part of the library; other language
 *   implementations can completely replace these attributes, so they're
 *   not constrained to emulate their own number and gender systems with
 *   the English system.  
 */
modify Thing

    /*
     *   Flag that this object's name is rendered as a plural (this
     *   applies to both a singular noun with plural usage, such as
     *   "pants" or "scissors," and an object used in the world model to
     *   represent a collection of real-world objects, such as "shrubs").
     */
    isPlural = nil

    /*
     *   Flag that this is object's name is a "mass noun" - that is, a
     *   noun denoting a continuous (effectively infinitely divisible)
     *   substance or material, such as water, wood, or popcorn; and
     *   certain abstract concepts, such as knowledge or beauty.  Mass
     *   nouns are never rendered in the plural, and use different
     *   determiners than ordinary ("count") nouns: "some popcorn" vs "a
     *   kernel", for example.
     */
    isMassNoun = nil

    /*
     *   Flags indicating that the object should be referred to with
     *   gendered pronouns (such as 'he' or 'she' rather than 'it').
     *
     *   Note that these flags aren't mutually exclusive, so it's legal
     *   for the object to have both masculine and feminine usage.  This
     *   can be useful when creating collective objects that represent
     *   more than one individual, for example.
     */
    isHim = nil
    isHer = nil

    /*
     *   Flag indicating that the object can be referred to with a neuter
     *   pronoun ('it').  By default, this is true if the object has
     *   neither masculine nor feminine gender, but it can be overridden
     *   so that an object has both gendered and ungendered usage.  This
     *   can be useful for collective objects, as well as for cases where
     *   gendered usage varies by speaker or situation, such as animals.
     */
    isIt
    {
        /* by default, we're an 'it' if we're not a 'him' or a 'her' */
        return !(isHim || isHer);
    }

    /*
     *   Test to see if we can match the pronouns 'him', 'her', 'it', and
     *   'them'.  By default, these simply test the corresponding isXxx
     *   flags (except 'canMatchThem', which tests 'isPlural' to see if the
     *   name has plural usage).
     */
    canMatchHim = (isHim)
    canMatchHer = (isHer)
    canMatchIt = (isIt)
    canMatchThem = (isPlural)

    /* can we match the given PronounXxx pronoun type specifier? */
    canMatchPronounType(typ)
    {
        /* check the type, and return the appropriate indicator property */
        switch (typ)
        {
        case PronounHim:
            return canMatchHim;

        case PronounHer:
            return canMatchHer;

        case PronounIt:
            return canMatchIt;

        case PronounThem:
            return canMatchThem;

        default:
            return nil;
        }
    }

    /*
     *   The grammatical cardinality of this item when it appears in a
     *   list.  This is used to ensure verb agreement when mentioning the
     *   item in a list of items.  ("Cardinality" is a fancy word for "how
     *   many items does this look like").
     *
     *   English only distinguishes two degrees of cardinality in its
     *   grammar: one, or many.  That is, when constructing a sentence, the
     *   only thing the grammar cares about is whether an object is
     *   singular or plural: IT IS on the table, THEY ARE on the table.
     *   Since English only distinguishes these two degrees, two is the
     *   same as a hundred is the same as a million for grammatical
     *   purposes, so we'll consider our cardinality to be 2 if we're
     *   plural, 1 otherwise.
     *
     *   Some languages don't express cardinality at all in their grammar,
     *   and others distinguish cardinality in greater detail than just
     *   singular-vs-plural, which is why this method has to be in the
     *   language-specific part of the library.
     */
    listCardinality(lister) { return isPlural ? 2 : 1; }

    /*
     *   Proper name flag.  This indicates that the 'name' property is the
     *   name of a person or place.  We consider proper names to be fully
     *   qualified, so we don't add articles for variations on the name
     *   such as 'theName'.
     */
    isProperName = nil

    /*
     *   Qualified name flag.  This indicates that the object name, as
     *   given by the 'name' property, is already fully qualified, so
     *   doesn't need qualification by an article like "the" or "a" when
     *   it appears in a sentence.  By default, a name is considered
     *   qualified if it's a proper name, but this can be overridden to
     *   mark a non-proper name as qualified when needed.
     */
    isQualifiedName = (isProperName)

    /*
     *   The name of the object - this is a string giving the object's
     *   short description, for constructing sentences that refer to the
     *   object by name.  Each instance should override this to define the
     *   name of the object.  This string should not contain any articles;
     *   we use this string as the root to generate various forms of the
     *   object's name for use in different places in sentences.
     */
    name = ''

    /*
     *   The name of the object, for the purposes of disambiguation
     *   prompts.  This should almost always be the object's ordinary
     *   name, so we return self.name by default.
     *
     *   In rare cases, it might be desirable to override this.  In
     *   particular, if a game has two objects that are NOT defined as
     *   basic equivalents of one another (which means that the parser
     *   will always ask for disambiguation when the two are ambiguous
     *   with one another), but the two nonetheless have identical 'name'
     *   properties, this property should be overridden for one or both
     *   objects to give them different names.  This will ensure that we
     *   avoid asking questions of the form "which do you mean, the coin,
     *   or the coin?".  In most cases, non-equivalent objects will have
     *   distinct 'name' properties to begin with, so this is not usually
     *   an issue.
     *
     *   When overriding this method, take care to override
     *   theDisambigName, aDisambigName, countDisambigName, and/or
     *   pluralDisambigName as needed.  Those routines must be overridden
     *   only when the default algorithms for determining articles and
     *   plurals fail to work properly for the disambigName (for example,
     *   the indefinite article algorithm fails with silent-h words like
     *   "hour", so if disambigName is "hour", aDisambigName must be
     *   overridden).  In most cases, the automatic algorithms will
     *   produce acceptable results, so the default implementations of
     *   these other routines can be used without customization.
     */
    disambigName = (name)

    /*
     *   The "equivalence key" is the value we use to group equivalent
     *   objects.  Note that we can only treat objects as equivalent when
     *   they're explicitly marked with isEquivalent=true, so the
     *   equivalence key is irrelevant for objects not so marked.
     *   
     *   Since the main point of equivalence is to allow creation of groups
     *   of like-named objects that are interchangeable in listings and in
     *   command input, we use the basic disambiguation name as the
     *   equivalence key.  
     */
    equivalenceKey = (disambigName)

    /*
     *   The definite-article name for disambiguation prompts.
     *
     *   By default, if the disambiguation name is identical to the
     *   regular name (i.e, the string returned by self.disambigName is
     *   the same as the string returned by self.name), then we simply
     *   return self.theName.  Since the base name is the same in either
     *   case, presumably the definite article names should be the same as
     *   well.  This way, if the object overrides theName to do something
     *   special, then we'll use the same definite-article name for
     *   disambiguation prompts.
     *
     *   If the disambigName isn't the same as the regular name, then
     *   we'll apply the same algorithm to the base disambigName that we
     *   normally do to the regular name to produce the theName.  This
     *   way, if the disambigName is overridden, we'll use the overridden
     *   disambigName to produce the definite-article version, using the
     *   standard definite-article algorithm.
     *
     *   Note that there's an aspect of this conditional approach that
     *   might not be obvious.  It might look as though the test is
     *   redundant: if name == disambigName, after all, and the default
     *   theName returns theNameFrom(name), then this ought to be
     *   identical to returning theNameFrom(disambigName).  The subtlety
     *   is that theName could be overridden to produce a custom result,
     *   in which case returning theNameFrom(disambigName) would return
     *   something different, which probably wouldn't be correct: the
     *   whole reason theName would be overridden is that the algorithmic
     *   determination (theNameFrom) gets it wrong.  So, by calling
     *   theName directly when disambigName is the same as name, we are
     *   assured that we pick up any override in theName.
     *
     *   Note that in rare cases, neither of these default approaches will
     *   produce the right result; this will happen if the object uses a
     *   custom disambigName, but that name doesn't fit the normal
     *   algorithmic pattern for applying a definite article.  In these
     *   cases, the object should simply override this method to specify
     *   the custom name.
     */
    theDisambigName = (name == disambigName
                       ? theName : theNameFrom(disambigName))

    /*
     *   The indefinite-article name for disambiguation prompts.  We use
     *   the same logic here as in theDisambigName.
     */
    aDisambigName = (name == disambigName ? aName : aNameFrom(disambigName))

    /*
     *   The counted name for disambiguation prompts.  We use the same
     *   logic here as in theDisambigName.
     */
    countDisambigName(cnt)
    {
        return (name == disambigName && pluralName == pluralDisambigName
                ? countName(cnt)
                : countNameFrom(cnt, disambigName, pluralDisambigName));
    }

    /*
     *   The plural name for disambiguation prompts.  We use the same
     *   logic here as in theDisambigName.
     */
    pluralDisambigName = (name == disambigName
                          ? pluralName : pluralNameFrom(disambigName))

    /*
     *   The name of the object, for the purposes of disambiguation prompts
     *   to disambiguation among this object and basic equivalents of this
     *   object (i.e., objects of the same class marked with
     *   isEquivalent=true).
     *
     *   This is used in disambiguation prompts in place of the actual text
     *   typed by the user.  For example, suppose the user types ">take
     *   coin", then we ask for help disambiguating, and the player types
     *   ">gold".  This narrows things down to, say, three gold coins, but
     *   they're in different locations so we need to ask for further
     *   disambiguation.  Normally, we ask "which gold do you mean",
     *   because the player typed "gold" in the input.  Once we're down to
     *   equivalents, we don't have to rely on the input text any more,
     *   which is good because the input text could be fragmentary (as in
     *   our present example).  Since we have only equivalents, we can use
     *   the actual name of the objects (they're all the same, after all).
     *   This property gives the name we use.
     *
     *   For English, this is simply the object's ordinary disambiguation
     *   name.  This property is separate from 'name' and 'disambigName'
     *   for the sake of languages that need to use an inflected form in
     *   this context.
     */
    disambigEquivName = (disambigName)

    /*
     *   Single-item listing description.  This is used to display the
     *   item when it appears as a single (non-grouped) item in a list.
     *   By default, we just show the indefinite article description.
     */
    listName = (aName)

    /*
     *   Return a string giving the "counted name" of the object - that is,
     *   a phrase describing the given number of the object.  For example,
     *   for a red book, and a count of 5, we might return "five red
     *   books".  By default, we use countNameFrom() to construct a phrase
     *   from the count and either our regular (singular) 'name' property
     *   or our 'pluralName' property, according to whether count is 1 or
     *   more than 1.  
     */
    countName(count) { return countNameFrom(count, name, pluralName); }

    /*
     *   Returns a string giving a count applied to the name string.  The
     *   name must be given in both singular and plural forms.
     */
    countNameFrom(count, singularStr, pluralStr)
    {
        /* if the count is one, use 'one' plus the singular name */
        if (count == 1) {
            return (!isNeuter?'en':'ett') + ' ' + singularStr;
        }

        /*
         *   Get the number followed by a space - spell out numbers below
         *   100, but use numerals to denote larger numbers.  Append the
         *   plural name to the number and return the result.
         */
        return spellIntBelowExt(count, 100, 0, DigitFormatGroupSep)
            + ' ' + pluralStr;
    }

    /*
     *   Get the 'pronoun selector' for the various pronoun methods.  This
     *   returns:
     *   
     *.  - singular neuter = 1
     *.  - singular masculine = 2
     *.  - singular feminine = 3
     *.  - plural = 4
     */
    pronounSelector = (isPlural ? 4 : isHer ? 3 : isHim ? 2 : 1)

    /*
     *   get a string with the appropriate pronoun for the object for the
     *   nominative case, objective case, possessive adjective, possessive
     *   noun
     */
    itNom {  return [ (!isNeuter? 'den':'det'), 'han', 'hon', 'de'][pronounSelector];  }
    itObj { return [ (isNeuter?'det':'den'), 'honom', 'henne', 'dem'][pronounSelector]; }

    itPossAdj { return ['dess', 'hans', 'hennes', 'deras'][pronounSelector]; }
    itPossNoun { return ['dess', 'hans', 'hennes', 'deras'][pronounSelector]; }

    /* get the object reflexive pronoun (itself, etc) */
    itReflexive { return ['sig själv', 'han själv', 'hon själv', 'de själva'][pronounSelector]; }


    // Dessa används inte, men oklart om de ska få stanna ändå.

    /*
     *   Demonstrative pronoun, nominative case.  We'll use personal a
     *   personal pronoun if we have a gender or we're in the first or
     *   second person, otherwise we'll use 'that' or 'those' as we would
     *   for an inanimate object.
     */

    // demonstrativa pronomen, nominativt 
    thatNom { 
        local obestamdForm = true;
        if(isPlural) {
            return obestamdForm? 'dessa' : 'de där';
        }
        if(isNeuter) {
            return obestamdForm? 'detta' : 'det där';  
        }
        return  obestamdForm? 'denna' : 'den där';
    }

    // demonstrativa pronomen, objektivt
    thatObj { 
        //return [ (isNeuter?'det':'den'), 'honom', 'henne', 'de'][pronounSelector]; 
        local obestamdForm = true;
        if(isPlural) {
            return obestamdForm? 'dessa' : 'dem där';
        }
        if(isNeuter) {
            return obestamdForm? 'detta' : 'det där';  
        }
        return  obestamdForm? 'denna' : 'den där';
    }

    /*
     *   get a string with the appropriate pronoun for the object plus the
     *   correct conjugation of the given regular verb for the appropriate
     *   person
     */
    itVerb(verb)
    {
        return itNom + ' ' + conjugateRegularVerb(verb);
    }

    /*
     *   Conjugate a regular verb in the present or past tense for our
     *   person and number.
     *
     *   In the present tense, this is pretty easy: we add an 's' for the
     *   third person singular, and leave the verb unchanged for plural (it
     *   asks, they ask).  The only complication is that we must check some
     *   special cases to add the -s suffix: -y -> -ies (it carries), -o ->
     *   -oes (it goes).
     *
     *   In the past tense, we can equally easily figure out when to use
     *   -d, -ed, or -ied.  However, we have a more serious problem: for
     *   some verbs, the last consonant of the verb stem should be repeated
     *   (as in deter -> deterred), and for others it shouldn't (as in
     *   gather -> gathered).  To figure out which rule applies, we would
     *   sometimes need to know whether the last syllable is stressed, and
     *   unfortunately there is no easy way to determine that
     *   programmatically.
     *
     *   Therefore, we do *not* handle the case where the last consonant is
     *   repeated in the past tense.  You shouldn't use this method for
     *   this case; instead, treat it as you would handle an irregular
     *   verb, by explicitly specifying the correct past tense form via the
     *   tSel macro.  For example, to generate the properly conjugated form
     *   of the verb "deter" for an object named "thing", you could use an
     *   expression such as:
     *
     *   'deter' + tSel(thing.verbEndingS, 'red')
     *
     *   This would correctly generate "deter", "deters", or "deterred"
     *   depending on the number of the object named "thing" and on the
     *   current narrative tense.
     */
    conjugateRegularVerb(verb) {
        return verb;
        /*
         // Which tense are we currently using?
        if (gameMain.usePastTense)
        {
             // We want the past tense form.
             // If the last letter is 'e', simply add 'd'.
            if (verb.endsWith('e')) return verb + 'd';

            
             // Otherwise, if the verb ending would become 'ies' in the
             // third-person singular present, then it becomes 'ied' in
             // the past.
             
            else if (rexMatch(iesnounEndingPat, verb))
                    return verb.substr(1, verb.length() - 1) + 'ied';

            
             // Otherwise, use 'ed' as the ending.  Don't try to determine
             // if the last consonant should be repeated: that's too
             // complicated.  We'll just ignore the possibility.
             
            else return verb + 'ed';
        }
        else
        {
            
             // We want the present tense form.
             //
             // Check our number and person.
             
            if (isPlural)
            {
                
                 // We're plural, so simply use the base verb form ("they
                 // ask").
                 
                return verb;
            }
            else
            {
                
                 // Third-person singular, so we must add the -s suffix.
                 // Check for special spelling cases:
                 // 
                 // '-y' changes to '-ies', unless the 'y' is preceded by
                 // a vowel
                 //
                 // '-sh', '-ch', and '-o' endings add suffix '-es'
                 
                if (rexMatch(iesnounEndingPat, verb))
                    return verb.substr(1, verb.length() - 1) + 'ies';
                else if (rexMatch(esnounEndingPat, verb))
                    return verb + 'es';
                else
                    return verb;
                    //return verb + 's';
            }
        }*/
    }

    /* verb-ending patterns for figuring out which '-s' ending to add */
    iesnounEndingPat = static new RexPattern('.*[^aeiou]y$')
    esnounEndingPat = static new RexPattern('.*(o|ch|sh)$')

    /*
     *   Get the name with a definite article ("the box").  By default, we
     *   use our standard definite article algorithm to apply an article
     *   to self.name.
     *
     *   The name returned must be in the nominative case (which makes no
     *   difference unless the name is a pronoun, since in English
     *   ordinary nouns don't vary according to how they're used in a
     *   sentence).
     */

    // I ett fall där både bestämd/obestämd form ska användas får theName helt enkelt överridas 
    //jagare:  Actor 'hjortjägare+n/jägare+n' 'hjortjägare'
    //    theName = 'hjortjägaren'
    //    isProperName = nil
    //    isHim = true
    //;
    // 
    // 
    //hans:  Actor 'hans/hjortjägare+n/jägare+n' 'Hans'
    //    isProperName = true
    //    isHim = true
    //;



    theName = (theNameFrom(name))

    /*
     *   theName in objective case.  In most cases, this is identical to
     *   the normal theName, so we use that by default.  This must be
     *   overridden if theName is a pronoun (which is usually only the
     *   case for player character actors; see our language-specific Actor
     *   modifications for information on that case).
     */
    theNameObj { return theName; }

    /*
     *   Generate the definite-article name from the given name string.
     *   If my name is already qualified, don't add an article; otherwise,
     *   add a 'the' as the prefixed definite article.
     */
    
    //theNameFrom(str) { return (isQualifiedName ? '' : 'the ') + str; }

    definiteForm = nil

    theNameFrom(str) { 
        if(isQualifiedName) {
            return str;
        }
        if(definiteForm) {
            return definiteForm;
        }
        //tadsSay('theNameFrom <<definiteForm>>');
        return (isPlural ? 'de ' : (isNeuter? 'det ' : 'den ')) + str; 
    }

    swedishVocals = static ['a','e','i','o','u','y','å','ä','ö']

    /*
     *   theName as a possessive adjective (Bob's book, your book).  If the
     *   name's usage is singular (i.e., isPlural is nil), we'll simply add
     *   an apostrophe-S.  If the name is plural, and it ends in an "s",
     *   we'll just add an apostrophe (no S).  If it's plural and doesn't
     *   end in "s", we'll add an apostrophe-S.
     *
     *   Note that some people disagree about the proper usage for
     *   singular-usage words (especially proper names) that end in 's'.
     *   Some people like to use a bare apostrophe for any name that ends
     *   in 's' (so Chris -> Chris'); other people use apostrophe-s for
     *   singular words that end in an "s" sound and a bare apostrophe for
     *   words that end in an "s" that sounds like a "z" (so Charles
     *   Dickens -> Charles Dickens').  However, most usage experts agree
     *   that proper names take an apostrophe-S in almost all cases, even
     *   when ending with an "s": "Chris's", "Charles Dickens's".  That's
     *   what we do here.
     *
     *   Note that this algorithm doesn't catch all of the special
     *   exceptions in conventional English usage.  For example, Greek
     *   names ending with "-es" are usually written with the bare
     *   apostrophe, but we don't have a property that tells us whether the
     *   name is Greek or not, so we can't catch this case.  Likewise, some
     *   authors like to possessive-ize words that end with an "s" sound
     *   with a bare apostrophe, as in "for appearance' sake", and we don't
     *   attempt to catch these either.  For any of these exceptions, you
     *   must override this method for the individual object.
     */
    theNamePossAdj
    {
        /* add apostrophe-S, unless it's a plural ending with 's' */
        
        // Lägg till s om det saknas på slutet, t ex: "Bob" blir "Bobs"

        return theName + (theName.endsWith('s') ? '' : 's'); 
            //+ (isPlural && theName.endsWith('s') ? '' : 's')
            ;
    }

    /*
     *   TheName as a possessive noun (that is Bob's, that is yours).  We
     *   simply return the possessive adjective name, since the two forms
     *   are usually identical in English (except for pronouns, where they
     *   sometimes differ: "her" for the adjective vs "hers" for the noun).
     */
    theNamePossNoun = (theNamePossAdj)

    /*
     *   theName with my nominal owner explicitly stated, if we have a
     *   nominal owner: "your backpack," "Bob's flashlight."  If we have
     *   no nominal owner, this is simply my theName.
     */
    theNameWithOwner()
    {
        local owner;

        /*
         *   if we have a nominal owner, show with our owner name;
         *   otherwise, just show our regular theName
         */
        if ((owner = getNominalOwner()) != nil) {
            return owner.theNamePossAdj + ' ' + name;
        }
        else
            return theName;
    }

    /*
     *   Default preposition to use when an object is in/on this object.
     *   By default, we use 'in' as the preposition; subclasses can
     *   override to use others (such as 'på' for a surface).
     */
    objInPrep = 'i'

    /*
     *   Default preposition to use when an actor is in/on this object (as
     *   a nested location), and full prepositional phrase, with no article
     *   and with an indefinite article.  By default, we use the objInPrep
     *   for actors as well.
     */
    actorInPrep = (objInPrep)

    /* preposition to use when an actor is being removed from this location */
    actorOutOfPrep = 'ut ur'

    /* preposition to use when an actor is being moved into this location */
    actorIntoPrep
    {
        if (actorInPrep is in ('i', 'på'))
            return actorInPrep + 'till';
        else
            return actorInPrep;
    }

    /*
     *   describe an actor as being in/being removed from/being moved into
     *   this location
     */
    actorInName = (actorInPrep + ' ' + theNameObj)
    actorInAName = (actorInPrep + ' ' + aNameObj)
    actorOutOfName = (actorOutOfPrep + ' ' + theNameObj)
    actorIntoName = (actorIntoPrep + ' ' + theNameObj)

    /*
     *   A prepositional phrase that can be used to describe things that
     *   are in this room as seen from a remote point of view.  This
     *   should be something along the lines of "in the airlock", "at the
     *   end of the alley", or "on the lawn".
     *
     *   'pov' is the point of view from which we're seeing this room;
     *   this might be
     *
     *   We use this phrase in cases where we need to describe things in
     *   this room when viewed from a point of view outside of the room
     *   (i.e., in a different top-level room).  By default, we'll use our
     *   actorInName.
     */
    inRoomName(pov) { return actorInName; }

    /*
     *   Provide the prepositional phrase for an object being put into me.
     *   For a container, for example, this would say "into the box"; for
     *   a surface, it would say "onto the table."  By default, we return
     *   our library message given by our putDestMessage property; this
     *   default is suitable for most cases, but individual objects can
     *   customize as needed.  When customizing this, be sure to make the
     *   phrase suitable for use in sentences like "You put the book
     *   <<putInName>>" and "The book falls <<putInName>>" - the phrase
     *   should be suitable for a verb indicating active motion by the
     *   object being received.
     */
    putInName() { return gLibMessages.(putDestMessage)(self); }

    /*
     *   Get a description of an object within this object, describing the
     *   object's location as this object.  By default, we'll append "in
     *   <theName>" to the given object name.
     */
    childInName(childName)
        { return childInNameGen(childName, theName); }

    /*
     *   Get a description of an object within this object, showing the
     *   owner of this object.  This is similar to childInName, but
     *   explicitly shows the owner of the containing object, if any: "the
     *   flashlight in bob's backpack".
     */
    childInNameWithOwner(childName)
        { return childInNameGen(childName, theNameWithOwner); }

    /*
     *   get a description of an object within this object, as seen from a
     *   remote location
     */
    childInRemoteName(childName, pov)
        { return childInNameGen(childName, inRoomName(pov)); }

    /*
     *   Base routine for generating childInName and related names.  Takes
     *   the name to use for the child and the name to use for me, and
     *   combines them appropriately.
     *
     *   In most cases, this is the only one of the various childInName
     *   methods that needs to be overridden per subclass, since the others
     *   are defined in terms of this one.  Note also that if the only
     *   thing you need to do is change the preposition from 'in' to
     *   something else, you can just override objInPrep instead.
     */
    childInNameGen(childName, myName)
        { return childName + ' ' + objInPrep + ' ' + myName; }

    /*
     *   Get my name (in various forms) distinguished by my owner or
     *   location.
     *
     *   If the object has an owner, and either we're giving priority to
     *   the owner or our immediate location is the same as the owner,
     *   we'll show using a possessive form with the owner ("bob's
     *   flashlight").  Otherwise, we'll show the name distinguished by
     *   our immediate container ("the flashlight in the backpack").
     *
     *   These are used by the ownership and location distinguishers to
     *   list objects according to owners in disambiguation lists.  The
     *   ownership distinguisher gives priority to naming by ownership,
     *   regardless of the containment relationship between owner and
     *   self; the location distinguisher gives priority to naming by
     *   location, showing the owner only if the owner is the same as the
     *   location.
     *
     *   We will presume that objects with proper names are never
     *   indistinguishable from other objects with proper names, so we
     *   won't worry about cases like "Bob's Bill".  This leaves us free
     *   to use appropriate articles in all cases.
     */
    aNameOwnerLoc(ownerPriority)
    {
        local owner;

        /* show in owner or location format, as appropriate */
        if ((owner = getNominalOwner()) != nil
            && (ownerPriority || isDirectlyIn(owner)))
        {
            local ret;

            /*
             *   we have an owner - show as "one of Bob's items" (or just
             *   "Bob's items" if this is a mass noun or a proper name)
             */
            ret = owner.theNamePossAdj + ' ' + pluralName;
            if (!isMassNoun && !isPlural) {
                
                ret = isNeuter?'en':'ett' + ' av ' + ret;
            }

            /* return the result */
            return ret;
        }
        else
        {
            /* we have no owner - show as "an item in the location" */
            return location.childInNameWithOwner(aName);
        }
    }
    theNameOwnerLoc(ownerPriority)
    {
        local owner;

        /* show in owner or location format, as appropriate */
        if ((owner = getNominalOwner()) != nil
            && (ownerPriority || isDirectlyIn(owner)))
        {
            /* we have an owner - show as "Bob's item" */
            return owner.theNamePossAdj + ' ' + name;
        }
        else
        {
            /* we have no owner - show as "the item in the location" */
            return location.childInNameWithOwner(theName);
        }
    }
    countNameOwnerLoc(cnt, ownerPriority)
    {
        local owner;

        /* show in owner or location format, as appropriate */
        if ((owner = getNominalOwner()) != nil
            && (ownerPriority || isDirectlyIn(owner)))
        {
            /* we have an owner - show as "Bob's five items" */
            return owner.theNamePossAdj + ' ' + countName(cnt);
        }
        else
        {
            /* we have no owner - show as "the five items in the location" */
            return location.childInNameWithOwner('the ' + countName(cnt));
        }
    }

    /*
     *   Note that I'm being used in a disambiguation prompt by
     *   owner/location.  If we're showing the owner, we'll set the
     *   antecedent for the owner's pronoun, if the owner is a 'him' or
     *   'her'; this allows the player to refer back to our prompt text
     *   with appropriate pronouns.
     */
    notePromptByOwnerLoc(ownerPriority)
    {
        local owner;

        /* show in owner or location format, as appropriate */
        if ((owner = getNominalOwner()) != nil
            && (ownerPriority || isDirectlyIn(owner)))
        {
            /* we are showing by owner - let the owner know about it */
            owner.notePromptByPossAdj();
        }
    }

    /*
     *   Note that we're being used in a prompt question with our
     *   possessive adjective.  If we're a 'him' or a 'her', set our
     *   pronoun antecedent so that the player's response to the prompt
     *   question can refer back to the prompt text by pronoun.
     */
    notePromptByPossAdj()
    {
        if (isHim)
            gPlayerChar.setHim(self);
        if (isHer)
            gPlayerChar.setHer(self);
    }

    /*
     *   My name with an indefinite article.  By default, we figure out
     *   which article to use (a, an, some) automatically.
     *
     *   In rare cases, the automatic determination might get it wrong,
     *   since some English spellings defy all of the standard
     *   orthographic rules and must simply be handled as special cases;
     *   for example, the algorithmic determination doesn't know about
     *   silent-h words like "hour".  When the automatic determination
     *   gets it wrong, simply override this routine to specify the
     *   correct article explicitly.
     */
    aName = (aNameFrom(name))

    /* the indefinite-article name in the objective case */
    aNameObj { return aName; }

    /*
     *   Apply an indefinite article ("a box", "an orange", "some lint")
     *   to the given name.  We'll try to figure out which indefinite
     *   article to use based on what kind of noun phrase we use for our
     *   name (singular, plural, or a "mass noun" like "lint"), and our
     *   spelling.
     *
     *   By default, we'll use the article "a" if the name starts with a
     *   consonant, or "an" if it starts with a vowel.
     *
     *   If the name starts with a "y", we'll look at the second letter;
     *   if it's a consonant, we'll use "an", otherwise "a" (hence "an
     *   yttrium block" but "a yellow brick").
     *
     *   If the object is marked as having plural usage, we will use
     *   "some" as the article ("some pants" or "some shrubs").
     *
     *   Some objects will want to override the default behavior, because
     *   the lexical rules about when to use "a" and "an" are not without
     *   exception.  For example, silent-"h" words ("honor") are written
     *   with "an", and "h" words with a pronounced but weakly stressed
     *   initial "h" are sometimes used with "an" ("an historian").  Also,
     *   some 'y' words might not follow the generic 'y' rule.
     *
     *   'U' words are especially likely not to follow any lexical rule -
     *   any 'u' word that sounds like it starts with 'y' should use 'a'
     *   rather than 'an', but there's no good way to figure that out just
     *   looking at the spelling (consider "a universal symbol" and "an
     *   unimportant word", or "a unanimous decision" and "an unassuming
     *   man").  We simply always use 'an' for a word starting with 'u',
     *   but this will have to be overridden when the 'u' sounds like 'y'.
     */

     /**
      * Artikel+namn i svenska
      */
    aNameFrom(str)
    {
        /* remember the original source string */
        local inStr = str;

        /* if the name is already qualified, don't add an article at all */
        if (isQualifiedName) {
            return str;
        }
        // För odelbara saker så som vatten, trä, popcorn etc, kan vi antingen skriva 
        // "lite" eller skippa artikeln helt och hållet
        if (isMassNoun) {
            return str;
            //return 'lite ' + str;
        } 
        // Använd några som artikel för plural-objekt
        if(isPlural) {        
            return 'några ' + str; 
        } 

        // The rest is unneccessary in swedish
        local firstChar;

        /* if it's empty, just use "a" */
        if (inStr == '')
            return 'ett';

        /* get the first character of the name */
        firstChar = inStr.substr(1, 1);

        /* skip any leading HTML tags */
        if (rexMatch(patTagOrQuoteChar, firstChar) != nil)
        {
            /*
                *   Scan for tags.  Note that this pattern isn't quite
                *   perfect, as it won't properly ignore close-brackets
                *   that are inside quoted material, but it should be good
                *   enough for nearly all cases in practice.  In cases too
                *   complex for this pattern, the object will simply have
                *   to override aDesc.
                */
            local len = rexMatch(patLeadingTagOrQuote, inStr);

            /* if we got a match, strip out the leading tags */
            if (len != nil)
            {
                /* strip off the leading tags */
                inStr = inStr.substr(len + 1);

                /* re-fetch the first character */
                firstChar = inStr.substr(1, 1);
            }
        }
        local aName = (isNeuter?'ett':'en') + ' ' + str;
        //tadsSay('<<aName>>\n');
        return aName;
        
    }

    /* pre-compile some regular expressions for aName */
    patTagOrQuoteChar = static new RexPattern('[<"\']')
    patLeadingTagOrQuote = static new RexPattern(
        '(<langle><^rangle>+<rangle>|"|\')+')
    patOneLetterWord = static new RexPattern('<alpha>(<^alpha>|$)')
    patOneLetterAnWord = static new RexPattern('<nocase>[aefhilmnorsx]')
    patIsAlpha = static new RexPattern('<alpha>')
    patElevenEighteen = static new RexPattern('1[18](<^digit>|$)')

    /*
     *   Get the default plural name.  By default, we'll use the
     *   algorithmic plural determination, which is based on the spelling
     *   of the name.
     *
     *   The algorithm won't always get it right, since some English
     *   plurals are irregular ("men", "children", "Attorneys General").
     *   When the name doesn't fit the regular spelling patterns for
     *   plurals, the object should simply override this routine to return
     *   the correct plural name string.
     */
    pluralName = (pluralNameFrom(name))

    /*
     *   Get the plural form of the given name string.  If the name ends in
     *   anything other than 'y', we'll add an 's'; otherwise we'll replace
     *   the 'y' with 'ies'.  We also handle abbreviations and individual
     *   letters specially.
     *
     *   This can only deal with simple adjective-noun forms.  For more
     *   complicated forms, particularly for compound words, it must be
     *   overridden (e.g., "Attorney General" -> "Attorneys General",
     *   "man-of-war" -> "men-of-war").  Likewise, names with irregular
     *   plurals ('child' -> 'children', 'man' -> 'men') must be handled
     *   with overrides.
     */
    pluralNameFrom(str)
    {
        //tadsSay('pluralNameFrom(<<str>>)\n');
        local len;
        local lastChar;
        local lastPair;

        /*
         *   if it's marked as having plural usage, just use the ordinary
         *   name, since it's already plural
         */
        if (isPlural || isMassNoun) {
            return str;
        }
        
        /* check for a 'phrase of phrase' format */
        if (rexMatch(patOfPhrase, str) != nil)
        {
            local ofSuffix;

            /*
             *   Pull out the two parts - the part up to the 'of' is the
             *   part we'll actually pluralize, and the rest is a suffix
             *   we'll stick on the end of the pluralized part.
             */
            str = rexGroup(1)[3];
            ofSuffix = rexGroup(2)[3];

            /*
             *   now pluralize the part up to the 'of' using the normal
             *   rules, then add the rest back in at the end
             */
            return pluralNameFrom(str) + ofSuffix;
        }

        /* if there's no short description, return an empty string */
        len = str.length();
        if (len == 0)
            return '';

        /*
         *   If it's only one character long, handle it specially.  If it's
         *   a lower-case letter, add an apostrophe-S.  If it's a capital
         *   A, E, I, M, U, or V, we'll add apostrophe-S (because these
         *   could be confused with words or common abbreviations if we
         *   just added "s": As, Es, Is, Ms, Us, Vs).  If it's anything
         *   else (any other capital letter, or any non-letter character),
         *   we'll just add an "s".
         */
        /*if (len == 1)
        {
            if (rexMatch(patSingleApostropheS, str) != nil)
                return str + 'or';
            else
                return str + 'a';
        }*/

        /* get the last character of the name, and the last pair of chars */
        lastChar = str.substr(len, 1);
        lastPair = (len == 1 ? lastChar : str.substr(len - 1, 2));

        /*
         *   If the last letter is a capital letter, assume it's an
         *   abbreviation without embedded periods (CPA, PC), in which case
         *   we just add an "s" (CPAs, PCs).  Likewise, if it's a number,
         *   just add "s": "the 1940s", "the low 20s".
         */
        if (rexMatch(patUpperOrDigit, lastChar) != nil)
            return str + 'er'; // I svenskan, t ex: PLUer, GSMer, CFOer

        /*
         *   If the last character is a period, it must be an abbreviation
         *   with embedded periods (B.A., B.S., Ph.D.).  In these cases,
         *   add an apostrophe-S.
         */
        if (lastChar == '.')
            return str + 'er'; // Ingen aning om detta alltid fungerar.

        /*
         *   If it ends in a non-vowel followed by 'y', change -y to -ies.
         *   (This doesn't apply if a vowel precedes a terminal 'y'; in
         *   such cases, we'll use the normal '-s' ending instead: "survey"
         *   -> "surveys", "essay" -> "essays", "day" -> "days".)
         */
        if (rexMatch(patVowelY, lastPair) != nil)
            return str.substr(1, len - 1) + 'er';

        /* if it ends in s, x, z, or h, add -es */
        if ('sxzh'.find(lastChar) != nil)
            return str + 'er';


        // TODO: hantera oregelbundna verb genom att skapa upp en ordlista 
        // med t ex de 200 vanligaste orden. Här nedan följer en rudimentär
        // och bristfällig härledning som inte håller måttet i längden.
        // Tvärtom räknar systemet med att användaren ska ange pluralformen
        // själv.

        // I de flesta fall i svenskan då det är plural läggs följande till:
        //  -ar, -or,-er , 
        // skärm-ar
        // mugg-ar
        // fläkt-ar
        if ('mgt'.find(lastChar) != nil)
            return str + 'ar';

        // äpple-n
        if ('n'.find(lastChar) != nil)
            return str + 'a';

        /* for anything else, just add -er */
        return str + 'er';
    }

    /* some pre-compiled patterns for pluralName */
    patSingleApostropheS = static new RexPattern('<case><lower|A|E|I|M|U|V>')
    patUpperOrDigit = static new RexPattern('<upper|digit>')
    patVowelY = static new RexPattern('[^aeoiu]y')
    patOfPhrase = static new RexPattern(
        '<nocase>(.+?)(<space>+of<space>+.+)')

    /* get my name plus a being verb ("the box is") */
    nameIs { return theName + ' ' + verbToBe; }

    /* get my name plus a negative being verb ("the box isn't") */
    nameIsnt { return nameIs + 'n&rsquo;t'; }

    /*
     *   My name with the given regular verb in agreement: in the present
     *   tense, if my name has singular usage, we'll add 's' to the verb,
     *   otherwise we won't.  In the past tense, we'll add 'd' (or 'ed').
     *   This can't be used with irregular verbs, or with regular verbs
     *   that have the last consonant repeated before the past -ed ending,
     *   such as "deter".
     */
    nameVerb(verb) { return theName + ' ' + conjugateRegularVerb(verb); }

    /* being verb agreeing with this object as subject */
    verbToBe
    {
        //return tSel(isPlural ? 'are' : 'is', isPlural ? 'were' : 'was');
        return tSel('är', 'var');
    }

    verbToTake { return tSel('tar', 'tog');}

    verbHere {return tSel('här', 'där'); }

    verbToSeem { return tSel('verkar', 'verkade'); }
    verbToPut { return tSel('sätter', 'satte'); }
    

    /* past tense being verb agreeing with object as subject */
    //verbWas { return tSel(isPlural ? 'were' : 'was', 'had been'); }
    verbWas { return tSel('var', 'hade varit'); }

    /* 'have' verb agreeing with this object as subject */
    verbToHave { return tSel('har' , 'hade'); } 

    /*
     *   A few common irregular verbs and name-plus-verb constructs,
     *   defined for convenience.
     */
    verbToDo = (tSel('gör', 'gjorde'))
    nameDoes = (theName + ' ' + verbToDo)
    verbToGo = (tSel('går', 'gick'))
    verbToCome = (tSel('kommer' , 'kom'))
    verbToCome2 = (tSel('anländer' , 'anlände'))
    
    //verbToLeave = (tSel('leave' + verbEndingS, 'left'))
    //verbToLeave = (tSel('går härifrån' , 'gick därifrån'))
    verbToLeave = (tSel('lämnar' , 'lämnade'))
    verbToLeave2 = (tSel('avlägnsnar' , 'avlägsnade'))
    verbToLeave3 = (tSel('beger' , 'begav'))

    //verbToSee = (tSel('ser' + verbEndingS, 'såg'))
    verbToSee = (tSel('ser', 'såg'))
    verbToHear = (tSel('hör', 'hörde'))


    nameSees = (theName + ' ' + verbToSee)
    nameSeem = (theName + ' ' + verbToSeem)
    verbToSay = (tSel('säger', 'sade'))
    nameSays = (theName + ' ' + verbToSay)
    verbMust = (tSel('måste', 'var tvungen'))
    verbCan = (tSel('kan', 'kunde'))
    verbCannot = (tSel('kan inte', 'kunde inte'))
    verbCant = (tSel('kan inte', 'kunde inte'))
    verbWill = (tSel('kommer', 'skulle'))
    verbWont = (tSel('kommer inte', 'skulle inte'))

    /*
     *   Verb endings for regular '-s' verbs, agreeing with this object as
     *   the subject.  We define several methods each of which handles the
     *   past tense differently.
     *
     *   verbEndingS doesn't try to handle the past tense at all - use it
     *   only in places where you know for certain that you'll never need
     *   the past tense form, or in expressions constructed with the tSel
     *   macro: use verbEndingS as the macro's first argument, and specify
     *   the past tense ending explicitly as the second argument.  For
     *   example, you could generate the correctly conjugated form of the
     *   verb "to fit" for an object named "key" with an expression such
     *   as:
     *
     *   'fit' + tSel(key.verbEndingS, 'ted')
     *
     *   This would generate 'fit', 'fits', or 'fitted' according to number
     *   and tense.
     *
     *   verbEndingSD and verbEndingSEd return 'd' and 'ed' respectively in
     *   the past tense.
     *
     *   verbEndingSMessageBuilder_ is for internal use only: it assumes
     *   that the correct ending to be displayed in the past tense is
     *   stored in langMessageBuilder.pastEnding_.  It is used as part of
     *   the string parameter substitution mechanism.
     */
    verbEndingS { return isPlural ? '' : ''; }
    verbEndingSD = (tSel(verbEndingS, 'd'))
    verbEndingSEd = (tSel(verbEndingS, 'ed'))
   

    //---------------------------------------------------

    verbEndingR { return 'r'; }

    verbEndingA { return 'a'; }

    // Böjer adjektivet utifrån objektets genus/form
    // Fungerar för t ex: ätbar{a}
    endingForNounTA {
        // self är gDobj i detta läge:
        if(self) {
            if(self.isPlural) {
                return 'a'; // plural / bestämd form
            }
            if(self.isNeuter) {
                return 't'; // ett-genus
            }
        }
        return ''; // en-genus
    }

    endingForNounA {
        // self är gDobj i detta läge:
        if(self.isPlural) {
            return 'a'; // plural / bestämd form
        }
        return ''; // ingen förändring
    }

    endingForNounAdAtNa {
        if(self.isPlural) {
            return 'na'; // plural / bestämd form
        }
        if(self.isNeuter) {
            return 'at'; // ett-genus
        }
        return 'ad'; // en-genus
    }

    endingForNounDTDa {
        if(self.isPlural) {
            return 'da'; // plural / bestämd form
        }
        if(self.isNeuter) {
            return 't'; // ett-genus
        }
        return 'd'; // en-genus
    }

    endingForNounEnEtNa {
        if(self.isPlural) {
            return 'na'; // plural / bestämd form
        }
        if(self.isNeuter) {
            return 'et'; // ett-genus
        }
        return 'en'; // en-genus
    }

    verbEndingAR { return 'ar'; }
    
    verbEndingT { return 't'; }
    
    verbEndingRDe = (tSel(verbEndingR, 'de'))
    
    verbEndingARDe = (tSel(verbEndingAR, 'ade'))

    verbEndingRMessageBuilder_ =
        (tSel(verbEndingR, langMessageBuilder.pastEnding_))





    //---------------------------------------------------


    verbEndingSMessageBuilder_ =
        (tSel(verbEndingS, langMessageBuilder.pastEnding_))


    
    /**
     * Verb som slutar på '-er/-te', t ex: tryck{er/te} 
     * 
     */
    verbEndingEr { return tSel('er', 'te'); }
    verbEndingErE { return tSel('er', 'e'); }


    /*
     *   Verb endings (present or past) for regular '-es/-ed' and
     *   '-y/-ies/-ied' verbs, agreeing with this object as the subject.
     */
    verbEndingEs { return tSel(isPlural ? '' : 'es', 'ed'); }
    verbEndingIes { return tSel(isPlural ? 'y' : 'ies', 'ied'); }

    /*
     *   Dummy name - this simply displays nothing; it's used for cases
     *   where messageBuilder substitutions want to refer to an object (for
     *   internal bookkeeping) without actually showing the name of the
     *   object in the output text.  This should always simply return an
     *   empty string.
     */
    dummyName = ''

    /*
     *   Invoke a property (with an optional argument list) on this object
     *   while temporarily switching to the present tense, and return the
     *   result.
     */
    propWithPresent(prop, [args])
    {
        return withPresent({: self.(prop)(args...)});
    }

    /*
     *   Method for internal use only: invoke on this object the property
     *   stored in langMessageBuilder.fixedTenseProp_ while temporarily
     *   switching to the present tense, and return the result.  This is
     *   used as part of the string parameter substitution mechanism.
     */
    propWithPresentMessageBuilder_
    {
        return propWithPresent(langMessageBuilder.fixedTenseProp_);
    }

    /*
     *   For the most part, "strike" has the same meaning as "hit", so
     *   define this as a synonym for "attack" most objects.  There are a
     *   few English idioms where "strike" means something different, as
     *   in "strike match" or "strike tent."
     */
    dobjFor(Strike) asDobjFor(Attack)
;

/* ------------------------------------------------------------------------ */
/*
 *   An object that uses the same name as another object.  This maps all of
 *   the properties involved in supplying the object's name, number, and
 *   other usage information from this object to a given target object, so
 *   that all messages involving this object use the same name as the
 *   target object.  This is a mix-in class that can be used with any other
 *   class.
 *   
 *   Note that we map only the *reported* name for the object.  We do NOT
 *   give this object any vocabulary from the other object; in other words,
 *   we don't enter this object into the dictionary with the other object's
 *   vocabulary words.  
 */
class NameAsOther: object
    /* the target object - we'll use the same name as this object */
    targetObj = nil

    /* map our naming and usage properties to the target object */
    isPlural = (targetObj.isPlural)
    isMassNoun = (targetObj.isMassNoun)
    isHim = (targetObj.isHim)
    isHer = (targetObj.isHer)
    isIt = (targetObj.isIt)
    isProperName = (targetObj.isProperName)
    isQualifiedName = (targetObj.isQualifiedName)
    name = (targetObj.name)

    /* map the derived name properties as well, in case any are overridden */
    disambigName = (targetObj.disambigName)
    theDisambigName = (targetObj.theDisambigName)
    aDisambigName = (targetObj.aDisambigName)
    countDisambigName(cnt) { return targetObj.countDisambigName(cnt); }
    disambigEquivName = (targetObj.disambigEquivName)
    listName = (targetObj.listName)
    countName(cnt) { return targetObj.countName(cnt); }

    /* map the pronoun properites, in case any are overridden */
    itNom = (targetObj.itNom)
    itObj = (targetObj.itObj)
    itPossAdj = (targetObj.itPossAdj)
    itPossNoun = (targetObj.itPossNoun)
    itReflexive = (targetObj.itReflexive)
    thatNom = (targetObj.thatNom)
    thatObj = (targetObj.thatObj)
    itVerb(verb) { return targetObj.itVerb(verb); }
    conjugateRegularVerb(verb)
        { return targetObj.conjugateRegularVerb(verb); }
    theName = (targetObj.theName)
    theNameObj = (targetObj.theNameObj)
    theNamePossAdj = (targetObj.theNamePossAdj)
    theNamePossNoun = (targetObj.theNamePossNoun)
    theNameWithOwner = (targetObj.theNameWithOwner)
    aNameOwnerLoc(ownerPri)
        { return targetObj.aNameOwnerLoc(ownerPri); }
    theNameOwnerLoc(ownerPri)
        { return targetObj.theNameOwnerLoc(ownerPri); }
    countNameOwnerLoc(cnt, ownerPri)
        { return targetObj.countNameOwnerLoc(cnt, ownerPri); }
    notePromptByOwnerLoc(ownerPri)
        { targetObj.notePromptByOwnerLoc(ownerPri); }
    notePromptByPossAdj()
        { targetObj.notePromptByPossAdj(); }
    aName = (targetObj.aName)
    aNameObj = (targetObj.aNameObj)
    pluralName = (targetObj.pluralName)
    nameIs = (targetObj.nameIs)
    nameIsnt = (targetObj.nameIsnt)
    nameVerb(verb) { return targetObj.nameVerb(verb); }
    verbToBe = (targetObj.verbToBe)
    verbWas = (targetObj.verbWas)
    verbToHave = (targetObj.verbToHave)
    verbToDo = (targetObj.verbToDo)
    nameDoes = (targetObj.nameDoes)
    verbToGo = (targetObj.verbToGo)
    verbToCome = (targetObj.verbToCome)
    verbToLeave = (targetObj.verbToLeave)
    verbToSee = (targetObj.verbToSee)
    nameSees = (targetObj.nameSees)
    verbToSay = (targetObj.verbToSay)
    nameSays = (targetObj.nameSays)
    verbMust = (targetObj.verbMust)
    verbCan = (targetObj.verbCan)
    verbCannot = (targetObj.verbCannot)
    verbCant = (targetObj.verbCant)
    verbWill = (targetObj.verbWill)
    verbWont = (targetObj.verbWont)

    verbEndingS = (targetObj.verbEndingS)
    verbEndingSD = (targetObj.verbEndingSD)
    verbEndingSEd = (targetObj.verbEndingSEd)
    verbEndingEs = (targetObj.verbEndingEs)
    verbEndingIes = (targetObj.verbEndingIes)

;

/*
 *   Name as Parent - this is a special case of NameAsOther that uses the
 *   lexical parent of a nested object as the target object.  (The lexical
 *   parent is the enclosing object in a nested object definition; in other
 *   words, it's the object in which the nested object is embedded.)  
 */
class NameAsParent: NameAsOther
    targetObj = (lexicalParent)
;

/*
 *   ChildNameAsOther is a mix-in class that can be used with NameAsOther
 *   to add the various childInXxx naming to the mapped properties.  The
 *   childInXxx names are the names generated when another object is
 *   described as located within this object; by mapping these properties
 *   to our target object, we ensure that we use exactly the same phrasing
 *   as we would if the contained object were actually contained by our
 *   target rather than by us.
 *   
 *   Note that this should always be used in combination with NameAsOther:
 *   
 *   myObj: NameAsOther, ChildNameAsOther, Thing ...
 *   
 *   You can also use it the same way in combination with a subclass of
 *   NameAsOther, such as NameAsParent.  
 */
class ChildNameAsOther: object
    objInPrep = (targetObj.objInPrep)
    actorInPrep = (targetObj.actorInPrep)
    actorOutOfPrep = (targetObj.actorOutOfPrep)
    actorIntoPrep = (targetObj.actorIntoPrep)
    childInName(childName) { return targetObj.childInName(childName); }
    childInNameWithOwner(childName)
        { return targetObj.childInNameWithOwner(childName); }
    childInNameGen(childName, myName)
        { return targetObj.childInNameGen(childName, myName); }
    actorInName = (targetObj.actorInName)
    actorOutOfName = (targetObj.actorOutOfName)
    actorIntoName = (targetObj.actorIntoName)
    actorInAName = (targetObj.actorInAName)
;


/* ------------------------------------------------------------------------ */
/*
 *   Language modifications for the specialized container types
 */
modify Surface
    /*
     *   objects contained in a Surface are described as being on the
     *   Surface
     */
    objInPrep = 'på'
    actorInPrep = 'på'
    actorOutOfPrep = 'av från'
;

modify Underside
    objInPrep = 'under'
    actorInPrep = 'under'
    actorOutOfPrep = 'från undersidan'
;

modify RearContainer
    objInPrep = 'bakom'
    actorInPrep = 'bakom'
    actorOutOfPrep = 'från baksidan'
;

/* ------------------------------------------------------------------------ */
/*
 *   Language modifications for Actor.
 *   
 *   An Actor has a "referral person" setting, which determines how we
 *   refer to the actor; this is almost exclusively for the use of the
 *   player character.  The typical convention is that we refer to the
 *   player character in the second person, but a game can override this on
 *   an actor-by-actor basis.  
 */
modify Actor
    /* by default, use my pronoun for my name */
    name = (itNom)

    /*
     *   Pronoun selector.  This returns an index for selecting pronouns
     *   or other words based on number and gender, taking into account
     *   person, number, and gender.  The value returned is the sum of the
     *   following components:
     *
     *   number/gender:
     *.  - singular neuter = 1
     *.  - singular masculine = 2
     *.  - singular feminine = 3
     *.  - plural = 4
     *
     *   person:
     *.  - first person = 0
     *.  - second person = 4
     *.  - third person = 8
     *
     *   The result can be used as a list selector as follows (1=first
     *   person, etc; s=singular, p=plural; n=neuter, m=masculine,
     *   f=feminine):
     *
     *   [1/s/n, 1/s/m, 1/s/f, 1/p, 2/s/n, 2/s/m, 2/s/f, 2/p,
     *.  3/s/n, 3/s/m, 3/s/f, 3/p]
     */
    pronounSelector
    {
        return ((referralPerson - FirstPerson)*4
                + (isPlural ? 4 : isHim ? 2 : isHer ? 3 : 1));
    }

    /*
     *   get the verb form selector index for the person and number:
     *
     *   [1/s, 2/s, 3/s, 1/p, 2/p, 3/p]
     */
    conjugationSelector
    {
        return (referralPerson + (isPlural ? 3 : 0));
    }

    /*
     *   get an appropriate pronoun for the object in the appropriate
     *   person for the nominative case, objective case, possessive
     *   adjective, possessive noun, and objective reflexive
     */
    itNom
    {
        return ['jag', 'jag', 'jag', 'vi',
               'du', 'du', 'du', 'ni',
               (isNeuter?'det':'den'), 'han', 'hon', 'de'][pronounSelector];

    }

    itObj
    {
        return ['mig', 'mig', 'mig', 'oss',
               'dig', 'dig', 'dig', 'er',
               (isNeuter?'det':'den'), 'honom', 'henne', 'dem'][pronounSelector];
    }
    


    // defaultar till neutrum för att matcha mot ditt/mitt etc om detta 
    // objekt är huvudkaraktären. De flesta levande ting är utrum
    isNeuter = nil 

    itPossAdj
    {    
        //   [1/s/n, 1/s/m, 1/s/f, 1/p, 
        //    2/s/n, 2/s/m, 2/s/f, 2/p,
        //    3/s/n, 3/s/m, 3/s/f, 3/p]
        if (isNeuter) {
            return ['mitt', 'mitt', 'mitt', 'vårt',
                    'ditt', 'ditt', 'ditt', 'ert',
                    'sitt', 'hans', 'hennes', 'deras'][pronounSelector];
        }
        return ['min', 'min', 'min', 'vår',
                'din', 'din', 'din', 'er',
                'sin', 'hans', 'hennes', 'deras'][pronounSelector];
    }

    itPossAdjPlural 
    {
        return ['mina', 'mina', 'mina', 'våra',
               'dina', 'dina', 'dina', 'dina',
               'dessas', 'deras', 'deras', 'deras'][pronounSelector];
    }

    itPossNoun
    {
        if(gDobj) {
        if (gDobj.isPlural) {
                return ['mina', 'mina', 'mina', 'våra',
                        'dina', 'dina', 'dina', 'era',
                        'deras', 'hans', 'hennes', 'deras'][pronounSelector];
            }
            if (gDobj.isNeuter) {
                return ['mitt', 'mitt', 'mitt', 'vårat',
                        'ditt', 'ditt', 'ditt', 'erat',
                        'dess', 'hans', 'hennes', 'deras'][pronounSelector];
            }
                    //1a,   han,   hon,   plural
            return ['min', 'min',  'min', 'vår',    // 1a perspektiv
                    'din', 'din',  'din', 'er',     // 2a perspektiv
                    'sin', 'hans', 'hennes', 'deras'][pronounSelector]; //3e perspektiv
        }

        if (isPlural) {
            return ['mina', 'mina', 'mina', 'våra',
                    'dina', 'dina', 'dina', 'era',
                    'deras', 'hans', 'hennes', 'deras'][pronounSelector];
        }
        if (isNeuter) {
            return ['mitt', 'mitt', 'mitt', 'vårat',
                    'ditt', 'ditt', 'ditt', 'erat',
                    'dess', 'hans', 'hennes', 'deras'][pronounSelector];        
        }
                //1a,   han,   hon,   plural
        return ['min', 'min',  'min', 'vår',    // 1a perspektiv
                'din', 'din',  'din', 'er',     // 2a perspektiv
                'sin', 'hans', 'hennes', 'deras'][pronounSelector]; //3e perspektiv
    }
    
    itReflexiveSimple
    { 
            //  'myself', 'myself', 'myself', 'ourselves',
        return ['mig', 'mig', 'mig', 'oss',
            // 'yourself', 'yourself', 'yourself', 'yourselves',
                'dig', 'dig', 'dig', 'er',
               // 'itself', 'himself', 'herself', 'themselves'
               'sig', 'sig', 'sig', 'sig'][pronounSelector];
    }

    itReflexive
    { 
            //  'myself', 'myself', 'myself', 'ourselves',
        return ['mig själv', 'mig själv', 'mig själv', 'oss själva',
            // 'yourself', 'yourself', 'yourself', 'yourselves',
                'dig själv', 'dig själv', 'dig själv', 'er själva',
               // 'itself', 'himself', 'herself', 'themselves'
               'sig självt', 'sig själv', 'sig själv', 'sig själva'][pronounSelector];
    }

    /*
     *   Conjugate a regular verb in the present or past tense for our
     *   person and number.
     *
     *   In the present tense, this is pretty easy: we add an 's' for the
     *   third person singular, and leave the verb unchanged for every
     *   other case.  The only complication is that we must check some
     *   special cases to add the -s suffix: -y -> -ies, -o -> -oes.
     *
     *   In the past tense, we use the inherited handling since the past
     *   tense ending doesn't vary with person.
     */
    conjugateRegularVerb(verb)
    {
        /*
         *   If we're in the third person or if we use the past tense,
         *   inherit the default handling; otherwise, use the base verb
         *   form regardless of number (regular verbs use the same
         *   conjugated forms for every case but third person singular: I
         *   ask, you ask, we ask, they ask).
         */
        if (referralPerson != ThirdPerson && !gameMain.usePastTense)
        {
            /*
             *   we're not using the third-person or the past tense, so the
             *   conjugation is the same as the base verb form
             */
            return verb;
        }
        else
        {
            /*
             *   we're using the third person or the past tense, so inherit
             *   the base class handling, which conjugates these forms
             */
            return inherited(verb);
        }
    }

    /*
     *   Get the name with a definite article ("the box").  If the
     *   narrator refers to us in the first or second person, use a
     *   pronoun rather than the short description.
     */
    theName
        { return (referralPerson == ThirdPerson ? inherited : itNom); }

    /* theName in objective case */
    theNameObj
        { return (referralPerson == ThirdPerson ? inherited : itObj); }

    /* theName as a possessive adjective */
    theNamePossAdj
        { return (referralPerson == ThirdPerson ? inherited : itPossAdj); }

    /* theName as a possessive adjective and in plural form */
    theNamePossAdjPlural
        { return (referralPerson == ThirdPerson ? inherited : itPossAdjPlural); }

    /* theName as a possessive noun */
    theNamePossNoun
    { return (referralPerson == ThirdPerson ? inherited : itPossNoun); }

    /*
     *   Get the name with an indefinite article.  Use the same rules of
     *   referral person as for definite articles.
     */
    aName { return (referralPerson == ThirdPerson ? inherited : itNom); }

    /* aName in objective case */
    aNameObj { return (referralPerson == ThirdPerson ? inherited : itObj); }

    /* being verb agreeing with this object as subject */
    verbToBe
    {
        return tSel(['är', 'är', 'är', 'är', 'är', 'är'],
                    ['var', 'var', 'var', 'var', 'var', 'var'])
               [conjugationSelector];
    }

    /* past tense being verb agreeing with this object as subject */
    verbWas
    {
        return tSel(['var', 'var', 'var', 'var', 'var', 'var']
                    [conjugationSelector], 'hade varit');
    }

    /* 'have' verb agreeing with this object as subject */
    verbToHave
    {
        return tSel(['har', 'har', 'har', 'har', 'har', 'har']
                    [conjugationSelector], 'hade');
    }

    /*
     *   verb endings for regular '-s' and '-es' verbs, agreeing with this
     *   object as the subject
     */
    verbEndingS
    {
        return ['', '', 'r', '', '', ''][conjugationSelector];
    }
    verbEndingEs
    {
        return tSel(['', '', 'es', '', '', ''][conjugationSelector], 'ed');
    }
    verbEndingIes
    {
        return tSel(['y', 'y', 'ies', 'y', 'y', 'y'][conjugationSelector],
                    'ied');
    }

    /* "I'm not" doesn't fit the regular "+n't" rule */
    nameIsnt
    {
        return conjugationSelector == 1 && !gameMain.usePastTense
            ? 'I&rsquo;m not' : inherited;
    }

    /*
     *   Show my name for an arrival/departure message.  If we've been seen
     *   before by the player character, we'll show our definite name,
     *   otherwise our indefinite name.
     */
    travelerName(arriving)
        { say(gPlayerChar.hasSeen(self) ? theName : aName); }

    /*
     *   Test to see if we can match the third-person pronouns.  We'll
     *   match these if our inherited test says we match them AND we can
     *   be referred to in the third person.
     */
    canMatchHim = (inherited && canMatch3rdPerson)
    canMatchHer = (inherited && canMatch3rdPerson)
    canMatchIt = (inherited && canMatch3rdPerson)
    canMatchThem = (inherited && canMatch3rdPerson)

    /*
     *   Test to see if we can match a third-person pronoun ('it', 'him',
     *   'her', 'them').  We can unless we're the player character and the
     *   player character is referred to in the first or second person.
     */
    canMatch3rdPerson = (!isPlayerChar || referralPerson == ThirdPerson)

    /*
     *   Set a pronoun antecedent to the given list of ResolveInfo objects.
     *   Pronoun handling is language-specific, so this implementation is
     *   part of the English library, not the generic library.
     *
     *   If only one object is present, we'll set the object to be the
     *   antecedent of 'it', 'him', or 'her', according to the object's
     *   gender.  We'll also set the object as the single antecedent for
     *   'them'.
     *
     *   If we have multiple objects present, we'll set the list to be the
     *   antecedent of 'them', and we'll forget about any antecedent for
     *   'it'.
     *
     *   Note that the input is a list of ResolveInfo objects, so we must
     *   pull out the underlying game objects when setting the antecedents.
     */
    setPronoun(lst)
    {
        /* if the list is empty, ignore it */
        if (lst == [])
            return;

        /*
         *   if we have multiple objects, the entire list is the antecedent
         *   for 'them'; otherwise, it's a singular antecedent which
         *   depends on its gender
         */
        if (lst.length() > 1)
        {
            local objs = lst.mapAll({x: x.obj_});

            /* it's 'them' */
            setThem(objs);

            /* forget any 'it' */
            setIt(nil);
        }
        else if (lst.length() == 1)
        {
            /*
             *   We have only one object, so set it as an antecedent
             *   according to its gender.
             */
            setPronounObj(lst[1].obj_);
        }
    }

    /*
     *   Set a pronoun to refer to multiple potential antecedents.  This is
     *   used when the verb has multiple noun slots - UNLOCK DOOR WITH KEY.
     *   For verbs like this, we have no way of knowing in advance whether
     *   a future pronoun will refer back to the direct object or the
     *   indirect object (etc) - we could just assume that 'it' will refer
     *   to the direct object, but this won't always be what the player
     *   intended.  In natural English, pronoun antecedents must often be
     *   inferred from context at the time of use - so we use the same
     *   approach.
     *
     *   Pass an argument list consisting of ResolveInfo lists - that is,
     *   pass one argument per noun slot in the verb, and make each
     *   argument a list of ResolveInfo objects.  In other words, you call
     *   this just as you would setPronoun(), except you can pass more than
     *   one list argument.
     *
     *   We'll store the multiple objects as antecedents.  When we need to
     *   resolve a future singular pronoun, we'll figure out which of the
     *   multiple antecedents is the most logical choice in the context of
     *   the pronoun's usage.
     */
    setPronounMulti([args])
    {
        local lst, subLst;
        local gotThem;

        /*
         *   If there's a plural list, it's 'them'.  Arbitrarily use only
         *   the first plural list if there's more than one.
         */
        if ((lst = args.valWhich({x: x.length() > 1})) != nil)
        {
            /* set 'them' to the plural list */
            setPronoun(lst);

            /* note that we had a clear 'them' */
            gotThem = true;
        }

        /* from now on, consider only the sublists with exactly one item */
        args = args.subset({x: x.length() == 1});

        /* get a list of the singular items from the lists */
        lst = args.mapAll({x: x[1].obj_});

        /*
         *   Set 'it' to all of the items that can match 'it'; do likewise
         *   with 'him' and 'her'.  If there are no objects that can match
         *   a given pronoun, leave that pronoun unchanged.  
         */

        if ((subLst = lst.subset({x: x.canMatchIt})).length() > 0)
            setIt(subLst);
        if ((subLst = lst.subset({x: x.canMatchHim})).length() > 0)
            setHim(subLst);
        if ((subLst = lst.subset({x: x.canMatchHer})).length() > 0)
            setHer(subLst);

        /*
         *   set 'them' to the potential 'them' matches, if we didn't
         *   already find a clear plural list
         */
        if (!gotThem
            && (subLst = lst.subset({x: x.canMatchThem})).length() > 0)
            setThem(subLst);
    }

    /*
     *   Set a pronoun antecedent to the given ResolveInfo list, for the
     *   specified type of pronoun.  We don't have to worry about setting
     *   other types of pronouns to this antecedent - we specifically want
     *   to set the given pronoun type.  This is language-dependent
     *   because we still have to figure out the number (i.e. singular or
     *   plural) of the pronoun type.
     */
    setPronounByType(typ, lst)
    {
        /* check for singular or plural pronouns */
        if (typ == PronounThem)
        {
            /* it's plural - set a list antecedent */
            setPronounAntecedent(typ, lst.mapAll({x: x.obj_}));
        }
        else
        {
            /* it's singular - set an individual antecedent */
            setPronounAntecedent(typ, lst[1].obj_);
        }
    }

    /*
     *   Set a pronoun antecedent to the given simulation object (usually
     *   an object descended from Thing).
     */
    setPronounObj(obj)
    {
        /*
         *   Actually use the object's "identity object" as the antecedent
         *   rather than the object itself.  In some cases, we use multiple
         *   program objects to represent what appears to be a single
         *   object in the game; in these cases, the internal program
         *   objects all point to the "real" object as their identity
         *   object.  Whenever we're manipulating one of these internal
         *   program objects, we want to make sure that its the
         *   player-visible object - the identity object - that appears as
         *   the antecedent for subsequent references.
         */
        obj = obj.getIdentityObject();

        /*
         *   Set the appropriate pronoun antecedent, depending on the
         *   object's gender.
         *
         *   Note that we'll set an object to be the antecedent for both
         *   'him' and 'her' if the object has both masculine and feminine
         *   usage.
         */

        /* check for masculine usage */
        if (obj.canMatchHim)
            setHim(obj);

        /* check for feminine usage */
        if (obj.canMatchHer)
            setHer(obj);

        /* check for neuter usage */
        if (obj.canMatchIt)
            setIt(obj);

        /* check for third-person plural usage */
        if (obj.canMatchThem)
            setThem([obj]);
    }

    /* set a possessive anaphor */
    setPossAnaphorObj(obj)
    {
        /* check for each type of usage */
        if (obj.canMatchHim)
            possAnaphorTable[PronounHim] = obj;
        if (obj.canMatchHer)
            possAnaphorTable[PronounHer] = obj;
        if (obj.canMatchIt)
            possAnaphorTable[PronounIt] = obj;
        if (obj.canMatchThem)
            possAnaphorTable[PronounThem] = [obj];
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   Give the postures some additional attributes
 */

modify Posture

    /*
     *   Intransitive and transitive forms of the verb, for use in library
     *   messages.  Each of these methods simply calls one of the two
     *   corresponding fixed-tense properties, depending on the current
     *   tense.
     */
    msgVerbI = (tSel(msgVerbIPresent, msgVerbIPast))
    msgVerbT = (tSel(msgVerbTPresent, msgVerbTPast))

    /*
     *   Fixed-tense versions of the above properties, to be defined
     *   individually by each instance of the Posture class.
     */

    /* our present-tense intransitive form ("he stands up") */
    // msgVerbIPresent = 'stand{s} up'

    /* our past-tense intransitive form ("he stood up") */
    // msgVerbIPast = 'stood up'

    /* our present-tense transitive form ("he stands on the chair") */
    // msgVerbTPresent = 'stand{s}'

    /* our past-tense transitive form ("he stood on the chair") */
    // msgVerbTPast = 'stood'

    /* our active form */
    // active = 'standing'
;

modify standing
    msgVerbIPresent = 'ställer {mig} upp' //'stå{r} up'  'stand{s} up'
    msgVerbIPast = 'stod upp' // 'stood up'
    msgVerbTPresent = 'står' // 'stand{s}'
    msgVerbTPast = 'stod' // 'stood'
    // active motsvarar engelskans participle (t ex = 'standing'),
    // men vi skriver inte i participform i svenskan då det låter konstigt.
    active() {
        return gameMain.usePastTense ? self.msgVerbTPast : self.msgVerbTPresent;
    }  
    //participle = 'ståendes' // används inte
;

modify sitting
    msgVerbIPresent = 'sätter {mig} ner' //'sit{s} down'
    msgVerbIPast = 'satte {mig} ner' //'sat down'
    msgVerbTPresent = 'sitter' //'sit{s}'
    msgVerbTPast = 'satt' //'sat'
    // active motsvarar engelskans participle (t ex = 'sitting'),
    // men vi skriver inte i participform i svenskan då det låter konstigt.
    active() {
        return gameMain.usePastTense ? msgVerbTPast : msgVerbTPresent;
    }  
    // participle = 'sittande' // används inte
;

modify lying
    msgVerbIPresent = 'lägger {mig} ner' // 'lie{s} down'
    msgVerbIPast = 'lade {mig} ner' // 'lay down'
    msgVerbTPresent = 'ligger' // 'lie{s}'
    msgVerbTPast = 'låg' // 'lay'
    // active motsvarar engelskans participle (t ex = 'lying'),
    // men vi skriver inte i participform i svenskan då det låter konstigt.
    active() {
        return gameMain.usePastTense ? msgVerbTPast : msgVerbTPresent;
    }  

;

/* ------------------------------------------------------------------------ */
/*
 *   For our various topic suggestion types, we can infer the full name
 *   from the short name fairly easily.
 */
modify SuggestedAskTopic
    fullName = ('fråga {ref targetActor/honom} om ' + name)
;

modify SuggestedTellTopic
    fullName = ('berätta för {ref targetActor/honom} om ' + name)
;

modify SuggestedAskForTopic
    // Alt. "Be om"
    fullName = ('fråga {ref targetActor/honom} efter ' + name)
;

modify SuggestedGiveTopic
    fullName = ('ge {ref targetActor/honom} ' + name)
;

modify SuggestedShowTopic
    fullName = ('visa {ref targetActor/honom} ' + name)
;

modify SuggestedYesTopic
    name = 'ja'
    fullName = 'säg ja'
;

modify SuggestedNoTopic
    name = 'nej'
    fullName = 'säg nej'
;

/* ------------------------------------------------------------------------ */
/*
 *   Provide custom processing of the player input for matching
 *   SpecialTopic patterns.  When we're trying to match a player's command
 *   to a set of active special topics, we'll run the input through this
 *   processing to produce the string that we actually match against the
 *   special topics.
 *
 *   First, we'll remove any punctuation marks.  This ensures that we'll
 *   still match a special topic, for example, if the player puts a period
 *   or a question mark at the end of the command.
 *
 *   Second, if the user's input starts with "A" or "T" (the super-short
 *   forms of the ASK ABOUT and TELL ABOUT commands), remove the "A" or "T"
 *   and keep the rest of the input.  Some users might think that special
 *   topic suggestions are meant as ask/tell topics, so they might
 *   instinctively try these as A/T commands.
 *
 *   Users *probably* won't be tempted to do the same thing with the full
 *   forms of the commands (e.g., ASK BOB ABOUT APOLOGIZE, TELL BOB ABOUT
 *   EXPLAIN).  It's more a matter of habit of using A or T for interaction
 *   that would tempt a user to phrase a special topic this way; once
 *   you're typing out the full form of the command, it generally won't be
 *   grammatical, as special topics generally contain the sense of a verb
 *   in their phrasing.
 */
modify specialTopicPreParser
    processInputStr(str)
    {
        /*
         *   remove most punctuation from the string - we generally want to
         *   ignore these, as we mostly just want to match keywords
         */
        str = rexReplace(punctPat, str, '', ReplaceAll);

        /* if it starts with "A" or "T", strip off the leading verb */
        if (rexMatch(aOrTPat, str) != nil)
            str = rexGroup(1)[3];

        /* return the processed result */
        return str;
    }

    /* pattern for string starting with "A" or "T" verbs 
        I svenskan f - för fråga, b - för berätta
    */
    aOrTPat = static new RexPattern(
        '<nocase><space>*[fb]<space>+(<^space>.*)$')

    /* pattern to eliminate punctuation marks from the string */
    punctPat = static new RexPattern('[.?!,;:]');
;

/*
 *   For SpecialTopic matches, treat some strings as "weak": if the user's
 *   input consists of just one of these weak strings and nothing else,
 *   don't match the topic.
 */
modify SpecialTopic
    matchPreParse(str, procStr)
    {
        /* if it's one of our 'weak' strings, don't match */
        if (rexMatch(weakPat, str) != nil)
            return nil;

        /* it's not a weak string, so match as usual */
        return inherited(str, procStr);
    }

    /*
     *   Our "weak" strings - 'i', 'l', 'look': these are weak because a
     *   user typing one of these strings by itself is probably actually
     *   trying to enter the command of the same name, rather than entering
     *   a special topic.  These come up in cases where the special topic
     *   is something like "say I don't know" or "tell him you'll look into
     *   it".
     */

     // TODO: kontrollera vilka fall weakPat behöver uttökas i just svenskan
     // i dessa scenarios kommer inte orden att riskera ihopblandning med ett annat
     // kommando.
     // Eng org: weakPat = static new RexPattern('<nocase><space>*(i|l|look)<space>*$')
     weakPat = static new RexPattern('<nocase><space>*(kolla)<space>*$')
;

/* ------------------------------------------------------------------------ */
/*
 *   English-specific Traveler changes
 */
modify Traveler
    /*
     *   Get my location's name, from the PC's perspective, for describing
     *   my arrival to or departure from my current location.  We'll
     *   simply return our location's destName, or "the area" if it
     *   doesn't have one.
     */
    travelerLocName()
    {
        /* get our location's name from the PC's perspective */
        local nm = location.getDestName(gPlayerChar, gPlayerChar.location);
        /* if there's a name, return it; otherwise, use "the area" */
        return (nm != nil ? nm : 'platsen');
    }

    /*
     *   Get my "remote" location name, from the PC's perspective.  This
     *   returns my location name, but only if my location is remote from
     *   the PC's perspective - that is, my location has to be outside of
     *   the PC's top-level room.  If we're within the PC's top-level
     *   room, we'll simply return an empty string.
     */
    travelerRemoteLocName()
    {
        /*
         *   if my location is outside of the PC's outermost room, we're
         *   remote, so return my location name; otherwise, we're local,
         *   so we don't need a remote name at all
         */
        if (isIn(gPlayerChar.getOutermostRoom()))
            return '';
        else
            return travelerLocName;
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   English-specific Vehicle changes
 */
modify Vehicle
    /*
     *   Display the name of the traveler, for use in an arrival or
     *   departure message.
     */
    travelerName(arriving)
    {
        /*
         *   By default, start with the indefinite name if we're arriving,
         *   or the definite name if we're leaving.
         *
         *   If we're leaving, presumably they've seen us before, since we
         *   were already in the room to start with.  Since we've been
         *   seen before, the definite is appropriate.
         *
         *   If we're arriving, even if we're not being seen for the first
         *   time, we haven't been seen yet in this place around this
         *   time, so the indefinite is appropriate.
         */
        say(arriving ? aName : theName);

        /* show the list of actors aboard */
        aboardVehicleListerObj.showList(
            libGlobal.playerChar, nil, allContents(), 0, 0,
            libGlobal.playerChar.visibleInfoTable(), nil);
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   English-specific PushTraveler changes
 */
modify PushTraveler
    /*
     *   When an actor is pushing an object from one room to another, show
     *   its name with an additional clause indicating the object being
     *   moved along with us.
     */
    travelerName(arriving)
    {
        "<<gPlayerChar.hasSeen(self) ? theName : aName>>,
        puttar <<obj_.theNameObj>> framför {sig}, ";
    }
;


/* ------------------------------------------------------------------------ */
/*
 *   English-specific travel connector changes
 */

modify PathPassage
    /* treat "take path" the same as "enter path" or "go through path" */
    dobjFor(Take) maybeRemapTo(
        gAction.getEnteredVerbPhrase() == 'ta (dobj)', TravelVia, self)

    dobjFor(Enter)
    {
        verify() { logicalRank(50, 'enter path'); }
    }
    dobjFor(GoThrough)
    {
        verify() { logicalRank(50, 'enter path'); }
    }
;

modify AskConnector
    /*
     *   This is the noun phrase we'll use when asking disambiguation
     *   questions for this travel connector: "Which *one* do you want to
     *   enter..."
     */
    travelObjsPhrase = 'en'
;

/* ------------------------------------------------------------------------ */
/*
 *   English-specific changes for various nested room types.
 */
modify BasicChair
    /* by default, one sits *on* a chair */
    objInPrep = 'på'
    actorInPrep = 'på'
    actorOutOfPrep = 'av från'
;

modify BasicPlatform
    /* by default, one stands *on* a platform */
    objInPrep = 'på'
    actorInPrep = 'på'
    actorOutOfPrep = 'av från'
;

modify Booth
    /* by default, one is *in* a booth */
    objInPrep = 'i'
    actorInPrep = 'i'
    actorOutOfPrep = 'ut från'
;

/* ------------------------------------------------------------------------ */
/*
 *   Language modifications for Matchstick
 */
modify Matchstick
    /* "strike match" means "light match" */
    dobjFor(Strike) asDobjFor(Burn)

    /* "light match" means "burn match" */
    dobjFor(Light) asDobjFor(Burn)
;

/*
 *   Match state objects.  We show "lit" as the state for a lit match,
 *   nothing for an unlit match.
 */
matchStateLit: ThingState 'tänd'
    stateTokens = ['tänd']
;
matchStateUnlit: ThingState
    stateTokens = ['släckt']
;


/* ------------------------------------------------------------------------ */
/*
 *   English-specific modifications for Room.
 */
modify Room
    isProperName = true // En rumstitel skrivs oftast i bestämd form i svenskan

    /*
     *   The ordinary 'name' property is used the same way it's used for
     *   any other object, to refer to the room when it shows up in
     *   library messages and the like: "You can't take the hallway."
     *
     *   By default, we derive the name from the roomName by converting
     *   the roomName to lower case.  Virtually every room will need a
     *   custom room name setting, since the room name is used mostly as a
     *   title for the room, and good titles are hard to generate
     *   mechanically.  Many times, converting the roomName to lower case
     *   will produce a decent name to use in messages: "Ice Cave" gives
     *   us "You can't eat the ice cave."  However, games will want to
     *   customize the ordinary name separately in many cases, because the
     *   elliptical, title-like format of the room name doesn't always
     *   translate well to an object name: "West of Statue" gives us the
     *   unworkable "You can't eat the west of statue"; better to make the
     *   ordinary name something like "plaza".  Note also that some rooms
     *   have proper names that want to preserve their capitalization in
     *   the ordinary name: "You can't eat the Hall of the Ancient Kings."
     *   These cases need to be customized as well.
     */
    name = (roomName.toLower())

    /*
     *   The "destination name" of the room.  This is primarily intended
     *   for use in showing exit listings, to describe the destination of
     *   a travel connector leading away from our current location, if the
     *   destination is known to the player character.  We also use this
     *   as the default source of the name in similar contexts, such as
     *   when we can see this room from another room connected by a sense
     *   connector.
     *
     *   The destination name usually mirrors the room name, but we use
     *   the name in prepositional phrases involving the room ("east, to
     *   the alley"), so this name should include a leading article
     *   (usually definite - "the") unless the name is proper ("east, to
     *   Dinsley Plaza").  So, by default, we simply use the "theName" of
     *   the room.  In many cases, it's better to specify a custom
     *   destName, because this name is used when the PC is outside of the
     *   room, and thus can benefit from a more detailed description than
     *   we'd normally use for the basic name.  For example, the ordinary
     *   name might simply be something like "hallway", but since we want
     *   to be clear about exactly which hallway we're talking about when
     *   we're elsewhere, we might want to use a destName like "the
     *   basement hallway" or "the hallway outside the operating room".
     */
    destName = (theName) 

    /*
     *   For top-level rooms, describe an object as being in the room by
     *   describing it as being in the room's nominal drop destination,
     *   since that's the nominal location for the objects directly in the
     *   room.  (In most cases, the nominal drop destination for a room is
     *   its floor.)
     *
     *   If the player character isn't in the same outermost room as this
     *   container, use our remote name instead of the nominal drop
     *   destination.  The nominal drop destination is usually something
     *   like the floor or the ground, so it's only suitable when we're in
     *   the same location as what we're describing.
     */
    childInName(childName)
    {
        /* if the PC isn't inside us, we're viewing this remotely */
        if (!gPlayerChar.isIn(self))
            return childInRemoteName(childName, gPlayerChar);
        else
            return getNominalDropDestination().childInName(childName);
    }
    childInNameWithOwner(chiName)
    {
        /* if the PC isn't inside us, we're viewing this remotely */
        if (!gPlayerChar.isIn(self))
            return inherited(chiName);
        else
            return getNominalDropDestination().childInNameWithOwner(chiName);
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   Swedish-specific modifications for the default room parts.
 */

modify Floor
    childInNameGen(childName, myName) { return childName + ' på ' + myName; }
    objInPrep = 'på'
    actorInPrep = 'på'
    actorOutOfPrep = 'ut ur'
;

modify defaultFloor
    noun = 'golv' 'golvet' 'grund' 'grunden'
    name = 'golv'
    theName = 'golvet'
;

modify defaultGround
    noun = 'mark' 'marken' 'grund' 'grunden'
    name = 'mark'
    theName = 'marken'
;

modify DefaultWall noun='vägg' 'väggen' plural='väggar' name='vägg' theName = 'väggen';
modify defaultCeiling noun='tak' plural='taket' name='tak' theName = 'taket';
modify defaultNorthWall adjective='n' 'norr' 'nordlig' 'norra' noun = 'vägg' 'väggen' name='nordlig vägg' theName = 'norra väggen';
modify defaultSouthWall adjective='s' 'syd' 'sydlig' 'söder' 'södra' noun = 'vägg' 'väggen' name='sydlig vägg' theName = 'södra väggen';
modify defaultEastWall adjective='ö' 'öster' 'östlig' 'östra' noun = 'vägg' 'väggen' name='östlig vägg'  theName = 'östra väggen';
modify defaultWestWall adjective='v' 'väster' 'västlig' 'västra' noun = 'vägg' 'väggen' name='västlig vägg' theName = 'västra väggen';
modify defaultSky noun='himmel' 'himlen' name='himmel' theName = 'himlen';


/* ------------------------------------------------------------------------ */
/*
 *   The English-specific modifications for directions.
 */
modify Direction
    /* describe a traveler arriving from this direction */
    sayArriving(traveler)
    {
        /* show the generic arrival message */
        gLibMessages.sayArriving(traveler);
    }

    /* describe a traveler departing in this direction */
    sayDeparting(traveler)
    {
        /* show the generic departure message */
        gLibMessages.sayDeparting(traveler);
    }
;

/*
 *   The Swedish-specific modifications for compass directions.
 */

 modify CompassDirection
    /* describe a traveler arriving from this direction */
    sayArriving(traveler)
    {
        /* show the generic compass direction description */
        gLibMessages.sayArrivingDir(traveler, name);
    }

    /* describe a traveler departing in this direction */
    sayDeparting(traveler)
    {
        /* show the generic compass direction description */
        gLibMessages.sayDepartingDir(traveler, name + ending);
    }
;

/*
 *   The English-specific definitions for the compass direction objects.
 *   In addition to modifying the direction objects to define the name of
 *   the direction, we add a 'directionName' grammar rule.
 */
#define DefineLangDir(root, dirNames, backPre) \
grammar directionName(root): dirNames: DirectionProd \
   dir = root##Direction \
; \
\
modify root##Direction \
   name = #@root \
   backToPrefix = backPre


DefineLangDir(north, 'norr'  | 'n' | 'nord' | 'norrut', 'tillbaka från');
DefineLangDir(south, 'söder' | 's' | 'syd'  | 'söderut', 'tillbaka från');
DefineLangDir(east,  'öster' | 'ö' | 'öst'  | 'österut', 'tillbaka från');
DefineLangDir(west,  'väst'  | 'v' | 'väst' | 'västerut', 'tillbaka från');
DefineLangDir(northeast, 'nordöst'| 'nordost'|'nordösterut' | 'nö', 'tillbaka från');
DefineLangDir(northwest, 'nordväst'|'nordvästerut' | 'nv', 'tillbaka från');
DefineLangDir(southeast,  'sydöst'|'sydost'|'sydösterut'| 'sö', 'tillbaka från');
DefineLangDir(southwest,  'sydväst'|'sydvästerut'| 'sv', 'tillbaka från');
DefineLangDir(up, 'upp'|'uppåt'|'u', 'tillbaka');
DefineLangDir(down, 'ner'|'nedåt'|'n', 'tillbaka');
DefineLangDir(in,  'in', 'tillbaka');
DefineLangDir(out, 'ut', 'tillbaka');

modify Direction ending = 'ut';
modify northDirection       name = 'norr'; 
modify southDirection       name = 'söder'; 
modify eastDirection        name = 'öster'; 
modify westDirection        name = 'väster'; 
modify northwestDirection   name = 'nordväster'; 
modify northeastDirection   name = 'nordöster'; 
modify southwestDirection   name = 'sydväster'; 
modify southeastDirection   name = 'sydöster'; 
modify upDirection          name = 'upp' ending='åt'; 
modify downDirection        name = 'ner' ending='åt'; 
modify inDirection          name = 'in' ending='åt'; 
modify outDirection         name = 'ut' ending='åt'; 

/*
 *   The English-specific shipboard direction modifications.  Certain of
 *   the ship directions have no natural descriptions for arrival and/or
 *   departure; for example, there's no good way to say "arriving from
 *   fore."  Others don't fit any regular pattern: "he goes aft" rather
 *   than "he departs to aft."  As a result, these are a bit irregular
 *   compared to the compass directions and so are individually defined
 *   below.
 */

 // Den svenska översättningen är också lite av en kompromiss

DefineLangDir(port, 'babord' | 'b', 'tillbaka till')
    sayArriving(trav)
        { gLibMessages.sayArrivingShipDir(trav, 'babordssidan'); }
    sayDeparting(trav)
        { gLibMessages.sayDepartingShipDir(trav, 'längs babordssidan'); }
;

DefineLangDir(starboard, 'styrbord' | 'sb', 'tillbaka till')
    sayArriving(trav)
        { gLibMessages.sayArrivingShipDir(trav, 'styrbordssidan'); }
    sayDeparting(trav)
        { gLibMessages.sayDepartingShipDir(trav, 'längs styrbordssidan'); }
;

DefineLangDir(aft,  'akterut' | 'akt', 'tillbaka till')
    sayArriving(trav) { gLibMessages.sayArrivingShipDir(trav, 'aktern'); }
    sayDeparting(trav) { gLibMessages.sayDepartingAft(trav); }
;

DefineLangDir(fore, 'föröver' 'för' | 'fören' | 'f', 'tillbaka till')
    sayArriving(trav) { gLibMessages.sayArrivingShipDir(trav, 'fören'); }
    sayDeparting(trav) { gLibMessages.sayDepartingFore(trav); }
;

modify foreDirection name = 'föröver'; 
modify aftDirection name = 'akteröver'; 
modify starboardDirection name = 'styrbordssida'; 
modify portDirection name = 'babordssida'; 

/* ------------------------------------------------------------------------ */
/*
 *   Some helper routines for the library messages.
 */
class MessageHelper: object
    /*
     *   Show a list of objects for a disambiguation query.  If
     *   'showIndefCounts' is true, we'll show the number of equivalent
     *   items for each equivalent item; otherwise, we'll just show an
     *   indefinite noun phrase for each equivalent item.
     */
    askDisambigList(matchList, fullMatchList, showIndefCounts, dist)
    {
        /* show each item */
        for (local i = 1, local len = matchList.length() ; i <= len ; ++i)
        {
            local equivCnt;
            local obj;

            /* get the current object */
            obj = matchList[i].obj_;

            /*
             *   if this isn't the first, add a comma; if this is the
             *   last, add an "or" as well
              */
            if (i == len)
                ", eller ";
            else if (i != 1)
                ", ";

            /*
             *   Check to see if more than one equivalent of this item
             *   appears in the full list.
             */
            for (equivCnt = 0, local j = 1,
                 local fullLen = fullMatchList.length() ; j <= fullLen ; ++j)
            {
                /*
                 *   if this item is equivalent for the purposes of the
                 *   current distinguisher, count it
                 */
                if (!dist.canDistinguish(obj, fullMatchList[j].obj_))
                {
                    /* it's equivalent - count it */
                    ++equivCnt;
                }
            }

            /* show this item with the appropriate article */
            if (equivCnt > 1)
            {
                /*
                 *   we have multiple equivalents - show either with an
                 *   indefinite article or with a count, depending on the
                 *   flags the caller provided
                 */
                if (showIndefCounts)
                {
                    /* a count is desired for each equivalent group */
                    say(dist.countName(obj, equivCnt));
                }
                else
                {
                    /* no counts desired - show with an indefinite article */
                    say(dist.aName(obj));
                }
            }
            else
            {
                /* there's only one - show with a definite article */
                say(dist.theName(obj));
            }
        }
    }

    /*
     *   For a TAction result, select the short-form or long-form message,
     *   according to the disambiguation status of the action.  This is for
     *   the ultra-terse default messages, such as "Taken" or "Dropped",
     *   that sometimes need more descriptive variations.
     *   
     *   If there was no disambiguation involved, we'll use the short
     *   version of the message.
     *   
     *   If there was unclear disambiguation involved (meaning that there
     *   was more than one logical object matching a noun phrase, but the
     *   parser was able to decide based on likelihood rankings), we'll
     *   still use the short version, because we assume that the parser
     *   will have generated a parenthetical announcement to point out its
     *   choice.
     *   
     *   If there was clear disambiguation involved (meaning that more than
     *   one in-scope object matched a noun phrase, but there was only one
     *   choice that passed the logicalness tests), AND the announcement
     *   mode (in gameMain.ambigAnnounceMode) is DescribeClear, we'll
     *   choose the long-form message.  
     */
    shortTMsg(short, long)
    {
        /* check the disambiguation flags and the announcement mode */
        if ((gAction.getDobjFlags() & (ClearDisambig | AlwaysAnnounce))
            == ClearDisambig
            && gAction.getDobjCount() == 1
            && gameMain.ambigAnnounceMode == DescribeClear)
        {
            /* clear disambig and DescribeClear mode - use the long message */
            return long;
        }
        else
        {
            /* in other cases, use the short message */
            return short;
        }
    }

    /*
     *   For a TIAction result, select the short-form or long-form message.
     *   This works just like shortTIMsg(), but takes into account both the
     *   direct and indirect objects. 
     */
    shortTIMsg(short, long)
    {
        /* check the disambiguation flags and the announcement mode */
        if (((gAction.getDobjFlags() & (ClearDisambig | AlwaysAnnounce))
             == ClearDisambig
             || (gAction.getIobjFlags() & (ClearDisambig | AlwaysAnnounce))
             == ClearDisambig)
            && gAction.getDobjCount() == 1
            && gAction.getIobjCount() == 1
            && gameMain.ambigAnnounceMode == DescribeClear)
        {
            /* clear disambig and DescribeClear mode - use the long message */
            return long;
        }
        else
        {
            /* in other cases, use the short message */
            return short;
        }
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   Custom base resolver
 */
modify Resolver
    /*
     *   Get the default in-scope object list for a given pronoun.  We'll
     *   look for a unique object in scope that matches the desired
     *   pronoun, and return a ResolveInfo list if we find one.  If there
     *   aren't any objects in scope that match the pronoun, or multiple
     *   objects are in scope, there's no default.
     */
    getPronounDefault(typ, np)
    {
        local map = [PronounHim, &canMatchHim,
                     PronounHer, &canMatchHer,
                     PronounIt, &canMatchIt];
        local idx = map.indexOf(typ);
        local filterProp = (idx != nil ? map[idx + 1] : nil);
        local lst;

        /* if we couldn't find a filter for the pronoun, ignore it */
        if (filterProp == nil)
            return [];

        /*
         *   filter the list of all possible defaults to those that match
         *   the given pronoun
         */
        lst = getAllDefaults.subset({x: x.obj_.(filterProp)});

        /*
         *   if the list contains exactly one element, then there's a
         *   unique default; otherwise, there's either nothing here that
         *   matches the pronoun or the pronoun is ambiguous, so there's
         *   no default
         */
        if (lst.length() == 1)
        {
            /*
             *   we have a unique object, so they must be referring to it;
             *   because this is just a guess, though, mark it as vague
             */
            lst[1].flags_ |= UnclearDisambig;

            /* return the list */
            return lst;
        }
        else
        {
            /*
             *   the pronoun doesn't have a unique in-scope referent, so
             *   we can't guess what they mean
             */
            return [];
        }
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   Custom interactive resolver.  This is used for responses to
 *   disambiguation questions and prompts for missing noun phrases.
 */
modify InteractiveResolver
    /*
     *   Resolve a pronoun antecedent.  We'll resolve a third-person
     *   singular pronoun to the target actor if the target actor matches
     *   in gender, and the target actor isn't the PC.  This allows
     *   exchanges like this:
     *
     *.  >bob, examine
     *.  What do you want Bob to look at?
     *.
     *.  >his book
     *
     *   In the above exchange, we'll treat "his" as referring to Bob, the
     *   target actor of the action, because we have referred to Bob in
     *   the partial command (the "BOB, EXAMINE") that triggered the
     *   interactive question.
     */
    resolvePronounAntecedent(typ, np, results, poss)
    {
        local lst;

        /* try resolving with the target actor as the antecedent */
        if ((lst = resolvePronounAsTargetActor(typ)) != nil)
            return lst;

        /* use the inherited result */
        return inherited(typ, np, results, poss);
    }

    /*
     *   Get the reflexive third-person pronoun binding (himself, herself,
     *   itself, themselves).  If the target actor isn't the PC, and the
     *   gender of the pronoun matches, we'll consider this as referring
     *   to the target actor.  This allows exchanges of this form:
     *
     *.  >bob, examine
     *.  What do you want Bob to examine?
     *.
     *.  >himself
     */
    getReflexiveBinding(typ)
    {
        local lst;

        /* try resolving with the target actor as the antecedent */
        if ((lst = resolvePronounAsTargetActor(typ)) != nil)
            return lst;

        /* use the inherited result */
        return inherited(typ);
    }

    /*
     *   Try matching the given pronoun type to the target actor.  If it
     *   matches in gender, and the target actor isn't the PC, we'll
     *   return a resolve list consisting of the target actor.  If we
     *   don't have a match, we'll return nil.
     */
    resolvePronounAsTargetActor(typ)
    {
        /*
         *   if the target actor isn't the player character, and the
         *   target actor can match the given pronoun type, resolve the
         *   pronoun as the target actor
         */
        if (actor_.canMatchPronounType(typ) && !actor_.isPlayerChar())
        {
            /* the match is the target actor */
            return [new ResolveInfo(actor_, 0, nil)];
        }

        /* we didn't match it */
        return nil;
    }
;

/*
 *   Custom disambiguation resolver.
 */
modify DisambigResolver
    /*
     *   Perform special resolution on pronouns used in interactive
     *   responses.  If the pronoun is HIM or HER, then look through the
     *   list of possible matches for a matching gendered object, and use
     *   it as the result if we find one.  If we find more than one, then
     *   use the default handling instead, treating the pronoun as
     *   referring back to the simple antecedent previously set.
     */
    resolvePronounAntecedent(typ, np, results, poss)
    {
        /* if it's a non-possessive HIM or HER, use our special handling */
        if (!poss && typ is in (PronounHim, PronounHer))
        {
            local prop;
            local sub;

            /* get the gender indicator property for the pronoun */
            prop = (typ == PronounHim ? &canMatchHim : &canMatchHer);

            /*
             *   Scan through the match list to find the objects that
             *   match the gender of the pronoun.  Note that if the player
             *   character isn't referred to in the third person, we'll
             *   ignore the player character for the purposes of matching
             *   this pronoun - if we're calling the PC 'you', then we
             *   wouldn't expect the player to refer to the PC as 'him' or
             *   'her'.
             */
            sub = matchList.subset({x: x.obj_.(prop)});

            /* if the list has a single entry, then use it as the match */
            if (sub.length() == 1)
                return sub;

            /*
             *   if it has more than one entry, it's still ambiguous, but
             *   we might have narrowed it down, so throw a
             *   still-ambiguous exception and let the interactive
             *   disambiguation ask for further clarification
             */
            results.ambiguousNounPhrase(nil, ResolveAsker, 'av',
                                        sub, matchList, matchList,
                                        1, self);
            return [];
        }

        /*
         *   if we get this far, it means we didn't use our special
         *   handling, so use the inherited behavior
         */
        return inherited(typ, np, results, poss);
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   Distinguisher customizations for English.
 *   
 *   Each distinguisher must provide a method that gets the name of an item
 *   for a disamgiguation query.  Since these are inherently
 *   language-specific, they're defined here.  
 */

/*
 *   The null distinguisher tells objects apart based strictly on the name
 *   string.  When we list objects, we simply show the basic name - since
 *   we can tell apart our objects based on the base name, there's no need
 *   to resort to other names.  
 */
modify nullDistinguisher
    /* we can tell objects apart if they have different base names */
    canDistinguish(a, b) { return a.name != b.name; }

    name(obj) { return obj.name; }
    aName(obj) { return obj.aName; }
    theName(obj) { return obj.theName; }
    countName(obj, cnt) { return obj.countName(cnt); }
;


/*
 *   The basic distinguisher can tell apart objects that are not "basic
 *   equivalents" of one another.  Thus, we need make no distinctions when
 *   listing objects apart from showing their names.  
 */
modify basicDistinguisher
    name(obj) { return obj.disambigName; }
    aName(obj) { return obj.aDisambigName; }
    theName(obj) { return obj.theDisambigName; }
    countName(obj, cnt) { return obj.countDisambigName(cnt); }
;

/*
 *   The ownership distinguisher tells objects apart based on who "owns"
 *   them, so it shows the owner or location name when listing the object. 
 */
modify ownershipDistinguisher
    name(obj) { return obj.theNameOwnerLoc(true); }
    aName(obj) { return obj.aNameOwnerLoc(true); }
    theName(obj) { return obj.theNameOwnerLoc(true); }
    countName(obj, cnt) { return obj.countNameOwnerLoc(cnt, true); }

    /* note that we're prompting based on this distinguisher */
    notePrompt(lst)
    {
        /*
         *   notify each object that we're referring to it by
         *   owner/location in a disambiguation prompt
         */
        foreach (local cur in lst)
            cur.obj_.notePromptByOwnerLoc(true);
    }
;

/*
 *   The location distinguisher tells objects apart based on their
 *   containers, so it shows the location name when listing the object. 
 */
modify locationDistinguisher
    name(obj) { return obj.theNameOwnerLoc(nil); }
    aName(obj) { return obj.aNameOwnerLoc(nil); }
    theName(obj) { return obj.theNameOwnerLoc(nil); }
    countName(obj, cnt) { return obj.countNameOwnerLoc(cnt, nil); }

    /* note that we're prompting based on this distinguisher */
    notePrompt(lst)
    {
        /* notify the objects of their use in a disambiguation prompt */
        foreach (local cur in lst)
            cur.obj_.notePromptByOwnerLoc(nil);
    }
;

/*
 *   The lit/unlit distinguisher tells apart objects based on whether
 *   they're lit or unlit, so we list objects as lit or unlit explicitly.  
 */
modify litUnlitDistinguisher
    name(obj) { return obj.nameLit; }
    aName(obj) { return obj.aNameLit; }
    theName(obj) { return obj.theNameLit; }
    countName(obj, cnt) { return obj.pluralNameLit; }
;

/* ------------------------------------------------------------------------ */
/*
 *   Enligh-specific light source modifications
 */
modify LightSource
    /* provide lit/unlit names for litUnlitDistinguisher */
    nameLit = '<<isLit?'':'o'>>tän<<endingForNounDTDa>> <<name>>'
    aNameLit()
    {
        local form = '<<isLit?'':'o'>>tän<<endingForNounDTDa>>';
        if (isMassNoun || isPlural) {
            // Vid antingen:
            // Massnoun: tänt virke, tänd bensin (lite virke/bensin)
            // Plural: tända lyktor (t ex några lyktor)
            // så skippar vi artikeln
            return '<<form>> <<name>>'; 
        }
        
        local article = isNeuter ? 'ett' : 'en';
        return '<<article>> <<form>> <<name>>';
    }

    theNameLit = (isPlural && !isMassNoun? 'de ' : isNeuter ? 'det ' : 'den ') + ((isLit?'':'o')+'tända ' + definiteForm)
    pluralNameLit = (isLit?'':'o')+'tän' + (isMassNoun? (isNeuter? 't':'d'):'da') + ' ' + pluralName

    /*
     *   Allow 'lit' and 'unlit' as adjectives - but even though we define
     *   these as our adjectives in the dictionary, we'll only accept the
     *   one appropriate for our current state, thanks to our state
     *   objects.
     */
    adjective = 'tända' 'otända' 'tänd' 'otänd' 'tänt' 'otänt' 

;

/*
 *   Light source list states.  An illuminated light source shows its
 *   status as "providing light"; an unlit light source shows no extra
 *   status.
 */
lightSourceStateOn: ThingState 'avger ljus'
   stateTokens = (isPlural && !isMassNoun)? ['tända'] : isNeuter? ['tänt'] : ['tänd'] 
;

lightSourceStateOff: ThingState
    stateTokens = (isPlural && !isMassNoun)? ['otända'] : isNeuter? ['otänt'] : ['otänd'] 
;

/* ------------------------------------------------------------------------ */
/*
 *   Wearable states - a wearable item can be either worn or not worn.
 */

/* "worn" */
wornState: ThingState 'påklädd'
    /*
     *   In listings of worn items, don't bother mentioning our 'worn'
     *   status, as the entire list consists of items being worn - it
     *   would be redundant to point out that the items in a list of items
     *   being worn are being worn.
     */
    wornName(lst) { return nil; }
;

/*
 *   "Unworn" state.  Don't bother mentioning the status of an unworn item,
 *   since this is the default for everything.  
 */
unwornState: ThingState;


/* ------------------------------------------------------------------------ */
/*
 *   Typographical effects output filter.  This filter looks for certain
 *   sequences in the text and converts them to typographical equivalents.
 *   Authors could simply write the HTML for the typographical markups in
 *   the first place, but it's easier to write the typewriter-like
 *   sequences and let this filter convert to HTML.
 *
 *   We perform the following conversions:
 *
 *   '---' -> &zwnbsp;&mdash;
 *.  '--' -> &zwnbsp;&ndash;
 *.  sentence-ending punctuation -> same + &ensp;
 *
 *   Since this routine is called so frequently, we hard-code the
 *   replacement strings, rather than using properties, for slightly faster
 *   performance.  Since this routine is so simple, games that want to
 *   customize the replacement style should simply replace this entire
 *   routine with a new routine that applies the customizations.
 *
 *   Note that we define this filter in the English-specific part of the
 *   library, because it seems almost certain that each language will want
 *   to customize it for local conventions.
 */
typographicalOutputFilter: OutputFilter
    filterText(ostr, val)
    {
        /*
         *   Look for sentence-ending punctuation, and put an 'en' space
         *   after each occurrence.  Recognize ends of sentences even if we
         *   have closing quotes, parentheses, or other grouping characters
         *   following the punctuation.  Do this before the hyphen
         *   substitutions so that we can look for ordinary hyphens rather
         *   than all of the expanded versions.
         */
        val = rexReplace(eosPattern, val, '%1\u2002', ReplaceAll);

        /* undo any abbreviations we mistook for sentence endings */
        val = rexReplace(abbrevPat, val, '%1. ', ReplaceAll);

        /*
         *   Replace dashes with typographical hyphens.  Three hyphens in a
         *   row become an em-dash, and two in a row become an en-dash.
         *   Note that we look for the three-hyphen sequence first, because
         *   if we did it the other way around, we'd incorrectly find the
         *   first two hyphens of each '---' sequence and replace them with
         *   an en-dash, causing us to miss the '---' sequences entirely.
         *   
         *   We put a no-break marker (\uFEFF) just before each hyphen, and
         *   an okay-to-break marker (\u200B) just after, to ensure that we
         *   won't have a line break between the preceding text and the
         *   hyphen, and to indicate that a line break is specifically
         *   allowed if needed to the right of the hyphen.  
         */
        val = val.findReplace(['---', '--'],
                              ['\uFEFF&mdash;\u200B', '\uFEFF&ndash;\u200B']);

        /* return the result */
        return val;
    }

    /*
     *   The end-of-sentence pattern.  This looks a bit complicated, but
     *   all we're looking for is a period, exclamation point, or question
     *   mark, optionally followed by any number of closing group marks
     *   (right parentheses or square brackets, closing HTML tags, or
     *   double or single quotes in either straight or curly styles), all
     *   followed by an ordinary space.
     *
     *   If a lower-case letter follows the space, though, we won't
     *   consider it a sentence ending.  This applies most commonly after
     *   quoted passages ending med vad would normally be sentence-ending
     *   punctuation: "'Who are you?' he asked."  In these cases, the
     *   enclosing sentence isn't ending, so we don't want the extra space.
     *   We can tell the enclosing sentence isn't ending because a
     *   non-capital letter follows.
     *
     *   Note that we specifically look only for ordinary spaces.  Any
     *   sentence-ending punctuation that's followed by a quoted space or
     *   any typographical space overrides this substitution.
     */
    eosPattern = static new RexPattern(
        '<case>'
        + '('
        +   '[.!?]'
        +   '('
        +     '<rparen|rsquare|dquote|squote|\u2019|\u201D>'
        +     '|<langle><^rangle>*<rangle>'
        +   ')*'
        + ')'
        + ' +(?![-a-z])'
        )

    /* pattern for abbreviations that were mistaken for sentence endings */
    abbrevPat = static new RexPattern(
        '<nocase>%<(' + abbreviations + ')<dot>\u2002')

    /* 
     *   Common abbreviations.  These are excluded from being treated as
     *   sentence endings when they appear with a trailing period.
     *   
     *   Note that abbrevPat must be rebuilt manually if you change this on
     *   the fly - abbrevPat is static, so it picks up the initial value of
     *   this property at start-up, and doesn't re-evaluate it while the
     *   game is running.  
     */
    abbreviations = 'hr|fr|frk|dr|prof'
;

/* ------------------------------------------------------------------------ */
/*
 *   The English-specific message builder.
 */
langMessageBuilder: MessageBuilder

    /*
     *   The English message substitution parameter table.
     *
     *   Note that we specify two additional elements for each table entry
     *   beyond the standard language-independent complement:
     *
     *   info[4] = reflexive property - this is the property to invoke
     *   when the parameter is used reflexively (in other words, its
     *   target object is the same as the most recent target object used
     *   in the nominative case).  If this is nil, the parameter has no
     *   reflexive form.
     *
     *   info[5] = true if this is a nominative usage, nil if not.  We use
     *   this to determine which target objects are used in the nominative
     *   case, so that we can remember those objects for subsequent
     *   reflexive usages.
     */
    paramList_ =
    [
        ///////////////////////////////////////////////////////////
        // REFERENT - Du, Jag, Bob, Alice
        ///////////////////////////////////////////////////////////
        // Parametrar som implicerar nuvarande utförare av handling

        // - Första implicita formerna för 1a, 2a och 3:e person:  "jag", "du" & "ref"
        // Exempelvis:
        // "{Jag} drack kaffe" -> "Jag drack kaffe" (om "jag: Actor 'jag' 'jag' pcReferralPerson = FirstPerson")
        // "{Du} drack kaffe" -> "Du drack kaffe" (om "du: Actor 'du' 'du' pcReferralPerson = SecondPerson")
        // "{Ref} drack kaffe" -> "bob drack kaffe" (om "bob: Actor 'bob' 'Bob' pcReferralPerson = ThirdPerson")
        ['jag',       &theName, 'actor', nil, true],
        ['du',        &theName, 'actor', nil, true],
        ['ref',       &theName, 'actor', nil, true],
        ['du/han',    &theName, 'actor', nil, true],
        ['du/hon',    &theName, 'actor', nil, true],

        // Man kan se ref/han så som the/he eller the/him används i engelska versionen
        ['ref/han', &theName,  nil, nil, true],
        ['ref/hon', &theName,  nil, nil, true],
        ['ref/den', &theName,  nil, nil, true],
        ['ref/det', &theName,  nil, nil, true],
        ['ref/de',  &theName,  nil, nil, true],


        ///////////////////////////////////////////////////////////
        // NOMINATIV / SUBJEKTFORM
        ///////////////////////////////////////////////////////////
        // Subjektform: jag, du, han, hon, den, det + vi, ni, de

        // Först implicita formerna för utföraren av handlingen
        // "{Han} hoppade" -> "Han hoppade" (om t ex: Actor isHim=true)
        ['han',   &itNom,   'actor', nil, true],
        ['hon',   &itNom,   'actor', nil, true],
        ['den',   &itNom,   'actor', nil, true],
        ['det',   &itNom,   'actor', nil, true],
        ['vi',    &itNom,   'actor', nil, true],
        ['ni',    &itNom,   'actor', nil, true],
        ['de',    &itNom,   'actor', nil, true],

        // Explicit subjektform med '/subj'
        // "{Vi/subj} cyklade" -> "Vi cyklade" (om t ex: Actor isPlural=true)
        ['han/subj',   &itNom,    nil,    nil, true],
        ['hon/subj',   &itNom,    nil,    nil, true],
        ['den/subj',   &itNom,    nil,    nil, true],
        ['det/subj',   &itNom,    nil,    nil, true],
        ['vi/subj',    &itNom,    nil,    nil, true],
        ['ni/subj',    &itNom,    nil,    nil, true],
        ['de/subj',    &itNom,    nil,    nil, true],

        // TODO: ska dessa former få leva kvar eller tas bort?
        ['det/han',   &itNom,    nil,    nil, true],
        ['det/hon',   &itNom,    nil,    nil, true],
        ['den/han',   &itNom,    nil,    nil, true],
        ['den/hon',   &itNom,    nil,    nil, true],


        ///////////////////////////////////////////////////////////
        // OBJEKTFORM
        ///////////////////////////////////////////////////////////
        // mig, dig, den, det, honom, henne,  oss, er, dem

        // OBS: Undantag från objektform objektet är beskrivet i tredjepersonsperspektiv (theNameObj).
        // I första hand är det referenten, "ref", som ska användas, men om perspektivet 
        /// för objektet är annat så blir det objektform:
        ['ref/honom', &theNameObj, 'actor', &itReflexive, nil],
        ['ref/henne', &theNameObj, 'actor', &itReflexive, nil],
        ['ref/mig',   &theNameObj, 'actor', &itReflexive, nil],
        ['ref/dig',   &theNameObj, 'actor', &itReflexive, nil],

        // Nedan följer sedvanlig objektform, först implicit för 'actor' 
        // mig, dig, den, det, honom, henne,  oss, er, dem
        ['honom',     &itObj,   'actor', nil, nil],
        ['henne',     &itObj,   'actor', nil, nil],
        ['dem',       &itObj,   'actor', nil, nil],
        ['oss',       &itObj,   'actor', nil, nil],
        ['er',        &itObj,   'actor', nil, nil],

        // Objektform med explicit '/obj'-suffix
        // Exempelvis: "Det gick inte att lyfta {dem/obj sakerna}."
        ['den/obj', &itObj, nil, &itReflexive, nil],
        ['det/obj', &itObj, nil, &itReflexive, nil],
        ['dem/obj', &itObj, nil, &itReflexive, nil],

        // Mig, dig, sig, er och oss
        ['mig', &itReflexiveSimple, 'actor', nil, nil],
        ['dig', &itReflexiveSimple, 'actor', nil, nil],
        ['sig', &itReflexiveSimple, 'actor', nil, nil],

        // Några extra-former som känns förväntade att kunna skriva och som inte krockar med något annat
        ['det/honom', &itObj, nil, &itReflexive, nil],
        ['det/henne', &itObj, nil, &itReflexive, nil],
        ['den/honom', &itObj, nil, &itReflexive, nil],
        ['den/henne', &itObj, nil, &itReflexive, nil],

        ///////////////////////////////////////////////////////////
        // REFLEXIVA FORMER
        ///////////////////////////////////////////////////////////

        // Används för possessiva med namn i tredjepersonsperspektiv 
        // eller reflexiva possesiva (mitt/ditt/mina, etc...)
        ['ref/din',     &theNamePossAdj, 'actor', nil, nil],

        // Vanliga possessiva reflexiva fökjer
        ['din/erat',    &itPossNoun, 'actor', nil, nil],
        ['din/eran',    &itPossNoun, 'actor', nil, nil],
        
        ['din/hennes',  &itPossNoun, 'actor', nil, nil],
        ['din/hans',    &itPossNoun, 'actor', nil, nil],

        ['dess/hennes', &itPossNoun, 'actor', nil, nil],
        ['vår/hennes',  &itPossNoun, 'actor', nil, nil],    

        ['min',     &itPossAdj, 'actor', nil, nil],
        ['mitt',    &itPossAdj, 'actor', nil, nil],
        ['din',     &itPossAdj, 'actor', nil, nil],
        ['ditt',    &itPossAdj, 'actor', nil, nil],
        ['sin',     &itPossAdj, 'actor', nil, nil],
        ['sitt',     &itPossAdj, 'actor', nil, nil],
        ['deras',   &itPossAdj, 'actor', nil, nil],
        ['dess',    &itPossAdj, 'actor', nil, nil],
        ['vår',     &itPossAdj, 'actor', nil, nil],
        ['vårt',     &itPossAdj, 'actor', nil, nil],

        ['mina', &theNamePossAdjPlural, 'actor', nil, nil],
        ['dina', &theNamePossAdjPlural, 'actor', nil, nil],
        ['våra', &theNamePossAdjPlural, 'actor', nil, nil],

        ['själv', &itReflexive, 'actor', nil, nil],
        ['själva', &itReflexive, 'actor', nil, nil],
        ['mig_själv', &itReflexive, 'actor', nil, nil],
        ['dig_själv', &itReflexive, 'actor', nil, nil],
        ['sig_själv', &itReflexive, 'actor', nil, nil],
        ['oss_själva', &itReflexive, 'actor', nil, nil],
        ['er_själva', &itReflexive, 'actor', nil, nil],

        // parametrar som inte antar något målobjekt
        ['en/han', &aName, nil, nil, true],
        ['en/hon', &aName, nil, nil, true],
        ['ett/han', &aName, nil, nil, true],
        ['ett/hon', &aName, nil, nil, true],

        ['en/honom', &aNameObj, nil, &itReflexive, nil],
        ['en/henne', &aNameObj, nil, &itReflexive, nil],        
        ['ett/honom', &aNameObj, nil, &itReflexive, nil],
        ['ett/henne', &aNameObj, nil, &itReflexive, nil],    

        // Övrigt
        ['är', &verbToBe, nil, nil, true],
        ['var', &verbToBe, nil, nil, true],
        ['hade', &verbToHave, nil, nil, true],
        ['har', &verbToHave, nil, nil, true],
        ['kan', &verbCan, nil, nil, true],
        ['här', &verbHere, nil, nil, true],
        ['där', &verbHere, nil, nil, true],
        ['tar', &verbToTake, nil, nil, true],
        ['tog', &verbToTake, nil, nil, true],
        ['ser', &verbToSee, nil, nil, true],
        ['såg', &verbToSee, nil, nil, true],
        ['hör', &verbToHear, nil, nil, true],
        ['gör', &verbToDo, nil, nil, true],
        ['går', &verbToGo, nil, nil, true],
        ['kommer', &verbToCome, nil, nil, true],
        ['lämnar', &verbToLeave, nil, nil, true],
        ['säg', &verbToSay, nil, nil, true],
        ['måste', &verbMust, nil, nil, true],
        ['kommer', &verbWill, nil, nil, true],
        ['verkar', &verbToSeem, nil, nil, true],
        ['sätter', &verbToPut, nil, nil, true],

        // Prepositioner
        ['på', &actorInName, nil, nil, nil],
        ['i', &actorInName, nil, nil, nil],
        ['av_ur', &actorOutOfName, nil, nil, nil],

        /*
         *  Verbändelser
         */
        ['er/te', &verbEndingEr, nil, nil, true],  // t ex: trycker/tryckte
        ['er/e', &verbEndingErE, nil, nil, true],  // t ex: tänder/tände
        ['a/t', &endingForNounTA, nil, nil, nil],
        ['a', &endingForNounA, nil, nil, nil],
        ['d/t/da', &endingForNounDTDa, nil, nil, nil],
        ['ad/at/na', &endingForNounAdAtNa, nil, nil, nil],
        ['en/et/na', &endingForNounEnEtNa, nil, nil, nil],



        /*
         *   The special invisible subject marker - this can be used to
         *   mark the subject in sentences that vary from the
         *   subject-verb-object structure that most English sentences
         *   take.  The usual SVO structure allows the message builder to
         *   see the subject first in most sentences naturally, but in
         *   unusual sentence forms it is sometimes useful to be able to
         *   mark the subject explicitly.  This doesn't actually result in
         *   any output; it's purely for marking the subject for our
         *   internal book-keeping.
         *
         *   (The main reason the message builder wants to know the subject
         *   in the first place is so that it can use a reflexive pronoun
         *   if the same object ends up being used as a direct or indirect
         *   object: "you can't open yourself" rather than "you can't open
         *   you.")
         */
        ['subj', &dummyName, nil, nil, true]
    ]

    /*
     *   Add a hook to the generateMessage method, which we use to
     *   pre-process the source string before expanding the substitution
     *   parameters.
     */
    generateMessage(orig) { return inherited(processOrig(orig)); }

    /*
     *   Pre-process a source string containing substitution parameters,
     *   before generating the expanded message from it.
     *
     *   We use this hook to implement the special tense-switching syntax
     *   {<present>|<past>}.  Although it superficially looks like an
     *   ordinary substitution parameter, we actually can't use the normal
     *   parameter substitution framework for that, because we want to
     *   allow the <present> and <past> substrings themselves to contain
     *   substitution parameters, and the normal framework doesn't allow
     *   for recursive substitution.
     *
     *   We simply replace every sequence of the form {<present>|<past>}
     *   with either <present> or <past>, depending on the current
     *   narrative tense.  We then substitute braces for square brackets in
     *   the resulting string.  This allows treating every bracketed tag
     *   inside the tense-switching sequence as a regular substitution
     *   parameter.
     *
     *   For example, the sequence "{take[s]|took}" appearing in the
     *   message string would be replaced with "take{s}" if the current
     *   narrative tense is present, and would be replaced with "took" if
     *   the current narrative tense is past.  The string "take{s}", if
     *   selected, would in turn be expanded to either "take" or "takes",
     *   depending on the grammatical person of the subject, as per the
     *   regular substitution mechanism.
     */
    processOrig(str)
    {
        local idx = 1;
        local len;
        local match;
        local replStr;

        /*
         *   Keep searching the string until we run out of character
         *   sequences with a special meaning (specifically, we look for
         *   substrings enclosed in braces, and stuttered opening braces).
         */
        for (;;)
        {
            /*
             *   Find the next special sequence.
             */
            match = rexSearch(patSpecial, str, idx);

            /*
             *   If there are no more special sequence, we're done
             *   pre-processing the string.
             */
            if (match == nil) break;

            /*
             *   Remember the starting index and length of the special
             *   sequence.
             */
            idx = match[1];
            len = match[2];

            /*
             *   Check if this special sequence matches our tense-switching
             *   syntax.
             */
            if (rexMatch(patTenseSwitching, str, idx) == nil)
            {
                /*
                 *   It doesn't, so forget about it and continue searching
                 *   from the end of this special sequence.
                 */
                idx += len;
                continue;
            }

            /*
             *   Extract either the first or the second embedded string,
             *   depending on the current narrative tense.
             */
            match = rexGroup(tSel(1, 2));
            replStr = match[3];

            /*
             *   Convert all square brackets to braces in the extracted
             *   string.
             */
            replStr = replStr.findReplace('[', '{', ReplaceAll);
            replStr = replStr.findReplace(']', '}', ReplaceAll);

            /*
             *   In the original string, replace the tense-switching
             *   sequence with the extracted string.
             */
            str = str.substr(1, idx - 1) + replStr + str.substr(idx + len);

            /*
             *   Move the index at the end of the substituted string.
             */
            idx += match[2];
        }

        /*
         *   We're done - return the result.
         */
        return str;
    }

    /*
     *   Pre-compiled regular expression pattern matching any sequence with
     *   a special meaning in a message string.
     *
     *   We match either a stuttered opening brace, or a single opening
     *   brace followed by any sequence of characters that doesn't contain
     *   a closing brace followed by a closing brace.
     */
    patSpecial = static new RexPattern
        ('<lbrace><lbrace>|<lbrace>(?!<lbrace>)((?:<^rbrace>)*)<rbrace>')

    /*
     *   Pre-compiled regular expression pattern matching our special
     *   tense-switching syntax.
     *
     *   We match a single opening brace, followed by any sequence of
     *   characters that doesn't contain a closing brace or a vertical bar,
     *   followed by a vertical bar, followed by any sequence of characters
     *   that doesn't contain a closing brace or a vertical bar, followed
     *   by a closing brace.
     */
    patTenseSwitching = static new RexPattern
    (
        '<lbrace>(?!<lbrace>)((?:<^rbrace|vbar>)*)<vbar>'
                          + '((?:<^rbrace|vbar>)*)<rbrace>'
    )

    /*
     *   The most recent target object used in the nominative case.  We
     *   note this so that we can supply reflexive mappings when the same
     *   object is re-used in the objective case.  This allows us to map
     *   things like "you can't take you" to the better-sounding "you
     *   can't take yourself".
     */
    lastSubject_ = nil

    /* the parameter name of the last subject ('dobj', 'actor', etc) */
    lastSubjectName_ = nil

    /*
     *   Get the target object property mapping.  If the target object is
     *   the same as the most recent subject object (i.e., the last object
     *   used in the nominative case), and this parameter has a reflexive
     *   form property, we'll return the reflexive form property.
     *   Otherwise, we'll return the standard property mapping.
     *
     *   Also, if there was an exclamation mark at the end of any word in
     *   the tag, we'll return a property returning a fixed-tense form of
     *   the property for the tag.
     */
    getTargetProp(targetObj, paramObj, info)
    {
        local ret;

        /*
         *   If this target object matches the last subject, and we have a
         *   reflexive rendering, return the property for the reflexive
         *   rendering.
         *
         *   Only use the reflexive rendering if the parameter name is
         *   different - if the parameter name is the same, then presumably
         *   the message will have been written with a reflexive pronoun or
         *   not, exactly as the author wants it.  When the author knows
         *   going in that these two objects are structurally the same,
         *   they want the exact usage they wrote.
         */
        if (targetObj == lastSubject_
            && paramObj != lastSubjectName_
            && info[4] != nil)
        {
            /* use the reflexive rendering */
            ret = info[4];
        }
        else
        {
            /* no special handling; inherit the default handling */
            ret = inherited(targetObj, paramObj, info);
        }

        /* if this is a nominative usage, note it as the last subject */
        if (info[5])
        {
            lastSubject_ = targetObj;
            lastSubjectName_ = paramObj;
        }

        /*
         *   If there was an exclamation mark at the end of any word in the
         *   parameter string (which we remember via the fixedTenseProp_
         *   property), store the original target property in
         *   fixedTenseProp_ and use &propWithPresentMessageBuilder_ as the
         *   target property instead.  propWithPresentMessageBuilder_ acts
         *   as a wrapper for the original target property, which it
         *   invokes after temporarily switching to the present tense.
         */
        if (fixedTenseProp_)
        {
            fixedTenseProp_ = ret;
            ret = &propWithPresentMessageBuilder_;
        }

        /* return the result */
        return ret;
    }

    /* end-of-sentence match pattern */
    patEndOfSentence = static new RexPattern('[.;:!?]<^alphanum>')

    /*
     *   Process result text.
     */
    processResult(txt)
    {
        /*
         *   If the text contains any sentence-ending punctuation, reset
         *   our internal memory of the subject of the sentence.  We
         *   consider the sentence to end with a period, semicolon, colon,
         *   question mark, or exclamation point followed by anything
         *   other than an alpha-numeric.  (We require the secondary
         *   character so that we don't confuse things like "3:00" or
         *   "7.5" to contain sentence-ending punctuation.)
         */
        if (rexSearch(patEndOfSentence, txt) != nil)
        {
            /*
             *   we have a sentence ending in this run of text, so any
             *   saved subject object will no longer apply after this text
             *   - forget our subject object
             */
            lastSubject_ = nil;
            lastSubjectName_ = nil;
        }

        /* return the inherited processing */
        return inherited(txt);
    }


    /* some pre-compiled search patterns we use a lot */
    patIdObjSlashIdApostS = static new RexPattern(
        '(<^space>+)(<space>+<^space>+)\'s(/<^space>+)$')

    patIdObjApostS = static new RexPattern(
        '(?!<^space>+\'s<space>)(<^space>+)(<space>+<^space>+)\'s$')
    patParamWithExclam = static new RexPattern('.*(!)(?:<space>.*|/.*|$)')
    patSSlashLetterEd = static new RexPattern(
        's/(<alpha>ed)$|(<alpha>ed)/s$')

    patIdObjSEnding = static new RexPattern(
        '(<^space>+)(<space>+<^space>+)s\'?(<space><^space>+)')

    /*
     *   Rewrite a parameter string for a language-specific syntax
     *   extension.
     *
     *   For English, we'll handle the possessive apostrophe-s suffix
     *   specially, by allowing the apostrophe-s to be appended to the
     *   target object name.  If we find an apostrophe-s on the target
     *   object name, we'll move it to the preceding identifier name:
     *
     *   the dobj's -> the's dobj
     *.  the dobj's/he -> the's dobj/he
     *.  he/the dobj's -> he/the's dobj
     *
     *   We also use this method to check for the presence of an
     *   exclamation mark at the end of any word in the parameter string
     *   (triggering the fixed-tense handling), and to detect a parameter
     *   string matching the {s/?ed} syntax, where ? is any letter, and
     *   rewrite it literally as 's/?ed' literally.
     */
    langRewriteParam(paramStr)
    {       
        /*
         *   Check for an exclamation mark at the end of any word in the
         *   parameter string, and remember the result of the test.
         */
        local exclam = rexMatch(patParamWithExclam, paramStr);
        fixedTenseProp_ = exclam;

        /*
         *   Remove the exclamation mark, if any.
         */
        if (exclam)
        {
            local exclamInd = rexGroup(1)[1];
            paramStr = paramStr.substr(1, exclamInd - 1)
                       + paramStr.substr(exclamInd + 1);
        }

        /* look for "id obj's" and "id1 obj's/id2" */
        if (rexMatch(patIdObjSlashIdApostS, paramStr) != nil)
        {
            /* rewrite with the "'s" moved to the preceding parameter name */
            paramStr = rexGroup(1)[3] + '\'s'
                       + rexGroup(2)[3] + rexGroup(3)[3];
                       
        }
        else if (rexMatch(patIdObjApostS, paramStr) != nil)
        {
            /* rewrite with the "'s" moved to the preceding parameter name */
            paramStr = rexGroup(1)[3] + '\'s' + rexGroup(2)[3];
        }

        /*
         *   Check if this parameter matches the {s/?ed} or {?ed/s} syntax.
         */
        if (rexMatch(patSSlashLetterEd, paramStr))
        {
            /*
             *   It does - remember the past verb ending, and rewrite the
             *   parameter literally as 's/?ed'.
             */
            pastEnding_ = rexGroup(1)[3];
            paramStr = 's/?ed';
        }

        /* return our (possibly modified) result */
        return paramStr;
    }

    /*
     *   This property is used to temporarily store the past-tense ending
     *   of a verb to be displayed by Thing.verbEndingSMessageBuilder_.
     *   It's for internal use only; game authors shouldn't have any reason
     *   to access it directly.
     */
    pastEnding_ = nil

    /*
     *   This property is used to temporarily store either a boolean value
     *   indicating whether the last encountered parameter string had an
     *   exclamation mark at the end of any word, or a property to be
     *   invoked by Thing.propWithPresentMessageBuilder_.  This field is
     *   for internal use only; authors shouldn't have any reason to access
     *   it directly.
     */
    fixedTenseProp_ = nil
;


/* ------------------------------------------------------------------------ */
/*
 *   Temporarily override the current narrative tense and invoke a callback
 *   function.
 */
withTense(usePastTense, callback)
{
    /*
     *   Remember the old value of the usePastTense flag.
     */
    local oldUsePastTense = gameMain.usePastTense;
    /*
     *   Set the new value.
     */
    gameMain.usePastTense = usePastTense;
    /*
     *   Invoke the callback (remembering the return value) and restore the
     *   usePastTense flag on our way out.
     */
    local ret;
    try { ret = callback(); }
    finally { gameMain.usePastTense = oldUsePastTense; }
    /*
     *   Return the result.
     */
    return ret;
}


/* ------------------------------------------------------------------------ */
/*
 *   Functions for spelling out numbers.  These functions take a numeric
 *   value as input, and return a string with the number spelled out as
 *   words in English.  For example, given the number 52, we'd return a
 *   string like 'fifty-two'.
 *
 *   These functions obviously have language-specific implementations.
 *   Note also that even their interfaces might vary by language.  Some
 *   languages might need additional information in the interface; for
 *   example, some languages might need to know the grammatical context
 *   (such as part of speech, case, or gender) of the result.
 *
 *   Note that some of the spellIntXxx flags might not be meaningful in all
 *   languages, because most of the flags are by their very nature
 *   associated with language-specific idioms.  Translations are free to
 *   ignore flags that indicate variations with no local equivalent, and to
 *   add their own language-specific flags as needed.
 */

/*
 *   Spell out an integer number in words.  Returns a string with the
 *   spelled-out number.
 *
 *   Note that this simple version of the function uses the default
 *   options.  If you want to specify non-default options with the
 *   SpellIntXxx flags, you can call spellIntExt().
 */
spellInt(val)
{
    return spellIntExt(val, 0);
}

/*
 *   Spell out an integer number in words, but only if it's below the given
 *   threshold.  It's often awkward in prose to spell out large numbers,
 *   but exactly what constitutes a large number depends on context, so
 *   this routine lets the caller specify the threshold.
 *   
 *   If the absolute value of val is less than (not equal to) the threshold
 *   value, we'll return a string with the number spelled out.  If the
 *   absolute value is greater than or equal to the threshold value, we'll
 *   return a string representing the number in decimal digits.  
 */
spellIntBelow(val, threshold)
{
    return spellIntBelowExt(val, threshold, 0, 0);
}

/*
 *   Spell out an integer number in words if it's below a threshold, using
 *   the spellIntXxx flags given in spellFlags to control the spelled-out
 *   format, and using the DigitFormatXxx flags in digitFlags to control
 *   the digit format.  
 */
spellIntBelowExt(val, threshold, spellFlags, digitFlags)
{
    local absval;

    /* compute the absolute value */
    absval = (val < 0 ? -val : val);

    /* check the value to see whether to spell it or write it as digits */
    if (absval < threshold)
    {
        /* it's below the threshold - spell it out in words */
        return spellIntExt(val, spellFlags);
    }
    else
    {
        /* it's not below the threshold - write it as digits */
        return intToDecimal(val, digitFlags);
    }
}

/*
 *   Format a number as a string of decimal digits.  The DigitFormatXxx
 *   flags specify how the number is to be formatted.`
 */
intToDecimal(val, flags)
{
    local str;
    local sep;

    /* perform the basic conversion */
    str = toString(val);

    /* add group separators as needed */
    if ((flags & DigitFormatGroupComma) != 0)
    {
        /* explicitly use a comma as a separator */
        sep = ',';
    }
    else if ((flags & DigitFormatGroupPeriod) != 0)
    {
        /* explicitly use a period as a separator */
        sep = '.';
    }
    else if ((flags & DigitFormatGroupSep) != 0)
    {
        /* use the current languageGlobals separator */
        sep = languageGlobals.digitGroupSeparator;
    }
    else
    {
        /* no separator */
        sep = nil;
    }

    /* if there's a separator, add it in */
    if (sep != nil)
    {
        local i;
        local len;

        /*
         *   Insert the separator before each group of three digits.
         *   Start at the right end of the string and work left: peel off
         *   the last three digits and insert a comma.  Then, move back
         *   four characters through the string - another three-digit
         *   group, plus the comma we inserted - and repeat.  Keep going
         *   until the amount we'd want to peel off the end is as long or
         *   longer than the entire remaining string.
         */
        for (i = 3, len = str.length() ; len > i ; i += 4)
        {
            /* insert this comma */
            str = str.substr(1, len - i) + sep + str.substr(len - i + 1);

            /* note the new length */
            len = str.length();
        }
    }

    /* return the result */
    return str;
}

/*
 *   Spell out an integer number - "extended" interface with flags.  The
 *   "flags" argument is a (bitwise-OR'd) combination of SpellIntXxx
 *   values, specifying the desired format of the result.
 */
spellIntExt(val, flags)
{
    local str;
    local trailingSpace;
    local needAnd;
    local powers = [1000000000, 'miljard ',
                    1000000,    'miljon ',
                    1000,       'tusen ',
                    100,        'hundra '];

    /* start with an empty string */
    str = '';
    trailingSpace = nil;
    needAnd = nil;

    /* if it's zero, it's a special case */
    if (val == 0)
        return 'noll';

    /*
     *   if the number is negative, note it in the string, and use the
     *   absolute value
     */
    if (val < 0)
    {
        str = 'minus ';
        val = -val;
    }

    /* do each named power of ten */
    for (local i = 1 ; val >= 100 && i <= powers.length() ; i += 2)
    {
        /*
         *   if we're in teen-hundreds mode, do the teen-hundreds - this
         *   only works for values from 1,100 to 9,999, since a number like
         *   12,000 doesn't work this way - 'one hundred twenty hundred' is
         *   no good 
         */
        if ((flags & SpellIntTeenHundreds) != 0
            && val >= 1100 && val < 10000)
        {
            /* if desired, add a comma if there was a prior power group */
            if (needAnd && (flags & SpellIntCommas) != 0)
                str = str.substr(1, str.length() - 1) + ', ';

            /* spell it out as a number of hundreds */
            str += spellIntExt(val / 100, flags) + 'hundra ';

            /* take off the hundreds */
            val %= 100;

            /* note the trailing space */
            trailingSpace = true;

            /* we have something to put an 'and' after, if desired */
            needAnd = true;

            /*
             *   whatever's left is below 100 now, so there's no need to
             *   keep scanning the big powers of ten
             */
            break;
        }

        /* if we have something in this power range, apply it */
        if (val >= powers[i])
        {
            /* if desired, add a comma if there was a prior power group */
            if (needAnd && (flags & SpellIntCommas) != 0)
                str = str.substr(1, str.length() - 1) + ', ';

            /* add the number of multiples of this power and the power name */
            str += spellIntExt(val / powers[i], flags) + powers[i+1];

            /* take it out of the remaining value */
            val %= powers[i];

            /*
             *   note that we have a trailing space in the string (all of
             *   the power-of-ten names have a trailing space, to make it
             *   easy to tack on the remainder of the value)
             */
            trailingSpace = true;

            /* we have something to put an 'and' after, if one is desired */
            needAnd = true;
        }
    }

    /*
     *   if we have anything left, and we have written something so far,
     *   and the caller wanted an 'and' before the tens part, add the
     *   'and'
     */
    if ((flags & SpellIntAndTens) != 0
        && needAnd
        && val != 0)
    {
        /* add the 'and' */
        str += 'och ';
        trailingSpace = true;
    }

    /* do the tens */
    if (val >= 20)
    {
        /* anything above the teens is nice and regular */
        str += ['tjugo', 'trettio', 'fyrtio', 'femtio', 'sextio',
                'sjuttio', 'åttio', 'nittio'][val/10 - 1];
        val %= 10;

        /* if it's non-zero, we'll add the units, so add a hyphen */
        //if (val != 0) str += '';

        /* we no longer have a trailing space in the string */
        trailingSpace = nil;
    }
    else if (val >= 10)
    {
        /* we have a teen */
        str += ['tio', 'elva', 'tolv', 'tretton', 'fjorton',
                'femton', 'sexton', 'sjutton', 'arton',
                'nitton'][val - 9];

        /* we've finished with the number */
        val = 0;

        /* there's no trailing space */
        trailingSpace = nil;
    }

    /* if we have a units value, add it */
    if (val != 0)
    {
        /* add the units name */
        str += ['ett', 'två', 'tre', 'fyra', 'fem',
                'sex', 'sju', 'åtta', 'nio'][val];

        /* we have no trailing space now */
        trailingSpace = nil;
    }

    /* if there's a trailing space, remove it */
    if (trailingSpace)
        str = str.substr(1, str.length() - 1);

    if(rexMatch('(ett).*(ljard|ljon)', str)) {
        str = rexReplace('ett', str, 'en', ReplaceOnce);
    }
    str = rexReplace(' ', str, '', ReplaceAll);
    /* return the string */
    return str;
}

/*
 *   Return a string giving the numeric ordinal representation of a number:
 *   1st, 2nd, 3rd, 4th, etc.  
 */
intOrdinal(n)
{
    local s;

    /* start by getting the string form of the number */
    s = toString(n);

    /* now add the appropriate suffix */
    if (n >= 10 && n <= 19)
    {
        /* the teens all end in 'th' */
        return s + ':e';
    }
    else
    {
        /*
         *   for anything but a teen, a number whose last digit is 1
         *   always has the suffix 'st' (for 'xxx-first', as in '141st'),
         *   a number whose last digit is 2 always ends in 'nd' (for
         *   'xxx-second', as in '532nd'), a number whose last digit is 3
         *   ends in 'rd' (for 'xxx-third', as in '53rd'), and anything
         *   else ends in 'th'
         */
        switch(n % 10)
        {
            
        case 1:
            return s + ':a';

        case 2:
            return s + ':a';

        default:
            return s + ':e';
        }
    }
}


/*
 *   Return a string giving a fully spelled-out ordinal form of a number:
 *   first, second, third, etc.
 */
spellIntOrdinal(n)
{
    return spellIntOrdinalExt(n, 0);
}

/*
 *   Return a string giving a fully spelled-out ordinal form of a number:
 *   first, second, third, etc.  This form takes the same flag values as
 *   spellIntExt().
 */
spellIntOrdinalExt(n, flags)
{
    local s;

    /* get the spelled-out form of the number itself */
    s = spellIntExt(n, flags);

    /*
     *   If the number ends in 'one', change the ending to 'first'; 'two'
     *   becomes 'second'; 'three' becomes 'third'; 'five' becomes
     *   'fifth'; 'eight' becomes 'eighth'; 'nine' becomes 'ninth'.  If
     *   the number ends in 'y', change the 'y' to 'ieth'.  'Zero' becomes
     *   'zeroeth'.  For everything else, just add 'th' to the spelled-out
     *   name
     */
    if (s == 'noll') return 'nollte';
    if (s.endsWith('ett')) return s.substr(1, s.length() - 3) + 'första';
    else if (s.endsWith('två')) return s.substr(1, s.length() - 3) + 'andra';
    else if (s.endsWith('tre')) return s + 'dje';
    else if (s.endsWith('fyra')) return s.substr(1, s.length() - 3) + 'järde';
    else if (s.endsWith('fem')) return s + 'te';
    else if (s.endsWith('sex')) return s.substr(1, s.length() - 2) + 'jätte';
    else if (s.endsWith('sju')) return s + 'nde';
    else if (s.endsWith('åtta')) return s.substr(1, s.length() - 1) + 'onde';
    else if (s.endsWith('o')) return s + 'nde';
    else if (s.endsWith('elva')) return s.substr(1, s.length() - 2) + 'fte';
    else if (s.endsWith('tolv')) return s.substr(1, s.length() - 1) + 'fte';
    else if (s.endsWith('ton')) return s + 'de';
    else if (s.endsWith('hundra')) return s + 'de';
    else if (s.endsWith('tusen')) return s.substr(1, s.length() - 2) + 'ende';
    return s + 'te';
}

/* ------------------------------------------------------------------------ */
/*
 *   Parse a spelled-out number.  This is essentially the reverse of
 *   spellInt() and related functions: we take a string that contains a
 *   spelled-out number and return the integer value.  This uses the
 *   command parser's spelled-out number rules, so we can parse anything
 *   that would be recognized as a number in a command.
 *
 *   If the string contains numerals, we'll treat it as a number in digit
 *   format: for example, if it contains '789', we'll return 789.
 *
 *   If the string doesn't parse as a number, we return nil.
 */
parseInt(str)
{
    try
    {
        /* tokenize the string */
        local toks = cmdTokenizer.tokenize(str);

        /* parse it */
        return parseIntTokens(toks);
    }
    catch (Exception exc)
    {
        /*
         *   on any exception, just return nil to indicate that we couldn't
         *   parse the string as a number
         */
        return nil;
    }
}

/*
 *   Parse a spelled-out number that's given as a token list (as returned
 *   from Tokenizer.tokenize).  If we can successfully parse the token list
 *   as a number, we'll return the integer value.  If not, we'll return
 *   nil.
 */
parseIntTokens(toks)
{
    try
    {
        /*
         *   if the first token contains digits, treat it as a numeric
         *   string value rather than a spelled-out number
         */
        if (toks.length() != 0
            && rexMatch('<digit>+', getTokOrig(toks[1])) != nil)
            return toInteger(getTokOrig(toks[1]));

        /* parse it using the spelledNumber production */
        local lst = spelledNumber.parseTokens(toks, cmdDict);

        /*
         *   if we got a match, return the integer value; if not, it's not
         *   parseable as a number, so return nil
         */
        return (lst.length() != 0 ? lst[1].getval() : nil);
    }
    catch (Exception exc)
    {
        /*
         *   on any exception, just return nil to indicate that it's not
         *   parseable as a number
         */
        return nil;
    }
}


/* ------------------------------------------------------------------------ */
/*
 *   Additional token types for US English.
 */

/* special "apostrophe-s" token */
enum token tokApostropheS;

/* special ending-on-s token */
enum token tokEndingOnS;


/* special apostrophe token for plural possessives ("the smiths' house") */
enum token tokPluralApostrophe;

/* special abbreviation-period token */
enum token tokAbbrPeriod;

/* special "#nnn" numeric token */
enum token tokPoundInt;

/*
 *   Command tokenizer for US English.  Other language modules should
 *   provide their own tokenizers to allow for differences in punctuation
 *   and other lexical elements.
 */
cmdTokenizer: Tokenizer
    rules_ = static
    [
        /* skip whitespace */
        ['whitespace', new RexPattern('<Space>+'), nil, &tokCvtSkip, nil],

        /* certain punctuation marks */
        ['punctuation', new RexPattern('[.,;:?!]'), tokPunct, nil, nil],

        /*
         *   We have a special rule for spelled-out numbers from 21 to 99:
         *   when we see a 'tens' word followed by a hyphen followed by a
         *   digits word, we'll pull out the tens word, the hyphen, and
         *   the digits word as separate tokens.
         */
        ['spelled number',
         new RexPattern('<NoCase>(tjugo|trettio|fyrtio|femtio|sextio|'
                        + 'sjuttio|åttio|nittio)-'
                        + '(en|två|tre|fyra|fem|sex|sju|åtta|nio)'
                        + '(?!<AlphaNum>)'),
         tokWord, &tokCvtSpelledNumber, nil],


        /*
         *   Initials.  We'll look for strings of three or two initials,
         *   set off by periods but without spaces.  We'll look for
         *   three-letter initials first ("G.H.W. Billfold"), then
         *   two-letter initials ("X.Y. Zed"), so that we find the longest
         *   sequence that's actually in the dictionary.  Note that we
         *   don't have a separate rule for individual initials, since
         *   we'll pick that up with the regular abbreviated word rule
         *   below.
         *
         *   Some games could conceivably extend this to allow strings of
         *   initials of four letters or longer, but in practice people
         *   tend to elide the periods in longer sets of initials, so that
         *   the initials become an acronym, and thus would fit the
         *   ordinary word token rule.
         */
        ['three initials',
         new RexPattern('<alpha><period><alpha><period><alpha><period>'),
         tokWord, &tokCvtAbbr, &acceptAbbrTok],

        ['two initials',
         new RexPattern('<alpha><period><alpha><period>'),
         tokWord, &tokCvtAbbr, &acceptAbbrTok],

        /*
         *   Abbbreviated word - this is a word that ends in a period,
         *   such as "Mr.".  This rule comes before the ordinary word rule
         *   because we will only consider the period to be part of the
         *   word (and not a separate token) if the entire string
         *   including the period is in the main vocabulary dictionary.
         */
        ['abbreviation',
         new RexPattern('<Alpha|-><AlphaNum|-|squote>*<period>'),
         tokWord, &tokCvtAbbr, &acceptAbbrTok],

        /*
         *   A word ending in s.  We parse this as two
         *   separate tokens: one for the word and one for a
         *   "apostrophe-s". 
         */

        ['possesive ending-s word',
         new RexPattern('%b<Alpha|-|&><AlphaNum|-|&|squote>*[sS]%b'),
         tokWord, &tokCvtEndingOnS, &acceptEndingOnSTok],

        /*
         *   A word ending in an apostrophe-s.  We parse this as two
         *   separate tokens: one for the word and one for the
         *   apostrophe-s.
         */
        ['apostrophe-s word',
         new RexPattern('<Alpha|-|&><AlphaNum|-|&|squote>*<squote>[sS]'),
         tokWord, &tokCvtApostropheS, nil],

        /*
         *   A plural word ending in an apostrophe.  We parse this as two
         *   separate tokens: one for the word and one for the apostrophe. 
         */
        ['plural possessive word',
         new RexPattern('<Alpha|-|&><AlphaNum|-|&|squote>*<squote>'
                        + '(?!<AlphaNum>)'),
         tokWord, &tokCvtPluralApostrophe, nil],


        /*
         *   Words - note that we convert everything to lower-case.  A word
         *   must start with an alphabetic character, a hyphen, or an
         *   ampersand; after the initial character, a word can contain
         *   alphabetics, digits, hyphens, ampersands, and apostrophes.
         */
        ['word',
         new RexPattern('<Alpha|-|&><AlphaNum|-|&|squote>*'),
         tokWord, nil, nil],

        /* an abbreviation word starting with a number */
        ['abbreviation with initial digit',
         new RexPattern('<Digit>(?=<AlphaNum|-|&|squote>*<Alpha|-|&|squote>)'
                        + '<AlphaNum|-|&|squote>*<period>'),
         tokWord, &tokCvtAbbr, &acceptAbbrTok],

        /*
         *   A word can start with a number, as long as there's something
         *   other than numbers in the string - if it's all numbers, we
         *   want to treat it as a numeric token.
         */
        ['word with initial digit',
         new RexPattern('<Digit>(?=<AlphaNum|-|&|squote>*<Alpha|-|&|squote>)'
                        + '<AlphaNum|-|&|squote>*'), tokWord, nil, nil],

        /* strings with ASCII "straight" quotes */
        ['string ascii-quote',
         new RexPattern('<min>([`\'"])(.*)%1(?!<AlphaNum>)'),
         tokString, nil, nil],

        /* some people like to use single quotes like `this' */
        ['string back-quote',
         new RexPattern('<min>`(.*)\'(?!<AlphaNum>)'), tokString, nil, nil],

        /* strings with Latin-1 curly quotes (single and double) */
        ['string curly single-quote',
         new RexPattern('<min>\u2018(.*)\u2019'), tokString, nil, nil],
        ['string curly double-quote',
         new RexPattern('<min>\u201C(.*)\u201D'), tokString, nil, nil],

        /*
         *   unterminated string - if we didn't just match a terminated
         *   string, but we have what looks like the start of a string,
         *   match to the end of the line
         */
        ['string unterminated',
         new RexPattern('([`\'"\u2018\u201C](.*)'), tokString, nil, nil],

        /* integer numbers */
        ['integer', new RexPattern('[0-9]+'), tokInt, nil, nil],

        /* numbers with a '#' preceding */
        ['integer with #',
         new RexPattern('#[0-9]+'), tokPoundInt, nil, nil]
    ]

    /*
     *   Handle an apostrophe-s word.  We'll return this as two separate
     *   tokens: one for the word preceding the apostrophe-s, and one for
     *   the apostrophe-s itself.
     */
    tokCvtApostropheS(txt, typ, toks)
    {
        local w;
        local s;

        /*
         *   pull out the part up to but not including the apostrophe, and
         *   pull out the apostrophe-s part
         */
        w = txt.substr(1, txt.length() - 2);
        s = txt.substr(-2);

        /* add the part before the apostrophe as the main token type */
        toks.append([w, typ, w]);

        /* add the apostrophe-s as a separate special token */
        toks.append([s, tokApostropheS, s]);
    }

    /*
     *   Handle an ending on-'s' word.  We'll return this as two separate
     *   tokens: one for the word preceding the s, and one for
     *   the s itself, disguised as an tokApostropheS with an empty lexeme '',
     *   this is to piggyback the already existing logic in tads3 english version
     *   to sort out ownership of things. Internally, the parser will understand  
     *   the equivalences of "tomas's book" in token succession. 
     *   [tokWord tokApostropheS tokWord]
     */
    tokCvtEndingOnS(txt, typ, toks)
    {
        //tadsSay('\ntokCvtEndingOnS: [<<txt>>]\n');
        /*
         *   pull out the part up to but not including the apostrophe, and
         *   pull out the apostrophe-s part
         */
        // Check if the word with the "s"-ending exists out in the world:
        local sEndingDoesExists = cmdDict.isWordDefined(txt, {result: (result & StrCompTrunc) == 0});
        if(sEndingDoesExists) {
            // If the word exists, we use the whole word as the main token type, as it naturally ends 
            // with a "s" regardless of when its possessive or not
            //tadsSay('THE TYPE IS: <<typ>>\n');
            toks.append([txt, typ, txt, true]); // We add a fourth element, to keep an attribute
            //toks.append([txt, tokEndingOnS, txt, true]); // We add a fourth element, to keep an attribute

            // We also add an apostrophe-s as a separate special invisible token 
            // (if it is invisible it won't show up during reconstruction of the sentence later).
            // toks.append(['', tokApostropheS, '']);
            return;
        } 

        // If the word with "s"-ending wasn't found, try to remove the ending 's' and search again:
        local w = txt.substr(1, txt.length() - 1);
        local endingWithoutSDoesExists = cmdDict.isWordDefined(w, {result: (result & StrCompTrunc) == 0});
        
        // If it does exist, create two tokens: 
        if(endingWithoutSDoesExists) {

            //tadsSay('THE TYPE IS: <<typ>>\n');
            // Add a normal token with the 's' removed
            toks.append([w, typ, w]);

            // Then add a FAKED apostrophe-s as a separate anonymous '' special token,
            // this is just done so the parser will quickly understand that we are looking
            // for a possessive part. 
            toks.append(['', tokApostropheS, '']);
            //tadsSay('\n(<<w>> (utan s finns). Skapar två tokens: <<typ>>, samt tokApostropheS.)\n');
        } else {
            // Otherwise, don't interfere, just add the whole word as the main token type 
            // toks.append([txt, typ, txt]);
        }
        
    }

    /*
     *   Handle a plural apostrophe word ("the smiths' house").  We'll
     *   return this as two tokens: one for the plural word, and one for
     *   the apostrophe. 
     */
    tokCvtPluralApostrophe(txt, typ, toks)
    {
        local w;
        local s;

        /*
         *   pull out the part up to but not including the apostrophe, and
         *   separately pull out the apostrophe 
         */
        w = txt.substr(1, txt.length() - 1);
        s = txt.substr(-1);

        /* add the part before the apostrophe as the main token type */
        toks.append([w, typ, w]);

        /* add the apostrophe-s as a separate special token */
        toks.append([s, tokPluralApostrophe, s]);
    }

    /*
     *   Handle a spelled-out hyphenated number from 21 to 99.  We'll
     *   return this as three separate tokens: a word for the tens name, a
     *   word for the hyphen, and a word for the units name.
     */
    tokCvtSpelledNumber(txt, typ, toks)
    {
        /* parse the number into its three parts with a regular expression */
        rexMatch(patAlphaDashAlpha, txt);

        /* add the part before the hyphen */
        toks.append([rexGroup(1)[3], typ, rexGroup(1)[3]]);

        /* add the hyphen */
        toks.append(['-', typ, '-']);

        /* add the part after the hyphen */
        toks.append([rexGroup(2)[3], typ, rexGroup(2)[3]]);
    }
    patAlphaDashAlpha = static new RexPattern('(<alpha>+)-(<alpha>+)')

    /*
     *   Check to see if we want to accept an abbreviated token - this is
     *   a token that ends in a period, which we use for abbreviated words
     *   like "Mr." or "Ave."  We'll accept the token only if it appears
     *   as given - including the period - in the dictionary.  Note that
     *   we ignore truncated matches, since the only way we'll accept a
     *   period in a word token is as the last character; there is thus no
     *   way that a token ending in a period could be a truncation of any
     *   longer valid token.
     */
    acceptAbbrTok(txt)
    {
        /* look up the word, filtering out truncated results */
        return cmdDict.isWordDefined(
            txt, {result: (result & StrCompTrunc) == 0});
    }

    acceptEndingOnSTok(txt) {
        if(txt.endsWith('s')) {
            //tadsSay('\nacceptEndingOnSTok: [<<txt>>]\n');
            if(cmdDict.isWordDefined(txt, {result: (result & StrCompTrunc) == 0})) {
                //tadsSay('[TRÄFF PÅ <<txt>>]\n');
                return true;
            }        
            local shortened = txt.substr(1, txt.length() - 1);
            if(cmdDict.isWordDefined(shortened, {result: (result & StrCompTrunc) == 0})) {
                //tadsSay('[TRÄFF på <<shortened>>]\n');
                return true;
            }
        }
        return nil;
        //tadsSay('[<<txt.substr(1, txt.length() - 1)>>]');
        //return cmdDict.isWordDefined(txt.substr(1, txt.length() - 1), {result: (result & StrCompTrunc) == 0});
    }
    /*
     *   Process an abbreviated token.
     *
     *   When we find an abbreviation, we'll enter it with the abbreviated
     *   word minus the trailing period, plus the period as a separate
     *   token.  We'll mark the period as an "abbreviation period" so that
     *   grammar rules will be able to consider treating it as an
     *   abbreviation -- but since it's also a regular period, grammar
     *   rules that treat periods as regular punctuation will also be able
     *   to try to match the result.  This will ensure that we try it both
     *   ways - as abbreviation and as a word with punctuation - and pick
     *   the one that gives us the best result.
     */
    tokCvtAbbr(txt, typ, toks)
    {
        local w;

        /* add the part before the period as the ordinary token */
        w = txt.substr(1, txt.length() - 1);
        toks.append([w, typ, w]);

        /* add the token for the "abbreviation period" */
        toks.append(['.', tokAbbrPeriod, '.']);
    }

    /*
     *   Given a list of token strings, rebuild the original input string.
     *   We can't recover the exact input string, because the tokenization
     *   process throws away whitespace information, but we can at least
     *   come up with something that will display cleanly and produce the
     *   same results when run through the tokenizer.
     */
    buildOrigText(toks)
    {
        local str;

        /* start with an empty string */
        str = '';

        /* concatenate each token in the list */
        for (local i = 1, local len = toks.length() ; i <= len ; ++i)
        {
            /* add the current token to the string */
            str += getTokOrig(toks[i]);

            /*
             *   if this looks like a hyphenated number that we picked
             *   apart into two tokens, put it back together without
             *   spaces
             */
            if (i + 2 <= len
                && rexMatch(patSpelledTens, getTokVal(toks[i])) != nil
                && getTokVal(toks[i+1]) == '-'
                && rexMatch(patSpelledUnits, getTokVal(toks[i+2])) != nil)
            {
                /*
                 *   it's a hyphenated number, all right - put the three
                 *   tokens back together without any intervening spaces,
                 *   so ['tjugo', '-', 'ett'] turns into 'tjugo-ett'
                 */
                str += getTokOrig(toks[i+1]) + getTokOrig(toks[i+2]);

                /* skip ahead by the two extra tokens we're adding */
                i += 2;
            }
            else if (i + 1 <= len
                     && getTokType(toks[i]) == tokWord
                     && getTokType(toks[i+1]) is in
                        (tokApostropheS, tokPluralApostrophe))
            {
                /*
                 *   it's a word followed by an apostrophe-s token - these
                 *   are appended together without any intervening spaces
                 */
                str += getTokOrig(toks[i+1]);

                /* skip the extra token we added */
                ++i;
            }

            /*
             *   If another token follows, and the next token isn't a
             *   punctuation mark, and the previous token wasn't an open
             *   paren, add a space before the next token.
             */
            if (i != len
                && rexMatch(patPunct, getTokVal(toks[i+1])) == nil
                && getTokVal(toks[i]) != '(')
                str += ' ';
        }

        /* return the result string */
        return str;
    }

    /* some pre-compiled regular expressions */
    patSpelledTens = static new RexPattern(
        '<nocase>tjugo|trettio|fyrtio|femtio|sextio|sjuttio|åttio|nittio')
    patSpelledUnits = static new RexPattern(
        '<nocase>ett|två|tre|fyra|fem|sex|sju|åtta|nio')
    patPunct = static new RexPattern('[.,;:?!)]')
;


/* ------------------------------------------------------------------------ */
/*
 *   Grammar Rules
 */

/*
 *   Command with explicit target actor.  When a command starts with an
 *   actor's name followed by a comma followed by a verb, we take it as
 *   being directed to the actor.
 */
grammar firstCommandPhrase(withActor):
    singleNounOnly->actor_ ',' commandPhrase->cmd_
    : FirstCommandProdWithActor

    /* "execute" the target actor phrase */
    execActorPhrase(issuingActor)
    {
        /* flag that the actor's being addressed in the second person */
        resolvedActor_.commandReferralPerson = SecondPerson;
    }
;

grammar firstCommandPhrase(askTellActorTo):
    ('fråga' | 'berätta' | 'f') singleNounOnly->actor_
    //('fråga' | 'berätta' | 'f'| 'säg') singleNounOnly->actor_
    ('om'|'till'|'för') commandPhrase->cmd_
    : FirstCommandProdWithActor

    /* "execute" the target actor phrase */
    execActorPhrase(issuingActor)
    {
        /*
         *   Since our phrasing is TELL <ACTOR> TO <DO SOMETHING>, the
         *   actor clearly becomes the antecedent for a subsequent
         *   pronoun.  For example, in TELL BOB TO READ HIS BOOK, the word
         *   HIS pretty clearly refers back to BOB.
         */
        if (resolvedActor_ != nil)
        {
            /* set the possessive anaphor object to the actor */
            resolvedActor_.setPossAnaphorObj(resolvedActor_);

            /* flag that the actor's being addressed in the third person */
            resolvedActor_.commandReferralPerson = ThirdPerson;

            /*
             *   in subsequent commands carried out by the issuer, the
             *   target actor is now the pronoun antecedent (for example:
             *   after TELL BOB TO GO NORTH, the command FOLLOW HIM means
             *   to follow Bob)
             */
            issuingActor.setPronounObj(resolvedActor_);
        }
    }
;

/*
 *   An actor-targeted command with a bad command phrase.  This is used as
 *   a fallback if we fail to match anything on the first attempt at
 *   parsing the first command on a line.  The point is to at least detect
 *   the target actor phrase, if that much is valid, so that we better
 *   customize error messages for the rest of the command.  
 */
grammar actorBadCommandPhrase(main):
    singleNounOnly->actor_ ',' miscWordList
    | ('fråga' | 'berätta' | 'f' | 'b') singleNounOnly->actor_ ('om'|'till'|'för')  miscWordList
    //| ('fråga' | 'berätta' | 'säg' | 'f' | 'b') singleNounOnly->actor_ ('om'|'till'|'för')  miscWordList
    : FirstCommandProdWithActor

    /* to resolve nouns, we merely resolve the actor */
    resolveNouns(issuingActor, targetActor, results)
    {
        /* resolve the underlying actor phrase */
        return actor_.resolveNouns(getResolver(issuingActor), results);
    }
;


/*
 *   Command-only conjunctions.  These words and groups of words can
 *   separate commands from one another, and can't be used to separate noun
 *   phrases in a noun list.  
 */
grammar commandOnlyConjunction(sentenceEnding):
    '.'
    | '!'
    : BasicProd

    /* these conjunctions end the sentence */
    isEndOfSentence() { return true; }
;

grammar commandOnlyConjunction(nonSentenceEnding):
    'sen'
    | 'och' 'sen'
    | ',' 'sen'
    | ',' 'och' 'sen'
    | ';'
    : BasicProd

    /* these conjunctions do not end a sentence */
    isEndOfSentence() { return nil; }
;


/*
 *   Command-or-noun conjunctions.  These words and groups of words can be
 *   used to separate commands from one another, and can also be used to
 *   separate noun phrases in a noun list.
 */
grammar commandOrNounConjunction(main):
    ','
    | 'och'
    | ',' 'och'
    : BasicProd

    /* these do not end a sentence */
    isEndOfSentence() { return nil; }
;

/*
 *   Noun conjunctions.  These words and groups of words can be used to
 *   separate noun phrases from one another.  Note that these do not need
 *   to be exclusive to noun phrases - these can occur as command
 *   conjunctions as well; this list is separated from
 *   commandOrNounConjunction in case there are conjunctions that can never
 *   be used as command conjunctions, since such conjunctions, which can
 *   appear here, would not appear in commandOrNounConjunctions.  
 */
grammar nounConjunction(main):
    ','
    | 'och'
    | ',' 'och'
    : BasicProd

    /* these conjunctions do not end a sentence */
    isEndOfSentence() { return nil; }
;

/* ------------------------------------------------------------------------ */
/*
 *   Noun list: one or more noun phrases connected with conjunctions.  This
 *   kind of noun list can end in a terminal noun phrase.
 *   
 *   Note that a single noun phrase is a valid noun list, since a list can
 *   simply be a list of one.  The separate production nounMultiList can be
 *   used when multiple noun phrases are required.  
 */

/*
 *   a noun list can consist of a single terminal noun phrase
 */
grammar nounList(terminal): terminalNounPhrase->np_ : NounListProd
    resolveNouns(resolver, results)
    {
        /* resolve the underlying noun phrase */
        return np_.resolveNouns(resolver, results);
    }
;

/*
 *   a noun list can consist of a list of a single complete (non-terminal)
 *   noun phrase
 */
grammar nounList(nonTerminal): completeNounPhrase->np_ : NounListProd
    resolveNouns(resolver, results)
    {
        /* resolve the underlying noun phrase */
        return np_.resolveNouns(resolver, results);
    }
;

/*
 *   a noun list can consist of a list with two or more entries
 */
grammar nounList(list): nounMultiList->lst_ : NounListProd
    resolveNouns(resolver, results)
    {
        /* resolve the underlying list */
        return lst_.resolveNouns(resolver, results);
    }
;

/*
 *   An empty noun list is one with no words at all.  This is matched when
 *   a command requires a noun list but the player doesn't include one;
 *   this construct has "badness" because we only want to match it when we
 *   have no choice.
 */
grammar nounList(empty): [badness 500] : EmptyNounPhraseProd
    responseProd = nounList
;

/* ------------------------------------------------------------------------ */
/*
 *   Noun Multi List: two or more noun phrases connected by conjunctions.
 *   This is almost the same as the basic nounList production, but this
 *   type of production requires at least two noun phrases, whereas the
 *   basic nounList production more generally defines its list as any
 *   number - including one - of noun phrases.
 */

/*
 *   a multi list can consist of a noun multi- list plus a terminal noun
 *   phrase, separated by a conjunction
 */
grammar nounMultiList(multi):
    nounMultiList->lst_ nounConjunction terminalNounPhrase->np_
    : NounListProd
    resolveNouns(resolver, results)
    {
        /* return a list of all of the objects from both underlying lists */
        return np_.resolveNouns(resolver, results)
            + lst_.resolveNouns(resolver, results);
    }
;

/*
 *   a multi list can consist of a non-terminal multi list
 */
grammar nounMultiList(nonterminal): nonTerminalNounMultiList->lst_
    : NounListProd
    resolveNouns(resolver, results)
    {
        /* resolve the underlying list */
        return lst_.resolveNouns(resolver, results);
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   A non-terminal noun multi list is a noun list made up of at least two
 *   non-terminal noun phrases, connected by conjunctions.
 *
 *   This is almost the same as the regular non-terminal noun list
 *   production, but this production requires two or more underlying noun
 *   phrases, whereas the basic non-terminal noun list matches any number
 *   of underlying phrases, including one.
 */

/*
 *   a non-terminal multi-list can consist of a pair of complete noun
 *   phrases separated by a conjunction
 */
grammar nonTerminalNounMultiList(pair):
    completeNounPhrase->np1_ nounConjunction completeNounPhrase->np2_
    : NounListProd
    resolveNouns(resolver, results)
    {
        /* return the combination of the two underlying noun phrases */
        return np1_.resolveNouns(resolver, results)
            + np2_.resolveNouns(resolver, results);
    }
;

/*
 *   a non-terminal multi-list can consist of another non-terminal
 *   multi-list plus a complete noun phrase, connected by a conjunction
 */
grammar nonTerminalNounMultiList(multi):
    nonTerminalNounMultiList->lst_ nounConjunction completeNounPhrase->np_
    : NounListProd
    resolveNouns(resolver, results)
    {
        /* return the combination of the sublist and the noun phrase */
        return lst_.resolveNouns(resolver, results)
            + np_.resolveNouns(resolver, results);
    }
;


/* ------------------------------------------------------------------------ */
/*
 *   "Except" list.  This is a noun list that can contain anything that's
 *   in a regular noun list plus some things that only make sense as
 *   exceptions, such as possessive nouns (e.g., "mine").
 */

grammar exceptList(single): exceptNounPhrase->np_ : ExceptListProd
    resolveNouns(resolver, results)
    {
        return np_.resolveNouns(resolver, results);
    }
;

grammar exceptList(list):
    exceptNounPhrase->np_ nounConjunction exceptList->lst_
    : ExceptListProd
    resolveNouns(resolver, results)
    {
        /* return a list consisting of all of our objects */
        return np_.resolveNouns(resolver, results)
            + lst_.resolveNouns(resolver, results);
    }
;

/*
 *   An "except" noun phrase is a normal "complete" noun phrase or a
 *   possessive noun phrase that doesn't explicitly qualify another phrase
 *   (for example, "all the coins but bob's" - the "bob's" is just a
 *   possessive noun phrase without another noun phrase attached, since it
 *   implicitly qualifies "the coins").
 */
grammar exceptNounPhrase(singleComplete): completeNounPhraseWithoutAll->np_
    : ExceptListProd
    resolveNouns(resolver, results)
    {
        return np_.resolveNouns(resolver, results);
    }
;

grammar exceptNounPhrase(singlePossessive): possessiveNounPhrase->poss_
    : ButPossessiveProd
;


/* ------------------------------------------------------------------------ */
/*
 *   A single noun is sometimes required where, structurally, a list is not
 *   allowed.  Single nouns should not be used to prohibit lists where
 *   there is no structural reason for the prohibition - these should be
 *   used only where it doesn't make sense to use a list structurally.  
 */
grammar singleNoun(normal): singleNounOnly->np_ : LayeredNounPhraseProd
;

/*
 *   An empty single noun is one with no words at all.  This is matched
 *   when a command requires a noun list but the player doesn't include
 *   one; this construct has "badness" because we only want to match it
 *   when we have no choice.
 */
grammar singleNoun(empty): [badness 500] : EmptyNounPhraseProd
    /* use a nil responseProd, so that we get the phrasing from the action */
    responseProd = nil

    /* the fallback responseProd, if we can't get one from the action */
    fallbackResponseProd = singleNoun
;

/*
 *   A user could attempt to use a noun list with more than one entry (a
 *   "multi list") where a single noun is required.  This is not a
 *   grammatical error, so we accept it grammatically; however, for
 *   disambiguation purposes we score it lower than a singleNoun production
 *   with only one noun phrase, and if we try to resolve it, we'll fail
 *   with an error.  
 */
grammar singleNoun(multiple): nounMultiList->np_ : SingleNounWithListProd
;


/*
 *   A *structural* single noun phrase.  This production is for use where a
 *   single noun phrase (not a list of nouns) is required grammatically.
 */
grammar singleNounOnly(main):
    terminalNounPhrase->np_
    | completeNounPhrase->np_
    : SingleNounProd
;

/* ------------------------------------------------------------------------ */
/*
 *   Prepositionally modified single noun phrases.  These can be used in
 *   indirect object responses, so allow for interactions like this:
 *   
 *   >unlock door
 *.  What do you want to unlock it with?
 *   
 *   >with the key
 *   
 *   The entire notion of prepositionally qualified noun phrases in
 *   interactive indirect object responses is specific to English, so this
 *   is implemented in the English module only.  However, the general
 *   notion of specialized responses to interactive indirect object queries
 *   is handled in the language-independent library in some cases, in such
 *   a way that the language-specific library can customize the behavior -
 *   see TIAction.askIobjResponseProd.  
 */
class PrepSingleNounProd: SingleNounProd
    resolveNouns(resolver, results)
    {
        return np_.resolveNouns(resolver, results);
    }

    /* 
     *   If the response starts with a preposition, it's pretty clearly a
     *   response to the special query rather than a new command. 
     */
    isSpecialResponseMatch()
    {
        return (np_ != nil && np_.firstTokenIndex > 1);
    }
;

/*
 *   Same thing for a Topic phrase
 */
class PrepSingleTopicProd: TopicProd
    resolveNouns(resolver, results)
    {
        return np_.resolveNouns(resolver, results);
    }
;

grammar inSingleNoun(main):
     singleNoun->np_ | ('i' | 'in' 'i' | 'in' 'till') singleNoun->np_
    : PrepSingleNounProd
;

grammar forSingleNoun(main):
   singleNoun->np_ | 'efter' singleNoun->np_ : PrepSingleNounProd
;

grammar toSingleNoun(main):
   singleNoun->np_ | 'till' singleNoun->np_ : PrepSingleNounProd
;

grammar throughSingleNoun(main):
   singleNoun->np_ | 'genom' singleNoun->np_
   : PrepSingleNounProd
;

grammar fromSingleNoun(main):
   singleNoun->np_ | 'från' singleNoun->np_ : PrepSingleNounProd
;

grammar onSingleNoun(main):
   singleNoun->np_ | ('på' | ('upp' 'på') | 'på' 'till') singleNoun->np_
    : PrepSingleNounProd
;

grammar withSingleNoun(main):
   singleNoun->np_ | 'med' singleNoun->np_ : PrepSingleNounProd
;

grammar atSingleNoun(main):
   singleNoun->np_ | 'på' singleNoun->np_ : PrepSingleNounProd
;

grammar outOfSingleNoun(main):
   singleNoun->np_ | 'ut' 'ur' singleNoun->np_ : PrepSingleNounProd
;

grammar aboutTopicPhrase(main):
   topicPhrase->np_ | 'om' topicPhrase->np_
   : PrepSingleTopicProd
;

/* ------------------------------------------------------------------------ */
/*
 *   Complete noun phrase - this is a fully-qualified noun phrase that
 *   cannot be modified with articles, quantifiers, or anything else.  This
 *   is the highest-level individual noun phrase.  
 */

grammar completeNounPhrase(main):
    completeNounPhraseWithAll->np_ | completeNounPhraseWithoutAll->np_
    : LayeredNounPhraseProd
;

/*
 *   Slightly better than a purely miscellaneous word list is a pair of
 *   otherwise valid noun phrases connected by a preposition that's
 *   commonly used in command phrases.  This will match commands where the
 *   user has assumed a command with a prepositional structure that doesn't
 *   exist among the defined commands.  Since we have badness, we'll be
 *   ignored any time there's a valid command syntax with the same
 *   prepositional structure.
 */
grammar completeNounPhrase(miscPrep):
    [badness 100] completeNounPhrase->np1_
        ('med' | 'in' 'i' | 'in' 'till' | 'genom' | 'thru' | 'for' | 'till'
         | ('upp' 'på') | 'på' 'till' | 'på' | 'under' | 'bakom')
        completeNounPhrase->np2_
    : NounPhraseProd
    resolveNouns(resolver, results)
    {
        /* note that we have an invalid prepositional phrase structure */
        results.noteBadPrep();

        /* resolve the underlying noun phrases, for scoring purposes */
        np1_.resolveNouns(resolver, results);
        np2_.resolveNouns(resolver, results);

        /* return nothing */
        return [];
    }
;


/*
 *   A qualified noun phrase can, all by itself, be a full noun phrase
 */
grammar completeNounPhraseWithoutAll(qualified): qualifiedNounPhrase->np_
    : LayeredNounPhraseProd
;

/*
 *   Pronoun rules.  A pronoun is a complete noun phrase; it does not allow
 *   further qualification.  
 */
grammar completeNounPhraseWithoutAll(it):   'det'|'den' : ItProd;
grammar completeNounPhraseWithoutAll(them): 'de'|'dem'|'dom' : ThemProd;
grammar completeNounPhraseWithoutAll(him):  'honom' : HimProd;
grammar completeNounPhraseWithoutAll(her):  'henne' : HerProd;

/*
 *   Reflexive second-person pronoun, for things like "bob, look at
 *   yourself"
 */
grammar completeNounPhraseWithoutAll(yourself):
    'mig' 'själv' | 'dig' 'själv' | 'du' 'själv' | 'ni' 'själva' | 'du' | 'dig' : YouProd
;

/*
 *   Reflexive third-person pronouns.  We accept these in places such as
 *   the indirect object of a two-object verb.
 */
grammar completeNounPhraseWithoutAll(itself): 'det själv' : ItselfProd
    /* check agreement of our binding */
    checkAgreement(lst)
    {
        /* the result is required to be singular and ungendered */
        return (lst.length() == 1 && lst[1].obj_.canMatchIt);
    }
;

grammar completeNounPhraseWithoutAll(themselves):
    'de själv' | 'de själva' : ThemselvesProd

    /* check agreement of our binding */
    checkAgreement(lst)
    {
        /*
         *   For 'themselves', allow anything; we could balk at this
         *   matching a single object that isn't a mass noun, but that
         *   would be overly picky, and it would probably reject at least
         *   a few things that really ought to be acceptable.  Besides,
         *   'them' is the closest thing English has to a singular
         *   gender-neutral pronoun, and some people intentionally use it
         *   as such.
         */
        return true;
    }
;

grammar completeNounPhraseWithoutAll(himself): 'han själv' : HimselfProd
    /* check agreement of our binding */
    checkAgreement(lst)
    {
        /* the result is required to be singular and masculine */
        return (lst.length() == 1 && lst[1].obj_.canMatchHim);
    }
;

grammar completeNounPhraseWithoutAll(herself): 'hon själv' : HerselfProd
    /* check agreement of our binding */
    checkAgreement(lst)
    {
        /* the result is required to be singular and feminine */
        return (lst.length() == 1 && lst[1].obj_.canMatchHer);
    }
;

/*
 *   First-person pronoun, for referring to the speaker: "bob, look at me"
 */
grammar completeNounPhraseWithoutAll(me): 'mig' | 'mig själv' : MeProd;

/*
 *   "All" and "all but".
 *   
 *   "All" is a "complete" noun phrase, because there's nothing else needed
 *   to make it a noun phrase.  We make this a special kind of complete
 *   noun phrase because 'all' is not acceptable as a complete noun phrase
 *   in some contexts where any of the other complete noun phrases are
 *   acceptable.
 *   
 *   "All but" is a "terminal" noun phrase - this is a special kind of
 *   complete noun phrase that cannot be followed by another noun phrase
 *   with "and".  "All but" is terminal because we want any and's that
 *   follow it to be part of the exception list, so that we interpret "take
 *   all but a and b" as excluding a and b, not as excluding a but then
 *   including b as a separate list.  
 */
grammar completeNounPhraseWithAll(main):
    ('allt'|'alla'|'allting')
    : EverythingProd
;

grammar terminalNounPhrase(allBut):
    ('allt'|'alla'|'allting') ('förutom'|'utom'|'bortsett') ('från'|)
        exceptList->except_
    : EverythingButProd
;

/*
 *   Plural phrase with an exclusion list.  This is a terminal noun phrase
 *   because it ends in an exclusion list.
 */
grammar terminalNounPhrase(pluralExcept):
    (qualifiedPluralNounPhrase->np_ | detPluralNounPhrase->np_)
    ('förutom'|'utom'|'bortsett' ('från'|)
    | 'men' 'inte') exceptList->except_
    : ListButProd
;

/*
 *   Qualified singular with an exception
 */
grammar terminalNounPhrase(anyBut):
    ('vad' 'som' 'helst' |'någon'|'något'|'valfri') nounPhrase->np_
    ('förutom'|'utom'|'bortsett' ('från'|)
    | 'men' 'inte') exceptList->except_
    : IndefiniteNounButProd
;

/* ------------------------------------------------------------------------ */
/*
 *   A qualified noun phrase is a noun phrase with an optional set of
 *   qualifiers: a definite or indefinite article, a quantifier, words such
 *   as 'any' and 'all', possessives, and locational specifiers ("the box
 *   on the table").
 *
 *   Without qualification, a definite article is implicit, so we read
 *   "take box" as equivalent to "take the box."
 *
 *   Grammar rule instantiations in language-specific modules should set
 *   property np_ to the underlying noun phrase match tree.
 */

/*
 *   A qualified noun phrase can be either singular or plural.  The number
 *   is a feature of the overall phrase; the phrase might consist of
 *   subphrases of different numbers (for example, "bob's coins" is plural
 *   even though it contains a singular subphrase, "bob"; and "one of the
 *   coins" is singular, even though its subphrase "coins" is plural).
 */
grammar qualifiedNounPhrase(main):
    qualifiedSingularNounPhrase->np_
    | qualifiedPluralNounPhrase->np_
    : LayeredNounPhraseProd
;

/* ------------------------------------------------------------------------ */
/*
 *   Singular qualified noun phrase.
 */

/*
 *   A singular qualified noun phrase with an implicit or explicit definite
 *   article.  If there is no article, a definite article is implied (we
 *   interpret "take box" as though it were "take the box").
 */
grammar qualifiedSingularNounPhrase(definite):
    ('den' | 'den' 'enda' | 'den' '1' | ) indetSingularNounPhrase->np_
    : DefiniteNounProd
;

/*
 *   A singular qualified noun phrase with an explicit indefinite article.
 */
grammar qualifiedSingularNounPhrase(indefinite):
    ('en' | 'ett') indetSingularNounPhrase->np_
    : IndefiniteNounProd
;

/*
 *   A singular qualified noun phrase with an explicit arbitrary
 *   determiner.
 */
grammar qualifiedSingularNounPhrase(arbitrary):
    //('any' | 'one' | '1' | 'any' ('one' | '1')) indetSingularNounPhrase->np_
    ('någon' |'en'|'ett' | '1' | ('någon'|'vilken' 'som' 'helst') 'av' ('en'|'ett' | '1')) indetSingularNounPhrase->np_
    : ArbitraryNounProd
;

/*
 *   A singular qualified noun phrase with a possessive adjective.
 */
grammar qualifiedSingularNounPhrase(possessive):
    possessiveAdjPhrase->poss_ indetSingularNounPhrase->np_
    : PossessiveNounProd
;

/*
 *   A singular qualified noun phrase that arbitrarily selects from a
 *   plural set.  This is singular, even though the underlying noun phrase
 *   is plural, because we're explicitly selecting one item.
 */
grammar qualifiedSingularNounPhrase(anyPlural):
    //'any' 'of' explicitDetPluralNounPhrase->np_
    //'vilken' 'som' 'helst' 'av' explicitDetPluralNounPhrase->np_
    (('någon'|'vilken') 'som' 'helst') 'av' explicitDetPluralNounPhrase->np_
    : ArbitraryNounProd
;

/*
 *   A singular object specified only by its containment, with a definite
 *   article.
 */
grammar qualifiedSingularNounPhrase(theOneIn):
    'den' 'som' ('är' | 'var')  ('i' | 'inuti' | 'inom' | 'på' | 'från')

    //'the' 'one' ('that' ('is' | 'was') | 'that' tokApostropheS | )
    //('in' | 'inside' | 'inside' 'of' | 'på' | 'från')
    completeNounPhraseWithoutAll->cont_
    : VagueContainerDefiniteNounPhraseProd

    /*
     *   our main phrase is simply 'one' (so disambiguation prompts will
     *   read "which one do you mean...")
     */
    mainPhraseText = 'sådan'
;

/*
 *   A singular object specified only by its containment, with an
 *   indefinite article.
 */
grammar qualifiedSingularNounPhrase(anyOneIn):
    ('allting' | 'en') ('som' ('är' | 'var') )
    ('i' | 'inuti' | 'inom' | 'på' | 'från')
    //('anything' | 'one') ('that' ('is' | 'was') | 'that' tokApostropheS | )
    //('in' | 'inside' | 'inside' 'of' | 'på' | 'från')
    completeNounPhraseWithoutAll->cont_
    : VagueContainerIndefiniteNounPhraseProd
;

/* ------------------------------------------------------------------------ */
/*
 *   An "indeterminate" singular noun phrase is a noun phrase without any
 *   determiner.  A determiner is a phrase that specifies the phrase's
 *   number and indicates whether or not it refers to a specific object,
 *   and if so fixes which object it refers to; determiners include
 *   articles ("the", "a") and possessives.
 *
 *   Note that an indeterminate phrase is NOT necessarily an indefinite
 *   phrase.  In fact, in most cases, we assume a definite usage when the
 *   determiner is omitted: we take TAKE BOX as meaning TAKE THE BOX.  This
 *   is more or less the natural way an English speaker would interpret
 *   this ill-formed phrasing, but even more than that, it's the
 *   Adventurese convention, taking into account that most players enter
 *   commands telegraphically and are accustomed to noun phrases being
 *   definite by default.
 */

/* an indetermine noun phrase can be a simple noun phrase */
grammar indetSingularNounPhrase(basic):
    nounPhrase->np_
    : LayeredNounPhraseProd
;

/*
 *   An indetermine noun phrase can specify a location for the object(s).
 *   The location must be a singular noun phrase, but can itself be a fully
 *   qualified noun phrase (so it can have possessives, articles, and
 *   locational qualifiers of its own).
 *   
 *   Note that we take 'that are' even though the noun phrase is singular,
 *   because what we consider a singular noun phrase can have plural usage
 *   ("scissors", for example).  
 */
grammar indetSingularNounPhrase(locational):
    nounPhrase->np_

    ('som' ('är' | 'var') | )
    ('i' | 'inuti' | 'inom' | 'på' | 'från')

    //('that' ('is' | 'was')
    // | 'that' tokApostropheS
    // | 'that' ('are' | 'were')
    // | )
    //('in' | 'inside' | 'inside' 'of' | 'på' | 'från')
    completeNounPhraseWithoutAll->cont_
    : ContainerNounPhraseProd
;

/* ------------------------------------------------------------------------ */
/*
 *   Plural qualified noun phrase.
 */

/*
 *   A simple unqualified plural phrase with determiner.  Since this form
 *   of plural phrase doesn't have any additional syntax that makes it an
 *   unambiguous plural, we can only accept an actual plural for the
 *   underlying phrase here - we can't accept an adjective phrase.
 */
grammar qualifiedPluralNounPhrase(determiner):
    ('någon'|'en'| ) detPluralOnlyNounPhrase->np_
    : LayeredNounPhraseProd
;

/* plural phrase qualified with a number and optional "any" */
grammar qualifiedPluralNounPhrase(anyNum):
    ('någon'|'en'| ) numberPhrase->quant_ indetPluralNounPhrase->np_
    | ('någon'|'en'| ) numberPhrase->quant_ 'av' explicitDetPluralNounPhrase->np_
    : QuantifiedPluralProd
;

/* plural phrase qualified with a number and "all" */
grammar qualifiedPluralNounPhrase(allNum):
    ('allt'|'alla'|'allting') numberPhrase->quant_ indetPluralNounPhrase->np_
    | ('allt'|'alla'|'allting') numberPhrase->quant_ ('av'|'från') explicitDetPluralNounPhrase->np_
    : ExactQuantifiedPluralProd
;

/* plural phrase qualified with "both" */
grammar qualifiedPluralNounPhrase(both):
    'båda' detPluralNounPhrase->np_
    | 'båda' 'av' explicitDetPluralNounPhrase->np_
    : BothPluralProd
;

/* plural phrase qualified with "all" */
grammar qualifiedPluralNounPhrase(all):
    ('allt'|'alla'|'allting') detPluralNounPhrase->np_
    | ('allt'|'alla'|'allting') 'av' explicitDetPluralNounPhrase->np_
    : AllPluralProd
;

/* vague plural phrase with location specified */
grammar qualifiedPluralNounPhrase(theOnesIn):
    ('de' ('där'|) ('som' ('är' | 'var') | )
     | ('allting' | 'allt')
       ('som' ('är' | 'var') | ('det'|'den') tokApostropheS | ))
    ('i' | 'inuti' | 'insidan' 'av' | 'på' | 'från')
    completeNounPhraseWithoutAll->cont_
    : AllInContainerNounPhraseProd
;

/* ------------------------------------------------------------------------ */
/*
 *   A plural noun phrase with a determiner.  The determiner can be
 *   explicit (such as an article or possessive) or it can implied (the
 *   implied determiner is the definite article, so "take boxes" is
 *   understood as "take the boxes").
 */
grammar detPluralNounPhrase(main):
    indetPluralNounPhrase->np_ | explicitDetPluralNounPhrase->np_
    : LayeredNounPhraseProd
;

/* ------------------------------------------------------------------------ */
/*
 *   A determiner plural phrase with an explicit underlying plural (i.e.,
 *   excluding adjective phrases with no explicitly plural words).
 */
grammar detPluralOnlyNounPhrase(main):
    implicitDetPluralOnlyNounPhrase->np_
    | explicitDetPluralOnlyNounPhrase->np_
    : LayeredNounPhraseProd
;

/*
 *   An implicit determiner plural phrase is an indeterminate plural phrase
 *   without any extra determiner - i.e., the determiner is implicit.
 *   We'll treat this the same way we do a plural explicitly determined
 *   with a definite article, since this is the most natural interpretation
 *   in English.
 *
 *   (This might seem like a pointless extra layer in the grammar, but it's
 *   necessary for the resolution process to have a layer that explicitly
 *   declares the phrase to be determined, even though the determiner is
 *   implied in the structure.  This extra layer is important because it
 *   explicitly calls results.noteMatches(), which is needed for rankings
 *   and the like.)
 */
grammar implicitDetPluralOnlyNounPhrase(main):
    indetPluralOnlyNounPhrase->np_
    : DefinitePluralProd
;

/* ------------------------------------------------------------------------ */
/*
 *   A plural noun phrase with an explicit determiner.
 */

/* a plural noun phrase with a definite article */
grammar explicitDetPluralNounPhrase(definite):
    'de' indetPluralNounPhrase->np_
    : DefinitePluralProd
;

/* a plural noun phrase with a definite article and a number */
grammar explicitDetPluralNounPhrase(definiteNumber):
    'de' numberPhrase->quant_ indetPluralNounPhrase->np_
    : ExactQuantifiedPluralProd
;

/* a plural noun phrase with a possessive */
grammar explicitDetPluralNounPhrase(possessive):
    possessiveAdjPhrase->poss_ indetPluralNounPhrase->np_
    : PossessivePluralProd
;

/* a plural noun phrase with a possessive and a number */
grammar explicitDetPluralNounPhrase(possessiveNumber):
    possessiveAdjPhrase->poss_ numberPhrase->quant_
    indetPluralNounPhrase->np_
    : ExactQuantifiedPossessivePluralProd
;

/* ------------------------------------------------------------------------ */
/*
 *   A plural noun phrase with an explicit determiner and only an
 *   explicitly plural underlying phrase.
 */
grammar explicitDetPluralOnlyNounPhrase(definite):
    'de' indetPluralOnlyNounPhrase->np_
    : AllPluralProd
;

grammar explicitDetPluralOnlyNounPhrase(definiteNumber):
    'de' numberPhrase->quant_ indetPluralNounPhrase->np_
    : ExactQuantifiedPluralProd
;

grammar explicitDetPluralOnlyNounPhrase(possessive):
    possessiveAdjPhrase->poss_ indetPluralOnlyNounPhrase->np_
    : PossessivePluralProd
;

grammar explicitDetPluralOnlyNounPhrase(possessiveNumber):
    possessiveAdjPhrase->poss_ numberPhrase->quant_
    indetPluralNounPhrase->np_
    : ExactQuantifiedPossessivePluralProd
;


/* ------------------------------------------------------------------------ */
/*
 *   An indeterminate plural noun phrase.
 *
 *   For the basic indeterminate plural phrase, allow an adjective phrase
 *   anywhere a plural phrase is allowed; this makes possible the
 *   short-hand of omitting a plural word when the plural number is
 *   unambiguous from context.
 */

/* a simple plural noun phrase */
grammar indetPluralNounPhrase(basic):
    pluralPhrase->np_ | adjPhrase->np_
    : LayeredNounPhraseProd
;

/*
 *   A plural noun phrase with a locational qualifier.  Note that even
 *   though the overall phrase is plural (and so the main underlying noun
 *   phrase is plural), the location phrase itself must always be singular.
 */
grammar indetPluralNounPhrase(locational):
    (pluralPhrase->np_ | adjPhrase->np_) ('de' ('är' | 'var') | )
    ('i' | 'inuti' | 'insidan' 'av' | 'på' | 'från')
    completeNounPhraseWithoutAll->cont_
    : ContainerNounPhraseProd
;

/*
 *   An indetermine plural noun phrase with only explicit plural phrases.
 */
grammar indetPluralOnlyNounPhrase(basic):
    pluralPhrase->np_
    : LayeredNounPhraseProd
;

grammar indetPluralOnlyNounPhrase(locational):
    pluralPhrase->np_ ('de' ('är' | 'var') | )
    ('i' | 'inuti' | 'insidan' 'av' | 'på' | 'från')
    completeNounPhraseWithoutAll->cont_
    : ContainerNounPhraseProd
;

/* ------------------------------------------------------------------------ */
/*
 *   Noun Phrase.  This is the basic noun phrase, which serves as a
 *   building block for complete noun phrases.  This type of noun phrase
 *   can be qualified with articles, quantifiers, and possessives, and can
 *   be used to construct possessives via the addition of "'s" at the end
 *   of the phrase.
 *   
 *   In most cases, custom noun phrase rules should be added to this
 *   production, as long as qualification (with numbers, articles, and
 *   possessives) is allowed.  For a custom noun phrase rule that cannot be
 *   qualified, a completeNounPhrase rule should be added instead.  
 */
grammar nounPhrase(main): compoundNounPhrase->np_
    : LayeredNounPhraseProd
;

/*
 *   Plural phrase.  This is the basic plural phrase, and corresponds to
 *   the basic nounPhrase for plural forms.
 */
grammar pluralPhrase(main): compoundPluralPhrase->np_
    : LayeredNounPhraseProd
;

/* ------------------------------------------------------------------------ */
/*
 *   Compound noun phrase.  This is one or more noun phrases connected with
 *   'of', as in "piece of paper".  The part after the 'of' is another
 *   compound noun phrase.
 *   
 *   Note that this general rule does not allow the noun phrase after the
 *   'of' to be qualified with an article or number, except that we make an
 *   exception to allow a definite article.  Other cases ("a piece of four
 *   papers") do not generally make sense, so we won't attempt to support
 *   them; instead, games can add as special cases new nounPhrase rules for
 *   specific literal sequences where more complex grammar is necessary.  
 */
grammar compoundNounPhrase(simple): simpleNounPhrase->np_
    : NounPhraseWithVocab
    getVocabMatchList(resolver, results, extraFlags)
    {
        return np_.getVocabMatchList(resolver, results, extraFlags);
    }
    getAdjustedTokens()
    {
        return np_.getAdjustedTokens();
    }
;
// 'till'?
grammar compoundNounPhrase(of):
    simpleNounPhrase->np1_ ('av'->of_|'med'->of_|'från'->of_|'över'->of_) compoundNounPhrase->np2_
    | simpleNounPhrase->np1_ 'av'->of_ 'de'->the_ compoundNounPhrase->np2_
    | simpleNounPhrase->np1_ 'från'->of_ 'de'->the_ compoundNounPhrase->np2_
    : NounPhraseWithVocab
    getVocabMatchList(resolver, results, extraFlags)
    {
        local lst1;
        local lst2;

        /* resolve the two underlying lists */
        lst1 = np1_.getVocabMatchList(resolver, results, extraFlags);
        lst2 = np2_.getVocabMatchList(resolver, results, extraFlags);

        /*
         *   the result is the intersection of the two lists, since we
         *   want the list of objects with all of the underlying
         *   vocabulary words
         */
        return intersectNounLists(lst1, lst2);
    }
    getAdjustedTokens()
    {
        local ofLst;

        /* generate the 'of the' list from the original words */
        if (the_ == nil)
            ofLst = [of_, &miscWord];
        else
            ofLst = [of_, &miscWord, the_, &miscWord];

        /* return the full list */
        return np1_.getAdjustedTokens() + ofLst + np2_.getAdjustedTokens();
    }
;


/* ------------------------------------------------------------------------ */
/*
 *   Compound plural phrase - same as a compound noun phrase, but involving
 *   a plural part before the 'of'.  
 */

/*
 *   just a single plural phrase
 */
grammar compoundPluralPhrase(simple): simplePluralPhrase->np_
    : NounPhraseWithVocab
    getVocabMatchList(resolver, results, extraFlags)
    {
        return np_.getVocabMatchList(resolver, results, extraFlags);
    }
    getAdjustedTokens()
    {
        return np_.getAdjustedTokens();
    }
;

/*
 *   <plural-phrase> of <noun-phrase>
 */
grammar compoundPluralPhrase(of):
    simplePluralPhrase->np1_ 'av'->of_ compoundNounPhrase->np2_
    | simplePluralPhrase->np1_ 'från'->of_ compoundNounPhrase->np2_
    | simplePluralPhrase->np1_ 'av'->of_ 'de'->the_ compoundNounPhrase->np2_
    | simplePluralPhrase->np1_ 'från'->of_ 'de'->the_ compoundNounPhrase->np2_
    : NounPhraseWithVocab
    getVocabMatchList(resolver, results, extraFlags)
    {
        local lst1;
        local lst2;

        /* resolve the two underlying lists */
        lst1 = np1_.getVocabMatchList(resolver, results, extraFlags);
        lst2 = np2_.getVocabMatchList(resolver, results, extraFlags);

        /*
         *   the result is the intersection of the two lists, since we
         *   want the list of objects with all of the underlying
         *   vocabulary words
         */
        return intersectNounLists(lst1, lst2);
    }
    getAdjustedTokens()
    {
        local ofLst;

        /* generate the 'of the' list from the original words */
        if (the_ == nil)
            ofLst = [of_, &miscWord];
        else
            ofLst = [of_, &miscWord, the_, &miscWord];

        /* return the full list */
        return np1_.getAdjustedTokens() + ofLst + np2_.getAdjustedTokens();
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   Simple noun phrase.  This is the most basic noun phrase, which is
 *   simply a noun, optionally preceded by one or more adjectives.
 */

/*
 *   just a noun
 */
grammar simpleNounPhrase(noun): nounWord->noun_ : NounPhraseWithVocab
    /* generate a list of my resolved objects */
    getVocabMatchList(resolver, results, extraFlags)
    {
        return noun_.getVocabMatchList(resolver, results, extraFlags);
    }
    getAdjustedTokens()
    {
        return noun_.getAdjustedTokens();
    }
;

/*
 *   <adjective> <simple-noun-phrase> (this allows any number of adjectives
 *   to be applied) 
 */
grammar simpleNounPhrase(adjNP): adjWord->adj_ simpleNounPhrase->np_
    : NounPhraseWithVocab

    /* generate a list of my resolved objects */
    getVocabMatchList(resolver, results, extraFlags)
    {
        /*
         *   return the list of objects in scope matching our adjective
         *   plus the list from the underlying noun phrase
         */
        return intersectNounLists(
            adj_.getVocabMatchList(resolver, results, extraFlags),
            np_.getVocabMatchList(resolver, results, extraFlags));
    }
    getAdjustedTokens()
    {
        return adj_.getAdjustedTokens() + np_.getAdjustedTokens();
    }
;

/*
 *   A simple noun phrase can also include a number or a quoted string
 *   before or after a noun.  A number can be spelled out or written with
 *   numerals; we consider both forms equivalent in meaning.
 *   
 *   A number in this type of usage is grammatically equivalent to an
 *   adjective - it's not meant to quantify the rest of the noun phrase,
 *   but rather is simply an adjective-like modifier.  For example, an
 *   elevator's control panel might have a set of numbered buttons which we
 *   want to refer to as "button 1," "button 2," and so on.  It is
 *   frequently the case that numeric adjectives are equally at home before
 *   or after their noun: "push 3 button" or "push button 3".  In addition,
 *   we accept a number by itself as a lone adjective, as in "push 3".  
 */

/*
 *   just a numeric/string adjective (for things like "push 3", "push #3",
 *   'push "G"')
 */
grammar simpleNounPhrase(number): literalAdjPhrase->adj_
    : NounPhraseWithVocab
    getVocabMatchList(resolver, results, extraFlags)
    {
        /*
         *   note that this counts as an adjective-ending phrase, since we
         *   don't have a noun involved
         */
        results.noteAdjEnding();

        /* pass through to the underlying literal adjective phrase */
        local lst = adj_.getVocabMatchList(resolver, results,
                                           extraFlags | EndsWithAdj);

        /* if in global scope, also try a noun interpretation */
        if (resolver.isGlobalScope)
            lst = adj_.addNounMatchList(lst, resolver, results, extraFlags);

        /* return the result */
        return lst;
    }
    getAdjustedTokens()
    {
        /* pass through to the underlying literal adjective phrase */
        return adj_.getAdjustedTokens();
    }
;

/*
 *   <literal-adjective> <noun> (for things like "board 44 bus" or 'push
 *   "G" button')
 */
grammar simpleNounPhrase(numberAndNoun):
    literalAdjPhrase->adj_ nounWord->noun_
    : NounPhraseWithVocab
    getVocabMatchList(resolver, results, extraFlags)
    {
        local nounList;
        local adjList;

        /* get the list of objects matching the rest of the noun phrase */
        nounList = noun_.getVocabMatchList(resolver, results, extraFlags);

        /* get the list of objects matching the literal adjective */
        adjList = adj_.getVocabMatchList(resolver, results, extraFlags);

        /* intersect the two lists and return the results */
        return intersectNounLists(nounList, adjList);
    }
    getAdjustedTokens()
    {
        return adj_.getAdjustedTokens() + noun_.getAdjustedTokens();
    }
;

/*
 *   <noun> <literal-adjective> (for things like "press button 3" or 'put
 *   tab "A" in slot "B"')
 */
grammar simpleNounPhrase(nounAndNumber):
    nounWord->noun_ literalAdjPhrase->adj_
    : NounPhraseWithVocab
    getVocabMatchList(resolver, results, extraFlags)
    {
        local nounList;
        local adjList;

        /* get the list of objects matching the rest of the noun phrase */
        nounList = noun_.getVocabMatchList(resolver, results, extraFlags);

        /* get the literal adjective matches */
        adjList = adj_.getVocabMatchList(resolver, results, extraFlags);

        /* intersect the two lists and return the results */
        return intersectNounLists(nounList, adjList);
    }
    getAdjustedTokens()
    {
        return noun_.getAdjustedTokens() + adj_.getAdjustedTokens();
    }
;

/*
 *   A simple noun phrase can also end in an adjective, which allows
 *   players to refer to objects using only their unique adjectives rather
 *   than their full names, which is sometimes more convenient: just "take
 *   gold" rather than "take gold key."
 *   
 *   When a particular phrase can be interpreted as either ending in an
 *   adjective or ending in a noun, we will always take the noun-ending
 *   interpretation - in such cases, the adjective-ending interpretation is
 *   probably a weak binding.  For example, "take pizza" almost certainly
 *   refers to the pizza itself when "pizza" and "pizza box" are both
 *   present, but it can also refer just to the box when no pizza is
 *   present.
 *   
 *   Equivalent to a noun phrase ending in an adjective is a noun phrase
 *   ending with an adjective followed by "one," as in "the red one."  
 */
grammar simpleNounPhrase(adj): adjWord->adj_ : NounPhraseWithVocab
    /* generate a list of my resolved objects */
    getVocabMatchList(resolver, results, extraFlags)
    {
        /* note in the results that we end in an adjective */
        results.noteAdjEnding();

        /* generate a list of objects matching the adjective */
        local lst = adj_.getVocabMatchList(
            resolver, results, extraFlags | EndsWithAdj);

        /* if in global scope, also try a noun interpretation */
        if (resolver.isGlobalScope)
            lst = adj_.addNounMatchList(lst, resolver, results, extraFlags);

        /* return the result */
        return lst;
    }
    getAdjustedTokens()
    {
        /* return the adjusted token list for the adjective */
        return adj_.getAdjustedTokens();
    }
;

grammar simpleNounPhrase(adjAndOne): adjective->adj_ 'en'
    : NounPhraseWithVocab
    /* generate a list of my resolved objects */
    getVocabMatchList(resolver, results, extraFlags)
    {
        /*
         *   This isn't exactly an adjective ending, but consider it as
         *   such anyway, since we're not matching 'one' to a vocabulary
         *   word - we're just using it as a grammatical marker that we're
         *   not providing a real noun.  If there's another match for
         *   which 'one' is a noun, that one is definitely preferred to
         *   this one; the adj-ending marking will ensure that we choose
         *   the other one.
         */
        results.noteAdjEnding();

        /* generate a list of objects matching the adjective */
        return getWordMatches(adj_, &adjective, resolver,
                              extraFlags | EndsWithAdj, VocabTruncated);
    }
    getAdjustedTokens()
    {
        return [adj_, &adjective];
    }
;

/*
 *   In the worst case, a simple noun phrase can be constructed from
 *   arbitrary words that don't appear in our dictionary.
 */
grammar simpleNounPhrase(misc):
    [badness 200] miscWordList->lst_ : NounPhraseWithVocab
    getVocabMatchList(resolver, results, extraFlags)
    {
        /* get the match list from the underlying list */
        local lst = lst_.getVocabMatchList(resolver, results, extraFlags);

        /*
         *   If there are no matches, note in the results that we have an
         *   arbitrary word list.  Note that we do this only if there are
         *   no matches, because we might match non-dictionary words to an
         *   object with a wildcard in its vocabulary words, in which case
         *   this is a valid, matching phrase after all.
         */
        if (lst == nil || lst.length() == 0)
            results.noteMiscWordList(lst_.getOrigText());

        /* return the match list */
        return lst;
    }
    getAdjustedTokens()
    {
        return lst_.getAdjustedTokens();
    }
;

/*
 *   If the command has qualifiers but omits everything else, we can have
 *   an empty simple noun phrase.
 */
grammar simpleNounPhrase(empty): [badness 600] : NounPhraseWithVocab
    getVocabMatchList(resolver, results, extraFlags)
    {
        /* we have an empty noun phrase */
        return results.emptyNounPhrase(resolver);
    }
    getAdjustedTokens()
    {
        return [];
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   An AdjPhraseWithVocab is an English-specific subclass of
 *   NounPhraseWithVocab, specifically for noun phrases that contain
 *   entirely adjectives.  
 */
class AdjPhraseWithVocab: NounPhraseWithVocab
    /* the property for the adjective literal - this is usually adj_ */
    adjVocabProp = &adj_

    /* 
     *   Add the vocabulary matches that we'd get if we were treating our
     *   adjective as a noun.  This combines the noun interpretation with a
     *   list of matches we got for the adjective version.  
     */
    addNounMatchList(lst, resolver, results, extraFlags)
    {
        /* get the word matches with a noun interpretation of our adjective */
        local nLst = getWordMatches(
            self.(adjVocabProp), &noun, resolver, extraFlags, VocabTruncated);

        /* combine the lists and return the result */
        return combineWordMatches(lst, nLst);
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   A "literal adjective" phrase is a number or string used as an
 *   adjective.
 */
grammar literalAdjPhrase(number):
    numberPhrase->num_ | poundNumberPhrase->num_
    : AdjPhraseWithVocab

    adj_ = (num_.getStrVal())
    getVocabMatchList(resolver, results, extraFlags)
    {
        local numList;

        /*
         *   get the list of objects matching the numeral form of the
         *   number as an adjective
         */
        numList = getWordMatches(num_.getStrVal(), &adjective,
                                 resolver, extraFlags, VocabTruncated);

        /* add the list of objects matching the special '#' wildcard */
        numList += getWordMatches('#', &adjective, resolver,
                                  extraFlags, VocabTruncated);

        /* return the combined lists */
        return numList;
    }
    getAdjustedTokens()
    {
        return [num_.getStrVal(), &adjective];
    }
;

grammar literalAdjPhrase(string): quotedStringPhrase->str_
    : AdjPhraseWithVocab

    adj_ = (str_.getStringText().toLower())
    getVocabMatchList(resolver, results, extraFlags)
    {
        local strList;
        local wLst;

        /*
         *   get the list of objects matching the string with the quotes
         *   removed
         */
        strList = getWordMatches(str_.getStringText().toLower(),
                                 &literalAdjective,
                                 resolver, extraFlags, VocabTruncated);

        /* add the list of objects matching the literal-adjective wildcard */
        wLst = getWordMatches('\u0001', &literalAdjective, resolver,
                              extraFlags, VocabTruncated);
        strList = combineWordMatches(strList, wLst);

        /* return the combined lists */
        return strList;
    }
    getAdjustedTokens()
    {
        return [str_.getStringText().toLower(), &adjective];
    }
;

/*
 *   In many cases, we might want to write what is semantically a literal
 *   string qualifier without the quotes.  For example, we might want to
 *   refer to an elevator button that's labeled "G" as simply "button G",
 *   without any quotes around the "G".  To accommodate these cases, we
 *   provide the literalAdjective part-of-speech.  We'll match these parts
 *   of speech the same way we'd match them if they were quoted.
 */
grammar literalAdjPhrase(literalAdj): literalAdjective->adj_
    : AdjPhraseWithVocab
    getVocabMatchList(resolver, results, extraFlags)
    {
        local lst;

        /* get a list of objects in scope matching our literal adjective */
        lst = getWordMatches(adj_, &literalAdjective, resolver,
                             extraFlags, VocabTruncated);

        /* if the scope is global, also include ordinary adjective matches */
        if (resolver.isGlobalScope)
        {
            /* get the ordinary adjective bindings */
            local aLst = getWordMatches(adj_, &adjective, resolver,
                                        extraFlags, VocabTruncated);

            /* global scope - combine the lists */
            lst = combineWordMatches(lst, aLst);
        }

        /* return the result */
        return lst;
    }
    getAdjustedTokens()
    {
        return [adj_, &literalAdjective];
    }
;


/* ------------------------------------------------------------------------ */
/*
 *   A noun word.  This can be either a simple 'noun' vocabulary word, or
 *   it can be an abbreviated noun with a trailing abbreviation period.
 */
class NounWordProd: NounPhraseWithVocab
    getVocabMatchList(resolver, results, extraFlags)
    {
        local w;
        local nLst;

        /* get our word text */
        w = getNounText();

        /* get the list of matches as nouns */
        nLst = getWordMatches(w, &noun, resolver, extraFlags, VocabTruncated);

        /*
         *   If the resolver indicates that we're in a "global" scope,
         *   *also* include any additional matches as adjectives.
         *
         *   Normally, when we're operating in limited, local scopes, we
         *   use the structure of the phrasing to determine whether to
         *   match a noun or adjective; if we have a match for a given word
         *   as a noun, we'll treat it only as a noun.  This allows us to
         *   take PIZZA to refer to the pizza (for which 'pizza' is defined
         *   as a noun) rather than to the PIZZA BOX (for which 'pizza' is
         *   a mere adjective) when both are in scope.  It's obvious which
         *   the player means in such cases, so we can be smart about
         *   choosing the stronger match.
         *
         *   In cases of global scope, though, it's much harder to guess
         *   about the player's intentions.  When the player types PIZZA,
         *   they might be thinking of the box even though there's a pizza
         *   somewhere else in the game.  Since the two objects might be in
         *   entirely different locations, both out of view, we can't
         *   assume that one or the other is more likely on the basis of
         *   which is closer to the player's senses.  So, it's better to
         *   allow both to match for now, and decide later, based on the
         *   context of the command, which was actually meant.
         */
        if (resolver.isGlobalScope)
        {
            /* get the list of matching adjectives */
            local aLst = getWordMatches(w, &adjective, resolver,
                                        extraFlags, VocabTruncated);

            /* combine it with the noun list */
            nLst = combineWordMatches(nLst, aLst);
        }

        /* return the match list */
        return nLst;
    }
    getAdjustedTokens()
    {
        /* the noun includes the period as part of the literal text */
        return [getNounText(), &noun];
    }

    /* the actual text of the noun to match to the dictionary */
    getNounText() { return noun_; }
;

grammar nounWord(noun): noun->noun_ : NounWordProd
;

grammar nounWord(nounAbbr): noun->noun_ tokAbbrPeriod->period_
    : NounWordProd

    /*
     *   for dictionary matching purposes, include the text of our noun
     *   with the period attached - the period is part of the dictionary
     *   entry for an abbreviated word
     */
    getNounText() { return noun_ + period_; }
;

/* ------------------------------------------------------------------------ */
/*
 *   An adjective word.  This can be either a simple 'adjective' vocabulary
 *   word, or it can be an 'adjApostS' vocabulary word plus a 's token.  
 */

grammar adjWord(adj): adjective->adj_ : AdjPhraseWithVocab
    /* generate a list of resolved objects */
    getVocabMatchList(resolver, results, extraFlags)
    {
        /* return a list of objects in scope matching our adjective */
        return getWordMatches(adj_, &adjective, resolver,
                              extraFlags, VocabTruncated);
    }
    getAdjustedTokens()
    {
        return [adj_, &adjective];
    }
;

grammar adjWord(adjApostS): adjApostS->adj_ tokApostropheS->apost_
    : AdjPhraseWithVocab
    /* generate a list of resolved objects */
    getVocabMatchList(resolver, results, extraFlags)
    {
        /* return a list of objects in scope matching our adjective */
        return getWordMatches(adj_, &adjApostS, resolver,
                              extraFlags, VocabTruncated);
    }
    getAdjustedTokens()
    {
        return [adj_, &adjApostS];
    }
;

grammar adjWord(adjAbbr): adjective->adj_ tokAbbrPeriod->period_
    : AdjPhraseWithVocab
    getVocabMatchList(resolver, results, extraFlags)
    {
        /*
         *   return the list matching our adjective *with* the period
         *   attached; the period is part of the dictionary entry for an
         *   abbreviated word
         */
        return getWordMatches(adj_ + period_, &adjective, resolver,
                              extraFlags, VocabTruncated);
    }
    getAdjustedTokens()
    {
        /* the adjective includes the period as part of the literal text */
        return [adj_ + period_, &adjective];
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   Possessive phrase.  This is a noun phrase expressing ownership of
 *   another object.
 *   
 *   Note that all possessive phrases that can possibly be ambiguous must
 *   define getOrigMainText() to return the "main noun phrase" text.  In
 *   English, this means that we must omit any "'s" suffix.  This is needed
 *   only when the phrase can be ambiguous, so pronouns don't need it since
 *   they are inherently unambiguous.  
 */
grammar possessiveAdjPhrase(its): 'dess' : ItsAdjProd
    /* we only agree with a singular ungendered noun */
    checkAnaphorAgreement(lst)
        { return lst.length() == 1 && lst[1].obj_.canMatchIt; }
;
grammar possessiveAdjPhrase(his): 'hans' : HisAdjProd
    /* we only agree with a singular masculine noun */
    checkAnaphorAgreement(lst)
        { return lst.length() == 1 && lst[1].obj_.canMatchHim; }
;
grammar possessiveAdjPhrase(her): 'hennes' : HerAdjProd
    /* we only agree with a singular feminine noun */
    checkAnaphorAgreement(lst)
        { return lst.length() == 1 && lst[1].obj_.canMatchHer; }
;
grammar possessiveAdjPhrase(their): 'deras' : TheirAdjProd
    /* we only agree with a single noun that has plural usage */
    checkAnaphorAgreement(lst)
        { return lst.length() == 1 && lst[1].obj_.isPlural; }
;
grammar possessiveAdjPhrase(your): 'din' : YourAdjProd
    /* we are non-anaphoric */
    checkAnaphorAgreement(lst) { return nil; }
;
grammar possessiveAdjPhrase(yourNeuter): 'ditt' : YourAdjProd
    /* we are non-anaphoric */
    checkAnaphorAgreement(lst) { return nil; }
;
grammar possessiveAdjPhrase(yourPlural): 'dina' : YourAdjProd
    /* we are non-anaphoric */
    checkAnaphorAgreement(lst) { return nil; }
;
grammar possessiveAdjPhrase(my): 'min' : MyAdjProd
    /* we are non-anaphoric */
    checkAnaphorAgreement(lst) { return nil; }
;
grammar possessiveAdjPhrase(myNeuter): 'mitt' : MyAdjProd
    /* we are non-anaphoric */
    checkAnaphorAgreement(lst) { return nil; }
;
grammar possessiveAdjPhrase(myPlural): 'mina' : MyAdjProd
    /* we are non-anaphoric */
    checkAnaphorAgreement(lst) { return nil; }
;

grammar possessiveAdjPhrase(npApostropheS):
    ('den' | ) nounPhrase->np_  tokApostropheS->apost_  
    //| ('den' | ) nounPhrase->np_ 
    : LayeredNounPhraseProd    
    
    resolveNouns(resolver, results)
    {
        //tadsSay(self);
        //tadsSay('\n');

        /*
        resolver: Resolver 
            action_ = action;      // What action
            issuer_ = issuingActor; // Who issued the command
            actor_ = targetActor; // Who acting
        
        results: CommandRanking -> BasicResolveResults -> ResolveResults
            targetActor_ = nil
            issuingActor_ = nil
 
        results: [ResolveInfo]
                obj_ = obj;
                flags_ = flags;
                np_ = np;
        */
        /*
        local weakPossessive = tokenList && tokenList.length == 3 && tokenList[2].length == 4 && tokenList[2][4];
        if(weakPossessive) {
            // tadsSay('WEAK possessive!');
            results.append(new ResolveInfo(obj, 150));
        }*/
        /* let the underlying match tree object do the work */
        return np_.resolveNouns(resolver, results);
    }

    /* get the original text without the "'s" suffix */
    getOrigMainText()
    {
        /* return just the basic noun phrase part */
        return np_.getOrigText();
    }
;

grammar possessiveAdjPhrase(ppApostropheS):
    ('den' | ) pluralPhrase->np_
       (tokApostropheS->apost_ | tokPluralApostrophe->apost_)
    : LayeredNounPhraseProd

    /* get the original text without the "'s" suffix */
    getOrigMainText()
    {
        /* return just the basic noun phrase part */
        return np_.getOrigText();
    }

    resolveNouns(resolver, results)
    {
        /* note that we have a plural phrase, structurally speaking */
        results.notePlural();

        /* inherit the default handling */
        return inherited(resolver, results);
    }

    /* the possessive phrase is plural */
    isPluralPossessive = true
;

/*
 *   Possessive noun phrases.  These are similar to possessive phrases, but
 *   are stand-alone phrases that can act as nouns rather than as
 *   qualifiers for other noun phrases.  For example, for a first-person
 *   player character, "mine" would be a possessive noun phrase referring
 *   to an object owned by the player character.
 *   
 *   Note that many of the words used for possessive nouns are the same as
 *   for possessive adjectives - for example "his" is the same in either
 *   case, as are "'s" words.  However, we make the distinction internally
 *   because the two have different grammatical uses, and some of the words
 *   do differ ("her" vs "hers", for example).  
 */
grammar possessiveNounPhrase(its): 'dess': ItsNounProd;
grammar possessiveNounPhrase(his): 'hans': HisNounProd;
grammar possessiveNounPhrase(hers): 'hennes': HersNounProd;
grammar possessiveNounPhrase(theirs): 'deras': TheirsNounProd;
grammar possessiveNounPhrase(yours): 'din' : YoursNounProd;
grammar possessiveNounPhrase(mine): 'min' : MineNounProd;

/*
//FIXME: Runtime error: wrong number of arguments 
>x stol
Vilket stol menar du, din stol, eller professorns stol?


>min
[Runtime error: wrong number of arguments
]
*/



grammar possessiveNounPhrase(npApostropheS):
    ('den' | )
    (nounPhrase->np_ tokApostropheS->apost_
     | pluralPhrase->np (tokApostropheS->apost_ | tokPluralApostrophe->apost_))
    : LayeredNounPhraseProd

    /* get the original text without the "'s" suffix */
    getOrigMainText()
    {
        /* return just the basic noun phrase part */
        return np_.getOrigText();
    }
;


/* ------------------------------------------------------------------------ */
/*
 *   Simple plural phrase.  This is the most basic plural phrase, which is
 *   simply a plural noun, optionally preceded by one or more adjectives.
 *   
 *   (English doesn't have any sort of adjective declension in number, so
 *   there's no need to distinguish between plural and singular adjectives;
 *   this equivalent rule in languages with adjective-noun agreement in
 *   number would use plural adjectives here as well as plural nouns.)  
 */
grammar simplePluralPhrase(plural): plural->plural_ : NounPhraseWithVocab
    /* generate a list of my resolved objects */
    getVocabMatchList(resolver, results, extraFlags)
    {
        local lst;

        /* get the list of matching plurals */
        lst = getWordMatches(plural_, &plural, resolver,
                             extraFlags, PluralTruncated);

        /* get the list of matching 'noun' definitions */
        local nLst = getWordMatches(plural_, &noun, resolver,
                                    extraFlags, VocabTruncated);

        /* get the combined list */
        local comboLst = combineWordMatches(lst, nLst);

        /*
         *   If we're in global scope, add in the matches for just plain
         *   'noun' properties as well.  This is important because we'll
         *   sometimes want to define a word that's actually a plural
         *   usage (in terms of the real-world English) under the 'noun'
         *   property.  This occurs particularly when a single game-world
         *   object represents a multiplicity of real-world objects.  When
         *   the scope is global, it's hard to anticipate all of the
         *   possible interactions with vocabulary along these lines, so
         *   it's easiest just to include the 'noun' matches.
         */
        if (resolver.isGlobalScope)
        {
            /* keep the combined list */
            lst = comboLst;
        }
        else if (comboLst.length() > lst.length())
        {
            /*
             *   ordinary scope, so don't include the noun matches; but
             *   since we found extra items to add, at least mark the
             *   plural matches as potentially ambiguous
             */
            lst.forEach({x: x.flags_ |= UnclearDisambig});
        }

        /* return the result list */
        return lst;
    }
    getAdjustedTokens()
    {
        return [plural_, &plural];
    }
;

grammar simplePluralPhrase(adj): adjWord->adj_ simplePluralPhrase->np_ :
    NounPhraseWithVocab

    /* resolve my object list */
    getVocabMatchList(resolver, results, extraFlags)
    {
        /*
         *   return the list of objects in scope matching our adjective
         *   plus the list from the underlying noun phrase
         */
        return intersectNounLists(
            adj_.getVocabMatchList(resolver, results, extraFlags),
            np_.getVocabMatchList(resolver, results, extraFlags));
    }
    getAdjustedTokens()
    {
        return adj_.getAdjustedTokens() + np_.getAdjustedTokens();
    }
;

grammar simplePluralPhrase(poundNum):
    poundNumberPhrase->num_ simplePluralPhrase->np_
    : NounPhraseWithVocab

    /* resolve my object list */
    getVocabMatchList(resolver, results, extraFlags)
    {
        local baseList;
        local numList;

        /* get the base list for the rest of the phrase */
        baseList = np_.getVocabMatchList(resolver, results, extraFlags);

        /* get the numeric matches, including numeric wildcards */
        numList = getWordMatches(num_.getStrVal(), &adjective,
                                 resolver, extraFlags, VocabTruncated)
                  + getWordMatches('#', &adjective,
                                   resolver, extraFlags, VocabTruncated);

        /* return the intersection of the lists */
        return intersectNounLists(numList, baseList);
    }
    getAdjustedTokens()
    {
        return [num_.getStrVal(), &adjective] + np_.getAdjustedTokens();
    }
;


/*
 * Svenska motsvarigheten till "the red ones", motsvarande: "de röda ena". 
 * Detta "ena" som pronomen känns dock mer talspråkigt/ytters informellt 
 * och är frågan om det ens kommer användas av någon.
 */
grammar simplePluralPhrase(adjAndOnes): adjective->adj_ 'ena'
    : NounPhraseWithVocab
    getVocabMatchList(resolver, results, extraFlags)
    {
        // generate a list of objects matching the adjective 
        return getWordMatches(adj_, &adjective, resolver,
                              extraFlags | EndsWithAdj, VocabTruncated);
    }
    getAdjustedTokens()
    {
        return [adj_, &adjective];
    }
;

/*
 *   If the command has qualifiers that require a plural, but omits
 *   everything else, we can have an empty simple noun phrase.
 */
 grammar simplePluralPhrase(empty): [badness 600] : NounPhraseWithVocab
    getVocabMatchList(resolver, results, extraFlags)
    {
        // we have an empty noun phrase 
        return results.emptyNounPhrase(resolver);
    }
    getAdjustedTokens()
    {
        return [];
    }
;

/*
 *   A simple plural phrase can match unknown words as a last resort.
 */
grammar simplePluralPhrase(misc):
    [badness 300] miscWordList->lst_ : NounPhraseWithVocab
    getVocabMatchList(resolver, results, extraFlags)
    {
        /* get the match list from the underlying list */
        local lst = lst_.getVocabMatchList(resolver, results, extraFlags);

        /*
         *   if there are no matches, note in the results that we have an
         *   arbitrary word list that doesn't correspond to any object
         */
        if (lst == nil || lst.length() == 0)
            results.noteMiscWordList(lst_.getOrigText());

        /* return the vocabulary match list */
        return lst;
    }
    getAdjustedTokens()
    {
        return lst_.getAdjustedTokens();
    }
;


/* ------------------------------------------------------------------------ */
/*
 *   An "adjective phrase" is a phrase made entirely of adjectives.
 */
grammar adjPhrase(adj): adjective->adj_ : AdjPhraseWithVocab
    getVocabMatchList(resolver, results, extraFlags)
    {
        /* note the adjective ending */
        results.noteAdjEnding();

        /* return the match list */
        local lst = getWordMatches(adj_, &adjective, resolver,
                                   extraFlags | EndsWithAdj, VocabTruncated);

        /* if in global scope, also try a noun interpretation */
        if (resolver.isGlobalScope)
            lst = addNounMatchList(lst, resolver, results, extraFlags);

        /* return the result */
        return lst;
    }

    getAdjustedTokens()
    {
        return [adj_, &adjective];
    }
;

grammar adjPhrase(adjAdj): adjective->adj_ adjPhrase->ap_
    : NounPhraseWithVocab
    /* generate a list of my resolved objects */
    getVocabMatchList(resolver, results, extraFlags)
    {
        /*
         *   return the list of objects in scope matching our adjective
         *   plus the list from the underlying adjective phrase
         */
        return intersectWordMatches(
            adj_, &adjective, resolver, extraFlags, VocabTruncated,
            ap_.getVocabMatchList(resolver, results, extraFlags));
    }
    getAdjustedTokens()
    {
        return [adj_, &adjective] + ap_.getAdjustedTokens();
    }
;


/* ------------------------------------------------------------------------ */
/*
 *   A "topic" is a special type of noun phrase used in commands like "ask
 *   <actor> about <topic>."  We define a topic as simply an ordinary
 *   single-noun phrase.  We distinguish this in the grammar to allow games
 *   to add special syntax for these.  
 */
grammar topicPhrase(main): singleNoun->np_ : TopicProd
;

/*
 *   Explicitly match a miscellaneous word list as a topic.
 *
 *   This might seem redundant with the ordinary topicPhrase that accepts a
 *   singleNoun, because singleNoun can match a miscellaneous word list.
 *   The difference is that singleNoun only matches a miscWordList with a
 *   "badness" value, whereas we match a miscWordList here without any
 *   badness.  We want to be more tolerant of unrecognized input in topic
 *   phrases than in ordinary noun phrases, because it's in the nature of
 *   topic phrases to go outside of what's implemented directly in the
 *   simulation model.  At a grammatical level, we don't want to treat
 *   topic phrases that we can resolve to the simulation model any
 *   differently than we treat those we can't resolve, so we must add this
 *   rule to eliminate the badness that singleNoun associated with a
 *   miscWordList match.
 *
 *   Note that we do prefer resolvable noun phrase matches to miscWordList
 *   matches, but we handle this preference with the resolver's scoring
 *   mechanism rather than with badness.
 */
grammar topicPhrase(misc): miscWordList->np_ : TopicProd
   resolveNouns(resolver, results)
   {
       /* note in the results that we have an arbitrary word list */
       results.noteMiscWordList(np_.getOrigText());

       /* inherit the default TopicProd behavior */
       return inherited(resolver, results);
   }
;

/* ------------------------------------------------------------------------ */
/*
 *   A "quoted string" phrase is a literal enclosed in single or double
 *   quotes.
 *
 *   Note that this is a separate production from literalPhrase.  This
 *   production can be used when *only* a quoted string is allowed.  The
 *   literalPhrase production allows both quoted and unquoted text.
 */
grammar quotedStringPhrase(main): tokString->str_ : LiteralProd
    /*
     *   get my string, with the quotes trimmed off (so we return simply
     *   the contents of the string)
     */
    getStringText() { return stripQuotesFrom(str_); }
;

/*
 *   Service routine: strip quotes from a *possibly* quoted string.  If the
 *   string starts with a quote, we'll remove the open quote.  If it starts
 *   with a quote and it ends with a corresponding close quote, we'll
 *   remove that as well.  
 */
stripQuotesFrom(str)
{
    local hasOpen;
    local hasClose;

    /* presume we won't find open or close quotes */
    hasOpen = hasClose = nil;

    /*
     *   Check for quotes.  We'll accept regular ASCII "straight" single
     *   or double quotes, as well as Latin-1 curly single or double
     *   quotes.  The curly quotes must be used in their normal
     */
    if (str.startsWith('\'') || str.startsWith('"'))
    {
        /* single or double quote - check for a matching close quote */
        hasOpen = true;
        hasClose = (str.length() > 2 && str.endsWith(str.substr(1, 1)));
    }
    else if (str.startsWith('`'))
    {
        /* single in-slanted quote - check for either type of close */
        hasOpen = true;
        hasClose = (str.length() > 2
                    && (str.endsWith('`') || str.endsWith('\'')));
    }
    else if (str.startsWith('\u201C'))
    {
        /* it's a curly double quote */
        hasOpen = true;
        hasClose = str.endsWith('\u201D');
    }
    else if (str.startsWith('\u2018'))
    {
        /* it's a curly single quote */
        hasOpen = true;
        hasClose = str.endsWith('\u2019');
    }

    /* trim off the quotes */
    if (hasOpen)
    {
        if (hasClose)
            str = str.substr(2, str.length() - 2);
        else
            str = str.substr(2);
    }

    /* return the modified text */
    return str;
}

/* ------------------------------------------------------------------------ */
/*
 *   A "literal" is essentially any phrase.  This can include a quoted
 *   string, a number, or any set of word tokens.
 */
grammar literalPhrase(string): quotedStringPhrase->str_ : LiteralProd
    getLiteralText(results, action, which)
    {
        /* get the text from our underlying quoted string */
        return str_.getStringText();
    }

    getTentativeLiteralText()
    {
        /*
         *   our result will never change, so our tentative text is the
         *   same as our regular literal text
         */
        return str_.getStringText();
    }

    resolveLiteral(results)
    {
        /* flag the literal text */
        results.noteLiteral(str_.getOrigText());
    }
;

grammar literalPhrase(miscList): miscWordList->misc_ : LiteralProd
    getLiteralText(results, action, which)
    {
        /* get my original text */
        local txt = misc_.getOrigText();

        /*
         *   if our underlying miscWordList has only one token, strip
         *   quotes, in case that token is a quoted string token
         */
        if (misc_.getOrigTokenList().length() == 1)
            txt = stripQuotesFrom(txt);

        /* return the text */
        return txt;
    }

    getTentativeLiteralText()
    {
        /* our regular text is permanent, so simply use it now */
        return misc_.getOrigText();
    }

    resolveLiteral(results)
    {
        /*
         *   note the length of our literal phrase - when we have a choice
         *   of interpretations, we prefer to choose shorter literal
         *   phrases, since this means that we'll have more of our tokens
         *   being fully interpreted rather than bunched into an
         *   uninterpreted literal
         */
        results.noteLiteral(misc_.getOrigText());
    }
;

/*
 *   In case we have a verb grammar rule that calls for a literal phrase,
 *   but the player enters a command with nothing in that slot, match an
 *   empty token list as a last resort.  Since this phrasing has a badness,
 *   we won't match it unless we don't have any better structural match.
 */
grammar literalPhrase(empty): [badness 400]: EmptyLiteralPhraseProd
    resolveLiteral(results) { }
;

/* ------------------------------------------------------------------------ */
/*
 *   An miscellaneous word list is a list of one or more words of any kind:
 *   any word, any integer, or any apostrophe-S token will do.  Note that
 *   known and unknown words can be mixed in an unknown word list; we care
 *   only that the list is made up of tokWord, tokInt, tokApostropheS,
 *   and/or abbreviation-period tokens.
 *
 *   Note that this kind of phrase is often used with a 'badness' value.
 *   However, we don't assign any badness here, because a miscellaneous
 *   word list might be perfectly valid in some contexts; instead, any
 *   productions that include a misc word list should specify badness as
 *   desired.
 */
grammar miscWordList(wordOrNumber):
    tokWord->txt_ | tokInt->txt_ | tokApostropheS->txt_
    | tokPluralApostrophe->txt_
    | tokPoundInt->txt_ | tokString->txt_ | tokAbbrPeriod->txt_
    : NounPhraseWithVocab
    getVocabMatchList(resolver, results, extraFlags)
    {
        /* we don't match anything directly with our vocabulary */
        return [];
    }
    getAdjustedTokens()
    {
        /* our token type is the special miscellaneous word type */
        return [txt_, &miscWord];
    }
;

grammar miscWordList(list):
    (tokWord->txt_ | tokInt->txt_ | tokApostropheS->txt_
     | tokPluralApostrophe->txt_ | tokAbbrPeriod->txt_
     | tokPoundInt->txt_ | tokString->txt_) miscWordList->lst_
    : NounPhraseWithVocab
    getVocabMatchList(resolver, results, extraFlags)
    {
        /* we don't match anything directly with our vocabulary */
        return [];
    }
    getAdjustedTokens()
    {
        /* our token type is the special miscellaneous word type */
        return [txt_, &miscWord] + lst_.getAdjustedTokens();
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   A main disambiguation phrase consists of a disambiguation phrase,
 *   optionally terminated with a period.
 */
grammar mainDisambigPhrase(main):
    disambigPhrase->dp_
    | disambigPhrase->dp_ '.'
    : BasicProd
    resolveNouns(resolver, results)
    {
        return dp_.resolveNouns(resolver, results);
    }
    getResponseList() { return dp_.getResponseList(); }
;

/*
 *   A "disambiguation phrase" is a phrase that answers a disambiguation
 *   question ("which book do you mean...").
 *   
 *   A disambiguation question can be answered with several types of
 *   syntax:
 *   
 *.  all/everything/all of them
 *.  both/both of them
 *.  any/any of them
 *.  <disambig list>
 *.  the <ordinal list> ones
 *.  the former/the latter
 *   
 *   Note that we assign non-zero badness to all of the ordinal
 *   interpretations, so that we will take an actual vocabulary
 *   interpretation instead of an ordinal interpretation whenever possible.
 *   For example, if an object's name is actually "the third button," this
 *   will give us greater affinity for using "third" as an adjective than
 *   as an ordinal in our own list.  
 */
grammar disambigPhrase(all):
    'allt' | 'allting' | 'alla' 'dem' : DisambigProd
    resolveNouns(resolver, results)
    {
        /* they want everything we proposed - return the whole list */
        return removeAmbigFlags(resolver.getAll(self));
    }

    /* there's only me in the response list */
    getResponseList() { return [self]; }
;

grammar disambigPhrase(both): 'båda' | 'båda' 'av' 'dem' : DisambigProd
    resolveNouns(resolver, results)
    {
        /*
         *   they want two items - return the whole list (if it has more
         *   than two items, we'll simply act as though they wanted all of
         *   them)
         */
        return removeAmbigFlags(resolver.getAll(self));
    }

    /* there's only me in the response list */
    getResponseList() { return [self]; }
;

grammar disambigPhrase(any): 'någon' | 'någon' 'av' 'dem' : DisambigProd
    resolveNouns(resolver, results)
    {
        local lst;

        /* they want any item - arbitrarily pick the first one */
        lst = resolver.matchList.sublist(1, 1);

        /*
         *   add the "unclear disambiguation" flag to the item we picked,
         *   to indicate that the selection was arbitrary
         */
        if (lst.length() > 0)
            lst[1].flags_ |= UnclearDisambig;

        /* return the result */
        return lst;
    }

    /* there's only me in the response list */
    getResponseList() { return [self]; }
;

grammar disambigPhrase(list): disambigList->lst_ : DisambigProd
    resolveNouns(resolver, results)
    {
        return removeAmbigFlags(lst_.resolveNouns(resolver, results));
    }

    /* there's only me in the response list */
    getResponseList() { return lst_.getResponseList(); }
;

/*
(NOTE: Ser inte riktigt behovet av den svenska motsvarigheten ännu)
grammar disambigPhrase(ordinalList):
    disambigOrdinalList->lst_ 'ones'
    | 'the' disambigOrdinalList->lst_ 'ones'
    : DisambigProd

    resolveNouns(resolver, results)
    {
        // return the list with the ambiguity flags removed
        return removeAmbigFlags(lst_.resolveNouns(resolver, results));
    }

    //the response list consists of my single ordinal list item
    getResponseList() { return [lst_]; }
;
*/

/*
 *   A disambig list consists of one or more disambig list items, connected
 *   by noun phrase conjunctions.  
 */
grammar disambigList(single): disambigListItem->item_ : DisambigProd
    resolveNouns(resolver, results)
    {
        return item_.resolveNouns(resolver, results);
    }

    /* the response list consists of my single item */
    getResponseList() { return [item_]; }
;

grammar disambigList(list):
    disambigListItem->item_ commandOrNounConjunction disambigList->lst_
    : DisambigProd

    resolveNouns(resolver, results)
    {
        return item_.resolveNouns(resolver, results)
            + lst_.resolveNouns(resolver, results);
    }

    /* my response list consists of each of our list items */
    getResponseList() { return [item_] + lst_.getResponseList(); }
;

/*
 *   Base class for ordinal disambiguation items
 */
class DisambigOrdProd: DisambigProd
    resolveNouns(resolver, results)
    {
        /* note the ordinal match */
        results.noteDisambigOrdinal();

        /* select the result by the ordinal */
        return selectByOrdinal(ord_, resolver, results);
    }

    selectByOrdinal(ordTok, resolver, results)
    {
        local idx;
        local matchList = resolver.ordinalMatchList;

        /*
         *   look up the meaning of the ordinal word (note that we assume
         *   that each ordinalWord is unique, since we only create one of
         *   each)
         */
        idx = cmdDict.findWord(ordTok, &ordinalWord)[1].numval;

        /*
         *   if it's the special value -1, it indicates that we should
         *   select the *last* item in the list
         */
        if (idx == -1)
            idx = matchList.length();

        /* if it's outside the limits of the match list, it's an error */
        if (idx > matchList.length())
        {
            /* note the problem */
            results.noteOrdinalOutOfRange(ordTok);

            /* no results */
            return [];
        }

        /* return the selected item as a one-item list */
        return matchList.sublist(idx, 1);
    }
;

/*
 *   A disambig vocab production is the base class for disambiguation
 *   phrases that involve vocabulary words.
 */
class DisambigVocabProd: DisambigProd
;

/*
 *   A disambig list item consists of:
 *
 *.  first/second/etc
 *.  the first/second/etc
 *.  first one/second one/etc
 *.  the first one/the second one/etc
 *.  <compound noun phrase>
 *.  possessive
 */

grammar disambigListItem(ordinal):
    ordinalWord->ord_
    | ordinalWord->ord_ 'av' 'dem'
    | ('den'|'det') ordinalWord->ord_
    | ('den'|'det') ordinalWord->ord_ 'av' 'dem'
    : DisambigOrdProd
;

grammar disambigListItem(noun):
    completeNounPhraseWithoutAll->np_
    | terminalNounPhrase->np_
    : DisambigVocabProd
    resolveNouns(resolver, results)
    {
        /* get the matches for the underlying noun phrase */
        local lst = np_.resolveNouns(resolver, results);

        /* note the matches */
        results.noteMatches(lst);

        /* return the match list */
        return lst;
    }
;

grammar disambigListItem(plural):
    pluralPhrase->np_
    : DisambigVocabProd
    resolveNouns(resolver, results)
    {
        local lst;

        /*
         *   get the underlying match list; since we explicitly have a
         *   plural, the result doesn't need to be unique, so simply
         *   return everything we find
         */
        lst = np_.resolveNouns(resolver, results);

        /*
         *   if we didn't get anything, it's an error; otherwise, take
         *   everything, since we explicitly wanted a plural usage
         */
        if (lst.length() == 0)
            results.noMatch(resolver.getAction(), np_.getOrigText());
        else
            results.noteMatches(lst);

        /* return the list */
        return lst;
    }
;

grammar disambigListItem(possessive): possessiveNounPhrase->poss_
    : DisambigPossessiveProd
;

/*
 *   A disambig ordinal list consists of two or more ordinal words
 *   separated by noun phrase conjunctions.  Note that there is a minimum
 *   of two entries in the list.
 */
grammar disambigOrdinalList(tail):
    ordinalWord->ord1_ ('och' | ',') ordinalWord->ord2_ : DisambigOrdProd
    resolveNouns(resolver, results)
    {
        /* note the pair of ordinal matches */
        results.noteDisambigOrdinal();
        results.noteDisambigOrdinal();

        /* combine the selections of our two ordinals */
        return selectByOrdinal(ord1_, resolver, results)
            + selectByOrdinal(ord2_, resolver, results);
    }
;

grammar disambigOrdinalList(head):
    ordinalWord->ord_ ('och' | ',') disambigOrdinalList->lst_
    : DisambigOrdProd
    resolveNouns(resolver, results)
    {
        /* note the ordinal match */
        results.noteDisambigOrdinal();

        /* combine the selections of our ordinal and the sublist */
        return selectByOrdinal(ord_, resolver, results)
            + lst_.resolveNouns(resolver, results);
    }
;


/* ------------------------------------------------------------------------ */
/*
 *   Ordinal words.  We define a limited set of these, since we only use
 *   them in a few special contexts where it would be unreasonable to need
 *   even as many as define here.
 */
#define defOrdinal(str, val) object ordinalWord=#@str numval=val

//defOrdinal(former, 1);
defOrdinal(förra, 1);

defOrdinal(första, 1);
defOrdinal(andra, 2);
defOrdinal(tredje, 3);
defOrdinal(fjärde, 4);
defOrdinal(femte, 5);
defOrdinal(sjätte, 6);
defOrdinal(sjunde, 7);
defOrdinal(åttonde, 8);
defOrdinal(nionde, 9);
defOrdinal(tionde, 10);
defOrdinal(elfte, 11);
defOrdinal(tolfte, 12);
defOrdinal(trettonde, 13);
defOrdinal(fjortonde, 14);
defOrdinal(femtonde, 15);
defOrdinal(sextonde, 16);
defOrdinal(sjuttonde, 17);
defOrdinal(artonde, 18);
defOrdinal(nittonde, 19);
defOrdinal(tjugonde, 20);
defOrdinal(1a, 1);
defOrdinal(2a, 2);
defOrdinal(3e, 3);
defOrdinal(4e, 4);
defOrdinal(5e, 5);
defOrdinal(6e, 6);
defOrdinal(7e, 7);
defOrdinal(8e, 8);
defOrdinal(9e, 9);
defOrdinal(10e, 10);
defOrdinal(11e, 11);
defOrdinal(12e, 12);
defOrdinal(13e, 13);
defOrdinal(14e, 14);
defOrdinal(15e, 15);
defOrdinal(16e, 16);
defOrdinal(17e, 17);
defOrdinal(18e, 18);
defOrdinal(19e, 19);
defOrdinal(20e, 20);

/*
 *   the special 'last' ordinal - the value -1 is special to indicate the
 *   last item in a list
 */
//defOrdinal(last, -1);
//defOrdinal(latter, -1);
defOrdinal(sista, -1);
defOrdinal(senare, -1);


/* ------------------------------------------------------------------------ */
/*
 *   A numeric production.  These can be either spelled-out numbers (such
 *   as "fifty-seven") or numbers entered in digit form (as in "57").
 */
class NumberProd: BasicProd
    /* get the numeric (integer) value */
    getval() { return 0; }

    /*
     *   Get the string version of the numeric value.  This should return
     *   a string, but the string should be in digit form.  If the
     *   original entry was in digit form, then the original entry should
     *   be returned; otherwise, a string should be constructed from the
     *   integer value.  By default, we'll do the latter.
     */
    getStrVal() { return toString(getval()); }
;

/*
 *   A quantifier is simply a number, entered with numerals or spelled out.
 */
grammar numberPhrase(digits): tokInt->num_ : NumberProd
    /* get the numeric value */
    getval() { return toInteger(num_); }

    /*
     *   get the string version of the numeric value - since the token was
     *   an integer to start with, return the actual integer value
     */
    getStrVal() { return num_; }
;

grammar numberPhrase(spelled): spelledNumber->num_ : NumberProd
    /* get the numeric value */
    getval() { return num_.getval(); }
;

/*
 *   A number phrase preceded by a pound sign.  We distinguish this kind of
 *   number phrase from plain numbers, since this kind has a somewhat more
 *   limited set of valid contexts.  
 */
grammar poundNumberPhrase(main): tokPoundInt->num_ : NumberProd
    /*
     *   get the numeric value - a tokPoundInt token has a pound sign
     *   followed by digits, so the numeric value is the value of the
     *   substring following the '#' sign
     */
    getval() { return toInteger(num_.substr(2)); }

    /*
     *   get the string value - we have a number token following the '#',
     *   so simply return the part after the '#'
     */
    getStrVal() { return num_.substr(2); }
;


/*
 *   Number literals.  We'll define a set of special objects for numbers:
 *   each object defines a number and a value for the number.
 */
#define defDigit(num, val) object digitWord=#@num numval=val
#define defTeen(num, val)  object teenWord=#@num numval=val
#define defTens(num, val)  object tensWord=#@num numval=val

defDigit(en, 1);
defDigit(två, 2);
defDigit(tre, 3);
defDigit(fyra, 4);
defDigit(fem, 5);
defDigit(sex, 6);
defDigit(sju, 7);
defDigit(åtta, 8);
defDigit(nio, 9);
defTeen(tio, 10);
defTeen(elva, 11);
defTeen(tolv, 12);
defTeen(tretton, 13);
defTeen(fjorton, 14);
defTeen(femton, 15);
defTeen(sexton, 16);
defTeen(sjutton, 17);
defTeen(arton, 18);
defTeen(nitton, 19);
defTens(tjugo, 20);
defTens(trettio, 30);
defTens(fyrtio, 40);
defTens(femtio, 50);
defTens(sextio, 60);
defTens(sjuttio, 70);
defTens(åttio, 80);
defTens(nittio, 90);

grammar spelledSmallNumber(digit): digitWord->num_ : NumberProd
    getval()
    {
        /*
         *   Look up the units word - there should be only one in the
         *   dictionary, since these are our special words.  Return the
         *   object's numeric value property 'numval', which gives the
         *   number for the name.
         */
        return cmdDict.findWord(num_, &digitWord)[1].numval;
    }
;

grammar spelledSmallNumber(teen): teenWord->num_ : NumberProd
    getval()
    {
        /* look up the dictionary word for the number */
        return cmdDict.findWord(num_, &teenWord)[1].numval;
    }
;

grammar spelledSmallNumber(tens): tensWord->num_ : NumberProd
    getval()
    {
        /* look up the dictionary word for the number */
        return cmdDict.findWord(num_, &tensWord)[1].numval;
    }
;

grammar spelledSmallNumber(tensAndUnits):
    tensWord->tens_ '-'->sep_ digitWord->units_
    | tensWord->tens_ digitWord->units_
    : NumberProd
    getval()
    {
        /* look up the words, and add up the values */
        return cmdDict.findWord(tens_, &tensWord)[1].numval
            + cmdDict.findWord(units_, &digitWord)[1].numval;
    }
;

grammar spelledSmallNumber(zero): 'noll' : NumberProd
    getval() { return 0; }
;

grammar spelledHundred(small): spelledSmallNumber->num_ : NumberProd
    getval() { return num_.getval(); }
;

grammar spelledHundred(hundreds): spelledSmallNumber->hun_ 'hundra'
    : NumberProd
    getval() { return hun_.getval() * 100; }
;

grammar spelledHundred(hundredsPlus):
    spelledSmallNumber->hun_ 'hundra' spelledSmallNumber->num_
    | spelledSmallNumber->hun_ 'hundra' 'och'->and_ spelledSmallNumber->num_
    : NumberProd
    getval() { return hun_.getval() * 100 + num_.getval(); }
;

grammar spelledHundred(aHundred): 'ett' 'hundra' : NumberProd
    getval() { return 100; }
;

grammar spelledHundred(aHundredPlus):
    'ett' 'hundra' 'och' spelledSmallNumber->num_
    : NumberProd
    getval() { return 100 + num_.getval(); }
;

grammar spelledThousand(thousands): spelledHundred->thou_ 'tusen'
    : NumberProd
    getval() { return thou_.getval() * 1000; }
;

grammar spelledThousand(thousandsPlus):
    spelledHundred->thou_ 'tusen' spelledHundred->num_
    : NumberProd
    getval() { return thou_.getval() * 1000 + num_.getval(); }
;

grammar spelledThousand(thousandsAndSmall):
    spelledHundred->thou_ 'tusen' 'och' spelledSmallNumber->num_
    : NumberProd
    getval() { return thou_.getval() * 1000 + num_.getval(); }
;

grammar spelledThousand(aThousand): 'ett' 'tusen' : NumberProd
    getval() { return 1000; }
;

grammar spelledThousand(aThousandAndSmall):
    'ett' 'tusen' 'och' spelledSmallNumber->num_
    : NumberProd
    getval() { return 1000 + num_.getval(); }
;

grammar spelledMillion(millions): spelledHundred->mil_ 'miljon': NumberProd
    getval() { return mil_.getval() * 1000000; }
;

grammar spelledMillion(millionsPlus):
    spelledHundred->mil_ 'miljon'
    (spelledThousand->nxt_ | spelledHundred->nxt_)
    : NumberProd
    getval() { return mil_.getval() * 1000000 + nxt_.getval(); }
;

grammar spelledMillion(aMillion): 'en' 'miljon' : NumberProd
    getval() { return 1000000; }
;

grammar spelledMillion(aMillionAndSmall):
    'en' 'miljon' 'och' spelledSmallNumber->num_
    : NumberProd
    getval() { return 1000000 + num_.getval(); }
;

grammar spelledMillion(millionsAndSmall):
    spelledHundred->mil_ 'miljon' 'och' spelledSmallNumber->num_
    : NumberProd
    getval() { return mil_.getval() * 1000000 + num_.getval(); }
;

grammar spelledNumber(main):
    spelledHundred->num_
    | spelledThousand->num_
    | spelledMillion->num_
    : NumberProd
    getval() { return num_.getval(); }
;


/* ------------------------------------------------------------------------ */
/*
 *   "OOPS" command syntax
 */
grammar oopsCommand(main):
    oopsPhrase->oops_ | oopsPhrase->oops_ '.' : BasicProd
    getNewTokens() { return oops_.getNewTokens(); }
;

grammar oopsPhrase(main):
    'oj' miscWordList->lst_
    | 'oj' ',' miscWordList->lst_
    | 'o' miscWordList->lst_
    | 'o' ',' miscWordList->lst_
    : BasicProd
    getNewTokens() { return lst_.getOrigTokenList(); }
;

grammar oopsPhrase(missing):
    'oj' | 'o'
    : BasicProd
    getNewTokens() { return nil; }
;

/* ------------------------------------------------------------------------ */
/*
 *   finishGame options.  We provide descriptions and keywords for the
 *   option objects here, because these are inherently language-specific.
 *   
 *   Note that we provide hyperlinks for our descriptions when possible.
 *   When we're in plain text mode, we can't show links, so we'll instead
 *   show an alternate form with the single-letter response highlighted in
 *   the text.  We don't highlight the single-letter response in the
 *   hyperlinked version because (a) if the user wants a shortcut, they can
 *   simply click the hyperlink, and (b) most UI's that show hyperlinks
 *   show a distinctive appearance for the hyperlink itself, so adding even
 *   more highlighting within the hyperlink starts to look awfully busy.  
 */
modify finishOptionQuit
    desc = "<<aHrefAlt('avsluta', 'AVSLUTA', '<b>A</b>VSLUTA', 'Lämna berättelsen')>>"
    responseKeyword = 'avsluta'
    responseChar = 'a'
;

modify finishOptionRestore
    desc = "<<aHrefAlt('ladda', 'LADDA', '<b>L</b>ADDA',
            'Ladda en sparad position')>> en sparad position"
    responseKeyword = 'ladda'
    responseChar = 'l'
;

modify finishOptionRestart
    desc = "<<aHrefAlt('starta om', 'START', '<b>S</b>TARTA OM',
            'Starta om spelet från början')>> spelet"
    responseKeyword = 'starta om'
    responseChar = 's'
;

modify finishOptionUndo
    desc = "<<aHrefAlt('ångra', 'ÅNGRA', '<b>Å</b>NGRA',
            'Ångra senaste draget')>> det senaste draget"
    responseKeyword = 'ångra'
    responseChar = 'å'
;

modify finishOptionCredits
    desc = "Se <<aHrefAlt('omnämnanden', 'OMNÄMNDANDEN', '<b>O</b>MNÄMNDANDEN',
            'Visa omnämnanden')>>"
    responseKeyword = 'omnämnanden'
    responseChar = 'o'
;

modify finishOptionFullScore
    desc = "Se <<aHrefAlt('fullständiga poäng', 'FULLSTÄNDIG POÄNG',
            '<b>F</b>ULLSTÄNDIG POÄNG', 'Visa fullständig poäng')>>"
    responseKeyword = 'fullständig poäng'
    responseChar = 'f'
;

modify finishOptionAmusing
    desc = "se några <<aHrefAlt('roande', 'ROANDE', '<b>R</b>OANDE',
            'Se några roande saker att testa')>> saker att testa"
    responseKeyword = 'roande'
    responseChar = 'r'
;

modify restoreOptionStartOver
    desc = "<<aHrefAlt('starta', 'STARTA', '<b>S</b>TARTA',
            'Starta spelet från början')>> spelet från början"
    responseKeyword = 'starta'
    responseChar = 's'
;

modify restoreOptionRestoreAnother
    desc = "<<aHrefAlt('ladda', 'LADDA', '<b>L</b>ADDA',
            'Ladda en sparad position')>> en annan sparad position"
;

/* ------------------------------------------------------------------------ */
/*
 *   Context for Action.getVerbPhrase().  This keeps track of pronoun
 *   antecedents in cases where we're stringing together a series of verb
 *   phrases.
 */
class GetVerbPhraseContext: object
    /* get the objective form of an object, using a pronoun as appropriate */
    objNameObj(obj)
    {
        /*
         *   if it's the pronoun antecedent, use the pronoun form;
         *   otherwise, use the full name
         */
        if (obj == pronounObj)
            return obj.itObj;
        else
            return obj.theNameObj;
    }

    /* are we showing the given object pronomially? */
    isObjPronoun(obj) { return (obj == pronounObj); }

    /* set the pronoun antecedent */
    setPronounObj(obj) { pronounObj = obj; }

    /* the pronoun antecedent */
    pronounObj = nil
;

/*
 *   Default getVerbPhrase context.  This can be used when no other context
 *   is needed.  This context instance has no state - it doesn't track any
 *   antecedents.  
 */
defaultGetVerbPhraseContext: GetVerbPhraseContext
    /* we don't remember any antecedents */
    setPronounObj(obj) { }
;

/* ------------------------------------------------------------------------ */
/*
 *   Implicit action context.  This is passed to the message methods that
 *   generate implicit action announcements, to indicate the context in
 *   which the message is to be used.
 */
class ImplicitAnnouncementContext: object
    /*
     *   Should we use the infinitive form of the verb, or the active
     *   form for generating the announcement?  By default, use use the
     *   active form: "(ÖPPNAR LÅDAN först)".
     */

    useInfPhrase = nil

    /* is this message going in a list? */
    isInList = nil

    /*
     *   Are we in a sublist of 'just trying' or 'just asking' messages?
     *   (We can only have sublist groupings one level deep, so we don't
     *   need to worry om vad kind of sublist we're in.)
     */
    isInSublist = nil

    /* our getVerbPhrase context - by default, don't use one */
    getVerbCtx = nil

    /* generate the announcement message given the action description */
    buildImplicitAnnouncement(txt)
    {
        /* if we're not in a list, make it a full, stand-alone message */
        if (!isInList) {
            txt = '<./p0>\n<.assume>' + txt + ' först<./assume>\n';
        }

        /* return the result */
        return txt;
    }
;

/* the standard implicit action announcement context */
standardImpCtx: ImplicitAnnouncementContext;

/* the "just trying" implicit action announcement context */
tryingImpCtx: ImplicitAnnouncementContext
    /*
     *   The action was merely attempted, so use the infinitive phrase in
     *   the announcement: "(first trying to OPEN THE BOX)".
     */
    useInfPhrase = true

    /* build the announcement */
    buildImplicitAnnouncement(txt)
    {
        /*
         *   If we're not in a list of 'trying' messages, add the 'trying'
         *   prefix message to the action description.  This isn't
         *   necessary if we're in a 'trying' list, since the list itself
         *   will have the 'trying' part.
         */
        if (!isInSublist) {
            txt = 'försöker ' + txt;
        }

        /* now build the message into the full text as usual */
        return inherited(txt);
    }
;

/*
 *   The "asking question" implicit action announcement context.  By
 *   default, we generate the message exactly the same way we do for the
 *   'trying' case.
 */
askingImpCtx: tryingImpCtx;

/*
 *   A class for messages appearing in a list.  Within a list, we want to
 *   keep track of the last direct object, so that we can refer to it with
 *   a pronoun later in the list.
 */
class ListImpCtx: ImplicitAnnouncementContext, GetVerbPhraseContext
    /*
     *   Set the appropriate base context for the given implicit action
     *   announcement report (an ImplicitActionAnnouncement object).
     */
    setBaseCtx(ctx)
    {
        /*
         *   if this is a failed attempt, use a 'trying' context;
         *   otherwise, use a standard context
         */
        if (ctx.justTrying)
            baseCtx = tryingImpCtx;
        else if (ctx.justAsking)
            baseCtx = askingImpCtx;
        else
            baseCtx = standardImpCtx;
    }

    /* we're in a list */
    isInList = true

    /* we are our own getVerbPhrase context */
    getVerbCtx = (self)

    /* delegate the phrase format to our underlying announcement context */
    useInfPhrase = (delegated baseCtx)

    /* build the announcement using our underlying context */
    buildImplicitAnnouncement(txt) { 
        return delegated baseCtx(txt); }

    /* our base context - we delegate some unoverridden behavior to this */
    baseCtx = nil
;

/* ------------------------------------------------------------------------ */
/*
 *   Language-specific Action modifications.
 */
modify Action
    /*
     *   In the English grammar, all 'predicate' grammar definitions
     *   (which are usually made via the VerbRule macro) are associated
     *   with Action match tree objects; in fact, each 'predicate' grammar
     *   match tree is the specific Action subclass associated with the
     *   grammar for the predicate.  This means that the Action associated
     *   with a grammar match is simply the grammar match object itself.
     *   Hence, we can resolve the action for a 'predicate' match simply
     *   by returning the match itself: it is the Action as well as the
     *   grammar match.
     *
     *   This approach ('grammar predicate' matches are based on Action
     *   subclasses) works well for languages like English that encode the
     *   role of each phrase in the word order of the sentence.
     *
     *   Languages that encode phrase roles using case markers or other
     *   devices tend to be freer with word order.  As a result,
     *   'predicate' grammars for such languages should generally not
     *   attempt to capture all possible word orderings for a given
     *   action, but should instead take the complementary approach of
     *   capturing the possible overall sentence structures independently
     *   of verb phrases, and plug in a verb phrase as a component, just
     *   like noun phrases plug into the English grammar.  In these cases,
     *   the match objects will NOT be Action subclasses; the Action
     *   objects will instead be buried down deeper in the match tree.
     *   Hence, resolveAction() must be defined on whatever class is used
     *   to construct 'predicate' grammar matches, instead of on Action,
     *   since Action will not be a 'predicate' match.
     */
    resolveAction(issuingActor, targetActor) { return self; }

    /*
     *   Return the interrogative pronoun for a missing object in one of
     *   our object roles.  In most cases, this is simply "what", but for
     *   some actions, "whom" is more appropriate (for example, the direct
     *   object of "ask" is implicitly a person, so "whom" is most
     *   appropriate for this role).
     */
    whatObj(which)
    {
        /* intransitive verbs have no objects, so there's nothing to show */
    }

    /*
     *   Translate an interrogative word for whatObj.  If the word is
     *   'whom', translate to the library message for 'whom'; this allows
     *   authors to use 'who' rather than 'whom' as the objective form of
     *   'who', which sounds less stuffy to many people.
     */
    whatTranslate(txt)
    {
        /*
         *   if it's 'whom', translate to the library message for 'whom';
         *   otherwise, just show the word as is
         */
        return (txt == 'whom' ? gLibMessages.whomPronoun : txt);
    }

    /*
     *   Return a string with the appropriate pronoun (objective form) for
     *   a list of object matches, with the given resolved cardinality.
     *   This list is a list of ResolveInfo objects.
     */
    objListPronoun(objList)
    {
        local himCnt, herCnt, themCnt;
        local FirstPersonCnt, SecondPersonCnt;
        local resolvedNumber;

        /* if there's no object list at all, just use 'it' */
        if (objList == nil || objList == []) {
            //return 'it';
            return isNeuter? 'det' : 'den';
        }

        /* note the number of objects in the resolved list */
        resolvedNumber = objList.length();

        /*
         *   In the tentatively resolved object list, we might have hidden
         *   away ambiguous matches.  Expand those back into the list so
         *   we have the full list of in-scope matches.
         */
        foreach (local cur in objList)
        {
            /*
             *   if this one has hidden ambiguous objects, add the hidden
             *   objects back into our list
             */
            if (cur.extraObjects != nil)
                objList += cur.extraObjects;
        }

        /*
         *   if the desired cardinality is plural and the object list has
         *   more than one object, simply say 'them'
         */
        if (objList.length() > 1 && resolvedNumber > 1)
            return 'de';

        /*
         *   singular cardinality - count masculine and feminine objects,
         *   and count the referral persons
         */
        himCnt = herCnt = themCnt = 0;
        FirstPersonCnt = SecondPersonCnt = 0;
        foreach (local cur in objList)
        {
            /* if it's masculine, count it */
            if (cur.obj_.isHim)
                ++himCnt;

            /* if it's feminine, count it */
            if (cur.obj_.isHer)
                ++herCnt;

            /* if it has plural usage, count it */
            if (cur.obj_.isPlural)
                ++themCnt;

            /* if it's first person usage, count it */
            if (cur.obj_.referralPerson == FirstPerson)
                ++FirstPersonCnt;

            /* if it's second person usage, count it */
            if (cur.obj_.referralPerson == SecondPerson)
                ++SecondPersonCnt;

            /* if it's second person usage, count it */
            if (cur.obj_.referralPerson == SecondPerson)
                ++SecondPersonCnt;

        }

        /*
         *   if they all have plural usage, show "them"; if they're all of
         *   one gender, show "him" or "her" as appropriate; if they're
         *   all neuter, show "it"; otherwise, show "them"
         */
        if (themCnt == objList.length())
            return 'dem';
        else if (FirstPersonCnt == objList.length())
            return 'mig själv';
        else if (SecondPersonCnt == objList.length())
            return 'du själv';
        else if (himCnt == objList.length() && herCnt == 0)
            return 'honom';
        else if (herCnt == objList.length() && himCnt == 0)
            return 'henne';
        else if (herCnt == 0 && himCnt == 0) {
            return (objList[1].obj_.isNeuter)?'det':'den';
        }
        else
            return 'dem';
    }

    /*
     *   Announce a default object used with this action.
     *
     *   'resolvedAllObjects' indicates where we are in the command
     *   processing: this is true if we've already resolved all of the
     *   other objects in the command, nil if not.  We use this
     *   information to get the phrasing right according to the situation.
     */
    announceDefaultObject(obj, whichObj, resolvedAllObjects)
    {
        /*
         *   the basic action class takes no objects, so there can be no
         *   default announcement
         */
        return '';
    }

    /*
     *   Announce all defaulted objects in the action.  By default, we
     *   show nothing.
     */
    announceAllDefaultObjects(allResolved) { }

    /*
     *   Returnera en fras som beskriver den implicita handlingen som en
     *   aktiv fras. 'ctx' är ett ImplicitAnnouncementContext-objekt
     *   som beskriver sammanhanget i vilket vi genererar frasen.
     *
     *   Detta kommer i två former: om kontexten indikerar att vi bara
     *   försöker utföra handlingen, kommer vi att returnera en infinitivfras 
     *   ("öppna lådan") för användning i en större aktiv fras som beskriver
     *   försöket ("försöker..."). Annars kommer vi att beskriva
     *   handlingen som ett faktiskt utförande, så vi returnerar en
     *   aktiv presensform ("öppnar lådan"). 
     * 
     *   OBS: Detta skiljer sig från den engelska versionen, där participformen (t ex: "öppnandet") 
     *   används istället för den aktiva formen. Anledningen till detta är att svenska meningar 
     *   inte låter välformulerade när man använder particip på detta sätt som engelska
     *   meningar gör.
     */
    getImplicitPhrase(ctx)
    {
        /*
         *   Get the phrase.  Use the infinitive or active form, as
         *   indicated in the context.
         */
        local x = getVerbPhrase(ctx.useInfPhrase, ctx.getVerbCtx);
        return x;
    }

    /*
     *   Get the infinitive form of the action.  We are NOT to include the
     *   infinitive complementizer (i.e., "to") as part of the result,
     *   since the complementizer isn't used in all contexts in which we
     *   might want to use the infinitive; for example, we don't want a
     *   "to" in phrases involving an auxiliary verb, such as "he can open
     *   the box."
     */
    getInfPhrase()
    {
        /* return the verb phrase in infinitive form */
        return getVerbPhrase(true, nil);
    }

    /*
     *   Get the root infinitive form of our verb phrase as part of a
     *   question in which one of the verb's objects is the "unknown" of
     *   the interrogative.  'which' is one of the role markers
     *   (DirectObject, IndirectObject, etc), indicating which object is
     *   the subject of the interrogative.
     *
     *   For example, for the verb UNLOCK <dobj> WITH <iobj>, if the
     *   unknown is the direct object, the phrase we'd return would be
     *   "unlock": this would plug into contexts such as "what do you want
     *   to unlock."  If the indirect object is the unknown for the same
     *   verb, the phrase would be "unlock it with", which would plug in as
     *   "what do you want to unlock it with".
     *
     *   Note that we are NOT to include the infinitive complementizer
     *   (i.e., "to") as part of the phrase we generate, since the
     *   complementizer isn't used in some contexts where the infinitive
     *   conjugation is needed (for example, "what should I <infinitive>").
     */
    getQuestionInf(which)
    {
        /*
         *   for a verb without objects, this is the same as the basic
         *   infinitive
         */
        return getInfPhrase();
    }

    /*
     *   Get a string describing the full action in present active
     *   form, using the current command objects: "taking the watch",
     *   "putting the book on the shelf"
     */
    // getParticiplePhrase() - OBSERVERA att denna metod inte används  
    // av språkmodulen så som engelska språkmodulen så därför har den 
    // här bytt namn. För spårbarhetens skull behålls en den gamla 
    // metodens namn här bortkommenterad. 
    // getParticiplePhrase kan komma att behöva användas i svenska 
    // språkmodulen längre fram, men i så fall troligen på ett annat 
    // sätt än som i engelskan. Se getActivePhrase() istället.

    /*
     *   Hämtar en sträng som beskriver hela handlingen i aktiv presensform, 
     *   med de nuvarande kommandoobjekten: "tar klockan",
     *   "stoppar boken på hyllan"

     * Observera att i svenskan finns det ingen bra anledning att använda 
     * engelskans particip-form för att konstruera meningar så som: 
     * "öppnandes dörren" eller "tagandes boken först".
     * (motsvarande "opening the door" eller "first taking the book")
     * 
     * Istället görs här en trade-off till att skapa meningar i aktiv form istället:
     * "öppnar dörren först" eller "tar boken först" osv.
     *
     * Vi lagrar med andra ord i verbPhrase: infinitiv/aktiv-formerna "öppna/öppnar" och "ta/tar" osv.
     */
    getActivePhrase()
    {
        /* return the verb phrase in active form */
        return getVerbPhrase(nil, nil);
    }

    /*
     *   Get the full verb phrase in either infinitive or active
     *   format.  This is a common handler for getInfinitivePhrase() and
     *   getActivePhrase().
     *
     *   'ctx' is a GetVerbPhraseContext object, which lets us keep track
     *   of antecedents when we're stringing together multiple verb
     *   phrases.  'ctx' can be nil if the verb phrase is being used in
     *   isolation.
     */
    getVerbPhrase(inf, ctx)
    {
        /*
        *   parse the verbPhrase into the parts before and after the
        *   slash, and any additional text following the slash part
        */
        rexMatch('(.*)/(<alphanum|-|squote>+)(.*)', verbPhrase);
        /* return the appropriate parts */
        if (inf)
        {
            /*
             *   infinitive - we want the part before the slash, plus the
             *   extra prepositions (or whatever) after the switched part
             */
            return rexGroup(1)[3] + rexGroup(3)[3];
        }
        else
        {
            /* active form - it's the part after the slash */
            return rexGroup(2)[3] + rexGroup(3)[3];
        }
    }

    /*
     *   Show the "noMatch" library message.  For most verbs, we use the
     *   basic "you can't see that here".  Verbs that are mostly used with
     *   intangible objects, such as LISTEN TO and SMELL, might want to
     *   override this to use a less visually-oriented message.
     */
    noMatch(msgObj, actor, txt) { msgObj.noMatchCannotSee(actor, txt); }

    /*
     *   Verb flags - these are used to control certain aspects of verb
     *   formatting.  By default, we have no special flags.
     */
    verbFlags = 0

    /* add a space prefix/suffix to a string if the string is non-empty */
    spPrefix(str) { return (str == '' ? str : ' ' + str); }
    spSuffix(str) { return (str == '' ? str : str + ' '); }
;

/*
 *   English-specific additions for single-object verbs.
 */
modify TAction
    /* return an interrogative word for an object of the action */
    whatObj(which)
    {
        /*
         *   Show the interrogative for our direct object - this is the
         *   last word enclosed in parentheses in our verbPhrase string.
         */
        rexSearch('<lparen>.*?(<alpha>+)<rparen>', verbPhrase);
        return whatTranslate(rexGroup(1)[3]);
    }

    /* announce a default object used with this action */
    announceDefaultObject(obj, whichObj, resolvedAllObjects)
    {
        /*
         *   get any direct object preposition - this is the part inside
         *   the "(vad)" specifier parens, excluding the last word
         */
        rexSearch('<lparen>(.*<space>+)?<alpha>+<rparen>', verbPhrase);
        local prep = (rexGroup(1) == nil ? '' : rexGroup(1)[3]);

        /* do any verb-specific adjustment of the preposition */
        if (prep != nil)
            prep = adjustDefaultObjectPrep(prep, obj);

        /* 
         *   get the object name - we need to distinguish from everything
         *   else in scope, since we considered everything in scope when
         *   making our pick 
         */
        local nm = obj.getAnnouncementDistinguisher(
            gActor.scopeList()).theName(obj);

        /* show the preposition (if any) and the object */
        return (prep == '' ? nm : prep + nm);
    }

    /*
     *   Adjust the preposition.  In some cases, the verb will want to vary
     *   the preposition according to the object.  This method can return a
     *   custom preposition in place of the one in the verbPhrase.  By
     *   default, we just use the fixed preposition from the verbPhrase,
     *   which is passed in to us in 'prep'.  
     */
    adjustDefaultObjectPrep(prep, obj) { return prep; }

    /* announce all defaulted objects */
    announceAllDefaultObjects(allResolved)
    {
        /* announce a defaulted direct object if appropriate */
        maybeAnnounceDefaultObject(dobjList_, DirectObject, allResolved);
    }

    /* show the verb's basic infinitive form for an interrogative */
    getQuestionInf(which)
    {
        /*
         *   Show the present-tense verb form (removing the active form
         *   part - the "/xxxing" part).  Include any prepositions
         *   attached to the verb itself or to the direct object (inside
         *   the "(vad)" parens).
         */
        rexSearch('(.*)/<alphanum|-|squote>+(.*?)<space>+'
                  + '<lparen>(.*?)<space>*?<alpha>+<rparen>',
                  verbPhrase);
        return rexGroup(1)[3] + spPrefix(rexGroup(2)[3])
            + spPrefix(rexGroup(3)[3]);
    }

    /* Hämta verbfrasen i antingen infinitiv eller aktiv form */
    getVerbPhrase(inf, ctx)
    {
        local dobj;
        local dobjText;
        local dobjIsPronoun;
        local ret;

        /* use the default pronoun context if one wasn't supplied */
        if (ctx == nil) {
            ctx = defaultGetVerbPhraseContext;
        }

        /* get the direct object */
        dobj = getDobj();

        /* note if it's a pronoun */
        dobjIsPronoun = ctx.isObjPronoun(dobj);

        /* get the direct object name */
        dobjText = ctx.objNameObj(dobj);




        /* get the phrasing */
        ret = getVerbPhrase1(inf, verbPhrase, dobjText, dobjIsPronoun);

        /* set the pronoun antecedent to my direct object */
        ctx.setPronounObj(dobj);

        /* return the result */
        return ret;
    }

    /*
     *   Given the text of the direct object phrase, build the verb phrase
     *   for a one-object verb.  This is a class method that can be used by
     *   other kinds of verbs (i.e., non-TActions) that use phrasing like a
     *   single object.
     *
     *   'inf' is a flag indicating whether to use the infinitive form
     *   (true) or the active form (nil); 'vp' is the
     *   verbPhrase string; 'dobjText' is the direct object phrase's text;
     *   and 'dobjIsPronoun' is true if the dobj text is rendered as a
     *   pronoun.
     *  
     */
    
    getVerbPhrase1(inf, vp, dobjText, dobjIsPronoun)
    {
        local ret;
        local dprep;
        local vcomp;

        /*
        *   parse the verbPhrase: pick out the 'infinitive/active'
        *   part, the complementizer part up to the '(vad)' direct
        *   object placeholder, and any preposition within the '(vad)'
        *   specifier
        */
        rexMatch('(.*)/(<alphanum|-|squote>+)(.*) '
                + '<lparen>(.*?)<space>*?<alpha>+<rparen>(.*)',
                vp);

        /* start off with the infinitive or active form, as desired */
        if (inf)
            ret = rexGroup(1)[3];
        else
            ret = rexGroup(2)[3];

        /* get the prepositional complementizer */
        vcomp = rexGroup(3)[3];

        /* get the direct object preposition */
        dprep = rexGroup(4)[3];

        /* do any verb-specific adjustment of the preposition */
        if (dprep != nil)
            dprep = adjustDefaultObjectPrep(dprep, getDobj());

        /*
         *   if the direct object is not a pronoun, put the complementizer
         *   BEFORE the direct object (the 'up' in "PICKING UP THE BOX")
         */
        if (!dobjIsPronoun)
            ret += spPrefix(vcomp);

        /* add the direct object preposition */
        ret += spPrefix(dprep);

        /* add the direct object, using the pronoun form if applicable */
        ret += ' ' + dobjText;

        /*
         *   if the direct object is a pronoun, put the complementizer
         *   AFTER the direct object (the 'up' in "PICKING IT UP")
         */
        if (dobjIsPronoun)
            ret += spPrefix(vcomp);

        /*
         *   if there's any suffix following the direct object
         *   placeholder, add it at the end of the phrase
         */
        ret += rexGroup(5)[3];

        /* return the complete phrase string */
        return ret;
    }
;

/*
 *   English-specific additions for two-object verbs.
 */
modify TIAction
    /*
     *   Flag: omit the indirect object in a query for a missing direct
     *   object.  For many verbs, if we already know the indirect object
     *   and we need to ask for the direct object, the query sounds best
     *   when it includes the indirect object: "what do you want to put in
     *   it?"  or "what do you want to take from it?".  This is the
     *   default phrasing.
     *
     *   However, the corresponding query for some verbs sounds weird:
     *   "what do you want to dig in with it?" or "whom do you want to ask
     *   about it?".  For such actions, this property should be set to
     *   true to indicate that the indirect object should be omitted from
     *   the queries, which will change the phrasing to "what do you want
     *   to dig in", "whom do you want to ask", and so on.
     */
    omitIobjInDobjQuery = nil

    /*
     *   For VerbRules: does this verb rule have a prepositional or
     *   structural phrasing of the direct and indirect object slots?  That
     *   is, are the object slots determined by a prepositional marker, or
     *   purely by word order?  For most English verbs with two objects,
     *   the indirect object is marked by a preposition: GIVE BOOK TO BOB,
     *   PUT BOOK IN BOX.  There are a few English verbs that don't include
     *   any prespositional markers for the objects, though, and assign the
     *   noun phrase roles purely by the word order: GIVE BOB BOOK, SHOW
     *   BOB BOOK, THROW BOB BOOK.  We define these phrasings with separate
     *   verb rules, which we mark with this property.
     *
     *   We use this in ranking verb matches.  Non-prepositional verb
     *   structures are especially prone to matching where they shouldn't,
     *   because we can often find a way to pick out words to fill the
     *   slots in the absence of any marker words.  For example, GIVE GREEN
     *   BOOK could be interpreted as GIVE BOOK TO GREEN, where GREEN is
     *   assumed to be an adjective-ending noun phrase; but the player
     *   probably means to give the green book to someone who they assumed
     *   would be filled in as a default.  So, whenever we find an
     *   interpretation that involves a non-prespositional phrasing, we'll
     *   use this flag to know we should be suspicious of it and try
     *   alternative phrasing first.
     *
     *   Most two-object verbs in English use prepositional markers, so
     *   we'll set this as the default.  Individual VerbRules that use
     *   purely structural phrasing should override this.
     */
    isPrepositionalPhrasing = true

    /* resolve noun phrases */
    resolveNouns(issuingActor, targetActor, results)
    {
        /*
         *   If we're a non-prepositional phrasing, it means that we have
         *   the VERB IOBJ DOBJ word ordering (as in GIVE BOB BOX or THROW
         *   BOB COIN).  For grammar match ranking purposes, give these
         *   phrasings a lower match probability when the dobj phrase
         *   doesn't have a clear qualifier.  If the dobj phrase starts
         *   with 'the' or a qualifier word like that (GIVE BOB THE BOX),
         *   then it's pretty clear that the structural phrasing is right
         *   after all; but if there's no qualifier, we could reading too
         *   much into the word order.  We could have something like GIVE
         *   GREEN BOX, where we *could* treat this as two objects, but we
         *   could just as well have a missing indirect object phrase.
         */
        if (!isPrepositionalPhrasing)
        {
            /*
             *   If the direct object phrase starts with 'a', 'an', 'the',
             *   'some', or 'any', the grammar is pretty clearly a good
             *   match for the non-prepositional phrasing.  Otherwise, it's
             *   suspect, so rank it accordingly.
             */
            if (rexMatch('(en|att|den|några|lite|någon)<space>',
                         dobjMatch.getOrigText()) == nil)
            {
                /* note this as weak phrasing level 100 */
                results.noteWeakPhrasing(100);
            }
        }

        /* inherit the base handling */
        inherited(issuingActor, targetActor, results);
    }

    /* get the interrogative for one of our objects */
    whatObj(which)
    {
        switch (which)
        {
        case DirectObject:
            /*
             *   the direct object interrogative is the first word in
             *   parentheses in our verbPhrase string
             */
            rexSearch('<lparen>.*?(<alpha>+)<rparen>', verbPhrase);
            break;

        case IndirectObject:
            /*
             *   the indirect object interrogative is the second
             *   parenthesized word in our verbPhrase string
             */
            rexSearch('<rparen>.*<lparen>.*?(<alpha>+)<rparen>', verbPhrase);
            break;
        }

        /* show the group match */
        return whatTranslate(rexGroup(1)[3]);
    }

    /* announce a default object used with this action */
    announceDefaultObject(obj, whichObj, resolvedAllObjects)
    {
        /* presume we won't have a verb or preposition */
        local verb = '';
        local prep = '';

        /*
         *   Check the full phrasing - if we're showing the direct object,
         *   but an indirect object was supplied, use the verb's
         *   active form ("frågar bob") in the default string, since
         *   we must clarify that we're not tagging the default string on
         *   to the command line.  Don't include the active form if we
         *   don't know all the objects yet, since in this case we are in
         *   fact tagging the default string onto the command so far, as
         *   there's nothing else in the command to get in the way.
         */
        if (whichObj == DirectObject && resolvedAllObjects)
        {
            /*
             *   extract the verb's active form (including any
             *   complementizer phrase)
             */
            rexSearch('/(<^lparen>+) <lparen>', verbPhrase);
            verb = rexGroup(1)[3] + ' ';
        }

        /* get the preposition to use, if any */
        switch(whichObj)
        {
        case DirectObject:
            /* use the preposition in the first "(vad)" phrase */
            rexSearch('<lparen>(.*?)<space>*<alpha>+<rparen>', verbPhrase);
            prep = rexGroup(1)[3];
            break;

        case IndirectObject:
            /* use the preposition in the second "(vad)" phrase */
            rexSearch('<rparen>.*<lparen>(.*?)<space>*<alpha>+<rparen>',
                      verbPhrase);
            prep = rexGroup(1)[3];
            break;
        }

        /* 
         *   get the object name - we need to distinguish from everything
         *   else in scope, since we considered everything in scope when
         *   making our pick 
         */
        local nm = obj.getAnnouncementDistinguisher(
            gActor.scopeList()).theName(obj);

        /* build and return the complete phrase */
        return spSuffix(verb) + spSuffix(prep) + nm;
    }

    /* announce all defaulted objects */
    announceAllDefaultObjects(allResolved)
    {
        /* announce a defaulted direct object if appropriate */
        maybeAnnounceDefaultObject(dobjList_, DirectObject, allResolved);

        /* announce a defaulted indirect object if appropriate */
        maybeAnnounceDefaultObject(iobjList_, IndirectObject, allResolved);
    }

    /* show the verb's basic infinitive form for an interrogative */
    getQuestionInf(which)
    {
        local ret;
        local vcomp;
        local dprep;
        local iprep;
        local pro;

        /*
         *   Our verb phrase can one of three formats, depending on which
         *   object role we're asking about (the part in <angle brackets>
         *   is the part we're responsible for generating).  In these
         *   formats, 'verb' is the verb infinitive; 'comp' is the
         *   complementizer, if any (e.g., the 'up' in 'pick up'); 'dprep'
         *   is the direct object preposition (the 'in' in 'dig in x with
         *   y'); and 'iprep' is the indirect object preposition (the
         *   'med' in 'dig in x with y').
         *
         *   asking for dobj: verb vcomp dprep iprep it ('what do you want
         *   to <open with it>?', '<dig in with it>', '<look up in it>').
         *
         *   asking for dobj, but suppressing the iobj part: verb vcomp
         *   dprep ('what do you want to <turn>?', '<look up>?', '<dig
         *   in>')
         *
         *   asking for iobj: verb dprep it vcomp iprep ('what do you want
         *   to <open it with>', '<dig in it with>', '<look it up in>'
         */

        /* parse the verbPhrase into its component parts */
        rexMatch('(.*)/<alphanum|-|squote>+(?:<space>+(<^lparen>*))?'
                 + '<space>+<lparen>(.*?)<space>*<alpha>+<rparen>'
                 + '<space>+<lparen>(.*?)<space>*<alpha>+<rparen>',
                 verbPhrase);

        /* pull out the verb */
        ret = rexGroup(1)[3];

        /* pull out the verb complementizer */
        vcomp = (rexGroup(2) == nil ? '' : rexGroup(2)[3]);

        /* pull out the direct and indirect object prepositions */
        dprep = rexGroup(3)[3];
        iprep = rexGroup(4)[3];


        /* get the pronoun for the other object phrase */
        pro = getOtherMessageObjectPronoun(which);

        /* check what we're asking about */
        if (which == DirectObject)
        {
            /* add the <vcomp dprep> part in all cases */
            ret += spPrefix(vcomp) + spPrefix(dprep);

            /* add the <iprep it> part if we want the indirect object part */
            if (!omitIobjInDobjQuery && pro != nil)
                ret += spPrefix(iprep) + ' ' + pro;
        }
        else
        {
            /* add the <dprep it> part if appropriate */
            if (pro != nil)
                ret += spPrefix(dprep) + ' ' + pro;

            /* add the <vcomp iprep> part */
            ret += spPrefix(vcomp) + spPrefix(iprep);
        }

        /* return the result */
        return ret;
    }

    /*
     *   Get the pronoun for the message object in the given role.
     */
    getOtherMessageObjectPronoun(which)
    {
        local lst;

        /*
         *   Get the resolution list (or tentative resolution list) for the
         *   *other* object, since we want to show a pronoun representing
         *   the other object.  If we don't have a fully-resolved list for
         *   the other object, use the tentative resolution list, which
         *   we're guaranteed to have by the time we start resolving
         *   anything (and thus by the time we need to ask for objects).
         */
        lst = (which == DirectObject ? iobjList_ : dobjList_);
        if (lst == nil || lst == [])
            lst = (which == DirectObject
                   ? tentativeIobj_ : tentativeDobj_);

        /* if we found an object list, use the pronoun for the list */
        if (lst != nil && lst != [])
        {
            /* we got a list - return a suitable pronoun for this list */
            return objListPronoun(lst);
        }
        else
        {
            /* there's no object list, so there's no pronoun */
            return nil;
        }
    }

    /* get the verb phrase in infinitive or active form */
    getVerbPhrase(inf, ctx)
    {
        local dobj, dobjText, dobjIsPronoun;
        local iobj, iobjText;
        local ret;

        /* use the default context if one wasn't supplied */
        if (ctx == nil)
            ctx = defaultGetVerbPhraseContext;

        /* get the direct object information */
        dobj = getDobj();
        dobjText = ctx.objNameObj(dobj);
        dobjIsPronoun = ctx.isObjPronoun(dobj);

        /* get the indirect object information */
        iobj = getIobj();
        iobjText = (iobj != nil ? ctx.objNameObj(iobj) : nil);

        /* get the phrasing */
        ret = getVerbPhrase2(inf, verbPhrase,
                             dobjText, dobjIsPronoun, iobjText);
        /*
         *   Set the antecedent for the next verb phrase.  Our direct
         *   object is normally the antecedent; however, if the indirect
         *   object matches the current antecedent, keep the current
         *   antecedent, so that 'it' (or whatever) remains the same for
         *   the next verb phrase.
         */
        if (ctx.pronounObj != iobj)
            ctx.setPronounObj(dobj);

        /* return the result */
        return ret;
    }

    /*
     *   Get the verb phrase for a two-object (dobj + iobj) phrasing.  This
     *   is a class method, so that it can be reused by unrelated (i.e.,
     *   non-TIAction) classes that also use two-object syntax but with
     *   other internal structures.  This is the two-object equivalent of
     *   TAction.getVerbPhrase1().
     */
    getVerbPhrase2(inf, vp, dobjText, dobjIsPronoun, iobjText)
    {
        local ret;
        local vcomp;
        local dprep, iprep;

        /* parse the verbPhrase into its component parts */
        rexMatch('(.*)/(<alphanum|-|squote>+)(?:<space>+(<^lparen>*))?'
                 + '<space>+<lparen>(.*?)<space>*<alpha>+<rparen>'
                 + '<space>+<lparen>(.*?)<space>*<alpha>+<rparen>',
                 vp);

        /* start off with the infinitive or active form, as desired */
        if (inf)
            ret = rexGroup(1)[3];
        else
            ret = rexGroup(2)[3];

        /* get the complementizer */
        vcomp = (rexGroup(3) == nil ? '' : rexGroup(3)[3]);

        /* get the direct and indirect object prepositions */
        dprep = rexGroup(4)[3];
        iprep = rexGroup(5)[3];

        /*
         *   add the complementizer BEFORE the direct object, if the
         *   direct object is being shown as a full name ("PICK UP BOX")
         */
        if (!dobjIsPronoun)
            ret += spPrefix(vcomp);

        /*
         *   add the direct object and its preposition, using a pronoun if
         *   applicable
         */
        ret += spPrefix(dprep) + ' ' + dobjText;

        /*
         *   add the complementizer AFTER the direct object, if the direct
         *   object is shown as a pronoun ("PICK IT UP")
         */
        if (dobjIsPronoun)
            ret += spPrefix(vcomp);

        /* if we have an indirect object, add it with its preposition */
        if (iobjText != nil)
            ret += spPrefix(iprep) + ' ' + iobjText;

        /* return the result phrase */
        return ret;
    }
;

/*
 *   English-specific additions for verbs taking a literal phrase as the
 *   sole object.
 */
modify LiteralAction
    /* provide a base verbPhrase, in case an instance leaves it out */
    verbPhrase = 'verb/verbing (vad)'

    /* get an interrogative word for an object of the action */
    whatObj(which)
    {
        /* use the same processing as TAction */
        return delegated TAction(which);
    }

    getVerbPhrase(inf, ctx)
    {
        /* handle this as though the literal were a direct object phrase */
        return TAction.getVerbPhrase1(inf, verbPhrase, gLiteral);
    }

    getQuestionInf(which)
    {
        /* use the same handling as for a regular one-object action */
        return delegated TAction(which);
    }

;

/*
 *   English-specific additions for verbs of a direct object and a literal
 *   phrase.
 */
modify LiteralTAction
    announceDefaultObject(obj, whichObj, resolvedAllObjects)
    {
        /*
         *   Use the same handling as for a regular two-object action.  We
         *   can only default the actual object in this kind of verb; the
         *   actual object always fills the DirectObject slot, but in
         *   message generation it might use a different slot, so use the
         *   message generation slot here.
         */
        return delegated TIAction(obj, whichMessageObject,
                                  resolvedAllObjects);
    }

    whatObj(which)
    {
        /* use the same handling we use for a regular two-object action */
        return delegated TIAction(which);
    }

    getQuestionInf(which)
    {
        /*
         *   use the same handling as for a two-object action (but note
         *   that we override getMessageObjectPronoun(), which will affect
         *   the way we present the verb infinitive in some cases)
         */
        return delegated TIAction(which);
    }

    /*
     *   When we want to show a verb infinitive phrase that involves a
     *   pronoun for the literal phrase, refer to the literal as 'that'
     *   rather than 'it' or anything else.
     */
    getOtherMessageObjectPronoun(which)
    {
        /*
         *   If we're asking about the literal phrase, then the other
         *   pronoun is for the resolved object: so, return the pronoun
         *   for the direct object phrase, because we *always* store the
         *   non-literal in the direct object slot, regardless of the
         *   actual phrasing of the action.
         *
         *   If we're asking about the resolved object (i.e., not the
         *   literal phrase), then return 'that' as the pronoun for the
         *   literal phrase.
         */
        if (which == whichMessageLiteral)
        {
            /*
             *   we're asking about the literal, so the other pronoun is
             *   for the resolved object, which is always in the direct
             *   object slot (so the 'other' slot is effectively the
             *   indirect object)
             */
            return delegated TIAction(IndirectObject);
        }
        else
        {
            /*
             *   We're asking about the resolved object, so the other
             *   pronoun is for the literal phrase: always use 'that' to
             *   refer to the literal phrase.
             */
            return 'det'; 
        }
    }

    getVerbPhrase(inf, ctx)
    {
        local dobj, dobjText, dobjIsPronoun;
        local litText;
        local ret;

        /* use the default context if one wasn't supplied */
        if (ctx == nil)
            ctx = defaultGetVerbPhraseContext;

        /* get the direct object information */
        dobj = getDobj();
        dobjText = ctx.objNameObj(dobj);
        dobjIsPronoun = ctx.isObjPronoun(dobj);

        /* get our literal text */
        litText = gLiteral;

        /*
         *   Use the standard two-object phrasing.  The order of the
         *   phrasing depends on whether our literal phrase is in the
         *   direct or indirect object slot.
         */
        if (whichMessageLiteral == DirectObject)
            ret = TIAction.getVerbPhrase2(inf, verbPhrase,
                                          litText, nil, dobjText);
        else
            ret = TIAction.getVerbPhrase2(inf, verbPhrase,
                                          dobjText, dobjIsPronoun, litText);

        /* use the direct object as the antecedent for the next phrase */
        ctx.setPronounObj(dobj);

        /* return the result */
        return ret;
    }
;

/*
 *   English-specific additions for verbs taking a topic phrase as the sole
 *   object.  
 */
modify TopicAction
    /* get an interrogative word for an object of the action */
    whatObj(which)
    {
        /* use the same processing as TAction */
        return delegated TAction(which);
    }

    getVerbPhrase(inf, ctx)
    {
        /* handle this as though the topic text were a direct object phrase */
        return TAction.getVerbPhrase1(
            inf, verbPhrase, getTopic().getTopicText().toLower());
    }

    getQuestionInf(which)
    {
        /* use the same handling as for a regular one-object action */
        return delegated TAction(which);
    }

;

/*
 *   English-specific additions for verbs with topic phrases.
 */
modify TopicTAction
    announceDefaultObject(obj, whichObj, resolvedAllObjects)
    {
        /*
         *   Use the same handling as for a regular two-object action.  We
         *   can only default the actual object in this kind of verb; the
         *   actual object always fills the DirectObject slot, but in
         *   message generation it might use a different slot, so use the
         *   message generation slot here.
         */
        return delegated TIAction(obj, whichMessageObject,
                                  resolvedAllObjects);
    }

    whatObj(which)
    {
        /* use the same handling we use for a regular two-object action */
        return delegated TIAction(which);
    }

    getQuestionInf(which)
    {
        /* use the same handling as for a regular two-object action */
        return delegated TIAction(which);
    }

    getOtherMessageObjectPronoun(which)
    {
        /*
         *   If we're asking about the topic, then the other pronoun is
         *   for the resolved object, which is always in the direct object
         *   slot.  If we're asking about the resolved object, then return
         *   a pronoun for the topic.
         */
        if (which == whichMessageTopic)
        {
            /*
             *   we want the pronoun for the resolved object, which is
             *   always in the direct object slot (so the 'other' slot is
             *   effectively the indirect object)
             */
            return delegated TIAction(IndirectObject);
        }
        else
        {
            /* return a generic pronoun for the topic */
            return 'det'; 
        }
    }

    getVerbPhrase(inf, ctx)
    {
        local dobj, dobjText, dobjIsPronoun;
        local topicText;
        local ret;

        /* use the default context if one wasn't supplied */
        if (ctx == nil)
            ctx = defaultGetVerbPhraseContext;

        /* get the direct object information */
        dobj = getDobj();
        dobjText = ctx.objNameObj(dobj);
        dobjIsPronoun = ctx.isObjPronoun(dobj);

        /* get our topic phrase */
        topicText = getTopic().getTopicText().toLower();

        /*
         *   Use the standard two-object phrasing.  The order of the
         *   phrasing depends on whether our topic phrase is in the direct
         *   or indirect object slot.
         */
        if (whichMessageTopic == DirectObject)
            ret = TIAction.getVerbPhrase2(inf, verbPhrase,
                                          topicText, nil, dobjText);
        else
            ret = TIAction.getVerbPhrase2(inf, verbPhrase,
                                          dobjText, dobjIsPronoun, topicText);

        /* use the direct object as the antecedent for the next phrase */
        ctx.setPronounObj(dobj);

        /* return the result */
        return ret;
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   Verbs.
 *
 *   The actual body of each of our verbs is defined in the main
 *   language-independent part of the library.  We only define the
 *   language-specific grammar rules here.
 */

VerbRule(Take)
    (('ta'|'tag') ('ner'|'ned'|) 
    | ('ta'|'tag'|'plocka'|'hämta') ('upp'|'med'|)) dobjList
    | 'införskaffa' dobjList
    : TakeAction
    verbPhrase = 'ta/tar (vad)'
;

VerbRule(TakeFrom)
    ('ta' | 'tag') dobjList
        ('från' | 'ut' 'ur' | 'bort' | 'av' | 'av' 'från') singleIobj
    | 'ta' 'bort' dobjList 'från' singleIobj
    : TakeFromAction
    verbPhrase = 'ta/tar (vad) (från vad)'
;

VerbRule(Remove)
    'ta' 'bort' dobjList
    : RemoveAction
    verbPhrase = 'ta bort/tar bort (vad)'
;

VerbRule(Drop)
    ('släpp' | 'sätt' | 'ställ') ('ner'|'ned'|)  dobjList
    | 'lämna' dobjList
    : DropAction
    verbPhrase = 'släppa/släpper (vad)'
;

VerbRule(Examine)
    ('undersök' | 'inspektera' | 'x' | 'granska' | 'analysera' | 'betrakta' | 'utforska' | 'observera' 
     | 'titta' 'på' | 'se' 'på' | 'titta' ) dobjList
     | ('ta' 'en' 'närmare' 'titt' 'på' ) dobjList
    : ExamineAction
    verbPhrase = 'undersöka/undersöker (vad)'
;

VerbRule(Read)
    ('läs'|'tolka'|'tyd'|'studera') ('igenom'|) dobjList
    : ReadAction
    verbPhrase = 'läsa/läser (vad)'
;

VerbRule(LookIn)
    ('se'|'titta') ('in'|) ('i'|'inuti') dobjList
    : LookInAction
    verbPhrase = 'titta/tittar (i vad)'
;

VerbRule(Search)
    'sök' ('genom'|'igenom'|) dobjList
    : SearchAction
    verbPhrase = 'söka/söker igenom (vad)'
;

VerbRule(LookThrough)
    ('titta' | 't' | 'se') ('in'|'ut'|) ('genom') dobjList
    : LookThroughAction
    verbPhrase = 'titta/tittar (genom vad)'
;

VerbRule(LookUnder)
    ('titta' | 't' | 'se') ('in'|) 'under' dobjList
    : LookUnderAction
    verbPhrase = 'titta/tittar (under vad)'
;

VerbRule(LookBehind)
    ('titta' | 't' | 'se') ('in'|) 'bakom' dobjList
    : LookBehindAction
    verbPhrase = 'titta/tittar (bakom vad)'
;

VerbRule(Feel)
    ('känn' | 'rör') ('efter'|) ('på'|) dobjList
    : FeelAction
    verbPhrase = 'röra/rör (vad)'
;

VerbRule(Taste)
    'smaka' dobjList
    : TasteAction
    verbPhrase = 'smaka/smakar (vad)'
;

VerbRule(Smell)
    ('lukta' | 'vädra' | 'lukta' | 'dofta') ('på'|) dobjList
    : SmellAction
    verbPhrase = 'lukta/luktar (vad)'

    /*
     *   use the "not aware" version of the no-match message - the object
     *   of SMELL is often intangible, so the default "you can't see that"
     *   message is often incongruous for this verb
     */
    noMatch(msgObj, actor, txt) { msgObj.noMatchNotAware(actor, txt); }
;

VerbRule(SmellImplicit)
    'lukta' | 'vädra'
    : SmellImplicitAction
    verbPhrase = 'lukta/luktar'
;

VerbRule(ListenTo)
    ('hör' | 'lyssna' ('på'|'till') ) dobjList
    : ListenToAction
    verbPhrase = 'lyssna/lyssnar (till vad)'

    /*
     *   use the "not aware" version of the no-match message - the object
     *   of LISTEN TO is often intangible, so the default "you can't see
     *   that" message is often incongruous for this verb
     */
    noMatch(msgObj, actor, txt) { msgObj.noMatchNotAware(actor, txt); }
;

VerbRule(ListenImplicit)
    'lyssna' | 'hör'
    : ListenImplicitAction
    verbPhrase = 'lyssna/lyssnar'
;

VerbRule(PutIn)
    ('lägg' | 'placera' | 'sätt' | 'stoppa') ('in'|'i') dobjList ('i'|'inuti') singleIobj
    | ('lägg' | 'placera' | 'sätt' | 'stoppa'  ) dobjList singleIobj
    | ('lägg' | 'placera' | 'sätt' | 'stoppa' | 'infoga') ('ned'|'ner'|) dobjList
    ('i' | 'in' | 'in' 'i' | 'in' 'till' | 'insidan' | 'insidan' 'av') singleIobj
    : PutInAction
    verbPhrase = 'sätta/sätter (vad) (in i vad)'
    askIobjResponseProd = inSingleNoun
;

VerbRule(PutOn)
    ('lägg' | 'placera' | 'släpp' | 'sätt' | 'stoppa') dobjList
        ('på' | ('upp' 'på') | 'på' 'till' | 'uppe' 'på') singleIobj
    | 'sätt' dobjList 'ner' 'på' singleIobj
    : PutOnAction
    verbPhrase = 'sätta/sätter (vad) (på vad)'
    askIobjResponseProd = onSingleNoun
;

VerbRule(PutUnder)
    ('lägg' | 'placera' |'sätt') dobjList 'under' singleIobj
    : PutUnderAction
    verbPhrase = 'sätta/sätter (vad) (under vad)'
;

VerbRule(PutBehind)
    ('lägg' | 'placera' |'sätt') dobjList 'bakom' singleIobj
    : PutBehindAction
    verbPhrase = 'sätta/sätter (vad) (bakom vad)'
;

VerbRule(PutInWhat)
    [badness 500] ('lägg' | 'placera' |'sätt') dobjList
    : PutInAction
    verbPhrase = 'sätta/sätter (vad) (i vad)'
    construct()
    {
        /* set up the empty indirect object phrase */
        iobjMatch = new EmptyNounPhraseProd();
        iobjMatch.responseProd = inSingleNoun;
    }
;

VerbRule(Kiss)
    'kyss' singleDobj
    : KissAction
    verbPhrase = 'kyssa/kysser (vem)'
;

VerbRule(AskFor)
    ('fråga' |'be'|'f') singleDobj 'efter' singleTopic
    | ('fråga'|'be'|'f') 'efter' singleTopic 'av' singleDobj
    : AskForAction
    verbPhrase = 'fråga/frågar (vem) (efter vad)'
    omitIobjInDobjQuery = true
    askDobjResponseProd = singleNoun
    askIobjResponseProd = forSingleNoun
;

VerbRule(AskWhomFor)
    ('fråga'|'be'|'f') 'efter' singleTopic
    : AskForAction
    verbPhrase = 'fråga/frågar (vem) (efter vad)'
    omitIobjInDobjQuery = true
    construct()
    {
        /* set up the empty direct object phrase */
        dobjMatch = new EmptyNounPhraseProd();
        dobjMatch.responseProd = singleNoun;
    }
;

VerbRule(AskAbout)
    ('fråga'|'be'|'f') singleDobj 'om' singleTopic
    | ('fråga' 'ut'|'utfråga') singleDobj 'om' singleTopic
    | ('diskutera'|'utforska') singleTopic 'med' singleDobj
    | 'konsultera' singleDobj 'angående' singleTopic
    | 'be'  singleDobj ('förklara'| ('berätta' 'om')) singleTopic
    : AskAboutAction
    verbPhrase = 'fråga/frågar (vem) (om vad)'
    omitIobjInDobjQuery = true
    askDobjResponseProd = singleNoun
;

VerbRule(AskAboutImplicit)
    ('f'|'prata') ('om'|) singleTopic
    : AskAboutAction
    verbPhrase = 'fråga/frågar (vem) (om vad)'
    omitIobjInDobjQuery = true
    construct()
    {
        /* set up the empty direct object phrase */
        dobjMatch = new EmptyNounPhraseProd();
        dobjMatch.responseProd = singleNoun;
    }
;

VerbRule(AskAboutWhat)
    [badness 500] 'fråga'|'be' singleDobj
    : AskAboutAction
    verbPhrase = 'fråga/frågar (vem) (om vad)'
    askDobjResponseProd = singleNoun
    omitIobjInDobjQuery = true
    construct()
    {
        /* set up the empty topic phrase */
        topicMatch = new EmptyNounPhraseProd();
        topicMatch.responseProd = aboutTopicPhrase;
    }
;


VerbRule(TellAbout)
    ('berätta' | 'informera' | 'säg' | 'b') ('för'|) singleDobj 'om' singleTopic
    : TellAboutAction
    verbPhrase = 'berätta/berättar för (vem) (om vad)'
    askDobjResponseProd = singleNoun
    omitIobjInDobjQuery = true
;

VerbRule(TellAboutImplicit)
    'b' singleTopic
    : TellAboutAction
    verbPhrase = 'berätta/berättar för (vem) (om vad)'
    omitIobjInDobjQuery = true
    construct()
    {
        /* set up the empty direct object phrase */
        dobjMatch = new EmptyNounPhraseProd();
        dobjMatch.responseProd = singleNoun;
    }
;

VerbRule(TellAboutWhat)
    [badness 500] 'berätta' singleDobj
    : TellAboutAction
    verbPhrase = 'berätta/berättar (vem) (om vad)'
    askDobjResponseProd = singleNoun
    omitIobjInDobjQuery = true
    construct()
    {
        /* set up the empty topic phrase */
        topicMatch = new EmptyNounPhraseProd();
        topicMatch.responseProd = aboutTopicPhrase;
    }
;

VerbRule(AskVague)
    [badness 500] 'fråga' singleDobj singleTopic
    : AskVagueAction
    verbPhrase = 'fråga/frågar (vem)'
;

VerbRule(TellVague)
    [badness 500] 'berätta' singleDobj singleTopic
    : AskVagueAction
    verbPhrase = 'berätta/berättar (vem)'
;

VerbRule(TalkTo)
    ('prata'|'konversera') ('till'|'med') singleDobj
    | 'inled' 'konversation' 'med' singleDobj
    | 'hälsa' ('på'|) singleDobj
    : TalkToAction
    verbPhrase = 'prata/pratar (med vem)'
    askDobjResponseProd = singleNoun
;

VerbRule(TalkToWhat)
    [badness 500] 'prata'
    : TalkToAction
    verbPhrase = 'prata/pratar (med vem)'
    askDobjResponseProd = singleNoun

    construct()
    {
        /* set up the empty direct object phrase */
        dobjMatch = new EmptyNounPhraseProd();
        dobjMatch.responseProd = onSingleNoun;
    }
;

VerbRule(Topics)
    ('ä' | 'ämne' | 'ämnen' | 'samtalsämnen' | 'samtal')
    : TopicsAction
    verbPhrase = 'visa/visar samtalsämnen'
;

VerbRule(Hello)
    ('hälsa' ('på'|'till'|))
    | ('säg' 'hej' 'till')
    ('säg' | ) ('hej' | 'hallå' | 'tjena' | 'tja')
    : HelloAction
    verbPhrase = 'hälsa/hälsar'
;

VerbRule(Goodbye)
    ('säg' | ()) ('adjö' | 'hejdå' | 'hej' 'då'| 'farväl')
    : GoodbyeAction
    verbPhrase = 'ta/tar farväl'
;

VerbRule(Yes)
    'ja' | 'bekräfta' | 'instäm' | ('säg' 'ja')
    : YesAction
    verbPhrase = 'säga/säger ja'
;

VerbRule(No)
    'nej' | 'neka' | 'säg' 'nej'
    : NoAction
    verbPhrase = 'säga/säger nej'
;

VerbRule(Yell)
    'skrik' | 'vråla' | 'skräna'
    : YellAction
    verbPhrase = 'skrika/skriker'
;

VerbRule(GiveTo)
    ('ge' | 'erbjud' | 'överlämna') dobjList 'till' singleIobj
    : GiveToAction
    verbPhrase = 'ge/ger (vad) (till vem)'
    askIobjResponseProd = toSingleNoun
;

VerbRule(GiveToType2)
    ('ge' | 'erbjud') singleIobj dobjList
    : GiveToAction
    verbPhrase = 'ge/ger (vad) (till vem)'
    askIobjResponseProd = toSingleNoun

    /* this is a non-prepositional phrasing */
    isPrepositionalPhrasing = nil
;

VerbRule(GiveToWhom)
    ('ge' | 'erbjud') dobjList
    : GiveToAction
    verbPhrase = 'ge/ger (vad) (till vem)'
    construct()
    {
        /* set up the empty indirect object phrase */
        iobjMatch = new ImpliedActorNounPhraseProd();
        iobjMatch.responseProd = toSingleNoun;
    }
;

VerbRule(ShowTo)
    'visa' ('upp'|) dobjList 'för' singleIobj
    : ShowToAction
    verbPhrase = 'visa/visar (vad) (till vem)'
    askIobjResponseProd = toSingleNoun
;

VerbRule(ShowToType2)
    'visa' singleIobj dobjList
    : ShowToAction
    verbPhrase = 'visa/visar (vad) (till vem)'
    askIobjResponseProd = toSingleNoun

    /* this is a non-prepositional phrasing */
    isPrepositionalPhrasing = nil
;

VerbRule(ShowToWhom)
    'visa' dobjList
    : ShowToAction
    verbPhrase = 'visa/visar (vad) (till vem)'
    construct()
    {
        /* set up the empty indirect object phrase */
        iobjMatch = new ImpliedActorNounPhraseProd();
        iobjMatch.responseProd = toSingleNoun;
    }
;

VerbRule(Throw)
    ('kasta' | 'släng') dobjList
    : ThrowAction
    verbPhrase = 'kasta/kastar (vad)'
;

VerbRule(ThrowAt)
    ('kasta' | 'släng') dobjList ('på'|'mot') singleIobj
    : ThrowAtAction
    verbPhrase = 'kasta/kastar (vad) (mot vad)'
    askIobjResponseProd = atSingleNoun
;

VerbRule(ThrowTo)
    ('kasta' | 'släng') dobjList 'till' singleIobj
    : ThrowToAction
    verbPhrase = 'kasta/kastar (vad) (till vem)'
    askIobjResponseProd = toSingleNoun
;

VerbRule(ThrowToType2)
    'kasta' singleIobj dobjList
    : ThrowToAction
    verbPhrase = 'kasta/kastar (vad) (till vem)'
    askIobjResponseProd = toSingleNoun

    /* this is a non-prepositional phrasing */
    isPrepositionalPhrasing = nil
;

VerbRule(ThrowDir)
    ('kasta' | 'släng') dobjList ('till' | ) singleDir
    : ThrowDirAction
    verbPhrase = ('kasta/kastar (vad) ' + dirMatch.dir.name)
;

/* a special rule for THROW DOWN <dobj> */
VerbRule(ThrowDirDown)
    'kasta' 'ner' dobjList
    : ThrowDirAction
    verbPhrase = ('kasta/kastar (vad) ner')

    /* the direction is fixed as 'ner' for this phrasing */
    getDirection() { return downDirection; }
;

VerbRule(Follow)
    'följ' ('efter'|) singleDobj
    : FollowAction
    verbPhrase = 'följa/följer (vem)'
    askDobjResponseProd = singleNoun
;

VerbRule(Attack)
    ('attackera' | 'döda' | 'slå' | 'sparka') singleDobj
    : AttackAction
    verbPhrase = 'attackera/attackerar (vem)'
    askDobjResponseProd = singleNoun
;

VerbRule(AttackWith)
    ('attackera' | 'döda' | 'slå' | 'sparka')
        singleDobj
        'med' singleIobj
    : AttackWithAction
    verbPhrase = 'attackera/attackerar (vem) (med vad)'
    askDobjResponseProd = singleNoun
    askIobjResponseProd = withSingleNoun
;

VerbRule(Inventory)
    'i' | 'inv' |'inventera' | 'l' | 'lista' | ('lista'|'ta'|'tag') ('inventarie'|'inventarier')
    : InventoryAction
    verbPhrase = 'lista/listar inventarier'
;

VerbRule(InventoryTall)
    'l' 'högt' | 'lista' 'högt'
    : InventoryTallAction
    verbPhrase = 'lista/listar inventarier "högt"'
;

VerbRule(InventoryWide)
    'l' 'brett' | 'inventarier' 'brett'
    : InventoryWideAction
    verbPhrase = 'lista/listar inventarier "brett"'
;

VerbRule(Wait)
    'z' | 'vänta'
    : WaitAction
    verbPhrase = 'vänta/väntar'
;

VerbRule(Look)
    ('t' | 'se' | 'titta' | 'betrakta' | 'kolla') ('omkring'|'runt'|) 
    : LookAction
    verbPhrase = 'titta/tittar runt'
;

VerbRule(Quit)
    'avsluta' | 'av' | 'a' | 'q'
    : QuitAction
    verbPhrase = 'avsluta/avslutar'
;

VerbRule(Again)
    'igen' | 'fortsätt' | 'upprepa' | 'g'
    : AgainAction
    verbPhrase = 'repetera/repeterar det sista kommandot'
;

VerbRule(Footnote)
    ('fotnot' | 'not') singleNumber
    : FootnoteAction
    verbPhrase = 'visa/visar fotnoter'
;

VerbRule(FootnotesFull)
    'fotnoter' ('fullständiga'|'alla'|'allt'|'full'|'fullt')
    : FootnotesFullAction
    verbPhrase = 'tillåta/tillåter alla fotnoter'
;

VerbRule(FootnotesMedium)
    'fotnoter' 'medium'
    : FootnotesMediumAction
    verbPhrase = 'tillåta/tillåter nya fotnoter'
;

VerbRule(FootnotesOff)
    'fotnoter' 'av'
    : FootnotesOffAction
    verbPhrase = 'gömma/gömmer fotnoter'
;

VerbRule(FootnotesStatus)
    'fotnoter'
    : FootnotesStatusAction
    verbPhrase = 'visa/visar status för fotnoter'
;

VerbRule(TipsOn)
    'tips' 'på'
    : TipModeAction

    stat_ = true

    verbPhrase = 'aktivera/aktiverar tips'
;

VerbRule(TipsOff)
    'tips' 'av'
    : TipModeAction

    stat_ = nil

    verbPhrase = 'inaktivera/inaktiverar tips'
;

VerbRule(Verbose)
    'ordrik' | 'ordrikt' | 'verbose'
    : VerboseAction
    verbPhrase = 'aktivera/aktiverar ORDRIKT läge'
;

VerbRule(Terse)
    'kortfattat' | 'kortfattad' | 'terse' | 'brief'
    : TerseAction
    verbPhrase = 'aktivera/aktiverar KORTFATTAT läge'
;

VerbRule(Score)
    'poäng' | 'status'
    : ScoreAction
    verbPhrase = 'visa/visar poäng'
;

VerbRule(FullScore)
    'full' 'poäng' | 'full'
    : FullScoreAction
    verbPhrase = 'visa/visar full poäng'
;

VerbRule(Notify)
    'notifiering'
    : NotifyAction
    verbPhrase = 'visa/visar notifieringsstatus'
;

VerbRule(NotifyOn)
    'notifiering' 'på'
    : NotifyOnAction
    verbPhrase = 'slå/slår på poängnotifikation'
;

VerbRule(NotifyOff)
    'notifiering' 'av'
    : NotifyOffAction
    verbPhrase = 'stänga/stänger av poängnotifikation'
;

VerbRule(Save)
    'spara'
    : SaveAction
    verbPhrase = 'spara/sparar'
;

VerbRule(SaveString)
    'spara' quotedStringPhrase->fname_
    : SaveStringAction
    verbPhrase = 'spara/sparar'
;

VerbRule(Restore)
    ('ladda'|'återskapa')
    : RestoreAction
    verbPhrase = 'ladda/laddar'
;

VerbRule(RestoreString)
    ('ladda'|'återskapa') quotedStringPhrase->fname_
    : RestoreStringAction
    verbPhrase = 'ladda/laddar'
;

VerbRule(SaveDefaults)
    'spara' 'förvalt'
    : SaveDefaultsAction
    verbPhrase = 'spara/sparar förvalt'
;

VerbRule(RestoreDefaults)
    'återställ' 'förvalt'
    : RestoreDefaultsAction
    verbPhrase = 'återställa/återställer förvalt'
;

VerbRule(Restart)
    'omstart' 
    | ('starta' 'om') 
    | ('börja' 'om')
    : RestartAction
    verbPhrase = 'starta om/startar om'
;

VerbRule(Pause)
    'pausa'
    : PauseAction
    verbPhrase = 'pausa/pausar'
;

VerbRule(Undo)
    'ångra'
    : UndoAction
    verbPhrase = 'ångra/ångrar'
;

VerbRule(Version)
    'version'
    : VersionAction
    verbPhrase = 'visa/visar version'
;

VerbRule(Credits)
    ('omnämnande'|'omnämnanden'|'credits'|'tillägnan'|'tillägningar'|'tillägnad')
    : CreditsAction
    verbPhrase = 'visa/visar omnämnanden'
;

VerbRule(About)
    'om'
    : AboutAction
    verbPhrase = 'visa/visar information om berättelse'
;

VerbRule(Script)
    'skript' | 'skript' 'på'
    : ScriptAction
    verbPhrase = 'starta/startar skriptande'
;

VerbRule(ScriptString)
    'skript' quotedStringPhrase->fname_
    : ScriptStringAction
    verbPhrase = 'starta/startar skriptande'
;

VerbRule(ScriptOff)
    'skript' 'av' | 'unscript'
    : ScriptOffAction
    verbPhrase = 'avsluta/avslutar skriptande'
;

VerbRule(Record)
    'inspelning' | 'inspelning' 'på'
    : RecordAction
    verbPhrase = 'starta/startar kommandoinspelning'
;

VerbRule(RecordString)
    'inspelning' quotedStringPhrase->fname_
    : RecordStringAction
    verbPhrase = 'starta/startar kommandoinspelning'
;

VerbRule(RecordEvents)
    'inspelning' ('events'|'händelser') | 'inspelning' ('events'|'händelser') 'på'
    : RecordEventsAction
    verbPhrase = 'starta/startar händelseinspelning'
;

VerbRule(RecordEventsString)
    'record' 'events' quotedStringPhrase->fname_
    : RecordEventsStringAction
    verbPhrase = 'starta/startar händelseinspelning'
;

VerbRule(RecordOff)
    'inspelning' 'av'
    : RecordOffAction
    verbPhrase = 'avsluta/avslutar kommandoinspelning'
;

VerbRule(ReplayString)
    'återspela' ('tyst'->quiet_ | 'oavbrutet'->nonstop_ | )
        (quotedStringPhrase->fname_ | )
    : ReplayStringAction
    verbPhrase = 'återuppspela/återuppspelar kommandoinspelning'

    /* set the appropriate option flags */
    scriptOptionFlags = ((quiet_ != nil ? ScriptFileQuiet : 0)
                         | (nonstop_ != nil ? ScriptFileNonstop : 0))
;
VerbRule(ReplayQuiet)
    'rq' (quotedStringPhrase->fname_ | )
    : ReplayStringAction

    scriptOptionFlags = ScriptFileQuiet
;


// ..........................................................



VerbRule(VagueTravel) 'gå' | 'vandra' : VagueTravelAction
    verbPhrase = 'gå/går'
;

VerbRule(Travel)
    ('gå'|'fortsätt'|'vandra') ('vidare'|) singleDir ('igen'|) 
    | ('bege'|'förflytta') ('mig'|'dig') singleDir ('igen'|) 
    | singleDir
    : TravelAction
    verbPhrase = ('gå/går ' + dirMatch.dir.name)
;

/*
 *   Create a TravelVia subclass merely so we can supply a verbPhrase.
 *   (The parser looks for subclasses of each specific Action class to find
 *   its verb phrase, since the language-specific Action definitions are
 *   always in the language module's 'grammar' subclasses.  We don't need
 *   an actual grammar rule, since this isn't an input-able verb, so we
 *   merely need to create a regular subclass in order for the verbPhrase
 *   to get found.)  
 */
class EnTravelVia: TravelViaAction
    verbPhrase = 'använd/använder (vad)'
;

VerbRule(Port)
    'gå' 'till' ('babord' | 'b')
    : PortAction
    dirMatch: DirectionProd { dir = portDirection }
    verbPhrase = 'gå/går till babord'
;

VerbRule(Starboard)
    'gå' 'till' ('styrbord' | 'sb')
    : StarboardAction
    dirMatch: DirectionProd { dir = starboardDirection }
    verbPhrase = 'gå/går till styrbord'
;

VerbRule(In)
    'gå' 'in' 
    : InAction
    dirMatch: DirectionProd { dir = inDirection }
    verbPhrase = 'gå/går in'
;

VerbRule(Out)
    'gå' 'ut' | 'lämna'
    : OutAction
    dirMatch: DirectionProd { dir = outDirection }
    verbPhrase = 'gå/går ut'
;

VerbRule(GoThrough)
    ('vandra' | 'gå' ) ('in'|) ('genom'|'i') singleDobj
    : GoThroughAction
    verbPhrase = 'gå/går (genom vad)'
    askDobjResponseProd = singleNoun
;

VerbRule(Enter)
    (('gå'|'kliv'|'stig') 'in' ('i'|) 
    | 'in' 'till'
    | ('vandra' | 'gå') ('till' 
    | 'in' ('i'|)
    | 'in' 'till'))
    singleDobj
    : EnterAction
    verbPhrase = 'gå/går in i (vad)'
    askDobjResponseProd = singleNoun
;

VerbRule(GoBack)
    'tillbaka' | 'gå' 'tillbaka' | 'återvänd'
    : GoBackAction
    verbPhrase = 'gå/går tillbaka'
;

VerbRule(Dig)
    ('gräv' | 'gräv' 'i') singleDobj
    : DigAction
    verbPhrase = 'gräva/gräver (i vad)'
    askDobjResponseProd = inSingleNoun
;

VerbRule(DigWith)
    ('gräv' | 'gräv' 'i') singleDobj 'med' singleIobj
    : DigWithAction
    verbPhrase = 'gräva/gräver (i vad) (med vad)'
    omitIobjInDobjQuery = true
    askDobjResponseProd = inSingleNoun
    askIobjResponseProd = withSingleNoun
;

VerbRule(Jump)
    'hoppa'
    : JumpAction
    verbPhrase = 'hoppa/hoppar'
;

VerbRule(JumpOffI)
    'hoppa' 'av'
    : JumpOffIAction
    verbPhrase = 'hoppa/hoppar av'
;

VerbRule(JumpOff)
    'hoppa' 'av' singleDobj
    : JumpOffAction
    verbPhrase = 'hoppa/hoppar (av vad)'
    askDobjResponseProd = singleNoun
;

VerbRule(JumpOver)
    ('hoppa' | 'hoppa' 'över') singleDobj
    : JumpOverAction
    verbPhrase = 'hoppa/hoppar (över vad)'
    askDobjResponseProd = singleNoun
;

VerbRule(Push)
    ///('tryck' |'knuffa' | 'pressa') dobjList
    (('flytta' |'knuffa' | 'pressa' | 'tryck') 'på' dobjList)
    | (('förflytta') dobjList)
    : PushAction
    verbPhrase = 'trycka/trycker (vad)'
;

VerbRule(Pull)
    ('dra'|'ryck') ('i'|) dobjList
    : PullAction
    verbPhrase = 'dra/drar (vad)'
;

VerbRule(Move)
    ('flytta'|'knuffa') dobjList
    : MoveAction
    verbPhrase = 'flytta/flyttar (vad)'
;

VerbRule(MoveTo)
    //('flytta' ) dobjList ('till' | 'under') singleIobj
    ('flytta'|'tryck') dobjList ('till' | 'under') singleIobj
    : MoveToAction
    verbPhrase = 'flytta/flyttar (vad) (till vad)'
    askIobjResponseProd = toSingleNoun
    omitIobjInDobjQuery = true
;

VerbRule(MoveWith)
    'flytta' singleDobj 'med' singleIobj
    : MoveWithAction
    verbPhrase = 'flytta/flyttar (vad) (med vad)'
    askDobjResponseProd = singleNoun
    askIobjResponseProd = withSingleNoun
    omitIobjInDobjQuery = true
;

VerbRule(Turn)
    ('vrid' | 'rotera') dobjList
    : TurnAction
    verbPhrase = 'vrida/vrider (vad)'
;

VerbRule(TurnWith)
    ('vrid' | 'rotera') singleDobj 'med' singleIobj
    : TurnWithAction
    verbPhrase = 'vrida/vrider (vad) (med vad)'
    askDobjResponseProd = singleNoun
    askIobjResponseProd = withSingleNoun
;

VerbRule(TurnTo)
    ('vrid' | 'rotera') singleDobj
        'till' singleLiteral
    : TurnToAction
    verbPhrase = 'vrida/vrider (vad) (till vad)'
    askDobjResponseProd = singleNoun
    omitIobjInDobjQuery = true
;

VerbRule(Set)
    'ställ' dobjList
    : SetAction
    verbPhrase = 'ställa/ställer (vad)'
;

VerbRule(SetTo)
    'ställ' 'in' singleDobj ('till'|'på') singleLiteral
    : SetToAction
    verbPhrase = 'ställa/ställer (vad) (till vad)'
    askDobjResponseProd = singleNoun
    omitIobjInDobjQuery = true
;

VerbRule(TypeOn)
    'skriv' 'på' singleDobj
    : TypeOnAction
    verbPhrase = 'skriva/skriver (på vad)'
;

VerbRule(TypeLiteralOn)
    'skriv' ('in'|'ner'|) singleLiteral 'på' singleDobj
    : TypeLiteralOnAction
    verbPhrase = 'skriva/skriver (vad) (på vad)'
    askDobjResponseProd = singleNoun
;

VerbRule(TypeLiteralOnWhat)
    [badness 500] 'skriv' singleLiteral
    : TypeLiteralOnAction
    verbPhrase = 'skriva/skriver (vad) (på vad)'
    construct()
    {
        /* set up the empty direct object phrase */
        dobjMatch = new EmptyNounPhraseProd();
        dobjMatch.responseProd = onSingleNoun;
    }
;

VerbRule(EnterOn)
    ('kliv'|'gå') singleLiteral
        ('på' | 'in' 'i' | 'in' 'till' | 'med') singleDobj
    : EnterOnAction
    verbPhrase = 'kliva/kliver (vad) på (vad)'
    askDobjResponseProd = singleNoun
;

VerbRule(EnterOnWhat)
    'kliv' 'på' singleLiteral
    : EnterOnAction
    verbPhrase = 'kliva/kliver (vad) på (vad)'
    construct()
    {
        /*
         *   ENTER <text> is a little special, because it could mean ENTER
         *   <text> ON <keypad>, or it could mean GO INTO <object>.  It's
         *   hard to tell which based on the grammar alone, so we have to
         *   do some semantic analysis to make a good decision about it.
         *
         *   We'll start by assuming it's the ENTER <text> ON <iobj> form
         *   of the command, and we'll look for a suitable default object
         *   to serve as the iobj.  If we can't find a suitable default, we
         *   won't prompt for the missing object as we usually would.
         *   Instead, we'll try re-parsing the command as GO INTO.  To do
         *   this, use our custom "asker" - this won't actually prompt for
         *   the missing object, but will instead retry the command as a GO
         *   INTO command.
         */
        dobjMatch = new EmptyNounPhraseProd();
        dobjMatch.setPrompt(onSingleNoun, enterOnWhatAsker);
    }
;

/* our custom "asker" for the missing iobj in an "ENTER <text>" command */
enterOnWhatAsker: ResolveAsker
    askMissingObject(targetActor, action, which)
    {
        /*
         *   This method is called when the resolver has failed to find a
         *   suitable default for the missing indirect object of ENTER
         *   <text> ON <iobj>.
         *
         *   Instead of issuing the prompt that we'd normally issue under
         *   these circumstances, assume that we're totally wrong about the
         *   way we've been interpreting the command: assume that it's not
         *   meant as ENTER <text> ON <iobj> after all, but was actually
         *   meant as GO IN <object>.  So, rephrase the command as such and
         *   start over with the new phrasing.
         */
        throw new ReplacementCommandStringException(
            'gå in i ' + action.getLiteral(), gIssuingActor, gActor);
    }
;


VerbRule(Consult)
    'konsultera' singleDobj : ConsultAction
    verbPhrase = 'konsultera/konsulterar (vad)'
    askDobjResponseProd = singleNoun
;

VerbRule(ConsultAbout)
    'konsultera' singleDobj ('på' | 'om') singleTopic
    | 'sök' singleDobj 'efter' singleTopic
    //| (('titta' | 'se' | 't' | 'slå') ('upp' | 'efter')
    | (('slå') ('upp' | 'efter')
       | 'hitta'
       | 'sök' 'efter'
       | 'läs' 'om')
         singleTopic 'i' singleDobj

    //| ('titta' | 'l') singleTopic 'upp' 'i' singleDobj
    : ConsultAboutAction
    verbPhrase = 'konsultera/konsulterar (vad) (om vad)'
    omitIobjInDobjQuery = true
    askDobjResponseProd = singleNoun
;

VerbRule(ConsultWhatAbout)
    //(('titta' | 'se' | 't' | 'slå') ('upp' | 'efter')
    (('slå') ('upp' | 'efter')
     | 'hitta'
     | 'konsultera'
     | 'sök' 'efter'
     | 'läs' 'om') singleTopic

    //| ('titta' | 't') singleTopic 'upp'

    : ConsultAboutAction
    verbPhrase = 'slå/slår upp (vad) (i vad)'
    whichMessageTopic = DirectObject
    construct()
    {
        /* set up the empty direct object phrase */
        dobjMatch = new EmptyNounPhraseProd();
        dobjMatch.responseProd = inSingleNoun;
    }
;
// TODO: Sammanblandas ofta med TurnOn men saknar SwitchOn / SwitchOff
VerbRule(Switch)
    'tryck' 'på' dobjList
    : SwitchAction
    verbPhrase = 'trycka/trycker på (vad)'
;

VerbRule(Flip)
    'vänd' dobjList
    : FlipAction
    verbPhrase = 'vända/vänder (vad)'
;


VerbRule(TurnOn)
    ('aktivera' | ('vrid' | 'slå') 'på' | 'starta') dobjList
    | ('vrid' | 'slå') dobjList 'på'
    : TurnOnAction
    verbPhrase = 'slå/slår på (vad)'
;

VerbRule(TurnOff)
    ('deaktivera' | ('vrid' | 'stäng' | 'slå') 'av') dobjList
    | ('vrid' | 'slå') dobjList 'av'
    : TurnOffAction
    verbPhrase = 'stänga/stänger av (vad)'
;

VerbRule(Light)
    'tänd' dobjList
    : LightAction
    verbPhrase = 'tända/tänder (vad)'
;

DefineTAction(Strike);
VerbRule(Strike)
    'slå' dobjList
    : StrikeAction
    verbPhrase = 'slå/slår (vad)'
;

VerbRule(Burn)
    ('tänd' | 'bränn' | 'sätt' 'eld' 'på') dobjList
    : BurnAction
    verbPhrase = 'tända/tänder (vad)'
;

VerbRule(BurnWith)
    ('tänd' | 'bränn' | 'sätt' 'eld' 'på') singleDobj
        'med' singleIobj
    : BurnWithAction
    verbPhrase = 'tända/tänder (vad) (med vad)'
    omitIobjInDobjQuery = true
    askDobjResponseProd = singleNoun
    askIobjResponseProd = withSingleNoun
;

VerbRule(Extinguish)
    ('släck' | 'släck ut' | 'blås' 'ut') dobjList
    
    : ExtinguishAction
    verbPhrase = 'släcka/släcker (vad)'
;

VerbRule(Break)
    ('förstör' | 'ha' 'sönder'|'demontera') dobjList
    : BreakAction
    verbPhrase = 'förstöra/förstör (vad)'
;

VerbRule(CutWithWhat)
    [badness 500] 'klipp' singleDobj
    : CutWithAction
    verbPhrase = 'klippa/klipper (vad) (med vad)'
    construct()
    {
        /* set up the empty indirect object phrase */
        iobjMatch = new EmptyNounPhraseProd();
        iobjMatch.responseProd = withSingleNoun;
    }
;

VerbRule(CutWith)
    'klipp' ('av'|) singleDobj 'med' singleIobj
    : CutWithAction
    verbPhrase = 'klippa/klipper (vad) (med vad)'
    askDobjResponseProd = singleNoun
    askIobjResponseProd = withSingleNoun
;

VerbRule(Eat)
    ('ät' | 'konsumera' | 'förtär' ) dobjList
    : EatAction
    verbPhrase = 'äta/äter (vad)'
;

VerbRule(Drink)
    ('drick' ) dobjList
    : DrinkAction
    verbPhrase = 'dricka/dricker (vad)'
;

VerbRule(Pour)
    'häll' dobjList
    : PourAction
    verbPhrase = 'hälla/häller (vad)'
;

VerbRule(PourInto)
    'häll' dobjList ('i') singleIobj
    : PourIntoAction
    verbPhrase = 'hälla/häller (vad) (i vad)'
    askIobjResponseProd = inSingleNoun
;

VerbRule(PourOnto)
    'häll' dobjList ('på' | 'på' 'till') singleIobj
    : PourOntoAction
    verbPhrase = 'hälla/häller (vad) (på vad)'
    askIobjResponseProd = onSingleNoun
;

VerbRule(Climb)
    'klättra' ('upp'|) ('på'|) singleDobj
    : ClimbAction
    verbPhrase = 'klättra/klättrar (på vad)'
    askDobjResponseProd = singleNoun
;

VerbRule(ClimbUp)
    ('kliv'|'klättra'|'gå'|'vandra') ('upp'|'uppåt') ('på'|) singleDobj
    : ClimbUpAction
    verbPhrase = 'kliva/kliver upp (på vad)'
    askDobjResponseProd = singleNoun
;

VerbRule(ClimbUpWhat)
    [badness 200] ('klättra'|'kliv' | 'gå' | 'vandra') 'upp'
    : ClimbUpAction
    verbPhrase = 'kliva/kliver upp (på vad)'
    askDobjResponseProd = singleNoun
    construct()
    {
        dobjMatch = new EmptyNounPhraseProd();
        dobjMatch.responseProd = onSingleNoun;
    }
;

VerbRule(ClimbDown)
    ('klättra' | 'gå' | 'vandra') 'ner' ('från'|) singleDobj
    : ClimbDownAction
    verbPhrase = 'kliva/kliver ner (på vad)'
    askDobjResponseProd = singleNoun
;

VerbRule(ClimbDownWhat)
    [badness 200] ('klättra'|'gå'|'vandra') ('ner'|'ned'|'neråt'|'nedåt')
    : ClimbDownAction
    verbPhrase = 'kliva/kliver ner (på vad)'
    askDobjResponseProd = singleNoun
    construct()
    {
        dobjMatch = new EmptyNounPhraseProd();
        dobjMatch.responseProd = onSingleNoun;
    }
;

VerbRule(Clean)
    'rengör'|'städa' dobjList
    : CleanAction
    verbPhrase = 'rengöra/rengör (vad)'
;

VerbRule(CleanWith)
    'rengör'|'städa' dobjList 'med' singleIobj
    : CleanWithAction
    verbPhrase = 'rengöra/rengör (vad) (med vad)'
    askIobjResponseProd = withSingleNoun
    omitIobjInDobjQuery = true
;

VerbRule(AttachTo)
    (
      (('koppla'|'sätt') ('ihop'|'fast'|'fast'|'samman'|'in'))
      | ('sammansätt'|'anslut') 
    )
    dobjList ('med'|'till'|'i') singleIobj
    : AttachToAction
    askIobjResponseProd = toSingleNoun
    verbPhrase = 'sätt fast/sätter fast (vad) (med vad)'
;

VerbRule(AttachToWhat)
    [badness 500] ('koppla') dobjList
    : AttachToAction
    verbPhrase = 'koppla/kopplar samman (vad) (med vad)'
    construct()
    {
        /* set up the empty indirect object phrase */
        iobjMatch = new EmptyNounPhraseProd();
        iobjMatch.responseProd = toSingleNoun;
    }
;

VerbRule(DetachFrom)
    ('koppla' 'från')| ('ta'|'tag') 'loss' | 'lossa' ('på'|) dobjList 'från' singleIobj
    : DetachFromAction
    verbPhrase = 'ta loss/lossa på (vad) (från vad)'
    askIobjResponseProd = fromSingleNoun
;

VerbRule(Detach)
    ('koppla' 'från')| ('ta'|'tag') 'loss' | 'lossa' ('på'|) dobjList
    : DetachAction
    verbPhrase = 'ta loss/lossar på (vad)'
;

VerbRule(Open)
    'öppna' dobjList
    : OpenAction
    verbPhrase = 'öppna/öppnar (vad)'
;

VerbRule(Close)
    ('stäng' |'försegla'| ('slå'|'stäng') 'igen') dobjList
    : CloseAction
    verbPhrase = 'stänga/stänger (vad)'
;

VerbRule(Lock)
    'lås' dobjList
    : LockAction
    verbPhrase = 'låsa/låser (vad)'
;

VerbRule(Unlock)
    'lås' 'upp' dobjList
    : UnlockAction
    verbPhrase = 'låsa/låser upp (vad)'
;

VerbRule(LockWith)
    'lås' singleDobj 'med' singleIobj
    : LockWithAction
    verbPhrase = 'låsa/låser (vad) (med vad)'
    omitIobjInDobjQuery = true
    askDobjResponseProd = singleNoun
    askIobjResponseProd = withSingleNoun
;

VerbRule(UnlockWith)
    ('lås' 'upp') singleDobj 'med' singleIobj
    : UnlockWithAction
    verbPhrase = 'låsa/låser upp (vad) (med vad)'
    omitIobjInDobjQuery = true
    askDobjResponseProd = singleNoun
    askIobjResponseProd = withSingleNoun
;

VerbRule(SitOn)
    'sitt' ('på' | 'i' | ('ner'|'ned') ('på'|'i'))
        singleDobj
    : SitOnAction
    verbPhrase = 'sitta/sitter (på vad)'
    askDobjResponseProd = singleNoun

    /* use the actorInPrep, if there's a direct object available */
    adjustDefaultObjectPrep(prep, obj)
        { return (obj != nil ? obj.actorInPrep + ' ' : prep); }
;

VerbRule(Sit)
    'sitt' ( | ('ner'|'ned')) : SitAction
    verbPhrase = 'sitta/sitter ner'
;

VerbRule(LieOn)
    'ligg' ('på' | 'i' | ('ner'|'ned') ('på' | 'i'))
        singleDobj
    : LieOnAction
    verbPhrase = 'ligga/ligger (på vad)'
    askDobjResponseProd = singleNoun

    /* use the actorInPrep, if there's a direct object available */
    adjustDefaultObjectPrep(prep, obj)
        { return (obj != nil ? obj.actorInPrep + ' ' : prep); }
;

VerbRule(Lie)
    'ligg' ( | ('ner'|'ned')) : LieAction
    verbPhrase = 'ligga/ligger ner'
;

VerbRule(StandOn)
    ('stå' ('på' | 'in' | ('upp' 'på') | 'på' 'till' | 'into' | 'in' 'till'))
    | ('klättra' 'upp' 'på')
    singleDobj
    : StandOnAction
    verbPhrase = 'stå/står (på vad)'
    askDobjResponseProd = singleNoun

    /* use the actorInPrep, if there's a direct object available */
    adjustDefaultObjectPrep(prep, obj)
        { return (obj != nil ? obj.actorInPrep + ' ' : prep); }
;

VerbRule(Stand)
    'stå' | 'stå' 'upp' | 'kliv' 'upp'
    : StandAction
    verbPhrase = 'stå/står upp'
;

VerbRule(GetOutOf)
    ( ('kliv'|'ut') 'ur' | 'kliv' 'ut' ('ur'|) | 'lämna' | 'gå' ('ut'|'ur'))
    singleDobj
    : GetOutOfAction
    verbPhrase = 'kliva/kliver (ut ur vad)'
    askDobjResponseProd = singleNoun

    /* use the actorOutOfPrep, if there's a direct object available */
    adjustDefaultObjectPrep(prep, obj)
        { return (obj != nil ? obj.actorOutOfPrep + ' ' : prep)  ; }
;

VerbRule(GetOffOf)
    'kliv' ('av'| ('ner'|'ned')) ('från'|) singleDobj
    : GetOffOfAction
    verbPhrase = 'kliva/kliver av (från vad)'
    askDobjResponseProd = singleNoun

    /* use the actorOutOfPrep, if there's a direct object available */
    adjustDefaultObjectPrep(prep, obj)
        { return (obj != nil ? obj.actorOutOfPrep + ' ' : prep); }
;

VerbRule(GetOut)
    'kliv' 'ut'
    | 'kliv' 'av'
    | 'kliv' ('ner'|'ned')
    | 'gå' 'i' 'land'
    | 'kliv' 'ut'
    : GetOutAction
    verbPhrase = 'kliva/kliver ut'
;

VerbRule(Board)
    ('borda'
     | ('hoppa' ('i' | 'in' 'till' | 'på' | ('upp' 'på') | 'på' 'till'))
     | ('kliv' ('in' | 'i' | 'in' 'till'))
     | ('gå' 'ombord')
     )
    singleDobj
    : BoardAction
    verbPhrase = 'borda/bordar (vad)'
    askDobjResponseProd = singleNoun
;

VerbRule(Sleep)
    'sova'
    : SleepAction
    verbPhrase = 'sova/sover'
;

VerbRule(Fasten)
    'fäst' | ('koppla' 'fast') dobjList
    //('fäst' | 'säkra') ('fast'|) dobjList
    : FastenAction
    verbPhrase = 'fästa/fäster (vad)'
;



VerbRule(FastenTo)
    ('fäst' | 'koppla') dobjList ('till'|'i') singleIobj
    : FastenToAction
    verbPhrase = 'fästa/fäster (vad) (i vad)'
    askIobjResponseProd = toSingleNoun
;

VerbRule(Unfasten)
    'koppla' ('loss'|'lös') | 'avfäst' dobjList
//    (('koppla'|'ta') ('loss'|'lös') | 'avfäst' | 'osäkra') dobjList
    : UnfastenAction
    verbPhrase = 'koppla/kopplar lös (vad)'
;

VerbRule(UnfastenFrom)
    'koppla' ('loss'|'lös') | 'avfäst'  dobjList 'från' singleIobj
//    (('koppla'|'ta') ('loss'|'lös') | 'avfäst' | 'osäkra')  dobjList 'från' singleIobj
    : UnfastenFromAction
    verbPhrase = 'koppla/kopplar lös (vad) (från vad)'
    askIobjResponseProd = fromSingleNoun
;

VerbRule(PlugInto)
    'koppla'|'anslut' dobjList ('i' | 'in' ('till'|'i'|)) singleIobj
    : PlugIntoAction
    verbPhrase = 'koppla/kopplar in (vad) (i vad)'
    askIobjResponseProd = inSingleNoun
;

VerbRule(PlugIntoWhat)
    [badness 500] 'koppla' 'in' dobjList
    : PlugIntoAction
    verbPhrase = 'koppla/kopplar in (vad) (i vad)'
    construct()
    {
        /* set up the empty indirect object phrase */
        iobjMatch = new EmptyNounPhraseProd();
        iobjMatch.responseProd = inSingleNoun;
    }
;

VerbRule(PlugIn)
    'koppla' ('i'|'in') dobjList
    : PlugInAction
    verbPhrase = 'koppla/kopplar in (vad)'
;

VerbRule(UnplugFrom)
    'koppla' ('ner' | 'loss' | 'lös'| 'ur') dobjList 'från' singleIobj
    : UnplugFromAction
    verbPhrase = 'koppla/kopplar ur (vad) (från vad)'
    askIobjResponseProd = fromSingleNoun
;

VerbRule(Unplug)
    'koppla' ('ner' | 'loss' | 'lös'| 'ur') dobjList
    : UnplugAction
    verbPhrase = 'koppla/kopplar ur (vad)'
;

VerbRule(Screw)
    'skruva' dobjList
    : ScrewAction
    verbPhrase = 'skruva/skruvar (på vad)'
;

VerbRule(ScrewWith)
    'skruva' dobjList 'med' singleIobj
    : ScrewWithAction
    verbPhrase = 'skruva/skruvar (på vad) (med vad)'
    omitIobjInDobjQuery = true
    askIobjResponseProd = withSingleNoun
;

VerbRule(Unscrew)
    'skruva' ('loss'|'lös') dobjList
    : UnscrewAction
    verbPhrase = 'skruva/skruvar loss (vad)'
;

VerbRule(UnscrewWith)
    'skruva' ('loss'|'lös')  dobjList 'med' singleIobj
    : UnscrewWithAction
    verbPhrase = 'skruva/skruvar loss (vad) (med vad)'
    omitIobjInDobjQuery = true
    askIobjResponseProd = withSingleNoun
;

VerbRule(PushTravelDir)
    //('tryck' | 'dra' | 'drag' | 'flytta') singleDobj singleDir
    ('knuffa' | 'tryck' | 'putta' | 'pressa' | 'dra' | 'drag' | 'flytta' | 'skjut') singleDobj ('åt'|'mot'|'till'|) singleDir
    : PushTravelDirAction
    verbPhrase = ('trycka/trycker (vad) ' + dirMatch.dir.name)
;

VerbRule(PushTravelThrough)
    //('tryck' | 'dra' | 'drag' | 'flytta') singleDobj
    ('knuffa' | 'dra' | 'drag' | 'flytta') singleDobj singleDir
    ('genom') singleIobj
    : PushTravelThroughAction
    verbPhrase = 'trycka/trycker (vad) (genom vad)'
;

VerbRule(PushTravelEnter)
    //('tryck' | 'dra' | 'drag' | 'flytta') singleDobj
    ('knuffa' | 'tryck' | 'putta' | 'dra' | 'drag' | 'flytta') singleDobj
    ('in' ('till'|'i') ) singleIobj
    : PushTravelEnterAction
    verbPhrase = 'trycka/trycker (vad) (in i vad)'
;

VerbRule(PushTravelGetOutOf)
    //('tryck' | 'dra' | 'drag' | 'flytta') singleDobj
    ('knuffa' | 'tryck' | 'putta' | 'dra' | 'drag' | 'flytta') singleDobj
    'ut' ('of' | ) singleIobj
    : PushTravelGetOutOfAction
    verbPhrase = 'trycka/trycker (vad) (ut ur vad)'
;


VerbRule(PushTravelClimbUp)
    //('tryck' | 'dra' | 'drag' | 'flytta') singleDobj
    ('knuffa' | 'tryck' | 'putta' | 'dra' | 'drag' | 'flytta') singleDobj
    'up' singleIobj
    : PushTravelClimbUpAction
    verbPhrase = 'trycka/trycker (vad) (up vad)'
    omitIobjInDobjQuery = true
;

VerbRule(PushTravelClimbDown)
    //('tryck' | 'dra' | 'drag' | 'flytta') singleDobj
    ('knuffa' | 'tryck' | 'putta' | 'dra' | 'drag' | 'flytta') singleDobj
    ('ner'|'ned') singleIobj
    : PushTravelClimbDownAction
    verbPhrase = 'trycka/trycker (vad) (ner vad)'
;

VerbRule(Exits)
    'utgångar'
    : ExitsAction
    verbPhrase = 'visa/visar utgångar'
;

VerbRule(ExitsMode)
    'utgångar' ('på'->on_ | 'alla'->on_
             | 'av'->off_ | 'ingen'->off_
             | ('status' ('rad' | ) | 'statuslinje') 'titta'->on_
             | 'titta'->on_ ('status' ('rad' | ) | 'statusrad')
             | 'status'->stat_ ('rad' | ) | 'statusrad'->stat_
             | 'titta'->look_)
    : ExitsModeAction
    verbPhrase = 'stänga av/stänger av visning av utgångar'
;

VerbRule(HintsOff)
    'ledtrådar' 'av'
    : HintsOffAction
    verbPhrase = 'stänga av/stänger av ledtrådar'
;

VerbRule(Hint)
    'ledtrådar'
    : HintAction
    verbPhrase = 'visa/visar ledtrådar'
;

VerbRule(Oops)
    ('oops'|'o'|'oj'|'hoppsan') singleLiteral
    : OopsAction
    verbPhrase = 'rätta/rättar (vad)'
;

VerbRule(OopsOnly)
    ('oops'|'o'|'oj'|'hoppsan')
    : OopsIAction
    verbPhrase = 'rätta/rättar'
;

/* ------------------------------------------------------------------------ */
/*
 *   "debug" verb - special verb to break into the debugger.  We'll only
 *   compile this into the game if we're compiling a debug version to begin
 *   with, since a non-debug version can't be run under the debugger.  
 */
#ifdef __DEBUG

VerbRule(Debug)
    'debug'
    : DebugAction
    verbPhrase = 'debug/debugging'
;

#endif /* __DEBUG */




/******************************************************************************
 *** Additionals ***
 *****************************************************************************/


DefineTIAction(WearPerson)
;

VerbRule(Wear)
    ('ta'|'ikläd'|'klä'|'klär'|'kläd') ('på') dobjList
    | 'sätt' 'på' ('mig'|'dig') dobjList
    : WearAction
    //verbPhrase = 'klä/klär på (vad)'
    verbPhrase = 'ta/tar på (vad)'
;

VerbRule(WearPerson)
    ('ta'|'ikläd'|'klä'|'kläd') 'på' singleIobj dobjList
    : WearAction
    //verbPhrase = 'klä/klär på (vad)' 
    verbPhrase = 'ta/tar på (vad)' 
;

VerbRule(Doff)
    ('tag'|'ta'|'klä'|'klär'|'kläd') 'av' dobjList
    : DoffAction
    //verbPhrase = 'klä/klär av (vad)' 
    verbPhrase = 'ta/tar av (vad)' 
;


/**
 * Define new grammar for the swedish cases
 */
VerbRule(DoffPerson)
    ('tag'|'ta'|'klä'|'kläd') 'av' singleIobj dobjList
    : DoffAction
    //verbPhrase = 'klä/klär av (vad)' 
    verbPhrase = 'ta/tar av (vad)' 
;


// Liten konstruktion som har som syfte att hålla en ordkomponent med ändelse och eventuellt foge-s.
class WordPart: object {
    word = nil
    ending = nil
    jointS = nil
    useIndividually = nil
    construct(word, ending, jointS, useIndividually) {
        self.word = word;
        self.ending = ending;
        self.jointS = jointS;
        self.useIndividually = useIndividually;
    }
}

// Denna funktion skapar variationer från vocabWords
// förutsatt att den följer följande mall:
// äpple+t, äppel+kaka+n, papper+et eller papper^s+flyg+plan+et
// 
// Med andra ord, som enklast, lägg in en ändelse för bestämd form, så som "äpple+t"
// Om det finns foge-s med i ordet, använd ^s, så som: ansvar^s+känsla+n
// Om det ordets totala forms genus skiljer sig från enskilda ord går det att ändra 
// enligt:
//
// sten:+häll:^s+altare+t
// 
// Det fungerar så här, då stenhällsaltaret slutar på t och vi märker ut det med +t
// så antas hela ordets ändelse vara neutrum.
// Om du vill göra avvikelser från detta, kan du skriva in ett ':' för att få 
// skifta genus från neutrum till utrum för bara den ord komponenten, i detta fallet
// "sten:", som nu blir utrum sten-en i sin enskildhet
// samma med "häll:" som blir "häll-en" i sin enskildhet
// 
// Som bäst lyckas genusformen härledas automatiskt genom att bara skriva :,
// men skulle det misslyckas och inte bli rätt, så kan du själv skriva in ändelsen 
// direkt efter kolonet, t ex: "sten:en+häll:en^s+altare+t"
// eller "tranbär:en^s+juice+n"
// för att få automatgenererade ord: "tranbär, tranbären, juice, juicen, tranbär, tranbärjuice, tranbärsjuicen
function createCompoundWordVariations(obj, cur, sectPart, enableShortenRepeatingCharacters = true) {
    
    // wordParts är en behållare för objekt av typen WordPart, 
    // som i sin tur håller koll på ord, foge-s samt ändelse,
    // per ordkomponent. Detta ger flexibilitet vid 
    // permutationsskapandet, där foge-s och ändelse vid vissa 
    // lägen ska vara med, annars inte.
    local wordParts = new Vector();

    // wordVariations är en vector som får hålla alla sammansatta
    // varianter innan de förs över till cmdDict på slutet.
    local wordVariations = new Vector(); 

    // Inleder med att dela upp alla ordets sammansatta komponenter
    // som är avskiljda med '+', '|'-tecken, eller ingen avskiljare alls (nil)
    local parts = splitWithDelimiterPattern(cur, VocabObject.wordPartDelPat);
    
    // Utgå från att minst två komponenter finns i parts eftersom 
    // det reguljära uttrycket identifierat det mönstret med "abc+def" 
    // innan metodanropet in hit.
    local wordCount = parts.length;

    // Håll reda på sista ändelsen för ordet. Den definitiva formen går att 
    // använda för att härleda neutrum/utrum.
    local ending = parts[parts.length][1]; 

    // Beroende på vilken sektion av vocabWords vi nu befinner oss i 
    // skapas boolesker för att hålla koll på om vi är i pluralläge
    // eller singularläge med ett substantiv i plural bestämt utrum. 
    // T ex: äpple+n, äpple+na,
    local isNounOrPluralEndingUter = (sectPart == &noun || sectPart == &plural)
                                  && (ending.endsWith('n') || ending.endsWith('na'));

    // Gör samma för ett adjektiv i bestämd utrum-form
    // Slutet på ett adjektiv i bestämd form. 
    // T ex: ljus+a, grön+a, adekvat+a, överväldigand+e, välartikulerad+e.
    local isAdjectiveEndingUter = (sectPart == &adjective) 
                               && (ending.endsWith('e') || ending.endsWith('a'));

    // Vi anger bara om ett objekt är neutrum (med isNeutrum) då utrum är vanligast
    // och därmed blir default. Negation används på för att det generellt sett är 
    // lättare att matcha mot utrum än neutrum.
    local isEndingNeuter = !isNounOrPluralEndingUter && !isAdjectiveEndingUter;

    // Skapar upp individuella WordPart(s)-objekt av alla ordets komponenter 
    // Skippa den sista ändelsen (som redan finns i variabeln 'ending')
    for(local i = 1; i<=parts.length-1; i++) {
        local part = parts[i][1];
        // Fånga in själva ordet isolerat, samt optionell 'genus-inverter (:)' och optionellt foge-S (^s)
        local match = rexMatch('([^<:^>]+)(:<alpha>*)?(<caret>s)?', part);
        if(match == nil) {
            // Varna om felaktig notation använts
            tadsSay('\n<font color=red>VARNING: Notationsmismatch av "<<cur>>"\n.Använd enligt följande mall: äpple+n, äppel+kaka+n,papper+et eller papper^s+flyg+plan+et</font>\n');
            continue;
        }
        local word = rexGroup(1)[3];        // Plocka ut själva ordet utan ändelse
        
        // Kontrollera om ordet bara ska vara med i en större sammansättning och inte enskilt
        // Om ordet slutar på | så kommer inte ett enskilt ord att skapas för komponenten. 
        local useIndividually =  parts[i][2] != '|';

        local jointS = rexGroup(3) != nil;  // Plocka ut true/false för foge-S
        local genderMod = rexGroup(2);      // Plocka grammatisk genus-moddning som boolesk
        local genderModContent = genderMod ? rexGroup(2)[3] : nil; // Plocka ut alternativ ändelse, annars nil

        // Börja med att kontrollera följande villkor: 
        // 2 delar, inget foge-S MEN en variant av ändelse efter ett kolon.
        //
        // Användningsfallet här är för att stödja alternativa ändelser
        // där ändelsen inte enkelt kan läggas på efter standardformen
        // T ex: 'fönst:er+ret' ger oss 'fönster' & 'fönstret'

        // I detta fallet kommer kolon inte stå för en genusvariant som den 
        // gör när den används ihop med foge-S utan snarare obestämd+bestämd form. 
        // Ändelsen efter (+) kommer att bli den bestämda formen.
        if(parts.length == 2 && !jointS && genderMod) {
            genderModContent = genderModContent.findReplace(':', '', ReplaceAll);
            local wordWithoutEnding = word + genderModContent;
            local wordWithEnding = word + ending;
            cmdDict.addWord(obj, wordWithoutEnding, sectPart);  
            cmdDict.addWord(obj, wordWithEnding, sectPart);  
            return object {
                standardForm = wordWithoutEnding
                definiteForm = wordWithEnding
            };
        }

        // Kontrollera om vi är på sista ordet i iterationen, använd bara definierade 
        // ändelsen i ending rakt av och bryt tidigt. Det finns ingen anledning att 
        // härleda där då användaren specificerat ändelsen som sista del av ordet redan.
        if(i == parts.length-1) {
            wordParts.append(new WordPart(word, ending, nil, useIndividually));
            break;
        } 

        // Annars, kontrollera om det finns ett undantag till genus, 
        // detta mönster inleds av användaren med kolon och en eventuellt 
        // bifogad annan ändelse. Om ingen ändelse anges, kommer kolon 
        // betyda motsatsen till den slutliga ändelsen för ordet.
        
        local partEnding = ending;  // Utgå från att komponenten får samma ändelse som ändelsen för helhetsordet

        if(genderMod) {
            if(genderModContent) {
                // Om kolon + eventuell ny ändelse har påträffas behöver det hanteras
                // Kontrollera om det finns en ändelse bifogad efter kolonet, och skriv i så fall 
                // över partEnding.
                genderModContent = genderModContent.findReplace('^s', '', ReplaceAll);
                genderModContent = genderModContent.findReplace(':', '', ReplaceAll);
                partEnding = genderModContent;
            } else {
                // Om genus-ändelsen saknas försöker vi härleda genus så gott det går
                // Om ordet slutar på vokal eller inte är en god guidning till ett flertal fall
                local endsWithVocal = rexMatch('.*[aeioyu]$', word);

                // Ett-ord, kan sluta på vokal: äpple-t,  eller konsonant, träd-et, lock-et
                // OBS: fixar inte former så som skimmer/skimret, dessa får läggas till som separata ord
                if(isEndingNeuter) {
                    // Neutrum  som slutar vokal, t ex: äpple-t 
                    // Alternativ konsonant, så som: träd-et
                    partEnding = endsWithVocal? 't' : 'et'; 
                
                } else {
                    if(endsWithVocal) {
                        partEnding = 'n'; // en-ord som slutar på vokal, t ex: fura, pinne,
                    } else {
                        // Utrum (-en-ord) som slutar på konsonant.
                        // Här är det omöjligt att veta säker, men en gissning är att om ordet 
                        // slutar på -el, -er, -or eller -al kan vi lägga på ett enkelt 'n'
                        // så som, cykel-n dator-n, teater-n
                        partEnding = rexMatch('.*(el|er|or|al)$', word) ? 'n' : 'en';
                        //tadsSay('SLUTAR PÅ KONSONANT UTRUM: <<word>> = <<partEnding>>');
                    }
                }
            }
        } else {
            local endsWithVocal = rexMatch('.*[aeioyu]$', word);
            // PLURAL
            if(sectPart == &plural) {
                // Vid plural gör vi ingenting än så länge... oftast skriver man formen direkt i obestämd+bestämd
                // form, t ex: äpplen+a
                // Utarbeta detta vid behov.
            } else if(isEndingNeuter) {
                partEnding = endsWithVocal? 't' : 'et';   // NEUTRUM
            } else {
                if(endsWithVocal) {
                    partEnding = 'n';                     // UTRUM, t ex: fura, pinne får "n" som ändelse.
                } else {
                    // Omöjligt att egentligen veta, men en god gissning är att om ordet slutar på el,er,or eller al
                    partEnding = rexMatch('.*(el|er|or|al)$', word) ? 'n' : 'en';
                    //tadsSay('SLUTAR PÅ KONSONANT UTRUM: <<word>> = <<partEnding>>');
                }
            }
        }
        wordParts.append(new WordPart(word,partEnding,jointS, useIndividually));
    }

    for(local part in wordParts) {
        if(part.useIndividually) {
            wordVariations.append(part.word);
            wordVariations.append(part.word + part.ending);
        } else {
            //tadsSay('Skippar enskild ordkomponent: <<part.word>>\n');
        }
    }

    local longestCompoundWord = '';

    // Bygg upp längre sammansatta ord, genom att addera ett i taget
    local wordPartsList = wordParts.toList(); // Skapa en lista av de ord som ska användas individuellt

    for(local nr = 1; nr <= wordPartsList.length; nr++) {
        local w = wordPartsList.sublist(1, nr); // Bygg upp en lista med allt längre sammansatta ord

        // Sätt ihop orden med foge-s om det behövs
        local compoundWord = w.mapAll({x: '<<x.word>><<x.jointS?'s':''>>' }).join('');

        // Om sista sammansatta ordet har foge-s tillagt, ta bort det
        local lastWordHasJointS = w[w.length].jointS;

        if(lastWordHasJointS) {
            compoundWord = compoundWord.substr(1,-1);
        }

        // Håll koll det hittills längst sammansatta ordet för bestämd form 
        longestCompoundWord = max(compoundWord, longestCompoundWord); 
        
        // Om det sista ordet i en sammansättning ska få användas indidivuellt, lägg till det.
        // Annars inte, t ex: i fallet | används, så som i fallet 'vatten|slang+en', här ska inte vatten
        // ensamt läggas till, vatten+slang+en, ska dock göra det.
        if(wordPartsList[nr].useIndividually)  {
            wordVariations.append(compoundWord);
        }
    }

    // Använd det längst sammansatta ordet för att skapa upp namn utan ändelse och med,
    // detta blir standardform respektive bestämd form för just detta specifika ord i mängden.
    local wordWithoutEnding = longestCompoundWord; 
    local wordWithEnding = longestCompoundWord + ending;

    if(parts.length == 3) {
        for(local i=1; i<=wordCount-2; i++) {
            for(local j=2; j<=wordCount-1; j++) {
                if(i == j) continue; // Kombinera inte samma ord
                local firstWord = wordParts[i];
                local secondWord = wordParts[j];
                local word = firstWord.word + (firstWord.jointS?'s':'') + secondWord.word;
                local wordWithEnding = word + secondWord.ending;

                // Lägg bara till det sammansatta ordet om det sista sammansatt ordet får 
                // användas individuellt
                if(secondWord.useIndividually)  {
                    wordVariations.append(word);
                    wordVariations.append(wordWithEnding);
                }
            }
        }
    } else if(parts.length > 3) {        

        // OBS: En gräns nu är vid 3 inre komponenter för olika permutationer med förskjuten offset.
        // (Förskjuten offset för att vi inte kombinerar med omkastad ordföljd, bara framåtriktad)
        // 
        // Detta skulle bör vara dynamiskt men får vara en förbättringspunkt till senare
        // Just nu är det frågan om rent praktiskt gör någon större skillnad.
         // För även om vi i svenskan har en stor mängder sammansatta ord så är 
        // det troliga att man som spelare hellre använder en fåordig synonym än den längsta 
        // sammanssättningen om kontext kan guida vad man avser.

        for(local i=1; i<=wordCount-3; i++) {
            for(local j=2; j<=wordCount-2; j++) {
                for(local k=3; k<=wordCount-1; k++) {
                    if(i == j || j == k) {continue;} // Kombinera inte samma ord flera gånger
                    local firstWord = wordParts[i];
                    local secondWord = wordParts[j];
                    local thirdWord = wordParts[k];
                    local word = firstWord.word + (firstWord.jointS?'s':'') + secondWord.word + (secondWord.jointS?'s':'') + thirdWord.word;
                    local wordWithEnding = word + thirdWord.ending;
                    //tadsSay('[<<i>>,<<j>>,<<k>>] = [<<firstWord.word>>,<<secondWord.word>>,<<thirdWord.word>>] = <<word>> <<wordWithEnding>>\n');

                    // Lägg bara till det sammansatta ordet om det sista sammansatt ordet får 
                    // användas individuellt
                    if(thirdWord.useIndividually)  {
                        wordVariations.append(word);
                        wordVariations.append(wordWithEnding);
                    }
                }
            }
        }
    }

    if(enableShortenRepeatingCharacters) {
        wordVariations = wordVariations.mapAll(shortenRepeatingCharacters);
        wordWithoutEnding = shortenRepeatingCharacters(wordWithoutEnding);
        wordWithEnding = shortenRepeatingCharacters(wordWithEnding);
    }

    // Ta bort dubbletter, kanske onödigt då cmdDict redan är ett table, så när dessa 
    // adderas dit kommer bara dubbletter skrivas över ändå.
    wordVariations = wordVariations.getUnique();

    //tadsSay('Word variations: ' + wordVariations.mapAll({x: '<<x>>'}).join(', '));
    wordVariations.forEach(function(wordVariation) {
        cmdDict.addWord(obj, wordVariation, sectPart);  
        /*
        #ifdef __DEBUG
            displayWordPart(sectPart, wordVariation, obj);
        #endif
        */
    });

    return object {
        standardForm = wordWithoutEnding
        definiteForm = wordWithEnding
    };
}

// works similar to the string split function
// But returns an array of pairs where for each pair there's the word and the delimiter
// As default, it will search for words that ends in either the '+' or '|'-delimiter
//
// e.g: calling splitWithDelimiterPattern('stols|ben+et') 
// will return:  [ [stols, '|'], ['ben','+'], [et, nil] ]
//  
function splitWithDelimiterPattern(str, pat = VocabObject.wordPartDelPat) {
    local pairs = new Vector();
    local idx = 1; // Begin searching the pattern at position 1 

    // Keep looping as long as the index is less than the length of the string
    while(idx <= str.length) {

      local result = rexMatch(pat, str, idx);
      if(result == nil) {
        // If no delimiter was found it's becasue it is the last word, 
        // just add nil as delimiter and step out of the loop
        pairs += [[str.substr(idx, str.length), nil]];
        break;
      } 

      // Add a pair to the result that will be returned eventually
      local word = rexGroup(1)[3];
      local delimiter = rexGroup(2)[3];
      pairs += [[word, delimiter]];

      // Update the index to be +1 after where the last delimiter was found
      idx = rexGroup(2)[1] + 1; 
    }

    return pairs;
};


// Rensa bort alla eventuella trippelbokstäver som uppstått på grund 
// av ordsammansättningarna:
function shortenRepeatingCharacters(word) {
    local match = rexMatch(VocabObject.tripleLetterPat, word);
    if(match) {
        local groupOfRepeats = rexGroup(1);
        if(groupOfRepeats.length > 2) {
            //tadsSay('<<groupOfRepeats>>\n');
            local startPos = groupOfRepeats[1];
            local similarCount = groupOfRepeats[2];
            local lengthToRemove = similarCount - 2;
            local pruned =  word.splice(startPos, lengthToRemove, '');
            //tadsSay('Rensar bort trippelbokstäver: <<w>> -> <<pruned>> (startpos: <<startPos>>, similarCount: <<similarCount>>, remove: <<lengthToRemove>> )\n');
            return pruned;
        }
    }
    return word;
}




#ifdef __DEBUG

//###############################
//### SVENSKA DEBUGFUNKTIONER ###
//###############################

// 'vokab' listar alla ord och vilken kategori de tillhör (substantiv, adjektiv, plural)
DefineIAction(Vocab)
    execAction() {
        displayVocab();
    }
;

function displayVocab() {
    local objList = [];
    local stringList = [];
    local propList = [];
            
    local nounList = [];
    local adjectiveList = [];
    local pluralList = [];
    local adjApostSList = [];
    local litAdjList = [];

    cmdDict.forEachWord({ x,y,z: objList += x});
    cmdDict.forEachWord({ x,y,z: stringList += y});
    cmdDict.forEachWord({ x,y,z: propList += z});
    
    local len = objList.length();
    for (local i = 1; i < len; i++) {
        local obj = propList[i];
        switch(obj) {
            case &noun:               nounList += stringList[i]; break;
            case &adjective:          adjectiveList += stringList[i]; break;
            case &plural:             pluralList += stringList[i]; break;
            case &adjApostS:          adjApostSList += stringList[i]; break;
            case &literalAdjective:   litAdjList += stringList[i]; break;
        }
    }
    "<.p>[NOUNS]<.p>";              foreach (local cur in nounList)         "\^<<cur>> ";
    "<.p>[ADJECTIVES]<.p>";         foreach (local cur in adjectiveList)    "\^<<cur>> ";
    "<.p>[PLURALS]<.p>";            foreach (local cur in pluralList)       "\^<<cur>> ";
    "<.p>[ADJAPOSTS]<.p>";          foreach (local cur in adjApostSList)    "\^<<cur>> ";    
    "<.p>[LITERALADJECTIVE]<.p>";   foreach (local cur in litAdjList)       "\^<<cur>> ";
}

VerbRule(Vokabular)
    'vokab' | 'voc' | 'vocab' | 'vokabulär' | 'vokabulär'
    :VocabAction 
    verbPhrase = 'se/ser vokabulär'
; 


DefineLiteralAction(Ord)
    execAction() {
        local target = gLiteral.toLower();
        local str = new Vector();
        local o = cmdDict.findWord(target);
        local wordFound = o && o.length>0;
        if(wordFound) {
            cmdDict.forEachWord(function(obj, word, wordPart) {
                if(o[1] == obj) {
                    local grammarFunction = '<<wordPart>>'; //'unknown';
                    if(wordPart == &noun) grammarFunction = 'substantiv';
                    else if(wordPart == &literalAdjective) grammarFunction = 'literalAdjective';
                    else if(wordPart == &adjApostS) grammarFunction = 'adjApostS';
                    else if(wordPart == &plural) grammarFunction = 'plural';
                    else if(wordPart == &adjective) grammarFunction = 'adjektiv';
                    str.append('<<word>> (<<grammarFunction>>) \n');
                }
            });
        }
        str.sort();

        local explain = wordFound 
            ? 'Hittade objektet: [<<o[1]>>], \ntheName: "<<o[1].theName>>" \naName: "<<o[1].aName>>"\b
                Följande ord finns definierade:\b'
            :'Fann inget objekt som kan kallas så\n';
        mainReport(toString(explain + str.join('')));
    }
    afterAction() { }
    turnSequence() { }
;

VerbRule(Ord)
    ('ord'|'ordgranska') singleLiteral
    :OrdAction  
    verbPhrase = 'ordgranska/ordgranskar (vad)'
; 

DefineLiteralAction(ObjOrd)
    execAction() { 
        tadsSay('Visar ord definierade i cmdDict för objekt: <<gLiteral>>\n');
        local res = Compiler.compile('displayGrammarInfo(<<gLiteral>>)')();
        mainReport(toString(res));
    }
;

VerbRule(ObjOrd)
    ('obj'|'objektgranska') singleLiteral
    :ObjOrdAction 
    verbPhrase = 'objektgranska/objektgranskar (vad)'
; 

function displayGrammarInfo(o) {
    local str = new StringBuffer();
    str.append('\n');
    cmdDict.forEachWord(function(obj, word, wordPart) {
        try {
            if(obj == o) {
                local grammarFunction = 'okänd';
                if(wordPart == &noun) grammarFunction = 'substantiv';
                else if(wordPart == &literalAdjective) grammarFunction = 'literalAdjective';
                else if(wordPart == &adjApostS) grammarFunction = 'adjApostS';
                else if(wordPart == &plural) grammarFunction = 'plural';
                else if(wordPart == &adjective) grammarFunction = 'adjektiv';
                str.append('<<word>> (<<grammarFunction>>) \n');
            }
        } catch(Exception e) {
            tadsSay('Felaktig jämförelse: <<e>>\n');
        }
    });
    str.append('\b');
    return toString(str);
}

function displayWordPartOnly(wordPart) {
    if(wordPart == &noun) {
        tadsSay(' &noun ');
    }
    if(wordPart == &plural) {
        tadsSay(' &plural ');
    }
    if(wordPart == &adjective) {
        tadsSay(' &noun ');
    }
    if(wordPart == &literalAdjective) {
        tadsSay(' &literalAdjective ');
    }
    if(wordPart == &adjApostS) {
        tadsSay(' &adjApostS ');
    }
    
}

function displayWordPart(wordPart, cur, obj) {
    if(wordPart == &noun) {
        tadsSay('\ <<cur>> (substantiv)');
    }
    if(wordPart == &plural) {
        tadsSay('\ <<cur>> (plural)');
    }
    if(wordPart == &adjective) {
        tadsSay('\ <<cur>> (adjektiv)');
    }
    if(wordPart == &literalAdjective) {
        tadsSay('\ <<cur>> (literalAdjective)');
    }
    if(wordPart == &adjApostS) {
        tadsSay('\ <<cur>> (adjApostS)');
    }
    tadsSay('\t\t\t\t\t\t -> \ [<<obj.name>>]\n');
}



#endif