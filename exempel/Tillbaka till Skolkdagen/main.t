#charset "utf-8"
/* 
 *   Copyright 2003, 2013 Michael J. Roberts
 *   
 *   Return to Ditch Day - main game frame routines.  This defines the main
 *   entrypoint, the startup routines, and the finishing routines.  
 */

#include <adv3.h>
#include <sv_se.h>

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
               /* visa prologen */
        "\bÄn en gång är det du, Doug Mittling, som fått det usla 
        reseuppdraget. Det är nackdelen med att vara mellanchef—
        dina ingenjörer hade fullt upp med riktigt arbete,
        och vice vd:n var på en viktig faktainsamlingsresa till
        Maui, själv hade du ingen ursäkt förutom en stor hög med
        processrapporter att granska. Så här står du nu, på ett anonymt
        kraftverk i en myggstinn djungel någonstans i Sydostasien,
        tolv timmars bilresa från närmaste flygplats. Du har redan varit
        här i sex veckor och försökt få den förbaskade SCU-1100DX
        att fungera så att du kan visa upp den för kunden, men hittills 
        är den fortfarande trasig. Det börjar bli svettigt, särskilt
        eftersom du har hört Guanmgon prata om Mitachron flera gånger
        nyligen. Om du förlorar det här kontraktet till dem, kommer
        din vice vd att bli rasande. När han kommer hem från Maui,
        förstås.\b";

        /* visa spelets titel */
        "<b>Tillbaka till Skolkdagen</b>\n
        av Michael J.\ Roberts\n
        Översatt av Tomas Öberg\n
        Version <<versionInfo.version>> (<<versionInfo.serialNum>>)\n
        \b";
    }

    /* show our "goodbye" message */
    showGoodbye()
    {
        "<.p>Tack för att du spelade <i>Tillbaka till Skolkdagen</i>!\b";
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
        "\b<b>Tillbaka till Skolkdagen</b>
        \nVersion <<versionInfo.version>> (<<versionInfo.serialNum>>)
        \nCopyright &copy;2004, 2013 Michael J.\ Roberts
        / Gratisprogram / Skriv <<aHref('copyright', 'COPYRIGHT')>> för detaljer\n
        
        <.p>Om det här är första gången du spelar detta spel, vänligen skriv
        <<aHref('om', 'OM')>> för viktig
        information. För att återställa en tidigare sparad position, skriv
        <<aHref('ladda', 'LADDA')>> 
        <.p>För att <<aHref('', 'börja spelet')>>, tryck bara på Enter-tangenten. ";

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
                '<space>*(rq|återspela)'
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
            if ('om'.startsWith(kw))
            {
                /* they want the ABOUT information */
                versionInfo.showAbout();
            }
            else if ('ladda'.startsWith(kw))
            {
                /* try restoring a game */
                if (RestoreAction.askAndRestore())
                {
                    /* we succeeded - proceed directly to the game */
                    return 2;
                }
            }
            else if ('avsluta'.startsWith(kw))
            {
                /* do they really want to quit? */
                libMessages.confirmQuit();
                if (yesOrNo())
                    return 3;
                else
                    "Okej. ";
            }
            else if ('ledtrådar'.startsWith(kw))
            {
                /* there's no point in showing hints yet; explain this */
                "Tyvärr finns inga ledtrådar tillgängliga just nu. Ledtrådar kommer att vara
                tillgängliga så snart du börjar spelet. ";
            }
            else if ('instruktioner'.startsWith(kw))
            {
                /* show the instructions */
                InstructionsAction.execSystemAction();
            }
            else if ('copyright'.startsWith(kw))
            {
                /* show the copyright/license information */
                versionInfo.showCopyright();
            }
            else if (kw == 'rq' || 'återspela'.startsWith(kw))
            {
                /* if there's no argument, ask for one */
                if (rqArg == nil)
                {
                    /* there's no file, so ask for one */
                    local result = inputManager.getInputFile(
                        'Skriv in kommandofil', InFileOpen, FileTypeCmd, 0);
                    
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
            "\b(Vänligen skriv <<aHref('OM', 'OM')>> för information om
            hur man spelar, eller <<aHref('ladda', 'LADDA')>> för att återställa
            en sparad position. För att <<aHref('', 'börja spelet')>>, tryck bara
            på Enter-tangenten.) ";
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
        "<.p>Om du klarade av spelet utan att få alla poäng, och
        i synnerhet om det verkade som att det fanns många fler poäng att
        få, så kanske du undrar vad du har missat. Det mest
        sannolika svaret är att du hoppade över den valfria sidohandlingen 
        <q>mysteriet</q>. Det finns ledtrådar gömda här och där som du
        kan följa för att lista ut vad vissa tvivelaktiga karaktärer
        i berättelsen egentligen har för sig. Du kan lösa
        Skolkdagsstapeln och vinna spelet utan att följa mysteriet alls,
        så om mina försök att väcka din nyfikenhet misslyckades, har du
        förmodligen inte missat så mycket mer än poäng. Om du
        undrar varför det fanns en spionkamera gömd i Stamer's 
        laboratorium, kan jag försäkra dig om att svaret finns på
        samma ställen som de saknade poängen.

        <.p>Dessutom kan stapeln i Upper Seven (rum 42) lösas.
        Den är irrelevant för själva spelet, så det finns egentlig 
        ingen belöning för att lösa den, men vissa personer kanske 
        tycker det är en trevlig fristående problemlösning.

        <.p>Vissa spelare av originalet <i>Ditch Day Drifter</i>
        har frågat varifrån termen <q>stapel</q> kommer.
        För att svara på det behöver jag ge en kort historik 
        om Ditch Day. De första Ditch Days var enkla tillställningar 
        där sistaårsstudenterna helt enkelt bara skolkade för dagen. De
        yngre studenterna blev uppenbarligen irriterade över att lämnas 
        kvar själva, och de uttryckte detta genom att bryta sig in i 
        sistaårsstudenternas rum och vandalisera dem. Vid någon tidpunkt 
        började därför sistaårsstudenterna försöka barrikadera sina rum 
        innan de  gav sig av, genom att stapla skrivbord och andra tunga 
        föremål mot sina dörrar.

        <.p>Det är därifrån termen kommer: sistaårsstudenterna byggde bokstavligen
        staplar av tunga föremål för att blockera tillträde till sina rum.
        För sin del lät sig inte de yngre studenterna avskräckas; tvärtom
        tog de staplarna som en utmaning. Om detta hade utvecklats till
        en kapprustning hade traditionen förmodligen blivit alltför
        repetitiv (och alltför destruktiv) för att hålla särskilt länge.
        Lyckligtvis blev rivaliteten istället ritualiserad: staplarna
        utvecklades från fysiska barriärer till, i grund och botten, spel.
        Ditch Day är idag en höjdpunkt för alla på Caltech;
        yngre studenter ser fram emot det som IF-spelare ser fram emot
        <a href='http://www.ifcomp.org'>årliga Comp</a>, och
        sistaårsstudenterna är mycket stolta över att skapa staplar som är originella,
        utmanande och roliga. Jag kan förstås inte påstå att jag har skapat mer än
        en blek avbild av verkligheten här.

        <.p><tab indent=4><i>&mdash;<tab id=t1>MJR<br>
        <tab to=t1>Palo Alto, Kalifornien<br>
        <tab to=t1>April, 2004
        </i>";

        /* ask for another option */
        return true;
    }

    desc = "läs <<aHrefAlt('efterord', 'EFTERORD', '<b>E</b>FTERORD',
                                'Visa Efterord')>>"
    responseKeyword = 'efterord'
    responseChar = 'e'
    
;

/* ------------------------------------------------------------------------ */
/*
 *   Amusing things to try
 */
modify finishOptionAmusing
    doOption()
    {
        "\bNågra roliga saker att prova:
        <.p>
        <ul>
        \n<li>Lukta på Koffee.
        \n<li>Fråga Xojo om hissen efter att den fastnat.
        \n<li>Fortsätt ner i korridoren i källaren när
        Xojo försöker leda dig in i förrådsrummet.
        \n<li>Fråga Xojo om repbron flera gånger innan du går över 
        den, och igen efter att den går sönder.
        \n<li>Undersök överste Magnxis hatt.
        \n<li>Läs broschyrerna på karriärcentret.
        \n<li>Fråga bibliotekarien om hans bok flera gånger.
        \n<li>Fråga studenterna i Gränd 4 om stapeln.
        \n<li>Spela kullabyrintspelet i Gränd 5 flera gånger.
        \n<li>Ta eller ät frukten i Gränd 6.
        \n<li>Lös Commandant 64-stapeln i Upper 7.
        \n<li>Titta in i kanonröret från den höjda skyliften.
        \n<li>Visa Plisnik råttdockan.
        \n<li>Visa Plisnik råttdockan medan du bär den.
        \n<li>Fråga Dave (på nätverkskontoret) om Network
        Installer Company.
        \n<li>Prova de olika föreslagna ursäkterna när du blir påkommen utanför
        <q>Förråds</q>-rummet i ångtunnlarna.
        \n<li>När du är utomhus, titta på himlen på eftermiddagen.
        \n<li>Titta på graffitin i de olika Dabney-gränderna (praktiskt taget
        varje gränd har något att titta på).
        \n<li>Titta under sängen i Brian Stamers rum.
        \n<li>Bär den gigantiska novitetsbasebollkepsen.
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

