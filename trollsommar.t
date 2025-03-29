#charset "utf8"
#include <adv3.h>
#include <sv_se.h> 

// TODO: x mig

karl:  Actor 'karl' 'Karl' @huset //@husetsVeranda //landsvagen
    isProperName = true
    posture = sitting
;
+key: Key 'nyckel[-n]*nycklar[-na]' 'nyckel';


landsvagen: OutdoorRoom 'landsvägen' 'landsvägen'
    "Du står still efter landsväg. Soppatorsk. På båda sidor om vägen är skogar. "
    east = ostraSkogen
    west = vastraSkogen
;


+bilen: Vehicle 'bil[-en]*bilar[-na]' 'bilen'
    allowedPostures = [sitting]
    canTravelVia(connector, dest) { return nil; }
    explainNoTravelVia(connector, dest) { 
        "Slut på bensin. Motorn hackar bara. Bättre att gå ut. ";
    }
;

ostraSkogen: Room 'Intill östra skogen vid vägkanten' 'intill östra skogen vid vägkanten'
    "Du står på en förhöjning på andra sidan diket vid en landsväg. Din bil står vid vägkanten. 
    En snirklig stig leder in i skogen österut. "
    east = stigen
    west = landsvagen
;

stigen: Room 'Längs en snirklig stig' 'en snirklig stig'
    ""
    west = ostraSkogen
    east = vidOvergivetHus
;
+pinne: Thing 'pinne[-n]' 'pinne';

vidOvergivetHus: OutdoorRoom 'Vid ett övergivet hus' 'vid ett övergivet hus'
    west = stigen
    east = husetsVeranda
;

husetsVeranda: OutdoorRoom 'Husets veranda (västra sidan)' 'husverandan'
    "Du står på husets veranda. En dörr leder in till huset till öst och man kan följa verandan till husets södra sida söderut"
    west = vidOvergivetHus
    east = husdorrOutside
    in asExit(east)
    south = husetsSydsida
;
+husdorrOutside: LockableWithKey, Door 'dörr[-en]*dörrar[-na]' 'dörr'
    keyList = [key]    
    dobjFor(Attack) {
        action() {
            husdorrOutside.isOpen = true;
            husdorrOutside.moveInto(nil);
            husdorrInside.moveInto(nil);
            husetsVeranda.east = huset;
            huset.west = huset;
            flis.moveInto(huset);
            "Du tar i hårt och sparkar in i dörren, plankorna som den bestod av blev till flis där din fot träffade. Några till sparkar får den att rasa ihop fullständigt. ";
        }
    }
;

husetsSydsida: OutdoorRoom 'Husets veranda (södra sidan)' 'husverandan'
    "Du står på husets veranda på södra sidan. Verandan går tillbaka västerut till husets västra sida. Ett fönster står på halvglänt här. "
    west = husetsVeranda
    north = husFonsterSydsidaUtsida
    in asExit(north)
;
+husFonsterSydsidaUtsida: Door -> husFonsterSydsidaInsida 'fönst[-er]*fönst[-rena]' 'fönster'
;


husetsKok: Room 'Köket' 'köket'
    "I kökets mitt står ett köksbord och två stolar. Köksskåp pryder västra väggen och till söder står diskhon. Ett halvöppet avställt kylskåp står här också mot östra väggen. En korridor går vidare norrut. "
    south = husFonsterSydsidaInsida
    north = huset
;
+diskhon: Container 'diskho[-n]' 'diskho'
;

++tallrik: Surface 'tallrik[-en]*tallrikar[-na]' 'tallrik';
+++sked: Thing 'sked[-en]*skedar[-na]' 'sked';

+husFonsterSydsidaInsida: Door -> husFonsterSydsidaUtsida 'fönster/fönstret*fönster' 'fönster'
    theName = 'fönstret'

;

huset: Room 'I husets vestibul' 'husets vestibul' 
    west = husdorrInside
    south = husetsKok
    east = vardagsrum
    out asExit(west)
;

+bokhylla: Container 'bokhylla[-n] hylla[-n]' 'bokhylla' 
    initSpecialDesc = "En bokhylla står här. "
;

++bok: Thing 'bok[-en]*böcker[-na]' 'bok';

++trasnidadFigur: Thing 'träsnidad figur[-en]' 'träsnidad figur' 
"En träsnidad figur av ett troll. "
;


+husdorrInside: LockableWithKey, Door  'dörr[-en]*dörrar[-na]' 'dörr'
    masterObject = husdorrOutside
    //isLocked = true
    keyList = [key]
    knownKeyList = [key]
    /*makeLocked(value) {
        // TODO: makeLocked(nil) fungerar inte (obs: körs på masterObject)
        inherited(value);
        tadsSay('TODO: makeLocked <<isLocked>>');
    }*/
;

vardagsrum: Room 'vardagsrummet' 'vardagsrummet'
    "En enkel soffa står här. "
    roomFirstDesc {
        "När du kliver in i vardagsrummet hör du något rassla till. Du ser en skugga röra sig bakom en grön sliten soffa. Du iaktar den försiktigt när du plötsligt ser något litet och ludet med en svans springa iväg från sitt gömställe och hoppa ut genom fönstret som står på glänt bakom soffan. ";
    } 
    west = huset
;
+ bord: Surface, Heavy 'bord[-et]*bord[-en]' 'bord';
++ bricka: Surface 'bricka[-n]*brickor' 'bricka';
+++ lov: Thing 'löv[-et]*löven' 'löv';
+++ matta: Surface 'matta[-n]' 'matta';
++++ bowl: Container 'skål[-en]*skålar' 'skål';
+++++ grape: Food 'grapefrukt[-en]*grapefrukter' 'grapefrukt';

+soffa: Thing 'soffa[-n]' 'soffa'
    initSpecialDesc = ""
;

//TODO: behövs fönst[-er|-ret]c eller liknande också?
/*+fonster: Openable, Fixture 'fönster[-et] fönstret*fönster' 'fönster'
    isOpen = true
;*/

+fonster: Openable, Fixture 'fonst{er,ret@d,ren@p,rena@dp}' 'fönster'
    isOpen = true
;

//


//+husFonsterSydsidaInsida: Door -> husFonsterSydsidaUtsida 'fönster/fönstret*fönster' 'fönster'


// TODO: några dörrflis,
flis: Thing 'dörrflis' 'dörrflis'
    isPlural = true
;

// ------------------------------

vastraSkogen: Room 'västra skogen vid vägkanten' 'västra skogen vid vägkanten'
    "Du ser en strand nerför kullen västerut. "
    west = strandkant
    east = landsvagen
;

strandkant: OutdoorRoom 'Stranden' 'stranden'
    east = vastraSkogen
;
