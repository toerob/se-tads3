#charset "utf-8"
#include <adv3.h>
#include <sv_se.h> 

#define __DEBUG
#include "../debug.h"

versionInfo: GameID
    IFID = '70aba847-c325-4e1b-9460-2a8a2f9cfd5b'
    name = 'Sarkofagen'
    byline = 'by Tomas'
    htmlByline = 'by <a href="mailto:yourmail@address.com"></a>'
    version = '1'
    authorEmail = 'Tomas yourmail@address.com'
    desc = ''
    htmlDesc = ''
;


gameMain: GameMainDef
    initialPlayerChar = me
    usePastTense = true

    showIntro() {
        me.setPronounObj(sarkofag);
        "Du, Arthur, en framstående arkeolog har precis hittat en dold gravkammare under sanden i ett utgrävninsområde. 
        
        Du har precis tagit dig in i gravkammaren.
        En sarkofag vilar här i mitten av det spartanskt utsmyckade rummet. Det är något märkligt med den dock. Den är inte skapad av ett tidsenligt material. Materialet är kromliknande och strömlinjeformad, Teknologiskt omöjlig att framställa på faraoernas tid.          \b
        ";
    }
;


kryptan: Room 'Kryptan'
  " "
;

+sarkofag: Thing 'sarkofag[-en]' 'sarkofag'
    "Den är inte skapad av ett tidsenligt material. Den är kromliknande och strömlinjeformad."

  isProperName = true
  feelDesc() {
    me.moveInto(tempel);
    "Du lägger tanklöst men försiktigt din hand på sarkofagen,\b
    
    Med ens börjar ett dovt surrande höras och ytan som din hand vilar på skiftar färg och lyser upp i gult. Ytan blir varm. Du rycker undan handen i en instinktsfull blandning av förskräckelse och fascination. 
    \b
    En virvelström av sand och damm börjar dra upp i rummet runtom kistan, samtidigt som glöden på ytan koncentreras till en koncentrerad punkt mitt i kistan. När den smalnar av skjuter en stråle rakt upp i taket. Du backar mot väggen men iakttar storögt strålen samtidigt som du skyddar ansiktet mot den häftiga virvelvinden som tilltar mer och mer i styrka och hastighet.
    \b
    Ljusstrålen intensifieras och börjar breda ut sig och blir alltmer klotformad. Ljusarean närmar sig dig där du står tryckt mot väggen. När ljuset når dig blir ditt synfält helt vitt. Ljudet surrar högt och som ur en mardröm. Ljusa tjutande övertoner börjar höras och din kropp hettas upp av dess värme. Ljus, ljud och hetta, allting stiger till ett crescendo och på kulmen av det crescendot kommer en åksjuka som om av att åka hiss i raketfart. Det susar i magen och det känns som om du ska slitas i stycken. Du finner dig oförmögen att röra dig dock, fastfrusen där du står. 
    \b
    Med ens stannar allt upp. Ljus, ljud och ebbar ut. Världen står stilla igen. Beckmörker och kyla börjar omge dig. Du vet inte var, men du är någon annanstans nu.
    \b
    \b";

    me.lookAround(true);
  }
;

+me: Actor 'jag';


tempel: Room 'Mörker' 'salen'
  desc  {
    roomName = 'Stensal i mörker';

    "<<one of>>Du upplever rummet genom din hörsel. Av ekon från dina rörelser kan du förnimma att det är en större sal. Det är högt i tak med tanke på det eko du hör av vinden. 

    Du tar ett försiktigt, prövande steg och hör ljudet fortplanta sig igen. Golvet känns stenbelagt. 

    Du känner dig om och finner ett altarliknande objekt i midjehöjd. Dina fingrar följer de sirliga mönstren men du känner inte igen den egendomliga stilen alls, trots alla dina år som arkeolog. 

    Du fortsätter din upptäcksfärd i mörker längs altaret. På sidan närmast dig känner du en basrelif av vad som känns som ormskepnader. Något som får dig att skälva till av obehag. ”Ondska”, muttrade du. 

    Vid det yttrande hör du något i andra änden av rummet. Som om något hasade till. Du vänder dig hastigt om. Mörkret döljer nästan allt men du kan ana konturerna av en stor trappa i mitten och valvbågar på båda sidor, i den högra, där ljudet hördes anar du en mörk alkov.


    <<or>>

    Du står i en mörk stensal, högt i tak och med stora valvbågar längs väggarna där små alkover i mörkret sticker in. I främre delen av rummet syns konturerna av en trappa. 
    \b
    
    Du anar och vet om sedan tidigare ett altarliknade objekt i mitten av salen. 
    <<stopping>>
    ";
  }

  atmosphereList = ['En sval vind kyler din hjässa och kropp.']
  north: TravelMessage {
    travelDesc = "<<one of>>En lång stund senare har du tagit dig fram till trappan.<<or>><<stopping>>"
    destination = bottenAvTrappa
  }
;

bottenAvTrappa: Room 'botten av en trappa' 'botten av trappan'
  "Du står vid foten av en enormt bred trappa gjord av märklig sten"

  south  = tempel
  north asExit(up)
  up : TravelMessage {
    destination = toppenAvTrappan
    travelDesc = "<<one of>>Ljuset kommer definitivt uppifrån. Men där är fortfarande mörkt. Trappstenarna känns mjuka som en romersk staty.  Du kliver upp några steg i taget. En yrsel kom över dig när du rör dig i altitud. När du slutligen når trappans topp är yrseln särskilt skarp. Du känner plötsligt hur din mage vänder sig ut och in och hur du nödgas ställa dig på knä för att kräkas med huvudet snurrar. Ekot är mindre här uppe men fortplantar sig tydligt i salen nedanför. Du sitter  där en bra stund och djupandas till dess att yrseln avtar. En överlevnadsinstinkt får upp dig på benen igen och du pressar dig vidare att gå igenom den svagt upplysta korridoren.<<or>>Med försiktiga steg går du upp för trappan<<stopping>>"
  }
;

toppenAvTrappan: Room 'toppen av en trappan' 'toppen av trappan'
  ""
  north = tKorsning
  down : TravelMessage {
    destination = bottenAvTrappa
    travelDesc = "Med försiktiga steg går du ner för trappan"
  }
;

tKorsning: Room 't-korsning' 't-korsningen'
  ""
  south = toppenAvTrappan
  east: TravelMessage {
    destination =  sal
    travelDesc = "Du går mot korsningen och till höger. Du möts på nytt av en ytterligare en trapp. Denna gång tar du stegen med mer respekt än förut men illamåendet är inte lika påtagligt nu och du tar dig upp för trappan fortare än tidigare. "
  } 
;

sal: Room 'sal' 'sal'
  "Vid trappans topp ser du ut över en mindre sal med ett högt valvbågat tak. Längs sidorna finns breda, rektangulära  fönster med avfasade kanter som beskådar natthimlen.
  
  Du ser märkliga ting på natthimlen du inte är van vid från en ordinarie stjärnbild. Tre gånger större än månen ser du en planet med ringar som saturnus. Du iakttar en svag oscillerande rörelse i det stoftliknande material som ringarna består av. Stjärnhimlen har dessutom ett svagt rött stoft som tycks skifta i nyans. 
  
   "
;



Test 'spel' ['rör den', 'framåt', 'upp', 'framåt', 'höger'];

/*
En sval vind drar genom hans hår, han upplever rummet genom sin hörsel. Det är en sal, högt i tak med tanke på det eko han hör av vinden. Han tar ett försiktigt steg och hör ljudet fortplanta sig. Golvet känns stenbelagt. Han känner sig om och finner ett altarliknande objekt i midjehöjd. Hans fringrar följer de sirliga mönstren men han känner inte igen stilen, trots alla sin år som arkitekt. 

Han fortsätter sin upptäcksfärd i mörker längs altaret. På sidan närmast honom hittar en basrelif av vad som känns som ormskepnader. Han skälvde till av obehag. ”Ondska”, muttrade han. 

Vid dett yttrande hörde han något i andra änden av rummet. Som om något hasade till. Han vände sig hastigt om. Mörkret dolde nästan almt. Men han kunde nu ana konturerna av en stor trappa i mitten och valvbågar på båda sidor, i den högra, där ljudet hördes anade han en alkov.

Han tog så slutligen mod till sig och började försiktigt hasa mot trappan. Ett steg i taget. För varje steg stannade han till, lyssnade, insåg mer och mer att det bara var sitt eko han hörde. Det var något besynnerligt med platsen och hur den påverkade ljud. Inte som ekon han var van vid. Här var ljudet mer… flerdimensionellt. 

En lång stund senare hade han tagit sig fram till trappan. Ljuset kom definitivt uppifrån. Men där var fortfarande mörkt. Trappstenarna kändes mjuka som en romersk staty.  Han klev upp några steg i taget. En kortvarig yrsel kom över honom när han steg i altitud.

Han nådde trappans topp yrseln var nu särskilt skarp. Han kände hur hans mage vände ut och in på sig och hur han var nödgad att ställa sig på knä för att kräkas. Ekot var mindre här uppe men fortplantade sig tydligt i salen nedanför. Han satt där en bra stund och djupandades till yrseln sakta avtag. En överlevnadsinstinkt fick honom på benen igen och han pressade sig vidare att gå igenom den svagt upplysta korridoren.

Ljuset tilltog mer och vid slutet av korridoren kom en t-korsning. Till höger var det än ljusare. Han gick dit och möttes kort efter av ytterligare en trapp. Denna gång tog han stegen med mer respekt men illamåendet var inte lika påtagligt nu och han tog sig upp för trappen fortare än tidigare. Vid trappans topp såg han ut över en mindre sal med ett högt valvbågat tak. Längs sidorna fanns rymliga fönster som beskådade natthimlen. Han såg märkliga ting. Inte den stjärnbild han var van vid. Tre gånger större än månen brukade avteckna sig såg han istället en planet med ringar som saturnus. 


*/