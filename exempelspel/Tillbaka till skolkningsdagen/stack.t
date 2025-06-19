#charset "utf-8"
/*
 *   Copyright 2003, 2013 Michael J. Roberts
 *   
 *   Return to Ditch Day - the stack.  This is part of Dabney, but it's big
 *   enough on its own that it's easier to handle as a separate module.  
 */

#include <adv3.h>
#include <sv_se.h>
#include "ditch3.h"


/* ------------------------------------------------------------------------ */
/*
 *   Alley One north 
 */
alley1N: AlleyRoom 'Alley One North' 'north end of Alley One'
    "Alley One ends here in a stairway leading up.  Room 3 is to
    the east and room 4 is to the west.  The hallway continues south. "

    south = alley1S
    east = room3Door
    west = room4Door
    north asExit(up)
    up = alley1Stairs

    /* set up the crowd blocks */
    setCrowdBlocks()
    {
        south = crowdBlock;
        up = crowdBlock;
    }

    /*
     *   Fake connectors for after we solve the stack.  When we solve the
     *   stack, a crowd forms, blocking any way out except into room 4. 
     */
    crowdBlock: FakeConnector { "There are too many people standing
        in the hall; you can't get through. "; }

    vocabWords = '1 alley one'

    roomParts = static (inherited + [alleyWestWall, alleyEastWall])

    /* 
     *   take our atmosphere list from Belker's current state; it's a good
     *   place to control it for this room, since Belker hangs out here
     *   for extended periods and the atmosphere all revolves around him 
     */
    atmosphereList = (frosst.curState.alley1Atmosphere)

    /* on the first arrival, award points for finding our way here */
    enteringRoom(traveler)
    {
        if (traveler == me)
            scoreMarker.awardPointsOnce();
    }
    scoreMarker: Achievement { +1 "finding Stamer's stack" }

    /* end the big blowout that happens around lunchtime */
    endBlowout()
    {
        /* get rid of the black smoke */
        bwSmoke.moveInto(nil);

        /* bring back frosst and xojo */
        frosst.moveIntoForTravel(self);
        xojo2.moveIntoForTravel(self);
        mitaTestOps.moveIntoForTravel(self);

        /* 
         *   Put xojo into the mitavac state, and cancel any pending
         *   introduction.  The introduction assumes that the megatester
         *   is present, so we don't want to do the intro now that it's
         *   gone.  In any normal game, we should have just naturally
         *   reached the intro by this point, but in any case it's not a
         *   big deal if we miss it.  
         */
        xojo2.setCurState(xojo2Mitavac);
        xojo2.removeFromAgenda(xojoIntroAgenda);
        xojo2.removeFromAgenda(xojoIntroRetryAgenda);

        /* set frosst to the 'computing' state */
        frosst.setCurState(frosstComputing);

        /* get rid of the MegaTester 3000 and associated items */
        PresentLater.makePresentByKeyIf('pro3000', nil);

        /* bring in the MitaVac 3000 and associated items */
        PresentLater.makePresentByKey('mitavac');

        /* mark that we're after lunch */
        gReveal('after-lunch');
    }
;

+ Graffiti
    'psychedelic random vibration
    art/scrawling/scribbling/particle/(box)/stills/film/squares/dot/lines'
    'graffiti'
    "It's the typical mix of psychedelic art and random scrawling.
    One amusing bit here is labeled <q>Stills from the film <q>Particle
    in a Box</q></q>: it's a series of squares, each with a
    dot inside, with little comics-style vibration lines around the dot.
    It's a quantum mechanics joke. "
;

+ alley1Stairs: StairwayUp 'stair/stairway/stairs' 'stairway'
    "The stairs lead up. "

    /* a traveler can only pass when the crowd blocks aren't in effect */
    canTravelerPass(trav) { return location.up == self; }
    explainTravelBarrier(trav) { "You can't get through the crowd. "; }
;

+ room3Door: AlleyDoor '3 -' 'door to room 3'
    "It's a wooden door labeled <q>3.</q> "
;

+ room4Door: Door 'room 4 room/door*doors' 'door to room 4'
    "It's a wooden door labeled <q>4.</q> "

    dobjFor(LookUnder) { action() { "A bundle of wires coming from
        the black box runs under the door, but other than that, there's
        nothing to see. "; } }

    dobjFor(Open)
    {
        check()
        {
            if (!isSolved)
            {
                "You can't enter until the stack is solved. ";
                exit;
            }
            else
                inherited();
        }
    }
    dobjFor(TravelVia)
    {
        check()
        {
            if (!isSolved)
            {
                "You can't enter until the stack is solved. ";
                exit;
            }
            else
                inherited();
        }
    }

    /* if the stack isn't solved, use no precondition, as we can't enter */
    getDoorOpenPreCond() { return isSolved ? inherited() : nil; }

    dobjFor(Knock)
    {
        action()
        {
            if (isSolved)
                "No need to knock; as the rightful solver of the stack,
                you can go right in. ";
            else
                "You knock, but there's no reply.
                The owner is presumably away for Ditch Day. ";
        }
    }
;

class StackFixture: CustomFixture
    cannotTakeMsg = 'It\'s against the rules of the stack to move
        this stuff around. '
;

+ PermanentAttachment, StackFixture 'bundle/wire/wires' 'bundle of wires'
    "The bundle of wires attaches to the back of the black box, and
    runs under the door. "

    attachedObjects = [blackBox]
;

/* the stack as a generic object */
+ Decoration 'brian brian\'s stamer\'s ditch day stack'
    'Ditch Day stack'
    "<<room4Sign.described
      ? "Brian's stack consists of the black box on the table.  The
        sign on the door has details on the rules of the stack."
      : "You should probably read the sign on the door to get details
        on the stack.">> "

    notImportantMsg = 'The stack consists of the black box, so anything
        you want to do with the stack, you should do with the black box. '
;

/* make the table a fixture, because it's obvious that we can't move it */
+ StackFixture, Surface 'old small wood wooden card table' 'small table'
    "It's an old wooden card table. "

    dobjFor(LookUnder) { action() { "All you see is the bundle of
        wires that runs under the door. "; } }
;

++ blackBox: TestGearAttachable, CustomFixture
    'black sheet metal box' 'black box'
    "The box looks a little improvised; it might have been a microwave
    oven at some point, but if there was a door, it's been replaced by
    sheet metal, and the whole thing has been painted black.
    <.p>Visual inspection doesn't offer much in the way of clues.
    A bundle of wires runs out the back and under the door.  In
    front, there's an unusual electrical connector.  Otherwise,
    it's just black sheet metal.
    <<extraInfo>> "

    dobjFor(LookBehind) { action() { "The black box is pretty close to
        the door, so you can't see much of the back.  All you can see
        is the bundle of wires. "; } }

    dobjFor(LookUnder) { action() { "There's no space between the box
        and the table, and you're not supposed to move the box, so
        there's nothing to see here. "; } }

    /*
     *   Provide some extra information as part of the description of the
     *   black box.  This helps explain what we need to do with the box
     *   next, so it varies according to where we are in the game.
     *   
     *   Early on, until we've gathered the necessary equipment from the
     *   Bridge lab, provide a hint about what equipment we'll need to
     *   solve the stack. 
     *   
     *   Later, once we have the Hovarth number, explain how to enter the
     *   number.  
     */
    extraInfo()
    {
        /* if we haven't gathered the equipment yet, explain what we need */
        if (equipHintNeeded)
            "<.p>It looks like the mystery of the box is electronic
            in nature, so you'll need some test gear to analyze it.
            There's not much to go on at this point, so you don't see
            much choice but to start with the basics---an oscilloscope
            and a signal generator.  It's been an awfully long time
            since you've had to debug circuitry at such a low level;
            you're not at all sure you'll be able to figure this out.
            <.reveal needed-equip-list> ";

        /* if we have the hovarth number, explain how to enter it */
        if (gRevealed('hovarth-solved') && !gRevealed('black-box-solved'))
            "<.p>When you were examining the box earlier, you noticed
            that it has a ten-level voltage digitizer hooked up to one
            of the connector pins.  You'd guess that it's the way you're
            meant to enter the Hovarth number.  The signal generator
            ought to work as the voltage source. ";
    }

    /* 
     *   we need the equipment hint until we gather the equipment, but not
     *   until we know what the stack is about from reading the sign 
     */
    equipHintNeeded = (room4Sign.described && !equipGathered)
    equipGathered = (oscilloscope.moved && signalGen.moved)

    specialDesc = "Next to the door to room 4 is a small table, on
        which is a black metal box that looks like it could once have
        been a microwave oven.  A sign (really just a sheet of paper)
        is fastened to the door above the box. "

    /* put this early among the specialDesc's */
    specialDescOrder = 90

    showSpecialDescInContents(actor, cont)
        { "On the table is a black metal box that looks a little like
            a microwave oven. "; }

    cannotTakeMsg = 'It\'s against the rules of the stack to move the box. '
    cannotOpenMsg = 'That\'s against the rules of the stack. '

    /* handle connecting the test equipment */
    probeWithScope()
    {
        /* if we've solved the Hovarth puzzle, explain how to proceed */
        if (gRevealed('hovarth-solved') && !gRevealed('black-box-solved'))
        {
            "You don't need the scope at this point, since your earlier
            reverse engineering already told you what you need to know:
            you just need to use the signal generator as a voltage source
            for the black box's digitizer circuit. ";
            return;
        }
        
        /* 
         *   nothing happens unless the signal generator is plugged in and
         *   turned on 
         */
        if (attachedObjects.indexOf(signalGen) != nil && signalGen.isOn)
        {
            /*
             *   Okay, as far as the circuitry is concerned, we have data
             *   to observe.  What we gather from the data, though,
             *   depends on the character's current experience level.
             *   
             *   If we've done all of our background research - we've read
             *   the Morgen textbook for a bit, and we've successfully
             *   repaired the Positron machine - we can actually make some
             *   sense of the data.  Otherwise, we're a bit lost.  
             */
            if (morgenBook.isRead && gRevealed('positron-repaired'))
            {
                /* 
                 *   The circuitry is all operating and we know how to
                 *   interpret the data.  If we're past lunch, we can just
                 *   read the message; otherwise, we kick off the
                 *   lunchtime blowout.
                 */
                if (gRevealed('after-lunch'))
                {
                    if (timesRead++ == 0)
                    {
                        "You make some adjustments on the scope, and start
                        probing the contacts.  The patterns jump right out
                        at you now: this is a simple serial data
                        communication circuit, but it's disguised
                        well enough with weird voltages and wave patterns
                        that you didn't recognize it before.
                        <.p>Ideally, you'd go build a compatible interface,
                        then plug in a terminal to see what the message is.
                        But there's no time for that; you'll have to just
                        try to read the data right off the scope.  It's
                        a good thing you memorized ASCII in binary a long
                        time ago.  It takes you a couple of minutes to
                        get the hang of it again, but the bit patterns
                        finally start looking like letters and numbers:
                        <.p>\t3... 9... 2... )... H... O... V... A...
                        <.p>Eventually the sequence starts repeating;
                        it's just repeating a short message in a loop.
                        You watch it go by a few times until you're
                        convinced it really is repeating the same
                        message each time:
                        <.p>\tHOVARTH(<<infoKeys.hovarthIn>>)
                        <.p>This is almost trivial!  <q>Hovarth</q> is
                        one of those obscure math functions; the solution
                        to the stack must simply be to calculate the
                        result and key in the number.  All you need to do
                        is to find a copy of the DRD math tables, and look
                        up this Hovarth number.
                        <.p>You put down the scope probe, and suddenly
                        realize Belker is hovering behind you.
                        <q>I take it you have discovered a hidden
                        message,</q> he says.  <q>Perhaps you will
                        be more efficient than my inferiors at
                        formulating a response.</q>  He chuckles and
                        goes back to watching the technicians.
                        <.reveal hovarth> ";

                        /* this is worth some points */
                        hovarthScore.awardPointsOnce();
                    }
                    else
                    {
                        "You find the right set of contacts to touch
                        with the oscilloscope probe, and watch the
                        the bits of the message on the display.
                        It looks like the same message as before:
                        <.p>
                        \tHOVARTH(<<infoKeys.hovarthIn>>)
                        <.p>
                        <<gRevealed('drd-hovarth')
                            ? "Now you just need to figure out how to
                              calculate that Hovarth number."
                            : "This should be easy---you just need to
                              get a copy of the DRD math tables and look
                              up Hovarth functions.  The library probably
                              has a copy.">> ";
                    }
                }
                else
                {
                    /* trigger the lunchtime blowout */
                    "You're eager to take another look at the black box now
                    that you've had a chance to reacquaint yourself with
                    this stuff.  You make some adjustments on the scope and
                    pick up the probe.
                    <.p>Just as you're about to connect the probe, the
                    entire alley fills with a blinding blue-white light
                    and a deafening crash.  A wave of pressure hits you
                    and slams you against the wall.  You reach out for
                    something to hold on to for balance, but find nothing;
                    you feel yourself stumbling sideways, your ears ringing,
                    your eyes filled with dark green blotches, and you have
                    the sensation of being caught in a stampede, of trying
                    to push your way through a crowd rushing in the opposite
                    direction.
                    <.p>As the after-images start to fade from your eyes,
                    you see that you've somehow made your way out to the
                    breezeway outside Alley One, along with the Mitachron
                    technicians.  Thick black smoke billows out from the
                    alley entrance.
                    <.p>Frosst Belker emerges nonchalantly from the cloud
                    of smoke, brushing bits of ash off his white clothes.
                    At the same time, a group of fire fighters rush in from
                    the Orange Walk.  They see Belker, talk to him briefly,
                    then rush into the alley.  As they leave, you notice
                    the Mitachron logos on their uniforms.
                    <.p>Belker turns to you.  <q>This building,</q> he says,
                    flicking a bit of ash from his lapel, <q>it is not, er,
                    <q>up to code,</q> you might say.  Not to worry, though.
                    I am assured that repairs will be complete within the
                    hour.</q> He glances at his watch. <q>Ah, just enough
                    time for lunch.</q> He points his finger around the crowd
                    of technicians, snaps his fingers, and points outside.
                    The technicians all file out, and Belker follows. ";

                    /* move me outside */
                    me.moveIntoForTravel(dabneyBreezeway);
                    
                    /* set up the smoke */
                    bwSmoke.makePresent();
                    
                    /* 
                     *   set up follow departure data for belker, xojo,
                     *   and the other technicians 
                     */
                    trackAndDisappear(frosst, dabneyBreezeway.west);
                    trackAndDisappear(mitaTestOps, dabneyBreezeway.west);
                    trackAndDisappear(xojo2, dabneyBreezeway.west);

                    /* set a fuse for aaron and erin to arrive shortly */
                    erin.startLunchFuse();

                    /* fire the plot clock event for the blowout */
                    blowoutPlotEvent.eventReached();
                }
            }
            else
            {
                /* 
                 *   we haven't done all of our research, so we can't make
                 *   sense of the data 
                 */
                "You fumble around with the signal generator and the
                oscilloscope for a bit, trying various frequencies and
                waveforms, and touching the scope's probe to the
                different contacts in turn.  The scope shows clear
                responses; there are undoubtedly patterns here,
                but you're not seeing them. ";

                /* 
                 *   If we've done part of our research, provide some
                 *   encouragement need to do the rest.  If we haven't
                 *   done any research yet, suggest what research would be
                 *   helpful. 
                 */
                if (morgenBook.isRead)
                {
                    "You feel like you should be able to figure this out;
                    you know you understand the principles.  What you need,
                    you think, is some practice with something simpler and
                    better defined.<.reveal need-ee-practice>
                    Repairing a broken television, ";

                    /* if we've described Positron, recommend it */
                    if (posGame.described)
                        "maybe.  Actually, that Positron game in the
                        pinball room could be just the thing. ";
                    else
                        "something like that. ";
                }
                else if (gRevealed('positron-repaired'))
                    "You feel like you should be able to figure this out;
                    you did manage to repair that video game, after all.
                    What you need, you think, is to spend some time with
                    a good textbook, to brush up on theory a
                    bit.<.reveal need-ee-text> ";
                else
                    "<.p>You have the sinking feeling that you're not up to
                    this.  You'd been hoping that the box would turn out to
                    be something deceptively simple, but you're now pretty
                    sure it's not; it looks like a serious electrical
                    engineering puzzle, and you're just not much of a
                    double-E these days.  If you could snap your fingers
                    like Belker and get a gaggle of engineers out here to
                    do the work for you, no problem, but that's not how
                    Omegatron works.
                    <.p>Maybe if you spent some time with a good EE
                    textbook, you'd have a chance, although right now you
                    can't even think of what book to read; maybe you could
                    ask one of the students here for a recommendation.
                    You could also really use some practice debugging a
                    simpler circuit.  It seems like quite a long shot,
                    given that you're up against this whole Mitachron
                    crew, but you don't have anywhere else you have to
                    be today, after all.
                    <.reveal need-ee-text><.reveal need-ee-practice> ";

                /* on the first time through, Belker notices */
                if (timesProbed++ == 0)
                    "<.p><q>I see you are making some progress at last.</q>
                    You look up and see Belker watching, looking faintly
                    amused. <q>Your collection of test equipment looks
                    quite formidable,</q> he says, surveying your gear.
                    <q>I shall have to instruct my technicians to redouble
                    their efforts, lest we fall behind.</q>
                    <.p>Something distracts him, and he turns back to the
                    technicians. <q>No, no, no,</q> he says to one of them,
                    making his way through the narrow space. ";
            }
        }
        else
        {
            /* the signal generator isn't in use, so we don't get any data */
            "You touch the scope's probe to the various contacts
            one at a time.  Some faint, erratic patterns appear; they
            could just be electrical noise.  It might be useful to try
            a signal generator to see if there's any response to different
            waveforms. ";
        }
    }

    probeWithSignalGen()
    {
        /* 
         *   If we have the solution to the Hovarth puzzle in hand,
         *   explain how to enter digits.
         */
        if (gRevealed('hovarth-solved') && !gRevealed('black-box-solved'))
        {
            /* if the signal generator's not already on, turn it on now */
            if (!signalGen.isOn)
            {
                "<.p>You turn on the generator, then attach it ";
                signalGen.makeOn(true);
            }
            else
                "<.p>You attach the generator ";
            
            /* explain the procedure */
            "to the connector pin you think is the <q>clear</q> switch,
            to make sure the box's internal number memory is zeroed.
            You give it a few moments, then you attach the connector
            to the pins going to the voltage digitizer, and you adjust
            the generator settings to the right voltage range.  It should
            now be set up to enter digits, one at a time, using the
            amplitude knob. ";

            /* start the knob on zero */
            signalGenKnob.curSetting = '0';

            /* start the data entry daemon */
            clearDigits();
            new Daemon(self, &digitEntryDaemon, 1);
        }
    }

    /* score marker for getting Hovarth code */
    hovarthScore: Achievement { +10 "decoding the black box's message" }

    /* a game-clock event for the explosion */
    blowoutPlotEvent: ClockEvent { eventTime = [2, 12, 07] }

    /* number of times we've attempted probing with the scope */
    timesProbed = 0

    /* number of times we've read the message */
    timesRead = 0

    turnOnSignalGen()
    {
        /* 
         *   if we don't know the Hovarth story yet, mention the scope; if
         *   we do, and we haven't solved the stack yet, reset the digit
         *   accumulator so that we can have a fresh start at entering the
         *   number 
         */
        if (!gRevealed('hovarth-solved'))
        {
            "You try a few settings, but there's no obvious response
            from the black box.  An oscilloscope would probably help
            to see if anything's going on. ";
        }
        else if (!gRevealed('black-box-solved'))
        {
            /* reset the knob to zero, and clear our accumulator */
            signalGenKnob.curSetting = '0';
            clearDigits();

            /* mention what we did */
            "Just to make sure you're getting a clean start at entering
            digits, you turn the amplitude knob to zero and briefly touch
            the connector pin that you think resets the black box.  You
            should be set to enter a number now. ";
        }
    }

    /*
     *   The digit entry daemon.  The signal generator starts this
     *   running, once per turn, whenever the signal generator is attached
     *   and we've solved the Hovarth number puzzle.  We accept one digit
     *   per turn, issuing auditory feedback each time we accept a digit.  
     */
    digitEntryDaemon()
    {
        /* 
         *   if the generator is still attached and turned on, accept the
         *   current digit 
         */
        if (signalGen.isOn && signalGen.isAttachedTo(self))
        {
            /* ignore it if we're paused */
            if (pauseDigits)
            {
                /* end the pause */
                pauseDigits = nil;

                /* do no more this turn */
                return;
            }
            
            /* accept the current dial position as the next digit */
            enterDigit(toInteger(signalGenKnob.curSetting));

            /* 
             *   If we're here, mention the beep.  (Note that we could
             *   instead have made this a SenseDaemon with the 'sound'
             *   sense; but in this case, the only way we can hear the
             *   beep is to be present, so we save the sense system a
             *   little extra calculation on each turn by using the
             *   simpler means of figuring out whether or not we're within
             *   hearing range.) 
             */
            if (me.isIn(alley1N))
            {
                /* mention the beep */
                "<.p>The black box emits a soft beep. ";

                /* if this is the first mention, explain what it means */
                if (beepHeardCount++ == 0)
                    "You'd assume that this means the box accepted
                    the current digit. ";

                /* 
                 *   notify frosst if we've turned the knob to a non-zero
                 *   value (if we're entering 0s, don't bother, as we're
                 *   probably just doing something else before we get to
                 *   entering digits) 
                 */
                if (signalGenKnob.curSetting != '0')
                    frosstWatchingDigits.noteDigitEntry();
            }

            /* check for a winning combination */
            checkDigits();
        }
    }

    /* pause reading input for a turn */
    pauseDigits = nil

    /* number of times we've heard the beep */
    beepHeardCount = 0

    /* clear the digit memory */
    clearDigits()
    {
        /* zero the accumulator */
        curAcc = 0;

        /* pause reading digits for a turn */
        pauseDigits = true;
    }

    /* enter one digit */
    enterDigit(n)
    {
        /* multiply the accumulator by ten and add the new one */
        curAcc *= 10;
        curAcc += n;
    }

    /* check for a winning combination */
    checkDigits()
    {
        if (curAcc == toInteger(infoKeys.hovarthOut))
        {
            "Then, after a few moments, it makes a loud <q>Ding.</q>
            <.p>You realize that a crowd has formed in the hallway.
            The technicians have all abandoned the Mitavac and are
            standing watching you, and a couple dozen students have
            arrived as well.  Everyone's silently watching you.
            <.p>Belker looks confused.  <q>What does this dinging
            noise signify?</q> he asks sharply.  As though to answer,
            the black box clicks, and the door to room 4 swings open.
            The crowd cheers and applauds---even the Mitachron
            technicians are smiling.  Belker just stands there with
            his jaw hanging open.
            <.p>Some of the students start heading into room 4 to
            claim their share of the bribe.  Belker makes his way
            over to you through the crowd.  He's regained his composure
            now; he smiles faintly.  <q>Congratulations,</q> he says.
            <q>I am suitably impressed with your resourcefulness.
            I should like my technicians to study your methods
            someday.</q>  He seems about to say something else, but
            his cell phone rings; he takes it out of his pocket and
            answers.  He moves away through the crowd.
            <.reveal black-box-solved> ";

            /* make frosst disappear for now */
            frosst.moveInto(nil);

            /* set the mitachron technicians into crowd mode */
            mitavacTechs.setCurState(mitaTechCrowd);
            xojo2.setCurState(xojo2Crowd);

            /* open the door to room 4 and mark it as "solved" */
            room4Door.makeOpen(true);
            room4Door.isSolved = true;

            /* set up the crowd blocks so we can't leave the alley */
            alley1N.setCrowdBlocks();

            /* move the crowd here */
            alley1Crowd.makePresent();

            /* kill the black box daemon */
            signalGen.killDaemon();

            /* this is definitely worth some points, and a plot event */
            solveScoreMarker.awardPointsOnce();
            solvePlotEvent.eventReached();
        }
    }

    /* points for solving the stack */
    solveScoreMarker: Achievement { +10 "solving Brian Stamer's stack" }

    /* solving the stack is a clock-significant plot event */
    solvePlotEvent: ClockEvent { eventTime = [2, 16, 53] }

    /* our accumulator - this is the number we've entered so far */
    curAcc = 0
;

+++ PluggableComponent
    '(black) (box) unusual small t-shaped electrical connector
    post/connector/pin/pins/hole/holes'
    'electrical connector'
    "The connector isn't a standard type, or at least not one you're
    familiar with.  It has a combination of pins and holes, about a
    dozen of each, and a small T-shaped post. "

    disambigName = 'black box connector'
;

++ Unthing 'former microwave oven' 'former microwave oven'
    notHereMsg = 'There\'s no microwave here&mdash;just that black
        box that might have been a microwave in a past life. '
;

++ room4Sign: CustomImmovable, Readable 'sheet/paper/sign' 'sign'
    "It's a laser-printed set of instructions for the stack:
    <.p><.blockquote>
    <font face=tads-sans><b>Brian's Black Box of Mystery</b>
    <.p>My stack is the black box you see before you.  It controls the
    door to my room.  All you have to do is figure out how to make the
    box open the door.
    <.p>This is a <q>finesse</q> stack, which means you're not allowed
    to use physical force to break the stack---so no breaking down my
    door.  You're also not allowed to force open the black box, or move
    it, or disturb its external wiring.  Apart from all that, you can
    use pretty much any means you like to figure out how the box works.
    <.p>I'll give you one hint: electronic test equipment might be
    helpful.  For your convenience, I've left a bunch of equipment
    in my lab (022 Bridge).  You can help yourself to anything on the
    shelves on the back wall.  The key to the lab is on top of the box.
    <.p>P.S.\ If there are a couple of non-Techers working on the stack,
    that's okay.  They're recruiters who came here to interview me,
    and I invited them to join in the Ditch Day fun.  One special rule
    for them: you're allowed as many helpers as you want and any
    equipment you want, but everything you use has to be on-campus.
    It wouldn't be fair to just phone it in from headquarters.
    <.reveal stamer-lab>
    </font><./blockquote>"

    dobjFor(Examine)
    {
        action()
        {
            /* inherit the default handling first */
            inherited();

            /* always set back the 'bribe' timer when we read the sign */
            bribeStudents.setDelay(2);
            
            /* this makes aaron and erin introduce themselves if necessary */
            aaron.noteMeReadingSign();
        }
    }

    cannotTakeMsg = 'You should leave that where it is so that other
        people can read it. '
;

/* ------------------------------------------------------------------------ */
/*
 *   A class for Aaron-and-Erin conversation lists.  This is a script that
 *   can be combined with an actor state.  What's special about this type
 *   of script is that we perform a scripted conversational action only if
 *   there was no other conversation from either Aaron or Erin this turn.  
 */
class AaronErinConvList: object
    doScript()
    {
        /* 
         *   if neither Erin nor Aaron has conversed this turn, proceed
         *   with the script; otherwise do nothing 
         */
        if (!erin.conversedThisTurn() && !aaron.conversedThisTurn())
            inherited();
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   Aaron 
 */
+ aaron: IntroPerson
    'tall thin young skinny frizzy red hair red-haired
    guy/boy/man/student/aaron*students men'
    'tall, thin student'
    "He's tall and so thin he looks almost undernourished.  His hair is
    red and frizzy, as though he just got a big static electric shock. "
    properName = 'Aaron'
    isHim = true

    noteMeReadingSign()
    {
        /* if we haven't been introduced yet, introduce ourselves */
        if (!introduced)
        {
            "<.p>The young woman approaches you. <q>Hi,</q>
            she says. <q>I'm curious&mdash;are you guys the
            recruiters?</q>";
            commonIntro(true, true);
        }

        /* if erin hasn't mentioned the key yet, do so now */
        erin.mentionKey(true);
    }

    commonIntro(enterConv, fromSign)
    {
        /* show the common introduction */
        "<.p><q>Yeah,</q> you answer.  <q>He's with Mitachron. I'm Doug,
        from Omegatron.</q>
        <.p><q>Greetings, Doug from Omegatron,</q> the guy with the
        frizzy hair says. <q>I'm Aaron.</q>
        <.p><q>Me, too,</q> the young woman says, <q>only I spell it
        E-R-I-N.</q> ";

        /* if we got here by reading the sign, mention the key */
        if (fromSign)
            erin.mentionKey(nil);

        /* aaron and erin are now introduced */
        aaron.setIntroduced();
        erin.setIntroduced();

        /* set up frosst's "bribe" agenda item */
        frosst.addToAgenda(bribeStudents.setDelay(2));

        /* if necessary, put both of them in conversation mode */
        if (enterConv)
        {
            /* 
             *   note that we can just make the state changes explicitly,
             *   since we've already run through the intro on our own 
             */
            erin.setCurState(erin.curState.inConvState);
            aaron.setCurState(aaron.curState.inConvState);

            /* set 'me' to be talking to erin */
            me.noteConversation(erin);
        }
    }

    /* erin's also in any conversation we're in */
    noteConversationFrom(other)
    {
        inherited(other);
        erin.noteConvAction(other);
    }
;
++ InConversationState
    specialDescListWith = [aaronAndErinAlley1]
;

/* 
 *   since we're not going to be around for long, just use one topic to
 *   talk about most anything related to the stack 
 */
+++ AskTellShowTopic, SuggestedAskTopic, ShuffledEventList
    [blackBox, ddTopic, stackTopic, stamerStackTopic]
    ['<q>Have you figured out anything about the stack yet?</q> you ask.
    <.p>Aaron shakes his head.  <q>Not really.</q> ',
     '<q>Is the stack you\'re going to work on today?</q>
     <.p><q>Maybe,</q> Aaron says. <q>It looks suitably obscure.</q> ',
     '<q>Any ideas about how to approach this?</q> you ask.
     <.p>Aaron appraises the black box for a bit. <q>I don\'t know.
     Visual inspection isn\'t turning up much to work with.</q> ']

    name = 'the stack'
;

+++ AskTellShowTopic [aaron, erin]
    "<q>What's your major?</q> you ask.
    <.p><q>We're both double-E's,</q> he says, then adds, <q>That's
    electrical engineering.</q><.reveal aaron-erin-major> "
;
++++ AltTopic
    "<q>This stack looks perfect for a double-E.</q>
    <.p><q>Maybe,</q> Aaron says. <q>It might be too much like
    real work, though.</q> "
    isActive = (gRevealed('aaron-erin-major') && room4Sign.described)
;

+++ AskTellAboutForTopic @labKey
    "<q>Do you know where the key is?</q> you ask.
    <.p><q>I think Erin has it, don't you?</q>
    <.p><q>I've got it,</q> she says.<.reveal erin-has-key> "
;

+++ DefaultAnyTopic
    "He seems pretty focused on the stack right now.  You doubt he'd
    be very interested in talking about much else. "
    isConversational = nil
;

+++ ConversationReadyState
    isInitState = true
    stateDesc = "He's studying the black box. "
    specialDescListWith = [aaronAndErinAlley1]
    showGreetingMsg(actor, explicit)
    {
        if (!aaron.introduced)
        {
            "<q>Hi,</q> you say to the pair of students.
            <.p>The two look up from their deliberations over the black
            box.  <q>Hi,</q> they say almost in unison.  <q>Are you guys
            the recruiters?</q> the young woman asks, glancing over
            at Frosst.";
            aaron.commonIntro(nil, nil);
        }

        /* 
         *   Enter conversation for erin as well.  We can just make the
         *   state change in Erin explicitly, since we're handling the
         *   rest of the transition for both Aaron and Erin.  
         */
        erin.setCurState(erin.curState.inConvState);
    }
;

/* a separate set of states for when we're working on the Upper 7 stack */
++ InConversationState
    specialDescListWith = [aaronAndErinUpper7]
;
+++ AskTellTopic @posGame
    "<q>Do you know anything about the Positron machine downstairs?</q>
    you ask.
    <.p><q>It's moderately fun, when it's working,</q> he says.
    <q>Which isn't often.</q> "
;
+++ AskTellTopic @scottTopic
    "<q>I'm looking for Scott,</q> you say. <q>The owner of the Positron
    machine downstairs.  Have you seen him around?</q>
    <.p><q>I believe he is working on the giant chicken stack
    in alley 3,</q> he says. "
;
+++ AskForTopic @scottTopic
    topicResponse() { replaceAction(AskAbout, gDobj, scottTopic); }
;
+++ AskTellGiveShowTopic
    [efficiencyStudy37Topic, efficiencyStudy37, galvaniTopic]
    "As much as you'd like to expose Mitachron's evil plans to the
    world, you have a feeling that there are better places to start. "

    isConversational = nil
;
+++ AskTellTopic @jayTopic
    "<q>Do you know where Jay Santoshnimoorthy is?</q> you ask.
    <.p>He crosses his arms and thinks for a minute.  <q>Yes,</q>
    he finally says. <q>More precisely, I know where he was
    earlier today: he was considering the stack in Alley
    Four,</q> he says. "
;
+++ GiveShowTopic @calculator
    "He looks at the calculator and hands it back. <q>This is the
    sort of calculator Jay Santoshnimoorthy likes to play with,</q>
    he says. "
;
    
+++ AskTellShowTopic, StopEventList [ddTopic, paulStackTopic, commandant64]
    ['<q>It looks like you found another stack,</q> you say.
    <.p>Aaron nods. <q>This one is better anyway.</q> ',
     '<q>How\'s the stack coming?</q> you ask.
     <.p>Aaron shrugs. <q>Progress is being made, I believe.</q> ',
     '<q>Any ideas how this stack works?</q> you ask.
     <.p><q>Some,</q> Aaron says, nodding.  <q>We believe it is a
     code of some kind.</q> ']
;
+++ AskTellAboutForTopic [physicsTextTopic, bloemnerBook, drdTopic]
    "<q>What's the best place around here to find textbooks?</q> you ask.
    <.p><q>The campus bookstore or Millikan,</q> Aaron says. "
;
+++ AskTellAboutForTopic +90
    [eeTextbookRecTopic, eeTextTopic, morgenBook,
     eeLabRecTopic, labManualTopic, townsendBook]

    topicResponse()
    {
        "<q>You're double-E's, right?</q> you ask.  The two nod. <q>I was
        wondering if you had any recommendations for a good EE text.
        Something I could use as a refresher.</q>
        <.p>Aaron nods. <q>Yves Morgen, Electronics Lectures.  The name
        is spelled M-O-R-G-E-N.  Very readable.</q><.reveal morgen-book> ";

        /* award some points for this */
        morgenBook.recMarker.awardPointsOnce();
    }
;
++++ AltTopic
    "<q>Any other double-E text recommendations?</q> you ask.
    <.p>Aaron shakes his head. <q>Morgen is the best I know of.</q> "

    isActive = (gRevealed('morgen-book'))
;
+++ AskTellTopic @qubitsTopic
    "<q>Do you know what <q>QUBITS</q> refers to?</q> you ask.
    <.p>He nods. <q>Affirmative.  A qubit is the name for a quantum bit,
    the quantum computing equivalent of a conventional binary data bit.</q> "
;
+++ AskTellTopic @quantumComputingTopic
    "<q>What do you know about quantum computing?</q> you ask.
    <.p><q>Very little,</q> he says. <q>They do a lot of work on that
    around here, but I haven't followed it much.</q> "
;
    
+++ DefaultAnyTopic
    "He seems mostly interested in the stack right now. "
    isConversational = nil
;

+++ aaronUpper7: ConversationReadyState
    stateDesc = "He's studying the computer screen. "
    specialDescListWith = [aaronAndErinUpper7]
    showGreetingMsg(actor, explicit)
    {
        /* show the greeting */
        "<q>Hi,</q> you say.  The two look up from the computer and
        say hello.<.p>";
        
        /* erin is automatically part of the conversation as well */
        erin.setCurState(erin.curState.inConvState);
    }
;

/* a separate set of states for the breezeway around lunchtime */
++ aaronBreezeway: ActorState
    stateDesc = "He's trying to look through the cloud of smoke
        into the alley. "
    specialDescListWith = [aaronAndErinBreezeway]
;

+++ DefaultAnyTopic
    "Aaron seems preoccupied with trying to see what's going on in
    the alley. "
    isConversational = nil
;

/* a separate set of states for lunchtime */
++ aaronLunch: ActorState
    stateDesc = "He's sitting at the table eating lunch. "
    specialDescListWith = [aaronAndErinLunch]
;

+++ HelloTopic
    "You make some smalltalk with Aaron, but he's not very
    responsive; he seems lost in thought. "
;

+++ DefaultAnyTopic, ShuffledEventList
    ['Aaron seems too focused on his food to respond. ',
     'It looks like he\'s too busy trying to identify something
     on his plate to pay any attention to you. ',
     'He\'s busy with his food; he seems to ignore you. ',
     'Aaron seems lost in thought. ']
    isConversational = nil
;


/* a separate set of conversation states for the endgame */
++ aaronRoom4: ActorState
    stateDesc = "He's working on the snacks. "
    specialDescListWith = [aaronAndErinRoom4]
;

+++ AskTopic [ddTopic, stackTopic, paulStackTopic, commandant64]
    "<q>How did you do on your stack?</q> you ask.
    <.p><q>We were successful,</q> he says. <q>It's an amusing
    puzzle.</q> "
;
+++ TellTopic [ddTopic, stackTopic, blackBox, stamerStackTopic]
    "Aaron and Erin listen attentively as you explain your
    adventures solving Stamer's stack. "
;

+++ DefaultAnyTopic
    "Aaron can't seem to hear you over the noise of the crowd. "
    isConversational = nil
;

/* ------------------------------------------------------------------------ */
/*
 *   Erin
 */
+ erin: IntroPerson
    'short young young-looking blond blonde student/woman/erin*students women'
    'short blonde woman'
    "She's short and very young-looking, even for a college student. "
    properName = 'Erin'
    isHer = true

    mentionKey(newPara)
    {
        /* 
         *   if erin can talk to the PC, and she hasn't already mentioned
         *   the key, do so now 
         */
        if (canTalkTo(me) && !gRevealed('erin-has-key'))
        {
            "<<newPara ? '<.p>Erin' : 'She'>> takes something out of her
            pocket and shows it to you: a key.  <q>I've got the key to
            the lab, by the way,</q> she says, and puts it away. <q>You
            guys are welcome to come with us when we go to the lab, if
            you want.</q> ";

            /* 
             *   Note that we reveal 'erin-has-key' through gReveal rather
             *   than through the <.reveal> tag because we might want to
             *   check the revelation again on this very same turn, due to
             *   the way we generate the sign message.  <.reveal> sometimes
             *   won't take effect until after the turn is finished,
             *   because the command transcript usually captures the output
             *   while the turn is ongoing.  
             */
            gReveal('erin-has-key');
        }
    }

    /* aarin's also in any conversation we're in */
    noteConversationFrom(other)
    {
        inherited(other);
        aaron.noteConvAction(other);
    }

    /* start the lunch fuse */
    startLunchFuse()
    {
        /* create and remember the event */
        lunchFuseEvt = new Fuse(self, &lunchFuse, 2);
    }

    /* the lunch fuse */
    lunchFuseEvt = nil

    /* 
     *   A fuse handler for lunch time.  This gets set up when we trigger
     *   the explosion in alley 1; aaron and erin go to the breezeway to
     *   see what's going on, and invite the PC to lunch.  
     */
    lunchFuse()
    {
        /* bring aaron and erin to the breezeway */
        aaron.moveIntoForTravel(dabneyBreezeway);
        moveIntoForTravel(dabneyBreezeway);

        /* set aaron to just peering into the cloud */
        aaron.setCurState(aaronBreezeway);

        /* erin says hello */
        initiateConversation(erinBreezeway, 'erin-smoke');

        /* forget our fuse */
        lunchFuseEvt = nil;
    }

    /* head to lunch */
    goToLunch()
    {
        /* mention where we're going */
        "The two head across the courtyard toward the dining room. ";
        
        /* depart via courtyard */
        trackAndDisappear(aaron, dabneyBreezeway.east);
        trackAndDisappear(erin, dabneyBreezeway.east);

        /* we know where they're going */
        knownFollowDest = dabneyDining;
        aaron.knownFollowDest = dabneyDining;

        /* begin lunch */
        dabneyDining.startLunch();
    }

    /* 
     *   interrupt the lunch fuse - this gets invoked if the PC leaves the
     *   breezeway before we show up 
     */
    interruptLunchFuse()
    {
        if (lunchFuseEvt != nil)
        {
            "As you're leaving, Aaron and Erin come in from the courtyard.
            Aaron goes to check out the smoke, and Erin stops you for
            a moment. <q>We're about to go have lunch,</q> she says.
            <q>You should join us, if you feel like it.</q> ";

            /* send them on their way */
            goToLunch();

            /* cancel the fuse; we don't need it any more */
            eventManager.removeEvent(lunchFuseEvt);
            lunchFuseEvt = nil;
        }
    }
;

++ Fixture, Container 'pocket' 'pocket'
    contentsListed = nil
    dobjFor(Examine)
    {
        check()
        {
            "You don't make a habit of going through other people's
            pockets. ";
            exit;
        }
    }
    dobjFor(LookIn) asDobjFor(Examine)
;

+++ labKey: DitchKey 'metal "lab" laboratory key*keys' 'lab key'
    "<q>Lab</q> is handwritten on it. "

    /* make this pre-known so we can ask about it */
    isKnown = true
;
    
++ InConversationState
    specialDescListWith = [aaronAndErinAlley1]
;

+++ AskTellShowTopic [erin, aaron]
    "<q>What do you study?</q> you ask.
    <.p><q>Electrical engineering,</q> she says. <q>Both of us are
    double-E's, actually.</q><.reveal aaron-erin-major> "
;
++++ AltTopic
    "<q>This stack looks perfect for a double-E,</q> you say.
    <.p><q>Maybe, but Brian's a physicist.  They don't think like
    engineers.  It's probably some elaborate joke where it looks
    electronic but there's really a Maxwell top inside or something.</q> "
    isActive = (gRevealed('aaron-erin-major') && room4Sign.described)
;

/* a master stack-related topic for Erin */
+++ AskTellShowTopic, SuggestedAskTopic
    [blackBox, ddTopic, stackTopic, stamerStackTopic]
    "<q>Any ideas on solving the stack yet?</q> you ask.
    <.p><q>Not yet,</q> Erin says. "

    name = 'the stack'
;

+++ AskTellAboutForTopic @labKey
    "<q>Do you know what happened to the key?</q>
    <.p><q>Yeah, I have it,</q> she says.  <q>We'll probably
    go to the lab pretty soon.  We can all go together, if
    you want.</q><.reveal erin-has-key> "
;

++++ AltTopic
    "<q>Could I have the key?</q> you ask.
    <.p><q>I'll hang onto it, if you don't mind,</q> she says.
    <q>You guys can come with us to the lab, though.</q> "
    isActive = (gRevealed('erin-has-key'))
;

+++ AskTellTopic @stamerLabTopic
    "<q>When are you going to the lab?</q> you ask.
    <.p>Erin and Aaron look at each other, and both shrug.
    <q>Later, I guess,</q> she says. "
    isActive = (gRevealed('erin-has-key'))
;

+++ DefaultAnyTopic
    "You doubt she'd be very interested in talking about anything
    apart from the stack right now. "
    isConversational = nil
;

+++ ConversationReadyState
    isInitState = true
    specialDescListWith = [aaronAndErinAlley1]
    stateDesc = "She's examining the black box. "

    /* 
     *   Erin and Aaron are always paired for conversation state.  We let
     *   Aaron drive the whole thing, so the only thing we need to do is
     *   call the enter-converation routine in Aaron's state object.  
     */
    enterConversation(actor, entry)
        { aaron.curState.enterConversation(actor, entry); }
;

/* a custom list group for Aaron and Erin when they're in alley 1 */
++ aaronAndErinAlley1: ListGroupCustom
    showGroupMsg(lst)
    {
        if (aaron.introduced)
            "Aaron and Erin are here, talking quietly about the stack. ";
        else
            "Two students are looking at the black box, and talking quietly
            to each other.  One is a tall, skinny guy with frizzy red hair;
            the other is a short blonde woman. ";
    }
;

/* a separate set of states for when we're working on the Upper 7 stack */
++ InConversationState
    specialDescListWith = [aaronAndErinUpper7]
;
+++ AskTellGiveShowTopic [efficiencyStudy37Topic, efficiencyStudy37]
    "As much as you'd like to expose Mitachron's evil plans to the
    world, you have a feeling that there are better places to start. "

    isConversational = nil
;
+++ AskTellTopic @posGame
    "<q>Do you know anything about the Positron game downstairs?</q>
    you ask.
    <.p><q>Not really,</q> she says.  <q>I'm not too into those retro
    video games.</q> "
;
+++ AskTellTopic @scottTopic
    "<q>Have you seen Scott around?</q> you ask. <q>The guy who owns the
    Positron machine downstairs?</q>
    <.p><q>I think he's doing the giant chicken stack,</q> she
    says. <q>Alley 3.</q> "
;
+++ AskForTopic @scottTopic
    topicResponse() { replaceAction(AskAbout, gDobj, scottTopic); }
;
+++ AskTellTopic @jayTopic
    "<q>Have you seen Jay Santoshnimoorthy today?</q> you ask.
    <.p><q>I think he was working on the stack in Alley Four,</q> she says. "
;
+++ GiveShowTopic @calculator
    "She glances at the calculator and hands it back. <q>If you
    have time, you should show it to Jay Santoshnimoorthy and
    see what tricks he can do with it.</q> "
;
+++ AskTellShowTopic [ddTopic, paulStackTopic, commandant64]
    "<q>How's the stack coming?</q> you ask.
    <.p><q>Too early to tell,</q> she says. <q>We're not quite sure
    what's going on yet.</q> "
;
+++ AskTellAboutForTopic [physicsTextTopic, bloemnerBook, drdTopic]
    "<q>What's the best place around here to find textbooks?</q> you ask.
    <.p><q>I'd try Millikan,</q> Erin says. <q>The bookstore usually
    doesn't stock much this time of year.</q> "
;
+++ AskTellAboutForTopic +90
    [eeTextbookRecTopic, eeTextTopic, morgenBook,
     eeLabRecTopic, labManualTopic, townsendBook]

    topicResponse()
    {
        "<q>You're double-E's, right?</q> you ask.  The two nod. <q>I was
        wondering if you had any recommendations for a good EE text.
        Something I could use as a refresher.</q>
        <.p><q>Well,</q> Erin says, <q>I thought the book we used in
        EE twelve was good.  Um, somebody Morgen, I think.</q>
        <.p>Aaron nods. <q>Yves Morgen.  Very readable.  Spelled
        M-O-R-G-E-N.</q><.reveal morgen-book> ";

        /* award some points for this */
        morgenBook.recMarker.awardPointsOnce();
    }
;
++++ AltTopic
    "<q>Any other double-E text recommendations?</q> you ask.
    <.p>Erin shakes her head. <q>The ones I'm using this year are
    crap.  I thought the Morgen book was pretty good.</q> "

    isActive = (gRevealed('morgen-book'))
;
+++ AskTellTopic @qubitsTopic
    "<q>Do you know what <q>QUBITS</q> means?</q> you ask.
    <.p><q>I think it's some kind of quantum computing thing,</q> she
    says. "
;
+++ AskTellTopic @quantumComputingTopic
    "<q>What do you know about quantum computing?</q> you ask.
    <.p><q>It's a hot topic around here these days,</q> she says,
    <q>but I haven't really looked at it much.</q> "
;
+++ DefaultAnyTopic
    "She seems pretty focused on the stack right now. "
    isConversational = nil
;
    
+++ erinUpper7: ConversationReadyState
    stateDesc = "She's studying the computer screen. "
    specialDescListWith = [aaronAndErinUpper7]

    /* we're paired with Aaron for conversation, so let him handle it */
    enterConversation(actor, entry)
        { aaron.curState.enterConversation(actor, entry); }
;

/* a custom list group for Aaron and Erin when they're in Upper 7 */
++ aaronAndErinUpper7: ListGroupCustom
    showGroupMsg(lst)
    {
        "Aaron and Erin are here, huddled around the personal computer. ";
    }
;

/* a separate set of states for the breezeway around lunchtime */
++ erinBreezeway: InConversationState
    nextState = erinBreezeway
    stateDesc = "She's standing here talking to you.  She keeps
        glancing over at the alley. "
    specialDescListWith = [aaronAndErinBreezeway]
;

++ ConvNode 'erin-smoke'
    npcGreetingMsg = "Aaron and Erin walk in from the courtyard,
        and peer cautiously into the alley.  Erin sees you and
        comes over.  <q>What happened?</q> she asks. "

    npcContinueList: StopEventList { [
        'Erin joins Aaron for a moment near the alley entrance,
        then returns. <q>What a mess,</q> she says. ',

        &inviteToLunch ]

        /* invite the PC to lunch */
        inviteToLunch()
        {
            "Aaron comes over to join you and Erin. <q>See anything?</q>
            Erin asks.
            <.p>Aaron shakes his head. <q>No.  Only smoke.</q>
            <.p>Erin turns to you. ";

            if (gRevealed('lunch-invite'))
                "<q>We're heading over to lunch now, if you want to
                join us. ";
            else
                "<q>We were just on our way to lunch.  You should
                join us. ";

            "You can tell us about Brian's stack.</q><.convnode> ";
            erin.goToLunch();
        }
    }

    endConversation(actor, reason)
    {
        "<q>By the way,</q> Erin says, <q>we're on our way to lunch.
        You should join us if you want.</q> ";

        erin.goToLunch();
    }
;
+++ TellTopic, SuggestedTellTopic
    [ddTopic, stackTopic, blackBox, stamerStackTopic, explosionTopic, bwSmoke]
    "<q>I'm not really sure what happened,</q> you say. <q>There was
    some kind of explosion, I think.  I'm pretty sure it was the
    Mitachron equipment.</q>  Erin nods.<.convstay> "

    name = 'the explosion'
;
+++ AskTellTopic, StopEventList @lunchTopic
    ['<q>Any ideas for where I can get lunch?</q> you ask.
    <.p><q>We\'re just going to eat here,</q> Erin says. <q>You should
    join us.  The dining room\'s right over there.</q>  She points
    across the courtyard to the east.<.reveal lunch-invite><.convstay> ',

     '<q>You said you\'re going to eat lunch here?</q> you ask.
     <.p><q>Right, in the dining room,</q> she says, pointing
     across the courtyard to the east.<.convstay> ']
;

+++ DefaultAnyTopic
    "Something in the alley distracts her just as you start to
    talk, and she seems to miss what you were saying.<.convstay> "
    isConversational = nil
;

/* a custom list group for Aaron and Erin for the breezeway at lunchtime */
++ aaronAndErinBreezeway: ListGroupCustom
    showGroupMsg(lst) { "Erin is standing here talking to you.
        Aaron's trying to see what's going on in the alley. "; }
;

/* a custom list group for Aaron and Erin in the dining room at lunch */
++ aaronAndErinLunch: ListGroupCustom
    showGroupMsg(lst) { "Erin and Aaron are sitting at the table
        eating their lunch. "; }
;

/* a separate set of states for the dining room at lunchtime */
++ erinLunch: ActorState, AaronErinConvList, EventList
    nextState = erinLunch
    stateDesc = "She's sitting at the table eating lunch. "
    specialDescListWith = [aaronAndErinLunch]

    eventList = [
        nil,
        'Aaron tries to cut in half a particularly tough meat puck,
        but can\'t make a dent.  He gives up and eats it whole. ',
        &askAboutOmegatron
    ]

    askAboutOmegatron()
        { erin.initiateConversation(nil, 'erin-ask-omegatron'); }
;

+++ HelloTopic
    "You make some smalltalk with Erin. "
;

/* BYE depends on whether we've seen the whole lunch conversation yet */
+++ ByeTopic, StopEventList
    ['<q>I\'d better get back to my stack,</q> you say.
    <.p><q>Already?</q> Erin asks. <q>Come on, stay a while.  They
    probably don\'t even have the fire out yet.</q> ',

     '<q>I should be going,</q> you say.
     <.p><q>You should at least finish,</q> Erin says. ']
;
++++ AltTopic
    topicResponse()
    {
        /* we're done with lunch, so just leave */
        replaceAction(South);
    }
    isActive = (dabneyDining.endOfLunchNoted != 0)
;

+++ AskTellShowTopic @myLunch
    "<q>Is the food always this bad?</q> you ask.
    <.p><q>This?</q> Erin asks.  <q>This isn't that bad.  You
    should see dinner.</q> "
;

+++ AskTopic [stackTopic, ddTopic, paulStackTopic, commandant64]
    "<q>How's your stack coming?</q> you ask.
    <.p>Erin shrugs. <q>We haven't cracked it yet.  It's obviously
    some kind of code, but we're not sure what kind.</q> "
;

+++ AskTellTopic, SuggestedTellTopic [blackBox, ddTopic, stamerStackTopic]
    "You tell Erin a bit about your attempts to solve the stack,
    and how you've had to re-learn a lot of basic EE stuff.
    You also mention the equipment and personnel that Belker's
    brought in.
    <.p><q>That doesn't seem fair,</q> Erin points out.  You
    have to agree, it <i>doesn't</i> seem fair; but it doesn't
    technically seem to be against the rules of the stack. "

    name = 'the stack'
;

+++ TellTopic, StopEventList @omegatronTopic
    ['You tell Erin some generic background facts about Omegatron,
    and you catch yourself sounding like a corporate positioning
    brochure.  You\'re not sure how specific you want to get about;
    you could talk about lots of details, like your job, your
    products, your boss, the company\'s bureaucracy... ',

     'You\'ve already given her the generic background, and
     you\'re not sure how much detail she really wants to hear.
     There are lots of things you could talk about, like your job,
     your products, your boss, the bureaucracy... ']

    name = 'Omegatron'
;

+++ TellTopic +90 @mitachronTopic
    "You always feel like it's bad form to trash the competition,
    but you can't help yourself from making fun of some of their
    more infamous products.  You also tell Erin some of the things
    you've heard about working there, such as how some departments
    make their engineers wear paper hats showing their rank. "
;

+++ AskTellShowTopic @aaron
    "<q>Is it just my imagination, or do you two spend a lot of
    time together?</q> you ask.
    <.p>Erin shrugs. <q>It's our names, truth be told.  There was
    all this confusion about whether someone was talking about
    Aaron with an A or Erin with an E, so we just figured it'd be
    easier if we went everywhere together.</q> "
;

+++ AskTellTopic, StopEventList @erin
    ['<q>Where did you grow up?</q> you ask.
    <.p><q>Here in So Cal,</q> she says. <q>Orange County, actually.
    Behind the orange curtain, as they say.</q> ',

     '<q>What do you do in your spare time?</q> you ask.
     <.p><q>Spare time?</q> she says, laughing sarcastically.
     <q>What a nice concept.</q> ',

     'You make some more smalltalk. ']
;

+++ AskTellTopic 'orange (county|curtain)'
    "<q>What's Orange County like?</q> you ask.
    <.p>She shrugs. <q>It's like anywhere else, really.  Just
    moreso.</q> "
;

+++ TellTopic @jobTopic
    "You tell Erin a bit about your job as an engineering manager.
    You try to make it sound interesting, but you feel like you're
    failing miserably.  As you talk about it, you realize that most
    of your job involves working around corporate stupidity: getting
    approvals even though your VP is never around, satisfying weird
    edicts from on high without derailing real work, shuffling budgets
    that make absolutely no sense...
    <.p><q>So why do you stay?</q> Erin finally asks.
    <.reveal erin-asked-why-stay><.topics> "
;

+++ TellTopic [productsTopic, scu1100dx]
    "You tell Erin a bit about Omegatron's products.  You even
    describe the SCU-1100DX, even though you've heard that program
    is likely to be canceled.  Erin listens attentively, but you're
    sure she's just feigning interest; Omegatron hasn't had a
    cutting-edge product in years. "
;

+++ TellTopic @bossTopic
    "You relate a couple of humorous stories about your VP's
    legendary cluelessness about the business.  <q>People who
    know too much know all the reasons you <i>can't</i>,</q>
    he's fond of saying; <q>my job is to say, <i>why not?</i></q>
    You always have to restrain yourself from suggesting that if
    that's his job description, the company could save a lot of
    money by replacing him with a trained parrot.
    <.p><q>I'm surprised you put up with it,</q> Erin says.
    <.reveal erin-asked-why-stay><.topics> "
;

+++ TellTopic @bureaucracyTopic
    "You tell Erin about how bureaucracy is the one area where
    Omegatron really overachieves, how it has enough bureaucracy
    for a company ten times its size.  You can go on all day about
    the departmental turf wars, the ridiculous policies that are
    always applied so rigidly that they achieve the opposite of
    the intended effect; and from Erin's glazed expression, you
    realize that you <i>have</i> been going on all day about it.
    <.p><q>Why don't you find another job?</q> Erin asks.
    <.reveal erin-asked-why-stay><.topics> "
;

+++ DefaultAnyTopic, ShuffledEventList
    ['Erin is intently examining part of her lunch, her expression
    showing equal parts curiosity and revulsion.  She seems to miss
    what you were saying. ',
    'The ambient noise level in the room rises just as you start
    talking, and Erin doesn\'t seem to hear you. ',
    'Erin doesn\'t seem too interested in that. '
    ]

    isConversational = nil
;

/* 
 *   Topic group for explaining why we stay at omegatron.  We open this up
 *   when Erin asks about why we stay, and leave it open as long as lunch
 *   is going. 
 */
+++ TopicGroup
    isActive = (gRevealed('erin-asked-why-stay') && !gRevealed('after-lunch'))
;

++++ TellTopic @mitachronTopic
    "<q>I actually looked at a job at Mitachron at one point,</q>
    you tell her.  However annoying Omegatron has been at times,
    you really have no regrets about passing on that Mitachron job.
    Sure, the stock options would have been worth a fair amount by
    now, but the more you learn about Mitachron the less you like
    them.  <q>That's one job I'm glad I passed up.</q> "
;

++++ TellTopic, SuggestedTellTopic @otherJobOffersTopic
    "<q>Actually, I have had a few offers over the years from other
    companies,</q> you say.  Thinking back, it's hard to remember
    exactly why you never took any of those offers.  Each one had
    some flaw, you're sure; staying put certainly has had its own
    problems, but better the devil you know, as they say.  But was
    it really fear of the unknown that always stopped you?  You have
    a nagging feeling that it wasn't, that it was another sort of
    fear: fear that whatever success you've had at Omegatron has
    been a fluke, and that you wouldn't be able to reproduce it
    elsewhere.  <q>I guess I just never found an opportunity good
    enough to tear me away.</q>
    <.reveal lunch-satisfied-1> "

    name = 'other job offers'
;

++++ TellTopic, SuggestedTellTopic @startupsTopic
    "<q>I have looked at a few start-ups over the years,</q> you say,
    <q>but they always seemed kind of risky.</q>  You've always liked
    the idea of working for a smaller company---a chance to build
    something from the ground up, without all the big-company overhead.
    Sure, start-ups are risky.  But thinking about it now, you have to
    wonder if the risk that really worried you wasn't something more
    personal: fear that you wouldn't be good enough, that your years
    at the big company made you too soft.
    <.reveal lunch-satisfied-1> "

    name = 'start-up companies'
;

/* conversation node for asking about omegatron at lunchtime */
++ ConvNode 'erin-ask-omegatron'
    npcGreetingMsg = "Erin gives up on a bluish-green glob, pushing
        it aside.  <q>What's Omegatron like?</q> she asks. "

    npcContinueList: ShuffledEventList { [
        '<q>I\'m curious what Omegatron\'s like,</q> Erin says. ',
        '<q>I don\'t know too much about Omegatron,</q> Erin says. ',
        '<q>Tell us about Omegatron,</q> Erin says. ' ] }
;
+++ TellTopic, SuggestedTellTopic @omegatronTopic
    "You're not sure how to answer such an open question; you could
    tell her about your job, your products, your boss, the
    bureaucracy...\ everything that comes to mind seems just a
    little negative.  <q>We're a leading electronics manufacturer,</q>
    you say, as though reading from a brochure.  But you can't seem
    to stop yourself.  <q>We provide a diversified line of
    industry-leading products, along with related consulting and
    support services.</q> "

    name = 'Omegatron'
;

/* a separate set of conversation states for the endgame */
++ erinRoom4: ActorState
    stateDesc = "She's checking out the snacks. "
    specialDescListWith = [aaronAndErinRoom4]
;

+++ AskTopic [stackTopic, ddTopic, paulStackTopic, commandant64]
    "<q>Did you solve your stack?</q> you ask.
    <.p><q>Yeah,</q> she says. <q>It's a good puzzle.  I won't
    spoil it for you, in case you want to go back and try it
    yourself.</q> "
;
+++ TellTopic [stackTopic, ddTopic, blackBox, stamerStackTopic]
    "Aaron and Erin listen attentively as you explain your
    adventures solving Stamer's stack. "
;

+++ DefaultAnyTopic
    "She can't seem to hear you over the noise of the crowd. "
    isConversational = nil
;

+++ InitiateTopic @stackTopic
    "Aaron and Erin make their way into the room.  They see you
    and come over to say hello.
    <.p><q>Congratulations on solving the stack,</q> Erin says.
    She and Aaron then wander over to the snacks. "
;

/* a custom list group for Aaron and Erin when we're in room 4 */
++ aaronAndErinRoom4: ListGroupCustom
    showGroupMsg(lst) { "Aaron and Erin are standing near the snacks. "; }
;

/* ------------------------------------------------------------------------ */
/*
 *   The movers.  These guys show up near the start of the stack discovery
 *   section, after we meet Aaron and Erin.  
 */
+ a1nMovers: MitaMovers
    "A number of the movers are unpacking crates and arranging
    equipment taken from the crates.  Others continue arriving with
    more boxes, putting them where Belker directs and then turning
    around to go get more. "

    "Several Mitachron movers are here, unpacking their boxes and
    crates.  Others keep arriving, dropping off their loads, and
    leaving. "

    /* 
     *   list the movers early, before the other specialDesc items - we
     *   want them to show up before the piles of stuff they're unloading 
     */
    specialDescBeforeContents = true
    specialDescOrder = 90
;

+ equipInAssembly: PresentLater, Immovable
    'unassembled electronics mitachron equipment/piles'
    'Mitachron equipment'
    "With all of the activity going on, you can't get close enough
    to get a good look at anything.  It just looks like a lot of
    unassembled electronic equipment right now. "

    specialDesc = "Piles of unassembled equipment are starting to
        stack up around Belker as the movers unpack their loads.
        The alley is becoming quite difficult to move through. "

    /* this is part of the MitaMovers 'makePresent' group */
    plKey = MitaMovers

    lookInDesc = "You casually look over the equipment, but there
        are too many Mitachron people around for you to be able to
        get a detailed look. "
;

/* ------------------------------------------------------------------------ */
/*
 *   The Mita Test Ultimate Pro 3000.  The Mita Test and its gaggle of
 *   technicians are around for the first half or so of solving the stack.
 *   These guys are reverse-engineering the black box for Belker.  The Mita
 *   Test and its technicians are removed in the lunchtime blowout, to be
 *   replaced with the Mitavac.  
 */
+ mitaTestPro: PresentLater, Heavy
    'oversized bright yellow ultra-modern huge
    mitatest ultimate pro industrial double platinum
    super 3000 mainframe (type)/machine/megatester/lettering/computer'
    'MegaTester 3000'
    "Oversized lettering, in ultra-modern bright yellow type,
    proudly announces the machine's name: the MitaTest Ultimate Pro
    Industrial Double Platinum Super MegaTester 3000.
    <.p>
    You've heard of these, but you've never seen one before; you've heard
    that only about a dozen have ever been built.  About the size of a
    minivan, it doesn't leave a lot of room for the several technicians
    here busily tending to it.
    <.p>
    The 3000 is supposed to have a database of every chip produced
    in the last thirty years, even custom parts, and they say it can
    detect a defective chip from twenty feet away.  It reduces the most
    intricate electronic detective work to a simple matter of reading
    a monitor.  Stamer's black box doesn't stand a chance against this
    thing. "

    plKey = 'pro3000'

    specialDesc = "A huge machine reminiscent of a 1960s
        mainframe computer nearly blocks the hall, leaving barely
        enough space to get past.  Several technicians are busily
        operating it. "
;
++ Component
    '(megatester) (3000) monitor/monitors'
    'MegaTester monitors'
    "The MegaTester has numerous monitors, but you don't know anything
    about how to interpret the displayed information. "
    isPlural = true
;
++ Component
    '(megatester) (3000) controls' 'MegaTester controls'
    "The MegaTester is as laden with controls as the flight deck of
    a airliner, and they make about as much sense to you. "
    isPlural = true
;

+ mitaTestOps: PresentLater, Person 'mitachron technicians' 'technicians'
    "They're all wearing long white lab coats.  They're busily operating
    operating the MegaTester 3000, as Belker watches closely.  The
    intense supervision is obviously making them nervous. "
    isPlural = true
    isHim = true
    isHer = true

    plKey = 'pro3000'

    /* we don't need a special desc, as the MegaTester mentions us */
    specialDesc = ""
;
++ mitaTestOpsCoats: InitiallyWorn
    'technicians\' knee-length long white lab coat/coats' 'lab coats'
    "The technicians are wearing knee-length white lab coats. "
    isPlural = true
    isListedInInventory = nil
;

++ DefaultAnyTopic, ShuffledEventList
    ['You try to talk to one of the technicians, but he nervously
    looks the other way. ',
     'You can\'t seem to get anyone\'s attention. ',
     'The technicians feverishly work the equipment, ignoring you. ']
;

/* ------------------------------------------------------------------------ */
/*
 *   Xojo is one of the technicians operating the MegaTester; we notice
 *   him after a bit.  We use a separate object for Xojo in this segment
 *   of the game from the one we used in the introduction, since at an
 *   implementation level there's not much in common.  
 */
+ xojo2: PresentLater, Person 'probationary 119297 xojo/(employee)' 'Xojo'
    "Xojo is a twenty-something Asian fellow, slightly taller than
    you and very thin.  He's wearing a knee-length white lab coat. "

    isProperName = true
    isHim = true

    /* 
     *   list xojo after other actors, so that he always follows the
     *   technicians when they're also present (which they essentially
     *   always are when xojo is here) 
     */
    specialDescOrder = 210
;

++ DisambigDeferrer, InitiallyWorn
    'knee-length long white lab coat' 'lab coat'
    "Xojo is wearing a knee-length white lab coat. "

    isListedInInventory = nil

    /* defer to the generic technician lab coat object */
    disambigDeferTo = [mitaTestOpsCoats]
;

++ xojo2Base: ActorState
    isInitState = true
    stateDesc = "He's diligently operating the MegaTester. "
    specialDesc = "One of the technicians working on the machine is Xojo. "
;

++ xojo2Mitavac: ActorState
    stateDesc = "He's working the controls on the Mitavac. "
    specialDesc = "One of the technicians working on the computer is Xojo. "
;

++ xojo2Crowd: ActorState
    stateDesc = "He's standing in the crowd. "
    specialDesc = ""
;
+++ DefaultAnyTopic
    "It's too noisy in here; you can't get his attention. "
;

++ DefaultAnyTopic, ShuffledEventList
    ['Xojo turns just slightly toward you and grimaces, gesturing with
    a twitch of his head toward Belker. ',
     'Xojo gets up and walks toward you, pausing for just a moment
     as he draws up alongside to say <q>He will observe,</q> then
     continues past you. ',
     'Xojo glances at you, shakes his head very slightly, and looks away. ',
     'Before you can get Xojo\'s attention, one of the other technicians
     taps Xojo on the shoulder and starts talking to him. ',
     'As you\'re about to try talking to Xojo, you see Belker glance
     over, so you decide to wait a bit to avoid getting Xojo in trouble. ',
     'Xojo pretends to ignore you. ',
     'Xojo ignores you and moves away slightly. ']
;

/* 
 *   An agenda item for Xojo's re-introduction.  This brings the new xojo
 *   actor into the game, and kicks off a brief conversation.  We schedule
 *   this as soon as the MegaTester and the other technicians are set up,
 *   but we don't let it fire until the player is back here to take part in
 *   the intro conversation.  
 */
++ xojoIntroAgenda: ConvAgendaItem
    isReady = (inherited() && me.isIn(alley1N))
    invokeItem()
    {
        /* 
         *   Wait a couple of eligible turns to fire this.  Note that we
         *   don't use DelayedAgendaItem for this, because that waits a
         *   few turns before even testing for eligibility - we instead
         *   want to wait a few turns after we know we're already eligible
         *   to run. 
         */
        if (invokeCnt++ < 3)
            return;

        /* bring the new xojo into play */
        xojo2.makePresent();

        /* xojo introduces himself */
        "<.p>One of the technicians moves near you,
        fiddling with the controls on the MegaTester. <q>Excuse me,
        Mr.\ Mittling,</q> he says.  You move aside to give him a
        little room to work, but it immediately occurs to you to
        wonder why he called you by name.  You look back to see him
        looking your way, giving you a worried, imploring grin and
        a very slight wave.  You realize it's Xojo, your erstwhile
        assistant/minder from Government Power Plant #6. ";

        /* this counts as xojo initiating a conversation */
        xojo2.initiateConversation(xojo2Intro, nil);

        /* this agenda item is done */
        isDone = true;
    }

    invokeCnt = 0;
;

/* 
 *   a "retry" for the xojo introduction agenda - we'll run this if we walk
 *   out before talking to xojo the first time around 
 */
++ xojoIntroRetryAgenda: ConvAgendaItem
    isReady = (inherited() && me.isIn(alley1N))
    invokeItem()
    {
        /* xojo introduces himself */
        "<.p>Xojo moves near you and gestures at you like he wants
        to talk to you, but he keeps himself turned away from you. ";

        /* this counts as xojo initiating a conversation */
        xojo2.initiateConversation(xojo2Intro, nil);

        /* this agenda item is done */
        isDone = true;
    }
;

/*
 *   A state for Xojo's re-introduction.  Xojo initiates the conversation,
 *   and then will respond to anything with the default response here.
 *   When we show that response, it will attract Belker to join in, so
 *   we'll initiate another conversation with Belker at that point.  
 */
++ xojo2Intro: InConversationState
    attentionSpan = nil
    stateDesc = "He's discreetly trying to attract your attention. "
    specialDesc = "Xojo is standing near the MegaTester, discreetly
        trying to attract your attention. "

    /* 
     *   on leaving this state, re-introduce the 'introduction' agenda item
     *   if we didn't finish the conversation 
     */
    deactivateState(actor, newState)
    {
        /* do the normal work first */
        inherited(actor, newState);

        /* rerun the 'introduction' agenda if we're not talking to xojo */
        if (newState != xojo2Intro2)
            xojo2.addToAgenda(xojoIntroRetryAgenda);
    }
;
+++ DefaultAnyTopic
    topicResponse()
    {
        "<q>Xojo!</q> you say. <q>What are you doing here?</q>
        <.p>He keeps himself turned to the MegaTester and speaks
        softly, furtively. <q>The Mitachron company was most
        generous in offering employment to me after their visit
        to Government Power Plant number 6.</q> He moves a little
        closer, pretending to work on controls nearer to you, and
        lowers his voice even more. <q>However, I wish to request
        most urgently your assistance in gaining employment at
        your wonderful Omegatron company.  The Mitachron is much
        more horrible than the Omegatron, I am sure.</q>  He nods
        rapidly.  <q>The very convincing employment brochure does
        not accurately portray the great resemblance in unpleasantness
        to a penal institution.  We are required to sing corporate
        motivational songs during morning arrival period.  At
        lunchtime&mdash;</q> ";

        /* switch to the pretending-to-be-invisible state */
        xojo2.setCurState(xojo2Intro2);

        /* initiate the conversation with Frosst */
        frosst.initiateConversation(frosstAlleyConv, 'meet-xojo');
    }
;

/* a new state we reach after Belker comes over during our introduction */
++ xojo2Intro2: InConversationState
    attentionSpan = nil
    stateDesc = "He seems to be trying to be invisible. "
    specialDesc = "Xojo is standing near the MegaTester.  He's facing
        away from you and Belker, like he's trying to be invisible. "

    /* when we're done, return to the base state */
    nextState = xojo2Base
;
+++ DefaultAnyTopic
    "Xojo is plainly trying hard to be invisible right now. "
;

/* ------------------------------------------------------------------------ */
/*
 *   The Mitavac 3000.  This shows up after the lunchtime blowout; it
 *   replaces the Mita Test Pro, but serves essentially the same scenery
 *   function.  We just change things to provide a little variety, and
 *   because it makes more sense in the plot for Frosst to have figured out
 *   what the black box does and to have moved on to solving its math
 *   puzzle.  
 */
+ mitavac: PresentLater, Heavy
    'top-end mainframe mitavac gray grey 3000
    computer/supercomputer/unit/units/nameplate'
    'Mitavac 3000'
    "It's a series of gray refrigerator-sized units, lined up
    side by side along one wall.  The nameplate identifies it as
    a Mitavac 3000, which you recognize as Mitachron's high-end
    mainframe supercomputer.  You don't remember the detailed stats
    on this model, but you know it's fast; it's the sort of computer
    one uses these days if one is predicting the weather, simulating
    thermonuclear explosions, or adding up Mitachron's quarterly
    profits. "

    plKey = 'mitavac'
;
++ Component
    '(mitavac) (mainframe) (computer) (3000) blinking
    control/controls/knob/knobs/switch/switches/array/light/lights'
    'Mitavac controls'
    "The computer has an array of knobs and switches and blinking
    lights.  You wouldn't have any idea how to use any of them, even
    if the technicians would let you get anywhere near them. "
;
++ SimpleNoise 'low throbbing hum/sound/noise' 'throbbing sound'
    "The Mitavac is emitting a low throbbing hum. "
;

+ mitavacTechs: PresentLater, Person
    'mitachron technicians' 'technicians'

    /* 
     *   note that we use no description here; we get it entirely from the
     *   state object 
     */
    desc = ""

    isPlural = true
    isHim = true
    isHer = true

    plKey = 'mitavac'
;
++ InitiallyWorn
    'technicians\' knee-length long white lab coat/coats' 'lab coats'
    "The technicians are wearing knee-length white lab coats. "
    isPlural = true
    isListedInInventory = nil
;

++ DefaultAnyTopic, ShuffledEventList
    ['You try to talk to one of the technicians, but he nervously
    looks the other way. ',
     'You can\'t seem to get anyone\'s attention. ',
     'The technicians feverishly work the equipment, ignoring you. ']
;

++ ActorState
    stateDesc = "The technicians are all wearing long white lab coats.
        They're busily operating the Mitavac 3000. "
    specialDesc = "A huge mainframe computer fills the hall, leaving
        very little space to pass.  Several Mitachron technicians are
        standing near it, working the controls. "

    isInitState = true
;

++ mitaTechCrowd: ActorState
    stateDesc = "The technicians are all wearing long white lab coats.
        They're standing in the crowded hall. "
    specialDesc = "A huge mainframe computer fills the hall, leaving
        very little space to pass.
        <.p>A crowd has formed in the alley---mostly students, but
        the Mitachron technicians are mixed in, including Xojo.  So
        many people are here that there's barely any space to move.
        They're all standing around talking. "
;
+++ DefaultAnyTopic
    "You can't get anyone's attention over all the noise. "
;

/* ------------------------------------------------------------------------ */
/*
 *   The crowd of students that shows up after we solve the stack 
 */
+ alley1Crowd: PresentLater, Actor
    'crowd/student/students' 'crowd'
    "A couple dozen students, along with the Mitachron technicians,
    are milling around in the alley, going in and out of room 4. "
;
++ DefaultAnyTopic
    "There's a lot of noise; you have a hard time making yourself
    heard. "
;
++ SimpleNoise
    'crowd noise/talking/babble/conversation' 'crowd noise'
    "The alley is filled with a continuous babble of conversation from
    the crowd. "
;

/* ------------------------------------------------------------------------ */
/*
 *   An agenda item for Frosst to bribe the techers hanging around the
 *   stack initially, so that they'll go find something else to do. 
 */
bribeStudents: DelayedAgendaItem
    /* 
     *   We want the PC to see this happen, so only fire when the PC is
     *   here.  We also only want to fire this when the PC hasn't been
     *   talking to anyone else this turn, so that we don't interrupt the
     *   rest of the conversation.  
     */
    isReady = (inherited
               && me.isIn(frosst.location)
               && !me.conversedThisTurn())

    invokeItem()
    {
        "<.p>Frosst rotates his cell phone away from his mouth, still
        holding it to his ear. <q>Excuse me,</q> he says to Aaron and
        Erin, ";

        if (gRevealed('aaron-erin-major'))
            "<q>but did I overhear you two say you were studying electrical
            engineering?</q>
            <.p>They look at Belker and nod. ";
        else
            "<q>might I ask what subject you two young people are
            studying at this university?</q>
            <.p><q>We're both double-E's---electrical engineers,</q>
            Erin says. ";

        "<.p><q>Then surely you have encountered the Pauli principle of
        exclusion,</q> he says.  Erin and Aaron look at each other,
        confused. <q>The principle that allows semiconductors to function
        and makes all modern electronics possible?  Well.  I mention this
        because it seems we have our own exclusion principle of sorts.
        In our case, it is not electrons that interest us but we
        several persons, who will presently find it difficult to
        occupy the same space while working on the same...\ stack.  This
        is why I would like to offer you a certain sum, merely for
        finding another stack to pursue.  There are many, I understand.</q>
        <.p>Erin looks insulted. <q>You think you can just buy us off?</q>
        <.p>Belker uses his shoulder to pin the cell phone to his ear
        and reaches into his pocket, taking out a wad of cash.
        <q>It is more of the nature of a token in recompense,</q> he
        says.  <q>A collection of large equipment will be arriving
        presently, which will make this hallway cramped and
        unpleasant.  My offer is by way of apology for the
        inconvenience I am sure to cause.  Perhaps a fair amount would
        be, hmm, five dollars?</q>
        <.p>Aaron and Erin look at each other incredulously. <q>Five
        dollars?</q> Erin asks.
        <.p><q>Five dollars <i>each</i>, of course.</q>
        <.p><q>Whoa!</q> says Aaron.
        <.p>The two happily accept the money and start to leave, but
        Erin abruptly halts, turns around, and takes out a key.
        <q>I guess I won't be needing this,</q> she says, tossing you
        the key.  Then they race off down the hall.  You glance
        at the key and see that it's labeled <q>Lab.</q> ";

        /* give me the key; put it on the keyring if convenient */
        if (myKeyring.isIn(me) && me.canTouch(myKeyring))
        {
            "You put it on your keyring to make sure you don't lose it. ";
            labKey.moveInto(myKeyring);
        }
        else
            labKey.moveInto(me);

        /* keep track of the departure for 'follow' purposes */
        me.trackFollowInfo(aaron, alley1N.south, alley1N);
        me.trackFollowInfo(erin, alley1N.south, alley1N);

        /* 
         *   move aaron and erin to Upper 7 north, where they'll find
         *   another stack to work on 
         */
        aaron.moveIntoForTravel(upper7N);
        erin.moveIntoForTravel(upper7N);
        aaron.setCurState(aaronUpper7);
        erin.setCurState(erinUpper7);

        /* schedule the start of the equipment arrival */
        frosst.addToAgenda(equipArrival.setDelay(2));

        /* this agenda item is completed */
        isDone = true;
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   An agenda item to begin the arrival of frosst's equipment. 
 */
equipArrival: DelayedAgendaItem
    invokeItem()
    {
        /*
         *   Belker's equipment arrival spans several locations: the orange
         *   walk, the breezeway, and alley 1 north and south.  Generate an
         *   appropriate message in each location (with the sense context
         *   limiting each report to its location), so that we hear about
         *   it no matter where we are among these locations.
         *   
         *   Given the timed conditions that initiate this agenda item, we
         *   can't actually get farther than the breezeway, so we don't
         *   actually need to report anything on the orange walk.  However,
         *   do so anyway for completeness; this will ensure we have
         *   something there if we change the timer in the future.  
         */
        callWithSenseContext(orangeWalk, sight, new function() {
            "<.p>A line of movers carrying boxes and crates marches
            up from California Boulevard.  As they walk by, you see
            that their uniforms bear the Mitachron logo.  They head
            into Dabney, as others follow with more boxes. "; });

        callWithSenseContext(dabneyBreezeway, sight, new function() {
            "<.p>Several movers carrying boxes and crates come in
            from the Orange Walk, look around briefly, then head into
            the north hallway.  As they trudge into the hallway, you
            see that their uniforms bear the Mitachron logo.  More
            movers arrive behind them. "; });

        callWithSenseContext(alley1S, sight, new function() {
            "<.p>A few movers carrying boxes and crates walk in
            through the south doorway.  They brusquely maneuver
            their bulky loads around you and continue up the alley to
            the north.  As they go past, you see the Mitachron logo
            on their uniforms.  More movers follow them. "; });

        callWithSenseContext(alley1N, sight, new function() {
            "<.p>Several movers carrying boxes and crates come up
            the alley from the south.  You notice that their
            uniforms bear the Mitachron logo.  Belker puts away his cell
            phone and exchanges a few words with the movers, pointing
            out where they should put their loads.  A couple of the
            movers set about opening boxes, and the others turn around
            and head back down the alley as more movers arrive.
            Belker stands in place, pointing and issuing orders like a
            traffic cop, the movers a mass of motion around him. "; });

        /* get all the movers into place */
        PresentLater.makePresentByKey(MitaMovers);

        /* set frosst into unpacking mode */
        frosst.setCurState(frosstUnpacking);
        frosstCellPhone.moveInto(nil);

        /* we only need to run once */
        isDone = true;
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   Room 4
 */
room4: Room 'Room 4' 'room 4' 'room'
    "The room has the cluttered yet spartan look of a student room.
    It's a single, so it's small; not quite so small that you can
    touch opposing walls at the same time, but close enough. Packed
    into the seventy or so square feet are a desk, a chair, and a bed.
    Bookshelves cover the wall above the desk.  A door leads out
    to the alley. "

    vocabWords = '4 room four'

    east = r4Door
    out asExit(east)

    afterTravel(trav, conn)
    {
        /* bring the crowd into the room when we first arrive */
        if (!r4Crowd.isIn(self))
        {
            r4Crowd.makePresent();
            "Some of the students and technicians follow you into the
            room to help celebrate.  They head straight for the snacks
            and start digging in. ";
        }
    }

    /* we have some scripted events that occur after we enter the room */
    atmosphereList: EventList { [
        nil,
        'A couple more students make their way into the room. ',
        &aaronErinArrival,
        'A couple of the technicians make their way out into the hall. ',
        nil,
        &stamerArrival ]

        /* aaron and erin arrive */
        aaronErinArrival()
        {
            /* bring them in */
            aaron.moveIntoForTravel(room4);
            erin.moveIntoForTravel(room4);
            aaron.setCurState(aaronRoom4);
            erin.setCurState(erinRoom4);

            /* say hello */
            erin.curState.initiateTopic(stackTopic);
        }

        /* stamer arrives */
        stamerArrival()
        {
            /* bring him in */
            stamer.moveIntoForTravel(room4);

            /* say hello */
            stamer.initiateConversation(nil, 'stamer-hello');
        }
    }

;

+ r4Door: Door ->room4Door '(room) (4) room/door*doors' 'door'
    "It's a wooden door leading out to the alley. "

    /* don't allow leaving once we enter */
    canTravelerPass(trav) { return nil; }
    explainTravelBarrier(trav) { "You can't get past all the people
        crowded around the door. "; }
;

+ r4Crowd: PresentLater, Person
    'mitachron crowd/student/students/technician/technicians' 'crowd'
    "The crowd is a mix of students and Mitachron technicians.
    There's only room for a few people at a time in here, so
    they're milling in and out of the room. "

    specialDesc = "Part of the crowd from the hallway has spilled
        into the room, leaving little room to move.  People are
        coming and going, helping themselves to the snacks. "
;
++ SimpleNoise
    'crowd noise/talking/babble/conversation' 'crowd noise'
    "The alley is filled with a continuous babble of conversation from
    the crowd. "
;
++ DefaultAnyTopic
    "You try to get someone's attention, but everyone's too
    busy chatting. "
;

+ r4Desk: Heavy, Surface 'wood wooden desk' 'desk'
    "It's a small wooden desk. "
;

++ PresentLater, Wearable 'black mitachron logo t-shirt' 'black T-shirt'
    "It's a black T-shirt bearing the Mitachron logo. "
    plKey = 'logo-wear'
;
++ PresentLater, Readable
    'working at mitachron glossy brochure' 'Mitachron brochure'
    "It's a glossy brochure labeled <q>Working at Mitachron.</q> "

    readDesc = "You glance through the brochure, and find lots of
        pictures of happy young people doing fun things in the
        halls of modern office buildings.  They don't seem to focus
        a lot on the work part. "
    
    plKey = 'logo-wear'
;
++ logoCap: PresentLater, Wearable
    'black giant gigantic novelty mitachron logo baseball cap/hat'
    'baseball cap'
    "It's ridiculously large---it's like one of those ten-gallon
    Texas hats, but in the shape of a baseball cap.  It's black, with
    the Mitachron logo across the front. "

    dobjFor(Wear)
    {
        action()
        {
            "The hat is extremely heavy, even considering its enormous
            size.  It almost feels too heavy for your neck to support,
            but you put it on anyway.  As you do, a strange, warm feeling
            overcomes you...\ OBEY...\ almost like the pins-and-needles
            feeling of having your arm fall asleep...\ ALL HAIL
            MITACHRON...\ a comforting feeling, really...\ WHAT'S GOOD
            FOR MITACHRON IS GOOD FOR AMERICA...\ and it's a little odd
            the way your vision seems blurred, the way everything is
            suddenly surrounded by glowing, swirling fringes of
            color...\ ACCEPT JOB OFFER AT MITACHRON NOW...\ and the
            way everything sounds like you're underwater...\ OBEY
            ACCEPT OBEY ACCEPT OBEY...
            <.p>You feel a bit dizzy, and you realize that your vision
            and hearing have started returning to normal.  Belker is
            saying something and laughing nervously as he sets the hat
            on the desk. ";

            /* move me back onto the desk */
            moveInto(r4Desk);
        }
    }

    plKey = 'logo-wear'
;

++ CustomImmovable, Food
    'snack party bribe/food/foods/platter/chocolate/chocolates/candy/candies/
    cookie/cookies/cracker/crackers/grape/grapes/strawberry/strawberries/
    fruit/fruits/cheese/snack/snacks/treat/treats'
    'party platter'
    "The bribe is an essential part of any Ditch Day stack; once the
    underclassmen have solved the main part of the stack, the bribe is
    the last line of defense against the room getting trashed.  Bribes
    are typically in the form of edible treats like this.  The rule is
    that if the bribe is accepted, the room is safe from trashing. "

    specialDesc = "Spread out on the desk is a nice selection of
        snack foods, arranged in a party platter: chocolates, cookies,
        crackers, grapes, strawberries, cheese. "

    cannotPutInMsg = 'There\'s no reason to hoard the food; just
        eat what you want. '
    cannotMoveMsg = 'There\'s no reason to rearrange the food. '

    dobjFor(Take) asDobjFor(Eat)
    dobjFor(Eat)
    {
        /* we don't have to take the food to eat it; touching it is enough */
        preCond = [touchObj]
        action()
        {
            "You help yourself to some of the treats.  Everything's
            delicious. ";
        }
    }
;

+ Bed, Heavy 'twin bed' 'bed'
    "It's a simple twin bed with white sheets. "

    dobjFor(LookUnder) { action() { "You have no reason to snoop around
        someone else's room.  Even if there were, say, a dollar bill there,
        it wouldn't be yours to take. "; } }
;
++ Decoration 'plain white (bed) sheet/sheets/bedsheet/bedsheets' 'bedsheets'
    "They're just plain white sheets, with that institutional look. "
    isPlural = true
;

+ Chair, CustomImmovable 'straight-backed wood wooden chair' 'chair'
    "It's a straight-backed wooden chair. "

    cannotTakeMsg = 'The chair is a bit bulky to carry around. '
;

+ Surface, Fixture
    'unfinished particle book bookshelf/bookshelves/shelf/shelves/board'
    'bookshelves'
    "The shelves are made of unfinished particle board.  They
    must be sturdy, given the heavy load of books they support. "
;
++ Decoration
    'reference physics math chemistry astronomy biology engineering
    economics serious literature science fiction
    textbook/book/text*textbooks*texts*books'
    'books'
    "It looks like the usual collection of books a Techer accumulates
    over a student career: textbooks for physics, math, chemistry,
    astronomy, biology, economics; reference books; a bit of serious
    literature; and lots of science fiction. "
    isPlural = true
;

/* ------------------------------------------------------------------------ */
/*
 *   Brian Stamer 
 */
stamer: Person
    'brian stamer' 'Brian'
    "He's lanky and a little pale.  His clothes are slightly
    disheveled.  From the wispy layer of fuzz, you'd guess he
    hasn't shaved in a few days. "

    isHim = true
    isProperName = true
;

+ HelloTopic
    "You already have Brian's attention. "
;

+ ActorState
    isInitState = true
    stateDesc = "He's standing here talking to you. "
    specialDesc = "Brian Stamer is standing here talking to you. "
;

++ TellTopic @logoCap
    "You know exactly what that hat must be.  <q>That's no ordinary
    baseball cap,</q> you tell Brian.  <q>Whatever you do, don't put
    it on.</q> "
    
    isActive = (gRevealed('galvani-2') && logoCap.location != nil)
;

++ AskTellTopic, SuggestedTellTopic, StopEventList @galvaniTopic
    ['<q>Have you ever heard of a Mitachron project called Galvani-2?</q>
    you ask.
    <.p><q>Sure,</q> he says.  <q>That\'s the mind-control system
    Mitachron\'s been working on.  They\'ve been talking about that
    for years, but they keep slipping their schedule.</q> ',

     '<q>Don\'t you think Galvani-2 is a little disturbing?</q> you ask.
     <.p>He shrugs. <q>I guess it would be if it actually worked.
     From what I\'ve heard, though, it\'s kind of a joke.</q> ',

     '<q>I think they\'re a lot further along than you\'ve heard,</q>
     you say. <q>And they\'ve been spying on your lab.  They think
     your decoherence project is just what they need to solve their
     problems.</q>
     <.p><q>Interesting,</q> he says. ',

     'You mention again how Mitachron has been spying on Stamer\'s
     lab.  He nods pensively. ']

    name = 'Project Galvani-2'
    isActive = gRevealed('galvani-2')
;
++ AskTellGiveShowTopic
    [efficiencyStudy37, efficiencyStudy37Topic, galvaniTopic]
    topicResponse() { replaceAction(TellAbout, stamer, galvaniTopic); }
;

++ AskTellTopic, SuggestedTopicTree, SuggestedTellTopic, StopEventList @spy9
    ['<q>Did you know there\'s a spy camera hidden in your lab?</q>
    you ask.
    <.p>He raises his eyebrows. <q>No, I didn\'t.</q> ',

     'You describe the camera and tell him where it\'s hidden.
     <.p><q>Thanks for letting me know,</q> he says.  <q>I\'m
     definitely going to look into it.</q> ']

    name = 'the SPY-9 camera'
    isActive = (spy9.described)
;
+++ AltTopic, StopEventList
    ['<q>Did you know there\'s a spy camera hidden in your lab?</q>
    you ask.
    <.p>He raises his eyebrows. <q>No, I didn\'t.</q> ',

     '<q>I tracked the camera data connection to an office in the
     Sync Lab,</q> you say. <q>Mitachron set it up.  They\'ve been
     spying on your lab.</q>
     <.p><q>Well,</q> he says.  <q>That\'s extremely disturbing.</q> ',

     'You tell him how to get into the Sync Lab office, and he
     says he\'ll go check it out. ']
    
    isActive = (syncLabOffice.seen)
;

++ DefaultAnyTopic
    "You should probably stick to the subject for now.<.convstay> "
;

+ ConvNode 'stamer-hello'
    npcGreetingMsg = "There's a lull in the noise of the crowd.
        A lanky, pale student, looking slightly disheveled, comes
        in through the door, saying hello to the other students
        as he makes his way through the crowd.  He finally comes
        to you and stops.
        <.p><q>Hi,</q> he says. <q>I'm Brian Stamer.  I'm guessing
        you're the one who solved my stack?</q> "

    /* stay here until we explicitly move on */
    isSticky = true

    /* don't allow terminating the conversation just yet */
    canEndConversation(actor, reason)
    {
        "You really should introduce yourself to Brian first. ";
        return nil;
    }

    npcContinueMsg = "Brian is still waiting for you to introduce
        yourself. "

    nextMsg = "<q>I'm Doug Mittling, from Omegatron.</q> You shake hands.
        <.p><q>So,</q> Brian says, <q>what did you think of the stack?</q>
        <.convnode stamer-stack> "
;

++ HelloTopic
    "<q>Yes,</q> you say. <<location.nextMsg>> "
;

++ YesTopic, SuggestedYesTopic
    "<q>That's right,</q> you say.  <<location.nextMsg>> "
;

++ NoTopic
    "<q>It was actually my pocket calculator that solved it,</q>
    you say, laughing. <<location.nextMsg>> "
;

++ SpecialTopic 'introduce yourself' ['introduce','yourself','myself','me']
    "<q>That's right,</q> you say. <<location.nextMsg>> "
;

+ ConvNode 'stamer-stack'
    /* stay here until we explicitly move on */
    isSticky = true

    /* don't allow terminating the conversation just yet */
    canEndConversation(actor, reason)
    {
        "You should tell Brian about the stack first. ";
        return nil;
    }

    npcContinueMsg = "Brian gets your attention again. <q>What did
        you think of the stack?</q> "

    nextMsg = "<.p><q>You said you work for Omegatron?</q> Brian asks.
        <.convnode stamer-omegatron> "
;

++ AskTellTopic, SuggestedTellTopic [stackTopic, ddTopic, stamerStackTopic]
    "<q>Your stack was definitely a learning experience,</q> you say.
    <q>Your experiment is quite something.</q><<location.nextMsg>> "
    name = 'the stack'
;

++ AskTellTopic, SuggestedTellTopic [blackBox]
    "<q>The black box was rather challenging to reverse-engineer,</q>
    you say. <<location.nextMsg>> "
    name = 'the black box'
;

++ AskTellGiveShowTopic, SuggestedTellTopic [calculator]
    "<q>The quantum calculation trick is pretty amazing,</q> you
    say. <<location.nextMsg>> "
    name = 'the calculator'
;

++ DefaultAnyTopic
    "You should tell Brian about the stack first.<.convstay> "
    isConversational = nil

    deferToEntry(entry) { return !entry.ofKind(DefaultTopic); }
;

+ ConvNode 'stamer-omegatron'
    /* stay here until we explicitly move on */
    isSticky = true

    /* don't allow terminating the conversation just yet */
    canEndConversation(actor, reason)
    {
        "You really shouldn't miss this chance to sell Brian on
        Omegatron. ";
        return nil;
    }

    npcContinueMsg = "Brian asks you again about Omegatron. "
;

++ TellTopic, SuggestedTellTopic @omegatronTopic
    name = 'Omegatron'
    topicResponse()
    {
        "<q>I do work for Omegatron,</q> you say.  You start telling
        Brian about the company, what your group does, what you do, what
        Brian might do as a new hire---your standard spiel for candidates.
        Mid-way through, it strikes you that your heart really isn't in it;
        but you press on anyway.  <q>So,</q> you conclude, <q>there are
        some great opportunities, and we'd love to have you on board.</q>
        <.p>Stamer listens and nods.  <q>Sounds okay,</q> he says, not
        sounding very enthusiastic.
        <.p><q>Excuse me,</q> a voice says from alongside you.  You and
        Brian turn to see Belker standing there.  <q>My name is Frosst
        Belker,</q> he says to Brian. <q>I am with the Mitachron Company.
        You must be Brian Stamer---a pleasure at last to meet you.</q>
        He opens a bag he's carrying, and starts taking things out and
        handing them to Brian: first a t-shirt, then a brochure, then a
        gigantic novelty baseball cap.  <q>Please accept these tokens of
        our esteem.</q>   He holds up the baseball cap. <q>This article,
        perhaps it is the wrong size for you.  Please, allow me to assess
        the situation, if you would be so kind...</q>
        <.p>Belker tries to put the cap on Brian's head, but Brian
        deftly ducks, takes the cap from Belker, and sets it on the desk
        along with the other things.  <q>That's okay,</q> he says.
        <q>I'll try it on later.</q>
        <.convnode stamer-hat> ";
        
        /* bring in belker */
        frosst.moveIntoForTravel(room4);
        frosst.setCurState(frosstRoom4);

        /* bring in the logo-wear */
        PresentLater.makePresentByKey('logo-wear');
    }
;

++ YesTopic
    "<q>Yes, I work for Omegatron,</q> you say.  This would be a good
    chance to tell him about the company.<.convstay> "
;
++ NoTopic
    "You try to come up with a working-hard-hardly-working kind of
    joke, but nothing good comes to mind.  You really should take
    the opportunity to tell him about Omegatron, through.<.convstay> "
;

+ ConvNode 'stamer-hat'
    isSticky = true

    canEndConversation(actor, reason)
    {
        "You can't very well walk out now. ";
        return nil;
    }

    /* Belker continues no matter what we do */
    npcContinueMsg() { nextMsg; }
    nextMsg()
    {
        "Belker flashes you a thin smile.  <q>Before you expend too
        much energy on the particulars of employment negotiations,
        Mr.\ Mittling, I bring news that will be of considerable interest
        to you.  Moments ago I have spoken with my company's headquarters,
        and I am pleased to say that Mitachron initiated a hostile
        takeover of Omegatron early today.</q>  He turns to Brian.
        <q>So, you see, while Mr.\ Mittling unarguably prevailed in the
        stack competition, he was technically already an employee of
        Mitachron while doing so.  The victory is therefore Mitachron's.</q>
        Belker turns back to you, smirking.   <q>Once again, Mr.\ Mittling,
        we see that however diligent your efforts, in the end it is I
        who prevails.  And do not fret, Mr.\ Stamer; you can be assured
        that Mitachron's employment terms will be most agreeable.</q>
        <.convnode stamer-frosst> ";
    }
;
++ DefaultAnyTopic
    topicResponse() { location.nextMsg; }
;

+ ConvNode 'stamer-frosst'
    /* stay here until we explicitly move on */
    isSticky = true

    canEndConversation(actor, reason)
    {
        "You can't very well leave the conversation at this juncture. ";
        return nil;
    }

    /* 
     *   Brian continues the conversation of his own volition if we say
     *   nothing 
     */
    npcContinueMsg() { nextMsg; }

    /* 
     *   the common next message - we'll use this whether Brian continues
     *   the conversation or we do 
     */
    nextMsg()
    {
        "<q>I'll think about your offer,</q> Brian says to Belker.
        He turns to you.  <q>Actually, there's something else I wanted
        to talk to you about.  A few friends and I have been putting
        together a start-up company, based on the technology in my
        lab.  The thing is, we need some people with industry experience,
        to keep the investors happy.  We don't want just anyone,
        though.</q>  He shoots a sideways glance at Belker.  <q>That's
        the real reason I put together this stack---I figured anyone
        who could solve it must be pretty good with technology.  The
        point is, I'd like to hire you as our VP of engineering.
        Interested?</q>
        <.convnode stamer-job> ";
    }
;
++ DefaultAnyTopic
    topicResponse()
    {
        "You start to talk, but Belker interrupts. <q>Please,
        Mr.\ Mittling, you must learn your place now that you
        work for me.  I'm talking with Mr.\ Stamer right now.</q>
        <.p>";

        location.nextMsg;
    }
;

+ ConvNode 'stamer-job'
    /* stay here until we explicitly move on */
    isSticky = true

    canEndConversation(actor, reason)
    {
        "You should tell Brian whether or not you're interested
        in his job offer. ";
        return nil;
    }

    npcContinueMsg = "Brian clears his throat. <q>Well?</q> he asks.
        <q>Are you interested in the job?</q> "
;

++ YesTopic
    topicResponse()
    {
        "You almost say no just out of habit, out of fear of the
        unknown.  But thinking back on your day, on all of the new
        and interesting challenges, on all of the cool technology
        that Stamer's been working on, you realize how complacent
        you've become at Omegatron, and how little reason you have
        to stay.  And with this Mitachron takeover, you <i>really</i>
        want to get out of there.
        <.p><q>I'd love to,</q> you say, surprising yourself a little.
        <.p><q>Great,</q> Brian says.  You shake hands on the deal.
        <.p><q>No!</q> Belker yells. <q>This is not possible.
        Mr.\ Stamer, you gave assurances that you would accept a job
        at the winner's company.  Mr.\ Mittling won, and Mitachron
        is his company, therefore you must accept a job at Mitachron.</q>
        <.convnode stamer-quit-mitachron> ";
    }
;

++ NoTopic
    topicResponse()
    {
        "Brian's start-up sounds interesting, and heaven knows Omegatron
        isn't perfect; but when you get right down to it, nothing is.
        There's a lot to be said for sticking with a good thing, building
        a career at one company.  The Mitachron takeover is a bit of a
        wild card, but who knows; it could actually be interesting to
        be on the winning side for a change.
        <.p><q>Thanks for the offer,</q> you say, <q>but I think I'm
        going to stay at Omegatron for now.</q>
        <.p>Brian looks disappointed. <q>Really?  Oh, well, I guess we'll
        have to find someone else.  Good to meet you, though.</q>
        <.p>You and Brian shake hands, and Brian wanders off into the
        party.  Frosst chases after him.
        <.p>You stay a while longer, chatting and enjoying the food.
        You catch up with Xojo, who has nothing nice to say about
        Mitachron, and you run into most of the students you met during
        the day.  Eventually the party dwindles, and you head back to
        the airport.
        <.p>You talk to Brian on the phone a few times over the next week
        or so, trying to persuade him to take the Omegatron job, but it
        soon becomes clear that his start-up is shifting into high gear
        already.  With Brian out of the picture, Mitachron seems to
        lose interest in the Omegatron takeover, so things are soon
        back to boring but comfortable normalcy.
        <.p>All in all, it wasn't a bad trip.  You didn't manage to
        hire Brian, but at least you gave it your best shot.  And you
        feel great about having solved the stack. ";

        /* award the points for at least trying to hire Brian */
        scoreMarker.awardPointsOnce();

        /* offer finishing options */
        finishGameMsg('YOU HAVE SURVIVED DITCH DAY',
                      [finishOptionUndo, finishOptionFullScore,
                       finishOptionAfterword, finishOptionAmusing,
                       finishOptionCredits, finishOptionCopyright]);
    }

    scoreMarker: Achievement { +5
        "taking your best shot at hiring Brian Stamer"

        /* 
         *   Don't count this in the game's maximum score.  This is an
         *   alternative achievement that we don't capture in the best
         *   winning solution, so it doesn't count in the highest possible
         *   score, which is only achieved in the best winning solution. 
         */
        maxPoints = 0
    }
;

+ ConvNode 'stamer-quit-mitachron'
    /* stay here until we explicitly move on */
    isSticky = true

    canEndConversation(actor, reason)
    {
        "You don't have any intention of walking away in the middle
        of this. ";
        return nil;
    }

    npcContinueMsg = "Brian looks at Belker and then at you. <q>I hope
        you're going to get me out of this,</q> he says. "
    
    nextMsg()
    {
        "<q>I don't think you understand,</q> you tell Belker.
        <q>I don't work for Omegatron <i>or</i> Mitachron any longer.
        I work for Brian's company now.</q>  You turn to Stamer.
        <q>I know Mitachron will make you a good offer, but you did
        say you'd come work for the winner's company.  So, what'll
        it be?  Will you come work for my new company?</q>
        <.p><q>Why, yes,</q> Brian says. <q>I'd be thrilled to.  Sorry,
        Mr.\ Belker, but a deal's a deal, and he did win the stack.</q>
        <.p>Frosst stands there looking like steam is about to come
        shooting out his ears.  He starts flailing his arms wildly.
        <q>No!  No, no, no!  This is intolerable!</q>  A couple of
        Mitachron technicians come running over and try to calm him
        down, but this just makes him more furious.  <q>You think
        you are so clever, both of you.</q>  More technicians have
        come over now, and they've started dragging him away through
        the crowd.  <q>You have not heard the last of Frosst Belker,
        I assure you.  You will see...</q>  His voice trails off as
        the technicians drag him away.
        <.p>Over the next few weeks, Brian's start-up comes together
        amazingly quickly.  By the time the school year ends, you've
        already hired enough people to fill up the new office space,
        including Xojo, who turns out to have some great experience
        with semiconductor fab operations.  You know you have a lot
        of work ahead of you, and a lot to learn, but you can already
        tell it's going to be a great ride. ";

        /* award the points for reaching the best solution */
        scoreMarker.awardPointsOnce();

        /* offer finishing options */
        finishGameMsg('YOU HAVE SUCCEEDED',
                      [finishOptionUndo, finishOptionFullScore,
                       finishOptionAfterword, finishOptionAmusing,
                       finishOptionCredits, finishOptionCopyright]);
    }

    scoreMarker: Achievement { +5 "escaping Belker's takeover attempt" }
;

++ SpecialTopic 'tell Belker you quit'
    ['tell','frosst','belker','i','you','quit']
    topicResponse() { location.nextMsg; }
;

++ SpecialTopic 'offer Brian a job' ['offer','brian','stamer','a','job']
    topicResponse() { location.nextMsg; }
;

++ DefaultAnyTopic
    "You really should figure out this job situation first.<.convstay> "
    isConversational = nil

    deferToEntry(entry) { return !entry.ofKind(DefaultTopic); }
;

