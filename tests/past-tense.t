#charset "utf-8"
#include <adv3.h>
#include <sv_se.h> 
#include "../../../code/tads3/tads3-unit-test/unittest.h"

versionInfo: GameID
  IFID = '38da5fdf-9077-4043-bfe1-14c83c087c81'
  name = 'tester för svenska översättningen av adv3'
  byline = 'by Tomas Öberg'
  htmlByline = 'by <a href="mailto:yourmail@address.com">Tomas Öberg</a>'
  version = '1'
  authorEmail = 'Tomas Öberg yourmail@address.com'
  desc = 'enhetstester'
  htmlDesc = 'enhetstester'
;
gameMain: GameMainDef
    initialPlayerChar = spelare2aPerspektiv
    usePastTense = true
;

// Test arrangements



modify testRunner 
  verboseAboutSuccessfulTests = nil // Visa inte varje testutfall om det är OK
;


modify mainOutputStream
    hideOutput = true
    capturedOutputBuffer = nil // = static new StringBuffer()
    writeFromStream(txt) {
        if(capturedOutputBuffer == nil) {
          capturedOutputBuffer = new StringBuffer();
        }
        capturedOutputBuffer.append(txt);
        // Swallow the message
        if(!hideOutput) {
          inherited(txt);
        }
    }
;
// Shortcut to access the output without lengthy comparisons
#define o toString(mainOutputStream.capturedOutputBuffer)

// Rensa fångst-buffern varje gång samt sätt ett default gAction 
// (då det förutsätts vid bland annat gMessageParams)
beforeEachTest: BeforeEach 
    run() { 
        mainOutputStream.capturedOutputBuffer = new StringBuffer();
        gAction = ExamineAction.createInstance();
    }
;

spelare1aPerspektiv: Actor 'jag' 'jag'
  pcReferralPerson = FirstPerson
  isProperName = true
  isHim = true
;

spelare2aPerspektiv: Actor 'du' 'du'
  pcReferralPerson = SecondPerson
  isProperName = true
  isHim = true
;
spelare3dePerspektiv: Actor 'bob' 'Bob'
  pcReferralPerson = ThirdPerson
  isProperName = true
  isHim = true
;

appletObjNeutrumSingular: Thing 'äpple+t' 'äpple' ;
jordgubbeObjUtrumSingular: Thing 'jordgubbe+n' 'jordgubbe';
vindruvorObjNeutrumPlural: Thing 'vindruva*vindruvor+na' 'vindruvor' isPlural=true;

bokenObjUtrumSingular: Thing 'bok+en' 'bok';
papperetObjNeutrumSingular: Thing 'papper+et' 'papper' ;
skyltarObjUtrumPlural: Thing 'skylt*skyltar+na' 'skyltar' isPlural=true;

dorrenObjUtrumSingular: Thing 'dörr+en' 'dörr';
skapetObjNeutrumSingular: Thing 'skåp+et' 'skåp' ;
+snickargladje: Component 'snickareglädje+n' 'snickargläde';

dorrarObjUterPlural: Thing 'dörr+en*dörrar+na' 'dörrar' isPlural = true;
skapenObjNeuterPlural: Thing 'skåp+et*skåpen' 'skåpen' isPlural = true theName = 'skåpen';

tandsticka: Thing 'tändsticka+n' 'tändsticka';
ljuset: Thing 'stearinljus+et' 'stearinljus';
prassel: SimpleNoise 'prassel/prasslet/prasslande+t' 'prassel' 
  theName = 'prasslet'
  
  //isProperName = true
;

hatt: Wearable 'hatt+en' 'hatt';

sopor: SimpleOdor 'sopa*sopor' 'sopor' isPlural = true isQualifiedName = true;

lukten: SimpleOdor 'lukt+en' 'lukt';

roret: Container 'rör+et' 'rör' ;
nyckel: Key 'nyckel+n' 'nyckel';
nyckelring: Keyring 'nyckelring+en' 'nyckelring';

stegen: Thing 'stege+n' 'stege';
vaggen: DefaultWall 'vägg+en' 'väggen';

hobbit: Actor 'hobbit+en' 'hobbit' isHim = true isProperName = nil;
baren: Room 'baren' 'baren'   theName = 'baren'
  east = valvgangPathPassage
  south = passageThroughPassage
;
apan: Actor 'apa+n' 'apa';

+ krogare: Actor 'krögare+n' 'krögare' isHim = true isProperName = nil;
+ bankraden: Chair 'bänkrad+en' 'bänkrad';
++ sjorovare: Actor 'sjörrövare+n' 'sjörövare' 
  isHim = true 
  isProperName = nil
  posture = sitting
;
++ viking: Actor 'viking+en' 'sjörövare' 
  isHim = true 
  isProperName = nil
  posture = sitting
;

+ passageThroughPassage: ThroughPassage 'passage+n' 'passage' theName = 'passagen';
+ trappan: StairwayUp 'trappa+n' 'trappa' theName = 'trappan';
+ kallartrappan: StairwayDown 'trappa+n' 'trappa' theName = 'källartrappan';
fylke: OutdoorRoom 'Fylke' 'Fylke';

hallen: Room 'hallen' 'hallen'
  west = valvgangPathPassage
;
+ valvgangPathPassage: PathPassage 'valvgång+en' 'valvgång' theName = 'valvgången';

vagnen: Vehicle 'vagn+en' 'vagn';
masten: OutdoorRoom 'masten' 'masten';
+pirat: Actor 'pirat+en' 'pirat';
+matros: Actor 'matros+en' 'matros';
kajen: OutdoorRoom 'kajen' 'kajen';

musikenObjUtrumSingular: Thing 'musik+en' 'musik';
matosetObjUtrumSingular: Thing 'matos+et' 'matos';

tingest: Thing 'tingest+en' 'tingest';
sak: Thing 'sak+en' 'sak';






// Test Assertions
UnitTest 'openMsg - utrum singular' run {
  assertThat(libMessages.openMsg(dorrenObjUtrumSingular)).isEqualTo('öppen');
};
UnitTest 'openMsg - neutrum singular' run {
  assertThat(libMessages.openMsg(skapetObjNeutrumSingular)).isEqualTo('öppet');
};
UnitTest 'openMsg - utrum plural' run {
  assertThat(libMessages.openMsg(dorrarObjUterPlural)).isEqualTo('öppna');
};
UnitTest 'openMsg - neutrum plural' run {
  assertThat(libMessages.openMsg(skapenObjNeuterPlural)).isEqualTo('öppna');
};

UnitTest 'distantThingDesc - neutrum plural' run {
  libMessages.distantThingDesc(dorrenObjUtrumSingular);
  assertThat(o).startsWith('Den är för långt borta för att kunna utgöra några detaljer'); 
};


UnitTest 'obscuredThingDesc first person' run {
  gPlayerChar = spelare1aPerspektiv;
  libMessages.obscuredThingDesc(skapenObjNeuterPlural, skapenObjNeuterPlural);
  assertThat(o).startsWith('Jag kunde inte utgöra några detaljer genom skåpen.');
};

UnitTest 'obscuredThingDesc second person' run {
  gPlayerChar = spelare2aPerspektiv;
  libMessages.obscuredThingDesc(skapenObjNeuterPlural, skapenObjNeuterPlural);
  assertThat(o).startsWith('Du kunde inte utgöra några detaljer genom skåpen.');
};

UnitTest 'obscuredThingDesc second person' run {
  gPlayerChar = spelare3dePerspektiv;
  libMessages.obscuredThingDesc(skapenObjNeuterPlural, skapenObjNeuterPlural);
  assertThat(o).startsWith('Bob kunde inte utgöra några detaljer genom skåpen.');
};


UnitTest 'thingTasteDesc neuter singular' run {
  gPlayerChar = spelare2aPerspektiv;
  libMessages.thingTasteDesc(skapetObjNeutrumSingular);
  assertThat(o).startsWith('Det smakade ungefär som du hade förväntat dig.');
};

UnitTest 'thingTasteDesc utrum singular' run {
  gPlayerChar = spelare2aPerspektiv;
  libMessages.thingTasteDesc(dorrenObjUtrumSingular);
  assertThat(o).startsWith('Den smakade ungefär som du hade förväntat dig.');
};

UnitTest 'thingTasteDesc plural' run {
  gPlayerChar = spelare2aPerspektiv;
  libMessages.thingTasteDesc(skapenObjNeuterPlural);
  assertThat(o).startsWith('De smakade ungefär som du hade förväntat dig.');
};

UnitTest 'announceRemappedAction neutrum dobj' run {
  //mainOutputStream.hideOutput = nil;
  gAction = OpenAction.createActionInstance();
  gAction.setCurrentObjects([skapetObjNeutrumSingular]);
  assertThat(libMessages.announceRemappedAction(gAction))
    .contains('öppnar skåpet');
};


UnitTest 'announceRemappedAction utrum dobj' run {
  //mainOutputStream.hideOutput = nil;
  gAction = OpenAction.createActionInstance();
  gAction.setCurrentObjects([dorrenObjUtrumSingular]);
  assertThat(libMessages.announceRemappedAction(gAction))
    .contains('öppnar dörren');
};


UnitTest 'announceRemappedAction plural dobj' run {
  //mainOutputStream.hideOutput = nil;
  gAction = OpenAction.createActionInstance();
  gAction.setCurrentObjects([skapenObjNeuterPlural]);
  assertThat(libMessages.announceRemappedAction(gAction))
    .contains('öppnar skåpen');
};

UnitTest 'announceImplicitAction neutrum dobj tryingImpCtx' run {
  //mainOutputStream.hideOutput = nil;
  gAction = OpenAction.createActionInstance();
  gAction.setCurrentObjects([skapetObjNeutrumSingular]);
  assertThat(libMessages.announceImplicitAction(gAction, tryingImpCtx))
    .contains('försöker öppna skåpet först');
};

UnitTest 'announceImplicitAction utrum dobj tryingImpCtx' run {
  //mainOutputStream.hideOutput = nil;
  gAction = OpenAction.createActionInstance();
  gAction.setCurrentObjects([dorrenObjUtrumSingular]);
  assertThat(libMessages.announceImplicitAction(gAction, tryingImpCtx))
    .contains('försöker öppna dörren först');
};

UnitTest 'announceImplicitAction plural dobj tryingImpCtx' run {
  //mainOutputStream.hideOutput = nil;
  gAction = OpenAction.createActionInstance();
  gAction.setCurrentObjects([skapenObjNeuterPlural]);
  assertThat(libMessages.announceImplicitAction(gAction, tryingImpCtx))
    .contains('försöker öppna skåpen först');
};


UnitTest 'announceMoveToBag plural dobj tryingImpCtx' run {
  //mainOutputStream.hideOutput = nil;
  gAction = MoveAction.createActionInstance();
  gAction.setCurrentObjects([skapenObjNeuterPlural]);
  assertThat(libMessages.announceMoveToBag(gAction, tryingImpCtx))
    .contains('försöker flytta skåpen för att göra plats först');
};


UnitTest 'announceMoveToBag plural dobj tryingImpCtx' run {
  //mainOutputStream.hideOutput = nil;
  gAction = MoveAction.createActionInstance();
  gAction.setCurrentObjects([skapenObjNeuterPlural]);
  assertThat(libMessages.announceMoveToBag(gAction, tryingImpCtx))
    .contains('försöker flytta skåpen för att göra plats först');
};


UnitTest 'obscuredThingSoundDesc first person neuter singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare1aPerspektiv;
  libMessages.obscuredThingSoundDesc(appletObjNeutrumSingular, skapetObjNeutrumSingular);
  assertThat(o).startsWith('Jag kunde inte höra något detaljerat genom skåpet.');
};

UnitTest 'obscuredThingSmellDesc first person utrum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare1aPerspektiv;
  libMessages.obscuredThingSmellDesc(appletObjNeutrumSingular, dorrenObjUtrumSingular);
  assertThat(o).startsWith('Jag kunde inte känna så mycket lukt genom dörren.');
};

UnitTest 'obscuredReadDesc first person utrum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare1aPerspektiv;
  libMessages.obscuredReadDesc(papperetObjNeutrumSingular);
  assertThat(o).startsWith('Jag kunde inte se det bra nog för att kunna läsa det.');
};

UnitTest 'obscuredReadDesc 1a person utrum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  libMessages.obscuredReadDesc(bokenObjUtrumSingular);
  assertThat(o).startsWith('Du kunde inte se den bra nog för att kunna läsa den.');
};

UnitTest 'obscuredReadDesc 3ee person utrum plural' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare3dePerspektiv;
  libMessages.obscuredReadDesc(skyltarObjUtrumPlural);
  assertThat(o).startsWith('Bob kunde inte se dem bra nog för att kunna läsa dem.');
};

UnitTest 'obscuredThingSmellDesc 2a person utrum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  libMessages.thingTasteDesc(appletObjNeutrumSingular);
  assertThat(o).startsWith('Det smakade ungefär som du hade förväntat dig.');
};

UnitTest 'dimReadDesc 2a person neutrum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  libMessages.dimReadDesc(papperetObjNeutrumSingular);
  assertThat(o).startsWith('Det fanns inte ljus bra nog att läsa det.');
};

UnitTest 'cannotReachObject 1a person dobj: utrum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare1aPerspektiv;
  libMessages.cannotReachObject(appletObjNeutrumSingular);
  assertThat(o).startsWith('Jag kunde inte nå äpplet.');
};

UnitTest 'cannotReachObject 2nd person dobj: utrum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  libMessages.cannotReachObject(appletObjNeutrumSingular);
  assertThat(o).startsWith('Du kunde inte nå äpplet.');
};

UnitTest 'cannotReachObject 3e person dobj: utrum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare3dePerspektiv;
  libMessages.cannotReachObject(appletObjNeutrumSingular);
  assertThat(o).startsWith('Bob kunde inte nå äpplet.');
};

UnitTest 'cannotReachContents 1a person dobj: utrum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare1aPerspektiv;
  local str = libMessages.cannotReachContents(appletObjNeutrumSingular, skapetObjNeutrumSingular);
  "<<str>>";
  assertThat(o).startsWith('Jag kunde inte nå det genom skåpet.');
};

UnitTest 'cannotReachContents 2a person dobj: utrum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  local str = libMessages.cannotReachContents(appletObjNeutrumSingular, skapetObjNeutrumSingular);
  "<<str>>";
  assertThat(o).startsWith('Du kunde inte nå det genom skåpet.');
};

UnitTest 'cannotReachContents 3e person dobj: utrum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare3dePerspektiv;
  local str = libMessages.cannotReachContents(appletObjNeutrumSingular, skapetObjNeutrumSingular);
  "<<str>>";
  assertThat(o).startsWith('Bob kunde inte nå det genom skåpet.');
};


UnitTest 'cannotReachOutside 2a person dobj: utrum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare3dePerspektiv;
  local str = libMessages.cannotReachOutside(appletObjNeutrumSingular, skapetObjNeutrumSingular);
  "<<str>>";
  assertThat(o).startsWith('Bob kunde inte nå det genom skåpet.');
};


UnitTest 'soundIsFromWithin 2a person dobj: utrum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  libMessages.soundIsFromWithin(musikenObjUtrumSingular, skapetObjNeutrumSingular);
  assertThat(o).startsWith('\^musiken verkade komma från insidan skåpet.');
};


UnitTest 'soundIsFromWithout 2a person dobj: utrum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  libMessages.soundIsFromWithout(musikenObjUtrumSingular, skapetObjNeutrumSingular);
  assertThat(o).startsWith('\^musiken verkade komma från utsidan skåpet.');
};

UnitTest 'smellIsFromWithin 2a person dobj: utrum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  libMessages.smellIsFromWithin(matosetObjUtrumSingular, skapetObjNeutrumSingular);
  assertThat(o).startsWith('\^matoset verkade komma från insidan skåpet.');
};

UnitTest 'smellIsFromWithout 2a person dobj: utrum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  libMessages.smellIsFromWithout(matosetObjUtrumSingular, skapetObjNeutrumSingular);
  assertThat(o).startsWith('\^matoset verkade komma från utsidan skåpet.');
};

UnitTest 'pcDesc 1a person' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare1aPerspektiv;
  libMessages.pcDesc(gPlayerChar);
  assertThat(o).startsWith('\^jag såg likadan ut som vanligt.');
};
UnitTest 'pcDesc 2a person' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  libMessages.pcDesc(gPlayerChar);
  assertThat(o).startsWith('\^du såg likadan ut som vanligt.');
};

UnitTest 'pcDesc 3e person' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare3dePerspektiv;
  libMessages.pcDesc(gPlayerChar);
  assertThat(o).startsWith('\^Bob såg likadan ut som vanligt.');
};

UnitTest 'roomActorStatus actor (ingen output om stående)' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  hobbit.posture = standing;
  libMessages.roomActorStatus(hobbit);
  assertThat(o).isEqualTo('');
};

UnitTest 'roomActorStatus actor (sitter)' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  hobbit.posture = sitting;
  libMessages.roomActorStatus(hobbit);
  assertThat(o).isEqualTo(' (sitter)');
};

UnitTest 'roomActorStatus actor (ligger)' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  hobbit.posture = lying;
  libMessages.roomActorStatus(hobbit);
  assertThat(o).isEqualTo(' (ligger)');
};


UnitTest 'roomActorHereDesc actor (ligger)' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  hobbit.posture = standing;
  libMessages.roomActorHereDesc(hobbit);
  assertThat(o).contains('\^hobbiten står där.');
};

UnitTest 'roomActorHereDesc actor (ligger)' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  hobbit.posture = sitting;
  libMessages.roomActorHereDesc(hobbit);
  assertThat(o).startsWith('\^hobbiten sitter där.');
};

UnitTest 'roomActorHereDesc actor (ligger)' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  hobbit.posture = lying;
  libMessages.roomActorHereDesc(hobbit);
  assertThat(o).startsWith('\^hobbiten ligger där.');
};



UnitTest 'roomActorThereDesc actor (ligger)' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  hobbit.posture = standing;
  libMessages.roomActorThereDesc(hobbit);
  assertThat(o).contains('\^hobbiten står i närheten.'); // TODO: OK mening?
};

UnitTest 'roomActorThereDesc actor (ligger)' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  hobbit.posture = sitting;
  libMessages.roomActorThereDesc(hobbit);
  assertThat(o).startsWith('\^hobbiten sitter i närheten.'); // TODO: OK mening?
};

UnitTest 'roomActorThereDesc actor (ligger)' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  hobbit.posture = lying;
  libMessages.roomActorThereDesc(hobbit);
  assertThat(o).startsWith('\^hobbiten ligger i närheten.'); // TODO: OK mening?
};


// TODO: kan testas betydligt mera
UnitTest 'actorInRoom' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  hobbit.posture = sitting;
  libMessages.actorInRoom(hobbit, baren); 
  assertThat(o).startsWith('\^hobbiten sitter i baren.');
};

// TODO: kan testas betydligt mera
UnitTest 'actorInRoomPosture' run {
  //mainOutputStream.hideOutput = nil;
  gActor = hobbit;
  hobbit.posture = sitting;
  libMessages.actorInRoomPosture(hobbit, baren); 
  assertThat(o).startsWith('Han sitter i baren.');
};

UnitTest 'roomActorPostureDesc' run {
  //mainOutputStream.hideOutput = nil;
  gActor = hobbit;
  hobbit.posture = sitting;
  libMessages.roomActorPostureDesc(hobbit); 
  assertThat(o).startsWith('Han sitter.');
};

UnitTest 'sayArriving' run {
  //mainOutputStream.hideOutput = nil;
  hobbit.location = fylke; 
  libMessages.sayArriving(hobbit); 
  assertThat(o).startsWith('\^en hobbit kom till Fylke.');
};

UnitTest 'sayDeparting' run {
  //mainOutputStream.hideOutput = nil;
  hobbit.location = fylke; 
  libMessages.sayDeparting(hobbit); 
  assertThat(o).startsWith('\^en hobbit lämnade Fylke.');
};


UnitTest 'sayArrivingLocally' run {
  //mainOutputStream.hideOutput = nil;
  hobbit.location = fylke; 
  libMessages.sayArrivingLocally(hobbit, baren); 
  //sayDepartingLocally(traveler, dest)
  assertThat(o).startsWith('\^en hobbit kom till Fylke.');
};

UnitTest 'sayDepartingLocally' run {
  //mainOutputStream.hideOutput = nil;
  hobbit.location = fylke; 
  libMessages.sayDepartingLocally(hobbit, baren); 
  assertThat(o).startsWith('\^en hobbit lämnade Fylke.');
};

UnitTest 'sayTravelingRemotely' run {
  //mainOutputStream.hideOutput = nil;
  hobbit.location = fylke; 
  libMessages.sayTravelingRemotely(hobbit, baren); 
  assertThat(o).startsWith('\^en hobbit gick till Fylke.');
};

UnitTest 'sayArrivingDir' run {
  //mainOutputStream.hideOutput = nil;
  [
    [northDirection, '\^en hobbit kom till Fylke norrifrån.'],
    [southDirection, '\^en hobbit kom till Fylke söderifrån.'],
    [eastDirection, '\^en hobbit kom till Fylke österifrån.'],
    [westDirection, '\^en hobbit kom till Fylke västerifrån.'],
    [northeastDirection, '\^en hobbit kom till Fylke nordösterifrån.'],
    [northwestDirection, '\^en hobbit kom till Fylke nordvästerifrån.'],
    [southeastDirection, '\^en hobbit kom till Fylke sydösterifrån.'],
    [southwestDirection, '\^en hobbit kom till Fylke sydvästerifrån.'],
    [upDirection, '\^en hobbit kom till Fylke uppifrån.'],
    [downDirection, '\^en hobbit kom till Fylke nerifrån.'],
    [inDirection, '\^en hobbit kom till Fylke inifrån.'],
    [outDirection, '\^en hobbit kom till Fylke utifrån.']
  ].forEach(function(pair) {
    hobbit.location = fylke;   
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    local dir = pair[1];
    local msg = pair[2];
    hobbit.location = fylke; 
    libMessages.sayArrivingDir(hobbit, dir.name); 
    assertThat(o).startsWith(msg);
  });
};

UnitTest 'sayDepartingDir' run {
  //mainOutputStream.hideOutput = nil;
  hobbit.location = fylke; 
  
  [
    [northDirection, '\^en hobbit lämnade Fylke norrut.'],
    [southDirection, '\^en hobbit lämnade Fylke söderut.'],
    [eastDirection, '\^en hobbit lämnade Fylke österut.'],
    [westDirection, '\^en hobbit lämnade Fylke västerut.'],
    [northeastDirection, '\^en hobbit lämnade Fylke nordösterut.'],
    [northwestDirection, '\^en hobbit lämnade Fylke nordvästerut.'],
    [southeastDirection, '\^en hobbit lämnade Fylke sydösterut.'],
    [southwestDirection, '\^en hobbit lämnade Fylke sydvästerut.'],
    
    // TODO: snygga till meningarna nedan:
    [upDirection, '\^en hobbit lämnade Fylke uppåt.'], 
    [downDirection, '\^en hobbit lämnade Fylke neråt.'],
    [inDirection, '\^en hobbit lämnade Fylke inåt.'],
    [outDirection, '\^en hobbit lämnade Fylke utåt.']
  ].forEach(function(pair) {
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    local dir = pair[1];
    local msg = pair[2];
    hobbit.location = fylke; 
    libMessages.sayDepartingDir(hobbit, dir.name); 
    assertThat(o).startsWith(msg);
  });

};


// Överväg allternativen:
//Han kom från kajen akterifrån
//Han kom från kajen vid babord
//Han kom från styrbordssidan av kajen



UnitTest 'sayArrivingShipDir' run {
  ////mainOutputStream.hideOutput = nil;
  [
    [foreDirection, 'en pirat kom till masten från fören.'],
    [aftDirection, 'en pirat kom till masten från aktern.'],
    [portDirection, 'en pirat kom till masten från babordssidan.'],
    [starboardDirection, 'en pirat kom till masten från styrbordssidan.']
  ].forEach(function(pair) {
    pirat.location = masten; 
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    local dir = pair[1];
    local msg = pair[2];
    pirat.location = masten; 
    dir.sayArriving(pirat);
    // NOTE: testar indirekt även:
    // libMessages.sayDepartingShipDir(hobbit, dir.name); 

    assertThat(o).contains(msg);
  });
};

UnitTest 'sayDepartingShipDir' run {
  // mainOutputStream.hideOutput = nil;
  [
     [foreDirection, 'en pirat gick föröver mot kajen'],
     [aftDirection, 'en pirat gick akteröver mot kajen'],
     [portDirection, 'en pirat gick längs babordssidan mot kajen'],
     [starboardDirection, 'en pirat gick längs styrbordssidan mot kajen']
  ].forEach(function(pair) {
    pirat.location = kajen; 
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    local dir = pair[1];
    local msg = pair[2];
    pirat.location = kajen;     
    // NOTE: inkluderar test av sayDepartingAft(traveler) & sayDepartingFore(traveler)
    dir.sayDeparting(pirat);
    assertThat(o).contains(msg);
  });
};

UnitTest 'sayDepartingShipDir' run {
  // mainOutputStream.hideOutput = nil;
  [
     [foreDirection, 'en pirat gick föröver mot kajen'],
     [aftDirection, 'en pirat gick akteröver mot kajen'],
     [portDirection, 'en pirat gick längs babordssidan mot kajen'],
     [starboardDirection, 'en pirat gick längs styrbordssidan mot kajen']
  ].forEach(function(pair) {
    pirat.location = kajen; 
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    local dir = pair[1];
    local msg = pair[2];
    pirat.location = kajen; 
    dir.sayDeparting(pirat);
    assertThat(o).contains(msg);
  });
};

UnitTest 'sayDepartingThroughPassage' run {
  //mainOutputStream.hideOutput = nil;
  pirat.location = baren; 
  libMessages.sayDepartingThroughPassage(pirat, passageThroughPassage);
  assertThat(o).contains('en pirat lämnade baren genom passagen');
};

UnitTest 'sayArrivingThroughPassage' run {
  //mainOutputStream.hideOutput = nil;
  pirat.location = baren; 
  libMessages.sayArrivingThroughPassage(pirat, passageThroughPassage);
  assertThat(o).startsWith('\^en pirat kom in i baren genom passagen');
};

UnitTest 'sayDepartingViaPath' run {
  //mainOutputStream.hideOutput = nil;
  pirat.location = baren; 
  libMessages.sayDepartingViaPath(pirat, valvgangPathPassage);
  assertThat(o).startsWith('\^en pirat lämnade baren via valvgången');
};


UnitTest 'sayArrivingViaPath' run {
  //mainOutputStream.hideOutput = nil;
  pirat.location = baren; 
  libMessages.sayArrivingViaPath(pirat, valvgangPathPassage);
  assertThat(o).contains('\^en pirat kom till baren via valvgången');
};

UnitTest 'sayDepartingUpStairs' run {
  //mainOutputStream.hideOutput = nil;
  pirat.location = baren; 
  libMessages.sayDepartingUpStairs(pirat, trappan);
  assertThat(o).contains('\^en pirat gick upp för trappan');
};

UnitTest 'sayDepartingDownStairs' run {
  //mainOutputStream.hideOutput = nil;
  pirat.location = baren; 
  libMessages.sayDepartingDownStairs(pirat, trappan);
  assertThat(o).contains('\^en pirat gick ner för trappan');
};

UnitTest 'sayArrivingUpStairs' run {
  //mainOutputStream.hideOutput = nil;
  pirat.location = baren; 
  libMessages.sayArrivingUpStairs(pirat, kallartrappan);
  assertThat(o).contains('\^en pirat kom upp från källartrappan');
};

UnitTest 'sayArrivingDownStairs' run {
  //mainOutputStream.hideOutput = nil;
  pirat.location = baren; 
  libMessages.sayArrivingDownStairs(pirat, trappan);
  assertThat(o).contains('\^en pirat kom ner från trappan till baren.');
};

UnitTest 'sayDepartingWith' run {
  //mainOutputStream.hideOutput = nil;
  libMessages.sayDepartingWith(pirat, hobbit);
  assertThat(o).contains('\^en pirat anlände med hobbiten.');
};


UnitTest 'sayDepartingWithGuide' run {
  //mainOutputStream.hideOutput = nil;
  libMessages.sayDepartingWithGuide(pirat, matros);
  assertThat(o).contains('\^matrosen lät piraten leda vägen.');
};

UnitTest 'sayOpenDoorRemotely dörren (neutrum utrum)' run {
  //mainOutputStream.hideOutput = nil;
  libMessages.sayOpenDoorRemotely(dorrenObjUtrumSingular, true);
  assertThat(o).contains('Någon öppnade dörren från den andra sidan');
};

UnitTest 'sayOpenDoorRemotely skåpet (neutrum singular)' run {
  //mainOutputStream.hideOutput = nil;
  libMessages.sayOpenDoorRemotely(skapetObjNeutrumSingular, true);
  assertThat(o).contains('Någon öppnade skåpet från den andra sidan');
};

UnitTest 'sayOpenDoorRemotely dörrar (utrum plural)' run {
  //mainOutputStream.hideOutput = nil;
  libMessages.sayOpenDoorRemotely(dorrarObjUterPlural, true);
  assertThat(o).contains('Någon öppnade dörrarna från den andra sidan');
};

// TODO: bör testas mera
UnitTest 'actorInRemoteRoom' run {
  //mainOutputStream.hideOutput = nil;
  //libGlobal.pointOfView = hobbit;
  libMessages.actorInRemoteRoom(pirat, baren, krogare);
  assertThat(o).contains('\^piraten står i baren');
};

// TODO: testa i större sammanhang också
UnitTest 'actorInGroupSuffix' run {
  //mainOutputStream.hideOutput = nil;
  libMessages.actorInGroupSuffix(sitting, bankraden, [sjorovare, viking]);
  assertThat(o).startsWith(' sitter på bänkraden'); // TODO: måste testa denna i sin helhet
};

// TODO: testa i större sammanhang också
UnitTest 'actorInRemoteGroupSuffix' run {
  //mainOutputStream.hideOutput = nil;
  libMessages.actorInRemoteGroupSuffix(hobbit, sitting, bankraden, baren, [sjorovare, viking]);
  assertThat(o).startsWith(' i baren, sitter på bänkraden'); // TODO: måste testa denna i sin helhet
};

// TODO: testa i större sammanhang också, 
// verkar bara vara Lister.showArrangedList(pov, parent, lst, options, indent, infoTab, itemCount, singles, groups, groupTab, origLst)
// som använder detta meddelande

UnitTest 'actorHereGroupSuffix' run {
  //mainOutputStream.hideOutput = nil;
  libMessages.actorHereGroupSuffix(sitting, [sjorovare]);
  assertThat(o).startsWith(' sitter där');
};

// TODO: testa i större sammanhang också
UnitTest 'actorThereGroupSuffix' run {
  //mainOutputStream.hideOutput = nil;
  libMessages.actorThereGroupSuffix(krogare, lying, baren, [viking]);
  assertThat(o).startsWith(' ligger i baren');
};


//   say that the actor is in the nested room, in the current
//   posture, and add then add that we're in the outer room as
//   well 
UnitTest 'actorInRemoteNestedRoom' run {
  //mainOutputStream.hideOutput = nil;
  libMessages.actorInRemoteNestedRoom(krogare, baren, hallen, viking);
  
  // TODO: oklart om hur detta ska se ut och det är rätt? 
  // TODO: Bygg upp ett scenario som visar detta meddelande i sin helhet
  assertThat(o).startsWith('\^krögaren var i hallen, står i baren.'); 
  // I engelskan ska participle vara ståendes, men det känns inte rätt här. 
};

UnitTest 'matchBurnedOut' run {
  //mainOutputStream.hideOutput = nil;
  libMessages.matchBurnedOut(tandsticka);
  assertThat(o).startsWith('Tändstickan brann upp, och försvann i ett moln av aska.'); 
};

UnitTest 'candleBurnedOut' run {
  //mainOutputStream.hideOutput = nil;
  libMessages.candleBurnedOut(ljuset);
  assertThat(o).startsWith('Stearinljuset brann ner för långt för att fortsätta vara tänt, och slocknade.'); 
};

UnitTest 'objBurnedOut' run {
  //mainOutputStream.hideOutput = nil;
  libMessages.objBurnedOut(ljuset);
  assertThat(o).startsWith('Stearinljuset slocknade.');
};

UnitTest 'inputFileScriptWarning' run {
  //mainOutputStream.hideOutput = nil;
  assertThat(libMessages.inputFileScriptWarning('42VARNING', 'filnamn'))
    .startsWith('VARNING Vill du fortsätta?');
};

UnitTest 'inputFileScriptWarning' run {
  //mainOutputStream.hideOutput = nil;
  assertThat(libMessages.inputFileScriptWarning('42VARNING', 'filnamn'))
    .startsWith('VARNING Vill du fortsätta?');
};

// --------------
// playerMessages
// --------------

UnitTest 'commandNotUnderstood' run {
  //mainOutputStream.hideOutput = nil;
  playerMessages.commandNotUnderstood(nil);
  assertThat(o).startsWith('Spelet förstår inte det kommandot.');
};
UnitTest 'specialTopicInactive' run {
  //mainOutputStream.hideOutput = nil;
  playerMessages.specialTopicInactive(nil);
  assertThat(o).startsWith('Det kommandot kan inte användas just nu.');
};
UnitTest 'allNotAllowed' run {
  //mainOutputStream.hideOutput = nil;
  playerMessages.allNotAllowed(nil);
  assertThat(o).contains('<q>Allt</q> kan inte användas med det verbet');
};

UnitTest 'noMatchForAll' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare2aPerspektiv;
  playerMessages.noMatchForAll(nil);
  assertThat(o).contains('Du såg inget passande där');
};

UnitTest 'noMatchForAllBut' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare2aPerspektiv;
  playerMessages.noMatchForAllBut(nil);
  assertThat(o).contains('Du såg ingenting annat där');
};

UnitTest 'noMatchForPronoun' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare2aPerspektiv;
  playerMessages.noMatchForPronoun(gActor, nil, 'den');
  assertThat(o).contains('Ordet <q>den</q> refererade inte till någonting just nu.');
};

// --------------------
// playerActionMessages
// --------------------
UnitTest 'mustBeHoldingMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare3dePerspektiv;
  gAction = EatAction.createActionInstance();
  gAction.setCurrentObjects([appletObjNeutrumSingular]);
  local msg = playerActionMessages.mustBeHoldingMsg(appletObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Bob behövde hålla i det för att göra det.');
};

UnitTest 'mustBeVisibleMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare3dePerspektiv;
  gAction = EatAction.createActionInstance();
  gAction.setCurrentObjects([appletObjNeutrumSingular]);
  local msg = playerActionMessages.mustBeVisibleMsg(appletObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Bob kunde inte se det.');
};

UnitTest 'heardButNotSeenMsg' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = gActor;
  gActor = spelare3dePerspektiv;
  gAction = EatAction.createActionInstance();
  gAction.setCurrentObjects([prassel]);
  local msg = playerActionMessages.heardButNotSeenMsg(prassel);
  "<<msg>>";
  // TODO: "kunde höra något prassla" skulle varit en bättre mening, 
  // se över hur det ska gå att ordna så som proper/plural fungerar nu
  assertThat(o).startsWith('Bob kunde höra ett prassel, men han kunde inte se det.');
};

UnitTest 'smelledButNotSeenMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare3dePerspektiv;
  gAction = SearchAction.createActionInstance();
  gAction.setCurrentObjects([sopor]);
  local msg = playerActionMessages.smelledButNotSeenMsg(sopor);
  "<<msg>>";
  assertThat(o).startsWith('Bob kunde känna lukten av sopor, men han kunde inte se dem.');
};


UnitTest 'cannotHearMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare2aPerspektiv;
  gAction = ListenToAction.createActionInstance();
  gAction.setCurrentObjects([prassel]);
  local msg = playerActionMessages.cannotHearMsg(prassel);
  "<<msg>>";
  assertThat(o).startsWith('Du kunde inte höra det.');
};

UnitTest 'cannotSmellMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare2aPerspektiv;
  gAction = ListenToAction.createActionInstance();
  gAction.setCurrentObjects([prassel]);
  local msg = playerActionMessages.cannotSmellMsg(prassel);
  "<<msg>>";
  assertThat(o).startsWith('Du kunde inte känna lukten av det.');
};

UnitTest 'cannotTasteMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare2aPerspektiv;
  gAction = ListenToAction.createActionInstance();
  gAction.setCurrentObjects([prassel]);
  local msg = playerActionMessages.cannotTasteMsg(prassel);
  "<<msg>>";
  assertThat(o).startsWith('Du kunde inte smaka det.');
};


UnitTest 'cannotBeWearingMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare1aPerspektiv;
  gPlayerChar = gActor;
  gAction = WearAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.cannotBeWearingMsg(hatt);
  "<<msg>>";
  assertThat(o).startsWith('Jag måste ta av den innan jag kunde göra det.');
};

UnitTest 'mustBeEmptyMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare1aPerspektiv;
  gPlayerChar = gActor;
  local msg = playerActionMessages.mustBeEmptyMsg(hatt);
  "<<msg>>";
  assertThat(o).startsWith('Jag behövde ta ut allting från den före jag kunde göra det.');
};


UnitTest 'mustBeOpenMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare1aPerspektiv;
  gPlayerChar = gActor;
  local msg = playerActionMessages.mustBeOpenMsg(hatt);
  "<<msg>>";
  assertThat(o).startsWith('Jag behövde öppna den före jag kunde göra det');
};


UnitTest 'mustBeClosedMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare1aPerspektiv;
  gPlayerChar = gActor;
  local msg = playerActionMessages.mustBeClosedMsg(skapetObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Jag behövde stänga det före jag kunde göra det.');
};


UnitTest 'mustBeUnlockedMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare1aPerspektiv;
  gPlayerChar = gActor;
  local msg = playerActionMessages.mustBeUnlockedMsg(skapenObjNeuterPlural);
  "<<msg>>";
  assertThat(o).startsWith('Jag behövde låsa upp dem före jag kunde göra det.');
};

UnitTest 'mustSitOnMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare1aPerspektiv;
  gPlayerChar = gActor;
  local msg = playerActionMessages.mustSitOnMsg(skapetObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Jag behövde sitta i skåpet först.');
};

UnitTest 'mustLieOnMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare1aPerspektiv;
  gPlayerChar = gActor;
  local msg = playerActionMessages.mustLieOnMsg(bankraden);
  "<<msg>>";
  assertThat(o).startsWith('Jag behövde ligga på bänkraden först.');
};

UnitTest 'mustGetOnMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare1aPerspektiv;
  gPlayerChar = gActor;
  local msg = playerActionMessages.mustGetOnMsg(bankraden);
  "<<msg>>";
  assertThat(o).startsWith('Jag behövde komma upp på bänkraden först.');
};

UnitTest 'mustBeInMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare1aPerspektiv;
  gPlayerChar = gActor;
  local msg = playerActionMessages.mustBeInMsg(appletObjNeutrumSingular, skapetObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Äpplet behövde vara i skåpet före jag kunde göra det');
};


UnitTest 'mustBeCarryingMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare3dePerspektiv;
  gPlayerChar = gActor;
  local msg = playerActionMessages.mustBeCarryingMsg(appletObjNeutrumSingular, gActor);
  "<<msg>>";
  assertThat(o).startsWith('Bob behövde hålla det före han kunde göra det.');
};

UnitTest 'decorationNotImportantMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare3dePerspektiv;
  gPlayerChar = gActor;
  local msg = playerActionMessages.decorationNotImportantMsg(bankraden);
  "<<msg>>";
  assertThat(o).startsWith('Bänkraden är oviktig.');
};

UnitTest 'unthingNotHereMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare1aPerspektiv;
  gPlayerChar = gActor;
  local msg = playerActionMessages.unthingNotHereMsg(appletObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Jag ser inte det där.');
};

// ------- Masskopiera mall
UnitTest 'tooDistantMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare1aPerspektiv;
  gPlayerChar = gActor;
  local msg = playerActionMessages.tooDistantMsg(appletObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Äpplet var för långt borta.');
};

UnitTest 'notWithIntangibleMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare1aPerspektiv;
  gPlayerChar = gActor;
  local msg = playerActionMessages.notWithIntangibleMsg(appletObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Jag kunde inte göra det med ett äpple.');
};

UnitTest 'notWithVaporousMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare1aPerspektiv;
  gPlayerChar = gActor;
  local msg = playerActionMessages.notWithVaporousMsg(appletObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Jag kunde inte göra det med ett äpple.');
};


UnitTest 'lookInVaporousMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare1aPerspektiv;
  gPlayerChar = gActor;
  local msg = playerActionMessages.lookInVaporousMsg(appletObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Jag såg bara det.');
};


// ---


UnitTest 'cannotReachObjectMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare1aPerspektiv;
  gPlayerChar = gActor;
  local msg = playerActionMessages.cannotReachObjectMsg(appletObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Jag kunde inte nå det.');
};

UnitTest 'thingDescMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare1aPerspektiv;
  gPlayerChar = gActor;
  local msg = playerActionMessages.thingDescMsg(appletObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Jag såg inget ovanligt med det.');
};



UnitTest 'npcDescMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare1aPerspektiv;
  gPlayerChar = gActor;
  local msg = playerActionMessages.npcDescMsg(appletObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Jag såg inget ovanligt med äpplet.');
};


UnitTest 'noiseSourceMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare1aPerspektiv;
  gPlayerChar = gActor;
  gAction = ListenToAction.createActionInstance();
  gAction.setCurrentObjects([prassel]);
  local msg = playerActionMessages.noiseSourceMsg(skapenObjNeuterPlural);
  "<<msg>>";
  assertThat(o).startsWith('Prasslet verkade att komma från skåpen.');
};


UnitTest 'odorSourceMsg' run {
  //mainOutputStream.hideOutput = nil;
  gAction = ListenToAction.createActionInstance();
  gAction.setCurrentObjects([lukten]);
  local msg = playerActionMessages.odorSourceMsg(skapetObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Lukten verkade att komma från skåpet.');
};


UnitTest 'cannotMoveComponentMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare1aPerspektiv;
  gAction = MoveAction.createActionInstance();
  gAction.setCurrentObjects([snickargladje]);
  local msg = playerActionMessages.cannotMoveComponentMsg(skapetObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Snickareglädjen var en del av skåpet');
};


UnitTest 'cannotTakeComponentMsg singular/neutrum del av singular' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = TakeAction.createActionInstance();
  gAction.setCurrentObjects([snickargladje]);
  local msg = playerActionMessages.cannotTakeComponentMsg(dorrenObjUtrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Jag kunde inte ta den; den var del av dörren.');
};

UnitTest 'cannotPutComponentMsg singular/neutrum del av plural' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = TakeAction.createActionInstance();
  gAction.setCurrentObjects([snickargladje]);
  gAction.setActors([gActor]);

  setPlayer(spelare1aPerspektiv);
  local msg = playerActionMessages.cannotPutComponentMsg(dorrarObjUterPlural);
  "<<msg>>";
  assertThat(o).startsWith('Jag kunde inte lägga den någonstans; den var en del av dörrarna');
};

UnitTest 'droppingObjMsg' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.droppingObjMsg(hatt);
  "<<msg>>";
  assertThat(o).startsWith('Jag släppte hatten.');
};


UnitTest 'floorlessDropMsg' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.floorlessDropMsg(hatt);
  "<<msg>>";
  assertThat(o).startsWith('Den föll utom synhåll nedanför.');
};

// ...........

UnitTest 'cannotMoveThroughMsg' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  local msg = playerActionMessages.cannotMoveThroughMsg(appletObjNeutrumSingular, roret);
  "<<msg>>";
  assertThat(o).startsWith('Jag kunde inte förflytta det genom röret.');
};

UnitTest 'cannotMoveThroughContainerMsg' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  local msg = playerActionMessages.cannotMoveThroughContainerMsg(appletObjNeutrumSingular, roret);
  "<<msg>>";
  assertThat(o).startsWith('Jag kunde inte förflytta det genom röret.');
};

UnitTest 'cannotMoveThroughClosedMsg' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = MoveWithAction.createActionInstance();
  gAction.setCurrentObjects([appletObjNeutrumSingular, roret]);
  local msg = playerActionMessages.cannotMoveThroughClosedMsg(appletObjNeutrumSingular, roret);
  "<<msg>>";
  assertThat(o).startsWith('Jag kunde inte göra det då röret var stängt.');
};

UnitTest 'cannotFitIntoOpeningMsg' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([appletObjNeutrumSingular]);
  local msg = playerActionMessages.cannotFitIntoOpeningMsg(appletObjNeutrumSingular, roret);
  "<<msg>>";
  assertThat(o).startsWith('Jag kunde inte göra det då äpplet var för stort för att sätta in i röret.');
};

UnitTest 'cannotFitOutOfOpeningMsg' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.cannotFitOutOfOpeningMsg(appletObjNeutrumSingular, roret);
  "<<msg>>";
  assertThat(o).startsWith('Jag kunde inte göra det då äpplet var för stort för att ta ut ur röret.');
};


UnitTest 'cannotTouchThroughContainerMsg' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = FeelAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.cannotTouchThroughContainerMsg(gActor, roret);
  "<<msg>>";
  assertThat(o).startsWith('Jag kunde inte nå någonting genom röret.');
};

UnitTest 'cannotTouchThroughClosedMsg' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = FeelAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.cannotTouchThroughClosedMsg(gActor, roret);
  "<<msg>>";
  assertThat(o).startsWith('Jag kunde inte göra det då röret var stängt.');
};

UnitTest 'cannotReachIntoOpeningMsg' run {
  setPlayer(spelare2aPerspektiv);
  gActor = spelare2aPerspektiv;
  gAction = TakeAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);

  local msg = playerActionMessages.cannotReachIntoOpeningMsg(gActor, roret);
  "<<msg>>";
  assertThat(o).startsWith('Du kunde inte få in din hand i röret.');
};

UnitTest 'cannotReachOutOfOpeningMsg' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gPlayerChar = gActor;
  gAction = TakeAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.cannotReachOutOfOpeningMsg(gActor, roret);
  "<<msg>>";
  assertThat(o).startsWith('Jag kunde inte få in min hand genom röret.');
};


UnitTest 'tooLargeForActorMsg(obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = TakeAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.tooLargeForActorMsg(skapetObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Skåpet var för stort för mig att hålla.');
};

UnitTest 'handsTooFullForMsg(obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = TakeAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.handsTooFullForMsg(hatt);
  "<<msg>>";
  // TODO: hantera även dina/deras/dessas händer osv..
  assertThat(o).startsWith('Mina händer var för fulla för att även hålla hatten.');
};

UnitTest 'becomingTooLargeForActorMsg(obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = TakeAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.becomingTooLargeForActorMsg(hatt);
  "<<msg>>";
  assertThat(o)
  .startsWith('Jag kunde inte göra det då hatten skulle ha blivit för stor för mig att hålla.');
};

UnitTest 'handsBecomingTooFullForMsg(obj) 1a person' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = TakeAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.handsBecomingTooFullForMsg(hatt);
  "<<msg>>";
  assertThat(o)
    .startsWith('Jag kunde inte göra det då mina händer skulle ha blivit för fulla för att kunna hålla den.');
   
};

UnitTest 'handsBecomingTooFullForMsg(obj) 2a person' run {
  setPlayer(spelare2aPerspektiv);
  gActor = spelare2aPerspektiv;
  gPlayerChar = gActor;
  gAction = TakeAction.createActionInstance();
  gAction.setCurrentObjects([roret]);
  local msg = playerActionMessages.handsBecomingTooFullForMsg(roret);
  "<<msg>>";
  assertThat(o)
    .startsWith('Du kunde inte göra det då dina händer skulle ha blivit för fulla för att kunna hålla det.');
};


UnitTest 'obscuredReadDesc 3de person utrum plural' run {
  //mainOutputStream.hideOutput = nil;
  setPlayer(spelare3dePerspektiv);
  gActor = spelare3dePerspektiv;
  gPlayerChar = spelare3dePerspektiv;
  libMessages.obscuredReadDesc(skyltarObjUtrumPlural);
  assertThat(o).startsWith('Bob kunde inte se dem bra nog för att kunna läsa dem.');
};

// TODO: fixa test, texten kan inte genereras som det är nu.
// UnitTest 'handsBecomingTooFullForMsg(obj) 3de person' run {
//   //mainOutputStream.hideOutput = nil;
//   setPlayer(spelare3dePerspektiv);
//   gActor = spelare3dePerspektiv;
//   gPlayerChar = spelare3dePerspektiv;
//   gAction = TakeAction.createActionInstance();
//   gAction.setCurrentObjects([hatt]);
//   gAction.setActors([spelare3dePerspektiv]);
//   local msg = playerActionMessages.handsBecomingTooFullForMsg(hatt);
//   "<<msg>>";
//   assertThat(o)
//     .startsWith('Bob kunde inte göra det då hans händer skulle ha blivit för fulla för att kunna hålla det.');
// };


UnitTest 'tooHeavyForActorMsg(obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  local msg = playerActionMessages.tooHeavyForActorMsg(hatt);
  "<<msg>>";
  assertThat(o).startsWith('Hatten var för tung för mig att plocka upp.');
};

UnitTest 'totalTooHeavyForMsg(obj)' run {
  //mainOutputStream.hideOutput = nil;
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = TakeAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.totalTooHeavyForMsg(hatt);
  "<<msg>>";
  assertThat(o).startsWith('Hatten var för tung; jag behövde sätta ner någonting först.');
};

UnitTest 'tooLargeForContainerMsg(obj, cont)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.tooLargeForContainerMsg(hatt, roret);
  "<<msg>>";
  assertThat(o).startsWith('Hatten var för stor för röret.');
};

UnitTest 'tooLargeForUndersideMsg(obj, cont)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.tooLargeForUndersideMsg(hatt, skapetObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Hatten var för stor för att stoppa in under skåpet');
};

UnitTest 'tooLargeForRearMsg(obj, cont)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.tooLargeForRearMsg(hatt, skapenObjNeuterPlural);
  "<<msg>>";
  assertThat(o).startsWith('Hatten var för stor för att stoppa in bakom skåpen.');
};

UnitTest 'containerTooFullMsg(obj, cont)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.containerTooFullMsg(hatt, skapetObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('skåpet var redan för fullt för att få plats med den.');
};

UnitTest 'surfaceTooFullMsg(obj, cont)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.surfaceTooFullMsg(hatt, bankraden);
  "<<msg>>";
  assertThat(o).startsWith('Det fanns inget rum för den på bänkraden.');
};

UnitTest 'undersideTooFullMsg(obj, cont)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.undersideTooFullMsg(hatt, bankraden);
  "<<msg>>";
  assertThat(o).startsWith('Det fanns inget rum för den under bänkraden.');
};

UnitTest 'rearTooFullMsg(obj, cont)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.rearTooFullMsg(hatt, skapetObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Det fanns inget rum för den bakom skåpet.');
};

UnitTest 'becomingTooLargeForContainerMsg(obj, cont)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.becomingTooLargeForContainerMsg(hatt, dorrenObjUtrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Jag kunde inte göra det då det skulle ha gjort den för stor för dörren.');
};

UnitTest 'containerBecomingTooFullMsg(obj, cont)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.containerBecomingTooFullMsg(hatt, skapetObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Jag kunde inte göra det för att hatten skulle inte längre få plats i skåpet.');
};

UnitTest 'takenAndMovedToKeyringMsg(keyring)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([nyckel]);
  local msg = playerActionMessages.takenAndMovedToKeyringMsg(nyckelring);
  "<<msg>>";
  assertThat(o).startsWith('Jag plockade upp nyckeln och fäste den i nyckelringen');
};

UnitTest 'movedKeyToKeyringMsg(keyring)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([nyckel]);
  local msg = playerActionMessages.movedKeyToKeyringMsg(nyckelring);
  "<<msg>>";
  assertThat(o).startsWith('Jag fäste nyckeln i nyckelringen');
};

UnitTest 'movedKeysToKeyringMsg(keyring, keys)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([nyckel]);
  local msg = playerActionMessages.movedKeysToKeyringMsg(nyckelring, [nyckel]);
  "<<msg>>";
  assertThat(o).startsWith('Jag fäste min lösa nyckel i nyckelringen.');
};

// TODO: Förbättra objekten till kläder 
UnitTest 'circularlyInMsg(x, y)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([nyckel]);
  local msg = playerActionMessages.circularlyInMsg(nyckel, nyckelring);
  "<<msg>>";
  assertThat(o).startsWith('Jag kunde inte göra det då nyckeln var i nyckelringen.');
};

// TODO: Förbättra objekten till kläder
UnitTest 'circularlyOnMsg(x, y)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.circularlyOnMsg(hatt, bankraden);
  "<<msg>>";
  assertThat(o).startsWith('Jag kunde inte göra det då hatten var på bänkraden.');
};

// TODO: Förbättra objekten till kläder
UnitTest 'circularlyUnderMsg(x, y)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.circularlyUnderMsg(hatt, skapetObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Jag kunde inte göra det då hatten var under skåpet.');
};

// TODO: Förbättra objekten till kläder
UnitTest 'circularlyBehindMsg(x, y)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.circularlyBehindMsg(hatt, skapetObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Jag kunde inte göra det då hatten var bakom skåpet.');
};

UnitTest 'willNotLetGoMsg(holder, obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = TakeAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.willNotLetGoMsg(hobbit, hatt);
  "<<msg>>";
  assertThat(o).startsWith('Hobbiten låter inte mig få den.');
};

UnitTest 'cannotGoThroughClosedDoorMsg(door)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = EnterAction.createActionInstance();
  gAction.setCurrentObjects([dorrenObjUtrumSingular]);
  local msg = playerActionMessages.cannotGoThroughClosedDoorMsg(dorrenObjUtrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Jag kunde inte göra det då dörren var stängd.');
};

// TODO: Keep going, you can do it!
UnitTest 'invalidStagingContainerMsg(cont, dest)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.invalidStagingContainerMsg(baren, bankraden);
  "<<msg>>";
  assertThat(o).startsWith('Jag kunde inte göra det medan bänkraden var i baren.');
};

UnitTest 'invalidStagingContainerActorMsg(cont, dest)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = TravelAction.createActionInstance();
  local msg = playerActionMessages.invalidStagingContainerActorMsg(hobbit, dorrarObjUterPlural);
  "<<msg>>";
  assertThat(o).startsWith('Jag kunde inte göra det då hobbiten höll i dörrarna.');
};

UnitTest 'invalidStagingLocationMsg(dest)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.invalidStagingLocationMsg(hatt);
  "<<msg>>";
  assertThat(o).startsWith('Jag kunde inte gå in i hatten.'); // TODO: Rätt?
};

UnitTest 'nestedRoomTooHighMsg(obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.nestedRoomTooHighMsg(hatt);
  "<<msg>>";
  assertThat(o).startsWith('Hatten var för hög att nå därifrån.');
};

UnitTest 'nestedRoomTooHighToExitMsg(obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.nestedRoomTooHighToExitMsg(hatt);
  "<<msg>>";
  assertThat(o).startsWith('Det var alltför långt fall ner för att kunna göra det därifrån.');
};

UnitTest 'cannotDoFromMsg(obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.cannotDoFromMsg(hatt);
  "<<msg>>";
  assertThat(o).startsWith('Jag kunde inte göra det från den.');
};

UnitTest 'vehicleCannotDoFromMsg(obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  hatt.location = baren;
  local msg = playerActionMessages.vehicleCannotDoFromMsg(hatt);
  "<<msg>>";
  assertThat(o).startsWith('Jag kunde inte göra det medan hatten var i baren');
};

UnitTest 'cannotGoThatWayInVehicleMsg(traveler)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = TravelAction.createActionInstance();
  local msg = playerActionMessages.cannotGoThatWayInVehicleMsg(vagnen);
  "<<msg>>";
  assertThat(o).startsWith('Jag kunde inte göra det i vagnen.');
};

UnitTest 'cannotPushObjectThatWayMsg(obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = PushAction.createActionInstance();
  gAction.setCurrentObjects([vagnen]);
  local msg = playerActionMessages.cannotPushObjectThatWayMsg(vagnen);
  "<<msg>>";
  assertThat(o).startsWith('Jag kunde inte knuffa den i den riktningen.');
};

UnitTest 'cannotPushObjectNestedMsg(obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = PushAction.createActionInstance();
  gAction.setCurrentObjects([vagnen]);
  local msg = playerActionMessages.cannotPushObjectNestedMsg(vagnen);
  "<<msg>>";
  assertThat(o).startsWith('Jag kunde inte knuffa den dit.');
};

UnitTest 'cannotEnterExitOnlyMsg(obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.cannotEnterExitOnlyMsg(hatt);
  "<<msg>>";
  assertThat(o).startsWith('Jag kunde inte gå in i den därifrån.');
};

UnitTest 'mustOpenDoorMsg(obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  local msg = playerActionMessages.mustOpenDoorMsg(dorrarObjUterPlural);
  "<<msg>>";
  assertThat(o).startsWith('Jag behövde öppna dem först.');
};

UnitTest 'doorClosesBehindMsg(obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = TravelAction.createActionInstance();
  local msg = playerActionMessages.doorClosesBehindMsg(dorrarObjUterPlural);
  "<<msg>>";
  assertThat(o).contains('efter att jag gick igenom dem, stängde sig dörrarna bakom mig.');
};


UnitTest 'refuseCommand(targetActor, issuingActor)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  local msg = playerActionMessages.refuseCommand(hobbit, gActor);
  "<<msg>>";
  assertThat(o).startsWith('Hobbiten vägrade min begäran.');
};


UnitTest 'refuseCommand(targetActor, issuingActor)' run {
  setPlayer(spelare2aPerspektiv);
  gActor = spelare2aPerspektiv;
  local msg = playerActionMessages.refuseCommand(hobbit, gActor);
  "<<msg>>";
  assertThat(o).startsWith('Hobbiten vägrade din begäran.');
};


UnitTest 'refuseCommand(targetActor, issuingActor)' run {
  setPlayer(spelare3dePerspektiv);
  gActor = spelare3dePerspektiv;
  local msg = playerActionMessages.refuseCommand(hobbit, gActor);
  "<<msg>>";
  assertThat(o).startsWith('Hobbiten vägrade hans begäran.');
};

UnitTest 'notAddressableMsg(obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.notAddressableMsg(hatt);
  "<<msg>>";
  assertThat(o).startsWith('Jag kunde inte prata med den.');
};

UnitTest 'noResponseFromMsg(other)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.noResponseFromMsg(hatt);
  "<<msg>>";
  assertThat(o).startsWith('Hatten svarade inte.');
};

UnitTest 'notInterestedMsg(actor)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  local msg = playerActionMessages.notInterestedMsg(pirat);
  "<<msg>>";
  assertThat(o).startsWith('\^piraten verkade ointresserad.');
};

UnitTest 'objCannotHearActorMsg(obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([pirat]);
  local msg = playerActionMessages.objCannotHearActorMsg(pirat);
  "<<msg>>";
  assertThat(o).startsWith('\^piraten verkade inte kunna höra mig.');
};

UnitTest 'actorCannotSeeMsg(actor, obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hobbit]);
  local msg = playerActionMessages.actorCannotSeeMsg(hobbit, hatt);
  "<<msg>>";
  assertThat(o).startsWith('\^hobbiten verkar oförmögen att se hatten.');
};

UnitTest 'cannotFollowFromHereMsg(srcLoc)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.cannotFollowFromHereMsg(hatt);
  "<<msg>>";
  assertThat(o).startsWith('Den senaste platsen jag hade sett hatten var baren.');
};

UnitTest 'okayPushTravelMsg(obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.okayPushTravelMsg(hatt);
  "<<msg>>";
  assertThat(o).contains('Jag tryckte in hatten i utrymmet.');
};

UnitTest 'mustBeBurningMsg(obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([ljuset]);
  local msg = playerActionMessages.mustBeBurningMsg(ljuset);
  "<<msg>>";
  assertThat(o).startsWith('Jag behövde tända stearinljuset före jag kunde göra det.');
};

UnitTest 'mustDetachMsg(obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.mustDetachMsg(hatt);
  "<<msg>>";
  assertThat(o).startsWith('Jag behövde ta loss den före jag kunde göra det.');
};

UnitTest 'foundKeyOnKeyringMsg(ring, key)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = ExamineAction.createActionInstance();
  gAction.setCurrentObjects([nyckel]);
  local msg = playerActionMessages.foundKeyOnKeyringMsg(nyckelring, nyckel);
  "<<msg>>";
  assertThat(o).startsWith('Jag försökte varje nyckel på nyckelringen, och upptäckte att nyckeln passade låset.');
};

UnitTest 'foundNoKeyOnKeyringMsg(ring)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([nyckelring]);
  local msg = playerActionMessages.foundNoKeyOnKeyringMsg(nyckelring);
  "<<msg>>";
  assertThat(o).startsWith('Jag försökte varje nyckel på nyckelringen, men jag hittade inte någon som passade låset.');
};

UnitTest 'roomOkayPostureChangeMsg(posture, obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  local msg = playerActionMessages.roomOkayPostureChangeMsg(sitting, baren);
  "<<msg>>";
  assertThat(o).startsWith('Ok, jag satt i baren.');
};

UnitTest 'cannotThrowThroughMsg(target, loc)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.cannotThrowThroughMsg(hatt, baren);
  "<<msg>>";
  assertThat(o).startsWith('Jag kunde inte kasta någonting genom baren.');
};

UnitTest 'throwHitMsg(projektilen, target)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = ThrowAtAction.createActionInstance();
  gAction.setCurrentObjects([hatt, hobbit]);
  local msg = playerActionMessages.throwHitMsg(hatt, hobbit);
  "<<msg>>";
  assertThat(o).startsWith('Hatten träffade hobbiten utan någon uppenbar effekt.');
};

UnitTest 'throwFallMsg(projektilen, target)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = ThrowAtAction.createActionInstance();
  gAction.setCurrentObjects([hatt, hobbit]);
  local msg = playerActionMessages.throwFallMsg(hatt, hobbit);
  "<<msg>>";
  assertThat(o).startsWith('Hatten landade på hobbiten.');
};

UnitTest 'throwHitFallMsg(projektilen, target, dest)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.throwHitFallMsg(hatt, hobbit, bankraden);
  "<<msg>>";
  assertThat(o).startsWith('Hatten träffade hobbiten utan någon uppenbar effekt, och föll ner på bänkraden.');
};

UnitTest 'throwShortMsg(projektilen, target)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.throwShortMsg(hatt, hobbit);
  "<<msg>>";
  assertThat(o).startsWith('Hatten föll långtifrån hobbiten.');
};

UnitTest 'throwFallShortMsg(projektilen, target, dest)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.throwFallShortMsg(hatt, hobbit, baren);
  "<<msg>>";
  assertThat(o).startsWith('Hatten föll i baren långtifrån hobbiten.');
};

UnitTest 'throwCatchMsg(obj, target)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.throwCatchMsg(hatt, hobbit);
  "<<msg>>";
  assertThat(o).startsWith('\^hobbiten fångade hatten.');
};

UnitTest 'willNotCatchMsg(catcher)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.willNotCatchMsg(hobbit);
  "<<msg>>";
  assertThat(o).startsWith('\^hobbiten såg inte ut som han ville fånga någonting.');
};

UnitTest 'tooLargeForContainerMsg(obj, cont)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.tooLargeForContainerMsg(hatt, skapetObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Hatten var för stor för skåpet.');
};


UnitTest 'missingObject(actor, action, which)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gActor.referralPerson = DirectObject;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  playerMessages.missingObject(gActor, gAction, DirectObject);
  assertThat(o).startsWith('Du behöver vara specifik om vad du vill');
};


UnitTest 'missingActor(actor)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gActor.referralPerson = DirectObject;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  playerMessages.missingActor(gActor);
  assertThat(o).startsWith('Du behövde vara mer specifik om vem du ville addressera.');
};

UnitTest 'singleActorRequired(actor)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gActor.referralPerson = DirectObject;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  playerMessages.singleActorRequired(gActor);
  assertThat(o).startsWith('Du kan bara addressera en person åt gången.');
};


UnitTest 'cannotTalkTo(targetActor, issuingActor) #1' run {
  //mainOutputStream.hideOutput = nil;
  setPlayer(pirat);
  gActor = pirat;
  playerMessages.cannotTalkTo(hobbit, pirat);
  assertThat(o).startsWith('\^hobbiten var inte någonting du kunde prata med.');
};

UnitTest 'cannotTalkTo(targetActor, issuingActor) #2' run {
  //mainOutputStream.hideOutput = nil;
  setPlayer(pirat);
  gActor = pirat;
  playerMessages.cannotTalkTo(pirat, hobbit);
  assertThat(o).startsWith('\^du var inte någonting han kunde prata med.');
};

UnitTest 'cannotTalkTo(targetActor, issuingActor) #3' run {
  //mainOutputStream.hideOutput = nil;
  setPlayer(apan);
  gActor = apan;  
  apan.pcReferralPerson = FirstPerson;
  playerMessages.cannotTalkTo(hobbit, apan);
  assertThat(o).startsWith('\^hobbiten var inte någonting jag kunde prata med.');
  mainOutputStream.capturedOutputBuffer = new StringBuffer();

  apan.pcReferralPerson = SecondPerson;
  playerMessages.cannotTalkTo(hobbit, apan);
  assertThat(o).startsWith('\^hobbiten var inte någonting du kunde prata med.');
  
  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  apan.pcReferralPerson = ThirdPerson;
  playerMessages.cannotTalkTo(hobbit, apan);
  assertThat(o).startsWith('\^hobbiten var inte någonting den kunde prata med.');

};


UnitTest 'alreadyTalkingTo(actor, greeter)' run {
  //mainOutputStream.hideOutput = nil;
  setPlayer(apan);
  gActor = apan;  
  apan.pcReferralPerson = FirstPerson;
  playerMessages.alreadyTalkingTo(hobbit, apan);
  assertThat(o).startsWith('\^jag hade redan hobbitens uppmärksamhet.');
  mainOutputStream.capturedOutputBuffer = new StringBuffer();

  apan.pcReferralPerson = SecondPerson;
  playerMessages.alreadyTalkingTo(hobbit, apan);
  assertThat(o).startsWith('\^du hade redan hobbitens uppmärksamhet.');
  
  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  apan.pcReferralPerson = ThirdPerson;
  playerMessages.alreadyTalkingTo(hobbit, apan);
  assertThat(o).startsWith('\^apan hade redan hobbitens uppmärksamhet.');
};


UnitTest 'againCannotChangeActor' run {
  //mainOutputStream.hideOutput = nil;
  setPlayer(pirat);
  gActor = pirat;
  local msg = playerMessages.againCannotChangeActor();
  "<<msg>>";
  assertThat(o).contains('För att repetera ett kommando som <q>sköldpadda, gå norrut,</q>
säg bara <q>igen,</q> inte <q>sköldpadda, igen.</q>');
};

UnitTest 'againCannotTalkToTarget' run {
  //mainOutputStream.hideOutput = nil;
  setPlayer(pirat);
  gActor = pirat;
  playerMessages.againCannotTalkToTarget(hobbit, apan);
  assertThat(o).contains('\^hobbiten kunde inte repetera det kommandot.');

};

//TODO:
    // TakeFromAction -> 'vad vill du x',
    // DetachFromAction -> 'vad vill du x',
    // UnfastenFromAction -> 'vad vill du x',
    // UnplugFromAction -> 'vad vill du x',

    //PutInAction -> 'vad vill du stoppa in',
    //PutOnAction -> 'vad vill du lägga på',
    //PutUnderAction -> 'vad vill du lägga under',
    //PutBehindAction -> 'vad vill du lägga bakom',
    //PutInAction -> 'vad vill du x',
    //AskVagueAction -> 'vem vill du x',

    //GiveToAction -> 'vad vill du x',
    //ShowToAction -> 'vad vill du x',
    //ThrowAction -> 'vad vill du kasta',
    //ThrowAtAction -> 'vad vill du x',
    //ThrowToAction -> 'vad vill du x',

    //ReplayStringAction -> 'vill du avsluta kommandoinspelning',
    //TravelViaAction -> 'vad vill du x',
    //MoveToAction -> 'vad vill du röra',


    //EnterOnAction -> 'vad vill du kliva på',
    //ConsultAboutAction -> 'vad vill du sklå upp',

    //PourIntoAction -> 'vad vill du hälla i',
    //PourOntoAction -> 'vad vill du hälla på',
    //AttachToAction -> 'vad vill du sätta fast',


    //FastenToAction -> 'vad vill du fästa till',
    //PlugIntoAction -> 'vad vill du x',
    //PushTravelDirAction -> 'vad vill du x',
    //PushTravelEnterAction -> 'vad vill du x',
    //PushTravelGetOutOfAction -> 'vad vill du x',
    //PushTravelClimbUpAction -> 'vad vill du x',
    //PushTravelClimbDownAction -> 'vad vill du x',
    //DebugAction -> 'vill du debugga',
    //AskAboutAction -> 'vad vill du x'
  

UnitTest 'askMissingLiteral(actor, action, which)' run {
  //mainOutputStream.hideOutput = nil;
  local actionTextPairs = 
  [
    TakeAction -> 'vad vill du ta',
    RemoveAction -> 'vad vill du ta bort',
    DropAction -> 'vad vill du släppa',
    ExamineAction -> 'vad vill du undersöka',
    ReadAction -> 'vad vill du läsa',
    LookInAction -> 'vad vill du titta i',
    LookUnderAction -> 'vad vill du titta under',
    LookBehindAction -> 'vad vill du titta bakom',
    FeelAction -> 'vad vill du röra',
    TasteAction -> 'vad vill du smaka',
    SmellAction -> 'vad vill du lukta',
    ListenToAction -> 'vad vill du lyssna till',
    SmellImplicitAction -> 'vill du lukta',
    ListenImplicitAction -> 'vill du lyssna',
    KissAction -> 'vem vill du kyssa',
    AskForAction -> 'vem vill du fråga',
    AskAboutAction -> 'vem vill du fråga',
    TellAboutAction -> 'vem vill du berätta för',
    TalkToAction -> 'vem vill du prata med',
    TopicsAction -> 'vill du visa samtalsämnen',
    HelloAction -> 'vill du hälsa',
    GoodbyeAction -> 'vill du ta farväl',
    YesAction -> 'vill du säga ja',
    NoAction -> 'vill du säga nej',
    YellAction -> 'vill du skrika',
    ThrowDirAction -> 'vad vill du kasta?',
    FollowAction -> 'vem vill du följa',
    AttackAction -> 'vem vill du attackera',
    InventoryAction -> 'vill du lista inventarier',
    InventoryTallAction -> 'vill du lista inventarier "högt"',
    InventoryWideAction -> 'vill du lista inventarier "brett"',
    WaitAction -> 'vill du vänta',
    LookAction -> 'vill du titta runt',
    QuitAction -> 'vill du avsluta',
    AgainAction -> 'vill du repetera det sista kommandot',
    FootnoteAction -> 'vill du visa fotnoter?',
    FootnotesFullAction -> 'vill du tillåta alla fotnoter',
    FootnotesMediumAction -> 'vill du tillåta nya fotnoter',
    FootnotesOffAction -> 'vill du gömma fotnoter',
    FootnotesStatusAction -> 'vill du visa status för fotnoter',    
    TipModeAction -> 'vill du aktivera tips',
    VerboseAction -> 'vill du aktivera ORDRIKT läge',
    TerseAction -> 'vill du aktivera KORTFATTAT läge',
    ScoreAction -> 'vill du visa poäng',
    FullScoreAction -> 'vill du visa full poäng',
    NotifyAction -> 'vill du visa notifieringsstatus',
    NotifyOnAction -> 'vill du slå på poängnotifikation',
    NotifyOffAction -> 'vill du stänga av poängnotifikation',
    SaveAction -> 'vill du spara',
    SaveStringAction -> 'vill du spara',
    RestoreAction -> 'vill du ladda',
    RestoreStringAction -> 'vill du ladda',
    SaveDefaultsAction -> 'vill du spara förvalt',
    RestoreDefaultsAction -> 'vill du återställa förvalt',
    RestartAction -> 'vill du starta om',
    PauseAction -> 'vill du pausa',
    UndoAction -> 'vill du ångra',
    VersionAction -> 'vill du visa version',
    CreditsAction -> 'vill du visa omnämnanden',
    AboutAction -> 'vill du visa information om berättelse',
    ScriptAction -> 'vill du starta skriptande',
    ScriptStringAction -> 'vill du starta skriptande',
    ScriptOffAction -> 'vill du avsluta skriptande',
    
    RecordAction -> 'vill du starta händelseinspelning',
    RecordStringAction -> 'vill du starta händelseinspelning',
    RecordEventsAction -> 'vill du starta händelseinspelning',
    RecordEventsStringAction -> 'vill du starta händelseinspelning',

    RecordOffAction -> 'vill du avsluta kommandoinspelning',
    VagueTravelAction -> 'vill du gå',
    TravelAction -> 'vill du gå till',
    PortAction -> 'vill du gå till babord',
    StarboardAction -> 'vill du gå till styrbord',
    InAction -> 'vill du gå in',
    OutAction -> 'vill du gå ut',
    EnterAction -> 'vad vill du gå in i', // TODO: gå in i
    GoBackAction -> 'vill du gå tillbaka',
    DigAction -> 'vad vill du gräva',
    JumpAction -> 'vill du hoppa',
    JumpOffIAction -> 'vill du hoppa av',
    JumpOffAction -> 'vad vill du hoppa av',
    JumpOverAction -> 'vad vill du hoppa över',
    PullAction -> 'vad vill du dra',
    MoveAction -> 'vad vill du flytta',
    TurnAction -> 'vad vill du vrida',
    TurnToAction -> 'vad vill du vrida',
    SetAction -> 'vad vill du ställa',
    SetToAction -> 'vad vill du ställa',
    TypeOnAction -> 'vad vill du skriva på',
    TypeLiteralOnAction -> 'vad vill du skriva',
    ConsultAction -> 'vad vill du konsultera',
    FlipAction -> 'vad vill du vända',
    TurnOnAction -> 'vad vill du vrida på',
    TurnOffAction -> 'vad vill du vrida av',
    LightAction -> 'vad vill du tända',
    StrikeAction -> 'vad vill du slå',
    BurnAction -> 'vad vill du tända',
    BreakAction -> 'vad vill du förstöra',
    EatAction -> 'vad vill du äta',
    DrinkAction -> 'vad vill du dricka',
    PourAction -> 'vad vill du hälla',
    ClimbAction -> 'vad vill du klättra',
    ClimbUpAction -> 'vad vill du kliva upp på',
    ClimbDownAction -> 'vad vill du kliva ner på',
    CleanAction -> 'vad vill du rengöra',
    OpenAction -> 'vad vill du öppna',
    CloseAction -> 'vad vill du stänga',
    LockAction -> 'vad vill du låsa',
    UnlockAction -> 'vad vill du låsa upp',
    SitOnAction -> 'vad vill du sitta på',
    SitAction -> 'vill du sitta ner',
    LieOnAction -> 'vad vill du ligga på',
    LieAction -> 'vill du ligga',
    StandOnAction -> 'vad vill du stå på',
    StandAction -> 'vill du stå',
    GetOutOfAction -> 'vad vill du kliva ut ur',
    GetOffOfAction -> 'vad vill du kliva av från',
    GetOutAction -> 'vill du kliva ut',
    BoardAction -> 'vad vill du borda',
    SleepAction -> 'vill du sova',
    FastenAction -> 'vad vill du fästa',
    UnfastenAction -> 'vad vill du koppla lös',
    PlugInAction -> 'vad vill du koppla in',
    UnplugAction -> 'vad vill du koppla ur',
    ScrewAction -> 'vad vill du skruva på',
    UnscrewAction -> 'vad vill du skruva loss',
    ExitsAction -> 'vill du visa utgångar',
    ExitsModeAction -> 'vill du stänga av av visning av utgångar',
    HintsOffAction -> 'vill du stänga av av ledtrådar',
    HintAction -> 'vill du visa ledtrådar',
    OopsAction -> 'vad vill du rätta',
    OopsIAction -> 'vill du rätta',
    DoffAction -> 'vad vill du ta av',
    WearAction -> 'vad vill du ta på'
  ];

  actionTextPairs.forEachAssoc(function(action, msg) {
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    gTranscript = new CommandTranscript();
    setPlayer(spelare1aPerspektiv);
    gActor = spelare1aPerspektiv;
    gActor.referralPerson = DirectObject;
    gAction = action.createActionInstance();
    gAction.setCurrentObjects([hatt]);
    playerMessages.askMissingLiteral(gActor, gAction, DirectObject);
    gTranscript.showReports(true);
    gTranscript.clearReports();
    assertThat(o.findReplace('  ', ' ', ReplaceAll)).contains(msg);
  });
} skip=nil;

UnitTest 'playerMessages.askMissingObject' run {
  local actionTextPairs = 
  [
      AttackWithAction -> 'vad vill du attackera med',
      DigWithAction -> 'vad vill du gräva med',
      MoveWithAction -> 'vad vill du flytta med',
      TurnWithAction -> 'vad vill du vrida med',
      BurnWithAction-> 'vad vill du tända med',
      CutWithAction -> 'vad vill du klippa med',
      CleanWithAction -> 'vad vill du rengöra med',
      LockWithAction -> 'vad vill du låsa med',
      UnlockWithAction -> 'vad vill du låsa upp med',
      ScrewWithAction -> 'vad vill du skruva med',
      UnscrewWithAction -> 'vad vill du skruva loss med'
  ];
  actionTextPairs.forEachAssoc(function(action, msg) {
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    //mainOutputStream.hideOutput = nil;
    gTranscript = new CommandTranscript();
    setPlayer(pirat);
    gActor = pirat;
    gAction = action.createActionInstance();
    gAction.setCurrentObjects([skapetObjNeutrumSingular, nyckel]);
    playerMessages.askMissingObject(pirat, gAction, IndirectObject);
    gTranscript.showReports(true);
    gTranscript.clearReports();
    //local str = mainOutputStream.captureOutput( {: "<<o>>" });    
    assertThat(o).contains(msg);
  });
} skip=nil;


UnitTest 'npcMessages.askMissingObject' run {
  //mainOutputStream.hideOutput = nil;
  local actionTextPairs = 
  [
      AttackWithAction -> 'vad vill du att apan ska attackera med',
      DigWithAction -> 'vad vill du att apan ska gräva med',
      MoveWithAction -> 'vad vill du att apan ska flytta med',
      TurnWithAction -> 'vad vill du att apan ska vrida med',
      BurnWithAction-> 'vad vill du att apan ska tända med',
      CutWithAction -> 'vad vill du att apan ska klippa med',
      CleanWithAction -> 'vad vill du att apan ska rengöra med',
      LockWithAction -> 'vad vill du att apan ska låsa med',
      UnlockWithAction -> 'vad vill du att apan ska låsa upp med',
      ScrewWithAction -> 'vad vill du att apan ska skruva med',
      UnscrewWithAction -> 'vad vill du att apan ska skruva loss med'
  ];
  actionTextPairs.forEachAssoc(function(action, msg) {
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    gTranscript = new CommandTranscript();
    setPlayer(pirat);
    gActor = pirat;
    gAction = action.createActionInstance();
    gAction.setCurrentObjects([skapetObjNeutrumSingular, nyckel]);
    npcMessages.askMissingObject(apan, gAction, IndirectObject);
    gTranscript.showReports(true);
    gTranscript.clearReports();
    //local str = mainOutputStream.captureOutput( {: "<<o>>" });    
    assertThat(o).contains(msg);
  });
};


UnitTest 'npcDeferredMessagesDirect.askMissingObject' run {
  //mainOutputStream.hideOutput = nil;
  local actionTextPairs = 
  [
      AttackWithAction -> '\^matrosen sade, <q>Jag visste inte vad du ville att jag skulle attackera med.</q>',
      DigWithAction -> '\^matrosen sade, <q>Jag visste inte vad du ville att jag skulle gräva med.</q>',
      MoveWithAction -> '\^matrosen sade, <q>Jag visste inte vad du ville att jag skulle flytta med.</q>',
      TurnWithAction -> '\^matrosen sade, <q>Jag visste inte vad du ville att jag skulle vrida med.</q>',
      BurnWithAction-> '\^matrosen sade, <q>Jag visste inte vad du ville att jag skulle tända med.</q>',
      CutWithAction -> '\^matrosen sade, <q>Jag visste inte vad du ville att jag skulle klippa med.</q>',
      CleanWithAction -> '\^matrosen sade, <q>Jag visste inte vad du ville att jag skulle rengöra med.</q>',
      LockWithAction -> '\^matrosen sade, <q>Jag visste inte vad du ville att jag skulle låsa med.</q>',
      UnlockWithAction -> '\^matrosen sade, <q>Jag visste inte vad du ville att jag skulle låsa upp med.</q>',
      ScrewWithAction -> '\^matrosen sade, <q>Jag visste inte vad du ville att jag skulle skruva med.</q>',
      UnscrewWithAction -> '\^matrosen sade, <q>Jag visste inte vad du ville att jag skulle skruva loss med.</q>'
  ];
  actionTextPairs.forEachAssoc(function(action, msg) {
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    gTranscript = new CommandTranscript();
    setPlayer(pirat);
    gActor = pirat;
    gAction = action.createActionInstance();
    gAction.setCurrentObjects([skapetObjNeutrumSingular, nyckel]);
    npcDeferredMessagesDirect.askMissingObject(matros, gAction, IndirectObject);
    gTranscript.showReports(true);
    gTranscript.clearReports();
    //local str = mainOutputStream.captureOutput( {: "<<o>>" });    
    assertThat(o).contains(msg);
  });
};

UnitTest 'npcMessagesDirect.askMissingObject' run {
  //mainOutputStream.hideOutput = nil;
  local actionTextPairs = 
  [
      AttackWithAction -> '\^matrosen sade, <q>\^vad vill du att jag ska attackera med?</q>',
      DigWithAction -> '\^matrosen sade, <q>\^vad vill du att jag ska gräva med?</q>',
      MoveWithAction -> '\^matrosen sade, <q>\^vad vill du att jag ska flytta med?</q>',
      TurnWithAction -> '\^matrosen sade, <q>\^vad vill du att jag ska vrida med?</q>',
      BurnWithAction-> '\^matrosen sade, <q>\^vad vill du att jag ska tända med?</q>',
      CutWithAction -> '\^matrosen sade, <q>\^vad vill du att jag ska klippa med?</q>',
      CleanWithAction -> '\^matrosen sade, <q>\^vad vill du att jag ska rengöra med?</q>',
      LockWithAction -> '\^matrosen sade, <q>\^vad vill du att jag ska låsa med?</q>',
      UnlockWithAction -> '\^matrosen sade, <q>\^vad vill du att jag ska låsa upp med?</q>',
      ScrewWithAction -> '\^matrosen sade, <q>\^vad vill du att jag ska skruva med?</q>',
      UnscrewWithAction -> '\^matrosen sade, <q>\^vad vill du att jag ska skruva loss med?</q>'
      
  ];
  actionTextPairs.forEachAssoc(function(action, msg) {
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    gTranscript = new CommandTranscript();
    setPlayer(pirat);
    gActor = pirat;
    gAction = action.createActionInstance();
    gAction.setCurrentObjects([skapetObjNeutrumSingular, nyckel]);
    npcMessagesDirect.askMissingObject(matros, gAction, IndirectObject);
    gTranscript.showReports(true);
    gTranscript.clearReports();
    //local str = mainOutputStream.captureOutput( {: "<<o>>" });    
    assertThat(o).contains(msg);
  });
};


// Notering: npcMessagesDirect.missingLiteral 
// anropar direkt
// npcMessagesDirect.missingObject(actor, action, which);
// så det blir exakt samma output


UnitTest 'playerMessages.missingLiteral' run {
  //mainOutputStream.hideOutput = nil;
  local actionTextPairs = 
  [
      AttackWithAction -> ['Var mer specifik om vad du vill attackera med',
                        'Försök, exempelvis, attackera med <q>någonting</q>'],  
      DigWithAction -> ['Var mer specifik om vad du vill gräva med',
                        'Försök, exempelvis, gräva med <q>någonting</q>'],
      MoveWithAction -> ['Var mer specifik om vad du vill flytta med',
                        'Försök, exempelvis, flytta med <q>någonting</q>'],
      TurnWithAction -> ['Var mer specifik om vad du vill vrida med',
                        'Försök, exempelvis, vrida med <q>någonting</q>'],
      BurnWithAction-> ['Var mer specifik om vad du vill tända med',
                        'Försök, exempelvis, tända med <q>någonting</q>'],
      CutWithAction -> ['Var mer specifik om vad du vill klippa med',
                        'Försök, exempelvis, klippa med <q>någonting</q>'],
      CleanWithAction -> ['Var mer specifik om vad du vill rengöra med',
                        'Försök, exempelvis, rengöra med <q>någonting</q>'],
      LockWithAction -> ['Var mer specifik om vad du vill låsa med',
                        'Försök, exempelvis, låsa med <q>någonting</q>'],
      UnlockWithAction -> ['Var mer specifik om vad du vill låsa upp',
                        'Försök, exempelvis, låsa upp med <q>någonting</q>'],
      ScrewWithAction -> ['Var mer specifik om vad du vill skruva med',
                        'Försök, exempelvis, skruva med <q>någonting</q>'],
      UnscrewWithAction -> ['Var mer specifik om vad du vill skruva loss med',
                        'Försök, exempelvis, skruva loss med <q>någonting</q>']
  ];
  actionTextPairs.forEachAssoc(function(action, msg) {
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    gTranscript = new CommandTranscript();
    setPlayer(pirat);
    gActor = pirat;
    gAction = action.createActionInstance();
    gAction.setCurrentObjects([skapetObjNeutrumSingular, nyckel]);
    playerMessages.missingLiteral(matros, gAction, IndirectObject);
    gTranscript.showReports(true);
    gTranscript.clearReports();
    local str = mainOutputStream.captureOutput( {: "<<o>>" }); 
    assertThat(str).contains(msg[1]);
    assertThat(str).contains(msg[2]);
  });
};

UnitTest 'npcMessages.missingLiteral' run {
  //mainOutputStream.hideOutput = nil;
  local actionTextPairs = 
  [
      AttackWithAction -> ['Du behöver vara mer specifik om vad du vill att matrosen ska attackera med',
                        'Till exempel: matrosen, attackera med <q>någonting</q>'],  
      DigWithAction -> ['Du behöver vara mer specifik om vad du vill att matrosen ska gräva med',
                        'Till exempel: matrosen, gräva med <q>någonting</q>'],
      MoveWithAction -> ['Du behöver vara mer specifik om vad du vill att matrosen ska flytta med',
                        'Till exempel: matrosen, flytta med <q>någonting</q>'],
      TurnWithAction -> ['Du behöver vara mer specifik om vad du vill att matrosen ska vrida med',
                        'Till exempel: matrosen, vrida med <q>någonting</q>'],
      BurnWithAction-> ['Du behöver vara mer specifik om vad du vill att matrosen ska tända med',
                        'Till exempel: matrosen, tända med <q>någonting</q>'],
      CutWithAction -> ['Du behöver vara mer specifik om vad du vill att matrosen ska klippa med',
                        'Till exempel: matrosen, klippa med <q>någonting</q>'],
      CleanWithAction -> ['Du behöver vara mer specifik om vad du vill att matrosen ska rengöra med',
                        'Till exempel: matrosen, rengöra med <q>någonting</q>'],
      LockWithAction -> ['Du behöver vara mer specifik om vad du vill att matrosen ska låsa med',
                        'Till exempel: matrosen, låsa med <q>någonting</q>'],
      UnlockWithAction -> ['Du behöver vara mer specifik om vad du vill att matrosen ska låsa upp',
                        'Till exempel: matrosen, låsa upp med <q>någonting</q>'],
      ScrewWithAction -> ['Du behöver vara mer specifik om vad du vill att matrosen ska skruva med',
                        'Till exempel: matrosen, skruva med <q>någonting</q>'],
      UnscrewWithAction -> ['Du behöver vara mer specifik om vad du vill att matrosen ska skruva loss med',
                        'Till exempel: matrosen, skruva loss med <q>någonting</q>']
  ];
  actionTextPairs.forEachAssoc(function(action, msg) {
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    gTranscript = new CommandTranscript();
    setPlayer(pirat);
    gActor = pirat;
    gAction = action.createActionInstance();
    gAction.setCurrentObjects([skapetObjNeutrumSingular, nyckel]);
    npcMessages.missingLiteral(matros, gAction, IndirectObject);
    gTranscript.showReports(true);
    gTranscript.clearReports();
    local str = mainOutputStream.captureOutput( {: "<<o>>" }); 
    assertThat(str).contains(msg[1]);
    assertThat(str).contains(msg[2]);
  });
};

UnitTest 'playerMessages.noMatchForPossessive' run {
  //mainOutputStream.hideOutput = nil;
  setPlayer(pirat);
  gActor = pirat;
  playerMessages.noMatchForPossessive(gActor, apan, nil);
  assertThat(o).contains('\^apan verkade inte ha någon sådan sak.');
};

UnitTest 'playerMessages.noMatchForPluralPossessive' run {
  //mainOutputStream.hideOutput = nil;
  setPlayer(pirat);
  gActor = pirat;
  playerMessages.noMatchForPluralPossessive(gActor, nil);
  assertThat(o).contains('\^de verkade inte ha någon sådan sak');
};

UnitTest 'playerMessages.noMatchForLocation' run {
  //mainOutputStream.hideOutput = nil;
  setPlayer(pirat);
  gActor = pirat;
  gActor.location = masten;
  playerMessages.noMatchForLocation(gActor, masten, 'kikare');
  assertThat(o).contains('\^du såg inget liknande där.');
};

UnitTest 'playerMessages.noMatchForLocation' run {
  //mainOutputStream.hideOutput = nil;
  setPlayer(pirat);
  gActor = pirat;
  gActor.location = masten;
  playerMessages.noMatchForLocation(apan, masten, 'kikare');
  assertThat(o).contains('\^apan såg inget liknande där.');
};

UnitTest 'playerMessages.nothingInLocation 2d' run {
  //mainOutputStream.hideOutput = nil;
  setPlayer(pirat);
  gActor = pirat;
  gActor.location = masten;
  playerMessages.nothingInLocation(gActor, masten);
  assertThat(o).contains('\^du såg inget ovanligt på marken.');
};

UnitTest 'playerMessages.nothingInLocation 3d' run {
  //mainOutputStream.hideOutput = nil;
  setPlayer(pirat);
  gActor = pirat;
  gActor.location = masten;
  playerMessages.nothingInLocation(apan, masten);
  assertThat(o).contains('\^apan såg inget ovanligt på marken.');
};


UnitTest 'playerMessages.nothingInLocation 3d' run {
  //mainOutputStream.hideOutput = nil;
  setPlayer(pirat);
  gActor = pirat;
  gActor.location = masten;
  playerMessages.nothingInLocation(apan, masten);
  assertThat(o).contains('\^apan såg inget ovanligt på marken.');
};

UnitTest 'libMessages' run {
    local pairs = [
      &finishDeathMsg -> 'DU DOG',
      &finishVictoryMsg -> 'DU VANN',
      &finishFailureMsg -> 'DU MISSLYCKADES',
      &finishGameOverMsg -> 'SPELET SLUT'
  ];
  pairs.forEachAssoc(function(msg, expectedOutput) {
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
     "<<libMessages.(msg)>>";
    local str = o.findReplace('  ', ' ', ReplaceAll);
    assertThat(str).isEqualTo(expectedOutput);
  });
};


UnitTest 'playerActionMessages sig/dig' run {
  //mainOutputStream.hideOutput = nil;
    setPlayer(spelare3dePerspektiv);
    gActor = spelare3dePerspektiv;
    gAction = DoffAction.createActionInstance();
    gAction.setCurrentObjects([skapetObjNeutrumSingular]);
    local pairs = [
        &notDoffableMsg -> 'Det där var inte någonting som Bob kunde ta av sig.'
    ];
  pairs.forEachAssoc(function(msg, expectedOutput) {
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
     "<<playerActionMessages.(msg)>>";
    local str = o.findReplace('  ', ' ', ReplaceAll);
    assertThat(str).startsWith(expectedOutput);
  });
};


UnitTest 'playerActionMessages' run {
    //mainOutputStream.hideOutput = nil;
    setPlayer(pirat);
    gActor = pirat;
    gAction = UnlockWithAction.createActionInstance();
    gAction.setCurrentObjects([tingest, sak]);
    local pairs = [
      &cannotDoThatMsg -> 'Du kunde inte göra det.',
      &tooDarkMsg -> 'Det var för mörkt för att göra det.',
      &noKeyNeededMsg -> 'Tingesten verkade inte behöva en nyckel',
      &mustBeStandingMsg -> 'Du behövde stå upp före du kunde göra det.',
      &nothingInsideMsg -> 'Det var inget ovanligt i tingesten.',
      &nothingUnderMsg -> 'Du såg inget ovanligt under tingesten.',
      &nothingBehindMsg -> 'Du såg inget ovanligt bakom tingesten',
      &nothingThroughMsg -> 'Du såg ingenting genom tingesten',
      &cannotLookBehindMsg -> 'Du kunde inte se bakom tingesten',
      &cannotLookUnderMsg -> 'Du kunde inte se under tingesten',
      &cannotLookThroughMsg -> 'Du kunde inte se genom tingesten',
      &nothingThroughPassageMsg -> 'Du kunde inte se mycket genom tingesten därifrån',
      &nothingBeyondDoorMsg -> 'Du öppnade tingesten och fann ingenting ovanligt.',

      &nothingToSmellMsg -> 'Du kände ingen oväntad lukt.',
      &nothingToHearMsg -> 'Du hörde inget oväntat.',
      &notWearableMsg -> 'Den där var inte någonting som du kunde klä på dig.',
      &notDoffableMsg -> 'Den där var inte någonting som du kunde ta av dig.',
      &alreadyWearingMsg -> 'Du bar redan tingesten.',
      &notWearingMsg -> 'Du hade inte på dig den.',
      &okayWearMsg -> 'Okej, du klädde på dig tingesten',
      &okayDoffMsg -> 'Okej, du tog av dig tingesten',
      &okayOpenMsg -> 'Öppnad.',
      &okayCloseMsg -> 'Stängd.',
      &okayLockMsg -> 'Låst.',
      &okayUnlockMsg -> 'Upplåst.',
      &cannotDigMsg -> 'Du hade ingen anledning att gräva i den där.',
      &cannotDigWithMsg -> 'Du såg inget sätt att använda den så som en spade.',
      &alreadyHoldingMsg -> 'Du höll redan tingesten.',
      &takingSelfMsg -> 'Du kunde inte plocka upp dig själv',
      &notCarryingMsg -> 'Du bär inte på den.',
      &droppingSelfMsg -> 'Du kunde inte släppa dig själv.',
      &puttingSelfMsg -> 'Du kunde inte göra det med dig själv.',
      &throwingSelfMsg -> 'Du kunde inte kasta dig själv.',
      &alreadyPutInMsg -> 'Tingesten var redan i saken.',
      &alreadyPutOnMsg -> 'Tingesten var redan på saken.',
      &alreadyPutUnderMsg -> 'Tingesten var redan under saken.',
      &alreadyPutBehindMsg -> 'Tingesten var redan bakom saken.',
      &cannotMoveFixtureMsg -> 'Tingesten kunde inte flyttas',
      &cannotTakeFixtureMsg -> 'Du kunde inte ta den.',
      &cannotPutFixtureMsg -> 'Du kunde inte stoppa tingesten någonstans',
      &cannotTakeImmovableMsg -> 'Du kunde inte ta den.',
      &cannotMoveImmovableMsg -> 'Tingesten kunde inte flyttas.',
      &cannotPutImmovableMsg -> 'Du kunde inte stoppa tingesten någonstans',
      &cannotTakeHeavyMsg -> 'Den var för tung.',
      &cannotMoveHeavyMsg -> 'Den var för tung.',
      &cannotPutHeavyMsg -> 'Den var för tung.',
      &cannotTakePushableMsg -> 'Du kunde inte ta den, men det kan vara möjligt att knuffa den någonstans.',
      &cannotMovePushableMsg -> 'Det skulle inte ha åstadkommit någonting att flytta runt tingesten riktningslöst, men det kanske var möjligt att flytta den i en specifik riktning.',
      &cannotPutPushableMsg -> 'Du kunde inte stoppa den någonstans, men det kunde vara möjligt att knuffa den någonstans.',
      &cannotTakeLocationMsg -> 'Du kunde inte plocka upp den medan du uppehåller den',
      &cannotRemoveHeldMsg -> 'Det fanns ingenting att ta bort tingesten ifrån.',
      &okayTakeMsg -> 'Tagen.',
      &okayDropMsg -> 'Släppt.',
      &okayPutInMsg -> 'Gjort.',
      &okayPutOnMsg -> 'Gjort.',
      &okayPutUnderMsg -> 'Gjort.',
      &okayPutBehindMsg -> 'Gjort.',

      &cannotTakeActorMsg -> 'Tingesten låter inte dig göra det.',
      &cannotMoveActorMsg -> 'Tingesten låter inte dig göra det.',
      &cannotPutActorMsg -> 'Tingesten låter inte dig göra det.',
      &cannotTasteActorMsg -> 'Tingesten låter inte dig göra det.',
      &cannotTakePersonMsg -> 'Tingesten skulle antagligen inte ha uppskattat det.',
      &cannotMovePersonMsg -> 'Tingesten skulle antagligen inte ha uppskattat det.',
      &cannotPutPersonMsg -> 'Tingesten skulle antagligen inte ha uppskattat det.',
      &cannotTastePersonMsg -> 'Tingesten skulle antagligen inte ha uppskattat det.',

      &notAContainerMsg -> 'Du kunde inte stoppa någonting i saken.',
      &notASurfaceMsg -> 'Det fanns ingen bra yta på saken.',
      &cannotPutUnderMsg -> 'Du kunde inte stoppa någonting under den.',
      &cannotPutBehindMsg -> 'Du kunde inte stoppa in någonting bakom saken.',
      &cannotPutInSelfMsg -> 'Du kunde inte stoppa tingesten i sig själv.',
      &cannotPutOnSelfMsg -> 'Du kunde inte stoppa tingesten på sig själv.',
      &cannotPutUnderSelfMsg -> 'Du kunde inte stoppa tingesten under sig själv.',
      &cannotPutBehindSelfMsg -> 'Du kunde inte stoppa tingesten bakom sig själv.',
      &cannotPutInRestrictedMsg -> 'Du kunde inte stoppa den i saken.',
      &cannotPutOnRestrictedMsg -> 'Du kunde inte stoppa den på saken.',
      &cannotPutUnderRestrictedMsg -> 'Du kunde inte stoppa den under saken.',
      &cannotPutBehindRestrictedMsg -> 'Du kunde inte stoppa den bakom saken.',
      &cannotReturnToDispenserMsg -> 'Du kunde inte stoppa tillbaka en tingest i saken.',
      &cannotPutInDispenserMsg -> 'Du kunde inte stoppa en tingest i saken.',
      &objNotForKeyringMsg -> 'Tingesten passar inte på saken.',
      &keyNotOnKeyringMsg -> 'Tingesten satt inte fast i saken.',
      &keyNotDetachableMsg -> 'Tingesten satt inte fast i någonting.',
      &takeFromNotInMsg -> 'Tingesten var inte i den.',
      &takeFromNotOnMsg -> 'Tingesten var inte på den.',
      &takeFromNotUnderMsg -> 'Tingesten var inte under den.',
      &takeFromNotBehindMsg -> 'Tingesten var inte bakom den.',
      &takeFromNotInActorMsg -> 'Saken hade inte den.',
      &whereToGoMsg -> 'Du behöver ange vilken väg att gå',
      &cannotGoThatWayMsg -> 'Du kunde inte gå ditåt.',
      &cannotGoThatWayInDarkMsg -> 'Det var för mörkt; du kunde inte se var du gick.',
      &cannotGoBackMsg -> 'Du visste inte hur man återvände därifrån.',
      &cannotDoFromHereMsg -> 'Du kunde inte göra det därifrån.',
      &stairwayNotUpMsg -> 'Tingesten gick bara ner därifrån.',
      &stairwayNotDownMsg -> 'Tingesten gick bara upp därifrån.',
      //&timePassesMsg -> 'Tiden gick...',
      &sayHelloMsg -> 'Du behövde vara mer specifik om vem du ville prata med.',
      &sayGoodbyeMsg -> 'Du behövde vara mer specifik om vem du ville prata med.',
      &sayYesMsg -> 'Du behövde vara mer specifik om vem du ville prata med.',
      &sayNoMsg -> 'Du behövde vara mer specifik om vem du ville prata med.',
      &okayYellMsg -> 'Du skrek så högt du bara kunde.',
      &okayJumpMsg -> 'Du hoppade och landade på samma ställe.',
      &cannotJumpOverMsg -> 'Du kunde inte hoppa över den.',
      &cannotJumpOffMsg -> 'Du kunde inte hoppa av den.',
      &cannotJumpOffHereMsg -> 'Det fanns ingenting att hoppa från därifrån.',
      &cannotFindTopicMsg -> 'Du verkade inte kunna hitta det i tingesten.',
      &giveAlreadyHasMsg -> 'Saken hade redan den.',
      &cannotTalkToSelfMsg -> 'Att prata med dig själv skulle inte ha åstadkommit någonting.',
      &cannotAskSelfMsg -> 'Att prata med dig själv skulle inte ha åstadkommit någonting.',
      &cannotAskSelfForMsg -> 'Att prata med dig själv skulle inte ha åstadkommit någonting.',
      &cannotTellSelfMsg -> 'Att prata med dig själv skulle inte ha åstadkommit någonting.',
      &cannotGiveToSelfMsg -> 'Att ge tingesten till dig själv skulle inte ha åstadkommit någonting.',
      &cannotGiveToItselfMsg -> 'Att ge tingesten till dig själv skulle inte ha åstadkommit någonting.',
      &cannotShowToSelfMsg -> 'Att visa tingesten för dig själv skulle inte ha åstadkommit någonting.',
      &cannotShowToItselfMsg -> 'Att visa tingesten för sig själv skulle inte ha åstadkommit någonting.',
      &cannotGiveToMsg -> 'Du kunde inte ge någonting till en sak',
      &cannotShowToMsg -> 'Du kunde inte visa någonting för en sak',
      //&askVagueMsg -> '-',
      //&tellVagueMsg -> '-',
      &notFollowableMsg -> 'Du kunde inte följa den.',
      &cannotFollowSelfMsg -> 'Du kunde inte följa dig själv.',
      &followAlreadyHereMsg -> 'Tingesten var precis där.',
      &followAlreadyHereInDarkMsg -> 'Tingesten borde varit precis där, men du kunde inte se den.',
      &followUnknownMsg -> 'Du var inte säker på var tingesten hade gått därifrån.',
      &notAWeaponMsg -> 'Du kunde inte attackera någonting med saken',
      &uselessToAttackMsg -> 'Du kunde inte attackera den.',
      &pushNoEffectMsg -> 'Att trycka på tingesten hade ingen effekt.',
      //&okayPushButtonMsg -> '-',
      &alreadyPushedMsg -> 'Tingesten var redan intryckt så långt det gick.',
      &okayPushLeverMsg -> 'Du tryckte tingesten till dess stopp.',
      &pullNoEffectMsg -> 'Att dra i tingesten hade ingen effekt.',
      &alreadyPulledMsg -> 'Tingesten var redan dragen så långt det gick.',
      &okayPullLeverMsg -> 'Du drog tingesten till dess stopp.',
      &okayPullSpringLeverMsg -> 'Du drog tingesten, som fjädrade tillbaka till dess startposition så snart som du släppte taget om den.',
      &moveNoEffectMsg -> 'Att flytta tingesten skulle inte ge någon effekt.',
      &moveToNoEffectMsg -> 'Detta skulle inte ha åstadkommit någonting.',
      &cannotPushTravelMsg -> 'Detta skulle inte ha åstadkommit någonting.',
      &cannotMoveWithMsg -> 'Du kunde inte flytta någonting med saken.',
      &cannotSetToMsg -> 'Du kunde inte ställa den till någonting.',
      &setToInvalidMsg -> 'Tingesten hade ingen sådan inställning.',
      &cannotTurnMsg -> 'Du kunde inte vrida den.',
      &mustSpecifyTurnToMsg -> 'Du behöver vara tydlig med vilken inställning du vill sätta den till.',
      &cannotTurnWithMsg -> 'Du kunde inte vrida någonting med den.',
      &turnToInvalidMsg -> 'Tingesten hade ingen sådan inställning.',
      &alreadySwitchedOnMsg -> 'Tingesten var redan på.',
      &alreadySwitchedOffMsg -> 'Tingesten var redan av.',
      &okayTurnOnMsg -> 'Okej, tingesten var nu på.',
      &okayTurnOffMsg -> 'Okej, tingesten var nu av.',
      &flashlightOnButDarkMsg -> 'Du slog på tingesten, men ingenting verkade hända.',
      &okayEatMsg -> 'Du åt tingesten.',
      &matchNotLitMsg -> 'Tingesten var inte tänd',
      &okayBurnMatchMsg -> 'Du drog an tingesten och tände en liten låga',
      &okayExtinguishMatchMsg -> 'Du släckte tingesten, som försvann i en moln av aska.',
      &candleOutOfFuelMsg -> 'Tingesten var för nedbrunnen; den kunde inte tändas.',
      &okayBurnCandleMsg -> 'Du tände tingesten.',
      &candleNotLitMsg -> 'Tingesten var inte tänd.',
      &okayExtinguishCandleMsg -> 'Gjort.',
      &cannotConsultMsg -> 'Den var ingenting du kunde konsultera.',
      &cannotTypeOnMsg -> 'Du kunde inte skriva någonting på den.',
      &cannotEnterOnMsg -> 'Du kunde inte knappa in någonting på den.',
      &cannotSwitchMsg -> 'Du kunde inte ändra på den.',
      &cannotFlipMsg -> 'Du kunde inte vända den.',
      &cannotTurnOnMsg -> 'Den var inte någonting som du kunde slå på.',
      &cannotTurnOffMsg -> 'Den var inte någonting som du kunde stänga av.',
      &cannotLightMsg -> 'Du kunde inte tända den.',
      &cannotBurnMsg -> 'Den var inte någonting du kunde elda',
      &cannotBurnWithMsg -> 'Du kunde inte elda någonting med den',
      &cannotBurnDobjWithMsg -> 'Du kunde inte tända tingesten med saken.',
      &alreadyBurningMsg -> 'Tingesten brann redan.',
      &cannotExtinguishMsg -> 'Du kunde inte släcka den.',
      &cannotPourMsg -> 'Den var inte någonting du kunde hälla.',
      &cannotPourIntoMsg -> 'Du kunde inte hälla någonting i den.',
      &cannotPourOntoMsg -> 'Du kunde inte hälla någonting på den.',
      &cannotAttachMsg -> 'Du kunde inte fästa den på någonting.',
      &cannotAttachToMsg -> 'Du kunde inte fästa någonting på den.',
      &cannotAttachToSelfMsg -> 'Du kunde inte fästa tingesten på sig själv.',
      &alreadyAttachedMsg -> 'Tingesten var redan fäst med saken.',
      &wrongAttachmentMsg -> 'Du kunde inte fästa den på saken.',
      &wrongDetachmentMsg -> 'Du kunde inte koppla loss den från saken.',
      &okayAttachToMsg -> 'Gjort.',
      &okayDetachFromMsg -> 'Gjort.',
      &cannotDetachMsg -> 'Du kunde inte koppla loss den.',
      &cannotDetachFromMsg -> 'Du kunde inte ta loss någonting från den.',
      &cannotDetachPermanentMsg -> 'Det fanns inget uppenbart sätt att ta loss den.',
      &notAttachedToMsg -> 'Tingesten satt inte fast i den.',
      &shouldNotBreakMsg -> 'Att ha sönder den skulle inte ha tjänat något syfte.',
      &cutNoEffectMsg -> 'Saken verkade inte kunna skära tingesten.',
      &cannotCutWithMsg -> 'Du kunde inte skära någonting med saken.',
      &cannotClimbMsg -> 'Den var inte någonting du kunde klättra på.',
      &cannotOpenMsg -> 'Den var inte någonting du kunde öppna.',
      &cannotCloseMsg -> 'Den var inte någonting du kunde stänga.',
      &alreadyOpenMsg -> 'Tingesten var redan öppen.',
      &alreadyClosedMsg -> 'Tingesten var redan stängd.',
      &alreadyLockedMsg -> 'Tingesten var redan låst.',
      &alreadyUnlockedMsg -> 'Tingesten var redan olåst.',
      &cannotLookInClosedMsg -> 'Tingesten var stängd.',
      &cannotLockMsg -> 'Den var inte någonting du kunde låsa.',
      &cannotUnlockMsg -> 'Den var inte någonting du kunde låsa upp.',
      &cannotOpenLockedMsg -> 'Tingesten verkade vara låst.',
      &unlockRequiresKeyMsg -> 'Du verkade behöva en nyckel för att låsa upp tingesten.',
      &cannotLockWithMsg -> 'Saken såg inte lämplig ut att kunna låsa tingesten med.',
      &cannotUnlockWithMsg -> 'Saken såg inte lämplig ut att kunna låsa upp tingesten med.',
      &unknownHowToLockMsg -> 'Det var inte tydligt på vilket sätt tingesten skulle låsas.',
      &unknownHowToUnlockMsg -> 'Det var inte tydligt på vilket sätt tingesten skulle låsas upp.',
      &keyDoesNotFitLockMsg -> 'Saken passade inte låset.',
      &cannotEatMsg -> 'Tingesten verkade inte vara ätbar.',
      &cannotDrinkMsg -> 'Tingesten verkade inte vara något du kunde dricka.',
      &cannotCleanMsg -> 'Du skulle inte veta hur den skulle rengöras.',
      &cannotCleanWithMsg -> 'Du kunde inte rengöra någonting med den.',
      &cannotAttachKeyToMsg -> 'Du kunde inte fästa tingesten i den.',
      &cannotSleepMsg -> 'Du behövde inte sova just nu.',
      &cannotSitOnMsg -> 'Den var inte någonting som du kunde sitta på.',
      &cannotLieOnMsg -> 'Den var inte någonting som du kunde ligga på.',
      &cannotStandOnMsg -> 'Du kunde inte stå på den.',
      &cannotBoardMsg -> 'Du kunde inte kliva ombord på den.',
      &cannotUnboardMsg -> 'Du kunde inte kliva ut ur den.',
      &cannotGetOffOfMsg -> 'Du kunde inte kliva av från den.',
      &cannotStandOnPathMsg -> 'Om du ville följa tingesten, säg bara det.',
      &cannotEnterHeldMsg -> 'Du kunde inte göra det medan du höll i tingesten.',
      &cannotGetOutMsg -> 'Du var inte i någonting som du kunde kliva ur från.',
      &alreadyInLocMsg -> 'Du var redan i tingesten.',
      &alreadyStandingMsg -> 'Du stod redan.',
      &alreadyStandingOnMsg -> 'Du stod redan i tingesten.',
      &alreadySittingMsg -> 'Du satt redan ner.',
      &alreadySittingOnMsg -> 'Du satt redan i tingesten.',
      &alreadyLyingMsg -> 'Du låg redan ner.',
      &alreadyLyingOnMsg -> 'Du låg redan ner i tingesten.',
      &notOnPlatformMsg -> 'Du var inte i tingesten.',
      &noRoomToStandMsg -> 'Det fanns inte rum för dig att stå i tingesten.',
      &noRoomToSitMsg -> 'Det fanns inte rum för dig att sitta i tingesten.',
      &noRoomToLieMsg -> 'Det fanns inte rum för dig att ligga i tingesten.',
      &okayNotStandingOnMsg -> 'Ok, du var inte längre i tingesten.',
      &cannotFastenMsg -> 'Du kunde inte fästa tingesten',
      &cannotFastenToMsg -> 'Du kunde inte fästa någonting på saken.',
      &cannotUnfastenMsg -> 'Du kunde inte ta loss tingesten.',
      &cannotUnfastenFromMsg -> 'Du kunde inte ta loss någonting från saken.',
      &cannotPlugInMsg -> 'Du såg inget sätt att koppla in tingesten.',
      &cannotPlugInToMsg -> 'Du såg inget sätt att koppla in någonting i saken.',
      &cannotUnplugMsg -> 'Du såg inget sätt att koppla loss tingesten.',
      &cannotUnplugFromMsg -> 'Du såg inget sätt att la loss någonting från saken.',
      &cannotScrewMsg -> 'Du såg inget sätt att skruva tingesten.',
      &cannotScrewWithMsg -> 'Du kunde inte skruva något med saken.',
      &cannotUnscrewMsg -> 'Du visste inget sätt att skruva loss tingesten.',
      &cannotUnscrewWithMsg -> 'Du kunde inte skruva loss något med saken.',
      &cannotEnterMsg -> 'Den var inte någonting du kunde gå in i.',
      &cannotGoThroughMsg -> 'Den var inte någonting du kunde gå genom.',
      &cannotThrowAtSelfMsg -> 'Du kunde inte kasta den på dig själv.',
      &cannotThrowAtContentsMsg -> 'Du behövde ta bort saken från tingesten före du kunde göra det.',
      &shouldNotThrowAtFloorMsg -> 'Du borde bara lagt ner den istället.',
      &dontThrowDirMsg -> 'Du behöver vara mer specifik om vad du ska kasta tingesten mot.',
      &cannotThrowToMsg -> 'Du kunde inte kasta någonting till en sak.',
      &cannotKissMsg -> 'Att kyssa tingesten hade ingen uppenbar effekt.',
      &cannotKissSelfMsg -> 'Du kunde inte kyssa dig själv.',
      &newlyDarkMsg -> 'Det var nu kolsvart.'
  ];
  pairs.forEachAssoc(function(msg, expectedOutput) {
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
     "<<playerActionMessages.(msg)>>";
     
    local str = o.findReplace('  ', ' ', ReplaceAll);
    
    assertThat(str).startsWith(expectedOutput);
  });
};


UnitTest 'npcActionMessages' run {
    //mainOutputStream.hideOutput = nil;
    setPlayer(pirat);
    gActor = spelare3dePerspektiv;
    gAction = UnlockWithAction.createActionInstance();
    gAction.setCurrentObjects([tingest, sak]);
    local pairs = [
      &cannotDoThatMsg -> 'Bob kunde inte göra det.',
      &tooDarkMsg -> 'Det var för mörkt för att göra det.',
      &noKeyNeededMsg -> 'Tingesten verkade inte behöva en nyckel',
      &mustBeStandingMsg -> 'Bob behövde stå upp före han kunde göra det.',
      &nothingInsideMsg -> 'Det var inget ovanligt i tingesten.',
      &nothingUnderMsg -> 'Bob såg inget ovanligt under tingesten.',
      &nothingBehindMsg -> 'Bob såg inget ovanligt bakom tingesten',
      &nothingThroughMsg -> 'Bob såg ingenting genom tingesten',
      &cannotLookBehindMsg -> 'Bob kunde inte se bakom tingesten',
      &cannotLookUnderMsg -> 'Bob kunde inte se under tingesten',
      &cannotLookThroughMsg -> 'Bob kunde inte se genom tingesten',
      &nothingThroughPassageMsg -> 'Bob kunde inte se mycket genom tingesten därifrån',
      &nothingBeyondDoorMsg -> 'Bob öppnade tingesten och fann ingenting ovanligt.',

      &nothingToSmellMsg -> 'Bob kände ingen oväntad lukt.',
      &nothingToHearMsg -> 'Bob hörde inget oväntat.',
      &notWearableMsg -> 'Den där var inte någonting som Bob kunde klä på sig.',
      &notDoffableMsg -> 'Den där var inte någonting som Bob kunde ta av sig.',
      &alreadyWearingMsg -> 'Bob bar redan tingesten.',
      &notWearingMsg -> 'Bob hade inte på sig den.',
      &okayWearMsg -> 'Bob klädde på sig tingesten',
      &okayDoffMsg -> 'Bob tog av sig tingesten',
      &okayOpenMsg -> 'Bob öppnade tingesten.',
      &okayCloseMsg -> 'Bob stängde tingesten.',
      &okayLockMsg -> 'Bob låste tingesten.',
      &okayUnlockMsg -> 'Bob låste upp tingesten.',
      &cannotDigMsg -> 'Bob hade ingen anledning att gräva i den där.',
      &cannotDigWithMsg -> 'Bob såg inget sätt att använda den så som en spade.',
      &alreadyHoldingMsg -> 'Bob höll redan tingesten.',
      &takingSelfMsg -> 'Bob kunde inte plocka upp sig själv',
      &notCarryingMsg -> 'Bob bär inte på den.',
      &droppingSelfMsg -> 'Bob kunde inte släppa sig själv.',
      &puttingSelfMsg -> 'Bob kunde inte göra det med sig själv.',
      &throwingSelfMsg -> 'Bob kunde inte kasta sig själv.',
      &alreadyPutInMsg -> 'Tingesten var redan i saken.',
      &alreadyPutOnMsg -> 'Tingesten var redan på saken.',
      &alreadyPutUnderMsg -> 'Tingesten var redan under saken.',
      &alreadyPutBehindMsg -> 'Tingesten var redan bakom saken.',
      &cannotMoveFixtureMsg -> 'Bob kunde inte flytta den.',
      &cannotTakeFixtureMsg -> 'Bob kunde inte ta den.',
      &cannotPutFixtureMsg -> 'Bob kunde inte stoppa tingesten någonstans',
      &cannotTakeImmovableMsg -> 'Bob kunde inte ta den.',
      &cannotMoveImmovableMsg -> 'Bob kunde inte flytta tingesten.',
      &cannotPutImmovableMsg -> 'Bob kunde inte stoppa tingesten någonstans',
      &cannotTakeHeavyMsg -> 'Den var för tung för Bob att ta.',
      &cannotMoveHeavyMsg -> 'Den var för tung för Bob att flytta.',
      &cannotPutHeavyMsg -> 'Den var för tung för Bob att flytta.',
      &cannotTakePushableMsg -> 'Bob kunde inte ta den, men det kan vara möjligt att knuffa den någonstans.',
      &cannotMovePushableMsg -> 'Det skulle inte ha åstadkommit någonting att flytta runt tingesten riktningslöst, men det kanske var möjligt att flytta den i en specifik riktning.',
      &cannotPutPushableMsg -> 'Bob kunde inte stoppa den någonstans, men det kunde vara möjligt att knuffa den någonstans.',
      &cannotTakeLocationMsg -> 'Bob kunde inte plocka upp den medan Bob uppehåller den',
      &cannotRemoveHeldMsg -> 'Det fanns ingenting att ta bort tingesten ifrån.',
      &okayTakeMsg -> 'Bob tog tingesten.',
      &okayDropMsg -> 'Bob satte ner tingesten.',
      &okayPutInMsg -> 'Bob satte tingesten i saken.',
      &okayPutOnMsg -> 'Bob satte tingesten på saken.',
      &okayPutUnderMsg -> 'Bob satte tingesten under saken.',
      &okayPutBehindMsg -> 'Bob satte tingesten bakom saken.',

      &cannotTakeActorMsg -> 'Tingesten låter inte Bob göra det.',
      &cannotMoveActorMsg -> 'Tingesten låter inte Bob göra det.',
      &cannotPutActorMsg -> 'Tingesten låter inte Bob göra det.',
      &cannotTasteActorMsg -> 'Tingesten låter inte Bob göra det.',
      &cannotTakePersonMsg -> 'Tingesten skulle antagligen inte ha uppskattat det.',
      &cannotMovePersonMsg -> 'Tingesten skulle antagligen inte ha uppskattat det.',
      &cannotPutPersonMsg -> 'Tingesten skulle antagligen inte ha uppskattat det.',
      &cannotTastePersonMsg -> 'Tingesten skulle antagligen inte ha uppskattat det.',

      &notAContainerMsg -> 'Bob kunde inte stoppa någonting i saken.',
      &notASurfaceMsg -> 'Det fanns ingen bra yta på saken.',
      &cannotPutUnderMsg -> 'Bob kunde inte stoppa någonting under den.',
      &cannotPutBehindMsg -> 'Bob kunde inte stoppa in någonting bakom saken.',
      &cannotPutInSelfMsg -> 'Bob kunde inte stoppa tingesten i sig själv.',
      &cannotPutOnSelfMsg -> 'Bob kunde inte stoppa tingesten på sig själv.',
      &cannotPutUnderSelfMsg -> 'Bob kunde inte stoppa tingesten under sig själv.',
      &cannotPutBehindSelfMsg -> 'Bob kunde inte stoppa tingesten bakom sig själv.',
      &cannotPutInRestrictedMsg -> 'Bob kunde inte stoppa den i saken.',
      &cannotPutOnRestrictedMsg -> 'Bob kunde inte stoppa den på saken.',
      &cannotPutUnderRestrictedMsg -> 'Bob kunde inte stoppa den under saken.',
      &cannotPutBehindRestrictedMsg -> 'Bob kunde inte stoppa den bakom saken.',
      &cannotReturnToDispenserMsg -> 'Bob kunde inte stoppa tillbaka en tingest i saken.',
      &cannotPutInDispenserMsg -> 'Bob kunde inte stoppa en tingest i saken.',
      &objNotForKeyringMsg -> 'Bob kunde inte göra det för att den fick inte plats i saken.',
      &keyNotOnKeyringMsg -> 'Tingesten satt inte fast i saken.',
      &keyNotDetachableMsg -> 'Tingesten satt inte fast i någonting.',
      &takeFromNotInMsg -> 'Bob kunde inte göra det för att tingesten var inte i den.',
      &takeFromNotOnMsg -> 'Bob kunde inte göra det för att tingesten var inte på den.',
      &takeFromNotUnderMsg -> 'Bob kunde inte göra det för att tingesten var inte under den.',
      &takeFromNotBehindMsg -> 'Bob kunde inte göra det för att tingesten var inte bakom den.',
      &takeFromNotInActorMsg -> 'Saken hade inte den.',
      &whereToGoMsg -> 'Du skulle behöva säga vilken väg Bob skulle ha gått.',
      &cannotGoThatWayMsg -> 'Bob kunde inte gå ditåt.',
      &cannotGoThatWayInDarkMsg -> 'Det var för mörkt; Bob kunde inte se var han gick.',
      &cannotGoBackMsg -> 'Bob visste inte hur man återvände därifrån.',
      &cannotDoFromHereMsg -> 'Bob kunde inte göra det därifrån.',
      &stairwayNotUpMsg -> 'Tingesten gick bara ner därifrån.',
      &stairwayNotDownMsg -> 'Tingesten gick bara upp därifrån.',
      //&timePassesMsg -> 'Tiden gick...',
      &sayHelloMsg -> 'Bob behövde vara mer specifik om vem han ville prata med.',
      &sayGoodbyeMsg -> 'Bob behövde vara mer specifik om vem han ville prata med.',
      &sayYesMsg -> 'Bob behövde vara mer specifik om vem han ville prata med.',
      &sayNoMsg -> 'Bob behövde vara mer specifik om vem han ville prata med.',
      &okayYellMsg -> 'Bob skrek så högt han bara kunde.',
      &okayJumpMsg -> 'Bob hoppade och landade på samma ställe.',
      &cannotJumpOverMsg -> 'Bob kunde inte hoppa över den.',
      &cannotJumpOffMsg -> 'Bob kunde inte hoppa av den.',
      &cannotJumpOffHereMsg -> 'Det fanns ingenstans för Bob att hoppa av.',
      &cannotFindTopicMsg -> 'Bob verkade inte kunna hitta det i tingesten.',
      &giveAlreadyHasMsg -> 'Saken hade redan den.',
      &cannotTalkToSelfMsg -> 'Bob kommer inte åstadkomma någonting genom att prata med sig själv.',
      &cannotAskSelfMsg -> 'Bob kommer inte åstadkomma någonting genom att prata med sig själv.',
      &cannotAskSelfForMsg -> 'Bob kommer inte åstadkomma någonting genom att prata med sig själv.',
      &cannotTellSelfMsg -> 'Bob kommer inte åstadkomma någonting genom att prata med sig själv.',
      &cannotGiveToSelfMsg -> 'Bob kommer inte åstadkomma någonting genom att ge tingesten till sig själv.',
      &cannotGiveToItselfMsg -> 'Att ge tingesten till sig själv skulle inte ha åstadkommit någonting.',
      &cannotShowToSelfMsg -> 'Bob kommer inte åstadkomma någonting genom att visa tingesten för sig själv.',
      &cannotShowToItselfMsg -> 'Att visa tingesten för sig själv skulle inte ha åstadkommit någonting.',
      &cannotGiveToMsg -> 'Bob kunde inte ge någonting till en sak',
      &cannotShowToMsg -> 'Bob kunde inte visa någonting för en sak',
      //&askVagueMsg -> '-',
      //&tellVagueMsg -> '-',
      &notFollowableMsg -> 'Bob kunde inte följa den.',
      &cannotFollowSelfMsg -> 'Bob kunde inte följa sig själv.',
      &followAlreadyHereMsg -> 'Tingesten var precis där.',
      &followAlreadyHereInDarkMsg -> 'Tingesten borde varit precis där, men Bob kunde inte se den.',
      &followUnknownMsg -> 'Bob var inte säker på var tingesten hade gått därifrån.',
      &notAWeaponMsg -> 'Bob kunde inte attackera någonting med saken',
      &uselessToAttackMsg -> 'Bob kunde inte attackera den.',
      &pushNoEffectMsg -> 'Bob försökte att knuffa tingesten, utan någon uppenbar effekt.',
      //&okayPushButtonMsg -> '-',
      &alreadyPushedMsg -> 'Tingesten var redan intryckt så långt det gick.',
      &okayPushLeverMsg -> 'Bob tryckte tingesten till dess stopp.',
      &pullNoEffectMsg -> 'Bob försökte att dra tingesten, utan någon uppenbar effekt.',
      &alreadyPulledMsg -> 'Tingesten var redan dragen så långt det gick.',
      &okayPullLeverMsg -> 'Bob drog tingesten till dess stopp.',
      &okayPullSpringLeverMsg -> 'Bob drog tingesten, som fjädrade tillbaka till dess startposition så snart som Bob släppte taget om den.',
      &moveNoEffectMsg -> 'Bob försökte att flytta tingesten, utan någon uppenbar effekt.',
      &moveToNoEffectMsg -> 'Bob lämnade tingesten där tingesten var.',
      &cannotPushTravelMsg -> 'Detta skulle inte ha åstadkommit någonting.',
      &cannotMoveWithMsg -> 'Bob kunde inte flytta någonting med saken.',
      &cannotSetToMsg -> 'Bob kunde inte ställa den till någonting.',
      &setToInvalidMsg -> 'Tingesten hade ingen sådan inställning.',
      &cannotTurnMsg -> 'Bob kunde inte vrida den.',
      &mustSpecifyTurnToMsg -> 'Bob behöver vara tydlig med vilken inställning Bob vill sätta den till.',
      &cannotTurnWithMsg -> 'Bob kunde inte vrida någonting med den.',
      &turnToInvalidMsg -> 'Tingesten hade ingen sådan inställning.',
      &alreadySwitchedOnMsg -> 'Tingesten var redan på.',
      &alreadySwitchedOffMsg -> 'Tingesten var redan av.',
      &okayTurnOnMsg -> 'Bob slog på tingesten',
      &okayTurnOffMsg -> 'Bob slog av tingesten',
      &flashlightOnButDarkMsg -> 'Bob slog på tingesten, men ingenting verkade hända.',
      &okayEatMsg -> 'Bob åt tingesten.',
      &matchNotLitMsg -> 'Tingesten var inte tänd',
      &okayBurnMatchMsg -> 'Bob drog an tingesten och tände en liten låga',
      &okayExtinguishMatchMsg -> 'Bob släckte tingesten, som försvann i en moln av aska.',
      &candleOutOfFuelMsg -> 'Tingesten var för nedbrunnen; den kunde inte tändas.',
      &okayBurnCandleMsg -> 'Bob tände tingesten.',
      &candleNotLitMsg -> 'Tingesten var inte tänd.',
      &okayExtinguishCandleMsg -> 'Bob släckte tingesten.',
      &cannotConsultMsg -> 'Den var ingenting Bob kunde konsultera.',
      &cannotTypeOnMsg -> 'Bob kunde inte skriva någonting på den.',
      &cannotEnterOnMsg -> 'Bob kunde inte knappa in någonting på den.',
      &cannotSwitchMsg -> 'Bob kunde inte ändra på den.',
      &cannotFlipMsg -> 'Bob kunde inte vända den.',
      &cannotTurnOnMsg -> 'Den var inte någonting som Bob kunde slå på.',
      &cannotTurnOffMsg -> 'Den var inte någonting som Bob kunde stänga av.',
      &cannotLightMsg -> 'Bob kunde inte tända den.',
      &cannotBurnMsg -> 'Den var inte någonting Bob kunde elda',
      &cannotBurnWithMsg -> 'Bob kunde inte elda någonting med den',
      &cannotBurnDobjWithMsg -> 'Bob kunde inte tända tingesten med saken.',
      &alreadyBurningMsg -> 'Tingesten brann redan.',
      &cannotExtinguishMsg -> 'Bob kunde inte släcka den.',
      &cannotPourMsg -> 'Den var inte någonting Bob kunde hälla.',
      &cannotPourIntoMsg -> 'Bob kunde inte hälla någonting i den.',
      &cannotPourOntoMsg -> 'Bob kunde inte hälla någonting på den.',
      &cannotAttachMsg -> 'Bob kunde inte fästa den på någonting.',
      &cannotAttachToMsg -> 'Bob kunde inte fästa någonting på den.',
      &cannotAttachToSelfMsg -> 'Bob kunde inte fästa tingesten på sig själv.',
      &alreadyAttachedMsg -> 'Tingesten var redan fäst med saken.',
      &wrongAttachmentMsg -> 'Bob kunde inte fästa den på saken.',
      &wrongDetachmentMsg -> 'Bob kunde inte koppla loss den från saken.',
      &okayAttachToMsg -> 'Bob fäste tingesten till saken.',
      &okayDetachFromMsg -> 'Bob tog loss tingesten från saken.',
      &cannotDetachMsg -> 'Bob kunde inte koppla loss den.',
      &cannotDetachFromMsg -> 'Bob kunde inte ta loss någonting från den.',
      &cannotDetachPermanentMsg -> 'Det fanns inget uppenbart sätt att ta loss den.',
      &notAttachedToMsg -> 'Tingesten satt inte fast i den.',
      &shouldNotBreakMsg -> 'Bob ville inte förstöra den.',
      &cutNoEffectMsg -> 'Saken verkade inte kunna skära tingesten.',
      &cannotCutWithMsg -> 'Bob kunde inte skära någonting med saken.',
      &cannotClimbMsg -> 'Den var inte någonting Bob kunde klättra på.',
      &cannotOpenMsg -> 'Den var inte någonting Bob kunde öppna.',
      &cannotCloseMsg -> 'Den var inte någonting Bob kunde stänga.',
      &alreadyOpenMsg -> 'Tingesten var redan öppen.',
      &alreadyClosedMsg -> 'Tingesten var redan stängd.',
      &alreadyLockedMsg -> 'Tingesten var redan låst.',
      &alreadyUnlockedMsg -> 'Tingesten var redan olåst.',
      &cannotLookInClosedMsg -> 'Tingesten var stängd.',
      &cannotLockMsg -> 'Den var inte någonting Bob kunde låsa.',
      &cannotUnlockMsg -> 'Den var inte någonting Bob kunde låsa upp.',
      &cannotOpenLockedMsg -> 'Tingesten verkade vara låst.',
      &unlockRequiresKeyMsg -> 'Bob verkade behöva en nyckel för att låsa upp tingesten.',
      &cannotLockWithMsg -> 'Saken såg inte lämplig ut att kunna låsa tingesten med.',
      &cannotUnlockWithMsg -> 'Saken såg inte lämplig ut att kunna låsa upp tingesten med.',
      &unknownHowToLockMsg -> 'Det var inte tydligt på vilket sätt tingesten skulle låsas.',
      &unknownHowToUnlockMsg -> 'Det var inte tydligt på vilket sätt tingesten skulle låsas upp.',
      &keyDoesNotFitLockMsg -> 'Bob provade saken, men den passade inte till låset.',
      &cannotEatMsg -> 'Tingesten verkade inte vara ätbar.',
      &cannotDrinkMsg -> 'Tingesten verkade inte vara något Bob kunde dricka.',
      &cannotCleanMsg -> 'Bob skulle inte veta hur den skulle rengöras.',
      &cannotCleanWithMsg -> 'Bob kunde inte rengöra någonting med den.',
      &cannotAttachKeyToMsg -> 'Bob kunde inte fästa tingesten i den.',
      &cannotSleepMsg -> 'Bob behövde inte sova just nu.',
      &cannotSitOnMsg -> 'Den var inte någonting som Bob kunde sitta på.',
      &cannotLieOnMsg -> 'Den var inte någonting som Bob kunde ligga på.',
      &cannotStandOnMsg -> 'Bob kunde inte stå på den.',
      &cannotBoardMsg -> 'Bob kunde inte kliva ombord på den.',
      &cannotUnboardMsg -> 'Bob kunde inte kliva ut ur den.',
      &cannotGetOffOfMsg -> 'Bob kunde inte kliva av från den.',
      &cannotStandOnPathMsg -> 'Om Bob ville följa tingesten, säg bara det.',
      &cannotEnterHeldMsg -> 'Bob kunde inte göra det medan Bob höll i tingesten.',
      &cannotGetOutMsg -> 'Bob var inte i någonting som Bob kunde kliva ur från.',
      &alreadyInLocMsg -> 'Bob var redan i tingesten.',
      &alreadyStandingMsg -> 'Bob stod redan.',
      &alreadyStandingOnMsg -> 'Bob stod redan i tingesten.',
      &alreadySittingMsg -> 'Bob satt redan ner.',
      &alreadySittingOnMsg -> 'Bob satt redan i tingesten.',
      &alreadyLyingMsg -> 'Bob låg redan ner.',
      &alreadyLyingOnMsg -> 'Bob låg redan ner i tingesten.',
      &notOnPlatformMsg -> 'Bob var inte i tingesten.',
      &noRoomToStandMsg -> 'Det fanns inte rum för Bob att stå i tingesten.',
      &noRoomToSitMsg -> 'Det fanns inte rum för Bob att sitta i tingesten.',
      &noRoomToLieMsg -> 'Det fanns inte rum för Bob att ligga i tingesten.',
      &okayNotStandingOnMsg -> 'Bob klev ut ur tingesten.',
      &cannotFastenMsg -> 'Bob kunde inte fästa tingesten',
      &cannotFastenToMsg -> 'Bob kunde inte fästa någonting på saken.',
      &cannotUnfastenMsg -> 'Bob kunde inte ta loss tingesten.',
      &cannotUnfastenFromMsg -> 'Bob kunde inte ta loss någonting från saken.',
      &cannotPlugInMsg -> 'Bob såg inget sätt att koppla in tingesten.',
      &cannotPlugInToMsg -> 'Bob såg inget sätt att koppla in någonting i saken.',
      &cannotUnplugMsg -> 'Bob såg inget sätt att koppla loss tingesten.',
      &cannotUnplugFromMsg -> 'Bob såg inget sätt att la loss någonting från saken.',
      &cannotScrewMsg -> 'Bob såg inget sätt att skruva tingesten.',
      &cannotScrewWithMsg -> 'Bob kunde inte skruva något med saken.',
      &cannotUnscrewMsg -> 'Bob visste inget sätt att skruva loss tingesten.',
      &cannotUnscrewWithMsg -> 'Bob kunde inte skruva loss något med saken.',
      &cannotEnterMsg -> 'Den var inte någonting Bob kunde gå in i.',
      &cannotGoThroughMsg -> 'Den var inte någonting Bob kunde gå genom.',
      &cannotThrowAtSelfMsg -> 'Bob kunde inte kasta den på sig själv.',
      &cannotThrowAtContentsMsg -> 'Bob behövde ta bort saken från tingesten före han kunde göra det.',
      &shouldNotThrowAtFloorMsg -> 'Bob borde bara lagt ner den istället.',
      &dontThrowDirMsg -> 'Du behöver vara mer specifik om vad du vill att Bob ska kasta tingesten mot.',
      &cannotThrowToMsg -> 'Bob kunde inte kasta någonting till en sak.',
      &cannotKissMsg -> 'Att kyssa tingesten hade ingen uppenbar effekt.',
      &cannotKissSelfMsg -> 'Bob kunde inte kyssa sig själv.',
      &newlyDarkMsg -> 'Det var nu kolsvart.'
  ];
  pairs.forEachAssoc(function(msg, expectedOutput) {
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
     "<<npcActionMessages.(msg)>>";
     
    local str = o.findReplace('  ', ' ', ReplaceAll);
    
    assertThat(str).startsWith(expectedOutput);
  });
};



/*
TODO: openStatusMsg


noMatchDisambig(actor, origPhrase, disambigResponse)
emptyNounPhrase(actor)
zeroQuantity(actor, txt)
insufficientQuantity(actor, txt, matchList, requiredNum)
uniqueObjectRequired(actor, txt, matchList)
singleObjectRequired(actor, txt)
disambigOrdinalOutOfRange(actor, ordinalWord, originalText)
requiredNum, askingAgain, dist)
ambiguousNounPhrase(actor, originalText, matchList, fullMatchList)

cannotChangeActor()
askUnknownWord(actor, txt)
wordIsUnknown(actor, txt)
refuseCommandBusy(targetActor, issuingActor)
cannotAddressMultiple(actor)
explainCancelCommandLine()
commandNotHeard(actor)
noMatchForAll(actor)
noMatchForAllBut(actor)
insufficientQuantity(actor, txt, matchList, requiredNum)
ambiguousNounPhrase(actor, originalText, matchList, fullMatchList)

missingObject(actor, action, which)
missingLiteral(actor, action, which)
noMatchCannotSee(actor, txt)
noMatchNotAware(actor, txt)
noMatchForAll(actor)
noMatchForAllBut(actor)
zeroQuantity(actor, txt)
insufficientQuantity(actor, txt, matchList, requiredNum)
uniqueObjectRequired(actor, txt, matchList)
singleObjectRequired(actor, txt)
noMatchDisambig(actor, origPhrase, disambigResponse)
disambigOrdinalOutOfRange(actor, ordinalWord, originalText)
requiredNum, askingAgain, dist)
ambiguousNounPhrase(actor, originalText, matchList, fullMatchList)
askMissingObject(actor, action, which)
missingObject(actor, action, which)
missingLiteral(actor, action, which)
askUnknownWord(actor, txt)
wordIsUnknown(actor, txt)
commandNotUnderstood(actor)
noMatchCannotSee(actor, txt)
noMatchNotAware(actor, txt)
noMatchForAll(actor)
noMatchForAllBut(actor)
emptyNounPhrase(actor)
zeroQuantity(actor, txt)
insufficientQuantity(actor, txt, matchList, requiredNum)
uniqueObjectRequired(actor, txt, matchList)
singleObjectRequired(actor, txt)
ambiguousNounPhrase(actor, originalText, matchList, fullMatchList)
askMissingObject(actor, action, which)

[actorInventoryLister, actorHoldingDescInventoryListerLong, actorHoldingDescInventoryListerShort]:
showInventoryEmpty(parent)
showInventoryWearingOnly(parent, wearing)
showInventoryCarryingOnly(parent, carrying)
showInventoryShortLists(parent, carrying, wearing)
showInventoryLongLists(parent, carrying, wearing)

showListEmpty(pov, parent)

showListPrefixWide(itemCount, pov, parent)
showListEmpty(pov, parent)
showListEmpty(pov, parent)
showListPrefixWide(itemCount, pov, parent)
showListPrefixWide(itemCount, pov, parent)
showListSuffixWide(itemCount, pov, parent)
showListPrefixTall(itemCount, pov, parent)
showListContentsPrefixTall(itemCount, pov, parent)
isListed(obj)
isListed(obj)
isListed(obj)
showListPrefixWide(itemCount, pov, parent)
showListPrefixWide(itemCount, pov, parent)
showListPrefixWide(cnt, pov, parent)
showListEmpty(pov, parent)
showListPrefixWide(cnt, pov, parent)
showListSuffixWide(itemCount, pov, parent)
showListSuffixWide(cnt, pov, parent)
showListPrefixWide(cnt, pov, parent)
showListSuffixWide(cnt, pov, parent)
showListItem(obj, options, pov, infoTab)
showListSeparator(options, curItemNum, totalItems)
showListItem(obj, options, pov, infoTab)
showListSeparator(options, curItemNum, totalItems)
showListPrefixWide(cnt, pov, parent)
showListItem(obj, options, pov, infoTab)
showListSeparator(options, curItemNum, totalItems)
showListItemDirName(obj, initCap)
showListItem(obj, options, pov, infoTab)
showListSeparator(options, curItemNum, totalItems)
showListPrefixWide(cnt, pov, parent)
showListPrefixWide(cnt, pov, parent)
showListItem(obj, options, pov, infoTab)
showListSuffixWide(cnt, pov, parent)
showListSeparator(options, curItemNum, totalItems)
showListEmpty(pov, parent)
showListEmpty(pov, parent)
showListPrefixWide(cnt, pov, parent)
showListSuffixWide(cnt, pov, parent)
showListItem(obj, options, pov, infoTab)
showListSeparator(options, curItemNum, totalItems)
compositeMessage(lst)
construct(asker, askee, explicit)
showListPrefixWide(cnt, pov, parent)
showListSuffixWide(cnt, pov, parent)
showListEmpty(pov, parent)
showListSeparator(options, curItemNum, totalItems)
showListItem(obj, options, pov, infoTab)
showGroupItem(sublister, obj, options, pov, infoTab)
showGroupList(pov, lister, lst, options, indent, infoTab)

showScoreMessage(points, maxPoints, turns)
showScoreNoMaxMessage(points, turns)
fullScoreItemPoints(points)
firstScoreChange(delta)
scoreChange(delta)
basicScoreChange(delta)
acknowledgeTipStatus(stat)
tipStatusShort(stat)
footnoteRef(num)
firstFootnote()
noSuchFootnote(num)
showFootnoteStatus(stat)
acknowledgeFootnoteStatus(stat)
shortFootnoteStatus(stat)
invalidCommandToken(ch)
smellDescSeparator()
soundDescSeparator()






*/