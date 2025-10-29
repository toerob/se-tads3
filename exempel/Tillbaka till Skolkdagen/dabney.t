#charset "utf-8"
/*
 *   Copyright 2003, 2013 Michael J. Roberts
 *   
 *   Return to Ditch Day - Dabney Hovse.  Dabney is implemented in
 *   considerable detail, so it rates its own module.  
 */

#include <adv3.h>
#include <sv_se.h>
#include "ditch3.h"

/* ------------------------------------------------------------------------ */
/*
 *   A class for the outdoor rooms within Dabney.
 */
class DabneyOutdoorRoom: CampusOutdoorRoom
    /*
     *   Dabney outdoor rooms are technically campus outdoor rooms, but
     *   they don't connect directly to the main outdoor campus location
     *   graph (as you have to go through Dabney interior rooms to reach
     *   the main campus outdoor graph).  So, we can't use the map in
     *   these locations.  Explain why.
     */
    cannotUseMapHere = "(Kartan visar bara placeringen av byggnader,
        så du måste gå utanför Dabney om du vill ta reda på
        vägen dit.) "
;

/* ------------------------------------------------------------------------ */
/*
 *   breezeway 
 */
dabneyBreezeway: Room 'Pelargång' 'pelargången'
    "Denna breda passage öppnar sig mot en innergård i öster, och
    leder västerut ut ur huset till Orange Walk. En svagt upplyst
    korridor leder in i huset norrut; målat på väggen
    längs korridoren står texten <q>1-9</q>. "

    vocabWords = 'pelar|gång+en'

    west = orangeWalk
    out asExit(west)
    north = alley1S
    in asExit(north)
    east = dabneyCourtyard
    
    roomParts = static (inherited - [defaultEastWall, defaultWestWall])

    atmosphereList = (dbwMovers.isIn(self) ? moversAtmosphereList : nil)
;

+ bwSmoke: PresentLater, Vaporous 'tjock+a svart+a rök+en/moln+et' 'rök'
    "Röken väller ut ur korridoren i tjocka svarta moln. "
    specialDesc = "Tjock svart rök väller ut ur korridoren. "
    isMassNoun = true

    lookInDesc = "Röken är nästan ogenomskinlig; du kan inte se in i
        gränden alls. "

    beforeTravel(traveler, connector)
    {
        /* 
         *   if Erin and Aaron are still on their way, run into them on
         *   our way out 
         */
        erin.interruptLunchFuse();
    }
;
++ SimpleOdor
    desc = "Röken har den skarpa lukten av brinnande elektronik. "
;

+ Decoration 'text+en*siffror+na' 'text'
    "Texten <q>1-9</q> är målad på väggen längs korridoren,
    vilket indikerar att rum 1 till 9 ligger åt det hållet. "
;

+ Enterable ->(location.east) 'innergård+en' 'innergård'
    "Innergården ligger österut. "
;

+ EntryPortal ->(location.north)
    'svagt upplyst+a svag+a norr+a n 1 gränd+en korridor+en/ett' 'korridor'
    "Korridoren leder norrut. "
;

+ Enterable ->(location.west) 'orange walk/gångväg+en' 'Orange Walk'
    "Orange Walk ligger utanför västerut. "
;

+ Enterable ->(location.east) 'innergård+en' 'innergård'
    "Innergården ligger österut. "
;

+ dbwMovers: MitaMovers
    "Flyttarbetare fortsätter att komma in från Orange Walk, bärande på sina
    lådor in i korridoren. Andra kommer ut från gränden tomhänta
    och går ut. "

    "Mitachron-flyttarbetare kommer stadigt in från Orange Walk och
    bär in sina laster i korridoren. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Stuff inside the movers.  We create an intermediate MultiInstance
 *   dummy object that we put inside all of the different mover objects,
 *   and then put the mover components inside the dummy object.  This will
 *   automatically set up the individual copies of mover components for
 *   each mover, while still letting us use separate mover objects - which
 *   we want to do because we want to describe each one a little
 *   differently.  
 */

MultiInstance
    initialLocationClass = MitaMovers
    instanceObject: Decoration {
        name = 'flyttarbetare'
        isPlural = true
    }
;

+ Immovable 'vit+a *uniformer+na/overaller+na' 'uniformer'
    "Flyttarna bär på vita overaller med stora Mitachron-logotyper
    på ryggen. "
    isPlural = true
;

++ Component 'mitachron+s logotyp+en*logotyper+na' 'Mitachron-logotyp'
    "Det är det vanliga Mitachrongula <q>M</q>:et mot en kontur
    av en glob. "
;

+ Immovable 'kartong+en trä+et trä|låda+n*trä|lådor+na' 'lådor'
    "Flyttarna bär kartonger och trälådor
    i varierande storlekar, vissa så pass stora eller uppenbart tunga
    för att kräva två eller tre personer att bära. "
    isPlural = true

    lookInDesc = "Det finns ingen möjlighet att titta igenom lådorna
        medan Mitachron-folket är upptagna med dem. "
;

/* 
 *   A class for the movers.  The movers all show up later in the game, so
 *   make the PresentLater objects. 
 */
class MitaMovers: PresentLater, Person
    'mitachron+s flyttkarl+en/flyttarbetare+n/man+nen/kvinna+n*flyttkarlar-na män+nen kvinnor+na' 'flyttarbetare'
    isPlural = true
    isHim = true
    isHer = true

    /* 
     *   use the class as the PresentLater key - this lets us move all of
     *   the movers into the game at once simply by referring to this key
     *   in PresentLater.makePresentByKey() 
     */
    plKey = MitaMovers
;

/* atmosphere messages for the movers */
moversAtmosphereList: ShuffledEventList
    ['En av flyttarbetarna stöter in i dig med en låda. Du börjar
    be om ursäkt, men han har redan trängt sig förbi. ',
     'Två flyttarbetare som bär en särskilt stor låda arbetar sig
     förbi dig. ',
     'Flera tomhänta flyttarbetare strömmar förbi. ',
     'Fyra flyttarbetare som bär på identiska lådor manövrerar förbi dig. ',
     'Ett par flyttarbetare som bär på ett två och en halvt meters långt kartongrör går förbi. ',
     'Fyra flyttarbetare arbetar sig förbi bärandes på en till synes tung
     låda upphängd på ett par stänger. ',
     'En trafikstockning bildas tillfälligt när ett halvdussin flyttarbetare försöker
     komma igenom samtidigt, men knuten löser fort upp sig igen. ']
    eventPercent = 66
;


/* ------------------------------------------------------------------------ */
/*
 *   Doors to rooms that we're not welcome to enter.  We'll simply say so
 *   if we try to enter, or even open the door. 
 */
class ForbiddenDoor: Door
    dobjFor(Open)
    {
        check()
        {
            cannotEnter;
            exit;
        }
    }
    dobjFor(TravelVia)
    {
        verify()
        {
            /* 
             *   slightly downgrade this, as wanting to enter a private
             *   room is unlikely if there's a better enterable nearby 
             */
            logicalRank(50, 'private room');
        }
        check()
        {
            cannotEnter;
            exit;
        }
    }

    /* explain why we can't enter */
    cannotEnter = "Det skulle vara fräckt att gå in utan tillåtelse. "

    /* 
     *   since we don't want to open this door, don't bother making
     *   opening it a precondition to travel 
     */
    getDoorOpenPreCond() { return nil; }
;

/*
 *   A default door to a student room in an alley.  In the usual case,
 *   these are just forbidden doors, since they're private rooms we don't
 *   want to enter uninvited.  
 */
class AlleyDoor: ForbiddenDoor 'trä rums|dörr+en/trä|dörr+en*trä|dörrar+na'
    cannotEnter = "Det där är någons privata rum - du vill inte
        gå in dit oinbjuden. "

    dobjFor(Knock) { action() { "Du knackar, men får inget svar.
        Personen som bor här är förmodligen ute och gör något
        Skolkdagen-relaterat. "; } }
;

/*
 *   A door for a room with a stack 
 */
class StackDoor: AlleyDoor
    cannotEnter()
    {
        if (isSolved)
            "Även om du lyckades lösa stapeln, så skulle det inte kännas
            rätt att sabba nöjet för de övriga studenterna. Dessutom, är
            <q>mutorna</q> som de flesta seniorer lämnar kvar som belöning 
            för klara deras staplar, bara en massa skräpmat. ";
        else
            "Du kan inte gå in förrän stapeln är löst. ";
    }
    
    dobjFor(Knock) { action() { "Du knackar, men det kommer inget svar.
        Ägaren är förmodligen borta på grund av Skolkdagen. "; } }

    /* flag: we've solved the stack */
    isSolved = nil
;

/* ------------------------------------------------------------------------ */
/*
 *   Alley walls.  Define a mix-in class that describes the alley walls;
 *   we'll mix this with the default directional walls to create the
 *   corresponding directional alley walls.  
 */
class AlleyWall: object
    desc = "Väggarna är dekorerade med graffiti. "
;

/* define the individual walls in the different directions */
alleyNorthWall: AlleyWall, defaultNorthWall;
alleySouthWall: AlleyWall, defaultSouthWall;
alleyEastWall: AlleyWall, defaultEastWall;
alleyWestWall: AlleyWall, defaultWestWall;

/*
 *   Base alley room subclass.  These rooms have the generic floor and
 *   ceiling, but need one or more alley walls to be added to their room
 *   parts.  
 */
class AlleyRoom: Room
    roomParts = [defaultFloor, defaultCeiling]
    vocabWords = 'gränd+en/korridor+en'
    name = 'korridor'
;

/* base class for graffiti on the alley walls */
class Graffiti: Decoration 'graffiti+t/graffito+t' 'graffiti'
    dobjFor(Read) asDobjFor(Examine)
;
Graffiti template "desc";

/* ------------------------------------------------------------------------ */
/*
 *   alley one south 
 */
alley1S: AlleyRoom 'Gränd Ett Syd' 'södra änden av Gränd Ett'
    "Några av de andra husen ger fantasifulla namn till sina gränder, men
    av någon anledning brydde sig Darbarna aldrig om det; de hänvisar bara till sina
    gränder med nummer, och denna är Gränd Ett. Rum 1 är österut och
    rum 2 västerut; korridoren fortsätter norrut, och en dörröppning leder
    söderut.
    <.p>Väggarna är kraftigt prydda med graffiti, precis som de var när
    du var student här. "

    vocabWords = '1+a gränd+en ett första'

    south = dabneyBreezeway
    out asExit(south)
    north = alley1N
    east = room1Door
    west = room2Door

    roomParts = static (inherited + [alleyWestWall, alleyEastWall])

    atmosphereList = (a1sMovers.isIn(self) ? moversAtmosphereList : nil)

    /* can't enter alley when the smoke is present */
    canTravelerPass(traveler) { return bwSmoke.location == nil; }
    explainTravelBarrier(traveler)
    {
        "Du försöker ta dig in i gränden, men röken är för tjock. ";
    }
;

+ room1Door: AlleyDoor '1 -' 'dörr till rum 1'
    "Det är en sliten trädörr märkt med <q>1.</q> "
;

+ room2Door: AlleyDoor '2 -' 'dörr till rum 2'
    "Det är en trädörr märkt med <q>2.</q> "
;

+ EntryPortal ->(location.south) 'syd s+ödra dörr|öppning+en' 'dörröppning'
    "Dörröppningen leder ut ur korridoren söderut. "
;

++ Decoration 'huvudsaklig+a vänst:er+ra hög:er+ra fotokopia+n/råtta+n/bildtext+en*bilder+na foton+a råttor+na'
    'fotokopia'
    "Det är en fotokopia av en sida från en lärobok. Den har två bilder
    av råttor, sida vid sida. I den vänstra bilden, med bildtexten <q>Råtta
    utom kontroll,</q> ser råttan hemsk ut: den är utmärglad, och
    stora klumpar av dess päls saknas. I den högra bilden, märkt
    <q>Råtta under kontroll,</q> så ser råttan glad och frisk ut. 
    Den huvudsakliga bildtexten lyder:
    <.p><b>Stress och kontroll.</b> I fotot till vänster
    ges råttan små, ofarliga elektriska stötar slumpmässigt. Råttan
    har inget sätt att kontrollera stötarna, och på bara några dagar
    blir den överväldigad av stress. I fotot till höger ges
    råttan samma elektriska stötar, men kan stoppa varje stöt
    genom att trycka på en paddel i sin bur. Även om båda råttorna
    utsätts för liknande typer och mängder av stress, förblir råttan 
    med kontroll över stresskällan frisk. "

    specialDesc = "En fotokopia är fäst på dörren. "
    useSpecialDescInRoom(room) { return nil; }
;

+ Graffiti
    'ny+a nyare gam:mal+la äldre abstrakt+a fantasy psykedeliska klottrade 
    konst+en/konstverk+et/del+en/väggmålning+en/klott:er+ret/*delar+na väggmålningar+na'
    'graffiti'
    "När Institutet renoverade South Houses för några
    år sedan övertalade studenterna bostadskontoret att bevara
    några av de bättre bitarna av Dabney-graffiti, så det som finns på väggarna
    nu är en blandning av gammalt och nytt. Konstverken här är mestadels
    abstrakt psykedeliska och fantasy-väggmålningar, några ganska bra;
    det finns också en hel del mindre konstnärligt klotter. "
;

+ a1sMovers: MitaMovers
    "Flyttarbetare fortsätter att strömma in söderifrån, bärande sina
    laster till den norra änden av gränden, andra återvänder tomhänta
    och går tillbaka ut. "

    "En stadig ström av Mitachron-flyttarbetare tränger sig förbi
    dig med skrymmande laster av lådor och packlårar, på väg till den norra
    änden av gränden. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Alley 2 - north end
 */
alley2N: AlleyRoom 'Gränd Två' 'Gränd Två'
    "Gränd Två är bara en kort sträcka av korridor högst upp i ett brett
    trapphus. Dörren till rum 6 är österut. Trapporna
    norrut leder ner, och korridoren fortsätter söderut. "

    vocabWords = '2 två andra gränd+en'

    roomParts = static (inherited + [alleyWestWall, alleyEastWall])

    down = alley2Stairs
    north asExit(down)
    east = room6door
    south = alley2S
;

+ alley2Stairs: StairwayDown ->alley1Stairs
    'bred+a trappa+n/trappuppgång+en/trappor+na/trapphus+et' 'trappa'
    "Trapporna leder nedåt. "
;

+ room6door: AlleyDoor '6 -' 'dörr till rum 6'
    "Det är en trädörr märkt med <q>6.</q> "
;

+ Graffiti
    'stor+a fantasy landskap:et^s+vägg+målning+en/torn+et/spira/berg+et*torn+en spiror+na berg+en'
    'graffiti'
    "En stor fantasy-landskapsmålning täcker en vägg: torn, spiror,
    berg i fjärran. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Alley 2 - south end 
 */
alley2S: AlleyRoom 'Gränd Två Syd' 'södra änden av Gränd Två'
    "Gränd Två slutar här med två till rumsdörrar, rum 7 västerut
    och rum 9 österut. Gränden fortsätter norrut. "

    vocabWords = '2 gränd två'

    north = alley2N
    west = room7door
    east = room9door

    roomParts = static (inherited
                        + [alleyWestWall, alleyEastWall, alleySouthWall])
;

+ room7door: AlleyDoor '7 -' 'dörr till rum 7'
    "Det är en trädörr märkt med <q>7.</q> "
;

+ room9door: AlleyDoor '9 -' 'dörr till rum 9'
    "Det är en trädörr märkt med <q>9.</q> "
;

+ Graffiti 'omfattande sammanflätad+e ranka+n/mönster/mönstret*mönstren+a rankor+na' 'graffiti'
    "Denna ände av korridoren är dekorerad med ett omfattande mönster av
    sammanflätade rankor. "
;


/* ------------------------------------------------------------------------ */
/*
 *   Dabney courtyard 
 */
dabneyCourtyard: DabneyOutdoorRoom 'Innergård' 'innergården'
    "Denna stora inre gård domineras av vad som ser ut att vara
    en papier-m&acirc;ch&eacute; skalmodell av ett berg: en två våningar
    hög byggnad av klippor och stenblock, som reser sig i mitten av
    innergården till en topp högre än de omgivande innergårdsväggarna.
    Slumpmässigt staplade runt basen finns metallbehållare märkta med
    strålningsvarningar, många uppspruckna och läckande grön sörja.
    <<initialExplanation>>
    <.p>
    Själva innergården följer den medelhavsstil som präglar
    sydhusen: rött tegelgolv, stuckoväggar, spröjsade fönster,
    pelare som stöder en arkadliknande överhängande del i öster, terrakottaplattor
    på de svagt sluttande taken. Under det överhängande taket leder dörrar
    österut in i sällskapsrummet. Ingången till gränd 3 är i
    sydväst, och gränd 5 är i sydost. En liten alkov
    ligger i söder. I väster finns en passage som leder utomhus,
    och en lång betongtrappa går uppåt. "

    /* provide a background explanation on the first viewing */
    initialExplanation()
    {
        if (!seen)
            "<.p>Allt detta måste vara en dekoration för en nylig
            flerhus-fest. Det är ganska anmärkningsvärt; på din tid
            skulle Darbarna vanligtvis inte bry sig om att välja ett tema
            för dessa fester, än mindre genomföra ett, och definitivt inte så
            genomarbetat. ";
    }

    vocabWords = '(dabney) innergård+en'
    
    up = dcStairsUp
    west = dabneyBreezeway
    east = dcDoors
    southwest = alley3main
    southeast = alley5main
    south = dabneyCourtyardAlcove

    roomParts = static (inherited - defaultGround)
;

+ EntryPortal ->(location.west) 'passage+n' 'passage'
    "Passagen leder västerut. "
;
+ dcDoors: Door ->dlDoors
    'sällskapsrum+met dörr+en/sällskapsrum+met*dörrar+na' 'dörrar till sällskapsrummet'
    "Dörrar leder in i sällskapsrummet österut. "
    isPlural = true
    initiallyOpen = true
;
+ EntryPortal ->(location.southwest)
    'sydväst+ra sv gränd+en 3 gränd-3-ingång+en ingång+en/dörröppning+en/skylt+en'
    'gränd 3 ingång'
    "Ingången till gränd 3 är i sydväst. Dörröppningen är
    märkt med skylten <q>10-16, 18-22.</q> "
    definiteFrom = 'gränd-3-ingången'
;
+ EntryPortal ->(location.southeast)
    'sydost sydöst+ra so gränd+en 5 gränd-5-ingång+en ingång+en/dörröppning+en/skylt+en'
    'gränd 5 ingång'
    "Ingången till gränd 5 är i sydost. Dörröppningen är
    märkt med skylten <q>23-31, 33-37.</q> "
    definiteFrom = 'gränd-5-ingången'
;
+ Enterable ->(location.south) 'liten lilla alkov+en' 'alkov'
    "En liten alkov finns i söder. "
;
+ dcStairsUp: StairwayUp 'lång+a upp+åtgående upp+ledande betong^s+trappa+n*trappor' 'trappa upp'
    "Trappan leder uppåt. Det ser ut som två normala våningar i trapphöjd.  "
;

+ Floor '(innergård+en) mörk+a röd+a teglet tegel+golv+et*tegel+stenar+na' 'rött tegelgolv'
    "Innergårdens golv är belagt med mörka röda tegelstenar. "
;
+ Fixture '(innergård) öst+ra väst+ra nord+liga norr+a syd ö v n s stucko vägg+en*väggar+na'
    'innergårdsväggar'
    "Väggarna är kantade med fönster som vetter ut mot innergården från studentrummen. "
    isPlural = true
;
++ Distant 'spröjsat spröjsad+e fönst:er+ret*fönstren' 'fönster'
    "Väggarna är kantade med fönster som vetter mot innergården. "
    isPlural = true
    tooDistantMsg = 'Fönstren är alla för högt upp för att nå. '
;
+ Fixture 'täckt+a arkad+en/pelare+n/pelare+n/överhäng+et/valv+et/område+t*valvbågar+na' 'arkad'
    "Överhänget ger ett täckt område utanför sällskapsrummet. "

    dobjFor(StandOn)
    {
        verify() { }
        action() { "Om du vill gå in i sällskapsrummet, gå bara österut. "; }
    }
    dobjFor(LookUnder) { action() { "Dörrar leder in i sällskapsrummet
        österut. "; } }
;
+ Distant 'rundad+e svag+a svagt sluttande tak+et/platta+n*plattor+na/terrakotta:n+plattor+na' 'tak'
    "Taket är täckt med rundade terrakottaplattor, som ser
    ut som blomkrukor som har delats på mitten längs höjden. "
;

+ Fixture 'papier-mache paper-mache papier-m\u00E2ch\u00E9 skalmodell+en modell+en
    berg+et/stenblock+et/klippa+n/byggnad+en/topp+en*klippor+na' 'berg'
    "Det är en effektfull modell: klipporna nära botten reser sig nästan
    vertikalt, vilket ökar känslan av att toppen tornar upp sig
    på en stor höjd, även om den bara reser sig ungefär lika högt som
    den omgivande byggnaden. Stenblock är utspridda runt
    basen, blandade med stora metallbehållare märkta med strålningsvarningar. "

    dobjFor(Climb)
    {
        verify() { }
        action() { "Det är för brant, och även om det inte vore det, skulle det förmodligen
            inte bära din vikt. "; }
    }
    dobjFor(StandOn) asDobjFor(Climb)
    dobjFor(ClimbUp) asDobjFor(Climb)
    dobjFor(Board) asDobjFor(Climb)
    lookInDesc = "Du kan inte se in i berget, och du hittar
        inget gömt bland stenblocken. "
;
+ CustomImmovable 'stor+a metall strålning+s varning^s+symbol+en
    (symboler) metall+behållare+n/varningar/fat+et*cylindrar+na varningssymboler+na' 
    'behållare'
    "Rostiga metallcylindrar, tre fot långa, är slumpmässigt placerade bland
    stenblocken runt bergets bas. De är märkta med
    den treflikiga strålningsvarningssymbolen. Många är uppspruckna och
    läcker en trögflytande grön sörja. "
    isPlural = true

    lookInDesc = "Du ser inget förutom den sipprande gröna sörjan. "
    cannotTakeMsg = 'Du vill inte störa den noggranna designen. '
;
+ CustomImmovable 'trögflytande sipprande geléaktig klargrön sörja' 'grön sörja'
    "Det är någon slags geléaktig sörja, klargrön till färgen. "

    cannotTakeMsg = 'Det finns inget bra sätt att flytta den, och dessutom
        skulle du inte vilja störa den noggranna designen. '

    dobjFor(Eat)
    {
        preCond = []
        verify() { }
        action() { "Vid närmare eftertanke bör du förmodligen låta bli.
            Var som helst annars skulle du kunna anta att det är trevlig, ofarlig
            limegele, men här är det svårt att vara säker på att det inte är äkta 
            radioaktivt avfall. "; }
    }
    dobjFor(Taste) asDobjFor(Eat)
;
    

/* ------------------------------------------------------------------------ */
/*
 *   Dabney lounge 
 */
dabneyLounge: Room 'Sällskapsrum' 'sällskapsrummet'
    "Detta stora gemensamma rum är i princip Hovsens vardagsrum.
    Det måste ha varit nödvändigt att rensa innergården för att göra plats
    för berget, eftersom högarna av skräp som normalt finns där verkar
    vara här inne. Flera soffor är hopskjutna nära eldstaden
    för att göra plats för högarna av saker som fyller rummets södra sida.
    Innergården är utanför dörrarna västerut, och en bred
    passage leder norrut in i matsalen. "

    vocabWords = '(dabney) (hus+et) (hovse) sällskapsrum+met'

    west = dlDoors
    north = dlPassage
    out asExit(west)
;

+ dlDoors: Door ->dcDoors 'till innergård+en dörr+en/dörrar+na'
    'dörrar till innergården'
    "Dörrarna leder ut till innergården västerut. "
;

+ dlPassage: ThroughPassage ->ddPassage
    'bred+a välvd+a matsal+en nord+liga n passage+n' 'bred passage'
    "Det är en välvd passage som leder norrut in i matsalen. "
;

+ Chair, Heavy 'stor+a stadig+a lädret läder:et+soffa+n*soffor+na' 'soffa'
    "Sofforna matchar inte varandra, men de är alla stora, stadiga,
    klädda i välanvänt läder. "
;

+ Fixture, Booth 'överdimensionerad+e gaseldad+e sten+eld+stad+en' 'eldstad'
    "Den överdimensionerade steneldstaden är på rummets östra sida.
    Den konverterades för länge sedan till att bränna gas istället för ved, så den
    innehåller bara simulerade vedträn. Den är för närvarande avstängd. "

    up: NoTravelMessage { "Skorstenen är inte stor nog att klättra in i. "; }

    dobjFor(TurnOn)
    {
        verify() { }
        action() { "Det är en tillräckligt varm dag; ingen anledning att göra det till en ugn
            här inne. "; }
    }
;
++ EntryPortal ->(location.up) 'skorsten+en/sot+en/sot+et' 'skorsten'
    "Det är bara ett mörkt schakt en fot i diameter. "

    dobjFor(Climb) asDobjFor(Enter)
    dobjFor(ClimbUp) asDobjFor(Enter)
    dobjFor(Board) asDobjFor(Enter)

    lookInDesc = "Det finns inget annat än sot där uppe. "
;

++ Heavy 'svart+a simulerad+e betong ved:en+trä+n' 'simulerade vedträn'
    "Vedträna är gjorda av betong eller något liknande, formade
    för att likna de riktiga. De är svarta efter lång exponering för
    en gaslåga. "

    isPlural = true
;

+ CustomImmovable
    'skrot+et gammal säng+ram+en bil+en auto
    skräp+et/hög+en/ram+en/del+en/skrot:et+trä+t*högar+na delar+na filtar+na saker+na säng+ramar+na'
    'skräp'
    "Gamla filtar, sängramar, bildelar, skrotträ; det mesta
    är inte ens omedelbart identifierbart. "
    isMassNoun = true

    cannotTakeMsg = 'Det finns för mycket skräp att flytta runt. '

    lookInDesc = "Du rotar runt och letar efter en dold pärla, men du
        hittar inget intressant. Du kan tänka dig att det redan har
        genomsökts ordentligt av personer med en mer generös
        skräp/skatt-tröskel än din egen. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Dining room 
 */
dabneyDining: Room 'Matsal' 'matsalen'
    "Detta är Hovsens matsal. Flera långa träbord är
    arrangerade i ett par rader, och stolar är uppradade på båda
    sidor av varje bord. En bred passage leder söderut, till sällskapsrummet,
    och ett par svängdörrar österut leder till köket. "

    vocabWords = '(dabney) (hovse) (hus+et) matsal+en'

    south = ddPassage
    out asExit(south)
    east = ddKitchenDoors

    /* begin lunch */
    startLunch()
    {
        /* activate the students, food, etc */
        PresentLater.makePresentByKey('lunch');

        /* open the doors */
        ddKitchenDoors.makeOpen(true);

        /* note that it's lunchtime */
        isLunchtime = true;

        /* set a daemon to nag about going to lunch */
        new Daemon(self, &nagAboutLunch, 1);
    }

    /* end lunch */
    endLunch()
    {
        /* deactivate the students, food, etc */
        PresentLater.makePresentByKeyIf('lunch', nil);
        myLunch.moveInto(nil);

        /* close the doors */
        ddKitchenDoors.makeOpen(nil);

        /* it's lunchtime no more */
        isLunchtime = nil;

        /* make sure the lunch-winding-down daemon is removed */
        eventManager.removeMatchingEvents(self, &lunchMonitor);
    }

    /* flag: it's lunchtime */
    isLunchtime = nil

    /* daemon to nag about going to lunch */
    nagAboutLunch()
    {
        /* nag with 20% probability */
        if (rand(100) < 20)
            nagMessages.doScript();
    }

    /* lunch nag messages */
    nagMessages: ShuffledEventList { [
        'Du börjar bli ganska hungrig. Du borde verkligen gå och äta
        lite lunch. ',
        'Det är inte som om du kommer att dö av näringsbrist
        eller något, men du känner dig lite hungrig. ',
        'Du borde gå och äta lite lunch medan matsalen fortfarande
        är öppen. ',
        'Du känner dig hungrig. Du borde ta Erins erbjudande att ansluta 
        dig till henne och Aaron för lunch. ' ] }


    /*
     *   Lunch monitor daemon.  This watches what's going on at lunch, to
     *   evaluate whether we should start nudging the player to finish up
     *   and get back to the stack already.  The main point here is to let
     *   the player know that there's not much more they're going to find
     *   out by talking more to Aaron and Erin during lunch, so they don't
     *   think they have to just sit around all day waiting for something
     *   to happen here.  
     */
    lunchMonitor()
    {
        /* check to see if they've seen enough of the lunch topics */
        if (gRevealed('lunch-satisfied-1'))
        {
            /* if we haven't already, fire the end-of-lunch plot event */
            if (endOfLunchNoted++ == 0)
                lunchWindingPlotEvent.eventReached();
            
            /* mention that lunch is done with 33% probability */
            if (rand(100) < 33)
                lunchDoneMessages.doScript();
        }
    }

    /* count of times we've noted the end-of-lunch status */
    endOfLunchNoted = 0


    /* messages to hint to player that they should finish lunch */
    lunchDoneMessages: ShuffledEventList { [
        'Lunchfolket verkar tunnas ut lite. Folk
        är förmodligen ivriga att komma tillbaka till sina studier. ',
        'Lunchen verkar vara på väg att avslutas. ',
        'Folk verkar vara på väg att avsluta lunchen. '] }

    /* if we arrive during lunch, do some extra work */
    travelerArriving(traveler, origin, connector, backConnector)
    {
        /* do the normal work */
        inherited(traveler, origin, connector, backConnector);

        /* if it's lunchtime, begin lunch */
        if (isLunchtime)
        {
            /* remove the nag-about-lunch daemon */
            eventManager.removeMatchingEvents(self, &nagAboutLunch);

            /* start the lunch monitor daemon */
            new Daemon(self, &lunchMonitor, 1);
            
            /* move aaron and erin here */
            aaron.moveIntoForTravel(self);
            erin.moveIntoForTravel(self);

            /* set them to their lunch states */
            aaron.setCurState(aaronLunch);
            erin.setCurState(erinLunch);

            /* describe the start of lunch */
            "<.p>Du får syn på Aaron och Erin vid ett av borden. Erin
            tar dig med in i köket och visar dig var du kan köpa ett
            måltidspass, och ger dig en snabb rundtur av lunchalternativen.
            Upplägget har inte förändrats mycket sedan du var student,
            och inte heller, uppenbarligen, matens kvalitet. Du lastar
            en bricka, går tillbaka till matsalen och sätter dig ner med
            Aaron och Erin. ";
            
            /* sit down */
            me.moveInto(ddChair);
            me.posture = sitting;

            /* fetch the PC's lunch */
            myLunch.makePresent();

            /* note the turn number when we arrived at lunch */
            lunchStartTime = Schedulable.gameClockTime;
        }
    }

    /* the turn number when we arrived at lunch */
    lunchStartTime = nil

    /* if we depart during lunch, finish up lunch */
    leavingRoom(traveler)
    {
        /* if it's lunchtime, end lunch */
        if (isLunchtime)
        {
            /* 
             *   Describe the end of lunch.  If we've only been here a
             *   couple of turns, mention that a lot of time has passed. 
             */
            if (Schedulable.gameClockTime - lunchStartTime < 7)
                "Du tillbringar ungefär en timme i lugn och ro med att 
                äta lunch och prata med Aaron och Erin. Så småningom 
                börjar matsalen att tömmas, och Aaron nämner att han 
                och Erin behöver gå tillbaka till sin stapel. Du äter 
                upp de ätbara delarna av din lunch och lämnar din 
                bricka.";
            else
                "Lunchen har hållit på att avslutas ett tag nu, och
                matsalen har börjat tömmas. Aaron nämner
                att han och Erin behöver återvända till sin stapel, så
                du äter upp de ätbara delarna av din lunch och lämnar
                in din bricka. ";

            /* mention that lunch is over now, not just for us */
            "Erin och Aaron går mot Gränd Sju; du önskar dem lycka till
            på vägen ut. ";

            /* put out the fire */
            alley1N.endBlowout();

            /* send aaron and erin back to alley 7 */
            aaron.moveIntoForTravel(upper7N);
            erin.moveIntoForTravel(upper7N);
            aaron.setCurState(aaronUpper7);
            erin.setCurState(erinUpper7);

            /* we mentioned where they were going */
            aaron.knownFollowDest = upper7N;
            erin.knownFollowDest = upper7N;

            /* fire the end-of-lunch plot clock event */
            lunchDonePlotEvent.eventReached();

            /* bus the tables (etc) */
            endLunch();

            /* the Campus Network Office is now open */
            networkOffice.endLunch();
        }
    }

    /* a game-clock event for lunch winding down */
    lunchWindingPlotEvent: ClockEvent { eventTime = [2, 13, 8] }

    /* a game-clock event for after we've finished lunch and departed */
    lunchDonePlotEvent: ClockEvent { eventTime = [2, 13, 19] }
;

+ ddPassage: ThroughPassage
    'bred+a välvd+a sällskapsrum+met syd+liga s passage+n' 'bred passage'
    "Den välvda passagen leder söderut, ut till sällskapsrummet. "
;

+ ddKitchenDoors: Door 'svängande svängd+a sväng+dörr+en/svängdörrar+na' 'svängdörrar'
    "Dörrarna leder in i köket, österut. "
    isPlural = true

    /* the doors are locked outside of meal times */
    dobjFor(Open)
    {
        check()
        {
            /* 
             *   if we get this far, they're closed, which means they're
             *   locked 
             */
            "Dörrarna verkar vara låsta. Köket måste vara
            stängt just nu, eftersom det inte är måltidstid. ";
            exit;
        }
    }

    dobjFor(Unlock)
    {
        verify()
        {
            if (isOpen)
                illogicalAlready('Dörrarna är redan upplåsta och öppna. ');
            else
                illogical('Dörrarna har ingen uppenbar låsmekanism,
                    åtminstone inte på den här sidan. ');
        }
    }
    dobjFor(Lock)
    {
        preCond = [touchObj, objClosed]
        verify()
        {
            if (!isOpen)
                illogical('Dörrarna har ingen uppenbar låsmekanism,
                    åtminstone inte på den här sidan. ');
        }
    }

    /* the doors can only be closed by staff */
    dobjFor(Close)
    {
        check()
        {
            /* 
             *   if we get this far, they're open, which means they're
             *   locked in the open position 
             */
            "Dörrarna verkar vara låsta i öppet läge. ";
            exit;
        }
    }

    /* 
     *   going through the doors at lunchtime doesn't really go anywhere,
     *   but it seems to 
     */
    dobjFor(TravelVia)
    {
        action()
        {
            /* 
             *   if we make it this far, the doors are open; we don't
             *   actually go anywhere, but pretend we do 
             */
            moreFood.doScript();
        }
    }
    moreFood: StopEventList { [
        'Du går tillbaka in i köket i hopp om att hitta något mer
        aptitligt att äta, men en grundlig genomsökning av utbudet ger
        inget bättre. Besviken återvänder du till matsalen. ',
        'Du går tillbaka till köket och tar en sista titt, men du
        hittar inget mer aptitligt. Du återvänder till matsalen. ',
        'Det finns verkligen ingen anledning att besöka köket igen. ' ] }
;

+ Fixture, Surface
    'mörk+a lång+a trä matbord+et/bord+et/rad+en*rader+na' 'bord'
    "Borden är gjorda av ett mörkt, lackerat trä. De har använts flitigt. "

    disambigName = 'långt träbord'
;

/* our lunch - present only during the lunch hour */
++ myLunch: PresentLater, Thing
    'fet+a mat:en+bricka+n/puck+en/lunch+en*puckar matvaror+na' 'matbricka'
    "Din bricka har ett urval av de feta, odefinierbara matvarorna
    som här kallas <q>puckar,</q> på grund av deras likhet i utseende
    och smak med den eponyma hockeytillbehöret. "

    owner = me
    disambigName = 'din mat'

    smellDesc = "Maten är förvånansvärt luktfri. Den måste vara
        relativt färsk från burken, eller vilken sorts behållare
        de nu får det här i från. "

    tasteDesc = "Du testar lite, och förbereder dig på något
        alarmerande, som mögel eller kallbrand. Men det är mestadels bara torrt
        och smaklöst. "

    dobjFor(Eat)
    {
        preCond = [touchObj]
        verify() { }
        action() { "Du sväljer ner lite av en av puckarna. "; }
    }

    dobjFor(ThrowAt)
    {
        check()
        {
            /* FOOD FIGHT! ...or maybe not */
            if (gIobj.ofKind(Actor))
                "Du fantiserar för ett ögonblick om att stå på
                bordet, skrika MATKRIG!, och delta när
                matsalen exploderar i kaos. Men, tyvärr,
                Dabney är en för lugn plats för sådant,
                och dessutom skulle dessa puckar kunna slå ut ett öga. ";
            else
                "Bäst att inte kasta runt puckarna; de skulle kunna slå ut
                ett öga. ";
            exit;
        }
    }
;
/* aaron's lunch, erin's lunch, etc */
++ PresentLater, Decoration
    'någon annans aarons erins lunch+en/bricka+n/mat+en/pucken*puckar+na' 'mat'
    "Ingen annans mat ser mer aptitlig ut än din. "

    disambigName = 'någon annans mat'

    plKey = 'lunch'
;

+ ddChair: CustomImmovable, MultiChair
    'enkel enkla mörk+a trä (matsal) stol+en*stolar+na' 'stol'
    "Stolarna är av obeklätt trä. Det finns tillräckligt med stolar för att
    rymma cirka sjuttio personer. "
    
    disambigName = 'enkel trästol'

    cannotTakeMsg = 'Du har ingen anledning att bära runt på en matsalsstol. '

    /* because we represent many objects, customize the status messages */
    actorInName = 'i en av stolarna'

    chooseChairSitMsg()
    {
        if (location.isLunchtime)
            "Du sätter dig med Erin och Aaron. ";
        else
            inherited();
    }
;

/* 
 *   The students eating lunch - present only during the lunch hour.
 *   Don't actually put them in the chair, as the collective nature of the
 *   chair makes that work not terribly well.  Instead, we'll just create
 *   the general impression that various people are sitting in the chairs.
 */
+ PresentLater, Person 'ätande annan student+en*studenter+na' 'studenter'
    "Studenterna äter och pratar. "

    specialDesc = "Rummet är ungefär halvfullt med studenter som sitter
        runt borden och äter lunch. "
    
    disambigName = 'andra studenter'
    isPlural = true

    plKey = 'lunch'
;
++ SimpleNoise '*konversationer+na' 'konversationer'
    "Det är ett konstant sorl av samtal och klirr av bestick. "
    isPlural = true
;

/* ------------------------------------------------------------------------ */
/*
 *   Alcove off Dabney Courtyard 
 */
dabneyCourtyardAlcove: Room 'Flipperspelsrum' 'flipperspelsrummet'
    "Du vet inte vad detta lilla rum utanför innergården
    ursprungligen var avsett för, men för dig är det flipperspelsrummet,
    eftersom det alltid fanns en eller två gamla flipperspel från 1960-talet här.
    Det ser ut som om de äntligen har kommit ikapp 80-talet:
    istället för ett flipperspel finns Positron, ett klassiskt videospel.
    <.p>Innergården är utanför, norrut. "

    vocabWords = 'flipperspelsrum+met/alkov+en'

    north = dabneyCourtyard
    out asExit(north)
;

+ Enterable ->(location.out) 'innergård+en' 'innergård'
    "Innergården är utanför, norrut. "
;

+ posKey: PresentLater, Key 'liten lilla mässing+s (positron) nyckel+n' 'liten mässingsnyckel'
    "Det är en liten mässingsnyckel; det är den som Scott gav dig till
    Positron-spelet. "
;
+ posGame: Heavy, ComplexContainer
    'positron klassisk+a svart+a video+spel+et/positron-spel+et/maskin+en/skåp+et/bokstäver+na'
    'Positron-spel'
    "Du kommer ihåg Positron: det är ett av de klassiska 80-tals-videospelen,
    från generationen direkt efter vektorgrafik-maskinerna.
    Spelet är ganska abstrakt; du flyger ett rymdskepp runt i en labyrint
    av 2D-grottor, skjuter aliens och samlar kraftkristaller.
    <.p>Maskinens skåp är ungefär fem fot högt, målat svart,
    med <q>Positron</q> längs sidan i utsmyckade silverbokstäver. 
    Skärmen är infälld och lutad bakåt, och under den finns konsolen
    med sina stora plastknappar. Ett instruktionskort är fäst
    på konsolen. Under konsolen finns en myntinkast
    och en <<doorStat>> servicelucka, och runt sidan från
    luckan finns strömbrytaren (för närvarande <<posSwitch.onDesc>>).
    <<practiceNote>> "

    /* 
     *   We don't want to show our contents as part of the 'status' part of
     *   EXAMINE, so don't show anything in our examineStatus().  Instead,
     *   we'll count on the compartment's specialDesc to show its contents.
     */
    examineStatus() { }

    /* 
     *   mention that this would be a good thing to practice on, if we
     *   know we need practice and haven't mentioned it before 
     */
    practiceNote()
    {
        if (gRevealed('need-ee-practice') && practiceNoteCount++ == 0)
            "<.p>Det här kan vara precis den sortens sak du behöver
            för att komma i form igen för att arbeta på Brians stapel. Dessa
            gamla videospel är ganska lågteknologiska, så du borde inte ha
            för mycket problem att hitta runt i det. ";
    }
    practiceNoteCount = 0

    /* our door status message */
    doorStat = (posInterior.isOpen ? " (nuvarande öppen)" : "")

    /* our complex-container subcontainer */
    subContainer = posInterior

    /* turn on/off go to the switch */
    dobjFor(TurnOn) remapTo(TurnOn, posSwitch)
    dobjFor(TurnOff) remapTo(TurnOff, posSwitch)

    /* the closest thing we have to a surface is the display */
    iobjFor(PutOn) remapTo(PutOn, DirectObject, posDisplay)

    /* USE POSITRON == play it */
    dobjFor(Use) remapTo(Push, posButtons)
    dobjFor(Play) remapTo(Push, posButtons)

    /* are we working? */
    isWorking = (goodXtal.isIn(xtalSocket))

    /* our on/off state is controlled via the power switch */
    isOn = nil
;

/* 
 *   a class for most of the Positron parts that happen to be elecrical in
 *   nature - these can be tested with the scope and signal generator, but
 *   not much happens when they are 
 */
class PosElectricalPart: TestGearAttachable
    /* 
     *   don't worry about attachment locations, as we don't actually
     *   allow attaching anything - just use everything's current location
     *   to avoid trying to put anything anywhere, and use an elevated
     *   priority to make sure that our non-condition prevails 
     */
    getNearbyAttachmentLocs(other) { return [location, other.location, 100]; }

    probeWithSignalGen()
    {
        /* 
         *   we can only probe if the cabinet is open, and even then,
         *   don't bother 
         */
        if (posInterior.isOpen)
            "Du behöver inte ansluta signalgeneratorn där;
            en snabb undersökning med oscilloskopet borde vara tillräckligt för
            att kontrollera <<itObj>>. "; // TODO: testa av itObj istf thatOBj
        else
            "Du måste öppna skåpet innan du kan komma åt
            någon av komponenternas ledningar. ";

        /* don't allow attaching it in any case */
        detachFrom(signalGen);
    }

    probeWithScope()
    {
        /* only probe when the cabinet is open */
        if (posInterior.isOpen)
            probeWithScopeMsg;
        else
            "Du måste öppna skåpet innan du kan komma åt
            någon av komponenternas ledningar. ";
    }
;

++ posSwitch: PosElectricalPart, Switch, Component
    '(positron) (video) (spel) strömbrytare+n/spel+et' 'strömbrytare'
    disambigName = 'videospelets strömbrytare'

    /* coordinate our on/off state with our parent */
    makeOn(val)
    {
        inherited(val);
        location.isOn = isOn;
    }

    turnOnOff()
    {
        /* show what happens */
        "Du trycker på strömbrytaren";
        if (location.isWorking)
        {
            /* we're working; the display goes on or off as appropriate */
            if (isOn)
            {
                ", och en uppstartsskärm tonar gradvis in på
                displayen. Efter några ögonblick växlar displayen
                till spelets <q>attraktionsläge.</q> ";

                /* if this is the first time, mention it specially */
                if (scoreMarker.scoreCount == 0)
                {
                    "<.p>Det måste ha fungerat! Du pillar med de interna 
                    kontrollerna för att få spela ett gratisspel,
                    sedan spelar du i några minuter. Utomjordingarna 
                    besegrar dig snabbt, men det verkar som att allt 
                    fungerar ordentligt.<.reveal positron-repaired> ";

                    /* score this the first time it happens */
                    scoreMarker.awardPointsOnce();

                    /* this is a clock-significant plot event */
                    repairPlotEvent.eventReached();
                }
            }
            else
                ". En kortvarig vit blixt syns på displayskärmen,
                sedan blir skärmen mörk. ";
        }
        else
            ", men det händer inget uppenbart. ";
    }

    /* do some extra work on turning on or off */
    dobjFor(TurnOn) { action() { inherited(); turnOnOff(); } }
    dobjFor(TurnOff) { action() { inherited(); turnOnOff(); } }

    /* it's a reasonable thing to do, so at least acknowledge it */
    probeWithScopeMsg = "Du gör en snabb undersökning av strömbrytarens
        elektriska kontakter. Allt ser bra ut där. "

    /* 
     *   sore the repair when we turn it on for the first time with the
     *   machine working 
     */
    scoreMarker: Achievement { +10 "reparera Positron" }

    /* a game-clock event for having fixed the game */
    repairPlotEvent: ClockEvent { eventTime = [2, 11, 41] }
;
++ CustomFixture 'instruktionskort+et/instruktionen*instruktioner+na' 'instruktionskort'
    "Överst på kortet, tryckt med fet stil står:
    <table><tr><td align=center>
    <font face='tads-sans'><b>
    \b\t25 öre per spel - Endast mynt
    \n\tEndast för nöjes skull
    \n\t<i>Tillverkad av ARITA GAMES</i>
    \n\t<font size=-1>&copy;1982 Alla rättigheter förbehållna</font>
    \b
    </b></font>
    </table>
    Under detta, handskrivet:
    \b\t<i>Tappat mynt? Besök Scott, Dabney rum 39 (Gränd 7)</i>
    <.reveal find-scott> "
    cannotTakeMsg = 'Instruktionskortet är permanent fäst på
        konsolen. '
;
// TODO: Fixa språket ovan


++ posButtons: PosElectricalPart, Component
    '(positron) (video) (spel) stor+a plastknappar+na/konsol+en'
    'videospelskonsol'
    "Konsolen består av flera stora plastknappar som styr
    rymdskeppet. "

    dobjFor(Push)
    {
        verify() { }
        action()
        {
            if (location.isWorking)
            {
                if (posInterior.isOpen)
                    "Du pillar med de interna kontrollerna för att få dig 
                    ett gratis spel, sedan spelar du i några minuter för
                    att verifiera att allt fungerar. Det är faktiskt ett 
                    ganska roligt spel. Du spelar tills du blir nedslagen
                    av utomjordingarna; GAME OVER blinkar på skärmen i några
                    ögonblick, sedan återgår maskinen till attraktionsläget. ";
                else
                    "Spelet visar SÄTT IN MYNT på skärmen i
                    några ögonblick, och återgår sedan till attraktionsläget. ";
            }
            else
                "Du trycker på knapparna, men ingenting händer. ";
        }
    }

    /* it's not interesting to test this part, but allow it */
    probeWithScopeMsg = "Du testar knapparnas ledningar med oscilloskopet,
        och allt verkar vara i ordning. "

;
++ RestrictedContainer, Component
    '(positron) (video) (spel+et) mynt+et kvarts dollar:s+kvartar mynt:et+springa+n' 'myntspringa'
    "Det är en myntinkast för 25-centmynt. Under springan finns en myntreturknapp. "
    cannotPutInMsg(obj) { return 'Springan accepterar endast mynt. '; }
;
++ RestrictedContainer, Component
    '(positron) (video) (spel) li:ll+ten myntretur+en/fördjupning+en' 'myntretur'
    "Det är en liten fördjupning där mynt returneras när de avvisas
    av myntspringan. "
    cannotPutInMsg(obj) { return 'Fördjupningen är för liten för att rymma
        något annat än ett eller två mynt. '; }

    lookInLister: thingLookInLister {
        showListEmpty(pov, parent) { defaultDescReport('Du kontrollerar
            myntreturen, men du hittar inga vilsna 25-centare. '); }
    }
;
++ posDisplay: PosElectricalPart, Component, Surface
    '(positron) (video) (spel) display+en/skärm+en' 'videospelsdisplay'
    desc()
    {
        if (location.isWorking)
            "Displayen visar spelets <q>attraktionsläge,</q>
            vilket bara är en sektion av spelet som spelas i en loop. ";
        else
            "Displayen är för närvarande mörk. ";
    }
    iobjFor(PutOn)
    {
        action()
        {
            if (gDobj == oooSign)
            {
                "Du sätter tillbaka skylten på displayen. ";
                inherited();
            }
            else
                "Skärmen är för brant vinklad för att kunna hålla något. ";
        }
    }

    /* it's not interesting to test this part, but allow it */
    probeWithScopeMsg = "Du kontrollerar displayanslutningarna och
        ser att allt verkar vara korrekt anslutet. "
;
+++ oooSign: Readable 'gul+a ur-funktion^s+lapp+en' 'gul lapp'
    "Det är en gul lapp som lyder <q>Ur funktion.</q> "

    useSpecialDesc = (location == posDisplay)
    specialDesc = "En gul lapp som lyder <q>Ur funktion</q> sitter på
        Positron-displayen. "
;    
++ posDoor: ContainerDoor
    '(positron) (video) (spel) servicelucka+n/dörr+en*dörrar+na' 'servicelucka'
    "Serviceluckan upptar ungefär den nedre halvan av maskinens framsida;
    den ger tillträde till spelets elektronik.
    <<posInterior.isOpen ? "Den är för närvarande öppen och ger tillträde
        till serviceutrymmet inuti skåpet." : "">> "
;
++ posInterior: KeyedContainer, Component
    '(positron) (video) (spel) service+utrymme+t' 'serviceutrymme'
    
    keyList = [posKey]
    knownKeyList = [posKey]

    initiallyLocked = true
    initiallyOpen = nil

    dobjFor(Close)
    {
        check()
        {
            local obj;
            
            /* do the normal work */
            inherited();

            /* 
             *   we can't close it if anything's attached to the circuits
             *   that's not in the compartment 
             */
            obj = posCircuits.attachedObjects.valWhich({x: !x.isIn(self)});
            if (obj != nil)
            {
                "Du kan inte stänga utrymmet medan <<obj.nameIs>> fortfarande
                ansluten till kretskortet. ";
                exit;
            }
        }
    }
;
+++ posCircuits: TestGearAttachable, CustomImmovable
    'krets+en huvudlogik+en stort stor+a krets:en+kort+et/video:+förstärkare+n/kort+et/kretssystem+et*kretsar+na'
    'kretskort'
    "Dessa gamla spel byggdes på primitiva chips enligt dagens
    standarder, så istället för några få stora integrerade kretsar har dessa
    kort många små chips och diskreta komponenter.
    <<xtalSocket.boardDesc>> "

    cannotTakeMsg = 'Korten är inte lätta att ta bort. '

    /* 
     *   Show a special description in descriptions of our immediate
     *   container (the service compartment), but not as part of anything
     *   above that level.  This is too much detail until we're looking
     *   right at the compartment.  
     */
    useSpecialDescInRoom(room) { return nil; }
    useSpecialDescInContents(cont) { return cont == location; }
    specialDesc = "Flera stora kretskort finns inuti utrymmet. "

    /* 
     *   When things are attached to me, put them in the Positron's
     *   location, and leave me where I am.  This is as safe as the
     *   standard both-in-same-location pattern, since the positron game
     *   can't be moved.  
     */
    getNearbyAttachmentLocs(other)
        { return [location, posGame.location, 100]; }

    /* putting a part into the board maps to the socket */
    iobjFor(PutIn) remapTo(PutIn, DirectObject, xtalSocket)

    /* probe with the oscilloscope */
    probeWithScope()
    {
        /* if the game isn't on, not much happens */
        if (!posGame.isOn)
        {
            "Du undersöker kretsarna på några ställen och finner att
            allt du får är en platt linje, precis vad du skulle förvänta dig när
            spelet är avstängt. ";
            return;
        }

        /* if the machine is repaired, this is easy */
        if (posGame.isWorking)
        {
            "Du gör några snabba kontroller, och allt ser
            ut att fungera korrekt. ";
            return;
        }

        /* if the crystal socket is empty, we know what to do */
        if (xtalSocket.contents.length() == 0)
        {
            "Du är ganska säker på att du behöver sätta in en ny kristall
            i sockel X-7. ";
            return;
        }
        
        /* check how far we've traced the problem */
        switch (traceLevel)
        {
        case 0:
            /* we haven't started yet, so say how we're starting */
            "Eftersom spelets display inte visar något,
            bestämmer du dig för att börja med videoförstärkarna. Det skulle
            vara trevligt att ha ett schema, men du tänker att
            det faktiskt är bättre övning för Stamers stapel utan
            dem.<.p> ";

            /* advance to the video amp trace level */
            ++traceLevel;

            /* go check the video amps */
            goto checkVideoAmps;

        case 1:
            "Du går tillbaka och tittar på videoförstärkarna igen. ";
            
        checkVideoAmps:
            /* check to see if we know what we're doing */
            if (gRevealed('read-video-amp-lab'))
            {
                /* we can finish with this part */
                "Du går noggrant igenom videoförstärkarkretsarna,
                och efter en stund är du övertygad om att de är okej
                och att problemet ligger någon annanstans.
                <.p>Nästa sak att kontrollera är förmodligen
                huvudlogikkortet. ";
            
                /* move to the next trace level */
                ++traceLevel;

                /* go check the main logic board */
                goto checkCPU;
            }
            else
            {
                "Du undersöker lite med oscilloskopet, men det har
                gått ett tag sedan du tittade på en videoförstärkare så
                här mycket i detalj. Om du skulle spendera lite tid med att läsa
                om videoförstärkare i <<townsendBook.moved ? 'en labbmanual':'labbmanualen'>>, 
                skulle du nog ha en bättre idé om hur du ska gå vidare.<.reveal need-video-amp-lab> ";
            }
            break;

        case 2:
            /* move on to the CPU */
            "Du tittar igen på huvudlogikkortet. ";

        checkCPU:
            if (gRevealed('read-1a80-lab'))
            {
                /* we can finish this part */
                "Du kontrollerar runt CPU:n. Efter lite
                undersökning blir det uppenbart att problemet ligger
                i klocksignalen som kommer in i CPU:n, och när
                du vet det identifierar du snabbt en defekt del, som
                förmodligen är källan till problemet: en kristall med
                den bleknade markeringen <q>9.8304MHZ,</q> som indikerar
                dess frekvens.
                <.p>Kristallen behöver bytas ut mot en
                fungerande. Lyckligtvis är den inte lödad på
                kortet---den sitter i en sockel för enkel
                utbyte.<.reveal need-pos-xtal> ";

                /* bring the bad crystal and its socket into the game */
                xtalSocket.makePresent();

                /* move to the next trace level */
                ++traceLevel;
            }
            else
            {
                "Du identifierar CPU:n som en 1A80. Du byggde några få
                projekt med dessa för många år sedan, men du kommer säkert
                inte ihåg alla små detaljer om stiftkonfiguration
                och så vidare, så du behöver slå upp 1A80
                i <<townsendBook.moved ? 'en labbmanual':'labbmanualen'>> 
                innan du kan testa logikkortet ordentligt.
                <.reveal need-1a80-lab> ";
            }
            break;

        case 3:
            "Du har spårat problemet till en defekt kristall---den
            märkt <q>9.8304MHz</q>---på huvudlogikkortet. Du
            behöver helt enkelt byta ut den. Lyckligtvis sitter den i en sockel,
            inte fastlödd, vilket gör den lätt att ta bort. ";
            break;
        }
    }

    /* how far have we traced the problem? */
    traceLevel = 0
;
++++ randomComponents: GenericObject, CustomImmovable
    'små+skalig+a diskret+a 1A80 cpu+n/kristall+en/chip+pen/
    *chips kristaller+na komponenter+na transistorer+na motstånd+ena kondensatorer+na'
    'chips'
    "Korten har många diskreta komponenter---transistorer,
    motstånd, kondensatorer och småskaliga chips. "

    disambigName = 'chips på kretskorten'
    isPlural = true

    cannotTakeMsg = 'De flesta komponenterna är fastlödda. '

    /* trying to attach something here redirects to the board */
    iobjFor(AttachTo) remapTo(AttachTo, DirectObject, location)
    dobjFor(TestWith) remapTo(TestWith, location, IndirectObject)
    iobjFor(PlugInto) remapTo(PlugInto, DirectObject, location)
;
++++ xtalSocket: PresentLater, Component,
    SingleContainer, RestrictedContainer
    'x-7/x7 kristall+sockel+n' 'X-7 sockel'
    "Det är en sockel för en viss typ av kristall. "

    aName = 'sockel X-7'

    /* mention it as part of the board description if appropriate */
    boardDesc()
    {
        /* if I'm not here, say nothing */
        if (location == nil)
            return;

        /* mention me and my contents */
        if (badXtal.isIn(self))
            "<.p>En av komponenterna är den dåliga 9,8304 MHz-kristallen du har
            identifierat som den troliga källan till spelets problem. ";
        else
            "<.p>Bland kortets komponenter finns en tom sockel
            märkt X-7. Sockeln är avsedd för en kristall. ";
    }

    /* don't show my contents in listings of containing objects */
    contentsListed = nil

    /* allow only the crystals */
    validContents = [badXtal, goodXtal]
    cannotPutInMsg(obj) { return 'Det enda som passar i sockeln
        är en viss typ av kristall. '; }

    /* turn off positron when inserting or removing parts */
    turnOffGameFirst()
    {
        if (posGame.isOn)
        {
            extraReport('Du stänger av Positron-spelet först för att
                säkerställa att du inte skadar några delar. ');
            posSwitch.makeOn(nil);
        }
    }
    notifyRemove(obj) { turnOffGameFirst(); }
    notifyInsert(obj, newCont) { turnOffGameFirst(); }
;
+++++ badXtal: Thing
    'svart+a svartnad+e  gam:mal+la dålig+a trasig+a li:ten+lla metallisk+a 9,8304mhz 9,8304 mhz kristall+en/(låda+n)'
    'gammal 9,8304 MHz-kristall'
    "Det är en liten metallåda, formad som en sardinburk men krympt
    till storleken av ett mynt. <q>9,8304MHZ</q> är stämplat på den
    med bleknade bokstäver.
    <<isIn(xtalSocket)
      ? "Lyckligtvis sitter den i en sockel, inte fastlödd på kortet,
        vilket gör det enkelt att byta ut den." : "">> "

    disambigName = 'gammal 9,8304 MHz-kristall'
;

/*
 *   The bag of spare parts 
 */
+++ RestrictedContainer, Consultable
    'skrynklig+a brun+a papperspåse+n/säck+en' 'brun papperspåse'
    "Det är en brun papperspåse, den typ som vid något tillfälle kan ha
    rymt två liter mjölk från mataffären. "

    cannotPutInMsg(obj) { return 'Du vill inte blanda ihop något
        med de blandade reservdelarna. '; }

    lookInDesc = "Påsen är full av slumpmässiga reservdelar. Om du
        behöver en specifik del, så skulle du kanske hitta den om 
        du letade efter den. "

    /* GET X FROM BAG -> SEARCH BAG FOR X */
    iobjFor(TakeFrom) remapTo(ConsultAbout, self, DirectObject)

    /* this isn't something we want to put new objects into */
    iobjFor(PutIn) { verify() { logicalRank(50, 'speciell påse'); } }

    /* 
     *   When we LOOK IN or SEARCH the bag, there are three possibilities.
     *   First, if we haven't found out that we need the crystal yet, we
     *   see only random parts, because we don't know what we need yet.
     *   Second, if we do know we need the crystal, but we haven't found
     *   it yet, we find the crystal.  Third, if we've already found the
     *   crystal, we again see only random spare parts, but this time
     *   because we've already found everything we need so far. 
     */
    dobjFor(LookIn)
    {
        action()
        {
            if (!gRevealed('need-pos-xtal'))
            {
                /* we don't even know what we need yet */
                "Påsen är full av slumpmässiga reservdelar. Om du lyckas
                spåra problemet med Positron till en specifik
                dålig del, så kanske du kan hitta en ersättare här. ";
            }
            else if (goodXtal.location == nil)
            {
                /* we know we need the crystal, and we don't have it yet */
                replaceAction(ConsultAbout, self, goodXtal);
            }
            else
            {
                /* we've already found everything we need */
                "Du sållar genom delarna lite, men du ser inte
                något du behöver för tillfället. ";
            }
        }
    }
;
++++ GenericObject, CustomImmovable
    '(slumpmässig+a) (positron) reservdel+en/kristall+en/chip+et*reservdelar+na kristaller+na chips komponenter+na transistorer+na motstånd+et kondensatorer+na'
    'reservdelar'
    "Påsen är full av slumpmässiga reservdelar för Positron-
    spelet---chips, transistorer, kondensatorer, kristaller och så vidare. "

    isPlural = true

    cannotTakeMsg = 'Det finns många delar här, så det är bättre
        att hålla dem ihop i påsen. Om du behöver en specifik
        del, så kanske du skulle kunna hitta den om du letade efter den. '

    /* show a special description in our immediate container only */
    useSpecialDescInRoom(room) { return nil; }
    useSpecialDescInContents(cont) { return cont == location; }
    specialDesc = "Påsen är full av slumpmässiga reservdelar för
        Positron-maskinen. "

    /* map LOOK IN and CONSULT ABOUT to our container */
    dobjFor(LookIn) remapTo(LookIn, location)
    dobjFor(ConsultAbout) remapTo(ConsultAbout, location, IndirectObject)
    iobjFor(TakeFrom) remapTo(ConsultAbout, location, DirectObject)
;

/*
 *   Find the good crystal.  Use an elevated match score for this so that
 *   we match it if at all possible, even on vague things like "find
 *   crystal".  We'll then turn around and ignore this if we don't know
 *   what we're looking for yet.
 *   
 *   We have three goals that we meet with this weird handling.  First, if
 *   we know what we're looking for, we want to be liberal about finding
 *   it: we want vague things like FIND CRYSTAL IN BAG to find it, which
 *   we do by ensuring this topic is highly ranked and thus matches on any
 *   correct vocabulary.  Second, if we *don't* know what we're looking
 *   for, because we haven't gotten to that point in the game yet, we
 *   *don't* want such liberal matching.  We avoid the liberal matching in
 *   this case by matching on the vocabulary, but then just replacing the
 *   action with FIND GENERIC PARTS instead if we don't know what we need
 *   yet.  Third, if we look for *exactly* the right part, we want to find
 *   it regardless of whether we know about it yet.  We accomplish this
 *   third bit by allowing the match if the command contains the specific,
 *   unique identifier for this part that can't be confused with the
 *   generic parts.  
 */
++++ ConsultTopic +110 @goodXtal
    handleTopic(actor, topic)
    {
        /*
         *   Until we know we need the crystal, only find the crystal if
         *   we asked for exactly the right one, identified by the unique
         *   "9.8304" vocabulary.  
         */
        if (gRevealed('need-pos-xtal')
            || rexSearch('9<dot>8304', topic.getTopicText(), 1) != nil)
        {
            /* we know what we want, or the exact name was given - find it */
            inherited(actor, topic);
        }
        else
        {
            /* don't know exactly what we want; find generic parts instead */
            replaceAction(ConsultAbout, location, randomComponents);
        }
    }
    
    topicResponse()
    {
        /* move the good crystal into the bag, then take it */
        goodXtal.makePresent();
        nestedAction(Take, goodXtal);

        /* mention that we found it */
        "Du sållar igenom delarna i några ögonblick och stöter 
        på en helt ny 9,8304 MHz-kristall<<
          goodXtal.isIn(me) ? ", som du tar" : "" >>. ";

        /* make the crystal 'it' */
        gActor.setIt(goodXtal);
    }

    /* this is only active until we find the crystal */
    isActive = (goodXtal.location == nil)
;
++++ ConsultTopic @randomComponents
    "Påsen är full av slumpmässiga delar. Du kanske kan hitta
    en specifik del om du letar efter exakt den del du behöver. "
;
++++ DefaultConsultTopic
    "Det finns många delar, men du hittar inte den
    du letar efter. "
;
++++ goodXtal: PresentLater, Thing
    'splitter+ny+a ny+a li:ten+lla metallisk+a 9,8304mhz 9,8304 mhz bra
    ersättning^s+kristall+en/kristall+en/(metall|låda+n)'
    'ny 9,8304 MHz-kristall'
    "Det är en liten metallåda, ungefär lika stor som ett mynt, stämplad
    med <q>9,8304MHZ.</q> Den ser blank och ny ut. "

    disambigName = 'ny 9,8304 MHz-kristall'

    /* make it known so that we can look it up */
    isKnown = true
;

/* ------------------------------------------------------------------------ */
/*
 *   Alley 3 - entrance 
 */
alley3main: AlleyRoom 'Gränd Tre Ingång' 'ingången till Gränd Tre'
    "Detta är mitten av Gränd Tre, som löper öster och
    väster härifrån. Utgången till innergården är norrut,
    och bredvid den leder en trappa uppåt. Dörren till rum 13 är
    söderut. "

    vocabWords = '3+e gränd+en tre+dje ingång+en/korridor+en/hall+en'

    north = dabneyCourtyard
    out asExit(north)
    northeast asExit(north)
    up = a3StairsUp
    east = alley3E
    west = alley3W
    south = room13door

    roomParts = static (inherited + [alleySouthWall, alleyNorthWall])
;

+ ExitPortal ->(location.out) 'innergård+en/utgång+en' 'innergård'
    "Innergården ligger norrut. "

    dobjFor(Enter) asDobjFor(TravelVia)
;

+ room13door: AlleyDoor '13 13e -' 'dörr till rum 13'
    "Trädörren är märkt med <q>13.</q> "
;

+ Graffiti 'par små li:ten+lla abstrakt+a mönst:er+ret*mönst:er+rena' 'klotter'
    "Det finns ett par små abstrakta mönster som tydligen sparats
    vid den senaste ommålningen, och inte mycket annat. "
;

+ a3StairsUp: StairwayUp 'trappa+n/trappuppgång+en*trappor+na' 'trappuppgång'
    "Trapporna leder upp till Gränd Fyra. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Alley 3 east
 */
alley3E: AlleyRoom 'Gränd Tre Öst' 'östra änden av Gränd Tre'
    "Korridoren slutar här och fortsätter västerut. Den är delvis
    blockerad av en elaborat dekorerad, kylskåpsstor kartong
    utanför dörren till rum 12, på södra sidan av hallen.
    Dörren till rum 10 är på andra sidan hallen på norra sidan, och rum
    11 är i slutet av hallen. "

    vocabWords = '3+e tre+dje gränd+en'

    west = alley3main
    north = room10door
    east = room11door
    south = room12door

    atmosphereList: ShuffledEventList { [
        'Ett par av kycklingarna ger sig av nerför hallen, förmodligen
        på väg ut på ett uppdrag. ',
        'Kycklingarna myllrar omkring och flaxar med vingarna. ',
        'Ett par kycklingar anländer från hallen. ',
        'Kycklingarna flaxar upphetsat med vingarna. ']
        
        eventPercent = 66
    }
;

+ Graffiti '-' 'klotter'
    "Till skillnad från resten av huset finns det inget klotter här. "
;

+ room10door: AlleyDoor '10 -' 'dörr till rum 10'
    "Dörren är märkt med <q>10.</q> "
;

+ room11door: AlleyDoor '11 -' 'dörr till rum 11'
    "Trädörren är märkt med <q>11.</q> "
;

+ room12door: StackDoor '12 -' 'dörr till rum 12'
    "Dörren är märkt med <q>12.</q> "
;
++ chickenNotebook: CustomImmovable, Readable
    'grå+a anteckningsbok+en/snöre+t' 'anteckningsbok'
    "Anteckningsboken hänger i ett snöre. Eleganta kalligrafiska
    bokstäver pryder omslaget: <q><i>Laboratorieanteckningar och
    Filosofiskt Manifest av Dr. Klaus W.D. von Geflügel,
    Supergeni</i>.</q> "
    
    readDesc = "Anteckningsboken är fylld med samma typ av blomstrande
        kursiv stil som omslaget.
        <.p><i>
        &ldquo;Laboratorieanteckningar och Filosofiskt Manifest
        av Dr. Klaus W.D. von Geflügel, Supergeni
        <.p>&ldquo;Jag, Klaus von Geflügel, anförtror nu till bläck
        och pergament mina Största Upptäckter, sannerligen en Historisk
        Bedrift. Sedan mina tidigaste Barndomsminnen har det
        Varit min Dröm och Heliga Strävan att skapa
        det jag nu har skapat. Du, läsaren, en
        Vanlig Man, kan Omöjligt känna till eller uppskatta den stora
        Vedermödan i min strävan. Du kan inte veta Hur det är att bli
        kallad Galen, att bli utskrattad av Rivaler när Dina tidiga
        experiment &lsquo;misslyckas.&rsquo; Men dessa Rivaler kommer snart
        att inse att de är Rena Dårar, för de visste inte att
        mina tidigare experiment Inte var misslyckanden, utan Gradvisa och
        Avsiktliga Steg på en Stor Resa som nu, Äntligen,
        når sin Oundvikliga slutsats och Fullbordan.
        <.p>&ldquo;För jag har skapat det som alla Filosofer har
        drömt om sedan Vetenskapens Tidigaste dagar. Jag har skapat
        Medlen för att producera en varelse vida Överlägsen alla som
        hittills vandrat på denna Jord: En Varelse som kombinerar
        Människans Statur och Stora Storlek med Kycklingens Intelligens
        och Graciösa Elegans... en ras av jätte-superkycklingar. 
        Med denna Upptäckt kommer jag att skapa En armé
        av oövervinneliga Superkycklingar, och tillsammans kommer vi att Härska över
        Jorden, och Under mitt Välvilliga Styre kommer vi att skapa ett
        Sant paradis för Människa och Kyckling alike.&rdquo;
        </i>
        <.p>Det fortsätter så här och lägger fram reglerna för stapeln.
        Det verkar som att stackdeltagarna måste <q>bli</q> jätte-
        kycklingar med hjälp av Chickenatorn, och sedan utföra ett antal
        uppdrag som en del av Super-Kyckling Armén---i princip en
        serie stunts runt campus. Den viktigaste regeln är att
        när man väl har förvandlats till en kyckling kan en deltagare bara prata med
        icke-kycklingar genom att kackla. "

    disambigName = 'grå anteckningsbok'
    specialDesc = "En grå anteckningsbok hänger i ett snöre på
        dörren till rum 12. "
    cannotTakeMsg = 'Anteckningsboken är fastbunden vid dörren, förmodligen
        för att förhindra att någon går iväg med den. '

    dobjFor(Open) asDobjFor(Read)
    dobjFor(LookIn) asDobjFor(Read)
;

+ chickenator: Immovable, EntryPortal -> insideChickenator
    'färgad+e stor+a dekorerad+e kartong smal+a
    låda+n/bås+et/chickenator+n/ljus+et/öppning+en*ljusen+a'
    'kartongbox'
    "Lådan måste ursprungligen ha innehållit ett kylskåp eller en stor
    möbel: den är över två meter hög och nästan lika bred
    och djup. Den har målats och dekorerats med färgade ljus
    för att se ut som något från en gammal science fiction-film, och
    på framsidan står det <q>Chickenator Mark III.</q> På ena sidan
    finns en smal öppning, precis nog stor för en person att gå in i. "

    disambigName = 'dekorerad kartongbox'

    dobjFor(Board) asDobjFor(Enter)
;

+ superChickens: DisambigDeferrer, Person
    'jättekycklingar+na dräkter+na kycklingar+na super-kycklingar+na kostymer+na'
    'jättekycklingar'
    "De är egentligen människor som bär kycklingdräkter, men kostymerna är
    ganska bra. "

    isPlural = true

    /* defer in disambiguation to the chicken suit I'm wearing */
    disambigDeferTo = [chickenSuit]
;

/* 
 *   A class for actors who are being chickens.  As participants in the
 *   stack, they can't interact with us unless we're wearing the chicken
 *   suit. 
 */
class ChickenActorState: ActorState
    handleConversation(otherActor, topic, convType)
    {
        /* 
         *   if the other actor is wearing the chicken suit, proceed as
         *   normal; otherwise, we can't talk to them 
         */
        if (chickenSuit.isWornBy(otherActor))
            inherited(otherActor, topic, convType);
        else
            "<q>Kluck! Kluck! Kluck!</q> Kycklingarna flaxar med vingarna
            i upprördhet och pekar på anteckningsboken på dörren. ";
    }
;

++ ChickenActorState
    isInitState = true
    specialDesc = "Flera jättekycklingar står runt omkring
        i hallen och pratar tyst med varandra. "
;
+++ AskTellShowTopic, StopEventList
    [stackTopic, chickenSuit, chickenator, chickenNotebook, superChickens]
    ['<q>Så hur fungerar den här stapeln?</q> frågar du genom dräkten.
    <.p><q>Vi är super-kycklingarmén!</q> säger en av kycklingarna.
    <q>Vi är på ett uppdrag från Dr. von Geflügel!</q> ',

     '<q>Hur många super-kycklingar finns det?</q> frågar du.
     <.p><q>Det fanns ungefär åtta fjäderfäformiga matrixerare när vi
     började,</q> säger en av kycklingarna. ',

     '<q>Hur går det med stapeln?</q> frågar du.
     <.p>Kycklingarna rådgör. <q>Super-kyckling armén gör
     utmärkta framsteg!</q> säger en av dem. ']
;
    
+++ AskTellTopic [scottTopic, posGame]
    topicResponse()
    {
        "<q>Har någon sett Scott?</q> frågar du, din röst
        dämpad genom dräkten.
        <.p>En av kycklingarna, en färgglad röd, vinkar. <q>Jag är
        Scott,</q> säger han. ";

        /* bring scott into play, and drop his Unthing */
        scott.makePresent();
        unScott.moveInto(nil);
    }
;
+++ AskForTopic @scottTopic
    topicResponse() { replaceAction(AskAbout, gDobj, scottTopic); }
;
++++ AltTopic
    "<q>Har ni killar sett Scott?</q> Din röst är dämpad
    genom kycklingdräkten.
    <.p>Kycklingarna ser sig omkring och lutar på huvudena för att se ut
    genom dräkterna. <q>Jag tror han är ute på ett av uppdragen,</q>
    säger en av dem. <q>Han kommer tillbaka senare.</q> "
    
    /* we gate scott's appearance on starting with stamer's stack */
    isActive = (labKey.isIn(erin))
;
++++ AltTopic
    "<q>Är Scott här?</q> frågar du.
    <.p>En av kycklingarna, en färgglad röd, vinkar. <q>Här
    är jag,</q> säger han. "

    /* this one fires when scott is already here */
    isActive = (scott.isIn(alley3E))
;
    
+++ DefaultAnyTopic, ShuffledEventList
    ['En kyckling anländer precis när du börjar prata, vilket orsakar
    en mindre uppståndelse i flocken. ',
     'Kycklingarna bara kacklar. ',
     'Kycklingarna bara flaxar med vingarna. ',
     '<q>Super-kyckling armén är mycket upptagen!</q> säger en av
     kycklingarna. ']
;

/* an unthing for scott, until he's here */
+ unScott: Unthing 'scott' 'Scott'
    isProperName = true
    isHim = true
    notHereMsg = 'En av kycklingarna kan vara Scott, men du vet inte
        vilken. '
;

/* the owner of the positron game */
+ scott: DisambigDeferrer, PresentLater, Person
    'färgglad+a röd+a jättekyckling+en dräkt+en/scott' 'Scott'
    "Han bär en särskilt färgglad kycklingdräkt, mestadels röd. "

    /* 
     *   he's just one of the crowd of chickens, so don't mention him
     *   separately 
     */
    specialDesc = ""
    isProperName = true
    isHim = true

    noResponseFromMsg(actor) { return 'Scott bara kacklar och flaxar 
        med vingarna. '; }

    /* 
     *   defer in disambiguation to the chicken suit I'm wearing, and to
     *   the other giant chicken people 
     */
    disambigDeferTo = [chickenSuit, superChickens]
;
++ ChickenActorState
    isInitState = true
;
++ AskTellGiveShowTopic [posGame, lostQuarterTopic, oooSign]
    "<q>Är du ägaren till Positron-maskinen?</q> frågar du.
    <.p><q>Ja,</q> säger han.
    <.convnode repair-positron> "
;
+++ AltTopic
    "<q>Har du några fler detaljer om vad som är fel med
    Positron?</q> frågar du.
    <.p><q>Inte egentligen,</q> säger han. <q>Den är bara helt död.</q> "

    /* this topic is active after we've obtained the key */
    isActive = (posKey.moved)
;
+++ AltTopic, StopEventList
    ['<q>Jag ville bara meddela att jag lyckades reparera Positron,</q>
    säger du.
    <.p><q>Det är fantastiskt!</q> säger Scott. <q>Tack!</q> ',
     '<q>Nämnde jag att jag fixade Positron?</q> frågar du.
     <.p><q>Ja, tack igen,</q> säger Scott. ']
    
    isActive = gRevealed('positron-repaired')
;
++ DefaultAnyTopic, ShuffledEventList
    ['<q>Jag är lite upptagen med stapeln,</q> säger Scott. ',
     'Scott bara kacklar. ',
     'Han verkar upptagen med stapeln. ']
;
++ ConvNode 'repair-positron';
+++ SpecialTopic 'fråga vad som är fel med den'
    ['fråga','scott','honom','vad','som','är','trasigt','fel','med','den',
     'positron','maskinen']
    "<q>Vet du vad som är fel med den?</q> frågar du.
    <.p>Han kliar sig på huvudet med vingen. <q>Inte egentligen. Jag har
    försökt få någon att titta på den.</q>
    <.convstay><.topics> "

    /* only offer this question at this node one time */
    isActive = (talkCount == 0)
;
+++ SpecialTopic 'erbjud dig att reparera den'
    ['erbjud','mig','dig','att','laga','reparera','den','positron','maskinen']
    topicResponse()
    {
        "<q>Jag kan lite om elektronik,</q> säger du. <q>Jag skulle
        gärna försöka fixa den.</q>
        <.p><q>Har du reparerat något liknande förut?</q>
        <.convnode ask-experience> ";
    }
;
++ ConvNode 'ask-experience'
    commonReply = "<.p><q>Så varför är du så intresserad av att fixa ett
        gammalt videospel?</q> frågar han med skeptism i rösten. <q>Jag
        brukar behöva tjata på mina elektroingenjörsvänner i veckor för
        att få någon att hjälpa till.</q>
        <.convnode why-repair> "
;
+++ YesTopic
    "<q>Visst,</q> säger du. <q>Det var ett tag sedan, men jag har gjort mycket
    arbete med datorer och videoskärmar förut.</q>
    <<location.commonReply>> "
;
+++ NoTopic
    "<q>Inte något exakt som det här,</q> medger du. <q>Men jag har
    gjort mycket arbete med datorer och videoskärmar, vilket är
    i princip samma sak.</q>
    <<location.commonReply>> "
;
++ ConvNode 'why-repair'
    commonReply = "<q>Jag jobbar med Brian Stamers stapel,</q> säger du.
        <q>Det är någon sorts elektronisk felsökningspussel, och jag behöver
        verkligen öva på något enklare innan jag tar mig an det.</q>
        <.p><q>Öva?</q> Han låter lite irriterad. <q>Du vill
        öva på mitt videospel? Jag menar, jag uppskattar erbjudandet
        och allt, men hur vet jag att du inte kommer att göra det värre?</q>
        <.convnode why-not-worse> "
;
+++ SpecialTopic 'förklara Stamers stapel'
    ['förklara','om','hur','brian','stamers','stack', 'stapeln','fungerar']
    "<<location.commonReply>> "
;
+++ SpecialTopic 'säg att du behöver öva'
    ['säg','jag','du','behöver','öva','lite','övning']
    "<<location.commonReply>> "
;
++ ConvNode 'why-not-worse'
    commonReply()
    {
        "<.p>Han pausar länge. <q>Okej,</q> säger han,
        <q>låter rimligt.</q> Han letar runt i sin kycklingdräkt
        ett tag, sedan fiskar han upp en nyckel och räcker den till dig.
        <q>Här är nyckeln till maskinen. </q>
        <q>Du tar nyckeln, vilket är svårt med dräkten på, </q>";

        if (myKeyring.isIn(me))
        {
            "och fumlar genom dräkten för att hitta din egen nyckelring,
            vilket är ännu svårare.  Efter några försök lyckas
            du stoppa fast nyckeln på din nyckelring och stoppa 
            nyckelringen i din ficka. ";

            posKey.moveInto(myKeyring);
            myKeyring.moveInto(myPocket);
        }
        else
        {
            "och fumlar genom dräkten för att hitta din ficka,
            vilket är ännu svårare. Du lyckas till sist att 
            sätta nyckeln i fickan. ";

            posKey.moveInto(myPocket);
        }

        /* aware some points */
        scoreMarker.awardPointsOnce();

        "<.p><q>Tack!</q> säger du.  <q>Jag återkommer om jag lyckas laga
        det.</q> ";
    }

    scoreMarker: Achievement { +5 "få Positronnyckeln" }
;
+++ SpecialTopic 'lova att inte ha sönder den'
    ['lova','att','inte','förstöra','ha','sönder','den','positron','maskinen']
    "<q>Jag lovar att jag inte kommer att göra det värre,</q> säger du. <q>Jag ska bara
    ta en titt för att se om jag kan lista ut vad som är fel, och om jag
    inte är säker på att jag kan fixa det, kommer jag inte att försöka.</q><<location.commonReply>> "
;
+++ SpecialTopic 'säg att du betalar för reparationer om du har sönder den'
    ['lova','säg','att','du','jag','kommer','ska','erbjuda','erbjuder','dig','att',
     'betala','för','ev','eventuella','reparationer','reparationerna',
     'om','du','jag','har','sönder','förstör','den','positron','maskinen']
    "<q>Om jag gör det värre, kommer jag att betala för att få den reparerad,</q> erbjuder du.
    <<location.commonReply>> "
;

/* ------------------------------------------------------------------------ */
/*
 *   Inside the chickenator.  We could have made this a nested room, but
 *   there's no real relationship to the enclosing alley 3 area other than
 *   the in/out connection, so for simplicity it's just a separate room. 
 */
insideChickenator: Room 'Chickenator' 'Chickenatorn' 'Chickenator'
    "Lådan är lika dekorerad på insidan som på utsidan. En instruktionsskylt
    är uppsatt ovanför en enorm knivströmbrytare, och färgade lampor längs
    alla väggar och i taket blinkar. Flera rockkrokar är placerade
    längs en vägg, nära taket. En smal öppning i sidan av
    lådan leder tillbaka ut. "
    
    vocabName_ = 'chickenator+n/kartong+låda+n'

    out = alley3E

    /* 
     *   the box is described in the alley description as being on the
     *   south side of the hall, so map 'north' to 'out' even though we
     *   don't mention it as an exit; likewise, some people might
     *   visualize the exit as being west, since we're at the east end of
     *   the hall, or east, as the hall continues a bit further east, so
     *   allow these as equivalents for 'out' as well 
     */
    north asExit(out)
    east asExit(out)
    west asExit(out)
;

+ Decoration 'julgrans färgad+e lampa+n/lampor+na' 'färgade lampor'
    "De är förmodligen julgransljus. "
;

+ ExitPortal
    'smal+a 3 3e gränd+en öppning+en/utgång+en/tre+dje/gränd+en/hall+en/korridor+en' 'öppning'
    "Öppningen leder tillbaka ut till gränden. "
;

+ Fixture, Surface 'rock|krok+en*rock|krokar+na' 'rockkrokar'
    "Flera rockkrokar är placerade längs väggen nära taket. "
    isPlural = true

    /* only allow the chicken suit to hang here */
    iobjFor(PutOn)
    {
        verify()
        {
            if (gDobj != nil && gDobj != chickenSuit)
                illogical('Krokarna är endast för kycklingdräkter. ');
        }
    }

    /* HANG obj ON HOOK -> PUT obj ON HOOK */
    iobjFor(HangOn) remapTo(PutOn, DirectObject, self)

    /* customize some default messages */
    alreadyPutOnMsg = '{Ref dobj/han} hänger redan på en krok. '

    /* 
     *   customize the way we describe our contents, so that we describe
     *   things as hanging on the hooks rather than being in the hooks 
     */
    contentsLister: HookContentsLister, surfaceContentsLister { }
    descContentsLister: HookContentsLister, surfaceDescContentsLister { }
    lookInLister: HookContentsLister, surfaceLookInLister {
        showListEmpty(pov, parent)
            { "Ingenting hänger för närvarande på krokarna. "; }
    }
;

/* 
 *   Contents lister mix-in for our hooks.  This is a mix-in that can be
 *   combined with the normal surface contents lister subtypes to create
 *   the various specialized kinds of listers we need. 
 */
class HookContentsLister: object
    showListPrefixWide(itemCount, pov, parent)
        { "\^"; }
    showListSuffixWide(itemCount, pov, parent)
    {
        if (itemCount == 1)
            " hänger på en av krokarna. ";
        else
            " hänger på krokar. ";
    }
;

++ chickenSuit: Wearable
    'vit+a fjäderfä+formig+a kyckling+dräkt+en/matrixerare+n*fjädrar+na' 'kycklingdräkt'
    "Det är en heltäckande kycklingdräkt, stor nog för dig att ta på dig.
    Fjädrarna är mestadels vita. "

    bulk = 4

    beforeAction()
    {
        /* do the normal work */
        inherited();
        
        /* don't allow picking anything up while in the chicken suit */
        if (isWornBy(gActor))
        {
            if (gActionIs(Take) || gActionIs(TakeFrom))
            {
                "Det är för svårt att greppa något med 
                kycklingdräkten på. ";
                exit;
            }
        }
    }
    beforeTravel(traveler, conn)
    {
        if (traveler.isActorTraveling(me) && isWornBy(me))
        {
            if (conn.getDestination(traveler.location, traveler)
                not in (alley3main, alley3E, alley3W, insideChickenator))
            {
                "Det är för svårt att se vart du går i
                kycklingdräkten. Om du lämnar gränden
                kanske du inte kan hitta tillbaka. ";
                exit;
            }
            else
                "Det är verkligen svårt att se vart du 
                går med kycklingdräkten på; du måste 
                gå långsamt och känna dig för längs 
                väggen.<.p>";
        }
    }
    
    dobjFor(Wear)
    {
        preCond = (inherited() + handsEmptyForSuit)
        check()
        {
            if (!isIn(insideChickenator))
            {
                "Du borde verkligen följa med i stapeln och
                använda Chickenatorn för att göra transformationen. ";
                exit;
            }
        }
    }
    okayWearMsg = 'Det tar lite tid, särskilt i detta
        trånga utrymme, men du lyckas kämpa dig in i
        dräkten. Den täcker dig från topp till tå, och det är inte
        särskilt lätt att se ut genom den. '

    /* a customized hands-empty condition for wearing the suit */
    handsEmptyForSuit: handsEmpty {
        failureMsg = 'Dräkten är så stor och otymplig att du måste
            lägga ner allting innan du kan ta på dig den. '

        /* 
         *   Require dropping everything except the chicken suit (we
         *   obviously wouldn't want to require dropping the suit itself,
         *   since we need to be holding it to put it on).  Include even
         *   worn items that aren't AlwaysWorn's.  
         */
        requireDropping(obj)
        {
            /* 
             *   We have to drop everything that we're either holding or
             *   wearing, except for the chicken suit itself and any
             *   AlwaysWorn items.  
             */
            return (obj != chickenSuit
                    && (obj.isHeldBy(gActor)
                        || (obj.ofKind(Wearable)
                            && !obj.ofKind(AlwaysWorn)
                            && obj.isWornBy(gActor))));
        }

        /* 
         *   don't try auto-bagging anything; since we need to drop
         *   everything, including the tote bag, there's no point in trying
         *   to free up space that way 
         */
        autoBag = nil
    }

    dobjFor(Doff)
    {
        check()
        {
            if (!isIn(insideChickenator))
            {
                "Du borde verkligen följa med i stapeln och använda
                Chickenatorn för att transformeras tillbaka till människa. ";
                exit;
            }
        }
    }
    okayDoffMsg = 'Klumpigt extraherar du dig själv från dräkten. Det är
        en lättnad att komma ur den. '

    /* this is a bit too large to stuff in the tote */
    dobjFor(PutIn)
    {
        check()
        {
            if (gIobj == toteBag.subContainer)
            {
                "Tygkassen är rymlig, men kycklingdräkten är helt enkelt
                för stor. ";
                exit;
            }
        }
    }
;

+ Fixture, Readable 'instruktion:en^s+skylt+en*instruktioner+na' 'instruktionsskylt'
    "<font face=tads-sans><b>Chickenator Mark III Bruksanvisning</b>
    <br><br><b>Kycklingsomvandling:</b> Välj fjäderfäformig matrixerare från hyllan.
    Ta på. Dra i omkopplaren. Kycklingsomvandlingsprocessen är automatisk.
    <br><br><b>Av-kycklingsomvandling:</b> Dra i omkopplaren. Av-kycklingsomvandlingsprocessen
    är automatisk. När det är klart kommer subjektet att vara täckt med rester
    av fjäderfäformig matrixerare. Ta av matrixeraren och återlämna den till
    kroken.</font> "
;

+ SpringLever, Fixture
    'enorm+a elektrisk+a gångjärnsförsedd+a gångjärnsförsett (par+et) bar+a metall+iska
     knivomkopplare+n/spak+en/handtag+et/metallblad+en'
    'knivomkopplare'
    "Det är den standardmässiga Galen Vetenskapsman-typen av elektrisk omkopplare: ett gångjärnsförsett
    par av bara metallblad med ett fotlångt handtag. Den är i nedfällt läge. "

    dobjFor(Pull)
    {
        action()
        {
            "Du griper tag i handtaget och drar bladen uppåt. Ljudet
            av elektriska gnistor kommer från en dold högtalare, och
            lamporna i båset dämpas. Så snart du släpper handtaget
            fjädrar det tillbaka ner och specialeffekterna upphör. ";

            if (!seenBefore)
            {
                "<.p>Inte oväntat verkar det som att du faktiskt inte
                har förvandlats till en kyckling. ";
                seenBefore = true;
            }
        }
    }
    seenBefore = nil

    dobjFor(Push) asDobjFor(Pull)
    dobjFor(Raise) asDobjFor(Pull)
    dobjFor(Lower) { verify() { 
        illogicalAlready('Den är redan i nedfällt läge. '); 
    } }
;

/* ------------------------------------------------------------------------ */
/*
 *   Alley 3 west
 */
alley3W: AlleyRoom 'Gränd Tre Väst' 'västra änden av Gränd Tre'
    "Detta är den västra änden av Gränd Tre; korridoren fortsätter
    österut. Dörren till rum 14 är på södra sidan, 15
    i västra änden, och 16 på norra sidan av korridoren. "

    vocabWords = '3 3e gränd+en tre+dje'

    east = alley3main
    north = room16door
    west = room15door
    south = room14door
;

+ room14door: AlleyDoor '14+e -' 'dörr till rum 14'
    "Dörren är märkt med <q>14.</q> "
;

+ room15door: AlleyDoor '15+e -' 'dörr till rum 15'
    "Trädörren är märkt med <q>15.</q> "
;

+ room16door: AlleyDoor '16+e -' 'dörr till rum 16'
    "Dörren är märkt med <q>16.</q> "
;

+ Graffiti 'udda *kommentarer+na' 'klotter'
    "Det finns inte mycket här; bara ett par udda kommentarer
    klottrade på väggen med små bokstäver: <q>Han är en rolig Gud! Han
    är Solguden! Ra! Ra! Ra!</q> Och: <q>Subtilitet är en krycka.</q> "
;


/* ------------------------------------------------------------------------ */
/*
 *   Alley 4 center
 */
alley4main: AlleyRoom 'Gränd Fyra' 'Gränd Fyra'
    "Detta är mitten av Gränd Fyra, där korridoren vidgas till
    ett rejält loungeområde. De två flyglarna av gränden leder
    österut respektive västerut, och norrut leder en trappa
    nedåt. Ett stort runt bord och några stolar är uppställda här. "

    vocabWords = '4+e fjärde fyra gränd+en'

    down = a4StairsDown
    north asExit(down)
    west = alley4W
    east = alley4E

    roomParts = static (inherited + [alleyNorthWall, alleySouthWall,
                                     alleyEastWall, alleyWestWall])
;

+ Graffiti 'slingrande lövrik+a gecko/geckos/väggmålning+en/ranka+n*rankor+na' 'klotter'
    "En väggmålning av slingrande, lövrika rankor täcker en vägg. Bland
    rankorna finns ett antal väl gömda geckos. "
;

+ a4StairsDown: StairwayDown -> a3StairsUp
    'trappa+n/trappuppgång+en*trappor+na' 'trappuppgång'
    "Trapporna leder ner till Gränd Tre. "
;

+ EntryPortal ->(location.west)
    'väst+ra v (4) (fyra) smal+a hall+en/korridor+en/flygel+n/(gränd+en)' 'västra flygeln'
    "Den smala korridoren leder västerut. "
;
+ EntryPortal ->(location.east)
    'öst+ra ö (4) (fyra) smal+a hall+en/korridor+en/flygel+n/(gränd+en)' 'östra flygeln'
    "Den smala korridoren leder österut. "
;

+ a4mChair: CustomImmovable, MultiChair
    'upptagen upptagna tom+ma enk:el+la ek+stol+en/köksstol+en*stolar+na köksstolar+na' 'ekstol'
    "Det finns flera av de enkla köksstolarna i ek. De flesta
    av dem är upptagna; några få är tomma. "

    cannotTakeMsg = 'Du har inget behov av att bära omkring på någon av stolarna. '

    /* because we represent many objects, customize the status messages */
    actorInName = 'på en av ekstolarna'
;

+ a4Table: Heavy, Surface
    'stor:t+a run:t+da ekträ ek|trä|bord+et/köksträ|bord+et/trä|bord+et' 'runt bord'
    "Det är den typ av bord man skulle hitta i ett kök. Det är runt
    och ser ut att vara gjort av ek. "

    iobjFor(PutOn)
    {
        action() { "Du är rädd att du skulle störa den noggranna organiseringen
            av papper på bordet om du lade till något. "; }
    }
;

/* a class for the immovable items on the table, with a custom message */
class A4TableImmovable: CustomImmovable
    cannotTakeMsg = 'Allt är noggrant utlagt; du vill inte
        störa det. '
;

/* a class for the Turbo Power Animals action figures */
class TurboPowerAnimal: Thing
    /* don't list these when on the table */
    isListed = (!isIn(a4Table))

    moveInto(obj)
    {
        /* don't allow these to be taken when on the alley 4 table */
        if (isIn(a4Table))
        {
            "Actionfiguren är viktig för stapeln; du vill inte
            störa. ";
            exit;
        }

        /* otherwise, do the normal stuff */
        inherited(obj);
    }
;

++ a4Materials: A4TableImmovable
    'hög+en papper:et^s+hög+en/material+et*material+ena papper+ena' 'hög med papper'
    "Bordet är fullt med papper. En stor ritning över
    campus ligger i mitten av bordet, och runt omkring den
    finns kuvert och indexkort. Kuverten och korten verkar
    vara noggrant arrangerade. "

    /* 
     *   use a specialDesc in our container's description only (not in the
     *   room description, since we mention the materials as part of the
     *   students' specialDesc instead)
     */
    specialDesc = "En hög med papper är utspridd på bordet. "
    useSpecialDescInRoom(room) { return nil; }
;

++ a4Envelopes: A4TableImmovable, Readable
    'index+kort+en/kuvert+en/handstil+en'
    'kuvert och kort'
    "Några av kuverten har öppnats, andra är förseglade.
    De flesta indexkorten är täckta med handskrift. "

    isPlural = true

    readDesc = "Du skannar igenom några av indexkorten, men ingen av
       dem är särskilt meningsfull för dig. "

    dobjFor(Open)
    {
        verify() { }
        action() { "Du vill inte störa något. "; }
    }
    dobjFor(Close) asDobjFor(Open)
    dobjFor(LookIn) asDobjFor(Open)
    dobjFor(Search) asDobjFor(Open)
;

++ A4TableImmovable
    'stor+a campus+et ritning+en/karta+n/kontur+en/(byggnad+en)/(campus+et)*konturer+na (byggnader+na)'
    'ritning'
    "Kartan visar konturerna av campusbyggnaderna, tryckt
    i ljusblått bläck på ett affischstort papper. Det ser
    nästan ut som en stridsplaneringskartan: den är markerad med många
    linjer, kruseduller, cirklar och andra anteckningar, och små
    markörer är utspridda över kartan. "

    dobjFor(ConsultAbout)
    {
        verify() { logicalRank(50, 'endast dekoration'); }
        action() { "Det är för trångt här, och bordet är för
            belamrat, för att få en bra titt på kartan. "; }
    }
;
+++ a4Map: Fixture
    'karta+ns annan kart|anteckning+en/markering+en/linje+n/pil+en/krumelur+en/cirkel+n
    *markeringar+na anteckningar+na kartanteckningar+na linjer+na pilar+na krumelurer+na cirklar+na'
    'kartanteckningar'
    "Det är inte uppenbart vad markeringarna betyder. Några av byggnaderna
    är inringade, andra är överkryssade; på andra ställen är linjer eller
    pilar ritade mellan byggnader. "

    isPlural = true
;
+++ A4TableImmovable
    '(karta+ns) li:ten+lla plast+iga pjäs+en/markör+en*kartmarkörer+na markörer+na pjäser+na' 'kartmarkörer'
    "Markörerna är mestadels små plastpjäser, förmodligen från ett brädspel.
    De är placerade runt kartan för att markera vissa platser,
    även om det inte är uppenbart vad de indikerar. "

    isPlural = true
;

+ Person 'student+en*studenter+na' 'studenter'
    "Några sitter vid bordet, andra står nära det.
    De arbetar alla med materialet som är utspritt på bordet. "

    specialDesc = "Ungefär ett halvdussin studenter<<
          jay.isIn(alley4main) ? ", inklusive Jay, " : ""
          >> sitter eller står runt bordet och arbetar med
        en hög papper utspridda över ytan. "

    isPlural = true
;

++ AskTellShowTopic
    [stackTopic, a4Materials, a4Envelopes, a4Map, turboTopic]
    "<q>Vilken stapel arbetar ni med?</q> frågar du.
    <.p>En av dem pekar ner i korridoren västerut. <q>
    Turbo Power Animals-stapeln. Du bör läsa skylten nere i
    korridoren om du vill hjälpa till.</q> "
;

+++ AltTopic, StopEventList
    ['<q>Arbetar ni med Turbo Power Animals-stapeln?</q>
    frågar du.
    <.p>En av dem vänder sig om och gör en elaborerad serie
    ryckiga armgester, först korsar han armarna, sedan håller han en arm
    rakt upp och den andra åt sidan, sedan gör han en neddragande
    rörelse med båda nävarna, och så vidare. <q>Turbo power Caltech
    adjunkten är redo!</q> säger han. De andra ler och skakar på
    huvudet åt uppvisningen. Han avslutar slutligen hälsningen och
    återvänder till bordet. ',

     '<q>Hur fungerar den här stapeln?</q> frågar du.
     <.p>En av studenterna tittar upp från papperen. <q>Vi har
     dessa ledtrådar,</q> säger han och pekar på kuverten, <q>som antyder
     var de fem Power Animals är gömda. Ledtrådarna är alla
     ganska oklara, så vi försöker pussla ihop bitarna.</q> ',

     '<q>Hur går det med stapeln?</q>
     <.p>Ett par av studenterna tittar bara upp på dig och rycker på axlarna. ']

    isActive = gRevealed('tpa-stack')
;

++ AskTellTopic @jayTopic
    topicResponse()
    {
        "<q>Ursäkta,</q> säger du, <q>men jag letar efter Jay
        Santoshnimoorthy.</q>
        <.p>Alla tittar på en av studenterna, som tittar upp
        på dig. <q>Jag är Jay,</q> säger han.
        <.p>Med alohaskjortan, hans kroppsbyggnad och hans långa hår,
        ser Jay ut som en surfare. ";

        /* bring Jay into the game, and drop his Unthing */
        jay.makePresent();
        unJay.moveInto(nil);

        /* transition jay directly to conversation */
        jay.autoEnterConv();
    }
;
+++ AltTopic
    "<q>Har någon sett Jay Santoshnimoorthy?</q> frågar du.
    <.p>En av studenterna tittar upp. <q>Han gick över till Bridge,
    tror jag, följandes en av ledtrådarna,</q> säger hon. <q>Han borde
    vara tillbaka om en liten stund.</q> "

    /* jay won't show up until we at least start on stamer's stack */
    isActive = (labKey.isIn(erin))
;
+++ AltTopic
    "<q>Är Jay fortfarande här?</q> frågar du.
    <.p>Jay lutar sig tillbaka från bordet. <q>Här är jag,</q> säger han.
    <<jay.autoEnterConv>> "

    /* use this one when jay is already here */
    isActive = (jay.isIn(alley4main))
;
+++ AltTopic
    "<q>Är Jay fortfarande här?</q> frågar du.
    <.p>En av studenterna pekar på honom. Han sitter fortfarande där
    och läser tidskriften du gav honom. "
    
    isActive = (jay.curState == jayReading)
;

++ AskTellTopic [scottTopic, posGame]
    "<q>Har någon sett Scott?</q> frågar du.
    <.p>En av studenterna svarar utan att titta upp från
    bordet. <q>Jag såg honom nere i Gränd Tre,</q> säger hon. "
;
++ AskForTopic @scottTopic
    topicResponse() { replaceAction(AskAbout, gDobj, scottTopic); }
;

++ DefaultAnyTopic, ShuffledEventList
    ['Du försöker få någons uppmärksamhet, men de är alla för
    involverade i andra samtal. ',
     'Alla verkar för fokuserade på stapeln för att svara. ',
     'De är förmodligen mest intresserade av stapeln just nu. ']
;

/* ------------------------------------------------------------------------ */
/*
 *   Alley 4 west
 */
alley4W: AlleyRoom 'Gränd Fyra Väst' 'västra änden av Gränd Fyra'
    "Den smala korridoren leder österut och slutar här.
    Dörren till rum 20 är söderut, 21 norrut och
    22 västerut. "

    vocabWords = '4+e gränd+en fyra fjärde'

    south = room20door
    north = room21door
    west = room22door
    east = alley4main

    roomParts = static (inherited + [alleyNorthWall, alleySouthWall,
                                     alleyWestWall])
;

+ room20door: AlleyDoor '20+e -' 'dörr till rum 20'
    "Dörren är märkt med <q>20.</q> "
;

+ room21door: AlleyDoor '21+e -' 'dörr till rum 21'
    "Numret 21 är målat på dörren. "
;

+ room22door: StackDoor '22+e -' 'dörr till rum 22'
    "Trädörren är numrerad <q>22.</q> "
;

++ Fixture
    'färgglad+a illustrerad+a turbo power
    skylt+en/teckning+en/djur+en/illustration+en*teckningar+na djuren+a illustrationer+na'
    'illustrerad skylt'
    "Den stora skylten är illustrerad med färgglada teckningar av
    karaktärer från Turbo Power Animals, den populära japanska
    tecknade serien/videospelserien/actionfigursamlingen/medieimperiet.
    Stora, feta, actionfyllda bokstäver flödar runt
    illustrationerna:
    <.p>
    <.blockquote>
    <font face='tads-sans'><b><i>
    <center>Åkallande av Turbo Power Animals!</center>
    <.p>Utryckningslarm! Den ökände GENERAL XI har kidnappat
    de fem Power Friends i en komplott för att orsaka en miljö-
    katastrof!
    <.p>Vetande att endast Power Animals kan stoppa hans
    onda plan att förorena PASADENA-HAVET med det dödliga
    INDUSTRIA-VIRUSET, har den ökände Generalen lockat
    Turbo Friends till CALTECH under förevändningen av en Goda Gärningar-
    konvention. Omedvetna om faran gick Power Friends till
    sina välgörenhetsseminarier, bara för att finna den onde Generalens
    dumma men muskulösa GRODFISK-ARMÉ väntande. Turbo Animals
    kämpade tappert med de senaste stridsteknikerna, såsom
    tvåarms-korsad-flip och höger-armbågs-led-knäck, men
    Grodfiskarna var för många till antalet och hindrade
    Power Friends från att bilda TURBO POWER COMBINE GIANT ANIMAL!
    <.p>Turbo Power Animals behöver DIN hjälp! Med hjälp av
    dina vänner måste du bilda CALTECH TURBO ADJUNCT. Du
    måste hitta var General Xi håller var och en av de fem Turbo
    Power Animals fångna, och rädda dem alla. Endast när alla fem är
    räddade kan de bilda TURBO POWER COMBINE GIANT ANIMAL, och,
    med din hjälp, konfrontera General Xi i strid för att besegra hans
    onda plan!
    <.p>Men det kommer inte att bli lätt! General Xi är mycket listig, och han
    har bara lämnat ledtrådarna i kuverten nedan. Dessutom
    har han skyddat många av ledtrådarna med tidslås, så de
    kan öppnas endast vid den angivna timmen.
    </i></b></font>
    <./blockquote>
    Skylten fortsätter med några ytterligare regler för stapeln;
    det ser ut som en skattjakt-typ av stapel. <<extraComment>>
    <.reveal tpa-stack> "

    specialDesc = "En färgglad, illustrerad skylt är uppsatt på
        dörren till rum 22. "

    extraComment()
    {
        if (commentCount++ == 0)
            "Du ser inte kuverten som skylten nämner;
            förmodligen är det vad som finns på bordet nere i korridoren. ";
    }
    commentCount = 0
;

+ Graffiti
    'lovecraftiansk+a droppande klott:er+ret/skräck+en/monst:er+ret/öga+t/ektoplasma*tentakler+na ögon ögonen+a tänder+na' 
    'klotter'
    "En teckning av ett Lovecraftianskt-liknande monster dominerar en vägg:
    tentakler, dussintals ögon, tänder droppande av ektoplasma. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Alley 4 east
 */
alley4E: AlleyRoom 'Gränd Fyra Öst' 'östra änden av Gränd Fyra'
    "Detta är en smal del av korridoren, som fortsätter västerut och
    slutar här i öster. En dörr numrerad 18 är söderut,
    och dörren till rum 19 är norrut. I nordöst leder en
    dörr som ser ut som en vanlig rumsdörr in till
    husets bibliotek. "

    vocabWords = '4+e gränd+en fyra fjärde'

    north = room19door
    south = room18door
    northeast = a4LibDoor
    west = alley4main

    roomParts = static (inherited + [alleyNorthWall, alleySouthWall,
                                     alleyEastWall])
;

+ room18door: AlleyDoor '18+e -' 'dörr till rum 18'
    "Dörren är märkt med <q>18.</q> "
;

+ room19door: AlleyDoor '19+e -' 'dörr till rum 19'
    "Numret 19 är målat på dörren. "
;

+ Graffiti 'lång+t invecklad+e matte+skämt+et li:ten+lla pytteli:ten+lla berättelse+n/bokstäver+na' 'klotter'
    "En lång, invecklad berättelse är skriven på väggen med pyttesmå bokstäver.
    Det är något slags utdraget matteskämt. "
;

+ a4LibDoor: Door 'biblioteksdörr+en' 'biblioteksdörr'
    "Den ser ut som dörren till vilket studentrum som helst i huset, men
    <q>Bibliotek</q> är målat på dörren istället för ett rumsnummer. "

    isOpen = true
;

/* ------------------------------------------------------------------------ */
/*
 *   The Dabney library 
 */
dabneyLib: Room 'Bibliotek' 'husets bibliotek' 'husets bibliotek'
    "Detta rum var förmodligen en gång ett vanligt dubbelrum, men det omvandlades
    för länge sedan till husets bibliotek. Det är lite av en röra;
    böcker är slumpmässigt staplade inte bara på hyllorna längs väggarna,
    utan också på golvet, det stora bordet och de två sofforna.
    <.p>Ett stort fönster med gångjärn i norr har utsikt över
    innergården. Rummet har två dörrar som leder ut, en mot
    sydöst och en mot sydväst. "

    vocabWords = 'dabney hus+et bibliotek+et'

    southeast = libA6Door
    southwest = libA4Door

    /* "out" is ambiguous here */
    out: AskConnector {
        /* don't show this as an obvious direction; just show se/sw */
        isConnectorApparent(origin, actor) { return nil; }

        /* "out" could mean going through either door */
        travelAction = GoThroughAction
        travelObjs = [libA6Door, libA4Door]

        /* customize the parser prompts when we go this way */
        askDisambig(targetActor, promptTxt, curMatchList, fullMatchList,
                    requiredNum, askingAgain, dist)
            { "Vilken väg vill du gå, sydöst eller sydväst? "; }
        askMissingObject(targetActor, action, which)
            { "Vilken väg vill du gå, sydöst eller sydväst? "; }
    }
;

+ Graffiti 'klott:er+ret/teckning+en/citat+et/kommentar+en*teckningar+na citaten' 'klotter'
    "Det finns massor av små teckningar och citat på väggarna.
    Din favorit är en liten kommentar nära den nordöstra
    dörren: <q>Biblioteket: Där <b>VAD SOM HELST</b> kan hända.
    <font size=-1>(Men troligen inte kommer att göra det.)</font></q> "
;

+ libA4Door: Door ->a4LibDoor
    'gränd+en fyra fjärde 4+e sv sydväst+ra dörr+en*dörrar+na' 'sydvästra dörren'
    "Dörren leder ut mot sydväst. "
;

+ libA6Door: Door ->a6LibDoor
    'gränd+en sjätte sex 6+e sö sydöst+ra dörr+en*dörrar+na' 'sydöstra dörren'
    "Dörren leder ut mot sydöst. "
;

+ libBookPiles: CustomImmovable
    'bibliotek+et slit:en+na välanvänd+a gam:mal+la science fiction sf sci-fi 
    serie+n pocket|bok+en/lärobok+en/manual+en/
    bok+en*böcker+na läroböcker+na manualer+na pocketböcker+na instruktioner+na'
    'högar av böcker'
    "De flesta böckerna verkar vara välanvända science fiction-pocketböcker, men
    det finns också gamla läroböcker, serietidningar, telefonkataloger, instruktions-
    manualer och vem vet vad annat blandat. De är staplade
    överallt, praktiskt taget i knädjupa högar på vissa ställen. "

    isPlural = true

    cannotTakeMsg = 'Du kan uppenbarligen inte ta dem alla, och det skulle
        ta för lång tid att gå igenom dem efter något intressant. '

    lookInDesc = "Du rotar lite i böckerna, men du hittar
        inget särskilt intressant. "
    dobjFor(Search) asDobjFor(LookIn)
    dobjFor(LookUnder) asDobjFor(LookIn)
    dobjFor(LookThrough) asDobjFor(LookIn)
    dobjFor(LookBehind) asDobjFor(LookIn)

    dobjFor(ConsultAbout)
    {
        verify() { }
        action() { "Böckerna är bara slumpmässigt staplade, så det finns
            ingen chans att hitta något specifikt. "; }
    }

    /* we're nominally on anything that's a LibUnderBooks */
    isNominallyIn(obj) { return inherited(obj) || obj.ofKind(LibUnderBooks); }
;

/* a class for one of our items buried under books */
class LibUnderBooks: object
    dobjFor(Search) remapTo(Search, libBookPiles)
    lookInDesc = "{Ref dobj/han} {är} begravd under högar av böcker. "
    iobjFor(PutOn)
    {
        verify() { }
        action() { "Det finns för många böcker staplade på {ref iobj/honom};
            allt du lägger till skulle förmodligen försvinna i högarna. "; }
    }
;

+ LibUnderBooks, Fixture 'inbyggd+a hylla+n*hyllor+na' 'hyllor'
    "De inbyggda hyllorna kantar väggarna. Böcker är staplade på
    hyllorna horisontellt, vertikalt, diagonalt och på alla sätt
    däremellan. "
    isPlural = true
;

+ LibUnderBooks, Fixture, Chair 'soffa+n/divan+en*soffor+na divaner+na' 'soffor'
    "Till och med sofforna är begravda under högar av böcker, vilket inte lämnar
    någon plats där du enkelt kan sätta dig ner. "
    isPlural = true

    dobjFor(SitOn)
    {
        check()
        {
            "Det finns för många böcker; det finns inget utrymme kvar
            att sitta på. ";
            exit;
        }
    }
    dobjFor(LieOn) asDobjFor(SitOn)
    dobjFor(StandOn) asDobjFor(SitOn)
;

+ LibUnderBooks, Fixture 'stor:t+a bord+et' 'stort bord'
    "Själva bordet är inte särskilt synligt; allt du kan se är
    böckerna som är staplade ovanpå. "
;

+ Openable, Fixture 'stor:t+a gångjärn+et fönst:er+ret' 'fönster med gångjärn'
    "Fönstret har utsikt över innergården och modellberget. "

    dobjFor(LookThrough) remapTo(Examine, libCourtyard)

    initiallyOpen = nil
    dobjFor(Open)
    {
        check()
        {
            "Fönstret verkar ha fastnat. Det målades förmodligen
            fast vid den senaste renoveringen. ";
            exit;
        }
    }
;

+ libCourtyard: Distant
    'dabney hus+et hovse papier-mache papier-mâché
    papier-mâché innergård+en/berg+et/topp+en' 'innergård'
    "Fönstret har utsikt över innergården från en våning upp. 
    Modellberget i innergården reser sig lite högre än
    denna nivå. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Alley 5 main 
 */
alley5main: AlleyRoom 'Gränd Fem Entré' 'entrén till Gränd Fem'
    "Detta är en märkligt vinklad korsning av korridorer vid
    ingången till Gränd Fem. Söderut finns en trappa som leder
    uppåt, och mitt emot trappan finns utgången till innergården
    norrut. En korridor leder västerut, och en annan svänger
    runt ett hörn och leder sydöst. "

    vocabWords = '5 gränd+en fem+te entré+n/ingång+en/korridor+en/hall+en'

    north = dabneyCourtyard
    out asExit(north)
    northwest asExit(north)

    up = a5StairsUp
    south asExit(up)
    west = alley5M
    southeast = alley5N

    roomParts = static (inherited
                        + [alleyNorthWall, alleySouthWall, alleyEastWall])
;

+ ExitPortal ->(location.out) 'innergård+en/utgång+en' 'innergård'
    "Innergården ligger norrut. "
;

+ Graffiti 'matte matematisk+a formel+n' 'klotter'
    "Det är en matematisk formel: e upphöjt till pi i är lika med minus ett.
    Det förhållandet mellan dessa tre speciella tal är alltid
    häpnadsväckande när man först lär sig det; tydligen var någon
    tillräckligt förundrad för att skriva det på väggen. "
;

+ a5StairsUp: StairwayUp ->a6StairsDown
    'trappa+n/trappuppgång+en*trappor+na' 'trappuppgång'
    "Trapporna leder upp till Gränd Sex. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Alley 5 north
 */
alley5N: AlleyRoom 'Gränd Fem Nord' 'norra änden av Gränd Fem'
    "Detta är den norra änden av en nord/syd-sektion av Gränd Fem.
    Dörren till rum 25 är på östra sidan av korridoren, och mitt
    emot den på västra sidan är dörren till rum 26. Korridoren
    fortsätter söderut och svänger runt ett hörn mot nordväst. "

    vocabWords = '5 gränd+en fem+te korridor+en/hall+en'

    northwest = alley5main
    south = alley5S
    east = room25door
    west = room26door

    roomParts = static (inherited
                        + [alleyEastWall, alleyWestWall, alleySouthWall])
;

+ room25door: AlleyDoor '25+e -' 'dörr till rum 25'
    "Numret 25 är målat på dörren. "
;

+ room26door: AlleyDoor '26+e -' 'dörr till rum 26'
    "Trädörren har numret 26 målat på sig. "
;

+ Graffiti 'bit+en dikt+en' 'klotter'
    "Det är en liten bit av en dikt:
    \b\tDet spelar ingen roll hur smal porten är,
    \n\thur full av straff rullen är
    \n\tJag är herre över mitt öde:
    \n\tJag är kapten över min själ.
    \n\tNu, angående den där tentan... "
;

/* we can hear the music from down the hall */
+ Noise 'hög+a honolulu 10-4 tema+t låt+en/musik+en' 'hög musik'
    aName = 'en låt'
    
    /* LISTEN TO ALLEY */
    sourceDesc = (hereWithSource)

    /* LISTEN TO MUSIC */
    descWithSource = "Den kommer från korridoren söderut.
        Den är ganska hög även härifrån; du känner igen den som
        temat från <i>Honolulu 10-4</i>, som spelas i en loop. "

    hereWithSource = "Du kan höra musik från korridoren söderut. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Alley 5 south 
 */
alley5S: AlleyRoom 'Gränd Fem Syd' 'södra änden av Gränd Fem'
    "Detta är den södra änden av Gränd Fem. På östra sidan av
    korridoren finns en dörr numrerad 23, och mitt emot korridoren västerut
    är dörren till rum 24. Korridoren slutar här och sträcker sig
    norrut. "

    vocabWords = '5 gränd+en fem+te korridor+en/hall+en'

    north = alley5N
    east = room23door
    west = room24door

    roomParts = static (inherited
                        + [alleyEastWall, alleyWestWall, alleyNorthWall])
;

+ room23door: AlleyDoor '23+e -' 'dörr till rum 23'
    "Numret 23 är målat på dörren. "
;

+ room24door: StackDoor '24+e -' 'dörr till rum 24'
    "Trädörren har numret 24 målat på sig. "
;

++ CustomImmovable, Readable
    'stor+a honolulu 10-4 reklam+en rick palm hula
    affisch+en/burl/träd+et/hav+et/dansare+n*dansare dansarna träden+a'
    '<i>Honolulu 10-4</i> affisch'
    "Det är en reklamaffisch för TV-serien <i>Honolulu 10-4</i>.
    Den visar stjärnan Rick Burl i en actionpose, med pistolen redo,
    mot en bakgrund av palmer, hav och huladansare.
    Längst ner, i fånig skripttext, står seriens
    slagord, <i><q>Sätt handbojor på dem, Kiko!</q></i> "
    
    cannotTakeMsg = 'Den är inte din; du bör lämna den där den är. '
;

++ CustomImmovable, Readable 'blå+a pappersskylt+en' 'blå skylt'
    "Skylten är handtextad på blått papper:
    <.p><.blockquote>
    Jacobs Honolulu 10-4 Surfin' Marbles-stapel
    <.p>Detta är din chans till ett sista försök av mitt Surfin' Marbles
    spel. Allt du behöver göra för att besegra min stapel är att lösa den
    fullständigt---du behöver bara få en kula till varje hörn. Du har
    sett mig lösa det, så du vet att det är möjligt. För att hjälpa dig
    komma i stämning har jag ställt in min stereo att spela <q>Honolulu 10-4</q>
    temat kontinuerligt hela dagen. Jag är övertygad om att du kommer att njuta av det!
    <./blockquote> "

    specialDesc = "Dörren till rum 24 är dekorerad med en stor
        reklamaffisch, och under affischen finns en blå pappersskylt. "
    
    cannotTakeMsg = 'Du bör lämna den där den är. '
;

+ Person 'student+en/grupp+en*studenter+na' 'grupp av studenter'
    "Studenterna är samlade runt ett träkulspel.
    En av dem spelar spelet och försöker styra flera
    kulor genom labyrinten på spelplanen genom att vrida på handtag som
    lutar spelplanen. Resten tittar på. De flesta av dem
    verkar bära öronproppar eller hörlurar. "

    specialDesc = "En grupp studenter är samlade runt ett träkulespel
        och tittar på när en av dem spelar. "
;
++ InitiallyWorn
    'hörsel+n öronpropp+en/hörlur+en/skydd+et*öronproppar+na hörlurar+na' 'öronproppar'
    "De flesta av studenterna bär någon form av hörselskydd.
    Några har öronproppar, andra bär hörlurar. "

    isListedInInventory = nil
    isPlural = true
;

++ DefaultAnyTopic, ShuffledEventList
    ['Du knackar en av studenterna på axeln för att få hennes
    uppmärksamhet. Hon tittar upp på dig, men innan du hinner avsluta
    din mening formar hon med läpparna <q>VA?</q> Du inser att hon inte kan
    höra dig över musiken bättre än du kan höra henne. ',

     'Du försöker få någons uppmärksamhet, men musiken är
     för hög; ingen verkar höra ett ord du säger. ',

     'Ingen verkar kunna höra något du säger över musiken. ']
;

+ CustomImmovable
    'trä (honolulu) (10-4) träkulspel+et kul-labyrint+en labyrint+en
    surfin surfin\' surfing kulspel+et/spel+et/låda+n*kulor+na'
    'kulspel'

    "Det är en trälåda som är ungefär 60 cm i kvadrat och 15 cm hög.
    Spelplanen har ett nätverk av små kanter som bildar en labyrint
    för en uppsättning kulor.  Spelplanen lutar; spelaren styr
    lutningen genom att vrida på ett par handtag på sidan av spelet.
    Målet är att styra varje kula till ett annat hörn.

    <.p>Spelet har ett <i>Honolulu 10-4</i> tema. En illustration
    av karaktärerna från serien är målad på spelplanen,
    även om den är något sliten efter lång användning. "
    
    cannotTakeMsg = 'Studenterna skulle definitivt inte vilja att du
        springer iväg med huvudattraktionen i stapeln medan de
        fortfarande arbetar med den. '

    dobjFor(Play)
    {
        verify() { }
        action() { playScript.doScript(); }
    }
    dobjFor(Use) asDobjFor(Play)

    playScript: StopEventList { [
        'Du tränger dig in i gruppen av studenter och väntar på
        en öppning. Studenten som har spelat avslutar
        sitt försök och låter dig ta över. Du placerar kulorna
        i startpositionen och börjar vrida på handtagen.
        Det är mycket svårare än det ser ut, och du förlorar nästan
        omedelbart två av kulorna i <q>Honolulu
        Fängelse</q>-fällan. Du reser dig upp och låter en av studenterna
        försöka. Det här spelet kräver uppenbarligen mycket övning. ',

        'Du tränger dig in i gruppen och gör ett nytt försök med
        spelet. Du ställer upp kulorna och börjar arbeta med handtagen.
        Den här gången går det lite bättre; du lyckas få en av
        kulorna till sitt hörn. Men när du börjar arbeta med
        nästa hörn, rullar den första kulan ut ur sitt hörn
        och hamnar i <q>Hajattack</q>-fällan. Du låter någon
        annan ta en ny tur. ',

        'Du tränger dig in för ett nytt försök. Du får den första kulan
        till sitt hörn ganska snabbt den här gången, och du lyckas
        backa bort den från Hajfällan precis när den är på väg
        att falla i. Men medan du gör det faller en tredje kula
        i <q>Tiki Tabu</q>-fällan. Du lämnar över
        spelet till nästa spelare. ',

        'Du känner att du borde bli bra på spelet efter
        all övning du har haft, så du ger det ett nytt försök.
        Du känner att det går bra, men sedan faller en kula
        i Fängelsefällan samtidigt som en annan faller
        i Hajfällan. Du skakar på huvudet och låter någon
        annan ta en tur. ',

        'Du ger spelet ett nytt försök, men den dunkande musiken
        börjar verkligen påverka dig; du kan bara inte koncentrera dig.
        Du låter någon annan ta en tur. ']
    }
;
++ Component 'slit:en+na (spelplan+en) (honolulu) (10-4)
    illustration+en/karaktär+en/karaktärer+na/spelplan+en'
    'spelplanillustration'
    "Spelplanen är illustrerad med karaktärer från
    <i>Honolulu 10-4</i> TV-serien. Illustrationen är något
    sliten efter att kulor har rullat över den. "
;
++ Component
    'stål stål|kula+n/lag:er+ret/kullag:er+ret*/kulor+na stålkulor+na'
    'kulor'
    "Kulorna ser ut att vara gjorda av stål; de är förmodligen
    bara kullager. "
    isPlural = true
;
++ Component 'handtag+et' 'handtag'
    "Du kan kontrollera lutningen på spelplanen genom att vrida på
    handtagen. "

    /* TURN HANDLES -> PLAY GAME */
    dobjFor(Turn) remapTo(Play, location)
;

+ xyzzyGraffiti: Graffiti 'konstig+a slingrig+a handstil+en' 'klotter'
    "Ordet <q>xyzzy</q> är skrivet på väggen med konstig, slingrig
    handstil. "
;

+ Noise 'honolulu 10-4 tema låt+en/musik+en' '<i>Honolulu 10-4</i> tema'
    aName = 'en temalåt'

    /* LISTEN TO ALLEY shows this; just show our normal emanation */
    sourceDesc = (hereWithSource.doScript())

    /* LISTEN TO MUSIC shows this message */
    descWithSource = "Det är den otroligt fängslande och repetitiva
        temamusiken till <i>Honolulu 10-4</i>, som spelas på
        hög volym och i en till synes ändlös loop. "

    /* 
     *   this is used in generic LISTEN, in X ALLEY, and in our background
     *   daemon that runs as long as we're within hearing range 
     */
    hereWithSource: ShuffledEventList { [
        'Drivande, snabb musik dånar genom korridoren med 
        en nästan öronbedövande volym. Du känner omedelbart igen den
        som den otroligt medryckande temamusiken från <i>Honolulu 10-4</i>,
        den populära TV-polisserien från slutet av 60-talet. ',

        '<i>Honolulu 10-4</i> musiken spelar genom sitt brassiga 
        crescendo. Du tror att den är på väg att sluta, men nästan
        sömlöst övergår den till den rullande slagverksektionen och trumpet-
        ens skallande toner i låtens inledning, och allting börjar om igen
        från början. ',

        '<i>Honolulu 10-4</i>-temamusiken fortsätter att spela, uppenbarligen
        i en tight loop. Du är säker på att du kommer att ha den här låten
        fast i huvudet hela dagen. ']

        ['TONARTSBYTE! <i>Honolulu 10-4</i>-musiken skiftar subtilt
        tonart och upprepar den medryckande melodin ännu en gång. ',

        '<i>Honolulu 10-4</i>-musiken fortsätter att dundra genom
        gränden. ',

        'TRUMVIRVEL! Temamusiken börjar ännu en cykel. ',

        'Den öronbedövande temamusiken fortsätter att ansätta gränden. ',

        'TRUMPETSTÖT! Temamusiken når ännu ett klimaktiskt
        crescendo och loopar tillbaka till början. ']
    }

    /* remind about the music pretty frequently */
    displaySchedule = [1, 2, 2, 3]
;

/* better define a 'xyzzy' verb, now that we've mentioned the word... */
DefineIAction(Xyzzy)
    execAction()
    {
        if (!dabneyBreezeway.seen)
        {
            "Det skulle vara fantastiskt om ett magiskt ord kunde föra dig bort,
            men ingenting verkar hända här. ";
        }
        else if (xyzzyGraffiti.described)
        {
            if (gActor.isIn(xyzzyGraffiti.location))
                "Du säger det magiska ordet högt, men tyvärr händer ingenting
                här. ";
            else
                "Du säger det magiska ordet högt, men tyvärr blir du inte
                magiskt transporterad till Gränd Fem. ";
        }
        else
            "Du tycks minnas ett klotter med den innebörden någonstans
            i Gränd Fem. ";
    }
;
VerbRule(Xyzzy) 'xyzzy' : XyzzyAction
    verbPhrase = 'xyzzy/xyzzying'
;

/* ------------------------------------------------------------------------ */
/*
 *   Alley 5 middle
 */
alley5M: AlleyRoom 'Mitten av Gränd Fem' 'mitten av Gränd Fem'
    "Detta är mitten av en öst/väst-sektion av Gränd Fem.
    En dörr på norra sidan är numrerad 31, och mitt emot på
    södra sidan är dörren till rum 27. "

    east = alley5main
    west = alley5W
    north = room31door
    south = room27door

    vocabWords = '5+e gränd+en fem+te mitten hall+en/korridor+en'
    
    roomParts = static (inherited + [alleyNorthWall, alleySouthWall])
;

+ room27door: AlleyDoor '27+e -' 'dörr till rum 27'
    "Numret 27 är målat på dörren. "
;

+ room31door: AlleyDoor '31+e -' 'dörr till rum 31'
    "Trädörren har numret 31 målat på sig. "
;

+ Graffiti 'kinesiskt kinesisk+a tecken/tecknet/kalligrafi+n/tecknen+a/klottret' 'klotter'
    "Det finns en passage av vad som ser ut som kinesisk kalligrafi. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Alley 5 west 
 */
alley5W: AlleyRoom 'Gränd Fem Väst' 'västra änden av Gränd Fem'
    "Detta är den västra änden av Gränd Fem; korridoren fortsätter
    österut. Västerut är dörren till rum 29. En
    dörr numrerad 28 är på södra sidan av korridoren, och mitt
    emot på norra sidan är dörren till rum 30. "

    east = alley5M
    south = room28door
    west = room29door
    north = room30door

    vocabWords = '5+e gränd+en fem+te/hall+en/korridor+en'
    
    roomParts = static (inherited +
                        [alleyNorthWall, alleySouthWall, alleyWestWall])
;

+ room28door: AlleyDoor '28+e -' 'dörr till rum 28'
    "Numret 28 är målat på dörren. "
;

+ room29door: AlleyDoor '29+e -' 'dörr till rum 29'
    "Trädörren har numret 29 målat på sig. "
;

+ room30door: AlleyDoor '30+e -' 'dörr till rum 30'
    "Det är en trädörr märkt med numret 30. "
;

+ Graffiti 'tecknad+e serie+n figur+en/pojke+n/tiger+n*figurer+na' 'klotter'
    "En mycket fin återgivning av några seriefigurer
    är ritad här. Det är en pojke och hans gosedjurstiger, från en
    serie från tidigare år. "
;


/* ------------------------------------------------------------------------ */
/*
 *   Alley 6 center 
 */
alley6main: AlleyRoom 'Mitten av Gränd Sex' 'mitten av Gränd Sex'
    "Detta är mitten av Gränd Sex. En trappa söderut
    leder nedåt. Korridoren fortsätter österut och västerut. "

    vocabWords = '6+e gränd+en sex sjätte hall+en/korridor+en'

    down = a6StairsDown
    south asExit(down)
    east = alley6E
    west = alley6W

    roomParts = static (inherited + [alleyNorthWall, alleySouthWall])
;

+ a6StairsDown: StairwayDown 'trappa+n/trappuppgång+en*trappor+na' 'trappuppgång'
    "Trapporna leder ner till Gränd Fem. "
;

+ Graffiti 'escher-liknande teckning+en/orm+en' 'klotter'
    "En Escher-liknande teckning av en orm som äter sin egen svans
    finns på väggen. "
;    

/* ------------------------------------------------------------------------ */
/*
 *   Alley 6 west
 */
alley6W: AlleyRoom 'Gränd Sex Väst' 'västra änden av Gränd Sex'
    "Detta är den västra änden av Gränd Sex. Mot nordväst finns
    en dörr som leder in till husets bibliotek. Dörren till rum
    33 är mot sydväst, och rum 34 är mot sydöst.
    Korridoren fortsätter österut. "

    vocabWords = '6+e gränd+en sex sjätte hall+en/korridor+en'

    northwest = a6LibDoor
    southwest = room33door
    southeast = room34door
    east = alley6main

    roomParts = static (inherited + [alleyNorthWall, alleySouthWall])
;

+ a6LibDoor: Door 'biblioteksdörr+en' 'biblioteksdörr'
    "Den ser ut som dörren till vilket studentrum som helst i huset, men
    <q>Bibliotek</q> är målat på dörren istället för ett rumsnummer. "

    isOpen = true
;

+ room33door: AlleyDoor '33+e -' 'dörr till rum 33'
    "Det är en trädörr märkt med <q>33.</q> "
;

+ room34door: AlleyDoor '34+e -' 'dörr till rum 34'
    "Det är en trädörr märkt med <q>34.</q> "
;

+ Graffiti 'grov+t grova sprayad+e ko+n/kontur+en' 'klotter'
    "En ganska grov kontur av en ko är ritad på väggen
    med sprayfärg. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Alley 6 east 
 */
alley6E: AlleyRoom 'Gränd Sex Öst' 'östra änden av Gränd Sex'
    "Detta är den östra änden av Gränd Sex. Gränden slutar vid
    dörren till rum 35 österut och fortsätter västerut. En annan,
    smalare korridor leder söderut. "

    vocabWords = '6+e gränd+en sex sjätte'

    south = alley6S
    west = alley6main
    east = room35door

    roomParts = static (inherited
                        + [alleyEastWall, alleySouthWall, alleyNorthWall])
;

+ Vaporous 'litet lilla svart+a diffust diffus+a moln+et/bananfluga+n/drosophila*molnen bananflugor+na'
    'moln av bananflugor'
    "<i>Drosophila melanogaster</i>, antar du: genetikerns
    favorit. Flugorna driver lojt omkring i korridoren i ett
    diffust moln. Några av dem rör sig fritt in och ut ur
    plaströret i dörren; ungefär lika många verkar
    komma och gå. "

    specialDesc = "Ett diffust moln av små svarta flugor fyller
        gränden. "
;

+ CustomImmovable 'hög+en frukt:er+hög+en/banan+en/persika+n/apelsin+en' 'frukthög'
    "Flera frukter är staplade på golvet: en banan, en
    apelsin, en persika och flera andra. De har alla delvis
    skalats och kryper av bananflugor. "

    /* show the initial description the first time only */
    isInInitState = (!described)
    initDesc = "Det ser ut som om någon arbetar på stapeln, även om
        de inte är här just nu. <<desc>> "

    cannotTakeMsg = 'Du vill inte ha frukten tillräckligt mycket för att
        konkurrera med flugorna. '

    /* list it as though it were portable */
    isListed = true
    isListedInContents = true

    dobjFor(Eat)
    {
        preCond = []
        verify() { }
        action() { "Du kan inte mena allvar. "; }
    }
;
++ Decoration 'li:ten+lla svart+a bananfluga+n/drosophila*flugor+na bananflugor+na' 'bananflugor'
    "De äter glatt frukten, mikrogram för mikrogram. "

    disambigName = 'flugor på frukten'
    notImportantMsg = 'Flugorna är för många och för små för att
        göra något med. '

    isPlural = true
;

+ room35door: StackDoor '35+e -' 'dörr till rum 35'
    "Det är en dörr målad med nummer 35. "
;

++ CustomImmovable
    '(bananfluga) bioventics modell+en 77 insekts liten elektronisk 
    flugdensitometer/densitometer/instrument+et/enhet+en/tråd+en/trådar+na'

    name = (described ? 'flugdensitometer' : 'liten elektronisk enhet')

    desc = "Det är en liten elektronisk enhet märkt <q>Bioventics
        Modell 77 Insektsdensitometer.</q> Den enda funktionen är en numerisk
        display, som för närvarande visar <q><tt><<dispVal>></tt>.</q>
        Enheten sitter längst ner på dörren, och några trådar
        löper ut från baksidan och under dörren. "
    
    cannotTakeMsg = 'Kablaget förhindrar att enheten kan flyttas. '

    dispVal = (toString(7500 + rand(1000)) + '.' + toString(10 + rand(80))
               + ' /m^3')
;
+++ Component, Readable
    '(flug) densitometer flugdensitometer numerisk+a display+en' 'flugdensitometer display'
    "Displayen visar för närvarande <q><tt><<location.dispVal>></tt>.</q> "
;

++ Fixture 'hård+a vit+a plaströr+et' 'plaströr'
    "Röret är ungefär en tum i diameter och är gjort av hård
    vit plast. Det går genom hålet i dörren där,
    förmodligen, dörrhandtaget brukade sitta. Bananflugor driver lojt
    in och ut ur röret. "

    dobjFor(LookIn) asDobjFor(LookThrough)
    dobjFor(LookThrough) { action() { "Du tittar in i röret, men
        du kan inte se förbi en böj som ser ut att vara precis bakom
        dörren. "; } }

    specialDesc = "En orange skylt är fäst på dörren till rum 35.
        Under skylten sticker ett svart plaströr ut något
        från dörren. På golvet längst ner på dörren finns
        en liten elektronisk enhet. "
;

++ CustomImmovable
    'orange bruten brutna sammanflätad internationell biologisk fara 
    ring+en/ringar+na/skylt+en/symbol+en'
    'orange skylt'
    "Skylten är handtextad med svart penna, över en bakgrundsgrafik 
    som visar de tre brutna, sammanflätade ringarna av den
    internationella symbolen för biologisk fara.
    <.p><.blockquote>
    Stans Värld av Drosophila-stapel
    <.p>Hjälp mig bevisa att städpersonalen har fel. De säger att mitt rum
    är för smutsigt för att städas. Det stämmer, det är rummet så smutsigt
    att det inte kan städas. Så säger de. Jag säger att deras problem är mitt
    mycket framgångsrika drosophila-avelsprogram.
    <.p>Min stapel är detta: du måste befria de ungefär
    femtiotusen bananflugorna i mitt rum. Observera att nyckelordet är
    befria, inte utrota. Hjälp till att visa dem vägen ut i
    det fria. Du vet att du är klar när Flugdensitometern visar
    en avläsning på 5 eller mindre.
    <.p>Som extra incitament att arbeta snabbt, inkluderas mutan som väntar
    inuti generösa mängder av läcker färsk frukt,
    plus ett par öppna behållare med majssirap. Ju snabbare du visar
    flugorna vägen ut, desto mer kommer det att finnas kvar.
    <./blockquote> "

    cannotTakeMsg = 'Du bör lämna den där den är. '
;

+ EntryPortal ->(location.south)
    'annan söder s smal+a smalare hall+en/korridor+en' 'smal korridor'
    "Den smala korridoren ansluter till den huvudsakliga öst/väst-korridoren i en
    T-korsning här. Den leder söderut. "
;

+ Graffiti 'ljusgul+a lövgrön+a målad+e stjälk+en blomma+n*blommor+na/stjälkar+na'
    'klotter'
    "Väggen är målad nära golvet med naturtrogna
    ljusgula blommor på lövgröna stjälkar. "
    isMassNoun = true
;

/* ------------------------------------------------------------------------ */
/*
 *   Alley 6 south 
 */
alley6S: AlleyRoom 'Gränd Sex Syd' 'södra änden av Gränd Sex'
    "Detta är den södra änden av den smala nord/syd-sektionen av
    Gränd Sex. Dörren till rum 36 är på västra sidan av
    korridoren, och mitt emot på östra sidan är dörren till
    rum 37. Gränden fortsätter norrut och slutar här i en
    spröjsad glasdörr, som leder ut söderut. "

    vocabWords = '6+e gränd+en sex sjätte hall+en/korridor+en'

    north = alley6E
    east = room37door
    west = room36door
    south = a6PorchDoor

    roomParts = static (inherited
                        + [alleySouthWall, alleyEastWall, alleyWestWall])
;

+ room36door: AlleyDoor '36+e -' 'dörr till rum 36'
    "Det är en trädörr numrerad 36. "
;

+ room37door: AlleyDoor '37+e -' 'dörr till rum 37'
    "Det är en dörr målad med nummer 37. "
;

class SleepingPorchDoor: Door
    'smidesjärn smidesjärns spröjsad+e glas+et spröjsad-glas 
    en-fot-kvadrat+s fot-kvadrat+s glasdörr+en/ram+en/ruta+n/rutor+na/glas+et'

    'spröjsad glasdörr'

    "Dörren har en smidesjärnsram med en-fot-kvadratiska
    glasrutor. <<whereDesc>> "


    dobjFor(LookThrough) { action() { "Du kan inte se mycket; glaset
        är lite dimmigt. "; } }
;

+ a6PorchDoor: SleepingPorchDoor
    whereDesc = "Den leder ut söderut. "
;

+ Graffiti 'målning+en/vampyr+en/fönst:er+ret/fönsteret/klott:er+ret' 'klotter'
    desc = "Väggen här har en målning av vad som verkar vara
        en vampyr som flyr genom ett fönster. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Sleeping Porch 
 */
sleepingPorch: DabneyOutdoorRoom 'Sovveranda' 'sovverandan'
    "Denna breda terrass är känd som Sovverandan. Studenter
    sover faktiskt här ibland, särskilt under
    sommaren när det är för varmt inomhus. Trafiken rusar förbi på
    California Boulevard nedanför. En spröjsad glasdörr leder in
    norrut. "

    north = spDoor

    vocabWords = 'bred+a sov+veranda+n/terrass+en'

    dobjFor(JumpOff)
    {
        verify() { }
        action() { "Det är alldeles för långt ner för att försöka. "; }
    }

    roomBeforeAction()
    {
        if (gActionIn(Jump, JumpOffI))
            replaceAction(JumpOff, self);
    }
;

+ spDoor: SleepingPorchDoor ->a6PorchDoor
    whereDesc = "Den leder norrut, tillbaka inomhus. "
;

/* add California Blvd and its consituent parts */
+ Distant 'california boulevard gata+n/blvd/blvd./väg+en'
    'California Boulevard'
    "California Boulevard är en livlig fyrafilig gata som utgör
    campusområdets södra gräns. "

    isProperName = true
;
++ CalBlvdTraffic;
+++ CalBlvdNoise;

/* ------------------------------------------------------------------------ */
/*
 *   Alley 7 top of stairs 
 */
alley7main: AlleyRoom 'Gränd Sju' 'Gränd Sju'
    "Detta är navet i Gränd Sju. Den långa, smala sträckan av
    Övre Sju, med sin rad av klosterceller, sträcker sig norrut;
    Nedre Sju är några trappsteg ner österut. En lång, brant
    trappa leder ner till innergården. "

    vocabWords = '7+e gränd+en sju+nde'

    down = a7CourtyardStairs
    out asExit(down)
    north = upper7S
    east = a7lowerStairs
    south asExit(down)

    roomParts = static (inherited + [alleySouthWall, alleyWestWall])
;

+ a7CourtyardStairs: StairwayDown -> dcStairsUp
    'lång+a brant+a betong innergård+en trappa+n*trappor+na' 'innergårdstrappa'
    "Det är ungefär två normala våningar med trappor som leder ner till
    innergården. "
;

+ EntryPortal ->(location.north)
    'lång+a smal+a kloster klostret 7+e övre sju+nde/cell+en/(rad+en)/hall+en/korridor+en*celler+na'
    'Övre Sju'
    "Den långa, smala korridoren sträcker sig norrut. "
    isProperName = true
;

+ a7lowerStairs: StairwayDown -> l7Stairs
    'nedre sju+nde 7+e steg+en/trappsteg+en/trappa+n*trappor+na' 'Nedre Sju'
    "Nedre Sju är några trappsteg ner österut. "
    isProperName = true
;

+ Graffiti 'gigantisk+a svart+a "välkommen till gränd 7" "välkommen" skylt+en  välkomstskylt+en' 'klotter'
    "Det finns många bitar av klotter här, inklusive en gigantisk
    svart <q>Välkommen till Gränd 7</q> skylt. "
;    

/* ------------------------------------------------------------------------ */
/*
 *   Lower 7 West
 */
lower7W: AlleyRoom 'Nedre Sju Väst' 'västra änden av Nedre Sju'
    "Detta är den västra änden av Nedre Sju. En halv trappa västerut
    leder upp till Övre Sju. Korridoren fortsätter österut,
    men vägen är helt blockerad av en hög betongskrot
    och trasiga armeringsjärn, samt en samling tunga elverktyg.
    Skrotet är uppenbarligen det som har huggits bort från det enorma betong-
    blocket i söder, som fyller utrymmet där dörren till rum 50
    normalt skulle vara. Tvärs över korridoren i norr är dörren till
    rum 49 fortfarande intakt. "

    west = l7Stairs
    up asExit(west)
    north = room49door
    south: NoTravelMessage { "Det står ett enormt betongblock i vägen. " }

    east: NoTravelMessage { "Korridoren fortsätter visserligen österut, men det
        finns ingen möjlighet att ta sig förbi skrotet och alla verktyg. " }

    vocabWords = 'gränd+en nedre sju+nde 7+e korridor+en'

    roomParts = static (inherited + [alleyNorthWall, alleySouthWall])
;

+ Graffiti
    'psykedelisk+a ljus+a neon+iska neonlysande neonfärgade svartvit+a
    virvel+n/färg+en/landskap+et/schackbräde+n/spiral+en/väggmålning+en*färger+na virvlar+na spiraler+na'
    'klotter'
    "En omfattande väggmålning börjar med ett svartvitt schackbräde
    i ena änden som förvandlas till ett psykedeliskt landskap av
    virvlar och spiraler i ljusa, neonfärger i den andra änden. "
;

+ l7Stairs: StairwayUp
    'övre sju+nde 7+e steg+en/trappsteg+en/trappa+n*trappor+na' 'trappa'
    "Trappan leder upp till Övre Sju, västerut. "
;

+ room49door: AlleyDoor '49+e -' 'dörr till rum 49'
    "Det är en trädörr märkt med <q>49.</q> "
;

+ CustomImmovable
    'konstruktion+en tung+a el+ektriska cirkulär+a murverk+s enorm+a luftdriv:en+na 
    luft|verktyg+et/luft|verktyg+en/utrustning+en/tryckluftsborr+en/såg+en/borr+en/
    kompressor+n*borrar+na kompressorer+na tryckluftsborrar+na'
    'elverktyg'
    "Det finns en hel del seriösa konstruktionsverktyg staplade längs
    väggen: ett par tryckluftsborrar, en cirkulär murverkssåg,
    enorma luftdrivna borrar, luftkompressorer och massor av saker
    du inte ens känner igen. Flera av studenterna attackerar
    betongblocket med en av tryckluftsborrana. "

    isPlural = true
    
    cannotTakeMsg = 'Även om utrustningen inte vore så stor och
        otymplig, skulle studenterna utan tvekan invända mot att du
        tar den med dig. '
;

++ Noise '(tryckluftsborr+ens) (tryckluftsborrning+ens) konstruktions|ljud+et/oljud+et'
    'konstruktionsljud'
    /* LISTEN TO TOOLS */
    sourceDesc = "Tryckluftsborren gör mycket oljud när den
        hugger bort betongen. "

    /* LISTEN TO CONSTRUCTION NOISE */
    descWithSource = (sourceDesc)

    /* LISTEN, X ALLEY, background daemon */
    hereWithSource: ShuffledEventList { [
        'Tryckluftsborren orsakar ett hemskt skrapande ljud av metall mot metall. ',
        'Tryckluftsborren slår hårt mot betongblocket. ',
        'Luftkompressorn avger ett högt väsande ljud. ',
        'Hela byggnaden verkar skaka av ljudet från tryckluftsborren. ']
    }

    displaySchedule = [2]
;

+ Person 'dammig+a grupp+en/student+grupp+en*studenter+na' 'grupp studenter'
    "Studenterna är dammiga från rivningsarbetet, precis som allt
    annat här omkring. De arbetar tillsammans med att borra sönder
    betongblocket med tryckluftsborren. "

    specialDesc = "En grupp studenter attackerar betongblocket
        med en tryckluftsborr. "
;

++ DefaultAnyTopic
    "Du försöker få någons uppmärksamhet, men alla är för
    upptagna med tryckluftsborren. "
;

+ Fixture 'rum+met 50+e dörr+en dörrram+en/ram+en' 'rum 50 dörrram'
    "Dörramen är helt fylld med ett block av betong. "
;

++ Heavy 'betong+s betong:en^s+block+et' 'betongblock'
    "Betongblocket fyller helt dörramen till rum 50,
    och sticker ut ett par fot i korridoren. Ungefär halva
    framsidan är ojämnt gropig till ett djup av några tum,
    uppenbarligen från studenternas ansträngningar att bryta igenom.
    Vridna bitar av armeringsjärn sticker ut på sina ställen. "

    /* show the initial description the first time only */
    isInInitState = (!described)
    initDesc = "Detta är ett utmärkt exempel på den klassiska Råstyrke-
        stapeln: inte den sortens sofistikerade intellektuella pussel som är så
        populära nuförtiden, utan ett faktiskt fysiskt hinder.
        Poängen är bara att spränga sig igenom det med rå fysisk kraft.
        Det behövs inga regler; de enda reglerna är fysikens lagar.
        Det, och en anständig respekt för byggnadens
        strukturella integritet.
        <.p><<desc>> "
;

+++ Decoration 'vridet vridna exponerade armeringsjärn+et/armering+en' 'vridet armeringsjärn'
    "Armeringsjärnet är exponerat på några ställen där betongen har
    huggits bort. "

    dobjFor(Pull)
    {
        verify() { }
        action() { "Det är bokstavligen ingjutet i betong. Det finns ingen möjlighet
            att du kan flytta det med bara händerna. "; }
    }
    dobjFor(Push) asDobjFor(Pull)
    dobjFor(Move) asDobjFor(Pull)
    dobjFor(Turn) asDobjFor(Pull)
    dobjFor(PushTravel) asDobjFor(Pull)
;

+ CustomImmovable
    'trasig+a betong+s rivning+s skrot+et/hög+en/armeringsjärn+et/bit+en/damm+et*högar+na bitar+na'
    'skrot'
    "Med tanke på hur mycket skrot som är uppstaplat i korridoren, är det
    förvånande att blocket inte redan är borta. Skrotet är
    staplat minst ett par fot djupt och blockerar effektivt
    vägen österut. Givetvis är det rivningsdamm överallt. "

    cannotTakeMsg = 'Det finns alldeles för mycket skrot att ta med dig,
        och även de minsta bitarna är obekvämt stora och
        tunga och vassa. Det mesta du skulle kunna göra är att flytta
        högarna lite, vilket inte skulle åstadkomma något. '

    lookInDesc = "Allt du hittar i skrotet är ännu mer skrot. "
;    
    

/* ------------------------------------------------------------------------ */
/*
 *   Upper 7 South
 */
upper7S: AlleyRoom 'Övre Sju Syd' 'södra änden av Övre Sju'
    "Detta är den södra änden av Övre Sju. Den smala korridoren
    sträcker sig norrut, kantad på båda sidor av klotter och
    tätt placerade dörrar. De flesta av de ökända Övre Sju-enkelrummen
    är så små att du kan stå i mitten av ett och röra vid
    motsatta väggar samtidigt.
    <.p>Dörren till rum 43 är nordväst, 44 nordöst, 45 väster,
    46 öster, 47 sydväst och 48 sydöst. Korridoren fortsätter
    till fler tätt packade rum norrut och öppnar sig till ett större
    område söderut. "

    vocabWords = '7+e övre sju+nde gränd+en'

    south = alley7main
    north = upper7N
    northwest = room43door
    northeast = room44door
    west = room45door
    east = room46door
    southwest = room47door
    southeast = room48door

    roomParts = static (inherited + [alleyEastWall, alleyWestWall])
;

+ room43door: AlleyDoor '43+e -' 'dörr till rum 43'
    "Det är en trädörr märkt med <q>43.</q> "
;
+ room44door: AlleyDoor '44+e -' 'dörr till rum 44'
    "Det är en trädörr märkt med <q>44.</q> "
;
+ room45door: AlleyDoor '45+e -' 'dörr till rum 45'
    "Det är en trädörr märkt med <q>45.</q> "
;
+ room46door: AlleyDoor '46+e -' 'dörr till rum 46'
    "Det är en trädörr märkt med <q>46.</q> "
;
+ room47door: AlleyDoor '47+e -' 'dörr till rum 47'
    "Det är en trädörr märkt med <q>47.</q> "
;
+ room48door: AlleyDoor '48+e -' 'dörr till rum 48'
    "Det är en trädörr märkt med <q>48.</q> "
;

+ Graffiti '- klotter klottret' 'klotter'
    "<font face='tads-sans'><b>Du vet att du är en nörd när
    du börjar drömma i <tab id=lang><s>&nbsp;FORTRAN&nbsp;</s>
    \n<tab to=lang><s>&nbsp;Pascal&nbsp;</s>
    \n<tab to=lang><s>&nbsp;C&nbsp;</s>
    \n<tab to=lang><s>&nbsp;C++&nbsp;</s>
    \n<tab to=lang><s>&nbsp;Java&nbsp;</s>
    \n<tab to=lang>&nbsp;QUBITS&nbsp;
    </b></font>
    \bVarje programmeringsspråks namn har strukits över och
    ett annat har skrivits under, och sedan har den ersättningen
    själv strukits över och ersatts. Endast den
    sista posten, <q>QUBITS,</q> står kvar. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Upper 7 North 
 */
upper7N: AlleyRoom 'Övre Sju Nord' 'norra änden av Övre Sju'
    "Tätt placerade dörrar till de klosterlika cellerna som är Övre Sju-
    enkelrummen kantar denna sträcka av den smala korridoren. Rum 38 är nordöst,
    39 är nordväst (du minns att det är det enda dubbelrummet i Övre 7),
    40 är öster, 41 är sydväst och 42 är sydöst.
    Gränden sträcker sig bort söderut och slutar här vid en vägg i
    norr.
    <.p>En antik persondator står på golvet utanför
    dörren till rum 42. En blå pappersskylt är fäst på dörren. "
    
    vocabWords = '7+e övre sju+nde gränd+en'

    south = upper7S
    northeast = room38door
    northwest = room39door
    east = room40door
    southwest = room41door
    southeast = room42door

    roomParts = static (inherited
                        + [alleyEastWall, alleyWestWall, alleyNorthWall])
;

+ room38door: AlleyDoor '38+e -' 'dörr till rum 38'
    "Det är en trädörr märkt med <q>38.</q> "
;
+ room39door: AlleyDoor '39+e -' 'dörr till rum 39'
    "Det är en trädörr märkt med <q>39.</q> "

    dobjFor(Knock)
    {
        action()
        {
            /* do the normal no-reply business */
            inherited();

            /* if Aaron's here, mention where he went */
            if (aaron.isIn(location))
                "<.p>Aaron tittar ditåt. <q>Om du letar efter
                Scott tror jag han arbetar med den gigantiska kyckling-
                stapeln i gränd 3.</q> ";
        }
    }
;
+ room40door: AlleyDoor '40+e -' 'dörr till rum 40'
    "Det är en trädörr märkt med <q>40.</q> "
;
+ room41door: AlleyDoor '41+e -' 'dörr till rum 41'
    "Det är en trädörr märkt med <q>41.</q> "
;
+ room42door: StackDoor '42+e -' 'dörr till rum 42'
    "En blå pappersskylt är fäst på dörren, och en gammal persondator
    står på golvet framför den. Dörren är
    märkt med <q>42.</q> "
;
++ CustomImmovable, Readable 'blå+a papper:et^s+skylt+en' 'skylt'
    "<font face='tads-sans'>Välkommen till Pauls Skoldagsstapel! Min
    stapel består av endast ett problem, som finns i Commandant 64 nedan.
    Allt du behöver göra är att skriva in rätt <q>lösenord.</q> Du vet 
    att du har skrivit rätt sak när utmatningen är exakt samma sträng
    som inmatningen. (Lösenordet har ett antal tecken som inte är noll.
    Du kan inte vinna genom att hävda att om du skriver noll tecken, så
    svarar datorn med samma noll tecken.)
    <.p>Ett par ledtrådar. För det första är lösenordet mellan ett och
    sexton tecken långt. För det andra innehåller det bara siffrorna 0 till 9
    och bokstäverna A till F. För det tredje, om du skriver in något annat
    än lösenordet, kan datorn visa dig ett svar som
    ser ut som nonsens---men det nonsens är faktiskt användbar
    information, så ignorera det inte.
    <.p>Lycka till!</font> "
    
    disambigName = 'blå pappersskylt'
    cannotTakeMsg = 'Du bör lämna skylten där den är. '
;
+ commandant64: Keypad, CustomImmovable, Readable
    'vit+a plast+iga antik+a gammal gamla personlig+a 64 display+en
    dator+n/commandant+en/maskin+en/tangentbord+et/display+en/monitor+n/skärm+en/pc+n'
    'gammal dator'
    "Datorn är en Commandant 64, en av de maskinerna från
    den första eller andra generationen av persondatorer. Den ser ut som
    en vit plastresväska, liggande på sidan, med ett tangentbord
    inbäddat på ovansidan nära framkanten. En liten display sitter
    ovanpå.
    <.p><<readDesc>> "
    
    cannotTakeMsg = 'Du bör inte störa stapeln. '
    readDesc()
    {
        "Monitorn visar för närvarande:\b
        <tt><<monitorDesc>></tt> ";

        /* note that this program has been observed */
        progSeen = true;
    }

    /* a few interesting programs */
    interestingProgs =
    [
        '123456789abcdef0',                      /* just a random first try */
        'eeee',                                 /* displays 0000... forever */
        '21ed0',                                 /* display 1111... forever */
        '22ed0',                                 /* display 2222... forever */
        '1ea6d11',                    /* display 0123... repeatedly forever */
        '1ea6d12',                   /* display 02468... repeatedly forever */
        '1ea9c8d101',                            /* display 0123...DEF once */
        '1b9ec8d101',                            /* display FEDC...210 once */
        '3feae5fbdccd0b11'                 /* count from 1 to 10 (0xA) once */
    ]
    nextInteresting = 2
    monitorDesc = static (processInput(interestingProgs[1]))
    successStr = 'LÖST!!!'

    /* flag: the current program has been examined */
    progSeen = nil

    /* 
     *   When the PC arrives, and Aaron is present, change the program if
     *   we've seen the one that was here before.  This makes it seem as
     *   though Aaron is actively trying different entries.  
     */
    afterTravel(trav, conn)
    {
        /* 
         *   if Aaron is here, and the current program has been observed,
         *   select a new program 
         */
        if (aaron.isIn(location) && progSeen)
            selectNewProg();
    }

    /* select and enter a program */
    selectNewProg()
    {
        local str;
        
        /* 
         *   if we have more interesting programs to enter, enter one of
         *   those 
         */
        if (nextInteresting <= interestingProgs.length())
        {
            /* we have more programs to enter, so enter one */
            str = interestingProgs[nextInteresting++];
        }
        else
        {
            /* 
             *   we have no more interesting programs, so make one up
             *   randomly - just choose a string of random hex digits, of
             *   random length (but always from 5 to 16 characters) 
             */
            for (local len = rand(12) + 5, str = '' ; len != 0 ; --len)
                str += '01234567890abcdef'.substr(rand(16) + 1, 1);
        }

        /* enter the selected program */
        monitorDesc = processInput(str);

        /* this new program hasn't been examined by the player yet */
        progSeen = nil;
    }

    dobjFor(TypeLiteralOn)
    {
        verify() { }
        action()
        {
            /* process the input (from the literal phrase typed) */
            monitorDesc = processInput(gLiteral);
            
            /* show the result */
            "Du skriver in <q><tt><<gLiteral.htmlify()>></tt></q> och trycker 
            på enter. Efter en liten stund ändras bildskärmen till att visa:
            \b<tt><<monitorDesc>></tt> ";

            /* if it's the winning password, say so */
            if (monitorDesc.endsWith(successStr))
            {
                if (room42door.isSolved)
                {
                    "<.p>Du har löst det igen! Du skriver diskret in
                    en ny slumpmässig sträng för att undvika att förstöra utmaningen
                    för någon annan. ";
                }
                else
                {
                    "<.p>Du hittade lösenordet! Du känner dig orimligt
                    nöjd med dig själv, men det dämpas av
                    vetskapen att detta inte för dig någon vart
                    med Stamers stapel. ";

                    if (aaron.isIn(location))
                        "<.p>Det verkar inte som om Erin eller Aaron
                        uppmärksammade det. Hur gärna du än vill skryta
                        med din lösning, tänker du att de förmodligen
                        skulle bli gladare av att lösa stapeln på egen hand, så
                        du skriver tyst in en slumpmässig sträng för att rensa
                        lösningen från monitorn. ";
                    else
                        "<.p>Du vill inte förstöra utmaningen för
                        någon annan, så hur gärna du än vill skryta
                        med din lösning, skriver du tyst in en slumpmässig
                        sträng för att rensa lösningen från monitorn. ";

                    /* mark the stack as solved */
                    room42door.isSolved = true;

                    /* award extra-credit points for solving it */
                    extraCreditMarker.awardPointsOnce();
                }

                /* reset the display */
                monitorDesc = processInput('123456');
            }
            else
            {
                /* mention that this isn't important once in a while */
                timeWasterWarning.doScript();

                /* mention that aaron and erin notice, if they're here */
                if (aaron.isIn(location))
                    aAndENotice.doScript();
            }

            /* this counts as seeing the program */
            progSeen = true;
        }
    }
    dobjFor(EnterOn) asDobjFor(TypeLiteralOn)

    /* an extra-credit achievement for solving the stack */
    extraCreditMarker: ExtraCreditAchievement { +50 "lösa
        Commandant 64-stapeln" }

    timeWasterWarning: StopEventList { [
        nil, nil, nil,
        '<.p>Det slår dig att den här typen av problem kan vara fruktansvärt
        beroendeframkallande; bäst att vara försiktig så du inte fastnar för länge här. ',
        nil, nil, nil, nil, nil,
        '<.p>Hur intressant det än är, vet du att du verkligen borde
        återgå till Stamers stapel inom kort. ',
        '<.p>Du påminner dig själv om att inte bli för uppslukad av
        den här stapeln, eftersom du har viktigare saker du borde
        arbeta med. ',
        nil] }

    aAndENotice: ShuffledEventList { [
        '<.p>Erin och Aaron tittar på vad du skrev och mumlar
        några kommentarer till varandra. ',
        '<.p>Aaron tittar på displayen och gör ett litet <q>hmm</q>
        ljud. ',
        '<.p>Erin tittar noggrant på vad du skrev. ',
        '<.p><q>Intressant,</q> säger Aaron, medan han tittar på displayen. ',
        '<.p>Erin tittar på vad du skrev och nickar. '] }

    /* process an input string and update the monitor with the result */
    processInput(str)
    {
        local prefix;
        
        /* get the upper-case version of the input */
        str = str.toUpper();
            
        /* the monitor always shows the input first */
        prefix = '\tIN:\ ' + str.htmlify() + '\n\t';
            
        /* 
         *   if the string contains non-hex, or it's longer than 16
         *   characters, show an error 
         */
        if (rexMatch('[0-9A-F]+$', str) == nil)
        {
            /* invalid keys entered */
            return prefix + 'ERR:0-9+A-F BARA!!!';
        }
        else if (str.length() > 16)
        {
            /* too long */
            return prefix + 'ERR:16 TECKEN MAX!!!';
        }
        else
        {
            local result, outStr;
            
            /* run the program */
            outStr = runProgram(str);
            
            /* add the result to the prefix */
            result = prefix + 'UT:' + outStr;

            /* 
             *   If it's a winner, add a mention of this.  We can tell
             *   that we have a winner when the output string equals the
             *   input string.
             *   
             *   Note that a great feature of this puzzle is that you can
             *   read the source code, and it still doesn't give away the
             *   solution.  You'll notice that there's no hard-coded
             *   string anywhere in here that says what the solution is;
             *   it's simply the input that yields itself as the output.
             *   It probably helps a little that you can see exactly what
             *   each input does without having to infer it from
             *   trial-and-error observation, but reverse-engineering the
             *   mechanism is only half the game - there's still a fairly
             *   challenging problem to solve even after you know exactly
             *   how the input is transformed into the output.  
             */
            if (str.length() > 0 && str == outStr)
                result += '\b\t' + successStr;

            /* return the result */
            return result;
        }
    }

    /*
     *   Run the program contained in the given string, returning the
     *   display string that results. 
     */
    runProgram(str)
    {
        local iter;
        local pc;
        local disp;
        local r0;
        local mem;

        /* start out with no display results */
        disp = '';

        /* start with R0 set to zero */
        r0 = 0;

        /* set up a vector from the string */
        mem = new Vector(16);
        for (local i = 1, local len = str.length() ; i <= 16 ; ++i)
        {
            /* 
             *   fill from this string element, or with zero if the string
             *   isn't long enough 
             */
            mem[i] = (i <= len ? toInteger(str.substr(i, 1), 16) : 0);
        }

        /* run an arbitrary maximum of 1024 instructions */
    runLoop:
        for (iter = 0, pc = 1 ; iter < 1024 ; ++iter)
        {
            /* fetch the current instruction half-byte */
            local instr = mem[pc];

            /* 
             *   advance the program counter, wrapping if we've reached
             *   the top of memory 
             */
            if (++pc > 16)
                pc = 1;
            
            /* process the current instruction */
            switch (instr)
            {
            case 0:
                /* HALT */
                break runLoop;

            case 1:
                /* CLR - load zero into R0 */
                r0 = 0;
                break;

            case 2:
                /* LOADC - load immediate operand into R0 */
                r0 = mem[pc++];
                break;

            case 3:
                /* LOAD - load value from address operand */
                r0 = mem[mem[pc++] + 1];
                break;

            case 4:
                /* LOADIDX - load value from address pointer operand */
                r0 = mem[mem[mem[pc++] + 1] + 1];
                break;

            case 5:
                /* STORE - store R0 into address operand */
                mem[mem[pc++] + 1] = r0;
                break;

            case 6:
                /* STOREIDX - store R0 into address pointer operand */
                mem[mem[mem[pc++] + 1] + 1] = r0;
                break;

            case 7:
                /* AND - bitwise AND address operand into R0 */
                r0 &= mem[mem[pc++] + 1];
                break;

            case 8:
                /* OR - bitwise OR address operand into R0 */
                r0 |= mem[mem[pc++] + 1];
                break;

            case 9:
                /* NOT - bitwise negate R0 */
                r0 = ~r0;
                r0 &= 0xF;
                break;

            case 0xA:
                /* ADD - add address operand into R0 */
                r0 += mem[mem[pc++] + 1];
                r0 &= 0xF;
                break;

            case 0xB:
                /* SUB - subtract address operand from R0 */
                r0 -= mem[mem[pc++] + 1];
                r0 &= 0xF;
                break;

            case 0xC:
                /* JZ - jump to operand address if R0 is zero */
                if (r0 == 0)
                    pc = mem[pc] + 1;
                else
                    ++pc;
                break;

            case 0xD:
                /* JMP - jump to operand address */
                pc = mem[pc] + 1;
                break;

            case 0xE:
                /* 
                 *   PRINT - display contents of R0.  Only allow up to 64
                 *   characters in the output; if we already have 64,
                 *   simply stop running now. 
                 */
                if (disp.length() >= 64)
                {
                    disp += '...';
                    break runLoop;
                }

                /* add the contents of R0 to the display */
                disp += toString(r0, 16);
                break;

            case 0xF:
                /* NOP - no operation */
                break;
            }

            /* wrap the PC if necessary, in case we read an operand */
            if (pc > 16)
                pc = 1;
        }

        /* return the display result */
        return disp;
    }
;

+ Graffiti 'Polly Nomial berättelse+n' 'klotter'
    "<q>...När Polly kom hem den kvällen märkte hennes mamma
    att hon inte längre var styckvis kontinuerlig –
    någon hade klippt av henne i flera intervall.
    Men det var för sent att derivera nu.
    Tiden gick, och Pollys nämnare växte monotont.
    Till slut hamnade hon på l’Hôpital,
    där hon födde en liten men patologisk funktion
    som spred irrationella rötter över hela huset
    och drev Polly till total standardavvikelse...</q>"
;
