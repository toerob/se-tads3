#charset "utf-8"
/*
 *   Copyright 2003, 2013 Michael J. Roberts
 *   
 *   Return to Ditch Day - Millikan Library.  This includes the library's
 *   physical setting, plus the various books we can find.  
 */

#include <adv3.h>
#include <sv_se.h>
#include "ditch3.h"



/* ------------------------------------------------------------------------ */
/*
 *   Elevator doors on a floor of Millikan - we customize the basic class
 *   slightly to add vocabulary and a description.  
 */
class LibElevatorDoor: ElevatorDoor
    'skinande metall+iska glidande hissens hiss+dörr+en/hissdörrar+na' 'hiss'
    "Hissens skjutdörrar är gjorda av skinande metall. <<buttonDesc>> "

    isPlural = true

    /* 
     *   put the door in my lexical parent to allow nested declaration,
     *   right as part of the room definition 
     */
    location = (lexicalParent)

    /* 
     *   My floor number - we use this to figure out where the elevator
     *   opens to when it's on a given floor.  Take this from my location's
     *   floor number by default, since all of the LibRoom levels define
     *   the same floor number information we need here.  
     */
    floorNum = (location.floorNum)

    /* 
     *   because we mention some other things in our description, don't
     *   use a pronoun in our open-status message 
     */
    openStatus = "dörrarna är <<openDesc>>"

    /* announce our doors opening/closing */
    announceRemoteOpen(stat, dir)
    {
        if (stat)
            "Hissdörrarna glider upp med <<
              ['två mjuka <q>ding.</q>',
               'en klang.',
               'ett mjukt <q>ding.</q>'][dir + 2]>> ";
        else
            "Hissdörrarna glider igen. ";
    }

    /* the master side of all of the elevator doors is the inner door */
    masterObject = meDoors
;

/* library up/down buttons */
class LibElevatorUpButton: ElevatorUpButton
    'platt+a plast+iga -' '<q>upp</q> knapp'
    "Det är en platt plastknapp formad som en pil som pekar uppåt.
    <<isLit ? "Den lyser." : "">> "
;

class LibElevatorDownButton: ElevatorDownButton
    'platt+a plast+iga -' '<q>ner</q> knapp'
    "Det är en platt plastknapp formad som en pil som pekar nedåt.
    <<isLit ? "Den lyser." : "">> "
;

/* ------------------------------------------------------------------------ */
/*
 *   Millikan lobby 
 */
millikanLobby: Room 'Millikan Entré' 'entrén till Millikan' 'entré'
    "Denna första våning av biblioteket är en stor, öppen entré. En
    receptionist sitter bakom en bred disk; en skylt på disken
    lyder <q>Vänligen visa ID.</q> På norra sidan av entrén
    finns en hiss, med en våningsförteckning på väggen bredvid den.
    Utgången är åt öster. "

    vocabWords = 'bibliotek+et millikan+s entré+n'

    east = millikanPond
    out asExit(east)
    north = mlElevatorDoor

    /* on arrival, reset the need-to-show-ID marker */
    travelerArriving(traveler, origin, connector, backConnector)
    {
        /* do the normal work */
        inherited(traveler, origin, connector, backConnector);

        /* 
         *   if we're not coming from the elevator, and we've shown our ID
         *   in the past, have the librarian mention that we don't need to
         *   show it again 
         */
        if (traveler == me && origin != millikanElevator && !needID)
            "<.p>Bibliotekarien tittar upp från sin bok kort när du
            kommer in, och återgår sedan till sin läsning. ";
    }

    beforeTravel(traveler, connector)
    {
        /* 
         *   if the actor is trying to leave with some un-checked-out
         *   library books, stop him 
         */
        if (connector is in (east, out))
        {
            local lst;
            local cnt;
            
            /* get a list of un-checked-out books we're carrying */
            lst = LibBook.allLibBooks.subset(
                {x: x.isIn(gActor) && !x.isCheckedOut});

            /* if we found any un-checked-out books, warn about it */
            cnt = lst.length();
            if (cnt != 0)
            {
                local aBook, it;

                /* 
                 *   get the noun and pronoun phrase to use to refer to the
                 *   book or books we need to check out 
                 */
                if (cnt == 1)
                {
                    /* we have just one, so use its singular name */
                    it = 'den';
                    aBook = lst[1].coName;
                }
                else
                {
                    /* 
                     *   we have more than one - use them as the pronoun,
                     *   and if they all have the same plural name, use
                     *   that plural name, otherwise make it "some items" 
                     */
                    it = 'dem';
                    aBook = lst[1].coPluralName;
                    if (lst.indexWhich({x: x.coPluralName != aBook}) != nil)
                        aBook = 'några saker';
                }
                
                /* complain about it */
                "Du börjar gå, men du inser att du har <<aBook>>
                som du inte har lånat. Du ger <<it>> till
                bibliotekarien; han stämplar <<it>> och ger <<it>>
                tillbaka. <q>Ska lämnas tillbaka om två veckor,</q> säger han. ";

                /* mark them all as checked out */
                foreach (local cur in lst)
                    cur.isCheckedOut = true;
            }
        }
    }

    /* flag: we need to show our ID before we can enter the library */
    needID = true

    /* this is the first floor */
    floorNum = 1
;

+ Fixture 'bred+a reception^s+disk+en' 'bred disk'
    "Det är en bred disk som skapar en arbetsyta för receptionisten.
    En skylt på disken lyder <q>Vänligen visa ID.</q> "
;

++ Readable, Immovable 'skylt+en' 'skylt'
    "<q>Vänligen visa ID.</q> "
;

+ millikanReceptionist: Person
    'receptionist+en/doktorand+en/bibliotekarie+n/man+nen*män+nen' 'receptionist'
    "Receptionisten ser ut att vara en doktorand---i mitten av
    tjugoårsåldern, flanellskjorta, ungefär fyra dagar sedan han rakade sig.
    Han studerar intensivt en, till utseendet, tung lärobok. "

    isHim = true

    /* 
     *   don't bother listing my contents on Examine, as we've already
     *   done so in our basic description 
     */
    examineListContents() { }

    /* we don't need a special mention, since we're in the room desc */
    specialDesc = ""

    defaultGreetingResponse(actor)
    {
        "Du står vid disken och harklar dig.
        <.p><q>Ja?</q> säger receptionisten utan att titta upp
        från sin bok. ";
    }
;

++ InitiallyWorn 'flanell:en+skjorta+n' 'flanellskjorta'
    "Den ser välanvänd ut. "
    isListedInInventory = nil
;

++ AskTopic @millikanReceptionist
    "<q>Är du student här?</q> frågar du.
    <q>Doktorand,</q> säger han utan att titta upp. "
;

++ receptBook: Readable
    'tung+a utseende+t text+en lärobok+en/bok+en' 'tung lärobok'
    "Det ser ut som att det kan vara en lärobok i allmän relativitetsteori. "
;

++ AskTopic, SuggestedAskTopic, StopEventList @receptBook
    ['<q>Vilken text är det där?</q> frågar du receptionisten.
    <.p>Han tittar inte upp. <q>Relativistisk gravitation,</q> säger han. ',
     '<q>Relativistisk gravitation? Låter <q>tungt.</q></q> Du
     gör små citattecken i luften med fingrarna.
     <.p><q>Vet du vad som gör det skämtet riktigt roligt? Att göra små
     citattecken i luften med fingrarna medan du säger <q>tungt.</q></q> ',
     '<q>Intressant bok?</q> frågar du.
     <.p><q>Nästan intressant nog för att dränka ut alla distraktioner
     här omkring,</q> säger han och sätter ansiktet ännu närmare boken. ']

    name = 'hans bok'
;

++ AskTellTopic, StopEventList @ddTopic
    ['<q>Så varför sitter du fast här under Skolkdagen?</q> frågar du, och inser
    omedelbart att det kanske var en okänslig fråga.
    <.p><q>För att killen som <i>borde</i> vara här är en
    grundstudent,</q> säger han. ',
     'Han verkade lite känslig för ämnet, så du kanske inte borde 
     pressa honom. ']
;

++ AskTellTopic @stamerTopic
    "<q>Du råkar inte känna en grundstudent som heter Brian Stamer,
    eller?</q> frågar du.
    <.p><q>Nej, tyvärr,</q> säger han utan att titta upp. "
;

++ AskTellTopic @researchReport
    "Du beskriver Brian Stamers forskningsrapport för bibliotekarien,
    men han känner inte igen den. <q>Kanske om jag fick se den,</q>
    föreslår han. "
;
++ GiveShowTopic @researchReport
    "Du räcker över rapporten till bibliotekarien, och han ger den en snabb
    överblick. <q>QM,</q> säger han. <q>Tyvärr, det är inte min grej.
    Gravitation och kvantmekanik fungerar inte så bra ihop.</q> "
;

++ AskTellTopic [sAndPs, sAndP, sAndPTopic, sAndP3Topic]
    "<q>Har ni tidskriften Science &amp; Progress?</q> frågar du.
    <.p><q>Visst,</q> säger han. <q>Tidskrifter. Andra våningen.</q> "
;

++ AskTellTopic [morgenUnbook, morgenTopic, morgenBook,
                 townsendUnbook, townsendTopic, townsendBook]
    "<q>På vilken våning har ni böckerna om elektroteknik?</q> frågar du.
    <.p><q>Elektroteknik? Tredje våningen,</q> säger han. "
;

++ AskTellTopic [qrlTopic, qrls,
                 qrl7011c, qrl7011cTopic,
                 qrl739a, qrl739aTopic]
    "<q>Var kan jag hitta tidskriften som heter Quantum Review Letters?</q>
    frågar du.
    <.p>Han tittar upp. <q>Vi har tidskrifterna på ämnesvåningarna.
    QRL är fysik, så sjätte våningen.</q> "
;

++ AskTellTopic [physicsTextTopic, bloemnerTopic, bloemnerBook,
                 bloemnerUnbook]
    "<q>Var har ni fysikböckerna?</q> frågar du.
    <.p><q>Sjätte våningen,</q> säger han. "
;

++ AskTellTopic [drdUnbook, drdBook, drdTopic]
    "<q>Jag letar efter DRD-tabellerna,</q> säger du.
    <.p><q>Få se nu,</q> säger han. <q>Jag tror de är med fysikböckerna,
    på sexan.</q> "
;

++ AskTellAboutForTopic
    [eeTextbookRecTopic, eeTextTopic, eeLabRecTopic, labManualTopic,
     morgenBook, townsendBook]
    "<q>Var finns elektroteknikböckerna?</q> frågar du.
    <.p>Han läser bara sin bok i några ögonblick, sedan verkar han märka
    att du sa något. <q>Tredje våningen,</q> säger han frånvarande. "
;
+++ AltTopic
    "<q>Kan du rekommendera en bra lärobok i elektroteknik?</q> frågar du.
    <.p><q>Jag är fysiker,</q> säger han. <q>Fråga en elektrotekniker.</q> "

    isActive = gRevealed('need-ee-text')
;

++ AskTopic '<nocase>(id|identifikation)$'
    "<q>Vilken typ av ID behöver du se?</q> frågar du.
    <.p><q>Vilket Caltech-ID som helst går bra,</q> säger han. "
;

++ AskTellTopic, SuggestedTopic 'checka ut ( bok| böcker|en bok)?'
    topicResponse()
    {
        "<q>Var lånar jag böcker?</q> frågar du.
        <.p><q>Precis här,</q> säger han. <q>Ge mig bara allt du
        behöver låna så tar jag hand om det.";

        if (millikanLobby.needID)
            " Jag behöver se något ID först, förstås.";

        "</q> ";
    }

    /* 
     *   This is a basic SuggestedTopic rather than a SuggestedAskTopic, so
     *   we need to define a full name.  We do it this way because it
     *   doesn't fit the regular grammatical pattern for ASK ABOUT TOPIC
     *   suggestions, and as a result it doesn't fit the parallel structure
     *   needed for a list of ASK ABOUT TOPIC suggestions.  Because it
     *   doesn't fit the parallel grammar structure, it sounds better if
     *   it's off on its own, not grouped with the other ASK suggestions.  
     */
    fullName = 'fråga om att låna böcker'
;
++ GiveShowTopic @alumniID
    topicResponse()
    {
        "Du håller fram ditt alumni-ID-kort, och receptionisten granskar det
        noggrant. <q>Du kan gå upp,</q> säger han och vinkar
        med handen mot hissen. ";

        /* note that we're approved */
        millikanLobby.needID = nil;
    }
;
+++ AltTopic
    "Du håller fram ditt kort för receptionisten, men han ger det
    bara en snabb blick innan han vinkar förbi dig. <q>Jag kommer fortfarande ihåg
    dig,</q> säger han. <q>Du kan gå upp.</q> "
    
    isActive = (!millikanLobby.needID)
;
++ GiveShowTopic @driverLicense
    "Du håller upp ditt körkort för receptionisten att se;
    han tittar på det men skakar på huvudet. <q>Jag behöver <i>Caltech</i>
    ID,</q> säger han. "
;
++ GiveShowTopic @cxCard
    "Du håller fram Consumer Express-kortet för receptionisten,
    men han rynkar bara pannan. <q>Det där är inte ett ID,</q> säger han. "
;
++ DefaultAnyTopic
    "<q>Jag är lite upptagen,</q> säger receptionisten utan att titta
    upp från sin bok. "
;
++ checkOutBookTopic: GiveTopic
    matchObj = (LibBook.allLibBooks)
    handleTopic(fromActor, obj)
    {
        /* inherit the normal work */
        inherited(fromActor, obj);

        /* respond according to whether or not we've check it out yet */
        if (obj.isCheckedOut)
            "Receptionisten tittar inuti boken. <q>Du har redan
            lånat den här,</q> säger han. ";
        else
        {
            "Receptionisten tittar inuti boken, stämplar den,
            och lämnar tillbaka den. <q>Ska lämnas tillbaka om två veckor,</q> säger han. ";
            obj.isCheckedOut = true;
        }
    }
;
++ ShowTopic
    matchObj = (LibBook.allLibBooks)
    handleTopic(fromActor, obj)
    {
        /* inherit the normal work */
        inherited(fromActor, obj);

        /* ask why they're showing it to us */
        "Receptionisten tittar på boken. <q>Ville du
        låna den?</q> frågar han.<.convnode checking-out> ";

        /* 
         *   this is a bit tricky: the YES handler in the ConvNode doesn't
         *   by itself have any idea what book we're talking about, so
         *   store it explicitly so that the YES handler will know about it
         */
        checkOutBookYes.bookToCheckOut = obj;
    }
;
++ ConvNode 'checking-out';
+++ checkOutBookYes: YesTopic
    handleTopic(fromActor, obj)
    {
        /* inherit the normal work */
        inherited(fromActor, obj);

        "<q>Ja, tack,</q> säger du och räcker honom boken.<.p> ";
        checkOutBookTopic.handleTopic(fromActor, bookToCheckOut);
    }

    /* 
     *   the book to check out - the SHOW TO handler that sets up this
     *   ConvNode will initialize this with the book in question 
     */
    bookToCheckOut = nil
;
+++ NoTopic
    "<q>Inte just nu, tack,</q> säger du. Receptionisten återgår
    till sin bok. "
;

+ LibElevatorUpButton;
+ mlElevatorDoor: LibElevatorDoor
    desc = "De glidande hissdörrarna är gjorda av blank metall. En
        <q>upp</q>-knapp finns på ena sidan av dörrarna, och på andra
        sidan finns en våningsförteckning. "

    /* we can't enter the elevator until we show ID */
    canTravelerPass(trav) { return !millikanLobby.needID; }
    explainTravelBarrier(trav)
    {
        "<q>Ursäkta,</q> säger receptionisten. <q>Jag behöver se
        ditt ID först.</q>
        <.p>Han ser inte ut som någon som skulle försöka fysiskt
        hindra dig, men han skulle utan tvekan ringa säkerhetsvakten om du
        trängde dig förbi honom. ";
    }
;

+ Readable, Fixture 'vånings|förteckning+en/katalog+en' 'våningsförteckning'
    "Skylten listar ämnesområdena på varje våning:
    <.p>
    <.blockquote>
    2 - Kemi/Tidskrifter<br>
    3 - Elektroteknik<br>
    4 - Flygteknik/Materialvetenskap<br>
    5 - Astronomi<br>
    6 - Fysik/Matematik<br>
    7 - Biologi<br>
    8 - Datavetenskap<br>
    9 - Geologi
    <./blockquote> "
;

/* ------------------------------------------------------------------------ */
/*
 *   The Millikan elevator 
 */
millikanElevator: Elevator, Room 'Hiss' 'hissen'
    "Hissens dörrar, som leder söderut, är för närvarande
    <<meDoors.openDesc>>. Bredvid dörrarna finns en rad
    knappar numrerade från 1 till 9, och ovanför knapparna finns en
    digital display som för närvarande visar <q><<getFloorName()>>.</q> "

    vocabWords = 'hiss+en/lift+en'

    south = meDoors
    out asExit(south)

    /* when we move between floors, mention the change in the display */
    continueElevatorMotion(curFloorNum, targetFloorNum)
    {
        /* mention the change in the display */
        "Displayen ändras <<
          (targetFloorNum - curFloorNum) is in (1, -1)
          ? "till" : "för varje våning tills den når"
          >> <<getNameForFloor(targetFloorNum)>>. ";

        /* travel directly to the new floor */
        return targetFloorNum;
    }

    announceStop(moving, newDir)
    {
        /* one ding for up, two for down */
        local ding = ['två mjuka <q>ding.</q>',
                      'en klang.',
                      'ett mjukt <q>ding.</q>'][newDir + 2];

        if (moving)
            "Hissen stannar och dörrarna glider upp med <<ding>> ";
        else
            "Hissdörrarna glider upp med <<ding>> ";
    }
;

+ Fixture 'digital+a hiss+ens lift+ens display+en' 'hissdisplay'
    "Det är en digital display som visar aktuellt våningsnummer.
    Den visar <<location.getFloorName()>>. "
;

+ meDoors: ElevatorInnerDoor
    'blank+a metall+iska hiss+ens lift+ens dörr+en*dörrar+na' 'hissdörrar'
    "Hissdörrarna är gjorda av blank metall. "
    isPlural = true
    
    /* start out on the first floor */
    otherSide = mlElevatorDoor
;

class LibElevatorButton: ElevatorButton
    'platt+a plast+iga knapp+en*knappar+na'
    desc = "Det är en platt plastknapp numrerad <<floorName>>.
        <<isLit ? "Den lyser för närvarande. " : "">> "

    collectiveGroups = [libElevatorButtonGroup]
;

+ libElevatorButtonGroup: ElevatorButtonGroup
    'platt+a plast+iga knapp+en/rad+en*knappar+na' 'knappar'
    "Knapparna är ordnade i en rad, numrerade från 1 till 9. <<listLit>> "
;

+ LibElevatorButton '1 -' floorNum = 1;
+ LibElevatorButton '2 -' floorNum = 2;
+ LibElevatorButton '3 -' floorNum = 3;
+ LibElevatorButton '4 -' floorNum = 4;
+ LibElevatorButton '5 -' floorNum = 5;
+ LibElevatorButton '6 -' floorNum = 6;
+ LibElevatorButton '7 -' floorNum = 7;
+ LibElevatorButton '8 -' floorNum = 8;
+ LibElevatorButton '9 -' floorNum = 9;

/* ------------------------------------------------------------------------ */
/*
 *   A class for a floor of the library.
 */
class LibRoom: Room
    floorNum = 2
    subjectMatter = ''

    vocabWords = perInstance(
        spellIntOrdinal(floorNum) + ' millikan/bibliotek+et/våning+en')
    name = (spellIntOrdinal(floorNum) + ' våningen')

    desc = "Detta är <<spellIntOrdinal(floorNum)>> våningen i
        biblioteket, som är ägnad åt böcker och tidskrifter om
        <<subjectMatter>>. Rader av bokhyllor från golv till tak
        fyller hela våningen. Hissen är norrut. "

    east = travelIntoStacks
    west = travelIntoStacks
    south = travelIntoStacks

    /* the 'shelves' object for this level */
    floorShelves = nil

    /* 
     *   on arriving on a floor in the library, set the default
     *   Consultable to our books 
     */
    afterTravel(traveler, connector)
    {
        /* do the normal work */
        inherited(traveler, connector);

        /* set the default Consultable to our books */
        traveler.forEachTravelingActor(
            {actor: actor.noteConsultation(floorShelves)});
    }
;

travelIntoStacks: FakeConnector
    "Om du skulle tillåta dig att börja bläddra, är risken stor att du skulle
    bli helt uppslukad och spendera resten av dagen här. Du bör förmodligen försöka
    begränsa dig till endast specifika saker som du behöver slå upp. "
;

/* 
 *   A common mix-in for shelves and collections of books in the library.
 *   Both of these kinds of objects can accept returns of books that
 *   originally came from them. 
 */
class LibBookColl: object
    iobjFor(PutIn) asIobjFor(PutOn)
    iobjFor(PutOn)
    {
        verify()
        {
            if (gDobj != nil && !gDobj.ofKind(LibBook))
                illogical('Bokhyllorna är endast till för böcker. ');
        }
        check()
        {
            if (!bookBelongs(gDobj))
            {
                "Det hör inte hemma här; det skulle inte vara särskilt hänsynsfullt
                att röra till i bibliotekets ordning på det sättet. ";
                exit;
            }
        }
        action()
        {
            /* 
             *   putting something on the shelf that belongs there - which
             *   it must, if we made it this far - simply makes it join the
             *   collection by removing it from the game 
             */
            "Du lägger tillbaka {den/honom dobj} där du hittade {den/honom}. ";
            gDobj.moveInto(nil);
        }
    }

    /* does the given book belong in me? */
    bookBelongs(obj) { return obj.floorNum == floorNum; }
;

/* 
 *   A class for the bookshelves on a floor of the library.  We use a
 *   single object to represent all of the shelves on a floor collectively.
 */
class LibShelves: LibBookColl, Consultable, Fixture, Surface
    'golv-till-tak hylla+n/bokhylla+n/rad+en*bokhyllor+na hyllor+na rader+na'
    'rader av bokhyllor'
    "Bokhyllorna sträcker sig från golv till tak och är ordnade i
    rader som fyller hela våningen. "

    isPlural = true

    /* take my floor number from my location, which is the LibRoom object */
    floorNum = (location.floorNum)

    /* rank this low for LOOK IN, in case there's anything better */
    dobjFor(LookIn) { verify() { logicalRank(50, 'decoration'); } }
    lookInDesc = "Du kan inte tillåta dig att bli uppslukad i att bläddra;
        du skulle förmodligen blir kvar här hela dagen. Lyckligtvis är böckerna
        välorganiserade, så du kan förmodligen hitta allt specifikt
        du behöver slå upp utan alltför stor risk för att fastna i 
        oändliga-tidsfördriv-problemet. "

    topicNotFound() { "Du tror att du har förstått organisationsschemat
        som bibliotekarierna använder här, men du kan inte hitta
        det du letar efter. "; }

    /* on initialization, remember this object in my floor's Room */
    initializeThing()
    {
        inherited();
        location.floorShelves = self;
    }
;

/* 
 *   A class for the collections of books on the shelves in the library -
 *   this represents the whole collection of books for a floor of the
 *   library, not a single book.  Note that these go inside LibShelves
 *   objects.  
 */
class LibShelfBooks: Consultable, Fixture, Readable
    'text+en bok+en/lärobok+en/tidskrift+en*böcker+na texter+na läroböcker+na tidskrifter+na' 'böcker'

    isPlural = true

    /* our floor number comes from our enclosing shelves */
    floorNum = (location.floorNum)

    cannotPutMsg = 'Det finns för många böcker för att flytta alla. '

    dobjFor(Search) remapTo(LookIn, location)
    dobjFor(Examine) remapTo(LookIn, location)
    dobjFor(LookIn) remapTo(LookIn, location)
    dobjFor(Take) remapTo(LookIn, location)
    dobjFor(Read) remapTo(LookIn, location)

    dobjFor(Move)
    {
        verify() { }
        action() { 
            "Du gör några små justeringar av böckerna för 
            att rada upp dem lite snyggare."; }
    }
    dobjFor(Turn) asDobjFor(Move)
    dobjFor(Pull) asDobjFor(Move)
    dobjFor(Push) asDobjFor(Move)
    
    dobjFor(Consult) remapTo(Consult, location)
    dobjFor(ConsultAbout) remapTo(ConsultAbout, location, IndirectObject)
;

/*
 *   A class for a collection of periodicals.  We need an object to
 *   represent a collection of periodicals in case we want to LOOK UP
 *   VOLUME 7 IN QUANTUM REVIEW LETTERS, for example 
 */
class LibShelfColl: DisambigDeferrer, Consultable, SecretFixture
    cannotTakeMsg = 'Samlingen i sin helhet är för stor för att bära. '
    cannotMoveMsg = 'Samlingen i sin helhet är för stor för att flytta. '
    cannotPutMsg = (cannotMoveMsg)

    topicNotFound() { "Du ser inte det numret. "; }

    /* putting something in the collection just re-shelves the item */
    iobjFor(PutIn) remapTo(PutIn, DirectObject, location)
    iobjFor(PutOn) remapTo(PutOn, DirectObject, location)

    dobjFor(Read)
    {
        action() { "Det skulle ta veckor, kanske månader, att läsa igenom 
            hela samlingen. "; }
    }

    dobjFor(ConsultAbout)
    {
        verify()
        {
            /* 
             *   downplay our likelihood for matching; prefer the shelves
             *   as the default whenever it's ambiguous 
             */
            logicalRank(90, 'shelf subset');
            inherited();
        }
    }

    /* defer to any real object in a disambiguation situation */
    disambigDeferToObj(obj) { return obj != self; }
;

/* a class for an individual library book */
class LibBook: Readable
    /* the floor of the library where I belong */
    floorNum = nil

    /* 
     *   A list of all of the LibBooks in the game, for quick scanning.
     *   We'll build this automatically during initialization. 
     */
    allLibBooks = []

    /* class method: have any library books been found yet? */
    anyLibBookFound = (allLibBooks.indexWhich({x: x.moved}) != nil)

    /* class method: have ALL of the library books been found? */
    allLibBooksFound = (allLibBooks.indexWhich({x: !x.moved}) == nil)

    initializeThing()
    {
        /* do the normal work */
        inherited();

        /* 
         *   add myself to the master list of library books in the class
         *   (note that the list is in the class itself, not in the
         *   instance) 
         */
        LibBook.allLibBooks += self;
    }

    /* the player has checked this book out */
    isCheckedOut = nil

    dobjFor(Examine)
    {
        action()
        {
            /* do the normal work */
            inherited();

            /* if it's checked out, say so */
            if (isCheckedOut)
                "<.p>En gummistämpel visar att du har lånat
                den här boken. ";
        }
    }

    /* LOOK IN and OPEN == read */
    dobjFor(LookIn) asDobjFor(Read)
    dobjFor(Open) asDobjFor(Read)

    /* for check-out purposes, my singular and plural generic names */
    coName = 'en bok'
    coPluralName = 'några böcker'

    /* receive notification that we're finding the book */
    notifyFound() { }
;

/* an "unbook," representing the absence of a book until it's found */
class LibUnbook: Unthing
    desc() { say(notHereMsg); }
    notHereMsg = 'Du ser inte den ligga framme, men det finns
        många böcker här, så du kanske kan hitta den om
        du letar efter den. '
;

/* a class for a topic that represents a search for a particular book */
class LibBookTopic: ConsultTopic
    /* my actual LibBook object */
    myBook = nil

    /* the vague generic name for this object (book, magazine, etc) */
    vagueName = 'bok'

    topicResponse()
    {
        if (myBook.location == nil)
        {
            /* move it into the shelf */
            myBook.makePresent();

            /* notify the book that we're finding it */
            myBook.notifyFound();
            
            /* 
             *   mention that we found it, and that we took it (if taking
             *   it in fact succeeded) 
             */
            "Du skannar genom hyllorna och hittar vad du
            söker efter: <<myBook.theName>>. ";

            /* take it */
            nestedAction(Take, myBook);

            /* make it 'it' */
            gActor.setIt(myBook);

            /* if we got it, say so */
            if (myBook.isIn(gActor))
                "Du tar <<vagueName>>en från hyllan. ";
        }
        else
            "Du hittar platsen där den där <<vagueName>>en borde vara, men
            den har tagits bort. ";
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   Second floor 
 */
millikan2: LibRoom
    floorNum = 2
    subjectMatter = 'kemi, och innehåller även bibliotekets samling 
        av tidskrifter'
    north: LibElevatorDoor { }
;
+ LibElevatorUpButton;
+ LibElevatorDownButton;

/*
 *   The object structure for the bookshelves and books is a little
 *   complicated, so some explanation is in order.
 *   
 *   First, we have the LibShelves object itself, and it contains a
 *   LibShelfBooks object.  This is the same as for any floor - this lets
 *   us look at the shelves and at the books, search the books, and so on.
 *   These objects don't do very much; their main purpose is to direct the
 *   player to LOOK UP the specific information required.  The
 *   LibShelfBooks object redirects any LOOK UP commands to its container,
 *   the LibShelves object, so we only have to worry about a ConsultTopic
 *   database for the shelves.  Note one small extra bit on this floor is
 *   that we give the LibShelfBooks vocabulary for 'periodicals' and
 *   'magazines' in addition to the standard 'books' and so on.
 *   
 *   Within the LibShelves object, then, we add the ConsultTopic items for
 *   the things we can find here.  There's a special issue of "Science &
 *   Progress Magazine" that we can find here, so we have a ConsultTopic
 *   for the specific issue, identified by its unique issue number.  We
 *   also have a separate ConsultTopic that matches Science & Progress
 *   generically, when no issue number is specified; we include this so
 *   that a search for S&P generically turns up what we describe as a
 *   collection of issues.
 *   
 *   Now, we also create a LibShelfColl object that represents the S&P
 *   collection.  This isn't a topic - it's a real object on the shelves.
 *   LibShelfColl is largely hidden from view; it's here only so that a
 *   specific look at the issues won't respond with a nonsensical "you
 *   don't see that here" error.  In particular, having found the generic
 *   bunch of issues, the player might want to LOOK UP the specific issue
 *   in the collection, rather than in the whole set of shelves.  To handle
 *   this, the LibShelfColl is itself a Consultable, and we make it contain
 *   a separate copy of the specific-issue topic.
 *   
 *   Because we have two copies of the specific-issue ConsultTopic, we
 *   create a class for this topic, and then put one instance of the class
 *   in the shelves and another instance in the LibShelfColl collection.
 *   This ensures that we can search either place and turn up the right
 *   object.  We could have achieved much the same effect by redirecting
 *   LOOK UP from the LibShelfColl to the shelves, exactly as we do from
 *   the LibShelfBooks; the only reason not to go that route is that we
 *   could then LOOK UP *anything* in the "S&P magazines" collection.
 *   Probably no one would ever notice, but still.
 *   
 *   Two more small details.  First, we have the object for our specific
 *   issue itself, of course - this pops into existence when we
 *   successfully LOOK UP the issue.  Second, we have another object that
 *   looks just like the specific issue, but is a LibUnbook object; the
 *   only purpose of this object is to respond to commands on the special
 *   issue before the special issue object has been found.  If the player
 *   says GET <issue>, we don't want to say "you don't see that here" -
 *   it's not that we don't see it here, but rather that we might or might
 *   not see it among all the other stuff.  The LibUnbook object is there
 *   simply to improve the response messages for these cases.  
 */

+ LibShelves;
++ LibShelfBooks 'kemi tidskrifter+na/magasin+en';

/* 
 *   A generic item, to match searches for S&P without a specific issue.
 *   Match this at a higher-than-default level, so that we'll match it
 *   whenever possible.  A match is only possible when the player uses only
 *   generic words (no issue number), since we don't have the issue number
 *   among our vocabulary.  When only generic words are present, we want to
 *   match this generic response instead of an issue-specific topic. 
 */
++ ConsultTopic +110 [sAndPTopic, sAndPs]
    "Du hittar en samling av <i>Vetenskap &amp; Framsteg</i> som sträcker sig
    flera årtionden tillbaka. De är alla i ordning, så det skulle vara
    lätt att hitta ett nummer om du vet numret."
;

/* 
 *   create a class for the special issue, so we can put instances both in
 *   the shelves and in the specific magazine collection 
 */
class SAndPEntry: LibBookTopic @sAndP3Topic
    myBook = sAndP
    vagueName = 'nummer'
;
++ SAndPEntry;

/* an object for the whole collection of Science & Progress */
++ sAndPs: LibShelfColl
    'vetenskap & framsteg v&f vetenskap&framsteg samling+en*tidskrifter+na'
    'samling av <i>Vetenskap &amp; Framsteg</i>'
    "Samlingen av tidskriften sträcker sig årtionden tillbaka."
;
+++ SAndPEntry;

/* an Unbook for the P&S, in case we try to take it before finding it */
++ LibUnbook
    'vetenskap & framsteg vetenskap&framsteg v&f num:mer+ret utgåva+n
    xlvi-3/tidskrift+en'
;

/* 
 *   the tangible game object for the special issue itself - this pops
 *   into existence when we look it up successfully 
 */
++ sAndP: PresentLater, LibBook
    'vetenskap & framsteg vetenskap&framsteg v&f tidskrift+en num:mer+ret utgåva+n
    xlvi-3/tidskrift+en'
    '<i>Vetenskap &amp; Framsteg</i> nummer XLVI-3'
    "<i>V&amp;F</i> är en av dina favoriter, åtminstone när du kan hitta
    tid att läsa den."

    /* my check-out names */
    coName = 'en tidskrift'
    coPluralName = 'några tidskrifter'

    readDesc = "Du bläddrar igenom detta nummer och hittar artikeln
        som refereras i Stamers uppsats: <q>Bortom Köpenhamn: Den
        Kvant/Klassiska Övergången.</q>
        <.p>Artikeln handlar om en irriterande svaghet i <q>Köpenhamns-
        tolkningen</q> av kvantmekanik. Du hade inte hört termen
        tidigare, men tydligen syftar den på den vanliga QM-modellen, vilket
        i huvudsak är vad du lärde dig i Fysik 2. En viktig del av
        Köpenhamnsdoktrinen är idén att ett kvantsystem utvecklas på
        sitt bisarra kvantvis tills någon observerar systemet, vid
        vilken tidpunkt den kvantmekaniska vågfunktionen <q>kollapsar</q>
        och systemet blir klassiskt deterministiskt. Problemet,
        verkar det som, är att det inte finns någon rigorös definition av 
        vad det betyder att <q>observera</q> systemet.
        <.p><q>En idé är att en medveten observatör krävs, men de flesta
        forskare gillar inte denna eftersom den bara ersätter en
        illa definierad term med en ännu sämre definierad, och dessutom
        luktar det metafysik. Den vanliga uppfattningen är att interaktion
        med <q>bulkmateria</q> är vad som utgör en mätning. Det
        låter åtminstone som en solid, okomplicerad, vetenskaplig definition,
        men det är fortfarande lite av en undanflykt: pratar vi om ett dussin 
        atomer eller en kvadriljon? Ingen kan svara. Och många nya 
        experiment ifrågasätter hela idén genom att visa att vissa exotiska
        typer av stora ensemblesystem kan uppvisa kvantbeteende under
        långa perioder, så enbart <q>bulk</q> kan inte vara nyckeln.</q>
        <.p>Artikeln påpekar att de flesta forskare är villiga att leva
        med en luddig definition i en teori som är så empiriskt framgångsrik,
        men några fysiker finner det tillräckligt bekymmersamt för att leta 
        efter ett bättre svar på denna nyckelfråga. Artikeln undersöker 
        några av de föreslagna alternativen till Köpenhamnstolkningen, 
        med namn som Många Världar, Dolda Variabler och Transaktionell.
        Den talar också om några lovande nya arbeten som ramar in
        kvant/klassisk-övergången i termer av <q>dekoherens</q>
        av vågfunktionen. Denna idé är baserad på vågteori som
        kom fram ur uppfinningen av lasern; den säger att kvantsystem
        blir klassiska system när deras vågfunktioner
        interagerar på specifika sätt med vågfunktionerna hos andra
        system, vilket orsakar att vågfunktionerna förlorar sin
        koherens---deras förmåga att superponera flera kvant-
        tillstånd samtidigt.
        <<researchReport.checkComprehension('decoherence')>> "

    /* we're named by title, which is proper */
    isProperName = true

    /* we belong on the second floor (periodicals) */
    floorNum = 2
;

/*
 *   If we try to look up any Quantum Review Letters here, we'll point out
 *   that these are usually on 6.  This is a reasonable place to think to
 *   look for a journal, as it's a periodical of a sort.  
 */
++ ConsultTopic +110 [qrlTopic, qrls,
                      qrl7011c, qrl7011cTopic,
                      qrl739a, qrl739aTopic]
    "Du hittar inte <i>Quantum Review Letters</i> någonstans på
    hyllorna här. Du minns att de brukar ha tidskrifter på
    ämnesvåningarna snarare än med tidskrifterna, så den
    är förmodligen med fysikböckerna."
;

/*
 *   Create a special grammar rule for "science and progress" as an
 *   adjective.  The word "and" is normally taken to be a grammatical
 *   token, and we don't really want to introduce it as an actual adjective
 *   for fear of complicated interactions with the rest of the grammar.
 *   So, we'll instead define a custom rule that makes the entire phrase
 *   "science and progress" look like an adjective.  For simplicity, we'll
 *   match vocabulary for the token "s&p", which all of the relevant
 *   objects define as adjectives anyway.  
 */
grammar adjWord(sAndP): 'vetenskap' 'och' 'framsteg'
    : NounPhraseWithVocab

    getVocabMatchList(resolver, results, extraFlags)
    {
        //return getWordMatches('s&p', &adjective, resolver,
        //                      extraFlags, VocabTruncated);
        return getWordMatches('v&f', &adjective, resolver,
                              extraFlags, VocabTruncated);
    }

    getAdjustedTokens()
    {
        return ['vetenskap', &adjective, 'och', &adjective,
                'framsteg', &adjective];
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   Third floor 
 */
millikan3: LibRoom
    floorNum = 3
    subjectMatter = 'elektroteknik'
    north: LibElevatorDoor { }
;
+ LibElevatorUpButton;
+ LibElevatorDownButton;
+ LibShelves;
++ LibShelfBooks 'elektroteknikiska elektroteknik+en ee et-'; 

/* 
 *   A topic for "ee textbooks" in general - score this higher than default
 *   so that it will overshadow any more specific match object when only
 *   the vague terms are used.  (We can't match unless only vague terms are
 *   used, so when we do match, we want to select this match rather than
 *   any more specific object.  The specific objects match the vague terms,
 *   too, but they also match special terms describing them only.)  
 */
++ ConsultTopic +110 @eeTextTopic
    "Det finns i princip inget annat än Elektroteknikläroböcker här. Det skulle 
    ta hela dagen att titta på ens en liten bråkdel av dem, och de flesta 
    är så specialiserade att man sannolikt inte lär sig särskilt mycket 
    genom att bara bläddra. Å andra sidan, om du har en specifik bok 
    i åtanke, skulle du kunna hitta den ganska lätt. <<mentionRec>> "

    /* 
     *   mention that we could use a recommendation from somebody, if we've
     *   revealed the need for a textbook 
     */
    mentionRec()
    {
        if (gRevealed('need-ee-text') && !gRevealed('morgen-book'))
            //"<.p>You don't have any ideas for EE texts to look at.
            //Maybe you could ask someone for a recommendation. ";

            "<.p>Du har inga idéer om vilka Elektroktekniktexter du behöver titta i.
            Det kanske finns någon att fråga om efter en rekommendation. ";

    }
;

/* an Unbook for the Morgen text */
++ morgenUnbook: LibUnbook 'yves morgen elektronisk föreläsningar elektronik+bok+en/lärobok+en'
    'Morgens lärobok'
;

/* a topic for looking up the Morgen text */
++ LibBookTopic [morgenTopic, morgenBook, morgenUnbook]
    myBook = morgenBook
;

/* the Morgen text itself */
++ morgenBook: PresentLater, LibBook
    'yves morgen elektronik elektroteknik+en föreläsning+ar 
    text+bok+en/lärobok+en*böcker+na*texter+na*läroböcker+na'
    '<i>Elektronikföreläsningar</i> lärobok'
    "Det är en tjock lärobok av Yves Morgen, med titeln
    <i>Elektronikföreläsningar</i>. "
    isRead = nil
    readDesc()
    {

        if (isRead)
            "Du bläddrar snabbt genom boken, men du känner att
            du redan har absorberat så mycket teori som du kan
            för tillfället.
            <.p>I bokens inledande del noterar du en referens
            till en tillhörande laborationsmanual av E.J.\ Townsend. ";
        else
        {
            "Du öppnar boken och börjar läsa. Till en början verkar den
            lite tung på matematiken, men när du kommer längre in
            börjar du känna igen de vanliga byggstenarna---Fourierserier,
            Laplacetransformer, partiella differentialekvationer.
            Du är glad att upptäcka att begreppen och matematiken
            är mindre avlägsna i ditt minne än du trodde.
            <.p>Du fortsätter läsa, skummar igenom vissa delar men
            saktar ner för att smälta andra. Så småningom börjar dina ögon 
            bli lite glasartade, och du inser att du har 
            <<me.posture.pastTense>> här och läst ett bra tag.
            Du bestämmer dig för att du har 
            absorberat ungefär så mycket teori som du kan för tillfället; 
            vad du egentligen behöver nu är något lite mer praktiskt. 
            Du lägger märke till en hänvisning i bokens framsida till 
            en medföljande labmanual av E.J.\ Townsend; det kan vara värt 
            att titta på.";

            /* 
             *   this counts as an event on the game clock, since we spend
             *   a significant amount of time reading 
             */
            readPlotEvent.eventReached();

            /* score some points for this as well */
            readMarker.awardPointsOnce();

            /* we've now read it */
            isRead = true;
        }
    }

    /* a game-clock event for having read the book */
    readPlotEvent: ClockEvent { eventTime = [2, 10, 18] }

    cannotConsultMsg = 'Den här boken är förmodligen mycket mer 
        användbar om du bara läser igenom den. Läroböcker som denna 
        brukar inte vara särskilt bra som snabbreferenser.'
    /* 
     *   we need to do this manually because the <i> tag at the start of
     *   the name throws off the automatic sensing algorithm 
     */
    aName = ('en ' + name)

    /* we belong on the EE floor */
    floorNum = 3

    /* a score marker for getting the recommendation for this book */
    recMarker: Achievement { +2 "få en rekommendation av en ET-bok" }

    /* a score marker for finding the book */
    readMarker: Achievement { +1 "läst ET-läroboken" }
;

/* 
 *   a generic "lab manuals" topic - score this high so that it will
 *   overshadow a more specific match when only the vague terms are entered
 */
++ ConsultTopic +110 @labManualTopic
    "Det finns många ET-labbmanualer blandade med läroböckerna;
    det skulle ta för lång tid att bläddra igenom alla, men du kan förmodligen
    hitta en specifik om du vet författaren."
;

++ townsendUnbook: LibUnbook 'e.j. townsend lab laboratorium manual'
    'Townsends labbmanual'
;
++ LibBookTopic [townsendTopic, townsendBook, townsendUnbook]
    myBook = townsendBook
;
++ townsendBook: PresentLater, LibBook, Consultable
    'e.j. townsend lab labb+et laboratorium+et stor+a mjukpärm+en manual+en/bok+en*böcker+na*manualer+na'
    'labb+manual+en'
    "Det är en stor bok med mjuk pärm. Den här typen av bok innehåller
    labbövningar som demonstrerar olika elektronikprinciper."

    readDesc = "Du tittar igenom bokens olika labbövningar.
        Var och en skulle ta några timmar att arbeta igenom, och de
        kräver alla viss specifik utrustning, så du kommer inte att
        få ut mycket av att bara bläddra. Det verkar som att det skulle vara en bra
        referens att ha till hands när man faktiskt arbetar med kretsar,
        dock---du skulle kunna slå upp saker efter behov."

    /* on finding this book, award some points */
    notifyFound() { foundMarker.awardPointsOnce(); }

    /* we belong on the EE floor */
    floorNum = 3

    /* points for finding the Townsend book */
    foundMarker: Achievement { +2 "hittat en ET-labbmanual" }
;
+++ ConsultTopic @waveformTopic
    "Boken har många vågformsdiagram, men du hittar inget
    som är direkt tillämpbart på det du letar efter."
;

/* the video amp lab */
+++ ConsultTopic @videoAmpTopic
    "Du hittar en labbövning om videoförstärkare och skummar igenom den
    snabbt. Det är bra att veta att den finns här ifall du behöver
    detaljer om den här typen av saker vid något annat tillfälle."
;
++++ AltTopic, StopEventList
    ['Du hittar en hel labbövning om videoförstärkare. Du går igenom
    den noggrant och fräschar upp ditt minne om hur dessa saker fungerar.
    Du når slutet av avsnittet och känner att du har en bra
    uppfattning om hur man hanterar den här typen av krets nu.
    <.reveal read-video-amp-lab> ',
     'Du skummar snabbt igenom videoförstärkarlabbet igen.']

    /* we only read this thoroughly once we know we need it */
    isActive = (gRevealed('need-video-amp-lab'))
;

/* the 1A80 lab */
+++ ConsultTopic @the1a80Topic
    "Boken har en ganska bra uppsättning information om denna tidiga 80-tals
    CPU. Du minns att du arbetade med dessa några gånger för många år sedan.
    Du noterar avsnittet för framtida referens, för den osannolika händelsen
    att du behöver veta om 1A80:or vid något tillfälle."
;
++++ AltTopic, StopEventList
    ['Du hittar ett ganska bra avsnitt om 1A80, med detaljer om
    pin-konfigurationen och elektriska egenskaper. Detta är ett mycket
    enkelt chip enligt moderna standarder, och det tar inte lång tid
    för dig att bekanta dig med det igen.
    <.reveal read-1a80-lab> ',
     'Du går snabbt igenom 1A80-materialet igen.']

    /* we only read this thoroughly once we know we need it */
    isActive = (gRevealed('need-1a80-lab'))
;

+++ DefaultConsultTopic
    "Du tittar igenom indexet, men du hittar inte det du
    letar efter."
;

/* ------------------------------------------------------------------------ */
/*
 *   Fourth floor 
 */
millikan4: LibRoom
    floorNum = 4
    subjectMatter = 'aeronautik och materialvetenskap'
    north: LibElevatorDoor { }
;
+ LibElevatorUpButton;
+ LibElevatorDownButton;
+ LibShelves;
++ LibShelfBooks 'aeronautik materialvetenskap -';

/* ------------------------------------------------------------------------ */
/*
 *   Fifth floor 
 */
millikan5: LibRoom
    floorNum = 5
    subjectMatter = 'astronomi'
    north: LibElevatorDoor { }
;
+ LibElevatorUpButton;
+ LibElevatorDownButton;
+ LibShelves;
++ LibShelfBooks 'astronomi astrofysik -';

/* ------------------------------------------------------------------------ */
/*
 *   A list group for the Quantum Review Letters issues.  This tidies the
 *   list a bit by keeping the related items together. 
 */
qrlListGroup: ListGroupPrefixSuffix
    groupPrefix = "nummer "
    groupSuffix = " av <i>Quantum Review Letters</i>"

    /* just show the issue number for an item within the group sub-list */
    showGroupItem(sublister, obj, options, pov, infoTab)
        {  say(obj.qrlIssueName); }

    /*
     *   We don't enclose our sublist in parentheses, but we do set it off
     *   pretty clearly from the enclosing list by our phrasing, so there's
     *   little risk of the two lists looking like they run together
     *   confusingly.  
     */
    groupDisplaysSublist = nil
;

/* ------------------------------------------------------------------------ */
/*
 *   Sixth floor 
 */
millikan6: LibRoom
    floorNum = 6
    subjectMatter = 'matematik och fysik'
    north: LibElevatorDoor { }
;
+ LibElevatorUpButton;
+ LibElevatorDownButton;

/*
 *   We have exactly the same slightly tricky object structure on this
 *   floor as for the second floor.  See the comments for millikan2 for
 *   details on what these various objects are for.  
 */

+ LibShelves;
++ LibShelfBooks 'fysik -';

/* 
 *   A topic for the generic 'quantum review letters'.  Match more strongly
 *   than the default, so that if we match - which is possible only with
 *   generic words, not with an issue number - we'll override any other
 *   matches that have specific issue numbers. 
 */
++ ConsultTopic +110 [qrlTopic, qrls]
    "Du hittar var de förvarar samlingen av <i>Quantum Review
    Letters</i>---hyllor, hyllor och åter hyllor av dem.
    De är alla prydligt organiserade, så det skulle vara lätt
    att hitta ett specifikt nummer."
;
++ ConsultTopic +109 [qrlVolumeTopic, qrls]
    "Du hittar var de förvarar <i>Quantum Review Letters</i>-samlingen,
    och du hittar rätt volym, men det finns många enskilda nummer.
    De är prydligt organiserade, så det skulle vara lätt 
    att hitta ett specifikt nummer."
;

/* 
 *   create a class for our special issues, so that we can put instances
 *   both in the shelves and in the collection of this journal 
 */
class Qrl7011cEntry: LibBookTopic @qrl7011cTopic
    myBook = qrl7011c
    vagueName = 'nummer'
;
class Qrl739aEntry: LibBookTopic @qrl739aTopic
    myBook = qrl739a
    vagueName = 'nummer'
;
++ Qrl7011cEntry;
++ Qrl739aEntry;

/* an object for the whole collection of Quantum Review Letters */
++ qrls: LibShelfColl
    'quantum review letters/samling+en/tidskrift+en/qrl'
    'samling av <i>Quantum Review Letters</i>'
    "Flera hyllor är fyllda med nummer av denna tidskrift."
;
+++ Qrl7011cEntry;
+++ Qrl739aEntry;

/* an Unbook for QRL 70:11c, for when we're not here */
++ LibUnbook 'quantum review letters tidskrift+en qrl nummer numret 70:11c/qrl';

/* 
 *   the tangible game object for our special issue - this pops into
 *   existence when we successfully look it up 
 */
++ qrl7011c: PresentLater, LibBook
    'quantum review letters tidskrift+en qrl nummer numret
    70:11c/brev+et/tidskrift+en/nummer/qrl*tidskrifter+na numren+a qlrs'
    '<i>Quantum Review Letters</i> nummer 70:11c'
    "Som de flesta vetenskapliga tidskrifter ser den mer ut som en pocketbok
    än en tidskrift; bara vanlig text på vanligt vitt papper, fylld med
    fackspråk och ekvationer."

    /* we have more than one of these, so list them together */
    listWith = [qrlListGroup]
    qrlIssueName = '70:11c'

    /* my check-out names */
    coName = 'en tidskrift'
    coPluralName = 'några tidskrifter'

    readDesc = "Du bläddrar förbi en massa artiklar som ser ogenomträngliga ut,
        och hittar den som nämns i Stamers uppsats: <q>Dekoherens-
        tolerans i Kvantberäkning.</q> Den är skriven av en annan forskningsgrupp från Caltech.
        <.p>Artikeln är inte direkt lättläst. Den handlar om några av
        problemen med att bygga kvantdatorer---datorer
        som utnyttjar ett kvantsystems förmåga att vara i många tillstånd
        samtidigt för att snabbt utföra beräkningar som är extremt långsamma
        på konventionella datorer. Ett av de största praktiska problemen
        med att bygga kvantdatorer, förklarar artikeln, är
        svårigheten att isolera ett kvantsystem tillräckligt väl för att det
        ska förbli ett kvantsystem tillräckligt länge för att slutföra sin
        beräkning. Om systemet inte är tillräckligt väl isolerat,
        kommer interaktioner med dess omgivning att orsaka <q>dekoherens,</q>
        vilket förstör kvanteffekterna. Ännu mer problematiskt är
        självinteraktionen som uppstår när man skalar upp en kvantdator
        till den punkt där den kan utföra användbara beräkningar i verkliga 
        världen: datorns kvantelement börjar faktiskt interagera med
        varandra tillräckligt starkt för att orsaka dekoherens.
        <.p>Huvuddelen av artikeln föreslår några sätt att kringgå
        självinteraktionsproblemet, genom att anta några av de egenskaper hos
        konventionella datorer som gör dem mer feltolerant. Ett
        förslag är att koda information i kvanttillståndet med hjälp av
        felkorrigerande koder, så att en förlust av koherens i en del
        av systemet kan kompenseras av de andra delarna. Ett annat
        förslag---och detta fångar din uppmärksamhet, eftersom Stamers uppsats
        hade detta i titeln---är att <q>spinn-dekorrelation</q> kan
        användas för att delvis isolera systemet internt och från dess
        omgivning. Artikeln börjar med tät matematik vid den punkten,
        så du skummar mest över resten.
        <<researchReport.checkComprehension('spin-decorr')>> "

    /* we're named by title, which is proper */
    isProperName = true

    /* we belong on floor 6 (physics) */
    floorNum = 6
;


/* an Unbook for issue 73:9a, for when we're not here */
++ LibUnbook 'quantum review letters qrl tidskrift+en nummer numret 73:9a/qrl';

/* the actual QRL 73:9a */
++ qrl739a: PresentLater, LibBook
    'quantum review letters qrl tidskrift+en nummer numret
    73:9a/brev+et/tidskrift+en/nummer+et/qrl*tidskrifter+na*nummer*qrls'
    '<i>Quantum Review Letters</i> nummer 73:9a'
    "Som de flesta vetenskapliga tidskrifter ser den mer ut som en pocketbok
    än en tidskrift; bara vanlig text på vanligt vitt papper, fylld med
    fackspråk och ekvationer. "

    /* we have more than one of these, so list them together */
    listWith = [qrlListGroup]
    qrlIssueName = '73:9a'

    /* my check-out names */
    coName = 'en tidskrift'
    coPluralName = 'några tidskrifter'

    readDesc = "Du hittar Stamers grupps artikel: <q>Tillämpningar
        av Icke-dekoherenta Heterogena Bulkensembler.</q>
        <.p>Artikeln talar om ett antal möjliga tillämpningar
        av dekoherenssuppression, men huvudpoängen är att det
        skulle kunna ge ett helt ny tillvägagångssätt att bygga kvantdatorer.
        <.p><q>I princip, om vi lyckas undertrycka
        dekoherens i bulkmateria, skulle vi kunna skapa en effektiv
        kvantdator som en superposition av tillstånd hos en
        <i>vanlig</i> dator, som en PC, eller till och med en fick-
        räknare... Naturligtvis skulle speciella algoritmer behöva
        utformas för en sådan enhet. Beräkningen måste bestå av
        en serie unitära transformationer. I den slutliga tillståndsvektorn
        måste komponenterna som representerar felaktiga resultat ta ut varandra,
        och det korrekta resultatet måste förstärkas via konstruktiv
        interferens... Att mappa en konventionell algoritm till vår hybrid av
        kvant/konventionella dator är förvånansvärt enkelt,
        som vi kommer att visa...</q>
        <.p>Artikeln går igenom ett utförligt exempel som visar hur
        man använder tekniken för att hitta primfaktorerna av ett stort
        heltal. Talteorin är lite över din nivå, men
        det intressanta är hur enkelt programmet är; det är bara
        en serie enkla aritmetiska steg som skulle ta några
        sekunder att köra i kvantläge. På en vanlig dator tar
        faktorisering av stora heltal naturligtvis enorma mängder
        tid. <q>Denna teknik är inte begränsad till primtalsfaktorisering,</q>
        tillägger artikeln. <q>Metoderna vi har visat här skulle lika gärna
        kunna tillämpas på andra konventionellt superpolynomiella tidsproblem:
        diskreta logaritmer, Hovarthfunktioner, etc.</q>
        <.reveal qc-calculator-technique> "

    /* we're named by title, which is proper */
    isProperName = true

    /* we belong on floor 6 (physics) */
    floorNum = 6
;

/* 
 *   A topic for physics texts generally - score this higher than the
 *   default, so that if we match this and something more specific, we'll
 *   prefer this to the more specific match.  We don't want the more
 *   specific match in these cases because, if we match this generic one,
 *   then we've only matched the more specific one because the more
 *   specific one shares some of our generic words.  We only want to match
 *   the specific ones when we refer to them with their own unique words.  
 */
++ ConsultTopic +110 @physicsTextTopic
    "Eftersom detta är fysikavdelningen i biblioteket finns det massor av
    fysikböcker här; det skulle ta hela dagen att titta på dem alla.
    Om du har en specifik författare i åtanke skulle du förmodligen kunna hitta
    boken ganska lätt. "
;

/* a topic for the Bloemner book */
++ LibBookTopic [bloemnerTopic, bloemnerBook, bloemnerUnbook]
    myBook = bloemnerBook
;

/* the Bloemner book itself */
++ bloemnerBook: PresentLater, LibBook
    'lärobok textbok av
    blomner bloemner bl\u00F6mner blomners bloemners bl\u00F6mners
    introduktion till kvantfysik
    bok+en/text+en/lärobok*böcker+na texter+na läroböcker+na'
    '<i>Introduktion till kvantfysik</i> lärobok'
    "Dieter Bl&ouml;mner: <i>Introduktion till kvantfysik.</i> Detta
    är en av texterna de använde i Fy 2 när du var här; skräcken
    kommer tillbaka bara av att titta på den. "

    readDesc = "Du hittar kapitlet Stamer nämnde och börjar läsa.
        <.p>När du går igenom materialet upptäcker du att du faktiskt kommer ihåg
        en hel del av det. Allt det bisarra om hur subatomära
        partiklar beter sig som både vågor och partiklar samtidigt, hur
        en partikel kan vara i en <q>superposition</q> av flera tillstånd på
        en gång, hur en egenskap hos en partikel inte bestäms förrän någon
        mäter den. Du hoppar över ekvationerna, men du lyckas ändå
        få en kvalitativ förståelse för begreppen.
        <.p>Kapitlet avslutas med en diskussion om de filosofiska
        frågor som KM väcker. Ett stort mysterium är den märkliga dualiteten
        i naturen: att system ibland beter sig enligt kvant-
        mekanik och ibland enligt klassisk mekanik. Till och med
        samma system beter sig på båda sätt: ett kvantsystem har sitt märkliga
        kvantbeteende, där dess verklighet bara är en sannolikhets-
        fördelning---men bara tills någon mäter systemets
        egenskaper. Att mäta en egenskap hos systemet <q>kollapsar
        vågfunktionen,</q> och förvandlar det till ett klassiskt, deterministiskt system.
        <q>Kvantmekaniken trotsar högljutt vår intuition,</q> skriver Herr
        Professor Bl&ouml;mner, <q>men det är bara vår mänskliga
        arrogans som får oss att förvänta oss att det skulle vara annorlunda. För
        varför skulle vår intuition, som utvecklats för att tolka de definitivt
        icke-kvantfenomen i våra förfäders primitiva miljö,
        ha någon tillämpning i detta exotiska rike? Vi måste
        lära oss att skoningslöst krossa detta inre motstånd, att böja vår
        intuition för Naturens järnvilja.</q>
        <<researchReport.checkComprehension('QM-intro')>> "

    /* 
     *   we need to do this manually because the <i> tag at the start of
     *   the name throws off the automatic sensing algorithm 
     */
    aName = ('en ' + name)

    /* we belond on the physics floor */
    floorNum = 6
;

/* an unbook for Bloemner */
++ bloemnerUnbook: LibUnbook
    'av blomner bloemner bl\u00F6mner blomners bloemners bl\u00F6mners
    introduktion till kvantfysik text bok/lärobok'
    'Bl&ouml;mner lärobok'
;

/* an Unbook for the DRD tables */
++ drdUnbook: LibUnbook
    'drd matte matematik matematisk+a funktion+en/tabell+en/handbok+en/bok+en*funktioner+na böcker+na tabeller+na'
    'DRD Handbok'
;

/* a topic for looking up the DRD tables */
++ LibBookTopic [drdTopic, drdBook, drdUnbook]
    myBook = drdBook
;

/* the DRD Tables book itself */
++ drdBook: PresentLater, LibBook, Consultable
    'drd matte matematik matematisk+a funktion+en/tabell+en/handbok+en/bok+en*funktioner+na böcker+na tabeller+na'
    'DRD Handbok'
    "<i>DRD Handbok över matematiska funktioner</i> var en ständig
    följeslagare under ditt tredje och fjärde år. Den är full av tabeller med
    förberäknade värden för obskyra funktioner som inte ens de mest
    avancerade räknare täcker. Det är en extremt tjock bok,
    men den är indexerad för enkel referens till specifika funktioner. "

    /* we belong on the math & physics floor */
    floorNum = 6
;

+++ ConsultTopic @hovarthTopic
    "Du hittar avsnittet i boken. Det finns en kort introduktion,
    följt av en sida med formler, och sedan en lång tabell med värden.
    <.blockquote>
    Hovarthfunktioner (uppkallade efter Wilma Hovarth, 1806-1892) är en
    klass av transcendentala funktioner baserade på integraltransformationer,
    med tillämpningar inom fysik och (nyligen) kryptografi. Den
    allmänna familjen av funktioner betecknas konventionellt
    <b>Hov<sub>[<i>g,k</i>]</sub>(</b><i>n</i><b>)</b>,
    där <i>g</i> och <i>k</i> är heltal som anger de större och mindre
    koefficienterna, respektive. Den vanligaste medlemmen,
    <b>Hov<sub>[<i>0,0</i>]</sub>(</b><i>n</i><b>)</b>, är
    vanligtvis betecknad helt enkelt som <b>Hovarth(</b><i>n</i><b>)</b>.
    <.p><b>Hov<sub>[<i>0,0</i>]</sub>(</b><i>n</i><b>)</b>
    kan beräknas analytiskt för <i>n</i> = 0, 1, --1, <i>e</i>, och
    <i>--e</i>. För andra värden på <i>n</i> kan funktionen inte
    reduceras analytiskt, så den måste beräknas numeriskt (t.ex. med
    Taylorserie). Tyvärr konvergerar alla kända serierepresentationer
    extremt långsamt, så funktionen är beräkningsmässigt
    ohanterlig för stora <i>n</i>. I skrivande stund 
    (<<getTime(GetTimeDateAndTime)[1]-1>>), har Hovarthtalen
    upp till ungefär <i>n</i> = 300 000 beräknats. Värden upp till
    <i>n</i> = 2 000 är tabellerade nedan.
    <./blockquote>
    <.p>Under introduktionen ges den allmänna formeln för familjen
    av funktioner, och sedan de specifika formlerna för några
    av koefficientvärdena. Funktionerna är alla komplicerade
    integraler; det är lätt att tro att det inte finns något sätt att
    lösa någon av dessa analytiskt.
    <<extraNotes>>
    <.reveal drd-hovarth> "

    /* extra notes, depending on how far we've gotten */
    extraNotes()
    {
        if (gRevealed('hovarth'))
            "Tyvärr går tabellen inte alls tillräckligt högt för
            dina behov---detta kommer uppenbarligen inte att bli så trivialt
            som du trodde. Du kommer att behöva hitta något sätt
            att beräkna numret.
            <.p>Du skannar formeln, och den är inte alls enkel.
            Det är definitivt inte ett program du skulle vilja skriva själv. ";
    }
;

+++ DefaultConsultTopic
    "Du skannar indexet i slutet av DRD, men du ser inte det. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Seventh floor 
 */
millikan7: LibRoom
    floorNum = 7
    subjectMatter = 'biologi'
    north: LibElevatorDoor { }
;
+ LibElevatorUpButton;
+ LibElevatorDownButton;
+ LibShelves;
++ LibShelfBooks 'bio biologi -';

/* ------------------------------------------------------------------------ */
/*
 *   Eighth floor 
 */
millikan8: LibRoom
    floorNum = 8
    subjectMatter = 'datavetenskap'
    north: LibElevatorDoor { }
;
+ LibElevatorUpButton;
+ LibElevatorDownButton;
+ LibShelves;
++ LibShelfBooks 'cs datavetenskap -';

/* ------------------------------------------------------------------------ */
/*
 *   Ninth floor 
 */
millikan9: LibRoom
    floorNum = 9
    subjectMatter = 'geologi'
    north: LibElevatorDoor { }
;
+ LibElevatorDownButton;
+ LibShelves;
++ LibShelfBooks 'geologi -';

