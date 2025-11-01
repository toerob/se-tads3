#charset "utf-8"
/*
 *   Copyright 2003, 2013 Michael J. Roberts
 *   
 *   Return to Ditch Day - Sync Lab.  This includes the roof of the sync
 *   lab, the catwalks, and the crate-choked floor areas.  
 */

#include <adv3.h>
#include <sv_se.h>
#include "ditch3.h"


/* ------------------------------------------------------------------------ */
/*
 *   Sync lab roof 
 */

syncLabRoof: RoofRoom
    'Tak på Sync Lab' 'taket på Sync Lab' 'tak'
    "Takets yta verkar vara asfalt. Taket är platt, men ytan är ojämn
    på grund av många lagningar och reparationer. Nära den västra kanten
    reser sig en rektangulär anordning av omålad plåt ett par fot upp.
    <.p>Taket slutar i norr vid Firestones bakvägg, som reser sig
    ytterligare en våning härifrån. En stege är fäst vid väggen och
    leder upp längs byggnadens sida. "

    up = slrLadderUp
    down = (slrDoor.isOpen ? slrLadderDown : inherited)

    vocabWords = 'sync synkrotron lab+bet/laboratorium+et/byggnad+en/tak+et'
;

+ Floor
    'platt+a ojämn+a asfalt+iga tak+et/golv+et/yta+n/lagning+en/reparation+en/lagningar+na/reparationer+na'
    'tak'
    "Det är en ojämn asfaltyta. Taket slutar i norr vid Firestones bakvägg. "
    dobjFor(JumpOff) remapTo(Jump)
;

+ Distant, Decoration 'mark+en/gång+väg+en' 'mark/gångväg'
    "Marken är två våningar nedanför. "
;

+ Fixture 'bak+re blank+a firestone betong|vägg+en/lab/labb+et/laboratorium+et/byggnad+en'
    'Firestones bakvägg'
    "Firestone är bara en blank betongvägg på denna sida. En stege
    är fäst vid väggen och leder upp längs byggnadens sida. "
;
++ slrLadderUp: StairwayUp ->frLadder 'firestone stege' 'Firestone-stege'
    "Stegen är fäst vid Firestones vägg och leder upp längs byggnadens sida. "
;

+ Platform, Fixture
    'utstickande rektangulär+a omålad+e plåt+anordning+en/låda+n'
    'rektangulär anordning'
    "Det är en rektangulär låda på ungefär en och en halv meter varje sida och drygt 
    en halv meter hög. På toppen finns en metalldörr (som är <<slrDoor.openDesc>>). "

    dobjFor(Open) remapTo(Open, slrDoor)
    dobjFor(Close) remapTo(Close, slrDoor)
    dobjFor(LookIn) remapTo(LookIn, slrDoor)
    dobjFor(Enter) remapTo(Enter, slrDoor)

    /* när dörren är öppen betyder 'NER' härifrån att klättra ner för stegen */
    down = (slrDoor.isOpen ? slrLadderDown : inherited)
;

/* 
 *   detta är egentligen en behållare, inte en dörr, eftersom vi vill att den ska
 *   dölja schaktet och stegen när den är stängd 
 */
++ slrDoor: Fixture, Openable, RestrictedContainer
    'omålad+e metall+dörr+en/plåt+dörr+en' 'metalldörr'
    "Dörren är en tre fot stor kvadrat av samma plåt
    som den utstickande anordningen är byggd av. "

    /* tillåt inte att något läggs in här */
    cannotPutInMsg(obj)
    {
        gMessageParams(obj);
        return 'Bäst att låta bli; {det obj/han} kunde gå sönder i fallet. ';
    }

    /* 
     *   Anpassa våra innehållslistningsmeddelanden. Vi är inte en riktig
     *   behållare, eftersom inget kan läggas in manuellt i mig, så allt vi
     *   behöver oroa oss för är våra 'tom' statusmeddelanden. 
     */
    descContentsLister: thingContentsLister {
        showListEmpty(pov, parent)
        {
            if (parent.isOpen)
                "Dörren är öppen och avslöjar en smidessjärnsstege
                som leder ner i ett schakt. ";
            else
                "Den är för närvarande stängd. ";
        }
    }
    lookInLister = (descContentsLister)
    openingLister: openableOpeningLister {
        showListEmpty(pov, parent)
            { "När du öppnar dörren uppenbarar sig en smidessjärnsstege som
                leder ner i ett schakt. "; } 
    }

    dobjFor(Enter) remapTo(TravelVia, slrLadderDown)
    dobjFor(Board) remapTo(TravelVia, slrLadderDown)
    dobjFor(GoThrough) remapTo(TravelVia, slrLadderDown)
;
+++ Fixture 'schaktets mörkret+s schakt+et/mörker/(vägg+en)' 'schakt'
    "En smidessjärnsstege går ner i schaktet och försvinner
    i mörkret nedanför. "

    dobjFor(LookIn) remapTo(LookIn, location)
    iobjFor(PutIn) remapTo(PutIn, DirectObject, location)
    dobjFor(Enter) remapTo(TravelVia, slrLadderDown)
    dobjFor(Board) remapTo(TravelVia, slrLadderDown)
    dobjFor(Climb) remapTo(TravelVia, slrLadderDown)
    dobjFor(ClimbDown) remapTo(TravelVia, slrLadderDown)
;

++++ slrLadderDown: TravelWithMessage, StairwayDown
    'järn smide smidesjärns|stege+n*' 'smidesjärnsstege'
    "Stegen är fäst vid schaktets vägg. Den går ner i schaktet
    in i mörkret. "

    disambigName = 'stege i schaktet'

    travelDesc = "Dina ögon anpassar sig långsamt till det dunkla interiören
        när du klättrar ner för stegen. Efter ungefär tjugo pinnar når du
        en avsats. "
;

/* ------------------------------------------------------------------------ */
/*
 *   A class for sync lab catwalk rooms 
 */
class SyncCatwalkRoom: Room
    roomBeforeAction()
    {
        /* don't allow jumping here */
        if (gActionIn(Jump, JumpOffI))
        {
            "I det här ljuset går det inte att avgöra exakt hur långt det
            är till marken, men den ser inte ut att vara tillräckligt nära 
            för att försöka hoppa.";
            exit;
        }
    }

    name = 'catwalk'

    /* 
     *   Catwalk locations have some special room parts, but none of the
     *   usual ones.  We can't see the ceiling, and we can't see any walls
     *   except those explicitly mentioned, which we'll implement
     *   individually.  
     */
    roomParts = [catwalkFloor, syncLights, catwalkSpace]
;


catwalkFloor: Floor
    'smal+a matt+a grå+a galler gallret plåt stål metall upphöjd+a 
    gångbro+n/gångväg+en/golv+et/mönster/mönstret/x\'n'
    'gångbro'
    "Gångbrons golv är av matt grå metall, förmodligen stål.
    Det är präglat med ett rutmönster av upphöjda X, antagligen för
    att ge grepp. "

    /* behandla HOPPA AV GÅNGBRO på samma sätt som HOPPA */
    dobjFor(JumpOff) remapTo(Jump)
;

catwalkSpace: Distant, RoomPart
    'välvt välvd+a inre mörker/mörkret/utrymme+t/(byggnad+en)' 'mörker'
    "Byggnadens interiör verkar vara ett stort, öppet utrymme
    som sträcker sig nedåt och österut, men belysningen är otillräcklig för
    att se något bortom gångbron. "
    isNeuter = true
;

syncLights: Distant, RoomPart
    'svag+a gul+a lampa+n ljus:et+armatur+en*ljus+armaturer+na lampor+na' 'ljusarmaturer'
    "Armaturerna kastar ett svagt gult ljus, knappt tillräckligt för
    det stora utrymmet. "
    isPlural = true
;

/* ------------------------------------------------------------------------ */
/*
 *   Sync lab catwalk, south end on west side
 */

syncCatwalkSouthWest: SyncCatwalkRoom
    'Gångbro nära Stegen' 'gångbron nära stegen'
    "Detta är en smal metallgångbro som klänger sig fast vid den västra väggen i
    ett välvt inre utrymme. Svagt gult ljus silar ner
    från armaturer ovanför, men endast mörker är synligt nedanför.
    <.p>En smidessjärnsstege, fäst vid väggen, leder upp<<
      slrDoor.isOpen ? " till en liten öppning ovanför. En flik av
          himlen är synlig genom öppningen" : "" >>. 
    Gångbron fortsätter norrut längs väggen och slutar i söder
    vid en trappa som leder nedåt. "

    up = scswLadderUp
    down = scswStairDown
    south asExit(down)
    north = syncCatwalkNorth
;

+ Fixture 'väst+ra v betong+s vägg+en*väggar+na' 'västra väggen'
    "Väggen verkar vara gjord av betong. Den sträcker sig uppåt och
    nedåt in i mörkret. En stege som leder uppåt är fäst vid
    väggen här. "
;

+ scswLadderUp: StairwayUp ->slrLadderDown
    'smides|järnsstege+en/smidesstege+en' 'smidessjärnsstege'
    "Stegen går uppför väggen<< slrDoor.isOpen
      ? " till en liten öppning ovanför" : "" >>. "
    
    noteTraversal(trav)
    {
        /* beskriv förflyttningen */
        "Du tar dig uppför stegen";

        /* öppna dörren om nödvändigt */
        if (!slrDoor.isOpen)
        {
            ". När du når toppen hittar du en liten dörr i
            taket, som du skjuter upp. Du klättrar genom
            dörren ut i solljuset. ";

            slrDoor.makeOpen(true);
        }
        else
            ", klättrande ut genom öppningen när du når den. ";

        /* gör det normala arbetet */
        inherited(trav);
    }
;

+ scswStairDown: StairwayDown 'trappa+n/trappor+na' 'trappa'
    "Trappan leder ner i mörkret. "
;

/* 
 *   en intern behållare för att innehålla öppningen, som endast är synlig
 *   när dörren är öppen 
 */
+ Fixture, BasicContainer
    isOpen = (slrDoor.isOpen)
;
++ Distant 'li:ten+lla öppning+en' 'liten öppning'
    "En flik av himlen är synlig genom öppningen. "

    dobjFor(LookIn) remapTo(Examine, scswSky)
    dobjFor(LookThrough) remapTo(Examine, scswSky)
; 
++ scswSky: Distant 'synlig+a flik+en/him:mel+len' 'himmel'
    "Endast en liten flik av himlen är synlig härifrån. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Sync Catwalk North 
 */

syncCatwalkNorth: SyncCatwalkRoom
    'Gångbro, vid Hörnet' 'hörnet i gångbron'
    "Detta är ett hörn i den upphöjda metallgångbron. Gångbron
    fortsätter söderut, längs byggnadens västra vägg, och
    österut in i det dunkla halvljuset. "

    south = syncCatwalkSouthWest
    east = syncCatwalkGapWest
;

+ Fixture 'väst+ra v betong|vägg+en*betong|väggar+na' 'västra väggen'
    "Väggen verkar vara gjord av betong. Den sträcker sig uppåt och
    nedåt in i mörkret. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Some common elements of the gap rooms 
 */

/* the bridge across the gap, permanently hanging overhead */
MultiFaceted
    locationList = [syncCatwalkGapWest, syncCatwalkGapEast, syncOnCrate]
    instanceObject: Distant {
        'överhängande bro+n/undersida+n/vindbrygga+n' 'bro'
        "Den är för långt borta för att du ska kunna utgöra några detaljer, 
        särskilt i den svaga belysningen, men det ser ut som en sektion av 
        gångbron som skulle passa precis över gapet. "

        disambigName = 'överhängande bro'
    }
;

/* the catwalk sections and the gap */
syncCatwalkGapFloor: catwalkFloor
    'annan (öst+ra) (väst+ra) (ö) (v) gångbro+n/sektion+en/gap+et/fortsättning+en' 'gångbro'
    "Gångbron avbryts av ett gap, som ser ut att vara ungefär
    tre meter brett, österut. "

    dobjFor(JumpOver)
    {
        verify() { }
        action() { "Gapet är alldeles för brett för att hoppa över. "; }
    }
;

/*
 *   The top of the crate, as it appears from the ends of the catwalk
 *   adjacent to the gap. 
 */
metalCrateTop: MultiFaceted
    instanceObject: Enterable {
        -> syncOnCrate
        'särskilt stor+a enorm+a polerad+e aluminium metall|låda+n/topp+en/bro+n'
        'metallåda'
        "Lådans topp är ungefär i nivå med gångbron,
        vilket skapar en bro över gapet. "

        specialDesc = "En enorm metallåda är kilad mellan ändarna
            av gångbron. Dess topp är ungefär i nivå med gångbron,
            vilket skapar en bro över gapet. "

        /* GET ON and STAND ON are equivalent to ENTER */
        dobjFor(Board) remapTo(Enter, self)
        dobjFor(StandOn) remapTo(Enter, self)

        lookInDesc = "Det finns inget uppenbart sätt att öppna lådan för att
            titta inuti. "
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   Sync Catwalk West 
 */

syncCatwalkGapWest: SyncCatwalkRoom
    'Gångbro vid Gap' 'gångbron väster om gapet'
    "Gångbron sträcker sig västerut och slutar abrupt österut.
    En annan sektion av gångbron, uppenbarligen fortsättningen på
    denna, är knappt synlig ungefär tre meter längre österut.
    Ovanför gapet, högt uppe, syns undersidan av vad som ser ut
    att vara en bro.
    <.p>Precis på denna sida av gapet finns en kontrollpanel. "

    west = syncCatwalkNorth
    east = (metalCrateTop.isIn(self) ? syncOnCrate : noEast)
    noEast: NoTravelMessage { "Gapet är alldeles för brett för att hoppa över. "; }

    /* don't use the usual catwalk floor here, as there's another section */
    roomParts = static (inherited - catwalkFloor + syncCatwalkGapFloor)
;

+ Fixture 'kontroll+panel+en' 'kontrollpanel'
    "Panelen har två stora svampknappar, en röd och en grön.
    En handskriven skylt är fäst: <q>Ur funktion---Fastnat.</q> "
;
++ Button, Fixture 'stor+a röd+a svamp+knapp+en' 'röd svampknapp'
    "Det är en stor röd knapp med rundad topp. "
    okayPushButtonMsg = 'Knappen klickar, men inget annat verkar
        hända. '
    dobjFor(Switch) asDobjFor(Push)
;
++ Button, Fixture 'stor+a grön+a svamp+knapp+en' 'grön svampknapp'
    "Det är en stor grön knapp med rundad topp. "
    okayPushButtonMsg = 'Knappen klickar, men inget annat verkar
        hända. '
    dobjFor(Switch) asDobjFor(Push)
;
++ CustomImmovable 'handskriv:en+na skylt+en' 'handskriven skylt'
    "<q>Ur funktion---Fastnat.</q> "
    cannotTakeMsg = 'Att ta bort skylten kan skapa en säkerhetsrisk;
        bättre att låta den vara. '
;

/* ------------------------------------------------------------------------ */
/*
 *   On the crate in the gap in the catwalk 
 */
syncOnCrate: SyncCatwalkRoom
    'På Lådan' 'toppen av lådan' 'låda'
    "Detta är toppen av en låda, som är kilad mellan ändarna
    av gångbron i öst och väst. Lådan är tillräckligt stor
    att stå på, och fungerar som en bro över gapet. Ovanför
    syns en annan sektion av gångbron, upphängd ovanifrån. "

    east = syncCatwalkGapEast
    west = syncCatwalkGapWest
    
    roomParts = static (inherited - catwalkFloor)
;

+ Floor 'stor+a enorm+a polerad+e aluminium gångbrons topp+en metall+låda+n'
    'toppen av lådan'
    "Lådans topp är av polerad aluminium. Lådan är kilad
    mellan ändarna av gångbron, och toppen är ungefär i nivå
    med gångbron, vilket skapar en bro över gapet. "

    dobjFor(LookIn)
    {
        action() { "Det finns inget uppenbart sätt att öppna lådan för att titta
            inuti. "; }
    }
;

+ Distant '(öst+ra) (väst+liga) (ö) (v) sektion+en gång|bro+n/gång|väg+en' 'gångbro'
    "Sektioner av gångbron ligger österut och västerut. "
;


/* ------------------------------------------------------------------------ */
/*
 *   Catwalk, east of the gap 
 */
syncCatwalkGapEast: SyncCatwalkRoom
    'Gångbro vid Gap' 'gångbron öster om gapet'
    "Gångbron sträcker sig österut och slutar här i väster. Svagt
    synlig över ett gap på ungefär tre meter är en annan sektion av
    gångbron, uppenbarligen en fortsättning på denna; högt ovanför,
    över gapet, syns undersidan av vad som ser ut att vara en bro. "

    east = syncCatwalkEast
    west = (metalCrateTop.isIn(self) ? syncOnCrate : noWest)
    noWest: NoTravelMessage { "Gapet är alldeles för brett för att hoppa över. "; }

    /* don't use the usual catwalk floor here, as there's another section */
    roomParts = static (inherited - catwalkFloor + syncCatwalkGapFloor)

    /* on the first arrival, award points for finding our way here */
    afterTravel(traveler, conn)
    {
        scoreMarker.awardPointsOnce();
        inherited(traveler, conn);
    }
    scoreMarker: Achievement { +5 "korsa gapet i gångbron" }
;

/* ------------------------------------------------------------------------ */
/*
 *   Catwalk, east wall.
 */
syncCatwalkEast: SyncCatwalkRoom
    'Gångbro, Utanför Kontoret' 'gångbron utanför kontoret'
    "Denna sektion av gångbron löper längs framsidan av en trästruktur
    i norr. Strukturen liknar ett litet hus; en grå dörr (<<sceDoor.openDesc>>)
    i väggen är märkt med <q>Kontor.</q>
    <.p>Gångbron fortsätter västerut och slutar i en betongvägg österut.
    Söderut leder en trappa nedåt. "

    west = syncCatwalkGapEast

    north = sceDoor
    in asExit(north)

    down = sceStairs
    south asExit(down)
;

+ Fixture 'öst+ra ö betong+vägg+en*betongväggar+na' 'östra väggen'
    "Väggen verkar vara gjord av betong. "
;

+ sceDoor: Keypad, Lockable, Door 'trist+a grå+a "kontor" kontor^s+dörr+en' 'grå dörr'
    "<q>Kontor</q> är målat med bleknade bokstäver på den trista
    grå dörren. Ett numeriskt knappsatslås sitter där dörrhandtaget
    normalt skulle vara. "

    isLocked() { return sceKeypad.combo != internCombo; }

    /* allow automatic unlock on open once we've used the combination once */
    autoUnlockOnOpen = (usedCombo)

    /* the lock status is never visually apparent */
    lockStatusObvious = nil

    /* the internal combination - just the string of digits in the combo */
    internCombo = static (infoKeys.syncLabCombo)

    /* the display version of the combination, with hyphens between digits */
    showCombo = static (rexReplace('(<digit>)(?=<digit>)', internCombo,
                                   '%1-', ReplaceAll, 1))

    /* we haven't used the combination before */
    usedCombo = nil

    dobjFor(Lock)
    {
        action()
        {
            "Du knappar in nollor för att rensa kombinationen, vilket borde
            låsa dörren. ";
            sceKeypad.combo = '00000';
        }
    }
    dobjFor(Unlock)
    {
        check()
        {
            if (!usedCombo)
            {
                "Det verkar som om du måste ange en kombination på
                knappsatsen för att låsa upp dörren. ";
                exit;
            }
        }
        action()
        {
            "Du slår in kombinationen på knappsatsen; ett mjukt
            klick hörs från mekanismen. ";
            sceKeypad.combo = internCombo;
        }
    }
    dobjFor(Open)
    {
        action()
        {
            /* 
             *   do the normal work; if we managed to open the door, make a
             *   note that we've successfully used the combination
             */
            inherited();
            if (isOpen)
                usedCombo = true;
        }
    }

    /* type/enter a sequence on the door is the same as typing on the lock */
    dobjFor(EnterOn) remapTo(EnterOn, sceKeypad, gLiteral)
    dobjFor(TypeLiteralOn) remapTo(EnterOn, sceKeypad, gLiteral)
;
++ sceKeypad: Keypad, Fixture
    'elektronisk+a (dörrens) knappsats:en^s+lås+et/mekanism+en'
    'knappsatslås'
    "Det är en elektronisk knappsats. Det finns ingen display; bara knappar
    märkta 0 till 9. "

    /* current combination */
    combo = '000000'

    dobjFor(EnterOn)
    {
        verify() { }
        action()
        {
            local str;
            local change;

            /* remove spaces and dashes from the entered string */
            str = rexReplace('<space|->', gLiteral, '', ReplaceAll, 1);

            /* make sure it looks valid */
            if (rexMatch('[0-9]+', str, 1) != str.length())
            {
                "Endast siffror kan anges på knappsatsen. ";
                return;
            }

            /* if the door's open, ignore it */
            if (location.isOpen)
            {
                "Knappsatsen avger ett långt pip när du trycker på varje knapp. ";
                return;
            }

            /* check to see if we're changing state */
            change = (location.isLocked != (str != location.internCombo));

            /* set the combination */
            combo = str;
            "Du trycker på knapparna i sekvens. ";

            /* check for a change in state */
            if (change)
                "Mekanismen klickar mjukt. ";
        }
    }
    dobjFor(TypeLiteralOn) asDobjFor(EnterOn)
;
+++ Button, Component
    '(låsets) (knappsats) numrerade 0 1 2 3 4 5 6 7 8 9 knapp+en*knappar+na'
    'låsknappsatsknapp'
    "Knappsatsen har knappar märkta 0 till 9. "

    dobjFor(Push) { action() { "(Du behöver inte trycka på knapparna
        individuellt; ange bara kombinationen på knappsatsen.) "; } }
;


+ Enterable ->(location.north) 'träig+a träaktig+a li:ten+lla struktur+en/hus+et/kontor+et'
    'trästruktur'
    "Strukturen är gjord av trä och ser ut som ett litet hus.
    En dörr märkt <q>Kontor</q> leder in. "
;

+ sceStairs: StairwayDown
    'metall+trappa+n/trappor+na' 'metalltrappa'
    "Trappan leder ner i mörkret nedanför. "
;

/* ------------------------------------------------------------------------ */
/*
 *   The sync lab office 
 */

syncLabOffice: Room
    'Kontor' 'kontoret'
    "Detta lilla rum med lågt i tak är mestadels upplyst av glöden från
    en rad videomonitorer uppradade längs en vägg. I
    mitten av rummet, vänd mot monitorerna, står ett U-format
    skrivbord med en kontorsstol; en dator står på skrivbordet. Mittemot
    monitorerna finns en uppsättning hyllor fyllda med rader av identiska
    svarta pärmar. En grå dörr leder ut söderut. "

    south = sloDoor
    out asExit(south)

    /* on the first arrival, award points for finding our way here */
    afterTravel(traveler, conn)
    {
        scoreMarker.awardPointsOnce();
        inherited(traveler, conn);
    }
    scoreMarker: Achievement { +10 "ta sig in i Sync Lab-kontoret" }
;

+ sloDoor: Lockable, Door ->sceDoor 'trist+a grå+a dörr+en' 'grå dörr'
    "Dörren är målad i en trist grå färg. "
;

+ Fixture
    'statisk+a li:ten+lla rad+en video monitor+n/skärm+en/
    bild+en/tv+n/television+en*tvs bilder+na monitorer+na skärmar+na'
    'rad av monitorer'
    "De ser ut som övervakningsmonitorer man skulle se i
    en närbutik: små skärmar som visar statiska bilder
    tagna genom fiskögonlinser. Bilderna ser ut att vara från inomhusmiljöer
    ---några ser ut som kontor, andra som laboratorier. Du
    skannar igenom monitorerna och inser att en av dem
    visar en bild av Stamers labb. "
    isPlural = true
;

+ Intangible 'stamers bild+en/labb+et/laboratorium+et' 'bild av Stamers labb'
    "Bilden har ganska låg upplösning, och kameran verkar vara
    placerad i en konstig vinkel, men du är ganska säker på att detta
    kommer från SPY-9-kameran i labbet. "

    sightPresence = true
    dobjFor(Examine) { verify() { inherited(); } }
;

+ Heavy, Chair 'aeleron (skrivbords) kontors|stol+en' 'kontorsstol'
    "Det är en av de där fancy Aeleron-stolarna, den typ som alla
    VP:s har på Omegatron. "
;

+ Heavy, Surface 'u-formade u-format skrivbord+et' 'skrivbord'
    "Skrivbordet är format som ett U, så att det omsluter sin
    användare. En dator är placerad något till sidan
    om mitten. "
;

++ Keypad, CustomImmovable
    'mita+mail e-post epost email dator+n/mita+mail+en/e-post|terminal+en' 'dator'
    "Det är faktiskt inte en dator; det är egentligen en av de där
    hemska MitaMail e-postterminalerna. Ingen påstår sig gilla
    dem, men Mitachron har på något sätt sålt miljoner av dem;
    de är till och med allestädes närvarande på Omegatron.
    <.p>Terminalen är en enhet med en bärnstensfärgad text-
    display och ett tangentbord. "

    dobjFor(TypeLiteralOn)
    {
        verify() { }
        action()
        {
            "Så fort du börjar skriva dyker ett kryptiskt felmeddelande
            upp på skärmen. Du provar ett par andra tangenter,
            och som tur är hittar du en som rensar felet. ";
        }
    }

    dobjFor(Read) remapTo(Read, mitaMailDisplay)

    nextMessage()
    {
        /* advance to the next message if possible */
        if (curMessageIdx < messageList.length())
            ++curMessageIdx;

        /* show the new message */
        "Displayen blinkar några gånger och uppdateras sedan:<<showMessage>> ";
    }
    prevMessage()
    {
        /* back up if possible */
        if (curMessageIdx > 1)
            --curMessageIdx;

        /* show the new message */
        "Displayen blinkar några gånger och uppdateras sedan:<<showMessage>> ";
    }

    showMessage()
    {
        "<.p><.blockquote><tt>
        <<messageList[curMessageIdx]>>
        </tt><./blockquote>";
    }

    curMessageIdx = 2
    messageList = [
        '@@# 392003-99203: VID SPOLE BOF {{[F13]}} INTE TILLÅTEN
        \n@#@ 392770-20399: FELAKTIG FKEY-TRYCKNING, SE SUBEXC
        \n@@# 392060-39902: ANVÄND {{[F7]}} FÖR ÅTERUPPTAGANDE AV FUNKTION',

        'Från: frosstb@mitachron.com
        \nTill: normf@mitachron.com
        \nÄmne: Sv:\ forskningsledtrådar
        \bJag har etablerat mitt kontor här i Pasadena, i ett oanvänt
        utrymme som säkert kommer att gå obemärkt förbi. Detta kommer att 
        påskynda vårt arbete här avsevärt.
        \bEnligt vår diskussion i måndags har vi slutfört vår lista över
        intressanta projekt och har påbörjat installation av video-
        utrustning på de identifierade platserna. Vi samlar redan in data
        från experimentet med neutronens magnetiska dipolmoment; vi
        hoppas ha anti-dekoherens och Z0-precession klara nästa
        vecka. NI CO kommer att vara fullt bemannat inom fjorton dagar.
        \n-fb',

        'Från: normf@mitachron.com
        \nTill: frosstb@mitachron.com
        \nÄmne: Sv:\ forskningsledtrådar
        \bFrosst - Vi är mycket nöjda med framstegen hittills.
        Vänligen påskynda de återstående installationerna. Ägna särskild
        uppmärksamhet åt anti-dekoherensexperimentet: Galvani-2-
        teamet har visat intresse för detta och tror att det är
        högst relevant.
        \b-Norm<.reveal galvani-2>',

        'Från: frosstb@mitachron.com
        \nTill: normf@mitachron.com
        \nÄmne: Sv:\ forskningsledtrådar
        \bVi har slutfört installationen av all videoutrustning.
        Enligt din anvisning övervakar vi anti-dekoherens-
        projektet med särskilt intresse. Projektet verkar
        fortskrida väl; vi samlar in data kontinuerligt
        och kommer att rapportera när det är lämpligt.
        \b-fb',

        'Från: Cindy Anderson
        \nTill: frossta@mitachron.com,
        frosstb@mitachron.com,
        frosstc@mitachron.com,
        frosstd@mitachron.com,
        frosste@mitachron.com,
        frosstf@mitachron.com,
        frosstg@mitachron.com,
        frossth@mitachron.com,
        frossti@mitachron.com,
        frosstj@mitachron.com,
        frosstk@mitachron.com,
        frosstl@mitachron.com,
        frosstm@mitachron.com,
        frosstn@mitachron.com,
        frossto@mitachron.com,
        frosstp@mitachron.com,
        frosstq@mitachron.com,
        frosstr@mitachron.com,
        frossts@mitachron.com,
        frosstt@mitachron.com,
        frosstu@mitachron.com,
        frosstv@mitachron.com,
        frosstw@mitachron.com,
        frosstx@mitachron.com,
        frossty@mitachron.com,
        frosstz@mitachron.com
        \nÄmne: sänk din bolåneränta! axjshe0193098 intensiv ingenstans
        \bBetalar du 10%, 15%, till och med 20% för ditt bolån?!? Inte
        mer! Nu kan du få de lägsta bolåneräntorna punkt!
        \b&gt;&gt;&gt;KLICKA HÄR!!!&lt;&lt;&lt;
        \bÄven världens lägsta pris på örtbaserad Vigara!
        \b(Detta är INTE SPAM! Om du får detta meddelande är det
        för att du är på en noggrant utvald OPT-IN-lista. Det är inte
        fysiskt möjligt för detta att vara SPAM eftersom du har VALT ATT DELTA.
        För att tas bort från denna lista, som du har VALT ATT DELTA i så
        detta är INTE SPAM, kom bara och besök våra kontor och be oss
        personligen att ta bort dig. Du kan hitta våra kontor genom vår
        ISP - men det är inte för att vi blir utkastade, vi är
        legitima affärsmänniskor och INTE SPAMMARE, våra ISP:er kan inte
        kasta ut oss för SPAMMING eftersom VI REDAN LÄMNADE DEM! HA!) ',

        'Från: izrum@mitachron.com
        \nTill: frosstb@mitachron.com
        \nÄmne: anti-dekoherensdata
        \bFrosst - Norm fått i uppdrag att kontakta 
        dig angående det anti-dekohärensexperiment du är
        utför. Mitt team har utför första Galvani-2 
        fältutplaceringtest. 
        Framgång endast delvis, på grund av samma 
        lokaliseringsbegränsningar som påträffats i
        G-1. Är nu övertygad om anti-dekoherensteknologi
        för att lösa problem.
        \bHar över natten skickat (DefEx) rapport om experiment hos 
        dig i Pasadena-plats. Av säkerhetsskäl är i svart status-
        rapportpärm med titel Effektivitetsstudie #37. Granska
        vänligen.
        \b/IhM.',

        'Från: frosstb@mitachron.com
        \nTill: izrum@mitachron.com
        \nÄmne: sv:\ anti-dekoherensdata
        \bIzru - Bifogat är våra data insamlade från anti-dekoherens-
        experimentet. Vi har utfört några preliminära analyser, och jag
        tror du kommer att finna det ganska tillämpbart på Galvani-2.
        \b-fb
        \b@#@BILAGA:&lt;&lt;DEKOHER1.XLS&gt;&gt;
        \n#@#BILAGA BORTTAGEN ENLIGT POLICY FÖR VIRUSSKANNING',

        'Från: normf@mitachron.com
        \nTill: frosstb@mitachron.com
        \nÄmne: förströelse
        \bBra jobb hittills i Pasadena. Izru berättar för mig att Galvani-2
        kommer att dra stor nytta.
        \bIntresserad av att ta en dag eller två för en rolig förströelse?
        Vi hörde just att O. lägger bud på ett stort kraftverkskontrakt i Asien.
        Vi vill egentligen inte ha det, men jag vet hur mycket du tycker om att 
        leka med dem. Om du är intresserad, ta företagsplanet och åk
        och gör din vin-och-mat-grej. Sarah har detaljerna.
        \b-Norm',

        'Från: izrum@mitachron.com
        \nTill: frosstb@mitachron.com
        \nKopia: normf@mitachron.com
        \nÄmne: sv:\ anti-dekoherensdata
        \bFrosst - översvallande tack för datakalkylblad. Mycket intressant.
        Alla nu övertygade om relevans. Tyvärr, nuvarande expertis
        inom området nu otillräcklig. Att rekommendera anställning av medlem från
        experimentteam från Caltech. Norm har godkänn personalstyrka;
        välja vänligen kandidat och rekrytera.
        \b/IhM.',

        'Från: frosstb@mitachron.com
        \nTill: izrum@mitachron.com
        \nKopia: normf@mitachron.com
        \nÄmne: sv:\ anti-dekoherensdata
        \bIzru - enligt din begäran har vi identifierat kandidater i
        anti-dekoherensexperimentteamet. Toppkandidaten är en
        herr B. Stamer. Han är en avgångsstudent, så vi kommer lätt att
        få honom genom de vanliga högskolerekryteringskanalerna.
        \b-fb',

        'Från: normf@mitachron.com
        \nTill: frosstb@mitachron.com
        \nÄmne: sv:\ anti-dekoherensdata
        \bPlanen för studentanställning är helt rätt. Frosst, jag vill att du
        hanterar detta personligen. Galvani-2 växer i strategisk
        betydelse och vi behöver denna expertis snabbt.
        \b-Norm',

        '@@# 392003-29903: VID SPOLE EOF {{[F7]}} INTE TILLÅTEN
        \n@#@ 392770-92903: FELAKTIG FKEY-TRYCKNING, SE SUBEXC
        \n@@# 392060-23990: ANVÄND {{[F13]}} FÖR ÅTERUPPTAGANDE AV FUNKTION']
;

+++ mitaMailDisplay: Component, Readable
    'mitamail+en e-post epost email datorns terminal+ens bärnstensfärgad+e text+en dator|display+en/dator|skärm+en'
    'datordisplay'
    "Displayen visar för närvarande ett meddelande i bärnstensfärgad text:
    <.p><<location.showMessage>> "
;

/*
 *   The keyboard.  Make this match 'key' and 'keys', and make the
 *   individual keys match these words only weakly - this will ensure that
 *   these words are never ambiguous, since when used without an adjective
 *   they'll just refer to the overall keyboard object. 
 */
+++ Component
    'mitamail+en e-post epost email datorns terminal+ens tangentbord+et/tangent+er*tangenter+na' 'tangentbord'
    "Tangentbordet har en rad funktionstangenter ovanför de vanliga
    tangenterna. Du har använt dessa precis tillräckligt för att veta 
    att du trycker på F7-tangenten för att gå till nästa meddelande, 
    och F13 för att gå till föregående meddelande. "

    dobjFor(TypeOn) remapTo(TypeOn, location)
    dobjFor(TypeLiteralOn) remapTo(TypeLiteralOn, location, IndirectObject)
;
class MitaMailFKey: Button, Component
    desc = "Funktionstangenterna är i en rad ovanför huvudtangentbordet.
        De är märkta F1 till F17. "
;
++++ MitaMailFKey
    'f1 f2 f3 f4 f5 f6 f8 f9 f10 f11 f12 f14 f15 f16 f17
    (funktions|tangent+en)*(funktions|tangenter+na) rader+na'
    'rad av funktionstangenter'

    dobjFor(Push) { action() { "Du trycker på tangenten, och displayen
        visar ett kryptiskt felmeddelande. Du provar ett par andra
        tangenter, och som tur är lyckas du rensa felet. "; } }
;
++++ MitaMailFKey 'f7 (funktion) (tangent)' 'F7-tangent'
    dobjFor(Push) { action() { location.location.nextMessage(); } }
;
++++ MitaMailFKey 'f13 (funktion) (tangent)' 'F13-tangent'
    dobjFor(Push) { action() { location.location.prevMessage(); } }
;

+ Fixture, Consultable 'hylla+n/bokhylla+n*bokhyllor+na hyllor+na' 'hyllor'
    "Hyllorna är fulla med svarta pärmar, uppradade i prydliga rader. "
    isPlural = true

    iobjFor(PutOn) { verify() { illogical('Hyllorna är för fyllda;
        det finns inget utrymme att lägga till något. '); } }
    iobjFor(PutIn) asIobjFor(PutOn)

    dobjFor(Search) asDobjFor(LookIn)
    lookInDesc = "Det finns för många pärmar för att titta igenom alla.
        Många är dock märkta, så du skulle förmodligen kunna
        hitta en specifik en om du vet vad du letar efter. "
;
/* use LibBookTopic for this, as it works the same way */
++ LibBookTopic @efficiencyStudy37Topic
    myBook = efficiencyStudy37

    /* don't allow retries, since we can't put it back */
    isActive = (myBook.location == nil)
;

/* likewise, include an unbook in case we TAKE it before finding it */
++ LibUnbook '37 effektivitetsstudie+n'
    notHereMsg = 'Du ser inte den ligga framme, men den kan vara
        begravd bland de andra pärmarna; du kanske kan
        finna den om du letar efter den. '
;

++ DefaultConsultTopic
    "Du skannar hyllorna, men du hittar inte det du letar efter. "
;
++ efficiencyStudy37: PresentLater, Readable, Consultable
    '37 svart+a effektivitets|studie+n/effektivitets|pärm+en' 'Effektivitetsstudie #37'
    "Den svarta pärmen är märkt <q>Effektivitetsstudie #37</q> på
    ryggen. "

    readDesc = "Det verkar finnas mycket information inuti.
        Du bläddrar till framsidan och skannar över innehålls-
        förteckningen:
        \b\tÖversikt
        \n\tBudget
        \n\tFältutplaceringstest
        \n\tUtmaningar
        \n\tFramtidsplaner "

    isProperName = true

    /* OPEN BINDER is equivalent to READ */
    dobjFor(Open) asDobjFor(Read)
;
+++ es37Overview: Component, Readable 'översikt:en^s+avsnitt+et' 'Översiktsavsnitt'
    "Du bläddrar till Översiktsavsnittet. Som du förväntade dig är inte detta 
    en <q>effektivitetsstudie</q> alls, utan information om något
    som kallas Projekt Galvani-2. Det finns inget specifikt om vad
    projektet är tänkt att göra; istället ligger fokus på hur Galvani-2
    planerar att övervinna problemen från sin föregångare, Projekt Galvani-1.
    <.p>Den primära begränsningen för Galvani-1, enligt rapporten,
    var att det krävde att användarna bar en otymplig huvudbonad. Det finns
    en illustration av en man som bär något som ser ut som en
    tidig dykhjälm, eller en av de gamla skönhetssalongens hårtorkar.
    Galvani-2 är tänkt att lösa detta problem genom att fungera på avstånd
    från användaren (egentligen använder rapporten ordet <q>försöksperson</q> 
    hela tiden), vilket eliminerar behovet av huvudbonaden.
    <.reveal galvani-2-overview> "
;
+++ es37Budget: Component, Readable 'budget:en+avsnitt+et' 'Budgetavsnitt'
    "Du läser över budgetavsnittet med förvåning. Detta enskilda
    projekt har en finansiering som är mer än fem gånger större än hela
    din avdelnings årliga budget. Det konstiga är att du
    inte kan komma på några Mitachron-produkter som verkar vara relaterade 
    till detta projekt; de verkar finansiera detta som en ren forsknings-
    insats. "
;
+++ es37Test: Component, Readable 'fältutplacering:en^s+test:et+sektion+en/testsektion+en/fälttest+et/avsnitt+et'
    'Fältutplaceringstestsektion'
    "Detta avsnitt beskriver ett fälttest av Galvani-2. Utplaceringen
    var vid en nylig rättegång. Du minns det---en
    av de mellanvästliga staterna stämde Mitachron för påstådda
    antitrustöverträdelser. Det verkade uppenbart för alla att
    Mitachron var skyldiga, men de vann på något sätt frikännande. 
    Till och med domaren sa i en intervju senare att hon var 
    förvånad över sitt eget beslut.
    <.p><q>Detta bevisar effektiviteten i
    tillvägagångssättet,</q> säger rapporten. <q>Det krävde exceptionell
    kreativitet att lura en försöksperson att bära Galvani-1-huvudbonaden
    medan dess syfte doldes. Galvani-2-designen kommer
    däremot att vara nästan trivial att placera ut i hemlighet,
    när vi väl överkommer de nuvarande räckviddsbegränsningarna. Även med
    dagens räckviddsgränser är utplacering fortfarande möjlig under
    tillräckligt kontrollerade förhållanden, som detta test demonstrerade:
    tekniker kunde dölja kontroll- och strömförsörjnings-
    utrustning i enkla kartonger som påstods innehålla
    pappersfiler, och dolde sändarna i bärbara
    datorer... Det råder ingen tvekan om att försökspersonen agerade
    under påverkan av Galvani-fältet och dömde fördelaktigt
    som ett resultat.</q> "
;
+++ es37Challenges: Component, Readable 'utmaning:en^s+avsnittet'
    'Utmaningsavsnitt'
    "Detta avsnitt är kort och skissartat. Det listar flera frågor
    som måste vara bekanta för dem som arbetar med projektet, men betyder
    ingenting för dig. Den enda delen med några detaljer beskriver ett
    problem med <q>räckvidd och omfattning</q>: projektet fungerar
    uppenbarligen på kort avstånd och med en enda <q>försöksperson,</q> men
    ett pågående problem med <q>dekoherenseffekter</q> hindrar
    projektet från att nå sina fulla mål. "
;
+++ es37Futures: Component, Readable 'framtidsplaner:+avsnitt+et/framtidsplanering:en^s+avsnitt+et'
    'Framtidsplaneravsnitt'
    "<q>De första planerade produktionsutplaceringarna av Galvani-2-
    enheterna är fortfarande mestadels i regeringsbyggnader. Men vi
    nedprioriterar för närvarande den lagstiftande utrullningen enligt den
    senaste analysen från vårt politiska operationsteam, som förutspår
    kraftigt minskad risk för exponering, och förbättrad operativ
    effektivitet, genom att först fokusera på viktiga byråkratiska
    beslutsfattare... Med enkelheten i utplaceringen av
    Galvani-2-designen tittar vi dock redan bortom
    regeringstillämpningar. Potentialen för att modifiera konsument-
    beteende är enorm. Föreställ dig effekten av fältsändare uppsatta
    i stora köpcentrum, inställda på att sända meddelanden som
    <q>Köp fler Mitachron-produkter nu</q> eller <q>Mitachron-produkter
    får mig att må gott om mig själv</q>... Inom tre år
    bör komponentkostnaderna vara tillräckligt låga för att vi ska kunna 
    inkludera
    miniatyriserade fältsändare i våra företags- och konsumentterminal-
    produkter (MitaMail, MitaMon, etc). Med måttliga e-handels-
    partnerinitiativ skulle vi kunna direkt kontrollera online-
    shoppingbeteende... 
    Även när Galvani-2-regeringens
    utrullning är slutförd kan vi inte förvänta oss full kontroll över
    variablerna, eftersom dagens regeringar i den första världen är komplexa
    system som är sammanlänkade och kan trotsa viljan hos varje enskild
    komponent. Lyckligtvis skapar företagets tysta engagemang i
    elektroniska röstningssystem (FairVote, e-TrustSafe, etc) ett idealt 
    tillfälle att kringgå
    nyckfullheten av lagstiftning och byråkrati genom
    att modifiera ett politiskt beteende på en 
    indiviuella väljarnivå. Detta kommer i slutändan att ge oss våra mest 
    kraftfulla förmågor...</q><.reveal galvani-2-full> "
;

class ES37Topic: ConsultTopic
    topicResponse = (matchObj.actionDobjRead())
;
+++ ES37Topic @es37Overview;
+++ ES37Topic @es37Budget;
+++ ES37Topic @es37Test;
+++ ES37Topic @es37Challenges;
+++ ES37Topic @es37Futures;
+++ DefaultConsultTopic "Du kan inte se den sektionen i pärmen. ";


/* a generic object for the binders */
++ GenericObject, CustomImmovable
    'identisk+a svart+a pärm+en/pärmar+na' 'svarta pärmar'
    "Pärmarna är uppradade i prydliga rader och fyller upp
    hyllorna helt. De är alla identiska, förutom att många är märkta.
    Du kanske kan hitta en specifik pärm om du visste vad du
    letade efter. "
    
    isPlural = true
    cannotTakeMsg = 'Det är alldeles för många pärmar för att ta dem alla.
        Många är dock märkta, så du kanske kan hitta en
        specifik om du vet vad du letar efter. '


    /* remap searches/consults to the shelves */
    dobjFor(LookIn) remapTo(LookIn, location)
    dobjFor(Search) asDobjFor(LookIn)
    dobjFor(Consult) remapTo(Consult, location)
    dobjFor(ConsultAbout) remapTo(ConsultAbout, location, IndirectObject)
;


/* ------------------------------------------------------------------------ */
/*
 *   A class for rooms on the main floor of the sync lab 
 */
class SyncLabRoom: Room
    /* all of these locations can be called "sync lab" */
    vocabWords = 'sync synkrotron synchrotron lab synchrotron|labb+et/synchrotron|laboratorium+et'
    name = 'Synkrotronlaboratoriet'
    /* 
     *   these locations use a special set of room parts, as walls are not
     *   visible in most of these locations (where they are, we'll
     *   implement them explicitly) 
     */
    roomParts = [syncFloor, syncLights, syncCrates]

    /*
     *   For any compass direction not overridden in the individual rooms,
     *   use our special crate blockage. 
     */
    getTravelConnector(dir, actor)
    {
        local conn;
        
        /* get the inherited result */
        conn = inherited(dir, actor);

        /* 
         *   if it's simply 'noTravel', and this is a compass direction,
         *   use our special crate-blockage connector 
         */
        if (conn == noTravel && dir.ofKind(CompassDirection))
            conn = noTravelCrates;

        /* return the result */
        return conn;
    }

    /* 
     *   use a custom 'up' - this is mostly so that we can distinguish
     *   PUSH CRATE UP by the connector 
     */
    up: NoTravelMessage { "Det finns ingen uppenbar väg upp dit. "; }
;

syncFloor: Floor
    '(sync) (synkrotron) (lab) (labb+ets) (laboratorium+ets) grov:t+a betong+golv+et/betong+platta+n'
    'golv'
    "Golvet är en platta av grov betong. "
;

syncCrates: CustomImmovable, RoomPart
    'kartong+en trä|låda+n/kista+n/stapel+n/behållare+n*behållar+na trä|lådor+na kistor+na staplar+na'
    'trälådor'
    "Det finns en blandning av trälådor och kartonger i varierande
    storlekar, mestadels stora. Några är märkta med några slumpmässiga bokstäver
    eller siffror, men ingen av markeringarna betyder något för dig.
    Behållarna är tätt staplade och verkar slumpmässigt utplacerade.
    Många av staplarna når långt över din egen höjd. "

    isPlural = true

    cannotTakeMsg = 'Du skulle behöva en gaffeltruck för att kunna göra någon betydande
        omorganisation. '

    dobjFor(Open)
    {
        verify() { logicalRank(50, 'sync boxes'); }
        action() { "Lådorna och kistorna är staplade för högt för
            att du ska kunna öppna någon av dem. "; }
    }
    dobjFor(LookIn) asDobjFor(Open)
    dobjFor(Search) asDobjFor(Open)
    dobjFor(LookThrough) asDobjFor(Open)
    dobjFor(LookBehind) asDobjFor(Open)
    dobjFor(LookUnder) asDobjFor(Open)

    dobjFor(Climb)
    {
        verify() { logicalRank(50, 'sync boxes'); }
        action() { "Ingen av lådstaplarna ser ut att vara lätta att klättra på. "; }
    }
    dobjFor(ClimbUp) asDobjFor(Climb)

    /* downgrade our likelihood for Examine vs anything else present */
    dobjFor(Examine)
    {
        verify()
        {
            inherited();
            logicalRank(70, 'x decoration');
        }
    }
;

/*
 *   A special travel connector for directions blocked by crates.  We'll
 *   use this by default for any directions not otherwise set.  
 */
noTravelCrates: NoTravelMessage
    "Lådorna är för tätt packade; det finns ingen väg igenom. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Sync Lab 1 - at base of stairs on west side
 */
syncLab1: SyncLabRoom
    'Synkrotronlaboratoriet nära trappan' 'området nära trappan' 'hörn'
    "Detta hörn av Synkrotronlaboratoriets golv är inneslutet av lådor och
    kistor staplade högt runt omkring, med precis tillräckligt utrymme lämnat
    öppet för att bilda en gångväg. Området längs den västra väggen är mestadels
    fritt, vilket ger tillgång till en uppåtledande metalltrappa 
    mot norr. En väg mot nordost är också öppen. "

    vocabWords = 'hörn+et/gångväg+en'

    northeast = syncLab2
    up = sl1Stairs
    north asExit(up)

    /* customize 'west', since it's blocked by something other than crates */
    west: NoTravelMessage { "Du kan inte gå åt det hållet. "; }
    southwest = (west)
    northwest = (west)
;

+ Fixture 'väst+ra v vägg+en*väggar+na' 'västra väggen'
    "Området längs den västra väggen är mestadels fritt, vilket ger
    tillgång till en metalltrappa som leder upp mot norr. "
;

+ EntryPortal ->(location.northeast) 'väg+en' 'väg'
    "Vägen leder nordost genom staplarna av lådor. "
;

+ sl1Stairs: StairwayUp ->scswStairDown
    'metall|trappa+n/metall|trapp+uppgång+en*trappor+na' 'metalltrappa'
    "Trappan leder upp längs den västra väggen och försvinner in i
    skuggan. "
;

/* ------------------------------------------------------------------------ */
/*
 *   The metal crate in its original position has two distinct sides - one
 *   in syncLab2, one in syncLab4.  Use a MultiFaceted to implement this.  
 */
metalCrate: MultiFaceted
    locationList = [syncLab2, syncLab4]
    instanceObject: Heavy, TravelPushable, Underside {
        'särskilt stor+a enorm+a polerad+e aluminium metall+låda+n' 'metallåda'

        desc()
        {
            "Lådan är enorm: den måste vara tre eller fyra meter hög, och
            nästan lika bred. De flesta andra lådor här omkring är
            av trä, men den här är gjord av en polerad metall, troligen
            aluminium. ";
            
            /* add something about our location */
            switch (location)
            {
            case syncLab2:
                if (inOrigPos)
                    "Den är inklämd bland många andra lådor och boxar
                    staplade längs den västra sidan av området. ";
                else
                    "Den står ute i mitten av området. ";
                break;

            case syncLab3:
                "Den verkar vara inklämd mellan de två ändarna av
                gångbron ovanför. ";
                break;

            case syncLab4:
                "Den är inklämd bland många andra lådor och boxar
                staplade här, och blockerar vägen österut. ";
                break;
            }
            
            /* if the casters haven't been seen, mention the space below */
            if (!metalCrateWheels.discovered)
                "<.p>Vid en närmare inspektion verkar lådan vara upphöjd
                något från golvet; det måste finnas något under den. ";
        }

        lookInDesc = "Det finns inget uppenbart sätt att öppna lådan för att
            titta inuti. "
        
        /* are we in our original position? */
        inOrigPos = true
        
        specialDesc()
        {
            switch (location)
            {
            case syncLab2:
                if (inOrigPos)
                    "Vägen västerut blockeras av en särskilt stor
                    metallåda. ";
                else
                    "En enorm metallåda står i mitten av
                    området. ";
                break;

            case syncLab4:
                "En enorm metallåda blockerar vägen österut. ";
                break;

            case syncLab3:
                "En enorm metallåda, tre meter bred, är placerad
                under gapet i gångbron och verkar vara inklämd
                mellan de två ändarna. ";
                break;
            }
        }

        dobjFor(Push)
        {
            verify() { }
            action()
            {
                /* the result depends on where we are */
                switch (location)
                {
                case syncLab2:
                    "Du ger lådan en knuff och upptäcker att den rör sig
                    förvånansvärt lätt med tanke på dess uppenbara vikt. ";

                    if (inOrigPos)
                        "Men du lyckas bara flytta den några centimeter innan
                        något blockerar den. ";
                    else
                        "Det finns förmodligen tillräckligt med öppet utrymme för att du skulle kunna
                        putta den norrut om du ville. ";
                    break;

                case syncLab4:
                    /* handle this as PUSH CRATE EAST */
                    replaceAction(PushEast, self);
                    break;

                case syncLab3:
                    "Lådan verkar vara fastkilad mellan de två
                    ändarna av gångbron. Den rör sig inte. ";
                    break;
                }
            }
        }
        dobjFor(Move) asDobjFor(Push)
        dobjFor(Turn) asDobjFor(Push)
        
        dobjFor(Pull)
        {
            verify() { }
            action() { "Du kan inte få ett tillräckligt bra grepp om
                lådan för att dra den någonstans. "; }
        }

        /* can we be pushed via the given connector? */
        canPushTravelVia(connector, dest)
        {
            /* we can only be moved via some specific connectors */
            return (connector == sl4CrateConnector
                    || (!inOrigPos && connector == syncLab3));
        }

        /* explain why we can't traverse a connector */
        explainNoPushTravelVia(connector, dest)
        {
            /* check for some special conditions */
            if (connector == location.up)
            {
                "Lådan är alldeles för tung för att lyfta. ";
            }
            else if (isIn(syncLab2) && inOrigPos)
            {
                /* 
                 *   we're in our original position in syncLab2 - explain
                 *   in detail what's going on, depending on whether we're
                 *   trying to pull the crate away from the wall of boxes
                 *   or going somewhere else 
                 */
                if (connector is in (syncLab2.east, syncLab2.north))
                    "Du kan inte få ett tillräckligt bra grepp om
                    lådan härifrån för att dra ut den från
                    de andra sakerna som är staplade runt den. ";
                else
                    "Du försöker putta lådan. Den rör sig
                    förvånansvärt lätt med tanke på dess uppenbara vikt,
                    men du kan bara flytta den några centimeter innan
                    något blockerar den. ";
            }
            else if (isIn(syncLab3))
            {
                /* we're wedged in our final position; handle as a PUSH */
                replaceAction(Push, self);
            }
            else
            {
                /* anywhere else, we just don't have enough room */
                "Det verkar inte finnas tillräckligt med utrymme
                för att flytta lådan åt det hållet. ";
            }
        }

        /* receive notification that I'm being pushed somewhere */
        beforeMovePushable(trav, conn, dest)
        {
            /* what happens depends upon where we are now */
            if (isIn(syncLab4))
            {
                "Du lutar dig mot den enorma lådan och ger den en ordentlig,
                stadig knuff. Den börjar sakta rulla, och du
                kliver framåt, trycker ifrån med hälarna, och fortsätter att knuffa.
                Efter några meter märker du att de andra lådorna och kartongerna
                som är staplade bredvid börjar vackla farligt. 
                Du skjuter snabbt aluminiumväggen framåt,
                och hinner precis undan när högar av lådor
                välter in från alla håll för att
                fylla tomrummet. ";

                /* 
                 *   eliminate the existing syncLab2 facet, as we're
                 *   pushing this facet into syncLab2 and consolidating
                 *   into a single facet 
                 */
                miParent.moveInto(syncLab4);
                
                /* we're no longer in the original position */
                miParent.instanceObject.inOrigPos = nil;
            }
            else if (isIn(syncLab2))
            {
                "Du ger lådan en kraftig knuff, och den börjar
                rulla norrut. Du fortsätter att knuffa den och ökar
                farten, till den plötsligt stannar tvärt 
                med en hög metallisk smäll som ekar
                från taket. Du tittar upp och inser
                att lådan har kilats fast mellan
                de två ändarna av catwalken och fyller ut mellanrummet. ";

                /* fill in the gap in the catwalk above */
                metalCrateTop.moveIntoAdd(syncCatwalkGapWest);
                metalCrateTop.moveIntoAdd(syncCatwalkGapEast);
            }
        }

        /* show the arrival message */
        describeMovePushable(traveler, connector)
        {
            /* the description depends on where we are */
            if (isIn(syncLab2))
            {
                "Du låter lådan rulla till stopp i mitten av
                området. ";
            }
            else if (isIn(syncLab3))
            {
                "Metallådan är inklämd mellan ändarna av
                gångbron. ";
            }
        }

        /* we can't add new things underneath */
        allowPutUnder = nil
    }
;

+ metalCrateWheels: Component, Hidden
    '(uppsättning+en) hjul+ställ+et*hjulställen+a hjulen+a' 'hjulställ'
    "Det är för mörkt under lådan för att se några detaljer, men det
    ser ut som om det finns ett hjul i varje hörn, antagligen för att
    göra det möjligt att flytta lådan genom att skjuta på den."

    /* use the special description only in contents, not in the room */
    useSpecialDescInRoom(room) { return nil; }
    specialDesc = "Det är svårt att se i skuggorna under lådan,
        men det ser ut som om lådan har en uppsättning av hjul under sig. "

    /* 
     *   when we're discovered, discover the wheels in all facets; do this
     *   by setting the 'discovered' property in the main template object
     *   instead of the one in 'self', which is always just a facet clone 
     */
    discover() { metalCrateWheels.discovered = true; }
;

/* ------------------------------------------------------------------------ */
/*
 *   Sync Lab 2 - center of sync lab 
 */
syncLab2: SyncLabRoom
    'Öppet område' 'det öppna området'
    "Detta är en stor öppning i röran av lådor och kistor
    som fyller Synkrotronlaboratoriet. Gult ljus sipprar ner från armaturer
    högt ovanför, och belyser svagt de tätt packade staplarna
    av lådor som avgränsar området i öster, väster och söder. En
    smal passage leder mellan staplarna mot sydväst, och vägen
    norrut är mestadels öppen. En annan liten öppning mellan lådorna
    leder mot sydost. "

    southwest = syncLab1
    southeast = syncLab6S
    north = syncLab3

    /* 
     *   use a separate subclass of noTravelCrates for 'east' - we don't
     *   need to customize any of the object's behavior, but the separate
     *   instance allows us to distinguish this kind of travel when
     *   looking at the connector 
     */
    east: noTravelCrates { }
;

+ EntryPortal ->(location.southwest) 'smal+a passage+n' 'smal passage'
    "Passagen leder sydväst mellan staplar av lådor. "
;

+ EntryPortal ->(location.southeast) 'li:ten+lla öppning+en' 'liten öppning'
    "Det finns precis tillräckligt med utrymme mellan lådorna för att gå sydöst. "
;


/* ------------------------------------------------------------------------ */
/*
 *   Sync Lab 3 - north end 
 */
syncLab3: SyncLabRoom
    'Under gångbron' 'området under gångbron' 'öppet område'
    "Detta är ett öppet område bland lådorna. Öppningen sträcker sig
    mot söder; täta staplar av lådor och kistor avgränsar de andra
    riktningarna, även om en passage har lämnats fri mot öster,
    och en smal öppning kan vara passerbar mot sydväst.
    <.p>Ovanför, ungefär en våning upp, syns undersidan av en metall-
    gångbro knappt synlig i det svaga ljuset. Gångbron löper öster
    och väster, men den avbryts direkt ovanför av ett brett gap på
    ungefär tre meter. "

    south = syncLab2
    east = syncLab5
    southwest = syncLab4
;

+ Distant 'metall:en+gångbro+n/undersida+n/gap+et/ände+n*ändar+na' 'metallgångbro'
    "Gångbron löper öster och väster. Den avbryts av ett
    gap på ungefär tre meter<< metalCrate.isIn(syncLab3)
      ? ", som fylls av en enorm metallåda fastkilad
        mellan ändarna av gångbron" : ""
      >>. "
;

+ EntryPortal ->(location.east) 'öst+ra ö passage+n' 'östra passagen'
    "Passagen leder österut, mellan staplar av lådor. "
;

+ EntryPortal ->(location.southwest)
    'smal+a sydväst+ra sv öppning+en' 'smal öppning'
    "Öppningen ser precis tillräckligt stor ut för att man ska 
    kunna ta sig igenom.  Den leder sydväst genom staplarna 
    av lådor."
;

/* ------------------------------------------------------------------------ */
/*
 *   A class for the undersides of stairways.  There are a couple of
 *   locations where we find ourselves under a stairway; these obviously
 *   can't be climbed from this side, but the player might not realize
 *   that right away.  
 */
class SyncStairUnderside: Fixture
    dobjFor(LookUnder) remapTo(Look)

    dobjFor(Climb)
    {
        verify() { logicalRank(70, 'not really stairs'); }
        action() { "Detta är undersidan av trappan. Det finns ingen
            uppenbar väg runt till framsidan av trappan härifrån."; }
    }
    dobjFor(ClimbUp) asDobjFor(Climb)
    dobjFor(ClimbDown) asDobjFor(Climb)
;

/* ------------------------------------------------------------------------ */
/*
 *   Sync Lab 4 - under stairs 
 */
syncLab4: SyncLabRoom
    'Under trappan' 'området under trappan' 'vrå'
    "Detta är en trång, mörk vrå under en trappa, som
    sluttar nedåt tills den når golvet i den södra änden
    av området. Lådor och kistor är instoppade i det sluttande
    utrymmet, vilket lämnar lite plats att röra sig på. En smal öppning
    genom lådorna leder nordöst. "

    vocabWords = 'trång+a mörk+a vrå+n'

    northeast = syncLab3
    south: NoTravelMessage { "Trappan och lådorna som är packade
        under den är i vägen. " }

    roomParts = (inherited - syncLights)

    /* get a travel connector */
    getTravelConnector(dir, actor)
    {
        /* if we're pushing the crate east, use the secret crate connector */
        if (actor != nil)
        {
            local trav = actor.getTraveler(sl4CrateConnector);
        
            if (dir == eastDirection
                && trav.ofKind(PushTraveler)
                && trav.obj_.ofKind(MultiFacetedFacet)
                && trav.obj_.miParent == metalCrate)
            {
                /* use the special connector */
                return sl4CrateConnector;
            }
        }

        /* nothing special; inherit the standard handling */
        return inherited(dir, actor);
    }
;

+ EntryPortal ->(location.northeast)
    'smal+a nordost nordöst+ra no nö passage+n/öppning+en' 'smal öppning'
    "Passagen leder nordöst. Den ser knappt passerbar ut. "
;

+ SyncStairUnderside 'trappa+n/undersida+n*trappor+na' 'trappor'
    "Endast undersidan av trappan är synlig här; den sluttar
    nedåt mot söder. Lådor och kistor är instoppade i det
    tillgängliga utrymmet under trappan. "

    isPlural = true
;

/* 
 *   a secret connector that we can use only to push the giant metal crate
 *   into syncLab2 
 */
sl4CrateConnector: OneWayRoomConnector
    destination = syncLab2
;

/* ------------------------------------------------------------------------ */
/*
 *   Sync Lab 5 - tunnel under office 
 */
syncLab5: SyncLabRoom
    'Tunnel' 'tunneln'
    "Detta är en låg, mörk tunnel, avgränsad av en betongvägg på
    östra sidan och staplar av lådor längs den västra sidan. Ovanför
    löper en metallgångbro norrut och söderut längs väggen. Tunneln
    slutar vid fler lådor i norr, men en öppning genom
    lådorna leder västerut.
    <.p>Tunneln slutar i söder vid undersidan av en
    trappa, som går från gångbron ovanför ner till
    golvet. "

    vocabWords = 'sync synkrotron lab labb+et/laboratorium+et/tunnel+n'

    roomParts = (inherited - syncLights)

    west = syncLab3
    south: NoTravelMessage { "Trappan är i vägen. " }
    east: NoTravelMessage { "Du kan inte gå åt det hållet. " }
    northeast = (east)
    southeast = (east)
;

+ Fixture 'öst+ra ö betong+en vägg+en*väggar+na' 'betongvägg'
    "Väggen är gjord av betong. "
;

+ EntryPortal ->(location.west) 'väst+ra v öppning+en' 'öppning'
    "Öppningen leder genom lådorna västerut. " 
;

+ Distant 'metall+gångbro+n/gångväg+en' 'metallgångbro'
    "Gångbron utgör ett lågt tak över tunneln. Vid den
    södra änden slutar tunneln i undersidan av en trappa
    som leder ner från gångbron till golvet. "
;

+ sl5Stairs: SyncStairUnderside
    'metall:en+trappa+n/undersida+n*metalltrappor+na' 'metalltrappa'
    "Trappan sluttar ner från gångbron till golvet.
    Endast undersidan är synlig härifrån. "
;

/* ------------------------------------------------------------------------ */
/* 
 *   Sync Lab 6.  This location is a bit tricky: it has a large crate that
 *   completely blocks travel through the location, effectively dividing
 *   the room into a north side and a south side.  The crate can be pushed
 *   to the north side of the room or to the south side of the room, but in
 *   no case can the crate be passed, so we can't get from the south side
 *   to the north side or vice versa.
 *   
 *   In real-world terms, it's a single location.  However, because the
 *   crate effectively divides the room in two, we implement it as two
 *   separate rooms.  The tricky part is that the partition between the two
 *   halves - the crate - can be moved.  In practical terms, what this
 *   means is that the doorway leading outside the building can be accessed
 *   form either half of the room, if the crate is pushed to the correct
 *   position; and the stairs at the north end are visible from either half
 *   (but they can only be reached from the north half).  
 */

/*
 *   Sync Lab 6 North.  This half is approached from the stairs up to the
 *   catwalk. 
 */
syncLab6N: SyncLabRoom
    'Synkrotronlaboratoriet vid trappan' 'Synkrotronlaboratoriet, vid trappan' 'området nära trappan'
    "Detta område är så tätt packat med lådor att det knappt finns
    plats att stå. En trappa i norr leder uppåt,
    och lådor är packade runt omkring avsatsen, vilket lämnar
    endast en smal passage mellan röran och den östra
    väggen. <<isCrateAtNorth
      ? "Det ser ut som om passagen fortsätter söderut, men en
        stor trälåda, något högre än du och nästan
        för bred för passagen, blockerar vägen. "
      : "En matt metalldörr är infattad i väggen precis söder
        om trappan. Det ser ut som om passagen fortsätter
        längre söderut, men en stor trälåda blockerar vägen. " >>
    <.p>En skylt med texten <q>Kontor,</q> med en pil som pekar upp
    för trappan, är målad på väggen. "

    up = sl6nStairs
    north asExit(up)

    south: NoTravelMessage { "Den stora lådan är i vägen. "; }

    /* the door is accessible if the crate is to the south */
    east = (isCrateAtNorth ? noEast : sl6Door)

    /* there's a wall (not boxes) in the way to the east */
    noEast: NoTravelMessage { "Du kan inte gå åt det hållet. "; }
    southeast = (noEast)
    northeast = (noEast)

    isCrateAtNorth = nil
;

+ sl6nStairs: StairwayUp ->sceStairs
    '(fot) metall|trappa+n*trappor+na' 'trappa'
    "Metalltrappan leder uppåt mot norr. "
;

+ sl6Door: Lockable, Door ->syncDoor
    'matt+a metall|dörr+en' 'matt metalldörr'
    "Dörren är gjord av en matt metall. "
;

+ Fixture 'betong öst+ra ö vägg+en*väggar+na' 'östra väggen'
    "Väggen är gjord av betong. Skylten <q>Kontor,</q> med
    en pil som pekar uppåt, är målad vid trappan. "
;
++ Decoration 'målad+e "kontor" kontors|skylt+en/pil+en' '<q>Kontor</q>-skylt'
    "Skylten lyder <q>Kontor,</q> med en pil som pekar
    upp för trappan. "
;

class SyncLab6Crate: CustomImmovable
    'stor+a trä:d+låda+n' 'stor trälåda'
    "Lådan har inga uppenbara märkningar. Den är lite
    högre än du och nästan för bred för passagen, så
    det är omöjligt att se runt den. "

    cannotTakeMsg = 'Lådan är för stor. Förmodligen är det enda
        sättet du skulle kunna flytta den på att putta den. '

    dobjFor(Pull)
    {
        verify() { }
        action() { "Du letar efter något att ta tag i, men du
            kan inte hitta något som skulle ge dig ett tillräckligt
            bra grepp. "; }
    }

    /* allow Push - but this will have to be implemented per instance */
    dobjFor(Push) { verify() { } }

    /* set the crate to the north (true) or south (nil) end of the room */
    moveCrateNorth(n)
    {
        /* mark the crate's new position */
        syncLab6N.isCrateAtNorth = n;

        /* 
         *   make the out-of-reach stairs visible in the south room if the
         *   box is to the north 
         */
        sl6sStairs.makePresentIf(n);

        /* 
         *   move the door to the north room if the crate is pushed south,
         *   or the south room if the crate is pushed north 
         */
        sl6Door.moveInto(n ? syncLab6S : syncLab6N);
    }

    dobjFor(Climb)
    {
        verify() { }
        action() { "Lådan är för hög, och det finns inget att fatta tag i . "; }
    }
    dobjFor(ClimbUp) asDobjFor(Climb)
    dobjFor(Board) asDobjFor(Climb)

    dobjFor(Open)
    {
        verify() { }
        action() { "Det finns inget uppenbart sätt att öppna den. "; }
    }

    nothingBehindMsg = 'Lådan är så stor att den nästan skymmer hela din sikt. '
;

+ SyncLab6Crate
    dobjFor(Push)
    {
        action()
        {
            if (syncLab6N.isCrateAtNorth)
            {
                "Du tar spjärn mot trappan och trycker så
                hårt du bara kan. Lådan glider motvilligt söderut,
                och gör ett fruktansvärt skrikande ljud medan den 
                skrapar längs golvet. Efter några meter upptäcker 
                du en dörr i den östra väggen som var dold bakom lådan. 
                Du lyckas precis pressa lådan förbi dörren, men därefter 
                fastnar den på något, och du kan inte flytta den längre. ";

                /* move it south */
                moveCrateNorth(nil);
            }
            else
                "Du trycker lådan så hårt du bara kan, men du
                verkar inte kunna rubba den. ";
        }
    }

    dobjFor(PushTravel)
    {
        verify() { }
        action()
        {
            if (gAction.getDirection() == southDirection)
                replaceAction(Push, self);
            else if (gAction.getDirection() == northDirection)
                replaceAction(Pull, self);
            else
                "Det finns inget uppenbart sätt att trycka lådan någon annan väg
                än söderut härifrån. ";
        }
    }
;


/*
 *   Sync Lab 6 South. 
 */
syncLab6S: SyncLabRoom
    'Smal passage' 'den smala passagen' 'smal passage'
    "Lådor och kistor är tätt staplade här, och lämnar endast
    en smal passage längs betongväggen i öster.
    << syncLab6N.isCrateAtNorth
      ? "En matt metalldörr är infattad i väggen. "
      : "Passagen verkar fortsätta längre norrut, men
        vägen blockeras av en trälåda, något
        högre än du och nästan för bred för passagen. "
    >> Det ser också ut som om det finns tillräckligt med 
    utrymme för att ta sig igenom en öppning mellan 
    lådorna västerut. <<syncLab6N.isCrateAtNorth
      ? "En stor trälåda, något högre än du,
        blockerar vägen norrut; i den svaga belysningen kan
        du precis urskilja en trappa som leder uppåt på
        andra sidan lådan. " : "" >> "

    west = syncLab2
    northwest asExit(west)
    north: NoTravelMessage { "Den stora lådan är i vägen. "; }

    /* the door is accessible if the crate is to the north */
    east = (syncLab6N.isCrateAtNorth ? sl6Door : noEast)

    /* there's a wall (not boxes) in the way to the east */
    noEast: NoTravelMessage { "Du kan inte gå åt det hållet. "; }
    southeast = (noEast)
    northeast = (noEast)
;

+ EntryPortal ->(location.west) 'väst+ra v öppning+en' 'öppning'
    "Öppningen är precis stor nog för att låta dig smita igenom
    västerut. "
;

+ sl6sStairs: PresentLater, Distant 'metall trappa+n*trappor+na' 'trappa'
    "Du kan skymta trappan på andra sidan lådan. "
;

+ SyncLab6Crate
    dobjFor(Push)
    {
        action()
        {
            if (!syncLab6N.isCrateAtNorth)
            {
                "Du lutar dig mot lådan och trycker på den så hårt du 
                bara kan.  Lådan rör sig inte överhuvudtaget under 
                loppet av åtskilliga sekunder, men till slut lyckas 
                du få loss den.
                Den gnisslar fruktansvärt när den skrapar längs golvet.
                Efter att ha knuffat den några meter upptäcker du en dörr 
                i den östra väggen som var gömd bakom lådan. Du
                fortsätter tills dörren är tillgänglig, men sedan
                stöter lådan på något hårt och vägrar att röra sig
                längre. I den svaga belysningen kan du precis
                urskilja en trappa som leder uppåt på andra sidan
                lådan. ";
                
                /* move it north */
                moveCrateNorth(true);
            }
            else
                "Du trycker lådan så hårt du bara kan, men du 
                verkar inte kunna rubba den. ";
        }
    }

    dobjFor(LookBehind)
    {
        action()
        {
            if (syncLab6N.isCrateAtNorth)
                "Du kan se en trappuppgång på andra sidan av lådan. ";
            else
                inherited();
        }
    }

    dobjFor(PushTravel)
    {
        verify() { }
        action()
        {
            if (gAction.getDirection() == northDirection)
                replaceAction(Push, self);
            else if (gAction.getDirection() == southDirection)
                replaceAction(Pull, self);
            else
                "Det finns inget uppenbart sätt att putta lådan 
                åt något annat håll än norrut härifrån. ";
        }
    }
;

+ Fixture 'betong öst+ra ö vägg+en*väggar+na' 'östra väggen'
    "Väggen är gjord av betong. "
;
