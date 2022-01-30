#charset "UTF-8"
#include <adv3.h>
#include <sv_se.h> 


korridor: Room 'korridoren' 'korridoren'
    "Du står i en lång korridor. Västerut står en <<if labbetDoorOutside.isOpen>>öppen<<else>>stängd<<end>> dörr."
    west = labbetDoorOutside
;

+greenApple: Food 'grönt gröna äpple/äpplet' 'grönt äpple'
    "Det ser ut att vara ett gott äpple"
    theName = 'gröna äpplet'
    //disambigName = 'gröna äpplet'

;

// TODO: additional scanning in the words

Thing template +article? 'vocabWords' 'name' @location? "desc"?;


+labbetDoorOutside: LockableWithKey, Door -> labbetDoorInside 'labbdörr*dörrar dörr*dörrar' 'labbdörr'
    isUter = true
    theName = 'dörren'
    keyList = [labbnyckel]
;

class Labbrock: Wearable 'labb rock/rocken/labbrock/labbrocken*labbrockarna' 'labbrock'
    isUter =true
    isWorn = true
;

+mikael: Actor 'Mikael' 'Mikael'
    "Mikael är en stackars student i den här galna labbmiljön. "
    isProperName = true
    isHim = true
;

++mikaelsLabbrock: Labbrock 'Mikaels' isOwnedBy = [mikael];

++redApple: Food 'röda rött äpple/äpplet' 'rött äpple'
    "Det ser ut att vara ett gott äpple"
    theName = 'röda äpplet'
    //disambigName = 'röda'
;




+anna: Actor 'Anna' 'Anna'
    "Anna är en stackars student i den här galna labbmiljön. "
    isProperName = true
    isHer = true
;

++annasLabbrock: Labbrock 'Annas' isOwnedBy = [anna];
