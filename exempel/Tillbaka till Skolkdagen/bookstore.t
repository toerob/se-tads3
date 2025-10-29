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
bookstore: Room 'Bokhandel' 'bokhandeln'
    "Större delen av detta stora, ljusa utrymme är fyllt med låga bokhyllor
    i smala rader, men den främre delen är lite mer öppen, med böcker
    utställda på en rad bord. Utgången är åt sydost, och
    bredvid den finns kassan och ett litet tidningsställ. "

    vocabWords = 'bok|handel+n/bok|affär+en'

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
            "Du inser att du bär på obetalda varor;
            du bör inte gå härifrån förrän du har betalat för dem. ";
            
            /* stop the action short */
            exit;
        }

        /* 
         *   if there's anything already purchased on the counter, remind
         *   us to take it 
         */
        if (bookstoreCounter.contents.indexWhich({x: x.isPaidFor}) != nil)
            "Expediten ropar efter dig. <q>Herrn! Glöm inte ditt
            inköp!</q><.p>";
    }

    /* construct a list of all buyable objects in the bookstore */
    allBuyables = static (allInstancesWhich(
        Buyable, {x: x.bookstorePrice != nil}))
;

+ Fixture, Container 'litet lilla tidnings|ställ+et/korg+en/ben+et' 'tidningsställ'
    "Det är bara en liten korg på ben, med uppgift att hålla en hög
    vikta tidningar. "

    /* don't list my contents in the room description */
    contentsListed = nil
;
++ newspaper: Buyable, Readable
    'student+en kalifornien komisk+t tidning+en/papper+et/tech/exemplar+et/
    artikel+n/recension+en/serie+n*artiklar+na recensioner+na'
    '<i>California Tech</i>'
    "<i>California Tech</i> är studenttidningen. Den är
    bara på några sidor, så det skulle inte ta så lång tid att läsa den. "

    aName = 'ett exemplar av <i>California Tech</i>'

    readDesc = "Du bläddrar igenom de få sidorna i tidningen.
        Det finns en artikel om någon esoterisk politisk fråga
        i Ricketts, en annan om föreslagna ändringar i grundutbildningens
        humaniorakrav, en recension av en ny lokal restaurang,
        en annan om en teaterföreställning. Du läser igenom en rolig
        artikel om Jay Santoshnimoorthy, en nuvarande Darb, som kom
        med i Wayne Alders show (det sena kvällsprogrammet på kabel-tv)
        med sin fantastiska förmåga att programmera miniräknare. Under 
        showen, säger artikeln, programmerade han en enkel fyra-funktions
        soldriven miniräknare att uttala de små slagorden
        som Waynes programledare/sidekick Phil alltid säger. Det finns
        också en hemmagjord tecknad serie; I det här avsnittet deltar 
        karaktärerna i ett slags ekonomiskt experiment om sömnbrist. "

    /* it's bookstore merchandise, but it's free */
    bookstorePrice = 0
;

+ bookstoreClerk: Person 'äldre gänglig+a man+nen/expedit+en/kassör+en*män+nen personer+na' 'expedit'
    "Han är en äldre man, mycket lång och smal, som bär läsglasögon. "

    isHim = true
    actorHereDesc = "En expedit står bakom disken. "

    defaultGreetingResponse(actor)
    {
        if (bookstoreRegister.curBalance != 0)
            initiateConversation(nil, 'clerk-checkout');
        else
            "<q>Hej,</q> säger du.
            <.p><q>Välkommen till bokhandeln,</q> säger han. ";
    }

    dobjFor(Pay)
    {
        verify() { }
        action() { "Expediten pekar mot disken. <q>Lägg bara
            allt du vill köpa här till mig, så slår jag
            in det.</q> "; }
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
++ InitiallyWorn 'tunn+a små+a glas+et rektanglar+na läs|glasögon+en/båge+n/glas+en/trådbåge+n*bågar+na'
    'läsglasögon'
    "De är bara små tunna rektanglar av glas i en trådbåge. "
    isPlural = true
    isListedInInventory = nil
;
/* 
 *   if there are unpurchased things on the counter, they're the obvious
 *   thing to talk about if we just TALK TO CLERK 
 */
++ HelloTopic
    "<q>Hej,</q> säger du.
    <.p>Expediten tittar på dig över sina läsglasögon. <q>Hej.
    Vad kan jag hjälpa dig med?</q> "
;
+++ AltTopic
    "<q>Hej,</q> säger du.
    <.p><q>Hej igen,</q> säger expediten. <q>Redo att betala?</q>
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

    topicResponse = "<q>Är det här kassan?</q> frågar du expediten.
        <.p><q>Ja,</q> säger han och tittar över sina läsglasögon.
        <q>Lägg bara din beställning på disken, så slår jag in den.</q> "
;
++ AskTellShowTopic
    /* we match on anything buyable that's on the counter */
    matchObj = (bookstoreCounter.contents.subset({
        x: x.bookstorePrice not in (nil, 0) && !x.isPaidFor}))

    /* override the plain buyable topic by using a higher score */
    matchScore = 110

    topicResponse = "<q>Jag är redo att betala,</q> säger du.
        <.p><q>Okej,</q> säger expediten. Han tittar på kassan.
        <q>Det blir <<bookstoreRegister.curBalanceSpelled>>,
        tack.</q> "
;

++ AskTopic, SuggestedAskTopic 'köp+a( saker)?'
    "<q>Är det här kassan?</q> frågar du expediten.
    <.p>Han tittar på dig över sina läsglasögon. <q>Ja,</q> säger
    han. <q>Lägg bara din beställning på disken här så slår jag
    in den.</q> "

    name = 'buying things'
;
++ AskTellTopic [bookstore, bookstoreClerk]
    "<q>Arbetar du här?</q>
    <.p><q>Ja,</q> säger han. <q>Jag kan hjälpa dig med att betala
    när du är redo.</q> "
;

++ AskTellAboutForTopic +90
    [eeTextbookRecTopic, eeTextTopic, morgenBook,
     eeLabRecTopic, labManualTopic, townsendBook]
    "<q>Var har ni böckerna om elektroteknik?</q> frågar du.
    <.p>Expediten rycker på axlarna. <q>Tyvärr, </q> vi har mestadels
    slut på läroböcker för året.  Du kan kanske prova biblioteket. 
    Stor, hög byggnad, där bortåt.</q>  Han håller ut sin arm, 
    pekandes ungefär västerut.";

+++ AltTopic
    "<q>Kan du rekommendera en bra lärobok för elektroteknik?</q> frågar du.
    <.p>Han kliar sin haka. <q>Vi är mer eller mindre utsålda 
    på de flesta av våra läroböcker just nu,</q> säger han. <q>Du missade
    med ungefär åtta veckor.  Biblioteket bör ha allt du 
    behöver, dock.</q> Han håller ut sin arm och pekar ungefär västerut.
    <q>Det är den stora höga byggnaden en bit bort.</q> "

    isActive = gRevealed('need-ee-text')
;

++ AskTellTopic [bsBooks, physicsTextTopic, drdTopic,
                 bloemnerTopic, bloemnerBook]
    "<q>Jag letar efter en lärobok,</q> säger du.
    <.p>Expediten skakar på huvudet ursäktande. <q>Du är lite
    sent ute i terminen,</q> säger han. <q>Vi är mestadels utsålda för i
    år. Prova biblioteket.</q> Han pekar ungefär västerut. <q>Högt
    hus. Du kan inte missa det.</q> "
;

++ AskTellTopic @cxCard
    "<q>Tar ni Consumer Express?</q> frågar du.
    <.p><q>Sist jag kollade gjorde vi det,</q> säger han. <q>Jag har inte sett
    ett sådant på länge dock.</q> "
;
++ ShowTopic @cxCard
    "Du håller fram ditt kreditkort för expediten att se. <q>Tar ni
    Consumer Express</q> frågar du.
    <.p><q>Sist jag kollade gjorde vi det,</q> säger han. <q>Jag har inte sett
    ett sådant på länge dock.</q> "
;
++ DefaultGiveTopic
    "Expediten pekar på disken. <q>Lägg bara din beställning på
    disken här, så slår jag in den.</q> "
;
++ DefaultAnyTopic "Expediten bara hummar och pysslar med saker bakom
    disken. "
;
++ ConvNode 'clerk-checkout'
    npcGreetingMsg = "<.p><q>Är det allt?</q> frågar han. "
;
+++ YesTopic
    "<q>Det är allt,</q> säger du.
    <.p><q>Okej, det blir <<bookstoreRegister.curBalanceSpelled>>,</q>
    säger han och pekar på kassan. "
;
+++ NoTopic
    "<q>Inte riktigt än,</q> säger du.
    <.p><q>Okej, låt mig bara veta när du är klar,</q> säger han. "
;
++ GiveTopic, StopEventList @cxCard
    ['Du räcker över ditt kort. Expediten vänder på det ett par
    gånger och tittar noga på det, nästan misstänksamt. <q>Jag har inte
    sett ett sådant här på länge,</q> säger han. <q>Jag visste inte
    att de fortfarande tillverkade dem.</q> Han rycker på axlarna och drar det genom
    kassan, väntar sedan några ögonblick tills kassan börjar
    skriva ut ett kvitto. Han ger dig tillbaka kortet tillsammans med kvittot.
    <q>Tack för besöket,</q> säger han. ',
     'Du ger expediten ditt kort. Han drar det genom kassan,
     väntar på kvittot och ger dig kortet och kvittot.
     <q>Ha en bra dag,</q> säger han. ']
    
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

    "Du håller fram ditt kreditkort, men expediten ignorerar det.
    <q>Jag behöver det inte förrän jag har slagit in din beställning,</q>
    säger han. "

    /* until something's on the counter, this one takes precedence */
    isActive = (bookstoreRegister.curBalance == 0)
;

class BookstoreReceipt: Readable
    'bokhandels|kvitto+t*bokhandels|kvitton+a' 'bokhandelskvitto'
    "Det är en avlång <<receiptColor>>färgad papperslapp.  Kvittot lyder:
    <tt>
    \bCaltechs Bokhandel
    \b<<listLineItems()>>
    \bSkatt CA 8.25%\t\ <<totalTax>>
    \nTOTALT\t\t\t$<<totalPrice>>
    \nKredit - CUMEX 8771XXXXXXXXXXX
    \b** Tack!\ **
    \n** Välkommen Tillbaka **
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
    diffAdjs = ['vit', 'purpur', 'gul', 'grå', 'beige', 'lila',
                'chartreuse', 'lavendel', 'vinröds', 'rödbruns', 'cyan']

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
    'trång+a låg+a bok+serie+n/bord+et/rad+en
    bok+hylla+n/bok*bok+hyllor+na böcker borden+a rader+na'
    'bokhyllor'
    "Du märker att butiken inte har så mycket i form av läroböcker
    just nu; blandningen av böcker är mer som du skulle hitta i vilken
    vanlig bokhandel som helst. Det är logiskt med tanke på hur sent
    det är på läsåret; studenterna har redan köpt sina läroböcker för
    flera veckor sedan, och nästa års beställningar har inte lagts än. "
    
    isPlural = true

    cannotTakeMsg = 'Du bör nog motstå frestelsen att köpa
        en massa böcker just nu. Du kan komma tillbaka senare, efter
        att du är klar med skolkdagen, när du har lite ledig tid. '

    readDesc = "Du bör nog undvika att fastna i att bläddra
        här tills du är klar med skolkdagen. "

    dobjFor(Buy) asDobjFor(Take)

    dobjFor(PutOn)
    {
        verify() { }
        check()
        {
            "Bäst att inte lämna kvar saker här; någon
            kanske misstar dem för varor. ";
            exit;
        }
    }
    dobjFor(PutIn) asDobjFor(PutOn)
    
    lookInDesc = "Du vandrar genom bokraderna en liten
        stund. Du kan alltid hitta massor av intressanta böcker
        när du bläddrar i en bokhandel, men du ser inget du behöver för
        den aktuella uppgiften. "

    dobjFor(Enter) asDobjFor(LookIn)
    dobjFor(Board) asDobjFor(LookIn)
;
++ DefaultConsultTopic "Du letar igenom böckerna lite, men
    du ser inte vad du letar efter. "
;

+ bookstoreCounter: Fixture, Surface
    'lång+a betalning^s+disk+en' 'betalningsdisk'
    "Det är en lång disk med en kassaapparat i ena änden. "

    dobjFor(LookBehind) { action() { "Utrymmet bakom disken
        är endast till för anställda. "; } }

    iobjFor(PutOn)
    {
        check()
        {
            /* PUT CREDIT CARD ON COUNTER -> give it to clerk */
            if (gDobj == cxCard)
                replaceAction(GiveTo, cxCard, bookstoreClerk);

            /* vi kan bara lägga till saluförda varor här */
            if (gDobj.bookstorePrice == nil)
            {
                "{Det dobj} är inte till salu här; Bäst att inte blanda ihop saker och ting genom att lägga {det dobj/obj} på kassadisken. ";
                exit;
            }

            /* ...och bara om de inte redan har köpts */
            if (gDobj.isPaidFor)
            {
                "Du har redan betalat för {det dobj/honom}; det finns ingen anledning att
                betala för det igen. ";
                exit;
            }
        }
    }

    /* vid tillägg av objekt, lägg till pris till kassaregisterbalansen */
    notifyInsert(obj, newCont)
    {
        if (obj.bookstorePrice != nil)
        {
            gMessageParams(obj);
            if (obj.bookstorePrice == 0)
                "<q>Det är ingen kostnad för {det obj/honom} där,</q> säger
                expediten när du lägger {det/honom} på disken. ";
            else
                "När du lägger {det obj/honom} på disken, plockar expediten
                upp {det obj/honom}, vänder försiktigt på {det obj/honom}, och trycker på några knappar på kassaapparaten. ";

            /* lägg till priset till registertotalen */
            bookstoreRegister.curBalance += obj.bookstorePrice;

            /* 
             *   Om vi har något att checka ut, schemalägg utcheckning.
             *   (Schemalägg det till slutet av åtgärden, snarare än att
             *   göra det direkt - detta kommer att säkerställa att vi bara
             *   gör det en gång för denna tur, även om spelaren lägger en lista
             *   med objekt på disken med ett enda kommando.) 
             */
            if (bookstoreRegister.curBalance != 0)
                gAction.callAfterActionMain(checkoutNotifier);
        }
    }

    /*
     *   Utcheckningsnotifierare - detta är ett abstrakt objekt vi använder
     *   enbart för att registrera för afterActionMain-notifiering. Detta
     *   kallas i slutet av en åtgärd där vi lägger något köpbar på disken. 
     */
    checkoutNotifier: object {
        afterActionMain()
        {
            /* initiera utcheckningskonversationen */
            bookstoreClerk.initiateConversation(nil, 'clerk-checkout');
        }
    }

    /* vid borttagning av objekt, dra av pris från kassaregisterbalansen */
    notifyRemove(obj)
    {
        if (obj.bookstorePrice not in (nil, 0) && !obj.isPaidFor)
        {
            gMessageParams(obj);
            "Expediten gör ett litet <q>hmm</q>-ljud och trycker
            på några knappar på kassaapparaten. ";

            /* dra av priset från registertotalen */
            bookstoreRegister.curBalance -= obj.bookstorePrice;
        }
    }
;
++ bookstoreRegister: Decoration 'kassa+apparat+en' 'kassaapparaten'
    "Kassaapparaten visar för närvarande en total kostnad på $<<curBalanceString>>. "

    notImportantMsg = 'Som en del av standardprotokollet för shoppande,
        leker inte kunder med kassaapparater. '

    /* nuvarande balans */
    curBalance = 0

    /* nuvarande balans som en sträng */
    curBalanceString()
    {
        local total = (curBalance * 10825 + 5000) / 10000;
        local dollars = total / 100, cents = total % 100;

        return toString(dollars)
            + '.'
            + (cents < 10 ? '0' : '')
            + toString(cents);
    }

    /* nuvarande balans, utskriven */
    curBalanceSpelled()
    {
        local total = (curBalance * 10825 + 5000) / 10000;
        local dollars = total / 100, cents = total % 100;

        return spellInt(dollars)
            + ' '
            + (cents < 10 ? 'och ' : '')
            + spellInt(cents);
    }
;

+ Immovable 'ljus+a färgglad+a kartong+en skylt+en/bild+en' 'kartongskylt'
    "Skylten är ljus och färgglad. <q>Labbkompisar!</q> står skrivet
    med knubbiga gula bokstäver över en bild som visar många vänliga,
    förmänskligade djur. "
;
+ Fixture, Container, Consultable 'rutnät glänsande tråd utställningslåda+n' 'utställningslåda'
    "Lådan är gjord av ett rutnät av glänsande tråd och är ungefär
    en meter hög. En färgglad kartongskylt ovanför lådan
    utannonserar <q>Labbkompisar!</q> "

    specialDesc = "Bredvid ett av borden finns en utställningslåda
        fylld med gosedjur. "

    /* don't include my contents in the room description */
    contentsListed = nil

    /* 
     *   use special contents listers, to emphasize that our enumerated
     *   contents are over and above a background of numerous unlisted
     *   items 
     */
    descContentsLister: thingDescContentsLister {
        showListEmpty(pov, parent)
            { "Lådan innehåller många gosedjur. "; }
        showListPrefixWide(itemCount, pov, parent)
            { "Lådan innehåller massor av djur, inklusive "; }
    }
    lookInLister: thingLookInLister {
        showListEmpty(pov, parent)
            { "Lådan innehåller många gosedjur. "; }
        showListPrefixWide(itemCount, pov, parent)
            { "Lådan innehåller massor av djur, inklusive "; }
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
            logicalRank(70, 'i lådan');
    }
;
++ DefaultConsultTopic "Lådan är fylld med ett slumpmässigt urval
    av djur; det skulle ta för lång tid att gå igenom dem alla. "
;
++ Decoration 'gosedjur+en' 'gosedjur'
    "Lådan innehåller massor av gosedjur. "

    isPlural = true
    notImportantMsg = 'Lådan har många fler gosedjur än
        du skulle kunna hantera just nu. '

    dobjFor(Examine) remapTo(LookIn, location)
    dobjFor(ConsultAbout) remapTo(ConsultAbout, location, IndirectObject)
;

++ Buyable, Thing
    'plysch+ig mjuk rhesus leksak plysch-rhesus|apa+n/plyschrhesusapa+n/leksak+en/djur+et*leksaker+na djur+en'
    'plysch-rhesusapa'
    "Det är en söt liten uppstoppad mjukisapa. Du hoppas bara inte att de även inte
    säljer ett tillbehörsset med intrakraniella elektroder. "

    bookstorePrice = 1599
    bookstoreReceiptName = 'Plysch Apa'
    isPaidFor = nil
;

++ Buyable, Thing 'plysch+iga mjuk+a marsvin+et marsvins|leksak+en/leksaks|marsvin+et/leksaks|djur+et*leksaker+na djur+en'
    'marsvin av plysch'
    "Det är ett sött mjukismarsvin, nästan i naturlig storlek. "

    bookstorePrice = 1499
    bookstoreReceiptName = 'Plysch Marsvin'
    isPaidFor = nil
;

++ ratPuppet: Buyable, HandWearable
    'svart+a tjock+a plysch+iga mjuk+a råttaktig+a leksak+en
    handdocka+n/docka+n/leksak+en/djur+et/råtta+n/päls+en*leksaker+na*djur+en'
    'plyschråttleksak'
    "Det är en söt mjukisråtta, lite större än i naturlig storlek,
    med tjock svart päls. Den är något förmänskligad,
    men ganska realistisk.
    <.p>Vid närmare inspektion ser den ut att vara en handdocka - en öppning
    i botten låter dig stoppa in handen.
    << isIn(toyCar)
      ? "Den <q>bärs</q> för närvarande av en leksaksbil; den täcker större delen
        av bilen och så att endast hjulen sticker ut längst ner."
      : "">> "

    /* this is merchandise at the bookstore */
    bookstorePrice = 1249
    bookstoreReceiptName = 'Plysch Råtta'
    isPaidFor = nil

    dobjFor(Wear)
    {
        action()
        {
            /* do the normal work... */
            inherited();

            /* ...but customize the message if it succeeds */
            if (isWornBy(gActor))
                "Du placerar råttdockan över din hand. ";
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
                "Råttdockan har inte mycket utrymme inuti; den är
                inte utformad för att kunna förvara saker. ";
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
                "Du avlägsnar råttdockan från leksaksbilen. ";
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
                "Du vickar på fingrarna för att få råttans nos att rycka till. ";
                exit;
            }
        }
    }
;
+++ Component '(råtta) (docka) (handdocka) hand råttans öppning handrått:an^s+dock:an^s+öppning+en' 'råtthanddocksöppning'
    iobjFor(PutIn) remapTo(PutIn, DirectObject, location)
;