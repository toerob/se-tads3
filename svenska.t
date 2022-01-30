#charset "UTF-8"

/*
 *   Copyright (c) 1999, 2002 by Michael J. Roberts.  Permission is
 *   granted to anyone to copy and use this file for any purpose.  
 *   
 *   This is a starter TADS 3 source file.  This is a complete TADS game
 *   that you can compile and run.
 */

#include <adv3.h>

#include "sv_se.h" //en_us.t


gameMain: GameMainDef
    initialPlayerChar = me
    showIntro() {

    }

    
;

versionInfo: GameID
    IFID = '' // obtain IFID from http://www.tads.org/ifidgen/ifidgen
    name = 'Exempel 1'
    byline = 'av Tomas Öberg'
    htmlByline = 'av <a href="mailto:tomaserikoberg@gmail.com">Tomas Öberg</a>'
    version = '1'
    authorEmail = 'Tomas Öberg tomaserikoberg@gmail.com'
    desc = 'Exempel 2'
    htmlDesc = 'Exempel 2'
;

me: Actor 'du' 'du' @labbet
;


//FIXME: x stol (om det finns flera att välja på)