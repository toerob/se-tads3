#charset "utf-8"
#include <adv3.h>
#include <sv_se.h> 


/*


>x träd
Jag ser inget ovanligt med det. 


Ånga bildas i den kyliga luften då jag andas. 

>se in i det
// TODO: Jag ser ingen i det här. 

*/

argon: Actor 'argon' 'Argon' @stranden
    pcReferralPerson = FirstPerson
;


modify OutdoorRoom
    atmosphereList: ShuffledEventList {[
        'Ånga bildas i den kyliga luften då jag andas. ',
        'Jag hör ett djur i skogen'
    ]}
;
class Coin: Thing 'mynt[-et]*mynt[-en]' 'mynt';



stranden: OutdoorRoom 'Stranden'
        "Det är kväll och jag står vid en kall, gyttjig strand intill riket riket Num rad 'dar. Sjön är upplyst endast av månen och blänket i det kalla, svarta vattnet.\n
        Långt bortom bortom sjön anar jag mäktiga bergskedjor, dödliga klippväggar, is och snö på extrema höjder.\n
        En liten stig leder in mellan träden vid stranden söderut. 
        "
        south = strandstigen
;

+ihaligtTrad: Container, Fixture 'träd[-et]*träd[-en]' 'träd'
    dobjFor(Search) {
        verify() {
            
        }
        action() {
            sack.discover();
            "{Du/han} söker igenom det ihåliga trädet och hittar en säck. ";
        }
    }
;

+sack: BagOfHolding, Hidden 'säck[-en]' 'säck';
++mynt: Coin;



+sten: Thing 'sten[-en]*stenar[-na]' 'sten'
    "Stenen har vassa kanter och skulle kunna göra stor skada vid ett kast. "
    dobjFor(ThrowAt) {
        verify() { }
        check() {
            if(gIobj == lampa) {
                failCheck('En del av mig ville men det skulle skada lampan. ');
            }
        }
    }
;





+stugdorrsnyckel: Key 'nyckel[-n]' 'nyckel';



strandstigen: OutdoorRoom 'Stigen i skogen'
        "I skogen är det mörkt och tyst. En stig går från söder till norr medan en mindre stig går iväg sydväst in i en tät skog. "
    north = stranden
    southwest = tempelplats
    south = huvudvagen
;


tempelplats: OutdoorRoom 'Tempelplats'
    northeast = strandstigen
;

huvudvagen: OutdoorRoom 'Huvudväg'
    north = strandstigen
    northeast = byn
    southwest = vid_stuga
    south = vid_fortet
;

byn: OutdoorRoom 'Byn'
    north = strandstigen
    southwest = huvudvagen
;



vid_stuga: OutdoorRoom 'Vid en stuga'
    "..."
    northeast = huvudvagen
    east =  huvudvagen
    inorth = stugdorrenOutside
    west = stugdorrenOutside
;
+stugdorrenOutside: LockableWithKey, Door -> stugdorrenInside 'dörr[-en]*dörrar[-na]' 'dörr'
    keyList = [stugdorrsnyckel]
;


insida_stuga: OutdoorRoom 'I stugan'
    "..."
    east = stugdorrenInside
    out = stugdorrenInside
;
+stugdorrenInside: LockableWithKey, Door -> stugdorrenOutside 'dörr[-en]*dörrar[-na]' 'dörr'
    keyList = [stugdorrsnyckel]
;



lampa: LightSource 'svarta lykta[-n]/lampa[-n]*lampor[-na]' 'lampa' @stranden
   
;

vid_fortet: OutdoorRoom 'Vid bergets portar'
    "Du står intill ett skogsbryn där huvudvägen dels går in i skogen dels fortsätter söderut mot en enorm bergskedja. Vägen går fram till ett fort inbyggt i berget. "
    north = huvudvagen
;


