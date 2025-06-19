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
phoneCallTopic: Topic 'telefon mobil mobiltelefon cell samtal';

/* elevators in general */
elevatorTopic: Topic 'hiss/elevator/lift';

/* some resume-related topics */
hiringFreezeTopic: Topic 'omegatron anställningsstop';
kowtuan: Topic 'kowtuan tekniska institut/universitet/skola';
chipTechNo: Topic 'halvledare kemisk applikator
    chiptechno/tillverkare/operationer/åtgärder';

/* the power plant itself */
powerPlant6: Topic '6 regeringskraftverk';

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
        '6 regeringens kraftverk' 'Regeringens kraftverk #6'

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
deetCloud: Vaporous 'dimmigt kraftfullt giftigt insekts
    spray/medel/dimma/moln/ånga/bekämpningsmedel'
    'moln av insektsmedel'
    "Den dimmiga ångan hänger i luften genom hela rummet. "
;
+ Odor
    isAmbient = true
    sourceDesc = "Det har en vidrig kemisk lukt. "
    hereWithSource = "En giftig dimma av insektsmedel fyller luften. "
;

/* tanken */
deetTank: Thing 'kraftfull resväskestor metall insekts tank/slang/medel'
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
    "Detta är det trånga kontrollrummet i Statligt Kraftverk #6.
    Redan innan du kom var detta rum så proppfullt med utrustning
    att det knappt gick att vända sig om. Nu när du har lagt till den
    kylskåpsstora SCU-1100DX:en är det ungefär lika mycket fritt utrymme
    som i det <q>budgetekonomiklass</q>-flygplanssäte du var inklämd i under
    femton timmar på flygresan hit. Den enda utgången är västerut. "

    vocabWords = 'kontrollrum'

    /* going west takes us to the power control hallway */
    west = powerControlDoorway
    out asExit(west)

    /* some atmospheric messages */
    atmosphereList: ShuffledEventList {
        [
            'Du märker att en mygga landar på din arm och lyckas slå till
            den innan den hinner bita. ',
            'Du känner något på din nacke och inser för sent att
            det är en mygga som just flyger iväg. ',
            'En mygga surrar förbi bara centimeter från ditt öra. ',
            'Flera av dina myggbett börjar klia. ',
            'En mygga flyger långsamt förbi ditt huvud. ',
            'Luftfuktigheten blir definitivt värre. ',
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
    'väst v dörr/dörröppning' 'dörröppning'
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
+ xojo: TourGuide, Person 'xojo/man/byråkrat*män' 'Xojo'
    "Han är en lågnivåbyråkrat som tilldelats att hjälpa dig med 
    SCU-1100DX-installationen. Han ser ung ut, kanske i mitten av 
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
            "<.p><q>Jag hoppas du ser vilken initiativrik anställd
            jag skulle vara,</q> säger Xojo, lite ansträngd av din vikt. ";

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
    'cirriculum resume/r\u00E9sum\u00E9/cv/c.v./vitae/papper/pappret'
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
    "<q>Har du något du kan berätta om Översten?</q> frågar du.
    <.p><q>Jag tar dig till henne nu,</q> svarar han. "

    /* this is active as soon as we're on our way to see the colonel */
    isActive = (scu1100dx.isOn)
;

++ GiveTopic @xojoResume
    "Du erbjuder tillbaka CV:t till Xojo, men han bara viftar med
    händerna. <q>Snälla,</q> säger han, <q>behåll det för din
    framtida övervägande.</q> "
;

++ DefaultCommandTopic
    "Xojo avböjer artigt och säger att hans rang är för låg för
    att kunna hjälpa till på det sättet. "

    isConversational = nil
;

++ AskTellTopic @xojo
    "<q>Berätta om dig själv,</q> säger du.
    <.p><q>Jag är här för att hjälpa dig,</q> svarar Xojo. "
;

++ AskTellShowTopic +90 @guanmgon
    "<q>Berätta om Guanmgon,</q> säger du.
    <.p>Xojo pausar ett ögonblick. <q>Han är mycket kvalificerad att
    hjälpa dig,</q> säger han till slut. "
;

++ HelloTopic
    "<q>Hur kan jag hjälpa till?</q> frågar Xojo. "
;

++ DefaultAnyTopic, ShuffledEventList
    ['<q>Min överordnade, Guanmgon, skulle vara bättre kvalificerad än
    jag att hjälpa dig i denna fråga,</q> säger Xojo. ',
    '<q>Jag måste överlåta sådana frågor till mina överordnade,</q> säger Xojo. ',
    'Xojo tänker ett ögonblick. <q>Kanske borde du rådfråga min överordnade,
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
    "Det är ingen idé att göra det; Xojo är ungefär fyrtiofem
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
    och träffa Överste Magnxi direkt. "

    isActive = (scu1100dx.isWorking && scu1100dx.isOn)
    isConversational = nil
;

++ GiveShowTopic [ct22, s901, xt772hv, tester, testerProbe, xt772lv]
    "Du tror att han verkligen skulle vilja hjälpa till, men det har blivit tydligt att
    all bisarr byråkrati här hindrar Xojo från att faktiskt göra
    något som skulle likna reparationsarbete. "

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
    "<q>Jag vill verkligen inte korsa den där repbron,</q> säger du.
    <.p><q>Det är vår mest effektiva väg,</q> säger
    Xojo, <q>men kanske kunde vi vänta på reparationen av
    hissen, om du föredrar det.</q> "
;

/* Repbro-svar för när vi är på plattformen */
+++ AltTopic, StopEventList
    ['<q>Är du seriös?</q> frågar du. <q>Du vill verkligen gå över
    repbron?</q>
    <.p><q>Jag beklagar,</q> säger han, <q>men det är den mest effektiva vägen.
    Den enda möjligheten till ett alternativ är att invänta färdigställandet av
    reparationerna på hissen.</q> ',
    '<q>Varför finns den här ens här?</q> frågar du skeptiskt.
    <.p><q>Peon-gradspersonalen får normalt inte lämna
    källarvåningarna under arbetstid,</q> säger Xojo.
    <q>En grupp sub-peoner byggde detta i hemlighet, för att möjliggöra avfärd
    och senare återkomst utan upptäckt av överordnade funktionärer.</q> ',
    '<q>Den här bron ser inte särskilt säker ut,</q> säger du.
    <.p><q>Jag har använt den personligen, under min egen Peon-gradsperiod
    av anställning,</q> försäkrar Xojo dig. <q>Använd bara försiktighet för att göra
    överfarten relativt fri från överdriven fara.</q> ',
    '<q>Är du verkligen säker på att detta är enda vägen över?</q> frågar du.
    <.p><q>Jag är tyvärr tvungen att svara jakande,</q>
    säger Xojo. ']

    isActive = (xojo.isIn(s2Platform))
;

/* Repbro-svar för när vi börjar korsa bron */
+++ AltTopic
    "<q>Är du verkligen säker på att den här är säker?</q> frågar du.
    <.p><q>Jag har korsat den flera gånger,</q> säger han. <q>Snälla,
    vi borde skynda oss.</q> "

    isActive = (xojo.isIn(ropeBridge1) || xojo.isIn(ropeBridge2))
;

/* Repbro-svar efter att bron kollapsar */
+++ AltTopic
    "<q>Du sa att den här var säker!</q> skriker du.
    <.p><q>Förlåt,</q> säger Xojo. <q>Det här har bara hänt en
    eller två gånger förut. Kom, vi kan klättra upp härifrån.</q> "

    isActive = (xojo.isIn(ropeBridge3))
;

/* Repbro-svar när vi är förbi den */
+++ AltTopic
    "<q>Jag kan fortfarande inte tro att du fick mig att korsa den där
    repbron,</q> säger du.
    <.p><q>Medges, faronivån var inte noll,</q> säger Xojo. "

    isActive = (me.hasSeen(canyonNorth))
;

/* in-conversation state for xojo */
++ InConversationState
    stateDesc = "He's waiting attentively. "
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
    ['Du tittar på Xojo. <q>Ursäkta...</q>
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
    'koffee brand business (man\'s) aluminum aluminium 12-ounce 12 ounce
    beverage/koffee/coffee/can'
    'burk Koffee'
    "Ja, det är Koffee med K: Koffee brand Business Man's Beverage,
    det 100% oorganiska valet, förpackat i en 33 cl aluminiumburk.
    Det verkar som att du stöter på denna hemska ToxiCola Corporation-produkt
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
                "Bättre att låta bli; vem vet vad den giftiga vätskan skulle
                göra med {that dobj/him}. ";
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
    stateDesc = "Han väntar på att du ska slå honom följe. "
    showGreeting(actor) { "Du har redan Xojos uppmärksamhet. "; }

    justFollowed(success)
    {
        local st;
        
        /* 
         *   if they made us follow them, it means they're not going where
         *   we're trying to guide them; let them know 
         */
        "Han ser lite otålig ut.  <q>Varsågod, den här vägen.</q> ";

        /* make sure we're in the right state for the new location */
        st = instanceWhich(XojoEscortState, {x: x.stateLoc == xojo.location});
        if (st != nil)
            xojo.setCurState(st);
    }
;

/* waiting in the control room to escort us to the colonel */
++ xojoEscortControl: XojoEscortState
    stateLoc = powerControl

    stateDesc = "Han väntar på dig att slå honom följe genom dörröppningen. "
    specialDesc = "Xojo väntar på dig att slå honom följe genom dörröppningen. "
    escortDest = (powerControl.west)
    stateAfterEscort = xojoHallEast
;

/* waiting at the east end of the hallway to escort us */
++ xojoHallEast: XojoEscortState
    stateLoc = powerHallEast

    arrivingWithDesc = "Xojo holds his hand out to indicate the far
                        end of the hall, and waits for you to proceed. "
    stateDesc = "He's waiting for you to accompany him down the hall
                 to the west. "
    specialDesc = "Xojo is waiting for you to follow him down the
                   hall to the west. "
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
            "Xojo stop and waits with you for the elevator. ";
        else if (plantElevator.isAtTop)
        {
            "Xojo pulls open the elevator door and pushes aside
            the gate, and waits for you to get in. ";
            
            plantElevatorGate.makeOpen(true);
        }
        else
        {
            /* the elevator hasn't even been called yet - call it */
            "Xojo reaches out and pushes the elevator call button.
            The neon lamp above the button lights dimly. ";
            
            plantElevator.callToTop();
        }
    }
    stateDesc()
    {
        if (plantElevatorGate.isOpen)
            "He's waiting for you to get in the elevator. ";
        else
            "He's waiting with you for the elevator to arrive. ";
    }
    specialDesc()
    {
        if (plantElevator.isAtTop)
            "Xojo is here, holding the elevator door open for you. ";
        else
            "Xojo is here, waiting with you for the elevator. ";
    }
    escortDest = (plantElevatorGate.isOpen ? powerHallWest.west : nil)
    stateAfterEscort = xojoElevator
;
+++ AskTellShowTopic @plantHallElevatorDoor 'stair(s|way)?'
    "<q>Couldn\'t we take the stairs instead?</q> you ask, worried
    about the time.
    <.p>Xojo laughs nervously. <q>Stairs, no,</q> he says. <q>For fire
    safety reasons, only the elevator is provided in this sector.</q> "
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

        "Xojo lets the door swing shut and closes the gate, then
        pushes the <q>G</q> button.  The elevator lurches and starts
        slowly descending. ";

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
    "<q>Is that a service panel up there?</q> you ask.
    <.p><q>The answering of such questions is not within the scope
    of my responsibilities,</q> Xojo says.  <q>Our very fine department
    of vertical conveyance is in command of such matters.</q> "
;
++++ AltTopic
    "You point to the service panel.  <q>Do you think we could get
    out through that panel?</q>
    <.p>Xojo looks at it appraisingly. <q>Perhaps, but the height is
    too far above for me to reach it.  Perhaps I could lift you, and
    you could attempt reaching.  Shall we try?</q><.convnode offer-boost> "

    isActive = (plantElevator.isAtBottom)
;
++++ AltTopic
    "<q>I need to get up to the service panel again,</q> you say.
    <.p><q>Would you like me to lift you again?</q> Xojo asks.
    <.convnode offer-boost> "

    isActive = (xojo.boostCount != 0)
;
++++ AltTopic
    "<q>Thanks for your help with the service panel,</q> you say.
    <.p><q>It is a duty and a pleasure to assist,</q> he says. "

    isActive = (me.isIn(atopPlantElevator))
;

++ xojoElevatorBoosting: InConversationState
    stateDesc = "He's holding you on his shoulders. "
    specialDesc = "Xojo is holding you on his shoulders. "
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
        "Xojo harklar sig. <q>Jag undrade,</q> säger han,
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
    ['<q>Förlåt,</q> säger du, <q>men jag har inte hört talas om ditt
    universitet förut. Är det en bra skola?</q>
    <.p><q>Åh, ja,</q> säger Xojo ivrigt, nickande snabbt.
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
    ['<q>Jag är ledsen att säga att det är anställningsstopp på Omegatron
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
            "Xojo indicates the door.  <q>This way,</q> he says. ";
        else
        {
            s2HallEastDoor.makeOpen(true);
            "Xojo opens the door. <q>This way, please,</q> he says,
            indicating the door. ";
        }
    }
    stateDesc = "He's waiting for you to accompany him through
                 the door. "
    specialDesc = "Xojo is waiting for you to accompany him through
                   the door. "
    escortDest = (s2HallEast.north)
    stateAfterEscort = xojoS2Storage
;

++ xojoS2Storage: XojoEscortState
    stateLoc = s2Storage
    arrivingWithDesc = "<q>The clutter is formidable,</q> Xojo says,
                        <q>but the way north is passable.</q> "
    stateDesc = "He's waiting for you to accompany him through
                 the junk to the north. "
    specialDesc = "Xojo is waiting for you to accompany him through
                   the junk to the north. "
    escortDest = (s2Storage.north)
    stateAfterEscort = xojoS2Utility
;

++ xojoS2Utility: XojoEscortState
    stateLoc = s2Utility
    arrivingWithDesc = "Xojo points to the opening. <q>My apologies,
                        but this is the way for proceeding,</q> he
                        says. "
    stateDesc = "He's waiting for you to go through the opening
                 in the wall. "
    specialDesc = "Xojo is by the opening in the wall, waiting for
                   you to go through. "
    escortDest = (s2Utility.north)
    stateAfterEscort = xojoS2Platform
;

++ xojoS2Platform: XojoEscortState
    stateLoc = s2Platform
    arrivingWithDesc = "<q>Apologies once again,</q> Xojo says,
         indicating the rope bridge.  <q>It is relatively safe,
         in contrast to appearances.</q> "
    stateDesc = "He's waiting by the rope bridge for you. "
    specialDesc = "Xojo is waiting for you to start across the
                   rope bridge. "
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
    arrivingWithDesc = "Xojo waits for you to catch up. "
    stateDesc = "He's waiting for you to continue across the bridge. "
    specialDesc = "Xojo is waiting for you to keep going across
                   the bridge. "
    escortDest = (ropeBridge1.north)
    stateAfterEscort = xojoRopeBridge2
;

++ xojoRopeBridge2: XojoEscortState
    stateLoc = ropeBridge2
    arrivingWithDesc = "Xojo waits for you to catch up. "
    stateDesc = "He's waiting for you to continue across the bridge. "
    specialDesc = "Xojo is waiting for you to continue across the bridge. "
    escortDest = (ropeBridge2.north)
    stateAfterEscort = xojoRopeBridge3
;

++ xojoRopeBridge3: XojoEscortState
    stateLoc = ropeBridge3
    arrivingWithDesc = "Xojo is just above, hanging on to the ropes.
                        <q>I think we can climb up from here,</q> he says. "
    stateDesc = "He's waiting for you to try climbing up the ropes. "
    specialDesc = "Xojo is waiting for you to try climbing up the ropes. "
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
            "<.p>Xojo sits on the ground, catching his breath. <q>Ha,
            ha,</q> he forces a laugh.  <q>Perhaps I should have mentioned.
            The senior leaders sometimes find it is useful to partially cut
            the ropes anchoring the bridge, as a surprise to those crossing
            it.  This reminds Junior Peons of the importance of remaining
            alert.</q>  He gets to his feet. <q>This way,</q> he says,
            pointing to the path. ";

            firstTime = nil;
        }
        else
            "Xojo points to the path. <q>This way,</q> he says. ";
    }
    firstTime = true
    
    stateDesc = "He's waiting by the path. "
    specialDesc = "Xojo is waiting by the path. "
    escortDest = (canyonNorth.northeast)
    stateAfterEscort = xojoCourtyard
;

++ xojoCourtyard: XojoEscortState
    stateLoc = plantCourtyard
    arrivingWithDesc = "Xojo points to the doors into the building. "
    stateDesc = "He's waiting for you to go into the building. "
    specialDesc = "Xojo is waiting for you to enter the building. "
    escortDest = (plantCourtyard.in)
    stateAfterEscort = xojoAdmin
;

++ xojoAdmin: HermitActorState
    arrivingWithDesc = ""
    arrivingTurn()
    {
        "<.p>Xojo taps you on the shoulder. <q>Behold, Colonel
        Magnxi!</q> he shouts, pointing to the Colonel.  You hadn't
        picked her out of the crowd yet, but now you see her standing
        nearby.
        <.p>So this is your chance.  You wish you didn't look like
        you'd just been hit by a bus, but this is no time to worry
        about trivial details such as looking presentable.  Besides,
        the Colonel looks a little ridiculous herself---the military
        uniform she's wearing is funny-looking enough, but she's worn
        that every other time you've met with her.  It's the hat she
        has on that crosses the line from eccentric to bizarre. ";

        /* no need to follow the player any longer */
        xojo.followingActor = nil;

        /* move the colonel here */
        magnxi.moveIntoForTravel(adminLobby);
    }

    stateDesc = "He's watching the band. "
    specialDesc = "Xojo is here, watching the band. "
    noResponse = "Xojo can't seem to hear you over the music. "
;

++ xojoEmailAgenda: ConvAgendaItem, DelayedAgendaItem
    invokeItem()
    {
        "<.p>Xojo taps you on the shoulder and hands you a piece of
        paper---a print-out from an old-style line printer, with
        alternating green and white horizontal stripes across the
        page.  <q>This arrived in the nightly batch of electronic
        e-mail,</q> he says.  <q>I express my sympathy for your
        unfortunate non-success,</q> he adds. <q>I wish you improvement
        of fortune for your future endeavors.  Now, I must return
        to assist Guanmgon in dismantling your very wonderful
        SCU-1100DX product.</q>  You shake hands, and he disappears
        into the crowd. ";

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
+ guanmgon: Person 'guanmgon/guan/man/bureaucrat*men' 'Guanmgon'
    "He's a mid-level bureaucrat assigned to assist you with the
    installation.  He's wearing a suit that looks a bit too small
    for him.  Guanmgon looks like he's in his forties. "

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
            "<.p>You hear the opening notes of Beethoven's Fifth as rendered
            in piezo-electric square waves: Guanmgon's cell phone ringing.
            He frantically pulls out the phone, drops it, catches it in
            mid-air, drops it again, picks it up, pokes at the keypad,
            and finally puts it to his ear.  His conversation isn't in
            English, so you don't have any idea what's being said, but
            you can tell it's not good news.  You'd bet it's his
            superiors calling for yet another update.  Needless to
            say, the bill of goods they were sold didn't include six
            long weeks just to get the demo working, and they haven't
            been hiding their impatience lately. ";

            /* switch to my 'on the phone' state */
            setCurState(guanmgonOnPhone);
            setConvNode(nil);
            break;

        case 17:
            /* continue the call */
            "<.p>Guanmgon continues talking on the phone.  More listening
            than talking, actually; even without understanding the language,
            you can tell that every time he starts to say something he gets
            interrupted. ";
            break;

        case 18:
            /* make sure xojo is back from any errand, since we mention him */
            xojo.endErrand();

            /* finish the call */
            "<.p>Guanmgon fumbles with the phone, almost dropping it, and
            puts it away.  Xojo asks him something, and you hear
            <q>Mitachron</q> a couple of times in Guanmgon's reply,
            accompanied by heavy sighs. ";

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
    'narrow vertical broad striped checked small brown slightly mismatched
    suit/slacks/pants/jacket/stripe/stripes/check/checks/pattern'
    'Guanmgon\'s suit'
    "Apart from looking a little too small, the thing that makes
    Guanmgon's suit look odd is that the jacket and slacks don't
    quite match.  They're both brown, but the jacket has a narrow
    vertical striped pattern, and the pants have broad checks. "

    isQualifiedName = true
    isListedInInventory = nil
;

/* our initial state - standing nearby watching us try to repair the SCU */
++ guanmgonInit: ActorState, EventList
    isInitState = true

    stateDesc = "Det verkar som att Guanmgon har blivit alltmer
                 nervös medan ditt arbete här har dragit ut på tiden;
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
        "Guanmgon tassar in i rummet och försöker hitta en väg genom röran, 
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
        "<q>Visst, tack,</q> säger du.<.p> ";
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
    "Det har gjorts klart att Guanmgon är här för administrativt, 
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
    snart ha detta uppdrag klart, det är jag säker på.</q> "
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
    anledning att oroa sig för det företaget! Jag är säker på att 
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
    har någon aning om var du kan hitta chipet du behöver.
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
    
++ Decoration 'mobil mobiltelefon/telefon' 'mobiltelefon'
    "Du är lika teknikintresserad som nästa ingenjör, men ärligt talat 
    har du inte varit särskilt imponerad av enheter som kan spela 
    syntetiserad musik med fyrkantsvågor sedan de tidiga PC-dagarna. "
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
+ Decoration '(power) (plant) equipment/systems/pile' 'equipment'
    "Det är det vanliga utbudet av strömbrytare, mätare, laststyrningspaneler och interna
    kommunikationssystem som man kan förvänta sig att hitta i vilket kraftverk som helst
    byggt på 1960-talet. Just nu är allt öppet och taget isär, tack vare dina ansträngningar
    att integrera 1100DX i de befintliga systemen. "
    notImportantMsg = 'Du har redan riggat det ganska
                       grundligt; det är nog bäst att inte
                       pilla med det nu när saker och ting nästan fungerar. '

    /* 
     *   It's the power plant's systems.  Setting 'owner' like this
     *   explicitly means that the player can refer to this using a
     *   possessive that refers to the owner, as in "the plant's
     *   equipment" or "the power plant's systems". 
     */
    owner = powerPlant6
;

+ Decoration 'breaker panel/panels/switch/switches/breakers' 'breaker panels'
    "Det finns dussintals strömbrytare som styr distributionen
    av ström från generatorerna och ger skydd mot
    överbelastningar. "
    isPlural = true
    notImportantMsg = 'Det är inte din domän; bäst att låta det vara. '
;

+ Decoration 'power levels/gauge/guage/gauges/guages/voltages/amperages'
    'gauges'
    "Mätarna visar spänningar, strömstyrkor och effektnivåer för de många
    kretsarna. "
    notImportantMsg = 'Du borde nog låta mätarna vara. '
    isPlural = true
;

+ Decoration 'load control board/boards/panel/panels' 'load control boards'
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
+ Decoration 'internal comm communications (system)/(systems)' 'comm systems'
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
    'mygga/myggor/fluga/flugor/insekt/insekter' 'myggor'
    "De är oupphörliga. "
    isPlural = true
    notImportantMsg = 'Myggorna är extremt irriterande, men de är oviktiga. '
    dobjFor(Attack)
    {
        verify() { }
        action() { "Det är meningslöst; det finns fler buggar i detta
            rum än i SCU-1100DX. "; }
    }
    dobjFor(Take)
    {
        verify() { }
        action() { "Hur mycket du än försöker kan du inte fånga någon av dem. "; }
    }
;

/* the SCU-1100DX */
+ scu1100dx: TestableCircuit, Immovable, OnOffControl
    'omegatron kompletterande kontrollenhet modell stor metall 
    låda/scu/1100/1100dx/scu-1100/scu-1100dx/scu1100/scu1100dx'
    'SCU-1100DX'
    "En Omegatron Supplemental Control Unit modell 1100DX. Du borde
    känna den som din egen handflata efter att ha suttit igenom alla
    de där ingenjörsmötena och designgranskningarna, men den omfattande
    kostnadsbesparingen och riggningen i tillverkningsprocessen
    har förvandlat den till något märkligt obekant.
    <<isOn ? "Lyckligtvis har du äntligen lyckats få den att fungera. "
           : "Oavsett vad är det din uppgift att få den att fungera. " >>
    <.p>
    1100:an är i grunden en stor metallåda öppen på ena sidan, som en
    kylskåp utan dörr (och ungefär samma storlek), fylld
    med staplade elektronikmoduler. Knippen med kablar och ledningar kopplar
    modulerna till kontrollpanelerna och annan utrustning i kraftverket.
    Den är för närvarande <<onDesc>>.
    <<isWorking ? "" :
    "<.p>Det finns en tom plats, som är där CT-22-modulen du
    tagit bort ska vara." >> "

    cannotTakeMsg = 'Skämtar du? Den är stor som ett kylskåp,
                     och väger lika mycket som en bil. '
    cannotMoveMsg = 'Det finns ingen plats att flytta den någonstans. '
    cannotPutMsg = 'Den är alldeles för tung. '

    /* keep track of whether we're working */
    isWorking = nil

    /* we're not a container, but we make it look like we are */
    container = nil
    makeContainerLook = true

    /* we're not really a container, but make it look like we are */
    lookInDesc = "The unit is stuffed full of stacked electronics modules. "

    dobjFor(Open) { verify() { illogical('The 1100DX doesn\'t have a
        door, to keep the modules inside easily accessible. '); } }
    dobjFor(Close) asDobjFor(Open)

    dobjFor(TurnOn)
    {
        check()
        {
            /* allow activation only after repair */
            if (!isWorking)
            {
                "You have no reason to turn it on until you've fixed
                the problem with the CT-22. ";
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
            "You cross your fingers and flip the switch.
            The SCU-1100DX clicks and hums as it starts its
            power-on self-test sequence.  Many seconds pass.
            You hold your breath.  Guanmgon and Xojo lean in
            from the doorway, as though there were something
            to see.  Then, four short beeps: successful
            start-up!  You carefully scan the modules, and
            see that everything's working.  After six weeks,
            you\'ve finally done it; at last, you can give
            the demo and, hopefully, get a contract signed.
            <.p>
            Guanmgon sees the SCU power up, and squeezes into
            the room to check the control boards.  <q>It is
            working,</q> he says with amazement.  <q>This is
            so wonderful!  Dreadful disgrace is not for us now!
            But we must act quickly.  Xojo!  Escort Mr.\ Mittling
            to see the Colonel at once.  Hurry with maximum haste!
            Do not delay!  Quickly, quickly, hurry!</q>
            <.p>
            Xojo nods, then turns to you and indicates the
            doorway. ";

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

    scoreMarker: Achievement { +10 "repairing the SCU-1100DX" }

    /* once it's on, don't allow turning it off */
    dobjFor(TurnOff)
    {
        check()
        {
            "Are you out of your mind?  There's no way you're going to
            risk going through a power cycle now that you've got it
            ready to demo. ";
            exit;
        }
    }

    dobjFor(Repair)
    {
        action()
        {
            mainReport(isWorking && isOn
                       ? 'But it\'s already repaired! '
                       : 'It sure would be nice if it were that easy,
                       wouldn\'t it?  Sadly, you don\'t have any magical
                       powers of electronics repair, so you\'ll have to do
                       something besides just willing it to start working. ');
        }
    }

    /* map 'put x in scu' to 'put x in slot' */
    iobjFor(PutIn) maybeRemapTo(scuSlot.isIn(self),
                                PutIn, DirectObject, scuSlot)
;

++ scuSlot: TestableCircuit, Component, RestrictedContainer
    'tom modul/modullucka[-n]/plats[-en]/lucka[-n]' 'tom lucka'
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
               reportFailure('{That dobj} do{es}n\'t belong in the slot. ');
           }
           else if (!xt772lv.isIn(ct22))
           {
               reportFailure('There\'s no reason to re-install the module
                   until you\'ve fixed it. ');
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
               mainReport('The module slides into place&mdash;not quite
                   smoothly, but at this point it\'s enough that it fits
                   at all.  You give it a firm push to make sure the
                   connectors are all seated properly.  Now all that
                   remains is switching on the SCU, and hoping there\'s
                   not yet another problem lurking. ');
           }
       }
   }
;

++ moduleStack: TestableCircuit, Immovable
    'stacked installed electronics module/modules/stack' 'electronics modules'
    "Each module is about the shape of a pizza box, and the modules
    are stacked one on top of another inside the 1100DX.
    << scu1100dx.isWorking
    ? "The repaired CT-22 is back in place. "
    : "There's one empty slot, where the CT-22 module goes. " >> "

    isPlural = true

    dobjFor(Take)
    {
        /* this is slightly less likely for 'take' than portable modules */
        verify()
        {
            inherited();
            logicalRank(80, 'do not disturb');
        }
    }

    dobjFor(Open) asDobjFor(LookIn)
    lookInDesc = "The modules are all kind of jury-rigged into place
        at the moment; you don't want to risk breaking something by
        taking them apart. "

    /*
     *   For disambiguation purposes, refer to this object as the
     *   "installed modules" to more clearly differentiate it from the
     *   single uninstalled module (the ct-22).  
     */
    disambigName = 'installed modules'

    cannotTakeMsg = 'It took a while to get everything plugged in
                     properly, so you\'d rather leave everything where
                     it is. '
    cannotMoveMsg = 'The modules are all seated properly, so it\'s best
                     not to jiggle them. '
    cannotPutMsg = 'You don\'t want to move the modules anywhere, since
                    it took a while to get them all positioned properly. '
;

+ ct22: TestableCircuit, Thing
    'ct ct-22 ct22 diagnostic modul[-en]' 'CT-22 diagnostikmodul'
    "<< xt772lv.isIn(self)
    ? "Det är diagnostikmodulen som är ansvarig för många av
    dina bekymmer här. Som tur är verkar den äntligen vara lagad: ett
    XT772-LV-chip är installerat i modulens S901-sockel. "
    : "Den här modulen är en stor del av varför det här jobbet har tagit
    så lång tid. CT-22:ans funktion är att diagnostisera fel och defekter
    i de andra modulerna; naturligtvis visade det sig att den själv var defekt.
    Den fungerade precis tillräckligt bra för att skicka dig på veckors
    vilda jakter efter att fixa falska problem som den rapporterade i
    andra moduler. När det slog dig att ta ut den och kontrollera dess
    egen funktion med din kretsprovare hittade du snabbt problemet:
    tillverkningen installerade fel chip i en av nyckelkretsarna.
    De installerade en XT772-HV, högspänningsversionen, när de borde ha
    installerat lågspänningsversionen, XT772-LV. Skillnaderna i
    spänningskänslighet skapade alla möjliga falska felmeddelanden.
    Tyvärr är CT-22 en kritisk komponent i SCU:n, så du kan inte
    bara utelämna den. ">>
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
            logicalRank(110, 'more special');
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
                Utan ett, finns det ingen uppenbar lösning";

                /* this counts as a mention of the lv */
                xt772lv.isMentioned = true;
            }
        }
    }
;

++ s901: TestableCircuit, Component, SingleContainer, RestrictedContainer
    's901 chip 97-pin medium-density hybrid square/square socket'
    'S901 socket'
    "It's a 97-pin medium-density hybrid square/square socket. "

    /* this is a special case for a/an because of the leading initial */
    aName = 'an S901 socket'

    /* don't show my contents in listings of containing objects */
    contentsListed = nil

    /* only allow the XT772 chips */
    validContents = [xt772lv, xt772hv]
;
+++ xt772hv: TestableCircuit, Thing
    'felaktig[-a] xt772 hv xt772-hv högeffekt hög effekt chip/version'
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
    'bunt/buntar/kabel/kablar/ledning/ledningar/sladd/sladdar' 'kablar'
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
+ tester: ComplexContainer 'mitachron dynatest multifunktions kretstestare[-n]/testare[-en]'
    'kretstestare'
    "Detta är din Mitachron DynaTest multifunktions kretstestare.
    Du känner dig alltid lite generad över att ett av dina viktigaste
    vardagliga ingenjörsverktyg är tillverkat av din största konkurrent, men
    Omegatron har aldrig haft någon större framgång med sina egna produkter i detta
    marknadssegment. Testaren är ungefär lika stor som ett bilbatteri; dess
    huvudfunktioner är en prob och en liten displayskärm, plus den vanliga
    samlingen varningsdekaler på bakstycket. Den är för närvarande
    avstängd. "

    /* Use a secret nested container to hold our contents */
    subContainer = testerInterior

    dobjFor(TurnOn)
    {
        verify() { }
        action() { noNeedToTest(nil); }
    }
    cannotTurnOffMsg = 'It\'s already off. '

    noNeedToTest(other)
    {
        if (other != nil && !other.ofKind(TestableCircuit))
            "Testaren är inte designad för att testa {that iobj/him}. ";
        else if (scu1100dx.isWorking)
            "Ingen anledning; SCU:n är redan fixad. ";
        else
            "Du har redan avgränsat problemet, eller åtminstone
            det senaste problemet, till CT-22:an. Ingen anledning att göra
            fler tester förrän du kommer på hur du ska fixa det. ";
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

++ Component '(circuit) (tester) platt panel platt-panel skärm/display'
    'testerdisplay'
    "Det är en liten platt skärm där testaren visar sina mätvärden. 
    Skärmen är för närvarande tom. "
;

++ testerProbe: ComponentDeferrer, Component
    '(circuit) (tester) elektrisk (koax) (koaxial)
    prob/set/kontakter/kabel' 'prob'
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
    dobjFor(Test)
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
            "Bäst att låta bli; det skulle antagligen förstöra {the iobj/him}. ";
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
    'circuit tester back cover' 'back cover'
    "Den är designad för att ge serviceåtkomst till enhetens interna
    komponenter, och har de vanliga varningsdekalerna.
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
    name = 'tester'

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
                "The back cover is open, revealing the circuitry inside
                the tester. ";
        }
        
        showListPrefixWide(itemCount, pov, parent)
        {
            /* 
             *   note that we'll only reach this method if we're open,
             *   since otherwise we wouldn't have any visible contents to
             *   list 
             */
            "The back cover of the tester is open, revealing the circuitry
            inside, including ";
        }
    }
    descContentsLister = (contentsLister)
    lookInLister = (contentsLister)

    /* use a custom lister when we're opened */
    openingLister: openableOpeningLister {
        showListPrefixWide(itemCount, pov, parent)
        {
            "Opening the tester reveals the circuitry inside,
            including ";
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
                illogicalNow('You\'d have to take it apart to do that. ');

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
                reportAfter('<.p>Of course!  The DynaTest is just the
                    kind of low-power application where you\'d find an
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
    scoreMarker: Achievement { +2 "finding the XT772-LV chip" }
;

+++ Fixture 'tester circuitry/circuits' 'tester circuitry'
    "The circuitry has the usual Mitachron look of chaotic design,
    as though the parts wouldn't quite fit and had to be force into
    place with a hammer. "
;

+++ xt772lv: TestableCircuit, Thing
    'xt772 lv xt772-lv low-power low power chip/version'
    'XT772-LV chip'
    "It's the low-power version of the XT772 chip. "

    /* we need to override the a/an name because of the leading initial */
    aName = 'an XT772-LV chip'

    /* mark it as known in advance */
    isKnown = true

    /* have we found it yet? */
    isFound = nil

    /* have we mentioned it to the player yet? (for hint management) */
    isMentioned = nil

    /* it's small; make it pocketable */
    okayForPocket = true
;

++ Component 'warning stickers/warnings' 'warning stickers'
    "Lightning bolts inside yellow triangles.
    <font color=red bgcolor=yellow><b>DO NOT OPEN!</b></font>
    No user-serviceable parts inside!
    <b>Opening may invalidate warranty!</b>  The usual stuff. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Some objects in common to both hallways 
 */

/* class for power hall rooms */
class PowerPlantHallRoom: PowerPlantRoom
    north: NoTravelMessage { "You're five stories up; better take the
        elevator instead. " }
    south: NoTravelMessage { "The plant floor is five stories below;
        better take the elevator instead. " }

    name = 'hallway'
    vocabWords = 'hall/hallway'

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
                "A distant rumbling sound drifts in from somewhere out in
                the jungle.  At first you think it's thunder, but it grows
                a bit louder and you realize it's an approaching helicopter.
                A scan of the horizon shows nothing in the air.  Suddenly
                the noise is deafening, and a black shape swoops into view
                from overhead, racing away toward the buildings across the
                river.  As the helicopter flies past, you spot the yellow
                Mitachron logo on the tail. ";

                /* add the first helicopter */
                helicopter1.moveIntoAdd(powerHallEast);
                helicopter1.moveIntoAdd(powerHallWest);

                /* mark it as having been seen */
                me.setHasSeen(helicopter1);
                break;

            case 2:
                "The sound of another approaching helicopter drifts in
                from the jungle, and within a few moments it
                appears&mdash;along with three others, flying in
                formation, heading the same way as the previous one.
                The four fly across the river and land next to the
                first. ";

                /* replace the single helicopter with the five */
                helicopter1.moveInto(nil);
                helicopter5.moveIntoAdd(powerHallEast);
                helicopter5.moveIntoAdd(powerHallWest);

                /* mark it as having been seen */
                me.setHasSeen(helicopter5);
                break;

            case 3:
                "The arrival of the Mitachron people is awfully
                worrying; they must really want this deal to have
                sent such a large group.  At least they'll have to do
                their own demo, so you're ahead of them on that count.
                Even so, direct competitive situations with Mitachron
                never seem to go well for Omegatron.  Maybe if you can
                get to the Colonel quickly enough, you'll be able to get
                your contract signed before the Mitachron reps even
                get a meeting with her. ";
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
    'north n waist high waist-high wall' 'north wall'
    "It's only waist-high, leaving the hallway open to the jungle. "
;
+ Fixture
    'south s waist high waist-high wall' 'south wall'
    "It's only waist-high, leaving the hallway open to the plant
    interior. "
;
+ Fixture 'concrete widely-spaced space columns' 'columns'
    "They're just concrete columns holding up the roof. "
    isPlural = true
;
+ Distant 'cavernous plant interior/plant/(floor)'
    'plant interior'
    "The plant interior is a cavernous space to the south.  This
    hallway is essentially a balcony, five stores up, along the
    north wall.  From here, you have a good view of the giant
    industrial equipment that runs the plant. "
;
+ Distant 'giant industrial steam age steam-age
    equipment/turbines/transformers/boilers/pipe/pipes/cable/cables'
   'equipment'
    "Turbines, transformers, boilers, all connected with a vast
    web of pipes and cables.  All very steam-age looking. "

    /* 
     *   'equipment' is used as a 'mass noun' - it refers to mutiple
     *   objects even though the word itself is singular 
     */
    isMassNoun = true
;
+ Distant 'jungle' 'jungle'
    "The scenery is great from this elevated vantage.  Directly to
    the north is the deep gorge of the Xtuyong River Canyon; the plant
    is built right on the edge of the cliffs.  On the opposite
    rim of the canyon is the complex of administrative buildings,
    where the Colonel's office is.  Beyond that is untamed jungle
    to the horizon.  A bridge spans the canyon. "
;
+ Distant 'vegetation/plants' 'vegetation'
    "There's quite a lot of it, this being a jungle and all. "
;
+ Distant 'xtuyong river deep canyon/gorge' 'canyon'
    "Two hundred meters deep and a hundred across, carved out
    over the eons by the steady flow of water from the rain forest
    highlands to the west.  A bridge spans the canyon. "
;
+ Distant 'concrete steel structure/bridge' 'bridge'
    "You've been across it many times now; it's a broad, modern structure
    built of steel and concrete.  The bridge connects the power plant on
    this side of the canyon with the administrative buildings on the
    other side. "
;
+ Distant 'office administrative complex/buildings'
    'administrative complex'
    "It's a sprawling complex of office buildings housing the
    power plant's extensive bureaucracy. "
;
+ Distant 'sky' 'sky'
    "It's a deep, bright blue. "
;

class HeliTail: Distant 'helicopter tail' 'helicopter tail'
    "It appears to be marked with the Mitachron logo. "
   ;
class HeliTailLogo: Distant 'yellow mitachron logo' 'Mitachron logo'
    "You can just barely make it out from here, but you think
    you recognize the tail markings as the Mitachron logo: a big yellow
    <q>M</q> in a heavy sans-serif action-slant font, superimposed over
    a light yellow outline of a globe. "
;

/* the first helicopter */
helicopter1: MultiLoc, Distant 'black mitachron helicopter/chopper/copter'
    'black helicopter'
    "It's just setting down near the administrative complex. "
;
+ HeliTail;
++ HeliTailLogo;

/* the full group of helicopters */
helicopter5: MultiLoc, Distant
    'five black mitachron helicopters/choppers/copters/group'
    'five black helicopters'
    "All five helicopters are parked together near the administration
    complex.  They're too far away, and there's too much vegetation
    in the way, to see if there's any activity near them or if anyone
    has disembarked. "
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
    'East End of Hallway' 'the east end of the hallway'
    "Like every other part of the plant structure, this wide
    fifth-floor hallway is built entirely of concrete.  The north
    and south walls are only waist-high, apart from a few widely-spaced
    columns supporting the roof, leaving the hallway open
    to the jungle to the north and to the cavernous interior of
    the plant to the south.  The hall ends in a doorway to the
    east, and continues to the west. "

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
    'east e door/doorway/sign' 'doorway'
    "You assume that the sign says <q>Control Room,</q> although
    it's not in an alphabet you can read.  The doorway leads to the east. "
;
   
/* ------------------------------------------------------------------------ */
/*
 *   The west end of the hall, at the elevator 
 */
powerHallWest: PowerPlantHallRoom
    'West End of Hallway' 'the west end of the hallway'
    "This wide hallway has waist-high walls open to the jungle
    to the north, and to the enormous plant interior to the south; a
    few widely-spaced columns support the roof.  The hall ends at an
    elevator door to the west, and continues to the east. "

    east = powerHallEast
    west = plantHallElevatorDoor
    in asExit(west)

    /* we have no east well, and we have custom north and south walls */
    roomParts = static (inherited()
                - [defaultNorthWall, defaultSouthWall, defaultEastWall])
;

+ plantHallElevatorDoor: Door, BasicContainer ->plantElevatorGate
    'elevator lift door/elevator/lift' 'elevator door'
    "It's one of those old-style elevators with an ordinary swinging
    door, painted a pale blue-green.  A round, black call button is
    next to the door, and above the button is a small neon lamp (currently
    <<plantElevator.isOnCall ? 'lit' : 'unlit'>>). "

    /* it's initially closed - we can't open it until the elevator arrives */
    initiallyOpen = nil

    dobjFor(Open)
    {
        check()
        {
            /* if the elevator isn't here, we can't open it */
            if (!plantElevator.isAtTop)
            {
                "The door can't be opened until the elevator arrives. ";
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
                "Xojo is holding it open for you; no need to be rude. ";
                exit;
            }
        }
    }

    dobjFor(Board) remapTo(TravelVia, self)
;

++ Fixture 'folding metal elevator lift gate' 'elevator gate'
    "It's a folding metal gate that serves as the elevator's
    inner door. "
;

+ Button, Fixture 'round black elevator lift call button' 'call button'
    "It's a big black button sticking out from the wall about
    a centimeter. "
;

+ Fixture 'small neon lamp' 'neon lamp'
    "It's currently <<plantElevator.isOnCall ? 'lit' : 'unlit'>>. "
;

/* ------------------------------------------------------------------------ */
/*
 *   The elevator interior.  Note that we don't use our general Elevator
 *   class, or its various related components, to implement this elevator;
 *   this elevator's behavior is quirky, so our general elevator classes
 *   don't apply well here.  
 */
plantElevator: PowerPlantRoom 'Elevator' 'the elevator'
    "This is a big, sturdily-built elevator, like something you'd
    find in an old warehouse.  There's been no attempt at decoration;
    just dull metal walls, a folding metal gate to the east,
    a handrail on the back wall, <<powerElevPanel.isOpen
    ? 'a two-by-three-foot opening' : 'a recessed service panel'
    >> in the ceiling, a bare bulb dimly burning at the top corner of
    the back wall.  Protruding black buttons are labeled, from the
    bottom, S2, S1, G, and 2 through 5.
    <<isDescending ? "The bare concrete of the shaft wall slides by
    beyond the gate." : "Beyond the gate is the bare concrete of
    the shaft wall." >> "

    vocabWords = 'elevator/lift'

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
        "A loud buzzer sounds from the elevator, and the neon
        lamp above the call button goes out. ";

        /* if xojo is here, have him open the door */
        if (xojo.isIn(powerHallWest))
        {
            "<.p>Xojo pulls opens the door and pushes aside the elevator's
            folding metal gate for you, and waits for you to get in. ";
            
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
            "<.p>The elevator descends past a door marked
            <q><<btn.nominalFloor>>.</q> ";

            /*
             *   If we just passed floor 1, xojo notices it.  If we just
             *   passed S2, we're about to crash.  Otherwise, if the button
             *   is pushed, mention that we didn't stop.  
             */
            if (btn.internalFloor == 2)
            {
                "Strange; you thought that was your stop.
                <.p>Xojo, looking a little alarmed, starts punching
                buttons.  <q>No reason for panic,</q> he says, not very
                convincingly, but then he seems to calm down and stop
                fooling with the buttons.  <q>The elevator programming
                is sometimes faulty.  We should be halted soon,
                since the shaft is nearly at bottom.</q> ";

                /* cancel any conversation */
                xojo.setConvNode(nil);
            }
            else if (btn.internalFloor == -2)
            {
                /* we've reached the bottom of the shaft */
                "<.p>Xojo grips the handrail tightly.  <q>Be firm, the
                stopping is ready to be abrupt.</q>  You grab the handrail
                and brace yourself.
                <.p>
                The shaft wall keeps going by for a few more moments, showing
                no sign of slowing, then: thud!  Not a jerk from the cable
                above, but the sharp shock of hitting something below.
                The whole elevator shudders.  Outside the gate, the shaft
                wall is suddenly motionless.
                <.p>
                <q>All is safe now,</q> Xojo says, relaxing. <q>Now we
                need do no more than wait patiently for rescue.</q> ";
                
                /* no longer descending, since we're at the bottom */
                isDescending = nil;
                isAtBottom = true;

                /* we don't need the descent script any longer */
                eventManager.removeCurrentEvent();

                /* cancel any conversation */
                xojo.setConvNode(nil);
            }                
            else if (btn.isPushed)
                "Strange that the elevator didn't stop here, given that
                you pushed the button. ";
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
            "<.p>The elevator continues its lethargic descent.
            Rationally, you know that the few minutes of this elevator
            ride aren't going to cost you the deal, but that doesn't
            stop the irrational part of your brain from pumping out
            anxiety hormones. ";
        }
        else if (curFloor == 3)
        {
            "<.p>The elevator plods on.  Come on, come on, come on... ";
        }
        else
        {
            /* there's no button, so we're just going by shaft wall */
            "<.p>The elevator continues its slow descent. ";
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

+ Fixture 'shaft wall' 'shaft wall'
    "The shaft wall is plain concrete.
    <<location.isDescending ? 'The elevator\'s motion creates the
    illusion that the shaft wall is sliding slowly upwards.' : ''>> "

    /* this wall is slightly more interesting than the elevator walls */
    dobjFor(Examine) { verify() { logicalRank(110, 'shaft'); } }
;

+ Fixture
    'dull metal elevator lift north south west n s w back top
    wall/corner*walls'
    'elevator walls'
    "The elevator walls are a bare, dull metal. A handrail is attached
    to the back wall. "
    isPlural = true
;

+ Fixture 'metal hand rail/handrail' 'handrail'
    "It's a simple metal handrail. "

    dobjFor(Hold)
    {
        verify() { }
        action() { "You hold the handrail for a moment. "; }
    }
    dobjFor(StandOn)
    {
        verify() { }
        action()
        {
            "You try to climb onto the handrail, but it's too
            narrow to get a good footing, and there's nothing else to
            hold onto.  You try attacking it from a few different angles,
            but you can't seem to make it work. ";

            xojo.observeClimb(self);
        }
    }
    dobjFor(Climb) asDobjFor(StandOn)
    dobjFor(ClimbUp) asDobjFor(StandOn)
    dobjFor(Board) asDobjFor(StandOn)
;

+ plantElevatorGate: Door 'folding metal elevator lift door/gate' 'gate'
    "Instead of a door, there's only this folding metal gate to
    separate passengers from the shaft wall while the elevator is
    in motion. "

    dobjFor(Open)
    {
        action()
        {
            "You try, but it won't budge.  Presumably, the gate 
            automatically locks while the elevator is in
            motion<< location.isDescending ? "" : " (or stuck
            between floors)" >>. ";
        }
    }

    dobjFor(LookThrough)
    {
        action() { "You see the shaft wall. "; }
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
            "You tentatively try climbing the gate the way you would
            a chain-link fence, but it's too wobbly; you'd be sure
            to get your fingers badly pinched, so you don't risk it. ";

            xojo.observeClimb(self);
        }
    }
    dobjFor(ClimbUp) asDobjFor(Climb)
;

/* 
 *   the ceiling and its contents are out of reach (until Xojo gives us a
 *   boost) 
 */
+ OutOfReach, NestedRoom, Fixture 'ceiling' 'ceiling'
    "Dull, bare metal like the walls; the only feature is a recessed
    service panel. "

    /* we can reach Xojo when he's giving us a boost */
    canReachFromInside(obj, dest)
        { return inherited(obj, dest) || dest == xojo; }
    cannotReachFromOutsideMsg(dest)
    {
        gMessageParams(dest);
        return '{The dest/he} {is} too high up to reach from here. ';
    }
    cannotReachFromInsideMsg(dest)
    {
        gMessageParams(dest);
        return 'You can\'t reach {that dest/him} from up here. ';
    }

    /* the only way we can be inside here is to be in xojoBoost */
    tryRemovingFromNested() { return tryImplicitAction(GetOffOf, xojo); }

    /* 
     *   anything thrown at an object inside the out-of-reach area near the
     *   ceiling lands back on the floor 
     */
    getDropDestination(objToDrop, path) { return location; }
;

++ Fixture 'bare light bulb' 'light bulb'
    "It's providing the dull illumination in here. "

    cannotTakeMsg = 'You have no desire to eliminate the only
        source of light here. '
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
    name = 'Xojo\'s shoulders'
    isQualifiedName = true
    isPlural = true

    /* show special descriptions while here */
    roomActorStatus(actor) { " (on Xojo's shoulders)"; }
    roomActorPostureDesc(actor) { "You're on Xojo's shoulders. "; }

    /* we can't stand here */
    makeStandingUp() { reportFailure('You and Xojo are having a difficult
        enough time keeping balanced as it is. '); }

    /* ...but we can implicitly dismount if needed */
    tryMakingTravelReady(conn) { return tryImplicitAction(GetOffOf, self); }
    notTravelReadyMsg = 'You\'ll have to get off Xojo\'s shoulders first. '

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
            && gAction.getOrigText.find('down') == nil
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
    'recessed metal ceiling service panel/plate/hatch' 'service panel'
    desc()
    {
        if (isOpen)
            "It's an opening in the ceiling, about two feet by
            three feet. ";
        else
            "It's a recessed metal plate set into the ceiling,
            about two feet by three feet.  You'd guess it's a
            service hatch, providing access to the roof of the
            elevator car. ";
    }

    initiallyOpen = nil
    descContentsLister = thingContentsLister

    dobjFor(TravelVia)
    {
        action()
        {
            /* add a description of the traversal */
            "You lift yourself through the opening, first propping yourself
            on your elbows, then using the leverage to lift the rest of
            your body. ";

            /* an unfortunate side effect the first time through... */
            if (scoreMarker.scoreCount == 0)
            {
                "Just as you're almost through, you hear the sound of
                tearing cloth---you realize you managed to snag the leg
                of your pants on the edge of the opening, making a huge
                rip down half the leg.<.p>";

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

            "<.p>You extend your hand to Xojo and help him climb up
            from the elevator. ";
        }
    }
    dobjFor(Board) asDobjFor(TravelVia)
    dobjFor(ClimbUp) asDobjFor(TravelVia)

    scoreMarker: Achievement { +5 "escaping the stalled elevator" }

    dobjFor(Open)
    {
        action()
        {
            "You give the plate a push, and it lifts away easily.
            You slide it aside, leaving a two-by-three foot opening
            in the ceiling. ";

            makeOpen(true);

            /* it's now an opening */
            initializeVocabWith('two-by-three-foot opening');
        }
    }
    dobjFor(Push) remapTo(Open, self)
    dobjFor(Pull) remapTo(Open, self)
    dobjFor(Remove) remapTo(Open, self)
    dobjFor(Move) remapTo(Open, self)
    dobjFor(PushTravel) remapTo(Open, self)

    dobjFor(Close) { action() { "There's no reason to do that. "; }}

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
    'black protruding button*buttons' 'button'
    "It's a round, black button protruding about a centimeter. "
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
                "You push the button, hoping it'll unfreeze the elevator,
                but nothing seems to happen. ";
            else if (internalFloor >= plantElevator.curFloor)
                "You push the button, but you doubt it'll have
                any effect, since the elevator has already passed
                that floor.  Xojo gives you a quizzical look. ";
            else if (internalFloor == 2)
                "You push the button, which shouldn't be necessary
                given that you already saw Xojo push it. ";
            else if (isPushed)
                "You push the button.  You doubt it'll have any
                effect, since you've already pushed it. ";
            else
                "You push the button.  Xojo looks like he wants
                to object, but it's too late. ";

            /* note that this button has been pushed */
            isPushed = true;
        }
    }
;
+ PlantElevButton '"s2" button' '<q>S2</q> button'
    internalFloor = -2
    nominalFloor = 'S2'
;
+ PlantElevButton '"s1" button' '<q>S1</q> button'
    internalFloor = 0
    nominalFloor = 'S1'
;
+ PlantElevButton '"g" button' '<q>G</q> button'
    internalFloor = 2
    nominalFloor = 'G'
;
+ PlantElevButton '2 -' '<q>2</q> button' internalFloor = 4;
+ PlantElevButton '3 -' '<q>3</q> button' internalFloor = 6;
+ PlantElevButton '4 -' '<q>4</q> button' internalFloor = 8;
+ PlantElevButton '5 -' '<q>5</q> button' internalFloor = 10;

/* 
 *   A "collective group" object for the buttons.  For most actions, when
 *   we try to operate on a 'button' without saying which one, we don't
 *   want to ask "which button do you mean...", since they're all basically
 *   the same.  Instead, we just want to say why you can't do whatever it
 *   is you're trying to do. 
 */
plantElevButtonGroup: ElevatorButtonGroup
    'black protruding elevator lift -' 'elevator buttons'
    "The buttons are arranged in a column.  From the bottom, they're
    labeled S2, S1, G, 2, 3, 4, 5. "
;


/* ------------------------------------------------------------------------ */
/*
 *   Atop the elevator.  We get here after making it through the escape
 *   hatch.  
 */
atopPlantElevator: Room 'Elevator Shaft' 'the elevator shaft'
    "The roof of the elevator car doesn't make a very good place to stand,
    crowded as it is with mechanical protrusions and cable attachments.
    A service hatch provides access to the elevator's interior.
    The main cable hangs limply from the top of the shaft far above.
    <.p>To the east is a door marked <q>S2</q>, just a little above
    the top of the elevator. "

    down = elevRoofHatch
    east = doorS2inner
    out asExit(east)
    up: NoTravelMessage { "The only way of going up would be to climb
        the cable, but it's too greasy to get a good grip. "; }

    roomParts = []
    roomFloor = apeFloor
;

+ Fixture 'shaft concrete wall/walls' 'shaft walls'
    "The shaft walls are bare concrete.  Rails  "
    isPlural = true
;

+ Fixture 'elevator lift rail/rails' 'rails'
    "The rails presumably guide the elevator car as it travels up
    and down the shaft. "
    isPlural = true

    dobjFor(Climb)
    {
        verify() { }
        action() { reportFailure('They\'re too narrow; there\'s no way
            to get a good enough grip. '); }
    }
    dobjFor(ClimbUp) asDobjFor(Climb)
;

+ apeFloor: Floor 'elevator lift elevator/lift/roof/car/floor' 'elevator roof'
    "It's not a very easy place to stand because of the many
    mechanical protrusions. "
;

+ Fixture 'mechanical cable bolts/attachments/protrusions' 'protrusions'
    "They're just a bunch of bolts and cable attachments and the like. "
    isPlural = true
;

+ Fixture 'elevator lift shaft/top' 'shaft'
    "The shaft must be about seven or eight stories, but there's not
     enough light that you can really tell by looking at it. "
;

+ elevatorCable: Fixture 'main elevator lift cable/cables' 'cable'
    "It's just hanging limply, which is consistent with the way the
    elevator crashed into the bottom of the shaft. "

    dobjFor(Climb)
    {
        verify() { }
        action() { reportFailure('The cable is well oiled; there\'s
            no way to get a good enough grip. '); }
    }
    dobjFor(ClimbUp) asDobjFor(Climb)

    dobjFor(Pull)
    {
        verify() { }
        action() { "You give the cable a tug.  This sends a lovely
            sine wave propagating up the cable.  You're sure you could
            calculate several properties of the cable by observing
            the propagation velocity of the wave, but you're in too
            much of a hurry for such diversions right now. "; }
    }
;

+ elevPanelCover: Thing 'service hatch opening metal plate/cover/panel'
    'metal plate'
    "It's a rectangular metal plate, about two feet by three feet,
    a few millimeters thick.  It serves as the cover for the elevator
    service hatch. "

    initSpecialDesc = "The service hatch cover is lying next to the opening. "

    cannotUnlockWithMsg = 'You\'ll have to be more specific about
        how you intend to do that. '
;

/* the escape hatch, as seen from above */
+ elevRoofHatch: TravelWithMessage, ThroughPassage -> powerElevPanel
    'service access opening/hatch' 'service hatch'
    "It's a two-by-three-foot opening in the roof of the elevator. "

    /* 
     *   our destination is the elevator itself, not the ceiling (where the
     *   other side of our passage is actually contained) 
     */
    destination = plantElevator

    /* this travel merits some extra description */
    travelDesc = "You carefully lower yourself through the service access
                  hatch.  Once you're through, you let go, and drop
                  the several feet to the elevator floor. "

    dobjFor(Close)
    {
        verify() { }
        action() { reportFailure('There\'s no need to do that, and it
            would take away the main source of light here. '); }
    }
    iobjFor(PutOn)
    {
        verify() { }
        action()
        {
            if (gDobj == elevPanelCover)
                replaceAction(Close, self);
            else
                reportFailure('That\'s not a good place to put
                    {that/him dobj}. ');
        }
    }
    iobjFor(PutIn)
    {
        verify() { }
        action() { "Better not; it's a long drop. "; }
    }
;

+ doorS2inner: TravelWithMessage, Door '"s2" door' 'door'
    "Like the other doors in this shaft, it's the kind that
    swings outward rather than the sliding type more typical of modern
    elevators.  The bottom of the door is a couple of feet above the
    top of the elevator.  The marking <q>S2</q> has been painted on with
    a stencil, and at the edge of the door is a locking mechanism. 
    <<isOpen ? "You're holding it open. "
             : isLocked ? '' : "It's just slightly ajar. " >> "

    descContentsLister = thingContentsLister
    isLocked = true

    dobjFor(Open)
    {
        check()
        {
            if (isLocked)
            {
                "The door won\'t budge.  You notice a locking
                mechanism at the edge of the door: probably a
                safety feature that keeps the door from being
                opened when the elevator isn\'t stopped at this
                floor. ";
                gActor.setIt(self);
                exit;
            }
        }
        action()
        {
            "You give the door a push and it swings open.  It's
            spring-loaded, so you have to hold it open. ";
            makeOpen(true);
        }
    }
    dobjFor(Push) remapTo(Open, self)
    dobjFor(Pull) remapTo(Open, self)
    dobjFor(Move) remapTo(Open, self)
    dobjFor(Unlock) remapTo(Unlock, elevLockSlot)

    cannotUnlockMsg = 'You\'ll have to be more specific about how
        you intend to do that. '

    beforeTravel(traveler, connector)
    {
        if (connector != self && isOpen)
        {
            "The elevator door slams shut as soon as you let go.<.p> ";
            makeOpen(nil);
            isLocked = true;
        }
    }

    travelDesc = "You climb the couple of feet over the raised threshold. "
;
++ Component 'stenciled s2 marking s2' '<q>S2</q> marking'
    "It's just a stenciled marking reading <q>S2</q>; it's presumably
    the floor number. "
;

++ elevLockSlot: Fixture 'narrow vertical door locking
    safety mechanism/lock/interlock'
    'locking mechanism'
    "It looks like a safety interlock, to prevent anyone from opening the
    door into the empty shaft when the elevator car isn't stopped at
    this floor.  The only exposed parts are a locking bolt and a narrow
    vertical slot about four inches deep and a foot long; presumably
    the elevator car has a corresponding part that slides into the slot
    when the car is stopped at this door. "

    dobjFor(Open)
    {
        verify()
        {
            if (location.isOpen)
                illogicalNow('The bolt is already unlocked. ');
        }
        action() { reportFailure('You fiddle with the bolt a bit, but
            you can\'t get it free, and your fingers don\'t fit into
            the slot. '); }
    }
    dobjFor(Unlock) asDobjFor(Open)

    lookInDesc = "The slot is too narrow to make out any detail of
        its inner workings. "

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
                "You try sliding the paper into the slot.  It easily
                fits, but it's too flimsy to trip the locking mechanism. ";
                exit;

            default:
                "{The dobj/he} do{es}n't fit in the slot. ";
                exit;
            }
        }
        action()
        {
            /* 
             *   check() will ensure we only make it here if we chose the
             *   right object 
             */
            "You slide the plate into the slot. ";
            if (location.isLocked)
            {
                "You move it up and down a bit, and you feel it catch
                on something.  You give it a little tug; with a
                click, the door unlatches and pops just a little
                ajar.  You remove the plate from the slot. ";
                
                location.isLocked = nil;
            }
            else
                "This doesn't have any obvious effect, so you remove
                the plate. ";
        }
    }

    /* 
     *   receive notification that we're the indirect object of a PUT IN
     *   involving multiple direct objects 
     */
    noteMultiPutIn(dobjs)
    {
        /* don't allow it */
        "You can only put one thing at a time in the slot. ";
        exit;
    }

    /* MOVE THROUGH SLOT, MOVE INTO SLOT -> PUT IN SLOT */
    iobjFor(PushTravelThrough) remapTo(PutIn, DirectObject, self)
    iobjFor(PushTravelEnter) remapTo(PutIn, DirectObject, self)
;
+++ Component 'locking mechanism vertical slot' 'slot'
    "It's about four inches deep and a foot long, and only a few
    millimeters wide. "

    /* map PUT IN, LOOK IN, etc to our location */
    iobjFor(PutIn) remapTo(PutIn, DirectObject, location)
    dobjFor(LookIn) remapTo(LookIn, location)
    iobjFor(PushTravelThrough) remapTo(PutIn, DirectObject, location)
    iobjFor(PushTravelEnter) remapTo(PutIn, DirectObject, location)
;
+++ Component 'locking mechanism bolt' 'locking bolt'
    "It's recessed into the mechanism enough that you can't really
    see how it works. "
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
s2HallWest: Room 'West End of Hallway' 'the west end of the hallway'
    'hallway'
    "This is the west end of a dimly-lit corridor.  The hall ends here
    with an elevator door to the west, and continues to the east. "

    vocabWords = 'hall/hallway'

    west = doorS2outer
    east = s2HallEast

    roomParts = static (inherited() - defaultEastWall)
;

+ doorS2outer: Door ->doorS2inner
    'elevator lift door/elevator/lift' 'elevator door'
    "It's an old-style elevator door that opens by swinging out
    rather than sliding sideways.  A round, black call button is
    next to the door, and above the button is a small neon lamp
    (currently <<isOnCall ? 'lit' : 'unlit'>>). "

    isOnCall = nil

    dobjFor(Open)
    {
        check()
        {
            "The door is locked and won't budge. ";
            exit;
        }
    }
    dobjFor(Unlock)
    {
        verify() { }
        action() { "It's locked from the other side; there's no obvious
            way to unlock it from this side. "; }
    }

    afterTravel(traveler, connector)
    {
        if (connector == doorS2inner)
        {
            "<.p>You hold the door open for Xojo, then let it swing
            shut after he comes through.  You hear the door latch as
            it closes. ";
            xojo.moveIntoForTravel(location);
            makeOpen(nil);

            /* award some points */
            scoreMarker.awardPointsOnce();

            /* have xojo start escorting us again */
            xojo.setCurState(xojoS2West);
            "<.p><q>Your plan of escape was conceived and executed
            with great excellence,</q> Xojo says. <q>The main
            canyon bridge is unfortunately not accessible from this
            sub-basement level, but I know of an alternative crossing.
            This way, please.</q>  He points down the hall. ";
        }
    }

    scoreMarker: Achievement { +2 "escaping the elevator shaft" }
;

++ Button, Fixture 'round black elevator lift call button' 'call button'
    "It's a big black button sticking out from the wall about
    a centimeter. "

    dobjFor(Push)
    {
        action()
        {
            if (!location.isOnCall)
            {
                "The lamp above the button lights dimly. ";
                location.isOnCall = true;
            }
            else
                "<q>Click.</q> ";
        }
    }
;
++ Fixture 'small neon lamp' 'neon lamp'
    "It's currently <<location.isOnCall ? 'lit' : 'unlit'>>. "
;

/* ------------------------------------------------------------------------ */
/*
 *   S2 hallway - east side 
 */
s2HallEast: Room 'Middle of Hallway' 'the middle of the hallway' 'hallway'
    "This long, dimly-lit corridor extends to the east and west.
    A low, narrow door leads north. "

    vocabWords = 'hall/hallway'

    west = s2HallWest
    east: FakeConnector, StopEventList {
        ['Xojo gently but firmly takes your arm and stops you.
        <q>Respectfully, we must not go that way,</q> he says.  He
        looks around almost conspiratorially and lowers his voice.
        <q>That is the domain of Junior Assistant Staff Functionaries,
        of Peon Grade and lower.  They are relegated to toil here in
        these nether regions, and in their misery they are desperate
        for any contact with even such lowly superiors as myself.
        Were we to venture thus, we could perhaps not escape the
        obsequious attentions of sub-peons for many hours.  Better
        to go this way instead.</q>  He indicates the door to the
        north. ',

        'Xojo stops you. <q>Sub-peon staffers that way lie,</q> he
        says. <q>Better to go this way.</q> He indicates the door. ']
    }
    north = s2HallEastDoor

    roomParts = static (inherited() - [defaultEastWall, defaultWestWall])
;

+ s2HallEastDoor: Door ->s2StorageDoor 'low narrow door' 'door'
    "It's a low, narrow door leading north. "
;

/* ------------------------------------------------------------------------ */
/*
 *   S2 Storage room 
 */
s2Storage: Room 'Storage Room' 'the storage room'
    "This dark, musty room is packed with boxes, crates, and random
    junk, jammed into every available space and stacked precariously
    from the floor to the low ceiling.  A narrow path seems to wind
    through the junk to the north.  A door leads south. "

    vocabWords = 'storage room'

    south = s2StorageDoor
    north = storagePath

    roomParts = [defaultFloor, defaultCeiling, defaultSouthWall]
;

+ s2StorageDoor: Door 'low narrow door' 'door'
    "It's a low, narrow door leading south. "
;

+ Decoration
    'random stack/stacks/box/boxes/crate/crates/junk/pile/piles/clutter/stuff'
    'junk'
    "It's just a lot of random junk. "
    isMassNoun = true
;

+ storagePath: TravelWithMessage, ThroughPassage 'narrow path' 'path'
    "It looks like enough of a path through the junk that you
    could get through. "

    travelDesc()
    {
        "You carefully pick your way through the piles of junk";
        if (!traversedBefore)
        {
            traversedBefore = true;
            myDust.makePresent();
            ", but the place is so cramped that you can't avoid getting
            covered with dust and cobwebs";
        }
        ". ";
    }

    traversedBefore = nil
;

/* ------------------------------------------------------------------------ */
/*
 *   North end of storage room
 */
s2Utility: Room 'Utility Area' 'the utility area'
    "This is the north end of a dark, musty storage room.  Junk is
    piled almost from floor to ceiling to the south, except for a
    narrow path that winds through the clutter.  This end of the
    room is mostly cleared of junk, probably to leave room to
    access the pipes, conduits, and other utility equipment arrayed
    near the north wall.  A round opening in the north wall leads
    outside; it looks like it was designed mostly for the pipes
    and conduits, but there's enough space left over for a person
    to fit through. "

    vocabWords = 'utility area/room'

    south = utilityPath
    north = utilityOpening

    roomParts = [defaultFloor, defaultCeiling]
;

+ Fixture 'north n wall*walls' 'north wall'
    "A round opening leads outside. "
;

++ utilityOpening: ThroughPassage 'round opening' 'round opening'
    "It's about a meter in diameter.  A number of pipes and conduits
    run through it, but there's enough space left over for a person
    to fit through. "
;

+ Fixture 'utility pipe/pipes/conduits/equipment' 'utility equipment'
    "A complex network of pipes and conduits fills most of the north
    end of the room, some connecting to pieces of equipment installed
    here, some going out through the round opening to the north,
    some running out through the floor or ceiling. "
    isMassNoun = true
;

+ Decoration
    'random stack/stacks/pile/piles/box/boxes/crate/crates/junk/clutter/stuff'
    'junk'
    "It's just a lot of random junk. "
    isMassNoun = true
;

+ utilityPath: TravelWithMessage, ThroughPassage ->storagePath
    'narrow path' 'path'
    "It's enough of a path that you could make it through the junk. "

    travelDesc = "You carefully pick your way through the piles of junk. "
;

/* ------------------------------------------------------------------------ */
/*
 *   platform outside storage room 
 */
s2Platform: OutdoorRoom 'Utility Platform' 'the utility platform'
    "This rickety walkway is little more than a steel grating
    bolted to the outside of the power plant building, suspended
    over a six-hundred foot drop into the canyon below.  The plant
    wall continues for another twenty feet below, where it reaches
    the top of the sheer cliff wall of the canyon.  The canyon
    wall drops almost vertically to the river below.

    <.p>A crude rope bridge over the canyon ends here.  This end
    of the bridge is tied to the steel grating of the platform,
    and the bridge extends out over the canyon to the north.

    <.p>Numerous pipes and conduits run up and down the wall of
    the building.  Many go in through the round opening in the
    wall to the south, but there's just enough space left over
    for a person to fit through the opening.

    <.p>A short distance east, the underside of the main bridge
    across the canyon is visible. "

    north: TravelMessage { -> ropeBridge1
        "You take a deep breath and carefully follow Xojo's lead,
        holding the main support ropes for balance and hunting
        around for footing on each step. " }

    south = platformOpening
    down: NoTravelMessage { "No way; it's much too big a drop. "; }

    roomParts = [s2PlatformFloor, defaultSky]

    roomBeforeAction()
    {
        if (gActionIn(Jump, JumpOffI))
        {
            "It's much too big a drop. ";
            exit;
        }
    }
;

+ platformBridge: Enterable 'crude rope bridge/ropes' 'rope bridge'
    "It really is a <i>rope</i> bridge---not a bridge made of
    wooden planks supported by ropes, like you've seen before,
    but a bridge literally made entirely of rope.  The walkway
    is formed by ropes arranged in a criss-crossed pattern to
    create a sort of sling hanging from the main supporting ropes,
    which could be used as handrails.  It looks very makeshift. "

    connector = (location.north)

    dobjFor(Cross) asDobjFor(Enter)
    dobjFor(Board) asDobjFor(Enter)

    dobjFor(Push)
    {
        verify() { }
        action() { "The bridge sways, a bit more than you'd expect. "; }
    }
    dobjFor(Pull) asDobjFor(Push)
    dobjFor(Move) asDobjFor(Push)
;

+ Distant, Decoration 'main underside/bridge/girders' 'main bridge'
    "All you can see from here is the steel girders supporting the
    roadway over the canyon. "
;

+ RopeBridgeCanyon 'sheer vertical cliff canyon river/wall/walls' 'canyon'
    "The canyon walls drop away almost vertically.  Judging distances
    on this scale by eye is almost impossible, but you've been told
    that the canyon is about six hundred feet deep. "
;

+ s2PlatformFloor: Floor 'steel metal platform/floor/grate/grating/walkway'
    'steel grating'
    "It's a simple steel grating, bolted to the side of the power
    plant building. "

    dobjFor(JumpOff)
    {
        verify() { }
        action() { "It's much too big a drop. "; }
    }
    dobjFor(JumpOver) asDobjFor(JumpOff)
;

+ Fixture 'utility pipe/pipes/conduits' 'pipes'
    "There are no markings you can read, so it's hard
    to tell what the specific purpose of any given pipe or
    conduit is. "
    isPlural = true
;

+ Fixture 'concrete government power plant 6 outside wall/building/side'
    'power plant'
    "The power plant wall towers several stories above, and ends
    not far below, at the top of the cliff wall.  A round opening
    leads into the building. "

    dobjFor(Enter) remapTo(TravelVia, platformOpening)
    dobjFor(GoThrough) remapTo(TravelVia, platformOpening)
;

++ platformOpening: ThroughPassage ->utilityOpening
    'round opening' 'round opening'
    "It's about a meter in diameter.  Pipes and conduits run through
    it, but there's space enough for a person to fit through. "
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
            "There's no place to put anything down here; it
            would probably fall through the gaps in the ropes. ";
            exit;
        }
        if (gActionIs(ThrowAt) && !gIobj.ofKind(RopeBridgeCanyon))
        {
            "Better not; {it dobj/he} would probably fall into the canyon. ";
            exit;
        }
        if (gActionIn(Jump, JumpOffI))
        {
            "No way; it's a very long way down. ";
            exit;
        }
        if (gActionIs(Wait))
        {
            "You'd rather not spend any more time here than necessary. ";
        }
    }
;

class RopeBridge: Fixture
    'rope rope/ropes/bridge/walkway/lattice' 'rope bridge'
    "The whole bridge is swaying considerably.  You don't want to
    spend any more time on this thing than you have to. "

    dobjFor(JumpOff)
    {
        verify() { }
        action() { "No way; it's a very long way down. "; }
    }
    dobjFor(JumpOver) asDobjFor(JumpOff)
    dobjFor(SitOn)
    {
        verify() { }
        check() { "It's not a very good place to sit. "; exit; }
    }
    dobjFor(LieOn)
    {
        verify() { }
        check() { "It's not a very good place to lie down. "; exit;  }
    }
    dobjFor(StandOn)
    {
        verify() { }
        check() { "You already are. "; exit; }
    }
    iobjFor(PutOn) remapTo(Drop, DirectObject)

    dobjFor(Cross)
    {
        verify() { }
        action() { "(If you want to continue across, just say which way.) "; }
    }

    dobjFor(Push)
    {
        verify() { }
        action() { "The bridge sways alarmingly. "; }
    }
    dobjFor(Pull) asDobjFor(Push)
    dobjFor(Move) asDobjFor(Push)
;

class RopeBridgeCanyon: Distant
    'sheer vertical cliff canyon river/canyon/(wall)/(walls)/cliff/cliffs'
    'canyon'
    "You're sure you're missing a great view, but right now you're
    too fixated on not falling to pay any attention. "

    iobjFor(ThrowAt)
    {
        verify() { }
        check()
        {
            "Better not; they have very harsh penalties for littering
            around here. ";
            exit;
        }
    }
;

class RopeBridgeMainBridge: Distant
    'main bridge/underside/girders' 'main bridge'
    "The main bridge is visible overhead and some distance east. "

    dobjFor(Examine)
    {
        /* make this less likely, like decorations */
        verify()
        {
            inherited();
            logicalRank(70, 'x distant');
        }
    }
;

/* ------------------------------------------------------------------------ */
    
/*
 *   The bridge - part 1 
 */
ropeBridge1: RopeBridgeRoom 'South End of Rope Bridge'
    'the south end of the rope bridge' 'rope bridge'
    "Standing on this bridge is a lot more difficult than it looked
    from the platform.  The whole thing wants to fold up under
    your weight, and the lattice of ropes making up the walkway shifts
    with every step. "

    north = ropeBridge2
    south = s2Platform

    atmosphereList: StopEventList {
    [
        'A sharp vibration shudders through the bridge, as though
        someone struck one of the ropes with a hammer. ',
        'A little gust of wind sets the bridge swaying alarmingly. ',
        'The ropes creak and groan disconcertingly. ',
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
ropeBridge2: RopeBridgeRoom 'Middle of Rope Bridge'
    'the middle of the rope bridge' 'rope bridge'
    "This is just about halfway across the bridge.  From here, the
    ends of the bridge are so far away they're not readily visible,
    making it almost feel like the bridge is floating in mid-air
    over the canyon. "

    south = ropeBridge1
    north = ropeBridge3

    atmosphereList: StopEventList {
    [
        'The whole bridge abruptly falls about three feet, then stops
        with a jerk.  Xojo looks back and laughs nervously. ',
        'The wind kicks up a little.  The bridge sways and twists. ',
        'A loud snapping noise comes from behind you somewhere. ',
        'The ropes creak and groan. ',
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
ropeBridge3: RopeBridgeRoom 'Hanging on a Rope Bridge'
    'the dangling rope bridge' 'rope bridge'
    "What was once a rope bridge is now hanging vertically alongside
    the north cliff of the canyon.  Fortunately, the construction of the
    bridge seems somewhat usable as a ladder.  It looks like it's only
    about fifty feet to the top of the cliff above; the rest of the
    bridge continues for some distance below. "

    enteringRoom(traveler)
    {
        if (traveler == me)
        {
            /* uh-oh... */
            "You think you're starting to get the hang of this, and you move
            forward with a little more confidence.  The north end of the
            bridge finally comes into sight---not much further now.
            <.p>The bridge shudders with a sharp shock and twists to
            the left.  You stop and hold on tight.  The vibration fades,
            but the walkway is still at an odd angle, so you try to shift
            your weight to right yourself.  Another shudder, and the
            bridge twists even more, then drops about six feet and jerks
            to a stop.  Your heart pounds and you hang on as tightly as
            you can.
            <.p>Xojo looks back. <q>Perhaps we should---</q>
            <.p>The bridge gives way, and you're in free-fall.  You hang
            on to the rope out of reflex, but it's just falling with you.
            Maybe not, though: the rope jerks tight and starts pulling
            you toward the north face of the cliff.  Suddenly you're
            falling sideways rather than down, the north cliff approaching
            fast.  You brace yourself for impact just before you slam
            into the cliff wall.
            <.p>After a couple of bounces, you more or less come to a stop.
            You take a look at yourself, and it doesn't look like you're
            bleeding.  Maybe you're so drenched with adrenaline that you
            don't realize how badly you're hurt yet, but you don't seem to
            have any serious injuries; you're undoubtedly a little bruised,
            but no major body parts seem broken or missing.  It looks like
            you lost one of your shoes, though. ";

            /* lose the shoe */
            myShoes.moveInto(nil);
            myLeftShoe.makePresent();
        }
    }

    up: TravelMessage { -> canyonNorth
         "It's a bit of work, but the rope lattice of the former walkway
         actually makes a pretty good ladder.  You make it to the top
         of the cliff in almost no time, and Xojo helps you up over
         the edge. " }

    down: FakeConnector { "You do a little quick arithmetic: the
         canyon is about a hundred meters across, as you recall, and
         two hundred deep.  If the whole bridge is still intact, that
         means the former south end would still be about a hundred
         meters above the floor of the canyon.  Up seems like a much
         better option. " }

    roomBeforeAction()
    {
        inherited();
        if (gActionIs(Stand) || gActionIs(StandOn))
        {
            "Standing isn't really an option right now. ";
            exit;
        }
    }
;

+ RopeBridgeMainBridge;

+ Distant 'river/canyon' 'canyon'
    "You'd rather not look down too much just now. "
    tooDistantMsg(obj)
        { return 'You\'d rather not look down too much just now. '; }
;

+ Fixture 'north n canyon rock wall/cliff/walls/cliffs/rock' 'canyon wall'
    "It's an almost vertical wall of rock. "
;

+ RopeBridge
    desc = "The collapsed bridge is hanging vertically from above. "
        
    dobjFor(Climb) remapTo(Up)
    dobjFor(ClimbUp) asDobjFor(Climb)
    dobjFor(ClimbDown) remapTo(Down)
    dobjFor(Cross) { action() { "That's out of the question at this
        point; climbing seems more likely. "; } }
;

/* ------------------------------------------------------------------------ */
/*
 *   North edge of canyon 
 */
canyonNorth: OutdoorRoom 'Edge of Canyon' 'the edge of the canyon'
    "This is a rough area strewn with rocks and overgrown
    with vegetation.  To the south, the sheer cliff wall of
    the canyon drops away almost vertically.  A little path
    leading northeast has been cut through the overgrowth.
    <.p>The end of the rope bridge is anchored to a pair of
    sturdy metal stakes driven into the rock.  The bridge
    itself hangs limply over the edge of the canyon. "

    northeast = canyonPath
    down: NoTravelMessage { "Nothing could persuade you to climb back
        down onto the bridge. "; }

    roomBeforeAction()
    {
        if (gActionIn(Jump, JumpOffI))
        {
            "You'd rather keep your distance from the canyon. ";
            exit;
        }
    }
;

+ canyonPath: TravelWithMessage, PathPassage ->courtyardPath
    'little path' 'path'
    "The path leads northeast, through the overgrowth. "

    travelDesc = "You follow the path through the dense foliage. "
;

+ Decoration 'rock/rocks' 'rocks'
    "Rocks of all sizes litter the area. "
    isPlural = true
;
+ Decoration 'dense lush tropical
    plant/plants/vegetation/overgrowth/jungle/foliage/overgrowth'
    'vegetation'
    "The dense, lush vegetation grows almost up to the edge of the
    cliff.  The only way through is the path leading northeast. "
    isMassNoun = true
;

+ cnRopeBridge: StairwayDown 'rope bridge' 'rope bridge'
    "The bridge hangs over the side of the canyon, disappearing
    into the distance below. "

    dobjFor(TravelVia)
    {
        check()
        {
            "Nothing could persuade you to set foot on that thing again. ";
            exit;
        }
    }
    dobjFor(Pull)
    {
        verify() { }
        action() { "The bridge is much too heavy to move. "; }
    }

    dobjFor(Cross) { verify() { illogical('It\'s more of a ladder
        than a bridge at this point, so it\'s not something you
        can cross any more. '); } }

    dobjFor(Board) asDobjFor(TravelVia)
    dobjFor(Enter) asDobjFor(TravelVia)
;

+ Fixture 'sturdy metal stake/stakes/pair' 'metal stake'
    "The stakes are driven deep into the rock to make a sturdy anchor. "

    dobjFor(Pull)
    {
        verify() { }
        action() { "The stakes are solidly embedded in the rock. "; }
    }
;

+ Distant 'sheer cliff river/canyon/wall/cliff/walls/cliffs/edge' 'canyon'
    "The view of the canyon isn't bad from here, but you don't want
    to get too close to the edge. "

    dobjFor(JumpOff) remapTo(Jump)
    dobjFor(JumpOver) remapTo(Jump)
;


/* ------------------------------------------------------------------------ */
/*
 *   Plant courtyard 
 */
plantCourtyard: OutdoorRoom 'Innergård' 'innergården'
    "Ett stort område av djungeln har röjts för att skapa denna innergård.
    Den enorma administrativa huvudbyggnaden omsluter området i norr och
    öster, och låga trästaket håller djungeln på avstånd i söder och väster.
    En smal stig leder sydväst in i djungeln. En uppsättning dörrar i öster
    leder in i byggnaden.
    <.p>Flera helikoptrar---du räknar till fem---står parkerade här, med
    rotorbladen som fortfarande snurrar långsamt. Dussintals personer som
    bär svarta Mitachron-logotyp polotröjor rusar omkring, många bär på
    lådor eller packlårar."

    vocabWords = 'innergård'

    in = adminDoorExt
    east asExit(in)
    southwest = courtyardPath

    atmosphereList: ShuffledEventList {
        ['Mitachron-folket är här med full styrka, det är säkert; all
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

+ courtyardPath: PathPassage 'smal stig' 'stigen'
    "Stigen leder sydväst in i djungeln. "
;

+ Distant 'frodig tropisk djungel/växt/växter/vegetation/växtlighet' 'djungel'
    "Vegetationen är frodig, tropisk och mestadels obekant för dig. "
;

+ Decoration 'lågt trä trästaket/staket' 'trästaket'
    "Staketen markerar innergårdens gränser i söder och väster.
    Djungeln ligger bortom. "
;

+ Decoration
    'fem svarta mitachron helikoptrar/helikopter' 'helikoptrar'
    "De är alla identiska: varje är helt svart, förutom den gula
    Mitachron-logotypen på stjärten. "

    isPlural = true
    notImportantMsg = 'Du vill inte komma för nära helikoptrarna;
                      Mitachron-folket kanske inte uppskattar att en
                      Omegatron-anställd nosar omkring. '
;
++ Decoration 'helikopter rotor/rotorer/rotorblad' 'rotorer'
    "Rotorerna snurrar fortfarande långsamt, som om piloterna höll
    helikoptrarna redo för en plötslig avfärd. "
;
++ Decoration 'helikopter gul mitachron stjärt/stjärtar' 'helikopterstjärtar'
    "Stjärten på varje helikopter är målad med Mitachron-logotypen. "
    isPlural = true
;

+ Decoration 'gul mitachron logotyp/logo' 'mitachron-logotyp'
    "Mitachron-logotypen är ett stort gult <q>M</q> i ett kraftigt sans-serif
    action-lutande typsnitt, överlagrat på en ljusgul kontur av en
    glob. Du har alltid tyckt att det symboliserar Mitachrons
    världsherravälde. "
;

+ Decoration
    'mitachron-logotyp polo anställd/anställda/arbetare/skjorta/skjortor/
    folk/man/kvinna*män kvinnor'
    'mitachron-folk'
    "Mitachron-folket går alla snabbt och målmedvetet, med uttryck av
    allvarlig beslutsamhet i ansiktena. De verkar stressade men inte
    panikslagna, som om de vet exakt vad de gör men inte har någon tid
    att förlora. De flesta bär lådor eller packlårar, och några bär
    skrivplattor och dirigerar de andra. "

    isPlural = true
    notImportantMsg = 'Du verkar inte kunna få någons uppmärksamhet. '
;
++ Decoration 'låda/packlår/lådor/packlårar/skrivplattor/headset/koffert/utrustning'
    'Mitachron-grejer'
    "Sakerna de bär på är av litet intresse för dig, förutom att allt
    detta förmodligen är för en omedelbar demonstration, vilket du gärna
    vill förekomma om möjligt. "
    isMassNoun = true
;

+ Enterable 'väldiga administrativa huvudbyggnad byggnader'
    'administrativa huvudbyggnaden'
    "Byggnaden är enorm: den sträcker sig hundratals meter från söder till
    norr, svänger sedan runt ett hörn och fortsätter hundratals meter från
    öster till väster. En uppsättning dörrar i öster leder in. "

    connector = adminDoorExt
;
+ adminDoorExt: Door ->adminDoorInt
    'administrativa huvudbyggnad dörr/dörrar/uppsättning'
    'administrationsdörrar'
    "Dörrarna leder in i byggnaden åt öster. "

    isPlural = true
;

/* ------------------------------------------------------------------------ */
/*
 *   The administration building lobby 
 */
adminLobby: Room 'Lobby' 'the lobby'
    "On past visits to the administration center, this large, open lobby
    was quite austere and utilitarian, but it's been transformed: it's
    festive, colorful, almost carnival-like.  The room is crowded with
    people talking and dancing.  Balloons and confetti fill the air, a
    live band plays from a stage, tables spread with food line the walls,
    waiters weave through the crowd with big trays of drinks.
    <.p>A set of doors leads outside to the west. "

    vocabWords = 'lobby'

    west = (gRevealed('talked-to-magnxi') ? noWest : adminDoorInt)
    out asExit(west)

    noWest: FakeConnector { "You try to make your way to the doors, but
        you can't get through the crowd. "; }

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
        ['<q>Excuse me!</q> a waiter shouts.  You make enough room
         for him to get past, and he moves away through the crowd. ',

         'The band finishes a song to a round of applause, then they
         start another. ',

         'A group of laughing people pushes past you. ',

         'The band plays a slightly quieter passage briefly, then
         the tempo picks up and they\'re even louder than before. ',

         'The tempo of the music slows down a little, and things get
          a little less noisy. ',

         'The music changes to a slower dance song. ',

         'The ad hoc dance area seems to expand to where you\'re standing,
         forcing you to move out of the way a little. '
        ] }
;

+ adminDoorInt: Door 'door/doors/set' 'doors'
    "The doors lead outside to the west. "
    isPlural = true

    dobjFor(TravelVia)
    {
        check()
        {
            if (gRevealed('talked-to-magnxi'))
            {
                "You try to leave, but there are too many people
                blocking the way through the doors. ";
                exit;
            }
        }
    }
;

+ Decoration
    'partying plant mitachron worker/workers/employees/crowd*people' 'crowd'
    "It looks like they're mostly plant employees, but many Mitachron
    people are here as well. "

    /* use normal Thing Examine verification rules */
    dobjFor(Examine) { verify() { inherited Thing(); } }
;

+ Decoration 'big waiters/waitresses/tray/trays' 'waiters'
    "The waiters are moving through the crowd carrying drinks. "
    isPlural = true
;

+ Decoration 'drink/drinks/cocktail/cocktails/glass/glasses' 'drinks'
    "The waiters are moving fast enough that you can't see exactly
    what drinks they have, but it looks like a wide range of cocktails. "
    isPlural = true

    dobjFor(Take)
    {
        verify() { }
        action() { drinkScript.doScript(); }
    }
    dobjFor(Drink) asDobjFor(Take)

    drinkScript: StopEventList { [
        'You\'re not much of a drinker normally, but right now you
        could really use something to calm your nerves.  You grab a
        glass from a passing waiter\'s tray and down it in one gulp.
        Practically the instant you\'re done, a waiter going the other
        direction collects your glass. ',

        'You grab another drink from a passing waiter and swallow it,
        a little less frantically this time.  A waiter collects the
        glass when you\'re done. ',

        'Better not overdo it; you still need to maintain a
        businesslike demeanor. ']
    }

    notImportantMsg = 'The drinks aren\'t especially interesting
        apart from their alcohol content. '

    dobjFor(GiveTo)
    {
        preCond = []
        verify() { }
        check()
        {
            "No need; {the iobj/he} can help {itself} if
            {it's} so inclined. ";
            exit;
        }
    }
;

+ Decoration 'balloons/confetti/decorations' 'decorations'
    "The decorations make the normally spartan lobby look festive. "
    isPlural = true
;

+ Decoration 'food/table/tables' 'tables of food'
    "Tables piled with food line the walls. "
    notImportantMsg = 'You think you\'ll hold off on joining the party
                       until you\'ve had a chance to talk to the Colonel. '
    isPlural = true
;

+ Decoration 'live band/stage' 'band'
    "They're playing big-band music.  They seem pretty good. "
    dobjFor(ListenTo) { verify() { logicalRank(50, 'x decoration'); } }
;

++ SimpleNoise 'big band big-band music/song' 'music'
    "The live band is playing big-band-style music. "
;

/* 
 *   once Frosst is mentioned, create an object for his un-presence, in
 *   case the player assumes he hasn't actually left yet 
 */
+ adminUnFrosst: PresentLater, Unthing
    'slight pale junior (mitachron) frosst belker/executive/man*men'
    'Frosst Belker'

    isProperName = true
    isHim = true

    notHereMsg = 'You don\'t see Frosst Belker here; he left after
        talking to the Colonel. '

    dobjFor(Follow)
    {
        verify() { }
        action() { "It's so crowded that you lost track of
            Frosst Belker as soon as he walked away. "; }
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   The colonel 
 */
magnxi: Person 'colonel grand high administrator magnxi/woman*women'
    'Colonel Magnxi'
    "Her official title is Grand High Administrator Magnxi, but she
    insists on everyone using her military title, and she always wears
    a dress uniform that looks like something out of the Napoleonic
    era.  You've never seen her wear this hat before, though; it pushes
    the bizarreness of her outfit to a whole new level. "
    isProperName = true
    isHer = true

    /* we know about the colonel from the start */
    isKnown = true

    scoreMarker: Achievement { +1 "getting Colonel Magnxi's attention" }

    beforeAction()
    {
        /* do the normal work */
        inherited();

        /* special handling if throwing something at the colonel */
        if (gActionIs(ThrowAt) && (gIobj == self || gIobj.isIn(self)))
        {
            "The Colonel might find that annoying, which is the last
            thing you'd want right now. ";
            exit;
        }
    }
;

+ InitiallyWorn
    'dress uniform/sash/sashes/ribbons/medal/medals/epaulets/outfit'
    'uniform'
    "It's like a 19th century museum piece: sashes, ribbons, medals,
    epaulets, the whole works. "

    /* 
     *   The English library tries hard to guess whether to use 'a' or
     *   'an', but 'u' words are too unpredictable for the library to get
     *   them right every time, and this is one that it gets wrong.  So, we
     *   need to override the aName to make it 'a uniform'.  
     */
    aName = 'a uniform'

    isListedInInventory = nil
;

+ InitiallyWorn 'military hat/insignia/brim' 'hat'
     "It's positively huge; it's proportioned like a novelty chef hat,
    ludicrously tall and ballooning outwards toward the top, but it's
    dark blue, made of stiff material, and adorned with military
    insignia.  It's about two sizes too large for the Colonel's
    head, and as a result it sits far too low on her head, almost covering
    her eyes. "

    isListedInInventory = nil
;

+ Decoration 'small group/people/companions' 'small group of people'
    "The place is so crowded that you can't see who she's with. "
    theDisambigName = 'Colonel Magnxi\'s companions'
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
    stateDesc = "She's chatting with a small group of people. "
    specialDesc = "Colonel Magnxi is here, chatting with a group of people. "

    tries = 0
    enterConversation(actor, entry)
    {
        switch (++tries)
        {
        case 1:
            "<q>Colonel Magnxi!</q> you shout, trying to be heard over
            the music, but the brass section picks just this moment to
            get really loud.  The Colonel doesn't seem to hear you. ";
            break;

        case 2:
            "You push your way through the crowd and wave your arms,
            shouting a little louder.  <q>Colonel! Colonel Magnxi!</q>
            She looks your way like she actually heard you this time,
            but a waiter cuts in front of you.  The waiter moves off,
            but Colonel Magnxi is talking to someone else again now. ";
            break;

        case 3:
            "You shout at the top of your lungs.  <q>Colonel Magnxi!</q>
            Just as you do, the music stops---your shout echoes
            through the suddenly quiet room.  Everyone turns and looks
            at you.
            <.p>The Colonel stares at you along with everyone else
            for a moment, then smiles.  <q>Oh, how lovely to see you
            again,</q> the Colonel says in her perfect English accent.
            She squints and wobbles a little, like she's had a bit to
            drink. <q>Mister, um, Mister Muddling, isn't it?  Well, do
            join us.  We were all just celebrating our new partnership
            with the Mitachron Corporation.  Isn't this a lovely party
            Mitachron are throwing for us?</q>
            <.p>New partnership?  <q>But, but...</q> you stutter, not
            believing what you're hearing.
            <.p>The band starts a new song, a bit less deafening
            than the last one.  <q>And did you see my brilliant
            new hat?</q> she asks, running her fingers around the
            oversized brim.  <q>It's a gift from Mr.\ Belker here.
            Really, Frosst, it's too much.</q>
            <.p>Oh, no.  You didn't see him here until just now.  The
            slight, pale man standing next to Magnxi is Frosst Belker,
            a junior executive at Mitachron.  You've crossed paths with
            him before, always on occasions just like this.
            <.p><q>Ah, Mr.\ Mittling,</q> Belker says with that damned
            smirk of his.  He speaks with a faint accent you've never
            been able to place, his vowels a bit elongated and nasal,
            his consonants a little too crisply enunciated.
            <q>Again we see there is no customer you can
            court which I cannot take away.</q>  He finishes his champagne
            and hands the glass to a passing waiter. <q>Colonel, a pleasure
            doing business, as always.  I must be on my way, but do enjoy
            the party.</q>  He and the Colonel embrace like diplomats,
            and then he turns to go, but he stops for a moment and
            looks your way.  <q>You too, of course, Mr.\ Mittling,</q>
            he says with another smirk, then chuckles and walks off,
            disappearing into the crowd.
            <.p>The colonel goes back to mingling.
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
            "You try to get the Colonel's attention again, but she's
            too busy talking to someone else. ";
            break;
        }

        /* 
         *   we can never actually enter a conversation, so stop the
         *   command here 
         */
        exit;
    }
;

adminEmail: Readable 'piece/paper/print-out/printout/email/e-mail'
    'print-out'

    "It's a print-out from an old-style line printer, printed on
    continuous fan-fold paper with alternating stripes of white and
    pale green.  It's an e-mail message from your boss; he must be
    back from Maui.  It's in his distinctive all-lower-case style;
    he does that to impress upon people that he's too important to
    waste his valuable time pressing the Shift key.  His spelling and
    punctuation styles are similarly streamlined.

    <.p><.blockquote>
    <tt>doug- hope your done with the demo by now.....when you get back
    i need you to go down to la to recrute a cal tech student named
    brian stamer.\ rudyb saw an artical about him someware hes all
    hot to hir ehim.\ do you no him....anyway rudyb wants you to
    go cause you went to cal tech.

    <.p>thx carl

    <.p>btw- im out of the office next month....important conference
    in fiji.\ im getting burned out from all this travel so im going to
    take some time off when i get back.\ if you need anything just email.

    <.p>bbtw- o-travel got you a grate!!!\ price on you're return
    flight.\ they found a downgrade to economy-minus, it has a couple
    xtra connectoins, im sure you wont mind.\ saves big $$$ in the bujit,
    fiji kind of pushed it over, rudyb is all like your overspending
    to much again so we all have to pitch in to costcut more.

    <.p>have fun in la!!!!!!!!!!!!!
    </tt>
    <./blockquote>

    <.p>Great.  You're not even back from this miserable trip yet and
    you already have another one scheduled.  Oh, well.  Might as well
    arrange for the ox cart back to the airport, or whatever it is the
    new, lower budget will allow... "

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

