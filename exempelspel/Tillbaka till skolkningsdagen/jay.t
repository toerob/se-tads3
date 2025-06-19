#charset "utf-8"
/*
 *   Copyright 2003, 2013 Michael J. Roberts
 *   
 *   Return to Ditch Day - Jay Santoshnimoorthy.  Jay programs the
 *   calculator for us to solve the Hovarth puzzle, but it takes a bit of
 *   interacting with him to get him to cooperate.  
 */

#include <adv3.h>
#include <sv_se.h>
#include "ditch3.h"


/* an unthing for jay, until he's present */
unJay: Unthing 'jay santoshnimoorthy' 'Jay' @alley4main
    isHim = true
    isProperName = true
    notHereMsg = 'You don\'t know what Jay looks like, so you wouldn\'t
        know if he were here. '
;

jay: PresentLater, Person 'jay santoshnimoorthy' 'Jay' @alley4main
    "His height and build and long hair make him look like a
    surfer dude.  He's wearing a bright aloha shirt. "

    /* jay is just part of the crowd, so don't mention him separately */
    specialDesc = ""
    isHim = true
    isProperName = true

    /* 
     *   enter the conversation state automatically - we use this when we
     *   trigger a conversation entry via some other conversational event,
     *   such as asking the other students where jay is 
     */
    autoEnterConv()
    {
        /* 
         *   if our current state is a conversation-ready state, switch
         *   directly to the corresponding in-conversation state 
         */
        if (curState.ofKind(ConversationReadyState))
            setCurState(curState.inConvState);

        /* mark me as 'him' */
        gPlayerChar.setPronounObj(self);

        /* make me the interlocutor */
        noteConversation(gPlayerChar);
    }
;

+ InitiallyWorn 'bright vividly-colored aloha hawaiian shirt' 'aloha shirt'
    "The vividly-colored shirt is adorned with a floral pattern. "
    isListedInInventory = nil
;

+ InConversationState
    stateDesc = "He's standing here talking to you. "
;

/* ask jay about the stack */
++ AskTellShowTopic
    [stackTopic, a4Materials, a4Envelopes, a4Map, turboTopic]
    "<q>Which stack is this?</q> you ask.
    <.p><q>It's the Turbo Power Animals stack,</q> he says.
    <q>Go check out the sign.</q> He points down the hall
    to the west. "
;
+++ AltTopic, StopEventList
    ['<q>Anything I can do to help with the stack?</q> you ask.
    <.p>He looks over the papers on the table. <q>You know, we
    don\'t have anyone working on Turbo Power Squirrel.  We\'ve
    figured out where he is---he\'s in the Guggenheim wind tunnel.
    We need someone to get up there and bring him back.</q>
    <.reveal squirrel-assigned> ',

     '<q>How\'s the stack coming?</q> you ask.
     <.p><q>We still need someone to go get Turbo Power Squirrel,
     if you\'re interested,</q> he says.  <q>We think he\'s up
     in the Guggenheim wind tunnel.</q> ']

    isActive = gRevealed('tpa-stack')
;
+++ AltTopic
    "<q>How's the stack coming?</q> you ask.
    <.p>He shrugs.  <q>We'd be doing great if you could bring
    back Turbo Power Squirrel for us.</q> "

    isActive = gRevealed('squirrel-assigned')
;
+++ AltTopic
    "You're a little hesitant to ask about the stack again;
    you're afraid you might end up with another assignment. "

    isConversational = nil
    isActive = gRevealed('squirrel-returned')
;

/* ask about turbo power squirrel is about like asking about the stack */
++ AskTellTopic @squirrel
    "<q>Where was this squirrel I'm supposed to find?</q> you ask.
    <.p><q>We're pretty sure he's in the Guggenheim wind tunnel,</q> Jay
    says.  <q>Up on the roof of Guggenheim.</q> "
    isActive = gRevealed('squirrel-assigned')
;
+++ AltTopic
    "<q>How's Turbo Power Squirrel doing?</q> you ask.
    <.p><q>He's safe, thanks to you!</q> Jay says, smiling. "
    isActive = gRevealed('squirrel-returned')
;

++ AskTellTopic @stamerStackTopic
    "You ask Jay if he's seen Stamer's stack.  He says he looked at
    it and wasn't very interested---he calls it <q>another boring
    black box stack.</q> "
;

/* once we assign the squirrel, guggenheim is a topic of interest */
++ AskTellTopic [guggenheimTopic, windTunnelTopic]
    "<q>How am I supposed to get up to the wind tunnel?</q> you ask.
    <.p>He shrugs. <q>I was hoping you'd be able to figure that out.</q> "
    isActive = gRevealed('squirrel-assigned')
;
+++ AltTopic
    "<q>Have you been up in the wind tunnel before?</q> you ask.
    <.p><q>Nope,</q> he says. "
    isActive = (windTunnel.seen)
;

/* returning the squirrel */
++ GiveShowTopic @squirrel
    topicResponse()
    {
        "You offer the squirrel action figure to Jay.  <q>Hey! That's
        great!</q>  He takes the squirrel and holds it up for everyone
        to see. <q>Turbo Power Squirrel is safe!</q>  Everyone cheers.
        Jay puts the figure on the table.
        <.reveal squirrel-returned> ";

        /* remove the squirrel from play */
        squirrel.moveInto(a4Table);

        /* award some points for this */
        scoreMarker.awardPointsOnce();
    }

    scoreMarker: Achievement { +5 "rescuing Turbo Power Squirrel" }
;

/*
 *   Ask Jay about the calculator.
 *   
 *   - if we've already programmed it, explain the instructions again
 *   
 *   - if we've shown it to him before, just say there's nothing more to
 *   say
 *   
 *   - otherwise, ask to show him the calculator 
 */
+++ AskTellTopic @calculator
    "You describe the calculator to Jay and ask him if he knows
    anything about it.
    <.p><q>Sounds pretty generic,</q> he says. <q>Maybe if I
    could take a look at it...</q> "
;
++++ AltTopic
    "You ask Jay if there's anything else special about the
    calculator.  He just shrugs. "
    isActive = gRevealed('calc-to-jay')
;
++++ AltTopic
    "<q>How does that program you wrote work again?</q> you ask.
    <.p>Jay points to the <q>+</q> key.  <q>Just type the number,
    then plus-plus-plus.  Do that right after you get the quantum
    machinery going, and the answer should come right up.</q> "
    
    isActive = (calculator.isProgrammed)
;


/*
 *   Give Jay the calculator.  There are several variations of this:
 *   
 *   - if we've already programmed the calculator, just re-explain how the
 *   programming works
 *   
 *   - if we've talked about hovarth numbers, AND we've shown him the
 *   article on macroscopic quantum computing, AND we've returned the
 *   squirrel, we're good to go
 *   
 *   - if we've talked about hovarth numbers AND we've shown him the QC
 *   article, but we haven't yet returned the squirrel, hold out for the
 *   squirrel
 *   
 *   - if we've only talked about hovarth numbers, explain that they're
 *   impossible to program (conventionally, anyway)
 *   
 *   - if we've only showed him the QRL article without talking about
 *   hovarth numbers, he's interested but has nothing to calculate
 *   
 *   - if we haven't done any of this, show off his prowess by playing a
 *   little tune 
 */
++ GiveShowTopic, StopEventList @calculator
    [&response1,

     'You offer Jay the calculator, but he doesn\'t take it.
     <q>I don\'t want to show off,</q> he says.
     <.convnode jay-programming> ']

    response1()
    {
        "<q>Have a look at this,</q> you say, handing Jay the calculator.
        <.p>He turns it over a couple of times, turns it on, taps on
        the keys for a bit.  The calculator starts beeping a little
        tune.  One of the other students groans and playfully tries to
        grab the calculator from Jay, but Jay dodges out of the way.
        <.p><q>Don\'t encourage him,</q> the other guys says.  <q>He
        just can\'t help showing off his nerdly trick.</q>
        <.p>Jay laughs.  <q>Sorry,</q> he says.  He turns off the
        calculator and hands it back.
        <.reveal calc-to-jay>
        <.convnode jay-programming> ";

        /* we mentioned that he turns off the calculator */
        calculator.makeOn(nil);
    }
;
+++ AltTopic
    "<q>Do you think you could program a Hovarth function on my
    calculator?</q> you ask.
    <.p><q>Dude, there's no point,</q> he says. <q>Unless you
    have, oh, about ten to the fortieth years to wait for the
    answer.</q> "

    isActive = (gRevealed('hovarth-to-jay'))
;
+++ AltTopic
    "You offer the calculator to Jay, but he waves you off.
    <.p><q>I still haven't thought of the right problem,</q> he
    says. <q>We need something interesting, something you can't
    do on a normal computer.</q> "

    isActive = (gRevealed('jay-ready-to-program'))
;
+++ AltTopic
    topicResponse()
    {
        "You offer Jay the calculator, but he doesn't take it.
        <q>Tell you what,</q> he says. ";

        if (gRevealed('squirrel-assigned'))
            "<q>Remember Turbo Power Squirrel?  Go bring him back
            from the Guggenheim wind tunnel, and I'll help you out
            with programming your calculator.</q> ";
        else
            "<q>We need someone to rescue Turbo Power Squirrel.  We've
            figured out that he's in the Guggenheim wind tunnel, but
            no one's got any time to go get him.  If you could go
            rescue him and bring him back here, I'll help you out
            with programming your calculator.</q>
            <.reveal squirrel-assigned> ";
    }
    isActive = (gRevealed('jay-ready-to-program')
                && gRevealed('hovarth-to-jay'))
;
+++ AltTopic
    topicResponse()
    {
        /* 
         *   if we've already talked about programming hovarth functions on
         *   the calculator, follow up on that thought; otherwise,
         *   introduce the idea here 
         */
        if (gRevealed('jay-ready-to-program-hovarth'))
            "You hand Jay the calculator. ";
        else
            "<q>Do you think you could program a quantum Hovarth
            function?</q> you ask, handing Jay the calculator.
            <.p><q>Dude, that's an excellent idea,</q> he says. ";
        
        "He starts tapping furiously at the keypad with both
        thumbs, almost too fast to see.  <q>This is perfect,</q>
        he says, still typing away. <q>The chipset in this model
        has an unstable flip-flop on the key debouncer that we
        can use as a true random source.</q>
        <.p>He finally finishes, smiling broadly at his handiwork.
        <q>There,</q> he says, handing the calculator back to you.
        <q>It's the least I could do for the man who rescued
        Turbo Power Squirrel.</q>  He points to the <q>+</q>
        key. <q>All you have to do is enter the number for
        the Hovarth function, then press <q>plus</q> three times
        in a row, really fast.  So type the number, then type
        plus-plus-plus.  Make sure the quantum thingy is going
        when you do.  The result should come right up.</q> ";

        /* the calculator is now programmed */
        calculator.isProgrammed = true;

        /* leave it off, and clear the display */
        calculator.makeOn(nil);
    }
    
    isActive = (gRevealed('jay-ready-to-program')
                && gRevealed('hovarth-to-jay')
                && gRevealed('squirrel-returned'))
;
+++ AltTopic
    "<q>How does that program you wrote work again?</q> you ask.
    <.p>Jay points to the <q>+</q> key.  <q>Just type the number,
    then plus-plus-plus.  Do that right after you get the quantum
    machinery going, and the answer should come right up.</q> "
    
    isActive = (calculator.isProgrammed)
;

++ GiveShowTopic @drdBook
    topicResponse()
    {
        /* just handle this with ASK JAY ABOUT HOVARTH NUMBERS */
        replaceAction(AskAbout, jay, hovarthTopic);
    }
;

/*
 *   If we ask Jay about Hovarth numbers (or the DRD), mention that he
 *   knows about them, but leave it at that.  If we're ready to program the
 *   calculator, take it as a suggestion. 
 */
++ AskTellShowTopic, StopEventList [hovarthTopic, drdTopic, drdBook]
    ['<q>Have you heard of Hovarth numbers?</q> you ask.
    <.p><q>Yes, most definitely,</q> he says. <q>We had a phys
    homework a few weeks ago that was all about Hovarth numbers.
    Entirely heinous stuff.</q>
    <.reveal hovarth-to-jay>
    <.convnode jay-programming> ',

     '<q>You said you know about Hovarth numbers?</q> you ask.
     <.p><q>Yeah, from a phys class.</q>
     <.convnode jay-programming> ']
;
+++ AltTopic
    "<q>Have you heard of Hovarth numbers?</q> you ask.
    <.p><q>Sure,</q> he says. <q>You know, that's a perfect problem
    for a quantum computer.  I could try programming it if you give
    me a calculator.</q>
    <.reveal hovarth-to-jay>
    <.reveal jay-ready-to-program-hovarth> "

    isActive = gRevealed('jay-ready-to-program')
;
+++ AltTopic
    "<q>So you think you can program a Hovarth solver for me?</q> you ask.
    <.p><q>I think so,</q> he says. <q>Give me a calculator and I'll
    take a shot at it.</q> "
    
    isActive = gRevealed('jay-ready-to-program-hovarth')
;
+++ AltTopic
    "You ask Jay about the Hovarth calculation, and he explains
    again how to use the calculator program he wrote for you: just
    enter the number and press the <q>+</q> key three times in a row. "

    isActive = (calculator.isProgrammed)
;

/* talk about the newspaper article */
++ AskTellGiveShowTopic @newspaper
    "<q>I saw the article about you in the <i>Tech</i>,</q> you say.
    <q>Can you really program <i>any</i> calculator?</q>
    <.p>Jay shrugs. <q>I don't know.  I haven't found a
    counter-example yet.</q>
    <.convnode jay-programming> "
;
+++ AltTopic
    "<q>That was a great article about you in the <i>Tech</i>,</q>
    you say.
    <.p>Jay smiles. <q>Thanks,</q> he says. "

    isActive = gRevealed('jay-ready-to-program')
;

/* 
 *   A conversation node for programming the calculator.  We'll come here
 *   after we talk about the calculator, hovarth numbers, or the newspaper
 *   article - basically, anything that would lead us to talking about
 *   programming the calculator to do the hovarth calculation.  We never
 *   come here if we've already talked about programming the calculator,
 *   since it's redundant with that previous conversation.  
 */
++ ConvNode 'jay-programming'
    /* always show topic inventory on entry */
    autoShowTopics = true
;
+++ AskTellTopic, SuggestedAskTopic, StopEventList @programmingHovarthTopic
    ['<q>Could you program a Hovarth function on my calculator?</q>
    you ask.
    <.p>Jay looks nonplussed. <q>Um, dude, are you out of your mind?
    I mean, I <i>could</i>, but nobody has that kind of time.  We\'re
    talking heat death of the universe.</q>
    <.reveal hovarth-to-jay> ',

     '<q>I really need a Hovarth function programmed on my calculator,</q>
     you say.
     <.p>Jay shakes his head. <q>It\'d be pointless,</q> he says.
     <q>The sun would go super-nova before the program ever finished.</q> ']

    name = 'programming hovarth numbers'
;
++++ AltTopic
    "You're not quite sure what to ask him, since you don't have
    anything at the moment suitable for programming. "

    isActive = (!calculator.isIn(me))
;

/* 
 *   The article about the quantum calculator.  We need to show this to Jay
 *   to explain about how to turn the calculator into a hovarth machine.
 *   But we can't just tell him about it; if we do, just ask to show it.  
 */
++ AskTellTopic [qrl739a, qrl739aTopic]
    "You tell Jay a bit about the article.
    <.p><q>Sounds cool,</q> he says.  <q>I'd like to read it, if you
    have a copy.</q><.reveal 739a-to-jay> "
;
+++ AltTopic
    "You don't really have anything tell Jay about it, since you
    haven't read it yourself. "
    isActive = (!gRevealed('qc-calculator-technique'))
;
+++ AltTopic
    "<q>What do you think of that quantum computing article?</q> you ask.
    <.p><q>That's ultra bizarre stuff,</q> he says. "
    isActive = (gRevealed('jay-ready-to-program'))
;

/* the other QRL article is semi-interesting also */
++ AskTellTopic [qrl7011c, qrl7011cTopic]
    "You summarize the article for Jay.  He shrugs.  <q>Quantum
    computing is cool,</q> he says. <q>I've been meaning to read
    up on it.</q> "
;
+++ AltTopic
    "You mention the article to Jay.  <q>That quantum stuff is
    way bizarre,</q> he says, shaking his head. "
    isActive = (gRevealed('jay-ready-to-program'))
;

++ AskTellTopic @quantumComputingTopic
    "<q>Do you know anything about quantum computing?</q> you ask.
    <.p><q>Not much,</q> he says.  <q>Sounds way cool, though.  I've
    been looking for some good reading material about it.</q> "

    isActive = (!gRevealed('jay-ready-to-program'))
;
++ AskTellTopic @qubitsTopic
    "<q>Have you ever heard of <q>QUBITS</q>?</q> you ask.
    <.p>He shrugs. <q>That's some kind of quantum computing thing,
    isn't it?  Don't know much about it, but it sounds cool.  I've
    been meaning to find something good to read about it.</q> "

    isActive = (!gRevealed('jay-ready-to-program'))
;

/* QRL 70:11c has some quantum computing stuff, but it's not very concrete */
++ GiveShowTopic @qrl7011c
    "You hand Jay the article, and he scans through it quickly.
    <q>Dude, this is some pretty abstract theoreticalness,</q>
    he says, handing the journal back.  <q>I've been meaning to
    read about quantum computing, but, you know, something
    <i>concrete</i>.</q> "
;
+++ AltTopic
    "You offer Jay the article, but he waves you off. <q>Dude, my brain
    is full,</q> he says. "
    isActive = gRevealed('jay-ready-to-program')
;

/*
 *   The quantum calculator article.  The first time we show this, we'll
 *   take the article, spend a few turns reading it, and then we'll be
 *   ready to do the programming.  
 */
++ GiveShowTopic @qrl739a
    topicResponse()
    {
        if (!gRevealed('739a-to-jay'))
            "<q>You might find this interesting,</q> you say, offering
            the journal to Jay.
            <.p>He takes it and scans over the abstract.  <q>Hm,</q>
            he says, then sits down and starts reading through the
            article. ";
        else
            "You hand Jay the journal.  He sits down and starts reading
            through the article. ";

        /* give him the article */
        qrl739a.moveInto(jay);

        /* sit him down */
        jay.moveInto(a4mChair);
        jay.posture = sitting;

        /* start him reading */
        jay.setCurState(jayReading);

        /* set up an agenda item to finish the reading */
        jay.addToAgenda(jayDoneReading.setDelay(3));
    }
;
+++ AltTopic
    "You offer Jay the article, but he says he doesn't need
    to read it again. "

    isActive = gRevealed('jay-ready-to-program')
;

/* we can get a pointer to Scott here */
++ AskTellTopic [scottTopic, posGame]
    "<q>Have you seen Scott around?</q> you ask.
    <.p><q>Um, I think I saw him in a giant chicken suit in
    Alley Three,</q> he says. "
;

++ DefaultAnyTopic, ShuffledEventList
    ['<q>I\'m kind of busy here,</q> he says. ',
     'Just as you\'re about to talk, someone else asks him a
     question, so you decide not to interrupt. ',
     'He gets distracted looking at something on the map for
     a moment, and ignores what you were saying. ']

    isConversational = nil
;

/* the initial ready-for-conversation state */
++ jayGroundState: ConversationReadyState
    isInitState = true
    stateDesc = "He's busy working on the stack. "
;
+++ HelloTopic
    "<q>Hi, Jay,</q> you say.
    <.p>Jay puts down some papers and turns away from the table
    to talk. <q>Hey,</q> he says. "
;
+++ ByeTopic
    "Jay goes back to the table. "
;

/* a state for jay, while he's busy reading the journal */
+ jayReading: HermitActorState
    stateDesc = "He's reading an article. "
    noResponse = "He seems to engrossed in his reading to notice you. "
;

/* an agenda item for jay, for when he's finished reading */
+ jayDoneReading: DelayedAgendaItem
    invokeItem()
    {
        local calc, hov;
        
        /* get up */
        jay.moveInto(alley4main);
        jay.posture = standing;

        /* 
         *   if the PC isn't present, note that we finished while he was
         *   out, but don't finish yet 
         */
        if (!me.isIn(alley4main))
        {
            /* note that we finished while the PC was out */
            finishedWhilePcOut = true;

            /* go back to our normal state */
            jay.setCurState(jayGroundState);

            /* we're done */
            return;
        }

        /* return the journal */
        qrl739a.moveInto(me);

        /* return to the conversational state */
        jay.setCurState(jayGroundState.inConvState);

        /* 
         *   use the appropriate message, depending on whether the PC was
         *   present or not when we first finished 
         */
        if (finishedWhilePcOut)
            "<.p>Jay sees you and comes over to talk. <q>Here,</q> he
            says, <q>I finished the article.</q>  He hands you the
            journal. ";
        else
            "<.p>Jay gets up and hands you the journal. ";

        /* continue the discussion */
        "<q>That's pretty bizarre stuff.  I wonder if it would
        really work?";

        /* have we seen the calculator and/or Hovarth numbers? */
        calc = gRevealed('calc-to-jay');
        hov = gRevealed('hovarth-to-jay');
        if (calc && hov)
            "</q> He ponders something for a few moments, then smiles.
            <q>Hey, that would be perfect for Hovarth numbers!  Maybe I
            could program your calculator to figure Hovarth-of-X, and we
            could try it out.<.reveal jay-ready-to-program-hovarth>";
        else if (calc)
            " Maybe I could program your calculator to do some
            impossible calculation so we could try it out.  But
            what would be a good thing to calculate?";
        else if (hov)
            "</q> He ponders something for a few moments.  <q>You know,
            Hovarth numbers would be a good test for this.  Maybe I could
            program a calculator to figure Hovarth-of-X.  We'd need to find
            a calculator, though.<.reveal jay-ready-to-program-hovarth>";
        else
            " Maybe I could program a calculator to do some
            impossible calculation.  We'd have to find a calculator,
            though, and we'd need something interesting to calculate.";

        /* finish up */
        "</q><.reveal jay-ready-to-program> ";

        /* this agenda item is now finished */
        isDone = true;
    }

    /* flag: we finished while the PC was out */
    finishedWhilePcOut = nil
;

