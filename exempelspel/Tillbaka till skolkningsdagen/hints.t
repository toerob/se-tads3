#charset "utf-8"
/* 
 *   Copyright 2003, 2013 Michael J. Roberts
 *   
 *   Return to Ditch Day - Hints.  This implements the on-line hints
 *   provided with the game.  
 */

#include <adv3.h>
#include <sv_se.h>


/* ------------------------------------------------------------------------ */
/* 
 *   The main hint menu 
 */
topHintMenu: TopHintMenu
    'Select the general area of your question'
;

/*
 *   Provide help on the hint system itself 
 */
+ HintLongTopicItem 'Hint System Overview'
    '''It's tricky to give good hints for IF games.  Hints can spoil
    the fun if they give away too much, but at the same time, it's
    no frustrating being stuck.  We've tried to strike a balance here
    by putting you in control of how strong a hint you receive.
    <.p>
    Hints are presented in a question-and-answer format, with the
    questions grouped into story areas.  To avoid revealing potential
    plot developments too early, the system tries to show you only
    the topics you ought to know about already, based on where
    you are in the story.
    <.p>
    Select the general area where you're stuck, and you'll be given
    a list of questions.  Select the question closest to what you're
    trying to figure out, and the game will start showing you
    hints for that question, one hint at a time.  The first hint
    or two will be very vague and general and usually won't give
    anything away.  Each additional hint will get more specific, and
    the last hint for each question usually gives away the exact solution.
    You can stop after any hint---just press <b>Q</b> and you'll be
    returned to the story.  Try to stop at the first hint that gives
    you any new ideas, to avoid revealing too much at once; you can
    always come back to the same topic later and see more hints if
    you need to.
    <.p>
    Be aware that most people enjoy IF a lot more when they solve all
    of the puzzles for themselves, without any hints.  I've tried to
    design the puzzles in this game to be fair, so that most players
    can keep the story moving without any impossible leaps of logic,
    random guesswork, or feats of telepathy (that is, reading the
    author's mind).  If you do get horribly stuck, though, the hints
    are here for you; just keep in mind that hints belong at the very
    top of the IF dietary pyramid---<q>use sparingly.</q> '''

    /* make sure this is the first item in the menu */
    topicOrder = 1
;

+ HintLongTopicItem 'A Few Words of Advice'
    '''This game is designed to be fun to play, not to frustrate you.
    If you've played other text adventures, especially older
    <q>classic</q> games, you might have gotten the impression that
    IF authors take cruel delight in stumping players and randomly
    killing main characters.  Some do, certainly, but this isn't
    that kind of game.
    <.p>
    There are two things I'd like you to know and to keep in mind
    while you play.
    <.p>
    First, you might encounter some engineering and physics jargon
    in the course of the game.  Don't let it scare you---just think
    of it as <q>technobabble,</q> the way they're always going on
    about <q>nutating the shield harmonics</q> and what not in <i>Star
    Trek</i>.  You don't need a background in physics to play - in
    fact, you're probably better off without it, since the <q>science</q>
    in the story is mostly made up anyway.  You can rely on your
    character to figure things out and fill you in.
    <.p>
    Second, you don't have to worry about <q>losing</q> the game.
    There are no random deaths for the main character, and there
    shouldn't be any way to make the game unwinnable.  You don't
    have to worry that a seemingly innocuous action will turn out,
    hours later, to have ruined the game.  So feel free to explore
    and experiment---no matter what you do, the game should always
    remain winnable. '''

    /* keep this just after the 'hint system overview' topic */
    topicOrder = 10
;

/* ------------------------------------------------------------------------ */
/*
 *   Miscellanous general topics 
 */
+ HintMenu 'General Questions'
    /* keep this just after the 'a few words of advice' topic */
    topicOrder = 20
;

++ Goal 'What does this have to do with Ditch Day?'
    ['''Don't worry; you'll get to that part soon enough.''']
    goalState = OpenGoal

    /* stop showing this hint as soon as we get the ditch day lecture */
    closeWhenRevealed = 'ditch-day-explained'
;

/* ------------------------------------------------------------------------ */
/*
 *   Hints for the prologue
 */
+ HintMenu 'Government Power Plant #6';

/*
 *   A general hint topic for the main goals right now.  In any adventure
 *   game, one of the big problems some players experience is that they
 *   don't know what they're supposed to be doing in general, or they
 *   misunderstand what they're supposed to be doing.  A high-level goals
 *   topic like this can help avoid that sort of frustrating aimlessness.
 *   
 *   The "->" indicates that this goal is achieved as soon as the "->"
 *   expression is true; in this case, we point to the scoreMarker for the
 *   scu1100dx object, which means that we'll consider this goal achieved
 *   as soon as that achievement is scored.  When the goal is achieved,
 *   it'll be automatically "closed," which means it won't show up in the
 *   hint menus any longer.  Once we've accomplished a goal, there's no
 *   reason to give hints for that goal any longer.  
 */
++ Goal ->(scu1100dx.scoreMarker)
    'What am I supposed to be doing?'
    ['''You're here to give the customer a demo of the SCU-1100DX.''',
     '''You can't demo it until you get it working.''',
     'You have to repair the SCU-1100DX.']

    /* make this goal open from the start of the game */
    goalState = OpenGoal

    /* put this at the top of the hint list */
    topicOrder = 100
;

/* 
 *   explain how to repair the SCU; close this goal as soon as we've
 *   awarded the points for repairing the SCU 
 */
++ Goal ->(scu1100dx.scoreMarker)
    'How do I repair the SCU-1100DX?'
    ['Have you looked at it carefully?',
     'Did you notice the empty slot?',
     'What goes in the empty slot?',
     'Have you looked at the CT-22 carefully?',
     '''There's an incorrect component in the CT-22.''',
     hint772lv,
     'Once you put the XT772-LV in the CT-22, just put the CT-22
     back in the SCU-1100DX and turn on the SCU-1100DX.']

    goalState = OpenGoal
;

/*
 *   A 'Hint' object is a line item with a list of answers for a Goal.  In
 *   most cases, we don't bother with a separate Hint object, but just use
 *   a string.  In this particular case, though, we want to make sure that
 *   we make the XT772-LV hints available as soon as we mention the
 *   XT772-LV in a hint (we otherwise wouldn't have mentioned it until the
 *   player saw the ct-22 description).  Using a separate Hint object lets
 *   us do this via our 'referencedGoals' property, which points to one or
 *   more goals that we need to mark as open as soon as we show this hint.
 */
+++ hint772lv: Hint
    hintText = 'You need to replace the XT772-HV with an XT772-LV.'
    referencedGoals = [goal772lv]
;

/*
 *   A hint topic for finding the xt772-lv.  Don't make this hint
 *   available until the player has discovered that they need the XT772-LV
 *   in the first place - they should be able to realize this as soon as
 *   they've seen the xt772-hv.  
 */
++ goal772lv: Goal ->(scu1100dx.scoreMarker)
    'Where can I find an XT772-LV?'
    ['Have you looked at everything here carefully?',
     'Have you looked closely at your own equipment?',
     'Have you looked closely at your circuit tester?',
     'Did you read the warning labels?',
     'Did you notice that the circuit tester has a removable back cover?',
     '''You're supposed to be an engineer, right?  Would an engineer
       pay attention to a warning not to open the back cover?''',
     '''Try opening the circuit tester's back cover.''']

    closeWhenSeen = xt772lv

    /* open the goal when the CT-22 is examined or the LV is mentioned */
    openWhenTrue = (ct22.described || xt772lv.isMentioned)
;

++ Goal 'What do I do now?'
    ['You were supposed to find someone.',
     'You were supposed to find Colonel Magnxi.',
     'Someone was going to take you to the Colonel.',
     '''Just stick with Xojo; he'll lead you to the Colonel.''']

    openWhenAchieved = (scu1100dx.scoreMarker)
    closeWhenSeen = adminLobby
;

++ Goal 'I found Colonel Magnxi.  Now what?'
    ['You were supposed to get the contract signed, right?',
    'Try showing her the contract.',
    'Or, you can just ask her about anything, or even just TALK TO her.']

    openWhenSeen = adminLobby
    closeWhenAchieved = (magnxi.scoreMarker)
;

++ Goal '''I can't get Colonel Magnxi's attention.'''
    ['Maybe you just have to try harder.',
     'Or maybe you just have to try again.',
     '''Keep trying to talk to her, and you'll eventually get her attention.''']

    openWhenSeen = adminLobby
    closeWhenAchieved = (magnxi.scoreMarker)
;

++ Goal 'Uh, now what?'
    ['Just read the print-out Xojo gave you.']
    openWhenTrue = (!adminEmail.isIn(nil))
    closeWhenTrue = (adminEmail.isIn(nil))
;

++ Goal 'Is there a way to avoid getting stuck in the elevator?'
    ['Did you see any stairs?',
    '''There are no stairs; the elevator is the only way down.
    You can't avoid it, and you can't keep it from getting stuck,
    so you'll just have to find a way out once it's stuck.''']
    
    openWhenTrue = (plantElevator.seen && plantElevator.isAtBottom)
    closeWhenAchieved = (powerElevPanel.scoreMarker)
;

++ Goal 'The elevator is stuck.  What do I do now?'
    ['Have you looked around carefully?',
     '''The gate doesn't open here, but maybe there\'s another way out.''',
     'Do you see anything interesting on the ceiling?',
     'How about the service panel?',
     'Maybe you could escape through the service panel.',
     'The only problem is the service panel is too high to reach.',
     '''Maybe there's something you could stand on, or something you
     could climb.''',
     'Try standing on the handrail, or climbing the gate.',
     '''Standing on the handrail and climbing the gate won't work,
     but notice that Xojo will offer to help you up when you try.''',
     'STAND ON HANDRAIL.  When Xojo asks if you want a lift, say YES.',
    'Once Xojo has lifted you up, just open the panel and go UP.']

    openWhenTrue = (plantElevator.seen && plantElevator.isAtBottom)
    closeWhenAchieved = (powerElevPanel.scoreMarker)
;

++ Goal '''I'm out of the elevator, but now I'm stuck in the shaft.'''
    ['Did you try the door?',
     'Okay, so the door is locked.  Take a look at it more carefully.',
     '''There's a locking mechanism on the door.  Examine it.''',
     '''The locking mechanism opens when the elevator car inserts
     something into the slot.  Maybe there's something else you
     could insert to trip the lock.''',
     'You need something thin enough to fit the slot but strong
     enough to trip the lock.',
     'Something like a piece of sheet metal.',
     'The cover for the service match will work.  Put it in the slot.',
     'Now just go through the door.']

    openWhenSeen = atopPlantElevator
    closeWhenAchieved = (doorS2outer.scoreMarker)
;

/* ------------------------------------------------------------------------ */
/*
 *   General hints for the campus 
 */
+ HintMenu 'On Campus';

++ Goal 'How do I find my way around campus?'
    ['Have you looked in your tote bag yet?',
     'Did you notice the campus map?',
     'Look at the campus map.',
     '''The campus map shows the locations of the buildings on campus.
     To find your way to a building, just type FIND <i>building</i>
     ON MAP.  Note that you have to be outdoors to do this, because
     the map doesn't include interior floor plans of any buildings.
     The map also won't help you find your way around inside any
     building; you'll have to rely on exploration for that.''']

    openWhenSeen = sanPasqual
;

++ Goal 'Just how big is the campus?'
    ['''The campus has quite a few locations.  If you're not sure
    what to do next, you might want to just spend a little time
    wandering around, exploring.  Most of the buildings aren't
    too large inside, but a couple---particularly Dabney
    House---are big enough that you might want to make a map.''']

    openWhenSeen = spWalkway
;

++ Goal 'What am I doing at Caltech?'
    ['''You're here to interview a student for a job at your company.''']

    openWhenSeen = sanPasqual
;

++ Goal 'Is there any way to get the Netbisco 9099?'
    ['Did you talk to the workers yet?',
     '''Ask them something, then WAIT for a few turns.  You'll overhear
     some things they say to one another.''',
     'Notice that they have a co-worker down in the shaft.',
     'Notice that they hand stuff to their co-worker from time to time.',
     'Did you look at the shaft carefully?',
     'The shaft reportedly connects to the steam tunnels.  Maybe you could
     reach the bottom of the shaft from the Bridge steam tunnels.',
     'From the Bridge steam tunnel entrance, go eastward (jogging north
     when necessary) until you find Plisnik.',
     'Maybe if you can get rid of Plisnik, you can get the workers on
     the surface to hand you the network analyzer.',
     'Once you get rid of Plisnik, all you have to do is ask the workers
     for the Netbisco 9099.']
    
    openWhenTrue = (quadAnalyzer.described)
    closeWhenTrue = (netAnalyzer.moved)
;

++ Goal 'How do I get past the counter in the Physical Plant office?'
    ['Think about what made you want to get back there.',
     'Come to think of it, did anything actually make you think you
     had any business back there?',
     '''You really don't need to get back there.''']

    openWhenSeen = ppOffice
;

++ Goal 'How do I communicate with the electrician?'
    ['''He only seems to speak German, which your character doesn't
    speak, so there's not much you can talk about with him.''',
     'You could at least show him things, though.',
     'There are a couple of things lying around meant just for him.',
     'Have you been inside the Physical Plant office yet?',
     'Did you look at the job cards?',
     'A couple of the job cards are meant for an electrician.  You could
     try giving him one of those.']

    openWhenDescribed = ernst
    closeWhenTrue = (ernst.location == nil)
;

++ Goal 'Can I get the gardener to let me use the cherry picker?'
    ['You could always just try asking him for it.',
     '''Okay, so he won't willingly let you have it.  Have you been
     inside the Physical Plant office yet?''',
     'Did you look at the job cards?',
     'A couple of the job cards are meant for a gardener.  You could
     try giving him one of those.',
     'Did you read the memo in the Physical Plant office?',
     'Have you run into anyone named Ernst yet?',
     'What does the memo say you should never allow to happen?',
     'Maybe you could arrange for that to happen.',
     '''Unfortunately, the shift supervisor who created the job cards
     paid attention to the memo and didn't arrange for any gardening
     jobs to coincide with any electrical jobs.  But there's another
     thing that you're supposed to avoid.''',
     'Maybe you can make the Gunther and Ernst cross paths on the
     way to new jobs.',
     'It takes a little care with timing, but you can make them both
     cross the Quad at the same time.',
     'Did you notice that Ernst always takes a little while to get going?',
     'Ernst takes long enough to get going that you can dispatch him
     to a new job, then immediately go find Gunther and dispatch him.
     If you time things properly, the two will reach the Quad at
     the same time.',
     '''It's important to get the timing right.''',
     '''The Quad is too far away from where Gunther and Ernst start out,
     so you can't make the timing work from there.''',
     'Gunther and Ernst both have two locations you can send them.
     First send them both to their other location, then send them
     back.  You can make the timing work out on the return trip.'
    ]

    openWhenSeen = cherryPicker
    closeWhenTrue = (gunther.location == nil)
;

++ Goal 'How can I get to the Guggenheim wind tunnel?'
    ['''It's on the roof of the building.  But you can't seem to
    get inside to take the stairs.''',
     '''Maybe there's a way to get up there without going inside
     the building.''',
     'Have you looked carefully at the building?',
     'Have you noticed that Guggenheim is attached to another building?',
     'Did you look carefully at Firestone?',
     'That latticework on Firestone might be worth another look.',
     'People have been known to climb that latticework.',
     '''The only catch is that you need a way to reach the latticework,
     since it doesn't start until well above ground level.''',
     'You need something that will get you up far enough to reach
     the grill.',
     'Something that lifts people a little ways above the ground.',
     '''You should explore around the campus grounds a little more if
     you haven't seen anything that might help.''',
     'Look up Beckman Auditorium on the campus map and go look around.',
     'Maybe that cherry picker would be of use.']

    openWhenSeen = wowWindTunnel
    closeWhenSeen = guggenheimRoof
;

++ Goal 'How do I get into the wind tunnel?'
    ['Did you look carefully at the structure?',
     'Did you examine the small panel?',
     'Try opening the panel.']

    openWhenSeen = guggenheimRoof
    closeWhenSeen = windTunnel
;

++ Goal 'How do I get into the Campus Network Office?'
    ['Did you read the sign?',
     'It says the office will be open again at 1:00 pm.  Maybe you
     should take it at face value.',
     'You have plenty of other stuff to do until then; try working
     on your stack for a while.',
     '''Lunch is usually at noon.  Once you finish with lunch, it
     should be around one o'clock; check back then.''']

    openWhenSeen = jorgensenHall
    closeWhenSeen = networkOffice
;

++ Goal '''What's the deal with Mr.\ Happy Gear?'''
    ['''It's just a little in-joke reference for people who remember
    the original <i>Ditch Day Drifter</i>.''',
     'Mr.\ Happy Gear was one of the random objects you had to find
     to solve the Ditch Day stack in the original <i>DDD</i>.',
     '''Other than that, it's completely unimportant.''']

    openWhenDescribed = mrHappyGear
;

++ Goal '''What's with all the <q>Hovse</q> misspellings?'''
    ['Did you look at the decorative stonework outside Dabney on
    the Orange Walk?',
     '''It's just a little joke about the student hovses.''',
     '''The hovses feature stonework with inscriptions designed
     to look like the inscriptions on classical Roman buildings.  The
     Roman alphabet in classical times didn't have a U; V had roughly
     the phonetic value of the modern U.  So the hovse builders substituted
     V for U in all of the instructions, thus HOVSE for HOUSE.''',
     '''It's always seemed like a silly affectation to me; I mean,
     why worry about one letter when the entire word is historically
     inaccurate?  If they had <i>really</i> wanted to be historically
     accurate, they might have written something like DOMVS DABNEIIS.''']
    
    openWhenSeen = orangeWalk
;

/* ------------------------------------------------------------------------ */
/*
 *   Hints for the Sync Lab 
 */
+ HintMenu 'The Sync Lab';

++ Goal 'How do I get into the Sync Lab?'
    ['''There doesn't seem to be any way of unlocking the door in
    the parking lot.''',
     'Maybe you need an indirect approach.',
     '''Don't worry too much about this for now; something might
     occur to you after you've explored more.''']

    openWhenSeen = syncLot
    closeWhenSeen = firestoneRoof
;

++ Goal 'How do I get into the Sync Lab?'
    ['You should do some more exploring in the general area.',
     'What else seems nearby?',
     'Firestone is nearby, but it blocks the way in.',
     'Maybe you could get past Firestone somehow.',
     'Think three-dimensionally.',
     'Try exploring some rooftops more thoroughly.',
     'Specifically, the roof of Firestone.',
     'Check to see where that ladder goes.']

    openWhenSeen = firestoneRoof
    closeWhenSeen = syncLabRoof
;

++ Goal 'How do I get into the Sync Lab?'
    ['''You've already technically been to the Sync Lab.''',
     '''You just haven't been inside yet.''',
     '''You've been on the roof of the building.  Maybe there's a
     way inside from there.''',
     'Look at the rectangular fixture.',
     'Open the door and go inside.']

    openWhenSeen = syncLabRoof
    closeWhenSeen = syncCatwalkSouthWest
;

++ Goal 'How do I cross the gap in the catwalk?'
    ['''It looks like there's a drawbridge, but unfortunately it seems
    to be inoperable.''',
     '''Maybe there's something else you could use to bridge the gap.''',
     'Explore the lab a bit.',
     'Did you notice anything standing out among all the crates and
     boxes?',
     'Maybe one unusual crate?',
     'Look at the metal crate in the Open Area.',
     'Did you notice anything unusual about, other than its size?',
     '''It's raised off the floor slightly; maybe you should look
     under it to find out why.''',
     '''It's on wheels, so maybe you can move it.''',
     '''You can't move it from the Open Area, but maybe you can get
     around behind it and dislodge it.''',
     'Go north and southwest from the Open Area.  There it is again.',
     'Try pushing it.',
     'Now that you have it free, maybe you could use it somehow.',
     'It looks pretty large---maybe even big enough to bridge that gap.',
     'Try pushing it north from the Open Area.']

    openWhenSeen = syncCatwalkGapWest
    closeWhenTrue = (metalCrate.isIn(syncLab3))
;

++ Goal 'How do I get into the office?'
    ['It looks like you need a combination to open the door.',
     '''Don't worry too much about it for now; should you find
     out you need to get in there, you'll also learn more
     about how to do so.''']
    
    openWhenSeen = syncCatwalkEast
    closeWhenSeen = syncLabOffice
;

/* ------------------------------------------------------------------------ */
/*
 *   Hints for the initial campus section: finding our way to the career
 *   center office 
 */
+ HintMenu 'The Interview';

++ Goal 'Where am I now?'
    ['''You're not anywhere near the power plant.''',
     '''You're on the Caltech campus in Pasadena, California.  Three weeks
     have passed since the previous scene.  You're here to interview a
     candidate for a job at your company.''']

    openWhenSeen = sanPasqual
    closeWhenSeen = ccOffice
;

++ Goal '''How do I find the person I'm supposed to interview?'''
    ['''You're supposed to go to the Career Center Office first.
    They'll put you in touch with the candidate.''']

    openWhenSeen = sanPasqual
    closeWhenSeen = ccOffice
;

++ Goal 'How do I find the Career Center Office?'
    ['The Career Center Office is in the Student Services building on
    Holliston Avenue.',
     '''You can't get too lost at this point; just go north from
     San Pasqual, east off of Holliston, and south from the lobby.''']

    openWhenSeen = sanPasqual
    closeWhenSeen = ccOffice
;

++ Goal '''How do I get the woman's attention?'''
    ['It would be rude to interrupt her phone call.',
     '''Don't worry about it; just hang out a while and she'll eventually
     finish her call and come talk to you.''',
     '''Why not read some of the brochures (on the literature rack)
     while you're waiting?''']

    openWhenSeen = ccOffice
    closeWhenTrue = (ccDinsdale.introduced)
;

++ Goal 'What do I do now?'
    ['Just talk to Ms.\ Dinsdale for a bit.']
    openWhenRevealed = 'ditch-day-explained'
    closeWhenRevealed = 'stack-accepted'
;

/* ------------------------------------------------------------------------ */
/*
 *   Hints for the stack 
 */
+ HintMenu 'Ditch Day';

++ Goal '''What's this Ditch Day thing about again?'''
    ['''It's an annual event where all of the seniors ditch their
    classes for the day and go to the beach, leaving behind <q>stacks</q>
    outside their rooms to keep out the underclassmen.''']

    openWhenRevealed = 'stack-accepted'
    topicOrder = 100
;

++ Goal 'What should I be doing?'
    ['You\'re trying to solve Stamer\'s stack, so that you can hire
    him into Omegatron.']

    openWhenRevealed = 'stack-accepted'
    topicOrder = 110
;

++ Goal 'Where\'s this so-called <q>stack</q> I\'m supposed to find?'
    ['Ms.\ Dinsdale mentioned where Stamer lives.  That\'s where
    you\'re going.',
     'You\'re going to Dabney House, room 4.',
     'If you\'re not sure where Dabney House is, have you looked inside
     your tote bag?',
     'You have a map of the campus, so just FIND DABNEY HOUSE ON MAP.
     (You\'ll need to be outdoors before this will work, though, because
     the map doesn\'t show any interior floor plans.)']

    openWhenRevealed = 'stack-accepted'
    closeWhenSeen = alley1N
;

++ Goal 'How do I get the key from Erin?'
    ['Have you asked her for it?',
     'She won\'t give it to you as long as she\'s working on the stack,
     but don\'t worry: she won\'t be working on the stack for long.
     Just stay near her for a couple of turns.']

    openWhenRevealed = 'erin-has-key'
    closeWhenTrue = (!labKey.isIn(erin))
;

++ Goal 'What am I supposed to do with the <q>black box</q>?'
    ['Did you look at it?',
     'When you examined the black box, the story gave you some ideas
     for test gear that you\'ll need.',
     'You need an oscilloscope and a signal generator.',
     'Did you read the sign on Brian Stamer\'s door?',
     'Brian left the equipment you\'ll need in his lab.']

    openWhenSeen = alley1N
    closeWhenTrue = (blackBox.equipGathered)
;

++ Goal 'How do I figure out what the <q>black box</q> does?'
    ['You gathered the test equipment, right?',
     'Maybe you should use the test equipment.',
     'You might start by plugging the oscilloscope into the black box.',
     'It would also help to turn on the oscilloscope.',
     'Does that suggest anything else you could try?',
     'Try plugging the signal generator into the black box while the
     oscilloscope is still attached.',
     'Turn on the signal generator, of course.  <b>Then</b> plug
     in the oscilloscope.',
     'Okay, so that didn\'t exactly solve the stack, but at least it
     gives you an idea of what to do next.',
     'You need to do some background reading and get some practice
     working with circuitry.',
     'Once you do all that, just try probing with the signal generator
     and oscilloscope again.']
    
    openWhenTrue = (blackBox.equipGathered)
    closeWhenTrue = (blackBox.timesRead != 0)
;

++ Goal 'Where would I find a <q>good EE textbook</q>?'
    ['What\'s a good place to find books in general?',
     'Maybe a big building devoted to housing lots of books...',
     'The library, for example.',
     'If you haven\'t been to the library yet, go outside and
     find the library on your map.',
     'You might need someone to recommend a book (see the separate
     hints on that.)']
    
    openWhenRevealed = 'need-ee-text'
    closeWhenSeen = morgenBook
;

++ Goal 'Where can I get a recommendation for a good EE textbook?'
    ['Maybe there\'s someone on campus who could help.',
     'Maybe a student.',
     'Have you met any electrical engineering students?',
     'Erin and Aaron mentioned they were EE students.  Go ask them.',
     'If you\'re not sure where they are, just wander around Dabney
     a bit.',
     'They\'re working on a stack in Alley 7.',
     'From the courtyard, go up the stairs, then north, and north again.']

    openWhenRevealed = 'need-ee-text'
    closeWhenSeen = morgenBook
;

++ Goal 'Where can I get some practice debugging circuitry?'
    ['Explore Dabney a little; maybe you\'ll come across something.',
     'Check the locations near the courtyard.',
     'You\'re looking for some kind of electronic device that\'s in
     need of repairs.',
     'Something out of order.',
     'Go into the alcove off the courtyard.',
     'The Positron game needs repairs.',
     'Be sure to look carefully at the machine.  In particular, take
     note of the instruction card.']

    openWhenRevealed = 'need-ee-text'
    closeWhenRevealed = 'positron-repaired'
;

++ Goal 'How do I find Scott?'
    ['You might start by going to his room.',
     'The instruction card mentioned that he\'s in room 39.',
     'Room 39 is in Alley 7.',
     'From the courtyard, go up the stairs, then go north, and north again.',
     'Try knocking on his door.',
     'If there\'s no one else around right now, you should hold off
     for a while---go back and work on Stamer\'s stack for a bit.',
     'If Erin and Aaron are around, just ask them about Scott.']

    openWhenRevealed = 'find-scott'
    closeWhenTrue = (scott.moved)
;

++ Goal 'Where can I find electronic test equipment?'
    ['Did you read the sign on Brian Stamer\'s door?',
     'Brian left the needed equipment in his lab.',
     'The sign mentions that his lab is in Bridge, room 022.  (Bridge
     is a building on campus---you can find it on your campus map
     if you\'re not sure how to get there.)']

    openWhenRevealed = 'needed-equip-list'
    closeWhenTrue = (blackBox.equipGathered)
;

++ Goal 'Oscilloscopes? Signal generators? I\'m not an EE major!'
    ['Relax---you don\'t need to know anything about electronics
    to play the game.  Your <i>character</i> might have to know
    some electronics, but you don\'t.',
     'You don\'t even have to worry about the details of running
     the test equipment; your character will take care of that.']

    openWhenTrue = (gRevealed('needed-equip-list')
                    || oscilloscope.moved
                    || signalGen.moved)
    closeWhenRevealed = 'black-box-solved'
;

++ Goal 'How can I get past the smoke in Alley One?'
    ['Maybe you just need to wait a while.',
     'Did you run into anyone in the breezeway?',
     'What time did Erin say it was?',
     'Erin said it\'s lunchtime.  You might as well get some lunch
     while you\'re waiting for the fire to be put out.',
     'Go to the Dabney dining room and have some lunch.']

    openWhenTrue = (bwSmoke.location != nil)
    closeWhenRevealed = 'after-lunch'
;

++ Goal 'What\'s a Hovarth function?'
    ['You know where to look for information like this.',
     'You just need a copy of the DRD math tables.',
     'Like most of the other books you\'ve needed, this one is
     probably available in the library.',
     'It\'s a math book, so try the math floor.',
     'Once you find the book, just look up Hovarth functions in it.']

    openWhenRevealed = 'hovarth'
    closeWhenRevealed = 'drd-hovarth'
;

++ Goal 'How do I calculate that Hovarth number?'
    ['The DRD doesn\'t list the number, so you need to calculate it
    somehow.',
     'The DRD mentioned that these numbers are computationally
     intractable.',
     'Have you run into anything other mention of computationally
     intractable problems?',
     'Did you read the background information on Stamer\'s research
     project, as referenced in the report in his lab?',
     'Read the report, and then go find the references in the library.
     Then go back and read the report again.  That will point you to
     one more reference you should look at.',
     'Now, this should give you some ideas about how to proceed.',
     'Hovarth functions are computationally intractable, but maybe
     a <q>quantum computer</q> could handle the job.',
     'Have you looked at the equipment in Stamer\'s lab carefully?',
     'Have you played with it?',
     'Have you figured out what\'s going on when you push down on the
     Dice-O-Matic while the equipment is running?',
     'The equipment is creating a <q>decoherence</q> field.  Anything
     you put inside will start showing <q>quantum</q> behavior.',
     'Putting a computing device of some kind inside the equipment
     could make it into a quantum computer.',
     'A calculator is a kind of computer that might fit in the
     equipment.',
     'If you could properly program a calculator, you could put it
     in the equipment to turn it into a quantum calculator, which
     could then solve the problem.',
     'Your skills at programming calculators aren\'t up to the task,
     but maybe there\'s someone else who could help out.',
     'Have you been to the bookstore yet?',
     'Did you read the newspaper?',
     'Did you see the part about Jay?',
     'Maybe Jay could program the calculator as needed.']

    openWhenRevealed = 'drd-hovarth'
    closeWhenTrue = (calculator.isProgrammed)
;

++ Goal 'Where can I find a calculator?'
    ['There\'s one in plain view, in one of the places you\'ve
    already been.',
     'There\'s a calculator in Stamer\'s lab in Bridge.']
    
    openWhenRevealed = 'qc-calculator-technique'
    closeWhenTrue = (calculator.moved)
;

++ Goal 'How do I find Jay?'
    ['Have you been to the bookstore yet?',
     'Did you read the newspaper?',
     'Jay is a student in Dabney.  Maybe he\'s working on a stack.',
     'Go ask Aaron about Jay.',
     'Jay is in Alley Four.  Go ask the people there about him.']

    openWhenRevealed = 'dvd-hovarth'
    closeWhenSeen = jay
;

++ Goal 'How do I get Jay to help me?'
    ['First, you need to explain what you need him to do.',
     'There are two main things you need to cover: Hovarth numbers,
     and quantum computers.',
     'You can just ask Jay about Hovarth numbers.',
     'Quantum computers are a bit hard to explain, though.  Maybe
     you can just let him read about them for himself.',
     'Give Jay the <i>Quantum Review Letters</i> number 73:9a.',
     'When he\'s done reading, you can just give him the calculator.',
     'But before he\'ll program the calculator for you, you have to
     do something for him, which he\'ll explain.']

    openWhenTrue = (gRevealed('dvd-hovarth') && jay.seen)
    closeWhenRevealed = 'jay-ready-to-program'
;

++ Goal 'How do I find Turbo Power Squirrel?'
    ['Jay tells you where he thinks it is.',
     'You just need to get into the Guggenheim wind tunnel.']

    openWhenRevealed = 'squirrel-assigned'
    closeWhenRevealed = 'squirrel-returned'
;

++ Goal 'Jay programmed the calculator; now what?'
    ['Remember the Dice-O-Matic?  If not, go back to Stamer\'s lab
    and have a closer look.',
     'The equipment in Stamer\'s lab turns ordinary things into weird
     quantum things.  So maybe it could turn your ordinary calculator
     into a quantum computer.',
     'Put the calcalator in the experiment and turn it on.  Push the
     green button.  Follow Jay\'s instructions to enter the number
     from the black box.']

    openWhenTrue = (calculator.isProgrammed)
    closeWhenRevealed = 'hovarth-solved'
;

++ Goal 'Okay, Stamer\'s door is open; what now?'
    ['It\'s traditional after solving a stack to enter the senior\'s room.
    You broke past their defenses, after all.',
     'Just go into room 4.']

    openWhenTrue = (room4Door.isOpen)
    closeWhenTrue = (me.isIn(room4))
;

++ Goal 'I\'m in Stamer\'s room.  What now?'
    ['Help yourself to the bribe---you earned it.',
     'Just hang out for a while.  Brian will show up shortly.',
     'When Brian shows up, talk to him.']

    openWhenTrue = (me.isIn(room4))
;

/* ------------------------------------------------------------------------ */
/*
 *   The library 
 */
+ HintMenu 'Millikan Library';

++ Goal 'How do I get past the receptionist?'
    ['Did you read the sign?',
     'What does the receptionist ask you for?',
     'You might be thinking you have to trick him somehow, but you don\'t.',
     'After all, you\'re an alum, so you\'re allowed to use the library.',
     'Maybe you have an ID card proving that.',
     'Did you check your wallet?',
     'Show your alumni ID card to the receptionist.']

    openWhenSeen = millikanLobby
    closeWhenSeen = millikanElevator
;

++ Goal 'How do I find the book I\'m looking for?'
    ['You might have noticed that the library\'s floors are dedicated
    to different subjects, so you need to find the right floor first.',
     'There\'s a directory outside the elevator on the first floor
     (look at the elevator if you haven\'t found it yet).',
     'Once you know which floor your book is on, just go there and
     look for it by title (FIND title IN SHELVES).']
    
    openWhenSeen = millikanElevator
    closeWhenTrue = (LibBook.allLibBooksFound)
;

/* ------------------------------------------------------------------------ */
/*
 *   Hints for Bridge Lab 
 */
+ HintMenu 'Bridge Lab';

++ Goal 'Stamer\'s lab is locked!  How do I get in?'
    ['Erin gave you the key when Belker bribed her to go work
    on another stack.  You simply need to use that key.']

    openWhenTrue = (!labKey.isIn(erin))
    closeWhenSeen = basementLab
;

++ Goal 'How do I get into the display case?'
    ['Did you find the alarm system yet?  Stop with this topic until you do.',
     'I thought I said not to continue with this topic until you found the
     alarm system!',
     'Okay, so there\'s no alarm system.  The simple fact is, you don\'t
     need to get into the display case.',
     'Stop worrying about it already; it\'s just scenery.']

    openWhenSeen = bridgeEntry
;

++ Goal 'How do I get the SPY-9 camera?'
    ['You don\'t actually need to take the camera, but there might be
    other interesting things about it.',
     'Did you look carefully at how it\'s wired?',
     'Maybe you should try figuring out where the wire goes.']

    openWhenTrue = (spy9.described)
;

++ Goal 'How do I trace the wire from the SPY-9 camera?'
    ['Did you look at it carefully?',
     'You should go find the wiring closet mentioned when you looked at
     the wire.',
     'The wiring closet is in the sub-basement, down a level from the lab.',
     'Once you\'ve found the wiring closet, you need to figure out which
     wire connects to the camera.',
     'Have you tried searching the mass of wiring?',
     'That suggested a way to identify the wire.',
     'Go upstairs and pull the wire connected to the camera, then go
     downstairs and look at mass of wiring again.']

    openWhenTrue = (spy9Wire.described)
    closeWhenTrue = (bwirBlueWire.described)
;

++ Goal 'Does the tag on the SPY-9 wire mean anything?'
    ['You don\'t have to worry about this for a while.']

    openWhenTrue = (spy9Tag.described)
    closeWhenTrue = (!plisnik.inOrigLocation)
;

++ Goal 'What does the tag on the SPY-9 wire mean?'
    ['Did you check around Plisnik\'s work area yet?',
     'Have a look at the three-ring binder.',
     'The number on the tag is a job number in the binder.']

    openWhenTrue = (spy9Tag.moved && !plisnik.inOrigLocation)
    closeWhenRevealed = 'spy9-ip'
;

++ Goal 'Is there any way to trace the wire beyond the wiring closet?'
    ['You noticed that it goes through a hole in the north wall, right?',
     'So, maybe you should find out what\'s on the other side of the wall.',
     'There\'s no way north from the wiring closet, but maybe there\'s a
     way north from somewhere nearby.',
     'Have you been to the storage room yet?',
     'Have you looked at everything there carefully?',
     'Have you looked at the pile of scrap wood in particular?',
     'There\'s a door behind the scrap wood.',
     'The wood is too heavy to take, but maybe you could move it out
     of the way.',
     'Just MOVE WOOD.',
     'The wiring closet is west of the storage room, so maybe if you
     go through the door and then west, you\'ll find what you\'re looking
     for.',
     'Once you\'re in <q>Narrow Tunnel,</q> try searching the pipes.']

    openWhenTrue = (bwirBlueWire.described)
    closeWhenTrue = (st5Wire.described || steamTunnel8.seen)
;

++ Goal 'Where can I find the books listed in the bibliography?'
    ['Let\'s see...\ where can one find books?  Think, think, think...',
     'If only there were a big building full of all sorts of different
     books...',
     'Have you tried the library?',
     'If you\'re not sure where the library is, try going outside
     and finding the library on your map.']

    openWhenRevealed = 'bibliography'
    closeWhenTrue = (LibBook.anyLibBookFound)
;

/* ------------------------------------------------------------------------ */
/*
 *   Steam tunnels 
 */
+ HintMenu 'The Steam Tunnels';

++ Goal 'What was the combination to the supply room again?'
    ['What, you aren\'t keeping careful notes?',
     'It\'s ' + st8Door.showCombo + '. ',
     'If that doesn\'t work, you might try pushing the Reset
     button before entering the combination---the lock remembers
     button presses until the door is opened.',
     'Also note that once you\'ve successfully opened the door once,
     your character will remember how to do it in the future; all you
     need to type from then on is UNLOCK DOOR, or even just OPEN DOOR.']

    openWhenRevealed = 'supplies-combo'
;

++ Goal 'How do I get into the "Supplies" room?'
    ['You don\'t even want to think about going in there while anyone
    else is around.',
     'You can listen to the door to see if anyone\'s in the room.',
     'If you just wait a little bit, everyone will leave the room.',
     'But you still need to know the combination.',
     'Who would know the combination?',
     'The people already in the room probably know the combination.',
     'If you\'ve avoided the people in the room by leaving each time
     they show up, you\'ve probably noticed that they come and go
     frequently.',
     'Maybe if you could spy on them when they\'re arriving, you could
     see the combination they enter.',
     'But if you leave every time they show up, you won\'t be able to
     spy on them.',
     'Maybe you could stay, and find a place to hide.',
     'Have you looked at everything in the <q>Dead End</q> location?',
     'Have you noticed the nook?',
     'If you STAND IN THE NOOK before the workers show up, they won\'t
     notice you, giving you a chance to spy on them.']

    openWhenSeen = steamTunnel8
    closeWhenRevealed = 'supplies-combo'
;

++ Goal 'How do I avoid getting kicked out of the tunnels by the workers?'
    ['You do get a little warning when they\'re about to show up.',
     'You could just leave before they arrive.',
     'Or perhaps you could stay, and find a place to hide.',
     'Have you looked at everything in the <q>Dead End</q> location?',
     'Have you noticed the nook?',
     'If you stand in the nook before the workers show up, they won\'t
     notice you.']

    openWhenRevealed = 'escorted-out-of-tunnels'
    closeWhenRevealed = 'supplies-combo'
;

++ Goal 'How do I trace the camera past the network router?'
    ['You\'ve traced the physical wiring to the router, but the
    router is connected to the whole campus network, so tracing
    the physical connection is useless beyond this point.',
     'You need instead to trace the network connection.',
     'Each device on the network has an <q>IP address</q> that
     identifies it.  If you could analyze the data on the network,
     you could find out the IP address where the packets are going.',
     'Your character happens to know that a <q>network analyzer</q>
     would let you trace where the data packets are going.',
     'You need to find a network analyzer, plug it into the
     router, and trace the packets coming from the camera.',
     'To trace the right packets, you have to know where the
     packets are coming from.',
     'Like all devices on the network, the camera has an IP address.',
     'You need to find the camera\'s address, and trace packets
     from that address.  That will tell you the address of the
     computer that\'s receiving data from the camera.']

    openWhenRevealed = 'need-net-analyzer'
    closeWhenRevealed = 'spy9-dest-ip'
;

++ Goal 'How do I find a computer if I know its IP address?'
    ['You must have seen a few Network Installer Company
    job-order forms by now.  Did you notice the boilerplate
    text at the top of each form?',
     'Each form says that IP address assignments have to be
     obtained through the Campus Network Office, in Jorgensen.',
     'Maybe you could visit that office and ask them to look
     up the IP address for you.',
     'If you don\'t know where Jorgensen is, just check your
     campus map.']

    openWhenRevealed = 'spy9-dest-ip'
    closeWhenSeen = syncLabOffice
;

++ Goal 'I got the work order for the IP address, but now what?'
    ['You\'ve looked up work orders before.',
     'Look up the work order in the binder you got from Plisnik.',
     'That will tell you where to go and how to get in.']

    openWhenRevealed = 'sync-job-number-available'
    closeWhenSeen = syncLabOffice
;

++ Goal 'Where can I find a <q>network analyzer</q>?'
    ['Have you run into anyone else around campus working on networks?',
     'Someone dressed similarly to the workers you saw in the tunnels,
     perhaps?',
     'The workers out on the Quad are wearing similar uniforms.',
     'Look at the equipment the workers on the Quad have.']

    openWhenRevealed = 'need-net-analyzer'
    closeWhenTrue = (netAnalyzer.moved)
;

++ Goal 'What do I do with the network analyzer?'
    ['Did you find the instructions on how to use the analyzer yet?',
     'Have you run into any other networking gear?',
     'Down in the steam tunnels somewhere, perhaps?',
     'You need to find your way into the room marked <q>Supplies</q>
     before you need the network analyzer.',
     'Once you\'re in the network room (the room marked <q>Supplies</q>),
     take a closer look at the router.',
     'You should notice two things.  First, note where the blue wire goes
     (the one you\'ve been tracing).  Second, note the special jack on
     the router.',
     'You\'ve probably figured out that you can plug the network analyzer
     into the router\'s special jack.',
     'What do you want to know about the router?',
     'You want to trace what\'s connected to the camera, which requires
     that you trace the data packets from the camera through the router.
     The network analyzer can do this.',
     'Once you figure out how to work the network analyzer, you just
     need to type the special code to trace packets from the camera.
     You need to know the camera\'s IP address to do this.']

    openWhenTrue = (netAnalyzer.moved)
    closeWhenRevealed = 'spy9-dest-ip'
;

++ Goal 'I don\'t understand the network analyzer instructions!'
    ['They do seem to be poorly translated.  It might help to
    know that tracing a data packet on a network is often known
    by the jargon <q>packet sniffing.</q>',
     'What you\'re after here is a way to trace a packet from
     one computer to another.  Computers are identified by their
     <q>IP addresses,</q> so if you know the IP address of the
     computer sending data, you want to find out the IP address
     of the computer receiving those packets.',
     'Note that the instructions are trying to warn you that the
     network analyzer model you have uses different code numbers
     than most of the other models.  The hand-written bits at the
     bottom of the page might be important.']

    openWhenDescribed = netAnInstructions
    closeWhenRevealed = 'spy9-dest-ip'
;

++ Goal 'What\'s an <q>IP address</q>?'
    ['It\'s just some computer jargon for a special number assigned to
    each computer or other device that\'s hooked up to a computer network.
    Each device has its own unique IP address, which identifies it so
    that the other devices on the network can send information to it.
    <q>IP</q> stands for <q>internet protocol,</q> and it\'s called
    an <q>address</q> because it\'s kind of like your street address,
    in that it tells other machines where you are so that they can send
    you information.  There\'s nothing meaningful about the actual numbers
    in an IP address, at least in this story; it\'s just an arbitrary
    identification number, kind of like a social security number.
    IP addresses are usually written like this: 89.99.100.101---four
    decimal numbers, ranging from 0 to 255, separated by periods.']

    openWhenTrue = (netAnalyzer.moved)
;

++ Goal 'How do I convert decimal to hexadecimal (or vice versa)?'
    ['Hexadecimal is just base 16.  0-9 are the same as in decimal;
    10 in decimal is written as A in hex, 11 as B, 12 as C, 13 as D,
    14 as E, and 15 as F.  16 in decimal is written as 10 in hex.
    To read a hex number, treat each digit as a power of 16: the
    last digit is the units, the second-to-last is 16\'s, the
    third-to-last is 256\'s, and so on.  So 100 hex is 1x256=256,
    200 hex is 2x256=512, 123 hex is 1x256+2x16+3x1=291.',
     'Of course, the <i>easy</i> way to convert is to use a hex
     calculator.  The Windows CALC program can show hex in its
     <q>Scientific</q> mode, for example. ']

    openWhenTrue = (netAnalyzer.moved)
;
++ Goal 'What\'s <q>hexadecimal</q>?'
    ['It\'s a base-16 number system.  Remember the stuff from
    elementary school about using different arithmetic bases?
    The idea is that each digit can hold 16 different values
    rather than just the usual 10.  You need more than just
    the digits 0 through 9 to represent the extra values,
    so in hexadecimal, you add A through F---A stands for
    the decimal value 10, B for 11, C for 12, D for 13, E
    for 14, and F for 15.  So the hexadecimal (or just <q>hex</q>)
    number 25 means 2 times 16, plus 5, or 37 in decimal.  1F
    means 1 times 16, plus 15, which adds up to 31 in decimal.
    100 in hex is 1 times 16 times 16, or 256 in decimal.  123
    in hex is 1 times 16 times 16, plus 2 times 16, plus 3,
    which is 291 in decimal.',
     'Computer programmers tend to use hex numbering a lot
     because it\'s relatively easy to convert hex numbers to
     and from binary.  The exact reasons for this will be left
     as an exercise to the reader, but it has to do with powers
     of 2.']
    openWhenTrue = (netAnalyzer.moved)
;

++ Goal 'Where do I find instructions for the network analyzer?'
    ['Who was supposed to be using the network analyzer?',
     'It\'s not the workers on the quad who use the network analyzer---it\'s
     Plisnik.',
     'Have you looked at the other things where Plisnik was?',
     'Did you look at the three-ring binder?',
     'Did you read it?',
     'The piece of paper that falls out of the binder has instructions
     on using the network analyzer.',
     'The instructions are kind of hard to read, since they\'re poorly
     translated from some other language, but you should be able to make
     sense of them.',
     'You just need the part about <q>packet smelling</q> (which really
     means <q>packet sniffing,</q> computer jargon for tracing the flow
     of data on a network from one computer to another).',
     'Note the hand-written comments at the bottom of the page.',
     'To trace packets on the network, type 09 plus the IP address
     you want to trace.  For example, to trace packets from a device
     with IP address 8.9.10.11, you\'d type in 0908090A0B.']

    openWhenTrue = (netAnalyzer.moved)
    closeWhenRevealed = 'spy9-dest-ip'
;

++ Goal 'How do I get the IP address for the SPY-9?'
    ['Did you notice the tag on the wire connected to the camera?',
     'Did you look around Plisnik\'s work area after he left?',
     'Did you find the three-ring binder?',
     'Did you look in it?',
     'The number on the wire tag is a work order number. Look it up
     in the binder.',
     'The work order referenced on the wire tag refers to another
     work order. Look that one up too.',
     'The dotted four-part number on the work order is the camera\'s
     IP address.']
    
    openWhenTrue = (netAnalyzer.moved && nrRouter.seen)
    closeWhenRevealed = 'spy9-dest-ip'
;

++ Goal 'How do I get rid of Plisnik?'
    ['Try talking to him a bit.',
     'You\'ve undoubtedly noticed he has a favorite topic.',
     'Something he\'s scared of.',
     'Plisnik is scared of rats.  Maybe a rat would scare him away.',
     'Have you found the plush rat toy?',
     'Maybe you could try showing it to Plisnik.',
     'Okay, so he\'s not scared of a toy rat. But what if you made
     it look alive?',
     'Did you notice it\'s a hand-puppet?',
     'Try putting it on your hand and showing it to him.',
     'So that doesn\'t convince him either. Maybe you need to make the
     toy rat look like it\'s moving around without your help.',
     'Have you been inside Thomas yet?',
     'Did you find anything interesting around the robotics competition?',
     'Have a look at the toy car.',
     'The toy car appears to move around on its own, if you drive it
     with the remote.',
     'Maybe you could use the toy car to make the toy rat look alive.',
     'Put the rat on the toy car.  Go into the steam tunnel next to
     where Plisnik is working, and drive the rat in remotely.']

    openWhenSeen = plisnik
    closeWhenTrue = (!plisnik.inOrigLocation)
;

++ Goal 'Is there anything I need to look up in the three-ring binder?'
    ['Notice the job number format: 1234-5678.',
     'Have you seen anything else in that format?',
     'How about something in the lab in Bridge?',
     'Something related to the SPY-9.',
     'Try looking up the number on the tag on the SPY-9 wire.']
    
    openWhenTrue = (workOrders.described && spy9Tag.described)
    closeWhenRevealed = 'spy9-ip'
;

++ Goal 'How do I get through the north-south crawl?'
    ['Do you have any reason to go that way?',
     'You don\'t have to worry about getting through.  There\'s
     nothing you need on the other side.']

    openWhenSeen = steamTunnel15
;

/* ------------------------------------------------------------------------ */
/*
 *   Other stacks 
 */
+ HintMenu 'The Other Stacks';

++ Goal 'How do I solve Paul\'s Stack (room 42)?'
    ['Before you get sucked into this too much, you might note
    the warnings the story shows every so often about how this stack
    isn\'t very important. (Try typing in a few random passwords if
    you haven\'t seen the warnings yet.) ',
     'You don\'t need to solve this stack to win the game. ',
     'This stack is entirely optional, so we\'re going to leave it
     as an exercise for the reader.  Be assured that there is a solution,
     though (possibly even more than one). ',
     'For extra bonus nerdliness, try finding another password that
     the computer repeats back to you in <i>reverse order</i>.  (This
     doesn\'t do anything special in the game, but it\'s an interesting
     extra challenge once you figure out how the puzzle works.) ']

    openWhenSeen = commandant64
    closeWhenTrue = (room42door.isSolved)
;

++ Goal 'How do I solve the Giant Chicken Stack (room 12)?'
    ['If you\'ve been looking for someone, you might be able to
    find them here.',
     'You might try talking to the chickens.',
     'If they\'re not very responsive, it might have to do with the
     rules of the stack.',
     'You might want to read the notebook (on the door to room 12)
     for information on the stack.',
     'The chickens can only talk to other chickens.',
     'Maybe you could find a way to join them.',
     'Have you checked out the Chickenator?',
     'Go into the Chickenator and put on the suit.  That\'ll let you
     talk to the chickens and ask about the person you\'re looking
     for.',
     'Beyond that, there\'s nothing you have to do with this stack.
     You don\'t have time for a scavenger hunt dressed as a giant
     chicken.']

    openWhenSeen = alley3E
;

++ Goal 'Can I help with the Turbo Power Animals stack (room 22)?'
    ['You have plenty to do on your own stack.  You probably
    shouldn\'t worry too much about this one, unless a good reason
    comes up.']

    openWhenSeen = alley4W
    closeWhenRevealed = 'squirrel-assigned'
;

++ Goal 'Can I help with the Turbo Power Animals stack (room 22)?'
    ['You could use Jay\'s help, so it seems worth your time to go
    retrieve Turbo Power Squirrel.',
     'Beyond that, you should probably stay focused on your own task
     of solving Brian Stamer\'s stack.']
    
    openWhenRevaled = 'squirrel-assigned'
;

++ Goal 'How do I solve the <i>Honolulu 10-4</i> stack (room 24)?'
    ['Have you tried playing the game?',
     'Practice might help.',
     'But even with practice, the music is an intolerable distraction.',
     'Unfortunately, there\'s no way to turn off the music.',
     'You probably shouldn\'t worry too much about this stack for now.
     Brian Stamer\'s stack is much more important to you.']

    openWhenSeen = alley5S
;

++ Goal 'How do I solve the fruit fly stack (room 35)?'
    ['You probably shouldn\'t let this stack take time away from
    your main task of solving Brian Stamer\'s stack, unless a good
    reason comes up.']

    openWhenSeen = alley6E
;

++ Goal 'How do I solve the brute-force stack (room 50)?'
    ['The students seem to have this one under control.  You
    should probably focus your efforts on Brian Stamer\'s stack.']

    openWhenSeen = lower7W
;

