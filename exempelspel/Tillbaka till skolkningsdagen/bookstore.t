#charset "utf-8"
/*
 *   Copyright 2003, 2013 Michael J. Roberts
 *   
 *   Return to Ditch Day - the book store.
 */

#include <adv3.h>
#include <sv_se.h>
#include "ditch3.h"

/* ------------------------------------------------------------------------ */
/*
 *   The bookstore
 */
bookstore: Room 'Bookstore' 'the bookstore'
    "Most of this large, bright space is crammed with low bookshelves
    in narrow rows, but the front part is a little more open, with books
    displayed on a series of tables.  The exit is southeast, and
    next to it is the check-out counter and a small newspaper stand. "

    vocabWords = '(book) bookstore/store'

    southeast = quad
    out asExit(southeast)

    /* 
     *   before leaving, check to make sure we don't have unpurchased
     *   merchandise 
     */
    beforeTravel(traveler, connector)
    {
        local lst;

        /* if the PC isn't traveling, don't worry about it */
        if (!traveler.isActorTraveling(me))
            return;

        /* get a list of carried merchandise */
        lst = me.allContents().subset(
            {x: x.bookstorePrice not in (nil, 0) && !x.isPaidFor});

        /* if we found anything, say so, and stop the travel */
        if (lst.length() != 0)
        {
            /* complain about it */
            "You realize you're carrying unpurchased merchandise;
            you shouldn't leave until you pay for it. ";
            
            /* stop the action short */
            exit;
        }

        /* 
         *   if there's anything already purchased on the counter, remind
         *   us to take it 
         */
        if (bookstoreCounter.contents.indexWhich({x: x.isPaidFor}) != nil)
            "The clerk calls after you.  <q>Sir! Don't forget your
            purchase!</q><.p>";
    }

    /* construct a list of all buyable objects in the bookstore */
    allBuyables = static (allInstancesWhich(
        Buyable, {x: x.bookstorePrice != nil}))
;

+ Fixture, Container 'small newspaper stand/basket/legs' 'newspaper stand'
    "It's just a little basket on legs, for holding a stack of
    folded newspapers. "

    /* don't list my contents in the room description */
    contentsListed = nil
;
++ newspaper: Buyable, Readable
    'student california comic paper/newspaper/tech/copy/
    article/articles/reviews/strip'
    '<i>California Tech</i>'
    "The <i>California Tech</i> is the student newspaper.  It's
    only a few pages, so it wouldn't take long to read. "

    aName = 'a copy of the <i>California Tech</i>'

    readDesc = "You glance through the few pages of the paper.
        There's an article on some esoteric matter of politics
        in Ricketts, another on proposed changes to the undergrad
        humanities requirements, a review of a new local restaurant,
        another of a Theater Arts play.  You read through an amusing
        article about Jay Santoshnimoorthy, a current Darb, who got
        on the Wayne Alders show (the late-night cable talk show)
        with his amazing ability to program pocket calculators.  On
        the show, the article says, he programmed a basic four-function
        solar-powered calculator to speak the little catch-phrases
        that Wayne's announcer/sidekick Phil is always saying.  There's
        also a home-grown comic strip; in this episode, the characters
        are in some kind of sleep-deprivation economics experiment. "

    /* it's bookstore merchandise, but it's free */
    bookstorePrice = 0
;

+ bookstoreClerk: Person 'older lanky man/clerk/cashier*men*people' 'clerk'
    "He's an older man, very lanky, wearing reading glasses. "

    isHim = true
    actorHereDesc = "A clerk is standing behind the counter. "

    defaultGreetingResponse(actor)
    {
        if (bookstoreRegister.curBalance != 0)
            initiateConversation(nil, 'clerk-checkout');
        else
            "<q>Hi,</q> you say.
            <.p><q>Welcome to the bookstore,</q> he says. ";
    }

    dobjFor(Pay)
    {
        verify() { }
        action() { "The clerk indicates the counter.  <q>Just put
            anything you want to buy here for me, and I'll ring
            it up.</q> "; }
    }

    dobjFor(PayFor) asDobjFor(Pay)

    beforeAction()
    {
        /* do the normal work */
        inherited();

        /* explain about BUY X */
        if (gActionIs(Buy))
            replaceAction(Pay, self);
    }
;
++ InitiallyWorn 'thin little wire reading rectangles/frame/glass/glasses'
    'reading glasses'
    "They're just thin little rectangles of glass in a wire frame. "
    isPlural = true
    isListedInInventory = nil
;
/* 
 *   if there are unpurchased things on the counter, they're the obvious
 *   thing to talk about if we just TALK TO CLERK 
 */
++ HelloTopic
    "<q>Hi,</q> you say.
    <.p>The clerk looks at you over his reading glasses. <q>Hello.
    What can I do for you?</q> "
;
+++ AltTopic
    "<q>Hi,</q> you say.
    <.p><q>Hello again,</q> the clerk says. <q>Ready to check out?</q>
    <.convnode clerk-checkout> "
    isActive = (bookstoreRegister.curBalance != 0)
;

/* 
 *   asking about unpurchased goods elicits some kind of response; if the
 *   goods are on the counter, it initiates check-out 
 */
++ AskTellShowTopic
    /* we match on anything buyable */
    matchObj = (bookstore.allBuyables)

    topicResponse = "<q>Is this the check-out counter?</q> you ask
        the clerk.
        <.p><q>Yes,</q> he says, looking over his reading glasses.
        <q>Just put your order on the counter, and I'll ring it up.</q> "
;
++ AskTellShowTopic
    /* we match on anything buyable that's on the counter */
    matchObj = (bookstoreCounter.contents.subset({
        x: x.bookstorePrice not in (nil, 0) && !x.isPaidFor}))

    /* override the plain buyable topic by using a higher score */
    matchScore = 110

    topicResponse = "<q>I'm ready to checkout,</q> you say.
        <.p><q>Okay,</q> the clerk says.  He looks at the register.
        <q>That'll be <<bookstoreRegister.curBalanceSpelled>>,
        please.</q> "
;

++ AskTopic, SuggestedAskTopic 'buying( things)?'
    "<q>Is this the check-out counter?</q> you ask the clerk.
    <.p>He peers at you over his reading glasses. <q>Yes,</q> he
    says. <q>Just put your order on the counter here and I'll
    ring it up.</q> "

    name = 'buying things'
;
++ AskTellTopic [bookstore, bookstoreClerk]
    "<q>Do you work here?</q>
    <.p><q>Yes,</q> he says. <q>I can help you with checking out
    when you're ready.</q> "
;
++ AskTellAboutForTopic +90
    [eeTextbookRecTopic, eeTextTopic, morgenBook,
     eeLabRecTopic, labManualTopic, townsendBook]

    "<q>Where do you keep electrical engineering books?</q> you ask.
    <.p>The clerk shrugs. <q>Sorry,</q> he says. <q>We're mostly
    sold out of textbooks for the year.  You might try the
    library.  Big, tall building, thataway.</q>  He holds out
    his arm, pointing roughly west. "
;
+++ AltTopic
    "<q>Could you recommend a good electrical engineering
    textbook?</q> you ask.
    <.p>He scratches his chin. <q>We're more or less out of stock
    on most of our textbooks right now,</q> he says. <q>You missed
    by about eight weeks.  The library should have anything you
    need, though.</q> He holds out his arm and points roughly west.
    <q>It's the big tall building a ways thataway.</q> "

    isActive = gRevealed('need-ee-text')
;
++ AskTellTopic [bsBooks, physicsTextTopic, drdTopic,
                 bloemnerTopic, bloemnerBook]
    "<q>I'm looking for a textbook,</q> you say.
    <.p>The clerk shakes his head apologetically. <q>You're a little
    late in the term,</q> he says.  <q>We're mostly sold out for this
    year.  Try the library.</q>  He points roughly west. <q>Tall
    building.  Can't miss it.</q> "
;

++ AskTellTopic @cxCard
    "<q>Do you take Consumer Express?</q> you ask.
    <.p><q>Last I checked, we did,</q> he says. <q>I haven't seen
    one of those in a long time, though.</q> "
;
++ ShowTopic @cxCard
    "You hold out your credit card for the clerk to see.  <q>Do you
    take Consumer Express</q> you ask.
    <.p><q>Last I checked, we did,</q> he says. <q>I haven't seen
    one of those in a long time, though.</q> "
;
++ DefaultGiveTopic
    "The clerk points to the counter. <q>Just put your order on
    the counter here, and I'll ring it up.</q> "
;
++ DefaultAnyTopic "The clerk just hums and fusses with things behind
    the counter. "
;
++ ConvNode 'clerk-checkout'
    npcGreetingMsg = "<.p><q>Is that everything?</q> he asks. "
;
+++ YesTopic
    "<q>That's it,</q> you say.
    <.p><q>Okay, that'll be <<bookstoreRegister.curBalanceSpelled>>,</q>
    he says, pointing to the register. "
;
+++ NoTopic
    "<q>Not quite yet,</q> you say.
    <.p><q>Okay, just let me know when you're ready,</q> he says. "
;
++ GiveTopic, StopEventList @cxCard
    ['You hand over your card.  The clerk turns it over a couple of
    times, looking at it carefully, almost suspiciously.  <q>I haven\'t
    seen one of these in a long while,</q> he says.  <q>I didn\'t know
    they still made them.</q>  He shrugs and runs it through the
    register, then waits a few moments until the register starts
    printing a receipt.  He hands you back the card along with the
    receipt.
    <q>Thanks for coming in,</q> he says. ',
     'You give the clerk your card.  He runs it through the register,
     waits for the receipt, and hands you the card and the receipt.
     <q>Have a good day,</q> he says. ']
    
    handleTopic(fromActor, topic)
    {
        local priceList;
        
        /* do all the normal work (including showing our script response) */
        inherited(fromActor, topic);

        /* start with an empty price list */
        priceList = new Vector(bookstoreCounter.contents.length());

        /* mark the items on the counter as purchased */
        foreach (local cur in bookstoreCounter.contents)
        {
            /* if it's purchasable, mark it as purchased */
            if (cur.bookstorePrice not in (nil, 0)  && !cur.isPaidFor)
            {
                /* mark it as paid for */
                cur.isPaidFor = true;

                /* add it to the price list for the receipt */
                priceList.append(cur.bookstoreReceiptName);
                priceList.append(cur.bookstorePrice);
            }
        }

        /* create the receipt and give it to the PC */
        new BookstoreReceipt(priceList, bookstoreRegister.curBalance)
            .moveInto(me);

        /* 
         *   set the register balance to zero, as there are no unpurchased
         *   items on the counter now 
         */
        bookstoreRegister.curBalance = 0;
    }
;
+++ AltTopic
    "You hold out your credit card, but the clerk ignores it.
    <q>I don't need that until after I've rung up your order,</q>
    he says. "

    /* until something's on the counter, this one takes precedence */
    isActive = (bookstoreRegister.curBalance == 0)
;

class BookstoreReceipt: Readable
    'bookstore slip/paper/receipt*slips*receipts' 'bookstore receipt'
    "It's a narrow <<receiptColor>> slip of paper.  It reads:
    <tt>
    \bCaltech Bookstore
    \b<<listLineItems()>>
    \bTax CA 8.25%\t\ <<totalTax>>
    \nTOTAL\t\t\t$<<totalPrice>>
    \nCredit - CUMEX 8771XXXXXXXXXXX
    \b** Thank You!\ **
    \n** Come Again **
    </tt> "

    /* the plural name doesn't include the differentiating color */
    pluralName = 'bookstore receipts'

    /* 
     *   These aren't true equivalents, but list them as though they were.
     *   This ensures that we show 'three bookstore receipts' rather than
     *   listing them individually, but this is only for listing, so it
     *   doesn't affect their distinguishability in the parser. 
     */
    listWith = static [new ListGroupEquivalent()]

    /* we can put these in our wallet or pocket */
    okayForWallet = true
    okayForPocket = true

    /* list the line items */
    listLineItems()
    {
        for (local i = 1, local len = lineItems.length() ; i <= len ; i += 2)
        {
            /* 
             *   format this item (the extra '\ ' is to line up with the
             *   dollar sign in the total; we'reusing a monospaced <TT>
             *   font, so things should line up visuall if we make the line
             *   lengths equal 
             */
            "<<lineItems[i]>>\t\t\ <<lineItems[i+1]>> T\n";
        }
    }

    /* the total price, the tax, and the line items */
    totalPrice = nil
    totalTax = nil
    lineItems = nil

    /* differentiating color for the receipt */
    receiptColor = nil

    /* class-level variable with total number of receipts issued */
    totalReceipts = 0

    /* 
     *   Differentiating adjectives we add to the names, to allow
     *   disambiguation of the receipts as distinct objects.  (We can't
     *   simply make them indistinguishables, because they really are all
     *   different.)  We don't need very many of these, since there's not
     *   all that much we can buy; at most, we need one per purchasable
     *   item.  
     */
    diffAdjs = ['white', 'pink', 'yellow', 'gray', 'beige', 'mauve',
                'chartreuse', 'lavender', 'burgundy', 'maroon', 'cyan']

    /* we always create these dynamically */
    construct(prices, total)
    {
        /* inherit the standard base class handling */
        inherited();
        
        /* format and remember the total price and tax */
        totalTax = formatPrice((total * 825 + 5000) / 10000);
        totalPrice = formatPrice((total * 10825 + 5000) / 10000);

        /* format the price list entries */
        for (local i = 2, local len = prices.length() ; i <= len ; i += 2)
            prices[i] = formatPrice(prices[i]);

        /* remember the price list */
        lineItems = prices.toList();

        /* give myself a differentiating adjective */
        local diff = diffAdjs[++BookstoreReceipt.totalReceipts];

        /* add it to my disambiguation name and my dictionary entry */
        disambigName = diff + ' ' + name;
        cmdDict.addWord(self, diff, &adjective);

        /* remember my color for descriptive purposes */
        receiptColor = diff;
    }

    /* format a price as ###.## */
    formatPrice(p)
    {
        /* convert to a string */
        p = toString(p);

        /* insert the decimal point */
        p = p.substr(1, p.length() - 2) + '.' + p.substr(p.length() - 1);

        /* add extra leading spaces as neeed */
        if (p.length() < 6)
            p = makeString('\ ', 6 - p.length()) + p;

        /* return the result */
        return p;
    }
;

+ bsBooks: CustomImmovable, Readable, Consultable
    'narrow low book series/table/tables/row/rows/
    bookshelf/bookshelves/shelf/shelves/book*books'
    'bookshelves'
    "You notice that the store isn't stocking much in the way of textbooks
    right now; the mix of books is more like you'd find in any ordinary
    bookstore.  That makes sense given how late it is in the academic year;
    students will have finished purchasing their textbooks weeks ago, and
    next year's orders won't have been placed yet. "
    
    isPlural = true

    cannotTakeMsg = 'You should probably resist the temptation to buy
        a bunch of books right now.  You can come back later, after
        you\'re done with Ditch Day, when you have some free time. '

    readDesc = "You should probably avoid getting sucked into browsing
        here until you're done with Ditch Day. "

    dobjFor(Buy) asDobjFor(Take)

    dobjFor(PutOn)
    {
        verify() { }
        check()
        {
            "Better not leave things lying around here; someone
            might mistake them for merchandise. ";
            exit;
        }
    }
    dobjFor(PutIn) asDobjFor(PutOn)
    
    lookInDesc = "You wander through the rows of books for a little
        while.  You can always find plenty of interesting books
        browsing in a bookstore, but you see nothing you need for
        the task at hand. "

    dobjFor(Enter) asDobjFor(LookIn)
    dobjFor(Board) asDobjFor(LookIn)
;
++ DefaultConsultTopic "You search through the books a bit, but
    you don't see what you're looking for. "
;

+ bookstoreCounter: Fixture, Surface
    'long check-out counter' 'check-out counter'
    "It's a long counter with a cash register at one end. "

    dobjFor(LookBehind) { action() { "The area behind the counter
        is for employees only. "; } }

    iobjFor(PutOn)
    {
        check()
        {
            /* PUT CREDIT CARD ON COUNTER -> give it to clerk */
            if (gDobj == cxCard)
                replaceAction(GiveTo, cxCard, bookstoreClerk);

            /* we can only put for-sale items here */
            if (gDobj.bookstorePrice == nil)
            {
                "{That's dobj} not for sale here; better not confuse
                matters by putting it on the check-out counter. ";
                exit;
            }

            /* ...and only if they haven't already been purchased */
            if (gDobj.isPaidFor)
            {
                "You've already paid for {that dobj/him}; no need to
                pay for it again. ";
                exit;
            }
        }
    }

    /* on adding objects, add price to cash register balance */
    notifyInsert(obj, newCont)
    {
        if (obj.bookstorePrice != nil)
        {
            gMessageParams(obj);
            if (obj.bookstorePrice == 0)
                "<q>There's no charge for {that obj/him},</q> the
                clerk says as you put {it/him} on the counter. ";
            else
                "As you put {the obj/him} on the counter, the clerk picks
                it up, carefully turns it over, and punches some keys on
                the cash register. ";

            /* add the price to the register total */
            bookstoreRegister.curBalance += obj.bookstorePrice;

            /* 
             *   If we have anything to check out, schedule check-out.
             *   (Schedule it for the end of the action, rather than just
             *   doing it directly - this will ensure that we only do it
             *   once for this turn, even if the player is putting a list
             *   of objects on the counter with a single command.) 
             */
            if (bookstoreRegister.curBalance != 0)
                gAction.callAfterActionMain(checkoutNotifier);
        }
    }

    /*
     *   Checkout notifier - this is an abstract object we use purely to
     *   register for afterActionMain notification.  This is called at the
     *   end of an action where we put something buyable on the counter. 
     */
    checkoutNotifier: object {
        afterActionMain()
        {
            /* initiate the checkout conversation */
            bookstoreClerk.initiateConversation(nil, 'clerk-checkout');
        }
    }

    /* on removing objects, deduct price from cash register balance */
    notifyRemove(obj)
    {
        if (obj.bookstorePrice not in (nil, 0) && !obj.isPaidFor)
        {
            gMessageParams(obj);
            "The clerk makes a little <q>hmm</q> sound and punches
            some keys on the cash register. ";

            /* deduct the price from the register total */
            bookstoreRegister.curBalance -= obj.bookstorePrice;
        }
    }
;
++ bookstoreRegister: Decoration 'cash register' 'cash register'
    "The cash register is currently displaying a total of $<<
      curBalanceString>>. "

    notImportantMsg = 'As a matter of standard shopping protocol,
        customers don\'t play with cash registers. '

    /* current balance */
    curBalance = 0

    /* current balance as a string */
    curBalanceString()
    {
        local total = (curBalance * 10825 + 5000) / 10000;
        local dollars = total / 100, cents = total % 100;

        return toString(dollars)
            + '.'
            + (cents < 10 ? '0' : '')
            + toString(cents);
    }

    /* current balance, spelled out */
    curBalanceSpelled()
    {
        local total = (curBalance * 10825 + 5000) / 10000;
        local dollars = total / 100, cents = total % 100;

        return spellInt(dollars)
            + ' '
            + (cents < 10 ? 'oh-' : '')
            + spellInt(cents);
    }
;

+ Immovable 'colorful cardboard sign/picture' 'cardboard sign'
    "The sign is bright and colorful.  <q>Lab Pals!</q> is emblazoned
    in pudgy yellow letters over a picture showing numerous friendly,
    anthropomorphized animals. "
;
+ Fixture, Container, Consultable 'grid shiny wire display bin' 'display bin'
    "The bin is made of a grid of shiny wire, and it stands about
    three feet high.  A colorful cardboard sign above the bin
    announces <q>Lab Pals!</q> "

    specialDesc = "Next to one of the tables is a display bin
        filled with stuffed animals. "

    /* don't include my contents in the room description */
    contentsListed = nil

    /* 
     *   use special contents listers, to emphasize that our enumerated
     *   contents are over and above a background of numerous unlisted
     *   items 
     */
    descContentsLister: thingDescContentsLister {
        showListEmpty(pov, parent)
            { "The bin contains numerous stuffed animals. "; }
        showListPrefixWide(itemCount, pov, parent)
            { "The bin contains lots of animals, including "; }
    }
    lookInLister: thingLookInLister {
        showListEmpty(pov, parent)
            { "The bin contains numerous stuffed animals. "; }
        showListPrefixWide(itemCount, pov, parent)
            { "The bin contains lots of animals, including "; }
    }

    /* treat SEARCH <self> as FIND <nothing> IN <self> */
    dobjFor(Search) remapTo(ConsultAbout, self, resolvedTopicNothing)

    verifyRemove(obj)
    {
        /* 
         *   reduce the likelihood of TAKE and PUT IN slightly for things
         *   in the bin; we're more likely to want to take something lying
         *   around or on the counter 
         */
        if (gActionIs(Take) || gActionIs(PutIn))
            logicalRank(70, 'in bin');
    }
;
++ DefaultConsultTopic "The bin is stuffed with a random assortment
    of animals; it would take too long to go through them all. "
;
++ Decoration 'stuffed animals' 'stuffed animals'
    "The bin contains lots of stuffed animals. "

    isPlural = true
    notImportantMsg = 'The bin has many more stuffed animals than
        you could handle right now. '

    dobjFor(Examine) remapTo(LookIn, location)
    dobjFor(ConsultAbout) remapTo(ConsultAbout, location, IndirectObject)
;

++ Buyable, Thing
    'plush stuffed rhesus toy monkey toy/animal*toys*animals'
    'plush rhesus monkey'
    "It's a cute little stuffed monkey.  You kind of hope they don't
    sell an intracranial electrode accessory kit. "

    bookstorePrice = 1599
    bookstoreReceiptName = 'Plsh Mnky'
    isPaidFor = nil
;

++ Buyable, Thing 'plush stuffed guinea toy pig toy/animal*toys*animals'
    'plush guinea pig'
    "It's a cute stuffed guinea pig, almost life-sized. "

    bookstorePrice = 1499
    bookstoreReceiptName = 'Plsh GP'
    isPaidFor = nil
;

++ ratPuppet: Buyable, HandWearable
    'black thick plush stuffed rat toy
    hand-puppet/puppet/toy/animal/rat/fur*toys*animals'
    'plush rat toy'
    "It's a cute stuffed rat, a little larger than life-sized,
    with thick black fur.  It's slightly anthropomorphized,
    but reasonably realistic.
    <.p>On closer inspection, it looks to be a hand-puppet---an opening
    in the bottom lets you put your hand in.
    << isIn(toyCar)
      ? "It's currently being <q>worn</q> by a toy car; it covers most
        of the car, leaving only the wheels sticking out the bottom."
      : "">> "

    /* this is merchandise at the bookstore */
    bookstorePrice = 1249
    bookstoreReceiptName = 'Plsh Rat'
    isPaidFor = nil

    dobjFor(Wear)
    {
        action()
        {
            /* do the normal work... */
            inherited();

            /* ...but customize the message if it succeeds */
            if (isWornBy(gActor))
                "You put the rat puppet on your hand. ";
        }
    }

    iobjFor(PutIn)
    {
        remap = (gDobj == myHands ? [WearAction, self] : nil)
        verify() { }
        check()
        {
            if (gDobj != toyCar && gDobj != myHands)
            {
                "The rat puppet doesn't have much room inside; it's
                not designed to hold things. ";
                exit;
            }
        }
        action() { replaceAction(PutOn, self, toyCar); }
    }

    /* 
     *   when we're on the car, dropping the rat or putting it in
     *   something else maps to handling the car 
     */
    dobjFor(Drop) maybeRemapTo(isIn(toyCar), Drop, location)
    dobjFor(PutIn) maybeRemapTo(isIn(toyCar), PutIn, location, IndirectObject)
    dobjFor(PutOn) maybeRemapTo(isIn(toyCar), PutOn, location, IndirectObject)
    dobjFor(ThrowAt) maybeRemapTo(isIn(toyCar),
                                  ThrowAt, location, IndirectObject)

    dobjFor(Take)
    {
        action()
        {
            local wasInCar = isIn(toyCar);
            
            /* now do the normal work */
            inherited();
            
            /* 
             *   if this removed us from the car, say so conspicuously,
             *   since it might not be obvious that we didn't simply pick
             *   up the rat/car combo 
             */
            if (wasInCar && !isIn(toyCar))
                "You remove the rat puppet from the toy car. ";
        }
    }

    beforeAction()
    {
        /* do the normal work */
        inherited();
        
        /* 
         *   if we move our hand around with the puppet on, make the rat
         *   wiggle 
         */
        if (gActionIs(Move) && isWornBy(gActor))
        {
            /* 
             *   if plisnik is here, make this equivalent to SHOW RAT TO
             *   PLISNIK 
             */
            if (gActor.canSee(plisnik))
                replaceAction(ShowTo, self, plisnik);
            else
            {
                "You wiggle your fingers to make the rat's nose twitch. ";
                exit;
            }
        }
    }
;
+++ Component '(rat) (puppet) (hand-puppet) hand opening' 'rat puppet opening'
    iobjFor(PutIn) remapTo(PutIn, DirectObject, location)
;

