#charset "utf-8"

/* 
 *   Copyright (c) 2000, 2006 Michael J. Roberts.  All Rights Reserved. 
 *
 *   TADS 3 Library - "neutral" messages for US English
 *
 *   This module provides standard library messages with a parser/narrator 
 *   that's as invisible (neutral) as possible.  These messages are designed 
 *   to reduce the presence of the computer as mediator in the story, to 
 *   give the player the most direct contact that we can with the scenario.
 *
 *   The parser almost always refers to itself in the third person (by 
 *   calling itself something like "this story") rather than in the first 
 *   person, and, whenever possible, avoids referring to itself in the first 
 *   place.  Our ideal phrasing is either second-person, describing things 
 *   directly in terms of the player character's experience, or "no-person," 
 *   simply describing things without mentioning the speaker or listener at 
 *   all.  For example, rather than saying "I don't see that here," we say 
 *   "you don't see that here," or "that's not here."  We occasionally stray 
 *   from this ideal where achieving it would be too awkward.
 *
 *   In the earliest days of adventure games, the parser was usually a 
 *   visible presence: the early parsers frequently reported things in the 
 *   first person, and some even had specific personalities.  This 
 *   conspicuous parser style has become less prevalent in modern games, 
 *   though, and authors now usually prefer to treat the parser as just 
 *   another part of the user interface, which like all good UI's is best 
 *   when the user doesn't notice it.  
 */

#include "adv3.h"
#include "sv_se.h"

/* ------------------------------------------------------------------------ */
/*
 *   Build a message parameter string with the given parameter type and
 *   name.
 *   
 *   This is useful when we have a name from a variable, and we need to
 *   build the message substitution string for embedding in a larger
 *   string.  We can't just embed the name variable using <<var>>, because
 *   that would process the output piecewise - the output filter needs to
 *   see the whole {typ var} expression in one go.  So, instead of writing
 *   this:
 *   
 *.     {The/he <<var>>} {is} ...
 *   
 *   write this:
 *   
 *.     <<buildParam('The/he', var)>> {is} ...
 */
buildParam(typeString, nm)
{
    return '{' + typeString + ' ' + nm + '}';
}

/*
 *   Synthesize a message parameter, and build it into a parameter string
 *   with the given substitution type.
 *   
 *   For example, buildSynthParam('abc', obj) returns '{abc xxx}', where
 *   'xxx' is a synthesized message parameter name (created using
 *   gSynthMessageParam) for the object obj.  
 */
buildSynthParam(typeString, obj)
{
    return '{' + typeString + ' ' + gSynthMessageParam(obj) + '}';
}


/* ------------------------------------------------------------------------ */
/*
 *   Library Messages 
 */
libMessages: MessageHelper
    /*
     *   The pronoun to use for the objective form of the personal
     *   interrogative pronoun.  Strictly speaking, the right word for
     *   this usage is "whom"; but regardless of what the grammar books
     *   say, most American English speakers these days use "who" for both
     *   the subjective and objective cases; to many ears, "whom" sounds
     *   old-fashioned, overly formal, or even pretentious.  (Case in
     *   point: a recent television ad tried to make a little kid look
     *   ultra-sophisticated by having him answer the phone by asking
     *   "*whom* may I ask is calling?", with elaborate emphasis on the
     *   "whom."  Of course, the correct usage in this case is "who," so
     *   the ad only made the kid look pretentious.  It goes to show that,
     *   at least in the mind of the writer of the ad, "whom" is just the
     *   snooty, formal version of "who" that serves only to signal the
     *   speaker's sophistication.)
     *   
     *   By default, we distinguish "who" and "whom."  Authors who prefer
     *   to use "who" everywhere can do so by changing this property's
     *   value to 'who'.  
     */
    whomPronoun = 'vem'

    /*
     *   Flag: offer an explanation of the "OOPS" command when it first
     *   comes up.  We'll only show this the first time the player enters
     *   an unknown word.  If you never want to offer this message at all,
     *   simply set this flag to nil initially.
     *   
     *   See also oopsNote() below.  
     */
    offerOopsNote = true

    /*
     *   some standard commands for insertion into <a> tags - these are in
     *   the messages so they can translated along with the command set
     */
    commandLookAround = 'titta runt'
    commandFullScore = 'full poäng'
    
    /* announce a completely remapped action */
    announceRemappedAction(action)
    {
        return '<./p0>\n<.assume>' + action.getParticiplePhrase()
            + '<./assume>\n';
    }

    /*
     *   Get a string to announce an implicit action.  This announces the
     *   current global action.  'ctx' is an ImplicitAnnouncementContext
     *   object describing the context in which the message is being
     *   displayed.  
     */
    announceImplicitAction(action, ctx)
    {
        /* build the announcement from the basic verb phrase */
        return ctx.buildImplicitAnnouncement(action.getImplicitPhrase(ctx));
    }

    /*
     *   Announce a silent implied action.  This allows an implied action
     *   to work exactly as normal (including the suppression of a default
     *   response message), but without any announcement of the implied
     *   action. 
     */
    silentImplicitAction(action, ctx) { return ''; }

    /*
     *   Get a string to announce that we're implicitly moving an object to
     *   a bag of holding to make room for taking something new.  If
     *   'trying' is true, it means we want to phrase the message as merely
     *   trying the action, not actually performing it.  
     */
    announceMoveToBag(action, ctx)
    {
        /* build the announcement, adding an explanation */
        return ctx.buildImplicitAnnouncement(
            action.getImplicitPhrase(ctx) + ' för att göra plats');
    }

    /* show a library credit (for a CREDITS listing) */
    showCredit(name, byline) { "<<name>> <<byline>>"; }

    /* show a library version number (for a VERSION listing) */
    showVersion(name, version) { "<<name>> version <<version>>"; }

    /* there's no "about" information in this game */
    noAboutInfo = "<.parser>Det här spelet har ingen OM information.<./parser> "

    /*
     *   Show a list state name - this is extra state information that we
     *   show for an object in a listing involving the object.  For
     *   example, a light source might add a state like "(providing
     *   light)".  We simply show the list state name in parentheses.  
     */
    showListState(state) { " (<<state>>)"; }

    /* a set of equivalents are all in a given state */
    allInSameListState(lst, stateName)
        { " (<<lst.length() == 2 ? 'båda' : 'alla'>> <<stateName>>)"; }

    /* generic long description of a Thing from a distance */
    distantThingDesc(obj) 
    {
        gMessageParams(obj);
        "{Det obj/han} är för långt borta för att kunna utgöra några detaljer. ";
    }

    /* generic long description of a Thing under obscured conditions */
    obscuredThingDesc(obj, obs)
    {
        gMessageParams(obj, obs);
        "{Du/han} {kan} inte utgöra några detaljer genom {den obs/honom}. ";
    }

    /* generic "listen" description of a Thing at a distance */
    distantThingSoundDesc(obj)
        { "{Du/han} {kan} inte höra något detaljerat från det här avståndet. "; }

    /* generic obscured "listen" description */
    obscuredThingSoundDesc(obj, obs)
    {
        gMessageParams(obj, obs);
        "{Du/han} {kan} inte höra något detaljerat genom {den obs/honom}. ";
    }

    /* generic "smell" description of a Thing at a distance */
    distantThingSmellDesc(obj)
        { "{Du/han} {kan} inte känna någon lukt från det här avståndet. "; }

    /* generic obscured "smell" description */
    obscuredThingSmellDesc(obj, obs)
    {
        gMessageParams(obj, obs);
        "{Du/han} {kan} inte känna så mycket lukt genom {den obs/honom}. ";
    }

    /* generic "taste" description of a Thing */
    thingTasteDesc(obj)
    {
        gMessageParams(obj);
        "{Det/han obj} smaka{r|de} ungefär som {du/han}{| hade} förvänta{r|t} {dig}. ";
    }

    /* generic "feel" description of a Thing */
    thingFeelDesc(obj)
        { "{Du/han} kän{ner|de} inget oväntat. "; }

    /* obscured "read" description */
    obscuredReadDesc(obj)
    {
        gMessageParams(obj);
        "{Du/han} {kan} inte se {det obj/honom} bra nog för att kunna läsa {det/honom}. ";
    }

    /* dim light "read" description */
    dimReadDesc(obj)
    {
        gMessageParams(obj);
        "Det f{i|a}nns inte ljus bra nog att läsa {det obj/honom}. ";
    }

    /* lit/unlit match description */
    litMatchDesc(obj) { "\^<<obj.nameIs>> tänd. "; }
    unlitMatchDesc(obj) { "\^<<obj.nameIs>> en vanlig tändsticka. "; }

    /* lit candle description */
    litCandleDesc(obj) { "\^<<obj.nameIs>> tänd. "; }

    /*
     *   Prepositional phrases for putting objects into different types of
     *   objects. 
     */
    putDestContainer(obj) { return 'in i ' + obj.theNameObj; }
    putDestSurface(obj) { return 'på ' + obj.theNameObj; }
    putDestUnder(obj) { return 'under ' + obj.theNameObj; }
    putDestBehind(obj) { return 'bakom ' + obj.theNameObj; }
    putDestFloor(obj) { return 'till ' + obj.theNameObj; }
    putDestRoom(obj) { return 'i ' + obj.theNameObj; }

    /* the list separator character in the middle of a list */
    listSepMiddle = ", "

    /* the list separator character for a two-element list */
    listSepTwo = " och "

    /* the list separator for the end of a list of at least three elements */
    listSepEnd = ", och "

    /*
     *   the list separator for the middle of a long list (a list with
     *   embedded lists not otherwise set off, such as by parentheses) 
     */
    longListSepMiddle = "; "

    /* the list separator for a two-element list of sublists */
    longListSepTwo = ", och "

    /* the list separator for the end of a long list */
    longListSepEnd = "; och "

    /* show the basic score message */
    showScoreMessage(points, maxPoints, turns)
    {
        "Du har hittills fått ihop <<points>> poäng av möjliga <<maxPoints>> på <<turns>> drag. ";
    }

    /* show the basic score message with no maximum */
    showScoreNoMaxMessage(points, turns)
    {
        "På <<turns>> drag har du fått ihop <<points>>";
    }

    /* show the full message for a given score rank string */
    showScoreRankMessage(msg) { "Detta gör dig till <<msg>>. "; }

    /*
     *   show the list prefix for the full score listing; this is shown on
     *   a line by itself before the list of full score items, shown
     *   indented and one item per line 
     */
    showFullScorePrefix = "Din poäng består av:"

    /*
     *   show the item prefix, with the number of points, for a full score
     *   item - immediately after this is displayed, we'll display the
     *   description message for the achievement 
     */
    fullScoreItemPoints(points)
    {
        "<<points>> poäng för ";
    }

    /* score change - first notification */
    firstScoreChange(delta)
    {
        scoreChange(delta);
        scoreChangeTip.showTip();
    }

    /* score change - notification other than the first time */
    scoreChange(delta)
    {
        "<.commandsep><.notification><<basicScoreChange(delta)>><./notification> ";
    }

    /*
     *   basic score change notification message - this is an internal
     *   service routine for scoreChange and firstScoreChange 
     */
    basicScoreChange(delta)
    {

        "Din <<aHref(commandFullScore, 'poäng', 'Visa fullständig poäng')>>
        has precis <<delta > 0 ? 'ökat' : 'minskat'>> med
        <<spellInt(delta > 0 ? delta : -delta)>> poäng.";

    }

    /* acknowledge turning tips on or off */
    acknowledgeTipStatus(stat)
    {
        "<.parser>Tips är nu <<stat ? 'på' : 'av'>>slagna.<./parser> ";
    }

    /* describe the tip mode setting */
    tipStatusShort(stat)
    {
        "TIPS <<stat ? 'PÅ' : 'AV'>>";
    }

    /* get the string to display for a footnote reference */
    footnoteRef(num)
    {
        /* set up a hyperlink for the note that enters the "note n" command */
        return '<sup>[<<aHref('fotnot ' + num, toString(num))>>]</sup>';
    }

    /* first footnote notification */
    firstFootnote()
    {
        footnotesTip.showTip();
    }

    /* there is no such footnote as the given number */
    noSuchFootnote(num)
    {
        "<.parser>Spelet har aldrig referat till någon sådan fotnot.<./parser> ";
    }

    /* show the current footnote status */
    showFootnoteStatus(stat)
    {
        //"The current setting is FOOTNOTES ";
        "Den nuvarande inställningen är FOTNOTER ";
        switch(stat)
        {
        case FootnotesOff:
            "AV, som döljer alla fotnotsreferenser.
            Skriv <<aHref('fotnoter medium', 'FOTNOTER MEDIUM',
                         'Ställ in fotnoter till Medium')>> för 
            att visa referenser till fotnoter förutom de du redan har sett, 
            eller <<aHref('fotnoter fullständiga', 'FOTNOTER FULLSTÄNDIGA',
                                     'Ställ in fotnoter till Fullständiga')>>
            för att visa alla fotnotsreferenser. ";
            break;

        case FootnotesMedium:
            "MEDIUM, som visar referenser till olästa fotnoter, men 
            döljer referenser till de du redan har läst. Skriv
            <<aHref('fotnoter av', 'FOTNOTER AV',
                    'Stäng av fotnoter')>> för att dölja 
            fotnotsreferenser helt, eller 
            <<aHref('fotnoter fullständiga', 'FOTNOTER FULLSTÄNDIGA',
            'Ställ in fotnoter till Fullständiga')>> för att visa alla 
            fotnotsreferenser, även de du redan har läst. ";
            break;

        case FootnotesFull:
            "FULLSTÄNDIGA, vilket visar varje fotnotsreferens, även 
            de du redan har läst.  Skriv <<aHref('fotnoter medium',
            'FOTNOTER MEDIUM', 'Ställ in fotnoter till Medium')>> för att 
            bara visa referenser till fotnoter du inte redan har läst, eller
            <<aHref('fotnoter av', 'FOTNOTER AV','Stäng av fotnoter')>> för att dölja 
            fotnotsreferenser helt";
            break;
        }
    }

    /* acknowledge a change in the footnote status */
    acknowledgeFootnoteStatus(stat)
    {
        "<.parser>Inställningen är nu <<shortFootnoteStatus(stat)>>.<./parser> ";
    }

    /* show the footnote status, in short form */
    shortFootnoteStatus(stat)
    {
        "FOTNOTER <<
          stat == FootnotesOff ? 'AV'
          : stat == FootnotesMedium ? 'MEDIUM'
          : 'FULLSTÄNDIGA' >>";
    }

    /*
     *   Show the main command prompt.
     *   
     *   'which' is one of the rmcXxx phase codes indicating what kind of
     *   command we're reading.  This default implementation shows the
     *   same prompt for every type of input, but games can use the
     *   'which' value to show different prompts for different types of
     *   queries, if desired.  
     */
    mainCommandPrompt(which) { "\b&gt;"; }

    /*
     *   Show a pre-resolved error message string.  This simply displays
     *   the given string.  
     */
    parserErrorString(actor, msg) { say(msg); }

    /* show the response to an empty command line */
    emptyCommandResponse = "<.parser>Ursäkta?<./parser> "

    /* invalid token (i.e., punctuation) in command line */
    invalidCommandToken(ch)
    {
        "<.parser>Spelet förstår inte hur tecknet <<ch>> ska användas i ett kommando.<./parser> ";
    }

    /*
     *   Command group prefix - this is displayed after a command line and
     *   before the first command results shown after the command line.
     *   
     *   By default, we'll show the "zero-space paragraph" marker, which
     *   acts like a paragraph break in that it swallows up immediately
     *   following paragraph breaks, but doesn't actually add any space.
     *   This will ensure that we don't add any space between the command
     *   input line and the next text.  
     */
    commandResultsPrefix = '<.p0>'

    /*
     *   Command "interruption" group prefix.  This is displayed after an
     *   interrupted command line - a command line editing session that
     *   was interrupted by a timeout event - just before the text that
     *   interrupted the command line.
     *   
     *   By default, we'll show a paragraph break here, to set off the
     *   interrupting text from the command line under construction.  
     */
    commandInterruptionPrefix = '<.p>'

    /*
     *   Command separator - this is displayed after the results from a
     *   command when another command is about to be executed without any
     *   more user input.  That is, when a command line contains more than
     *   one command, this message is displayed between each successive
     *   command, to separate the results visually.
     *   
     *   This is not shown before the first command results after a
     *   command input line, and is not shown after the last results
     *   before a new input line.  Furthermore, this is shown only between
     *   adjacent commands for which output actually occurs; if a series
     *   of commands executes without any output, we won't show any
     *   separators between the silent commands.
     *   
     *   By default, we'll just start a new paragraph.  
     */
    commandResultsSeparator = '<.p>'

    /*
     *   "Complex" result separator - this is displayed between a group of
     *   messages for a "complex" result set and adjoining messages.  A
     *   command result list is "complex" when it's built up out of
     *   several generated items, such as object identification prefixes
     *   or implied command prefixes.  We use additional visual separation
     *   to set off these groups of messages from adjoining messages,
     *   which is especially important for commands on multiple objects,
     *   where we would otherwise have several results shown together.  By
     *   default, we use a paragraph break.  
     */
    complexResultsSeparator = '<.p>'

    /*
     *   Internal results separator - this is displayed to visually
     *   separate the results of an implied command from the results for
     *   the initiating command, which are shown after the results from
     *   the implied command.  By default, we show a paragraph break.
     */
    internalResultsSeparator = '<.p>'

    /*
     *   Command results suffix - this is displayed just before a new
     *   command line is about to be read if any command results have been
     *   shown since the last command line.
     *   
     *   By default, we'll show nothing extra.  
     */
    commandResultsSuffix = ''

    /*
     *   Empty command results - this is shown when we read a command line
     *   and then go back and read another without having displaying
     *   anything.
     *   
     *   By default, we'll return a message indicating that nothing
     *   happened.  
     */
    commandResultsEmpty =
        ('Inget uppenbart hände' + tSel('r', '') + '.<.p>')

    /*
     *   Intra-command report separator.  This is used to separate report
     *   messages within a single command's results.  By default, we show
     *   a paragraph break.  
     */
    intraCommandSeparator = '<.p>'

    /*
     *   separator for "smell" results - we ordinarily show each item's
     *   odor description as a separate paragraph 
     */
    smellDescSeparator()
    {
        "<.p>";
    }

    /*
     *   separator for "listen" results 
     */
    soundDescSeparator()
    {
        "<.p>";
    }

    /* a command was issued to a non-actor */
    cannotTalkTo(targetActor, issuingActor)
    {
        "\^<<targetActor.nameIs>> inte någonting <<issuingActor.itNom>> <<issuingActor.verbCan>> prata med. ";
    }

    /* greeting actor while actor is already talking to us */
    alreadyTalkingTo(actor, greeter)
    {
        "\^<<greeter.theName>> {har|hade} redan <<actor.theNamePossAdj>> uppmärksamhet. ";
    }

    /* no topics to suggest when we're not talking to anyone */
    noTopicsNotTalking = "<.parser>{Du} prata{r|de} inte för närvarande med någon.<./parser> "

    /*
     *   Show a note about the OOPS command.  This is, by default, added
     *   to the "I don't know that word" error the first time that error
     *   occurs.  
     */
    oopsNote()
    {
        oopsTip.showTip();
    }

    /* can't use OOPS right now */
    oopsOutOfContext = "<.parser>Du kan bara använda OJ för att korrigera en felstavning direkt efter 
    att spelet påpekar att den inte förstår ett visst ord.<./parser> "

    /* OOPS in context, but without the word to correct */
    oopsMissingWord = "<.parser>För att använda OJ för att korrigera en felstavning, 
        placera det rättade ordet efter OJ, som i OJ BOK.<./parser> "

    /* acknowledge setting VERBOSE mode (true) or TERSE mode (nil) */
    acknowledgeVerboseMode(verbose)
    {
        if (verbose)
            "<.parser>ORDRIKT läge är nu valt.<./parser> ";
        else
            "<.parser>SPARSAMT läge är nu valt.<./parser> ";
    }

    /* show the current VERBOSE setting, in short form */
    shortVerboseStatus(stat) { "<<stat ? 'ORDRIKT' : 'SPARSAMT'>> läge"; }

    /* show the current score notify status */
    showNotifyStatus(stat)
    {
        "<.parser>Poängnotifikationer är för närvarande <<stat ? 'på' : 'av'>>slagna.<./parser> ";
    }

    /* show the current score notify status, in short form */
    shortNotifyStatus(stat) { "POÄNGNOTIFIERING <<stat ? 'PÅ' : 'AV'>>"; }

    /* acknowledge a change in the score notification status */
    acknowledgeNotifyStatus(stat)
    {
        "<.parser>Poängnotifikationer är nu <<stat ? 'på' : 'av'>>slagna.<./parser> ";
    }

    /*
     *   Announce the current object of a set of multiple objects on which
     *   we're performing an action.  This is used to tell the player
     *   which object we're acting upon when we're iterating through a set
     *   of objects specified in a command targeting multiple objects.  
     */
    announceMultiActionObject(obj, whichObj, action)
    {
        /* 
         *   get the display name - we only need to differentiate this
         *   object from the other objects in the iteration 
         */
        local nm = obj.getAnnouncementDistinguisher(
            action.getResolvedObjList(whichObj)).name(obj);

        /* build the announcement */
        return '<./p0>\n<.announceObj>' + nm + ':<./announceObj> <.p0>';
    }

    /*
     *   Announce a singleton object that we selected from a set of
     *   ambiguous objects.  This is used when we disambiguate a command
     *   and choose an object över other objects that are also logical but
     *   are less likely.  In such cases, it's courteous to tell the
     *   player what we chose, because it's possible that the user meant
     *   one of the other logical objects - announcing this type of choice
     *   helps reduce confusion by making it immediately plain to the
     *   player when we make a choice other than what they were thinking.  
     */
    announceAmbigActionObject(obj, whichObj, action)
    {
        /* 
         *   get the display name - distinguish the object from everything
         *   else in scope, since we chose from a set of ambiguous options 
         */
        local nm = obj.getAnnouncementDistinguisher(gActor.scopeList())
            .theName(obj);

        /* announce the object in "assume" style, ending with a newline */
        return '<.assume>' + nm + '<./assume>\n';
    }

    /*
     *   Announce a singleton object we selected as a default for a
     *   missing noun phrase.
     *   
     *   'resolvedAllObjects' indicates where we are in the command
     *   processing: this is true if we've already resolved all of the
     *   other objects in the command, nil if not.  We use this
     *   information to get the phrasing right according to the situation.
     */
    announceDefaultObject(obj, whichObj, action, resolvedAllObjects)
    {
        /*
         *   put the action's default-object message in "assume" style,
         *   and start a new line after it 
         */
        return '<.assume>'
            + action.announceDefaultObject(obj, whichObj, resolvedAllObjects)
            + '<./assume>\n';
    }

    /* 'again' used with no prior command */
    noCommandForAgain()
    {
        "<.parser>Det finns inget att repetera.<./parser> ";
    }

    /* 'again' cannot be directed to a different actor */
    againCannotChangeActor()
    {
        "<.parser>För att repetera ett kommando som <q>sköldpadda, gå norrut,</q>
        säg bara <q>igen,</q> inte <q>sköldpadda, igen.</q><./parser> ";
    }

    /* 'again': can no longer talk to target actor */
    againCannotTalkToTarget(issuer, target)
    {
        "\^<<issuer.theName>> <<issuer.verbCannot>> repetera det kommandot. ";
    }

    /* the last command cannot be repeated in the present context */
    againNotPossible(issuer)
    {
        "Det kommandot kan inte repeteras nu. ";
    }

    /* system actions cannot be directed to non-player characters */
    systemActionToNPC()
    {
        "<.parser>Det här kommandot kan inte riktas till en annan karaktär i spelet.<./parser> ";
    }

    /* confirm that we really want to quit */
    confirmQuit()
    {
        "Vill du verkligen avsluta?\ (<<aHref('j', 'J', 'Bekräfta avslut')
        >> bekräftar) >\ ";
    }

    /*
     *   QUIT message.  We display this to acknowledge an explicit player
     *   command to quit the game.  This is the last message the game
     *   displays on the way out; there is no need to offer any options at
     *   this point, because the player has decided to exit the game.
     *   
     *   By default, we show nothing; games can override this to display an
     *   acknowledgment if desired.  Note that this isn't a general
     *   end-of-game 'goodbye' message; the library only shows this to
     *   acknowledge an explicit QUIT command from the player.  
     */
    okayQuitting() { }

    /*
     *   "not terminating" confirmation - this is displayed when the
     *   player doesn't acknowledge a 'quit' command with an affirmative
     *   response to our confirmation question 
     */
    notTerminating()
    {
        "<.parser>Fortsätter spelet.<./parser> ";
    }

    /* confirm that they really want to restart */
    confirmRestart()
    {
        
        "Vill du verkligen börja om?\ (<<aHref('J', 'J',
        'Bekräfta omstart')>> är bekräftande) >\ ";
    }

    /* "not restarting" confirmation */
    notRestarting() { "<.parser>Fortsätter spelet.<./parser> "; }

    /*
     *   Show a game-finishing message - we use the conventional "*** You
     *   have won! ***" format that text games have been using since the
     *   dawn of time. 
     */
    showFinishMsg(msg) { "<.p>*** <<msg>>\ ***<.p>"; }

    /* standard game-ending messages for the common outcomes */
    finishDeathMsg = '{DU/HAN pc}{ HAR | }{DÖTT|DOG}'
    finishVictoryMsg = ('DU ' + tSel('HAR ', '') + '{VUNNIT|VANN}')
    finishFailureMsg = ('DU ' + tSel('HAR ', '') + '{MISSLYCKATS|MISSLYCKADES}')
    finishGameOverMsg = 'SPELET SLUT'

    /*
     *   Get the save-game file prompt.  Note that this must return a
     *   single-quoted string value, not display a value itself, because
     *   this prompt is passed to inputFile(). 
     */
    getSavePrompt = 'Spara spelet till fil'

    /* get the restore-game prompt */
    getRestorePrompt = 'Återställer spelet från fuil'

    /* successfully saved */
    saveOkay() { "<.parser>Sparat.<./parser> "; }

    /* save canceled */
    saveCanceled() { "<.parser>Avbrutet.<./parser> "; }

    /* saved failed due to a file write or similar error */
    saveFailed(exc)
    {
        "<.parser>Misslyckades; din dator kanske börjar få slut 
        på diskutrymme, eller så har du inte de rätta privilegierna 
        för att skriva till den här filen.<./parser> ";
    }

    /* save failed due to storage server request error */
    saveFailedOnServer(exc)
    {
        "<.parser>Misslyckades, på grund av ett problem att nå lagringsservern: 
        <<makeSentence(exc.errMsg)>><./parser>";
    }

    /* 
     *   make an error message into a sentence, by capitalizing the first
     *   letter and adding a period at the end if it doesn't already have
     *   one 
     */
    makeSentence(msg)
    {
        return rexReplace(
            ['^<space>*[a-z]', '(?<=[^.?! ])<space>*$'], msg,
            [{m: m.toUpper()}, '.']);
    }

    /* note that we're restoring at startup via a saved-position launch */
    noteMainRestore() { "<.parser>Återställt sparat spel...<./parser>\n"; }

    /* successfully restored */
    restoreOkay() { "<.parser>Återställt.<./parser> "; }

    /* restore canceled */
    restoreCanceled() { "<.parser>Avbrutet.<./parser> "; }

    /* restore failed due to storage server request error */
    restoreFailedOnServer(exc)
    {
        "<.parser>Misslyckades, på grund av ett problem att nå lagringsservern: 
        <<makeSentence(exc.errMsg)>><./parser>";
    }

    /* restore failed because the file was not a valid saved game file */
    restoreInvalidFile()
    {
        //"<.parser>Misslyckades: this is not a valid saved position file.<./parser> ";
        "<.parser>Misslyckades: det här är inte en korrekt sparad positioneringsfil.<./parser> ";
    }

    /* restore failed because the file was corrupted */
    restoreCorruptedFile()
    {
        "<.parser>Misslyckades: Den här tillståndslagrande filen verkar vara felaktig. 
        Detta kan inträffa om filen modifierats av ett annat program, eller att filen 
        kopierats mellan datorer i ett icke-binärt överföringsläge, eller att den 
        fysiska lagringsenheten som filen befinner sig på är skadad.<./parser> ";
        
    }

    /* restore failed because the file was for the wrong game or version */
    restoreInvalidMatch()
    {
        "<.parser>Misslyckades: filen sparades inte av detta spel (eller 
        sparades av en inkompatibel version av spelet).<./parser> ";
    }

    /* restore failed for some reason other than those distinguished above */
    restoreFailed(exc)
    {
        "<.parser>Misslyckades: positionen kunde inte återskapas.<./parser> ";
    }

    /* error showing the input file dialog (or character-mode equivalent) */
    filePromptFailed()
    {
        "<.parser>Ett systemfel inträffade medan förfrågandes ett filnamn. 
        Din dator kan ha lite ledigt minnesutrymme, eller ha 
        konfigurationsproblem.<./parser> ";
    }

    /* error showing the input file dialog, with a system error message */
    filePromptFailedMsg(msg)
    {
        "<.parser>Misslyckades: <<makeSentence(msg)>><./parser> ";
    }

    /* Web UI inputFile error: uploaded file is too large */
    webUploadTooBig = 'Filen du har valt är för stor för att ladda upp.'

    /* PAUSE prompt */
    pausePrompt()
    {
        "<.parser>Spelet är nu pausat. Tryck på mellanslagstangenten när 
        du är redo att återuppta spelet, eller tryck på tangenten &lsquo;S&rsquo; 
        för att spara den nuvarande positionen.<./parser><.p>";
    }

    /* saving from within a pause */
    pauseSaving()
    {
        "<.parser>Sparar spelet...<./parser><.p>";
    }

    /* PAUSE ended */
    pauseEnded()
    {
        "<.parser>Återupptar spelet.<./parser> ";
    }

    /* acknowledge starting an input script */
    inputScriptOkay(fname)
    {
        "<.parser>Läser kommandon från <q><<
          File.getRootName(fname).htmlify()>></q>...<./parser>\n ";
    }

    /* error opening input script */
    //inputScriptFailed = "<.parser>Failed; the script input file could not be opened.<./parser> "
    inputScriptFailed = "<.parser>Misslyckades; Scriptfilen kunde inte öppnas.<./parser> "

        
    /* exception opening input script */
    inputScriptFailedException(exc)
    {
        "<.parser>Misslyckades; <<exc.displayException>><./parser> ";
    }

    /* get the scripting inputFile prompt message */
    getScriptingPrompt = 'Välj ett namn för den nya scriptfilen'

    /* acknowledge scripting on */
    scriptingOkay()
    {
        "<.parser>Transkriberingen kommer att sparas till filen.
        Skriv <<aHref('script av', 'SCRIPT AV', 'Stäng av scripting')>> för 
        att avsluta transkriberingen.<./parser> ";
    }

    scriptingOkayWebTemp()
    {
        "<.parser>Transkriberingen kommer att sparas.
        Skriv <<aHref('script av', 'SCRIPT AV', 'Stäng av scripting')>> för 
        att avsluta transkriberingen och ladda ner den sparade transkribering.
        <./parser> ";
    }

    /* scripting failed */
    scriptingFailed = "<.parser>Misslyckades; ett fel inträffade vid öppnandet 
        av scriptfilen.<./parser> "

    /* scripting failed with an exception */
    scriptingFailedException(exc)
    {
        "<.parser>Misslyckades; <<exc.displayException>><./parser>";
    }

    /* acknowledge cancellation of script file dialog */
    scriptingCanceled = "<.parser>Avbrutet.<./parser> "

    /* acknowledge scripting off */
    scriptOffOkay = "<.parser>Transkriberingen avslutades.<./parser> "

    /* SCRIPT OFF ignored because we're not in a script file */
    scriptOffIgnored = "<.parser>Ingen transkribering spelas för närvarande in.<./parser> "

    /* get the RECORD prompt */
    getRecordingPrompt = 'Välj ett namn för den nya kommandologgfilen. '

    /* acknowledge recording on */
    recordingOkay = "<.parser>Kommandon kommer nu att spelas in.  Skriv
                     <<aHref('inspelning av', 'INSPELNING AV',
                             'Stäng av inspelning')>>
                     för att sluta spela in kommandon.<.parser> "

    /* recording failed */
    recordingFailed = "<.parser>Misslyckades; ett fel inträffade vid öppnandet av kommandologgfilen.<./parser> "

    /* recording failed with exception */
    recordingFailedException(exc)
    {
        "<.parser>Misslyckades; <<exc.displayException()>><./parser> ";
    }

    /* acknowledge cancellation */
    recordingCanceled = "<.parser>Avbrutet.<./parser> "

    /* recording turned off */
    recordOffOkay = "<.parser>Kommandoinspelningen avslutades.<./parser> "

    /* RECORD OFF ignored because we're not recording commands */
    recordOffIgnored = "<.parser>Ingen kommandoinspelning pågår för tillfället.<./parser> "

    /* REPLAY prompt */
    getReplayPrompt = 'Välj vilken kommandologgfil att spela upp'

    /* REPLAY file selection canceled */
    replayCanceled = "<.parser>Avbrutet.<./parser> "

    /* undo command succeeded */
    undoOkay(actor, cmd)
    {
        "<.parser>Tar tillbaka ett drag: <q>";

        /* show the target actor prefix, if an actor was specified */
        if (actor != nil)
            "<<actor>>, ";

        /* show the command */
        "<<cmd>></q>.<./parser><.p>";
    }

    /* undo command failed */
    undoFailed()
    {
        "<.parser>Ingen mer ångrainformation finns tillgänglig.<./parser> ";
    }

    /* comment accepted, with or without transcript recording in effect */
    noteWithScript = "<.parser>Kommentar inspelad.<./parser> "
    noteWithoutScript = "<.parser>Kommentar <b>ej</b> inspelad.<./parser> "

    /* on the first comment without transcript recording, warn about it */
    noteWithoutScriptWarning = "<.parser>Kommentar <b>ej</b> inspelad.
        Använd <<aHref('script', 'SCRIPT', 'Börja transkribering ')
          >> om du vill starta transkribering.<./parser> "

    /* invalid finishGame response */
    invalidFinishOption(resp)
    {
        //"\bThat isn&rsquo;t one of the options. ";
        //"\bDet är inte ett av alternativen. ";
        "\bDet är inte ett valbart alternativ. ";
    }

    /* acknowledge new "exits on/off" status */
    exitsOnOffOkay(stat, look)
    {
        if (stat && look)
            "<.parser>Listan med utgångar kommer nu att visas både på statusraden och i varje rumbeskrivning.<./parser> ";
        else if (!stat && !look)
            "<.parser>Listan med utgångar kommer inte längre visas vare sig på statusraden eller i rumbeskrivningen.<./parser> ";
        else
            "<.parser>Listan med utgångar kommer <<stat ? '' : 'ej'>>  att visas på statusraden, 
            och kommer <<look ? '' : 'ej'>> inkluderas i rumbeskrivningar.<./parser> ";
    }

    /* explain how to turn exit display on and off */
    explainExitsOnOff()
    {
        exitsTip.showTip();
    }

    /* describe the current EXITS settings */
    currentExitsSettings(statusLine, roomDesc)
    {
        "UTGÅNGAR ";
        if (statusLine && roomDesc)
            "PÅ";
        else if (statusLine)
            "STATUSRADEN";
        else if (roomDesc)
            "TITTA";
        else
            "AV";
    }

    /* acknowledge HINTS OFF */
    hintsDisabled = '<.parser>Ledtrådar är nu avstängda.<./parser> '

    /* rebuff a request for hints when they've been previously disabled */
    sorryHintsDisabled = '<.parser>Ledtrådar har dessvärre blivit avstängda
        för denna session, så som du begärde.  Om du har ändrat dig, kommer du 
        behöva spara din nuvarande position, avsluta TADS-speltolken, 
        och starta igång en ny session.<./parser> '

    /* this game has no hints */
    hintsNotPresent = '<.parser>Detta spel har tyvärr inte några inbyggda ledtrådar.<./parser> '

    /* there are currently no hints available (but there might be later) */
    currentlyNoHints = '<.parser>Tyvärr finns det inga ledtrådar tillgängliga för tillfället. 
                        Prova återkomma senare.<./parser> '

    /* show the hint system warning */
    showHintWarning =
        "<.notification>Varning: Vissa gillar inte inbyggda ledtrådar, då
        frestelsen att fråga efter hjälp för tidigt kan bli för övermäktig
        då ledtrådar är så lätta att tillgå. Om du oroar dig för att din 
        viljestyrka inte ska kvarhålla, så kan du stänga av ledtrådar för
        resten av den här sessionen genom att skriva <<aHref('ledtrådar av', 'LEDTRÅDAR AV')
       >>.  Om du fortfarande vill se ledtrådarna nu, skriv
       <<aHref('ledtråd', 'LEDTRÅD')>>.<./notification> "


    /* done with hints */
    hintsDone = '<.parser>Klart.<./parser> '

    /* optional command is not supported in this game */
    commandNotPresent = "<.parser>Det kommandot behövs inte i det här spelet.<./parser> "

    /* this game doesn't use scoring */
    scoreNotPresent = "<.parser>Det här spelet använder inte poängställning.<./parser> "

    /* mention the FULL SCORE command */
    mentionFullScore()
    {
        fullScoreTip.showTip();
    }

    /* SAVE DEFAULTS successful */
    savedDefaults()
    {
        "<.parser>Dina nuvarande inställningar har sparats som standardinställning för nya spel. 
            De sparade inställningarna är: ";

        /* show all of the settings */
        settingsUI.showAll();

        ".  De flesta nyare spel kommer att applicera dessa inställningar automatiskt
        närhelst du startar (eller OMSTARTAR) spelet, men observera dock att äldre spel 
        inte kommer göra det.<./parser> ";
    }

    /* RESTORE DEFAULTS successful */
    restoredDefaults()
    {
        //"<.parser>The saved default settings have been put into effect.  The new settings are: ";
        "<.parser>De sparade standardinställningarna har satts i spel.  De nya inställningarna är: ";

        /* show all of the settings */
        settingsUI.showAll();

        ".<./parser> ";
    }

    /* show a separator for the settingsUI.showAll() list */
    settingsItemSeparator = "; "

    /* SAVE/RESTORE DEFAULTS not supported (old interpreter version) */

    defaultsFileNotSupported = "<.parser>Tyvärr stödjer inte versionen 
        av din TADS-speltolk att spara eller återskapa standardinställningar. 
        Du behöver installera en nyare version för att kunna använda denna
        förmåga.<./parser> "

    /* RESTORE DEFAULTS file open/read error */
    defaultsFileReadError(exc)
    {
        "<.parser>Ett fel inträffade vid läsningen av standardinställningarna från fil.  
        De globala standardinställningarna kan inte återskapas.<./parser> ";
    }

    /* SAVE DEFAULTS file creation error */
    defaultsFileWriteError = "<.parser>Ett fel inträffade vid skrivning av
        standardinställningarna till fil.  Standardinställningarna har inte 
        sparats. Det kan bero på att du har slut på diskutrymme, eller att du
        inte har nödvändiga privilegier för att skriva till filen.<./parser> "

    /*
     *   Command key list for the menu system.  This uses the format
     *   defined for MenuItem.keyList in the menu system.  Keys must be
     *   given as lower-case in order to match input, since the menu
     *   system converts input keys to lower case before matching keys to
     *   this list.  
     *   
     *   Note that the first item in each list is what will be given in
     *   the navigation menu, which is why the fifth list contains 'ENTER'
     *   as its first item, even though this will never match a key press.
     */
    menuKeyList = [
                   ['q'],
                   ['p', '[vänster]', '[bksp]', '[esc]'],
                   ['u', '[upp]'],
                   ['d', '[ner]'],
                   ['RADBRYT', '\n', '[höger]', ' ']
                  ]

    /* link title for 'previous menu' navigation link */
    prevMenuLink = '<font size=-1>Föregående</font>'

    /* link title for 'next topic' navigation link in topic lists */
    nextMenuTopicLink = '<font size=-1>Nästa</font>'

    /*
     *   main prompt text for text-mode menus - this is displayed each
     *   time we ask for a keystroke to navigate a menu in text-only mode 
     */
    textMenuMainPrompt(keylist)
    {
        "\bVälj ett ämnesnummer, eller tryck på &lsquo;<<
        keylist[M_PREV][1]>>&rsquo; för den föregående menyn
        eller &lsquo;<<keylist[M_QUIT][1]>>&rsquo; för att avsluta:\ ";
    }

    /* prompt text for topic lists in text-mode menus */
    textMenuTopicPrompt()
    {
        "\bTryck på mellanslagstangen för att visa nästa rad,
        &lsquo;<b>P</b>&rsquo; för att gå tillbaka till föregående meny, eller
        &lsquo;<b>Q</b>&rsquo; för att avsluta.\b";
    }

    /*
     *   Position indicator for topic list items - this is displayed after
     *   a topic list item to show the current item number and the total
     *   number of items in the list, to give the user an idea of where
     *   they are in the overall list.  
     */
    menuTopicProgress(cur, tot) { " [<<cur>>/<<tot>>]"; }

    /*
     *   Message to display at the end of a topic list.  We'll display
     *   this after we've displayed all available items from a
     *   MenuTopicItem's list of items, to let the user know that there
     *   are no more items available.  
     */
    menuTopicListEnd = '[Slutet]'

    /*
     *   Message to display at the end of a "long topic" in the menu
     *   system.  We'll display this at the end of the long topic's
     *   contents.  
     */
    menuLongTopicEnd = '[Slutet]'

    /*
     *   instructions text for banner-mode menus - this is displayed in
     *   the instructions bar at the top of the screen, above the menu
     *   banner area 
     */
    menuInstructions(keylist, prevLink)
    {
        "<tab align=right ><b>\^<<keylist[M_QUIT][1]>></b>=Avsluta <b>\^<<
        keylist[M_PREV][1]>></b>=Föregående Meny<br>
        <<prevLink != nil ? aHrefAlt('föregående', prevLink, '') : ''>>
        <tab align=right ><b>\^<<keylist[M_UP][1]>></b>=Upp <b>\^<<
        keylist[M_DOWN][1]>></b>=Ner <b>\^<<
        keylist[M_SEL][1]>></b>=Välj<br>";
    }

    /* show a 'next chapter' link */
    menuNextChapter(keylist, title, hrefNext, hrefUp)
    {
        "Nästa: <<aHref(hrefNext, title)>>;
        <b>\^<<keylist[M_PREV][1]>></b>=<<aHref(hrefUp, 'Meny')>>";
    }

    /*
     *   cannot reach (i.e., touch) an object that is to be manipulated in
     *   a command - this is a generic message used when we cannot
     *   identify the specific reason that the object is in scope but
     *   cannot be touched 
     */
    cannotReachObject(obj)
    {
        "{Du/han} {kan} inte nå <<obj.theNameObj>>. ";
    }

    /*
     *   cannot reach an object, because the object is inside the given
     *   container 
     */
    cannotReachContents(obj, loc)
    {
        gMessageParams(obj, loc);
        return '{Du/han} {kan} inte nå {det obj/honom} genom ' + '{den loc/honom}. ';
    }

    /* cannot reach an object because it's outside the given container */
    cannotReachOutside(obj, loc)
    {
        gMessageParams(obj, loc);
        return '{Du/han} {kan} inte nå {det obj/honom} genom ' + '{den loc/honom}. ';
    }

    /* sound is coming from inside/outside a container */
    soundIsFromWithin(obj, loc)
    {
        "\^<<obj.theName>> {verkar|verkade} komma från insidan <<loc.theNameObj>>. ";
    }
    soundIsFromWithout(obj, loc)
    {
        "\^<<obj.theName>> {verkar|verkade} komma från utsidan <<loc.theNameObj>>. ";    }

    /* odor is coming from inside/outside a container */
    smellIsFromWithin(obj, loc)
    {
        "\^<<obj.theName>> {verkar|verkade} komma från insidan <<loc.theNameObj>>. ";
    }
    smellIsFromWithout(obj, loc)
    {
        "\^<<obj.theName>> {verkar|verkade} komma från utsidan <<loc.theNameObj>>. ";
    }

    /* default description of the player character */
    pcDesc(actor)
    {
        "\^<<actor.theName>> {ser|såg} likadan ut som vanligt. ";
    }

    /*
     *   Show a status line addendum for the actor posture, without
     *   mentioning the actor's location.  We won't mention standing, since
     *   this is the default posture.  
     */
    roomActorStatus(actor)
    {
        /* mention any posture other than standing */
        if (actor.posture != standing) {
            " (<<actor.posture.participle>>)";
        }
    }

    /* show a status line addendum: standing in/on something */
    actorInRoomStatus(actor, room)
        { " (<<actor.posture.participle>> <<room.actorInName>>)"; }

    /* generic short description of a dark room */
    roomDarkName = 'I mörkret'

    /* generic long description of a dark room */
    roomDarkDesc = "Det {är|var} kolsvart. "

    /*
     *   mention that an actor is here, without mentioning the enclosing
     *   room, as part of a room description 
     */
    roomActorHereDesc(actor)
    {
        "\^<<actor.theName>> <<actor.posture.participle>> <<tSel('här', 'där')>>. ";
    }

    /*
     *   mention that an actor is visible at a distance or remotely,
     *   without mentioning the enclosing room, as part of a room
     *   description 
     */
    roomActorThereDesc(actor)
    {
        //"\^<<actor.nameIs>> <<actor.posture.participle>> i närheten. ";
        "\^<<actor.theName>> <<actor.posture.participle>> i närheten. ";
    }

    /*
     *   Mention that an actor is in a given local room, as part of a room
     *   description.  This is used as a default "special description" for
     *   an actor.  
     */
    actorInRoom(actor, cont)
    {
        //"\^<<actor.nameIs>> <<actor.posture.participle>> <<cont.actorInName>>. ";
        "\^<<actor.theName>> <<actor.posture.participle>> <<cont.actorInName>>. ";
    }

    /*
     *   Describe an actor as standing/sitting/lying on something, as part
     *   of the actor's EXAMINE description.  This is additional
     *   information added to the actor's description, so we refer to the
     *   actor with a pronoun ("He's standing here").  
     */
    actorInRoomPosture(actor, room)
    {
        "{Det actor/han} <<actor.posture.participle>> <<room.actorInName>>. ";
    }

    /*
     *   Describe an actor's posture, as part of an actor's "examine"
     *   description.  If the actor is standing, don't bother mentioning
     *   anything, as standing is the trivial default condition.  
     */
    roomActorPostureDesc(actor)
    {
        if (actor.posture != standing) {
            "{Det actor/han} <<actor.posture.participle>>. ";
        }
    }

    /*
     *   mention that the given actor is visible, at a distance or
     *   remotely, in the given location; this is used in room
     *   descriptions when an NPC is visible in a remote or distant
     *   location 
     */
    actorInRemoteRoom(actor, room, pov)
    {
        /* say that the actor is in the room, using its remote in-name */
        "\^<<actor.theName>> <<actor.posture.participle>> <<room.inRoomName(pov)>>. ";
    }

    /*
     *   mention that the given actor is visible, at a distance or
     *   remotely, in the given nested room within the given outer
     *   location; this is used in room descriptions 
     */
    actorInRemoteNestedRoom(actor, inner, outer, pov)
    {
        /*
         *   say that the actor is in the nested room, in the current
         *   posture, and add then add that we're in the outer room as
         *   well 
         */
        "\^<<actor.nameIs>> <<outer.inRoomName(pov)>>,
        <<actor.posture.participle>> <<inner.actorInName>>. ";
    }

    /*
     *   Prefix/suffix messages for listing actors in a room description,
     *   for cases when the actors are in the local room in a nominal
     *   container that we want to mention: "Bob and Bill are sitting on
     *   the couch."  
     */
    actorInGroupPrefix(posture, cont, lst) { "\^"; }
    actorInGroupSuffix(posture, cont, lst)
    {
        // Inget behov av är/var i svenskan, vi går direkt på verbet
        //" <<lst.length() == 1 ? tSel('är', 'var') : tSel('är', 'var')>>
        " <<posture.participle>> <<cont.actorInName>>. ";
    }

    /*
     *   Prefix/suffix messages for listing actors in a room description,
     *   for cases when the actors are inside a nested room that's inside
     *   a remote location: "Bob and Bill are in the courtyard, sitting on
     *   the bench." 
     */
    actorInRemoteGroupPrefix(pov, posture, cont, remote, lst) { "\^"; }
    actorInRemoteGroupSuffix(pov, posture, cont, remote, lst)
    {
        //" <<lst.length() == 1 ? tSel('är', 'var') : tSel('är', 'var')>>
        " <<remote.inRoomName(pov)>>, <<posture.participle>>
        <<cont.actorInName>>. ";
    }

    /*
     *   Prefix/suffix messages for listing actors in a room description,
     *   for cases when the actors' nominal container cannot be seen or is
     *   not to be stated: "Bob and Bill are standing here."
     *   
     *   Note that we don't always want to state the nominal container,
     *   even when it's visible.  For example, when actors are standing on
     *   the floor, we don't bother saying that they're on the floor, as
     *   that's stating the obvious.  The container will decide whether or
     *   not it wants to be included in the message; containers that don't
     *   want to be mentioned will use this form of the message.  
     */
    actorHereGroupPrefix(posture, lst) { "\^"; }
    actorHereGroupSuffix(posture, lst)
    {
        // e.g "Bob och Bill står här"
        " <<posture.participle>> <<tSel('här', 'där')>>. ";
    }

    /*
     *   Prefix/suffix messages for listing actors in a room description,
     *   for cases when the actors' immediate container cannot be seen or
     *   is not to be stated, and the actors are in a remote location:
     *   "Bob and Bill are in the courtyard."  
     */
    actorThereGroupPrefix(pov, posture, remote, lst) { "\^"; }
    actorThereGroupSuffix(pov, posture, remote, lst)
    {
        //" <<lst.length() == 1 ? tSel('är', 'var') : tSel('är', 'var')>>
        " <<posture.participle>> <<remote.inRoomName(pov)>>. ";
    }

    /* a traveler is arriving, but not from a compass direction */
    sayArriving(traveler)
    {
        //"\^<<traveler.travelerName(true)>> enter<<traveler.verbEndingSEd>> <<traveler.travelerLocName>>. ";
        "\^<<traveler.travelerName(true)>> <<traveler.verbToCome>> till <<traveler.travelerLocName>>. ";
    }

    /* a traveler is departing, but not in a compass direction */
    sayDeparting(traveler)
    {
        "\^<<traveler.travelerName(nil)>> <<traveler.verbToLeave>> <<traveler.travelerLocName>>. ";
    }

    /*
     *   a traveler is arriving locally (staying within view throughout the
     *   travel, and coming closer to the PC) 
     */
    sayArrivingLocally(traveler, dest)
    {
        "\^<<traveler.travelerName(true)>> <<traveler.verbToCome>> till <<traveler.travelerLocName>>. ";
    }

    /*
     *   a traveler is departing locally (staying within view throughout
     *   the travel, and moving further away from the PC) 
     */
    sayDepartingLocally(traveler, dest)
    {
        "\^<<traveler.travelerName(true)>> <<traveler.verbToLeave>> <<traveler.travelerLocName>>. ";
    }

    /*
     *   a traveler is traveling remotely (staying within view through the
     *   travel, and moving from one remote top-level location to another) 
     */
    sayTravelingRemotely(traveler, dest)
    {
        //"\^<<traveler.travelerName(true)>> <<traveler.verbToGo>> to <<traveler.travelerLocName>>. ";
        "\^<<traveler.travelerName(true)>> <<traveler.verbToGo>> till <<traveler.travelerLocName>>. ";
    }

    /* a traveler is arriving from a compass direction */
    sayArrivingDir(traveler, dirName)
    {
        // Byt ut ändelsen -'ut' till '-ifrån' när vi beskriver 
        // varifrån någon kom, tex: "En hobbit kom till Fylke norrifrån."
        local dirNameEnding2 = dirName.splice(-2, 2, 'ifrån');
        "\^<<traveler.travelerName(true)>> <<traveler.verbToCome>> till <<traveler.travelerRemoteLocName>> <<dirNameEnding2>>. ";
    }

    /* a traveler is leaving in a given compass direction */
    sayDepartingDir(traveler, dirName)
    {
        local nm = traveler.travelerRemoteLocName;
        /* ORG:
            "\^<<traveler.travelerName(nil)>> <<traveler.verbToLeave>>
            to the <<dirName>><<nm != '' ? ' from ' + nm : ''>>. ";
        */
        "\^<<traveler.travelerName(nil)>> <<traveler.verbToLeave>> <<nm>> <<dirName>>. ";

        //"\^<<traveler.travelerName(nil)>> <<traveler.verbToLeave>>   <<dirName>><<nm != '' ? ' från ' + nm : ''>>. ";
        //"\^<<traveler.travelerName(nil)>> <<traveler.verbToLeave>> 
        //to the <<dirName>><<nm != '' ? ' from ' + nm : ''>>. ";
    }
    
    /* a traveler is arriving from a shipboard direction */
    sayArrivingShipDir(traveler, dirName)
    {
        // Byt ut ändelsen -'ut' till '-ifrån' när vi beskriver 
        // varifrån någon kom, tex: "En hobbit kom till Fylke akterifrån." 
        // föröverifrån, babordssida,
        //local dirNameEnding2 = dirName + 'ifrån';
        "\^<<traveler.travelerName(true)>> <<traveler.verbToCome>> till <<traveler.travelerRemoteLocName>> från <<dirName>>. ";
    }

    /* a traveler is leaving in a given shipboard direction */
    sayDepartingShipDir(traveler, dirName)
    {
        local nm = traveler.travelerRemoteLocName;
        "\^<<traveler.travelerName(nil)>> <<traveler.verbToGo>> <<dirName>><<nm != '' ? ' mot ' + nm : ''>>. ";
    }

    /* a traveler is going aft */
    sayDepartingAft(traveler)
    {
        local nm = traveler.travelerRemoteLocName;
        
        "\^<<traveler.travelerName(nil)>> <<traveler.verbToGo>> akteröver<<nm != '' ? ' mot ' + nm : ''>>. ";
    }

    /* a traveler is going fore */
    sayDepartingFore(traveler)
    {
        local nm = traveler.travelerRemoteLocName;

        "\^<<traveler.travelerName(nil)>> <<traveler.verbToGo>> föröver<<nm != '' ? ' mot ' + nm : ''>>. ";
    }

    /* a shipboard direction was attempted while not onboard a ship */
    notOnboardShip = "Den riktningen sakna{r|de} betydelse {här}. "

    /* a traveler is leaving via a passage */
    sayDepartingThroughPassage(traveler, passage)
    {
        "\^<<traveler.travelerName(nil)>> <<traveler.verbToLeave>>
        <<traveler.travelerRemoteLocName>> genom <<passage.theNameObj>>. ";
    }

    /* a traveler is arriving via a passage */
    sayArrivingThroughPassage(traveler, passage)
    {
        "\^<<traveler.travelerName(true)>> <<traveler.verbToCome>> in i <<traveler.travelerRemoteLocName>> genom <<passage.theNameObj>>. ";
    }

    /* a traveler is leaving via a path */
    sayDepartingViaPath(traveler, passage)
    {
        "\^<<traveler.travelerName(nil)>> <<traveler.verbToLeave>> <<traveler.travelerRemoteLocName>> via <<passage.theNameObj>>. ";
    }

    /* a traveler is arriving via a path */
    sayArrivingViaPath(traveler, passage)
    {
        "\^<<traveler.travelerName(true)>> <<traveler.verbToCome>> till <<traveler.travelerRemoteLocName>> via <<passage.theNameObj>>. ";
    }

    /* a traveler is leaving up a stairway */
    sayDepartingUpStairs(traveler, stairs)
    {
        "\^<<traveler.travelerName(nil)>> <<traveler.verbToGo>> upp för <<stairs.theNameObj>>. ";
    }

    /* a traveler is leaving down a stairway */
    sayDepartingDownStairs(traveler, stairs)
    {
        "\^<<traveler.travelerName(nil)>> <<traveler.verbToGo>> ner för <<stairs.theNameObj>>. ";
    }

    /* a traveler is arriving by coming up a stairway */
    sayArrivingUpStairs(traveler, stairs)
    {
        local nm = traveler.travelerRemoteLocName;

        "\^<<traveler.travelerName(true)>> <<traveler.verbToCome>> upp från <<stairs.theNameObj>><<nm != '' ? ' till ' + nm : ''>>. ";
    }

    /* a traveler is arriving by coming down a stairway */
    sayArrivingDownStairs(traveler, stairs)
    {
        local nm = traveler.travelerRemoteLocName;

        "\^<<traveler.travelerName(true)>> <<traveler.verbToCome>>
        ner från <<stairs.theNameObj>><<nm != '' ? ' till ' + nm : ''>>. ";
    }

    /* acompanying another actor on travel */
    sayDepartingWith(traveler, lead)
    {
        "\^<<traveler.travelerName(nil)>> <<traveler.verbToCome2>> med <<lead.theNameObj>>. ";
    }

    /*
     *   Accompanying a tour guide.  Note the seemingly reversed roles:
     *   the lead actor is the one initiating the travel, and the tour
     *   guide is the accompanying actor.  So, the lead actor is
     *   effectively following the accompanying actor.  It seems
     *   backwards, but really it's not: the tour guide merely shows the
     *   lead actor where to go, but it's up to the lead actor to actually
     *   initiate the travel.  
     */
    sayDepartingWithGuide(guide, lead)
    {
        "\^<<lead.theName>> <<tSel('låter', 'lät')>> <<guide.theNameObj>> leda vägen. ";
    }

    /* note that a door is being opened/closed remotely */
    sayOpenDoorRemotely(door, stat)
    {
        "Någon <<stat ? 'öppna' + tSel('r', 'de') : 'stäng' + tSel('er', 'de')>>
        <<door.theNameObj>> från den andra sidan. ";
    }

    /*
     *   open/closed status - these are simply adjectives that can be used
     *   to describe the status of an openable object 
     */
    openMsg(obj) { 
        //gMessageParams(obj);
        //return 'öpp{en/et/na}';
        if(obj.isPlural) {
            return 'öppna';
        }
        return 'öppe<<obj.isNeuter?'t':'n'>>'; 
        
    }

    closedMsg(obj) { 
        //gMessageParams(obj);
        //return 'stäng{d/t/da}';
        if(obj.isPlural) {
            return 'stängda';
        }
        return 'stäng<<obj.isNeuter?'t':'d'>>'; 
    }

    /* object is currently open/closed */
    //currentlyOpen = '{Detär dobj} för närvarande öpp en/na öppe<<obj.isNeuter?'t':'n'>>. '
    //currentlyClosed = '{Detär dobj} för närvarande stäng<<obj.isNeuter?'t':'d'>>. '
    currentlyOpen = '{Denär dobj} för närvarande öpp{en/et/na}. ' // TODO: ta bort sammansättningen
    currentlyClosed = '{Detär dobj} för närvarande stäng{d/t/da}. ' // TODO: ta bort sammansättningen

    // eval buildParam('en/ett/na', buildSynthParam(stugdorrUtsida))


    /* stand-alone independent clause describing current open status */
    openStatusMsg(obj) { return obj.itNom + ' ' + obj.verbToBe + ' ' + obj.openDesc; }

    /* locked/unlocked status - adjectives describing lock states */
    lockedMsg(obj) { 
        return 'låst{a}'; 
    }
    
    unlockedMsg(obj) { 
        return 'olåst{a}'; 
    }

    /* object is currently locked/unlocked */
    currentlyLocked = '{Denär dobj} för närvarande låst{a}. '
    currentlyUnlocked = '{Denär dobj} för närvarande olåst{a}. '

    /*
     *   on/off status - these are simply adjectives that can be used to
     *   describe the status of a switchable object 
     */
    onMsg(obj) { return 'på'; }
    offMsg(obj) { return 'av'; }

    /* daemon report for burning out a match */
    matchBurnedOut(obj)
    {
        gMessageParams(obj);
        //"{Den obj/ref} finish{es/ed} burning, and disappear{s/ed} into a cloud of ash. ";
        "{Den obj/ref} br{inner|ann} upp, och försv{inner|ann} i ett moln av aska. ";
    }

    /* daemon report for burning out a candle */
    candleBurnedOut(obj)
    {
        gMessageParams(obj);
        //"{Den obj/ref} burn{s/ed} down too far to stay lit, and {goes} out. ";
        "{Den obj/ref} br{inner|ann} ner för långt för att fortsätta vara tänt, och slockna{r|de}. ";
    }

    /* daemon report for burning out a generic fueled light source */
    objBurnedOut(obj)
    {
        gMessageParams(obj);
        "{Den obj/ref} slockna{r|de}. ";
    }

    /* 
     *   Standard dialog titles, for the Web UI.  These are shown in the
     *   title bar area of the Web UI dialog used for inputDialog() calls.
     *   These correspond to the InDlgIconXxx icons.  The conventional
     *   interpreters use built-in titles when titles are needed at all,
     *   but in the Web UI we have to generate these ourselves. 
     */
    dlgTitleNone = 'Information'
    dlgTitleWarning = 'Varning'
    dlgTitleInfo = 'Information'
    dlgTitleQuestion = 'Fråga'
    dlgTitleError = 'Fel'

    /*
     *   Standard dialog button labels, for the Web UI.  These are built in
     *   to the conventional interpreters, but in the Web UI we have to
     *   generate these ourselves.  
     */
    dlgButtonOk = 'OK'
    dlgButtonCancel = 'Avbryt'
    dlgButtonYes = 'Ja'
    dlgButtonNo = 'Nej'

    /* web UI alert when a new user has joined a multi-user session */
    webNewUser(name) { "\b[<<name>> har anslutit till sessionen.]\n"; }

    /*
     *   Warning prompt for inputFile() warnings generated when reading a
     *   script file, for the Web UI.  The interpreter normally displays
     *   these warnings directly, but in Web UI mode, the program is
     *   responsible, so we need localized messages.  
     */
    inputFileScriptWarning(warning, filename)
    {
        /* remove the two-letter error code at the start of the string */
        warning = warning.substr(3);

        /* build the message */
        return warning + ' Vill du fortsätta?';
    }
    inputFileScriptWarningButtons = [
        '&Ja, använd denna fil', '&Välj en annan fil', '&Stoppa scriptet']
;

/* ------------------------------------------------------------------------ */
/*
 *   Player Character messages.  These messages are generated when the
 *   player issues a regular command to the player character (i.e.,
 *   without specifying a target actor).  
 */
playerMessages: libMessages
    /* invalid command syntax */
    commandNotUnderstood(actor)
    {
        "<.parser>Spelet förstår inte det kommandot.<./parser> ";
    }

    /* a special topic can't be used right now, because it's inactive */
    specialTopicInactive(actor)
    {
        "<.parser>Det kommandot kan inte användas just nu.<./parser> ";
    }

    /* no match for a noun phrase */
    noMatch(actor, action, txt) { action.noMatch(self, actor, txt); }


    uterPattern = static new RexPattern('(.*)en$|.*(um|e|el|er|en)$')

    /*
     *   No match message - we can't see a match for the noun phrase.  This
     *   is the default for most verbs. 
     */


    noMatchCannotSee(actor, txt) { 
        local match, pronoun;
        local target = txt.toLower();
        match = cmdDict.findWord(target);

        if(match != nil) {
            match = match[1];
        } else {
            forEachInstance(Thing, function(obj) {
                if(obj.name.startsWith(target) || obj.theName.startsWith(target)) {
                    match = obj;
                    throw new BreakLoopSignal();
                }        
            });
        }

        if(match) {
            if(match.definitiveForm == txt) {
                "{Du/han} {ser} inte <<txt>> {här}. "; 
            } else {
                pronoun = match.isPlural ? 'inga' : match.isNeuter ? 'inget' : 'ingen';                
                "{Du/han} {ser} <<pronoun>> <<txt>> {här}. "; 
            }
        } else {
            pronoun = rexMatch(uterPattern, txt) ? 'ingen' : 'inget';
            "{Du/han} {ser} <<pronoun>> sådant {här}. "; 

        }
    }

    /*
     *   No match message - we're not aware of a match for the noun phrase.
     *   Some sensory actions, such as LISTEN TO and SMELL, use this
     *   variation instead of the normal version; the things these commands
     *   refer to tend to be intangible, so "you can't see that" tends to
     *   be nonsensical. 
     */
    noMatchNotAware(actor, txt)
        { "{Du/han} {är} inte varsebliven någon <<txt>> {här}. "; }

    /* 'all' is not allowed with the attempted action */
    allNotAllowed(actor)
    {
        "<.parser><q>Allt</q> kan inte användas med det verbet.<./parser> ";
    }

    /* no match for 'all' */
    noMatchForAll(actor)
    {
        "<.parser>{Du/han} {ser} inget passande {här}.<./parser> ";
    }

    /* nothing left for 'all' after removing 'except' items */
    noMatchForAllBut(actor)
    {
        "<.parser>{Du/han} {ser} ingenting annat {här}.<./parser> ";
    }

    /* nothing left in a plural phrase after removing 'except' items */
    noMatchForListBut(actor) { noMatchForAllBut(actor); }

    /* no match for a pronoun */
    noMatchForPronoun(actor, typ, pronounWord)
    {
        /* show the message */
        "<.parser>Ordet <q><<pronounWord>></q> referera{r|de} inte till någonting just nu.<./parser> ";
    }

    /*
     *   Ask for a missing object - this is called when a command is
     *   completely missing a noun phrase for one of its objects.  
     */
    askMissingObject(actor, action, which)
    {
        local actorName = actor.referralPerson == ThirdPerson ? ' '+actor.theName : '';
        reportQuestion('<.parser>\^' + action.whatObj(which)
                       + ' vill du<<actorName>> <<action.getQuestionInf(which)>>?<./parser> ');
    }

    /*
     *   An object was missing - this is called under essentially the same
     *   circumstances as askMissingObject, but in cases where interactive
     *   resolution is impossible and we simply wish to report the problem
     *   and do not wish to ask for help.
     */
    missingObject(actor, action, which)
    {
        "<.parser>Du behöver vara specifik om <<action.whatObj(which)>> du vill
        <<actor.referralPerson == ThirdPerson ? actor.theName : ''>> 
        ska <<action.getQuestionInf(which)>>.<./parser> ";
    }

    /*
     *   Ask for a missing literal phrase. 
     */
    askMissingLiteral(actor, action, which)
    {
        /* use the standard missing-object message */
        askMissingObject(actor, action, which);
    }

    /*
     *   Show the message for a missing literal phrase.
     */
    missingLiteral(actor, action, which)
    {
        /*"<.parser>Please be more specific
        about <<action.whatObj(which)>> to
        <<action.getQuestionInf(which)>>.  Try, for example,
        <<action.getQuestionInf(which)>> <q>something</q>.<./parser> ";
        */
        "<.parser>Var mer specifik om <<action.whatObj(which)>> du vill <<action.getQuestionInf(which)>>. Försök, exempelvis,
        <<action.getQuestionInf(which)>> <q>någonting</q>.<./parser> ";

    }

    /* reflexive pronoun not allowed */
    reflexiveNotAllowed(actor, typ, pronounWord)
    {
        "<.parser>Spelet förstå inte hur det ska använda ordet
        <q><<pronounWord>></q> på det sättet.<./parser> ";
    }

    /*
     *   a reflexive pronoun disagrees in gender, number, or something
     *   else with its referent 
     */
    wrongReflexive(actor, typ, pronounWord)
    {
        "<.parser>Spelet förstår inte vad order <q><<pronounWord>></q> refererar till.<./parser> ";
    }

    /* no match for a possessive phrase */
    noMatchForPossessive(actor, owner, txt)
    {
        "<.parser>\^<<owner.nameSeem>> inte ha någon sådan sak.<./parser> ";
    }

    /* no match for a plural possessive phrase */
    noMatchForPluralPossessive(actor, txt)
    {
        "<.parser>\^de verka{r|de} inte ha någon sådan sak.<./parser> ";
    }

    /* no match for a containment phrase */
    noMatchForLocation(actor, loc, txt)
    {        
        // Du såg ingen kikare på marken
        // Du såg ingen äpple på marken
        // Du såg in

        //"<.parser>\^<<actor.nameSees>> inge<<utrum?'n':'t'>> <<loc.childInName(txt)>>.<./parser>";
        "<.parser>\^<<actor.nameSees>> inget liknande {här|där}.<./parser>";
        //"<.parser>\^Detta syntes inte till.<./parser> ";
    }

    /* nothing in a container whose contents are specifically requested */
    nothingInLocation(actor, loc)
    {
        "<.parser>\^<<actor.nameSees>>
        <<loc.childInName('inget ovanligt')>>.<./parser> ";
    }

    /* no match for the response to a disambiguation question */
    noMatchDisambig(actor, origPhrase, disambigResponse)
    {
        /*
         *   show the message, leaving the <.parser> tag mode open - we
         *   always show another disambiguation prompt after this message,
         *   so we'll let the prompt close the <.parser> mode 
         */
        "<.parser>Det var inte ett av alternativen. ";
    }

    /* empty noun phrase ('take the') */
    emptyNounPhrase(actor)
    {
        "<.parser>Du verkar ha utelämnat några ord.<./parser> ";
    }

    /* 'take zero books' */
    zeroQuantity(actor, txt)
    {
        "<.parser>\^<<actor.theName>> <<actor.verbCant>> göra det med noll av någonting.<./parser> ";
    }

    /* insufficient quantity to meet a command request ('take five books') */
    insufficientQuantity(actor, txt, matchList, requiredNum)
    {
        "<.parser>\^<<actor.theName>> ser inte särskilt många <<txt>> <<tSel('här', 'där')>>.<./parser> ";
    }

    /* a unique object is required, but multiple objects were specified */
    uniqueObjectRequired(actor, txt, matchList)
    {
        "<.parser>Du kan inte använda multipla objekt där.<./parser> ";
    }

    /* a single noun phrase is required, but a noun list was used */
    singleObjectRequired(actor, txt)
    {
        "<.parser>Multipla objekt are inte tillåtet med det kommandot.<./parser> ";
    }

    /*
     *   The answer to a disambiguation question specifies an invalid
     *   ordinal ("the fourth one" when only three choices were offered).
     *   
     *   'ordinalWord' is the ordinal word entered ('fourth' or the like).
     *   'originalText' is the text of the noun phrase that caused the
     *   disambiguation question to be asked in the first place.  
     */
    disambigOrdinalOutOfRange(actor, ordinalWord, originalText)
    {
        /* leave the <.parser> tag open, for the re-prompt that will follow */
        "<.parser>Det fanns inte så många alternativ. ";
    }

    /*
     *   Ask the canonical disambiguation question: "Which x do you
     *   mean...?".  'matchList' is the list of ambiguous objects with any
     *   redundant equivalents removed; and 'fullMatchList' is the full
     *   list, including redundant equivalents that were removed from
     *   'matchList'.
     *   
     *   If askingAgain is true, it means that we're asking the question
     *   again because we got an invalid response to the previous attempt
     *   at the same prompt.  We will have explained the problem, and now
     *   we're going to give the user another crack at the same response.
     *   
     *   To prevent interactive disambiguation, do this:
     *   
     *   throw new ParseFailureException(&ambiguousNounPhrase,
     *.  originalText, matchList, fullMatchList); 
     */
    askDisambig(actor, originalText, matchList, fullMatchList,
                requiredNum, askingAgain, dist)
    {
        /* mark this as a question report with a dummy report */
        reportQuestion('');
        
        /*
         *   Open the "<.parser>" tag, if we're not "asking again."  If we
         *   are asking again, we will already have shown a message
         *   explaining why we're asking again, and that message will have
         *   left us in <.parser> tag mode, so we don't need to open the
         *   tag again. 
         */
        if (!askingAgain)
            "<.parser>";
        
        /*
         *   the question varies depending on whether we want just one
         *   object or several objects in the final result 
         */
        if (requiredNum == 1)
        {
            /*
             *   One object needed - use the original text in the query.
             *   
             *   Note that if we're "asking again," we will have shown an
             *   additional message first explaining *why* we're asking
             *   again, and that message will have left us in <.parser>
             *   tag mode; so we need to close the <.parser> tag in this
             *   case, but we don't need to show a new one. 
             */

            local whichWord = (matchList.length>0 && matchList[1].obj_.isNeuter)?'Vilket':'Vilken';
            if (askingAgain)
            
                "<<whichWord>> menade du,
                <<askDisambigList(matchList, fullMatchList, nil, dist)>>?";
            else
                "<<whichWord>> <<originalText>> menar du,
                <<askDisambigList(matchList, fullMatchList, nil, dist)>>?";
        }
        else
        {
            /*
             *   Multiple objects required - ask by number, since we can't
             *   easily guess what the plural might be given the original
             *   text.
             *   
             *   As above, we only need to *close* the <.parser> tag if
             *   we're asking again, because we will already have shown a
             *   prompt that opened the tag in this case.  
             */
            local whichWord = (matchList.length>0 && matchList[1].isNeuter)?'Vilket':'Vilken';

            if (askingAgain)
                "<<whichWord>> <<spellInt(requiredNum)>> (av
                <<askDisambigList(matchList, fullMatchList, true, dist)>>)
                menade du?";
            else
                "<<whichWord>> <<spellInt(requiredNum)>>
                (av <<askDisambigList(matchList, fullMatchList,
                                      true, dist)>>) menar du?";
        }

        /* close the <.parser> tag */
        "<./parser> ";
    }

    /*
     *   we found an ambiguous noun phrase, but we were unable to perform
     *   interactive disambiguation 
     */
    ambiguousNounPhrase(actor, originalText, matchList, fullMatchList)
    {
        "<.parser>Spelet vet inte vilken 
        <<originalText>> du menar.<./parser> ";
    }

    /* the actor is missing in a command */
    missingActor(actor)
    {
        "<.parser>Du behöv{er|de} vara mer specifik om <<whomPronoun>> du vill<<tSel('', 'e')>> addressera.<./parser> ";
    }

    /* only a single actor can be addressed at a time */
    singleActorRequired(actor)
    {
        "<.parser>Du kan bara addressera en person åt gången.<./parser> ";
    }   

    /* cannot change actor mid-command */
    cannotChangeActor()
    {
        "<.parser>Du kan inte addressera mer än en karaktär åt gången per kommandorad i det här spelet.<./parser> ";
    }

    /*
     *   tell the user they entered a word we don't know, offering the
     *   chance to correct it with "oops" 
     */
    askUnknownWord(actor, txt)
    {
        /* start the message */
        "<.parser>Ordet <q><<txt>></q> är ej nödvändigt i denna berättelse.<./parser> ";

        /* mention the OOPS command, if appropriate */
        oopsNote();
    }

    /*
     *   tell the user they entered a word we don't know, but don't offer
     *   an interactive way to fix it (i.e., we can't use OOPS at this
     *   point) 
     */
    wordIsUnknown(actor, txt)
    {
        "<.parser>Spelet förstår inte det kommandot.<./parser> ";
    }

    /* the actor refuses the command because it's busy with something else */
    refuseCommandBusy(targetActor, issuingActor)
    {
        "\^<<targetActor.nameIs>> upptagen. ";
    }

    /* cannot speak to multiple actors */
    cannotAddressMultiple(actor)
    {
        "<.parser>\^<<actor.theName>> <<actor.verbCannot>> addressera multipla
        människor åt gången.<./parser> ";
    }

    /* 
     *   Remaining actions on the command line were aborted due to the
     *   failure of the current action.  This is just a hook for the game's
     *   use, if it wants to provide an explanation; by default, we do
     *   nothing.  Note that games that override this will probably want to
     *   use a flag property so that they only show this message once -
     *   it's really only desirable to explain the the mechanism, not to
     *   flag it every time it's used.  
     */
    explainCancelCommandLine()
    {
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   Non-Player Character (NPC) messages - parser-mediated format.  These
 *   versions of the NPC messages report errors through the
 *   parser/narrator.
 *   
 *   Note that a separate set of messages can be selected to report
 *   messages in the voice of the NPC - see npcMessagesDirect below.  
 */

/*
 *   Standard Non-Player Character (NPC) messages.  These messages are
 *   generated when the player issues a command to a specific non-player
 *   character. 
 */
npcMessages: playerMessages
    /* the target cannot hear a command we gave */
    commandNotHeard(actor)
    {
        "\^<<actor.nameDoes>> svara{r|de} ej. ";
    }

    /* no match for a noun phrase */
    noMatchCannotSee(actor, txt) { 
        "\^<<actor.nameSees>> inget liknande <<txt>>. ";  // TODO: genitiv
    }
    noMatchNotAware(actor, txt)
        { "\^<<actor.nameIs>> inte medveten om något liknande <<txt>>. "; }

    /* no match for 'all' */
    noMatchForAll(actor)
    {
        "<.parser>\^<<actor.nameDoes>> {ser} inget passande.<./parser> ";
    }

    /* nothing left for 'all' after removing 'except' items */
    noMatchForAllBut(actor)
    {
        "<.parser>\^<<actor.nameSees>> ingenting annat.<./parser> ";
    }

    /* insufficient quantity to meet a command request ('take five books') */
    insufficientQuantity(actor, txt, matchList, requiredNum)
    {
            "<.parser>\^<<actor.nameDoes>> ser inte särskilt många <<txt>>.<./parser> ";
    }

    /*
     *   we found an ambiguous noun phrase, but we were unable to perform
     *   interactive disambiguation 
     */
    ambiguousNounPhrase(actor, originalText, matchList, fullMatchList)
    {
        "<.parser>\^<<actor.nameDoes>> vet inte [TODO: vilket/vilken/vilka] <<originalText>> du mena<<tSel('r', 'de')>>.<./parser> ";
    }

    /*
     *   Missing object query and error message templates 
     */
    askMissingObject(actor, action, which)
    {
        //reportQuestion('<.parser>\^' + action.whatObj(which)
        //               + ' do you want ' + actor.theNameObj + ' to '
        //               + action.getQuestionInf(which) + '?<./parser> ');
        reportQuestion('<.parser>\^<<action.whatObj(which)>> vill du att '
                       + actor.theNameObj + ' ska '
                       + action.getQuestionInf(which) + '?<./parser> '
                       );
    }
    missingObject(actor, action, which)
    {
        "<.parser>Du behöver vara mer specifik om <<action.whatObj(which)>> du vill att <<actor.theNameObj>> ska <<action.getQuestionInf(which)>>.<./parser> ";
    }

    /* missing literal phrase query and error message templates */
    missingLiteral(actor, action, which)
    {
        "<.parser>Du behöver vara mer specifik om <<action.whatObj(which)>> du vill att <<actor.theNameObj>> ska <<action.getQuestionInf(which)>>. Till exempel: <<actor.theName>>, <<action.getQuestionInf(which)>> <q>någonting</q>.<./parser> ";
    }
;

/*
 *   Deferred NPC messages.  We use this to report deferred messages from
 *   an NPC to the player.  A message is deferred when a parsing error
 *   occurs, but the NPC can't talk to the player because there's no sense
 *   path to the player.  When this happens, the NPC queues the message
 *   for eventual delivery; when a sense path appears later that lets the
 *   NPC talk to the player, we deliver the message through this object.
 *   Since these messages describe conditions that occurred in the past,
 *   we use the past tense to phrase the messages.
 *   
 *   This default implementation simply doesn't report deferred errors at
 *   all.  The default message voice is the parser/narrator character, and
 *   there is simply no good way for the parser/narrator to say that a
 *   command failed in the past for a given character: "Bob looks like he
 *   didn't know which box you meant" just doesn't work.  So, we'll simply
 *   not report these errors at all.
 *   
 *   To report messages in the NPC's voice directly, modify the NPC's
 *   Actor object, or the Actor base class, to return
 *   npcDeferredMessagesDirect rather than this object from
 *   getParserMessageObj().  
 */
npcDeferredMessages: object
;

/* ------------------------------------------------------------------------ */
/*
 *   NPC messages, reported directly in the voice of the NPC.  These
 *   messages are not selected by default, but a game can use them instead
 *   of the parser-mediated versions by modifying the actor object's
 *   getParserMessageObj() to return these objects.  
 */

/*
 *   Standard Non-Player Character (NPC) messages.  These messages are
 *   generated when the player issues a command to a specific non-player
 *   character. 
 */
npcMessagesDirect: npcMessages
    /* no match for a noun phrase */
    noMatchCannotSee(actor, txt)
    {
        "\^<<actor.nameVerb('titta')>> runt. <q>Jag ser inte någonting liknande <<txt>>.</q> ";
    }
    noMatchNotAware(actor, txt)
    {
        "<q>Jag känner inte till någonting om <<txt>>,</q> <<actor.nameSays>>. ";
    }

    /* no match for 'all' */
    noMatchForAll(actor)
    {
        "\^<<actor.nameSays>>, <q>Jag ser ingenting lämpligt.</q> ";
    }

    /* nothing left for 'all' after removing 'except' items */
    noMatchForAllBut(actor)
    {
        "\^<<actor.nameSays>>, <q>Jag ser ingenting annat här.</q> ";
    }

    /* 'take zero books' */
    zeroQuantity(actor, txt)
    {
        "\^<<actor.nameSays>>,
        <q>Jag kan inte göra det med noll av någonting.</q> ";
    }

    /* insufficient quantity to meet a command request ('take five books') */
    insufficientQuantity(actor, txt, matchList, requiredNum)
    {
        "\^<<actor.nameSays>>,
        <q>Jag ser inte särskilt många <<txt>> här.</q> ";
    }

    /* a unique object is required, but multiple objects were specified */
    uniqueObjectRequired(actor, txt, matchList)
    {
        "\^<<actor.nameSays>>,
        <q>Jag kan inte använda flera saker så där.</q> ";
    }

    /* a single noun phrase is required, but a noun list was used */
    singleObjectRequired(actor, txt)
    {
        "\^<<actor.nameSays>>,
        <q>Jag kan inte använda flera saker så där.</q> ";
    }

    /* no match for the response to a disambiguation question */
    noMatchDisambig(actor, origPhrase, disambigResponse)
    {
        /* leave the quote open for the re-prompt */
        "\^<<actor.nameSays>>,
        <q>Det var inte ett av alternativen. ";
    }

    /*
     *   The answer to a disambiguation question specifies an invalid
     *   ordinal ("the fourth one" when only three choices were offered).
     *   
     *   'ordinalWord' is the ordinal word entered ('fourth' or the like).
     *   'originalText' is the text of the noun phrase that caused the
     *   disambiguation question to be asked in the first place.  
     */
    disambigOrdinalOutOfRange(actor, ordinalWord, originalText)
    {
        /* leave the quote open for the re-prompt */
        "\^<<actor.nameSays>>,
        <q>Det fanns inte särskilt många alternativ. ";
    }

    /*
     *   Ask the canonical disambiguation question: "Which x do you
     *   mean...?".  'matchList' is the list of ambiguous objects with any
     *   redundant equivalents removed, and 'fullMatchList' is the full
     *   list, including redundant equivalents that were removed from
     *   'matchList'.  
     *   
     *   To prevent interactive disambiguation, do this:
     *   
     *   throw new ParseFailureException(&ambiguousNounPhrase,
     *.  originalText, matchList, fullMatchList); 
     */
    askDisambig(actor, originalText, matchList, fullMatchList,
                requiredNum, askingAgain, dist)
    {
        /* mark this as a question report */
        reportQuestion('');

        /* the question depends on the number needed */
        if (requiredNum == 1)
        {
            /* one required - ask with the original text */
            if (!askingAgain)
                "\^<<actor.nameVerb('fråga')>>, <q>";
            

            "<<isNeuter?'Vilket':'Vilken'>> <<originalText>> menar du, <<
            askDisambigList(matchList, fullMatchList, nil, dist)>>?</q> ";
        }
        else
        {
            /*
             *   more than one required - we can't guess at the plural
             *   given the original text, so just use the number 
             */
            if (!askingAgain)
                //"\^<<actor.nameVerb('ask')>>, <q>";
                "\^<<actor.nameVerb('fråga')>>, <q>";
            
            "Vilka <<spellInt(requiredNum)>> (av <<
            askDisambigList(matchList, fullMatchList, true, dist)>>)
            menar du?</q> ";
        }
    }

    /*
     *   we found an ambiguous noun phrase, but we were unable to perform
     *   interactive disambiguation 
     */
    ambiguousNounPhrase(actor, originalText, matchList, fullMatchList)
    {
        "\^<<actor.nameSays>>,
        <q>Jag vet inte vilken <<originalText>> du menar.</q> ";
    }

    /*
     *   Missing object query and error message templates 
     */
    askMissingObject(actor, action, which)
    {
        reportQuestion('\^' + actor.nameSays
                       + ', <q>\^' + action.whatObj(which)
                       + ' vill du att jag ska '
                       + action.getQuestionInf(which) + '?</q> ');
    }
    missingObject(actor, action, which)
    {
        "\^<<actor.nameSays>>,
        <q>Jag vet inte <<action.whatObj(which)>>
        du vill att jag ska <<action.getQuestionInf(which)>>.</q> ";
    }
    missingLiteral(actor, action, which)
    {
        /* use the same message we use for a missing ordinary object */
        missingObject(actor, action, which);
    }

    /* tell the user they entered a word we don't know */
    askUnknownWord(actor, txt)
    {
        "\^<<actor.nameSays>>,
        <q>Jag förstår inte ordet <q><<txt>></q>.</q> ";
    }

    /* tell the user they entered a word we don't know */
    wordIsUnknown(actor, txt)
    {
        "\^<<actor.nameSays>>,
        <q>Du använde ett ord jag inte känner till.</q> ";
    }
;

/*
 *   Deferred NPC messages.  We use this to report deferred messages from
 *   an NPC to the player.  A message is deferred when a parsing error
 *   occurs, but the NPC can't talk to the player because there's no sense
 *   path to the player.  When this happens, the NPC queues the message
 *   for eventual delivery; when a sense path appears later that lets the
 *   NPC talk to the player, we deliver the message through this object.
 *   Since these messages describe conditions that occurred in the past,
 *   we use the past tense to phrase the messages.
 *   
 *   Some messages will never be deferred:
 *   
 *   commandNotHeard - if a command is not heard, it will never enter an
 *   actor's command queue; the error is given immediately in response to
 *   the command entry.
 *   
 *   refuseCommandBusy - same as commandNotHeard
 *   
 *   noMatchDisambig - interactive disambiguation will not happen in a
 *   deferred response situation, so it is impossible to have an
 *   interactive disambiguation failure.  
 *   
 *   disambigOrdinalOutOfRange - for the same reason noMatchDisambig can't
 *   be deferred.
 *   
 *   askDisambig - if we couldn't display a message, we definitely
 *   couldn't perform interactive disambiguation.
 *   
 *   askMissingObject - for the same reason that askDisambig can't be
 *   deferred
 *   
 *   askUnknownWord - for the same reason that askDisambig can't be
 *   deferred.  
 */
npcDeferredMessagesDirect: npcDeferredMessages
    commandNotUnderstood(actor)
    {
        "\^<<actor.nameSays>>,
        <q>Jag förstod inte vad du menade .</q> ";
    }

    /* no match for a noun phrase */
    noMatchCannotSee(actor, txt)
    {
        "\^<<actor.nameSays>>, <q>Jag såg inget liknande <<txt>>.</q> ";
    }
    noMatchNotAware(actor, txt)
    {
        "\^<<actor.nameSays>>, <q>Jag märkte inte av <<txt>>.</q> ";
    }

    /* no match for 'all' */
    noMatchForAll(actor)
    {
        "\^<<actor.nameSays>>, <q>Jag såg ingenting passande.</q> ";
    }

    /* nothing left for 'all' after removing 'except' items */
    noMatchForAllBut(actor)
    {
        "\^<<actor.nameSays>>,
        <q>Jag förstod inte vad du menade.</q> ";
    }

    /* empty noun phrase ('take the') */
    emptyNounPhrase(actor)
    {
        "\^<<actor.nameSays>>,
        <q>Du utelämnade några ord.</q> ";
    }

    /* 'take zero books' */
    zeroQuantity(actor, txt)
    {
        "\^<<actor.nameSays>>,
        <q>Jag förstod inte vad du menade.</q> ";
    }

    /* insufficient quantity to meet a command request ('take five books') */
    insufficientQuantity(actor, txt, matchList, requiredNum)
    {
        "\^<<actor.nameSays>>,
        <q>Jag såg inte tillräckligt <<txt>>.</q> ";
    }

    /* a unique object is required, but multiple objects were specified */
    uniqueObjectRequired(actor, txt, matchList)
    {
        "\^<<actor.nameSays>>,
        <q>Jag förstod inte vad du menade.</q> ";
    }

    /* a unique object is required, but multiple objects were specified */
    singleObjectRequired(actor, txt)
    {
        "\^<<actor.nameSays>>,
        <q>Jag förstod inte vad du menade.</q> ";
    }

    /*
     *   we found an ambiguous noun phrase, but we were unable to perform
     *   interactive disambiguation 
     */
    ambiguousNounPhrase(actor, originalText, matchList, fullMatchList)
    {
        "\^<<actor.nameSays>>,
        <q>[TODO:2492]Jag kunde inte avgöra vilket/vilken/vilka <<originalText>> du menade.</q> ";
    }

    /* an object phrase was missing */
    askMissingObject(actor, action, which)
    {
        reportQuestion('\^<<actor.nameSays>>, <q>Jag {vet|visste} inte '
                       + action.whatObj(which) + ' du {vill|ville} att jag {ska|skulle} '
                       + action.getQuestionInf(which) + '.</q> ');
    }

    /* tell the user they entered a word we don't know */
    wordIsUnknown(actor, txt)
    {
        "\^<<actor.nameSays>>,
        <q>Du använde ett ord jag inte kan.</q> ";
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   Verb messages for standard library verb implementations for actions
 *   performed by the player character.  These return strings suitable for
 *   use in VerifyResult objects as well as for action reports
 *   (defaultReport, mainReport, and so on).
 *   
 *   Most of these messages are generic enough to be used for player and
 *   non-player character alike.  However, some of the messages either are
 *   too terse (such as the default reports) or are phrased awkwardly for
 *   NPC use, so the NPC verb messages override those.  
 */
playerActionMessages: MessageHelper
    /*
     *   generic "can't do that" message - this is used when verification
     *   fails because an object doesn't define the action ("doXxx")
     *   method for the verb 
     */
    cannotDoThatMsg = '{Du/han} {kan} inte göra det. '

    /* must be holding something before a command */
    mustBeHoldingMsg(obj)
    {
        gMessageParams(obj);
        return '{Du/han} {behöver|behövde} hålla i {det obj/honom} för att göra det. ';
    }

    /* it's too dark to do that */
    tooDarkMsg = 'Det {är} för mörkt för att göra det. '

    /* object must be visible */
    mustBeVisibleMsg(obj)
    {
        gMessageParams(obj);
        return '{Du/han} {kan} inte se {det obj/honom}. ';
    }

    /* object can be heard but not seen */
    heardButNotSeenMsg(obj)
    {
        gMessageParams(obj);
        return '{Du actor/han} {kan} höra {en obj/honom}, men {det actor/han}
                 {kan} inte se {det obj/honom}. ';
    }

    /* object can be smelled but not seen */
    smelledButNotSeenMsg(obj)
    {
        gMessageParams(obj);
        return '{Du actor/han} {kan} känna lukten av {en obj/honom}, men {det actor/han}
                {kan} inte se {det obj/honom}. ';
    }

    /* cannot hear object */
    cannotHearMsg(obj)
    {
        gMessageParams(obj);
        return '{Du/han} {kan} inte höra {det obj/honom}. ';
    }

    /* cannot smell object */
    cannotSmellMsg(obj)
    {
        gMessageParams(obj);
        return '{Du/han} {kan} inte känna lukten av {det obj/honom}. ';
    }

    /* cannot taste object */
    cannotTasteMsg(obj)
    {
        gMessageParams(obj);
        return '{Du/han} {kan} inte smaka {det obj/honom}. ';
    }

    /* must remove an article of clothing before a command */
    cannotBeWearingMsg(obj)
    {
        gMessageParams(obj);
        return '{Du actor/han} måste ta av {det obj/honom}
                innan {det actor/han} {kan} göra det. ';
    }

    /* all contents must be removed from object before doing that */
    mustBeEmptyMsg(obj)
    {
        gMessageParams(obj);
        return '{Du/han} {behöver|behövde} ta ut allting från {det obj/honom}
                före {det actor/han} {kan} göra det. ';
    }

    /* object must be opened before doing that */
    mustBeOpenMsg(obj)
    {
        gMessageParams(obj);
        return '{Du/han} {behöver|behövde} öppna {det obj/honom}
                före {det actor/han} {kan} göra det. ';
    }

    /* object must be closed before doing that */
    mustBeClosedMsg(obj)
    {
        gMessageParams(obj);
        return '{Du/han} {behöver|behövde} stänga {det obj/honom}
               före {det actor/han} {kan} göra det. ';
    }

    /* object must be unlocked before doing that */
    mustBeUnlockedMsg(obj)
    {
        gMessageParams(obj);
        return '{Du/han} {behöver|behövde} låsa upp {det obj/honom}
                före {det actor/han} {kan} göra det. ';
    }

    /* no key is needed to lock or unlock this object */
    noKeyNeededMsg = '{Den dobj/ref} verka{r|de} inte behöva en nyckel. '

    /* actor must be standing before doing that */
    mustBeStandingMsg = '{Du/han} {behöver|behövde} stå upp före {det actor/han} {kan} göra det. '

    /* must be sitting on/in chair */
    mustSitOnMsg(obj)
    {
        gMessageParams(obj);
        return '{Du/han} {behöver|behövde} sitta {i obj} först. ';
    }

    /* must be lying on/in object */
    mustLieOnMsg(obj)
    {
        gMessageParams(obj);
        return '{Du/han} {behöver|behövde} ligga {i obj} först. ';
    }

    /* must get on/in object */
    // TODO: undersök
    mustGetOnMsg(obj)
    {
        gMessageParams(obj);
        //return '{You/he} {must} get {i obj} first. ';
        return '{Du/han} {behöver|behövde} komma upp {i obj} först. '; 
    }

    /* object must be in loc before doing that */
    // TODO: undersök
    mustBeInMsg(obj, loc)
    {
        gMessageParams(obj, loc);
        return '{Den obj/ref} {behöver|behövde} vara {i loc} före {du/han} {kan} göra det. ';
    }

    /* actor must be holding the object before we can do that */
    mustBeCarryingMsg(obj, actor)
    {
        gMessageParams(obj, actor);
        return '{Den actor/ref} {behöver|behövde} hålla {det obj/honom} före {det actor/han} {kan} göra det. ';
    }

    /* generic "that's not important" message for decorations */
    // TODO: undersök
    decorationNotImportantMsg(obj)
    {
        gMessageParams(obj);
        local ending = obj.isPlural? 'a' : (obj.isNeuter?'t':'');
        return '{Den obj/ref} är oviktig<<ending>>. ';
    }

    /* generic "you don't see that" message for "unthings" */
    unthingNotHereMsg(obj)
    {
        gMessageParams(obj);
        return '{Du/han} ser inte {det obj/honom} {här}. ';
    }

    /* generic "that's too far away" message for Distant items */
    tooDistantMsg(obj)
    {
        gMessageParams(obj);
        return '{Den obj/ref} {är} för långt borta. ';
    }

    /* generic "no can do" message for intangibles */
    notWithIntangibleMsg(obj)
    {
        gMessageParams(obj);
        return '{Du/han} {kan} inte göra det med {en obj/honom}. ';
    }

    /* generic failure message for varporous objects */
    notWithVaporousMsg(obj)
    {
        gMessageParams(obj);
        return '{Du/han} {kan} inte göra det med {en obj/honom}. ';
    }

    /* look in/look under/look through/look behind/search vaporous */
    lookInVaporousMsg(obj)
    {
        gMessageParams(obj);
        return '{Du/han} {ser} bara {det obj/honom}. ';
    }

    /*
     *   cannot reach (i.e., touch) an object that is to be manipulated in
     *   a command - this is a generic message used when we cannot
     *   identify the specific reason that the object is in scope but
     *   cannot be touched 
     */
    cannotReachObjectMsg(obj)
    {
        gMessageParams(obj);
        return '{Du/han} {kan} inte nå {det obj/honom}. ';
    }

    /* cannot reach an object through an obstructor */
    cannotReachThroughMsg(obj, loc)
    {
        gMessageParams(obj, loc);
        return '{Du/han} {kan} inte nå {det obj/honom} genom ' + '{den loc/honom}. ';
    }

    /* generic long description of a Thing */
    thingDescMsg(obj)
    {
        gMessageParams(obj);
        return '{Du/han} {ser} inget ovanligt med ' + '{det obj/honom}. ';
    }

    /* generic LISTEN TO description of a Thing */
    thingSoundDescMsg(obj)
        { return '{Du/han} hör{|de} inget oväntat. '; }

    /* generic "smell" description of a Thing */
    thingSmellDescMsg(obj)
        { return '{Du/han} kän{ner|de} ingen oväntad lukt. '; }

    /* default description of a non-player character */
    npcDescMsg(npc)
    {
        gMessageParams(npc);
        return '{Du/han} {ser} inget ovanligt med ' + '{den npc/honom}. ';
    }

    /* generic messages for looking prepositionally */
    nothingInsideMsg =
        'Det {är} inget ovanligt i {den dobj/honom}. '
    nothingUnderMsg =
        '{Du/han} {ser} inget ovanligt under {den dobj/honom}. '
    nothingBehindMsg =
        '{Du/han} {ser} inget ovanligt bakom {den dobj/honom}. '
    nothingThroughMsg =
        '{Du/han} {ser} ingenting genom {den dobj/honom}. '

    /* this is an object we can't look behind/through */
    cannotLookBehindMsg = '{Du/han} {kan} inte se bakom {den dobj/honom}. '
    cannotLookUnderMsg = '{Du/han} {kan} inte se under {den dobj/honom}. '
    cannotLookThroughMsg = '{Du/han} {kan} inte se genom {den dobj/honom}. '

    /* looking through an open passage */
    nothingThroughPassageMsg = '{Du/han} {kan} inte se mycket genom
        {den dobj/honom} {h|d}ärifrån. '

    /* there's nothing on the other side of a door we just opened */
    nothingBeyondDoorMsg = '{Du/han} öppna{r|de} {den dobj/honom} och {finner|fann} ingenting
        ovanligt. '

    /* there's nothing here with a specific odor */
    nothingToSmellMsg = '{Du/han} kän{ner|de} ingen oväntad lukt. '

    /* there's nothing here with a specific noise */
    nothingToHearMsg = '{Du/han} {hör|hörde} inget oväntat. '

    /* a sound appears to be coming from a source */
    noiseSourceMsg(src)
    {
        return '{Den dobj/ref} verka{r|de} att komma från ' + src.theNameObj + '. ';
    }

    /* an odor appears to be coming from a source */
    odorSourceMsg(src)
    {
        return '{Den dobj/ref} verka{r|de} att komma från '+ src.theNameObj + '. ';
    }

    /* an item is not wearable */
    notWearableMsg =
        '{Det dobj/han} där {är} inte någonting som {du/han} {kan} klä på {sig}. '

    /* doffing something that isn't wearable */
    notDoffableMsg =
        '{Det dobj/han} där {är} inte någonting som {du/han} {kan} ta av {sig}. '


    /* already wearing item */
    alreadyWearingMsg = '{Du/han} {bär|bar} redan {den dobj/honom}. '


    //notWearingMsg = '{You\'re} not wearing {that dobj/him}. '

    /* not wearing (item being doffed) */
    notWearingMsg = '{Du/han} {har|hade} inte på {sig} {det dobj/honom}. '

    /* default response to 'wear obj' */
    okayWearMsg = 'Okej, {du/han} {klär|klädde} på {dig} {den dobj/honom}. '

    /* default response to 'doff obj' */
    okayDoffMsg = 'Okej, {du/han} {tar|tog} av {dig} {den dobj/honom}. '

    /* default response to open/close */
    okayOpenMsg = shortTMsg(
        'Öppn{ad/at/na}. ', '{Du/han} öppna{r|de} {den dobj/honom}. ')
    okayCloseMsg = shortTMsg(
        'Stäng{d/t/da}. ', '{Du/han} stäng{er|de} {den dobj/honom}. ')

    /* default response to lock/unlock */
    okayLockMsg = shortTMsg(
        'Låst<<gDobj.isPlural?'a':''>>. ', '{Du/han} lås{e/te} {den dobj/honom}. ')
    okayUnlockMsg = shortTMsg(
        'Upplåst<<gDobj.isPlural?'a':''>>. ', '{Du/han} lås{er/te} upp {den dobj/honom}. ')

    /* cannot dig here */
    cannotDigMsg = '{Du/han} {har|hade} ingen anledning att gräva i {det dobj/honom} där. '

    /* not a digging implement */
    cannotDigWithMsg =
        '{Du/han} {ser} inget sätt att använda {det iobj/honom} så som en spade. '

    /* taking something already being held */
    alreadyHoldingMsg = '{Du/han} {håller|höll} redan {den dobj/honom}. '

    /* actor taking self ("take me") */
    takingSelfMsg = '{Du/han} {kan} inte plocka upp {digsjälv}. '

    /* dropping an object not being carried */
    notCarryingMsg = '{Du/han} bär inte på {det dobj/honom}. '

    /* actor dropping self */
    droppingSelfMsg = '{Du/han} {kan} inte släppa {digsjälv}. '

    /* actor putting self in something */
    puttingSelfMsg = '{Du/han} {kan} inte göra det med {digsjälv}. '

    /* actor throwing self */
    throwingSelfMsg = '{Du/han} {kan} inte kasta {digsjälv}. '

    /* we can't put the dobj in the iobj because it's already there */
    alreadyPutInMsg = '{Den dobj/ref} {är} redan i {den iobj/honom}. '

    /* we can't put the dobj on the iobj because it's already there */
    alreadyPutOnMsg = '{Den dobj/ref} {är} redan på {den iobj/honom}. '

    /* we can't put the dobj under the iobj because it's already there */
    alreadyPutUnderMsg = '{Den dobj/ref} {är} redan under {den iobj/honom}. '

    /* we can't put the dobj behind the iobj because it's already there */
    alreadyPutBehindMsg = '{Den dobj/ref} {är} redan bakom {den iobj/honom}. '

    /*
     *   trying to move a Fixture to a new container by some means (take,
     *   drop, put in, put on, etc) 
     */
    cannotMoveFixtureMsg = '{Den dobj/ref} {kan} inte flyttas. '

    /* trying to take a Fixture */
    cannotTakeFixtureMsg = '{Du/han} {kan} inte ta {det dobj/honom}. '

    /* trying to put a Fixture in something */
    cannotPutFixtureMsg = '{Du/han} {kan} inte stoppa {den dobj/honom} någonstans. '

    /* trying to take/move/put an Immovable object */
    cannotTakeImmovableMsg = '{Du/han} {kan} inte ta {det dobj/honom}. '
    cannotMoveImmovableMsg = '{Den dobj/ref} {kan} inte flyttas. '
    cannotPutImmovableMsg = '{Du/han} {kan} inte stoppa {den dobj/honom} någonstans. '

    /* trying to take/move/put a Heavy object */
    cannotTakeHeavyMsg = '{Det dobj/han} {är} för tung{a/t}. '
    cannotMoveHeavyMsg = '{Det dobj/han} {är} för tung{a/t}. '
    cannotPutHeavyMsg = '{Det dobj/han} {är} för tung{a/t}. '

    /* trying to move a component object */
    cannotMoveComponentMsg(loc)
    {
        return '{Den dobj/ref} {är} en del av ' + loc.theNameObj + '. ';
    }

    /* trying to take a component object */
    cannotTakeComponentMsg(loc)
    {
        // TODO: 
        return '{Du/han} {kan} inte ta {det/honom dobj}; '
            + '{det dobj} {är} del av ' + loc.theNameObj + '. ';
    }

    /* trying to put a component in something */
    cannotPutComponentMsg(loc)
    {
        return '{Du/han} {kan} inte lägga {det/honom dobj} någonstans; '
            + '{det dobj} {är} en del av ' + loc.theNameObj + '. ';
    }

    /* specialized Immovable messages for TravelPushables */
    cannotTakePushableMsg = '{Du/han} {kan} inte ta {det/honom dobj}, men
        det kan vara möjligt att knuffa {det dobj/honom} någonstans. '

    cannotMovePushableMsg = 'Det skulle inte {|ha} åstadkomm{a|it}
        någonting att flytta runt {den dobj/honom} riktningslöst, men 
        det kanske {är} möjligt att flytta {det dobj/honom} i en specifik riktning. '

    cannotPutPushableMsg = '{Du/han} {kan} inte stoppa {det/honom dobj} någonstans,
        men det {kan} vara möjligt att knuffa {det dobj/honom} någonstans. '

    /* can't take something while occupying it */
    cannotTakeLocationMsg = '{Du/han} {kan} inte plocka upp {det/honom dobj}
        medan {du} uppehåller {det/honom dobj}. '

    /* can't REMOVE something that's being held */
    cannotRemoveHeldMsg = 'Det f{i|a}nns ingenting att ta bort {den dobj/honom} ifrån. '

    /* default 'take' response */
    okayTakeMsg = shortTMsg(
        'Tag<<gDobj.isPlural? 'na' : (gDobj.isNeuter?'et':'en')>>. ', '{Du/han} {tar|tog} {den dobj/honom}. ')

    /* default 'drop' response */
    okayDropMsg = shortTMsg(
        'Släppt<<gDobj.isPlural? 'a':''>>. ', '{Du/han} släpp{te/er} {den dobj/honom}. ')

    /* dropping an object */
    droppingObjMsg(dropobj)
    {
        gMessageParams(dropobj);
        return '{Du/han} släpp{er/te} {den dropobj/honom}. ';
    }

    /* default receiveDrop suffix for floorless rooms */
    floorlessDropMsg(dropobj)
    {
        gMessageParams(dropobj);
        //return '{It dropobj/he}  {faller|föll} out of sight below. ';
        return '{Det dropobj/han} {faller|föll} utom synhåll nedanför. ';
    }

    /* default successful 'put in' response */
    okayPutInMsg = shortTIMsg(
        'Gjort. ', '{Du/han} {sätter} {den dobj/honom} i {den iobj/honom}. ')

    /* default successful 'put on' response */
    okayPutOnMsg = shortTIMsg(
        'Gjort. ', '{Du/han} {sätter} {den dobj/honom} på {den iobj/honom}. ')

    /* default successful 'put under' response */
    okayPutUnderMsg = shortTIMsg(
        'Gjort. ', '{Du/han} {sätter} {den dobj/honom} under {den iobj/honom}. ')

    /* default successful 'put behind' response */
    okayPutBehindMsg = shortTIMsg(
        'Gjort. ', '{Du/han} {sätter} {den dobj/honom} bakom {den iobj/honom}. ')

    /* try to take/move/put/taste an untakeable actor */
    cannotTakeActorMsg = '{Den dobj/ref} låter inte {du/honom} göra det. '
    cannotMoveActorMsg = '{Den dobj/ref} låter inte {du/honom} göra det. '
    cannotPutActorMsg = '{Den dobj/ref} låter inte {du/honom} göra det. '
    cannotTasteActorMsg = '{Den dobj/ref} låter inte {du/honom} göra det. '

    /* trying to take/move/put/taste a person */
    cannotTakePersonMsg =
        '{Den dobj/ref} skulle antagligen inte {|ha} uppskatta{|t} det. '
    cannotMovePersonMsg =
        '{Den dobj/ref} skulle antagligen inte {|ha} uppskatta{|t} det. '
    cannotPutPersonMsg =
        '{Den dobj/ref} skulle antagligen inte {|ha} uppskatta{|t} det. '
    cannotTastePersonMsg =
        '{Den dobj/ref} skulle antagligen inte {|ha} uppskatta{|t} det. '

    /* cannot move obj through obstructor */
    cannotMoveThroughMsg(obj, obs)
    {
        gMessageParams(obj, obs);
        return '{Du/han} {kan} inte förflytta {det obj/honom} genom ' + '{den obs/honom}. ';
    }

    /* cannot move obj in our out of container cont */
    cannotMoveThroughContainerMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{Du/han} {kan} inte förflytta {det obj/honom} genom ' + '{den cont/honom}. ';
    }

    /* cannot move obj because cont is closed */
    cannotMoveThroughClosedMsg(obj, cont)
    {
        gMessageParams(cont);
        return '{Du/han} {kan} inte göra det då {den cont/ref} {är} ' + 'stäng{d/t/da iobj}. ';
    }

    /* cannot fit obj into cont through cont's opening */
    cannotFitIntoOpeningMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{Du/han} {kan} inte göra det då {den obj/ref} {är} för stor{a/t obj} för att sätta in i {den cont/honom}. ';
    }

    /* cannot fit obj out of cont through cont's opening */
    cannotFitOutOfOpeningMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{Du/han} {kan} inte göra det då {den obj/ref} {är} för stor{a/t obj} för att ta ut ur {den cont/honom}. ';
    }

    /* actor 'obj' cannot reach in our out of container 'cont' */
    cannotTouchThroughContainerMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{Den obj/ref} {kan} inte nå någonting genom ' + '{den cont/honom}. ';
    }

    /* actor 'obj' cannot reach through cont because cont is closed */
    cannotTouchThroughClosedMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{Den obj/ref} {kan} inte göra det då {den cont/ref} {är} stäng{d/t/da cont}. ';
    }

    /* actor cannot fit hand into cont through cont's opening */
    cannotReachIntoOpeningMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{Den obj/ref} {kan} inte få in {din actor} hand i ' + '{den cont/honom}. ';
    }

    /* actor cannot fit hand into cont through cont's opening */
    cannotReachOutOfOpeningMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{Den obj/ref} {kan} inte få in {dess/hennes obj} hand genom {den cont/honom}. ';
    }

    /* the object is too big for the actor to hold */
    tooLargeForActorMsg(obj)
    {
        gMessageParams(obj);
        return '{Den obj/ref} {är} för stor{t/a obj} för {du/honom} att hålla. ';
    }

    /* the actor doesn't have room to hold the object */
    handsTooFullForMsg(obj)
    {
        return '{Mina} händer {är} för fulla för att även hålla ' + obj.theNameObj + '. ';
    }

    /* the object is becoming too big for the actor to hold */
    becomingTooLargeForActorMsg(obj)
    {
        gMessageParams(obj);
        return '{Du/han} {kan} inte göra det då {den obj/ref} skulle{ | ha }{bli|blivit} för stor{a/t} för {du/honom} att hålla. ';
    }

    /* the object is becoming large enough that the actor's hands are full */
    handsBecomingTooFullForMsg(obj)
    {
        gMessageParams(obj);
        return '{Du/han} {kan} inte göra det då {mina} händer skulle{ | ha }{bli|blivit} för fulla för att kunna hålla {det/honom obj}. ';
    }

    /* the object is too heavy (all by itself) for the actor to hold */
    tooHeavyForActorMsg(obj)
    {
        gMessageParams(obj);
        return '{Den obj/ref} {är} för tung{t/a obj} för {dig} att plocka upp. ';
    }

    /*
     *   the object is too heavy (in combination with everything else
     *   being carried) for the actor to pick up 
     */
    totalTooHeavyForMsg(obj)
    {
        gMessageParams(obj);
        return '{Den obj/ref} {är} för tung{t/a obj}; {du/han} behöv{er|de} sätta ner någonting först. ';
    }

    /* object is för stor för container */
    tooLargeForContainerMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{Den obj/ref} {är} för stor för {den cont/honom}. ';
    }

    /* object is too large to fit under object */
    tooLargeForUndersideMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{Den obj/ref} {är} för stor för att stoppa in under {den cont/honom}. ';
    }

    /* object is too large to fit behind object */
    tooLargeForRearMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{Den obj/ref} {är} för stor för att stoppa in bakom {den cont/honom}. ';
    }

    /* container doesn't have room for object */
    containerTooFullMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{den cont/ref} {är} redan för full{t/a cont} för att få plats med {det obj/honom}. ';
    }

    /* surface doesn't have room for object */
    surfaceTooFullMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return 'Det {finns|fanns} inget rum för {det obj/honom} på ' + '{den cont/honom}. ';
    }

    /* underside doesn't have room for object */
    undersideTooFullMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return 'Det {finns|fanns} inget rum för {det obj/honom} under ' + '{den cont/honom}. ';
    }

    /* rear surface/space doesn't have room for object */
    rearTooFullMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return 'Det {finns|fanns} inget rum för {det obj/honom} bakom ' + '{den cont/honom}. ';
    }

    /* the current action would make obj too big for its container */
    becomingTooLargeForContainerMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{Du/han} {kan} inte göra det då det skulle {göra|ha gjort} {det obj/honom} för stor{t/a obj} för {den cont/honom}. ';
    }

    /*
     *   the current action would increase obj's bulk so that container is
     *   too full 
     */
    containerBecomingTooFullMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{Du/han} {kan} inte göra det för att {den obj/ref} skulle inte längre få plats i {den cont/honom}. ';
    }

    /* trying to put an object in a non-container */
    notAContainerMsg = '{Du/han} {kan} inte stoppa någonting i {den iobj/honom}. '

    /* trying to put an object on a non-surface */
    notASurfaceMsg = 'Det {finns|fanns} ingen bra yta på {den iobj/honom}. ' // TODO: genitiv

    /* can't put anything under iobj */
    cannotPutUnderMsg =
        '{Du/han} {kan} inte stoppa någonting under {det iobj/honom}. '

    /* nothing can be put behind the given object */
    cannotPutBehindMsg = '{Du/han} {kan} inte stoppa in någonting bakom {den iobj/honom}. '

    /* trying to put something in itself */
    cannotPutInSelfMsg = '{Du/han} {kan} inte stoppa {den dobj/honom} i {sigsjälv dobj}. '

    /* trying to put something on itself */
    cannotPutOnSelfMsg = '{Du/han} {kan} inte stoppa {den dobj/honom} på {sigsjälv dobj}. '

    /* trying to put something under itself */
    cannotPutUnderSelfMsg = '{Du/han} {kan} inte stoppa {den dobj/honom} under {sigsjälv dobj}. '

    /* trying to put something behind itself */
    cannotPutBehindSelfMsg = '{Du/han} {kan} inte stoppa {den dobj/honom} bakom {sigsjälv dobj}. '

    /* can't put something in/on/etc a restricted container/surface/etc */
    cannotPutInRestrictedMsg =
        '{Du/han} {kan} inte stoppa {det dobj/honom} i {den iobj/honom}. '
    cannotPutOnRestrictedMsg =
        '{Du/han} {kan} inte stoppa {det dobj/honom} på {den iobj/honom}. '
    cannotPutUnderRestrictedMsg =
        '{Du/han} {kan} inte stoppa {det dobj/honom} under {den iobj/honom}. '
    cannotPutBehindRestrictedMsg =
        '{Du/han} {kan} inte stoppa {det dobj/honom} bakom {den iobj/honom}. '

    /* trying to return something to a remove-only dispenser */
    cannotReturnToDispenserMsg =
        '{Du/han} {kan} inte stoppa tillbaka {en dobj/honom} i {den iobj/honom}. '

    /* wrong item type for dispenser */
    cannotPutInDispenserMsg =
        '{Du/han} {kan} inte stoppa {en dobj/honom} i {den iobj/honom}. '

    /* the dobj doesn't fit on this keyring */
    objNotForKeyringMsg = '{Den dobj/ref} passar inte på {den iobj/honom}. '

    /* the dobj isn't on the keyring */
    keyNotOnKeyringMsg = '{Den dobj/ref} {sitter|satt} inte fast i {den iobj/honom}. '

    /* can't detach key (with no iobj specified) because it's not on a ring */
    keyNotDetachableMsg = '{Den dobj/ref} {sitter|satt} inte fast i någonting. '

    /* we took a key and attached it to a keyring */
    takenAndMovedToKeyringMsg(keyring)
    {
        gMessageParams(keyring);
        return '{Du/han} plocka{r|de} upp {den dobj/honom} och fäs{ter|te} {det dobj/honom} i {den keyring/honom}. ';
    }

    /* we attached a key to a keyring automatically */
    movedKeyToKeyringMsg(keyring)
    {
        gMessageParams(keyring);
        return '{Du/han} fäst{er|e} {den dobj/honom} i {den keyring/honom}. ';
    }

    /* we moved several keys to a keyring automatically */
    movedKeysToKeyringMsg(keyring, keys)
    {
        gMessageParams(keyring);
        return '{Du/han} fäst{er|e} {din/hans} lösa nyck' + (keys.length() > 1 ? 'lar' : 'el') + ' i {den keyring/honom}. ';
    }

    /* putting y in x when x is already in y */
    circularlyInMsg(x, y)
    {
        gMessageParams(x, y);
        return '{Du/han} {kan} inte göra det då {den x/ref} {är} i {den y/honom}. ';
    }

    /* putting y in x when x is already on y */
    circularlyOnMsg(x, y)
    {
        gMessageParams(x, y);
        return '{Du/han} {kan} inte göra det då {den x/ref} {är} på {den y/honom}. ';
    }

    /* putting y in x when x is already under y */
    circularlyUnderMsg(x, y)
    {
        gMessageParams(x, y);
        return '{Du/han} {kan} inte göra det då {den x/ref} {är} under {den y/honom}. ';
    }

    /* putting y in x when x is already behind y */
    circularlyBehindMsg(x, y)
    {
        gMessageParams(x, y);
        return '{Du/han} {kan} inte göra det då {den x/ref} {är} bakom {den y/honom}. ';
    }

    /* taking dobj from iobj, but dobj isn't in iobj */
    takeFromNotInMsg = '{Den dobj/ref} {är} inte i {det iobj/honom}. '

    /* taking dobj from surface, but dobj isn't on iobj */
    takeFromNotOnMsg = '{Den dobj/ref} {är} inte på {det iobj/honom}. '

    /* taking dobj from under something, but dobj isn't under iobj */
    takeFromNotUnderMsg = '{Den dobj/ref} {är} inte under {det iobj/honom}. '

    /* taking dobj from behind something, but dobj isn't behind iobj */
    takeFromNotBehindMsg = '{Den dobj/ref} {är} inte bakom {det iobj/honom}. '

    /* taking dobj from an actor, but actor doesn't have iobj */
    takeFromNotInActorMsg = '{Den iobj/ref} {har|hade} inte {det dobj/honom}. '

    /* actor won't let go of a possession */
    willNotLetGoMsg(holder, obj)
    {
        gMessageParams(holder, obj);
        return '{Den holder/ref} låter inte {du/honom} få {det obj/honom}. ';
    }

    /* must say which way to go */
    whereToGoMsg = 'Du behöver ange vilken väg att gå. '

    /* travel attempted in a direction with no exit */
    cannotGoThatWayMsg = '{Du/han} {kan} inte gå ditåt. '

    /* travel attempted in the dark in a direction with no exit */
    cannotGoThatWayInDarkMsg = 'Det {är} för mörkt; {du/han}
        {kan} inte se var {det/han actor} {går|gick}. '

    /* we don't know the way back for a GO BACK */
    cannotGoBackMsg = '{Du/han} {vet|visste} inte hur man återvände{r|} {h|d}ärifrån. '

    /* cannot carry out a command from this location */
    cannotDoFromHereMsg = '{Du/han} {kan} inte göra det {h|d}ärifrån. '

    /* can't travel through a close door */
    cannotGoThroughClosedDoorMsg(door)
    {
        gMessageParams(door);
        return '{Du/han} {kan} inte göra det då {den door/ref} {är} ' + 'stängd. ';
    }

    /* cannot carry out travel while 'dest' is within 'cont' */
    invalidStagingContainerMsg(cont, dest)
    {
        gMessageParams(cont, dest);
        return '{Du/han} {kan} inte göra det medan {den dest/ref} {är} {i cont}. ';
    }

    /* cannot carry out travel while 'cont' (an actor) is holding 'dest' */
    invalidStagingContainerActorMsg(cont, dest)
    {
        gMessageParams(cont, dest);
        return '{Du/han} {kan} inte göra det då {den cont/ref} {håller|höll} i {den dest/honom}. ';
    }
    
    /* can't carry out travel because 'dest' isn't a valid staging location */
    invalidStagingLocationMsg(dest)
    {
        gMessageParams(dest);
        return '{Du/han} {kan} inte gå in {i dest}. ';
    }

    /* destination is too high to enter from here */
    nestedRoomTooHighMsg(obj)
    {
        gMessageParams(obj);
        return '{Den obj/ref} {är} för hög{t/a obj} att nå {h|d}ärifrån. ';
    }

    /* enclosing room is too high to reach by GETTING OUT OF here */
    nestedRoomTooHighToExitMsg(obj)
    {
        // TODO: testa denna
        return 'Det {är} alltför långt fall ner för att kunna göra det {h|d}ärifrån. ';
        //return 'It{&rsquo;s| was} too long a drop to do that från {här}. ';
    }

    /* cannot carry out a command from a nested room */
    cannotDoFromMsg(obj)
    {
        gMessageParams(obj);
        return '{Du/han} {kan} inte göra det från {det obj/honom}. ';
    }

    /* cannot carry out a command from within a vehicle in a nested room */
    vehicleCannotDoFromMsg(obj)
    {
        local loc = obj.location;
        gMessageParams(obj, loc);
        return '{Du/han} {kan} inte göra det medan {den obj/ref} {är} {i loc}. ';
    }

    /* cannot go that way in a vehicle */
    cannotGoThatWayInVehicleMsg(traveler)
    {
        gMessageParams(traveler);
        return '{Du/han} {kan} inte göra det {i traveler}. ';
    }

    /* cannot push an object that way */
    cannotPushObjectThatWayMsg(obj)
    {
        gMessageParams(obj);
        return '{Du/han} {kan} inte knuffa {det obj/honom} i den riktningen.';
    }

    /* cannot push an object to a nested room */
    cannotPushObjectNestedMsg(obj)
    {
        gMessageParams(obj);
        return '{Du/han} {kan} inte knuffa {det obj/honom} dit. ';
    }

    /* cannot enter an exit-only passage */
    cannotEnterExitOnlyMsg(obj)
    {
        gMessageParams(obj);
        return '{Du/han} {kan} inte gå in i {det obj/honom} {h|d}ärifrån. ';
    }

    /* must open door before going that way */
    mustOpenDoorMsg(obj)
    {
        gMessageParams(obj);
        return '{Du/han} {behöver|behövde} öppna {det obj/honom} först. ';
    }

    /* door closes behind actor during travel through door */
    doorClosesBehindMsg(obj)
    {
        gMessageParams(obj);
        //return '<.p>After {du/han} {goes} through {det obj/honom}, {it/he} close{s/d} behind {it actor/him}. ';
        //return '<.p>{den/han obj} stäng{er|de} sig bakom {det actor/honom} efter att {du/han} {går|gick} igenom {det/honom obj}. ';
        return '<.p>efter att {du/han actor} {går|gick} igenom {det/honom obj}, stäng{er|de} sig {den/ref obj} bakom {det actor/honom}. ';

    }

    /* the stairway does not go up/down */
    stairwayNotUpMsg = '{Den dobj/ref} {går|gick} bara ner {h|d}ärifrån. '
    stairwayNotDownMsg = '{Den dobj/ref} {går|gick} bara upp {h|d}ärifrån. '

    /* "wait" */
    timePassesMsg = 'Tiden {går|gick}... '

    /* "hello" with no target actor */
    sayHelloMsg = (addressingNoOneMsg)

    /* "goodbye" with no target actor */
    sayGoodbyeMsg = (addressingNoOneMsg)

    /* "yes"/"no" with no target actor */
    sayYesMsg = (addressingNoOneMsg)
    sayNoMsg = (addressingNoOneMsg)

    /* an internal common handler for sayHelloMsg, sayGoodbyeMsg, etc */
    addressingNoOneMsg
    {
        return '{Du/han} {behöver|behövde} vara mer specifik om ' + gLibMessages.whomPronoun
            + ' {det actor/han} vill{|e} prata med. ';
    }

    /* "yell" */
    okayYellMsg = '{Du/han} {skriker|skrek} så högt {det actor/han} bara {kan}. '

    /* "jump" */
    okayJumpMsg = '{Du/han} hoppa{r|de} och landa{r|de} på samma ställe. '

    /* cannot hoppa over object */
    cannotJumpOverMsg = '{Du/han} {kan} inte hoppa över {det dobj/honom}. '

    /* cannot hoppa off object */
    cannotJumpOffMsg = '{Du/han} {kan} inte hoppa av {det dobj/honom}. '

    /* cannot hoppa off (with no direct object) from here */
    //cannotJumpOffHereMsg = 'There{&rsquo;s| was} nowhere to jump från {här}. '
    cannotJumpOffHereMsg = 'Det f{i|a}nns ingenting att hoppa från {h|d}ärifrån. '

    /* failed to find a topic in a consultable object */
    cannotFindTopicMsg = '{Du/han} verka{r|de} inte kunna hitta det i {den dobj/honom}. '

    /* an actor doesn't accept a command from another actor */
    refuseCommand(targetActor, issuingActor)
    {
        gMessageParams(targetActor, issuingActor);
        return '{Den targetActor/ref} vägra{r|de} {din/hans issuingActor} begäran. ';
    }

    /* cannot talk to an object (because it makes no sense to do so) */
    notAddressableMsg(obj)
    {
        gMessageParams(obj);
        return '{Du/han} {kan} inte prata med {det obj/honom}. ';
    }

    /* actor won't respond to a request or other communicative gesture */
    noResponseFromMsg(other)
    {
        gMessageParams(other);
        return '{Den other/ref} svara{r|de} inte. ';
    }

    /* trying to give something to someone who already has the object */
    giveAlreadyHasMsg = '{Den iobj/ref} {har|hade} redan {det/honom dobj}. '

    /* can't talk to yourself */
    cannotTalkToSelfMsg = 'Att prata med {sigsjälv} {kommer|skulle} inte {|ha} åstadkomm{a|it} någonting. '

    /* can't ask yourself about anything */
    cannotAskSelfMsg = 'Att prata med {sigsjälv} {kommer|skulle} inte {|ha} åstadkomm{a|it} någonting. '

    /* can't ask yourself for anything */
    cannotAskSelfForMsg = 'Att prata med {sigsjälv} {kommer|skulle} inte {|ha} åstadkomm{a|it} någonting. '

    /* can't tell yourself about anything */
    cannotTellSelfMsg = 'Att prata med {sigsjälv} {kommer|skulle} inte {|ha} åstadkomm{a|it} någonting. '

    /* can't give yourself something */
    cannotGiveToSelfMsg = 'Att ge {den dobj/honom} till {sigsjälv} {kommer|skulle} inte {|ha} åstadkomm{a|it} någonting. '
    
    /* can't give something to itself */
    cannotGiveToItselfMsg = 'Att ge {den dobj/honom} till {sigsjälv} {kommer|skulle} inte {|ha} åstadkomm{a|it} någonting. '

    /* can't show yourself something */
    cannotShowToSelfMsg = 'Att visa {den dobj/honom} för {digsjälv} {kommer|skulle} inte {|ha} åstadkomm{a|it} någonting. '

    /* can't show something to itself */
    cannotShowToItselfMsg = 'Att visa {den dobj/honom} för {sigsjälv dobj} {kommer|skulle} inte {|ha} åstadkomm{a|it} någonting. '

    /* can't give/show something to a non-actor */
    cannotGiveToMsg = '{Du/han} {kan} inte ge någonting till {en iobj/han}. '
    cannotShowToMsg = '{Du/han} {kan} inte visa någonting för {en iobj/han}. '

    /* actor isn't interested in something being given/shown */
    notInterestedMsg(actor)
    {
        return '\^' + actor.theName + ' verka{r|de} ointresserad. ';
    }

    /* vague ASK/TELL (for ASK/TELL <actor> <topic> syntax errors) */
    askVagueMsg = '<.parser>Spelet förstår inte det kommandot. 
        Använd istället FRÅGA PERSON OM ÄMNE (eller bara F ÄMNE)<./parser> ' 

    tellVagueMsg = '<.parser>Spelet förstår inte det kommandot.
        Använd istället FRÅGA PERSON OM ÄMNE (eller bara F ÄMNE)<./parser> '

    /* object cannot hear actor */
    objCannotHearActorMsg(obj)
    {
        return '\^' + obj.theName + ' verka{r|de} inte kunna höra {du/honom}. ';
    }

    /* actor cannot see object being shown to actor */
    actorCannotSeeMsg(actor, obj)
    {
        return '\^<<actor.theName>> verkar oförmögen att se ' + obj.theNameObj + '. ';
    }

    /* not a followable object */
    notFollowableMsg = '{Du/han} {kan} inte följa {det dobj/honom}. '

    /* cannot follow yourself */
    cannotFollowSelfMsg = '{Du/han} {kan} inte följa {digsjälv}. '

    /* following an object that's in the same location as the actor */
    followAlreadyHereMsg = '{Den dobj/ref} {är} precis {här}. '

    /*
     *   following an object that we *think* is in our same location (in
     *   other words, we're already in the location where we thought we
     *   last saw the object go), but it's too dark to see if that's
     *   really true 
     */
    followAlreadyHereInDarkMsg = '{Den dobj/ref} {bör|borde} {vara|varit} precis 
        {här}, men {du/han} {kan} inte se {det dobj/honom}. '

    /* trying to follow an object, but don't know where it went from here */
    followUnknownMsg = '{Du/han} {är} inte säker på var {den dobj/ref} {har|hade} gått {h|d}ärifrån. '

    /*
     *   we're trying to follow an actor, but we last saw the actor in the
     *   given other location, so we have to go there to follow 
     */
    cannotFollowFromHereMsg(srcLoc)
    {
        return 'Den senaste platsen {du/han} {såg|hade sett} {den dobj/honom} {är} '
            + srcLoc.getDestName(gActor, gActor.location) + '. ';
    }

    /* acknowledge a 'follow' for a target that was in sight */
    okayFollowInSightMsg(loc)
    {
        return '{Du/han} följ{er|de} {den dobj/honom} '
            + loc.actorIntoName + '. ';
    }

    /* obj is not a weapon */
    notAWeaponMsg = '{Du/han} {kan} inte attackera någonting med {den iobj/honom}. '

    /* no effect attacking obj */
    uselessToAttackMsg = '{Du/han} {kan} inte attackera {det dobj/honom}. '

    /* pushing object has no effect */
    pushNoEffectMsg = 'Att trycka på {den dobj/honom} {har|hade} ingen effekt. '

    /* default 'push button' acknowledgment */
    okayPushButtonMsg = '<q>Klick.</q> '

    /* lever is already in pushed state */
    alreadyPushedMsg =
        '{Den dobj/honom} {är} redan intryckt så långt det {går|gick}. '

    /* default acknowledgment to pushing a lever */
    okayPushLeverMsg = '{Du/han} tryck{er|te} {den dobj/honom} till {dess/hennes dobj} stopp. '

    /* pulling object has no effect */
    pullNoEffectMsg = 'Att dra i {den dobj/honom} ha{r|de} ingen effekt. '

    /* lever is already in pulled state */
    alreadyPulledMsg = '{Den dobj/honom} {är} redan dragen så långt det {går|gick}. '

    /* default acknowledgment to pulling a lever */
    okayPullLeverMsg = '{Du/han} {drar|drog} {den dobj/honom} till {dess/hennes dobj} stopp. '

    /* default acknowledgment to pulling a spring-loaded lever */
    okayPullSpringLeverMsg = '{Du/han} {drar|drog} {den dobj/honom}, som
        fjädra{r|de} tillbaka till {dess/hennes} startposition så snart som 
        {du/han} släpp{er/te} taget om {det dobj/honom}. '

//TODO: fortsätt uppåt

    /* moving object has no effect */
    moveNoEffectMsg = 'Att flytta {den dobj/honom} skulle inte ge någon effekt. '

    /* cannot move object to other object */
    moveToNoEffectMsg = 'Detta skulle inte {|ha} åstadkomm{a|it} någonting. '

    /* cannot push an object through travel */
    cannotPushTravelMsg = 'Detta skulle inte {|ha} åstadkomm{a|it} någonting. '

    /* acknowledge pushing an object through travel */
    okayPushTravelMsg(obj)
    {
        //return '<.p>{Du/han} push{es/ed} ' + obj.theNameObj + ' into the area. ';
        return '<.p>{Du/han} tryck{er/te} in ' + obj.theNameObj + ' i utrymmet. ';
    }

    /* cannot use object as an implement to move something */
    cannotMoveWithMsg =
        '{Du/han} {kan} inte flytta någonting med {den iobj/honom}. '

    /* cannot set object to setting */
    cannotSetToMsg = '{Du/han} {kan} inte ställa {det dobj/honom} till någonting. '

    /* invalid setting for generic Settable */
    setToInvalidMsg = '{Den dobj/ref} {har|hade} ingen sådan inställning. '

    /* default 'set to' acknowledgment */
    okaySetToMsg(val)
        { return 'Ok, {Den dobj/ref} {är} nu satt till ' + val + '. '; }

    /* cannot turn object */
    cannotTurnMsg = '{Du/han} {kan} inte vrida {det dobj/honom}. '

    /* must specify setting to turn object to */
    mustSpecifyTurnToMsg = '{Du/han} behöver vara tydlig med vilken inställning {den actor/ref} vill sätta {det dobj/honom} till. '

    /* cannot turn anything with object */
    cannotTurnWithMsg =
        '{Du/han} {kan} inte vrida någonting med {det iobj/honom}. '

    /* invalid setting for dial */
    turnToInvalidMsg = '{Den dobj/ref} {har|hade} ingen sådan inställning. '

    /* default 'turn to' acknowledgment */
    okayTurnToMsg(val)
        { return 'Ok, {Den dobj/ref} {är} nu satt till ' + val + '. '; }

    /* switch is already on/off */
    alreadySwitchedOnMsg = '{Den dobj/ref} {är} redan på. '
    alreadySwitchedOffMsg = '{Den dobj/ref} {är} redan av. '

    /* default acknowledgment for switching on/off */
    okayTurnOnMsg = 'Okej, {den dobj/ref} {är} nu på. '
    okayTurnOffMsg = 'Okej, {den dobj/ref} {är} nu av. '

    /* flashlight is on but doesn't light up */
    flashlightOnButDarkMsg = '{Du/han} sl{år|og} på {den dobj/honom}, men ingenting verka{r|de} hända. '

    /* default acknowledgment for eating something */
    okayEatMsg = '{Du/han} {äter|åt} {den dobj/honom}. '

    /* object must be burning before doing that */
    mustBeBurningMsg(obj)
    {
        return '{Du/han} behöv{er|de} tända ' + obj.theNameObj + ' före {det actor/han} {kan} göra det. ';
    }

    /* match not lit */
    matchNotLitMsg = '{Den dobj/ref} {är} inte tänd. '

    /* lighting a match */
    okayBurnMatchMsg =
        '{Du/han} {drar|drog} an {den dobj/honom} och tänd{er/e} en liten låga. '

    /* extinguishing a match */
    okayExtinguishMatchMsg = '{Du/han} släck{er/te} {den dobj/honom}, som {försvinner|försvann} i en moln av aska. '

    /* trying to light a candle with no fuel */
    candleOutOfFuelMsg =
        '{Den dobj/ref} {är} för nedbrunn{en/et/na dobj}; {det dobj/han} {kan} inte tändas. '

    /* lighting a candle */
    okayBurnCandleMsg = '{Du/han} tänd{er/e} {den dobj/honom}. '

    /* extinguishing a candle that isn't lit */
    candleNotLitMsg = '{Den dobj/ref} {är} inte tänd. '

    /* extinguishing a candle */
    okayExtinguishCandleMsg = 'Gjort. '

    /* cannot consult object */
    cannotConsultMsg =
        '{Det dobj/han} {är} ingenting {du/han} {kan} konsultera. '

    /* cannot type anything on object */
    cannotTypeOnMsg = '{Du/han} {kan} inte skriva någonting på {det dobj/honom}. '

    /* cannot enter anything on object */
    cannotEnterOnMsg = '{Du/han} {kan} inte knappa in någonting på {det dobj/honom}. '

    /* cannot switch object */
    cannotSwitchMsg = '{Du/han} {kan} inte ändra på {det dobj/honom}. '

    /* cannot flip object */
    cannotFlipMsg = '{Du/han} {kan} inte vända {det dobj/honom}. '

    /* cannot turn object on/off */
    cannotTurnOnMsg =
        '{Det dobj/han} {är} inte någonting som {du/han} {kan} slå på. '
    cannotTurnOffMsg =
        '{Det dobj/han} {är} inte någonting som {du/han} {kan} stänga av. '

    /* cannot light */
    cannotLightMsg = '{Du/han} {kan} inte tända {det dobj/honom}. '

    /* cannot burn */
    cannotBurnMsg = '{Det dobj/han} {är} inte någonting {du/han} {kan} elda. '
    cannotBurnWithMsg =
        '{Du/han} {kan} inte elda någonting med {det iobj/honom}. '

    /* cannot burn this specific direct object with this specific iobj */
    cannotBurnDobjWithMsg = '{Du/han} {kan} inte tända {den dobj/honom}
                          med {den iobj/honom}. '

    /* object is already burning */
    alreadyBurningMsg = '{Den dobj/ref} br{inner|ann} redan. '

    /* cannot extinguish */
    cannotExtinguishMsg = '{Du/han} {kan} inte släcka {det dobj/honom}. '

    /* cannot pour/pour in/pour on */
    cannotPourMsg = '{Det dobj/han} {är} inte någonting {du/han} {kan} hälla. '
    cannotPourIntoMsg =
        '{Du/han} {kan} inte hälla någonting i {det iobj/honom}. '
    cannotPourOntoMsg =
        '{Du/han} {kan} inte hälla någonting på {det iobj/honom}. '

    /* cannot attach object to object */
    cannotAttachMsg =
        '{Du/han} {kan} inte fästa {det dobj/honom} på någonting. '
    cannotAttachToMsg =
        '{Du/han} {kan} inte fästa någonting på {det iobj/honom}. '

    /* cannot attach to self */
    cannotAttachToSelfMsg =
        '{Du/han} {kan} inte fästa {den dobj/honom} på {sigsjälv dobj}. '

    /* cannot attach because we're already attached to the given object */
    alreadyAttachedMsg =
        '{Den dobj/ref} {är} redan fäst med {den iobj/honom}. '

    /*
     *   dobj and/or iobj can be attached to certain things, but not to
     *   each other 
     */
    wrongAttachmentMsg =
        '{Du/han} {kan} inte fästa {det dobj/honom} på {den iobj/honom}. '

    /* dobj and iobj are attached, but they can't be taken apart */
    wrongDetachmentMsg =
        '{Du/han} {kan} inte koppla loss {det dobj/honom} från {den iobj/honom}. '

    /* must detach the object before proceeding */
    mustDetachMsg(obj)
    {
        gMessageParams(obj);
        return '{Du/han} {behöver|behövde} ta loss {det obj/honom} före {det actor/han}
            {kan} göra det. ';
    }

    /* default message for successful Attachable attachment */
    okayAttachToMsg = 'Gjort. '

    /* default message for successful Attachable detachment */
    okayDetachFromMsg = 'Gjort. '

    /* cannot detach object from object */
    cannotDetachMsg = '{Du/han} {kan} inte koppla loss {det dobj/honom}. '
    cannotDetachFromMsg =
        '{Du/han} {kan} inte ta loss någonting från {det iobj/honom}. '

    /* no obvious way to detach a permanent attachment */
    cannotDetachPermanentMsg =
        'Det {finns|fanns} inget uppenbart sätt att ta loss {det dobj/honom}. '

    /* dobj isn't attached to iobj */
    notAttachedToMsg = '{Den dobj/ref} {sitter|satt} inte fast i {det iobj/honom}. '

    /* breaking object would serve no purpose */
    shouldNotBreakMsg =
        //'Breaking {det dobj/honom} would {|have} serve{|d} no purpose. '
        'Att ha sönder {det dobj/honom} skulle inte {|ha} tjäna{|t} något syfte. '

    /* cannot cut that */
    cutNoEffectMsg = '{Den iobj/ref} verka{r|de} inte kunna skära {den dobj/honom}. '

    /* can't use iobj to cut anything */
    cannotCutWithMsg = '{Du/han} {kan} inte skära någonting med {den iobj/honom}. '

    /* cannot climb object */
    cannotClimbMsg = '{Det dobj/han} {är} inte någonting {du/han} {kan} klättra på. '

    /* object is not openable/closable */
    cannotOpenMsg = '{Det dobj/han} {är} inte någonting {du/han} {kan} öppna. '
    cannotCloseMsg =
        '{Det dobj/han} {är} inte någonting {du/han} {kan} stänga. '

    /* already open/closed */
    alreadyOpenMsg = '{Den dobj/ref} {är} redan öppe<<gDobj && gDobj.isNeuter?'t':'n'>>. '
    
    // TODO: Går det att hitta ett bättre sätt?
    alreadyClosedMsg = '{Den dobj/ref} {är} redan stäng<<gDobj && gDobj.isNeuter?'t':'d'>>. '

    /* already locked/unlocked */
    alreadyLockedMsg = '{Den dobj/ref} {är} redan låst. '
    alreadyUnlockedMsg = '{Den dobj/ref} {är} redan olåst. '

    /* cannot look in container because it's closed */
    cannotLookInClosedMsg = '{Den dobj/ref} {är} stängd. '

    /* object is not lockable/unlockable */
    cannotLockMsg =
        '{Det dobj/han} {är} inte någonting {du/han} {kan} låsa. '
    cannotUnlockMsg =
        '{Det dobj/han} {är} inte någonting {du/han} {kan} låsa upp. '

    /* attempting to open a locked object */
    cannotOpenLockedMsg = '{Den dobj/ref} verka{r|de} vara låst. '

    /* object requires a key to unlock */
    unlockRequiresKeyMsg =
        '{Du/han} verka{r|de} behöva en nyckel för att låsa upp {den dobj/honom}. '

    /* object is not a key */
    cannotLockWithMsg =
        '{Den iobj/ref} {ser} inte lämplig ut att kunna låsa {den dobj/honom} med. '
    cannotUnlockWithMsg =
        '{Den iobj/ref} {ser} inte lämplig ut att kunna låsa upp {den dobj/honom} med. '

    /* we don't know how to lock/unlock this */
    unknownHowToLockMsg =
        'Det {är} inte tydligt på vilket sätt {den dobj/honom} {ska|skulle} låsas. '
    unknownHowToUnlockMsg =
        'Det {är} inte tydligt på vilket sätt {den dobj/honom} {ska|skulle} låsas upp. '

    /* the key (iobj) does not fit the lock (dobj) */
    keyDoesNotFitLockMsg = '{Den iobj/ref} passa{r|de} inte låset. '

    /* found key on keyring */
    foundKeyOnKeyringMsg(ring, key)
    {
        /*
        return '{You/he} tr{ies/ied} each key on {the ring/him}, and
            {find[s actor]|found} that {the key/he} fit{s/ted} the lock. ';
        */
        // TODO: undersök hur denna fungerar
        //  {find[s actor]|finner} 
        gMessageParams(ring, key);
        return '{Du/han} försök{er|te} varje nyckel på {den ring/honom}, och upptäck{er|te} att {den key/ref} passa{r|de} låset. ';
    }

    /* failed to find a key on keyring */
    foundNoKeyOnKeyringMsg(ring)
    {
        gMessageParams(ring);
        return '{Du/han} försök{er|te} varje nyckel på {den ring/honom}, men {du} hitta{r|de} inte någon som passa{r|de} låset. ';
    }


    /* not edible/drinkable */
    cannotEatMsg = '{Den dobj/ref} verka{r|de} inte vara ätbar{a/t}. '
    cannotDrinkMsg = '{Den dobj/ref} verka{r|de} inte vara något {du/han} {kan} dricka. '

    /* cannot clean object */
    cannotCleanMsg =
        //'{Du/han} wouldn&rsquo;t {|have} know{|n} how to clean {det dobj/honom}. '
        '{Du/han} skulle inte veta hur {det dobj/honom} skulle rengöras. '
    cannotCleanWithMsg =
        '{Du/han} {kan} inte rengöra någonting med {det iobj/honom}. '

    /* cannot attach key (dobj) to (iobj) */
    cannotAttachKeyToMsg =
        '{Du/han} {kan} inte fästa {den dobj/honom} i {det iobj/honom}. '

    /* actor cannot sleep */
    cannotSleepMsg = '{Du/han} behöv{er|de} inte sova just nu. '

    /* cannot sit/lie/stand/get on/get out of */
    cannotSitOnMsg =
        '{Det dobj/han} {är} inte någonting som {du/han} {kan} sitta på. '
    cannotLieOnMsg =
        '{Det dobj/han} {är} inte någonting som {du/han} {kan} ligga på. '
    cannotStandOnMsg = '{Du/han} {kan} inte stå på {det dobj/honom}. '
    cannotBoardMsg = '{Du/han} {kan} inte kliva ombord på {det dobj/honom}. '
    cannotUnboardMsg = '{Du/han} {kan} inte kliva ut ur {det dobj/honom}. '
    cannotGetOffOfMsg = '{Du/han} {kan} inte kliva av från {det dobj/honom}. '

    /* standing on a PathPassage */
    cannotStandOnPathMsg = 'Om {du/han} vill{|e} följa {den dobj/honom},
        säg bara det. '

    /* cannot sit/lie/stand on something being held */
    cannotEnterHeldMsg =
        '{Du/han} {kan} inte göra det medan {du} {håller|höll} i {den dobj/honom}. '

    /* cannot get out (of current location) */
    cannotGetOutMsg = '{Du/han} {är} inte i någonting som {du/han} {kan} kliva ur från. '

    /* actor is already in a location */
    alreadyInLocMsg = '{Du/han} {är} redan {i dobj}. '

    /* actor is already standing/sitting on/lying on */
    alreadyStandingMsg = '{Du/han} {står|stod} redan. '
    alreadyStandingOnMsg = '{Du/han} {står|stod} redan {på dobj}. '
    alreadySittingMsg = '{Du/han} {sitter|satt} redan ner. '
    alreadySittingOnMsg = '{Du/han} {sitter|satt} redan {på dobj}. '
    alreadyLyingMsg = '{Du/han} {ligger|låg} redan ner. '
    alreadyLyingOnMsg = '{Du/han} {ligger|låg} redan ner {på dobj}. '

    /* getting off something you're not on */
    notOnPlatformMsg = '{Du/han} {är} inte {på dobj}. '

    /* no room to stand/sit/lie på dobj */
    noRoomToStandMsg =
        'Det {finns|fanns} inte rum för {du/honom} att stå {på dobj}. '
    noRoomToSitMsg =
        'Det {finns|fanns} inte rum för {du/honom} att sitta {på dobj}. '
    noRoomToLieMsg =
        'Det {finns|fanns} inte rum för {du/honom} att ligga {på dobj}. '

    /* default report for standing up/sitting down/lying down */
    okayPostureChangeMsg(posture)
        { return 'Ok, {du/han} ' + posture.msgVerbI + '. '; }

    /* default report for standing/sitting/lying in/on something */
    roomOkayPostureChangeMsg(posture, obj)
    {
        gMessageParams(obj);
        return 'Ok, {du/han} <<posture.msgVerbT>>{ nu | }{på obj}. ';
        // ( {är} nu ' + posture.participle + ' {på obj}. )';
    }

    /* default report for getting off of a platform */
    okayNotStandingOnMsg = 'Ok, {du/han} {är} inte längre {på dobj}. '

    /* cannot fasten/unfasten */
    cannotFastenMsg = '{Du/han} {kan} inte fästa {den dobj/honom}. '
    cannotFastenToMsg = '{Du/han} {kan} inte fästa någonting på {den iobj/honom}. '
    cannotUnfastenMsg = '{Du/han} {kan} inte ta loss {den dobj/honom}. '
    cannotUnfastenFromMsg = '{Du/han} {kan} inte ta loss någonting från {den iobj/honom}. '

    /* cannot plug/unplug */
    cannotPlugInMsg = '{Du/han} {ser} inget sätt att koppla in {den dobj/honom}. '
    cannotPlugInToMsg = '{Du/han} {ser} inget sätt att koppla in någonting i {den iobj/honom}. '
    cannotUnplugMsg = '{Du/han} {ser} inget sätt att koppla loss {den dobj/honom}. '
    cannotUnplugFromMsg = '{Du/han} {ser} inget sätt att la loss någonting från {den iobj/honom}. '

    /* cannot screw/unscrew */
    cannotScrewMsg = '{Du/han} {ser} inget sätt att skruva {den dobj/honom}. '
    cannotScrewWithMsg = '{Du/han} {kan} inte skruva något med {den iobj/honom}. '
    cannotUnscrewMsg = '{Du/han} {vet|visste} inget sätt att skruva loss {den dobj/honom}. '
    cannotUnscrewWithMsg = '{Du/han} {kan} inte skruva loss något med {den iobj/honom}. '

    /* cannot enter/go through */
    cannotEnterMsg = '{Det/han dobj} {är} inte någonting {du/han} {kan} gå in i. '
    cannotGoThroughMsg = '{Det/han dobj} {är} inte någonting {du/han} {kan} gå genom. '
        
    /* can't throw something at itself */
    cannotThrowAtSelfMsg =
        '{Du/han} {kan} inte kasta {det dobj/honom} på {sigsjälv}. '

    /* can't throw something at an object inside itself */
    cannotThrowAtContentsMsg = '{Du/han} {behöver|behövde} ta bort {den iobj/honom}
        från {den dobj/honom} före {det actor/han} {kan} göra det. '

    /* can't throw through a sense connector */
    cannotThrowThroughMsg(target, loc)
    {
        gMessageParams(target, loc);
        return '{Du/han} {kan} inte kasta någonting genom {den loc/honom}. ';
    }

    /* shouldn't throw something at the floor */
    shouldNotThrowAtFloorMsg =
        '{Du/han} {bör|borde} bara {lägga|lagt} ner {det dobj/honom} istället. '

    /* THROW <obj> <direction> isn't supported; use THROW AT instead */
    dontThrowDirMsg =
        ('<.parser>Du behöver vara mer specifik om vad ' 
        + (gActor.referralPerson == ThirdPerson? 'du vill att {den actor/honom}' : '{du}')
         + ' ska kasta {den dobj/honom} mot.<./parser> ')

    /* thrown object bounces off target (short report) */
    throwHitMsg(projektilen, target)
    {
        gMessageParams(projektilen, target);
        return '{Den projektilen/ref} träffa{r|de} {den target/ref} utan någon uppenbar effekt. ';
    }

    /* thrown object lands on target */
    throwFallMsg(projektilen, target)
    {
        gMessageParams(projektilen, target);
        return '{Den projektilen/ref} landa{r|de} på {den target/ref}. ';
    }

    /* thrown object bounces off target and falls to destination */
    throwHitFallMsg(projektilen, target, dest)
    {
        gMessageParams(projektilen, target);
        return '{Den projektilen/ref} träffa{r|de} {den target/ref}
            utan någon uppenbar effekt, och {faller|föll} ner '
            + dest.putInName + '. '
            ;
    }

    /* thrown object falls short of distant target (sentence prefix only) */
    throwShortMsg(projektilen, target)
    {
        gMessageParams(projektilen, target);
        return '{Den projektilen/ref} {faller|föll} långtifrån {den target/ref}. ';
    }
        
    /* thrown object falls short of distant target */
    throwFallShortMsg(projektilen, target, dest)
    {
        gMessageParams(projektilen, target);
        return '{Den projektilen/ref} {faller|föll} ' + dest.putInName
            + ' långtifrån {den target/ref}. ';
    }

    /* target catches object */
    throwCatchMsg(obj, target)
    {
        return '\^' + target.theName + ' ' + tSel('fångar', 'fångade') + ' ' + obj.theNameObj + '. ';
    }

    /* we're not a suitable target for THROW TO (because we're not an NPC) */
    cannotThrowToMsg = '{Du/han} {kan} inte kasta någonting till {en iobj/han}. '

    /* target does not want to catch anything */
    willNotCatchMsg(catcher)
    {
        return '\^' + catcher.theName + ' {ser} inte ut som ' + catcher.itNom + ' vill{|e} fånga någonting. ';
    }

    /* cannot kiss something */
    //cannotKissMsg = 'Kissing {den dobj/honom} {has|had} no obvious effect. '
    cannotKissMsg = 'Att kyssa {den dobj/honom} {har|hade} ingen uppenbar effekt. '

    /* person uninterested in being kissed */
    cannotKissActorMsg
        = '{Den dobj/ref} skulle antagligen inte {|ha} uppskatta{|t} det. '

    /* cannot kiss yourself */
    cannotKissSelfMsg = '{Du/han} {kan} inte kyssa {digsjälv}. '

    /* it is now dark at actor's location */
    newlyDarkMsg = 'Det {är} nu kolsvart. '
;

/*
 *   Non-player character verb messages.  By default, we inherit all of
 *   the messages defined for the player character, but we override some
 *   that must be rephrased slightly to make sense for NPC's.
 */
npcActionMessages: playerActionMessages
    /* "wait" */
    timePassesMsg = '{Du/han} vänta{r|de}... '

    /* trying to move a Fixture/Immovable */
    cannotMoveFixtureMsg = '{Du/han} {kan} inte flytta {det dobj/honom}. '
    cannotMoveImmovableMsg = '{Du/han} {kan} inte flytta {den dobj/honom}. '

    /* trying to take/move/put a Heavy object */
    cannotTakeHeavyMsg =
        '{Det dobj/han} {är} för tung{a/t} för {du/honom} att ta. '
    cannotMoveHeavyMsg =
        '{Det dobj/han} {är} för tung{a/t} för {du/honom} att flytta. '
    cannotPutHeavyMsg =
        '{Det dobj/han} {är} för tung{a/t} för {du/honom} att flytta. '

    /* trying to move a component object */
    cannotMoveComponentMsg(loc)
    {
        return '{Du/han} {kan} inte göra det för att {Den dobj/ref} {är} del av ' + loc.theNameObj + '. ';
    }

    /* default successful 'take' response */
    okayTakeMsg = '{Du/han} {tar|tog} {den dobj/honom}. '

    /* default successful 'drop' response */
    okayDropMsg = '{Du/han} {sätter} ner {den dobj/honom}. '

    /* default successful 'put in' response */
    okayPutInMsg = '{Du/han} {sätter} {den dobj/honom} i {den iobj/honom}. '

    /* default successful 'put on' response */
    okayPutOnMsg = '{Du/han} {sätter} {den dobj/honom} på {den iobj/honom}. '

    /* default successful 'put under' response */
    okayPutUnderMsg =
        '{Du/han} {sätter} {den dobj/honom} under {den iobj/honom}. '

    /* default successful 'put behind' response */
    okayPutBehindMsg =
        '{Du/han} {sätter} {den dobj/honom} bakom {den iobj/honom}. '

    /* default succesful response to 'wear obj' */
    okayWearMsg =
        '{Du/han} {klär|klädde} på {sig} {den dobj/honom}. '

    /* default successful response to 'doff obj' */
    okayDoffMsg = '{Du/han} {tar|tog} av {sig} {den dobj/honom}. '

    /* default successful responses to open/close */
    okayOpenMsg = '{Du/han} öppna{r|de} {den dobj/honom}. '
    okayCloseMsg = '{Du/han} stäng{er|de} {den dobj/honom}. '

    /* default successful responses to lock/unlock */
    okayLockMsg = '{Du/han} lås{er|te} {den dobj/honom}. '
    okayUnlockMsg = '{Du/han} lås{er|te} upp {den dobj/honom}. '

    /* push/pull/move with no effect */
    pushNoEffectMsg = '{Du/han} försök{er|te} att knuffa {den dobj/honom}, utan någon '
                      + 'uppenbar effekt. '
    pullNoEffectMsg = '{Du/han} försök{er|te} att dra {den dobj/honom}, utan någon '
                      + 'uppenbar effekt. '
    moveNoEffectMsg = '{Du/han} försök{er|te} att flytta {den dobj/honom}, utan någon '
                      + 'uppenbar effekt. '
    moveToNoEffectMsg = '{Du/han} lämna{r|de} {den dobj/ref} där {den/ref dobj} {är}. '

    whereToGoMsg =
        //'You&rsquo;ll have to say which way {du/han} should {|have} go{|ne}. '
        'Du skulle behöva säga vilken väg {du/han} skulle {|ha} gå{|tt}. '

    /* object is för stor för container */
    tooLargeForContainerMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{Du/han} {kan} inte göra det för att {den obj/ref} {är}
            för stor för {den cont/honom}. ';
    }

    /* object is för stor för underside */
    tooLargeForUndersideMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{Du/han} {kan} inte göra det för att {den obj/ref}
            inte {|skulle} {får|få} plats under {den cont/honom}. ';
    }

    /* object is too large to fit behind something */
    tooLargeForRearMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{Du/han} {kan} inte göra det för att {den obj/ref}
            inte {|skulle} {får|få} plats bakom {den cont/honom}. ';
    }

    /* container doesn't have room for object */
    containerTooFullMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{Du/han} {kan} inte göra det för att {den cont/ref} {är}
            är redan för full för att få rymma {det obj/honom}. ';
    }

    /* surface doesn't have room for object */
    surfaceTooFullMsg(obj, cont)
    {
        gMessageParams(obj, cont);
        return '{Du/han} {kan} inte göra det för att det {finns|fanns} 
            ingen plats för {det obj/honom} på {den cont/honom}. ';
    }

    /* the dobj doesn't fit on this keyring */
    objNotForKeyringMsg = '{Du/han} {kan} inte göra det för att {det dobj/han}
        {får|fick} inte plats i {den iobj/honom}. '

    /* taking dobj from iobj, but dobj isn't in iobj */
    takeFromNotInMsg = '{Du/han} {kan} inte göra det för att
        {den dobj/ref} {är} inte i {det iobj/honom}. '

    /* taking dobj from surface, but dobj isn't on iobj */
    takeFromNotOnMsg = '{Du/han} {kan} inte göra det för att
        {den dobj/ref} {är} inte på {det iobj/honom}. '

    /* taking dobj under something, but dobj isn't under iobj */
    takeFromNotUnderMsg = '{Du/han} {kan} inte göra det för att
        {den dobj/ref} {är} inte under {det iobj/honom}. '

    /* taking dobj from behind something, but dobj isn't behind iobj */
    takeFromNotBehindMsg = '{Du/han} {kan} inte göra det för att
        {den dobj/ref} {är} inte bakom {det iobj/honom}. '

    /* cannot jump off (with no direct object) from here */
    cannotJumpOffHereMsg = 'Det {finns|fanns} ingenstans för {du/honom} att hoppa av. '

    /* should not break object */
    shouldNotBreakMsg = '{Du/han} {vill|ville} inte förstöra {det dobj/honom}. '

    /* report for standing up/sitting down/lying down */
    okayPostureChangeMsg(posture)
        { return '{Du/han} ' + posture.msgVerbI + '. '; }

    /* report for standing/sitting/lying in/on something */
    roomOkayPostureChangeMsg(posture, obj)
    {
        gMessageParams(obj);
        return '{Du/han} ' + posture.msgVerbT + ' {på obj}. ';
    }

    /* report for getting off a platform */
    okayNotStandingOnMsg = '{Du/han} {kliver|klev} {avur dobj}. '

    /* default 'turn to' acknowledgment */
    okayTurnToMsg(val)
        { return '{Du/han} {vrider|vred} {den dobj/honom} till ' + val + '. '; }

    /* default 'push button' acknowledgment */
    okayPushButtonMsg = '{Du/han} tryck{er/te} {den dobj/honom}. '

    /* default acknowledgment for switching on/off */
    okayTurnOnMsg = '{Du/han} {slår|slog} på {den dobj/honom}. '
    okayTurnOffMsg = '{Du/han} {slår|slog} av {den dobj/honom}. '

    /* the key (iobj) does not fit the lock (dobj) */
    keyDoesNotFitLockMsg = '{Du/han} prova{r|de} {den iobj/ref}, men {det iobj/han} passa{r|de} inte till låset. '

    /* acknowledge entering "follow" mode */
    okayFollowModeMsg = '<q>Ok, jag kommer följa {den dobj/honom}.</q> '

    /* note that we're already in "follow" mode */
    alreadyFollowModeMsg = '<q>Jag följer redan {den dobj/honom}.</q> '

    /* extinguishing a candle */
    okayExtinguishCandleMsg = '{Du/han} släck{er/te} {den dobj/honom}. '

    /* acknowledge attachment */
    okayAttachToMsg =
        '{Du/han} fäst{er|e} {den dobj/honom} till {den iobj/honom}. '

    /* acknowledge detachment */
    okayDetachFromMsg =
        '{Du/han} {tar} loss {den dobj/honom} från {den iobj/honom}. '

    /*
     *   the PC's responses to conversational actions applied to oneself
     *   need some reworking for NPC's 
     */
    cannotTalkToSelfMsg = '{Du/han} kommer inte åstadkomma någonting genom att prata med {sigsjälv}. '
    cannotAskSelfMsg = '{Du/han} kommer inte åstadkomma någonting genom att prata med {sigsjälv}. '
    cannotAskSelfForMsg = '{Du/han} kommer inte åstadkomma någonting genom att prata med {sigsjälv}. '
    cannotTellSelfMsg = '{Du/han} kommer inte åstadkomma någonting genom att prata med {sigsjälv}. '
    cannotGiveToSelfMsg = '{Du/han} kommer inte åstadkomma någonting genom att ge {den dobj/honom} till {sigsjälv}. '
    cannotShowToSelfMsg = '{Du/han} kommer inte åstadkomma någonting genom att visa {den dobj/honom} för {sigsjälv}. '
;

/* ------------------------------------------------------------------------ */
/*
 *   Standard tips
 */

scoreChangeTip: Tip
    "Om du föredrar att inte få notiser om poängförändringar i framtiden, 
    skriv, <<aHref('notiser av', 'NOTISER AV', 'Stäng av poängnotiser')>>."
;

footnotesTip: Tip
    "Ett nummer i [klammer] som det ovanför refererar till en fotnot,
    som du kan läsa genom att skriva FOTNOT följt av numret:
    <<aHref('fotnot 1', 'FOTNOT 1', 'Visa fotnot [1]')>>, till exempel.
    Fotnoter innehåller ofta tillagd bakgrundsinformation som kan vara
    intressant men det är inte viktigt för spelet. Om du föredrar att
    inte se fotnoter överhuvudtaget, så kan du kontrollera deras 
    synlighet genom att skriva <<aHref('fotnoter', 'FOTNOTER', 'kontrollera 
    fotnoters synlighet')>>."
;

oopsTip: Tip
    "Om detta var en oavsiktlig felstavning, kan du korrigera den genom att skriva
    OJ följt av det rättade ordet. Varje gång spelet pekar ut ett okänt ord kan du korrigera
    felstavningen genom att använda OJ som ditt nästa kommando."
;

fullScoreTip: Tip
    "För att se en detaljerade redogörelse av  din poäng, skriv
    <<aHref('full poäng', 'FULL POÄNG')>>."
;

exitsTip: Tip
    "Du kan kontrollera listan med utgångar med UTGÅNGAR kommandot. 
    <<aHref('utgångar status', 'UTGÅNGAR STATUS',
            'Slå på listning av utgångar på statusraden')>>
    visar en lista med utgångar på statusraden,
    <<aHref('utgångar se', 'UTGÅNGAR SE', 'Lista utgångar i rumsbeskrivningar')>>
    visa en komplett utgångslista i varje rumsbeskrivning,
    <<aHref('utgångar på', 'UTGÅNGAR PÅ', 'Slå alla utgångslistningar')>>
    visar båda, och
    <<aHref('utgångar av', 'UTGÅNGAR AV', 'Stäng av alla utgångslistningar')>>
    stänger av båda slags utgångslistningar."
;

undoTip: Tip
    "Om detta inte blev riktigt så som du tänkt dig, observera att du
    kan alltid ta tillbaka ett drag genom att skriva <<aHref('ångra', 'ÅNGRA',
        'Ta tillbaka det senaste kommandot')>>.  Du kan till och med använda
    ÅNGRA upprepade gånger för att ta tillbaka flera drag i rad. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Listers
 */

/*
 *   The basic "room lister" object - this is the object that we use by
 *   default with showList() to construct the listing of the portable
 *   items in a room when displaying the room's description.  
 */
roomLister: Lister
    /* show the prefix/suffix in wide mode */
    showListPrefixWide(itemCount, pov, parent) { "{Du/han} {ser} "; }
    //showListSuffixWide(itemCount, pov, parent) { " {här}. "; }
    showListSuffixWide(itemCount, pov, parent) { " {här}. "; }

    /* show the tall prefix */
    showListPrefixTall(itemCount, pov, parent) { "{Du/han} {ser}:"; }
;

/*
 *   The basic room lister for dark rooms 
 */
darkRoomLister: Lister
    showListPrefixWide(itemCount, pov, parent)
        { "I mörkret {kan} {du/han} se "; }

    showListSuffixWide(itemCount, pov, parent) { ". "; }

    showListPrefixTall(itemCount, pov, parent)
        { "I mörkret {kan} {du/han} se:"; }
;

/*
 *   A "remote room lister".  This is used to describe the contents of an
 *   adjoining room.  For example, if an actor is standing in one room,
 *   and can see into a second top-level room through a window, we'll use
 *   this lister to describe the objects the actor can see through the
 *   window. 
 */
class RemoteRoomLister: Lister
    construct(room) { remoteRoom = room; }
    
    showListPrefixWide(itemCount, pov, parent)
        { "\^<<remoteRoom.inRoomName(pov)>>, {du/han} {ser} "; }
    showListSuffixWide(itemCount, pov, parent)
        { ". "; }

    showListPrefixTall(itemCount, pov, parent)
        { "\^<<remoteRoom.inRoomName(pov)>>, {du/han} {ser}:"; }

    /* the remote room we're viewing */
    remoteRoom = nil
;

/*
 *   A simple customizable room lister.  This can be used to create custom
 *   listers for things like remote room contents listings.  We act just
 *   like any ordinary room lister, but we use custom prefix and suffix
 *   strings provided during construction.  
 */
class CustomRoomLister: Lister
    construct(prefix, suffix)
    {
        prefixStr = prefix;
        suffixStr = suffix;
    }

    showListPrefixWide(itemCount, pov, parent) { "<<prefixStr>> "; }
    showListSuffixWide(itemCount, pov, parent) { "<<suffixStr>> "; }
    showListPrefixTall(itemCount, pov, parent) { "<<prefixStr>>:"; }

    /* our prefix and suffix strings */
    prefixStr = nil
    suffixStr = nil
;

/*
 *   Single-list inventory lister.  This shows the inventory listing as a
 *   single list, with worn items mixed in among the other inventory items
 *   and labeled "(being worn)".  
 */
actorSingleInventoryLister: InventoryLister
    showListPrefixWide(itemCount, pov, parent)
        { "<<buildSynthParam('Den/han', parent)>> {bär|bar} på "; }
    showListSuffixWide(itemCount, pov, parent)
        { ". "; }

    showListPrefixTall(itemCount, pov, parent)
        { "<<buildSynthParam('Den/han', parent)>> {bär|bar} på:"; }
    showListContentsPrefixTall(itemCount, pov, parent)
        { "<<buildSynthParam('En/han', parent)>>, som {bär|bar} på:"; }

    showListEmpty(pov, parent)
        { "<<buildSynthParam('Den/han', parent)>> {är} --tomhänt. "; }
;

/*
 *   Standard inventory lister for actors - this will work for the player
 *   character and NPC's as well.  This lister uses a "divided" format,
 *   which segregates the listing into items being carried and items being
 *   worn.  We'll combine the two lists into a single sentence if the
 *   overall list is short, otherwise we'll show two separate sentences for
 *   readability.  
 */
actorInventoryLister: DividedInventoryLister
    /*
     *   Show the combined inventory listing, putting together the raw
     *   lists of the items being carried and the items being worn. 
     */
    showCombinedInventoryList(parent, carrying, wearing)
    {
        /* if one or the other sentence is empty, the format is simple */
        if (carrying == '' && wearing == '')
        {
            /* the parent is completely tomhänt */
            showInventoryEmpty(parent);
        }
        else if (carrying == '')
        {
            /* the whole list is being worn */
            showInventoryWearingOnly(parent, wearing);
        }
        else if (wearing == '')
        {
            /* the whole list is being carried */
            showInventoryCarryingOnly(parent, carrying);
        }
        else
        {
            /*
             *   Both listings are populated.  Count the number of
             *   comma-separated or semicolon-separated phrases in each
             *   list.  This will give us an estimate of the grammatical
             *   complexity of each list.  If we have very short lists, a
             *   single sentence will be easier to read; if the lists are
             *   long, we'll show the lists in separate sentences.  
             */
            if (countPhrases(carrying) + countPhrases(wearing)
                <= singleSentenceMaxNouns)
            {
                /* short enough: use a single-sentence format */
                showInventoryShortLists(parent, carrying, wearing);
            }
            else
            {
                /* long: use a two-sentence format */
                showInventoryLongLists(parent, carrying, wearing);
            }
        }
    }

    /*
     *   Count the noun phrases in a string.  We'll count the number of
     *   elements in the list as indicated by commas and semicolons.  This
     *   might not be a perfect count of the actual number of noun phrases,
     *   since we could have commas setting off some other kind of clauses,
     *   but it nonetheless will give us a good estimate of the overall
     *   complexity of the text, which is what we're really after.  The
     *   point is that we want to break up the listings if they're long,
     *   but combine them into a single sentence if they're short.  
     */
    countPhrases(txt)
    {
        local cnt;
        
        /* if the string is empty, there are no phrases at all */
        if (txt == '')
            return 0;

        /* a non-empty string has at least one phrase */
        cnt = 1;

        /* scan for commas and semicolons */
        for (local startIdx = 1 ;;)
        {
            local idx;
            
            /* find the next phrase separator */
            idx = rexSearch(phraseSepPat, txt, startIdx);

            /* if we didn't find it, we're done */
            if (idx == nil)
                break;

            /* count it */
            ++cnt;

            /* continue scanning after the separator */
            startIdx = idx[1] + idx[2];
        }

        /* return the count */
        return cnt;
    }

    phraseSepPat = static new RexPattern(',(?! och )|;| och |<rparen>')

    /*
     *   Once we've made up our mind about the format, we'll call one of
     *   these methods to show the final sentence.  These are all separate
     *   methods so that the individual formats can be easily tweaked
     *   without overriding the whole combined-inventory-listing method. 
     */
    showInventoryEmpty(parent)
    {
        /* empty inventory */
        "<<buildSynthParam('Den/han', parent)>> {är} tomhänt. ";
    }
    showInventoryWearingOnly(parent, wearing)
    {
        /* we're carrying nothing but wearing some items */
        "<<buildSynthParam('Den/han', parent)>> {bär|bar} på ingenting, och {är} {bär|bar} på <<wearing>>. ";
    }
    showInventoryCarryingOnly(parent, carrying)
    {
        /* we have only carried items to report */
        "<<buildSynthParam('Den/han', parent)>> {bär|bar} på <<carrying>>. ";
    }
    showInventoryShortLists(parent, carrying, wearing)
    {
        local nm = gSynthMessageParam(parent);
        
        // TODO: it\'s
        /* short lists - combine carried and worn in a single sentence */
        "<<buildParam('Den/han', nm)>> {är} bär på <<carrying>>,
        och <<buildParam('den/han', nm)>>{subj} är iklädd <<wearing>>. ";
    }
    showInventoryLongLists(parent, carrying, wearing)
    {
        local nm = gSynthMessageParam(parent);

        // TODO:
        /* long lists - show carried and worn in separate sentences */
        "<<buildParam('Den/han', nm)>> {bär|bar} på <<carrying>>.
        <<buildParam('Det/han', nm)>> {bär|bar} <<wearing>>. ";
    }

    /*
     *   For 'tall' listings, we'll use the standard listing style, so we
     *   need to provide the framing messages for the tall-mode listing.  
     */
    showListPrefixTall(itemCount, pov, parent)
        { "<<buildSynthParam('Den/han', parent)>> {bär|bar} på:"; }
    showListContentsPrefixTall(itemCount, pov, parent)
        { "<<buildSynthParam('En/han', parent)>>, som {bär|bar} på:"; }
    showListEmpty(pov, parent)
        { "<<buildSynthParam('Den/han', parent)>> {är} tomhänt. "; }
;

/*
 *   Special inventory lister for non-player character descriptions - long
 *   form lister.  This is used to display the inventory of an NPC as part
 *   of the full description of the NPC.
 *   
 *   This long form lister is meant for actors with lengthy descriptions.
 *   We start the inventory listing on a new line, and use the actor's
 *   full name in the list preface.  
 */
actorHoldingDescInventoryListerLong: actorInventoryLister
    showInventoryEmpty(parent)
    {
        /* empty inventory - saying nothing in an actor description */
    }
    showInventoryWearingOnly(parent, wearing)
    {
        /* we're carrying nothing but wearing some items */
        "<.p><<buildSynthParam('Den/han', parent)>> {bär|bar} på <<wearing>>. ";
    }
    showInventoryCarryingOnly(parent, carrying)
    {
        /* we have only carried items to report */
        "<.p><<buildSynthParam('Den/han', parent)>> {bär|bar} på <<carrying>>. ";
    }
    showInventoryShortLists(parent, carrying, wearing)
    {
        local nm = gSynthMessageParam(parent);

        /* short lists - combine carried and worn in a single sentence */
        "<.p><<buildParam('Den/han', nm)>> bär på <<carrying>>,
        och <<buildParam('det/han', nm)>>{subj} iklädd <<wearing>>. ";
    }
    showInventoryLongLists(parent, carrying, wearing)
    {
        local nm = gSynthMessageParam(parent);

        /* long lists - show carried and worn in separate sentences */
        "<.p><<buildParam('Den/han', nm)>> {bär|bar} på <<carrying>>.
        <<buildParam('det/han', nm)>> {bär|bar} på <<wearing>>. ";
    }
;

/* short form of non-player character description inventory lister */
actorHoldingDescInventoryListerShort: actorInventoryLister
    showInventoryEmpty(parent)
    {
        /* empty inventory - saying nothing in an actor description */
    }
    showInventoryWearingOnly(parent, wearing)
    {
        /* we're carrying nothing but wearing some items */
        "<<buildSynthParam('Det/han', parent)>> {är} {har|hade} på sig <<wearing>>. ";
    }
    showInventoryCarryingOnly(parent, carrying)
    {
        /* we have only carried items to report */
        "<<buildSynthParam('Det/han', parent)>> {bär|bar} på <<carrying>>. ";
    }
    showInventoryShortLists(parent, carrying, wearing)
    {
        local nm = gSynthMessageParam(parent);

        /* short lists - combine carried and worn in a single sentence */
        "<<buildParam('Det/han', nm)>> {bär|bar} på <<carrying>>, och
        <<buildParam('det/han', nm)>>{subj} {har|hade} på sig <<wearing>>. ";
    }
    showInventoryLongLists(parent, carrying, wearing)
    {
        local nm = gSynthMessageParam(parent);

        /* long lists - show carried and worn in separate sentences */
        "<<buildParam('Det/han', nm)>> {bär|bar} på <<carrying>>.
        <<buildParam('det/han', nm)>> {har|hade} på sig <<wearing>>. ";
    }
;

/*
 *   Base contents lister for things.  This is used to display the contents
 *   of things shown in room and inventory listings; we subclass this for
 *   various purposes 
 */
class BaseThingContentsLister: Lister
    showListPrefixWide(itemCount, pov, parent)
        { "\^<<parent.nameVerb('{innehåller|innehöll}')>> "; }
    showListSuffixWide(itemCount, pov, parent)
        { ". "; }
    showListPrefixTall(itemCount, pov, parent)
        { "\^<<parent.nameVerb('{innehåller|innehöll}')>>:"; }
    showListContentsPrefixTall(itemCount, pov, parent)
        { "<<parent.aName>>, som {innehåller|innehöll}:"; }
;

/*
 *   Contents lister for things.  This is used to display the second-level
 *   contents lists for things listed in the top-level list for a room
 *   description, inventory listing, or object description.  
 */
thingContentsLister: ContentsLister, BaseThingContentsLister
;

/*
 *   Contents lister for descriptions of things - this is used to display
 *   the contents of a thing as part of the long description of the thing
 *   (in response to an "examine" command); it differs from a regular
 *   thing contents lister in that we use a pronoun to refer to the thing,
 *   rather than its full name, since the full name was probably just used
 *   in the basic long description.  
 */
thingDescContentsLister: DescContentsLister, BaseThingContentsLister
    showListPrefixWide(itemCount, pov, parent)
        { "\^<<parent.itVerb('innehåller')>> "; }
;

/*
 *   Contents lister for openable things.
 */
openableDescContentsLister: thingDescContentsLister
    showListEmpty(pov, parent)
    {
        "\^<<parent.openStatus>>. ";
    }
    showListPrefixWide(itemCount, pov, parent)
    {
        //"\^<<parent.openStatus>>, och innehåller <<parent.verbEndingSEd>> ";
        "\^<<parent.openStatus>>, och {innehåller|innehöll} ";
    }
;

/*
 *   Base contents lister for "LOOK <PREP>" commands (LOOK IN, LOOK UNDER,
 *   LOOK BEHIND, etc).  This can be subclasses for the appropriate LOOK
 *   <PREP> command matching the container type - LOOK UNDER for
 *   undersides, LOOK BEHIND for rear containers, etc.  To use this class,
 *   combine it via multiple inheritance with the appropriate
 *   Base<Prep>ContentsLister for the preposition type.  
 */
class LookWhereContentsLister: DescContentsLister
    showListEmpty(pov, parent)
    {
        /* show a default message indicating the surface is empty */
        gMessageParams(parent);
        defaultDescReport('{Du/han} {ser} ingenting ' + parent.objInPrep + ' {den parent/honom}. ');
    }
;

/*
 *   Contents lister for descriptions of things whose contents are
 *   explicitly inspected ("look in").  This differs from a regular
 *   contents lister in that we explicitly say that the object is empty if
 *   it's empty.
 */
thingLookInLister: LookWhereContentsLister, BaseThingContentsLister
    showListEmpty(pov, parent)
    {
        /*
         *   Indicate that the list is empty, but make this a default
         *   descriptive report.  This way, if we report any special
         *   descriptions for items contained within the object, we'll
         *   suppress this default description that there's nothing to
         *   describe, which is clearly wrong if there are
         *   specially-described contents. 
         */
        gMessageParams(parent);
        defaultDescReport('{Du/han} {ser} inget ovanligt i {den parent/honom}. ');
    }
;

/*
 *   Default contents lister for newly-revealed objects after opening a
 *   container.  
 */
openableOpeningLister: BaseThingContentsLister
    showListEmpty(pov, parent) { }
    showListPrefixWide(itemCount, pov, parent)
    {
        /*
         *   This list is, by default, generated as a replacement for the
         *   default "Opened" message in response to an OPEN command.  We
         *   therefore need different messages for PC and NPC actions,
         *   since this serves as the description of the entire action.
         *   
         *   Note that if you override the Open action response for a given
         *   object, you might want to customize this lister as well, since
         *   the message we generate (especially for an NPC action)
         *   presumes that we'll be the only response the command.  
         */
        gMessageParams(pov, parent);
        if (pov.isPlayerChar())
            "{Du/han} öppna{r|de} {den parent/honom} och {finner|fann} ";
        else
            "{Du/han} öppna{r|de} {den parent/honom} och {finner|fann} ";
    }
;

/*
 *   Base contents lister.  This class handles contents listings for most
 *   kinds of specialized containers - Surfaces, RearConainers,
 *   RearSurfaces, and Undersides.  The main variation in the contents
 *   listings for these various types of containers is simply the
 *   preposition that's used to describe the relationship between the
 *   container and the contents, and for this we can look to the objInPrep
 *   property of the container.  
 */
class BaseContentsLister: Lister
    showListPrefixWide(itemCount, pov, parent)
    {
        "\^<<parent.objInPrep>> <<parent.theNameObj>>
        <<itemCount == 1 ? tSel('är', 'var') : tSel('är', 'var')>> ";
    }
    showListSuffixWide(itemCount, pov, parent)
    {
        ". ";
    }
    showListPrefixTall(itemCount, pov, parent)
    {
        "\^<<parent.objInPrep>> <<parent.theNameObj>>
        <<itemCount == 1 ? tSel('är', 'var') : tSel('är', 'var')>>:";
    }
    showListContentsPrefixTall(itemCount, pov, parent)
    {
        "<<parent.aName>>, <<parent.objInPrep>> <<parent.isNeuter?'vilket':'vilken'>>
        <<itemCount == 1 ? tSel('är', 'var') : tSel('är', 'var')>>:";
    }
;


/*
 *   Base class for contents listers for a surface 
 */
class BaseSurfaceContentsLister: BaseContentsLister
;

/*
 *   Contents lister for a surface 
 */
surfaceContentsLister: ContentsLister, BaseSurfaceContentsLister
;

/*
 *   Contents lister for explicitly looking in a surface 
 */
surfaceLookInLister: LookWhereContentsLister, BaseSurfaceContentsLister
;

/*
 *   Contents lister for a surface, used in a long description. 
 */
surfaceDescContentsLister: DescContentsLister, BaseSurfaceContentsLister
;

/*
 *   Contents lister for room parts
 */
roomPartContentsLister: surfaceContentsLister
    isListed(obj)
    {
        /* list the object if it's listed in the room part */
        return obj.isListedInRoomPart(part_);
    }

    /* the part I'm listing */
    part_ = nil
;

/*
 *   contents lister for room parts, used in a long description 
 */
roomPartDescContentsLister: surfaceDescContentsLister
    isListed(obj)
    {
        /* list the object if it's listed in the room part */
        return obj.isListedInRoomPart(part_);
    }

    part_ = nil
;

/*
 *   Look-in lister for room parts.  Most room parts act like surfaces
 *   rather than containers, so base this lister on the surface lister.  
 */
roomPartLookInLister: surfaceLookInLister
    isListed(obj)
    {
        /* list the object if it's listed in the room part */
        return obj.isListedInRoomPart(part_);
    }

    part_ = nil
;
                         
/*
 *   Base class for contents listers for an Underside.  
 */
class BaseUndersideContentsLister: BaseContentsLister
;

/* basic contents lister for an Underside */
undersideContentsLister: ContentsLister, BaseUndersideContentsLister
;

/* contents lister for explicitly looking under an Underside */
undersideLookUnderLister: LookWhereContentsLister, BaseUndersideContentsLister
;

/* contents lister for moving an Underside and abandoning its contents */
undersideAbandonContentsLister: undersideLookUnderLister
    showListEmpty(pov, parent) { }
    showListPrefixWide(itemCount, pov, parent)
        { "Flyttandet av  <<parent.theNameObj>> avslöja<<tSel('r', 'de')>> "; }
    showListSuffixWide(itemCount, pov, parent)
        { " nedanför. "; }
    showListPrefixTall(itemCount, pov, parent)
        { "Flyttandet av  <<parent.theNameObj>> avslöja<<tSel('r', 'de')>>:"; }
;
 
/* contents lister for an Underside, used in a long description */
undersideDescContentsLister: DescContentsLister, BaseUndersideContentsLister
    showListPrefixWide(itemCount, pov, parent)
    {
        "Under <<parent.theNameObj>>
        <<itemCount == 1 ? tSel('är', 'var')
                         : tSel('är', 'var')>> ";
    }
;

/*
 *   Base class for contents listers for an RearContainer or RearSurface 
 */
class BaseRearContentsLister: BaseContentsLister
;

/* basic contents lister for a RearContainer or RearSurface */
rearContentsLister: ContentsLister, BaseRearContentsLister
;

/* contents lister for explicitly looking behind a RearContainer/Surface */
rearLookBehindLister: LookWhereContentsLister, BaseRearContentsLister
;
 
/* lister for moving a RearContainer/Surface and abandoning its contents */
rearAbandonContentsLister: undersideLookUnderLister
    showListEmpty(pov, parent) { }
    showListPrefixWide(itemCount, pov, parent)
        { "Flyttandet av <<parent.theNameObj>> avslöja<<tSel('r', 'de')>> "; }
    showListSuffixWide(itemCount, pov, parent)
        { " bakom <<parent.itObj>>. "; }
    showListPrefixTall(itemCount, pov, parent)
        { "Flyttandet av <<parent.theNameObj>> avslöja<<tSel('r', 'de')>>:"; }
;
 
/* long-description contents lister for a RearContainer/Surface */
rearDescContentsLister: DescContentsLister, BaseRearContentsLister
    showListPrefixWide(itemCount, pov, parent)
    {
        "Bakom <<parent.theNameObj>>
        <<itemCount == 1 ? tSel('är', 'var')
                         : tSel('är', 'var')>> ";
    }
;


/*
 *   Base class for specialized in-line contents listers.  This shows the
 *   list in the form "(<prep> which is...)", with the preposition obtained
 *   from the container's objInPrep property.  
 */
class BaseInlineContentsLister: ContentsLister
    showListEmpty(pov, parent) { }
    showListPrefixWide(cnt, pov, parent)
    {

        " (<<parent.objInPrep>> <<parent.isNeuter?'vilket':'vilken'>> <<
          cnt == 1 ? tSel('är', 'var') : tSel('är', 'var')>> ";
    }
    showListSuffixWide(itemCount, pov, parent)
        { ")"; }
;

/*
 *   Contents lister for a generic in-line list entry.  We customize the
 *   wording slightly here: rather than saying "(in which...)" as the base
 *   class would, we use the slightly more readable "(which contains...)".
 */
inlineListingContentsLister: BaseInlineContentsLister
    showListPrefixWide(cnt, pov, parent)
        //{ " (som innehåller<<parent.verbEndingSEd>> "; }
        { " (som {innehåller|innehöll} "; }
;

/* in-line contents lister for a surface */
surfaceInlineContentsLister: BaseInlineContentsLister
;

/* in-line contents lister for an Underside */
undersideInlineContentsLister: BaseInlineContentsLister
;

/* in-line contents lister for a RearContainer/Surface */
rearInlineContentsLister: BaseInlineContentsLister
;

/*
 *   Contents lister for keyring list entry.  This is used to display a
 *   keyring's contents in-line with the name of the keyring,
 *   parenthetically. 
 */
keyringInlineContentsLister: inlineListingContentsLister
    showListPrefixWide(cnt, pov, parent)
        { " (med "; }
    showListSuffixWide(cnt, pov, parent)
        { " fäst)"; }
;


/*
 *   Contents lister for "examine <keyring>" 
 */
keyringExamineContentsLister: DescContentsLister
    showListEmpty(pov, parent)
    {
        "\^<<parent.nameIs>> tom. ";
    }
    showListPrefixWide(cnt, pov, parent)
    {
        "Fäst i <<parent.theNameObj>>
        <<cnt == 1 ? tSel('är', 'var')
                   : tSel('är', 'var')>> ";
    }
    showListSuffixWide(itemCount, pov, parent)
    {
        ". ";
    }
;

/*
 *   Lister for actors aboard a traveler.  This is used to list the actors
 *   on board a vehicle when the vehicle arrives or departs a location.  
 */
aboardVehicleLister: Lister
    showListPrefixWide(itemCount, pov, parent)
        { " (håller i "; }
    showListSuffixWide(itemCount, pov, parent)
        { ")"; }

    /* list anything whose isListedAboardVehicle returns true */
    isListed(obj) { return obj.isListedAboardVehicle; }
;

/*
 *   A simple lister to show the objects to which a given Attachable
 *   object is attached.  This shows the objects which have symmetrical
 *   attachment relationships to the given parent object, or which are
 *   "major" items to which the parent is attached.  
 */
class SimpleAttachmentLister: Lister
    construct(parent) { parent_ = parent; }
    
    showListEmpty(pov, parent)
        { /* say nothing when there are no attachments */ }
    
    showListPrefixWide(cnt, pov, parent)
        { "<.p>\^<<parent.nameIs>> fäst i "; }
    showListSuffixWide(cnt, pov, parent)
        { ". "; }

    /* ask the parent if we should list each item */
    isListed(obj) { return parent_.isListedAsAttachedTo(obj); }

    /*
     *   the parent object - this is the object whose attachments are being
     *   listed 
     */
    parent_ = nil
;

/*
 *   The "major" attachment lister.  This lists the objects which are
 *   attached to a given parent Attachable, and for which the parent is
 *   the "major" item in the relationship.  The items in the list are
 *   described as being attached to the parent.  
 */
class MajorAttachmentLister: SimpleAttachmentLister
    showListPrefixWide(cnt, pov, parent) { "<.p>\^"; }
    showListSuffixWide(cnt, pov, parent)
    {
        " <<cnt == 1 ? tSel('är', 'var')
                     : tSel('är', 'var')>>
        fäst i <<parent.theNameObj>>. ";
    }

    /* ask the parent if we should list each item */
    isListed(obj) { return parent_.isListedAsMajorFor(obj); }
;

/*
 *   Finish Options lister.  This lister is used to offer the player
 *   options in finishGame(). 
 */
finishOptionsLister: Lister
    showListPrefixWide(cnt, pov, parent)
    {
        "<.p>Skulle du vilja ";
    }
    showListSuffixWide(cnt, pov, parent)
    {
        /* end the question, add a blank line, and show the ">" prompt */
        "?\b&gt;";
    }
    
    isListed(obj) { return obj.isListed; }
    listCardinality(obj) { return 1; }
    
    showListItem(obj, options, pov, infoTab)
    {
        /* obj is a FinishOption object; show its description */
        obj.desc;
    }
    
    showListSeparator(options, curItemNum, totalItems)
    {
        /*
         *   for the last separator, show "or" rather than "and"; for
         *   others, inherit the default handling 
         */
        if (curItemNum + 1 == totalItems)
        {
            if (totalItems == 2)
                " eller ";
            else
                ", eller ";
        }
        else
            inherited(options, curItemNum, totalItems);
    }
;

/*
 *   Equivalent list state lister.  This shows a list of state names for a
 *   set of otherwise indistinguishable items.  We show the state names in
 *   parentheses, separated by commas only (i.e., no "and" separating the
 *   last two items); we use this less verbose format so that we blend
 *   into the larger enclosing list more naturally.
 *   
 *   The items to be listed are EquivalentStateInfo objects.  
 */
equivalentStateLister: Lister
    showListPrefixWide(cnt, pov, parent) { " ("; }
    showListSuffixWide(cnt, pov, parent) { ")"; }
    isListed(obj) { return true; }
    listCardinality(obj) { return 1; }
    showListItem(obj, options, pov, infoTab)
    {
        "<<spellIntBelow(obj.getEquivCount(), 100)>> <<obj.getName()>>";
    }
    showListSeparator(options, curItemNum, totalItems)
    {
        if (curItemNum < totalItems)
            ", ";
    }
;

/* in case the exits module isn't included in the build */
property destName_, destIsBack_, others_, enableHyperlinks;

/*
 *   Basic room exit lister.  This shows a list of the apparent exits from
 *   a location.
 *   
 *   The items to be listed are DestInfo objects.  
 */
class ExitLister: Lister
    showListPrefixWide(cnt, pov, parent)
    {
        if (cnt == 1)
            "Den enda uppenbara utgången {leder|ledde} ";
        else
            "Uppenbara utgångar {leder|ledde} ";
    }
    showListSuffixWide(cnt, pov, parent) { ". "; }

    isListed(obj) { return true; }
    listCardinality(obj) { return 1; }

    showListItem(obj, options, pov, infoTab)
    {
        /*
         *   Show the back-to-direction prefix, if we don't know the
         *   destination name but this is the back-to direction: "back to
         *   the north" and so on. 
         */
        if (obj.destIsBack_ && obj.destName_ == nil)
            say(obj.dir_.backToPrefix + ' ');
        
        /* show the direction */
        showListItemDirName(obj, nil);

        /* if the destination is known, show it as well */
        if (obj.destName_ != nil)
        {
            /*
             *   if we have a list of other directions going to the same
             *   place, show it parenthetically 
             */
            otherExitLister.showListAll(obj.others_, 0, 0);
            
            /*
             *   Show our destination name.  If we know the "back to"
             *   destination name, show destination names in the format
             *   "east, to the living room" so that they are consistent
             *   with "west, back to the dining room".  Otherwise, just
             *   show "east to the living room".  
             */
            if ((options & hasBackNameFlag) != 0)
                ",";

            /* if this is the way back, say so */
            if (obj.destIsBack_)
                " tillbaka";

            /* show the destination */
            " till <<obj.destName_>>";
        }
    }
    showListSeparator(options, curItemNum, totalItems)
    {
        /*
         *   if we have a "back to" name, use the "long" notation - this is
         *   important because we'll use commas in the directions with
         *   known destination names 
         */
        if ((options & hasBackNameFlag) != 0)
            options |= ListLong;

        /*
         *   for a two-item list, if either item has a destination name,
         *   show a comma or semicolon (depending on 'long' vs 'short' list
         *   mode) before the "and"; for anything else, use the default
         *   handling 
         */
        if (curItemNum == 1
            && totalItems == 2
            && (options & hasDestNameFlag) != 0)
        {
            if ((options & ListLong) != 0)
                "; och ";
            else
                ", och ";
        }
        else
            inherited(options, curItemNum, totalItems);
    }

    /* show a direction name, hyperlinking it if appropriate */
    showListItemDirName(obj, initCap)
    {
        local dirname;
        
        /* get the name */
        dirname = obj.dir_.name;

        /* capitalize the first letter, if desired */
        if (initCap)
            dirname = dirname.substr(1,1).toUpper() + dirname.substr(2);

        /* show the name with a hyperlink or not, as configured */
        if (libGlobal.exitListerObj.enableHyperlinks)
            say(aHref(dirname, dirname));
        else
            say(dirname);
    }

    /* this lister shows destination names */
    listerShowsDest = true

    /*
     *   My special options flag: at least one object in the list has a
     *   destination name.  The caller should set this flag in our options
     *   if applicable. 
     */
    hasDestNameFlag = ListerCustomFlag(1)
    hasBackNameFlag = ListerCustomFlag(2)
    nextCustomFlag = ListerCustomFlag(3)
;

/*
 *   Show a list of other exits to a given destination.  We'll show the
 *   list parenthetically, if there's a list to show.  The objects to be
 *   listed are Direction objects.  
 */
otherExitLister: Lister
    showListPrefixWide(cnt, pov, parent) { " (eller "; }
    showListSuffixWide(cnt, pov, parent) { ")"; }

    isListed(obj) { return true; }
    listCardinality(obj) { return 1; }

    showListItem(obj, options, pov, infoTab)
    {
        if (libGlobal.exitListerObj.enableHyperlinks)
            say(aHref(obj.name, obj.name));
        else
            say(obj.name);
    }
    showListSeparator(options, curItemNum, totalItems)
    {
        /*
         *   simply show "or" for all items (these lists are usually
         *   short, so omit any commas) 
         */
        if (curItemNum != totalItems)
            " eller ";
    }
;

/*
 *   Show room exits as part of a room description, using the "verbose"
 *   sentence-style notation.  
 */
lookAroundExitLister: ExitLister
    showListPrefixWide(cnt, pov, parent)
    {
        /* add a paragraph break before the exit listing */
        "<.roompara>";

        /* inherit default handling */
        inherited(cnt, pov, parent);
    }    
;

/*
 *   Show room exits as part of a room description, using the "terse"
 *   notation. 
 */
lookAroundTerseExitLister: ExitLister
    showListPrefixWide(cnt, pov, parent)
    {
        "<.roompara><.parser>Uppenbara utgångar: ";
    }
    showListItem(obj, options, pov, infoTab)
    {
        /* show the direction name */
        showListItemDirName(obj, true);
    }
    showListSuffixWide(cnt, pov, parent)
    {
        "<./parser> ";
    }
    showListSeparator(options, curItemNum, totalItems)
    {
        /* just show a comma between items */
        if (curItemNum != totalItems)
            ", ";
    }

    /* this lister does not show destination names */
    listerShowsDest = nil
;

/*
 *   Show room exits in response to an explicit request (such as an EXITS
 *   command).  
 */
explicitExitLister: ExitLister
    showListEmpty(pov, parent)
    {
        "Det {finns|fanns} inga uppenbara utgångar. ";
        //"There {are|were} no obvious exits. ";
    }
;

/*
 *   Show room exits in the status line (used in HTML mode only)
 */
statuslineExitLister: ExitLister
    showListEmpty(pov, parent)
    {
        "<<statusHTML(3)>><b>Utgångar:</b> <i>Ingen</i><<statusHTML(4)>>";
    }
    showListPrefixWide(cnt, pov, parent)
    {
        "<<statusHTML(3)>><b>Utgångar:</b> ";
    }
    showListSuffixWide(cnt, pov, parent)
    {
        "<<statusHTML(4)>>";
    }
    showListItem(obj, options, pov, infoTab)
    {
        "<<aHref(obj.dir_.name, obj.dir_.name, 'Gå ' + obj.dir_.name,
                 AHREF_Plain)>>";
    }
    showListSeparator(options, curItemNum, totalItems)
    {
        /* just show a space between items */
        if (curItemNum != totalItems)
            " &nbsp; ";
    }

    /* this lister does not show destination names */
    listerShowsDest = nil
;

/*
 *   Implied action announcement grouper.  This takes a list of
 *   ImplicitActionAnnouncement reports and returns a single message string
 *   describing the entire list of actions.  
 */
implicitAnnouncementGrouper: object
    /*
     *   Configuration option: keep all failures in a list of implied
     *   announcements.  If this is true, then we'll write things like
     *   "trying to unlock the door and then open it"; if nil, we'll
     *   instead write simply "trying to unlock the door".
     *   
     *   By default, we keep only the first of a group of failures.  A
     *   group of failures is always recursively related, so the first
     *   announcement refers to the command that actually failed; the rest
     *   of the announcements are for the enclosing actions that triggered
     *   the first action.  All of the enclosing actions failed as well,
     *   but only because the first action failed.
     *   
     *   Announcing all of the actions is too verbose for most tastes,
     *   which is why we set the default here to nil.  The fact that the
     *   first action in the group failed means that we necessarily won't
     *   carry out any of the enclosing actions, so the enclosing
     *   announcements don't tell us much.  All they really tell us is why
     *   we're running the action that actually failed, but that's almost
     *   always obvious, so suppressing them is usually fine.  
     */
    keepAllFailures = nil

    /* build the composite message */
    compositeMessage(lst)
    {
        local txt;
        local ctx = new ListImpCtx();

        /* add the text for each item in the list */
        for (txt = '', local i = 1, local len = lst.length() ; i <= len ; ++i)
        {
            local curTxt;

            /* get this item */
            local cur = lst[i];

            /* we're not in a 'try' or 'ask' sublist yet */
            ctx.isInSublist = nil;

            /* set the underlying context according to this item */
            ctx.setBaseCtx(cur);

            /*
             *   Generate the announcement for this element.  Generate the
             *   announcement from the message property for this item using
             *   our running list context.  
             */
            curTxt = cur.getMessageText(
                cur.getAction().getOriginalAction(), ctx);

            /*
             *   If this one is an attempt only, and it's followed by one
             *   or more other attempts, the attempts must all be
             *   recursively related (in other words, the first attempt was
             *   an implied action required by the second attempt, which
             *   was required by the third, and so on).  They have to be
             *   recursively related, because otherwise we wouldn't have
             *   kept trying things after the first failed attempt.
             *   
             *   To make the series of failed attempts sound more natural,
             *   group them into a single "trying to", and keep only the
             *   first failure: rather than "trying to unlock the door,
             *   then trying to open the door", write "trying to unlock the
             *   door and then open it".
             *   
             *   An optional configuration setting makes us keep only the
             *   first failed operation, so we'd instead write simply
             *   "trying to unlock the door".
             *   
             *   Do the same grouping for attempts interrupted for an
             *   interactive question.  
             */
            while ((cur.justTrying && i < len && lst[i+1].justTrying)
                   || (cur.justAsking && i < len && lst[i+1].justAsking))
            {
                local addTxt;
                
                /*
                 *   move on to the next item - we're processing it here,
                 *   so we don't need to handle it again in the main loop 
                 */
                ++i;
                cur = lst[i];

                /* remember that we're in a try/ask sublist */
                ctx.isInSublist = true;

                /* add the list entry for this action, if desired */
                if (keepAllFailures)
                {
                    /* get the added text */
                    addTxt = cur.getMessageText(
                        cur.getAction().getOriginalAction(), ctx);

                    /*
                     *   if both the text so far and the added text are
                     *   non-empty, string them together with 'and then';
                     *   if one or the other is empty, use the non-nil one 
                     */
                    if (addTxt != '' && curTxt != '')
                        //curTxt += ' och sen ' + addTxt;
                        curTxt += ', ' + addTxt;
                    else if (addTxt != '')
                        curTxt = addTxt;
                }
            }

            /* add a separator before this item if it isn't the first */
            if (txt != '' && curTxt != '')
                //txt += ', sen ';
                txt += ' och ';

            /* add the current item's text */
            txt += curTxt;
        }

        /* if we ended up with no text, the announcement is silent */
        if (txt == '')
            return '';

        /* wrap the whole list in the usual full standard phrasing */
        return standardImpCtx.buildImplicitAnnouncement(txt);
    }
;

/*
 *   Suggested topic lister. 
 */
class SuggestedTopicLister: Lister
    construct(asker, askee, explicit)
    {
        /* remember the actors */
        askingActor = asker;
        targetActor = askee;

        /* remember whether this is explicit or implicit */
        isExplicit = explicit;

        /* cache the actor's scope list */
        scopeList = asker.scopeList();
    }
    
    showListPrefixWide(cnt, pov, parent)
    {
        /* add the asking and target actors as global message parameters */
        gMessageParams(askingActor, targetActor);

        /* show the prefix; include a paren if not in explicit mode */
        "<<isExplicit ? '' : '('>>{Du askingActor/han} kan ";
    }
    showListSuffixWide(cnt, pov, parent)
    {
        /* end the sentence; include a paren if not in explicit mode */
        ".<<isExplicit? '' : ')'>> ";
    }
    showListEmpty(pov, parent)
    {
        /*
         *   say that the list is empty if it was explicitly requested;
         *   say nothing if the list is being added by the library 
         */
        if (isExplicit)
        {
            gMessageParams(askingActor, targetActor);
            "<<isExplicit ? '' : '('>>{Du askingActor/han} {har|hade} ingenting
            specifikt just {nu|då} att diskutera med 
            {den targetActor/honom}.<<isExplicit ? '' : ')'>> ";
        }
    }

    showListSeparator(options, curItemNum, totalItems)
    {
        /* use "or" as the conjunction */
        if (curItemNum + 1 == totalItems)
            ", eller ";
        else
            inherited(options, curItemNum, totalItems);
    }

    /* list suggestions that are currently active */
    isListed(obj) { return obj.isSuggestionActive(askingActor, scopeList); }

    /* each item counts as one item grammatically */
    listCardinality(obj) { return 1; }

    /* suggestions have no contents */
    contentsListed(obj) { return nil; }

    /* get the list group */
    listWith(obj) { return obj.suggestionGroup; }

    /* mark as seen - nothing to do for suggestions */
    markAsSeen(obj, pov) { }

    /* show the item - show the suggestion's theName */
    showListItem(obj, options, pov, infoTab)
    {
        /* note that we're showing the suggestion */
        obj.noteSuggestion();

        /* show the name */
        say(obj.fullName);
    }

    /* don't use semicolons, even in long lists */
    longListSepTwo { listSepTwo; }
    longListSepMiddle { listSepMiddle; }
    longListSepEnd { listSepEnd; }

    /* flag: this is an explicit listing (i.e., a TOPICS command) */
    isExplicit = nil

    /* the actor who's asking for the topic list (usually the PC) */
    askingActor = nil

    /* the actor we're talking to */
    targetActor = nil

    /* our cached scope list for the actor */
    scopeList = nil
;

/* ASK/TELL suggestion list group base class */
class SuggestionListGroup: ListGroupPrefixSuffix
    showGroupItem(sublister, obj, options, pov, infoTab)
    {
        /*
         *   show the short name of the item - the group prefix will have
         *   shown the appropriate long name 
         */
        say(obj.name);
    }
;

/* ASK ABOUT suggestion list group */
suggestionAskGroup: SuggestionListGroup
    groupPrefix = "fråga {den targetActor/honom} om "
;

/* TELL ABOUT suggestion list group */
suggestionTellGroup: SuggestionListGroup
    groupPrefix = "berätta för {den targetActor/honom} om "
;

/* ASK FOR suggestion list group */
suggestionAskForGroup: SuggestionListGroup
    groupPrefix = "fråga {den targetActor/honom} om "
;

/* GIVE TO suggestions list group */
suggestionGiveGroup: SuggestionListGroup
    groupPrefix = "ge {den targetActor/honom} "
;

/* SHOW TO suggestions */
suggestionShowGroup: SuggestionListGroup
    groupPrefix = "visa {den targetActor/honom} "
;

/* YES/NO suggestion group */
suggestionYesNoGroup: SuggestionListGroup
    showGroupList(pov, lister, lst, options, indent, infoTab)
    {
        /*
         *   if we have one each of YES and NO responses, make the entire
         *   list "say yes or no"; otherwise, use the default behavior 
         */
        if (lst.length() == 2
            && lst.indexWhich({x: x.ofKind(SuggestedYesTopic)}) != nil
            && lst.indexWhich({x: x.ofKind(SuggestedNoTopic)}) != nil)
        {
            /* we have a [yes, no] group - use the simple message */
            "säg ja eller nej";
        }
        else
        {
            /* inherit the default behavior */
            inherited(pov, lister, lst, options, indent, infoTab);
        }
    }
    groupPrefix = "säg";
;
