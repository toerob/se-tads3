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
    'shiny metal sliding elevator lift door/doors/elevator/lift' 'elevator'
    "The elevator's sliding doors are made of a shiny metal. <<buttonDesc>> "

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
    openStatus = "the doors are <<openDesc>>"

    /* announce our doors opening/closing */
    announceRemoteOpen(stat, dir)
    {
        if (stat)
            "The elevator doors slide open with <<
              ['two soft <q>dings.</q>',
               'a chime.',
               'a soft <q>ding.</q>'][dir + 2]>> ";
        else
            "The elevator doors slide shut. ";
    }

    /* the master side of all of the elevator doors is the inner door */
    masterObject = meDoors
;

/* library up/down buttons */
class LibElevatorUpButton: ElevatorUpButton
    'flat plastic -' '<q>up</q> button'
    "It's a flat plastic button in the shape of an arrow pointing up.
    <<isLit ? "It's lit." : "">> "
;

class LibElevatorDownButton: ElevatorDownButton
    'flat plastic -' '<q>down</q> button'
    "It's a flat plastic button in the shape of an arrow pointing down.
    <<isLit ? "It's lit." : "">> "
;

/* ------------------------------------------------------------------------ */
/*
 *   Millikan lobby 
 */
millikanLobby: Room 'Millikan Lobby' 'the lobby of Millikan' 'lobby'
    "This first floor of the library is a large, open lobby.  A
    receptionist sits behind a wide counter; a sign on the counter
    reads <q>Please show ID.</q>  On the north side of the lobby
    is an elevator, with a floor directory on the wall alongside it.
    The exit is to the east. "

    vocabWords = 'library millikan lobby'

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
            "<.p>The librarian looks up from his book briefly as you
            you come in, then goes back to his reading. ";
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
                    it = 'it';
                    aBook = lst[1].coName;
                }
                else
                {
                    /* 
                     *   we have more than one - use them as the pronoun,
                     *   and if they all have the same plural name, use
                     *   that plural name, otherwise make it "some items" 
                     */
                    it = 'them';
                    aBook = lst[1].coPluralName;
                    if (lst.indexWhich({x: x.coPluralName != aBook}) != nil)
                        aBook = 'some items';
                }
                
                /* complain about it */
                "You start to leave, but you realize you have <<aBook>>
                that you haven't checked out.  You give <<it>> to the
                librarian; he rubber-stamps <<it>> and hands <<it>>
                back.  <q>Due back in two weeks,</q> he says. ";

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

+ Fixture 'wide reception counter' 'wide counter'
    "It's a wide counter, creating a workspace for the receptionist.
    A sign on the counter reads <q>Please show ID.</q> "
;

++ Readable, Immovable 'sign' 'sign'
    "<q>Please show ID.</q> "
;

+ millikanReceptionist: Person
    'grad student/receptionist/librarian/man*men' 'receptionist'
    "The receptionist looks like he's probably a grad student---mid
    twenties, flannel shirt, about four days since he's shaved.  He's
    intently studying a weighty-looking textbook. "

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
        "You stand at the counter and clear your throat.
        <.p><q>Yeah?</q> the receptionist says without looking away
        from his book. ";
    }
;

++ InitiallyWorn 'flannel shirt' 'flannel shirt'
    "It looks well-used. "
    isListedInInventory = nil
;

++ AskTopic @millikanReceptionist
    "<q>Are you a student here?</q> you ask.
    <q>Grad student,</q> he says, not looking up. "
;

++ receptBook: Readable
    'weighty-looking looking text textbook/book' 'weighty textbook'
    "It looks like it might be a general relativity text. "
;

++ AskTopic, SuggestedAskTopic, StopEventList @receptBook
    ['<q>What text is that?</q> you ask the receptionist.
    <.p>He doesn\'t look up. <q>Relativistic Gravitation,</q> he says. ',
     '<q>Relativistic Gravitation? Sounds <q>heavy.</q></q> You
     make little air quotes with your fingers.
     <.p><q>You know what makes that joke really funny?  Making little
     air quotes with your fingers while you say <q>heavy.</q></q> ',
     '<q>Interesting book?</q> you ask.
     <.p><q>Almost interesting enough to drown out all the distractions
     around here,</q> he says, putting his face even closer to the book. ']

    name = 'his book'
;

++ AskTellTopic, StopEventList @ddTopic
    ['<q>So why are you stuck here for Ditch Day?</q> you ask, immediately
    realizing it might be an insensitive question.
    <.p><q>Because the guy who\'s <i>supposed</i> to be here is an
    undergrad,</q> he says. ',
     'He seemed a bit touchy about the subject, so maybe you shouldn\'t
     press it. ']
;

++ AskTellTopic @stamerTopic
    "<q>You wouldn't happen to know an undergrad named Brian Stamer,
    would you?</q> you ask.
    <.p><q>Nope, sorry,</q> he says, without looking up. "
;

++ AskTellTopic @researchReport
    "You describe Brian Stamer's research report to the librarian,
    but he doesn't recognize it.  <q>Maybe if I could see it,</q>
    he suggests. "
;
++ GiveShowTopic @researchReport
    "You hand the report to the librarian, and he gives it a quick
    looking over. <q>QM,</q> he says. <q>Sorry, that's not my thing.
    Gravity and quantum mechanics don't play very nice together.</q> "
;

++ AskTellTopic [sAndPs, sAndP, sAndPTopic, sAndP3Topic]
    "<q>Do you have Science &amp; Progress magazine?</q> you ask.
    <.p><q>Sure,</q> he says. <q>Periodicals.  Second floor.</q> "
;

++ AskTellTopic [morgenUnbook, morgenTopic, morgenBook,
                 townsendUnbook, townsendTopic, townsendBook]
    "<q>Which floor do you keep the double-E books on?</q> you ask.
    <.p><q>Electrical engineering?  Third floor,</q> he says. "
;

++ AskTellTopic [qrlTopic, qrls,
                 qrl7011c, qrl7011cTopic,
                 qrl739a, qrl739aTopic]
    "<q>Where can I find the journal called Quantum Review Letters?</q>
    you ask.
    <.p>He glances up. <q>We keep the journals on the subject floors.
    QRL is physics, so sixth floor.</q> "
;

++ AskTellTopic [physicsTextTopic, bloemnerTopic, bloemnerBook,
                 bloemnerUnbook]
    "<q>Where do you keep the physics books?</q> you ask.
    <.p><q>Sixth floor,</q> he says. "
;

++ AskTellTopic [drdUnbook, drdBook, drdTopic]
    "<q>I'm looking for the DRD Tables,</q> you say.
    <.p><q>Let's see,</q> he says.  <q>I think that's with the physics
    books, on six.</q> "
;

++ AskTellAboutForTopic
    [eeTextbookRecTopic, eeTextTopic, eeLabRecTopic, labManualTopic,
     morgenBook, townsendBook]
    "<q>Where are the double-E texts?</q> you ask.
    <.p>He just reads his book for a few moments, then seems to notice
    that you said something.  <q>Third floor,</q> he says absently. "
;
+++ AltTopic
    "<q>Can you recommend a good double-E textbook?</q> you ask.
    <.p><q>I'm a physicist,</q> he says. <q>Ask a double-E.</q> "

    isActive = gRevealed('need-ee-text')
;

++ AskTopic '<nocase>(id|identification)$'
    "<q>What sort of ID do you need to see?</q> you ask.
    <.p><q>Any Caltech ID is fine,</q> he says. "
;

++ AskTellTopic, SuggestedTopic 'checking out( book| books|a book)?'
    topicResponse()
    {
        "<q>Where do I check out books?</q> you ask.
        <.p><q>Right here,</q> he says. <q>Just give me anything you
        need to check out and I'll take care of it.";

        if (millikanLobby.needID)
            " I'll need to see some ID first, of course.";

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
    fullName = 'ask about checking out books'
;
++ GiveShowTopic @alumniID
    topicResponse()
    {
        "You hold out your alumni ID card, and the receptionist gives it
        a good looking over.  <q>You can go on up,</q> he says, waving
        his hand toward the elevator. ";

        /* note that we're approved */
        millikanLobby.needID = nil;
    }
;
+++ AltTopic
    "You hold out your card for the receptionist, but he gives it
    only a quick glance before waving you by.  <q>I still remember
    you,</q> he says. <q>You can go on up.</q> "
    
    isActive = (!millikanLobby.needID)
;
++ GiveShowTopic @driverLicense
    "You hold up your driver's license for the receptionist to see;
    he glances at it but shakes his head. <q>I need <i>Caltech</i>
    ID,</q> he says. "
;
++ GiveShowTopic @cxCard
    "You hold out the Consumer Express card for the receptionist,
    but he just frowns. <q>That's not ID,</q> he says. "
;
++ DefaultAnyTopic
    "<q>I'm kind of busy,</q> the receptionist says, not looking
    up from his book. "
;
++ checkOutBookTopic: GiveTopic
    matchObj = (LibBook.allLibBooks)
    handleTopic(fromActor, obj)
    {
        /* inherit the normal work */
        inherited(fromActor, obj);

        /* respond according to whether or not we've check it out yet */
        if (obj.isCheckedOut)
            "The receptionist looks inside the book. <q>You've already
            checked this one out,</q> he says. ";
        else
        {
            "The receptionist looks inside the book, rubber-stamps it,
            and hands it back. <q>Due back in two weeks,</q> he says. ";
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
        "The receptionist looks at the book. <q>Did you
        want to check that out?</q> he asks.<.convnode checking-out> ";

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

        "<q>Yes, please,</q> you say, handing him the book.<.p> ";
        checkOutBookTopic.handleTopic(fromActor, bookToCheckOut);
    }

    /* 
     *   the book to check out - the SHOW TO handler that sets up this
     *   ConvNode will initialize this with the book in question 
     */
    bookToCheckOut = nil
;
+++ NoTopic
    "<q>Not right now, thanks,</q> you say. The receptionist goes
    back to his book. "
;

+ LibElevatorUpButton;
+ mlElevatorDoor: LibElevatorDoor
    desc = "The sliding elevator doors are made of a shiny metal.  An
        <q>up</q> button is on one side of the doors, and on the other
        side is a floor directory. "

    /* we can't enter the elevator until we show ID */
    canTravelerPass(trav) { return !millikanLobby.needID; }
    explainTravelBarrier(trav)
    {
        "<q>Excuse me,</q> the receptionist says. <q>I need to see
        your ID first.</q>
        <.p>He doesn't look like someone who'd try to physically
        restrain you, but he'd undoubtedly call Security if you
        pushed your way past him. ";
    }
;

+ Readable, Fixture 'floor directory' 'floor directory'
    "The sign lists the subject matter on each floor:
    <.p>
    <.blockquote>
    2 - Chemistry/Periodicals<br>
    3 - Electrical Engineering<br>
    4 - Aeronautics/Materials Science<br>
    5 - Astronomy<br>
    6 - Physics/Mathematics<br>
    7 - Biology<br>
    8 - Computer Science<br>
    9 - Geology
    <./blockquote> "
;

/* ------------------------------------------------------------------------ */
/*
 *   The Millikan elevator 
 */
millikanElevator: Elevator, Room 'Elevator' 'the elevator'
    "The elevator's doors, which lead south, are currently
    <<meDoors.openDesc>>.  Alongside the doors is a column
    of buttons numbered 1 to 9, and above the buttons is a
    digital display, currently reading <q><<getFloorName()>>.</q> "

    vocabWords = 'elevator/lift'

    south = meDoors
    out asExit(south)

    /* when we move between floors, mention the change in the display */
    continueElevatorMotion(curFloorNum, targetFloorNum)
    {
        /* mention the change in the display */
        "The display changes <<
          (targetFloorNum - curFloorNum) is in (1, -1)
          ? "to" : "at each floor until it reaches"
          >> <<getNameForFloor(targetFloorNum)>>. ";

        /* travel directly to the new floor */
        return targetFloorNum;
    }

    announceStop(moving, newDir)
    {
        /* one ding for up, two for down */
        local ding = ['two soft <q>dings.</q>',
                      'a chime.',
                      'a soft <q>ding.</q>'][newDir + 2];

        if (moving)
            "The elevator stops, and the doors slide open with <<ding>> ";
        else
            "The elevator doors slide open with <<ding>> ";
    }
;

+ Fixture 'digital elevator lift display' 'elevator display'
    "It's a digital display showing the current floor number.
    It reads <<location.getFloorName()>>. "
;

+ meDoors: ElevatorInnerDoor
    'shiny metal elevator lift door/doors' 'elevator doors'
    "The elevator doors are made of a shiny metal. "
    isPlural = true
    
    /* start out on the first floor */
    otherSide = mlElevatorDoor
;

class LibElevatorButton: ElevatorButton
    'flat plastic button*buttons'
    desc = "It's a flat plastic button numbered <<floorName>>.
        <<isLit ? "It's currently lit. " : "">> "

    collectiveGroups = [libElevatorButtonGroup]
;

+ libElevatorButtonGroup: ElevatorButtonGroup
    'flat plastic button/buttons/column*buttons' 'buttons'
    "The buttons are arranged in a column, numbered 1 to 9. <<listLit>> "
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
        spellIntOrdinal(floorNum) + ' millikan/library/floor')
    name = (spellIntOrdinal(floorNum) + ' floor')

    desc = "This is the <<spellIntOrdinal(floorNum)>> floor of
        library, which is devoted to books and journals about
        <<subjectMatter>>.  Rows of floor-to-ceiling bookshelves
        fill the entire floor.  The elevator is to the north. "

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
    "If you were to let yourself start browsing, chances are you'd get
    sucked in and spend the whole day here.  You should probably try
    to limit yourself to only specific things you need to look up. "
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
                illogical('The bookshelves are only for books. ');
        }
        check()
        {
            if (!bookBelongs(gDobj))
            {
                "That doesn't belong here; it wouldn't be very considerate
                to mess up the library's organization like that. ";
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
            "You put {it/him dobj} back where you found {it/him}. ";
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
    'floor-to-ceiling shelf/shelves/bookshelf/bookshelves/row/rows'
    'rows of bookshelves'
    "The bookshelves extend from floor to ceiling, and are arranged in
    rows filling the whole floor. "

    isPlural = true

    /* take my floor number from my location, which is the LibRoom object */
    floorNum = (location.floorNum)

    /* rank this low for LOOK IN, in case there's anything better */
    dobjFor(LookIn) { verify() { logicalRank(50, 'decoration'); } }
    lookInDesc = "You can't let yourself get sucked into browsing;
        you'd likely be here all day.  Fortunately, the books are
        well-organized, so you could probably find anything specific
        you need to look up without too much danger of the
        infinite-time-sink problem. "

    topicNotFound() { "You think you've figured out the organization
        scheme the librarians here are using, but you can't find
        what you're looking for. "; }

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
    'text book/textbook/journal*books*texts*textbooks*journals' 'books'

    isPlural = true

    /* our floor number comes from our enclosing shelves */
    floorNum = (location.floorNum)

    cannotPutMsg = 'There are too many books to move them all. '

    dobjFor(Search) remapTo(LookIn, location)
    dobjFor(Examine) remapTo(LookIn, location)
    dobjFor(LookIn) remapTo(LookIn, location)
    dobjFor(Take) remapTo(LookIn, location)
    dobjFor(Read) remapTo(LookIn, location)

    dobjFor(Move)
    {
        verify() { }
        action() { "You make some slight adjustments to the
            books to line them up a tiny bit more neatly. "; }
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
    cannotTakeMsg = 'The whole collection is too large to carry. '
    cannotMoveMsg = 'The whole collection is too large to move. '
    cannotPutMsg = (cannotMoveMsg)

    topicNotFound() { "You don't see that issue. "; }

    /* putting something in the collection just re-shelves the item */
    iobjFor(PutIn) remapTo(PutIn, DirectObject, location)
    iobjFor(PutOn) remapTo(PutOn, DirectObject, location)

    dobjFor(Read)
    {
        action() { "It would take weeks, maybe months, to read the
            whole collection. "; }
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
                "<.p>A rubber stamp mark indicates that you've checked
                this book out. ";
        }
    }

    /* LOOK IN and OPEN == read */
    dobjFor(LookIn) asDobjFor(Read)
    dobjFor(Open) asDobjFor(Read)

    /* for check-out purposes, my singular and plural generic names */
    coName = 'a book'
    coPluralName = 'some books'

    /* receive notification that we're finding the book */
    notifyFound() { }
;

/* an "unbook," representing the absence of a book until it's found */
class LibUnbook: Unthing
    desc() { say(notHereMsg); }
    notHereMsg = 'You don\'t see that lying around, but there are
        a lot of books here, so you might be able to find it if
        you looked for it. '
;

/* a class for a topic that represents a search for a particular book */
class LibBookTopic: ConsultTopic
    /* my actual LibBook object */
    myBook = nil

    /* the vague generic name for this object (book, magazine, etc) */
    vagueName = 'book'

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
            "You scan through the shelves and find what you're
            looking for: <<myBook.theName>>. ";

            /* take it */
            nestedAction(Take, myBook);

            /* make it 'it' */
            gActor.setIt(myBook);

            /* if we got it, say so */
            if (myBook.isIn(gActor))
                "You take the <<vagueName>> from the shelf. ";
        }
        else
            "You find the spot where that <<vagueName>> should be, but
            it's been removed. ";
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   Second floor 
 */
millikan2: LibRoom
    floorNum = 2
    subjectMatter = 'chemistry, and also houses the library\'s collection
        of periodicals'
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
++ LibShelfBooks 'chemistry periodicals/magazines';

/* 
 *   A generic item, to match searches for S&P without a specific issue.
 *   Match this at a higher-than-default level, so that we'll match it
 *   whenever possible.  A match is only possible when the player uses only
 *   generic words (no issue number), since we don't have the issue number
 *   among our vocabulary.  When only generic words are present, we want to
 *   match this generic response instead of an issue-specific topic. 
 */
++ ConsultTopic +110 [sAndPTopic, sAndPs]
    "You find a collection of <i>Science &amp; Progress</i> going back
    several decades.  They're all arranged in order, so it'd be easy
    to find an issue if you know the number. "
;

/* 
 *   create a class for the special issue, so we can put instances both in
 *   the shelves and in the specific magazine collection 
 */
class SAndPEntry: LibBookTopic @sAndP3Topic
    myBook = sAndP
    vagueName = 'issue'
;
++ SAndPEntry;

/* an object for the whole collection of Science & Progress */
++ sAndPs: LibShelfColl
    'science & progress s&p science&progress magazines/collection'
    'collection of <i>Science &amp; Progress</i>'
    "The collection of the magazine goes back decades. "
;
+++ SAndPEntry;

/* an Unbook for the P&S, in case we try to take it before finding it */
++ LibUnbook
    'science & progress science&progress s&p magazine number issue
    xlvi-3/magazine'
;

/* 
 *   the tangible game object for the special issue itself - this pops
 *   into existence when we look it up successfully 
 */
++ sAndP: PresentLater, LibBook
    'science & progress science&progress s&p magazine number issue
    xlvi-3/magazine'
    '<i>Science &amp; Progress</i> issue XLVI-3'
    "<i>S&amp;P</i> is a favorite of yours, at least when you can find
    the time to read it. "

    /* my check-out names */
    coName = 'a magazine'
    coPluralName = 'some magazines'

    readDesc = "You scan through this issue and find the article
        referenced in Stamer's paper: <q>Beyond Copenhagen: The
        Quantum/Classical Transition.</q>
        <.p>The article is about a nagging weakness in the <q>Copenhagen
        Interpretation</q> of quantum mechanics.  You hadn't heard the term
        before, but apparently it refers to the mainstream QM model, which
        is essentially what you learned in Ph 2.  A key part of the
        Copenhagen doctrine is the idea that a quantum system evolves in
        its bizarre quantum way until someone observes the system, at
        which point the quantum-mechanical wavefunction <q>collapses</q>
        and the system becomes classically deterministic.  The problem,
        it seems, is that there's no rigorous definition of what it means
        to <q>observe</q> the system.
        <.p><q>One idea is that a conscious observer is required, but most
        scientists don't like this one because it just replaces one
        ill-defined term with an even iller-defined one, and anyway, it
        smells like metaphysics.  The mainstream view is that interaction
        with <q>bulk matter</q> is what constitutes a measurement.  That
        at least sounds like a solid, no-nonsense, scientific definition,
        but it's still a bit of a dodge: are we talking a dozen atoms or
        a quadrillion?  No one can say.  And numerous recent experiments
        call into question the whole idea by showing that certain exotic
        kinds of large ensemble systems can exhibit quantum behavior for
        prolonged periods, so mere <q>bulk</q> can't be the key.</q>
        <.p>The article points out that most scientists are willing to live
        with one fuzzy definition in a theory so empirically successful,
        but a few physicists find it troubling enough to look for a better
        answer to this key question.  The article surveys some of the
        proposed alternatives to the Copenhagen interpretation, with
        names like Many Worlds, Hidden Variables, and Transactional.
        It also talks about some promising recent work that frames
        the quantum/classical transition in terms of <q>decoherence</q>
        of the wavefunction.  This idea is based on wave theory that
        came out of the invention of the laser; it says that quantum
        systems turn into classical systems when their wavefunctions
        interact in specific ways with the wavefunctions of other
        systems, which causes the wavefunctions to lose their
        coherence---their ability to superpose multiple quantum
        states at once.
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
    "You don't find <i>Quantum Review Letters</i> anywhere on the
    shelves here.  Your recollection is that they keep journals on
    the subject floors rather than with the periodicals, so it's
    probably with the physics books. "
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
grammar adjWord(sAndP): 'science' 'and' 'progress'
    : NounPhraseWithVocab

    getVocabMatchList(resolver, results, extraFlags)
    {
        return getWordMatches('s&p', &adjective, resolver,
                              extraFlags, VocabTruncated);
    }

    getAdjustedTokens()
    {
        return ['science', &adjective, 'and', &adjective,
                'progress', &adjective];
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   Third floor 
 */
millikan3: LibRoom
    floorNum = 3
    subjectMatter = 'electrical engineering'
    north: LibElevatorDoor { }
;
+ LibElevatorUpButton;
+ LibElevatorDownButton;
+ LibShelves;
++ LibShelfBooks 'electrical engineering ee -';

/* 
 *   A topic for "ee textbooks" in general - score this higher than default
 *   so that it will overshadow any more specific match object when only
 *   the vague terms are used.  (We can't match unless only vague terms are
 *   used, so when we do match, we want to select this match rather than
 *   any more specific object.  The specific objects match the vague terms,
 *   too, but they also match special terms describing them only.)  
 */
++ ConsultTopic +110 @eeTextTopic
    "There's basically nothing but EE textbooks here.  It would take
    all day to look at even a tiny fraction of them, and most are so
    specialized that you're not likely to learn much just browsing.
    On the other hand, if had a specific book in mind, you
    could find it up pretty easily. <<mentionRec>> "

    /* 
     *   mention that we could use a recommendation from somebody, if we've
     *   revealed the need for a textbook 
     */
    mentionRec()
    {
        if (gRevealed('need-ee-text') && !gRevealed('morgen-book'))
            "<.p>You don't have any ideas for EE texts to look at.
            Maybe you could ask someone for a recommendation. ";
    }
;

/* an Unbook for the Morgen text */
++ morgenUnbook: LibUnbook 'yves morgen electronics lectures book/textbook'
    'Morgen textbook'
;

/* a topic for looking up the Morgen text */
++ LibBookTopic [morgenTopic, morgenBook, morgenUnbook]
    myBook = morgenBook
;

/* the Morgen text itself */
++ morgenBook: PresentLater, LibBook
    'yves morgen electronics lectures text
    book/textbook*books*texts*textbooks'
    '<i>Electronics Lectures</i> textbook'
    "It's a thick textbook by Yves Morgen, titled <i>Electronics
    Lectures</i>. "

    isRead = nil
    readDesc()
    {
        if (isRead)
            "You flip through the book quickly, but you feel like
            you've already absorbed as much theory as you're able
            to for the moment.
            <.p>In the book's front matter, you notice a reference
            to an accompanying lab manual by E.J.\ Townsend. ";
        else
        {
            "You open the book and start reading. At first it seems
            a little heavy on the math, but as you get further into
            it you start to recognize the standard building
            blocks---Fourier series, Laplace transforms, PDE's.
            You're pleased to find that the concepts and the math
            are less distant in your memory than you'd thought.
            <.p>You keep reading, skimming over some parts but slowing
            down to digest others.  Eventually, your eyes start
            glazing over a bit, and you realize that you've been
            <<me.posture.presentParticiple>> here reading for quite
            a while.  You decide you've absorbed just about as
            much theory as you can for the moment; what you really
            need now is something a little more hands-on.  You
            notice in the book's front matter a reference to an
            accompanying lab manual by E.J.\ Townsend; that might
            be worth looking at. ";

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

    cannotConsultMsg = 'This book is probably a lot more useful if
        you just read through it.  Textbooks like this don\'t tend
        to be very good as quick references. '

    /* 
     *   we need to do this manually because the <i> tag at the start of
     *   the name throws off the automatic sensing algorithm 
     */
    aName = ('an ' + name)

    /* we belong on the EE floor */
    floorNum = 3

    /* a score marker for getting the recommendation for this book */
    recMarker: Achievement { +2 "getting a recommendation for a EE book" }

    /* a score marker for finding the book */
    readMarker: Achievement { +1 "reading the EE textbook" }
;

/* 
 *   a generic "lab manuals" topic - score this high so that it will
 *   overshadow a more specific match when only the vague terms are entered
 */
++ ConsultTopic +110 @labManualTopic
    "There are lots of EE lab manuals mixed in with the textbooks;
    it would take too long to browse them all, but you could probably
    find a specific one if you knew the author. "
;

++ townsendUnbook: LibUnbook 'e.j. townsend lab laboratory manual'
    'Townsend lab manual'
;
++ LibBookTopic [townsendTopic, townsendBook, townsendUnbook]
    myBook = townsendBook
;
++ townsendBook: PresentLater, LibBook, Consultable
    'e.j. townsend lab laboratory large softcover manual/book*books*manuals'
    'lab manual'
    "It's a large softcover book.  This type of book contains
    lab exercises demonstrating various electronics principles. "

    readDesc = "You look through the book's various lab exercises.
        Each one would take a few hours to work through, and they
        all require some specific equipment, so you're not going to
        get much out of just browsing.  It looks like it'd be a great
        reference to have on hand while actually working on circuitry,
        though---you could look things up as needed. "

    /* on finding this book, award some points */
    notifyFound() { foundMarker.awardPointsOnce(); }

    /* we belong on the EE floor */
    floorNum = 3

    /* points for finding the Townsend book */
    foundMarker: Achievement { +2 "finding a EE lab manual" }
;
+++ ConsultTopic @waveformTopic
    "The book has lots of waveform charts, but you don't find anything
    directly applicable to what you're looking for. "
;

/* the video amp lab */
+++ ConsultTopic @videoAmpTopic
    "You find a lab exercise on video amps and glance through it
    quickly.  It's good to know it's here in case you need
    details on this sort of thing at some point. "
;
++++ AltTopic, StopEventList
    ['You find a whole lab exercise on video amps.  You go through
    it carefully, refreshing your memory on how these things work.
    You reach the end of the section, feeling that you have a good
    idea how to handle this kind of circuit now.
    <.reveal read-video-amp-lab> ',
     'You briefly scan the video amp lab again. ']

    /* we only read this thoroughly once we know we need it */
    isActive = (gRevealed('need-video-amp-lab'))
;

/* the 1A80 lab */
+++ ConsultTopic @the1a80Topic
    "The book has a pretty good set of information on this early-80s
    CPU.  You remember working with these a few times, years ago.
    You note the section for future reference, on the off chance
    you need to know about 1A80s at some point. "
;
++++ AltTopic, StopEventList
    ['You find a pretty good section on the 1A80, with details on
    the pin-outs and electrical characteristics.  This is a very
    simple chip by modern standards, and it doesn\'t take you long
    to reacquaint yourself with it.
    <.reveal read-1a80-lab> ',
     'You quickly go over the 1A80 material again. ']

    /* we only read this thoroughly once we know we need it */
    isActive = (gRevealed('need-1a80-lab'))
;

+++ DefaultConsultTopic
    "You look through the index, but you don't find what you're
    looking for. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Fourth floor 
 */
millikan4: LibRoom
    floorNum = 4
    subjectMatter = 'aeronautics and materials science'
    north: LibElevatorDoor { }
;
+ LibElevatorUpButton;
+ LibElevatorDownButton;
+ LibShelves;
++ LibShelfBooks 'aeronautics materials science -';

/* ------------------------------------------------------------------------ */
/*
 *   Fifth floor 
 */
millikan5: LibRoom
    floorNum = 5
    subjectMatter = 'astronomy'
    north: LibElevatorDoor { }
;
+ LibElevatorUpButton;
+ LibElevatorDownButton;
+ LibShelves;
++ LibShelfBooks 'astronomy astrophysics -';

/* ------------------------------------------------------------------------ */
/*
 *   A list group for the Quantum Review Letters issues.  This tidies the
 *   list a bit by keeping the related items together. 
 */
qrlListGroup: ListGroupPrefixSuffix
    groupPrefix = "issues "
    groupSuffix = " of <i>Quantum Review Letters</i>"

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
    subjectMatter = 'math and physics'
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
++ LibShelfBooks 'physics -';

/* 
 *   A topic for the generic 'quantum review letters'.  Match more strongly
 *   than the default, so that if we match - which is possible only with
 *   generic words, not with an issue number - we'll override any other
 *   matches that have specific issue numbers. 
 */
++ ConsultTopic +110 [qrlTopic, qrls]
    "You find where they keep the collection of <i>Quantum Review
    Letters</i>---shelves and shelves and shelves of them.
    They're all neatly organized, though, so it'd be easy
    to find a particular issue. "
;
++ ConsultTopic +109 [qrlVolumeTopic, qrls]
    "You find where they keep the <i>Quantum Review Letters</i> collection,
    and you find the right volume, but there are lots of individual issues.
    They're neatly organized, so it'd be easy to find a particular issue. "
;

/* 
 *   create a class for our special issues, so that we can put instances
 *   both in the shelves and in the collection of this journal 
 */
class Qrl7011cEntry: LibBookTopic @qrl7011cTopic
    myBook = qrl7011c
    vagueName = 'issue'
;
class Qrl739aEntry: LibBookTopic @qrl739aTopic
    myBook = qrl739a
    vagueName = 'issue'
;
++ Qrl7011cEntry;
++ Qrl739aEntry;

/* an object for the whole collection of Quantum Review Letters */
++ qrls: LibShelfColl
    'quantum review letters/collection/journal/qrl'
    'collection of <i>Quantum Review Letters</i>'
    "Several shelves are filled with issues of this journal. "
;
+++ Qrl7011cEntry;
+++ Qrl739aEntry;

/* an Unbook for QRL 70:11c, for when we're not here */
++ LibUnbook 'quantum review letters journal qrl number 70:11c/qrl';

/* 
 *   the tangible game object for our special issue - this pops into
 *   existence when we successfully look it up 
 */
++ qrl7011c: PresentLater, LibBook
    'quantum review letters journal qrl number
    70:11c/letters/journal/issue/qrl*journals*issues*qlrs'
    '<i>Quantum Review Letters</i> number 70:11c'
    "Like most scientific journals, it looks more like a paperback book
    than a magazine; just plain text on plain white paper, dense with
    jargon and equations. "

    /* we have more than one of these, so list them together */
    listWith = [qrlListGroup]
    qrlIssueName = '70:11c'

    /* my check-out names */
    coName = 'a journal'
    coPluralName = 'some journals'

    readDesc = "You flip past a bunch of papers that look impenetrable,
        finding the one mentioned in Stamer's paper: <q>Decoherence
        Tolerance in Quantum Computation.</q>  It's by another Caltech
        research group.
        <.p>The article isn't exactly light reading.  It's about some of
        the problems involved in building quantum computers---computers
        that exploit the ability of a quantum system to be in many states
        at once to quickly perform calculations that are extremely slow
        on conventional computers.  One of the biggest practical problems
        in building quantum computers, the article explains, is the
        difficulty of isolating a quantum system well enough that it
        will remain a quantum system long enough to finish its
        calculation.  If the system isn't isolated well enough,
        interactions with its environment will cause <q>decoherence,</q>
        destroying the quantum effects.  Even more problematic is the
        self-interaction that results from scaling up a quantum computer
        to the point where it can perform useful real-world calculations:
        the computer's quantum elements actually start interacting with
        one another strongly enough to cause decoherence.
        <.p>The bulk of the article proposes some ways of working around
        the self-interaction problem, by adopting some of the features of
        conventional computers that make them more fault-tolerant.  One
        proposal is to encode information in the quantum state using
        error-correcting codes, so that a loss of coherence in one part
        of the system can be compensated for by the other parts.  Another
        proposal---and this one catches your eye, because Stamer's paper
        had this in the title---is that <q>spin decorrelation</q> can be
        used to partially isolate the system internally and from its
        environment.  The paper starts in with dense math at that point,
        so you mostly skim over the rest.
        <<researchReport.checkComprehension('spin-decorr')>> "

    /* we're named by title, which is proper */
    isProperName = true

    /* we belong on floor 6 (physics) */
    floorNum = 6
;

/* an Unbook for issue 73:9a, for when we're not here */
++ LibUnbook 'quantum review letters qrl journal number 73:9a/qrl';

/* the actual QRL 73:9a */
++ qrl739a: PresentLater, LibBook
    'quantum review letters qrl journal number
    73:9a/letters/journal/issue/qrl*journals*issues*qrls'
    '<i>Quantum Review Letters</i> number 73:9a'
    "Like most scientific journals, it looks more like a paperback book
    than a magazine; just plain text on plain white paper, dense with
    jargon and equations. "

    /* we have more than one of these, so list them together */
    listWith = [qrlListGroup]
    qrlIssueName = '73:9a'

    /* my check-out names */
    coName = 'a journal'
    coPluralName = 'some journals'

    readDesc = "You find Stamer's group's paper: <q>Applications
        of Nondecohering Heterogeneous Bulk Ensembles.</q>
        <.p>The paper talks about a number of possible applications
        of decoherence suppression, but the main thrust is that it
        could provide a whole new approach to building quantum computers.
        <.p><q>In principle, if we are successful in suppressing
        decoherence in bulk matter, we could create an effectively
        quantum computer as a superposition of states of an
        <i>ordinary</i> computer, such as a PC, or even a pocket
        calculator... Of course, special algorithms would need to be
        designed for such a device.  The computation must consist of
        a series of unitary transformations.  In the final state vector,
        the components representing incorrect results must cancel out,
        and the correct result must reinforce via constructive
        interference... Mapping a conventional algorithm to our hybrid
        quantum-conventional computer is surprisingly straightforward,
        as we'll show...</q>
        <.p>The article goes through an extended example, showing how
        to use the technique to find the prime factors of a large
        integer.  The number theory is a bit beyond you, but
        what's interesting is how simple the program is; it's just
        a series of simple arithmetic steps that would take a matter of
        seconds to run, in quantum mode.  On an ordinary computer, of
        course, factoring large integers takes enormous amounts of
        time.  <q>This technique isn't limited to prime factorization,</q>
        the paper adds.  <q>The methods we've shown here could be equally
        well applied to other conventionally superpolynomial-time
        problems:  discrete logarithms, Hovarth functions, etc.</q>
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
    "This being the physics floor of the library, there are lots of
    physics texts here; it would take all day to look at them all.
    If you have a specific author in mind, you could probably find
    the book pretty easily. "
;

/* a topic for the Bloemner book */
++ LibBookTopic [bloemnerTopic, bloemnerBook, bloemnerUnbook]
    myBook = bloemnerBook
;

/* the Bloemner book itself */
++ bloemnerBook: PresentLater, LibBook
    'text book textbook by
    blomner bloemner bl\u00F6mner blomner\'s bloemner\'s bl\u00F6mner\'s
    introductory quantum physics
    book/text/textbook*books*texts*textbooks'
    '<i>Introductory Quantum Physics</i> textbook'
    "Dieter Bl&ouml;mner: <i>Introductory Quantum Physics.</i>  This
    is one of the texts they used in Ph 2 when you were here; the horror
    comes flooding back just looking at it. "

    readDesc = "You find the chapter Stamer mentioned and start reading.
        <.p>Going through the material, you find you actually do remember
        a fair amount of it.  All that bizarre stuff about how subatomic
        particles act like both waves and particles at the same time, how
        a particle can be in a <q>superposition</q> of several states at
        once, how a property of a particle isn't determined until someone
        measures it.  You skip over the equations, but you still manage to
        get a qualitative grasp of the concepts.
        <.p>The chapter ends with a discussion of the philosophical
        questions that QM raises.  One big mystery is the strange duality
        of nature: that systems sometimes behave according to quantum
        mechanics, and sometimes according to classical mechanics.  Even
        the same system behaves both ways: a quantum system has its strange
        quantum behavior, where its reality is just a probability
        distribution---but only until someone measures the system's
        properties.  Measuring a property of the system <q>collapses the
        wavefunction,</q> turning it into a classical, deterministic system.
        <q>The quantum mechanics stridently defies our intuition,</q> Herr
        Professor Bl&ouml;mner writes, <q>but it is only our human
        arrogance that allows us to expect it should be otherwise.  For
        why should our intuition, evolved to interpret the decidedly
        non-quantum phenomena of the primitive environment of our
        ancestors, have any application in this exotic realm?  We must
        learn ruthlessly to crush this inner protest, to bend our
        intuition to the iron will of Nature.</q>
        <<researchReport.checkComprehension('QM-intro')>> "

    /* 
     *   we need to do this manually because the <i> tag at the start of
     *   the name throws off the automatic sensing algorithm 
     */
    aName = ('an ' + name)

    /* we belond on the physics floor */
    floorNum = 6
;

/* an unbook for Bloemner */
++ bloemnerUnbook: LibUnbook
    'by blomner bloemner bl\u00F6mner blomner\'s bloemner\'s bl\u00F6mner\'s
    introductory quantum physics text book/textbook'
    'Bl&ouml;mner textbook'
;

/* an Unbook for the DRD tables */
++ drdUnbook: LibUnbook
    'drd math mathematics mathematical functions/table/tables/handbook/book'
    'DRD Handbook'
;

/* a topic for looking up the DRD tables */
++ LibBookTopic [drdTopic, drdBook, drdUnbook]
    myBook = drdBook
;

/* the DRD Tables book itself */
++ drdBook: PresentLater, LibBook, Consultable
    'drd math mathematics mathematical functions/table/tables/handbook/book'
    'DRD Handbook'
    "The <i>DRD Handbook of Mathematical Functions</i> was a constant
    companion in your junior and senior years.  It's full of tables of
    pre-computed values for obscure functions that even the most
    advanced calculators don't cover.  It's an extremely thick book,
    but it's indexed for easy reference to particular functions. "

    /* we belong on the math & physics floor */
    floorNum = 6
;

+++ ConsultTopic @hovarthTopic
    "You find the section in the book.  There's a brief introduction,
    followed by a page of formulas, and then a long table of values.
    <.blockquote>
    Hovarth functions (named for Wilma Hovarth, 1806-1892) are a
    class of transcendental functions based on integral transforms,
    with applications in physics and (recently) cryptography.  The
    general family of functions is conventionally denoted
    <b>Hov<sub>[<i>g,k</i>]</sub>(</b><i>n</i><b>)</b>,
    where <i>g</i> and <i>k</i> are integers giving the greater and lesser
    coefficients, respectively.  The most common member,
    <b>Hov<sub>[<i>0,0</i>]</sub>(</b><i>n</i><b>)</b>, is
    usually denoted simply as <b>Hovarth(</b><i>n</i><b>)</b>.
    <.p><b>Hov<sub>[<i>0,0</i>]</sub>(</b><i>n</i><b>)</b>
    can be calculated analytically for <i>n</i> = 0, 1, --1, <i>e</i>, and
    <i>--e</i>.  For other values of <i>n</i> the function cannot be
    reduced analytically, so it must be computed numerically (e.g., with
    Taylor series).  Unfortunately, all known series representations are
    extremely slow to converge, so the function is computationally
    intractable for large <i>n</i>.  As of this writing
    (<<getTime(GetTimeDateAndTime)[1]-1>>), the Hovarth numbers
    up to about <i>n</i> = 300,000 have been calculated.  Values up
    <i>n</i> = 2,000 are tabulated below.
    <./blockquote>
    <.p>Below the introduction, the general formula for the family
    of functions is given, and then the specific formulas for some
    of the coefficient values.  The functions are all complicated
    integrals; it's easy enough to believe that there's no way to
    solve any of these analytically.
    <<extraNotes>>
    <.reveal drd-hovarth> "

    /* extra notes, depending on how far we've gotten */
    extraNotes()
    {
        if (gRevealed('hovarth'))
            "Unfortunately, the table doesn't go nearly high enough for
            you needs---this apparently isn't going to be as trivial
            as you'd thought.  You're going to have to find some way
            to calculate the number.
            <.p>You scan the formula, and it's not at all straightforward.
            It's not a program you'd want to write yourself, certainly. ";
    }
;

+++ DefaultConsultTopic
    "You scan the index at the back of the DRD, but you don't see that. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Seventh floor 
 */
millikan7: LibRoom
    floorNum = 7
    subjectMatter = 'biology'
    north: LibElevatorDoor { }
;
+ LibElevatorUpButton;
+ LibElevatorDownButton;
+ LibShelves;
++ LibShelfBooks 'bio biology -';

/* ------------------------------------------------------------------------ */
/*
 *   Eighth floor 
 */
millikan8: LibRoom
    floorNum = 8
    subjectMatter = 'computer science'
    north: LibElevatorDoor { }
;
+ LibElevatorUpButton;
+ LibElevatorDownButton;
+ LibShelves;
++ LibShelfBooks 'cs computer science -';

/* ------------------------------------------------------------------------ */
/*
 *   Ninth floor 
 */
millikan9: LibRoom
    floorNum = 9
    subjectMatter = 'geology'
    north: LibElevatorDoor { }
;
+ LibElevatorDownButton;
+ LibShelves;
++ LibShelfBooks 'geology -';

