/* 
 *   Copyright 2003, 2013 Michael J. Roberts
 *   
 *   Return to Ditch Day - main game frame routines.  This defines the main
 *   entrypoint, the startup routines, and the finishing routines.  
 */

#include <adv3.h>
#include <en_us.h>

/* ------------------------------------------------------------------------ */
/*
 *   gameMain is the object that controls the game's startup.  The library
 *   calls routines in this to start the game.  
 */
gameMain: GameMainDef
    /* the initial (and only) player character is 'me' */
    initialPlayerChar = me

    /* show our introduction */
    showIntro()
    {
        /* show the prologue */
        "\bOnce again, you, Doug Mittling, got stuck with the crappy
        travel assignment. It's the downside of being a middle
        manager---your engineers were all too busy with real work,
        and your vice president had an important fact-finding trip to
        Maui, but you had no excuse apart from a big pile of process
        reports to review.  So here you are, at an anonymous power
        plant in a mosquito-infested jungle somewhere in south Asia,
        the nearest airport a twelve-hour drive away.  You've been
        here six weeks already, trying to get this crappy SCU-1100DX
        working so you can give the customer a demo, but so far it's
        still broken.  It's starting to feel desperate, especially
        since you've overheard Guanmgon talking about Mitachron
        several times recently.  If you lose this contract to
        Mitachron, your VP will be furious.  When he gets back from
        Maui, of course.\b";

        /* show the game title */
        "<b>Return to Ditch Day</b>\n
        by Michael J.\ Roberts\n
        Release <<versionInfo.version>> (<<versionInfo.serialNum>>)
        \b";
    }

    /* show our "goodbye" message */
    showGoodbye()
    {
        "<.p>Thanks for playing <i>Return to Ditch Day</i>!\b";
    }
    
    /* 
     *   Start a new game.  Before we launch into the game, we show some
     *   startup options.
     *   
     *   I use this extra pre-game screen because I personally like getting
     *   the "administrative" tasks out of the way before actually getting
     *   into the narrative.  It's become something of a convention in IF
     *   to show you the introductory text first, and only then ask you to
     *   type ABOUT and CREDITS and so on to see a bunch of information
     *   about the mechanics of the game.  I don't like this because it
     *   totally blows my sense of immersion - reading the introduction
     *   gets me all mentally geared for getting into the story, and then
     *   just as I'm getting to the good part, the author goes and blows it
     *   with an explanation of how ASK ABOUT works.  So, we get this out
     *   of the way up front - we offer options to see the usual sundry
     *   game-mechanics stuff, or to restore a previous session.  After the
     *   player's satisfied with the administrative stuff, we start the
     *   game.  
     */
    newGame()
    {
        /* restore the global default settings */
        SettingsItem.restoreSettings(nil);

        /* starting a new session - show the startup options */
        switch(runStartupOptions())
        {
        case 1:
            /* 
             *   regular startup - show the introduction and run the main
             *   command loop 
             */

            /*
             *   Clear and initialize the normal game screen, including the
             *   status line, before we display any text.  This will help
             *   minimize redrawing - if we waited until after displaying
             *   some text, we might have to redraw some of the screen to
             *   rearrange things for the new screen area taken up by the
             *   status line, which could cause some visible redraw
             *   flashing on the display.  By setting up the status line
             *   first, we'll probably have less to redraw because we won't
             *   have anything on the screen yet when figuring the
             *   subwindow banner layout.  
             */
            initScreen(true);

            /* show the introduction */
            showIntro();
        
            /* 
             *   Set up a daemon for guanmgon's phone call.  The daemon
             *   will activate once per turn until we tell it to stop.  
             */
            new SenseDaemon(guanmgon, &phoneScript, 1, guanmgon, sight);

            /* run the game, showing the initial location description */
            runGame(true);
            break;

        case 2:
            /*
             *   We've just restored a saved game.  Simply go directly to
             *   the main command loop; there's no need to show the room
             *   description, since the RESTORE operation will already have
             *   done so. 
             */
            runGame(nil);
            break;

        case 3:
            /*
             *   we're quitting from the startup options - there's no need
             *   to run the game 
             */
            break;
        }

        /* show our 'goodbye' message */
        showGoodbye();
    }

    /*
     *   Run the "startup options."  The game invokes this routine before
     *   we actually start the game, to give the player some options on how
     *   they want to proceed.  The player can simply proceed directly to
     *   the game, can view background (ABOUT) information and/or
     *   introduction-to-IF instructions first, or can restore a previously
     *   saved game.
     *   
     *   This returns 1 if we're to start the game normally, 2 if we're to
     *   skip the introductory text (because we restored a saved game, for
     *   example), 3 if we're to quit immediately.
     *   
     *   We show these startup options immediately after the game program
     *   is launched, before we show the story's introduction.
     */
    runStartupOptions()
    {
        /* 
         *   if we don't need to run the startup options, just continue
         *   into normal game startup 
         */
        if (!sessionInfo.showStartupOptions)
            return 1;

        /* 
         *   We won't need to show startup options again should we find
         *   ourselves back here at some point.  In particular, we'll
         *   return to the main() routine if the player enters the RESTART
         *   command; but we won't want to go through these options again,
         *   since RESTART should take us back to the start of the story,
         *   not this meta-game launch stuff.  So, indicate in our
         *   transient session information that we don't need to ask for
         *   startup options again during this session.  
         */
        sessionInfo.showStartupOptions = nil;

        /* show the cover art */
        "\b\b<center><img src='.system/CoverArt.jpg' width=250 height=250>
        </center>\b\b";
        
        /* show the title/author/version and startup options */
        "\b<b>Return to Ditch Day</b>
        \nRelease <<versionInfo.version>> (<<versionInfo.serialNum>>)
        \nCopyright &copy;2004, 2013 Michael J.\ Roberts
        / Freeware / Type <<aHref('copyright', 'COPYRIGHT')>> for details\n
        
        <.p>If this is your first time playing this game, please type
        <<aHref('about', 'ABOUT')>> (or just 'A') for some important
        information.  To restore a position you saved earlier, type
        <<aHref('restore', 'RESTORE')>> (or 'R').
        <.p>To <<aHref('', 'begin the game')>>, just press the Enter key. ";

        /* keep going as long as they want to stay here */
        for (;;)
        {
            local cmd;
            local kw;
            local rqArg = nil;
            
            cmd = inputManager.getInputLine(nil, {: "\b&gt;" });

            /* check the various allowed commands */
            if (rexMatch('<space>*$', cmd) != nil)
            {
                /* blank line - we're ready to begin the game */
                return 1;
            }
            
            /* check for a keyword */
            if (rexMatch('<space>*(<alpha>+)<space>*$', cmd) != nil)
            {
                /* get the keyword */
                kw = rexGroup(1)[3].toLower();
            }
            else if (rexMatch(
                /*
                 *   This is a little tricky: we match spaces, then RQ or
                 *   REPLAY, then spaces, then a quoted string.  The string
                 *   starts with either a single or double quote, and now
                 *   comes the tricky part: we match any number of
                 *   arbitrary characters, but we use a "negative
                 *   assertion" (that's the "(?!)" group) that says that
                 *   each of those arbitrary characters can't be the open
                 *   quote, which we marked with parens as group #2.
                 *   Finally, we can optionally match the open quote
                 *   character again as a matching close quote, but we
                 *   don't require it.  Then we accept spaces, and then the
                 *   string has to end.  
                 */
                '<space>*(rq|replay)'
                + '<space>+([\'"])(((?!%2).)+)%2?<space>*$', cmd) != nil)
            {
                /* get the keyword */
                kw = rexGroup(1)[3];

                /* get the argument */
                rqArg = rexGroup(3)[3];
            }
            else
            {
                /* there's no keyword - use a string we know we won't match */
                kw = ' ';
            }

            /* check which keyword we got */
            if ('about'.startsWith(kw))
            {
                /* they want the ABOUT information */
                versionInfo.showAbout();
            }
            else if ('restore'.startsWith(kw))
            {
                /* try restoring a game */
                if (RestoreAction.askAndRestore())
                {
                    /* we succeeded - proceed directly to the game */
                    return 2;
                }
            }
            else if ('quit'.startsWith(kw))
            {
                /* do they really want to quit? */
                libMessages.confirmQuit();
                if (yesOrNo())
                    return 3;
                else
                    "Okay. ";
            }
            else if ('hints'.startsWith(kw))
            {
                /* there's no point in showing hints yet; explain this */
                "Sorry, no hints are available right now.  Hints will be
                available as soon as you start the game. ";
            }
            else if ('instructions'.startsWith(kw))
            {
                /* show the instructions */
                InstructionsAction.execSystemAction();
            }
            else if ('copyright'.startsWith(kw))
            {
                /* show the copyright/license information */
                versionInfo.showCopyright();
            }
            else if (kw == 'rq' || 'replay'.startsWith(kw))
            {
                /* if there's no argument, ask for one */
                if (rqArg == nil)
                {
                    /* there's no file, so ask for one */
                    local result = inputManager.getInputFile(
                        'Enter command file', InFileOpen, FileTypeCmd, 0);
                    
                    /* if we got a file, it's the file argument */
                    if (result[1] == InFileSuccess)
                        rqArg = result[2];
                }
                
                /* if we got a file, open it and start the game */
                if (rqArg != nil)
                {
                    /* read from the file */
                    setScriptFile(rqArg, kw == 'rq' ? ScriptFileQuiet : 0);
                    
                    /* go start the game */
                    return 1;
                }
            }
            
            /* refresh them on what to do next */
            "\b(Please type <<aHref('about', 'ABOUT')>> for notes on
            how to play, or <<aHref('restore', 'RESTORE')>> to restore
            a saved position.  To <<aHref('', 'begin the game')>>, just
            press the Enter key.) ";
        }
    }
;


/*
 *   Session information.  This is a transient object with some
 *   miscellaneous information about the gaming session.  It's
 *   transient because we want it to reflect the *session*
 *   status, which means we don't want it affected by things like
 *   Save, Restore, Undo, and Restart.  
 */
transient sessionInfo: object
    /* do we still need to show the startup options? */
    showStartupOptions = true
;

/* ------------------------------------------------------------------------ */
/*
 *   Some miscellaneous numbers and strings we use in information-based
 *   puzzles in the game - combinations for keypad locks, passwords, that
 *   sort of thing.  We keep them here so that it'd easy to select these
 *   values randomly at the start of the game, if we wanted to do so.
 *   
 *   It's common in IF games to randomize the keys for information-based
 *   puzzles as a means to prevent players from getting these keys from
 *   Usenet postings (or whatever) without doing any work in the game.
 *   When a puzzle is based on a physical token within the game, such as a
 *   regular mechanical key, then even a player working from a walkthrough
 *   has to at least run through the steps of obtaining the key in the
 *   game.  Not so with information keys; if an information key is the
 *   same every time the game is played, a player can just get the correct
 *   value from someone else and entirely skip the steps that would reveal
 *   it within the game.  Some authors get unreasonably testy about
 *   players skipping parts of the game; if a player is determined to skip
 *   past your golden prose, there's not much point in trying to force
 *   them to appreciate it.  But there's often a practical reason for
 *   wanting to force the player to go through the motions anyway:
 *   frequently, the author wants to be able make certain assumptions
 *   about the game state that would result from having gone through all
 *   of the key-revealing steps.  Randomizing the information keys
 *   achieves this: a walkthrough can't tell you the actual key values,
 *   since they're different every time, so it instead has to settle for
 *   listing the steps that reveal the keys.  
 */
infoKeys: object
    /*
     *   The input and output values for the "Hovarth" function used in
     *   the Ditch Day stack. 
     */
    hovarthIn = '17281392'
    hovarthOut = '35506392'

    /* the combination to the door in steamTunnel8 */
    st8DoorCombo = '57212'

    /* the combination to the door to the Sync Lab office */
    syncLabCombo = '16974'

    /* the IP address of the sync lab */
    spy9IP = 'C0A848D6'
    spy9DestIP = 'C0A80B26'

    /* the spy9 IP in decimal dotted-quad notation */
    spy9IPDec = static (
        toString(toInteger(spy9IP.substr(1, 2), 16), 10) + '.'
        + toString(toInteger(spy9IP.substr(3, 2), 16), 10) + '.'
        + toString(toInteger(spy9IP.substr(5, 2), 16), 10) + '.'
        + toString(toInteger(spy9IP.substr(7, 2), 16), 10))

    /* the spy9 dest IP in decimal dotted-quad notation */
    spy9DestIPDec = static (
        toString(toInteger(spy9DestIP.substr(1, 2), 16), 10) + '.'
        + toString(toInteger(spy9DestIP.substr(3, 2), 16), 10) + '.'
        + toString(toInteger(spy9DestIP.substr(5, 2), 16), 10) + '.'
        + toString(toInteger(spy9DestIP.substr(7, 2), 16), 10))

    /* the job number for the Sync Lab installation */
    syncJobNumber = '1082-9686'

    /* the job number for installing the Spy-9 camera */
    spy9JobNumber = '3349-2016'

    /* the job number for the Spy-9 IP assignment */
    spy9IPJobNumber = '3312-8622'
;


/* ------------------------------------------------------------------------ */
/* 
 *   An invisible COPYRIGHT finish-game option.  We provide this as an
 *   invisible option because we want to allow it (it's mentioned in the
 *   CREDITS message), but we don't want to clutter the prompt list with
 *   it. 
 */
finishOptionCopyright: FinishOption
    doOption()
    {
        /* just show the copyright message */
        versionInfo.showCopyright();

        /* ask for another option */
        return true;
    }

    responseKeyword = 'copyright'

    /* don't list the option in the prompt */
    isListed = nil
;

/*
 *   A finish option for the AFTERWORD.  We'll only offer this when we
 *   actually win the game. 
 */
finishOptionAfterword: FinishOption
    doOption()
    {
        "<.p>If you finished without getting all of the points, and
        especially if it looks like there are a lot more points to
        be had, you might be wondering what you missed.  The most
        likely answer is that you skipped the optional <q>mystery</q>
        subplot.  There are clues hidden here and there that you
        can follow to figure out what certain unsavory characters
        in the story are really up to.  You can solve the Ditch
        Day stack and win the game without pursuing the mystery at
        all, so if my attempts to pique your curiosity failed, you
        probably didn't miss out on much except points.  If you
        wondered why there was a spy camera hidden in Stamer's lab,
        though, let me assure you that the answer can be found in
        the same places as those missing points.

        <.p>Also, the stack in Upper Seven (room 42) can be solved.
        It's irrelevant to the game, so there's no real in-game reward
        for solving it, but some people might find it to be an enjoyable
        stand-alone puzzle.

        <.p>Some players of the original <i>Ditch Day Drifter</i>
        asked where the term <q>stack</q> comes from.
        To answer, I have to give you a brief history of Ditch Day.
        The first few Ditch Days were simple affairs where the
        seniors really did just ditch classes for the day.  The
        underclassmen were apparently annoyed at being left behind,
        and they expressed this by breaking into the seniors' rooms and
        trashing them.  At some point, the seniors started trying to
        barricade their rooms before they left, by stacking desks and
        other heavy objects against their doors.

        <.p>That's where the term comes from: the seniors literally
        built stacks of heavy objects to block entry to their rooms.
        For their part, the underclassmen weren't deterred; on the
        contrary, they took the stacks as a challenge.  If this
        had developed into an arms race, the tradition would probably
        have become too repetitive (and too destructive) to last very
        long.  Happily, the rivalry instead became ritualized: stacks
        evolved from physical barriers into, essentially, games.
        Ditch Day today is a highlight of everyone's year at Caltech;
        underclassmen look forward to it the way IF'ers look forward
        to the <a href='http://www.ifcomp.org'>annual Comp</a>, and
        seniors take great pride in creating stacks that are original,
        challenging, and fun.  I can't claim to have created more than
        a shadow of the real thing here, of course.

        <.p><tab indent=4><i>&mdash;<tab id=t1>MJR<br>
        <tab to=t1>Palo Alto, California<br>
        <tab to=t1>April, 2004
        </i>"; // $$$ update before final release

        /* ask for another option */
        return true;
    }

    desc = "read the <<aHrefAlt('afterword', 'AFTERWORD', 'AFTER<b>W</b>ORD',
                                'Show the Afterword')>>"
    responseKeyword = 'afterword'
    responseChar = 'w'
    
;

/* ------------------------------------------------------------------------ */
/*
 *   Amusing things to try
 */
modify finishOptionAmusing
    doOption()
    {
        "\bA few amusing things to try:
        <.p>
        <ul>
        \n<li>Smell the Koffee.
        \n<li>Ask Xojo about the elevator after it gets stuck.
        \n<li>Continue down the hall in the sub-basement when
        Xojo is trying to lead you into the storage room.
        \n<li>Ask Xojo about the rope bridge several times before crossing
        it, and again after it breaks.
        \n<li>Examine Colonel Magnxi's hat.
        \n<li>Read the brochures in the Career Center Office.
        \n<li>Ask the librarian about his book several times.
        \n<li>Ask the undergrads in Alley 4 about the stack.
        \n<li>Play the marble-maze game in Alley 5 several times.
        \n<li>Take or eat the fruit in Alley 6.
        \n<li>Solve the Commandant 64 stack in Upper 7.
        \n<li>Look in cannon barrel from the raised cherry picker.
        \n<li>Show Plisnik the rat puppet.
        \n<li>Show Plisnik the rat puppet while wearing it.
        \n<li>Ask Dave (in the Network Office) about Network
        Installer Company.
        \n<li>Try the various suggested excuses when caught outside
        the <q>Supplies</q> room in the steam tunnels.
        \n<li>When outdoors, look at the sky in the afternoon.
        \n<li>Look at the graffiti in the various Dabney alleys (virtually
        every alley location has something to look at).
        \n<li>Look under the bed in Brian Stamer's room.
        \n<li>Wear the giant novelty baseball cap.
        </ul>
        <.p>";

        return true;
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   Initialize the screen.  This clears the screen and optionally sets up
 *   the status line. 
 */
initScreen(showStat)
{
    /* clear the screen */
    cls();

    /* show the status line immediately if desired */
    if (showStat)
        statusLine.showStatusLine();
}

