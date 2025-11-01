#charset "utf-8"
#include <adv3.h>
#include <sv_se.h> 

#ifdef __DEBUG

  #include "tests2/tests2.h"

  modify sessionInfo
      /* do we still need to show the startup options? */
      showStartupOptions = nil
  ;

  Test 'del1' [
    'x Xojo','x Guanmgon','säg ja','x SCU','x CT-22','ta HV-chip','x testare','läs etiketter','öppna testare','ta LV-chip','sätt in det i uttaget','sätt in CT i facket','slå på SCU','v','v', 'x helikoptrar', 'fråga Xojo om Mitachron','lukta på Koffee','drick det','v','x mig','berätta för Xojo om anställningsstopp','x kontrakt','x meritförteckning','fråga Xojo om Kowtuan','fråga Xojo om ChipTechNo','fråga Xojo om Magnxi','fråga Xojo om hissen','fråga Xojo om trappor', 'x klocka','fråga Xojo om kraftverk','fråga Xojo om Guanmgon','öppna dörr','fråga Xojo om hissen','g','x tak','x panel','öppna panel','klättra på Xojo','öppna panel','u','x kabel','dra i den','x utsprång','öppna dörr','x mekanism','sätt meritförteckning i mekanism','x panel','ta den','sätt den i mekanism','öppna dörr','ö','fråga Xojo om hissen','ö','ö','n','n','n','x bro','x huvudbro','x kanjon','fråga Xojo om bron','g','g','g','n','n','fråga Xojo om bron','n','n','fråga Xojo om bron','u','fråga Xojo om bron','nö','in','x Magnxi','x hatt','x uniform','prata med Magnxi','g','g','x publik','x Belker','x band','x mat','x servitör','x utskrift'
  ];

  Test 'del2' [
    'n','ö','s','x kvinna','x ställ','x mortera','x toxicola','x locktheon','x Belker','ja','ja','läs anteckning','acceptera','n','v','s','v','s','s','ö','n','n','x skylt','x Aaron','x Erin','x låda','x kontakt','x bord','titta under bord','x kablar','i','x axelväska','x plånbok','öppna den','x kreditkort','x alumnkort','x körkort','lägg plånbok i ficka','s','s','v','n','x arbetare','x utrustning','v','v','v','s','x monter','x anteckningsbok','x motor','ner','n','x miniräknare','ta den','x mapp','ta den','läs den','x bänk','x experiment','tryck på grön knapp','x plattform','x hyllor','ta generator','x den','x vred','x kontakt','ta oscilloskop','x prob','x boll','ta kamera','x kabel','dra i den','x etikett'
  ];

  Test 'del3' [
    's','v','ner','n','x ledningar','x blå kabel','s','ö','x möbler','x lådor','x trä','flytta trä','n','v','x hål','x kabel','v','x kabel','s','x kabel','v','x kabel','x dörr','göm mig i nisch','skriv 57212 på dörr','v','x blå kabel','ö','ö','n','ö','ö','ö','ö','n','ö','presentera mig','nej','fråga Plisnik om råttor','f honom','x pärm','f pärm','f nic','f analysator','u'
  ];

  Test 'del4' [
    'nv','x ställ','ta tidning','x djur','ta råtta','x expedit','köp tidning','ta den','läs den','lägg råtta på disk','ja','öppna plånbok','ge kreditkort till expedit','lägg kreditkort i plånbok','x kvitto','lägg plånbok i ficka','lägg råtta, kvitto och tidning i väska','sö','v','n','ö','x bil','x fjärrkontroll','lägg bil och fjärrkontroll i väska','v','s','ö','n','nö','läs memo','läs rosa kort','läs gult kort','läs blått kort','läs grönt kort','lägg allt från disk i väska','sv','s','s','ö','n','n'

  ];

  Test 'del5' [ 
    'x dator','koppla generator till låda','slå på generator', 'ta oscilloskop','slå på oscilloskop','proba låd-kontakt med oscilloskop','ta generator och oscilloskop','s','s','ö','x berg','klättra på berg','x behållare','s','x Positron','x instruktionskort','x servicelucka','öppna den','n','u','n','läs klotter','n','x skylt','x dator','fråga Erin om stack','fråga Erin om EE','fråga Erin om qubits','fråga Erin om Jay','knacka på 39','slå upp bibliotek på karta','s','s','ner','v','v','slå upp bibliotek på karta',
    
    'n','v','v','v','v','x receptionist','x lärobok','f lärobok','g','g','öppna plånbok','visa alumnkort för honom','lägg plånbok i ficka','läs katalog','x hiss','tryck på upp','n','tryck på 3','z','z','s','slå upp morgen','läs den','slå upp townsend','läs den','tryck på upp','n','tryck på 6','z','z','s','slå upp blomner','läs den','slå upp 70:11c','läs den','tryck på ner','n','tryck på 2','z','z','s','slå upp XLVI-3','läs den','läs rapport','tryck på upp','n','tryck på 6','z','z','s','slå upp 73:9a','läs den','tryck på ner','n','tryck på 1','z','z','s','ö'
  ];

  Test 'del6' [
    's','ner','v','ner','ö','n','ö','ö','n','ta bil','sätt råtta på bil','släpp bil','x bil','ta fjärrkontroll','x den','x joystick','tryck joystick öster','ö','ja', 'be arbetare om analysator', 'fråga om Netbisco 9099', 'ta bil', 'ta pärm','läs den','slå upp 3349-2016 i pärm','slå upp 3312-8622 i pärm','ta smutsigt papper','läs det','v','s','v','v','v','v','s','v','v','x låda', 'koppla in analysator i uttag',
    'mata in 09C0A848D6 i analysator','ö','ö','n','n','n','ö','ö','x säkringsskåp','x DEI','ö','s','ö','u','s','ö','ö'
  ];

  Test 'del7' [
    'sv','ö','x kycklingar','x anteckningsbok','läs den','x kartong','gå in i den','läs skylt','lägg allt utom dräkt i väska','släpp väska','ta på dräkt','dra i spak','ut','fråga kycklingar om Scott','fråga Scott om Positron','fråga vad som är fel','erbjud att reparera den','ja','förklara om Stamers stack','betala för reparationer','in','dra i spak','ta av dräkt','häng dräkt på krok','ta väska','ut','v','n','s','lås upp dörr','öppna den','ta säck','x den','undersök den','x kretskort','proba kort med oscilloskop','slå på spel','proba kort med oscilloskop','slå upp videoförstärkare i manual','proba videoförstärkare med oscilloskop','slå upp 1a80 i manual','proba 1a80 med oscilloskop','lägg trasig kristall i väska','sök säck','sätt ny kristall i sockel','slå på spel','ta oscilloskop och gul lapp','stäng av spel','stäng dörr','lås den','n','v','n','n'
  ];

  Test 'del8' [
    'koppla generator till låda','slå på generator','proba låd-kontakt med oscilloskop','x rök','n','berätta för Erin om explosion','fråga Erin om lunch','ö','ö','n','x mat','ät mat','berätta för Erin om Omegatron','f jobb','f jobberbjudanden','f byråkrati','f start-up','f stack','x klocka','s','v','v','n','n','x dator','proba låd-kontakt med oscilloskop','ta generator och oscilloskop','s','s','v','n','v','v','v','v','tryck på upp','n','tryck på 6','z','z','s','slå upp DRD','läs den','slå upp hovarth i DRD','tryck på ner','n','tryck på 1','z','z','s','ö','ö','ö','ö','n','n','n','v','x man','x skrivbord','x pärmar','fråga man om router','fråga man om NIC','fråga man om 192.168.11.38','f kamera','f jobbnummer','slå upp 1082-9686 i pärm','ö','s','s','s','s','v','x sync lab','x dörr','öppna dörr','ö','ö','ö'
  ];

  Test 'del9' [
    'sv','u','x papper','x ritning','x kuvert','fråga studenter om Jay',
    'fråga Jay om programmering','f hovarth','f programmera hovarth-tal','f 73:9a','ge den till Jay','v','läs skylt','ö','ge miniräknare till Jay','fråga Jay om Guggenheim','ner','n','v','v','n','v','sv','sö','x Guggenheim','x vindtunnel','x fönster på Guggenheim','x Firestone','x galler','klättra på galler','x bro','s','x dörr','x man','fråga man om Guggenheim','fråga man om Ernst','fråga man om Gunther','visa blått kort för Ernst','n','ö','n','v','fråga trädgårdsmästare om Gunther','visa gult kort för Gunther','ö','s','s','visa rosa kort för Ernst','n','ö','visa grönt kort för Gunther','v','x plockare','gå in i korg','ö','höj korg','titta i kanon','ta kugghjul','x kugghjul','v','v'
  ];

  Test 'del10' [
    'höj korg','klättra på galler','u','v','x tunnel','x panel','öppna panel','s','x tunnel','öppna tunnel','ta ekorre','x den','n','ö','sö','x plåtanordning','öppna dörr','ner','n','ö','x bro','x panel','tryck på grön knapp','tryck på röd knapp','v','s','s','nö','x låda','titta under låda','n','sv','putta låda öster','putta låda norr','s','sv','n','n','ö','ö','ö','ö','x dörr','skriv 16974 på dörr','n','x dator','läs dator','x skärmar','x lab','x skrivbord','x pärmar','s','v','v','v','v','s','s','upp','upp','ner','ner','ner','upp','n','ö','ö','ö','ö','s','ö','ö','ö','ö'
  ];

  Test 'del11' [
    'sv','u','ge ekorre till Jay','ge miniräknare till Jay','ner','n','v','v','n','v','v','v','s','ner','n','ta kupol', 'x stamers forskningsrapport', 'skriv 17281392 på miniräknare','lägg miniräknare på platta','tryck på grön knapp','skriv +++ på miniräknare','ta miniräknare','s','u','n','ö','ö','ö','s','ö','n','n'
  ];

  Test 'del12' [
    'koppla generator till låda','ställ in amplitud till 3','ställ in den till 5','g','ställ in den till 0','ställ in den till 6','ställ in den till 3','ställ in den till 9','ställ in den till 2','v','titta under säng','x snacks','fråga Erin om stack','ät snacks','x bokhyllor','ja','berätta för Brian om stack','ja','berätta för Brian om kamera','berätta för Brian om Omegatron','x keps','ta på keps','ja','säg till belker att du slutar', 'efterord','roligt','omnämnanden','fullständig poäng'
  ];

  Test 'allt' [
    't del1','t del2','t del3','t del4','t del5','t del6',
    't del7','t del8','t del9','t del10','t del11','t del12'
    // 'avsluta'
  ];



  // 
  Test 'del1-7alt' [
    // Del 1
    'granska Xojo', 'undersök Guanmgon', 'bekräfta', 'inspektera SCU', 'studera CT-22', 'plocka upp HV-chip', 'analysera testare', 'tyd etiketter', 'frigör testare', 'hämta LV-chip', 'placera det i uttaget', 'infoga CT i facket', 'aktivera SCU', 'förflytta västerut', 'gå väster', 'utfråga Xojo om Mitachron', 'dofta på Koffee', 'förtär det', 'gå väster', 'betrakta mig själv', 'informera Xojo om anställningsstoppet', 'granska kontraktet', 'studera meritförteckningen', 'fråga ut Xojo om Kowtuan', 'utforska ChipTechNo med Xojo', 'diskutera Magnxi med Xojo', 'be Xojo berätta om hissen', 'observera klockan', 'konsultera Xojo angående kraftverket', 'be Xojo förklara Guanmgon', 'öppna dörren', 'prata om hissen','fråga Xojo om hissen', 'v', 'titta uppåt mot taket', 'inspektera panelen','z', 'z','z','z','z', 'z','z','z','z', 'använd Xojo som stege', 'forcera panelen',  'klättra uppåt', 'undersök kabeln', 'ryck i den', 'granska utsprånget', 'forcera dörren', 'studera mekanismen', 'applicera meritförteckningen på mekanismen', 'ta en närmare titt på panelen', 'införskaffa den', 'applicera den på mekanismen', 'bänd upp dörren', 'öppna dörren', 'dra kabel', 'ta panel', 'stoppa panelen i låsmekanismen', 'öppna dörren', 'gå österut', 'prata om hissen', 'fortsätt österut', 'gå öster igen', 'förflytta norrut', 'gå norr igen', 'fortsätt norrut', 'granska bron', 'studera huvudbron', 'undersök ravinen', 'fråga Xojo om brokonstruktionen', 'upprepa', 'fortsätt fråga', 'insistera', 'gå norrut', 'fortsätt norrut', 'be Xojo elaborera om bron', 'fortsätt norrut', 'gå norr igen', 'utforska bron', 'klättra uppåt', 'be om Xojos åsikt om bron', 'bege dig nordöst', 'stig in', 'granska Magnxi', 'studera hatten', 'undersök uniformen', 'inled konversation med Magnxi','fortsätt','g', 'granska publiken','titta på belker','se bandet','x maten','x kyparna','studera utskriften',

    // Del 2
    'gå norrut', 'förflytta dig österut', 'bege dig söderut', 'granska kvinnan', 'undersök stället', 'studera morterabroschyren', 'analysera toxicolabroschyr', 'inspektera locktheonbroschyren', 'observera Belker', 'bekräfta', 'instäm', 'studera anteckningen', 'godta erbjudandet', 'gå norrut', 'bege dig västerut', 'förflytta dig söderut', 'gå väster', 'fortsätt söderut', 'gå söder igen', 'bege dig österut', 'förflytta dig norrut', 'gå norr igen', 'läs skylten', 'granska Aaron', 'studera Erin', 'undersök lådan', 'inspektera kontakten', 'analysera bordet', 'sök under bordet', 'granska kablarna', 'inventera', 'undersök axelväskan', 'granska plånboken', 'öppna plånboken', 'studera kreditkortet', 'inspektera alumnkortet', 'analysera körkortet', 'förvara plånboken i fickan', 'gå söderut', 'fortsätt söderut', 'bege dig västerut', 'förflytta dig norrut', 'observera arbetaren', 'granska utrustningen', 'gå västerut', 'fortsätt västerut', 'gå väster igen', 'bege dig söderut', 'undersök montern', 'studera anteckningsboken', 'granska motorn', 'gå nedåt', 'förflytta dig norrut', 'inspektera miniräknaren', 'ta upp den', 'granska mappen', 'plocka upp den', 'läs igenom den', 'undersök bänken', 'studera experimentet', 'tryck på den gröna knappen', 'granska plattformen', 'undersök hyllorna', 'hämta generatorn', 'inspektera den', 'studera vredet', 'granska kontakten', 'ta med oscilloskopet', 'undersök proben', 'granska bollen', 'plocka upp kameran', 'studera kabeln', 'dra i den', 'läs etiketten',

    // Del 3
    'gå söderut', 'bege dig västerut', 'gå nedåt', 'förflytta mig norrut', 'undersök ledningarna', 'granska den blå kabeln', 'gå söderut', 'bege dig österut', 'inspektera möblerna', 'undersök lådorna', 'granska träet', 'förflytta träet', 'gå norrut', 'bege dig västerut', 'undersök hålet', 'granska kabeln', 'gå västerut', 'studera kabeln', 'förflytta mig söderut', 'inspektera kabeln', 'gå västerut', 'analysera kabeln', 'granska dörren', 'dölj mig i nischen', 'mata in 57212 på dörren', 'gå västerut', 'undersök den blå kabeln', 'bege dig österut', 'fortsätt österut', 'förflytta mig norrut', 'gå österut', 'fortsätt österut', 'gå öster igen', 'bege dig österut', 'förflytta mig norrut', 'gå österut', 'presentera mig', 'neka', 'fråga ut Plisnik om råttorna', 'utforska honom', 'granska pärmen', 'undersök pärmen', 'fråga om NIC', 'utforska analysatorn', 'gå uppåt',

    // Del 4
    'bege dig nordväst', 'granska stället', 'plocka upp tidningen', 'undersök djuret', 'fånga råttan', 'studera expediten', 'inhandla tidningen', 'ta den', 'läs innehållet', 'placera råttan på disken', 'bekräfta', 'öppna plånboken', 'överlämna kreditkortet till expediten', 'förvara kreditkortet i plånboken', 'granska kvittot', 'stoppa plånboken i fickan', 'packa ner råttan, kvittot och tidningen i väskan', 'gå sydöst', 'bege dig västerut', 'förflytta mig norrut', 'gå österut', 'undersök bilen', 'granska fjärrkontrollen', 'stoppa bilen och fjärrkontrollen i väskan', 'gå västerut', 'bege dig söderut', 'förflytta mig österut', 'gå norrut', 'bege dig nordöst', 'studera memot', 'läs det rosa kortet', 'granska det gula kortet', 'undersök det blå kortet', 'studera det gröna kortet', 'packa ner allt från disken i väskan', 'gå sydväst', 'bege dig söderut', 'fortsätt söderut', 'förflytta mig österut', 'gå norrut', 'fortsätt norrut',

    // Del 5
    'undersök datorn', 'anslut generatorn till lådan','starta generatorn', 'hämta oscilloskopet', 'aktivera oscilloskopet', 'mät låd-kontakten med oscilloskopet', 'ta med generatorn och oscilloskopet', 'gå söderut', 'fortsätt söderut', 'bege dig österut', 'granska berget', 'bestiga berget', 'undersök behållaren', 'gå söderut', 'granska Positron', 'studera instruktionskortet', 'undersök serviceluckan', 'öppna den', 'gå norrut', 'klättra uppåt', 'förflytta dig norrut', 'studera klottret', 'gå norrut', 'läs skylten', 'granska datorn', 'fråga ut Erin om stapeln', 'diskutera ET med Erin', 'utforska qubits med Erin', 'fråga Erin om Jay', 'knacka på dörr 39', 'slå upp biblioteket på kartan', 'gå söderut', 'fortsätt söderut', 'gå nedåt', 'bege dig västerut', 'fortsätt västerut', 'slå upp biblioteket på kartan', 'förflytta dig norrut', 'gå västerut', 'fortsätt västerut', 'gå väster igen', 'bege dig västerut', 'granska receptionisten', 'undersök läroboken', 'fråga om läroboken', 'upprepa', 'insistera', 'öppna plånboken', 'visa upp alumnkortet för honom', 'förvara plånboken i fickan', 'studera katalogen', 'granska hissen', 'tryck på upp', 'gå norrut', 'tryck på 3', 'vänta', 'vänta', 'gå söderut', 'slå upp Morgen', 'läs informationen', 'slå upp Townsend', 'studera texten', 'tryck på upp', 'gå norrut', 'tryck på 6', 'vänta', 'vänta', 'gå söderut', 'slå upp Blomner', 'läs om det', 'slå upp 70:11c', 'studera den', 'tryck på ner', 'gå norrut', 'tryck på 2', 'vänta', 'vänta', 'gå söderut', 'slå upp XLVI-3', 'läs rapporten', 'granska rapporten', 'tryck på upp', 'gå norrut', 'tryck på 6', 'vänta', 'vänta', 'gå söderut', 'slå upp 73:9a', 'studera texten', 'tryck på ner', 'gå norrut', 'tryck på 1', 'vänta', 'vänta', 'gå söderut', 'bege dig österut',


    // Del 6
    'gå söderut', 'förflytta dig nedåt', 'bege dig västerut', 'gå nedåt', 'förflytta dig österut', 'gå norrut', 'bege dig österut', 'fortsätt österut', 'gå norrut', 'plocka upp bilen', 'placera råttan på bilen', 'släpp bilen', 'undersök bilen', 'ta fjärrkontrollen', 'granska den', 'studera joysticken', 'styr joysticken österut', 'gå österut', 'bekräfta', 'be arbetaren om analysatorn', 'hämta bilen', 'ta pärmen', 'studera den', 'slå upp 3349-2016 i pärmen', 'sök efter 3312-8622 i pärmen', 'plocka upp det smutsiga papperet', 'läs innehållet', 'gå västerut', 'bege dig söderut', 'fortsätt västerut', 'gå väster igen', 'fortsätt västerut', 'gå väster', 'förflytta dig söderut', 'bege dig västerut', 'gå väster igen', 'granska lådan', 'koppla in analysatorn i uttaget', 'mata in 09C0A848D6 på analysatorn', 'gå österut', 'fortsätt österut', 'förflytta dig norrut', 'gå norr igen', 'fortsätt norrut', 'bege dig österut', 'gå öster igen', 'undersök säkringsskåpet', 'granska DEI', 'gå österut', 'bege dig söderut', 'förflytta dig österut', 'klättra uppåt', 'gå söderut', 'bege dig österut', 'fortsätt österut',

    // Del 7
    'gå sydväst', 'bege dig österut', 'granska kycklingarna', 'undersök anteckningsboken', 'studera den', 'inspektera kartongen', 'gå in i den', 'läs skylten', 'lägg allt utom dräkten i väskan', 'släpp väskan', 'klä på dig dräkten', 'dra i spaken', 'kliv ut', 'fråga ut kycklingarna om Scott', 'utforska Positron med Scott', 'undersök vad som är fel', 'erbjud dig att reparera den', 'bekräfta', 'förklara Stamers stack', 'betala för reparationerna', 'gå in', 'dra i spaken', 'ta av dig dräkten', 'häng upp dräkten på kroken', 'hämta väskan', 'gå ut', 'bege dig västerut', 'förflytta mig norrut', 'gå söderut', 'lås upp dörren', 'öppna den', 'ta säcken', 'granska den', 'undersök den', 'studera kortet', 'mät kortet med oscilloskop', 'starta spelet', 'mät kortet med oscilloskopet', 'slå upp videoförstärkare i manual', 'mät videoförstärkaren med oscilloskopet', 'slå upp 1a80 i manualen', 'mät 1a80 med oscilloskopet'
  
  ];

#endif

