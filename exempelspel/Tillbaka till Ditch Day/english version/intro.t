/* 
 *   Copyright 2003, 2013 Michael J. Roberts
 *   
 *   Return to Ditch Day - Prologue.  This introductory sequence takes
 *   place away from campus - "somewhere in south Asia" - and gives us
 *   a chance to set up some of the characters and back-story.  
 */

#include <adv3.h>
#include <en_us.h>


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
omegatronTopic: Topic 'my omegatron/company';

/* mitachron (the rival company) */
mitachronTopic: Topic 'mitachron';

/* phone call */
phoneCallTopic: Topic 'cell cellular phone telephone call';

/* elevators in general */
elevatorTopic: Topic 'elevator/lift';

/* some resume-related topics */
hiringFreezeTopic: Topic 'omegatron hiring freeze';
kowtuan: Topic 'kowtuan technical institute/university/college';
chipTechNo: Topic 'semiconductor chemical applicator
    chiptechno/manufacturer/operations';

/* the power plant itself */
powerPlant6: Topic '6 government power plant';

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
        '6 government power plant' 'Government Power Plant #6'

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

/* the background plant noise */
+ SimpleNoise
    desc = "The normal low rumblings and industrial noises of
            a power plant are constantly in the background. "
;

MultiInstance
    initialLocationClass = PowerPlantRoom
    instanceObject: Decoration { 'concrete' 'concrete'
        "Essentially all of the plant structure is built out of concrete. "
    }
;

/* a simple marker class for our power plant rooms */
class PowerPlantRoom: Room;

/* misty cloud of insect repellent */
deetCloud: Vaporous 'misty powerful noxious insect
    spray/repellent/mist/cloud/vapor/insecticide'
    'cloud of insect repellent'
    "The misty vapor hangs in the air through the whole room. "
;
+ Odor
    isAmbient = true
    sourceDesc = "It has a foul chemical odor. "
    hereWithSource = "A noxious mist of insect repellent fills the air. "
;

/* the tank */
deetTank: Thing 'powerful suitcase-sized metal insect tank/hose/repellent'
    'tank of insect repellent'
    "It's about the size of a large suitcase, and has a hose attached. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Power Plant Control Room 
 */

/* group lister for Xojo and Guanmgon while standing in the doorway */
standingInDoorway: ListGroupPrefixSuffix
    groupPrefix = "\^"
    groupSuffix = " are standing in the doorway watching you work. "
    createGroupSublister(parentLister) { return plainActorLister; }
;

/* 
 *   The control room itself. 
 */
powerControl: PowerPlantRoom 'Control Room' 'the control room'
    "This is the cramped control room of Government Power Plant #6.
    Even before you arrived, this room was so stuffed with equipment
    that it was barely possible to turn around.  Now that you've
    added the refrigerator-sized SCU-1100DX to the mix, the room has
    about as much open space as the <q>budget economy class</q>
    airline seat you were wedged into for fifteen hours on the
    flight here.  The only exit is west. "

    vocabWords = 'control room'

    /* going west takes us to the power control hallway */
    west = powerControlDoorway
    out asExit(west)

    /* some atmospheric messages */
    atmosphereList: ShuffledEventList {
        [
            'You notice a mosquito land on your arm, and manage to swat
            it before it can bite. ',
            'You feel something on your neck, and realize too late that
            it\'s a mosquito just flying away. ',
            'A mosquito buzzes past within inches of your ear. ',
            'Several of your mosquito bites start itching. ',
            'A mosquito flies lazily past your head. ',
            'The humidity is definitely getting worse. ',
            'A distant creaking sound echoes through the building. '
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
    'west w door/doorway' 'doorway'
    "It's just a doorway without a door, leading out to the west. "

    /*
     *   Dont't allow the player to go this way until the SCU-1100DX is
     *   repaired. 
     */
    canTravelerPass(travler) { return scu1100dx.isOn; }
    explainTravelBarrier(traveler)
    {
       "You simply can't leave until you get the SCU-1100DX working. ";
    }

    dobjFor(StandOn)
    {
        verify() { }
        action() { mainReport('There\'s no reason to do that. '); }
    }
;

/*
 *   our first assistant
 */
+ xojo: TourGuide, Person 'xojo/man/bureaucrat*men' 'Xojo'
    "He's a low-level bureaucrat assigned to assist you with the
    SCU-1100DX installation.  He looks young, maybe in his mid-twenties.
    He's a bit taller than you and very thin. "

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
                "<q>Do you think you could try lifting me?</q> you ask.
                <.p><q>Very well,</q> Xojo says. ";
                
                boostPlayerChar();
            }
            else if (gActor.isIn(xojoBoost))
                "It doesn't look like Xojo can lift you any higher. ";
            else
                "Xojo probably wouldn\'t like that. ";
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
                "<.p>Xojo watches what you're doing. <q>I think
                <<obj.theName>> is too difficult to climb.</q> he says.
                <q>Perhaps, though, I could lift you.  Do you want me to
                try?</q> ";
            else
                "<.p><q>Would you perhaps like me to lift you
                once again?</q> Xojo asks. ";
            
            xojo.initiateConversation(nil, 'offer-boost');
        }
    }

    /* give the player a boost (in the elevator) */
    boostPlayerChar()
    {
        /* describe it */
        "Xojo bends down to let you climb onto his shoulders,
        which you manage to do with some awkwardness, then he
        shakily stands up.  This puts you in easy reach of the
        ceiling. ";

        /* if this is the first time, add a little something extra */
        if (boostCount++ == 0)
            "<.p><q>I hope you can see what a high-initiative employee
            I would be,</q> Xojo says, straining a bit under your weight. ";

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
    'cirriculum resume/r\u00E9sum\u00E9/cv/c.v./vitae/piece/paper'
    'r\u00E9sum\u00E9'
    "The format is slightly unusual, probably a matter of local
    conventions, but you don't have much trouble finding the important
    bits of information about Xojo's professional qualifications:
    a bachelor's degree in electrical engineering
    from Kowtuan Technical Institute; a year in an entry-level
    position with a semiconductor manufacturer called ChipTechNo;
    and two years here at Government Power Plant #6, rising from
    Junior Technical Administrative Rank 3 to Junior Administrative
    Technical Rank 7. "

    /* it's xojo's, no matter where it's located */
    owner = xojo

    /* take the resume before reading or examining it */
    dobjFor(Read) { preCond = (inherited() + [objHeld]) }
    dobjFor(Examine) { preCond = (inherited() + [objHeld]) }
;

++ AskTellTopic @magnxi
    "<q>What can you tell me about the Colonel?</q> you ask.
    <.p><q>I am taking you to her now,</q> he replies. "

    /* this is active as soon as we're on our way to see the colonel */
    isActive = (scu1100dx.isOn)
;

++ GiveTopic @xojoResume
    "You offer the r\u00E9sum\u00E9 back to Xojo, but he just waves
    his hands. <q>Please,</q> he says, <q>keep it for your eventual
    consideration.</q> "
;

++ DefaultCommandTopic
    "Xojo politely declines, saying his rank is too low to
    be of assistance in this manner. "

    isConversational = nil
;

++ AskTellTopic @xojo
    "<q>Tell me about yourself,</q> you say.
    <.p><q>I am here to assist you,</q> Xojo replies. "
;

++ AskTellShowTopic +90 @guanmgon
    "<q>Tell me about Guanmgon,</q> you say.
    <.p>Xojo pauses for a moment.  <q>He is very qualified to
    assist you,</q> he finally says. "
;

++ HelloTopic
    "<q>How may I assist?</q> Xojo asks. "
;

++ DefaultAnyTopic, ShuffledEventList
    ['<q>My superior, Guanmgon, would be better qualified than
    myself to assist you in this matter,</q> Xojo says. ',
    '<q>I must defer on such matters to my superiors,</q> Xojo says. ',
    'Xojo thinks for a moment. <q>Perhaps you should consult my superior,
    Guanmgon,</q> he says. '
    ]

    /* don't use an implied greeting with this topic */
    impliesGreeting = nil
;

++ AskTellTopic @contract
    "You know for a fact that Xojo is too far down in the bureaucracy to
    have anything to do with contracts. "

    /* we're not conversational, so don't use a greeting */
    isConversational = nil
;

++ GiveShowTopic @contract
    "There's no point in doing that; Xojo is about forty-five
    bureaucracy levels too low to have anything to do with contracts. "

    isConversational = nil
;

/* when asking about the SCU, change the response once we've fixed it */
++ GiveShowTopic @scu1100dx
    "You don't have anything to show him until you get it working. "

    isConversational = nil
;
+++ AltTopic
    "You'd love to give Xojo a full demo, but you really should go
    see Colonel Magnxi right away. "

    isActive = (scu1100dx.isWorking && scu1100dx.isOn)
    isConversational = nil
;

++ GiveShowTopic [ct22, s901, xt772hv, tester, testerProbe, xt772lv]
    "You think he'd really like to help, but it's become clear that
    all the bizarre red tape here prevents Xojo from actually doing
    anything that would resemble repair work. "

    isConversational = nil
;

++ AskTellShowTopic, SuggestedAskTopic [helicopter1, helicopter5]
    "<q>Do you know anything about those helicopters?</q> you ask.
    <.p><q>I am not sure,</q> he says, <q>but my superior, Guanmgon,
    intimated that a representative of Mitachron was to
    approach.  Perhaps the representative is performing arrival.</q> "

    isActive = (helicopter1.seen)

    /* suggestion name */
    name = 'the helicopters'
;

/* 
 *   the rope bridge - start with the generic response, then define some
 *   specific responses for asking about it in different locations 
 */
++ AskTellShowTopic [platformBridge]
    "<q>I really don't want to cross that rope bridge,</q> you say.
    <.p><q>It is our most expedient course,</q> Xojo
    says, <q>but perhaps we could wait for the repair of the
    elevator, if you prefer.</q> "
;

/* Rope Bridge response for when we're on the platform */
+++ AltTopic, StopEventList
    ['<q>Are you serious?</q> you ask. <q>You actually want to go across
    the rope bridge?</q>
    <.p><q>I am sorry,</q> he says, <q>but it the most expedient course.
    The only possibility of an alternative is awaiting the completion of
    repairs to the elevator.</q> ',
    '<q>Why is this thing even here?</q> you ask incredulously.
    <.p><q>The Peon Grade staff are not normally allowed to leave
    the sub-basement levels during the working hours,</q> Xojo says.
    <q>A group of sub-peons erected this in secret, to enable departure
    and later return without detection by superior staff functionaries.</q> ',
    '<q>This bridge doesn\'t look very safe,</q> you say.
    <.p><q>I have used it personally, during my own Peon Grade period
    of employment,</q> Xojo assures you. <q>Simply use caution to make
    the crossing relatively free of excess hazard.</q> ',
    '<q>You\'re really sure this is the only way across?</q> you ask.
    <.p><q>I am regrettably forced to respond in the affirmative,</q>
    Xojo says. ']

    isActive = (xojo.isIn(s2Platform))
;

/* Rope Bridge response for when we're starting across the bridge */
+++ AltTopic
    "<q>You're really sure this thing is safe?</q> you ask.
    <.p><q>I have crossed it several times,</q> he says. <q>Please,
    we should be quick.</q> "

    isActive = (xojo.isIn(ropeBridge1) || xojo.isIn(ropeBridge2))
;

/* Rope Bridge response after the bridge collapses */
+++ AltTopic
    "<q>You said this thing was safe!</q> you yell.
    <.p><q>Sorry,</q> Xojo says.  <q>I've only had this happen once
    or twice before.  Come, we can climb up from here.</q> "

    isActive = (xojo.isIn(ropeBridge3))
;

/* Rope Bridge response once we're past it */
+++ AltTopic
    "<q>I still can't believe you made me cross that rope
    bridge,</q> you say.
    <.p><q>Admittedly, the danger level was non-zero,</q> Xojo says. "

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
    specialDesc = "Xojo is watching you from the doorway. "
    specialDescListWith = [standingInDoorway]
    stateDesc = "He's been watching you attentively. "
;
++++ HelloTopic, ShuffledEventList
    ['You look over at Xojo.  <q>Excuse me...</q>
    <.p><q>How may I assist?</q> ',
     'You make eye contact.  <q>Yes?</q> he asks.<.p>',
     '<q>Xojo?</q>
     <.p><q>What can I do to help?</q> ']
;
++++ ByeTopic "<q>Thanks,</q> you say. Xojo nods. "
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
        "<q>Xojo! Go fetch Mr.\ Mittling some Koffee. Hurry!</q>
        Xojo rushes off through the door. ";

        /* we're done with the agenda item for the koffee */
        guanmgon.removeFromAgenda(koffeeAgenda);
    }
    endErrand()
    {
        "Xojo returns with a can of Koffee, and squeezes
        into the room long enough to hand it to you. ";
        
        koffee.moveInto(me);
    }
;

/* fetching Deet */
++ deetErrand: XojoErrandState
    beginErrand()
    {
        "<q>The mosquito insects are a nuisance for you,</q> Guanmgon
        says. <q>Xojo!</q> he yells. <q>Go fetch powerful insect repellent!
        Go now!</q>  Xojo walks off, muttering something. ";

        /* we're done with the dispatching agenda item */
        guanmgon.removeFromAgenda(deetAgenda);
    }
    endErrand()
    {
        "Xojo returns, lugging a suitcase-sized metal tank with a
        hose attached.  He turns a valve on the tank and points the
        hose into the room.  A misty spray issues from the hose, and
        the room is quickly filled with a cloud of noxious vapor.
        <.p>The mosquitoes carry on with their business unperturbed. ";

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
    endErrand = "Xojo returns and stands next to Guanmgon in the doorway. "
;

++ koffee: Food
    'koffee brand business (man\'s) aluminum aluminium 12-ounce 12 ounce
    beverage/koffee/coffee/can'
    'can of Koffee'
    "Yes, it's Koffee with a K: Koffee brand Business Man's Beverage,
    the 100% inorganic choice, packaged in a 12-ounce aluminum can.
    It seems that you run into this horrid ToxiCola Corporation product
    every time you visit a customer outside the US. "

    dobjFor(Taste) asDobjFor(Eat)
    dobjFor(Drink) asDobjFor(Eat)
    dobjFor(Eat) { action() { "You don't want Xojo to feel put out,
        so you manage to choke down a little.  It's as awful as ever. "; }}

    smellDesc = "It has a strong chemical odor, although nothing
        you can place exactly; paint thinner mixed with chlorine,
        perhaps, with just a hint of 3-methoxy-4-hydroxybenzaldehyde. "

    dobjFor(Pour)
    {
        preCond = [objHeld]
        verify() { }
        action() { "That would make a mess. "; }
    }
    dobjFor(PourInto) asDobjFor(Pour)
    dobjFor(PourOnto) asDobjFor(Pour)

    iobjFor(PutIn)
    {
        verify() { }
        check()
        {
            if (gDobj == xt772hv)
                "It'd be an interesting experiment, but the noxious
                fluid would probably just dissolve the chip, and it's
                still possible that you'll need it for something. ";
            else
                "Better not; who knows what the noxious fluid would
                do to {that dobj/him}. ";
            exit;
        }
    }

    cannotOpenMsg = 'No need; Xojo already opened it for you. '

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
    stateDesc = "He's waiting for you to accompany him. "
    showGreeting(actor) { "You already have Xojo's attention. "; }

    justFollowed(success)
    {
        local st;
        
        /* 
         *   if they made us follow them, it means they're not going where
         *   we're trying to guide them; let them know 
         */
        "He looks a little impatient.  <q>Please, this way.</q> ";

        /* make sure we're in the right state for the new location */
        st = instanceWhich(XojoEscortState, {x: x.stateLoc == xojo.location});
        if (st != nil)
            xojo.setCurState(st);
    }
;

/* waiting in the control room to escort us to the colonel */
++ xojoEscortControl: XojoEscortState
    stateLoc = powerControl

    stateDesc = "He's waiting for you to accompany him through the doorway. "
    specialDesc = "Xojo is waiting for you to accompany him through
                   the doorway. "
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
        "<q>Okay,</q> you say, <q>let's give it a try.</q> ";
        xojo.boostPlayerChar();
    }
;
+++ NoTopic
    "<q>No, thanks,</q> you say. <q>I'll try to think of something else.</q> "
;

/* ask about the elevator once broken */
++ AskTellShowTopic @elevatorTopic
    "<q>What's wrong with the elevator?</q> you ask.
    <.p><q>The elevator is sometimes faulty in halting as requested,</q>
    Xojo replies. <q>But no need for concern.  It reliably halts, in due
    course.</q> "

    isActive = (plantElevator.curFloor <= 2)
;
+++ AltTopic, SuggestedAskTopic, StopEventList
    ['<q>How can we get out of here?</q> you ask.
    <.p><q>Yes, our facility\'s very efficient department of vertical
    conveyance will soon observe our mishap, then to notify office of
    elevator rescue.  Many times before when I have been similarly
    detained in the elevators, the department responded within several
    hours only, in typical experiences. </q> ',

    '<q>Are you sure we can\'t find a way out of here?</q> you ask, hoping
    to avoid waiting for help---you definitely can\'t afford the <q>several
    hours</q> Xojo said that could take.
    <.p>Xojo shakes his head. <q>The standard procedure for such
    elevator mishaps is the waiting for rescue.</q> ']

    isActive = (plantElevator.isAtBottom)
    name = 'the elevator'
;
+++ AltTopic
    "<q>I'm glad we were able to get out of that elevator,</q> you say.
    <.p><q>Yes, your extrication plan was most well conceived
    and executed,</q> Xojo says. "
    isActive = (plantElevator.isAtBottom && me.hasSeen(atopPlantElevator))
;

++ ConvNode 'xojo-resume'
    npcGreetingMsg()
    {
        "Xojo clears his throat. <q>I was wondering,</q> he says,
        <q>if your fine company might consider myself for a position
        of employment.</q>  He produces a piece of paper and holds
        it out for you. <q>My r&eacute;sum&eacute;,</q> he says. <q>I
        would most appreciate your kind consideration.</q>
        <.topics><.reveal xojo-job> ";

        xojoResume.makePresent();
    }

    npcContinueList: StopEventList {
        ['<q>If anything is unclear on my r&eacute;sum&eacute;,</q>
         Xojo says, <q>I would be pleased to clarify.</q> ',
         '',
         '<q>I would appreciate the opportunity to be considered
         for opportunities with your wonderful company,</q> Xojo says. ',

         '',
         'Xojo looks at you expectantly. ',
         'Xojo watches you expectantly. '
        ]
    }
;

++ AskTellShowTopic +90 @xojoResume
    "<q>This is your r&eacute;sum&eacute;?</q> you ask.
    <.p><q>Yes,</q> Xojo says, <q>please allow me to clarify any
    questions you wonder about.</q> "
    isActive = (xojoResume.isIn(xojo))
;

++ TopicGroup
    isActive = (xojoResume.described)
;
+++ AskTellShowTopic, StopEventList @xojoResume
    ['<q>This looks very nice,</q> you say. <q>Is there anything more
     you wanted to mention about it?</q>
     <.p><q>Yes, perhaps it is useful to know that my rank, rank 7,
     is considered advanced for an employee of my duration.</q> ',
     
     '<q>Is there anything else about your r&eacute;sum&eacute; you wanted
     to add?</q> you ask.
     <.p><q>Thank you,</q> he responds, <q>but I believe it is
     inclusive.</q> ']
;
+++ AskTellTopic, SuggestedAskTopic, StopEventList @kowtuan
    ['<q>Forgive me,</q> you say, <q>but I haven\'t heard of your
    university before. Is it a good school?</q>
    <.p><q>Oh, yes,</q> Xojo says earnestly, nodding his head rapidly.
    <q>It is often known as the <q>MIT</q> of the tri-province region.
    The program is very rigorous.</q> ',

    '<q>Is there anything else about your university you can tell me?</q>
    <.p>Xojo replies, <q>The program is considered very excellent.</q> ']

    name = 'Kowtuan Technical Institute'
;
+++ AskTellTopic, SuggestedAskTopic, StopEventList @chipTechNo
    ['<q>Tell me about your job at ChipTechNo,</q> you say.
     <.p><q>It was an excellent experience of learning,</q> he says,
     <q>but the promotability was limited due to non-local ownership.</q> ',

     '<q>What did you do at ChipTechNo?</q> you ask him.
     <.p><q>My primary duties were in the chemical applicator
     operations,</q> he says.  <q>But this was only after
     considerable training and apprenticeship, of course.</q> ',

     '<q>Is there anything else about ChipTechNo you can tell me?</q>
     you ask.
     <.p><q>I believe you have the main facts now,</q> he says. '
    ]

    name = 'ChipTechNo'
;
+++ AskTellTopic, SuggestedAskTopic, StopEventList @powerPlant6
    ['<q>Why do you want to leave your job here at the plant?</q> you ask.
    <.p><q>As you have surely observed,</q> he says, <q>my duties are
    considerably variable, at the whim of my very capable superiors.
    This has provided many excellent opportunities for frustration.</q> ',

    '<q>Tell me more about your job at the plant,</q> you say.
    <.p><q>I feel my growth opportunities at the Government Power
    Plant are limited,</q> he says. <q>I would hope to find an
    opportunity that is more robust.</q> ',

    '<q>You\'re not happy with your job at the plant?</q> you ask.
    <.p><q>My happiness is perhaps less here than it might be elsewhere,</q>
    he says. ']

    name = 'the power plant'
;
+++ AskTellTopic, SuggestedAskTopic, StopEventList @guanmgon
    ['<q>Guanmgon seems to keep you busy,</q> you say.
    <.p><q>Yes,</q> Xojo says, looking a bit distant for a moment.
    <q>He is most capable at providing numerous small tasks of
    considerable import to himself.</q> ',

    '<q>Is Guanmgon a good manager?</q> you ask.
    <.p><q>He is undoubtedly assigned the role of manager,</q>
    Xojo replies. ']

    name = 'Guanmgon'
;

++ TellTopic, SuggestedTellTopic, StopEventList @hiringFreezeTopic
    ['<q>I\'m sorry to say that there\'s a hiring freeze at Omegatron
    right now,</q> you explain.  <q>That means we can\'t hire anyone.</q>
    <.p>Xojo can\'t quite conceal his disappointment. <q>Oh.  Well,
    perhaps in the future, then.</q>  You shrug slightly and
    nod noncommittally. ',

    '<q>Sorry about the hiring freeze,</q> you say.
    <.p><q>Oh, that is not your fault,</q> Xojo says. <q>Still, it
    is unfortunate.</q> ']

    name = 'the Omegatron hiring freeze'
    isActive = gRevealed('xojo-job')
;

/* waiting at the east end of the hallway to escort us */
++ xojoS2West: XojoEscortState
    stateLoc = s2HallWest

    arrivingWithDesc = "Xojo points down the hall. "
    stateDesc = "He's waiting for you to accompany him down the hall
                 to the east. "
    specialDesc = "Xojo is waiting for you to follow him down the
                   hall to the east. "
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

    stateDesc = "It seems to you that Guanmgon has grown increasingly
                 nervous as your work here has dragged on; lately he's
                 become almost frantic. "
    specialDesc = "Guanmgon is watching from the doorway, craning his
                   neck to see what you're doing. "
    specialDescListWith = [standingInDoorway]

    /* our background script steps */
    eventList =
    [
        nil,
        &initKoffee,
        'Guanmgon taps his fingers on the wall. <q>No reason for panic,</q>
        he says to himself. <q>Success is still possible.</q> ',
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
        "Guanmgon tiptoes into the room, trying to find a path through
        the clutter, but he bumps something and knocks a pile of equipment
        onto the floor.  <q>Sorry, sorry!</q> he whispers.  He hastily
        puts everything back as it was and works his way back to the
        doorway. ";
    }
    initDeet()
    {
        /* add the item for fetching deet */
        guanmgon.addToAgenda(deetAgenda);
    }
;
++ HelloTopic, ShuffledEventList
    ['You glance over at Guanmgon.  As soon as you make eye contact,
    he eagerly leans into the room.  <q>I am to your service,</q>
    he says. ',
     'Guanmgon sees that you\'re about to speak.  <q>Whatever you need,
     it is I who is here to provide,</q> he says nervously. ',
     'You look over at Guanmgon and clear your throat.  <q>I am
     here to be of help,</q> he says. ']
;
++ ByeTopic "<q>Thanks,</q> you say. Guanmgon nods. "
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
        "<q>Do you need anything?</q> Guanmgon asks. <q>Perhaps some
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
        "<.p>Guanmgon waves his hand to clear the air around him.
        <q>Xojo! You must not keep the powerful insect repellent
        vessel for so long, for our cost account will receive the
        excess internal late fee! Go quickly to return the vessel!</q>
        Xojo lugs the tank away. ";

        /* start the tank return errand */
        xojo.beginErrand(tankReturnErrand);
    }
;

++ ConvNode 'Koffee?'
    npcContinueMsg()
    {
        /* start the errand */
        "<q>Yes, Koffee is just what you need,</q> Guanmgon says.
        <.convnode> ";

        /* send xojo off for Koffee */
        xojo.beginErrand(koffeeErrand);
    }
;
+++ YesTopic
    topicResponse()
    {
        "<q>Sure, thanks,</q> you say.<.p> ";
        xojo.beginErrand(koffeeErrand);
    }
;
+++ NoTopic
    topicResponse()
    {
        "<q>No, thanks, that's okay,</q> you say.  You want nothing to
        do with that Koffee stuff.
        <.p><q>Yes, I insist,</q> Guanmgon says, <q>I would be pleased to
        bring you some.</q> He turns to Xojo. ";
        
        xojo.beginErrand(koffeeErrand);
    }
;
+++ AskTellAboutForTopic @koffee
    topicResponse()
    {
        "<q>Do you mean Koffee with a K?</q> you ask.
        <.p><q>Yes, of course,</q> Guanmgon says. ";

        xojo.beginErrand(koffeeErrand);
    }
;


/* 
 *   while guanmgon is on the phone, he's a "hermit" - he doesn't respond
 *   to any conversational commands 
 */
++ guanmgonOnPhone: HermitActorState
    stateDesc = "He's currently talking to someone on his cell phone. "
    specialDesc = "Guanmgon is talking to someone on his cell phone. "

    /* don't respond to any conversation while on the phone */
    noResponse = "You don't want to disturb him while he's on the phone. "
;

++ DefaultCommandTopic
    "Guanmgon politely declines, explaining that, much as he'd like
    to help, administrative rules prohibit someone of his high rank
    from assisting in this manner. "

    isConversational = nil
;

++ AskTellAboutForTopic @koffee
    "<q>Do you have any coffee around here?</q> you ask.
    <.p>Guanmgon smiles and nods. <q>Koffee, yes.</q> "
;
+++ AltTopic
    "<q>You wouldn't have any real coffee, with a C, would you?</q>
    <.p><q>We have the very delicious Koffee with a K kind only,</q>
    Guanmgon says, nodding. "
    isActive = (koffee.location != nil)
;

++ AskTellShowTopic [mosquitoes, deetCloud]
    "<q>There are sure a lot of mosquitoes around here,</q> you
    say, stating the obvious.
    <.p><q>Mosquitoes, many, yes,</q> Guanmgon says, laughing
    nervously. "
;
+++ AltTopic
    "<q>I don't think the insecticide is working,</q> you say,
    swatting another mosquito.
    <.p>Guanmgon laughs nervously.  <q>We must be patient in the
    extreme, and trust that working will eventually occur, just
    as with the very nice SCU product.</q> "

    isActive = (deetCloud.location != nil)
;

++ AskTellTopic @contract
    "Guanmgon is only a mid-level functionary; he doesn't know anything
    about contract matters. "

    isConversational = nil
;

++ GiveShowTopic @contract
    "There's no point; Guanmgon is only a mid-level functionary, not
    the sort of deluxe grand high administrator who could help you
    with a contract matter. "

    isConversational = nil
;

/* change the response once we fix the SCU */
++ GiveShowTopic @scu1100dx
    "You don't have anything to show him until you get it working. "

    isConversational = nil
;
+++ AltTopic
    "Guanmgon looks a little busy; besides, you're in a hurry to
    see the Colonel. "
    isActive = (scu1100dx.isWorking && scu1100dx.isOn)
;

++ GiveShowTopic [ct22, s901, xt772hv, tester, testerProbe, xt772lv]
    "It's been made clear that Guanmgon is here for administrative,
    not technical, support. "

    isConversational = nil
;

++ AskTellTopic, SuggestedAskTopic @phoneCallTopic
    "<q>Do you mind my asking what that call was about?</q> you ask.
    <.p><q>Call?  What call?  Oh, yes, it was nothing.  No need for
    concern at all.  It will be fine.  No reason for panic.  Yes, there
    was just a slight mention of a representative of the Mitachron
    company, possibly arriving, possibly today.  I am sure this is no
    reason for worrying.</q>  He pretends to smile broadly. "

    /* this topic isn't meaningful until after the phone call */
    isActive = (guanmgon.didGetCall)

    /* suggestion name */
    name = 'the phone call'
;

++ guanmgonChecking: HermitActorState
    stateDesc = "He's busily checking the equipment. "
    specialDesc = "Guanmgon is here, busily checking the equipment. "

    noResponse = "He seems busy, and besides, you're in a bit of
                 a hurry to see the Colonel. ";
;

++ AskTellTopic @guanmgon
    "<q>How's it going?</q> you ask.
    <.p><q>Oh, well, very fine, thank you,</q> Guanmgon says. <q>We will
    soon have this assignment complete, I am certain.</q> "
;

/* 
 *   A pair of topics about Mitachron.  The first is known from the start;
 *   the second one becomes available only after the phone call.
 */
++ AskTellTopic, SuggestedAskTopic @mitachronTopic
    "<q>What do you know about Mitachron?</q> you ask.
    <.p><q>Nothing!</q> he rushes to say. <q>Certainly, your very
    wonderful SCU-1100DX is far superior to the similiar offerings
    that this other company provides.  No need exists for worrying about
    that company!  I am sure we can be successful at completing this
    assignment, so there will be no motivation for considering
    alternatives.</q> "

    /* suggestion name */
    name = 'mitachron'
;
+++ AltTopic, SuggestedAskTopic
    "<q>Have you heard anything about Mitachron?</q> you ask.
    <.p><q>No!</q> he replies.  <q>Only on my phone call, and just a
    small mention, very brief, probably not important.  Something about
    a representative of that company arriving, that is all it was.
    I am sure we will be successful before any reason to worry arises.</q> "

    isActive = (guanmgon.didGetCall)
    name = 'mitachron'
;

++ AskTellTopic [omegatronTopic, me]
    "<q>What do you think about Omegatron so far?</q> you ask.
    <.p><q>Excellent, very good,</q> he says, nodding rapidly. <q>I am
    sure we can be successful.  I am impressed especially with how
    very greatly challenging you have made this project appear.</q> "
;

++ AskTellShowTopic [ct22, xt772hv, xt772lv]
    "You really don't think Guanmgon knows much about
    the inner workings of this equipment. "

    isConversational = nil
;

/* 
 *   if we haven't found the xt772-lv yet, override the more general
 *   answer about the equipment - use an elevated score to override other
 *   answers 
 */
++ AskTellAboutForTopic +110 @xt772lv
    "Not knowing where else to turn, you ask Guanmgon if he
    has any idea where you can find the chip you need.
    <q>No, sorry, we do not have anything of this kind,</q> he
    says.  <q>Perhaps we can order it on the internet web?  But
    that would take too long.  We must be successful with our
    assignment much too soon for that!</q> "

    /* this one is used only if we haven't already found the xt772-lv */
    isActive = (!xt772lv.isFound)
;

++ AskTellTopic @magnxi
    "<q>What can you tell me about Colonel Magnxi?</q> you ask.
    <.p><q>The Colonel?</q> he says, getting flustered. <q>There's
    no need to talk to the Colonel!  I have great confidence in
    our success with this assignment.  Very great confidence!</q> "
;

/* 
 *   a pair of topics about the SCU - which one we get depends on whether
 *   or not we've fixed it yet 
 */
++ AskTellShowTopic @scu1100dx
    "<q>How do you like the SCU-1100DX so far?</q> you ask.
    <.p><q>Very wonderful!</q> he says. <q>It will be more wonderful
    when it is working, certainly, but it is very wonderful already.</q> "
;
+++ AltTopic
    "<q>How do you like the SCU-1100DX so far?</q> you ask.
    <.p><q>I am relieved very much to see that your excellent product
    has begun functioning properly,</q> he says. <q>Very, very, very
    relieved.</q> "

    isActive = (scu1100dx.isWorking && scu1100dx.isOn)
;

++ AskTellShowTopic @xojo
    "<q>Tell me about Xojo,</q> you say.
    <.p><q>Xojo is here to assist you,</q> he says. <q>I hope he has
    been adequate in his assistance.  There has been no mistake in
    assigning him, I am sure.  He is most capable.</q> "
;

++ AskTellTopic @powerPlant6
    "<q>What else can you tell me about the power plant?</q>
    you ask.
    <.p><q>I am very committed to its proper operation!</q> he
    says.  <q>Yes, I very much like it here.</q> "
;

++ DefaultAskTellTopic, ShuffledEventList
    ['Guanmgon doesn\'t seem to understand the question. ',
    'Guanmgon smiles but does not respond. ',
    '<q>I am sorry,</q> Guanmgon says, <q>perhaps
    I could answer a different question?</q> ']
;     
    
++ Decoration 'cell cellular phone/telephone/cellphone' 'cell phone'
    "You're as technophilic as the next engineer, but really, you
    haven't been very impressed by devices that can play synthesized
    music with square waves since the early PC days. "
;

/*
 *   Decorations for the control room equipment.  Decorations are objects
 *   that exist for descriptive purposes only, and generally have no other
 *   function in the game.  The default response of a decoration to any
 *   action is to say "that's not important," to make it clear to the
 *   player that they shouldn't waste any time trying to figure out the
 *   object's purpose.  We customize some of these decorations (via
 *   notImportantMsg) with more specific responses, but the gist is the
 *   same.  
 */
+ Decoration '(power) (plant) equipment/systems/pile' 'equipment'
    "It's the usual complement of breaker panels, gauges, load
    control boards, and internal comm systems that you'd expect
    to find in any plant built in the 1960s.  Right now it's all
    opened up and taken apart, thanks to your efforts to integrate
    the 1100DX into the existing systems. "
    notImportantMsg = 'You\'ve already jury-rigged it pretty
                       thoroughly; it\'d probably be best not to
                       mess with it now that things are nearly working. '

    /* 
     *   It's the power plant's systems.  Setting 'owner' like this
     *   explicitly means that the player can refer to this using a
     *   possessive that refers to the owner, as in "the plant's
     *   equipment" or "the power plant's systems". 
     */
    owner = powerPlant6
;

+ Decoration 'breaker panel/panels/switch/switches/breakers' 'breaker panels'
    "There are dozens of breaker switches controlling the distribution
    of power out of the generators and providing some protection against
    overloads. "
    isPlural = true
    notImportantMsg = 'That\'s not your domain; best to leave it alone. '
;

+ Decoration 'power levels/gauge/guage/gauges/guages/voltages/amperages'
    'gauges'
    "The gauges show voltages, amperages, and power levels for the many
    circuits. "
    notImportantMsg = 'You should probably leave the gauges alone. '
    isPlural = true
;

+ Decoration 'load control board/boards/panel/panels' 'load control boards'
    "These controls adjust the power generation capacity to match the
    load.  Every day you've been here, technicians have interrupted you
    several times to adjust these settings. "
    notImportantMsg = 'The controls are all delicately balanced; you
                       definitely don\'t want to touch them. '
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
    "The comm system lets the operators talk to technicians in other
    parts of the plant. "
    notImportantMsg = 'Best to leave the comm systems alone. '
    isPlural = true
;

/* 
 *   Mosquitoes.  These are purely a decoration, but we mention them a lot
 *   in the room's atmospheric messages, so it's good to be able to refer
 *   to them. 
 */
+ mosquitoes: Decoration
    'mosquito/mosquitos/mosquitoes/fly/flies/bug/bugs/insect/insects'
    'mosquitoes'
    "They're incessant. "
    isPlural = true
    notImportantMsg = 'The mosquitoes are extremely annoying, but
                       they\'re not important. '
    dobjFor(Attack)
    {
        verify() { }
        action() { "It's futile; there are more bugs in this
            room than in the SCU-1100DX. "; }
    }
    dobjFor(Take)
    {
        verify() { }
        action() { "Try as you might, you can't catch any of them. "; }
    }
;

/* the SCU-1100DX */
+ scu1100dx: TestableCircuit, Immovable, OnOffControl
    'omegatron supplemental control unit model big metal
    box/scu/1100/1100dx/scu-1100/scu-1100dx/scu1100/scu1100dx'
   'SCU-1100DX'
    "An Omegatron Supplemental Control Unit model 1100DX.  You ought
    to know it like the back of your hand after sitting through all
    of those engineering meetings and design reviews, but the extensive
    cost-cutting and jury-rigging in the manufacturing process
    changed it into something strangely unfamiliar.
    <<isOn ? "Fortunately, you finally managed to get it working. "
           : "Regardless, your job is to get it working. " >>
    <.p>
    The 1100 is essentially a big metal box open on one side, like a
    refrigerator without a door (and about the same size), filled
    with stacked electronics modules.  Bundles of wires and cables connect
    the modules to the control boards and other plant equipment.
    It's currently powered <<onDesc>>.
    <<isWorking ? "" :
    "<.p>There's one empty slot, which is where the CT-22 module you
    removed goes." >> "

    /* customize the messages for various ways of trying to move me */
    cannotTakeMsg = 'Are you kidding? It\'s the size of a refrigerator,
                     and it weighs as much as a car. '
    cannotMoveMsg = 'There\'s no room to move it anywhere. '
    cannotPutMsg = 'It\s far too heavy. '

    /* keep track of when I start working */
    isWorking = nil

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
    'empty module slot' 'empty slot'
    "It's the slot where the CT-22 diagnostic module goes. "

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
    'ct ct-22 ct22 diagnostic module' 'CT-22 diagnostic module'
    "<< xt772lv.isIn(self)
    ? "It's the diagnostic module that's responsible for many of
    your woes here.  Fortunately, it seems at last to be repaired: an
    XT772-LV chip is installed in the module's S901 socket. "
    : "This module is a big part of why this job has taken
    so long.  The CT-22's function is to diagnose errors and defects
    in the other modules; naturally, it turned out be defective
    itself.  It was working just well enough to send you on weeks
    of wild goose chases fixing the fake problems it reported in
    other modules.  Once it occurred to you to take it out and check its
    own operation with your circuit tester, you quickly found the problem:
    manufacturing installed the wrong chip in one of the key circuits.
    They installed an XT772-HV, the high-power version, when they should
    have installed the low-power version, the XT772-LV.  The voltage
    sensitivity differences made for all sorts of false error readings.
    Unfortunately, the CT-22 is a critical component of the SCU, so
    you can't just leave it out. ">>
    << xt772hv.isIn(self)
    ? "<.p>The errant XT772-HV chip is currently seated in the module's
    S901 socket. "
    : xt772lv.isIn(self)
      ? "" : "<.p>The module's S901 socket is current empty. " >> "

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
                "You already have! ";
            else if (gActor.canSee(xt772lv))
            {
                "A simple matter of putting the XT772-LV in the socket. ";
                nestedAction(PutIn, xt772lv, self);

                if (xt772lv.isIn(self))
                    "Done. ";
            }
            else
            {
                "That would be trivial if you had an XT772-LV chip. 
                Without one, there's no obvious fix. ";

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
    'errant xt772 hv xt772-hv high-power high power chip/version'
    'XT772-HV chip'
    "It's a high-power version of the XT772 chip.  It's the right kind
    of chip for most of the other modules, but the wrong kind for the
    CT-22. <<xt772lv.isIn(nil)
    ? "Unfortunately, this is a spare part you didn't think to
    bring, and it could take several days to get one shipped here. "
    : "" >> "

    /* 
     *   override the 'aName', because the standard rules that figure out
     *   whether to use 'a' or 'an' can't handle this kind of weird
     *   special case 
     */
    aName = 'an XT772-HV chip'

    /* it's small; make it pocketable */
    okayForPocket = true
;

+ TestableCircuit, Decoration
    'bundle/bundles/wire/wires/cable/cables' 'wires'
    "The wires and cables connect the SCU-1100DX to the power plant's
    systems.  You've spent the last six weeks figuring out where
    everything goes with a certain amount of trial and error, so
    the wiring is a bit of a mess, but you think everything is mostly
    where it should be at this point. "
    notImportantMsg = 'It took you six weeks to get the wiring set up just
                       right.  You\'re not about to mess with it now. '
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
+ tester: ComplexContainer 'mitachron dynatest multi-function circuit tester'
    'circuit tester'
    "This is your Mitachron DynaTest multi-function circuit tester.
    You're always a little embarrassed that one of your main
    day-to-day engineering tools is made by your chief competitor, but
    Omegatron has never had much luck fielding its own products in this
    market segment.  The tester is about the size of a car battery; its
    main features are a probe and a small display screen, plus the usual
    collection of warning stickers on the back cover.  It's currently
    turned off. "

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
            "The tester isn't designed to test {that iobj/him}. ";
        else if (scu1100dx.isWorking)
            "No need; the SCU is already fixed. ";
        else
            "You've already narrowed down the problem, or at least
            the latest problem, to the CT-22.  No need to do more
            testing until you figure out how to fix that. ";
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

++ Component '(circuit) (tester) flat panel flat-panel display screen/display'
    'tester display'
    "It's a small flat-panel screen, where the tester displays
    its readings.  The screen is currently blank. "
;

++ testerProbe: ComponentDeferrer, Component
    '(circuit) (tester) electrical (coax) (coaxial)
    probe/set/contacts/cable' 'probe'
    "It's the set of electrical contacts, connected to the tester by
    a coaxial cable, that you attach to the circuit you want to
    test. "

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
                "There's no obvious way to do that. ";
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
            "Better not; that would probably ruin {the iobj/him}. ";
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
    "It's designed to provide service access to the unit's internal
    components, and has the usual warning stickers.
    <<testerInterior.isOpen ? "It's currently open." : "">> "

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
plantCourtyard: OutdoorRoom 'Courtyard' 'the courtyard'
    "A sizable area of jungle has been cleared to form this courtyard.
    The vast main administrative office building wraps around the north
    and east sides of the area, and low wooden fences keep the jungle
    at bay to the south and west.  A narrow path leads southwest
    into the jungle.  A set of doors to the east leads into the building.
    <.p>Several helicopters---you count five---are parked here, rotors
    still spinning lazily.  Dozens of people wearing black Mitachron-logo
    polo shirts are busily dashing around, many carrying boxes or crates. "

    vocabWords = 'courtyard'

    in = adminDoorExt
    east asExit(in)
    southwest = courtyardPath

    atmosphereList: ShuffledEventList {
        ['The Mitachron people are here in force, all right; all of
         this activity must be to set up an instant demo.  It\'s
         a very good thing you let Xojo take you across that rope
         bridge after all; if it had taken any longer to get here,
         they might actually have been able to steal this deal away
         from you.  Luckily, it looks like you got here in time. '
        ]
        ['One of the Mitachron people almost bumps into you with
         something that looks like a bag of golf clubs, but you
         manage to jump out of the way. ',
         'A Mitachron woman with a clipboard zips past, saying
         something into her headset about ice. ',
         'Two Mitachron men shuffle by carrying an apparently very
         heavy metal create that reminds you of a steamer trunk. ',
         'The Mitachron employees busily carry things in and out
         of the helicopters. ',
         'Several Mitachron workers hustle by carrying some heavy
         piece of equipment. ']
    }
;

+ courtyardPath: PathPassage 'narrow path' 'path'
    "The path leads southwest into the jungle. "
;

+ Distant 'lush tropical jungle/plant/plants/vegetation/overgrowth' 'jungle'
    "The vegetation is lush, tropical, and mostly unfamiliar to you. "
;

+ Decoration 'low wood wooden fence/fences' 'wooden fence'
    "The fences mark the boundaries of the courtyard to the south
    and west.  The jungle lies beyond. "
;

+ Decoration
    'five black mitachron helicopters/choppers/copters' 'helicopters'
    "They're all identical: each is all black, except for the yellow
    Mitachron logo on the tail. "

    isPlural = true
    notImportantMsg = 'You don\'t want to get too close to the
                       helicopters; the Mitachron people might
                       not take kindly to an Omegatron employee
                       snooping around. '
;
++ Decoration 'helicopter rotor/rotors' 'rotors'
    "The rotors are still spinning lazily, as though the pilots were
    keeping the choppers ready for a sudden departure. "
;
++ Decoration 'helicopter yellow mitachron tail/tails' 'helicopter tails'
    "The tail of each helicopter is painted with the Mitachron logo. "
    isPlural = true
;

+ Decoration 'yellow mitachron logo' 'mitachron logo'
    "The Mitachron logo is a big yellow <q>M</q> in a heavy sans-serif
    action-slant font, superimposed over a light yellow outline of a
    globe.  You've always thought it symbolizes Mitachron world
    domination. "
;

+ Decoration
    'mitachron-logo polo employee/employees/worker/workers/shirt/shirts/
    people/man/woman*men women'
    'mitachron people'
    "The Mitachron people are all walking fast and purposefully,
    expressions of earnest resolve on their faces.  They seem hurried
    but not frantic, like they know exactly what they're doing but
    they don't have any time to waste.  Most are carrying boxes
    or crates, and a few are carrying clipboards and directing the
    others. "

    isPlural = true
    notImportantMsg = 'You can\'t seem to get anyone\'s attention. '
;
++ Decoration 'box/crate/boxes/crates/clipboards/handsets/trunk/equipment'
    'Mitachron stuff'
    "The things they're carrying are of little interest to you,
    except that all of this is probably for an instant demo, which
    you'd like to preempt if possible. "
    isMassNoun = true
;

+ Enterable 'vast main administrative administration office buildings'
    'main administrative building'
    "The building is huge: it runs hundreds of feet south to north,
    then turns a corner and runs hundreds more feet east to west.
    A set of doors to the east leads inside. "

    connector = adminDoorExt
;
+ adminDoorExt: Door ->adminDoorInt
    'main administrative office building door/doors/set'
    'administration building doors'
    "The doors lead into the building to the east. "

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

