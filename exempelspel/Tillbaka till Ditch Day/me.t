#charset "utf-8"
/* 
 *   Copyright 2003, 2013 Michael J. Roberts
 *   
 *   Return to Ditch Day - "me."  This module defines the player character
 *   actor object.  
 */

#include <adv3.h>
#include <sv_se.h>


/* ------------------------------------------------------------------------ */
/*
 *   The player character.  We base this on Actor, rather than Person, to
 *   avoid adding the base vocabulary that we define for Person.  
 */
me: BagOfHolding, Actor
    vocabWords = 'doug douglas doug/douglas/mittling'
    desc
    {
        "Du är Doug Mittling, teknisk chef på Industry Products
        Group, Omegatron Corporation. Det har gått ungefär ett decennium sedan
        college, och tidens gång har börjat visa sig; du är
        lite mjukare, lite bredare runt midjan, och
        en aning blek av att spendera den större delen av din tid inomhus. ";

        if (myDust.isIn(self))
        {
            "Du ser rätt bedrövlig ut---dina byxor är trasiga, ";
            if (myLeftShoe.isIn(self))
                "du saknar en sko, ";
            "och du är täckt av ett lager damm och spindelnät. ";
        }

        /* visa min hållning */
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
            "Du bär ingenting och har på dig
            <<usualAttireMsg>> <<wearing>><<casualFridayMsg>>. ";
        }
        showInventoryShortLists(parent, carrying, wearing)
        {
            "Du bär på <<carrying>> och har på dig
            <<usualAttireMsg>> <<wearing>><<casualFridayMsg>>. ";
        }
        showInventoryLongLists(parent, carrying, wearing)
        {
            "Du bär på <<carrying>>. Du har på dig
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
                "---varje dag är <q>casual Friday</q> i Silicon Valley";
        }
        casualFridayCount = 0

        /* "your usual office attire" message, if appropriate */
        usualAttireMsg()
        {
            if (!wearingExtras())
                "din vanliga kontorsklädsel:";
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
                "Du försöker göra dig lite mer presentabel genom att
                borsta av dammet och spindelnäten, men allt är så
                klibbigt att du bara verkar göra det värre. ";
            else
                "Du borstar av dina kläder lite. ";
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

+ myHands: CustomImmovable 'vänster vänstra höger högra hand+en/händer+na' 'din hand'
    "Du kan den som din egen ficka. "
    //"You know it like the back of your hand."
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
                illogical('{Du/han} kan inte ta på dig {ref dobj/honom} på dina händer. ');
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
        action() { "Du flyttar runt din hand en liten stund. "; }
    }

    cannotTakeMsg = 'Det finns ingen anledning att hålla på med dina händer. '
    dobjFor(Take) { verify() { illogical(cannotTakeMsg); } }
    dobjFor(TakeFrom) asDobjFor(Take)
    dobjFor(Open) asDobjFor(Take)
    dobjFor(Close) asDobjFor(Take)
;

+ AlwaysWorn 'armband:et^s+ur+et/klocka+n/ur+et' 'armbandsur'
    "Det är inget fancy; bara en billig analog modell. Den visar för närvarande 
    <<clockManager.checkTimeFmt('24 h:mm')>>. "
    // NOTE that in the original it is AM/PM: <<clockManager.checkTimeFmt('[am][pm]h:mm a')>>. "
    dobjFor(Open) { verify() { illogical('Du skulle behöva speciella 
        urmakeriverktyg för att öppna klockan, och du skulle förmodligen 
        bara ha sönder den om du gjorde det. '); } }
    dobjFor(LookIn) asDobjFor(Open)

    cannotDoffMsg = "Bäst att låta bli; den är för lätt att tappa 
        bort när du inte har den på dig. "
;

+ myDust: PresentLater, Component
    'spindelnät:et^s+täckt+a lager dammtäckt+a dammlager/dammlagret/spindelnät+et/nät+et*näten+a spindelnäten+a'
    'lager av damm'
    "Du är täckt av ett lager damm och spindelnät. "

    introOnly = true
    isNeuter = true

    dobjFor(Clean)
    {
        verify() { }
        action() { "Du försöker borsta av lite av dammet från dina kläder, 
            men det är ganska hopplöst. "; }
    }
    dobjFor(Remove) asDobjFor(Clean)
    dobjFor(Drop) asDobjFor(Clean)
;

+ khakis: AlwaysWorn
    'par byxa+n*khakis:+byxor+na slacks chinos byxor+na' 'par khakis'
    "Det är ett par khakis<<isTorn
    ? " med en enorm reva längs vänstra benet."
    : ". En del av din vardagliga klädsel.">> "

    makeTorn(torn)
    {
        isTorn = torn;
        khakiRip.makePresentIf(isTorn);
    }
    isTorn = nil
    isPlural = true
    /* PUT X IN PANTS -> PUT X IN POCKET; likewise LOOK IN */
    iobjFor(PutIn) remapTo(PutIn, DirectObject, myPocket)
    dobjFor(LookIn) remapTo(LookIn, myPocket)
;
++ khakiRip: PresentLater, Component 'enorm+a reva+n/repa+n/hål+et' 'reva'
    "Det är pinsamt men inte livshotande. "
;
++ myPocket: BagOfHolding, Component, RestrictedContainer
    '(byxor+nas) ficka+n*fickor+na' 'ficka'
    "En av sakerna du gillar med det här märket av khakis är att 
    de har trevliga, djupa fickor. "

    theName = 'din ficka'
    aName = 'din ficka'
    disambigName = 'din byxficka'

    /* we're restricted to pocketable items */
    canPutIn(obj) { return obj.okayForPocket; }
    cannotPutInMsg(obj) { return '{Ref dobj/han} skulle inte passa särskilt 
        bra i din ficka. '; }

    /* we have a high affinity for best-for-pocket items */
    affinityFor(obj) { return obj.bestForPocket ? 200 : 0; }

    contentsLister: thingContentsLister {
        showListPrefixWide(itemCount, pov, parent)
            { "I din ficka har du "; }
        showListPrefixTall(itemCount, pov, parent)
            { "I din ficka har du:"; }
    }
;

+ AlwaysWorn 'beige sport+iga långärmad+e knäppt+a skjorta+n'
    'beige skjorta'
    "Det är en knäppt långärmad sportskjorta i en ganska neutral beige färg. 
    Det är din typiska klädsel på kontoret de flesta dagar. "
;

+ myShoes: AlwaysWorn 'brun+a vänster höger par *läder:+skor+na'
    'par bruna läderskor'
    "Dina skor är av brunt läder, i en stil som är vardaglig men ändå inte för vardaglig.
    De är tillverkade av ett av de där märkena som befinner sig på gränsen mellan sneakers och riktiga skor."
;
+ myLeftShoe: PresentLater, AlwaysWorn 'brun+a vänster läder+sko+n'
    'vänster sko'
    "Det är en brun lädersko för vänster fot. "
;
++ Decoration 'läder+sko+n' 'sko'
    "Sko, singular. Du verkar bara ha en vänstersko nu. "
    isPlural = true
    notImportantMsg = 'Du verkar inte ha <q>skor</q> längre,
                       bara <q>sko.</q> '
;

/* ge oss några myggbett från början */
+ mosquitoBites: Decoration 'myggbett+en/bett+en' 'myggbett'
    "Du har varit en riktig myggmagnet här; för myggorna måste du
    vara exotisk utländsk mat. "
    isPlural = true
    notImportantMsg = 'Det finns inget du kan göra åt dem. '

    specialDesc = "Du har ganska många myggbett. "

    dobjFor(Scratch)
    {
        verify() { logicalRank(150, 'bites'); }
        action() { mainReport('Att klia dina myggbett känns bra
            för stunden, men du vet att det bara kommer göra det värre
            i längden. '); }
    }

    introOnly = true
;

+ contract: Readable 'kontrakt+et/avtal+et' 'kontrakt'
    "Detta är ett kontrakt för att tillhandahålla ett kompletterande styrsystem,
    samt tillhörande konsult- och underhållstjänster, till Statligt
    Kraftverk #6. Det är hela anledningen till varför du är här, och om du
    åker hem utan att få det underskrivet kommer din VP att bli rasande.
    Överste Magnxi klargjorde att hon inte kommer skriva på något
    förrän hon ser en fungerande demo av SCU:n---vilket är
    precis därför de skickade dig istället för en säljare. "
;
