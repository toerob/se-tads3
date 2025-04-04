#charset "utf-8"
#include <adv3.h>
#include <sv_se.h> 

#define __DEBUG
#include "debug.h"


gameMain: GameMainDef
    initialPlayerChar = me
    showIntro() {
        "Du tog dig slutligen till Tuscany. Huset är äntligen ditt och det här är det första besöket du gjort sedan sedan husvisningen och den hemska budgivnigen som åt ett stort hål i både din och din frus plånbok. \b
        
        Din fru, har för övrigt har börjat packa upp alla hennes kläder inne i huset. Du planerar att delta i uppackandet, men just nu står du bara på uppfarten och njuter av den varma eftermiddagssolen som orsakar långa diagonala rogivna skuggor från sykamorträden över vägen genom det stora fältet på vägen hit. DINA sykamorträd.
        
        \b
        
        ";
    }
;

versionInfo: GameID
    IFID = '952c94dd-f92a-4970-9a00-cdcc24d038a1'
    name = 'The italian house'
    byline = 'by Tomas'
    htmlByline = 'by <a href="mailto:yourmail@address.com"></a>'
    version = '1'
    authorEmail = 'Tomas yourmail@address.com'
    desc = ''
    htmlDesc = ''
;


gameGlobal: object
    day = 1
;

hallway: Room 'Hallen' 'hallen'
    "Norrut ligger vardagsrummet. En passage leder öst till köket. Väst är badrummet. Till söder står <<houseEntranceDoorInside.isOpen?'(den öppna) ':''>> huvuddörren som går ut till uppfarten av gården. Sydväst går en vit trappa upp till den övre hallen. "
    south = houseEntranceDoorInside
    east = kitchenPassage
    north = livingRoom
    west = bathroom
    up = hallwayStairsUp
    southwest asExit(up)
    
;
+hallwayStairsUp: StairwayUp  -> hallwayStairsDown 'trappa[n]**trappor[-na]' 'trappor' isPlural = true;
+houseEntranceDoorInside: Door -> houseEntranceDoorOutside 'husentrén/dörr[-en]*dörrar[-na]' 'huvuddörr';
+kitchenPassage: ThroughPassage ->hallPassage 'passage[n]' 'passage';

kitchen: Room 'köket' 'köket'
    west = hallPassage
;
+ hallPassage: PathPassage 'passage' 'passage' "A passage leder iväg österut. ";




bathroom: Room 'badrummet' 'badrummet'
    east = hallway
;

livingRoom: Room 'vardagsrummet' 'vardagsrummet'
    south = hallway
    north = patioDoorInside
;
+patioDoorInside: Door -> patioDoorOutside 'patio door*doors' 'patio door' material = glass;
patio: Room 'patio' 'patio'
    "There's an actual POOL here. Other than that no furniture yet. Tomorrow they'll come. "
    //Add adjacent garden ?
    south = patioDoorOutside
;
+patioDoorOutside: Door -> patioDoorInside 'patio door*doors' 'patio door' material = glass;




hallwayUpstairs: Room 'Övre hallen' 'Övre hallen'
    "En vitmålad hall med dekorerade väggar. Västerut ligger sovrummet genom två dubbeldörrar, en trappa leder ner till nedre hallen."
    down = hallwayStairsDown
    west = masterBedroom
    southwest asExit(down)
;
+hallwayStairsDown: StairwayDown -> hallwayStairsUp 'trappor[-na]' 'trappor'  isPlural = true;


masterBedroom: Room 'Stora sovrummet' 'Stora sovrummet'
    "Ett stort sovrum med en stor dubbelsäng. Ugången är österut. "
    east = hallwayUpstairs
;

+bed: Bed 'dubbelsäng[-en]/säng[-en]**sängar[-na]' 'dubbelsäng'
    theName = 'dubbelsängen'
;

driveway: OutdoorRoom 'Uppfarten' 'Uppfarten'
    "Du står på uppfarten till ditt nya hus (med sin ingång norrut). En väg går sydväst genom ett stort fält kantat av sykamorträd. "
    north = houseEntranceDoorOutside
    southwest: RoomConnector {
        destination = nil
        canTravelerPass(traveler) {
            return gameGlobal.day > 1;
        }
        explainTravelBarrier(traveler) {
            // Eller så går man en bit och återvänder sedan
            "Imorgon, du är alltför utmattad för en sån slags promenad även om det är en vacker kväll. Vägen ger ett rejält avstånd till närmsta by. ";
        }
    }
;

+houseEntranceDoorOutside: Door -> houseEntranceDoorInside 'huvudingång[en]/dörr[-en]**dörrar[-na]' 'huvudingången'
    isProperName = true
;

+me: Actor;

++anteckning: Readable 'anteckning[-ar]/anteckningslapp[-en]**anteckningslappar[-na]/lapp[-en]**lappar[na]' 'anteckningslapp'
    theName = 'anteckningslappen'
    readDesc = "En TODO-lista:
       \n* Ta hand om baggaget 
       \n* Fixa mat (PIZZA och VIN)
       \n"
;



Test 'spel' ['n','z', 'ö', 'hälsa', 'kyss', 'v', 'upp', 'v', 'sitt på sängen'] [anteckning];
