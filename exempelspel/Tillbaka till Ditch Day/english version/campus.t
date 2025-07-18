/*
 *   Copyright 2003, 2013 Michael J. Roberts
 *   
 *   Return to Ditch Day - campus section.  This contains most of the
 *   campus outdoor locations, and the smaller campus building interiors.  
 */

#include <adv3.h>
#include <en_us.h>
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
    "\b\b\b\b<i>Three weeks later...</i>
    \b\b
    \bThe airport shuttle drops you off at the end of San Pasqual
    St., at the east edge of the Caltech campus, and drives off.
    
    <.p>You'd forgotten how incredibly heinous LA traffic can be.
    The 105 was solid tail-lights all the way from LAX to downtown,
    and the 110 was a parking lot most of the way up to Pas.  You had
    thought you might poke around campus a little before your
    appointment, but that's out of the question now; better get
    straight to the Career Center Office.  Speaking of which, it
    seems like they move the Career Center to a new building every
    time you're down here; this time it's in the Student Services
    building, a short distance up Holliston.<.p> ";
    
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

ddTopic: Topic 'ditch day';
nicTopic: Topic 'network installer company/nic/n.i.c.';
stackTopic: Topic 'ditch day stack/stacks';
stamerStackTopic: Topic '(brian) (brian\'s) (stamer\'s) ditch day stack';
paulStackTopic: Topic '(paul) (paul\'s) ditch day stack/password'; 
caltechTopic: Topic '(cal) caltech/tech';
stamerLabTopic: Topic
    '(brian) (brian\'s) (stamer\'s) 022 lab/laboratory/bridge';
stamerTopic: Topic 'brian stamer';
ratTopic: Topic 'rat/rats';
plisnikTopic: Topic 'plisnik';
scottTopic: Topic 'scott';
jayTopic: Topic 'jay santoshnimoorthy';
turboTopic: Topic 'turbo power animals';
windTunnelTopic: Topic 'guggenheim wind hypervelocity shock tunnel';
guggenheimTopic: Topic 'guggenheim';
galvaniTopic: Topic 'project 2 galvani/galvani-2';
explosionTopic: Topic 'explosion';
jobNumberTopic: Topic 'job number';
ipAddressesTopic: Topic 'ip address/addresses';

jobTopic: Topic 'my your job';
bossTopic: Topic 'my your vice boss/vp/president/v.p.';
productsTopic: Topic
    'omegatron omegatron\'s company\'s my your product/products';
bureaucracyTopic: Topic
    'omegatron omegatron\'s company\'s bureaucracy';
otherJobOffersTopic: Topic 'other job offer/offers';
startupsTopic: Topic 'start-up startup company/companies/start-ups/startups';

supplyRoomTopic: Topic 'supply supplies room keypad room/door/lock';

eeTextbookRecTopic: Topic
    '(ee) (electrical) (engineering) book books textbooks (recommendations)';
eeLabRecTopic: Topic
    '(ee) (electrical) (engineering) lab laboratory manual (recommendations)';

physicsTextTopic: Topic
    'quantum physics text book/books/text/texts/textbook/textbooks';
eeTextTopic: Topic
    'ee electrical engineering text book/books/text/texts/textbook/textbooks';
labManualTopic: Topic 'ee electrical engineering lab manual';
drdTopic: Topic
    'drd math mathematics mathematical functions/table/tables/handbook/book'
;

quantumComputingTopic: Topic 'quantum computing/computer/computers';
qubitsTopic: Topic 'qubits programming language/qubit/qubits';

videoAmpTopic: Topic 'video amp/amps/amplifiers';
waveformTopic: Topic 'waveforms';
the1a80Topic: Topic '1a80 cpu';
hovarthTopic: Topic 'hovarth number/numbers/function/functions';
programmingHovarthTopic: Topic
    'programming (hovarth) (numbers)/(number)/(function)/(functions)';

lostQuarterTopic: Topic 'lost quarter';

lunchTopic: Topic 'lunch';

bloemnerTopic: Topic
    'by blomner bloemner bl\u00F6mner blomner\'s bloemner\'s bl\u00F6mner\'s
    introductory quantum physics
    text book/books/text/texts/textbook/textbooks';
sAndP3Topic: Topic
    'science&progress s&p science & progress magazine
    issue number xlvi-3';
sAndPTopic: Topic
    'science&progress s&p science & progress magazine issue number -';
qrlTopic: Topic
    'quantum review letters qrl number issue volume journal/letters/qrl';
qrlVolumeTopic: Topic
    'quantum review letters qrl number issue 70 73 volume
    journal/letters/qrl';
qrl7011cTopic: Topic 'quantum review letters qrl number issue 70:11c';
qrl739aTopic: Topic 'quantum review letters qrl number issue 73:9a';
morgenTopic: Topic
    'yves morgen electronics lectures text
    book/books/text/texts/textbook/textbooks';
townsendTopic: Topic 'e.j. townsend lab laboratory manual';

efficiencyStudy37Topic: Topic '37 efficiency study';

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

myKeyring: Keyring 'key keyring/ring' 'keyring'
    "It's just a simple metal ring you use to hold your keys. "

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

+ DitchKey 'house key/(house)*keys' 'house key'
    "It's the key to your house. "
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
    'brown leather wallet' 'wallet'
    "It's a simple brown leather wallet. "
    owner = me

    /* putting the wallet in my pocket requires the wallet to be closed */
    dobjFor(PutIn) { preCond = ([walletClosedInPocket] + inherited) }

    /* opening the wallet requires holding it */
    dobjFor(Open) { preCond = (inherited + objHeld) }

    /* start closed */
    initiallyOpen = nil

    /* restrict our contents to walletable items */
    canPutIn(obj) { return obj.okayForWallet; }
    cannotPutInMsg(obj) { return 'You don\'t like to stuff your wallet
        with miscellaneous junk. '; }

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

+ alumniID: WalletItem 'alumni id identification card' 'alumni ID card'
    "This card identifies you as a Caltech alum. "
    owner = me
;

+ cxCard: WalletItem 'corporate consumer express credit cumex card'
    'Consumer Express card'
    "Omegatron chose Consumer Express as the corporate credit card
    because it was the cheapest, no doubt, ignoring the inconvenient
    practical matter that hardly anyone accepts it. "
    owner = me
;

+ driverLicense: WalletItem
    'california driver\'s driving license/licence/photo/photograph'
    'driver\'s license'
    "This is your California driver's license, complete with eyes-closed
    photo. "
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
toteBag: BagOfHolding, Wearable, ComplexContainer 'tote bag' 'tote bag'
    "You always bring this tote bag when traveling.  It's made of a
    tough, pliable synthetic, and it expands to accommodate almost
    anything. <<
      isWornBy(me)
      ? "The bag is currently slung over your shoulder by its strap. "
      : "A strap lets you wear it over your shoulder. ">> "

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
                "You sling the bag over your shoulder. ";
        }
    }
;
+ Component '(tote) (bag) padded shoulder strap' 'shoulder strap'
    "It's a padded strap that lets you carry the bag over one
    shoulder. "
;

+ Readable 'quick reference career center office information sheet'
    'information sheet'
    "<i>Caltech Career Center Office</i>
    <.p>Thanks for your interest in on-campus recruiting at Caltech.
    This is a quick reference to help ensure your visit is smooth and
    productive.
    <.p>When you arrive on campus, come by the Career Center Office.
    We're in the Student Services building on S.\ Holliston Ave., on
    the first floor&mdash;please refer to the enclosed map of the campus
    if you have any trouble finding us.  When you get here, check in
    with our staff and we'll direct you to your interview location.
    <.p>We're here to ensure that your visit is productive for both
    your company and our students.  If there's anything we can do to
    make your visit more successful, let us know.
    <.p>Sincerely,
    \n<i>the Caltech Career Center Office staff</i> "

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
+ campusMap: Consultable '(caltech) (cal) (tech) campus map' 'campus map'
    "It's a schematic map showing the locations of the campus's main
    buildings.  You know your way around campus from your days here
    as a student, of course, but it's still worth having a
    map in case anything's changed lately.  If you need to
    go somewhere unfamiliar, you can just look it up on the map. "

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
                "You can't find anything on the map by that name. ";
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
                "You really have no reason to go there right now, though,
                and much as you'd like to explore, you remind yourself to
                stay focused on the task at hand. ";

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
                "(The map only shows the locations of buildings, not
                interior floor plans, so you'll have to go outside and
                get your bearings if you want to figure the way there.) ";
                return;
            }

            /* if we're already there, just say so */
            if (dst.location == loc || dst.altLocations.indexOf(loc) != nil)
            {
                "It looks from the map like it should be right here. ";
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
                "To get there from here, you'd go ";
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
                        "then ";

                    /* add the destination name */
                    "to <<cur.getDestName(gActor, prv)>>";

                    /* add appropriate list separation */
                    if (i == len - 1)
                        ", and ";
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
                "You can't tell from the map how to get there from here. ";
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
                "<.p>It looks like you've arrived at <<lastDest.name>>. ";
            }
            else
            {
                /* get the direction name */
                local dir = directionFromTo(lastPath[lastPathIdx],
                                            lastPath[lastPathIdx + 1]);

                /* show how to continue */
                if (dir != nil)
                    "<.p>To continue to <<lastDest.name>>, it looks like
                    you'd go <<dir.name>> from here. ";
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
    desc = "You scan the map and find <<name>> in the <<quadrant>> part
        of the campus. "

    /*
     *   The "quadrant" of the campus containing the building.  This is
     *   used by the default 'desc' to describe roughly where the building
     *   is.  If 'desc' is customized so that it doesn't refer to the
     *   quadrant, this won't be needed.  
     */
    quadrant = 'central'

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
    desc = "The campus map isn't detailed enough to show the interior
        layout of Dabney, but after four years of living there, you
        know where <<name>> is: <<subdesc>>. "

    /* 
     *   all of these are in the game map, even though we don't give
     *   specific directions to them 
     */
    isInGame = true
;

DabneyMapEntry template 'vocabWords' 'name' "subdesc";

DabneyMapEntry '1 alley one' 'Alley One'
    "north of the breezeway, which is just west of the courtyard"
;
DabneyMapEntry '2 alley two' 'Alley Two'
    "upstairs from Alley One"
;
DabneyMapEntry '3 alley three' 'Alley Three'
    "just off the courtyard, to the southwest"
;
DabneyMapEntry '4 alley four' 'Alley Four'
    "upstairs from Alley Three"
;
DabneyMapEntry '5 alley five' 'Alley Five'
    "just off the courtyard, to the southeast"
;
DabneyMapEntry '6 alley six' 'Alley Six'
    "upstairs from Alley Five"
;
DabneyMapEntry '7 upper lower alley seven' 'Alley Seven'
    "upstairs from the courtyard"
;
DabneyMapEntry 'courtyard' 'the courtyard'
    "in the middle of the house, right inside from the Orange Walk"
;
DabneyMapEntry 'lounge' 'the lounge'
    "just off the courtyard, to the east"
;
DabneyMapEntry 'dining room' 'the dining room'
    "north of the lounge"
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
CampusMapEntry 'alles lab/laboratory' 'Alles Laboratory' 'southwest';
CampusMapEntry 'alumni house' 'the Alumni House' 'northeast';
CampusMapEntry 'arms lab/laboratory' 'Arms Laboratory' 'southwest';
CampusMapEntry 'avery center' 'Avery Center' 'north';
CampusMapEntry 'baxter hall' 'Baxter Hall' 'north';
CampusMapEntry 'beckman institute' 'the Beckman Institute' 'northwest';
CampusMapEntry 'beckman behavioral lab/labs/laboratory/laboratories/science' 
    'Beckman Laboratories of Behavioral Science' 'north';
CampusMapEntry 'beckman chemical lab/laboratory/synthesis'
    'Beckman Laboratory of Chemical Synthesis' 'southwest';
CampusMapEntry 'blacker house/hovse' 'Blacker House' 'southeast';
CampusMapEntry 'braun athletic center/gym' 'Braun Athletic Center'
    "It's on the south side of California Blvd. ";
CampusMapEntry 'braun house' 'Braun House' 'east';
CampusMapEntry 'braun lab/labs/laboratory/laboratories'
    'Braun Laboratories' 'west';
CampusMapEntry 'catalina graduate housing'
    'the Catalina Graduate Housing' 'northwest';
CampusMapEntry 'central engineering services'
    'Central Engineering Services' 'northeast';
CampusMapEntry 'central plant' 'Central Plant'
    "It's on the south side of California Blvd. ";
CampusMapEntry 'chandler dining hall' 'Chandler Dining Hall' 'east';
CampusMapEntry 'church lab/laboratory' 'Church Laboratory' 'southwest';
CampusMapEntry 'crellin lab/laboratory' 'Crellin Laboratory' 'southwest';
CampusMapEntry '(dabney) hall/humanities' 'Dabney Hall' 'southwest'
    desc = "Confusingly, the campus has two buildings named
        Dabney: Dabney Hall of the Humanities, which is an academic
        building full of classrooms and faculty offices, and Dabney
        House, the student house.
        <.p><<inherited>>"
;
CampusMapEntry '(dabney) gardens' 'Dabney Gardens' 'southwest';
CampusMapEntry '(holliston) parking structure'
    'the Holliston parking structure' 'northeast';
CampusMapEntry 'industrial relations center'
    'the Industrial Relations Center' 'northeast';
CampusMapEntry 'isotope handling lab/laboratory'
    'the Isotope Handling Laboratory' 'southwest';
CampusMapEntry 'karman lab/laboratory' 'Karman Laboratory' 'south';
CampusMapEntry 'keck lab/laboratories' 'Keck Laboratories' 'central';
CampusMapEntry 'keith spalding building'
    'the Keith Spalding Building' 'southeast';
CampusMapEntry 'kellogg radiation lab/laboratory'
    'the Kellogg Radiation Laboratory' 'southwest';
CampusMapEntry 'kerckhoff lab/labs/laboratory/laboratories'
    'Kerckhoff Laboratories' 'southwest';
CampusMapEntry 'marks house' 'Marks House' 'east';
CampusMapEntry 'mead lab/laboratory' 'Mead Laboratory' 'northwest';
CampusMapEntry 'mechanical universe' 'the Mechanical Universe' 'northeast';
CampusMapEntry 'project mathematics' 'Project MATHEMATICS!' 'northeast';
CampusMapEntry 'moore lab/laboratory' 'Moore Laboratory' 'north';
CampusMapEntry 'morrisroe astroscience lab/laboratory'
    'Morrisroe Astroscience Laboratory'
    "It's on the south side of California Blvd., out by the track. ";
CampusMapEntry 'north mudd lab/laboratory'
    'North Mudd Laboratory' 'southwest';
CampusMapEntry 'noyes lab/laboratory' 'Noyes Laboratory' 'northwest';
CampusMapEntry 'parsons-gates hall/administration'
    'the Parsons-Gates Hall of Administration' 'southwest';
CampusMapEntry 'powell-booth lab/laboratory'
    'Powell-Booth Laboratory' 'central';
CampusMapEntry 'public events ticket office/offices'
    'the Public Events ticket offices' 'northwest';
CampusMapEntry 'public relations' 'Public Relations' 'northeast';
CampusMapEntry 'media relations' 'Media Relations' 'northeast';
CampusMapEntry 'visitors center' 'the Visitors Center' 'northeast';
CampusMapEntry 'robinson lab/laboratory' 'Robinson Laboratory' 'southwest';
CampusMapEntry 'sherman fairchild (library)'
    'the Sherman Fairchild Library' 'south';
CampusMapEntry 'sloan lab/laboratory' 'Sloan Laboratory' 'southwest';
CampusMapEntry 'south mudd lab/laboratory'
    'South Mudd Laboratory' 'southwest';
CampusMapEntry 'spalding lab/laboratory' 'Spalding Laboratory' 'south';
CampusMapEntry 'steele house' 'Steele House' 'northeast';
CampusMapEntry 'steele lab/laboratory' 'Steele Laboratory' 'north';
CampusMapEntry 'theater arts/tacit' 'Theater Arts' 'northeast';
CampusMapEntry 'watson lab/labs/laboratory/laboratories'
    'Watson Laboratories' 'north';
CampusMapEntry 'wilson parking structure'
    'the Wilson parking structure' 'west';
CampusMapEntry 'winnett center' 'Winnett Center' 'south';
CampusMapEntry 'red door cafe' 'the Red Door Cafe' 'south';
CampusMapEntry 'young health center' 'the Young Health Center'
    "It's on the south side of California Blvd. ";

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
    descCherryPickerArrival = "You find an out-of-the-way spot, and
        park the cherry picker. "

    /* 
     *   provide the cherry picker's specialDesc when the PC is in the
     *   cherry picker, and the cherry picker is in this location 
     */
    inCherryPickerSpecialDesc = "You're standing in the basket of
        a cherry picker. "

    /* provide the specialDesc for the cherry picker when it's here */
    cherryPickerSpecialDesc = "A cherry picker is parked here. "

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
    vocabWords = '(clear) (blue) orange-brown hazy smog/haze'
    desc()
    {
        /* 
         *   the smog starts around noon, so if we haven't reached an
         *   event that's noon or after yet, it's not yet smoggy 
         */
        if (clockManager.curTime[2] < 12)
            "The sky is relatively blue and clear.  It's a warm, still
            day, though, so it'll probably get smoggy in the afternoon. ";
        else
            "The smog isn't terrible today, but the sky has taken on
            that distinctive orange-brown color and is looking a bit
            hazy. ";
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
        action() { "(If you want to go somewhere, just say which
            direction to go.) "; }
    }
;    

/* ------------------------------------------------------------------------ */
/*
 *   San Pasqual Street 
 */
sanPasqual: Street, CampusOutdoorRoom 'San Pasqual St.' 'San Pasqual'
    'San Pasqual street'
    "This is the end of a wide residential street.  Parked cars line
    both sides of the street, which continues to the east, out into
    Pasadena.  The street ends here and becomes a walkway to
    the west, leading deeper into the campus.  Tall bushes along the
    south side of the street partially conceal a wall, which encloses
    the rear of the North Houses complex.  Holliston Ave., which
    ends here in a T-intersection, continues north. "

    vocabWords = 'san pasqual st./street'
    isProperName = true

    north = spHolliston
    west = spWalkway
    east: FakeConnector { "That way lies Pasadena.  Nice enough
        town, but you should attend to your business here first. " }

    atmosphereList: ShuffledEventList {
        [
            '',
            'A beat-up old car drives slowly by, obviously looking
            for parking.  The driver looks your way, undoubtedly hopeful
            that you\'re about to get in a car and leave.  She creeps
            along the curb for a bit, but after a bit she abruptly
            drives off. ',
            'A police siren races by on one of the nearby streets. ',
            'An older man dressed in a garishly colorful
            medieval court jester outfit walks past. '
        ]
        [
            'Two maintenance guys drive by, at about two miles per
            hour, in one of those B&amp;G electric golf carts. ',
            'A car drives by looking for parking, but finds none
            and leaves. ',
            'A small group of students walks past and heads up
            Holliston. ',
            'A couple walking their dog strolls past, heading
            west into the campus. ',
            'A B&amp;G golf cart drives by carrying a couple of
            big metal trash cans. '
        ]
        eventPercent = 66
    }
;

+ CampusMapEntry 'san pasqual st./street' 'San Pasqual St.' 'northeast';

+ Decoration 'parked car/cars' 'parked cars'
    "San Pasqual is one of the closest places to campus where it's
    possible to park a car, but the street is too short to accommodate
    more than a couple dozen cars.  The cars probably mostly belong to
    students. "
    isPlural = true
;

+ spHolliston: Street, PathPassage
    's. s south holliston ave./avenue' 'Holliston'
    "Holliston is another residential-style street.  It ends here
    in a T-intersection and continues north. "

    isProperName = true

    /* 
     *   we mention in the room description that the Career Center Office
     *   is 'up' holliston... 
     */
    dobjFor(ClimbUp) asDobjFor(GoThrough)
;

+ spWalkway: PathPassage 'campus/walkway/path' 'walkway'
    "The paved walkway leads deeper into the campus to the west. "

    /* we can't go this way until we've finished at the career center */
    canTravelerPass(trav) { return ccOffice.doneWithAppointment; }
    explainTravelBarrier(trav)
    {
        reportFailure('Much as you\'d like to spend some time looking
            around the campus, you really need to get to the Career
            Center if you\'re going to make your appointment. ');
    }
;

+ Decoration 'eight-foot concrete tall north house houses
    bush/bushes/wall/complex' 'wall'
    "The North Houses are on the other side of the eight-foot
    concrete wall, but all you can see from here is the wall. "

    dobjFor(Climb)
    {
        verify() { }
        action() { "That really wouldn't save much time versus just
            walking around to the Olive Walk, where you can go in
            the front door. "; }
    }
    dobjFor(ClimbUp) asDobjFor(Climb)
;

/* ------------------------------------------------------------------------ */
/*
 *   Holliston Ave. 
 */
holliston: Street, CampusOutdoorRoom
    'Holliston Ave.' 'Holliston' 'Holliston Avenue'
    "This is a typically wide Pasadena residential street, running
    north and south.  The back side of the Physical Plant machine shop is
    to the west, and the Student Services building is on the east side
    of the street. "

    isProperName = true
    vocabWords = 'holliston ave./avenue'

    south = holSanPasqual
    east = cssLobby
    north: FakeConnector { "There's not much more of the campus further
        up Holliston---there are the two new undergraduate houses
        they built a few years ago, but you should probably save the
        sightseeing for after you're done with more urgent matters. " }
;

+ CampusMapEntry '(physical) (plant) machine shop'
    'the physical plant machine shop' 'northeast';
+ CampusMapEntry 'student services career center office building/(office)'
    'Student Services' 'northeast';
+ CampusMapEntry 's. s south holliston ave./avenue'
    'Holliston Ave.' 'northeast';

+ holSanPasqual: Street, PathPassage ->spHolliston
    'san pasqual st./street' 'San Pasqual Street'
    "Holliston ends in a T-intersection with San Pasqual St.\ just
    to the south of here. "
    isProperName = true
;

+ Fixture 'back physical plant machine (loading) shop/(dock)/(docks)/side'
    'machine shop'
    "The only thing to see on this side of the shop is the
    loading docks.  No trucks are loading right now, so all of
    the roll-down doors are closed. "
;
++ Decoration 'loading dock docks (physical) (plant) (machine) (shop)
    roll-down roll down door/doors' 'loading dock doors'
    "The loading dock doors are all closed. "
    isPlural = true
;

+ EntryPortal ->cssLobby 'student services building/entrance/center'
    'Student Services building'
    "This building was a graduate student house when you were a
    student, and it still looks a lot like a dorm: it's a squat,
    three-story, rectangular concrete box with little windows spaced
    at monotonously regular intervals along the wall.  A sign by
    the entrance reads <q>Student Services Center.</q>  You can enter
    to the east. "
;
++ Readable, Decoration '(student) (services) (center) (building) sign'
    'sign'
    "It reads simply: <q>Student Services Center.</q> "
;
++ Decoration '(student) (services) (building) little small casement windows'
    'windows'
    "They're small casement windows, spaced at regular intervals. "
    isPlural = true
;

/* ------------------------------------------------------------------------ */
/*
 *   Center for Student Services lobby 
 */
cssLobby: Room 'Student Services Lobby' 'the Student Services lobby' 'lobby'
    "A brightly-colored sofa and a couple of big potted plants
    lend some cheer to this small lobby.  Several doors
    lead to adjoining rooms: to the north is a door labeled
    <q>Office of Graduate Studies</q>; to the east, a door marked
    <q>Student Affairs</q>; and to the south, <q>Career Center
    Office.</q>  A doorway to the west leads out to the street. "

    vocabWords = 'student services lobby'

    north = cssDoorN
    south = cssDoorS
    east = cssDoorE
    west = holliston
    out asExit(west)
;

+ EntryPortal ->holliston 'doorway' 'doorway'
    "The doorway leads out to the street. "
;

+ cssDoorN: AlwaysLockedDoor
    '"office of graduate studies" office graduate studies north n door*doors'
    'north door'
    "It's marked <q>Office of Graduate Studies.</q> "
;

+ cssDoorE: AlwaysLockedDoor
    '"student affairs" student affairs east e door*doors' 'east door'
    "It's marked <q>Student Affairs.</q> "
;

+ cssDoorS: Door
    '"career center office" career center office south s door*doors'
    'south door'
    "It's marked <q>Career Center Office.</q> "
    initiallyOpen = true
;

+ Fixture, Chair
    'colorful brightly-colored colored sofa/couch*furniture'
    'sofa'
    "It's a full-sized sofa upholstered in cloth with random
    splotches of bright colors. "

    /* allow four people at once on the sofa (a person's bulk is 10) */
    bulkCapacity = 40
;

+ Decoration 'big green leafy potted plant/plants/tree/trees' 'potted plants'
    "They're big, green, leafy trees in clay pots. "
    isPlural = true
;
+ Decoration 'clay pot/pots' 'clay pots'
    "There's nothing remarkable about them; they're just there
    to hold the trees. "
    isPlural = true
;

/* ------------------------------------------------------------------------ */
/*
 *   San Pasqual walkway
 */
sanPasqualWalkway: CampusOutdoorRoom 'San Pasqual Walkway'
    'the San Pasqual walkway' 'walkway'
    "This broad paved walkway curves through a well-maintained lawn
    surrounded by campus buildings.  The entrance to Jorgensen lab is
    to the north, the Physical Plant offices are to the northeast,
    and the back of Page House is to the southeast.

    <.p>The walkway continues west, and abuts the end of San
    Pasqual Street to the east.  A narrower intersecting walkway leads
    south. "

    isProperName = true

    east = spwStreet
    west = spwWestWalk
    south = spwSouthWalk
    north = jorgensen
    northeast = ppOffice
    southeast: NoTravelMessage { "There's no entrance to the
        building on this side. " }
;

+ CampusMapEntry 'jorgensen lab/laboratory'
    'Jorgensen Laboratory' 'northeast'
;

+ CampusMapEntry 'b&g physical plant office/offices'
    'the Physical Plant offices' 'northeast'
;

+ EntryPortal ->(location.northwest)
    'jorgensen windowless concrete exterior/lab/laboratory/entrance'
    'Jorgensen Lab'
    "Jorgensen is the main computer science building.  It's always
    looked vaguely like a bunker to you, probably because of its almost
    windowless concrete exterior.  The entrance is to the north. "
    isProperName = true
;

+ EntryPortal ->(location.north)
    'b&g physical plant offices/building/door/doorway'
    'Physical Plant offices'
    "Physical Plant, a/k/a Buildings and Grounds, a/k/a B&amp;G, is
    the department that maintains the campus's infrastructure.  This
    modest single-story structure is where the B&amp;G managers
    have their offices.  A doorway leads inside. "
    isPlural = true
;

+ Immovable 'back page house/corner' 'Page House'
    "Page is one of the student houses.  Only the back corner is
    visible here; there's no entrance on this side. "
    isProperName = true

    dobjFor(Enter) { verify() { illogical('There\'s no entrance to
        the building on this side. '); } }
;

+ spwStreet: Street, PathPassage ->spWalkway
    'san pasqual st./street' 'San Pasqual Street'
    "San Pasqual is just to the east. "
    isProperName = true

    canTravelerPass(trav) { return trav != cherryPicker; }
    explainTravelBarrier(trav)
    {
        "Better not drive the cherry picker off campus; it
        certainly can't be street-legal. ";
    }
;

+ spwSouthWalk: PathPassage ->quadNorthWalk
    'narrower intersecting south s walkway/path' 'intersecting walkway'
    "The intersecting walkway leads south. "
;

+ spwWestWalk: PathPassage ->blEastWalk
    'west w san pasqual walkway' 'west walkway'
    "The walkway extends west, and opens into San Pasqual Street to the
    east. "
;

+ Decoration 'well maintained grassy large lawn/grass' 'lawns'
    "The lawns are covered with healthy green grass. "
    isPlural = true
;

/*
 *   Create special noun phrase syntax for "Gunther the gardener" -
 *   normally, articles aren't allowed in the middle of a noun phrase like
 *   that. 
 */
grammar qualifiedSingularNounPhrase(gunther): 'gunther' 'the' 'gardener'
    : SpecialNounPhraseProd

    /* we match only gunther */
    getMatchList = [gunther]

    /* get our "adjusted" tokens; make 'the' a miscellaneous word */
    getAdjustedTokens()
        { return ['gunther', &noun, 'the', &miscWord, 'gardener', &noun]; }
;

/* ------------------------------------------------------------------------ */
/*
 *   The Physical Plant office
 */
ppOffice: Room 'Physical Plant Office' 'the Physical Plant Office'
    "A service counter divides this small room roughly in half,
    the south side being for customers and the north side for
    employees.  A doorway to the southwest leads outside; on the
    other side of the counter, a narrow hallway leads north. "
    
    vocabWords = 'physical plant office'

    southwest = sanPasqualWalkway
    south asExit(southwest)
    out asExit(south)
    north = ppoHall
;

+ EntryPortal ->(location.out) 'southwest sw door/doorway' 'doorway'
    "The doorway leads outside to the southwest. "
;

+ Surface, Fixture 'service counter' 'service counter'
    "The counter runs across the middle of the room, dividing it
    roughly into two halves: the south side for customers, the
    north side for employees. "

    dobjFor(LookBehind) { action() { "You lean over the counter a little
        to get a look behind it, but you see nothing interesting. "; } }

    dobjFor(StandOn)
    {
        verify() { }
        action() { "Better not; it would look weird if someone
            walked in. "; }
    }
    dobjFor(SitOn) asDobjFor(StandOn)
    dobjFor(LieOn) asDobjFor(StandOn)
    dobjFor(Board) asDobjFor(StandOn)
;

++ oakJobCard: JobCard 'green -' 'green index card'
    cardColor = 'green'
    cardDept = 'GARDENING'
    cardJob = 'TRIM OAK'
    cardLoc = 'BECKMAN LAWN'
    cardDesc = 'TRIM/SHAPE OAK BRANCHES. 1-MAN PERSONAL LIFTER AUTH\'D. '
;
++ oliveJobCard: JobCard 'yellow - ' 'yellow index card'
    cardColor = 'yellow'
    cardDept = 'GARDENING'
    cardJob = 'TRIM TREES'
    cardLoc = 'OLIVE WK @ FLEMING'
    cardDesc = 'TRIM OLIVE TREE BRANCHES &amp; CLEAR DEBRIS. USE
        PERSONAL LIFTER (SINGLE) IF NEEDED. '
;
++ orwalkJobCard: JobCard 'blue -' 'blue index card'
    cardColor = 'blue'
    cardDept = 'ELECTRICAL'
    cardJob = 'REPAIR LIGHTING'
    cardLoc = 'ORANGE WK @ DABNEY HOUSE'
    cardDesc = 'PED.\ LIGHT #S30 OUT.\ BULB OK, CHECK WIRING.'
;    
++ lauritsenJobCard: JobCard 'pink -' 'pink index card'
    cardColor = 'pink'
    cardDept = 'ELECTRICAL'
    cardJob = 'LIGHTING MAINT.'
    cardLoc = 'LAURITSEN'
    cardDesc = 'CHECK EXT.\ LIGHTING, REPAIR AS NEEDED.'
;

++ Readable '(physical) (plant) memo' 'memo'
    "<tt>To: Shift Supervisors
    \nFrom: Management
    \nRe: Staff disagreements
    \bIt has come to our attention that certain staff members have
    not been getting along with each other.  We do not want to name
    any names, but we ask supervisors to make their daily schedules
    to keep ERNST and GUNTHER apart.  I.e., DO NOT schedule tree
    trimming and electrical maintenance at the same place and time.
    If possible do not even let these two cross paths during the day.
    We do not want another repeat of the incident of last week, when
    someone we shall not name left his service vehicle unattended
    while he chased the other unnamed party all around campus for
    two hours.  Leaving service vehicles unattended makes them
    vulnerable to all sorts of student and faculty hijinks, as we
    saw once again in last week's incident when said service vehicle
    was found on the roof of our offices the next morning.</tt> "
    disambigName = 'physical plant memo'
;

+ ppoHall: OutOfReach, ThroughPassage 'hall/hallway' 'hallway'
    "The hallway leads north, further into the building. "

    cannotReachFromOutsideMsg(dest) { return 'You can\'t reach the
        hallway from this side of the counter. '; }

    dobjFor(TravelVia)
    {
        preCond = []
        verify() { }
        check()
        {
            "You have to assume that the area behind the counter is
            for authorized personnel only. ";
            exit;
        }
    }
;

/* 
 *   A class for the job cards on the physical plant counter, which all
 *   list together. 
 */
class JobCard: Readable 'colored index job assignment card*cards' 'index card'
    "It's a <<cardColor>> five-by-seven index card, pre-printed
    with a form that's been filled out with a typewriter:
    <font face='tads-sans'>
    \bCALTECH PHYSICAL PLANT
    \nJOB ASSIGNMENT CARD
    \bDept.: <font face='tads-typewriter'><u>&nbsp;<<cardDept
      >>&nbsp;&nbsp;&nbsp;</u></font>
    \nJob: <font face='tads-typewriter'><u>&nbsp;<<cardJob
      >>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</u></font>
    \nLocation: <font face='tads-typewriter'><u>&nbsp;<<cardLoc
      >>&nbsp;&nbsp;&nbsp;</u></font>
    \nDesc.: <font face='tads-typewriter'><u>&nbsp;<<cardDesc
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
            "a couple of colored index cards";
        else
            "several colored index cards";
    }

    /* the name of an individual item in the parenthesized sublist */
    showGroupItem(lister, obj, options, pov, info)
        { "one <<obj.cardColor>>"; }
;

/* ------------------------------------------------------------------------ */
/*
 *   Jorgensen - main lobby
 */
jorgensen: Room 'Jorgensen Lobby' 'the lobby of Jorgensen' 'lobby'
    "This is a large, open area, decorated by framed photos
    along the walls.  Classrooms lie to the east and west,
    and a corridor leads north.  The building's exit is to
    the south. "

    vocabWords = 'jorgensen lab/laboratory/lobby'

    north = jorgensenHall
    south = sanPasqualWalkway
    out asExit(south)

    west: FakeConnector { "You peek into the classroom, but you
        don't see anything interesting. "; }

    east: FakeConnector { "You have a look in the classroom, but
        you see nothing of interest. "; }
;

+ ExitPortal ->(location.south) 'building building\'s exit' 'exit'
    "The exit is to the south. "
;

+ Enterable ->(location.north) 'corridor/hall/hallway' 'corridor'
    "The corridor leads north. "
;

+ Decoration 'framed black-and-white photo/photos/picture/pictures'
    'framed photos'
    "The photos are mostly black-and-white, showing historical
    computer equipment.  The oldest ones are analog computers;
    operators peer into hooded displays to read oscilloscope
    traces.  Later pictures show what look like giant
    switchboards adorned with masses of tangled cables: a rather
    literal kind of <q>spaghetti code.</q> After that are the early
    mainframes, huge boxes attended by white-coated technicians. "

    isNominallyIn(obj) { return inherited(obj) || obj.ofKind(DefaultWall); }

    isPlural = true
;

+ Decoration 'east west e w classroom/classrooms' 'classroom'
    "Classrooms lie to the east and west. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Jorgensen - hallway 
 */
jorgensenHall: Room 'Corridor' 'the corridor'
    "This is a hallway running north and south.  Doors line the
    hall on both sides; apart from the door to the west, which is
    labeled <q>Campus Network Office,</q> the doors appear to be
    to private offices.  The hallway ends a short way to the north,
    and opens into a lobby to the south. "

    vocabWords = 'jorgensen hall/hallway/corridor/lab/laboratory'

    south = jorgensen
    out asExit(south)

    east = jhPrivateDoor
    northeast = jhPrivateDoor
    southeast = jhPrivateDoor
    northwest = jhPrivateDoor
    southwest = jhPrivateDoor

    west = jhNetworkOfficeDoor
    
    north: NoTravelMessage { "The hallway ends a short distance
        to the north. "; }
;

+ Enterable ->(location.south) 'lobby' 'lobby'
    "The lobby lies to the south. "
;

+ jhPrivateDoor: ForbiddenDoor
    'private office door*doors' 'private office doors'
    "Most of the doors along the hall appear to be to private offices. "
    isPlural = true

    cannotEnter = "That appears to be a private office.  It would be
        rude to just walk in. "
;

+ jhNetworkOfficeDoor: LockableWithKey, Door
    'west w campus network office door*doors' 'Campus Network Office door'
    "The door is labeled <q>Campus Network Office.</q> "
;
++ jhSign: CustomImmovable, Readable 'handwritten sign' 'handwritten sign'
    "The sign reads <q>Closed - Back at 1 PM.</q> "

    /* 
     *   Show a special description.  Note that we use separate special
     *   descriptions for room descriptions and contents descriptions
     *   because of the surplus of doors.  In the room description, we need
     *   to say which door the sign is on; in the contents description,
     *   that would be redundant, since we're just examining the door. 
     */
    specialDesc = "A hand-written sign on the Network Office door
        reads <q>Closed - Back at 1 PM.</q> "
    showSpecialDescInContents(actor, cont) { "A hand-written sign
        on the door reads <q>Closed - Back at 1 PM.</q> "; }

    cannotTakeMsg = 'You have no reason to remove the sign. '
;

/* ------------------------------------------------------------------------ */
/*
 *   The Campus Network Office 
 */
networkOffice: Room 'Network Office' 'the Network Office' 'office'
    "This room is set up roughly like a private office.  A desk
    is positioned across the center of the room, facing the door,
    and behind the desk are floor-to-ceiling bookshelves, crammed
    with print-outs, binders, folders, and loose papers.  Most
    of the space on the desk is occupied by several terminals and
    workstations.  The door leads out to the east. "

    vocabWords = 'campus network office'

    east = netOfcDoor
    out asExit(east)

    west: NoTravelMessage { "You'd best stay on this side of the desk. "; }

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

+ netOfcDoor: Door ->jhNetworkOfficeDoor 'door' 'door'
    "The door leads out to the east. "
;

+ Heavy, Surface 'desk' 'desk'
    "The desk faces the door, informally dividing the room.  Several
    terminals and workstations vie for space on the surface. "

    iobjFor(PutOn)
    {
        check()
        {
            "There's very little free space on the desk where you
            could put anything new. ";
            exit;
        }
    }

    dobjFor(LookBehind) { action() { "The main thing you see behind
        the desk is the bookshelves. "; } }
;

++ Heavy 'terminal/terminals/workstation/workstations' 'workstations'
    "They're facing the other way, so you can't see exactly what
    kind they are from here. "

    isPlural = true

    dobjFor(Use) asDobjFor(TypeOn)
    dobjFor(TypeLiteralOn) asDobjFor(TypeOn)
    dobjFor(TypeOn)
    {
        verify() { }
        action() { "The terminals are facing the other way; you can't
            easily type on them from here. "; }
    }
;

+ Heavy 'rolling office chair' 'office chair'
    "It's a simple rolling office chair. "
;

++ dave: IntroPerson 'heavy-set middle-aged dave/david/man*men' 'man'
    "He's a heavy-set, middle-aged man, wearing a slightly rumpled
    white dress shirt without a tie. "

    specialDesc = "{A/he dave} is sitting behind the desk. "

    isHim = true
    globalParamName = 'dave'
    properName = 'Dave'

    posture = sitting
    postureDesc = "He's sitting behind the desk. "
;

+++ daveGreet: AgendaItem
    invokeItem()
    {
        "{The/he dave} looks up as you enter. <q>Hi,</q> he says. ";
        me.noteConversation(dave);
        isDone = true;
    }
;

+++ InitiallyWorn 'rumpled wrinkled white dress shirt' 'white shirt'
    "It's a little wrinkled, but otherwise presentable. "
    isListedInInventory = nil
;

+++ HelloTopic
    topicResponse()
    {
        "<q>Hi,</q> you say, <q>I'm Doug.</q>
        <.p>He gives you a little nod. <q>I'm Dave,</q> he says.
        <q>What can I do you for?</q> ";

        /* note that he's introduced now */
        dave.setIntroduced();
    }
;
++++ AltTopic
    "<q>Hi again,</q> you say.  Dave gives you a little nod. "
    isActive = (dave.introduced)
;


+++ AskTopic @dave
    topicResponse()
    {
        "<q>Do you work here?</q> you ask.
        <.p><q>Yep,</q> he says. <q>I'm Dave.  What can I do you for?</q> ";
        dave.setIntroduced();
    }
;
++++ AltTopic
    "<q>What do you do here?</q> you ask.
    <.p>He shrugs. <q>Network operations, officially.  Mostly means I
    run around yelling at people for using unassigned IP addresses,
    downloading too many MP3's, that sort of thing.</q> "
    isActive = (dave.introduced)
;

+++ AskTopic @networkOffice
    "<q>What does the Network Office do?</q> you ask.
    <.p><q>All sorts of things,</q> he says. <q>We run the physical
    network, manage IP assignments, configure the routers, you name it.</q> "
;

+++ AskTellTopic, StopEventList [quadWorkers, nicTopic]
    ['<q>What are the guys out on the quad doing?</q> you ask.
    <.p><q>You mean the NIC guys?</q> he asks. <q>They\'re doing some
    contracting for us.  Network wiring upgrades.</q>  He looks around
    you to see if anyone\'s coming, and lowers his voice. <q>Just between
    you and me, I think they\'re goldbricking us something awful,
    frankly.</q><.reveal dave-suspects-nic> ',

     '<q>The NIC people...</q> you start.  <q>What did you mean about
     them goldbricking?</q>
     <.p><q>Well,</q> he says, <q>half the time I find them down in the
     tunnels, doing jobs that, near as I can tell, they just made up.</q> ',

     '<q>So you\'re suspicious of the NIC contractors?</q> you ask.
     <.p><q>Yeah, you could say that,</q> he says.  <q>I\'m going to
     have to do some digging at some point.</q> ']
;

+++ AskTellTopic, SuggestedAskTopic
    topicResponse = "<q>Could you look up an IP address for me?</q>
        you ask.
        <.p>He frowns and scrutinizes your face for a few moments.
        <q>Why would you want me to do that?</q> he asks suspiciously.
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
    "<q>What was that you found out about that IP address again?
    It was <<infoKeys.spy9DestIPDec>>.</q>
    you ask.
    <.p>He checks the binder again. <q>Let's see.  Here it is.
    It's a job number with our network contractor:
    <<infoKeys.syncJobNumber>>.</q> "

    isActive = gRevealed('sync-job-number')
;

+++ AskTellTopic @ipAddressesTopic
    "<q>You handle IP assignments on campus, right?</q> you ask.
    <.p><q>Yep,</q> he says. <q>That's us.</q> "
;
+++ AskTellTopic @nrRouter
    "<q>You manage the campus routers, right?</q> you ask.
    <.p><q>Right,</q> he says, <q>among other things.</q> "
;

+++ AskTellGiveShowTopic @netAnalyzer
    "<q>Do you know how to work Netbisco 9099's?</q> you ask.
    <.p><q>That's a net analyzer, right?</q>  He stares off into
    the distance for a while. <q>Yeah, I've used them, but I'm
    sorry to say I can't remember the first thing about them.
    They have this crappy hex function-code interface.</q>
    He mimes punching keys in the air with his index finger.
    <q>Never could figure out those darn codes.</q> "
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
        "You're not sure how cooperative he'll be about looking up IP
        addresses for you, so you don't want to press your luck by asking
        about random addresses.  Better to limit yourself to asking about
        ones you really need to track down. ";
    }

    isConversational = nil
;
++++ AltTopic
    "You don't want to pester him with requests to look up random IP
    addresses. "
    isConversational = nil
    isActive = gRevealed('sync-job-number')
;

/* we might ask about the camera IP number as well */
+++ AskTellTopic
    matchPattern = static (new RexPattern(
        infoKeys.spy9IPDec.findReplace('.', '<dot>', ReplaceAll, 1) + '$'))

    topicResponse = "You don't want to wear out your welcome with
        unnecessary requests.  You already know everything you need
        to know about that IP address---it's the one the SPY-9 camera
        is using. "

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
        "<q>What can you tell me about <q><<gTopic.getTopicText()
          >></q>?</q>you ask.
        <.p>He laughs. <q>So, you've heard I'm the human hex-to-decimal
        converter.</q>   He closes his eyes for a few moments.
        <q>\^<<convertLiteral>>!</q>
        he says, looking pleased with himself. ";
    }

    nthResponse()
    {
        "<q>How about <q><<gTopic.getTopicText()>></q>?</q> you ask.
        <.p>He squints and thinks, then announces,
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
            str = spellInt(toInteger(num / 1000000000)) + ' billion, ';

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
    topicResponse = "<q>What can you tell me about
        <q><<gTopic.getTopicText()>></q>?</q>you ask.
        <.p><q>That's an awfully big hex number,</q> he says. "
;

+++ AskAboutForTopic, SuggestedAskTopic @jobNumberTopic
    "<q>Just out of curiosity, what was that job number?</q>
    <.p>He shrugs and pulls out the binder again, and finds the
    right page. <q>Here it is. <<infoKeys.syncJobNumber>>.  Won't
    do you much good, though---they have their own private system
    for those.</q><.reveal sync-job-number> "
    
    name = 'the job number'
    isActive = gRevealed('sync-job-number-available')
;
++++ AltTopic
    "<q>What was that job number you gave me again?</q>
    <.p>He sighs and pulls out the binder. <q>It's
    <<infoKeys.syncJobNumber>>.  I really don't know anything more
    about it, though.  Sorry.</q> "
    isActive = gRevealed('sync-job-number')
;
+++ DefaultAnyTopic, ShuffledEventList
    ['He types something on one of the workstations. <q>Just a sec,</q>
    he says, <q>I have to answer this chat.</q> ',
     'Something on one of the terminals distracts him as you\'re talking. ',
     '<q>Sorry,</q> he says, <q>not my department.</q> ']
;

+++ ConvNode 'dave-why-ip'
    genericSearch = "He types on his terminal, looks at the screen,
        types some more. <q>Hmm.</q>  He rolls his chair over to the
        wall and scans his fingers over some binders, then pulls one
        out and flips through it. He puts it back and returns to the
        terminal.  <q>That's in a block we gave to NIC,</q> he says.
        <q>The contractors we have doing some new wiring.</q>  He taps
        away at the terminal. <q>They're supposed to tell us how they're
        using these, but they're not always all that prompt.</q>  He
        goes back to the shelf and pulls out another binder, and scans
        through it. <q>Here we are.  Sorry, bad news.  All they gave us
        is a job number, which won't do either of us a fat lot of good.</q>
        He puts the binder back.<.reveal sync-job-number-available>"
;

++++ TellTopic, SuggestedTopicTree, SuggestedTellTopic @spy9
    "You hesitate to say too much, because you can't be sure who
    was involved with planting the camera.  <q>I'm trying to track
    down some monitoring equipment,</q> you say. <q>We're not sure
    exactly where it\'s plugged in.</q>
    <.p>He seems to accept that. <q>Okay, let me see what I can
    find.</q>  <<location.genericSearch>> "

    name = 'the SPY-9 camera'
;
+++++ AltTopic
    "You hesitate to say too much, but given his suspicions about
    the NIC guys, you figure he might be willing to help.  <q>I'm
    trying to track down some unauthorized equipment that I think
    the NIC people installed,</q> you say.
    <.p>He raises his eyebrows. <q>Really,</q> he says.  <q>Well,
    let me see what I can find.</q>  He types on his terminal,
    looks at the screen, types some more. <q>Hmm.</q>  He rolls his
    chair over to the wall and scans his fingers over some binders,
    then pulls one out and flips through it.  He puts it back and
    returns to the terminal.  <q>Sure enough, that's in a block we
    gave to NIC,</q> he says.  He taps away at the terminal.
    <q>They're <i>supposed</i> to tell us how they're using these,
    but they take their sweet time.</q>  He goes back to the shelf
    and pulls out another binder, and scans through it. <q>Here we
    are.  Well, what a surprise.  All they gave us is a job number,
    which won't do either of us a fat lot of good.</q>  He puts
    the binder back.<.reveal sync-job-number-available> "

    isActive = gRevealed('dave-suspects-nic')
;
++++ TellTopic [ddTopic, stamerStackTopic, stackTopic, stamerTopic,
               stamerLabTopic]
    "<q>It's for a Ditch Day stack,</q> you say.
    <.p>He smiles. <q>Ah, gotcha,</q> he says. <q>Happy to help.</q>
    <<location.genericSearch>> "
;

++++ SpecialTopic 'say you\'re a private detective'
    ['say','you\'re','i\'m','i','am','you','are','a','private','detective']
    "<q>I'm doing an informal investigation,</q> you say, trying to
    sound conspiratorial.
    <.p>He regards you suspiciously. <q>What kind of investigation?</q>
    he asks.<.convstay> "
;

/* a secret out-of-reach object representing the back half of the room */
+ OutOfReach, SecretFixture
    cannotReachFromOutsideMsg(dest) { return 'You can\'t reach that
        from this side of the room. '; }
;

++ Fixture
    'floor-to-ceiling bookshelf/bookshelves/shelf/shelves' 'bookshelves'
    "The bookshelves cover the walls behind the desk.  They're
    stuffed with print-outs, binders, folders, and loose papers. "
    isPlural = true
;
+++ Thing
    'loose print-out/print-outs/binder/binders/folder/folders/paper/papers'
    'papers'
    "You can't see much from here apart from the labels on a few
    of the binders: <q>1996 Wiring Plan,</q> <q>2000-1 Budget,</q>
    <q>South Campus Router Configuration.</q> "
    isPlural = true
;
++++ Component 'binder label/labels' 'binder labels'
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
        action() { "You have no reason to climb <<isPlural ?
              'any of these trees' : 'the tree'>>. "; }
    }
;

/* an orange - fruit for the orange trees */
class OrangeDecoration: CustomImmovable, Food
    'orange/oranges/fruit' 'oranges'
    "These trees yield a fairly small type of orange. "
    isPlural = true
    cannotTakeMsg = 'You tried an orange from one of these trees years
        ago, when you were a student, and you have no interest in repeating
        the sour experience. '
    dobjFor(Eat)
    {
        preCond = []
        action() { "You know from experience that these oranges are
            too acidic to eat. "; }
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   Lawn outside Beckman Auditorium 
 */
beckmanLawn: CampusOutdoorRoom 'Lawn near Beckman'
    'the lawn near Beckman' 'lawn'
    "The circular Beckman Auditorium is just north of this expansive
    lawn area; a towering double door leads inside.  A leafy oak tree
    leans over the grass, providing some shade.  A walkway leads east. "

    north = blDoors
    east = blEastWalk
;

+ CampusMapEntry 'beckman auditorium' 'Beckman Auditorium' 'north';

+ Decoration 'expansive lawn/grass' 'lawn'
    "The grass is well tended. "
;

+ blDoors: AlwaysLockedDoor
    '(beckman) (auditorium) towering double door/entrance'
    'entrance to the auditorium'
    "The imposing set of doors are at least twenty feet high. "

    cannotOpenLockedMsg = 'The doors seem to be locked---which isn\'t
        surprising, as there\'s not usually anything scheduled here
        during the day. '
;

+ Enterable ->(location.north)
    'circular beckman auditorium' 'Beckman Auditorium'
    "Beckman is known as the <q>wedding cake</q> for its visual
    resemblance to same: it's round, tall, and white, with a
    gently sloping cone for its roof. "
    isProperName = true
;
++ Distant, Component
    '(beckman) (auditorium) gently sloping conical roof/cone'
    'roof of the auditorium'
    "The roof is a gently sloping cone. "
;

+ blEastWalk: PathPassage 'east e walkway' 'east walkway'
    "The walkway leads east past the oak. "
;

+ blOak: TreeDecoration
    'tall full leafy oak tree/shade/branch/branches' 'oak tree'
    "The oak is tall and full. <<gunther.isIn(location)
      ? "A gardener is standing in a cherry picker parked under
        the tree, trimming branches. " : "">> "

    /* 
     *   this is obviously reachable from the cherry picker, whether raised
     *   or lowered
     */
    isCherryPickerReachable = true
;

+ cherryPicker: Heavy, Vehicle
    '(personal) small electric cherry picker/cart/lifter'
    'cherry picker'
    "It's a small electric cart with a passenger basket at the
    end of a boom, which <<cherryPickerBasket.isRaised
      ? "is currently raised up to its full height of about ten feet. "
      : "looks like it can raise the basket to a height of about ten
        feet, but is currently retracted. "
      >>  The operating controls appear to be located in the basket. "

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
            "You'd better keep the cherry picker outdoors. ";
            
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
            "You step on the pedal, and the cart accelerates to a full
            two miles per hour.  You steer the cart along the path. ";

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
            "\^<<gunther.aName>> drives a cherry picker in
            from <<conn.theName>>. ";
        else
            inherited(conn);
    }
    sayDepartingViaPath(conn)
    {
        if (gunther.isIn(self))
            "\^<<gunther.theName>> steers the cherry picker away
            down <<conn.theName>>. ";
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
        verify() { logicalRank(50, 'too heavy'); }
        check()
        {
            "The cherry picker is much too heavy to push around
            by hand; you'd have to get in and drive it to move
            it anywhere. ";
            exit;
        }
    }
;
++ cherryPickerBoom: Component '(cherry) (picker) (cart) boom' 'boom'
    "The boom raises and lowers the passenger basket. "
    disambigName = 'cherry picker boom'

    dobjFor(ClimbUp) asDobjFor(Climb)
    dobjFor(Climb)
    {
        verify()
        {
            if (!cherryPickerBasket.isRaised)
                illogicalNow('There\'s not much point in that when the
                    boom is in the retracted position. ');
        }
        check()
        {
            "You give it a try, but you quickly find that the boom
            doesn't have any good handholds. ";
            exit;
        }
    }

    dobjFor(Lower) remapTo(Pull, cherryPickerLever)
    dobjFor(Raise) remapTo(Push, cherryPickerLever)

    /* the boom can be reached from the basket in all positions */
    isCherryPickerReachable = true
;
++ cherryPickerBasket: OutOfReach, Component, Booth
    '(cherry) (picker) (cart) metal passenger basket/enclosure'
    'basket of the cherry picker'
    "It's a small metal enclosure, about waist-high, just large enough
    for one person to stand in. <<isRaised
      ? "It's currently raised to its full height of about
        ten feet above the ground."
      : "It's currently in its fully-lowered position."
      >> The basket contains the operating controls for the cart. "
    
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

    cannotReachFromOutsideMsg(dest) { return 'The basket is raised
        too high for you to reach. '; }
    cannotReachFromInsideMsg(dest) { return 'You can\'t reach that
        from the basket. '; }

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
    howToDrive = "(If you want to drive the cart
        somewhere, just <<gActor.isIn(cherryPickerBasket) ? ''
          : "get in and" >> say which direction you want to go.) ";

;
+++ gunther: IntroPerson
    'wild white fuzzy gunther der
    gardener/hair/mustache/gunther/gartner/g\u00e4rtner/gaertner/man*men'
    'gardener'
    "The gardener is a short man with wild white hair and a
    fuzzy white mustache. "

    properName = 'Gunther the gardener'

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
++++ Thing '(tree) clippers/trimmers/blade/blades/pair' 'tree clippers'
    "They're like very large scissors, with two-foot blades. "
    isPlural = true
    isListedInInventory = nil
;

/* base state for trimming tress */
class GuntherTrimmingState: ActorState
    stateDesc = "He's standing in the basket of the cherry picker,
        trimming branches from <<treeName>>. "
    specialDesc = "\^<<location.aName>> is standing in the raised basket
        of a cherry picker, trimming branches from <<treeName>>. "
    specialDescInContents = "\^<<location.aName>> is standing in the
        basket, trimming <<treeName>>. "

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
    treeName = 'the oak'
;

/* our state when trimming olive trees on the olive walk */
++++ guntherTrimmingOlive: GuntherTrimmingState
    treeName = 'one of the olive trees'
;

++++ DefaultCommandTopic
    "<q>Can't you see I'm busy here?</q> he asks with annoyance. "
;

++++ HelloTopic
    "<q>Hi,</q> you say.
    <.p>He glances down but keeps trimming. <q><i>Ja</i>, hi,</q>
    he says. "
;
++++ AskTellTopic, StopEventList @ernst
    ['<q>Do you know any electricians around here?</q> you ask.
    <.p><q>Electricians?</q> His eyes narrow. <q>Do you speak to
    me of that horrible Ernst?</q>  He starts speaking rapid
    German, which you don\'t know enough to follow what he\'s
    saying, but you can tell he\'s angry about something.  He
    finally stops and goes back to his trimming, still muttering. ',
     'You start to bring up the subject of electricians again,
     but he just starts saying <q><i>Nein</i></q> and ignoring
     you. ']
;

++++ AskTellShowTopic [blOak, owTrees]
    "<q>How\'s the tree coming?</q> you ask.
    <.p><q>Coming,</q> he says. <q>Dis tree needs a big lot
    of trimming.</q> "
;
++++ AskTellTopic, StopEventList @gunther
    [&doIntro,
     '<q>How\'s it going?</q> you ask.
     <.p>He glances down. <q>Not so bad,</q> he says. ']

    doIntro()
    {
        "<q>What\'s your name?</q> you ask.
        <.p>He keeps trimming while he talks. <q>Gunther,</q> he says.
        <q><i>Ja</i>, I know, Gunther der G&auml;rtner, very funny,
        I know, I know.</q> ";

        gunther.setIntroduced();
    }
;
++++ AskTellShowTopic @cherryPicker
    "<q>What kind of cherry picker is that?</q> you ask.
    <.p>He looks down at you, still trimming. <q>Das ist no concern
    of yours,</q> he says dismissively. "
;
++++ AskForTopic @cherryPicker
    "<q>Um, do you think I could borrow that cherry picker for
    a while?</q> You smile plaintively.
    <.p>The gardener stops his trimming for a moment and stares
    at you. <q><i>Nein!</i></q> he says, shaking his head emphatically.
    <q><i>Nein, nein, nein!</i></q>  He returns to clipping with
    renewed vigor. "
;
class GuntherJobCardTopic: GiveShowTopic
    topicResponse()
    {
        "<q>Here,</q> you say, holding the card up for the gardener.
        <.p>He lowers the basket enough to reach the card, and looks
        it over. ";

        /* check to see if we're already there */
        if (gunther.isIn(destLoc))
        {
            "<q>What looks like here already is going on that I work
            on, <i>ja</i>?</q> he says, waving the card around.
            He testily hands the card back to you, raises the basket
            back up, and goes back to trimming the tree. ";
            return;
        }

        /* get going */
        "<q>They said trim <i>this</i> tree!</q> he says.  He reads
        the card again, then looks resigned.  <q><i>Ja wohl,</i></q> he
        says, <q>now I go trim this other tree.</q>  He lowers the
        basket, muttering in German. ";

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
    "<q>Here,</q> you say, holding the card up for the gardener.
    <.p>He lowers the basket enough to reach the card, and looks
    it over. <q>Das ist not for <i>G&auml;rtner</i>!</q> he says,
    handing the card back.  <q>You want that job to do, go find
    <i>einen Elektromechaniker</i>!</q> "
;
++++ DefaultAnyTopic
    "He just ignores you and keeps trimming the tree. "
;

/* our state while we're traveling to our next location */
++++ guntherInTransit: ActorState
    stateDesc = "He's driving through in the cherry picker. "
    specialDesc = "\^<<location.theName>> is driving through in a
        cherry picker. "
    specialDescInContents = "\^<<location.theName>> is driving the
        cherry picker somewhere. "

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
            "<.p>The gardener parks the cherry picker under
            <<destState.treeName>>, raises the basket, and
            starts trimming. ";

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
            "<q><i>Nein!</i></q> the gardener shouts, blocking
            the way. <q>One occupant only this device can handle!</q> ";
            exit;
        }
    }
;

/* while we're in this state, we ignore conversations entirely */
+++++ DefaultAnyTopic
    "<q>Not now!</q> the gardener says without slowing down. <q>I must
    be going to the new job now!</q> "
    
    /* use this one while we're in transit */
    isActive = (gunther.curState == guntherInTransit)
;
    
/* our state while fighting */
++++ guntherFightingState: ActorState
    stateDesc = "He's chasing the electrician with a pair of tree clippers. "
    specialDesc = "\^<<ernst.aName>> runs toward you, a panicked look
        on his face, nearly crashing into you before swerving sharply
        to one side.  \^<<gunther.aName>> is right behind him, chasing
        him with a pair of tree clippers. "
;

+++ Component '(cherry) (picker) operating iconic
    silhouette/controls/icon/icons/arrow/arrows' 'controls'
    "The controls look simple.  A lever is labeled with an
    iconic silhouette of the basket on the boom, with arrows pointing
    up and down.  Next to the lever is a steering wheel, and below
    the wheel on the floor of the basket is a pedal, presumably the
    accelerator.  An icon above the steering wheel shows a silhouette
    of the cart with its basket raised, and an arrow pointing forward,
    and a big red X through the whole thing. "

    distantDesc = "The basket is too high up; you can't see the controls
        clearly from here. "

    isPlural = true
    disambigName = 'cherry picker controls'
;
+++ NestedRoomFloor 'floor/(basket)' 'floor of the basket'
    "A pedal is on the floor. "
;
++++ Component 'accelerator pedal' 'pedal'
    "It looks like an accelerator pedal. "

    dobjFor(Push)
    {
        verify()
        {
            if (!gActor.isIn(cherryPickerBasket))
                illogicalNow('You need to be in the basket to operate
                    the controls. ');
        }
        action()
        {
            "You give the pedal a little push<<
              cherryPickerBasket.isRaised
              ? ".  Nothing seems to happen."
              : ", and the cart jerks forward a little bit.  You
                release the pedal and the cart stops."
              >> <<location.location.howToDrive>> ";
        }
    }
;
+++ Component 'miniature steering wheel' 'steering wheel'
    "It's like the steering wheel of a car, but in miniature. "
    dobjFor(Turn)
    {
        verify()
        {
            if (!gActor.isIn(location))
                illogicalNow('You need to be in the basket to operate
                    the controls. ');
        }
        action()
        {
            "You turn the wheel a little, but it seems hard to turn
            while the cart is stopped.  <<location.howToDrive>> ";
        }
    }
;
+++ cherryPickerLever: Component '(cherry) (picker) lever' 'lever'
    "The lever is labeled with an icon showing the basket moving
    up and down. "
    disambigName = 'cherry picker lever'

    cannotMoveMsg = 'The lever doesn\'t move that way; you can only
        push and pull it. '
    
    dobjFor(Move)
    {
        /* it's logical to move the lever, but more specificity is required */
        verify() { logicalRank(50, 'move lever'); }
        action() { "(You'll have to be more specific: you can either push
            it or pull it.) "; }
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
                illogicalNow('You need to be in the basket to operate
                    the controls. ');
        }
        action()
        {
            if (cherryPickerBasket.isRaised)
            {
                "You pull the lever all the way back, and the basket
                slowly descends.  Once the boom is fully retracted,
                the descent stops, and you let the lever spring back
                to the center position. ";

                /* note that we're no longer raised */
                cherryPickerBasket.isRaised = nil;
            }
            else
                "A motor whines a little, but nothing else happens,
                so you release the lever and let it spring back to
                its center position. ";
        }
    }

    dobjFor(Push)
    {
        verify()
        {
            /* we need to be in the basket to operate the lever */
            if (!gActor.isIn(location))
                illogicalNow('You need to be in the basket to operate
                    the controls. ');
        }
        action()
        {
            if (cherryPickerBasket.isRaised)
                "A motor whines a little, but nothing else happens.
                You release the lever and let it spring back to its
                center position. ";
            else
            {
                "You push the lever all the way forward, and a whining
                electric motor slowly raises the basket until the boom
                is fully extended.  You release the lever, and it
                springs back to the center position. ";

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
        reportFailure('You\'ll have to lower the basket first. ');
        exit;
    }
;


/* ------------------------------------------------------------------------ */
/*
 *   Quad
 */
quad: CampusOutdoorRoom
    'Quad' 'the Quad' 'Quad'
    "This open lawn area is known as the Quad, for its rectangular
    shape.  Several walkways meet here: the Olive Walk leads east and
    west, the Orange Walk leads down a few steps to the south, and
    another walkway leads north.  To the northwest is the campus
    bookstore.  The two main student house complexes lie a short distance
    to the east: the North Houses on the north side of the Olive Walk,
    and the older South Houses on the south side. "

    vocabWords = 'quad'

    north = quadNorthWalk
    east = quadEastWalk
    west = quadWestWalk
    south = quadSouthWalk
    down = quadManhole
    northwest = bookstore
    in asExit(northwest)
;

+ CampusMapEntry '(campus) (caltech) bookstore' 'the bookstore' 'southeast';
+ CampusMapEntry 'winnett center' 'Winnett Center' 'southeast';
+ CampusMapEntry 'quad' 'the Quad' 'southeast';
+ CampusMapEntry 'olive walk' 'the Olive Walk' 'southeast'
    altLocations = [westOliveWalk, oliveWalk]
;

+ Enterable ->(location.northwest)
    '(campus) (caltech) (book) bookstore/store' 'bookstore'
    "The bookstore has been given a new facade since you were here
    last, in the same Mediterranean style as many of the other
    nearby buildings.  The entrance is to the northwest. "
;

+ Decoration 'lawn/grass' 'grass'
    "It's fairly ordinary grass. "
;

+ quadNorthWalk: PathPassage 'paved north n walkway/path' 'north walkway'
    "It's a paved walkway leading north. "
;
+ quadSouthWalk: PathPassage -> orwNorthWalk
    '(brick) orange south s stair/stairs/step/steps/walk/walkway/path'
    'Orange Walk'
    "The Orange Walk lies down a few steps to the south. "

    dobjFor(ClimbDown) asDobjFor(Enter)
    dobjFor(Climb) asDobjFor(Enter)

    canTravelerPass(trav) { return trav != cherryPicker; }
    explainTravelBarrier(trav)
        { "There's no way to get the cherry picker down the stairs. "; }
;
+ quadEastWalk: PathPassage ->olwWestWalk
    '(brick) east e olive walk/walkway/path' 'east walkway'
    "The brick walkway leads east. "
;
+ quadWestWalk: PathPassage
    '(brick) west w olive walk/walkway/path' 'west walkway'
    "The brick walkway leads west. "
;

+ Decoration 'red brick/bricks' 'bricks'
    "The path is paved with fairly ordinary red bricks. "
    isPlural = true
;

+ Distant 'old older new newer south north undergraduate student
    house/houses/complex' 'student houses'
    "The student houses lie a short distance to the east, down the
    Olive Walk.  The newer houses are on the north side, and the older
    houses on the south side. "
    isPlural = true
;

+ CustomImmovable
    'yellow "caution" plastic stake/stakes/tape' '<q>Caution</q> tape'
    "Plastic yellow tape, with the word <q>Caution</q> written every
    couple of feet, is strung around some stakes surrounding the
    manhole. "

    cannotTakeMsg = 'The workers would probably be cross with you
        if you did that. '

    dobjFor(Enter)
    {
        verify() { }
        action() { "At a guess, you'd say the workers taped off the area
            to keep people like you out. "; }
    }
;
+ OutOfReach, SecretFixture
    cannotReachFromOutsideMsg(dest)
    {
        gMessageParams(dest);
        return '{The dest/he} {is} on the other side of the yellow tape,
            which the workers undoubtedly put there to prevent just this
            sort of interference from passersby. ';
    }
;
++ quadAnalyzer: Thing
    'electronic netbisco 9099 network analyzer/piece/gear'
    name = (described ? 'network analyzer' : 'electronic gear')
    aName = (described ? 'a network analyzer' : 'a piece of electronic gear')
    desc = "It looks a little like the kind of oversized telephone
        you'd find on a receptionist's desk in a large office.  You
        can make out a name printed on top: it's a Netbisco 9099,
        which is a network analyzer, if you recall correctly.  You've
        used something like it before when setting up a network; it's
        useful for tasks like configuring routers. "

    /* we list these in the worker specialDesc, so don't list separately */
    isListed = nil

    dobjFor(Take)
    {
        preCond = []
        check()
        {
            "For one thing, it's behind the yellow tape, which is
            plainly meant to keep people like you out.  For another,
            the workers would undoubtedly stop you if you tried to
            take it. ";
            exit;
        }
    }
;
++ Thing 'big phone network wooden spool/spools/wire' 'spools of wire'
    "They're two-foot-diameter wooden spools wound with wire,
    which looks like some kind of phone or network wire. "

    isPlural = true

    /* we list these in the worker specialDesc, so don't list separately */
    isListed = nil
;
++ quadManhole: ThroughPassage
    'large rectangular manhole manhole/hole/shaft/opening' 'manhole'
    "It's a rectangular opening in the ground, big enough to accomodate
    a couple of people at once, with a pair of metal doors.  A shaft
    descends from the opening, and you're pretty sure it leads down to
    the steam tunnel that runs roughly under the Olive Walk. "

    specialDesc()
    {
        "Alongside the Olive Walk, a couple of workers are
        standing by an open rectangular manhole, which they've
        cordoned off with yellow <q>Caution</q> tape strung around
        some stakes in the ground.  Several big spools of wire are
        piled up next to the manhole";

        if (quadAnalyzer.isIn(location))
            ", along with <<quadAnalyzer.aName>>";

        ". ";
    }

    dobjFor(Board) asDobjFor(Enter)
    dobjFor(Climb) asDobjFor(Enter)
    dobjFor(ClimbDown) asDobjFor(Enter)

    lookInDesc = "You can't see anything from here, but you're pretty
        sure the shaft leads down to a steam tunnel. "

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
            "<q>Hey!</q> one of the workers shouts, catching
            {the projectile/him} just before {it/he} fall{s} into
            the manhole. <q>There's a guy down there working!</q> ";

            if (projectile_ == ratPuppet)
                "He looks at the toy rat and laughs, then waves
                it around the manhole opening and shouts into the
                shaft.  <q>Hey, Plisnik!  Look what I got here!</q>
                There's some angry shouting from the shaft.<.p>";

            "The worker tosses {the projectile/him} back to you.
            <q>I'm gonna pretend that was a accident,</q> he says
            to you menacingly. ";
        }

        secondTime()
        {
            "One of the workers grabs {the projectile/him} out of
            the air before {it/he} fall{s} into the shaft. ";


            if (projectile_ == ratPuppet)
                "<q>Hey, Plisnik!</q> he shouts into the tunnel.
                <q>This jerk up here thinks you're gonna be scared
                by rats falling from the sky!  Very scary---flying
                rats!  Oooh!</q> He tosses the rat back to you.
                <q>Look, would you quit it with the throwing junk
                at us?  It's dangerous!</q> ";
            else
                "<q>Hey!</q> he yells, tossing {it/him} back to you.
                <q>Knock it off with the throwing junk at us!  It's
                dangerous!</q> ";
        }
    }
;
+++ Door '(manhole) metal door/doors'
    'manhole doors'
    "The doors are sheets of metal, hinged at the edges to open
    like a barn door. "
    
    isPlural = true
    initiallyOpen = true

    dobjFor(Board) asDobjFor(Enter)
;
++ quadWorkers: Person
    'big heavy unruly workers/man/beard/beards*men' 'workers'
    "The two workers are both big, heavy men with unruly beards.
    They're wearing bright green overalls and matching hardhats. "

    isHim = true
    isPlural = true

    /* 
     *   we don't need to be mentioned in the room description, since the
     *   manhole includes us in its description 
     */
    specialDesc = ""

    /* 
     *   don't require touching for GIVE TO - all of our GIVE TO topics
     *   just amount to SHOW TO anyway, so there's no need to touch 
     */
    iobjFor(GiveTo) { preCond = (inherited - touchObj); }
;
+++ InitiallyWorn 'bright green hard overalls/hardhats/uniforms/hat/hats'
    'uniforms'
    "The workers are wearing bright green overalls and matching hardhats,
    marked <q>Network Installer Company</q> in blocky white letters.
    <.reveal NIC> "
    isPlural = true
    isListedInInventory = nil
;

+++ Unthing 'plisnik' 'plisnik'
    notHereMsg = 'Plisnin\'s down the shaft, you take it---not here. '
;

+++ InConversationState, StopEventList
    [
        '<.p>One worker pokes the other playfully with his elbow. <q>Hey,
        you know what\'s a laugh?  Plisnik\'s scared of rats.  Watch
        this.</q> He cups his hands and yells into the shaft. <q>Hey,
        Plisnik! Is that a rat?</q> There\'s some commotion from down
        in the shaft, then a lot of cursing.  The two workers chuckle and
        do a high-five.<.reveal plisnik-n-rats> ',

        '<.p>You can hear someone calling from the shaft, but you can\'t
        make out what he\'s saying.  One of the workers responds by
        handing down one of the spools of wire. ',

        '<.p><q>Hey,</q> one of the workers says to the other, <q>how
        sweet would it be to have a rat right now?</q>  He chuckles.
        <.p><q>Yeah,</q> the other says, chuckling, <q>we could drop
        it down there and watch Plisnik freak out.</q> ',

        '<.p>Someone in the shaft says something you can\'t quite
        make out.  One of the workers grumbles and grabs a spool of
        wire.  <q>What am I, a delivery service?</q> he complains,
        handing the spool down into the shaft. ',

        '<.p>One of the workers says to the other, <q>You seen them new
        self-crimping connectors?  Pretty sweet, huh?</q>  The other
        nods and grunts acknowledgment. ',

        /* 
         *   use a nil last element, so that we do nothing once we run out
         *   of items to show 
         */
        nil
    ]

    stateDesc = "Both are looking at you---not exactly expectantly; more
        like you just did something idiotic and they're wondering what
        you're going to do next. "

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
    "<q>Why's Plisnik so afraid of rats?</q> you ask.
    <.p>The workers chuckle.  One of them yells down into the
    shaft, <q>Hey, Plisnik!  I think I see another rat!</q>
    You hear some yelling coming from the shaft but you can't
    tell what's being said. "

    isActive = (gRevealed('plisnik-n-rats'))
;
+++++ AltTopic
    "<q>Why's Plisnik so afraid of rats?</q> you ask.
    <.p>The workers just look at each other and chuckle. "

    isActive = (!plisnik.inOrigLocation)
;

/* 
 *   if we TELL ABOUT PLISNIK, mention that he ran off, if he did - use an
 *   elevated score for this so we override the generic plisnik/rat topic 
 */
++++ TellTopic +110 @plisnikTopic
    "<q>Did you guys know Plisnik saw a rat and ran off?</q> you ask.
    <.p>The two roll their eyes. <q>Yep, he does that every day,</q> one
    of them says. "

    isActive = (!plisnik.inOrigLocation)
;

++++ GiveShowTopic @ratPuppet
    "You show the workers the rat. <q>Cute,</q> one of them says.
    He elbows the other guy. <q>Wouldn't it be a hoot if we had
    a <i>real</i> rat?</q> "
;

++++ AskTellShowTopic, SuggestedAskTopic @quadWorkers
    "<q>What are you fellas workin' on?</q> you ask, affecting your
    idea of a working-class diction for some reason beyond your control.
    <.p>One of the two just rolls his eyes a bit, and the other one
    slowly, elaborately looks down at his uniform and points to the
    blocky letters. <q>Network,</q> he reads, moving his finger over
    the words, <q>Installer... Company.</q> He looks up at you. <q>We're
    installing a network.</q><.convnode what-network><.reveal NIC> "

    name = 'themselves'
;
++++ AskTellTopic, SuggestedAskTopic @ddTopic
    "<q>Are you doing anything as part of Ditch Day?</q> you ask.
    <.p>They both look a little angry. <q>Do we look like ditch diggers
    to you?</q> one says. <q>We're in high tech.</q> "

    name = 'Ditch Day'
;
++++ AskTellTopic, SuggestedAskTopic @nicTopic
    "<q>I've never heard of <q>Network Installer Company</q> before,</q>
    you say. <q>What do they do?</q>
    <.p>The two give you blank stares for a long few moments, then one
    says, <q>Uh, we install networks.</q>
    <.convnode what-network>"

    name = 'Network Installer Company'
    isActive = (gRevealed('NIC'))
;

/* a couple of topics pertain to the network analyzer */
++++ TopicGroup
    isActive = (quadAnalyzer.isIn(quad) && quadAnalyzer.described)
;
+++++ AskTellShowTopic @quadAnalyzer
    "<q>Is that a Netbisco 9099?</q> you ask.
    <.p>The two glance at the network analyzer. <q>Yep,</q> one says. "
;
+++++ AskForTopic @quadAnalyzer
    "<q>Could I borrow your Netbisco 9099?</q> you ask.
    <.p><q>Uh, no,</q> one of the workers says, sounding annoyed.
    <q>Our guy down in the tunnel might need it.</q> "
;

/* a topic about the netbisco *before* we know what it is */
++++ AskTellAboutForTopic @quadAnalyzer
    "<q>What kind of equipment is that?</q> you ask, pointing to it.
    <.p>One of the workers looks at it. <q>I dunno,</q> he says.
    <q>Something we use for network installing, I guess.</q> "
    
    isActive = (quadAnalyzer.isIn(quad) && !quadAnalyzer.described)
;

/* trying to return the analyzer after we have it */
++++ GiveShowTopic @netAnalyzer
    "You think it might be a bad idea to call too much attention to the
    fact you borrowed their analyzer.  It would probably better to just
    leave it somewhere nearby and let them find it on their own. "

    isConversational = nil
;

++++ DefaultAnyTopic, ShuffledEventList
    ['The two just stare at you, chewing whatever it is they\'re chewing. ',
     'The two workers look at each other, then back at you, but neither
     one says anything. ',
     'The workers roll their eyes and say nothing. ',
     'One of the workers laughs a bit, and the other one looks at
     him, but neither one says anything. ']
;
++++ ConversationReadyState
    isInitState = true
    stateDesc = "Both workers are standing by the manhole, looking down
        into it with bored expressions, lazily chewing something. "
;
+++++ HelloTopic, StopEventList
    ['You stand close to the yellow tape and try to get the workers\'
    attention. <q>Excuse me...</q> you call to them.
    <.p>The two slowly look up from the hole, and look over at you
    as though you interrupted an important conversation. <q>Yeah?</q>
    one asks. ',
     '<q>Excuse me,</q> you say to the workers.
     <.p>The two look up from the manhole. <q>You again,</q> one
     says. ']
;
+++++ ByeTopic "The two workers go back to staring into the hole. "
;

+++ ConvNode 'what-network';
++++ SpecialTopic 'ask what kind of network'
    ['ask','what','kind','of','network']
    "You don't want to seem thin-skinned, so you force a laugh.
    <q>Yeah, but what kind of network are you working on?</q>
    <.p><q>Cables, wires, little boxes with blinking lights,</q> he
    says, miming flashing lights by flapping his fingers.
    <q>See, they just give us these work orders, and we do the
    work.</q>  He takes a piece of paper out of his pocket and
    makes a half-hearted effort to hold it out for you to see.
    You read enough to get the idea they're doing some upgrades
    for the campus network, but he puts it away before you can
    read the whole thing. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Olive Walk
 */
oliveWalk: CampusOutdoorRoom
    'East Olive Walk' 'the east Olive Walk' 'Olive Walk'
    "The Olive Walk is named for the olive trees lining both sides
    of the brick-paved walkway and arching overhead.  The walkway runs
    east and west between the two main undergraduate house complexes:
    the newer North Houses on the north side, and the older South Houses
    on the south side.  The front entrances to the houses face the walkway.
    An antique cannon sits in front of Fleming to the south. "

    vocabWords = 'east e olive walk'

    west = olwWestWalk
    east = olwEastWalk
    north: NoTravelMessage { "It would certainly be entertaining to
        go through all the houses and see the different stacks this
        year, but you should probably try to stay focused for now. " }
    south: NoTravelMessage { "Much as you'd like to survey all of the
        stacks in the other houses, you should probably try to stay
        focused on Stamer's stack. " }

    /* provide some special descriptions for the cherry picker when here */
    descCherryPickerArrival = "You steer the cherry picker to a spot
        alongside the cannon, off the main path, and park. "
    inCherryPickerSpecialDesc = "You're standing in the basket of a
        cherry picker, which is parked alongside the cannon. "
    cherryPickerSpecialDesc = "A cherry picker is parked alongside the
        cannon. "
;

+ CampusMapEntry 'south s student houses' 'the South Houses' 'southeast';
+ CampusMapEntry 'north n student houses' 'the North Houses' 'southeast';
+ CampusMapEntry 'fleming house/hovse' 'Fleming House' 'southeast';
+ CampusMapEntry 'page house' 'Page House' 'southeast';
+ CampusMapEntry 'lloyd house' 'Lloyd House' 'southeast';
+ CampusMapEntry 'ruddock house' 'Ruddock House' 'southeast';
+ CampusMapEntry 'ricketts house/hovse' 'Ricketts House' 'southeast';

+ owTrees: TreeDecoration
    '(long) olive row/rows/tree/trees/branches' 'olive trees'
    "The trees are planted in neat rows, one on each side of the walkway,
    their long, thin branches arching over the path. "
    isPlural = true
;

+ Decoration 'red path/brick/bricks' 'bricks'
    "The path is paved with fairly ordinary red bricks.  It continues
    east and west. "
    isPlural = true
;

+ olwWestWalk: PathPassage '(brick) west w walkway/path' 'west walkway'
    "The walkway continues to the west. "
;

+ olwEastWalk: PathPassage ->alWestWalk
    '(brick) east e walkway/path' 'east walkway'
    "The walkway continues to the east. "
;

+ Fixture, Chair, ComplexContainer
    'antique (fleming) (house) cannon' 'cannon'
    "It's the Fleming House cannon, an actual piece of nineteenth-century
    artillery.  The barrel is at least twelve feet long, and it rides on
    a pair of big wagon wheels; the carriage is painted the official
    Fleming House bright red.  It's been a fixture here since
    before your time, and you don't remember the whole story behind it;
    distant ancestors of modern Flems absconded with it as part of a
    rivalry with another local college, or something like that. "

    cannotMoveMsg = 'The cannon is much too heavy to move on your own. '

    /* if they just say 'down', translate to 'get off' what we're on */
    down = noTravelDown

    /* the barrel is our container */
    subContainer: Occluder, Component, RestrictedContainer
    {
        '(cannon) barrel/end' 'barrel of the cannon'

        desc()
        {
            "It's twelve feet long or so.  The barrel tilts up; ";
            if (isBarrelAccessible(getPOV()))
                "the end is easily reachable from here. ";
            else if (getPOV().isIn(location))
                "even sitting on the cannon, it's still a long
                way to the end of the barrel. ";
            else
                "the end is well overhead. ";
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

        /* explain why we can't look in from the ground */
        dobjFor(LookIn)
        {
            check()
            {
                checkBarrelAccess(
                    gActor.isIn(location)
                    ? 'From your perch on the cannon, the barrel extends
                      another six or eight feet; there\'s no way to
                      see into it from here. '
                    : 'The barrel tilts up, and its open end is well
                      overhead, so there\'s no way to see inside it
                      from here. ');
            }
        }

        iobjFor(PutIn)
        {
            check()
            {
                /* first, check that the barrel is accessible at all */
                checkBarrelAccess(
                    gActor.isIn(location)
                    ? 'From your perch on the cannon, the barrel extends
                      another six or either feet; there\'s no way to
                      reach into the end from here. '
                    : 'The end of the barrel is too high overhead to
                      reach from here. ');

                /* do the normal checks */
                inherited();
            }
        }

        /* why can't we put an object inside? */
        validContents = []
        cannotPutInMsg(obj) { return 'You probably shouldn\'t; it could
            create a safety hazard the next time the cannon is fired. '; }

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
            "It takes a little figuring out, but you manage to climb
            up onto the carriage and sit down astride the barrel. ";
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
    notTravelReadyMsg = 'You\'ll have to get off the cannon first. '
;
++ Component '(cannon) big red wagon wheel/wheels'
    'wheels of the cannon'
    "They're about five feet in diameter, and they look just like
    wagon wheels. "
    isPlural = true
;
++ Component '(cannon) counterweight/carriage' 'carriage'
    "It's mostly just a big counterweight for the barrel.
    It's painted the standard Fleming bright red. "
;

/* 
 *   this is just a joke reference to in Ditch Day Drifter - Mr. Happy
 *   Gear was one of the random scavenger-hunt items you had to obtain in
 *   that game's Ditch Day stack 
 */
++ mrHappyGear: Hidden
    'mr. happy happy-face metal machine gear/face/
    cut-out/cut-outs/pattern'
    'machine gear'
    "It's a metal gear about an inch and a half in diameter, with a
    pattern of cut-outs that makes it look a lot like a happy-face icon.
    For some reason, the name <q>Mr.\ Happy Gear</q> comes to mind. "

    subLocation = &subContainer
;

+ EntryPortal ->(location.north)
    'new newer north n undergraduate student front house page lloyd ruddock
    house/houses/complex/dorm/dorms/entrances'
    'North Houses'
    "The North Houses complex was built in the 1960s; it's a group of
    three dorms&mdash;Page, Lloyd, and Ruddock&mdash;more or less
    under one roof.  The houses are built in a 1960s-modern style,
    with simple, straight lines. "

    isPlural = true
;

+ EntryPortal ->(location.south)
    'old older south s undergraduate student house clay tile
    stucco front fleming ricketts arch/arches/roof/roofs/
    house/houses/hovses/complex/dorm/dorms/wall/walls/entrances'
    'South Houses'
    "The South Houses were built in the 1930s, and were designed in
    a Mediterranean style: arches, clay tile roofs, stucco walls,
    irregular lines, a somewhat rambling layout.  Fleming and Ricketts
    are on this side of the complex, Dabney and Blacker on the south side. "

    isPlural = true
;

+ Distant 'blacker dabney house/houses/hovse/hovses' 'Blacker and Dabney'
    "Blacker and Dabney aren't visible from here; they're on the south side
    of the group of buildings. "
    isPlural = true
    isProperName = true
    tooDistantMsg = 'Blacker and Dabney aren\'t visible from here. '
;

/* ------------------------------------------------------------------------ */
/*
 *   Ath lawn 
 */
athLawn: CampusOutdoorRoom 'Athenaeum Lawn' 'the Ath lawn' 'lawn'
    "This is a wide lawn outside the campus's faculty club, known
    as the Athenaeum: a stately, Mediterranean-style structure of
    white stucco, columns, and red roof tiles, looming to the east.
    The Ath's open-air dining room faces the lawn.  The olive walk
    ends here, and continues into the campus to the west. "

    east = athDiningRoom
    in asExit(east)
    west = alWestWalk
;
+ CampusMapEntry 'athenaeum/ath' 'the Athenaeum' 'southeast';

+ Distant, Enterable -> (location.east)
    'stately mediterranean-style dining faculty
    ath/athenaeum/structure/building/room/club'
    'Athenaeum'
    "The Ath is a sprawling stucco-and-red-tile-roof structure, which
    makes it look like a lot of SoCal movie-star mansions.  The
    open-air dining room looks out onto the lawn. "
;
++ Decoration 'white red roof tile stucco/column/columns/tile/tiles/roof'
    'architectural details'
    "The Ath has that Mediterranean style that's ubiquitous here
    on the campus. "

    isPlural = true
;

+ alWestWalk: PathPassage
    '(brick) west w olive walk/walkway/path' 'west walkway'
    "The walkway continues to the west. "
;

+ Decoration 'grass/lawn' 'lawn'
    "The lawn looks well tended. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Ath dining room 
 */
athDiningRoom: Room 'Athenaeum Dining Room' 'the Ath dining room'
    'dining room'
    "Dining tables are set up around this spacious room, which is
    open to the lawn to the west.  Huge round columns support the
    high ceiling.  A wide double door leads east. "

    vocabWords = 'spacious ath athenaeum dining room'

    west = athLawn
    east = adrDoor
    out asExit(west)
;

+ Distant, Enterable -> (location.west) 'lawn/grass' 'lawn'
    "The lawn is outside, to the west. "
;

+ adrDoor: AlwaysLockedDoor
    'wide tall wood double door/doors' 'double doors'
    "The doors are wide and tall.  They lead into the structure
    to the east. "

    isPlural = true
;

+ Decoration 'dining tables/chairs/table/chair' 'tables'
    "The tables are currently empty, since the dining room isn't
    serving a meal at the moment. "
    isPlural = true
;

+ Decoration 'huge round column/columns' 'columns'
    "The columns are holding up the roof, and lend the room a
    formal air. "
    isPlural = true
;

/* ------------------------------------------------------------------------ */
/*
 *   California Blvd is visible from several locations, so make it a
 *   class.  We'd normally use MultiFaceted for this kind of situation,
 *   but in this case it's easier to make it a class, because we want to
 *   point room directional connectors to it.  
 */
class CalBlvd: PathPassage
    'california boulevard/blvd/blvd./street/road'
    'California Boulevard'
    "California Boulevard is a busy four-lane street that forms
    the south border of the campus. "

    isProperName = true

    dobjFor(TravelVia)
    {
        action() { reportFailure('You shouldn\'t go wandering off
            campus until you\'ve finished your business here. '); }
    }

    dobjFor(Cross) remapTo(TravelVia, self)
;
class CalBlvdTraffic: Distant
    'traffic/car/cars/auto/automobile' 'traffic'
    "The traffic is fairly heavy, but moving steadily. "
;
class CalBlvdNoise: SimpleNoise
    desc = "Constant traffic zips by on California Boulevard. "
;


/* ------------------------------------------------------------------------ */
/*
 *   Orange walk 
 */
orangeWalk: CampusOutdoorRoom 'Orange Walk' 'the Orange Walk' 'Orange Walk'
    "This north-south walkway is named for the orange trees planted
    alongside.  A few steps ascend to the north.  To the south, the
    walkway ends at California Boulevard, which forms the southern
    limit of the campus.  An unpaved path through the orange trees
    leads west.  To the east, a passage leads into Dabney Hovse. "

    vocabWords = 'orange walk/walkway'

    north = orwNorthWalk
    up asExit(north)
    south = orwCalBlvd
    east = dabneyBreezeway
    in asExit(east)
    west = orwWestPath

    atmosphereList = (owMovers.isIn(self) ? moversAtmosphereList : nil)
;

+ CampusMapEntry 'orange walk' 'the Orange Walk' 'southeast';
+ CampusMapEntry 'dabney house/hovse' 'Dabney House' 'southeast'
    altLocations = [dabneyCourtyard]

    /* this is the most important "dabney" and "house" we might seek */
    mapMatchStrength = 200
;

+ Decoration
    'metal (path) lighting (light) clear
    fixture/fixtures/light/lights/post/posts/enclosures'
    'path lights'
    "The path lights are simple metal posts with light bulbs
    inside clear enclosures near the top.  They're arranged every
    few feet alongside the path. "
    isPlural = true
;
++ Decoration '(path) light bulb/bulbs' 'path light bulbs'
    "You are too much a child of your era to find light bulbs
    especially noteworthy.  While it is no doubt a scientific
    and technological marvel to coax photons from excited
    electrons returning to their ground states in a low-pressure
    capsule of sodium vapor, you are all too quick to conclude
    that these look like ordinary light bulbs to you. "
;

+ orwNorthWalk: PathPassage
    'north n paved path/step/steps/stair/stairs' 'steps'
    "The walkway ascends a few steps to the north. "
    isPlural = true

    dobjFor(ClimbUp) asDobjFor(Enter)
    dobjFor(Climb) asDobjFor(Enter)
;

+ TreeDecoration 'large dense orange tree/trees/foliage' 'orange trees'
    "They're large trees with dense foliage and lots of oranges. "
    isPlural = true

    lookInDesc = "Apart from the oranges, you see nothing in the trees. "
;
++ OrangeDecoration;

+ EntryPortal ->(location.east)
    'faux decorative letters/passage/stonework' 'passage'
    "It's a generously proportioned passage leading east.  The passage
    is framed in decorative faux stonework, and the words <q>DABNEY HOVSE</q>
    are inscribed above it.  (The letters are styled to look like
    they're chiseled in stone, but they're actually just stamped in
    the stucco.) "
;

+ Enterable ->(location.east)
    'big stucco dabney building/house/hovse/word/words' 'Dabney House'
    "It's a big stucco building designed to resemble classic
    Mediterranean architecture.  The words <q>DABNEY HOVSE</q> are
    inscribed above the passage to the east. "

    isProperName = true
;

+ orwWestPath: PathPassage ->syncEastPath
    'west w unpaved dirt path' 'unpaved path'
    "The dirt path leads west through the orange trees. "
;

+ owMovers: MitaMovers
    "A seemingly endless stream of movers is coming up from California
    Boulevard and heading into Dabney, carrying boxes and crates.  Others
    are returning from Dabney empty-handed, probably on their way to pick
    up the next load. "

    "Mitachron movers are working their way up from California Boulevard
    and into Dabney, carrying loads of boxes and crates. "
;

/* add our California Blvd instance, and its constituent parts */
+ orwCalBlvd: CalBlvd;
++ CalBlvdTraffic;
+++ CalBlvdNoise;

/* ------------------------------------------------------------------------ */
/*
 *   Sync lot 
 */
syncLot: CampusOutdoorRoom 'Sync Lot' 'the Sync lot' 'parking lot'
    "This narrow parking lot has room for only four or five cars;
    the ones parked here today look like they haven't been moved
    in a while.  The gray bulk of the Synchrotron Lab looms to the
    west, featureless but for a dull metal door, and the back side
    of Firestone rises to the north.  A row of orange trees borders
    the parking lot to the east; a dirt path leads through the
    trees.  To the south is California Boulevard. "

    vocabWords = '(sync) (synchrotron) parking lot'

    west = syncDoor
    east = syncEastPath
    south = syncCalBlvd
;

+ CampusMapEntry 'synchrotron sync synch lab/laboratory'
    'the Synchrotron Laboratory' 'southeast';

+ syncEastPath: PathPassage 'east e unpaved dirt path' 'dirt path'
    "The path leads east through a row of orange trees. "
;

+ TreeDecoration 'large dense orange tree/trees/foliage' 'orange trees'
    "They're large trees with dense foliage and lots of oranges. "
    isPlural = true

    lookInDesc = "Apart from the oranges, you see nothing in the trees. "
;
++ OrangeDecoration;

+ Decoration 'older parked car/cars/auto/autos/automobiles' 'cars'
    "Five cars are squeezed into the lot today.  They're mostly older
    models, and they look like they haven't been moved in a while. "
    isPlural = true
    notImportantMsg = 'You shouldn\'t mess with other people\'s cars. '
;

+ syncDoor: LockableWithKey, Door
    'dull metal (sync) (synchrotron) (lab) (laboratory) door'
    'dull metal door'
    "The door is made of a dull metal. "
;

+ Immovable
    'two-story gray sync synchrotron lab laboratory building/bulk/wall'
    'Sync Lab'
    "The only feature of the two-story gray building is a dull
    metal door.  The Sync Lab is so named because it housed a
    synchrotron particle accelerator back in the 1960s, but that
    has long since been dismantled. "

    dobjFor(Enter) remapTo(Enter, syncDoor)
;
+ Immovable
    'three-story firestone lab laboratory back building/wall/side/backside'
    'back side of Firestone'
    "This side of Firestone is just just a featureless three-story wall. "

    dobjFor(Enter) { verify() { illogical('There is no entrance to
        Firestone here. '); } }
;
 
/* add our California Blvd instance, and its constituent parts */
+ syncCalBlvd: CalBlvd;
++ CalBlvdTraffic
    /* this is even less likely than the parked cars decoration for EXAMINE */
    dobjFor(Examine) { verify() { logicalRank(50, 'x decoration'); } }
;
+++ CalBlvdNoise;

/* ------------------------------------------------------------------------ */
/*
 *   West olive walk
 */
westOliveWalk: CampusOutdoorRoom 'West Olive Walk' 'the west Olive Walk'
    'Olive Walk'
    "The olive walk runs east and west here through a broad lawn
    flanked by academic buildings.  On the north side is the beige,
    rectilinear expanse of Thomas.  Firestone, to the southeast,
    and Guggenheim, to the southwest, are joined together by a
    second-story bridge over the wide gap between them; a paved
    walkway leads south under the bridge. "

    vocabWords = 'west w olive walk'

    east = wowEastWalk
    west = wowWestWalk
    south = wowSouthWalk
    north = wowThomasDoor

    southeast = firestoneDoor
    southwest = guggenheimDoor

    /* 
     *   After we've climbed firestone once, allow climbing again by
     *   simply saying 'up'.  If we haven't climbed firestone at least
     *   once already, or we're not positioned to do so currently, use the
     *   inherited 'up' instead.  
     */
    up = (gActor.isIn(cherryPickerBasket)
          && cherryPickerBasket.isRaised
          && gActor.hasSeen(climbingFirestone)
          ? wowFirestoneLattice : inherited)

    /* provide special descriptions for the cherry picker when it's here */
    descCherryPickerArrival = "You steer the cherry picker to a spot
        off the path, right next to the wall of Firestone, and park. "
    inCherryPickerSpecialDesc = "You're standing in the basket of a
        cherry picker, which is parked next to Firestone.
        <<cherryPickerBasket.isRaised
          ? "The bottom of the latticework grill is within arm's
            reach of the basket." : "">> "
    cherryPickerSpecialDesc = "A cherry picker is parked next to
        Firestone. "
    noteCherryPickerRaised = "<.p>The latticework grill facing Firestone
        is now within arm's reach. "
;

+ CampusMapEntry 'firestone lab/laboratory' 'Firestone Laboratory' 'south';
+ CampusMapEntry 'guggenheim lab/laboratory' 'Guggenheim Laboratory' 'south';
+ CampusMapEntry 'thomas lab/laboratory' 'Thomas Laboratory' 'south';

+ Decoration 'red path/brick/bricks' 'bricks'
    "The path is paved with fairly ordinary red bricks.  It continues
    east and west. "
    isPlural = true
;

+ firestoneDoor: AlwaysLockedDoor
    'front white metal (firestone) (firestone)/door*doors'
    'door of Firestone'
    "The front door of Firestone is just a simple metal door painted white. "
    cannotOpenLockedMsg = 'The door seems to be locked.  Security must
        not have bothered to unlock the building today, knowing that
        most classes would be canceled for Ditch Day. '
;

+ guggenheimDoor: AlwaysLockedDoor
    'front wood (guggenheim) (guggenheim)/door*doors' 'door of Guggenheim'
    "It's a simple wood door. "
    cannotOpenLockedMsg = 'The door seems to be locked.  It\'s strange
        for campus buildings to be locked during the day, but the usual
        routines don\'t always apply on Ditch Day. '
;

+ wowWestWalk: PathPassage '(brick) west w path/walkway' 'west walkway'
    "The walkway leads west. "
;

+ wowEastWalk: PathPassage ->quadWestWalk
    '(brick) east e path/walkway' 'east walkway'
    "The walkway leads east. "
;

+ wowSouthWalk: PathPassage ->ldcNorthWalk
    'south s walk/walkway' 'south walkway'
    "The walkway leads south, under the second-story bridge. "
;

+ TreeDecoration 'olive tree/trees/branches' 'olive trees'
    "The olive trees here are planted randomly around the lawn. "
    isPlural = true
;

+ Decoration 'wide grass/lawn' 'lawn'
    "The wide lawn is punctuated here and there by olive trees. "
;

+ Enterable ->(location.southeast)
    'firestone flight sciences lab/laboratory/wall/building*buildings*walls'
    'Firestone Lab'
    "Firestone is the flight sciences lab.  The building is
    three stories tall, and faced with a series of lattice-work
    grills. The door is the southeast. "

    isProperName = true

    dobjFor(Climb) remapTo(Climb, wowFirestoneLattice)
    dobjFor(ClimbUp) remapTo(Climb, wowFirestoneLattice)
;
++ wowFirestoneLattice: OutOfReach, TravelWithMessage, StairwayUp ->cfDown
    '(firestone) asterisk lattice-work
    x\'s/plus-signs/shapes/grill/grills/series/lattice/lattices/columns'
    'lattice'
    "The grills don't cover the entire face of the building but
    are spaced out in columns, each one starting at the second floor and
    continuing up to the roofline. Each lattice column is a grid of little
    asterisk shapes, X's superimposed on plus-signs&mdash;sized
    perfectly as hand-holds for climbing.  Security frowns vigorously
    upon anyone climbing the building, but it's too tempting a target,
    and it seems like every year someone takes up the challenge.
    Of course, this isn't trivial, as the bottom of each lattice is
    well overhead. "

    /* we can reach this only from the raised cherry picker basket */
    canObjReachContents(obj)
    {
        /* 
         *   'obj' must be in the cherry picker, and the basket must be
         *   raised; otherwise, we can't reach the building 
         */
        return obj.isIn(cherryPickerBasket) && cherryPickerBasket.isRaised;
    }

    /* explain that it's out of reach - from the ground, at least */
    cannotReachFromOutsideMsg(dest) { return 'The lattice starts at the
        second floor.  You can\'t reach it from the ground. '; }

    /* 
     *   this object is reachable from the raised cherry picker, and ONLY
     *   from the raised cherry picker 
     */
    isRaisedCherryPickerReachable = true

    /* to climb this way, we have to start in the cherry picker basket */
    connectorStagingLocation = cherryPickerBasket

    /* apply some special preconditions */
    connectorTravelPreCond()
    {
        local lst;
        
        /* get the inherited list */
        lst = inherited();

        /* in addition, our hands must be empty */
        lst += handsEmpty;

        /* 
         *   Remove the staging location precondition.  Our staging
         *   location is important, but we don't need or want a
         *   precondition for it.  We don't need the precondition because
         *   the fact that the lattice is out of reach is enough to prevent
         *   climbing the lattice until we're in the raised cherry picker.
         *   We don't want the precondition because we want to leave it to
         *   the player to figure out what to do - we don't want to make
         *   this automatic. 
         */
        lst = lst.subset({x: !x.ofKind(TravelerDirectlyInRoom)});

        /* return the result */
        return lst;
    }

    /* add a message on traversal */
    travelDesc { travelDescScript.doScript(); }
    travelDescScript: StopEventList { [
        'You carefully climb up onto the edge of the basket
        and reach out for the Firestone grill.  The pattern of
        the latticework offers surprisingly easy handholds.
        You feel you have a secure grip on the wall, so you
        take one foot off the basket and search for a toehold.
        No problem so far.  You take a deep breath and commit
        yourself, taking your other foot off the basket, shifting
        your full weight to the wall.
        <.p>You don\'t immediately fall, so you try moving
        up the wall a few inches.  It\'s actually pretty easy;
        almost like climbing a ladder.  You move up a few feet,
        getting the hang of it. ',
        
        'You reach out for the wall and find a handhold, then
        shift your feet over.  You climb up the wall a few feet. '] }

    /* "get on grill" is the same as climbing it */
    dobjFor(Board) remapTo(Climb, self)
;

+ Enterable ->(location.southwest)
    'guggenheim aeronautics lab/laboratory/wall/building*buildings*walls'
    'Guggenheim Lab'
    "Guggenheim is an aeronautics lab.  It's a three-story
    building with large windows framed in wrought iron.  From here,
    you can just get a glimpse of the wind tunnel structure on the
    roof of the building.  The entrance is to the southwest. "

    isProperName = true
;

++ wowWindTunnel: Distant 'wind tunnel structure' 'wind tunnel'
    "You can just barely see the long, low structure on the roof
    of Guggenheim.  You can't make out any detail from here. "
;

++ Distant 'wrought iron frame/frames/window/windows/(guggenheim)'
    'windows of Guggenheim'
    "The windows are large, many-paned windows in wrought iron frames. "
    owner = (location)
;

+ Enterable ->(location.north)
    'beige rectilinear thomas civil mechanical engineering
    lab/laboratory/expanse/wall/building*buildings*labs'
    'Thomas Lab'
    "Thomas is the civil and mechanical engineering building.  It's
    a large building with what you've always thought is a rather
    spartan appearance: it's essentially a big rectangular box,
    three stories high, with a regular grid of small windows trimmed
    in rectangular grids of wrought iron.  A door in the center of
    the structure leads inside. "

    isProperName = true
;
++ wowThomasDoor: Door
    'wide double (thomas) door/(thomas)/(lab)/(laboratory)*doors'
    'door to Thomas'
    "It's a wide double door, but the bulk of Thomas makes it look
    miniature. "
;

++ Distant
    'wrought iron window/windows/grid/pane/panes/frame/frames/(thomas)'
    'windows of Thomas'
    "The windows are arranged in a regular grid, and each window
    is itself a grid of panes in a wrought iron frame. "
    isPlural = true
    owner = (location)
;

+ Distant 'second-story story bridge' 'second-story bridge'
    "The bridge is decorated with the same lattice-work facing
    as Firestone.  It connects Firestone and Guggenheim on their
    second floors.  A walkway leads south under the bridge. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Climbing on the Firestone grill 
 */
climbingFirestone: Floorless, CampusOutdoorRoom
    'Climbing Firestone' 'halfway up the side of Firstone'
    "This point is about halfway up the side of Firestone.  The
    latticework grill facing the building is relatively easy to
    climb; it extends above to the roof, and below to about one
    story above ground level. "

    up = cfUp
    down = cfDown

    roomBeforeAction()
    {
        /* don't allow taking or dropping anything here */
        if (gActionIs(Take) || gActionIs(TakeFrom)
            || gActionIs(Doff) || gActionIs(Drop))
        {
            "Your hands are already fully occupied holding onto
            the side of the building. ";
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
    'front north latticework firestone
    grill/building/lab/laboratory/wall/firestone'
    'wall of Firestone'
    "The asterisk-shaped pattern of the grill is relatively easy
    to hang onto.  The latticework continues up to the roof, but
    ends below at about one story above ground level. "

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
    travelDesc = "You work your way up to the top of the wall.  Once
        you're at the top, you roll yourself over the edge and onto
        the roof. "

    /* we're for internal use only, so hide from 'all' */
    hideFromAll(action) { return true; }
;
    

/* an internal connector leading down to ground level */
+ cfDown: TravelWithMessage, StairwayDown
    travelDesc = "You carefully climb down the grill until you're level
        with the basket, then ease yourself into the basket. "

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
    explainTravelBarrier(trav) { "The grill ends about one story up,
        so you can\'t climb down far enough to safely jump to the
        ground. "; }
;

+ Distant 'olive ground/walk/walkway/lawn' 'ground'
    "The ground is about two stories below. "
;

+ Distant 'thomas lab/building' 'Thomas Lab'
    "Thomas is across the lawn, a distance to the north. "
    isProperName = true
;

/* a local proxy for the cherry picker */
+ cfCherryPicker: PresentLater, Distant
    'cherry picker' 'cherry picker'
    desc()
    {
        "The cherry picker is directly below. ";
        if (cherryPickerBasket.isRaised)
            "Its basket is raised to full height,
            so it shouldn't be too hard to climb into it from here. ";
        else
            "The basket is lowered, though, so there's no way you
            could climb into it from here. ";
    }
    specialDesc = "The cherry picker is parked next to the building,
        almost directly below. "

    /* we can enter it without touching it */
    dobjFor(Enter) remapTo(TravelVia, cfDown)
    dobjFor(Board) asDobjFor(Enter)
    dobjFor(StandOn) asDobjFor(Enter)
;
++ Distant
    '(cherry) (picker) basket' 'basket of the cherry picker'
    desc()
    {
        if (cherryPickerBasket.isRaised)
            "The basket is raised up to full height, putting it at
            about second-floor level.  It shouldn't be too hard to
            climb into it from here. ";
        else
            "The basket is lowered, so there's no way you could climb
            into it from here. ";
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
    cannotUseMapHere = "You'll have to get down to the ground before
        you can go there, of course. "

    /* don't use the standard ground; we'll use a special 'roof' instead */
    roomParts = static (inherited - defaultGround)

    roomBeforeAction()
    {
        if (gActionIn(Jump, JumpOffI))
        {
            "It's too far to the ground to jump. ";
            exit;
        }
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   Roof of Firestone 
 */
firestoneRoof: RoofRoom 'Roof of Firestone' 'the roof of Firestone' 'roof'
    "A knee-level lip runs around the perimeter of this flat,
    tar-coated roof, providing a modicum of protection against
    walking off the edge.  Numerous vents, pipes, and other fixtures
    protrude at random spots.
    <.p>The roof narrows and continues west, over the bridge
    connecting Firestone and Guggenheim.  The latticework grill
    facing the north side of the building comes up to the roofline,
    so it should be possible to climb down that way.  At the southeast
    corner, a ladder leads down the south wall. "

    vocabWords = 'firestone lab/laboratory/building/(roof)'

    north = frGrill
    west = guggenheimRoof
    southeast = frLadder

    /* 'down' is ambiguous, so ask what they intend to climb down */
    down: AskConnector {
        travelAction = ClimbDownAction
        askMissingObject(actor, action, which)
        {
            "Do you want to climb down the ladder, or the front wall
            of Firestone? ";
        }
    }

    /* 'climb down firestone' == 'climb down grill' */
    dobjFor(Climb) remapTo(TravelVia, frGrill)
    dobjFor(ClimbDown) remapTo(TravelVia, frGrill)
;

+ Floor 'flat tar tar-coated roof/floor' 'roof'
    "It's a flat, tar-coated roof. "
    dobjFor(JumpOff) remapTo(Jump)
;

+ Decoration 'knee-level lip/(roof)' 'lip of roof'
    "The lip is about two feet high, and runs around the perimeter
    of the roof.  It's probably meant more to block water run-off
    than to protect climbers. "
    dobjFor(JumpOff) remapTo(Jump)
;

+ Decoration 'vent/vents/pipe/pipes/fixtures' 'fixtures'
    "The protrusions would make it dangerous to walk around up here
    at night, but they're easy enough to avoid in the daylight. "
    isPlural = true
;

+ Distant, Decoration
    'guggenheim (roof)/(lab)/(laboratory)/(building)' 'Guggenheim'
    "Guggenheim is the next building west, but the roof is connected
    via the bridge. "
;

+ Enterable ->(location.west) '(roof) bridge' 'bridge'
    "From here, the bridge is simply a slightly narrower section of
    roof leading west. "
;

+ Distant, Decoration 'ground' 'ground/walkway'
    "The ground is three stories below. "
;
+ Distant, Decoration 'cherry picker basket' 'cherry picker'
    "The cherry picker is too close to the wall and too far
    below to get a good look from here. "
;

+ frGrill: TravelWithMessage, StairwayDown
    'north n front latticework grill/wall/side/(building)/(firestone)'
    'latticework grill'
    "The building is faced with a latticework grill, whose
    asterisk-shaped openings make nice handholds for climbing. "

    travelDesc = "You back up to the north edge of the roof and
        lie down on the lip, then lower your legs over the edge.
        You find a toehold and start working your way down the wall. "

    /* hands must be empty to climb down the building */
    connectorTravelPreCond = (inherited() + handsEmpty)
;

+ frLadder: StairwayDown 'metal ladder' 'ladder'
    "The metal ladder is permanently attached at the southwest
    corner of the roof.  It leads over the edge of the roof, down
    the south side of the building. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Guggenheim roof 
 */
guggenheimRoof: RoofRoom
    'Roof of Guggenheim' 'the roof of Guggenheim' 'roof'
    "The whole south side of the roof is dominated by the Guggenheim
    wind tunnel: a long, low steel structure, resembling an
    extremely elongated storage shed. <<grPanel.roomDesc>>  The
    roof continues east, narrowing over the bridge connecting
    Guggenheim to Firestone. "

    vocabWords = 'guggenheim lab/laboratory/building/(roof)'

    east = firestoneRoof
    south: NoTravelMessage { "There's no obvious entrance to the
        structure here.  Which isn't surprising: you'd expect the
        wind tunnel scientists to enter from inside Guggenheim, not
        by scaling the exterior walls. " }
    down: NoTravelMessage { "The face of Guggenheim is not as
        climber-friendly as Firestone, so there's no obvious
        way down from here. " }
;

+ Floor 'flat tar tar-coated roof/floor' 'roof'
    "It's a flat, tar-coated roof. "
    dobjFor(JumpOff) remapTo(Jump)
;

+ Distant, Decoration 'ground' 'ground/walkway'
    "The ground is three stories below. "
;

+ Distant, Decoration
    'firestone (roof)/(lab)/(laboratory)/(building)' 'Firestone'
    "Firestone is the next building east, but the roof connects
    via the bridge. "
;

+ Enterable ->(location.east) '(roof) bridge' 'bridge'
    "From here, the bridge is simply a slightly narrower section of
    roof leading east. "
;

+ Enterable ->(location.south)
    'long low steel (guggenheim) wind structure/tunnel/wall'
    'wind tunnel'
    "The structure runs the full east-west extent of Guggenheim, but
    it's low and narrow.  A complex network of pipes and conduits
    runs along the walls of the structure, turning and twisting
    around one another.  A group of pipes makes right-angle turns
    around <<grPanel.aName>> low on the wall. "
;
++ Fixture 'complex metal electrical pipe/pipes/conduits/network' 'pipes'
    "Metal pipes are arrayed along the wall, mostly running
    horizontally but frequently turning to make room for
    other pipes, or to enter the structure, or to plunge down
    through the roof.  Electrical conduits are mixed in with
    the pipes. "
    isPlural = true
;
++ grPanel: TravelWithMessage, Door ->wtPassage
    'access small low panel/door/passage' 'small panel'
    "The panel looks to be a small door, about a meter square,
    near the bottom of the wall.  It's probably an access door
    for mechanical work on the tunnel apparatus. "

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
            "Opening the panel reveals a passage that seems to
            lead inside the structure. ";
        }

        /* change the name to passage or panel, according to our status */
        name = (stat ? 'access door' : 'small panel');
    }

    travelDesc = "You get down on all fours and crawl through the
        passage. "

    roomDesc()
    {
        if (openedBefore)
            "A small, low door leads into the structure. ";
    }

    /* have we been opened before? */
    openedBefore = nil
;

/* ------------------------------------------------------------------------ */
/*
 *   Wind tunnel interior 
 */
windTunnel: Room 'Wind Tunnel Lab' 'the wind tunnel lab'
    "This is a long, low, narrow space, crammed with equipment.  It
    doesn't seem to be the sort of wind tunnel with a gigantic fan
    at one end of a big, empty room.  Instead, the <q>tunnel</q>
    looks more like a cement mixer: a bright blue metal cylinder
    about ten feet long and six feet in diameter, lying on its side.
    The cylinder is tapered to a smaller diameter at each end, where
    it's connected to stacks of heavy industrial machinery that would
    look at home in an auto plant.
    <.p>A wrought-iron spiral stairway leads down a narrow shaft.
    A low door to the north, almost hidden under pieces of equipment,
    leads outside. "

    north = wtPassage
    out asExit(north)
    down = wtStairs
;

+ wtPassage: TravelWithMessage, Door
    'small low passage/door' 'low door'
    "It's a small door, only about three feet high, leading
    out of the structure to the north. "

    travelDesc = "You get on your hands and knees and crawl out
        through the passage. "
;

+ wtStairs: StairwayDown ->wtsStairs
    'black wrought-iron spiral narrow stairs/staircase/stairway/shaft'
    'spiral stairs'
    "The narrow spiral stairs lead down a shaft. "
    isPlural = true
;

+ Decoration
    'heavy industrial measuring imaging
    piece/pieces/equipment/machinery/plumbing/compressors/pumps/apparatus'
    'equipment'
    "A lot of the equipment, especially the industrial-looking
    machinery, seems to be plumbing for the wind tunnel, probably
    compressors and pumps and the like.  Other equipment is clearly
    imaging and measuring apparatus. "

    isMassNoun = true

    notImportantMsg = 'The wind tunnel is undoubtedly both delicate
        and powerful, so you could probably do a lot of damage if you
        started fooling around with it. '

    dobjFor(LookUnder) { action() { "A low door leading north is
        partially hidden under some of the equipment stacked
        along the wall.  Other than that, you see nothing
        apart from more machinery. "; } }
;

+ ComplexContainer, Fixture
    'bright blue metal wind cement tunnel/cylinder/mixer'
    'metal cylinder'
    "The cylinder appears to be the main part of the wind tunnel.
    It's lying on its side; it's about ten feet long and six feet
    in diameter, so it almost fills the short floor-to-ceiling
    distance of the room.  The cylinder tapers at each end to
    a smaller diameter.  Many pieces of equipment attach to
    the cylinder at each end.  A round, steel hatch, about two
    feet in diameter, provides access to the interior; it's
    currently <<subContainer.openDesc>>. "

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

++ ContainerDoor 'round steel metal hatch' 'hatch'
    "It's a round metal hatch, about two feet in diameter. "
;

++ squirrel: TurboPowerAnimal
    'turbo power sqirrel action figure/squirrel' 'squirrel action figure'
    "It's half robot, half plush animal toy, vaguely resembling a
    squirrel.  <q>Turbo Power Squirrel!</q> is emblazoned on the
    front. "
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
windTunnelShaft: Room 'Bottom of Stairs' 'the bottom of the stairs'
    'narrow shaft'
    "This is the bottom of a narrow shaft housing a wrought-iron
    spiral stairway.  An old wooden door leads south. "
    
    vocabWords = 'narrow shaft/bottom/(stairs)/(stairway)/(staircase)'

    up = wtsStairs
    south = wtsDoor

    /* we have no ceiling, since we're the bottom of a shaft */
    roomParts = static (inherited - defaultCeiling)
;

+ wtsStairs: StairwayUp
    'black wrought-iron spiral narrow stairs/staircase/stairway'
    'spiral stairway'
    "The narrow black stairway ascends the shaft. "
;

+ wtsDoor: AlwaysLockedDoor 'old dark wood wooden door' 'wooden door'
    "The door is made of a dark wood, and looks old and worn. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Thomas Lobby 
 */
thomasLobby: Room 'Thomas Lobby' 'the Thomas lobby' 'lobby'
    "This wide, high-ceilinged entryway is paneled in dark wood,
    making it feel a little gloomy.  Doors lead off the lobby
    to the east and west, and a wide double door leads outside
    to the south.
    <.p>A hand-written sign taped to the east doorway reads
    <q>Robotics Competition,</q> with an arrow pointing east. "

    vocabWords = 'thomas lobby/thomas'

    south = tlSouthDoor
    out asExit(south)
    east = tlEastDoor
    west = tlWestDoor
;

+ Decoration
    'shiny dark wood varnished
    varnish/finish/wood/panel/panels/paneling/panelling'
    'dark wood'
    "Despite the shiny varnished finish, the wood is so dark, and
    there's so much of it, that it gives the room a gloomy look. "
;

+ tlSouthDoor: Door ->wowThomasDoor 'wide double door*doors' 'double door'
    "The wide double door leads south, outside. "
;

+ Fixture, Readable 'hand-written sign' 'sign'
    "The sign reads <q>Robotics Competition,</q> written above
    an arrow pointing into the room to the east. "
    cannotTakeMsg = 'You have no reason to take the sign down. '
;

+ tlEastDoor: Door -> teWestDoor 'east e door/doorway*doors' 'east door'
    "The door leads into a room to the east.  A sign taped to the
    door reads <q>Robotics Competition,</q> with an arrow pointing
    into the room. "
;

+ tlWestDoor: Door -> twEastDoor 'west w door/doorway*doors' 'west door'
    "The door leads west. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Thomas west classroom 
 */
thomasWest: Room 'Classroom' 'the classroom'
    "This is a good-sized classroom, with about a dozen rows of
    built-in wooden chairs facing a wide blackboard.  A door
    leads out to the east. "

    vocabWords = 'classroom/room'

    east = twEastDoor
    out asExit(east)
;

+ twEastDoor: Door 'east e door/doorway' 'east door'
    "The door leads out to the east. "
;

+ Fixture, Chair 'wooden row/rows/chair/chairs/seat/seats' 'wooden chairs'
    "The chairs are all fixed in place, arranged into about
    a dozen rows. "
    isPlural = true

    dobjFor(SitOn) { action() { "There's not much point when
        there's no lecture going on. "; } }
;

+ Fixture, Readable 'wide blackboard' 'blackboard'
    "The blackboard is the width of the room.  It has a few
    unintelligible scribbles, partially erased, from a recent
    lecture. "
;
++ Fixture, Readable 'unintelligible scribbles/writing'
    'scribbles on blackboard'
    "There's nothing you can make out; most of the writing has
    already been erased. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Thomas east - robotics competition room
 */
thomasEast: Room 'Robotics Lab' 'the robotics lab'
    "This is a large, open room, with a door leading out to the west.
    A miniature obstacle course fills the floor: little orange traffic
    cones, sheet metal half-cylinders serving as tunnels, wooden ramps.
    Everything is about the right scale for a Chihauhau, although given
    the sign outside, it must be for pint-sized robots. "

    vocabWords = 'robotics lab/laboratory'

    west = teWestDoor
    out asExit(west)
;

+ teWestDoor: Door 'west w door/doorway' 'west door'
    "The door leads out to the west. "
;

class ObstacleItem: CustomImmovable
    cannotTakeMsg = 'The course looks carefully laid out; you shouldn\'t
        mess it up. '

    iobjFor(PutIn)
    {
        verify() { }
        check()
        {
            if (gDobj == toyCar)
                "It would be fun to drive the car around the course,
                but you probably shouldn't; it'd be too easy to knock
                parts out of place. ";
            else
                "<<cannotTakeMsg>>";
            exit;
        }
    }
    iobjFor(PutOn) asIobjFor(PutIn)
;

+ ObstacleItem 'obstacle course' 'obstacle course'
    "The obstacle course fills most of the room.  Everything's
    in miniature, about the right scale for Chihuahuas. "

;
+ ObstacleItem 'little orange traffic cones' 'traffic cones'
    "The cones are miniature versions of what you'd see on the highway,
    about a foot high. "
    isPlural = true
;
+ ObstacleItem 'wooden ramp/ramps' 'wooden ramps'
    "There are a number of ramps, some that just turn back down at
    their apex, some with brief plateaus, others that turn a corner
    at the top. "
    isPlural = true
;
+ ObstacleItem
    'sheet metal half half-cylinder/half-cylinders/cylinder/cylinders/tunnels'
    'tunnels'
    "There are a couple of tunnels made of pieces of sheet metal
    curved into half-cylinders. "
    isPlural = true
;

/* a property for Rooms indicating that the car can't travel here */
property blockToyCar;

+ toyCar: Thing, Traveler
    'radio-controlled rc miniature scale-model toy car/toy*toys' 'toy car'

    desc()
    {
        if (ratPuppet.isIn(self))
            "The toy car is currently disguised as a rat---a plush rat
            puppet has been put over the car, leaving only the wheels
            sticking out from the bottom. ";
        else
            "It's a scale-model car about six inches long.  It's
            radio-controlled: a long wire antenna sticks up from the
            back. ";
    }

    /* when we appear in contents lists, mention when we're in disguise */
    listName = (ratPuppet.isIn(self)
                ? 'a toy car (disguised as a rat)' : 'a toy car')

    /* 
     *   Do not list my contents in listings involving me, even for direct
     *   examination.  The only thing I can contain is the plush rat, and
     *   we don't contain that in the usual way - it's more like wearing
     *   the puppet.  
     */
    contentsListedInExamine = nil

    useInitSpecialDesc = (inherited && !ratPuppet.isIn(self))
    initSpecialDesc = "A small toy car is lying on the floor at one corner
        of the obstacle course; someone must have been driving it
        around the course for fun.
        <<toyCarControl.location == location
          ? 'Next to it is a little box that must be its remote control. '
          : ''>> "

    /* on the first move, add an extra ethics message */
    moveInto(obj)
    {
        /* if this is the first purloining, rationalize it */
        if (!moved)
            extraReport('It looks like the car has just been sitting here
                for a while, so you figure it\'s probably okay to borrow
                it for the day.<.p>');

        /* do the normal work */
        inherited(obj);
    }

    iobjFor(PutOn)
    {
        verify() { logicalRank(50, 'toy car surface'); }
        check()
        {
            if (gDobj != ratPuppet)
            {
                "There's no way to balance {the dobj/him} on the toy car. ";
                exit;
            }
        }
        action()
        {
            "The plush rat's hand opening fits nicely over the
            toy car, leaving the wheels sticking out just enough
            to let it drive around. ";

            gDobj.moveInto(self);
        }
    }

    dobjFor(ThrowAt)
    {
        check()
        {
            "That would probably break the toy car. ";
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
            "(The joystick can be moved in any of the compass
            directions: MOVE JOYSTICK NORTH, for example.) ";
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
                visMsg = '. The toy car revs its engine but
                    can\'t seem to move on this surface';
                audMsg = '. You hear the toy car\'s engine rev';
            }
            else
            {
                local conn;
                local dest;
                
                /* 
                 *   most of the audible-only messages are the same, so
                 *   set a default 
                 */
                audMsg = '. You hear the car moving around nearby';
                
                /* 
                 *   The car is directly in the same room as the actor, and
                 *   travel is allowed here.  Find the exit in the
                 *   direction we're going, and check for compatibility.  
                 */
                conn = room.getTravelConnector(dir, nil);
                if (conn == nil)
                {
                    /* no connector; we just zip around the floor */
                    visMsg = ', and the toy car zips a short
                        distance ' + dir.name;
                    
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
                            visMsg = '. The toy car zips over to '
                                + conn.theName + ' and stops';
                        }
                        else
                        {
                            visMsg = '. The toy car zips a ways '
                                + dir.name + ' and stops';
                        }

                        /* we moved around within the room */
                        didLocalMove = true;
                    }
                    else
                    {
                        /* the toy car departs via the connector */
                        visMsg = '. The toy car zips out of the room
                            to the ' + dir.name;
                        audMsg = '. You hear the car moving away';

                        /* if it's a stairway down, mention that */
                        if (conn.ofKind(StairwayDown)
                            && conn.name != nil)
                        {
                            visMsg += ' and goes tumbling down '
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
                visMsg = '. The toy car zips ' + dir.name + ' and
                    falls off ' + location.theName;
                audMsg = '. You hear the toy car moving around,
                    then you hear something falling';
                
                /* move it to the surface's container's drop destination */
                moveInto(location.getDropDestination(self, nil));

                /* we moved around within the room */
                didLocalMove = true;
            }
            else if (location.ofKind(Actor))
            {
                /* just spin our wheels */
                visMsg = ', and the toy car\'s wheels spin a bit';
                audMsg = '. You hear the toy car\'s engine rev';
            }
            else
            {
                /* just move aimlessly */
                visMsg = '. The toy car moves around a bit';

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
                extraMsg = '. Nothing seems to happen; the toy car
                    must be out of range of the remote';
        }
        
        /* 
         *   Acknowlege that we moved the joystick, and show the result.
         *   If we can see the car, show the visual message; if we can't
         *   see it but can hear it, show the aural message; otherwise
         *   don't even mention the car.  
         */
        "You nudge the joystick <<dir.name>><<
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
++ Component 'fine stiff long looped wire (toy) (car) car\'s antenna/loop'
    'antenna'
    "It's a piece of fine, stiff wire about four inches long, curved
    into a little loop at the top. "
    disambigName = 'toy car\'s antenna'
;

+ toyCarControl: Thing 'little rf remote control/box' 'remote control'
    "It's a little box with an antenna and a joystick. "

    isListed = (toyCar.isListed || location != toyCar.location)

    filterResolveList(lst, action, whichObj, np, requiredNum)
    {
        /* 
         *   if the phrase was just "box", and there's anything else that
         *   can match, take the other thing 
         */
        if (np.getOrigText() == 'box' && lst.length() > 1)
            lst = lst.subset({x: x.obj_ != self});

        /* return the result */
        return lst;
    }
;
++ Component 'wire (remote) (control) antenna' 'antenna'
    "It's a piece of wire sticking out from the remote control box. "
    disambigName = 'remote control antenna'
;
++ Component '(remote) (control) joystick' 'remote control joystick'
    "It's a stubby control stick that you can move in any of the
    compass directions. "

    dobjFor(Move)
    {
        verify() { }
        action() { "(The joystick can be moved in any of the compass
            directions: MOVE JOYSTICK NORTH, for example.) "; }
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
ldCourtyard: CampusOutdoorRoom 'Lauritsen-Downs Courtyard'
    'Lauritsen-Downs courtyard' 'courtyard'
    "This is a small courtyard bounded by lab buildings:
    Guggenheim to the north, Firestone to the east, and 
    Lauritsen-Downs to the south and west.  A walkway leads north
    under a second-story bridge connecting Firestone and Guggenheim.
    The entrance to Lauritsen-Downs is to the south; the
    other buildings are just blank walls here, except for a door
    marked <q>Emergency Exit</q> in the northwest corner of
    Guggenheim. "

    vocabWords = '(lauritsen-downs) courtyard'

    north = ldcNorthWalk
    northwest = ldEmergencyDoor

    south: FakeConnector { "Lauritsen-Downs is mostly offices and
        classrooms; given that it's Ditch Day, there's probably not
        much going on here today. "; }

    /* we have some walls despite being an outdoor location */
    roomParts = static (inherited + [defaultNorthWall, defaultSouthWall,
                                     defaultEastWall, defaultWestWall])
;

+ CampusMapEntry 'downs lab/laboratory' 'Downs Laboratory' 'southwest';
+ CampusMapEntry 'lauritsen lab/laboratory' 'Lauritsen Laboratory' 'south';
+ CampusMapEntry 'lauritsen-downs lab/laboratory/courtyard'
    'Lauritsen-Downs courtyard' 'south';

+ ldcNorthWalk: PathPassage 'north n walkway' 'north walkway'
    "The walkway leads north under the second-story bridge. "
;

+ ldEmergencyDoor: Door
    '"emergency exit" emergency exit door' 'emergency exit door'
    "The door is marked <q>Emergency Exit.</q>  It looks like a one-way
    door leading out; there's no obvious way to open it from this side. "

    initiallyOpen = nil

    dobjFor(Open)
    {
        check()
        {
            "The door has no knob or handle on this side; it looks like
            it's only possible to open it from the other side. ";
            exit;
        }
    }
;

+ Enterable ->(location.south)
    'beige large lauritsen downs lauritsen-downs
    glass/windows/stucco/lab/laboratory/building'
    'Lauritsen-Downs'
    "Lauritsen and Downs are nominally separate buildings, but
    they're adjoined into a single L-shaped structure.  The combined
    building is modern-looking: beige stucco, right angles, large
    rectangular windows.  Most of the Institute's high-energy
    physicists have their offices in these buildings.  An entrance
    is to the south. "

    isProperName = true
;

+ Fixture 'blank back guggenheim lab/laboratory/wall/side' 'Guggenheim'
    "The back side of Guggenheim faces the courtyard.  Apart from the
    emergency exit door, it's just a blank wall. "

    isProperName = true
;

+ Fixture 'blank back firestone lab/laboratory/wall/side' 'Firestone'
    "The back side of Firestone faces the courtyard; it's just a blank
    wall on this side. "

    isProperName = true
;

+ Distant 'second-story story bridge' 'second-story bridge'
    "The bridge connects Firestone and Guggenheim on the second story.
    A walkway leads north under the bridge. "
;
    

/*
 *   Ernst, the electrician.  
 */
+ ernst: IntroPerson
    'tall rotund ruddy curly hair/electrician/ernst/man*men'
    'tall, rotund man'
    "He's a tall, rotund, ruddy man with curly hair, wearing denim
    overalls with an embroidered nametag reading <q>Ernst.</q>  You
    surmise that he's an electrician, from the tools hanging off his
    belt---voltmeters, crimpers, wire cutters.
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
            "<.p>You hear a commotion from somewhere nearby. ";
        });

        /* activate the nearby fight sounds */
        guntherErnstNearbyFightNoise.makePresent();

        /* set them both in the fighting states */
        setCurState(ernstFightingState);
        gunther.setCurState(guntherFightingState);
    }
;
++ InitiallyWorn 'denim overalls' 'denim overalls'
    "An embroidered nametag on the overalls reads <q>Ernst.</q> "
    isPlural = true
    isListedInInventory = nil
;
+++ Component, Readable 'embroidered nametag' 'nametag'
    "It reads <q>Ernst</q> in embroidered cursive letters. "
;
++ Thing
    'tool (electrician\'s) (wire) tool
    voltmeters/crimpers/cutters/belt/toolbelt/tools'
    'electrician\'s tools'
    "The tools look like the sorts of things an electrician would carry:
    voltmeters, crimpers, wire cutters, that sort of thing. "
    isPlural = true
    isListedInInventory = nil
;

++ DefaultAnyTopic, ShuffledEventList
    ['<q><i>Guten Tag,</i></q> he says.  Unfortunately, you don\'t
    speak much German.  He goes back to his work. ',
     '<q><i>Ich verstehe die Sprache nicht,</i></q> he says.  You
     recognize it as German, but you don\'t know enough German to
     carry on a conversation with him.  He goes back to his work. ',
     '<q><i>Bitte?</i></q> he says.  He looks at you quizzically
     for a few moments, then shrugs and goes back to work. ',
     'He just smiles and nods. <q><i>Guten Tag,</i></q> he finally
     says, then goes back to his work. ']
;

++ AskTellTopic, StopEventList @gunther
    ['He interrupts you before you finish. <q>Gunther?</q> he says,
    looking all around, then looks back at you.  He says something
    lengthy in rapid German, jabbing his finger in the air for
    emphasis every few words, then stops and stands there looking
    indignant.  He grunts and goes back to what he was doing, still
    looking a bit agitated. ',
     'He spins to face you, says something angry in German, and
     then goes back to his work. ']
;

class ErnstJobCardTopic: GiveShowTopic
    topicResponse()
    {
        "<q>Excuse me,</q> you say, holding out the card.
        <.p>He reads it over and says something in German, then hands
        the card back to you. ";

        /* check to see if we're already there */
        if (ernst.isIn(destLoc))
        {
            "He goes back to what he was doing. ";
            return;
        }

        "He stops what he was doing and starts putting things away
        and rearranging things on his toolbelt. ";

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
    "<q>Excuse me,</q> you say, holding out the card.
    <.p>He reads it over and says something in German, then hands
    the card back to you, and goes back to his work. "
;

/* our initial state: checking around Thomas */
++ ernstLauritsenState: ActorState
    isInitState = true
    stateDesc = "He's walking slowly near Lauritsen, looking closely at
        the building. "
    specialDesc = "\^<<location.aName>> is walking slowly along the
        outside of Lauritsen, looking closely at the building. "

    /* show a message when we arrive and start doing this state */
    introDesc = "\^<<location.theName>> starts walking slowly along
        the outside of Lauritsen, inspecting the building. "
;

/* our state on the orange walk: fixing a light fixture */
++ ernstOrangeState: ActorState
    stateDesc = "He's working on a lighting fixture alongside the
        walkway. "
    specialDesc = "\^<<location.aName>> is standing alongside the
        walkway, working on a lighting fixture. "

    /* show a message when we arrive and start doing this state */
    introDesc = "\^<<location.theName>> walks over to a lighting
        fixture alongside the walkway, and starts taking it apart. "
;

/* preparing to leave on our way to a new job */
++ ernstPreparingState: ActorState
    stateDesc = "He's rearranging things on his toolbelt. "
    specialDesc = "\^<<location.aName>> is standing here rearranging
        things on his toolbelt. "

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
    "He seems too busy with his tools to notice that you're trying
    to talk to him. "
;

/* our state while in transit through the quad */
++ ernstInTransitState: ActorState
    stateDesc = "He's walking past, on his way somewhere. "
    specialDesc = "\^<<location.aName>> is walking through, on his
        way somewhere. "

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
    "He just smiles and keeps walking. "
;

/* our state while fighting */
++ ernstFightingState: ActorState
    stateDesc = "He's running from the gardener, who's chasing him
        with tree clippers. "

    /* gunther provides the special description for the both of us */
    specialDesc = ""

    /* when the PC arrives, take our fight off-stage */
    afterTravel(traveler, connector)
    {
        if (traveler.isActorTraveling(me))
        {
            "<.p>\^<<ernst.theName>> abruptly stops running from
            <<gunther.theName>> and turns around, holding out a pair
            of wire cutters.  He yells something in German, and starts
            chasing the gardener.  The two run off to the north. ";

            trackAndDisappear(ernst, ernst.location.north);
            trackAndDisappear(gunther, gunther.location.north);

            /* this is worth some points */
            scoreMarker.awardPointsOnce();

            /* get rid of the commotion noises */
            guntherErnstNearbyFightNoise.moveInto(nil);
        }
    }

    scoreMarker: Achievement { +5 "commandeering the cherry picker" }
;
+++ DefaultAnyTopic
    "He seems to be preoccupied at the moment. "
;

/*
 *   A multi-instance noise object that shows up in each location adjacent
 *   to the fight. 
 */
guntherErnstNearbyFightNoise: PresentLater, MultiInstance
    locationList = [sanPasqualWalkway, orangeWalk, westOliveWalk, oliveWalk]
    instanceObject: SimpleNoise {
        desc = "You hear a commotion from somewhere nearby.  It sounds
            like someone's shouting in German. "
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
        action() { "It's probably not a good idea to drink water
            from a pond. "; }
    }
    dobjFor(Eat) asDobjFor(Drink)

    dobjFor(Enter)
    {
        verify() { logicalRank(50, 'enter pond'); }
        action() { "You have no interest in getting all wet right now. "; }
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
rockGarden: CampusOutdoorRoom 'Rock Garden' 'the rock garden'
    "The walkway winds its way through a rock garden set within a
    terraced series of ponds.  The path ascends the hillside to the
    west, and leads to the Olive Walk to the east.  A distance off
    to the west, you can see the Millikan library towering above. "

    east = rgEastWalk
    down asExit(east)
    west = rgWestWalk
    up asExit(west)
;

+ Decoration 'walkway/path' 'walkway'
    "The walkway leads uphill to the west, and to the Olive Walk
    to the east. "
;

+ rgEastWalk: PathPassage ->wowWestWalk 'olive walk' 'Olive Walk'
    "The Olive Walk lies to the east. "
;

+ rgWestWalk: PathPassage ->mpEastWalk 'path/walkway' 'path'
    "The path winds up the hillside to the west. "

    canTravelerPass(trav) { return trav != cherryPicker; }
    explainTravelBarrier(trav) { "The cherry picker won't fit on
        the narrow path. "; }
;

+ Decoration 'hill/hillside' 'hillside'
    "The path winds its way up the ten feet or so of the hillside
    to the west. "
;

+ Decoration 'rock garden/rock/rocks/stone/stones/boulder/boulders' 'rocks'
    "The rocks range from baseball-sized to boulders.  They're
    arranged in no particular pattern among a meandering series
    of pools and lush vegetation. "
    isPlural = true
    owner = (self)
;

+ Pond, Decoration
    'small miniature terraced water/series/pool/pond/ponds/pools/waterfalls'
    'ponds'
    "Small pools are terraced into the hillside, the higher ones
    gently overflowing in miniature waterfalls into the ones below.
    Water lilies float on the surface, and dense foliage surrounds
    each pool.  The rock garden's stones and boulders are arranged
    throughout. "
    isPlural = true

    dobjFor(Enter) { action() { "That would only disturb the careful
        arrangement of the rocks, and besides, you have no desire
        to get all wet. "; } }

    lookInDesc = "You see no lost treasures in the water; just
        rocks and water lilies. "

    iobjFor(PutIn)
    {
        verify() { }
        action() { "Better not; you'd get {it dobj/him} all wet. "; }
    }
;

++ Decoration 'water lily/lilies' 'water lilies'
    "The lilies bob on the rippling surface of the water. "
    isPlural = true
;

+ Decoration 'lush dense vegetation/plant/plants/foliage' 'vegetation'
    "Plants are arranged around the ponds and rocks, forming a
    green backdrop to the rock garden. "
    isMassNoun = true
;

+ Distant 'black nine-story millikan library/monolith' 'Millikan Library'
    "From here, you can see the top half or so of the nine-story
    black monolith. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Millikan pond 
 */
millikanPond: CampusOutdoorRoom 'Millikan Pond' 'Millikan Pond'
    'pond walkway'
    "The nine-story obsidian tower of the Millikan Library is to
    the west, rising above the wide rectangular pond that fills
    the large open area north of the walkway.  A combination abstract
    sculpture and fountain in the center of the pond shoots several
    streams of water into the air.
    <.p>Bridge Lab is a short distance to the south, and the entrance
    to the library is to the west.  A path leads east, down a hill. "

    vocabWords = 'pond walkway'

    west = millikanLobby
    east = rockGarden
    down asExit(east)
    south = bridgeEntry
;

+ CampusMapEntry 'east e bridge lab/laboratory/bridge'
    'Bridge Laboratory' 'southwest'

    /* 
     *   since we mention this specifically as a destination the player
     *   should seek, elevate its match strength in case of ambiguity
     *   (which can happen if we look up simply "lab") 
     */
    mapMatchStrength = 200
;

+ CampusMapEntry 'millikan library' 'Millikan Library' 'southwest'
    /* elevate the match strength in case we look up just "library" */
    mapMatchStrength = 200
;

+ mpEastWalk: PathPassage 'path/hill/hillside' 'path'
    "The path leads down a hill to the east. "
;

+ Enterable ->(location.west)
    'millikan nine-story obsidian black library/tower/monolith'
    'Millikan Library'
    "The black, windowless face of the library rises up from the
    west end of the pool to a height of nine stories, towering
    over everything else nearby.  The entrance is to the west. "
;

+ EntryPortal ->(location.south)
    'norman bridge lab/laboratory/arcade/entrance' 'Bridge Lab'
    "The Norman Bridge Laboratory of Physics is where they teach
    phys 1, which virtually every frosh has to take.  The entrance
    is to the south, through an arched walkway. "

    isProperName = true
;

+ EntryPortal ->(location.south)
    'arched (bridge) walkway/arcade' 'arched walkway'
    "The arcade runs the length of this side of Bridge. "
;

+ Pond, Fixture '(millikan) wide rectangular shallow pond/pool/water' 'pond'
    "The pond is quite shallow, a couple of feet deep at most.
    A fountain in the center is shooting water into the air. "

    lookInDesc = "You see nothing interesting submerged in the pond. "

    iobjFor(PutIn)
    {
        verify() { }
        action() { "Better not; you'd get {it dobj/him} all wet. "; }
    }
;

+ Distant
    'twisting curving abstract (water)
    sculpture/fountain/shape/shapes/stream/streams/(water)'
    'fountain'
    "The fountain is a sculpture of twisting, curving shapes.  Several
    streams of water shoot up out of the fountain and arc away in
    different directions. "
;

