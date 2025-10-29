#charset "utf-8"
/* 
 *   Copyright 2003, 2013 Michael J. Roberts
 *   
 *   Return to Ditch Day - Prologue.  This introductory sequence takes
 *   place away from campus - "somewhere in south Asia" - and gives us
 *   a chance to set up some of the characters and back-story.  
 */

#include <adv3.h>
#include <sv_se.h>


/* ------------------------------------------------------------------------ */
/*
 *   The plot event describing the time at the start of the game
 */
ClockEvent eventTime = [1, 10, 35];


/* ------------------------------------------------------------------------ */
/*
 *   Some generic topic items, for conversation
 */

/* omegatron (the player character's employer) */
omegatronTopic: Topic 'mitt omegatron/företag';

/* mitachron (the rival company) */
mitachronTopic: Topic 'mitachron';

/* phone call */
phoneCallTopic: Topic 'mobil:en+telefon+en/telefon:en+samtal+et';

/* elevators in general */
elevatorTopic: Topic 'hiss+en/elevator+n/lift+en';

/* some resume-related topics */
hiringFreezeTopic: Topic 'omegatron+s anställning^s+stopp+et';
kowtuan: Topic 'kowtuan teknisk+a institut+et/universitet+et/skola+n';
chipTechNo: Topic 'halvledare kemisk+a applikator
    chiptechno tillverkare+n*åtgärder+na operationer+na';

/* the power plant itself */
powerPlant6: Topic '6+e regering^skraftverk+et';

/* ------------------------------------------------------------------------ */
/*
 *   A special object for the power plant itself.  This object will exist
 *   everywhere in the plant, so that the plant can always be referred to
 *   while we're in it.  
 */
MultiInstance
    /* we're in all power plant rooms */
    initialLocationClass = PowerPlantRoom

    instanceObject: SecretFixture {
        '6+e regeringens kraftverk+et' 'Regeringens kraftverk #6'

        /* examine the plant by doing an ordinary "look" */
        dobjFor(Examine)
        {
            action() { replaceAction(Look); }
        }

        /* 
         *   reduce my likelihood slightly for disambiguation in all
         *   commands, so that if there's another object present that
         *   responds to the same vocabulary, we'll pick the other object -
         *   the other one is almost certainly more specific than this
         *   generic object 
         */
        dobjFor(All) { verify() { logicalRank(55, 'generic'); } }
    }
;

/* kraftverkets bakgrundsljud */
+ SimpleNoise
    desc = "De normala låga mullrande och industriella ljuden från
            ett kraftverk hörs konstant i bakgrunden. "
;

MultiInstance
    initialLocationClass = PowerPlantRoom
    instanceObject: Decoration { 'betong' 'betong'
        "I princip hela kraftverkets struktur är byggd av betong. "
    }
;

/* a simple marker class for our power plant rooms */
class PowerPlantRoom: Room;

/* dimmigt moln av insektsmedel */
deetCloud: Vaporous 'dimmig+a kraftfull+a giftig+a insektsspray+en/spray+en/medel/medlet/dimma+n/moln/molnet/ånga+n/bekämpningsmedel/bekämpningsmedlet'
    'moln av insektsmedel'
    "Den dimmiga ångan hänger i luften genom hela rummet. "
;
+ Odor
    isAmbient = true
    sourceDesc = "Det har en vidrig kemisk lukt. "
    hereWithSource = "En giftig dimma av insektsmedel fyller luften. "
;

/* tanken */
deetTank: Thing 'kraftfull+a resväskestor+a metall+iska insektsmedel medel medlet tank+en/insektstank+en/slang+en'
    'tank med insektsmedel'
    "Den är ungefär lika stor som en stor resväska och har en slang fäst vid sig. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Power Plant Control Room 
 */

/* group lister for Xojo and Guanmgon while standing in the doorway */
standingInDoorway: ListGroupPrefixSuffix
    groupPrefix = "\^"
    groupSuffix = " står i dörröppningen och tittar på medan du arbetar. "
    createGroupSublister(parentLister) { return plainActorLister; }
;

/* 
 *   The control room itself. 
 */
powerControl: PowerPlantRoom 'Kontrollrum' 'kontrollrummet'
    "Det här är det trånga kontrollrummet i Statligt Kraftverk #6.
    Redan innan du kom hit var detta rum så proppfullt med utrustning
    att det knappt gick att vända sig om. Nu efter du har klämt in den
    kylskåpsstora SCU-1100 DX:en, finns det ungefär lika mycket utrymme
    kvar som i det där <q>budgetekonomiklass</q>-sätet du var fastkilad i, under
    den femton timmar långa flygresan hit. Den enda utgången är västerut. "

    vocabWords = 'kontrollrum+met'

    /* going west takes us to the power control hallway */
    west = powerControlDoorway
    out asExit(west)

    /* some atmospheric messages */
    atmosphereList: ShuffledEventList {
        [
            'Du märker att en mygga landar på din arm och lyckas slå ihjäl 
            den innan den hinner bita. ',
            'Du känner något på din nacke och inser för sent att
            det är en mygga som just flyger iväg. ',
            'En mygga surrar förbi bara centimeter från ditt öra. ',
            'Flera av dina myggbett börjar klia. ',
            'En mygga flyger långsamt förbi ditt huvud. ',
            'Luftfuktigheten blir tydligt sämre. ',
            'Ett avlägset knarrande ljud ekar genom byggnaden. '
        ]
        eventPercent = 80
        eventReduceAfter = 20
        eventReduceTo = 25
    }
;

/* 
 *   The doorway.  This is a Fixture, which means that it's a permanent
 *   part of the room (so it can't be taken or moved, for example), and
 *   it's a ThroughPassage, which means that it connects this location to
 *   another location for actor travel.  
 */
+ powerControlDoorway: Fixture, ThroughPassage
    'väst+ra v dörr+öppning+en' 'dörröppning'
    "Det är bara en dörröppning utan dörr som leder västerut. "

    /*
     *   Tillåt inte spelaren att gå denna väg förrän SCU-1100DX är
     *   reparerad.
     */
    canTravelerPass(travler) { return scu1100dx.isOn; }
    explainTravelBarrier(traveler)
    {    
       "Du kan helt enkelt inte lämna rummet förrän du får SCU-1100DX att fungera. ";
    }

    dobjFor(StandOn)
    {
        verify() { }
        action() { mainReport('Det finns ingen anledning att göra det. '); }
    }
;

/*
 *   our first assistant
 */
+ xojo: TourGuide, Person 'xojo/man+nen/byråkrat+en*män+nen' 'Xojo'
    "Han är en lågnivåbyråkrat som har fått i uppdrag att hjälpa dig med 
    installationen av SCU-1100DX. Han ser ung ut, kanske i mitten av 
    tjugoårsåldern. Han är lite längre än dig och mycket smal."

    isProperName = true
    isHim = true

    checkTakeFromInventory(actor, obj)
    {
        /* allow taking the resume; for others, use default handling */
        if (obj != xojoResume)
            inherited(actor, obj);
    }

    /* begin an errand */
    beginErrand(state)
    {
        /* remove us from power control */
        trackAndDisappear(xojo, powerControl.west);

        /* transition to the errand state */
        setCurState(state);

        /* show the message */
        state.beginErrand();
    }

    /* 
     *   End an errand.  This can be called to cause us to return from an
     *   errand immediately.  The errand state objects will automatically
     *   call this after enough turns have elapsed. 
     */
    endErrand()
    {
        local st = curState;
        
        /* if we're not in an errand state, ignore it */
        if (!st.ofKind(XojoErrandState))
            return;
        
        /* return us to power control */
        moveIntoForTravel(powerControl);

        /* return to the our main state */
        setCurState(xojoInit);

        /* let the errand state describe our return */
        "<.p>";
        st.endErrand();
        "<.p>";
    }

    dobjFor(Climb)
    {
        verify()
        {
            /* Xojo is certainly not the most obvious thing to climb */
            nonObvious;
        }
        action()
        {
            if (gActor.location == plantElevator && plantElevator.isAtBottom)
            {
                /* 
                 *   we're stuck in the elevator; we can use Xojo's help to
                 *   reach the escape hatch 
                 */
                "<q>Skulle du kunna försöka lyfta mig?</q> frågar du.
                <.p><q>Absolut,</q> säger Xojo. ";
                
                boostPlayerChar();
            }
            else if (gActor.isIn(xojoBoost))
                "Det ser inte ut som Xojo kan lyfta dig högre än så här. ";
            else
                "Xojo skulle troligen inte gilla det. ";
        }
    }
    dobjFor(ClimbUp) asDobjFor(Climb)
    dobjFor(StandOn) asDobjFor(Climb)
    dobjFor(SitOn) asDobjFor(Climb)
    dobjFor(Board) asDobjFor(Climb)

    /* observe the player trying to climb something in the elevator */
    observeClimb(obj)
    {
        if (plantElevator.isAtBottom)
        {
            if (boostCount == 0)
                "<.p>Xojo tittar på vad du gör. <q>Jag tror att
                <<obj.theName>> är för svår att klättra på,</q> säger han.
                <q>Men jag skulle kunna lyfta dig. Vill du att jag
                försöker?</q> ";
            else
                "<.p><q>Skulle du kanske vilja att jag lyfter dig
                en gång till?</q> frågar Xojo. ";
            
            xojo.initiateConversation(nil, 'offer-boost');
        }
    }

    /* give the player a boost (in the elevator) */
    boostPlayerChar()
    {
        /* beskriv det */
        "Xojo böjer sig ner för att låta dig klättra upp på hans axlar,
        vilket du lyckas med efter lite krångel, sedan reser han sig
        skakigt upp. Nu når du enkelt upp till taket. ";

        /* om detta är första gången, lägg till något extra */
        if (boostCount++ == 0)
            "<.p><q>Jag hoppas du märker vilken initiativrik anställd
            jag skulle vara,</q> säger Xojo, något ansträngd av din vikt. ";

        /* move me to the special secret "boosted by xojo" location */
        me.moveIntoForTravel(xojoBoost);

        /* xojo has a special state for this situation */
        xojo.setCurState(xojoElevatorBoosting);
    }
    boostCount = 0

    dobjFor(GetOffOf) maybeRemapTo(gActor.isIn(xojoBoost),
                                   GetOffOf, xojoBoost);
;

++ xojoResume: PresentLater, Readable
    'cirriculum meritförteckning+en/resume+n/r\u00E9sum\u00E9/cv/c.v./vitae/papper+et/pappret*meriter+na'
    'r\u00E9sum\u00E9'
    "Formatet är lite ovanligt, förmodligen på grund av lokala
    konventioner, men du har inga större problem att hitta den viktiga
    informationen om Xojos professionella meriter:
    en kandidatexamen i elektroteknik
    från Kowtuan Tekniska Institut; ett år i en ingångsposition
    hos en halvledartillverkare som heter ChipTechNo;
    och två år här på Statligt Kraftverk #6, där han avancerat från
    Junior Teknisk Administrativ Rang 3 till Junior Administrativ
    Teknisk Rang 7. "

    /* it's xojo's, no matter where it's located */
    owner = xojo

    /* take the resume before reading or examining it */
    dobjFor(Read) { preCond = (inherited() + [objHeld]) }
    dobjFor(Examine) { preCond = (inherited() + [objHeld]) }
;

++ AskTellTopic @magnxi
    "<q>Vad kan du berätta om Översten?</q> frågar du.
    <.p><q>Jag för dig till henne nu,</q> svarar han. "

    /* this is active as soon as we're on our way to see the colonel */
    isActive = (scu1100dx.isOn)
;

++ GiveTopic @xojoResume
    "Du försöker ge tillbaka CV:t till Xojo, men han bara viftar med
    händerna. <q>Snälla,</q> säger han, <q>behåll det för ditt 
    framtida övervägande.</q> "
;

++ DefaultCommandTopic
    "Xojo avböjer artigt och säger att hans rang är för låg för
    att kunna hjälpa till på det sättet. "

    isConversational = nil
;

++ AskTellTopic @xojo
    "<q>Berätta något om dig själv,</q> säger du.
    <.p><q>Jag är här för att hjälpa dig,</q> svarar Xojo. "
;

++ AskTellShowTopic +90 @guanmgon
    "<q>Berätta något om Guanmgon,</q> säger du.
    <.p>Xojo pausar ett ögonblick. <q>Han är väldigt kvalificerad att
    hjälpa dig,</q> säger han till slut. "
;

++ HelloTopic
    "<q>Hur kan jag hjälpa till?</q> frågar Xojo. "
;

++ DefaultAnyTopic, ShuffledEventList
    ['<q>Min överordnade, Guanmgon, skulle vara bättre kvalificerad än
    jag att hjälpa dig i denna fråga,</q> säger Xojo. ',
    '<q>Jag måste överlåta sådana frågor till mina överordnade,</q> säger Xojo. ',
    'Xojo tänker ett ögonblick. <q>Du kanske borde rådfråga min överordnade,
    Guanmgon,</q> säger han. '
    ]

    /* använd inte en underförstådd hälsning med detta ämne */
    impliesGreeting = nil
;

++ AskTellTopic @contract
    "Du vet med säkerhet att Xojo är alldeles för långt ner i byråkratin för att
    ha något med kontrakt att göra. "

    /* vi är inte konversationella, så använd inte en hälsning */
    isConversational = nil
;

++ GiveShowTopic @contract
    "Det finns ingen mening med att göra det; Xojo är ungefär fyrtiofem
    byråkratinivåer för låg för att ha något med kontrakt att göra. "

    isConversational = nil
;

/* när man frågar om SCU:n, ändra svaret när vi har fixat den */
++ GiveShowTopic @scu1100dx
    "Du har inget att visa honom förrän du får den att fungera. "

    isConversational = nil
;
+++ AltTopic
    "Du skulle gärna ge Xojo en full demonstration, men du borde verkligen gå
    och träffa Överste Magnxi på en gång. "

    isActive = (scu1100dx.isWorking && scu1100dx.isOn)
    isConversational = nil
;

++ GiveShowTopic [ct22, s901, xt772hv, tester, testerProbe, xt772lv]
    "Du är säker på att han verkligen skulle vilja hjälpa till, men det har blivit tydligt att
    all bisarr byråkrati här hindrar Xojo från att faktiskt göra
    något som ens skulle likna reparationsarbete. "

    isConversational = nil
;

++ AskTellShowTopic, SuggestedAskTopic [helicopter1, helicopter5]
    "<q>Vet du något om de där helikoptrarna?</q> frågar du.
    <.p><q>Jag är inte säker,</q> säger han, <q>men min överordnade, Guanmgon,
    antydde att en representant från Mitachron skulle
    närma sig. Kanske representanten utför ankomst.</q> "

    isActive = (helicopter1.seen)

    /* förslagsnamn */
    name = 'helikoptrarna'
;

/* 
 *   repbron - börja med det generiska svaret, definiera sedan några
 *   specifika svar för att fråga om den på olika platser 
 */
++ AskTellShowTopic [platformBridge]
    "<q>Jag vill verkligen inte gå över den där repbron,</q> säger du.
    <.p><q>Det är vår mest effektiva väg,</q> säger
    Xojo, <q>men kanske kunde vi vänta på reparationen av
    hissen, om du föredrar det.</q> "
;

/* Repbro-svar för när vi är på plattformen */
+++ AltTopic, StopEventList
    ['<q>Är du seriös?</q> frågar du. <q>Vill du verkligen gå över
    repbron?</q>
    <.p><q>Jag beklagar,</q> säger han, <q>men det är den mest effektiva vägen.
    Den enda möjligheten till ett alternativ är att invänta färdigställandet av
    reparationerna på hissen.</q> ',
    '<q>Varför finns den ens här?</q> frågar du skeptiskt.
    <.p><q>Peon-gradspersonalen får normalt sett inte lämna
    källarvåningarna under arbetstid,</q> säger Xojo.
    <q>En grupp sub-peoner byggde detta i hemlighet, för att möjliggöra avfärd
    och senare återkomst utan upptäckt av överordnade funktionärer.</q> ',
    '<q>Den här bron ser inte särskilt säker ut,</q> säger du.
    <.p><q>Jag har använt den personligen, under min egen Peon-gradsperiod
    av anställning,</q> försäkrar Xojo dig. <q>Använd bara försiktighet för att göra
    överfarten relativt fri från överdriven fara.</q> ',
    '<q>Är du verkligen säker på att det här är den enda vägen över?</q> frågar du.
    <.p><q>Jag är tyvärr tvungen att svara jakande,</q>
    säger Xojo. ']

    isActive = (xojo.isIn(s2Platform))
;

/* Repbro-svar för när vi börjar korsa bron */
+++ AltTopic
    "<q>Är du verkligen säker på att den är säker?</q> frågar du.
    <.p><q>Jag har gått över den flera gånger,</q> säger han. <q>Snälla,
    vi borde skynda oss.</q> "

    isActive = (xojo.isIn(ropeBridge1) || xojo.isIn(ropeBridge2))
;

/* Repbro-svar efter att bron kollapsar */
+++ AltTopic
    "<q>Du sa att den var säker!</q> skriker du.
    <.p><q>Förlåt,</q> säger Xojo. <q>Det här har bara hänt en
    eller två gånger förut. Kom, vi kan klättra upp härifrån.</q> "

    isActive = (xojo.isIn(ropeBridge3))
;

/* Repbro-svar när vi är förbi den */
+++ AltTopic
    "<q>Jag kan fortfarande inte fatta att du fick mig att gå över den där
    repbron,</q> säger du.
    <.p><q>Medges, faronivån var inte noll,</q> säger Xojo. "

    isActive = (me.hasSeen(canyonNorth))
;

/* in-conversation state for xojo */
++ InConversationState
    stateDesc = "Han väntar vaksamt. "
    specialDescListWith = [standingInDoorway]
    attentionSpan = nil
;

/* initial state - waiting for repairs to the SCU */
+++ xojoInit: ConversationReadyState
    isInitState = true
    specialDesc = "Xojo står och tittar på dig från dörröppningen. "
    specialDescListWith = [standingInDoorway]
    stateDesc = "Han har iakttagit dig uppmärksamt. "
;
++++ HelloTopic, ShuffledEventList
    ['Du tittar bort mot Xojo. <q>Ursäkta...</q>
    <.p><q>Hur kan jag hjälpa till?</q> ',
     'Ni får ögonkontakt. <q>Ja?</q> frågar han.<.p>',
     '<q>Xojo?</q>
     <.p><q>Vad kan jag göra för att hjälpa?</q> ']
;
++++ ByeTopic "<q>Tack,</q> säger du. Xojo nickar. "
;
++++ ImpByeTopic ""
;

/* a state class for when xojo is running an errand */
class XojoErrandState: ActorState
    takeTurn()
    {
        /* if we've been gone long enough, return */
        ++turnCount;
        if (turnCount > turnsNeeded)
            xojo.endErrand();
    }

    activateState(actor, oldState)
    {
        /* inherit the default handling */
        inherited(actor, oldState);

        /* reset our counter of turns in this state */
        turnCount = 0;
    }

    /* the number of turns we've been gone */
    turnCount = 0

    /* the expected number of turns for the errand */
    turnsNeeded = 2
;

/* fetching Koffee */
++ koffeeErrand: XojoErrandState
    beginErrand()
    {
        "<q>Xojo! Hämta lite Koffee till herr Mittling. Skynda dig!</q>
        Xojo rusar ut genom dörren. ";

        /* we're done with the agenda item for the koffee */
        guanmgon.removeFromAgenda(koffeeAgenda);
    }
    endErrand()
    {
        "Xojo kommer tillbaka med en burk Koffee och klämmer sig
        in i rummet tillräckligt länge för att räcka den till dig. ";
        koffee.moveInto(me);
    }
;

/* fetching Deet */
++ deetErrand: XojoErrandState
    beginErrand()
    {
        "<q>Myggorna måste vara irriterande för dig,</q> säger Guanmgon.
        <q>Xojo!</q> ropar han. <q>Hämta kraftfullt insektsmedel! 
        Gå nu!</q> Xojo går iväg muttrande något. ";

        /* we're done with the dispatching agenda item */
        guanmgon.removeFromAgenda(deetAgenda);
    }
    endErrand()
    {
        "Xojo kommer tillbaka, släpande på en resväskestor metalltank med 
        en slang fastsatt. Han vrider på en ventil på tanken och riktar 
        slangen in i rummet. En dimmig spray kommer ut ur slangen och 
        rummet fylls snabbt med ett giftigt moln.
        <.p>Myggorna fortsätter oberörda med sina bestyr. ";

        /* add the tank and deet cloud */
        deetTank.moveInto(xojo);
        deetCloud.moveInto(powerControl);

        /* add the agenda item for returning the tank */
        guanmgon.addToAgenda(tankReturnAgenda);
    }
;

++ tankReturnErrand: XojoErrandState
    beginErrand()
    {
        /* get rid of the deet tank */
        deetTank.moveInto(nil);

        /* this agenda item is finished now */
        guanmgon.removeFromAgenda(tankReturnAgenda);
    }
    endErrand = "Xojo kommer tillbaka och ställer sig bredvid Guanmgon i dörröppningen. "
;

++ koffee: Food
    'koffee brand business (man\'s) aluminum+burk+en 340-gram 340 gram
    dryck+n/beverage/koffee+t/kaffe+t/burk+en'
    'burk med Koffee'

    "Ja, det är Koffee med K: Koffee brand Business Man's Beverage,
    det 100% oorganiska valet, förpackat i en 33 cl aluminiumburk.
    Det verkar som att du stöter på denna hemska företagsprodukt från ToxiCola 
    varje gång du besöker en kund utanför USA. "

    dobjFor(Taste) asDobjFor(Eat)
    dobjFor(Drink) asDobjFor(Eat)
    dobjFor(Eat) { action() { "Du vill inte att Xojo ska känna sig sårad,
        så du lyckas svälja lite. Det är lika hemskt som vanligt. "; }}

    smellDesc = "Den har en stark kemisk lukt, även om inget
        du kan placera exakt; thinner blandat med klor,
        kanske, med bara en antydan av 3-metoxi-4-hydroxibensaldehyd. "

    dobjFor(Pour)
    {
        preCond = [objHeld]
        verify() { }
        action() { "Det skulle bli en röra. "; }
    }
    dobjFor(PourInto) asDobjFor(Pour)
    dobjFor(PourOnto) asDobjFor(Pour)

    iobjFor(PutIn)
    {
        verify() { }
        check()
        {
            if (gDobj == xt772hv)
                "Det skulle vara ett intressant experiment, men den giftiga
                vätskan skulle förmodligen bara lösa upp chipet, och det är
                fortfarande möjligt att du kommer behöva det till något. ";
            else
                "Bäst att låta bli; vem vet vad den giftiga vätskan skulle
                göra med {det dobj/honom} där. ";
            exit;
        }
    }

    cannotOpenMsg = 'Det behövs inte; Xojo har redan öppnat den åt dig. '

    /* we know about it from the start */
    isKnown = true

    /* 
     *   we're not actually part of the state tree - we just want to
     *   define ourselves here for convenience 
     */
    location = nil
;

/* a special "escort" state class, for our trip to see the colonel */
class XojoEscortState: GuidedTourState
    stateDesc = "Han väntar på att du ska följa med honom. "
    showGreeting(actor) { "Du har redan Xojos uppmärksamhet. "; }

    justFollowed(success)
    {
        local st;
        
        /* 
         *   if they made us follow them, it means they're not going where
         *   we're trying to guide them; let them know 
         */
        "Han ser lite otålig ut. <q>Varsågod, den här vägen.</q> ";

        /* make sure we're in the right state for the new location */
        st = instanceWhich(XojoEscortState, {x: x.stateLoc == xojo.location});
        if (st != nil)
            xojo.setCurState(st);
    }
;

/* waiting in the control room to escort us to the colonel */
++ xojoEscortControl: XojoEscortState
    stateLoc = powerControl

    stateDesc = "Han väntar på att följa med honom genom dörröppningen. "
    specialDesc = "Xojo väntar på att följa med honom genom dörröppningen. "
    escortDest = (powerControl.west)
    stateAfterEscort = xojoHallEast
;

/* waiting at the east end of the hallway to escort us */
++ xojoHallEast: XojoEscortState
    stateLoc = powerHallEast

    arrivingWithDesc = "Xojo sträcker ut handen för att indikera den bortre
                        änden av korridoren och väntar på att du ska fortsätta gå. "
    stateDesc = "Han väntar på att du ska följa med honom ner för korridoren
                 västerut. "
    specialDesc = "Xojo väntar på att du ska följa honom ner för
                   korridoren västerut. "
    escortDest = (powerHallEast.west)
    stateAfterEscort = xojoHallWest
;

/* waiting at west end of hallway to escort us */
++ xojoHallWest: XojoEscortState
    stateLoc = powerHallWest

    arrivingWithDesc = ""
    arrivingTurn()
    {
        if (plantElevator.isOnCall)
            "Xojo stannar och väntar på hissen med dig. ";
        else if (plantElevator.isAtTop)
        {
            "Xojo drar upp hissdörren och skjuter undan
            gallret, och väntar på att du ska gå in. ";
            
            plantElevatorGate.makeOpen(true);
        }
        else
        {
            /* the elevator hasn't even been called yet - call it */
            "Xojo sträcker ut handen och trycker på hissens anropsknapp.
            Neonlampan ovanför knappen lyser svagt. ";
            
            plantElevator.callToTop();
        }
    }
    stateDesc()
    {
        if (plantElevatorGate.isOpen)
            "Han väntar på att du ska gå in i hissen. ";
        else
            "Han väntar med dig på att hissen ska anlända. ";
    }
    specialDesc()
    {
        if (plantElevator.isAtTop)
            "Xojo är här och håller hissdörren öppen för dig. ";
        else
            "Xojo är här och väntar med dig på hissen. ";
    }
    escortDest = (plantElevatorGate.isOpen ? powerHallWest.west : nil)
    stateAfterEscort = xojoElevator
;
+++ AskTellShowTopic @plantHallElevatorDoor 'trapp(a|or)?' // TODO: testa
    "<q>Kan vi inte ta trapporna istället?</q> frågar du, orolig
    över tiden.
    <.p>Xojo skrattar nervöst. <q>Trappor, nej,</q> säger han. <q>Av brandsäkerhetsskäl
    finns endast hissen tillgänglig i denna sektor.</q> "
;

++ xojoElevator: InConversationState
    arrivingWithDesc = ""
    arrivingTurn()
    {
        /* 
         *   if the elevator isn't at the top, we must have re-entered the
         *   elevator through the service panel; don't repeat this
         *   conversation (and the elevator descent) in this case
         */
        if (!plantElevator.isAtTop)
            return;

        "Xojo låter dörren svänga igen och stänger gallret, sedan
        trycker han på <q>G</q>-knappen. Hissen skakar till och börjar
        långsamt sjunka. ";

        /* kick off Xojo's resume offer after we get going */
        xojo.scheduleInitiateConversation(nil, 'xojo-resume', 1);

        /* close the door and start the descent */
        plantElevatorGate.makeOpen(nil);
        plantElevator.startDescent();
    }

    /* we have no limit on our attention span */
    attentionSpan = nil

    /* just stay in this state at end of conversation */
    nextState = self
;
+++ AskTellShowTopic @powerElevPanel
    "<q>Är det en servicepanel där uppe?</q> frågar du.
    <.p><q>Att besvara sådana frågor ligger inte inom ramen
    för mina ansvarsområden,</q> säger Xojo. <q>Vår mycket fina avdelning
    för vertikal transport har befäl över sådana frågor.</q> "
;
++++ AltTopic
    "Du pekar på servicepanelen. <q>Tror du att vi skulle kunna ta
    oss ut genom den där panelen?</q>
    <.p>Xojo tittar på den uppskattande. <q>Kanske, men höjden är
    för hög för att jag ska nå den. Kanske jag skulle kunna lyfta dig, och
    du skulle kunna försöka nå. Ska vi prova?</q><.convnode offer-boost> "

    isActive = (plantElevator.isAtBottom)
;
++++ AltTopic
    "<q>Jag behöver komma upp till servicepanelen igen,</q> säger du.
    <.p><q>Vill du att jag ska lyfta dig igen?</q> frågar Xojo.
    <.convnode offer-boost> "

    isActive = (xojo.boostCount != 0)
;
++++ AltTopic
    "<q>Tack för din hjälp med servicepanelen,</q> säger du.
    <.p><q>Det är en plikt och ett nöje att hjälpa till,</q> säger han. "

    isActive = (me.isIn(atopPlantElevator))
;

++ xojoElevatorBoosting: InConversationState
    stateDesc = "Han håller dig på sina axlar. "
    specialDesc = "Xojo håller dig på sina axlar. "
    attentionSpan = nil

    afterAction()
    {
        /* if the PC is back in the elevator, go back to the elevator state */
        if (gPlayerChar.location == plantElevator)
            xojo.setCurState(xojoElevator);
    }
;

++ ConvNode 'offer-boost';
+++ YesTopic
    topicResponse()
    {
        "<q>Okej,</q> säger du, <q>låt oss prova.</q> ";
        xojo.boostPlayerChar();
    }
;
+++ NoTopic
    "<q>Nej tack,</q> säger du. <q>Jag ska försöka komma på något annat.</q> "
;

/* fråga om hissen när den är trasig */
++ AskTellShowTopic @elevatorTopic
    "<q>Vad är det för fel på hissen?</q> frågar du.
    <.p><q>Hissen är ibland felaktig i att stanna som begärt,</q>
    svarar Xojo. <q>Men ingen anledning till oro. Den stannar pålitligt, med tiden.</q> "

    isActive = (plantElevator.curFloor <= 2)
;
+++ AltTopic, SuggestedAskTopic, StopEventList
    ['<q>Hur kan vi ta oss ut härifrån?</q> frågar du.
    <.p><q>Ja, vår anläggnings mycket effektiva avdelning för vertikal
    transport kommer snart att observera vårt missöde, för att sedan meddela
    kontoret för hissräddning. Många gånger förr när jag har varit
    liknande instängd i hissarna, svarade avdelningen inom bara några
    timmar, i typiska fall.</q> ',

    '<q>Är du säker på att vi inte kan hitta en väg ut härifrån?</q> frågar du, i hopp om
    att slippa vänta på hjälp---du har definitivt inte råd med de <q>flera
    timmar</q> som Xojo sa att det kunde ta.
    <.p>Xojo skakar på huvudet. <q>Standardproceduren för sådana
    hissmissöden är att vänta på räddning.</q> ']

    isActive = (plantElevator.isAtBottom)
    name = 'hissen'
;
+++ AltTopic
    "<q>Jag är glad att vi kunde ta oss ut ur den där hissen,</q> säger du.
    <.p><q>Ja, din uttagningsplan var mycket väl uttänkt
    och genomförd,</q> säger Xojo. "
    isActive = (plantElevator.isAtBottom && me.hasSeen(atopPlantElevator))
;

++ ConvNode 'xojo-resume'
    npcGreetingMsg()
    {
        "Xojo harklar sig. <q>Jag undrar,</q> säger han,
        <q>om ert fina företag skulle kunna överväga mig för en
        anställning.</q> Han tar fram ett papper och håller
        fram det till dig. <q>Mitt CV,</q> säger han. <q>Jag
        skulle mycket uppskatta ert vänliga övervägande.</q>
        <.topics><.reveal xojo-job> ";

        xojoResume.makePresent();
    }

    npcContinueList: StopEventList {
        ['<q>Om något är oklart i mitt CV,</q>
         säger Xojo, <q>skulle jag gärna förtydliga.</q> ',
         '',
         '<q>Jag skulle uppskatta möjligheten att bli övervägd
         för möjligheter hos ert underbara företag,</q> säger Xojo. ',

         '',
         'Xojo tittar förväntansfullt på dig. ',
         'Xojo iakttar dig förväntansfullt. '
        ]
    }
;

++ AskTellShowTopic +90 @xojoResume
    "<q>Detta är ditt CV?</q> frågar du.
    <.p><q>Ja,</q> säger Xojo, <q>låt mig förtydliga alla
    frågor du undrar över.</q> "
    isActive = (xojoResume.isIn(xojo))
;

++ TopicGroup
    isActive = (xojoResume.described)
;
+++ AskTellShowTopic, StopEventList @xojoResume
    ['<q>Det här ser mycket bra ut,</q> säger du. <q>Är det något mer
     du ville nämna om det?</q>
     <.p><q>Ja, kanske det är användbart att veta att min rang, rang 7,
     anses avancerad för en anställd med min anställningstid.</q> ',
     
     '<q>Är det något annat om ditt CV som du ville
     tillägga?</q> frågar du.
     <.p><q>Tack,</q> svarar han, <q>men jag tror det är
     heltäckande.</q> ']
;
+++ AskTellTopic, SuggestedAskTopic, StopEventList @kowtuan
    ['<q>Ursäkta,</q> säger du, <q>men jag har inte hört talas om ditt
    universitet förut. Är det en bra skola?</q>
    <.p><q>Oh, ja,</q> säger Xojo ivrigt, nickande snabbt.
    <q>Det är ofta känt som <q>MIT</q> i tre-provinsregionen.
    Programmet är mycket rigoröst.</q> ',

    '<q>Finns det något mer om ditt universitet du kan berätta för mig?</q>
    <.p>Xojo svarar, <q>Programmet anses vara mycket utmärkt.</q> ']

    name = 'Kowtuan Tekniska Institut'
;
+++ AskTellTopic, SuggestedAskTopic, StopEventList @chipTechNo
    ['<q>Berätta om ditt jobb på ChipTechNo,</q> säger du.
     <.p><q>Det var en utmärkt läroerfarenhet,</q> säger han,
     <q>men befordringsmöjligheterna var begränsade på grund av icke-lokalt ägande.</q> ',

     '<q>Vad gjorde du på ChipTechNo?</q> frågar du honom.
     <.p><q>Mina huvudsakliga uppgifter var inom kemiska appliceringsoperationer,</q> 
     säger han. <q>Men detta var endast efter betydande träning och lärlingstid, naturligtvis.</q> ',

     '<q>Finns det något mer om ChipTechNo du kan berätta för mig?</q>
     frågar du.
     <.p><q>Jag tror du har huvudfakta nu,</q> säger han. '
    ]

    name = 'ChipTechNo'
;
+++ AskTellTopic, SuggestedAskTopic, StopEventList @powerPlant6
    ['<q>Varför vill du lämna ditt jobb här på kraftverket?</q> frågar du.
    <.p><q>Som du säkert har observerat,</q> säger han, <q>är mina uppgifter
    betydligt varierande, efter mina mycket kapabla överordnades nycker.
    Detta har gett många utmärkta möjligheter till frustration.</q> ',

    '<q>Berätta mer om ditt jobb på kraftverket,</q> säger du.
    <.p><q>Jag känner att mina utvecklingsmöjligheter på Statliga
    Kraftverket är begränsade,</q> säger han. <q>Jag skulle hoppas på att hitta en
    möjlighet som är mer robust.</q> ',

    '<q>Du är inte nöjd med ditt jobb på kraftverket?</q> frågar du.
    <.p><q>Min lycka är kanske mindre här än den skulle kunna vara någon annanstans,</q>
    säger han. ']

    name = 'kraftverket'
;
+++ AskTellTopic, SuggestedAskTopic, StopEventList @guanmgon
    ['<q>Guanmgon verkar hålla dig sysselsatt,</q> säger du.
    <.p><q>Ja,</q> säger Xojo, och ser lite frånvarande ut för ett ögonblick.
    <q>Han är mycket kapabel på att tillhandahålla många små uppgifter av
    betydande vikt för honom själv.</q> ',

    '<q>Är Guanmgon en bra chef?</q> frågar du.
    <.p><q>Han är utan tvekan tilldelad rollen som chef,</q>
    svarar Xojo. ']

    name = 'Guanmgon'
;

++ TellTopic, SuggestedTellTopic, StopEventList @hiringFreezeTopic
    ['<q>Tråkigt nog är det tyvärr anställningsstopp på Omegatron
    just nu,</q> förklarar du. <q>Det betyder att vi inte kan anställa någon.</q>
    <.p>Xojo kan inte riktigt dölja sin besvikelse. <q>Åh. Tja,
    kanske i framtiden då.</q> Du rycker lätt på axlarna och
    nickar oengagerat. ',

    '<q>Ledsen för anställningsstoppet,</q> säger du.
    <.p><q>Åh, det är inte ditt fel,</q> säger Xojo. <q>Ändå är
    det olyckligt.</q> ']

    name = 'Omegatrons anställningsstopp'
    isActive = gRevealed('xojo-job')
;

/* väntar vid östra änden av korridoren för att eskortera oss */
++ xojoS2West: XojoEscortState
    stateLoc = s2HallWest

    arrivingWithDesc = "Xojo pekar ner i korridoren. "
    stateDesc = "Han väntar på att du ska följa med honom ner i korridoren
                 österut. "
    specialDesc = "Xojo väntar på att du ska följa honom ner i
                   korridoren österut. "
    escortDest = (s2HallWest.east)
    stateAfterEscort = xojoS2East
;

++ xojoS2East: XojoEscortState
    stateLoc = s2HallEast
    arrivingWithDesc()
    {
        /* open the door if it's not already */
        if (s2HallEastDoor.isOpen)
            "Xojo pekar på dörren. <q>Den här vägen,</q> säger han. ";
        else
        {
            s2HallEastDoor.makeOpen(true);
            "Xojo öppnar dörren. <q>Den här vägen, tack,</q> säger han
            och pekar på dörren. ";
        }
    }
    stateDesc = "Han väntar på att du ska följa med honom genom
                 dörren. "
    specialDesc = "Xojo väntar på att du ska följa med honom genom
                   dörren. "
    escortDest = (s2HallEast.north)
    stateAfterEscort = xojoS2Storage
;

++ xojoS2Storage: XojoEscortState
    stateLoc = s2Storage
    arrivingWithDesc = "<q>Röran är formidabel,</q> säger Xojo,
                        <q>men vägen norrut är framkomlig.</q> "
    stateDesc = "Han väntar på att du ska följa med honom genom
                 skräpet norrut. "
    specialDesc = "Xojo väntar på att du ska följa med honom genom
                   skräpet norrut. "
    escortDest = (s2Storage.north)
    stateAfterEscort = xojoS2Utility
;

++ xojoS2Utility: XojoEscortState
    stateLoc = s2Utility
    arrivingWithDesc = "Xojo pekar på öppningen. <q>Jag ber om ursäkt,
                        men detta är vägen att fortsätta,</q> säger
                        han. "
    stateDesc = "Han väntar på att du ska gå genom öppningen
                 i väggen. "
    specialDesc = "Xojo står vid öppningen i väggen och väntar på
                   att du ska gå igenom. "
    escortDest = (s2Utility.north)
    stateAfterEscort = xojoS2Platform
;

++ xojoS2Platform: XojoEscortState
    stateLoc = s2Platform
    arrivingWithDesc = "<q>Ursäkta igen,</q> säger Xojo och
         pekar på repbron. <q>Den är relativt säker,
         i motsats till vad det ser ut som.</q> "
    stateDesc = "Han väntar vid repbron på dig. "
    specialDesc = "Xojo väntar på att du ska börja gå över
                   repbron. "
    escortDest = (s2Platform.north)
    stateAfterEscort = xojoRopeBridge1

    /* 
     *   this escort state class is special, because we don't want to
     *   bother with the usual "you let xojo lead the way" message here -
     *   we have a custom message for this travel instead, provided by the
     *   room 
     */
    escortStateClass = SilentGuidedInTravelState
;

/* 
 *   a "silent" version of the guided tour travel state - this simply
 *   doesn't say anything when we follow our escort 
 */
class SilentGuidedInTravelState: GuidedInTravelState
    sayDeparting(conn) { }
;
    

++ xojoRopeBridge1: XojoEscortState
    stateLoc = ropeBridge1
    arrivingWithDesc = "Xojo väntar på att du ska komma ikapp. "
    stateDesc = "Han väntar på att du ska fortsätta över bron. "
    specialDesc = "Xojo väntar på att du ska fortsätta gå över
                   bron. "
    escortDest = (ropeBridge1.north)
    stateAfterEscort = xojoRopeBridge2
;

++ xojoRopeBridge2: XojoEscortState
    stateLoc = ropeBridge2
    arrivingWithDesc = "Xojo väntar på att du ska komma ikapp. "
    stateDesc = "Han väntar på att du ska fortsätta över bron. "
    specialDesc = "Xojo väntar på att du ska fortsätta över bron. "
    escortDest = (ropeBridge2.north)
    stateAfterEscort = xojoRopeBridge3
;

++ xojoRopeBridge3: XojoEscortState
    stateLoc = ropeBridge3
    arrivingWithDesc = "Xojo är precis ovanför, hängande i repen.
                        <q>Jag tror vi kan klättra upp härifrån,</q> säger han. "
    stateDesc = "Han väntar på att du ska försöka klättra upp för repen. "
    specialDesc = "Xojo väntar på att du ska försöka klättra upp för repen. "
    escortDest = (ropeBridge3.up)
    stateAfterEscort = xojoCanyonNorth
;

++ xojoCanyonNorth: XojoEscortState
    stateLoc = canyonNorth

    arrivingWithDesc = ""
    arrivingTurn()
    {
        if (firstTime)
        {
            "<.p>Xojo sätter sig på marken och hämtar andan. <q>Ha,
            ha,</q> framtvingar han ett skratt. <q>Kanske jag borde ha nämnt.
            De högre ledarna finner det ibland användbart att delvis skära av
            repen som förankrar bron, som en överraskning för dem som går över
            den. Detta påminner Junior-Peons om vikten av att förbli
            uppmärksamma.</q> Han reser sig. <q>Den här vägen,</q> säger han
            och pekar på stigen. ";

            firstTime = nil;
        }
        else
            "Xojo pekar på stigen. <q>Den här vägen,</q> säger han. ";
    }
    firstTime = true
    
    stateDesc = "Han väntar vid stigen. "
    specialDesc = "Xojo väntar vid stigen. "
    escortDest = (canyonNorth.northeast)
    stateAfterEscort = xojoCourtyard
;

++ xojoCourtyard: XojoEscortState
    stateLoc = plantCourtyard
    arrivingWithDesc = "Xojo pekar på dörrarna in i byggnaden. "
    stateDesc = "Han väntar på att du ska gå in i byggnaden. "
    specialDesc = "Xojo väntar på att du ska gå in i byggnaden. "
    escortDest = (plantCourtyard.in)
    stateAfterEscort = xojoAdmin
;

++ xojoAdmin: HermitActorState
    arrivingWithDesc = ""
    arrivingTurn()
    {
        "<.p>Xojo knackar dig på axeln. <q>Se, Överste
        Magnxi!</q> ropar han och pekar på Översten. Du hade inte
        hittat henne i folkmassan ännu, men nu ser du henne stå
        i närheten.
        <.p>Detta är din chans. Du önskar att du inte såg ut som
        om du precis hade blivit påkörd av en buss, men nu finns det ingen tid att oroa sig
        över triviala detaljer så som att se presentabel ut. Dessutom
        ser Översten själv lite löjlig ut - militär-
        uniformen hon har på sig är rolig nog, men den har hon haft på sig
        varje gång du träffat henne. Det är hatten hon
        har på sig som går över gränsen från excentrisk till bisarr. ";

        /* no need to follow the player any longer */
        xojo.followingActor = nil;

        /* move the colonel here */
        magnxi.moveIntoForTravel(adminLobby);
    }

    stateDesc = "Han tittar på bandet. "
    specialDesc = "Xojo är här och tittar på bandet. "
    noResponse = "Xojo verkar inte kunna höra dig på grund av musiken. "
;

++ xojoEmailAgenda: ConvAgendaItem, DelayedAgendaItem
    invokeItem()
    {
        "<.p>Xojo knackar dig på axeln och räcker dig ett papper -
        en utskrift från en gammal radskrivare, med
        omväxlande gröna och vita horisontella ränder över
        sidan. <q>Detta anlände i nattens sändning av elektronisk
        e-post,</q> säger han. <q>Jag uttrycker mitt medlidande för din
        olyckliga misslyckande,</q> tillägger han. <q>Jag önskar dig förbättring
        av lycka för dina framtida strävanden. Nu måste jag återvända
        för att hjälpa Guanmgon att demontera din mycket underbara
        SCU-1100DX-produkt.</q> Ni skakar hand och han försvinner
        in i folkmassan. ";

        /* move the email */
        adminEmail.moveInto(me);

        /* I'm outta here */
        xojo.moveIntoForTravel(nil);

        /* we're done */
        isDone = true;
    }

    /* we need the PC to be present to proceed */
    isReady = (inherited() && xojo.canSee(me))
;

/*
 *   Our other assistant. 
 */
+ guanmgon: Person 'guanmgon/guan/man/byråkrat*män' 'Guanmgon'
    "Han är en byråkrat på mellannivå som tilldelats att hjälpa dig med
    installationen. Han har på sig en kostym som ser lite för liten ut.
    Guanmgon ser ut att vara i fyrtioårsåldern. "

    isProperName = true
    isHim = true

    /* 
     *   ensure we start the phone call on this turn, if we haven't
     *   already started it 
     */
    ensureStartPhoneCall()
    {
        if (phoneState < 16)
            phoneState = 16;
    }

    /* flag: we've received the phone call */
    didGetCall = nil

    /* the phone daemon handler */
    phoneState = 0
    phoneScript()
    {
        /* check our state */
        switch (phoneState++)
        {
        case 16:
            /* start the phone call */
            "<.p>Du hör öppningstonerna från Beethovens femma återges 
            i piezoelektriska fyrkantsvågor: Guanmgons mobil ringer.
            Han drar frenetiskt fram telefonen, tappar den, fångar den i
            fallet, tappar den igen, plockar upp den, petar på knappsatsen,
            och sätter den slutligen mot örat. Hans konversation är inte på
            engelska, så du har ingen aning om vad som sägs, men
            du märker att det inte är goda nyheter. Du skulle gissa att det är hans
            överordnade som ringer för ännu en uppdatering. Det är självklart 
            att det de blev lovade inte inkluderade sex långa veckor bara för 
            att få demot att fungera, och de har inte dolt sin otålighet på 
            sistone. ";

            /* switch to my 'on the phone' state */
            setCurState(guanmgonOnPhone);
            setConvNode(nil);
            break;

        case 17:
            /* continue the call */
            "<.p>Guanmgon fortsätter att prata i telefonen. Mer lyssnande
            än pratande, faktiskt; även utan att förstå språket
            kan du se att varje gång han börjar säga något blir han
            avbruten. ";
            break;

        case 18:
            /* make sure xojo is back from any errand, since we mention him */
            xojo.endErrand();

            /* finish the call */
            "<.p>Guanmgon fumlar med telefonen, nästan tappar den, och
            lägger undan den. Xojo frågar honom något, och du hör
            <q>Mitachron</q> ett par gånger i Guanmgons svar,
            åtföljt av tunga suckar. ";

            /* switch back to the base state */
            setCurState(guanmgonInit);

            /* note that we got the call */
            didGetCall = true;

            /* the script is done, so cancel the daemon */
            eventManager.removeCurrentEvent();
            break;
        }
    }
;
++ InitiallyWorn
    'smal+a vertikal+a bred+a randig+a rutig+a liten brun+a något missanpassad+e
    kostym+en/byxor+na/jacka+n/rand+en/ränder+na/ruta+n/rutor+na/mönster'
    'Guanmgons kostym'
    "Förutom att den ser lite för liten ut, är det som gör
    Guanmgons kostym udda att jackan och byxorna inte
    riktigt matchar. De är båda bruna, men jackan har ett smalt
    vertikalt randigt mönster, och byxorna har breda rutor. "

    isQualifiedName = true
    isListedInInventory = nil
;


/* our initial state - standing nearby watching us try to repair the SCU */
++ guanmgonInit: ActorState, EventList
    isInitState = true

    stateDesc = "Det verkar som att Guanmgon har blivit allt mer 
                 nervös ju längre ditt arbete dragit ut på tiden;
                 på sistone har han nästan blivit desperat. "
    specialDesc = "Guanmgon står i dörröppningen och sträcker på
                   halsen för att se vad du gör. "
    specialDescListWith = [standingInDoorway]

    /* our background script steps */
    eventList =
    [
        nil,
        &initKoffee,
        'Guanmgon trummar med fingrarna mot väggen. <q>Ingen anledning till panik,</q>
        säger han till sig själv. <q>Framgång är fortfarande möjlig.</q> ',
        &initDeet
    ]

    doScript()
    {
        /* 
         *   only perform a scripted action if we haven't engaged in
         *   conversation on this turn, so that we're not overly active; to
         *   perform a scripted action, just inherit the default handling 
         */
        if (!guanmgon.conversedThisTurn())
            inherited();
    }

    initKoffee()
    {
        /* start offering "koffee" on the next turn */
        guanmgon.addToAgenda(koffeeAgenda);
        
        /* just show a background message on this turn */
        "Guanmgon trippar in på tå i rummet och försöker hitta en väg genom röran, 
        men han stöter till något och välter en hög med utrustning på golvet. 
        <q>Förlåt, förlåt!</q> viskar han. Han ställer hastigt tillbaka allt 
        som det var och arbetar sig tillbaka till dörröppningen. ";
    }
    initDeet()
    {
        /* add the item for fetching deet */
        guanmgon.addToAgenda(deetAgenda);
    }
;
++ HelloTopic, ShuffledEventList
    ['Du sneglar på Guanmgon. Så fort ni får ögonkontakt 
    lutar han sig ivrigt in i rummet. <q>Jag står till din tjänst,</q>
    säger han.',
     'Guanmgon ser att du är på väg att säga något. <q>Vad du än behöver,
     så är det jag som är här för att ordna det,</q> säger han nervöst.',
     'Du tittar på Guanmgon och harklar dig. <q>Jag är
     här för att hjälpa till,</q> säger han.']
;
++ ByeTopic "<q>Tack,</q> säger du. Guanmgon nickar."
;
++ ImpByeTopic ""
;

/* 
 *   A class for guanmgon's "conversational agenda" items.  These are
 *   things guanmgon wants to do when he has an opening in the
 *   conversation.  
 */
class GuanmgonAgendaItem: ConvAgendaItem
    /*
     *   We can optionally set a delay, so that we don't run at the first
     *   opportunity but wait the given number of turns. 
     */
    delayBy = 0

    /* cancel these items after the SCU is repaired */
    isDone = (scu1100dx.isWorking && scu1100dx.isOn)

    /* 
     *   These items all dispatch xojo, so make sure xojo is present; only
     *   perform these items in our base state.
     */
    isReady = (inherited()
               && xojo.location == guanmgon.location
               && guanmgon.curState == guanmgonInit
               && deferCnt++ >= delayBy)

    /* 
     *   number of times we've been able to run but haven't, to satisfy
     *   our delay 
     */
    deferCnt = 0
;

/* 
 *   an "agenda item" - this lets guanmgon keep pursuing the koffee
 *   question until we get an answer 
 */
++ koffeeAgenda: GuanmgonAgendaItem
    invokeItem()
    {
        "<q>Behöver du något?</q> frågar Guanmgon. <q>Kanske lite
        Koffee?</q> ";

        guanmgon.setConvNode('Koffee?');
        me.noteConversation(guanmgon);
    }
;

++ deetAgenda: GuanmgonAgendaItem
    delayBy = 2
    invokeItem()
    {
        xojo.beginErrand(deetErrand);
    }
;

++ tankReturnAgenda: GuanmgonAgendaItem
    delayBy = 2
    invokeItem()
    {
        "<.p>Guanmgon viftar med handen för att rensa luften omkring sig.
        <q>Xojo! Du får inte behålla den kraftfulla insektsmedelbehållaren
        så länge, för vårt kostnadskonto kommer att få en intern
        förseningsavgift! Skynda dig att lämna tillbaka behållaren!</q>
        Xojo släpar iväg tanken. ";

        /* start the tank return errand */
        xojo.beginErrand(tankReturnErrand);
    }
;

++ ConvNode 'Koffee?'
    npcContinueMsg()
    {
        /* start the errand */
        "<q>Ja, Koffee är precis vad du behöver,</q> säger Guanmgon.
        <.convnode> ";

        /* send xojo off for Koffee */
        xojo.beginErrand(koffeeErrand);
    }
;
+++ YesTopic
    topicResponse()
    {
        "<q>Ja, tack,</q> säger du.<.p> ";
        xojo.beginErrand(koffeeErrand);
    }
;
+++ NoTopic
    topicResponse()
    {
        "<q>Nej tack, det är okej,</q> säger du. Du vill inte ha något 
        med det där Koffee-grejset att göra.
        <.p><q>Jo, jag insisterar,</q> säger Guanmgon, <q>det skulle glädja mig 
        att hämta lite till dig.</q> Han vänder sig mot Xojo. ";
        
        xojo.beginErrand(koffeeErrand);
    }
;
+++ AskTellAboutForTopic @koffee
    topicResponse()
    {
        "<q>Menar du Koffee med K?</q> frågar du.
        <.p><q>Ja, naturligtvis,</q> säger Guanmgon. ";

        xojo.beginErrand(koffeeErrand);
    }
;


/* 
 *   while guanmgon is on the phone, he's a "hermit" - he doesn't respond
 *   till några konversationskommandon 
 */
++ guanmgonOnPhone: HermitActorState
    stateDesc = "Han pratar just nu med någon i sin mobiltelefon. "
    specialDesc = "Guanmgon pratar med någon i sin mobiltelefon. "

    /* svara inte på någon konversation medan han är i telefon */
    noResponse = "Du vill inte störa honom medan han pratar i telefon. "
;

++ DefaultCommandTopic
    "Guanmgon avböjer artigt och förklarar att administrativa regler, 
    hur gärna han än skulle vilja hjälpa till, förbjuder någon av hans 
    höga rang att assistera på detta sätt. "

    isConversational = nil
;

++ AskTellAboutForTopic @koffee
    "<q>Har ni något kaffe här?</q> frågar du.
    <.p>Guanmgon ler och nickar. <q>Koffee, ja.</q> "
;
+++ AltTopic
    "<q>Ni har inte något riktigt kaffe, med K, eller?</q>
    <.p><q>Vi har bara den mycket utsökta Koffee-sorten med K,</q>
    säger Guanmgon och nickar. "
    isActive = (koffee.location != nil)
;

++ AskTellShowTopic [mosquitoes, deetCloud]
    "<q>Det är verkligen många myggor här,</q> säger du
    och konstaterar det uppenbara.
    <.p><q>Myggor, många, ja,</q> säger Guanmgon och skrattar
    nervöst. "
;
+++ AltTopic
    "<q>Jag tror inte att insektsmedlet fungerar,</q> säger du
    och slår till en till mygga.
    <.p>Guanmgon skrattar nervöst. <q>Vi måste vara extremt tålmodiga
    och lita på att det kommer fungera till slut, precis som med den
    mycket trevliga SCU-produkten.</q> "

    isActive = (deetCloud.location != nil)
;

++ AskTellTopic @contract
    "Guanmgon är bara en mellanchef; han vet ingenting om
    kontraktsärenden. "

    isConversational = nil
;

++ GiveShowTopic @contract
    "Det är ingen idé; Guanmgon är bara en mellanchef, inte den sortens 
    högt uppsatta administratör som skulle kunna hjälpa dig med ett 
    kontraktsärende. "

    isConversational = nil
;

/* ändra svaret när vi fixar SCU:n */
++ GiveShowTopic @scu1100dx
    "Du har inget att visa honom förrän du får den att fungera. "

    isConversational = nil
;
+++ AltTopic
    "Guanmgon verkar lite upptagen; dessutom har du bråttom att 
    träffa Översten. "
    isActive = (scu1100dx.isWorking && scu1100dx.isOn)
;

++ GiveShowTopic [ct22, s901, xt772hv, tester, testerProbe, xt772lv]
    "Det har gjorts tydligt att Guanmgon är här för administrativt, 
    inte tekniskt, stöd. "

    isConversational = nil
;

++ AskTellTopic, SuggestedAskTopic @phoneCallTopic
    "<q>Får jag fråga vad det där samtalet handlade om?</q> frågar du.
    <.p><q>Samtal? Vilket samtal? Åh, ja, det var ingenting. Ingen 
    anledning till oro alls. Det kommer bli bra. Ingen anledning till 
    panik. Ja, det var bara ett litet omnämnande av en representant 
    från Mitachron-företaget, som möjligen anländer, möjligen idag. 
    Jag är säker på att det inte finns någon anledning till oro.</q> 
    Han försöker le brett. "

    /* detta ämne är inte meningsfullt förrän efter telefonsamtalet */
    isActive = (guanmgon.didGetCall)

    /* förslagsnamn */
    name = 'telefonsamtalet'
;

++ guanmgonChecking: HermitActorState
    stateDesc = "Han kontrollerar utrustningen ivrigt. "
    specialDesc = "Guanmgon är här och kontrollerar utrustningen ivrigt. "

    noResponse = "Han verkar upptagen, och dessutom har du lite 
                 bråttom att träffa Översten. ";
;

++ AskTellTopic @guanmgon
    "<q>Hur går det?</q> frågar du.
    <.p><q>Åh, mycket bra, tack,</q> säger Guanmgon. <q>Vi kommer 
    snart ha detta uppdrag slutfört, det är jag säker på.</q> "
;

/* 
 *   Ett par ämnen om Mitachron. Det första är känt från början;
 *   det andra blir tillgängligt först efter telefonsamtalet.
 */
++ AskTellTopic, SuggestedAskTopic @mitachronTopic
    "<q>Vad vet du om Mitachron?</q> frågar du.
    <.p><q>Ingenting!</q> skyndar han sig att säga. <q>Din mycket 
    fantastiska SCU-1100DX är definitivt överlägsen de liknande 
    produkter som det andra företaget erbjuder. Det finns ingen 
    anledning till att oroa sig för det företaget! Jag är säker på att 
    vi kan lyckas slutföra detta uppdrag, så det kommer inte finnas 
    någon motivation att överväga alternativ.</q> "

    /* förslagsnamn */
    name = 'mitachron'
;
+++ AltTopic, SuggestedAskTopic
    "<q>Har du hört något om Mitachron?</q> frågar du.
    <.p><q>Nej!</q> svarar han. <q>Bara i mitt telefonsamtal, och 
    bara ett litet omnämnande, mycket kort, förmodligen inte viktigt. 
    Något om att en representant från det företaget anländer, det var 
    allt det var. Jag är säker på att vi kommer lyckas innan det finns 
    någon anledning till oro.</q> "

    isActive = (guanmgon.didGetCall)
    name = 'mitachron'
;

++ AskTellTopic [omegatronTopic, me]
    "<q>Vad tycker du om Omegatron hittills?</q> frågar du.
    <.p><q>Utmärkt, mycket bra,</q> säger han och nickar snabbt. 
    <q>Jag är säker på att vi kan lyckas. Jag är särskilt imponerad 
    av hur väldigt utmanande du har fått detta projekt att verka.</q> "
;

++ AskTellShowTopic [ct22, xt772hv, xt772lv]
    "Du tror verkligen inte att Guanmgon vet mycket om hur denna 
    utrustning fungerar. "

    isConversational = nil
;

/* 
 *   om vi inte har hittat xt772-lv än, åsidosätt det mer generella
 *   svaret om utrustningen - använd en högre poäng för att åsidosätta 
 *   andra svar
 */
++ AskTellAboutForTopic +110 @xt772lv
    "När du inte vet vart du ska vända dig, frågar du Guanmgon om han 
    har någon aning om var du kan hitta den krets du behöver.
    <q>Nej, tyvärr, vi har inget sådant,</q> säger han. <q>Kanske vi 
    kan beställa det på internet? Men det skulle ta för lång tid. Vi 
    måste lyckas med vårt uppdrag alldeles för snart för det!</q> "

    /* detta används bara om vi inte redan har hittat xt772-lv */
    isActive = (!xt772lv.isFound)
;

++ AskTellTopic @magnxi
    "<q>Vad kan du berätta om Överste Magnxi?</q> frågar du.
    <.p><q>Översten?</q> säger han och blir nervös. <q>Det finns 
    ingen anledning att prata med Översten! Jag har stor tilltro 
    till vår framgång med detta uppdrag. Mycket stor tilltro!</q> "
;

/* 
 *   ett par ämnen om SCU:n - vilket vi får beror på om vi har 
 *   fixat den än eller inte
 */
++ AskTellShowTopic @scu1100dx
    "<q>Vad tycker du om SCU-1100DX hittills?</q> frågar du.
    <.p><q>Mycket fantastisk!</q> säger han. <q>Den kommer bli ännu 
    mer fantastisk när den fungerar, självklart, men den är redan 
    mycket fantastisk.</q> "
;
+++ AltTopic
    "<q>Vad tycker du om SCU-1100DX hittills?</q> frågar du.
    <.p><q>Jag är mycket lättad över att se att din utmärkta produkt 
    har börjat fungera ordentligt,</q> säger han. <q>Mycket, mycket, 
    mycket lättad.</q> "

    isActive = (scu1100dx.isWorking && scu1100dx.isOn)
;

++ AskTellShowTopic @xojo
    "<q>Berätta om Xojo,</q> säger du.
    <.p><q>Xojo är här för att assistera dig,</q> säger han. <q>Jag 
    hoppas han har varit tillräcklig i sin assistans. Det har inte 
    varit något misstag att tilldela honom, det är jag säker på. Han 
    är mycket kapabel.</q> "
;

++ AskTellTopic @powerPlant6
    "<q>Vad mer kan du berätta om kraftverket?</q> frågar du.
    <.p><q>Jag är mycket engagerad i dess korrekta drift!</q> säger 
    han. <q>Ja, jag trivs mycket bra här.</q> "
;

++ DefaultAskTellTopic, ShuffledEventList
    ['Guanmgon verkar inte förstå frågan. ',
    'Guanmgon ler men svarar inte. ',
    '<q>Jag är ledsen,</q> säger Guanmgon, <q>kanske jag kunde 
    svara på en annan fråga?</q> ']
;     
    
++ Decoration 'mobil+telefon+en' 'mobiltelefon'
    "Du är lika teknikintresserad som vilken ingenjör som helst, 
    men ärligt talat, så har du inte varit särskilt imponerad av 
    enheter som kan spelat syntetiserad musik med fyrkantsvågor, 
    sedan de tidiga PC-dagarna. "
;

/*
 *   Dekorationer för kontrollrummets utrustning. Dekorationer är objekt
 *   som existerar endast för beskrivande ändamål och har generellt ingen
 *   annan funktion i spelet. Standardsvaret för en dekoration på någon
 *   handling är att säga "det är inte viktigt", för att göra det klart
 *   för spelaren att de inte bör slösa tid på att försöka lista ut
 *   objektets syfte. Vi anpassar några av dessa dekorationer (via
 *   notImportantMsg) med mer specifika svar, men innebörden är
 *   densamma.
 */
+ Decoration '(el+kraft) (anläggning+en) utrustning+en/system+et/hög+en' 'utrustning'
    "Det är det typiska utbudet av strömbrytare, mätare, laststyrningspaneler och interna
    kommunikationssystem som man kan förvänta sig att hitta i vilket kraftverk som helst
    byggt på 60-talet. Just nu är allt öppet och isärtaget, tack vare dina ansträngningar
    att integrera 1100DX i de befintliga systemen. "
    notImportantMsg = 'Du har redan riggat det ganska
                       grundligt; det är nog bäst att inte
                       pilla mer nu när saker och ting nästan fungerar. '

    /* 
     *   It's the power plant's systems.  Setting 'owner' like this
     *   explicitly means that the player can refer to this using a
     *   possessive that refers to the owner, as in "the plant's
     *   equipment" or "the power plant's systems". 
     */
    owner = powerPlant6
;

//TODO: + 
+ Decoration 'säkringspanel+en/brytarpanel+en/paneler+na/ström|brytare+n*ström|brytar+na säkringar+na' 'säkringspaneler'
    "Det finns dussintals strömbrytare som styr distributionen
    av ström från generatorerna och ger skydd mot
    överbelastningar. "
    isPlural = true
    notImportantMsg = 'Det är inte din domän; bäst att låta det vara. '
;

+ Decoration 'kraft|mätar+na/kraft|nivåer+na/effekt|nivåer+na/mätare+n/spänningar+na/strömstyrkor+na/volt+en/ampere+n'
    'gauges'
    "Mätarna visar spänningar, strömstyrkor och effektnivåer för de många
    kretsarna. "
    notImportantMsg = 'Du borde nog låta mätarna vara. '
    isPlural = true
;

//+ Decoration 'load control board/boards/panel/panels' 'load control boards'
+ Decoration 'laststyrkort+et/kort+et/panel+en/paneler+na/kontroller+na' 'laststyrkort'
    "Dessa kontroller justerar kraftgenereringskapaciteten för att matcha
    belastningen. Varje dag du har varit här har tekniker avbrutit dig
    flera gånger för att justera dessa inställningar. "
    notImportantMsg = 'Kontrollerna är alla känsligt balanserade; du
                       vill definitivt inte röra dem. '
    isPlural = true
;

/*
 *   The internal communications systems.  Note that we define the
 *   vocabulary words "system" and "systems" in parentheses; this makes
 *   them "weak" vocabulary words, which means that they can't be used to
 *   refer to this object without also including one of the other
 *   ("strong") words.  We do this because we don't want any ambiguity if
 *   the player refers to simply "system" or "systems" - we want those
 *   words by themselves to refer to the main "equipment" decoration that
 *   models all of the plant's systems.  
 */

+ Decoration 'intern+a kommunikation^s|system+et/(system+en)' 'kommunikationssystem'
    "Kommunikationssystemet låter operatörerna prata med tekniker i andra
    delar av kraftverket. "
    notImportantMsg = 'Bäst att låta kommunikationssystemen vara. '
    isPlural = true
;

/* 
 *   Mosquitoes.  These are purely a decoration, but we mention them a lot
 *   in the room's atmospheric messages, so it's good to be able to refer
 *   to them. 
 */
+ mosquitoes: Decoration
    'mygga+n/fluga+n/flugor+na/insekt+er*mygg+en insekter+na myggor+na' 'myggor'
    "De är oupphörliga. "
    isPlural = true
    notImportantMsg = 'Myggorna är extremt irriterande, men de är oviktiga. '
    dobjFor(Attack)
    {
        verify() { }
        action() { "Det är meningslöst; det finns fler insekter i detta
            rum än det finnas buggar i SCU-1100DX. "; }
    }
    dobjFor(Take)
    {
        verify() { }
        action() { "Du lyckas inte fånga någon av dem hur mycket du än försöker. "; }
    }
;

/* the SCU-1100DX */
+ scu1100dx: TestableCircuit, Immovable, OnOffControl
    'omegatron komplettera:d+nde kontrollenhet+en modell+en stor+a metall|låda+n 
    scu+n/1100/1100dx/scu-1100dx/scu1100dx/scu1100dx'
    'SCU-1100DX'
    "En Omegatron Supplemental Control Unit modell 1100DX. Du borde
    kunna den lika bra som din egen handflata efter att ha suttit igenom alla
    de där ingenjörsmötena och designgranskningarna, men den omfattande
    kostnadsbesparingen och riggningen i tillverkningsprocessen
    har förvandlat den till något märkligt obekant.
    <<isOn ? "Lyckligtvis har du äntligen lyckats få den att fungera. "
           : "Oavsett det så är det din uppgift att få den att fungera. " >>
    <.p>
    1100:an är i grund och botten en stor metallåda öppen på ena sidan, som ett
    kylskåp utan dörr (och ungefär samma storlek), fylld
    med staplade elektronikmoduler. Knippen med kablar och ledningar som kopplar
    modulerna till kontrollpanelerna och annan utrustning i kraftverket.
    Den är för närvarande <<onDesc>>.
    <<isWorking ? "" :
    "<.p>Det finns en tom plats, där CT-22-modulen du tagit bort ska sitta." >> "
    onDesc = (isOn ? 'påslagen' : 'avstängd')
    cannotTakeMsg = 'Skämtar du? Den är stor som ett kylskåp,
                     och väger lika mycket som en bil. '
    cannotMoveMsg = 'Det finns inte plats att flytta den någonstans. '
    cannotPutMsg = 'Den är alldeles för tung. '

    /* keep track of whether we're working */
    isWorking = nil

    /* we're not a container, but we make it look like we are */
    container = nil
    makeContainerLook = true

    /* we're not really a container, but make it look like we are */
    lookInDesc = "Enheten är fullpackad med staplade elektronikmoduler. "

    dobjFor(Open) { verify() { illogical('1100DX har ingen dörr, för att hålla modulerna lätt tillgängliga. '); } }    
    dobjFor(Switch) asDobjFor(TurnOn)
    dobjFor(TurnOn)
    {
        check()
        {
            /* allow activation only after repair */
            if (!isWorking)
            {
                "Du har ingen anledning att slå på den förrän du har fixat
                problemet med CT-22. ";
                exit;
            }
        }
        action()
        {
            /* remember our activated status */
            makeOn(true);

            /* make sure xojo is back from any errand, since we mention him */
            xojo.endErrand();

            /* success! */
            "Du håller tummarna och slår på strömbrytaren.
            SCU-1100DX klickar och surrar när den startar sin
            självtestsekvens vid uppstart. Många sekunder passerar.
            Du håller andan. Guanmgon och Xojo lutar sig in
            från dörröppningen, som om det fanns något
            att se. Sedan, fyra korta pip: lyckad
            uppstart! Du skannar noggrant modulerna och
            ser att allt fungerar. Efter sex veckor
            har du äntligen klarat det; äntligen kan du visa ett 
            demo och förhoppningsvis få ett kontrakt underskrivet.
            <.p>
            Guanmgon ser SCU:n starta och tränger sig in i
            rummet för att kontrollera kontrollpanelerna. <q>Den
            fungerar,</q> säger han förvånat. <q>Det här är
            så underbart! Fruktansvärd skam är inte för oss nu!
            Men vi måste agera snabbt. Xojo! Eskortera herr Mittling
            för att träffa Översten omedelbart. Skynda med maximal hast!
            Dröj inte! Snabbt, snabbt, skynda!</q>
            <.p>
            Xojo nickar, vänder sig sedan mot dig och pekar mot
            dörröppningen. ";

            /* set xojo to follow us around from now on */
            xojo.followingActor = me;

            /* update xojo's and guanmgon's states for the change */
            xojo.setCurState(xojoEscortControl);
            guanmgon.setCurState(guanmgonChecking);
            guanmgon.setConvNode(nil);

            /* count the score */
            scoreMarker.awardPoints();
        }
    }

    scoreMarker: Achievement { +10 "reparera SCU-1100DX" }

    /* once it's on, don't allow turning it off */
    dobjFor(TurnOff)
    {
        check()
        {
            "Är du från vettet? Du tänker väl inte riskera en full 
            omstart nu när du har fått den redo för ett demo? ";
            exit;
        }
    }

    dobjFor(Repair)
    {
        action()
        {
            mainReport(isWorking && isOn
                       ? 'Men den är redan reparerad! '
                       : 'Det skulle verkligen vara trevligt om det var så enkelt,
                       eller hur? Tyvärr har du inga magiska
                       krafter för elektronisk reparation, så du måste göra
                       något annat än att bara önska att den ska börja fungera. ');
        }
    }

    /* map 'put x in scu' to 'put x in slot' */
    iobjFor(PutIn) maybeRemapTo(scuSlot.isIn(self),
                                PutIn, DirectObject, scuSlot)
;

++ scuSlot: TestableCircuit, Component, RestrictedContainer
    'tom+ma modul:en+lucka+n/plats+en/lucka+n/fack+et' 'tom lucka'
    "Det är luckan där CT-22 diagnostikmodulen ska vara. "

   /* only allow the CT-22 to go in the slot */
   validContents = [ct22]

   iobjFor(PutIn)
   {
       action()
       {
           if (gDobj != ct22)
           {
               /* only allow my module to go in the slot */
               reportFailure('{Den dobj/obj} hör inte hemma i luckan. ');
           }
           else if (!xt772lv.isIn(ct22))
           {
               reportFailure('Det finns ingen anledning att återinstallera modulen innan du lagat den. ');
           }
           else
           {
               /* 
                *   once the module is back in place, get rid of the empty
                *   slot, and get rid of the module itself as a separate
                *   entity 
                */
               self.moveInto(nil);
               ct22.moveInto(nil);

               /* 
                *   in case they want to refer to 'it' again, refer them
                *   to the entire of components, since we're essentially
                *   merged into the stack now 
                */
               gActor.setIt(moduleStack);

               /* 
                *   add the ct22 vocabulary to the main stack of modules,
                *   so that we can still refer to the ct22 even though
                *   it's no longer around as a separate object 
                */
               moduleStack.initializeVocabWith(ct22.vocabWords);

               /* the SCU-1100DX is now repaired! */
               scu1100dx.isWorking = true;

               /* explain what happened */
               mainReport('Modulen glider på plats&mdash;inte helt smidigt,
                        men vid det här laget räcker det att den passar
                        överhuvudtaget. Du ger den en bestämd knuff för att
                        försäkra dig om att alla kontakter sitter ordentligt.
                        Nu återstår bara att slå på SCU:n och hoppas att det
                        inte lurar något ytterligare problem. ');
           }
       }
   }
;

++ moduleStack: TestableCircuit, Immovable
    'staplad+e installerad+e elektroni:sk+k modul+en/moduler+na/stack+en' 'elektronikmoduler'
    "Varje modul är formad ungefär som en pizzakartong, och modulerna
    är staplade på varandra inuti 1100DX.
    << scu1100dx.isWorking
    ? "Den reparerade CT-22 är tillbaka på plats. "
    : "Det finns en tom plats där CT-22-modulen ska sitta. " >> "
    isPlural = true

    dobjFor(Take)
    {
        /* this is slightly less likely for 'take' than portable modules */
        verify()
        {
            inherited();
            logicalRank(80, 'stör ej');
        }
    }

    dobjFor(Open) asDobjFor(LookIn)
    lookInDesc = "Modulerna är alla lite provisoriskt monterade för tillfället;
        du vill inte riskera att ha sönder något genom att ta isär dem. "


    /*
     *   For disambiguation purposes, refer to this object as the
     *   "installed modules" to more clearly differentiate it from the
     *   single uninstalled module (the ct-22).  
     */
    disambigName = 'installerade moduler'

    cannotTakeMsg = 'Det tog ett tag att få allt inkopplat ordentligt,
                     så du vill hellre lämna allt där det är. '
    cannotMoveMsg = 'Modulerna sitter alla ordentligt, så det är bäst
                     att inte skaka dem. '
    cannotPutMsg = 'Du vill inte flytta modulerna någonstans, eftersom
                    det tog ett tag att få dem alla placerade ordentligt. '
;

+ ct22: TestableCircuit, Thing
    'ct-22 ct+22 diagnostiks|modul+en' 'CT-22 diagnostikmodul'
    "<< xt772lv.isIn(self)
    ? "Det är diagnostiksmodulen som är ansvarig för många av
    dina bekymmer här. Som tur är verkar den äntligen vara lagad: ett
    XT772-LV-chip är installerat i modulens S901-sockel. "
    : "Den här modulen är en stor anledning till att jobbet tagit så lång 
    tid. CT-22:ans funktion är att diagnostisera fel och defekter
    i de andra modulerna; naturligtvis visade det sig att den själv var 
    defekt. Den fungerade precis tillräckligt bra för att slösa 
    veckor av din tid, på förgäves felsökning av påhittade problem 
    den rapporterade om i andra moduler. 
    Så snart du kom på att ta ut och kontrollera dess
    funktion med din kretsprovare hittade du snabbt felet:
    tillverkaren hade monterat fel chip i en av de centrala kretsarna.
    De hade monterat en XT772-HV, en högspänningsversion, när de borde ha
    monterat en lågspänningsversion, XT772-LV. Skillnaderna i
    spänningskänslighet skapade alla möjliga falska felmeddelanden.
    Tyvärr är CT-22 en kritisk komponent i SCU:n, så du kan inte
    bara slopa den. ">>
    << xt772hv.isIn(self)
    ? "<.p>Det felaktiga XT772-HV-chipet sitter för närvarande i modulens
    S901-sockel. "
    : xt772lv.isIn(self)
      ? "" : "<.p>Modulens S901-sockel är för närvarande tom. " >> "

    dobjFor(Examine)
    {
        verify()
        {
            /* 
             *   use a slightly elevated rank for disambiguating 'examine
             *   module'; we're the more special of the modules, so it's
             *   more likely we're the one they intend to examine 
             */
            logicalRank(110, 'mer speciell');
        }
    }
    dobjFor(LookIn) asDobjFor(Examine)

    /* map 'put x in ct22' to 'put x in socket' */
    iobjFor(PutIn) remapTo(PutIn, DirectObject, s901)

    dobjFor(Repair)
    {
        action()
        {
            if (xt772lv.isIn(self))
                "Det har du redan gjort! ";
            else if (gActor.canSee(xt772lv))
            {
                //"A simple matter of putting the XT772-LV in the socket. ";
                "Det enkla konsttstycket att stoppa XT772-LV i sockeln. ";
                nestedAction(PutIn, xt772lv, self);

                if (xt772lv.isIn(self))
                    "Gjort. ";
            }
            else
            {
                "Det vore trivialt förutsatt att du hade ett XT772-LV chip.
                Utan ett sådant, finns det ingen uppenbar lösning";

                /* this counts as a mention of the lv */
                xt772lv.isMentioned = true;
            }
        }
    }
;

++ s901: TestableCircuit, Component, SingleContainer, RestrictedContainer
    's901 chip 97-pinn:s^s+medeldensitet^s+hybrid^s+fyrkant+en/fyrkant^s+sockel+n/uttag+et'
    'S901 socket'
    "Det är en 97-pinns medeldensitetshybridsfyrkant/fyrkantssockel. "

    /* this is a special case for a/an because of the leading initial */
    aName = 'en S901-sockel'

    /* don't show my contents in listings of containing objects */
    contentsListed = nil

    /* only allow the XT772 chips */
    validContents = [xt772lv, xt772hv]
;
+++ xt772hv: TestableCircuit, Thing
    'felaktig+a xt772 xt772-hv hög+a effekt+en högeffekt:en^s+version:en^s+chip+et/hv+chip+et/hv+-chip+et'
    'XT772-HV chip'
    "Det är en högeffektsversion av XT772-chipet. Det är rätt sorts
    chip för de flesta andra modulerna, men fel sort för 
    CT-22. <<xt772lv.isIn(nil)
    ? "Tyvärr är detta en reservdel du inte tänkte på att
    ta med dig, och det kan ta flera dagar att få en skickad hit. "
    : "" >> "

    /* 
     *   åsidosätt 'aName', eftersom standardreglerna som räknar ut
     *   om man ska använda 'en' eller 'ett' inte kan hantera den här sortens
     *   konstiga specialfall
     */
    aName = 'ett XT772-HV chip'

    /* it's small; make it pocketable */
    okayForPocket = true
;
+ TestableCircuit, Decoration
    'bunt+en/kabel+n/ledning+en/sladd+en*sladdar+na kablar+na ledningar+na buntar+na' 'kablar'
    "Kablarna och ledningarna kopplar SCU-1100DX till kraftverkets
    system. Du har spenderat de senaste sex veckorna med att lista ut var
    allting ska sitta genom en del försök och misstag, så
    kabeldragningen är lite rörig, men du tror att det mesta
    sitter där det ska vid det här laget. "
    notImportantMsg = 'Det tog dig sex veckor att få kablarna på plats.
                       Du tänker inte röra dem nu. '
    isPlural = true
;

/*
 *   The circuit tester.  This is a "complex container" because we want it
 *   to have some components that are always on the outside, plus a secret
 *   interior container that can be opened and closed.  The secret
 *   interior container is what makes it "complex."  The ComplexContainer
 *   class automatically handles most of the details of the secret
 *   interior container; all we have to do is set a property,
 *   subContainer, to point to the interior container object.  
 */
+ tester: ComplexContainer 'mitachron dynatest multifunktionell+a kretsprovare+n/provare+n/multifunktion^s+kretstestare+n/testare+n'
    'kretsprovare'
    "Det här är din multifunktionella kretsprovare från Mitachron, DynaTest.
    Du känner dig alltid lite generad över att ett av dina viktigaste
    vardagliga ingenjörsverktyg är tillverkat av din största konkurrent, men
    Omegatron har aldrig haft någon större framgång med sina egna produkter i detta
    marknadssegment. Testaren är ungefär lika stor som ett bilbatteri; dess
    huvudfunktioner är en provspets och en liten displayskärm, plus den typiska
    samlingen varningsdekaler på bakstycket. Den är för närvarande
    avstängd. "

    /* Use a secret nested container to hold our contents */
    subContainer = testerInterior

    dobjFor(TurnOn)
    {
        verify() { }
        action() { noNeedToTest(nil); }
    }
    cannotTurnOffMsg = 'Den är redan avstängd. '

    noNeedToTest(other)
    {
        if (other != nil && !other.ofKind(TestableCircuit))
            "Testaren är inte designad för att testa {den iobj/obj} där. ";
        else if (scu1100dx.isWorking)
            "Ingen anledning; SCU:n är redan fixad. ";
        else
            "Du har redan avgränsat problemet, eller åtminstone
            det senaste problemet, till CT-22:an. Ingen anledning att göra
            fler tester förrän du kommer på hur du ska lösa det. ";
    }

    /* "use tester" requires something to use it on */
    dobjFor(Use)
    {
        verify() { }
        action() { askForIobj(UseOn); }
    }

    /* "use tester on x" maps to "test x with probe" */
    dobjFor(UseOn) remapTo(TestWith, IndirectObject, testerProbe)

    /* "test x with tester" maps to "test x with probe" */
    iobjFor(TestWith) remapTo(TestWith, DirectObject, testerProbe)

    /* "plug tester into x" equals "test x with probe" */
    dobjFor(PlugInto) remapTo(TestWith, IndirectObject, testerProbe)

    /* "attach tester to x" maps to "test x with probe" */
    dobjFor(AttachTo) remapTo(TestWith, IndirectObject, testerProbe)
;

++ Component '(krets) (testare) platt panel+en platt-panel+en skärm+en/display+en'
    'testardisplay'
    "Det är en liten platt skärm där testaren visar sina mätvärden. 
    Skärmen är för närvarande blank. "
;

++ testerProbe: ComponentDeferrer, Component
    '(kretstestare+n) elektrisk+a (koax) (koaxial)
    provspets+en/testsond+en/provspets+n/kontakt+en/kabel+n*kontakter+na kablar+na' 'provspets'
    "Det är en uppsättning elektriska kontakter, anslutna till testaren via
    en koaxialkabel, som du fäster på kretsen du vill testa. "

    /* handle testing */
    iobjFor(TestWith)
    {
        verify() { }
        action() { location.noNeedToTest(gDobj); }
    }

    /* treat "attach probe to x" as "test x with probe" */
    dobjFor(AttachTo) remapTo(TestWith, IndirectObject, self)

    /* treat "plug probe into x" as "test x with probe" */
    dobjFor(PlugInto) remapTo(TestWith, IndirectObject, self)

    /* treat "use probe on x" as "test x with probe */
    dobjFor(UseOn) remapTo(TestWith, IndirectObject, self)
;

/* mix-in for something we can attach the probe to */
class TestableCircuit: object
    iobjFor(AttachTo)
    {
        verify() { }
        check()
        {
            if (gDobj != testerProbe)
            {
                "Det finns inget uppenbart sätt att göra det på. ";
                exit;
            }
        }
    }

    /* plug <x> into <self> -> attach <x> to <self> */
    iobjFor(PlugInto) remapTo(AttachTo, DirectObject, self)

    /* "test <self>" requires something to test it with */
    dobjFor(TestObj)
    {
        verify() { }
        action() { askForIobj(TestWith); }
    }

    /* 
     *   "test <self> with <x> is allowed; but we'll count on the indirect
     *   object to do the actual action() handling 
     */
    dobjFor(TestWith) { verify() { } }

    iobjFor(PourOnto) remapTo(PourInto, DirectObject, self)
    iobjFor(PourInto)
    {
        verify() { }
        check()
        {
            "Bäst att låta bli; det skulle antagligen förstöra {ref iobj/honom}. ";
            exit;
        }
    }
;    

/* 
 *   The back cover of the tester.  The tricky thing about this object is
 *   that we want to allow the player to open and close the back cover to
 *   open and close the tester; we manage this by remapping these commands
 *   from us to the tester's secret interior container. 
 */
++ testerBackCover: ComponentDeferrer, ContainerDoor
    'krets|testarens krets|provarens baklucka+n/baksida+n/bakstycke+t' 'baklucka'
    "Den är designad att ge serviceåtkomst till enhetens interna
    komponenter, och har de typiska varningsdekalerna.
    <<testerInterior.isOpen ? "Den är för närvarande öppen." : "">> "

    /* treat 'remove back cover' as 'open tester' */
    dobjFor(Remove) remapTo(Open, testerInterior)
    dobjFor(TakeFrom) maybeRemapTo(gIobj == location, Open, testerInterior)

    /* treat 'take off back cover' as 'open tester' */
    dobjFor(Doff) remapTo(Open, testerInterior)
;

/*
 *   The tester's secret interior container.  This isn't really visible to
 *   the player as a game object, so it has no vocabulary of its own.
 *   Instead, we redirect container-oriented commands (open, close, look
 *   in, put in) from the tester to this object, so the player can refer
 *   to us in relevant commands by referring to the tester.  
 */
++ testerInterior: Component, Openable, RestrictedContainer
    /* 
     *   we don't want this object to appear to the player as a separate
     *   object from the tester, so just refer to us as the tester 
     */
    name = 'testare'

    /* only allow the xt772's to go in here */
    validContents = [xt772lv, xt772hv]

    /* 
     *   Use a custom contents lister.  First, don't bother mentioning
     *   anything when the back cover is closed; we want to make its
     *   openability somewhat understated rather than calling it out as
     *   explicit status.  Second, describe the contents as being inside
     *   the tester rather than inside the back cover.  
     */
    contentsLister: thingContentsLister {
        showListEmpty(pov, parent)
        {
            if (parent.isOpen)
                "Baksidan är öppen, och kretsarna inuti testaren syns. ";
        }
        
        showListPrefixWide(itemCount, pov, parent)
        {
            /* 
             *   note that we'll only reach this method if we're open,
             *   since otherwise we wouldn't have any visible contents to
             *   list 
             */
             "Baksidan av testaren är öppen, och kretsarna inuti är synliga, de inkluderar ";
        }
    }
    descContentsLister = (contentsLister)
    lookInLister = (contentsLister)

    /* use a custom lister when we're opened */
    openingLister: openableOpeningLister {
        showListPrefixWide(itemCount, pov, parent)
        {
            "När du öppnar blir kretsarna inuti synliga,
            de inkluderar ";
        }
    }

    dobjFor(LookIn)
    {
        verify()
        {
            /* 
             *   If we're not open, it's illogical to look in the tester.
             *   Getting this message right is a bit tricky; we want to
             *   convey that the only reason we can't look inside the
             *   tester is that it's not open, but we don't want to make
             *   it too obvious that it actually is openable, since in
             *   real life we'd tend to overlook the possibility of taking
             *   apart an everyday object like this.  
             */
            if (!isOpen)
                illogicalNow('Du skulle behöva ta isär den för att göra det. ');

            /* inherit the default handling as well */
            inherited();
        }
    }
    dobjFor(Open)
    {
        verify()
        {
            /* 
             *   Mark this as non-obvious, so we don't do it implicitly.
             *   Since you have to remove the back cover to open the
             *   tester, it's not entirely obvious that the tester is
             *   openable in the first place. 
             */
            nonObvious;

            /* inherit default */
            inherited();
        }
        action()
        {
            /* run the normal action first */
            inherited();

            /* if we haven't scored before, do so now */
            if (scoreMarker.awardPointsOnce())
            {
                /* mention that we've found something special */
                reportAfter('<.p>Så klart, DynaTestaren är precis en 
                    sån typ av lågströmsenhet där du skulle kunna hitta en 
                    XT772-LV! ');

                /* note that we've found it */
                xt772lv.isFound = true;

                /*
                 *   This is a bit of a "story hack," but we want to
                 *   ensure that Guanmgon's phone call finishes before the
                 *   PC can finish the repairs to the SCU-1100DX.  It
                 *   takes three turns for the phone call, and the repair
                 *   will take at least three turns after this one (put
                 *   xt772lv in ct-22; put ct-22 in slot; turn on
                 *   scu1100dx).  So, if we simply start the phone call on
                 *   this turn (if it hasn't started already), and the
                 *   player does the repair in the least possible number
                 *   of turns, then the phone call finish on the 'put
                 *   ct-22 in slot' turn.  So, we'll definitely be past
                 *   the phone call on the 'turn on scu1100dx' turn. 
                 */
                guanmgon.ensureStartPhoneCall();
            }
        }
    }

    /* achievement object to track finding the xt772-lv chip */
    scoreMarker: Achievement { +2 "hitta XT772-LV-kretsen" }
;

+++ Fixture 'krets+testare+n' 'kretstestare'
    "Kretsarna har det vanliga Mitachron-utseendet med kaotisk design,
    som om delarna inte riktigt passar och har tvingats på plats
    med en hammare. "
;

+++ xt772lv: TestableCircuit, Thing
    'xt772 xt772-lv låg+a lågeffekt:en^s+version:en^s+chip+et/lv+chip+et/lv+-chip+et chip/version'
    'XT772-LV-chip'
    "Det är lågeffektsversionen av XT772-chipet. "

    /* we need to override the a/an name because of the leading initial */
    aName = 'ett XT772-LV-chip'

    /* mark it as known in advance */
    isKnown = true

    /* have we found it yet? */
    isFound = nil

    /* have we mentioned it to the player yet? (for hint management) */
    isMentioned = nil

    /* it's small; make it pocketable */
    okayForPocket = true
;

++ Component 'varning:en^s+etikett+en klistermärke+t*varningar+na varning:ar^s+etiketter+na' 'varningsetiketter'
    "Blixtsymboler i gula trianglar.
    <font color=red bgcolor=yellow><b>ÖPPNA INTE!</b></font>
    Inga delar som kan underhållas av användaren!
    <b>Garantin kan ogiltigförklaras vid öppnande!</b> De gamla vanliga sakerna. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Some objects in common to both hallways 
 */


/* class for power hall rooms */
class PowerPlantHallRoom: PowerPlantRoom
    north: NoTravelMessage { "Du är fem våningar upp; bäst att ta
        hissen istället. " }
    south: NoTravelMessage { "Anläggningens golv är fem våningar nedanför;
        bäst att ta hissen istället. " }

    name = 'korridor'
    vocabWords = 'hall+en/korridor+en'

    /* 
     *   these rooms don't have normal north and south walls (we provide
     *   our own custom walls instead, to describe the waist-high nature) 
     */
    roomParts = static (inherited - [defaultNorthWall, defaultSouthWall])

    /* share a single set of atmosphere events with both hall locations */
    atmosphereList: Script
    {
        doScript()
        {
            switch (curScriptState++)
            {
            case 1:
                "Ett avlägset mullrande ljud hörs någonstans från djungeln.
                Först tror du att det är åska, men när det blir lite högre 
                inser du att det är en annalkande helikopter. Du söker av 
                horisonten, men himlen är tom. Plötsligt är ljudet öronbedövande,
                och en svart form sveper in i synfältet ovanifrån och rasar iväg
                mot byggnaderna på andra sidan floden. När helikoptern flyger förbi
                ser du den gula Mitachron-logotypen på stjärtbommen. ";

                /* add the first helicopter */
                helicopter1.moveIntoAdd(powerHallEast);
                helicopter1.moveIntoAdd(powerHallWest);

                /* mark it as having been seen */
                me.setHasSeen(helicopter1);
                break;

            case 2:
                "Ljudet av en annan annalkande helikopter hörs från djungeln,
                och inom några ögonblick dyker den upp&mdash;tillsammans med
                tre andra, flygandes i formation, på väg åt samma håll som
                den föregående. De fyra flyger över floden och landar bredvid
                den första. ";

                /* replace the single helicopter with the five */
                helicopter1.moveInto(nil);
                helicopter5.moveIntoAdd(powerHallEast);
                helicopter5.moveIntoAdd(powerHallWest);

                /* mark it as having been seen */
                me.setHasSeen(helicopter5);
                break;

            case 3:
                "Mitachron-folkets ankomst är oroande – de måste verkligen vilja 
                säkra kontraktet, med tanke på hur stor grupp de skickat. 
                Som minst måste de dock hålla sin egen demonstration, så där ligger du steget före. 
                Men direkta konkurrenssituationer med Mitachron brukar sällan sluta väl för Omegatron. 
                Möjligen, om du lyckas nå Översten i tid, så kan du få kontraktet påskrivet innan 
                Mitachrons representanter ens får till stånd ett möte med henne";
                break;
            }
        }
    }
;

/* a dummy container for objects within the power plant */
MultiInstance
    initialLocationClass = PowerPlantHallRoom
    instanceObject: SecretFixture { }
;

+ Fixture
    'norra n midjehög+a midje-hög+a vägg+en' 'norra väggen'
    "Den är bara midjehög, vilket lämnar korridoren öppen mot djungeln. "
;
+ Fixture
    'södra s midjehög+a midje-hög+a vägg+en' 'södra väggen'
    "Den är bara midjehög, vilket lämnar korridoren öppen mot anläggningens
    interiör. "
;
+ Fixture 'betong vitt-placerade placerade pelare' 'pelare'
    "De är bara betongpelare som håller upp taket. "
    isPlural = true
;
+ Distant 'enorm+a anläggning^s+interiör+en/(golv+et)'
    'anläggningens interiör'
    "Anläggningens interiör är ett enormt utrymme söderut. Denna
    korridor är i princip en balkong, fem våningar upp, längs den
    norra väggen. Härifrån har du en bra utsikt över den gigantiska
    industriella utrustningen som driver anläggningen. "
;
+ Distant 'gigantisk+a industriell+a ångåldersutrustning+en/utrustning+en
            /turbiner+na/transformatorer+na/pannor+na/rör+en/kablar+na'
   'utrustning'
    "Turbiner, transformatorer, pannor, alla sammankopplade med ett stort
    nätverk av rör och kablar. Allt ser väldigt ångåldersmässigt ut. "

    /* 
     *   'equipment' is used as a 'mass noun' - it refers to mutiple
     *   objects even though the word itself is singular 
     */
    isMassNoun = true
;
+ Distant 'djungel' 'djungel'
    "Utsikten är fantastisk från denna upphöjda position. Direkt norrut
    ligger den djupa ravinen Xtuyong-flodkanjonen; anläggningen
    är byggd precis på kanten av klipporna. På den motsatta
    kanten av kanjonen ligger komplexet av administrativa byggnader,
    där Överstens kontor finns. Bortom det är det otämjd djungel
    ända till horisonten. En bro spänner över kanjonen. "
;
+ Distant 'vegetation+en/växter+na' 'vegetation'
    "Det finns gott om den, eftersom detta är en djungel. "
;
+ Distant 'xtuyong flod djup+a kanjon+en/ravin+en' 'kanjon'
    "Tvåhundra meter djup och hundra meter bred, urholkad
    under årtusenden av det stadiga vattenflödet från regnskogens
    högland i väster. En bro spänner över kanjonen. "
;
+ Distant 'betong stål struktur+en/bro+n' 'bro'
    "Du har gått över den många gånger nu; det är en bred, modern struktur
    byggd av stål och betong. Bron förbinder kraftverket på
    denna sida av kanjonen med de administrativa byggnaderna på
    andra sidan. "
;
+ Distant 'kontor administrativ:t+a komplex+et*kontorsbyggnader+na/byggnader+na'
    'administrativa komplexet'
    "Det är ett vidsträckt komplex av kontorsbyggnader som inhyser
    kraftverkets omfattande byråkrati. "
;
+ Distant 'himmel+n' 'himmel'
    "Den är djupt, klart blå. "
;

class HeliTail: Distant 'helikopterbom+men+stjärtbom+men/fenstronaxel+n' 'stjärtbommen'
    "Den verkar vara märkt med Mitachron-logotypen. "
   ;
class HeliTailLogo: Distant 'gul+a mitachron logotyp+en/mitachron-logotyp+en/mitachron|logotyp+en' 'Mitachron-logotyp'
    "Du kan knappt urskilja den härifrån, men du tror
    att du känner igen markeringarna som Mitachron-logotypen: ett stort gult
    <q>M</q> i ett kraftigt sans-serif-typsnitt med lutning, överlagrat på
    en ljusgul kontur av en glob. "
;

/* the first helicopter */
helicopter1: MultiLoc, Distant 'svart+a mitachron+helikopter+n'
    'svart helikopter'
    "Den håller just på att landa nära det administrativa komplexet. "
;
+ HeliTail;
++ HeliTailLogo;

/* the full group of helicopters */
helicopter5: MultiLoc, Distant
    'fem svart+a mitachron+helikopter+n/choppers/grupp+en*mitachron+helikoptrar+na'
    'fem svarta helikoptrar'
    "Alla fem helikoptrar är parkerade tillsammans nära administrations-
    komplexet. De är för långt borta, och det finns för mycket vegetation
    i vägen, för att se om det är någon aktivitet nära dem eller om någon
    har stigit ur. "
    isPlural = true
    aName = (name)
;
+ HeliTail;
++ HeliTailLogo;


/* ------------------------------------------------------------------------ */
/*
 *   The hallway outside the control room 
 */
powerHallEast: PowerPlantHallRoom
    'Östra änden av korridoren' 'den östra änden av korridoren'
    "Precis som varje annan del av anläggningens struktur är den här breda
    korridoren på femte våningen helt byggd av betong. De norra
    och södra väggarna är bara midjehöga, bortsett från några glest placerade
    pelare som stödjer taket, vilket lämnar korridoren öppen
    mot djungeln i norr och mot anläggningens enorma interiör i
    söder. Korridoren slutar i en dörröppning i
    öster och fortsätter västerut. "

    east = powerHallDoorway
    in asExit(east)
    west = powerHallWest

    /* 
     *   remove the west wall, since there isn't one, and the default
     *   north and south walls, since we want custom descriptions for
     *   these instead 
     */
    roomParts = static (inherited() - defaultWestWall)
;

+ powerHallDoorway: Fixture, ThroughPassage -> powerControlDoorway
    'öst+ra ö dörr+öppning+en/skylt+en' 'dörröppning'
    "Du antar att skylten säger <q>Kontrollrum,</q> även om
    det inte är på ett alfabet du kan läsa. Dörröppningen leder österut. "
;
   
/* ------------------------------------------------------------------------ */
/*
 *   The west end of the hall, at the elevator 
 */
powerHallWest: PowerPlantHallRoom
    'Västra änden av korridoren' 'den västra änden av korridoren'
    "Denna breda korridor har midjehöga väggar öppna mot djungeln
    i norr och mot anläggningens enorma interiör i söder; några
    glest placerade pelare stödjer taket. Korridoren slutar vid en
    hissdörr i väster och fortsätter österut. "

    east = powerHallEast
    west = plantHallElevatorDoor
    in asExit(west)

    /* we have no east well, and we have custom north and south walls */
    roomParts = static (inherited()
                - [defaultNorthWall, defaultSouthWall, defaultEastWall])
;

+ plantHallElevatorDoor: Door, BasicContainer ->plantElevatorGate
    'hiss+dörr+en/lift+dörr+en' 'hissdörr'
    "Det är en av de där gamla hissarna med en vanlig svängdörr,
    målad i en blek blågrön färg. En rund, svart anropsknapp är
    bredvid dörren, och ovanför knappen finns en liten (för närvarande
    <<plantElevator.isOnCall ? 'tänd' : 'släckt'>>) neonlampa."

    /* it's initially closed - we can't open it until the elevator arrives */
    initiallyOpen = nil

    dobjFor(Open)
    {
        check()
        {
            /* if the elevator isn't here, we can't open it */
            if (!plantElevator.isAtTop)
            {
                "Dörren kan inte öppnas förrän hissen anländer. ";
                exit;
            }

            /* run the default checks */
            inherited();
        }
    }
    dobjFor(Close)
    {
        check()
        {
            /* if xojo is here, don't allow the player to close it */
            if (xojo.isIn(location))
            {
                "Xojo håller den öppen åt dig; ingen anledning att vara oartig. ";
                exit;
            }
        }
    }

    dobjFor(Board) remapTo(TravelVia, self)
;

++ Fixture 'vikbar metall hiss lift grind' 'hissgrind'
    "Det är en vikbar metallgrind som fungerar som hissens
    inre dörr. "
;

+ Button, Fixture 'rund+a svart+a hiss+anrop^s+knapp+en/lift+anrop^s+knapp+en ' 'anropsknapp'
    "Det är en stor svart knapp som sticker ut från väggen ungefär
    en centimeter. "
;

+ Fixture 'li:lla+ten neon|lampa+n' 'neonlampa'
    "Den är för närvarande <<plantElevator.isOnCall ? 'tänd' : 'släckt'>>. "
;

/* ------------------------------------------------------------------------ */
/*
 *   The elevator interior.  Note that we don't use our general Elevator
 *   class, or its various related components, to implement this elevator;
 *   this elevator's behavior is quirky, so our general elevator classes
 *   don't apply well here.  
 */
plantElevator: PowerPlantRoom 'Hiss' 'hissen'
    "Detta är en stor, robust byggd hiss, som något du skulle
    hitta i ett gammalt lager. Det har inte gjorts något försök till dekoration;
    bara matta metallväggar, en vikbar metallgrind i öster,
    ett handräcke på den bakre väggen, <<powerElevPanel.isOpen
    ? 'en, två gånger tre fot, stor öppning' : 'en infälld servicepanel'
    >> i taket, en naken glödlampa som lyser svagt i det övre hörnet av
    bakre väggen. Utstickande svarta knappar är märkta, nerifrån
    och upp, S2, S1, G, och 2 till 5.
    <<isDescending ? "Den nakna betongen i schaktväggen glider förbi
    bortom grinden." : "Bortom grinden är schaktväggens nakna betong." >> "

    vocabWords = 'hiss+en/lift+en'

    east = plantElevatorGate
    out asExit(east)

    dobjFor(GetOutOf)
    {
        verify() { }
        remap = nil
        action()
        {
            /* 
             *   if we're on xojo's shoulders, and the panel is open,
             *   climb out; otherwise, there's no obvious way out 
             */
            if (gActor.isIn(xojoBoost) && powerElevPanel.isOpen)
                replaceAction(Up);
            else
                replaceAction(East);
        }
    }

    up = (powerElevPanel.isOpen ? powerElevPanel : inherited())

    /* dispense with the usual room parts, keeping only the floor */
    roomParts = [defaultFloor]
    
    /* flag: the elevator is on call to the top floor */
    isOnCall = nil

    /* flag: we're at the top floor */
    isAtTop = nil

    /* flag: we're at the bottom of the shaft */
    isAtBottom = nil

    /* flag: we're currently descending */
    isDescending = nil

    /* current floor number */
    curFloor = 10

    /* call the elevator to the top floor */
    callToTop()
    {
        /* note that I'm on call */
        isOnCall = true;

        /* 
         *   Set a fuse for arrival in a few turns.  We want to make the
         *   wait long enough that we see the helicopters arrive, but not
         *   much longer.  
         */
        new SenseFuse(self, &arriveAtTop, 3, plantHallElevatorDoor, sight);
    }

    /* start the descent */
    startDescent()
    {
        /* set us in motion */
        isDescending = true;
        isAtTop = nil;

        /* start a daemon to run the descent */
        new Daemon(self, &descentDaemon, 1);
    }

    /* fuse - arrive at the top floor when called */
    arriveAtTop()
    {
        "En hög summer ljuder från hissen, och neonlampan
        ovanför anropsknappen släcks. ";

        /* if xojo is here, have him open the door */
        if (xojo.isIn(powerHallWest))
        {
            "<.p>Xojo öppnar dörren och skjuter undan hissens
            fällbara metallgrind för dig, och väntar på att du ska gå in. ";
            
            plantElevatorGate.makeOpen(true);
        }

        /* we're no longer on call, and we are at the top */
        isOnCall = nil;
        isAtTop = true;
    }

    /* descent daemon - called each turn while we're descending */
    descentDaemon()
    {
        local btn;
        
        /* descend one level */
        --curFloor;

        /* find the button for our current floor, if any */
        btn = contents.valWhich(
            {x: x.ofKind(PlantElevButton) && x.internalFloor == curFloor});

        /* mention what's going on */
        if (btn != nil)
        {
            /* we have a button, so we just passed a door */
            "<.p>Hissen passerar en dörr märkt
            <q><<btn.nominalFloor>>.</q> ";

            /*
             *   If we just passed floor 1, xojo notices it.  If we just
             *   passed S2, we're about to crash.  Otherwise, if the button
             *   is pushed, mention that we didn't stop.  
             */
            if (btn.internalFloor == 2)
            {
                "Konstigt; du trodde att det var din våning.
                <.p>Xojo, som ser lite orolig ut, börjar trycka på
                knapparna. <q>Ingen anledning till panik,</q> säger han, inte särskilt
                övertygande, men sedan verkar han lugna ner sig och sluta
                pilla med knapparna. <q>Hissprogrammeringen
                är ibland felaktig. Vi borde stanna snart,
                eftersom schaktet nästan är i botten.</q> ";

                /* cancel any conversation */
                xojo.setConvNode(nil);
            }
            else if (btn.internalFloor == -2)
            {
                /* we've reached the bottom of the shaft */
                "<.p>Xojo griper tag i handräcket hårt. <q>Var beredd, 
                stoppet kommer att bli abrupt.</q> Du tar tag i handräcket
                och förbereder dig.
                <.p>
                Schaktväggen fortsätter att glida förbi i några ögonblick till, utan
                tecken på att sakta ner, sedan: duns! Inte ett ryck från kabeln
                ovanför, utan den skarpa chocken av att träffa något nedanför.
                Hela hissen skakar. Utanför grinden är schaktväggen
                plötsligt stilla.
                <.p>
                <q>Allt är säkert nu,</q> säger Xojo och slappnar av. <q>Nu
                behöver vi bara vänta tålmodigt på räddning.</q> ";
                
                /* no longer descending, since we're at the bottom */
                isDescending = nil;
                isAtBottom = true;

                /* we don't need the descent script any longer */
                eventManager.removeCurrentEvent();

                /* cancel any conversation */
                xojo.setConvNode(nil);
            }                
            else if (btn.isPushed)
                "Konstigt att hissen inte stannade här, med tanke på att
                du tryckte på knappen. ";
        }
        else if (curFloor == 9)
        {
            /* 
             *   say nothing on the first turn we're descending, as we will
             *   just have said we started descending 
             */
        }
        else if (curFloor == 5)
        {
            "<.p>Hissen fortsätter sin långsamma nedstigning.
            Rationellt sett vet du att de få minuterna av denna hissfärd
            inte kommer att kosta dig affären, men det hindrar inte
            den irrationella delen av din hjärna från att pumpa ut
            ångesthormon. ";
        }
        else if (curFloor == 3)
        {
            "<.p>Hissen kämpar vidare. Kom igen, kom igen, kom igen... ";
        }
        else
        {
            /* there's no button, so we're just going by shaft wall */
            "<.p>Hissen fortsätter sin långsamma nedstigning. ";
        }
    }

    roomBeforeAction()
    {
        /* 
         *   if we try going UP from directly in the elevator (not sitting
         *   on xojo's shoulders), and we've climbed up before, allow it 
         */
        if (gActionIs(Up)
            && xojo.boostCount != 0
            && gActor.isDirectlyIn(self))
            replaceAction(Climb, xojo);
    }
;
+ Fixture 'schaktvägg+en' 'schaktvägg'
    "Schaktväggen är av enkel betong.
    <<location.isDescending ? 'Hissens rörelse skapar
    illusionen att schaktväggen glider långsamt uppåt.' : ''>> "

    /* this wall is slightly more interesting than the elevator walls */
    dobjFor(Examine) { verify() { logicalRank(110, 'schakt'); } }
;

+ Fixture
    'bar+a matt+a metall+en hiss lift nord syd väst n s v bak övre
    vägg+en/hörn+en*väggar+na'
    'hissväggar'
    "Hissväggarna är av bar, matt metall. Ett handräcke är fäst
    på bakväggen. "
    isPlural = true
;

+ Fixture 'metall:en+hand|räcke+t' 'handräcke'
    "Det är ett enkelt metallhandräcke. "

    dobjFor(Hold)
    {
        verify() { }
        action() { "Du håller i handräcket ett ögonblick. "; }
    }
    dobjFor(StandOn)
    {
        verify() { }
        action()
        {
            "Du försöker klättra upp på handräcket, men det är för
            smalt för att få ett bra fotfäste, och det finns inget annat att
            hålla i. Du försöker angripa det från några olika vinklar,
            men du kan inte få det att fungera. ";

            xojo.observeClimb(self);
        }
    }
    dobjFor(Climb) asDobjFor(StandOn)
    dobjFor(ClimbUp) asDobjFor(StandOn)
    dobjFor(Board) asDobjFor(StandOn)
;

+ plantElevatorGate: Door 'fällbar+a hiss lift metall+grind+en/dörr+en' 'grind'
    "Istället för en dörr finns det bara denna fällbara metallgrind för att
    separera passagerare från schaktväggen medan hissen är
    i rörelse. "

    dobjFor(Open)
    {
        action()
        {
            "Du försöker, men den rubbas inte. Förmodligen låser sig grinden
            automatiskt medan hissen är i
            rörelse<< location.isDescending ? "" : " (eller har fastnat 
            mellan våningarna)" >>. ";
        }
    }

    dobjFor(LookThrough)
    {
        action() { "Du ser schaktväggen. "; }
    }

    /* once the elevator is moving, the apparent destination is nowhere */
    getApparentDestination(origin, actor)
    {
        if (plantElevator.isAtTop)
            return inherited(origin, actor);
        else
            return nil;
    }

    dobjFor(Climb)
    {
        verify() { }
        action()
        {
            "Du försöker försiktigt klättra på grinden så som du skulle göra
            på ett stängsel, men den är för vinglig; du skulle säkert
            få dina fingrar klämda ordentligt, så det riskerar du inte. ";

            xojo.observeClimb(self);
        }
    }
    dobjFor(ClimbUp) asDobjFor(Climb)
;

/* 
 *   the ceiling and its contents are out of reach (until Xojo gives us a
 *   boost) 
 */
+ OutOfReach, NestedRoom, Fixture 'tak+et' 'tak'
    "Matt, bar metall som väggarna; den enda detaljen är en infälld
    servicepanel. "

    /* we can reach Xojo when he's giving us a boost */
    canReachFromInside(obj, dest)
        { return inherited(obj, dest) || dest == xojo; }
    cannotReachFromOutsideMsg(dest)
    {
        gMessageParams(dest);
        return '{Den dest/han} {är} för högt upp för att nå härifrån. ';
    }
    cannotReachFromInsideMsg(dest)
    {
        gMessageParams(dest);
        return 'Du kan inte nå {det dest/honom} här uppifrån. ';
    }

    /* the only way we can be inside here is to be in xojoBoost */
    tryRemovingFromNested() { return tryImplicitAction(GetOffOf, xojo); }

    /* 
     *   anything thrown at an object inside the out-of-reach area near the
     *   ceiling lands back on the floor 
     */
    getDropDestination(objToDrop, path) { return location; }
;

++ Fixture 'naken nakna glöd+lampa+n' 'glödlampa'
    "Den ger den matta belysningen här inne. "

    cannotTakeMsg = 'Du har ingen önskan att eliminera den enda
        ljuskällan här. '
;


/*
 *   A secret internal platform for we're on Xojo's shoulders.  We can't
 *   refer to this object directly; we get here through other actions that
 *   cause Xojo to offer us a boost.
 *   
 *   Putting this platform "inside" the ceiling means we don't have to
 *   traverse the ceiling's OutOfReach containment boundary, which puts the
 *   ceiling and everything inside within reach while we're here, and puts
 *   everything outside the ceiling out of reach while we're here.  
 */
++ xojoBoost: SecretFixture, Platform
    name = 'Xojos axlar'
    isQualifiedName = true
    isPlural = true

    /* show special descriptions while here */
    roomActorStatus(actor) { " (på Xojos axlar)"; }
    roomActorPostureDesc(actor) { "Du är på Xojos axlar. "; }

    /* we can't stand here */
    makeStandingUp() { reportFailure('Du och Xojo har det svårt nog att 
        hålla er i balans så som det är. '); }

    /* ...but we can implicitly dismount if needed */
    tryMakingTravelReady(conn) { return tryImplicitAction(GetOffOf, self); }
    notTravelReadyMsg = 'Du skulle behöva komma ner från Xojos axlar först. '

    /* 
     *   obviously, we don't want xojo following us here; we can prevent
     *   this from happening by making our 'effective' follow location the
     *   same as the elevator, which will mean that being in the elevator
     *   is as good as being here for following purposes 
     */
    effectiveFollowLocation = plantElevator

    /* when we leave via "get off of", we return to the elevator */
    exitDestination = plantElevator

    /* stuff dropped here lands in the elevator */
    getDropDestination(obj, path) { return plantElevator; }

    roomBeforeAction()
    {
        /* 
         *   IF the command is an explicit OUT or GET OUT, treat the
         *   command as simply UP if the power panel is open, or GET OFF
         *   XOJO is it's closed.
         *   
         *   Note that we check to make sure the command doesn't include
         *   the word 'down', because there's at least one GET OUT
         *   phrasing that does; if DOWN is involved, it pretty clearly
         *   means GET OFF XOJO'S SHOULDERS instead of GET OUT OF
         *   ELEVATOR.  We also ignore nested commands, as we have to do a
         *   GET OUT OF to get down, so we don't want to get stuck in a
         *   loop.  
         */
        if (!gAction.isImplicit
            && (gAction.getOrigText.find('ner') == nil && gAction.getOrigText.find('ned') == nil) // TODO: testa av
            && gActionIn(GetOut, Out))
        {
            if (powerElevPanel.isOpen)
                replaceAction(Up);
            else
                replaceAction(GetOffOf, xojo);
        }

        /* if the command is DOWN, treat it as GET OFF XOJO */
        if (!gAction.isImplicit && gActionIs(Down))
            replaceAction(GetOffOf, xojo);
    }

    /* 
     *   we handle OUT specially, and we don't want it to show in the exits
     *   list, so we can just make this a noTravel 
     */
    out = noTravel
;


++ powerElevPanel: Door
    'infälld+a metall (takets) service+panel+en/metall+lucka+n' 'servicepanel'
    desc()
    {
        if (isOpen)
            "Det är en öppning i taket, ungefär sextio centimeter gånger
            nittio centimeter. ";
        else
            "Det är en infälld metallplatta i taket,
            ungefär sextio centimeter gånger nittio centimeter. Du gissar att det är en
            servicelucka som ger tillgång till hissens tak. ";
    }

    initiallyOpen = nil
    descContentsLister = thingContentsLister

    dobjFor(TravelVia)
    {
        action()
        {
            /* add a description of the traversal */
            "Du lyfter dig själv genom öppningen, först genom att stödja dig
            på dina armbågar, sedan använder du hävstångseffekten för att lyfta resten av
            din kropp. ";

            /* an unfortunate side effect the first time through... */
            if (scoreMarker.scoreCount == 0)
            {
                "Precis när du nästan är igenom hör du ljudet av
                tyg som rivs - du inser att du lyckades fastna med benet
                av dina byxor på kanten av öppningen, vilket orsakar en stor
                reva längs halva benet.<.p>";

                khakis.makeTorn(true);
            }
            
            /* achieve the score */
            scoreMarker.awardPointsOnce();

            /* use the normal handling */
            inherited();

            /* 
             *   bring Xojo here directly; he won't be able to follow using
             *   the standard follow handling, because he can't reach the
             *   opening from the floor any more than we could 
             */
            xojo.moveIntoForTravel(destination);

            "<.p>Du sträcker ut din hand till Xojo och hjälper honom att klättra upp
            från hissen. ";
        }
    }
    dobjFor(Board) asDobjFor(TravelVia)
    dobjFor(ClimbUp) asDobjFor(TravelVia)

    scoreMarker: Achievement { +5 "fly från den fastnade hissen" }

    dobjFor(Open)
    {
        action()
        {
            "Du ger plattan en knuff, och den lyfts enkelt bort.
            Du skjuter den åt sidan och lämnar en sextio gånger nittio centimeter stor öppning
            i taket. ";

            makeOpen(true);

            /* it's now an opening */
            initializeVocabWith('sextio-gånger-nittio-centimeter öppning');
        }
    }
    dobjFor(Push) remapTo(Open, self)
    dobjFor(Pull) remapTo(Open, self)
    dobjFor(Remove) remapTo(Open, self)
    dobjFor(Move) remapTo(Open, self)
    dobjFor(PushTravel) remapTo(Open, self)
    dobjFor(Break) remapTo(Open, self)

    dobjFor(Close) { action() { "Det finns ingen anledning att göra det. "; }}

    /* 
     *   to traverse this connector, we don't need a staging location,
     *   since we'll be in the right location if we can reach the panel;
     *   and we don't need to be standing, since sitting on xojo's
     *   shoulders is good enough 
     */
    connectorStagingLocation = nil
    actorTravelPreCond(actor) { return []; }
;

class PlantElevButton: Button, Fixture
    'svart utstickande knapp*knappar' 'knapp'
    "Det är en rund, svart knapp som sticker ut ungefär en centimeter. "
    collectiveGroups = [plantElevButtonGroup]

    /* flag: I've been pushed */
    isPushed = nil

    /* 
     *   our "nominal floor" - we use two internal floors for each nominal
     *   floor, so our nominal floor is our internal floor number divided
     *   by 2 
     */
    nominalFloor = (toString(internalFloor/2))
    
    dobjFor(Push)
    {
        action()
        {
            if (plantElevator.isAtBottom)
                "Du trycker på knappen i hopp om att det ska låsa upp hissen,
                men ingenting verkar hända. ";
            else if (internalFloor >= plantElevator.curFloor)
                "Du trycker på knappen, men du tvivlar på att det kommer ha
                någon effekt, eftersom hissen redan har passerat
                den våningen. Xojo ger dig en frågande blick. ";
            else if (internalFloor == 2)
                "Du trycker på knappen, vilket inte borde vara nödvändigt
                med tanke på att du redan sett Xojo trycka på den. ";
            else if (isPushed)
                "Du trycker på knappen, men du tvivlar på att det kommer ha någon
                effekt, eftersom du redan har tryckt på den. ";
            else
                "Du trycker på knappen. Xojo ser ut som om han vill
                invända, men det är för sent. ";

            /* note that this button has been pushed */
            isPushed = true;
        }
    }
;
+ PlantElevButton '"s2" knapp' '<q>S2</q> knapp'
    internalFloor = -2
    nominalFloor = 'S2'
;
+ PlantElevButton '"s1" knapp' '<q>S1</q> knapp'
    internalFloor = 0
    nominalFloor = 'S1'
;
+ PlantElevButton '"g" knapp' '<q>G</q> knapp'
    internalFloor = 2
    nominalFloor = 'G'
;
+ PlantElevButton '2 -' '<q>2</q> knapp' internalFloor = 4;
+ PlantElevButton '3 -' '<q>3</q> knapp' internalFloor = 6;
+ PlantElevButton '4 -' '<q>4</q> knapp' internalFloor = 8;
+ PlantElevButton '5 -' '<q>5</q> knapp' internalFloor = 10;

/* 
 *   A "collective group" object for the buttons.  For most actions, when
 *   we try to operate on a 'button' without saying which one, we don't
 *   want to ask "which button do you mean...", since they're all basically
 *   the same.  Instead, we just want to say why you can't do whatever it
 *   is you're trying to do. 
 */
plantElevButtonGroup: ElevatorButtonGroup
    'svart+a utstickande hiss|knappar+na lift|knappar+na -' 'hissknappar'
    "Knapparna är ordnade i en kolumn. Nerifrån och upp är de
    märkta S2, S1, G, 2, 3, 4, 5. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Atop the elevator.  We get here after making it through the escape
 *   hatch.  
 */
atopPlantElevator: Room 'Hisschakt' 'hisschaktet'
    "Taket på hisskorgen är inte en särskilt bra plats att stå på,
    trångt som det är med mekaniska utsprång och kabelanslutningar.
    En servicelucka ger tillgång till hissens interiör.
    Huvudkabeln hänger slappt från toppen av schaktet långt ovanför.
    <.p>Österut finns en dörr märkt <q>S2</q>, precis lite ovanför
    toppen av hissen. "

    down = elevRoofHatch
    east = doorS2inner
    out asExit(east)
    up: NoTravelMessage { "Det enda sättet att gå uppåt skulle vara att klättra
        på kabeln, men den är för oljig för att få ett bra grepp. "; }

    roomParts = []
    roomFloor = apeFloor
;

+ Fixture 'betong+schakt+vägg+en/vägg+en/väggar+na' 'schaktväggar'
    "Schaktväggarna är av bar betong. Skenor "
    isPlural = true
;

+ Fixture 'hiss+skena+n*skenor+na' 'skenor'
    "Skenorna styr förmodligen hisskorgen när den färdas upp
    och ner i schaktet. "
    isPlural = true

    dobjFor(Climb)
    {
        verify() { }
        action() { reportFailure('De är för smala; det finns inget sätt
            att få ett tillräckligt bra grepp. '); }
    }
    dobjFor(ClimbUp) asDobjFor(Climb)
;

+ apeFloor: Floor 'hissens liftens tak+et/korg+en/golv+et' 'hisstak'
    "Det är en inte särskilt lätt plats att stå på, på grund av de många
    mekaniska utsprången. "
;

+ Fixture 'mekanisk+a utsprång+et/*bultar+na kabelanslutningar+na kablar+na' 'utsprång'
    "Det är bara en massa bultar och kabelanslutningar och liknande. "
    isPlural = true
;

+ Fixture 'hiss schakt+et/topp+en' 'schakt'
    "Schaktet måste vara runt sju eller åtta våningar högt, men det finns inte
     tillräckligt med ljus för att du ska kunna veta med säkerhet genom att titta på det. "
;

+ elevatorCable: Fixture 'kabel+n/huvud+hiss+kabel+en*kablar+na' 'kabel'
    "Den hänger bara slappt, vilket är rimligt med tanke på att
    hissen kraschade i botten av schaktet. "

    dobjFor(Climb)
    {
        verify() { }
        action() { reportFailure('Kabeln är väl oljad; det finns
            inget sätt att få ett tillräckligt bra grepp. '); }
    }
    dobjFor(ClimbUp) asDobjFor(Climb)

    dobjFor(Pull)
    {
        verify() { }
        action() { "Du drar i kabeln. Vilket skapar en vacker
            sinusvåg som fortplantar sig uppåt. Du är rätt säker på att du skulle kunna
            beräkna flera olika egenskaper hos kabeln endast genom att observera
            vågens fortplantningshastighet, men du har för
            bråttom för att hålla på med sådana förströelser just nu. "; }
    }
;

+ elevPanelCover: Thing 'metall+en lucka+n/servicelucka+n/serviceluck^s+öppning^s+platta+n/lock+et/panel+en'
    'metallplatta'
    "Det är en rektangulär metallplatta, ungefär sextio gånger nittio centimeter,
    några millimeter tjock. Den fungerar som ett lock för hissens
    servicelucka. "

    initSpecialDesc = "Serviceluckans lock ligger bredvid öppningen. "

    cannotUnlockWithMsg = 'Du behöver vara mer specifik om
        hur du tänker göra det. '
;

/* the escape hatch, as seen from above */
+ elevRoofHatch: TravelWithMessage, ThroughPassage -> powerElevPanel
    'service+åtkomst^s+lucka+n/service+åtkomst^s+öppning+en' 'servicelucka'
    "Det är en sextio gånger nittio centimeter stor öppning i hissens tak. "

    /* 
     *   our destination is the elevator itself, not the ceiling (where the
     *   other side of our passage is actually contained) 
     */
    destination = plantElevator

    /* this travel merits some extra description */
    travelDesc = "Du sänker försiktigt ner dig själv genom serviceluckan.
                  När du är igenom, släpper du taget och faller
                  de sista metrarna till hissgolvet. "

    dobjFor(Close)
    {
        verify() { }
        action() { reportFailure('Det finns inget behov av att göra det, och det
            skulle ta bort den huvudsakliga ljuskällan här. '); }
    }
    iobjFor(PutOn)
    {
        verify() { }
        action()
        {
            if (gDobj == elevPanelCover)
                replaceAction(Close, self);
            else
                reportFailure('Det är inte en bra plats att lägga
                    {det/honom dobj} där. ');
        }
    }
    iobjFor(PutIn)
    {
        verify() { }
        action() { "Bäst att låta bli; det är ett långt fall. "; }
    }
;

+ doorS2inner: TravelWithMessage, Door '"s2" hiss+dörr+en' 'dörr'
    "Liksom de andra dörrarna i detta schakt är det en dörr som
    svänger utåt snarare än snarare än en skjutdörr som är mer typisk 
    för moderna hissar. Dörrens nedre del är ungefär sextio centimeter 
    ovanför toppen av hissen. Markeringen <q>S2</q> har målats på med
    en schablon, och vid kanten av dörren finns en låsmekanism.
    <<isOpen ? "Du håller den öppen. "
             : isLocked ? '' : "Den är bara lite på glänt. " >> "

    descContentsLister = thingContentsLister
    isLocked = true

    dobjFor(Open)
    {
        check()
        {
            if (isLocked)
            {
                "Dörren rör sig inte. Du märker en låsmekanism
                vid kanten av dörren: förmodligen en
                säkerhetsfunktion som förhindrar att dörren öppnas
                när hissen inte har stannat på denna
                våning. ";
                gActor.setIt(self);
                exit;
            }
        }
        action()
        {
            "Du knuffar på dörren som svänger upp.
            Den är fjäderbelastad, så du måste hålla i den för att den ska förbli öppen. ";
            makeOpen(true);
        }
    }
    dobjFor(Push) remapTo(Open, self)
    dobjFor(Pull) remapTo(Open, self)
    dobjFor(Move) remapTo(Open, self)
    dobjFor(Unlock) remapTo(Unlock, elevLockSlot)

    cannotUnlockMsg = 'Du behöver vara mer specifik om hur
        du tänker göra det. '

    beforeTravel(traveler, connector)
    {
        if (connector != self && isOpen)
        {
            "Hissdörren slår igen så fort du släpper taget.<.p> ";
            makeOpen(nil);
            isLocked = true;
        }
    }

    travelDesc = "Du klättrar upp de få decimetrarna till den upphöjda tröskeln. "
;
++ Component 'schablonerad s2 markering s2' '<q>S2</q> markering'
    "Det är bara en schablonerad markering som läser <q>S2</q>; det är förmodligen
    våningsnumret. "
;

++ elevLockSlot: Fixture 'smal+a vertikal+a dörrens låsning
    säkerhetsmekanism+en/lås:et+mekanism+en/spärr+en'
    'låsmekanism'
    "Det ser ut som en säkerhetsspärr för att förhindra att någon öppnar
    dörren in i det tomma schaktet när hisskorgen inte har stannat på
    denna våning. De enda exponerade delarna är en låsbult och en smal
    vertikal springa ungefär tio centimeter djup och trettio centimeter lång; förmodligen har hisskorgen en motsvarande del som glider in i springan
    när korgen har stannat vid denna dörr. "

    dobjFor(Open)
    {
        verify()
        {
            if (location.isOpen)
                illogicalNow('Bulten är redan upplåst. ');
        }
        action() { reportFailure('Du pillar lite med bulten, men
            du kan inte få den fri, och dina fingrar passar inte in i
            springan. '); }
    }
    dobjFor(Unlock) asDobjFor(Open)

    lookInDesc = "Springan är för smal för att urskilja några detaljer av
        dess inre funktion. "

    iobjFor(PutIn)
    {
        verify() { }
        check()
        {
            switch (gDobj)
            {
            case elevPanelCover:
                /* this one works - keep going... */
                break;

            case contract:
            case xojoResume:
                "Du försöker glida in papperet i springan. Det passar
                lätt, men det är för tunt för att utlösa låsmekanismen. ";
                exit;

            default:
                "{Ref dobj/han} passar inte i springan. ";
                exit;
            }
        }
        action()
        {
            /* 
             *   check() will ensure we only make it here if we chose the
             *   right object 
             */
            "Du glider in plattan i springan. ";
            if (location.isLocked)
            {
                "Du rör den lite upp och ner, och känner att den fastnar på något. Du drar lite i den; med ett
                klick låses dörren upp och öppnas lite på glänt.
                Du tar bort plattan från springan. ";
                
                location.isLocked = nil;
            }
            else
                "Detta har ingen uppenbar effekt, så du tar bort
                plattan. ";
        }
    }

    /* 
     *   receive notification that we're the indirect object of a PUT IN
     *   involving multiple direct objects 
     */
    noteMultiPutIn(dobjs)
    {
        /* don't allow it */
        "Du kan bara sätta in en sak i taget i springan. ";
        exit;
    }

    /* MOVE THROUGH SLOT, MOVE INTO SLOT -> PUT IN SLOT */
    iobjFor(PushTravelThrough) remapTo(PutIn, DirectObject, self)
    iobjFor(PushTravelEnter) remapTo(PutIn, DirectObject, self)
;
+++ Component 'låsmekanism+en vertikal+springa+n' 'springa'
    "Den är ungefär tio centimeter djup och trettio centimeter lång, och bara några få
    millimeter bred. "

    /* map PUT IN, LOOK IN, etc to our location */
    iobjFor(PutIn) remapTo(PutIn, DirectObject, location)
    dobjFor(LookIn) remapTo(LookIn, location)
    iobjFor(PushTravelThrough) remapTo(PutIn, DirectObject, location)
    iobjFor(PushTravelEnter) remapTo(PutIn, DirectObject, location)
;

+++ Component 'låsmekanism^s+bult+en' 'låsbult'
    "Den är infälld i mekanismen så pass mycket att du inte riktigt kan se hur den fungerar. "
    dobjFor(Open) remapTo(Open, location)
    dobjFor(Unlock) asDobjFor(Open)
    dobjFor(Pull) asDobjFor(Open)
    dobjFor(Move) asDobjFor(Open)
    dobjFor(Push) asDobjFor(Open)
    dobjFor(Turn) asDobjFor(Open)
;

/* ------------------------------------------------------------------------ */
/*
 *   The hallway on level s2 - west end 
 */
s2HallWest: Room 'Västra änden av korridoren' 'den västra änden av korridoren'
    'korridor'
    "Detta är den västra änden av en svagt upplyst korridor. Korridoren slutar här
    med en hissdörr i väster och fortsätter österut. "

    vocabWords = 'hall+en/korridor+en'

    west = doorS2outer
    east = s2HallEast

    roomParts = static (inherited() - defaultEastWall)
;

+ doorS2outer: Door ->doorS2inner
    'hiss+dörr+en/hiss+en/lift+en' 'hissdörr'
    "Det är en gammalmodig hissdörr som öppnas genom att svänga ut
    snarare än att glida åt sidan. En rund, svart anropsknapp finns
    bredvid dörren, och ovanför knappen finns en liten neonlampa
    (för närvarande <<isOnCall ? 'tänd' : 'släckt'>>). "

    isOnCall = nil

    dobjFor(Open)
    {
        check()
        {
            "Dörren är låst och rör sig inte. ";
            exit;
        }
    }
    dobjFor(Unlock)
    {
        verify() { }
        action() { "Den är låst från andra sidan; det finns inget uppenbart sätt att låsa upp den från den här sidan. "; }
    }

    afterTravel(traveler, connector)
    {
        if (connector == doorS2inner)
        {
            "<.p>Du håller dörren öppen för Xojo och låter den sedan dras igen efter att han kommit igenom. Du hör dörren låsas när den stängs. ";
            xojo.moveIntoForTravel(location);
            makeOpen(nil);

            /* award some points */
            scoreMarker.awardPointsOnce();

            /* have xojo start escorting us again */
            xojo.setCurState(xojoS2West);
            "<.p><q>Din flyktplan var uttänkt och utförd
            med stor excellens,</q> säger Xojo. <q>Huvudkanjonens
            bro är tyvärr inte tillgänglig från denna
            källarnivå, men jag känner till en alternativ övergång.
            Den här vägen, tack.</q> Han pekar ner i korridoren. ";
        }
    }

    scoreMarker: Achievement { +2 "fly från hisschaktet" }
;

++ Button, Fixture 'rund+a svart+a hissens anrop^s|knapp+en' 'anropsknapp'
    "Det är en stor svart knapp som sticker ut från väggen ungefär
    en centimeter. "

    dobjFor(Push)
    {
        action()
        {
            if (!location.isOnCall)
            {
                "Lampan ovanför knappen tänds svagt. ";
                location.isOnCall = true;
            }
            else
                "<q>Klick.</q> ";
        }
    }
;
++ Fixture 'li:lla+ten neon|lampa+n' 'neonlampa'
    "Den är för närvarande <<location.isOnCall ? 'tänd' : 'släckt'>>. "
;

/* ------------------------------------------------------------------------ */
/*
 *   S2 hallway - east side 
 */
s2HallEast: Room 'Mitten av korridoren' 'mitten av korridoren' 'korridor'
    "Denna långa, svagt upplysta korridor sträcker sig österut och västerut. En låg, smal dörr leder norrut. "

    vocabWords = 'hall+en/korridor+en'

    west = s2HallWest
    east: FakeConnector, StopEventList {
        ['Xojo tar försiktigt men bestämt tag i din arm och stoppar dig.
        <q>Med respekt, vi får inte gå åt det hållet,</q> säger han. Han
        ser sig nästan konspiratoriskt omkring och sänker rösten.
        <q>Det är domänen för Juniorassisterande Personalfunktionärer,
        av Peon-grad och lägre. De är förvisade att slita här i
        dessa nedre regioner, och i sin misär är de desperata
        efter kontakt till och med med sådana lågt stående överordnade 
        som jag själv. Om vi skulle våga oss dit, skulle vi kanske 
        inte kunna undkomma de underdåniga uppmärksamheterna från 
        sub-peoner på många timmar. Bättre att gå den här vägen 
        istället.</q> Han pekar på dörren mot norr. ',

        'Xojo stoppar dig. <q>Sub-peon-personal den vägen ligger,</q>
        säger han. <q>Bättre att gå den här vägen.</q> Han pekar mot dörren. ']
    }
    north = s2HallEastDoor

    roomParts = static (inherited() - [defaultEastWall, defaultWestWall])
;

+ s2HallEastDoor: Door ->s2StorageDoor 'låg+a smal+a dörr+en' 'dörr'
    "Det är en låg, smal dörr som leder norrut. "
;

/* ------------------------------------------------------------------------ */
/*
 *   S2 Storage room 
 */
s2Storage: Room 'Förrådsrum' 'förrådsrummet'
    "Detta mörka, unkna rum är fyllt med lådor, packlårar och slumpmässigt
    skräp, intryckt i varje tillgängligt utrymme och staplat otryggt 
    från golv till det låga taket. En smal stig verkar slingra sig
    genom skräpet norrut. En dörr leder söderut. "

    vocabWords = 'förrådsrum+met/förråd+et'

    south = s2StorageDoor
    north = storagePath

    roomParts = [defaultFloor, defaultCeiling, defaultSouthWall]
;

+ s2StorageDoor: Door 'låg+a smal+a dörr+en' 'dörr'
    "Det är en låg, smal dörr som leder söderut. "
;

+ Decoration
    'slumpmässig skräp+et/hög+en/låda+n*bråte+n saker+na högar+na packlårar+na lådor+na'  
    'skräp'
    "Det är bara en massa slumpmässigt skräp. "
    isMassNoun = true
;

+ storagePath: TravelWithMessage, ThroughPassage 'smal+a stig+en' 'stig'
    "Det ser ut att vara en tillräckligt stor stig genom skräpet för att
    du ska kunna ta dig igenom. "

    travelDesc()
    {
        "Du tar dig försiktigt fram genom högarna av skräp";
        if (!traversedBefore)
        {
            traversedBefore = true;
            myDust.makePresent();
            ", men platsen är så trång att du inte kan undvika att bli
            täckt med damm och spindelväv";
        }
        ". ";
    }

    traversedBefore = nil
;

/* ------------------------------------------------------------------------ */
/*
 *   North end of storage room
 */
s2Utility: Room 'Nyttoområde' 'nyttoområdet'
    "Det här är den norra änden av ett mörkt, unket förrådsrum. Skräp står 
    staplat nästan från golv till tak i söder, förutom en
    smal stig som slingrar sig genom röran. Den här änden av
    rummet är mestadels rensat från skräp, förmodligen för att lämna plats för
    åtkomst till rör, ledningar och annan nyttoutrustning uppställd
    nära den norra väggen. En rund öppning i den norra väggen leder
    till utsidan; det ser ut som om den främst var designad för rören
    och ledningarna, men det finns tillräckligt med utrymme kvar för en 
    person att ta sig igenom. "

    vocabWords = 'nyttoområde+t/rum+met'

    south = utilityPath
    north = utilityOpening

    roomParts = [defaultFloor, defaultCeiling]
;

+ Fixture 'nord+liga norra n vägg+en*väggar+na' 'norra väggen'
    "En rund öppning leder utomhus. "
;

++ utilityOpening: ThroughPassage 'rund+a öppning+en' 'rund öppning'
    "Den är ungefär en meter i diameter. Ett antal rör och ledningar
    går igenom den, men det finns tillräckligt med utrymme kvar för en person
    att ta sig igenom. "
;

+ Fixture 'nytta nytto rör+en/ledningar+na/utrustning+en' 'nyttoutrustning'
    "Ett komplext nätverk av rör och ledningar fyller större delen av den norra
    änden av rummet, vissa ansluter till utrustning installerad
    här, vissa går ut genom den runda öppningen i norr,
    vissa löper ut genom golvet eller taket. "
    isMassNoun = true
;

+ Decoration
    'slumpmässig+a hög+en/högar+na/låda+n/lådor+na/packlår+en/packlårar+na/skräp+et/bråte+n/saker+na'
    'skräp'
    "Det är bara en massa slumpmässigt skräp. "
    isMassNoun = true
;

+ utilityPath: TravelWithMessage, ThroughPassage ->storagePath
    'smal+a stig+en' 'stig'
    "Det är en tillräckligt stor en stig för att du skulle kunna ta dig igenom skräpet. "

    travelDesc = "Du tar dig försiktigt fram genom högarna av skräp. "
;

/* ------------------------------------------------------------------------ */
/*
 *   platform outside storage room 
 */
s2Platform: OutdoorRoom 'Nyttoplattform' 'nyttoplattformen'
    "Denna rangliga gångbana är inte mycket mer än ett stålgaller
    fastbultat på utsidan av kraftverksbyggnaden, upphängd
    över ett hundraåttio meter djupt fall rakt ner i ravinen nedanför. 
    Anläggningens vägg fortsätter ytterligare sex meter nedåt, där den når
    toppen av ravinens lodräta klippvägg. Ravinens
    vägg stupar nästan vertikalt ner till floden nedanför.

    <.p>En primitiv repbro över ravinen slutar här. Den här änden 
    av bron är bunden till plattformens stålgaller,
    och bron sträcker sig ut över ravinen norrut.

    <.p>Talrika rör och ledningar löper upp och ner längs byggnaden vägg.
    Många går in genom den runda öppningen i
    väggen söderut, men det finns precis tillräckligt med utrymme kvar
    för en person att ta sig igenom öppningen.

    <.p>En kort sträcka österut är undersidan av huvudbron
    över ravinen synlig. "

    north: TravelMessage { -> ropeBridge1
        "Du tar ett djupt andetag och följer försiktigt Xojos ledning,
        håller i huvudstödrepen för balans och letar
        efter fotfäste vid varje steg. " }

    south = platformOpening
    down: NoTravelMessage { "Inte en chans; det är ett alldeles för stort fall. "; }

    roomParts = [s2PlatformFloor, defaultSky]

    roomBeforeAction()
    {
        if (gActionIn(Jump, JumpOffI))
        {
            "Det är ett alldeles för stort fall. ";
            exit;
        }
    }
;

+ platformBridge: Enterable 'primitiv+a hängmatte+liknande hängmatta+n korslagda mönstret rep+bro+n/häng|bro+n*handräcken+a mönstren+a' 'repbro'
    "Det är verkligen en <i>rep</i>bro---inte en bro gjord av
    träplankor som stöds av rep, som du har sett förut,
    utan en bro bokstavligen gjord helt av rep. Gångbanan
    är formad av rep arrangerade i ett korslagt mönster för att
    skapa en sorts hängmatta hängandes från huvudstödrepen,
    som kan användas som handräcken. Den ser mycket provisorisk ut. "

    connector = (location.north)

    dobjFor(Cross) asDobjFor(Enter)
    dobjFor(Board) asDobjFor(Enter)

    dobjFor(Push)
    {
        verify() { }
        action() { "Bron gungar, lite mer än du vad du hade förväntat dig. "; }
    }
    dobjFor(Pull) asDobjFor(Push)
    dobjFor(Move) asDobjFor(Push)
;

+ Distant, Decoration 'undersida+n/huvud|bro+n/balkar+na' 'huvudbro'
    "Det enda kan se härifrån är stålbalkarna som stöder
    vägbanan över ravinen. "
;

+ RopeBridgeCanyon 'brant+a vertikal+a  ravin+en/klippa+n/flod+en/vägg+en/väggar+na' 'ravin'
    "Ravinens väggar stupar nästan vertikalt. Att bedöma avstånd
    i denna skala med blotta ögat är nästan omöjligt, men du har blivit tillsagd
    att ravinen är ungefär hundraåttio meter djup. "
;

+ s2PlatformFloor: Floor 'metall+en plattform+en/golv+et/stålgaller/stålgallret/gall:er+ret/gångbana+n'
    'stålgaller'
    "Det är ett enkelt stålgaller, fastbultat på sidan av kraftverks-
    byggnaden. "

    dobjFor(JumpOff)
    {
        verify() { }
        action() { "Det är ett alldeles för stort fall. "; }
    }
    dobjFor(JumpOver) asDobjFor(JumpOff)
;

+ Fixture '*ledningar+na rör+en' 'rör'
    "Det finns inga markeringar du kan läsa, så det är svårt
    att säga vad det specifika syftet med något givet rör eller
    ledning är. "
    isPlural = true
;

+ Fixture 'betong+en regering+en 6 utsida+n kraftverk+et/vägg+en/byggnad+en/sida+n'
    'kraftverk'
    "Kraftverkets vägg reser sig flera våningar ovanför och slutar
    inte långt nedanför, vid toppen av klippväggen. En rund öppning
    leder in i byggnaden. "

    dobjFor(Enter) remapTo(TravelVia, platformOpening)
    dobjFor(GoThrough) remapTo(TravelVia, platformOpening)
;

++ platformOpening: ThroughPassage ->utilityOpening
    'rund+a öppning+en' 'rund öppning'
    "Den är ungefär en meter i diameter. Rör och ledningar går genom
    den, men det finns tillräckligt med utrymme för en person att ta sig igenom. "
;

/* ------------------------------------------------------------------------ */
/*
 *   helper classes for the bridge rooms 
 */
class RopeBridgeRoom: Floorless, OutdoorRoom
    roomBeforeAction()
    {
        if (gActionIs(Drop))
        {
            "Det finns ingen plats att lägga ner något här; det
            skulle förmodligen falla genom gliporna i repen. ";
            exit;
        }
        if (gActionIs(ThrowAt) && !gIobj.ofKind(RopeBridgeCanyon))
        {
            "Bäst att inte göra det; {det dobj/han} skulle förmodligen falla ner i ravinen. ";
            exit;
        }
        if (gActionIn(Jump, JumpOffI))
        {
            "Inte en chans; det är en väldigt lång väg ner. ";
            exit;
        }
        if (gActionIs(Wait))
        {
            "Du vill helst inte spendera mer tid här än nödvändigt. ";
        }
    }
;

class RopeBridge: Fixture
    'rep|bro+n/gångbana+n/gall:er+ret' 'repbro'
    "Hela bron gungar avsevärt. Du vill inte
    spendera mer tid på den här saken än du måste. "

    dobjFor(JumpOff)
    {
        verify() { }
        action() { "Inte en chans; det är en väldigt lång väg ner. "; }
    }
    dobjFor(JumpOver) asDobjFor(JumpOff)
    dobjFor(SitOn)
    {
        verify() { }
        check() { "Det är ingen bra plats att sitta på. "; exit; }
    }
    dobjFor(LieOn)
    {
        verify() { }
        check() { "Det är ingen bra plats att ligga på. "; exit;  }
    }
    dobjFor(StandOn)
    {
        verify() { }
        check() { "Du gör redan det. "; exit; }
    }
    iobjFor(PutOn) remapTo(Drop, DirectObject)

    dobjFor(Cross)
    {
        verify() { }
        action() { "(Om du vill fortsätta över, säg bara åt vilket håll.) "; }
    }

    dobjFor(Push)
    {
        verify() { }
        action() { "Bron gungar oroväckande. "; }
    }
    dobjFor(Pull) asDobjFor(Push)
    dobjFor(Move) asDobjFor(Push)
;

class RopeBridgeCanyon: Distant
    'brant+a vertikal+a ravin+en/flod+en/(vägg+en)/klippa+n*(väggar+na) klippor+na'
    'ravin'
    "Du är säker på att du missar en fantastisk utsikt, men just nu är du
    för fixerad vid att inte falla för att lägga märke till något. "

    iobjFor(ThrowAt)
    {
        verify() { }
        check()
        {
            "Bäst att inte göra det; de har väldigt hårda straff för nedskräpning
            här omkring. ";
            exit;
        }
    }
;

class RopeBridgeMainBridge: Distant
    'huvudbro+n/undersida+n/balkar+na' 'huvudbro'
    "Huvudbron är synlig ovanför och en bit österut. "

    dobjFor(Examine)
    {
        /* make this less likely, like decorations */
        verify()
        {
            inherited();
            logicalRank(70, 'x fjärran');
        }
    }
;

/* ------------------------------------------------------------------------ */
    
/*
 *   The bridge - part 1 
 */
ropeBridge1: RopeBridgeRoom 'Södra änden av repbron'
    'södra änden av repbron' 'repbro'
    "Att stå på den här bron är mycket svårare än det såg ut
    från plattformen. Hela saken vill vika ihop sig under
    din vikt, och nätverket av rep som utgör gångbanan förskjuts
    med varje steg. "

    north = ropeBridge2
    south = s2Platform

    atmosphereList: StopEventList {
    [
        'En skarp vibration skakar genom bron, som om
        någon slog i ett av repen med en hammare. ',
        'En liten vindpust får bron att gunga oroväckande. ',
        'Repen knakar och knarrar oroväckande. ',
        nil
    ] }
;

+ RopeBridge;
+ RopeBridgeCanyon;
+ RopeBridgeMainBridge;


/* ------------------------------------------------------------------------ */
/*
 *   The bridge - part 2
 */
ropeBridge2: RopeBridgeRoom 'Mitten av repbron'
    'mitten av repbron' 'repbro'
    "Detta är ungefär halvvägs över bron. Härifrån är
    brons ändar så långt borta att de knappt är synliga,
    vilket nästan får det att kännas som om bron svävar i luften
    över kanjonen. "

    south = ropeBridge1
    north = ropeBridge3

    atmosphereList: StopEventList {
    [
        'Hela bron faller plötsligt ned ungefär en meter, och stannar sedan
        med ett ryck. Xojo tittar bakåt och skrattar nervöst. ',
        'Vinden ökar lite. Bron gungar och vrider sig. ',
        'Ett högt knäppande ljud kommer någonstans bakom dig. ',
        'Repen knakar och knarrar. ',
        nil
    ] }
;

+ RopeBridge;
+ RopeBridgeCanyon;
+ RopeBridgeMainBridge;

/* ------------------------------------------------------------------------ */
/*
 *   The bridge - part 3 - the fall 
 */
ropeBridge3: RopeBridgeRoom 'Hängande på en repbro'
    'den hängande repbron' 'repbro'
    "Det som en gång var en repbro hänger nu vertikalt längs
    kanjonens norra klippvägg. Lyckligtvis verkar brons konstruktion
    vara användbar som en stege. Det ser ut att bara vara
    cirka femton meter till klippans topp ovanför; resten av
    bron fortsätter en bit nedåt. "

    enteringRoom(traveler)
    {
        if (traveler == me)
        {
            /* uh-oh... */
            "Du tror att du börjar få grepp om det här, och du rör dig
            framåt med lite mer självsäkerhet. Brons norra ände
            kommer äntligen inom synhåll - inte mycket kvar nu.
            <.p>Bron skakar med en skarp stöt och vrider sig åt
            vänster. Du stannar och håller dig fast. Vibrationen avtar,
            men gångbanan är fortfarande i en konstig vinkel, så du försöker
            flytta din vikt för att kunna räta upp dig. En annan skakning, och
            bron vrider sig ännu mer, faller sedan ungefär två meter och rycker
            till med ett abrupt stopp. Ditt hjärta slår hårt och du håller fast 
            dig så hårt du kan.
            <.p>Xojo tittar bakåt. <q>Kanske vi borde---</q>
            <.p>Bron ger vika, och du faller fritt. Du håller
            fast i repet av reflex, men det faller bara med dig.
            Kanske inte ändå: repet rycker till och börjar dra
            dig mot kanjonens norra vägg. Plötsligt faller du i sidled
            snarare än nedåt, den norra klippväggen närmar sig 
            snabbt. Du förbereder dig för krocken precis innan du slår
            in i klippväggen.
            <.p>Efter ett par studsar stannar du mer eller mindre av.
            Du undersöker på dig själv, och det verkar inte som om du blöder.
            Kanske är du så dränkt i adrenalin att du inte inser
            hur allvarligt skadad du är än, men du verkar inte ha
            några allvarliga skador; du är utan tvekan lite blåslagen,
            men inga större kroppsdelar verkar brutna eller saknas. Det ser dock ut som
            att du tappade en av dina skor. ";

            /* lose the shoe */
            myShoes.moveInto(nil);
            myLeftShoe.makePresent();
        }
    }

    up: TravelMessage { -> canyonNorth
         "Det är lite jobbigt, men repnätet från den tidigare gångbanan
         fungerar faktiskt ganska bra som en stege. Du tar dig upp till toppen
         av klippan på nolltid, och Xojo hjälper dig upp över
         kanten. " }

    down: FakeConnector { "Du gör lite snabb huvudräkning: kanjonen
         är ungefär hundra meter bred, vad du minns, och
         tvåhundra meter djup. Om hela bron fortfarande är intakt, betyder det
         att den tidigare södra änden fortfarande skulle vara ungefär hundra
         meter ovanför kanjonens botten. Uppåt verkar vara ett mycket
         bättre alternativ. " }

    roomBeforeAction()
    {
        inherited();
        if (gActionIs(Stand) || gActionIs(StandOn))
        {
            "Att stå upp är inte riktigt ett alternativ just nu. ";
            exit;
        }
    }
;

+ RopeBridgeMainBridge;

+ Distant 'flod+en/kanjon+en' 'kanjon'
    "Du föredrar att inte titta ner så mycket just nu. "
    tooDistantMsg(obj)
        { return 'Du föredrar att inte titta ner så mycket just nu. '; }
;

+ Fixture 'norra n kanjonens klippvägg+en kanjonvägg+en/klipp+an' 'kanjonvägg'
    "Det är en nästan vertikal klippvägg. "
;

+ RopeBridge
    desc = "Den kollapsade bron hänger vertikalt från ovan. "
        
    dobjFor(Climb) remapTo(Up)
    dobjFor(ClimbUp) asDobjFor(Climb)
    dobjFor(ClimbDown) remapTo(Down)
    dobjFor(Cross) { action() { "Det är uteslutet vid det här
        tillfället; att klättra verkar mer troligt. "; } }
;

/* ------------------------------------------------------------------------ */
/*
 *   North edge of canyon 
 */
canyonNorth: OutdoorRoom 'Kanten av kanjonen' 'kanten av kanjonen'
    "Detta är ett kuperat område fullt av stenar och igenvuxen
    med vegetation. I söder stupar kanjonens branta klippvägg ner 
    nästan vertikalt. En liten stig som leder nordost har huggits
    genom den täta växtligheten.
    <.p>Änden av repbron är förankrad vid ett par
    stadiga metallpålar som drivits ner i klippan. Själva
    bron hänger slappt över kanten av kanjonen. "

    northeast = canyonPath
    down: NoTravelMessage { "Inget skulle kunna övertala dig att klättra tillbaka
        ner på bron. "; }

    roomBeforeAction()
    {
        if (gActionIn(Jump, JumpOffI))
        {
            "Du föredrar att hålla dig på avstånd från kanjonen. ";
            exit;
        }
    }
;

+ canyonPath: TravelWithMessage, PathPassage ->courtyardPath
    'liten lilla stig+en' 'stig'
    "Stigen leder nordost, genom den täta växtligheten. "

    travelDesc = "Du följer stigen genom den täta växtligheten. "
;

+ Decoration 'sten+en*stenar+na' 'stenar'
    "Stenar i alla storlekar ligger utspridda över området. "
    isPlural = true
;
+ Decoration  'tät+a frodig+a tropisk+a växt+en/växter+na/vegetation+en/igenväxt+en/djungel+n/lövverk+et/igenväxt+en'
    'vegetation'
    "Den täta, frodiga vegetationen växer nästan ända fram till
    klippkanten. Det enda sättet att ta sig igenom är stigen som leder nordost. "
    isMassNoun = true
;

+ cnRopeBridge: StairwayDown 'repbro' 'repbro'
    "Bron hänger över kanten av kanjonen och försvinner
    ner i fjärran. "

    dobjFor(TravelVia)
    {
        check()
        {
            "Inget skulle kunna övertala dig att sätta foten på den där igen. ";
            exit;
        }
    }
    dobjFor(Pull)
    {
        verify() { }
        action() { "Bron är alldeles för tung för att flytta. "; }
    }

    dobjFor(Cross) { verify() { illogical('Den är mer som en stege
        än en bro vid det här laget, så det är inte något du
        kan gå över längre. '); } }

    dobjFor(Board) asDobjFor(TravelVia)
    dobjFor(Enter) asDobjFor(TravelVia)
;

+ Fixture 'robust+a metallpåle+n/pålar+na/par+et' 'metallpåle'
    "Pålarna är djupt nedslagna i klippan för att skapa ett stabilt ankare. "

    dobjFor(Pull)
    {
        verify() { }
        action() { "Pålarna sitter ordentligt fast i klippan. "; }
    }
;

+ Distant  'brant+a klippa+n flod+en/kanjon+en/vägg+en/klippa+n/väggar+na/klippor+na/kant+en' 'kanjon'
    "Utsikten över kanjonen är inte dålig härifrån, men du vill inte
    komma för nära kanten. "

    dobjFor(JumpOff) remapTo(Jump)
    dobjFor(JumpOver) remapTo(Jump)
;
/* ------------------------------------------------------------------------ */
/*
 *   Plant courtyard 
 */
plantCourtyard: OutdoorRoom 'Innergård' 'innergården'
    "Ett stort område av djungeln har röjts undan för att skapa denna innergård.
    Den enorma administrativa huvudbyggnaden omsluter området i norr och
    öster, och låga trästaket håller djungeln på avstånd i söder och väster.
    En smal stig leder sydväst in i djungeln. En uppsättning dörrar i öster
    leder in i byggnaden.
    <.p>Flera helikoptrar---du räknar till fem---står parkerade här, med
    rotorbladen som fortfarande snurrar långsamt. Dussintals personer som
    bär svarta Mitachron-logotypsförsedda polotröjor rusar omkring, många bär på
    lådor eller packlårar."

    vocabWords = 'innergård+en'

    in = adminDoorExt
    east asExit(in)
    southwest = courtyardPath

    atmosphereList: ShuffledEventList {
        ['Mitachron-folket är här i full styrka, det är säkert; all
         denna aktivitet måste vara för att sätta upp en omedelbar
         demonstration. Det var verkligen tur att du lät Xojo ta dig över
         den där repbron trots allt; om det hade tagit längre tid att
         komma hit, kunde de faktiskt ha lyckats stjäla denna affär
         från dig. Som tur är verkar du ha kommit hit i tid.']
        ['En av Mitachron-personerna är nära att krocka med dig med
         något som ser ut som en golfbagväska, men du lyckas hoppa undan.',
         'En Mitachron-kvinna med en skrivplatta susar förbi, säger
         något i sitt headset om is.',
         'Två Mitachron-män släpar förbi en uppenbarligen mycket tung
         metallåda som påminner om en ångbåtskoffert.',
         'Mitachron-anställda bär flitigt saker in och ut ur
         helikoptrarna.',
         'Flera Mitachron-arbetare skyndar förbi bärande på någon tung
         utrustning.']
    }
;

+ courtyardPath: PathPassage 'smal+a stig+en' 'stigen'
    "Stigen leder sydväst in i djungeln. "
;

+ Distant 'frodig+a tropisk+a djungel+n/växt+en/växter+n/vegetatio+en/växtlighet+en' 'djungel'
    "Vegetationen är frodig, tropisk och mestadels obekant för dig. "
;

+ Decoration 'låg:t+a trä|staket+et*trä|staketen+a' 'trästaket'
    "Staketen markerar innergårdens gränser i söder och väster.
    Djungeln ligger bortom. "
;

+ Decoration
    'fem svarta mitachron helikopter+n*helikoptrar+na' 'helikoptrar'
    "De är alla identiska: varje är helt svart, förutom den gula
    Mitachron-logotypen på stjärtbommen. "

    isPlural = true
    notImportantMsg = 'Du vill inte komma för nära helikoptrarna;
                      Mitachron-folket kanske inte uppskattar att en
                      Omegatron-anställd nosar omkring. '
;
++ Decoration 'helikopter|rotor+n/helikopter|rotorer+na/rotorblad+en' 'rotorer'
    "Rotorerna snurrar fortfarande långsamt, som om piloterna höll
    helikoptrarna redo för en plötslig avfärd. "
;

++ Decoration 'gul+a mitachron+logo+prydda helikopterbomm+en/fenstronaxel+n*stjärtbommar+na fenstron+axlar+na' 'stjärtbommar'
    "Stjärtbommarna på varje helikopter är målad med Mitachron-logotypen. "
    isPlural = true
;

+ Decoration 'gul+a mitachron logotyp+en/logo+n' 'mitachron-logotyp'
    "Mitachron-logotypen är ett stort gult <q>M</q> i ett kraftigt sans-serif
    action-lutande typsnitt, överlagrat på en ljusgul kontur av en
    glob. Du har alltid tyckt att det symboliserar Mitachrons
    världsherravälde. "
;

+ Decoration
    'mitachron-logotyps+försedda polotröjor+na anställd+a/anställda/arbetare/skjorta+n/skjortor+na/
    folk+et/man+nen/kvinna+n*män+nen kvinnor+na'
    'mitachron-folk'
    "Mitachron-folket går alla snabbt och målmedvetet, med uttryck av
    allvarlig beslutsamhet i ansiktena. De verkar stressade men inte
    panikslagna, som om de vet exakt vad de gör men inte har någon tid
    att förlora. De flesta bär lådor eller packlårar, och några bär
    skrivplattor och dirigerar de andra. "

    isPlural = true
    notImportantMsg = 'Du verkar inte kunna få någons uppmärksamhet. '
;
++ Decoration 'låda+n/packlår+en/lådor+na/packlårar+na/skrivplattor+na/headset+en/koffert+en/utrustning+en'
    'Mitachron-grejer'
    "Sakerna de bär på är av litet intresse för dig, förutom att allt
    detta förmodligen är för en omedelbar demonstration, vilket du gärna
    vill förekomma om möjligt. "
    isMassNoun = true
;

+ Enterable 'väldiga administrativa huvudbyggnad+en*byggnader+na'
    'administrativa huvudbyggnaden'
    "Byggnaden är enorm: den sträcker sig hundratals meter från söder till
    norr, svänger sedan runt ett hörn och fortsätter hundratals meter från
    öster till väster. En uppsättning dörrar i öster leder in. "

    connector = adminDoorExt
;
+ adminDoorExt: Door ->adminDoorInt
    'administrativa huvudbyggnaden+s dörr+en/dörrar+na/uppsättning+en'
    'administrationsdörrar'
    "Dörrarna leder in i byggnaden åt öster. "

    isPlural = true
;

/* ------------------------------------------------------------------------ */
/*
 *   The administration building lobby 
 */
adminLobby: Room 'Lobby' 'lobbyn'
    "Vid tidigare besök på administrationscentret var denna stora, öppna lobby
    ganska spartansk och funktionell, men den har förvandlats: den är
    festlig, färgglad, nästan karnevalsliknande. Rummet är fullt av
    människor som pratar och dansar. Ballonger och konfetti fyller luften,
    ett liveband spelar från en scen, bord fyllda med mat kantar väggarna,
    servitörer slingrar sig genom folkmassan med stora brickor med drycker.
    <.p>En uppsättning dörrar leder ut västerut."

    vocabWords = 'lobby+n'

    west = (gRevealed('talked-to-magnxi') ? noWest : adminDoorInt)
    out asExit(west)

    noWest: FakeConnector { "Du försöker ta dig till dörrarna, men
        du kan inte komma igenom folkmassan. "; }

    /* 
     *   reaching this room is a time-based plot point, so set a marker
     *   here 
     */
    afterTravel(traveler, conn)
    {
        inherited(traveler, conn);
        plotMarker.eventReached();
    }

    /* arrive here at about noon */
    plotMarker: ClockEvent { eventTime = [1, 12, 8] }
    
    atmosphereList: ShuffledEventList {
        ['<q>Ursäkta!</q> ropar en servitör. Du gör tillräckligt med plats
         för att han ska kunna passera, och han rör sig bort genom folkmassan.',

         'Bandet avslutar en låt till en runda applåder, sedan börjar de
         en ny.',

         'En grupp skrattande människor tränger sig förbi dig.',

         'Bandet spelar en något lugnare passage en kortare stund, sedan ökar tempot
         och volymen blir ännu högre än tidigare.',

         'Tempot i musiken saktar ner lite, och det blir lite mindre
          bullrigt.',

         'Musiken ändras till en långsammare danslåt.',

         'Det improviserade dansområdet verkar expandera till där du står,
         vilket tvingar dig att flytta dig lite.']
    }
;

+ adminDoorInt: Door 'dörr+en/dörrar+na/uppsättning+en' 'dörrar'
    "Dörrarna leder ut västerut."
    isPlural = true

    dobjFor(TravelVia)
    {
        check()
        {
            if (gRevealed('talked-to-magnxi'))
            {
                "Du försöker lämna, men det är för många människor
                som blockerar vägen genom dörrarna. ";
                exit;
            }
        }
    }
;

+ Decoration
    'festande anläggning+en mitachron arbetarn+a/publik+en/anställda/folk+massa+n*folk' 'folkmassa'
    "Det ser ut som om de mestadels är anläggningsanställda, men många
    Mitachron-personer är också här."
    isPlural = true
    /* use normal Thing Examine verification rules */
    dobjFor(Examine) { verify() { inherited Thing(); } }
;

+ Decoration 'bricka+n*servitörer+na servitriser+na brickor+na' 'servitörer'
    "Servitörerna rör sig genom folkmassan bärande på drycker."
    isPlural = true
;

+ Decoration 'dryck+en/drycker+na/cocktail+en/cocktails/glas+en' 'drycker'
    "Servitörerna rör sig så snabbt att du inte kan se exakt vilka
    drycker de har, men det ser ut att vara ett brett utbud av cocktails."
    isPlural = true

    dobjFor(Take)
    {
        verify() { }
        action() { drinkScript.doScript(); }
    }
    dobjFor(Drink) asDobjFor(Take)

    drinkScript: StopEventList { [
        'Du är normalt inte mycket för att dricka, men just nu skulle
        du verkligen behöva något för att lugna nerverna. Du tar ett
        glas från en passerande servitörs bricka och sveper det i en
        klunk. Praktiskt taget i samma ögonblick som du är klar samlar
        en servitör som går åt andra hållet in ditt glas.',

        'Du tar ytterligare en drink från en passerande servitör och
        sväljer den, lite mindre frenetiskt den här gången. En servitör
        samlar in glaset när du är klar.',

        'Bäst att inte överdriva; du behöver fortfarande upprätthålla
        en affärsmässig hållning.']
    }

    notImportantMsg = 'Dryckerna är inte särskilt intressanta
        bortsett från deras alkoholinnehåll.'

    dobjFor(GiveTo)
    {
        preCond = []
        verify() { }
        check()
        {
            "Finns ingen anledning; {ref iobj/han} kan förse sig själv om
            {han iobj/subj} vill. ";
            exit;
        }
    }
;

+ Decoration 'ballonger+na/konfetti+n/dekorationer+na' 'dekorationer'
    "Dekorationerna får den normalt spartanska lobbyn att se festlig ut."
    isPlural = true
;

+ Decoration 'mat|bord+et' 'bord med mat'
    "Bord fyllda med mat kantar väggarna."
    notImportantMsg = 'Du tror att du väntar med att ansluta dig till festen
                       tills du har haft en chans att prata med Översten.'
    isPlural = true
;

+ Decoration 'liveband+et/scen+en' 'band'
    "De spelar storbandsmusik. De verkar ganska bra."
    dobjFor(ListenTo) { verify() { logicalRank(50, 'x decoration'); } }
;

++ SimpleNoise 'storband+et storband^s+musik/låt+en' 'musik'
    "Livebandet spelar storbandsmusik."
;

/* 
 *   once Frosst is mentioned, create an object for his un-presence, in
 *   case the player assumes he hasn't actually left yet 
 */
+ adminUnFrosst: PresentLater, Unthing
    'smal+a blek+a junior (mitachron) frosst belker/chef+en/man+nen*män+nen'
    'Frosst Belker'

    isProperName = true
    isHim = true

    notHereMsg = 'Du ser inte Frosst Belker här; han gick härifrån efter
        att ha pratat med Översten.'

    dobjFor(Follow)
    {
        verify() { }
        action() { "Det är så trångt att du tappade bort
            Frosst Belker så fort han gick iväg. "; }
    }
;


/* ------------------------------------------------------------------------ */
/*
 *   The colonel 
 */
magnxi: Person 'överste höga administratör+en magnxi/kvinna+n*kvinnor+na'
    'Överste Magnxi'
    "Hennes officiella titel är Höga Administratör Magnxi, men hon
    insisterar på att alla använder hennes militära titel, och hon bär
    alltid en uniformsklänning som ser ut som något från Napoleontiden.
    Du har dock aldrig sett henne bära den här hatten förut; den driver
    upp bisarrheten i hennes outfit till en helt ny nivå."
    isProperName = true
    isHer = true

    /* we know about the colonel from the start */
    isKnown = true

    scoreMarker: Achievement { +1 "att få Överste Magnxis uppmärksamhet" }

    beforeAction()
    {
        /* do the normal work */
        inherited();

        /* special handling if throwing something at the colonel */
        if (gActionIs(ThrowAt) && (gIobj == self || gIobj.isIn(self)))
        {
            "Översten kanske skulle uppleva det irriterande, vilket är det
            sista du vill just nu. ";
            exit;
        }
    }
;

+ InitiallyWorn
    'uniformsklänning+en uniform+en/skärp+et/band+et/medalj+en/outfit+en*medaljer+na/epåletter+na'
    'uniform'
    "Det är som ett museiföremål från 1800-talet: skärp, band, medaljer,
    epåletter, hela paketet."

    /* 
     *   The English library tries hard to guess whether to use 'a' or
     *   'an', but 'u' words are too unpredictable for the library to get
     *   them right every time, and this is one that it gets wrong.  So, we
     *   need to override the aName to make it 'a uniform'.  
     */
    aName = 'en uniform'

    isListedInInventory = nil
;

+ InitiallyWorn 'hatt+en/militär+hatt+/insignier+na/emblem+en/brätte+t' 'hatt'
     "Den är otroligt stor; den har proportioner som en kockmössa,
    löjligt hög och ballongformad utåt mot toppen, men den är mörkblå, gjord av styvt material och prydd med militära emblem. Den är ungefär två storlekar
    för stor för Överstens huvud, och som ett resultat sitter den alldeles
    för lågt på hennes huvud, nästan täckande hennes ögon."

    isListedInInventory = nil
;

+ Decoration 'liten lilla grupp+en människor+na/följeslagare*människor+na följeslagarna' 'liten grupp människor'
    "Platsen är så trång att du inte kan se vilka hon är med."
    theDisambigName = 'Överste Magnxis följeslagare'
;

+ InConversationState
    /* 
     *   this won't actually be used, since we end the scene as soon as we
     *   start a conversation with the colonel, but we need it to fit the
     *   standard structure 
     */
;

/* 
 *   to allow entering a conversation, we need a topic to handle the
 *   response; but we don't actually need a response, since we handle
 *   everything just by starting the conversation 
 */
++ DefaultAnyTopic "";

++ ConversationReadyState
    isInitState = true
    stateDesc = "Hon pratar med en liten grupp människor."
    specialDesc = "Överste Magnxi är här och pratar med en grupp människor."

    tries = 0
    enterConversation(actor, entry)
    {
        switch (++tries)
        {
        case 1:
            "<q>Överste Magnxi!</q> ropar du och försöker höras över
            musiken, men brassektionen väljer just i detta ögonblick att
            bli riktigt högljudd. Översten verkar inte höra dig.";
            break;

        case 2:
            "Du tränger dig genom folkmassan och viftar med armarna,
            ropande lite högre. <q>Överste! Överste Magnxi!</q>
            Hon tittar åt ditt håll som om hon faktiskt hörde dig den här
            gången, men en servitör skär av framför dig. Servitören går
            iväg, men Överste Magnxi pratar med någon annan nu igen.";
            break;
        case 3:
            "Du skriker av full hals. <q>Överste Magnxi!</q>
            Precis när du gör det stannar musiken - ditt skrik ekar
            genom det plötsligt tysta rummet. Alla vänder sig om och 
            tittar på dig.
            <.p>Översten stirrar på dig tillsammans med alla andra
            ett ögonblick, sedan ler hon. <q>Åh, så trevligt att se dig
            igen,</q> säger Översten med sin perfekta engelska accent.
            Hon kisar och vinglar lite, som om hon har druckit en del.
            <q>Herr, öh, Herr Muddling, inte sant? Nå, kom och anslut dig
            till oss. Vi firade just vårt nya partnerskap med Mitachron
            Corporation. Är det inte en underbar fest som Mitachron
            anordnar för oss?</q>
            <.p>Nytt partnerskap? <q>Men, men...</q> stammar du, utan
            att tro på vad du hör.
            <.p>Bandet börjar en ny låt, lite mindre öronbedövande
            än den förra. <q>Och har du sett min briljanta nya hatt?</q>
            frågar hon och låter fingrarna glida längs det överdimensionerade
            brättet. <q>Det är en gåva från herr Belker här.
            Frosst, det är verkligen för mycket.</q>
            <.p>Åh nej. Du såg honom inte här förrän just nu. Den
            smala, bleka mannen som står bredvid Magnxi är Frosst Belker,
            en junior chef på Mitachron. Du har stött på honom förut,
            alltid vid tillfällen precis som detta.
            <.p><q>Ah, herr Mittling,</q> säger Belker med det där
            förbannade leendet. Han talar med en svag accent som du
            aldrig lyckats placera, hans vokaler lite utdragna och nasala,
            hans konsonanter lite för tydligt uttalade.
            <q>Återigen ser vi att det inte finns någon kund du kan
            uppvakta som jag inte kan ta ifrån dig.</q> Han avslutar sin champagne
            och räcker glaset till en passerande servitör. <q>Överste, ett nöje
            att göra affärer, som alltid. Jag måste ge mig av, men njut av
            festen.</q> Han och Översten omfamnar varandra som diplomater,
            och sedan vänder han sig för att gå, men han stannar ett ögonblick och
            tittar åt ditt håll. <q>Du också, naturligtvis, herr Mittling,</q>
            säger han med ett annat leende, skrattar sedan och går iväg,
            försvinnande in i folkmassan.
            <.p>Översten återgår till att mingla.
            <.reveal talked-to-magnxi> ";

            /* award some points for getting her attention */
            magnxi.scoreMarker.awardPointsOnce();

            /* move the departed frosst here */
            adminUnFrosst.makePresent();

            /* one last task for xojo */
            xojo.addToAgenda(xojoEmailAgenda.setDelay(1));

            /* all done */
            break;

        case 4:
        default:
            "Du försöker att få överstens uppmärksamhet igen, men hon är
            för upptagen med att prata med någon annan. ";
            break;
        }

        /* 
         *   we can never actually enter a conversation, so stop the
         *   command here 
         */
        exit;
    }
;

adminEmail: Readable 'papper^s+utskrift+en/papper^s+bit+en/utskrift+en/email+et/e-mail+et'
    'utskrift'

    "Det är en utskrift från en gammal radskrivare, tryckt på
    kontinuerligt vikpapper med alternerande ränder av vitt och
    blekgrönt. Det är ett e-postmeddelande från din chef; han måste vara
    tillbaka från Maui. Det är i hans karakteristiska stil med enbart gemener;
    han gör det för att imponera på folk att han är för viktig för att
    slösa sin värdefulla tid på att trycka på Shift-tangenten. Hans stavning och
    interpunktion är på liknande sätt effektiviserade.

    <.p><.blockquote>
    <tt>doug- hoppas du är klar med demon nu.....när du kommer tillbaka
    vill jag att du åker ner till la för att rekrytera en cal tech-student som heter
    brian stamer.\ rudyb såg en artikel om honom någonstans han är helt i
    eld och lågor om att anställa honom.\ känner du honom....i alla fall vill rudyb att du
    åker eftersom du gick på cal tech.

    <.p>tack carl

    <.p>förresten- jag är borta från kontoret nästa månad....viktig konferens
    på fiji.\ jag börjar bli utbränd av allt detta resande så jag tänker
    ta lite ledigt när jag kommer tillbaka.\ bara maila om du behöver något.

    <.p>förresten igen- o-travel fick ett jättebra!!!\ pris på din returresa.\
    de hittade en nedgradering till economy-minus, den har ett par
    extra mellanlandningar, jag är säker på att du inte har något emot det.\ sparar stora $$$ i budgeten,
    fiji pressade den lite, rudyb säger liksom att du överskrider budgeten
    för mycket igen så vi måste alla hjälpas åt att skära ner mer på kostnaderna.

    <.p>ha så kul i la!!!!!!!!!!!!!
    </tt>
    <./blockquote>

    <.p>Toppen. Du är inte ens tillbaka från den här eländiga resan än och
    du har redan en till inbokad. Nåja. Lika bra att
    ordna med oxkärran tillbaka till flygplatsen, eller vad det nu är som
    den nya, lägre budgeten tillåter... "

    dobjFor(Examine)
    {
        action()
        {
            /* show the message */
            inherited();

            /* run the campus initialization */
            campusInit();

            /* end the turn here */
            exit;
        }
    }
;

