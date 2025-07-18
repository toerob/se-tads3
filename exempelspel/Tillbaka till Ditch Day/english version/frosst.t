/*
 *   Copyright 2003, 2013 Michael J. Roberts
 *   
 *   Return to Ditch Day - Frosst Belker.  Frosst is a fairly substantial
 *   NPC, so it's convenient to give him his own, separate source module.  
 */

#include <adv3.h>
#include <en_us.h>


/* ------------------------------------------------------------------------ */
/*
 *   Frosst Belker 
 */
frosst: Person 'frosst belker/man*men' 'Belker'
    "He's a slight man of medium height and rather pale complexion.
    You have a hard time guessing how old he is; he looks like he
    could be anywhere from twenty-five to forty-five.  He's dressed
    in white slacks and a white double-breasted jacket. "
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

+ InitiallyWorn 'white double-breasted breasted jacket/coat'
    'white double-breasted jacket'
    "It's an immaculately tailored double-breasted white suit coat. "
    isListedInInventory = nil
;

+ InitiallyWorn 'white slacks/pants' 'white slacks'
    "It's a well-tailored pair of white dress slacks. "
    isPlural = true
    isListedInInventory = nil
;

+ frosstCellPhone: PresentLater, Thing 'cell phone' 'cell phone'
    "It's small enough that it must be a recent model, but you
    can't really get a good look at it while he's using it. "

    /* 
     *   don't list in inventory, as we'll mention the phone specially
     *   while it's in use 
     */
    isListedInInventory = nil
;

+ PresentLater, Container
    'mitachron logo large black plastic shopping bag' 'plastic bag'
    "It's a large plastic shopping bag with the Mitachron logo on
    the side. "

    plKey = 'logo-wear'
;

+ ActorState
    isInitState = true
    stateDesc = "He's standing here with an amused expression. "
    specialDesc = "Frosst Belker is standing here.  He has an amused
                   expression. "
;
++ DefaultAnyTopic
    "Belker just ignores you and looks over toward the woman
    on the phone. "
;

+ frosstTalking: ActorState
    stateDesc = "He's here talking with Ms.\ Dinsdale. "
    specialDesc = "Frosst Belker is here, talking with Ms.\ Dinsdale. "
;
++ DefaultAnyTopic
    "He glances over at you, but ignores you and turns back
    to Ms.\ Dinsdale. "
;

+ goingToStack: HermitActorState
    stateDesc = "He's walking briskly, and talking to someone
        on a cell phone. "
    specialDesc = "Frosst Belker is walking briskly through while
        talking to someone on a cell phone. "
    noResponse = "Belker just ignores you and keeps walking. "
    soundDesc = "He's talking too quickly and quietly; you can't
        make out what he's saying. "

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
    stateDesc = "He's pacing around in little circles, talking
        rapidly into his cell phone. "
    specialDesc = "Belker is here, pacing in little circles
        as he talks into his cell phone. "
    noResponse = "He just ignores you and keeps talking into his phone. "
    soundDesc = "He's talking too quickly and quietly; you can't
        make out what he's saying. "
;

+ frosstUnpacking: HermitActorState
    stateDesc = "He's standing in the middle of the swarm of
        movers directing their movements. "
    specialDesc = "Belker is standing in the middle of the swarm
        of movers, pointing and issuing orders. "
    noResponse = "He pays no attention to you as he orders the
        movers around. "
    soundDesc = "He's just issuing orders to the movers&mdash;put
        this here, put that there, move this, unpack that. "

    alley1Atmosphere: ShuffledEventList { [
        'A mover with a huge box negotiates his way around you, forcing
        you to press yourself against the wall for a moment. ',
        'A mover comes up behind you with a crate, waits for you
        to get out of the way, then goes past. ',
        'A couple of movers come through with a crate that barely fits
        the alley\'s width.  You have to duck down and let them carry it
        over your head. ',
        'One of the movers drops a crate to the floor with a crash.
        Belker looks over.  The mover picks up the crate and keeps going. ',
        'A mover goes past carrying a round box. ',
        'You have to stand aside as a couple of movers carrying
        large boxes try to get by you. ',
        'One of the departing movers bumps shoulders with you, but just
        keeps going past without even glancing at you. ']
        
        eventPercent = 75
    }
;

/* 
 *   Frosst's state while initially figuring out the stack: his gang of
 *   technicians is using the MitaTest Pro 3000 to reverse-engineer the
 *   black box. 
 */
+ frosstSolving: HermitActorState
    stateDesc = "He's slowly pacing, closely watching his technicians
        as they operate the test equipment. "
    specialDesc = "Belker is slowly pacing back and forth, supervising
        the technicians as they operate the test equipment. "
    noResponse = "He glances at you, but goes back to his pacing
        without responding. "

    alley1Atmosphere: ShuffledEventList { [
        'The technicians continue to tend to the MegaTester 3000.',
        'Belker confers with one of the technicians for a few moments.',
        'Three of the technicians gather around one of the MegaTester
        monitors and talk to one another excitedly.',
        'A loud alarm bell sounds from the MegaTester, and the technicians
        start slapping at the controls in a panic.  They manage to stop
        the alarm after a few seconds.',
        'The technicians busily adjust controls on the MegaTester.',
        'A couple of the technicians tending the MegaTester switch places,
        forcing them to squeeze past each other in the narrow space
        alongside the machine.',
        'One of the technicians gets on his hands and knees and looks
        carefully under the table with the black box.  He gets up and
        returns to the MegaTester after a minute.',

        /* 
         *   include the special sub-list - we'll get a special message
         *   each time we run this entry 
         */
        testOpsSubList,
        
        'A technician holds out a wand-like apparatus connected by a
        thick cable to the MegaTester, running it slowly around the
        outside of the black box.  After a couple of passes around
        the box, he returns to the MegaTester and puts away the wand.',
        'Belker speaks in hushed tones to a couple of the technicians.',
        'Belker gets out his phone, says a few words into it, and returns
        it to his pocket.',
        'One of the technicians calls out a few numbers.',
        'The MegaTester starts emitting a deep, rumbling sound.  You can
        feel it in the floor and you can see the walls shaking.  Ten
        seconds later the sound abruptly stops.',
        'Several of the technicians switch places on the MegaTester,
        squeezing past one another in the crowded hallway. ',
        'A bright, erratic light like the sparks from a welding torch
        flashes from somewhere behind the MegaTester for several moments.',

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
    stateDesc = "He's walking around slowly, watching the technicians
        operate the computer. "
    specialDesc = "Belker is walking around slowly, supervising the
        technicians. "
    noResponse = "He ignores you, his attention fixed on the technicians. "

    alley1Atmosphere: ShuffledEventList { [
        'The technicians make adjustments on the computer. ',
        'Belker confers quietly with one of the technicians for a
        few moments. ',
        'A couple of the technicians trade places on the Mitavac. ',
        'The Mitavac\'s throbbing seems to get louder. ',
        'The Mitavac beeps softly a few times, and one of the
        technicians reacts by making several rapid adjustments. ',
        'One of the technicians points something out to Belker,
        who nods and returns to his pacing. ',
        'Belker leans in between two of the technicians and makes
        an adjustment to the computer. ',
        'The Mitavac\'s throbbing seems to get a little quieter. ']

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
                "You notice Belker is watching you. <q>This dialing
                of yours, it seems quite pointless,</q> he says.  <q>But
                perhaps you have a reason to manipulate this device while
                it is inertly <<
                  signalGen.isOn ? 'turned off' : 'disconnected'>>.</q>
                One of the technicians attracts his attention and he
                turns away. ";
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
    ['<q>Clear!</q> someone shouts.  The technicians all rush to the
     end of the hall and huddle with their backs to the MegaTester,
     which is making a sound like a jet engine starting up.  The sound
     abruptly stops, and nothing happens for several moments, then
     the hall fills with a flash of blinding light for an instant.
     Everything seems to turn dark blue with yellow spots.  You blink
     and squint, and your vision gradually returns to normal, by which
     time the technicians are back at their stations like nothing
     happened.',

     'All of the monitors on the MegaTester start flashing in unison,
     in a blue-white-blue-white pattern that repeats several times.
     The technicians furiously pound at the controls, and the monitors
     return to normal.',

     'Two of the technicians approach the black box, dragging
     cables from the MegaTester.  They carefully attach the
     elaborate connectors on the cables to the connector on
     the black box, then give some sort of hand signal to the
     other technicians, who punch busily at the MegaTester
     controls.  The operators at the controls finally stop
     and give another hand signal to the technicians with the
     cables, who detach their cables and retract them back
     into the MegaTester. ',
     
     '<q>Prepare for reboot!</q> one of the technicians shouts.  All
     of the technicians stand back from the MegaTester and hold up their
     arms to cover their eyes.  The MegaTester makes a sound like a
     camera flash charging, a whine that climbs in pitch until it\'s
     too high to hear; then rumbles like distant thunder.  The
     MegaTester plays a little piezo-electric <q>welcome</q> tune, and
     the technicians drop their poses and return to the controls.',
     
     'A technician goes up to the black box with what looks
     like a simple voltmeter.  She delicately touches the
     connector pins one at a time with the voltmeter contacts,
     watching the meter intently.  She returns to the MegaTester
     as soon as she\'s done. ',

     'Someone yells <q>Clear!</q> The technicians rush behind the
     MegaTester and huddle with their backs to it.  You remember
     the last time this happened, so you tightly shut your eyes and
     cover them with your hand.  Just like last time, a jet-engine
     screech fills the alleyway, then goes quiet.  You wait for
     the flash.  Nothing for a really long time.  Then something
     happens, but it\'s not a flash of light---it\'s some kind of
     ghostly glow that goes right through your hand and right through
     your eyelids, and for a moment you see everything around you
     in a near-black photo-negative, the bones in your hand black
     against a not-quite-black alley wall, diffuse black outlines of
     the huddled technicians in the corner, glowing black gears and
     wheels inside the MegaTester, Belker\'s bright black cell phone
     hanging in mid-air alongside his glowing black skeleton.  The
     X-ray vision fades and you feel a blast of heat on your face
     and the hand that\'s still in front of your eyes.  You cautiously
     peek through your fingers and see that the technicians are all
     back at their stations.',

     'Two of the technicians come over and carefully look all around
     the box, then go back to the MegaTester. ']
;


+ frosstAlleyConv: InConversationState
    specialDesc = (stateDesc)
    stateDesc = "Belker is standing in the alley watching you. "

    /* don't time out of this conversation */
    attentionSpan = nil
;
+ ConvNode 'meet-xojo'
    npcGreetingMsg = "<.p><q>Ah, Mr.\ Mittling.</q> You look over
        and see that Frosst Belker has come up alongside you.
        <q>Have you previously made acquaintance with, er, um...</q>
        <.p><q>Probationary employee 119297, sir,</q> Xojo says
        sheepishly, cringing like Belker's going to slap him.
        <.p><q>Yes, of course.  So, I take it you two know one
        another?</q> "

    noteLeaving()
    {
        /* end the conversation with both Frosst and Xojo */
        frosst.endConversation();
        xojo2.endConversation();
    }
;
++ YesTopic
    "<q>Xojo and I met while I was working on the Government Power
    Plant 6 demo,</q> you say.
    <.p><q>How nice,</q> Belker says. <q>As reluctant as I am to
    interrupt your reminiscences, I must remind, er, 119297 of the
    elevated standard of productivity to which we at Mitachron must
    always strive.</q>
    <.p><q>I am most grateful for this helpful episode of reminding,
    sir,</q> Xojo says, then slowly moves away, working the controls.
    Belker smiles and goes back to his pacing. "
;
++ NoTopic
    "<q>No, I don't think so,</q> you say, hoping to help Xojo avoid
    getting in trouble.
    <.p>Frosst pauses and smiles faintly. <q>Perhaps you are curious
    about our progress, then.  I am sorry to have to insist on a degree
    of secrecy because of our friendly rivalry; I am certain you
    understand.</q>  He looks at Xojo, who's slowly slinking away.
    <q>And I am equally certain my colleagues here would more than
    agree.</q> He shakes his head and goes back to his pacing. "
;
++ DefaultAnyTopic
    "<q>I am very much more interested in your acquaintance with
    my colleague here.  Do you in fact know one another?</q>
    <.convstay> "
;

/*
 *   Frosst's state for near the end of the game, when we're entering
 *   digits into the black box.  This is an in-conversation state because
 *   we want to revert to our prior state when the PC wanders off or stops
 *   interacting with us.  
 */
+ frosstWatchingDigits: InConversationState
    specialDesc = "Frosst Belker is standing near the black box,
        watching what you're doing. "
    stateDesc = "He's standing near the black box watching you. "

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
            "<.p>Frosst Belker wanders over to watch what you're doing. ";
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
        ['<q>So, Mr.\ Mittling,</q> Belker says, <q>you have deduced
        the method by which digits are entered, I see.</q> ',
         'Belker clucks his tongue. <q>If I were you, Mr.\ Mittling,
         I would not be wasting the scant time remaining trying digits
         at random.</q> ',
         'Belker shakes his head. <q>Your determination is admirable,</q>
         he says, <q>but surely you realize the impossibility of solving
         Mr.\ Stamer\'s riddle by exhaustive enumeration.</q> ',
         '<q>At this pace,</q> Belker says, <q>you might find the number
         you are seeking in, perhaps, thirty years.</q> ',
         '<q>You know,</q> Belker says, <q>my engineers will have the
         correct number very soon.  Perhaps I could persuade them to
         allow you to use their equipment afterwards.  It would, of
         course, be too late for you to win, but at least you might have
         the satisfaction of solving the riddle for yourself.</q> ',
         'Belker chuckles. <q>Mr.\ Mittling, I begin to wonder if you
         even know what riddle you are attempting to solve.  Given the
         lateness of the hour, I think it safe to offer you a small
         hint: it has something to do with a mathematician named
         Hovarth.</q><.reveal frosst-hovarth-hint> ']

        /* ...then we'll show this list in shuffled order, if we need more */
        ['<q>Mr.\ Mittling,</q> Belker says, <q>I find it nearly
        unbearable to watch such an earnest display of futility.</q> ',
         'Belker sighs. <q>I cannot bear to watch these pointless
         exertions of yours for much longer.</q> ',
         '<q>This futile effort of yours is exhausting to watch,</q>
         Belker says. ',
         '<q>Surely you must be tiring of this hopeless, random
         flailing,</q> Belker says. ']
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
        "<.p>Frosst goes back to supervising the technicians. ";
    }
;

/*
 *   There's no point in having too many responses in this state, as most
 *   players at this point will be highly motivated to plow on through and
 *   enter the number without interruption.  However, provide a few
 *   responses just in case...  
 */
    
++ AskTellTopic @hovarthTopic
    "You assume that Belker's technicians have managed to read the
    message from the black box, but you don't want to give anything
    away in case they haven't. "
    isConversational = nil
;
+++ AltTopic
    "<q>I know all about Hovarth numbers,</q> you boast.
    <.p>Belker raises his eyebrows.  <q>Indeed,</q> he says.
    <q>Then I should think you would be marshalling the services of a
    large supercomputer, as I have, rather than persisting in this
    random tinkering.</q> "
    isActive = gRevealed('frosst-hovarth-hint')
;
++ DefaultAnyTopic, ShuffledEventList
    ['Before you can start talking, Belker turns away to talk
    momentarily to one of the technicians. ',
     'Something on the Mitavac diverts Belker\'s attention as you
     try to talk to him. ',
     'Belker seems distracted by the black box; he just ignores you. ']

    isConversational = nil
;

/* state when in room 4 during the endgame */
+ frosstRoom4: ActorState
    specialDesc = "Frosst Belker is standing next to you. "
    stateDesc = "He's standing next to you. "
;
++ DefaultAnyTopic
    "Belker waves his hand at you dismissively. <q>Not now,
    Mr.\ Mittling,</q> he says. "
;

/* in any communicative state, we should at least recognize Galvani-2 */
+ AskTellTopic [efficiencyStudy37, galvaniTopic]
    "<q>What do you know about Project Galvani-2?</q> you ask.
    <.p>Belker raises his eyebrows slightly.  <q>Project
    Galvani-2?</q> he asks.  He strokes his chin. <q>I am afraid
    this means nothing to me.</q> "
    isActive = (efficiencyStudy37.seen)
;
+ GiveShowTopic @efficiencyStudy37
    "<q>How do you explain this?</q> you ask, holding up the binder.
    <.p>Belker gives it a cursory glance, then waves it away.
    <q>I am unfamiliar with this,</q> he says dismissively.
    <q>If I were you, though, I would be careful with such matters.
    You might arouse unwelcome curiosity about how you came into
    possession of such things.</q> "
;

