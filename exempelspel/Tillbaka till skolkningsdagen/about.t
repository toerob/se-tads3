#charset "utf-8"
/* 
 *   Copyright 2003, 2013 Michael J. Roberts
 *   
 *   Return to Ditch Day - "About" information (credits, version, help,
 *   and so on).  
 */

#include <adv3.h>
#include <sv_se.h>

/*
 *   versionInfo - The library expects us to provide an object with this
 *   name to supply some basic information about the game: the name,
 *   version number, author, and so on.  This object also provides methods
 *   for handling a few standard system verbs, such as CREDITS and ABOUT.
 *   The library uses the information here to generate a GameInfo.txt file,
 *   which we store in the compiled .t3 file as a resource for use by the
 *   HTML TADS Game Chest feature and any other tools that wish to extract
 *   the information.  
 */
versionInfo: GameID
    name = 'Return to Ditch Day'
    version = '2.se'
    byline = 'by Michael J.\ Roberts'
    htmlByline = 'by <a href="mailto:mjr_@hotmail.com">'
                 + 'Michael J.\ Roberts</a>'
    authorEmail = 'M.J. Roberts <mjr_@hotmail.com>'
    desc = 'It\'s been a decade since you graduated, but now it
        looks like you\'re going to have to solve one more
        Ditch Day stack.
        \\nYou play a Caltech alum whose big-company employer
        sends you back to campus to recruit a star student. But
        when you get there, you find the tables turned when your
        candidate makes you audition to be his employer. What do
        you have to do to win your new recruit? You just have to
        solve a little Ditch Day stack, of course.
        \\nReturn to Ditch Day is a sprawling interactive
        adventure, part treasure hunt, part mystery, part science
        fiction. It was written as a demonstration and example
        of TADS 3, the latest generation of the TADS authoring
        tool for Interactive Fiction, but it\'s not just a demo -
        it\'s a full-fledged game, with an expansive and detailed 
        setting, an engrossing plot, a cast of eccentric characters, 
        and lots of challenging and logical puzzles. And the game
        gives you an unusual amount of control over the way the
        story unfolds: you can simply pursue your "official" goals,
        or you can also investigate an elaborate hidden mystery.'
    firstPublished = '2005'
    genre = 'Collegiate, Science Fiction'
    IFID = 'TADS3-B4445266034D48C99DA08C2EC3C1B229'
    

    /* a "serial number" constructed from the date */
#ifdef QA_TEST_MODE
    serialNum = 'QA-TEST-BUILD'
#else
    serialNum = static releaseDate.findReplace('-', '', ReplaceAll, 1)
#endif

    /* 
     *   show the version information - override this to use a special
     *   format that includes the date-based serial number 
     */
    showVersion()
    {
        "<i><<name>></i> Release <<version>> (<<serialNum>>)\n";
    }

    /* 
     *   Handle the CREDITS command.  We show our production credits,
     *   acknowledgments, and disclaimers here.  
     */
    showCredit()
    {
        "<i>Return to Ditch Day</i> was written and programmed by
        Michael J.\ Roberts, using the <font size=-1>TADS</font> 3
        interactive fiction design system.
        <br><br>
        This game was tested by Steve Breslin, Eric Eve, Kevin Forchione,
        Stephen Granade, Andreas Sewe, Dan Shiovitz, and Brett Witty.
        I can't thank these folks enough for suffering through the
        early versions and offering so much helpful feedback and so
        many great ideas for improvements.  The game is vastly better
        for their generous efforts.  Thanks also to Mark Engelberg,
        Tommy Herbert, Valentine Kopteltsev, Matt McGlone, Michel
        Nizette, Emily Short, and Mike Snyder for catching a number of
        significant bugs in the released versions.
        <br><br>
        Some of the graffiti in the rendition here of Dabney House
        are based on or (more often) shamelessly copied from the real
        thing.  Similarly, a few of the stacks are loosely based on
        actual stacks of the past.  In all cases, the originals are
        much better than the poor imitations here.
        <br><br>
        This game was written in parallel with the last year or so
        of work on <font size=-1>TADS</font> 3 itself, so in a sense
        it's a part of that effort.  I therefore wish to thank everyone
        who contributed via the tads3 list---your advice, ideas, and
        practical experience using the system in its prolonged half-baked
        state have made all the difference.
        <br><br>
        Omegatron, Mitachron, Netbisco, ToxiCola, and Bioventics are
        trademarks of their respective fictitious companies.
        J.R.R.\ Tobacco is a trademark of SG Naming Consultants, used by
        permission.  DEI, DabniCorp, and the elephant-and-shield device
        are trademarks of Dabney Hovse.
        <br><br>
        <b>This is a work of fiction.</b>  All persons, places, organizations,
        and events in this story are products of the author's imagination
        or are used fictionally, and any resemblance to reality is purely
        coincidental.  Nothing in this game is meant to reflect in any way
        on the real-life Caltech or anyone associated with it.  Needless
        to say, Caltech was not involved in the creation of this work.
        But the next time your plans call for higher education, why not
        consider Caltech?  Nestled near the foothills of the San Gabriel
        mountains in Pasadena, Caltech offers a unique student experience
        that is said to rarely cause permanent damage.
        Visit <a href='http://www.caltech.edu'>www.caltech.edu</a> today.
        <br><br>
        For information on writing your own game using
        <font size=-1>TADS</font>, visit the official website at
        <a href='http://www.tads.org'>www.tads.org</a>.
        <br><br>
        Copyright &copy;2004, 2013 Michael J.\ Roberts. All rights reserved.
        Type <<aHref('copyright', 'COPYRIGHT')>> for license information. ";
    }

    /* 
     *   Handle the COPYRIGHT command.  We show our copyright message and
     *   license terms here. 
     */
    showCopyright()
    {
        "Copyright &copy;2004, 2013 Michael J.\ Roberts.
        All rights reserved.
        <p>
        <b>Free Software License</b><br>
        This is a copyrighted work, which means that it's against the
        law to copy or distribute this package without the author's
        written permission.  The author hereby grants you
        permission to use, copy, and redistribute this software, without
        charge, with the following conditions: you may not alter or remove
        any copyright notice or license notice in the work; you may not
        collect a fee for copies of this software, except for a nominal
        fee to cover the cost of physically making the copy; you may
        not distribute modified or incomplete versions; and you may not
        impose any additional license terms with respect to this work
        on recipients of copies you make or distribute.

        <p>This software has NO WARRANTY of any kind, expressed or
        implied, including without limitation the implied warranties
        of merchantability and fitness for a particular purpose.

        <p>
        If you have any questions about this license, please contact
        the author at
        <a href='mailto:mjr_@hotmail.com'>mjr_@hotmail.com</a>. ";
    }

    /* 
     *   Handle the ABOUT command.  By convention, this command gives the
     *   player a brief summary of anything unusual about the game - not
     *   full instructions on how to play, but a mention of any commands or
     *   other features that differ from the typical conventions of modern
     *   IF.  The idea is that we assume the player is already familiar
     *   with IF in general, so we just want to alert her to any quirks
     *   this game has.  Frequently, the command also provides a bit of
     *   background information about the game.  
     */
    showAbout()
    {
        "<img src='.system/CoverArt.jpg?id=<<rand('z{32}')>>'><br>";
        "Welcome to <i>Return to Ditch Day</i>!
        <.p>
        If you're a newcomer to Interactive Fiction, you might find it
        helpful to read our IF instruction manual---just type
        <<aHref('instructions', 'INSTRUCTIONS')>> at the command prompt.

        <.p>
        This game uses the standard commands that most IF games use,
        but there are a few extras worth mentioning.
        You can <b>TALK TO</b> a character to greet them (this is
        optional, though: you can always just ASK or TELL them
        about something instead).  Once you're talking to someone, you
        can abbreviate <b>ASK person ABOUT topic</b> to simply
        <b>A topic</b>, and <b>TELL person ABOUT topic</b> to
        <b>T topic</b>.  <b>TOPICS</b> shows you a list of things
        your character is interested in discussing---but note
        that you're never limited to what's on the list, and the list
        might not show everything that's important to talk about.
        
        <.p>The story might occasionally make a few special
        suggestions when you're talking with someone, like this:

        \b\t(You could apologize for breaking the vase, or explain
        \n\tabout the aliens.)

        <.p>These are special options that you can use at the moment
        they're suggested.  You don't have to worry about memorizing
        them or trying them at other random times in the story; they'll
        only work on the turn they're offered.  If you want to use one
        of the suggestions, just type it in; you can usually abbreviate
        to the first word or two when the suggestion is long:

        \b\t&gt;APOLOGIZE

        <.p>Note that you're never limited to the offered suggestions.
        You can always use an ordinary command instead, such as ASK or
        TELL, or even ignore the character completely.

        <.p>Many years ago, I wrote a game called <i>Ditch Day Drifter</i>
        as an example game for the first version of <font size=-1>TADS</font>,
        my IF development system.  This is very loosely a sequel to that
        game, but if you haven\'t played the original, don\'t worry---you
        can play this game entirely on its own.  There\'s nothing you need
        to know from the earlier game to play this one.
        
        <.p>There are no <q>unwinnable</q> situations in this game:
        there's no way for your character to be killed, and you can't
        accidentally lock yourself out of completing the story.  If you
        ever get really stuck, you can type <<aHref('hint', 'HINT')>>
        to access built-in hints. ";
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   Provide a HELP command.  A player who's completely lost might think to
 *   try typing HELP, so it's best to offer some assistance here.  Since we
 *   have a number of special commands that provide specific kinds of help,
 *   we'll simply list those other commands here.  
 */
DefineSystemAction(Help)
    execSystemAction()
    {
        "For more information, you can type one of the
        following at any command prompt:

        \b<<aHref('about', 'ABOUT')>> - for some general background
        information about this game

        \n<<aHref('copyright', 'COPYRIGHT')>> - to display copyright and
        license information

        \n<<aHref('credits', 'CREDITS')>> - to show the game's credits
        
        \n<<aHref('hints', 'HINT')>> - to access the built-in hints

        \n<<aHref('instructions', 'INSTRUCTIONS')>> - for general
        instructions on how to play this game ";
    }
;
VerbRule(Help) 'help' : HelpAction
    verbPhrase = 'show/showing help information'
;

/* ------------------------------------------------------------------------ */
/* 
 *   Provide a COPYRIGHT command.  This simply shows the license
 *   information from the versionInfo object. 
 */
DefineSystemAction(Copyright)
    execSystemAction() { versionInfo.showCopyright(); }
;
VerbRule(Copyright) 'copyright' | 'license' | 'licence' : CopyrightAction
    verbPhrase = 'show/showing copyright information'
;

