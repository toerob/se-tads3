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
    usePastTense = true

    showIntro() {
        "Din farfars stuga ligger i en avlägsen del av skogen. Du har just kommit hit för att städa upp efter din farfar som dog förra året. Stugan är gammal och innehar många hemligheter. Du har alltid trivts att vara här.  
        \b
        Men en sak har du alltid funderat över. Det gamla gökuret som hänger på väggen. Det har alltid stått still. Du har aldrig sett det gå. Du har alltid undrat varför. Kanske är det en hemlighet som din farfar ville att du skulle lösa?
        \b
        ";
    }
;
sjon: OutdoorRoom 'Sjön' 'sjön'
  "Du står vid sjön. Det är ljust och varmt här. Du kan se sjön glittra i solljuset utanför. Det finns en dörr som leder till stugan i väster. "
  west = koket
;

koket: OutdoorRoom 'Stugans kök' 'stugans kök'
  "Du står i köket. Det är ljust och varmt här. Detta är en gammal stuga med en gammal historia. Du kan se ut genom fönstret och se sjön glittra i solljuset utanför. Det finns en dörr som leder ut till stugan till öster. Det finns också en dörr som leder till sovrummet i väster.  På väggen hänger det gamla gökuret. "
  west = sovrummet
  east = sjon
;

+gokur: OpenableContainer, Heavy 'gökur+et/klocka+n'
  "Ett gammal gökur som hänger på väggen. Det har alltid stått still. "
  fixat = nil
  makeOpen(stat) {
    inherited(stat);
    if (stat) {
      "Du öppnar gökuret. Inuti ser du ett gammalt intrikat maskineri av kugghjul och fjädrar. Du kan se att det saknas ett kugghjul. Kanske är det därför det inte fungerar? ";
    } else {
      "Du stänger gökuret. ";
    }
  }


;

++visarna: Component 'visarna'
  "Visarna på klockan är gamla och rostiga. De har stått still så länge du kan minnas."
   isPlural = true
;


+hemligLucka: HiddenDoor 'lucka+n'
  "En lucka i väggen. "
;

sovrummet: OutdoorRoom 'Sovrummet' 'sovrummet'
  "Du står i sovrummet. Det är ljust och varmt här. Du kan se ut genom fönstret och se sjön glittra i solljuset utanför. Det finns en dörr som leder till köket i öster. "
  east = koket
;

+skap: Heavy, OpenableContainer 'skåp+et' 
  "Ett gammalt skåp som står i hörnet av rummet. Det är fullt med gamla kläder och andra saker. "
;
// TODO: "ta det" kugghjulet
// TODO: "placera kugghjulet i gökuret"
++kugghjul: Thing 'kugg+hjul+et'
  initial = "Ett gammalt kugghjul som ligger i skåpet. Det ser ut som det har legat där länge. "
  location = skap
  dobjFor(PutIn) {    
    check() {
      if (gIobj && gIobj.location != gokur) {
        reportFailure('Det skulle göra föga nytta att placera kugghjulet där. ');
      }
    }
    action() {
      gokur.fixat = true;
      "Du placerar kugghjulet i gökuret. ";
    }
  }
;


du: Actor 'du'
  location = koket
  pcReferralPerson = SecondPerson
;

+apple: Thing 'goda smaskiga gröna äpple+t/frukt+en*äpplen+a frukter+na';
+tranbar: Thing 'tranbär^s+juice+paket+et' 'tranbärsjuicepaket';


Test 'spelet' ['väst', 'öppna skåp', 'ta kugghjul', 'öst', 'öppna lucka', 'placera kugghjul i gökuret'];

/*
Start: Eliya lämnar byn med sin mantel och en tygdocka från sin mor.

Möter Kråkan, som talar i motsägelser:
Ger ledtrådar som bara blir begripliga när man har hört flera
Val: Ignorera kråkan eller försök förstå den (avgör om kråkan dyker upp igen som hjälp)

Möter Ekonas Träd:
En plats där ekon av Eliyas egna tankar återkommer snett

Val: Svara sanningsenligt eller ljug för att skydda dig själv
Påverkar hur spegelpojken ter sig senare





En bro som bara bär den som inte vet vart den ska

En gåta viskad av vinden, men bara om du lyssnar genom en sovande blomma

Ett ögonblick där spelaren får välja vad hon offrar – sitt namn, sitt minne eller sin sångröst


*/