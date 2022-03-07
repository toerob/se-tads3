#charset "utf8"
#include <adv3.h>
#include <sv_se.h> 


karl:  Actor 'karl' 'Karl' @landsvagen
    isProperName = true
    posture = sitting
;


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

husetsVeranda: OutdoorRoom 'Husets veranda' 'husverandan'
    west = vidOvergivetHus
    east = husdorrOutside
    in asExit(east)
;
+husdorrOutside: Door -> husdorrInside 'dörr[-en]*dörrar[-na]' 'dörr';

huset: Room 'I husets vestibul' 'husets vestibul' 
    west = husdorrInside
    out asExit(west)
;
+husdorrInside: Door -> husdorrOutside 'dörr[-en]*dörrar[-na]' 'dörr';


// ------------------------------

vastraSkogen: Room 'västra skogen vid vägkanten' 'västra skogen vid vägkanten'
    "Du ser en strand nerför kullen västerut. "
    west = strandkant
    east = landsvagen
;

strandkant: OutdoorRoom 'Stranden' 'stranden'
    east = vastraSkogen
;


