#charset "utf-8"
/*
 *   Copyright 2003, 2013 Michael J. Roberts
 *   
 *   Return to Ditch Day - the stack.  This is part of Dabney, but it's big
 *   enough on its own that it's easier to handle as a separate module.  
 */

#include <adv3.h>
#include <sv_se.h>
#include "ditch3.h"


/* ------------------------------------------------------------------------ */
/*
 *   Alley One north 
 */
alley1N: AlleyRoom 'Gränd Ett Nord' 'norra änden av Gränd Ett'
    "Gränd Ett slutar här i en trappa som leder uppåt. Rum 3 ligger
    österut och rum 4 ligger västerut. Korridoren fortsätter söderut. "
    south = alley1S
    east = room3Door
    west = room4Door
    north asExit(up)
    up = alley1Stairs

    /* set up the crowd blocks */
    setCrowdBlocks()
    {
        south = crowdBlock;
        up = crowdBlock;
    }

    /*
     *   Fake connectors for after we solve the stack.  When we solve the
     *   stack, a crowd forms, blocking any way out except into room 4. 
     */
    crowdBlock: FakeConnector { "Det står för många människor 
        i hallen; Du kan inte komma igenom. "; }

    vocabWords = '1 gränd ett'

    roomParts = static (inherited + [alleyWestWall, alleyEastWall])

    /* 
     *   take our atmosphere list from Belker's current state; it's a good
     *   place to control it for this room, since Belker hangs out here
     *   for extended periods and the atmosphere all revolves around him 
     */
    atmosphereList = (frosst.curState.alley1Atmosphere)

    /* on the first arrival, award points for finding our way here */
    enteringRoom(traveler)
    {
        if (traveler == me)
            scoreMarker.awardPointsOnce();
    }
    scoreMarker: Achievement { +1 "hitta Stamers hög" }

    /* end the big blowout that happens around lunchtime */
    endBlowout()
    {
        /* get rid of the black smoke */
        bwSmoke.moveInto(nil);

        /* bring back frosst and xojo */
        frosst.moveIntoForTravel(self);
        xojo2.moveIntoForTravel(self);
        mitaTestOps.moveIntoForTravel(self);

        /* 
         *   Put xojo into the mitavac state, and cancel any pending
         *   introduction.  The introduction assumes that the megatester
         *   is present, so we don't want to do the intro now that it's
         *   gone.  In any normal game, we should have just naturally
         *   reached the intro by this point, but in any case it's not a
         *   big deal if we miss it.  
         */
        xojo2.setCurState(xojo2Mitavac);
        xojo2.removeFromAgenda(xojoIntroAgenda);
        xojo2.removeFromAgenda(xojoIntroRetryAgenda);

        /* set frosst to the 'computing' state */
        frosst.setCurState(frosstComputing);

        /* get rid of the MegaTester 3000 and associated items */
        PresentLater.makePresentByKeyIf('pro3000', nil);

        /* bring in the MitaVac 3000 and associated items */
        PresentLater.makePresentByKey('mitavac');

        /* mark that we're after lunch */
        gReveal('after-lunch');
    }
;

+ Graffiti
    'psykedelisk slumpmässig vibration
    konst/klotter/kladd/partikel/(låda)/stillbilder/film/kvadrater/prick/linjer'
    'graffiti'
    "Det är den typiska blandningen av psykedelisk konst och slumpmässigt klotter.
    En rolig bit här är märkt <q>Stillbilder från filmen <q>Partikel
    i en låda</q></q>: det är en serie kvadrater, var och en med en
    prick inuti, med små serietidningsliknande vibrationslinjer runt pricken.
    Det är ett kvantmekanikskämt. "
;

+ alley1Stairs: StairwayUp 'trappa/trappuppgång/trappor' 'trappuppgång'
    "Trapporna leder uppåt. "

    /* a traveler can only pass when the crowd blocks aren't in effect */
    canTravelerPass(trav) { return location.up == self; }
    explainTravelBarrier(trav) { "Du kan inte ta dig igenom folkmassan. "; }
;

+ room3Door: AlleyDoor '3 -' 'dörr till rum 3'
    "Det är en trädörr märkt <q>3.</q> "
;

+ room4Door: Door 'rum 4 rum/dörr*dörrar' 'dörr till rum 4'
    "Det är en trädörr märkt <q>4.</q> "

    dobjFor(LookUnder) { action() { "En bunt kablar som kommer från
        den svarta lådan löper under dörren, men förutom det finns det
        inget att se. "; } }

    dobjFor(Open)
    {
        check()
        {
            if (!isSolved)
            {
                "Du kan inte gå in förrän stacken är löst. ";
                exit;
            }
            else
                inherited();
        }
    }
    dobjFor(TravelVia)
    {
        check()
        {
            if (!isSolved)
            {
                "Du kan inte gå in förrän stacken är löst. ";
                exit;
            }
            else
                inherited();
        }
    }

    /* if the stack isn't solved, use no precondition, as we can't enter */
    getDoorOpenPreCond() { return isSolved ? inherited() : nil; }

    dobjFor(Knock)
    {
        action()
        {
            if (isSolved)
                "Inget behov av att knacka; som den rättmätiga lösaren av stacken
                kan du gå rakt in. ";
            else
                "Du knackar, men det kommer inget svar.
                Ägaren är förmodligen borta för Ditch Day. ";
        }
    }
;

class StackFixture: CustomFixture
    cannotTakeMsg = 'Det strider mot reglerna för stacken att flytta
        runt på de här sakerna. '
;

+ PermanentAttachment, StackFixture 'bunt/kabel/kablar' 'bunt med kablar'
    "Bunten med kablar är fäst vid baksidan av den svarta lådan och
    löper under dörren. "

    attachedObjects = [blackBox]
;

/* the stack as a generic object */
+ Decoration 'brian brians stamers ditch day stack'
    'Ditch Day-stack'
    "<<room4Sign.described
      ? "Brians stack består av den svarta lådan på bordet. Skylten
        på dörren har detaljer om reglerna för stacken."
      : "Du bör förmodligen läsa skylten på dörren för att få detaljer
        om stacken.">> "

    notImportantMsg = 'Stacken består av den svarta lådan, så allt
        du vill göra med stacken bör du göra med den svarta lådan. '
;
/* make the table a fixture, because it's obvious that we can't move it */
+ StackFixture, Surface 'gammalt gamla lilla litet trä+bord+et/kort+bord+et' 'litet bord'
    "Det är ett gammalt träkortbord. "

    dobjFor(LookUnder) { action() { "Allt du ser är bunten av
        kablar som löper under dörren. "; } }
;

++ blackBox: TestGearAttachable, CustomFixture
    'svart+a plåt+låda+n/låd-kontakt+en/låd+kontakt+en' 'svart låda'
    "Lådan ser lite improviserad ut; den kan ha varit en mikrovågsugn
    vid något tillfälle, men om det fanns en dörr har den ersatts av
    plåt, och hela saken har målats svart.
    <.p>Visuell inspektion ger inte mycket i form av ledtrådar.
    En bunt kablar löper ut från baksidan och under dörren. På
    framsidan finns en ovanlig elektrisk kontakt. I övrigt är
    det bara svart plåt.
    <<extraInfo>> "

    dobjFor(LookBehind) { action() { "Den svarta lådan är ganska nära
        dörren, så du kan inte se mycket av baksidan. Allt du kan se
        är bunten med kablar. "; } }

    dobjFor(LookUnder) { action() { "Det finns inget utrymme mellan lådan
        och bordet, och du ska inte flytta lådan, så
        det finns inget att se här. "; } }

    /*
     *   Provide some extra information as part of the description of the
     *   black box.  This helps explain what we need to do with the box
     *   next, so it varies according to where we are in the game.
     *   
     *   Early on, until we've gathered the necessary equipment from the
     *   Bridge lab, provide a hint about what equipment we'll need to
     *   solve the stack. 
     *   
     *   Later, once we have the Hovarth number, explain how to enter the
     *   number.  
     */
    extraInfo()
    {
        /* if we haven't gathered the equipment yet, explain what we need */
        if (equipHintNeeded)
            "<.p>Det verkar som om lådans mysterium är av elektronisk
            natur, så du kommer att behöva viss testutrustning för att analysera den.
            Det finns inte mycket att gå på just nu, så du ser
            inget annat val än att börja med grunderna---ett oscilloskop
            och en signalgenerator. Det har gått väldigt lång tid
            sedan du behövde felsöka kretsar på en så låg nivå;
            du är inte alls säker på att du kommer att kunna lista ut det här.
            <.reveal needed-equip-list> ";

        /* if we have the hovarth number, explain how to enter it */
        if (gRevealed('hovarth-solved') && !gRevealed('black-box-solved'))
            "<.p>När du undersökte lådan tidigare märkte du
            att den har en tio-nivåers spänningsdigitaliserare kopplad till en
            av kontaktstiften. Du skulle gissa att det är sättet du
            ska använda för att mata in Hovarth-numret. Signalgeneratorn
            borde fungera som spänningskälla. ";
    }

    /* 
     *   we need the equipment hint until we gather the equipment, but not
     *   until we know what the stack is about from reading the sign 
     */
    equipHintNeeded = (room4Sign.described && !equipGathered)
    equipGathered = (oscilloscope.moved && signalGen.moved)

    specialDesc = "Bredvid dörren till rum 4 finns ett litet bord, på
        vilket det står en svart metallåda som ser ut som om den en gång
        kan ha varit en mikrovågsugn. En skylt (egentligen bara ett pappersark)
        är fäst på dörren ovanför lådan. "

    /* put this early among the specialDesc's */
    specialDescOrder = 90

    showSpecialDescInContents(actor, cont)
        { "På bordet finns en svart metallåda som ser ut lite som
            en mikrovågsugn. "; }

    cannotTakeMsg = 'Det strider mot reglerna för stacken att flytta lådan. '
    cannotOpenMsg = 'Det strider mot reglerna för stacken. '

    /* handle connecting the test equipment */
    probeWithScope()
    {
        /* if we've solved the Hovarth puzzle, explain how to proceed */
        if (gRevealed('hovarth-solved') && !gRevealed('black-box-solved'))
        {
            "Du behöver inte oscilloskopet vid det här tillfället, eftersom din tidigare
            omvända ingenjörskonst redan berättade för dig vad du behöver veta:
            du behöver bara använda signalgeneratorn som spänningskälla
            för den svarta lådans digitaliseringskrets. ";
            return;
        }
        
        /* 
         *   nothing happens unless the signal generator is plugged in and
         *   turned on 
         */
        if (attachedObjects.indexOf(signalGen) != nil && signalGen.isOn)
        {
            /*
             *   Okay, as far as the circuitry is concerned, we have data
             *   to observe.  What we gather from the data, though,
             *   depends on the character's current experience level.
             *   
             *   If we've done all of our background research - we've read
             *   the Morgen textbook for a bit, and we've successfully
             *   repaired the Positron machine - we can actually make some
             *   sense of the data.  Otherwise, we're a bit lost.  
             */
            if (morgenBook.isRead && gRevealed('positron-repaired'))
            {
                /* 
                 *   The circuitry is all operating and we know how to
                 *   interpret the data.  If we're past lunch, we can just
                 *   read the message; otherwise, we kick off the
                 *   lunchtime blowout.
                 */
                if (gRevealed('after-lunch'))
                {
                    if (timesRead++ == 0)
                    {
                        "Du gör några justeringar på oscilloskopet och börjar
                        sonda kontakterna. Mönstren hoppar fram för dig
                        nu: detta är en enkel seriell data-
                        kommunikationskrets, men den är förklädd
                        tillräckligt väl med konstiga spänningar och vågmönster
                        att du inte kände igen den tidigare.
                        <.p>Idealt sett skulle du bygga ett kompatibelt gränssnitt,
                        sedan koppla in en terminal för att se vad meddelandet är.
                        Men det finns ingen tid för det; du måste bara
                        försöka läsa av datan direkt från oscilloskopet. Det är
                        tur att du memorerade ASCII i binär form för länge
                        sedan. Det tar dig ett par minuter att
                        komma in i det igen, men bitmönstren
                        börjar äntligen se ut som bokstäver och siffror:
                        <.p>\t3... 9... 2... )... H... O... V... A...
                        <.p>Så småningom börjar sekvensen upprepas; den 
                        repeterar bara ett kort meddelande i en loop. 
                        Du ser det gå förbi några gånger tills du är 
                        övertygad om att det verkligen upprepar samma 
                        meddelande varje gång:
                        <.p>\tHOVARTH(<<infoKeys.hovarthIn>>)
                        <.p>Detta är nästan trivialt! <q>Hovarth</q> är
                        en av de där obskyra matematiska funktionerna; lösningen
                        på stacken måste helt enkelt vara att beräkna
                        resultatet och mata in numret. Allt du behöver göra
                        är att hitta en kopia av DRD-mattabellerna och slå
                        upp detta Hovarth-nummer.
                        <.p>Du lägger ner oscilloskopproben och plötsligt
                        inser du att Belker svävar bakom dig.
                        <q>Jag antar att du har upptäckt ett dolt
                        meddelande,</q> säger han. <q>Kanske kommer du
                        att vara mer effektiv än mina underordnade när det gäller
                        att formulera ett svar.</q> Han skrockar och
                        går tillbaka för att övervaka teknikerna.
                        <.reveal hovarth> ";

                        /* this is worth some points */
                        hovarthScore.awardPointsOnce();
                    }
                    else
                    {                       
                        "Du hittar rätt uppsättning kontakter att röra vid
                        med oscilloskopproben och tittar på
                        meddelandets bitar på displayen.
                        Det ser ut som samma meddelande som tidigare:
                        <.p>
                        \tHOVARTH(<<infoKeys.hovarthIn>>)
                        <.p>
                        <<gRevealed('drd-hovarth')
                            ? "Nu behöver du bara lista ut hur du ska
                              beräkna det där Hovarth-numret."
                            : "Detta borde vara enkelt---du behöver bara
                              få tag på en kopia av DRD-mattabellerna och slå
                              upp Hovarth-funktioner. Biblioteket har förmodligen
                              en kopia.">> ";
                    }
                }
                else
                {
                    /* trigger the lunchtime blowout */
                    "Du är ivrig att ta en ny titt på den svarta lådan nu
                    när du har haft en chans att bekanta dig med
                    det här materialet igen. Du gör några justeringar på oscilloskopet och
                    plockar upp proben.
                    <.p>Precis när du ska ansluta proben fylls hela
                    gränden med ett bländande blåvitt ljus
                    och en öronbedövande krasch. En tryckvåg träffar dig
                    och slår dig mot väggen. Du sträcker ut handen efter
                    något att hålla dig i för balansen, men hittar inget;
                    du känner hur du snubblar sidledes, öronen ringer,
                    ögonen fyllda med mörkgröna fläckar, och du har
                    känslan av att vara fångad i ett tumult, av att försöka
                    tränga dig genom en folkmassa som rusar i motsatt
                    riktning.
                    <.p>När efterbilderna börjar blekna från dina ögon
                    ser du att du på något sätt har tagit dig ut till
                    arkadgången utanför Gränd Ett, tillsammans med Mitachron-
                    teknikerna. Tjock svart rök väller ut från
                    grändingången.
                    <.p>Frosst Belker kommer nonchalant fram ur
                    rökmoln, och borstar bort askbitar från sina vita kläder.
                    Samtidigt rusar en grupp brandmän in från
                    Orange Walk. De ser Belker, pratar kort med honom,
                    och rusar sedan in i gränden. När de lämnar märker du
                    Mitachron-logotyperna på deras uniformer.
                    <.p>Belker vänder sig mot dig. <q>Den här byggnaden,</q> säger han,
                    och flinar bort lite aska från sin kavajslagskant, <q>den är inte, öh,
                    <q>enligt föreskrifterna,</q> kan man säga. Men oroa dig inte.
                    Jag är försäkrad om att reparationerna kommer att vara klara inom
                    en timme.</q> Han tittar på sin klocka. <q>Ah, precis tillräckligt med
                    tid för lunch.</q> Han pekar med fingret runt folkmassan
                    av tekniker, knäpper med fingrarna och pekar utåt.
                    Alla tekniker går ut på led, och Belker följer efter. ";

                    /* move me outside */
                    me.moveIntoForTravel(dabneyBreezeway);
                    
                    /* set up the smoke */
                    bwSmoke.makePresent();
                    
                    /* 
                     *   set up follow departure data for belker, xojo,
                     *   and the other technicians 
                     */
                    trackAndDisappear(frosst, dabneyBreezeway.west);
                    trackAndDisappear(mitaTestOps, dabneyBreezeway.west);
                    trackAndDisappear(xojo2, dabneyBreezeway.west);

                    /* set a fuse for aaron and erin to arrive shortly */
                    erin.startLunchFuse();

                    /* fire the plot clock event for the blowout */
                    blowoutPlotEvent.eventReached();
                }
            }
            else
            {
                /* 
                 *   we haven't done all of our research, so we can't make
                 *   sense of the data 
                 */
                "Du fumlar runt med signalgeneratorn och
                oscilloskopet en stund, provar olika frekvenser och
                vågformer, och rör oscilloskopets prob mot de
                olika kontakterna i tur och ordning. Oscilloskopet visar tydliga
                svar; det finns utan tvekan mönster här,
                men du ser dem inte. ";

                /* 
                 *   If we've done part of our research, provide some
                 *   encouragement need to do the rest.  If we haven't
                 *   done any research yet, suggest what research would be
                 *   helpful. 
                 */
                if (morgenBook.isRead)
                {
                    "Du känner att du borde kunna lista ut det här;
                    du vet att du förstår principerna. Vad du behöver,
                    tänker du, är lite övning med något enklare och
                    bättre definierat.<.reveal need-ee-practice>
                    Att reparera en trasig TV, ";

                    /* if we've described Positron, recommend it */
                    if (posGame.described)
                        "kanske. Faktiskt, det där Positron-spelet i
                        flipperspelsrummet skulle kunna vara precis rätt sak. ";
                    else
                        "något sådant. ";
                }
                else if (gRevealed('positron-repaired'))
                    "Du känner att du borde kunna lista ut det här;
                    du lyckades ju reparera det där videospelet, trots allt.
                    Vad du behöver, tänker du, är att spendera lite tid med
                    en bra lärobok, för att fräscha upp teorin
                    lite.<.reveal need-ee-text> ";
                else
                    "<.p>Du får en sjunkande känsla av att du inte klarar
                    det här. Du hade hoppats att lådan skulle visa sig
                    vara något bedrägligt enkelt, men nu är du ganska
                    säker på att den inte är det; det ser ut som ett seriöst elektriskt
                    ingenjörspussel, och du är helt enkelt inte mycket till
                    elektroingenjör nuförtiden. Om du kunde knäppa med fingrarna
                    som Belker och få en skara ingenjörer hit för att
                    göra jobbet åt dig, inga problem, men det är inte så
                    Omegatron fungerar.
                    <.p>Om du spenderade lite tid med en bra elektroteknikbok skulle du kanske ha en chans, även om du just nu
                    inte ens kan komma på vilken bok du skulle behöva läsa; 
                    du kanske kan fråga en av studenterna här om en rekommendation.
                    Du skulle också verkligen behöva öva på att felsöka en
                    enklare krets. Det verkar som en ganska liten chans,
                    med tanke på att det är du mot hela det här Mitachron-
                    gänget, men du har ju trots allt ingenstans annat du måste
                    vara idag.
                    <.reveal need-ee-text><.reveal need-ee-practice> ";

                /* on the first time through, Belker notices */
                if (timesProbed++ == 0)
                    "<.p><q>Jag ser att du äntligen gör några framsteg.</q>
                    Du tittar upp och ser Belker titta på, med ett svagt
                    roat uttryck. <q>Din samling av testutrustning ser
                    ganska imponerande ut,</q> säger han och granskar din utrustning.
                    <q>Jag måste instruera mina tekniker att fördubbla
                    sina ansträngningar, så att vi inte hamnar efter.</q>
                    <.p>Något distraherar honom, och han vänder sig tillbaka till
                    teknikerna. <q>Nej, nej, nej,</q> säger han till en av dem,
                    medan han banar sig väg genom det trånga utrymmet. ";
            }
        }
        else
        {
            /* the signal generator isn't in use, so we don't get any data */
            "Du rör oscilloskopets prob mot de olika kontakterna
            en i taget. Några svaga, oregelbundna mönster dyker upp; de
            kan bara vara elektriskt brus. Det kan vara användbart att prova
            en signalgenerator för att se om det finns någon respons på olika
            vågformer. ";
        }
    }

    probeWithSignalGen()
    {
        /* 
         *   If we have the solution to the Hovarth puzzle in hand,
         *   explain how to enter digits.
         */
        if (gRevealed('hovarth-solved') && !gRevealed('black-box-solved'))
        {
            /* if the signal generator's not already on, turn it on now */
            if (!signalGen.isOn)
            {
                "<.p>Du slår på generatorn och ansluter den sedan ";
                signalGen.makeOn(true);
            }
            else
                "<.p>Du ansluter generatorn ";
            
            /* explain the procedure */
            "till den kontaktstift som du tror är <q>nollställnings</q>-brytaren,
            för att säkerställa att lådans interna nummerminne är nollställt.
            Du väntar några ögonblick, sedan ansluter du kontakten
            till stiften som går till spänningsdigitaliseraren, och du justerar
            generatorinställningarna till rätt spänningsområde. Den borde
            nu vara inställd för att mata in siffror, en i taget, med hjälp av
            amplitudratten. ";

            /* start the knob on zero */
            signalGenKnob.curSetting = '0';

            /* start the data entry daemon */
            clearDigits();
            new Daemon(self, &digitEntryDaemon, 1);
        }
    }

    /* score marker for getting Hovarth code */
    hovarthScore: Achievement { +10 "avkoda den svarta lådans meddelande" }

    /* a game-clock event for the explosion */
    blowoutPlotEvent: ClockEvent { eventTime = [2, 12, 07] }

    /* number of times we've attempted probing with the scope */
    timesProbed = 0

    /* number of times we've read the message */
    timesRead = 0

    turnOnSignalGen()
    {
        /* 
         *   if we don't know the Hovarth story yet, mention the scope; if
         *   we do, and we haven't solved the stack yet, reset the digit
         *   accumulator so that we can have a fresh start at entering the
         *   number 
         */
        if (!gRevealed('hovarth-solved'))
        {
            "Du provar några inställningar, men det finns inget uppenbart 
            svar från den svarta lådan. Ett oscilloskop skulle förmodligen 
            hjälpa för att se om något är på gång.";
        }
        else if (!gRevealed('black-box-solved'))
        {
            /* reset the knob to zero, and clear our accumulator */
            signalGenKnob.curSetting = '0';
            clearDigits();

            /* mention what we did */
            "För att vara säker på att du får en ren start när du matar in
            siffror, vrider du amplitudratten till noll och rör kort vid
            det kontaktstift som du tror återställer den svarta lådan. Du
            borde nu vara redo att mata in ett nummer. ";
        }
    }

    /*
     *   The digit entry daemon.  The signal generator starts this
     *   running, once per turn, whenever the signal generator is attached
     *   and we've solved the Hovarth number puzzle.  We accept one digit
     *   per turn, issuing auditory feedback each time we accept a digit.  
     */
    digitEntryDaemon()
    {
        /* 
         *   if the generator is still attached and turned on, accept the
         *   current digit 
         */
        if (signalGen.isOn && signalGen.isAttachedTo(self))
        {
            /* ignore it if we're paused */
            if (pauseDigits)
            {
                /* end the pause */
                pauseDigits = nil;

                /* do no more this turn */
                return;
            }
            
            /* accept the current dial position as the next digit */
            enterDigit(toInteger(signalGenKnob.curSetting));

            /* 
             *   If we're here, mention the beep.  (Note that we could
             *   instead have made this a SenseDaemon with the 'sound'
             *   sense; but in this case, the only way we can hear the
             *   beep is to be present, so we save the sense system a
             *   little extra calculation on each turn by using the
             *   simpler means of figuring out whether or not we're within
             *   hearing range.) 
             */
            if (me.isIn(alley1N))
            {
                /* mention the beep */
                "<.p>Den svarta lådan avger ett mjukt pip. ";

                /* if this is the first mention, explain what it means */
                if (beepHeardCount++ == 0)
                    "Du antar att detta betyder att lådan accepterade
                    den aktuella siffran. ";
                    
                /* 
                 *   notify frosst if we've turned the knob to a non-zero
                 *   value (if we're entering 0s, don't bother, as we're
                 *   probably just doing something else before we get to
                 *   entering digits) 
                 */
                if (signalGenKnob.curSetting != '0')
                    frosstWatchingDigits.noteDigitEntry();
            }

            /* check for a winning combination */
            checkDigits();
        }
    }

    /* pause reading input for a turn */
    pauseDigits = nil

    /* number of times we've heard the beep */
    beepHeardCount = 0

    /* clear the digit memory */
    clearDigits()
    {
        /* zero the accumulator */
        curAcc = 0;

        /* pause reading digits for a turn */
        pauseDigits = true;
    }

    /* enter one digit */
    enterDigit(n)
    {
        /* multiply the accumulator by ten and add the new one */
        curAcc *= 10;
        curAcc += n;
    }

    /* check for a winning combination */
    checkDigits()
    {
        if (curAcc == toInteger(infoKeys.hovarthOut))
        {
            "Sedan, efter några ögonblick, ger den ifrån sig ett högt <q>Ding.</q>
            <.p>Du inser att en folkmassa har samlats i korridoren.
            Teknikerna har alla övergivit Mitavac och står
            och tittar på dig, och ett par dussin studenter har
            också anlänt. Alla tittar tyst på dig.
            <.p>Belker ser förvirrad ut. <q>Vad betyder detta dingande
            ljud?</q> frågar han skarpt. Som för att svara
            klickar den svarta lådan, och dörren till rum 4 svänger upp.
            Folkmassan hurrar och applåderar---till och med Mitachron-
            teknikerna ler. Belker står bara där med
            hakan hängande.
            <.p>Några av studenterna börjar gå in i rum 4 för att
            göra anspråk på sin del av mutan. Belker banar sig väg
            fram till dig genom folkmassan. Han har återfått fattningen
            nu; han ler svagt. <q>Grattis,</q> säger han.
            <q>Jag är vederbörligen imponerad av din uppfinningsrikedom.
            Jag skulle vilja att mina tekniker studerar dina metoder
            någon dag.</q> Han verkar vara på väg att säga något annat, men
            hans mobiltelefon ringer; han tar fram den ur fickan och
            svarar. Han rör sig bort genom folkmassan.
            <.reveal black-box-solved> ";

            /* make frosst disappear for now */
            frosst.moveInto(nil);

            /* set the mitachron technicians into crowd mode */
            mitavacTechs.setCurState(mitaTechCrowd);
            xojo2.setCurState(xojo2Crowd);

            /* open the door to room 4 and mark it as "solved" */
            room4Door.makeOpen(true);
            room4Door.isSolved = true;

            /* set up the crowd blocks so we can't leave the alley */
            alley1N.setCrowdBlocks();

            /* move the crowd here */
            alley1Crowd.makePresent();

            /* kill the black box daemon */
            signalGen.killDaemon();

            /* this is definitely worth some points, and a plot event */
            solveScoreMarker.awardPointsOnce();
            solvePlotEvent.eventReached();
        }
    }

    /* points for solving the stack */
    solveScoreMarker: Achievement { +10 "lösa Brian Stamers hög" }

    /* solving the stack is a clock-significant plot event */
    solvePlotEvent: ClockEvent { eventTime = [2, 16, 53] }

    /* our accumulator - this is the number we've entered so far */
    curAcc = 0
;

+++ PluggableComponent
    '(svart) (låda) ovanlig liten t-formad elektrisk anslutning
    stift/kontakt/stift/stift/hål/hål'
    'elektrisk anslutning'
    "Anslutningen är inte av standardtyp, eller åtminstone inte en du är
    bekant med. Den har en kombination av stift och hål, ungefär ett
    dussin av varje, och ett litet T-format stift. "

    disambigName = 'svart lådanslutning'
;

++ Unthing 'tidigare mikrovågsugn' 'tidigare mikrovågsugn'
    notHereMsg = 'Det finns ingen mikrovågsugn här&mdash;bara den där svarta
        lådan som kanske var en mikrovågsugn i ett tidigare liv. '
;

++ room4Sign: CustomImmovable, Readable 'ark/papper/skylt' 'skylt'
    "Det är en lasertryckt uppsättning instruktioner för stacken:
    <.p><.blockquote>
    <font face=tads-sans><b>Brians Svarta Låda av Mysterium</b>
    <.p>Min stack är den svarta låda du ser framför dig. Den kontrollerar
    dörren till mitt rum. Allt du behöver göra är att lista ut hur du får
    lådan att öppna dörren.
    <.p>Detta är en <q>finess</q>-stack, vilket betyder att du inte får
    använda fysisk kraft för att bryta stacken---så inget nedbrytande av min
    dörr. Du får inte heller tvinga upp den svarta lådan, eller flytta
    den, eller störa dess externa ledningar. Bortsett från allt detta kan du
    använda i princip vilka medel som helst för att lista ut hur lådan fungerar.
    <.p>Jag ger dig en ledtråd: elektronisk testutrustning kan vara
    till hjälp. För din bekvämlighet har jag lämnat en massa utrustning
    i mitt labb (022 Bridge). Du kan hjälpa dig själv till vad som helst på
    hyllorna på bakre väggen. Nyckeln till labbet ligger ovanpå lådan.
    <.p>P.S.\ Om det finns ett par icke-Techers som arbetar på stacken,
    så är det okej. De är rekryterare som kom hit för att intervjua mig,
    och jag bjöd in dem att delta i Ditch Day-kul. En särskild regel
    för dem: ni får ha så många hjälpare ni vill och vilken
    utrustning ni vill, men allt ni använder måste vara på campus.
    Det skulle inte vara rättvist att bara ringa in det från huvudkontoret.
    <.reveal stamer-lab>
    </font><./blockquote>"

    dobjFor(Examine)
    {
        action()
        {
            /* inherit the default handling first */
            inherited();

            /* always set back the 'bribe' timer when we read the sign */
            bribeStudents.setDelay(2);
            
            /* this makes aaron and erin introduce themselves if necessary */
            aaron.noteMeReadingSign();
        }
    }

    cannotTakeMsg = 'Du bör lämna den där den är så att andra
        personer kan läsa den. '
;

/* ------------------------------------------------------------------------ */
/*
 *   A class for Aaron-and-Erin conversation lists.  This is a script that
 *   can be combined with an actor state.  What's special about this type
 *   of script is that we perform a scripted conversational action only if
 *   there was no other conversation from either Aaron or Erin this turn.  
 */
class AaronErinConvList: object
    doScript()
    {
        /* 
         *   if neither Erin nor Aaron has conversed this turn, proceed
         *   with the script; otherwise do nothing 
         */
        if (!erin.conversedThisTurn() && !aaron.conversedThisTurn())
            inherited();
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   Aaron 
 */
+ aaron: IntroPerson
    'lång tunn ung mager krulligt rött hår rödhårig
    kille/pojke/man/student/aaron*studenter män'
    'lång, tunn student'
    "Han är lång och så tunn att han ser nästan undernärd ut. Hans hår är
    rött och krulligt, som om han just fått en stor statisk elektrisk stöt. "
    properName = 'Aaron'
    isHim = true

    noteMeReadingSign()
    {
        /* if we haven't been introduced yet, introduce ourselves */
        if (!introduced)
        {
            "<.p>Den unga kvinnan närmar sig dig. <q>Hej,</q>
            säger hon. <q>Jag är nyfiken&mdash;är ni rekryterarna?</q>";
            commonIntro(true, true);
        }

        /* if erin hasn't mentioned the key yet, do so now */
        erin.mentionKey(true);
    }

    commonIntro(enterConv, fromSign)
    {
        /* show the common introduction */
        "<.p><q>Ja,</q> svarar du. <q>Han är från Mitachron. Jag är Doug,
        från Omegatron.</q>
        <.p><q>Hälsningar, Doug från Omegatron,</q> säger killen med det
        krulliga håret. <q>Jag är Aaron.</q>
        <.p><q>Jag också,</q> säger den unga kvinnan, <q>fast jag stavar det
        E-R-I-N.</q> ";

        /* if we got here by reading the sign, mention the key */
        if (fromSign)
            erin.mentionKey(nil);

        /* aaron and erin are now introduced */
        aaron.setIntroduced();
        erin.setIntroduced();

        /* set up frosst's "bribe" agenda item */
        frosst.addToAgenda(bribeStudents.setDelay(2));

        /* if necessary, put both of them in conversation mode */
        if (enterConv)
        {
            /* 
             *   note that we can just make the state changes explicitly,
             *   since we've already run through the intro on our own 
             */
            erin.setCurState(erin.curState.inConvState);
            aaron.setCurState(aaron.curState.inConvState);

            /* set 'me' to be talking to erin */
            me.noteConversation(erin);
        }
    }

    /* erin's also in any conversation we're in */
    noteConversationFrom(other)
    {
        inherited(other);
        erin.noteConvAction(other);
    }
;
++ InConversationState
    specialDescListWith = [aaronAndErinAlley1]
;

/* 
 *   since we're not going to be around for long, just use one topic to
 *   talk about most anything related to the stack 
 */
+++ AskTellShowTopic, SuggestedAskTopic, ShuffledEventList
    [blackBox, ddTopic, stackTopic, stamerStackTopic]
    ['<q>Har ni kommit på något om stacken än?</q> frågar du.
    <.p>Aaron skakar på huvudet. <q>Inte riktigt.</q> ',
     '<q>Är det stacken ni ska arbeta med idag?</q>
     <.p><q>Kanske,</q> säger Aaron. <q>Den ser tillräckligt dunkel ut.</q> ',
     '<q>Några idéer om hur man ska närma sig detta?</q> frågar du.
     <.p>Aaron bedömer den svarta lådan en stund. <q>Jag vet inte.
     Visuell inspektion ger inte mycket att arbeta med.</q> ']

    name = 'stacken'
;

+++ AskTellShowTopic [aaron, erin]
    "<q>Vad är er huvudinriktning?</q> frågar du.
    <.p><q>Vi är båda double-E's,</q> säger han, och tillägger sedan, <q>Det är
    elektroteknik.</q><.reveal aaron-erin-major> "
;
++++ AltTopic
    "<q>Den här stacken verkar perfekt för en double-E.</q>
    <.p><q>Kanske,</q> säger Aaron. <q>Det kan dock vara för likt
    riktigt arbete.</q> "
    isActive = (gRevealed('aaron-erin-major') && room4Sign.described)
;

+++ AskTellAboutForTopic @labKey
    "<q>Vet ni var nyckeln är?</q> frågar du.
    <.p><q>Jag tror Erin har den, eller hur?</q>
    <.p><q>Jag har den,</q> säger hon.<.reveal erin-has-key> "
;

+++ DefaultAnyTopic
    "Han verkar ganska fokuserad på stacken just nu. Du tvivlar på att han skulle
    vara särskilt intresserad av att prata om mycket annat. "
    isConversational = nil
;

+++ ConversationReadyState
    isInitState = true
    stateDesc = "Han studerar den svarta lådan. "
    specialDescListWith = [aaronAndErinAlley1]
    showGreetingMsg(actor, explicit)
    {
        if (!aaron.introduced)
        {
            "<q>Hej,</q> säger du till de två studenterna.
            <.p>De två tittar upp från sina funderingar över den svarta
            lådan. <q>Hej,</q> säger de nästan i kör. <q>Är ni
            rekryterarna?</q> frågar den unga kvinnan och kastar en blick
            mot Frosst.";
            aaron.commonIntro(nil, nil);
        }

        /* 
         *   Enter conversation for erin as well.  We can just make the
         *   state change in Erin explicitly, since we're handling the
         *   rest of the transition for both Aaron and Erin.  
         */
        erin.setCurState(erin.curState.inConvState);
    }
;


/* a separate set of states for when we're working on the Upper 7 stack */
++ InConversationState
    specialDescListWith = [aaronAndErinUpper7]
;
+++ AskTellTopic @posGame
    "<q>Vet du något om Positron-maskinen på nedervåningen?</q>
    frågar du.
    <.p><q>Den är ganska rolig, när den fungerar,</q> säger han.
    <q>Vilket inte är ofta.</q> "
;
+++ AskTellTopic @scottTopic
    "<q>Jag letar efter Scott,</q> säger du. <q>Ägaren till Positron-
    maskinen på nedervåningen. Har du sett honom i närheten?</q>
    <.p><q>Jag tror han arbetar med den gigantiska kycklingsstacken
    i gränd 3,</q> säger han. "
;
+++ AskForTopic @scottTopic
    topicResponse() { replaceAction(AskAbout, gDobj, scottTopic); }
;
+++ AskTellGiveShowTopic
    [efficiencyStudy37Topic, efficiencyStudy37, galvaniTopic]
    "Hur mycket du än vill avslöja Mitachrons onda planer för 
    världen, har du en känsla av att det finns bättre ställen att 
    börja på."
    isConversational = nil
;
+++ AskTellTopic @jayTopic
    "<q>Vet du var Jay Santoshnimoorthy är?</q> frågar du.
    <p>Han sätter armarna i kors och tänker en minut. <q>Ja,</q>
    säger han till slut. <q>Mer exakt, jag vet var han var
    tidigare idag: han funderade stacken i Gränd Fyra,</q> 
    säger han."
;

+++ GiveShowTopic @calculator
    "Han tittar på miniräknaren och lämnar tillbaka den. <q>Det här är
    den typ av miniräknare som Jay Santoshnimoorthy gillar att leka med,</q>
    säger han. "
;
    
+++ AskTellShowTopic, StopEventList [ddTopic, paulStackTopic, commandant64]
    ['<q>Det ser ut som om ni har hittat en annan stack,</q> säger du.
    <.p>Aaron nickar. <q>Den här är bättre ändå.</q> ',
     '<q>Hur går det med stacken?</q> frågar du.
     <.p>Aaron rycker på axlarna. <q>Framsteg görs, tror jag.</q> ',
     '<q>Några idéer om hur den här stacken fungerar?</q> frågar du.
     <.p><q>Några,</q> säger Aaron och nickar. <q>Vi tror att det är någon
     form av kod.</q> ']
;
+++ AskTellAboutForTopic [physicsTextTopic, bloemnerBook, drdTopic]
    "<q>Var är bästa stället här för att hitta läroböcker?</q> frågar du.
    <.p><q>Campusbokhandeln eller Millikan,</q> säger Aaron. "
;
+++ AskTellAboutForTopic +90
    [eeTextbookRecTopic, eeTextTopic, morgenBook,
     eeLabRecTopic, labManualTopic, townsendBook]

    topicResponse()
    {
        "<q>Ni är elektroingenjörer, va?</q> frågar du. De två nickar. <q>Jag
        undrade om ni hade några rekommendationer för en bra Elektro-text.
        Något jag kunde använda för att fräscha upp mina kunskaper.</q>
        <.p>Aaron nickar. <q>Yves Morgen, Electronics Lectures. Namnet
        stavas M-O-R-G-E-N. Mycket lättläst.</q><.reveal morgen-book> ";

        /* award some points for this */
        morgenBook.recMarker.awardPointsOnce();
    }
;
++++ AltTopic
    "<q>Några andra rekommendationer för elektro-texter?</q> frågar du.
    <.p>Aaron skakar på huvudet. <q>Morgen är den bästa jag känner till.</q> "

    isActive = (gRevealed('morgen-book'))
;
+++ AskTellTopic @qubitsTopic
    "<q>Vet du vad <q>QUBITS</q> syftar på?</q> frågar du.
    <.p>Han nickar. <q>Ja. En qubit är namnet på en kvantbit,
    kvantdatorns motsvarighet till en konventionell binär databit.</q> "
;
+++ AskTellTopic @quantumComputingTopic
    "<q>Vad vet du om kvantdatorer?</q> frågar du.
    <.p><q>Väldigt lite,</q> säger han. <q>De gör mycket arbete med det
    här omkring, men jag har inte följt det särskilt mycket.</q> "
;
    
+++ DefaultAnyTopic
    "Han verkar mest intresserad av stacken just nu. "
    isConversational = nil
;

+++ aaronUpper7: ConversationReadyState
    stateDesc = "Han studerar datorskärmen. "
    specialDescListWith = [aaronAndErinUpper7]
    showGreetingMsg(actor, explicit)
    {
        /* show the greeting */
        "<q>Hej,</q> säger du. De två tittar upp från datorn och
        säger hej.<.p>";
        
        /* erin is automatically part of the conversation as well */
        erin.setCurState(erin.curState.inConvState);
    }
;

/* a separate set of states for the breezeway around lunchtime */
++ aaronBreezeway: ActorState
    stateDesc = "Han försöker se genom rökmoln
        in i gränden. "
    specialDescListWith = [aaronAndErinBreezeway]
;

+++ DefaultAnyTopic
    "Aaron verkar upptagen med att försöka se vad som pågår i
    gränden. "
    isConversational = nil
;

/* a separate set of states for lunchtime */
++ aaronLunch: ActorState
    stateDesc = "Han sitter vid bordet och äter lunch. "
    specialDescListWith = [aaronAndErinLunch]
;

+++ HelloTopic
    "Du småpratar lite med Aaron, men han är inte särskilt
    mottaglig; han verkar försjunken i tankar. "
;

+++ DefaultAnyTopic, ShuffledEventList
    ['Aaron verkar för fokuserad på sin mat för att svara. ',
     'Det ser ut som om han är för upptagen med att försöka identifiera något
     på sin tallrik för att uppmärksamma dig. ',
     'Han är upptagen med sin mat; han verkar ignorera dig. ',
     'Aaron verkar försjunken i tankar. ']
    isConversational = nil
;


/* a separate set of conversation states for the endgame */
++ aaronRoom4: ActorState
    stateDesc = "Han arbetar med snacksen. "
    specialDescListWith = [aaronAndErinRoom4]
;

+++ AskTopic [ddTopic, stackTopic, paulStackTopic, commandant64]
    "<q>Hur gick det med er stack?</q> frågar du.
    <.p><q>Vi lyckades,</q> säger han. <q>Det är ett roligt
    pussel.</q> "
;
+++ TellTopic [ddTopic, stackTopic, blackBox, stamerStackTopic]
    "Aaron och Erin lyssnar uppmärksamt när du förklarar dina
    äventyr med att lösa Stamers stack. "
;

+++ DefaultAnyTopic
    "Aaron verkar inte kunna höra dig över ljudet från folkmassan. "
    isConversational = nil
;

/* ------------------------------------------------------------------------ */
/*
 *   Erin
 */
+ erin: IntroPerson
    'kort ung ungdomlig blond blondin student/kvinna/erin*studenter kvinnor'
    'kort blond kvinna'
    "Hon är kort och ser väldigt ung ut, även för en högskolestudent. "
    properName = 'Erin'
    isHer = true

    mentionKey(newPara)
    {
        /* 
         *   if erin can talk to the PC, and she hasn't already mentioned
         *   the key, do so now 
         */
        if (canTalkTo(me) && !gRevealed('erin-has-key'))
        {
            "<<newPara ? '<.p>Erin' : 'Hon'>> tar fram något ur sin
            ficka och visar det för dig: en nyckel. <q>Jag har förresten nyckeln till
            labbet,</q> säger hon och stoppar tillbaka den. <q>Ni
            killar är välkomna att följa med oss när vi går till labbet, om
            ni vill.</q> ";

            /* 
             *   Note that we reveal 'erin-has-key' through gReveal rather
             *   than through the <.reveal> tag because we might want to
             *   check the revelation again on this very same turn, due to
             *   the way we generate the sign message.  <.reveal> sometimes
             *   won't take effect until after the turn is finished,
             *   because the command transcript usually captures the output
             *   while the turn is ongoing.  
             */
            gReveal('erin-has-key');
        }
    }

    /* aarin's also in any conversation we're in */
    noteConversationFrom(other)
    {
        inherited(other);
        aaron.noteConvAction(other);
    }

    /* start the lunch fuse */
    startLunchFuse()
    {
        /* create and remember the event */
        lunchFuseEvt = new Fuse(self, &lunchFuse, 2);
    }

    /* the lunch fuse */
    lunchFuseEvt = nil

    /* 
     *   A fuse handler for lunch time.  This gets set up when we trigger
     *   the explosion in alley 1; aaron and erin go to the breezeway to
     *   see what's going on, and invite the PC to lunch.  
     */
    lunchFuse()
    {
        /* bring aaron and erin to the breezeway */
        aaron.moveIntoForTravel(dabneyBreezeway);
        moveIntoForTravel(dabneyBreezeway);

        /* set aaron to just peering into the cloud */
        aaron.setCurState(aaronBreezeway);

        /* erin says hello */
        initiateConversation(erinBreezeway, 'erin-smoke');

        /* forget our fuse */
        lunchFuseEvt = nil;
    }

    /* head to lunch */
    goToLunch()
    {
        /* mention where we're going */
        "De två går över gården mot matsalen. ";
        
        /* depart via courtyard */
        trackAndDisappear(aaron, dabneyBreezeway.east);
        trackAndDisappear(erin, dabneyBreezeway.east);

        /* we know where they're going */
        knownFollowDest = dabneyDining;
        aaron.knownFollowDest = dabneyDining;

        /* begin lunch */
        dabneyDining.startLunch();
    }

    /* 
     *   interrupt the lunch fuse - this gets invoked if the PC leaves the
     *   breezeway before we show up 
     */
    interruptLunchFuse()
    {
        if (lunchFuseEvt != nil)
        {
            "När du är på väg att lämna, kommer Aaron och Erin in från gården.
            Aaron går för att kolla på röken, och Erin stoppar dig för
            ett ögonblick. <q>Vi är på väg att äta lunch,</q> säger hon.
            <q>Du borde följa med oss, om du känner för det.</q> ";

            /* send them on their way */
            goToLunch();

            /* cancel the fuse; we don't need it any more */
            eventManager.removeEvent(lunchFuseEvt);
            lunchFuseEvt = nil;
        }
    }
;

++ Fixture, Container 'ficka' 'ficka'
    contentsListed = nil
    dobjFor(Examine)
    {
        check()
        {
            "Du har inte för vana att gå igenom andra människors
            fickor. ";
            exit;
        }
    }
    dobjFor(LookIn) asDobjFor(Examine)
;

+++ labKey: DitchKey 'metall "lab" laboratorium nyckel*nycklar' 'labb-nyckel'
    "<q>Lab</q> är handskrivet på den. "

    /* make this pre-known so we can ask about it */
    isKnown = true
;
    
++ InConversationState
    specialDescListWith = [aaronAndErinAlley1]
;

+++ AskTellShowTopic [erin, aaron]
    "<q>Vad studerar ni?</q> frågar du.
    <.p><q>Elektroteknik,</q> säger hon. <q>Vi är faktiskt
    båda double-E's.</q><.reveal aaron-erin-major> "
;
++++ AltTopic
    "<q>Den här stacken verkar perfekt för en double-E,</q> säger du.
    <.p><q>Kanske, men Brian är fysiker. De tänker inte som
    ingenjörer. Det är förmodligen något elaborerat skämt där det ser
    elektroniskt ut men det egentligen är en Maxwell-snurra inuti eller något.</q> "
    isActive = (gRevealed('aaron-erin-major') && room4Sign.described)
;

/* a master stack-related topic for Erin */
+++ AskTellShowTopic, SuggestedAskTopic
    [blackBox, ddTopic, stackTopic, stamerStackTopic]
    "<q>Några idéer om hur man löser stacken än?</q> frågar du.
    <.p><q>Inte än,</q> säger Erin. "

    name = 'stacken'
;

+++ AskTellAboutForTopic @labKey
    "<q>Vet du vad som hände med nyckeln?</q>
    <.p><q>Ja, jag har den,</q> säger hon. <q>Vi kommer förmodligen
    gå till labbet ganska snart. Vi kan alla gå tillsammans, om
    ni vill.</q><.reveal erin-has-key> "
;

++++ AltTopic
    "<q>Kan jag få nyckeln?</q> frågar du.
    <.p><q>Jag behåller den, om du inte har något emot det,</q> säger hon.
    <q>Ni killar kan följa med oss till labbet dock.</q> "
    isActive = (gRevealed('erin-has-key'))
;

+++ AskTellTopic @stamerLabTopic
    "<q>När ska ni gå till labbet?</q> frågar du.
    <.p>Erin och Aaron tittar på varandra och rycker båda på axlarna.
    <q>Senare, antar jag,</q> säger hon. "
    isActive = (gRevealed('erin-has-key'))
;

+++ DefaultAnyTopic
    "Du tvivlar på att hon skulle vara särskilt intresserad av att prata om något
    annat än stacken just nu. "
    isConversational = nil
;

+++ ConversationReadyState
    isInitState = true
    specialDescListWith = [aaronAndErinAlley1]
    stateDesc = "Hon undersöker den svarta lådan. "

    /* 
     *   Erin and Aaron are always paired for conversation state.  We let
     *   Aaron drive the whole thing, so the only thing we need to do is
     *   call the enter-converation routine in Aaron's state object.  
     */
    enterConversation(actor, entry)
        { aaron.curState.enterConversation(actor, entry); }
;

/* a custom list group for Aaron and Erin when they're in alley 1 */
++ aaronAndErinAlley1: ListGroupCustom
    showGroupMsg(lst)
    {
        if (aaron.introduced)
            "Aaron och Erin är här och pratar tyst om stacken. ";
        else
            "Två studenter tittar på den svarta lådan och pratar tyst
            med varandra. En är en lång, smal kille med krulligt rött hår;
            den andra är en kort blond kvinna. ";
    }
;

/* a separate set of states for when we're working on the Upper 7 stack */
++ InConversationState
    specialDescListWith = [aaronAndErinUpper7]
;
+++ AskTellGiveShowTopic [efficiencyStudy37Topic, efficiencyStudy37]
    "Hur gärna du än skulle vilja avslöja Mitachrons onda planer för
    världen, har du en känsla av att det finns bättre ställen att börja på. "

    isConversational = nil
;
+++ AskTellTopic @posGame
    "<q>Vet du något om Positron-spelet på nedervåningen?</q>
    frågar du.
    <.p><q>Inte direkt,</q> säger hon. <q>Jag är inte så intresserad av de där retro
    tv-spelen.</q> "
;
+++ AskTellTopic @scottTopic
    "<q>Har du sett Scott i närheten?</q> frågar du. <q>Killen som äger
    Positron-maskinen på nedervåningen?</q>
    <.p><q>Jag tror han håller på med den gigantiska kycklingsstacken,</q> säger
    hon. <q>Gränd 3.</q> "
;
+++ AskForTopic @scottTopic
    topicResponse() { replaceAction(AskAbout, gDobj, scottTopic); }
;
+++ AskTellTopic @jayTopic
    "<q>Har du sett Jay Santoshnimoorthy idag?</q> frågar du.
    <.p><q>Jag tror han arbetade med stacken i Gränd Fyra,</q> säger hon. "
;
+++ GiveShowTopic @calculator
    "Hon tittar snabbt på miniräknaren och lämnar tillbaka den. <q>Om du
    har tid borde du visa den för Jay Santoshnimoorthy och
    se vilka trick han kan göra med den.</q> "
;
+++ AskTellShowTopic [ddTopic, paulStackTopic, commandant64]
    "<q>Hur går det med stacken?</q> frågar du.
    <.p><q>För tidigt att säga,</q> säger hon. <q>Vi är inte riktigt säkra
    på vad som pågår än.</q> "
;
+++ AskTellAboutForTopic [physicsTextTopic, bloemnerBook, drdTopic]
    "<q>Var är bästa stället att hitta läroböcker här omkring?</q> frågar du.
    <.p><q>Jag skulle prova Millikan,</q> säger Erin. <q>Bokhandeln brukar
    inte ha så mycket i lager den här tiden på året.</q> "
;
+++ AskTellAboutForTopic +90
    [eeTextbookRecTopic, eeTextTopic, morgenBook,
     eeLabRecTopic, labManualTopic, townsendBook]

    topicResponse()
    {
        "<q>Ni är elektroingenjörer, va?</q> frågar du. De två nickar. <q>Jag
        undrar om ni hade några rekommendationer för en bra lärobok i elektroteknik.
        Något jag kunde använda för att fräscha upp mina kunskaper.</q>
        <.p><q>Tja,</q> säger Erin, <q>jag tyckte boken vi använde i
        EE tolv var bra. Um, någon Morgen, tror jag.</q>
        <.p>Aaron nickar. <q>Yves Morgen. Mycket lättläst. Stavas
        M-O-R-G-E-N.</q><.reveal morgen-book> ";

        /* award some points for this */
        morgenBook.recMarker.awardPointsOnce();
    }
;
++++ AltTopic
    "<q>Några andra rekommendationer för läroböcker i elektroteknik?</q> frågar du.
    <.p>Erin skakar på huvudet. <q>De jag använder i år är
    skräp. Jag tyckte Morgen-boken var ganska bra.</q> "

    isActive = (gRevealed('morgen-book'))
;
+++ AskTellTopic @qubitsTopic
    "<q>Vet du vad <q>QUBITS</q> betyder?</q> frågar du.
    <.p><q>Jag tror det är något kvantdatorgrejer,</q> säger
    hon. "
;
+++ AskTellTopic @quantumComputingTopic
    "<q>Vad vet du om kvantdatorer?</q> frågar du.
    <.p><q>Det är ett hett ämne här omkring nuförtiden,</q> säger hon,
    <q>men jag har inte tittat så mycket på det.</q> "
;
+++ DefaultAnyTopic
    "Hon verkar ganska fokuserad på stacken just nu. "
    isConversational = nil
;
    
+++ erinUpper7: ConversationReadyState
    stateDesc = "Hon studerar datorskärmen. "
    specialDescListWith = [aaronAndErinUpper7]

    /* we're paired with Aaron for conversation, so let him handle it */
    enterConversation(actor, entry)
        { aaron.curState.enterConversation(actor, entry); }
;

/* a custom list group for Aaron and Erin when they're in Upper 7 */
++ aaronAndErinUpper7: ListGroupCustom
    showGroupMsg(lst)
    {
        "Aaron och Erin är här, samlade runt persondatorn. ";
    }
;

/* a separate set of states for the breezeway around lunchtime */
++ erinBreezeway: InConversationState
    nextState = erinBreezeway
    stateDesc = "Hon står här och pratar med dig. Hon fortsätter
        att kasta blickar mot gränden. "
    specialDescListWith = [aaronAndErinBreezeway]
;

++ ConvNode 'erin-smoke'
    npcGreetingMsg = "Aaron och Erin kommer in från innergården
        och tittar försiktigt in i gränden. Erin ser dig och
        kommer fram. <q>Vad hände?</q> frågar hon. "

    npcContinueList: StopEventList { [
        'Erin går bort till Aaron för en stund nära grändens ingång,
        sedan kommer hon tillbaka. <q>Vilken röra,</q> säger hon. ',

        &inviteToLunch ]

        /* invite the PC to lunch */
        inviteToLunch()
        {
            "Aaron kommer över för att ansluta sig till dig och Erin. <q>Såg du något?</q>
            frågar Erin.
            <.p>Aaron skakar på huvudet. <q>Nej. Bara rök.</q>
            <.p>Erin vänder sig mot dig. ";

            if (gRevealed('lunch-invite'))
                "<q>Vi är på väg till lunch nu, om du vill
                följa med. ";
            else
                "<q>Vi var precis på väg till lunch. Du borde
                följa med. ";

            "Du kan berätta för oss om Brians stack.</q><.convnode> ";
            erin.goToLunch();
        }
    }

    endConversation(actor, reason)
    {
        "<q>Förresten,</q> säger Erin, <q>vi är på väg till lunch.
        Du borde följa med om du vill.</q> ";

        erin.goToLunch();
    }
;
+++ TellTopic, SuggestedTellTopic
    [ddTopic, stackTopic, blackBox, stamerStackTopic, explosionTopic, bwSmoke]
    "<q>Jag är inte riktigt säker på vad som hände,</q> säger du. <q>Det var
    någon sorts explosion, tror jag. Jag är ganska säker på att det var
    Mitachron-utrustningen.</q> Erin nickar.<.convstay> "

    name = 'explosionen'
;
+++ AskTellTopic, StopEventList @lunchTopic
    ['<q>Några idéer om var jag kan få tag på lunch?</q> frågar du.
    <.p><q>Vi ska äta här,</q> säger Erin. <q>Du borde
    följa med oss. Matsalen är precis där borta.</q> Hon pekar
    över innergården mot öster.<.reveal lunch-invite><.convstay> ',

     '<q>Du sa att ni ska äta lunch här?</q> frågar du.
     <.p><q>Ja, i matsalen,</q> säger hon och pekar
     över innergården mot öster.<.convstay> ']
;

+++ DefaultAnyTopic
    "Något i gränden distraherar henne precis när du börjar
    prata, och hon verkar missa vad du sa.<.convstay> "
    isConversational = nil
;

/* a custom list group for Aaron and Erin for the breezeway at lunchtime */
++ aaronAndErinBreezeway: ListGroupCustom
    showGroupMsg(lst) { "Erin står här och pratar med dig.
        Aaron försöker se vad som pågår i gränden. "; }
;

/* a custom list group for Aaron and Erin in the dining room at lunch */
++ aaronAndErinLunch: ListGroupCustom
    showGroupMsg(lst) { "Erin och Aaron sitter vid bordet
        och äter sin lunch. "; }
;

/* a separate set of states for the dining room at lunchtime */
++ erinLunch: ActorState, AaronErinConvList, EventList
    nextState = erinLunch
    stateDesc = "Hon sitter vid bordet och äter lunch. "
    specialDescListWith = [aaronAndErinLunch]

    eventList = [
        nil,
        'Aaron försöker skära itu en särskilt seg köttbit,
        men kan inte göra ett märke. Han ger upp och äter den hel. ',
        &askAboutOmegatron
    ]

    askAboutOmegatron()
        { erin.initiateConversation(nil, 'erin-ask-omegatron'); }
;

+++ HelloTopic
    "Du småpratar lite med Erin. "
;

/* BYE depends on whether we've seen the whole lunch conversation yet */
+++ ByeTopic, StopEventList
    ['<q>Jag borde återgå till min stack,</q> säger du.
    <.p><q>Redan?</q> frågar Erin. <q>Kom igen, stanna en stund. De
    har förmodligen inte ens släckt branden än.</q> ',

     '<q>Jag borde gå,</q> säger du.
     <.p><q>Du borde åtminstone äta klart,</q> säger Erin. ']
;
++++ AltTopic
    topicResponse()
    {
        /* we're done with lunch, so just leave */
        replaceAction(South);
    }
    isActive = (dabneyDining.endOfLunchNoted != 0)
;

+++ AskTellShowTopic @myLunch
    "<q>Är maten alltid så här dålig?</q> frågar du.
    <.p><q>Det här?</q> frågar Erin. <q>Det här är inte så illa. Du
    borde se middagen.</q> "
;

+++ AskTopic [stackTopic, ddTopic, paulStackTopic, commandant64]
    "<q>Hur går det med er stack?</q> frågar du.
    <.p>Erin rycker på axlarna. <q>Vi har inte knäckt den än. Det är uppenbarligen
    någon sorts kod, men vi är inte säkra på vilken typ.</q> "
;

+++ AskTellTopic, SuggestedTellTopic [blackBox, ddTopic, stamerStackTopic]
    "Du berättar för Erin lite om dina försök att lösa stacken,
    och hur du har fått lära dig mycket grundläggande elektroteknik på nytt.
    Du nämner också utrustningen och personalen som Belker har
    tagit in.
    <.p><q>Det verkar inte rättvist,</q> påpekar Erin. Du
    måste hålla med, det <i>verkar</i> inte rättvist; men det
    verkar tekniskt sett inte bryta mot reglerna för stacken. "

    name = 'stacken'
;

+++ TellTopic, StopEventList @omegatronTopic
    ['Du berättar för Erin några allmänna bakgrundsfakta om Omegatron,
    och du hör dig själv låta som en företagsbroschyr. Du är inte
    säker på hur specifik du vill vara; du skulle kunna prata om
    många detaljer, som ditt jobb, era produkter, din chef,
    företagets byråkrati... ',

     'Du har redan gett henne den allmänna bakgrunden, och
     du är inte säker på hur mycket detaljer hon verkligen vill höra.
     Det finns många saker du skulle kunna prata om, som ditt jobb,
     era produkter, din chef, byråkratin... ']

    name = 'Omegatron'
;

+++ TellTopic +90 @mitachronTopic
    "Du känner alltid att det är dålig stil att smutskasta konkurrensen,
    men du kan inte låta bli att skämta om några av deras
    mer ökända produkter. Du berättar också för Erin om några av sakerna
    du har hört om att arbeta där, som hur vissa avdelningar
    får sina ingenjörer att bära pappershattar som visar deras rang. "
;

+++ AskTellShowTopic @aaron
    "<q>Är det bara min fantasi, eller tillbringar ni två mycket
    tid tillsammans?</q> frågar du.
    <.p>Erin rycker på axlarna. <q>Det är våra namn, ärligt talat. Det var
    all denna förvirring om huruvida någon pratade om
    Aaron med A eller Erin med E, så vi tänkte att det skulle vara
    enklare om vi gick överallt tillsammans.</q> "
;

+++ AskTellTopic, StopEventList @erin
    ['<q>Var växte du upp?</q> frågar du.
    <.p><q>Här i södra Kalifornien,</q> säger hon. <q>Orange County, faktiskt.
    Bakom den orangea ridån, som man säger.</q> ',

     '<q>Vad gör du på din fritid?</q> frågar du.
     <.p><q>Fritid?</q> säger hon och skrattar sarkastiskt.
     <q>Vilket trevligt koncept.</q> ',

     'Du småpratar lite mer. ']
;

+++ AskTellTopic 'orange (county|curtain)'
    "<q>Hur är Orange County?</q> frågar du.
    <.p>Hon rycker på axlarna. <q>Det är som var som helst, egentligen. Bara
    mer så.</q> "
;

+++ TellTopic @jobTopic
    "Du berättar för Erin lite om ditt jobb som ingenjörschef.
    Du försöker få det att låta intressant, men du känner att du
    misslyckas fruktansvärt. När du pratar om det inser du att större delen
    av ditt jobb handlar om att arbeta runt företagets dumhet: att få
    godkännanden trots att din VD aldrig är tillgänglig, att tillfredsställa konstiga
    påbud från högre ort utan att spåra ur det verkliga arbetet, att jonglera budgetar
    som inte alls är logiska...
    <.p><q>Så varför stannar du kvar?</q> frågar Erin till slut.
    <.reveal erin-asked-why-stay><.topics> "
;

+++ TellTopic [productsTopic, scu1100dx]
    "Du berättar för Erin lite om Omegatrons produkter. Du beskriver till och med
    SCU-1100DX, trots att du har hört att programmet troligen kommer att läggas ner.
    Erin lyssnar uppmärksamt, men du är säker på att hon bara låtsas vara intresserad;
    Omegatron har inte haft en banbrytande produkt på åratal. "
;

+++ TellTopic @bossTopic
    "Du berättar ett par humoristiska historier om din VD:s
    legendariska okunskap om verksamheten. <q>Personer som
    vet för mycket känner till alla anledningar till varför man <i>inte kan</i>,</q>
    brukar han säga; <q>mitt jobb är att säga, <i>varför inte?</i></q>
    Du måste alltid behärska dig för att inte föreslå att om
    det är hans arbetsbeskrivning, skulle företaget kunna spara mycket
    pengar genom att ersätta honom med en tränad papegoja.
    <.p><q>Jag är förvånad över att du står ut med det,</q> säger Erin.
    <.reveal erin-asked-why-stay><.topics> "
;

+++ TellTopic @bureaucracyTopic
    "Du berättar för Erin om hur byråkrati är det enda område där
    Omegatron verkligen överträffar sig själv, hur det har tillräckligt med byråkrati
    för ett företag tio gånger dess storlek. Du kan prata hela dagen om
    avdelningarnas revirstrider, de löjliga policyer som
    alltid tillämpas så stelt att de uppnår motsatsen till
    den avsedda effekten; och från Erins glasartade uttryck
    inser du att du <i>har</i> pratat hela dagen om det.
    <.p><q>Varför hittar du inte ett annat jobb?</q> frågar Erin.
    <.reveal erin-asked-why-stay><.topics> "
;

+++ DefaultAnyTopic, ShuffledEventList
    ['Erin undersöker intensivt en del av sin lunch, hennes uttryck
    visar lika delar nyfikenhet och avsky. Hon verkar missa
    vad du säger. ',
    'Den omgivande ljudnivån i rummet stiger just när du börjar
    prata, och Erin verkar inte höra dig. ',
    'Erin verkar inte särskilt intresserad av det. '
    ]

    isConversational = nil
;

/* 
 *   Topic group for explaining why we stay at omegatron.  We open this up
 *   when Erin asks about why we stay, and leave it open as long as lunch
 *   is going. 
 */
+++ TopicGroup
    isActive = (gRevealed('erin-asked-why-stay') && !gRevealed('after-lunch'))
;

++++ TellTopic @mitachronTopic
    "<q>Jag tittade faktiskt på ett jobb på Mitachron vid ett tillfälle,</q>
    berättar du för henne. Hur irriterande Omegatron än har varit ibland,
    ångrar du verkligen inte att du tackade nej till det Mitachron-jobbet.
    Visst, aktieoptionerna skulle ha varit värda en hel del vid det här laget,
    men ju mer du lär dig om Mitachron desto mindre gillar du
    dem. <q>Det är ett jobb jag är glad att jag tackade nej till.</q> "
;

++++ TellTopic, SuggestedTellTopic @otherJobOffersTopic
    "<q>Faktiskt har jag fått några erbjudanden genom åren från andra
    företag,</q> säger du. När du tänker tillbaka är det svårt att komma ihåg
    exakt varför du aldrig tog något av dessa erbjudanden. Var och en hade
    någon brist, det är du säker på; att stanna kvar har definitivt haft sina egna
    problem, men bättre den djävul man känner, som man säger. Men var det
    verkligen rädsla för det okända som alltid stoppade dig? Du har
    en gnagande känsla av att det inte var det, att det var en annan sorts
    rädsla: rädsla för att vilken framgång du än har haft på Omegatron har
    varit en tillfällighet, och att du inte skulle kunna upprepa den
    någon annanstans. <q>Jag antar att jag aldrig hittade en möjlighet som var bra
    nog för att locka bort mig.</q>
    <.reveal lunch-satisfied-1> "

    name = 'andra jobberbjudanden'
;

++++ TellTopic, SuggestedTellTopic @startupsTopic
    "<q>Jag har tittat på några startups genom åren,</q> säger du,
    <q>men de verkade alltid lite riskabla.</q> Du har alltid gillat
    tanken på att arbeta för ett mindre företag---en chans att bygga
    något från grunden, utan all overhead från stora företag.
    Visst, startups är riskabla. Men när du tänker på det nu måste du
    undra om risken som verkligen oroade dig inte var något mer
    personligt: rädsla för att du inte skulle vara tillräckligt bra, att dina år
    på det stora företaget gjorde dig för mjuk.
    <.reveal lunch-satisfied-1> "

    name = 'startup-företag'
;

/* conversation node for asking about omegatron at lunchtime */
++ ConvNode 'erin-ask-omegatron'
    npcGreetingMsg = "Erin ger upp om en blågrön klump och skjuter
        den åt sidan. <q>Hur är Omegatron?</q> frågar hon. "

    npcContinueList: ShuffledEventList { [
        '<q>Jag är nyfiken på hur Omegatron är,</q> säger Erin. ',
        '<q>Jag vet inte så mycket om Omegatron,</q> säger Erin. ',
        '<q>Berätta om Omegatron,</q> säger Erin. ' ] }
;
+++ TellTopic, SuggestedTellTopic @omegatronTopic
    "Du är inte säker på hur du ska svara på en så öppen fråga; du skulle kunna
    berätta för henne om ditt jobb, era produkter, din chef,
    byråkratin...\ allt som kommer till tankarna verkar bara lite
    negativt. <q>Vi är en ledande elektroniktillverkare,</q>
    säger du, som om du läste från en broschyr. Men du kan inte verkar
    stoppa dig själv. <q>Vi erbjuder ett diversifierat utbud av
    branschledande produkter, tillsammans med relaterade konsult- och
    supporttjänster.</q> "

    name = 'Omegatron'
;

/* a separate set of conversation states for the endgame */
++ erinRoom4: ActorState
    stateDesc = "Hon kollar in snacksen. "
    specialDescListWith = [aaronAndErinRoom4]
;

+++ AskTopic [stackTopic, ddTopic, paulStackTopic, commandant64]
    "<q>Löste ni er stack?</q> frågar du.
    <.p><q>Ja,</q> säger hon. <q>Det är ett bra pussel. Jag tänker inte
    avslöja det för dig, ifall du vill gå tillbaka och prova det
    själv.</q> "
;
+++ TellTopic [stackTopic, ddTopic, blackBox, stamerStackTopic]
    "Aaron och Erin lyssnar uppmärksamt när du förklarar dina
    äventyr med att lösa Stamers stack. "
;

+++ DefaultAnyTopic
    "Hon verkar inte kunna höra dig över ljudet från folkmassan. "
    isConversational = nil
;

+++ InitiateTopic @stackTopic
    "Aaron och Erin tar sig in i rummet. De ser dig
    och kommer över för att hälsa.
    <.p><q>Grattis till att du löste stacken,</q> säger Erin.
    Hon och Aaron vandrar sedan över till snacksen. "
;

/* a custom list group for Aaron and Erin when we're in room 4 */
++ aaronAndErinRoom4: ListGroupCustom
    showGroupMsg(lst) { "Aaron och Erin står nära snacksen. "; }
;

/* ------------------------------------------------------------------------ */
/*
 *   The movers.  These guys show up near the start of the stack discovery
 *   section, after we meet Aaron and Erin.  
 */
+ a1nMovers: MitaMovers
    "Ett antal av flyttarbetarna packar upp lådor och arrangerar
    utrustning tagen från lådorna. Andra fortsätter att anlända med
    fler lådor, placerar dem där Belker anvisar och vänder sedan
    om för att hämta mer. "

    "Flera Mitachron-flyttarbetare är här och packar upp sina lådor och
    containrar. Andra fortsätter att anlända, lämnar av sin last och
    ger sig av. "

    /* 
     *   list the movers early, before the other specialDesc items - we
     *   want them to show up before the piles of stuff they're unloading 
     */
    specialDescBeforeContents = true
    specialDescOrder = 90
;

+ equipInAssembly: PresentLater, Immovable
    'omonterad elektronik mitachron utrustning/högar'
    'Mitachron-utrustning'
    "Med all aktivitet som pågår kan du inte komma tillräckligt nära
    för att få en bra titt på något. Det ser just nu bara ut som en massa
    omonterad elektronisk utrustning. "

    specialDesc = "Högar av omonterad utrustning börjar
        staplas upp runt Belker när flyttarna packar upp sin last.
        Gränden blir allt svårare att ta sig igenom. "

    /* this is part of the MitaMovers 'makePresent' group */
    plKey = MitaMovers

    lookInDesc = "Du tittar försiktigt över utrustningen, men det
        är för många Mitachron-personer runt omkring för att du ska kunna
        få en detaljerad titt. "
;

/* ------------------------------------------------------------------------ */
/*
 *   The Mita Test Ultimate Pro 3000.  The Mita Test and its gaggle of
 *   technicians are around for the first half or so of solving the stack.
 *   These guys are reverse-engineering the black box for Belker.  The Mita
 *   Test and its technicians are removed in the lunchtime blowout, to be
 *   replaced with the Mitavac.  
 */
+ mitaTestPro: PresentLater, Heavy
    'överdimensionerad klarguld ultramodern enorm
    mitatest ultimat pro industriell dubbel platina
    super 3000 stordator (typ)/maskin/megatestare/text/dator'
    'MegaTestare 3000'
    "Överdimensionerad text, i ultramodern klarguld typsnitt,
    tillkännager stolt maskinens namn: MitaTest Ultimat Pro
    Industriell Dubbel Platina Super MegaTestare 3000.
    <.p>
    Du har hört talas om dessa, men du har aldrig sett en förut; du har hört
    att endast ett dussintal någonsin har byggts. Ungefär lika stor som en
    minibuss, lämnar den inte mycket utrymme för de flera tekniker
    som här flitigt sköter den.
    <.p>
    3000:an sägs ha en databas över varje chip som producerats
    under de senaste trettio åren, även specialdelar, och de säger att den kan
    upptäcka ett defekt chip på sex meters avstånd. Den reducerar det mest
    invecklade elektroniska detektivarbetet till en enkel fråga om att läsa
    av en skärm. Stamers svarta låda har inte en chans mot den här
    saken. "

    plKey = 'pro3000'

    specialDesc = "En enorm maskin som påminner om en 1960-tals
        stordator blockerar nästan hallen och lämnar knappt
        tillräckligt med utrymme för att ta sig förbi. Flera tekniker är flitigt
        sysselsatta med att manövrera den. "
;
++ Component
    '(megatestare) (3000) skärm/skärmar'
    'MegaTestare-skärmar'
    "MegaTestaren har många skärmar, men du vet inte hur man
    ska tolka den visade informationen. "
    isPlural = true
;
++ Component
    '(megatestare) (3000) kontroller' 'MegaTestare-kontroller'
    "MegaTestaren är lika fullproppad med kontroller som cockpiten på
    ett passagerarflygplan, och de är lika obegripliga för dig. "
    isPlural = true
;

+ mitaTestOps: PresentLater, Person 'mitachron tekniker' 'tekniker'
    "De bär alla långa vita labbrockar. De är flitigt sysselsatta med att manövrera
    MegaTestare 3000, medan Belker övervakar noga. Den
    intensiva övervakningen gör dem uppenbarligen nervösa. "
    isPlural = true
    isHim = true
    isHer = true

    plKey = 'pro3000'

    /* we don't need a special desc, as the MegaTester mentions us */
    specialDesc = ""
;
++ mitaTestOpsCoats: InitiallyWorn
    'teknikernas knälånga långa vita labbrock/labbrockar' 'labbrockar'
    "Teknikerna bär knälånga vita labbrockar. "
    isPlural = true
    isListedInInventory = nil
;

++ DefaultAnyTopic, ShuffledEventList
    ['Du försöker prata med en av teknikerna, men han tittar nervöst
    åt ett annat håll. ',
     'Du verkar inte kunna få någons uppmärksamhet. ',
     'Teknikerna arbetar febrilt med utrustningen och ignorerar dig. ']
;

/* ------------------------------------------------------------------------ */
/*
 *   Xojo is one of the technicians operating the MegaTester; we notice
 *   him after a bit.  We use a separate object for Xojo in this segment
 *   of the game from the one we used in the introduction, since at an
 *   implementation level there's not much in common.  
 */
+ xojo2: PresentLater, Person 'provanställd 119297 xojo/(anställd)' 'Xojo'
    "Xojo är en asiatisk kille i tjugoårsåldern, något längre än
    du och mycket smal. Han bär en knälång vit labbrock. "

    isProperName = true
    isHim = true

    /* 
     *   list xojo after other actors, so that he always follows the
     *   technicians when they're also present (which they essentially
     *   always are when xojo is here) 
     */
    specialDescOrder = 210
;

++ DisambigDeferrer, InitiallyWorn
    'knälång lång vit labbrock' 'labbrock'
    "Xojo bär en knälång vit labbrock. "

    isListedInInventory = nil

    /* defer to the generic technician lab coat object */
    disambigDeferTo = [mitaTestOpsCoats]
;

++ xojo2Base: ActorState
    isInitState = true
    stateDesc = "Han manövrerar flitigt MegaTestaren. "
    specialDesc = "En av teknikerna som arbetar på maskinen är Xojo. "
;

++ xojo2Mitavac: ActorState
    stateDesc = "Han arbetar med kontrollerna på Mitavac. "
    specialDesc = "En av teknikerna som arbetar på datorn är Xojo. "
;

++ xojo2Crowd: ActorState
    stateDesc = "Han står i folkmassan. "
    specialDesc = ""
;
+++ DefaultAnyTopic
    "Det är för bullrigt här; du kan inte få hans uppmärksamhet. "
;

++ DefaultAnyTopic, ShuffledEventList
    ['Xojo vänder sig bara lite mot dig och grimaserar, gestikulerar med
    en ryck på huvudet mot Belker. ',
     'Xojo reser sig och går mot dig, stannar upp för ett ögonblick
     när han kommer upp jämsides för att säga <q>Han kommer att observera,</q> sedan
     fortsätter han förbi dig. ',
     'Xojo sneglar på dig, skakar på huvudet mycket lätt och tittar bort. ',
     'Innan du kan få Xojos uppmärksamhet klappar en av de andra teknikerna
     Xojo på axeln och börjar prata med honom. ',
     'När du är på väg att försöka prata med Xojo ser du Belker titta
     över, så du bestämmer dig för att vänta lite för att undvika att få Xojo i trubbel. ',
     'Xojo låtsas ignorera dig. ',
     'Xojo ignorerar dig och rör sig lite bort. ']
;

/* 
 *   An agenda item for Xojo's re-introduction.  This brings the new xojo
 *   actor into the game, and kicks off a brief conversation.  We schedule
 *   this as soon as the MegaTester and the other technicians are set up,
 *   but we don't let it fire until the player is back here to take part in
 *   the intro conversation.  
 */
++ xojoIntroAgenda: ConvAgendaItem
    isReady = (inherited() && me.isIn(alley1N))
    invokeItem()
    {
        /* 
         *   Wait a couple of eligible turns to fire this.  Note that we
         *   don't use DelayedAgendaItem for this, because that waits a
         *   few turns before even testing for eligibility - we instead
         *   want to wait a few turns after we know we're already eligible
         *   to run. 
         */
        if (invokeCnt++ < 3)
            return;

        /* bring the new xojo into play */
        xojo2.makePresent();

        /* xojo introduces himself */
        "<.p>En av teknikerna rör sig nära dig,
        pysslar med kontrollerna på MegaTestaren. <q>Ursäkta mig,
        herr Mittling,</q> säger han. Du flyttar dig åt sidan för att ge honom
        lite utrymme att arbeta, men det slår dig omedelbart att
        undra varför han kallade dig vid namn. Du tittar tillbaka och ser honom
        titta åt ditt håll, ger dig ett oroligt, bönfallande leende och
        en mycket lätt vinkning. Du inser att det är Xojo, din forna
        assistent/övervakare från Statligt Kraftverk #6. ";

        /* this counts as xojo initiating a conversation */
        xojo2.initiateConversation(xojo2Intro, nil);

        /* this agenda item is done */
        isDone = true;
    }

    invokeCnt = 0;
;

/* 
 *   a "retry" for the xojo introduction agenda - we'll run this if we walk
 *   out before talking to xojo the first time around 
 */
++ xojoIntroRetryAgenda: ConvAgendaItem
    isReady = (inherited() && me.isIn(alley1N))
    invokeItem()
    {
        /* xojo introduces himself */
        "<.p>Xojo rör sig nära dig och gestikulerar som om han vill
        prata med dig, men han håller sig vänd bort från dig. ";

        /* this counts as xojo initiating a conversation */
        xojo2.initiateConversation(xojo2Intro, nil);

        /* this agenda item is done */
        isDone = true;
    }
;

/*
 *   A state for Xojo's re-introduction.  Xojo initiates the conversation,
 *   and then will respond to anything with the default response here.
 *   When we show that response, it will attract Belker to join in, so
 *   we'll initiate another conversation with Belker at that point.  
 */
++ xojo2Intro: InConversationState
    attentionSpan = nil
    stateDesc = "Han försöker diskret få din uppmärksamhet. "
    specialDesc = "Xojo står nära MegaTestaren och försöker diskret
        få din uppmärksamhet. "

    /* 
     *   on leaving this state, re-introduce the 'introduction' agenda item
     *   if we didn't finish the conversation 
     */
    deactivateState(actor, newState)
    {
        /* do the normal work first */
        inherited(actor, newState);

        /* rerun the 'introduction' agenda if we're not talking to xojo */
        if (newState != xojo2Intro2)
            xojo2.addToAgenda(xojoIntroRetryAgenda);
    }
;
+++ DefaultAnyTopic
    topicResponse()
    {
        "<q>Xojo!</q> säger du. <q>Vad gör du här?</q>
        <.p>Han håller sig vänd mot MegaTestaren och talar
        tyst, i smyg. <q>Mitachron-företaget var mycket
        generöst i att erbjuda mig anställning efter deras besök
        på Statligt Kraftverk nummer 6.</q> Han rör sig lite
        närmare, låtsas arbeta med kontroller närmare dig, och
        sänker rösten ännu mer. <q>Men jag önskar be
        mest enträget om din hjälp att få anställning på
        ert underbara Omegatron-företag. Mitachron är mycket
        mer hemskt än Omegatron, det är jag säker på.</q> Han nickar
        snabbt. <q>Den mycket övertygande anställningsbroschyren
        skildrar inte korrekt den stora likheten i obehag
        med en straffanstalt. Vi är tvungna att sjunga företagets
        motivationssånger under morgonens ankomsttid. Vid
        lunchtid&mdash;</q> ";

        /* switch to the pretending-to-be-invisible state */
        xojo2.setCurState(xojo2Intro2);

        /* initiate the conversation with Frosst */
        frosst.initiateConversation(frosstAlleyConv, 'meet-xojo');
    }
;

/* a new state we reach after Belker comes over during our introduction */
++ xojo2Intro2: InConversationState
    attentionSpan = nil
    stateDesc = "Han verkar försöka vara osynlig. "
    specialDesc = "Xojo står nära MegaTestaren. Han är vänd
        bort från dig och Belker, som om han försöker vara osynlig. "

    /* when we're done, return to the base state */
    nextState = xojo2Base
;
+++ DefaultAnyTopic
    "Xojo försöker uppenbarligen hårt att vara osynlig just nu. "
;

/* ------------------------------------------------------------------------ */
/*
 *   The Mitavac 3000.  This shows up after the lunchtime blowout; it
 *   replaces the Mita Test Pro, but serves essentially the same scenery
 *   function.  We just change things to provide a little variety, and
 *   because it makes more sense in the plot for Frosst to have figured out
 *   what the black box does and to have moved on to solving its math
 *   puzzle.  
 */
+ mitavac: PresentLater, Heavy
    'toppmodell stordator mitavac grå 3000
    dator/superdator/enhet/enheter/namnskylt'
    'Mitavac 3000'
    "Det är en serie gråa kylskåpsstora enheter, uppradade
    sida vid sida längs en vägg. Namnskylten identifierar den som
    en Mitavac 3000, som du känner igen som Mitachrons högklassiga
    stordator-superdator. Du kommer inte ihåg de detaljerade specifikationerna
    för den här modellen, men du vet att den är snabb; det är den typ av dator
    man använder dessa dagar om man förutspår vädret, simulerar
    termonukleära explosioner, eller summerar Mitachrons kvartalsvisa
    vinster. "

    plKey = 'mitavac'
;
++ Component
    '(mitavac) (stordator) (dator) (3000) blinkande
    kontroll/kontroller/vred/vredar/knapp/knappar/panel/lampa/lampor'
    'Mitavac-kontroller'
    "Datorn har en panel med vred och knappar och blinkande
    lampor. Du skulle inte ha en aning om hur man använder någon av dem, även
    om teknikerna skulle låta dig komma i närheten av dem. "
;
++ SimpleNoise 'lågt pulserande brummande/ljud/oljud' 'pulserande ljud'
    "Mitavac avger ett lågt pulserande brummande. "
;

+ mitavacTechs: PresentLater, Person
    'mitachron tekniker' 'tekniker'

    /* 
     *   note that we use no description here; we get it entirely from the
     *   state object 
     */
    desc = ""

    isPlural = true
    isHim = true
    isHer = true

    plKey = 'mitavac'
;
++ InitiallyWorn
    'teknikernas knälånga långa vita labbrock/labbrockar' 'labbrockar'
    "Teknikerna bär knälånga vita labbrockar. "
    isPlural = true
    isListedInInventory = nil
;

++ DefaultAnyTopic, ShuffledEventList
    ['Du försöker prata med en av teknikerna, men han tittar nervöst
    åt ett annat håll. ',
     'Du verkar inte kunna få någons uppmärksamhet. ',
     'Teknikerna arbetar febrilt med utrustningen och ignorerar dig. ']
;

++ ActorState
    stateDesc = "Teknikerna bär alla långa vita labbrockar.
        De manövrerar flitigt Mitavac 3000. "
    specialDesc = "En enorm stordator fyller hallen och lämnar
        mycket lite utrymme att passera. Flera Mitachron-tekniker
        står nära den och arbetar med kontrollerna. "

    isInitState = true
;

++ mitaTechCrowd: ActorState
    stateDesc = "Teknikerna bär alla långa vita labbrockar.
        De står i den trånga hallen. "
    specialDesc = "En enorm stordator fyller hallen och lämnar
        mycket lite utrymme att passera.
        <.p>En folkmassa har bildats i gränden---mestadels studenter, men
        Mitachron-teknikerna är blandade in, inklusive Xojo. Så
        många människor är här att det knappt finns utrymme att röra sig.
        De står alla runt och pratar. "
;
+++ DefaultAnyTopic
    "Du kan inte få någons uppmärksamhet över allt oväsen. "
;

/* ------------------------------------------------------------------------ */
/*
 *   The crowd of students that shows up after we solve the stack 
 */
+ alley1Crowd: PresentLater, Actor
    'folkmassa/student/studenter' 'folkmassa'
    "Ett par dussin studenter, tillsammans med Mitachron-teknikerna,
    rör sig omkring i gränden, går in och ut ur rum 4. "
;
++ DefaultAnyTopic
    "Det är mycket oväsen; du har svårt att göra dig
    hörd. "
;
++ SimpleNoise
    'folkmassans ljud/prat/sorl/samtal' 'folkmassans ljud'
    "Gränden är fylld av ett kontinuerligt sorl av samtal från
    folkmassan. "
;

/* ------------------------------------------------------------------------ */
/*
 *   An agenda item for Frosst to bribe the techers hanging around the
 *   stack initially, so that they'll go find something else to do. 
 */
bribeStudents: DelayedAgendaItem
    /* 
     *   We want the PC to see this happen, so only fire when the PC is
     *   here.  We also only want to fire this when the PC hasn't been
     *   talking to anyone else this turn, so that we don't interrupt the
     *   rest of the conversation.  
     */
    isReady = (inherited
               && me.isIn(frosst.location)
               && !me.conversedThisTurn())

    invokeItem()
    {
        "<.p>Frosst vrider sin mobiltelefon bort från munnen, fortfarande
        med den mot örat. <q>Ursäkta mig,</q> säger han till Aaron och
        Erin, ";

        if (gRevealed('aaron-erin-major'))
            "<q>men hörde jag rätt att ni två sa att ni studerade elektroteknik?</q>
            <.p>De tittar på Belker och nickar. ";
        else
            "<q>får jag fråga vilket ämne ni två unga människor
            studerar vid detta universitet?</q>
            <.p><q>Vi är båda elektronikingenjörer,</q>
            säger Erin. ";

        "<.p><q>Då har ni säkert stött på Paulis uteslutningsprincip,</q>
        säger han. Erin och Aaron tittar på varandra,
        förvirrade. <q>Principen som gör att halvledare fungerar
        och gör all modern elektronik möjlig? Nåväl. Jag nämner detta
        eftersom det verkar som om vi har vår egen uteslutningsprincip av något slag.
        I vårt fall är det inte elektroner som intresserar oss utan vi
        flera personer, som snart kommer att finna det svårt att
        uppta samma utrymme medan vi arbetar på samma...\ stack. Detta
        är anledningen till att jag skulle vilja erbjuda er en viss summa, endast för
        att hitta en annan stack att ägna er åt. Det finns många, förstår jag.</q>
        <.p>Erin ser förolämpad ut. <q>Tror du att du bara kan muta oss?</q>
        <.p>Belker använder sin axel för att hålla fast mobiltelefonen mot örat
        och sträcker sig ner i fickan, tar fram en bunt sedlar.
        <q>Det är mer av naturen av en symbolisk ersättning,</q> säger
        han. <q>En samling stor utrustning kommer att anlända
        inom kort, vilket kommer att göra denna korridor trång och
        obehaglig. Mitt erbjudande är ett sätt att be om ursäkt för
        olägenheten jag säkert kommer att orsaka. Kanske ett rimligt belopp skulle
        vara, hmm, fem dollar?</q>
        <.p>Aaron och Erin tittar på varandra otroligt. <q>Fem
        dollar?</q> frågar Erin.
        <.p><q>Fem dollar <i>var</i>, naturligtvis.</q>
        <.p><q>Wow!</q> säger Aaron.
        <.p>De två tar glatt emot pengarna och börjar gå, men
        Erin stannar plötsligt, vänder sig om och tar fram en nyckel.
        <q>Jag antar att jag inte kommer att behöva den här,</q> säger hon och kastar
        nyckeln till dig. Sedan rusar de iväg nerför korridoren. Du tittar
        på nyckeln och ser att den är märkt <q>Lab.</q> ";

        /* give me the key; put it on the keyring if convenient */
        if (myKeyring.isIn(me) && me.canTouch(myKeyring))
        {
            "Du sätter den på din nyckelring för att vara säker på att du inte tappar bort den. ";
            labKey.moveInto(myKeyring);
        }
        else
            labKey.moveInto(me);

        /* keep track of the departure for 'follow' purposes */
        me.trackFollowInfo(aaron, alley1N.south, alley1N);
        me.trackFollowInfo(erin, alley1N.south, alley1N);

        /* 
         *   move aaron and erin to Upper 7 north, where they'll find
         *   another stack to work on 
         */
        aaron.moveIntoForTravel(upper7N);
        erin.moveIntoForTravel(upper7N);
        aaron.setCurState(aaronUpper7);
        erin.setCurState(erinUpper7);

        /* schedule the start of the equipment arrival */
        frosst.addToAgenda(equipArrival.setDelay(2));

        /* this agenda item is completed */
        isDone = true;
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   An agenda item to begin the arrival of frosst's equipment. 
 */
equipArrival: DelayedAgendaItem
    invokeItem()
    {
        /*
         *   Belker's equipment arrival spans several locations: the orange
         *   walk, the breezeway, and alley 1 north and south.  Generate an
         *   appropriate message in each location (with the sense context
         *   limiting each report to its location), so that we hear about
         *   it no matter where we are among these locations.
         *   
         *   Given the timed conditions that initiate this agenda item, we
         *   can't actually get farther than the breezeway, so we don't
         *   actually need to report anything on the orange walk.  However,
         *   do so anyway for completeness; this will ensure we have
         *   something there if we change the timer in the future.  
         */
        callWithSenseContext(orangeWalk, sight, new function() {
            "<.p>En rad flyttarbetare som bär lådor och containrar marscherar
            upp från California Boulevard. När de går förbi ser du
            att deras uniformer bär Mitachron-logotypen. De går in
            i Dabney, medan andra följer efter med fler lådor. "; });

        callWithSenseContext(dabneyBreezeway, sight, new function() {
            "<.p>Flera flyttarbetare som bär lådor och containrar kommer in
            från Orange Walk, tittar sig omkring kort och går sedan in i
            den norra korridoren. När de släpar sig in i korridoren ser
            du att deras uniformer bär Mitachron-logotypen. Fler
            flyttarbetare anländer bakom dem. "; });

        callWithSenseContext(alley1S, sight, new function() {
            "<.p>Några flyttarbetare som bär lådor och containrar går in
            genom den södra dörröppningen. De manövrerar bryskt
            sina skrymmande laster runt dig och fortsätter upp i gränden
            norrut. När de passerar ser du Mitachron-logotypen
            på deras uniformer. Fler flyttarbetare följer efter dem. "; });

        callWithSenseContext(alley1N, sight, new function() {
            "<.p>Flera flyttarbetare som bär lådor och containrar kommer upp
            i gränden söderifrån. Du märker att deras
            uniformer bär Mitachron-logotypen. Belker lägger undan sin mobil-
            telefon och utbyter några ord med flyttarna, pekar
            ut var de ska ställa sina laster. Ett par av
            flyttarna börjar öppna lådor, och de andra vänder om
            och går tillbaka ner i gränden när fler flyttarbetare anländer.
            Belker står på plats, pekar och ger order som en
            trafikpolis, flyttarna en massa av rörelse runt honom. "; });

        /* get all the movers into place */
        PresentLater.makePresentByKey(MitaMovers);

        /* set frosst into unpacking mode */
        frosst.setCurState(frosstUnpacking);
        frosstCellPhone.moveInto(nil);

        /* we only need to run once */
        isDone = true;
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   Room 4
 */
room4: Room 'Rum 4' 'rum 4' 'rum'
    "Rummet har det röriga men spartanska utseendet av ett studentrum.
    Det är ett enkelrum, så det är litet; inte riktigt så litet att du kan
    röra vid motstående väggar samtidigt, men nästan. Inpackat
    i de cirka sju kvadratmeterna finns ett skrivbord, en stol och en säng.
    Bokhyllor täcker väggen ovanför skrivbordet. En dörr leder ut
    till gränden. "

    vocabWords = '4 rum fyra'

    east = r4Door
    out asExit(east)

    afterTravel(trav, conn)
    {
        /* bring the crowd into the room when we first arrive */
        if (!r4Crowd.isIn(self))
        {
            r4Crowd.makePresent();
            "Några av studenterna och teknikerna följer efter dig in i
            rummet för att hjälpa till att fira. De går raka vägen till snacksen
            och börjar äta. ";
        }
    }

    /* we have some scripted events that occur after we enter the room */
    atmosphereList: EventList { [
        nil,
        'Ett par fler studenter tar sig in i rummet. ',
        &aaronErinArrival,
        'Ett par av teknikerna tar sig ut i korridoren. ',
        nil,
        &stamerArrival ]

        /* aaron and erin arrive */
        aaronErinArrival()
        {
            /* bring them in */
            aaron.moveIntoForTravel(room4);
            erin.moveIntoForTravel(room4);
            aaron.setCurState(aaronRoom4);
            erin.setCurState(erinRoom4);

            /* say hello */
            erin.curState.initiateTopic(stackTopic);
        }

        /* stamer arrives */
        stamerArrival()
        {
            /* bring him in */
            stamer.moveIntoForTravel(room4);

            /* say hello */
            stamer.initiateConversation(nil, 'stamer-hello');
        }
    }

;

+ r4Door: Door ->room4Door '(rum) (4) rum/dörr*dörrar' 'dörr'
    "Det är en trädörr som leder ut till gränden. "

    /* don't allow leaving once we enter */
    canTravelerPass(trav) { return nil; }
    explainTravelBarrier(trav) { "Du kan inte ta dig förbi alla människor
        som trängs runt dörren. "; }
;

+ r4Crowd: PresentLater, Person
    'mitachron folkmassa/student/studenter/tekniker/tekniker' 'folkmassa'
    "Folkmassan är en blandning av studenter och Mitachron-tekniker.
    Det finns bara plats för några få personer åt gången här inne, så
    de rör sig in och ut ur rummet. "

    specialDesc = "En del av folkmassan från korridoren har spillt över
        in i rummet och lämnar lite utrymme att röra sig. Folk
        kommer och går, hjälper sig själva till snacksen. "
;
++ SimpleNoise
    'folkmassans ljud/prat/sorl/samtal' 'folkmassans ljud'
    "Gränden är fylld av ett kontinuerligt sorl av samtal från
    folkmassan. "
;
++ DefaultAnyTopic
    "Du försöker få någons uppmärksamhet, men alla är för
    upptagna med att prata. "
;

+ r4Desk: Heavy, Surface 'trä träskrivbord' 'skrivbord'
    "Det är ett litet träskrivbord. "
;

++ PresentLater, Wearable 'svart mitachron logotyp t-shirt' 'svart T-shirt'
    "Det är en svart T-shirt med Mitachron-logotypen. "
    plKey = 'logo-wear'
;
++ PresentLater, Readable
    'arbeta på mitachron glansig broschyr' 'Mitachron-broschyr'
    "Det är en glansig broschyr med titeln <q>Arbeta på Mitachron.</q> "

    readDesc = "Du bläddrar igenom broschyren och hittar massor av
        bilder på glada unga människor som gör roliga saker i
        korridorerna i moderna kontorsbyggnader. De verkar inte fokusera
        särskilt mycket på arbetsdelen. "
    
    plKey = 'logo-wear'
;
++ logoCap: PresentLater, Wearable
    'svart jätte gigantisk novelty mitachron logotyp basebollkeps/hatt'
    'basebollkeps'
    "Den är löjligt stor---den är som en av de där tio-gallons
    Texas-hattarna, men i form av en basebollkeps. Den är svart, med
    Mitachron-logotypen över framsidan. "

    dobjFor(Wear)
    {
        action()
        {
            "Kepsen är extremt tung, även med tanke på dess enorma
            storlek. Den känns nästan för tung för din nacke att bära,
            men du sätter på den ändå. När du gör det, överväldigas du av en konstig, varm känsla...\ LYD...\ nästan som stickningar-och-nålar
            känslan av att din arm somnar...\ HELL
            MITACHRON...\ en tröstande känsla, egentligen...\ VAD SOM ÄR BRA
            FÖR MITACHRON ÄR BRA FÖR AMERIKA...\ och det är lite konstigt
            hur din syn verkar suddig, hur allt plötsligt
            omges av glödande, virvlande kanter av
            färg...\ ACCEPTERA JOBBERBJUDANDE PÅ MITACHRON NU...\ och
            hur allt låter som om du är under vatten...\ LYD
            ACCEPTERA LYD ACCEPTERA LYD...
            <.p>Du känner dig lite yr, och du inser att din syn
            och hörsel har börjat återgå till det normala. Belker
            säger något och skrattar nervöst medan han sätter hatten
            på skrivbordet. ";

            /* move me back onto the desk */
            moveInto(r4Desk);
        }
    }

    plKey = 'logo-wear'
;

++ CustomImmovable, Food
    'snacks fest muta/mat/maträtter/bricka/choklad/choklader/godis/godisar/
    kaka/kakor/kex/kexen/druva/druvor/jordgubbe/jordgubbar/
    frukt/frukter/ost/snacks/snacksen/godbit/godbitar'
    'festbricka'
    "Mutan är en väsentlig del av varje Ditch Day-stack; när
    underklassarna har löst huvuddelen av stacken, är mutan
    den sista försvarslinjen mot att rummet vandaliseras. Mutor
    är vanligtvis i form av ätbara godsaker som detta. Regeln är
    att om mutan accepteras, är rummet säkert från vandalisering. "

    specialDesc = "Utspritt på skrivbordet finns ett fint urval av
        snacks, arrangerade på en festbricka: choklad, kakor,
        kex, druvor, jordgubbar, ost. "

    cannotPutInMsg = 'Det finns ingen anledning att hamstra maten; ät bara
        det du vill ha. '
    cannotMoveMsg = 'Det finns ingen anledning att omorganisera maten. '

    dobjFor(Take) asDobjFor(Eat)
    dobjFor(Eat)
    {
        /* we don't have to take the food to eat it; touching it is enough */
        preCond = [touchObj]
        action()
        {
            "Du hjälper dig själv till några av godsakerna. Allt är
            utsökt. ";
        }
    }
;

+ Bed, Heavy 'enkel+säng+en' 'säng'
    "Det är en enkel enkelsäng med vita lakan. "

    dobjFor(LookUnder) { action() { "Du har ingen anledning att snoka runt
        i någon annans rum. Även om det fanns, säg, en dollarsedel där,
        skulle den inte vara din att ta. "; } }
;
++ Decoration 'enkla vita (säng) lakan/sängkläder' 'sängkläder'
    "De är bara enkla vita lakan, med den där institutionella looken. "
    isPlural = true
;

+ Chair, CustomImmovable 'rak trä trästol' 'stol'
    "Det är en rak trästol. "

    cannotTakeMsg = 'Stolen är lite för skrymmande för att bära omkring. '
;

+ Surface, Fixture
    'obehandlad spånskiva bok bokhylla/bokhyllor/hylla/hyllor/skiva'
    'bokhyllor'
    "Hyllorna är gjorda av obehandlad spånskiva. De
    måste vara robusta, med tanke på den tunga lasten av böcker de bär. "
;
++ Decoration
    'referens fysik matematik kemi astronomi biologi teknik
    ekonomi seriös litteratur science fiction
    lärobok/bok/text*läroböcker*texter*böcker'
    'böcker'
    "Det ser ut som den vanliga samlingen böcker en Techer samlar på sig
    under en studentkarriär: läroböcker i fysik, matematik, kemi,
    astronomi, biologi, ekonomi; referensböcker; lite seriös
    litteratur; och massor av science fiction. "
    isPlural = true
;

/* ------------------------------------------------------------------------ */
/*
 *   Brian Stamer 
 */
stamer: Person
    'brian stamer' 'Brian'
    "Han är gänglig och lite blek. Hans kläder är något
    rufsiga. Från det tunna lagret av fjun skulle du gissa att han
    inte har rakat sig på några dagar. "

    isHim = true
    isProperName = true
;

+ HelloTopic
    "Du har redan Brians uppmärksamhet. "
;

+ ActorState
    isInitState = true
    stateDesc = "Han står här och pratar med dig. "
    specialDesc = "Brian Stamer står här och pratar med dig. "
;

++ TellTopic @logoCap
    "Du vet exakt vad den där kepsen måste vara. <q>Det där är ingen vanlig
    basebollkeps,</q> berättar du för Brian. <q>Vad du än gör, sätt inte
    på dig den.</q> "
    
    isActive = (gRevealed('galvani-2') && logoCap.location != nil)
;

++ AskTellTopic, SuggestedTellTopic, StopEventList @galvaniTopic
    ['<q>Har du någonsin hört talas om ett Mitachron-projekt som kallas Galvani-2?</q>
    frågar du.
    <.p><q>Visst,</q> säger han. <q>Det är det sinneskontrrollsystem
    som Mitachron har jobbat på. De har pratat om det
    i åratal, men de fortsätter att missa sina tidsplaner.</q> ',

     '<q>Tycker du inte att Galvani-2 är lite oroande?</q> frågar du.
     <.p>Han rycker på axlarna. <q>Jag antar att det skulle vara det om det faktiskt fungerade.
     Från vad jag har hört är det dock lite av ett skämt.</q> ',

     '<q>Jag tror att de har kommit mycket längre än du har hört,</q>
     säger du. <q>Och de har spionerat på ditt labb. De tror
     att ditt dekoherensprojekt är precis vad de behöver för att lösa sina
     problem.</q>
     <.p><q>Intressant,</q> säger han. ',

     'Du nämner igen hur Mitachron har spionerat på Stamers
     labb. Han nickar eftertänksamt. ']

    name = 'Projekt Galvani-2'
    isActive = gRevealed('galvani-2')
;
++ AskTellGiveShowTopic
    [efficiencyStudy37, efficiencyStudy37Topic, galvaniTopic]
    topicResponse() { replaceAction(TellAbout, stamer, galvaniTopic); }
;

++ AskTellTopic, SuggestedTopicTree, SuggestedTellTopic, StopEventList @spy9
    ['<q>Visste du att det finns en spionkamera gömd i ditt labb?</q>
    frågar du.
    <.p>Han höjer på ögonbrynen. <q>Nej, det visste jag inte.</q> ',

     'Du beskriver kameran och berättar för honom var den är gömd.
     <.p><q>Tack för att du berättade,</q> säger han. <q>Jag
     ska definitivt undersöka det.</q> ']

    name = 'SPY-9-kameran'
    isActive = (spy9.described)
;
+++ AltTopic, StopEventList
    ['<q>Visste du att det finns en spionkamera gömd i ditt labb?</q>
    frågar du.
    <.p>Han höjer på ögonbrynen. <q>Nej, det visste jag inte.</q> ',

     '<q>Jag spårade kamerans dataanslutning till ett kontor i
     Sync Lab,</q> säger du. <q>Mitachron satte upp den. De har
     spionerat på ditt labb.</q>
     <.p><q>Tja,</q> säger han. <q>Det är extremt oroande.</q> ',

     'Du berättar för honom hur man kommer in i Sync Lab-kontoret, och han
     säger att han ska gå och kolla upp det. ']
    
    isActive = (syncLabOffice.seen)
;

++ DefaultAnyTopic
    "Du bör förmodligen hålla dig till ämnet just nu.<.convstay> "
;

+ ConvNode 'stamer-hello'
    npcGreetingMsg = "Det blir en paus i folkmassans brus.
        En gänglig, blek student, som ser något rufsig ut, kommer
        in genom dörren och hälsar på de andra studenterna
        medan han banar sig väg genom folkmassan. Han kommer slutligen
        fram till dig och stannar.
        <.p><q>Hej,</q> säger han. <q>Jag är Brian Stamer. Jag gissar
        att du är den som löste min stack?</q> "

    /* stay here until we explicitly move on */
    isSticky = true

    /* don't allow terminating the conversation just yet */
    canEndConversation(actor, reason)
    {
        "Du bör verkligen presentera dig för Brian först. ";
        return nil;
    }

    npcContinueMsg = "Brian väntar fortfarande på att du ska presentera
        dig. "

    nextMsg = "<q>Jag är Doug Mittling, från Omegatron.</q> Ni skakar hand.
        <.p><q>Så,</q> säger Brian, <q>vad tyckte du om stacken?</q>
        <.convnode stamer-stack> "
;

++ HelloTopic
    "<q>Ja,</q> säger du. <<location.nextMsg>> "
;

++ YesTopic, SuggestedYesTopic
    "<q>Det stämmer,</q> säger du. <<location.nextMsg>> "
;

++ NoTopic
    "<q>Det var faktiskt min fickräknare som löste det,</q>
    säger du skrattande. <<location.nextMsg>> "
;

++ SpecialTopic 'presentera dig själv' ['presentera','dig','själv','mig']
    "<q>Det stämmer,</q> säger du. <<location.nextMsg>> "
;

+ ConvNode 'stamer-stack'
    /* stay here until we explicitly move on */
    isSticky = true

    /* don't allow terminating the conversation just yet */
    canEndConversation(actor, reason)
    {
        "Du borde berätta för Brian om stacken först. ";
        return nil;
    }

    npcContinueMsg = "Brian får din uppmärksamhet igen. <q>Vad tyckte
        du om stacken?</q> "

    nextMsg = "<.p><q>Du sa att du jobbar för Omegatron?</q> frågar Brian.
        <.convnode stamer-omegatron> "
;

++ AskTellTopic, SuggestedTellTopic [stackTopic, ddTopic, stamerStackTopic]
    "<q>Din stack var definitivt en lärorik upplevelse,</q> säger du.
    <q>Ditt experiment är verkligen något.</q><<location.nextMsg>> "
    name = 'stacken'
;

++ AskTellTopic, SuggestedTellTopic [blackBox]
    "<q>Den svarta lådan var ganska utmanande att dekonstruera,</q>
    säger du. <<location.nextMsg>> "
    name = 'den svarta lådan'
;

++ AskTellGiveShowTopic, SuggestedTellTopic [calculator]
    "<q>Kvantberäkningstricket är ganska fantastiskt,</q>
    säger du. <<location.nextMsg>> "
    name = 'räknaren'
;

++ DefaultAnyTopic
    "Du borde berätta för Brian om stacken först.<.convstay> "
    isConversational = nil

    deferToEntry(entry) { return !entry.ofKind(DefaultTopic); }
;

+ ConvNode 'stamer-omegatron'
    /* stay here until we explicitly move on */
    isSticky = true

    /* don't allow terminating the conversation just yet */
    canEndConversation(actor, reason)
    {
        "Du bör verkligen inte missa denna chans att sälja in Brian på
        Omegatron. ";
        return nil;
    }

    npcContinueMsg = "Brian frågar dig igen om Omegatron. "
;

++ TellTopic, SuggestedTellTopic @omegatronTopic
    name = 'Omegatron'
    topicResponse()
    {
        "<q>Jag jobbar för Omegatron,</q> säger du. Du börjar berätta
        för Brian om företaget, vad din grupp gör, vad du gör, vad
        Brian skulle kunna göra som nyanställd---din standardpresentation för kandidater.
        Halvvägs genom slår det dig att ditt hjärta inte riktigt är med i det;
        men du fortsätter ändå. <q>Så,</q> avslutar du, <q>det finns
        några fantastiska möjligheter, och vi skulle älska att ha dig ombord.</q>
        <.p>Stamer lyssnar och nickar. <q>Låter okej,</q> säger han, utan
        att låta särskilt entusiastisk.
        <.p><q>Ursäkta mig,</q> säger en röst bredvid dig. Du och
        Brian vänder er om och ser Belker stå där. <q>Mitt namn är Frosst
        Belker,</q> säger han till Brian. <q>Jag är från Mitachron Company.
        Du måste vara Brian Stamer---ett nöje att äntligen få träffa dig.</q>
        Han öppnar en väska han bär på och börjar ta ut saker och
        räcka dem till Brian: först en t-shirt, sedan en broschyr, sedan en
        gigantisk novelty-basebollkeps. <q>Vänligen acceptera dessa tecken på
        vår uppskattning.</q> Han håller upp basebollkepsen. <q>Den här artikeln,
        kanske den är fel storlek för dig. Vänligen, låt mig bedöma
        situationen, om du skulle vara så vänlig...</q>
        <.p>Belker försöker sätta kepsen på Brians huvud, men Brian
        duckar skickligt, tar kepsen från Belker och lägger den på skrivbordet
        tillsammans med de andra sakerna. <q>Det är okej,</q> säger han.
        <q>Jag provar den senare.</q>
        <.convnode stamer-hat> ";
        
        /* bring in belker */
        frosst.moveIntoForTravel(room4);
        frosst.setCurState(frosstRoom4);

        /* bring in the logo-wear */
        PresentLater.makePresentByKey('logo-wear');
    }
;

++ YesTopic
    "<q>Ja, jag jobbar för Omegatron,</q> säger du. Det här skulle vara ett bra
    tillfälle att berätta för honom om företaget.<.convstay> "
;
++ NoTopic
    "Du försöker komma på ett jobbar-hårt-knappt-jobbar-skämt, men
    inget bra kommer till dig. Du borde verkligen ta
    tillfället i akt att berätta för honom om Omegatron.<.convstay> "
;

+ ConvNode 'stamer-hat'
    isSticky = true

    canEndConversation(actor, reason)
    {
        "You can't very well walk out now. ";
        return nil;
    }

    /* Belker continues no matter what we do */
    npcContinueMsg() { nextMsg; }
    nextMsg()
    {
        "Belker ger dig ett tunt leende. <q>Innan du lägger för mycket
        energi på detaljerna i anställningsförhandlingarna,
        herr Mittling, har jag nyheter som kommer att vara av betydande intresse
        för dig. För några ögonblick sedan pratade jag med mitt företags huvudkontor,
        och jag gläds åt att meddela att Mitachron inledde ett fientligt
        övertagande av Omegatron tidigare idag.</q>  Han vänder sig till Brian.
        <q>Så, som ni ser, medan herr Mittling obestridligen segrade i
        stack-tävlingen, var han tekniskt sett redan anställd av
        Mitachron medan han gjorde det. Segern tillhör därför Mitachron.</q>
        Belker vänder sig tillbaka till dig med ett hånleende.   <q>Än en gång, herr Mittling,
        ser vi att hur än flitiga dina ansträngningar än är, så är det i 
        slutändan jag som segrar.   Och oroa er inte, herr Stamer; ni kan
        vara säker på att Mitachrons anställningsvillkoren kommer att bli ytterst förmånliga.</q>
        <.convnode stamer-frosst> ";
    }
;
++ DefaultAnyTopic
    topicResponse() { location.nextMsg; }
;
+ ConvNode 'stamer-frosst'
    /* stay here until we explicitly move on */
    isSticky = true

    canEndConversation(actor, reason)
    {
        "Du kan knappast lämna konversationen vid denna tidpunkt. ";
        return nil;
    }

    /* 
     *   Brian continues the conversation of his own volition if we say
     *   nothing 
     */
    npcContinueMsg() { nextMsg; }

    /* 
     *   the common next message - we'll use this whether Brian continues
     *   the conversation or we do 
     */
    nextMsg()
    {
        "<q>Jag ska tänka på ditt erbjudande,</q> säger Brian till Belker.
        Han vänder sig till dig. <q>Faktiskt finns det något annat jag ville
        prata med dig om. Några vänner och jag har satt ihop
        ett startup-företag, baserat på teknologin i mitt
        labb. Saken är den att vi behöver några personer med branscherfarenhet,
        för att hålla investerarna nöjda. Vi vill dock inte ha vem som helst.</q>
        Han kastar en sidoblick på Belker. <q>Det är
        den verkliga anledningen till att jag satte ihop den här stacken---jag tänkte att vem som helst
        som kunde lösa den måste vara ganska bra på teknik.
        Poängen är att jag skulle vilja anställa dig som vår VP för teknik.
        Intresserad?</q>
        <.convnode stamer-job> ";
    }
;
++ DefaultAnyTopic
    topicResponse()
    {
        "Du börjar prata, men Belker avbryter. <q>Snälla,
        herr Mittling, du måste lära dig din plats nu när du
        arbetar för mig. Jag pratar med herr Stamer just nu.</q>
        <.p>";

        location.nextMsg;
    }
;

+ ConvNode 'stamer-job'
    /* stay here until we explicitly move on */
    isSticky = true

    canEndConversation(actor, reason)
    {
        "Du bör berätta för Brian om du är intresserad
        av hans jobberbjudande eller inte. ";
        return nil;
    }

    npcContinueMsg = "Brian harklar sig. <q>Nå?</q> frågar han.
        <q>Är du intresserad av jobbet?</q> "
;

++ YesTopic
    topicResponse()
    {
        "Du är nästan på väg att säga nej av ren vana, av rädsla för det
        okända. Men när du tänker tillbaka på din dag, på alla nya
        och intressanta utmaningar, på all cool teknik
        som Stamer har arbetat med, inser du hur självbelåten
        du har blivit på Omegatron, och hur lite anledning du har
        att stanna. Och med detta Mitachron-övertagande vill du <i>verkligen</i>
        komma därifrån.
        <.p><q>Jag skulle älska det,</q> säger du, och överraskar dig själv lite.
        <.p><q>Toppen,</q> säger Brian. Ni skakar hand på affären.
        <.p><q>Nej!</q> skriker Belker. <q>Det här är inte möjligt.
        Herr Stamer, du gav försäkringar om att du skulle acceptera ett jobb
        hos vinnarens företag. Herr Mittling vann, och Mitachron
        är hans företag, därför måste du acceptera ett jobb på Mitachron.</q>
        <.convnode stamer-quit-mitachron> ";
    }
;

++ NoTopic
    topicResponse()
    {
        "Brians startup låter intressant, och det är ingen hemlighet att Omegatron
        inte är perfekt; men när allt kommer omkring är inget det. Det finns
        mycket som talar för att hålla fast vid en bra sak, bygga
        en karriär på ett företag. Mitachrons övertagande är lite av ett
        vildkort, men vem vet; det kunde faktiskt vara intressant att
        vara på den vinnande sidan för en gångs skull.
        <.p><q>Tack för erbjudandet,</q> säger du, <q>men jag tror jag
        stannar på Omegatron för tillfället.</q>
        <.p>Brian ser besviken ut. <q>Verkligen? Åh, nåja, jag antar att vi får
        hitta någon annan. Trevligt att träffas i alla fall.</q>
        <.p>Du och Brian skakar hand, och Brian vandrar iväg in i
        festen. Frosst jagar efter honom.
        <.p>Du stannar kvar en stund till, pratar och njuter av maten.
        Du uppdaterar dig med Xojo, som inte har något snällt att säga om
        Mitachron, och du springer på de flesta av studenterna som du har mött
        under dagen. Slutligen bärjar festen avta, och du beger dig tillbaka
        till flygplatsen.
        <.p>Du pratar med Brian på telefon några gånger under den kommande veckan
        eller så, och försöker övertala honom att ta jobbet på Omegatron, men det
        blir snart tydligt att hans startup redan växlar upp till en högre växel.
        Med Brian ur bilden verkar Mitachron
        tappa intresset för övertagandet av Omegatron, så saker återgår snart
        till tråkig men bekväm normalitet.
        <.p>Allt som allt var det ingen dålig resa. Du lyckades inte
        anställa Brian, men du gav det åtminstone ditt bästa försök. Och du
        känner dig väldigt nöjd med att ha löst stacken. ";

        /* award the points for at least trying to hire Brian */
        scoreMarker.awardPointsOnce();

        /* offer finishing options */
        finishGameMsg('DU HAR ÖVERLEVT DAY',
                      [finishOptionUndo, finishOptionFullScore,
                       finishOptionAfterword, finishOptionAmusing,
                       finishOptionCredits, finishOptionCopyright]);
    }

    scoreMarker: Achievement { +5
        "gjort ditt bästa försök att anställa Brian Stamer"

        /* 
         *   Don't count this in the game's maximum score.  This is an
         *   alternative achievement that we don't capture in the best
         *   winning solution, so it doesn't count in the highest possible
         *   score, which is only achieved in the best winning solution. 
         */
        maxPoints = 0
    }
;

+ ConvNode 'stamer-quit-mitachron'
    /* stay here until we explicitly move on */
    isSticky = true

    canEndConversation(actor, reason)
    {
        "Du har ingen avsikt att gå därifrån mitt i allt detta. ";
        return nil;
    }

    npcContinueMsg = "Brian tittar på Belker och sedan på dig. <q>Jag hoppas
        att du kommer att få mig ur det här,</q> säger han. "
    
    nextMsg()
    {
        "<q>Jag tror inte du förstår,</q> säger du till Belker.
        <q>Jag jobbar varken för Omegatron <i>eller</i> Mitachron längre.
        Jag jobbar för Brians företag nu.</q> Du vänder dig till Stamer.
        <q>Jag vet att Mitachron kommer att ge dig ett bra erbjudande, men du sa
        faktiskt att du skulle komma och jobba för vinnarens företag. Så, vad säger du?
        Vill du komma och jobba för mitt nya företag?</q>
        <.p><q>Ja, absolut,</q> säger Brian. <q>Jag skulle bli överlycklig. Ledsen,
        herr Belker, men ett avtal är ett avtal, och han vann faktiskt stacken.</q>
        <.p>Frosst står där och ser ut som om ånga är på väg att skjuta ut ur öronen på honom.
        Han börjar vifta vilt med armarna.
        <q>Nej! Nej, nej, nej! Det här är oacceptabelt!</q> Ett par
        Mitachron-tekniker kommer springande och försöker lugna ner honom,
        men det gör honom bara ännu mer rasande. <q>Ni tror att
        ni är så smarta, båda två.</q>  Fler tekniker har
        kommit över nu, och de har börjat dra bort honom genom
        folkmassan. <q>Du har inte hört det sista av  Frosst Belker,
        det kan jag lova dig.  Du ska få se...</q>  Hans röst His voice tonar bort 
        medan teknikerna drar bort
        honom.
        <.p>Under loppet av de nästkommande få veckorna, har Brians startup tagit form
        otroligt snabbt.  Vid skolårets slut, har du redan anställt tillräckligt 
        många personer för att fylla det nya kontorsutrymmet,
        inklusive Xojo, som visar sig ha stor erfarenhet
        av halvledarfabrikationsverksamhet. Du vet att du har mycket
        arbete framför dig, och mycket att lära, men du kan redan
        känna att det kommer att bli en fantastisk resa. ";

        /* award the points for reaching the best solution */
        scoreMarker.awardPointsOnce();

        /* offer finishing options */
        finishGameMsg('DU HAR LYCKATS',
                      [finishOptionUndo, finishOptionFullScore,
                       finishOptionAfterword, finishOptionAmusing,
                       finishOptionCredits, finishOptionCopyright]);
    }

    scoreMarker: Achievement { +5 "undkomma Belkers övertagandeförsök" }
;

//TODO: "säg till Belker att jag slutar"
++ SpecialTopic 'berätta för Belker att du slutar'
    ['säg','berätta','till','för','frosst','belker','att','jag','du','slutar']
    topicResponse() { location.nextMsg; }
;

++ SpecialTopic 'erbjud Brian ett jobb' ['erbjud','brian','stamer','ett','jobb']
    topicResponse() { location.nextMsg; }
;

++ DefaultAnyTopic
     "Du borde verkligen reda ut den här jobbsituationen först.<.convstay> "
    isConversational = nil

    deferToEntry(entry) { return !entry.ofKind(DefaultTopic); }
;

