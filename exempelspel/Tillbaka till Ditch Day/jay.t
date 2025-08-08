#charset "utf-8"
/*
 *   Copyright 2003, 2013 Michael J. Roberts
 *   
 *   Return to Ditch Day - Jay Santoshnimoorthy.  Jay programs the
 *   calculator for us to solve the Hovarth puzzle, but it takes a bit of
 *   interacting with him to get him to cooperate.  
 */

#include <adv3.h>
#include <sv_se.h>
#include "ditch3.h"


/* an unthing for jay, until he's present */
unJay: Unthing 'jay santoshnimoorthy' 'Jay' @alley4main
    isHim = true
    isProperName = true
    notHereMsg = 'Du vet inte hur Jay ser ut, så du skulle inte
        veta om han var här. '
;

jay: PresentLater, Person 'jay santoshnimoorthy' 'Jay' @alley4main
    "Hans längd och kroppsbyggnad och långa hår får honom att se ut som en
    surfare. Han bär en ljus hawaiiskjorta. "

    /* jay is just part of the crowd, so don't mention him separately */
    specialDesc = ""
    isHim = true
    isProperName = true

    /* 
     *   enter the conversation state automatically - we use this when we
     *   trigger a conversation entry via some other conversational event,
     *   such as asking the other students where jay is 
     */
    autoEnterConv()
    {
        /* 
         *   if our current state is a conversation-ready state, switch
         *   directly to the corresponding in-conversation state 
         */
        if (curState.ofKind(ConversationReadyState))
            setCurState(curState.inConvState);

        /* mark me as 'him' */
        gPlayerChar.setPronounObj(self);

        /* make me the interlocutor */
        noteConversation(gPlayerChar);
    }
;

+ InitiallyWorn 'ljus+a blommönst:er+rade färgglad+a aloha hawaii|skjorta+n' 'hawaiiskjorta'
    "Den färgglada skjortan är prydd med ett blommönster. "
    isListedInInventory = nil
;

+ InConversationState
    stateDesc = "Han står här och pratar med dig. "
;

/* ask jay about the stack */
++ AskTellShowTopic
    [stackTopic, a4Materials, a4Envelopes, a4Map, turboTopic]
    "<q>Vilken stapel är det här?</q> frågar du.
    <.p><q>Det är Turbo Power Animals-stapeln,</q> säger han.
    <q>Gå och kolla skylten.</q> Han pekar ner i korridoren
    västerut. "
;
+++ AltTopic, StopEventList
    ['<q>Finns det något jag kan göra för att hjälpa till med stapeln?</q> frågar du.
    <.p>Han tittar över papperen på bordet. <q>Alltså, vi har faktiskt
    ingen som jobbar med Turbo Power Squirrel. Vi har
    listat ut var han är---han är i Guggenheims vindtunnel.
    Vi behöver någon som kan ta sig dit upp och hämta tillbaka honom.</q>
    <.reveal squirrel-assigned> ',

     '<q>Hur går det med stapeln?</q> frågar du.
     <.p><q>Vi behöver fortfarande någon som kan hämta Turbo Power Squirrel,
     om du är intresserad,</q> säger han. <q>Vi tror att han är uppe
     i Guggenheims vindtunnel.</q> ']

    isActive = gRevealed('tpa-stack')
;
+++ AltTopic
    "<q>Hur går det med stapeln?</q> frågar du.
    <.p>Han rycker på axlarna. <q>Det skulle gå jättebra om du kunde hämta
    tillbaka Turbo Power Squirrel åt oss.</q> "

    isActive = gRevealed('squirrel-assigned')
;
+++ AltTopic
    "Du är lite tveksam till att fråga om stapeln igen;
    du är rädd att du kanske skulle få ytterligare ett uppdrag. "

    isConversational = nil
    isActive = gRevealed('squirrel-returned')
;

/* ask about turbo power squirrel is about like asking about the stack */
++ AskTellTopic @squirrel
    "<q>Var var den här ekorren jag ska hitta?</q> frågar du.
    <.p><q>Vi är ganska säkra på att han är i Guggenheims vindtunnel,</q> säger Jay.
    <q>Uppe på taket av Guggenheim.</q> "
    isActive = gRevealed('squirrel-assigned')
;
+++ AltTopic
    "<q>Hur mår Turbo Power Squirrel?</q> frågar du.
    <.p><q>Han är i säkerhet, tack vare dig!</q> säger Jay och ler. "
    isActive = gRevealed('squirrel-returned')
;

++ AskTellTopic @stamerStackTopic
    "Du frågar Jay om han har sett Stamers stapel. Han säger att han tittade på
    den och blev inte särskilt intresserad---han kallar den <q>ännu en tråkig
    svart låda-stapel.</q> "
;

/* once we assign the squirrel, guggenheim is a topic of interest */
++ AskTellTopic [guggenheimTopic, windTunnelTopic]
    "<q>Hur ska jag ta mig upp till vindtunneln?</q> frågar du.
    <.p>Han rycker på axlarna. <q>Jag hoppades att du skulle kunna lista ut det sjäv.</q> "
    isActive = gRevealed('squirrel-assigned')
;
+++ AltTopic
    "<q>Har du varit uppe i vindtunneln förut?</q> frågar du.
    <.p><q>Nix,</q> säger han. "
    isActive = (windTunnel.seen)
;

/* returning the squirrel */
++ GiveShowTopic @squirrel
    topicResponse()
    {
        "Du ger Jay actionfiguren av ekorren. <q>Men hallå! Det här är ju 
        fantastiskt!</q> Han tar ekorren och håller upp den så att alla
        kan se. <q>Turbo Power Squirrel är i säkerhet!</q> Alla jublar.
        Jay lägger figuren på bordet.
        <.reveal squirrel-returned> ";

        /* remove the squirrel from play */
        squirrel.moveInto(a4Table);

        /* award some points for this */
        scoreMarker.awardPointsOnce();
    }

    scoreMarker: Achievement { +5 "rädda Turbo Power Squirrel" }
;

/*
 *   Ask Jay about the calculator.
 *   
 *   - if we've already programmed it, explain the instructions again
 *   
 *   - if we've shown it to him before, just say there's nothing more to
 *   say
 *   
 *   - otherwise, ask to show him the calculator 
 */
+++ AskTellTopic @calculator
    "Du beskriver miniräknaren för Jay och frågar om han vet
    något om den.
    <.p><q>Låter ganska allmän,</q> säger han. <q>Kanske om jag
    fick ta en titt på den...</q> "
;
++++ AltTopic
    "Du frågar Jay om det finns något annat speciellt med
    miniräknaren. Han rycker bara på axlarna. "
    isActive = gRevealed('calc-to-jay')
;
++++ AltTopic
    "<q>Hur fungerar det där programmet du skrev nu igen?</q> frågar du.
    <.p>Jay pekar på <q>+</q>-knappen. <q>Mata bara in numret,
    sedan plus-plus-plus. Gör det direkt efter att du har fått igång
    kvantmaskinerna, så borde svaret komma upp direkt.</q> "
    
    isActive = (calculator.isProgrammed)
;


/*
 *   Give Jay the calculator.  There are several variations of this:
 *   
 *   - if we've already programmed the calculator, just re-explain how the
 *   programming works
 *   
 *   - if we've talked about hovarth numbers, AND we've shown him the
 *   article on macroscopic quantum computing, AND we've returned the
 *   squirrel, we're good to go
 *   
 *   - if we've talked about hovarth numbers AND we've shown him the QC
 *   article, but we haven't yet returned the squirrel, hold out for the
 *   squirrel
 *   
 *   - if we've only talked about hovarth numbers, explain that they're
 *   impossible to program (conventionally, anyway)
 *   
 *   - if we've only showed him the QRL article without talking about
 *   hovarth numbers, he's interested but has nothing to calculate
 *   
 *   - if we haven't done any of this, show off his prowess by playing a
 *   little tune 
 */
++ GiveShowTopic, StopEventList @calculator
    [&response1,
     'Du erbjuder Jay miniräknaren, men han tar inte emot den.
     <q>Jag vill inte skryta,</q> säger han.
     <.convnode jay-programming> ']

    response1()
    {
        "<q>Ta en titt på den här,</q> säger du och räcker Jay miniräknaren.
        <.p>Han vänder runt på den ett par gånger, slår på den och trycker på
        knapparna en stund. Miniräknaren börjar pipa en liten
        melodi. En av de andra studenterna stönar och försöker lekfullt
        ta miniräknaren från Jay, men Jay undviker honom.
        <.p><q>Uppmuntra honom inte,</q> säger den andre killen. <q>Han
        kan bara inte hålla sig från att visa upp sitt nördiga trick.</q>
        <.p>Jay skrattar. <q>Förlåt,</q> säger han. Han stänger av
        miniräknaren och lämnar tillbaka den.
        <.reveal calc-to-jay>
        <.convnode jay-programming> ";

        /* we mentioned that he turns off the calculator */
        calculator.makeOn(nil);
    }
;
+++ AltTopic
    "<q>Tror du att du skulle kunna programmera en Hovarth-funktion på min
    miniräknare?</q> frågar du.
    <.p><q>Det är meningslöst, kompis,</q> säger han. <q>Om du inte
    har, typ, ungefär tio upphöjt till fyrtio år att vänta på
    svaret.</q> "

    isActive = (gRevealed('hovarth-to-jay'))
;
+++ AltTopic
    "Du erbjuder miniräknaren till Jay, men han viftar bort den.
    <.p><q>Jag har fortfarande inte kommit på rätt problem,</q> säger han.
    <q>Vi behöver något intressant, något som du inte kan
    göra på en vanlig dator.</q> "

    isActive = (gRevealed('jay-ready-to-program'))
;
+++ AltTopic
    topicResponse()
    {
        "Du erbjuder Jay miniräknaren, men han tar inte emot den.
        <q>Vet du vad,</q> säger han. ";

        if (gRevealed('squirrel-assigned'))
            "<q>Kommer du ihåg Turbo Power Squirrel? Gå och hämta tillbaka honom
            från Guggenheims vindtunnel, så hjälper jag dig
            med att programmera din miniräknare.</q> ";
        else
            "<q>Vi behöver någon som kan rädda Turbo Power Squirrel. Vi har
            listat ut att han är i Guggenheims vindtunnel, men
            ingen har tid att gå och hämta honom. Om du kan gå
            och rädda honom och få med honom tillbaka hit, så kommer jag hjälpa dig
            med att programmera din miniräknare.</q>
            <.reveal squirrel-assigned> ";
    }
    isActive = (gRevealed('jay-ready-to-program')
                && gRevealed('hovarth-to-jay'))
;
+++ AltTopic
    topicResponse()
    {
        /* 
         *   if we've already talked about programming hovarth functions on
         *   the calculator, follow up on that thought; otherwise,
         *   introduce the idea here 
         */
        if (gRevealed('jay-ready-to-program-hovarth'))
            "Du räcker Jay miniräknaren. ";
        else
            "<q>Tror du att du skulle kunna programmera en kvant-Hovarth-
            funktion?</q> frågar du och räcker Jay miniräknaren.
            <.p><q>Det är en utmärkt idé, kompis,</q> säger han. ";
        
        "Han börjar trycka frenetiskt på knappsatsen med båda
        tummarna, nästan för snabbt för att kunna se. <q>Det här är perfekt,</q>
        säger han, fortfarande i full fart med att skriva. <q>Chipsetet i den här modellen har ett instabilt vippläge i studsfiltret som 
        används för knappen, och det kan vi utnyttja som en äkta 
        slumpkälla.</q>
        <.p>Han avslutar äntligen, och ler brett åt sitt hantverk.
        <q>Sådär,</q> säger han och lämnar tillbaka din miniräknaren.
        <q>Detta är det minsta jag kunde göra för mannen som räddade
        Turbo Power Squirrel.</q> Han pekar på <q>+</q>-
        knappen. <q>Allt du behöver göra är att mata in numret för
        Hovarth-funktionen, och sedan trycka på <q>plus</q> tre gånger
        i rad, riktigt snabbt. Så mata in numret, och tryck sedan
        plus-plus-plus. Se till att kvantgrejen är igång
        när du gör det. Resultatet borde komma fram direkt.</q> ";

        /* the calculator is now programmed */
        calculator.isProgrammed = true;

        /* leave it off, and clear the display */
        calculator.makeOn(nil);
    }
    
    isActive = (gRevealed('jay-ready-to-program')
                && gRevealed('hovarth-to-jay')
                && gRevealed('squirrel-returned'))
;
+++ AltTopic
    "<q>Hur fungerar det program du skrev igen?</q> frågar du.
    <.p>Jay pekar på <q>+</q>-knappen. <q>Skriv bara in numret,
    sedan plus-plus-plus. Gör det direkt efter att du har fått igång
    kvantmaskinerna, så borde svaret komma fram direkt.</q> "
    
    isActive = (calculator.isProgrammed)
;

++ GiveShowTopic @drdBook
    topicResponse()
    {
        /* just handle this with ASK JAY ABOUT HOVARTH NUMBERS */
        replaceAction(AskAbout, jay, hovarthTopic);
    }
;

/*
 *   If we ask Jay about Hovarth numbers (or the DRD), mention that he
 *   knows about them, but leave it at that.  If we're ready to program the
 *   calculator, take it as a suggestion. 
 */
++ AskTellShowTopic, StopEventList [hovarthTopic, drdTopic, drdBook]
    ['<q>Har du hört talas om Hovarth-tal?</q> frågar du.
    <.p><q>Ja, absolut,</q> säger han. <q>Vi hade en fysikläxa
    för några veckor sedan som bara handlade om Hovarth-tal.
    Riktigt plågsamt.</q>
    <.reveal hovarth-to-jay>
    <.convnode jay-programming> ',

     '<q>Du sa förut att du känner till Hovarth-tal?</q> frågar du.
     <.p><q>Ja, från en fysikkurs.</q>
     <.convnode jay-programming> ']
;
+++ AltTopic
    "<q>Har du hört talas om Hovarth-tal?</q> frågar du.
    <.p><q>Javisst,</q> säger han. <q>Vet du, det är ett perfekt problem
    för en kvantdator. Jag skulle kunna försöka programmera det om du ger
    mig en miniräknare.</q>
    <.reveal hovarth-to-jay>
    <.reveal jay-ready-to-program-hovarth> "

    isActive = gRevealed('jay-ready-to-program')
;
+++ AltTopic
    "<q>Så du tror att du kan programmera en Hovarth-lösare åt mig?</q> frågar du.
    <.p><q>Jag tror det,</q> säger han. <q>Ge mig en miniräknare så ska
    jag försöka.</q> "
    
    isActive = gRevealed('jay-ready-to-program-hovarth')
;
+++ AltTopic
    "Du frågar Jay om Hovarth-beräkningen, och han förklarar
    igen hur man använder miniräknarprogrammet han skrev åt dig: mata
    bara in numret och tryck på <q>+</q>-knappen tre gånger i rad. "

    isActive = (calculator.isProgrammed)
;

/* talk about the newspaper article */
++ AskTellGiveShowTopic @newspaper
    "<q>Jag såg artikeln om dig i <i>Tech</i>,</q> säger du.
    <q>Kan du verkligen programmera <i>vilken</i> miniräknare som helst?</q>
    <.p>Jay rycker på axlarna. <q>Jag vet inte. Jag har inte hittat något
    motexempel än.</q>
    <.convnode jay-programming> "
;
+++ AltTopic
    "<q>Det var en jättebra artikel om dig i <i>Tech</i>,</q>
    säger du.
    <.p>Jay ler. <q>Tack,</q> säger han. "

    isActive = gRevealed('jay-ready-to-program')
;

/* 
 *   A conversation node for programming the calculator.  We'll come here
 *   after we talk about the calculator, hovarth numbers, or the newspaper
 *   article - basically, anything that would lead us to talking about
 *   programming the calculator to do the hovarth calculation.  We never
 *   come here if we've already talked about programming the calculator,
 *   since it's redundant with that previous conversation.  
 */
++ ConvNode 'jay-programming'
    /* always show topic inventory on entry */
    autoShowTopics = true
;

+++ AskTellTopic, SuggestedAskTopic, StopEventList @programmingHovarthTopic
    ['<q>Skulle du kunna programmera en Hovarth-funktion på min miniräknare?</q>
    frågar du.
    <.p>Jay ser förbryllad ut. <q>Öh, kompis, är du från vettet?
    Jag menar, jag <i>skulle kunna</i>, men ingen har den sortens tid. Vi
    pratar om universums värmedöd här.</q>
    <.reveal hovarth-to-jay> ',

     '<q>Jag behöver verkligen en Hovarth-funktion programmerad på min miniräknare,</q>
     säger du.
     <.p>Jay skakar på huvudet. <q>Det vore meningslöst,</q> säger han.
     <q>Solen skulle gå supernova innan programmet någonsin blev klart.</q> ']

    name = 'programmera hovarth-tal'
;
++++ AltTopic
    "Du är inte riktigt säker på vad du ska fråga honom, eftersom du inte har
    något lämpligt att programmera just nu. "

    isActive = (!calculator.isIn(me))
;

/* 
 *   The article about the quantum calculator.  We need to show this to Jay
 *   to explain about how to turn the calculator into a hovarth machine.
 *   But we can't just tell him about it; if we do, just ask to show it.  
 */
++ AskTellTopic [qrl739a, qrl739aTopic]
    "Du berättar lite för Jay om artikeln.
    <.p><q>Låter coolt,</q> säger han. <q>Jag skulle gärna läsa den, om du
    har en kopia.</q><.reveal 739a-to-jay> "
;
+++ AltTopic
    "Du har egentligen inget att berätta för Jay om den, eftersom du
    inte har läst den själv. "
    isActive = (!gRevealed('qc-calculator-technique'))
;
+++ AltTopic
    "<q>Vad tycker du om den där kvantdatorartikeln?</q> frågar du.
    <.p><q>Det är ultraskumma grejer,</q> säger han. "
    isActive = (gRevealed('jay-ready-to-program'))
;

/* the other QRL article is semi-interesting also */
++ AskTellTopic [qrl7011c, qrl7011cTopic]
    "Du sammanfattar artikeln för Jay. Han rycker på axlarna. <q>Kvantdatorer
    är coola,</q> säger han. <q>Jag har tänkt läsa på om det.</q> "
;
+++ AltTopic
    "Du nämner artikeln för Jay. <q>Det där kvantgrejet är
    helt bisarrt,</q> säger han och skakar på huvudet. "
    isActive = (gRevealed('jay-ready-to-program'))
;

++ AskTellTopic @quantumComputingTopic
    "<q>Vet du något om kvantdatorer?</q> frågar du.
    <.p><q>Inte mycket,</q> säger han. <q>Låter väldigt coolt dock. Jag har
    letat efter bra läsmaterial om det.</q> "

    isActive = (!gRevealed('jay-ready-to-program'))
;
++ AskTellTopic @qubitsTopic
    "<q>Har du någonsin hört talas om <q>QUBITS</q>?</q> frågar du.
    <.p>Han rycker på axlarna. <q>Det är väl något kvantdatorgrejer,
    eller hur? Vet inte mycket om det, men det låter coolt. Jag har
    tänkt hitta något bra att läsa om det.</q> "

    isActive = (!gRevealed('jay-ready-to-program'))
;

/* QRL 70:11c has some quantum computing stuff, but it's not very concrete */
++ GiveShowTopic @qrl7011c
    "Du räcker Jay artikeln, och han skummar igenom den snabbt.
    <q>Det här är ganska abstrakt teoretiskt, kompis,</q>
    säger han och lämnar tillbaka tidskriften. <q>Jag har tänkt
    läsa om kvantdatorer, men, alltså, något mer
    <i>konkret</i>.</q> "
;
+++ AltTopic
    "Du erbjuder Jay artikeln, men han viftar bort den. <q>Min hjärna
    är full, kompis,</q> säger han. "
    isActive = gRevealed('jay-ready-to-program')
;

/*
 *   The quantum calculator article.  The first time we show this, we'll
 *   take the article, spend a few turns reading it, and then we'll be
 *   ready to do the programming.  
 */
++ GiveShowTopic @qrl739a
    topicResponse()
    {
        if (!gRevealed('739a-to-jay'))
            "<q>Du kanske finner det här är intressant,</q> säger du och erbjuder
            tidskriften till Jay.
            <.p>Han tar den och skummar igenom sammanfattningen. <q>Hm,</q>
            säger han, sätter sig sedan ner och börjar läsa igenom
            artikeln. ";
        else
            "Du räcker Jay tidskriften. Han sätter sig ner och börjar läsa
            igenom artikeln. ";

        /* give him the article */
        qrl739a.moveInto(jay);

        /* sit him down */
        jay.moveInto(a4mChair);
        jay.posture = sitting;

        /* start him reading */
        jay.setCurState(jayReading);

        /* set up an agenda item to finish the reading */
        jay.addToAgenda(jayDoneReading.setDelay(3));
    }
;
+++ AltTopic
    "Du erbjuder Jay artikeln, men han säger att han inte behöver
    läsa om den. "

    isActive = gRevealed('jay-ready-to-program')
;

/* we can get a pointer to Scott here */
++ AskTellTopic [scottTopic, posGame]
    "<q>Har du sett Scott någonstans?</q> frågar du.
    <.p><q>Öh, jag tror jag såg honom i en jättestor kycklingdräkt i
    Gränd Tre,</q> säger han. "
;

++ DefaultAnyTopic, ShuffledEventList
    ['<q>Jag är lite upptagen här,</q> säger han. ',
     'Precis när du ska till att prata, ställer någon annan en
     fråga till honom, du bestämmer dig för att inte avbryta. ',
     'Han blir distraherad av något på kartan för
     ett ögonblick och ignorerar vad du sa. ']

    isConversational = nil
;

/* the initial ready-for-conversation state */
++ jayGroundState: ConversationReadyState
    isInitState = true
    stateDesc = "Han är upptagen med att arbeta på stapeln. "
;
+++ HelloTopic
    "<q>Hej, Jay,</q> säger du.
    <.p>Jay lägger undan några papper och vänder sig bort från bordet
    för att prata. <q>Tjena,</q> säger han. "
;
+++ ByeTopic
    "Jay går tillbaka till bordet. "
;

/* a state for jay, while he's busy reading the journal */
+ jayReading: HermitActorState
    stateDesc = "Han läser en artikel. "
    noResponse = "Han verkar vara för djupt inne i sin läsning för att ens lägga märke till dig. "
;

/* an agenda item for jay, for when he's finished reading */
+ jayDoneReading: DelayedAgendaItem
    invokeItem()
    {
        local calc, hov;
        
        /* get up */
        jay.moveInto(alley4main);
        jay.posture = standing;

        /* 
         *   if the PC isn't present, note that we finished while he was
         *   out, but don't finish yet 
         */
        if (!me.isIn(alley4main))
        {
            /* note that we finished while the PC was out */
            finishedWhilePcOut = true;

            /* go back to our normal state */
            jay.setCurState(jayGroundState);

            /* we're done */
            return;
        }

        /* return the journal */
        qrl739a.moveInto(me);

        /* return to the conversational state */
        jay.setCurState(jayGroundState.inConvState);

        /* 
         *   use the appropriate message, depending on whether the PC was
         *   present or not when we first finished 
         */
        if (finishedWhilePcOut)
            "<.p>Jay ser dig och kommer fram för att prata. <q>Här,</q> säger
            han, <q>jag är klar med artikeln.</q> Han räcker dig
            tidskriften. ";
        else
            "<.p>Jay reser sig upp och räcker dig tidskriften. ";

        /* continue the discussion */
        "<q>Det där är ganska bisarra grejer. Jag undrar om det skulle
        fungera på riktigt?";

        /* have we seen the calculator and/or Hovarth numbers? */
        calc = gRevealed('calc-to-jay');
        hov = gRevealed('hovarth-to-jay');
        if (calc && hov)
            "</q> Han funderar på något i några ögonblick, sedan ler han.
            <q>Du, det skulle vara perfekt för Hovarth-tal! Jag kanske
            skulle kunna programmera din miniräknare att räkna ut Hovarth-av-X, och vi
            skulle sedan kunna testa det.<.reveal jay-ready-to-program-hovarth>";
        else if (calc)
            " Jag kanske skulle kunna programmera din miniräknare att göra någon
            slags omöjlig beräkning så vi kunde testa det. Men
            vad skulle vara en vettig sak att beräkna?";
        else if (hov)
            "</q> Han funderar på något i några ögonblick. <q>Du,
            Hovarth-tal skulle vara ett bra test för det här. Jag kanske skulle kunna
            programmera en miniräknare att räkna ut Hovarth-av-X. Vi skulle behöva hitta
            en miniräknare först dock.<.reveal jay-ready-to-program-hovarth>";
        else
            " Jag kanske skulle kunna programmera en miniräknare att göra någon 
            slags omöjlig beräkning. Vi skulle behöva hitta en miniräknare först
            dock, och vi skulle behöva ha något intressant att beräkna.";

        /* finish up */
        "</q><.reveal jay-ready-to-program> ";

        /* this agenda item is now finished */
        isDone = true;
    }

    /* flag: we finished while the PC was out */
    finishedWhilePcOut = nil
;
