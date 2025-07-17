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

+hast: Actor 'häst+en' 'häst'
  owner = hantvig
  //isProperName = nil
;

skogsstigen: OutdoorRoom 'Skogsstigen'
  "..."
  east = sjostranden
;

+svarttroll: Actor '(svart+a) *svarttrollen+a troll+en' 'svarttroll'
  isPlural = true

  // theName kommer användas för att skriva "Svarttrollena står där."
  // pga att Actor används. (Till skillnad från Thing, där "Några svarttroll står där." används.)
  //
  // Detta är likadant i den engelska versionen, så här gör vi samma och ändrar det 
  // genom att skriva en specialDesc istället.

  specialDesc = "Några svarttroll lurar i mörkret bakom träden. "
;

+trees: Decoration 'träd+en' 'träd' "Träden är knotiga och mörka. " isPlural = true;


hantvig: Actor 'hantvig' 'Hantvig' @skogsstigen //@sjostranden
  pcReferralPerson = ThirdPerson
  isProperName = true
;
