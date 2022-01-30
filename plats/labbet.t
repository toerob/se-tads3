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

+banken: Surface 'bänk/bänken*bänkarna'  'bänk' 
    //theName = 'bänken'
    isUter = true
;

//++fridge: OpenableContainer 'kyl[-en]' 
++fridge: OpenableContainer 'kyl/kylen/kylskåp' 'kyl'
    theName = 'kylen'
    isUter = true
;

+++berries: Food 'bär/bären' 'bär'
    theName = 'bären'
    isUter = true
    isPlural = true
;
+++krut: Thing 'krut/krutet' 'krut'
    theName = 'krutet'
    isPlural = true
;


++labbnyckel: Key 'nyckel/nyckeln' 'nyckel'
    //theName = 'bänken'
    isUter = true
    theName = 'nyckeln'
;

++sockerbit: Thing 'sockerbit' 'sockerbit'
    isUter = true
;


+labbetDoorInside: LockableWithKey, Door -> labbetDoorOutside 'labbdörr*dörrar dörr*dörrar' 'labbdörr'
    isUter  = true
    theName = 'dörren'
    keyList = [labbnyckel]
;


+professornsStol: Chair 'stol/stolen*stolar' 'stol'
    isUter = true
    isOwnedBy = [professor]
    disambigName = 'professorns stol'
    theName = 'stolen'
;

+minStol: Chair 'stol/stolen*stolar' 'stol'
    isUter = true
    isOwnedBy = [me]
    disambigName = 'din stol'
    theName = 'stolen'
;

++jacka: Wearable 'jacka*jackor/jackan' 'jacka'
    isUter = true
    isOwnedBy = [me]
    //theName = 'jackan'
;
+++ficka: Container, Component 'jackficka/jackfickan' 'jackficka'
    isUter = true
    theName = 'jackfickan'
;