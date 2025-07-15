#charset "utf-8"
#include <adv3.h>
#include <sv_se.h> 
#include "testunit.h"


#define __DEBUG
#include "../debug.h"
#include "../tests2/tests2.h"

/*
modify mainOutputStream
    hideOutput = true
    capturedOutputBuffer = nil // = static new StringBuffer()
    writeFromStream(txt) {
        if(capturedOutputBuffer == nil) {
          capturedOutputBuffer = new StringBuffer();
        }
        capturedOutputBuffer.append(txt);
        // Swallow the message
        if(!hideOutput) {
          inherited(txt);
        }
    }
;
// Shortcut to access the output without lengthy comparisons
#define o toString(mainOutputStream.capturedOutputBuffer)
*/


/**
 * Tester för att säkerställa att olika sätt att skapa upp ett objekt med vocabWords beter sig enligt förväntat sätt.
 *   
 */
versionInfo: GameID
  IFID = '38da5fdf-9077-4043-bfe1-14c83c087c81'
  name = 'Tester för svenska översättningen av adv3'
  byline = 'by Tomas Öberg'
  htmlByline = 'by <a href="mailto:yourmail@address.com">Tomas Öberg</a>'
  version = '1'
  authorEmail = 'Tomas Öberg yourmail@address.com'
  desc = 'enhetstester'
  htmlDesc = 'enhetstester'
;

gameMain: GameMainDef
    initialPlayerChar = me
    usePastTense = true
;


tronrummet: Room 'tronrummet' 'tronrummet'
;
+glasMedVatten: Thing 'glas+et vatt:en+net' 'glas med vatten';

+me: Actor 'du' 'du';
++skold: Thing 'sköld+en' 'sköld';

+arthur: Actor 'arthur' 'Arthur' @tronrummet
  isProperName = true
  isHim = true
;
++excalibur: Thing 'excalibur svärd+et' 'Excalibur'
  isProperName = true
  owner = arthur
;

Test 'run' [
  'x glas',              // Du såg inget ovanligt med det.
  'x glaset',            // Du såg inget ovanligt med det.
  'x glasets vatten',    // Du såg inget ovanligt med det.
  'x glaset med vatten', // Du såg inget ovanligt med det.
  'x arthurs svärd',     // Du såg inget ovanligt med det.

  'x arthurs sköld',     // Arthur verkade inte ha någon sådan sak.
  'x mitt svärd',        // Du verkade inte ha någon sådan sak.

  'x min sköld',         // Du såg inget ovanligt med den.
  'släpp min sköld',     // Släppt.
  'x min sköld'          // Du verkade inte ha någon sådan sak.

];