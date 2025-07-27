#charset "utf-8"

/* 
 *   Include the main header for the standard TADS 3 adventure library.
 *   Note that this does NOT include the entire source code for the
 *   library; this merely includes some definitions for our use here.  The
 *   main library must be "linked" into the finished program by including
 *   the file "adv3.tl" in the list of modules specified when compiling.
 *   In TADS Workbench, simply include adv3.tl in the "Source Files"
 *   section of the project.
 *   
 *   Also include the SE Swedish definitions, since this game is written
 *   in Swedish.  
 */
#include <adv3.h>
#include <sv_se.h> 

#ifdef __DEBUG
#include "tests2.h"
#endif

/*
 *   Our game credits and version information.  This object isn't required
 *   by the system, but our GameInfo initialization above needs this for
 *   some of its information.
 *   
 *   You'll have to customize some of the text below, as marked: the name
 *   of your game, your byline, and so on.  
 */
versionInfo: GameID
    IFID = '10BC0B40-952C-4BF8-BA4F-F43A1E5661CA'
    name = 'RUINER'
    byline = 'av Angela M. Horns (aka Graham Nelson); portad till TADS
      3 av Eric Eve; översatt till svenska av Tomas Öberg'
    htmlByline = 'av <a href="mailto:tomaserikoberg@gmail.com">TOMAS ÖBERG</a>'
    version = '1.0'
    authorEmail = 'Tomas Öberg <tomaserikoberg@gmail.com>'
    desc = 'En TADS-portning av Informspelet Ruins från DM4.'
    htmlDesc = 'En TADS-portning av Informspelet Ruins från DM4.'
    showCredit()
    {
      "<i>Ruiner</i> (orig. Ruins) skrevs ursprungligen av Graham Nelson till
       <i>Inform Designer's Manual</i>. Denna översättning på den tidigare 
       portningen av Eric Eve har publicerats med bådas vänliga godkännande.\b
       ncDebugActions av Nikos Chantziaras (och ändrad lite av Eric Eve).\n
       cQuotes av Stephen Granade.\n
      TADS 3 språket och biblioteket adv3 skrevs av Michael J. Roberts. ";
    }
    
    showAbout()
    {
      "Detta är den översatta TADS 3-portningen av spelet <i>Ruins</i> som 
       ursprungligen skrevs av Graham Nelson till <i>Inform Designer's Manual</i>.
       Det försöker i huvudsak vara troget originalet på ett rimligt sätt, 
       med bara en eller två mindre förändringar.\b

       Det huvudsakliga syftet med själva portningen var att tillhandahålla
       ett prov av TADS 3-kod som kan jämföra sig med ett högst tillgängligt
       Inform-original, som i sig var designat att demonstrera en stor bredd av 
       programmeringsfunktionalitet. 
       
       Det huvudsakliga syftet med denna översättning av portningen är att visa 
       hur du enklast använder de svenskanpassningar som det svenska biblioteket 
       tillför till TADS 3.\n";
    }
;

/*
 *   The "gameMain" object lets us set the initial player character and
 *   control the game's startup procedure.  Every game must define this
 *   object.  For convenience, we inherit from the library's GameMainDef
 *   class, which defines suitable defaults for most of this object's
 *   required methods and properties.  
 *
 *   The properties and methods on this object correspond roughly to
 *   the work carried out in the Inform initialise routine.
 */
gameMain: GameMainDef
    /* the initial player character is 'me' */
    initialPlayerChar = me
    showIntro() {
        "Dagar av sökande, dagar av törstig kamp genom snåren i djungeln. Men till slut belönades ditt tålamod. En upptäckt!\b";
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
      <b>Ej grävde Alligatorn botten av den grop
        Som skulle bli hans grav,\n
        Utan han grävde sin egen grop\n
        för att söka skydd.\b
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
    
    /*
     *  This code sets up an about box that will be displayed when the
     *  player sets Help->About from the interpreter's menu.
     */
    
    setAboutBox()
    {
      "<ABOUTBOX><CENTER><b><<versionInfo.name>></b></CENTER>\b
       <CENTER><<versionInfo.byline>></CENTER>\b
       <CENTER>Version <<versionInfo.version>> 
       </CENTER></ABOUTBOX>";      
    }
;


/*
 *   Define the player character.  The name of this object is not
 *   important, but it MUST match the name we use to initialize
 *   gameMain.initialPlayerChar above.         
 */ 


me: Actor 'din min kropp+en' 'din kropp' @forest
  npcDesc = "Den ser rätt passiv ut. "
  isQualifiedName = true

  dobjFor(Photograph)
  {
    verify() { illogicalSelf('Bäst att låta bli. Du har inte rakat dig sen Mexico. '); }
  }

;

warthog: UntakeableActor 'lerig+a grymtande vårt|svin+et' 'vårtsvin' "Lerig och grymtande."
  pcDesc = "Lerig och grymtande -- och definitivt ett vårtsvin"
  actorHereDesc = "Ett vårtsvin sniffar och grymtar omkring i askan. "
  isProper = true
  actorAction()
  {  
    if(gActionIs(Eat))
      failCheck('Du har inte knäckt knepet med att sniffa upp mat än. ');
    if(!gActionIn(Look, Examine, Travel, Smell, Taste, Feel,
      LookIn, Search, Jump, Enter, TravelVia, System))
      failCheck('Vårtsvin kan inte göra något så invecklat. Om inte mörkerseendet och de förlorade kilona räddade dem, vore de sämre ställda än människan i allt.');

  }
;

class Unimportant: Decoration '-' 
   "<<notImportantMsg>>"
   notImportantMsg = '\^<<self.theName>> är inget du behöver referera till under spelets gång.'
; 
 

class Treasure: Thing 'skatt+en*skatter+na'
    culturalValue = 5
    photographedInSitu = nil
    
    dobjFor(Take)
    {
        check()
        {
            if(isIn(packingCase)) {
                failCheck('Det vore bäst att vänta med uppackandet av en sån obetalbar artefakt till dess att Carnegieinstitutionen kan göra det. ');
            }
            if(!photographedInSitu) {
                failCheck('Detta är 30-talet; inte den gamla dåliga tiden. Att ta en artefakt utan att redogöra dess kontext vore helt enkelt att plundra. ');
            }
        }
    }
    dobjFor(PutIn) 
    {
        action()
        {
            inherited;
            if (gIobj == packingCase) {
                addToScore(culturalValue, 'att packa ' + theName + ' i packväskan. ');
                if(libScore.totalScore == gameMain.maxScore) {
                    "Då du försiktigt packar undan {ref dobj/den} seglar en röd ara ner från trädtopparna, dess fjädrar tunga i det senaste regnet, ljudet av dess slagande vingar nästan öronbedövande, sten faller mot sten... 
                    När himlen klarnar stiger en halvmåne upp ovanför en fridfull djungel. Det är slutet på Mars 1938, och det är dags att åka hem.";

                    finishGameMsg(ftVictory, [finishOptionUndo, finishOptionFullScore]);
                }
                else {
                  "Säkert undanpacka{d/t/da dobj}.";
                }
            }
        }
    }
    dobjFor(Photograph) 
    {
        check()
        {
            if(moved)  {
                failCheck('Va, falsifiera den arkeologiska uppteckningen? ');
            }
            if(photographedInSitu) {
                failCheck('Inte igen. ');
            }
            inherited;
        }
        action() 
        {
            inherited;
            photographedInSitu = true;
        }
    }

;

//===============================================================

forest: OutdoorRoom '<q>STORA TORGET</q>' 'det stora torget'
  "Det är åtminstone vad dina anteckningar kallar denna låga kalkstensås, men nu har regnskogen återtagit den. Mörkt olivfärgad växtlighet tränger in från alla håll, luften är mättad av dimman efter ett nyligen passerat regn, knotten svävar stilla i regnets eftervärme. Struktur 10 är ett sönderfallet murverk, som kanske en gång utgjorde en gravpyramid. Litet finns kvar, annat än de stenhuggna trappstegen som leder ner i mörkret nedanför."

    up: NoTravelMessage {
        "Träden är taggbeväxta och du skulle skära upp dina händer fullständigt om du försökte klättra i dem. "
    }
    down = steps
    in asExit(down)

    cannotGoThatWayMsg = 'Regnskogen är tät, och du har inte huggit dig igenom den i flera dagar för att överge din upptäckt nu. Du behöver hitta några riktigt bra fynd att ta med tillbaka till civilisationen, innan du kan rättfärdiga att ge upp expeditionen. '
    roomBeforeAction()
    {
        if(gActionIs(Photograph)) {
         failCheck('I den här regnblöta skogen är det bäst att låta bli. ');            
        }
    }
;

+SimpleNoise 'djungel|ljud+et/macaw+en/papegoja+n/ara+n*papegojor+na macawer+na aror+na fladdermöss+en' 'djungelljud' 
    "Vrålapor, fladdermöss, papegojor, aror."
;

+ Unimportant 'mörk+a olivfärg+ade djungel+n/träd+en/växtlighet+en/limesten+en/regnskog+en/skog+en/knott+en' 'djungel'
;

+ mushroom: Food 'fläckig+a padd|svamp+en*padd|svampar+na' 'fläckiga svampar'
    "Svampen är täckt med fläckar, och du är inte ens säker på att det inte är en paddsvamp."
    theName = 'de fläckiga svamparna'
    isPlural = true
    initSpecialDesc = 'På en lång stjälk i den genomdränkta jorden växer en fläckig svamp.'
    dobjFor(Take) 
    {
     action()
     {
       if(!moved)
         "Du plockar svampen och klyver elegant dess tunna stjälk. ";
       inherited;
     }
   }
   
   dobjFor(Drop) 
   {
     action()
     {
        "Svampen faller till marken, något skadad. ";
        inherited;
     }
   }
   
   dobjFor(Eat)
   {
     action()
     {
        moveInto(nil);
        steps.isInInitState = nil;
        "Du gnager på ett hörn, oförmögen att förnimma den 
        skarpa smaken, distraherad av en röd aras flykt ovanför, som tycks explodera ur solen. Ljudet av dess slagande vingar är öronbedövande, som sten som faller mot sten.";
     }
   }
;

+ packingCase: Heavy, OpenableContainer 'pack|väska+n/pack|låda+n/pack+et' 
    initSpecialDesc =  "Din packväska ligger här, redo att fyllas med alla viktiga kulturella fynd du kan göra, för transport tillbaka till civilisationen."
    cannotTakeMsg = 'Väskan är för tung för att bemöda sig flytta runt på, så länge din expedition fortfarande är ofullständig. '
    initiallyOpen = true 
;

++ camera: Thing  'otymplig+a robust+a träinramad+e plåtaktig+a våtplåts|kamera+n/våtplåtsmodell+en/' 
  "En otymplig, robust, envis träinramad våtplåtsmodell: som alla arkeologer har du ett kärleks-hatförhållande till din kamera."

   dobjFor(Photograph)
   {
    verify() { illogicalSelf('Du kan inte använda kameran till att fotografera sig själv. '); }
   }
;

++ newspaper: Readable 'månad+s gammal gamla tidning+en/times' 'månad gammal tidning'
    "<q>The Times</q> från 26 februari 1938, på en gång fuktig och skör efter en månads exponering av klimatet, vilket är ungefär så som du själv känner dig. Kanske är det dimma i London. Kanske finns där bomber också."
;

+ steps: StairwayDown 'sten huggen huggna stenhuggen stenhuggna trappsteg+en/sten|stege+n/sten|trapp+en/tio/10/pyramid+en/begravningsplats+en/struktur+en/anläggning+en*trappsteg+en' 'stenhuggna trappsteg'
    "De spruckna och slitna trappstegen leder ner till en dunkel kammare. Dina fötter kanske  <<squareChamber.seen ? 'är de första att beträda'
        : 'har varit de första att ha beträtt'>> dem på femhundra år. På det översta trappsteget är glyfen Q1 inristad. "
    
    initDesc = "Rasmassorna blockerar vägen efter bara några steg."
    isPlural = true
    isInInitState = true
    canTravelerPass(traveler) { return !isInInitState; }
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

    burnDaemon()
    {
        inherited;
        switch(fuelLevel)
        {
            case 10:  "<.p>Natriumlampan blir svagare!"; 
            break;
            case  5:  "<.p>Natriumlampan kommer inte räcka till så länge till"; 
            break;
        }
    }
    sayBurnedOut { "<.p>Natriumlampan falnar och slocknar plötsligt.<.p>"; }

  /*
   *  We need to make the sodium lamp a TravelPushable to incorporate the
   *  handling for pushing around; normally this would disable the normal
   *  Take and Drop handling, since the adv3 library doesn't consider TravelPushables
   *  to be takeable. We therefore override the action methods of dobjFor(Take) and
   *  (Drop) to inherit the Take and Drop behaviour from Thing.
   */
  
    dobjFor(Take)
    {
        check()
        {
            if (isLit) {
                 failCheck('Glödlampan är för ömtålig och metallhandtaget för varmt för att lyfta lampan medan den är påslagen.');
            }
        }
        action()  { inherited Thing; }
    }

    dobjFor(Drop) { action() { inherited Thing; } }

    dobjFor(TurnOn)
    { 
        check()
        {
            if(!location.ofKind(BasicLocation) && !location.ofKind(Platform))
            {
                failCheck('Lampan måste placeras stabilt innan den tänds.');            
            }
        }
        action() {
            if(!gPlayerChar.canSee(gPlayerChar.getOutermostRoom())) {
              inherited;
              "Du famlar i mörkret och känner lampans metall. Du tänder den.";
              return;
            }
            inherited;
        }
    }
    dobjFor(TurnOff)
    { 
        check()
        {
            if(getOutermostRoom.brightness == 0) {
                failCheck('Bäst att låta bli -- du skulle bli helt utlämnad åt mörkret. ');
            }
        }
    }
    
  canPushTravelVia(connector, dest) { return connector != shrine.southwest; }
    explainNoPushTravelVia(connector, dest)
    {  
        "Det närmaste du kan göra är att skjuta natriumlampan fram till den yttersta kanten av Helgedomen, där grottans golv ger vika.";
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
    "Du skjuter in natriumlampan till <<getOutermostRoom.destName>>. ";
    
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

map: Readable 'över Quintana Roo skiss-karta+n/skiss:en+karta+n' 'skiss-karta över Quintana Roo' @me
    "Denna karta markerar inte mycket mer än den bäck som förde dig hit, från Mexikos sydöstra kant och in i den djupaste regnskogen, endast avbruten av denna höjdplatå.";
;

squareChamber: Room 'Fyrkantig Kammare' 'den fyrkantiga Kammaren'
    "En nedsänkt, dystert stenhuggen kammare, runt fem famnar bred. En solljusstråle skär in från trappstegen ovan och ger kammaren ett diffust ljus. I skuggorna dock leder dörröppningar, med låga överliggare, åt öster och söder in i templets djupare mörker."
 
    up = forest
    south = corridor
    east = wormcast
;


+ Unimportant 'östra södra låga överliggande *dörr+öppningar+na dörrar+na överliggar+na skuggor+na'
  isPlural = true
;

+ Fixture 
        'inristad+e rörlig+a krylla+nde mängd+er inskription+er/ristning+ar/märk+en/markering+ar/symbol+er/pil+en/cirkel+n*inskriptioner+na symboler+na'
        'inristade inskriptioner'
         "Varje gång du tittar noga på ristningarna verkar de vara stilla. Men du har en obehaglig känsla när du tittar bort att de kryper, rör sig omkring. Två glyfer är framträdande: Pil och Cirkel."

        initSpecialDesc = "Inristade inskriptioner trängs på väggarna, golvet och taket."
        isPlural = true
;

+ sunlight: Vaporous 'solbelyst+a ljus+a solens sol:en+ljusstråle+n/stråle/sol:en+ljus+et/luft+en/damm+korn+en/damm+et*strålar' "Dammkorn glimmar i strålen av solbelyst luft, så att den nästan verkar fast."
    dobjFor(Search) asDobjFor(Examine)
                
    notWithIntangibleMsg = 'Det är bara en immateriell solljusstråle.' 
    iobjFor(PutIn)
    {
        verify()
        {
            if(gDobj && gDobj == self)
                illogicalSelf('Du kan inte stoppa en solljusstråle i sig själv. ');
        }
        action()
        {
            if(gDobj==eggsac) {
                eggsac.moveInto(nil);
                stoneKey.moveInto(location);
                "Du släpper ner äggsäcken till solljusstrålens sken. Den bubblar obscent, sväller och brister sedan i hundratals små insekter som springer åt alla håll in i mörkret. Endast stänk av slem och en märklig gul stennyckeln återstår på kammarens golv.";
            } else {
                "Du håller {den dobj/honom} i skenet av ljusstrålen en liten stund. ";
            }
        }        
    }   
;

MultiLoc, Vaporous  'lågt låg+a virvlande dimma+n'
  "Dimman har en arom som påminner om tortilla."
  notWithIntangibleMsg = 'Dimman är för osubstansiell. '
  locationList = [forest, squareChamber]
;

+ SimpleOdor 'arom+en/lukt+en/odör+en/tortilla+n' 'odör'
  "<<location.desc()>>"
  disambigName = 'odör av tortilla'
;  

corridor: DarkRoom 'Den krökta korridoren' 'den krökta korridoren'
    "En låg, fyrkantigt huggen korridor som löper från norr till söder, och tvingar dig till stå framåtböjd."
    npcDesc = "En låg, fyrkantigt huggen korridor som löper från norr till söder"
    north = squareChamber
    south = stoneDoor
;
+stoneDoor: LockableWithKey, Door 'massiv+a stor+a gul+a sten+dörr+en' 'stendörr'
    "Det är bara en stor stendörr. "
    isInInitState = (!isOpen)
    initSpecialDesc = "Passagen blockeras av en massiv dörr av gul sten. "
    specialDesc =  "Den stora gula stendörren är öppen"
    keyList = [stoneKey]
;

+statuette: Treasure 'pygmé+statyett+en'
    "En hotfull, nästan karikatyrliknande statyett av en pygméande med en orm runt halsen."
    initSpecialDesc = "En dyrbar mayastatyett vilar här!"
;


shrine: DarkRoom 'Helgedomen' 'helgedomen' 
  "Denna magnifika Helgedom visar tecken på att ha urholkats från redan existerande kalkstensgrottor, särskilt i den västra av de två långa takfoten i söder."
    north = stoneDoorInside
    southeast = antechamber
   southwest: OneWayRoomConnector { -> junction
      canTravelerPass(traveler) { return !icicles.isIn(lexicalParent); }
      explainTravelBarrier(traveler)
      {
        "Takfoten smalnar av till en spricka som skulle slingra sig längre om den inte var tätt igensatt med istappar. Glyfen av halvmånen är inte helt dold av is.";
      }
    }
;

+ stoneDoorInside: Door ->stoneDoor 'massiv+a stor+a gul+a sten+dörr+en' 'stendörr'
    "Det är bara en stor stendörr. "
    isInInitState = (!isOpen)
    initSpecialDesc = "Passagen norrut blockeras av en massiv dörr av gul sten. "
    specialDesc =  "Den stora gula stendörren är öppen"
;

+ stoneTable: Heavy, Enterable, Surface 'stora stort sten+häll^s+altare+t/stenhäll+en/bord+et'
    initSpecialDesc =  "En stor stenhäll av ett bord, eller altare, dominerar Helgedomen."
;

++ mask: Wearable, Treasure 'mosaik jadeansikt:et^s+mask+en/jade|mosaik^s+ansikte^s+mask+en'
  "Så enastående den skulle se ut på museet."
  initSpecialDesc = "Vilande på altaret finns en jadeansiktsmask av mosaik."
  culturalValue = 10
  dobjFor(Wear)
  {
    action()
    {
        inherited;
        priest.moveIntoForTravel(shrine);
          if(gPlayerChar.isIn(shrine))
              "När du tittar genom obsidianögonspringorna i mosaikmasken, uppenbarar sig en spöklik närvaro: en mumifierad kalenderpräst, som står redo att höra ditt ord.";
        }
    }

    dobjFor(Doff)
    {
        action()
        {
            inherited;
            if(gActor.canSee(priest)) {
                "Då du tar av masken, försvinner den mumifierade kalenderprästen från ditt synfält. ";
            }
            priest.moveInto(nil);
        }
    }
;

+ icicles: Decoration 'istappar+na' 'istappar' "istappar täpper för sprickan som leder sydväst. "
  isPlural=true
;

+ Decoration 'halvmåne+formad+e glyf+en*glyfer';

+ paintings: Fixture 'målning+ar/herre+n/fånge+n' 'målningar' 
    "Köttet på kropparna är blodröda. Markeringarna för den Långa Räkningen daterar händelsen till 10 baktun 4 katun 0 tun 0 uinal 0 kin, den typ av årsdag då en Herre slutligen skulle halshugga en tillfångatagen rival som hade rituellt torterats under en period av några år, i den balkaniserade galenskapen i mayastadsstater."
    initSpecialDesc = "Livligt röriga målningar, där den bepansrade Härskaren trampar på en fånge, är nästan för bländande för ögat, ett slags graffiti från en organiserad pöbel."
    isPlural = true
;

wormcast: Room 'Maskgångar' 'maskgångarna' 
  "ett utgrävt nätverk av håligheter, som ett spindelnät av tomrum hängande i sten. De enda gångarna som är breda nog att krypa igenom börjar löpa norrut, söderut och uppåt."

   west = squareChamber
   northeast = burrowCrawl
   up = burrowCrawl
   south = burrowCrawl
   cannotGoThatWay()
   {
     if(gActor != warthog) {
        "Även om du börjar känna dig säker på att något ligger bakom maskgången, måste denna väg vara en djurgång i bästa fall: den är alldeles för trång för din fåtöljarkeologsformade mage.";
     } else {
        "maskgången blir hal runt din vårtsvinkropp, och du gnäller ofrivilligt när du gräver dig genom mörkret, och faller slutligen söderut till...<.p>";
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

+ eggsac: Thing 'glänsande vit+a ägg:et+säck+en' 'glänsande vit äggsäck'
    initSpecialDesc = "En glänsande vit äggsäck, som en klump grodrom stor som en strandboll, har fäst sig vid något i en spricka i en vägg."
    dobjFor(Take)
    {
        action()
        {
            inherited();
            "Åh herregud.";
        }
    }    
    beforeTravel(traveler, connector)
    {
        if(connector == squareChamber.up && self.isIn(traveler)) {
        "I samma ögonblick naturligt ljus skiner på äggsäcken börjar den att bubbla obscent och svälla. Innan du kan kasta bort den brister den ut i hundratals små, födelsehungriga insekter...";
        finishGameMsg(ftDeath, [finishOptionUndo]);
        }    
    }
;

burrowCrawl: TravelMessage
  travelDesc =
  "Maskgången blir hal runt dig, som om din kroppsvärme smälter den härdade kådan och, och du blundar medan du tunnlar tätt genom mörkret. "
  destination = (eggsac.isIn(gPlayerChar) ? squareChamber
    : rand(squareChamber, corridor, forest));

;

//=======================================================================

antechamber: DarkRoom 'Förkammaren' 'förkammaren'
    "De sydöstra takfoten i Helgedomen bildar en märklig förkammare."
    northwest = shrine
;

+ cage: Openable, Booth, Fixture 'gallrad+e järn|bur+en/gall:er+et/järn|ram+en/glyf+er' 'järnbur'
    "Glyferna lyder: Fågel Pil Vårtsvin. "
  roomDesc()
  {
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

++ skeletons : Fixture 'nedbrut:en+na gam:mal+la skelett+en/ben+en/döskallen/*döskall+ar'
   'nedbrutna skelett'
   "Bara gamla benrester. "
   isListedInContents = true
   isPlural = true
   afterAction()
   {
    if(me.isIn(cage)) {
        "Skeletten inuti buren vaknar till liv, griper sina beniga händer runt dig, krossar och slår. Du förlorar medvetandet, och när du återfår det har något groteskt och omöjligt inträffat...<.p>";
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

++ cageFloor: HiddenDoor 'öppen öppna+de jordgrop+en/grav|kammare+n/golv+et/hål+et' 'mark'
   "En öppen jordgrop skär ner till gravkammaren nedanför."
   destination = burialShaft
;

burialShaft: Room 'Gravschaktet' 'gravschaktet' 
    "I dina eventuella fältanteckningar kommer detta att stå: 
    <q>En gravkammare med konsolvalv och ett tilltäppt jordlock som försegling ovan, och målade figurer som förmodligen föreställer de nio Nattens Herrar. Utspridda ben verkar tillhöra en äldre man och flera barnoffer, medan andra gravfynd inkluderar jaguartassar.</q> (I fältanteckningar är det viktigt att aldrig ge minsta antydan om när du är skräckslagen.)"

    cannotGoThatWayMsg = 'Arkitekterna bakom denna kammare var mindre än generösa med att tillhandahålla utgångar. Något vårtsvin verkar ha grävt sig in från norr dock. '

    north = wormcast
    up: OneWayRoomConnector { -> cage
      canTravelerPass(traveler) { return traveler == me; }
      explainTravelBarrier(traveler) {
        "Med ett mäktigt vårtsvinshopp stångar du mot jordlocket som förseglar kammaren ovan,  vilket kollapsar din omgivelse med aska och jord. Något livlöst och fruktansvärt tungt faller ner ovanpå dig: du förlorar medvetandet, och när du återfår det har något omöjligt och groteskt hänt...<.p>";
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

+ honeycomb: Treasure, Food 'gammal forntida honung^s+kaka+n' 'forntida honungskaka'
    "Kanske någon form av gravoffergåva."
    initSpecialDesc = 
    "En utsökt bevarad, forntida honungskaka vilar här!"
    dobjFor(Eat)
    {
        action()
        {
            inherited;
            "Kanske den dyraste måltiden i ditt liv. Honungen smakar konstigt, kanske för att den användes för att förvara inälvorna från Herren som begravdes här, men fortfarande likt honung.";
        }
    }
;

+ plug: Distant 'drabbad+e jord|lock+et/jord|plugg+en'
    "Det är ovanför, förseglar kammaren. "  
;

junction: Room 'Xibalb&aacute' 'Xibalb&aacute'
    "Femtio meter under regnskog, och ljudet av vatten är överallt: dessa djupa, ugröpta kalkstengrottor sträcker sig som pål-rötter.  Ett hasande nordost, förbi en bred pelare av isbelagd sten, leder tillbaka till Helgedomen, medan ett slags kanjongolv sträcker sig uppför mot norr och nedåt mot söder, blekt vita som hajtänder i det diffusa skenet från natriumlampan ovanför."
   northeast =  shrine   
   north = canyonN
   up asExit(north)
   south =  canyonS
   down asExit(south)
;

+ Surface, Fixture 'huvudhög avsats+en/hylla+n/kant+en'
  "Den är ungefär i huvudhöjd. "
;

++ stela: Treasure 'sten stele+n/gräns|markör+en/gräns|sten+en'
    "Ristningarna verkar varna för att gränsen till Xibalb&aacute, Skräckens Plats, är nära. Fågelglyfen är framträdande."
    
    initSpecialDesc = "En måttligt stor stele, eller gränssten, vilar på en avsats i huvudhöjd."
;

canyonN: Room 'Övre Änden av Dalgången' 'den övre änden av dalgången'
    "Den högre, bredare norra änden av dalgången stiger endast till en ojämn vägg av vulkanisk karst."
  south = junction
  down asExit(south)
;

+ hugeBall: TravelPushable 'enormt pimp|sten:en^s+klot+et' 'enorm pimpstensklot' 
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

canyonS: Room 'Nedre Änden av Dalgången'  'den nedre änden av dalgången'
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

+ chasm: Container, Fixture 'skräckinjagande bottenlös+a avgrund+en/svärta+n/grop+en' 'skräckinjagande avgrund'
    beforeAction()
    {
        if(gActionIs(Jump)) {
            replaceAction(Enter, self);
        }
    }
    dobjFor(Enter) {
        verify() {}
        action() {
            "Du störtar genom mörkrets tysta tomrum och krossar din skalle mot en utskjutande klippa. Mitt i smärtan och det röda diset anar du svagt guden med ugglehuvudet.<.p>";
            finishGameMsg('DU HAR BLIVIT TILLFÅNGATAGEN', [finishOptionUndo]);
        }
    }

    afterAction()
    {
        if(hugeBall.isIn(getOutermostRoom))
        {
            hugeBall.moveInto(nil);
            "Pimpstensklotet rullar okontrollerat nerför de sista metrarna av dalgången innan det darrar till i käftarna på en klyfta, studsar tillbaka lite och träffar dig mot sidan av pannan. Du sjunker ihop, blödande, och... pimpstenen krymper, eller så växer din hand, för plötsligt verkar du hålla i den, stirrande på Alligator, son till Sju-Ara, tvärs över bollplanen på Plazan, med hans sista motståndares huvuden spetsade på pålar, och församlingen vrålar efter ditt blod, och det finns inget annat att göra än att kasta ändå, och... men allt det här är ju nonsens, och du har en sprängande huvudvärk.";
        }
    }

    cannotJumpOverMsg = 'Den är alldeles för bred. '
;

onBall: Room 'Pimpstensavsatsen' 'pimpstensavsatsen' 
    "En provisorisk avsats, bildad av pimpstensklotet, kilats fast i klyftan. Men ravinen tar ändå slut här."
    north = canyonS
    down asExit(north)
    up asExit(north)
;

+carvedBone: Treasure 'ristad+e ristat skur:et+na ben+et*ben+en' 
    "En hand som håller en pensel framträder ur käftarna på Itzamn@'a, skriftens uppfinnare, i hans ormform."
    initSpecialDesc = "Av alla de offergåvor som kastats ner i ravinen, är det kanske inget som någonsin kommer att återtas – inget, förutom ett ristat ben, lättare än det ser ut, som sticker fram ur en ficka av våt silt i ravinens vägg."
;

+ Unimportant 'våt+a ficka silt|jord+en' 'siltjord'
;

stoneKey: Key 'sten+nyckel+n' ;

//=======================================================================

 /*
  *  We'll show two versions of Waldeck's dictionary, since the TADS 3
  *  way of coding an object like this is very different from the Inform
  *  way.
  *
  *  We'll start with an implementation that's close to the Inform original.
  *  We'll call it 'booklet' to distinguish it from the second version that
  *  we'll actually use in the game. If you compile the game for debugging
  *  you can try PURLOIN BOOKLET and test that it works. It's more concise
  *  than the second version, but also more complex.
  */


/*
booklet: Consultable 'waldecks maya+ordbok+en/ordbok+en' 'Waldecks mayaordbok'
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
*/


 /*
  *  This is how Waldeck's dictionary would normally be implemented in
  *  TADS 3, using a series of simple objects rather than one complex
  *  object; note that the code is almost entirely declarative, without
  *  a single switch statement, if statement, or indeed any procedural
  *  code at all.
  *
  *  Note that we can't call this object 'dictionary', since dictionary
  *  is a reserved word in TADS 3
  */

waldeck: Consultable 'waldecks maya|ordbok+en' 'Waldecks mayaordbok' @me
   "Sammanställd från de opålitliga litografierna av den legendariske berättaren och upptäcktsresanden <q>Greve</q> Jean Frederic Maximilien Waldeck (1766??-1875), innehåller denna guide det lilla som är känt om glyferna som används i den lokala forntida dialekten."
   correct = nil
   isProperName = true
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


  /*
   *  We want the unrecognized glyph message to appear if what the player
   *  typed was either a single word, or two words one of which is 'glyph',
   *  but not any of the recognized glyph.
   */

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


  /* This contains the message that will be displayed if all else fails */
  
+ DefaultConsultTopic
  "Försök med <q>slå upp <namn på glyf> i boken.</q> "
;

 /*
  * We define a special Glyph class as a type of Topic that will
  * match 'foo', 'glyph foo' or 'foo glyph' but not just 'glyph'.
  * To do that we need 'glyph' to be a weak token as both noun and
  * adjective, and each time we define a Glyph we want its vocabWords
  * treated as an adjective as well as a noun.
  */

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


//======================================================================

 /* 
  * Having illustrated two ways of implementing the dictionary, we'll 
  * stick with the TADS 3 way of implementing the priest.
  */

priest: Actor 'mumifierad+e kalenderlig+a präst+en' 
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

+ AskTopic [waldeck]
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
  "<q>Ruinerna kommer föralltid att besegra tjuvar. I underjorden torteras plundrare i all evighet.</q> En paus. <q>Likadant arkeologer.</q>"
;

+ AskTopic @tWormcast
  "<q>Ingen man kan passera Maskgången.</q>"
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

+ GiveShowTopic [waldeck]
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


 /*
  *  TADS 3 has no equivalent of a location called thedark, so the scuttling
  *  claws will have to be coded in a very different way. We start by overrriding
  *  Room to customise the description of a dark room; and while we're at it
  *  we'll make another modification to room to as '(as Warthog)' to the room
  *  name while the player is a warthog.
  */

//========================================================================

modify Room
    roomDarkDesc = "Århundradenas mörker trycker mot dig, och du känner dig klaustrofobisk."

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


scuttlingClaws: Decoration, EventList, InitObject
  'små klapp:er+ret klapprande smattrande smatter ljud+et/monst:er+ret*klor+na monstren+a saker+na varelser+na insekter+na'
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
    'Någonstans hörs ett klapprande av små klor.',

    'Klapprandet kommer närmare, och din andhämtning blir tung och rosslig.',    

    'Skräckens svett rinner nerför din panna. Varelserna är nästan här!',

    'Du känner ett kittlande vid händer och fötter och sparkar till – något kitinartat far av. Bara ljudet av dem är ett hotfullt skrapande.', 

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
    action() { "Varelserna undviker dig, klapprande. "; }
  }
  
  beforeAction()
  {
    if(gActionIs(ListenImplicit))
      replaceAction(ListenTo, self);
    if(gActionIs(SmellImplicit))
      replaceAction(Smell, self);
  }
   
;  

 /*
  *  Define the grammar and handling for the Photograph action.
  */
  
DefineTAction(Photograph)
;

VerbRule(Photograph)
    ('fotografera'|'fota') singleDobj
    |'ta' ('bild'|'foto') ('av'|'på') singleDobj
    : PhotographAction
    verbPhrase = 'fotografera/fotograferar (vad)'
    missingQ = 'vad vill du fotografera'
;

 /*
  *  Define the grammar and handling implicitly "climbing (walking) the stairs" in swedish.
  */
VerbRule(ClimbUpDirection)
    'klättra' singleDir
    : TravelAction
    verbPhrase = ('klättra/klättrar ' + dirMatch.dir.name)
    askDobjResponseProd = singleNoun
;

VerbRule(DropAsPutIn)
    'släpp' dobjList ('i'|'inuti') singleIobj
    : PutInAction
    verbPhrase = 'sätta/sätter (vad) (in i vad)'
    askIobjResponseProd = inSingleNoun
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
        "Du ställer upp den elefantlika storformatskameran med våtplåt<<sodiumLamp.isIn(getOutermostRoom)?', justerar natriumlampan':''>> och gör en tålmodig exponering av {den dobj/honom}.";
    }
  }

;

/*  Change some default messages. */

modify npcMessages
  askUnknownWord(actor, txt) { "<q>Du talar i gåtor.</q> "; }
  wordIsUnknown(actor, txt) { askUnknownWord(actor, txt); }
  commandNotUnderstood(actor) { askUnknownWord(actor, ''); }

;

/* 
 *  This is a kludge to redirect the askUnknownWord message to
 *  npcMessages when the command line begins with "priest, "
 */

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

#ifdef __DEBUG
/*
 * Test: walkthrough variant #1
 */

Test 'spel' [
  'ta allt', 'ät svamp', 'ner', 'läs inskriptioner', 'x solljus',  'öst', 'ta äggsäck', 'väst', 'sätt äggsäcken i solljuset', 'ta nyckel', 'söder', 'släpp lampa', 'tänd den', 'släpp allt förutom kamera', 'fotografera statyett', 'ta allt', 'lås upp dörr med nyckel', 'knuffa lampan söderut', 'släpp allt förutom kamera', 'fotografera mask', 'ta allt', 'ta på dig masken', 'fråga om xibalba', 'sv', 'upp', 'tryck klotet nedåt', 'ner', 'norr', 'tryck klot s', 's', 'släpp allt förutom kamera', 'fotografera ben', 'ta allt', 'upp', 'norr', 'släpp allt förutom kamera', 'fotografera stelen', 'ta allt', 'nö', 'knuffa lampan sö', 'kliv in i buren', 'nv', 'n', 'n', 'ö', 'n', 'upp', 'fotografera honungskaka', 'ta allt', 'upp', 'kliv ut', 'tryck lampan nv', 'tryck lampan n', 'tryck lampan n', 'tryck lampan upp', 'lägg alla skatter i lådan'
];

/*
 * Test: walkthrough variant #2
 */
Test 'spel2' [
  'plocka upp allt', 'förtär svampen', 'klättra neråt', 'tyd inskriptionerna', 'granska solljuset', 'gå österut', 'hämta äggsäcken', 'västerut', 'placera äggsäcken i solljuset', 'plocka upp nyckeln', 'vandra söderut', 'ställ ner lampan', 'tänd den', 'lämna allt utom kameran', 'ta bild av statyetten', 'ta allt', 'lås upp dörren med nyckeln', 'skjut lampan åt söder', 'lämna allt förutom kameran', 'ta bild av masken',
  'ta allt', 'sätt på dig masken', 'fråga om Xibalba', 'gå sydväst', 'klättra upp', 'pressa klotet nedåt', 'klättra ner', 'vandra norrut', 'tryck klotet åt söder', 'gå söderut', 'lämna allt utom kameran', 'ta foto av benen', 'ta allting', 'upp', 'gå norrut', 'lämna allt utom kameran', 'ta foto av stelen', 'plocka upp allting', 'gå nordost', 'putta lampan sydösterut', 'stig in i buren', 'gå nordväst', 'gå norrut', 'fortsätt norrut', 'gå österut', 'gå norrut', 'klättra uppåt', 'fotografera honungskakan', 'ta allting', 'klättra uppåt', 'kliv ut ur buren', 'skjut lampan nordväst', 'skjut lampan norrut', 'skjut lampan norrut', 'skjut lampan uppåt', 'stoppa alla skatterna i lådan'
];

#endif
