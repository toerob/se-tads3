/*
 *   Copyright 2003, 2013 Michael J. Roberts
 *   
 *   Return to Ditch Day - Dabney Hovse.  Dabney is implemented in
 *   considerable detail, so it rates its own module.  
 */

#include <adv3.h>
#include <en_us.h>
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
    cannotUseMapHere = "(The map only shows the locations of buildings,
        so you'll have to go outside Dabney if you want to figure the
        way there.) "
;

/* ------------------------------------------------------------------------ */
/*
 *   breezeway 
 */
dabneyBreezeway: Room 'Breezeway' 'the breezeway'
    "This wide passageway opens onto a courtyard to the east, and
    to the west leads out of the house to the Orange Walk.  A dimly-lit
    hallway leads into the house to the north; painted on the wall
    alongside the hallway is the legend <q>1-9</q>. "

    vocabWords = 'breezeway'

    west = orangeWalk
    out asExit(west)
    north = alley1S
    in asExit(north)
    east = dabneyCourtyard
    
    roomParts = static (inherited - [defaultEastWall, defaultWestWall])

    atmosphereList = (dbwMovers.isIn(self) ? moversAtmosphereList : nil)
;

+ bwSmoke: PresentLater, Vaporous 'thick black smoke/cloud/clouds' 'smoke'
    "The smoke billows out of the hallway in thick black clouds. "
    specialDesc = "Thick black smoke billows out of the hallway. "
    isMassNoun = true

    lookInDesc = "The smoke is almost opaque; you can't see into the
        alley at all. "

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
    desc = "The smoke has the acrid odor of burning electronics. "
;

+ Decoration 'legend/numbers' 'legend'
    "The legend <q>1-9</q> is painted on the wall alongside the hallway,
    indicating that rooms 1 through 9 lie this way. "
;

+ Enterable ->(location.east) 'courtyard' 'courtyard'
    "The courtyard lies to the east. "
;

+ EntryPortal ->(location.north)
    'dimly-lit dim north n 1 alley one/hall/hallway' 'hallway'
    "The hallway leads north. "
;

+ Enterable ->(location.west) 'orange walk/walkway' 'Orange Walk'
    "The Orange Walk is outside to the west. "
;

+ Enterable ->(location.east) 'courtyard' 'courtyard'
    "The courtyard lies to the east. "
;

+ dbwMovers: MitaMovers
    "Movers just keep coming in from the Orange Walk, carrying their
    boxes into the hallway.  Others emerge from the alley empty-handed
    and head outside. "

    "Mitachron movers are steadily coming in from the Orange Walk and
    carrying their loads into the hallway. "
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
        name = 'movers'
        isPlural = true
    }
;

+ Immovable 'white uniforms/jumpsuits' 'uniforms'
    "The movers are wearing white jumpsuits with big Mitachron logos
    on the back. "
    isPlural = true
;

++ Component 'mitachron logo/logos' 'Mitachron logo'
    "It's the standard Mitachron yellow <q>M</q> against an outline
    of a globe. "
;

+ Immovable 'cardboard wood wooden box/boxes/crate/crates' 'crates'
    "The movers are carrying cardboard boxes and wooden crates
    of varying sizes, some large enough or evidently heavy enough
    to require two or three people to carry. "
    isPlural = true

    lookInDesc = "There's no way you can look through the boxes
        while the Mitachron people are busy with them. "
;

/* 
 *   A class for the movers.  The movers all show up later in the game, so
 *   make the PresentLater objects. 
 */
class MitaMovers: PresentLater, Person
    'mitachron mover/movers/man/woman*men women' 'movers'
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
    ['One of the movers bumps into you with a crate.  You start to
    apologize, but he\'s already pushed past. ',
     'Two movers carrying an especially large crate work their way
     past you. ',
     'Several empty-handed movers stream past. ',
     'Four movers carrying identical boxes maneuver past you. ',
     'A pair of movers carrying an eight-foot cardboard tube go past. ',
     'Four movers work their way past carrying a heavy-looking
     crate suspended from a pair of poles. ',
     'A traffic jam briefly forms as a half-dozen movers try to
     come through at the same time, but the knot soon clears. ']
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
    cannotEnter = "It would be rude to enter without permission. "

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
class AlleyDoor: ForbiddenDoor 'wood wooden room room/door*doors'
    cannotEnter = "That's someone's private room---you wouldn't want to
        enter uninvited. "

    dobjFor(Knock) { action() { "You knock, but there's no reply.
        The person who lives here is probably off doing something
        Ditch Day-related. "; } }
;

/*
 *   A door for a room with a stack 
 */
class StackDoor: AlleyDoor
    cannotEnter()
    {
        if (isSolved)
            "Even though you did manage to solve the stack, you wouldn't
            feel right about spoiling it for the undergrads.  Besides,
            the <q>bribes</q> most seniors leave as rewards for breaking
            their stacks are just a bunch of junk food. ";
        else
            "You can't enter until the stack is solved. ";
    }
    
    dobjFor(Knock) { action() { "You knock, but there's no reply.
        The owner is presumably away for Ditch Day. "; } }

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
    desc = "The walls are decorated with graffiti. "
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
    vocabWords = 'alley/alleyway/hall/hallway'
    name = 'hallway'
;

/* base class for graffiti on the alley walls */
class Graffiti: Decoration 'graffiti/graffito' 'graffiti'
    dobjFor(Read) asDobjFor(Examine)
;
Graffiti template "desc";

/* ------------------------------------------------------------------------ */
/*
 *   alley one south 
 */
alley1S: AlleyRoom 'Alley One South' 'south end of Alley One'
    "Some of the other houses give fanciful names to their alleys, but
    for some reason the Darbs never bothered; they just refer to their
    alleys by number, this one being Alley One.  Room 1 is to the east and
    room 2 to the west; the hallway continues north, and a doorway leads
    south.
    <.p>The walls are heavily adorned with graffiti, as they were when
    you were a student here. "

    vocabWords = '1 alley one'

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
        "You try to make your way into the alley, but the smoke is
        too thick. ";
    }
;

+ room1Door: AlleyDoor '1 -' 'door to room 1'
    "It's a worn wooden door labeled <q>1.</q> "
;

+ room2Door: AlleyDoor '2 -' 'door to room 2'
    "It's a wooden door labeled <q>2.</q> "
;

+ EntryPortal ->(location.south) 'south s doorway' 'doorway'
    "The doorway leads out of the hallway to the south. "
;

++ Decoration 'main left right photocopy/rat/pictures/photos/caption'
    'photocopy'
    "It's a photocopy of a page from a textbook.  It has two pictures
    of rats, side by side.  In the left picture, captioned <q>Rat out
    of control,</q> the rat looks terrible: it's emaciated, and
    big clumps of fur are missing.  In the right picture, labeled
    <q>Rat in control,</q> the rat looks happy and healthy.  The
    main caption reads:
    <.p><b>Stress and control.</b> In the photo on the left,
    the rat is given small, harmless electrical shocks at random.  The
    rat has no way of controlling the shocks, and in only a few days
    becomes overwhelmed with stress.  In the photo on the right, the
    rat is given the same electrical shocks, but can stop each shock
    by pressing on a paddle in its cage.  Even though both rats are
    subjected to similar types and amounts of stress, the rat with
    control over the source of the stress remains healthy. "

    specialDesc = "A photocopy is attached to the door. "
    useSpecialDescInRoom(room) { return nil; }
;

+ Graffiti
    'new newer old older abstract fantasy
    art/artwork/part/parts/psychedelica/mural/murals/scribbling/scrawling'
    'graffiti'
    "When the Institute renovated the South Houses a few
    years ago, the students persuaded the housing office to preserve
    some of the better bits of Dabney graffiti, so what's on the walls
    now is a mix of old and new.  The artwork here is mostly
    abstract psychedelica and fantasy murals, some pretty good;
    there's also a lot of less-than-artistic scribbling. "
;

+ a1sMovers: MitaMovers
    "Movers keep streaming in from the south, carrying their
    loads to the north end of the alley, others returning empty-handed
    and heading back outside. "

    "A steady stream of Mitachron movers are pushing their way past
    you with bulky loads of boxes and crates, heading to the north
    end of the alley. "
;


/* ------------------------------------------------------------------------ */
/*
 *   Alley 2 - north end
 */
alley2N: AlleyRoom 'Alley Two' 'Alley Two'
    "Alley Two is just a short run of hall at the top of a broad
    stairwell.  The door to room 6 is to the east.  The stairs to
    the north lead down, and the hall continues south. "

    vocabWords = '2 alley two'

    roomParts = static (inherited + [alleyWestWall, alleyEastWall])

    down = alley2Stairs
    north asExit(down)
    east = room6door
    south = alley2S
;

+ alley2Stairs: StairwayDown ->alley1Stairs
    'broad stair/stairway/stairs/stairwell' 'stairway'
    "The stairs lead down. "
;

+ room6door: AlleyDoor '6 -' 'door to room 6'
    "It's a wooden door labeled <q>6.</q> "
;

+ Graffiti
    'large fantasy landscape
    mural/tower/towers/spire/spires/mountain/mountains'
    'graffiti'
    "A large fantasy landscape mural covers one wall: towers, spires,
    mountains in the distance. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Alley 2 - south end 
 */
alley2S: AlleyRoom 'Alley Two South' 'the south end of Alley Two'
    "Alley Two ends here in two more room doors, room 7 to the west
    and room 9 to the east.  The alley continues north. "

    vocabWords = '2 alley two'

    north = alley2N
    west = room7door
    east = room9door

    roomParts = static (inherited
                        + [alleyWestWall, alleyEastWall, alleySouthWall])
;

+ room7door: AlleyDoor '7 -' 'door to room 7'
    "It's a wooden door labeled <q>7.</q> "
;

+ room9door: AlleyDoor '9 -' 'door to room 9'
    "It's a wooden door labeled <q>9.</q> "
;

+ Graffiti 'expansive intertwined vine/vines/pattern' 'graffiti'
    "This end of the hall is decorated with an expansive pattern of
    intertwined vines. "
;


/* ------------------------------------------------------------------------ */
/*
 *   Dabney courtyard 
 */
dabneyCourtyard: DabneyOutdoorRoom 'Courtyard' 'the courtyard'
    "This large interior courtyard is dominated by what looks to be
    a papier-m&acirc;ch&eacute; scale-model mountain: a two-story
    edifice of cliffs and boulders, rising in the center of the
    courtyard to a peak higher than the surrounding courtyard walls.
    Piled randomly around the base are metal canisters marked with
    radiation warnings, many split open and leaking green goo.
    <<initialExplanation>>
    <.p>
    The courtyard itself follows the Mediterranean style of the
    south houses: red brick floor, stucco walls, casement windows,
    columns supporting an arcaded overhang to the east, terra cotta
    tiles on the gently-sloped roofs.  Under the overhang, doors
    lead east into the lounge.  The alley 3 entrance is to the
    southwest, and alley 5 is to the southeast.  A small alcove
    lies to the south.  To the west is a breezeway leading outside,
    and a long concrete stairway goes up. "

    /* provide a background explanation on the first viewing */
    initialExplanation()
    {
        if (!seen)
            "<.p>This must all be a decoration for a recent
            multi-house party.  It's pretty remarkable; back in your
            day, the Darbs couldn't usually be bothered to pick a theme
            for those parties, much less implement one, much less so
            elaborately. ";
    }

    vocabWords = '(dabney) courtyard'
    
    up = dcStairsUp
    west = dabneyBreezeway
    east = dcDoors
    southwest = alley3main
    southeast = alley5main
    south = dabneyCourtyardAlcove

    roomParts = static (inherited - defaultGround)
;

+ EntryPortal ->(location.west) 'breezeway' 'breezeway'
    "The breezeway leads west. "
;
+ dcDoors: Door ->dlDoors
    'lounge door/doors/lounge' 'doors to the lounge'
    "Doors lead into the lounge to the east. "
    isPlural = true
    initiallyOpen = true
;
+ EntryPortal ->(location.southwest)
    'southwest sw alley 3 entrance/doorway/legend'
    'alley 3 entrance'
    "The entrance to alley 3 is to the southwest.  The doorway is
    marked with the legend <q>10-16, 18-22.</q> "
;
+ EntryPortal ->(location.southeast)
    'southeast se alley 5 entrance/doorway/legend'
    'alley 5 entrance'
    "The entrance to alley 5 is to the southeast.  The doorway is
    marked with the legend <q>23-31, 33-37.</q> "
;
+ Enterable ->(location.south) 'small alcove' 'alcove'
    "A small alcove is to the south. "
;
+ dcStairsUp: StairwayUp 'long concrete stairway stairs up' 'stairway up'
    "The stairway leads up.  It looks like two normal floor-heights
    worth of stairs. "
;

+ Floor '(courtyard) dark red brick floor/bricks' 'red brick floor'
    "The courtyard floor is paved in dark red bricks. "
;
+ Fixture '(courtyard) east west north south e w n s stucco wall/walls'
    'courtyard walls'
    "The walls are lined with windows looking out into the courtyard
    from student rooms. "
    isPlural = true
;
++ Distant 'casement window/windows' 'windows'
    "The walls are lined with windows facing the courtyard. "
    isPlural = true
    tooDistantMsg = 'The windows are all up too high to reach. '
;
+ Fixture 'covered arcaded column/columns/overhang/arch/arches/area' 'arcade'
    "The overhang provides a covered area outside the lounge. "

    dobjFor(StandOn)
    {
        verify() { }
        action() { "If you want to enter the lounge, just go east. "; }
    }
    dobjFor(LookUnder) { action() { "Doors lead into the lounge to
        the east. "; } }
;
+ Distant 'rounded gently-sloping terra cotta tile/tiles/roof/roofs' 'roof'
    "The roof is covered with rounded terra cotta tiles, which look
    rather like flower pots that were cut in half down their height. "
;

+ Fixture 'papier-mache paper-mache papier-m\u00E2ch\u00E9 scale-model model
    mountain/boulders/cliff/cliffs/edifice/peak' 'mountain'
    "It's an effective model: the cliffs near the bottom rise almost
    vertically, increasing the sense that the peak looms overhead
    at a great height, even though it only rises about the height
    of the surrounding building.  Boulders are strewn about the
    base, mixed with big metal canisters marked with radiation warnings. "

    dobjFor(Climb)
    {
        verify() { }
        action() { "It's too steep, and even if it weren't, it probably
            wouldn't support your weight. "; }
    }
    dobjFor(StandOn) asDobjFor(Climb)
    dobjFor(ClimbUp) asDobjFor(Climb)
    dobjFor(Board) asDobjFor(Climb)
    lookInDesc = "You can't see inside the mountain, and you find
        nothing hidden among the boulders. "
;
+ CustomImmovable 'big large metal radiation warning
    (symbols)/warnings/canisters/drum/drums/cylinders'
    'canisters'
    "Rusty metal cylinders, three feet long, are randomly placed among
    the boulders around the base of the mountain.  They're marked with
    the three-pronged radition warning symbol.  Many are split open and
    leaking a viscous green goo. "
    isPlural = true

    lookInDesc = "You see nothing apart from the oozing green goo. "
    cannotTakeMsg = 'You don\'t want to mess up the careful design. '
;
+ CustomImmovable 'viscous oozing gelatinous bright green goo' 'green goo'
    "It's some kind of gelatinous goo, bright green in color. "

    cannotTakeMsg = 'There\'s no good way to move it, and besides,
        you wouldn\'t want to mess up the careful design. '

    dobjFor(Eat)
    {
        preCond = []
        verify() { }
        action() { "On second thought, you probably shouldn't.
            Anywhere else, you could assume that it's nice, safe
            lime jello, but around here it's hard to be sure that
            it's not authentic radioactive waste. "; }
    }
    dobjFor(Taste) asDobjFor(Eat)
;
    

/* ------------------------------------------------------------------------ */
/*
 *   Dabney lounge 
 */
dabneyLounge: Room 'Lounge' 'the lounge'
    "This large common room is essentially the Hovse's living room.
    It must have been necessary to clear the courtyard to make room
    for the mountain, because the piles of junk normally out there seem
    to be in here.  Several couches are shoved together near the fireplace
    to make room for the heaps of stuff filling the south side of the
    room.  The courtyard is out the doors to the west, and a wide
    passage leads north into the dining room. "

    vocabWords = '(dabney) (house) (hovse) lounge'

    west = dlDoors
    north = dlPassage
    out asExit(west)
;

+ dlDoors: Door ->dcDoors 'courtyard door/doors/courtyard'
    'doors to the courtyard'
    "The doors lead out to the courtyard to the west. "
;

+ dlPassage: ThroughPassage ->ddPassage
    'wide arched dining room north n passage' 'wide passage'
    "It's an arched passage leading north into the dining room. "
;

+ Chair, Heavy 'big sturdy leather couch/couches/sofa/sofas' 'couch'
    "The couches don't match one another, but they're all big, sturdy,
    upholstered in well-worn leather. "
;

+ Fixture, Booth 'oversized stone fire/fireplace' 'fireplace'
    "The oversized stone fireplace is on the east side of the room.
    It was converted long ago to burn gas rather than wood, so it
    contains only simulated logs.  It's currently turned off. "

    up: NoTravelMessage { "The chimney isn't big enough to climb into. "; }

    dobjFor(TurnOn)
    {
        verify() { }
        action() { "It's a warm enough day; no need to make it an oven
            in here. "; }
    }
;
++ EntryPortal ->(location.up) 'chimney/soot' 'chimney'
    "It's just a dark shaft a foot in diameter. "

    dobjFor(Climb) asDobjFor(Enter)
    dobjFor(ClimbUp) asDobjFor(Enter)
    dobjFor(Board) asDobjFor(Enter)

    lookInDesc = "There's nothing but soot up there. "
;

++ Heavy 'black simulated concrete logs' 'simulated logs'
    "The logs are made out of concrete or something like it, molded
    to resemble the real thing.  They're black from long exposure to
    a gas flame. "

    isPlural = true
;

+ CustomImmovable
    'scrap old bed car auto
    junk/pile/piles/stuff/blankets/frame/frames/part/parts/wood'
    'junk'
    "Old blankets, bed frames, car parts, scrap wood; most of the stuff
    isn't even immediately identifiable. "
    isMassNoun = true

    cannotTakeMsg = 'There\'s too much junk to move around. '

    lookInDesc = "You poke around, looking for a hidden gem, but you
        find nothing interesting.  You'd imagine it's already been
        given a good going-over by people with a more generous
        trash/treasure threshold than your own. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Dining room 
 */
dabneyDining: Room 'Dining Room' 'the dining room'
    "This is the Hovse's dining room.  Several long wooden tables are
    arranged into a couple of rows, and chairs are lined up on either
    side of each table.  A wide passage leads south, to the lounge,
    and a pair of swinging doors to the east leads to the kitchen. "

    vocabWords = '(dabney) (hovse) (house) dining room'
    
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
        'You\'re getting pretty hungry.  You really should go have
        some lunch. ',
        'It\'s not as though you\'re going to drop dead from lack
        of nutrition or anything, but you are feeling a bit hungry. ',
        'You should go get some lunch while the dining room is
        still open. ',
        'You\'re feeling hungry.  You should take up Erin on her
        offer to join Aaron and her for lunch. ' ] }

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
        'The lunch crowd seems to be thinning out a bit.  People
        are probably eager to get back to their stacks. ',
        'Lunch seems to be winding down. ',
        'People seem to be finishing up with lunch. '] }

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
            "<.p>You spot Aaron and Erin at one of the tables.  Erin
            takes you into the kitchen and shows you where to buy a
            meal pass, and gives you a quick tour of the lunch options.
            The set-up hasn't changed much since you were a student,
            nor, apparently, has the quality of the food.  You load
            up a tray, go back to the dining room, and sit down with
            Aaron and Erin. ";

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
                "You spend a leisurely hour or so eating lunch
                and chatting with Aaron and Erin.  Eventually, the
                dining room starts to clear out, and Aaron mentions
                that he and Erin need to get back to their stack.
                You finish up the edible parts of your lunch and
                drop off your tray. ";
            else
                "Lunch has been winding down for a while now, and the
                dining room has started clearing out.  Aaron mentions
                that he and Erin need to get back to their stack, so
                you finish up the edible parts of your lunch and drop
                off your tray. ";

            /* mention that lunch is over now, not just for us */
            "Erin and Aaron head toward Alley Seven; you wish them luck
            on their way out. ";

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
    'wide arched lounge south s passage' 'wide passage'
    "The arched passage leads south, out to the lounge. "
;

+ ddKitchenDoors: Door 'swinging kitchen pair/door/doors' 'swinging doors'
    "The doors lead into the kitchen, to the east. "
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
            "The doors seem to be locked.  The kitchen must be
            closed right now, since it isn't a meal time. ";
            exit;
        }
    }

    dobjFor(Unlock)
    {
        verify()
        {
            if (isOpen)
                illogicalAlready('The doors are already unlocked and open. ');
            else
                illogical('The doors have no obvious locking mechanism,
                    at least not on this side. ');
        }
    }
    dobjFor(Lock)
    {
        preCond = [touchObj, objClosed]
        verify()
        {
            if (!isOpen)
                illogical('The doors have no obvious locking mechanism,
                    at least not on this side. ');
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
            "The doors seem to be locked in the open position. ";
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
        'You go back into the kitchen, hoping to find something more
        palatable to eat, but a thorough scan of the offerings turns
        up nothing better.  Disappointed, you return to the dining room. ',
        'You go back to the kitchen and take one more look, but you
        find nothing more palatable.  You return to the dining room. ',
        'There\'s really no point in visiting the kitchen again. ' ] }
;

+ Fixture, Surface
    'dark long wooden wood dining table/tables/row/rows' 'table'
    "The tables are made of a dark, varnished wood.  They've seen
    plenty of use. "

    disambigName = 'long wooden table'
;

/* our lunch - present only during the lunch hour */
++ myLunch: PresentLater, Thing
    'greasy tray/food/puck/pucks/lunch' 'tray of food'
    "Your tray has a selection of the greasy, non-descript foodstuffs
    known here as <q>pucks,</q> for their resemblance in appearance
    and flavor to the eponymous hockey accoutrement. "

    owner = me
    disambigName = 'your food'

    smellDesc = "The food is surprisingly odorless.  It must be
        relatively fresh from the can, or whatever sort of receptacle
        they get this stuff out of. "

    tasteDesc = "You test a little bit, bracing yourself something
        alarming, like mold or gangrene.  But it's mostly just dry
        and flavorless. "

    dobjFor(Eat)
    {
        preCond = [touchObj]
        verify() { }
        action() { "You choke down a little of one of the pucks. "; }
    }

    dobjFor(ThrowAt)
    {
        check()
        {
            /* FOOD FIGHT! ...or maybe not */
            if (gIobj.ofKind(Actor))
                "You fantasize for a moment about standing on the
                table, yelling FOOD FIGHT!, and joining in as the
                dining room explodes into pandemonium.  But, alas,
                Dabney is too mellow a place for that sort of thing,
                and anyway, these pucks could put out an eye. ";
            else
                "Better not throw the pucks around; they could put
                out an eye. ";
            exit;
        }
    }
;

/* aaron's lunch, erin's lunch, etc */
++ PresentLater, Decoration
    'someone else\'s aaron\'s erin\'s lunch/food/puck/pucks/tray' 'food'
    "No one else's food looks any more appetizing than yours. "

    disambigName = 'someone else\'s food'

    plKey = 'lunch'
;

+ ddChair: CustomImmovable, MultiChair
    'simple dark wood wooden (dining) (room) chair/chairs' 'chair'
    "The chairs are unpadded wood.  There are enough chairs to seat
    about seventy people. "
    
    disambigName = 'simple wood chair'

    cannotTakeMsg = 'You have no reason to carry around a dining room chair. '

    /* because we represent many objects, customize the status messages */
    actorInName = 'in one of the chairs'

    chooseChairSitMsg()
    {
        if (location.isLunchtime)
            "You sit down with Erin and Aaron. ";
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
+ PresentLater, Person 'dining other student*students' 'students'
    "The students are eating and talking. "

    specialDesc = "The room is about half full of students, sitting
        around the tables eating lunch. "
    
    disambigName = 'other students'
    isPlural = true

    plKey = 'lunch'
;
++ SimpleNoise 'conversations' 'conversations'
    "There's a continuous babble of conversation and cliking of
    silverware. "
    isPlural = true
;

/* ------------------------------------------------------------------------ */
/*
 *   Alcove off Dabney Courtyard 
 */
dabneyCourtyardAlcove: Room 'Pinball Room' 'the pinball room'
    "You don't know what this small room off the courtyard was
    originally intended for, but to you it's the pinball room,
    since there was always an old 1960s-vintage pinball machine or
    two in here.  It looks like they've finally gotten with the 80s:
    in place of a pinball machine is Positron, a classic video game.
    <.p>The courtyard is outside, to the north. "

    vocabWords = 'pinball alcove/room'

    north = dabneyCourtyard
    out asExit(north)
;

+ Enterable ->(location.out) 'courtyard' 'courtyard'
    "The courtyard is outside, to the north. "
;

+ posKey: PresentLater, Key 'small brass (positron) key' 'small brass key'
    "It's a small brass key; it's the one Scott gave you for the
    Positron game. "
;
+ posGame: Heavy, ComplexContainer
    'positron classic video game black machine/cabinet/letters'
    'Positron game'
    "You remember Positron: it's one of those classic 80s video
    games, from the generation right after the vector graphics machines.
    The game is pretty abstract; you fly a spaceship around a maze
    of 2D caves, blasting aliens and collecting power crystals.
    <.p>The machine's cabinet is about five feet tall, painted black,
    with <q>Positron</q> down the side in elaborate silver letters.  The
    display is recessed and slanted back, and under it is the console
    with its big plastic buttons.  An instruction card is affixed
    to the console.  Below the console is a coin slot
    and a service door<<doorStat>>, and around the side from the
    door is the power switch (currently <<posSwitch.onDesc>>).
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
            "<.p>This might be just the sort of thing you need to
            get back in practice for working on Brian's stack.  These
            old video games are pretty low-tech, so you shouldn't have
            too much trouble finding your way around it. ";
    }
    practiceNoteCount = 0

    /* our door status message */
    doorStat = (posInterior.isOpen ? " (currently open)" : "")

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
            "You don't need to attach the signal generator there;
            a quick probe with the scope ought to be sufficient to
            check <<thatObj>>. ";
        else
            "You'll have to open the cabinet before you can access
            any of the component wiring. ";

        /* don't allow attaching it in any case */
        detachFrom(signalGen);
    }

    probeWithScope()
    {
        /* only probe when the cabinet is open */
        if (posInterior.isOpen)
            probeWithScopeMsg;
        else
            "You'll have to open the cabinet before you can access
            any of the component wiring. ";
    }
;

++ posSwitch: PosElectricalPart, Switch, Component
    '(positron) (video) (game) power switch' 'power switch'
    disambigName = 'video game power switch'

    /* coordinate our on/off state with our parent */
    makeOn(val)
    {
        inherited(val);
        location.isOn = isOn;
    }

    turnOnOff()
    {
        /* show what happens */
        "You flip the switch";
        if (location.isWorking)
        {
            /* we're working; the display goes on or off as appropriate */
            if (isOn)
            {
                ", and a power-up test screen gradually fades in on the
                display.  After a few moments, the display switches
                to the game's <q>attract mode.</q> ";

                /* if this is the first time, mention it specially */
                if (scoreMarker.scoreCount == 0)
                {
                    "<.p>That must have done the trick!  You fiddle
                    with the internal controls to give yourself a free
                    game, and you start playing.  The aliens quickly
                    clobber you, but it looks like everything's working
                    properly.<.reveal positron-repaired> ";

                    /* score this the first time it happens */
                    scoreMarker.awardPointsOnce();

                    /* this is a clock-significant plot event */
                    repairPlotEvent.eventReached();
                }
            }
            else
                ". A brief white flash shows on the display screen,
                then the screen goes dark. ";
        }
        else
            ", but there's no obvious effect. ";
    }

    /* do some extra work on turning on or off */
    dobjFor(TurnOn) { action() { inherited(); turnOnOff(); } }
    dobjFor(TurnOff) { action() { inherited(); turnOnOff(); } }

    /* it's a reasonable thing to do, so at least acknowledge it */
    probeWithScopeMsg = "You give the switch's electrical contacts a
        cursory examination.  Everything looks fine there. "

    /* 
     *   sore the repair when we turn it on for the first time with the
     *   machine working 
     */
    scoreMarker: Achievement { +10 "repairing Positron" }

    /* a game-clock event for having fixed the game */
    repairPlotEvent: ClockEvent { eventTime = [2, 11, 41] }
;
++ CustomFixture 'instruction card/instructions' 'instruction card'
    "At the top of the card, printed in bold type:
    <table><tr><td align=center>
    <font face='tads-sans'><b>
    \b\t25&cent; Per Game - Quarters Only
    \n\tFor Amusement Only
    \n\t<i>Manufactured by ARITA GAMES</i>
    \n\t<font size=-1>&copy;1982 All Rights Reserved</font>
    \b
    </b></font>
    </table>
    Under this, handwritten:
    \b\t<i>Lost quarter? See Scott, Dabney rm 39 (Alley 7)</i>
    <.reveal find-scott> "
    cannotTakeMsg = 'The instruction card is permanently affixed to
        the console. '
;
++ posButtons: PosElectricalPart, Component
    '(positron) (video) (game) big plastic buttons/console'
    'video game console'
    "The console consists of several big plastic buttons that control
    the spaceship. "

    dobjFor(Push)
    {
        verify() { }
        action()
        {
            if (location.isWorking)
            {
                if (posInterior.isOpen)
                    "You fiddle with the internal controls to give yourself
                    a free game, then play for a few minutes to verify
                    that everything's working.  It's actually kind of a
                    fun game.  You play until you get clobbered by the
                    aliens; GAME OVER flashes on the screen for a few
                    moments, then the machine goes back to attract mode. ";
                else
                    "The game displays INSERT QUARTER on the screen for
                    a few moments, and then returns to attract mode. ";
            }
            else
                "You tap on the buttons, but nothing happens. ";
        }
    }

    /* it's not interesting to test this part, but allow it */
    probeWithScopeMsg = "You test the button wiring with the scope,
        and everything to be in order. "

;
++ RestrictedContainer, Component
    '(positron) (video) (game) coin quarter slot' 'coin slot'
    "It's a slot for quarters.  Under the slot is a coin return. "
    cannotPutInMsg(obj) { return 'The slot only accepts quarters. '; }
;
++ RestrictedContainer, Component
    '(positron) (video) (game) small coin return/recess' 'coin return'
    "It's a small recess where coins are returned when rejected
    by the coin slot. "
    cannotPutInMsg(obj) { return 'The recess is too small to hold
        anything but a coin or two. '; }

    lookInLister: thingLookInLister {
        showListEmpty(pov, parent) { defaultDescReport('You check the
            coin return, but you find no stray quarters. '); }
    }
;
++ posDisplay: PosElectricalPart, Component, Surface
    '(positron) (video) (game) display/screen' 'video game display'
    desc()
    {
        if (location.isWorking)
            "The display is showing the game's <q>attract mode,</q>
            which is just a section of the game being played in a loop. ";
        else
            "The display is currently dark. ";
    }
    iobjFor(PutOn)
    {
        action()
        {
            if (gDobj == oooSign)
            {
                "You put the sign back on the display. ";
                inherited();
            }
            else
                "The screen is too steeply slanted to hold anything. ";
        }
    }

    /* it's not interesting to test this part, but allow it */
    probeWithScopeMsg = "You check the display connections, and
        find that everything looks to be hooked up properly. "
;
+++ oooSign: Readable 'yellow out-of-order note' 'yellow note'
    "It's a yellow note reading <q>Out of Order.</q> "

    useSpecialDesc = (location == posDisplay)
    specialDesc = "A yellow note reading <q>Out of Order</q> is on the
        Positron display. "
;    
++ posDoor: ContainerDoor
    '(positron) (video) (game) service door' 'service door'
    "The service door takes up roughly the bottom half of the front of
    the machine; it provides access to the game's electronics.
    <<posInterior.isOpen ? "It's currently open, providing access
        to the service compartment inside the cabinet." : "">> "
;
++ posInterior: KeyedContainer, Component
    '(positron) (video) (game) service compartment' 'service compartment'
    
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
                "You can't close the compartment while <<obj.nameIs>> still
                attached to the circuit board. ";
                exit;
            }
        }
    }
;
+++ posCircuits: TestGearAttachable, CustomImmovable
    'video amp amps amplifiers main logic large circuit
    board/boards/circuits/circuitry'
    'circuit board'
    "These old games were built on primitive chips by today's
    standards, so rather than a few big integrated circuits, these
    boards have lots of small chips and discrete components.
    <<xtalSocket.boardDesc>> "

    cannotTakeMsg = 'The boards aren\'t easily removable. '

    /* 
     *   Show a special description in descriptions of our immediate
     *   container (the service compartment), but not as part of anything
     *   above that level.  This is too much detail until we're looking
     *   right at the compartment.  
     */
    useSpecialDescInRoom(room) { return nil; }
    useSpecialDescInContents(cont) { return cont == location; }
    specialDesc = "Several large circuit boards are inside the
        compartment. "

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
        local aThe = (townsendBook.moved ? 'the' : 'a');

        /* if the game isn't on, not much happens */
        if (!posGame.isOn)
        {
            "You probe the circuits in a few places, and find that
            all you get is a flat line, just as you'd expect with
            the game powered off. ";
            return;
        }

        /* if the machine is repaired, this is easy */
        if (posGame.isWorking)
        {
            "You make a few quick checks, and everything looks
            like it's working properly. ";
            return;
        }

        /* if the crystal socket is empty, we know what to do */
        if (xtalSocket.contents.length() == 0)
        {
            "You're pretty sure that you need to put a new crystal
            in socket X-7. ";
            return;
        }
        
        /* check how far we've traced the problem */
        switch (traceLevel)
        {
        case 0:
            /* we haven't started yet, so say how we're starting */
            "Since the game's display isn't showing anything, you
            decide to start with the video amplifiers.  It would
            be nice to have a set of schematics, but you figure
            it's actually better practice for Stamer's stack without
            them.<.p> ";

            /* advance to the video amp trace level */
            ++traceLevel;

            /* go check the video amps */
            goto checkVideoAmps;

        case 1:
            "You go back and look at the video amplifiers again. ";
            
        checkVideoAmps:
            /* check to see if we know what we're doing */
            if (gRevealed('read-video-amp-lab'))
            {
                /* we can finish with this part */
                "You carefully step through the video amp circuits,
                and after a bit you're convinced that they're okay
                and that the problem lies elsewhere.
                <.p>The next thing to check is probably the main
                logic board. ";
            
                /* move to the next trace level */
                ++traceLevel;

                /* go check the main logic board */
                goto checkCPU;
            }
            else
            {
                "You probe around a little with the scope, but it's
                been a while since you looked at a video amp in this
                much detail.  Maybe if you spent a little time reading
                about video amps in <<aThe>> lab manual, you'd have a
                better idea how to proceed.<.reveal need-video-amp-lab> ";
            }
            break;

        case 2:
            /* move on to the CPU */
            "You look again at the main logic board. ";

        checkCPU:
            if (gRevealed('read-1a80-lab'))
            {
                /* we can finish this part */
                "You check around the CPU.  After a bit of
                probing, it becomes apparent that the problem is
                on the clock signal coming into the CPU, and once
                you know that, you quickly identify a bad part, which
                is probably the source of the problem: a crystal with
                the faded marking <q>9.8304MHZ,</q> indicating
                its frequency.
                <.p>The crystal will need to be replaced with a
                working one.  Fortunately, it's not soldered into
                the board---it's in a socket for easy
                replacement.<.reveal need-pos-xtal> ";

                /* bring the bad crystal and its socket into the game */
                xtalSocket.makePresent();

                /* move to the next trace level */
                ++traceLevel;
            }
            else
            {
                "You identify the CPU as a 1A80.  You built a few
                projects with these many years ago, but you certainly
                don't remember all the little details of pin layout
                and so forth, so you'll need to look up the 1A80
                in <<aThe>> lab manual before you can test the logic
                board properly.<.reveal need-1a80-lab> ";
            }
            break;

        case 3:
            "You've traced the problem to a bad crystal---the one
            labeled <q>9.8304MHz</q>---on the main logic board.  You
            simply need to replace it.  Luckily, it's in a socket,
            not soldered in place, making it easily removable. ";
            break;
        }
    }

    /* how far have we traced the problem? */
    traceLevel = 0
;
++++ randomComponents: GenericObject, CustomImmovable
    'small small-scale discrete 1A80 cpu/crystal/crystals/chip/chips/
    components/transistors/resistors/capacitors'
    'chips'
    "The boards have lots of discrete components---transistors,
    resistors, capacitors, and small-scale chips. "

    disambigName = 'chips on the circuit boards'
    isPlural = true

    cannotTakeMsg = 'Most of the components are soldered in place. '

    /* trying to attach something here redirects to the board */
    iobjFor(AttachTo) remapTo(AttachTo, DirectObject, location)
    dobjFor(TestWith) remapTo(TestWith, location, IndirectObject)
    iobjFor(PlugInto) remapTo(PlugInto, DirectObject, location)
;
++++ xtalSocket: PresentLater, Component,
    SingleContainer, RestrictedContainer
    'crystal socket x-7/x7' 'socket X-7'
    "It's a socket for a certain type of crystal. "

    aName = 'socket X-7'

    /* mention it as part of the board description if appropriate */
    boardDesc()
    {
        /* if I'm not here, say nothing */
        if (location == nil)
            return;

        /* mention me and my contents */
        if (badXtal.isIn(self))
            "<.p>One of the components is the bad 9.8304 MHz crystal you've
            identified as the probable source of the game's problem. ";
        else
            "<.p>Among the board's components is an empty socket
            labeled X-7.  The socket is for a crystal. ";
    }

    /* don't show my contents in listings of containing objects */
    contentsListed = nil

    /* allow only the crystals */
    validContents = [badXtal, goodXtal]
    cannotPutInMsg(obj) { return 'The only thing that fits the socket
        is a certain kind of crystal. '; }

    /* turn off positron when inserting or removing parts */
    turnOffGameFirst()
    {
        if (posGame.isOn)
        {
            extraReport('You turn off the Positron game first, to
                make sure you don\'t damage any parts. ');
            posSwitch.makeOn(nil);
        }
    }
    notifyRemove(obj) { turnOffGameFirst(); }
    notifyInsert(obj, newCont) { turnOffGameFirst(); }
;
+++++ badXtal: Thing
    'blackened tiny metal 9.8304mhz 9.8304 mhz old bad crystal/(box)'
    'old 9.8304 MHz crystal'
    "It's a tiny metal box, shaped like a can of sardines but shrunk
    down to the size of a dime.  <q>9.8304MHZ</q> is stamped on it
    in faded letters.
    <<isIn(xtalSocket)
      ? "Fortunately, it's in a socket, not soldered into the board,
        making it easy to replace it." : "">> "

    disambigName = 'old 9.8304 MHz crystal'
;

/*
 *   The bag of spare parts 
 */
+++ RestrictedContainer, Consultable
    'crumpled brown paper bag/sack' 'brown paper sack'
    "It's a brown paper bag, the kind that might at some point have
    held a half gallon of milk from the grocery store. "

    cannotPutInMsg(obj) { return 'You don\'t want to get anything
        mixed up with the assorted spare parts. '; }

    lookInDesc = "The bag is full of random spare parts.  If you
        needed a particular part, you might be able to find it if
        you looked for it. "

    /* GET X FROM BAG -> SEARCH BAG FOR X */
    iobjFor(TakeFrom) remapTo(ConsultAbout, self, DirectObject)

    /* this isn't something we want to put new objects into */
    iobjFor(PutIn) { verify() { logicalRank(50, 'special bag'); } }

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
                "The bag is full of random spare parts.  If you manage
                to track down the problem with Positron to a particular
                bad part, maybe you can find a replacement here. ";
            }
            else if (goodXtal.location == nil)
            {
                /* we know we need the crystal, and we don't have it yet */
                replaceAction(ConsultAbout, self, goodXtal);
            }
            else
            {
                /* we've already found everything we need */
                "You sift through the parts a bit, but you don't see
                anything you need at the moment. ";
            }
        }
    }
;
++++ GenericObject, CustomImmovable
    '(random) (positron) spare part/parts/crystal/crystals/chip/chips/
    components/transistors/resistors/capacitors'
    'spare parts'
    "The bag is full of random spare parts for the Positron
    game---chips, transistors, capacitors, crystals, and so on. "

    isPlural = true

    cannotTakeMsg = 'There are a lot of parts here, so it\'s better
        to keep them together in the bag.  If you needed a particular
        part, you might be able to find it if you looked for it. '

    /* show a special description in our immediate container only */
    useSpecialDescInRoom(room) { return nil; }
    useSpecialDescInContents(cont) { return cont == location; }
    specialDesc = "The bag is full of random spare parts for
        the Positron machine. "

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
        "You sift through the parts for a few moments, coming
        across a brand new-looking 9.8304 MHz crystal<<
          goodXtal.isIn(me) ? ", which you take" : "" >>. ";

        /* make the crystal 'it' */
        gActor.setIt(goodXtal);
    }

    /* this is only active until we find the crystal */
    isActive = (goodXtal.location == nil)
;
++++ ConsultTopic @randomComponents
    "The bag is full of random parts.  You might be able to find
    a specific part if you look for exactly the part you need. "
;
++++ DefaultConsultTopic
    "There are a lot of parts, but you don't come across the one
    you're looking for. "
;
++++ goodXtal: PresentLater, Thing
    'brand new new-looking tiny metal 9.8304mhz 9.8304 mhz good
    replacement crystal/(box)'
    'new 9.8304 MHz crystal'
    "It's a tiny metal box, about the size of a dime, stamped
    with <q>9.8304MHZ.</q>  It looks shiny and new. "

    disambigName = 'new 9.8304 MHz crystal'

    /* make it known so that we can look it up */
    isKnown = true
;

/* ------------------------------------------------------------------------ */
/*
 *   Alley 3 - entrance 
 */
alley3main: AlleyRoom 'Alley Three Entry' 'the Alley Three entry'
    "This is the middle of Alley Three, which runs east and
    west from here.  The exit to the courtyard is to the north,
    and next to it a stairway leads up.  The door to room 13 is
    to the south. "

    vocabWords = '3 alley three entry/hallway/hall'

    north = dabneyCourtyard
    out asExit(north)
    northeast asExit(north)
    up = a3StairsUp
    east = alley3E
    west = alley3W
    south = room13door

    roomParts = static (inherited + [alleySouthWall, alleyNorthWall])
;

+ ExitPortal ->(location.out) 'courtyard/exit' 'courtyard'
    "The courtyard lies to the north. "

    dobjFor(Enter) asDobjFor(TravelVia)
;

+ room13door: AlleyDoor '13 -' 'door to room 13'
    "The wooden door is labeled <q>13.</q> "
;

+ Graffiti 'small abstract designs' 'graffiti'
    "There a couple of small abstract designs apparently saved
    in the last repainting, and not much else. "
;

+ a3StairsUp: StairwayUp 'stairs/stair/stairway' 'stairway'
    "The stairs lead up to Alley Four. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Alley 3 east
 */
alley3E: AlleyRoom 'Alley Three East' 'the east end of Alley Three'
    "The hallway ends here, continuing west.  It's partially
    blocked by an elaborately decorated, refrigerator-sized cardboard
    box outside the door to room 12, on the south side of the hall.
    The door to room 10 is across the hall on the north side, and room
    11 is at the end of the hall. "

    vocabWords = '3 alley three'

    west = alley3main
    north = room10door
    east = room11door
    south = room12door

    atmosphereList: ShuffledEventList { [
        'A couple of the chickens depart down the hall, probably
        leaving on a mission. ',
        'The chickens mill about, flapping their wings. ',
        'A couple of chickens arrive from the down the hall. ',
        'The chickens flap their wings excitedly. ']
        
        eventPercent = 66
    }
;

+ Graffiti '-' 'graffiti'
    "Unlike most of the rest of the house, there's no graffiti here. "
;

+ room10door: AlleyDoor '10 -' 'door to room 10'
    "The door is labeled <q>10.</q> "
;

+ room11door: AlleyDoor '11 -' 'door to room 11'
    "The wooden door is labeled <q>11.</q> "
;

+ room12door: StackDoor '12 -' 'door to room 12'
    "The door is labeled <q>12.</q> "
;
++ chickenNotebook: CustomImmovable, Readable
    'gray notebook/string' 'notebook'
    "The notebook is hanging from a string.  Fancy calligraphic
    letters adorn the cover: <q><i>The Laboratory Notebook and
    Philosophical Manifesto of Dr.\ Klaus W.D. von Gefl&uuml;gel,
    Super-Genius</i>.</q> "
    
    readDesc = "The notebook is filled with the same sort of flowery
        cursive as the cover.
        <.p><i>
        &ldquo;The Laboratory Notebook and Philosophical Manifesto
        of Dr.\ Klaus W.D. von Gefl&uuml;gel, Super-Genius
        <.p>&ldquo;I, Klaus von Gefl&uuml;gel, now commit to ink
        and parchment my Greatest Findings, truly an Historic
        Achievement.  Since the time of my earliest Childhood
        memories, it has Been my Dream and Sacred Quest to create
        what I have now created.  You, the reader, an
        Ordinary Man, cannot Possibly know or appreciate the great
        Tribulation of my quest.  You cannot know What it is to be
        called Mad, to be laughed at by Rivals when Your early
        experiments &lsquo;fail.&rsquo;  But those Rivals will soon
        see that they are Mere Fools, for they did not Know that
        my past experiments Were no failures, only Gradual and
        Deliberate Steps on a Great Journey that is now, Finally,
        reaching its Inevitable conclusion and Fruition.
        <.p>&ldquo;For I have created that which all Philosophers have
        dreamt of since the Earliest days of Science.  I have created
        the Means to produce a creature vastly Superior to any that
        have walked this Earth heretofore: a Creature that combines
        the Stature and Great Size of Man, with the Intelligence
        and Graceful Elegance of the Chicken...\ a race of giant
        Super-Chickens.  With this Discovery, I will create An army
        of unstoppable Super-Chickens, and together we will Rule the
        Earth, and Under my Benevolent Dominion, we will create a
        True paradise for Man and Chicken alike.&rdquo;
        </i>
        <.p>It goes on like this, laying out the rules of the stack.
        It seems that stack participants have to <q>become</q> giant
        chickens using the Chickenator, and then carry out a number
        of missions as part of the Super-Chicken Army---basically a
        series of stunts around campus.  The key rule is that,
        once turned into a chicken, a participant can only talk to
        non-chickens with clucking noises. "

    disambigName = 'gray notebook'
    specialDesc = "A gray notebook is hanging on a string on the
        door to room 12. "
    cannotTakeMsg = 'The notebook is tethered to the door, presumably
        to prevent anyone from walking off with it. '

    dobjFor(Open) asDobjFor(Read)
    dobjFor(LookIn) asDobjFor(Read)
;

+ chickenator: Immovable, EntryPortal -> insideChickenator
    'colored large decorated cardboard narrow
    box/booth/chickenator/light/lights/opening'
    'cardboard box'
    "The box must have originally contained a refrigerator or a large
    piece of furniture: it's over six feet tall and almost as wide
    and deep.  It's been painted and decorated with colored lights
    to look like something out of an old science fiction movie, and
    on the front is written <q>Chickenator Mark III.</q>  On one side
    is a narrow opening, just large enough for a person to enter. "

    disambigName = 'decorated cardboard box'

    dobjFor(Board) asDobjFor(Enter)
;

+ superChickens: DisambigDeferrer, Person
    'giant chicken suit/suits/costumes/chickens/super-chickens'
    'giant chickens'
    "They're really people wearing chicken suits, but the costumes are
    pretty good. "

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
            "<q>Cluck! Cluck! Cluck!</q> The chickens flap their wings
            in agitation and point at the notebook on the door. ";
    }
;

++ ChickenActorState
    isInitState = true
    specialDesc = "Several giant chickens are standing around
        the hall, talking quietly among themselves. "
;
+++ AskTellShowTopic, StopEventList
    [stackTopic, chickenSuit, chickenator, chickenNotebook, superChickens]
    ['<q>So how does this stack work?</q> you ask through the suit.
    <.p><q>We are the super-chicken army!</q> one of the chickens
    says. <q>We are on a mission from Dr.\ von Gefl&uuml;gel!</q> ',

     '<q>How many super-chickens are there?</q> you ask.
     <.p><q>There were about eight poultriform matrixizers when we
     started,</q> one of the chickens says. ',

     '<q>How\'s the stack coming?</q> you ask.
     <.p>The chickens confer. <q>The super-chicken army is making
     excellent progress!</q> one of them says. ']
;
    
+++ AskTellTopic [scottTopic, posGame]
    topicResponse()
    {
        "<q>Has anyone seen Scott around?</q> you ask, your voice
        muffled through the suit.
        <.p>One of the chickens, a colorful red one, waves. <q>I'm
        Scott,</q> he says. ";

        /* bring scott into play, and drop his Unthing */
        scott.makePresent();
        unScott.moveInto(nil);
    }
;
+++ AskForTopic @scottTopic
    topicResponse() { replaceAction(AskAbout, gDobj, scottTopic); }
;
++++ AltTopic
    "<q>Have you guys seen Scott around?</q> Your voice is muffled
    through the chicken suit.
    <.p>The chickens look around, tilting their heads to see out
    through the suits.  <q>I think he's out on one of the missions,</q>
    one of them says. <q>He'll be back later.</q> "
    
    /* we gate scott's appearance on starting with stamer's stack */
    isActive = (labKey.isIn(erin))
;
++++ AltTopic
    "<q>Is Scott here?</q> you ask.
    <.p>One of the chickens, a colorful red one, waves.  <q>Right
    here,</q> he says. "

    /* this one fires when scott is already here */
    isActive = (scott.isIn(alley3E))
;
    
+++ DefaultAnyTopic, ShuffledEventList
    ['A chicken arrives just as you start to talk, sending the
    flock into a minor commotion. ',
     'The chickens just cluck. ',
     'The chickens just flap their wings. ',
     '<q>The super-chicken army is very busy!</q> one of the
     chickens says. ']
;

/* an unthing for scott, until he's here */
+ unScott: Unthing 'scott' 'Scott'
    isProperName = true
    isHim = true
    notHereMsg = 'One of the chickens might be Scott, but you don\'t
        know which one. '
;

/* the owner of the positron game */
+ scott: DisambigDeferrer, PresentLater, Person
    'colorful red giant chicken suit/scott' 'Scott'
    "He's wearing an especially colorful chicken suit, mostly red. "

    /* 
     *   he's just one of the crowd of chickens, so don't mention him
     *   separately 
     */
    specialDesc = ""
    isProperName = true
    isHim = true

    noResponseFromMsg(actor) { return 'Scott just clucks and flaps
        his wings. '; }

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
    "<q>Are you the owner of the Positron machine?</q> you ask.
    <.p><q>Yeah,</q> he says.
    <.convnode repair-positron> "
;
+++ AltTopic
    "<q>Do you have any more details about what's wrong with
    Positron?</q> you ask.
    <.p><q>Not really,</q> he says. <q>It's just completely dead.</q> "

    /* this topic is active after we've obtained the key */
    isActive = (posKey.moved)
;
+++ AltTopic, StopEventList
    ['<q>I just wanted to let you know I managed to repair Positron,</q>
    you say.
    <.p><q>That\'s great!</q> Scott says. <q>Thanks!</q> ',
     '<q>Did I mention I fixed Positron?</q> you ask.
     <.p><q>Yeah, thanks again,</q> Scott says. ']
    
    isActive = gRevealed('positron-repaired')
;
++ DefaultAnyTopic, ShuffledEventList
    ['<q>I\'m kind of busy with the stack,</q> Scott says. ',
     'Scott just clucks. ',
     'He seems busy with the stack. ']
;
++ ConvNode 'repair-positron';
+++ SpecialTopic 'ask what\'s wrong with it'
    ['ask','scott','him','what','is','what\'s','wrong','with','it',
     'the','positron','machine']
    "<q>Do you know what\'s wrong with it?</q> you ask.
    <.p>He scratches his head with his wing. <q>Not really. I've been
    trying to get someone to take a look at it.</q>
    <.convstay><.topics> "

    /* only offer this question at this node one time */
    isActive = (talkCount == 0)
;
+++ SpecialTopic 'offer to repair it'
    ['offer','to','repair','it','the','positron','machine']
    topicResponse()
    {
        "<q>I know a bit about electronics,</q> you say. <q>I'd be
        happy to try fixing it.</q>
        <.p><q>Have you repaired anything like this before?</q>
        <.convnode ask-experience> ";
    }
;
++ ConvNode 'ask-experience'
    commonReply = "<.p><q>So why are you so interested in fixing an
        old video game?</q> he asks, skepticism in his voice.  <q>I
        usually have to harangue my double-E friends for weeks to
        get anyone to help.</q>
        <.convnode why-repair> "
;
+++ YesTopic
    "<q>Sure,</q> you say. <q>It's been a while, but I've done lots
    of work on computers and video displays before.</q>
    <<location.commonReply>> "
;
+++ NoTopic
    "<q>Not anything exactly like it,</q> you admit.  <q>But I've
    done lots of work on computers and video displays, which are
    basically the same thing.</q>
    <<location.commonReply>> "
;
++ ConvNode 'why-repair'
    commonReply = "<q>I'm working on Brian Stamer's stack,</q> you say.
        <q>It's some kind of electronics debugging puzzle, and I really
        need some practice on something simpler before I tackle it.</q>
        <.p><q>Practice?</q>  He sounds a little annoyed. <q>You want
        to practice on my video game?  I mean, I appreciate the offer
        and all, but how do I know you're not going to make it worse?</q>
        <.convnode why-not-worse> "
;
+++ SpecialTopic 'explain about Stamer\'s stack'
    ['explain','about','brian','stamer\'s','the','stack']
    "<<location.commonReply>> "
;
+++ SpecialTopic 'say you need the practice'
    ['say','i','you','need','the','some','practice']
    "<<location.commonReply>> "
;
++ ConvNode 'why-not-worse'
    commonReply()
    {
        "<.p>He pauses for a long time.  <q>Okay,</q> he says,
        <q>sounds fair.</q> He searches around in his chicken suit
        for a while, then fishes out a key and hands it to you.
        <q>Here's the key to the machine.</q>
        <.p>You take the key, which is difficult with the suit on, ";

        if (myKeyring.isIn(me))
        {
            "and fumble through the suit to find your own keyring,
            which is even more difficult.  After a few tries you
            manage to put the key on your keyring and put the
            keyring in your pocket. ";

            posKey.moveInto(myKeyring);
            myKeyring.moveInto(myPocket);
        }
        else
        {
            "and fumble through the suit to find your pocket,
            which is even more difficult.  You finally manage to
            pocket the key. ";

            posKey.moveInto(myPocket);
        }

        /* aware some points */
        scoreMarker.awardPointsOnce();

        "<.p><q>Thanks!</q> you say.  <q>I'll let you know if
        I can fix it.</q> ";
    }

    scoreMarker: Achievement { +5 "getting the Positron key" }
;
+++ SpecialTopic 'promise not to break it'
    ['promise','not','to','break','it','the','positron','machine']
    "<q>I promise I won't make it any worse,</q> you say. <q>I'll just
    take a look to see if I can figure out what's wrong, and if I'm
    not sure I can fix it, I won't try.</q><<location.commonReply>> "
;
+++ SpecialTopic 'say you\'ll pay for repairs if you break it'
    ['say','you','will','you\'ll','i','will','i\'ll','offer','to',
     'pay','for','repairs',
     'if','you','i','break','it','the','positron','machine']
    "<q>If I make it worse, I'll pay to get it repaired,</q> you offer.
    <<location.commonReply>> "
;

/* ------------------------------------------------------------------------ */
/*
 *   Inside the chickenator.  We could have made this a nested room, but
 *   there's no real relationship to the enclosing alley 3 area other than
 *   the in/out connection, so for simplicity it's just a separate room. 
 */
insideChickenator: Room 'Chickenator' 'the Chickenator' 'Chickenator'
    "The box is as decorated inside as it is outside.  An instruction
    sign is posted above a huge knife switch, and colored lights all
    along the walls and ceiling twinkle.  Several coat hooks are arranged
    along one wall, near the ceiling.  A narrow opening in the side of
    the box leads back out. "
    
    vocabName_ = 'cardboard chickenator/box'

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

+ Decoration 'christmas-tree colored light/lights' 'colored lights'
    "They're probably Christmas-tree lights. "
;

+ ExitPortal
    'narrow 3 alley opening/exit/three/alleyway/hall/hallway' 'opening'
    "The opening leads back outside to the alleyway. "
;

+ Fixture, Surface 'coat hook/hooks' 'coat hooks'
    "Several coat hooks are arranged along the wall near the ceiling. "
    isPlural = true

    /* only allow the chicken suit to hang here */
    iobjFor(PutOn)
    {
        verify()
        {
            if (gDobj != nil && gDobj != chickenSuit)
                illogical('The hooks are only for chicken suits. ');
        }
    }

    /* HANG obj ON HOOK -> PUT obj ON HOOK */
    iobjFor(HangOn) remapTo(PutOn, DirectObject, self)

    /* customize some default messages */
    alreadyPutOnMsg = '{The dobj/he} {is} already on a hook. '

    /* 
     *   customize the way we describe our contents, so that we describe
     *   things as hanging on the hooks rather than being in the hooks 
     */
    contentsLister: HookContentsLister, surfaceContentsLister { }
    descContentsLister: HookContentsLister, surfaceDescContentsLister { }
    lookInLister: HookContentsLister, surfaceLookInLister {
        showListEmpty(pov, parent)
            { "Nothing is currently hanging from the hooks. "; }
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
            " is hanging from one of the hooks. ";
        else
            " are hanging from hooks. ";
    }
;

++ chickenSuit: Wearable
    'white chicken poultriform suit/feathers/matrixizer' 'chicken suit'
    "It's a full-body chicken suit, big enough for you to put on.
    The feathers are mostly white. "

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
                "It's too hard to grasp anything with the chicken
                suit on. ";
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
                "It's too hard to see where you're going in the
                chicken suit.  If you were to leave the alley, you
                might not be able to find your way back. ";
                exit;
            }
            else
                "It's really hard to see where you're going with the
                chicken suit on; you have to go slowly and feel your
                way along the wall.<.p>";
        }
    }
    
    dobjFor(Wear)
    {
        preCond = (inherited() + handsEmptyForSuit)
        check()
        {
            if (!isIn(insideChickenator))
            {
                "You really should play along with the stack and
                use the Chickenator to make the transformation. ";
                exit;
            }
        }
    }
    okayWearMsg = 'It takes a bit of doing, especially in this
        cramped space, but you manage to wrestle your way into
        the suit.  It covers you head to toe, and it\'s not very
        easy to see out of it. '

    /* a customized hands-empty condition for wearing the suit */
    handsEmptyForSuit: handsEmpty {
        failureMsg = 'The suit is so big and bulky that you\'ll have to
            put everything down before you can put it on. '

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
                "You really should play along with the stack and use
                the Chickenator to transform back into a human. ";
                exit;
            }
        }
    }
    okayDoffMsg = 'You clumsily extract yourself from the suit.  It\'s
        a relief to get out of it. '

    /* this is a bit too large to stuff in the tote */
    dobjFor(PutIn)
    {
        check()
        {
            if (gIobj == toteBag.subContainer)
            {
                "The tote is capacious, but the chicken suit is just
                too large. ";
                exit;
            }
        }
    }
;

+ Fixture, Readable 'instruction sign/instructions' 'instruction sign'
    "<font face=tads-sans><b>Chickenator Mark III Operating Instructions</b>
    <br><br><b>Chickenation:</b> Select poultriform matrixizer from shelf.
    Wear.  Pull switch lever.  Chickenation process is automatic.
    <br><br><b>De-Chickenation:</b> Pull switch lever.  Dechickenation
    process is automatic.  When done, subject will be coated with vestige
    of poultriform matrixizer.  Remove matrixizer and return to
    hook.</font> "
;

+ SpringLever, Fixture
    'huge electrical knife switch hinged bare metal
    (pair)/lever/handle/blade/blades'
    'knife switch'
    "It's the standard Mad Scientist type of electrical switch: a hinged
    pair of bare metal blades with a foot-long handle.  It's in the down
    position. "

    dobjFor(Pull)
    {
        action()
        {
            "You grasp the handle and pull the blades up.  The sound
            of electric sparks comes from a hidden speaker, and the
            lights in the booth dim.  As soon as you release the handle,
            it springs back down and the special effects end. ";

            if (!seenBefore)
            {
                "<.p>Not surprisingly, it appears that you haven't
                actually been transformed into a chicken. ";
                seenBefore = true;
            }
        }
    }
    seenBefore = nil

    dobjFor(Push) asDobjFor(Pull)
    dobjFor(Raise) asDobjFor(Pull)
    dobjFor(Lower) { verify() { illogicalAlready('It\'s already in the
        down position. '); } }
;

/* ------------------------------------------------------------------------ */
/*
 *   Alley 3 west
 */
alley3W: AlleyRoom 'Alley Three West' 'the west end of Alley Three'
    "This is the west end of Alley Three; the hallway continues
    to the east.  The door to room 14 is on the south side, 15
    at the west end, and 16 on the north side of the hall. "

    vocabWords = '3 alley three'

    east = alley3main
    north = room16door
    west = room15door
    south = room14door
;

+ room14door: AlleyDoor '14 -' 'door to room 14'
    "The door is labeled <q>14.</q> "
;

+ room15door: AlleyDoor '15 -' 'door to room 15'
    "The wooden door is labeled <q>15.</q> "
;

+ room16door: AlleyDoor '16 -' 'door to room 16'
    "The door is labeled <q>16.</q> "
;

+ Graffiti 'odd comments' 'graffiti'
    "There's not much here; just a couple of odd comments
    scribbled on the wall in small letters: <q>He is a fun God! He
    is the Sun God!  Ra! Ra! Ra!</q> And: <q>Subtlety is a crutch.</q> "
;


/* ------------------------------------------------------------------------ */
/*
 *   Alley 4 center
 */
alley4main: AlleyRoom 'Alley Four' 'Alley Four'
    "This is the middle of Alley Four, where the hallway widens into
    a good-sized lounge area.  The two wings of the alley lead off
    to the east and west, respectively, and to the north, a stairway
    leads down.  A large round table and some chairs are set up here. "

    vocabWords = '4 alley four'

    down = a4StairsDown
    north asExit(down)
    west = alley4W
    east = alley4E

    roomParts = static (inherited + [alleyNorthWall, alleySouthWall,
                                     alleyEastWall, alleyWestWall])
;

+ Graffiti 'twisty leafy gecko/geckos/mural/vine/vines' 'graffiti'
    "A mural of twisty, leafy vines covers one wall.  Among the
    vines are a number of well-hidden geckos. "
;

+ a4StairsDown: StairwayDown -> a3StairsUp
    'stairs/stairs/stairway' 'stairway'
    "The stairs lead down to Alley Three. "
;

+ EntryPortal ->(location.west)
    'west w (4) (four) narrow hall/hallway/wing/(alley)' 'west wing'
    "The narrow hallway leads west. "
;
+ EntryPortal ->(location.east)
    'east e (4) (four) narrow hall/hallway/wing/(alley)' 'east wing'
    "The narrow hallway leads east. "
;

+ a4mChair: CustomImmovable, MultiChair
    'occupied empty simple oak kitchen chair/chairs' 'oak chair'
    "There are several of the simple oak kitchen chairs.  Most of
    them are occupied; a few are empty. "

    cannotTakeMsg = 'You have no need to carry around any of the chairs. '

    /* because we represent many objects, customize the status messages */
    actorInName = 'on one of the oak chairs'
;

+ a4Table: Heavy, Surface
    'large kitchen round oak wood wooden table' 'round table'
    "It's the kind of table you'd find in a kitchen.  It's round
    and looks to be made of oak. "

    iobjFor(PutOn)
    {
        action() { "You're afraid you'd mess up the careful organization
            of papers on the table if you added anything. "; }
    }
;

/* a class for the immovable items on the table, with a custom message */
class A4TableImmovable: CustomImmovable
    cannotTakeMsg = 'Everything\'s carefully laid out; you don\'t want
        to disturb it. '
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
            "The action figure is important to the stack; you don't
            want to interfere. ";
            exit;
        }

        /* otherwise, do the normal stuff */
        inherited(obj);
    }
;
    
++ a4Materials: A4TableImmovable
    'pile/papers/paper/materials' 'pile of papers'
    "The table is piled with papers.  A large blueprint map of
    the campus is in the center of the table, and all around it
    are envelopes and index cards.  The envelopes and cards seem
    carefully arranged. "

    /* 
     *   use a specialDesc in our container's description only (not in the
     *   room description, since we mention the materials as part of the
     *   students' specialDesc instead)
     */
    specialDesc = "A pile of papers is spread out on the table. "
    useSpecialDescInRoom(room) { return nil; }
;

++ a4Envelopes: A4TableImmovable, Readable
    'index envelope/envelopes/card/cards/handwriting'
    'envelopes and cards'
    "Some of the envelopes have been opened, others are sealed.
    Most of the index cards are covered with handwriting. "

    isPlural = true

    readDesc = "You scan a few of the index cards, but none of
       them are very meaningful to you. "

    dobjFor(Open)
    {
        verify() { }
        action() { "You don't want to disturb anything. "; }
    }
    dobjFor(Close) asDobjFor(Open)
    dobjFor(LookIn) asDobjFor(Open)
    dobjFor(Search) asDobjFor(Open)
;

++ A4TableImmovable
    'large campus blueprint
    map/outline/outlines/(building)/(buildings)/(campus)'
    'blueprint map'
    "The map shows the outlines of the campus's buildings, printed
    in light blue ink on a poster-sized piece of paper.  It looks
    almost like a battle-planning map: it's marked up with numerous
    lines, squiggles, circles, and other annotations, and little
    tokens are scattered around the map. "

    dobjFor(ConsultAbout)
    {
        verify() { logicalRank(50, 'decoration only'); }
        action() { "It's too crowded in here, and the table is too
            cluttered, to get a good look at the map. "; }
    }
;
+++ a4Map: Fixture
    'map other mark/marks/marking/markings/line/lines/arrow/
    arrows/squiggle/squiggles/circle/circles/annotation/annotations'
    'map annotations'
    "It's not obvious what the markings mean.  Some of the buildings
    are circled, others are crossed out; in other places, lines or
    arrows are drawn between buildings. "

    isPlural = true
;
+++ A4TableImmovable
    'map little plastic token/tokens/pawn/pawns' 'map tokens'
    "The tokens are mostly little plastic pawns, probably from a board
    game.  They're placed around the map to mark certain locations,
    although it's not obvious what they indicate. "

    isPlural = true
;

+ Person 'student/students' 'students'
    "Some are sitting at the table, others are standing near it.
    They're all working on the materials spread out on the table. "

    specialDesc = "About a half dozen students<<
          jay.isIn(alley4main) ? ", including Jay, " : ""
          >> are sitting or standing around the table, working on
        a pile of papers spread out over the surface. "

    isPlural = true
;

++ AskTellShowTopic
    [stackTopic, a4Materials, a4Envelopes, a4Map, turboTopic]
    "<q>Which stack are you guys working on?</q> you ask.
    <.p>One of them points down the hall to the west. <q>The
    Turbo Power Animals stack.  You should read the sign down
    the hall if you want to help out.</q> "
;

+++ AltTopic, StopEventList
    ['<q>Are you guys working on the Turbo Power Animals stack?</q>
    you ask.
    <.p>One of them turns around and makes an elaborate series of
    jerky arm gestures, first crossing his arms, then holding one arm
    straight up and the other one sideways, then making a pulling-down
    motion with both fists, and on and on.  <q>The turbo power Caltech
    adjunct is ready!</q> he says.  The others smile and shake
    their heads at the display.  He finally finishes the salute and
    returns to the table. ',

     '<q>How does this stack work?</q> you ask.
     <.p>One of the students looks up from the papers. <q>We have
     these clues,</q> he says, indicating the envelopes, <q>hinting
     where the five Power Animals are hidden.  The clues are all
     pretty obscure, so we\'re trying to piece things together.</q> ',

     '<q>How\'s the stack coming?</q>
     <.p>A couple of the students just look up at you and shrug. ']

    isActive = gRevealed('tpa-stack')
;

++ AskTellTopic @jayTopic
    topicResponse()
    {
        "<q>Excuse me,</q> you say, <q>but I'm looking for Jay
        Santoshnimoorthy.</q>
        <.p>Everyone looks at one of the students, who looks up
        at you. <q>I'm Jay,</q> he says.
        <.p>With the aloha shirt, his build, and his long hair,
        Jay looks like a surfer dude. ";

        /* bring Jay into the game, and drop his Unthing */
        jay.makePresent();
        unJay.moveInto(nil);

        /* transition jay directly to conversation */
        jay.autoEnterConv();
    }
;
+++ AltTopic
    "<q>Has anyone seen Jay Santoshnimoorthy around?</q> you ask.
    <.p>One of the students looks up. <q>He went over to Bridge,
    I think, following one of the clues,</q> she says. <q>He should
    be back in a little while.</q> "

    /* jay won't show up until we at least start on stamer's stack */
    isActive = (labKey.isIn(erin))
;
+++ AltTopic
    "<q>Is Jay still here?</q> you ask.
    <.p>Jay leans back from the table. <q>Right here,</q> he says.
    <<jay.autoEnterConv>> "

    /* use this one when jay is already here */
    isActive = (jay.isIn(alley4main))
;
+++ AltTopic
    "<q>Is Jay still here?</q> you ask.
    <.p>One of the students points to him.  He's still sitting there
    reading the journal you gave him. "
    
    isActive = (jay.curState == jayReading)
;

++ AskTellTopic [scottTopic, posGame]
    "<q>Has anyone seen Scott around?</q> you ask.
    <.p>One of the students answers without looking up from
    the table. <q>I saw him down in Alley Three,</q> she says. "
;
++ AskForTopic @scottTopic
    topicResponse() { replaceAction(AskAbout, gDobj, scottTopic); }
;

++ DefaultAnyTopic, ShuffledEventList
    ['You try to get someone\'s attention, but they\'re all too
    involved in other conversations. ',
     'Everyone seems too focused on the stack to respond. ',
     'They\'re probably mostly interested in the stack right now. ']
;

/* ------------------------------------------------------------------------ */
/*
 *   Alley 4 west
 */
alley4W: AlleyRoom 'Alley Four West' 'the west end of Alley Four'
    "The narrow hallway leads off to the east and ends here.
    The door to room 20 is to the south, 21 to the north, and
    22 to the west. "

    vocabWords = '4 alley four'

    south = room20door
    north = room21door
    west = room22door
    east = alley4main

    roomParts = static (inherited + [alleyNorthWall, alleySouthWall,
                                     alleyWestWall])
;

+ room20door: AlleyDoor '20 -' 'door to room 20'
    "The door is labeled <q>20.</q> "
;

+ room21door: AlleyDoor '21 -' 'door to room 21'
    "The number 21 is painted on the door. "
;

+ room22door: StackDoor '22 -' 'door to room 22'
    "The wooden door is numbered <q>22.</q> "
;

++ Fixture
    'colorful illustrated turbo power
    sign/drawing/drawings/animal/animals/illustration/illustrations'
    'illustrated sign'
    "The large sign is illustrated with colorful drawings of
    characters from the Turbo Power Animals, the popular Japanese
    cartoon/video game series/action figure collection/media empire.
    Large, bold, action-packed lettering flows around the
    illustrations:
    <.p>
    <.blockquote>
    <font face='tads-sans'><b><i>
    <center>Invoking Turbo Power Animals!</center>
    <.p>Dispatch Alert! The nefarious GENERAL XI has kidnapped
    the five Power Friends in a plot to cause environmental
    catastrophe!
    <.p>Knowing only the Power Animals can stop his
    evil plan to pollute the PASADENA SEA with the deadly
    INDUSTRIA VIRUS, the nefarious General has lured the
    Turbo Friends to CALTECH under the guise of a Do Gooders
    Convention.  Unwary of the danger, the Power Friends went to
    their good-doing seminars, only to find the wicked General's
    dim-witted but brawny FROGFISH ARMY waiting.  The Turbo Animals
    fought bravely using the latest fighting moves, such as
    two-arm cross-over flip and right-elbow joint snap, but
    the Frogfish were too many in number, and prevented the
    Power Friends from forming TURBO POWER COMBINE GIANT ANIMAL!
    <.p>The Turbo Power Animals need YOUR help!  With the help of
    your friends, you must form the CALTECH TURBO ADJUNCT.  You
    must find where General Xi is holding each of the five Turbo
    Power Animals, and rescue each one.  Only when all five are
    rescued can they form TURBO POWER COMBINE GIANT ANIMAL, and,
    with your help, confront General Xi in battle to defeat his
    evil plot!
    <.p>But it won't be easy! General Xi is very crafty, and he
    has left only the clues in the envelopes below.  Furthermore,
    he has protected many of the clues with time locks, so they
    can be opened only at the designated hour.
    </i></b></font>
    <./blockquote>
    The sign goes on with some additional rules for the stack;
    it looks like a scavenger-hunt type of stack. <<extraComment>>
    <.reveal tpa-stack> "

    specialDesc = "A colorful, illustrated sign is posted on the
        door to room 22. "

    extraComment()
    {
        if (commentCount++ == 0)
            "You don't see the envelopes the sign mentions;
            presumably that's what's on the table down the hall. ";
    }
    commentCount = 0
;

+ Graffiti
    'lovecraftian dripping horror/monster/tentacles/eyes/eye/teeth/ectoplasm'
    'graffiti'
    "A drawing of a rather Lovecraftian monster dominates one wall:
    tentacles, eyes by the dozen, teeth dripping with ectoplasm. "
;


/* ------------------------------------------------------------------------ */
/*
 *   Alley 4 east
 */
alley4E: AlleyRoom 'Alley Four East' 'the east end of Alley Four'
    "This is a narrow section of hallway, continuing west and
    ending here to the east.  A door numbered 18 is to the south,
    and the door to room 19 is to the north.  To the northeast, a
    door that looks like an ordinary room door leads into the
    house library. "

    vocabWords = '4 alley four'

    north = room19door
    south = room18door
    northeast = a4LibDoor
    west = alley4main

    roomParts = static (inherited + [alleyNorthWall, alleySouthWall,
                                     alleyEastWall])
;

+ room18door: AlleyDoor '18 -' 'door to room 18'
    "The door is labeled <q>18.</q> "
;

+ room19door: AlleyDoor '19 -' 'door to room 19'
    "The number 19 is painted on the door. "
;

+ Graffiti 'long involved math tiny small story/letters' 'graffiti'
    "A long, involved story is written on the wall in tiny letters.
    It's some kind of extended math joke. "
;

+ a4LibDoor: Door 'library door' 'library door'
    "It looks like the door to any student room in the house, but
    <q>Library</q> is painted on the door in place of a room number. "

    isOpen = true
;

/* ------------------------------------------------------------------------ */
/*
 *   The Dabney library 
 */
dabneyLib: Room 'Library' 'the house library' 'house library'
    "This room was probably once a regular double, but it was converted
    a long time ago into the house library.  It's a bit of a mess;
    books are piled randomly not only on the shelves lining the walls,
    but also on the floor, the large table, and the pair of couches.
    <.p>A large casement window to the north overlooks the
    courtyard.  The room has two doors leading out, one to the
    southeast and one to the southwest. "

    vocabWords = 'dabney house library'

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
            { "Which way do you want to go, southeast or southwest? "; }
        askMissingObject(targetActor, action, which)
            { "Which way do you want to go, southeast or southwest? "; }
    }
;

+ Graffiti 'graffiti/drawing/drawings/quote/quotes/remark' 'graffiti'
    "There are lots of little drawings and quotes on the walls.
    Your favorite is a little remark near the northeast
    door: <q>The Library: Where <b>ANYTHING</b> can happen.
    <font size=-1>(But probably won't.)</font></q> "
;

+ libA4Door: Door ->a4LibDoor
    'alley four 4 sw southwest door*doors' 'southwest door'
    "The door leads out to the southwest. "
;

+ libA6Door: Door ->a6LibDoor
    'alley six 6 se southeast door*doors' 'southeast door'
    "The door leads out to the southeast. "
;

+ libBookPiles: CustomImmovable
    'library worn well-worn old science fiction sf sci-fi paperback
    comic instruction paperbacks/book/pile/piles/textbook/manual/
    book/books*books*textbooks*manuals'
    'piles of books'
    "Most of the books seem to be well-worn science fiction paperbacks, but
    there are also old textbooks, comic books, phone books, instruction
    manuals, and who knows what else mixed in.  They're stacked up
    everywhere, practically in knee-deep piles in some places. "

    isPlural = true

    cannotTakeMsg = 'You can\'t have them all, obviously, and it would
        take too long to sift through them for something interesting. '

    lookInDesc = "You poke through the books a bit, but you find
        nothing particularly interesting. "
    dobjFor(Search) asDobjFor(LookIn)
    dobjFor(LookUnder) asDobjFor(LookIn)
    dobjFor(LookThrough) asDobjFor(LookIn)
    dobjFor(LookBehind) asDobjFor(LookIn)

    dobjFor(ConsultAbout)
    {
        verify() { }
        action() { "The books are just piled randomly, so there's
            no chance of finding anything specific. "; }
    }

    /* we're nominally on anything that's a LibUnderBooks */
    isNominallyIn(obj) { return inherited(obj) || obj.ofKind(LibUnderBooks); }
;

/* a class for one of our items buried under books */
class LibUnderBooks: object
    dobjFor(Search) remapTo(Search, libBookPiles)
    lookInDesc = "{The dobj/he} {is} buried under piles of books. "
    iobjFor(PutOn)
    {
        verify() { }
        action() { "There are too many books piled on {the iobj/him};
            anything you add would probably get lost in the piles. "; }
    }
;

+ LibUnderBooks, Fixture 'built-in shelves/shelf' 'shelves'
    "The built-in shelves line the walls.  Books are piled on the
    shelves horizontally, vertically, diagonally, and every way in
    between. "
    isPlural = true
;

+ LibUnderBooks, Fixture, Chair 'couch/couches/sofa/sofas' 'couches'
    "Even the couches are buried under piles of books, leaving
    no place you can easily sit down. "
    isPlural = true

    dobjFor(SitOn)
    {
        check()
        {
            "There are too many books; there's no space left over
            to sit. ";
            exit;
        }
    }
    dobjFor(LieOn) asDobjFor(SitOn)
    dobjFor(StandOn) asDobjFor(SitOn)
;

+ LibUnderBooks, Fixture 'large table' 'large table'
    "The table isn't itself very visible; all you can see is the
    books piled on top. "
;

+ Openable, Fixture 'large casement window' 'casement window'
    "The window looks out onto the courtyard and the model mountain. "

    dobjFor(LookThrough) remapTo(Examine, libCourtyard)

    initiallyOpen = nil
    dobjFor(Open)
    {
        check()
        {
            "The window seems to be stuck.  It was probably painted
            shut in the last remodel. ";
            exit;
        }
    }
;

+ libCourtyard: Distant
    'dabney house hovse paper-mache papier-mache
    papier-m\u00E2ch\u00E9 courtyard/mountain/peak' 'courtyard'
    "The window overlooks the courtyard from one story up.  The
    model mountain in the courtyard rises up a little higher than
    this level. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Alley 5 main 
 */
alley5main: AlleyRoom 'Alley Five Entry' 'the Alley Five entry'
    "This is an oddly-angled intersection of hallways at the
    entrance of Alley Five.  To the south is a stairway leading
    up, and across from the stairway is the exit to the courtyard
    to the north.  One hallway leads west, and another turns a
    corner and leads southeast. "

    vocabWords = '5 alley five entry/entrance/hallway/hall'

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

+ ExitPortal ->(location.out) 'courtyard/exit' 'courtyard'
    "The courtyard lies to the north. "
;

+ Graffiti 'math mathematical formula' 'graffiti'
    "It's a math formula: e to the pi i equals negative one.
    That relationship among those three special numbers is always
    mind-blowing when you first learn it; evidently someone was
    amazed enough to write it on the wall. "
;

+ a5StairsUp: StairwayUp ->a6StairsDown
    'stairs/stair/stairway' 'stairway'
    "The stairs lead up to Alley Six. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Alley 5 north
 */
alley5N: AlleyRoom 'Alley Five North' 'the north end of Alley Five'
    "This is the north end of a north/south section of Alley Five.
    The door to room 25 is on the east side of the hall, and across
    from it on the west side is the door to room 26.  The hallway
    continues south, and turns a corner to the northwest. "

    vocabWords = '5 alley five hall/hallway'

    northwest = alley5main
    south = alley5S
    east = room25door
    west = room26door

    roomParts = static (inherited
                        + [alleyEastWall, alleyWestWall, alleySouthWall])
;

+ room25door: AlleyDoor '25 -' 'door to room 25'
    "The number 25 is painted on the door. "
;

+ room26door: AlleyDoor '26 -' 'door to room 26'
    "The wooden door has the number 26 painted on it. "
;

+ Graffiti 'poem' 'graffiti'
    "It's a little snippet of a poem:
    \b\tIt matters not how strait the gate,
    \n\thow charged with punishment the scroll
    \n\tI am the master of my fate:
    \n\tI am the captain of my soul.
    \n\tNow, about that midterm... "
;

/* we can hear the music from down the hall */
+ Noise 'loud honolulu 10-4 theme theme/song/music' 'loud music'
    aName = 'a song'
    
    /* LISTEN TO ALLEY */
    sourceDesc = (hereWithSource)

    /* LISTEN TO MUSIC */
    descWithSource = "It's coming from down the alley to the south.
        It's pretty loud even from here; you recognize it as the
        theme from <i>Honolulu 10-4</i>, being played in a loop. "

    hereWithSource = "You can hear music from down the hall to the south. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Alley 5 south 
 */
alley5S: AlleyRoom 'Alley Five South' 'the south end of Alley Five'
    "This is the south end of Alley Five.  On the east side of the
    hall is a door numbered 23, and across the hall to the west
    is the door to room 24.  The hallway ends here, and stretches
    to the north. "

    vocabWords = '5 alley five hall/hallway'

    north = alley5N
    east = room23door
    west = room24door

    roomParts = static (inherited
                        + [alleyEastWall, alleyWestWall, alleyNorthWall])
;

+ room23door: AlleyDoor '23 -' 'door to room 23'
    "The number 23 is painted on the door. "
;

+ room24door: StackDoor '24 -' 'door to room 24'
    "The wooden door has the number 24 painted on it. "
;

++ CustomImmovable, Readable
    'large honolulu 10-4 promotional rick palm hula
    poster/burl/tree/trees/ocean/dancer/dancers'
    '<i>Honolulu 10-4</i> poster'
    "It's a promotional poster for the <i>Honolulu 10-4</i> TV series.
    It shows star Rick Burl in an action stance, gun at the ready,
    against a backdrop of palm trees, ocean, and hula dancers.
    At the bottom, in cheesy script lettering, is the series'
    catch-phrase, <i><q>Cuff 'em, Kiko!</q></i> "
    
    cannotTakeMsg = 'That\'s not yours; you should leave that where it is. '
;

++ CustomImmovable, Readable 'blue paper sign' 'blue sign'
    "The sign is hand-lettered on blue paper:
    <.p><.blockquote>
    Jacob's Honolulu 10-4 Surfin' Marbles Stack
    <.p>This is your chance for one more try at my Surfin' Marbles
    game.  All you have to do to defeat my stack is to solve it
    fully---you just have to get one marble to each corner.  You've
    seen me solve it, so you know it's possible.  To help get you
    in the mood, I've set up my stereo to play the <q>Honolulu 10-4</q>
    theme continuously all day long.  I'm sure you'll enjoy it!
    <./blockquote> "

    specialDesc = "The door to room 24 is decorated with a large
        promotional poster, and under the poster is a blue paper
        sign. "
    
    cannotTakeMsg = 'You should leave that where it is. '
;

+ Person 'student/students/group' 'group of students'
    "The students are huddled around a wooden marble-maze game.
    One of them is playing the game, trying to steer several
    marbles through the playfield maze by turning handles that
    tilt the playfield.  The rest are watching.  Most of them
    seem to be wearing earplugs or headphones. "

    specialDesc = "A group of students are huddled around a wooden
        marble-maze game, watching one of them play. "
;
++ InitiallyWorn
    'hearing earplug/earplugs/headphone/headphones/protection' 'earplugs'
    "Most of the students are wearing some kind of hearing protection.
    Some have earplugs, others are wearing headphones. "

    isListedInInventory = nil
    isPlural = true
;

++ DefaultAnyTopic, ShuffledEventList
    ['You tap one of the students on the shoulder to get her
    attention.  She looks up at you, but before you can finish
    talking, she mouths <q>WHAT?</q>  You realize that she can\'t
    hear you over the music any better than you can hear her. ',

     'You try to get someone\'s attention, but the music is
     too loud; no one seems to hear a word you\'re saying. ',

     'No one can seem to hear anything you say over the music. ']
;

+ CustomImmovable
    'wood (honolulu) (10-4) wooden marble marble-maze maze
    surfin surfin\' marbles surfing game/box'
    'marble-maze game'

    "It's a wooden box about two feet square and six inches high.
    The playfield has a network of little ridges that form a maze
    for a set of marbles.  The playfield tilts; the player controls
    the tilt by turning a couple of handles on the side of the game.
    The goal is to steer each marble to a different corner.
    <.p>The game has a <i>Honolulu 10-4</i> theme.  An illustration
    of the characters from the series is painted on the playfield,
    although it's somewhat worn from long use. "
    
    cannotTakeMsg = 'The students would certainly not want you to
        run off with the centerpiece of the stack while they\'re
        still working on it. '

    dobjFor(Play)
    {
        verify() { }
        action() { playScript.doScript(); }
    }
    dobjFor(Use) asDobjFor(Play)

    playScript: StopEventList { [
        'You squeeze into the group of students, and wait for
        an opening.  The student who\'s been playing finishes
        his attempt and lets you take over.  You put the marbles
        in the starting position, and start turning the handles.
        It\'s a lot harder than it looks, though, and you almost
        immediately lose two of the marbles in the <q>Honolulu
        Jail</q> trap.  You stand up and let one of the students
        try it.  This game clearly takes a lot of practice. ',

        'You squeeze into the group and take another try at the
        game.  You set up the marbles and start working the handles.
        This time you do a little better; you manage to get one of
        the marbles into its corner.  But as you start working on
        the next corner, the first marble rolls out of its corner
        and lands in the <q>Shark Attack</q> trap.  You let someone
        else take another turn. ',

        'You squeeze in for another try.  You get the first marble
        into its corner pretty quickly this time, and you manage to
        back it away from the Shark trap just as it\'s about to
        fall in.  But while you\'re doing that, a third marble
        falls into the <q>Tiki Taboo</q> trap.  You hand over the
        game to the next player. ',

        'You feel like you should be getting good at the game after
        all the practice you\'ve had, so you give it another go.
        You feel like you\'re doing well, but then one marble
        falls into the Jail trap at the same time another falls
        into the Shark trap.  You shake your head and let someone
        else take a turn. ',

        'You give the game another try, but the throbbing music is
        really getting to you; you just can\'t concentrate.  You
        let someone else have a turn. ']
    }
;
++ Component 'worn (playfield) (honolulu) (10-4)
    illustration/character/characters/playfield'
    'playfield illustration'
    "The playfield is illustrated with characters from the
    <i>Honolulu 10-4</i> TV series.  The illustration is slightly
    worn from having marbles roll over it. "
;
++ Component
    'steel ball marble/marbles/bearing/bearings/ball-bearing/ball-bearings'
    'marbles'
    "The marbles look like they're made of steel; they're probably
    just ball bearings. "
    isPlural = true
;
++ Component 'handle/handles' 'handle'
    "You can control the tilt of the playfield by turning the
    handles. "

    /* TURN HANDLES -> PLAY GAME */
    dobjFor(Turn) remapTo(Play, location)
;

+ xyzzyGraffiti: Graffiti 'odd wiggly handwriting' 'graffiti'
    "The word <q>xyzzy</q> is written on the wall in odd, wiggly
    handwriting. "
;

+ Noise 'honolulu 10-4 theme theme/song/music' '<i>Honolulu 10-4</i> theme'
    aName = 'a theme song'

    /* LISTEN TO ALLEY shows this; just show our normal emanation */
    sourceDesc = (hereWithSource.doScript())

    /* LISTEN TO MUSIC shows this message */
    descWithSource = "It's the incredibly catchy and repetitive
        theme music to <i>Honolulu 10-4</i>, being played at
        high volume and in a seemingly endless loop. "

    /* 
     *   this is used in generic LISTEN, in X ALLEY, and in our background
     *   daemon that runs as long as we're within hearing range 
     */
    hereWithSource: ShuffledEventList { [
        'Driving, fast-tempo music blares through the hall at
        an almost deafening volume.  You immediately recognize it
        as the incredibly catchy theme music from <i>Honolulu 10-4</i>,
        the popular TV cop show from the late 60\'s. ',

        'The <i>Honolulu 10-4</i> music plays through its brassy
        crescendo.  You think it\'s about to end, but almost
        seamlessly, it switches to the rolling percussion and trumpet
        blast of the song\'s opening, and the whole thing starts
        over again. ',

        'The <i>Honolulu 10-4</i> theme music keeps playing, obviously
        on a tight loop.  You\'re sure you\'re going to have this song
        stuck in your head all day. ']

        ['KEY CHANGE!  The <i>Honolulu 10-4</i> music subtly shifts
        keys and repeats the catchy melody yet again. ',

         'The <i>Honolulu 10-4</i> music keeps blasting through the
         alley. ',

         'DRUM ROLL!  The theme music starts yet another cycle. ',

         'The blaring theme music continues to assault the alley. ',

         'TRUMPET BLAST!  The theme music reaches another climactic
         crescendo, and loops back to the beginning. ']
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
            "It would be great if a magic word could whisk you away,
            but nothing seems to happen here. ";
        }
        else if (xyzzyGraffiti.described)
        {
            if (gActor.isIn(xyzzyGraffiti.location))
                "You say the magic word aloud, but alas, nothing
                happens here. ";
            else
                "You say the magic word aloud, but alas, you're not
                magically transported to Alley Five. ";
        }
        else
            "You seem to recall a graffito to that effect somewhere
            in Alley Five. ";
    }
;
VerbRule(Xyzzy) 'xyzzy' : XyzzyAction
    verbPhrase = 'xyzzy/xyzzying'
;

/* ------------------------------------------------------------------------ */
/*
 *   Alley 5 middle
 */
alley5M: AlleyRoom 'Middle of Alley Five' 'the middle of Alley Five'
    "This is the middle of an east/west section of Alley Five.
    A door on the north is numbered 31, and across the hall on
    the south side is the door to room 27. "

    east = alley5main
    west = alley5W
    north = room31door
    south = room27door

    vocabWords = '5 alley five/hall/hallway'
    
    roomParts = static (inherited + [alleyNorthWall, alleySouthWall])
;

+ room27door: AlleyDoor '27 -' 'door to room 27'
    "The number 27 is painted on the door. "
;

+ room31door: AlleyDoor '31 -' 'door to room 31'
    "The wooden door has the number 31 painted on it. "
;

+ Graffiti 'chinese character/character/calligraphy' 'graffiti'
    "There's a passage of what looks like Chinese calligraphy. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Alley 5 west 
 */
alley5W: AlleyRoom 'Alley Five West' 'the west end of Alley Five'
    "This is the west end of Alley Five; the hallway continues
    off to the east.  To the west is the door to room 29.  A
    door numbered 28 is on the south side of the hall, and across
    from it on the north is the door to room 30. "

    east = alley5M
    south = room28door
    west = room29door
    north = room30door

    vocabWords = '5 alley five/hall/hallway'
    
    roomParts = static (inherited +
                        [alleyNorthWall, alleySouthWall, alleyWestWall])
;

+ room28door: AlleyDoor '28 -' 'door to room 28'
    "The number 28 is painted on the door. "
;

+ room29door: AlleyDoor '29 -' 'door to room 29'
    "The wooden door has the number 29 painted on it. "
;

+ room30door: AlleyDoor '30 -' 'door to room 30'
    "It's a wooden door labeled with the number 30. "
;

+ Graffiti 'comic stuffed strip character/characters/boy/tiger' 'graffiti'
    "A very nice rendition of some comic strip characters
    is drawn here.  It's a boy and his stuffed tiger, from a
    comic strip from years past. "
;


/* ------------------------------------------------------------------------ */
/*
 *   Alley 6 center 
 */
alley6main: AlleyRoom 'Middle of Alley Six' 'the middle of Alley Six'
    "This is the middle of Alley Six.  A stairway to the south
    leads down.  The hallway continues east and west. "

    vocabWords = '6 alley six hall/hallway'

    down = a6StairsDown
    south asExit(down)
    east = alley6E
    west = alley6W

    roomParts = static (inherited + [alleyNorthWall, alleySouthWall])
;

+ a6StairsDown: StairwayDown 'stairs/stair/stairway' 'stairway'
    "The stairs lead down to Alley Five. "
;

+ Graffiti 'escher-like drawing/snake' 'graffiti'
    "An Escher-like drawing of a snake eating its own tail
    is on the wall. "
;    

/* ------------------------------------------------------------------------ */
/*
 *   Alley 6 west
 */
alley6W: AlleyRoom 'Alley Six West' 'the west end of Alley Six'
    "This is the west end of Alley Six.  To the northwest is
    a door leading into the house library.  The door to room
    33 is to the southwest, and room 34 is to the southeast.
    The hallway continues to the east. "

    vocabWords = '6 alley six hall/hallway'

    northwest = a6LibDoor
    southwest = room33door
    southeast = room34door
    east = alley6main

    roomParts = static (inherited + [alleyNorthWall, alleySouthWall])
;

+ a6LibDoor: Door 'library door' 'library door'
    "It looks like the door to any student room in the house, but
    <q>Library</q> is painted on the door in place of a room number. "

    isOpen = true
;

+ room33door: AlleyDoor '33 -' 'door to room 33'
    "It's a wooden door labeled <q>33.</q> "
;

+ room34door: AlleyDoor '34 -' 'door to room 34'
    "It's a wooden door labeled <q>34.</q> "
;

+ Graffiti 'crude spray-painted cow/outline' 'graffiti'
    "A rather crude outline of a cow is drawn on the wall
    in spray paint. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Alley 6 east 
 */
alley6E: AlleyRoom 'Alley Six East' 'the east end of Alley Six'
    "This is the east end of Alley Six.  The alley ends at the
    door to room 35 to the east, and continues west.  Another,
    narrower hallway leads south. "

    vocabWords = '6 alley six'

    south = alley6S
    west = alley6main
    east = room35door

    roomParts = static (inherited
                        + [alleyEastWall, alleySouthWall, alleyNorthWall])
;

+ Vaporous 'small black diffuse fruit fly/flies/drosophila/cloud'
    'cloud of fruit flies'
    "<i>Drosophila melanogaster</i>, you presume: the geneticist's
    favorite.  The flies are lazily drifting around the hall in a
    diffuse cloud.  Some of them move freely in and out of the
    plastic tube in the door; about equal numbers seem to be
    coming and going. "

    specialDesc = "A diffuse cloud of small black flies fills the
        alley. "
;

+ CustomImmovable 'pile/fruit/banana/peach/orange' 'pile of fruit'
    "Several pieces of fruit are piled on the floor: a banana, an
    orange, a peach, and several others.  They've all been partially
    peeled, and they're all crawling with fruit flies. "

    /* show the initial description the first time only */
    isInInitState = (!described)
    initDesc = "It looks like someone's working on the stack, even if
        they're not here at the moment.  <<desc>> "

    cannotTakeMsg = 'You don\'t want the fruit badly enough to
        compete for it with the flies. '

    /* list it as though it were portable */
    isListed = true
    isListedInContents = true

    dobjFor(Eat)
    {
        preCond = []
        verify() { }
        action() { "You can't be serious. "; }
    }
;
++ Decoration 'small black ruit fly/flies/drosophila' 'fruit flies'
    "They're happily ingesting the fruit, micrograms at a time. "

    disambigName = 'flies on the fruit'
    notImportantMsg = 'The flies are too numerous and too small to
        do anything with. '

    isPlural = true
;

+ room35door: StackDoor '35 -' 'door to room 35'
    "It's a door painted with the number 35. "
;

++ CustomImmovable
    '(fruit) (fly) bioventics model 77 insect small electronic
    densitometer/instrument/device/wire/wires'

    name = (described ? 'fly densitometer' : 'small electronic device')

    desc = "It's a small electronic device labeled <q>Bioventics
        Model 77 Insect Densitometer.</q>  The only feature is a numeric
        display, which currently reads <q><tt><<dispVal>></tt>.</q>
        The device is sitting at the bottom of the door, and some wires
        run out the back and under the door. "
    
    cannotTakeMsg = 'The wiring prevents the device from being moved. '

    dispVal = (toString(7500 + rand(1000)) + '.' + toString(10 + rand(80))
               + ' /m^3')
;
+++ Component, Readable
    '(fly) densitometer numeric display' 'fly densitometer display'
    "The display is currently reading <q><tt><<location.dispVal>></tt>.</q> "
;

++ Fixture 'hard white plastic tube' 'plastic tube'
    "The tube is about an inch in diameter and is made of hard
    white plastic.  It goes through the hole in the door where,
    presumably, the doorknob used to be.  Fruit flies lazily drift
    in and out of the tube. "

    dobjFor(LookIn) asDobjFor(LookThrough)
    dobjFor(LookThrough) { action() { "You peer into the tube, but
        you can't see past a bend that looks like it's just past
        the door. "; } }

    specialDesc = "An orange sign is affixed to the door of room 35.
        Under the sign, a black plastic tube sticks out slightly
        from the door.  On the floor at the bottom of the door is
        a small electronic device. "
;

++ CustomImmovable
    'orange broken interlocking international biohazard
    ring/rings/sign/symbol'
    'orange sign'
    "The sign is hand-lettered in black marker, over a background
    graphic showing the three broken, interlocking rings of the
    international Biohazard symbol.
    <.p><.blockquote>
    Stan's World of Drosophila Stack
    <.p>Help me prove the cleaning people wrong.  They say my room
    is too dirty to clean.  That's right, it's the room so dirty,
    it can't be cleaned.  So say they.  I say their problem is my
    highly successful drosophila breeding program.
    <.p>My stack is this: you have to liberate the approximately
    fifty thousand fruit flies in my room.  Notice the key word is
    liberate, not exterminate.  Help show them the way into the
    wild.  You'll know you're done when the Fly Densitometer shows
    a reading of 5 or less.
    <.p>As an added incentive to work quickly, the bribe waiting
    inside includes generous quantities of delicious fresh fruit,
    plus a couple of open tubs of corn syrup.  The sooner you show
    the flies the way out, the more there'll be left.
    <./blockquote> "

    cannotTakeMsg = 'You should leave that where it is. '
;

+ EntryPortal ->(location.south)
    'another south s narrow narrower hall/hallway' 'narrow hallway'
    "The narrow hallway joins the main east/west hall in a
    T-intersection here.  It leads south. "
;

+ Graffiti 'bright yellow leafy green painted flower/flowers/stalk/stalks'
    'graffiti'
    "The wall is painted near the floor with life-sized
    bright-yellow flowers on leafy green stalks. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Alley 6 south 
 */
alley6S: AlleyRoom 'Alley Six South' 'the south end of Alley Six'
    "This is the south end of the narrow north/south section of
    Alley Six.  The door to room 36 is on the west side of the
    hall, and across from it on the east side is the door to
    room 37.  The alley continues north, and ends here in a
    paned-glass door, which leads outside to the south. "

    vocabWords = '6 alley six hall/hallway'

    north = alley6E
    east = room37door
    west = room36door
    south = a6PorchDoor

    roomParts = static (inherited
                        + [alleySouthWall, alleyEastWall, alleyWestWall])
;

+ room36door: AlleyDoor '36 -' 'door to room 36'
    "It's a wood door numbered 36. "
;

+ room37door: AlleyDoor '37 -' 'door to room 37'
    "It's a door painted with the number 37. "
;

class SleepingPorchDoor: Door
    'wrought iron wrought-iron paned glass paned-glass
    one-foot-square foot-square door/frame/pane/panes/glass'

    'paned-glass door'

    "The door has a wrought iron frame set with one-foot-square
    panes of glass. <<whereDesc>> "


    dobjFor(LookThrough) { action() { "You can't see much; the glass
        is a little hazy. "; } }
;

+ a6PorchDoor: SleepingPorchDoor
    whereDesc = "It leads outside to the south. "
;

+ Graffiti 'painting/vampire/window' 'graffiti'
    desc = "The wall here features a painting of what seems to be
        a vampire escaping a window. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Sleeping Porch 
 */
sleepingPorch: DabneyOutdoorRoom 'Sleeping Porch' 'the sleeping porch'
    "This wide terrace is known as the Sleeping Porch.  Students
    actually do sleep out here on occasion, especially during the
    summer when it's too warm indoors.  Traffic busily zips by on
    California Boulevard below.  A paned-glass door leads inside to
    the north. "

    north = spDoor

    vocabWords = 'wide sleeping porch/terrace'

    dobjFor(JumpOff)
    {
        verify() { }
        action() { "It's much too long a drop to attempt. "; }
    }

    roomBeforeAction()
    {
        if (gActionIn(Jump, JumpOffI))
            replaceAction(JumpOff, self);
    }
;

+ spDoor: SleepingPorchDoor ->a6PorchDoor
    whereDesc = "It leads north, back inside. "
;

/* add California Blvd and its consituent parts */
+ Distant 'california boulevard/blvd/blvd./street/road'
    'California Boulevard'
    "California Boulevard is a busy four-lane street that forms
    the south border of the campus. "

    isProperName = true
;
++ CalBlvdTraffic;
+++ CalBlvdNoise;

/* ------------------------------------------------------------------------ */
/*
 *   Alley 7 top of stairs 
 */
alley7main: AlleyRoom 'Alley Seven' 'Alley Seven'
    "This is the hub of Alley Seven.  The long, narrow expanse of
    Upper Seven, with its array of monastic cells, stretches north;
    Lower Seven is down a few steps to the east.  A long, steep
    stairway descends to the courtyard. "

    vocabWords = '7 alley seven'

    down = a7CourtyardStairs
    out asExit(down)
    north = upper7S
    east = a7lowerStairs
    south asExit(down)

    roomParts = static (inherited + [alleySouthWall, alleyWestWall])
;

+ a7CourtyardStairs: StairwayDown -> dcStairsUp
    'long steep concrete courtyard stairs/stairway' 'courtyard stairway'
    "It's about two normal stories worth of stairs leading down to
    the courtyard. "
;

+ EntryPortal ->(location.north)
    'long narrow monastic 7 upper seven/cell/cells/(array)/hall/hallway'
    'Upper Seven'
    "The long, narrow hallway extends north. "
    isProperName = true
;

+ a7lowerStairs: StairwayDown -> l7Stairs
    'lower seven 7 step/steps/stair/stairs/stairway' 'Lower Seven'
    "Lower Seven is down a few steps to the east. "
    isProperName = true
;

+ Graffiti 'gigantic black "welcome to alley 7" "welcome" sign' 'graffiti'
    "There are lots of bits of graffiti here, including a gigantic
    black <q>Welcome to Alley 7</q> sign. "
;    

/* ------------------------------------------------------------------------ */
/*
 *   Lower 7 West
 */
lower7W: AlleyRoom 'Lower Seven West' 'the west end of Lower Seven'
    "This is the west end of Lower Seven.  A half flight of stairs to
    the west leads up to Upper Seven.  The hallway continues east,
    but the way is thoroughly blocked by a pile of concrete rubble
    and broken pieces of re-bar, and a collection of heavy power tools.
    The rubble is evidently what's been chipped off the huge concrete
    block to the south, filling the space where the door to room 50
    would normally be.  Across the hall to the north, the door to
    room 49 is still intact. "

    west = l7Stairs
    up asExit(west)
    north = room49door
    south: NoTravelMessage { "There's a huge concrete block in the way. " }

    east: NoTravelMessage { "The hallway does continue east, but there's
        no way you can get past the rubble and all of the tools. " }

    vocabWords = '7 alley lower seven/hallway'

    roomParts = static (inherited + [alleyNorthWall, alleySouthWall])
;

+ Graffiti
    'psychedelic bright neon black-and-white
    swirl/swirls/spiral/spirals/color/colors/landscape/checkerboard/mural'
    'graffiti'
    "An extensive mural starts with a black-and-white checkerboard
    at one end that transforms into a psychedelic landscape of
    swirls and spirals of bright, neon colors at the other end. "
;

+ l7Stairs: StairwayUp
    'upper seven 7 step/steps/stair/stairs/stairway' 'stairs'
    "The stairs lead up to Upper Seven, to the west. "
;

+ room49door: AlleyDoor '49 -' 'door to room 49'
    "It's a wooden door labeled <q>49.</q> "
;

+ CustomImmovable
    'construction heavy power circular masonry huge air-powered air
    tool/tools/equipment/jackhammer/jackhammers/saw/drill/drills/
    compressor/compressors'
    'power tools'
    "There are a bunch of serious construction tools stacked along
    the wall: a couple of jackhammers, a circular masonry saw,
    huge air-powered drills, air compressors, and lots of things
    you don't even recognize.  Several of the students are attacking
    the block of concrete with one of the jackhammers. "

    isPlural = true
    
    cannotTakeMsg = 'Even if the equipment weren\'t so large and
        unwieldy, the students would undoubtedly object to your
        making off with it. '
;

++ Noise '(jackhammer) (jackhammering) construction noise'
    'construction noise'
    /* LISTEN TO TOOLS */
    sourceDesc = "The jackhammer is making a lot of noise as it
        chips away at the concrete. "

    /* LISTEN TO CONSTRUCTION NOISE */
    descWithSource = (sourceDesc)

    /* LISTEN, X ALLEY, background daemon */
    hereWithSource: ShuffledEventList { [
        'The jackhammer makes a horrible metal-on-metal scraping sound. ',
        'The jackhammer blasts away at the concrete block. ',
        'The air compressor makes a loud hiss. ',
        'The whole building seems to rumble with the jackhammer noise. ']
    }

    displaySchedule = [2]
;

+ Person 'dusty group/student/students' 'group of students'
    "The students are dusty from the demolition, like everything
    else around here.  They're working together to jackhammer the
    block of concrete. "

    specialDesc = "A group of students are attacking the block
        of concrete with a jackhammer. "
;

++ DefaultAnyTopic
    "You try to get someone's attention, but everyone's too
    busy with the jackhammering. "
;

+ Fixture 'room 50 door doorframe/frame' 'room 50 doorframe'
    "The doorframe is completely filled in with a block of concrete. "
;

++ Heavy 'concrete block/concrete' 'concrete block'
    "The block of concrete entirely fills the room 50 doorframe,
    and sticks out a couple of feet into the hall.  About half of
    the front face is unevenly pitted to a depth of a few inches,
    evidently from the efforts of the students to break through.
    Twisted bits of re-bar stick out in places. "

    /* show the initial description the first time only */
    isInInitState = (!described)
    initDesc = "This is a fine example of the classic Brute Force
        Stack: not the sort of fancy intellectual puzzle that's so
        popular these days, but an actual physical barrier.  The
        point is just to blast through it with raw physical force.
        There's no need for rules; the only rules are the laws of
        physics.  That, and a decent respect for the structural
        integrity of the building.
        <.p><<desc>> "
;

+++ Decoration 'twisted re-bar/rebar' 'twisted re-bar'
    "The re-bar is exposed in a few places where the concrete has
    been chipped away. "

    dobjFor(Pull)
    {
        verify() { }
        action() { "It's literally set in concrete.  There's no way
            you can move it with your bare hands. "; }
    }
    dobjFor(Push) asDobjFor(Pull)
    dobjFor(Move) asDobjFor(Pull)
    dobjFor(Turn) asDobjFor(Pull)
    dobjFor(PushTravel) asDobjFor(Pull)
;

+ CustomImmovable
    'broken concrete demolition rubble/pile/piles/re-bar/piece/pieces/dust'
    'rubble'
    "Considering how much rubble is piled in the hallway, it's
    surprising that the block isn't already gone.  The rubble is
    piled at least a couple of feet deep, effectively blocking the
    way east.  Needless to say, the demolition dust is everywhere. "

    cannotTakeMsg = 'There\'s far too much rubble to take with you,
        and even the smallest pieces are inconveniently large and
        heavy and sharp-edged.  The most you could do is shift the
        piles around a little, which wouldn\'t accomplish anything. '

    lookInDesc = "All you find in the rubble is even more rubble. "
;    
    

/* ------------------------------------------------------------------------ */
/*
 *   Upper 7 South
 */
upper7S: AlleyRoom 'Upper Seven South' 'south end of Upper Seven'
    "This is the south end of Upper Seven.  The narrow hallway
    stretches north, lined on both sides with graffiti and
    closely-spaced doors.  Most of the notorious Upper Seven singles
    are so small that you can stand in the middle of one and touch
    opposite walls at the same time.
    <.p>The door to room 43 is northwest, 44 northeast, 45 west,
    46 east, 47 southwest, and 48 southeast.  The hallway continues
    to more dense-packed rooms to the north, and opens into a larger
    area to the south. "

    vocabWords = '7 upper alley seven'

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

+ room43door: AlleyDoor '43 -' 'door to room 43'
    "It's a wooden door labeled <q>43.</q> "
;
+ room44door: AlleyDoor '44 -' 'door to room 44'
    "It's a wooden door labeled <q>44.</q> "
;
+ room45door: AlleyDoor '45 -' 'door to room 45'
    "It's a wooden door labeled <q>45.</q> "
;
+ room46door: AlleyDoor '46 -' 'door to room 46'
    "It's a wooden door labeled <q>46.</q> "
;
+ room47door: AlleyDoor '47 -' 'door to room 47'
    "It's a wooden door labeled <q>47.</q> "
;
+ room48door: AlleyDoor '48 -' 'door to room 48'
    "It's a wooden door labeled <q>48.</q> "
;

+ Graffiti '-' 'graffiti'
    "<font face='tads-sans'><b>You know you're a nerd when
    you start dreaming in <tab id=lang><s>&nbsp;FORTRAN&nbsp;</s>
    \n<tab to=lang><s>&nbsp;Pascal&nbsp;</s>
    \n<tab to=lang><s>&nbsp;C&nbsp;</s>
    \n<tab to=lang><s>&nbsp;C++&nbsp;</s>
    \n<tab to=lang><s>&nbsp;Java&nbsp;</s>
    \n<tab to=lang>&nbsp;QUBITS&nbsp;
    </b></font>
    \bEach programming language name has been crossed out and
    another has been written below, and then that replacement
    has been itself crossed out and replaced.  Only the
    last entry, <q>QUBITS,</q> is left standing. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Upper 7 North 
 */
upper7N: AlleyRoom 'Upper Seven North' 'north end of Upper Seven'
    "Closely-spaced doors to the monastic cells that are Upper Seven
    singles line this stretch of narrow hallway.  Room 38 is northeast,
    39 is northwest (you recall it's the one double room in Upper 7),
    40 is east, 41 is southwest, and 42 is southeast.
    The alley extends away to the south, ending here at a wall to
    the north.
    <.p>An ancient personal computer is on the floor outside the
    door of room 42.  A blue paper sign is attached to the door. "
    
    vocabWords = '7 upper alley seven'

    south = upper7S
    northeast = room38door
    northwest = room39door
    east = room40door
    southwest = room41door
    southeast = room42door

    roomParts = static (inherited
                        + [alleyEastWall, alleyWestWall, alleyNorthWall])
;

+ room38door: AlleyDoor '38 -' 'door to room 38'
    "It's a wooden door labeled <q>38.</q> "
;
+ room39door: AlleyDoor '39 -' 'door to room 39'
    "It's a wooden door labeled <q>39.</q> "

    dobjFor(Knock)
    {
        action()
        {
            /* do the normal no-reply business */
            inherited();

            /* if Aaron's here, mention where he went */
            if (aaron.isIn(location))
                "<.p>Aaron glances over. <q>If you're looking for
                Scott, I think he's working on the giant chicken
                stack in alley 3.</q> ";
        }
    }
;
+ room40door: AlleyDoor '40 -' 'door to room 40'
    "It's a wooden door labeled <q>40.</q> "
;
+ room41door: AlleyDoor '41 -' 'door to room 41'
    "It's a wooden door labeled <q>41.</q> "
;
+ room42door: StackDoor '42 -' 'door to room 42'
    "A blue paper sign is attached to the door, and an old personal
    computer is sitting on the floor in front of it.  The door is
    labeled <q>42.</q> "
;
++ CustomImmovable, Readable 'blue paper sign' 'sign'
    "<font face='tads-sans'>Welcome to Paul's Ditch Day Stack!
    My stack consists of
    just one puzzle, contained in the Commandant 64 below.  All you have
    to do is type in the correct <q>password.</q>  You'll know
    you've typed the right thing when the output is the exact same string
    as the input.  (The password has a non-zero number of characters.
    You can't win by claiming that if you type zero characters, the
    computer responds with the same zero characters.)
    <.p>A couple of hints.  First, the password is from one to
    sixteen characters long.  Second, it only contains the digits 0 to 9
    and the letters A through F.  Third, if you type in something other
    than the password, the computer might show you a response that
    looks like gibberish---but that gibberish is actually useful
    information, so don't ignore it.
    <.p>Good luck!</font> "
    
    disambigName = 'blue paper sign'
    cannotTakeMsg = 'You should leave the sign where it is. '
;
+ commandant64: Keypad, CustomImmovable, Readable
    'white plastic ancient old personal 64 display
    computer/commandant/machine/keyboard/display/monitor/screen/pc'
    'old computer'
    "The computer is a Commandant 64, one of those machines from
    the first generation or two of personal computers.  It looks like
    a white plastic suitcase, lying on its side, with a keyboard
    embedded on the top near the front edge.  A small display sits
    on top.
    <.p><<readDesc>> "
    
    cannotTakeMsg = 'You shouldn\'t disturb the stack. '
    readDesc()
    {
        "The monitor is currently showing:\b
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
    successStr = 'SUCCESS!!!'

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
            "You type in <q><tt><<gLiteral.htmlify()>></tt></q> and press
            enter.  After a few moments, the monitor changes to display:
            \b<tt><<monitorDesc>></tt> ";

            /* if it's the winning password, say so */
            if (monitorDesc.endsWith(successStr))
            {
                if (room42door.isSolved)
                {
                    "<.p>You've solved it again!  You discreetly type in
                    a new random string to avoid spoiling the puzzle
                    for anyone else. ";
                }
                else
                {
                    "<.p>You found the password!  You feel inordinantly
                    pleased with yourself, but that's tempered by the
                    knowledge that this doesn't get you any further
                    with Stamer's stack. ";

                    if (aaron.isIn(location))
                        "<.p>It doesn't look like Erin or Aaron were
                        paying attention.  As much as you'd like to show
                        off your solution, you figure they'd probably
                        be happier solving the stack on their own, so
                        you quietly type in a random string to clear
                        the solution from the monitor. ";
                    else
                        "<.p>You don't want to spoil the puzzle for
                        anyone else, so much as you'd like to show off
                        your solution, you quietly type in a random
                        string to clear the solution from the monitor. ";

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
    extraCreditMarker: ExtraCreditAchievement { +50 "solving the
        Commandant 64 stack" }

    timeWasterWarning: StopEventList { [
        nil, nil, nil,
        '<.p>It occurs to you that this sort of puzzle can be awfully
        addictive; better be careful not to get sidetracked too much here. ',
        nil, nil, nil, nil, nil,
        '<.p>Interesting as this is, you know you really should be
        getting back to Stamer\'s stack before too long. ',
        '<.p>You keep reminding yourself not to get too sucked into
        this stack, since you have more important things you should
        be working on. ',
        nil] }

    aAndENotice: ShuffledEventList { [
        '<.p>Erin and Aaron look at what you typed and mutter a
        few comments to each other. ',
        '<.p>Aaron looks at the display and makes a little <q>hmm</q>
        noise. ',
        '<.p>Erin looks carefully at what you typed. ',
        '<.p><q>Interesting,</q> Aaron says, looking at the display. ',
        '<.p>Erin looks at what you typed and nods. '] }

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
            return prefix + 'ERR:0-9+A-F ONLY!!!';
        }
        else if (str.length() > 16)
        {
            /* too long */
            return prefix + 'ERR:16 CHARS MAX!!!';
        }
        else
        {
            local result, outStr;
            
            /* run the program */
            outStr = runProgram(str);
            
            /* add the result to the prefix */
            result = prefix + 'OUT:' + outStr;

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

+ Graffiti 'Polly Nomial story' 'graffiti'
    "<q>...When Polly got home that night, her mother noticed
    that she was no longer piecewise continuous, but had been
    truncated in several places.  But it was too late to
    differentiate now.  As the months went by, Polly's
    denominator increased monotonically.  Finally, she went
    to l'H&ocirc;pital and generated a small but pathological
    function which left surds all over the place, and drove
    Polly to deviation...</q> "
;

