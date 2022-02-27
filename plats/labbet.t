#charset "UTF-8"
#include <adv3.h>
#include <sv_se.h> 


labbet: Room 'Labbet'
    "Du står i laboratoriumet. Väggarna är fyllda med tavlor på periodiska systemet och annat kemirelaterat. "
    east = labbetDoorInside
    atmosphereList: EventList {[
        'Det fräser till i ett provrör. ',
        'en kylskåpsfläkt varvar upp. ',
        'en kylskåpsfläkt varvar ner. ',
        'professorn muttrar. ',
        'Det smäller plötsligt till från ett provrör på bänken. <q>Oj!</q> skrokkar professorn. '
    ]}
;
+ladbil: Vehicle, Chair 'lådbil[-en]' 'lådbil';

+banken: Surface 'bänk[-en]*bänkar[-na]'  'bänk' 
;

++maskin: Thing, Heavy 'espressomaskin[-en]/maskin[-en]' 'espresso maskin'
    isListed = true
;
+++knapp: Component, Switch 'knapp[-en]' 'knapp';




++fridge: OpenableContainer 'kyl[-en]/kylskåp[-et]*kylar[-na]' 'kyl';

+++berries: Food 'bär[-en]' 'bär'
    isPlural = true
;
+++krut: Thing 'krut[-et]' 'krut'
    isPlural = true
;


++labbnyckel: Key 'nyckel[-n]' 'nyckel';
++sockerbit: Thing 'sockerbit[-en]' 'sockerbit';

+labbetDoorInside: LockableWithKey, Door -> labbetDoorOutside 'labbdörr[-en]/dörr[-en]*dörrar[-na]' 'labbdörr'
    keyList = [labbnyckel]
;


+professornsStol: Chair 'stol[-en]*stolar' 'stol'
    isUter = true
    isOwnedBy = [professor]
    disambigName = 'professorns stol'
    theName = 'stolen'
;

+minStol: Chair 'stol[-en]*stolar' 'stol'
    isUter = true
    isOwnedBy = [me]
    disambigName = 'din stol'
;

++jacka: Wearable 'jacka[-n]*jackor[-na]' 'jacka'
    isOwnedBy = [me]
;
+++ficka: Container, Component 'jackficka[-n]' 'jackficka'
;