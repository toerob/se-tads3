#charset "utf-8"
#include <adv3.h>
#include <sv_se.h> 

#define __DEBUG
#include "../debug.h"

#define MAX_SCORE 30;

// TODO: fixa norr

Test 'spel' ['ta allt', 'ät svamp', 'ner', 'läs inskriptioner', 'x solljus',  'x pygmé', 'öst', 'ta äggsäck', 'väst', 'sätt äggsäcken i solljuset', 'ta nyckel', 'söder', 'öppna dörr', 'lås upp dörr', 'fotografera statyett', 'söder', 'ta på mask', 'sv', 'fråga om xibalba', 'sv', 'upp', 'tryck klotet nedåt', 'ner', 'norr', 'tryck klot s', 's', 'ner', 's'];


versionInfo: GameID
    IFID = '952c94dd-f92a-4970-9a00-cdcc24d038a1'
    name = 'RUINER'
    byline = 'by Angela M. Horns.'
    htmlByline = 'by <a href="mailto:yourmail@address.com"></a>'
    version = '1'
    authorEmail = 'Tomas yourmail@address.com'
    desc = 'Ett Interaktivt bearbetat exempel'
    htmlDesc = 'Ett Interaktivt bearbetat exempel'
;

modify Room
    roomDarkDesc = "Åldrarnas mörker pressar sig in på dig, och du känner dig klaustrofobisk."
    /*
    *  Unlike Inform, TADS 3 doesn't automatically as '(as whatever)' to the
    *  room name when the PC isn't the initial player object. We make a small
    *  modification below to add this feature.
    */
    lookAroundWithinName(actor, illum)
    {
        /* 
        *   if there's light, show our name; otherwise, show our
        *   in-the-dark name 
        */
        if (illum > 1)
        {
            /* we can see, so show our interior description */
            
            /* 
            * If the player character isn't me (the initial PC) add the PC's
            * name in parenthesis to the end of the room name.
            */
            "\^<<roomName>> <<gPlayerChar != me ? '(som ' + gPlayerChar.name + ')' : ''>>";
        }
        else
        {
            /* we're in the dark, so show our default dark name */
            say(roomDarkName);
        }

        /* show the actor's posture as part of the description */
        actor.actorRoomNameStatus(self);
    }
;

gameMain: GameMainDef
    //usePastTense = true
    initialPlayerChar = me

    showIntro() {
        "Dagar av sökande, dagar av törstigt hackande genom skogens törnbuskar, men äntligen belönades ditt tålamod. En upptäckt!\b";
    }
    newGame()
    {
      titlePage();
      inherited();
    }

    maxScore = 30
    scoreRankTable = [
      [0, 'Turist'],
      [5, 'Utforskare'],
      [10, 'Nyfiken sökare'],
      [25, 'Arkeolog'],
      [30, 'Direktör för Carnegie-institutionen']      
    ]
    
    titlePage()
    {
      cls();    

      /* 
       *  There's no TADS 3 equivalent to the Inform box command, but we
       *  can create much the same effect with table created in HTML
       *  markup.
       */
       
      "\b\b<TABLE ALIGN=CENTER CELLPADDING=16>
      <TR><TD BGCOLOR=text>      
      <FONT FACE='TADS-TYPEWRITER' COLOR=bgcolor> 
      <b>Men Alligatorn grävde inte botten av hålet
        Som skulle bli hans grav,\n
        Utan snarare grävde han sitt eget hål\n
        Som ett skydd för sig själv.\b
        --- <i>från Popol Vuh</i>\b</b>
      </FONT></TD></TR>
      <TR></TR>
      <TR><TD ALIGN=CENTER>
      <FONT FACE='TADS-TYPEWRITER'> 
      [Tryck MELLANSLAG för att börja]</FONT>
      </TD></TR>
      </TABLE>";

      inputManager.getKey(nil, nil);
      cls();      
    }
    setAboutBox()
    {
      "<ABOUTBOX><CENTER><b><<versionInfo.name>></b></CENTER>\b
       <CENTER><<versionInfo.byline>></CENTER>\b
       <CENTER>Version <<versionInfo.version>> 
       </CENTER></ABOUTBOX>";      
    }
;





me: Actor 'din min kropp' 'din kropp' @forest
  npcDesc = "It looks rather inert. "
  isQualifiedName = true
  dobjFor(Photograph)
  {
    verify() { illogicalSelf('Bättre att låta bli. Du har inte rakat dig sen Mexico. '); }
  }
;




warthog: UntakeableActor 'vårt+svin+et' "Muddy and grunting. "
  pcDesc = "Lerig och grymtande."
  actorHereDesc = "Ett vårtsvin sniffar och grymtar omkring i askan. "
  isProper = true
  actorAction()
  {
    /*
    #ifdef __DEBUG
      //if(gActionIn(Snarf, Zarvo, Pow))
        return;
    #endif
    */
    
  
    if(gActionIs(Eat))
      failCheck('Du har inte knäckt knepet med att sniffa upp mat än. ');
    if(!gActionIn(Look, Examine, Travel, Smell, Taste, Feel,
      LookIn, Search, Jump, Enter, TravelVia, System))
      failCheck('Vårtsvin kan inte göra något så invecklat. Om det inte vore för
                 nattsynen och den förlorade vikten, skulle de vara sämre ställda
                 på alla sätt än människor. ');
      
  }
;


class Unimportant: Decoration '-' 'det'
   "<<notImportantMsg>>"
   notImportantMsg = '<<self.theName>> är inget du behöver referera till under gången av det här spelet.'
; 
 


class Treasure: Thing
    photographedInSitu = nil
    culturalValue = 5
    dobjFor(Remove) asDobjFor(Take)
    dobjFor(Take) {
        check() {
            if(isIn(packingCase)) {
                failCheck('Det vore bäst att vänta med uppackandet av en sån obetalbar aartefakt till dess att Carnegieinstitutionen kan göra det. ');
            }
            if(!photographedInSitu) {
                failCheck('Detta är 30-talet; inte den gamla dåliga tiden. Att ta en artefakt utan att redogöra dess kontext vore helt enkelt att plundra. ');
            }
            inherited;
        }
    }
    dobjFor(PutIn) {
        action() {
            inherited;
            if (gIobj == packingCase) {
                addToScore(culturalValue, 'packing ' + theName + ' in the case. ');
                if(libScore.totalScore == gameMain.maxScore) {
                    "Då du försiktigt packar undan {the dobj/han} fladdrar en rödstjärtad ara ner från trädtopparna, dess fjädrar tunga i det senaste regnet, ljudet av dess slagande vingar nästan öronbedövande, sten faller mot sten... 
                    När himlen klarnar stiger en halvmåne upp ovanför en fridfull djungel. Det är slutet på Mars 1938, och det är dags att åka hem.";

                    finishGameMsg(ftVictory, [finishOptionUndo, finishOptionFullScore]);
                }
                "Säkert undanpackad.";
            }
        }
    }
    dobjFor(Photograph) {
        check() {
            if(!self.isInitState)  {
                failCheck('Va, falsifiera den arkeologiska uppteckningen? ');
            }
            if(photographedInSitu) {
                failCheck('Inte igen. ');
            }
            inherited;
        }
        action() {
            inherited;
            photographedInSitu = true;
        }
    }
;


forest: OutdoorRoom '<q>STORA TORGET</q>' 'stora torget'
"Eller så kallar i alla fall dina anteckningar denna låga branta sluttning av kalksten, men nu har regnskogen har tagit tillbaka det. Mörka olivträd tränger in från alla sidor, luften ångar av dimma från ett nyligt varmt regn, myggor hänger i luften. <q>Struktur 10</q> är en ruta av murverk som kan en gång i tiden har varit en begravningspyramid. Få saker har överlevt förutom de stenhuggna trappstegen som leder ner i mörkret nedanför. "
    in asExit(down)
    down = steps
    up: NoTravelMessage {
        "Träden är taggiga och du skulle skära upp dina händer fullständigt om du försökte klättra i dem. "
    }
    cannotGoThatWayMsg = 'Regnskogen är tät, och du har inte hackat dig igenom den i flera dagar för att överge din upptäckt nu. Vad du behöver göra är att hitta ett par riktigt bra fynd att ta med tillbaka till civilisationen innan du kan rättfärdiga att ge upp expeditionen. '
    roomBeforeAction()
    {
        if(gActionIs(Photograph)) {
         failCheck('I denna regnblöta skog är det bäst att låta bli. ');            
        }
    }

;

+SimpleNoise 'ljud+et/fladdermöss+en/macaw+er/papegoja/ara/djungel+n*papegojor aror' 'djungeln' 
    "Vrålapor, fladdermöss, papegojor, aror."
    isPlural = true
;

+ Unimportant 'mörk oliv limesten/träd+en/regnskog+en/skog+en/knott+en'
;

// TODO: kontrollera att det blir rätt adjektiv och inte bara substantiv:
// TODO: >ta svamp "Du hade redan de fläckiga svampar." 
//          borde bli: >ta svamp "Du hade redan de fläckiga svamparna."
// Ska du hade redan ha bestämd form istället? 

+ mushroom: Food 'fläckig[-a] svamp+en padd+svamp+en fläckig[-a] svampar[-na]' 'fläckiga svampar'
    "Svampen är täckt med fläckar, och du är inte alls säker på att det inte är en paddsvamp.",
    theName = 'de fläckiga svamparna'
    isQualifiedName = 'de fläckiga svamparna'
    isPlural=true
    initSpecialDesc = 'På en lång stjälk i den genomdränkta jorden växer en fläckig svamp.'
    
    /*
    okayTakeMsg {
        if (!moved) {
            "Du plockar upp den långsamt sönderfallande svampen. ";
            return;
        } 
        moved = true;
        "Du plockar svampen och klyver snyggt dess tunna stjälk. ";
    }
    okayDropMsg {
        "Svampen faller till marken, något skadad. ";
    }
    okayEatMsg {
        steps.rubbleFilled = nil;
        "Du gnager på ett hörn, oförmögen att spåra källan till en
        skarp smak, distraherad av en ara som flyger över huvudet
        som tycks brista ut ur solen, ljudet av dess vingslag
        nästan öronbedövande, sten faller mot sten.";
    }
    */

    dobjFor(Take) {
     action() {
       if(!moved)
         "Du plockar svampen och klyver snyggt dess tunna stjälk. ";
       inherited;
     }
   }
   
   dobjFor(Drop) {
     action() {
        "Svampen faller till marken, något skadad. ";
        inherited;
     }
   }
   
   dobjFor(Eat) {
     action() {
        moveInto(nil);
        steps.isInInitState = nil;
        "Du gnager på ett hörn, oförmögen att spåra källan till en
        skarp smak, distraherad av en ara som flyger över huvudet
        som tycks brista ut ur solen, ljudet av dess vingslag
        nästan öronbedövande, sten faller mot sten.";
     }
   }
;



// NEXT

+ packingCase: Heavy, OpenableContainer 'packväska+n/väska+n/pack/låda+n' 
    initSpecialDesc =  "Din packväska ligger här, redo att fyllas med alla viktiga kulturella fynd du kan göra, för transport tillbaka till civilisationen."
    cannotTakeMsg = 'Väskan är för tung för att flytta på, så länge din expedition fortfarande är ofullständig. '
    initiallyOpen = true 
;

++ camera: Thing  'våtplåts plåt våt våtplåtskamera+n/kamera+n' 
"En otymplig, robust, envis träinramad våtplåtsmodell: som alla arkeologer har du ett kärleks-hatförhållande till din kamera."

   dobjFor(Photograph)
   {
    verify() { illogicalSelf('Du kan inte använda kameran för att fotografera sig själv. '); }
   }

;

++ newspaper: Thing 'månad gammal tidning+en/times/' 'en månad gammal tidning'
    "<q>The Times</q> från 26 februari 1938, på en gång fuktig och skör efter en månads exponering för klimatet, vilket är ungefär hur du känner dig själv. Kanske är det dimma i London. Kanske finns det bomber."
;


+ steps: StairwayDown  'sten huggen huggna stenhuggen stenhuggna trappsteg+en/steg+en/stenstege+n/trappsteg+en/stentrapp+en/tio/10/pyramid/begravning[-splats]/struktur+en' 'stenhuggna trappsteg'
    "De spruckna och slitna trappstegen leder ner till en dunkel kammare. Dina fötter kanske  <<squareChamber.seen ? 'är de första att beträda'
        : 'har varit de första att ha beträtt'>> dem på femhundra år. På det översta trappsteget är glyfen Q1 inristad. "
    
    initDesc = "Rasmassorna blockerar vägen efter bara några steg."
    isPlural = true
    canTravelerPass(traveler) { 
        return !isInInitState; 
    }
    explainTravelBarrier(traveler) { initDesc; }
    destination = squareChamber
    dobjFor(Enter) remapTo(TravelVia, self)
;


sodiumLamp: Flashlight, FueledLightSource, TravelPushable 
    'tung+a kraftig+a natrium+lampa+n' 'natriumlampa' @me
    "Det är en kraftig arkeologlampa, << isLit ? (fuelLevel < 10
   ? 'som glöder med ett svagt gult sken.' : 'som lyser med ett starkt gult ljus')
   : 'för närvarande avstängd.'>>. "

    fuelLevel = 100
    burnDaemon {
        inherited;
        switch (fuelLevel) {
            case 10:  "<.p>Natriumlampan blir svagare!"; break;
            case  5:  "<.p>Natriumlampan kan inte hålla mycket längre."; break;
        }
    }
    sayBurnedOut { 
        "<.p>Natriumlampan bleknar och dör plötsligt.<.p>"; 
    }
    dobjFor(Take) { 
        check() {
            if (isLit) {
                 failCheck('Glödlampan är för ömtålig och metallhandtaget för varmt för att lyfta lampan medan den är påslagen.');
            }
        }
        action()  { inherited Thing; }
    }
    dobjFor(Drop) { action() { inherited Thing; } }

    dobjFor(TurnOn) { 
        check() {
            /*if (self.fuelLevel <= 0) {
                "Tyvärr verkar batteriet vara dött.";
                return;
            }*/
            if(!location.ofKind(BasicLocation) && !location.ofKind(Platform)) {
                failCheck('Lampan måste placeras säkert innan den tänds.');            
            }
        }
    }
    dobjFor(TurnOff) { 
        check() {
            if(getOutermostRoom.brightness == 0) {
                failCheck('Bäst att låta bli -- du skulle bli helt utlämnad till mörkret. ');
            }
        }
    }
    
    canPushTravelVia(connector, dest) { 
        return connector != shrine.southwest; 
    }
    explainNoPushTravelVia(connector, dest) {  
        "Det närmaste du kan göra är att skjuta natriumlampan till kanten av Helgedomen, där grottgolvet faller bort.";
    }

    dobjFor(PushTravelDir) { 
        check() {
            // TODO: testa denna
            if (gPlayerChar.location.isIn(shrine) && gDobj == southwestDirection) {
                 "Glödlampan är för ömtålig och metallhandtaget för varmt för att lyfta lampan medan den är påslagen.";
            }
        }
    }
    
  /*
   *   TADS 3 moves a TravelPushable into a new location *after* the actor
   *   who's pushing it, so if the player character pushed the lamp into a 
   *   dark area, it will still appear dark, even if the lamp is lit. To get
   *   round this we'll move a dummy light object (with the same brightness
   *   as the lamp) into the destination ahead of the actor to represent
   *   the light cast by the lamp.
   */
    
  beforeMovePushable(traveler_, connector, dest)
  {
    dummyLight.brightness = brightness;
    dummyLight.moveInto(dest);
  }
    
  describeMovePushable (traveler, connector)  
  {
    "You push the sodium lamp into <<getOutermostRoom.destName>>. ";
    
    /* Once the real lamp arrives, we can get rid of the dummy light */
    dummyLight.moveInto(nil);
  }
    
  brightnessOn = (fuelLevel > 9 ? 3 : 2)
  
  /* 
   *  We'll let the player refer to the lamp in the dark even when it's off -
   *  this makes it a bit less easy to put the game into an unwinnable state.
   *  We can do this most easily by giving it a brightness of 1 even when it's
   *  off; this makes it "self-illuminating", i.e. visible in the dark even though
   *  it doesn't make any neighbouring objects visible in the dark.
   */
   
  brightnessOff = 1
  
  isInInitState = (!isLit)
  isListedInInventory = true
  initSpecialDesc = "Natriumlampan står stadigt på backen. "
  specialDesc = "Natriumlampan brinner stadigt där den står på backen. "  
  useSpecialDesc { return location.ofKind(BasicLocation); }
;

dummyLight: SecretFixture
;

map: Readable 'skiss-karta över Quintana Roo' 'skiss-karta över Quintana Roo' @me
    "Denna karta markerar lite mer än bäcken som förde dig hit, från Mexikos sydöstra kant och in i den djupaste regnskogen, bruten endast av denna upphöjda platå.";
;

squareChamber:  Room 'Fyrkantig Kammare' 'fyrkantiga Kammaren'
    "En nedsänkt, dyster stenkammare, tio meter tvärs över. En stråle solljus skär in från trappstegen ovan, vilket ger kammaren ett diffust ljus, men i skuggorna leder låga överliggande dörröppningar åt öster och söder in i templets djupare mörker."
    up = forest
    south = corridor
    east = wormcast
;

+ Unimportant 'östra södra låga överliggande dörr+öppning+ar/överliggare/skuggor'
  isPlural = true
;

+stoneDoorNorth: Door, LockableWithKey  'massiv+a stor+a gul+a sten+dörr+en' 'stendörr'
    "Det är bara en stor stendörr. <<if isOpen>>Den stora gula stendörren är öppen<<else>>
    Passagen blockeras av en massiv dörr av gul sten<<end>>. "
    knownKeyList = [stoneKey]
    keyList = [stoneKey]
;

+stepsBottom: StairwayUp 'sten huggen huggna stenhuggen stenhuggna trappsteg+en/steg+en/stenstege+n/trappsteg+en/stentrapp+en/tio/10/pyramid/begravning[-splats]/struktur+en' 'stenhuggna trappsteg'
    desc {
        "De spruckna och slitna trappstegen leder ner till en
        dunkel kammare. Dina fötter kanske har varit de första att ha beträtt dem på femhundra år. På det översta trappsteget är glyfen Q1 inristad. ";
    }
    isPlural = true
;    

// TODO: bygg testfall av detta
+inscriptions: Fixture 
        'inrista+de rörlig+a krylla+nde mängd+er av inskription+er/ristning+ar/märk+en/markering+ar/symbol+er/pil+en/cirkel+n'
        'inristade inskriptioner'
         "Varje gång du tittar noga på ristningarna verkar de vara stilla. Men du har en obehaglig känsla när du tittar bort att de kryper, rör sig omkring. Två glyfer är framträdande: Pil och Cirkel."
        isListed = true
        initSpecialDesc = "Inristade inskriptioner trängs på väggarna, golvet och taket."
        isPlural = true
;

// TODO: Hur löser man egentligen "stråle av solljus" 
// så adjektiv substantiv blir korrekt?
// TODO: bygg fler tester av flera sammansatta ord åtskiljda av '/' så som detta exempel:
+ sunlight: Vaporous 'solbelyst stråle av solens sol+ljusstråle+n/sol:en+ljus+et/luft+en/damm+korn+en/damm+et*strålar' "Dammkorn glimmar i strålen av solbelyst luft, så att den nästan verkar fast."
    dobjFor(Search) asDobjFor(Examine)
                
    notWithIntangibleMsg = 'Det är bara en immateriell solljusstråle.' 
    iobjFor(PutIn) {
        verify() {
            if(gDobj && gDobj == self)
                illogicalSelf('You can\'t put the shaft of sunlight in itself. ');
        }
        action() {
            if(gDobj==eggsac) {
                eggsac.moveInto(nil);
                stoneKey.moveInto(location);
                "Du släpper äggsäcken i skenet av solljusstrålen. Den bubblar obscent, sväller och brister sedan i hundratals små insekter som springer åt alla håll in i mörkret. Endast stänk av slem och en märklig gul stennyckeln återstår på kammarens golv.";
            }
            else {
                "Du håller {den dobj/honom} i skenet av ljusstrålen en liten stund. ";
            }
        }        
    }   
;


MultiLoc, Vaporous  'lågt virvlande dimma+n'
  "Dimman har en arom som påminner om tortilla."
  notWithIntangibleMsg = 'Dimman är för osubstansiell. '
  locationList = [forest, squareChamber]
;

+ SimpleOdor 'lukt/odör+en/tortilla+n' 'odör'
  "<<location.desc()>>"
  disambigName = 'odör av tortilla'
;  

corridor: Room 'Den krökta korridor+en' 'krökta korridoren'
"En låg, fyrkantigt huggen korridor som löper från norr till söder, och får dig att böja dig.",
    north = squareChamber
    south = stoneDoor
;
+stoneDoor: LockableWithKey, Door 'massiv+a stor+a gul+a sten+dörr+en' 'stendörr'
    "Det är bara en stor stendörr."
    isInInitState = (!isOpen)
    initSpecialDesc = "Passagen blockeras av en massiv dörr av gul sten. "
    specialDesc =  "Den stora gula stendörren är öppen"
    keyList = [stoneKey]
;

+statuette: Treasure 'pygmé+statyett+en' 
    "En hotfull, nästan karikatyrliknande statyett av en pygméande med en orm runt halsen."
    initSpecialDesc = "En dyrbar mayastatyett vilar här!"
;


shrine: Room 'Helgedomen' 'helgedomen' "Denna magnifika Helgedom visar tecken på att ha urholkats från redan existerande kalkstensgrottor, särskilt i den västra av de två långa takfoten i söder.",
    north = stoneDoorInside
    southeast = antechamber
    southwest: OneWayRoomConnector { -> junction
      canTravelerPass(traveler) { 
        return !icicles.isIn(lexicalParent); 
     }
      explainTravelBarrier(traveler) {
        "Takfoten smalnar av till en spricka som skulle fortsätta längre om den inte var tätt packad med istappar. Glyfen för Halvmåne är nästan dold av is.";
      }
    }
;

+stoneDoorInside: Door -> stoneDoor 'massiv+a stor+a gul+a sten+dörr+en' 'stendörr'
    "Det är bara en stor stendörr."
    isInInitState = (!isOpen)
    initSpecialDesc = "Passagen norrut blockeras av en massiv dörr av gul sten. "
    specialDesc =  "Den stora gula stendörren är öppen"
;

+stone_table: Heavy, Enterable, Surface 'stora stort sten+häll^s+altare+t/stenhäll+en/bord+et'
    initSpecialDesc =  "En stor stenhäll av ett bord, eller altare, dominerar Helgedomen."
;

++mask: Wearable 'jade+mosaik^s+ansikte^s+mask+en' "Så utsökt den skulle se ut på museet."
    initSpecialDesc = "Vilande på altaret finns en jademosiakansiktsmask."
    culturalValue = 10
    dobjFor(Wear) {
        action() {
            inherited;
            priest.moveIntoForTravel(shrine);
            if(gPlayerChar.isIn(shrine)) {
                "När du tittar genom obsidianögonspringorna i mosaikmasken, avslöjar sig en spöklik närvaro: en mumifierad kalenderlig präst, till synes väntande på att höra dig tala.";
            }
        }
    }     
    dobjFor(Doff) {
        action() {
            inherited;
            if(gActor.canSee(priest)) {
                "Då du tar av masken, försvinner den mumifierade kalenderliga prästen från ditt synfält. ";
            }
            priest.moveInto(nil);
        }
    }
;

+ icicles: Decoration 'istappar' 'istappar' "istappar täpper för sprickan som leder sydväst. ";

+ Decoration 'halvmåne+formad+e glyf+er';

+ paintings: Fixture 'målning+ar/herre+n/fånge+n' 'målningar' 
    "Köttet på kropparna är blodröda. Markeringarna för den Långa Räkningen daterar händelsen till 10 baktun 4 katun 0 tun 0 uinal 0 kin, den typ av årsdag då en Herre slutligen skulle halshugga en tillfångatagen rival som hade rituellt torterats under en period av några år, i den balkaniserade galenskapen i mayastadsstater."
    initSpecialDesc = "Livligt upptagna målningar av den bepansrade Herren som trampar på en fånge är nästan för ljusa att titta på, graffiti från en organiserad pöbel."
    isPlural = true
;


wormcast: Room 'Maskhål' 'maskhålet' 
    "En störd plats av håligheter utskurna som ett spindelnät, strängar av tomrum hängande i sten. De enda gångarna breda nog att krypa igenom börjar löpa nordost, söderut och uppåt.",
    west = squareChamber

   west = squareChamber
   northeast = burrowCrawl
   up = burrowCrawl
   south = burrowCrawl
   cannotGoThatWay()
   {
     if(gActor != warthog) {
        "Även om du börjar känna dig säker på att något ligger bakom och genom maskhålet, måste denna väg vara en djurgång i bästa fall: den är alldeles för smal för din fåtöljarkeologs mage.";
     } else {
        "Maskhålet blir halt runt din vårtsvinkropp, och du gnäller ofrivilligt när du gräver dig genom mörkret, och faller slutligen söderut till...<.p>";
        nestedAction(TravelVia, burialShaft);
     }     
   }
   roomAfterAction
   {
     if(gActionIs(Drop)) {
        gDobj.moveInto(squareChamber);
        "Den dobj/han} glider genom en av gångarna och försvinner snabbt ur sikte.";
     }
   }
;   

+ eggsac: Thing 'glänsande vit ägg+säck+en' 'glänsande vit äggsäck'
    initSpecialDesc = "En glänsande vit äggsäck, som en klump grodrom stor som en strandboll, har fäst sig vid något i en spricka i en vägg."
    dobjFor(Take) {
        action() {
            inherited();
            "Åh herregud.";
        }
    }    
    beforeTravel(traveler, connector) {
        if(connector == squareChamber.up && self.isIn(traveler)) {
        "I det ögonblick naturligt ljus faller på äggsäcken bubblar den obscent och sväller. Innan du kan kasta bort den brister den i hundratals små, födelsehungriga insekter...";
        finishGameMsg(ftDeath, [finishOptionUndo]);
        }    
    }
;

burrowCrawl: TravelMessage
// TODO: översättning
  /*"The wormcast becomes slippery round you, as though your
   body-heat is melting long hardened resins, and
   you shut your eyes as you tunnel tightly through darkness. "*/   
  travelDesc =
          "Maskhålet blir halt runt dig, som om din kroppsvärme smäter den härdade kådan och, och du blundar medan du tunnlar tätt genom mörkret. "
  destination = (eggsac.isIn(gPlayerChar) ? squareChamber
    : rand(squareChamber, corridor, forest));

;

antechamber: Room 'För+kammare+n' 'förkammaren'
    "De sydöstra takfoten i Helgedomen bildar en märklig förkammare.",
    northwest = shrine
;


+ cage: Openable, Booth, Fixture 'järn järnbur+en/bur+en/galler/gallrad/ram+en/glyf+er' 'järnbur'
    "Glyferna lyder: Fågel Pil Vårtsvin."
  roomDesc() {
    if(cageFloor.isOpen) {
        "Från burens golv skär en öppen jordgrop ner i gravkammaren.";
    } else {
        "Burens galler omger dig.";        
    }
  }
  isLookAroundCeiling(actor, pov) { return true; }   

  isInInitState = (isOpen)
  initiallyOpen = true
  initSpecialDesc = "En järngallerbur, stor nog att böja sig i, tornar
             hotfullt upp sig här, med dörren öppen. Det finns några glyfer på
             ramen."
  specialDesc = "Järnburen är stängd."
  useSpecialDesc = (!gActor.isIn(self))
  material = fineMesh
  down = cageFloor
  
  afterAction()
  {
    if(gActionIs(GetOutOf))
      gActor.lookAround(gameMain.verboseMode.isOn);
  }
;

++ skeletons : Fixture 'vansinniga gamla skelett+en/ben+en/döskallen/*döskall+ar'
   'vansinniga skelett'
   "Bara gamla benrester. "
   isListedInContents = true
   isPlural = true
   afterAction()
   {
    if(me.isIn(cage)) {
        "Skeletten som bebor buren vaknar till liv, låser beniga händer runt dig, krossar och slår. Du förlorar medvetandet, och när du återfår det har något groteskt och omöjligt inträffat...<.p>";
        warthog.moveIntoForTravel(antechamber);
        warthog.brightness = 3;
        moveInto(nil);
        cage.makeOpen(nil);
        me.makePosture(lying);
        foreach(local obj in me.contents)
        obj.moveInto(me.location);  // if I'm unconscious I'll drop everything.
        setPlayer(warthog);
        gPlayerChar.lookAround(true);
    }
   }
;

// TODO: översätt
++ cageFloor: HiddenDoor 'öppen jordgrop gravkammare+n/golv+et/hål+et/kammar+en' 'mark'
   "En öppen jordgrop skär ner till gravkammaren nedanför."
   destination = burialShaft
;





burialShaft: Room 'Grav+schakt+et' 'gravschaktet' 
    "I dina eventuella fältanteckningar kommer detta att stå: ~En korbelbågad krypta med en kompakt jordplugg som försegling ovan, och målade figurer som förmodligen representerar Nattens Nio Herrar. Utspridda ben verkar tillhöra en äldre man och flera barnoffer, medan andra gravfynd inkluderar jaguartassar.~ (I fältanteckningar är det viktigt att inte ge något intryck av när du är skräckslagen.)"
    cannotGoThatWayMsg = 'Arkitekterna bakom denna kammare var mindre än generösa med att tillhandahålla utgångar. Något vårtsvin verkar ha grävt sig in från norr dock.'

    north = wormcast
    up: OneWayRoomConnector { -> cage
      canTravelerPass(traveler) { return traveler == me; }
      explainTravelBarrier(traveler) {
        "Med ett mäktigt vårtsvinshopp stångar du mot jordpluggen som förseglar kammaren ovan, och kollapsar din värld i aska och jord. Något livlöst och fruktansvärt tungt faller ovanpå dig: du förlorar medvetandet, och när du återfår det har något omöjligt och groteskt hänt...<.p>";
        setPlayer(me); 
        plug.moveInto(nil);
        me.moveIntoForTravel(lexicalParent);
        warthog.brightness = 0;
        cageFloor.makeOpen(true);                  
        foreach(local obj in cage.contents)
        if(obj.moved)
            obj.moveInto(lexicalParent);         
      }
      isConnectorApparent(origin, actor) { return actor == me; }
    }
    
    roomBeforeAction()
    {
      if(gActionIs(Jump))
        replaceAction(Up);
    }
;

+honeycomb: Treasure, Food 'gammal forntida honung^s+kaka+n'
            "Kanske någon form av gravoffergåva."
    initSpecialDesc = 
    "En utsökt bevarad, forntida honungskaka vilar här!"
    dobjFor(Eat) {
        action() {
            inherited;
            "Kanske den dyraste måltiden i ditt liv. Honungen smakar konstigt, kanske för att den användes för att förvara inälvorna från Herren som begravdes här, men fortfarande som honung.";
        }
    }
;

+ plug: Distant 'drabbad+e jordplugg+en/plugg+en'
    "Den är ovanför, förseglar kammaren. "  
;


//junction: Room 'Xibalb@\'a'
junction: Room 'Xibalb&aacute'
    "Femtio meter under regnskog, och ljudet av vatten är överallt: dessa djupa, eroderade kalkstengrottor sträcker sig som taprötter. En glidning nordost längs en bred kollapsad pelare av isbelagd sten leder tillbaka till Helgedomen, medan en slags dalgångsbotten sträcker sig uppför till norr och nedåt till söder, blektvit som hajtänder i det diffusa ljuset från natriumlampan ovan."
   northeast =  shrine   
   north = canyonN
   up asExit(north)
   south =  canyonS
   down asExit(south)
;

+ Surface, Fixture 'huvudhög avsats+en/hylla+n/kant+en'
  "Den är ungefär i huvudhöjd. "
;


++stela : Treasure 'sten stela/gräns+markör'
    "Ristningarna verkar varna för att gränsen till Xibalb&aacute, Skräckens Plats, är nära. Fågelglyfen är framträdande."
    initSpecialDesc = "En måttligt stor stela, eller gränssten, vilar på en avsats i huvudhöjd."
;

canyonN: Room 'Övre Änden av Dalgången' 'över änden av dalgången'
    "Den högre, bredare norra änden av dalgången stiger endast till en ojämn vägg av vulkanisk karst."
  south = junction
  down asExit(south)
;

+ hugeBall: TravelPushable 'enormt pimp+sten:en^s+klot+et' 'enorm pimpstensklot' 
    "Hela åtta fot i diameter, men ganska lätt."
    specialDesc =  "Ett enormt pimpstensklot vilar här, åtta fot brett."
    cannotTakeMsg = 'Det är mycket sten i en åtta fot stor sfär. '
    cannotMoveMsg = 'Det skulle inte vara så svårt att få det att rulla. '
    cannotTurnMsg = (cannotMoveMsg)
    canPushTravelVia(connector, dest)
    {
        return dest is in (canyonN, canyonS, junction);
    }
    explainNoPushTravelVia(connector, dest)
    {
        "Helgedomens ingång är långt mindre än åtta fot bred.";
    }
    describeMovePushable(traveler, connector)
    {
        if(connector != canyonS) {
            "Pimpstensklotet rullar in i <<getOutermostRoom.destName>>. ";
        }
    }
    beforeMovePushable(traveler, connector, dest) 
    { 
        if((getOutermostRoom == junction && dest == canyonN)
        || (getOutermostRoom == canyonS && dest == junction))
            "Du anstränger dig för att skjuta klotet uppför. ";
        else
            "Klotet är svårt att stoppa när det väl är i rörelse. ";
    }
;

canyonS: Room 'Nedre Änden av Dalgången'  'nedre änden av dalgången'
    desc()
    {
        if(hugeBall.isIn(nil)) {
             "Den södra änden av dalgången fortsätter nu ut på pimpstensklotet, som är kilat fast i avgrunden.";
        } else {
            "Vid den lägre och smalare södra änden slutar dalgången tvärt vid en avgrund av svindlande svärta. Inget kan ses eller höras från nedan.";
        }
    }  
    north = junction
    up asExit(south)
    south: OneWayRoomConnector -> onBall
    {    
        canTravelerPass(traveler) { return hugeBall.isIn(nil); }
        explainTravelBarrier(traveler) { "Ner i avgrunden?"; }
        isConnectorApparent (origin, actor) { return canTravelerPass(actor); }
    }
    down: NoTravelMessage {    
        dobjFor(TravelVia) { 
            action() { 
                replaceAction(Enter, chasm); 
            } 
        }
    }
;

+ chasm: Container, Fixture 'skräckinjagande bottenlös+a avgrund+en/svärta/grop+en' 'skräckinjagande avgrund'
    beforeAction()
    {
        if(gActionIs(Jump)) {
            replaceAction(Enter, self);
        }
    }
    dobjFor(Enter) {
        verify() {}
        action() {
            "Du störtar genom mörkrets tysta tomrum och krossar din skalle mot en klipputstickare. Mitt i smärtan och rödskimret skymtar du vagt Guden med Ugglehuvan...<.p>";
            finishGameMsg('DU HAR BLIVIT TILLFÅNGATAGEN', [finishOptionUndo]);
        }
    }
    afterAction() {
        if(hugeBall.isIn(getOutermostRoom))
        {
            hugeBall.moveInto(nil);
            "Pimpstensklotet rullar okontrollerat ner de sista metrarna av dalgången innan det skakar till i avgrundskäftarna, studsar tillbaka lite och träffar dig med en smäll på sidan av pannan. Du sjunker ihop, blödande, och... pimpstenen krymper, eller så växer din hand, för du verkar nu hålla den, stirrande på Alligator, son till Sju-Macaw, över bollplanen på Torget, huvudena av hans senaste motståndare spetsade på pålar, en församling som ropar efter ditt blod, och det finns inget annat att göra än att kasta ändå, och... men detta är bara nonsens, och du har en splittrande huvudvärk. ";
        }
    }
    cannotJumpOverMsg = 'Den är alldeles för bred. '
;

onBall: Room 'Pimpstensavsatsen' 'pimpstensavsatsen' 
    "En improviserad avsats bildad av pimpstensklotet, kilar fast på plats i avgrunden. Dalgången slutar ändå här."
    north = canyonS
    down asExit(north)
    up asExit(north)
;

+carvedBone: Treasure 'ristat/skuret ben+et' 
    "En hand som håller en pensel framträder ur käftarna på Itzamn@'a, skriftens uppfinnare, i hans ormform."
    initSpecialDesc = "Av alla offergåvor som kastats ner i avgrunden kommer kanske inget att återvinnas: inget förutom ett ristat ben, lättare än det ser ut, som sticker ut från en ficka av våt siltjord i dalgångsväggen."
;

+ Unimportant 'våt+a ficka av/silt+jord+en' 'siltjord'
;

stoneKey: Key 'sten+nyckel+n' ;

booklet: Consultable 'waldecks maya+ordbok+en/ordbok+en' 'Waldecks mayaordbok' @me
   "Sammanställd från de opålitliga litografierna av den legendariske berättaren och upptäcktsresanden <q>Greve</q> Jean Frederic Maximilien Waldeck (1766??-1875), innehåller denna guide det lilla som är känt om glyferna som används i den lokala forntida dialekten."

   correct = nil
   
   handleTopic(actor, topic, convType, path)
   {
      local toks = Tokenizer.tokenize(topic.getTopicText.toLower);
      local consultWords = toks.length;
      local w1 = getTokVal(toks[1]);
      if(consultWords > 1)
        local w2 = getTokVal(toks[2]);
      local glyph;
      if(consultWords == 1 && w1 not in ('glyf', 'glyfer'))
        glyph = w1;
      else if(consultWords == 2 && w1 == 'glyf')
        glyph = w2;
      else if(consultWords == 2 && w2 == 'glyf')
        glyph = w1;
      else
        return nil;
        
      switch(glyph)
      {
          case 'q1': "(Detta är en glyf du har memorerat!)\b
            Q1: <q>helig plats</q>.";
            break;
          case  'halvmåne': "Halvmåne: tros uttalas ~xibalbla~,
            men dess betydelse är okänd.";
            break;
          case 'pil': "Pil: <q>resa, bli</q>.";
            break;
          case 'döskalle': "Döskalle: <q>död, dödsdom; öde (inte nödvändigtvis dåligt)</q>.";
            break;
          case 'cirkel': "Cirkel: <q>Solen; också liv, livstid</q>.";
            break;
          case 'jaguar': "Jaguar: <q>herre</q>.";
            break;
          case 'apa': "Apa: <q>präst?</q>.";
            break;
          case 'fågel': if(correct) 
                    "Fågel: <q>död som en sten</q>.";
                  else
                    "Fågel: <q>rick, välbärgad?</q>";
                  break;
          default: 
            "Den glyfen är hittills oregistrerad. ";
      }
        
      return true;  
   }

   topicNotFound = "Försök med <q>slå upp <namn på glyf> i boken.</q> "
;

waldeck: Consultable 'waldecks maya+ordbok+en/ordbok+en' 'Waldecks mayaordbok' @me
   "Sammanställd från de opålitliga litografierna av den legendariske berättaren och upptäcktsresanden <q>Greve</q> Jean Frederic Maximilien Waldeck (1766??-1875), innehåller denna guide det lilla som är känt om glyferna som används i den lokala forntida dialekten."
   correct = nil
   isProperName = true
;

+ ConsultTopic 
  /*
   *  Match this ConsultTopic on a regular expression that matches either
   *  a single word, or 'glyph' plus one other word, or one other word
   *  plus 'glyph', irrespective of case.
   */
  '<NoCase>^<AlphaNum>+$|^glyf<Space>+<AlphaNum>+$|^<AlphaNum>+<Space>+glyf$'
  "Den glyfen är hittills oregistrerad. "
  
   /*
    * Lower the matchscore so that this ConsultTopic is not chosen before
    * any of the ConsultTopics that match specific glyphs.
    */
  matchScore = 50
  
  /*
   * Don't match this topic if the player typed either of the single
   * words 'glyph' or 'glyphs'; this is easier to deal with here than
   * by trying to complicate the regular expression.
   */
  isActive = gTopicText not in ('glyf', 'glyfer')
;

+ ConsultTopic @glyphQ1
  "(Detta är en glyf du har memorerat!)\bQ1: <q>helig plats</q>."
;

+ ConsultTopic @glyphCrescent
 "Halvmåne: tros uttalas ~xibalbla~, men dess betydelse är okänd."
;

+ ConsultTopic @glyphArrow
  "Pil: <q>resa, bli</q>."
;

+ ConsultTopic @glyphSkull
  "Döskalle: <q>död, dödsdom; öde (inte nödvändigtvis dåligt)</q>."
;

+ ConsultTopic @glyphCircle
  "Cirkel: <q>Solen; också liv, livstid</q>."
;

+ ConsultTopic @glyphJaguar
  "Jaguar: <q>herre</q>."
;

+ ConsultTopic @glyphMonkey
  "Apa: <q>präst?</q>."
;

+ ConsultTopic @glyphBird
  "Fågel: <q>rick, välbärgad?</q>"
;

++ AltTopic
  "Fågel: <q>död som en sten</q>."
  isActive = waldeck.correct
;


class Glyph: Topic '(glyf) (glyf)'
  initializeVocab()
  {
     inherited;
     cmdDict.addWord(self, vocabWords, &adjective);
  }
;

glyphQ1: Glyph 'q1';
glyphCrescent: Glyph 'halvmåne';
glyphArrow: Glyph 'pil';
glyphSkull: Glyph 'döskalle';
glyphCircle: Glyph 'cirkel';
glyphJaguar: Glyph 'jaguar';
glyphMonkey: Glyph 'apa';
glyphBird: Glyph 'fågel';


// HÄR
priest: Actor 'mumifierad kalenderlig präst+en' 
    "Han är uttorkad och hålls ihop endast av viljekraft. Även om hans första språk förmodligen är lokal maya, har du den märkliga känslan att han kommer att förstå ditt tal."
    
    actorHereDesc =  "Bakom stenhällen står en mumifierad präst och väntar, knappt vid liv i bästa fall, omöjligt ålderstigen."
    
    /* Indicate that he's male */
    isHim = true
    
    dobjFor(Attack)
    {
        action()
        {
            moveInto(nil);
            "Prästen torkar bort till damm tills inget återstår,
                 inte en fläkt eller ett ben. ";
        }
    }
    
    dobjFor(Kiss) asDobjFor(Attack)
    
    throwTargetHitWith(projectile, path)
    {
        projectile.moveInto(getHitFallDestination(projectile, path));
        replaceAction(Attack, self);
    }
;

 /* We can match on a list of game objects */

+ AskTopic [waldeck, booklet]
   "<q>Fågelglyfen... mycket roligt.<q>"
;

++ AltTopic
  "<q>En ordbok? Verkligen?<q>"
  isActive = gDobj.correct
;

/* Or on a list of topic objects */

+ AskTopic [tGlyph, tDialect]
 "<q>I vår kultur är Prästerna alltid läskunniga.</q> " 
;

/* Or on a regular expression */

+ AskTopic +110 '<NoCase>grav|helgedom|tempel' 
  "<q>Detta är en privat angelägenhet.</q>"
;

/* Or on a single topic object */

+ AskTopic @tRuins
  "<q>Ruinerna kommer alltid att besegra tjuvar. I underjorden torteras plundrare i all evighet.</q> En paus. <q>Liksom arkeologer.</q>"
;

+ AskTopic @tWormcast
  "<q>Ingen man kan passera Maskhålet.</q>"
;

+ AskTopic @tXibalba
  topicResponse()
  {
      "Prästen sträcker ut ett benigt finger sydväst mot istapparna, som försvinner som frost när han talar. <q>Xibalb&aacute, Underjorden.</q>";

      icicles.moveInto(nil);
  }
;

++ AltTopic
   "Prästen skakar på sitt beniga finger."
   isActive = icicles.isIn(nil)
;

+ AskTopic @paintings
   "Kalenderprästen rynkar pannan. <q>10 baktun, 4 katun, det blir 1 468 800 dagar sedan tidens början: i er kalender 19 januari 909.</q>";
;

+ DefaultAskTopic
   "<q>Du måste finna ditt eget svar.</q>";
;

+ DefaultTellTopic
  "Prästen har inget intresse av ditt smutsiga liv. "
;

+ GiveShowTopic [waldeck, booklet]
  topicResponse()
  {
     gDobj.correct = true;
     "Prästen läser lite i boken och skrattar på ett ihåligt, viskande sätt. Oförmögen att hålla tillbaka sin munterhet skrapar han in en korrigering någonstans innan han lämnar tillbaka boken. ";
  }
  isActive = !gDobj.correct
;

+ GiveShowTopic @newspaper
  "Han tittar på datumet. <q>12 baktun 16 katun 4 tun 1 uinal 12 kin</q>, förkunnar han innan han bläddrar på förstasidan. <q>Ah. Framsteg, ser jag.</q>";
;

+ DefaultGiveShowTopic
  "Prästen är inte intresserad av jordiska ting. "
;

+ DefaultAnyTopic
  "Prästen hostar och faller nästan sönder."
;

+ CommandTopic @TravelAction
  "<q>Jag får inte lämna Helgedomen.</q> "
;

+ DefaultCommandTopic
 "<q>Det är inte dina order jag tjänar.</q> "
;

tGlyph: Topic 'glyph/glyphs';
tDialect: Topic 'mayan dialect';
tRuins: Topic 'ruins';
tWormcast: Topic 'worm cast/web/wormcast';
tXibalba: Topic 'xibalba';

// ...


scuttlingClaws: Thing, EventList, InitObject
  'små smattrande smatter ljud+et/klor+na/saker/monster/varelse+r/insekt+er'
  'ljud av små klor'
  
  daemonID = nil
  
  /* 
   * Since this is an InitObject, the execute() method will be called at startup;
   * this will start the daemon going.
   */ 
  
  execute() {  daemonID = new Daemon(self, &daemon, 1); }
    
  /*  
   *  This daemon, run each turn, checks to see if the player character can see
   *  his present location. If he can't, then he must be in the dark, so if we
   *  aren't already in this location we move ourselves there and reset our
   *  curScriptState to run; we then call our doScript routine to call the next
   *  item in our eventList. If on the other hand the player character can see
   *  his present location, then he's in the light, so if we're not already in
   *  nil we move ourselves there.
   */ 
  daemon() 
  { 
    local loc = gPlayerChar.getOutermostRoom;
    if(!gPlayerChar.canSee(loc))
    {
      if(!isIn(loc))
      {
        moveInto(loc);
        curScriptState = 1;
      }
      doScript; 
    }
    else if(!isIn(nil))
    {
      moveInto(nil);
    }      
  }
  
  /* We want the claws to be in scope in the dark */ 
   
  brightness = 1   
  
  eventList = [
    'Någonstans smattrar små klor.',
    'Smattrandet kommer lite närmare, och din andning blir hög och hes.',
    'Skräcken svett rinner från din panna. Varelserna är nästan här!',
    'Du känner en kittling i dina extremiteter och sparkar utåt, skakande av något kitinöst. Bara deras ljud är ett hotfullt raspande.',
    new function {
        "Plötsligt känner du en liten smärta, av en hypodermisk-vass huggtand i din vad. Nästan omedelbart går dina lemmar i spasm, dina axlar och knäleder låser sig, din tunga svullnar...<.p>";
       
       finishGameMsg(ftDeath, [finishOptionUndo]);
    }     
  ]
  
  dobjFor(Examine) { verify() { illogical('Det är för mörkt att se källan till ljudet. ');}}
  
  dobjFor(Smell)  { action() { "Du kan bara känna lukten av din egen rädsla. ";  } }
  dobjFor(Taste) { check() { failCheck('Du skulle verkligen inte vilja det. '); } }
  dobjFor(Feel) asDobjFor(Taste)
  dobjFor(Attack) { action() { "De undviker lätt dina viftningar. "; } }
  dobjFor(ListenTo) { action() { "Så intelligenta de låter, för att vara bara insekter."; } }
  
  dobjFor(Default)
  {
    preCond = []
    verify() {}
    action() { "Varelserna undviker dig, smattrande. "; }
  }
  
  beforeAction()
  {
    if(gActionIs(ListenImplicit))
      replaceAction(ListenTo, self);
    if(gActionIs(SmellImplicit))
      replaceAction(Smell, self);
  }
   
;  

DefineTAction(Photograph);
VerbRule(Photograph)
    ('fotografera'|'fota') singleDobj
    : PhotographAction
    verbPhrase = 'fotografera/fotograferar (vad)'
    missingQ = 'vad vill du fotografera'
;


modify Thing
  dobjFor(Photograph)
  {
    preCond = [objVisible, new ObjectPreCondition(camera, objHeld)]
    verify() { }
    check() { 
       if(gPlayerChar.contents.length > 1)
         failCheck('Fotografering är en omständlig process som kräver användning av båda händerna. Du måste lägga ner allt annat.');       
    }
    action()
    {
        "Du ställer upp den elefantlika, storformats våtplåtskameran
                   <<sodiumLamp.isIn(getOutermostRoom)?', justerar natriumlampan':''>> och gör en tålmodig exponering av {the dobj/him}.";
    }
  }
;

modify npcMessages
  askUnknownWord(actor, txt) { "<q>Du talar i gåtor.</q> "; }
  wordIsUnknown(actor, txt) { askUnknownWord(actor, txt); }
  commandNotUnderstood(actor) { askUnknownWord(actor, ''); }    
;


modify playerMessages
   askUnknownWord(actor, txt) 
   { 
     local si = t3GetStackTrace().valWhich({x: x.obj_ && 
         x.obj_.ofKind(PendingCommandToks)});
     if(si != nil && getTokVal(si.self_.tokens_[1]).toLower == 'präst'
      && si.self_.tokens_.length > 1 && getTokVal(si.self_.tokens_[2]) == ',')
       npcMessages.askUnknownWord(actor,txt); 
     else    
       inherited(actor, txt);      
     
   }
;

modify libMessages
  showScoreRankMessage(msg) { "Detta ger dig rangen av <<msg>>. "; }
;
