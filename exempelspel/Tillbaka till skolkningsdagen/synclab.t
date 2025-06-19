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
    'Roof of Sync Lab' 'the roof of the Sync Lab' 'roof'
    "The surface of the roof seems to be asphalt.  The roof is
    flat, but the surface is uneven from numerous patches and
    repairs.  Near the west edge, a rectangular fixture of unpainted
    sheet metal rises up a couple of feet.
    <.p>The roof ends to the north at the back wall of Firestone,
    which rises up another story from here.  A ladder is bolted
    to the wall, leading up the side of the building. "

    up = slrLadderUp
    down = (slrDoor.isOpen ? slrLadderDown : inherited)

    vocabWords = 'sync synchrotron lab/laborator/building/roof'
;

+ Floor
    'flat uneven asphalt roof/floor/surface/patch/patches/repair/repairs'
    'roof'
    "It's an uneven asphalt surface.  The roof ends to the north
    at the back wall of Firestone. "
    dobjFor(JumpOff) remapTo(Jump)
;

+ Distant, Decoration 'ground' 'ground/walkway'
    "The ground is two stories below. "
;

+ Fixture 'back blank concrete firestone wall/lab/laboratory/building'
    'back wall of Firestone'
    "Firestone is just a blank concrete wall on this side.  A ladder
    is bolted to the wall, leading up the side of the building. "
;
++ slrLadderUp: StairwayUp ->frLadder 'firestone ladder' 'Firestone ladder'
    "The ladder is bolted to the wall of Firestone, and leads
    up the side of the building. "
;

+ Platform, Fixture
    'protruding rectangular unpainted sheet metal fixture/box'
    'rectangular fixture'
    "It's a rectangular box about five feet on a side and two feet
    high.  On top is a metal door (which is <<slrDoor.openDesc>>). "

    dobjFor(Open) remapTo(Open, slrDoor)
    dobjFor(Close) remapTo(Close, slrDoor)
    dobjFor(LookIn) remapTo(LookIn, slrDoor)
    dobjFor(Enter) remapTo(Enter, slrDoor)

    /* when the door is open, 'DOWN' from here means climbing the ladder */
    down = (slrDoor.isOpen ? slrLadderDown : inherited)
;

/* 
 *   this is really a container, not a door, since we want it to conceal
 *   the shaft and ladder when closed 
 */
++ slrDoor: Fixture, Openable, RestrictedContainer
    'unpainted sheet metal door' 'metal door'
    "The door is a three-foot square of the same sheet metal
    the protruding fixture is built from. "

    /* don't allow putting anything in here */
    cannotPutInMsg(obj)
    {
        gMessageParams(obj);
        return 'Better not; {it obj/he} could break in the fall. ';
    }

    /* 
     *   Customize our contents listing messages.  We're not a real
     *   container, in that nothing can be manually PUT IN me, so all we
     *   have to worry about is our 'empty' status messages. 
     */
    descContentsLister: thingContentsLister {
        showListEmpty(pov, parent)
        {
            if (parent.isOpen)
                "The door is open, revealing a wrought-iron ladder
                leading down a shaft. ";
            else
                "It's currently closed. ";
        }
    }
    lookInLister = (descContentsLister)
    openingLister: openableOpeningLister {
        showListEmpty(pov, parent)
            { "Opening the door reveals a wrought-iron ladder leading
                down a shaft. "; }
    }

    dobjFor(Enter) remapTo(TravelVia, slrLadderDown)
    dobjFor(Board) remapTo(TravelVia, slrLadderDown)
    dobjFor(GoThrough) remapTo(TravelVia, slrLadderDown)
;
+++ Fixture 'shaft shaft/darkness/(wall)' 'shaft'
    "A wrought-iron ladder descends the shaft, disappearing into
    darkness below. "

    dobjFor(LookIn) remapTo(LookIn, location)
    iobjFor(PutIn) remapTo(PutIn, DirectObject, location)
    dobjFor(Enter) remapTo(TravelVia, slrLadderDown)
    dobjFor(Board) remapTo(TravelVia, slrLadderDown)
    dobjFor(Climb) remapTo(TravelVia, slrLadderDown)
    dobjFor(ClimbDown) remapTo(TravelVia, slrLadderDown)
;

++++ slrLadderDown: TravelWithMessage, StairwayDown
    'iron wrought-iron ladder' 'wrought-iron ladder'
    "The ladder is bolted to the shaft wall.  It descends the shaft
    into darkness. "

    disambigName = 'ladder in the shaft'

    travelDesc = "Your eyes slowly adjust to the dim interior as you
        climb down the ladder.  After about twenty rungs, you reach
        a landing. "
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
            "You can't tell in this light exactly how far it is to
            the ground, but it doesn't look close enough to try jumping. ";
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
    'grid narrow metal catwalk walkway
    dull gray grey plate steel metal raised floor/pattern/x\'s'
    'catwalk'
    "The floor of the catwalk is a dull gray metal, probably steel.
    It's stamped with a grid pattern of raised X's, presumably for
    traction. "

    /* treat JUMP OFF CATWALK the same as JUMP */
    dobjFor(JumpOff) remapTo(Jump)
;

catwalkSpace: Distant, RoomPart
    'cavernous interior darkness/space/(building)' 'darkness'
    "The interior of the building seems to be a large, open space
    that extends below and east, but the lighting is inadequate to
    see anything beyond the catwalk. "
;

syncLights: Distant, RoomPart
    'weak yellow light lights/fixtures' 'light fixtures'
    "The fixtures cast a weak yellow light, barely adequate for
    the large space. "
    isPlural = true
;

/* ------------------------------------------------------------------------ */
/*
 *   Sync lab catwalk, south end on west side
 */
syncCatwalkSouthWest: SyncCatwalkRoom
    'Catwalk near Ladder' 'the catwalk near the ladder'
    "This is a narrow metal walkway clinging to the west wall of
    a cavernous interior space.  Weak yellow light filters down
    from fixtures overhead, but only darkness is visible below.
    <.p>A wrought-iron ladder, bolted to the wall, leads up<<
      slrDoor.isOpen ? " to a small opening overhead.  A patch of
          sky is visible through the opening" : "" >>.  The
    catwalk continues north along the wall, and ends to the south
    at a stairway leading down. "

    up = scswLadderUp
    down = scswStairDown
    south asExit(down)
    north = syncCatwalkNorth
;

+ Fixture 'west w concrete wall*walls' 'west wall'
    "The wall looks to be made of concrete.  It extends above and
    below into the darkness.  A ladder leading up is bolted to the
    wall here. "
;

+ scswLadderUp: StairwayUp ->slrLadderDown
    'wrought-iron iron ladder' 'wrought-iron ladder'
    "The ladder ascends the wall<< slrDoor.isOpen
      ? " to a small opening overhead" : "" >>. "
    
    noteTraversal(trav)
    {
        /* describe the travel */
        "You make your way up the ladder";

        /* open the door if necessary */
        if (!slrDoor.isOpen)
        {
            ".  When you reach the top, you find a small door in
            the ceiling, which you push open.  You climb through
            the door into sunlight. ";

            slrDoor.makeOpen(true);
        }
        else
            ", climbing out through the opening when you reach it. ";

        /* do the normal work */
        inherited(trav);
    }
;

+ scswStairDown: StairwayDown 'stairway/stair/stairs' 'stairway'
    "The stairs lead down into the darkness. "
;

/* 
 *   an internal container to contain the opening, which is only visible
 *   when the door is open 
 */
+ Fixture, BasicContainer
    isOpen = (slrDoor.isOpen)
;
++ Distant 'small opening' 'small opening'
    "A patch of sky is visible through the opening. "

    dobjFor(LookIn) remapTo(Examine, scswSky)
    dobjFor(LookThrough) remapTo(Examine, scswSky)
;
++ scswSky: Distant 'patch/sky' 'sky'
    "Only a small patch of sky is visible from here. "
;


/* ------------------------------------------------------------------------ */
/*
 *   Sync Catwalk North 
 */
syncCatwalkNorth: SyncCatwalkRoom
    'Catwalk, at Corner' 'the corner in the catwalk'
    "This is a corner in the raised metal walkway.  The catwalk
    continues south, along the west wall of the building, and
    east into the murky twilight. "

    south = syncCatwalkSouthWest
    east = syncCatwalkGapWest
;

+ Fixture 'west w concrete wall*walls' 'west wall'
    "The wall looks to be made of concrete.  It extends above and
    below into the darkness. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Some common elements of the gap rooms 
 */

/* the bridge across the gap, permanently hanging overhead */
MultiFaceted
    locationList = [syncCatwalkGapWest, syncCatwalkGapEast, syncOnCrate]
    instanceObject: Distant {
        'overhead bridge/underside/drawbridge' 'bridge'
        "It's too far away to see in any detail, especially in
        the dim lighting, but it looks like it's a section of catwalk
        that would just fit across the gap. "

        disambigName = 'overhead bridge'
    }
;

/* the catwalk sections and the gap */
syncCatwalkGapFloor: catwalkFloor
    'other another (east) (west) (e) (w) section/gap/continuation' 'catwalk'
    "The catwalk is interrupted by a gap, which looks to be about
    ten feet, to the east. "

    dobjFor(JumpOver)
    {
        verify() { }
        action() { "The gap is much too wide to jump across. "; }
    }
;

/*
 *   The top of the crate, as it appears from the ends of the catwalk
 *   adjacent to the gap. 
 */
metalCrateTop: MultiFaceted
    instanceObject: Enterable {
        -> syncOnCrate
        'especially large huge burnished aluminum metal crate/top/bridge'
        'metal crate'
        "The top of the crate is roughly level with the catwalk,
        creating a bridge across the gap. "

        specialDesc = "A huge metal crate is wedged between the ends
            of the catwalk.  Its top is roughly level with the catwalk,
            creating a bridge across the gap. "

        /* GET ON and STAND ON are equivalent to ENTER */
        dobjFor(Board) remapTo(Enter, self)
        dobjFor(StandOn) remapTo(Enter, self)

        lookInDesc = "There's no obvious way to open the crate to
            look inside. "
    }
;


/* ------------------------------------------------------------------------ */
/*
 *   Sync Catwalk West 
 */
syncCatwalkGapWest: SyncCatwalkRoom
    'Catwalk at Gap' 'the catwalk west of the gap'
    "The catwalk extends west, and abruptly ends to the east.
    Another section of catwalk, apparently the continuation of
    this one, is barely visible about ten feet further east.
    Above the gap, high overhead, the underside of what looks
    to be a bridge is visible.
    <.p>Just this side of the gap is a control panel. "

    west = syncCatwalkNorth
    east = (metalCrateTop.isIn(self) ? syncOnCrate : noEast)
    noEast: NoTravelMessage { "The gap is much too wide to jump across. "; }

    /* don't use the usual catwalk floor here, as there's another section */
    roomParts = static (inherited - catwalkFloor + syncCatwalkGapFloor)
;

+ Fixture 'control panel' 'control panel'
    "The panel has two large mushroom buttons, one red and one green.
    A handwritten sign is attached: <q>Out of Order---Jammed.</q> "
;
++ Button, Fixture 'large red mushroom button' 'red mushroom button'
    "It's a big red button with a rounded top. "
    okayPushButtonMsg = 'The button clicks, but nothing else seems to
        happen. '
;
++ Button, Fixture 'large green mushroom button' 'green mushroom button'
    "It's a big red button with a rounded top. "
    okayPushButtonMsg = 'The button clicks, but nothing else seems to
        happen. '
;
++ CustomImmovable 'handwritten sign' 'handwritten sign'
    "<q>Out of Order---Jammed.</q> "
    cannotTakeMsg = 'Removing the sign could create a safety hazard;
        better leave it. '
;

/* ------------------------------------------------------------------------ */
/*
 *   On the crate in the gap in the catwalk 
 */
syncOnCrate: SyncCatwalkRoom
    'On the Crate' 'the top of the crate' 'crate'
    "This is the top of a crate, which is wedged between the ends
    of the catwalk to the east and west.  The crate is easily large
    enough to stand on, providing a bridge across the gap.  Overhead,
    another section of catwalk is visible, suspended from above. "

    east = syncCatwalkGapEast
    west = syncCatwalkGapWest
    
    roomParts = static (inherited - catwalkFloor)
;

+ Floor 'large huge burnished aluminum metal crate/top/bridge'
    'top of the crate'
    "The top of the crate is burnished aluminum.  The crate is wedged
    between the ends of the catwalk, and the top is roughly level
    with the catwalk, creating a bridge across the gap. "

    dobjFor(LookIn)
    {
        action() { "There's no obvious way to open the create to look
            inside. "; }
    }
;

+ Distant '(east) (west) (e) (w) catwalk/walkway/section' 'catwalk'
    "Sections of the catwalk lie to the east and west. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Catwalk, east of the gap 
 */
syncCatwalkGapEast: SyncCatwalkRoom
    'Catwalk at Gap' 'the catwalk east of the gap'
    "The catwalk stretches east, and ends here to the west.  Dimly
    visible across a gap of about ten feet is another section of
    catwalk, apparently a continuation of this one; high overhead,
    above the gap, the underside of what looks to be a bridge is
    visible. "

    east = syncCatwalkEast
    west = (metalCrateTop.isIn(self) ? syncOnCrate : noWest)
    noWest: NoTravelMessage { "The gap is much too wide to jump across. "; }

    /* don't use the usual catwalk floor here, as there's another section */
    roomParts = static (inherited - catwalkFloor + syncCatwalkGapFloor)

    /* on the first arrival, award points for finding our way here */
    afterTravel(traveler, conn)
    {
        scoreMarker.awardPointsOnce();
        inherited(traveler, conn);
    }
    scoreMarker: Achievement { +5 "crossing the gap in the catwalk" }
;

/* ------------------------------------------------------------------------ */
/*
 *   Catwalk, east wall.
 */
syncCatwalkEast: SyncCatwalkRoom
    'Catwalk, Outside Office' 'the catwalk outside the office'
    "This section of catwalk runs along the front of a wooden
    structure, to the north.  The structure resembles a small
    house; a gray door (<<sceDoor.openDesc>>) in the wall
    is labeled <q>Office.</q>
    <.p>The catwalk continues west, and ends in a concrete
    wall to the east.  To the south, a stairway leads down. "

    west = syncCatwalkGapEast

    north = sceDoor
    in asExit(north)

    down = sceStairs
    south asExit(down)
;

+ Fixture 'east e concrete wall*walls' 'east wall'
    "The wall looks to be made of concrete. "
;

+ sceDoor: Keypad, Lockable, Door 'drab gray "office" door' 'gray door'
    "<q>Office</q> is painted in faded letters on the drab
    gray door.  A numeric keypad lock is where the doorknob
    would normally go. "

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
            "You key in zeroes to clear the combination, which should
            lock the door. ";
            sceKeypad.combo = '00000';
        }
    }
    dobjFor(Unlock)
    {
        check()
        {
            if (!usedCombo)
            {
                "It looks like you have to enter a combination on
                the keypad to unlock the door. ";
                exit;
            }
        }
        action()
        {
            "You key in the combination on the keypad; a soft
            click issues from the mechanism. ";
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
    'electronic keypad (door) lock locking lock/mechanism/keypad'
    'keypad lock'
    "It's an electronic keypad.  There's no display; just buttons
    labeled 0 to 9. "

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
                "Only digits can be entered on the keypad. ";
                return;
            }

            /* if the door's open, ignore it */
            if (location.isOpen)
            {
                "The keypad emits a long beep as you press each key. ";
                return;
            }

            /* check to see if we're changing state */
            change = (location.isLocked != (str != location.internCombo));

            /* set the combination */
            combo = str;
            "You push the buttons in sequence. ";

            /* check for a change in state */
            if (change)
                "The mechanism clicks softly. ";
        }
    }
    dobjFor(TypeLiteralOn) asDobjFor(EnterOn)
;
+++ Button, Component
    '(lock) (keypad) numbered 0 1 2 3 4 5 6 7 8 9 button*buttons'
    'lock keypad button'
    "The keypad has buttons labeled 0 to 9. "

    dobjFor(Push) { action() { "(You don't need to push the buttons
        individually; just enter the combination on the keypad.) "; } }
;


+ Enterable ->(location.north) 'wood wooden small structure/house/office'
    'wooden structure'
    "The structure is made of wood, and it looks like a small house.
    A door labeled <q>Office</q> leads inside. "
;

+ sceStairs: StairwayDown
    'metal stairway/stairs' 'metal stairway'
    "The stairs lead down into the darkness below. "
;

/* ------------------------------------------------------------------------ */
/*
 *   The sync lab office 
 */
syncLabOffice: Room
    'Office' 'the office'
    "This small, low-ceilinged room is lit mostly by the glow of
    a bank of video monitors arrayed along one wall.  In
    the center of the room, facing the monitors, sits a wrap-around
    desk with an office chair; a computer is on the desk.  Opposite
    the monitors is a set of shelves lined with rows of identical
    black binders.  A gray door leads out to the south. "

    south = sloDoor
    out asExit(south)

    /* on the first arrival, award points for finding our way here */
    afterTravel(traveler, conn)
    {
        scoreMarker.awardPointsOnce();
        inherited(traveler, conn);
    }
    scoreMarker: Achievement { +10 "getting into the Sync Lab office" }
;

+ sloDoor: Lockable, Door ->sceDoor 'drab gray door' 'gray door'
    "The door is painted a drab gray. "
;

+ Fixture
    'television static small video monitor/monitors/bank/screen/screens/
    image/images/tv/tv\'s/tvs/television/televisions'
    'bank of monitors'
    "They look like the security monitors you'd see in
    a convenience store: small screens showing static images
    shot through fish-eye lenses.  The images look like interior
    locations---some look like offices, others like labs.  You
    scan the monitors, and you realize that one of them is
    showing an image of Stamer's lab. "
;

+ Intangible 'stamer\'s image/lab/laboratory' 'image of Stamer\'s lab'
    "The image is fairly low-resolution, and the camera seems to
    be positioned at an odd angle, but you're pretty sure this
    is coming from the SPY-9 camera in the lab. "

    sightPresence = true
    dobjFor(Examine) { verify() { inherited(); } }
;

+ Heavy, Chair 'aeleron office (desk) chair' 'office chair'
    "It's one of those fancy Aeleron chairs, the kind that all
    the VP's have at Omegatron. "
;

+ Heavy, Surface 'wrap-around desk' 'desk'
    "The desk is shaped like a U, so that it wraps around its
    occupant.  A computer is positioned slightly to one side
    of the center. "
;

++ Keypad, CustomImmovable
    'mitamail e-mail email computer/terminal' 'computer'
    "It's not actually a computer; it's really one of those
    awful MitaMail e-mail terminals.  No one claims to like
    them, but Mitachron has somehow sold millions of them;
    they're even ubiquitous at Omegatron.
    <.p>The terminal is a one-piece unit with an amber text
    display and a keyboard. "

    dobjFor(TypeLiteralOn)
    {
        verify() { }
        action()
        {
            "As soon as you start typing, a cryptic error message
            appears on the screen.  You try a couple of other keys,
            and luckily you find one that clears the error. ";
        }
    }

    dobjFor(Read) remapTo(Read, mitaMailDisplay)

    nextMessage()
    {
        /* advance to the next message if possible */
        if (curMessageIdx < messageList.length())
            ++curMessageIdx;

        /* show the new message */
        "The display flashes a few times, then updates:<<showMessage>> ";
    }
    prevMessage()
    {
        /* back up if possible */
        if (curMessageIdx > 1)
            --curMessageIdx;

        /* show the new message */
        "The display flashes a few times, then updates:<<showMessage>> ";
    }

    showMessage()
    {
        "<.p><.blockquote><tt>
        <<messageList[curMessageIdx]>>
        </tt><./blockquote>";
    }

    curMessageIdx = 2
    messageList = [
        '@@# 392003-99203: AT SPOOL BOF {{[F13]}} NOT LEGAL
        \n@#@ 392770-20399: BAD FKEY PRESS, SEE SUBEXC
        \n@@# 392060-39902: USE {{[F7]}} FOR RESUMPTION OF FUNCTION',

        'From: frosstb@mitachron.com
        \nTo: normf@mitachron.com
        \nSubj: Re:\ research leads
        \bI have established my office here in Pasadena, in an unused
        space that is sure to go unnoticed.  This will accelerate our
        work here greatly.
        \bPer our discussion Monday, we have completed our list of
        projects of interest and have begun installation of video
        equipment in the identified locations.  We are capturing data
        from the neutron magnetic dipole moment experiment already; we
        hope to have anti-decoherence and Z0 prececession ready next
        week.  NI CO will be fully staffed within a fortnight.
        \n-fb',

        'From: normf@mitachron.com
        \nTo: frosstb@mitachron.com
        \nSubj: Re:\ research leads
        \bFrosst - We\'re very pleased with the progress so far.
        Please expedite the remaining installations.  Pay particular
        attention to the anti-decoherence experiment: the Galvani-2
        team has taken an interest in this and believes it is
        highly relevant.
        \b-Norm<.reveal galvani-2>',

        'From: frosstb@mitachron.com
        \nTo: normf@mitachron.com
        \nSubj: Re:\ research leads
        \bWe have completed installation of all video equipment.
        Per your direction, we are monitoring the anti-decoherence
        project with particular interest.  The project appears to
        be proceeding well; we are capturing data on an ongoing
        basis and will report as appropriate.
        \b-fb',

        'From: Cindy Anderson
        \nTo: frossta@mitachron.com,
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
        \nSubj: lower your mortgage rate! axjshe0193098 intense nowhere
        \bAre you paying 10%, 15%, even 20% for your mortgage?!? No
        more! Now you can get the lowest mortgage rates period!
        \b&gt;&gt;&gt;CLICK HERE!!!&lt;&lt;&lt;
        \bAlso the world\'s lowest price on herbal Vigara!
        \b(This is NOT SPAM!  If you are receiving this message, it is
        because you are on a carefully selected OPT-IN list.  It is not
        physically possible for this to be SPAM because you are OPTED IN.
        To be removed from this list, which you have OPTED IN for so
        this is NOT SPAM, just come visit our offices and ask us in
        person to be removed.  You can find our offices through our
        ISP - but that\'s not because we get kicked out, we are
        legitimate business people and NOT SPAMMERS, our ISP\'s can\'t
        kick us out for SPAMMING because WE ALREADY LEFT THEM! HA!) ',

        'From: izrum@mitachron.com
        \nTo: frosstb@mitachron.com
        \nSubj: anti-decoherence data
        \bFrosst - Norm instruct to contact you in regard
        anti-decoherence experiment you are perform.  My team have
        perform first Galvani-2 field deployment test.  Success
        only partial, due to same localization limits encountered in
        G-1.  Are now convinced of anti-decoherence technology
        to solve problem.
        \bHave overnight-sent (DefEx) report on experiment at you in
        Pasadena location.  For security reason, is in black status
        report binder with title of Efficiency Study #37.  Review
        please.
        \b/IhM.',

        'From: frosstb@mitachron.com
        \nTo: izrum@mitachron.com
        \nSubj: re:\ anti-decoherence data
        \bIzru - Attached are our data collected from the anti-decoherence
        experiment.  We have performed some preliminary analysis, and I
        believe you will find it quite applicable to Galvani-2.
        \b-fb
        \b@#@ATTACHMENT:&lt;&lt;DECOHER1.XLS&gt;&gt;
        \n#@#ATTACHMENT DELETED PER VIRUS SCAN POLICY',

        'From: normf@mitachron.com
        \nTo: frosstb@mitachron.com
        \nSubj: diversion
        \bGreat job so far in Pasadena.  Izru tells me Galvani-2 is
        going to benefit greatly.
        \bInterested in taking a day or two for an amusing diversion?
        We just heard O.\ is bidding a big power plant contract in Asia.
        We don\'t really want it, but I know how you enjoy playing with
        those guys.  If you\'re interested, take the co.\ jet and go
        do your wine-and-dine. Sarah has the details.
        \b-Norm',

        'From: izrum@mitachron.com
        \nTo: frosstb@mitachron.com
        \nCc: normf@mitachron.com
        \nSubj: re:\ anti-decoherence data
        \bFrosst - effusive thanks for data spreadsheet.  Most interesting.
        All now convinced of relevance.  Unfortunately, current expertise
        of area now insufficient.  To recommend hiring member of
        experiment team from Caltech.  Norm has approve headcount;
        select please candidate and recruit.
        \b/IhM.',

        'From: frosstb@mitachron.com
        \nTo: izrum@mitachron.com
        \nCc: normf@mitachron.com
        \nSubj: re:\ anti-decoherence data
        \bIzru - per your request, we have identified candidates on the
        anti-decoherence experiment team.  The top candidate is a
        Mr.\ B.\ Stamer.  He is a graduating senior, so we will easily
        obtain him through the standard college recruiting channels.
        \b-fb',

        'From: normf@mitachron.com
        \nTo: frosstb@mitachron.com
        \nSubj: re:\ anti-decoherence data
        \bThe student hire plan is exactly right.  Frosst, I want you
        to handle this personally.  Galvani-2 is growing in strategic
        importance and we need this expertise quickly.
        \b-Norm',

        '@@# 392003-29903: AT SPOOL EOF {{[F7]}} NOT LEGAL
        \n@#@ 392770-92903: BAD FKEY PRESS, SEE SUBEXC
        \n@@# 392060-23990: USE {{[F13]}} FOR RESUMPTION OF FUNCTION']
;
+++ mitaMailDisplay: Component, Readable
    'mitamail e-mail email computer terminal amber text display/screen'
    'computer display'
    "The display is currently showing a message in amber text:
    <.p><<location.showMessage>> "
;

/*
 *   The keyboard.  Make this match 'key' and 'keys', and make the
 *   individual keys match these words only weakly - this will ensure that
 *   these words are never ambiguous, since when used without an adjective
 *   they'll just refer to the overall keyboard object. 
 */
+++ Component
    'mitamail e-mail email computer terminal keyboard/key/keys' 'keyboard'
    "The keyboard has a row of function keys above the regular
    keys.  You've used these just enough to know that you press
    the F7 key to advance to the next mesage, and F13 to go to
    the previous message. "

    dobjFor(TypeOn) remapTo(TypeOn, location)
    dobjFor(TypeLiteralOn) remapTo(TypeLiteralOn, location, IndirectObject)
;
class MitaMailFKey: Button, Component
    desc = "The function keys are in a row above the main keyboard.
        They're labeled F1 through F17. "
;
++++ MitaMailFKey
    'f1 f2 f3 f4 f5 f6 f8 f9 f10 f11 f12 f14 f15 f16 f17
    function (key)/(keys)/row'
    'row of function keys'

    dobjFor(Push) { action() { "You push the key, and the display
        shows a cryptic error message.  You try a couple of other
        keys, and luckily you manage to clear the error. "; } }
;
++++ MitaMailFKey 'f7 (function) (key)' 'F7 key'
    dobjFor(Push) { action() { location.location.nextMessage(); } }
;
++++ MitaMailFKey 'f13 (function) (key)' 'F13 key'
    dobjFor(Push) { action() { location.location.prevMessage(); } }
;

+ Fixture, Consultable 'shelf/shelves/bookshelf/bookshelves' 'shelves'
    "The shelves are full of black binders, lined up in neat rows. "
    isPlural = true

    iobjFor(PutOn) { verify() { illogical('The shelves are too full;
        there\'s no room to add anything. '); } }
    iobjFor(PutIn) asIobjFor(PutOn)

    dobjFor(Search) asDobjFor(LookIn)
    lookInDesc = "There are too many binders to look through all
        of them.  Many are labeled, though, so you could probably
        find a specific one if you knew what you were looking for. "
;
/* use LibBookTopic for this, as it works the same way */
++ LibBookTopic @efficiencyStudy37Topic
    myBook = efficiencyStudy37

    /* don't allow retries, since we can't put it back */
    isActive = (myBook.location == nil)
;

/* likewise, include an unbook in case we TAKE it before finding it */
++ LibUnbook '37 efficiency study'
    notHereMsg = 'You don\'t see that lying around, but it might
        be buried among the other binders; you might be able to
        find it if you looked for it. '
;

++ DefaultConsultTopic
    "You scan the shelves, but you don't find what you're looking for. "
;

++ efficiencyStudy37: PresentLater, Readable, Consultable
    '37 efficiency black study/binder' 'Efficiency Study #37'
    "The black binder is labeled <q>Efficiency Study #37</q> on
    its spine. "

    readDesc = "There seems to be a lot of information inside.
        You flip to the front and scan over the table of
        contents:
        \b\tOverview
        \n\tBudget
        \n\tField Deployment Test
        \n\tChallenges
        \n\tFuture Plans "

    isProperName = true

    /* OPEN BINDER is equivalent to READ */
    dobjFor(Open) asDobjFor(Read)
;
+++ es37Overview: Component, Readable 'overview section' 'Overview section'
    "You flip to the Overview section.  As you expected, this isn't
    an <q>efficiency study</q> at all, but information about something
    called Project Galvani-2.  There's nothing specific about what the
    project is supposed to do; instead, the focus is how Galvani-2
    plans to overcome the problems of its predecessor, Project Galvani-1.
    <.p>The primary limitation of Galvani-1, according to the report,
    was that it required users to wear unwieldy headgear.  There's
    an illustration of a man wearing something that looks like an
    early diving helmet, or one of those old beauty shop hair dryers.
    Galvani-2 is supposed to fix this problem by working at a distance
    from the user (actually, the word the report keeps using is
    <q>subject</q>), eliminating the need for the headgear.
    <.reveal galvani-2-overview> "
;
+++ es37Budget: Component, Readable 'budget section' 'Budget section'
    "You read over the budget section with amazement.  This single
    project has funding that's more than five times your whole
    department's annual budget.  The strange thing is that you
    can't think of any Mitachron products that seem related to
    this project; they seem to be funding this as a pure research
    effort. "
;
+++ es37Test: Component, Readable 'field deployment test section'
    'Field Deployment Test section'
    "This section describes a field test of Galvani-2.  The
    deployment was at a recent trial.  You remember it---one
    of the mid-western states was suing Mitachron over alleged
    antitrust violations.  It looked obvious to everyone that
    Mitachron was guilty, but they somehow won acquittal.  Even
    the judge said in an interview later that she was surprised
    by her own decision.
    <.p><q>This proves the efficacy of the
    approach,</q> the report says.  <q>It required exceptional
    creativity to dupe a subject into wearing the Galvani-1 headgear
    while concealing its purpose.  The Galvani-2 design, in
    contrast, will be almost trivial to deploy surreptitiously,
    once we overcome the present range limitations.  Even with
    today's range limits, deployment is still possible under
    sufficiently controlled conditions, as this test demonstrated:
    technicians were able to conceal control and power supply
    equipment in simple cardboard boxes that purportedly contained
    paper files, and concealed the transmitters in laptop
    computers... There is no question that the subject was acting
    under the influence of the Galvani field and ruled favorably
    as a result.</q> "
;
+++ es37Challenges: Component, Readable 'challenges section'
    'Challenges section'
    "This section is short and sketchy.  It lists several issues
    that must be familiar to those working on the project, but mean
    nothing to you.  The only part with any detail describes a
    problem with <q>range and scope</q>: the project apparently
    works at short range and with a single <q>subject,</q> but
    an ongoing problem with <q>decoherence effects</q> is preventing
    the project from reaching its full objectives. "
;
+++ es37Futures: Component, Readable 'future plans section'
    'Future Plans section'
    "<q>The first planned production deployments of the Galvani-2
    devices are still mostly in government buildings.  However, we
    are currently de-emphasizing the legislative rollout per the
    recent analysis by our political ops team, which projects
    greatly reduced risk of exposure, and improved operational
    efficiency, by focusing first on key bureaucratic
    decision-makers... With the ease of deployment of the
    Galvani-2 design, though, we are already looking beyond
    government applications.  The potential for modifying consumer
    behavior is enormous.  Imagine the effect of field emitters set
    up in major shopping malls, set to transmit messages such as
    <q>Buy more Mitachron products now</q> or <q>Mitachron products
    make me feel good about myself</q>... Within three years,
    component costs should be low enough that we can include
    miniature field emitters in our business and consumer terminal
    products (MitaMail, MitaMon, etc).  With modest e-commerce
    partnering initiatives, we could directly control on-line
    shopping behavior... Even when the Galvani-2 government
    rollout is completed, we can't expect full control over 
    variables, as today's first-world governments are complexes
    of interlocking systems that can defy the will of any individual
    component.  Fortunately, the company's quiet involvement in
    electronic voting systems (FairVote, e-TrustSafe, etc) creates an
    ideal opportunity to bypass the vagaries of legislatures and
    bureaucracies by modifying political behavior at the level of
    individual voters.  This will ultimately give us our most
    powerful capabilities...</q><.reveal galvani-2-full> "
;

class ES37Topic: ConsultTopic
    topicResponse = (matchObj.actionDobjRead())
;
+++ ES37Topic @es37Overview;
+++ ES37Topic @es37Budget;
+++ ES37Topic @es37Test;
+++ ES37Topic @es37Challenges;
+++ ES37Topic @es37Futures;
+++ DefaultConsultTopic "You don't see that section in the binder. ";


/* a generic object for the binders */
++ GenericObject, CustomImmovable
    'identical black binder/binders' 'black binders'
    "The binders are lined up in neat rows, completely filling the
    shelves.  They're all identical, except that many are marked.
    You might be able to find a specific one if you knew what you
    were looking for. "
    
    isPlural = true
    cannotTakeMsg = 'There are too many binders to take them all.
        Many are labeled, though, so you might be able to find a
        specific one if you knew what you were looking for. '

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
    vocabWords = 'sync synchrotron lab/laboratory'
    name = 'Sync lab'
    
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
    up: NoTravelMessage { "There's no obvious way up from here. "; }
;

syncFloor: Floor
    '(sync) (synchrotron) (lab) (laboratory) rough concrete floor/slab'
    'floor'
    "The floor is a slab of rough concrete. "
;

syncCrates: CustomImmovable, RoomPart
    'wooden cardboard
    box/boxes/crate/crates/stack/stacks/container/containers'
    'wooden crates'
    "There's a mix of wooden crates and cardboard boxes of varying
    sizes, mostly large.  Some are marked with a few random letters
    or numbers, but none of the markings are meaningful to you.
    The containers are stacked densely and seemingly haphazardly.
    Many of the stacks reach well above your own height. "

    isPlural = true

    cannotTakeMsg = 'You\'d need a forklift to effect any significant
        rearrangement. '

    dobjFor(Open)
    {
        verify() { logicalRank(50, 'sync boxes'); }
        action() { "The boxes and crates are stacked too high for
            you to get into any of them. "; }
    }
    dobjFor(LookIn) asDobjFor(Open)
    dobjFor(Search) asDobjFor(Open)
    dobjFor(LookThrough) asDobjFor(Open)
    dobjFor(LookBehind) asDobjFor(Open)
    dobjFor(LookUnder) asDobjFor(Open)

    dobjFor(Climb)
    {
        verify() { logicalRank(50, 'sync boxes'); }
        action() { "None of the stacks of boxes look readily climbable. "; }
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
    "The crates are packed in too tightly; there's no way through. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Sync Lab 1 - at base of stairs on west side
 */
syncLab1: SyncLabRoom
    'Sync Lab near Stairs' 'the area near the stairs' 'corner'
    "This corner of the Sync Lab floor is closed in by boxes and
    crates stacked high all around, with just enough space left
    open to form a walkway.  The area along the west wall is mostly
    clear, providing access to a metal stairway, which leads up
    to the north.  A path is open to the northeast as well. "

    vocabWords = 'corner/walkway'

    northeast = syncLab2
    up = sl1Stairs
    north asExit(up)

    /* customize 'west', since it's blocked by something other than crates */
    west: NoTravelMessage { "You can't go that way. "; }
    southwest = (west)
    northwest = (west)
;

+ Fixture 'west w wall*walls' 'west wall'
    "The area along the west wall is mostly unobstructed, leaving
    access to a metal stairway leading up to the north. "
;

+ EntryPortal ->(location.northeast) 'path' 'path'
    "The path leads northeast through the stacks of boxes. "
;

+ sl1Stairs: StairwayUp ->scswStairDown
    'metal stair/stairs/stairway' 'metal stairway'
    "The stairs lead up along the west wall, disappearing into
    shadow. "
;

/* ------------------------------------------------------------------------ */
/*
 *   The metal crate in its original position has two distinct sides - one
 *   in syncLab2, one in syncLab4.  Use a MultiFaceted to implement this.  
 */
metalCrate: MultiFaceted
    locationList = [syncLab2, syncLab4]
    instanceObject: Heavy, TravelPushable, Underside {
        'especially large huge burnished aluminum metal crate' 'metal crate'

        desc()
        {
            "The crate is huge: it must be ten or twelve feet high, and
            almost as wide.  Most of the other crates around here are
            wooden, but this one is made of a burnished metal, probably
            aluminum. ";
            
            /* add something about our location */
            switch (location)
            {
            case syncLab2:
                if (inOrigPos)
                    "It's wedged in among numerous other crates and boxes
                    stacked along the west side of the area. ";
                else
                    "It's sitting out in the middle of the area. ";
                break;

            case syncLab3:
                "It looks to be wedged between the two ends of the
                catwalk overhead. ";
                break;

            case syncLab4:
                "It's wedged in among numerous other crates and boxes
                stacked up here, blocking the way east. ";
                break;
            }
            
            /* if the casters haven't been seen, mention the space below */
            if (!metalCrateWheels.discovered)
                "<.p>On closer inspection, the crate seems to be raised up
                slightly off the floor; there must be something under it. ";
        }

        lookInDesc = "There's no obvious way to open the crate to
            look inside. "
        
        /* are we in our original position? */
        inOrigPos = true
        
        specialDesc()
        {
            switch (location)
            {
            case syncLab2:
                if (inOrigPos)
                    "The way west is blocked by an especially large
                    metal crate. ";
                else
                    "A huge metal crate is sitting in the middle of
                    the area. ";
                break;

            case syncLab4:
                "A huge metal crate is blocking the way east. ";
                break;

            case syncLab3:
                "A huge metal crate, ten feet wide, is positioned
                under the gap in the catwalk, and looks to be wedged
                between the two ends. ";
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
                    "You give the crate a push, and find that it moves
                    surprisingly easily given its obvious weight. ";

                    if (inOrigPos)
                        "But you only manage to move it a few inches before
                        something blocks it. ";
                    else
                        "There's probably enough open space that you could
                        push it north if you wanted to. ";
                    break;

                case syncLab4:
                    /* handle this as PUSH CRATE EAST */
                    replaceAction(PushEast, self);
                    break;

                case syncLab3:
                    "The crate seems to be stuck between the two
                    ends of the catwalk.  It won't budge. ";
                    break;
                }
            }
        }
        dobjFor(Move) asDobjFor(Push)
        dobjFor(Turn) asDobjFor(Push)
        
        dobjFor(Pull)
        {
            verify() { }
            action() { "You can't get a good enough grip on the
                the crate to pull it anywhere. "; }
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
                "The crate is far too heavy to lift. ";
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
                    "You can't get a good enough grip on the
                    crate from here to pull it out from the
                    other things stacked around it. ";
                else
                    "You try pushing the crate.  It moves
                    surprisingly easily given its obvious weight,
                    but you can only move it a few inches before
                    something blocks it. ";
            }
            else if (isIn(syncLab3))
            {
                /* we're wedged in our final position; handle as a PUSH */
                replaceAction(Push, self);
            }
            else
            {
                /* anywhere else, we just don't have enough room */
                "It doesn't look like there's enough clearance
                to move the crate that way. ";
            }
        }

        /* receive notification that I'm being pushed somewhere */
        beforeMovePushable(trav, conn, dest)
        {
            /* what happens depends upon where we are now */
            if (isIn(syncLab4))
            {
                "You lean against the huge crate and give it a good,
                solid push.  It slowly starts rolling, and you
                step forward, digging in your heels, still pushing it.
                A few feet in, you notice the other crates and boxes
                stacked alongside start wobbling precariously.
                You urgently push the wall of aluminum forward,
                and you just manage to get out of the way as piles
                of boxes come tumbling in from all directions to
                fill the gap. ";

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
                "You give the crate a strong push, and it starts
                rolling north.  You keep pushing it, picking
                up speed, when suddenly it slams to a halt
                with a loud metal-on-metal crash that echoes
                from overhead.  You look up, and you realize
                that the crate has wedged itself between the
                two ends of the catwalk, filling in the gap. ";

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
                "You let the crate roll to a stop in the center of
                the area. ";
            }
            else if (isIn(syncLab3))
            {
                "The metal crate is wedged between the ends of the
                catwalk. ";
            }
        }

        /* we can't add new things underneath */
        allowPutUnder = nil
    }
;

+ metalCrateWheels: Component, Hidden
    'caster/casters/wheel/wheels/(set)' 'casters'
    "It's too dark under the crate to see much detail, but it
    looks like there's a wheel at each corner, presumably to
    make it possible to move the crate around by pushing it. "

    /* use the special description only in contents, not in the room */
    useSpecialDescInRoom(room) { return nil; }
    specialDesc = "It's hard to see in the shadows under the crate,
        but it looks like the crate is sitting on a set of casters. "

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
    'Open Area' 'the open area'
    "This is a large clearing in the clutter of boxes and crates
    filling the Sync Lab.  Yellow light trickles down from fixtures
    high overhead, faintly illuminating the tightly-packed stacks
    of crates bounding the area to the east, west, and south.  A
    narrow passage leads between stacks to the southwest, and the
    way north is mostly open.  Another small opening between boxes
    leads to the southeast. "

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

+ EntryPortal ->(location.southwest) 'narrow passage' 'narrow passage'
    "The passage leads southwest between stacks of crates. "
;

+ EntryPortal ->(location.southeast) 'small opening' 'small opening'
    "There's just enough space between boxes to go southeast. "
;


/* ------------------------------------------------------------------------ */
/*
 *   Sync Lab 3 - north end 
 */
syncLab3: SyncLabRoom
    'Under Catwalk' 'the area under the catwalk' 'open area'
    "This is an open area among the crates.  The clearing extends to
    the south; dense stacks of boxes and crates wall off the other
    directions, although a passage has been left clear to the
    east, and a narrow opening might be passable to the southwest.
    <.p>Overhead, about one story up, the underside of a metal
    catwalk is just visible in the dim light.  The catwalk runs east
    and west, but it's interrupted directly overhead by a wide gap of
    about ten feet. "

    south = syncLab2
    east = syncLab5
    southwest = syncLab4
;

+ Distant 'metal catwalk/underside/gap/end/ends' 'metal catwalk'
    "The catwalk runs east and west.  It's interrupted by a
    gap of about ten feet<< metalCrate.isIn(syncLab3)
      ? ", which is filled in by a huge metal crate logdged
        between the ends of the catwalk" : ""
      >>. "
;

+ EntryPortal ->(location.east) 'east e passage' 'east passage'
    "The passage leads east, between stacks of crates. "
;

+ EntryPortal ->(location.southwest)
    'narrow southwest sw opening' 'narrow opening'
    "The opening looks just large enough to get through.  It leads
    southwest through the stacks of boxes. "
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
        action() { "This is the underside of the stairway.  There's no
            obvious way around to the front of the stairs from here."; }
    }
    dobjFor(ClimbUp) asDobjFor(Climb)
    dobjFor(ClimbDown) asDobjFor(Climb)
;

/* ------------------------------------------------------------------------ */
/*
 *   Sync Lab 4 - under stairs 
 */
syncLab4: SyncLabRoom
    'Under Stairs' 'the area under the stairs' 'nook'
    "This is a cramped, dark nook underneath a stairway, which
    slopes down until it reaches the floor at the south end
    of the area.  Boxes and crates are stuffed into the sloping
    space, leaving little space to move around.  A narrow opening
    through the crates leads northeast. "

    vocabWords = 'cramped dark nook'

    northeast = syncLab3
    south: NoTravelMessage { "The stairs, and the crates packed
        underneath, are in the way. " }

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
    'narrow northeast ne passage/opening' 'narrow opening'
    "The passage leads northeast.  It looks just barely passable. "
;

+ SyncStairUnderside 'stairs/stairway/underside' 'stairs'
    "Only the underside of the stairway is visible here; it slopes
    downward to the south.  Boxes and crates are stuffed into the
    available space under the stairs. "

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
    'Tunnel' 'the tunnel'
    "This is a low, dark tunnel, bounded by a concrete wall on the
    east side and stacks of crates along the west side.  Overhead,
    a metal walkway runs north and south along the wall.  The
    tunnel ends at more boxes to the north, but an opening through
    the crates leads west.
    <.p>The tunnel ends to the south in the underside of a
    stairway, which runs from the walkway overhead down to
    the floor. "

    vocabWords = 'sync synchrotron lab/laboratory/tunnel'

    roomParts = (inherited - syncLights)

    west = syncLab3
    south: NoTravelMessage { "The stairs are in the way. " }
    east: NoTravelMessage { "You can't go that way. " }
    northeast = (east)
    southeast = (east)
;

+ Fixture 'east e concrete wall*walls' 'concrete wall'
    "The wall is made of concrete. "
;

+ EntryPortal ->(location.west) 'west w opening' 'opening'
    "The opening leads through the crates to the west. " 
;

+ Distant 'metal walkway/catwalk' 'metal walkway'
    "The walkway imposes a low ceiling on the tunnel.  At the
    south end, the tunnel ends in the underside of a stairway
    leading down from the walkway to the floor. "
;

+ sl5Stairs: SyncStairUnderside
    'metal stairway/stairs/underside' 'metal stairway'
    "The stairs slope down from the walkway to the floor.
    Only the underside is visible from here. "
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
    'Sync Lab at Stairs' 'the Sync Lab, at the stairs' 'area near the stairs'
    "This area is so densely stacked with boxes that there's
    barely room to stand.  A stairway to the north leads up,
    and boxes are packed in all around the landing, leaving
    only a narrow passage between the clutter and the east
    wall. <<isCrateAtNorth
      ? "It looks like the passage continues to the south, but a
        large wooden crate, slightly taller than you are and almost
        too wide for the passage, blocks the way. "
      : "A dull metal door is set into the wall just south
        of the stairs.  It looks as though the passage continues
        further south, but a large wooden crate blocks the way. " >>
    <.p>A legend reading <q>Office,</q> with an arrow pointing up
    the stairs, is painted on the wall. "

    up = sl6nStairs
    north asExit(up)

    south: NoTravelMessage { "The large crate is in the way. "; }

    /* the door is accessible if the crate is to the south */
    east = (isCrateAtNorth ? noEast : sl6Door)

    /* there's a wall (not boxes) in the way to the east */
    noEast: NoTravelMessage { "You can't go that way. "; }
    southeast = (noEast)
    northeast = (noEast)

    isCrateAtNorth = nil
;

+ sl6nStairs: StairwayUp ->sceStairs
    'metal stairway/stairs/(foot)' 'stairway'
    "The metal stairway leads up to the north. "
;

+ sl6Door: Lockable, Door ->syncDoor
    'dull metal door' 'dull metal door'
    "The door is made of a dull metal. "
;

+ Fixture 'concrete east e wall*walls' 'east wall'
    "The wall is made of concrete.  The legend <q>Office,</q> with
    an arrow pointing up, is painted by the stairs. "
;
++ Decoration 'painted "office" legend/arrow' '<q>Office</q> legend'
    "The legend reads <q>Office,</q> with an arrow pointing
    up the stairs. "
;

class SyncLab6Crate: CustomImmovable
    'large wooden wood crate' 'large wooden crate'
    "The crate doesn't have any obvious markings.  It's a little
    taller than you are and almost too wide for the passage, so
    it's impossible to see around it. "

    cannotTakeMsg = 'The crate is too large.  Probably the only
        way you could move it would be to push it. '

    dobjFor(Pull)
    {
        verify() { }
        action() { "You look for something to grab onto, but you
            can't find anything that would let you get a good
            enough grip. "; }
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
        action() { "The crate is too tall, and there's nothing to grab
            onto. "; }
    }
    dobjFor(ClimbUp) asDobjFor(Climb)
    dobjFor(Board) asDobjFor(Climb)

    dobjFor(Open)
    {
        verify() { }
        action() { "There's no obvious way to open it. "; }
    }

    nothingBehindMsg = 'The crate is so large that it almost completely
        obstructs your view. '
;

+ SyncLab6Crate
    dobjFor(Push)
    {
        action()
        {
            if (syncLab6N.isCrateAtNorth)
            {
                "You brace yourself against the stairs and push as
                hard as you can.  The crate grudgingly slides south,
                making a horrible screeching as it scrapes along the
                floor.  After a few feet, you discover a door in the
                east wall that was hidden behind the crate.  You
                manage to push the crate just past the door, but it
                catches on something, and you can't move it any
                further. ";

                /* move it south */
                moveCrateNorth(nil);
            }
            else
                "You push the crate as hard as you can, but you
                can't seem to budge it. ";
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
                "There's no obvious way to push the crate any way
                but south from here. ";
        }
    }
;


/*
 *   Sync Lab 6 South. 
 */
syncLab6S: SyncLabRoom
    'Narrow Passage' 'the narrow pasage' 'narrow passage'
    "Boxes and crates are stacked densely here, leaving only
    a narrow passage along the concrete wall to the east.
    << syncLab6N.isCrateAtNorth
      ? "A dull metal door is set into the wall. "
      : "The passage appears to continue further north, but
        the way is blocked by a wooden crate, slightly
        taller than you are and almost too wide for the passage. "
    >> It also looks like there's enough space to get through
    an opening between the boxes to the west.
    <<syncLab6N.isCrateAtNorth
      ? "A large wooden crate, slightly taller than you are,
        blocks travel to the north; in the dim lighting, you
        can just barely make out a stairway leading up on the
        other side of the crate. " : ""
    >> "

    west = syncLab2
    northwest asExit(west)
    north: NoTravelMessage { "The large crate is in the way. "; }

    /* the door is accessible if the crate is to the north */
    east = (syncLab6N.isCrateAtNorth ? sl6Door : noEast)

    /* there's a wall (not boxes) in the way to the east */
    noEast: NoTravelMessage { "You can't go that way. "; }
    southeast = (noEast)
    northeast = (noEast)
;

+ EntryPortal ->(location.west) 'west w opening' 'opening'
    "The opening is just large enough to let you slip through
    to the west. "
;

+ sl6sStairs: PresentLater, Distant 'metal stairway/stairs' 'stairway'
    "You can just barely see the stairs on the other side of the
    crate. "
;

+ SyncLab6Crate
    dobjFor(Push)
    {
        action()
        {
            if (!syncLab6N.isCrateAtNorth)
            {
                "You lean against the crate and push it as hard as
                you can.  The crate won't move at all for several
                seconds, but you finally manage to break it loose.
                It screeches horribly as it scrapes along the floor.
                After pushing a few feet, you discover a door in the
                east wall that was hidden behind the crate.  You
                keep going until the door is accessible, but then
                the crate hits something solid and refuses to move
                any further.  In the dim lighting, you can just barely
                make out a stairway leading up on the other side of
                the crate. ";

                /* move it north */
                moveCrateNorth(true);
            }
            else
                "You push the crate as hard as you can, but you
                can't seem to budge it. ";
        }
    }

    dobjFor(LookBehind)
    {
        action()
        {
            if (syncLab6N.isCrateAtNorth)
                "You can see a stairway rising on the other side
                of the crate. ";
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
                "There's no obvious way to push the crate any way
                but north from here. ";
        }
    }
;

+ Fixture 'concrete east e wall*walls' 'east wall'
    "The wall is made of concrete. "
;
