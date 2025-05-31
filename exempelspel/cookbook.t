#charset "utf-8"
#include <adv3.h>
#include <sv_se.h> 

#define __DEBUG
#include "../debug.h"

versionInfo: GameID
    IFID = '952c94dd-f92a-4970-9a00-cdcc24d038a1'
    name = 'TODO'
    byline = 'by Tomas'
    htmlByline = 'by <a href="mailto:yourmail@address.com"></a>'
    version = '1'
    authorEmail = 'yourmail@address.com'
    desc = ''
    htmlDesc = ''
;
gameMain: GameMainDef
    initialPlayerChar = du
    showIntro() {
        "Färdiga ting att nyttja";
    }
;

du: Actor 'du' @skogen
  text = 'mgt'
;

skogen: OutdoorRoom 'I skogen, vid en bäck' 'skogsbäcken';

+backen: Decoration 'bäck+en/vatten/vattnet'
    // Bäcket är en vätska med en liten vatten på sina ställen
  aName = 'liten vattenbäck'
  dobjFor(Take) {
    verify() {}
    action() {
      local water = new Water();
      water.moveInto(du);
      "Du formar dina händer till en skål och fyller den med vatten. ";
    }
  }
;

class Water: Thing 'bäck^s+vatten/vattnet/vätska+n' 'vatten'
  // Den definitiva formen av vattnet är oregelbundet, så här får vi hjälpa till med "vattnet"
  definitiveForm = 'vattnet' 
  isMassNoun = true
  // Utan aName får vi namnet 'vatten' utan artikel alls som aName, 
  // det är ok men här vill vi betona att det är just "lite"
  aName='lite vatten' 
  quantity = 3
  handle = nil
  construct() {
    handle = new Daemon(self, &dripDaemon, 0);
  }
  dripDaemon() {
    quantity--;
    if(quantity <= 0) {
      "Det lilla vatten du bar på har nu runnit bort. ";
      self.moveInto(nil);
      eventManager.removeEvent(handle);
      handle = nil;
    }
  }
  finalize() {
    "<<self.theName>> REMOVED";
  }
;
