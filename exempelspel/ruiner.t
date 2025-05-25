#charset "utf-8"
#include <adv3.h>
#include <sv_se.h> 

#define __DEBUG
#include "../debug.h"

#define MAX_SCORE 30;

versionInfo: GameID
    IFID = '952c94dd-f92a-4970-9a00-cdcc24d038a1'
    name = 'RUINER'
    byline = 'by Angela M. Horns.'
    htmlByline = 'by <a href="mailto:yourmail@address.com"></a>'
    version = '1'
    authorEmail = 'Tomas yourmail@address.com'
    desc = 'Ett Interaktivt bearbetat exempel'
    htmlDesc = 'Ett Interaktivt bearbetat exempel'
;

// TODO: "Det var kolsvart."
modify DarkRoom
    roomDarkDesc = "Åldrarnas mörker pressar sig in på dig, och du känner dig klaustrofobisk.";
;

gameMain: GameMainDef
    maxScore = 30
    usePastTense = true
    initialPlayerChar = player

// [ Initialise;
//         TitlePage();
//         StartDaemon(sodium_lamp);
//         thedark.description =
//             "Åldrarnas mörker pressar sig in på dig, och du känner dig klaustrofobisk.";

//         "^^^Dagar av sökande, dagar av törstigt hackande genom skogens törnbuskar, men äntligen belönades ditt tålamod. En upptäckt!^";
// ];

    showIntro() {
        "\b\b\bDagar av sökande, dagar av törstigt hackande genom skogens törnbuskar, men äntligen belönades ditt tålamod. En upptäckt!\b";
    }
;


/*
! ---------------------------------------------------------------------------- !
!       This version recreated by Roger Firth in May 2001, using the simple
!       (albeit time-consuming) process of combining the various fragments
!       of "Ruins" quoted in Edition 4/1 of the Inform Designer's Manual.
!       
!                       SPELARE
!                             lampa,uppslagsverk,karta
!                       STORA TORGET
!                           | svamp,förpackningsväska,kamera,nyhetstidning,trappor
!                           |
!                           |
!                       FYRKANTIG KAMMARE -------------------- MASKKAST
!                           | inskriptioner,solljus,(nyckel)         äggsäck
!                           |
!                           |
!                       BÖJD KORRIDOR
!                           | statyett,dörr
!                           |
!                           |
!   ÖVRE DALGÅNG        HELGEDOM
!       | boll           /     \ målningar,altare,mask(präst)
!       |     ----------         ----------
!       |   /                               \
!   XIBALBÁ                                 FÖRRUM
!       | stela                                 | cage,skeletons,(warthog)
!       |                                       |
!       |                                       |
!   LOWER CANYON                            Gravschakt
!       | chasm                                   vaxkaka
!       |
!       |
!   PIMPSTENSAVSATS
!         ben
!
! ---------------------------------------------------------------------------- !
*/




player: Actor 'du' 'du' @forest;

forest: OutdoorRoom '"STORA TORGET"' 'stora torget'
"Eller så kallar i alla fall dina anteckningar denna låga branta sluttning av kalksten, men nu har regnskogen har tagit tillbaka det. Mörka olivträd tränger in från alla sidor, luften ångar av dimma från ett nyligt varmt regn, myggor hänger i luften. ~Struktur 10~ är en ruta av murverk som kan en gång i tiden har varit en begravningspyramid. Få saker har överlevt förutom de stenhuggna trappstegen som leder ner i mörkret nedanför."
    down = steps
    in = steps
    up: NoTravelMessage {
        "Träden är taggiga och du skulle skära upp dina händer fullständigt om du försökte klättra i dem. "
    }
    cannotGoThatWayMsg = 'Regnskogen är tät, och du har inte hackat dig igenom den i flera dagar för att överge din upptäckt nu. Vad du behöver göra är att hitta ett par riktigt bra fynd att ta med tillbaka till civilisationen innan du kan rättfärdiga att ge upp expeditionen. '
    brightness = 2
;
+SimpleNoise 'djungel+n' 'djungeln' 
    "Vrålapor, fladdermöss, papegojor, aror.";

// TODO: kontrollera att det blir rätt adjektiv och inte bara substantiv:
// TODO: >ta svamp "Du hade redan de fläckiga svampar." 
//          borde bli: >ta svamp "Du hade redan de fläckiga svamparna."
// Ska du hade redan ha bestämd form istället? 

+ mushroom: Food 'fläckig[-a] svamp+en padd+svamp+en fläckig[-a] svampar[-na]' 'fläckiga svampar'
    "Svampen är täckt med fläckar, och du är inte alls säker på att det inte är en paddsvamp.",
    theName = 'de fläckiga svamparna'
    isQualifiedName = 'de fläckiga svamparna'
    isPlural=true
    mushroomPicked = nil
    initSpecialDesc = 'På en lång stjälk i den genomdränkta jorden växer en fläckig svamp.'
    
    okayTakeMsg {
        if (mushroomPicked) {
            "Du plockar upp den långsamt sönderfallande svampen. ";
            return;
        } 
        mushroomPicked = true;
        "Du plockar svampen och klyver snyggt dess tunna stjälk. ";
    }
    okayDropMsg {
        "Svampen faller till marken, något skadad. ";
    }
    okayEatMsg {
        steps.rubbleFilled = nil;
        "Du gnager på ett hörn, oförmögen att spåra källan till en
        skarp smak, distraherad av en ara som flyger över huvudet
        som tycks brista ut ur solen, ljudet av dess vingslag
        nästan öronbedövande, sten faller mot sten.";
    }
;



// NEXT

+ packingCase: Heavy, OpenableContainer 'packväska+n/väska+n/pack/låda+n' 'packväska'
    initSpecialDesc =  "Din packväska ligger här, redo att fyllas med alla viktiga kulturella fynd du kan göra, för transport tillbaka till civilisationen."
    dobjFor(Remove) asDobjFor(Take)
    dobjFor(PushTravel) asDobjFor(Take)
    dobjFor(Take) {
        check() {
            "Väskan är för tung för att flytta på, så länge din expedition fortfarande är ofullständig.";
        }
    }
;

++ camera: Thing  'våtplåts plåt våt våtplåtskamera+n/kamera+n' 'våtplåtskamera'
"En otymplig, robust, envis träinramad våtplåtsmodell: som alla arkeologer har du ett kärleks-hatförhållande till din kamera."
;

++ newspaper: Thing 'en månad gammal tidning+en/times/' 'en månad gammal tidning'
    "~The Times~ från 26 februari 1938, på en gång fuktig och skör efter en månads exponering för klimatet, vilket är ungefär hur du känner dig själv. Kanske är det dimma i London. Kanske finns det bomber."
;


+ steps: StairwayDown  -> stepsBottom 'sten huggen huggna stenhuggen stenhuggna trappsteg+en/steg+en/stenstege+n/trappsteg+en/stentrapp+en/tio/10/pyramid/begravning[-splats]/struktur+en' 'stenhuggna trappsteg'
    desc {
        if (self.rubbleFilled) {
            "Rasmassorna blockerar vägen efter bara några steg.";
            return;
        }
        "De spruckna och slitna trappstegen leder ner till en
                dunkel kammare. Dina fötter kanske ";

        if (gPlayerChar.hasSeen(squareChamber)) {
            "är de första att beträda";
        } else {
            "har varit de första att ha beträtt";
        }

        " dem på femhundra år. På det översta trappsteget är glyfen Q1 inristad. ";
    }
    isPlural = true
    rubbleFilled = true
    
    travelBarrier : TravelBarrier {
        canTravelerPass(t) { 
            return !steps.rubbleFilled; 
        }
        explainTravelBarrier(t) {
            "Rasmassorna blockerar vägen efter bara några steg.";
        }
    }
;


squareChamber:  Room 'Fyrkantig Kammare' 'fyrkantiga Kammaren'
    "En nedsänkt, dyster stenkammare, tio meter tvärs över. En stråle solljus skär in från trappstegen ovan, vilket ger kammaren ett diffust ljus, men i skuggorna leder låga överliggande dörröppningar åt öster och söder in i templets djupare mörker."
    up = stepsBottom
    east = wormcast
    south = corridor

    dobjFor(PutIn) {
        action() {
            if (gDobj == eggsac && gIobj == sunlight) {
            eggsac.moveInto(nil);
            stone_key.moveInto(self);
            "Du släpper äggsäcken i skenet av solljusstrålen. Den bubblar obscent, sväller och brister sedan i hundratals små insekter som springer åt alla håll in i mörkret. Endast stänk av slem och en märklig gul stennyckeln återstår på kammarens golv.";
            }
        }
    }
;

+stepsBottom: StairwayUp 'sten huggen huggna stenhuggen stenhuggna trappsteg+en/steg+en/stenstege+n/trappsteg+en/stentrapp+en/tio/10/pyramid/begravning[-splats]/struktur+en' 'stenhuggna trappsteg'
    desc {
        "De spruckna och slitna trappstegen leder ner till en
        dunkel kammare. Dina fötter kanske har varit de första att ha beträtt dem på femhundra år. På det översta trappsteget är glyfen Q1 inristad. ";
    }
    isPlural = true
;    

+ sunlight: Thing 'solljusstråle+n/strål+en' 'solljusstråle';

// TODO: alternativ syntax stråle+n stråle+n
//+ sunlight2: Thing 'stråle+n' 'solljusstråle';

corridor: Room 'Böjd Korridor+en' 'böjda korridoren'
    north = squareChamber
;
+ StoneDoor: Thing 'stendörr+en' 'stendörr';

shrine: Room 'Helgedom+en' 'helgedomen';
+ paintings: Thing 'målning+ar' 'målningar';
+ stone_table: Thing 'sten+häll^s+altare+t/stenhäll+en' 'stenhällsaltare';


canyonNorth: Room 'Övre Änden av Dalgången' 'över änden av dalgången';

+ huge_ball: Thing 'enormt pimp:en+sten:en^s+klot+et' 'enorm pimpstensklot';
+ huge_ball2: Thing 'ansvar^s+känsla+n' 'ansvarskänsla';
+ huge_ball3: Thing 'papper^s+flyg+plan+et' 'ansvarskänsla';
+ huge_ball4: Thing 'cyckel+slang+en' 'cyckelslang';
+ huge_ball5: Thing 'tranbär^s+juice+n' 'tranbärsjuice';

//+ test_obj: Thing 'ansvar:^skänsla-n' 'ansvarskänsla';



Junction: Room 'Xibalb@\'a';

canyonSouth: Room 'Nedre Änden av Dalgången'  'nedre änden av dalgången';
+ chasm: Room 'skräckinjagande avgrund' 'skräckinjagande avgrunden';

onBall: Room 'Pimp+sten^s+avsats+en' 'pimpstensavsatsen';


antechamber: Room 'För+kammare+n' 'förkammaren';
+ cage: Thing 'järnbur+en' 'järnbur';

burialShaft: Room 'Grav+schakt+et' 'gravschaktet';
wormcast: Room 'Maskhål' 'maskhålet'
    west = squareChamber
;

+ eggsac: Thing 'glänsande vit ägg+säck+en' 'glänsande vit äggsäck';
// schema~läggning -en
sodium_lamp: Thing 'natrium+lampa+n' 'natriumlampa' @player;

// TODO: idé:
// skriver man följande så får man alla 5 variationer per hel sektion: 
// sot+färgade
// sot, färgade
// sotfärgade

// Kanske ska vara försiktig med adjektiven, men det finns fall där det är mer behändigt:
// natrium, lampa, lampan
// natriumlampa, natriumlampan
// 

//sodium_lamp: Thing 'sot+färgade natrium+lampa+n' 'natriumlampa' @player;


walDecksDictionary: Readable 'waldecks maya+ordbok+en/ordbok+en' 'Waldecks mayaordbok' @player;

map: Thing 'skiss-karta över Quintana Roo' 'skiss-karta över Quintana Roo' @player;
// TODO: idé
//'äppel+kaka/äppel/äpplena'
//stone_key: Key 'stennyckel+n-2arna' 'stennyckel';

stone_key: Key 'sten+nyckel+n' 'stennyckel' isPlural = true combineVocabWords=nil;
priest: Actor 'mumifierad präst';
warthog: Actor 'Vårtsvin';
low_mist: Decoration 'låg dimma';
tiny_claws: SimpleNoise 'ljud av små klor' /*inuti thedark*/;
// TODO:

DefineTAction(Photograph);
VerbRule(Photograph)
    ('fotografera'|'fota') singleDobj
    : PhotographAction
    verbPhrase = 'fotografera/fotograferar (vad)'
    missingQ = 'vad vill du fotografera'
;

/*

---------------------------------------------------------------------------- !
!       The SQUARE CHAMBER.
!
!       Defined in DM4 Exercise 2, modified in $8 and $9


Object  squareChamber "Fyrkantig Kammare"
  with  name 'överliggande' 'överliggare' 'överliggarna' 'öst' 'syd' 'dörröppningar',
        description

        before [;
            Insert:
                if (noun == eggsac && second == sunlight) {
                    remove eggsac;
                    move stone_key to self;
                    "Du släpper äggsäcken i skenet av solljusstrålen. Den bubblar
                     obscent, sväller och brister sedan i hundratals små insekter
                     som springer åt alla håll in i mörkret. Endast stänk av slem
                     och en märklig gul stennyckeln återstår på kammarens golv.";
                    }
            ],
  has   light;

Object  -> "inristade inskriptioner"
  with  name 'inristade' 'inskriptioner' 'ristningar' 'märken' 'markeringar' 'symboler'
             'rörliga' 'kryllande' 'mängd' 'av',
        initial
            "Inristade inskriptioner trängs på väggarna, golvet och taket.",
        description
            "Varje gång du tittar noga på ristningarna verkar de vara stilla.
             Men du har en obehaglig känsla när du tittar bort att de kryper,
             rör sig omkring.
             Två glyfer är framträdande: Pil och Cirkel.",
  has   static pluralname;

Object  -> sunlight "solljusstråle"
  with  name 'stråle' 'av' 'solljus' 'sol' 'ljus' 'ljusstråle' 'solstråle'
             'stråle' 'strålar' 'solens' 'solbelyst' 'luft' 'dammkorn' 'damm',
        description
            "Dammkorn glimmar i strålen av solbelyst luft, så att den nästan
             verkar fast.",
        before [;
            Examine, Search:
                ;
            default:
                "Det är bara en immateriell solljusstråle.";
            ],
  has   scenery;

! ---------------------------------------------------------------------------- !
!       The STOOPED CORRIDOR.
!
!       Defined in DM4 §13
Object  Corridor "Böjd Korridor"
  with  description
            "En låg, fyrkantigt huggen korridor som löper från norr till söder,
             och får dig att böja dig.",
        n_to squareChamber,
        s_to StoneDoor;

Treasure -> statuette "pygméstatyett"
  with  name 'orm' 'maya' 'pygmé' 'ande' 'dyrbar' 'statyett',
        initial
            "En dyrbar mayastatyett vilar här!",
        description
            "En hotfull, nästan karikatyrliknande statyett av en pygméande
             med en orm runt halsen.";

Object  -> StoneDoor "stendörr"
  with  name 'dörr' 'massiv' 'stor' 'sten' 'gul',
        description
            "Det är bara en stor stendörr.",
        when_closed
            "Passagen blockeras av en massiv dörr av gul sten.",
        when_open
            "Den stora gula stendörren är öppen.",
        door_to [; if (self in Corridor) return Shrine; return Corridor; ],
        door_dir [; if (self in Shrine) return n_to; return s_to; ],
        with_key stone_key,
        found_in Corridor Shrine,
  has   static door openable lockable locked;

! ---------------------------------------------------------------------------- !
!       The SHRINE.
!
!       Defined in DM4 §23
Object  Shrine "Helgedom"
  with  description
            "Denna magnifika Helgedom visar tecken på att ha urholkats från
             redan existerande kalkstensgrotter, särskilt i den västra av de
             två långa takfoten i söder.",
        n_to StoneDoor,
        se_to antechamber,
        sw_to
            "Takfoten smalnar av till en spricka som skulle fortsätta längre om
             den inte var tätt packad med istappar. Glyfen för Halvmåne är
             nästan dold av is.";

!       Defined in DM4 §23
Object  -> paintings "målningar"
  with  name 'målning' 'målningar' 'herre' 'fånge',
        initial
            "Livligt upptagna målningar av den bepansrade Herren som trampar på en
             fånge är nästan för ljusa att titta på, graffiti från en organiserad pöbel.",
        description
            "Köttet på kropparna är blodröda. Markeringarna för den Långa Räkningen
             daterar händelsen till 10 baktun 4 katun 0 tun 0 uinal 0 kin, den typ av
             årsdag då en Herre slutligen skulle halshugga en tillfångatagen rival som
             hade rituellt torterats under en period av några år, i den balkaniserade
             galenskapen i mayastadsstater.",
  has   static;

Object  -> stone_table "stenhäll altare"
  with  name 'sten' 'bord' 'häll' 'altare' 'stort',
        initial
            "En stor stenhäll av ett bord, eller altare, dominerar Helgedomen.",
  has   enterable supporter static;

Treasure -> -> mask "jademosiakansiktsmask"
  with  name 'jade' 'mosaik' 'ansiktsmask' 'mask' 'ansikte',
        initial
            "Vilande på altaret finns en jademosiakansiktsmask.",
        description
            "Hur utsökt den skulle se ut på museet.",
        after [;
            Wear:
                move priest to Shrine;
                if (location == Shrine)
                    "När du tittar genom obsidianögonspringorna i mosaikmasken,
                     avslöjar sig en spöklik närvaro: en mumifierad kalenderlig
                     präst, som väntar på ditt ord.";
            Disrobe:
                remove priest;
            ],
        culturalValue 10,
  has   clothing;


! ---------------------------------------------------------------------------- !
!       The UPPER/NORTH CANYON.
!
!       Defined in DM4 §23

Object  CanyonNorth "Övre Änden av Dalgången"
  with  description
            "Den högre, bredare norra änden av dalgången stiger endast till en
             ojämn vägg av vulkanisk karst.",
        s_to Junction,
        d_to Junction,
  has   light;

Object  -> huge_ball "enorm pimpstensklot"
  with  name 'enorm' 'pimpsten' 'pimpstensklot' 'sten' 'klot',
        initial
            "Ett enormt pimpstensklot vilar här, åtta fot brett.",
        description
            "Hela åtta fot i diameter, men ganska lätt.",
        before [;
            PushDir:
                if (location == Junction && second == ne_obj)
                    "Helgedomens ingång är långt mindre än åtta fot bred.";
                AllowPushDir();
                rtrue;
            Pull, Push, Turn:
                "Det skulle inte vara så svårt att få det att rulla.";
            Take, Remove:
                "Det är mycket sten i en åtta fot stor sfär.";
            ],
        after [;
            PushDir:
                if (second == n_obj) "Du anstränger dig för att skjuta klotet uppför.";
                if (second == u_obj) <<PushDir self n_obj>>;
                if (second == s_obj) "Klotet är svårt att stoppa när det väl är i rörelse.";
                if (second == d_obj) <<PushDir self s_obj>>;
            ],
  has   static;

Object  Junction "Xibalb@'a"
  with  description
            "Femtio meter under regnskog, och ljudet av vatten är överallt:
             dessa djupa, eroderade kalkstengrottor sträcker sig som taprötter.
             En glidning nordost längs en bred kollapsad pelare av isbelagd sten
             leder tillbaka till Helgedomen, medan en slags dalgångsbotten
             sträcker sig uppför till norr och nedåt till söder,
             blektvit som hajtänder i det diffusa ljuset från
             natriumlampan ovan.",
        ne_to Shrine,
        n_to CanyonNorth,
        u_to CanyonNorth,
        s_to canyonSouth,
        d_to canyonSouth,
 has    light;

Treasure -> stela "stela"
  with  name 'stela' 'gräns' 'sten' 'markör',
        initial
            "En måttligt stor stela, eller gränssten, vilar på en avsats
             i huvudhöjd.",
        description
            "Ristningarna verkar varna för att gränsen till Xibalb@'a,
             Skräckens Plats, är nära. Fågelglyfen är framträdande.";

! ---------------------------------------------------------------------------- !
!       The LOWER/SOUTH CANYON.
!
!       Defined in DM4 §23
Object  canyonSouth "Nedre Änden av Dalgången"
  with  description
            "Vid den lägre och smalare södra änden slutar dalgången tvärt vid
             en avgrund av svindlande svärta. Inget kan ses eller höras
             från nedan.",
        n_to Junction,
        u_to Junction,
        s_to "Ner i avgrunden?",
        d_to nothing,
  has   light;

Object  -> chasm "skräckinjagande avgrund"
  with  name 'svärta' 'avgrund' 'grop' 'skräckinjagande' 'bottenlös',
        before [;
            Enter:
                deadflag = 3;
                "Du störtar genom mörkrets tysta tomrum och krossar
                 din skalle mot en klipputstickare. Mitt i smärtan och
                 rödskimret skymtar du vagt Guden med Ugglehuvan...";
            JumpOver:
                "Den är alldeles för bred.";
            ],
        after [;
            Receive:
                remove noun;
                print_ret (The) noun,
                          " faller tyst ner i avgrundsmörkret.";
            Search:
                "Avgrunden är djup och dunkel.";
            ],
        react_before [;
            Jump:
                <<Enter self>>;
            Go:
                if (noun == d_obj) <<Enter self>>;
            ],
        each_turn [;
            if (huge_ball in parent(self)) {
                remove huge_ball;
                canyonSouth.s_to = On_Ball;
                canyonSouth.description =
                    "Den södra änden av dalgången fortsätter nu ut på
                     pimpstensklotet, som är kilat fast i avgrunden.";
                "^Pimpstensklotet rullar okontrollerat ner de sista metrarna
                 av dalgången innan det skakar till i avgrundskäftarna,
                 studsar tillbaka lite och träffar dig med en smäll på sidan
                 av pannan. Du sjunker ihop, blödande, och...
                 pimpstenen krymper, eller så växer din hand, för du
                 verkar nu hålla den, stirrande på Alligator, son till
                 Sju-Macaw, över bollplanen på Torget, huvudena av
                 hans senaste motståndare spetsade på pålar, en församling
                 som ropar efter ditt blod, och det finns inget annat att göra
                 än att kasta ändå, och... men detta är bara nonsens,
                 och du har en splittrande huvudvärk.";
                }
            ],
  has   scenery open container;

Object  On_Ball "Pimpstensavsats"
  with  description
            "En improviserad avsats bildad av pimpstensklotet, kilar fast
             på plats i avgrunden. Dalgången slutar ändå här.",
        n_to canyonSouth,
        d_to canyonSouth,
        u_to canyonSouth,
  has   light;

Treasure -> "ristat ben"
  with  name 'ristat' 'skuret' 'ben',
        initial
            "Av alla offergåvor som kastats ner i avgrunden kommer kanske
             inget att återvinnas: inget förutom ett ristat ben, lättare
             än det ser ut, som sticker ut från en ficka av våt silt i
             dalgångsväggen.",
        description
            "En hand som håller en pensel framträder ur käftarna på Itzamn@'a,
             skriftens uppfinnare, i hans ormform.";
! ---------------------------------------------------------------------------- !
!       The aNTECHAMBER.
!
!       Defined in DM4 §23
Object  antechamber "Förkammare"
  with  description
            "De sydöstra takfoten i Helgedomen bildar en märklig förkammare.",
        nw_to Shrine;

Object  -> cage "järnbur"
  with  name 'järn' 'bur' 'galler' 'gallrad' 'ram' 'glyfer',
        description
            "Glyferna lyder: Fågel Pil Vårtsvin.",
        inside_description [;
            if (self.floor_open)
                "Från burens golv skär en öppen jordgrop
                 ner i gravkammaren.";
            "Burens galler omger dig.";
            ],
        when_open
            "En järngallerbur, stor nog att böja sig i, tornar
             hotfullt upp sig här, med dörren öppen. Det finns några glyfer på
             ramen.",
        when_closed
            "Järnburen är stängd.",
        after [;
            Enter:
                print "Skeletten som bebor buren vaknar till liv, låser
                       beniga händer runt dig, krossar och slår. Du förlorar
                       medvetandet, och när du återfår det har något groteskt
                       och omöjligt inträffat...^";
                move warthog to antechamber;
                remove skeletons;
                give self ~open;
                give warthog light;
                self.after = 0;
                ChangePlayer(warthog, 1);
                <<Look>>;
            ],
        react_before [;
            Go:
                if (noun == d_obj && self.floor_open) {
                    PlayerTo(Burial_Shaft);
                    rtrue;
                    }
            ],
        floor_open false,
  has   enterable transparent container openable open static;

Object  -> -> skeletons "skelett"
  with  name 'skelett' 'skelett' 'ben' 'skalle' 'ben' 'skallar',
        article "vansinniga",
  has   pluralname static;

Object  Burial_Shaft "Gravschakt"
  with  description
            "I dina eventuella fältanteckningar kommer detta att stå:
             ~En korbelbågad krypta med en kompakt jordplugg som försegling
             ovan, och målade figurer som förmodligen representerar Nattens
             Nio Herrar. Utspridda ben verkar tillhöra en
             äldre man och flera barnoffer, medan andra gravfynd
             inkluderar jaguartassar.~ (I fältanteckningar är det viktigt
             att inte ge något intryck av när du är skräckslagen.)",
        n_to Wormcast,
        u_to [;
            cage.floor_open = true;
            self.u_to = self.opened_u_to;
            move selfobj to self;
            print "Med ett mäktigt vårtsvinshopp stångar du mot jordpluggen
                   som förseglar kammaren ovan, och kollapsar din värld i aska
                   och jord. Något livlöst och fruktansvärt tungt faller ovanpå
                   dig: du förlorar medvetandet, och när du återfår det har något
                   omöjligt och groteskt hänt...^";
            ChangePlayer(selfobj);
            give warthog ~light;
            <<Look>>;
            ],
        cant_go
            "Arkitekterna bakom denna kammare var mindre än generösa med
             att tillhandahålla utgångar. Något vårtsvin verkar ha grävt sig in från
             norr dock.",
        before [; Jump: <<Go u_obj>>; ],
        opened_u_to [; PlayerTo(cage); rtrue; ],
  has   light;

Treasure -> honeycomb "forntida honungskaka"
  with  name 'forntida' 'gammal' 'honung' 'honungskaka',
        article "en",
        initial
            "En utsökt bevarad, forntida honungskaka vilar här!",
        description
            "Kanske någon form av gravoffergåva.",
        after [;
            Eat:
                "Kanske den dyraste måltiden i ditt liv. Honungen smakar
                 konstigt, kanske för att den användes för att förvara inälvorna
                 från Herren som begravdes här, men fortfarande som honung.";
            ],
  has   edible;

! ---------------------------------------------------------------------------- !
!       The WORMCAST.
!
!       Defined in DM4 Exercises 7 and 8, modified in Exercise 54

Object  Wormcast "Maskhål"
  with  description
            "En störd plats av håligheter utskurna som ett spindelnät, strängar av
             tomrum hängande i sten. De enda gångarna breda nog att krypa
             igenom börjar löpa nordost, söderut och uppåt.",
        w_to squareChamber,
        s_to [;
            print "Maskhålet blir halt runt dig, som om din
                   kroppsvärme smälter länge härdade hartser, och du blundar
                   hårt när du gräver dig genom mörkret.^";
            if (eggsac in player) return squareChamber;
            return random(squareChamber, Corridor, Forest);
            ],
        ne_to [; return self.s_to(); ],
        u_to [; return self.s_to(); ],
        cant_go [;
            if (player ~= warthog)
                "Även om du börjar känna dig säker på att något ligger bakom
                 och genom maskhålet, måste denna väg vara en djurgång i
                 bästa fall: den är alldeles för smal för din fåtöljarkeologs
                 mage.";
            print "Maskhålet blir halt runt din vårtsvinkropp, och
                   du gnäller ofrivilligt när du gräver dig genom mörkret,
                   och faller slutligen söderut till...^";
            PlayerTo(Burial_Shaft);
            rtrue;
            ],
        after [;
            Drop:
                move noun to squareChamber;
                print_ret (The) noun,
                          " glider genom en av gångarna och försvinner
                           snabbt ur sikte.";
            ],
  has   light;

Object  -> eggsac "glänsande vit äggsäck",
  with  name 'ägg' 'säck' 'ägg' 'äggsäck',
        initial
            "En glänsande vit äggsäck, som en klump grodrom stor som en
             strandboll, har fäst sig vid något i en spricka i en
             vägg.",
        after [; Take: "Åh herregud."; ],
        react_before [;
            Go:
                if (location == squareChamber && noun == u_obj) {
                    deadflag = true;
                    "I det ögonblick naturligt ljus faller på äggsäcken
                     bubblar den obscent och sväller. Innan du kan kasta bort den
                     brister den i hundratals små, födelsehungriga
                     insekter...";
                    }
            ];

Object  sodium_lamp "natriumlampa"
  with  name 'natrium' 'lampa' 'tung',
        describe [;
            if (self has on)
                "^Natriumlampan sitter på marken och brinner.";
            "^Natriumlampan sitter tungt på marken.";
            ],
        before [;
            Examine:
                print "Det är en kraftig arkeologlampa, ";
                if (self hasnt on) "för närvarande avstängd.";
                if (self.battery_power < 10) "som glöder med ett svagt gult sken.";
                "som lyser med ett starkt gult ljus.";
            Burn:
                <<SwitchOn self>>;
            SwitchOn:
                if (self.battery_power <= 0)
                    "Tyvärr verkar batteriet vara dött.";
                if (parent(self) hasnt supporter && self notin location)
                    "Lampan måste placeras säkert innan den tänds.";
            Take, Remove:
                if (self has on)
                    "Glödlampan är för ömtålig och metallhandtaget för varmt
                     för att lyfta lampan medan den är påslagen.";
            PushDir:
                if (location == Shrine && second == sw_obj)
                    "Det närmaste du kan göra är att skjuta natriumlampan till
                     kanten av Helgedomen, där grottgolvet faller bort.";
                AllowPushDir();
                rtrue;
            ],
        after [;
            SwitchOn:
                give self light;
            SwitchOff:
                give self ~light;
            ],
        daemon [;
            if (self hasnt on) return;
            if (--self.battery_power == 0) give self ~light ~on;
            if (self in location) {
                switch (self.battery_power) {
                    10: "^Natriumlampan blir svagare!";
                    5:  "^Natriumlampan kan inte hålla mycket längre.";
                    0:  "^Natriumlampan bleknar och dör plötsligt.";
                    }
                }
            ],
        battery_power 100,
  has   switchable;

Object  dictionary "Waldecks mayaordbok"
  with  name 'ordbok' 'lokal' 'guide' 'bok' 'maya' 'waldeck'
             'waldecks',
        description
            "Sammanställd från de opålitliga litografierna av den legendariske
             berättaren och upptäcktsresanden ~Greve~ Jean Frederic Maximilien Waldeck
             (1766??-1875), innehåller denna guide det lilla som är känt om
             glyferna som används i den lokala forntida dialekten.",
        before [ w1 w2 glyph;
            Consult:
                wn = consult_from;
                w1 = NextWord(); ! Första ordet i ämnet
                w2 = NextWord(); ! Andra ordet (om något) i ämnet
                if (consult_words==1 && w1~='glyf' or 'glyfer') glyph = w1;
                else if (consult_words==2 && w1=='glyf') glyph = w2;
                else if (consult_words==2 && w2=='glyf') glyph = w1;
                else "Försök med ~slå upp <namn på glyf> i boken~.";
                switch (glyph) {
                    'q1':       "(Detta är en glyf du har memorerat!)^^
                                 Q1: ~helig plats~.";
                    'halvmåne': "Halvmåne: tros uttalas ~xibalba~,
                                 men dess betydelse är okänd.";
                    'pil':      "Pil: ~resa; bli~.";
                    'dödskalle': "Dödskalle: ~död, öde; öde (inte nödvändigtvis dåligt)~.";
                    'cirkel':   "Cirkel: ~Solen; även liv, livstid~.";
                    'jaguar':   "Jaguar: ~herre~.";
                    'apa':      "Apa: ~präst?~.";
                    'fågel':    if (self.correct) "Fågel: ~död som en sten~.";
                                "Fågel: ~rik, välbärgad?~.";
                    default:    "Den glyfen är hittills oregistrerad.";
                }
            ],
        correct false,
  has   proper;
  
Object  map "skiss-karta över Quintana Roo"
  with  name 'karta' 'skiss' 'skiss-karta' 'quintana' 'roo',
        description
            "Denna karta markerar lite mer än bäcken som förde dig
             hit, från Mexikos sydöstra kant och in i den djupaste
             regnskogen, bruten endast av denna upphöjda platå.";

Object  stone_key "stennyckel"
  with  name 'sten' 'nyckel';


Object  priest "mumifierad präst"
  with  name 'mumifierad' 'präst',
        initial
            "Bakom stenhällen står en mumifierad präst och väntar,
             knappt vid liv i bästa fall, omöjligt ålderstigen.",
        description
            "Han är uttorkad och hålls ihop endast av viljekraft. Även om hans
             första språk förmodligen är lokal maya, har du den märkliga
             känslan att han kommer att förstå ditt tal.",
        life [;
            Answer:
                "Prästen hostar och faller nästan sönder.";
            Ask: switch (second) {
                'ordbok', 'bok':
                    if (dictionary.correct == false)
                        "~Fågel~-glyfen... mycket roligt.~";
                    "~En ordbok? Verkligen?~";
                'glyf', 'glyfer', 'maya', 'dialekt':
                    "~I vår kultur är Prästerna alltid läskunniga.~";
                'herre', 'grav', 'helgedom', 'tempel':
                    "~Detta är en privat angelägenhet.~";
                'målningar':
                    "Kalenderprästen rynkar pannan. ~10 baktun, 4 katun,
                     det blir 1 468 800 dagar sedan tidens början:
                     i er kalender 19 januari 909.~";
                'ruiner':
                    "~Ruinerna kommer alltid att besegra tjuvar. I underjorden
                     torteras plundrare i all evighet.~ En paus.
                     ~Liksom arkeologer.~";
                'nät', 'maskhål':
                    "~Ingen man kan passera Maskhålet.~";
                'xibalba':
                    if (Shrine.sw_to == Junction)
                        "Prästen skakar på sitt beniga finger.";
                    Shrine.sw_to = Junction;
                    "Prästen sträcker ut ett benigt finger sydväst mot
                     istapparna, som försvinner som frost när han talar. ~Xibalb@'a,
                     Underjorden.~";
                    }
                "~Du måste finna ditt eget svar.~";
            Tell:
                "Prästen har inget intresse av ditt smutsiga liv.";
            Attack, Kiss:
                remove self;
                "Prästen torkar bort till damm tills inget återstår,
                 inte en fläkt eller ett ben.";
            ThrowAt:
                move noun to location; <<Attack self>>;
            Show, Give:
                if (noun == dictionary && dictionary.correct == false) {
                    dictionary.correct = true;
                    "Prästen läser lite i boken och skrattar på ett
                     ihåligt, viskande sätt. Oförmögen att hålla tillbaka sin munterhet
                     skrapar han in en korrigering någonstans innan han lämnar tillbaka
                     boken.";
                    }
                if (noun == newspaper)
                    "Han tittar på datumet. ~12 baktun 16 katun 4 tun 1 uinal
                     12 kin~, förkunnar han innan han bläddrar på förstasidan.
                     ~Ah. Framsteg, ser jag.~";
                "Prästen är inte intresserad av jordiska ting.";
        ],
        orders [;
            Go:
                "~Jag får inte lämna Helgedomen.~";
            NotUnderstood:
                "~Du talar i gåtor.~";
            default:
                "~Det är inte dina order jag tjänar.~";
            ],
  has   animate;

!       Defined in DM4 Exercise 53
Object  warthog "Vårtsvin"
  with  name 'vart' 'svin' 'vartsvin',
        initial
            "Ett vårtsvin sniffar och grymtar omkring i askan.",
        description
            "Lerig och grymtande.",
        orders [;
            Go, Look, Examine, Smell, Taste, Touch, Search,Jump, Enter:
                rfalse;
            Eat:
                "Du har inte knäckt knepet med att sniffa upp mat än.";
            default:
                "Vårtsvin kan inte göra något så invecklat. Om det inte vore för
                 nattsynen och den förlorade vikten, skulle de vara sämre ställda
                 på alla sätt än människor.";
            ],
  has   animate proper;

!       Defined in DM4 §8
Object  low_mist "låg dimma"
  with  name 'lag' 'virvlande' 'dimma',
        description "Dimman har en arom som påminner om tortilla.",
        before [;
            Examine, Search:
                ;
            Smell:
                <<Examine self>>;
            default:
                "Dimman är för osubstansiell.";
            ],
        react_before [; Smell: if (noun == nothing) <<Smell self>>; ],
        found_in squareChamber Forest,
  has   scenery;

!       Defined in DM4 Exercise 46
Object  tiny_claws "ljud av små klor" thedark
  with  name 'sma' 'klor' 'ljud' 'av' 'skuttande' 'skutt' 'saker'
             'varelser' 'monster' 'insekter',
        article "det",
        initial
            "Någonstans skuttrar små klor.",
        before [;
            Listen:
                "Så intelligenta de låter, för att vara bara insekter.";
            Touch, Taste:
                "Du skulle verkligen inte vilja det.";
            Smell:
                "Du kan bara känna lukten av din egen rädsla.";
            Attack:
                "De undviker lätt dina viftningar.";
            default:
                "Varelserna undviker dig, kvittrande.";
            ],
        each_turn [; StartDaemon(self); ],
        daemon [;
            if (location ~= thedark) {
                self.turns_active = 0;
                StopDaemon(self);
                rtrue;
                }
            switch (++(self.turns_active)) {
                1:  "^Skuttret kommer lite närmare, och din andning
                     blir hög och hes.";
                2:  "^Terrorns svett rinner från din panna. Varelserna
                     är nästan här!";
                3:  "^Du känner en kittling i dina extremiteter och sparkar utåt,
                     skakande av något kitinöst. Bara deras ljud är ett
                     hotfullt raspande.";
                4:  deadflag = true;
                    "^Plötsligt känner du en liten smärta, av en hypodermisk-vass huggtand
                     i din vad. Nästan omedelbart går dina lemmar i spasm,
                     dina axlar och knäleder låser sig, din tunga svullnar...";
                }
            ],
        turns_active 0;



! ---------------------------------------------------------------------------- !
!       Utility routines.


[ TitlePage i;
        @erase_window -1; print "^^^^^^^^^^^^^";
        i = 0->33; if (i > 30) i = (i-30)/2;
        style bold; font off; spaces(i);
        print " RUINER^";
        style roman; print "^^"; spaces(i);
        print "[Tryck MELLANSLAG för att börja.]^";
        font on;
        box "Men Alligator grävde inte botten av hålet"
            "Som skulle bli hans grav,"
            "Utan snarare grävde han sitt eget hål"
            "Som ett skydd för sig själv."
            ""
            "-- från Popol Vuh";
        @read_char 1 -> i;
        @erase_window -1;
];

[ PrintRank;
        print ", vilket ger dig rangen av ";
        if (score == 30) "Direktör för Carnegie-institutionen.";
        if (score >= 20) "Arkeolog.";
        if (score >= 10) "Nyfiken sökare.";
        if (score >= 5) "Utforskare.";
        "Turist.";
];

[ DeathMessage;
        if (deadflag == 3) print "Du har blivit tillfångatagen";
];

! ---------------------------------------------------------------------------- !

Include "SwedishG"; 

[ PhotographSub;
        if (camera notin player) "Inte utan din kamera.";
        if (noun == player) "Bäst att låta bli. Du har inte rakat dig sedan Mexiko.";
        if (children(player) > 1)
            "Fotografering är en omständlig process som kräver användning av båda händerna. Du måste lägga ner allt annat.";
        if (location == Forest) "I denna regnblöta skog är det bäst att låta bli.";
        if (location == thedark) "Det är alldeles för mörkt.";
        if (AfterRoutines()) return;
        print_ret "Du ställer upp den elefantlika, storformats våtplåtskameran,
                   justerar natriumlampan och gör en tålmodig exponering av ",
                   (the) noun, ".";
];

Verb 'photograph'
        * noun          -> Photograph;

! ---------------------------------------------------------------------------- !
*/





class Treasure: Thing
    photographedInSitu = nil
    culturalValue = 5
    dobjFor(Remove) asDobjFor(Take)
    dobjFor(Take) {
        check() {
            if(isIn(packingCase)) {
                reportFailure('Det vore bäst att vänta med uppackandet av en sån obetalbar aartefakt till dess att Carnegieinstitutionen kan göra det. ');
            }
            if(!photographedInSitu) {
                reportFailure('Detta är 30-talet; inte den gamla dåliga tiden. Att ta en artefakt utan att redogöra dess kontext vore helt enkelt att plundra. ');
            }
        }
    }
    dobjFor(Photograph) {
        check() {
            if(!self.isInitState)  {
                "Va, falsifiera den arkeologiska uppteckningen?";
            }
            if(photographedInSitu) {
                "Inte igen.";
            }
        }
        action() {

        }
    }
    // TODO: Blir det PutIn?
    dobjFor(PutIn) {
        action() {
            if (gIobj == packingCase) {
                libScore.totalScore += culturalValue;
                if(libScore.totalScore == gameMain.maxScore) {
                    "Då du försiktigt packar undan {the dobj/han} fladdrar en rödstjärtad ara ner från trädtopparna, dess fjädrar tunga i det senaste regnet, ljudet av dess slagande vingar nästan öronbedövande, sten faller mot sten... 
                    När himlen klarnar stiger en halvmåne upp ovanför en fridfull djungel. Det är slutet på Mars 1938, och det är dags att åka hem.";

                    finishGameMsg(ftVictory, [finishOptionUndo, finishOptionFullScore]);
                }
                "Säkert undanpackad.";
            }
        }
    }
;
