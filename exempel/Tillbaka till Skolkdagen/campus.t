#charset "utf-8"
/*
 *   Copyright 2003, 2013 Michael J. Roberts
 *   
 *   Return to Ditch Day - campus section.  This contains most of the
 *   campus outdoor locations, and the smaller campus building interiors.  
 */

#include <adv3.h>
#include <sv_se.h>
#include <bignum.h>
#include "ditch3.h"

/* ------------------------------------------------------------------------ */
/*
 *   A plot event describing the start of the on-campus section of the
 *   game.  This is ostensibly three weeks after the introductory section -
 *   but we don't have a calendar in the game, so just make it day 2, and
 *   no one will ever know.  
 */
onCampusPlotEvent: ClockEvent eventTime = [2, 8, 30];

/* ------------------------------------------------------------------------ */
/*
 *   Set up for the campus section.  Show the transition passage, move the
 *   player character to the starting campus location, and adjust the
 *   inventory appropriately.  
 */
campusInit()
{
    /* pause, then clear the screen */
    "\b";
    inputManager.pauseForMore(nil);
    initScreen(true);

    /* notify the clock manager that we've reached a plot point */
    onCampusPlotEvent.eventReached();

    /* show the transitional text */
    "\b\b\b\b<i>Tre veckor senare...</i>
    \b\b
    \bFlygplatsbussen släpper av dig i slutet av San Pasqual
    St., vid östra kanten av Caltech-campus, och kör iväg.
    
    <.p>Du hade glömt hur otroligt hemsk LA-trafiken kan vara.
    Väg 105 var en solid rad av baklyktor hela vägen från LAX till centrum,
    och 110:an var en parkeringsplats större delen av vägen upp till Pas. Du hade
    tänkt att du kanske skulle utforska campus lite innan ditt
    möte, men det är uteslutet nu; bäst att gå
    direkt till Career Center-kontoret. Apropå det, det
    verkar som om de flyttar Career Center till en ny byggnad varje
    gång du är här nere; den här gången är det i Student Services-
    byggnaden, en kort bit upp på Holliston.<.p> ";
    
    /* get rid of all of the power-plant-related possessions */
    foreach (local cur in me.contents)
    {
        /* 
         *   if it's not clothing or a non-portable, or it's marked as
         *   'introOnly', get rid of it 
         */
        if (cur.introOnly
            || (!cur.ofKind(Wearable) && !cur.ofKind(NonPortable)))
            cur.moveInto(nil);
    }

    /* restore the normal shoes */
    myShoes.moveInto(me);
    myLeftShoe.moveInto(nil);

    /* un-rip the pants and brush off the accumulated dust */
    khakis.makeTorn(nil);
    myDust.moveInto(nil);

    /* move us to San Pasqual and have a look around */
    me.moveIntoForTravel(sanPasqual);
    me.lookAround(true);

    /* move our briefcase (and its contents) into the player's inventory */
    toteBag.moveInto(me);

    /* 
     *   Now that we have the tote bag, set a reasonable carrying limit, so
     *   that our hands don't get ridiculously full.  The tote bag is a
     *   "bag of holding," so it'll manage our inventory for us
     *   automatically as our hands get overfull, which means that there's
     *   no inconvenience for the player in setting a holding limit.  
     */
    me.bulkCapacity = 6;

    /* also pick up our keyring and wallet */
    myKeyring.moveInto(myPocket);
    myWallet.moveInto(myPocket);

    /* 
     *   Since this represents an abrupt transition in the game, and since
     *   we're triggered by a simple EXAMINE command, cancel anything
     *   remaining on the command line.  Anything remaining on the command
     *   line will probably be suitable only in the old context, and won't
     *   make any sense now that we've jumped to a new chapter.  
     */
    throw new TerminateCommandException();
}

/* ------------------------------------------------------------------------ */
/*
 *   A few topics for questions in this part of the game
 */

ddTopic: Topic 'ditch day skolkdagen';
nicTopic: Topic 'nätverksinstallatörsföretag+et/nic/n.i.c.';
stackTopic: Topic 'ditch day skolkdagen stapel+n/staplar+na/stack+en/stackar+na';
stamerStackTopic: Topic '(brians) (brians) (stamers) ditch day skolkdagen stapel+n/stack+en';
paulStackTopic: Topic '(pauls) (pauls) ditch day skolkdagen stapel+n/stack+en/lösenord+et'; 
caltechTopic: Topic '(cal) caltech/tech';
stamerLabTopic: Topic
    '(brians) (brians) (stamers) 022 lab+bet/laboratorium+et/bro+n';
stamerTopic: Topic 'brian stamer';
ratTopic: Topic 'råtta+n/råttor+na';
plisnikTopic: Topic 'plisnik';
scottTopic: Topic 'scott';
jayTopic: Topic 'jay santoshnimoorthy';
turboTopic: Topic 'turbo kraftdjur+et';
windTunnelTopic: Topic 'guggenheim vind hyperhastighetschock|tunnel+n/hyperhastighets|tunnel+n';
guggenheimTopic: Topic 'guggenheim';
galvaniTopic: Topic 'projekt 2 galvani/galvani-2';
explosionTopic: Topic 'explosion+en';
jobNumberTopic: Topic 'jobbnummer/jobbnumret';
ipAddressesTopic: Topic 'ip-adress+en/ip-adresser+na';

jobTopic: Topic 'mitt ditt jobb+et';
bossTopic: Topic 'min din vice chef/vd/president/v.d.';
productsTopic: Topic
    'omegatron omegatrons företagets min din produkt+en/produkter+na';
bureaucracyTopic: Topic
    'omegatron omegatrons företagets byråkrati+n';
otherJobOffersTopic: Topic 'andra jobberbjudande+t/erbjudanden+a';
startupsTopic: Topic 'start-up startup+en företag´+et/företag+en/start-ups/startups';

supplyRoomTopic: Topic 'förråd+et förrådsrum+met knappsats+en rum+met/dörr+en/lås+et';

eeTextbookRecTopic: Topic
    '(ee) (et) (elektroteknik+en) bok+en böcker+na läroböcker+na (rekommendationer+na)';
eeLabRecTopic: Topic
    '(ee) (et) (elektroteknik+en) lab+bet laboratorium+et manual+en (rekommendationer+na)';

physicsTextTopic: Topic
    'kvantfysik+en text+en bok+en/böcker+na/text+ten/texter+na/lärobok+en/läroböcker+na';
eeTextTopic: Topic
    'ee et elektroteknik+en text bok+en/böcker+na/text+ten/texter+na/lärobok+en/läroböcker+na';
labManualTopic: Topic 'ee et elektroteknik elektroteknisk labb|manual+en';
drdTopic: Topic
    'drd matte matematik+en matematiska funktioner+na/tabell+en/tabeller+na/handbok+en/bok+en'
;

quantumComputingTopic: Topic 'kvantdatorer+na/kvantdator+n';
qubitsTopic: Topic 'qubits programmeringsspråk+et/qubit/qubits';

videoAmpTopic: Topic 'videoförstärkare+n/förstärkare+n';
waveformTopic: Topic 'vågformer+na';
the1a80Topic: Topic '1a80 cpu';
hovarthTopic: Topic 'hovarth+s hovarth|tal+et/hovarth|tal+en/hovarth|funktion+en/hovarth|funktioner+na';
programmingHovarthTopic: Topic
    'programmering (hovarth) (tal+en)/(tal+et)/(funktion+en)/(funktioner+na)';

lostQuarterTopic: Topic 'förlora:t+de mynt+et';

lunchTopic: Topic 'lunch+en';

bloemnerTopic: Topic
    'av blomner bloemner bl\u00F6mner blomners bloemners bl\u00F6mners
    introduktion till kvantfysik
    text+en bok+en/böcker+na/text+en/texter+na/lärobok+en/läroböcker+na';
sAndP3Topic: Topic
    'science&progress s&p science & progress tidskrift+en
    num:mer+ret xlvi-3';
sAndPTopic: Topic
    'science&progress s&p science & progress tidskrift nummer numret -';
qrlTopic: Topic
    'quantum review letters qrl nummer numret utgåva+n volym+en tidskrift+en/brev+et/qrl';
qrlVolumeTopic: Topic
    'quantum review letters qrl nummer numret utgåva+n 70 73 volym+en
    tidskrift+en/brev+et/qrl';
qrl7011cTopic: Topic 'quantum review letters qrl nummer numret utgåva+n 70:11c';
qrl739aTopic: Topic 'quantum review letters qrl nummer numret utgåva+n 73:9a';
morgenTopic: Topic
    'yves morgen elektronikföreläsningar text+en
    bok+en/böcker+na/text+en/texter+na/lärobok+en/läroböcker+na';
townsendTopic: Topic 'e.j. townsend lab+bet laboratorium+et manual+en';

efficiencyStudy37Topic: Topic '37+e effektivitets|studie+n';

/* ------------------------------------------------------------------------ */
/*
 *   A person who starts off unknown to the PC but can be introduced.  Once
 *   introduced, we refer to the person by proper name; before that, we can
 *   refer to them by description only, since we don't know their name yet.
 */
class IntroPerson: Person
    /* my proper name - this will replace our name when we're introduced */
    properName = nil

    /* have we been introduced yet? */
    introduced = nil
    
    /* mark the person as introduced */
    setIntroduced()
    {
        /* 
         *   once we're introduced, we refer to the person using the proper
         *   name in messages 
         */
        isProperName = true;
        name = properName;
        disambigName = properName;

        /* note that we're now introduced */
        introduced = true;
    }
;
    
/* ------------------------------------------------------------------------ */
/*
 *   Some inventory items we gain when we start the campus section.
 */

myKeyring: Keyring 'nyckel|ring+en' 'nyckelring'
    "Det är bara en enkel metallring du använder för att hålla i dina nycklar. "

    /* this item can go in my pocket, and that's where it naturally goes */
    okayForPocket = true
    bestForPocket = true

    /* 
     *   use an elevated affinity for my keys, so we prefer to put them on
     *   the keyring to putting them in a pocket 
     */
    affinityFor(obj) { return isMyKey(obj) ? 300 : 0; }

    /* 
     *   on taking the keyring, attach any keys in my pocket or in the tote
     *   bag, as long as the tote bag is open and in my possession 
     */
    getLooseKeys(actor)
    {
        local lst;

        /* inherit the default handling first to get my directly held keys */
        lst = inherited(actor);

        /* if it's 'me', add in what's in my pocket and tote bag */
        if (actor == me)
        {
            /* add what's in my pocket */
            lst += myPocket.contents;

            /* if we have the tote bag, and it's open, add its contents */
            if (toteBag.isIn(actor) && toteBag.isOpen)
                lst += toteBag.subContainer.contents;
        }

        /* return what we found */
        return lst;
    }
;

/* all of the keys in the game are suitable for pocketing */
class DitchKey: Key
    okayForPocket = true
    bestForPocket = true
;

+ DitchKey 'hus|nyckel+n/(hus)*nycklar+na' 'husnyckel'
    "Det är nyckeln till ditt hus. "
;

/* special precondition for closing the wallet if we're pocketing it */
walletClosedInPocket: objClosed
    checkPreCondition(obj, allowImplicit)
    {
        /* 
         *   if we're pocketing the wallet, inherit the objClosed handling;
         *   if it's going anywhere else, we have nothing to enforce 
         */
        if (gIobj == myPocket)
            return inherited(obj, allowImplicit);
        else
            return nil;
    }

    verifyPreCondition(obj)
    {
        /* if we're pocketing the wallet, apply the default handling */
        if (gIobj == myPocket)
            inherited(obj);
    }
;

myWallet: BagOfHolding, Openable, RestrictedContainer
    'brun+a läder|plånbok+en/läder|börs+en' 'plånbok'
    "Det är en enkel brun läderplånbok. "
    owner = me

    /* putting the wallet in my pocket requires the wallet to be closed */
    dobjFor(PutIn) { preCond = ([walletClosedInPocket] + inherited) }

    /* opening the wallet requires holding it */
    dobjFor(Open) { preCond = (inherited + objHeld) }

    /* start closed */
    initiallyOpen = nil

    /* restrict our contents to walletable items */
    canPutIn(obj) { return obj.okayForWallet; }
    cannotPutInMsg(obj) { return 'Du gillar inte att stoppa din plånbok 
        full med diverse skräp. '; }

    /* 
     *   We have a high affinity for walletable items, but only if we're
     *   already open.  If we're closed, don't bother trying to accept
     *   items, since we might have to take it out of the pocket to open
     *   it, which could cause a cascade of other hands-freeing operations.
     *   Better to avoid these and just let the walletable item go directly
     *   in the pocket, since we're allowed to pocket walletable items
     *   directly.
     *   
     *   Use an especially high affinity when we're open and the object is
     *   walletable.  This ensures that we'll prefer to put walletable
     *   items in the wallet rather than directly in the pocket when
     *   possible, even though walletable items are also pocketable.  
     */
    affinityFor(obj) { return isOpen && obj.okayForWallet ? 300 : 0; }

    /* this item naturally belongs in our pocket */
    okayForPocket = true
    bestForPocket = true
;

class WalletItem: Thing
    /* these are all okay for the wallet */
    okayForWallet = true

    /* these are also directly pocketable */
    okayForPocket = true

    /* 
     *   Because this kind of thing is small, we need to be holding it to
     *   show it to someone, and it has to be visible.  Don't actually
     *   require holding it, though, since this would needlessly take it
     *   out of the wallet; instead, just require that we can touch it, so
     *   that we at least know we could in theory take it out and put it
     *   away again.  
     */
    dobjFor(ShowTo) { preCond = [objVisible, touchObj]; }
;

+ alumniID: WalletItem 'alumni|kort+et/id-|kort+et/id|kort+et/identifikation^s+kort+et/alumn+kort+et' 'alumni ID-kort'
    "Detta kort identifierar dig som en Caltech-alumn. "
    owner = me
;

+ cxCard: WalletItem 'consumer express cumex företag:et^s+kredit:en+kort+et/kredit|kort+et'
    'Consumer Express-kort'
    "Omegatron valde Consumer Express som företagskreditkort
    eftersom det var det billigaste, utan tvekan, och ignorerade den obekväma
    praktiska detaljen att knappt någon accepterar det. "
    owner = me
;

+ driverLicense: WalletItem
    'kalifornien kalifornisk:t+a körkort+et/förarbevis+et/foto+t/fotografi+et'
    'körkort'
    "Detta är ditt kaliforniska körkort, komplett med ett ögonen-stängda
    foto. "
    owner = me
;

/*
 *   Our tote bag, which we carry around everywhere on campus.  This is a
 *   "bag of holding," which means that we can stuff practically anything
 *   into it, and that we'll automatically put items into the bag whenever
 *   our hands get full (provided we're still carrying the bag).
 *   
 *   To allow hands-free use of the bag, we'll make the bag wearable;
 *   we'll give the bag a shoulder strap so that this makes sense.
 *   Because we need the strap to be a component attached to the outside
 *   of the bag, rather than inside the bag, we need to make the bag a
 *   "complex container."  This means that the bag has a secret inner
 *   container, called its "subContainer," that actually holds the bag's
 *   contents.  
 */
toteBag: BagOfHolding, Wearable, ComplexContainer 'tyg+et axel|väska+n/tyg|kasse+n' 'tygkasse'
    "Du tar alltid med dig denna tygkasse när du reser. Den är gjord av ett
    tåligt, flexibelt syntetmaterial, och den expanderar för att rymma nästan
    vad som helst. <<
      isWornBy(me)
      ? "Väskan hänger för närvarande över din axel med sin rem. "
      : "En rem låter dig bära den över axeln. ">> "

    subContainer: ComplexComponent, OpenableContainer {
        /* 
         *   Since the tote bag will tend to become rather full, list its
         *   contents separately rather than in-line; the in-line form of
         *   the list becomes pretty unwieldy when we contain a lot of
         *   items.  
         */
        contentsListedSeparately = true
    }

    dobjFor(Wear)
    {
        action()
        {
            /* do the normal work */
            inherited();

            /* if this isn't an implied action, add an explanation */
            if (!gAction.isImplicit)
                "Du slänger väskan över axeln. ";
        }
    }
;
+ Component '(tyg+et) (kasse+n) vadderad+e axelrem+men' 'axelrem'
    "Det är en vadderad rem som låter dig bära väskan över en
    axel. "
;

+ Readable 'snabbreferens+en karriärcenter kontor+et information:en^s+blad+et'
    'informationsblad'
    "<i>Caltech Karriärcenter</i>
    <.p>Tack för ditt intresse för rekrytering på campus på Caltech.
    Detta är en snabbreferens för att hjälpa till att säkerställa att 
    ditt besök blir smidigt och produktivt.
    <.p>När du anländer till campus, kom förbi Karriärcentret.
    Vi finns i Student Services-byggnaden på S. Holliston Ave., på
    första våningen&mdash;vänligen se den bifogade kartan över campus
    om du har problem att hitta oss. När du kommer hit, checka in
    hos vår personal så visar vi dig till din intervjuplats.
    <.p>Vi är här för att säkerställa att ditt besök är produktivt för både
    ditt företag och våra studenter. Om det finns något vi kan göra för att
    göra ditt besök mer framgångsrikt, låt oss veta.
    <.p>Med vänliga hälsningar,
    \n<i>personalen på Caltech Karriärcenter</i> "

    /* this is inside the bag's subContainer */
    subLocation = &subContainer
;

/*
 *   A map of the campus, showing where each building is.  The player can
 *   use the map to get directions to a building by typing FIND <building>
 *   ON MAP.
 *   
 *   We include a map to address the potential gap between the player
 *   character's knowledge and the player's.  The PC is a Caltech alum, so
 *   he knows the campus well enough that he wouldn't need this map.  We
 *   can't assume the same thing about the player, though - the player
 *   might never even have heard of Caltech.  (And even if the player were
 *   a Caltech alum, they still might want a map, because the campus
 *   depicted in the game isn't entirely realistic,) So, we somehow need to
 *   give the player access to the knowledge of the (fake) campus that the
 *   PC has.
 *   
 *   There are several ways we could have solved this problem:
 *   
 *   - Show a JPEG graphical map of the campus on-screen during the game.
 *   There are a couple of huge drawbacks with this approach, though.
 *   First, it would only work on the full HTML interpreters, so we'd have
 *   to provide an alternative for players using text-only terps.  Second,
 *   I personally dislike the subjective experience of playing a game
 *   that's mostly text with occasional graphics.  A game that mixes
 *   graphics and text destroys my ability to become immersed in a verbal
 *   frame of mind by constantly drawing my attention to my physical
 *   senses, which in turn reminds me that I'm reading text.  And once I
 *   start looking at graphics, I want to see graphics of everything; it
 *   starts to feel like the game is hiding the graphics from me when it
 *   selectively shows pictures for some things but not for others.
 *   
 *   - Provide an ASCII-graphics map.  This would address the text-only
 *   interpreter problem above, but it has exactly the same problems with
 *   immersion, because it forces the player to shift mental gears just
 *   like a real picture does.  Plus, ASCII graphics tend to look pretty
 *   cheesy.
 *   
 *   - Provide a graphical map of the campus as part of the game's
 *   "feelies" package (as PDF, say).  This solves the problem above with
 *   text-only interpreters, but it has all of the same problems with
 *   mixing graphical and verbal "mental modes."  I also find it quite
 *   jarring when a game employs "extrasomatic" props; when a game tells
 *   you something like "please refer to the campus map enclosed with your
 *   game package," it destroys my sense of immersion by calling explicit
 *   attention to the fact that I'm playing a game.  The more
 *   self-contained the game world is, the more immersive I find it.
 *   
 *   - Let the player find their way around by exploration.  This would
 *   have been marginally acceptable, since the campus setting isn't that
 *   complex, but I think it would have robbed the game of a certain
 *   momentum early on.  In the early parts of the game, the player
 *   character has specific goals that require going to specific places
 *   that the PC is depicted as being very familiar with.  If we were to
 *   force the player to wander around to find these things the PC is
 *   supposedly already familiar with, it would create a weird disconnect
 *   between the story and the action.  Now, the player could choose to
 *   wander around and explore anyway, but that would be their choice, so
 *   there'd be no reason for them to feel any incongruity; but we don't
 *   want to force a player who just wants to get on with the story to
 *   stumble around making a map.
 *   
 *   - Find an excuse to give directions within the game.  I actually
 *   experimented with that at first, by having Ms. Dinsdale give Frosst a
 *   list of turns to make to get to Dabney; the stack instructions could
 *   likewise have given directions to Bridge.  But this felt a bit forced;
 *   in real life, Ms. Dinsdale would have just handed Frosst a map and
 *   said "go here," pointing to #58.  (This is actually what motivated me
 *   to put the map in the game: I did the "what would really happen?"
 *   thought experiment, and this is clearly what would happen in real
 *   life.)
 *   
 *   - Provide a GO TO command: GO TO DABNEY HOUSE, GO TO BRIDGE LAB.  This
 *   would essentially give the player a way to tap into the PC's knowledge
 *   automatically.  This would have made sense from a story perspective,
 *   and overall it's really not a bad approach, but I ultimately decided
 *   against it for a couple of reasons.  First, it's not a conventional IF
 *   command.  That's not a showstopper, certainly, but it's a point
 *   against this approach.  Second, and more importantly, it creates an
 *   odd user interface in which a single command performs multiple travel
 *   steps.  This is the part of the UI that I really don't like.  If we do
 *   a LOOK at each stop along the way, as we would for a single travel
 *   step, we could have pages and pages of output; if we didn't do a LOOK
 *   at each step, we could omit some crucial detail.  In either case, the
 *   player might miss something because we showed too much or too little
 *   output.  I think it's important in text IF design to keep the level of
 *   detail of interaction consistent.  A GO TO command would obviously
 *   create a level of interaction detail substantially different from
 *   ordinary travel commands.  Third, my personal experience playing games
 *   with things similar to GO TO commands is that this approach actually
 *   makes it very difficult to learn the layout of the game world.  The
 *   (usually quick) learning process of traversing the directions manually
 *   just doesn't happen when the game is doing the work for you, and as a
 *   result, your mind's eye doesn't seem to be able to put together a
 *   clear picture of the game world.  So I'd prefer to give the player the
 *   tools to find their way around easily, but still let the player carry
 *   out the individual steps of the travel manually.  For authors who do
 *   like the idea of a GO TO command, note that the implementation here
 *   could be adapted pretty easily for use in a GO TO command, since this
 *   code has to do all the work of finding the path between two points;
 *   the only thing you'd have to do is execute the series of nested
 *   commands necessary to carry out the travel.
 *   
 *   The solution that seems best to me is to include this *narrated* map.
 *   The map fits into the narration style of the rest of the game - its
 *   appearance is described textually, not included as a graphic.  There's
 *   a perfectly good reason in the context of the story for the map to be
 *   in the PC's inventory: the Career Center Office would certainly send a
 *   campus map to a recruiter coming to campus.  Interacting with the map
 *   is achieved with a convention well established in text IF,
 *   specifically "consultation."  So the map fits well into the game in
 *   terms of both story and user interface, and solves the problem we set
 *   out to solve: it gives the player the same effective familiarity with
 *   the campus that the PC has.  
 */
+ campusMap: Consultable '(caltech) (cal) (tech) campus|karta+n' 'campuskarta'
    "Det är en schematisk karta som visar placeringen av campus huvudbyggnader. 
    Du känner förstås till campus från dina dagar här som student, men det är 
    ändå värt att ha en karta ifall något har förändrats på sistone. Om du 
    behöver gå någonstans obekant kan du bara slå upp det på kartan. "

    /* this is inside the bag's subContainer */
    subLocation = &subContainer

    /*
     *   Note that we implement a custom ConsultAbout handler, rather than
     *   using the standard topic database mechanism.  There's a special
     *   kind of topic we recognize, so rather than making a database of
     *   match association objects, we just look for our topics directly.
     *   We could have used the topic database scheme, but this would
     *   require us to create a separate ConsultTopic object for each
     *   CampusMapEntry object, which in this case is unnecessary
     *   duplication.  
     */
    dobjFor(ConsultAbout)
    {
        /* we have to be holding the map to find something on it */
        preCond = [objHeld]
        action()
        {
            local lst;
            local dst;
            local loc;
            local path;

            /* note the consultation */
            gActor.noteConsultation(self);

            /* get the topic matches */
            lst = gTopic.inScopeList;

            /* make sure we have at least one match to the topic phrase */
            if (lst.length() == 0)
            {
                "Du kan inte hitta något på kartan med det namnet. ";
                return;
            }

            /* pick the entry with the highest match strength */
            dst = lst[1];
            foreach (local cur in lst)
            {
                /* if this one has a higher match strength, use it */
                if (cur.mapMatchStrength > dst.mapMatchStrength)
                    dst = cur;
            }

            /* if we have more than one match, note which one we picked */
            if (lst.length() > 1)
                "<.assume><<dst.name>><./assume>\n";

            /* mention where it is */
            dst.desc;

            /* if it's not in the game, say that it's not important */
            if (!dst.isInGame)
                "Du har egentligen ingen anledning att gå dit just nu, och
                hur gärna du än skulle vilja utforska, påminner du dig själv om att
                fokusera på uppgiften du har framför dig. ";

            /* 
             *   in any case, if there's no location, we can't give
             *   directions, so we're done 
             */
            if (dst.location == nil)
                return;

            /* find the nearest enclosing campus outdoor location */
            for (loc = gActor.location ; loc != nil ; loc = loc.location)
            {
                /* if this is an outdoors location on campus, we're set */
                if (loc.ofKind(CampusOutdoorRoom))
                    break;
            }

            /* if we're not outdoors on campus, we can't navigate from here */
            if (loc == nil)
            {
                "(Kartan visar bara platserna av byggnaderna, inte 
                interiöra planlösningar, så du behöver gå ut och orientera 
                dig om du vill hitta vägen dit.) ";
                return;
            }

            /* if we're already there, just say so */
            if (dst.location == loc || dst.altLocations.indexOf(loc) != nil)
            {
                "Det ser ut på kartan som det borde vara precis här ";
                return;
            }

            /* compute the path */
            path = campusMapPathFinder.findPath(gActor, loc, dst.location);

            /* if we found the path, show it */
            if (loc.propDefined(&cannotUseMapHere))
            {
                /* 
                 *   this location has a special reason that the map can't
                 *   be used here - show it 
                 */
                loc.cannotUseMapHere;
            }
            else if (path != nil)
            {
                local idx;
                
                /*
                 *   Each map entry can represent more than one game
                 *   location.  For example, the Olive Walk spans several
                 *   rooms, and any of them should be considered the olive
                 *   walk for path-finding purposes.  Find the first entry
                 *   in the path list that appears as an alternative
                 *   location for the destination, and cut off the list at
                 *   that point.  
                 */
                if ((idx = path.indexWhich(
                    {p: dst.altLocations.indexOf(p) != nil})) != nil
                    && idx < path.length())
                {
                    /* 
                     *   'idx' is the first entry that can be considered
                     *   our destination, so truncate the list there 
                     */
                    path.removeRange(idx + 1, path.length());
                }

                /* show the path */
                "För att ta sig dit härifrån, så skulle du behöva gå ";
                for (local i = 2, local len = path.length() ; i <= len ; ++i)
                {
                    local prv = path[i-1];
                    local cur = path[i];

                    /* find the direction to get from 'prv' to 'cur' */
                    local dir = directionFromTo(prv, cur);

                    /* show the direction if we found one */
                    if (dir != nil)
                        "<<dir.name>> ";
                    else
                        "sen ";

                    /* add the destination name */
                    "till <<cur.getDestName(gActor, prv)>>";

                    /* add appropriate list separation */
                    if (i == len - 1)
                        ", och ";
                    else if (i < len)
                        ", ";
                }
                ". ";

                /* remember the current destination and the path there */
                lastDest = dst;
                lastPath = path;
                lastPathIdx = 1;
            }
            else
            {
                /* 
                 *   this shouldn't ever happen, since every outdoor
                 *   location on our rendition of the campus is connected
                 *   to every other outdoor location, but just in case...  
                 */
                "Du kan inte avgöra från kartan hur du kan ta dig dit härifrån. ";
            }
        }
    }

    /* find the direction of the connector from 'a' to 'b' */
    directionFromTo(a, b)
    {
        /* scan each possible direction for a matching connector */
        return Direction.allDirections.valWhich(new function(d)
        {
            local conn = a.getTravelConnector(d, gActor);
            return (conn != nil
                    && conn.isConnectorListed
                    && conn.getDestination(a, gActor) == b);
        });
    }

    /* 
     *   The last destination we looked up, the path there, and the index
     *   of our current position in the path.  As we travel from here,
     *   we'll follow along; if they stay on the path, we'll provide
     *   updates on the next direction to go at each point. 
     */
    lastDest = nil
    lastPath = nil
    lastPathIdx = nil

    /*
     *   Check to see if we can continue from our current location to the
     *   last destination we looked up.  If we're still on the path, we'll
     *   show how to continue; otherwise, we'll assume they've wandered
     *   off, so we'll forget about trying to provide directions.  
     */
    continueToDestination()
    {
        /* if it's an NPC traveling, it's obviously not relevant */
        if (!gActor.isPlayerChar)
            return;

        /* 
         *   if the PC is traveling, and we have a working destination,
         *   and we're in the next location on the path we calculated,
         *   show how to get to the next location from here 
         */
        if (lastDest != nil
            && lastPathIdx + 1 <= lastPath.length()
            && me.isIn(lastPath[lastPathIdx + 1]))
        {
            /* note that we're in the next location now */
            ++lastPathIdx;

            /* 
             *   if we're at the end of the path, say so; otherwise, show
             *   how to continue 
             */
            if (lastPathIdx == lastPath.length())
            {
                "<.p>Det ser ut som om du har anlänt till <<lastDest.name>>. ";
            }
            else
            {
                /* get the direction name */
                local dir = directionFromTo(lastPath[lastPathIdx],
                                            lastPath[lastPathIdx + 1]);

                /* show how to continue */
                if (dir != nil)
                    "<.p>För att fortsätta till <<lastDest.name>>, ser det ut som 
                    du ska gå <<dir.name>> härifrån. ";
            }
        }
        else
        {
            /* 
             *   we must have gone off the path, or reached the
             *   destination; we're no longer on a path, so clear out the
             *   navigation memory 
             */
            lastDest = nil;
        }
    }

    /*
     *   Resolve the topic.  Only CampusMapEntry objects can be found on
     *   the map, so limit the resolved topic to these. 
     */
    resolveConsultTopic(lst, np, resolver)
    {
        /* keep only CampusMapEntry objects in the resolved topic list */
        lst = lst.subset({x: x.obj_.ofKind(CampusMapEntry)});

        /* return a ResolvedTopic with the map entries */
        return new ResolvedTopic(lst, [], [], np);
    }
;

/*
 *   A path finder for the campus map.  We only include outdoor campus
 *   rooms in the map, since the map doesn't cover the insides of buildings
 *   or non-campus locations.  
 */
campusMapPathFinder: roomPathFinder
    /* include only campus outdoor rooms in the map */
    includeRoom(loc) { return loc.ofKind(CampusOutdoorRoom); }
;

/*
 *   A class for campus map building entries.  This is simply a Topic for a
 *   named building on the campus map.  For convenience in defining the
 *   map, we can associate each of these with a CampusOutdoorRoom on the
 *   game map, using the 'location' property of the map entry to put the
 *   map entry inside its associated campus outdoor room.  If an entry has
 *   no associated room, then it's there for completeness only and can't be
 *   used as a navigation destination.  
 */
class CampusMapEntry: Topic
    /* the associated CampusOutdoorRoom, if any */
    location = nil

    /* are we in the game? we are if we have a location */
    isInGame = (location != nil)

    /* alternative set of locations that are also considered to be here */
    altLocations = []

    /* the full name */
    name = nil

    /* 
     *   The description of the general location of the building on
     *   campus.  We'll report this when the player looks up the building
     *   on the map.  By default, we'll report that it's in the quadrant
     *   defined for the building.  
     */
    desc = "Du skannar kartan och hittar <<name>> i den <<quadrant>> delen
        av campus. "

    /*
     *   The "quadrant" of the campus containing the building.  This is
     *   used by the default 'desc' to describe roughly where the building
     *   is.  If 'desc' is customized so that it doesn't refer to the
     *   quadrant, this won't be needed.  
     */
    quadrant = 'centrala'

    /* all of these are known by virtue of appearing on the map */
    isKnown = true

    /* 
     *   Match strength of this map entry.  In cases of ambiguous matches,
     *   we'll take the one with the highest match strength. 
     */
    mapMatchStrength = 100
;

CampusMapEntry template 'vocabWords' 'name' 'quadrant' | "desc";

/* ------------------------------------------------------------------------ */
/*
 *   Map entries for various Dabney locations.  We don't need a map for
 *   these, but the player might not know where things are, so this is a
 *   fairly natural way for us to reveal PC knowledge to the player.  
 */
class DabneyMapEntry: CampusMapEntry
    vocabWords = 'dabney house hovse -'
    desc = "Campuskartan är inte tillräckligt detaljerad för att visa den inre
        planlösningen av Dabney, men efter fyra års boende där
        vet du var <<name>> är: <<subdesc>>. "

    /* 
     *   all of these are in the game map, even though we don't give
     *   specific directions to them 
     */
    isInGame = true
;

DabneyMapEntry template 'vocabWords' 'name' "subdesc";

DabneyMapEntry '1+a gränd+en ett' 'Gränd Ett'
    "norr om arkadgången, som är precis väster om innergården"
;
DabneyMapEntry '2+a gränd+en två' 'Gränd Två'
    "en trappa upp från Alley Ett"
;
DabneyMapEntry '3+e gränd+en tre' 'Gränd Tre'
    "precis vid innergården, åt sydväst"
;
DabneyMapEntry '4+e gränd+en fyra' 'Gränd Fyra'
    "en trappa upp från Alley Tre"
;
DabneyMapEntry '5+e gränd+en fem' 'Gränd Fem'
    "precis vid innergården, åt sydost"
;
DabneyMapEntry '6+e gränd+en sex' 'Gränd Sex'
    "en trappa upp från Alley Fem"
;
DabneyMapEntry '7+e övre lägre gränd+en sju' 'Gränd Sju'
    "en trappa upp från innergården"
;
DabneyMapEntry 'innergård+en ' 'innergården'
    "i mitten av huset, precis innanför Orange Walk"
;
DabneyMapEntry 'sällskapsrum+met' 'sällskapsrummet'
    "precis vid innergården, åt öster"
;
DabneyMapEntry 'matsal+en' 'matsalen'
    "norr om sällskapsrummet"
;

/* ------------------------------------------------------------------------ */
/* 
 *   Define a bunch of map points that aren't part of the game world.
 *   These will show up on the campus map for completeness, but they're
 *   not associated with anything in the game map.  We can look these up,
 *   but the mapper won't be able to generate routes to these for obvious
 *   reasons; we'll simply say that we're not interested in going there if
 *   asked for a route.  
 */
CampusMapEntry 'alles laboratorium+et/lab+bet' 'Alles Laboratorium' 'sydväst';
CampusMapEntry 'alumni alumnihus+et/house' 'Alumnihuset' 'nordost';
CampusMapEntry 'arms laboratorium+et/labb+et' 'Arms Laboratorium' 'sydväst';
CampusMapEntry 'avery center/centret' 'Avery Center' 'norr';
CampusMapEntry 'baxter hall' 'Baxter Hall' 'norr';
CampusMapEntry 'beckman+s institute institut+et' 'Beckmaninstitutet' 'nordväst';
CampusMapEntry 'beckman+s beteende|vetenskap labb+et/labb+en/laboratorie+t/laboratorier' 
    'Beckmans Laboratorier för Beteendevetenskap' 'norr';
CampusMapEntry 'beckman+s kemisk+a syntes laboratorium+et/lab+bet'
    'Beckmans Laboratorium för Kemisk Syntes' 'sydväst';
CampusMapEntry 'blacker house/hovse' 'Blacker House' 'sydost';
CampusMapEntry 'braun athletic atletiska center/centret/gym+met' 'Braun Athletic Center'
    "Det ligger på södra sidan av California Blvd. ";
CampusMapEntry 'braun house' 'Braun House' 'öst';
CampusMapEntry 'braun laboratorium+et/lab+bet/laboratorium+men/laboratorier'
    'Braun Laboratorier' 'väst';
CampusMapEntry 'catalina+s forskar|boende+t'
    'Catalina Forskarboende' 'nordväst';
CampusMapEntry 'central+a ingenjörs|tjänster'
    'Centrala Ingenjörstjänster' 'nordost';
CampusMapEntry 'central+a anläggning+en' 'Centrala Anläggningen'
    "Den ligger på södra sidan av California Blvd. ";
CampusMapEntry 'chandler matsal+en' 'Chandler Matsal' 'öst';
CampusMapEntry 'church lab+bet/laboratorium+et' 'Church Laboratorium' 'sydväst';
CampusMapEntry 'crellin lab+bet/laboratorium+et' 'Crellin Laboratorium' 'sydväst';
CampusMapEntry '(dabney) hall/humanities/humaniora' 'Dabney Hall' 'sydväst'
    desc = "Förvirrande nog har campus två byggnader som heter
        Dabney: Dabney Hall of the Humanities, som är en akademisk
        byggnad full av klassrum och fakultetskontor, och Dabney
        House, studentbostaden.
        <.p><<inherited>>"
;
CampusMapEntry '(dabney) (dabneys) gardens/trädgård+ar' 'Dabney Gardens' 'sydväst';
CampusMapEntry '(holliston) parkeringshus+et/parkering+en' 'Holliston parkeringshus' 'nordost';
CampusMapEntry 'center centret industriella relationer+na'
    'Centret för Industriella Relationer' 'nordost';
CampusMapEntry 'isotop|hantering+en/lab+bet/laboratoriet/laboratorium+et'
    'Laboratoriet för Isotophantering' 'sydväst';
CampusMapEntry 'karman+s lab+bet/laboratoriet/laboratorium+et' 'Karman Laboratorium' 'söder';
CampusMapEntry 'keck+s lab+bet/laboratorium/laboratorier' 'Keck Laboratorier' 'centralt';
CampusMapEntry 'keith+s spalding|byggnaden/spalding-|byggnaden'
    'Keith Spalding-byggnaden' 'sydost';
CampusMapEntry 'kellogg+s strålning strålnings|lab+bet/strålnings|laboratorium+et'
    'Kellogg Strålningslaboratorium' 'sydväst';
CampusMapEntry 'kerckhoff+s lab+bet/laboratorium/laboratoriet/laboratorier+na'
    'Kerckhoff Laboratorier' 'sydväst';
CampusMapEntry 'marks house/hus+et' 'Marks House' 'öst';
CampusMapEntry 'mead mjöd+et lab+bet/laboratorium+et' 'Mead Laboratorium' 'nordväst';
CampusMapEntry 'mekanisk+a universum+et' 'det Mekaniska Universumet' 'nordost';
CampusMapEntry 'projekt matematik+en' 'Projekt MATEMATIK!' 'nordost';
CampusMapEntry 'moore lab+bet/laboratorium+et' 'Moore Laboratorium' 'norr';
CampusMapEntry 'morrisroe astrovetenskap lab+bet/astrovetenskaps|laboratorium+et'
    'Morrisroe Astrovetenskapslaboratorium'
    "Det ligger på södra sidan av California Blvd., ute vid löparbanan. ";
CampusMapEntry 'north mudd norr+a lab+bet/laboratorium+et'
    'North Mudd Laboratorium' 'sydväst';
CampusMapEntry 'noyes lab+bet/laboratorium+et' 'Noyes Laboratorium' 'nordväst';
CampusMapEntry 'parsons-gates administration+hall+en'
    'Parsons-Gates Administrationshall' 'sydväst';
CampusMapEntry 'powell-booth lab+bet/laboratorium+et'
    'Powell-Booth Laboratorium' 'centralt';
CampusMapEntry 'offentlig+a evenemang+en evenmangs biljettkontor+et/biljettkontoren+a'
    'Biljettkontoret för Offentliga Evenemang' 'nordväst';
CampusMapEntry 'pr pr-|avdelning+en' 'PR-avdelningen' 'nordost';
CampusMapEntry 'medie+relationer+na' 'Medierelationer' 'nordost';
CampusMapEntry 'besöks|centret|besöks|centrum+et' 'Besökscentret' 'nordost';
CampusMapEntry 'robinson+s lab+bet/laboratorium+et' 'Robinson Laboratorium' 'sydväst';
CampusMapEntry 'sherman fairchild (library) (bibliotek+et)'
    'Sherman Fairchild-biblioteket' 'söder';
CampusMapEntry 'sloan+s lab+bet/laboratorium+et' 'Sloan Laboratorium' 'sydväst';
CampusMapEntry 'south mudd lab+bet/laboratorium+et'
    'South Mudd Laboratorium' 'sydväst';
CampusMapEntry 'spalding lab+bet/laboratorium+et' 'Spalding Laboratorium' 'söder';
CampusMapEntry 'steele+s house' 'Steele House' 'nordost';
CampusMapEntry 'steele+s lab+bet/laboratorium+et' 'Steele Laboratorium' 'norr';
CampusMapEntry 'teaterkonst+en/tacit' 'Teaterkonst' 'nordost';
CampusMapEntry 'watson+s lab+bet/laboratorium/laboratoriet/laboratorier'
    'Watson Laboratorier' 'norr';
CampusMapEntry 'wilson+s parkeringshus+et'
    'Wilson parkeringshus' 'väst';
CampusMapEntry 'winnett+s cent:er+ret/centrum+et' 'Winnett Center' 'söder';
CampusMapEntry 'red door röda dörr cafe+t' 'Red Door Café' 'söder';
CampusMapEntry 'unga hälsocenter/hälsocentret hälsocenter/hälsocentret' 'Unga Hälsocentret'
    "Det ligger på södra sidan av California Blvd. ";

/* ------------------------------------------------------------------------ */
/*
 *   Outdoor Room on the campus 
 */
class CampusOutdoorRoom: OutdoorRoom
    /* we have the normal ground, and the special pasadena sky */
    roomParts = [defaultGround, pasSky]

    /* 
     *   The cherry picker can travel to some outdoor rooms, so we need to
     *   describe the arrival when the PC drives it here.  Some rooms
     *   override this, but provide a default message for those that
     *   don't. 
     */
    descCherryPickerArrival = "Du hittar en avskild plats och
        parkerar skyliften. "

    /* 
     *   provide the cherry picker's specialDesc when the PC is in the
     *   cherry picker, and the cherry picker is in this location 
     */
    inCherryPickerSpecialDesc = "Du står i korgen på
        en skylift. "

    /* provide the specialDesc for the cherry picker when it's here */
    cherryPickerSpecialDesc = "En skylift är parkerad här. "

    /* note that the cherry picker basket has just been raised here */
    noteCherryPickerRaised = ""

    /*
     *   On arriving, check to see if we are continuing our journey to a
     *   location we previously looked up on the map, and provide advice
     *   on how to proceed if so. 
     */
    travelerArriving(traveler, origin, connector, backConnector)
    {
        /* do the normal work, which will display the room description */
        inherited(traveler, origin, connector, backConnector);

        /* check to see if we should offer continuing navigation advice */
        campusMap.continueToDestination();
    }
;

/*
 *   A class for our various doors for which we will never find a key.
 *   These are just limits of the map, but we want them to look like
 *   ordinary doors.  These are simply keyed lockables with no keys; the
 *   main reason for the extra class is to make it clear in the code which
 *   doors cannot ever be opened.  
 */
class AlwaysLockedDoor: LockableWithKey, Door
;

pasSky: defaultSky
    vocabWords = '(klar+a) (blå+a) orange-brun+a disig+a smog+en/dis+en/himle+n'
    desc()
    {
        /* 
         *   the smog starts around noon, so if we haven't reached an
         *   event that's noon or after yet, it's not yet smoggy 
         */
        if (clockManager.curTime[2] < 12)
            "Himlen är relativt blå och klar. Det är en varm, stilla
            dag, dock, så det kommer förmodligen bli smogigt på eftermiddagen. ";
        else
            "Smogen är inte så hemsk idag, men himlen har fått
            den där karakteristiska orange-bruna färgen och ser lite
            disig ut. ";
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   We have a few location that are or contain streets; crossing one of
 *   these has a standard response indicating that we just need to say
 *   which way to go.  
 */
class Street: object
    dobjFor(Cross)
    {
        verify() { }
        action() { "(Om du vill gå någonstans, säg bara vilken rikting du vill gå.) "; }
    }
;    

/* ------------------------------------------------------------------------ */
/*
 *   San Pasqual Street 
 */
sanPasqual: Street, CampusOutdoorRoom 'San Pasqual St.' 'San Pasqual'
    'San Pasqual-gatan'
    "Detta är slutet av en bred bostadsgata. Parkerade bilar kantar
    båda sidor av gatan, som fortsätter österut, ut i
    Pasadena. Gatan slutar här och blir en gångväg
    västerut, som leder djupare in på campus. Höga buskar längs
    södra sidan av gatan döljer delvis en mur, som omger
    baksidan av North Houses-komplexet. Holliston Ave., som
    slutar här i en T-korsning, fortsätter norrut. "

    vocabWords = 'san pasqual st./gata+n'
    isProperName = true

    north = spHolliston
    west = spWalkway
    east: FakeConnector { "Den vägen ligger Pasadena. Trevlig nog
        stad, men du bör ta hand om dina ärenden här först. " }

    atmosphereList: ShuffledEventList {
        [
            '',
            'En sliten gammal bil kör sakta förbi, uppenbarligen på jakt
            efter parkering. Föraren tittar åt ditt håll, utan tvekan hoppfull
            att du är på väg att sätta dig i en bil och åka. Hon kryper
            längs trottoarkanten ett tag, men efter en stund kör hon
            plötsligt iväg. ',
            'En polissiren rusar förbi på en av de närliggande gatorna. ',
            'En äldre man klädd i en skrikigt färgglad
            medeltida narrdräkt går förbi. '
        ]
        [
            'Två underhållskillar kör förbi, i ungefär tre kilometer
            per timme, i en av de där B&amp;G elektriska golfbilarna. ',
            'En bil kör förbi och letar efter parkering, men hittar ingen
            och åker därifrån. ',
            'En liten grupp studenter går förbi och går upp för
            Holliston. ',
            'Ett par som rastar sin hund promenerar förbi, på väg
            västerut in på campus. ',
            'En B&amp;G golfbil kör förbi med ett par
            stora metallsoptunnor. '
        ]
        eventPercent = 66
    }
;

+ CampusMapEntry 'san pasqual st./gata+n' 'San Pasqual St.' 'nordost';

+ Decoration 'parkera+e bil+en/bilar+na' 'parkerade bilar'
    "San Pasqual är en av de närmaste platserna till campus där det är
    möjligt att parkera en bil, men gatan är för kort för att rymma
    mer än ett tjugotal bilar. Bilarna tillhör förmodligen mestadels
    studenter. "
    isPlural = true
;

+ spHolliston: Street, PathPassage
    's. s söder södr+a holliston ave./avenue/aveny+n' 'Holliston'
    "Holliston är en annan bostadsliknande gata. Den slutar här
    i en T-korsning och fortsätter norrut. "

    isProperName = true

    /* 
     *   we mention in the room description that the Career Center Office
     *   is 'up' holliston... 
     */
    dobjFor(ClimbUp) asDobjFor(GoThrough)
;

+ spWalkway: PathPassage 'campus/gångväg+en/stig+en' 'gångväg'
    "Den asfalterade gångvägen leder djupare in på campus västerut. "

    /* we can't go this way until we've finished at the career center */
    canTravelerPass(trav) { return ccOffice.doneWithAppointment; }
    explainTravelBarrier(trav)
    {
        reportFailure('Hur gärna du än skulle vilja spendera lite tid med att titta
            runt på campus, behöver du verkligen ta dig till Career
            Center om du ska hinna till ditt möte. ');
    }
;

+ Decoration 'åtta fot hög+a betong north house+s 
    buske+n/buskar+na/mur+en/komplex+et' 'mur'
    "North Houses ligger på andra sidan av den åtta fot
    höga betongmuren, men allt du kan se härifrån är muren. "

    dobjFor(Climb)
    {
        verify() { }
        action() { "Det skulle verkligen inte spara mycket tid jämfört med att bara
            gå runt till Olive Walk, där du kan gå in
            genom huvudentrén. "; }
    }
    dobjFor(ClimbUp) asDobjFor(Climb)
;

/* ------------------------------------------------------------------------ */
/*
 *   Holliston Ave. 
 */
holliston: Street, CampusOutdoorRoom
    'Holliston Ave.' 'Holliston' 'Holliston Avenue'
    "Detta är en typiskt bred bostadsgata i Pasadena, som löper
    norrut och söderut. Baksidan av Physical Plants verkstad ligger
    i väster, och Studentservicebyggnaden ligger på östra sidan
    av gatan. "

    isProperName = true
    vocabWords = 'holliston ave./avenue/aveny+n'

    south = holSanPasqual
    east = cssLobby
    north: FakeConnector { "Det finns inte mycket mer av campus längre
        upp på Holliston---det finns de två nya studentbostäderna
        som byggdes för några år sedan, men du bör nog spara
        sightseeing till efter att du är klar med mer brådskande ärenden. " }
;

+ CampusMapEntry '(physical) (plant) verkstad+en'
    'Physical Plants verkstad' 'nordost';
+ CampusMapEntry 'studentservice karriär|center karriär|centret kontor+et byggnad+en/(kontor+et)'
    'Studentservice' 'nordost';
+ CampusMapEntry 's. s söder holliston ave./avenue/aveny+n'
    'Holliston Ave.' 'nordost';

+ holSanPasqual: Street, PathPassage ->spHolliston
    'san pasqual st./gata' 'San Pasqual-gatan'
    "Holliston slutar i en T-korsning med San Pasqual St.\ precis
    söder om här. "
    isProperName = true
;

+ Fixture 'baksida+n physical plant verkstad+en (lastning) butik+en/(kaj+en)/(kajer+na)/sida'
    'verkstad'
    "Det enda som syns på denna sida av verkstaden är
    lastkajerna. Inga lastbilar lastar just nu, så alla
    rullportar är stängda. "
;
++ Decoration 'lastkaj+en kajer+na (physical) (plant) (verkstad)
    rull|port+en/rull|portar+na/lastkajs|port+en/lastkajs|portar+na' 'lastkajsportar'
    "Lastkajsportarna är alla stängda. "
    isPlural = true
;

+ EntryPortal ->cssLobby 'studentservice byggnad+en/ingång+en/center+et/centret/centrum+et'
    'Studentservicebyggnaden'
    "Denna byggnad var ett hus för forskarstudenter när du var
    student, och den ser fortfarande ut mycket som ett studenthem: det är en kort,
    tre våningar hög, rektangulär betongbox med små fönster placerade
    med monotont regelbundna intervall längs väggen. En skylt vid
    ingången lyder <q>Studentservicecenter.</q> Du kan gå in
    åt öster. "
;
++ Readable, Decoration '(student) (service) (center) (byggnad+ens) skylt+en*skyltar+na'
    'skylt'
    "Den lyder helt enkelt: <q>Studentservicecenter.</q> "
;
++ Decoration '(student) (service) (byggnad) små sidohängda *fönster fönstren+a'
    'fönster'
    "De är små sidohängda fönster, placerade med jämna mellanrum. "
    isPlural = true
;

/* ------------------------------------------------------------------------ */
/*
 *   Center for Student Services lobby 
 */
cssLobby: Room 'Studentservice Lobby' 'Studentservice lobbyn' 'lobby'
    "En färgglad soffa och ett par stora krukväxter
    skänker lite glädje åt denna lilla lobby. Flera dörrar
    leder till angränsande rum: norrut finns en dörr märkt
    <q>Kontor för forskarstudier</q>; österut, en dörr märkt
    <q>Studentärenden</q>; och söderut, <q>Karriärcenter
    Kontor.</q> En dörröppning västerut leder ut till gatan. "

    vocabWords = 'studentservice lobby+n'

    north = cssDoorN
    south = cssDoorS
    east = cssDoorE
    west = holliston
    out asExit(west)
;

+ EntryPortal ->holliston 'dörr|öppning+en' 'dörröppning'
    "Dörröppningen leder ut till gatan. "
;

+ cssDoorN: AlwaysLockedDoor
    '"kontor för forskarstudier" kontor+et forskarstudier+na norr+a n dörr+en*dörrar+na'
    'norra dörren'
    "Den är märkt <q>Kontor för forskarstudier.</q> "
;

+ cssDoorE: AlwaysLockedDoor
    '"studentärenden" studentärenden öst+ra ö dörr+en*dörrar+na' 'östra dörren'
    "Den är märkt <q>Studentärenden.</q> "
;

+ cssDoorS: Door
    '"karriärcenter kontor" karriärcent:er+ret kontor+ret söder s+ödra dörr+en*dörrar+na'
    'södra dörren'
    "Den är märkt <q>Karriärcenter Kontor.</q> "
    initiallyOpen = true
;

+ Fixture, Chair
    'färgglad+a färgstark+a färgad+e soffa+n/säte+t/möbel+n*möbler+na'
    'soffa'
    "Det är en fullstor soffa klädd i tyg med slumpmässiga
    fläckar av starka färger. "

    /* allow four people at once on the sofa (a person's bulk is 10) */
    bulkCapacity = 40
;

+ Decoration 'stor+a grön+a lummig+a kruka+n/kruk|växt+en/träd+et/träd+en*krukväxter+na träden+a' 'krukväxter'
    "De är stora, gröna, lummiga träd i lerkrukor. "
    isPlural = true
;
+ Decoration 'ler|kruka+n*ler|krukor+na' 'lerkrukor'
    "Det finns inget anmärkningsvärt med dem; de är bara där
    för att hålla träden. "
    isPlural = true
;

/* ------------------------------------------------------------------------ */
/*
 *   San Pasqual walkway
 */
sanPasqualWalkway: CampusOutdoorRoom 'San Pasqual Gångväg'
    'San Pasqual-gångvägen' 'gångväg'
    "Denna breda asfalterade gångväg slingrar sig genom en välskött gräsmatta
    omgiven av campusbyggnader. Ingången till Jorgensens laboratorium är
    norrut, Physical Plants kontor ligger i nordost,
    och baksidan av Page House är i sydost.

    <.p>Gångvägen fortsätter västerut och gränsar till slutet av San
    Pasqual-gatan i öster. En smalare korsande gångväg leder
    söderut. "

    isProperName = true

    east = spwStreet
    west = spwWestWalk
    south = spwSouthWalk
    north = jorgensen
    northeast = ppOffice
    southeast: NoTravelMessage { "Det finns ingen ingång till
        byggnaden på denna sida. " }
;

+ CampusMapEntry 'jorgensen lab+bet/laboratorium+et'
    'Jorgensens Laboratorium' 'nordost'
;

+ CampusMapEntry 'b&g physical plant kontor'
    'Physical Plants kontor' 'nordost'
;

+ EntryPortal ->(location.northwest)
    'jorgensen fönsterlös+a betong+en exteriör+en/labb+et/laboratorium+et/ingång+en'
    'Jorgensens Lab'
    "Jorgensen är huvudbyggnaden för datavetenskap. Den har alltid
    sett vagt bekant ut en bunker för dig, förmodligen på grund av dess nästan
    fönsterlösa betongexteriör. Ingången är norrut. "
    isProperName = true
;

+ EntryPortal ->(location.north)
    'b&g physical plant plants kontor+et/byggnad+en/dörr+en/dörr+öppning+en'
    'Physical Plants kontor'
    "Physical Plant, även känt som Buildings and Grounds, även känt som B&amp;G, är
    avdelningen som underhåller campusinfrastrukturen. Denna
    blygsamma enplansbyggnad är där B&amp;G-cheferna
    har sina kontor. En dörröppning leder in. "
    isPlural = true
;

+ Immovable 'baksida+n page house studenthus+et/hörn+et' 'Page House'
    "Page är ett av studenthusen. Endast det bakre hörnet är
    synligt här; det finns ingen ingång på denna sida. "
    isProperName = true

    dobjFor(Enter) { verify() { illogical('Det finns ingen ingång till
        byggnaden på denna sida. '); } }
;

+ spwStreet: Street, PathPassage ->spWalkway
    'san pasqual st./gata' 'San Pasqual-gatan'
    "San Pasqual ligger precis österut. "
    isProperName = true

    canTravelerPass(trav) { return trav != cherryPicker; }
    explainTravelBarrier(trav)
    {
        "Bäst att inte köra skyliften utanför campus; den
        är säkert inte laglig att ha på gatan. ";
    }
;

+ spwSouthWalk: PathPassage ->quadNorthWalk
    'smalare korsande söder s+ödra gångväg+en/stig+en' 'korsande gångväg'
    "Den korsande gångvägen leder söderut. "
;

+ spwWestWalk: PathPassage ->blEastWalk
    'väst+ra v san pasqual gångväg+en' 'västra gångvägen'
    "Gångvägen sträcker sig västerut och öppnar sig mot San Pasqual-gatan i
    öster. "
;

+ Decoration 'välskött+a gräsig+a stor+a gräsmatta+n/gräs+et' 'gräsmattor'
    "Gräsmattorna är täckta med friskt grönt gräs. "
    isPlural = true
;

/*
 *   Create special noun phrase syntax for "Gunther the gardener" -
 *   normally, articles aren't allowed in the middle of a noun phrase like
 *   that. 
 */
grammar qualifiedSingularNounPhrase(gunther): 'gunther' 'trädgårdsmästaren'
    : SpecialNounPhraseProd

    /* we match only gunther */
    getMatchList = [gunther]

    /* get our "adjusted" tokens; make 'the' a miscellaneous word */
    getAdjustedTokens()
        { return ['gunther', &noun, 'trädgårdsmästaren', &noun]; }
;

/* ------------------------------------------------------------------------ */
/*
 *   The Physical Plant office
 */
ppOffice: Room 'Physical Plant Kontor' 'Physical Plant Kontoret'
    "En servicedisk delar detta lilla rum ungefär på mitten,
    där södra sidan är för kunder och norra sidan för
    anställda. En dörröppning i sydväst leder utomhus; på
    andra sidan disken leder en smal korridor norrut. "
    
    vocabWords = 'physical plant kontor+et'

    southwest = sanPasqualWalkway
    south asExit(southwest)
    out asExit(south)
    north = ppoHall
;

+ EntryPortal ->(location.out) 'sydväst+ra sv dörr+en/dörröppning+en' 'dörröppning'
    "Dörröppningen leder utomhus åt sydväst. "
;

+ Surface, Fixture 'service+disk+en' 'servicedisk'
    "Disken löper tvärs över mitten av rummet och delar det
    ungefär i två halvor: södra sidan för kunder, norra
    sidan för anställda. "

    dobjFor(LookBehind) { action() { "Du lutar dig lite över disken
        för att titta bakom den, men du ser inget intressant. "; } }

    dobjFor(StandOn)
    {
        verify() { }
        action() { "Bäst att låta bli; det skulle se konstigt ut om någon
            kom in. "; }
    }
    dobjFor(SitOn) asDobjFor(StandOn)
    dobjFor(LieOn) asDobjFor(StandOn)
    dobjFor(Board) asDobjFor(StandOn)
;

++ oakJobCard: JobCard 'grön+t gröna -' 'grönt indexkort'
    cardColor = 'grönt'
    cardDept = 'TRÄDGÅRD'
    cardJob = 'TRIMMA EK'
    cardLoc = 'BECKMAN GRÄSMATTA'
    cardDesc = 'TRIMMA/FORMA EKGRENAR. 1-MANS PERSONLIG LIFT GODKÄND. '
;
++ oliveJobCard: JobCard 'gul+t gula- ' 'gult indexkort'
    cardColor = 'gult'
    cardDept = 'TRÄDGÅRD'
    cardJob = 'TRIMMA TRÄD'
    cardLoc = 'OLIVE WK @ FLEMING'
    cardDesc = 'TRIMMA OLIVTRÄDGRENAR &amp; RENSA SKRÄP. ANVÄND
        PERSONLIG LIFT (ENSKILD) VID BEHOV. '
;
++ orwalkJobCard: JobCard 'blå+tt blåa -' 'blått indexkort'
    cardColor = 'blått'
    cardDept = 'EL'
    cardJob = 'REPARERA BELYSNING'
    cardLoc = 'ORANGE WK @ DABNEY HOUSE'
    cardDesc = 'FOTG.\ LAMPA #S30 UR FUNKTION.\ GLÖDLAMPA OK, KONTROLLERA LEDNINGAR.'
;    
++ lauritsenJobCard: JobCard 'rosa -' 'rosa indexkort'
    cardColor = 'rosa'
    cardDept = 'EL'
    cardJob = 'BELYSNINGSUNDERHÅLL'
    cardLoc = 'LAURITSEN'
    cardDesc = 'KONTROLLERA EXT.\ BELYSNING, REPARERA VID BEHOV.'
;

++ Readable '(physical) (plant) memo+t' 'memo'
    "<tt>Till: Skiftledare
    \nFrån: Ledningen
    \nÄrende: Personalmeningsskiljaktigheter
    \bDet har kommit till vår kännedom att vissa personalmedlemmar inte
    har kommit överens med varandra. Vi vill inte nämna några
    namn, men vi ber ledarna att göra sina dagliga scheman
    för att hålla ERNST och GUNTHER åtskilda. Dvs. SCHEMALÄGG INTE träd-
    trimning och elunderhåll på samma plats och tid.
    Om möjligt, låt inte ens dessa två korsa varandras vägar under dagen.
    Vi vill inte ha en upprepning av incidenten från förra veckan, när
    någon som vi inte ska nämna lämnade sitt servicefordon obevakat
    medan han jagade den andra onämnda parten runt hela campus i
    två timmar. Att lämna servicefordon obevakade gör dem
    sårbara för alla sorters student- och fakultetsbus, som vi
    såg än en gång i förra veckans incident när nämnda servicefordon
    hittades på taket till våra kontor nästa morgon.</tt> "
    disambigName = 'physical plant memo'
;

+ ppoHall: OutOfReach, ThroughPassage 'hall+en/korridor+en' 'korridor'
    "Korridoren leder norrut, längre in i byggnaden. "

    cannotReachFromOutsideMsg(dest) { return 'Du kan inte nå
        korridoren från den här sidan av disken. '; }

    dobjFor(TravelVia)
    {
        preCond = []
        verify() { }
        check()
        {
            "Du måste anta att området bakom disken 
            endast är för behörig personal. ";
            exit;
        }
    }
;

/* 
 *   A class for the job cards on the physical plant counter, which all
 *   list together. 
 */
class JobCard: Readable 'färgat färg+ade jobbkort+et uppdragskort+et index:+kort+et*korten+a' 'indexkort'
    "Det är ett <<cardColor>> fem-gånger-sju indexkort, förtryckt
    med ett formulär som har fyllts i med skrivmaskin:
    <font face='tads-sans'>
    \bCALTECH PHYSICAL PLANT
    \nARBETSUPPDRAGSKORT
    \bAvd.: <font face='tads-typewriter'><u>&nbsp;<<cardDept
      >>&nbsp;&nbsp;&nbsp;</u></font>
    \nJobb: <font face='tads-typewriter'><u>&nbsp;<<cardJob
      >>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</u></font>
    \nPlats: <font face='tads-typewriter'><u>&nbsp;<<cardLoc
      >>&nbsp;&nbsp;&nbsp;</u></font>
    \nBeskr.: <font face='tads-typewriter'><u>&nbsp;<<cardDesc
      >>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</u></font>
    </font> "

    /* the color of the card */
    cardColor = ''

    /* the various job assignment data */
    cardDept = ''
    cardJob = ''
    cardLoc = ''
    cardDesc = ''

    /* use our special listing group */
    listWith = [jobCardGroup]
;

jobCardGroup: ListGroupParen
    /* the group name, as a number of cards */
    showGroupCountName(lst)
    {
        if (lst.length() == 2)
            "ett par färgade indexkort";
        else
            "flera färgade indexkort";
    }

    /* the name of an individual item in the parenthesized sublist */
    showGroupItem(lister, obj, options, pov, info)
        { "ett <<obj.cardColor>>"; }
;

/* ------------------------------------------------------------------------ */
/*
 *   Jorgensen - main lobby
 */
jorgensen: Room 'Jorgensen Lobby' 'lobbyn i Jorgensen' 'lobby'
    "Detta är ett stort, öppet område, dekorerat med inramade foton
    längs väggarna. Klassrum ligger i öster och väster,
    och en korridor leder norrut. Byggnadens utgång är
    söderut. "

    vocabWords = 'jorgensen lab+bet/laboratorium+et/lobby+n'

    north = jorgensenHall
    south = sanPasqualWalkway
    out asExit(south)

    west: FakeConnector { "Du kikar in i klassrummet, men du
        ser inget intressant. "; }

    east: FakeConnector { "Du tittar in i klassrummet, men
        du ser inget av intresse. "; }
;

+ ExitPortal ->(location.south) 'byggnad byggnadens utgång+en' 'utgång'
    "Utgången är söderut. "
;

+ Enterable ->(location.north) 'korridor+en/hall+en/gång+en' 'korridor'
    "Korridoren leder norrut. "
;

+ Decoration 'inrama:t+de svartvit:t+a foto+t/bild+en*bilder+na foton+a'
    'inramade foton'
    "Fotona är mestadels svartvita och visar historisk
    datorutrustning. De äldsta är analoga datorer;
    operatörer tittar in i huva-försedda skärmar för att läsa oscilloskop-
    spår. Senare bilder visar vad som ser ut som gigantiska
    växelbord prydda med massor av trassliga kablar: en ganska
    bokstavlig typ av <q>spagettikod.</q> Efter det kommer de tidiga
    stordatorerna, enorma lådor omgivna av tekniker i vita rockar. "

    isNominallyIn(obj) { return inherited(obj) || obj.ofKind(DefaultWall); }

    isPlural = true
;

+ Decoration 'öst+ra väst+ra ö v klassrum+met' 'klassrum'
    "Klassrum ligger i öster och väster. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Jorgensen - hallway 
 */
jorgensenHall: Room 'Korridor' 'korridoren'
    "Detta är en hall som löper norr och söder. Dörrar kantar
    hallen på båda sidor; förutom dörren i väster, som är
    märkt <q>Campus Nätverkskontor,</q> verkar dörrarna leda till
    privata kontor. Hallen slutar en kort bit norrut,
    och öppnar sig mot en lobby söderut. "

    vocabWords = 'jorgensen hall+en/korridor+en/lab+bet/laboratorium+et'

    south = jorgensen
    out asExit(south)

    east = jhPrivateDoor
    northeast = jhPrivateDoor
    southeast = jhPrivateDoor
    northwest = jhPrivateDoor
    southwest = jhPrivateDoor

    west = jhNetworkOfficeDoor
    
    north: NoTravelMessage { "Hallen slutar en kort sträcka
        norrut. "; }
;

+ Enterable ->(location.south) 'lobby' 'lobby'
    "Lobbyn ligger söderut. "
;

+ jhPrivateDoor: ForbiddenDoor
    'privat+a kontors|dörr+en*kontors|dörrar+na' 'privata kontorsdörrar'
    "De flesta dörrarna längs hallen verkar leda till privata kontor. "
    isPlural = true

    cannotEnter = "Det verkar vara ett privat kontor. Det skulle vara
        oartigt att bara gå in. "
;

+ jhNetworkOfficeDoor: LockableWithKey, Door
    'väst+ra v campus nätverk kontor+et dörr+en*dörrar+na' 'Campus Nätverkskontorsdörr'
    "Dörren är märkt <q>Campus Nätverkskontor.</q> "
;
++ jhSign: CustomImmovable, Readable 'handskriv:en+na skylt+en' 'handskriven skylt'
    "Skylten lyder <q>Stängt - Tillbaka kl 13:00.</q> "

    /* 
     *   Show a special description.  Note that we use separate special
     *   descriptions for room descriptions and contents descriptions
     *   because of the surplus of doors.  In the room description, we need
     *   to say which door the sign is on; in the contents description,
     *   that would be redundant, since we're just examining the door. 
     */
    specialDesc = "En handskriven skylt på Nätverkskontorsdörren
        lyder <q>Stängt - Tillbaka kl 13:00.</q> "
    showSpecialDescInContents(actor, cont) { "En handskriven skylt
        på dörren lyder <q>Stängt - Tillbaka kl 13:00.</q> "; }

    cannotTakeMsg = 'Du har ingen anledning att ta bort skylten. '
;

/* ------------------------------------------------------------------------ */
/*
 *   The Campus Network Office 
 */
networkOffice: Room 'Nätverkskontor' 'Nätverkskontoret' 'kontor'
    "Detta rum är ungefär inrett som ett privat kontor. Ett skrivbord
    är placerat tvärs över rummets mitt, vänt mot dörren,
    och bakom skrivbordet finns bokhyllor från golv till tak, fyllda
    med utskrifter, pärmar, mappar och lösa papper. Större delen
    av utrymmet på skrivbordet upptas av flera terminaler och
    arbetsstationer. Dörren leder ut österut. "

    vocabWords = 'campus nätverks|kontor+et'

    east = netOfcDoor
    out asExit(east)

    west: NoTravelMessage { "Du bör nog stanna på den här sidan av skrivbordet. "; }

    /* on entry, have Dave greet us */
    enteringRoom(traveler)
    {
        dave.addToAgenda(daveGreet);
    }

    /* open the office for our return from lunch */
    endLunch()
    {
        /* open the door */
        jhNetworkOfficeDoor.makeLocked(nil);
        jhNetworkOfficeDoor.makeOpen(true);

        /* remove the "back at 1pm" sign */
        jhSign.moveInto(nil);
    }
;

+ netOfcDoor: Door ->jhNetworkOfficeDoor 'dörr' 'dörr'
    "Dörren leder ut österut. "
;

+ Heavy, Surface 'skrivbord+et/bord+et' 'skrivbord'
    "Skrivbordet är vänt mot dörren och delar informellt rummet. Flera
    terminaler och arbetsstationer tävlar om utrymme på ytan. "

    iobjFor(PutOn)
    {
        check()
        {
            "Det finns väldigt lite fritt utrymme på skrivbordet där du
            skulle kunna lägga något nytt. ";
            exit;
        }
    }

    dobjFor(LookBehind) { action() { "Det huvudsakliga du ser bakom
        skrivbordet är bokhyllorna. "; } }
;

++ Heavy 'terminal+en/arbetsstation+en*arbetsstationer+na terminaler+na' 'arbetsstationer'
    "De är vända åt andra hållet, så du kan inte se exakt vilken
    typ de är härifrån. "

    isPlural = true

    dobjFor(Use) asDobjFor(TypeOn)
    dobjFor(TypeLiteralOn) asDobjFor(TypeOn)
    dobjFor(TypeOn)
    {
        verify() { }
        action() { "Terminalerna är vända åt andra hållet; du kan inte
            enkelt skriva på dem härifrån. "; }
    }
;

+ Heavy 'rullande kontors|stol+en' 'kontorsstol'
    "Det är en enkel rullande kontorsstol. "
;

++ dave: IntroPerson 'kraftig+a medelålders dave/david/man+nen*män+nen' 'man'
    "Han är en kraftig, medelålders man, klädd i en lätt skrynklig
    vit skjorta utan slips. "

    specialDesc = "{En/han dave} sitter bakom skrivbordet. "

    isHim = true
    globalParamName = 'dave'
    properName = 'Dave'

    posture = sitting
    postureDesc = "Han sitter bakom skrivbordet. "
;

+++ daveGreet: AgendaItem
    invokeItem()
    {
        "{Ref/den dave} tittar upp när du kommer in. <q>Hej,</q> säger han. ";
        me.noteConversation(dave);
        isDone = true;
    }
;

+++ InitiallyWorn 'skrynklig+a vit+a skjorta+n' 'vit skjorta'
    "Den är lite skrynklig, men annars presentabel. "
    isListedInInventory = nil
;

+++ HelloTopic
    topicResponse()
    {
        "<q>Hej,</q> säger du, <q>jag heter Doug.</q>
        <.p>Han nickar lite. <q>Jag är Dave,</q> säger han.
        <q>Vad kan jag hjälpa dig med?</q> ";

        /* note that he's introduced now */
        dave.setIntroduced();
    }
;
++++ AltTopic
    "<q>Hej igen,</q> säger du. Dave nickar lite. "
    isActive = (dave.introduced)
;


+++ AskTopic @dave
    topicResponse()
    {
        "<q>Jobbar du här?</q> frågar du.
        <.p><q>Japp,</q> säger han. <q>Jag är Dave. Vad kan jag hjälpa dig med?</q> ";
        dave.setIntroduced();
    }
;
++++ AltTopic
    "<q>Vad gör du här?</q> frågar du.
    <.p>Han rycker på axlarna. <q>Nätverksoperationer, officiellt. Mest betyder det att jag
    springer runt och skriker på folk för att de använder otilldelade IP-adresser,
    laddar ner för många MP3:or, sånt där.</q> "
    isActive = (dave.introduced)
;

+++ AskTopic @networkOffice
    "<q>Vad gör Nätverkskontoret?</q> frågar du.
    <.p><q>Alla möjliga saker,</q> säger han. <q>Vi driver det fysiska
    nätverket, hanterar IP-tilldelningar, konfigurerar routrarna, you name it.</q> "
;

+++ AskTellTopic, StopEventList [quadWorkers, nicTopic]
    ['<q>Vad gör killarna ute på gården?</q> frågar du.
    <.p><q>Menar du NIC-killarna?</q> frågar han. <q>De gör lite
    kontraktsarbete för oss. Uppgraderingar av nätverkskablar.</q> Han tittar runt
    dig för att se om någon kommer, och sänker rösten. <q>Bara mellan
    dig och mig, jag tror ärligt talat att de latar sig något fruktansvärt.</q><.reveal dave-suspects-nic> ',

     '<q>NIC-folket...</q> börjar du. <q>Vad menade du med att
     de latar sig?</q>
     <.p><q>Tja,</q> säger han, <q>hälften av tiden hittar jag dem nere i
     tunnlarna, där de gör jobb som, såvitt jag kan se, de bara har hittat på.</q> ',

     '<q>Så du är misstänksam mot NIC-entreprenörerna?</q> frågar du.
     <.p><q>Ja, det kan man säga,</q> säger han. <q>Jag kommer behöva att
     gräva lite djupare i det vid något tillfälle.</q> ']
;


+++ AskTellTopic, SuggestedAskTopic
    topicResponse = "<q>Skulle du kunna slå upp en IP-adress åt mig?</q>
        frågar du.
        <.p>Han rynkar pannan och granskar ditt ansikte i några ögonblick.
        <q>Varför skulle du vilja att jag gör det?</q> frågar han misstänksamt.
        <.convnode dave-why-ip><.topics> "

    /* match the decimal IP address (but convert the dots to regex format) */
    matchPattern = static (new RexPattern(
        infoKeys.spy9DestIPDec.findReplace('.', '<dot>', ReplaceAll, 1)
        + '$'))

    /* the name to offer is the decimal IP format */
    name = static (infoKeys.spy9DestIPDec)

    /* we're active only if the number has been revealed */
    isActive = gRevealed('spy9-dest-ip')
;

++++ AltTopic
    "<q>Vad var det du fick reda på om den där IP-adressen igen?
    Det var <<infoKeys.spy9DestIPDec>>.</q>
    frågar du.
    <.p>Han kontrollerar pärmen igen. <q>Vi ska se. Här är det.
    Det är ett jobbnummer hos vår nätverksentreprenör:
    <<infoKeys.syncJobNumber>>.</q> "

    isActive = gRevealed('sync-job-number')
;

+++ AskTellTopic @ipAddressesTopic
    "<q>Du hanterar IP-tilldelningar på campus, eller hur?</q> frågar du.
    <.p><q>Japp,</q> säger han. <q>Det är vi som gör det.</q> "
;
+++ AskTellTopic @nrRouter
    "<q>Ni sköter campus-routrarna, eller hur?</q> frågar du.
    <.p><q>Stämmer,</q> säger han, <q>bland annat.</q> "
;

+++ AskTellGiveShowTopic @netAnalyzer
    "<q>Vet du hur man använder Netbisco 9099:or?</q> frågar du.
    <.p><q>Det är en nätverksanalysator, eller hur?</q> Han stirrar ut i
    tomma intet en stund. <q>Ja, jag har använt dem, men tyvärr 
    måste jag säga att jag inte kan komma ihåg det minsta om dem.
    De har det här usla hex-funktionskodsgränssnittet.</q>
    Han härmar att han trycker på knappar i luften med pekfingret.
    <q>Kunde aldrig lista ut de där förbannade koderna.</q> "
;

/* 
 *   answer requests for random IP addresses; rank this below distinguished
 *   IP address queries 
 */
+++ AskTellTopic
    matchScore = 70
    matchPattern = static new RexPattern(
        '(<digit>{1,3}<dot>){3}<digit>{1,3}$')
    topicResponse()
    {
        "Du är inte säker på hur samarbetsvillig han kommer att vara 
        när det gäller att slå upp IP-adresser åt dig, så du vill inte 
        pressa din tur genom att fråga om slumpmässiga adresser. Det 
        är bättre att begränsa dig till att fråga om de du verkligen 
        behöver spåra. ";
    }

    isConversational = nil
;
++++ AltTopic
    "Du vill inte besvära honom med förfrågningar om att slå upp slumpmässiga IP-adresser. "
    isConversational = nil
    isActive = gRevealed('sync-job-number')
;

/* we might ask about the camera IP number as well */
+++ AskTellTopic
    matchPattern = static (new RexPattern(
        infoKeys.spy9IPDec.findReplace('.', '<dot>', ReplaceAll, 1) + '$'))

    topicResponse = "Du vill inte slita ut ditt välkomnande med
        onödiga förfrågningar. Du vet redan allt du behöver
        veta om den IP-adressen---det är den som SPY-9-kameran
        använder. "

    isConversational = nil

    isActive = gRevealed('spy9-ip')
;

/* 
 *   If we give him the IP in hex, make a joke of it.  To be sure we don't
 *   accidentally match any better topics that are words that happen to
 *   contain only the letters A through F, use a low ranking.  Also, only
 *   accept 2 to 8 hex digits.
 */
+++ AskTellTopic, StopEventList
    eventList = [&firstResponse, &nthResponse]
    matchPattern = static new RexPattern('<nocase>[0-9a-f]{2,8}$')
    
    firstResponse()
    {
        "<q>Vad kan du berätta om <q><<gTopic.getTopicText()
          >></q>?</q>frågar du.
        <.p>Han skrattar. <q>Så, du har hört att jag är den mänskliga hex-till-decimal
        omvandlaren.</q> Han blundar i några ögonblick.
        <q>\^<<convertLiteral>>!</q>
        säger han, och ser nöjd ut med sig själv. ";
    }

    nthResponse()
    {
        "<q>Hur är det med <q><<gTopic.getTopicText()>></q>?</q> frågar du.
        <.p>Han kisar och tänker, sedan tillkännager han,
        <q>\^<<convertLiteral>>!</q> ";
    }
    /* return current topic text as a spelled-out decimal number */
    convertLiteral()
    {
        local txt;
        local num;
        local str = '';

        /*
         *   Convert the value to a BigNumber.  Since the value could be
         *   too big to fit in a 32-bit integer, convert it as a BigNumber.
         *   We only allow hex numbers up to 8 digits, so we only need
         *   enough precision for billions.  
         */
        txt = gTopic.getTopicText();
        num = new BigNumber(
            toInteger(txt.substr(1, txt.length() - 1), 16), 10);
        num *= 16;
        num += toInteger(txt.substr(txt.length()), 16);

        /* 
         *   if it's over two billion, handle the billions part ourselves,
         *   so that we don't overflow a 32-bit signed integer 
         */
        if (num > 2000000000)
        {
            /* spell out the billions part */
            str = spellInt(toInteger(num / 1000000000)) + ' biljard, ';

            /* take the billions out of the value */
            while (num > 1000000000)
                num -= 1000000000;
        }

        /* convert the number to an integer for spellIntExt's use */
        num = toInteger(num);

        /* spell the number */
        return str + spellIntExt(num,
                                 SpellIntCommas
                                 | SpellIntTeenHundreds
                                 | SpellIntAndTens);
    }
;

+++ AskTellTopic
    matchScore = 70
    matchPattern = static new RexPattern('<nocase>[0-9a-f]{9,}$')
    topicResponse = "<q>Vad kan du berätta om
        <q><<gTopic.getTopicText()>></q>?</q>frågar du.
        <.p><q>Det är ett väldigt stort hexadecimalt tal,</q> säger han. "
;

+++ AskAboutForTopic, SuggestedAskTopic @jobNumberTopic
    "<q>Bara av nyfikenhet, vad var det där jobbnumret?</q>
    <.p>Han rycker på axlarna och tar fram pärmen igen, och hittar
    rätt sida. <q>Här är det. <<infoKeys.syncJobNumber>>. Det kommer inte
    att hjälpa dig mycket dock---de har sitt eget privata system
    för dessa.</q><.reveal sync-job-number> "
    
    name = 'jobbnumret'
    isActive = gRevealed('sync-job-number-available')
;
++++ AltTopic
    "<q>Vad var det där jobbnumret du gav mig igen?</q>
    <.p>Han suckar och tar fram pärmen. <q>Det är
    <<infoKeys.syncJobNumber>>. Jag vet verkligen inte något mer
    om det dock. Ledsen.</q> "
    isActive = gRevealed('sync-job-number')
;
+++ DefaultAnyTopic, ShuffledEventList
    ['Han skriver något på en av arbetsstationerna. <q>Vänta lite,</q>
    säger han, <q>jag måste svara på den här chatten.</q> ',
     'Något på en av terminalerna distraherar honom medan ni pratar. ',
     '<q>Förlåt,</q> säger han, <q>inte min avdelning.</q> ']
;

+++ ConvNode 'dave-why-ip'
    genericSearch = "Han skriver på sin terminal, tittar på skärmen,
        skriver lite till. <q>Hmm.</q> Han rullar sin stol till
        väggen och låter fingrarna glida över några pärmar, drar sedan ut
        en och bläddrar igenom den. Han lägger tillbaka den och återvänder till
        terminalen. <q>Det är i ett block vi gav till NIC,</q> säger han.
        <q>Entreprenörerna vi har som gör lite ny kabeldragning.</q> Han knappar
        vidare på terminalen. <q>De ska egentligen berätta för oss hur de
        använder dessa, men de är inte alltid så snabba.</q> Han
        går tillbaka till hyllan och drar ut en annan pärm, och skannar
        igenom den. <q>Här har vi det. Tyvärr, dåliga nyheter. Allt de gav oss
        är ett jobbnummer, vilket inte kommer att hjälpa någon av oss särskilt mycket.</q>
        Han lägger tillbaka pärmen.<.reveal sync-job-number-available>"
;

++++ TellTopic, SuggestedTopicTree, SuggestedTellTopic @spy9
    "Du tvekar att säga för mycket, eftersom du inte kan vara säker på vem
    som var inblandad i att placera ut kameran. <q>Jag försöker spåra
    lite övervakningsutrustning,</q> säger du. <q>Vi är inte säkra
    på exakt var den är inkopplad.</q>
    <.p>Han verkar acceptera det. <q>Okej, låt mig se vad jag kan
    hitta.</q> <<location.genericSearch>> "

    name = 'SPY-9-kameran'
;
+++++ AltTopic
    "Du tvekar att säga för mycket, men med tanke på hans misstankar om
    NIC-killarna, tänker du att han kanske är villig att hjälpa till. <q>Jag
    försöker spåra lite obehörig utrustning som jag tror
    NIC-folket har installerat,</q> säger du.
    <.p>Han höjer på ögonbrynen. <q>Verkligen,</q> säger han. <q>Nå,
    låt mig se vad jag kan hitta.</q> Han skriver på sin terminal,
    tittar på skärmen, skriver lite till. <q>Hmm.</q> Han rullar sin
    stol till väggen och låter fingrarna glida över några pärmar,
    drar sedan ut en och bläddrar igenom den. Han lägger tillbaka den och
    återvänder till terminalen. <q>Mycket riktigt, det är i ett block vi
    gav till NIC,</q> säger han. Han knappar vidare på terminalen.
    <q>De <i>ska</i> berätta för oss hur de använder dessa,
    men de tar sig god tid.</q> Han går tillbaka till hyllan
    och drar ut en annan pärm, och skannar igenom den. <q>Här har vi det.
    Tja, vilken överraskning. Allt de gav oss är ett jobbnummer,
    vilket inte kommer att hjälpa någon av oss särskilt mycket.</q> Han lägger
    tillbaka pärmen.<.reveal sync-job-number-available> "

    isActive = gRevealed('dave-suspects-nic')
;
++++ TellTopic [ddTopic, stamerStackTopic, stackTopic, stamerTopic,
               stamerLabTopic]
    "<q>Det är för en Skoldagstapel,</q> säger du.
    <.p>Han ler. <q>Ah, jag förstår,</q> säger han. <q>Glad att kunna hjälpa till.</q>
    <<location.genericSearch>> "
;


++++ SpecialTopic 'säga att du är en privatdetektiv'
    ['säg','att','du','jag','är','en','privatdeckare','privat','detektiv','privatdetektiv']
    "<q>Jag gör en informell undersökning,</q> säger du och försöker
    låta konspiratorisk.
    <.p>Han betraktar dig misstänksamt. <q>Vilken typ av undersökning?</q>
    frågar han.<.convstay> "
;

/* a secret out-of-reach object representing the back half of the room */
+ OutOfReach, SecretFixture
    cannotReachFromOutsideMsg(dest) { return 'Du kan inte nå det
        från den här sidan av rummet. '; }
;

++ Fixture
    'golvtilltak bokhylla+n/hylla+n*hyllor+na bokhyllor+na' 'bokhyllor'
    "Bokhyllorna täcker väggarna bakom skrivbordet. De är
    fyllda med utskrifter, pärmar, mappar och lösa papper. "
    isPlural = true
;
+++ Thing
    'lös+a utskrift+en/pärm+en/mapp+en/pappret*utskrifter pärmar+na mappar+na papper pappren+a'
    'papper'
    "Du kan inte se mycket härifrån förutom etiketterna på några
    av pärmarna: <q>Kopplingsschema 1996,</q> <q>Budget 2000-1,</q>
    <q>Routerkonfiguration för södra campus.</q> "
    isPlural = true
;
++++ Component 'pärmetikett+en/etiketter+na' 'pärmetiketter'
    desc = (location.desc)
    isPlural = true
;

/* ------------------------------------------------------------------------ */
/*
 *   we need some rather similar 'tree' objects in a few places 
 */
class TreeDecoration: Fixture
    dobjFor(Climb)
    {
        verify() { }
        action() { "Du har ingen anledning att klättra i <<isPlural ?
              'några av dessa träd' : 'trädet'>>. "; }
    }
;

/* an orange - fruit for the orange trees */
class OrangeDecoration: CustomImmovable, Food
    'apelsin+en/frukt+en*apelsiner+na' 'apelsiner'
    "Dessa träd ger en ganska liten typ av apelsin. "
    isPlural = true
    cannotTakeMsg = 'Du provade en apelsin från ett av dessa träd för flera år sedan,
        när du var student, och du har inget intresse av att upprepa
        den sura upplevelsen. '
    dobjFor(Eat)
    {
        preCond = []
        action() { "Du vet av erfarenhet att dessa apelsiner är
            för sura för att äta. "; }
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   Lawn outside Beckman Auditorium 
 */
beckmanLawn: CampusOutdoorRoom 'Gräsmatta nära Beckman'
    'gräsmattan nära Beckman' 'gräsmatta'
    "Det cirkulära Beckman Auditorium ligger precis norr om detta vidsträckta
    gräsområde; en reslig dubbeldörr leder in. Ett lummigt ekträd
    lutar sig över gräset och ger lite skugga. En gångväg leder österut. "

    north = blDoors
    east = blEastWalk
;

+ CampusMapEntry 'beckman auditorium' 'Beckman Auditorium' 'norr';

+ Decoration 'vidsträckt+a gräsmatta+n/gräs+et' 'gräsmatta'
    "Gräset är välskött. "
;

+ blDoors: AlwaysLockedDoor
    '(beckman) (auditorium) reslig+a dubbeldörr+en/ingång+en* dubbeldörrar+na'
    'ingång till auditoriet'
    "Den imponerande uppsättningen dörrar är minst sex meter höga. "

    cannotOpenLockedMsg = 'Dörrarna verkar vara låsta---vilket inte är
        förvånande, eftersom det vanligtvis inte finns något schemalagt här
        under dagen. '
;

+ Enterable ->(location.north)
    'cirkulärt beckman auditorium' 'Beckman Auditorium'
    "Beckman är känt som <q>bröllopstårtan</q> på grund av dess visuella
    likhet med densamma: det är runt, högt och vitt, med ett
    svagt sluttande konformat tak. "
    isProperName = true
;
++ Distant, Component
    '(beckman) (auditorium) svagt sluttande konisk+a tak+et/kon+en'
    'taket på auditoriet'
    "Taket är en svagt sluttande kon. "
;

+ blEastWalk: PathPassage 'öst+ra ö gångväg+en' 'östra gångvägen'
    "Gångvägen leder österut förbi eken. "
;

+ blOak: TreeDecoration
    'högt hög+a full:t+a lummig:t+a ek:en+träd+et/skugga+n/gren+en/grenar+na' 'ekträd'
    "Eken är hög och full. <<gunther.isIn(location)
      ? "En trädgårdsmästare står i en skylift parkerad under
        trädet och trimmar grenar. " : "">> "

    /* 
     *   this is obviously reachable from the cherry picker, whether raised
     *   or lowered
     */
    isCherryPickerReachable = true
;

+ cherryPicker: Heavy, Vehicle
    '(personlig+a) li:ten+lla elektrisk+a skylift+en/lift+en/plockare+n/vagn+en'
    'skylift'
    "Det är en liten elektrisk vagn med en passagerarkorg i
    änden av en bomm, som <<cherryPickerBasket.isRaised
      ? "för närvarande är upphöjd till sin fulla höjd på cirka tre meter. "
      : "ser ut att kunna höja korgen till en höjd av cirka tre
        meter, men är för närvarande infälld. "
      >>  Manöverreglagen verkar vara placerade i korgen. "
    specialDesc()
    {
        if (gActionIs(TravelVia) && me.isIn(self))
        {
            /* 
             *   we're showing the description as part of our arrival when
             *   the PC is driving the cherry picker somewhere - say
             *   nothing here, as we'll add a mention in our afterTravel()
             *   of where we end up parking the cherry picker 
             */
        }
        else if (gunther.isIn(self))
        {
            /* 
             *   Gunther will mention us as part of his own specialDesc as
             *   long as he's in the cherry picker, so we don't need or
             *   want a separate description of the cherry picker itself
             *   in this case 
             */
        }
        else if (me.isIn(self))
        {
            /* 
             *   we're riding the cherry picker, so describe it as such,
             *   using a location-specific description 
             */
            location.inCherryPickerSpecialDesc;
        }
        else
        {
            /* we're just parked - show a location-specific description */
            location.cherryPickerSpecialDesc;
        }
    }

    /* when we board/unboard, simply get in/out of the basket */
    dobjFor(Board) remapTo(Board, cherryPickerBasket)
    dobjFor(Enter) remapTo(Board, cherryPickerBasket)
    dobjFor(GetOutOf) remapTo(GetOutOf, cherryPickerBasket)

    /* the basket must be lowered before travel can commence */
    travelerPreCond(conn) { return [cherryPickerLowered]; }

    /* 
     *   Before allowing travel to proceed, make sure we're going to a
     *   compatible location.  We can only go to campus outdoor locations.
     *   
     *   Note that we could have set up travel barriers everywhere needed
     *   to keep the cherry picker within an allowed region, but that
     *   would have been a pain to maintain as new rooms were added.  It's
     *   simpler and more reliable to take advantage of the fact that the
     *   cherry picker has to be outdoors across the board.  
     */
    travelerTravelTo(dest, connector, backConnector)
    {
        /* make sure the location is compatible */
        if (!dest.ofKind(CampusOutdoorRoom))
        {
            /* explain the problem */
            "Du gör bäst i att hålla skyliften utomhus. ";
            
            /* terminate the command */
            exit;
        }

        /* inherit the standard behavior to carry out the travel */
        inherited(dest, connector, backConnector);
    }

    /* add a message when we travel */
    moveIntoForTravel(dest)
    {
        /* if the PC is driving, mention what's going on */
        if (me.isIn(self))
            "Du trampar på gaspedalen och vagnen accelererar till hela 
            tre kilometer i timmen. Du styr vagnen längs vägen. ";

        /* do the normal work */
        inherited(dest);
    }

    /* after driving here, mention where we park */
    afterTravel(traveler, connector)
    {
        /* if the PC is driving, mention where we park */
        if (traveler == self && traveler.isActorTraveling(me))
            location.descCherryPickerArrival();

        /* do any inherited work */
        inherited(traveler, connector);
    }

    /* use special arrival/departure messages when Gunther is driving */
    sayArrivingViaPath(conn)
    {
        if (gunther.isIn(self))
            "\^<<gunther.aName>> kör in en skylift 
            från <<conn.theName>>. ";
        else
            inherited(conn);
    }
    sayDepartingViaPath(conn)
    {
        if (gunther.isIn(self))
            "\^<<gunther.theName>> styr iväg skyliften 
            mot <<conn.theName>>. ";
        else
            inherited(conn);
    }

    /* to get out, just EXIT */
    tryRemovingFromNested() { return tryImplicitAction(GetOutOf, self); }

    /* attempting to move the cherry picker explains it's a vehicle */
    dobjFor(Move) asDobjFor(PushTravel)
    dobjFor(Push) asDobjFor(PushTravel)
    dobjFor(Pull) asDobjFor(PushTravel)
    dobjFor(Turn) asDobjFor(PushTravel)
    dobjFor(PushTravel)
    {
        verify() { logicalRank(50, 'för tung'); }
        check()
        {
            "Skyliften är alldeles för tung att skjuta runt på för 
            hand; man skulle behöva sätta sig i och köra den för
            att flytta den någonstans.";
            exit;
        }
    }
;

++ cherryPickerBoom: Component '(skylift) (vagn+en) (korg+en) skylift^s+bom+men' 'bom'
    "Bommen höjer och sänker passagerarkorgen. "
    disambigName = 'skyliftens bom'

    dobjFor(ClimbUp) asDobjFor(Climb)
    dobjFor(Climb)
    {
        verify()
        {
            if (!cherryPickerBasket.isRaised)
                illogicalNow('Det finns igen större mening med det när
                    bommen är i sitt infällda läge. ');
        }
        check()
        {
            "Du försöker, men du upptäcker snabbt att bommen
            inte har några bra handtag. ";
            exit;
        }
    }

    dobjFor(Lower) remapTo(Pull, cherryPickerLever)
    dobjFor(Raise) remapTo(Push, cherryPickerLever)

    /* the boom can be reached from the basket in all positions */
    isCherryPickerReachable = true
;
++ cherryPickerBasket: OutOfReach, Component, Booth
    '(skylift+ens) (vagn+en) midjehöga metallinhägnad+e metall+en passagerarkorg+en/korg+en/inhägnad+en'
    'korgen på skyliften'
    "Det är en liten metallinhägnad, ungefär midjehög, precis stor nog
    för en person att stå i. <<isRaised
      ? "Den är för närvarande upphöjd till sin fulla höjd på cirka
        tre meter över marken."
      : "Den är för närvarande i sitt helt nedsänkta läge."
      >> Korgen innehåller manöverreglagen för vagnen. "
    
    /* when we exit, we move to the cart's location */
    exitDestination = (location.location)

    /* we can't get out when the cart is raised */
    dobjFor(GetOutOf) { preCond = (inherited() + cherryPickerLowered) }

    /* lowering and raising the basket is accomplished with the lever */
    dobjFor(Lower) remapTo(Pull, cherryPickerLever)
    dobjFor(Raise) remapTo(Push, cherryPickerLever)

    /* 
     *   We can reach in when we're lowered.  We can't reach out at all,
     *   except that we can reach certain specially marked objects.  
     */
    canObjReachContents(obj) { return !isRaised; }
    canReachFromInside(obj, dest)
    {
        local loc;
        
        /* 
         *   the destination is reachable if (1) it's marked as always
         *   reachable from here, or (2) it's marked as reachable from the
         *   raised basket and we're currently raised 
         */
        if (dest.isCherryPickerReachable
            || (isRaised && dest.isRaisedCherryPickerReachable))
            return true;

        /* 
         *   if the destination is inside something that's reachable, it's
         *   reachable 
         */
        if ((loc = dest.location) != nil
            && canReachFromInside(obj, loc))
            return true;

        /* the destination isn't reachable */
        return nil;
    }

    /* obviously, the basket is reachable from the basket */
    isCherryPickerReachable = true

    /* is the basket currently raised? */
    isRaised = true

    cannotReachFromOutsideMsg(dest) { return 'Vagnen är rest 
        för högt för dig att nå. '; }
    cannotReachFromInsideMsg(dest) { return 'Du kan inte nå detta
        från vagnen. '; }

    /* remove an out-of-reach obstruction by getting out of the basket */
    tryImplicitRemoveObstructor(sense, obj)
    {
        if (sense == touch && gActor.isIn(self))
            return tryRemovingFromNested();
        else
            return inherited(sense, obj);
    }

    /* 
     *   When we're raised, looking into the basket from outside counts as
     *   'distant'.  Allow looking out to work normally, though, since
     *   we're really not that far from anything. 
     */
    transSensingIn(sense)
        { return sense == sight && isRaised ? distant : inherited(sense); }
    transSensingOut(sense) { return transparent; }

    /* we can be boarded directly from the cherry picker's location */
    stagingLocations = [location.location]

    /* show a note on how to operate the vehicle */
    howToDrive = "(Om du vill köra vagnen 
        någonstans, bara <<gActor.isIn(cherryPickerBasket) ? ''
          : "kliv in och" >> säg vilken riktning du vill köra.) ";
;

+++ gunther: IntroPerson
    'vilt vitt vit+a fluffig+a gunther der
    trädgårdsmästare+n/hår+et/mustasch+en/gunther/gartner/g\u00e4rtner/gaertner/man*män'
    'trädgårdsmästare'
    "Trädgårdsmästaren är en kort man med yvigt vitt hår och en
    fluffig vit mustasch. "

    properName = 'Gunther trädgårdsmästaren'

    /* presume we're known, since we're mentioned in a memo */
    isKnown = true

    /* 
     *   don't show our posture separately when we're in the basket (which
     *   is the only place we ever appear in the game), since that's
     *   included in the base description 
     */
    postureDesc() { }

    /* 
     *   use a special state-dependent rendering to describe us when we
     *   appear in our location's contents listing 
     */
    showSpecialDescInContents(actor, cont) { curState.specialDescInContents; }

    /* 
     *   allow receiving things via GIVE TO without being within reach;
     *   this allows handing us things while we're in the raised basket,
     *   which is where we spend most of our time 
     */
    iobjFor(GiveTo) { preCond = static (inherited - [touchObj]) }

    /* Gunther is a "he" */
    isHim = true

    /* 
     *   allow him to be seen in full detail from a distance (the only
     *   time this will come up is when we're in the cherry picker, which
     *   isn't all that far from the ground) 
     */
    sightSize = large

    /* if ernst arrives while we're here, start the fight */
    afterTravel(traveler, connector)
    {
        inherited(traveler, connector);
        if (traveler.isActorTraveling(ernst))
            ernst.startFight();
    }
;

++++ Thing '(träd) träd|sekatör+en/träd|trimmer+n/par+et*blad+en' 'trädsekatör'
    "De är som mycket stora saxar, med sextio centimeter långa blad. "
    isPlural = true
    isListedInInventory = nil
;

/* base state for trimming tress */
class GuntherTrimmingState: ActorState
    stateDesc = "Han står i korgen på skyliften och
        trimmar grenar från <<treeName>>. "
    specialDesc = "\^<<location.aName>> står i den upphöjda korgen
        på en skylift och trimmar grenar från <<treeName>>. "
    specialDescInContents = "\^<<location.aName>> står i
        korgen och trimmar <<treeName>>. "

    /* 
     *   we're distant when we're in the raised cherry picker, but don't
     *   let that change our description in this state 
     */
    distantSpecialDesc = (specialDesc)

    /* the tree we're trimming */
    // treeName = ''
;

/* our initial state, trimming the oak tree */
++++ guntherTrimmingOak: GuntherTrimmingState
    isInitState = true
    treeName = 'eken'
;

/* our state when trimming olive trees on the olive walk */
++++ guntherTrimmingOlive: GuntherTrimmingState
    treeName = 'ett av olivträden'
;

++++ DefaultCommandTopic
    "<q>Kan du inte se att jag är upptagen?</q> frågar han irriterat. "
;

++++ HelloTopic
    "<q>Hej,</q> säger du.
    <.p>Han tittar ner men fortsätter trimma. <q><i>Ja</i>, hej,</q>
    säger han. "
;

++++ AskTellTopic, StopEventList @ernst
    ['<q>Känner du till någon elektriker i området ?</q> frågar du.
    <.p><q>Elektriker?</q> Hans ögon smalnar. <q>Pratar du med mig
    om den där gräslige Ernst?</q>  Han börjar prata snabbt på 
    tyska, som du inte kan tillräckligt av för att följa med vad 
    han säger, men du märker att han är arg över någonting.  Han
    slutar så småningom och återgår till sitt trimmande, fortsatt muttrande. ',
     'Du börjar ta upp ämnet om elektriker igen,
     men han börjar bara säga <q><i>Nein</i></q> och ignorerar 
     dig. ']
;

++++ AskTellShowTopic [blOak, owTrees]
    "<q>Hur går det med trädet?</q> frågar du.
    <.p><q>Det går framåt,</q> säger han. <q>Det här trädet behöver en hel del
    trimning.</q> "
;
++++ AskTellTopic, StopEventList @gunther
    [&doIntro,
     '<q>Hur går det?</q> frågar du.
     <.p>Han tittar ner. <q>Inte så illa,</q> säger han. ']

    doIntro()
    {
        "<q>Vad heter du?</q> frågar du.
        <.p>Han fortsätter trimma medan han pratar. <q>Gunther,</q> säger han.
        <q><i>Ja</i>, jag vet, Gunther der G&auml;rtner, mycket roligt,
        jag vet, jag vet.</q> ";

        gunther.setIntroduced();
    }
;
++++ AskTellShowTopic @cherryPicker
    "<q>Vilken typ av skylift är det där?</q> frågar du.
    <.p>Han tittar ner på dig, fortfarande trimmande. <q>Das ist inget som
    angår dig,</q> säger han avfärdande. "
;
++++ AskForTopic @cherryPicker
    "<q>Öh, tror du att jag skulle kunna låna den där skyliften en
    stund?</q> Du ler bedjande.
    <.p>Trädgårdsmästaren slutar trimma ett ögonblick och stirrar
    på dig. <q><i>Nein!</i></q> säger han, skakande på huvudet bestämt.
    <q><i>Nein, nein, nein!</i></q> Han återgår till att klippa med
    förnyad kraft. "
;
class GuntherJobCardTopic: GiveShowTopic
    topicResponse()
    {
        "<q>Här,</q> säger du och håller upp kortet för trädgårdsmästaren.
        <.p>Han sänker korgen tillräckligt för att nå kortet och tittar
        på det. ";

        /* check to see if we're already there */
        if (gunther.isIn(destLoc))
        {
            "<q>Vad ser det ut som att jag redan arbetar på här,
            <i>ja</i>?</q> säger han och viftar med kortet.
            Han lämnar irriterat tillbaka kortet till dig, höjer korgen
            igen och återgår till att trimma trädet. ";
            return;
        }

        /* get going */
        "<q>De sa trimma <i>det här</i> trädet!</q> säger han. Han läser
        kortet igen och ser sedan resignerad ut. <q><i>Ja wohl,</i></q> säger
        han, <q>nu går jag och trimmar det andra trädet.</q> Han sänker
        korgen, muttrande på tyska. ";

        /* lower the basket and go into transit state */
        cherryPickerBasket.isRaised = nil;
        gunther.setCurState(guntherInTransit);

        /* remember our destination */
        guntherInTransit.destPath = destPath;
        guntherInTransit.destState = destState;
    }
    /* the path to the destination */
    destPath = []

    /* the destination is the last path element */
    destLoc = (destPath[destPath.length()])

    /* the state to go into when we reach the destination */
    destState = nil
;
++++ GuntherJobCardTopic @oakJobCard
    destPath = [quad, sanPasqualWalkway, beckmanLawn]
    destState = guntherTrimmingOak
;
++++ GuntherJobCardTopic @oliveJobCard
    destPath = [sanPasqualWalkway, quad, oliveWalk]
    destState = guntherTrimmingOlive
;
++++ GiveShowTopic [orwalkJobCard, lauritsenJobCard]
    "<q>Här,</q> säger du och håller upp kortet för trädgårdsmästaren.
    <.p>Han sänker korgen tillräckligt för att nå kortet och tittar
    på det. <q>Das ist inte för <i>G&auml;rtner</i>!</q> säger han
    och lämnar tillbaka kortet. <q>Om du vill ha det jobbet gjort, gå och hitta
    <i>einen Elektromechaniker</i>!</q> "
;
++++ DefaultAnyTopic
    "Han ignorerar dig bara och fortsätter trimma trädet. "
;

/* our state while we're traveling to our next location */
++++ guntherInTransit: ActorState
    stateDesc = "Han kör igenom i skyliften. "
    specialDesc = "\^<<location.theName>> kör igenom i en
        skylift. "
    specialDescInContents = "\^<<location.theName>> kör
        skyliften någonstans. "

    takeTurn()
    {
        /* find our next location from our current location on the path */
        local idx = destPath.indexOf(gunther.location.getOutermostRoom());

        /* 
         *   if we haven't even started yet, move to the first location on
         *   the path; otherwise, move to the next one
         */
        idx = (idx == nil ? 0 : idx) + 1;

        /* travel to the next stop on the path */
        gunther.scriptedTravelTo(destPath[idx]);

        /* if that's the final destination, get to work */
        if (idx == destPath.length())
        {
            /* raise the basket */
            cherryPickerBasket.isRaised = true;
            "<.p>Trädgårdsmästaren parkerar skyliften under 
            <<destState.treeName>>, höjer korgen, och 
            börjar trimmar. ";

            /* switch to the new state */
            gunther.setCurState(destState);
        }
    }

    /* the path to our destination */
    destPath = []

    /* the state to go into when reaching our destination */
    destState = nil

    beforeAction()
    {
        /* do the normal work */
        inherited();
        
        /* don't let anyone into the basket while we're traveling */
        if ((gActionIs(Board) || gActionIs(Enter) || gActionIs(StandOn))
            && gDobj == cherryPickerBasket)
        {
            "<q><i>Nein!</i></q> skriker trädgårdsmästaren och   
            blockerar vägen. <q>Den här maskinen klarar bara av en person
            i taget!</q> ";
            exit;
        }
    }
;

/* medan vi är i detta tillstånd ignorerar vi konversationer helt */
+++++ DefaultAnyTopic
    "<q>Inte nu!</q> säger trädgårdsmästaren utan att sakta ner. <q>Jag måste
    bege mig till det nya jobbet nu!</q> "
    
    /* använd denna medan vi är i transit */
    isActive = (gunther.curState == guntherInTransit)
;
    
/* vårt tillstånd under slagsmål */
++++ guntherFightingState: ActorState
    stateDesc = "Han jagar elektrikern med en trädsekatör. "
    specialDesc = "\^<<ernst.aName>> springer mot dig med en panikslagen blick
        i ansiktet, nästan krockar med dig innan han svänger skarpt
        åt sidan. \^<<gunther.aName>> är precis bakom honom och jagar
        honom med en trädsekatör. "
;

+++ Component '(skylift+en) (vagn+en) ikonisk+a 
    silhuett+en/kontroller+n/ikon+en/pil+en*pilar+na*ikoner+na' 'kontroller'
    "Kontrollerna ser enkla ut. En spak är märkt med en
    ikonisk silhuett av korgen på bommen, med pilar som pekar
    uppåt och nedåt. Bredvid spaken finns en ratt, och under
    ratten på korgens golv finns en pedal, förmodligen
    gaspedalen. En ikon ovanför ratten visar en silhuett
    av vagnen med korgen upphöjd, och en pil som pekar framåt,
    och ett stort rött X över alltihop. "

    distantDesc = "Korgen är för högt upp; du kan inte se kontrollerna
        tydligt härifrån. "

    isPlural = true
    disambigName = 'skyliftens kontroller'
;
+++ NestedRoomFloor 'golv+et/(korgens)' 'korgens golv'
    "En pedal finns på golvet. "
;
++++ Component 'gas+pedal+en' 'pedal'
    "Den ser ut som en gaspedal. "

    dobjFor(Push)
    {
        verify()
        {
            if (!gActor.isIn(cherryPickerBasket))
                illogicalNow('Du måste vara i korgen för att använda
                    kontrollerna. ');
        }
        action()
        {
            "Du trycker lite på pedalen<<
              cherryPickerBasket.isRaised
              ? ". Ingenting verkar hända."
              : ", och vagnen rycker framåt lite. Du
                släpper pedalen och vagnen stannar."
              >> <<location.location.howToDrive>> ";
        }
    }
;
+++ Component 'miniatyr+ratt+en' 'ratt'
    "Den är som ratten på en bil, fast i miniatyr. "
    dobjFor(Turn)
    {
        verify()
        {
            if (!gActor.isIn(location))
                illogicalNow('Du måste vara i korgen för att använda
                    kontrollerna. ');
        }
        action()
        {
            "Du vrider på ratten lite, men den verkar svår att vrida
            medan vagnen står stilla. <<location.howToDrive>> ";
        }
    }
;
+++ cherryPickerLever: Component '(skylift+ens) (vagn+ens) skylift+spak+en/spak+en' 'spak'
    "Spaken är märkt med en ikon som visar korgen röra sig
    upp och ner. "
    disambigName = 'skyliftens spak'

    cannotMoveMsg = 'Spaken rör sig inte på det sättet; du kan bara
        trycka och dra den. '
    
    dobjFor(Move)
    {
        /* det är logiskt att flytta spaken, men mer specificitet krävs */
        verify() { logicalRank(50, 'flytta spak'); }
        action() { "(Du måste vara mer specifik: du kan antingen trycka
            på den eller dra i den.) "; }
    }

    /* translate MOVE UP into PUSH, and MOVE DOWN into PULL */
    dobjFor(PushTravel)
    {
        verify()
        {
            /* allow UP, FOREWARD, DOWN, and BACK only */
            if (gAction.getDirection() not in
                (upDirection, downDirection, foreDirection, backDirection))
                inherited();
        }
        action()
        {
            if (gAction.getDirection() is in (upDirection, foreDirection))
                replaceAction(Push, self);
            else
                replaceAction(Pull, self);
        }
    }
    
    dobjFor(Pull)
    {
        verify()
        {
            /* we need to be in the basket to operate the lever */
            if (!gActor.isIn(location))
                illogicalNow('Du behöver vara i korgen för att manövrera 
                    kontrollerna. ');
        }
        action()
        {
            if (cherryPickerBasket.isRaised)
            {
                "Du drar spaken hela vägen tillbaka, och korgen
                sänks långsamt. När bommen är helt indragen
                stannar nedsänkningen, och du låter spaken fjädra tillbaka
                till mittläget. ";

                /* notera att vi inte längre är upphöjda */
                cherryPickerBasket.isRaised = nil;
            }
            else
                "En motor gnäller lite, men inget annat händer,
                så du släpper spaken och låter den fjädra tillbaka till
                sitt mittläge. ";
        }
    }

    dobjFor(Push)
    {
        verify()
        {
            /* we need to be in the basket to operate the lever */
            if (!gActor.isIn(location))
                illogicalNow('Du behöver vara i korgen för att manövrera 
                    kontrollerna. ');
        }
        action()
        {
            if (cherryPickerBasket.isRaised)
                "En motor gnäller lite, men inget annat händer,
                så du släpper spaken och låter den fjädra tillbaka till
                sitt mittläge. ";
            else
            {
                "Du trycker spaken hela vägen framåt, och en gnällande
                motor börjar sakta höja korgen till dess att bommen är 
                helt utfälld.  Du släpper spaken, och den fjädrar tillbaka
                till mittläget. ";

                /* note that we're now raised */
                cherryPickerBasket.isRaised = true;

                /* let the location add any comment it wants to */
                cherryPicker.location.noteCherryPickerRaised;
            }
        }
    }
;

/*
 *   A precondition for lowering the cherry picker basket.  We use this as
 *   a convenience for the player if they try to disembark the cherry
 *   picker or drive it around while the basket is raised.  We *could*
 *   have just aborted those actions with an error, but since there's no
 *   mystery to operating the basket, there's no reason not to perform
 *   these actions automatically when needed.  
 */
+ cherryPickerLowered: PreCondition
    checkPreCondition(obj, allowImplicit)
    {
        /* if the basket is already lowered, we're done */
        if (!cherryPickerBasket.isRaised)
            return nil;

        /* try lowering the basket implicitly */
        if (allowImplicit && tryImplicitAction(Lower, cherryPickerBasket))
        {
            /* make sure the basket was lowered */
            if (cherryPickerBasket.isRaised)
                exit;

            /* tell the caller we executed an implied command */
            return true;
        }

        /* we can't do it implicitly - report the failure */
        reportFailure('Du måste sänka korgen först. ');
        exit;
    }
;


/* ------------------------------------------------------------------------ */
/*
 *   Quad
 */
quad: CampusOutdoorRoom
    'Kvadraten' 'Kvadraten' 'Kvadraten'
    "Detta öppna gräsområde är känt som Kvadraten, på grund av dess rektangulära
    form. Flera gångvägar möts här: Olivgången leder österut och
    västerut, Orangegången leder ner några trappsteg söderut, och
    en annan gångväg leder norrut. I nordväst ligger campusbokhandeln.
    De två huvudsakliga studentbostadskomplexen ligger en kort bit
    österut: Norra Husen på norra sidan av Olivgången,
    och de äldre Södra Husen på södra sidan. "

    vocabWords = 'kvadraten+en'

    north = quadNorthWalk
    east = quadEastWalk
    west = quadWestWalk
    south = quadSouthWalk
    down = quadManhole
    northwest = bookstore
    in asExit(northwest)
;

+ CampusMapEntry '(campus) (caltech) bokhandel+n' 'bokhandeln' 'sydost';
+ CampusMapEntry 'winnett center centret' 'Winnett Center' 'sydost';
+ CampusMapEntry 'kvadrat+en' 'Kvadraten' 'sydost';
+ CampusMapEntry 'olivgång+en' 'Olivgången' 'sydost'
    altLocations = [westOliveWalk, oliveWalk]
;

+ Enterable ->(location.northwest)
    '(campus) (caltech) bok|handel+n/bok|affär+en' 'bokhandeln'
    "Bokhandeln har fått en ny fasad sedan du var här
    senast, i samma medelhavsstil som många av de andra
    närliggande byggnaderna. Ingången är mot nordväst. "
;

+ Decoration 'gräs|matta+n/gräs+et' 'gräs'
    "Det är ganska vanligt gräs. "
;

+ quadNorthWalk: PathPassage 'stenlagd+a norra n gångväg+en/stig+en' 'norra gångvägen'
    "Det är en stenlagd gångväg som leder norrut. "
;
+ quadSouthWalk: PathPassage -> orwNorthWalk
    '(tegel) orange södra s orange|gång+en/trappa+n/gångväg+en/stig+en *trappor+na steg+en'
    'Orangegången'
    "Orangegången ligger ner några trappsteg söderut. "

    dobjFor(ClimbDown) asDobjFor(Enter)
    dobjFor(Climb) asDobjFor(Enter)

    canTravelerPass(trav) { return trav != cherryPicker; }
    explainTravelBarrier(trav)
        { "Det finns inget sätt att få ner skyliften för trapporna. "; }
;
+ quadEastWalk: PathPassage ->olwWestWalk
    '(tegel) östra ö olivgång+en/gångväg+en/stig+en' 'östra gångvägen'
    "Den tegellagda gångvägen leder österut. "
;
+ quadWestWalk: PathPassage
    '(tegel) västra v olivgång+en/gångväg+en/stig+en' 'västra gångvägen'
    "Den tegellagda gångvägen leder västerut. "
;

+ Decoration 'röd+a tegel|sten+en/teglet*tegel+stenar+na' 'tegelstenar'
    "Stigen är belagd med ganska vanliga röda tegelstenar. "
    isPlural = true
;

+ Distant 'gamla äldre nya+re södra norra grundutbildning student
    *hus+en bostäder+na komplex+en' 'studentbostäder'
    "Studentbostäderna ligger en kort bit österut, längs
    Olivgången. De nyare husen ligger på norra sidan, och de äldre
    husen på södra sidan. "
    isPlural = true
;

+ CustomImmovable
    'gul "varnings" plast|tejp+en/påle+n/tejp+en*pålar+na' '<q>Varning</q>stejp'
    "Gul plasttejp, med ordet <q>Varning</q> skrivet var
    annan meter, är uppspänd runt några pålar som omger
    brunnen. "

    cannotTakeMsg = 'Arbetarna skulle förmodligen bli arga på dig
        om du gjorde det. '

    dobjFor(Enter)
    {
        verify() { }
        action() { "Om du skulle gissa, skulle du säga att arbetarna tejpade av området
            för att hålla personer som dig utanför. "; }
    }
;
+ OutOfReach, SecretFixture
    cannotReachFromOutsideMsg(dest)
    {
        gMessageParams(dest);
        return '{Den dest/han} {är} på andra sidan av den gula tejpen,
            som arbetarna utan tvekan satte dit för att förhindra just den här
            sortens inblandning från förbipasserande. ';
    }
;
++ quadAnalyzer: Thing
    'elektronisk+a netbisco 9099 nätverksanalysator+n/analysator+n/pryl+en/utrustning+en'
    name = (described ? 'nätverksanalysator' : 'elektronisk utrustning')
    aName = (described ? 'en nätverksanalysator' : 'en elektronisk pryl')
    desc = "Den ser ut lite som den typ av överdimensionerad telefon
        man skulle hitta på en receptionists skrivbord i ett stort kontor. Du
        kan urskilja ett namn tryckt på toppen: det är en Netbisco 9099,
        vilket är en nätverksanalysator, om du minns rätt. Du har
        använt något liknande tidigare när du satte upp ett nätverk; den är
        användbar för uppgifter som att konfigurera routrar. "

    /* vi listar dessa i worker specialDesc, så lista inte separat */
    isListed = nil

    dobjFor(Take)
    {
        preCond = []
        check()
        {
            "För det första är den bakom den gula tejpen, som
            uppenbarligen är menad att hålla personer som dig utanför. För det andra
            skulle arbetarna utan tvekan stoppa dig om du försökte
            ta den. ";
            exit;
        }
    }
;
++ Thing 'stor+a telefon+en nätverk+et trä|spole+n/kabel+n/rulle+n*rullar+na trä|spolar+na' 'kabelrullar'
    "De är träspolar med en diameter på två fot, lindade med kabel,
    som ser ut att vara någon form av telefon- eller nätverkskabel. "

    isPlural = true

    /* vi listar dessa i worker specialDesc, så lista inte separat */
    isListed = nil
;
++ quadManhole: ThroughPassage
    'stor+a rektangulär+a brunn+en/hål+et/schakt+et/öppning+en' 'brunn'
    "Det är en rektangulär öppning i marken, stor nog att rymma
    ett par personer samtidigt, med ett par metalldörrar. Ett schakt
    går ner från öppningen, och du är ganska säker på att det leder ner till
    ångtunneln som löper ungefär under Olivgången. "

    specialDesc()
    {
        "Längs Olivgången står ett par arbetare
        vid en öppen rektangulär brunn, som de har
        avspärrat med gul <q>Varning</q>-tejp uppspänd runt
        några pålar i marken. Flera stora kabelrullar är
        staplade bredvid brunnen";

        if (quadAnalyzer.isIn(location))
            ", tillsammans med <<quadAnalyzer.aName>>";

        ". ";
    }

    dobjFor(Board) asDobjFor(Enter)
    dobjFor(Climb) asDobjFor(Enter)
    dobjFor(ClimbDown) asDobjFor(Enter)

    lookInDesc = "Du kan inte se något härifrån, men du är ganska
        säker på att schaktet leder ner till en ångtunnel. "
    /* 
     *   since the manhole is at a slight distance, we have to throw
     *   things into the manhole 
     */
    iobjFor(PutIn) remapTo(ThrowAt, DirectObject, self)

    /* throwing something at/into the manhole */
    throwTargetHitWith(projectile, path)
    {
        throwScript.doScript(projectile);
    }
    throwScript: StopEventList { [ &firstTime, &secondTime ]
        doScript(projectile)
        {
            /* set up the projectile as a message parameter */
            gMessageParams(projectile);

            /* remember it internally for our use in the event handler */
            projectile_ = projectile;

            /* do the normal work */
            inherited();
        }

        /* the projectile of this call */
        projectile_ = nil

        firstTime()
        {
            "<q>Hallå där!</q> ropar en av arbetarna och fångar
            {den projectile/honom} precis innan {det/han} faller ner i
            brunnen. <q>Det är en kille som jobbar där nere!</q> ";

            if (projectile_ == ratPuppet)
                "Han tittar på leksaksråttan och skrattar, sedan viftar
                han med den runt brunnens öppning och ropar ner i
                schaktet. <q>Hördu, Plisnik! Kolla vad jag har här!</q>
                Det hörs några arga rop från schaktet.<.p>";

            "Arbetaren kastar tillbaka {ref projectile/honom} till dig.
            <q>Jag ska låtsas att det var en olycka,</q> säger han
            hotfullt till dig. ";
        }

        secondTime()
        {
            "En av arbetarna grabbar tag i {ref projectile/honom} i
            luften innan {den/han} faller ner i schaktet. ";


            if (projectile_ == ratPuppet)
                "<q>Hördu, Plisnik!</q> ropar han ner i tunneln.
                <q>Den här idioten här uppe tror att du kommer bli rädd
                för råttor som faller från himlen! Väldigt skrämmande---flygande
                råttor! Oooh!</q> Han kastar tillbaka råttan till dig.
                <q>Hörru, kan du sluta kasta skräp på oss? Det är
                farligt!</q> ";
            else
                "<q>Hallå där!</q> skriker han och kastar tillbaka {den/honom} till dig.
                <q>Sluta kasta skräp på oss! Det är
                farligt!</q> ";
        }
    }
;
+++ Door '(brunn) gångjärnad+e brunn^s+metall+dörr+en/dörrar+na*metallplattor+na'
    'brunndörrar'
    "Dörrarna är metallplattor, gångjärnade i kanterna för att öppnas
    som en ladugårdsdörr. "
    
    isPlural = true
    initiallyOpen = true

    dobjFor(Board) asDobjFor(Enter)
;
++ quadWorkers: Person
    'stor+a tung+a ovårdad+e skägg+iga arbetare+n/man+nen*arbetar:e+na män+nen' 'arbetare'
    "De två arbetarna är båda stora, tunga män med ovårdade skägg.
    De bär ljusgröna overaller och matchande skyddshjälmar. "

    isHim = true
    isPlural = true

    /* 
     *   vi behöver inte nämnas i rumsbeskrivningen, eftersom
     *   brunnen inkluderar oss i sin beskrivning 
     */
    specialDesc = ""

    /* 
     *   kräv inte beröring för GIVE TO - alla våra GIVE TO-ämnen
     *   är bara SHOW TO ändå, så det finns inget behov av att röra 
     */
    iobjFor(GiveTo) { preCond = (inherited - touchObj); }
;
+++ InitiallyWorn 'ljusgrön+a hård+a overaller+na/skydds|hjälmar+na/uniformer+na'
    'uniformer'
    "Arbetarna bär ljusgröna overaller och matchande skyddshjälmar,
    märkta med <q>Nätverksinstallatörsföretaget</q> i kantiga vita bokstäver.
    <.reveal NIC> "
    isPlural = true
    isListedInInventory = nil
;

+++ Unthing 'plisnik' 'plisnik'
    notHereMsg = 'Plisnik är nere i schaktet, antar du---inte här. '
;

+++ InConversationState, StopEventList
    [
        '<.p>En arbetare knuffar lekfullt den andre med armbågen. <q>
        Vill du veta vad som är kul? Plisnik är rädd för råttor. Kolla
        här.</q> Han kupar händerna och ropar ner i schaktet. <q>Hallå,
        Plisnik! Är det en råtta där?</q> Det blir lite uppståndelse nere
        i schaktet, följt av en massa svordomar. De två arbetarna skrattar och
        gör en high-five.<.reveal plisnik-n-rats> ',

        '<.p>Du kan höra någon ropa från schaktet, men du kan inte
        urskilja vad han säger. En av arbetarna svarar genom att
        räcka ner en av kabelrullarna. ',

        '<.p><q>Du,</q> säger en av arbetarna till den andre, <q>hur
        kul skulle det inte vara att ha en råtta just nu?</q> Han skrattar.
        <.p><q>Ja,</q> säger den andre och skrattar, <q>vi kunde släppa
        ner den där och se Plisnik flippa ut.</q> ',

        '<.p>Någon i schaktet säger något som du inte riktigt kan
        uppfatta. En av arbetarna muttrar och tar tag i en kabelrulle.
        <q>Är jag en leveransservice?</q> klagar han och
        räcker ner rullen i schaktet. ',

        '<.p>En av arbetarna säger till den andre, <q>Har du sett de nya
        självkrympande kontakterna? Rätt coola, va?</q> Den andre
        nickar och grymtar instämmande. ',

        /* 
         *   use a nil last element, so that we do nothing once we run out
         *   of items to show 
         */
        nil
    ]

    stateDesc = "Båda tittar på dig---inte direkt förväntansfullt; 
            mer som om du just gjorde något idiotiskt och de undrar 
            vad du ska hitta på härnäst."

    /* 
     *   use a relatively long attention span, so we get to see a few of
     *   the background messages if we're idle 
     */
    attentionSpan = 5

    /* when we're in conversation, generate some comments while idle */
    doScript()
    {
        /* 
         *   Only make a comment if we didn't converse on this turn.
         *   Also, we mention Plisnik a lot, so don't do anything unless
         *   Plisnik is still in the tunnel below. 
         */
        if (!getActor().conversedThisTurn() && plisnik.inOrigLocation)
            inherited();
    }
;

++++ AskTellTopic [plisnikTopic, ratTopic]
    "<q>Varför är Plisnik så rädd för råttor?</q> frågar du.
    <.p>Arbetarna skrattar. En av dem ropar ner i
    schaktet, <q>Hallå, Plisnik! Jag tror jag ser en till råtta!</q>
    Du hör några rop komma från schaktet men du kan inte
    urskilja vad som sägs. "

    isActive = (gRevealed('plisnik-n-rats'))
;
+++++ AltTopic
    "<q>Varför är Plisnik så rädd för råttor?</q> frågar du.
    <.p>Arbetarna tittar bara på varandra och skrattar. "

    isActive = (!plisnik.inOrigLocation)
;

/* 
 *   if we TELL ABOUT PLISNIK, mention that he ran off, if he did - use an
 *   elevated score for this so we override the generic plisnik/rat topic 
 */
++++ TellTopic +110 @plisnikTopic
    "<q>Visste ni att Plisnik såg en råtta och sprang iväg?</q> frågar du.
    <.p>De två himlar med ögonen. <q>Japp, han gör det varje dag,</q> säger en
    av dem. "

    isActive = (!plisnik.inOrigLocation)
;

++++ GiveShowTopic @ratPuppet
    "Du visar råttan för arbetarna. <q>Söt,</q> säger en av dem.
    Han knuffar den andre killen med armbågen. <q>Skulle det inte vara kul om vi hade
    en <i>riktig</i> råtta?</q> "
;

++++ AskTellShowTopic, SuggestedAskTopic @quadWorkers
    "<q>Vad jobbar ni grabbar me'?</q> frågar du och använder
    din uppfattning om arbetarklassens språk av någon anledning som du 
    inte kan kontrollera.
    <.p>En av dem rullar bara lite med ögonen, medan den andre
    långsamt och noggrant tittar ner på sin uniform och pekar på de
    klumpiga bokstäverna. <q>Nätverk,</q> läser han och flyttar fingret över
    orden, <q>Installatör... Företag.</q> Han tittar upp på dig. <q>Vi
    installerar ett nätverk.</q><.convnode vilket-nätverk><.reveal NIC> "

    name = 'dem själva'
;
++++ AskTellTopic, SuggestedAskTopic @ddTopic
   "<q>Gör ni något som en del av Skolkdagen?</q> frågar du.
    <.p>De ser båda lite arga ut. <q>Tror du vi är kabelgrävare, 
    eller?</q> säger den ene. <q>Vi jobbar med högteknologi.</q> "
    name = 'skolkdagen'
;
++++ AskTellTopic, SuggestedAskTopic @nicTopic
    "<q>Jag har aldrig hört talas om <q>Nätverksinstallatörsföretaget</q> förut,</q>
    säger du. <q>Vad gör de?</q>
    <.p>De två stirrar tomt på dig under några långa ögonblick, sedan säger en
    av dem, <q>Öh, vi installerar nätverk.</q>
    <.convnode what-network>"

    name = 'Nätverksinstallatörsföretaget'
    isActive = (gRevealed('NIC'))
;

/* ett par ämnen gäller nätverksanalysatorn */
++++ TopicGroup
    isActive = (quadAnalyzer.isIn(quad) && quadAnalyzer.described)
;
+++++ AskTellShowTopic @quadAnalyzer
    "<q>Är det en Netbisco 9099?</q> frågar du.
    <.p>De två tittar på nätverksanalysatorn. <q>Japp,</q> säger en. "
;
+++++ AskForTopic @quadAnalyzer
    "<q>Skulle jag kunna låna er Netbisco 9099?</q> frågar du.
    <.p><q>Öh, nej,</q> säger en av arbetarna, och låter irriterad.
    <q>Vår kille nere i tunneln kanske behöver den.</q> "
;

/* ett ämne om netbisco *innan* vi vet vad det är */
++++ AskTellAboutForTopic @quadAnalyzer
    "<q>Vad är det för slags utrustning?</q> frågar du och pekar på den.
    <.p>En av arbetarna tittar på den. <q>Jag vet inte,</q> säger han.
    <q>Något vi använder för nätverksinstallation, antar jag.</q> "
    
    isActive = (quadAnalyzer.isIn(quad) && !quadAnalyzer.described)
;

/* försöker lämna tillbaka analysatorn efter att vi har den */
++++ GiveShowTopic @netAnalyzer
    "Du tänker att det kanske inte är en bra idé att dra för mycket uppmärksamhet till
    det faktum att du lånade deras analysator. Det vore nog bäst att bara
    lämna den någonstans i närheten och låta dem hitta den själva. "

    isConversational = nil
;

++++ DefaultAnyTopic, ShuffledEventList
    ['De två bara stirrar på dig och tuggar på vad det nu är de tuggar på. ',
     'De två arbetarna tittar på varandra, sedan tillbaka på dig, men ingen
     av dem säger något. ',
     'Arbetarna himlar med ögonen och säger ingenting. ',
     'En av arbetarna skrattar lite, och den andre tittar på
     honom, men ingen av dem säger något. ']
;
++++ ConversationReadyState
    isInitState = true
    stateDesc = "Båda arbetarna står vid brunnen och tittar ner
        i den med uttråkade ansiktsuttryck, och tuggar lojt på något. "
;
+++++ HelloTopic, StopEventList
    ['Du ställer dig nära den gula tejpen och försöker få arbetarnas
    uppmärksamhet. <q>Ursäkta mig...</q> ropar du till dem.
    <.p>De två tittar långsamt upp från hålet och ser på dig
    som om du avbröt ett viktigt samtal. <q>Ja?</q>
    frågar en av dem. ',
     '<q>Ursäkta mig,</q> säger du till arbetarna.
     <.p>De två tittar upp från brunnen. <q>Du igen,</q> säger
     en av dem. ']
;
+++++ ByeTopic "De två arbetarna går tillbaka till att stirra ner i hålet. "
;

+++ ConvNode 'what-network';
++++ SpecialTopic 'fråga vilken typ av nätverk'
    ['fråga','vilken','typ','av','nätverk']
    "Du vill inte verka lättstött, så du tvingar fram ett skratt.
    <q>Ja, men vilken typ av nätverk arbetar ni med?</q>
    <.p><q>Kablar, ledningar, små lådor med blinkande lampor,</q> säger han
    och härmar blinkande lampor genom att vifta med fingrarna.
    <q>Förstår du, de ger oss bara dessa arbetsordrar, och vi utför
    arbetet.</q> Han tar fram en papperslapp ur fickan och
    gör en halvhjärtad ansträngning att hålla fram den för dig att se.
    Du läser tillräckligt för att förstå att de gör några uppgraderingar
    av campusnätverket, men han stoppar undan den innan du kan
    läsa hela saken. "
;
/* ------------------------------------------------------------------------ */
/*
 *   Olive Walk
 */
oliveWalk: CampusOutdoorRoom
    'Östra Olivgången' 'den östra Olivgången' 'Olivgången'
    "Olivgången är uppkallad efter olivträden som kantar båda sidorna
    av den tegelbelagda gångvägen och bildar ett valv ovanför. Gångvägen löper
    öster och väster mellan de två huvudsakliga studentbostadskomplexen:
    de nyare Norra Husen på norra sidan, och de äldre Södra Husen
    på södra sidan. Husens huvudingångar vetter mot gångvägen.
    En antik kanon står framför Fleming i söder. "

    vocabWords = 'östra ö olivgång+en/gångväg+en'

    west = olwWestWalk
    east = olwEastWalk
    north: NoTravelMessage { "Det skulle säkert vara underhållande att
        gå genom alla husen och se de olika staplarna i år,
        men du borde förmodligen försöka hålla fokus just nu. " }
    south: NoTravelMessage { "Hur gärna du än skulle vilja undersöka alla
        staplarna i de andra husen, bör du förmodligen försöka hålla
        fokus på Stamers stapel. " }

    /* tillhandahåll några speciella beskrivningar för skyliften när den är här */
    descCherryPickerArrival = "Du styr skyliften till en plats
        bredvid kanonen, vid sidan av huvudstigen, och parkerar. "
    inCherryPickerSpecialDesc = "Du står i korgen på en
        skylift, som är parkerad bredvid kanonen. "
    cherryPickerSpecialDesc = "En skylift är parkerad bredvid
        kanonen. "
;

+ CampusMapEntry 'södra s studentbostäder+na' 'de Södra Husen' 'sydost';
+ CampusMapEntry 'norra n studentbostäder+na' 'de Norra Husen' 'sydost';
+ CampusMapEntry 'fleming+s house/hovse hus+et' 'Fleming House' 'sydost';
+ CampusMapEntry 'page+s house/hovse hus+et' 'Page House' 'sydost';
+ CampusMapEntry 'lloyd+s house/hovse hus+et' 'Lloyd House' 'sydost';
+ CampusMapEntry 'ruddock+s house/hovse hus+et' 'Ruddock House' 'sydost';
+ CampusMapEntry 'ricketts house/hovse hus+et' 'Ricketts House' 'sydost';

+ owTrees: TreeDecoration
    '(lång+a) rad+en rader+na *oliv|träd+en träden+a grenar+na' 'olivträden'
    "Träden är planterade i prydliga rader, en på varje sida av gångvägen,
    med deras långa, tunna grenar som bildar ett valv över stigen. "
    isPlural = true
;

+ Decoration 'röd+a stig+en/tegel*tegelstenar+na' 'tegelstenar'
    "Stigen är belagd med ganska vanliga röda tegelstenar. Den fortsätter
    österut och västerut. "
    isPlural = true
;

+ olwWestWalk: PathPassage '(tegel) västra v gångväg+en/stig+en' 'västra gångvägen'
    "Gångvägen fortsätter västerut. "
;

+ olwEastWalk: PathPassage ->alWestWalk
    '(tegel) (teglet) östra ö gångväg+en/stig+en' 'östra gångvägen'
    "Gångvägen fortsätter österut. "
;

+ Fixture, Chair, ComplexContainer
    'antik+a (fleming) (house) (hus+et) kanon+en' 'kanonen'
    "Det är Fleming House-kanonen, ett verkligt stycke artilleri från 1800-talet.
    Pipan är minst tolv fot lång, och den vilar på
    ett par stora vagnhjul; lavetten är målad i den officiella
    Fleming House-röda färgen. Den har varit en fast installation här sedan
    innan din tid, och du kommer inte ihåg hela historien bakom den;
    avlägsna förfäder till moderna Flems rymde med den som en del av en
    rivalitet med ett annat lokalt college, eller något sådant. "

    cannotMoveMsg = 'Kanonen är alldeles för tung för att du ska kunna flytta den på egen hand. '
    /* if they just say 'down', translate to 'get off' what we're on */
    down = noTravelDown

    /* the barrel is our container */
    subContainer: Occluder, Component, RestrictedContainer
    {
        '(kanon+ens) pipa+n/mynning+en' 'kanonens pipa'

        desc()
        {
            "Den är ungefär tolv fot lång. Pipan lutar uppåt; ";
            if (isBarrelAccessible(getPOV()))
                "mynningen är lätt att nå härifrån. ";
            else if (getPOV().isIn(location))
                "även när man sitter på kanonen är det fortfarande en lång
                väg till pipans mynning. ";
            else
                "mynningen är högt över huvudet. ";
        }

        /* we're a component of the cannon */
        location = lexicalParent

        /* map operations involving sitting on the barrel to the cannon */
        dobjFor(Board) remapTo(Board, location)
        dobjFor(Climb) remapTo(Climb, location)
        dobjFor(ClimbUp) remapTo(ClimbUp, location)
        dobjFor(SitOn) remapTo(SitOn, location)

        /* this object is reachable from the cherry picker */
        isCherryPickerReachable = true

        /* check for barrel access, showing the message and exiting if not */
        checkBarrelAccess(msg)
        {
            if (!isBarrelAccessible(gActor))
            {
                /* show the failure message */
                reportFailure(msg);

                /* abort */
                exit;
            }
        }

        /* förklara varför vi inte kan titta in från marken */
        dobjFor(LookIn)
        {
            check()
            {
                checkBarrelAccess(
                    gActor.isIn(location)
                    ? 'Från din position på kanonen sträcker sig pipan
                      ytterligare sex eller åtta fot; det finns inget sätt att
                      se in i den härifrån. '
                    : 'Pipan lutar uppåt, och dess öppna ände är högt
                      över huvudet, så det finns inget sätt att se in i den
                      härifrån. ');
            }
        }

        iobjFor(PutIn)
        {
            check()
            {
                /* först, kontrollera om pipan är tillgänglig överhuvudtaget */
                checkBarrelAccess(
                    gActor.isIn(location)
                    ? 'Från din position på kanonen sträcker sig pipan
                      ytterligare sex eller åtta fot; det finns inget sätt att
                      nå in till änden härifrån. '
                    : 'Änden av pipan är för högt över huvudet för att
                      nå härifrån. ');

                /* gör de normala kontrollerna */
                inherited();
            }
        }

        /* varför kan vi inte lägga ett föremål inuti? */
        validContents = []
        cannotPutInMsg(obj) { return 'Du bör förmodligen inte göra det; det kan
            skapa en säkerhetsrisk nästa gång kanonen avfyras. '; }

        /* 
         *   Is the inside of the barrel accessible from the given point of
         *   view?  It is only if the point of view is in the raised cherry
         *   picker basket.  
         */
        isBarrelAccessible(pov)
        {
            return (pov.isIn(cherryPickerBasket)
                    && cherryPickerBasket.isRaised);
        }

        /* we can't even see inside unless we're on high */
        occludeObj(obj, sense, pov)
        {
            /* 
             *   if the object is inside me, we can't see it (or anything
             *   else) unless the inside of the barrel is accessible 
             */
            return (obj.isIn(self) && !isBarrelAccessible(pov));
        }
    }

    dobjFor(SitOn)
    {
        action()
        {
            "Det tar en liten stund att räkna ut hur, men du lyckas klättra 
            upp på vagnen och sätt dig grensle över pipan";
            inherited();
        }
    }
    dobjFor(Climb) asDobjFor(SitOn)
    dobjFor(ClimbUp) asDobjFor(SitOn)

    /* 
     *   we're not an ordinary chair: to extricate ourselves, we want to
     *   put it in terms of getting off the cannon rather than merely
     *   standing up, as is the default for chairs 
     */
    tryMakingTravelReady(conn) { return tryImplicitAction(GetOffOf, self); }
    notTravelReadyMsg = 'Du måste kliva av kanonen först. '
;
++ Component '(kanon+en) stor+a röd+a kanon+vagn^s+hjul+en'
    'kanonhjul'
    "De har runt fem fot i diameter, och de ser ut precis som 
    vagnshjul. "
    isPlural = true
;
++ Component '(kanon+en) motvikt+en/kärra+n' 'kärra'
    "Det är mestadels en enda stor motvikt för kärran.
    Den är målad i standard Fleming klarröd. "
;

/* 
 *   detta är bara en skämtsam referens till Ditch Day Drifter - Mr. Happy
 *   Gear var en av de slumpmässiga skattjaktsobjekten du var tvungen att skaffa i
 *   den spelens Ditch Day-stapel 
 */
++ mrHappyGear: Hidden
    'herr glad glad-ansikte metall maskin|kugghjul+et/metall|kugghjul+et/glad-|ansikte+t/
    utskärning+en/mönster/mönstret*utskärningar+na kugghjulen+a'
    'maskinkugghjul'
    "Det är ett metallkugghjul med en diameter på ungefär en och en halv tum, med ett
    mönster av utskärningar som får det att se ut mycket som en glad-ansikte-ikon.
    Av någon anledning kommer namnet <q>Herr Glada Kugghjulet</q> i åtanke. "

    subLocation = &subContainer
;

+ EntryPortal ->(location.north)
    'nya+re norra n grundutbildning+en student främre hus+en page lloyd ruddock
    hus+en/komplex+et/studenthem+met*studenthemmen+a ingångar+na'
    'Norra Husen'
    "Norra Husen-komplexet byggdes på 1960-talet; det är en grupp av
    tre studenthem&mdash;Page, Lloyd och Ruddock&mdash;mer eller mindre
    under ett tak. Husen är byggda i en 1960-talsmodern stil,
    med enkla, raka linjer. "

    isPlural = true
;

+ EntryPortal ->(location.south)
    'gamla äldre södra s grundutbildning+en student hus lertegel
    stuck främre fleming ricketts båge+n/bågar+na/tak+et/
    hus+et/husen/houses/hovse/hovses/komplex+et/studenthem+met/vägg+en*väggar+na ingångar+na studenthemmen+a'
    'Södra Husen'
    "Södra Husen byggdes på 1930-talet och designades i
    medelhavsstil: bågar, lertegeltak, stuckväggar,
    oregelbundna linjer, en något utspridd layout. Fleming och Ricketts
    ligger på denna sida av komplexet, Dabney och Blacker på södra sidan. "

    isPlural = true
;

+ Distant 'blacker dabney hus+et/house/hovse*houses hovses husen+a' 'Blacker och Dabney'
    "Blacker och Dabney är inte synliga härifrån; de ligger på södra sidan
    av byggnadsgruppen. "
    isPlural = true
    isProperName = true
    tooDistantMsg = 'Blacker och Dabney är inte synliga härifrån. '
;

/* ------------------------------------------------------------------------ */
/*
 *   Ath-gräsmattan 
 */
athLawn: CampusOutdoorRoom 'Athenaeum-gräsmattan' 'Ath-gräsmattan' 'gräsmattan'
    "Detta är en bred gräsmatta utanför campusets fakultetsklubb, känd
    som Athenaeum: en ståtlig byggnad i medelhavsstil med
    vit stuck, pelare och röda takpannor, som tornar upp sig i öster.
    Ath:s utomhusmatsal vetter mot gräsmattan. Olivgången
    slutar här och fortsätter in på campus i väster. "

    east = athDiningRoom
    in asExit(east)
    west = alWestWalk
;
+ CampusMapEntry 'athenaeum/ath' 'Athenaeum' 'sydost';

+ Distant, Enterable -> (location.east)
    'ståtlig+a medelhavsstil matsal+en fakultet+et
    ath/athenaeum/struktur+en/byggnad+en/rum+met/klubb+en'
    'Athenaeum'
    "Ath är en vidsträckt stuck-och-rött-tegeltak-struktur, som
    får den att likna många av SoCals filmstjärnemansioner. Den
    öppna matsalen blickar ut över gräsmattan. "
;
++ Decoration 'vit+a röd+a tak+et tegel+tak+struktur arketektonisk+a detalj+er/tak+et/stuck/pelare+n/tegel*takpannor+na pelarna'
    'arkitektoniska detaljer'
    "Ath har den medelhavsstil som är allestädes närvarande här
    på campus. "

    isPlural = true
;

+ alWestWalk: PathPassage
    '(tegel) västra v olivgång+en/gångväg+en/stig+en' 'västra gångvägen'
    "Gångvägen fortsätter västerut. "
;

+ Decoration 'gräs+et/gräsmatta+n' 'gräsmatta'
    "Gräsmattan ser välskött ut. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Ath matsal 
 */
athDiningRoom: Room 'Athenaeum Matsal' 'Ath-matsalen'
    'matsal'
    "Matbord är uppställda runt detta rymliga rum, som är
    öppet mot gräsmattan i väster. Enorma runda pelare stöder det
    höga taket. En bred dubbeldörr leder österut. "

    vocabWords = 'rymlig+a ath athenaeum matsal+en/rum+met'

    west = athLawn
    east = adrDoor
    out asExit(west)
;

+ Distant, Enterable -> (location.west) 'gräsmatta+n/gräs+et' 'gräsmatta'
    "Gräsmattan är utanför, västerut. "
;

+ adrDoor: AlwaysLockedDoor
    'bred+a hög+a trä dubbel|dörr+en*dubbel|dörrar+na' 'dubbeldörrar'
    "Dörrarna är breda och höga. De leder in i byggnaden
    österut. "

    isPlural = true
;

+ Decoration 'matbord+et/bord+et/stol+en*stolar+na matborden+a borden+a' 'bord'
    "Borden är för närvarande tomma, eftersom matsalen inte
    serverar någon måltid just nu. "
    isPlural = true
;

+ Decoration 'enorm+a rund+a pelare+n*pelarna' 'pelare'
    "Pelarna håller upp taket och ger rummet en
    formell atmosfär. "
    isPlural = true
;

/* ------------------------------------------------------------------------ */
/*
 *   California Blvd är synlig från flera platser, så gör den till en
 *   klass. Vi skulle normalt använda MultiFaceted för denna typ av situation,
 *   men i det här fallet är det enklare att göra det till en klass, eftersom vi vill
 *   peka rummets riktningsanslutningar till den.  
 */
class CalBlvd: PathPassage
    'california boulevard gata+n/blvd/blvd./väg+en'
    'California Boulevard'
    "California Boulevard är en livlig fyrafilig gata som utgör
    campusets södra gräns. "

    isProperName = true

    dobjFor(TravelVia)
    {
        action() { reportFailure('Du bör inte vandra iväg från
            campus förrän du har avslutat dina ärenden här. '); }
    }

    dobjFor(Cross) remapTo(TravelVia, self)
;
class CalBlvdTraffic: Distant
    'trafik+en*bil+ar+na' 'trafik'
    "Trafiken är ganska tät, men flyter stadigt. "
;
class CalBlvdNoise: SimpleNoise
    desc = "Konstant trafik susar förbi på California Boulevard. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Apelsingången 
 */
orangeWalk: CampusOutdoorRoom 'Apelsingången' 'Apelsingången' 'Apelsingången'
    "Denna nord-sydliga gångväg är uppkallad efter apelsinträden som är planterade
    längs med den. Några trappsteg leder uppåt mot norr. I söder slutar
    gångvägen vid California Boulevard, som utgör campusets södra
    gräns. En oasfalterad stig genom apelsinträden
    leder västerut. Österut leder en passage in i Dabney Hovse. "

    vocabWords = 'apelsin apelsin|ingången/apelsin|gång+en/gång|väg+en'

    north = orwNorthWalk
    up asExit(north)
    south = orwCalBlvd
    east = dabneyBreezeway
    in asExit(east)
    west = orwWestPath

    atmosphereList = (owMovers.isIn(self) ? moversAtmosphereList : nil)
;

+ CampusMapEntry 'apelsin|gång+en/apelsin|ingång+en' 'Apelsingången' 'sydost';
+ CampusMapEntry 'dabney+s hus+et/house/hovse' 'Dabney House' 'sydost'
    altLocations = [dabneyCourtyard]

    /* detta är det viktigaste "dabney" och "hus" vi kan söka efter */
    mapMatchStrength = 200
;

+ Decoration
    'metall+en (stig) belysning+en (ljus+et) klar+a
    armatur+en/ljus+et/stolpe+n*stig|lampor+na armaturer+na stolpar+na höljen+a'
    'stiglampor'
    "Stiglamporna är enkla metallstolpar med glödlampor
    inuti klara höljen nära toppen. De är placerade med några
    meters mellanrum längs stigen. "
    isPlural = true
;
++ Decoration '(stig) glöd|lampa+n*glöd|lampor+na' 'stiglampor'
    "Du är för mycket ett barn av din tid för att finna glödlampor
    särskilt anmärkningsvärda. Även om det utan tvekan är ett vetenskapligt
    och teknologiskt under att locka fram fotoner från exciterade
    elektroner som återvänder till sina grundtillstånd i en lågtrycksbehållare
    av natriumånga, är du alldeles för snabb att dra slutsatsen
    att dessa ser ut som vanliga glödlampor för dig. "
;

+ orwNorthWalk: PathPassage
    'norra n asfalterad+e stig+en/trapp|steg+en/trappa+n/trappor+na' 'trappsteg'
    "Gångvägen stiger några trappsteg norrut. "
    isPlural = true

    dobjFor(ClimbUp) asDobjFor(Enter)
    dobjFor(Climb) asDobjFor(Enter)
;

+ TreeDecoration 'stor:t+a tät:t+a  apelsinträd+et*apelsinträd+en lövverk+en' 'apelsinträd'
    "De är stora träd med tätt lövverk och massor av apelsiner. "
    isPlural = true

    lookInDesc = "Förutom apelsinerna ser du inget i träden. "
;
++ OrangeDecoration;

+ EntryPortal ->(location.east)
    'falska dekorativa passage+n/stenarbete+t*bokstäver+na' 'passage'
    "Det är en generöst tilltagen passage som leder österut. Passagen
    är inramad av dekorativt falskt stenarbete, och orden <q>DABNEY HOVSE</q>
    är inskrivna ovanför den. (Bokstäverna är utformade för att se ut som
    om de är huggna i sten, men de är faktiskt bara stämplade i
    stucken.) "
;

+ Enterable ->(location.east)
    'stor+a stuck dabney+s byggnad+en/hus+et/house/hovse/hovses/ord+en' 'Dabney House'
    "Det är en stor stuckbyggnad designad för att likna klassisk
    medelhavs-arkitektur. Orden <q>DABNEY HOVSE</q> är
    inskrivna ovanför passagen österut. "

    isProperName = true
;

+ orwWestPath: PathPassage ->syncEastPath
    'västra v oasfalterad+e jord|stig+en' 'oasfalterad stig'
    "Den oasfalterade stigen leder västerut genom apelsinträden. "
;

+ owMovers: MitaMovers
    "En till synes ändlös ström av flyttarbetare kommer upp från California
    Boulevard och går in i Dabney, bärande lådor och packlårar. Andra
    återvänder från Dabney tomhänta, förmodligen på väg att hämta
    nästa last. "

    "Mitachron-flyttarbetare arbetar sig upp från California Boulevard
    och in i Dabney, bärande laster av lådor och packlårar. "
;

/* lägg till vår California Blvd-instans och dess beståndsdelar */
+ orwCalBlvd: CalBlvd;
++ CalBlvdTraffic;
+++ CalBlvdNoise;

/* ------------------------------------------------------------------------ */
/*
 *   Sync-parkeringen 
 */
syncLot: CampusOutdoorRoom 'Sync-parkeringen' 'Sync-parkeringen' 'parkeringsplats'
    "Denna smala parkeringsplats har bara plats för fyra eller fem bilar;
    de som är parkerade här idag ser ut som om de inte har flyttats
    på ett tag. Den gråa massan av Synkrotronlaboratoriet tornar upp sig i
    väster, utan särdrag förutom en matt metalldörr, och baksidan
    av Firestone reser sig i norr. En rad apelsinträd kantar
    parkeringsplatsen i öster; en jordstig leder genom
    träden. I söder ligger California Boulevard. "

    vocabWords = '(sync) (synkrotron) parkering+en parkeringsplats+en'

    west = syncDoor
    east = syncEastPath
    south = syncCalBlvd
;

+ CampusMapEntry 'synkrotron sync synch lab labb+et/laboratorium+et'
    'Synkrotronlaboratoriet' 'sydost';

+ syncEastPath: PathPassage 'östra ö oasfalterad+e jordstig+en' 'jordstig'
    "Stigen leder österut genom en rad apelsinträd. "
;

+ TreeDecoration 'stor:t+a tät:t+a apelsin|träd+et/lövverk+et' 'apelsinträd'
    "De är stora träd med tätt lövverk och massor av apelsiner. "
    isPlural = true

    lookInDesc = "Förutom apelsinerna ser du inget i träden. "
;
++ OrangeDecoration;

+ Decoration 'gamla äldre parkera+e bil+en*bilar+na automobiler+na' 'bilar'
    "Fem bilar är inträngda på parkeringen idag. De är mestadels äldre
    modeller, och de ser ut som om de inte har flyttats på ett tag. "
    isPlural = true
    notImportantMsg = 'Du bör inte röra andra människors bilar. '
;

+ syncDoor: LockableWithKey, Door
    'matt+a  (synkrotron) (sync|labbets) (laboratorium+ets) metall+dörr+en'
    'matt metalldörr'
    "Dörren är gjord av en matt metall. "
;

+ Immovable
    'tvåvånings grå sync lab synkrotron labb+et laboratorium+et sync-|labbet/sync-|byggnad+en/massa+n/vägg+en'
    'Sync-labbet'
    "Det enda kännetecknet på den tvåvånings gråa byggnaden är en matt
    metalldörr. Sync-labbet har fått sitt namn eftersom det inhyste en
    synkrotron partikelaccelerator på 1960-talet, men den har
    sedan länge demonterats. "

    dobjFor(Enter) remapTo(Enter, syncDoor)
;
+ Immovable
    'trevånings firestone lab laboratoriumets bakre byggnadens vägg+en/sida+n/baksida+n'
    'baksidan av Firestone'
    "Denna sida av Firestone är bara en intetsägande trevåningsvägg. "

    dobjFor(Enter) { verify() { illogical('Det finns ingen ingång till
        Firestone här. '); } }
;
 
/* lägg till vår California Blvd-instans och dess beståndsdelar */
+ syncCalBlvd: CalBlvd;
++ CalBlvdTraffic
    /* detta är ännu mindre sannolikt än de parkerade bilarna för UNDERSÖK */
    dobjFor(Examine) { verify() { logicalRank(50, 'x dekoration'); } }
;
+++ CalBlvdNoise;

/* ------------------------------------------------------------------------ */
/*
 *   Västra olivgången
 */
westOliveWalk: CampusOutdoorRoom 'Västra Olivgången' 'västra Olivgången'
    'Olivgången'
    "Olivgången löper öster och väster här genom en bred gräsmatta
    flankerad av akademiska byggnader. På norra sidan finns den beigea,
    rektangulära vidden av Thomas. Firestone, i sydost,
    och Guggenheim, i sydväst, är sammankopplade av en
    bro på andra våningen över det breda gapet mellan dem; en asfalterad
    gångväg leder söderut under bron. "

    vocabWords = 'v+ästra oliv|gång+en'

    east = wowEastWalk
    west = wowWestWalk
    south = wowSouthWalk
    north = wowThomasDoor

    southeast = firestoneDoor
    southwest = guggenheimDoor

    /* 
     *   Efter att vi har klättrat på Firestone en gång, tillåt klättring igen genom
     *   att helt enkelt säga 'upp'. Om vi inte har klättrat på Firestone minst
     *   en gång redan, eller om vi inte är positionerade för att göra det just nu, använd den
     *   ärvda 'upp' istället.  
     */
    up = (gActor.isIn(cherryPickerBasket)
          && cherryPickerBasket.isRaised
          && gActor.hasSeen(climbingFirestone)
          ? wowFirestoneLattice : inherited)

    /* tillhandahåll speciella beskrivningar för skyliften när den är här */
    descCherryPickerArrival = "Du styr skyliften till en plats
        utanför stigen, precis intill väggen på Firestone, och parkerar. "
    inCherryPickerSpecialDesc = "Du står i korgen på en
        skylift, som är parkerad intill Firestone.
        <<cherryPickerBasket.isRaised
          ? "Botten av det spjälliknande gallret är inom räckhåll
            från korgen." : "">> "
    cherryPickerSpecialDesc = "En skylift är parkerad intill
        Firestone. "
    noteCherryPickerRaised = "<.p>Det spjälliknande gallret som vetter mot Firestone
        är nu inom räckhåll. "
;

+ CampusMapEntry 'firestone labb+et/laboratorium' 'Firestone-laboratoriet' 'söder';
+ CampusMapEntry 'guggenheim labb+et/laboratorium' 'Guggenheim-laboratoriet' 'söder';
+ CampusMapEntry 'thomas labb+et/laboratorium' 'Thomas-laboratoriet' 'söder';

+ Decoration 'röd+a stig+en/tegel*tegelstenar+na' 'tegelstenar'
    "Stigen är belagd med ganska vanliga röda tegelstenar. Den fortsätter
    österut och västerut. "
    isPlural = true
;

+ firestoneDoor: AlwaysLockedDoor
    'främre vit+a metall (firestone) (firestone)/dörr+en*dörrar+na'
    'dörren till Firestone'
    "Framdörren till Firestone är bara en enkel metalldörr målad i vitt. "
    cannotOpenLockedMsg = 'Dörren verkar vara låst. Säkerhetspersonalen kan
        inte ha brytt sig om att låsa upp byggnaden idag, eftersom de visste att
        de flesta lektioner skulle ställas in för Skolkdagen. '
;

+ guggenheimDoor: AlwaysLockedDoor
    'främre trä (guggenheim) (guggenheim)/trä|dörr+en*trä|dörrar+na' 'dörren till Guggenheim'
    "Det är en enkel trädörr. "
    cannotOpenLockedMsg = 'Dörren verkar vara låst. Det är konstigt
        att campusbyggnader är låsta under dagen, men de vanliga
        rutinerna gäller inte alltid på Skolkdagen. '
;

+ wowWestWalk: PathPassage '(tegel) v+ästra stig+en/gångväg+en' 'västra gångvägen'
    "Gångvägen leder västerut. "
;

+ wowEastWalk: PathPassage ->quadWestWalk
    '(tegel) ö+stra stig+en/gångväg+en' 'östra gångvägen'
    "Gångvägen leder österut. "
;

+ wowSouthWalk: PathPassage ->ldcNorthWalk
    's+ödra gång+en/gångväg+en' 'södra gångvägen'
    "Gångvägen leder söderut, under bron på andra våningen. "
;

+ TreeDecoration 'olivträd+en/grenar+na' 'olivträd'
    "Olivträden här är planterade slumpmässigt runt gräsmattan. "
    isPlural = true
;

+ Decoration 'bred+a gräs+et/gräsmatta+n' 'gräsmatta'
    "Den breda gräsmattan är här och där prickad med olivträd. "
;

+ Enterable ->(location.southeast)
    'firestone flyg|vetenskap+liga labb+et/laboratorium+et/vägg+en/byggnad+en*byggnader+na*väggar+na'
    'Firestone-labbet'
    "Firestone är flygvetenskapslabbet. Byggnaden är
    tre våningar hög och har en fasad med en serie spjälliknande
    galler. Dörren är i sydost. "

    isProperName = true

    dobjFor(Climb) remapTo(Climb, wowFirestoneLattice)
    dobjFor(ClimbUp) remapTo(Climb, wowFirestoneLattice)
;
++ wowFirestoneLattice: OutOfReach, TravelWithMessage, StairwayUp ->cfDown
    '(firestone) asterisk spjälverk+et/x:en/gallret/serie+n
    *spjälverk+en kolonner+na galler+na gallren+a plustecken+a former+na'
    'spjälverk'
    "Gallren täcker inte hela byggnadens fasad utan
    är utplacerade i kolonner, där varje kolumn börjar på andra våningen och
    fortsätter upp till taklinjen. Varje spjälverkskolumn är ett rutnät av små
    asteriskformer, X:en överlagrade på plustecken&mdash;perfekt dimensionerade
    som handtag för klättring. Säkerhetspersonalen rynkar kraftigt på näsan
    åt alla som klättrar på byggnaden, men det är ett alltför lockande mål,
    och det verkar som om någon tar sig an utmaningen varje år.
    Naturligtvis är detta inte trivialt, eftersom botten av varje spjälverk är
    högt över huvudet. "

    /* vi kan nå detta endast från den upphöjda skyliftarkorgen */
    canObjReachContents(obj)
    {
        /* 
         *   'obj' måste vara i skyliften, och korgen måste vara
         *   upphöjd; annars kan vi inte nå byggnaden 
         */
        return obj.isIn(cherryPickerBasket) && cherryPickerBasket.isRaised;
    }

    /* förklara att det är utom räckhåll - åtminstone från marken */
    cannotReachFromOutsideMsg(dest) { return 'Spjälverket börjar på
        andra våningen. Du kan inte nå det från marken. '; }

    /* 
     *   detta objekt är nåbart från den upphöjda skyliften, och ENDAST
     *   från den upphöjda skyliften 
     */
    isRaisedCherryPickerReachable = true

    /* för att klättra denna väg måste vi börja i skyliftarkorgen */
    connectorStagingLocation = cherryPickerBasket

    /* tillämpa några speciella förhandsvillkor */
    connectorTravelPreCond()
    {
        local lst;
        
        /* hämta den ärvda listan */
        lst = inherited();

        /* dessutom måste våra händer vara tomma */
        lst += handsEmpty;

        /* 
         *   Ta bort förhandsvillkoret för startplatsen. Vår startplats
         *   är viktig, men vi behöver eller vill inte ha ett
         *   förhandsvillkor för det. Vi behöver inte förhandsvillkoret eftersom
         *   det faktum att spjälverket är utom räckhåll är tillräckligt för att förhindra
         *   klättring på spjälverket tills vi är i den upphöjda skyliften.
         *   Vi vill inte ha förhandsvillkoret eftersom vi vill låta
         *   spelaren lista ut vad som ska göras - vi vill inte göra
         *   detta automatiskt. 
         */
        lst = lst.subset({x: !x.ofKind(TravelerDirectlyInRoom)});

        /* returnera resultatet */
        return lst;
    }

    /* lägg till ett meddelande vid förflyttning */
    travelDesc { travelDescScript.doScript(); }
    travelDescScript: StopEventList { [
        'Du klättrar försiktigt upp på kanten av korgen
        och sträcker dig efter Firestone-gallret. Mönstret av
        spjälverket erbjuder överraskande lätta handtag.
        Du känner att du har ett säkert grepp om väggen, så du
        tar ena foten från korgen och söker efter ett fotfäste.
        Inga problem hittills. Du tar ett djupt andetag och bestämmer
        dig, tar den andra foten från korgen och flyttar
        hela din vikt till väggen.
        <.p>Du faller inte omedelbart, så du försöker röra dig
        upp längs väggen några centimeter. Det är faktiskt ganska lätt;
        nästan som att klättra på en stege. Du rör dig upp några decimeter,
        och börjar få grepp om tekniken. ',
        
        'Du sträcker dig efter väggen och hittar ett handtag, sedan
        flyttar du dina fötter över. Du klättrar upp längs väggen några decimeter. '] }

    /* "kliv på galler" är detsamma som att klättra på det */
    dobjFor(Board) remapTo(Climb, self)
;

+ Enterable ->(location.southwest)
    'guggenheim aeronautik labb+et/laboratorium+et/vägg+en/byggnad+en*byggnader+na väggar+na'
    'Guggenheim-labbet'
    "Guggenheim är ett aeronautiklabb. Det är en trevånings
    byggnad med stora fönster inramade i smidesjärn. Härifrån
    kan du precis skymta vindtunnelstrukturen på
    byggnadens tak. Ingången är i sydväst. "

    isProperName = true
;

++ wowWindTunnel: Distant 'vindtunnel+n/vindtunnel|struktur+en' 'vindtunnel'
    "Du kan knappt se den långa, låga strukturen på taket
    av Guggenheim. Du kan inte urskilja några detaljer härifrån. "
;

++ Distant 'smidesjärn+et ram+en/ramar+na/fönster*fönstren (guggenheim)'
    'fönstren på Guggenheim'
    "Fönstren är stora, med många rutor i smidesjärnsramar. "
    owner = (location)
;

+ Enterable ->(location.north)
    'beige rektangulär+a thomas civil+a mekanisk+a teknik vid+a
    labb+et/laboratorium+et/vägg/byggnad+en*byggnader+na*'
    'Thomas-labbet'
    "Thomas är byggnaden för civil- och maskinteknik. Det är
    en stor byggnad med vad du alltid har tyckt är ett ganska
    spartanskt utseende: det är i princip en stor rektangulär låda,
    tre våningar hög, med ett regelbundet rutnät av små fönster kantade
    med rektangulära galler av smidesjärn. En dörr i mitten av
    strukturen leder in. "

    isProperName = true
;
++ wowThomasDoor: Door
    'bred+a dubbel dubbla (thomas) dörr+en/(thomas)/(labb+et)/(laboratorium+et)*dörrar+na'
    'dörr till Thomas'
    "Det är en bred dubbeldörr, men Thomas massiva storlek får den att se
    som en miniatyr . "
;

++ Distant
    '(thomas) smidesjärn^s+fönster+et/fönstret/rutnät+et/ruta+n/rutor+na/ram+en*ramar'
    'fönstren på Thomas'
    "Fönstren är arrangerade i ett regelbundet rutnät, och varje fönster
    är i sig ett rutnät av rutor i en smidesjärnsram. "
    isPlural = true
    owner = (location)
;

+ Distant 'andra våningens våning+en bro+n' 'bron på andra våningen'
    "Bron är dekorerad med samma spjälverksfront
    som Firestone. Den förbinder Firestone och Guggenheim på deras
    andra våningar. En gångväg leder söderut under bron. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Climbing on the Firestone grill 
 */
climbingFirestone: Floorless, CampusOutdoorRoom
    'Klättrar på Firestone' 'halvvägs upp på sidan av Firestone'
    "Denna punkt är ungefär halvvägs upp på sidan av Firestone. Det
    spjälliknande gallret som täcker byggnaden är relativt lätt att
    klättra på; det sträcker sig uppåt till taket och nedåt till ungefär en
    våning ovanför marknivå. "

    up = cfUp
    down = cfDown

    roomBeforeAction()
    {
        /* don't allow taking or dropping anything here */
        if (gActionIs(Take) || gActionIs(TakeFrom)
            || gActionIs(Doff) || gActionIs(Drop))
        {
            "Dina händer är redan fullt sysselsatta att hålla fast 
            sidan av byggnaden. ";
            exit;
        }

        /* if we try to jump, it's the same as 'down' */
        if (gActionIn(Jump, JumpOffI))
            replaceAction(Down);
    }

    /* on entry, set up the proxy version of the cherry picker */
    enteringRoom(traveler)
    {
        /* set up the local proxy version of the cherry picker */
        cfCherryPicker.makePresentIf(cherryPicker.isIn(westOliveWalk));
    }
;

+ Fixture
    'främre norra spjälverk+ets firestone asteriskformade
    vägg+en/galler/gallret/byggnad+en/labb+et/laboratorium+et/firestone'
    'väggen på Firestone'
    "Det asteriskformade mönstret på gallret är relativt lätt
    att hålla sig fast i. Spjälverket fortsätter upp till taket, men
    slutar nedåt vid ungefär en våning ovanför marknivå. "

    dobjFor(JumpOff)
    {
        verify() { }
        action() { replaceAction(Down); }
    }

    /* climbing up/down the wall maps to climbing the internal connectors */
    dobjFor(ClimbUp) remapTo(TravelVia, cfUp)
    dobjFor(Climb) remapTo(TravelVia, cfUp)
    dobjFor(ClimbDown) remapTo(TravelVia, cfDown)
;

/* an internal connector leading up to the roof */
+ cfUp: TravelWithMessage, StairwayUp ->frGrill
    travelDesc = "Du arbetar dig upp till toppen av väggen. 
                  Så snart du är på toppen, rullar du dig 
                  över kanten till taket. "

    /* we're for internal use only, so hide from 'all' */
    hideFromAll(action) { return true; }
;

/* an internal connector leading down to ground level */
+ cfDown: TravelWithMessage, StairwayDown
    travelDesc = "Du klättrar försiktigt ner längs gallret tills du är i nivå
        med korgen, sedan tar du dig försiktigt in i korgen. "

    /* we're for internal use only, so hide from 'all' */
    hideFromAll(action) { return true; }

    /* our destination is the cherry picker basket */
    destination = cherryPickerBasket

    /* 
     *   we can only go down if the cherry picker is below us and the
     *   basket is raised 
     */
    canTravelerPass(trav)
    {
        return cfCherryPicker.isIn(location) && cherryPickerBasket.isRaised;
    }
    explainTravelBarrier(trav) { "Gallret slutar ungefär en våning upp,
        så du kan inte klättra ner tillräckligt långt för att säkert hoppa ner
        till marken. "; }
;

+ Distant 'oliv|mark+en/gång+en/gångväg+en/gräsmatta' 'mark'
    "Marken är ungefär två våningar nedanför. "
;

+ Distant 'thomas labb+et/byggnad+en' 'Thomas-labbet'
    "Thomas ligger över gräsmattan, på avstånd norrut. "
    isProperName = true
;
/* a local proxy for the cherry picker */
+ cfCherryPicker: PresentLater, Distant
    'skylift+en' 'skyliften'
    desc()
    {
        "Skyliften är direkt nedanför. ";
        if (cherryPickerBasket.isRaised)
            "Dess korg är upphöjd till full höjd,
            så det borde inte vara för svårt att klättra in i den härifrån. ";
        else
            "Korgen är dock nedsänkt, så det finns ingen möjlighet att
            klättra in i den härifrån. ";
    }
    specialDesc = "Skyliften är parkerad intill byggnaden,
        nästan direkt nedanför. "

    /* we can enter it without touching it */
    dobjFor(Enter) remapTo(TravelVia, cfDown)
    dobjFor(Board) asDobjFor(Enter)
    dobjFor(StandOn) asDobjFor(Enter)
;
++ Distant
    '(skylift+ens) skylift^s+korg+en' 'korgen på skyliften'
    desc()
    {
        if (cherryPickerBasket.isRaised)
            "Korgen är upphöjd till full höjd, vilket placerar den på
            ungefär andra våningens nivå. Det borde inte vara för svårt att
            klättra in i den härifrån. ";
        else
            "Korgen är nedsänkt, så det finns ingen möjlighet att klättra
            in i den härifrån. ";
    }

    /* we can enter it without touching it */
    dobjFor(Enter) remapTo(TravelVia, cfDown)
    dobjFor(Board) asDobjFor(Enter)
    dobjFor(StandOn) asDobjFor(Enter)
;

/* ------------------------------------------------------------------------ */
/*
 *   A class for our complex of roofs around Firestone 
 */
class RoofRoom: CampusOutdoorRoom
    /* 
     *   we can't use the map to navigate from here, as we're not
     *   trivially connected to the ground map 
     */
    cannotUseMapHere = "Du måste ta dig ner till marken innan
        du kan gå dit, naturligtvis. "

    /* don't use the standard ground; we'll use a special 'roof' instead */
    roomParts = static (inherited - defaultGround)

    roomBeforeAction()
    {
        if (gActionIn(Jump, JumpOffI))
        {
            "Det är för långt ner till marken för att hoppa. ";
            exit;
        }
    }
;
/* ------------------------------------------------------------------------ */
/*
 *   Roof of Firestone 
 */
firestoneRoof: RoofRoom 'Firestones tak' 'taket på Firestone' 'tak'
    "En knähög kant löper runt omkretsen av detta platta,
    tjärbelagda tak, vilket ger ett visst skydd mot
    att gå över kanten. Talrika ventiler, rör och andra installationer
    sticker ut på slumpmässiga ställen.
    <.p>Taket smalnar av och fortsätter västerut, över bron
    som förbinder Firestone och Guggenheim. Det spjälliknande gallret
    som vetter mot byggnadens norra sida går upp till taklinjen,
    så det borde vara möjligt att klättra ner den vägen. I det sydöstra
    hörnet leder en stege ner längs den södra väggen. "

    vocabWords = 'firestone labb+et/laboratorium+et/byggnad+en/(tak+et)'

    north = frGrill
    west = guggenheimRoof
    southeast = frLadder

    /* 'down' is ambiguous, so ask what they intend to climb down */
    down: AskConnector {
        travelAction = ClimbDownAction
        askMissingObject(actor, action, which)
        {
            "Vill du klättra ner för stegen eller framsidan
            av Firestone? ";
        }
    }

    /* 'climb down firestone' == 'climb down grill' */
    dobjFor(Climb) remapTo(TravelVia, frGrill)
    dobjFor(ClimbDown) remapTo(TravelVia, frGrill)
;

+ Floor 'platt+a tjär+belagd+a tjär+belagt tak+et/golv+et' 'tak'
    "Det är ett platt, tjärbelagt tak. "
    dobjFor(JumpOff) remapTo(Jump)
;

+ Decoration 'knähög+a kant+en/(taket)' 'takkant'
    "Kanten är ungefär 60 centimeter hög och löper runt takets omkrets.
    Den är förmodligen mer avsedd att blockera vattenavrinning
    än att skydda klättrare. "
    dobjFor(JumpOff) remapTo(Jump)
;

+ Decoration 'ventil+en/rör+et*ventiler+na rör+en installationer+na' 'installationer'
    "Utskjutningarna skulle göra det farligt att gå omkring här uppe
    på natten, men de är lätta att undvika i dagsljus. "
    isPlural = true
;

+ Distant, Decoration
    'guggenheim (tak+et)/(labb+et)/(laboratorium+et)/(byggnad+en)' 'Guggenheim'
    "Guggenheim är nästa byggnad västerut, men taken är förbundna
    via bron. "
;

+ Enterable ->(location.west) '(tak+et) bro+n' 'bro'
    "Härifrån är bron helt enkelt en något smalare del av
    taket som leder västerut. "
;

+ Distant, Decoration 'mark+en/gångväg+en' 'mark'
    "Marken är tre våningar nedanför. "
;
+ Distant, Decoration 'skylift^s+korg+en' 'skylift'
    "Skyliften är för nära väggen och för långt
    nedanför för att få en bra titt härifrån. "
;

+ frGrill: TravelWithMessage, StairwayDown
    'norra n främre spjälverk+et galler/gallret/vägg+en/sida+n/(byggnad+en)/(firestone)'
    'spjälliknande galler'
    "Byggnaden är täckt med ett spjälliknande galler, vars
    asteriskformade öppningar ger bra grepp för klättring. "

    travelDesc = "Du backar till takets norra kant och
        lägger dig ner på kanten, sedan sänker du ner benen över kanten.
        Du hittar ett fotfäste och börjar ta dig ner för väggen. "

    /* hands must be empty to climb down the building */
    connectorTravelPreCond = (inherited() + handsEmpty)
    isNeuter = true
    definiteFrom = 'gallret'
;

+ frLadder: StairwayDown 'metall|stege+n' 'stege'
    "Metallstegen är permanent fäst vid takets sydvästra
    hörn. Den leder över takkanten, ner
    längs byggnadens södra sida. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Guggenheim roof 
 */
guggenheimRoof: RoofRoom
    'Guggenheims tak' 'taket på Guggenheim' 'tak'
    "Hela södra sidan av taket domineras av Guggenheims
    vindtunnel: en lång, låg stålkonstruktion som liknar ett
    extremt förlängt förråd. <<grPanel.roomDesc>> Taket
    fortsätter österut och smalnar av över bron som förbinder
    Guggenheim med Firestone. "

    vocabWords = 'guggenheim lab+bet/laboratorium+et/byggnad+en/(tak+et)'

    east = firestoneRoof
    south: NoTravelMessage { "Det finns ingen uppenbar ingång till
        konstruktionen här. Vilket inte är förvånande: du förväntar dig att
        vindtunnelforskarna tar sig in från insidan av Guggenheim, inte
        genom att klättra på ytterväggarna. " }
    down: NoTravelMessage { "Guggenheims fasad är inte lika
        klättringsvänlig som Firestone, så det finns ingen uppenbar
        väg ner härifrån. " }
;

+ Floor 'platt+a tjär+belagd+a tjärbelagt tak+et/golv+et' 'tak'
    "Det är ett platt, tjärbelagt tak. "
    dobjFor(JumpOff) remapTo(Jump)
;

+ Distant, Decoration 'mark+en' 'mark/gångväg'
    "Marken är tre våningar nedanför. "
;

+ Distant, Decoration
    'firestone (tak+et)/(labb+et)/(laboratorium+et)/(byggnad+en)' 'Firestone'
    "Firestone är nästa byggnad österut, men taken är förbundna
    via bron. "
;

+ Enterable ->(location.east) '(tak+et) bro+n' 'bro'
    "Härifrån är bron helt enkelt en något smalare del av
    taket som leder österut. "
;

+ Enterable ->(location.south)
    'lång+a låg+a stål (guggenheim) vind konstruktion+en/vind|tunnel+n/vägg+en'
    'vindtunnel'
    "Konstruktionen sträcker sig över hela Guggenheims öst-västliga utsträckning, men
    den är låg och smal. Ett komplext nätverk av rör och ledningar
    löper längs konstruktionens väggar, vänder och vrider sig
    runt varandra. En grupp rör gör rätvinkliga svängar
    runt <<grPanel.aName>> lågt på väggen. "
;
++ Fixture 'komplex+a metall+aktiga elektrisk+a metall|rör+et/nätverk+et*rör+ledningar+na' 'rör'
    "Metallrör är uppradade längs väggen, mestadels löpande
    horisontellt men vänder ofta för att ge plats åt
    andra rör, eller för att gå in i konstruktionen, eller för att dyka ner
    genom taket. Elektriska ledningar är blandade med
    rören. "
    isPlural = true
;
++ grPanel: TravelWithMessage, Door ->wtPassage
    'åtkomst li:ten+lla låg+a panel+en/dörr+en/passage+n' 'liten panel'
    "Panelen ser ut att vara en liten dörr, ungefär en meter i kvadrat,
    nära väggens nedre del. Det är förmodligen en åtkomstlucka
    för mekaniskt arbete på tunnelapparaten. "

    makeOpen(stat)
    {
        /* do the normal work */
        inherited(stat);

        /* if this is the first time being opened, do some extra work */
        if (stat && !openedBefore)
        {
            /* make me the way south when I'm first opened */
            guggenheimRoof.south = self;

            /* we've been opened now */
            openedBefore = true;

            /* mention what we see */
            "När panelen öppnas avslöjas en passage som verkar
            leda in i konstruktionen. ";
        }

        /* change the name to passage or panel, according to our status */
        name = (stat ? 'åtkomstlucka' : 'liten panel');
    }

    travelDesc = "Du går ner på alla fyra och kryper genom
        passagen. "

    roomDesc()
    {
        if (openedBefore)
            "En liten, låg dörr leder in i konstruktionen. ";
    }

    /* have we been opened before? */
    openedBefore = nil
;
// ... fixa resten av vocabWords
/* ------------------------------------------------------------------------ */
/*
 *   Wind tunnel interior 
 */
windTunnel: Room 'Vindtunnellabb' 'vindtunnellabbet'
    "Detta är ett långt, lågt, smalt utrymme, proppfullt med utrustning. Det
    verkar inte vara den sortens vindtunnel med en gigantisk fläkt
    i ena änden av ett stort, tomt rum. Istället ser 'tunneln'
    mer ut som en cementblandare: en ljusblå metallcylinder
    ungefär tre meter lång och två meter i diameter, liggande på sidan.
    Cylindern är avsmalnande till en mindre diameter i varje ände, där
    den är ansluten till staplar av tung industriell maskineri som skulle
    passa in i en bilfabrik.
    <.p>En spiraltrappa av smidesjärn leder ner i ett smalt schakt.
    En låg dörr mot norr, nästan dold under delar av utrustningen,
    leder utomhus. "

    north = wtPassage
    out asExit(north)
    down = wtStairs
;

+ wtPassage: TravelWithMessage, Door
    'li:ten+lla låg+a passage+n/dörr+en' 'låg dörr'
    "Det är en liten dörr, bara ungefär en meter hög, som leder
    ut ur konstruktionen norrut. "

    travelDesc = "Du går ner på händer och knän och kryper ut
        genom passagen. "
;

+ wtStairs: StairwayDown ->wtsStairs
    'svart+a smidesjärn spiral+formad+e smal+a spiral|trappa+n/trappa+n/trappuppgång+en/schakt+et*trappor+na'
    'spiraltrappa'
    "Den smala spiraltrappan leder ner i ett schakt. "
    isPlural = true
;

+ Decoration
    'tung+a industriell+a mätning bildbehandling
    utrustning+en/del+en/delar+na/maskineri+et/rörledningar+na/kompressorer+na/pumpar+na/
    mät|apparatur+en/bildbehandlings|apparatur+en'
    'utrustning'
    "Mycket av utrustningen, särskilt det industriliknande
    maskineriet, verkar vara rörledningar för vindtunneln, förmodligen
    kompressorer och pumpar och liknande. Annan utrustning är tydligt
    bildbehandlings- och mätapparatur. "

    isMassNoun = true

    notImportantMsg = 'Vindtunneln är utan tvekan både ömtålig
        och kraftfull, så du skulle förmodligen kunna orsaka en hel del skada om du
        började leka med den. '

    dobjFor(LookUnder) { action() { "En låg dörr som leder norrut är
        delvis dold under en del av utrustningen som är staplad
        längs väggen. Förutom det ser du inget
        annat än mer maskineri. "; } }
;

+ ComplexContainer, Fixture
    'ljusblå+a metall vind cement tunnel+n/cylinder+n/blandare+n'
    'metallcylinder'
    "Cylindern verkar vara huvuddelen av vindtunneln.
    Den ligger på sidan; den är ungefär tre meter lång och två meter
    i diameter, så den fyller nästan hela den korta golv-till-tak
    höjden i rummet. Cylindern smalnar av i varje ände till
    en mindre diameter. Många delar av utrustningen är fästa vid
    cylindern i varje ände. En rund, stållucka, ungefär 60
    centimeter i diameter, ger tillgång till insidan; den är
    för närvarande <<subContainer.openDesc>>. "

    subContainer: ComplexComponent, OpenableContainer {
        /* 
         *   use the normal container contents lister, as we describe the
         *   open/closed status explicitly in the long description (the
         *   openable contents lister would add its own open/closed status
         *   description, which we don't want in this case) 
         */
        descContentsLister = thingDescContentsLister
    }
;

++ ContainerDoor 'rund+a stål metall lucka+n' 'lucka'
    "Det är en rund metallucka, ungefär 60 centimeter i diameter. "
;

++ squirrel: TurboPowerAnimal
    'turbo power ekorr^s+actionfigur+en/ekorre+n/mjukisdjur+et/ekorre-actionfigur+en' 'ekorre-actionfigur'
    "Den är hälften en robot, till hälften ett mjukisdjur, och liknar vagt en
    ekorre. <q>Turbo Power Ekorre!</q> står emblazerat på
    framsidan. "
    isIt = true
    isHim = true
    
    subLocation = &subContainer

    /* make us known from the start, as we're mentioned in a stack */
    isKnown = true
;

/* ------------------------------------------------------------------------ */
/*
 *   The little room at the bottom of the wind tunnel stairs.  This room is
 *   only here for "realism" - there obviously has to be a way into the
 *   wind tunnel from within Guggenheim, since the scientists working in
 *   the wind tunnel wouldn't get there by climbing the face of Firestone,
 *   crossing over the roof, and crawling in the access door.  We don't
 *   want the player to be able to enter Guggenheim at all, though, so this
 *   is just a dead-end on the game map: it's meant to suggest a connection
 *   to the interior of Guggenheim without actually providing one.  
 */
windTunnelShaft: Room 'Botten av trappan' 'botten av trappan'
    'smalt schakt'
    "Detta är botten av ett smalt schakt som innehåller en spiraltrappa
    av smidesjärn. En gammal trädörr leder söderut. "
    
    vocabWords = 'smal:t+a schakt+et/botten/bottnen/(trappa+n)/(trappuppgång+en)'

    up = wtsStairs
    south = wtsDoor

    /* we have no ceiling, since we're the bottom of a shaft */
    roomParts = static (inherited - defaultCeiling)
;

+ wtsStairs: StairwayUp
    'svart+a smidesjärn+et spiral+en smal+a trappa+n/trappuppgång+en'
    'spiraltrappa'
    "Den smala svarta trappan stiger upp genom schaktet. "
;

+ wtsDoor: AlwaysLockedDoor 'gam:mal+la mörk+a trä|dörr+en' 'trädörr'
    "Dörren är gjord av ett mörkt trä och ser gammal och sliten ut. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Thomas Lobby 
 */
thomasLobby: Room 'Thomas entréhall' 'Thomas entréhall' 'entréhall'
    "Denna breda entré med högt i tak är panelad med mörkt trä,
    vilket får den att kännas lite dyster. Dörrar leder från entrén
    åt öster och väster, och en bred dubbeldörr leder ut
    söderut.
    <.p>En handskriven skylt tejpad på den östra dörröppningen lyder
    <q>Robottävling,</q> med en pil som pekar österut. "

    vocabWords = 'thomas entréhall+en'

    south = tlSouthDoor
    out asExit(south)
    east = tlEastDoor
    west = tlWestDoor
;

+ Decoration
    'blank+a mörk+a lackerad+e träd+et 
    trä+et/lack+en/finish+en/trä+et/panel+en/panelering+en*paneler+na'
    'mörkt trä'
    "Trots den blanka lackerade ytan är träet så mörkt, och
    det finns så mycket av det, att det ger rummet ett dystert utseende. "
;

+ tlSouthDoor: Door ->wowThomasDoor 'bred+a dubbel+dörr+en*dörrar+na' 'dubbeldörr'
    "Den breda dubbeldörren leder söderut, utomhus. "
;

+ Fixture, Readable 'handskriv:en+na skylt+en' 'skylt'
    "På skylten står det <q>Robottävling,</q> skrivet ovanför
    en pil som pekar in i rummet österut. "
    cannotTakeMsg = 'Du har ingen anledning att ta ner skylten. '
;

+ tlEastDoor: Door -> teWestDoor 'ö+stra dörr+öppning+en*dörrar' 'östra dörr'
    "Dörren leder in i ett rum österut. En skylt tejpad på
    dörren lyder <q>Robottävling,</q> med en pil som pekar
    in i rummet. "
;

+ tlWestDoor: Door -> twEastDoor 'v+ästra dörr+öppning+en*dörrar' 'västra dörr'
    "Dörren leder västerut. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Thomas west classroom 
 */
thomasWest: Room 'Klassrum' 'klassrummet'
    "Detta är ett stort klassrum, med ungefär ett dussin rader av
    inbyggda trästolar vända mot en bred svart tavla. En dörr
    leder ut österut. "

    vocabWords = 'klass|rum+met'

    east = twEastDoor
    out asExit(east)
;

+ twEastDoor: Door 'ö+stra dörr+öppning+en' 'östra dörr'
    "Dörren leder ut österut. "
;

+ Fixture, Chair 'trä trä|rad+en/stol+en*stolar+na rader+na säte+n säten+a trä|rader+na' 'trästolar'
    "Stolarna är alla fastmonterade, ordnade i ungefär
    ett dussin rader. "
    isPlural = true

    dobjFor(SitOn) { action() { "Det är inte mycket mening med det när
        det inte pågår någon föreläsning. "; } }
;

+ Fixture, Readable 'bred+a svart+a tavla+n' 'svarta tavlan'
    "Den svarta tavlan är lika bred som rummet. Den har lite 
    obegripliga klotter, delvis utsuddade, från en nylig
    föreläsning. "
;
++ Fixture, Readable 'obegripligt obegripliga klottret/klotter/skrift+en'
    'klotter på svarta tavlan'
    "Det finns inget du kan tyda; det mesta av skriften har
    redan suddats ut. "
    isNeuter = true
;

/* ------------------------------------------------------------------------ */
/*
 *   Thomas east - robotics competition room
 */
thomasEast: Room 'Robotlabb' 'robotlabbet'
    "Detta är ett stort, öppet rum, med en dörr som leder ut västerut.
    En miniatyr-hinderbana fyller golvet: små orange trafikkoner,
    halvcylindrar av plåt som fungerar som tunnlar, träramper.
    Allt är i ungefär rätt skala för en chihuahua, men med tanke på
    skylten utanför måste det vara för småskaliga robotar. "

    vocabWords = 'robot labb+et/laboratorium+et'

    west = teWestDoor
    out asExit(west)
;

+ teWestDoor: Door 'v+ästra dörr+en/dörr|öppning+en' 'västra dörr'
    "Dörren leder ut västerut. "
;

class ObstacleItem: CustomImmovable
    cannotTakeMsg = 'Banan ser noggrant utlagd ut; du borde inte 
                    förstöra den. '

    iobjFor(PutIn)
    {
        verify() { }
        check()
        {
            if (gDobj == toyCar)
                "Det skulle vara kul att köra runt med bilen på banan,
                men du borde förmodligen låta bli; det skulle 
                vara alldeles för lätt att knuffa någon del ur position. ";
            else
                "<<cannotTakeMsg>>";
            exit;
        }
    }
    iobjFor(PutOn) asIobjFor(PutIn)
;

+ ObstacleItem 'hinder|bana+n' 'hinderbana'
    "Hinderbanan fyller större delen av rummet. Allt är
    i miniatyr, ungefär i rätt skala för chihuahuas. "

;
+ ObstacleItem 'små orange trafik|koner+na' 'trafikkoner'
    "Konerna är miniatyrversioner av vad du skulle se på motorvägen,
    ungefär 30 centimeter höga. "
    isPlural = true
;
+ ObstacleItem 'trä|ramper+na' 'träramper'
    "Det finns ett antal ramper, några som bara vänder nedåt igen vid
    toppen, några med korta platåer, andra som svänger i en kurva
    på toppen. "
    isPlural = true
;
+ ObstacleItem
    'plåt+bitar+na halv+a halv|cylinder+n/cylinder+n*halv|cylindrar+na tunnlar+na'
    'tunnlar'
    "Det finns ett par tunnlar gjorda av plåtbitar
    böjda till halvcylindrar. "
    isPlural = true
;

/* a property for Rooms indicating that the car can't travel here */
property blockToyCar;

+ toyCar: Thing, Traveler
    'radiostyrda rc miniatyr+en skal|modell+en leksaksbil+en/skalmodell|bil+en/leksak+en*leksaker+na' 'leksaksbil'

    desc()
    {
        if (ratPuppet.isIn(self))
            "Leksaksbilen är för närvarande förklädd som en råtta---en plyschråtta
            docka har placerats över bilen, med endast hjulen
            utstickandes från undersidan. ";
        else
            "Det är en skalmodellbil ungefär 15 centimeter lång. Den är
            radiostyrd: en lång trådantenn sticker upp från
            baksidan. ";
    }

    /* when we appear in contents lists, mention when we're in disguise */
    listName = (ratPuppet.isIn(self)
                ? 'en leksaksbil (förklädd som en råtta)' : 'en leksaksbil')

    /* 
     *   Do not list my contents in listings involving me, even for direct
     *   examination.  The only thing I can contain is the plush rat, and
     *   we don't contain that in the usual way - it's more like wearing
     *   the puppet.  
     */
    contentsListedInExamine = nil

    useInitSpecialDesc = (inherited && !ratPuppet.isIn(self))
    initSpecialDesc = "En liten leksaksbil ligger på golvet i ett hörn
        av hinderbanan; någon måste ha kört den
        runt banan för skojs skull.
        <<toyCarControl.location == location
          ? 'Bredvid den finns en liten låda som måste vara dess fjärrkontroll. '
          : ''>> "

    /* on the first move, add an extra ethics message */
    moveInto(obj)
    {
        /* if this is the first purloining, rationalize it */
        if (!moved)
            extraReport('Det verkar som om bilen bara har stått här
                ett tag, så du tänker att det förmodligen är okej att låna
                den för dagen.<.p>');

        /* do the normal work */
        inherited(obj);
    }

    iobjFor(PutOn)
    {
        verify() { logicalRank(50, 'leksaksbil yta'); }
        check()
        {
            if (gDobj != ratPuppet)
            {
                "Det finns inget sätt att balansera {ref dobj/honom} på leksaksbilen. ";
                exit;
            }
        }
        action()
        {
            "Plyschråttans handöppning passar fint över
            leksaksbilen, med hjulen stickande ut precis tillräckligt
            för att låta den köra runt. ";

            gDobj.moveInto(self);
        }
    }

    dobjFor(ThrowAt)
    {
        check()
        {
            "Det skulle förmodligen skada leksaksbilen. ";
            exit;
        }
    }

    /* determine if the car is capable of moving while in a given room */
    canTravelIn(room)
    {
        /* 
         *   we can travel in any indoor room except those that
         *   specifically don't allow it 
         */
        return (!room.ofKind(OutdoorRoom) && !room.blockToyCar);
    }

    /* I can be followed */
    verifyFollowable() { return true; }

    /* carry out a joystick control input */
    joystickCommand(actor, action)
    {
        local dir;
        local room;
        local vis, aud;
        local visMsg, audMsg, extraMsg;
        local didMove = nil;
        local didLocalMove = nil;
        local plisnikSaw = plisnik.canSee(self);

        /* 
         *   only allow directional PushTravel's, and only in the compass
         *   directions 
         */
        if (action.baseActionClass != PushTravelDirAction
            || !(dir = action.getDirection()).ofKind(CompassDirection))
        {
            "(Joysticken kan röras i vilken kompassriktning som helst:
             RÖR JOYSTICK NORRUT, till exempel.) ";
            return;
        }
        
        /* get the actor's outermost room */
        room = actor.location.getOutermostRoom();

        /* note whether or not the car is visible/audible */
        vis = actor.canSee(self);
        aud = actor.canHear(self);
        
        /* by default, we notice nothing going on with the car */
        visMsg = '';
        audMsg = '';

        /* check to see where the car is */
        if (isDirectlyIn(room))
        {
            /* if we can't travel while in this room, just sit and spin */
            if (!canTravelIn(room))
            {
                visMsg = '. Leksaksbilen varvar sin motor men 
                        verkar inte kunna röra sig på den här ytan';
                audMsg = '. Du hör leksaksbilens motor varva';
            }
            else
            {
                local conn;
                local dest;
                
                /* 
                 *   most of the audible-only messages are the same, so
                 *   set a default 
                 */
                audMsg = '. Du hör hur bilen kör omkring i närheten';
                
                /* 
                 *   The car is directly in the same room as the actor, and
                 *   travel is allowed here.  Find the exit in the
                 *   direction we're going, and check for compatibility.  
                 */
                conn = room.getTravelConnector(dir, nil);
                if (conn == nil)
                {
                    /* no connector; we just zip around the floor */
                    visMsg = ', och leksaksbilen susar en kort 
                        sträcka ' + dir.name; 

                    /* we moved around within the room */
                    didLocalMove = true;
                }
                else
                {
                    /* get the destination */
                    dest = conn.getDestination(location, self);
                    
                    /*
                     *   Check to see if we can travel.  If the connector
                     *   isn't passable, we can't.  If the connector is a
                     *   stairway up, we can't.  Otherwise, allow it.  
                     */
                    if (!conn.isConnectorPassable(location, self)
                        || conn.ofKind(StairwayUp))
                    {
                        /* the connector blocks us */
                        if (conn.name not in (nil, ''))
                        {
                            visMsg = '. Leksaksbilen susar över till '
                                + conn.theName + ' och stannar';
                        }
                        else
                        {
                            visMsg = '. Leksaksbilen susar fram en bit mot '
                                + dir.name + ' och stannar';
                        }

                        /* we moved around within the room */
                        didLocalMove = true;
                    }
                    else
                    {
                        /* the toy car departs via the connector */
                        visMsg = '. Leksaksbilen susar ut ur rummet
                            till ' + dir.name;
                        audMsg = '. Du hör bilen köra iväg';

                        /* if it's a stairway down, mention that */
                        if (conn.ofKind(StairwayDown)
                            && conn.name != nil)
                        {
                            visMsg += ' och trillar ner '
                                + conn.theName;
                        }
                        
                        /* track the follow */
                        me.trackFollowInfo(self, conn, room);

                        /* 
                         *   Move the car to its new location.  Note that
                         *   we don't have to worry about it entering the
                         *   player character's location, since it can't
                         *   operate unless it started in the PC's location
                         *   and thus can only be leaving.  
                         */
                        moveIntoForTravel(dest);

                        /* note that we did move the car */
                        didMove = true;
                    }
                }
            }
        }
        else if (isIn(room))
        {
            /* 
             *   We're in the same room, but only indirectly.  If we're on
             *   a surface, fall off.  If we're in a container, just move
             *   aimlessly.  If we're in an actor, rev the wheels.  
             */
            if (location.ofKind(Surface))
            {
                /* it falls off */
                visMsg = '. Leksaksbilen susar iväg till ' + dir.name + ' och
                    faller av ' + location.theName;
                audMsg = '. Du hör leksaksbilen köra omkring,
                    sen hör du något ramla';
                
                /* move it to the surface's container's drop destination */
                moveInto(location.getDropDestination(self, nil));

                /* we moved around within the room */
                didLocalMove = true;
            }
            else if (location.ofKind(Actor))
            {
                /* just spin our wheels */
                visMsg = ', och leksaksbilens hjul snurrar lite';
                audMsg = '. Du hör leksaksbilens motor varva';
            }
            else
            {
                /* just move aimlessly */
                visMsg = '. Leksaksbilen rör sig omkring lite';
                /* we moved around within the room */
                didLocalMove = true;
            }
        }
        else
        {
            /* 
             *   The car isn't in the same room as the actor, so it's out
             *   of range of the remote control.  Just use the default
             *   empty messages, since there's nothing to report with the
             *   car.  The first time this happens, though, if we've seen
             *   the car move previously, add a mention that it seems to
             *   be out of range.  
             */
            if (seenMove && ++outOfRangeNote == 1)
                extraMsg = '. Det verkar inte hända någonting; Leksaksbilen
                              måste vara utanför fjärrkontrollens räckvidd';
        }
        
        /* 
         *   Acknowlege that we moved the joystick, and show the result.
         *   If we can see the car, show the visual message; if we can't
         *   see it but can hear it, show the aural message; otherwise
         *   don't even mention the car.  
         */
        "Du rör joysticken åt <<dir.name>><<
          vis ? visMsg : aud ? audMsg : ''>><<extraMsg>>. ";

        /* 
         *   if we just saw any kind of reaction, note that we know that
         *   the remote controls the car now 
         */
        if ((vis && visMsg != '') || (aud && audMsg != ''))
            seenMove = true;

        /* if we're dressed up as a rat, check to see if plisnik notices */
        if (ratPuppet.isIn(self))
        {
            local plisnikSees = plisnik.canSee(self);

            /* if we moved it away from plisnik, notify him */
            if (didMove && plisnikSaw)
                plisnik.ratLeaving();

            /* if we just did a local move, and plisnik saw, notify him */
            if (didLocalMove && plisnikSees)
                plisnik.ratMoving();

            /* if we're arriving at plisnik's location, he freaks out */
            if (didMove && plisnikSees)
                plisnik.eekARat();
        }
    }

    /* flag: we've seen the car move around under joystick control */
    seenMove = nil

    /* number of times we've noted that the car might be out of range */
    outOfRangeNote = 0
;
++ Component 'fin+a styv+a lång+a öglad+e tråd+en (leksak^s+bil) bilens antenn+en/ögla+n'
    'antenn'
    "Det är en bit fin, styv tråd ungefär tio centimeter lång, böjd
    till en liten ögla i toppen. "
    disambigName = 'leksaksbilens antenn'
;

+ toyCarControl: Thing 'li:ten+lla rf fjärr+kontroll+en' 'fjärrkontroll'
    "Det är en liten låda med en antenn och en joystick. "

    isListed = (toyCar.isListed || location != toyCar.location)

    filterResolveList(lst, action, whichObj, np, requiredNum)
    {
        /* 
         *   if the phrase was just "box", and there's anything else that
         *   can match, take the other thing 
         */
        if (np.getOrigText() == 'låda' && lst.length() > 1)
            lst = lst.subset({x: x.obj_ != self});

        /* return the result */
        return lst;
    }
;
++ Component 'tråd (fjärr+ens) (kontroll+ens) antenn+en' 'antenn'
    "Det är en bit tråd som sticker ut från fjärrkontrollådan. "
    disambigName = 'fjärrkontrollens antenn'
;
++ Component '(fjärr+ens) (kontroll+ens) joystick+en/kontrollspak+en/fjärr+kontroll+en' 'fjärrkontrollens joystick'
    "Det är en kort kontrollspak som du kan flytta i alla
    kompassriktningar. "

    dobjFor(Move)
    {
        verify() { }
        action() { "(Joysticken kan flyttas i alla kompassriktningar:
            FLYTTA JOYSTICK NORR, till exempel.) "; }
    }
    dobjFor(Push) asDobjFor(Move)
    dobjFor(Pull) asDobjFor(Move)

    dobjFor(PushTravel)
    {
        preCond = [mainObjHeld]
        verify() { }
        action() { toyCar.joystickCommand(gActor, gAction); }
    }
;

/* 
 *   ------------------------------------------------------------------------
 */
/*
 *   Lauritsen-Downs Courtyard 
 */
ldCourtyard: CampusOutdoorRoom 'Lauritsen-Downs Innergård'
    'Lauritsen-Downs innergård' 'innergård'
    "Detta är en liten innergård omgiven av laboratoriebyggnader:
    Guggenheim i norr, Firestone i öster, och 
    Lauritsen-Downs i söder och väster. En gångväg leder norrut
    under en bro på andra våningen som förbinder Firestone och Guggenheim.
    Ingången till Lauritsen-Downs är söderut; de
    andra byggnaderna är bara tomma väggar här, förutom en dörr
    märkt <q>Nödutgång</q> i det nordvästra hörnet av
    Guggenheim. "

    vocabWords = '(lauritsen-downs) innergård+en'

    north = ldcNorthWalk
    northwest = ldEmergencyDoor

    south: FakeConnector { "Lauritsen-Downs är mestadels kontor och
        klassrum; med tanke på att det är Skolkdagen, pågår det förmodligen inte
        mycket här idag. "; }

    /* we have some walls despite being an outdoor location */
    roomParts = static (inherited + [defaultNorthWall, defaultSouthWall,
                                     defaultEastWall, defaultWestWall])
;

+ CampusMapEntry 'downs lab/labb+et/laboratorium+et' 'Downs Laboratorium' 'sydväst';
+ CampusMapEntry 'lauritsen lab/labb+et/laboratorium+et' 'Lauritsen Laboratorium' 'söder';
+ CampusMapEntry 'lauritsen-downs lab/labb+et/laboratorium+et/innergård+en'
    'Lauritsen-Downs innergård' 'söder';

+ ldcNorthWalk: PathPassage 'norra n gångväg+en' 'norra gångvägen'
    "Gångvägen leder norrut under bron på andra våningen. "
;

+ ldEmergencyDoor: Door
    '"nödutgång+en" nödutgång^s+dörr+en' 'nödutgångsdörr'
    "Dörren är märkt <q>Nödutgång.</q> Den ser ut som en envägs
    dörr som leder ut; det finns inget uppenbart sätt att öppna den från denna sida. "

    initiallyOpen = nil

    dobjFor(Open)
    {
        check()
        {
            "Dörren har inget dörrhandtag på denna sida; det verkar som
            att det bara är möjligt att öppna den från andra sidan. ";
            exit;
        }
    }
;

+ Enterable ->(location.south)
    'beige stor+a lauritsen downs lauritsen-downs
    glas+et/fönst:er+ret/stucko/lab+bet/laboratorium+et/byggnad+en'
    'Lauritsen-Downs'
    "Lauritsen och Downs är nominellt separata byggnader, men
    de är sammanfogade till en enda L-formad struktur. Den kombinerade
    byggnaden ser modern ut: beige stucko, räta vinklar, stora
    rektangulära fönster. De flesta av Institutets högenergi-
    fysiker har sina kontor i dessa byggnader. En ingång
    finns söderut. "

    isProperName = true
;

+ Fixture 'tom+ma baksida+n guggenheim lab+bet/laboratorium+et/vägg+en/sida+n' 'Guggenheim'
    "Baksidan av Guggenheim vetter mot innergården. Bortsett från
    nödutgångsdörren är det bara en tom vägg. "

    isProperName = true
;

+ Fixture 'tom+na baksida+n firestone lab+bet/laboratorium+et/vägg+en/sida+n' 'Firestone'
    "Baksidan av Firestone vetter mot innergården; det är bara en tom
    vägg på denna sida. "

    isProperName = true
;

+ Distant 'andra-vånings våning andravånings|bro+n' 'andra-våningsbro'
    "Bron förbinder Firestone och Guggenheim på andra våningen.
    En gångväg leder norrut under bron. "
;


/*
 *   Ernst, elektrikern.  
 */
+ ernst: IntroPerson
    'lång+a rund+a rödlätt+a lockig:t+a hår+et/elektriker+n/ernst/man+nen*män+nen'
    'lång, rund man'
    "Han är en lång, rund, rödlätt man med lockigt hår, klädd i jeans-
    hängselbyxor med en broderad namnskylt som lyder <q>Ernst.</q> Du
    antar att han är en elektriker, baserat på verktygen som hänger från hans
    bälte---voltmetrar, kabelpresstänger, avbitartänger.
    <<setIntroduced()>> "

    properName = 'Ernst'
    isHim = true

    /* presume we're known, since we're mentioned in a memo */
    isKnown = true

    /* if gunther arrives while we're here, start the fight */
    afterTravel(traveler, connector)
    {
        inherited(traveler, connector);
        if (traveler.isActorTraveling(gunther))
            startFight();
    }

    /* start the fight */
    startFight()
    {
        /* get gunther out of the cherry picker */
        gunther.moveIntoForTravel(cherryPicker.location);

        /* 
         *   the only way we can meet is when the PC just sent Gunther to
         *   a new job, so the PC is always one room away; note the start
         *   of the fight 
         */
        callWithSenseContext(nil, nil, new function() {
            "<.p>Du hör ett oväsen från någonstans i närheten. ";
        });

        /* activate the nearby fight sounds */
        guntherErnstNearbyFightNoise.makePresent();

        /* set them both in the fighting states */
        setCurState(ernstFightingState);
        gunther.setCurState(guntherFightingState);
    }
;
++ InitiallyWorn 'jeans hängselbyxor+na' 'jeans hängselbyxor'
    "En broderad namnskylt på hängselbyxorna lyder <q>Ernst.</q> "
    isPlural = true
    isListedInInventory = nil
;
+++ Component, Readable 'broderad+e namnskylt+en' 'namnskylt'
    "Den lyder <q>Ernst</q> i broderade kursiva bokstäver. "
;
++ Thing
    'verktyg+et (elektrikers) (kabel) verktyg+et
    avbitare+n/bälte+t/verktygsbälte+t/verktyg+et*voltmetrar+na kabelpresstänger+na'
    'elektrikers verktyg'
    "Verktygen ser ut som sådant en elektriker skulle bära:
    voltmetrar, kabelpresstänger, avbitare, den sortens saker. "
    isPlural = true
    isListedInInventory = nil
;


++ DefaultAnyTopic, ShuffledEventList
    ['<q><i>Guten Tag,</i></q> säger han. Tyvärr talar du inte
    mycket tyska. Han återgår till sitt arbete. ',
     '<q><i>Ich verstehe die Sprache nicht,</i></q> säger han. Du
     känner igen det som tyska, men du kan inte tillräckligt med tyska för att
     fortsätta en konversation med honom. Han återgår till sitt arbete. ',

     '<q><i>Bitte?</i></q> säger han.  Han tittar frågande på dig 
     en stund, rycker sedan på axlarna och återgår till arbetet. ',
     'Han bara ler och nickar. <q><i>Guten Tag,</i></q> säger han till
     slut, och återgår sedan till sitt arbete. ']
;

++ AskTellTopic, StopEventList @gunther
    ['Han avbryter dig innan du hinner avsluta. <q>Gunther?</q> säger han,
    och ser sig omkring, sedan tittar han tillbaka på dig. Han säger något
    långt på snabb tyska, pekar med fingret i luften för att
    betona vartannat ord, sedan stannar han och står där och ser
    indignerad ut. Han grymtar och går tillbaka till det han höll på med,
    fortfarande lite upprörd. ',
    'Han snurrar runt för att möta dig, säger något argt på tyska, och
    går sedan tillbaka till sitt arbete. ']
;

class ErnstJobCardTopic: GiveShowTopic
    topicResponse()
    {
        "<q>Ursäkta mig,</q> säger du och håller fram kortet.
        <.p>Han läser igenom det och säger något på tyska, sedan lämnar han
        tillbaka kortet till dig. ";

        /* check to see if we're already there */
        if (ernst.isIn(destLoc))
        {
            "Han återgår till det han höll på med. ";
            return;
        }

        "Han slutar med det han höll på med och börjar packa ihop saker och 
        omorganisera saker på sitt verktygsbälte. ";

        /* switch to the preparing-to-go state for a brief delay */
        ernst.setCurState(ernstPreparingState);
        ernstPreparingState.delayCount = 2;

        /* remember our destination */
        ernstInTransitState.destPath = destPath;
        ernstInTransitState.destState = destState;
    }

    /* the path to our destination */
    destPath = []

    /* the destination is the last path element */
    destLoc = (destPath[destPath.length()])

    /* the state to go into when we reach the destination */
    destState = nil
;
++ ErnstJobCardTopic @lauritsenJobCard
    destPath = [orangeWalk, quad, westOliveWalk, ldCourtyard]
    destState = ernstLauritsenState
;
++ ErnstJobCardTopic @orwalkJobCard
    destPath = [ldCourtyard, westOliveWalk, quad, orangeWalk]
    destState = ernstOrangeState
;
++ ErnstJobCardTopic [oakJobCard, oliveJobCard]
    "<q>Ursäkta mig,</q> säger du och håller fram kortet.
    <.p>Han läser igenom det och säger något på tyska, sedan lämnar han
    tillbaka kortet till dig och återgår till sitt arbete. "
;

/* our initial state: checking around Thomas */
++ ernstLauritsenState: ActorState
    isInitState = true
    stateDesc = "Han går långsamt nära Lauritsen och tittar noga på
        byggnaden. "
    specialDesc = "\^<<location.aName>> går långsamt längs
        utsidan av Lauritsen och tittar noga på byggnaden. "

    /* show a message when we arrive and start doing this state */
    introDesc = "\^<<location.theName>> börjar gå långsamt längs
        utsidan av Lauritsen och inspekterar byggnaden. "
;

/* our state on the orange walk: fixing a light fixture */
++ ernstOrangeState: ActorState
    stateDesc = "Han arbetar med en belysningsarmatur längs
        gångvägen. "
    specialDesc = "\^<<location.aName>> står längs
        gångvägen och arbetar med en belysningsarmatur. "

    /* show a message when we arrive and start doing this state */
    introDesc = "\^<<location.theName>> går fram till en belysningsarmatur
        längs gångvägen och börjar ta isär den. "
;

/* preparing to leave on our way to a new job */
++ ernstPreparingState: ActorState
    stateDesc = "Han omorganiserar saker på sitt verktygsbälte. "
    specialDesc = "\^<<location.aName>> står här och omorganiserar
        saker på sitt verktygsbälte. "

    takeTurn()
    {
        /* if we're done fussing, commence travel to our new job */
        if (delayCount-- == 0)
        {
            /* switch to our travel state */
            ernst.setCurState(ernstInTransitState);

            /* move to the first point on the path */
            ernst.scriptedTravelTo(ernstInTransitState.destPath[1]);
        }
    }

    /* the number of turns remaining before we start traveling */
    delayCount = 2
;
+++ DefaultAnyTopic
    "Han verkar för upptagen med sina verktyg för att märka att du försöker
    prata med honom. "
;

/* our state while in transit through the quad */
++ ernstInTransitState: ActorState
    stateDesc = "Han går förbi, på väg någonstans. "
    specialDesc = "\^<<location.aName>> går igenom, på väg
        någonstans. "

    takeTurn()
    {
        /* get our current position on the path, and figure out next */
        local idx = destPath.indexOf(ernst.location.getOutermostRoom()) + 1;

        /* move to our next location */
        ernst.scriptedTravelTo(destPath[idx]);

        /* if we're in our destination, go to work */
        if (idx == destPath.length())
        {
            /* switch to our new state */
            ernst.setCurState(destState);

            /* give our new state's intro message */
            "<.p>";
            destState.introDesc;
        }
    }

    /* our destination path and state */
    destPath = nil
    destState = nil
;
+++ DefaultAnyTopic
    "Han ler bara och fortsätter gå. "
;

/* our state while fighting */
++ ernstFightingState: ActorState
    stateDesc = "Han springer från trädgårdsmästaren, som jagar honom
        med en grensax. "

    /* gunther provides the special description for the both of us */
    specialDesc = ""

    /* when the PC arrives, take our fight off-stage */
    afterTravel(traveler, connector)
    {
        if (traveler.isActorTraveling(me))
        {
            "<.p>\^<<ernst.theName>> slutar abrupt springa från
            <<gunther.theName>> och vänder sig om, håller fram en
            avbitartång. Han skriker något på tyska och börjar
            jaga trädgårdsmästaren. De två springer iväg norrut. ";

            trackAndDisappear(ernst, ernst.location.north);
            trackAndDisappear(gunther, gunther.location.north);

            /* this is worth some points */
            scoreMarker.awardPointsOnce();

            /* get rid of the commotion noises */
            guntherErnstNearbyFightNoise.moveInto(nil);
        }
    }

    scoreMarker: Achievement { +5 "ta kontroll över skyliften" }
;
+++ DefaultAnyTopic
    "Han verkar vara upptagen för tillfället. "
;

/*
 *   A multi-instance noise object that shows up in each location adjacent
 *   to the fight. 
 */
guntherErnstNearbyFightNoise: PresentLater, MultiInstance
    locationList = [sanPasqualWalkway, orangeWalk, westOliveWalk, oliveWalk]
    instanceObject: SimpleNoise {
        desc = "Du hör ett oväsen från någonstans i närheten. Det låter
            som om någon skriker på tyska. "
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   A class for our various water features.
 */
class Pond: object
    dobjFor(Drink)
    {
        preCond = []
        verify() { }
        action() { "Det är förmodligen inte en bra idé att dricka vatten
            från en damm. "; }
    }
    dobjFor(Eat) asDobjFor(Drink)

    dobjFor(Enter)
    {
        verify() { logicalRank(50, 'enter pond'); }
        action() { "Du har inget intresse av att bli helt blöt just nu. "; }
    }
    dobjFor(Board) asDobjFor(Enter)
    dobjFor(StandOn) asDobjFor(Enter)
    dobjFor(SitOn) asDobjFor(Enter)
    dobjFor(LieOn) asDobjFor(Enter)
;

/* ------------------------------------------------------------------------ */
/*
 *   Pond/rock garden 
 */
rockGarden: CampusOutdoorRoom 'Stenträdgård' 'stenträdgården'
    "Gångvägen slingrar sig genom en stenträdgård inbäddad i en
    terrasserad serie av dammar. Stigen stiger uppför sluttningen mot
    väster och leder till Olive Walk i öster. På avstånd
    västerut kan du se hur Millikan-biblioteket tornar upp sig. "

    east = rgEastWalk
    down asExit(east)
    west = rgWestWalk
    up asExit(west)
;

+ Decoration 'gång|väg+en/gång|stig+en' 'gångväg'
    "Gångvägen leder uppför backen mot väster och till Olive Walk
    i öster. "
;

+ rgEastWalk: PathPassage ->wowWestWalk 'olive walk' 'Olive Walk'
    "Olive Walk ligger österut. "
;

+ rgWestWalk: PathPassage ->mpEastWalk 'gång|stig+en/gång|väg+en' 'stig'
    "Stigen slingrar sig uppför sluttningen västerut. "

    canTravelerPass(trav) { return trav != cherryPicker; }
    explainTravelBarrier(trav) { "skyliften kommer inte att få plats på
        den smala stigen. "; }
;

+ Decoration 'kulle+n/sluttning+en' 'sluttning'
    "Stigen slingrar sig uppför de cirka tre meterna av sluttningen
    västerut. "
;

+ Decoration 'sten|trädgård+en/sten+en/klippa+n*stenblock+en stenar+na klippor+na' 'stenar'
    "Stenarna varierar i storlek från basebollstora till stenblock. De är
    arrangerade utan något särskilt mönster bland en slingrande serie
    av dammar och frodig vegetation. "
    isPlural = true
    owner = (self)
;


+ Pond, Decoration
    'små miniatyr terrasserade vatt:en+net/serie+n/pool+en/vattenfall+et/damm+en*dammar+na pooler+na'
    'dammar'
    "Små pooler är terrasserade i sluttningen, där de högre sakta
    rinner över i miniatyrvattenfall ner i de lägre.
    Näckrosor flyter på ytan, och tät växtlighet omger
    varje pool. Stenträdgårdens stenar och stenblock är utplacerade
    överallt. "
    isPlural = true

    dobjFor(Enter) { action() { "Det skulle bara störa den noggrant
        arrangerade stenformationen, och dessutom har du ingen lust
        att bli helt blöt. "; } }

    lookInDesc = "Du ser inga förlorade skatter i vattnet; bara
        stenar och näckrosor. "

    iobjFor(PutIn)
    {
        verify() { }
        action() { "Bäst att låta bli; du skulle göra {det dobj/subj} helt blöt. "; }
    }
;

++ Decoration 'näckros+en/näckrosor+na' 'näckrosor'
    "Näckrosorna guppar på vattnets krusiga yta. "
    isPlural = true
;

+ Decoration 'frodig+a tät+a vegetation+en/växt+en/grönska+n*växter+na' 'vegetation'
    "Växter är arrangerade runt dammarna och stenarna och bildar en
    grön bakgrund till stenträdgården. "
    isMassNoun = true
;

+ Distant 'svart+a niovånings millikan bibliotek+et/monolit+en' 'Millikan-biblioteket'
    "Härifrån kan du se ungefär den övre halvan av den nio våningar höga
    svarta monoliten. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Millikan pond 
 */
millikanPond: CampusOutdoorRoom 'Millikan-dammen' 'Millikan-dammen'
    'dammgångväg'
    "Det niovåningar höga obsidiantornet som är Millikan-biblioteket ligger
    västerut och reser sig över den breda rektangulära dammen som fyller
    det stora öppna området norr om gångvägen. En kombination av abstrakt
    skulptur och fontän i mitten av dammen skjuter flera
    vattenstrålar upp i luften.
    <.p>Bridge Lab ligger en kort bit söderut, och ingången
    till biblioteket är västerut. En stig leder österut, ner för en kulle. "

    vocabWords = 'damm+en damm|gångväg+en'

    west = millikanLobby
    east = rockGarden
    down asExit(east)
    south = bridgeEntry
;

+ CampusMapEntry 'öst+ra ö bridge lab labb+et/laboratorium+et/bridge'
    'Bridge Laboratorium' 'sydväst'

    /* 
     *   since we mention this specifically as a destination the player
     *   should seek, elevate its match strength in case of ambiguity
     *   (which can happen if we look up simply "lab") 
     */
    mapMatchStrength = 200
;

+ CampusMapEntry 'millikan millikan|bibliotek+et/millikan-bibliotek+et' 'Millikan-biblioteket' 'sydväst'
    /* elevate the match strength in case we look up just "library" */
    mapMatchStrength = 200
;

+ mpEastWalk: PathPassage 'stig+en/kulle+n/sluttning+en' 'stig'
    "Stigen leder ner för en kulle österut. "
;

+ Enterable ->(location.west)
    'millikan niovånings obsidian svart+a bibliotek+et/torn+et/monolit+en'
    'Millikan-biblioteket'
    "Bibliotekets svarta, fönsterlösa fasad reser sig från
    dammens västra ände till en höjd av nio våningar och tornar
    över allt annat i närheten. Ingången är västerut. "
;

+ EntryPortal ->(location.south)
    'norman bridge lab+bet/laboratorium+et/arkad+en/ingång+en' 'Bridge Lab'
    "Norman Bridge Laboratory of Physics är där de undervisar
    i fysik 1, som praktiskt taget varje förstaårsstudent måste ta. Ingången
    är söderut, genom en välvd gång. "

    isProperName = true
;

+ EntryPortal ->(location.south)
    'välvd+a (bridge) gång+en/arkad+en' 'välvd gång'
    "Arkaden löper längs hela denna sida av Bridge. "
;

+ Pond, Fixture '(millikan) bred+a rektangulär+a grund+a damm+en/pool+en/vatten/vattnet' 'damm'
    "Dammen är ganska grund, högst en meter djup.
    En fontän i mitten skjuter vatten upp i luften. "

    lookInDesc = "Du ser inget intressant under vattenytan i dammen. "

    iobjFor(PutIn)
    {
        verify() { }
        action() { "Bäst att låta bli; du skulle göra {det dobj/subj} helt blöt. "; }
    }
;

+ Distant
    'slingrande böjd+a abstrakt+a (vatten)
    skulptur+en/fontän+en/form+en/stråle+n/(vatten)*former+na strålar+na (vatten)'
    'fontän'
    "Fontänen är en skulptur av slingrande, böjda former. Flera
    vattenstrålar skjuter upp ur fontänen och bågar iväg i
    olika riktningar. "
;
