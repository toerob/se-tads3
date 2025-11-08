#charset "utf-8"
/*
 *   Copyright 2003, 2013 Michael J. Roberts
 *   
 *   Return to Ditch Day - Frosst Belker.  Frosst is a fairly substantial
 *   NPC, so it's convenient to give him his own, separate source module.  
 */

#include <adv3.h>
#include <sv_se.h>


/* ------------------------------------------------------------------------ */
/*
 *   Frosst Belker 
 */
frosst: Person 'frosst belker/man+nen*män+nen' 'Belker'
    "Han är en spenslig man av medellängd med ganska blek hy.
    Du har svårt att gissa hur gammal han är; han ser ut att
    kunna vara allt från tjugofem till fyrtiofem år gammal. Han är klädd
    i vita byxor och en vit dubbelknäppt kavaj. "
    isProperName = true
    isHim = true

    /* 
     *   because we sometimes talk on the phone, delegate our sound
     *   description to the state, if it defines a soundDesc method
     */
    soundDesc
    {
        if (curState.propDefined(&soundDesc))
            curState.soundDesc;
        else
            inherited;
    }

    /* 
     *   List frosst just after other actors.  There are times when we
     *   refer to other actors, so it's best to list us after them. 
     */
    specialDescOrder = 220
;

+ InitiallyWorn 'vit+a dubbelknäppt+a kavaj+en/rock+en'
    'vit dubbelknäppt kavaj'
    "Det är en oklanderlig skräddarsydd dubbelknäppt vit kavaj. "
    isListedInInventory = nil
;

+ InitiallyWorn 'vit+a *byxor+na' 'vita byxor'
    "Det är ett par välskräddade vita kostymbyxor. "
    isPlural = true
    isListedInInventory = nil
;

+ frosstCellPhone: PresentLater, Thing 'mobil+telefon+en' 'mobiltelefon'
    "Den är så liten att den måste vara en ny modell, men du
    kan inte riktigt få en bra titt på den medan han använder den. "

    /* 
     *   don't list in inventory, as we'll mention the phone specially
     *   while it's in use 
     */
    isListedInInventory = nil
;

+ PresentLater, Container
    'mitachron^s+logotyp+en stor+a svart+a plast+påse+n' 'plastpåse'
    "Det är en stor plastpåse med Mitachrons logotyp på sidan. "

    plKey = 'logo-wear'
;


+ ActorState
    isInitState = true
    stateDesc = "Han står här med ett roat uttryck. "
    specialDesc = "Frosst Belker står här. Han har ett roat uttryck. "
;

++ DefaultAnyTopic
    "Belker ignorerar dig bara och tittar bort mot kvinnan
    i telefon. "
;

+ frosstTalking: ActorState
    stateDesc = "Han är här och pratar med fru Dinsdale. "
    specialDesc = "Frosst Belker är här och pratar med fru Dinsdale. "
;
++ DefaultAnyTopic
    "Han kastar en blick på dig men ignorerar dig och vänder sig
    tillbaka till fru Dinsdale. "
;

+ goingToStack: HermitActorState
    stateDesc = "Han går raskt och pratar med någon i en mobiltelefon. "
    specialDesc = "Frosst Belker går raskt förbi medan han pratar
        med någon i en mobiltelefon. "

    noResponse = "Belker ignorerar dig bara och fortsätter att gå. "
    soundDesc = "Han pratar för snabbt och tyst; du kan inte
        urskilja vad han säger. "

    takeTurn()
    {
        local path = [ccOffice, cssLobby, holliston, sanPasqual,
                      sanPasqualWalkway, quad, orangeWalk,
                      dabneyBreezeway, alley1S, alley1N];
        local idx;
        
        /* wherever we are, head off to our next location */
        switch (frosst.location)
        {
        default:
            /* 
             *   find our current location in our path, then increment it
             *   to get the next location to visit 
             */
            idx = path.indexOf(frosst.location) + 1;

            /* travel via the next connector */
            frosst.scriptedTravelTo(path[idx]);

            /* 
             *   if this is our final destination, switch Frosst to the
             *   state where he gets ready to start solving the stack 
             */
            if (idx == path.length())
                frosst.setCurState(stackSetup);
            break;
        }
    }
    sayDepartingThroughPassage(conn)
    {
        /* 
         *   if we're just leaving the Career Center Office, say nothing,
         *   since we've already mentioned that; otherwise, use the
         *   standard handling 
         */
        if (frosst.location != ccOffice)
            inherited(conn);
    }

    activateState(actor, prv)
    {
        /* inherit the base handling */
        inherited(actor, prv);

        /* take out the cell phone */
        frosstCellPhone.makePresent();
    }
;

+ stackSetup: HermitActorState
    stateDesc = "Han går runt i små cirklar och pratar
        snabbt i sin mobiltelefon. "
    specialDesc = "Belker är här och går runt i små cirklar
        medan han pratar i sin mobiltelefon. "
    noResponse = "Han ignorerar dig bara och fortsätter prata i sin telefon. "
    soundDesc = "Han pratar för snabbt och tyst; du kan inte
        urskilja vad han säger. "
;

+ frosstUnpacking: HermitActorState
    stateDesc = "Han står mitt i svärmen av flyttarbetare
        och styr deras rörelser. "
    specialDesc = "Belker står mitt i svärmen av flyttarbetare,
        pekar och ger order. "
    noResponse = "Han uppmärksammar dig inte medan han ger
        order till flyttarbetarna. "
    soundDesc = "Han ger bara order till flyttarbetarna&mdash;sätt
        det här, sätt det där, flytta detta, packa upp det. "

    alley1Atmosphere: ShuffledEventList { [
        'En flyttarbetare med en enorm låda manövrerar sig runt dig och tvingar
        dig att pressa dig mot väggen ett ögonblick. ',
        'En flyttarbetare kommer upp bakom dig med en låda, väntar på att
        du ska flytta på dig och går sedan förbi. ',
        'Ett par flyttarbetare kommer igenom med en låda som knappt får plats
        i grändens bredd. Du måste ducka och låta dem bära den
        över ditt huvud. ',
        'En av flyttarbetarna tappar en låda på golvet med en krasch.
        Belker tittar dit. Flyttarbetaren plockar upp lådan och fortsätter. ',
        'En flyttarbetare går förbi bärande på en rund låda. ',
        'Du måste stå åt sidan när ett par flyttarbetare som bär
        stora lådor försöker ta sig förbi dig. ',
        'En av de avgående flyttarbetarna stöter axeln mot dig men
        fortsätter bara förbi utan att ens titta på dig. ']
        
        eventPercent = 75
    }
;

/* 
 *   Frosst's state while initially figuring out the stack: his gang of
 *   technicians is using the MitaTest Pro 3000 to reverse-engineer the
 *   black box. 
 */
+ frosstSolving: HermitActorState
    stateDesc = "Han går långsamt fram och tillbaka och övervakar noga sina tekniker
        medan de använder testutrustningen. "
    specialDesc = "Belker går långsamt fram och tillbaka och övervakar
        teknikerna medan de använder testutrustningen. "
    noResponse = "Han tittar på dig men återgår till sin vandring
        utan att svara. "

    alley1Atmosphere: ShuffledEventList { [
        'Teknikerna fortsätter att sköta MegaTester 3000.',
        'Belker rådgör med en av teknikerna i några ögonblick.',
        'Tre av teknikerna samlas runt en av MegaTesters
        skärmar och pratar upprört med varandra.',
        'En högljudd larmsignal ljuder från MegaTester, och teknikerna
        börjar slå på kontrollerna i panik. De lyckas stoppa
        larmet efter några sekunder.',
        'Teknikerna justerar ivrigt kontrollerna på MegaTester.',
        'Ett par av teknikerna som sköter MegaTester byter plats,
        vilket tvingar dem att klämma sig förbi varandra i det trånga utrymmet
        bredvid maskinen.',
        'En av teknikerna går ner på händer och knän och tittar
        noga under bordet med den svarta lådan. Han reser sig och
        återvänder till MegaTester efter en minut.',

        /* 
         *   include the special sub-list - we'll get a special message
         *   each time we run this entry 
         */
        testOpsSubList,
        
        'En tekniker håller ut en stavliknande apparat ansluten med en
        tjock kabel till MegaTester och för den långsamt runt
        utsidan av den svarta lådan. Efter ett par varv runt
        lådan återvänder han till MegaTester och lägger undan staven.',
        'Belker talar med dämpad röst till ett par av teknikerna.',
        'Belker tar fram sin telefon, säger några ord i den och lägger
        tillbaka den i fickan.',
        'En av teknikerna ropar ut några siffror.',
        'MegaTester börjar avge ett djupt, mullrande ljud. Du kan
        känna det i golvet och du kan se väggarna skaka. Tio
        sekunder senare upphör ljudet abrupt.',
        'Flera av teknikerna byter plats vid MegaTester,
        och klämmer sig förbi varandra i den trånga gränden. ',
        'Ett starkt, oregelbundet ljus som gnistorna från en svetsbrännare
        blixtrar från någonstans bakom MegaTester i flera ögonblick.',

        /* 
         *   include the special sub-list again - this way we get a special
         *   message twice in each round of the ordinary messages 
         */
        testOpsSubList]
     
        eventPercent = 80
    }
;

/*
 *   Frosst's state for computing the answer to the stack's puzzle: his
 *   gang of technicians is using the Mitavac 3000 to figure out the
 *   Hovarth number. 
 */
+ frosstComputing: HermitActorState
    stateDesc = "Han går långsamt omkring och övervakar teknikerna
        som använder datorn. "
    specialDesc = "Belker går långsamt omkring och övervakar
        teknikerna. "
    noResponse = "Han ignorerar dig, hans uppmärksamhet är fäst på teknikerna. "

    alley1Atmosphere: ShuffledEventList { [
        'Teknikerna gör justeringar på datorn. ',
        'Belker rådgör tyst med en av teknikerna i
        några ögonblick. ',
        'Ett par av teknikerna byter plats vid Mitavac. ',
        'Mitavacs brummande verkar bli högre. ',
        'Mitavac piper mjukt några gånger, och en av
        teknikerna reagerar genom att göra flera snabba justeringar. ',
        'En av teknikerna pekar ut något för Belker,
        som nickar och återgår till sin vandring. ',
        'Belker lutar sig mellan två av teknikerna och gör
        en justering på datorn. ',
        'Mitavacs brummande verkar bli lite tystare. ']

        eventPercent = 80
        eventReduceAfter = 5
        eventReduceTo = 60
    }

    beforeAction()
    {
        /* do the normal work */
        inherited();
        
        /* check for pointlessly adjusting the dial */
        if (gActionIs(TurnTo)
            && gDobj == signalGenKnob
            && !(signalGen.isOn && signalGen.isAttachedTo(blackBox))
            && gRevealed('hovarth-solved')
            && !gRevealed('black-box-solved'))
        {
            /* remark on the third digit */
            if (++pointlessDialing == 3)
                "Du märker att Belker tittar på dig. <q>Det här vridandet
                verkar ganska meningslöst,</q> säger han. <q>Men
                du kanske har en anledning att manipulera denna enhet medan
                den är passivt <<signalGen.isOn ? 'avstängd' : 'frånkopplad'>>.</q>
                En av teknikerna påkallar sig hans uppmärksamhet och han
                vänder sig bort. ";
        }
    }

    /* count of times we've seen pointless signal generator dialing */
    pointlessDialing = 0
;

/* 
 *   An atmosphere sub-list for some special one-time-only events.  One
 *   entry of the main list points to this sublist, so once in a while, the
 *   sublist will come up in the random rotation.  At that point, we'll
 *   move on to the next item in the sub-list, working sequentially through
 *   the items until we've exhausted the list.  
 */
+ testOpsSubList: StopEventList
    ['<q>Klart!</q> ropar någon. Alla tekniker rusar till
     änden av hallen och hukar sig med ryggen mot MegaTestern,
     som låter som en jetmotor som startar. Ljudet
     upphör plötsligt, och ingenting händer på flera ögonblick, sedan
     fylls hallen av ett bländande ljussken för ett ögonblick.
     Allt verkar bli mörkblått med gula prickar. Du blinkar
     och kisar, och din syn återgår gradvis till det normala, vid vilket
     tillfälle teknikerna är tillbaka på sina stationer som om ingenting
     hade hänt.',

     'Alla monitorer på MegaTestern börjar blinka i takt,
     i ett blå-vit-blå-vitt mönster som upprepas flera gånger.
     Teknikerna hamrar frenetiskt på kontrollerna, och monitorerna
     återgår till det normala.',

     'Två av teknikerna närmar sig den svarta lådan och drar
     kablar från MegaTestern. De fäster försiktigt de
     avancerade kontakterna på kablarna till kontakten på
     den svarta lådan, och ger sedan någon sorts handsignal till
     de andra teknikerna, som ivrigt trycker på MegaTesterns
     kontroller. Operatörerna vid kontrollerna stannar
     slutligen och ger en annan handsignal till teknikerna med
     kablarna, som kopplar loss sina kablar och drar tillbaka dem
     in i MegaTestern. ',
     
     '<q>Förbered för omstart!</q> ropar en av teknikerna. Alla
     tekniker ställer sig en bit från MegaTestern och håller upp sina
     armar för att täcka ögonen. MegaTestern låter som en
     kameraflash som laddas, ett vinande som stiger i tonhöjd tills det är
     för högt för att höra; sedan mullrar det som avlägsen åska.
     MegaTestern spelar en liten piezoelektrisk <q>välkommen</q>-melodi, och
     teknikerna släpper sin hållning och återvänder till kontrollerna.',
     
     'En tekniker går fram till den svarta lådan med vad som ser ut
     som en enkel voltmeter. Hon rör försiktigt vid
     kontaktstiften ett i taget med voltmeterns kontakter,
     och tittar intensivt på mätaren. Hon återvänder till MegaTestern
     så snart hon är klar. ',

     'Någon ropar <q>Klart!</q> Teknikerna rusar bakom
     MegaTestern och hukar sig med ryggen mot den. Du kommer ihåg
     förra gången detta hände, så du sluter ögonen hårt och
     täcker dem med din hand. Precis som förra gången fyller ett jetmotor-
     liknande skrik gränden och tystnar sedan. Du väntar på
     blixten. Ingenting händer på väldigt lång tid. Sedan händer något,
     men det är inte en ljusblixt---det är någon slags
     spöklik glöd som går rakt igenom din hand och rakt igenom
     dina ögonlock, och för ett ögonblick ser du allt omkring dig
     i ett nästan svart foto-negativ, benen i din hand svarta
     mot en inte riktigt svart grändvägg, diffusa svarta konturer av
     de hukande teknikerna i hörnet, glödande svarta kugghjul och
     hjul inuti MegaTestern, Belkers ljust svarta mobiltelefon
     hängande i luften bredvid hans glödande svarta skelett. 
     Röntgensynen bleknar bort och du känner en värmebölja mot ditt ansikte
     och handen som fortfarande är framför dina ögon. Du kikar försiktigt
     genom fingrarna och ser att alla tekniker är
     tillbaka på sina stationer.',

     'Två av teknikerna kommer över och tittar noggrant runt
     lådan, sedan går de tillbaka till MegaTestern. ']
;


+ frosstAlleyConv: InConversationState
    specialDesc = (stateDesc)
    stateDesc = "Belker står i gränden och tittar på dig. "

    /* don't time out of this conversation */
    attentionSpan = nil
;
+ ConvNode 'meet-xojo'
    npcGreetingMsg = "<.p><q>Ah, herr Mittling.</q> Du tittar över
        och ser att Frosst Belker har kommit upp bredvid dig.
        <q>Har du tidigare gjort bekantskap med, öh, um...</q>
        <.p><q>Provanställd 119297, herrn,</q> säger Xojo
        skamset, krympande som om Belker skulle slå honom.
        <.p><q>Ja, naturligtvis. Så, jag antar att ni två känner
        varandra?</q> "

    noteLeaving()
    {
        /* end the conversation with both Frosst and Xojo */
        frosst.endConversation();
        xojo2.endConversation();
    }
;
++ YesTopic
    "<q>Xojo och jag träffades när jag arbetade med demonstrationen av
    Statligt Kraftverk 6,</q> säger du.
    <.p><q>Så trevligt,</q> säger Belker. <q>Så motvillig som jag är att
    avbryta era reminiscenser, måste jag påminna, öh, 119297 om den
    höga produktivitetsstandard som vi på Mitachron alltid
    måste sträva efter.</q>
    <.p><q>Jag är mycket tacksam för denna hjälpsamma påminnelseepisod,
    herrn,</q> säger Xojo, och rör sig sedan långsamt bort, arbetande med kontrollerna.
    Belker ler och återgår till sin vandring. "
;
++ NoTopic
    "<q>Nej, det tror jag inte,</q> säger du, i hopp om att hjälpa Xojo undvika
    att hamna i trubbel.
    <.p>Frosst pausar och ler svagt. <q>Du kanske är nyfiken
    på våra framsteg då. Jag beklagar att jag måste insistera på en viss
    grad av sekretess på grund av vår vänskapliga rivalitet; jag är säker på att du
    förstår.</q> Han tittar på Xojo, som långsamt smyger iväg.
    <q>Och jag är lika säker på att mina kollegor här mer än
    instämmer.</q> Han skakar på huvudet och återgår till sin vandring. "
;
++ DefaultAnyTopic
    "<q>Jag är mycket mer intresserad av din bekantskap med
    min kollega här. Känner ni faktiskt varandra?</q>
    <.convstay> "
;

/* 
 *   Frosst's state for near the end of the game, when we're entering
 *   digits into the black box.  This is an in-conversation state because
 *   we want to revert to our prior state when the PC wanders off or stops
 *   interacting with us.  
 */
+ frosstWatchingDigits: InConversationState
    specialDesc = "Frosst Belker står nära den svarta lådan
        och tittar på vad du gör. "
    stateDesc = "Han står nära den svarta lådan och tittar på dig. "

    /* always revert back to the 'computing' state when we give up */
    nextState = frosstComputing

    /* we get bored in this state quickly */
    attentionSpan = 2

    /* note that we're entering a digit */
    noteDigitEntry()
    {
        /* 
         *   if the PC is here, and frosst isn't already in this state,
         *   switch frosst to this state
         */
        if (me.isIn(alley1N) && frosst.curState != self)
        {
            /* set this state */
            frosst.setCurState(self);

            /* note Frosst's approach */
            "<.p>Frosst Belker kommer fram för att se vad du gör. ";
        }
    }

    /* generate our random comments */
    takeTurn()
    {
        /* do the normal work */
        inherited();

        /* if we're still in this state, do some more work */
        if (frosst.curState == self)
        {
            /* if the signal generator is off or detached, wander off */
            if (!signalGen.isOn || !signalGen.isAttachedTo(blackBox))
            {
                /* end the conversation */
                endConversation(me, endConvBoredom);
                
                /* we're done */
                return;
            }

            /* if we haven't conversed yet this turn, generate a comment */
            if (!frosst.conversedThisTurn())
                commentScript.doScript();
        }

        /* reset our boredom counter */
        frosst.boredomCount = 0;
    }

    /* our random comments */
    commentScript: ShuffledEventList {
        /* we'll go through this first list once, in this order */
        ['<q>Så, herr Mittling,</q> säger Belker, <q>du har listat ut
        metoden för att mata in siffror, ser jag.</q> ',
         'Belker klickar med tungan. <q>Om jag vore du, herr Mittling,
         skulle jag inte slösa den knappa tiden som återstår med att prova siffror
         på måfå.</q> ',
         'Belker skakar på huvudet. <q>Din beslutsamhet är beundransvärd,</q>
         säger han, <q>men säkert inser du omöjligheten i att lösa
         herr Stamers gåta genom uttömmande uppräkning.</q> ',
         '<q>I den här takten,</q> säger Belker, <q>kanske du hittar numret
         du söker, låt säga, om trettio år.</q> ',
         '<q>Vet du,</q> säger Belker, <q>mina ingenjörer kommer att ha
         det korrekta numret mycket snart. jag Kanske kan övertala dem att
         låta dig använda deras utrustning efteråt. Det skulle förstås
         vara för sent för dig att vinna, men åtminstone så kanske du får
         tillfredsställelsen att lösa gåtan på egen hand.</q> ',
         'Belker skrattar. <q>Herr Mittling, jag börjar undra om du
         ens vet vad för slags gåta du försöker lösa. Med tanke på
         den sena timmen tror jag det är säkert att ge dig en liten
         ledtråd: det har något att göra med en matematiker vid namn
         Hovarth.</q><.reveal frosst-hovarth-hint> ']

        /* ...then we'll show this list in shuffled order, if we need more */
        ['<q>Herr Mittling,</q> säger Belker, <q>jag finner det nästan
        outhärdligt att se en sådan uppriktig uppvisning av meningslöshet.</q> ',
         'Belker suckar. <q>Jag kan inte stå ut med att titta på dessa meningslösa
         ansträngningar från din sida mycket längre.</q> ',
         '<q>Denna fruktlösa ansträngning från din sida är uttröttande att titta på,</q>
         säger Belker. ',
         '<q>Säkert måste du tröttna på detta hopplösa, slumpmässiga
         fäktande,</q> säger Belker. ']
    }

    /* 
     *   our atmosphere list - we'll provide atmosphere with our comments,
     *   not through random background messages, so we don't need to do
     *   anything here 
     */
    alley1Atmosphere: Script { }

    endConversation(actor, reason)
    {
        /* do the normal work */
        inherited(actor, reason);

        /* mention that we're returning to work */
        "<.p>Frosst går tillbaka för att övervaka teknikerna. ";
    }
;

/*
 *   There's no point in having too many responses in this state, as most
 *   players at this point will be highly motivated to plow on through and
 *   enter the number without interruption.  However, provide a few
 *   responses just in case...  
 */

++ AskTellTopic @hovarthTopic
    "Du antar att Belkers tekniker har lyckats läsa
    meddelandet från den svarta lådan, men du vill inte avslöja något
    ifall de inte har gjort det. "
    isConversational = nil
;
+++ AltTopic
    "<q>Jag vet allt om Hovarth-tal,</q> skryter du.
    <.p>Belker höjer på ögonbrynen. <q>Jaså,</q> säger han.
    <q>Då borde du nog använda en stor superdator, som jag har gjort, 
    hellre än att envisas med detta slumpmässiga experimenterande.</q> "
    isActive = gRevealed('frosst-hovarth-hint')
;
++ DefaultAnyTopic, ShuffledEventList
    ['Innan du hinner börja prata vänder sig Belker bort för att
    tala kort med en av teknikerna. ',
     'Något på Mitavac avleder Belkers uppmärksamhet när du
     försöker prata med honom. ',
     'Belker verkar distraherad av den svarta lådan; han ignorerar dig bara. ']

    isConversational = nil
;

/* state when in room 4 during the endgame */
+ frosstRoom4: ActorState
    specialDesc = "Frosst Belker står bredvid dig. "
    stateDesc = "Han står bredvid dig. "
;
++ DefaultAnyTopic
    "Belker viftar avfärdande med handen. <q>Inte nu,
    herr Mittling,</q> säger han. "
;

/* in any communicative state, we should at least recognize Galvani-2 */
+ AskTellTopic [efficiencyStudy37, galvaniTopic]
    "<q>Vad vet du om Projekt Galvani-2?</q> frågar du.
    <.p>Belker höjer lätt på ögonbrynen. <q>Projekt
    Galvani-2?</q> frågar han. Han stryker sig om hakan. <q>Jag tror 
    tyvärr inte att det säger mig någonting.</q> "
    isActive = (efficiencyStudy37.seen)
;
+ GiveShowTopic @efficiencyStudy37
    "<q>Hur förklarar du det här?</q> frågar du och håller upp pärmen.
    <.p>Belker ger den en flyktig blick och viftar sedan bort den.
    <q>Jag känner inte till detta,</q> säger han avfärdande.
    <q>Om jag vore du skulle jag dock vara försiktig med sådana saker.
    Du kan väcka oönskad nyfikenhet om hur du kom i
    besittning av dem.</q> "
;

