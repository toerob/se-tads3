#charset "utf-8"

/* 
 *   Copyright (c) 2000, 2006 Michael J. Roberts.  All Rights Reserved. 
 *   
 *   TADS 3 Library: Instructions for new players
 *   
 *   This module defines the INSTRUCTIONS command, which provides the
 *   player with an overview of how to play IF games in general.  These
 *   instructions are especially designed as an introduction to IF for
 *   inexperienced players.  The instructions given here are meant to be
 *   general enough to apply to most games that follow the common IF
 *   conventions. 
 *   
 *   This module defines the English version of the instructions.
 *   
 *   In most cases, each author should customize these general-purpose
 *   instructions at least a little for the specific game.  We provide a
 *   few hooks for some specific parameter-driven customizations that don't
 *   require modifying the original text in this file.  Authors should also
 *   feel free to make more extensive customizations as needed to address
 *   areas where the game diverges from the common conventions described
 *   here.
 *   
 *   One of the most important things you should do to customize these
 *   instructions for your game is to add a list of any special verbs or
 *   command phrasings that your game uses.  Of course, you might think
 *   you'll be spoiling part of the challenge for the player if you do
 *   this; you might worry that you'll give away a puzzle if you don't keep
 *   a certain verb secret.  Be warned, though, that many players - maybe
 *   even most - don't think "guess the verb" puzzles are good challenges;
 *   a lot of players feel that puzzles that hinge on finding the right
 *   verb or phrasing are simply bad design that make a game less
 *   enjoyable.  You should think carefully about exactly why you don't
 *   want to disclose a particular verb in the instructions.  If you want
 *   to withhold a verb because the entire puzzle is to figure out what
 *   command to use, then you have created a classic guess-the-verb puzzle,
 *   and most everyone in the IF community will feel this is simply a bad
 *   puzzle that you should omit from your game.  If you want to withhold a
 *   verb because it's too suggestive of a particular solution, then you
 *   should at least make sure that a more common verb - one that you are
 *   willing to disclose in the instructions, and one that will make as
 *   much sense to players as your secret verb - can achieve the same
 *   result.  You don't have to disclose every *accepted* verb or phrasing
 *   - as long as you disclose every *required* verb *and* phrasing, you
 *   will have a defense against accusations of using guess-the-verb
 *   puzzles.
 *   
 *   You might also want to mention the "cruelty" level of the game, so
 *   that players will know how frequently they should save the game.  It's
 *   helpful to point out whether or not it's possible for the player
 *   character to be killed; whether it's possible to get into situations
 *   where the game becomes "unwinnable"; and, if the game can become
 *   unwinnable, whether or not this will become immediately clear.  The
 *   kindest games never kill the PC and are always winnable, no matter
 *   what actions the player takes; it's never necessary to save these
 *   games except to suspend a session for later resumption.  The cruelest
 *   games kill the PC without warning (although if they offer an UNDO
 *   command from a "death" prompt, then even this doesn't constitute true
 *   cruelty), and can become unwinnable in ways that aren't readily and
 *   immediately apparent to the player, which means that the player could
 *   proceed for quite some time (and thus invest substantial effort) after
 *   the game is already effectively lost.  Note that unwinnable situations
 *   can often be very subtle, and might not even be intended by the
 *   author; for example, if the player needs a candle to perform an
 *   exorcism at some point, but the candle can also be used for
 *   illumination in dark areas, the player could make the game unwinnable
 *   simply by using up the candle early on while exploring some dark
 *   tunnels, and might not discover the problem until much further into
 *   the game.  
 */

#include "adv3.h"
#include "sv_se.h"

/*
 *   The INSTRUCTIONS command.  Make this a "system" action, because it's
 *   a meta-action outside of the story.  System actions don't consume any
 *   game time.  
 */
DefineSystemAction(Instructions)
    /*
     *   This property tells us how complete the verb list is.  By default,
     *   we'll assume that the instructions fail to disclose every required
     *   verb in the game, because the generic set we use here doesn't even
     *   try to anticipate the special verbs that most games include.  If
     *   you provide your own list of game-specific verbs, and your custom
     *   list (taken together with the generic list) discloses every verb
     *   required to complete the game, you should set this property to
     *   true; if you set this to true, the instructions will assure the
     *   player that they will not need to think of any verbs besides the
     *   ones listed in the instructions.  Authors are strongly encouraged
     *   to disclose a list of verbs that is sufficient by itself to
     *   complete the game, and to set this property to true once they've
     *   done so.  
     */
    allRequiredVerbsDisclosed = nil

    /* 
     *   A list of custom verbs.  Each game should set this to a list of
     *   single-quoted strings; each string gives an example of a verb to
     *   display in the list of sample verbs.  Something like this:
     *   
     *   customVerbs = ['brush my teeth', 'pick the lock'] 
     */
    customVerbs = []

    /* 
     *   Verbs relating specifically to character interaction.  This is in
     *   the same format as customVerbs, and has essentially the same
     *   purpose; however, we call these out separately to allow each game
     *   not only to supplement the default list we provide but to replace
     *   our default list.  This is desirable for conversation-related
     *   commands in particular because some games will not use the
     *   ASK/TELL conversation system at all and will thus want to remove
     *   any mention of the standard set of verbs.  
     */
    conversationVerbs =
    [
        'FRÅGA TROLLKARL OM STAV',
        'BE TROLLKARL OM DRYCK',
        'BERÄTTA FÖR TROLLKARL OM DAMMIG BOK',
        'VISA RULLE FÖR TROLLKARL',
        'GE STAV TILL TROLLKARL',
        'JA (eller NEJ)'
    ]

    /* conversation verb abbreviations */
    conversationAbbr = "\n\tFRÅGA OM (ämne) kan förkortas till F (ämne)
                        \n\tBERÄTTA OM (ämne) kan skrivas som B (ämne)"

    /*
     *   Truncation length. If the game's parser allows words to be
     *   abbreviated to some minimum number of letters, this should
     *   indicate the minimum length.  The English parser uses a truncation
     *   length of 6 letters by default.
     *   
     *   Set this to nil if the game doesn't allow truncation at all.  
     */
    truncationLength = 6

    /*
     *   This property should be set on a game-by-game basis to indicate
     *   the "cruelty level" of the game, which is a rough estimation of
     *   how likely it is that the player will encounter an unwinnable
     *   position in the game.
     *   
     *   Level 0 is "kind," which means that the player character can
     *   never be killed, and it's impossible to make the game unwinnable.
     *   When this setting is used, the instructions will reassure the
     *   player that saving is necessary only to suspend the session.
     *   
     *   Level 1 is "standard," which means that the player character can
     *   be killed, and/or that unwinnable positions are possible, but
     *   that there are no especially bad unwinnable situations.  When
     *   this setting is selected, we'll warn the player that they should
     *   save every so often.
     *   
     *   (An "especially bad" situation is one in which the game becomes
     *   unwinnable at some point, but this won't become apparent to the
     *   player until much later.  For example, suppose the first scene
     *   takes place in a location that can never be reached again after
     *   the first scene, and suppose that there's some object you can
     *   obtain in this scene.  This object will be required in the very
     *   last scene to win the game; if you don't have the object, you
     *   can't win.  This is an "especially bad" unwinnable situation: if
     *   you leave the first scene without getting the necessary object,
     *   the game is unwinnable from that point forward.  In order to win,
     *   you have to go back and play almost the whole game over again.
     *   Saved positions are almost useless in a case like this, since
     *   most of the saved positions will be after the fatal mistake; no
     *   matter how often you saved, you'll still have to go back and do
     *   everything over again from near the beginning.)
     *   
     *   Level 2 is "cruel," which means that the game can become
     *   unwinnable in especially bad ways, as described above.  If this
     *   level is selected, we'll warn the player more sternly to save
     *   frequently.
     *   
     *   We set this to 1 ("standard") by default, because even games that
     *   aren't intentionally designed to be cruel often have subtle
     *   situations where the game becomes unwinnable, because of things
     *   like the irreversible loss of an object, or an unrepeatable event
     *   sequence; it almost always takes extra design work to ensure that
     *   a game is always winnable.  
     */
    crueltyLevel = 1

    /*
     *   Does this game have any real-time features?  If so, set this to
     *   true.  By default, we'll explain that game time passes only in
     *   response to command input. 
     */
    isRealTime = nil

    /*
     *   Conversation system description.  Several different conversation
     *   systems have come into relatively widespread use, so there isn't
     *   any single convention that's generic enough that we can assume it
     *   holds for all games.  In deference to this variability, we
     *   provide this hook to make it easy to replace the instructions
     *   pertaining to the conversation system.  If the game uses the
     *   standard ASK/TELL system, it can leave this list unchanged; if
     *   the game uses a different system, it can replace this with its
     *   own instructions.
     *   
     *   We'll include information on the TALK TO command if there are any
     *   in-conversation state objects in the game; if not, we'll assume
     *   there's no need for this command.
     *   
     *   We'll mention the TOPICS command if there are any SuggestedTopic
     *   instances in the game; if not, then the game will never have
     *   anything to suggest, so the TOPICS command isn't needed.
     *   
     *   We'll include information on special topics if there are any
     *   SpecialTopic objects defined.  
     */
    conversationInstructions =
        "Du kan prata med andra karaktärer genom att fråga dem om eller berätta för dem om saker i berättelsen. Till exempel kan du FRÅGA TROLLKARL OM STAV eller BERÄTTA FÖR VAKT OM LARMET. Du ska alltid använda fraserna FRÅGA OM eller BERÄTTA OM; spelet förstår inte andra format, så du behöver inte fundera på att formulera komplicerade frågor som <q>fråga vakt hur man öppnar fönstret</q>.
        Oftast får du bäst resultat genom att fråga om specifika föremål eller andra karaktärer du har stött på i berättelsen, snarare än om abstrakta ämnen som LIVETS MENING; men om något i spelet antyder att du <i>borde</i> fråga om ett visst abstrakt ämne, kan det vara värt att prova.

        \bOm du frågar eller berättar för samma person om flera ämnen i följd kan du spara skrivande genom att förkorta FRÅGA OM till F och BERÄTTA OM till B. Till exempel, när du redan pratar med trollkarlen kan du förkorta FRÅGA TROLLKARL OM AMULETT till bara F AMULETT. Det riktar frågan till samma person som i det senaste FRÅGA- eller BERÄTTA-kommandot.

        <<firstObj(InConversationState, ObjInstances) != nil ?
          "\bFör att hälsa på en annan karaktär, skriv PRATA MED (Person). Det försöker få den andra karaktärens uppmärksamhet och starta ett samtal. PRATA MED är alltid valfritt, eftersom du kan börja direkt med FRÅGA eller BERÄTTA om du vill." : "">>

        <<firstObj(SpecialTopic, ObjInstances) != nil ?
          "\bSpelet kan ibland föreslå särskilda samtalskommandon, som så här:

          \b\t(Du kan be om ursäkt, eller förklara om utomjordingarna.)

          \bOm du vill kan du använda ett av förslagen genom att helt enkelt skriva in den särskilda frasen som visas. Du kan oftast förkorta dessa till de första orden om de är långa.

          \b\t&gt;BE OM URSÄKT
          \n\t&gt;FÖRKLARA OM UTOMJORDINGARNA

          \bSärskilda förslag som dessa fungerar bara precis när de erbjuds, så du behöver inte komma ihåg dem eller prova dem vid andra tillfällen i spelet. Det är inga nya kommandon du måste lära dig; de är bara extra alternativ vid specifika tillfällen, och spelet talar alltid om när de finns. När spelet ger sådana förslag begränsar det inte vad du kan göra; du kan alltid skriva vilket vanligt kommando som helst istället för ett av förslagen." : "">>

        <<firstObj(SuggestedTopic, ObjInstances) != nil ?
          "\bOm du är osäker på vad du kan prata om kan du skriva ÄMNEN när du pratar med någon. Då får du en lista över saker som din karaktär kan vara intresserad av att diskutera med den andra personen. Kommandot ÄMNEN visar oftast inte allt du kan prata om, så känn dig fri att prova andra ämnen även om de inte står med i listan." : "">>

        \bDu kan också interagera med andra karaktärer med hjälp av fysiska föremål. Till exempel kan du ibland ge något till en annan karaktär, som i GE PENGAR TILL KASSÖR, eller visa ett föremål för någon, som i VISA IDOL FÖR PROFESSORN. Du kan också ibland slåss mot andra karaktärer, som i ATTACKERA TROLL MED SVÄRD eller KASTA YXA PÅ DVÄRG.

        \bI vissa fall kan du be en karaktär att göra något åt dig. Du gör detta genom att skriva karaktärens namn, sedan ett kommatecken, och sedan kommandot du vill att karaktären ska utföra, med samma formulering som du skulle använda för din egen karaktär. Till exempel:

        \b\t&gt;ROBOT, GÅ NORRUT

        \bTänk dock på att det inte är säkert att andra karaktärer alltid lyder dina order. De flesta karaktärer har en egen vilja och gör inte automatiskt vad du ber dem om."

    /* execute the command */
    execSystemAction()
    {
        local origElapsedTime;

        /* 
         *   note the elapsed game time on the real-time clock before we
         *   start, so that we can reset the game time when we're done; we
         *   don't want the instructions display to consume any real game
         *   time 
         */
        origElapsedTime = realTimeManager.getElapsedTime();

        /* show the instructions */
        showInstructions();

        /* reset the real-time game clock */
        realTimeManager.setElapsedTime(origElapsedTime);
    }

#ifdef INSTRUCTIONS_MENU
    /*
     *   Show the instructions, using a menu-based table of contents.
     */
    showInstructions()
    {
        /* run the instructions menu */
        topInstructionsMenu.display();

        /* show an acknowledgment */
        "Klart. ";
    }
    
#else /* INSTRUCTIONS_MENU */

    /*
     *   Visa instruktionerna som vanlig text. Ge användaren möjlighet
     *   att starta en SCRIPT-fil för att spara texten.
     */
    showInstructions()
    {
        local startedScript;

        /* anta att vi inte startar någon ny scriptfil */
        startedScript = nil;
        
        /* visa introduktionsmeddelandet */
        "Spelet kommer nu att visa en komplett uppsättning instruktioner,
        särskilt utformade för dig som inte redan är bekant med interaktiv fiktion. Instruktionerna är ganska omfattande";

        /*
         *   Kontrollera om vi redan spelar in. Om inte, erbjud att spara
         *   instruktionerna till en fil.
         */
        if (scriptStatus.scriptFile == nil)
        {
            local str;
            
            /* fråga om användaren vill börja spela in */
            ", så du kanske vill spara dem till en fil (så att du kan skriva ut dem, till exempel). Vill du fortsätta?
            \n(<<aHref('yes', 'J')>> betyder ja, eller skriv
            <<aHref('skript', 'SKRIPT')>> för att spara till fil) &gt; ";

            /* fråga efter inmatning */
            str = inputManager.getInputLine(nil, nil);

            /* om de vill spara till fil, starta inspelning */
            if (rexMatch('<nocase><space>*s(k(r(i(pt?)?)?)?)?<space>*', str)
                == str.length())
            {
                ScriptAction.setUpScripting(nil);

                if (scriptStatus.scriptFile == nil)
                    return;
                
                startedScript = true;
            }
            else if (rexMatch('<nocase><space>*j.*', str) != str.length())
            {
                "Avbrutet. ";
                return;
            }
        }
        else
        {
            "; vill du fortsätta?
            \n(J betyder ja) &gt; ";

            if (!yesOrNo())
            {
                "Avbrutet. ";
                return;
            }
        }

        /* se till att vi har något för nästa \b att hoppa över */
        "\ ";

        /* visa varje kapitel i tur och ordning */
        showCommandsChapter();
        showAbbrevChapter();
        showTravelChapter();
        showObjectsChapter();
        showConversationChapter();
        showTimeChapter();
        showSaveRestoreChapter();
        showSpecialCmdChapter();
        showUnknownWordsChapter();
        showAmbiguousCmdChapter();
        showAdvancedCmdChapter();
        showTipsChapter();

        /* om vi startade en scriptfil, stäng den */
        if (startedScript)
            ScriptOffAction.turnOffScripting(nil);
    }

#endif /* INSTRUCTIONS_MENU */

    /* Entering Commands chapter */
    showCommandsChapter()
    {
        "\b<b>Skriva kommandon</b>\b
        Du har säkert redan märkt att du interagerar med spelet genom att skriva ett kommando när du ser <q>prompten</q>, som oftast ser ut så här:
        \b";

        gLibMessages.mainCommandPrompt(rmcCommand);

        "\bNär du känner till detta tänker du kanske antingen: <q>Bra, jag kan skriva precis vad jag vill, på vanlig svenska, och spelet gör som jag säger,</q> eller <q>Bra, nu måste jag lära mig ännu ett krångligt kommandospråk för datorn; jag tror jag spelar något annat istället.</q>
        Ingen av dessa ytterligheter stämmer riktigt.

        \bI själva verket behöver du bara ett ganska litet antal kommandon, och de flesta kommandon är på vanlig svenska, så det är inte mycket du behöver lära dig eller komma ihåg. Även om prompten kan se skrämmande ut, låt dig inte avskräckas - det är bara några enkla saker du behöver känna till.

        \bFör det första behöver du nästan aldrig referera till något som inte nämns direkt i spelet; det här är en berättelse, inte en gissningslek där du måste tänka ut allt som hör ihop med något föremål. Om du till exempel har på dig en jacka kan du anta att jackan har fickor, knappar eller dragkedja - men om spelet aldrig nämner dessa saker behöver du inte oroa dig för dem.

        \bFör det andra behöver du inte komma på alla tänkbara handlingar du kan utföra. Poängen med spelet är inte att du ska gissa verb. Istället behöver du bara använda ett relativt litet antal enkla, vanliga handlingar. För att ge dig en uppfattning, här är några av de kommandon du kan använda:";

        "\b
        \n\t SE DIG OMKRING
        \n\t INVENTERA
        \n\t GÅ NORD (eller ÖST, SYDVÄST, och så vidare, eller UPP, NER, IN, UT)
        \n\t VÄNTA
        \n\t TA LÅDAN
        \n\t SLÄPP DISKETTEN
        \n\t TITTA PÅ DISKETTEN
        \n\t LÄS BOKEN
        \n\t ÖPPNA LÅDAN
        \n\t STÄNG LÅDAN
        \n\t TITTA I LÅDAN
        \n\t TITTA GENOM FÖNSTRET
        \n\t LÄGG DISKETT I LÅDAN
        \n\t STÄLL LÅDAN PÅ BORDET
        \n\t TA PÅ KONISK HATT
        \n\t TA AV HATTEN
        \n\t TÄND LYKTAN
        \n\t TÄND TÄNDSTICKA
        \n\t TÄND LJUS MED TÄNDSTICKA
        \n\t TRYCK PÅ KNAPP
        \n\t DRA I SPAKEN
        \n\t VRID PÅ KNAPP
        \n\t VRID RATTEN TILL 11
        \n\t ÄT KAKA
        \n\t DRICK MJÖLK
        \n\t KASTA PAJ PÅ CLOWN
        \n\t ATTACKERA TROLL MED SVÄRD
        \n\t LÅS UPP DÖRR MED NYCKEL
        \n\t LÅS DÖRR MED NYCKEL
        \n\t KLÄTTRA PÅ STEGEN
        \n\t SÄTT DIG I BILEN
        \n\t SITT PÅ STOLEN
        \n\t STÅ PÅ BORDET
        \n\t STÅ I BLOMSTERLANDET
        \n\t LÄGG DIG PÅ SÄNGEN
        \n\t SKRIV HEJ PÅ DATORN
        \n\t SLÅ UPP BOB I TELEFONKATALOGEN";

        /* visa samtalsrelaterade verb */
        foreach (local cur in conversationVerbs)
            "\n\t <<cur>>";

        /* visa egna specialverb */
        foreach (local cur in customVerbs)
            "\n\t <<cur>>";

        /* Om listan är uttömmande, säg det; annars, nämn att det kan finnas fler verb */
        if (allRequiredVerbsDisclosed)
            "\bDet var allt - varje verb och varje kommandosyntax du behöver för att klara spelet visas ovan.
            Om du någon gång fastnar och känner att spelet förväntar sig att du ska komma på något helt oväntat, kom ihåg detta: vad du än behöver göra, kan du göra det med ett eller flera av kommandona ovan.
            Du behöver aldrig börja prova slumpmässiga kommandon för att hitta rätt, för allt du behöver finns tydligt listat här ovan.";
        else
            "\bDe flesta verb du behöver för att klara spelet visas ovan; det kan finnas några ytterligare kommandon du behöver ibland, men de följer samma enkla format som ovan.";

        "\bNågra av dessa kommandon förtjänar lite mer förklaring.
        SE DIG OMKRING (som du kan förkorta till SE eller bara S) visar beskrivningen av platsen du befinner dig på. Du kan använda detta om du vill fräscha upp minnet av din karaktärs omgivning. INVENTERA (eller bara I) visar vad din karaktär bär på. VÄNTA (eller Z) låter lite tid gå i spelet.";
    }

    /* Abbreviations chapter */
    showAbbrevChapter()
    {
        "\b<b>Förkortningar</b>
        \bDu kommer troligen att använda vissa kommandon ganska ofta, så för att spara skrivande kan du förkorta några av de vanligaste kommandona:

        \b
        \n\t SE DIG OMKRING kan förkortas till SE eller bara S
        \n\t INVENTERA kan förkortas till I
        \n\t GÅ NORD/NORRUT kan skrivas NORD/NORRUT, eller bara N (likaså Ö, V, S, NO, SO, NV, SV, U för UPP och N för NER)
        \n\t TITTA PÅ DISKETTEN kan skrivas som EXAMINERA DISKETT eller bara X DISKETT
        \n\t VÄNTA kan förkortas till Z
        <<conversationAbbr>>

        \b<b>Några fler detaljer om kommandon</b>
        \bNär du skriver in kommandon kan du använda stora eller små bokstäver i vilken blandning du vill. Du kan använda ord som DEN och EN när de passar, men du kan utelämna dem om du föredrar det. ";

        if (truncationLength != nil)
        {
            "Du kan förkorta vilket ord som helst till sina första <<
            spellInt(truncationLength)>> bokstäver, men om du väljer att inte förkorta kommer spelet att ta hänsyn till allt du faktiskt skriver; det betyder till exempel att du kan förkorta SUPERCALIFRAGILISTICEXPIALIDOCIOUS till <<
            'SUPERCALIFRAGILISTICEXPIALIDOCIOUS'.substr(1, truncationLength)
            >> eller <<
            'SUPERCALIFRAGILISTICEXPIALIDOCIOUS'.substr(1, truncationLength+2)
            >>, men inte till <<
            'SUPERCALIFRAGILISTICEXPIALIDOCIOUS'.substr(1, truncationLength)
            >>SDF. ";
        }
    }
    /* Travel chapter */
    showTravelChapter()
    {
        "\b<b>Att förflytta sig</b>
        \bVid varje tillfälle i spelet befinner sig din karaktär på en <q>plats</q>. Spelet beskriver platsen när din karaktär först kommer dit, och igen varje gång du skriver SE DIG OMKRING (LOOK). Varje plats har oftast ett kort namn som visas före den fullständiga beskrivningen; namnet är användbart när du ritar en karta, och kan hjälpa dig att minnas var du är.

        \bVarje plats är ett separat rum, ett stort utomhusområde eller liknande. (Ibland kan ett enda fysiskt rum vara så stort att det består av flera platser i spelet, men det är ganska ovanligt.) För det mesta räcker det att ange vilken plats du vill gå till; när din karaktär är på en plats kan hen oftast se och nå allt där, så du behöver inte oroa dig för exakt var i rummet din karaktär står. Ibland kan något vara utom räckhåll, till exempel om det står på en hög hylla eller på andra sidan ett dike; då kan det vara användbart att vara mer specifik, till exempel genom att stå på något (STÅ PÅ BORDET, till exempel).

        \bAtt förflytta sig från en plats till en annan görs oftast med ett riktningskommando: GÅ NORD, GÅ NORDOST, GÅ UPP och så vidare. (Du kan förkorta väderstrecken och de vertikala riktningarna till en bokstav vardera - N, S, Ö, V, U, N - och diagonalerna till två: NO, NV, SO, SV.) Spelet berättar alltid vilka riktningar du kan gå när det beskriver en plats, så du behöver aldrig prova alla möjliga riktningar för att se om de leder någonstans.

        \bI de flesta fall tar det dig tillbaka till föregående plats om du går tillbaka i motsatt riktning, även om vissa passager kan ha svängar.

        \bOftast, när spelet beskriver en dörr eller passage, behöver du inte öppna dörren för att gå igenom - spelet gör det åt dig. Bara när spelet uttryckligen säger att en dörr blockerar vägen behöver du själv hantera dörren.";
    }

    /* Objects chapter */
    showObjectsChapter()
    {
        "\b<b>Hantera föremål</b>
        \bDu kan hitta föremål i spelet som din karaktär kan bära eller på annat sätt manipulera. Om du vill plocka upp något, skriv TA och föremålets namn: TA BOK. Om du vill släppa något du bär på, skriv SLÄPP det.

        \bDu behöver oftast inte vara särskilt specifik med exakt hur din karaktär ska bära eller hålla något, så du behöver inte tänka på vilken hand som håller vad eller liknande. Ibland kan det vara användbart att lägga ett föremål i eller på ett annat; till exempel, LÄGG BOK I KASSE eller STÄLL VAS PÅ BORDET. Om din karaktärs händer blir fulla kan det hjälpa att lägga saker i en behållare, precis som i verkligheten kan du bära mer om du har en väska eller låda.

        \bDu kan ofta få mycket extra information (och ibland viktiga ledtrådar) genom att undersöka föremål, vilket du gör med kommandot UNDERSÖK (eller titta på, EXAMINERA, som du kan förkorta till bara X, till exempel X MÅLNING). Erfarna spelare brukar undersöka allt på en ny plats direkt.";
    }

    /* show the Conversation chapter */
    showConversationChapter()
    {
        "\b<b>Interagera med andra karaktärer</b>
        \bDin karaktär kan möta andra personer eller varelser i spelet. Du kan ibland interagera med dessa karaktärer.\b";

        /* visa de anpassningsbara samtalsinstruktionerna */
        conversationInstructions;
    }

    /* Time chapter */
    showTimeChapter()
    {
        "\b<b>Tid</b>";

        if (isRealTime)
        {
            "\bTiden går i spelet både när du skriver kommandon och ibland även i <q>realtid</q>, vilket betyder att saker kan hända även medan du funderar på ditt nästa drag.

            \bOm du vill pausa tiden när du lämnar datorn en stund (eller bara behöver tänka), kan du skriva PAUS.";
        }
        else
        {
            "\bTiden går i spelet bara när du skriver kommandon. Det betyder att ingenting händer medan spelet väntar på att du ska skriva något. Varje kommando tar ungefär lika lång tid i spelet. Om du vill låta lite extra tid gå i spelet, till exempel för att du tror att något snart ska hända, kan du skriva VÄNTA (eller bara Z).";
        }
    }

    /* Saving, Restoring, and Undo chapter */
    showSaveRestoreChapter()
    {
        "\b<b>Spara och återställ</b>
        \bDu kan när som helst spara en ögonblicksbild av din nuvarande position i spelet,
        så att du senare kan återställa spelet till samma plats. Ögonblicksbilden sparas i en fil på din
        dators disk, och du kan spara så många olika ögonblicksbilder du vill (så länge du har plats på disken).\b";

        switch (crueltyLevel)
        {
        case 0:
            "I det här spelet kan din karaktär aldrig dö, och du kommer aldrig att hamna i en situation där det är omöjligt att slutföra spelet. Vad som än händer med din karaktär kommer du alltid att kunna hitta ett sätt att slutföra spelet. Till skillnad från många textspel behöver du alltså inte oroa dig för att spara för att skydda dig mot att fastna i omöjliga situationer. Självklart kan du ändå spara så ofta du vill, för att pausa din session och återuppta den senare, eller för att spara platser du vill kunna återvända till.";
            break;

        case 1:
        case 2:
            "Det kan vara möjligt för din karaktär att dö i spelet, eller att du hamnar i en omöjlig
            situation där du inte kan slutföra spelet. Därför bör du se till att spara din position
            <<crueltyLevel == 1 ? 'då och då' : 'ofta'>>
            så att du inte behöver gå tillbaka för långt om detta skulle hända. ";

            if (crueltyLevel == 2)
                "(Du bör också spara alla dina gamla sparfiler, eftersom du kanske inte alltid märker
                direkt när en situation blivit omöjlig.
                Ibland kan du behöva gå tillbaka längre än bara till den senaste platsen du <i>trodde</i>
                var säker.)";

            break;
        }

        "\bFör att spara din position, skriv SAVE vid kommandoprompten.
        Spelet kommer att fråga efter namnet på en fil där ögonblicksbilden ska sparas.
        Du måste ange ett filnamn som passar ditt system, och det måste finnas tillräckligt med utrymme på disken;
        du får veta om det uppstår problem vid sparandet. Använd ett filnamn som inte redan finns,
        eftersom den nya filen skriver över en eventuell befintlig fil med samma namn.

        \bDu kan återställa en tidigare sparad position genom att skriva RESTORE
        vid valfri prompt. Spelet frågar då efter filnamnet att återställa. När datorn har läst in filen,
        kommer allt i spelet att vara exakt som när du sparade den filen.";

        "\b<b>Ångra</b>
        \bÄven om du inte har sparat nyligen kan du oftast ta tillbaka dina senaste kommandon med kommandot UNDO.
        Varje gång du skriver UNDO ångras effekten av ett kommando,
        och spelet återställs till hur det var innan du skrev det kommandot. UNDO är begränsat till att ta tillbaka de senaste kommandona,
        så det är inte en ersättning för SAVE/RESTORE, men det är väldigt användbart om du
        hamnar i en farlig situation eller gör ett misstag du vill ta tillbaka.";
    }

    /* Other Special Commands chapter */
    showSpecialCmdChapter()
    {
        "\b<b>Några andra specialkommandon</b>
        \bSpelet förstår några andra specialkommandon som kan vara användbara.

        \bAGAIN (eller bara G): Upprepar det senaste kommandot. (Om din senaste rad innehöll flera kommandon, upprepas bara det sista.)
        \bINVENTORY (eller bara I): Visar vad din karaktär bär på.
        \bLOOK (eller bara L): Visar den fullständiga beskrivningen av din karaktärs nuvarande plats.";

        if (gExitLister != nil)
            "\bEXITS: Visar en lista över tydliga utgångar från nuvarande plats.
            \bEXITS ON/OFF/STATUS/LOOK: Styr hur spelet visar utgångar. EXITS ON visar en lista över
            utgångar i statusraden och i varje rumsbeskrivning. EXITS OFF stänger av båda dessa listor.
            EXITS STATUS visar bara statusradens lista, och EXITS ROOM visar bara listan i rumsbeskrivningen.";

        "\bOOPS: Rättar ett felstavat ord i ett kommando, utan att du behöver skriva om hela kommandot. Du kan bara använda OOPS direkt
        efter att spelet sagt att det inte kände igen ett ord i ditt förra kommando. Skriv OOPS följt av det rättade ordet.
        \bQUIT (eller bara Q): Avslutar spelet.
        \bRESTART: Startar om spelet från början.
        \bRESTORE: Återställer en position som tidigare sparats med SAVE.
        \bSAVE: Sparar nuvarande position i en fil.
        \bSCRIPT: Börjar spela in allt som visas i spelet till en fil, så att du kan läsa eller skriva ut det senare.
        \bSCRIPT OFF: Avslutar en inspelning som du startat med SCRIPT.
        \bUNDO: Tar tillbaka det senaste kommandot.
        \bSAVE DEFAULTS: Sparar dina nuvarande inställningar för saker som NOTIFY, EXITS och FOOTNOTES som standard. Dessa inställningar återställs automatiskt nästa gång du startar ett nytt spel, eller startar om detta.
        \bRESTORE DEFAULTS: Återställer uttryckligen de inställningar du tidigare sparat med SAVE DEFAULTS.";
    }
    
    /* Unknown Words chapter */
    showUnknownWordsChapter()
    {
        "\b<b>Okända ord</b>
        \bSpelet låtsas inte kunna varje ord i det svenska språket. Spelet kan till och med ibland använda ord i sina egna beskrivningar som det inte förstår i kommandon. Om du skriver ett kommando med ett ord som spelet inte känner till, kommer spelet att tala om vilket ord det inte kände igen. Om spelet inte känner till ett ord för något det beskrivit, och det inte heller finns några synonymer för det, kan du antagligen anta att objektet bara är en detalj i miljön och inte är viktigt för spelet.";
    }

    /* Ambiguous Commands chapter */
    showAmbiguousCmdChapter()
    {

        "\b<b>Otydliga kommandon</b>
        \bOm du skriver ett kommando som utelämnar viktig information,
        kommer spelet att försöka lista ut vad du menar. När det är
        rimligt uppenbart utifrån sammanhanget vad du menar, gör spelet
        en antagelse om den saknade informationen och fortsätter med
        kommandot. Spelet kommer att påpeka vad det antar i dessa fall,
        för att undvika missförstånd mellan spelets antaganden och dina.
        Till exempel:

        \b
        \n\t &gt;KNYT REPET
        \n\t (i kroken)
        \n\t Repet är nu fastknutet i kroken. Änden på repet når nästan
        \n\t ner till golvet i gropen nedanför.
        
        \bOm kommandot är så otydligt att spelet inte säkert kan göra
        en antagelse, kommer du att bli tillfrågad om mer information.
        Du kan svara på dessa frågor genom att skriva in den saknade
        informationen.

        \b
        \n\t &gt;LÅS UPP DÖRREN
        \n\t Vad vill du låsa upp den med?
        \b
        \n\t &gt;NYCKEL
        \n\t Vilken nyckel menar du, den gyllene nyckeln eller den
        \n\t silvriga nyckeln?
        \b
        \n\t &gt;GYLLENE
        \n\t Upplåst.

        \bOm spelet ställer en sådan fråga och du bestämmer dig för att
        du inte vill fortsätta med det ursprungliga kommandot, kan du
        bara skriva in ett helt nytt kommando istället för att svara
        på frågan.";
    }

    /* Advance Command Formats chapter */
    showAdvancedCmdChapter()
    {
        "\b<b>Avancerade kommandon</b>
        \bNär du har blivit bekväm med att skriva in kommandon kan du vara intresserad av att lära dig några mer avancerade kommandon som spelet förstår. Dessa avancerade kommandon är helt valfria, eftersom du alltid kan göra samma saker med de enklare kommandon vi redan gått igenom, men erfarna spelare brukar uppskatta de avancerade formaten eftersom de kan spara lite tangenttryckningar.

        \b<b>Använda flera objekt samtidigt</b>
        \bI de flesta kommandon kan du hantera flera objekt i ett och samma kommando. Använd ordet OCH eller ett kommatecken för att skilja objekten åt:

        \b
        \n\t TA LÅDAN, DISKETTEN OCH REPET
        \n\t LÄGG DISKETT OCH REP I LÅDAN
        \n\t SLÄPP LÅDA OCH REP

        \bDu kan använda orden ALLT och ALLTING för att syfta på allt som är relevant för ditt kommando, och du kan använda UTOM eller MEN (direkt efter ordet ALLT) för att undanta vissa objekt:

        \b
        \n\t TA ALLT
        \n\t LÄGG ALLT UTOM DISKETT OCH REP I LÅDAN
        \n\t TA ALLTING UR LÅDAN
        \n\t TA ALLT FRÅN HYLLAN

        \bALLT syftar på allt som är rimligt för ditt kommando, men utesluter saker som ligger inuti andra objekt som också matchar ALLT. Om du till exempel bär på en låda och ett rep, och lådan innehåller en diskett, så kommer TA ALLT att ta lådan och repet, men disketten blir kvar i lådan.

        \b<b><q>Den</q> och <q>Dem</q></b>
        \bDu kan använda DEN och DEM för att syfta på det eller de senaste objekt du använde i ett kommando:

        \b
        \n\t TA LÅDAN
        \n\t ÖPPNA DEN
        \n\t TA DISKETTEN OCH REPET
        \n\t LÄGG DEM I LÅDAN

        \b<b>Flera kommandon på samma rad</b>
        \bDu kan skriva flera kommandon på en och samma rad genom att separera dem med punkt, ordet SEDAN, ett kommatecken eller OCH. Till exempel:

        \b
        \n\t TA DISKETTEN OCH LÄGG DEN I LÅDAN
        \n\t TA LÅDAN. ÖPPNA DEN.
        \n\t LÅS UPP DÖRREN MED NYCKELN. ÖPPNA DEN, SEDAN GÅ NORD.

        \bOm spelet inte förstår ett av kommandona kommer det att tala om vilket kommando det inte förstod, och ignorera resten av raden.";
    }

    /* General Tips chapter */
    showTipsChapter()
    {
        "\b<b>Några tips</b>
        \bNu när du kan de tekniska detaljerna kring att skriva in kommandon kanske du är intresserad av några strategiska råd. Här är några tekniker som erfarna spelare av interaktiv fiktion brukar använda när de närmar sig en berättelse.

        \bUNDERSÖK allt, särskilt när du kommer till en ny plats för första gången. Att titta på föremål avslöjar ofta detaljer som inte nämns i den övergripande beskrivningen av platsen. Om undersökningen av ett föremål nämner detaljerade delar, undersök även dem.

        \bRita en karta om berättelsen har fler än ett fåtal platser. När du kommer till en ny plats för första gången, notera alla dess utgångar; då ser du snabbt om det finns utgångar du inte har utforskat än. Om du kör fast kan du titta på kartan efter outforskade områden där du kanske hittar det du söker.

        \bOm spelet inte känner igen ett ord eller någon synonym till det, är föremålet du försöker manipulera troligen inte viktigt för berättelsen. Om du försöker göra något med ett föremål och spelet svarar med något i stil med <q>det där är inte viktigt</q> kan du antagligen ignorera det föremålet; det finns troligen bara där som rekvisita för att göra miljön mer levande.

        \bOm du försöker åstadkomma något och inget verkar fungera, var uppmärksam på vad som går fel. Om allt du försöker bemöts med total avvisning (<q>inget händer</q> eller <q>det där är inget du kan öppna</q>) är du kanske inne på fel spår; ta ett steg tillbaka och fundera på andra sätt att angripa problemet. Om svaret är mer specifikt kan det vara en ledtråd. <q>Vakten säger <q>du kan inte öppna den här!</q> och rycker lådan ur dina händer</q> - det kan till exempel betyda att du måste få vakten att gå därifrån, eller att du ska ta lådan någon annanstans innan du öppnar den.

        \bOm du kör helt fast kan du prova att lägga undan det aktuella pusslet och arbeta med något annat en stund. Du kan också spara din position och ta en paus från spelet. Lösningen på det problem som stoppat dig kan dyka upp som en blixt av insikt när du minst anar det, och sådana insikter kan vara otroligt belönande. Vissa berättelser uppskattas bäst när de spelas under flera dagar, veckor eller till och med månader; om du har roligt, varför hasta igenom det?

        \bSlutligen, om inget annat hjälper, kan du alltid be om hjälp. Ett bra ställe för ledtrådar är Usenet-gruppen
        <a href='news:rec.games.int-fiction'>rec.games.int-fiction</a>.";
    }

    /* INSTRUCTIONS doesn't affect UNDO or AGAIN */
    isRepeatable = nil
    includeInUndo = nil
;


/* ------------------------------------------------------------------------ */
/*
 *   define the INSTRUCTIONS command's grammar 
 */
VerbRule(instructions) 'instruktioner' : InstructionsAction
;


/* ------------------------------------------------------------------------ */
/*
 *   The instructions, rendered in menu form.  The menu format helps break
 *   up the instructions by dividing the instructions into chapters, and
 *   displaying a menu that lists the chapters.  This way, players can
 *   easily go directly to the chapters they're most interested in, but
 *   can also still read through the whole thing fairly easily.
 *   
 *   To avoid creating an unnecessary dependency on the menu subsystem for
 *   games that don't want the menu-style instructions, we'll only define
 *   the menu objects if the preprocessor symbol INSTRUCTIONS_MENU is
 *   defined.  So, if you want to use the menu-style instructions, just
 *   add -D INSTRUCTIONS_MENU to your project makefile.  
 */
#ifdef INSTRUCTIONS_MENU

/* a base class for the instruction chapter menus */
class InstructionsMenu: MenuLongTopicItem
    /* 
     *   present the instructions in "chapter" format, so that we can
     *   navigate from one chapter directly to the next 
     */
    isChapterMenu = true

    /* the InstructionsAction property that we invoke to show our chapter */
    chapterProp = nil

    /* don't use a heading, as we provide our own internal chapter titles */
    heading = ''

    /* show our chapter text */
    menuContents = (InstructionsAction.(self.chapterProp)())
;

InstructionsMenu template 'titel' ->chapterProp;

/*
 *   The main instructions menu.  This can be used as a top-level menu;
 *   just call the 'display()' method on this object to display the menu.
 *   This can also be used as a sub-menu of any other menu, simply by
 *   inserting this menu into a parent menu's 'contents' list.  
 */
topInstructionsMenu: MenuItem 'Hur du spelar Interaktiv fiktion';

/* the chapter menus */
+ MenuLongTopicItem
    isChapterMenu = true
    title = 'Introduction'
    heading = nil
    menuContents()
    {
        "\b<b>Introduktion</b>
        \bVälkommen! Om du aldrig har spelat interaktiv fiktion tidigare är dessa instruktioner utformade för att hjälpa dig att komma igång. Om du redan vet hur man spelar den här typen av spel kan du antagligen hoppa över hela instruktionen, men du kanske vill skriva OM vid kommandoprompten för en sammanfattning av berättelsens specialfunktioner.
        \b
        För att göra instruktionerna lättare att navigera är de uppdelade i kapitel. ";

        if (curKeyList != nil && curKeyList.length() > 0)
            "I slutet av varje kapitel trycker du bara på
            <b><<curKeyList[M_SEL][1].toUpper()>></b> för att gå vidare till nästa kapitel, eller <b><<curKeyList[M_PREV][1].toUpper()>></b>
            för att återvända till kapitellistan. ";
        else
            "För att bläddra mellan kapitlen, klicka på länkarna eller använd vänster/höger piltangent. ";
    }
;

+ InstructionsMenu 'Skriva kommandon' ->(&showCommandsChapter);
+ InstructionsMenu 'Förkortningar' ->(&showAbbrevChapter);
+ InstructionsMenu 'Att förflytta sig' ->(&showTravelChapter);
+ InstructionsMenu 'Hantera föremål' ->(&showObjectsChapter);
+ InstructionsMenu 'Interagera med andra karaktärer'
    ->(&showConversationChapter);
+ InstructionsMenu 'Tid' ->(&showTimeChapter);
+ InstructionsMenu 'Spara och återställ' ->(&showSaveRestoreChapter);
+ InstructionsMenu 'Några andra specialkommandon' ->(&showSpecialCmdChapter);
+ InstructionsMenu 'Okända ord' ->(&showUnknownWordsChapter);
+ InstructionsMenu 'Otydliga kommandon' ->(&showAmbiguousCmdChapter);
+ InstructionsMenu 'Avancerade kommandon' ->(&showAdvancedCmdChapter);
+ InstructionsMenu 'Några tips' ->(&showTipsChapter);

#endif /* INSTRUCTIONS_MENU */

