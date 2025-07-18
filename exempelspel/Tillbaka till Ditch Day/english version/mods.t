/*
 *   Copyright 2003, 2013 Michael J. Roberts
 *   
 *   Return to Ditch Day - library modifications and extensions.  We
 *   centralize our changes to library objects here for efficiency, to
 *   avoid scattered modifications of the base library classes.  We also
 *   include some utility classes of our own here.  
 */

#include <adv3.h>
#include <en_us.h>


/* ------------------------------------------------------------------------ */
/*
 *   Add some custom verbs 
 */

/* 
 *   Define a generic USE verb.  For the most part, we'll require specific
 *   verbs, but there are a few cases where the specific verb might not be
 *   entirely straightforward to guess, so allow USE in these cases. 
 */
DefineTAction(Use);
VerbRule(Use) 'use' singleDobj : UseAction
    verbPhrase = 'use/using (what)'
;

/* similarly, a generic USE ON */
DefineTIAction(UseOn);
VerbRule(UseOn) 'use' singleDobj 'on' singleIobj : UseOnAction
    verbPhrase = 'use/using (what) (on what)'
;

/* 
 *   we have a number of doors in the game, and it might make sense to
 *   knock at some of them 
 */
DefineTAction(Knock);
VerbRule(Knock) 'knock' ('on' | 'at') singleDobj : KnockAction
    verbPhrase = 'knock/knocking (on what)'
;
VerbRule(KnockWhat) 'knock' : KnockAction
    verbPhrase = 'knock/knocking (on what)'
    construct()
    {
        dobjMatch = new EmptyNounPhraseProd();
        dobjMatch.responseProd = atOnSingleNoun;
    }
;

/* add a grammar rule for using either 'on' or 'at' to answer a question */
grammar atOnSingleNoun(main):
   ( | 'at' | 'on' ) singleNoun->np_ : PrepSingleNounProd
;

/*
 *   Given that we're trying to repair the SCU in the introduction
 *   section, players might want to just say "repair it"; at least
 *   recognize the syntax.  
 */
DefineTAction(Repair);
VerbRule(Repair) ('repair' | 'fix') singleDobj : RepairAction
    verbPhrase = 'repair/repairing (what)'
;

/* make 'power on/up/off/down' equivalent to 'turn on/off'  */
VerbRule(PowerOn)
    'power' ('on' | 'up') dobjList | 'power' dobjList ('on' | 'up')
    : TurnOnAction
    verbPhrase = 'power/powering on (what)'
;
VerbRule(PowerOff)
    'power' ('off' | 'down') dobjList | 'power' dobjList ('off' | 'down')
    : TurnOffAction
    verbPhrase = 'power/powering off (what)'
;

/* we talk about "accompanying" xojo; make this the same as "follow" */
VerbRule(Accompany)
    ('accompany' | 'go' 'with') singleDobj
    : FollowAction
    verbPhrase = 'accompany/accompanying (whom)'
;

/* 
 *   we have mosquito bites in the introductory section; we'd better be
 *   able to scratch them 
 */
DefineTAction(Scratch);
VerbRule(Scratch) 'scratch' singleDobj : ScratchAction
    verbPhrase = 'scratch/scratching (what)'
;

/* it would be good to be able to swat mosquitoes as well */
VerbRule(Swat) 'swat' singleDobj : AttackAction
    verbPhrase = 'swat/swatting (what)'
;

/* we might want to test things with the tester in the introduction */
DefineTAction(Test);
VerbRule(Test) ('test' | 'probe') singleDobj : TestAction
    verbPhrase = 'test/testing (what)'
;
DefineTIAction(TestWith);
VerbRule(TestWith)
    ('test' | 'probe') singleDobj 'with' singleIobj : TestWithAction
    verbPhrase = 'test/testing (what) (with what)'
;

/* there's a game we can play */
DefineTAction(Play);
VerbRule(Play) 'play' singleDobj : PlayAction
    verbPhrase = 'play/playing (what)'
;

/* 
 *   there's a handrail in the elevator in the introduction, so we might
 *   be inclined to hold onto it 
 */
DefineTAction(Hold);
VerbRule(Hold)
    (('hold' | 'grab') ('on' 'to' | 'onto' | )
     | 'take' 'hold' 'of' | 'grab' | 'grip') singleDobj : HoldAction
    verbPhrase = 'hold/holding (what)'
;

/* 
 *   Accept FIND X ON Y and LOOK UP X ON Y as synonyms for LOOK UP X IN Y.
 *   This is mostly for our campus map, since it makes more sense to use
 *   ON than IN when we're consulting a map.  
 */
VerbRule(ConsultMapAbout)
    'look' ('up' | 'for') singleTopic 'on' singleDobj
    | 'look' singleTopic 'up' 'on' singleDobj
    | 'find' singleTopic 'on' singleDobj
    : ConsultAboutAction
    verbPhrase = 'find/finding (what) (on what)'
    whichMessageTopic = DirectObject
    askDobjResponseProd = singleNoun
;

/*
 *   RAISE and LOWER verbs.  We use these as high-level substitutes for
 *   cases where the atomic action involved is obvious.  
 */
DefineTAction(Raise);
VerbRule(Raise) 'raise' singleDobj : RaiseAction
    verbPhrase = 'raise/raising (what)'
;

DefineTAction(Lower);
VerbRule(Lower) 'lower' singleDobj : LowerAction
    verbPhrase = 'lower/lowering (what)'
;

/*
 *   The Dice-O-Matic needs PUSH DOWN ON, to roll the dice.  Just make
 *   this a synonym for PUSH. 
 */
VerbRule(PushDownOn) 'push' 'down' 'on' singleDobj : PushAction
    verbPhrase = 'push/pushing (what)'
;

/*
 *   We want to be able to hang the chicken suit on the hooks. 
 */
DefineTIAction(HangOn);
VerbRule(HangOn) 'hang' dobjList 'on' singleIobj : HangOnAction
    verbPhrase = 'hang/hanging (what) (on what)'
;
VerbRule(HangOnWhat) 'hang' dobjList : HangOnAction
    verbPhrase = 'hang/hanging (what) (on what)'
    construct()
    {
        iobjMatch = new EmptyNounPhraseProd();
        iobjMatch.responseProd = onSingleNoun;
    }
;

/*
 *   There's a bridge; we should be able to cross it 
 */
DefineTAction(Cross);
VerbRule(Cross) 'cross' singleDobj : CrossAction
    verbPhrase = 'cross/crossing (what)'
;

/*
 *   We can buy things at the bookstore 
 */
DefineTAction(Buy);
VerbRule(Buy) ('buy' | 'pay' 'for') singleDobj : BuyAction
    verbPhrase = 'buy/buying (what)'
;

DefineTAction(Pay);
VerbRule(Pay) 'pay' singleDobj : PayAction
    verbPhrase = 'pay/paying (whom)'
;

DefineTIAction(PayFor);
VerbRule(PayFor)
    'pay' singleDobj 'for' singleIobj
    | 'buy' singleIobj 'from' singleDobj
    : PayForAction
    verbPhrase = 'pay/paying (whom) (for what)'
;

DefineTAction(Slide);
VerbRule(Slide) 'slide' dobjList : SlideAction
    verbPhrase = 'slide/sliding (what)'
;

DefineTAction(Roll);
VerbRule(Roll) 'roll' dobjList : RollAction
    verbPhrase = 'roll/rolling (what)'
;

/* SLIDE NORTH and ROLL NORTH, etc, are just synonyms for MOVE NORTH, etc */
VerbRule(SlideTravelDir)
    ('slide' | 'roll') dobjList singleDir
    : PushTravelDirAction
    verbPhrase = ('push/pushing (what) ' + dirMatch.dir.name)
;

/* SLIDE THROUGH -> MOVE THROUGH */
VerbRule(SlideTravelThrough)
    ('slide' | 'roll') dobjList ('through' | 'thru') singleIobj
    : PushTravelThroughAction
    verbPhrase = 'move/moving (what) (through what)'
;

/* there's at least one place where it might be nice to hide */
DefineTAction(HideIn);
VerbRule(HideIn) 'hide' 'in' singleDobj : HideInAction
    verbPhrase = 'hide/hiding (in what)'
;

VerbRule(HideInWhat) 'hide' : HideInAction
    verbPhrase = 'hide/hiding (in what)'
    construct()
    {
        dobjMatch = new EmptyNounPhraseProd();
        dobjMatch.responseProd = inSingleNoun;
    }
;

/* add THROW INTO as a synonym for THROW AT */
VerbRule(ThrowInto)
    ('throw' | 'toss') dobjList ('in' | 'into' | 'in' 'to') singleIobj
    : ThrowAtAction
    verbPhrase = 'throw/throwing (what) (at what)'
;

/* CLIMB THROUGH is the same as GO THROUGH for most purposes */
VerbRule(ClimbThrough)
    'climb' ('through' | 'thru') singleDobj
    : GoThroughAction
    verbPhrase = 'go/going (through what)'
    askDobjResponseProd = singleNoun
;

/*
 *   The special MOVE/PUSH/PULL dobj BACK phrasing.  "Back" isn't a real
 *   direction, in that it can't be named.  However, we do allow pushing
 *   and pulling things forward and back, since this is sometimes
 *   appropriate for levers and the like, where there's an obvious
 *   internal reference frame that is, to some people, the most intuitive
 *   and convenient way to describe the object's motion.  There's no way
 *   to use BACK as a direction in travel; this exists as an abstract
 *   internal direction only, and we only use it for our special
 *   PUSH/PULL/MOVE phrasing.  
 */
backDirection: Direction
    dirProp = &backDirLink
;
VerbRule(PushTravelBack)
    ('push' | 'pull' | 'drag' | 'move') dobjList 'back'
    | ('push' | 'pull' | 'drag' | 'move') 'back' dobjList
    : PushTravelDirAction

    verbPhrase = 'push/pushing (what) back'
    getDirection = backDirection
;

/*
 *   Treat CLIMB UP and CLIMB DOWN, when used alone, as synonyms for UP
 *   and DOWN.  (This won't overshadow the standard, transitive versions
 *   of these phrases.)  
 */
VerbRule(ClimbUpI) 'climb' 'up' : TravelAction
    getDirection = upDirection
    verbPhrase = 'go/going up'
;
VerbRule(ClimbDownI) 'climb' 'down' : TravelAction
    getDirection = downDirection
    verbPhrase = 'go/going down'
;

/* ------------------------------------------------------------------------ */
/*
 *   Our changes to the base Thing class.  Most of our changes are to add
 *   default handling for verbs we create.  
 */
modify Thing
    dobjFor(Scratch)
    {
        preCond = [touchObj]
        verify() { }
        action() { "There's no reason to do that. "; }
    }

    dobjFor(Repair)
    {
        preCond = [touchObj]
        verify() { }
        action() { "{You/he} will have to be more specific about
            how to do that. "; }
    }

    dobjFor(Knock)
    {
        preCond = [touchObj]
        verify() { logicalRank(50, 'why knock'); }
        action() { "There's no obvious effect. "; }
    }

    dobjFor(Use)
    {
        verify() { }
        action() { "{You/he} will have to be more specific about how
            you want to use {the dobj/him}. "; }
    }

    dobjFor(UseOn)
    {
        verify() { }
        action() { "{You/he} will have to be more specific about how
            you want to use {the dobj/him}. "; }
    }
    iobjFor(UseOn)
    {
        verify() { }
        action() { }
    }

    dobjFor(Test)
    {
        verify() { logicalRank(50, 'not testable'); }
        action() { askForIobj(TestWith); }
    }

    dobjFor(TestWith)
    {
        verify() { logicalRank(50, 'not testable'); }
    }
    iobjFor(TestWith)
    {
        verify() { illogical('{You/he} can\'t test anything
            with {the iobj/him}. '); }
    }

    dobjFor(HangOn)
    {
        verify() { }
        action() { reportFailure('There\'s no need to do that. '); }
    }
    iobjFor(HangOn)
    {
        verify()
        {
            illogical('There\'s no obvious way to hang anything
                on {the iobj/him}. ');
        }
    }

    dobjFor(Cross)
    {
        verify() { illogical('{That dobj/he} {is}n\'t something
            {you/he} can cross. '); }
    }

    /* by default, treat 'hold' as equivalent to 'take' */
    dobjFor(Hold) asDobjFor(Take)

    dobjFor(Buy)
    {
        verify() { illogical('{That dobj/he} {is}n\'t something
            {you/he} can buy. '); }
    }
    dobjFor(Pay)
    {
        verify() { illogical('There\'s no need to pay {the dobj/him}. '); }
    }
    dobjFor(PayFor)
    {
        verify() { illogical('There\'s no need to pay {the dobj/him}. '); }
    }
    iobjFor(PayFor)
    {
        verify() { illogical('{That dobj/he} {is}n\'t something
            {you/he} can buy. '); }
    }

    /* SLIDE and ROLL are synonyms for MOVE for most purposes */
    dobjFor(Slide) asDobjFor(Move)
    dobjFor(Roll) asDobjFor(Move)

    dobjFor(HideIn)
    {
        verify() { illogical('{That/he dobj} do{es}n\'t look like a
            viable hiding place. '); }
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   add some default vocabulary to Person 
 */
modify Person
    vocabWords = 'person*persons people'
;

/* ------------------------------------------------------------------------ */
/*
 *   make some customizations to the Door class 
 */
modify Door
    dobjFor(Knock)
    {
        verify() { }
        action() { "You knock on {the dobj/him}, but there doesn't
            seem to be any reply. "; }
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   A buyable is something that can be purchased.  We handle the actual
 *   purchasing process separately, but we at least want to recognize that
 *   the object can be purchased. 
 */
class Buyable: object
    dobjFor(Buy)
    {
        verify() { }
        action() { "You'll have to be more specific about how
            to do that. "; }
    }
    iobjFor(PayFor)
    {
        /* we'll leave it to the dobj to actually handle it */
        verify() { }
        action() { }
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   Add a noun phrase specifically for "door to <x>", where <x> is a
 *   simple noun phrase.  This works just like '<x> of <y>' in the
 *   standard parser, but we only accept 'door' as the first phrase.  This
 *   is useful for things like 'door to room 5' or 'door to the
 *   administration building'.  
 */
grammar compoundNounPhrase(doorTo):
    ('door'->door_ | 'doors'->door_ | 'entrance'->door_ | 'exit'->door_)
    'to'->to_ ( | 'the'->the_)
    compoundNounPhrase->np_
    : NounPhraseWithVocab

    getVocabMatchList(resolver, results, extraFlags)
    {
        /* resolve 'door' as a noun phrase */
        local lst1 = getWordMatches(door_, &noun, resolver,
                                    extraFlags, VocabTruncated);

        /* resolve the second noun phrase */
        local lst2 = np_.getVocabMatchList(resolver, results, extraFlags);

        /* return the interesection of the two lists */
        return intersectNounLists(lst1, lst2);
    }
    getAdjustedTokens()
    {
        local lst;
        
        /* generate the 'door to the' list from the original words */
        lst = [door_, &noun, to_, &miscWord];
        if (the_ != nil)
            lst += [the_, &miscWord];

        /* combine the 'door to the' list with the second noun phrase list */
        return lst + np_.getAdjustedTokens();
    }
;

/*
 *   A special noun phrase class, for defining an unusual phrasing for an
 *   individual object or set of objects.  This takes a specific set of
 *   tokens, and matches them to a given set of objects.
 *   
 *   This should usually be instantiated as a qualifiedSingularNounPhrase
 *   grammar rule.  
 */
class SpecialNounPhraseProd: NounPhraseWithVocab
    /* 
     *   Get our list of matching objects.  Each grammar rule instance of
     *   this class must define this to return the list of objects that
     *   the rule matches. 
     */
    getMatchList = []

    /* we always resolve to the in-scope subset of our matching objects */
    getVocabMatchList(resolver, results, flags)
    {
        /* 
         *   Get our list of all matching objects, then reduce it to the
         *   in-scope subset, then wrap each one in a ResolveInfo object
         *   and return the result.  
         */
        return getMatchList().subset({x: resolver.objInScope(x)})
            .mapAll({x: new ResolveInfo(x, flags, self)});
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   Add present participles to the standard postures.
 */
modify standing presentParticiple = 'standing';
modify sitting presentParticiple = 'sitting';
modify lying presentParticiple = 'lying';

/* ------------------------------------------------------------------------ */
/*
 *   Add a style tag for block-quote passages.  We'll use this set off long
 *   passages of text that's quoted from signs or books or the like.  For
 *   full HTML interpreters, we'll use <blockquote>; for non-HTML, we'll
 *   show some punctuation at the start and end of the text.  
 */
HtmlStyleTag 'blockquote'
    htmlOpenText = '<blockquote>'
    htmlCloseText = '</blockquote>'

    plainOpenText = '\n<tab align=center>***\n'
    plainCloseText = '\n<tab align=center>***\n'
;

/*
 *   Add some custom typographical output filtering. 
 */
modify typographicalOutputFilter
    filterText(ostr, val)
    {
        /* 
         *   duplicate the standard filtering (rather than inheriting it -
         *   this saves a little time, which with this routine is worth the
         *   duplication since it ends up being called so much 
         */
        val = rexReplace(eosPattern, val, '%1\u2002', ReplaceAll);
        val = val.findReplace('---', '\uFEFF&mdash;\u200B', ReplaceAll);
        val = val.findReplace('--',  '\uFEFF&ndash;\u200B', ReplaceAll);

        /*
         *   Replace double open-quotes and double close-quote sequences
         *   with close quotes surrounding a "hair space," which is a very
         *   thin space, just enough to keep the quotes from being smooshed
         *   together.  
         */
        val = val.findReplace('</q></q>', '</q>\uFEFF\u200A\uFEFF</q>',
                              ReplaceAll);
        val = val.findReplace('<q><q>', '<q>\uFEFF\u200A\uFEFF<q>',
                              ReplaceAll);

        /* return the result */
        return val;
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   A class for clothing worn by the player character, and which we can't
 *   take off.  We use this for the PC's constant complement of clothes;
 *   there's no reason to remove these.  
 */
class AlwaysWorn: Wearable
    wornBy = me
    dobjFor(Doff)
    {
        check()
        {
            cannotDoffMsg;
            exit;
        }
    }
    cannotDoffMsg = "You really don't have any reason to get
        undressed right now. "

    /* exclude these from DROP ALL and DOFF ALL */
    hideFromAll(action)
    {
        return action.ofKind(DropAction)
            || action.ofKind(DoffAction)
            || action.ofKind(PutInAction)
            || inherited(action);
    }
;

/*
 *   A class for clothing initially worn by its immediate container 
 */
class InitiallyWorn: Wearable
    wornBy = (location)

    /* 
     *   hide these from ALL, since they're essentially components of the
     *   person wearing them 
     */
    hideFromAll(action) { return true; }
;

/*
 *   A class for an item that can worn on one's hands 
 */
class HandWearable: Wearable
;

/* ------------------------------------------------------------------------ */
/*
 *   A special variation of the objHeld precondition: this ensures that
 *   the nearest non-Component container is being held.  This is useful
 *   when we want to apply a condition to an action on a component of an
 *   object that the main object itself is in hand. 
 */
mainObjHeld: objHeld
    checkPreCondition(obj, allowImplicit)
    {
        local cont;
        
        /* find the nearest non-Component container of 'obj' */
        for (cont = obj ; cont.location != nil && cont.ofKind(Component) ;
             cont = cont.location) ;

        /* now apply the normal precondition to the container */
        return inherited(cont, allowImplicit);
    }
;

/*
 *   A special precondition requiring that the actor's hands are empty.
 *   
 *   If the actor is carrying the tote bag, we'll try auto-bagging
 *   everything to free up space: the tote bag is wearable, and everything
 *   fits into it, so we might be able to go hands-free that way.
 *   Otherwise, we won't try anything implied; it's not always desirable to
 *   just put everything down, so in this case we'll simply enforce the
 *   requirement that the actor is holding nothing.  
 */
handsEmpty: PreCondition
    checkPreCondition(obj, allowImplicit)
    {
        /* 
         *   if they're not holding anything that we don't allow them to be
         *   holding, we can proceed with the command without further ado 
         */
        if (gActor.contents.indexWhich({x: requireDropping(x)}) == nil)
            return nil;

        /* 
         *   if implied commands are allowed, and auto-bagging is allowed,
         *   and the actor is carrying the tote bag, try moving things into
         *   bags 
         */
        if (allowImplicit && autoBag && toteBag.isIn(gActor))
        {
            local aff;
            
            /* get the bag-of-holding affinities for items being held */
            aff = gActor.getBagAffinities(gActor.contents
                                          .subset({x: x.isHeldBy(gActor)}));

            /* 
             *   Putting everything away could result in a lot of
             *   individual actions.  Rather than announcing each one
             *   individually, preface the actions with a summary
             *   announcement that says simply "putting everything away";
             *   then, after we're done, we'll remove the individual
             *   announcements that we generated.  
             */
            gTranscript.addReport(new ImplicitHandsEmptyAnnouncement(
                gAction, &announceImplicitAction));

            /* move things into their respective bags */
            foreach (local cur in aff)
            {
                /* put it in the bag if possible */
                if (!cur.bag_.isIn(cur.obj_)
                    && !cur.bag_.tryPuttingObjInBag(cur.obj_))
                    break;

                /* 
                 *   if we failed to accomplish that, give up without any
                 *   further message (as the failed attempt will have
                 *   generated an appropriate error report) 
                 */
                if (!cur.obj_.isIn(cur.bag_))
                    exit;
            }

            /* 
             *   Clean up the individual reports - these aren't needed, as
             *   we added the summary report at the beginning of the group
             *   of actions.  For each implicit action we performed
             *   directly, make the action's announcement silent.  
             */
            gTranscript.forEachReport(new function(cur)
            {
                /* 
                 *   if this is an implied action, and it was triggered
                 *   directly by our action, we can get rid of it 
                 */
                if (cur.ofKind(ImplicitActionAnnouncement)
                    && (cur.getAction().getOriginalAction().parentAction
                        == gAction))
                {
                    /* make this announcement silent */
                    cur.makeSilent();
                }
            });
            
            /* indicate that we did something implicit */
            return true;
        }

        /* we can't try moving anything around, so simply give up */
        reportFailure(failureMsg);
        exit;
    }

    /* can we try moving things into bags as a first resort? */
    autoBag = true

    /* the failure message */
    failureMsg = '{You/he}\'ll have to put everything down first. '

    /*
     *   Are we required to drop the given object?  By default, we'll
     *   require dropping anything being held.  
     */
    requireDropping(obj) { return obj.isHeldBy(gActor); }
;

/* special implied action announcement for emptying hands */
class ImplicitHandsEmptyAnnouncement: ImplicitActionAnnouncement
    /* use custom message text */
    getMessageText([params]) { return 'putting everything away'; }

    /* the bag of holding we're moving things into */
    bag_ = nil
;

/* a precondition for turning an object off */
objTurnedOff: PreCondition
    checkPreCondition(obj, allowImplicit)
    {
        /* if we're already turned off, we're good to go */
        if (!obj.isOn)
            return nil;

        /* try turning it off */
        if (allowImplicit && tryImplicitAction(TurnOff, obj))
        {
            /* make sure that worked */
            if (obj.isOn)
                exit;

            /* tell the caller we performed an implied action */
            return true;
        }

        /* couldn't turn it off implicitly, so complain and give up */
        gMessageParams(obj);
        "You'll have to turn off {the obj/him} first. ";
        exit;
    }
;

/* a precondition for turning an object on */
objTurnedOn: PreCondition
    checkPreCondition(obj, allowImplicit)
    {
        /* if we're already on, we're good to go */
        if (obj.isOn)
            return nil;

        /* try turning it on */
        if (allowImplicit && tryImplicitAction(TurnOn, obj))
        {
            /* make sure that worked */
            if (!obj.isOn)
                exit;

            /* tell the caller we performed an implied action */
            return true;
        }

        /* couldn't turn it off implicitly, so complain and give up */
        gMessageParams(obj);
        reportFailure('{You/he}\'ll have to turn on {the obj/him} first. ');
        exit;
    }
;

/* 
 *   A precondition for ensuring that a given set of objects is not being
 *   worn.  This can be used to enforce layering rules for clothing.  
 */
objsNotWorn: PreCondition
    checkPreCondition(obj, allowImplicit)
    {
        /* check each object to see if it's worn */
        foreach (local wornobj in objList)
        {
            /* if it's worn, try taking it off */
            if (wornobj.isWornBy(gActor))
            {
                /* if allowed, take it off implicitly */
                if (allowImplicit
                    && autoDoff
                    && tryImplicitAction(Doff, wornobj))
                {
                    /* make sure it's not being worn */
                    if (wornobj.isWornBy(gActor))
                        exit;

                    /* indicate that we performed an implied command */
                    return true;
                }
                else
                {
                    /* failed */
                    gMessageParams(wornobj);
                    reportFailure(failureMsg);
                    exit;
                }
            }
        }

        /* we didn't find anything worn, so we can proceed */
        return nil;
    }

    /* the objects that can't be worn */
    objList = []

    /* can we automatically remove these items? */
    autoDoff = true

    /* the failure message */
    failureMsg = '{You/he}\'ll have to take off {the wornobj/him} first. '
;

/* ------------------------------------------------------------------------ */
/*
 *   Add a tokenizer rule for floating-point numbers.
 */
PreinitObject
    execute()
    {
        /*
         *   Add a rule for dotted-quad IP addresses.  Insert this before
         *   the punctuation rule, and before our own floating-point number
         *   rule, since this looks like it starts with a regular
         *   floating-point number.  Treat this as a string when tokenized.
         */
        cmdTokenizer.insertRule(
            ['dotted quad', new RexPattern('([0-9]+<dot>){3}[0-9]+'),
             tokString, nil, nil],
            'punctuation', nil);

        /* 
         *   Add a rule for floating-point numbers.  Insert this before the
         *   punctuation rule, since we want to interpret a period followed
         *   immediately by a string of digits as a floating-point number.
         *   If the punctuation rule came first, we'd just treat the period
         *   as a period, which isn't what we want to do.
         *   
         *   Our rule consists of one or more digits, a period, and one or
         *   more digits.  We require one or more digits before and after
         *   the period to ensure that we really have a floating point
         *   number and not just an integer followed or preceded by a
         *   period.  Tokenize these as just ordinary vocabulary words.  
         */
        cmdTokenizer.insertRule(
            ['floating point number', new RexPattern('[0-9]*<dot>[0-9]+'),
             tokWord, nil, nil],
            'punctuation', nil);

        /*
         *   Add our calculator expression rule just before the normal
         *   'punctuation' rule.  This rule is ahead of punctuation
         *   because we want to interpret certain marks specially if
         *   they're part of a numeric expression.  We treat the whole
         *   thing as a literal string.
         *   
         *   The rule matches a series of at least one operator mixed in
         *   with zero or more numbers.  We don't want to match just a
         *   number without any operators, since we want to treat those as
         *   regular numeric tokens instead; but we can match just an
         *   operator, since we could PUSH THE = BUTTON, for example.  To
         *   express this rule, we match an optional sequence of digits,
         *   decimal points, and spaces (in any combination), followed by
         *   an operator character, followed by a sequence of digits,
         *   decimal points, spaces, and operator characters (in any
         *   combination).  This ensures that we recognize any sequence of
         *   digits and operator characters that has at least one operator
         *   character.  Note that we don't demand a rigid format for the
         *   entries, since we could certainly press an calculator's
         *   buttons in an order that doesn't constitute a valid entry on
         *   the calculator.  We leave it up to the calculator object to
         *   decide how it wants to interpret ill-formed entries.  
         */
        cmdTokenizer.insertRule(
            ['calculator',
             new RexPattern('[0-9.Cc ]*[-+*/=][-+*/=Cc0-9. ]*(?!<alpha>)'),
             tokString, tokStripTrailingSpaces, nil],
            'punctuation', nil);

        /*
         *   Add a pre-punctuation rule for journal numbers of the form
         *   70:11c - alphanumerics with an embedded colon. 
         */
        cmdTokenizer.insertRule(
            ['journal number', new RexPattern('<alphanum>+:<alphanum>+'),
             tokWord, nil, nil],
            'punctuation', nil);
    }
;

/*
 *   Strip spaces from the end of a token.  We use this for our calculator
 *   expression token; our token pattern includes arbitrary spaces at the
 *   end because we want arbitrary spaces in the middle of the expression.
 *   It's more convenient to deal with this after the fact, by stripping
 *   trailing spaces from the string, than by complicating the expression
 *   to capture embedded but not trailing spaces.  
 */
tokStripTrailingSpaces(txt, typ, toks)
{
    txt = rexReplace('<space>*(.*?)<space>*$', txt, '%1', ReplaceOnce);
    toks.append([txt, typ, txt]);
}

/* ------------------------------------------------------------------------ */
/*
 *   Track an actor's departure from the current location, then take the
 *   actor out of the game.  This is useful for cases where we have a
 *   scripted action where an actor pops in, says something, then is seen
 *   leaving but really ends up entirely gone from the game.  
 */
trackAndDisappear(actor, conn)
{
    local room;
    
    /* 
     *   If the actor isn't already in the player character's top-level
     *   location, move it there first.  This ensures that we'll be in
     *   sight, which is necessary to track "follow" information. 
     */
    room = gPlayerChar.location.getOutermostRoom();
    if (!actor.isIn(room))
        actor.moveIntoForTravel(room);

    /* track the departure for future "follow" commands */
    gPlayerChar.trackFollowInfo(actor, conn, room);

    /* move the actor out of the game entirely */
    actor.moveInto(nil);

    /* we have no idea of the actor's final destination */
    actor.knownFollowDest = nil;
}

/* ------------------------------------------------------------------------ */
/*
 *   A "generic object" is similar to a collective object.  This is an
 *   object that serves as a bland placeholder for lots of nameless
 *   individual objects that aren't actually implemented: a book on a
 *   bookshelf, for example.  When there's an actual implemented individual
 *   present, we'll consider a vocabulary match that matches a non-generic
 *   individual as well as us to refer unambiguously to the individual.  
 */
class GenericObject: object
    /* if we're ambiguous with any non-generics, use the non-generics */
    filterResolveList(lst, action, whichObj, np, requiredNum)
    {
        local nongen;
        
        /* get the subset of non-generics */
        nongen = lst.subset({x: !x.obj_.ofKind(GenericObject)});

        /* 
         *   if there are any non-generics, and we want fewer than the
         *   number matched, keep only the specific individuals 
         */
        if (requiredNum != nil
            && lst.length() > requiredNum
            && nongen.length() > 0)
            return nongen;
        else
            return lst;
    }
    
;

/*
 *   "Disambiguation deferrer" is a mix-in class that can be combined with
 *   any ordinary Thing class to create an object that defers in
 *   disambiguation situations to a given enumerated set of objects, or to
 *   objects that match some rule.  If we find any object from our
 *   enumerated set, or any object that matches our rule, we'll take
 *   ourselves out of the picture for disambiguation purposes.
 *   
 *   Deferral is useful in a lot of cases.  Frequently, one object will
 *   have a much stronger affinity for a given set of vocabulary words than
 *   most other objects, but we'll nonetheless want to make the other
 *   objects match the vocabulary when the stronger object isn't around.
 *   The deferrer lets the weaker objects opt out when they see the
 *   stronger object as a possible match.  
 */
class DisambigDeferrer: object
    /* 
     *   A list of objects I defer to.  We'll remove ourselves from parsing
     *   consideration if any of these objects are in scope.  
     */
    disambigDeferTo = []

    /* 
     *   Do we defer to the given object?  Returns true if we defer to the
     *   given object, nil if not.  By default, we defer if the object
     *   appears in our disambigDeferTo list.  
     */
    disambigDeferToObj(obj) { return disambigDeferTo.indexOf(obj) != nil; }

    /* 
     *   Filter the noun-phrase resolution list.  If we find any objects
     *   that we defer to in the match list, we'll defer by removing 'self'
     *   from the match list.  
     */
    filterResolveList(lst, action, whichObj, np, requiredNum)
    {
        /* if there's an object we defer to, defer to it */
        if (lst.indexWhich({x: disambigDeferToObj(x.obj_)}) != nil)
        {
            /* find myself in the list */
            local i = lst.indexWhich({x: x.obj_ == self});

            /* remove myself from the list */
            lst = lst.removeElementAt(i);
        }

        /* return the updated list */
        return lst;
    }
;

/*
 *   Component Deferrer - this is a disambiguation deferrer that can be
 *   combined with any component class to make the component defer to any
 *   non-component object.  Components are usually minor parts added to
 *   enhance the simulation depth, but as minor parts, they shouldn't take
 *   precedence over any more important objects in the game.  
 */
class ComponentDeferrer: DisambigDeferrer
    /* defer to any non-component */
    disambigDeferToObj(obj) { return !obj.ofKind(Component); }
;


/* ------------------------------------------------------------------------ */
/*
 *   A kind of chair that represents a bunch of chairs in one object. 
 */
class MultiChair: Chair
    /* allow multiple sitters simultaneously, since there are many */
    bulkCapacity = 100

    /* emphasize that we're acting as an arbitrary individual for sit, etc */
    dobjFor(SitOn)
    {
        action()
        {
            /* if we're not already on the chair, pick one explicitly */
            if (!gActor.isIn(self))
                chooseChairSitMsg;
            else
                "You sit on the chair. ";

            /* do the normal work */
            inherited();
        }
    }
    dobjFor(StandOn)
    {
        action()
        {
            /* if we're not already on the chair, pick one explicitly */
            if (!gActor.isIn(self))
                chooseChairStandMsg;
            else
                "You stand and step up onto the chair. ";

            /* do the normal work */
            inherited();
        }
    }

    chooseChairSitMsg = "You pick a chair and sit down. "
    chooseChairStandMsg = "You pick a chair and step up onto it. ";
;

/* ------------------------------------------------------------------------ */
/* 
 *   A class for things that can have literals typed on them.  The main
 *   thing we do is accept TYPE ON FOO, which simply asks for the literal
 *   to be typed.  
 */
class Keypad: object
    dobjFor(TypeOn)
    {
        verify() { }
        action() { askForLiteral(TypeLiteralOn); }
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   Modify the scoring system slightly to add "extra credit" points. 
 */
modify libScore
    showScore()
    {
        local turns = libGlobal.totalTurns;
        local points = totalScore;
        local maxPoints = gameMain.maxScore;

        /* show the  normal message */
        "In <<turns>> move<<turns == 1 ? '' : 's'>>, you have
        scored <<points>> of a possible <<maxPoints>> point<<
          maxPoints == 1 ? '' : 's'>>";

        /* add the extra credit message if appropriate */
        if (totalExtraCredit != 0)
            ", <i>plus</i> <<totalExtraCredit>> point<<
              totalExtraCredit == 1 ? '' : 's'>> of extra credit";

        ". ";
    }

    /* extra-credit points awarded */
    totalExtraCredit = 0
;

/*
 *   An extra-credit scoring item 
 */
class ExtraCreditAchievement: Achievement
    /* I'm worth zero points in the real score */
    maxPoints = 0

    /* show myself in a full-score listing */
    listFullScoreItem()
    {
        "<<points>> extra-credit point<<points == 1 ? '' : 's'>> for
        <<desc>>";
    }

    addToScoreOnce(points)
    {
        if (scoreCount == 0)
        {
            /* add zero points to the normal score */
            addToScore(0, self);

            /* count my points as extra credit */
            libScore.totalExtraCredit += points;

            /* tell the caller we awarded points as requested */
            return true;
        }
        else
            return nil;
    }

    awardPoints()
    {
        /* add me to the normal score with zero points */
        addToScore(0, self);

        /* count my points as extra credit */
        libScore.totalExtraCredit += points;
    }
;

/* monitor and announce extra-credit awards */
modify scoreNotifier
    lastExtraCredit = static (libScore.totalExtraCredit)
    checkNotification()
    {
        /* do the normal checks */
        inherited();

        /* notify about extra credit */
        if (libScore.totalExtraCredit != lastExtraCredit)
        {
            /* notify only if notifications are turned on */
            if (libScore.scoreNotify)
            {
                /* compute the change in extra credit since we last looked */
                local delta = libScore.totalExtraCredit - lastExtraCredit;

                /* tell them about it */
                "<.commandsep><.notification>You have just earned
                <<delta>> point<<delta == 1 ? '' : 's'>> of extra
                credit.<./notification> ";
            }

            /* remember the current score for next time */
            lastExtraCredit = libScore.totalExtraCredit;
        }
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   Customize PUT IN.
 */
modify PutInAction
    /*
     *   Before we perform the overall action, check to see if we're trying
     *   to put multiple things into the iobj.  If so, give the iobj a
     *   chance to object - some things can only accept a single direct
     *   object at a time.  
     */
    beforeActionMain()
    {
        /* do the inherited work */
        inherited();

        /* if we have multiple dobjs, give the iobj a chance to object */
        if (dobjList_.length() > 1)
            iobjList_[1].obj_.noteMultiPutIn(dobjList_.mapAll({x: x.obj_}));
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   Customize the generic INSTRUCTIONS manual slightly.  
 */
modify InstructionsAction
    /* 
     *   "cruelty" level - 0 means that the player character can't be
     *   killed, and that it's not possible to accidentally get yourself
     *   into an unwinnable position 
     */
    crueltyLevel = 0

    /* 
     *   we disclose every command required to complete the game - setting
     *   this flag causes the instructions to include a message assuring
     *   the user that they won't have to guess at any extra verbs beyond
     *   what's listed 
     */
    allRequiredVerbsDisclosed = true

    /* 
     *   this game requires some commands not listed in the generic set -
     *   since we want to be able to claim that the list of example
     *   commands is comprehensive, we need to add our extras to the list 
     */
    customVerbs = ['PUSH CART NORTH (or PUSH IT EAST, and so on)',
                   'PLUG ANTENNA INTO TV']
;

/* ------------------------------------------------------------------------ */
/*
 *   A service routine that extends the library's forEachInstance to
 *   return a list of instances of matching objects.  We'll return a list
 *   consisting of all of the objects of class 'cl' for which the given
 *   function 'func' (a function taking an object as its one parameter)
 *   returns true.  
 */
allInstancesWhich(cl, func)
{
    /* start with an empty vector */
    local v = new Vector(32);

    /* add to the vector each instance of 'cl' for which 'func' is true */
    for (local obj = firstObj(cl) ; obj != nil ; obj = nextObj(obj, cl))
    {
        /* if 'func' returns true for 'obj', include 'obj' in the result */
        if ((func)(obj))
            v.append(obj);
    }

    /* convert the vector to a list and return the result */
    return v.toList();
}
