#charset "utf-8"
#include <adv3.h>
#include <sv_se.h> 

#define __DEBUG
#include "../debug.h"

// TODO: kasta repet på årorna -krasch
// TODO: kasta åror
// –>baten.putInName()
//   playerActionMessages.throwHitFallMsg({obj:Attachable,Thing},
// putInName

// Översättningsproblem
// TODO: lös att det inte går att skriva följande nu och få "årorna var för tunga" istället för "de åror var för tunga":
//  ++Thing, Heavy 'åror[-na]' 'åror'     isPlural = true;
// En workaround är:
//++Thing, Heavy 'åra**åror[-na]' 'åror' "..."
//    isPlural = true

versionInfo: GameID
    IFID = '952c94dd-f92a-4970-9a00-cdcc24d038a1'
    name = 'Skärgården'
    byline = 'by Tomas'
    htmlByline = 'by <a href="mailto:yourmail@address.com"></a>'
    version = '1'
    authorEmail = 'Tomas yourmail@address.com'
    desc = ''
    htmlDesc = ''
;


gameMain: GameMainDef
    initialPlayerChar = Mats
    usePastTense = true

    showIntro() {
        "Mats kom slutligen fram till stugan. Efter att ha passerat grinden alldeles efter avtagsvägen kom han fram till sin grusplan. Parkerade bilen och gick ut. Regnet var ihållande men luften frisk. Han drog ett djupt andetag och bara kände regndropparna mot sitt ansikte. Ett lugn lade sig över honom trots en aning oroskänsla gällande olyckan.  \b";
    }
;


plankGolv: Floor 'golv[-et]**plankor[-na]' 'plankor';



grasmattan: OutdoorRoom 'Gräsmattan' 'gräsmattan'
    "Mats stod intill sin stuga österut, söderut var vedboden och grusvägen gick därifrån via nordväst. Ett staket var rest runtom hela tomten. Bortanför stugan (sydöst), låg en brygga anlagd över vattnet (öst). Regnet öste ner och det långa gräset gjorde hans skor fuktiga. "
    east : TravelMessage {
        destination = bryggplatsen
        travelDesc = "Mats gick på de tjocka brädorna som bar ut över sjön och bryggan guppade i vattnet i takt med hans steg. " 
    }
    southeast : TravelMessage {
        destination = verandan
        travelDesc =  "Mats gick över gräsmattan fram verandan och klev upp via tre blöta plankorna på den lilla trappstegen upp på verandan."
    }
    south = vedboDorrUtsida
;

+saken: Thing 'saker[-na]' 'saker' isPlural = true;

//++skapLuckeUtrymme: ComplexContainer,OpenableContainer 'insida[-n]' 'insida';
/*++skapLuckor: ContainerDoor, ComplexComponent 'skåplucka[-n]*skåpluck[-or]/lucka*luckor[-na]' 'skåpluckor' 
    isPlural = true
;*/

+sofia: Actor 'Sofia' 'Sofia' isShe = true isProperName = true;
++sofiasMossa: Wearable 'sofias mössa[-n]' 'mössa' wornBy = sofia;
++ sofiaChatting : InConversationState
    specialDesc = "Sofia stod alldeles framför dig "
    stateDesc = "Hon stod vänd mot dig och väntade på att du skulle tala. "
    attentionSpan = 2 
;
+++ sofiaRedoAttTala : ConversationReadyState
    specialDesc = "Sofia stod där."
    stateDesc = "Sofia stod framför dig. "
    isInitState = true
;

++++HelloTopic "<q>Hej!</q>, säger du. <q>Hej hej!</q>, svarar Sofia.";
++++ByeTopic "<q>Hej då!</q>, säger du. \n<q>Hej då</q>, svarar Sofia.";

++++ ImpByeTopic "Eran konverstation tog slut";
++++ BoredByeTopic "Sofia börjar titta på omgivningen istället för att konversera. ";

+++AskTopic, SuggestedAskTopic 'regn' 
    "<q>Det typiska livet i skärgården...</q>"
    name = 'regnet'
;
+++AskTopic, SuggestedAskTopic @sofia
    "<q>Jag har inte så mycket att säga...</q>"
    name = 'henne själv'
;
+++GiveShowTopic, SuggestedShowTopic @saken 
    "<q>Jag har en sån där hemma</q>, svarar Sofia med ett ansträngt leende. "
    name = (matchObj.name)
;
+++ TellTopic, SuggestedTellTopic @Mats
    "<q>Ok, berätta mer...</q>"
    name = 'dig själv'
;
// TODO: ge saker till sofia, krasch vid
+++GiveTopic, SuggestedGiveTopic @saken
    "<q>Eh, nja...</q>"
    name = (matchObj.name)
;


+vedboDorrUtsida: LockableWithKey, Door 'vedbodörr[-en]/dörr[-en]*dörrar[-na]' 'vedbodörr'
    knownKeyList = [forradsdorrsnyckel]
    keyList = [forradsdorrsnyckel]
;


verandan: OutdoorRoom 'Verandan' 'verandan'
    "Verandan till stugan var i behov av ommålning. Färgen hade börjat släppa överallt på räcket. Dörröppningen till stugan var söderut och framför (norrut) låg den välbekanta och av år naggade dörrmattan han fortfarande inte bytt ut. Det knattrade frenetiskt från regnet på det plåttak som räckte ut över den. Över sjön österut låg diset tätt. Bryggan (nordöst) stod redo att gå ut på och Mats vita mindre roddbåt var förtöjd med ett rep i bryggan."
    roomParts = static inherited - defaultGround + plankGolv
    west = grasmattan
    northeast : TravelMessage {
        destination = bryggplatsen
        travelDesc = "Mats gick på de tjocka brädorna som bar ut över sjön och bryggan guppade i vattnet i takt med hans steg. " 
    }
    south = stugdorrUtsida
    
;

+stugdorrUtsida: LockableWithKey, Door 'stugdörr[-en]/dörr[-en]*dörrar[-na]' 'stugdörr'
    knownKeyList = [stugdorrsnyckel]
    keyList = [stugdorrsnyckel]
    makeOpen(stat) {
        inherited(stat);
        stugansVardagsrum.brightness += stat? 1 : -1;
    }
;

+dorrmatta: Underside 'dörrmatta[-n]/matta[-n]' 'dörrmatta'
    // Search, Turn
    dobjFor(Search) asDobjFor(LookUnder)
    dobjFor(Turn) asDobjFor(LookUnder)
    dobjFor(Open) asDobjFor(LookUnder)
    dobjFor(Take) {
        action() {
            inherited();
            if(!stugdorrsnyckel.discovered) {
                //stugdorrsnyckel.moveInto(verandan);
                stugdorrsnyckel.discover();
                "Den välbekanta nyckeln blänker till av ljuset. ";
                
                stugdorrsnyckel.moveInto(gPlayerChar);
                "{Du} plockar upp den. ";

            }
        }
    }

    dobjFor(LookUnder) {
        action() {
            if(!stugdorrsnyckel.discovered) {
                //stugdorrsnyckel.moveInto(verandan);
                stugdorrsnyckel.discover();
                "Mats lyfte på hörnet av dörrmattan och fann den välbekanta nyckeln blänka till av ljuset. ";

                stugdorrsnyckel.moveInto(gPlayerChar);
                "{Du/han} plocka{r/de} upp den. ";

            }
        }
    }
;

stugdorrsnyckel: Hidden, Key 'stugdörrsnyckel[-n]/nyckel[-n]' 'stugdörrsnyckel'; 



stugansVardagsrum: DarkRoom 'stugans vardagsrum' 'stugans vardagsrum'
    "<<one of>> Mats gick in i det mörka rummet över det knarrande golvet. Det var rått och kallt där inne. <<or>><<stopping>>
    Den välbekanta soffan stod där den brukade, mitt i rummet riktad mot eldstaden i västra väggen och med ett mörkt ovalformat soffbord mellan sig. På andra sidan låg köksdelen med köksbänken varifrån man hade full översyn av vardagsrummet när man lagade mat. Sovrumsdörren till söder bredvid en röd väggtelefon, stod synlig alldeles bakom soffans ena sida. Norrut gick dörren ut till altanen." 
    out = stugdorrInsida
    north asExit(out)
    east = stugansKok
    south = stugansSovrum
    getExtraScopeItems(actor) { return inherited(actor) + lysknapp + stugansTaklampa; }

;

+lysknapp: Component, OnOffControl 'lysknapp[-en]/knapp[-en]/lyset/lampknapp[-en]/ljusknapp[-en]' 'lysknapp'
  "En liten plastbit monterad i väggen som man kan vika uppåt för att tända taklampan eller neråt för att släcka den. "
  dobjFor(Light) asDobjFor(TurnOn)
  dobjFor(Extinguish) asDobjFor(TurnOff)
  makeOn(status) {
    inherited(status);
    stugansTaklampa.isLit = status;
    stugansKok.brightness = status ? 2 : 0;
  }
;

+stugansTaklampa: Fixture, LightSource 'lampa[-n]/taklampa[-n]' 'taklampa'
    isLit = nil
    dobjFor(TurnOn) remapTo(TurnOn, lysknapp)
    dobjFor(Light) remapTo(TurnOn, lysknapp)
    dobjFor(TurnOff) remapTo(TurnOff, lysknapp)
    dobjFor(Extinguish) remapTo(TurnOff, lysknapp)
;

+soffa: Chair, Heavy 'soffa[-n]' 'soffa'
    bulkCapacity = 30 // Seating capacity for three  
;

+eldstaden: Fixture, ComplexContainer 'eldstad[-en]' 'eldstad' 
    subSurface: ComplexComponent, Surface 'spiselkrans[-en]/krans[-en]' 'spiselkrans' { 
        bulkCapacity = 5 
    }
    subContainer: ComplexComponent, Container 'öppna spis[-en]' 'öppna spisen'  { 
        bulkCapacity = 10 isQualifiedName = true 
    }
;
+hylla: Fixture, Container 'hylla[-n]' 'hylla';

++telefon: Thing 'röd telefon[-en]' 'telefon'
    "En röd telefon hängde på väggen. "
    dobjFor(Call) {
        verify() {}
        check() {}
        action() {
            "Ingen kopplingssignal hörs. Telefonledningen måste vara trasig. ";
        }
    }
;


/*
        before[;
            Call: 
                if(compareCalledNumberWith(phonenumber2) || compareCalledNumberWith(phonenumber2_without_prefix)) {
                    if(self hasnt general) {
                        give self general;
                        "Mats slog in numret och höll luren mot öran. Det han ringa ett par signaler innan en högljudd gammal mans röst svarade. ^^
                        ~Jaa-aa!~^^
                        ~Hej! Saknar ni en k...~, hann Mats bara börja säga innan han avbröts av ett stökande i bakgrunden. ^^
                        ~VA SA?!~, frågade mannen. ^^
                        ~Jag undrar om ni SAKNAR en katt?~^^
                        ~Nä.... vänta lite... har vi katt?!~, ropade han i bakgrunden.^^ 
                        ~Nej det har vi inte!~ skrek en irriterad kvinnoröst i bakgrunden.^^
                        ~Nej, det har vi inte~ sade mannen som i ett eko. ^^
                        ~Ok, då ska jag inte störa mer. Tack och hej~^^
                        ~Ja-a... hej.. då..~^^
                        ~Klick!~^^
                        Mats hängde på luren. Det uteslöt den adressen. "; 
                    }
                    "Mats såg liten mening att ringa upp det äldre paret igen. Han visste det han behövde veta. De var inte ägarna till katten och då kunde det bara vara det andra numret. ";
                } else if(compareCalledNumberWith(phonenumber1) || compareCalledNumberWith(phonenumber1_without_prefix)) {
                    "Mats slog in numret och höll luren mot öran. Det ringde upprepade gånger men ingen svarade. Efter tjugonde signalen gav han upp och lade på. ";
                } else if(compareCalledNumberWith(your_phonenumber) || compareCalledNumberWith(your_phonenumber_without_prefix)) {
                    "Mats ringde av nyfikenhet upp sitt eget nummer. Det tutade upptaget. ";
                }

                "Mats kände ingen iver att busringa folk på måfå. ";
                
        ],
    has scenery static;
*/

+telefonkatalog: Readable 'telefonkatalog[-en]/katalog[-en]' 'telefonkatalog';
/*
        !initial [;
        !    "Nedanför telefonen, var en enkel hylla med en telefonkatalog på. ";
        !],
        description "Det var en rejäl katalog, vägandes drygt ett kilo säkert. Med både vita och gula sidorna. ",
        before[;
            Search, Open: 
                "Mats öppnade och kollade igenom katalogen. Tusentals nummer stod nedskrivna där. Han kunde slå upp specifika nummer där om han visste något av intresse men annars var den allmänt känd som en ganska tråkig läsupplevelse. ";
            Consult:
                if(compareCalledNumberWith(phonenumber1) || compareCalledNumberWith(phonenumber1_without_prefix)) {
                    "Mats kollade upp numret och '08-22325' verkade gå till här i området. Adressen var Hökbacken 6. Det var en bit bort men ändå nära. "; 
                } else if(compareCalledNumberWith(phonenumber2) || compareCalledNumberWith(phonenumber2_without_prefix)) {
                    "Mats kollade upp numret och '08-22328' verkade faktiskt finnas här i området. Adressen var Örntorpsvägen 24. Det var mycket nära"; 
                } else if(compareCalledNumberWith(your_phonenumber) || compareCalledNumberWith(your_phonenumber_without_prefix)) {
                    "Mats kollade av nyfikenhet upp sin egna adress via sitt telefonnummer. Mats Lundbäck, Vickertorpsvägen 4. Det var en lättnad på något sätt att se den adressen. ";
                } else {
                    !Check if number is 5 long and starts with 2232x or starts with 082232x
                    if(dialled_number->0==5 || dialled_number->0==7) {
                        if(compareCalledNumberWith(phonenumber1_without_prefix, 4)
                        || compareCalledNumberWith(phonenumber1, 6)) {
                            "Det numrets adress hade kunnat vara troligen men låg för långt borta för att vara rimligt att vara kattens ägare tänkte Mats. ";
                        } 
                        "Mats titta runt lite på måfå i katalogen. Han kände dock på sig att han borde kolla upp något som låg närmare till. "; 
                    } else {
                        "Mats förstod att de nummer som var relevanta var de som fanns i hans riktnummerområde (08) och därefter hade fem siffror, så som hans eget hit till stugan, 08-22401. ";
                    }
                }
            ];

*/


+stugdorrInsida: LockableWithKey, Door 'stugdörr[-en]/dörr[-en]*dörrar[-na]' 'stugdörr'
    "<<if isOpen>>Stugdörren stod öppen och där ute knattrade regner mot taket och ner altanen.<<end>>"
    //openDesc = "Stugdörren stod öppen och där ute knattrade regner mot taket och ner altanen. "
    masterObject = stugdorrUtsida
    knownKeyList = [stugdorrsnyckel]
    keyList = [stugdorrsnyckel]
;


vedbod: Room 'vedboden' 'vedboden'
    "Det var en lagom stor vedbod med ved upptravad längs hela ena väggen upp till taket. På andra sidan var en verktygsbänk."
    brightness = 2 // TODO: hitta rätt nivå
    out = vedboDorrInsida
    north asExit(out)
;

+vedboDorrInsida: Door 'vedbodörr/dörr[-en]*dörrar[-na]' 'vedbodörr'
    masterObject = vedboDorrUtsida
;

+verktygsbank: Fixture 'verktygsbänk[-en]/bänk[-en]' 'verktygsbänk'
    feelDesc() {
            // TODO: inform -> tads equiv: if(location==thedark) {
        "Mats kände med handen över träytan på bänken <<if ficklampa.discovered>> men fann inget mer. <<end>>";
        if(!ficklampa.discovered) {
            ficklampa.discover();
            ficklampa.moveInto(Mats);
            "Lite längre in mot väggen fann han en välbekant tubformad sak av metall. En ficklampa. Han plockade på sig den. ";
        }
    }
;

+ficklampa: Hidden, Flashlight 'ficklampa[-n]/lampa[-n]' 'ficklampa';
/*
        before[;
            !TODO: batteriet i kylskåpet
            !Open: "";
            Attack,
            Burn,
            SwitchOn:
                give self light;
                "Mats tryckte knappen på ficklampans ovansida framåt och lampan sken upp. ";
            SwitchOff:
                give self ~light;
                "Mats tryckte knappen på ficklampans ovansida framåt och lampan sken upp. ";
        ],
    has switchable;
*/
+sag: Thing 'såg[-en]' 'såg';
+lie: Thing 'lie[-n]' 'lie';

+vedtran: Thing 'ved[-en]/vedträ*vedträn[-a]' 'hög med vedträn' 
;
/*
Object -> logPile "vedträn"
    with   
        name 'ved' 'veden',
        short_name_def "veden",
        numberOfLogsCarriedBy[who x nr;
            nr = 0;
            objectloop(x in who && x ofclass Log) {
                nr++;
            }
            return nr;
        ],
        pickUpLogs[who nr x;
            for(x=0: x < nr : x++) {
                move Log.create() to who;
            }
        ],
        before[;
            Take:
                if(self.numberOfLogsCarriedBy(player) >= 4) {
                    "Mats bar redan på tillräckligt många vedträn";
                }
                self.pickUpLogs(player, 4);
                "Mats plockade på sig några vedträn. ";
        ],
    has pluralname proper static scenery;

*/

bryggan: Floor, Attachable 'brygga[-n]' 'bryggan' isQualifiedName = true;

bryggplatsen: OutdoorRoom 'bryggan' 'bryggan'
    "Diset låg tätt och svårt för honom att se något annat av skärgårdsmiljön där ute, än anade gröna nyanser där avlägsna stränder och holmar låg. Långt bort åt norr syntes ett ljus blinka ungefär varannan sekund i en återkommande puls. "
    west = grasmattan
    southwest = verandan
    roomParts = static inherited - defaultGround + bryggan

    south: TravelMessage { -> baten
        "Mats klev i fjolårets båtköp. " // TODO: fungerar inte 
    }

    atmosphereList: ShuffledEventList {
         ['Mats kände en frisk vind fatta tag i hans kläder.',nil,nil,nil]
    }
;




+baten: Attachable, Heavy, Container, Vehicle  /*Enterable -> (location.south)*/ 'båt[-en]**båtar[-na]' 'båten'
    "Det var en träfärgad ~snipa~ med plats för två. Mats brukade använda den till att fiska och åka runt på upptäcktsfärder i skärgården. "
    specialDesc = "Mot bryggans södra del låg Mats båt förtöjd. "
    isQualifiedName = true
    arAnkrad = nil
    north  = bryggplatsen
;

++Component, Fixture 'ankare[-t]' 'ankare'
    cannotTakeMsg = "Ankaret satt fast med en kedja i båten. "
;
++Component, Fixture 'kedja[-n]' 'kedja'
    cannotTakeMsg = "Kedjan satt fast i ankaret och båten. "
;
++Attachable, Thing 'rep[-et]' 'rep'
    //"<<if baten.arAnkrad>>Båten var förtöjd med ett rep fastsatt i en metallring i bryggan.<<end>>"
    attachedObjects = [baten, bryggan] // TODO: fungerar inte 
;

++Thing, Heavy 'åra**åror[-na]' 'åror' "..."
    isPlural = true
    isListed = true
    /*
        before [;
            Take, Empty:
                if(~~(boat.moored))
                    "Båten låg fortfarande förtöjd så Mats såg liten mening i att ta börja ro. ";
                "Mats tog tag i årorna och gjorde sig redo att ro. ";
        ],
    */
;






Mats: Actor 'mats/du' 'Mats' @grasmattan
  pcReferralPerson = ThirdPerson
  isProperName = true
  isHim = true
;




// Insidan av stugan

stugansKok: DarkRoom 'stugans kök' 'köket'
    west = stugansVardagsrum
;
+OpenableContainer, Fixture, LightSource 'kylskåp[-et]/kyl[-en]/skåp[-et]' 'kylskåp'
    isLit = nil
    makeOpen(stat) {
        inherited(stat);
        self.isLit = stat;
    }
;

// TODO: Flytta in i köket sedan
+skap: Heavy, ComplexContainer 'skåp[-et]' 'skåp'
    subSurface: ComplexComponent, Surface {}
    subContainer: ComplexComponent, OpenableContainer  {
        //descContentsLister = thingDescContentsLister
    }
;

/*
Object -> fridge "kylskåp"
    with
        after[;
            Open:
                give self light;
                give cottageInsideLivingRoom light;
            Close:
                give self ~light;
                give cottageInsideLivingRoom ~light;
        ]
    has neuter openable container static;
*/

+batterier: Thing 'batteri[-er]' 'batterier' isPlural = true
    theName = 'batterierna'
;





+forradsdorrsnyckel: Key 'förrådsnyckel[-n]/förrådsdörrsnyckel[-n]/nyckel[-n]' 'förrådsdörrsnyckel'; 

// TODO: darkroom
stugansSovrum: Room 'stugans sovrum' 'sovrummet'
    north = stugansVardagsrum
    west = stugansBadrum
;

+stugansSovrumsSang: BasicBed 'säng[-en]' 'säng'
    dobjFor(Search) {
        action() {
            "Under sängen låg en hel dammråttsfamilj. ";
        }
    }
;

+garderob: OpenableContainer, Fixture 'garderob[-en]' 'garderob'
    cannotEnterMsg = "Den var inte tillräckligt stor för att rymmas i."
;

++dammsugare: Thing 'dammsugare[-n]' 'dammsugare';

// TODO: isUter fungerar inte på ComplexComponent (åtminstone när den deklareras inline som här)
// >x låda
// Det var öppen, och innehöll en tändsticksask.
+nattduksbord: ComplexContainer, Heavy 'bord[-et]/nattduksbord[-et]' 'nattduksbord'    "Ett nattduksbord med en låda. "
    subSurface: ComplexComponent, Surface { }
    /*subContainer: ComplexComponent, OpenableContainer 'låda[-n]' 'låda' {
        bulkCapacity = 10
        isUter = true
    }*/
    subContainer = drawer
    cannotTakeMsg = "Det var för otympligt för att gå runt att bära på."
;
++drawer: Component, OpenableContainer 'låda[-n]' 'låda' {
    bulkCapacity = 10
}


oljelampa: Thing 'oljelampa[-n]/lampa[-n]' 'oljelampa' 
    location = nattduksbord.subSurface
;

tandsticksask: OpenableContainer 'ask[-en]/tändsticka/tändstickor[-na]/tändsticksask[-en]' 'tändsticksask' 
    location = nattduksbord.subContainer
; 
+tandstickor: Thing 'tändsticka**tändstickor[-na]' 'tändstickor' isPlural=true;



stugansBadrum: DarkRoom 'stugans badrum'
    east = stugansSovrum
;
/*
TODO: ska det saknas lampa där? Anpassa annars:

+lysknapp: Component, OnOffControl 'lysknapp[-en]/knapp[-en]/lyset/lampknapp[-en]/ljusknapp[-en]' 'lysknapp'
  "En liten plastbit monterad i väggen som man kan vika uppåt för att tända taklampan eller neråt för att släcka den. "
  dobjFor(Light) asDobjFor(TurnOn)
  dobjFor(Extinguish) asDobjFor(TurnOff)
  makeOn(status) {
    inherited(status);
    stugansTaklampa.isLit = status;
  }
;

+stugansTaklampa: Fixture, LightSource 'lampa[-n]/taklampa[-n]' 'taklampa'
    isLit = nil
    dobjFor(TurnOn) remapTo(TurnOn, lysknapp)
    dobjFor(Light) remapTo(TurnOn, lysknapp)
    dobjFor(TurnOff) remapTo(TurnOff, lysknapp)
    dobjFor(Extinguish) remapTo(TurnOff, lysknapp)
;
*/

+Fixture 'dusch[-en]' 'dusch';
+Fixture, OpenableContainer 'spegel[-n]' 'spegel';
+Fixture, Surface 'toalett[-en]' 'toalett';
+Fixture, OpenableContainer 'lock[-et]/toalettlock[-et]' 'toalettlock';

+tvattstall: ComplexContainer 'handfat[-et]/fat[-et]/tvättställ[-et]' 'tvättställ'
    subSurface: ComplexComponent, Surface 'kant[-en]/tvättställskant[-en]' 'tvättställskanten' { }
    subContainer: ComplexComponent  {
        bulkCapacity = 3
    }
;

Component, Switch  'vattenkran[-en]/kran[-en]' 'vattenkran'
    location = tvattstall.subSurface
    dobjFor(Open) asDobjFor(TurnOn)
    dobjFor(Close) asDobjFor(TurnOff)
;
Thing 'tvål[-en]' 'tvål'
    location = tvattstall.subContainer;




/*
DefineLiteralTAction(CallImplicit, DirectObject)
    execAction() {
        "Men vem skulle {du} ringa?" ;
    }
;
VerbRule(CallImplicit)
    ('ring' 'med') 
    | ('slå' ('in'|) 'nummer' 'på'|) singleDobj
    : CallImplicitAction
    verbPhrase = 'ringa/ringer (vad)'
    missingQ = 'vilket nummer vill du ringa'
;*/

DefineLiteralTAction(Call, DirectObject)
    execAction() {
        "<q><<gLiteral>></q> {är} inte ett nummer som leder någonstans" ;
    }
;
VerbRule(Call)
    ('ring' (|'upp'|) 
    | ('slå' ('in'|) ('nummer'|))) singleLiteral 'på' singleDobj
    : CallAction
    verbPhrase = 'ringa/ringer (vad)'
    missingQ = 'vilket nummer vill du ringa'
;

DefineTAction(Lift);

VerbRule(Lift)
    'lyft' ('på'|) dobjList
    : LiftAction
    verbPhrase = 'lyfta/lyfter (vad)'
    missingQ = 'vad vill du lyfta på'
;


Test 'spel' [
    'sö', 'titta under matta', 'ta nyckel', 's', 
    'tänd lampan', 'ö', 'ta nyckel', 'v', 'n', 'v', 's', 
    'känn på verktygsbänk', 'n', 'sö', 's', 'tänd ficklampa', 's'
    ];


Test 'matta' ['sö', 'titta under matta', 'ta nyckel', 's'];

Test 'bord' ['purloin ficklampa', 'tänd lampa', 'öppna låda'] @stugansSovrum;


function w(o) {
    cmdDict.forEachWord(function(obj, str, prop) {
      if(obj == o) {
        "word: <<obj>>: <<str>> <<prop>>\n";
      }
    });
}
