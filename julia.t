#charset "UTF-8"
#include <adv3.h>
#include <sv_se.h> 

juliaGlobal: object 
    showIntro() {
        "
        <i>
        Tre skola de gå,\n 
        till skogen och få,\n
        sju sorters blommor,\n
        att bära krans ,\n
        till midsommarnattens sånger.\b
        </i>
        
        \bDu hade aldrig brytt dig särskilt mycket i traditionen. Men här befann du dig ändå. Dina vänner ivrigt letandes efter sju sorter på ängen. Du hade hittat den mest uppenbara. Tusenskönan. Bara sex stycken kvar. 
        \b
        ";
    }
;

angen: OutdoorRoom 'Ängen' 'ängen'
    "Du är på en mycket grön och frodig sommaräng. Det är lä och hett ute. Glädjefullt liv hörs från din hemby längre bort (i nordvästlig riktning) och fågelkvitter och surrande bin kring blommorna hörs runtom dig. 
    
    Ett Skogsbryn tar vid österut.
    "
    east = skogsbrynetInPassage
;

+skogsbrynetInPassage: ThroughPassage -> skogenUtPassage 'skogsbryn[-et]' 'skogsbrynet' 
    noteTraversal(traveler) {
        if(traveler == gPlayerChar) {
            "Du kliver in i skogen. ";
        }

    }
;

skogen: OutdoorRoom 'skogen' 'skogen'
    "Skogen..."
    west = skogenUtPassage
    east = gardsgard
;
+skogenUtPassage: ThroughPassage -> skogsbrynetInPassage 'skogsbryn[-et]' 'skogsbrynet'
    noteTraversal(traveler) {
        if(traveler == gPlayerChar) {
            "Du kliver ut ur skogen. ";
        }
    }
;


jagare:  Actor 'hjortjägare[-n]/jägare[-n]' 'hjortjägare'
    theName = 'hjortjägaren'
    isProperName = nil
    isHim = true
;

+jagareFetchDeerAgenda: DelayedAgendaItem
    isReady = inherited && deer.traffadAvPil
    readyTime = 2
    invokeItem() {
        jagare.moveInto(gardsgard);
        "En hjortjägare kliver fram ur skogen och går fram till hjorten. Han tar tag i kronen och dra hjorten mot kärran. ";
        isDone = true;
    }
    initiallyActive = true
;


gardsgard: OutdoorRoom 'I skogen, intill en gärdsgård' 'gärdsgårdens början'
    west = skogen
;




+karra: Thing, Heavy, Container 'kärra[-n]*kärror[-na]' 'kärran'
    specialDesc = "En kärra stod intill gärdsgården. "
; 




deer: Actor 'hjort[-en]' 'hjort'
    isIt =  true
    traffadAvPil = nil
    location = skogen
;
+deerSurprisedAgendaItem: AgendaItem
    isReady = deer.canSee(gPlayerChar)
    
    invokeItem() {
        if (deer.getOutermostRoom() == skogen) {
            "En hjort står och betar mitt på vägen. Den tittar plötsligt upp på dig, vänder sig om och springer iväg österut. ";
            deer.scriptedTravelTo(gardsgard);
        } else {
            "Du ser hjorten springa vidare. Plötsligt flyger en pil in och träffar den i sidan. Den brölar till och springer omkull intill vägen. ";
            deer.traffadAvPil = true;
            isDone = true;
        }
    }
    initiallyActive = true
;


julia: Actor 'Julia' 'Julia'
    isHer = true
    location = angen
    isProperName = true 
;

// TODO: gruppera
mona: Actor 'Mona' 'Mona'
    isHer = true
    location = angen
    isProperName = true 
;

jenny: Actor 'Jenny' 'Jenny'
    isHer = true
    location = angen
    isProperName = true 
;
