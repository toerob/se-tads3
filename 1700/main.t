#charset "utf-8"
#include <adv3.h>
#include <sv_se.h> 

#define __DEBUG
#include "../debug.h"


versionInfo: GameID
    IFID = 'UUID'
    name = 'Staden'
    byline = 'by Tomas'
    htmlByline = 'by <a href="mailto:yourmail@address.com"></a>'
    version = '1'
    authorEmail = 'Tomas yourmail@address.com'
    desc = 'Ett 1700-tals äventyr i frankrike'
    htmlDesc = 'Ett 1700-tals äventyr i frankrike'
;


gameMain: GameMainDef
    initialPlayerChar = du
    usePastTense = true

    showIntro() {
        "
        Nådens år 1836. 
        Den livliga franska staden Bordeaux ljuder av de typiska aktiviteterna.
        Ivriga dialoger på marknaden, kattskrik, bebisgråt och allmäna klagomål som ekar längs de trånga kullerstansgatorna inklämnda mellan husväggarna.
        ";
    }
;

torget: OutdoorRoom 'Place des Quinconces'
    "Torget   "
;

du: Actor 'du' 
  location = torget
; 