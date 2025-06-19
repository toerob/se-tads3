#charset "utf-8"
/* 
 *   Copyright 2003, 2013 Michael J. Roberts
 *   
 *   Return to Ditch Day - Hints.  This implements the on-line hints
 *   provided with the game.  
 */

#include <adv3.h>
#include <sv_se.h>


/* ------------------------------------------------------------------------ */
/* 
 *   The main hint menu 
 */
topHintMenu: TopHintMenu
    'Välj det allmänna området för din fråga'
;

/*
 *   Provide help on the hint system itself 
 */
+ HintLongTopicItem 'Översikt över Tipssystemet'
    '''Det är svårt att ge bra tips för IF-spel. Tips kan förstöra
    nöjet om de avslöjar för mycket, men samtidigt är det
    frustrerande att fastna. Vi har försökt hitta en balans här
    genom att ge dig kontroll över hur starkt ett tips du får.
    <.p>
    Tips presenteras i ett fråga-och-svar-format, med
    frågorna grupperade i berättelseområden. För att undvika att avslöja potentiella
    händelseutvecklingar för tidigt, försöker systemet visa dig endast
    de ämnen du redan borde känna till, baserat på var
    du befinner dig i berättelsen.
    <.p>
    Välj det allmänna området där du har fastnat, och du kommer att få
    en lista med frågor. Välj den fråga som ligger närmast det du
    försöker lista ut, och spelet kommer att börja visa dig
    tips för den frågan, ett tips i taget. Det första tipset
    eller två kommer att vara mycket vaga och allmänna och kommer vanligtvis inte att ge
    bort något. Varje ytterligare tips blir mer specifikt, och
    det sista tipset för varje fråga ger vanligtvis den exakta lösningen.
    Du kan sluta efter vilket tips som helst---tryck bara på <b>Q</b> så kommer du att
    återvändas till berättelsen. Försök att sluta vid det första tipset som ger
    dig några nya idéer, för att undvika att avslöja för mycket på en gång; du kan
    alltid komma tillbaka till samma ämne senare och se fler tips om
    du behöver det.
    <.p>
    Var medveten om att de flesta människor njuter mycket mer av IF när de löser alla
    pussel själva, utan några tips. Jag har försökt att
    designa pusslen i det här spelet för att vara rättvisa, så att de flesta spelare
    kan hålla berättelsen i rörelse utan några omöjliga logiska hopp,
    slumpmässiga gissningar eller telepatiska bedrifter (det vill säga att läsa
    författarens tankar). Om du ändå fastnar fruktansvärt, finns tipsen
    här för dig; kom bara ihåg att tips hör hemma högst upp
    på IF:s kostpyramid---<q>använd sparsamt.</q> '''

    /* make sure this is the first item in the menu */
    topicOrder = 1
;

+ HintLongTopicItem 'Några Ord på Vägen'
    '''Det här spelet är utformat för att vara roligt att spela, inte för att frustrera dig.
    Om du har spelat andra textäventyr, särskilt äldre
    <q>klassiska</q> spel, kanske du har fått intrycket att
    IF-författare tar grym glädje i att förvirra spelare och slumpmässigt
    döda huvudkaraktärer. Vissa gör det säkert, men det här är inte
    den typen av spel.
    <.p>
    Det finns två saker jag vill att du ska veta och ha i åtanke
    medan du spelar.
    <.p>
    För det första kan du stöta på en del ingenjörs- och fysikjargong
    under spelets gång. Låt det inte skrämma dig---tänk bara
    på det som <q>teknobabbel,</q> på samma sätt som de alltid pratar om
    att <q>nutrera sköldens harmonier</q> och liknande i <i>Star
    Trek</i>. Du behöver ingen bakgrund i fysik för att spela - faktiskt
    är du förmodligen bättre utan det, eftersom <q>vetenskapen</q>
    i berättelsen mestadels är påhittad ändå. Du kan lita på att din
    karaktär kommer att lista ut saker och fylla i dig.
    <.p>
    För det andra behöver du inte oroa dig för att <q>förlora</q> spelet.
    Det finns inga slumpmässiga dödsfall för huvudkaraktären, och det
    borde inte finnas något sätt att göra spelet omöjligt att vinna. Du behöver inte
    oroa dig för att en till synes oskyldig handling visar sig,
    timmar senare, ha förstört spelet. Så känn dig fri att utforska
    och experimentera---oavsett vad du gör bör spelet alltid
    förbli möjligt att vinna. '''

    /* keep this just after the 'hint system overview' topic */
    topicOrder = 10
;

/* ------------------------------------------------------------------------ */
/*
 *   Miscellanous general topics 
 */
+ HintMenu 'Allmänna Frågor'
    /* keep this just after the 'a few words of advice' topic */
    topicOrder = 20
;

++ Goal 'Vad har detta med Ditch Day att göra?'
    ['''Oroa dig inte; du kommer till den delen snart nog.''']
    goalState = OpenGoal

    /* stop showing this hint as soon as we get the ditch day lecture */
    closeWhenRevealed = 'ditch-day-explained'
;

/* ------------------------------------------------------------------------ */
/*
 *   Hints for the prologue
 */
+ HintMenu 'Statligt Kraftverk #6';

/*
 *   A general hint topic for the main goals right now.  In any adventure
 *   game, one of the big problems some players experience is that they
 *   don't know what they're supposed to be doing in general, or they
 *   misunderstand what they're supposed to be doing.  A high-level goals
 *   topic like this can help avoid that sort of frustrating aimlessness.
 *   
 *   The "->" indicates that this goal is achieved as soon as the "->"
 *   expression is true; in this case, we point to the scoreMarker for the
 *   scu1100dx object, which means that we'll consider this goal achieved
 *   as soon as that achievement is scored.  When the goal is achieved,
 *   it'll be automatically "closed," which means it won't show up in the
 *   hint menus any longer.  Once we've accomplished a goal, there's no
 *   reason to give hints for that goal any longer.  
 */
++ Goal ->(scu1100dx.scoreMarker)
    'Vad ska jag göra?'
    ['''Du är här för att ge kunden en demonstration av SCU-1100DX.''',
     '''Du kan inte demonstrera den förrän du får den att fungera.''',
     'Du måste reparera SCU-1100DX.']

    /* make this goal open from the start of the game */
    goalState = OpenGoal

    /* put this at the top of the hint list */
    topicOrder = 100
;

/* 
 *   explain how to repair the SCU; close this goal as soon as we've
 *   awarded the points for repairing the SCU 
 */
++ Goal ->(scu1100dx.scoreMarker)
    'Hur reparerar jag SCU-1100DX?'
    ['Har du tittat noga på den?',
     'Lade du märke till den tomma platsen?',
     'Vad ska vara i den tomma platsen?',
     'Har du tittat noga på CT-22?',
     '''Det finns en felaktig komponent i CT-22.''',
     hint772lv,
     'När du har satt in XT772-LV i CT-22, sätt bara tillbaka CT-22
     i SCU-1100DX och slå på SCU-1100DX.']

    goalState = OpenGoal
;

/*
 *   A 'Hint' object is a line item with a list of answers for a Goal.  In
 *   most cases, we don't bother with a separate Hint object, but just use
 *   a string.  In this particular case, though, we want to make sure that
 *   we make the XT772-LV hints available as soon as we mention the
 *   XT772-LV in a hint (we otherwise wouldn't have mentioned it until the
 *   player saw the ct-22 description).  Using a separate Hint object lets
 *   us do this via our 'referencedGoals' property, which points to one or
 *   more goals that we need to mark as open as soon as we show this hint.
 */
+++ hint772lv: Hint
    hintText = 'Du behöver ersätta XT772-HV med en XT772-LV.'
    referencedGoals = [goal772lv]
;

/*
 *   A hint topic for finding the xt772-lv.  Don't make this hint
 *   available until the player has discovered that they need the XT772-LV
 *   in the first place - they should be able to realize this as soon as
 *   they've seen the xt772-hv.  
 */
++ goal772lv: Goal ->(scu1100dx.scoreMarker)
    'Var kan jag hitta en XT772-LV?'
    ['Har du tittat noga på allt här?',
     'Har du tittat noga på din egen utrustning?',
     'Har du tittat noga på din kretsprovare?',
     'Läste du varningsetiketterna?',
     'Lade du märke till att kretsprovaren har ett avtagbart bakstycke?',
     '''Du ska vara ingenjör, eller hur? Skulle en ingenjör
       bry sig om en varning om att inte öppna bakstycket?''',
     '''Försök öppna kretsprovarens bakstycke.''']

    closeWhenSeen = xt772lv

    /* open the goal when the CT-22 is examined or the LV is mentioned */
    openWhenTrue = (ct22.described || xt772lv.isMentioned)
;

++ Goal 'Vad gör jag nu?'
    ['Du skulle hitta någon.',
     'Du skulle hitta Överste Magnxi.',
     'Någon skulle ta dig till Översten.',
     '''Håll dig bara till Xojo; han kommer att leda dig till Översten.''']

    openWhenAchieved = (scu1100dx.scoreMarker)
    closeWhenSeen = adminLobby
;

++ Goal 'Jag hittade Överste Magnxi. Vad händer nu?'
    ['Du skulle få kontraktet underskrivet, eller hur?',
    'Försök visa henne kontraktet.',
    'Eller så kan du bara fråga henne om något, eller till och med bara PRATA MED henne.']

    openWhenSeen = adminLobby
    closeWhenAchieved = (magnxi.scoreMarker)
;

++ Goal '''Jag kan inte få Överste Magnxis uppmärksamhet.'''
    ['Du kanske bara måste försöka hårdare.',
    'Eller så kanske du bara måste försöka igen.',
    'Fortsätt försöka prata med henne, så får du så småningom hennes uppmärksamhet.']
    openWhenSeen = adminLobby
    closeWhenAchieved = (magnxi.scoreMarker)
;

++ Goal 'Eh, vad händer nu?'
    ['Läs bara utskriften som Xojo gav dig.']
    openWhenTrue = (!adminEmail.isIn(nil))
    closeWhenTrue = (adminEmail.isIn(nil))
;

++ Goal 'Finns det ett sätt att undvika att fastna i hissen?'
    ['Såg du några trappor?',
    '''Det finns inga trappor; hissen är det enda sättet ner.
    Du kan inte undvika den, och du kan inte hindra den från att fastna,
    så du måste helt enkelt hitta en väg ut när den har fastnat.''']
    
    openWhenTrue = (plantElevator.seen && plantElevator.isAtBottom)
    closeWhenAchieved = (powerElevPanel.scoreMarker)
;

++ Goal 'Hissen har fastnat. Vad gör jag nu?'
    ['Har du tittat runt noggrant?',
     '''Grinden öppnas inte här, men kanske finns det en annan väg ut.''',
     'Ser du något intressant i taket?',
     'Vad sägs om servicepanelen?',
     'Kanske du kan fly genom servicepanelen.',
     'Det enda problemet är att servicepanelen är för högt upp för att nå.',
     '''Kanske finns det något du kan stå på, eller något du
     kan klättra på.''',
     'Försök stå på ledstången, eller klättra på grinden.',
     '''Att stå på ledstången och klättra på grinden fungerar inte,
     men lägg märke till att Xojo erbjuder sig att hjälpa dig upp när du försöker.''',
     'STÅ PÅ LEDSTÅNG. När Xojo frågar om du vill ha hjälp upp, säg JA.',
    'När Xojo har lyft upp dig, öppna bara panelen och gå UPP.']

    openWhenTrue = (plantElevator.seen && plantElevator.isAtBottom)
    closeWhenAchieved = (powerElevPanel.scoreMarker)
;

++ Goal '''Jag är ute ur hissen, men nu sitter jag fast i schaktet.'''
    ['Har du provat dörren?',
     'Okej, så dörren är låst. Ta en närmare titt på den.',
     '''Det finns en låsmekanism på dörren. Undersök den.''',
     '''Låsmekanismen öppnas när hisskorgen för in
     något i springan. Kanske finns det något annat du
     kan föra in för att utlösa låset.''',
     'Du behöver något som är tunt nog att passa i springan men starkt
     nog att utlösa låset.',
     'Något som en bit plåt.',
     'Locket till serviceluckan fungerar. Sätt in det i springan.',
     'Gå nu bara genom dörren.']

    openWhenSeen = atopPlantElevator
    closeWhenAchieved = (doorS2outer.scoreMarker)
;

/* ------------------------------------------------------------------------ */
/*
 *   General hints for the campus 
 */
+ HintMenu 'På Campus';

++ Goal 'Hur hittar jag runt på campus?'
    ['Har du tittat i din tygkasse än?',
     'Lade du märke till campuskartan?',
     'Titta på campuskartan.',
     '''Campuskartan visar placeringen av byggnaderna på campus.
     För att hitta vägen till en byggnad, skriv bara HITTA <i>byggnad</i>
     PÅ KARTA. Observera att du måste vara utomhus för att göra detta, eftersom
     kartan inte inkluderar interiöra planlösningar för några byggnader.
     Kartan hjälper dig inte heller att hitta vägen runt inne i någon
     byggnad; du måste förlita dig på utforskning för det.''']

    openWhenSeen = sanPasqual
;

++ Goal 'Hur stort är campus egentligen?'
    ['''Campus har ganska många platser. Om du inte är säker
    på vad du ska göra härnäst, kanske du vill spendera lite tid
    på att vandra runt och utforska. De flesta byggnaderna är inte
    för stora inuti, men ett par---särskilt Dabney
    House---är stora nog att du kanske vill göra en karta.''']

    openWhenSeen = spWalkway
;

++ Goal 'Vad gör jag på Caltech?'
    ['''Du är här för att intervjua en student för ett jobb på ditt företag.''']

    openWhenSeen = sanPasqual
;

++ Goal 'Finns det något sätt att få tag på Netbisco 9099?'
    ['Har du pratat med arbetarna än?',
     '''Fråga dem något, sedan VÄNTA i några omgångar. Du kommer att överhöra
     några saker de säger till varandra.''',
     'Lägg märke till att de har en medarbetare nere i schaktet.',
     'Lägg märke till att de ibland räcker saker till sin medarbetare.',
     'Tittade du noga på schaktet?',
     'Schaktet sägs ansluta till ångtunnlarna. Kanske du kan
     nå botten av schaktet från Bridge ångtunnlar.',
     'Från ingången till Bridge ångtunnel, gå österut (sväng norrut
     när det behövs) tills du hittar Plisnik.',
     'Kanske om du kan bli av med Plisnik, kan du få arbetarna på
     ytan att räcka dig nätverksanalysatorn.',
     'När du väl har blivit av med Plisnik, behöver du bara be arbetarna
     om Netbisco 9099.']
    
    openWhenTrue = (quadAnalyzer.described)
    closeWhenTrue = (netAnalyzer.moved)
;

++ Goal 'Hur kommer jag förbi disken på Physical Plant-kontoret?'
    ['Tänk på vad som fick dig att vilja komma dit bakom.',
     'När du tänker efter, var det egentligen något som fick dig att tro
     att du hade något att göra där bakom?',
     '''Du behöver verkligen inte komma dit bakom.''']

    openWhenSeen = ppOffice
;

++ Goal 'Hur kommunicerar jag med elektrikern?'
    ['''Han verkar bara tala tyska, vilket din karaktär inte
    talar, så det finns inte mycket du kan prata med honom om.''',
     'Du skulle åtminstone kunna visa honom saker.',
     'Det finns ett par saker som ligger runt som är menade just för honom.',
     'Har du varit inne på Physical Plant-kontoret än?',
     'Tittade du på arbetskorten?',
     'Ett par av arbetskorten är avsedda för en elektriker. Du skulle
     kunna försöka ge honom ett av dessa.']

    openWhenDescribed = ernst
    closeWhenTrue = (ernst.location == nil)
;

++ Goal 'Kan jag få trädgårdsmästaren att låta mig använda skyliftaren?'
    ['Du kan alltid försöka be honom om den.',
     '''Okej, så han låter dig inte frivilligt få den. Har du varit
     inne på Physical Plant-kontoret än?''',
     'Tittade du på arbetskorten?',
     'Ett par av arbetskorten är avsedda för en trädgårdsmästare. Du skulle
     kunna försöka ge honom ett av dessa.',
     'Läste du memon på Physical Plant-kontoret?',
     'Har du stött på någon som heter Ernst än?',
     'Vad säger memon att du aldrig ska låta hända?',
     'Kanske du kan ordna så att det händer.',
     '''Tyvärr var skiftledaren som skapade arbetskorten
     uppmärksam på memon och ordnade inte så att några trädgårdsarbeten
     sammanföll med några elektriska arbeten. Men det finns en annan
     sak som du ska undvika.''',
     'Kanske kan du få Gunther och Ernst att korsa varandras vägar på
     väg till nya jobb.',
     'Det kräver lite omsorg med timing, men du kan få dem båda
     att korsa Quad samtidigt.',
     'Lade du märke till att Ernst alltid tar lite tid på sig att komma igång?',
     'Ernst tar tillräckligt lång tid på sig att komma igång så att du kan skicka iväg honom
     till ett nytt jobb, och sedan omedelbart gå och hitta Gunther och skicka iväg honom.
     Om du tajmar det rätt kommer de två att nå Quad samtidigt.',
     '''Det är viktigt att få timingen rätt.''',
     '''Quad är för långt borta från där Gunther och Ernst börjar,
     så du kan inte få timingen att fungera därifrån.''',
     'Gunther och Ernst har båda två platser du kan skicka dem till.
     Skicka dem först båda till deras andra plats, skicka dem sedan
     tillbaka. Du kan få timingen att fungera på returresan.'
    ]

    openWhenSeen = cherryPicker
    closeWhenTrue = (gunther.location == nil)
;

++ Goal 'Hur kan jag komma till Guggenheims vindtunnel?'
    ['''Den är på taket av byggnaden. Men du verkar inte kunna
    komma in för att ta trapporna.''',
     '''Kanske finns det ett sätt att komma upp dit utan att gå in i
     byggnaden.''',
     'Har du tittat noga på byggnaden?',
     'Har du lagt märke till att Guggenheim är kopplad till en annan byggnad?',
     'Tittade du noga på Firestone?',
     'Det gallerverk på Firestone kanske är värt en närmare titt.',
     'Folk har varit kända för att klättra på det gallerverket.',
     '''Det enda problemet är att du behöver ett sätt att nå gallerverket,
     eftersom det inte börjar förrän en bra bit ovanför marknivå.''',
     'Du behöver något som får dig upp tillräckligt högt för att nå
     gallret.',
     'Något som lyfter människor en liten bit ovanför marken.',
     '''Du borde utforska campusområdet lite mer om
     du inte har sett något som kan hjälpa.''',
     'Titta upp Beckman Auditorium på campuskartan och gå och titta runt.',
     'Kanske den där skyliftaren skulle vara till nytta.']

    openWhenSeen = wowWindTunnel
    closeWhenSeen = guggenheimRoof
;

++ Goal 'Hur kommer jag in i vindtunneln?'
    ['Tittade du noga på strukturen?',
     'Undersökte du den lilla panelen?',
     'Försök öppna panelen.']

    openWhenSeen = guggenheimRoof
    closeWhenSeen = windTunnel
;

++ Goal 'Hur kommer jag in på Campus Network Office?'
    ['Läste du skylten?',
     'Den säger att kontoret öppnar igen klockan 13:00. Kanske du
     borde ta det bokstavligt.',
     'Du har gott om andra saker att göra tills dess; försök arbeta
     med din stack ett tag.',
     '''Lunch är vanligtvis vid middagstid. När du är klar med lunchen
     borde det vara runt klockan ett; kom tillbaka då.''']

    openWhenSeen = jorgensenHall
    closeWhenSeen = networkOffice
;

++ Goal '''Vad är grejen med Mr.\ Happy Gear?'''
    ['''Det är bara en liten intern referens för folk som kommer ihåg
    den ursprungliga <i>Ditch Day Drifter</i>.''',
     'Mr.\ Happy Gear var ett av de slumpmässiga föremålen du behövde hitta
     för att lösa Ditch Day-stacken i den ursprungliga <i>DDD</i>.',
     '''Förutom det är den helt oviktig.''']

    openWhenDescribed = mrHappyGear
;

++ Goal '''Vad är det med alla <q>Hovse</q>-felstavningar?'''
    ['Tittade du på den dekorativa stenarbetet utanför Dabney på
    Orange Walk?',
     '''Det är bara ett litet skämt om student-hovsen.''',
     '''Hovsen har stenarbete med inskriptioner designade
     för att se ut som inskriptionerna på klassiska romerska byggnader. Det
     romerska alfabetet i klassiska tider hade inget U; V hade ungefär
     det fonetiska värdet av det moderna U. Så hovse-byggarna ersatte
     U med V i alla inskriptioner, därav HOVSE istället för HOUSE.''',
     '''Det har alltid verkat som en löjlig tillgjordhet för mig; jag menar,
     varför oroa sig över en bokstav när hela ordet är historiskt
     felaktigt? Om de verkligen hade velat vara historiskt
     korrekta, kunde de ha skrivit något som DOMVS DABNEIIS.''']
    
    openWhenSeen = orangeWalk
;

/* ------------------------------------------------------------------------ */
/*
 *   Hints for the Sync Lab 
 */
+ HintMenu 'Sync-labbet';

++ Goal 'Hur kommer jag in i Sync-labbet?'
    ['''Det verkar inte finnas något sätt att låsa upp dörren på
    parkeringsplatsen.''',
     'Kanske du behöver en indirekt approach.',
     '''Oroa dig inte för mycket om detta just nu; något kanske
     faller dig in efter att du har utforskat mer.''']

    openWhenSeen = syncLot
    closeWhenSeen = firestoneRoof
;

++ Goal 'Hur kommer jag in i Sync-labbet?'
    ['Du borde utforska mer i det allmänna området.',
     'Vad annat verkar vara i närheten?',
     'Firestone är i närheten, men det blockerar vägen in.',
     'Kanske du kan komma förbi Firestone på något sätt.',
     'Tänk tredimensionellt.',
     'Försök utforska några tak mer noggrant.',
     'Specifikt taket på Firestone.',
     'Kolla vart den stegen leder.']

    openWhenSeen = firestoneRoof
    closeWhenSeen = syncLabRoof
;

++ Goal 'Hur kommer jag in i Sync-labbet?'
    ['''Du har tekniskt sett redan varit i Sync-labbet.''',
     '''Du har bara inte varit inuti än.''',
     '''Du har varit på taket av byggnaden. Kanske det finns en
     väg in därifrån.''',
     'Titta på den rektangulära anordningen.',
     'Öppna dörren och gå in.']

    openWhenSeen = syncLabRoof
    closeWhenSeen = syncCatwalkSouthWest
;

++ Goal 'Hur korsar jag gapet i gångbron?'
    ['''Det ser ut som om det finns en vindbrygga, men tyvärr verkar
    den vara ur funktion.''',
     '''Kanske det finns något annat du kan använda för att överbrygga gapet.''',
     'Utforska labbet lite.',
     'Lade du märke till något som stack ut bland alla lådor och
     boxar?',
     'Kanske en ovanlig låda?',
     'Titta på metallådan i det öppna området.',
     'Lade du märke till något ovanligt med den, förutom dess storlek?',
     '''Den är upphöjd från golvet något; kanske du borde titta
     under den för att ta reda på varför.''',
     '''Den är på hjul, så kanske du kan flytta den.''',
     '''Du kan inte flytta den från det öppna området, men kanske du kan komma
     runt bakom den och lossa den.''',
     'Gå norrut och sydväst från det öppna området. Där är den igen.',
     'Försök att putta den.',
     'Nu när du har fått den lös, kanske du kan använda den på något sätt.',
     'Den ser ganska stor ut---kanske till och med stor nog att överbrygga det gapet.',
     'Försök putta den norrut från det öppna området.']

    openWhenSeen = syncCatwalkGapWest
    closeWhenTrue = (metalCrate.isIn(syncLab3))
;

++ Goal 'Hur kommer jag in på kontoret?'
    ['Det ser ut som om du behöver en kombination för att öppna dörren.',
     '''Oroa dig inte för mycket om det just nu; om du upptäcker
     att du behöver komma in där, kommer du också att lära dig mer
     om hur du gör det.''']
    
    openWhenSeen = syncCatwalkEast
    closeWhenSeen = syncLabOffice
;
/* ------------------------------------------------------------------------ */
/*
 *   Hints for the initial campus section: finding our way to the career
 *   center office 
 */
+ HintMenu 'Intervjun';

++ Goal 'Var är jag nu?'
    ['''Du är inte i närheten av kraftverket.''',
     '''Du är på Caltech-campus i Pasadena, Kalifornien. Tre veckor
     har gått sedan den föregående scenen. Du är här för att intervjua en
     kandidat för ett jobb på ditt företag.''']

    openWhenSeen = sanPasqual
    closeWhenSeen = ccOffice
;

++ Goal '''Hur hittar jag personen jag ska intervjua?'''
    ['''Du ska gå till Career Center-kontoret först.
    De kommer att sätta dig i kontakt med kandidaten.''']

    openWhenSeen = sanPasqual
    closeWhenSeen = ccOffice
;

++ Goal 'Hur hittar jag Career Center-kontoret?'
    ['Career Center-kontoret ligger i Student Services-byggnaden på
    Holliston Avenue.',
     '''Du kan inte gå vilse just nu; gå bara norrut från
     San Pasqual, österut från Holliston, och söderut från lobbyn.''']

    openWhenSeen = sanPasqual
    closeWhenSeen = ccOffice
;

++ Goal '''Hur får jag kvinnans uppmärksamhet?'''
    ['Det skulle vara oartigt att avbryta hennes telefonsamtal.',
     '''Oroa dig inte för det; häng bara runt ett tag så kommer hon så småningom
     att avsluta sitt samtal och prata med dig.''',
     '''Varför inte läsa några av broschyrerna (på litteraturstället)
     medan du väntar?''']

    openWhenSeen = ccOffice
    closeWhenTrue = (ccDinsdale.introduced)
;

++ Goal 'Vad gör jag nu?'
    ['Prata bara med fröken Dinsdale en stund.']
    openWhenRevealed = 'ditch-day-explained'
    closeWhenRevealed = 'stack-accepted'
;
/* ------------------------------------------------------------------------ */
/*
 *   Hints for the stack 
 */
+ HintMenu 'Ditch Day';

++ Goal '''Vad handlar den här Ditch Day-grejen om igen?'''
    ['''Det är en årlig händelse där alla sistaårsstudenter skolkar från sina
    lektioner för dagen och åker till stranden, och lämnar <q>stacks</q>
    utanför sina rum för att hålla yngre studenter ute.''']

    openWhenRevealed = 'stack-accepted'
    topicOrder = 100
;

++ Goal 'Vad borde jag göra?'
    ['Du försöker lösa Stamers stack, så att du kan anställa
    honom till Omegatron.']

    openWhenRevealed = 'stack-accepted'
    topicOrder = 110
;

++ Goal 'Var är denna så kallade <q>stack</q> som jag ska hitta?'
    ['Fröken Dinsdale nämnde var Stamer bor. Det är dit
    du ska gå.',
     'Du ska gå till Dabney House, rum 4.',
     'Om du inte är säker på var Dabney House ligger, har du tittat i
    din tygkasse?',
     'Du har en karta över campus, så använd bara HITTA DABNEY HOUSE PÅ KARTAN.
    (Du måste vara utomhus innan detta fungerar dock, eftersom
    kartan inte visar några inomhusplanlösningar.)']

    openWhenRevealed = 'stack-accepted'
    closeWhenSeen = alley1N
;

++ Goal 'Hur får jag nyckeln från Erin?'
    ['Har du frågat henne om den?',
     'Hon kommer inte att ge den till dig så länge hon arbetar med stacken,
    men oroa dig inte: hon kommer inte att arbeta med stacken länge.
    Stanna bara nära henne i ett par rundor.']

    openWhenRevealed = 'erin-has-key'
    closeWhenTrue = (!labKey.isIn(erin))
;

++ Goal 'Vad ska jag göra med <q>svarta lådan</q>?'
    ['Tittade du på den?',
     'När du undersökte den svarta lådan gav berättelsen dig några idéer
    om testutrustning som du kommer att behöva.',
     'Du behöver ett oscilloskop och en signalgenerator.',
     'Läste du skylten på Brian Stamers dörr?',
     'Brian lämnade utrustningen du behöver i sitt labb.']

    openWhenSeen = alley1N
    closeWhenTrue = (blackBox.equipGathered)
;

++ Goal 'Hur listar jag ut vad <q>svarta lådan</q> gör?'
    ['Du samlade ihop testutrustningen, eller hur?',
     'Kanske du borde använda testutrustningen.',
     'Du kan börja med att koppla in oscilloskopet i den svarta lådan.',
     'Det skulle också hjälpa att slå på oscilloskopet.',
     'Föreslår det något annat du kan prova?',
     'Försök koppla in signalgeneratorn i den svarta lådan medan
    oscilloskopet fortfarande är anslutet.',
     'Slå på signalgeneratorn, såklart. <b>Sedan</b> kopplar
    du in oscilloskopet.',
     'Okej, så det löste inte exakt stacken, men åtminstone ger det
    dig en idé om vad du ska göra härnäst.',
     'Du behöver göra lite bakgrundsläsning och få lite övning
    i att arbeta med kretsar.',
     'När du har gjort allt det, försök bara sonda med signalgeneratorn
    och oscilloskopet igen.']
    
    openWhenTrue = (blackBox.equipGathered)
    closeWhenTrue = (blackBox.timesRead != 0)
;

++ Goal 'Var skulle jag hitta en <q>bra EE-lärobok</q>?'
    ['Vad är en bra plats att hitta böcker i allmänhet?',
     'Kanske en stor byggnad ägnad åt att hysa massor av böcker...',
     'Biblioteket, till exempel.',
     'Om du inte har varit på biblioteket än, gå ut och
    hitta biblioteket på din karta.',
     'Du kanske behöver någon som rekommenderar en bok (se de separata
    ledtrådarna om det.)']
    
    openWhenRevealed = 'need-ee-text'
    closeWhenSeen = morgenBook
;

++ Goal 'Var kan jag få en rekommendation för en bra EE-lärobok?'
    ['Kanske finns det någon på campus som kan hjälpa.',
     'Kanske en student.',
     'Har du träffat några elektroteknikstudenter?',
     'Erin och Aaron nämnde att de var EE-studenter. Gå och fråga dem.',
     'Om du inte är säker på var de är, vandra bara runt i Dabney
    lite.',
     'De arbetar med en stack i Alley 7.',
     'Från innergården, gå upp för trapporna, sedan norrut, och norrut igen.']

    openWhenRevealed = 'need-ee-text'
    closeWhenSeen = morgenBook
;

++ Goal 'Var kan jag få lite övning i att felsöka kretsar?'
    ['Utforska Dabney lite; kanske du stöter på något.',
     'Kolla platserna nära innergården.',
     'Du letar efter någon typ av elektronisk enhet som behöver
    reparationer.',
     'Något som är ur funktion.',
     'Gå in i alkoven utanför innergården.',
     'Positron-spelet behöver reparationer.',
     'Se till att titta noga på maskinen. Särskilt,
    lägg märke till instruktionskortet.']

    openWhenRevealed = 'need-ee-text'
    closeWhenRevealed = 'positron-repaired'
;

++ Goal 'Hur hittar jag Scott?'
    ['Du kan börja med att gå till hans rum.',
     'Instruktionskortet nämnde att han är i rum 39.',
     'Rum 39 är i Alley 7.',
     'Från innergården, gå upp för trapporna, gå sedan norrut, och norrut igen.',
     'Försök knacka på hans dörr.',
     'Om det inte finns någon annan runt just nu, bör du vänta
    ett tag---gå tillbaka och arbeta med Stamers stack lite.',
     'Om Erin och Aaron är i närheten, fråga dem bara om Scott.']

    openWhenRevealed = 'find-scott'
    closeWhenTrue = (scott.moved)
;

++ Goal 'Var kan jag hitta elektronisk testutrustning?'
    ['Läste du skylten på Brian Stamers dörr?',
     'Brian lämnade den nödvändiga utrustningen i sitt labb.',
     'Skylten nämner att hans labb är i Bridge, rum 022. (Bridge
    är en byggnad på campus---du kan hitta den på din campuskarta
    om du inte är säker på hur du tar dig dit.)']

    openWhenRevealed = 'needed-equip-list'
    closeWhenTrue = (blackBox.equipGathered)
;

++ Goal 'Oscilloskop? Signalgeneratorer? Jag är inte en EE-student!'
    ['Ta det lugnt---du behöver inte veta något om elektronik
    för att spela spelet. Din <i>karaktär</i> kanske måste kunna
    lite elektronik, men inte du.',
     'Du behöver inte ens oroa dig för detaljerna i att köra
    testutrustningen; din karaktär tar hand om det.']

    openWhenTrue = (gRevealed('needed-equip-list')
                    || oscilloscope.moved
                    || signalGen.moved)
    closeWhenRevealed = 'black-box-solved'
;

++ Goal 'Hur kan jag ta mig förbi röken i Alley One?'
    ['Kanske du bara behöver vänta ett tag.',
     'Stötte du på någon i korridoren?',
     'Vilken tid sa Erin att det var?',
     'Erin sa att det är lunchtid. Du kan lika gärna äta lunch
    medan du väntar på att branden ska släckas.',
     'Gå till Dabney matsalen och ät lite lunch.']

    openWhenTrue = (bwSmoke.location != nil)
    closeWhenRevealed = 'after-lunch'
;

++ Goal 'Vad är en Hovarth-funktion?'
    ['Du vet var du ska leta efter sådan information.',
     'Du behöver bara en kopia av DRD-mattabellerna.',
     'Precis som de flesta andra böcker du har behövt, finns denna
    förmodligen tillgänglig på biblioteket.',
     'Det är en mattebok, så prova mattevåningen.',
     'När du hittar boken, slå bara upp Hovarth-funktioner i den.']

    openWhenRevealed = 'hovarth'
    closeWhenRevealed = 'drd-hovarth'
;
++ Goal 'Hur beräknar jag det där Hovarth-numret?'
    ['DRD:n listar inte numret, så du måste beräkna det
    på något sätt.',
     'DRD:n nämnde att dessa nummer är beräkningsmässigt
     ohanterliga.',
     'Har du stött på något annat omnämnande av beräkningsmässigt
     ohanterliga problem?',
     'Läste du bakgrundsinformationen om Stamers forskningsprojekt,
     som refereras i rapporten i hans labb?',
     'Läs rapporten och gå sedan och hitta referenserna i biblioteket.
     Gå sedan tillbaka och läs rapporten igen. Det kommer att peka dig mot
     ytterligare en referens du bör titta på.',
     'Nu borde detta ge dig några idéer om hur du ska gå vidare.',
     'Hovarth-funktioner är beräkningsmässigt ohanterliga, men kanske
     en <q>kvantdator</q> skulle kunna hantera jobbet.',
     'Har du tittat noga på utrustningen i Stamers labb?',
     'Har du lekt med den?',
     'Har du listat ut vad som händer när du trycker ner på
     Dice-O-Matic medan utrustningen är igång?',
     'Utrustningen skapar ett <q>dekoherens</q>-fält. Allt
     du lägger inuti kommer att börja visa <q>kvant</q>-beteende.',
     'Att lägga en beräkningsenhet av något slag inuti utrustningen
     skulle kunna göra den till en kvantdator.',
     'En miniräknare är en typ av dator som kanske passar i
     utrustningen.',
     'Om du kunde programmera en miniräknare ordentligt, skulle du kunna lägga den
     i utrustningen för att förvandla den till en kvantminiräknare, som
     sedan skulle kunna lösa problemet.',
     'Dina färdigheter i att programmera miniräknare räcker inte till för uppgiften,
     men kanske det finns någon annan som skulle kunna hjälpa till.',
     'Har du varit i bokhandeln än?',
     'Läste du tidningen?',
     'Såg du delen om Jay?',
     'Kanske Jay skulle kunna programmera miniräknaren som behövs.']

    openWhenRevealed = 'drd-hovarth'
    closeWhenTrue = (calculator.isProgrammed)
;

++ Goal 'Var kan jag hitta en miniräknare?'
    ['Det finns en i öppen sikt, på en av platserna du
    redan har varit på.',
     'Det finns en miniräknare i Stamers labb i Bridge.']
    
    openWhenRevealed = 'qc-calculator-technique'
    closeWhenTrue = (calculator.moved)
;

++ Goal 'Hur hittar jag Jay?'
    ['Har du varit i bokhandeln än?',
     'Läste du tidningen?',
     'Jay är en student i Dabney. Kanske han arbetar med en stack.',
     'Gå och fråga Aaron om Jay.',
     'Jay är i Alley Four. Gå och fråga personerna där om honom.']

    openWhenRevealed = 'dvd-hovarth'
    closeWhenSeen = jay
;

++ Goal 'Hur får jag Jay att hjälpa mig?'
    ['Först måste du förklara vad du behöver att han gör.',
     'Det är två huvudsaker du behöver täcka: Hovarth-nummer,
     och kvantdatorer.',
     'Du kan bara fråga Jay om Hovarth-nummer.',
     'Kvantdatorer är lite svåra att förklara dock. Kanske
     du kan låta honom läsa om dem själv.',
     'Ge Jay <i>Quantum Review Letters</i> nummer 73:9a.',
     'När han är klar med att läsa kan du bara ge honom miniräknaren.',
     'Men innan han programmerar miniräknaren åt dig måste du
     göra något för honom, vilket han kommer att förklara.']

    openWhenTrue = (gRevealed('dvd-hovarth') && jay.seen)
    closeWhenRevealed = 'jay-ready-to-program'
;

++ Goal 'Hur hittar jag Turbo Power Squirrel?'
    ['Jay berättar för dig var han tror att den är.',
     'Du behöver bara komma in i Guggenheims vindtunnel.']

    openWhenRevealed = 'squirrel-assigned'
    closeWhenRevealed = 'squirrel-returned'
;

++ Goal 'Jay programmerade miniräknaren; vad händer nu?'
    ['Kommer du ihåg Dice-O-Matic? Om inte, gå tillbaka till Stamers labb
    och ta en närmare titt.',
     'Utrustningen i Stamers labb förvandlar vanliga saker till konstiga
     kvantsaker. Så kanske den skulle kunna förvandla din vanliga miniräknare
     till en kvantdator.',
     'Lägg miniräknaren i experimentet och slå på den. Tryck på
     den gröna knappen. Följ Jays instruktioner för att mata in numret
     från den svarta lådan.']

    openWhenTrue = (calculator.isProgrammed)
    closeWhenRevealed = 'hovarth-solved'
;

++ Goal 'Okej, Stamers dörr är öppen; vad händer nu?'
    ['Det är tradition att efter att ha löst en stack gå in i seniorens rum.
    Du bröt dig ju trots allt igenom deras försvar.',
     'Gå bara in i rum 4.']

    openWhenTrue = (room4Door.isOpen)
    closeWhenTrue = (me.isIn(room4))
;

++ Goal 'Jag är i Stamers rum. Vad händer nu?'
    ['Hjälp dig själv till mutan---du har förtjänat den.',
     'Häng bara runt ett tag. Brian kommer att dyka upp snart.',
     'När Brian dyker upp, prata med honom.']

    openWhenTrue = (me.isIn(room4))
;
/* ------------------------------------------------------------------------ */
/*
 *   The library 
 */
+ HintMenu 'Millikan-biblioteket';

++ Goal 'Hur kommer jag förbi receptionisten?'
    ['Läste du skylten?',
     'Vad ber receptionisten dig om?',
     'Du kanske tror att du måste lura honom på något sätt, men det behöver du inte.',
     'Trots allt är du en alumn, så du har rätt att använda biblioteket.',
     'Kanske har du ett ID-kort som bevisar det.',
     'Har du kollat i din plånbok?',
     'Visa ditt alumn-ID-kort för receptionisten.']

    openWhenSeen = millikanLobby
    closeWhenSeen = millikanElevator
;

++ Goal 'Hur hittar jag boken jag letar efter?'
    ['Du kanske har märkt att bibliotekets våningar är dedikerade
    till olika ämnen, så du måste först hitta rätt våning.',
     'Det finns en katalog utanför hissen på första våningen
     (titta på hissen om du inte har hittat den än).',
     'När du vet vilken våning din bok finns på, gå bara dit och
     leta efter den efter titel (HITTA titel I HYLLORNA).']
    
    openWhenSeen = millikanElevator
    closeWhenTrue = (LibBook.allLibBooksFound)
;

/* ------------------------------------------------------------------------ */
/*
 *   Hints for Bridge Lab 
 */
+ HintMenu 'Bridge-labbet';

++ Goal 'Stamers labb är låst! Hur kommer jag in?'
    ['Erin gav dig nyckeln när Belker mutade henne att gå och arbeta
    med en annan stack. Du behöver bara använda den nyckeln.']

    openWhenTrue = (!labKey.isIn(erin))
    closeWhenSeen = basementLab
;

++ Goal 'Hur kommer jag in i monterskåpet?'
    ['Har du hittat larmsystemet än? Sluta med detta ämne tills du gör det.',
     'Jag trodde jag sa att du inte skulle fortsätta med detta ämne förrän du hittade
     larmsystemet!',
     'Okej, så det finns inget larmsystem. Det enkla faktum är att du inte
     behöver komma in i monterskåpet.',
     'Sluta oroa dig för det redan; det är bara rekvisita.']

    openWhenSeen = bridgeEntry
;

++ Goal 'Hur får jag tag på SPY-9-kameran?'
    ['Du behöver faktiskt inte ta kameran, men det kan finnas
    andra intressanta saker om den.',
     'Tittade du noga på hur den är kopplad?',
     'Kanske du borde försöka lista ut vart kabeln går.']

    openWhenTrue = (spy9.described)
;

++ Goal 'Hur spårar jag kabeln från SPY-9-kameran?'
    ['Tittade du noga på den?',
     'Du borde gå och hitta kabelskåpet som nämndes när du tittade på
     kabeln.',
     'Kabelskåpet är i källaren, en nivå ner från labbet.',
     'När du har hittat kabelskåpet måste du lista ut vilken
     kabel som ansluter till kameran.',
     'Har du försökt söka igenom kabelmassan?',
     'Det föreslog ett sätt att identifiera kabeln.',
     'Gå upp och dra i kabeln som är ansluten till kameran, gå sedan
     ner och titta på kabelmassan igen.']

    openWhenTrue = (spy9Wire.described)
    closeWhenTrue = (bwirBlueWire.described)
;

++ Goal 'Betyder etiketten på SPY-9-kabeln något?'
    ['Du behöver inte oroa dig för detta på ett tag.']

    openWhenTrue = (spy9Tag.described)
    closeWhenTrue = (!plisnik.inOrigLocation)
;

++ Goal 'Vad betyder etiketten på SPY-9-kabeln?'
    ['Har du kollat runt Plisniks arbetsområde än?',
     'Ta en titt på ringpärmen.',
     'Numret på etiketten är ett jobbnummer i pärmen.']

    openWhenTrue = (spy9Tag.moved && !plisnik.inOrigLocation)
    closeWhenRevealed = 'spy9-ip'
;

++ Goal 'Finns det något sätt att spåra kabeln bortom kabelskåpet?'
    ['Du märkte att den går genom ett hål i norra väggen, eller hur?',
     'Så, kanske du borde ta reda på vad som finns på andra sidan väggen.',
     'Det finns ingen väg norrut från kabelskåpet, men kanske finns det en
     väg norrut från någonstans i närheten.',
     'Har du varit i förrådsrummet än?',
     'Har du tittat noga på allt där?',
     'Har du tittat särskilt på högen med skräpträ?',
     'Det finns en dörr bakom skräpträet.',
     'Träet är för tungt att ta, men kanske du kunde flytta det
     ur vägen.',
     'Bara FLYTTA TRÄ.',
     'Kabelskåpet är väster om förrådsrummet, så kanske om du
     går genom dörren och sedan västerut, hittar du vad du letar
     efter.',
     'När du är i <q>Smala Tunneln,</q> försök söka igenom rören.']

    openWhenTrue = (bwirBlueWire.described)
    closeWhenTrue = (st5Wire.described || steamTunnel8.seen)
;

++ Goal 'Var kan jag hitta böckerna som listas i bibliografin?'
    ['Låt se...\ var kan man hitta böcker? Tänk, tänk, tänk...',
     'Om det bara fanns en stor byggnad full av alla möjliga olika
     böcker...',
     'Har du provat biblioteket?',
     'Om du inte är säker på var biblioteket ligger, försök gå utomhus
     och hitta biblioteket på din karta.']

    openWhenRevealed = 'bibliography'
    closeWhenTrue = (LibBook.anyLibBookFound)
;

/* ------------------------------------------------------------------------ */
/*
 *   Steam tunnels 
 */
+ HintMenu 'Ångtunnlarna';

++ Goal 'Vad var kombinationen till förrådsrummet igen?'
    ['Va, för du inte noggranna anteckningar?',
     'Det är ' + st8Door.showCombo + '. ',
     'Om det inte fungerar kan du försöka trycka på Reset-knappen
     innan du anger kombinationen---låset kommer ihåg
     knapptryckningar tills dörren öppnas.',
     'Observera också att när du väl har öppnat dörren framgångsrikt en gång,
     kommer din karaktär att komma ihåg hur man gör det i framtiden; allt du
     behöver skriva från och med då är LÅS UPP DÖRR, eller till och med bara ÖPPNA DÖRR.']

    openWhenRevealed = 'supplies-combo'
;

++ Goal 'Hur kommer jag in i "Förråds"-rummet?'
    ['Du vill inte ens tänka på att gå in där medan någon
    annan är i närheten.',
     'Du kan lyssna vid dörren för att se om någon är i rummet.',
     'Om du bara väntar lite, kommer alla att lämna rummet.',
     'Men du behöver fortfarande veta kombinationen.',
     'Vem skulle känna till kombinationen?',
     'Personerna som redan är i rummet vet förmodligen kombinationen.',
     'Om du har undvikit personerna i rummet genom att lämna varje gång
     de dyker upp, har du förmodligen märkt att de kommer och går
     ofta.',
     'Kanske om du kunde spionera på dem när de anländer, skulle du kunna
     se kombinationen de anger.',
     'Men om du lämnar varje gång de dyker upp, kommer du inte att kunna
     spionera på dem.',
     'Kanske du kan stanna och hitta ett ställe att gömma dig på.',
     'Har du tittat på allt i "Återvändsgränd"-platsen?',
     'Har du lagt märke till nischen?',
     'Om du STÅ I NISCHEN innan arbetarna dyker upp, kommer de inte att
     märka dig, vilket ger dig en chans att spionera på dem.']

    openWhenSeen = steamTunnel8
    closeWhenRevealed = 'supplies-combo'
;

++ Goal 'Hur undviker jag att bli utkastad från tunnlarna av arbetarna?'
    ['Du får en liten varning när de är på väg att dyka upp.',
     'Du skulle kunna lämna innan de anländer.',
     'Eller kanske du kan stanna och hitta ett ställe att gömma dig på.',
     'Har du tittat på allt i "Återvändsgränd"-platsen?',
     'Har du lagt märke till nischen?',
     'Om du står i nischen innan arbetarna dyker upp, kommer de inte att
     märka dig.']

    openWhenRevealed = 'escorted-out-of-tunnels'
    closeWhenRevealed = 'supplies-combo'
;

++ Goal 'Hur spårar jag kameran förbi nätverksroutern?'
    ['Du har spårat den fysiska kabeldragningen till routern, men
    routern är ansluten till hela campusnätverket, så att spåra
    den fysiska anslutningen är meningslöst bortom denna punkt.',
     'Du behöver istället spåra nätverksanslutningen.',
     'Varje enhet på nätverket har en "IP-adress" som
     identifierar den. Om du kunde analysera data på nätverket,
     skulle du kunna ta reda på IP-adressen dit paketen går.',
     'Din karaktär råkar veta att en "nätverksanalysator"
    skulle låta dig spåra vart datapaketen går.',
     'Du behöver hitta en nätverksanalysator, koppla in den i
    routern och spåra paketen som kommer från kameran.',
     'För att spåra rätt paket måste du veta varifrån
    paketen kommer.',
     'Precis som alla enheter på nätverket har kameran en IP-adress.',
     'Du behöver hitta kamerans adress och spåra paket
    från den adressen. Det kommer att berätta för dig adressen till
    datorn som tar emot data från kameran.']

    openWhenRevealed = 'need-net-analyzer'
    closeWhenRevealed = 'spy9-dest-ip'
;

++ Goal 'Hur hittar jag en dator om jag vet dess IP-adress?'
    ['Du måste ha sett några Network Installer Company
    arbetsorderformulär vid det här laget. Lade du märke till standardtexten
    överst på varje formulär?',
     'Varje formulär säger att IP-adresstilldelningar måste
    erhållas genom Campus Network Office i Jorgensen.',
     'Kanske du kan besöka det kontoret och be dem slå upp
    IP-adressen åt dig.',
     'Om du inte vet var Jorgensen ligger, kolla bara din
    campuskarta.']

    openWhenRevealed = 'spy9-dest-ip'
    closeWhenSeen = syncLabOffice
;

++ Goal 'Jag fick arbetsordern för IP-adressen, men vad nu?'
    ['Du har tittat på arbetsordrar förut.',
     'Slå upp arbetsordern i pärmen du fick från Plisnik.',
     'Det kommer att berätta för dig vart du ska gå och hur du kommer in.']

    openWhenRevealed = 'sync-job-number-available'
    closeWhenSeen = syncLabOffice
;

++ Goal 'Var kan jag hitta en "nätverksanalysator"?'
    ['Har du stött på någon annan runt campus som arbetar med nätverk?',
     'Någon klädd liknande arbetarna du såg i tunnlarna,
    kanske?',
     'Arbetarna ute på Quad har liknande uniformer.',
     'Titta på utrustningen som arbetarna på Quad har.']

    openWhenRevealed = 'need-net-analyzer'
    closeWhenTrue = (netAnalyzer.moved)
;

++ Goal 'Vad gör jag med nätverksanalysatorn?'
    ['Hittade du instruktionerna om hur man använder analysatorn än?',
     'Har du stött på någon annan nätverksutrustning?',
     'Nere i ångtunnlarna någonstans, kanske?',
     'Du behöver hitta vägen in i rummet märkt "Förråd"
    innan du behöver nätverksanalysatorn.',
     'När du väl är i nätverksrummet (rummet märkt "Förråd"),
    ta en närmare titt på routern.',
     'Du bör lägga märke till två saker. För det första, notera var den blå kabeln går
    (den du har spårat). För det andra, notera det speciella uttaget på
    routern.',
     'Du har förmodligen listat ut att du kan koppla in nätverksanalysatorn
    i routerns speciella uttag.',
     'Vad vill du veta om routern?',
     'Du vill spåra vad som är anslutet till kameran, vilket kräver
    att du spårar datapaketen från kameran genom routern.
    Nätverksanalysatorn kan göra detta.',
     'När du väl har listat ut hur man använder nätverksanalysatorn, behöver du bara
    skriva in den speciella koden för att spåra paket från kameran.
    Du behöver veta kamerans IP-adress för att göra detta.']

    openWhenTrue = (netAnalyzer.moved)
    closeWhenRevealed = 'spy9-dest-ip'
;

++ Goal 'Jag förstår inte instruktionerna för nätverksanalysatorn!'
    ['De verkar vara dåligt översatta. Det kan hjälpa att
    veta att spåra ett datapaket på ett nätverk ofta kallas
    för jargongen "packet sniffing."',
     'Det du är ute efter här är ett sätt att spåra ett paket från
    en dator till en annan. Datorer identifieras av sina
    "IP-adresser," så om du vet IP-adressen för datorn som skickar data,
    vill du ta reda på IP-adressen för datorn som tar emot dessa paket.',
     'Observera att instruktionerna försöker varna dig för att
    nätverksanalysatormodellen du har använder olika kodnummer
    än de flesta andra modeller. De handskrivna bitarna längst
    ner på sidan kan vara viktiga.']

    openWhenDescribed = netAnInstructions
    closeWhenRevealed = 'spy9-dest-ip'
;

++ Goal 'Vad är en "IP-adress"?'
    ['Det är bara datajargong för ett speciellt nummer som tilldelas
    varje dator eller annan enhet som är ansluten till ett datornätverk.
    Varje enhet har sin egen unika IP-adress, som identifierar den så
    att de andra enheterna på nätverket kan skicka information till den.
    "IP" står för "internet protocol," och det kallas
    en "adress" eftersom det är lite som din gatuadress,
    i det att den berättar för andra maskiner var du är så att de kan skicka
    dig information. Det finns inget meningsfullt med de faktiska siffrorna
    i en IP-adress, åtminstone inte i den här berättelsen; det är bara ett godtyckligt
    identifikationsnummer, lite som ett personnummer.
    IP-adresser skrivs vanligtvis så här: 89.99.100.101---fyra
    decimala tal, från 0 till 255, separerade med punkter.']

    openWhenTrue = (netAnalyzer.moved)
;

++ Goal 'Hur konverterar jag decimal till hexadecimal (eller tvärtom)?'
    ['Hexadecimal är bara bas 16. 0-9 är samma som i decimal;
    10 i decimal skrivs som A i hex, 11 som B, 12 som C, 13 som D,
    14 som E, och 15 som F. 16 i decimal skrivs som 10 i hex.
    För att läsa ett hextal, behandla varje siffra som en potens av 16: den
    sista siffran är enheterna, den näst sista är 16-tal, den
    tredje sista är 256-tal, och så vidare. Så 100 hex är 1x256=256,
    200 hex är 2x256=512, 123 hex är 1x256+2x16+3x1=291.',
     'Självklart är det <i>enkla</i> sättet att konvertera att använda en hex-
    kalkylator. Windows CALC-programmet kan visa hex i sitt
    "Vetenskapliga" läge, till exempel. ']

    openWhenTrue = (netAnalyzer.moved)
;
++ Goal 'Vad är <q>hexadecimal</q>?'
    ['Det är ett talsystem med bas 16. Kommer du ihåg sakerna från
    grundskolan om att använda olika aritmetiska baser?
    Idén är att varje siffra kan innehålla 16 olika värden
    istället för bara de vanliga 10. Du behöver mer än bara
    siffrorna 0 till 9 för att representera de extra värdena,
    så i hexadecimal lägger du till A till F---A står för
    det decimala värdet 10, B för 11, C för 12, D för 13, E
    för 14, och F för 15. Så det hexadecimala (eller bara <q>hex</q>)
    talet 25 betyder 2 gånger 16, plus 5, eller 37 i decimal. 1F
    betyder 1 gånger 16, plus 15, vilket blir 31 i decimal.
    100 i hex är 1 gånger 16 gånger 16, eller 256 i decimal. 123
    i hex är 1 gånger 16 gånger 16, plus 2 gånger 16, plus 3,
    vilket är 291 i decimal.',
     'Datorprogrammerare tenderar att använda hex-numrering mycket
     eftersom det är relativt enkelt att konvertera hex-tal till
     och från binärt. De exakta orsakerna till detta lämnas
     som en övning för läsaren, men det har att göra med potenser
     av 2.']
    openWhenTrue = (netAnalyzer.moved)
;

++ Goal 'Var hittar jag instruktioner för nätverksanalysatorn?'
    ['Vem var det som skulle använda nätverksanalysatorn?',
     'Det är inte arbetarna på gården som använder nätverksanalysatorn---det är
     Plisnik.',
     'Har du tittat på de andra sakerna där Plisnik var?',
     'Tittade du på ringpärmen?',
     'Läste du den?',
     'Papperet som faller ut ur pärmen har instruktioner
     om hur man använder nätverksanalysatorn.',
     'Instruktionerna är lite svåra att läsa, eftersom de är dåligt
     översatta från något annat språk, men du borde kunna förstå
     dem.',
     'Du behöver bara delen om <q>paketluktning</q> (som egentligen
     betyder <q>paketsniffning,</q> datorjargong för att spåra flödet
     av data på ett nätverk från en dator till en annan).',
     'Notera de handskrivna kommentarerna längst ner på sidan.',
     'För att spåra paket på nätverket, skriv 09 plus IP-adressen
     du vill spåra. Till exempel, för att spåra paket från en enhet
     med IP-adress 8.9.10.11, skulle du skriva in 0908090A0B.']

    openWhenTrue = (netAnalyzer.moved)
    closeWhenRevealed = 'spy9-dest-ip'
;

++ Goal 'Hur får jag IP-adressen för SPY-9?'
    ['Lade du märke till etiketten på kabeln som är ansluten till kameran?',
     'Tittade du runt i Plisniks arbetsområde efter att han lämnade?',
     'Hittade du ringpärmen?',
     'Tittade du i den?',
     'Numret på kabeletiketten är ett arbetsordernummer. Slå upp det
     i pärmen.',
     'Arbetsordern som refereras på kabeletiketten hänvisar till en annan
     arbetsorder. Slå upp den också.',
     'Det prickade fyrsiffriga numret på arbetsordern är kamerans
     IP-adress.']
    
    openWhenTrue = (netAnalyzer.moved && nrRouter.seen)
    closeWhenRevealed = 'spy9-dest-ip'
;

++ Goal 'Hur blir jag av med Plisnik?'
    ['Försök prata med honom lite.',
     'Du har utan tvekan märkt att han har ett favoritämne.',
     'Något han är rädd för.',
     'Plisnik är rädd för råttor. Kanske en råtta skulle skrämma bort honom.',
     'Har du hittat råttleksaken?',
     'Kanske du kunde försöka visa den för Plisnik.',
     'Okej, så han är inte rädd för en leksaksråtta. Men om du fick den
     att se levande ut?',
     'Lade du märke till att det är en handdocka?',
     'Försök sätta den på din hand och visa den för honom.',
     'Så det övertygar honom inte heller. Kanske du behöver få
     leksaksråttan att se ut som om den rör sig utan din hjälp.',
     'Har du varit inne i Thomas än?',
     'Hittade du något intressant runt robottävlingen?',
     'Ta en titt på leksaksbilen.',
     'Leksaksbilen verkar röra sig av sig själv, om du kör den
     med fjärrkontrollen.',
     'Kanske du kunde använda leksaksbilen för att få leksaksråttan att se levande ut.',
     'Sätt råttan på leksaksbilen. Gå in i ångtunneln bredvid
     där Plisnik arbetar, och kör in råttan på distans.']

    openWhenSeen = plisnik
    closeWhenTrue = (!plisnik.inOrigLocation)
;

++ Goal 'Finns det något jag behöver slå upp i ringpärmen?'
    ['Lägg märke till jobbordernummerformatet: 1234-5678.',
     'Har du sett något annat i det formatet?',
     'Vad sägs om något i labbet i Bridge?',
     'Något relaterat till SPY-9.',
     'Försök slå upp numret på etiketten på SPY-9-kabeln.']
    
    openWhenTrue = (workOrders.described && spy9Tag.described)
    closeWhenRevealed = 'spy9-ip'
;

++ Goal 'Hur tar jag mig genom den nord-sydliga krypgången?'
    ['Har du någon anledning att gå den vägen?',
     'Du behöver inte oroa dig för att ta dig igenom. Det finns
     inget du behöver på andra sidan.']

    openWhenSeen = steamTunnel15
;

/* ------------------------------------------------------------------------ */
/*
 *   Other stacks 
 */
+ HintMenu 'De andra stackarna';

++ Goal 'Hur löser jag Pauls Stack (rum 42)?'
    ['Innan du sugs in i detta för mycket, kanske du bör notera
    varningarna som berättelsen visar då och då om hur denna stack
    inte är särskilt viktig. (Försök skriva in några slumpmässiga lösenord om
    du inte har sett varningarna än.) ',
     'Du behöver inte lösa denna stack för att vinna spelet. ',
     'Denna stack är helt valfri, så vi kommer att lämna den
     som en övning för läsaren. Var försäkrad om att det finns en lösning,
     dock (möjligen till och med mer än en). ',
     'För extra bonus nördighet, försök hitta ett annat lösenord som
    datorn upprepar tillbaka till dig i <i>omvänd ordning</i>. (Detta
    gör inget speciellt i spelet, men det är en intressant
    extra utmaning när du väl har listat ut hur pusslet fungerar.) ']

    openWhenSeen = commandant64
    closeWhenTrue = (room42door.isSolved)
;

++ Goal 'Hur löser jag Jättekyckling-stacken (rum 12)?'
    ['Om du har letat efter någon, kanske du kan
    hitta dem här.',
     'Du kanske kan försöka prata med kycklingarna.',
     'Om de inte är särskilt mottagliga, kan det ha att göra med
     reglerna för stacken.',
     'Du kanske vill läsa anteckningsboken (på dörren till rum 12)
     för information om stacken.',
     'Kycklingarna kan bara prata med andra kycklingar.',
     'Kanske du kunde hitta ett sätt att ansluta dig till dem.',
     'Har du kollat på Kycklingatorn?',
     'Gå in i Kycklingatorn och ta på dig dräkten. Det låter dig
     prata med kycklingarna och fråga om personen du letar
     efter.',
     'Utöver det finns det inget du måste göra med denna stack.
     Du har inte tid för en skattjakt utklädd som en jättekyckling.']

    openWhenSeen = alley3E
;

++ Goal 'Kan jag hjälpa till med Turbo Power Animals-stacken (rum 22)?'
    ['Du har mycket att göra på din egen stack. Du borde förmodligen
    inte oroa dig för mycket om denna, om inte en bra anledning
    dyker upp.']

    openWhenSeen = alley4W
    closeWhenRevealed = 'squirrel-assigned'
;

++ Goal 'Kan jag hjälpa till med Turbo Power Animals-stacken (rum 22)?'
    ['Du skulle kunna använda Jays hjälp, så det verkar värt din tid att gå
    och hämta Turbo Power Squirrel.',
     'Utöver det bör du förmodligen fokusera på din egen uppgift
     att lösa Brian Stamers stack.']
    
    openWhenRevaled = 'squirrel-assigned'
;

++ Goal 'Hur löser jag <i>Honolulu 10-4</i>-stacken (rum 24)?'
    ['Har du försökt spela spelet?',
     'Övning kan hjälpa.',
     'Men även med övning är musiken en outhärdlig distraktion.',
     'Tyvärr finns det inget sätt att stänga av musiken.',
     'Du bör förmodligen inte oroa dig för mycket om denna stack just nu.
     Brian Stamers stack är mycket viktigare för dig.']

    openWhenSeen = alley5S
;

++ Goal 'Hur löser jag bananfluge-stacken (rum 35)?'
    ['Du bör förmodligen inte låta denna stack ta tid från
    din huvuduppgift att lösa Brian Stamers stack, om inte en bra
    anledning dyker upp.']

    openWhenSeen = alley6E
;

++ Goal 'Hur löser jag brute-force-stacken (rum 50)?'
    ['Studenterna verkar ha kontroll över den här. Du
    bör förmodligen fokusera dina ansträngningar på Brian Stamers stack.']

    openWhenSeen = lower7W
;