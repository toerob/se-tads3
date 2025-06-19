#charset "utf-8"
/*
 *   Copyright 2003, 2013 Michael J. Roberts
 *   
 *   Return to Ditch Day - career center office.
 */

#include <adv3.h>
#include <sv_se.h>
#include "ditch3.h"

/* ------------------------------------------------------------------------ */
/*
 *   The Career Center Office
 */
ccOffice: Room 'Career Center Office' 'the Career Center office' 'office'
    "This room seems to be loosely divided into an office area and a
    public area.  Several desks are grouped on one side of the room,
    making up the office area.  On the other side, a couple of
    couches (one large and one small) are arranged in an <q>L</q>
    around a square glass coffee table.  A literature rack stands
    near the couches.
    <.p>A door to the north leads out to the lobby. "

    vocabWords = 'career center office'

    north = ccDoorN
    out asExit(north)

    /* flag: we've finished our appointment here */
    doneWithAppointment = nil

    /* on the first arrival, award points for finding our way here */
    afterTravel(traveler, conn)
    {
        scoreMarker.awardPointsOnce();
        inherited(traveler, conn);
    }
    scoreMarker: Achievement { +1 "finding the Career Center office" }

    roomDaemon()
    {
        switch(turnsInRoom++)
        {
        case 3:
            "<.p>The woman covers the phone with her hand and says
            to you loudly, <q>Hold your horses---I'll be with you
            in a minute.</q>  She goes back to her phone call. ";
            break;

        case 5:
            /* the return of Frosst Belker */
            "<.p>You hear someone coming through the door, and look over
            to see a slender man in a white double-breasted jacket and
            white slacks sauntering into the room.  You almost groan
            out loud when you realize that it's none other than Frosst
            Belker.  You just hope he's not here to interview the same
            student you are---as tough as it is to beat them at selling,
            it's even harder to beat them at hiring.
            <.p>Belker surveys the room.  He looks at the woman on
            the phone, then at you, then smiles---not warmly, not like
            he's glad to see you, more like he's amused at a private
            joke.  <q>Mr.\ Mittling,</q> he says with his slight accent,
            <q>what a pleasant surprise.  Our respective employers
            evidently have similar tastes in prospective employees as
            well as in clients.  Let us hope that on this occasion,
            your reach is more consonant with your grasp, as it were,
            than it has so often proved in our past encounters.</q> ";

            /* move frosst here */
            frosst.moveIntoForTravel(self);

            /* make frosst 'him', since he's been mentioned prominently */
            me.setHim(frosst);
            break;

        case 6:
            /* give Ms. Dinsdale her folder */
            ccFolder.makePresent();

            /* set up everyone in conversation */
            ccDinsdale.initiateConversation(dinsdaleTalking, 'cc-welcome');
            frosst.setCurState(frosstTalking);

            /* this introduces her */
            ccDinsdale.setIntroduced();
            break;
        }
    }

    turnsInRoom = 0
;

+ ccDoorN: Door -> cssDoorS 'north n door*doors' 'north door'
    "It leads north, back out to the lobby. "

    /* once we're here, don't leave until we finish our appointment */
    canTravelerPass(trav) { return location.doneWithAppointment; }
    explainTravelBarrier(trav)
    {
        reportFailure('You really shouldn\'t go anywhere until you\'ve
            finished with your appointment here. ');
    }
;

+ Fixture, Chair
    'large larger couch/sofa*couches*sofas*furniture' 'large couch'
    "It could easily seat three or four people. "
    disambigName = 'larger couch'
;

+ Fixture, Chair
    'small smaller couch/sofa*couches*sofas*furniture' 'small couch'
    "It's big enough for two or three people. "
    disambigName = 'smaller couch'

    dobjFor(SitOn)
    {
        /* 
         *   to avoid pointless disambiguation queries, arbitrarily pick
         *   the larger couch for 'sit on' 
         */
        verify()
        {
            inherited();
            logicalRank(90, 'pick arbitrary couch');
        }
    }
;

+ Fixture, Surface 'square glass coffee table/top*furniture' 'coffee table'
    "The coffee table has a glass top about four feet on a side. "
;

+ Fixture, RestrictedContainer 'chromed metal literature rack'
    'literature rack'
    "It's a chromed metal rack designed to display magazines or similar
    items, currently being used for a collection of glossy brochures
    from companies recruiting on campus. "

    canPutIn(obj) { return obj.ofKind(RecruitingBrochure); }
    cannotPutInMsg(obj) { return 'The rack is just for recruiting
        brochures; you wouldn\'t want to mess it up by putting
        anything else in it. '; }

    /* 
     *   don't list my contents in the room description (but note that our
     *   contents will still be listed when we're examined directly) 
     */
    contentsListed = nil

    /* customize our Examine contents listing slightly */
    descContentsLister: thingDescContentsLister {
        getFilteredList(lst, infoTab)
        {
            /* make sure our 'various brochures' item goes last */
            if (lst.indexOf(variousBrochures) != lst.length())
                lst = (lst - variousBrochures) + variousBrochures;

            /* otherwise use the standard handling */
            return inherited(lst, infoTab);
        }
        showListPrefixWide(itemCount, pov, parent)
            { "The rack is displaying "; }
    }
;

class RecruitingBrochure: Readable 'glossy recruiting brochure*brochures';

++ RecruitingBrochure 'mortera -' 'Mortera brochure'
    "The brochure features photos of the surprisingly many consumer products
    Mortera makes: <i>Manly</i> Cigarettes, the <i>Mrs.\ Pillskruft's
    Olde-Fashioned</i> line of processed meat and cheese food products,
    <i>Elephant</i> Cigarettes, the popular <i>Ellie Phant</i>
    character line of plush toys for toddlers and logo merchandise
    for teens, <i>HomeAir</i> medical oxygen products for home nursing
    care, <i>MassiveMeal</i> brand frozen entrees, <i>Muffin Farm</i>
    preserved bakery goods, <i>I'm Starving!</i>\ brand fried salty
    snacks, <i>Fitswell-Plus</i> super-sized pants and
    <i>Underswell-Plus</i> super-sized undergarments, and many more.
    You had no idea how many consumer brands this company owns; now
    you appreciate the reason for the fairly recent name change from
    J.R.R.\ Tobacco. "
;

++ RecruitingBrochure 'toxicola -' 'ToxiCola brochure'
    "It's about what you'd expect from the beverage giant.  They seem
    mostly interested in chemistry PhD's. "
;

++ RecruitingBrochure 'locktheon -' 'Locktheon brochure'
    "This brochure is heavily adorned with exciting, action-packed
    military photos: a fighter jet being readied for take-off from the
    deck of an aircraft carrier, a tank rolling past a burning building,
    a chemical warfare suit-clad soldier handing a smiling ethnic
    child a little American flag, a missile being launched from the
    deck of a battleship, a submarine cresting the surface of the
    sea.
    <.p><blockquote><font face='tads-sans'>
    <b><i>Locktheon: Dangerous Weapons for a Dangerous World</i></b>.
    Here at <b><i>Locktheon</i></b>, a lot of our work is <q>top secret,</q>
    but there's one thing that's not <q>top secret</q> these days: the
    world is more dangerous than ever.  War, terrorism, and
    international pacifism threaten America and all Americans like
    never before.  Loose arms control protocols allow---even
    encourage---companies like <b><i>Locktheon</i></b> to sell some of
    the most advanced weapons systems ever built to just about any
    tin-pot dictator.  Here at <b><i>Locktheon</i></b>, we know that
    the advanced defense systems that keep America safe today are the
    same devastating weapons that will threaten America tomorrow.  That's
    why we at <b><i>Locktheon</i></b> can never stop innovating.
    <.p><b><i>Locktheon: Exporting Products, Not Jobs</i></b>.  While
    the rest of corporate America sends jobs overseas to cheaper labor
    markets, <b><i>Locktheon</i></b> is creating jobs while helping to
    contain America's alarming trade deficit.  <b><i>Locktheon</i></b>
    defense systems are among America's leading exports.  And thanks to
    <b><i>Locktheon</i></b>'s industry-leading lobbying efforts,
    America's defense industry is breaking down the trade barriers
    that once held back American competitiveness by limiting what
    America's enterprises could sell to tin-pot dictators.
    <.p><b><i>Locktheon: Keeping America Working</i></b>.  America
    has the world's strongest, most vibrant free-market economy, an
    economy built on uniquely American virtues: rugged individualism,
    risk-taking, and constant innovation.  But all of those virtues
    would mean nothing without the greatest American virtue of all:
    government spending.  Study after classified study has proven
    that America's free-market economy would collapse instantly
    without billions and billions of dollars of federal largesse.
    And that vital federal spending wouldn't be possible without
    companies like <b><i>Locktheon</i></b>.  Think about it:
    in a world without expensive weapons systems, all of those untold
    federal billions would have to be spent on something else; cheese,
    for example.  If the government were to spend the same amount of
    money on cheese that it spends on just one <b><i>Locktheon Liberation
    Star T-702GKV Global Kill Vehicle</i></b>, it would receive enough
    cheese to stretch to the moon and back---<i>sixty-seven times</i>.
    The logistical problems of storage alone would cripple America's
    economy.  But thanks to the industry-leading dollar cost density of
    <b><i>Locktheon</i></b> advanced defense systems, storage space is
    never a problem.
    <.p><b><i>Locktheon: We Build the Weapons that Protect America
    from the Weapons that We Build.</i></b>
    </font></blockquote>
    <.p>It goes on and on like that. "
;

++ variousBrochures: Decoration
    'various other another glossy recruiting others/brochure*brochures'
    'other brochures'
    "They all have that slick, glossy look of an annual report.
    None of them look especially interesting; just a bunch of
    defense contractors, chemical companies, chip manufacturers,
    and software companies. "

    /* 
     *   if we're alone on the rack, we're just 'various brochures';
     *   otherwise we're 'various other brochures' 
     */
    aName = (location.contents.length() == 1
             ? 'various brochures' : 'various other brochures')
    theName = (aName)
    disambigName = 'another brochure'
    isPlural = true
    notImportantMsg = 'There are too many of them; it would take all
                       day to look through them all, and none of them
                       look all that interesting. '

    /* 
     *   list me among the rack's contents when the rack is examined (but
     *   only when the rack itself is examined: don't list in the main
     *   room description, as it's too much detail for that level) 
     */
    isListedInContents = true
;

+ Decoration
    'white plastic wood veneer desk/desks/top/tops*furniture' 'desks'
    "The desks are fairly ordinary office furniture, wood veneer
    with white plastic tops.  They're grouped together on one side
    of the room.  Each is paired with a chair. "
    isPlural = true
;

+ Decoration 'desk chair/chairs*furniture' 'desk chairs'
    "They're just ordinary office desk chairs. "
    isPlural = true
;

+ Decoration 'phone/phones' 'phones'
    "Each desk is equipped with a phone. "
    isPlural = true
;

+ ccDinsdale: IntroPerson 'ma\'am ms. dinsdale/woman*women'
    name = 'woman'
    properName = 'Ms.\ Dinsdale'
    npcDesc = "She's a short, stout woman in her late forties,
        built like a PE teacher.  She's dressed in a white
        polo shirt and dark slacks, and her dark but graying
        hair is arranged in a tight bun. "
    isHer = true
;
++ Component 'dark graying tight hair/bun' 'dark hair'
    "It's arranged in a tight bun. "
;
++ InitiallyWorn 'white polo shirt' 'polo shirt'
    "It's a plain white polo shirt. "
    isListedInInventory = nil
;
++ InitiallyWorn 'dark black navy slacks/pants' 'dark slacks'
    "The pants one of those dark colors that's hard to tell apart
    from one another---navy, black, something like that. "
    isListedInInventory = nil
;

++ ccFolder: PresentLater, Thing 'manila file folder' 'manila folder'
    "It's a thin manila file folder. "
;

++ HermitActorState
    isInitState = true
    noResponse = "You don't want to interrupt her while she's on the phone. "
    stateDesc = "She's sitting at a desk talking on the phone. "
    specialDesc()
    {
        "A woman is sitting at one of the desks, talking
        on the phone. ";

        /* if we've never seen the PC before, note the arrival */
        if (!sawPC)
        {
            "She sees you come in, gives you a little wave, and
            holds up her index finger in the standard <q>just a
            moment</q> gesture. ";

            /* note that we've seen the PC come in now */
            sawPC = true;

            /* set 'her,' since we've been prominently mentioned */
            me.setHer(ccDinsdale);
        }
    }
    sawPC = nil
;

++ dinsdaleTalking: ActorState
    stateDesc = "She's standing here talking with you. "
    specialDesc = "Ms.\ Dinsdale is standing here talking with you. "
;
+++ HelloTopic "You already have her attention. ";

++ workingAtDesk: ActorState
    stateDesc = "She's sitting at one of the desks, working. "
    specialDesc = "Ms.\ Dinsdale is sitting at one of the desks, working. "
;

+++ DefaultAnyTopic
    "She seems kind of busy, so you'd rather not bother her. "
;

++ ConvNode 'cc-welcome'
    npcGreetingMsg =
        "<.p>The woman hangs up the phone and walks over to you and
        Belker, carrying a manila folder.  She looks the two of you
        over.  <q>Would you two be...</q> She searches her folder
        for a moment, the continues, <q>Belker and Mittling?</q>
        <.p><q>Yes, I'm Frosst Belker,</q> Belker says, offering his
        hand, which she shakes briskly.
        <.p><q>I'm Ms.\ Dinsdale,</q> she says, <q>but you can call
        me <q>ma'am.</q></q>  She suddenly bursts into laughter,
        literally slapping her knee and throwing her head back, and
        then, just as suddenly, she's all business again. <q>No, seriously,
        <q>Ms.\ Dinsdale</q> will be fine.</q> She turns to you.
        <q>And you would be Mittling, from Omegatron?</q> "

    commonFollowup = "<.p>She looks again at her folder,
        speaking while flipping through its contents. <q>And you both
        came to see Mr.\ Stamer, I see.</q> She looks up and shakes
        her head. <q>Well,</q> she says in a peevish tone, <q>don't
        shoot the messenger, but I'm afraid Stamer won't be seeing you
        today.  It seems he had something more <q>important</q> to
        do, namely Ditch Day.  I don't suppose either of you have
        ever heard of that before?</q><.convnode cc-ditch> "
;
+++ YesTopic
    "<q>That's right,</q> you say, shaking her hand.
    <<location.commonFollowup>> "
;
+++ NoTopic
    "<q>You can call me <b>Mr.</b>\ Mittling,</q> you say with a smile,
    but she doesn't seem to think it's very funny.  She just glares at
    you for several seconds.
    <<location.commonFollowup>> "
;
+++ DefaultAnyTopic
    "<q>Whoa, there, fella,</q> Ms.\ Dinsdale says. <q>Let's make
    sure we have our P's and Q's all crossed and dotted here.
    You're Mittling, right? Yes or no?</q><.convstay> "
;

++ ConvNode 'cc-ditch'
    commonFollowup()
    {
        "This <q>Ditch Day</q> would be the tradition
        wherein the seniors abandon the campus for the day, yes?
        Leaving behind all manner of creative puzzles and challenges
        which are known, I believe, as <q>stacks,</q> hmm?  Ah, and the
        underclassmen all strive to overcome these challenges to gain
        access to the rooms of the seniors.  Am I informed properly?</q>
        <.p><q>Yep,</q> Ms.\ Dinsdale says, <q>that's basically it.</q>
        <.p><q>So,</q> Belker says, <q>I take it we are to arrange new
        appointments with Mr.\ Stamer?</q>
        <.p>Ms.\ Dinsdale draws closer, speaks almost conspiratorially.
        <q>Let me tell you, if I were you, and he pulled something like
        this with me, I'd flush the little punk right down the john.
        Here, look at this note he left for you and tell me this isn't
        the most arrogant thing you've never seen.</q>  She hands a note
        to Belker; he reads it quickly and hands it to you. 
        <.reveal ditch-day-explained>
        <.convnode accept-stack-pre> ";

        stackNote.moveInto(me);
        me.setPronounObj(stackNote);
    }
;
+++ YesTopic
    "<q>I'm actually an alum,</q> you say.
    <.p><q>Good,</q> Ms.\ Dinsdale replies. <q>I hate explaining things.
    Belker, what about you?</q>
    <.p><q><<location.commonFollowup>> "
;
+++ NoTopic
    "<q>I'm actually a Caltech alum,</q> you say, <q>but I think
    you might have to explain it for Mr.\ Belker here.</q>
    <.p>Belker smiles faintly. <q>Mr.\ Mittling makes a habit of
    underestimating me, it seems. <<location.commonFollowup>> "
;
+++ DefaultAnyTopic
    "You think she's waiting for a yes-or-no answer.  You'd rather
    not change the subject right now, since you need to find out what's
    going on.<.convstay> "
;

+++ stackNote: Readable
    'note from (mr.) (brian) (stamer)/note'
    'note from Brian Stamer'
    "<font face='tads-sans'>Dear Ms.\ Dinsdale,
    <.p>Sorry to spring this on you with no notice, but I have an unusual
    request for the Mitachron and Omegatron reps.  I'd like to ask them
    to take a stab at solving my stack.  If they do, I'll take a job
    at the winner's company, assuming they want to make an offer.  Sorry
    if it seems arrogant of me to want to interview the interviewers like
    this, but most of the recruiters I've met so far weren't technical
    enough to change a lightbulb.  As you know, I want to work someplace
    where I'll be around smart people, and I thought this would be a
    good filter.
    <br><br>---Brian (Dabney, room 4)
    </font> "
    
    mainExamine()
    {
        /* 
         *   we want to initiate the conversation only if this is the first
         *   time we've been described - note the status before we show the
         *   desription 
         */
        local conv = (!described);
        
        /* do the normal work */
        inherited();

        /* initiate the conversation if this is the first time through */
        if (conv)
            ccDinsdale.initiateConversation(dinsdaleTalking, 'accept-stack');
    }

    /* it's not actually here yet */
    location = nil
;

++ ConvNode 'accept-stack-pre';
+++ AskTopic @stackNote
    "<q>What's this note?</q> you ask.
    <.p><q>Have you tried just reading it?</q> she asks. <q>Oops,
    I guess not.</q> "
;
+++ DefaultAnyTopic
    "Ms.\ Dinsdale shakes her head. <q>Just read the note,</q> she
    says impatiently.<.convstay> "
;

class AcceptStackYes: SpecialTopic
    'accept the challenge' ['yes','i','accept','the','challenge','it']
    topicResponse()
    {
        "You hardly have a choice, given Rudy's personal interest in
        hiring Stamer; even so, this could be kind of fun.
        <q>Count me in,</q> you tell Ms.\ Dinsdale. ";

        if (!gRevealed('belker-accepted-stack'))
            "<.p>Belker chuckles.  <q>I also accept, of course.</q>
            <.reveal belker-accepted-stack> ";

        "<.p>She gives you both a shocked look. <q>Really?  Well,
        I think you're both crazy, but I guess it's your cheesecake.
        Stamer lives in Dabney House, room 4.  I hope you kept the
        campus maps I sent you because you're not getting new ones.</q>
        She slaps her knee again and guffaws.  <q>No, seriously, we're
        out of maps.  Anyway.  I think Ditch Day goes until five PM, so
        you've got a whole day to blow.</q>  She shakes her head, rolls
        her eyes, gives you and Belker a little mock salute, and returns
        to her desk.
        <.p>Belker watches her, looking amused.  He finally turns
        to you. <q>It seems we find ourselves once again in a friendly
        rivalry.</q>  He pulls a cell phone out of his pocket and
        absently keys in a number.  <q>May the better man prevail, as
        always.</q>  With a little nasal chuckle, he turns and heads
        out the door, talking into his cell phone.
        <.reveal stack-accepted> ";

        /* our appointment is now concluded */
        ccOffice.doneWithAppointment = true;

        /* set belker heading to the stack */
        frosst.setCurState(goingToStack);
        frosst.knownFollowDest = alley1N;

        /* send Ms. Dinsdale back to her desk, and discard her folder */
        ccDinsdale.setCurState(workingAtDesk);
        ccFolder.moveInto(nil);

        /* this counts toward our score */
        scoreMarker.awardPointsOnce();
    }

    scoreMarker: Achievement { +1 "accepting the Ditch Day challenge" }
;

class AcceptStackNo: SpecialTopic, StopEventList
    'decline the challenge'
    ['no','i','decline','reject','the','challenge','it']
    eventList = [&firstResponse, &secondResponse, &thirdResponse]

    firstResponse()
    {
        "You really want to decline and come back later for
        a normal interview, but you hesitate.  If Belker decides to
        stay here today, you might not get another chance for an
        interview.  And Rudy did seem awfully intent on hiring
        Stamer.<.convstay> ";
    }

    secondResponse()
    {
        "You hesitate again; you feel like you're in a lose-lose
        situation here.  Solving Stamer's Ditch Day stack could be
        fun, but it hardly seems like the right way to conduct a
        job interview.  Even so, it's hard to just leave, knowing
        how much Rudy wants to hire Stamer.<.convstay> ";
    }

    thirdResponse()
    {
        "<q>I think I'll come back when I can do a normal
        interview,</q> you say.

        <.p><q>You actually want to come back and talk to this
        loser?</q> Ms.\ Dinsdale asks.  <q>All right, if that's
        what you want.  I'll talk to Stamer to set up a new time,
        and I'll let you know.</q>

        <.p>You still have a few hours before your flight back, so
        you say your goodbyes and spend some time touring the campus.
        There are several changes since you went to school here,
        especially with all the new construction in the north part of
        the campus.  It's fun seeing the place again, and seeing how
        it's grown.

        <.p>A couple of days go by, then someone from the Career
        Center office calls you at your office to let you know that
        Brian Stamer took a job with Mitachron.
        <<laterMsg>>
        Needless to say, Carl and RudyB are very disappointed.
        It's not like they're going to fire you, but it's unarguably
        another dismal failure, and this time you can't avoid
        the feeling that there was more you could have done. ";

        /* offer finishing options */
        finishGameMsg('YOU HAVE GIVEN UP',
                      [finishOptionUndo, finishOptionFullScore,
                       finishOptionCredits, finishOptionCopyright]);
    }

    /* add-on message for what happens later */
    laterMsg = ""
;

++ ConvNode 'accept-stack'
    npcContinueMsg = "Belker chuckles. <q>I accept the challenge,</q>
        he says.
        <.p><q>You're serious?</q> Ms.\ Dinsdale asks. <q>I think
        you're crazy, but how do I know?  What about you, Mittling?</q>
        <.reveal belker-accepted-stack>
        <.convnode accept-stack2> "
;
+++ AcceptStackYes;
+++ AcceptStackNo
    laterMsg = "It turns out that Belker accepted Stamer's Ditch Day
                challenge after you took off. "
;
+++ DefaultAnyTopic
    "You really should tell her whether or not you're going to accept
    Stamer's challenge.<.convstay> "
;

++ ConvNode 'accept-stack2'
    npcContinueList: StopEventList { [
        '<q>Hey, Mittling!</q> Ms.\ Dinsdale says. <q>How about you?</q> ',

        '<q>Hello-ooo!</q> Ms.\ Dinsdale says, waving her hand in front
        of your eyes like you\'re asleep. ',

        '<q>Well, Mittling, what\'s it going to be?</q> Ms.\ Dinsdale
        says. '
    ] }
;
+++ AcceptStackYes;
+++ AcceptStackNo
    laterMsg = "Belker must have been able to solve the stack, or maybe
                he just made Stamer a great offer. "
;
+++ DefaultAnyTopic
    "You really should answer her question first.<.convstay> "
;

