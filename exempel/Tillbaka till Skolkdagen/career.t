#charset "utf-8"
/*
 *   Copyright 2003, 2013 Michael J. Roberts
 *   
 *   Return to Ditch Day - career center office.
 */

#include <adv3.h>
#include <sv_se.h>
#include "ditch3.h"

/* ------------------------------------------------------------------------ */
/*
 *   The Career Center Office
 */
ccOffice: Room 'Karriärcenter' 'karriärcentret' 'kontor'
    "Detta rum verkar vara löst uppdelat i ett kontorsområde och ett
    offentligt område. Flera skrivbord är grupperade på ena sidan av rummet
    och utgör kontorsområdet. På andra sidan är ett par soffor (en stor och
    en liten) arrangerade i ett <q>L</q> runt ett fyrkantigt glasbord. Ett
    litteraturställ står nära sofforna.
    <.p>En dörr mot norr leder ut till lobbyn. "

    vocabWords = 'karriärcent:er+ret kontor+et'

    north = ccDoorN
    out asExit(north)

    /* flag: we've finished our appointment here */
    doneWithAppointment = nil

    /* on the first arrival, award points for finding our way here */
    afterTravel(traveler, conn)
    {
        scoreMarker.awardPointsOnce();
        inherited(traveler, conn);
    }
    scoreMarker: Achievement { +1 "hitta karriärcentret" }

    roomDaemon()
    {
        switch(turnsInRoom++)
        {
        case 3:
            "<.p>Kvinnan täcker telefonen med handen och säger
            högt till dig, <q>Ta det lugnt---jag kommer strax.</q> Hon återgår till sitt telefonsamtal. ";
            break;

        case 5:
            /* the return of Frosst Belker */
            "<.p>Du hör någon komma in genom dörren och tittar ditåt
            och ser en smal man i vit dubbelknäppt kavaj och
            vita byxor komma in i rummet. Du är nära att jämra dig 
            högt när du inser att det inte är någon annan än Frosst
            Belker. Man kan bara hoppas han inte är här för att intervjua samma
            student som du---det är svårt nog att slå dem i försäljning,
            det är ännu svårare att slå dem i rekrytering.
            <.p>Belker granskar rummet. Han tittar på kvinnan som är i
            telefon, sedan på dig, och ler sedan---inte varmt, inte som
            om han är glad att se dig, mer som om han vore road av ett privat
            skämt. <q>Herr Mittling,</q> säger han med sin lätta accent,
            <q>vilken trevlig överraskning. Våra respektive arbetsgivare
            har tydligen liknande smak när det gäller potentiella anställda såväl
            som klienter. Låt oss hoppas att vid detta tillfälle
            är din räckvidd mer i linje med ditt grepp, så att säga,
            än vad som så ofta har visat sig i våra tidigare möten.</q> ";

            /* move frosst here */
            frosst.moveIntoForTravel(self);

            /* make frosst 'him', since he's been mentioned prominently */
            me.setHim(frosst);
            break;

        case 6:
            /* give Ms. Dinsdale her folder */
            ccFolder.makePresent();

            /* set up everyone in conversation */
            ccDinsdale.initiateConversation(dinsdaleTalking, 'cc-welcome');
            frosst.setCurState(frosstTalking);

            /* this introduces her */
            ccDinsdale.setIntroduced();
            break;
        }
    }

    turnsInRoom = 0
;

+ ccDoorN: Door -> cssDoorS 'norr+a n dörr+en*dörrar+na' 'norra dörren'
    "Den leder norrut, tillbaka till lobbyn. "

    /* once we're here, don't leave until we finish our appointment */
    canTravelerPass(trav) { return location.doneWithAppointment; }
    explainTravelBarrier(trav)
    {
        reportFailure('Du bör verkligen inte gå någonstans förrän du har
            avslutat ditt möte här. ');
    }
;

+ Fixture, Chair
    'större stor+a soffa+n/*soffor+na*möbler+na' 'stora soffan'
    "Den skulle lätt kunna rymma tre eller fyra personer. "
    disambigName = 'större soffan'
;

+ Fixture, Chair
    'mindre lilla soffa+n/soffor+na*möbler+na' 'lilla soffan'
    "Den är tillräckligt stor för två eller tre personer. "
    disambigName = 'mindre soffan'

    dobjFor(SitOn)
    {
        /* 
         *   to avoid pointless disambiguation queries, arbitrarily pick
         *   the larger couch for 'sit on' 
         */
        verify()
        {
            inherited();
            logicalRank(90, 'välj valfri soffa');
        }
    }
;

+ Fixture, Surface 'fyrkant+igt fyrkantig+a glas+et soffbord+et/glas|skiva+n/glasbord+et*möbler+na' 'soffbordet'
    "Soffbordet har en glasskiva som är ungefär en och en halv meter på varje sida. "
;

+ Fixture, RestrictedContainer 'förkroma:t+de metall+en litteratur:en+ställ+et'
    'litteraturställ'
    "Det är ett förkromat metallställ designat för att visa upp tidskrifter eller liknande
    föremål, för närvarande används det för en samling glansiga broschyrer
    från företag som rekryterar på campus. "

    canPutIn(obj) { return obj.ofKind(RecruitingBrochure); }
    cannotPutInMsg(obj) { return 'Stället är bara för rekryterings-
        broschyrer; du vill inte röra till det genom att lägga
        något annat i det. '; }

    /* 
     *   don't list my contents in the room description (but note that our
     *   contents will still be listed when we're examined directly) 
     */
    contentsListed = nil

    /* customize our Examine contents listing slightly */
    descContentsLister: thingDescContentsLister {
        getFilteredList(lst, infoTab)
        {
            /* make sure our 'various brochures' item goes last */
            if (lst.indexOf(variousBrochures) != lst.length())
                lst = (lst - variousBrochures) + variousBrochures;

            /* otherwise use the standard handling */
            return inherited(lst, infoTab);
        }
        showListPrefixWide(itemCount, pov, parent)
            { "Stället visar upp "; }
    }
;

class RecruitingBrochure: Readable 'glansig+a rekrytering^s+broschyr+en*broschyrer';

++ RecruitingBrochure 'mortera+broschyr+en' 'Mortera-broschyr'
    "Broschyren visar bilder på överraskande många konsumentprodukter
    som Mortera tillverkar: <i>Manly</i> Cigaretter, <i>Fru Pillskrufts
    Gammaldags</i> serie av bearbetade kött- och ostprodukter,
    <i>Elefant</i> Cigaretter, den populära <i>Ellie Fant</i>
    karaktärsserien av gosedjur för småbarn och logoprodukter
    för tonåringar, <i>HemLuft</i> medicinska syrgasprodukter för hemsjukvård,
    <i>MassivMåltid</i> varumärke för frysta rätter, <i>Muffingården</i>
    konserverade bageriprodukter, <i>Jag Svälter!</i> varumärke för friterade salta
    snacks, <i>PassarBra-Plus</i> extra stora byxor och
    <i>UnderSvällning-Plus</i> extra stora underkläder, och många fler.
    Du hade ingen aning om hur många konsumentvarumärken detta företag äger; nu
    förstår du anledningen till det ganska nyliga namnbytet från
    J.R.R. Tobak. "
;

++ RecruitingBrochure 'toxicola+broschyr+en' 'ToxiCola-broschyr'
    "Det är ungefär vad man kan förvänta sig från dryckesbjässen. De verkar
    mest intresserade av kemi-doktorer. "
;

++ RecruitingBrochure 'locktheon+broschyr+en' 'Locktheon-broschyr'
    "Denna broschyr är rikt utsmyckad med spännande, actionfyllda
    militära foton: ett stridsflygplan som förbereds för start från
    däcket på ett hangarfartyg, en stridsvagn som rullar förbi en brinnande byggnad,
    en soldat i kemisk krigföringsdräkt som ger ett leende barn från en etnisk minoritet
    en liten amerikansk flagga, en missil som avfyras från
    däcket på ett slagskepp, en ubåt som bryter vattenytan.

    <.p><blockquote><font face='tads-sans'>
    <b><i>Locktheon: Farliga Vapen för en Farlig Värld</i></b>.   

    Här på <b><i>Locktheon</i></b>, är en stor del av vårt arbete <q>topphemligt,</q>
    men det finns en sak som inte är <q>topphemligt</q> i dessa dagar: det är att 
    världen är mer farofylld än någonsin. Krig, terrorism, och international pacifism 
    hotar Amerika och alla amerikaner som aldrig förut. Kontrollprotokoll för 
    oreglerade vapen gör det möjligt att--och även uppmuntrar--företag som <b><i>Locktheon</i></b> 
    att sälja några av de mest avancerade vapensystem som någonsin har byggts 
    till vilken liten smådiktator som helst. Här vid <b><i>Locktheon</i></b>, 
    så vet vi att de mest avancerade vapensystemen som håller Amerika tryggt idag 
    är samma förödande vapen som kommer hota Amerika imorgon.  Det är därför vi 
    på <b><i>Locktheon</i></b> aldrig kan sluta innovera.
    <.p><b><i>Locktheon: Exporterar Produkter, Inte Jobb</i></b>. Medan
    resten av företags-Amerika skickar jobb utomlands till billigare arbets-
    marknader, skapar <b><i>Locktheon</i></b> jobb samtidigt som de hjälper till att
    begränsa USA:s alarmerande handelsunderskott. <b><i>Locktheon</i></b>s
    försvarssystem är bland USA:s ledande exportvaror. Och tack vare
    <b><i>Locktheon</i></b>s branschledande lobbyverksamhet, bryter 
    Amerikas försvarsindustri ner handelsbarriärerna som en gång i tiden
    höll tillbaka Amerikansk konkurrenskraft genom att begränsa vad 
    Amerikas företag kunde sälja till smådiktaturer.
    <.p><b><i>Locktheon: Håller Amerika vid arbete</i></b>.  Amerika
    har världens starkaste, mest färgstarka frimarknadsekonomi, en 
    ekonomi som bygger på unika amerikanska värdegrunder: en ekonomi byggd 
    på unika amerikanska dygder: robust individualism,
    risktagande och ständig innovation. Men alla dessa dygder
    skulle inte betyda något utan den största amerikanska dygden av alla:
    offentliga utgifter. Hemligstämplad studie efter hemligstämplad 
    studie har bevisat att USA:s fria marknadsekonomi skulle kollapsa omedelbart
    utan miljarder och åter miljarder dollar i federala bidrag.
    Och dessa livsviktiga federala utgifter skulle inte vara möjliga utan
    företag som <b><i>Locktheon</i></b>. Tänk på det:
    i en värld utan dyra vapensystem skulle alla dessa otaliga
    federala miljarder behöva spenderas på något annat; ost,
    till exempel. Om regeringen skulle spendera samma mängd
    pengar på ost som den spenderar på bara en <b><i>Locktheon Liberation
    Star T-702GKV Global Kill Vehicle</i></b>, skulle den få tillräckligt med
    ost för att sträcka sig till månen och tillbaka---<i>sextiosju gånger</i>.
    De logistiska problemen med enbart lagring skulle lamslå USA:s
    ekonomi. Men tack vare den branschledande dollarkostnadsdensiteten hos
    <b><i>Locktheon</i></b>s avancerade försvarssystem är lagringsutrymme
    aldrig ett problem.
    <.p><b><i>Locktheon: Vi Bygger de Vapen som Skyddar Amerika
    från de Vapen som Vi Bygger.</i></b>
    </font></blockquote>
    <.p>Det bara går på och på så där. "
;

++ variousBrochures: Decoration
    'diverse andra annan glansig+a rekryterings|broschyr+en*rekryterings|broschyrer+na'
    'andra broschyrer'
    "De har alla det där släta, glansiga utseendet av en årsredovisning.
    Ingen av dem ser särskilt intressant ut; bara en massa
    försvarsentreprenörer, kemiska företag, chiptillverkare,
    och mjukvaruföretag. "

    /* 
     *   if we're alone on the rack, we're just 'various brochures';
     *   otherwise we're 'various other brochures' 
     */
    aName = (location.contents.length() == 1
             ? 'diverse broschyrer' : 'diverse andra broschyrer')
    theName = (aName)
    disambigName = 'en annan broschyr'
    isPlural = true
    notImportantMsg = 'Det finns för många av dem; det skulle ta hela
                       dagen att gå igenom alla, och ingen av dem
                       ser särskilt intressant ut. '

    /* 
     *   list me among the rack's contents when the rack is examined (but
     *   only when the rack itself is examined: don't list in the main
     *   room description, as it's too much detail for that level) 
     */
    isListedInContents = true
;
+ Decoration
    'vit+a plast+iga träfaner+iga skrivbord+et/topp+en*toppar+na möbler+na skrivborden+a' 'skrivborden'
    "Skrivborden är ganska vanlig typ av kontorsmöbler, träfaner
    med vita plasttoppar. De är grupperade tillsammans på ena sidan
    av rummet. Varje skrivbord är parat ihop med en stol. "
    isPlural = true
;

+ Decoration 'skrivbords|stol+en/kontorsstol+en*skrivbords|stolar+na*möbler+na' 'skrivbordsstolar'
    "De är bara vanliga kontorsskrivbordsstolar. "
    isPlural = true
;

+ Decoration 'telefon+en*telefoner+na' 'telefoner'
    "Varje skrivbord är utrustat med en telefon. "
    isPlural = true
;

+ ccDinsdale: IntroPerson 'fru+n dinsdale/kvinna+n*kvinnor'
    name = 'kvinna'
    properName = 'Fru Dinsdale'
    npcDesc = "Hon är en kort, kraftig kvinna i sena fyrtioårsåldern,
        byggd som en idrottslärare. Hon är klädd i en vit
        polotröja och mörka byxor, och hennes mörka men grånade
        hår är ordnat i en stram knut. "
    isHer = true
;
++ Component 'mörk+a gråna+de grå+tt grå+a stram+a stramt hår+et/knut+en' 'mörka hår'
    "Det är ordnat i en stram knut. "
;
++ InitiallyWorn 'vit+a polo+tröja+n' 'polotröja'
    "Det är en enkel vit polotröja. "
    isListedInInventory = nil
;
++ InitiallyWorn 'mörk+a svart+a marinblå+a *byxor+na' 'mörka byxor'
    "Byxorna är en av de där mörka färgerna som är svåra att skilja åt
    från varandra---marinblå, svart, något sådant. "
    isListedInInventory = nil
;

++ ccFolder: PresentLater, Thing 'manila+akt^s+mapp+en/manila-|akt+en' 'manilamapp'
    "Det är en tunn manilaaktsmapp. "
;
++ HermitActorState
    isInitState = true
    noResponse = "Du vill inte avbryta henne medan hon pratar i telefon. "
    stateDesc = "Hon sitter vid ett skrivbord och pratar i telefon. "
    specialDesc()
    {
        "En kvinna sitter vid ett av skrivborden och pratar
        i telefon. ";

        /* if we've never seen the PC before, note the arrival */
        if (!sawPC)
        {
            "Hon ser dig komma in, vinkar lite, och
            håller upp pekfingret i den vanliga <q>vänta ett
            ögonblick</q>-gesten. ";

            /* note that we've seen the PC come in now */
            sawPC = true;

            /* set 'her,' since we've been prominently mentioned */
            me.setHer(ccDinsdale);
        }
    }
    sawPC = nil
;

++ dinsdaleTalking: ActorState
    stateDesc = "Hon står här och pratar med dig. "
    specialDesc = "Fru Dinsdale står här och pratar med dig. "
;
+++ HelloTopic "Du har redan hennes uppmärksamhet. ";

++ workingAtDesk: ActorState
    stateDesc = "Hon sitter vid ett av skrivborden och arbetar. "
    specialDesc = "Fru Dinsdale sitter vid ett av skrivborden och arbetar. "
;

+++ DefaultAnyTopic
    "Hon verkar ganska upptagen, så du vill helst inte störa henne. "
;

++ ConvNode 'cc-welcome'
    npcGreetingMsg =
        "<.p>Kvinnan lägger på telefonen och går fram till dig och
        Belker med en manila-mapp i handen. Hon granskar er båda.
        <q>Skulle ni två vara...</q> Hon letar i sin mapp
        ett ögonblick, sedan fortsätter hon, <q>Belker och Mittling?</q>
        <.p><q>Ja, jag är Frosst Belker,</q> säger Belker och sträcker fram
        sin hand, som hon skakar raskt.
        <.p><q>Jag är Fru Dinsdale,</q> säger hon, <q>men ni kan kalla
        mig <q>frun.</q></q> Hon brister plötsligt ut i skratt,
        bokstavligen slår sig på knät och kastar huvudet bakåt, och
        sedan, lika plötsligt, är hon helt affärsmässig igen. <q>Nej, seriöst,
        <q>Fru Dinsdale</q> duger bra.</q> Hon vänder sig till dig.
        <q>Och du är alltså Mittling, från Omegatron?</q> "

    commonFollowup = "<.p>Hon tittar en gång till på sin mapp,
        talar medan hon bläddrar genom innehållet. <q>Och ni båda
        kom för att träffa Herr Stamer, ser jag.</q> Hon tittar upp och skakar
        på huvudet. <q>Tja,</q> säger hon i en irriterad ton, <q>skjut inte
        budbäraren, men jag är rädd att Stamer inte kommer att träffa er
        idag. Det verkar som om han hade något mer <q>viktigt</q> att
        göra, nämligen Skolkdagen. Jag antar att ingen av er har
        hört talas om det förut?</q><.convnode cc-ditch> "
;
// TODO... ovan
+++ YesTopic
    "<q>Det stämmer,</q> säger du och skakar hennes hand.
    <<location.commonFollowup>> "
;
+++ NoTopic
    "<q>Du kan kalla mig <b>Herr</b> Mittling,</q> säger du med ett leende,
    men hon verkar inte tycka att det är särskilt roligt. Hon bara stirrar på
    dig i flera sekunder.
    <<location.commonFollowup>> "
;
+++ DefaultAnyTopic
    "<q>Lugna dig, min vän,</q> säger Fru Dinsdale. <q>
    Låt oss se till att vi har alla detaljer på plats här.
    Du är Mittling, eller hur? Ja eller nej?</q><.convstay> "
;

++ ConvNode 'cc-ditch'
    commonFollowup()
    {
        "Denna <q>Skolkdag</q> skulle vara traditionen
        där sistaårseleverna överger campus för dagen, eller hur?
        Och lämnar efter sig alla möjliga kreativa krypton och utmaningar
        som kallas, tror jag, <q>staplar,</q> hmm? Ah, och
        underklassarna strävar alla efter att klara dessa utmaningar för att få
        tillgång till sistaårselevernas rum. Är jag korrekt informerad?</q>
        <.p><q>Japp,</q> säger Fru Dinsdale, <q>det är i princip så.</q>
        <.p><q>Nåväl,</q> säger Belker, <q>jag antar att vi ska boka nya
        möten med Herr Stamer?</q>
        <.p>Fru Dinsdale kommer närmare, talar nästan konspiratoriskt.
        <q>I ärlighetens namn, om jag vore ni, och han gjorde något sådant
        mot mig, skulle jag spola ner den lille skitungen i toaletten. 
        Titta på det här meddelandet han lämnade till er och säg mig om 
        det inte är det mest arroganta ni någonsin sett.</q> Hon räcker 
        en lapp till Belker; han läser den snabbt och ger den till dig. 
        <.reveal ditch-day-explained>
        <.convnode accept-stack-pre> ";

        stackNote.moveInto(me);
        me.setPronounObj(stackNote);
    }
;
+++ YesTopic
    "<q>Jag är faktiskt en alumn,</q> säger du.
    <.p><q>Bra,</q> svarar Fru Dinsdale. <q>Jag hatar att förklara saker.
    Belker, hur är det med dig?</q>
    <.p><q><<location.commonFollowup>> "
;
+++ NoTopic
    "<q>Jag är faktiskt en Caltech-alumn,</q> säger du, <q>men jag tror
    att du kanske måste förklara det för Herr Belker här.</q>
    <.p>Belker ler svagt. <q>Herr Mittling har en vana att
    underskatta mig, verkar det som. <<location.commonFollowup>> "
;
+++ DefaultAnyTopic
    "Du tror att hon väntar på ett ja-eller-nej-svar. Du vill helst
    inte byta ämne just nu, eftersom du behöver ta reda på vad som
    pågår.<.convstay> "
;

+++ stackNote: Readable
    'meddelande från (herr+en) (brian) (stamer)/meddelande+t/lapp+en/anteckning+en'
    'meddelande från Brian Stamer'
    "<font face='tads-sans'>Kära Fru Dinsdale,
    <.p>Ursäkta att jag överraskar dig med detta utan förvarning, men jag har en ovanlig
    begäran för representanterna från Mitachron och Omegatron. Jag skulle vilja be dem
    att försöka lösa min stapel. Om de gör det, kommer jag att ta ett jobb
    hos det vinnande företaget, förutsatt att de vill ge ett erbjudande. Förlåt
    om det verkar arrogant av mig att vilja intervjua intervjuarna på
    det här viset, men de flesta rekryterare jag har träffat hittills var inte tillräckligt
    tekniska för att kunna byta en glödlampa. Som du vet vill jag arbeta någonstans
    där jag kommer att vara omgiven av smarta människor, och jag tänkte att detta skulle vara
    ett bra filter.
    <br><br>---Brian (Dabney, rum 4)
    </font> "
    
    mainExamine()
    {
        /* 
         *   we want to initiate the conversation only if this is the first
         *   time we've been described - note the status before we show the
         *   desription 
         */
        local conv = (!described);
        
        /* do the normal work */
        inherited();

        /* initiate the conversation if this is the first time through */
        if (conv)
            ccDinsdale.initiateConversation(dinsdaleTalking, 'accept-stack');
    }

    /* it's not actually here yet */
    location = nil
;

++ ConvNode 'accept-stack-pre';
+++ AskTopic @stackNote
    "<q>Vad är det här för meddelande?</q> frågar du.
    <.p><q>Har du ens försökt läsa det?</q> frågar hon. <q>Oj, det har du visst inte.</q> "
;
+++ DefaultAnyTopic
    "Fru Dinsdale skakar på huvudet. <q>Läs bara meddelandet,</q> säger
    hon otåligt.<.convstay> "
;

class AcceptStackYes: SpecialTopic
    'acceptera utmaningen' ['ja','jag','acceptera', 'accepterar','godta', 'godtar', 'utmaningen','erbjudandet','den', 'tacka', 'ja', 'till']
    topicResponse()
    {
        "Du har inte direkt något val, givet Rubys personliga intresse 
        av att anställa Stamer; likväl, detta kan faktiskt bli kul. 
        <q>Räkna med mig,</q> säger du till Fru Dinsdale. ";

        if (!gRevealed('belker-accepted-stack'))
            "<.p>Belker skrockar.  <q>Jag accepterar också, så klart.</q>
            <.reveal belker-accepted-stack> ";

        "<.p>Hon ger er båda en chockad blick. <q>Verkligen? Tja,
        jag tror ni båda är galna, men jag antar att det är er ostkaka.
        Stamer bor i Dabney House, rum 4. Jag hoppas ni behöll
        campuskartorna jag skickade er för ni får inga nya.</q>
        Hon slår sig på knät igen och gapskrattar.

         <q>Nej, seriöst, 
         vi har slut på kartor.  Hursomhelst.  Jag tror Skolkdagen håller på 
         till fem i eftermiddag, så du har en hel dag att 
         göra vad du vill.</q> Hon skakar på hennes huvud, rullar ögonen, 
         ger dig och Belker en ironisk salut och återvänder till sitt skrivbord

        <.p>Belker tittar på henne, roat.  Han vänder sig slutligen till dig. 
        <q>Det verkar som vi än en gång befinner oss i vänlig rivalitet.</q>  
        Han plockar upp en mobiltelefon ur sin ficka och trycker frånvarande 
        in ett nummer.  <q>Må bäste man segra, som vanligt.</q>  Med ett 
        lite nasalt skrock, vänder han sig om och beger sig ut genom dörren, 
        pratandes i sin mobiltelefon.
        <.reveal stack-accepted> ";
    
        /* our appointment is now concluded */
        ccOffice.doneWithAppointment = true;

        /* set belker heading to the stack */
        frosst.setCurState(goingToStack);
        frosst.knownFollowDest = alley1N;

        /* send Ms. Dinsdale back to her desk, and discard her folder */
        ccDinsdale.setCurState(workingAtDesk);
        ccFolder.moveInto(nil);

        /* this counts toward our score */
        scoreMarker.awardPointsOnce();
    }

    scoreMarker: Achievement { +1 "acceptera Skolkdagsutmaningen" }
;

class AcceptStackNo: SpecialTopic, StopEventList
    'avböj utmaningen'
    ['nej','jag','avböjer','utmaningen', 'den', 'tacka', 'nej']
    eventList = [&firstResponse, &secondResponse, &thirdResponse]

    firstResponse()
    {
        "Du vill verkligen avböja och komma tillbaka senare för
        en normal intervju, men du tvekar. Om Belker bestämmer sig för att
        stanna här idag, du kanske inte får en annan chans till en
        intervju. Och Rudy verkade verkligen fast besluten att anställa
        Stamer.<.convstay> ";
    }

    secondResponse()
    {
        "Du tvekar igen; du känner att du är i en förlora-förlora
        situation här. Att lösa Stamers Skolkdagsstapel kunde vara
        kul, men det verkar knappast som rätt sätt att genomföra en
        jobbintervju. Ändå är det svårt att bara gå, med tanke på
        hur gärna Rudy vill anställa Stamer.<.convstay> ";
    }

    thirdResponse()
    {
        "<q>Jag tror jag kommer tillbaka när jag kan göra en normal
        intervju,</q> säger du.

        <.p><q>Vill du verkligen komma tillbaka och prata med den här
        förloraren?</q> frågar Fru Dinsdale. <q>Okej, om det är vad 
        du vill. Jag ska prata med Stamer för att boka en ny tid,
        och jag hör av mig.</q>

        <.p>Du har fortfarande några timmar kvar innan ditt flyg tillbaka, så
        du säger hej då och spenderar lite tid med att tura runt på campus.
        Det finns flera förändringar sedan du gick i skolan här,
        särskilt med all ny konstruktion i den norra delen av
        campus. Det är kul att se platsen igen och se hur
        den har vuxit.

        <.p>Ett par dagar går, sedan ringer någon från Career
        Center-kontoret dig på ditt kontor för att meddela att
        Brian Stamer tog ett jobb hos Mitachron.
        <<laterMsg>>
        Det är behöver knappast sägas att Carl och RudyB är mycket besvikna.
        Det är inte som att de kommer att avskeda dig, men det är onekligen
        ännu ett eländigt misslyckande, och den här gången kan du inte undvika
        känslan av att det fanns mer du kunde ha gjort. ";

        /* offer finishing options */
        finishGameMsg('DU HAR GETT UPP',
                      [finishOptionUndo, finishOptionFullScore,
                       finishOptionCredits, finishOptionCopyright]);
    }

    /* add-on message for what happens later */
    laterMsg = ""
;

++ ConvNode 'accept-stack'
    npcContinueMsg = "Belker skrockar. <q>Jag accepterar utmaningen,</q>
        säger han.
        <.p><q>Är du seriös?</q> frågar Fru Dinsdale. <q>Jag tror
        du är galen, men vad vet jag? Hur är det med dig, Mittling?</q>
        <.reveal belker-accepted-stack>
        <.convnode accept-stack2> "
;
+++ AcceptStackYes;
+++ AcceptStackNo
    laterMsg = "Det visar sig att Belker accepterade Stamers 
                Skolkdagsutmaning efter att du åkte. "
;
+++ DefaultAnyTopic
    "Du borde verkligen berätta för henne om du tänker acceptera
    Stamers utmaning eller inte.<.convstay> "
;

++ ConvNode 'accept-stack2'
    npcContinueList: StopEventList { [
        '<q>Hej, Mittling!</q> säger Fru Dinsdale. <q>Hur är det med dig?</q> ',

        '<q>Hallå-åå!</q> säger Fru Dinsdale och viftar med handen framför
        dina ögon som om du sover. ',

        '<q>Nå, Mittling, vad blir det?</q> säger Fru
        Dinsdale. '
    ] }
;
+++ AcceptStackYes;
+++ AcceptStackNo
    laterMsg = "Belker måste ha kunnat lösa stapeln, eller kanske
                han bara gav Stamer ett bra erbjudande. "
;
+++ DefaultAnyTopic
    "Du borde verkligen svara på hennes fråga först.<.convstay> "
;