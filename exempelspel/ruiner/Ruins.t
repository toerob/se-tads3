#charset "us-ascii"

/* 
 *   Include the main header for the standard TADS 3 adventure library.
 *   Note that this does NOT include the entire source code for the
 *   library; this merely includes some definitions for our use here.  The
 *   main library must be "linked" into the finished program by including
 *   the file "adv3.tl" in the list of modules specified when compiling.
 *   In TADS Workbench, simply include adv3.tl in the "Source Files"
 *   section of the project.
 *   
 *   Also include the US English definitions, since this game is written
 *   in English.  
 */
#include <adv3.h>
#include <en_us.h>

/*
 *   Our game credits and version information.  This object isn't required
 *   by the system, but our GameInfo initialization above needs this for
 *   some of its information.
 *   
 *   You'll have to customize some of the text below, as marked: the name
 *   of your game, your byline, and so on.  
 */
versionInfo: GameID
    name = 'Ruins'
    byline = 'by Angela M. Horns (aka Graham Nelson); ported to TADS
      3 by Eric Eve'
    htmlByline = 'by <a href="mailto:eric.eve@ukf.net">
                  ERIC EVE</a>'
    version = '1.0'
    authorEmail = 'ERIC EVE <eric.eve@ukf.net>'
    desc = 'A TADS port of the Inform Ruins game from the DM4.'
    htmlDesc = 'A TADS port of the Inform Ruins game from the DM4.'
    
    showCredit()
    {
      "<i>Ruins</i> was originally written by Graham Nelson for the
       <i>Inform Designer's Manual</i>. This port is published with
       his kind permission.\b
       ncDebugActions by Nikos Chantziaras (and tweaked a bit by Eric Eve).\n
       cQuotes by Stephen Granade.\n
       The TADS 3 language and adv3 library were written by Michael
       J. Roberts. ";
    }
    
    showAbout()
    {
      "This is TADS 3 port of the <i>Ruins</i> game originally written 
       by Graham Nelson for the <i>Inform Designer's Manual</i>. It tries
       in the main to be reasonably faithful to the original, with just
       one or two minor tweaks.\b
       The main purpose of this port is to provide a sample of TADS 3 code
       that can be compared with a widely-available Inform original, which
       was itself designed to demonstrate a wide range of programming features. ";
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
    showIntro()
    {
       "Days of searching, days of thirsty hacking through the briars
       of the forest, but at last your patience was rewarded. A discovery!\b";  
    }
    newGame()
    {
      titlePage();
      inherited();
    }
    maxScore = 30
    scoreRankTable = [
      [0, 'Tourist'],
      [5, 'Explorer'],
      [10, 'Curiosity-seeker'],
      [25, 'Archaeologist'],
      [30, 'Director of the Carnegie Institute']      
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
      <b>But Alligator was not digging the bottom of the hole\n
      Which was to be his grave,\n
      But rather he was digging his own hole\n
      As a shelter for himself.\b     
      --- <i>from the Popol Vuh</i>\b</b>      
      </FONT></TD></TR>
      <TR></TR>
      <TR><TD ALIGN=CENTER>
      <FONT FACE='TADS-TYPEWRITER'> 
      [Please press SPACE to begin]</FONT>
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
 
 
me: Actor 'your my body' 'your body'
  npcDesc = "It looks rather inert. "
  location = forest
  isQualifiedName = true
  
  dobjFor(Photograph)
  {
    verify() { illogicalSelf('Best not. You haven\'t shaved since Mexico. '); }
  }
  
; 

warthog: UntakeableActor 'wart hog/warthog' 'Warthog'
  "Muddy and grunting. "
  pcDesc = "Muddy and grunting -- and definitely a warthog. "
  actorHereDesc = "A warthog snuffles and grunts about in the ashes. "
  isProper = true
  actorAction()
  {
    #ifdef __DEBUG
      if(gActionIn(Snarf, Zarvo, Pow))
        return;
    #endif
  
    if(gActionIs(Eat))
      failCheck('You haven\'t the knack of snuffling up to food yet. ');
    if(!gActionIn(Look, Examine, Travel, Smell, Taste, Feel,
      LookIn, Search, Jump, Enter, TravelVia, System))
      failCheck('Warthogs can\'t do anything so involved. If it weren\'t
         for the nocturnal eyesight and the lost weight, they\'d be
         worse off all round than people. ');
      
  }
;

class Unimportant: Decoration '-' 'that'
   "<<notImportantMsg>>"
   notImportantMsg = (isPlural? 'You don\'t' : 'That\'s not something you') +
    ' need to refer to ' + (isPlural ? 'those ' :'' )+ 'in the course of this game. '  
; 
 
 
class Treasure: Thing
  culturalValue = 5
  photographedInSitu = nil
  
  dobjFor(Take)
  {
    check()
    {
        if(isIn(packingCase))
         failCheck('Unpacking such a priceless artefact had best wait
           until the Carnegie Institution can do it. ');
        if(!photographedInSitu)
          failCheck('This is the 1930s, not the bad old days. Taking an
           artefact without recording its context is simply
           looting. ');
    } 
  }
  
  dobjFor(PutIn)
  {
    action()
    {
        inherited;
        if(gIobj == packingCase) {
          addToScore(culturalValue, 'packing ' + theName + ' in the case. ');
          if(libScore.totalScore == gameMain.maxScore)
          {
            "As you carefully pack away {the dobj/him}
             a red-tailed macaw flutters down from the tree-tops
             feathers heavy in the recent rain, the sound of its
             beating wings almost deafening, stone falling against
             stone... As the skies clear, a crescent moon rises above
             a peaceful jungle. It is the end of March, 1938, and it
             is time to go home. ";
             
             finishGameMsg(ftVictory, [finishOptionUndo, finishOptionFullScore]);
          }
          else
            "Safely packed away. ";
        }
    }
  }
  
  dobjFor(Photograph)
  {
     check()
     {
        if(moved)
          failCheck('What, and fake the archaeological record? ');
        if(photographedInSitu)
          failCheck('Not again. ');
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
 
forest: OutdoorRoom '<q>Great Plaza</q>' 'the forest'
    "Or so your notes call this low escarpment of limestone,
    but the rainforest has claimed it back. Dark olive
    trees crowd in on all sides, the air streams with the
    mist of a warm recent rain, midges hang in the air. 
    <q>Structure 10</q> is a shambles of masonry which might
    once have been a burial pyramid, and little survives
    except stone-cut steps leading down into darkness below. "
    
    up: NoTravelMessage { "The trees are spiny and you'd cut your hands 
         to ribbons trying to climb them." } 
   
    down = steps
    in asExit(down)
   
    cannotGoThatWayMsg = 'The rainforest is dense, and you haven\'t hacked
     through it for days to abandon your discovery now. Really,
     you need a good few artifacts to take back to civilization
     before you can justify giving up the expedition. '
     
    roomBeforeAction()
    {
        if(gActionIs(Photograph))
         failCheck('In this rain-soaked forest, best not. ');
    }
;

+ SimpleNoise 'sounds/bats/macaw/parrots/monkeys' 'sounds'
   "Howler monkeys, bats, parrots, macaw. "
   isPlural = true
;

+ Unimportant 'dark olive limestone/trees/rainforest/forest/midges'
;

+ mushroom: Food 'speckled mushroom/fungus/toadstool' 'speckled mushroom'
   "The mushroom is capped with blotches, and you aren't
    at all sure it's not a toadstool. "
   initSpecialDesc =  "A speckled mushroom grows out of the sodden earth,
       on a long stalk. "
   
   dobjFor(Take)
   {
     action()
     {
       if(!moved)
         "You pick the mushroom, neatly cleaving its thin stalk. ";
       inherited;
     }
   }
   
   dobjFor(Drop)
   {
     action()
     {
        "The mushroom drops to the ground, battered slightly. ";
        inherited;
     }
   }
   
   dobjFor(Eat)
   {
     action()
     {
        moveInto(nil);
        steps.isInInitState = nil;
        "You nibble at one corner, unable to trace the source of an
        acrid taste, distracted by the flight of a macaw overhead
        which seems to burst out of the sun, the sound of the beating
        of its wings deafening, stone falling against stone. ";
     }
   }
;

+ packingCase: OpenableContainer, CustomImmovable
  'packing case/box/strongbox' 'packing case'
  
  initSpecialDesc = "Your packing case rests here, ready to hold any 
   important cultural finds you might make, for shipping back to civilization."
  cannotTakeMsg = 'The case is too heavy to bother moving, as long as 
    your expedition is still incomplete. '
  initiallyOpen = true 
;

++ camera: Thing 'wet-plate wet plate cumbersome sturdy wooden-framed
   wooden framed wood camera/model' 'wet-plate camera'
   "A cumbersome, sturdy, stubborn wooden-framed wet plate
    model: like all archaelogists you have a love-hate relationship
    with your camera. "  
   dobjFor(Photograph)
   {
    verify() { illogicalSelf('You can\'t use the camera to photograph itself. '); }
   }
;

++ newspaper: Readable 'month-old old paper/newspaper/times' 
   'month-old newspaper'
    "<q>The Times</q> for 26 February, 1938, at once damp and brittle
     after a month's exposure to the climate, which is much the
     way you feel yourself. Perhaps there is fog in London.
     Perhaps there are bombs. "
;

+ steps: StairwayDown 'stone stone-cut ten 10 burial steps/pyramid/structure'
   'stone-cut steps'
    "The cracked and worn steps descend into a dim chamber. Yours might 
      <<squareChamber.seen ? 'have been the first feet to have trodden'
        : 'be the first feet to tread'>> them for five hundred years. 
        On the top step is inscribed the glyph Q1. "
   initDesc = "Rubble blocks the way after only a few steps. "
   isInInitState = true
   canTravelerPass(traveler) { return !isInInitState; }
   explainTravelBarrier(traveler) { initDesc; }
   destination = squareChamber
   dobjFor(Enter) remapTo(TravelVia, self)
;

sodiumLamp: Flashlight, FueledLightSource, TravelPushable 
  'heavy heavy-duty sodium lamp'  'sodium lamp' @me
  "It's a heavy-duty archaeologist's lamp, << isLit ? (fuelLevel < 10
   ? 'glowing a dim yellow' : 'blazing with a brilliant yellow light')
   : 'currently off'>>. "
  fuelLevel = 100
  
  burnDaemon()
  {
    inherited;
    switch(fuelLevel)
    {
      case 10: "<.p>The sodium lamp is getting dimmer!<.p>"; break;
      case 5: "<.p>The sodium lamp can't last much longer.<.p>"; break;
    }  
  }
  
  sayBurnedOut() { "<.p>The sodium lamp fades and suddenly dies.<.p>"; }
  
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
        if(isLit)
         failCheck('The bulb\'s too delicate and the handle\'s too hot to lift
           the lamp while it\'s switched on. ');
     }
     action()  { inherited Thing; }
  }
  
  dobjFor(Drop) { action() { inherited Thing; } }
  
  dobjFor(TurnOn)
  {
     check()
     {
        if(!location.ofKind(BasicLocation) && !location.ofKind(Platform))
         failCheck('The lamp must be securely placed before being 
           switched on. ');
     }
  }
  
  dobjFor(TurnOff)
  {
    check()
    {
      if(getOutermostRoom.brightness == 0)
        failCheck('Better not -- you\'d be left totally in the dark. ');
    }
  }
  
  canPushTravelVia(connector, dest) { return connector != shrine.southwest; }
  explainNoPushTravelVia(connector, dest) 
    {  
        "The nearest you can do is to push the sodium lamp to
        the very lip of the Shrine, where the cave floor falls away.";
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
  initSpecialDesc = "The sodium lamp squats heavily on the ground. "
  specialDesc = "The sodium lamp squats on the ground, burning away. "  
  useSpecialDesc { return location.ofKind(BasicLocation); }
;

dummyLight: SecretFixture
;

map: Readable 'sketch quintana map/roo/sketch-map'
  'sketch-map of Quintana Roo' @me
  "This map marks little more than the creek which brought you
   here, off the south-east edge of Mexico, and into deepest
   rainforest, broken only by this raised plateau."
;

squareChamber: Room 'Square Chamber' 'the square chamber'
  "A sunken, gloomy stone chamber, ten yards across. A shaft
   of sunlight cuts in from the steps above, giving the chamber
   a diffuse light, but in the shadows low lintelled doorways
   lead east and south into the deeper darkness of the Temple. "
 
  up = forest
  south = corridor
  east = wormcast  
;


+ Unimportant 'east south low lintelled doorways/lintels/shadows'
  isPlural = true
;

+ Fixture 'carved moving scuttling carvings/marks/markings/symbols/
  crowd/glyphs/inscriptions' 'carved inscriptions'
  "Each time you look at the carvings closely, they seem to be
  still. But you have the uneasy feeling when you look away
  that they're scuttling, moving about. Two glyphs are
  prominent: Arrow and Circle."
  
  initSpecialDesc =  "Carved inscriptions crowd the walls, floor and ceiling. "
  isPlural = true
;

+ Vaporous 'sun sun\'s sunlit shaft/light/beam/sunlight/sunbeam/ray/rays/
   air/motes/dust' 'shaft of light'
   "Motes of dust glimmer in the shaft of sunlit air, to
   that it seems almost solid. "  
   
  notWithIntangibleMsg = 'It\'s only an insubstantial shaft of sunlight' 
  iobjFor(PutIn)
  {
    verify()
    {
        if(gDobj && gDobj == self)
         illogicalSelf('You can\'t put the shaft of sunlight in itself. ');
    }
    action()
    {
        if(gDobj==eggsac) {
            eggsac.moveInto(nil);
            stoneKey.moveInto(location);
            "You drop the eggsac into the glare of the shaft of 
           sunlight. It bubbles obscenely, distends and then
           bursts into a hundred tiny insects which run in all
           directions into the darkness. Only spatters of slime
           and a curious yellow-stone key remain on the chamber
           floor."; 
        }
        else
          "You hold {the dobj/him} in the shaft of sunlight for
           a few moments. ";
    }        
  }   
;

MultiLoc, Vaporous  'low swirling mist' 'low mist'
  "The mist has an odour reminiscent of tortilla. "
  notWithIntangibleMsg = 'The mist is too insubstantial. '
  locationList = [forest, squareChamber]
;

+ SimpleOdor 'odour/odor/tortilla' 'odour'
  "<<location.desc()>>"
  disambigName = 'odour of tortilla'
;  
   
corridor: DarkRoom 'Stooped Corridor' 'the stooped corridor'
   "A low, square-cut corridor, running north to south,
     stooping you over. "
  north = squareChamber
  south = stoneDoor
;

+ stoneDoor: LockableWithKey, Door 'stone door' 'stone door'
  "It's just a big stone door. "
  isInInitState = (!isOpen)
  initSpecialDesc = "The passage is barred by a massive
    door of yellow stone."
  specialDesc =  "The great yellow stone door is open."
  keyList = [stoneKey]
;

+ statuette: Treasure 'precious mayan pigmy spirit/snake/statuette'
  'pygmy statuette'
   "A menacing, almost cartoon-like statuette of a pygmy spirit
    with a snake around its neck! "
   initSpecialDesc = "A precious Mayan statuette rests here! "
;


shrine: DarkRoom 'Shrine' 'the shrine'
  "This magnificent Shrine shows signs of being hollowed out
   from already-existing limestone caves, especially in the
   western of the two long eaves to the south. "
   north = stoneDoorInside
   southeast = antechamber
   southwest: OneWayRoomConnector { -> junction
      canTravelerPass(traveler) { return !icicles.isIn(lexicalParent); }
      explainTravelBarrier(traveler)
      {
       "The eaves taper out into a crevice which would wind
       further if it wasn't jammed tight with icicles. The glyph
       of the Crescent is not quite obscured by ice. ";
      }      
   }
;

+ stoneDoorInside: Door ->stoneDoor 'stone door' 'stone door'
   "It's just a big stone door. "
   isInInitState = (!isOpen)
   initSpecialDesc = "The exit to the north is barred by a massive
    door of yellow stone."
   specialDesc =  "The great yellow stone door is open."

;

+ stoneTable: Platform, Fixture 'stone great slab/altar/table' 'slab altar'
   initSpecialDesc = "A great stone slab of a table, or altar, dominates
     the shrine. "
;

++ mask: Wearable, Treasure 'jade mosaic face mask/face-mask' 'jade mosaic face-mask'
  "How exquisite it would look in a museum. "
  initSpecialDesc = "Resting on the altar is a jade mosaic face-mask. "
  culturalValue = 10
  dobjFor(Wear)
  {
    action()
    {
        inherited;
        priest.moveIntoForTravel(shrine);
        if(gPlayerChar.isIn(shrine))
          "Looking through the obsidian eyeslits of the
         mosaic mask, a ghostly presence reveals itself:
         a mummified calendrical priest, attending your word.";
    }
  }
  
  dobjFor(Doff)
  {
    action()
    {
        inherited;
        if(gActor.canSee(priest))
          "As you remove the mask, the ancient calendrical priest 
           vanishes from sight. ";
        priest.moveInto(nil);
    }
  }
          
;

+ icicles: Decoration 'icicles' 'icicles'
  "Icicles jam the crevice that leads to the southwest. "
;

+ Decoration 'crescent glyph' 'crescent glyph'
;

+ paintings: Decoration 'painting/paintings/lord/captive' 'paintings'
   "The flesh on the bodies is blood-red. The markers
    of the Long Count date the event to 10 baktun 4 katun 0 tun
    0 uinal 0 kin, the sort of anniversary when one Lord would 
    finally decapitate a captured rival who had been ritually
    tortured over a period of some years, in the Balkanised
    insanity of the Maya city states. "
   initSpecialDesc = "Vividly busy paintings, of the armoured lord trampling
    on a captive, are almost too bright to look at, the graffiti
    of an organized mob. " 
 
  isPlural = true
;

wormcast: Room 'Wormcast' 'the wormcast'
  "A disturbed place of hollows carved like a spider's web,
   strands of empty space hanging in stone. The only burrows
   wide enough to crawl through begin by running northeast,
   south and upwards. "
   west = squareChamber
   northeast = burrowCrawl
   up = burrowCrawl
   south = burrowCrawl
   cannotGoThatWay()
   {
     if(gActor != warthog)
       "Though you begin to feel certain that something lies 
        behind the wormcast, this way must be an animal-run at
        best: it's far too narrow for your armchair-archaeologist's
        paunch. ";  
     else 
     {
        "The wormcast becomes slippery around your warthog body,
         and you squeal involuntarily as you burrow through the
         darkness, falling finally southwards to...<.p>";  
         nestedAction(TravelVia, burialShaft);
     }     
   }
   
   roomAfterAction
   {
     if(gActionIs(Drop)) {
        gDobj.moveInto(squareChamber);
        "{The dobj/he} slips through one of the burrows
           and is quickly lost from sight. ";
     }
   }
;

+ eggsac: Thing 'glistening white egg eggsac/sac' 'glistening white eggsac'
  "It's like a clump of frogspawn the size of a beach ball. "
  initSpecialDesc = "A glistening white eggsac, like a clump of frogspawn
   the size of a beach ball, has adhered itself to something
   in a crevice in one wall. "
  
  dobjFor(Take)
  {
   action()
   {
     inherited;
     "Oh my! ";
   }
  }
  
  beforeTravel(traveler, connector)
  {
    if(connector == squareChamber.up && self.isIn(traveler)) {
       "The moment natural light falls upon the eggsac,
       it bubbles obscenely and distends. Before you can
       throw it away, it bursts into a hundred tiny,
       birth-hugry insects...";
       finishGameMsg(ftDeath, [finishOptionUndo]);
    }    
  }
;


burrowCrawl: TravelMessage
  travelDesc =
  "The wormcast becomes slippery round you, as though your
   body-heat is melting long hardened resins, and
   you shut your eyes as you tunnel tightly through darkness. "
   
  destination = (eggsac.isIn(gPlayerChar) ? squareChamber
    : rand(squareChamber, corridor, forest));

;

//=======================================================================

antechamber: DarkRoom 'Antechamber' 'the antechamber'
  "The southeastern eaves of the Shrine make a curious antechamber. "
  northwest = shrine  
;

+ cage: Openable, Booth, Fixture 
  'iron barred cage/bars/frame/glyphs' 'iron cage'
  "The glyphs read: Bird Arrow Warthog. "
  roomDesc()
  {
    if(cageFloor.isOpen)
      "From the floor of the pit, an open earthen pit cuts
       down into the burial chamber. ";
    else
       "The bars of the cage surround you. ";
  }
  isLookAroundCeiling(actor, pov) { return true; }   

  isInInitState = (isOpen)
  initiallyOpen = true
  initSpecialDesc = "An iron-barred cage, large enough to stoop over inside,
      looms ominously here, its door open. There are some glyphs
      on the frame. "
  specialDesc = "The iron cage is closed. "
  useSpecialDesc = (!gActor.isIn(self))
  material = fineMesh
  down = cageFloor
  
  afterAction()
  {
    if(gActionIs(GetOutOf))
      gActor.lookAround(gameMain.verboseMode.isOn);
  }
;

++ skeletons : Fixture 'degranged old skeletons/skeleton/bone/bones/skull/skulls'
   'deranged skeletons'
   "Just old bones. "
   isListedInContents = true
   isPlural = true
   afterAction()
   {
     if(me.isIn(cage)) {
        "The skeletons inhabiting the cage come alive, locking
         bony hands about you, crushing and pummeling. You lose
         consciousness, and when you recover something impossible
         and grotesque has occurred...<.p>";
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

++ cageFloor: HiddenDoor 'open earthen burial floor/pit/chamber' 'floor'
   "An open earthen pit cuts down into the burial chamber below. "
   destination = burialShaft
;

burialShaft: Room 'Burial Shaft'
   "In your eventual field notes, this will read:
    <q>A corbel-vaulted crypt with an impacted earthen plug
    as seal above, and painted figures conjecturelly
    representing the nine Lords of the Night. Dispersed
    bones appear to be those of one elderly man and
    several child sacrifices, while other funerary remains
    include jaguar paws.</q> (In field notes it is essential
    not to give any sense of when you are scared witless). "
    
    cannotGoThatWay {
       "The architects of this chamber were less than generous in
       providing exits. Some warthog seems to have burrowed in
       from the north, though. ";
    }
    
    north = wormcast
    up: OneWayRoomConnector { -> cage
      canTravelerPass(traveler) { return traveler == me; }
      explainTravelBarrier(traveler) {
        "Making a mighty warthog-leap, you butt at the 
         earthen-plug seal above the chamber, collapsing your
         world in ashes and earth. Something lifeless and
         terribly heavy falls on top of you: you lose 
         consciousness, and when you recover, something
         impossible and grotesque has happened...<.p>";
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

+ honeycomb: Food, Treasure 'old ancient honeycomb/honey' 'ancient honeycomb'
   "Perhaps some kind of funerary votive offering. "
   initSpecialDesc = "An exquisitely preserved, ancient honeycomb rests here!"
   dobjFor(Eat)
   {
     action()
     {
       inherited;
       "Perhaps the most expensive meal of your life. The
        honey tastes odd, perhaps because it was used to
        store the entrails of the Lord buried here, but still
        like honey. ";
     }
   }
;

+ plug: Distant 'impacted earthen plug earthen-plus seal/plug'
  'eathern plug seal' "It's overhead, sealing the chamber. "  
;


junction: Room 'Xibalb&aacute' 'Xibalb&aacute' 
   "Fifty metres below rainforest, and the sound of water 
     is everywhere: these deep, eroded limestone caves
     extend like tap roots. A slither northeast by a broad
     column of ice-covered rock leads back to the Shrine,
     while a kind of canyon floor extends uphill to the
     north and downwards to south, pale white like shark's
     teeth in the diffused light from the sodium lamp above. "   
   northeast =  shrine   
   north = canyonN 
   up asExit(north)
   south =  canyonS 
   down asExit(south)
;

+ Surface, Fixture 'head-high head high ledge/shelf' 'ledge'
  "It's at about head-height. "
;

++ stela: Treasure 'modest-sized boundary bird stone/marker/stela/glyph' 'stela'
  "The carvings appear to warn that the boundary of
   Xibalb&aacute;, Place of Fright, is near. The bird glyph 
   is prominent. "
   initSpecialDesc = "A modest-sized stela, or boundary stone, rests on a
      ledge at head height. "
;


canyonN: Room 'Upper End of Canyon' 'the upper end of the canyon'
  "The higher, broader northern end of the canyon rises only
   to an uneven wall of volcanic karst. "
  south = junction
  down asExit(south)
;

+ hugeBall: TravelPushable 'huge pumice stone pumice-stone ball'
  'huge pumice-stone ball'
  "A good eight feet across, though fairly lightweight. "
  specialDesc = "A huge pumice-stone ball rests here, eight feet wide. "
  cannotTakeMsg = 'There\'s a lot of stone in an eight-foot sphere. '
  cannotMoveMsg = 'It wouldn\'t be so very hard to get rolling. '
  cannotTurnMsg = (cannotMoveMsg)
  canPushTravelVia(connector, dest)
  {
    return dest is in (canyonN, canyonS, junction);
  }
  explainNoPushTravelVia(connector, dest)
  {
    "The Shrine entrance is far less than eight feet wide. "; 
  }
  describeMovePushable(traveler, connector)
  {
    if(connector != canyonS)
      "The pumice-stone ball rolls into <<getOutermostRoom.destName>>. ";
  }
  beforeMovePushable(traveler, connector, dest) 
  { 
    if((getOutermostRoom == junction && dest == canyonN)
       || (getOutermostRoom == canyonS && dest == junction))
       "You strain to push the ball uphill. ";
    else
       "The ball is hard to stop once underway. ";
  }
;

canyonS: Room 'Lower End of Canyon' 'the lower end of the canyon'
   desc()
   {
     if(hugeBall.isIn(nil))
        "The southern end of the canyon
         now continues onto the pumice-stone ball, wedged into
         the chasm. "; 
     else
        "At the lower, and narrower, southern end, the canyon stops
         dead at a canyon of vertiginous blackness. Nothing can be
         seen or heard from below. ";
   }  
     
  north = junction
  up asExit(south)
  south: OneWayRoomConnector -> onBall
   {
     canTravelerPass(traveler) { return hugeBall.isIn(nil); }
     explainTravelBarrier(traveler) { "Into the chasm? "; }
     isConnectorApparent (origin, actor) { return canTravelerPass(actor); }
   }
  down: NoTravelMessage {    
    dobjFor(TravelVia) { action() { replaceAction(Enter, chasm); } }
  }
;


+ chasm: Container, Fixture 'horrifying bottomless chasm/pit'
  'horrifying chasm'
  beforeAction()
  {
    if(gActionIs(Jump))
      replaceAction(Enter, self);    
  }
  dobjFor(Enter)
  {
    verify() {}
    action()
    {
      "You plummet through the silent void of darkness, cracking
       your skull against an outcrop of rock. Amid the pain and 
       redness, you dimly make out the god with the owl-headdress...<.p>";
       
       finishGameMsg('YOU HAVE BEEN CAPTURED', [finishOptionUndo]);
    }
  }
  
  afterAction()
  {
    if(hugeBall.isIn(getOutermostRoom))
    {
      hugeBall.moveInto(nil);
      "The pumice-stone ball rolls out of control down the
       last few feet of the canyon before shuddering into
       the jaws of the chasm, bouncing back a little, and catching
       you a blow on the side of the forehead. You slump
       forward, bleeding, and... the pumice stone shrinks,
       or else your hand grows, because you seem now to be
       holding it, staring at Alligator, son of seven-Macaw,
       across the ball-court of the Plaza, the heads of his
       last opponents impaled on spikes, a congregation baying
       for your blood, and there is nothing to do but to throw
       anyway, and... but this is all nonsense, and you have
       a splitting headache. ";
    }
  }
  
  cannotJumpOverMsg = 'It is far too wide. '
;

onBall: Room 'Pumice-Stone Ledge' 'the pumice-stone ledge'
   "An impromtu ledge formed by the pumice-stone ball,
    wedged into place in the chasm. The canyon nevertheless
    ends here. "
    north = canyonS
    down asExit(north)
    up asExit(north)
;

+ Treasure 'incised carved bone' 'incised bone'
   "A hand holding a brush pen appears from the jaws of
    Itzamn&aacute;, inventor of writing, in his serpent form. "
    
    initSpecialDesc =  "Of all the sacrificial goods thrown into the chasm, perhaps
      nothing will be reclaimed: nothing but an incised bone, lighter
      than it looks, which projects from a pocket of wet silt in the
      canyon wall. " 
;

+ Unimportant 'wet pocket/silt' 'silt'
;

stoneKey: Key 'stone key' 'stone key'
;

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

 booklet: Consultable 'booklet' 'booklet'
  "A booklet form of the dictionary compiled from the unreliable 
    lithographs of the 
   legendary raconteur and explorer <q>Count</q> Jean Frederick 
   Maximilien Waldeck (1766??-1875), this guide contains what
   little is known of the glyphs used in the local ancient
   dialect. "
   correct = nil
   
   handleTopic(actor, topic, convType, path)
   {
      local toks = Tokenizer.tokenize(topic.getTopicText.toLower);
      local consultWords = toks.length;
      local w1 = getTokVal(toks[1]);
      if(consultWords > 1)
        local w2 = getTokVal(toks[2]);
      local glyph;
      if(consultWords == 1 && w1 not in ('glyph', 'glyphs'))
        glyph = w1;
      else if(consultWords == 2 && w1 == 'glyph')
        glyph = w2;
      else if(consultWords == 2 && w2 == 'glyph')
        glyph = w1;
      else
        return nil;
        
      switch(glyph)
      {
          case 'q1': "(This is one glyph you have memorised)\b
            Q1: <q>sacred site</q>.";
            break;
          case  'crescent': "Crescent: believed pronounced ~xibalbla~,
            though its meaning is unknown.";
            break;
          case 'arrow': "Arrow: <q>journey, becoming</q>.";
            break;
          case 'skull': "Skull: <q>death, doom; fate (not nec. bad)</q>.";
            break;
          case 'circle': "Circle: <q>the Sun; also life, lifetime</q>.";
            break;
          case 'jaguar': "Jaguar: <q>lord</q>.";
            break;
          case 'monkey': "Monkey: <q>priest?</q>.";
            break;
          case 'bird': if(correct) 
                    "Bird: <q>dead as a stone</q>.";
                  else
                    "Bird: <q>rich, affluent?</q>";
                  break;
          default: 
            "That glyph is so far unrecorded. ";
      }
        
      return true;  
   }

   topicNotFound = "Try <q>look up &lt;name of glyph&gt; in book.</q> "
;


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

waldeck: Consultable 'local guide mayan book dictionary guide' 
  'Waldeck\'s Mayan Dictionary' @me
  "Compiled from the unreliable lithographs of the 
   legendary raconteur and explorer <q>Count</q> Jean Frederick 
   Maximilien Waldeck (1766??-1875), this guide contains what
   little is known of the glyphs used in the local ancient
   dialect. "
   correct = nil
   isProperName = true
;

+ ConsultTopic @glyphQ1
  "(This is one glyph you have memorised!)\b
   Q1: <q>sacred site</q>"
;

+ ConsultTopic @glyphCrescent
  "Crescent: believed pronounced <q>xibalba</q>,
   though its meaning is unknown. "
;

+ ConsultTopic @glyphArrow
  "Arrow: <q>Journey; becoming</q>."
;

+ ConsultTopic @glyphSkull
  "Skull: Skull: <q>death, doom, fate (not nec. bad)</q>. "
;

+ ConsultTopic @glyphCircle
  "Circle: <q>the sun; also life, lifetime</q>. "
;

+ ConsultTopic @glyphJaguar
  "Jaguar: <q>lord</q>. "
;

+ ConsultTopic @glyphMonkey
  "Monkey: <q>priest?</q>."
;

+ ConsultTopic @glyphBird
  "Bird: <q>rich, affluent?</q>. "
;

++ AltTopic
  "Bird: <q>dead as a stone</q>. "
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
  '<NoCase>^<AlphaNum>+$|^glyph<Space>+<AlphaNum>+$|^<AlphaNum>+<Space>+glyph$'
  "That glyph is so far unrecognized. "
  
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
  isActive = gTopicText not in ('glyph', 'glyphs')
;

 
  /* This contains the message that will be displayed if all else fails */
  
+ DefaultConsultTopic
  "Try <q>look up &lt;name of glyph&gt; in book.</q> "
;

 /*
  * We define a special Glyph class as a type of Topic that will
  * match 'foo', 'glyph foo' or 'foo glyph' but not just 'glyph'.
  * To do that we need 'glyph' to be a weak token as both noun and
  * adjective, and each time we define a Glyph we want its vocabWords
  * treated as an adjective as well as a noun.
  */

class Glyph: Topic '(glyph) (glyph)'
  initializeVocab()
  {
     inherited;
     cmdDict.addWord(self, vocabWords, &adjective);
  }
;

glyphQ1: Glyph 'q1';
glyphCrescent: Glyph 'crescent';
glyphArrow: Glyph 'arrow';
glyphSkull: Glyph 'skull';
glyphCircle: Glyph 'circle';
glyphJaguar: Glyph 'jaguar';
glyphMonkey: Glyph 'monkey';
glyphBird: Glyph 'bird'
;

//======================================================================

 /* 
  * Having illustrated two ways of implementing the dictionary, we'll 
  * stick with the TADS 3 way of implementing the priest.
  */

priest: Person 'mummified calendrical priest' 'mummified priest' 
   "He is dessicated and hangs together only by will-power.
    Although his first language is probably local Mayan,
    you have the curious instinct that he will probably
    understand your speech. "
    
    actorHereDesc = "Behind the slab, a mummified priest stands waiting,
     barely alive at best, impossibly venerable. "
    
    /* Indicate that he's male */
    isHim = true
    
    dobjFor(Attack)
    {
        action()
        {
            moveInto(nil);
            "The priest dessicates away into dust until nothing remains,
            not a breeze or a bone. ";
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
  "<q>The bird glyph... very funny.</q>"  
;

++ AltTopic
  "<q>A dictionary? Really?</q>"
  isActive = gDobj.correct
;

/* Or on a list of topic objects */

+ AskTopic [tGlyph, tDialect]
 "<q>In our culture the priests are ever literate.</q> " 
;

/* Or on a regular expression */

+ AskTopic +110 '<NoCase>lord|tomb|shrine|temple' 
  "<q>This is a private matter.</q>"
;

/* Or on a single topic object */

+ AskTopic @tRuins
  "<q>The ruins will ever defeat thieves. In the
    underworld, looters are tortured throughout
    eternity.</q> A pause. <q>As are archaeologists.</q>"
;

+ AskTopic @tWormcast
  "<q>No man can pass the wormcast.</q>"
;

+ AskTopic @tXibalba
  topicResponse()
  {
      "The priest extends one bony finger southwest towards the
       icicles, which vanish like a frost as he speaks. 
      <q>Xibalb&aacute;, the Underworld.</q> ";
      icicles.moveInto(nil);
  }
;

++ AltTopic
   "The priest shakes a bony finger. "
   isActive = icicles.isIn(nil)
;

+ AskTopic @paintings
   "The calendrical priest frowns.
    <q>10 baktun, 4 katun, that makes 1,486,800 days
    since the beginning of time: in your calendar 19 January 909.</q>";
;

+ DefaultAskTopic
   "<q>You must find your own answer.</q>";
;

+ DefaultTellTopic
  "The priest has no interest in your sordid life. "
;

+ GiveShowTopic [waldeck, booklet]
  topicResponse()
  {
     gDobj.correct = true;
     "The priest reads a little of the book, laughing in a hollow,
      whispering way. Unable to restrain his mirth, he scratches
      in a correction somewhere before returning the book. ";
  }
  isActive = !gDobj.correct
;

+ GiveShowTopic @newspaper
  "He looks at the date. <q>12 baktun 16 katun 4 tun
   1 uinal 12 kin,</q> he declares before browsing the
   front page. <q>Ah. Progress, I see.</q>";
;

+ DefaultGiveShowTopic
  "The priest is not interested in earthly things. "
;

+ DefaultAnyTopic
  "The priest coughs, and almost falls apart. "
;

+ CommandTopic @TravelAction
  "<q>I must not leave the shrine.</q> "
;

+ DefaultCommandTopic
 "<q>It is not your orders I serve.</q> "
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
  roomDarkDesc = "The darkness of ages presses in on you,
     and you feel claustrophobic. "

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
             "\^<<roomName>> <<gPlayerChar != me ? '(as ' + gPlayerChar.name
              + ')' : ''>>";
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


scuttlingClaws: Thing, EventList, InitObject
  'tiny scuttling sound/claws/scuttle/things/monsters/creatures/insects'
  'sound of tiny claws'
  
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
    'Somewhere, tiny claws are scuttling. ',
  
    'The scuttling draws a little nearer, and your
     breathing grows loud and hoarse. ',
     
    'The perspiration of terror runs off your brow.
     The creatures are almost here! ',
     
    'You feel a tickling at your extremities and kick
     outward, shaking something chitinous off. Their sound
     alone is a menacing rasp. ',
     
    new function {
      "Suddenly there is a tiny pain, of a
       hypodermic sharp fang at your calf. Almost at once
       your limbs go into spasm, your shoulders and 
       knee-joints lock, your tongue swells...<.p>";
       
       finishGameMsg(ftDeath, [finishOptionUndo]);
    }     
  ]
  
  dobjFor(Examine) { verify() { illogical('It\'s too dark to see the source of the sound. ');}}
  
  dobjFor(Smell)  { action() { "You can smell only your own fear. ";  } }
  dobjFor(Taste) { check() { failCheck('You wouldn\'t want to, really. '); } }
  dobjFor(Feel) asDobjFor(Taste)
  dobjFor(Attack) { action() { "They easily evade your flailing about. "; } }
  dobjFor(ListenTo) { action() { "How intelligent they sound, for mere insects. "; } }
  
  dobjFor(Default)
  {
    preCond = []
    verify() {}
    action() { "The creatures avoid you, scuttling. "; }
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
  ('photograph'|'photo') singleDobj
  :PhotographAction
  verbPhrase = 'photograph/photographing (what)'
;

modify Thing
  dobjFor(Photograph)
  {
    preCond = [objVisible, new ObjectPreCondition(camera, objHeld)]
    verify() { }
    check() { 
       if(gPlayerChar.contents.length > 1)
         failCheck('Photography is a cumbersome business, needing the
          use of both hands. You\'ll have to put everything else down. ');       
    }
    action()
    {
        "You set up the elephantine, large format, wet-plate 
        camera<<sodiumLamp.isIn(getOutermostRoom) ? ',
        adjust the sodium-lamp' : ''>> and make a patient exposure of
        {the dobj/him}. ";
    }
  }

;

 /*  Change some default messages. */

modify npcMessages
  askUnknownWord(actor, txt) { "<q>You talk in riddles.</q> "; }
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
     if(si != nil && getTokVal(si.self_.tokens_[1]).toLower == 'priest'
      && si.self_.tokens_.length > 1 && getTokVal(si.self_.tokens_[2]) == ',')
       npcMessages.askUnknownWord(actor,txt); 
     else    
       inherited(actor, txt);      
     
   }
;

modify libMessages
  showScoreRankMessage(msg) { "This earns you the rank of <<msg>>. "; }
;


