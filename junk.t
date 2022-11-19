
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

            // Determine utrum/neutrum from defintive name/vocabWords 
            // and add the correct forms to vocabWords before initializing
            if( name
            //&& name == 'sommardag[-en]' || name == 'stuga[-n]'  || name == 'hink[-en]' || name == 'äpple[-et]'
            ) {
                // TODO: clean up here, This is no longer needed since vocabWords keeps track of this

                /*
                local mutableName = name? name : '';

                isPlural = name.endsWith('[-na]')? true : nil;

                name = cutEndings(mutableName);   // Spara undan namnet utan [-ändelsen]
                //roomName = name;



                //TODO: remove this from name, only use it on vocabWords

                removeAndExpandEndings(vocabWords);


                // Om vi inte slutar på a så kan vi lägga på en
                local nameDefinitive = mutableName
                    .findReplace('[-en]', 'en', ReplaceAll)
                    .findReplace('[-n]', 'n', ReplaceAll)
                    .findReplace('[-t]', 't', ReplaceAll)
                    .findReplace('[-et]', 'et', ReplaceAll)
                    .findReplace('[-na]', 'na', ReplaceAll)
                    ;

                local backupVocabWords = vocabWords? vocabWords : '';    // Preserve the plural words(delimeted by*) by placing this last 

                //vocabWords = name;
                //vocabWords += nameDefinitive ? ('/' + nameDefinitive) : '';
                //vocabWords += backupVocabWords ? ('/' + backupVocabWords) : ''; 

                
                vocabWords = [name, nameDefinitive, backupVocabWords].join('/');
                
                //vocabWords = vocabWords.endsWith('/')? vocabWords.substr(vocabWords.length-1) : vocabWords;
                //local endsWithA = name.match(R'a$');

                isUter = nameDefinitive.endsWith('n');
                theName = nameDefinitive;


                */

                /*
                "localVocabWords: [<<localVocabWords>>]\n";

                "roomName: <<roomName>>";

                "Bestämd form: <<nameDefinitive>>  <<isPlural?'(pluralis)':''>>\n";
                "Obestämd form: <<name>>\n";
                "vocabWords: <<vocabWords>>\b";
                */

            }
            target.initializeVocabWith(vocabWords);

        }

        /* add vocabulary from each of our superclasses */
        foreach (local sc in getSuperclassList())
            sc.inheritVocab(target, done);
    }

    
/**
     * Both removes and expands the ending of a noun,
     * e.g: 
     *     klot[-et]                 ->          "klot/klotet"
     *     boll[-en]*bollar[-na]     ->          "boll/bollen*bollar bollarna"
     */
    removeAndExpandEndings(vocabWords) {

        //local buffer = new StrBuf();

        local singularAndPluralSplit = vocabWords.split('*');

        local singularPart = singularAndPluralSplit[1];
        local pluralPart = '';


        local nounsPart = '';
        local adjectivesPart = '';

        /*
        local lastNounDelimiter = singularPart.find('/');
        if(lastNounDelimiter == 0) {
            // No adjectives found, count all as nouns.
            nounsPart = singularPart;

        } else {
            local firstNounPos = findLastNounIndexFromPosition(singularPart, lastNounDelimiter);
            //"firstNounPos: <<firstNounPos>>\n";
            nounsPart = singularPart.substr(firstNounPos);
            adjectivesPart = singularPart.substr(0, firstNounPos);

        }
        "adjectivesPart: <<adjectivesPart>>\n";
        "nounsPart: <<nounsPart>>\n";
        */
        

        /*local singularWordsAndEndingsTable = extractToWordAndEndings(singularPart);
        if(singularWordsAndEndingsTable.getEntryCount()>0) {
            "singular words before: <<singularPart>>\n";
            singularWordsAndEndingsTable.forEachAssoc(function(wordPosition, wordAndEnding  ) {
                "position+ending: <<wordPosition>>+<<wordAndEnding[1]>> <<wordAndEnding[2]>>\n";
            });
            "-----\n";
        }

        if(splitted.length==2) {
            pluralPart = splitted.length==2 ? splitted[2] : '';
            local pluralPartAndEndingsTable = extractToWordAndEndings(pluralPart);

            if(pluralPartAndEndingsTable.getEntryCount()>0) {
                "plural words before: <<pluralPart>>\n";
                pluralPartAndEndingsTable.forEachAssoc(function(wordPosition, wordAndEnding  ) {
                    "position+ending: <<wordPosition>>+<<wordAndEnding[1]>> <<wordAndEnding[2]>>\n";
                });
            }
        }*/
        


        // Go through all found word + their endings
        // Add the noun without the ending and then with the ending 
        /*if(singularWordsAndEndingsTable.getEntryCount()>0) {
            "vocabWords before <<singularPart>>\n";
            singularWordsAndEndingsTable.forEachAssoc(function(wordPosition, wordAndEnding  ) {
                "position+ending: <<wordPosition>>+<<wordAndEnding[1]>> <<wordAndEnding[2]>>\n";
            });
            local offset = 0;
            singularWordsAndEndingsTable.forEachAssoc(function(wordPosition, wordEnding) {
                "position+ending: <<wordPosition>>+<<wordEnding>>\n";
                local startOfWord = findLastNounIndexFromPosition(str, wordPosition + offset);
                local lastNoun = str.substr(startOfWord, wordPosition-startOfWord);
                local lastNounWithEnding = lastNoun + wordEnding;

                "lastNoun: <<lastNoun>>\n";
                "startOfWord: <<startOfWord>>\n";
                "wordEnding: <<wordEnding>>\n";
                "lastNounWithEnding: <<lastNounWithEnding>>\n";
                "positionBeforeEndingMarker <<positionBeforeEndingMarker>>\n";

                local removeNumberOfTokens = wordEnding.length + 3;  // 3 = '[', '-' and ']'
                local nounDelimiter = startOfWord == 0? '/' :'';
                str = str.splice(wordPosition, removeNumberOfTokens, nounDelimiter+lastNounWithEnding);
                
                // Finally apply an offset to the changed string so another ending can be applied correctly
                offset += wordEnding.length; //+ nounDelimiter.length; 

            });
            "vocabWords after: <<str>>*<<pluralPart>>\n";
            

        }    */
        //"vocabWords after: <<str>>\n";
        //return str;
        return vocabWords;

        //return singularPart + '*' + pluralPart;
        /*return vocabWords.findReplace('[-en]', 'en', ReplaceAll)
        .findReplace('[-n]', 'n', ReplaceAll)
        .findReplace('[-t]', 't', ReplaceAll)
        .findReplace('[-et]', 'et', ReplaceAll)
        .findReplace('[-na]', 'na', ReplaceAll)
        ;*/
    }

    extractToWordAndEndings(str) {
        local wordAndEndingsTable = new LookupTable();
        local idx=0;
        do {
            local idx = str.find('[-', idx);
            if(idx == nil) { break; }
            local endPos = str.find(']', idx);
            local ending = str.substr(idx+2, endPos-(idx+2));
            local startOfWord = findLastNounIndexFromPosition(str, idx);
            local lastNoun = str.substr(startOfWord, idx-startOfWord);
            wordAndEndingsTable[idx] = [lastNoun, ending];
            if(endPos+2 >= str.length) { break; }
            idx = endPos+2;
        } while(idx != nil);
        return wordAndEndingsTable;
    }

    findLastNounIndexFromPosition(str, position) {
        local lastIdx = str.findLast('/', position);
        if(lastIdx == nil) {
            lastIdx = str.findLast(' ', position); // If no '/' was found, look for a blank
            lastIdx = lastIdx ? lastIdx : 0;     // If no blank was found, set it to beginning    
        }
        return lastIdx+1;
    }

