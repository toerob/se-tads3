#charset "UTF-8"
#include <adv3.h>
#include <sv_se.h> 


en_strand: OutdoorRoom 'strand+en' 'strand'
    "Du står på en sandstrand intill en brygga en het sommardag. Någonstans hör du en kyrkklocka slå. En hackspett bygger ett bo någonstans. "
    south = kullen
;

+ applePie : Food 'äppelpaj+en*äppelpajer+na' 'äppelpaj';
+ sandstrand : Decoration 'sandstrand+en' 'sandstrand';
+ brygga : Decoration 'brygga+n' 'brygga';
+ sommardag : Decoration 'sommardag+en' 'sommardag';
+ stuga : Decoration 'stuga+n' 'stuga';
+ hink: Container 'hink+en' 'hink'; 
+ apple: Food 'äpple+t' 'äpple'; 
+ dynor: Surface 'dyna+n*dynor+na' 'dynor'
    isPlural = true
    theName = 'dynorna'    
;
//+ dynor: Surface vocabWords = '' name = 'dynor+na';



kullen: OutdoorRoom 'kullen' 'kullen'
    "Du står på en kulle i skogen, överskådandes en liten sjö norrut. En stig leder ner ditåt. Stigen går även ner i djupare skog söderut. "
    north = en_strand
;


