#charset "utf-8"
/*
 *   Copyright 2003, 2013 Michael J. Roberts
 *   
 *   Return to Ditch Day - Bridge Lab.  Bridge has a fairly large internal
 *   geography, so we split this off into its own separate file.  This
 *   also includes some of the steam tunnels accessible from Bridge.  
 */

#include <adv3.h>
#include <sv_se.h>
#include <bignum.h>

/* ------------------------------------------------------------------------ */
/*
 *   Bridge entryway 
 */
bridgeEntry: Room 'Brolabbets entré' 'Brons entré' 'hall'
    "Denna entréhall återspeglar den annorlunda proportionskänsla
    som arkitekter hade på 1920-talet: den är lite för smal och lite för
    hög för det moderna ögat. I hallens södra ände leder trappor
    upp och ner, och en dörröppning i den norra änden leder utomhus.
    Ett utställningsskåp är inbyggt i den östra väggen. "

    vocabWords = 'bro labb+et laboratorium+et entré+n entrè|hall+en'

    north = millikanPond
    out asExit(north)
    up = beStairsUp
    down = beStairsDown

    roomParts = (inherited() - defaultEastWall)
;

+ ExitPortal 'dörr+öppning+en' 'dörröppning'
    "Dörröppningen leder utomhus norrut. "
;

+ Decoration 'öst+ra ö vägg+en*väggar+na' 'östra väggen'
    "Ett utställningsskåp är inbyggt i väggen. "
;

++ Fixture, Container 'utställning:en^s+skåp+et/glas+et/monter+n' 'utställningsskåp'
    "Skåpet innehåller ett urval av föremål av historisk
    betydelse inom fysiken. Bland annat finns det en labb-
    anteckningsbok, en liten motor och diverse experimentell
    utrustning. "
    isOpen = nil
    material = glass

    /* 
     *   since we list our contents explicitly, don't mention them again in
     *   the generated description 
     */
    examineListContents() { }
    contentsListed = nil

    dobjFor(Break)
    {
        verify() { }
        action() { "Det finns ingen anledning att vandalisera detta utställningsskåp. "; }
    }
;

+++ Readable
    'robert a. millikans labb laboratorium kursiv
    sida+n/bok+en/anteckning^s+bok+en/handstil+en*tabeller+na beräkningar+na data' 'labbanteckningsbok'
    "Anteckningsboken är öppen på en sida som visar en serie
    tabeller och beräkningar i precis kursiv handstil.
    Bildtexten lyder:
    <q>Robert A. Millikans labbanteckningsbok, 1910.
    Dessa sidor visar data som samlats in under hans berömda <q>oljedroppsexperiment,</q>
    där han för första gången bestämde elektronens laddning. Detta arbete ledde till
    Nobelpriset i fysik 1924.</q> "

    isListed = nil
;

+++ Thing 'liten lilla världens minsta förstorande motor+n/maskin+en/(glas+et)'
    'liten motor'
    "Ett förstoringsglas placerat framför den lilla anordningen
    gör att den kan identifieras som en elektrisk motor. Bildtexten lyder:
    <q>1959 erbjöd Richard Feynman ett pris på 1 000 dollar till den första
    person som kunde bygga en fungerande motor som passade in i en 1/64-tums
    kub. William McLellan, en Caltech-examen, tog priset
    1960 med denna motor, som bara är 15 tusendelar av en
    tum på varje sida. (Tyvärr fungerar motorn inte längre.)</q> "

    isListed = nil
;

+++ Thing 'diverse experimentell+a utrustning+en*bitar+na utrustningar+na' 'experimentell utrustning'
    "All utrustning är handbyggt material från det tidiga 1900-
    talet. "
    isMassNoun = true

    isListed = nil
;

+ beStairsUp: StairwayUp ->b201Stairs
    'upp trappuppgång+en/trappa+n*trappor+na' 'trappor upp' "Trapporna leder uppåt. "
    isPlural = true
;

+ beStairsDown: StairwayDown ->bbeStairs
    'ner trappuppgång+en/trappa+n*trappor+na' 'trappor ner' "Trapporna leder nedåt. "
    isPlural = true
;

/* ------------------------------------------------------------------------ */
/*
 *   201 Bridge lecture hall
 */
bridge201: Room 'Föreläsningssal' '201 Bridge' 'föreläsningssal'
    "Detta är 201 Bridge, föreläsningssalen där fysikkursen för förstaårsstudenter
    undervisas. Omkring 250 spartanska träsäten, arrangerade i
    brant sluttande rader, vetter mot en labbänk som löper längs rummets bredd
    och en vägg av skjutbara svarta tavlor bakom bänken. Utgången
    är en trappa som leder nedåt, på rummets södra sida. "

    vocabWords = '201 bridge föreläsningssal'

    down = b201Stairs
    south asExit(down)
;

+ b201Stairs: StairwayDown 'ner trapp+nedgång+en/trappa+n*trappor+na' 'trappor ner'
    "Trapporna leder nedåt. "
    isPlural = true
;

+ Fixture, Surface 'labb laboratorium+bänk+en/labb+bänk+en' 'labbänk'
    "Labbänken löper längs rummets bredd. Den fungerar som en
    plattform för utrustning som används i demonstrationer, och även som
    en överdimensionerad talarstol för föreläsaren. "
;

+ Fixture 'brant+a sluttande spartansk+a obonad+e trä+säte+t/rad+en*trästolar+na rader+na säten+a' 'säten'
    "Sätena är obonade trästolar. De är inte designade för komfort,
    kanske en mindre återspegling av den övergripande Phys 1 <i>gestalten</i>. "
    isPlural = true

    dobjFor(SitOn)
    {
        verify() { }
        check()
        {
            "Det pågår ingen föreläsning just nu, och ärligt talat
            är det bekvämare att stå. ";
            exit;
        }
    }
;

+ Fixture, Readable
    'elaborerad+e skjutbar+a svart+a tavla+n/panel+en/(vägg+en)/(uppsättning+en)*tavlor+na'
    'svarta tavlor'
    "Väggen bakom labbänken är upphängd med en elaborerad uppsättning
    svarta tavlor som glider upp och ner på rullar, som dubbelhängda
    fönster. Efter att föreläsaren har fyllt en panel kan han eller hon
    skjuta upp den och dra ner en ny panel för att ersätta den. "

    readDesc = "Du ser några diverse differentialekvationer och
        integraler kvar från en nyligen genomförd föreläsning. "

    isPlural = true

    dobjFor(PushTravel)
    {
        verify()
        {
            /* we can only move the blackboards up and down */
            if (gAction.getDirection() not in (upDirection, downDirection))
                illogical('De svarta tavlorna rör sig bara upp och ner. ');
        }
        action() { "Du skjuter runt de svarta tavlorna lite för skojs skull. "; }
    }
    dobjFor(Move)
    {
        verify() { }
        action() { "Du skjuter runt de svarta tavlorna lite för skojs skull. "; }
    }
    dobjFor(Push) asDobjFor(Move)
    dobjFor(Pull) asDobjFor(Move)
;
++ Decoration
    'diverse *differential:er+ekvationer+na integraler+na formler+na'
    'formler'
    "Det är svårt att säga vad formlerna relaterar till utan att känna till
    föreläsningens sammanhang. "
    isPlural = true
;

/* ------------------------------------------------------------------------ */
/*
 *   Bridge basement - east end
 */
bridgeBasementEast: Room 'Källarhall' 'källarhallen' 'korridor'
    "Det är bara källaren, men denna korridor har en nästan
    förtryckande underjordisk känsla, som om den vore begravd
    djupt under marken: luften är fuktig och unken, belysningen
    svag, det lätt välvda taket så lågt att du inte riktigt
    kan stå rak. Korridoren fortsätter västerut och slutar i
    öster med en trappa som leder upp, tillbaka till de
    levandes land.

    <.p>En dörr märkt 021 leder söderut, och en annan numrerad
    022 leder norrut. Korridoren fortsätter västerut. "

    vocabWords = 'källare+n hall+en/korridor+en'

    south = door021
    north = door022
    up = bbeStairs
    east asExit(up)
    west = bridgeBasementWest

    roomParts = static (inherited() - defaultCeiling)
;

+ SimpleOdor
    desc = "Luften här är märkbart fuktig och unken. "
;

+ Decoration 'lågt låg+a välv+da välvt tak+et' 'tak'
    "Taket är lätt välvt, och det är så lågt att du
    måste hålla huvudet lite nedböjt för att undvika att stöta i det. "
;

+ bbeStairs: StairwayUp 'trappa+n upp+åt trapp+uppgång+en*trappor+na' 'trappor'
    "Trapporna leder uppåt. "
    isPlural = true
;

+ door021: AlwaysLockedDoor 'södra syd s 021 o21 21 dörr+en*dörrar+na' 'dörr 021'
    "Det är en bred, låg dörr, märkt med rumsnummer 021. "
    theName = 'dörr 021'
;

+ door022: LockableWithKey, Door ->blDoor
    'nord+liga norra n 022 o22 22 dörr+en*dörrar+na' 'dörr 022'
    "Det är en bred, låg dörr, märkt med rumsnummer 022. "
    theName = 'dörr 022'

    keyList = [labKey]

    /* the lab key is marked as such, so we should know it's the one */
    knownKeyList = [labKey]
;

/* ------------------------------------------------------------------------ */
/*
 *   Stamer's lab 
 */
basementLab: Room 'Labb 022' 'labbet' 'labb'
    "Detta lilla laboratorium, är fullpackad av improviserad utrustning, det
    känns det lite som att befinna sig i ett underjordiskt parkeringsgarage 
    tack vare det låga taket och betongytorna.  Rummet domineras av ett 
    stort laboratoriebord av stål som står ungefär laboratoriets center, 
    och utrustningen är uppställd runt bordet och längs väggarna.  En rad 
    hyllor på bakväggen är fyllda med ännu mer utrustning."

    vocabWords = '022 labb+et/laboratorium+et'

    south = blDoor
    out asExit(south)

    /* on first arrival, finalize Belker's setting up shop at the stack */
    afterTravel(traveler, conn)
    {
        /* do the normal work first */
        inherited(traveler, conn);

        /* if this is the first time, Belker's finished setting up now */
        if (!belkerDone)
        {
            /* the movers are done - remove them and related objects */
            PresentLater.makePresentByKeyIf(MitaMovers, nil);

            /* move belker's equipment into the game */
            PresentLater.makePresentByKey('pro3000');

            /* put belker in the stack-solving state */
            frosst.setCurState(frosstSolving);

            /* set up the new xojo to appear */
            xojo2.addToAgenda(xojoIntroAgenda);

            /* belker's now done setting up */
            belkerDone = true;
        }
    }

    /* have we finished belker's setting up yet? */
    belkerDone = nil

    roomParts = static (inherited - defaultNorthWall - defaultCeiling)
;

+ Fixture 'lågt låga tak+et' 'tak' "Taket är obehagligt lågt. "
;
+ Decoration 'betong^s+yta+n/betong^s+ytor+na' 'betongytor'
    "Allt är gjort av betong, vilket ger labbet en stark känsla av 
    ett parkeringsgarage. "
    isPlural = true
;

+ blDoor: Lockable, Door 'dörr+en' 'dörr'
    "Dörren leder ut söderut. "
;

+ Fixture, Surface 'stor+a stål+et labb laboratorium+bänk+en/bord+et' 'labbänk'
    "Bänken är tre meter på varje sida, så den tar upp större delen av
    rummet. Det är mycket utrustning på den, som alla ser ut att vara
    noggrant uppställda för ett experiment. Huvuddelen av
    experimentet är en ring av vad som ser ut som stora elektromagneter. "

    lookInDesc = "Mycket utrustning ligger på bänken, noggrant uppställd
        för ett experiment.<.p>"
;

++ calculator: Keypad, Thing, OnOffControl, QuantumItem
    '4-funktions fyra-funktions fick|räknare+n/mini|räknare+n' 'fickräknare'
    desc()
    {
        "Det är en enkel fyra-funktions fickräknare, med knappar
        för siffrorna, decimalpunkten och de aritmetiska operatorerna
        <q>+</q>, <q>-</q>, <q>*</q>, <q>/</q>, och <q>=</q>. Det finns
        också en knapp märkt <q>C</q> för <q>rensa.</q> Den är för närvarande
        <<onDesc>>";

        if (isOn)
            ", och displayen visar <q><tt><<curDisplay>></tt></q>";

        ". ";
    }

    /* it's a "pocket" calculator, after all */
    okayForPocket = true

    /* do we have our special programming-by-Jay yet? */
    isProgrammed = nil

    /* when first taken, make a comment about ethics */
    moveInto(obj)
    {
        /* rationalize purloining this item if this is the first time */
        if (!moved)
            extraReport('Tekniskt sett uppmanade Stamer dig bara att
                ta för dig av det som finns på hyllorna, men du tvivlar på att någon
                skulle ha något emot att du lånade miniräknaren för dagen.<.p>');

        /* do the normal work */
        inherited(obj);
    }

    dobjFor(TurnOn)
    {
        action()
        {
            /* turn it on */
            makeOn(true);

            /* if we're on, reset the calculator */
            if (isOn)
            {
                /* reset the calculator */
                clearKey();

                /* 
                 *   Mention that it's on, but only as a default report.
                 *   This will suppress the report if this is an implied
                 *   action, which is what we want in this case.  If we
                 *   turned on the calculator implicitly in the course of
                 *   entering a sequence of keys, it's confusing to have
                 *   the report about the display show up, since we'll
                 *   immediately chime in with the final display after
                 *   entering the keys.  
                 */
                defaultReport('Fickräknaren är nu påslagen.  På displayen
                    står det <q><tt>' + curDisplay + '</tt></q> ');

                /* if we don't have a Hovarth table yet, create one now */
                if (hovarthTab == nil)
                {
                    local e = BigNumber.getE(maxDigits);
                    local pi = BigNumber.getPi(maxDigits);
                                            
                    /* create a lookup table */
                    hovarthTab = new LookupTable(16, 32);

                    /* populate the special values */
                    hovarthTab[0.0] = new BigNumber(0, maxDigits);
                    hovarthTab[1.0] = new BigNumber(1, maxDigits);
                    hovarthTab[-1.0] = new BigNumber(-1, maxDigits);
                    hovarthTab[e] = -pi;
                    hovarthTab[-e] = pi;
                    hovarthTab[new BigNumber(infoKeys.hovarthIn, maxDigits)]
                        = new BigNumber(infoKeys.hovarthOut, maxDigits);
                }
            }
        }
    }

    /*
     *   The current mode.  The calculator can be in one of these modes:
     *   
     *   1 - digit entry mode.  Pressing a digit or the decimal point adds
     *   the digit to the display number under construction.  Pressing an
     *   operator key or the '=' key commits the number under entry to the
     *   display register, then completes the pending operation, if any.
     *   If the key is an operator, we go to mode 2; if '=', mode 3.
     *   
     *   2 - awaiting second operand.  This mode exists immediately after
     *   an operator key is pressed.  Pressing a digit key goes into digit
     *   entry mode.  Pressing an operator key replaces the pending
     *   operator with the new operator key.  Pressing the '=' key copies
     *   the first operand into the second operand and completes the
     *   pending operator, then goes to mode 3.
     *   
     *   3 - chaining calculation mode.  This mode exists after pressing
     *   the '=' button.  Pressing a digit key clears the pending operator
     *   and goes to mode 1.  Pressing an operand key copies the current
     *   display register into operand 1 and goes to mode 2.  Pressing '='
     *   copies the display register into operand 1 and repeats the last
     *   calculation, if any.
     *   
     *   4 - error mode.  This mode exists after any calculation error
     *   occurs (such as division by zero).  We display 'E' and ignore key
     *   presses except for the 'clear' key.  
     */
    curMode = 3

    /* the contents of the display */
    curDisplay = '0.'

    /* number of *digits* in the current display (not counting any '.') */
    curDisplayDigitCount()
    {
        /* 
         *   The display can only contain digits, plus zero or one decimal
         *   point, plus zero or one minus sign.  So, simply return the
         *   display length, but deduct one for the decimal point if it's
         *   present, and another one for the sign if it's present.  
         */
        return (curDisplay.length()
                - (curDisplay.find('.', 1) != nil ? 1 : 0)
                - (curDisplay.startsWith('-') ? 1 : 0));
    }

    /* is there a decimal point in the display currently? */
    curDisplayHasDecimal() { return (curDisplay.find('.', 1) != nil); }

    /* maximum number of digits in the display, and our magnitude range */
    maxDigits = 10
    maxVal =  9999999999.0
    minVal = -9999999999.0

    /*
     *   The internal registers.  dispReg is the display register; this is
     *   the internal value we are showing on the display.  firstOperand is
     *   the first operand for the next calculation, and secondOperand is
     *   the second operand.  
     */
    displayReg = static (initDisplayReg)
    firstOperand = nil
    secondOperand = nil

    /* the initial/cleared display register value */
    initDisplayReg = 0.000000000000

    /* 
     *   Pending operator.  When we press an operator key, we'll store the
     *   operator key here.  This lets us remember what operator we're
     *   supposed to perform when we finish entering the second operand
     *   and then press '=' or another operator key.  
     */
    pendingOperator = nil

    /* 
     *   when we're programmed properly, three plus's in a row kicks off
     *   the quantum Hovarth calculation 
     */
    plusCount = 0

    /*
     *   Our table of previous Hovarth results.  Whenever we hand out a
     *   Hovarth number, we'll store it here, so that if we're asked to
     *   calculate the same value again we'll give a consistent answer.
     *   Apart from the values for 0, 1, -1, e, and -e, we simply
     *   calculate large random numbers for our Hovarth numbers.  We'll
     *   initialize this the first time we turn the calculator on.  
     */
    hovarthTab = nil

    /*
     *   Apply the pending operator. 
     */
    calcPendingOperator()
    {
        local didCalc = nil;
        
        /* 
         *   if there's a pending operator, and we have both operands,
         *   carry out the operation 
         */
        if (pendingOperator != nil
            && firstOperand != nil
            && secondOperand != nil)
        {
            /* note that we're doing a calculation */
            didCalc = true;

            /* catch any errors that occur during the calculation */
            try
            {
                local a, b;
                
                /* get the two operands as BigNumbers */
                a = new BigNumber(firstOperand, maxDigits + 2);
                b = new BigNumber(secondOperand, maxDigits + 2);
                
                /* carry out the pending operator */
                switch (pendingOperator)
                {
                case '+':
                    displayReg = a + b;
                    break;
                    
                case '-':
                    displayReg = a - b;
                    break;
                    
                case '*':
                    displayReg = a * b;
                    break;
                    
                case '/':
                    displayReg = a / b;
                    break;
                }
            }
            catch (Exception exc)
            {
                /* on any error, simply go into error mode */
                curMode = 4;
            }
        }

        /* update the display to reflect the new display register */
        displayRegToDisplay();

        /* tell the caller whether or not we did a calculation */
        return didCalc;
    }

    /*
     *   Update the display to reflect the current contents of the display
     *   register. 
     */
    displayRegToDisplay()
    {
        /* if the result is outside our range, it's an error */
        if (displayReg > maxVal || displayReg < minVal)
        {
            /* we're out of range - go into error mode */
            curMode = 4;
        }

        /* if we're in error mode, simply show "E" */
        if (curMode == 4)
        {
            /* show error mode */
            curDisplay = 'E';
        }
        else
        {
            /* convert the result back to a string */
            curDisplay = displayReg.formatString(maxDigits, BignumPoint);

            /* 
             *   If it contains an exponent, it means we have a number with
             *   an absolute value so small that no significant figures
             *   will appear in the available number of digits (that is, we
             *   have a number like ".00000...").  (We know it's too small
             *   because we've already tested for the case that the
             *   magnitude is too large.)  In this case, just show the
             *   result as zero.  
             */
            if (curDisplay.find('e'))
                curDisplay = '0.';
        }
    }

    /* process the Clear key */
    clearKey()
    {
        /* reset the display to zero */
        displayReg = initDisplayReg;

        /* clear the previous operator and operands */
        firstOperand = nil;
        pendingOperator = nil;
        secondOperand = nil;
        
        /* we're now in mode 3, awaiting the start of a new calculation */
        curMode = 3;

        /* bring the display up to date with the internal status */
        displayRegToDisplay();
    }

    /* handle entry of a literal string on the calculator */
    dobjFor(EnterOn)
    {
        preCond = static (inherited + [objTurnedOn])
        verify() { }
        action()
        {
            local str;
            local gotStackNum = nil;
            
            /* remove spaces from the string */
            str = gLiteral.findReplace(' ', '', ReplaceAll, 1);

            /* ensure we have a valid string */
            if (rexMatch('[-+/*=0-9.Cc]+$', str, 1) == nil)
            {
                "Räknaren har bara sifferknapparna, decimalpunkten,
                de aritmetiska operationsknapparna (<q>+</q>, <q>-</q>,
                <q>*</q>, och <q>/</q>), samt <q>C</q>-tangenten. ";
                return;
            }

            /* process the string one character at a time */
            for (local i = 1, local len = str.length() ; i <= len ; ++i)
            {
                /* get the current character */
                local ch = str.substr(i, 1);

                /* 
                 *   if it's a plus, and we're programmed, check for the
                 *   special "+++" sequence 
                 */
                if (ch == '+' && isProgrammed)
                {
                    /* 
                     *   count the added plus; if it makes three, kick off
                     *   the special programming, otherwise just proceed
                     *   with the normal calculator functions 
                     */
                    if (++plusCount == 3)
                    {
                        /* 
                         *   If we're in the quantum machinery, and the
                         *   quantum machinery is on, reveal the Hovarth
                         *   number of the current display register;
                         *   otherwise, just shut off, since the odds of
                         *   randomly guessing the right result in
                         *   non-quantum mode are effectively zero. 
                         */
                        if (isIn(quantumPlatform) && quantumButton.isOn)
                        {
                            local res;

                            /*
                             *   If this is the stack input, we're about
                             *   to reveal the answer to the stack,
                             *   assuming no other operations are
                             *   attempted after this.  Make a note that
                             *   we found the stack number if so.  
                             */
                            gotStackNum = (displayReg ==
                                           new BigNumber(infoKeys.hovarthIn));
                            
                            /* 
                             *   Quantum mode - calculate the result.  If
                             *   we've already calculated a result for
                             *   this number before, use the same result
                             *   as last time, to create the impression
                             *   that we're calculating Hovarth numbers
                             *   for real by at least giving consistent
                             *   results.  Otherwise, pick a random
                             *   16-digit number.
                             */
                            if ((res = hovarthTab[displayReg]) == nil)
                            {
                                /* 
                                 *   Invent a random number.  Do this by
                                 *   stringing together maxDigits random
                                 *   digits.  If the input is an integer,
                                 *   make the result an integer;
                                 *   otherwise, put a decimal point
                                 *   somewhere randomly in the result. 
                                 */
                                for (local i = 1, res = '' ;
                                     i <= maxDigits ; ++i)
                                {
                                    /* add a random digit to the string */
                                    res += rand('0', '1', '2', '3', '4',
                                                '5', '6', '7', '8', '9');
                                }

                                /* turn it into a BigNumber */
                                res = new BigNumber(res, maxDigits);

                                /* 
                                 *   insert a decimal point randomly if
                                 *   the input wasn't an integer 
                                 */
                                if (displayReg.getFraction() != 0.0)
                                    res = res.scaleTen(-rand(maxDigits));

                                /* store the result */
                                hovarthTab[displayReg] = res;
                            }

                            /* make the result current */
                            displayReg = res;
                            displayRegToDisplay();

                            /* go to '=' mode with no prior operator */
                            curMode = 3;
                            pendingOperator = nil;
                        }
                        else
                        {
                            /* classical mode - simply go into error mode */
                            curMode = 4;
                            displayRegToDisplay();
                        }

                        /* we've fully handled this keystroke */
                        continue;
                    }
                }
                else
                {
                    /* 
                     *   it's either not a plus or we're not programmed;
                     *   in either case, reset the plus counter 
                     */
                    plusCount = 0;
                }

                /* see what we have */
                switch (ch)
                {
                case '0':
                case '1':
                case '2':
                case '3':
                case '4':
                case '5':
                case '6':
                case '7':
                case '8':
                case '9':
                case '.':
                    /* a digit key will remove the winning stack answer */
                    gotStackNum = nil;

                    /* digit or decimal point entry - check the mode */
                    switch (curMode)
                    {
                    case 1:
                        /* 
                         *   Digit entry mode - accept another digit.  
                         *   
                         *   If it's a decimal point, add it only if we
                         *   don't have a decimal point already.
                         *   
                         *   Otherwise, it's a digit, so add the digit to
                         *   the display as long as we have room.  Do not
                         *   allow more than maxDigits digits; if we go
                         *   over that limit, simply ignore additional
                         *   digits.  If there's a decimal point in the
                         *   display, don't count it against the digit
                         *   limit.  
                         */
                        if (ch == '.'
                            ? !curDisplayHasDecimal()
                            : curDisplayDigitCount() < maxDigits)
                            curDisplay += ch;

                        /* done */
                        break;

                    case 3:
                        /*
                         *   Chaining calculation mode.  Entering a new
                         *   number cancels the old calculation and starts
                         *   a new one.  Switch to digit entry mode, forget
                         *   any pending operator, clear the display, and
                         *   accept the digit.
                         *   
                         *   We observe that this is everything we do from
                         *   mode 2, plus clearing the pending operator -
                         *   so just clear the pending operator and fall
                         *   through to the mode 2 handling.  
                         */
                        pendingOperator = nil;

                        /* FALL THROUGH... */

                    case 2:
                        /* 
                         *   Awaiting second operand.  Enter a new number
                         *   goes back into digit entry mode to allow us to
                         *   obtain the second operand.  Simply switch to
                         *   digit entry mode, clear the display, and
                         *   accept the new digit 
                         */
                        curMode = 1;
                        curDisplay = ch;
                        break;
                    }
                    break;
                    
                case 'c':
                case 'C':
                    /* Clear key - set the display to zero */
                    clearKey();

                    /* this clears away the winning stack answer */
                    gotStackNum = nil;
                    break;

                case '*':
                case '/':
                case '+':
                case '-':
                case '=':
                    /* operator or '=' key - check the mode */
                    switch (curMode)
                    {
                    case 1:
                        /*
                         *   We're in digit entry mode.  Commit the current
                         *   display to the display register. 
                         */
                        displayReg = new BigNumber(curDisplay, maxDigits + 2);

                        /* 
                         *   the display register is the second operand of
                         *   any pending operator 
                         */
                        secondOperand = displayReg;

                        /* carry out any pending operator */
                        if (calcPendingOperator())
                        {
                            /* we've now removed the winning stack number */
                            gotStackNum = nil;
                        }

                        /* if that yielded an error, we're done */
                        if (curMode == 4)
                            break;

                        /* check if we have an operator or '=' */
                        if (ch == '=')
                        {
                            /* it's '=', so switch to mode 3 */
                            curMode = 3;
                        }
                        else
                        {
                            /* 
                             *   it's an operator, so this operator is now
                             *   pending - remember it 
                             */
                            pendingOperator = ch;

                            /* the display is the first operand */
                            firstOperand = displayReg;

                            /* switch to mode 2 - awaiting second operand */
                            curMode = 2;
                        }

                        /* done */
                        break;

                    case 2:
                        /*
                         *   We were awaiting a second operand.  If this is
                         *   an operator, simply replace the pending
                         *   operator with the new one.  If it's '=', carry
                         *   out the operator, repeating the first operand
                         *   as the second operand.  
                         */
                        if (ch == '=')
                        {
                            /* copy the first operand to the second */
                            secondOperand = firstOperand;

                            /* carry out the operation */
                            if (calcPendingOperator())
                                gotStackNum = nil;

                            /* 
                             *   if that didn't result in an error, switch
                             *   to mode 3, since we're done with the
                             *   calculation 
                             */
                            if (curMode != 4)
                                curMode = 3;
                        }
                        else
                        {
                            /* 
                             *   it's an operator, so it simply replaces
                             *   the current pending operator 
                             */
                            pendingOperator = ch;
                        }
                        break;

                    case 3:
                        /* 
                         *   Chained calculation mode - we're either
                         *   repeating the last calculation (with '=') or
                         *   applying a new operator to the last result.
                         *   In either case, the display register becomes
                         *   the first operand for the next calculation.  
                         */
                        firstOperand = displayReg;

                        /* check what we have next */
                        if (ch == '=')
                        {
                            /*
                             *   They simply want to chain the previous
                             *   calculation, which means that we repeat it
                             *   with the current display as the first
                             *   operand. 
                             */
                            if (calcPendingOperator())
                                gotStackNum = nil;
                        }
                        else
                        {
                            /*
                             *   They want to start a new calculation.
                             *   Remember the new operator as the pending
                             *   operator and switch to mode 2 to await the
                             *   second operand. 
                             */
                            pendingOperator = ch;
                            curMode = 2;
                        }
                        break;
                    }
                    break;
                }
            }

            /* 
             *   show the result; if we're in quantum mode, our message is
             *   special because of the quantum effects
             */
            if (isIn(quantumPlatform) && quantumButton.isOn)
            {
                "Din hand blir något suddig när du sträcker dig in i
                den skimrande luften över plattformen. Detta gör det
                svårt att vara säker på att du hittar rätt tangent<<
                    str.length() == 1 ? '' : 'er'>>, men du gör ditt bästa.
                Du drar tillbaka handen så snart du är klar.
                <.p>Räknarens display blir suddig, siffrorna förvandlas
                till suddiga ljusfläckar. För den delen verkar hela
                räknaren märkligt ur fokus.
                <.p>Utrustningens surrande börjar sjunka i
                tonhöjd som en turbin som varvar ner. Räknaren
                kommer plötsligt i skarpt fokus, displayen 
                visar <q><tt><<curDisplay>></tt></q>. Ljudet från
                utrustningen tonar ut och upphör sedan helt. ";
                /* this immediately turns off the equipment */
                quantumButton.isOn = nil;
            }
            else
                "Du trycker på tangent<<
                    str.length() == 1 ? 'en' : 'erna i sekvens'>>.
                Displayen visar nu <q><tt><<curDisplay>></tt></q>. ";
            /* if we got the winning stack number, say so */
            if (gotStackNum)
            {
                "<.p>Förutsatt att Jays programmering fungerade, borde detta 
                vara numret för stapeln. Nu måste du bara gå och mata in
                det i den svarta lådan. Lyckligtvis borde det vara
                relativt enkelt: tidigare, när du tittade på den
                svarta lådan med oscilloskopet, märkte du att en del
                av kretsen var en tio-nivåers spänningsdigitaliserare. Det
                måste vara inmatningsenheten. Allt du behöver är ett sätt att
                producera spänningar i rätt intervall, vilket du borde
                kunna göra med signalgeneratorn.
                <.reveal hovarth-solved> ";

                /* 
                 *   make sure the signal generator is detached from the
                 *   black box and powered off - we'll give some extra
                 *   instructions on attaching it and turning it on 
                 */
                signalGen.detachFrom(blackBox);
                signalGen.makeOn(nil);

                /* score this achievement */
                scoreMarker.awardPointsOnce();
            }
        }
    }
    dobjFor(TypeLiteralOn) asDobjFor(EnterOn)

    /* an achievement for getting the Hovarth number for the stack */
    scoreMarker: Achievement { +10 "Räkna ut Hovarths nummer" }

    /* a game-clock event for solving the hovarth puzzle */
    readPlotEvent: ClockEvent { eventTime = [2, 16, 22] }
;
+++ ComponentDeferrer, Component, Readable
    'räknar:e+display+en' 'räknardisplay'
    desc()
    {
        if (location.isOn)
            "Displayen visar för närvarande
            <q><tt><<location.curDisplay>></tt></q>. ";
        else
            "Displayen är för närvarande tom (förmodligen eftersom
            räknaren är avstängd). ";
    }
;
class CalcButton: Button, Component
    'räknare+n tangent+en/knapp+en*tangenter*knappar'

    name = perInstance('räknarens <q>' + calcStr + '</q> knapp')
    desc = "Knappen är märkt <q><<calcStr>></q>. "

    /* the string I enter on the calculator when pushed */
    calcStr = nil

    dobjFor(Push)
    {
        preCond = [touchObj]
        verify()
        {
            /* 
             *   downgrade the likelihood, since we usually don't push
             *   these buttons individually - we'd rather pick another
             *   in-scope button if there's any ambiguity 
             */
            logicalRank(80, 'group button');
        }
        action()
        {
            /* enter my string */
            nestedAction(TypeLiteralOn, location, calcStr);

            /* 
             *   if this is the first time I've been pushed, mention that
             *   it's easier to enter whole strings 
             */
            if (CalcButton.pushCount++ == 0)
                "<.p>(Istället för att trycka på en tangent i taget, så kan du
                helt enkelt ANGE en formula på kalkylatorn, om du skulle föredra det.) ";
        }
    }

    /* treat ENTER the same as pressing the button */
    dobjFor(Enter) asDobjFor(Push)

    /* class variable: number of times we've pushed a button */
    pushCount = 0

    /* defer to our collective group object for some actions */
    collectiveGroups = [calcButtonGroup]
;
+++ CalcButton '"c" "nollställ" -' calcStr = 'c';
+++ CalcButton '"+" "plus" -' calcStr = '+';
+++ CalcButton '"-" "minus" -' calcStr = '-';
+++ CalcButton '"*" "multiplicerat" -' calcStr = '*';
+++ CalcButton '"/" "dela" "dela med -' calcStr = '/';
+++ CalcButton '"=" "lika med" -' calcStr = '=';
+++ CalcButton '"." "decimalpunkt" "punkt" -' calcStr = '=';

+++ CalcButton '0 -' calcStr = '0';
+++ CalcButton '1 -' calcStr = '1';
+++ CalcButton '2 -' calcStr = '2';
+++ CalcButton '3 -' calcStr = '3';
+++ CalcButton '4 -' calcStr = '4';
+++ CalcButton '5 -' calcStr = '5';
+++ CalcButton '6 -' calcStr = '6';
+++ CalcButton '7 -' calcStr = '7';
+++ CalcButton '8 -' calcStr = '8';
+++ CalcButton '9 -' calcStr = '9';

/* a collective group for the buttons */
+++ calcButtonGroup: CollectiveGroup, Component
    'räknare tangent+en/knapp+en*tangenter+na räknar+knappar+na' 'räknarknappar'
    "Räknaren har en knapp för varje siffra, en decimal-
    punktsknapp märkt <q>.</q>, aritmetiska knappar märkta
    <q>+</q>, <q>-</q>, <q>*</q>, <q>/</q>, och <q>=</q>, samt
    en <q>C</q>-knapp. "

    isPlural = true
    /* take over Examine, Push, and Enter */
    isCollectiveAction(action, whichObj)
    {
        return (action.ofKind(ExamineAction)
                || action.ofKind(PushAction)
                || action.ofKind(EnterAction));
    }

    /* take over singular and unspecified quantities */
    isCollectiveQuant(np, requiredNum) { return requiredNum is in (nil, 1); }

    /* for Push and Enter, just say they need to say which button */
    dobjFor(Push)
    {
        verify() { logicalRank(70, 'calc button entry'); }
        action() { "(Om du vill använda kalkylatorn kan du bara 
                    ANGE en formel på den.) "; }
    }
    dobjFor(Enter) asDobjFor(Push)

    /* don't allow this collective object as a default for ENTER */
    hideFromDefault(action)
    {
        /* hide from ENTER, as well as any inherited hiding */
        return action.ofKind(EnterAction) || inherited(action);
    }
;

class ExperimentPart: CustomImmovable
    cannotTakeMsg = 'Du ville inte störa experimentet. '
;

++ ExperimentPart 'tjock+a svart+a elektronisk:t+a elektrisk:t+a kablage+t/ledning+en*(kablar+na) ledningar+na'
    'elektroniskt kablage'
    "Kablarna är enorma; de måste kunna bära mycket ström. "
;

++ quantumButton: ExperimentPart
    'jätte+stor+a grön+a elektrisk+a svamp+knapp+en/anslutning^s+knapp+en/(låda+n)'
    'grön svampknapp'
    "Det är en fem centimeter i diameter grön svampknapp, som de stora
    nödstoppsknapparna på industriell utrustning. Den är en del av
    vad som ser ut som en elektrisk kopplingsdosa, som är fäst vid
    den andra utrustningen med en av samma tjocka svarta kablar
    som förbinder elektromagneterna. "

    dobjFor(TurnOn) asDobjFor(Push)
    dobjFor(Push)
    {
        verify() { }
        action()
        {
            local plc;
            
            /* if I'm already on, nothing extra happens */
            if (isOn)
            {
                "Utrustningen fortsätter att surra, men inget mer
                verkar hända. ";
                return;
            }

            /* start the show */
            "Du trycker ner den jättestora knappen. Det hörs omedelbart
            ett dunk någonstans i rummet, sedan ett djupt brummande
            ljud som gradvis stiger i tonhöjd. Brummandet fortsätter
            att stiga och bli högre tills det låter som en bil-
            tuta.
            <.p>Luften över glasplattformen i mitten av
            magnetringen börjar skimra. ";

            /* check to see if we have a special item on the dinner plate */
            if ((plc = quantumPlatform.contents).length() == 0
                || !plc[1].ofKind(QuantumItem))
            {
                /* 
                 *   There's nothing special on the plate.  To avoid
                 *   having to describe quantum effects for everything,
                 *   simply power down the machine immediately.  
                 */
                "<.p>Maskineriet fortsätter att surra i några ögonblick,
                sedan börjar ljudet sjunka i tonhöjd som en turbin
                som varvar ner, tills det upphör helt. ";
            }
            else
            {
                /* 
                 *   we have a quantum item on the dinner plate, so we get
                 *   the full show: start up the machine, leave it running
                 *   for one turn, and set up a fuse to stop us once the
                 *   one turn is up 
                 */

                /* set up the fuse to turn us off in one turn */
                new SenseFuse(self, &turnOff, 1, self, sight);

                /* note that we're on */
                isOn = true;
            }
        }
    }

    /* fuse - turn off the machine */
    turnOff()
    {
        /* 
         *   if we haven't already turned off by virtue of having done
         *   something special to what's on the platform, show a message
         */
        if (isOn)
        {
            "<.p>Ljudet från experimentets maskineri börjar
            sjunka i tonhöjd som en turbin som varvar ner. Efter några
            ögonblick till upphör det helt. ";

            /* we're no longer on */
            isOn = nil;
        }
    }

    afterAction()
    {
        /* 
         *   if we examined something that's on the platform, and we're
         *   turned on, mention the shimmering air 
         */
        if (isOn
            && gActionIs(Examine)
            && (gDobj.isIn(quantumPlatform) || gDobj == quantumPlatform))
            "<.p>Luften runt omkring {ref dobj/honom} skimrar
            märkligt. ";
    }

    /* did we turn the equipment on? */
    isOn = nil
;

+++ SimpleNoise
    desc = "Experimentets maskineri brummar högt. Det låter
        som ett närliggande bilhorn. "
        
    /* we're only here if the machine is on */
    soundPresence = (location.isOn)
;

/* 
 *   a class for an item with special quantum behavior when on the
 *   experimental platform 
 */
class QuantumItem: object;

++ ExperimentPart
    'fin:a+trådad+e metall+en däckstorlek+en däck+stora experiment+et/(ring+en)/spole+n/spolar+na/(tråd+en)/
    rör+et/maskin+en/maskineri+et*rör+en ramar+na elektro|magneter+na'
    'ring av elektromagneter'
    "Experimentets fokus verkar vara en ring av ungefär ett dussin
    stora enheter som förmodligen är elektromagneter---däckstora spolar av
    fin tråd lindad runt och genom ramar av metallrör,
    med en trasslig massa av tjocka svarta elektriska kablar som sammankopplar
    dem och den övriga utrustningen. En av kablarna leder till en
    elektrisk kopplingsdosa med en stor grön svampknapp som sticker ut.
    En glasplattform som ser ut som en tallrik är i mitten
    av ringen. "
    
    isPlural = true

    /* 
     *   specifically show the contents of the platform as part of our
     *   Examine description - it doesn't normally show its contents as
     *   part of room or container descriptions, but we want to override
     *   that here to show the contents 
     */
    examineStatus()
    {
        /* specifically show the contents of the platform */
        "<.p>";
        quantumPlatform.examineListContents();
    }
;

+++ quantumPlatform: ExperimentPart, Surface
    'tjock+a tallrik:en^s+stor+a rund+a klar+a glas+aktiga glas+plattform+en/platta+n/pelare+n' 'glasplattform'
    "Plattformen verkar vara av klart glas. Den är ungefär lika stor och
    formad som en tallrik, och den är upphöjd några centimeter över
    bänkens yta av en tjock glaspelare. "

    /* only allow one thing at a time on the platform */
    iobjFor(PutOn) { preCond { return inherited() + objEmpty; }}

    /* only allow small objects */
    maxSingleBulk = 1

    /* 
     *   don't show my contents in the room description; this is pretty
     *   deeply buried in a cluttered room, so it doesn't make sense to
     *   mention our contents until we're examined specifically 
     */
    contentsListed = nil
;

++++ QuantumItem, Thing, Container 'klar+a plast+iga tärning+en tärnings|-o-matic/plast+kupol+en'
    name = (described ? 'tärnings-o-matic' : 'klar plastkupol')
    desc = "Det är en kupol av klar plast med <q>Tärnings-O-Matic</q>
        svagt ingraverat på toppen. Inuti finns två sexsidiga
        tärningar.
        <.p>Du kan inte komma ihåg vilket det är, men det finns ett
        klassiskt brädspel som kom med Tärnings-O-Matic. Du
        trycker bara ner på kupolen, och en liten fjäderbelastad
        mekanism i botten kastar upp tärningarna i luften. "

    /* we're transparent but unopenable */
    material = glass
    isOpen = nil

    /* don't show my contents in container/room listings */
    contentsListed = nil

    dobjFor(Roll) asDobjFor(Push)
    dobjFor(Push)
    {
        verify() { }
        action()
        {
            /* select new values */
            die1 = rand(6) + 1;
            die2 = rand(6) + 1;

            /* check to see if we do quantum rolling */
            if (isIn(quantumPlatform) && quantumButton.isOn)
            {
                "Det är lite konstigt att sträcka sig in i den skimrande
                luften över plattformen; din hand verkar bli
                lite suddig. Du trycker ner på kupolen---du
                försöker i alla fall; det är faktiskt ganska svårt att avgöra,
                med allt som blir suddigare och suddigare och
                din hand som kittlar och känns märkligt frånkopplad
                från din arm.
                <.p>Du rycker bort handen från Tärnings-O-Matic
                och ser bara en suddig massa av tärningar inuti---inte den typ av
                suddighet du skulle se om de rörde sig riktigt snabbt, utan
                den typ du ser när du är skelögd, eller i ett fotografi
                som har exponerats om och om igen. Du kan tydligt
                se dussintals olika tärningar som ligger där, andra
                som tumlar, andra som studsar, alla delar den lilla
                bubblan och överlappar som spöken.
                <.p>Utrustningens brummande börjar sjunka
                i tonhöjd som en turbin som varvar ner, och upphör sedan
                helt. Röran av spöklika tärningar blir
                två vanliga tärningar som visar <<die1>> och <<die2>>;
                förändringen är plötslig och odramatisk, som om
                dina ögon bara plötsligt kom i fokus. ";

                /* this immediately turns off the equipment */
                quantumButton.isOn = nil;
            }
            else
                "Du trycker ner på kupolen tills den klickar, sedan
                släpper du. Tärningarna hoppar upp i luften, tumlar runt
                inuti kupolen ett ögonblick och landar och visar <<die1>>
                och <<die2>>. ";
        }
    }

    /* the numbers shown on my dice */
    die1 = 3
    die2 = 1

    /* 
     *   Do not list my contents when I'm described - we show them
     *   specifically as part of the description, and they never change,
     *   so we don't need to list them separately here.  
     */
    examineListContents() { }
;
+++++ Thing 'vit+a sexsidig+a par+et*tärningar+na' 'tärningar'
    "De är vita sexsidiga tärningar som du skulle hitta förpackade
    i vilket brädspel som helst. De visar för närvarande <<location.die1>>
    och <<location.die2>>. "
    isPlural = true

    /* to roll the dice, push on the dome */
    dobjFor(Roll) remapTo(Push, location)
;

++ researchReport: Readable
    'ljusblå+a stamers sjätte 6 forskning^s+rapport+en/forsknings|artikel+en/rapport+en|mapp+en/utkast+et'
    name = (isRead ? 'forskningsartikel' : 'rapportmapp')

    desc = "Det är en ljusblå rapportmapp, med <q>UTKAST 6</q>
        skrivet över omslaget. Rapporten inuti ser ut
        att vara omkring trettio sidor. "

    /* make an ethical comment when first taken */
    moveInto(obj)
    {
        /* rationalize it */
        if (!moved)
            extraReport('Du tänker att ingen kommer att behöva den idag; du
                måste bara komma ihåg att lämna tillbaka den senare.<.p>');
        
        /* do the normal work */
        inherited(obj);
    }

    readDesc()
    {
        local extraRef = nil;
        
        "<q>Spindekorrelerande och bulkmateria dekoherens
        isolering - UTKAST.</q> Det verkar vara ett nytt utkast av
        en forskningsartikel som Stamers labbgrupp arbetar med.<.p>";

        /* check our background knowledge */
        if (gRevealed('decoherence')
            && gRevealed('spin-decorr')
            && gRevealed('QM-intro'))
        {
            /* we have the full background, so we can understand a lot */
            "Delar av artikeln är långt bortom din förståelse av
            ämnet, men all bakgrundsläsning du har gjort
            låter dig faktiskt följa mycket av materialet. Stamers
            grupp arbetar tydligen på ett sätt att förhindra ett kvantsystem
            från att <q>dekoherera,</q> inte bara när det kommer i
            kontakt med sin omgivning, utan när delar av systemet
            själv interagerar med varandra. Enligt artikeln
            har de framgångsrikt undertryckt dekoherens under en
            period av sekunder i taget genom tiotals gram av
            material---uppenbarligen ganska häpnadsväckande resultat i ett område
            som vanligtvis räknas i femtosekunder och pikogram.
            De hoppas kunna använda detta för att skapa storskaliga kvantdatorer
            byggda av vanliga komponenter.
            <.p>I slutet finns några bibliografiska referenser, inklusive
            det <q>introducerande</q> material du redan har sett: ";

            /* award some points for this */
            scoreMarker.awardPointsOnce();

            /* show the extra reference */
            extraRef = true;
        }
        else if (gRevealed('decoherence')
                 || gRevealed('spin-decorr')
                 || gRevealed('QM-intro'))
        {
            /* some background - we understand a bit, but not all */
            "Det hjälper lite att du har läst lite bakgrundsmaterial;
            åtminstone vet du nu vad några av orden betyder och kan 
            följa delar av artikeln.  Du ser att det har mycket att 
            göra med kvantberäkningar, men du förstår fortfarande inte 
            vad det betyder.  Du går återigen till referenserna i 
            slutet och skummar igenom de som kallas 
            <q>introducerande</q>: ";
        }
        else
        {
            /* we have no background - we're basically baffled */
            "Du kommer ungefär halvvägs in i sammanfattningen innan du
            inser att du inte har någon aning om vad det handlar om. Du bläddrar
            igenom artikeln lite, men det enda du verkligen kommer ihåg om
            kvantfysik är lite om halvledarens bandgap från EE 11.
            <.p>I slutet finns en massa bibliografiska referenser som
            mestadels ser lika skrämmande ut som själva artikeln, även om
            ett par kallas <q>introducerande</q>: ";
        }

        "en artikel i tidskriften <i>Quantum Review Letters</i> nummer
        70:11c, en artikel i <i>Science &amp; Progress</i> tidningen
        nummer XLVI-3, och ett kapitel i en lärobok, <i>Introduktion till
        Kvantfysik</i> av Bl&ouml;mner.
        <.reveal bibliography> ";

        /* show the extra reference if appropriate */
        if (extraRef)
            "<.p>Du märker en referens till en annan artikel av Stamers
            grupp, denna publicerad i <i>Quantum Review Letters</i>
            nummer 73:9a.<.reveal understood-stamer-article> ";
    }

    /* 
     *   Reveal one of the report references, then check for comprehension.
     *   Each time we read one of the introductory references, we'll call
     *   this to check to see if we've read enough background information.
     *   If so, we'll mention specifically that we should go back and read
     *   through the report again, since doing so reveals a key clue.  
     */
    checkComprehension(topic)
    {
        /* first, reveal the topic */
        gReveal(topic);
        
        /* 
         *   Now, if all intro knowledge has been revealed, mention that we
         *   now want to go back and read the report again.  Don't do this
         *   if we've already gone back and read the report, though, for
         *   obvious reasons.  
         */
        if (gRevealed('decoherence')
            && gRevealed('spin-decorr')
            && gRevealed('QM-intro')
            && !gRevealed('understood-stamer-article'))
            "<.p>Du känner att du börjar förstå några av
            idéerna i Stamers forskningsrapport. Du gör en mental
            notering om att gå tillbaka och läsa rapporten igen mer detaljerat,
            när du har tid. ";
    }

    /* points for understanding the paper */
    scoreMarker: Achievement { +5 "att förstå forskningsrapporten" }

    /* OPEN REPORT is just like reading it, as is LOOK IN REPORT */
    dobjFor(Open) asDobjFor(Read)
    dobjFor(LookIn) asDobjFor(Read)

    /* on reading, note that we've been read */
    dobjFor(Read)
    {
        action()
        {
            inherited();
            isRead = true;
        }
    }

    isRead = nil
;

++ Decoration
    'improviserad+e signal+genererande elektronisk+a vakuum+pump+en klämd+a extra utrustning+en/bit+en/oscilloskop+et/mätare+n/instrument+et/pump+en/laser+n/steg+motor+n/nätaggregat+et/mikroskop+et/del+en/panel+en/innanmäte+t/enhet+en/
    *enheter+na innanmäten+a bitar+na generatorer+na mätarna paneler+na delar+na instrument+en nätaggregat+en stegmotorer+na motorer+na lasrar+na'
    'utrustning'
    "Det mesta av utrustningen runt labbet är elektronisk---signalgeneratorer, 
    oscilloskop, olika mätare och instrument, nätaggregat.
    Det finns också en vakuumpump, ett par lasrar, stegmotorer,
    och ett mikroskop. Många av enheterna ser ut som om de har
    modifierats: paneler saknas, vilket exponerar utrustningens innanmäten,
    och extra delar har lagts till och klämts fast. "

    isMassNoun = true
    notImportantMsg = 'Du vill inte störa något, eftersom det
         allt förmodligen är uppställt för ett experiment. '

    /* 
     *   This object represents equipment all over the room, including on
     *   the shelves.  So, we're nominally in the room, on the shelves,
     *   and on the bench.  (This is important mostly because it lets the
     *   player refer to us as EQUIPMENT ON SHELVES.)  
     */
    isNominallyIn(obj) { return inherited(obj) || obj == blShelves; }
;

+ Fixture 'bakre norr+a n vägg+en*väggar+na' 'norra väggen'
    "En uppsättning metallhyllor är fästa på den norra väggen. "
;

++ blShelves: Fixture, Surface 'metall|hylla+n*metall|hyllor+na' 'hyllor'
    "Metallhyllorna är fästa på den norra väggen och sträcker sig
    hela vägen upp till det låga taket. Precis som alla andra horisontella
    ytor i labbet är hyllorna packade med utrustning. "
    isPlural = true

    /* 
     *   Use a special prefix message for listing our contents (either by
     *   EXAMINE or LOOK IN) - this lets us add the extra equipment we want
     *   to mention but which we don't really implement.  
     */
    descContentsLister: surfaceDescContentsLister {
        showListPrefixWide(itemCount, pov, parent)
            { "Bland högarna av utrustning lägger du märke till "; }
    }
    lookInLister: surfaceLookInLister {
        showListPrefixWide(itemCount, pov, parent)
            { "Bland högarna av utrustning lägger du märke till "; }
    }

    /* don't show our contents with the room message */
    contentsListed = nil
;

/*
 *   A mix-in class for the special equipment items on the shelf in the
 *   lab.  When we first move one of these items, we'll discover the
 *   entangled camera. 
 */
class LabShelfItem: object
    /* when we first move it, find the camera if we haven't already */
    moveInto(obj)
    {
        /* do the normal work first */
        inherited(obj);

        /* 
         *   Check for finding the camera.  Do this after we've moved the
         *   object, in case there are any side effects of moving it; the
         *   disentangling comes essentially after we've done most of the
         *   normal moving already, so it works better if this comes after
         *   any messages generated while moving the object. 
         */
        if (!spy9.isFound)
        {
            local moveObj = self;
            gMessageParams(moveObj);

            extraReport('Du börjar lyfta {ref moveObj/honom} från hyllan, 
                men {det/han} fastnar på någonting. Du känner efter på
                sidorna och hittar några trassliga sladdar, och lyckas till 
                slut få loss {den/honom}. När du drar bort {det/honom} 
                från hyllan, lägger du märke till en liten vit boll, 
                ansluten till en blå kabel, som faller ner på hyllan.');

            /* mark the camera as found, and move it here */
            spy9.isFound = true;
            spy9.makePresent();
        }
        
        /* if we've acquired all of the needed devices, award some points */
        if (!blackBox.equipHintNeeded)
            scoreMarker.awardPointsOnce();
    }

    scoreMarker: Achievement { +2 "samla ihop testutrustningen" }
;
    

/*
 *   A class for the testing gear (oscilloscope, signal generator).  These
 *   objects can be attached to testable equipment; they have to be
 *   located right next to the equipment being tested (i.e., in the same
 *   container), which we enforce by making these NearbyAttachable
 *   objects.  
 */
class TestGear: PlugAttachable, NearbyAttachable
    /* we can attach to anything that's a test-gear-attachable object */
    canAttachTo(obj)
    {
        return obj.ofKind(TestGearAttachable) || obj.ofKind(TestGear);
    }
    explainCannotAttachTo(other)
    {
        gMessageParams(self, other);
        "{Ref other/den} verkar inte ha någon passande 
        plats att ansluta till {den self/honom}. ";
    }

    /* 
     *   We can only be attached to one thing at once, so add a
     *   precondition to ATTACH TO requiring that we're not attached to
     *   anything.
     */
    dobjFor(FastenTo) asDobjFor(AttachTo) 
    dobjFor(AttachTo) { preCond = (inherited() + objNotAttached) }
    iobjFor(AttachTo) { preCond = (inherited() + objNotAttached) }

    /* for electrical safety, turn off the test equipment before unplugging */
    dobjFor(Detach) { preCond = (inherited() + objTurnedOff) }
    dobjFor(DetachFrom) { preCond = (inherited() + objTurnedOff) }
    iobjFor(DetachFrom) { preCond = (inherited() + objTurnedOff) }

    /* USE ON is the same as ATTACH TO for us */
    dobjFor(UseOn) remapTo(AttachTo, self, IndirectObject)
    iobjFor(UseOn) remapTo(AttachTo, DirectObject, self)

    /* TEST obj WITH gear is the same as ATTACH gear TO obj */
    iobjFor(TestWith) remapTo(AttachTo, self, DirectObject)

    /* 
     *   Get the equipment we're attached to.  We can only be attached to
     *   one thing at a time, other than our permanent attachments, so this
     *   returns either nil or the single piece of equipment we're probing.
     */
    getAttachedEquipment()
    {
        local lst;

        /* get the list of non-permanent attachments */
        lst = attachedObjects.subset({x: !isPermanentlyAttachedTo(x)});

        /* 
         *   there can be no more than one, so if we have anything in our
         *   list, return the first one; if not, return nil 
         */
        return (lst.length() != 0 ? lst[1] : nil);
    }

    /* show what happens when we probe with the oscilloscope */
    probeWithScope() { "Oscilloskopets skärm visar bara en platt linje. "; }

    /* show what happens we we turn on the signal generator attached here */
    turnOnSignalGen() { }
;

/*
 *   Our test gear tends to have attached connectors.  We include these for
 *   completeness; they really don't do much apart from reflect commands
 *   back to the test gear container. 
 */
class PluggableComponent: PlugAttachable, Component
    /* attaching the probe really attaches the containing test gear */
    dobjFor(AttachTo) remapTo(AttachTo, location, IndirectObject)
    iobjFor(AttachTo) remapTo(AttachTo, DirectObject, location)

    /* using the probe on something attaches it */
    dobjFor(UseOn) remapTo(UseOn, location, IndirectObject)
    iobjFor(UseOn) remapTo(UseOn, DirectObject, location)

    /* defer to the parent for status, for the attachment list */
    examineStatus() { location.examineStatus(); }
;

/* 
 *   a probe for a piece of test gear - this is a test gear component
 *   that's also a permanent attachment child 
 */
class TestGearProbe: PermanentAttachmentChild, PluggableComponent
    /* putting the probe on something is equivalent to attaching it */
    dobjFor(PutOn) remapTo(AttachTo, location, IndirectObject)
;

/*
 *   A class representing objects that can attach to the testing gear
 *   (such as the oscilloscope and the signal generator).  These are all
 *   NearbyAttachments, because the test gear has to be placed right next
 *   to them (i.e., in the same container) to be attached.  Apart from
 *   making the object attachable, this is essentially just a marker class
 *   that we recognize in the test gear, to make sure that the object is
 *   something the scope can attach to.  
 */
class TestGearAttachable: NearbyAttachable
    /* show what happens when we probe with the oscilloscope */
    probeWithScope() { "Oscilloskopets skärm visar bara en platt linje. "; }

    /* show what happens when we attach the signal generator */
    probeWithSignalGen() { }

    /* show what happens we we turn on the signal generator attached here */
    turnOnSignalGen() { }

    iobjFor(FastenTo) asIobjFor(AttachTo) 
    /* testing this kind of thing is likely */
    dobjFor(TestObj) { verify() { } }

    /*
     *   These objects are always the "major" items when attached to test
     *   gear: "the oscilloscope is attached to the box," not vice versa.  
     */
    isMajorItemFor(obj) { return obj.ofKind(TestGear); }
;

/* a transient object to keep track of our scope notes per session */
+++ transient oscilloscopeNoteTracker: object
    noteCount = 0
;

+++ oscilloscope: LabShelfItem, TestGear, OnOffControl
    'portab:elt+la solid-state oscillo|skop+et/skop+et' 'oscilloskop'
    "Detta är en relativt liten solid-state modell, lätt att bära med sig.
    På ovansidan finns en displayskärm och kontrollerna, och en sond
    är ansluten med en koaxialkabel. <<screenDesc>> "

    /* this item is a little larger than the default */
    bulk = 2

    /* make it a precondition of attaching that we're turned on */
    dobjFor(AttachTo) { preCond = (inherited() + objTurnedOn) }
    iobjFor(AttachTo) { preCond = (inherited() + objTurnedOn) }

    /* handle attaching to another object */
    handleAttach(other)
    {
        /*
         *   If they're saying something about PLUG or ATTACH, note that
         *   we can't actually attach the scope to anything, to avoid
         *   confusion.  To avoid being annoying, have this note show up
         *   only a few times each session.  
         */
        if (rexSearch('fäst|koppla|sätt', gAction.getOrigText()) != nil
           && oscilloscopeNoteTracker.noteCount++ < 3)
            "(Observera att du inte kan permanent fästa oscilloskopet på
            något, eftersom dess nålspets endast tillåter momentan
            kontakt med kretsen du undersöker.)<.p>";
        
        /* let the other object tell us what happens */
        other.probeWithScope();

        /* 
         *   We don't actually stay attached; attaching to us is just
         *   momentary probing.  So mark us as no longer attached.
         */
        detachFrom(other);
    }

    screenDesc()
    {
        if (!isOn)
            "Oscilloskopet är för närvarande avstängt. ";
        else
            "Displayen visar en platt linje. ";
    }

    //dobjFor(Switch) asDobjFor(TurnOn) // TODO
    dobjFor(TurnOn)
    {
        action()
        {
            /* 
             *   announce this only if we're an explicit action; turning
             *   the scope on is a pretty simple action, so it's not worth
             *   a mention when it's done incidentally to another action 
             */
            if (!gAction.isImplicit)
            {
                "Du slår på oscilloskopet, och det vaknar till liv 
                nästan ögonblickligen. ";

                if (timesOn++ == 0)
                    "Du justerar kontrollerna lite och får en trevlig 
                    platt linje; det ser ut som att det fungerar som 
                    det ska, Åtminstone så vitt du kan se utan att 
                    ansluta det till något.";
            }

            /* mark it as on */
            makeOn(true);
        }
    }

    /* number of times we've turned it on */
    timesOn = 0

    dobjFor(TurnOff)
    {
        action()
        {
            /* do the normal work */
            inherited();

            /* 
             *   if we're not running as an implied action, mention that
             *   the screen goes dark 
             */
            if (!gAction.isImplicit)
                "Du stänger av oscilloskopet, och skärmen blir mörk. ";
        }
    }
;
++++ Component
    //'(oscilloskopets) (skopets) oscilloskops|kontroll+en*oscilloskops|kontroller+na'
    '(oscillo|skopets) kontroll+en*kontroller+na'
    'oscilloskopkontroller'
    "Kontrollerna låter dig slå på och stänga av oscilloskopet, och göra
    olika justeringar av displayen, såsom tids- och spänningsskalor
    och DC-offset. "

    dobjFor(Push)
    {
        verify() { }
        action() { "Du behöver inte göra några justeringar av
            oscilloskopinställningarna just nu. "; }
    }
    dobjFor(Pull) asDobjFor(Push)
    dobjFor(Turn) asDobjFor(Push)
    dobjFor(Move) asDobjFor(Push)
;
++++ Component
    '(oscilloskop+ets) (skop+ets) oscilloskop^s+skärm+en/oscilloskop^s+display+en' 'oscilloskopsdisplay'
    desc()
    {
        if (location.isOn)
            location.screenDesc();
        else
            "Skärmen är tom. ";
    }

    isOn = nil
;
++++ ComponentDeferrer, TestGearProbe
    '(oscilloskop+ets) (skop) lång+a metall+en koaxial+en isolerad+e vass+a spetsig+a ände+n
    oscilloskop:et^s+prob+en/grepp+et/prob+en/kabel+n/metall+stift+et/(spets+en)'
    'oscilloskopssond'
    "Sonden består av ett isolerat grepp med en två tum lång metallstift
    som sticker ut. Stiftet har en vass, spetsig ände för att möjliggöra exakt
    positionering när man arbetar med små kretsar. Sonden är
    ansluten till oscilloskopet med en koaxialkabel. "
;

+++ signalGen: LabShelfItem, TestGear, OnOffControl
    'signal+en signal|generator+n/funktions|generator+n' 'signalgenerator'
    "Signalgeneratorn låter dig mata olika vågformer in i en
    krets, för att testa hur kretsen beter sig elektriskt. Detta är
    en kompakt modell, i storlek med en inbunden bok. Den har en uppsättning
    knappar på framsidan, en amplitudknapp och en kontakt. Den är
    för närvarande <<onDesc>>. "

    /* this item is a little larger than the default */
    bulk = 2

    probeWithScope()
    {
        if (isOn)
            "Du kör igenom några olika vågformsmönster på
            signalgeneratorn för att kontrollera att de alla visas korrekt
            på oscilloskopet. Allt ser bra ut. ";
        else
            inherited();
    }

    handleAttach(other)
    {
        /* let the other equipment handle it */
        other.probeWithSignalGen();
    }

    killDaemon()
    {
        /* kill the data entry daemon if it's running */
        eventManager.removeMatchingEvents(blackBox, &digitEntryDaemon);
    }

    handleDetach(other)
    {
        /* on detaching, kill the data entry daemon */
        killDaemon();
    }

    dobjFor(TurnOn)
    {
        action()
        {
            local equip = getAttachedEquipment();

            /* switch it on */
            "Du slår på signalgeneratorn. ";
            makeOn(true);
            
            /* if we're attached to anything, let it know */
            if (equip != nil)
                equip.turnOnSignalGen();
        }
    }

    dobjFor(TypeLiteralOn)
    {
        verify() { logicalRank(50, 'inte en knappsats'); }
        action()
        {
            "Signalgeneratorn har inget som liknar en knappsats,
            men den har en ratt som du kan vrida till olika inställningar. ";
        }
    }
    dobjFor(EnterOn) asDobjFor(TypeLiteralOn)
    dobjFor(TypeOn) asDobjFor(TypeLiteralOn)
;
++++ signalGenKnob: NumberedDial, Component
    '(signal+ens) (generator+ns) amplitud+ratt+en/amplitud+vred+et' 'amplitudratt'
    "Det är en ratt numrerad från 0 till 9. Den justerar spänningsnivån
    på signalen som genereras, inom det intervall som valts av de
    aktuella vågformsparametrarna. Den är för närvarande inställd på <<curSetting>>. "
    curSetting = '3'
    minSetting = 0
    maxSetting = 9

    /* handle ENTER ON as TURN TO */
    dobjFor(EnterOn) asDobjFor(TurnTo)
;
++++ Component '(signal+ens) (signal+generator+ns) knapp+uppsättning+en*knappar+na'
    'signalgeneratorns knappar'
    "Knapparna låter dig välja formen på vågformen som
    genereras och justera dess parametrar. "
    isPlural = true

    dobjFor(Push)
    {
        verify()
        {
            /* 
             *   we never really need to push these buttons, so downgrade
             *   them in the logical rankings 
             */
            logicalRank(50, 'decoration-only');
        }
        
        action() { "Det finns inga ändringar du behöver göra på
            signalgeneratorns utdata just nu. "; }
    }
;
++++ TestGearProbe
    '(signal+ens) (signal+generator+s) kontakt+en/ledning+en*ledningar+na'
    'signalgeneratorns kontakt'
    "Kontakten är en enkel uppsättning ledningar anslutna till
    signalgeneratorn. "
;

+++ spy9: PresentLater, PermanentAttachment, Immovable
    'li:ten+lla vit+a plast+iga spy-9 kamera+n/boll+en'
    name = (described ? 'SPY-9-kamera' : 'liten vit boll')
    shortName = (described ? 'kamera' : 'vit plastboll')
    desc = "Det är en liten vit boll, ungefär i storlek med en golfboll
        men gjord av slät plast. En blå nätverkskabel kommer ut
        från baksidan, och <<
          described
          ? "en liten lins är framtill. Du känner igen den som en
            SPY-9-kamera"
          : "det finns en liten klar fläck framtill---en lins. Du
            inser plötsligt vad detta är: det är en SPY-9-kamera"
          >>, den avskyvärdiga produkten som marknadsförs med en oändlig ström
        av pop-up-annonser på internet, designad för sådana dygdiga användningsområden som
        att spionera på din barnvakt, make/maka, anställda, chef eller damernas
        omklädningsrum. "

    /* 
     *   it's immovable, but this isn't obvious looking at it, so list it
     *   as though it were portable 
     */
    isListedInContents = true
    
    /* we haven't found it yet */
    isFound = nil

    /* we can't be moved because of the cable tethering us to the wall */
    cannotTakeMsg = 'Du kan inte få loss {ref dobj/honom} från kabeln. '
    cannotMoveMsg = 'Kabeln låter dig inte flytta {ref dobj/honom} mer
        än några centimeter. '
    cannotPutMsg = (cannotTakeMsg)

    /* we can't detach from the cable */
    cannotDetachMsg(obj)
    {
        return 'Det finns inget uppenbart sätt att koppla bort kabeln; den verkar
            vara en integrerad del av ' + theNameObj + '. ';
    }

    /* pulling on the camera is just like pulling on the wire */
    dobjFor(Pull) remapTo(Pull, spy9Wire)
;
++++ Component 'klar+a li:ten+lla (kamera+ns) (spy-9) kamera+lins+en/fläck+en/(kamera+lins+ens)' 'spy-9-lins'
    "Det är kamerans lilla lins. "
;
++++ spy9Wire: PermanentAttachment, Immovable
    '(spy-9) (kamera+ns) blå+a nätverks|kabel+n/nätverks|sladd+en/isolering+en' 'nätverkskabel'
    "Den ser ut som en ganska standard blå nätverkskabel. Den verkar vara
    fast ansluten till <<location.shortName>>, och i andra änden
    går den in i en väggplatta. Märkligt nog går den direkt genom
    väggplattan---det finns ingen kontakt. Den här kabeln går förmodligen hela vägen
    till kopplingsskåpet nere i källaren. <<tagNote>> "

    tagNote()
    {
        /* add a note about the tag if the tag has been exposed */
        if (spy9Tag.isIn(self))
            "En ljusgrön etikett, markerad med siffrorna
            <<infoKeys.spy9JobNumber>>, är lindad runt kabeln nära väggplattan.";
    }

    dobjFor(Pull)
    {
        verify() { }
        action()
        {
            if (bwirBlueWire.location == nil)
            {
                "Du drar bort vajern från väggplattan, inte hårt 
                tillräckligt för att ta sönder det, men tillräckligt 
                för att ta upp eventuellt slack i ledningarna bakom väggen. 
                Du drar i den ett par tum, och en liten pappersetikett 
                lindad runt tråd hoppar ut bakom väggplattan. Du får 
                ett par centimeter tråd till innan slacket tar slut. ";

                /* reveal the tag */
                spy9Tag.makePresent();

                /* reveal the wire in the sub-basement */
                bwirBlueWire.makePresent();
                bwirHole.makePresent();
            }
            else
                "Du ger den ett ryck, men det finns inget mer spel kvar i kabeln. ";

        }
    }

    cannotTakeMsg = 'Kabeln matas genom väggplattan; det finns inget 
                    uppenbart sätt att ta bort det. '

    cannotMoveMsg = 'Det är väldigt lite spel i kabeln. '
    cannotPutMsg = (cannotTakeMsg)

    attachedObjects = [spy9, spy9WallPlate]
    cannotDetachMsg(obj)
    {
        return (obj == nil
                ? 'Kabeln verkar vara permanent ansluten. '
                : obj.cannotDetachMsg(self));
    }

    dobjFor(Follow)
    {
        verify() { logicalRank(50, 'not followable'); }
        action() { "Du kan bara följa den så långt som fram till väggplattan. "; }
    }
;
+++++ spy9Tag: PresentLater, PermanentAttachment, CustomImmovable, Readable
    'ljusgrön+a li:ten+lla papper:et^s+lapp+en/etikett+en' 'papperslapp'
    "Den ljusgröna lappen är märkt med siffrorna
    <<infoKeys.spy9JobNumber>>. Du kan också urskilja svag, liten
    text på kanten som lyder <q>NIC.</q> Lappen är vikt över
    kabeln och limmad på plats med ett starkt lim. "

    attachedObjects = [spy9Wire]
    cannotDetachMsg(obj) { return cannotTakeMsg; }
    cannotTakeMsg = 'Lappen verkar vara ordentligt fastklistrad på kabeln. '
;
    
++++ spy9WallPlate: PermanentAttachment, Fixture
    'väggplatta+n' 'väggplatta'
    "Den blå kabeln går in i väggplattan utan någon kontakt eller
    anslutning. Någon måste ha satt upp detta som en del av rummets
    kabeldragning av någon anledning---kabeln måste gå hela vägen ner till
    kopplingsskåpet i källaren. "

    cannotDetachMsg(obj) { return 'Kabeln går in i väggplattan
        utan någon uppenbar kontakt, så det finns inget sätt att koppla loss den. '; }

    dobjFor(LookBehind) { action() { "Du kan inte se bakom plattan
        utan att ta bort den, men det finns inget uppenbart sätt att göra det. "; } }
;

/* ------------------------------------------------------------------------ */
/*
 *   Bridge basement hall - west end 
 */
bridgeBasementWest: Room 'Källarhall Väst'
    'den västra källarhallen' 'hallen'
    "Den låga, svagt upplysta hallen slutar här och fortsätter österut.
    På södra sidan av hallen finns en dörr märkt 023, och på
    norra sidan en annan märkt 024. I hallens västra ände
    leder en mycket smal, brant trappa ner i skugga. "

    vocabWords = 'källare+n hall+en/korridor+en'

    east = bridgeBasementEast
    south = door023
    north = door024
    west asExit(down)
    down = bbwStair
;

+ bbwStair: StairwayDown ->bsubStair
    'mycket smal+a brant+a betong trappa+n/schakt+et*trappor+na' 'trappor'
    "Betongtrappan är så smal att den nästan ser ut som om den
    går rakt ner i ett schakt. "
    isPlural = true
;

+ SimpleOdor
    desc = "Luften här är fuktig och unken. "
;

+ door023: AlwaysLockedDoor 'syd s 023 dörr+en*dörrar+na' 'dörr 023'
    "Den är märkt med rumsnummer 023. "
    theName = 'dörr 023'
;

+ door024: AlwaysLockedDoor 'nord n 024 dörr+en*dörrar+na' 'dörr 024'
    "Dörren är märkt med rumsnummer 024. "
    theName = 'dörr 024'
;

/* ------------------------------------------------------------------------ */
/*
 *   Bridge sub-basement hall
 */
bridgeSubHall: Room 'Undre källarhall' 'den undre källarhallen' 'korridor'
    "Taket i denna korta korridor är för lågt för att du ska kunna
    stå rak, och väggarna är bara omålad betong.
    Det skulle vara för grymt att placera någons kontor här nere---även
    doktorander---så denna undre källare används främst för förvaring
    och byggnadens system. Hallen är full av skräp, uppenbarligen
    överskott från förrådsrummen. Bleknad text på den norra dörren 
    lyder <q>Elektro-Mekanisk,</q> och de östra och södra dörrarna 
    är omärkta. Västerut leder en brant trappa uppåt. "

    vocabWords = 'undre under|källare+n hall+en/korridor+en'

    up = bsubStair
    west asExit(up)
    north = bsubNorthDoor
    east = bsubEastDoor
    south = bsubSouthDoor

    roomParts = [defaultFloor]
;

+ Fixture 'lågt låga tak+et' 'tak' "Taket är så lågt att du inte kan
    stå rak. "
;
+ Fixture 'nord+liga syd+liga öst+ra väst+ra n s ö v betong betong|vägg+en/betong|väggar+na' 'vägg'
    "Väggarna här är omålad betong. "
;

+ Decoration
    'överbliv:et+na byggmaterial+et/skräp+et/hög+en/bit+en/trä+et/rör+et/längder*högar+na gipsskivor+na bitar+na' 
    'skräp'
    "Det ser ut som överblivet byggmaterial, mestadels: bitar av
    gipsskivor och trä, rörlängder, den sortens saker. "
    
    isMassNoun = true

    dobjFor(Take)
    {
        verify() { }
        action() { "Du tar en snabb titt genom
            skräpet för att se om det finns något användbart du kan låna,
            men du hittar inget intressant. "; }
    }
    dobjFor(Search) asDobjFor(Take)
;

+ bsubStair: StairwayUp 'mycket smal brant ojämn betong|trappa+n/betong|trappor+na'
    'trappor'
    "De ojämna betongtrapporna leder uppåt. "
    isPlural = true
;

+ SimpleOdor
    desc = "Luften här är torr och unken. "
;

+ bsubNorthDoor: Door ->bwirDoor
    'nord n elektro-mekanisk+a elektro+mekanisk+a dörr+en' 'norra dörren'
    "Bleknad text på dörren lyder <q>Elektro-Mekanisk.</q> "
;
++ Component 'handmålad bleknad text+en' 'bleknad text'
    "<q>Elektro-Mekanisk.</q> Den bleknade texten ser ut
    som om den var handmålad för länge sedan. "
;

+ bsubEastDoor: Door ->bstorWestDoor 'öst+ra ö dörr+en' 'östra dörren'
    "Dörren är omärkt. "
;

+ bsubSouthDoor: AlwaysLockedDoor 'södra s dörr+en' 'södra dörren'
    "Dörren är omärkt. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Bridge sub-basement wiring closet 
 */
bridgeWiringCloset: Room 'Kopplingsskåp+et' 'kopplingsskåpet'
    "När du var student hjälpte du till att dra kablar i ett par av Bridge-
    labben för ett primitivt datornätverk, vilket innebar att dra en
    massa kablar i trädgårdsslangs-storlek genom väggarna och ansluta
    dem till en rad transponderboxar i detta kopplingsskåp. Allt detta
    har sedan länge rivits ut och ersatts med mer modern telefonliknande
    kabeldragning. <.p>En dörr leder söderut, ut till korridoren. "

    vocabWords = 'kopplingsskåp+et'

    south = bwirDoor
    out asExit(south)

    roomParts = static [defaultFloor]
;

+ bwirDoor: Door 's+ödra dörr+en' 'dörr' "Dörren leder ut söderut. "
;

+ bsubWiring: Immovable, Consultable
    'blå+a röd+a vit+a gul+a orange grön+a
    modern+a telefon+en telefonliknande kabel+n/nätverks|kabel+n/kabeldragning+en/massa+n*kablar+na ledningar+na' 'kabeldragning'
    "Det finns en enorm massa kablar här, mestadels längs den norra väggen,
    som kommer in i rummet genom små öppningar i taket och
    väggarna. Kablarna är i många färger: blå, röd, vit, gul,
    orange, grön. <<
      bwirBlueWire.location != nil
      ? "En blå kabel sticker ut, eftersom den har dragits åt hårt---du
        kan se att det är den du drog i på övervåningen. " : "" >> "
    isMassNoun = true

    lookInDesc() { searchResponse(); }
    searchResponse()
    {
        "Det finns så många kablar att det är omöjligt att
        hitta en specifik, utan något som verkligen
        får den att sticka ut från de övriga. ";

        /* if we haven't found the blue wire yet, hint how we could */
        if (bwirBlueWire.location == nil)
            "När du hjälpte till med Bridge-kabeldragningsprojektet,
            till exempel, var det enklaste sättet att sortera ut vad som gick vart
            att ha någon på övervåningen som gav sin kabelände ett ordentligt
            ryck, och se vilken kabel som rörde sig här nere. ";
        else
            "Du kan urskilja den blå kabeln du drog i, dock,
            eftersom det är den som har dragits åt tillräckligt hårt för att
            sticka ut från de övriga. ";
    }
    dobjFor(Follow) asDobjFor(LookIn)
    
    dobjFor(Pull)
    {
        verify() { }
        action() { "Bäst att låta bli; du vill inte riskera att
            oavsiktligt koppla ur något. "; }
    }
    dobjFor(Move) asDobjFor(Pull)
    dobjFor(Push) asDobjFor(Pull)

    isNominallyIn(obj)
        { return isIn(obj) || obj == bwirWalls || obj == bwirOpenings; }
;

++ DefaultConsultTopic
    topicResponse = (location.searchResponse())
;

+ bwirBlueWire: PresentLater, Immovable
    'blå+a spänd+a sträckt+a nätverk:et^s+kabel+n/sladd+en/isolering+en'
    'blå kabel'
    "Det är en blå nätverkskabel, spänd så att den står
    på egen hand framför den stora mängden av kablar.
    Precis som många av de andra kablarna, går den in genom en öppning
    i taket. Du följer kabeln genom massan av
    kablar för att se var den är ansluten, och upptäcker att den försvinner
    in i ett litet hål borrat i den norra väggen.
    <<traceIntoTunnel()>> "

    /* trace the wire into the steam tunnels */
    traceIntoTunnel()
    {
        /* if we haven't already done so, reveal the tunnel-side wiring */
        if (!traceDone)
        {
            /* move the steam tunnel wires into position */
            PresentLater.makePresentByKey('stWire');

            /* no need to do this again */
            traceDone = true;
        }
    }

    /* flag: we've traced the wire into the tunnel */
    traceDone = nil

    /* 
     *   If we find a resolve list that includes both this wire and the
     *   bunch-of-wires object, throw out the generic object, unless they
     *   don't call us the 'blue' wire.  
     */
    filterResolveList(lst, action, whichObj, np, requiredNum)
    {
        local idx;

        /* check for the generic wire object */
        if ((idx = lst.indexWhich({x: x.obj_ == bsubWiring})) != nil)
        {
            /* 
             *   if they didn't say 'blue', drop me; otherwise, drop the
             *   generic wire object 
             */
            if (np.getOrigTokenList()
                .indexWhich({x: getTokVal(x) == 'blå'}) != nil)
            {
                /* they said 'blue' - throw out the generic wiring */
                lst = lst.removeElementAt(idx);
            }
            else
            {
                /* no 'blue' - throw me out */
                idx = lst.indexWhich({x: x.obj_ == self});
                if (idx != nil)
                    lst = lst.removeElementAt(idx);
            }
        }

        /* return the new list */
        return lst;
    }

    dobjFor(Pull)
    {
        verify() { }
        action() { "Bäst att låta bli; du riskerar att tappa bort 
                    den bland alla andra kablar om du släpper efter 
                    på spänningen igen. "; }
    }

    isNominallyIn(obj)
    {
        return isIn(obj) || obj == bwirWalls || obj == bwirOpenings
            || obj == bwirHole;
    }
;

+ bwirWalls: Fixture
    'nord+liga syd+liga öst+ra väst+ra n s ö v vägg+en/väggar+na/tak+et' 'tak'
    "En mängd kablar är dragna in i rummet genom öppningar i
    väggarna och taket. "
;
++ bwirOpenings: Fixture 'små proppfull+a *öppningar+na' 'öppningar'
    "Öppningarna leder in i ledningar som löper genom väggarna,
    och ger en kabelväg från labb på andra våningar
    till detta kopplingsskåp. Alla öppningar är proppfulla med kablar. "
    isPlural = true

    lookInDesc = "Öppningarna är fullpackade med kablar. "
;
++ bwirHole: PresentLater, Fixture 'li:tet+lla pytteli:tet+lla borr|hål+et' 'borrhål'
    "Det är ett pyttelitet hål borrat i den norra väggen, till synes avsiktligt
    dolt bakom massan av kablar. En enda blå kabel är
    dragen genom hålet. "

    lookInDesc = "En enda blå kabel är dragen genom hålet. "
    dobjFor(LookThrough) { action() { "Hålet är för litet för att se
        något på andra sidan. "; } }
;

/* ------------------------------------------------------------------------ */
/*
 *   Sub-basement storage room 
 */
bridgeStorage: Room 'Förrådsrum' 'förrådsrummet'
    "Detta är ett enormt förvaringsutrymme, mestadels för gamla möbler:
    rummet är fullt av skrivbord, arkivskåp och bokhyllor. Kartonger
    är också staplade här och där, och en hög med skräpvirke
    lutar mot väggen i det nordvästra hörnet<<
      bstorNorthDoor.isIn(self)
      ? bstorWood.pathCleared
      ? ", bredvid en dörr som leder norrut"
      : ", framför en dörr som leder norrut"
      : " av rummet"
      >>. En dörr leder ut västerut. "

    vocabWords = 'förråd:et^s+rum+met'

    west = bstorWestDoor
    out asExit(west)
;

+ bstorWestDoor: Door 'v+ästra dörr+en' 'västra dörren' "Dörren leder västerut. "
;

+ bstorNorthDoor: PresentLater, Door
    'n+orra dörr+en' 'norra dörren' "Dörren leder norrut. "
    /* find the door */
    makeFound()
    {
        if (location == nil)
        {
            /* move me into my location */
            makePresent();

            /* set up a north travel link and a northwest alias */
            bridgeStorage.north = self;
            bridgeStorage.northwest = createUnlistedProxy();
        }
    }

    dobjFor(Open)
    {
        /* we can't open the door until the path has been cleared */
        check()
        {
            if (!bstorWood.pathCleared)
            {
                "Du kan inte öppna dörren med alla skivor av
                skräpvirke i vägen. ";
                exit;
            }
        }
    }
;

+ bstorWood: CustomImmovable
    'stor+a skräp+et hög+a hög+en/bit+en/trä+et/plywood+en/virke+t/skiva+n*skivor+na träbitar+na' 'skräpvirke'
    desc()
    {
        "Virket ser ut som diverse rester från byggprojekt,
        mestadels plywoodskivor omkring två meter gånger två och en halv meter,
        lutande mot väggen. ";

        if (!pathCleared)
        {
            "Vid närmare inspektion märker du att virket är staplat
            framför en dörr som leder norrut. ";
            bstorNorthDoor.makeFound();
        }
    }

    isMassNoun = true

    cannotTakeMsg = 'Virkesskivorna är för stora och tunga för att
        bära; som mest skulle du kunna flytta dem några meter. '

    /* flag: a path has been cleared to the door */
    pathCleared = nil

    dobjFor(LookBehind)
    {
        action()
        {
            if (!pathCleared)
            {
                "Du märker att virket är staplat framför en dörr
                som leder norrut. ";
                bstorNorthDoor.makeFound();
            }
            else
                inherited();
        }
    }
    dobjFor(Move)
    {
        verify() { nonObvious; }
        action()
        {
            if (!pathCleared)
            {
                "Du lyckas skjuta virkestraven ett par
                meter åt sidan, <<
                  bstorNorthDoor.location != nil
                  ? "och röjer vägen till dörren. "
                  : "vilket avslöjar en dörr som leder norrut.
                    Du flyttar virket tillräckligt långt för att röja vägen till
                    dörren. "
                  >>";
                
                pathCleared = true;
                bstorNorthDoor.makeFound();
            }
            else
                "Det finns inget utrymme att flytta det längre. ";
        }
    }
    dobjFor(Push) asDobjFor(Move)
    dobjFor(Pull) asDobjFor(Move)
    dobjFor(PushTravel) asDobjFor(Move)
    dobjFor(Remove) asDobjFor(Move)
;

+ Decoration
    'möbel+n/skrivbord+et/skåp+et/hög+en/stapel+n*skrivborden bok|hyllor+na högar+na staplar+na möbler+na'
    'möbler'
    "Möblerna är staplade två eller tre högt på sina ställen och packade
    tätt tillsammans utan mycket överbliven plats. "
    isMassNoun = true

    lookInDesc = "Du tittar igenom några av högarna, men
        det är bara gamla möbler; du hittar inget intressant. "

    dobjFor(Search) asDobjFor(LookIn)
    
    notImportantMsg = 'Möblerna är alla tätt packade; det
        skulle kräva en enorm ansträngning att göra något med dem. '
;

+ Decoration
    'kartong^s+låda+n/kartong:erna^s+lådor+na' 'kartonger'
    "De ser ut som om de har varit här ganska länge. De är alla
    förseglade, och det finns ingen indikation på vad som finns inuti. "
    
    isPlural = true

    lookInDesc = "De är alla förseglade; du vill inte störa dem. "

    dobjFor(Open) asDobjFor(LookIn)
    dobjFor(Search) asDobjFor(LookIn)
    dobjFor(Read)
    {
        verify() { }
        action() { "Lådorna är omärkta. "; }
    }

    dobjFor(Take)
    {
        verify() { }
        action() { "Det finns alldeles för många lådor att bära omkring. "; }
    }
    dobjFor(Move)
    {
        verify() { }
        action() { "Det finns så många lådor att allt du kan göra är
            att flytta runt dem lite. "; }
    }
    dobjFor(Pull) asDobjFor(Move)
    dobjFor(Push) asDobjFor(Move)
    dobjFor(PushTravel) asDobjFor(Move)
    
    notImportantMsg = 'Du bör verkligen inte röra lådorna. '
;

/* ------------------------------------------------------------------------ */
/*
 *   A class for steam tunnel locations
 */
class SteamTunnelRoom: Room
    atmosphereList: ShuffledEventList { [
        'Ett knackande ljud ekar ner genom ett av rören i några
        ögonblick, sedan upphör det. ',
        'Ett djupt mullrande vibrerar kort genom tunneln. ',
        'En våg av het, torr luft blåser förbi. ',
        'Ett av rören ger ifrån sig ett plötsligt högt väsande ljud. ',
        'Ett avlägset mullrande, som ljudet av en stor lastbil,
        kommer närmare och närmare tills du är säker på att ett av rören
        är på väg att spricka, men det passerar förbi och tonar bort
        i fjärran. ',
        'Ett av rören vibrerar synligt i några ögonblick. ',
        'Det verkar bli lite varmare. ',
        'En skarpt klang ljuder precis bredvid dig, som om någon
        slog ett av rören med en skiftnyckel. ',
        'Något knakar och stönar ovanför. ']

        eventPercent = 80
        eventReduceAfter = 5
        eventReduceTo = 60
    }

    name = 'ångtunnel'
    vocabWords = 'ång|tunnel+n'

    /* what we see when we look behind the steam pipes */
    lookBehindPipes() { "Du ger rören en flyktig undersökning,
        men det finns många av dem tätt packade tillsammans---det skulle
        vara lätt att missa något om du inte visste exakt var
        du skulle titta. "; }
;

MultiLoc, SimpleOdor
    initialLocationClass = SteamTunnelRoom
    desc = "Luften är mycket varm och torr, och luktar av damm och metall. "
;

MultiInstance
    initialLocationClass = SteamTunnelRoom
    instanceObject: Fixture {
        'ångig+a två-tum:miga^s+stor+a enorm+a pvc 
        ång:an+rör+et/ledningssystem+et*ångrören+a rörledningar+na ledningar+na ledningssystemen+a'
        'ångrör'
        "Talrika rör och ledningar löper längs väggarna, från
        vanliga två-tums PVC-rör som du skulle hitta i ett hus,
        till enorma, industriella rör två fot i diameter. "
        isPlural = true
        
        dobjFor(LookBehind)
        {
            action() { gActor.location.getOutermostRoom().lookBehindPipes(); }
        }
        dobjFor(LookUnder) asDobjFor(LookBehind)
        dobjFor(Search) asDobjFor(LookBehind)
    }
;
+ SimpleNoise
    initialLocationClass = SteamTunnelRoom
    desc = "Väsande, mullrande och knackande ljud ekar intermittent
        genom rören. "
;

MultiInstance
    initialLocationClass = SteamTunnelRoom
    instanceObject: Decoration {
        'bar+a ljus+avgivande skyddande trådbur:en^s+höljig+a
        glöd+lampa+n/bur+en*lampor+na burar+na'
        'glödlampa'
        "Lamporna avger ett svagt gult ljus inifrån sina
        skyddande trådburar. "

        notImportantMsg = 'Glödlamporna är inte viktiga (bortsett
            från att hjälpa dig se var du går, förstås). '

        dobjFor(Take)
        {
            verify() { }
            action() { "Hur många Techers behövs det för att byta en glödlampa?
                Nu när du tänker på det har du aldrig hört
                ett Caltech glödlampsskämt, förvånansvärt nog. I vilket fall som helst,
                så är dessa glödlampor inte viktiga. "; }
        }
        dobjFor(Unscrew) asDobjFor(Take)
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   Steam tunnel near storage room 
 */
steamTunnel1: SteamTunnelRoom 'Ångtunnel vid Dörren'
    'ångtunneln nära dörren'
    "Detta är en sektion av ångtunneln som löper öster och väster förbi
    en dörr, som leder ut ur tunneln söderut. Rör och
    ledningar löper längs väggarna, och nakna glödlampor med låg effekt
    är placerade med ungefär tre meters mellanrum längs taket, vilket avger precis
    tillräckligt med ljus för att kunna se. "

    east = steamTunnel2
    west = steamTunnel5
    south = st1Door
    out asExit(south)

    roomParts = static (inherited - defaultEastWall - defaultWestWall)
;

+ st1Door: Door ->bstorNorthDoor 's+ödra dörr+en' 'södra dörren'
    "Dörren leder ut ur tunneln söderut. "
;

+ st1Wire: PresentLater, Unthing 'blå+a nätverks|kabel+n/nätverks|ledning+en' 'blå kabel'
    "Du ser inte kabeln här, men om du har din orientering rätt,
    skulle du inte förvänta dig det heller---kopplingsskåpet borde ligga 
    strax väster om här. "

    plKey = 'stWire'
;

/* ------------------------------------------------------------------------ */
/*
 *   narrow tunnel 
 */
steamTunnel5: SteamTunnelRoom 'Smal Tunnel' 'den smala tunneln'
    "Ångtunneln är ganska smal här; den vidgas lite åt
    öster och väster.
    <<st5Hole.isIn(self)
      ? "<.p>Du ser en liten ljuspunkt i den södra väggen---ett
        litet hål, nästan dolt bakom ett av de stora ångrören.
        Du skulle aldrig ha lagt märke till det, om du inte hade en
        känsla av att denna plats är ungefär i linje med kopplingsskåpet. "
      : ""
      >> "

    lookBehindPipes()
    {
        if (st5Hole.isIn(self))
            "Du hittar en blå kabel fäst längs baksidan av ett av de
            stora rören. ";
        else
            inherited();
    }

    east = steamTunnel1
    west = steamTunnel6
    roomParts = [defaultFloor, defaultCeiling, defaultNorthWall]
;

+ Fixture 's+ödra vägg+en*väggar+na' 'södra väggen'
    desc()
    {
        if (st5Hole.isIn(self))
            "Du märker ett litet hål i väggen, som släpper in en liten
            prick av ljus från andra sidan. ";
        else
            "Du ser inget ovanligt med den, även om du har en
            känsla av att kopplingsskåpet borde vara på andra sidan. ";
    }
;

++ st5Hole: PresentLater, Fixture
    'li:tet+lla pytteli:tet+lla hål+et/ljus:et+prick+en/(ljus+et)' 'lilla hålet'
    "Hålet är nästan helt dolt bakom ett av de stora
    ångrören. En blå kabel kommer in genom hålet, och
    slingrar sig sedan längs baksidan av ett av de stora 
    rören, och löper ner i tunneln västerut. "

    plKey = 'stWire'

    lookInDesc = "En enda blå kabel är dragen genom hålet. "
    dobjFor(LookThrough) { action() { "Allt du kan se är en prick
        av ljus. "; } }
;

+ st5Wire: PresentLater, Immovable 'blå+a nätverk^s+kabel+n/ledning+en' 'blå kabel'
    "Kabeln kommer in genom det lilla hålet i den södra väggen,
    slingrar sig sedan längs baksidan av ett av de stora ångrören,
    och sträcker sig ner i tunneln västerut. "

    plKey = 'stWire'

    /* we nominally run through the hole */
    isNominallyIn(obj) { return obj == st5Hole || inherited(obj); }

    dobjFor(Follow)
    {
        verify() { }
        action() { "Kabeln fortsätter ner i tunneln västerut,
            och lämnar tunneln genom det lilla hålet. "; }
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   Intersection 
 */
steamTunnel6: SteamTunnelRoom 'T-Korsning' 'T-korsningen'
    "Detta är en T-korsning, där en nord-sydlig tunnel möter en annan
    tunnel som fortsätter österut. Rören är arrangerade i ett invecklat
    nätverk av korsningar, vissa går rakt förbi korsningen,
    andra svänger runt hörnet.
    <<st6Wire.isIn(self)
      ? "<.p>Du märker en blå kabel dold bakom ett av de
        stora ångrören. "
      : "">> "

    lookBehindPipes()
    {
        if (st6Wire.isIn(self))
            "Det finns en blå kabel dold bakom ett stort rör.
            <<st6Wire.wireDesc>> ";
        else
            inherited();
    }

    east = steamTunnel5
    south = steamTunnel7
    north = steamTunnel13
;

+ st6Wire: PresentLater, Immovable 'blå+a nätverks|kabel+n/nätverks|ledning+en' 'blå kabel'
    "Kabeln är dold bakom ångrören. <<wireDesc>> "
    wireDesc = "Du följer dess väg och upptäcker att den följer ett stort
        ångrör som går ner i tunneln österut, löper upp längs ett annat
        rör, korsar över huvudet, löper ner längs ett rör på västra sidan, och
        följer sedan ett rör ner i tunneln söderut. "

    plKey = 'stWire'

    dobjFor(Follow) asDobjFor(Examine)
;

/* ------------------------------------------------------------------------ */
/*
 *   Musty tunnel 
 */
steamTunnel13: SteamTunnelRoom 'Unken Tunnel' 'den unkna tunneln'
    "Denna svagt upplysta del av tunneln har en lätt unken
    lukt. Tunneln löper norrut och söderut härifrån. "

    south = steamTunnel6
    north = steamTunnel14

    roomParts = static (inherited - [defaultNorthWall, defaultSouthWall])
;

+ SimpleOdor 'unk:en+na lukt+en/luft+en' 'unken lukt'
    "En lätt unken lukt finns i luften. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Corner at stairs 
 */
steamTunnel14: SteamTunnelRoom
    'Tunnel vid Trappan' 'tunneln nära trappan'
    "Detta är den norra änden av en nord-sydlig tunnelsektion.
    Österut leder en brant trappa ner i en sidopassage. "

    south = steamTunnel13
    east = st14Stairs
    down asExit(east)

    roomParts = static (inherited - defaultSouthWall)
;

+ EntryPortal ->(location.east) 'öst+ra ö smal+a sidopassage+n' 'sidopassage'
    "En brant trappa går ner i passagen. "
;

+ st14Stairs: StairwayDown ->st15Stairs
    'brant+a trappa+n/trapp:en+nedgång+en*trappor+na' 'brant trappa'
    "Trappan leder ner i den östra passagen. "
;
    
/* ------------------------------------------------------------------------ */
/*
 *   North-south crawl
 */
steamTunnel15: SteamTunnelRoom
    'Tunnel vid Krypgången' 'tunneln vid nord-syd krypgången'
    "Detta är en äldre sektion av ångtunneln, som löper öster och
    väster. Tunneln stiger upp via en brant trappa västerut.
    <.p>Uthuggen i den norra väggen finns en låg, smal servicetunnel;
    ett par gigantiska asbestinklädda rör, vardera nästan en meter
    i diameter, svänger in i servicetunneln och lämnar
    precis tillräckligt med utrymme för en person att slingra sig igenom genom att ligga
    platt ovanpå ångröret. Detta är vad du kallade
    nord-sydliga krypgången under dina studieår: den enda
    kända förbindelsen mellan de norra och södra tunnelsystemen. "

    west = st15Stairs
    up asExit(west)
    east = steamTunnel16
    north: NoTravelMessage { "Du slingrade dig genom krypgången
        flera gånger under dina studieår, och det var trångt
        redan då; du tvivlar starkt på att du skulle få plats längre. " }

    roomParts = static (inherited - [defaultEastWall, defaultWestWall,
                                     defaultNorthWall])
;

+ st15Stairs: StairwayUp 'brant+a trappa+n/trappor+na/trappuppgång+en' 'brant trappa'
    "Trappan leder upp västerut. "
;

+ Fixture 'n+orra vägg+en*väggar+na' 'norra väggen'
    "En servicetunnel, känd som nord-sydliga krypgången, är uthuggen
    i den norra väggen. "
;

+ EntryPortal ->(location.north)
    'smal+a nord-sydlig+a kryp|gång+en/gång+en/service|tunnel+n'
    'nord-sydliga krypgången'
    "Två stora asbestinklädda rör löper genom tunneln,
    och lämnar knappt tillräckligt med utrymme för en person att ta sig igenom genom att
    slingra sig längs toppen av rören. "
;

+ Fixture 'gigantisk:t+a asbest asbestinklä:tt+dda rör+et*rören+a ledningar+na' 'asbestinklädda rör'
    "Rören är ungefär en meter i diameter. De löper genom
    servicetunneln som grenar av sig norrut. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Older tunnel 
 */
steamTunnel16: SteamTunnelRoom
    'Äldre Tunnel' 'den äldre tunneln'
    "Denna del av tunneln löper öster och väster. Tunneln ser
    särskilt gammal ut här. På den södra väggen, bredvid vad som ser ut som
    en säkringsdosa, är bokstäverna <i>DEI</i> målade med schablon. "

    west = steamTunnel15
    east = steamTunnel9

    roomParts = static (inherited - [defaultEastWall, defaultWestWall,
                                     defaultSouthWall])
;

+ Fixture 's+ödra vägg+en*väggar+na' 'södra väggen'
    "Bokstäverna <i>DEI</i> är målade med schablon bredvid en
    elektrisk kopplingsdosa. "

    /* read wall -> read letters */
    dobjFor(Read) remapTo(Read, dei)
;

++ dei: Fixture 'schablon:en+målad+e *bokstäver+na "dei" dei' 'schablonmålade bokstäver'
    "<q>DEI</q> är ett Techer-internskämt som är så internt att ingen
    ens vet exakt vad det betyder. Det antas allmänt stå för
    <q>Dabney äter det,</q> vilket i sin tur antas syfta på
    någon matserveringsincident från det dimmiga förflutna, men det finns ingen
    definitiv dokumentation om exakt när eller varför eller vem eller vad. Trots
    sitt mystiska ursprung har trigrafin länge använts som
    ett sorts hemligt handslag för att i hemlighet identifiera något som
    Caltech-relaterat. Ångtunnelns DEI:er kommer från årtionden tillbaka
    när TV-programmet <i>Operation: Danger</i> spelade in ett avsnitt här nere,
    och några studenter tog tillfället i akt att smyga in insignian
    i programmet. "
    
    isPlural = true
;
+ Fixture 'säkrings elektrisk (dei) ("dei") kopplings|dosa+n/säkrings|dosa+n/säkrings|skåp+et'
    'elektrisk dosa'
    "Det är någon form av elektrisk kopplingsdosa. "

    /* read wall -> read letters */
    dobjFor(Read) remapTo(Read, dei)

    dobjFor(Open)
    {
        verify() { }
        action() { "Det finns inget uppenbart sätt att öppna dosan, åtminstone
            inte utan specialverktyg. "; }
    }
    dobjFor(LookIn)
    {
        preCond = [objOpen]
        verify() { }
    }
    isOpen = nil
;


/* ------------------------------------------------------------------------ */
/*
 *   Wide tunnel 
 */
steamTunnel7: SteamTunnelRoom 'Mörk Tunnel' 'den mörka tunneln'
    "Lamporna måste vara placerade lite glesare än vanligt
    här, eftersom denna del av nord-sydtunneln verkar särskilt
    mörk.
    <<st7Crawl.isIn(self)
      ? "I skuggorna, lågt på den västra väggen, är en öppning knappt
        synlig. " : "">>
    <<st7Wire.isIn(self)
      ? "Du kan urskilja en blå kabel dold bakom ett av de
        stora rören. " : "">> "

    lookBehindPipes()
    {
        if (st7Wire.isIn(self))
        {
            "Du hittar en blå kabel dold bakom ett av de
            stora ångrören. ";
            st7Wire.descWire;
        }
        else
            inherited();
    }

    north = steamTunnel6
    west = (st7Crawl.isIn(self) ? st7Crawl : inherited)
    south = steamTunnel12

    roomParts = [defaultFloor, defaultCeiling, defaultEastWall]
;

+ st7Wire: PresentLater, Immovable 'blå+a nätverks|kabel+n/nätverks|ledning+en' 'blå kabel'
    "Kabeln är dold bakom ett av de stora rören. <<descWire>> "
    descWire = "Den följer röret norrut<<revealCrawl>> "
    revealCrawl()
    {
        if (!st7Crawl.isIn(location))
        {
            ", men den verkar försvinna söderut. Du följer den
            noggrant och upptäcker att den går in i en öppning lågt
            på den västra väggen. Öppningen är väl dold i
            skuggorna under rören; du skulle inte ens ha sett den
            om du inte hade följt kabeln. ";

            st7Crawl.makePresent();
        }
        else
            ", och går in i en låg öppning på den västra väggen. ";
    }
    dobjFor(Follow) asDobjFor(Examine)

    plKey = 'stWire'
;

+ Fixture 'v+ästra vägg+en*väggar+na' 'västra väggen'
    desc()
    {
        if (st7Crawl.isIn(self))
            "En öppning är knappt synlig lågt på väggen. ";
        else
            "Du ser inget ovanligt med den. ";
    }
;

++ st7Crawl: PresentLater, TravelWithMessage, ThroughPassage ->st8Crawl
    'mörk+a öppning+en/kryp|utrymme+t' 'öppning'
    "Öppningen är väl dold i skuggorna under ångrören.
    Den måste ha varit avsedd att rymma ett par av de stora
    rören, men det ser ut som om den är tom just nu förutom den blå
    kabeln, så det kan finnas tillräckligt med utrymme för dig att klämma dig igenom. "

    travelDesc = "Du hukar dig ner på golvet och kryper in i
        öppningen med huvudet först. Det är obehagligt trångt,
        men du lyckas ta dig igenom de cirka två och en halv meterna
        av passagen och kommer slutligen ut i en annan tunnel. "

    /* treat LOOK IN the same as EXAMINE */
    dobjFor(LookIn) asDobjFor(Examine)
;

/* ------------------------------------------------------------------------ */
/*
 *   Tunnel at door
 */
steamTunnel12: SteamTunnelRoom 'Tunnel vid Dörr+en' 'tunneln nära dörren'
    "Denna del av tunneln slutar i söder vid en bred metalldörr
    märkt <q>Ångverk.</q> Tunneln fortsätter norrut. "

    north = steamTunnel7
    south = st12Door
    
    roomParts = static (inherited - defaultNorthWall)
;

+ st12Door: AlwaysLockedDoor 'bred+a metalliska ångverk ångverks|dörren/metall|dörr+en' 'metalldörr'
    "Det är en bred metalldörr märkt <q>Ångverk.</q> "
;

/* ------------------------------------------------------------------------ */
/*
 *   Sloping tunnel 
 */
steamTunnel2: SteamTunnelRoom 'Sluttande Tunnel' 'den sluttande tunneln'
    "Denna del av tunneln löper öster och väster, och sluttar brant
    nedåt mot öster. Ångrören följer tunnelns lutning. "

    west = steamTunnel1
    up asExit(west)
    east = steamTunnel3
    down asExit(east)

    roomParts = static (inherited - defaultEastWall - defaultWestWall)
;

/* ------------------------------------------------------------------------ */
/*
 *   Tunnel corner 
 */
steamTunnel3: SteamTunnelRoom 'Krök i Tunneln'
    'kröken i tunneln'
    "Ångtunneln svänger i en krök här och fortsätter norrut
    och västerut. Rören och ledningarna som kommer in från varje
    gren av tunneln korsar varandra, vissa följer svängen medan andra
    fortsätter rakt igenom väggarna. "

    north = steamTunnel4
    west = steamTunnel2
;

/* ------------------------------------------------------------------------ */
/*
 *   Tunnel T
 */
steamTunnel4: SteamTunnelRoom 'T-Korsning' 'T-korsningen'
    "Två ångtunnlar möts här och bildar ett <font face='tads-sans'>T</font>:
    en tunnel löper norrut och söderut, och en annan tunnel fortsätter
    österut. "

    north = steamTunnel9
    south = steamTunnel3
    east = steamTunnel10

    roomParts = static (inherited - defaultSouthWall - defaultNorthWall)
;

/* ------------------------------------------------------------------------ */
/*
 *   Dead end 
 */
steamTunnel9: SteamTunnelRoom 'Tunnelkrök' 'kröken i tunneln'
    "Ångtunneln svänger i en krök här, en gren löper
    söderut, den andra västerut. "

    south = steamTunnel4
    west = steamTunnel16

    roomParts = static (inherited - [defaultSouthWall, defaultWestWall])
;

/* ------------------------------------------------------------------------ */
/*
 *   Under quad manhole
 */
steamTunnel10: SteamTunnelRoom 'Botten av Schaktet' 'botten av schaktet'
    "En pelare av solljus strömmar in från ett schakt ovanför och tränger
    igenom tunnelns dunkel. En stege inbyggd i väggen leder uppåt
    in i schaktet. Tunneln fortsätter västerut och går ner några
    betongtrappsteg österut. "

    west = steamTunnel4
    east = st10Stairs
    down asExit(east)
    up = st10Ladder

    roomParts = [defaultFloor, defaultNorthWall, defaultSouthWall]

    afterTravel(trav, conn)
    {
        /* do the normal work */
        inherited(trav, conn);

        /* 
         *   if the PC is coming into the room, and plisnik isn't here,
         *   and we haven't talked to the workers above yet, have them ask
         *   if everything's okay 
         */
        if (trav == me
            && !plisnik.isIn(self)
            && !gRevealed('plisnik-checked'))
        {
            /* make sure the workers are here, and have them call down */
            st10QuadWorkers.makePresent();
            st10QuadWorkers.initiateConversation(nil, 'plisnik-check');
        }
    }
;

+ st10Stairs: StairwayDown ->st11Stairs
    'kort+a betong+steg+en/trapp+uppgång+en/trappa+n*trappor+na' 'betongtrappor'
    "Trappuppgången leder några steg ner österut. "
;

+ Vaporous 'pelare+n/sol|ljus+et' 'pelare av solljus'
    "Solljuset strömmar in i tunneln från öppningen i
    toppen av schaktet ovanför. "
;

+ Fixture 'tunneltak+et' 'tak'
    "Ett schakt ovanför tunneln leder upp till ytan. "
;

+ workOrders: Readable, Consultable
    'arbetsorder+fyllda överfylld+a treringad+e tjock+a brun+a pärm+en/blankett+en*papper pappren blanketter+na'
    'treringad pärm'
    "Det är en brun treringad pärm, svällande av papper. "

    /* 
     *   this is the kind of thing that takes some effort to read as
     *   opposed to just looking at it, so we have a separate read desc 
     */
    readDesc = "Pärmen är fylld med papper. När du bläddrar igenom
        verkar det vara en samling officiella <q>Arbetsorder</q>-blanketter
        från Network Installer Company. Du tittar på några slumpmässigt
        och upptäcker att de alla är ganska lika: installera nätverksuttag
        för kontor X i byggnad Y. Dessa killar måste ha ett kontrakt
        för att dra om kablar i hela campus, av utseendet att döma.
        Blanketterna verkar vara sorterade efter Jobbnumret som är stämplat
        överst på varje blankett, så det skulle vara lätt att hitta en specifik
        om man vet numret. "
    
    topicNotFound()
    {
        local jobnum = gTopic.getTopicText();
        
        if (rexMatch('(jobb<space>+)?(nummer<space>+)?[0-9]{4}-[0-9]{4}$',
                     jobnum) != jobnum.length())
        {
            /* it's not even the right format */
            "Du ser inga jobbnummer som ser ut så; de verkar alla
            vara i formatet 1234-5678. ";
        }
        else
        {
            /* pull out the job number from the string */
            rexMatch('.*([0-9]{4}-[0-9]{4}$', jobnum);
            jobnum = rexGroup(1)[3];

            /* 
             *   The format's right: with a 33% chance, if we haven't
             *   filled out the three random responses yet, pick one and
             *   fill it out.  The extra random responses don't tell us
             *   anything; they're just there for fun, so that we actually
             *   get non-trivial responses for trying random numbers.
             *   However, if we've previously claimed this number doesn't
             *   exist, then we want to claim this again.  
             */
            if (randomJob3.jobNumber == nil && !jobNotFound[jobnum])
            {
                /* only do this with a 33% chance */
                if (rand(100) < 33)
                {
                    local t;

                    /* find the first available random job entry */
                    t = [randomJob1, randomJob2, randomJob3]
                        .valWhich({x: x.jobNumber == nil});

                    /* set the topic's job number to what we looked up */
                    t.setJobNumber(jobnum);

                    /* show the response */
                    t.handleTopic(gActor, gTopic);

                    /* we've handled it */
                    return;
                }

                /* 
                 *   we're electing not to find it even though we could,
                 *   so for consistency, enter it in our table of jobs we
                 *   can never find 
                 */
                jobNotFound[jobnum] = true;
            }

            /* it's a valid number, but it's not there... */
            "Det verkar inte finnas ett arbetsorderformulär med det numret.";
        }
    }

    /* 
     *   a table of job numbers we've claimed do not exist - we keep this
     *   table to ensure that we don't later change our minds and decide
     *   to allow the job number as part of our random job responses 
     */
    jobNotFound = static new LookupTable(16, 16)

    /* 
     *   we're initially described with the spools of wire, so don't list
     *   me separately if we haven't been moved yet 
     */
    isListed = (moved)
    spoolDesc()
    {
        /* if we haven't been moved yet, add our description to the spools */
        if (!moved)
            "En överfylld treringarspärm ligger på golvet bredvid spolarna. ";
    }

    /* OPEN and LOOK IN are the same as READ for this */
    dobjFor(Open) asDobjFor(Read)
    dobjFor(LookIn) asDobjFor(Read)

    dobjFor(Read)
    {
        /* 
         *   this is the sort of big, heavy book one has to be holding in
         *   order to read 
         */
        preCond = (inherited() + objHeld)

        /* the first time we read it, the instruction sheet falls out */
        action()
        {
            /* if we haven't found the instruction sheet yet, find it now */
            if (!foundSheet)
            {
                local dest, nomDest;
                
                /* 
                 *   get the actor's "drop destination," which is where
                 *   things land when the actor drops them right now, and
                 *   the "nominal" drop destination, which is where we
                 *   *say* things land 
                 */
                dest = gActor.getDropDestination(netAnInstructions, nil);
                nomDest = dest.getNominalDropDestination();
                
                /* mention that the sheet falls out of the binder */
                "När du öppnar pärmen faller ett grådaskigt pappersark 
                ut och fladdrar <<nomDest.putInName()>>.<.p>"; 

                /* move the instruction sheet to the drop destination */
                netAnInstructions.moveInto(dest);

                /* note that we've found it */
                foundSheet = true;
            }

            /* do the normal work */
            inherited();
        }
    }

    /* as with reading, consulting requires holding the binder */
    dobjFor(ConsultAbout) { preCond = (inherited() + objHeld); }

    /* flag: we've found the instruction sheet */
    foundSheet = nil
        
;

class JobOrderTopic: ConsultTopic
    topicResponse = "Du bläddrar igenom pärmen och hittar en sida
        med det jobnumret:
        <.p><.blockquote><tt><i><b>OBS</b>: Alla IP-adresstilldelningar 
        <b>MÅSTE</b> göras genom Campus Nätverkskontor
        (Jorgensen Lab). Rapportera <b>ALLA</b> IP-ändringar till
        CNO.</i>
        <.p>Jobbeskrivning: <<jobDesc>>
        <br><br>Särskilda anteckningar: <<jobNotes>></tt><./blockquote>
        <<jobExtra>> "

    jobNumber = nil

    /* on setting the job number dynamically, rebuild the match pattern */
    setJobNumber(num)
    {
        /* remember the new job number */
        jobNumber = num;

        /* build the new match pattern */
        matchPattern = buildMatchPattern();
    }

    /* 
     *   build the match pattern as "job number xxx", with "job" and
     *   "number" being optional 
     */
    matchPattern = perInstance(buildMatchPattern())
    buildMatchPattern()
    {
        return (jobNumber == nil
                ? nil
                : new RexPattern(
                    '(jobb<space>+)?(nummer<space>+)?' + jobNumber + '$'));
    }
;

/* 
 *   Set up three topics for random things we look up, to surprise the
 *   user with actual results for looking up random numbers.  These don't
 *   tell us anything useful - they're just here for fun, to surprise the
 *   player with non-trivial feedback for trying random numbers.
 *   
 *   These don't have any match pattern initially.  When we decide to use
 *   one, we'll assign whatever number the player typed in as the match
 *   pattern, ensuring that they'll get the same response if they ask
 *   about the same number again.  
 */
++ randomJob1: JobOrderTopic
    jobDesc = "Installera ny Gb FO-anslutning i Athenaeum, rum 271.
        Std FO-kabeldragning. Std väggplattdelar."
    jobNotes = "Borra inte i N-väggen utan att kontrollera reglarna."
;
++ randomJob2: JobOrderTopic
    jobDesc = "Reparera 100TX-kabeldragning, Bridge Lab, rum 023."
    jobNotes = "Ingen spänning. Kontrollerade väggkabeldragning 17/4, dålig anslutning
        troligen i s/b kabelskåp."
;
++ randomJob3: JobOrderTopic
    jobDesc = "Lägg till 2 nya portar, Steele 237. Std cat5e-kabeldragning.
        Std väggplattdelar."
    jobNotes = "Behöver kabelrör om möjligt."
;
++ JobOrderTopic
    jobNumber = static (infoKeys.spy9JobNumber)
    jobDesc = "Installera SPY-9 i Bridge Lab, rum 022. Std cat5
        kabeldragning. Std kam-kabelprofil - dra via s/b kabelskåp,
        tunnel 7g, avsluta vid router S-24."
    jobNotes = "ENDAST NATTSKIFT. Placera kameran för klar sikt över
        huvudbänkområdet. REF <<infoKeys.spy9IPJobNumber>>."
;
++ JobOrderTopic
    jobNumber = static (infoKeys.spy9IPJobNumber)
    jobDesc = "Behöver statisk IP-adress för SPY-9."
    jobExtra = "<.p>Under detta finns stora handskrivna siffror:
        <<infoKeys.spy9IPDec>>.<.reveal spy9-ip> "
;
++ JobOrderTopic
    jobNumber = static (infoKeys.syncJobNumber)
    jobDesc = "Installera ny nätverksport, Sync Lab-kontor (2:a våningen)."
    jobNotes = "Dörrkombinationen är <<infoKeys.syncLabCombo>>."

    topicResponse()
    {
        /* show the description */
        inherited();

        /* award our points */
        scoreMarker.awardPointsOnce();
    }

    scoreMarker: Achievement { +10 "hitta information om Sync Lab-kontoret" }
;

+ st10Ladder: StairwayUp 'järnstege+n/järn|pinne+n/järn|stegpinne+n*järn|stegpinnar+na järn|pinnar+na' 'stege'
    "Stegen består av en serie järnpinnar inbäddade i
    väggen. Den går upp längs väggen in i tunneln. "

    dobjFor(TravelVia)
    {
        action()
        {
            "Du klättrar upp för stegen och kommer ut i solljuset på
            Quad. Precis när du når toppen av stegen
            griper två stora killar i ljusgröna overaller tag i dina
            armar och lyfter dig ur schaktet.
            <.p><q>Vad i helvete tror du att du gör där nere?</q> frågar en av de
            skäggiga arbetarna. De
            skyndar dig förbi den gula tejpen de har satt upp runt
            schaktet och ger dig en knuff.
            <.p><q>Jag är trött på att ni folk hela tiden är i vägen för oss,</q>
            säger arbetaren och pekar med pekfingret
            mot dig. <q>Du har tur att jag inte ringer polisen.</q> Han
            stampar tillbaka till kanten av schaktet. ";

            /* off to the quad */
            gActor.travelTo(quad, self, nil);
        }
    }
;

+ st10Spools: CustomImmovable
    'stor+a trä+spole kabel+vinda+n/rulle+n/nätverks|kabel+n/(hög+a)*telefonkabelvindor+na träspolar+na rullar+na (högar+na)'
    'kabelvindor'
    "De är två fot i diameter träspolar lindade med kabel,
    som ser ut att vara någon form av telefon- eller nätverkskabel. "

    specialDesc = "Flera stora träspolar med kabel är staplade
        längs tunnelväggen. <<workOrders.spoolDesc>> "

    isPlural = true

    cannotTakeMsg = 'Kabelrullarna är stora och tunga, och du vill
        helst inte slösa en massa kraft på att flytta runt dem. '
;

+ OutOfReach, Fixture 'schakt+et/topp+en/schakt|öppning+en' 'schakt'
    "Det är ett rektangulärt schakt som stiger från tunnelns tak
    till ytan ovanför. Schaktet är öppet i
    toppen. En stege inbyggd i väggen går upp i schaktet. "

    dobjFor(Enter) remapTo(ClimbUp, st10Ladder)
    dobjFor(Board) remapTo(ClimbUp, st10Ladder)
    dobjFor(GoThrough) remapTo(ClimbUp, st10Ladder)
    dobjFor(ClimbUp) remapTo(ClimbUp, st10Ladder)
    dobjFor(Climb) remapTo(ClimbUp, st10Ladder)

    dobjFor(LookThrough) { action() { "Du kan inte se något bortom
        schaktet förutom solljus. "; } }
    dobjFor(LookIn) asDobjFor(LookThrough)

    cannotReachFromOutsideMsg(dest) { return 'Du kan inte riktigt nå
        schaktet härifrån. '; }
;

/* 
 *   The quad workers above, as seen from the bottom of the shaft.  We're
 *   not even here initially - we don't show up until we make some mention
 *   of the workers above.  
 */
++ st10QuadWorkers: PresentLater, Actor
    'stor+a tung+a bråkig+a arbetare+n/man+nen*män+nen skägg+en' 'arbetare'
    "Du kan inte se dem härifrån; det enda du ser genom
    schaktet är solljus. "

    isPlural = true

    /* they're not in sight, so we don't need to mention them */
    specialDesc = ""

    /* as these guys are out of view, downgrade conversational actions */
    dobjFor(AskAbout)
        { verify() { logicalRank(70, 'utom synhåll'); inherited(); } }
    dobjFor(TellAbout)
        { verify() { logicalRank(70, 'utom synhåll'); inherited(); } }
    iobjFor(ShowTo)
        { verify() { logicalRank(70, 'utom synhåll'); inherited(); } }
    iobjFor(GiveTo)
        { verify() { logicalRank(70, 'utom synhåll'); inherited(); } }
;

/* we don't want to allow talking to them while Plisnik is here */
+++ TopicGroup
    isActive = (plisnik.inOrigLocation)
;
++++ DefaultAnyTopic, ShuffledEventList
    ['<q>Hördu, Plisnik,</q> ropar en av arbetarna ovanför,
    <q>har du någon där nere med dig? Se till att det inte är
    en jättestor talande råtta! Ha! Ha!</q> ',

     '<q>Håll käften, Plisnik,</q> ropar en av arbetarna ner,
     <q>vi har rast!</q> ',

     '<q>Vem är där nere med dig, Plisnik?</q> ropar en av
     arbetarna ovanför. <q>Säg åt vem det än är att dra!
     Du har jobb att utföra.</q> ']
;

/*
 *   Have the workers check on the commotion in the tunnels after Plisnik
 *   leaves.  The purpose of this brief conversation is to ensure that the
 *   player realizes that it's possible to talk to the workers through the
 *   shaft, since we have to talk to them to solve the network analyzer
 *   puzzle.  
 */
+++ ConvNode 'plisnik-check'
    npcGreetingMsg = "<.p>Du hör en arbetare ovanför ropa ner. <q>Hej,
        Plisnik, vad händer där nere?</q> Hans röst blir
        retsam. <q>Ser du en råtta eller något?</q> Han skrattar. "
;
++++ YesTopic
    "<q>Ja, en stor, ful en, men den är borta nu,</q> säger du och hoppas
    att de inte märker att det inte är Plisniks röst. Du hör arbetarna
    ovanför skratta och skratta.
    <.reveal plisnik-checked> "
;
++++ NoTopic
    "<q>Nej, inga problem här nere,</q> säger du.
    <.p><q>Hej,</q> ropar en av dem ner, <q>jag tror jag ser en
    nu!</q> Du kan höra de två skratta och skratta.
    <.reveal plisnik-checked> "
;

/* once plisnik is gone, the conversation changes a bit.. */
+++ TopicGroup
    isActive = (!plisnik.inOrigLocation)
;
++++ AskTellAboutForTopic @quadAnalyzer
    topicResponse()
    {
        "<q>Hallå, kan ni skicka ner Netbiscon?</q> ropar du upp
        till arbetarna ovanför.
        <.p>En av dem sträcker sig ner i schaktet och sänker ner
        nätverkslådan. <q>Se upp, Plisnik,</q> säger han. <q>Jag tror
        jag såg en råtta inuti den tidigare. Ha! Ha!</q> ";

        /* 
         *   Get rid of the fake analyzer on the quad, move the real
         *   analyzer into our location, then take it.  Note that we
         *   interrupt the dialog to take the analyzer so that any
         *   implicit action (such as hands-freeing bag-of-holding
         *   insertions) will be described just before our 'take'
         *   description below, rather than after the entire message.  
         */
        quadAnalyzer.moveInto(nil);
        netAnalyzer.moveInto(steamTunnel10);
        nestedAction(Take, netAnalyzer);

        /* and now we can mention that we took it, assuming we did */
        if (netAnalyzer.isIn(me))
            "Du sträcker dig upp och tar den från honom, noga med att stanna
            i skuggan. ";

        /* this is worth some points */
        scoreMarker.awardPointsOnce();

        /* make the new, real analyzer 'it' */
        me.setPronounObj(netAnalyzer);
    }

    scoreMarker: Achievement { +10 "erhålla Netbisco 9099"; }
;
+++++ AltTopic
    "<q>Hej killar, hur använder jag Netbiscon?</q> säger du.
    <.p><q>Att använda den där grejen är ditt jobb, Plisnik,</q> ropar en av
    arbetarna ner. "

    /* this topic takes over once we get the analyzer */
    isActive = (quadAnalyzer.location == nil)
;

++++ AskTellTopic @supplyRoomTopic
    "<q>Hej,</q> ropar du till arbetarna ovanför, <q>vad är
    kombinationen till förrådet?</q>
    <.p><q>Hur skulle jag veta det?</q> skriker en av arbetarna.
    <q>Det är du som jobbar nere i tunnlarna.</q> "
;

++++ AskForTopic @st10Spools
    "Du ropar upp till arbetarna ovanför. <q>Kan ni killar skicka ner
    mer kabel?</q>
    <.p><q>Vad ser jag ut som, en springpojke?</q> skriker en av
    arbetarna. <q>Du har massor av kabel där nere redan.</q> "
;

++++ DefaultAnyTopic
    "<q>Du låter konstig, Plisnik,</q> skriker en av arbetarna
    ner i schaktet. <q>Den där råttan måste ha skrämt dig ordentligt.</q> "
;

+ plisnik: IntroPerson
    'nervös+a skakig+a blek+a mag:er+ra gänglig:t+a
    arbetare+n/man+nen/skägg+et/plisnik*män+nen arbetarna'
    'arbetare'
    "Han är en blek, mager, nervös man med ett gängligt skägg.
    Han bär samma sorts gröna overall och skyddshjälm som
    arbetarna du såg på Quad. "

    isHim = true

    properName = 'Plisnik'
    specialDescName = (introduced
                       ? properName
                       : 'en kraftig, skäggig man i grön overall')

    /* am I in my original location? */
    inOrigLocation = (isIn(steamTunnel10))

    /* 
     *   use a global parameter name, so we can use {plisnik} in messages
     *   to refer to our current name, which depends on whether we've been
     *   introduced or not 
     */
    globalParamName = 'plisnik'

    beforeAction()
    {
        /* do the normal work */
        inherited();

        /* if they're trying to get my binder or spools, don't let them */
        if (gActionIs(Take) && gDobj is in(st10Spools, workOrders))
        {
            "<q>Hallå där,</q> ropar {den plisnik/han} och ställer sig i din
            väg, <q>det där är mina grejer!</q> ";
            exit;
        }
    }

    afterTravel(traveler, connector)
    {
        /* do the normal work */
        inherited(traveler, connector);

        /* if the PC just showed up, kick off our conversation */
        if (traveler == me)
            initiateConversation(plisnikTalking,
                                 introduced
                                 ? 'plisnik-rat' : 'plisnik-intro');
    }

    /* the toy car+rat combo will call this when it comes into our presence */
    eekARat()
    {
        "<.p>Du hör flickaktiga skrik från närheten, sedan kommer {en plisnik/han}
        springande genom tunneln i panik. Han kraschar nästan
        rakt in i dig, men stannar till och griper tag i dina armar.
        <q>Råtta!</q> skriker han åt dig. <q>Enorm, ful, elak!
        Det är inte säkert här nere!</q> Han släpper dig och fortsätter
        springa, och försvinner ner i tunneln. ";

        /* make this the current 'him', since we're mentioned prominently */
        me.setPronounObj(self);

        /* track our departure for "follow", but then disappear */
        trackAndDisappear(self, location.south);
    }

    /* receive notification that the toy car is leaving under its own power */
    ratLeaving()
    {
        "<.p>{Ref plisnik/han} tittar på när råttan lämnar. <q>Din sällskapsråtta
        stack just!</q> säger han och låter lite frenetisk. <q>Du borde
        gå och fånga den innan den kommer undan.</q> ";
    }

    /* receive notification that the rat is moving around locally */
    ratMoving() { ratMovingScript.doScript(); }
    ratMovingScript: StopEventList { [
        '<.p>{Ref plisnik/han} ryggar tillbaka lite, noga med
        att hålla avstånd från råttan. <q>Du borde inte låta din
        sällskapsråtta vandra omkring här nere utan koppel,</q> säger
        han. <q>Det är tur att jag såg dig komma in bärande på den.
        Jag vet inte vad jag skulle ha gjort om det var en <i>vild</i>
        råtta.</q> ',

        '<.p>{Ref plisnik/han} tittar nervöst på när råttleksaken
        rör sig omkring. <q>Jag önskar att du tog bort den där saken härifrån,</q>
        säger han. <q>Även om det är ett husdjur, litar jag fortfarande inte på råttor.</q> ',

        '<.p>{Ref plisnik/han} tittar nervöst på råttleksaken. <q>Jag önskar
        att du tog bort den där råttan härifrån,</q> säger han. ']
    }

    /* get hit with a thrown object */
    throwTargetHitWith(projectile, path)
    {
        if (projectile == ratPuppet)
        {
            /* move the rat to the floor here */
            ratPuppet.moveInto(location);

            /* show our special message */
            ratScript.doScript();
        }
        else
            inherited(projectile, path);
    }

    ratScript: StopEventList { [
        'Råttdockan träffar {ref plisnik/honom} och faller till
        golvet. Han ser vad det är och ryggar tillbaka i skräck,
        men bara för ett ögonblick; hans uttryck blir misstänksamt,
        och han går närmare för att titta. <q>Det är inte särskilt
        snällt,</q> säger han, <q>att kasta en falsk råtta på någon. 
        Råttor är inget att skämta om.</q> ',

        'Råttdockan träffar {ref plisnik/honom} och faller till
        golvet. Han blir överraskad, men bara för ett ögonblick. <q>Jag tyckte
        inte det var särskilt roligt första gången heller,</q> säger han. ']
    }
;
++ InitiallyWorn 'ljusgrön+a hård+a overall+en/skyddshjälm+en/uniform+en/hjälm+en'
    'uniform'
    "Hans ljusgröna overall och matchande skyddshjälm är märkta
    med <q>Network Installer Company</q> i kantiga vita bokstäver.
    <.reveal NIC> "
    isListedInInventory = nil
;

/* since we mention his hand... */
++ DisambigDeferrer, Decoration
    'hans plisnik\'s mannens arbetarens hand+en*händer+na' 'hans hand'
    "Det är inget anmärkningsvärt med hans händer. "
    isQualifiedName = true

    /* never confuse this with the PC's hands */
    disambigDeferTo = [myHands]
;

++ plisnikTalking: InConversationState
    specialDesc = "\^<<getActor().specialDescName>> står
        här och tittar vaksamt på dig. "

    /* infinite timeout - he never stops talking to us while we're here */
    attentionSpan = nil
;
+++ ConversationReadyState
    isInitState = true
    specialDesc = "\^<<getActor().specialDescName>> håller på med någon
        form av arbete på ledningarna i tunneln. "
;
    
++ ConvNode 'plisnik-intro'
    npcGreetingMsg = "<.p>\^<<getActor().theName>> släpper abrupt
        det han håller på med och vänder sig mot dig, och tar ett steg bakåt.
        <q>Vem är du?</q> frågar han. "
;
+++ SpecialTopic 'fråga vem han är'
    ['fråga', 'mannen', 'honom', 'vem', 'han', 'är', 'du']
    "<q>Vem är du?</q> frågar du tillbaka.
    <.p>Han kisar och tittar misstänksamt på dig. <q>Jag är Plisnik,</q>
    säger han. <q>Du har inte sett några råttor här nere, eller hur?</q>
    <<getActor().setIntroduced()>>
    <.convnode plisnik-rat> "
;
+++ HelloTopic
    topicResponse() { replaceAction(TellAbout, plisnik, me); }
;
+++ SpecialTopic 'presentera dig själv'
    ['presentera','mig','dig','själv']
    topicResponse() { replaceAction(TellAbout, plisnik, me); }
;
+++ GiveShowTopic [alumniID, driverLicense]
    topicResponse() { replaceAction(TellAbout, plisnik, me); }
;
+++ TellTopic @me
    "<q>Jag är Doug,</q> säger du.
    <.p>Han tittar misstänksamt på dig. <q>Jag är Plisnik,</q> säger han till slut. <q>Du har inte sett några råttor här nere, eller hur?</q>
    <<getActor().setIntroduced()>>
    <.convnode plisnik-rat> "
;

+++ DefaultAnyTopic
    "<q>Jag vill veta vem du är först,</q> säger han nervöst.
    <.convstay> "

    /* let the rat puppet through to the enclosing topic database */
    excludeMatch = [ratPuppet]
;

++ ConvNode 'plisnik-rat'
    npcGreetingMsg = "<.p>Plisnik släpper det han håller på med och vänder sig mot dig.
        <q>Åh, du igen,</q> säger han, men igenkännandet verkar
        inte göra honom mindre nervös. <q>Du har inte sett
        några råttor här nere, eller hur?</q> "
;
+++ YesTopic
    "<q>Jo, jag har sett några,</q> säger du.
    <.p>Han ryggar tillbaka och hans ögon flackar vilt omkring i tunneln.
    <q>Nå, låt dem inte komma nära mig!</q> säger han. "
;
+++ NoTopic
    "<q>Jag tror inte det,</q> säger du.
    <.p><q>Bra,</q> säger han och tittar misstänksamt runt
    tunnelgolvet. "
;
+++ DefaultAnyTopic
    "<q>Hej!</q> säger han. <q>Jag frågade om du har sett några råttor.
    Har du det?</q><.convstay> "

    /* let the rat puppet through to the enclosing topic database */
    excludeMatch = [ratPuppet]
;

++ AskTellTopic @quadWorkers
    "<q>Vad är det med dina arbetskamrater utanför?</q>
    <.p><q>De är idioter,</q> säger han. <q>Igår fångade de
    en råtta och släppte ner den här. Den bet mig nästan! Se?</q>
    Han sträcker fram sin hand, förmodligen för att visa dig stället där
    han nästan blev biten, men naturligtvis lämnar ett nästan-råttbett
    inte mycket synliga bevis. Han drar tillbaka handen när han
    ser din brist på förvåning. <q>Jag hatar de där typerna.</q> "
;
++ AskTellTopic @plisnik
    "<q>Vad arbetar du med?</q> frågar du.
    <.p><q>Jag försöker bara dra några nätverkskablar,</q> säger han.
    <q>Men råttorna försöker stoppa mig.</q> "
;
++ AskTellTopic @nicTopic
    "<q>Jag har aldrig hört talas om Network Installer Company förut,</q> säger du.
    <.p><q>Hör du, det du aldrig har hört talas om skulle kunna fylla en bok.
    Du har ingen aning om vad som pågår i världen idag. Om du hade det,
    skulle du inte vara här nere där råttorna lever och förökar sig.</q> Han
    ser sig nervöst omkring. "
;
++AskTellTopic @ratTopic
    "<q>Varför är du så orolig för råttor?</q>
    <.p>Hans ansikte blir rött och hans ögon flackar vilt. <q>Jag är inte
    orolig,</q> säger han. <q>Jag är skräckslagen! Och det skulle du också vara
    om du hade någon aning, någon aning, om vad de håller på med.</q> "
;
++ AskTellShowTopic @workOrders
    "<q>Vad finns i den där pärmen?</q> frågar du.
    <.p>Han flyttar sig lite närmare pärmen. <q>Det angår inte
    dig,</q> säger han. <q>Det är konfidentiellt. Företagshemligheter.</q> "
;
++ AskForTopic @workOrders
    "<q>Skulle jag kunna få se din pärm ett ögonblick?</q> frågar du.
    <.p><q>Nej!</q> säger han. <q>Det är viktig konfidentiell
    information.</q> "
;
++ AskTellAboutForTopic [netAnalyzer, quadAnalyzer]
    "<q>Har du en nätverksanalysator jag skulle kunna låna?</q> frågar du.
    <.p>Hans ögon smalnar. <q>Om jag hade det, skulle jag inte kunna låna ut den.
    Det är viktig arbetsrelaterad utrustning.</q> "
;

++ DefaultAnyTopic, ShuffledEventList
    ['<q>Råttor ligger bakom fluoridering av dricksvatten, vet du,</q>
    säger han vetande. ',
     'Han bara tittar misstänksamt på dig. ',
     '<q>Vet du vad källan till varje mänsklig sjukdom är?</q> frågar
     han, och svarar sedan på sin egen fråga: <q>Råttor,</q> säger han, nickande. ',
     '<q>Jag slår vad om att du inte visste att råttor är det enda däggdjur vars
     DNA de aldrig har sekvenserat,</q> säger han. <q>Det borde säga
     dig något om vem som har kontrollen.</q> ',
     'Han bara stirrar på dig. ']
;

/*
 *   Topics for showing the rat.  The first time he sees the rat, we get a
 *   bit of a rise out of him, but once he's seen it he's not startled
 *   again.  In addition, differentiate its use when worn and not worn. 
 */
++ GiveShowTopic @ratPuppet
    "{Ref plisnik/han} rycker tillbaka när han ser leksaksråttan, men tar sedan
    en närmare titt och slappnar av lite. <q>Det där är inte särskilt snällt,</q>
    säger han, <q>att försöka skrämma mig med en leksaksråtta. Jag trodde nästan
    den var äkta tills jag såg att den inte rörde sig.</q>
    <.reveal show-plisnik-rat>
    <.convstay> "
;
+++ AltTopic
    "{Ref plisnik/han} tittar på råttan. <q>Det är inte särskilt snällt
    att försöka skrämma mig med den där leksaksråttan,</q> säger han. <q>Det är tur
    att den inte rör sig, annars skulle jag ha trott att den var äkta.</q>
    <.convstay> "

    isActive = gRevealed('show-plisnik-rat')
;
+++ AltTopic
    "Du håller upp råttan och rör lite på fingrarna för att få
    dess nos att rycka som en riktig råtta. {Ref plisnik/han} ryser och
    hoppar bakåt, men tar sedan en närmare titt och slappnar av lite.
    <q>Det där är inte särskilt snällt,</q> säger han. <q>Jag trodde nästan
    att det var en riktig råtta, tills jag såg din hand i den.</q>
    <.reveal show-plisnik-rat>
    <.convstay> "
    
    isActive = (ratPuppet.isWornBy(me))
;
+++ AltTopic
    "Du rör på fingrarna för att få råttans nos att rycka.
    <q>Det där är inte särskilt snällt,</q> säger {Ref plisnik/han}. <q>Jag trodde nästan
    den var äkta tills jag såg din hand i den.</q>
    <.convstay> "
    
    isActive = (ratPuppet.isWornBy(me) && gRevealed('show-plisnik-rat'))
;

+ netAnalyzer: Keypad, PresentLater, PlugAttachable, NearbyAttachable, Thing
    'netbisco 9099 nätverks|analysator+n' 'nätverksanalysator'
    "Netbisco 9099 nätverksanalysatorn ser ut lite som en
    överdimensionerad telefon som man skulle hitta på en receptionists
    skrivbord på ett stort kontor. Den har en sextonställig hexadecimal
    knappsats (med knappar numrerade 0-F), en liten displayskärm och
    en kort sladd med en speciell kontakt i änden. <<screenDesc>> "

    /* we can only attach to one thing at a time */
    dobjFor(AttachTo) { preCond = (inherited() + objNotAttached) }
    iobjFor(AttachTo) { preCond = (inherited() + objNotAttached) }

    /* it doesn't need to turn on and off */
    cannotTurnOnMsg = 'Den verkar inte ha någon på/av-knapp. Om du
        minns rätt får dessa enheter ström genom att ansluta till en router. '
    cannotTurnOffMsg = (cannotTurnOnMsg)

    /* entering/typing on me redirects to the keypad */
    dobjFor(EnterOn) remapTo(EnterOn, netAnKeypad, IndirectObject)
    dobjFor(TypeLiteralOn) remapTo(TypeLiteralOn, netAnKeypad, IndirectObject)

    /* we can plug into the router */
    canAttachTo(obj) { return obj == nrRouter; }
    explainCannotAttachTo(obj) { "Kontakten passar bara i en viss typ
        av flerstiftsuttag på kompatibla nätverksroutrar. "; }

    /* on attaching to a compatible device, power up */
    handleAttach(other)
    {
        "Så snart du kopplar in kontakten blinkar displayskärmen
        med en serie slumpmässigt nonsens, och visar sedan
        <q>REDO.</q> ";

        /* reset it */
        dispData = 'REDO';
        sourceIP = nil;
    }

    /* we're turned on if anything is attached */
    isOn = (attachedObjects.length() != 0)

    /* add the screen to our description */
    screenDesc()
    {
        /* 
         *   if we're plugged in, show the screen data; otherwise we have
         *   nothing to add to the main description, since the screen is
         *   blank 
         */
        if (isOn)
        {
            "Skärmen visar för närvarande ";
            if (sourceIP == nil)
                "<tt><<dispData>></tt> ";
            else if (sourceIP == infoKeys.spy9IP)
                "numret <tt><<infoKeys.spy9DestIP>></tt>, upprepat
                på tre rader. Du räknar ut den decimala konverteringen av
                den adressen och kommer fram till <<infoKeys.spy9DestIPDec>>. ";
            else if (sourceIP.startsWith('C0A8'))
                "en serie nummer som rullar förbi medan du tittar. ";
            else
                "<tt>LÄSER...</tt> ";
        }
    }

    /* show the current display */
    readDisplay()
    {
        if (!isOn)
            "Den är för närvarande blank. ";
        else
        {
            "Det är en lågupplöst punktmatris-LCD-skärm. ";
            if (sourceIP == nil)
            {
                /* no IP, so just use the display data */
                "Den visar för närvarande <tt><<dispData>></tt>. ";
            }
            else if (sourceIP == infoKeys.spy9IP)
            {
                /* we're showing the camera IP */
                "Den visar för närvarande:
                \b<tt>\t<<infoKeys.spy9DestIP>>
                \n\t<<infoKeys.spy9DestIP>>
                \n\t<<infoKeys.spy9DestIP>></tt>
                \bDu räknar ut den decimala versionen av den adressen,
                och kommer fram till <<infoKeys.spy9DestIPDec>>. ";
            }
            else if (sourceIP.startsWith('C0A8'))
            {
                /* non-camera but valid IP; show random addresses */
                "Den visar för närvarande:
                \b<tt>\t<<randIP>>\n\t<<randIP>>\n\t<<randIP>></tt>
                \bMedan du tittar fortsätter displayen att rulla,
                med nya nummer som dyker upp längst ner. ";
            }
            else
            {
                /* invalid IP; we just sit here and get nothing */
                "Den visar för närvarande <tt>LÄSER...</tt> ";
            }
        }
    }

    /* our current display data */
    dispData = nil

    /* IP address we're currently dumping, if any */
    sourceIP = nil

    /* get a random 192.168.x.x IP address */
    randIP()
    {
        local res;

        /* 
         *   make up a random four-digit hex number, but one that doesn't
         *   have 0, 1, 254, or 255 in either byte 
         */
        do {
            res = rand(65536);
        } while ((res & 0xFF) <= 1
                 || (res & 0xFF) >= 254
                 || (res & 0xFF00) <= 0x100
                 || (res & 0xFF00) >= 0xFE00);

        /* make it a string */
        res = toString(res, 16);

        /* 
         *   extend to four digits (the first digit can't be less than 2,
         *   so at worst we start at three digits) 
         */
        if (res.length() < 4)
            res = '0' + res;

        /* add the 192.168 prefix and return the result */
        return 'C0A8' + res;
    }
;
++ PluggableComponent
    '(netbisco) (9099) (analysator) (nätverksanalysatorns) kort+a speciell+a kontakt+en/sladd+en'
    'nätverksanalysatorns kontakt'
    "Kontakten har en speciell design som passar diagnostikporten på
    vissa typer av kompatibla routrar. "

    /* map ATTACH and USE to our parent */
    dobjFor(PutIn) remapTo(AttachTo, location, IndirectObject)
    dobjFor(PutOn) remapTo(AttachTo, location, IndirectObject)
    dobjFor(AttachTo) remapTo(AttachTo, location, IndirectObject)
    iobjFor(AttachTo) remapTo(AttachTo, DirectObject, location)
    dobjFor(UseOn) remapTo(UseOn, location, IndirectObject)
    iobjFor(UseOn) remapTo(UseOn, DirectObject, location)
;
++ Component, Readable
    '(netbisco) (9099) (analysatorns) (nätverksanalysatorns) punktmatris li:ten+lla display+en/lcd+:n/skärm+en'
    'nätverksanalysatorns display'

    desc() { location.readDisplay(); }
;
++ netAnKeypad: Keypad, Component
    '(netbisco) (9099) (analysatorns) (nätverksanalysatorns) sextonställig+a hexadecimal+a knappsats+en'
    'nätverksanalysatorns knappsats'
    "Knappsatsen har siffrorna 0-9 och A-F, för att mata in hexadecimala tal. "

    dobjFor(TypeLiteralOn) asDobjFor(EnterOn)
    dobjFor(EnterOn)
    {
        verify() { }
        action()
        {
            local str;
            local resp = nil;

            /* change to upper-case hex */
            str = gLiteral.toUpper();
            tadsSay(str);

            /* make sure it's a hex number */
            if (rexMatch('[0-9A-F]+', str) != str.length())
            {
                reportFailure('(Knappsatsen accepterar endast hexadecimala
                    siffror, 0 till 9 och A till F.) ');
                return;
            }

            /* whatever happens, we key in the numbers... */
            "Du knappar in sekvensen. ";

            /* if we're not plugged in, obviously nothing happens */
            if (!location.isOn)
            {
                reportFailure('Displayen förblir blank. ');
                return;
            }

            /* 
             *   if we're clearing the screen, and we have an existing IP
             *   address, show the startup for that address again
             */
            if (str == '55' && location.sourceIP != nil)
                str = '09' + location.sourceIP;

            /* check the code */
            if (str.startsWith('09') && str.length() == 10)
            {
                local addr;

                /* get the address from the rest of the string */
                location.sourceIP = addr = str.substr(3);

                /* show the initial display */
                if (addr == infoKeys.spy9IP)
                {
                    /* it's the camera - show the other side */
                    "Displayen rensas, sedan visar den
                    <tt><<infoKeys.spy9DestIP>></tt>. Efter några ögonblick
                    upprepas samma nummer på en ny rad, sedan på en
                    tredje rad. Du tittar en liten stund, men alla
                    paket verkar gå till samma plats.
                    <.p>Det är bra---det betyder att det bara finns en dator
                    som du behöver spåra. Du konverterar hexadecimaltalen
                    till decimaler och kommer fram till <<infoKeys.spy9DestIPDec>>.
                    Nu behöver du bara ta reda på var datorn
                    med den adressen finns.
                    <.reveal spy9-dest-ip> ";

                    /* this merits some points */
                    scoreMarker.awardPointsOnce();
                }
                else if (addr.startsWith('C0A8'))
                {
                    /* 
                     *   a valid 192.168 address, but not one we know;
                     *   show random results 
                     */
                     "Displayen rensas, sedan visar den
                    <tt>READING...</tt> under en bråkdel av en sekund, sedan 
                    börjar Displayen visa siffror som skrollar förbi:
                    \b<tt>\t<<location.randIP>>
                    \n\t<<location.randIP>>
                    \n\t<<location.randIP>></tt>
                    \bNya nummer fortsätter att dyka upp, och skrollar 
                    bort de gamla siffrorna från skärmen. ";
                }
                else
                {
                    /* not a valid 192.168 address; show no traffic */
                    "Displayen rensas och visar <tt>READING...</tt> ";
                }
            }
            else if (str == '55')
            {
                /* not sniffing packets - just show READY */
                "Displayen ändras till att visa <tt>READY</tt>. ";
                resp = 'READY';
            }
            else
            {
                /* use a random error response */
                resp = rand(['ERR INV CMDCD', 'ERR UNK CYRRG',
                             'ERR CRW FNZPW', 'ERR CDN CPC C',
                             'ERR STK OVFLW', 'ERR FLTPT ASI',
                             'ERR OUTOFMEMR', 'ERR CLS LDR E',
                             'ERR SIG9 SEGV', 'ERR DLL NTFND']);

                /* show the error */
                "Displayen ändras till att visa <tt><<resp>></tt>. ";

                /* no IP */
                location.sourceIP = nil;
            }

            /* set the new value */
            location.dispData = resp;
        }
    }

    scoreMarker: Achievement { +5 "spåra kamerans datapaket" }
;
++ Button, Component
    '(netbisco) (9099) (analysatorns) (nätverksanalysatorns) (knappsats+iga)
    0 1 2 3 4 5 6 7 8 9 "a" "b" "c" "d" "e" "f" knappsats+knapp+en*knappsats|knappar+na'
    'nätverksanalysatorns knappsatsknapp'

    dobjFor(Push)
    {
        verify() { logicalRank(50, 'dekorativa knappar'); }
        action() { "(Du behöver inte trycka på knapparna
            individuellt; skriv bara in siffrorna på knappsatsen.) "; }
    }
;

/* 
 *   this falls out of the binder when we open the binder, so it's not
 *   actually anywhere until then 
 */
netAnInstructions: PresentLater, Readable
    'smutsig:t+a slit:et+na n:te generation+s generationen+s papper:et^s+ark+et/fotokopia+n/ark+et/papper+et/pappret'
    'smutsigt pappersark'
    "Pappersarket är smutsigt och lite slitet, som om det
    har hanterats mycket. Det ser ut som en n:te generationens fotokopia.
    <.p>
    <.blockquote><tt>
    <center>-12-</center>
    <br><br>
    inte för användarinsättning upp. VARNING: ALLTID INTE ATT INSTALLERA OM
    KONTAKT STRÖM AV!!! Men när öppnad är, knapptryckning insatt vara
    måste. Sida 52 instruktion fortsättning referera till också.

    <br><br><u>PAKETLUKTNING</u><br>
    För övervakning datapaket gå till och från. Om vet trevlig IP
    adress till källa, då användare hittade IP också destination. MÅSTE
    ATT SKRIVA IP I HEXADECIMAL. Användare till knappsatsinmatning FUNKTIONSKOD 71
    sedan knappsatsinmatning IP källadress. ALLT TILLSAMMANS!!! T.ex.,
    710ABCDEF1 om IP källa som 10.188.222.241. Eftersom 0A=10 -
    BC=188 - DE=222 - F1=241, så IP nummer punktnotation till
    10.188.222.241. MEN MODELL 9099 INTE ATT ANVÄNDA FUNKTIONSKOD 71!!!
    Måste att referera sida 59 instruktion för MODELL 9099
    SPECIALKODER.

    <br><br>Efter knappsatsinmatning, IP adress till DESTINATION visa
    på displayfönster vid datapaket överföring. IP TILL
    DESTINATION OCKSÅ I HEX!!! Gör normal punktnotation med
    DECIMAL konvertera. T.ex., på displayfönster visa 0ABCDEF1,
    konvertera för 10.188.222.241. Njut så enkelt! OBS. Om
    datapaket många överföra, displayfönster fullt bli kommer.
    Displayfönster tveka, senare att rulla. FUNKTIONSKOD 72
    displayfönster att tömma.

    <br><br><u>SÄTT ADRESS \"I P\" TILL PORT</u><br>
    Trevlig IP adress måste tilldelad vara när konfigurera router. INTE ATT
    UPPREPA IP ADRESS I TVÅ PORT PLATSER SAMTIDIGT!!! Eller dålig
    kollision hända. Referera till sida 40 för kollision
    lösning om misstänkt att hända,
    </tt><./blockquote>

    <.p>Handskrivet längst ner på sidan finns några siffror:
    <font face='tads-sans'>9099: 70=07, 71=09, 72=55, 57=18</font> "
;

/* ------------------------------------------------------------------------ */
/*
 *   Tunnel end
 */
steamTunnel11: SteamTunnelRoom 'Ath Tunnel' 'tunneln nära Ath'
    "Ångledningarna tunnas ut lite här, och tunneln slutar
    österut vid en dörr som leder in i Ath, om du minns rätt.
    Tunneln fortsätter västerut, upp för en kort betongtrappa. "

    west = st11Stairs
    up asExit(west)
    east = st11Door
;

+ st11Stairs: StairwayUp
    'kort+a trapp+steg+en/betong+trappa+n*betong|trappor+na' 'kort trappa'
    "Trappan leder upp några steg västerut. "
;

+ st11Door: AlwaysLockedDoor 'ath athenaeum öst+ra ö dörr+en/ath-dörr+en' 'Ath-dörren'
    "Dörren är omärkt, men du minns att den leder
    in i Ath-källaren. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Steam tunnel at dead end
 */
steamTunnel8: SteamTunnelRoom 'Återvändsgränd' 'återvändsgränden'
    "<<seen ? "" :
      "Du tillbringade mycket tid med att utforska ångtunnelsystemet
      under dina år här som student, men du tror inte att du har
      stött på den här sektionen tidigare.<.p>">>
    Ångtunneln från söder når en återvändsgränd här; den
    vidgas något i det nordöstra hörnet och skapar en skuggig nisch ett
    par fot djup. På tunnelns västra sida finns en dörr
    märkt <q>Förråd.</q> En liten öppning lågt på östra väggen leder
    in i ett kryputrymme.
    <.p>Du lägger märke till en blå kabel delvis dold bakom ångledningarna. "

    lookBehindPipes()
    {
        "Det finns en blå nätverkskabel delvis dold bakom
        en av de stora ångledningarna. <<st8Wire.wireDesc>> ";
    }

    east = st8Crawl
    west = st8Door
    south: TravelConnector
    {
        connectorStagingLocation = lexicalParent
        dobjFor(TravelVia)
        {
            action()
            {
                if (lexicalParent.workersPresent)
                {
                    /* the workers are in the room, so get them out here */
                    "Du börjar gå ner i tunneln, men dörren öppnas innan
                    du hinner förbi, och två arbetare i ljusgröna
                    overaller kliver ut. ";
                }
                else
                {
                    /* 
                     *   the workers aren't in the room, so they come in
                     *   from the tunnel 
                     */
                    "Innan du hinner särskilt långt kommer ett par arbetare i
                    ljusgröna overaller gående upp genom tunneln
                    från söder. De slutar abrupt att prata när
                    de ser dig. ";
                }

                /* in either case, cue the workers, and we're done */
                st8Workers.workerEntry(nil);
            }
        }
    }

    roomParts = [defaultFloor, defaultCeiling, defaultNorthWall]

    /* flag: the workers are present in the network room */
    workersPresent = true

    /* flag: the workers need to come back later */
    workersReturning = nil

    /* our score award for making it here */
    scoreMarker: Achievement { +10 "spåra kamerakabeln" }

    /* number of consecutive turns we've been here */
    hereCount = 0

    /* do some special work when a traveler arrives */
    afterTravel(traveler, conn)
    {
        /* 
         *   award points for tracing the wire all the way here on our
         *   first arrival 
         */
        scoreMarker.awardPointsOnce();

        /* reset the count of consecutive turns we've been here */
        hereCount = 0;

        /* do the normal work */
        inherited(traveler, conn);
    }

    /* reset the turns-here counter on nested room travel as well */
    actorTravelingWithin(origin, dest)
    {
        if (dest == self)
            hereCount = 0;
    }


    /* whenever we're in the room, check for worker arrivals/departures */
    roomDaemon()
    {
        /* do the normal work first */
        inherited();

        /* 
         *   Count this as a turn we're in the room.  Since the room daemon
         *   only fires when the PC is in the room, we know they're here if
         *   we're running at all. 
         */
        ++hereCount;

        /* 
         *   If the workers are in the control room, they might want to
         *   leave; if they're not, they might want to arrive.  If they're
         *   already in the hallway with us, we obviously don't need to do
         *   either of these.  
         */
        if (!st8Workers.isIn(steamTunnel8))
        {
            if (workersPresent)
            {
                /* 
                 *   the workers are here; if the PC has been here a few
                 *   turns, it's time for the workers to leave 
                 */
                if (hereCount == 3)
                {
                    /* warn that they're about to leave */
                    "<.p>Någon på andra sidan dörren öppnar den något. 
                    Du hör en mansröst säga: <q>Kom igen, 
                    kom så går vi.</q>";
                    
                    /* mark the door as unlocked and ajar */
                    st8Door.makeLocked(nil);
                    st8Door.isAjar = true;
                    
                    /* start the one-turn fuse to get them going */
                    st8Workers.setEntryFuse();
                }
            }
            else
            {
                /* 
                 *   the workers are gone; if we left without seeing them
                 *   leave before, bring them back after a few turns 
                 */
                if (workersReturning && hereCount == 2)
                {
                    /* warn that the workers are coming back */
                    "<.p>Du hör någon närma sig från tunneln till söder. ";
                    
                    /* start the fuse to bring them back */
                    st8Workers.setEntryFuse();
                }
            }
        }
    }
;

+ st8Workers: PresentLater, Person 'större mindre arbetare+n*män+nen' 'arbetarna'
    "De två männen bär ljusgröna overaller märkta
    <q>Network Installer Company</q> i vita bokstäver. Den större
    av de två är byggd som en fotbollsspelare. De står
    obehagligt nära dig, med armarna i kors och med misstänksamhet i
    ansiktena.<.reveal NIC> "

    actorHereDesc = "De två arbetarna står hotfullt nära dig,
        med armarna i kors. "

    isPlural = true
    isHim = true

    /* schedule the entry fuse */
    setEntryFuse()
    {
        /* note that we're about to arrive */
        aboutToArrive = true;

        /* set the fuse for the next turn */
        new Fuse(self, &entryFuse, 1);
    }

    /* fuse that fires when it's time for the workers to enter */
    entryFuse()
    {
        /* 
         *   have the workers enter, showing an appropriate arrival
         *   announcement 
         */
        workerEntry(true);
    }

    /* flag: we're about to arrive */
    aboutToArrive = nil

    /* 
     *   handle worker entry - this is called by our fuse that controls
     *   the workers' movements, but can also be called directly to
     *   trigger their appearance on specific events 
     */
    workerEntry(announce)
    {
        local fromDoor = (steamTunnel8.workersPresent);

        /* we're no longer about to arrive */
        aboutToArrive = nil;

        /* 
         *   we always go through the door (either in or out), so reset
         *   the combination lock, since it resets each time the door is
         *   opened 
         */
        st8DoorLock.resetCombo();

        /* 
         *   if we're already in steamTunnel8, we must have been
         *   expedited; ignore it if so 
         */
        if (isIn(steamTunnel8))
            return;
            
        /* if the player character is present, mention what's going on */
        if (me.isIn(steamTunnel8))
        {
            /* announce the entry if desired */
            if (announce)
            {
                /* our arrival mode depends on where we're coming from */
                if (fromDoor)
                    "<.p>Dörren öppnas helt och två arbetare i ljusgröna
                    overaller kliver ut och stänger dörren bakom sig. ";
                else
                    "<.p>Två arbetare i ljusgröna overaller kommer gående från
                    den södra tunneln. ";
            }

            /* are we hiding? */
            if (me.isIn(st8Nook) || me.isIn(st8CrawlOpening))
            {
                if (me.isIn(st8Nook))
                    "Du låtsas att du är i en spionfilm och pressar dig
                    mot väggen, gömmer dig bakom några ångrör
                    nära hörnet. Vilket verkar fungera---de två
                    verkar inte märka dig. ";
                else
                    "De verkar inte märka att du gömmer dig i krypgången. ";

                if (fromDoor)
                {
                    "De stänger dörren och går söderut ner i tunneln.
                    Efter några steg hör du en av dem säga <q>Vänta
                    lite, jag glömde något.</q> ";

                    if (me.isIn(st8Nook))
                        "Du tittar från bakom skyddet av rören
                        när den mindre killen återvänder till dörren och
                        slår in en kombination, som du lyckas
                        uppfatta: <<st8Door.showCombo>>. ";
                    else
                        "Du tittar när den mindre killen återvänder till dörren
                        och slår in en kombination, men du kan inte riktigt urskilja
                        siffrorna från en så låg utsiktspunkt. ";

                    "Han slinker in i rummet ett ögonblick, sedan är han
                    tillbaka och stänger dörren bakom sig. De två går
                    söderut; du hör deras steg avlägsna sig ner i tunneln. ";
                }
                else
                {
                    if (me.isIn(st8Nook))
                        "Du tittar från bakom skyddet av rören när
                        den mindre killen går till dörren och slår in en
                        kombination, som du precis lyckas uppfatta:
                        <<st8Door.showCombo>>. ";
                    else
                        "Du tittar när den mindre killen går till dörren
                        och slår in en kombination, men du kan inte riktigt
                        urskilja siffrorna från en så låg utsiktspunkt. ";

                    "Han går genom dörren; den större killen stannar
                    utanför. Efter några ögonblick kommer den mindre arbetaren
                    ut genom dörren. <q>Fixat,</q> säger han och stänger
                    dörren. De två går iväg ner i tunneln. ";
                }

                if (me.isIn(st8Nook))
                {
                    /* we now know the combination */
                    gReveal('supplies-combo');

                    /* the workers are now gone for good */
                    steamTunnel8.workersPresent = nil;
                    steamTunnel8.workersReturning = nil;
                }
                else
                {
                    /* 
                     *   We weren't caught, but we didn't get the combo;
                     *   we'll have to bring the workers back again.  Since
                     *   we didn't go anywhere, the workers have to come
                     *   from down the tunnel next time - they can't come
                     *   from the door, as we won't have seen them go into
                     *   the room if we don't leave.  
                     */
                    steamTunnel8.workersPresent = nil;
                    steamTunnel8.workersReturning = true;
                }
            }
            else
            {
                /* not hiding - move the workers here */
                makePresent();
                
                /* start the ejection conversation */
                initiateConversation(nil, 'intruder-alert');
            }
        }
        else
        {
            /*
             *   We snuck off at the first sign of danger.  That'll save us
             *   from being caught, but it doesn't let us see the
             *   combination to the door.  So, to give us a chance to get
             *   the combo again: swap the workers 'present' and
             *   'returning' states, so that they'll come back if they just
             *   left, and they'll leave if they just came back.  
             */
            steamTunnel8.workersPresent = !fromDoor;
            steamTunnel8.workersReturning = fromDoor;
        }

        /* whatever happened, the door is no longer ajar */
        st8Door.isAjar = nil;
    }

    /* intercept actions when we're present */
    beforeAction()
    {
        /* do the normal work */
        inherited();
        
        /* 
         *   if the action is travel, or involves the nook, the door, or
         *   the crawlspace, take over and kick them out of the tunnel 
         */
        if (gActionIs(TravelVia)
            || gDobj == st8Nook
            || gDobj == st8Door
            || (gDobj != nil && gDobj.isIn(st8Door))
            || gDobj == st8Crawl)
        {
            /* kick them out */
            "Den större arbetaren flyttar sig ännu närmare och blockerar dig.
            <q>Åh nej, det gör du inte,</q> säger han. ";
            escortOut();

            /* don't continue with the original command */
            gAction.cancelIteration();
            exit;
        }

        /* special handling for "yell" */
        if (gActionIs(Yell))
        {
            "Vid närmare eftertanke kanske det inte är en så bra idé att
            dra till sig ännu mer uppmärksamhet. ";
            exit;
        }
    }

    /* if we've scheduled an escort, do so now */
    afterAction()
    {
        /* escort out if we asked for it */
        if (escortPending)
        {
            /* do the escort */
            escortOut();

            /* clear the pending flag */
            escortPending = nil;
        }
    }

    /* 
     *   Schedule an escortOut for the end of this turn.  This is a
     *   convenience for topic responses; we don't want to put the actual
     *   escort action in a topic response, since it can confuse the
     *   response processor by making it think the whole new room
     *   description is part of the response text. 
     */
    escortLater() { escortPending = true; }
    escortPending = nil

    /* kick the player out of the steam tunnel */
    escortOut()
    {
        "<.p>Han tar tag i din arm med ett hårt grepp och börjar styra
        dig ner i tunneln. Det finns inte mycket du kan göra för att stå emot.
        Han marscherar dig genom en serie svängar, upp för en trappa, och
        ut genom en dörr till solljuset.
        <.p><q>Du ska vara glad att jag inte ringer väktarna,</q> säger han.
        <q>Låt mig inte komma på dig med att inkräkta igen!</q> Han släpper
        dig, går tillbaka genom dörren och smäller igen den. ";

        /* move me out */
        me.moveIntoForTravel(ldCourtyard);

        /* 
         *   Reset the workers.  Simply leave us in the control room; it'll
         *   take the PC a while to get back there, so it'll be plausible
         *   that we've returned by that time.  When the PC returns, we'll
         *   repeat the whole cycle.  If we've already learned the
         *   combination, then we did the escort only to keep the PC from
         *   going south, hence we don't need to repeat the cycle.  
         */
        moveInto(nil);
        steamTunnel8.workersPresent = !gRevealed('supplies-combo');
        steamTunnel8.workersReturning = nil;

        /* show our new location as though we just traveled normally */
        "<.p>";
        me.lookAround(gameMain.verboseMode.isOn);

        /* note that we've been escorted out at least once */
        gReveal('escorted-out-of-tunnels');

        /* we're not in conversation any more; reset our ConvNode */
        setConvNode(nil);
    }
;

++ InitiallyWorn 'ljusgrön+a hård+a *overaller+na/uniformer+na' 'overaller'
    "Arbetarna bär ljusgröna overaller och matchande skyddshjälmar,
    märkta <q>Network Installer Company</q> i kantiga vita bokstäver.
    <.reveal NIC> "
    isPlural = true
    isListedInInventory = nil
;

++ ConvNode 'intruder-alert'
    npcGreetingMsg = "De tittar misstänksamt på dig.
        <.p><q>Hej! Vem är du?</q> frågar den större av de två,
        den som är byggd som en fotbollsspelare. Han rör sig hotfullt
        nära dig, korsar armarna och rynkar pannan."
;

+++ SpecialTopic 'säg att du har gått vilse'
    ['säg','att','jag','är','du','är','har','gått','vilse']
    "<q>Jag har på något sätt gått vilse,</q> säger du.
    <.p>Den större killen kisar mot dig. <q>Vilse?</q> säger han. <q>Tja,
    låt mig hjälpa dig att hitta vägen.</q><<st8Workers.escortLater>> "
;
+++ SpecialTopic 'förklara om kameran'
    ['förklara','berätta','om','kamera','kameran']
    "<q>Så, jag hittade den här, öh...</q> Det slår dig plötsligt att
    det kanske inte är en så bra idé att berätta för vem som helst om
    kameran, åtminstone inte förrän du har en bättre uppfattning om vad som pågår.
    Och dessa killar ser inte ens ut som Caltech-personal, trots allt.
    <q>...öh, överhettade ångröret...</q>
    <.p><q>Tja, du kanske borde ringa B-och-G och rapportera det. 
    Kom, låt mig hjälpa dig att hitta en telefon.</q>
    <<st8Workers.escortLater>> "
;
+++ SpecialTopic 'påstå att du är en arbetsledare'
    ['påstå','säg','ljug','om','att','jag','är','en','arbetsledare']
    "<q>Huvudkontoret skickade ner mig för att, öh, kontrollera er produktivitet.
    Jag vill se era tidkort just nu, tack.</q>
    <.p>De två tittar på varandra. <q>Jag ser inte din uniform,</q>
    säger den större killen. <q>Jag ser inte ditt ID-kort heller. Jag antar
    att du lämnade dem på <q>huvudkontoret.</q> Här, låt mig visa dig
    vägen dit.</q><<st8Workers.escortLater>> "
;
+++ DefaultAnyTopic
    "Den större killen grymtar. <q>Vem du än är, så är du inte tillåten
    här nere,</q> säger han. <q>Du kommer med mig.</q>
    <<st8Workers.escortLater>> "
;

+ st8Wire: Immovable 'blå+a nätverks|kabel+n' 'blå kabel'
    "Kabeln är delvis dold bakom ett stort ångrör. <<wireDesc>> "
    wireDesc = "Kabeln kommer in från kryputrymmet, följer sedan ett
        av de stora rören norrut längs östra väggen, vänder för att följa
        ett annat rör över norra väggen, och vänder igen längs
        västra väggen. Bara ett par tum från dörren försvinner
        kabeln in i ett litet hål borrat i väggen. "

    dobjFor(Follow) asDobjFor(Examine)
    isNominallyIn(obj) { return obj == st8Hole || inherited(obj); }
;

+ Fixture 'väst+ra v vägg+en*väggar+na' 'västra väggen'
    "Den blå kabeln är trädd genom ett litet hål i väggen, några
    tum från dörren. "
;

++ st8Hole: Fixture 'li:tet+lla hål+et' 'litet hål'
    "Hålet är ett par tum från dörren. Den blå
    kabeln är trädd genom hålet. "

    lookInDesc = "Den blå kabeln är trädd genom hålet. "
;

+ Fixture 'ö+stra vägg+en*väggar+na' 'östra väggen'
    "Lågt på väggen finns en öppning till ett trångt kryputrymme. "
;

++ st8Crawl: TravelWithMessage, ThroughPassage
    'trång+a låg+a öppning+en/kryputrymme+t/krypgång+en/tunnel+n' 'kryputrymme'
    "Öppningen ser precis stor nog ut för att krypa in i. "

    travelDesc = "Du kryper in med huvudet först i passagen och drar
        dig fram ungefär åtta fot innan du kommer ut i
        en annan ångtunnel. "

    dobjFor(HideIn) remapTo(LieOn, st8CrawlOpening)
;

/* secret nested room for when we're hiding in the tunnel */
+ st8CrawlOpening: OutOfReach, Fixture, BasicChair
    name = 'krypgång'

    objInPrep = 'i'
    actorInPrep = 'i'
    actorOutOfPrep = 'ut från'

    obviousPostures = [lying]
    allowedPostures = [lying]

    tryRemovingFromNested() { return tryImplicitAction(GetOutOf, self); }

    /* as with the nook, we can reach inside from outside, not vice versa */
    canObjReachContents(obj) { return true; }
    canReachSelfFromInside(obj) { return true; }

    /* we can reach our surrogate crawlway opening, of course */
    canReachFromInside(obj, dest) { return dest == st8Crawl; }

    /* we don't show up for 'all', but allow in defaults */
    hideFromAll(action) { return true; }
    hideFromDefault(action) { return inherited(action); }

    dobjFor(LieOn)
    {
        action()
        {
            /* do the normal work */
            inherited();

            /* mention that we're hiding in the opening */
            "Du kryper baklänges in i öppningen, så pass långt att 
            du är utom synhåll. ";
        }
    }

    makeStandingUp()
    {
        /* stand us up in the main tunnel */
        gActor.makePosture(location.defaultPosture);
        gActor.travelWithin(location);

        "Du kryper ut ur tunneln och ställer dig upp. ";
    }

    /* we can't go east from here */
    east: NoTravelMessage { "Det är för svårt att krypa 
                            baklänges genom en sån trång 
                            passage; du måste ta dig ut 
                            först så du kan vända dig om. "; }

    /* likewise for ENTER CRAWLWAY */
    tryMakingTravelReady(conn)
    {
        if (conn == st8Crawl)
            return replaceAction(East);
        else
            return inherited(conn);
    }
;

+ st8Nook: OutOfReach, Fixture, Platform 'skuggig+a mörk+a nisch+en/skugga+n*skuggor+na' 'nisch'
    "Nischen är ett par fot djup---tillräckligt för att stå i, men den
    leder ingenstans. Den är nästan helt i skugga. "

    objInPrep = 'i'
    actorInPrep = 'i'
    actorOutOfPrep = 'ut ur'
    dobjFor(Enter) asDobjFor(StandOn)
    tryRemovingFromNested() { return tryImplicitAction(GetOutOf, self); }

    dobjFor(HideIn) remapTo(StandOn, self)
    dobjFor(StandOn)
    {
        action()
        {
            /* do the normal work */
            inherited();

            /* add an extra message if we succeeded */
            if (gActor.isIn(self))
                "Du kliver in i nischens skugga. ";
        }
    }

    /* 
     *   We can't reach things outside the nook from inside the nook, but
     *   we can reach inside the nook from outside.  The asymmetry comes
     *   from the idea that the nook is a small part of the room, so we
     *   have to move out of the nook to reach anything else in the room.  
     */
    canObjReachContents(obj) { return true; }
    canReachSelfFromInside(obj) { return true; }

    /* 
     *   to remove the out-of-reach obstruction, get out of the nook if
     *   we're inside 
     */
    tryImplicitRemoveObstructor(sense, obj)
    {
        if (sense == touch && gActor.isIn(self))
            return tryRemovingFromNested();
        else
            return inherited(sense, obj);
    }
;

+ st8Door: Keypad, Lockable, Door '"förråd" väst+ra v förråd:et^s+dörr+en' 'dörr'
    "Dörren är märkt <q>Förråd,</q> och den har ett av de där
    mekaniska kodlåsen. "

    /* 
     *   we're locked if we're closed and the right combo isn't on the
     *   keypad accumulator 
     */
    isLocked() { return !isOpen && st8DoorLock.comboAcc != internCombo; }

    /* a special state for "slightly ajar" */
    isAjar = nil

    /* supplement the open status message for the "ajar" state */
    openDesc = (isAjar ? 'lite på glänt' : inherited)

    /* the internal combo - this is just the string of combo digits */
    internCombo = static (infoKeys.st8DoorCombo)

    /* 
     *   the display version of the combo - to generate the display
     *   version, put a hyphen between each digit, which we can do by
     *   replacing each digit that's followed by another digit with itself
     *   plus a hyphen 
     */
    showCombo = static (rexReplace('(<digit>)(?=<digit>)', internCombo,
                                   '%1-', ReplaceAll, 1))

    /* 
     *   once we've successfully used the combination, allow automatic
     *   unlocking on future attempts to open the door 
     */
    autoUnlockOnOpen = (usedCombo)

    /* the lock status is never visually apparent */
    lockStatusObvious = nil

    /* 
     *   Have we successfully used the combination before?  We track this
     *   so that we can grant that the PC knows the combo after they've
     *   used it once manually, in which case we don't need to make them
     *   repeat the manual key entry on future visits; we'll just enter the
     *   combo automatically for them.  
     */
    usedCombo = nil

    dobjFor(Open)
    {
        check()
        {
            if (isAjar && steamTunnel8.workersPresent)
            {
                /* the workers are inside */
                "Du sträcker ut handen för att öppna dörren, 
                men någon öppnar den från andra sidan först. 
                Två arbetare i ljusgröna overaller kliver ut 
                i tunneln och stänger dörren bakom dem. ";

                /* trigger the workers */
                st8Workers.workerEntry(nil);

                /* forget the 'open' action */
                exit;
            }
            else if (isLocked())
            {
                /* reset the combination on attempting to turn the handle */
                st8DoorLock.resetCombo();

                /* mention what happens */
                "Du testar dörren, men det enda som händer är 
                ett klickande ljud låter från låsmekanismen. ";

                /* terminate the action */
                exit;
            }
            else if (steamTunnel8.workersPresent)
            {
                /* the workers are inside */
                "Du öppnar dörren och upptäcker ett par arbetare i
                ljusgröna overaller. De tittar upp förvånat på dig,
                och kliver sedan ut i korridoren och stänger dörren 
                bakom sig. ";

                /* cue the workers */
                st8Workers.workerEntry(nil);

                /* forget the rest of the 'open' action */
                exit;
            }
            else if (steamTunnel8.workersReturning)
            {
                /* 
                 *   they're not inside, but they're coming back; expedite
                 *   their return to happen right now 
                 */
                st8Workers.workerEntry(true);

                /* forget the 'open' action */
                exit;
            }
        }

        action()
        {
            /* do the normal work */
            inherited();

            /* if we're now open, reset the lock */
            if (isOpen)
            {
                /* mention it */
                "Låsmekanismen klickar och surrar, 
                och dörren öppnas upp. ";

                /* reset it */
                st8DoorLock.resetCombo();

                /* note that we've successfully used the combo */
                usedCombo = true;
            }
        }
    }

    dobjFor(Lock)
    {
        verify() { logicalRank(50, 'self-locking door'); }
        check()
        {
            "Det finns inget uppenbart sätt att låsa dörren, 
            men din tidigare erfarenhet säger att dörren 
            kommer att låsa sig automatiskt varje gång den 
            öppnas och sedan stängs igen. ";
            exit;
        }
    }

    dobjFor(Unlock)
    {
        verify() { logicalRank(50, 'self-locking door'); }
        check()
        {
            /* 
             *   if we've used the combo before, allow it; if not, we need
             *   to do this manually with keypad entry, so say so 
             */
            if (!usedCombo)
            {
                 "Det verkar som om du måste ange en kombination på
                knappsatsen för att låsa upp dörren. ";
                exit;
            }
        }
        action()
        {
            /* 
             *   if we made it this far, we know the combo, so just say
             *   we're using it 
             */
            "Du slår in kombinationen på knappsatsen. ";
            st8DoorLock.resetCombo();
            st8DoorLock.addToCombo(internCombo);
        }
    }

    dobjFor(EnterOn) remapTo(EnterOn, st8DoorLock, IndirectObject)
    dobjFor(TypeLiteralOn) remapTo(TypeLiteralOn, st8DoorLock, IndirectObject)

    dobjFor(Knock)
    {
       action()
        {
            "Ljudet av din knackning ekar i tunneln. ";

            if (steamTunnel8.workersPresent)
            {
                "Dörren öppnas och avslöjar en stor man i ljusgröna
                overaller. Han kliver ut, tillsammans med en annan,
                kortare man klädd på samma sätt, och de stänger dörren. ";

                st8Workers.workerEntry(nil);
            }
            else
                "Det verkar inte komma något svar. ";
        }
    }
;

++ st8DoorLock: Keypad, Fixture
    '(mekanisk+a) knappsats:en+lås+et/lås+et/låsning+en/(dörrens) nyckel+sats+en/mekanism+en/knappsats+en'
    'knappsatslås'
    "Det är en typ av lås du har sett förut i kontor och andra
    offentliga byggnader. Knappsatsen har tryckknappar märkta 0 till 9,
    ordnade i två kolumner, plus en större <q>Återställ</q>-knapp längst
    ner. "

    /* reset the combination */
    resetCombo() { comboAcc = ''; }

    /* add a string of digits to the combination */
    addToCombo(digits) { comboAcc += digits; }

    /* 
     *   the combination accumulator - as buttons are pressed, we keep
     *   track of the combination so far 
     */
    comboAcc = ''

    dobjFor(EnterOn)
    {
        verify() { }
        action()
        {
            local combo;

            /* get the literal string we're entering */
            combo = gLiteral;

            /* remove spaces and dashes */
            combo = rexReplace('<space|->', combo, '', ReplaceAll, 1);

            /* make sure it looks valid */
            if (rexMatch('[0-9]+', combo, 1) != combo.length())
            {
                "Du kan bara skriva in siffror på knappsatsen. ";
                return;
            }

            /* add the digits */
            addToCombo(combo);

            /* let them know it worked */
            "Du trycker på knapparna i sekvens: ";
            for (local i = 1, local len = combo.length() ; i <= len ; ++i)
            {
                say(combo.substr(i, 1));
                if (i != len)
                    "-";
            }
            ". mekanismen i knappsatsen klickar för varje knapptryckning. ";
        }
    }
    dobjFor(TypeLiteralOn) asDobjFor(EnterOn)
;
+++ Button, Component
    '(lås+et) (knappsats+en) numrerade metall 0 1 2 3 4 5 6 7 8 9 "återställ"
    tryckknapp+sats+en*knappar+na*tryckknappar+na'
    'låsknappsatsknapp'
    "Numrerade knappar märkta 0 till 9 är ordnade i två kolumner, och
    längst ner finns en större knapp märkt <q>Återställ.</q> "

    dobjFor(Push) { action() { "(Du behöver inte trycka på knapparna
        individuellt; ange bara kombinationen på knappsatsen.) "; } }
;

+++ Button, Component
    '"återställ" metall tryck|knapp+en*tryck|knappar+na'
    '<q>Återställ</q>-knapp'
    "Det är en metallknapp märkt <q>Återställ.</q> "

    dobjFor(Push)
    {
        action()
        {
            "Mekanismen inne låset klickar flera gånger när
            du trycker in knappen. ";
            location.resetCombo();
        }
    }
;

++ SimpleNoise
    desc = "Du tycker dig höra röster på andra sidan dörren. "
    soundPresence = (steamTunnel8.workersPresent)
;

/* ------------------------------------------------------------------------ */
/*
 *   The network room in the tunnels 
 */
networkRoom: Room 'Nätverksrum' 'nätverksrummet'
    "Dörren utanför är märkt <q>Förråd,</q> men det är tydligen
    inaktuellt; det ser ut som om detta faktiskt används som ett 
    nätverkskontrollrum. Rummet domineras av en golvstående 
    nätverksrouter, till vilken hundratals orange, vita,
    och gula nätverkskablar är anslutna. Kablarna är samlade i jättelika
    buntar i storlek med brandslang, som leder in i ledningar som går
    ut genom väggarna.
    <.p>En ensam blå nätverkskabel kommer in genom ett litet hål i
    väggen bredvid dörren, som leder ut ur rummet österut. "

    vocabWords = 'nätverks|rum+met'

    east = nrDoor
    out asExit(east)

    /* award points on first arrival */
    afterTravel(traveler, conn)
    {
        scoreMarker.awardPointsOnce();
        inherited(traveler, conn);
    }
    scoreMarker: Achievement { +5 "att komma in i nätverksrummet" }

    roomParts = static (inherited - defaultEastWall)
;

+ nrDoor: Door ->st8Door 'öst+ra ö dörr+en' 'dörr'
    "Dörren leder ut ur rummet österut. "

    dobjFor(Lock)
    {
        verify() { logicalRank(50, 'auto-locking'); }
        action() { "Det finns inget uppenbart sätt att låsa dörren; den låses
            förmodligen automatiskt när den stängs. "; }
    }
    dobjFor(Unlock)
    {
        verify() { logicalRank(50, 'auto-locking'); }
        action() { "Det finns inget uppenbart sätt att låsa upp den, men dörren
            kan öppnas från denna sida utan att låsa upp den. "; }
    }
;

+ Fixture 'öst+ra ö vägg+en*väggar+na' 'östra väggen'
    "En blå kabel är trädd genom ett litet hål i väggen bredvid
    dörren. "
;
++ nrHole: Fixture 'litet lilla pyttelitet hål+et' 'litet hål'
    "Hålet är precis bredvid dörren. En blå nätverkskabel kommer
    in genom hålet. "
    lookInDesc = "En blå nätverkskabel är trädd genom hålet. "
;

+ PlugAttachable, PermanentAttachment, Immovable
    'ensam+ma blå+a nätverks|kabel+n' 'blå nätverkskabel'
    "Den blå kabeln är trädd genom ett litet hål i väggen,
    bredvid dörren. Den ansluter till en av de stora buntarna av
    kablar---men det är den enda blå kabeln, så det är lätt att följa den till
    routerlådan, där den avslutas i ett av routeruttagen.
    <.p>Det finns uppenbarligen inget sätt att spåra den blå kabelns fysiska
    anslutning längre; routern måste ansluta till huvudcampus
    nätverk, så kameran är effektivt ansluten till varje
    dator på campus. Det enda sättet att spåra den härifrån skulle vara
    att koppla in en nätverksanalysator och se vart datapaketen
    går.
    <.reveal need-net-analyzer> "

    attachedObjects = [nrRouter, nrRouterSockets]
    cannotDetachMsg(obj) { return 'Det är förmodligen bäst att lämna den som
        den är, så att ingen blir misstänksam av att du snokar omkring. '; }

    isNominallyIn(obj) { return obj == nrHole || inherited(obj); }
;

+ nrConduits: Fixture 'ledningar+na' 'ledningar'
    "Stora buntar av nätverkskabel matar genom ledningarna, som
    förmodligen leder ut till närliggande byggnader. "
    isPlural = true

    dobjFor(LookIn) asDobjFor(Examine)
;

+ PlugAttachable, PermanentAttachment, Immovable
    'stor+a jättelik+a vit+a gul+a orange nätverks|kabel+n*nätverks|kablar+na kabel|buntar+na'
    'kabelbuntar'
    "Hundratals vita, gula och orange kablar är anslutna till
    routern. Kablarna är samlade i jättelika buntar, som matar in i
    ledningar. "
    isPlural = true

    isNominallyIn(obj)
    {
        return obj == nrConduits || obj == nrRouterSockets || inherited(obj);
    }

    attachedObjects = [nrRouter, nrRouterSockets]
    cannotDetachMsg(obj) { return 'Du bör inte göra det; du vill inte
        avbryta någons nätverkstjänst. '; }
;

+ nrRouter: PlugAttachable, NearbyAttachable, Heavy
    'golvstående nätverk:et^s+router:n+låda+n' 'nätverksrouter'
    "Det är en stor utrustning, i storlek med en hög bokhylla.
    Hundratals nätverkstrådar är anslutna till uttag utspridda över
    framsidan av lådan. På ena sidan finns ett flerstifts diagnostikuttag. "

    cannotDetachMsg(obj) { return 'Du bör inte göra det; du vill inte
        avbryta någons nätverkstjänst. '; }

    iobjFor(PutIn) remapTo(PlugInto, DirectObject, self)
;

/* 
 *   An object representing all of the sockets, and any individual socket
 *   that we don't otherwise enumerate with its own object.
 */
++ nrRouterSockets: PermanentAttachment, Component
    'nätverks|uttag+et' 'nätverksuttag'
    "Routern har hundratals uttag; trådar är anslutna till de flesta
    av dem. "

    isPlural = true

    dobjFor(LookIn) asDobjFor(Examine)
    iobjFor(PutIn) { verify() { illogical('{Det dobj/han} där ser inte
        ut att passa i något av nätverksuttagen. '); } }
    iobjFor(PlugInto) asIobjFor(PutIn)
    iobjFor(AttachTo) asIobjFor(PutIn)
;

++ PluggableComponent
    'diagnostiskt diagnostisk+a flerstift:s+iga uttag+et/port+en/socket+en' 'diagnostikuttag'
    "Det är ett uttag för en speciell typ av kontakt, förmodligen för
    en nätverksanalysator.<.reveal need-net-analyzer> "

    iobjFor(PutIn) remapTo(AttachTo, DirectObject, self)
;

