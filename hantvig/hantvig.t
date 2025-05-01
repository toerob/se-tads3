#charset "utf-8"
#include <adv3.h>
#include <sv_se.h> 

#define __DEBUG
#include "../debug.h"


versionInfo: GameID
    IFID = '952c94dd-f92a-4970-9a00-cdcc24d038a1'
    name = 'Hantvig och mörkret'
    byline = 'by Tomas'
    htmlByline = 'by <a href="mailto:yourmail@address.com"></a>'
    version = '1'
    authorEmail = 'Tomas yourmail@address.com'
    desc = ''
    htmlDesc = ''
;


gameMain: GameMainDef
    initialPlayerChar = hantvig
    usePastTense = true

    showIntro() {
        "
          Hantvig satt intill strandkanten och betraktade hans kanske sista solnedgång. Tjärnens yta var helt stilla. I fjärran hörde han en trana skrika ett brustet vårläte. Brustet var även Hantvigs hjärta. Han märkte det inte men hans knogar vitnade om svärdsskaftet. 
          \b

        ";
    }
;


sjostranden: OutdoorRoom 'Sjöstranden'
  "Sjöstranden blickade ut över det mörka vattnet i skymningen. Mörka moln täckte stjärnorna och förutom konturerna av landskapet var det enda ljus som syntes Hantvigs hästs glimmande ögon. En stig ledde in i ett kolsvart mörker till väst. En stig som var kantad av knotiga, hotfulla träd. "
  west = skogsstigen
;

+hast: Actor 'häst[-en]' 'häst'
  owner = hantvig
  //isProperName = nil
;

skogsstigen: OutdoorRoom 'Skogsstigen'
  "..."
  east = sjostranden
;

//TODO: Oklart om detta har gjorts rätt, jämför med engelska versionen "pair of" 
// "De svarttroll"  -> "Några svarttroll"
+svarttroll: Actor 'några/svarttroll[-en]**svarttroll[-ena];;troll[-en]**troll[-ena]' 'några svarttroll'
  theName = 'svartrollen'
  coPluralName = 'några svarttroll'

  isProperName = true
  isPlural = true
  canMatchThem = true
;

hantvig: Actor 'hantvig;;;' 'Hantvig' @sjostranden
  pcReferralPerson = ThirdPerson
  isProperName = true
;
