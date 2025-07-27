#charset "utf-8"
#include <adv3.h>
#include <sv_se.h> 

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
;

sjon: OutdoorRoom 'Sjön' 'sjön' "Du står på en stenig strand vid en insjö en varm och behaglig sommardag, någonstans i värmland. 
   Du ser en stuga norrut."
   north: NoTravelMessage { "Du känner dig inte riktigt redo för äventyr ännu. " }
   atmosphereList: ShuffledEventList {[
        'Du ser att det vakar på vattenytan längre ut. ',
        'Du hör fåglar kvittra i dialog. ',
        nil
   ]}
;
+Decoration 'glittrande rogivande soliga solljus+et in|sjö+n/vatt:en+net' "Det glittrar rogivande av solljuset i den lilla insjön. ";
+Decoration 'stenig+a strand+en' "Den steniga stranden följer den lilla sjön runt. ";
+Decoration 'stuga+n' "Du känner igen den här stugan någonstans ifrån, men du kan inte sätta fingret på det. ";

du: Actor 'du'
  location = sjon
  pcReferralPerson = SecondPerson
;

+kompass: Thing 'mystisk+a kompass+en' 
    "En mystisk kompass som du inte minns när du hittade, eller var... ";