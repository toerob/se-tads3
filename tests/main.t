#charset "utf-8"
#include <adv3.h>
#include <sv_se.h> 
#include "../../../code/tads3/tads3-unit-test/unittest.h"

/*
"{din} hand" är en beskrivning av ett objekt (handen),
 alltså används itPossAdj (possessivt adjektiv).

→ Det är din hand → "din" beskriver "hand".
 "Handen är {din}" → då används itPossNoun, eftersom "din" står för sig själv.
*/

versionInfo: GameID
  IFID = '38da5fdf-9077-4043-bfe1-14c83c087c81'
  name = 'tester för svenska översättningen av adv3'
  byline = 'by Tomas Öberg'
  htmlByline = 'by <a href="mailto:yourmail@address.com">Tomas Öberg</a>'
  version = '1'
  authorEmail = 'Tomas Öberg yourmail@address.com'
  desc = 'enhetstester'
  htmlDesc = 'enhetstester'
;
gameMain: GameMainDef
    initialPlayerChar = spelare2aPerspektivDu
    usePastTense = true
;


