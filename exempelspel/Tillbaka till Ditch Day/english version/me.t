/* 
 *   Copyright 2003, 2013 Michael J. Roberts
 *   
 *   Return to Ditch Day - "me."  This module defines the player character
 *   actor object.  
 */

#include <adv3.h>
#include <en_us.h>


/* ------------------------------------------------------------------------ */
/*
 *   The player character.  We base this on Actor, rather than Person, to
 *   avoid adding the base vocabulary that we define for Person.  
 */
me: BagOfHolding, Actor
    vocabWords = 'doug douglas doug/douglas/mittling'
    desc
    {
        "You're Doug Mittling, Engineering Manager, Industry Products
        Group, Omegatron Corporation.  It's been about a decade since
        college, and the passage of time has started to show; you're
        a little softer, a little wider around the middle, and a
        bit pale from spending most of your time indoors. ";

        if (myDust.isIn(self))
        {
            "You're kind of a mess---your pants are ripped, ";
            if (myLeftShoe.isIn(self))
                "you're missing a shoe, ";
            "and you're covered in a layer of dust and cobwebs. ";
        }

        /* show my posture */
        "<.p>";
        postureDesc;
        "<.p>";

        /* show my inventory */
        holdingDesc;
    }

    /* customize our inventory listing for what we're wearing */
    inventoryLister: actorInventoryLister {
        showInventoryWearingOnly(parent, wearing)
        {
            "You're carrying nothing, and you're wearing
            <<usualAttireMsg>> <<wearing>><<casualFridayMsg>>. ";
        }
        showInventoryShortLists(parent, carrying, wearing)
        {
            "You are carrying <<carrying>>, and you're wearing
            <<usualAttireMsg>> <<wearing>><<casualFridayMsg>>. ";
        }
        showInventoryLongLists(parent, carrying, wearing)
        {
            "You are carrying <<carrying>>.  You're wearing
            <<usualAttireMsg>> <<wearing>><<casualFridayMsg>>. ";
        }

        casualFridayMsg()
        {
            /* 
             *   this remark will wear thin; only show it a couple of
             *   times, and only show it when we're wearing the standard
             *   set of clothes 
             */
            if (!wearingExtras() && casualFridayCount++ < 2)
                "---every day is <q>casual Friday</q> in Silicon Valley";
        }
        casualFridayCount = 0

        /* "your usual office attire" message, if appropriate */
        usualAttireMsg()
        {
            if (!wearingExtras())
                "your usual office attire:";
        }

        /* are we wearing anything beyond the AlwaysWorn set? */
        wearingExtras()
        {
            /* look for anything being worn that's not of class AlwaysWorn */
            return me.contents.indexWhich(
                {x: x.isWornBy(me) && !x.ofKind(AlwaysWorn)});
        }
    }
    holdingDescInventoryLister = (inventoryLister)
    
    /* start out in the power control room */
    location = powerControl

    /* use Person-sized bulk */
    bulk = 10

    /* 
     *   issue commands synchronously to other actors (in other words,
     *   when we issue a command to another actor, wait for the actor to
     *   finish the entire command before we get another turn) 
     */
    issueCommandsSynchronously = true

    /*
     *   I'm a Bag of Holding, of sorts: if something can be worn, wearing
     *   that thing relieves us of the enumbrance of holding it.  So, use a
     *   non-zero affinity for anything wearable.  However, use a lower
     *   than default affinity, so that we'll try putting wearables into a
     *   normal bag of holding first.  
     */
    affinityFor(obj)
    {
        return (obj != self && obj.ofKind(Wearable) ? 50 : 0);
    }

    /* putting an object into this "Bag of Holding" means wearing it */
    tryPuttingObjInBag(target) { return tryImplicitAction(Wear, target); }

    dobjFor(Clean)
    {
        verify() { }
        action()
        {
            if (myDust.isIn(self))
                "You try to make yourself a little more presentable
                by brushing off the dust and cobwebs, but it's all such
                a sticky mess that you only seem to make it worse. ";
            else
                "You brush off your clothes a little. ";
        }
    }

    /* 
     *   Get follow information for the given object.  For the most part,
     *   we use the standard library mechanism, but we give the actor
     *   we're following a chance to supplement the information.  
     */
    getFollowInfo(obj)
    {
        local info;

        /* if the basic follow information is available, use that */
        if ((info = inherited(obj)) != nil
            && location.effectiveFollowLocation
               == info.sourceLocation.effectiveFollowLocation)
            return info;

        /* 
         *   if the target object has a known destination, see if we can
         *   calculate the path there 
         */
        if (obj.knownFollowDest != nil)
        {
            local path;
            local info;
            
            /* try to generate a path to the known destination */
            path = roomPathFinder.findPath(self,
                                           location.effectiveFollowLocation,
                                           obj.knownFollowDest);

            /* if we got a path, go to the next location on the path */
            if (path != nil && path.length() > 1)
            {
                /* construct a FollowInfo describing the next step */
                info = new FollowInfo();
                info.obj = obj;
                info.connector = location.effectiveFollowLocation.
                    getConnectorTo(self, path[2]);
                info.sourceLocation = location;

                /* return the information */
                return info;
            }
        }

        /* we didn't find any follow information */
        return nil;
    }

    dobjFor(Scratch) maybeRemapTo(mosquitoBites.isIn(self),
                                  Scratch, mosquitoBites)
;

/*
 *   The known follow destination.  We'll set this for any actor whose
 *   ultimate location is known to us, and we'll use it to calculate a
 *   path that lets us follow the actor even if we didn't see each step of
 *   the actor's journey.  This is essentially an extension of the basic
 *   follow idea, where we remember the last departure we actually saw for
 *   an actor; the extension is that if we know where the actor was
 *   heading when it departed, we'll calculate a path to the destination
 *   rather than just the single step of the last noted departure.  
 */
property knownFollowDest;

+ myHands: CustomImmovable 'left right hand/hands' 'your hand'
    "You know it like the back of your hand. "
    isQualifiedName = true

    /* our hands add no bulk, obviously */
    bulk = 0

    /* these are just here for decoration; no need to include in ALL */
    hideFromAll(action) { return true; }

    /* 
     *   we're a body part, so we don't need to be held to carry out
     *   actions, even when they have an objHeld condition 
     */
    meetsObjHeld(actor) { return actor == location; }

    /* 
     *   The hands are here because we have at least one object in the game
     *   that's specifically wearable on one's hands.  PUT X ON HAND maps
     *   to WEAR X, but only if X is a hand-wearable.  
     */
    iobjFor(PutOn)
    {
        verify()
        {
            /* only hand-wearables can be put on one's hands */
            if (gDobj != nil && !gDobj.ofKind(HandWearable))
                illogical('{You/he} can\'t put {the dobj/him} on
                    your hands. ');
        }
        action()
        {
            /* treat this as WEAR dobj */
            replaceAction(Wear, gDobj);
        }
    }

    dobjFor(Move)
    {
        verify() { }
        action() { "You move your hand around a little. "; }
    }

    cannotTakeMsg = 'There\'s no need to fiddle with your hands. '
    dobjFor(Take) { verify() { illogical(cannotTakeMsg); } }
    dobjFor(TakeFrom) asDobjFor(Take)
    dobjFor(Open) asDobjFor(Take)
    dobjFor(Close) asDobjFor(Take)
;

+ AlwaysWorn 'wrist wristwatch/watch' 'wristwatch'
    "It's nothing fancy; just a cheap analog model.  It
    currently reads <<clockManager.checkTimeFmt('[am][pm]h:mm a')>>. "

    dobjFor(Open) { verify() { illogical('You\'d need special jeweler\'s
        tools to open the watch, and you\'d probably just break it if
        you did. '); } }
    dobjFor(LookIn) asDobjFor(Open)

    cannotDoffMsg = "Better not; it's too easy to lose when you're
        not wearing it. "
;

+ myDust: PresentLater, Component
    'spider layer/dust/cobwebs/spiderwebs/web/webs'
    'layer of dust'
    "You're covered in a layer of dust and cobwebs. "

    introOnly = true

    dobjFor(Clean)
    {
        verify() { }
        action() { "You try brushing some of the dust off your clothes,
            but it's pretty hopeless. "; }
    }
    dobjFor(Remove) asDobjFor(Clean)
    dobjFor(Drop) asDobjFor(Clean)
;

+ khakis: AlwaysWorn
    'pair/khakis/pants/pant/slacks/trousers' 'pair of khakis'
    "It's a pair of khakis<<isTorn
    ? " with a huge rip down the left leg."
    : ". Part of your causal-everyday outfit.">> "

    makeTorn(torn)
    {
        isTorn = torn;
        khakiRip.makePresentIf(isTorn);
    }
    isTorn = nil

    /* PUT X IN PANTS -> PUT X IN POCKET; likewise LOOK IN */
    iobjFor(PutIn) remapTo(PutIn, DirectObject, myPocket)
    dobjFor(LookIn) remapTo(LookIn, myPocket)
;
++ khakiRip: PresentLater, Component 'huge rip/tear/hole' 'rip'
    "It's embarrassing but not life-threatening. "
;
++ myPocket: BagOfHolding, Component, RestrictedContainer
    '(pants) pocket/pockets' 'pocket'
    "One of things you like about this brand of khakis is that
    they have nice, deep pockets. "

    theName = 'your pocket'
    aName = 'your pocket'
    disambigName = 'your pants pocket'

    /* we're restricted to pocketable items */
    canPutIn(obj) { return obj.okayForPocket; }
    cannotPutInMsg(obj) { return '{The dobj/he} wouldn\'t fit very well
        in your pocket. '; }

    /* we have a high affinity for best-for-pocket items */
    affinityFor(obj) { return obj.bestForPocket ? 200 : 0; }

    contentsLister: thingContentsLister {
        showListPrefixWide(itemCount, pov, parent)
            { "In your pocket you have "; }
        showListPrefixTall(itemCount, pov, parent)
            { "In your pocket you have:"; }
    }
;

+ AlwaysWorn 'tan sport long-sleeved long sleeved button-down shirt'
    'tan shirt'
    "It's a button-down long-sleeved sport shirt, a fairly neutral
    tan color. It's typical of what you wear into the office most days. "
;

+ myShoes: AlwaysWorn 'brown leather left right shoe/shoes/pair'
    'pair of brown leather shoes'
    "Your shoes are brown leather, in a casual-but-not-too-casual
    style.  They're made by one of those brands that straddles the
    line between sneakers and real shoes. "
;
+ myLeftShoe: PresentLater, AlwaysWorn 'brown leather left shoe'
    'left shoe'
    "It's a brown leather shoe for the left foot. "
;
++ Decoration 'shoes' 'shoes'
    "Shoe, singular.  You only seem to have a left shoe now. "
    isPlural = true
    notImportantMsg = 'You don\'t seem to have <q>shoes</q> any more,
                       just <q>shoe.</q> '
;

/* initially give us some mosquito bites */
+ mosquitoBites: Decoration 'mosquito bite/bites' 'mosquito bites'
    "You've been a mosquito magnet here; to the mosquitoes you must
    be exotic foreign food. "
    isPlural = true
    notImportantMsg = 'There\'s nothing you can do about them. '

    specialDesc = "You have quite a number of mosquito bites. "

    dobjFor(Scratch)
    {
        verify() { logicalRank(150, 'bites'); }
        action() { mainReport('Scratching your mosquito bites feels good
            for a moment, but you know it\'ll only make it worse in the
            long run. '); }
    }

    introOnly = true
;

+ contract: Readable 'contract' 'contract'
    "This is a contract to provide a supplemental control system,
    and related consulting and maintenance services, to Government
    Power Plant #6.  It's the whole reason you're here, and if you
    go home without getting it signed, your VP will be furious.
    Colonel Magnxi made it clear that she won't sign anything
    until she sees a working demo of the SCU---which is
    precisely why they sent you instead of a sales rep. "
;

