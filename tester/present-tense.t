#charset "utf-8"
#include <adv3.h>
#include <sv_se.h> 
#include "TestUnit.h"

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
    usePastTense = nil
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

musketorer: Actor 'musketörer+na' 'musketörer'
  pcReferralPerson = ThirdPerson
  isProperName = nil
  isHim = true
  isPlural = true
;

appletObjNeutrumSingular: Thing 'äpple+t' 'äpple' ;
jordgubbeObjUtrumSingular: Thing 'jordgubbe+n' 'jordgubbe';
vindruvorObjNeutrumPlural: Thing 'vindruva*vindruvor+na' 'vindruvor' isPlural=true;

bokenObjUtrumSingular: Thing 'bok+en' 'bok';
papperetObjNeutrumSingular: Thing 'papper+et' 'papper' ;
skyltarObjUtrumPlural: Thing 'skylt*skyltar+na' 'skyltar' isPlural=true;

dorrenObjUtrumSingular: Thing 'dörr+en' 'dörr';
skapetObjNeutrumSingular: OpenableContainer 'skåp+et' 'skåp' 
  isOpen = true;

+snickargladje: Component 'snickareglädje+n' 'snickargläde';

dorrarObjUterPlural: Thing 'dörrar+na' 'dörrar2' isPlural = true;
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
TestUnit 'openMsg - utrum singular' run {
  assertThat(libMessages.openMsg(dorrenObjUtrumSingular)).isEqualTo('öppen');
};
TestUnit 'openMsg - neutrum singular' run {
  assertThat(libMessages.openMsg(skapetObjNeutrumSingular)).isEqualTo('öppet');
};
TestUnit 'openMsg - utrum plural' run {
  assertThat(libMessages.openMsg(dorrarObjUterPlural)).isEqualTo('öppna');
};
TestUnit 'openMsg - neutrum plural' run {
  assertThat(libMessages.openMsg(skapenObjNeuterPlural)).isEqualTo('öppna');
};

TestUnit 'distantThingDesc - neutrum plural' run {
  libMessages.distantThingDesc(dorrenObjUtrumSingular);
  assertThat(o).startsWith('Den är för långt borta för att kunna utgöra några detaljer'); 
};


TestUnit 'obscuredThingDesc first person' run {
  gPlayerChar = spelare1aPerspektiv;
  libMessages.obscuredThingDesc(skapenObjNeuterPlural, skapenObjNeuterPlural);
  assertThat(o).startsWith('Jag kan inte utgöra några detaljer genom skåpen.');
};

TestUnit 'obscuredThingDesc second person' run {
  gPlayerChar = spelare2aPerspektiv;
  libMessages.obscuredThingDesc(skapenObjNeuterPlural, skapenObjNeuterPlural);
  assertThat(o).startsWith('Du kan inte utgöra några detaljer genom skåpen.');
};

TestUnit 'obscuredThingDesc second person' run {
  gPlayerChar = spelare3dePerspektiv;
  libMessages.obscuredThingDesc(skapenObjNeuterPlural, skapenObjNeuterPlural);
  assertThat(o).startsWith('Bob kan inte utgöra några detaljer genom skåpen.');
};


TestUnit 'thingTasteDesc neuter singular' run {
  gPlayerChar = spelare2aPerspektiv;
  libMessages.thingTasteDesc(skapetObjNeutrumSingular);
  assertThat(o).startsWith('Det smakar ungefär som du förväntar dig.');
};

TestUnit 'thingTasteDesc utrum singular' run {
  gPlayerChar = spelare2aPerspektiv;
  libMessages.thingTasteDesc(dorrenObjUtrumSingular);
  assertThat(o).startsWith('Den smakar ungefär som du förväntar dig.');
};

TestUnit 'thingTasteDesc plural' run {
  gPlayerChar = spelare2aPerspektiv;
  libMessages.thingTasteDesc(skapenObjNeuterPlural);
  assertThat(o).startsWith('De smakar ungefär som du förväntar dig.');
};

TestUnit 'announceRemappedAction neutrum dobj' run {
  //mainOutputStream.hideOutput = nil;
  gAction = OpenAction.createActionInstance();
  gAction.setCurrentObjects([skapetObjNeutrumSingular]);
  assertThat(libMessages.announceRemappedAction(gAction))
    .contains('öppnar skåpet');
};


TestUnit 'announceRemappedAction utrum dobj' run {
  //mainOutputStream.hideOutput = nil;
  gAction = OpenAction.createActionInstance();
  gAction.setCurrentObjects([dorrenObjUtrumSingular]);
  assertThat(libMessages.announceRemappedAction(gAction))
    .contains('öppnar dörren');
};


TestUnit 'announceRemappedAction plural dobj' run {
  //mainOutputStream.hideOutput = nil;
  gAction = OpenAction.createActionInstance();
  gAction.setCurrentObjects([skapenObjNeuterPlural]);
  assertThat(libMessages.announceRemappedAction(gAction))
    .contains('öppnar skåpen');
};

TestUnit 'announceImplicitAction neutrum dobj tryingImpCtx' run {
  //mainOutputStream.hideOutput = nil;
  gAction = OpenAction.createActionInstance();
  gAction.setCurrentObjects([skapetObjNeutrumSingular]);
  assertThat(libMessages.announceImplicitAction(gAction, tryingImpCtx))
    .contains('försöker öppna skåpet först');
};

TestUnit 'announceImplicitAction utrum dobj tryingImpCtx' run {
  //mainOutputStream.hideOutput = nil;
  gAction = OpenAction.createActionInstance();
  gAction.setCurrentObjects([dorrenObjUtrumSingular]);
  assertThat(libMessages.announceImplicitAction(gAction, tryingImpCtx))
    .contains('försöker öppna dörren först');
};

TestUnit 'announceImplicitAction plural dobj tryingImpCtx' run {
  //mainOutputStream.hideOutput = nil;
  gAction = OpenAction.createActionInstance();
  gAction.setCurrentObjects([skapenObjNeuterPlural]);
  assertThat(libMessages.announceImplicitAction(gAction, tryingImpCtx))
    .contains('försöker öppna skåpen först');
};


TestUnit 'announceMoveToBag plural dobj tryingImpCtx' run {
  //mainOutputStream.hideOutput = nil;
  gAction = MoveAction.createActionInstance();
  gAction.setCurrentObjects([skapenObjNeuterPlural]);
  assertThat(libMessages.announceMoveToBag(gAction, tryingImpCtx))
    .contains('försöker flytta skåpen för att göra plats först');
};


TestUnit 'announceMoveToBag plural dobj tryingImpCtx' run {
  //mainOutputStream.hideOutput = nil;
  gAction = MoveAction.createActionInstance();
  gAction.setCurrentObjects([skapenObjNeuterPlural]);
  assertThat(libMessages.announceMoveToBag(gAction, tryingImpCtx))
    .contains('försöker flytta skåpen för att göra plats först');
};


TestUnit 'obscuredThingSoundDesc first person neuter singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare1aPerspektiv;
  libMessages.obscuredThingSoundDesc(appletObjNeutrumSingular, skapetObjNeutrumSingular);
  assertThat(o).startsWith('Jag kan inte höra något detaljerat genom skåpet.');
};

TestUnit 'obscuredThingSmellDesc first person utrum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare1aPerspektiv;
  libMessages.obscuredThingSmellDesc(appletObjNeutrumSingular, dorrenObjUtrumSingular);
  assertThat(o).startsWith('Jag kan inte känna så mycket lukt genom dörren.');
};

TestUnit 'obscuredReadDesc first person utrum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare1aPerspektiv;
  libMessages.obscuredReadDesc(papperetObjNeutrumSingular);
  assertThat(o).startsWith('Jag kan inte se det bra nog för att kunna läsa det.');
};

TestUnit 'obscuredReadDesc 1a person utrum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  libMessages.obscuredReadDesc(bokenObjUtrumSingular);
  assertThat(o).startsWith('Du kan inte se den bra nog för att kunna läsa den.');
};

TestUnit 'obscuredReadDesc 3ee person utrum plural' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare3dePerspektiv;
  libMessages.obscuredReadDesc(skyltarObjUtrumPlural);
  assertThat(o).startsWith('Bob kan inte se dem bra nog för att kunna läsa dem.');
};

TestUnit 'obscuredThingSmellDesc 2a person utrum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  libMessages.thingTasteDesc(appletObjNeutrumSingular);
  assertThat(o).startsWith('Det smakar ungefär som du förväntar dig.');
};

TestUnit 'dimReadDesc 2a person neutrum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  libMessages.dimReadDesc(papperetObjNeutrumSingular);
  assertThat(o).startsWith('Det finns inte ljus bra nog att läsa det.');
};

TestUnit 'cannotReachObject 1a person dobj: utrum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare1aPerspektiv;
  libMessages.cannotReachObject(appletObjNeutrumSingular);
  assertThat(o).startsWith('Jag kan inte nå äpplet.');
};

TestUnit 'cannotReachObject 2nd person dobj: utrum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  libMessages.cannotReachObject(appletObjNeutrumSingular);
  assertThat(o).startsWith('Du kan inte nå äpplet.');
};

TestUnit 'cannotReachObject 3e person dobj: utrum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare3dePerspektiv;
  libMessages.cannotReachObject(appletObjNeutrumSingular);
  assertThat(o).startsWith('Bob kan inte nå äpplet.');
};

TestUnit 'cannotReachContents 1a person dobj: utrum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare1aPerspektiv;
  local str = libMessages.cannotReachContents(appletObjNeutrumSingular, skapetObjNeutrumSingular);
  "<<str>>";
  assertThat(o).startsWith('Jag kan inte nå det genom skåpet.');
};

TestUnit 'cannotReachContents 2a person dobj: utrum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  local str = libMessages.cannotReachContents(appletObjNeutrumSingular, skapetObjNeutrumSingular);
  "<<str>>";
  assertThat(o).startsWith('Du kan inte nå det genom skåpet.');
};

TestUnit 'cannotReachContents 3e person dobj: utrum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare3dePerspektiv;
  local str = libMessages.cannotReachContents(appletObjNeutrumSingular, skapetObjNeutrumSingular);
  "<<str>>";
  assertThat(o).startsWith('Bob kan inte nå det genom skåpet.');
};


TestUnit 'cannotReachOutside 2a person dobj: utrum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare3dePerspektiv;
  local str = libMessages.cannotReachOutside(appletObjNeutrumSingular, skapetObjNeutrumSingular);
  "<<str>>";
  assertThat(o).startsWith('Bob kan inte nå det genom skåpet.');
};


TestUnit 'soundIsFromWithin 2a person dobj: utrum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  libMessages.soundIsFromWithin(musikenObjUtrumSingular, skapetObjNeutrumSingular);
  assertThat(o).startsWith('\^musiken verkar komma från insidan skåpet.');
};


TestUnit 'soundIsFromWithout 2a person dobj: utrum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  libMessages.soundIsFromWithout(musikenObjUtrumSingular, skapetObjNeutrumSingular);
  assertThat(o).startsWith('\^musiken verkar komma från utsidan skåpet.');
};

TestUnit 'smellIsFromWithin 2a person dobj: utrum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  libMessages.smellIsFromWithin(matosetObjUtrumSingular, skapetObjNeutrumSingular);
  assertThat(o).startsWith('\^matoset verkar komma från insidan skåpet.');
};

TestUnit 'smellIsFromWithout 2a person dobj: utrum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  libMessages.smellIsFromWithout(matosetObjUtrumSingular, skapetObjNeutrumSingular);
  assertThat(o).startsWith('\^matoset verkar komma från utsidan skåpet.');
};

TestUnit 'pcDesc 1a person' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare1aPerspektiv;
  libMessages.pcDesc(gPlayerChar);
  assertThat(o).startsWith('\^jag ser likadan ut som vanligt.');
};
TestUnit 'pcDesc 2a person' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  libMessages.pcDesc(gPlayerChar);
  assertThat(o).startsWith('\^du ser likadan ut som vanligt.');
};

TestUnit 'pcDesc 3e person' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare3dePerspektiv;
  libMessages.pcDesc(gPlayerChar);
  assertThat(o).startsWith('\^Bob ser likadan ut som vanligt.');
};

TestUnit 'roomActorStatus actor (ingen output om stående)' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  hobbit.posture = standing;
  libMessages.roomActorStatus(hobbit);
  assertThat(o).isEqualTo('');
};

TestUnit 'roomActorStatus actor (sitter)' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  hobbit.posture = sitting;
  libMessages.roomActorStatus(hobbit);
  assertThat(o).isEqualTo(' (sitter)');
};

TestUnit 'roomActorStatus actor (ligger)' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  hobbit.posture = lying;
  libMessages.roomActorStatus(hobbit);
  assertThat(o).isEqualTo(' (ligger)');
};


TestUnit 'roomActorHereDesc actor (ligger)' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  hobbit.posture = standing;
  libMessages.roomActorHereDesc(hobbit);
  assertThat(o).contains('\^hobbiten står här.');
};

TestUnit 'roomActorHereDesc actor (ligger)' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  hobbit.posture = sitting;
  libMessages.roomActorHereDesc(hobbit);
  assertThat(o).startsWith('\^hobbiten sitter här.');
};

TestUnit 'roomActorHereDesc actor (ligger)' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  hobbit.posture = lying;
  libMessages.roomActorHereDesc(hobbit);
  assertThat(o).startsWith('\^hobbiten ligger här.');
};



TestUnit 'roomActorThereDesc actor (ligger)' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  hobbit.posture = standing;
  libMessages.roomActorThereDesc(hobbit);
  assertThat(o).contains('\^hobbiten står i närheten.'); // TODO: OK mening?
};

TestUnit 'roomActorThereDesc actor (ligger)' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  hobbit.posture = sitting;
  libMessages.roomActorThereDesc(hobbit);
  assertThat(o).startsWith('\^hobbiten sitter i närheten.'); // TODO: OK mening?
};

TestUnit 'roomActorThereDesc actor (ligger)' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  hobbit.posture = lying;
  libMessages.roomActorThereDesc(hobbit);
  assertThat(o).startsWith('\^hobbiten ligger i närheten.'); // TODO: OK mening?
};


// TODO: kan testas betydligt mera
TestUnit 'actorInRoom' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = spelare2aPerspektiv;
  hobbit.posture = sitting;
  libMessages.actorInRoom(hobbit, baren); 
  assertThat(o).startsWith('\^hobbiten sitter i baren.');
};

// TODO: kan testas betydligt mera
TestUnit 'actorInRoomPosture' run {
  //mainOutputStream.hideOutput = nil;
  gActor = hobbit;
  hobbit.posture = sitting;
  libMessages.actorInRoomPosture(hobbit, baren); 
  assertThat(o).startsWith('\^han sitter i baren.');
};

TestUnit 'roomActorPostureDesc' run {
  //mainOutputStream.hideOutput = nil;
  gActor = hobbit;
  hobbit.posture = sitting;
  libMessages.roomActorPostureDesc(hobbit); 
  assertThat(o).startsWith('\^han sitter.');
};

TestUnit 'sayArriving' run {
  //mainOutputStream.hideOutput = nil;
  hobbit.location = fylke; 
  libMessages.sayArriving(hobbit); 
  assertThat(o).startsWith('\^en hobbit kommer till Fylke.');
};

TestUnit 'sayDeparting' run {
  //mainOutputStream.hideOutput = nil;
  hobbit.location = fylke; 
  libMessages.sayDeparting(hobbit); 
  assertThat(o).startsWith('\^en hobbit lämnar Fylke.');
};


TestUnit 'sayArrivingLocally' run {
  //mainOutputStream.hideOutput = nil;
  hobbit.location = fylke; 
  libMessages.sayArrivingLocally(hobbit, baren); 
  //sayDepartingLocally(traveler, dest)
  assertThat(o).startsWith('\^en hobbit kommer till Fylke.');
};

TestUnit 'sayDepartingLocally' run {
  //mainOutputStream.hideOutput = nil;
  hobbit.location = fylke; 
  libMessages.sayDepartingLocally(hobbit, baren); 
  assertThat(o).startsWith('\^en hobbit lämnar Fylke.');
};

TestUnit 'sayTravelingRemotely' run {
  //mainOutputStream.hideOutput = nil;
  hobbit.location = fylke; 
  libMessages.sayTravelingRemotely(hobbit, baren); 
  assertThat(o).startsWith('\^en hobbit går till Fylke.');
};

TestUnit 'sayArrivingDir' run {
  //mainOutputStream.hideOutput = nil;
  [
    [northDirection, '\^en hobbit anländer till Fylke norrifrån.'],
    [southDirection, '\^en hobbit anländer till Fylke söderifrån.'],
    [eastDirection, '\^en hobbit anländer till Fylke österifrån.'],
    [westDirection, '\^en hobbit anländer till Fylke västerifrån.'],
    [northeastDirection, '\^en hobbit anländer till Fylke nordösterifrån.'],
    [northwestDirection, '\^en hobbit anländer till Fylke nordvästerifrån.'],
    [southeastDirection, '\^en hobbit anländer till Fylke sydösterifrån.'],
    [southwestDirection, '\^en hobbit anländer till Fylke sydvästerifrån.'],
    [upDirection, '\^en hobbit anländer till Fylke uppifrån.'],
    [downDirection, '\^en hobbit anländer till Fylke nerifrån.'],
    [inDirection, '\^en hobbit anländer till Fylke inifrån.'],
    [outDirection, '\^en hobbit anländer till Fylke utifrån.']
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

TestUnit 'sayDepartingDir' run {
  //mainOutputStream.hideOutput = nil;
  hobbit.location = fylke; 
  
  [
    [northDirection, '\^en hobbit beger sig från Fylke norrut.'],
    [southDirection, '\^en hobbit beger sig från Fylke söderut.'],
    [eastDirection, '\^en hobbit beger sig från Fylke österut.'],
    [westDirection, '\^en hobbit beger sig från Fylke västerut.'],
    [northeastDirection, '\^en hobbit beger sig från Fylke nordösterut.'],
    [northwestDirection, '\^en hobbit beger sig från Fylke nordvästerut.'],
    [southeastDirection, '\^en hobbit beger sig från Fylke sydösterut.'],
    [southwestDirection, '\^en hobbit beger sig från Fylke sydvästerut.'],
    
    // TODO: snygga till meningarna nedan:
    [upDirection, '\^en hobbit beger sig från Fylke uppåt.'], 
    [downDirection, '\^en hobbit beger sig från Fylke neråt.'],
    [inDirection, '\^en hobbit beger sig från Fylke inåt.'],
    [outDirection, '\^en hobbit beger sig från Fylke utåt.']
  ].forEach(function(pair) {
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    local dir = pair[1];
    local msg = pair[2];
    hobbit.location = fylke; 
    libMessages.sayDepartingDir(hobbit, dir.name + dir.ending); 
    assertThat(o).startsWith(msg);
  });

};


TestUnit 'sayArrivingShipDir' run {
  ////mainOutputStream.hideOutput = nil;
  [
    [foreDirection, 'en pirat kommer till masten från fören.'],
    [aftDirection, 'en pirat kommer till masten från aktern.'],
    [portDirection, 'en pirat kommer till masten från babordssidan.'],
    [starboardDirection, 'en pirat kommer till masten från styrbordssidan.']
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

TestUnit 'sayDepartingShipDir' run {
  // mainOutputStream.hideOutput = nil;
  [
     [foreDirection, 'en pirat går föröver mot kajen'],
     [aftDirection, 'en pirat går akteröver mot kajen'],
     [portDirection, 'en pirat går längs babordssidan mot kajen'],
     [starboardDirection, 'en pirat går längs styrbordssidan mot kajen']
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

TestUnit 'sayDepartingShipDir' run {
  // mainOutputStream.hideOutput = nil;
  [
     [foreDirection, 'en pirat går föröver mot kajen'],
     [aftDirection, 'en pirat går akteröver mot kajen'],
     [portDirection, 'en pirat går längs babordssidan mot kajen'],
     [starboardDirection, 'en pirat går längs styrbordssidan mot kajen']
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

TestUnit 'sayDepartingThroughPassage' run {
  //mainOutputStream.hideOutput = nil;
  pirat.location = baren; 
  libMessages.sayDepartingThroughPassage(pirat, passageThroughPassage);
  assertThat(o).contains('en pirat lämnar baren genom passagen');
};

TestUnit 'sayArrivingThroughPassage' run {
  //mainOutputStream.hideOutput = nil;
  pirat.location = baren; 
  libMessages.sayArrivingThroughPassage(pirat, passageThroughPassage);
  assertThat(o).startsWith('\^en pirat kommer in i baren genom passagen');
};

TestUnit 'sayDepartingViaPath' run {
  //mainOutputStream.hideOutput = nil;
  pirat.location = baren; 
  libMessages.sayDepartingViaPath(pirat, valvgangPathPassage);
  assertThat(o).startsWith('\^en pirat lämnar baren via valvgången');
};


TestUnit 'sayArrivingViaPath' run {
  //mainOutputStream.hideOutput = nil;
  pirat.location = baren; 
  libMessages.sayArrivingViaPath(pirat, valvgangPathPassage);
  assertThat(o).contains('\^en pirat kommer till baren via valvgången');
};

TestUnit 'sayDepartingUpStairs' run {
  //mainOutputStream.hideOutput = nil;
  pirat.location = baren; 
  libMessages.sayDepartingUpStairs(pirat, trappan);
  assertThat(o).contains('\^en pirat går upp för trappan');
};

TestUnit 'sayDepartingDownStairs' run {
  //mainOutputStream.hideOutput = nil;
  pirat.location = baren; 
  libMessages.sayDepartingDownStairs(pirat, trappan);
  assertThat(o).contains('\^en pirat går ner för trappan');
};

TestUnit 'sayArrivingUpStairs' run {
  //mainOutputStream.hideOutput = nil;
  pirat.location = baren; 
  libMessages.sayArrivingUpStairs(pirat, kallartrappan);
  assertThat(o).contains('\^en pirat kommer upp från källartrappan');
};

TestUnit 'sayArrivingDownStairs' run {
  //mainOutputStream.hideOutput = nil;
  pirat.location = baren; 
  libMessages.sayArrivingDownStairs(pirat, trappan);
  assertThat(o).contains('\^en pirat kommer ner från trappan till baren.');
};

TestUnit 'sayDepartingWith' run {
  //mainOutputStream.hideOutput = nil;
  libMessages.sayDepartingWith(pirat, hobbit);
  assertThat(o).contains('\^en pirat anländer med hobbiten.');
};


TestUnit 'sayDepartingWithGuide' run {
  //mainOutputStream.hideOutput = nil;
  libMessages.sayDepartingWithGuide(pirat, matros);
  assertThat(o).contains('\^matrosen låter piraten leda vägen.');
};

TestUnit 'sayOpenDoorRemotely dörren (neutrum utrum)' run {
  //mainOutputStream.hideOutput = nil;
  libMessages.sayOpenDoorRemotely(dorrenObjUtrumSingular, true);
  assertThat(o).contains('Någon öppnar dörren från den andra sidan');
};

TestUnit 'sayOpenDoorRemotely skåpet (neutrum singular)' run {
  //mainOutputStream.hideOutput = nil;
  libMessages.sayOpenDoorRemotely(skapetObjNeutrumSingular, true);
  assertThat(o).contains('Någon öppnar skåpet från den andra sidan');
};

TestUnit 'sayOpenDoorRemotely dörrar (utrum plural)' run {
  //mainOutputStream.hideOutput = nil;
  libMessages.sayOpenDoorRemotely(dorrarObjUterPlural, true);
  assertThat(o).contains('Någon öppnar dörrarna från den andra sidan');
};

// TODO: bör testas mera
TestUnit 'actorInRemoteRoom' run {
  //mainOutputStream.hideOutput = nil;
  //libGlobal.pointOfView = hobbit;
  libMessages.actorInRemoteRoom(pirat, baren, krogare);
  assertThat(o).contains('\^piraten står i baren');
};

// TODO: testa i större sammanhang också
TestUnit 'actorInGroupSuffix' run {
  //mainOutputStream.hideOutput = nil;
  libMessages.actorInGroupSuffix(sitting, bankraden, [sjorovare, viking]);
  assertThat(o).startsWith(' sitter på bänkraden'); // TODO: måste testa denna i sin helhet
};

// TODO: testa i större sammanhang också
TestUnit 'actorInRemoteGroupSuffix' run {
  //mainOutputStream.hideOutput = nil;
  libMessages.actorInRemoteGroupSuffix(hobbit, sitting, bankraden, baren, [sjorovare, viking]);
  assertThat(o).startsWith(' i baren, sitter på bänkraden'); // TODO: måste testa denna i sin helhet
};

// TODO: testa i större sammanhang också, 
// verkar bara vara Lister.showArrangedList(pov, parent, lst, options, indent, infoTab, itemCount, singles, groups, groupTab, origLst)
// som använder detta meddelande

TestUnit 'actorHereGroupSuffix' run {
  //mainOutputStream.hideOutput = nil;
  libMessages.actorHereGroupSuffix(sitting, [sjorovare]);
  assertThat(o).startsWith(' sitter här');
};

// TODO: testa i större sammanhang också
TestUnit 'actorThereGroupSuffix' run {
  //mainOutputStream.hideOutput = nil;
  libMessages.actorThereGroupSuffix(krogare, lying, baren, [viking]);
  assertThat(o).startsWith(' ligger i baren');
};


//   say that the actor is in the nested room, in the current
//   posture, and add then add that we're in the outer room as
//   well 
TestUnit 'actorInRemoteNestedRoom' run {
  //mainOutputStream.hideOutput = nil;
  libMessages.actorInRemoteNestedRoom(krogare, baren, hallen, viking);
  
  // TODO: oklart om hur detta ska se ut och det är rätt? 
  // TODO: Bygg upp ett scenario som visar detta meddelande i sin helhet
  assertThat(o).startsWith('\^krögaren är i hallen, står i baren.'); 
  // I engelskan ska participle vara ståendes, men det känns inte rätt här. 
};

TestUnit 'matchBurnedOut' run {
  //mainOutputStream.hideOutput = nil;
  libMessages.matchBurnedOut(tandsticka);
  assertThat(o).startsWith('Tändstickan brinner upp, och försvinner i ett moln av aska.'); 
};

TestUnit 'candleBurnedOut' run {
  //mainOutputStream.hideOutput = nil;
  libMessages.candleBurnedOut(ljuset);
  assertThat(o).startsWith('Stearinljuset brinner ner för långt för att fortsätta vara tänt, och slocknar.'); 
};

TestUnit 'objBurnedOut' run {
  //mainOutputStream.hideOutput = nil;
  libMessages.objBurnedOut(ljuset);
  assertThat(o).startsWith('Stearinljuset slocknar.');
};

TestUnit 'inputFileScriptWarning' run {
  //mainOutputStream.hideOutput = nil;
  assertThat(libMessages.inputFileScriptWarning('42VARNING', 'filnamn'))
    .startsWith('VARNING Vill du fortsätta?');
};

TestUnit 'inputFileScriptWarning' run {
  //mainOutputStream.hideOutput = nil;
  assertThat(libMessages.inputFileScriptWarning('42VARNING', 'filnamn'))
    .startsWith('VARNING Vill du fortsätta?');
};

// --------------
// playerMessages
// --------------

TestUnit 'commandNotUnderstood' run {
  //mainOutputStream.hideOutput = nil;
  playerMessages.commandNotUnderstood(nil);
  assertThat(o).startsWith('Spelet förstår inte det kommandot.');
};
TestUnit 'specialTopicInactive' run {
  //mainOutputStream.hideOutput = nil;
  playerMessages.specialTopicInactive(nil);
  assertThat(o).startsWith('Det kommandot kan inte användas just nu.');
};
TestUnit 'allNotAllowed' run {
  //mainOutputStream.hideOutput = nil;
  playerMessages.allNotAllowed(nil);
  assertThat(o).contains('<q>Allt</q> kan inte användas med det verbet');
};

TestUnit 'noMatchForAll' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare2aPerspektiv;
  playerMessages.noMatchForAll(nil);
  assertThat(o).contains('Du ser inget passande här');
};

TestUnit 'noMatchForAllBut' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare2aPerspektiv;
  playerMessages.noMatchForAllBut(nil);
  assertThat(o).contains('Du ser ingenting annat här');
};

TestUnit 'noMatchForPronoun' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare2aPerspektiv;
  playerMessages.noMatchForPronoun(gActor, nil, 'den');
  assertThat(o).contains('Ordet <q>den</q> refererar inte till någonting just nu.');
};

// --------------------
// playerActionMessages
// --------------------
TestUnit 'mustBeHoldingMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare3dePerspektiv;
  gAction = EatAction.createActionInstance();
  gAction.setCurrentObjects([appletObjNeutrumSingular]);
  local msg = playerActionMessages.mustBeHoldingMsg(appletObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Bob behöver hålla i det för att göra det.');
};

TestUnit 'mustBeVisibleMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare3dePerspektiv;
  gAction = EatAction.createActionInstance();
  gAction.setCurrentObjects([appletObjNeutrumSingular]);
  local msg = playerActionMessages.mustBeVisibleMsg(appletObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Bob kan inte se det.');
};

TestUnit 'heardButNotSeenMsg' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = gActor;
  gActor = spelare3dePerspektiv;
  gAction = EatAction.createActionInstance();
  gAction.setCurrentObjects([prassel]);
  local msg = playerActionMessages.heardButNotSeenMsg(prassel);
  "<<msg>>";
  // TODO: "kan höra något prassla" skulle varit en bättre mening, 
  // se över hur det ska gå att ordna så som proper/plural fungerar nu
  assertThat(o).startsWith('Bob kan höra ett prassel, men han kan inte se det.');
};

TestUnit 'smelledButNotSeenMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare3dePerspektiv;
  gAction = SearchAction.createActionInstance();
  gAction.setCurrentObjects([sopor]);
  local msg = playerActionMessages.smelledButNotSeenMsg(sopor);
  "<<msg>>";
  assertThat(o).startsWith('Bob kan känna lukten av sopor, men han kan inte se dem.');
};


TestUnit 'cannotHearMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare2aPerspektiv;
  gAction = ListenToAction.createActionInstance();
  gAction.setCurrentObjects([prassel]);
  local msg = playerActionMessages.cannotHearMsg(prassel);
  "<<msg>>";
  assertThat(o).startsWith('Du kan inte höra det.');
};

TestUnit 'cannotSmellMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare2aPerspektiv;
  gAction = ListenToAction.createActionInstance();
  gAction.setCurrentObjects([prassel]);
  local msg = playerActionMessages.cannotSmellMsg(prassel);
  "<<msg>>";
  assertThat(o).startsWith('Du kan inte känna lukten av det.');
};

TestUnit 'cannotTasteMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare2aPerspektiv;
  gAction = ListenToAction.createActionInstance();
  gAction.setCurrentObjects([prassel]);
  local msg = playerActionMessages.cannotTasteMsg(prassel);
  "<<msg>>";
  assertThat(o).startsWith('Du kan inte smaka det.');
};


TestUnit 'cannotBeWearingMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare1aPerspektiv;
  gPlayerChar = gActor;
  gAction = WearAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.cannotBeWearingMsg(hatt);
  "<<msg>>";
  assertThat(o).startsWith('Jag måste ta av den innan jag kan göra det.');
};

TestUnit 'mustBeEmptyMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare1aPerspektiv;
  gPlayerChar = gActor;
  local msg = playerActionMessages.mustBeEmptyMsg(hatt);
  "<<msg>>";
  assertThat(o).startsWith('Jag behöver ta ut allting från den före jag kan göra det.');
};


TestUnit 'mustBeOpenMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare1aPerspektiv;
  gPlayerChar = gActor;
  local msg = playerActionMessages.mustBeOpenMsg(hatt);
  "<<msg>>";
  assertThat(o).startsWith('Jag behöver öppna den före jag kan göra det');
};


TestUnit 'mustBeClosedMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare1aPerspektiv;
  gPlayerChar = gActor;
  local msg = playerActionMessages.mustBeClosedMsg(skapetObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Jag behöver stänga det före jag kan göra det.');
};


TestUnit 'mustBeUnlockedMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare1aPerspektiv;
  gPlayerChar = gActor;
  local msg = playerActionMessages.mustBeUnlockedMsg(skapenObjNeuterPlural);
  "<<msg>>";
  assertThat(o).startsWith('Jag behöver låsa upp dem före jag kan göra det.');
};

TestUnit 'mustSitOnMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare1aPerspektiv;
  gPlayerChar = gActor;
  local msg = playerActionMessages.mustSitOnMsg(skapetObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Jag behöver sitta i skåpet först.');
};

TestUnit 'mustLieOnMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare1aPerspektiv;
  gPlayerChar = gActor;
  local msg = playerActionMessages.mustLieOnMsg(bankraden);
  "<<msg>>";
  assertThat(o).startsWith('Jag behöver ligga på bänkraden först.');
};

TestUnit 'mustGetOnMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare1aPerspektiv;
  gPlayerChar = gActor;
  local msg = playerActionMessages.mustGetOnMsg(bankraden);
  "<<msg>>";
  assertThat(o).startsWith('Jag behöver placera mig på bänkraden först.');
};

TestUnit 'mustBeInMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare1aPerspektiv;
  gPlayerChar = gActor;
  local msg = playerActionMessages.mustBeInMsg(appletObjNeutrumSingular, skapetObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Äpplet behöver vara i skåpet före jag kan göra det');
};


TestUnit 'mustBeCarryingMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare3dePerspektiv;
  gPlayerChar = gActor;
  local msg = playerActionMessages.mustBeCarryingMsg(appletObjNeutrumSingular, gActor);
  "<<msg>>";
  assertThat(o).startsWith('Bob behöver hålla det före han kan göra det.');
};

TestUnit 'decorationNotImportantMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare3dePerspektiv;
  gPlayerChar = gActor;
  local msg = playerActionMessages.decorationNotImportantMsg(bankraden);
  "<<msg>>";
  assertThat(o).startsWith('Bänkraden är oviktig.');
};

TestUnit 'unthingNotHereMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare1aPerspektiv;
  gPlayerChar = gActor;
  local msg = playerActionMessages.unthingNotHereMsg(appletObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Jag ser inte det här.');
};

// ------- Masskopiera mall
TestUnit 'tooDistantMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare1aPerspektiv;
  gPlayerChar = gActor;
  local msg = playerActionMessages.tooDistantMsg(appletObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Äpplet är för långt borta.');
};

TestUnit 'notWithIntangibleMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare1aPerspektiv;
  gPlayerChar = gActor;
  local msg = playerActionMessages.notWithIntangibleMsg(appletObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Jag kan inte göra det med ett äpple.');
};

TestUnit 'notWithVaporousMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare1aPerspektiv;
  gPlayerChar = gActor;
  local msg = playerActionMessages.notWithVaporousMsg(appletObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Jag kan inte göra det med ett äpple.');
};


TestUnit 'lookInVaporousMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare1aPerspektiv;
  gPlayerChar = gActor;
  local msg = playerActionMessages.lookInVaporousMsg(appletObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Jag ser bara det.');
};


// ---


TestUnit 'cannotReachObjectMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare1aPerspektiv;
  gPlayerChar = gActor;
  local msg = playerActionMessages.cannotReachObjectMsg(appletObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Jag kan inte nå det.');
};

TestUnit 'thingDescMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare1aPerspektiv;
  gPlayerChar = gActor;
  local msg = playerActionMessages.thingDescMsg(appletObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Jag ser inget ovanligt med det.');
};



TestUnit 'npcDescMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare1aPerspektiv;
  gPlayerChar = gActor;
  local msg = playerActionMessages.npcDescMsg(appletObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Jag ser inget ovanligt med äpplet.');
};


TestUnit 'noiseSourceMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare1aPerspektiv;
  gPlayerChar = gActor;
  gAction = ListenToAction.createActionInstance();
  gAction.setCurrentObjects([prassel]);
  local msg = playerActionMessages.noiseSourceMsg(skapenObjNeuterPlural);
  "<<msg>>";
  assertThat(o).startsWith('Prasslet verkar att komma från skåpen.');
};


TestUnit 'odorSourceMsg' run {
  //mainOutputStream.hideOutput = nil;
  gAction = ListenToAction.createActionInstance();
  gAction.setCurrentObjects([lukten]);
  local msg = playerActionMessages.odorSourceMsg(skapetObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Lukten verkar att komma från skåpet.');
};


TestUnit 'cannotMoveComponentMsg' run {
  //mainOutputStream.hideOutput = nil;
  gActor = spelare1aPerspektiv;
  gAction = MoveAction.createActionInstance();
  gAction.setCurrentObjects([snickargladje]);
  local msg = playerActionMessages.cannotMoveComponentMsg(skapetObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Snickareglädjen är en del av skåpet');
};


TestUnit 'cannotTakeComponentMsg singular/neutrum del av singular' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = TakeAction.createActionInstance();
  gAction.setCurrentObjects([snickargladje]);
  local msg = playerActionMessages.cannotTakeComponentMsg(dorrenObjUtrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Jag kan inte ta den; den är del av dörren.');
};

TestUnit 'cannotPutComponentMsg singular/neutrum del av plural' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = TakeAction.createActionInstance();
  gAction.setCurrentObjects([snickargladje]);
  gAction.setActors([gActor]);

  setPlayer(spelare1aPerspektiv);
  local msg = playerActionMessages.cannotPutComponentMsg(dorrarObjUterPlural);
  "<<msg>>";
  assertThat(o).startsWith('Jag kan inte lägga den någonstans; den är en del av dörrarna');
};

TestUnit 'droppingObjMsg' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.droppingObjMsg(hatt);
  "<<msg>>";
  assertThat(o).startsWith('Jag släpper hatten.');
};


TestUnit 'floorlessDropMsg' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.floorlessDropMsg(hatt);
  "<<msg>>";
  assertThat(o).startsWith('Den faller utom synhåll nedanför.');
};

// ...........

TestUnit 'cannotMoveThroughMsg' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  local msg = playerActionMessages.cannotMoveThroughMsg(appletObjNeutrumSingular, roret);
  "<<msg>>";
  assertThat(o).startsWith('Jag kan inte förflytta det genom röret.');
};

TestUnit 'cannotMoveThroughContainerMsg' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  local msg = playerActionMessages.cannotMoveThroughContainerMsg(appletObjNeutrumSingular, roret);
  "<<msg>>";
  assertThat(o).startsWith('Jag kan inte förflytta det genom röret.');
};

TestUnit 'cannotMoveThroughClosedMsg' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = MoveWithAction.createActionInstance();
  gAction.setCurrentObjects([appletObjNeutrumSingular, roret]);
  local msg = playerActionMessages.cannotMoveThroughClosedMsg(appletObjNeutrumSingular, roret);
  "<<msg>>";
  assertThat(o).startsWith('Jag kan inte göra det då röret är stängt.');
};

TestUnit 'cannotFitIntoOpeningMsg' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([appletObjNeutrumSingular]);
  local msg = playerActionMessages.cannotFitIntoOpeningMsg(appletObjNeutrumSingular, roret);
  "<<msg>>";
  assertThat(o).startsWith('Jag kan inte göra det då äpplet är för stort för att sätta in i röret.');
};

TestUnit 'cannotFitOutOfOpeningMsg' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.cannotFitOutOfOpeningMsg(appletObjNeutrumSingular, roret);
  "<<msg>>";
  assertThat(o).startsWith('Jag kan inte göra det då äpplet är för stort för att ta ut ur röret.');
};


TestUnit 'cannotTouchThroughContainerMsg' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = FeelAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.cannotTouchThroughContainerMsg(gActor, roret);
  "<<msg>>";
  assertThat(o).startsWith('Jag kan inte nå någonting genom röret.');
};

TestUnit 'cannotTouchThroughClosedMsg' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = FeelAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.cannotTouchThroughClosedMsg(gActor, roret);
  "<<msg>>";
  assertThat(o).startsWith('Jag kan inte göra det då röret är stängt.');
};

TestUnit 'cannotReachIntoOpeningMsg' run {
  setPlayer(spelare2aPerspektiv);
  gActor = spelare2aPerspektiv;
  gAction = TakeAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);

  local msg = playerActionMessages.cannotReachIntoOpeningMsg(gActor, roret);
  "<<msg>>";
  assertThat(o).startsWith('Du kan inte få in din hand i röret.');
};

TestUnit 'cannotReachOutOfOpeningMsg' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gPlayerChar = gActor;
  gAction = TakeAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.cannotReachOutOfOpeningMsg(gActor, roret);
  "<<msg>>";
  assertThat(o).startsWith('Jag kan inte få in min hand genom röret.');
};


TestUnit 'tooLargeForActorMsg(obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = TakeAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.tooLargeForActorMsg(skapetObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Skåpet är för stort för mig att hålla.');
};

TestUnit 'handsTooFullForMsg(obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = TakeAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.handsTooFullForMsg(hatt);
  "<<msg>>";
  // TODO: hantera även dina/deras/dessas händer osv..
  assertThat(o).startsWith('Mina händer är för fulla för att även hålla hatten.');
};

TestUnit 'becomingTooLargeForActorMsg(obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = TakeAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.becomingTooLargeForActorMsg(hatt);
  "<<msg>>";
  assertThat(o)
  .startsWith('Jag kan inte göra det då hatten skulle bli för stor för mig att hålla.');
};

TestUnit 'handsBecomingTooFullForMsg(obj) 1a person' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = TakeAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.handsBecomingTooFullForMsg(hatt);
  "<<msg>>";
  assertThat(o)
    .startsWith('Jag kan inte göra det då mina händer skulle bli för fulla för att kunna hålla den.');
   
};

TestUnit 'handsBecomingTooFullForMsg(obj) 2a person' run {
  setPlayer(spelare2aPerspektiv);
  gActor = spelare2aPerspektiv;
  gPlayerChar = gActor;
  gAction = TakeAction.createActionInstance();
  gAction.setCurrentObjects([roret]);
  local msg = playerActionMessages.handsBecomingTooFullForMsg(roret);
  "<<msg>>";
  assertThat(o)
    .startsWith('Du kan inte göra det då dina händer skulle bli för fulla för att kunna hålla det.');
};


TestUnit 'obscuredReadDesc 3de person utrum plural' run {
  //mainOutputStream.hideOutput = nil;
  setPlayer(spelare3dePerspektiv);
  gActor = spelare3dePerspektiv;
  gPlayerChar = spelare3dePerspektiv;
  libMessages.obscuredReadDesc(skyltarObjUtrumPlural);
  assertThat(o).startsWith('Bob kan inte se dem bra nog för att kunna läsa dem.');
};

// TODO: fixa test, texten kan inte genereras som det är nu.
// TestUnit 'handsBecomingTooFullForMsg(obj) 3de person' run {
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
//     .startsWith('Bob kan inte göra det då hans händer skulle bli för fulla för att kunna hålla det.');
// };


TestUnit 'tooHeavyForActorMsg(obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  local msg = playerActionMessages.tooHeavyForActorMsg(hatt);
  "<<msg>>";
  assertThat(o).startsWith('Hatten är för tung för mig att plocka upp.');
};

TestUnit 'totalTooHeavyForMsg(obj)' run {
  //mainOutputStream.hideOutput = nil;
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = TakeAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.totalTooHeavyForMsg(hatt);
  "<<msg>>";
  assertThat(o).startsWith('Hatten är för tung; jag behöver sätta ner någonting först.');
};

TestUnit 'tooLargeForContainerMsg(obj, cont)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.tooLargeForContainerMsg(hatt, roret);
  "<<msg>>";
  assertThat(o).startsWith('Hatten är för stor för röret.');
};

TestUnit 'tooLargeForUndersideMsg(obj, cont)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.tooLargeForUndersideMsg(hatt, skapetObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Hatten är för stor för att stoppa in under skåpet');
};

TestUnit 'tooLargeForRearMsg(obj, cont)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.tooLargeForRearMsg(hatt, skapenObjNeuterPlural);
  "<<msg>>";
  assertThat(o).startsWith('Hatten är för stor för att stoppa in bakom skåpen.');
};

TestUnit 'containerTooFullMsg(obj, cont)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.containerTooFullMsg(hatt, skapetObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('skåpet är redan för fullt för att få plats med den.');
};

TestUnit 'surfaceTooFullMsg(obj, cont)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.surfaceTooFullMsg(hatt, bankraden);
  "<<msg>>";
  assertThat(o).startsWith('Det finns inget rum för den på bänkraden.');
};

TestUnit 'undersideTooFullMsg(obj, cont)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.undersideTooFullMsg(hatt, bankraden);
  "<<msg>>";
  assertThat(o).startsWith('Det finns inget rum för den under bänkraden.');
};

TestUnit 'rearTooFullMsg(obj, cont)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.rearTooFullMsg(hatt, skapetObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Det finns inget rum för den bakom skåpet.');
};

TestUnit 'becomingTooLargeForContainerMsg(obj, cont)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.becomingTooLargeForContainerMsg(hatt, dorrenObjUtrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Jag kan inte göra det då det skulle göra den för stor för dörren.');
};

TestUnit 'containerBecomingTooFullMsg(obj, cont)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.containerBecomingTooFullMsg(hatt, skapetObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Jag kan inte göra det för att hatten skulle inte längre få plats i skåpet.');
};

TestUnit 'takenAndMovedToKeyringMsg(keyring)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([nyckel]);
  local msg = playerActionMessages.takenAndMovedToKeyringMsg(nyckelring);
  "<<msg>>";
  assertThat(o).startsWith('Jag plockar upp nyckeln och fäster den i nyckelringen');
};

TestUnit 'movedKeyToKeyringMsg(keyring)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([nyckel]);
  local msg = playerActionMessages.movedKeyToKeyringMsg(nyckelring);
  "<<msg>>";
  assertThat(o).startsWith('Jag fäster nyckeln i nyckelringen');
};

TestUnit 'movedKeysToKeyringMsg(keyring, keys)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([nyckel]);
  local msg = playerActionMessages.movedKeysToKeyringMsg(nyckelring, [nyckel]);
  "<<msg>>";
  assertThat(o).startsWith('Jag fäster min lösa nyckel i nyckelringen.');
};

// TODO: Förbättra objekten till kläder 
TestUnit 'circularlyInMsg(x, y)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([nyckel]);
  local msg = playerActionMessages.circularlyInMsg(nyckel, nyckelring);
  "<<msg>>";
  assertThat(o).startsWith('Jag kan inte göra det då nyckeln är i nyckelringen.');
};

// TODO: Förbättra objekten till kläder
TestUnit 'circularlyOnMsg(x, y)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.circularlyOnMsg(hatt, bankraden);
  "<<msg>>";
  assertThat(o).startsWith('Jag kan inte göra det då hatten är på bänkraden.');
};

// TODO: Förbättra objekten till kläder
TestUnit 'circularlyUnderMsg(x, y)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.circularlyUnderMsg(hatt, skapetObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Jag kan inte göra det då hatten är under skåpet.');
};

// TODO: Förbättra objekten till kläder
TestUnit 'circularlyBehindMsg(x, y)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.circularlyBehindMsg(hatt, skapetObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Jag kan inte göra det då hatten är bakom skåpet.');
};

TestUnit 'willNotLetGoMsg(holder, obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = TakeAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.willNotLetGoMsg(hobbit, hatt);
  "<<msg>>";
  assertThat(o).startsWith('Hobbiten låter inte mig få den.');
};

TestUnit 'cannotGoThroughClosedDoorMsg(door)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = EnterAction.createActionInstance();
  gAction.setCurrentObjects([dorrenObjUtrumSingular]);
  local msg = playerActionMessages.cannotGoThroughClosedDoorMsg(dorrenObjUtrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Jag kan inte göra det då dörren är stängd.');
};

// TODO: Keep going, you can do it!
TestUnit 'invalidStagingContainerMsg(cont, dest)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.invalidStagingContainerMsg(baren, bankraden);
  "<<msg>>";
  assertThat(o).startsWith('Jag kan inte göra det medan bänkraden är i baren.');
};

TestUnit 'invalidStagingContainerActorMsg(cont, dest)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = TravelAction.createActionInstance();
  local msg = playerActionMessages.invalidStagingContainerActorMsg(hobbit, dorrarObjUterPlural);
  "<<msg>>";
  assertThat(o).startsWith('Jag kan inte göra det då hobbiten håller i dörrarna.');
};

TestUnit 'invalidStagingLocationMsg(dest)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.invalidStagingLocationMsg(hatt);
  "<<msg>>";
  assertThat(o).startsWith('Jag kan inte gå in i hatten.'); // TODO: Rätt?
};

TestUnit 'nestedRoomTooHighMsg(obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.nestedRoomTooHighMsg(hatt);
  "<<msg>>";
  assertThat(o).startsWith('Hatten är för hög att nå härifrån.');
};

TestUnit 'nestedRoomTooHighToExitMsg(obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.nestedRoomTooHighToExitMsg(hatt);
  "<<msg>>";
  assertThat(o).startsWith('Det är alltför långt fall ner för att kunna göra det härifrån.');
};

TestUnit 'cannotDoFromMsg(obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.cannotDoFromMsg(hatt);
  "<<msg>>";
  assertThat(o).startsWith('Jag kan inte göra det från den.');
};

TestUnit 'vehicleCannotDoFromMsg(obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  hatt.location = baren;
  local msg = playerActionMessages.vehicleCannotDoFromMsg(hatt);
  "<<msg>>";
  assertThat(o).startsWith('Jag kan inte göra det medan hatten är i baren');
};

TestUnit 'cannotGoThatWayInVehicleMsg(traveler)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = TravelAction.createActionInstance();
  local msg = playerActionMessages.cannotGoThatWayInVehicleMsg(vagnen);
  "<<msg>>";
  assertThat(o).startsWith('Jag kan inte göra det i vagnen.');
};

TestUnit 'cannotPushObjectThatWayMsg(obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = PushAction.createActionInstance();
  gAction.setCurrentObjects([vagnen]);
  local msg = playerActionMessages.cannotPushObjectThatWayMsg(vagnen);
  "<<msg>>";
  assertThat(o).startsWith('Jag kan inte knuffa den i den riktningen.');
};

TestUnit 'cannotPushObjectNestedMsg(obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = PushAction.createActionInstance();
  gAction.setCurrentObjects([vagnen]);
  local msg = playerActionMessages.cannotPushObjectNestedMsg(vagnen);
  "<<msg>>";
  assertThat(o).startsWith('Jag kan inte knuffa den dit.');
};

TestUnit 'cannotEnterExitOnlyMsg(obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.cannotEnterExitOnlyMsg(hatt);
  "<<msg>>";
  assertThat(o).startsWith('Jag kan inte gå in i den härifrån.');
};

TestUnit 'mustOpenDoorMsg(obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  local msg = playerActionMessages.mustOpenDoorMsg(dorrarObjUterPlural);
  "<<msg>>";
  assertThat(o).startsWith('Jag behöver öppna dem först.');
};

TestUnit 'doorClosesBehindMsg(obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = TravelAction.createActionInstance();
  local msg = playerActionMessages.doorClosesBehindMsg(dorrarObjUterPlural);
  "<<msg>>";
  assertThat(o).contains('efter att jag går igenom dem, stänger sig dörrarna bakom mig.');
};


TestUnit 'refuseCommand(targetActor, issuingActor)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  local msg = playerActionMessages.refuseCommand(hobbit, gActor);
  "<<msg>>";
  assertThat(o).startsWith('Hobbiten vägrar min begäran.');
};


TestUnit 'refuseCommand(targetActor, issuingActor)' run {
  setPlayer(spelare2aPerspektiv);
  gActor = spelare2aPerspektiv;
  local msg = playerActionMessages.refuseCommand(hobbit, gActor);
  "<<msg>>";
  assertThat(o).startsWith('Hobbiten vägrar din begäran.');
};


TestUnit 'refuseCommand(targetActor, issuingActor)' run {
  setPlayer(spelare3dePerspektiv);
  gActor = spelare3dePerspektiv;
  local msg = playerActionMessages.refuseCommand(hobbit, gActor);
  "<<msg>>";
  assertThat(o).startsWith('Hobbiten vägrar Bobs begäran.');
};

TestUnit 'notAddressableMsg(obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.notAddressableMsg(hatt);
  "<<msg>>";
  assertThat(o).startsWith('Jag kan inte prata med den.');
};

TestUnit 'noResponseFromMsg(other)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.noResponseFromMsg(hatt);
  "<<msg>>";
  assertThat(o).startsWith('Hatten svarar inte.');
};

TestUnit 'notInterestedMsg(actor)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  local msg = playerActionMessages.notInterestedMsg(pirat);
  "<<msg>>";
  assertThat(o).startsWith('\^piraten verkar ointresserad.');
};

TestUnit 'objCannotHearActorMsg(obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([pirat]);
  local msg = playerActionMessages.objCannotHearActorMsg(pirat);
  "<<msg>>";
  assertThat(o).startsWith('\^piraten verkar inte kunna höra mig.');
};

TestUnit 'actorCannotSeeMsg(actor, obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hobbit]);
  local msg = playerActionMessages.actorCannotSeeMsg(hobbit, hatt);
  "<<msg>>";
  assertThat(o).startsWith('\^hobbiten verkar oförmögen att se hatten.');
};

TestUnit 'cannotFollowFromHereMsg(srcLoc)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.cannotFollowFromHereMsg(hatt);
  "<<msg>>";
  assertThat(o).startsWith('Den senaste platsen jag såg hatten är baren.');
};

TestUnit 'okayPushTravelMsg(obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.okayPushTravelMsg(hatt);
  "<<msg>>";
  assertThat(o).contains('Jag trycker in hatten i utrymmet.');
};

TestUnit 'mustBeBurningMsg(obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([ljuset]);
  local msg = playerActionMessages.mustBeBurningMsg(ljuset);
  "<<msg>>";
  assertThat(o).startsWith('Jag behöver tända stearinljuset före jag kan göra det.');
};

TestUnit 'mustDetachMsg(obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.mustDetachMsg(hatt);
  "<<msg>>";
  assertThat(o).startsWith('Jag behöver ta loss den före jag kan göra det.');
};

TestUnit 'foundKeyOnKeyringMsg(ring, key)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = ExamineAction.createActionInstance();
  gAction.setCurrentObjects([nyckel]);
  local msg = playerActionMessages.foundKeyOnKeyringMsg(nyckelring, nyckel);
  "<<msg>>";
  assertThat(o).startsWith('Jag försöker varje nyckel på nyckelringen, och upptäcker att nyckeln passar låset.');
};

TestUnit 'foundNoKeyOnKeyringMsg(ring)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([nyckelring]);
  local msg = playerActionMessages.foundNoKeyOnKeyringMsg(nyckelring);
  "<<msg>>";
  assertThat(o).startsWith('Jag försöker varje nyckel på nyckelringen, men jag hittar inte någon som passar låset.');
};

TestUnit 'playerActionMessages.roomOkayPostureChangeMsg(posture, obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  local msg = playerActionMessages.roomOkayPostureChangeMsg(sitting, baren);
  "<<msg>>";
  assertThat(o).startsWith('Ok, jag sitter nu i baren.');
};

TestUnit 'playerActionMessages.okayPostureChangeMsg(posture, obj)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  local msg = playerActionMessages.okayPostureChangeMsg(sitting);
  "<<msg>>";
  assertThat(o).startsWith('Ok, jag sätter mig ner.');
};

TestUnit 'npcActionMessages.okayPostureChangeMsg(posture, obj)' run {
  setPlayer(spelare3dePerspektiv);
  gActor = spelare3dePerspektiv;
  local msg = npcActionMessages.okayPostureChangeMsg(sitting);
  "<<msg>>";
  assertThat(o).startsWith('Bob sätter sig ner.');
};

TestUnit 'npcActionMessages.okayPostureChangeMsg(posture, obj) plural' run {
  setPlayer(musketorer);
  gActor = musketorer;
  local msg = npcActionMessages.okayPostureChangeMsg(sitting);
  "<<msg>>";
  assertThat(o).startsWith('Musketörerna sätter sig ner.');
};

TestUnit 'cannotThrowThroughMsg(target, loc)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.cannotThrowThroughMsg(hatt, baren);
  "<<msg>>";
  assertThat(o).startsWith('Jag kan inte kasta någonting genom baren.');
};

TestUnit 'throwHitMsg(projektilen, target)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = ThrowAtAction.createActionInstance();
  gAction.setCurrentObjects([hatt, hobbit]);
  local msg = playerActionMessages.throwHitMsg(hatt, hobbit);
  "<<msg>>";
  assertThat(o).startsWith('Hatten träffar hobbiten utan någon uppenbar effekt.');
};

TestUnit 'throwFallMsg(projektilen, target)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = ThrowAtAction.createActionInstance();
  gAction.setCurrentObjects([hatt, hobbit]);
  local msg = playerActionMessages.throwFallMsg(hatt, hobbit);
  "<<msg>>";
  assertThat(o).startsWith('Hatten landar på hobbiten.');
};

TestUnit 'throwHitFallMsg(projektilen, target, dest)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.throwHitFallMsg(hatt, hobbit, bankraden);
  "<<msg>>";
  assertThat(o).startsWith('Hatten träffar hobbiten utan någon uppenbar effekt, och faller ner på bänkraden.');
};

TestUnit 'throwShortMsg(projektilen, target)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.throwShortMsg(hatt, hobbit);
  "<<msg>>";
  assertThat(o).startsWith('Hatten faller långtifrån hobbiten.');
};

TestUnit 'throwFallShortMsg(projektilen, target, dest)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.throwFallShortMsg(hatt, hobbit, baren);
  "<<msg>>";
  assertThat(o).startsWith('Hatten faller i baren långtifrån hobbiten.');
};

TestUnit 'throwCatchMsg(obj, target)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.throwCatchMsg(hatt, hobbit);
  "<<msg>>";
  assertThat(o).startsWith('\^hobbiten fångar hatten.');
};

TestUnit 'willNotCatchMsg(catcher)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.willNotCatchMsg(hobbit);
  "<<msg>>";
  assertThat(o).startsWith('\^hobbiten ser inte ut som han vill fånga någonting.');
};

TestUnit 'tooLargeForContainerMsg(obj, cont)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  local msg = playerActionMessages.tooLargeForContainerMsg(hatt, skapetObjNeutrumSingular);
  "<<msg>>";
  assertThat(o).startsWith('Hatten är för stor för skåpet.');
};


TestUnit 'missingObject(actor, action, which)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gActor.referralPerson = DirectObject;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  playerMessages.missingObject(gActor, gAction, DirectObject);
  assertThat(o).startsWith('Du behöver vara specifik om vad du vill');
};


TestUnit 'missingActor(actor)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gActor.referralPerson = DirectObject;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  playerMessages.missingActor(gActor);
  assertThat(o).startsWith('Du behöver vara mer specifik om vem du vill addressera.');
};

TestUnit 'singleActorRequired(actor)' run {
  setPlayer(spelare1aPerspektiv);
  gActor = spelare1aPerspektiv;
  gActor.referralPerson = DirectObject;
  gAction = DropAction.createActionInstance();
  gAction.setCurrentObjects([hatt]);
  playerMessages.singleActorRequired(gActor);
  assertThat(o).startsWith('Du kan bara addressera en person åt gången.');
};



// TODO: kontrollera om det blir ett problem med 
// itNom {return [ (isUter ? 'den':'det'), 'han', 'hon', 'de'][pronounSelector]; }
// blir bara ett problem när den väljs, inte 'det'

TestUnit 'cannotTalkTo(targetActor, issuingActor) #1' run {
  //mainOutputStream.hideOutput = nil;
  setPlayer(pirat);
  gActor = pirat;
  playerMessages.cannotTalkTo(hobbit, pirat);
  assertThat(o).startsWith('\^hobbiten är inte någonting du kan prata med.');
};

TestUnit 'cannotTalkTo(targetActor, issuingActor) #2' run {
  //mainOutputStream.hideOutput = nil;
  setPlayer(pirat);
  gActor = pirat;
  playerMessages.cannotTalkTo(pirat, hobbit);
  assertThat(o).startsWith('\^du är inte någonting han kan prata med.');
};

TestUnit 'cannotTalkTo(targetActor, issuingActor) #3' run {
  //mainOutputStream.hideOutput = nil;
  setPlayer(apan);
  gActor = apan;  
  apan.pcReferralPerson = FirstPerson;
  playerMessages.cannotTalkTo(hobbit, apan);
  assertThat(o).startsWith('\^hobbiten är inte någonting jag kan prata med.');
  mainOutputStream.capturedOutputBuffer = new StringBuffer();

  apan.pcReferralPerson = SecondPerson;
  playerMessages.cannotTalkTo(hobbit, apan);
  assertThat(o).startsWith('\^hobbiten är inte någonting du kan prata med.');
  
  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  apan.pcReferralPerson = ThirdPerson;
  playerMessages.cannotTalkTo(hobbit, apan);
  assertThat(o).startsWith('\^hobbiten är inte någonting den kan prata med.');

};


TestUnit 'alreadyTalkingTo(actor, greeter)' run {
  //mainOutputStream.hideOutput = nil;
  setPlayer(apan);
  gActor = apan;  
  apan.pcReferralPerson = FirstPerson;
  playerMessages.alreadyTalkingTo(hobbit, apan);
  assertThat(o).startsWith('\^jag har redan hobbitens uppmärksamhet.');
  mainOutputStream.capturedOutputBuffer = new StringBuffer();

  apan.pcReferralPerson = SecondPerson;
  playerMessages.alreadyTalkingTo(hobbit, apan);
  assertThat(o).startsWith('\^du har redan hobbitens uppmärksamhet.');
  
  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  apan.pcReferralPerson = ThirdPerson;
  playerMessages.alreadyTalkingTo(hobbit, apan);
  assertThat(o).startsWith('\^apan har redan hobbitens uppmärksamhet.');
};


TestUnit 'againCannotChangeActor' run {
  //mainOutputStream.hideOutput = nil;
  setPlayer(pirat);
  gActor = pirat;
  local msg = playerMessages.againCannotChangeActor();
  "<<msg>>";
  assertThat(o).contains('För att repetera ett kommando som <q>sköldpadda, gå norrut,</q>
säg bara <q>igen,</q> inte <q>sköldpadda, igen.</q>');
};

TestUnit 'againCannotTalkToTarget' run {
  //mainOutputStream.hideOutput = nil;
  setPlayer(pirat);
  gActor = pirat;
  playerMessages.againCannotTalkToTarget(hobbit, apan);
  assertThat(o).contains('\^hobbiten kan inte repetera det kommandot.');

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
  

TestUnit 'askMissingLiteral(actor, action, which)' run {
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
    TurnOnAction -> 'vad vill du slå på',
    TurnOffAction -> 'vad vill du stänga av',
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

TestUnit 'playerMessages.askMissingObject' run {
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


TestUnit 'npcMessages.askMissingObject' run {
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


TestUnit 'npcDeferredMessagesDirect.askMissingObject' run {
  //mainOutputStream.hideOutput = nil;
  local actionTextPairs = 
  [
      AttackWithAction -> '\^matrosen säger, <q>Jag förstår inte vad du vill att jag ska attackera med.</q>',
      DigWithAction -> '\^matrosen säger, <q>Jag förstår inte vad du vill att jag ska gräva med.</q>',
      MoveWithAction -> '\^matrosen säger, <q>Jag förstår inte vad du vill att jag ska flytta med.</q>',
      TurnWithAction -> '\^matrosen säger, <q>Jag förstår inte vad du vill att jag ska vrida med.</q>',
      BurnWithAction-> '\^matrosen säger, <q>Jag förstår inte vad du vill att jag ska tända med.</q>',
      CutWithAction -> '\^matrosen säger, <q>Jag förstår inte vad du vill att jag ska klippa med.</q>',
      CleanWithAction -> '\^matrosen säger, <q>Jag förstår inte vad du vill att jag ska rengöra med.</q>',
      LockWithAction -> '\^matrosen säger, <q>Jag förstår inte vad du vill att jag ska låsa med.</q>',
      UnlockWithAction -> '\^matrosen säger, <q>Jag förstår inte vad du vill att jag ska låsa upp med.</q>',
      ScrewWithAction -> '\^matrosen säger, <q>Jag förstår inte vad du vill att jag ska skruva med.</q>',
      UnscrewWithAction -> '\^matrosen säger, <q>Jag förstår inte vad du vill att jag ska skruva loss med.</q>'
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

TestUnit 'npcMessagesDirect.askMissingObject' run {
  //mainOutputStream.hideOutput = nil;
  local actionTextPairs = 
  [
      AttackWithAction -> '\^matrosen säger, <q>\^vad vill du att jag ska attackera med?</q>',
      DigWithAction -> '\^matrosen säger, <q>\^vad vill du att jag ska gräva med?</q>',
      MoveWithAction -> '\^matrosen säger, <q>\^vad vill du att jag ska flytta med?</q>',
      TurnWithAction -> '\^matrosen säger, <q>\^vad vill du att jag ska vrida med?</q>',
      BurnWithAction-> '\^matrosen säger, <q>\^vad vill du att jag ska tända med?</q>',
      CutWithAction -> '\^matrosen säger, <q>\^vad vill du att jag ska klippa med?</q>',
      CleanWithAction -> '\^matrosen säger, <q>\^vad vill du att jag ska rengöra med?</q>',
      LockWithAction -> '\^matrosen säger, <q>\^vad vill du att jag ska låsa med?</q>',
      UnlockWithAction -> '\^matrosen säger, <q>\^vad vill du att jag ska låsa upp med?</q>',
      ScrewWithAction -> '\^matrosen säger, <q>\^vad vill du att jag ska skruva med?</q>',
      UnscrewWithAction -> '\^matrosen säger, <q>\^vad vill du att jag ska skruva loss med?</q>'
      
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


TestUnit 'playerMessages.missingLiteral' run {
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

TestUnit 'npcMessages.missingLiteral' run {
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

TestUnit 'playerMessages.noMatchForPossessive' run {
  //mainOutputStream.hideOutput = nil;
  setPlayer(pirat);
  gActor = pirat;
  playerMessages.noMatchForPossessive(gActor, apan, nil);
  assertThat(o).contains('\^apan verkar inte ha någon sådan sak.');
};

TestUnit 'playerMessages.noMatchForPluralPossessive' run {
  //mainOutputStream.hideOutput = nil;
  setPlayer(pirat);
  gActor = pirat;
  playerMessages.noMatchForPluralPossessive(gActor, nil);
  assertThat(o).contains('\^de verkar inte ha någon sådan sak');
};

TestUnit 'playerMessages.noMatchForLocation' run {
  //mainOutputStream.hideOutput = nil;
  setPlayer(pirat);
  gActor = pirat;
  gActor.location = masten;
  playerMessages.noMatchForLocation(gActor, masten, 'kikare');
  assertThat(o).contains('\^du ser inget liknande här.');
};

TestUnit 'playerMessages.noMatchForLocation' run {
  //mainOutputStream.hideOutput = nil;
  setPlayer(pirat);
  gActor = pirat;
  gActor.location = masten;
  playerMessages.noMatchForLocation(apan, masten, 'kikare');
  assertThat(o).contains('\^apan ser inget liknande här.');
};

TestUnit 'playerMessages.nothingInLocation 2d' run {
  //mainOutputStream.hideOutput = nil;
  setPlayer(pirat);
  gActor = pirat;
  gActor.location = masten;
  playerMessages.nothingInLocation(gActor, masten);
  assertThat(o).contains('\^du ser inget ovanligt på marken.');
};

TestUnit 'playerMessages.nothingInLocation 3d' run {
  //mainOutputStream.hideOutput = nil;
  setPlayer(pirat);
  gActor = pirat;
  gActor.location = masten;
  playerMessages.nothingInLocation(apan, masten);
  assertThat(o).contains('\^apan ser inget ovanligt på marken.');
};


TestUnit 'playerMessages.nothingInLocation 3d' run {
  //mainOutputStream.hideOutput = nil;
  setPlayer(pirat);
  gActor = pirat;
  gActor.location = masten;
  playerMessages.nothingInLocation(apan, masten);
  assertThat(o).contains('\^apan ser inget ovanligt på marken.');
};

TestUnit 'libMessages' run {
    local pairs = [
      &finishDeathMsg -> 'DU HAR DÖTT',
      &finishVictoryMsg -> 'DU HAR VUNNIT',
      &finishFailureMsg -> 'DU HAR MISSLYCKATS',
      &finishGameOverMsg -> 'SPELET SLUT'
  ];
  pairs.forEachAssoc(function(msg, expectedOutput) {
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
     "<<libMessages.(msg)>>";
    local str = o.findReplace('  ', ' ', ReplaceAll);
    assertThat(str).isEqualTo(expectedOutput);
  });
};


TestUnit 'playerActionMessages sig/dig' run {
  //mainOutputStream.hideOutput = nil;
    setPlayer(spelare3dePerspektiv);
    gActor = spelare3dePerspektiv;
    gAction = WearAction.createActionInstance();
    gAction.setCurrentObjects([skapetObjNeutrumSingular]);
    local pairs = [
        //&notWearableMsg -> 'Det är inte någonting som Bob kan klä på sig.',
        &notDoffableMsg -> 'Det där är inte någonting som Bob kan ta av sig.'
    ];
  pairs.forEachAssoc(function(msg, expectedOutput) {
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
     "<<playerActionMessages.(msg)>>";
    local str = o.findReplace('  ', ' ', ReplaceAll);
    assertThat(str).startsWith(expectedOutput);
  });
};


TestUnit 'playerActionMessages' run {
    //mainOutputStream.hideOutput = nil;
    setPlayer(pirat);
    gActor = pirat;
    gAction = UnlockWithAction.createActionInstance();
    gAction.setCurrentObjects([tingest, sak]);
    local pairs = [
      &cannotDoThatMsg -> 'Du kan inte göra det.',
      &tooDarkMsg -> 'Det är för mörkt för att göra det.',
      &noKeyNeededMsg -> 'Tingesten verkar inte behöva en nyckel',
      &mustBeStandingMsg -> 'Du behöver stå upp före du kan göra det.',
      &nothingInsideMsg -> 'Det är inget ovanligt i tingesten.',
      &nothingUnderMsg -> 'Du ser inget ovanligt under tingesten.',
      &nothingBehindMsg -> 'Du ser inget ovanligt bakom tingesten',
      &nothingThroughMsg -> 'Du ser ingenting genom tingesten',
      &cannotLookBehindMsg -> 'Du kan inte se bakom tingesten',
      &cannotLookUnderMsg -> 'Du kan inte se under tingesten',
      &cannotLookThroughMsg -> 'Du kan inte se genom tingesten',
      &nothingThroughPassageMsg -> 'Du kan inte se mycket genom tingesten härifrån',
      &nothingBeyondDoorMsg -> 'Du öppnar tingesten och finner ingenting ovanligt.',

      &nothingToSmellMsg -> 'Du känner ingen oväntad lukt.',
      &nothingToHearMsg -> 'Du hör inget oväntat.',
      &notWearableMsg -> 'Den där är inte någonting som du kan klä på dig.',
      &notDoffableMsg -> 'Den där är inte någonting som du kan ta av dig.',
      &alreadyWearingMsg -> 'Du bär redan tingesten.',
      &notWearingMsg -> 'Du har inte på dig den.',
      &okayWearMsg -> 'Okej, du klär på dig tingesten',
      &okayDoffMsg -> 'Okej, du tar av dig tingesten',
      &okayOpenMsg -> 'Öppnad.',
      &okayCloseMsg -> 'Stängd.',
      &okayLockMsg -> 'Låst.',
      &okayUnlockMsg -> 'Upplåst.',
      &cannotDigMsg -> 'Du har ingen anledning att gräva i den där.',
      &cannotDigWithMsg -> 'Du ser inget sätt att använda den så som en spade.',
      &alreadyHoldingMsg -> 'Du har redan tingesten.',
      &takingSelfMsg -> 'Du kan inte plocka upp dig själv',
      &notCarryingMsg -> 'Du bär inte på den.',
      &droppingSelfMsg -> 'Du kan inte släppa dig själv.',
      &puttingSelfMsg -> 'Du kan inte göra det med dig själv.',
      &throwingSelfMsg -> 'Du kan inte kasta dig själv.',
      &alreadyPutInMsg -> 'Tingesten är redan i saken.',
      &alreadyPutOnMsg -> 'Tingesten är redan på saken.',
      &alreadyPutUnderMsg -> 'Tingesten är redan under saken.',
      &alreadyPutBehindMsg -> 'Tingesten är redan bakom saken.',
      &cannotMoveFixtureMsg -> 'Tingesten kan inte flyttas',
      &cannotTakeFixtureMsg -> 'Du kan inte ta den.',
      &cannotPutFixtureMsg -> 'Du kan inte stoppa tingesten någonstans',
      &cannotTakeImmovableMsg -> 'Du kan inte ta den.',
      &cannotMoveImmovableMsg -> 'Tingesten kan inte flyttas.',
      &cannotPutImmovableMsg -> 'Du kan inte stoppa tingesten någonstans',
      &cannotTakeHeavyMsg -> 'Den är för tung.',
      &cannotMoveHeavyMsg -> 'Den är för tung.',
      &cannotPutHeavyMsg -> 'Den är för tung.',
      &cannotTakePushableMsg -> 'Du kan inte ta den, men det kan vara möjligt att knuffa den någonstans.',
      &cannotMovePushableMsg -> 'Det skulle inte åstadkomma någonting att flytta runt tingesten riktningslöst, men det kanske är möjligt att flytta den i en specifik riktning.',
      &cannotPutPushableMsg -> 'Du kan inte stoppa den någonstans, men det kan vara möjligt att knuffa den någonstans.',
      &cannotTakeLocationMsg -> 'Du kan inte plocka upp den medan du uppehåller den',
      &cannotRemoveHeldMsg -> 'Det finns ingenting att ta bort tingesten ifrån.',
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
      &cannotTakePersonMsg -> 'Tingesten skulle antagligen inte uppskatta det.',
      &cannotMovePersonMsg -> 'Tingesten skulle antagligen inte uppskatta det.',
      &cannotPutPersonMsg -> 'Tingesten skulle antagligen inte uppskatta det.',
      &cannotTastePersonMsg -> 'Tingesten skulle antagligen inte uppskatta det.',

      &notAContainerMsg -> 'Du kan inte stoppa någonting i saken.',
      &notASurfaceMsg -> 'Det finns ingen bra yta på saken.',
      &cannotPutUnderMsg -> 'Du kan inte stoppa någonting under den.',
      &cannotPutBehindMsg -> 'Du kan inte stoppa in någonting bakom saken.',
      &cannotPutInSelfMsg -> 'Du kan inte stoppa tingesten i sig själv.',
      &cannotPutOnSelfMsg -> 'Du kan inte stoppa tingesten på sig själv.',
      &cannotPutUnderSelfMsg -> 'Du kan inte stoppa tingesten under sig själv.',
      &cannotPutBehindSelfMsg -> 'Du kan inte stoppa tingesten bakom sig själv.',
      &cannotPutInRestrictedMsg -> 'Du kan inte stoppa den i saken.',
      &cannotPutOnRestrictedMsg -> 'Du kan inte stoppa den på saken.',
      &cannotPutUnderRestrictedMsg -> 'Du kan inte stoppa den under saken.',
      &cannotPutBehindRestrictedMsg -> 'Du kan inte stoppa den bakom saken.',
      &cannotReturnToDispenserMsg -> 'Du kan inte stoppa tillbaka en tingest i saken.',
      &cannotPutInDispenserMsg -> 'Du kan inte stoppa en tingest i saken.',
      &objNotForKeyringMsg -> 'Tingesten passar inte på saken.',
      &keyNotOnKeyringMsg -> 'Tingesten sitter inte fast i saken.',
      &keyNotDetachableMsg -> 'Tingesten sitter inte fast i någonting.',
      &takeFromNotInMsg -> 'Tingesten är inte i den.',
      &takeFromNotOnMsg -> 'Tingesten är inte på den.',
      &takeFromNotUnderMsg -> 'Tingesten är inte under den.',
      &takeFromNotBehindMsg -> 'Tingesten är inte bakom den.',
      &takeFromNotInActorMsg -> 'Saken har inte den.',
      &whereToGoMsg -> 'Du behöver ange vilken väg att gå',
      &cannotGoThatWayMsg -> 'Du kan inte gå ditåt.',
      &cannotGoThatWayInDarkMsg -> 'Det är för mörkt; du kan inte se var du går.',
      &cannotGoBackMsg -> 'Du vet inte hur man återvänder härifrån.',
      &cannotDoFromHereMsg -> 'Du kan inte göra det härifrån.',
      &stairwayNotUpMsg -> 'Tingesten går bara ner härifrån.',
      &stairwayNotDownMsg -> 'Tingesten går bara upp härifrån.',
      //&timePassesMsg -> 'Tiden går...',
      &sayHelloMsg -> 'Du behöver vara mer specifik om vem du vill prata med.',
      &sayGoodbyeMsg -> 'Du behöver vara mer specifik om vem du vill prata med.',
      &sayYesMsg -> 'Du behöver vara mer specifik om vem du vill prata med.',
      &sayNoMsg -> 'Du behöver vara mer specifik om vem du vill prata med.',
      &okayYellMsg -> 'Du skriker så högt du bara kan.',
      &okayJumpMsg -> 'Du hoppar och landar på samma ställe.',
      &cannotJumpOverMsg -> 'Du kan inte hoppa över den.',
      &cannotJumpOffMsg -> 'Du kan inte hoppa av den.',
      &cannotJumpOffHereMsg -> 'Det finns ingenting att hoppa från härifrån.',
      &cannotFindTopicMsg -> 'Du verkar inte kunna hitta det i tingesten.',
      &giveAlreadyHasMsg -> 'Saken har redan den.',
      &cannotTalkToSelfMsg -> 'Att prata med dig själv kommer inte åstadkomma någonting.',
      &cannotAskSelfMsg -> 'Att prata med dig själv kommer inte åstadkomma någonting.',
      &cannotAskSelfForMsg -> 'Att prata med dig själv kommer inte åstadkomma någonting.',
      &cannotTellSelfMsg -> 'Att prata med dig själv kommer inte åstadkomma någonting.',
      &cannotGiveToSelfMsg -> 'Att ge tingesten till dig själv kommer inte åstadkomma någonting.',
      &cannotGiveToItselfMsg -> 'Att ge tingesten till dig själv kommer inte åstadkomma någonting.',
      &cannotShowToSelfMsg -> 'Att visa tingesten för dig själv kommer inte åstadkomma någonting.',
      &cannotShowToItselfMsg -> 'Att visa tingesten för sig själv kommer inte åstadkomma någonting.',
      &cannotGiveToMsg -> 'Du kan inte ge någonting till en sak',
      &cannotShowToMsg -> 'Du kan inte visa någonting för en sak',
      //&askVagueMsg -> '-',
      //&tellVagueMsg -> '-',
      &notFollowableMsg -> 'Du kan inte följa den.',
      &cannotFollowSelfMsg -> 'Du kan inte följa dig själv.',
      &followAlreadyHereMsg -> 'Tingesten är precis här.',
      &followAlreadyHereInDarkMsg -> 'Tingesten bör vara precis här, men du kan inte se den.',
      &followUnknownMsg -> 'Du är inte säker på var tingesten har gått härifrån.',
      &notAWeaponMsg -> 'Du kan inte attackera någonting med saken',
      &uselessToAttackMsg -> 'Du kan inte attackera den.',
      &pushNoEffectMsg -> 'Att trycka på tingesten har ingen effekt.',
      //&okayPushButtonMsg -> '-',
      &alreadyPushedMsg -> 'Tingesten är redan intryckt så långt det går.',
      &okayPushLeverMsg -> 'Du trycker tingesten till dess stopp.',
      &pullNoEffectMsg -> 'Att dra i tingesten har ingen effekt.',
      &alreadyPulledMsg -> 'Tingesten är redan dragen så långt det går.',
      &okayPullLeverMsg -> 'Du drar tingesten till dess stopp.',
      &okayPullSpringLeverMsg -> 'Du drar tingesten, som fjädrar tillbaka till dess startposition så snart som du släpper taget om den.',
      &moveNoEffectMsg -> 'Att flytta tingesten skulle inte ge någon effekt.',
      &moveToNoEffectMsg -> 'Detta skulle inte åstadkomma någonting.',
      &cannotPushTravelMsg -> 'Detta skulle inte åstadkomma någonting.',
      &cannotMoveWithMsg -> 'Du kan inte flytta någonting med saken.',
      &cannotSetToMsg -> 'Du kan inte ställa den till någonting.',
      &setToInvalidMsg -> 'Tingesten har ingen sådan inställning.',
      &cannotTurnMsg -> 'Du kan inte vrida den.',
      &mustSpecifyTurnToMsg -> 'Du behöver vara tydlig med vilken inställning du vill sätta den till.',
      &cannotTurnWithMsg -> 'Du kan inte vrida någonting med den.',
      &turnToInvalidMsg -> 'Tingesten har ingen sådan inställning.',
      &alreadySwitchedOnMsg -> 'Tingesten är redan på.',
      &alreadySwitchedOffMsg -> 'Tingesten är redan av.',
      &okayTurnOnMsg -> 'Okej, tingesten är nu på.',
      &okayTurnOffMsg -> 'Okej, tingesten är nu av.',
      &flashlightOnButDarkMsg -> 'Du slår på tingesten, men ingenting verkar hända.',
      &okayEatMsg -> 'Du äter tingesten.',
      &matchNotLitMsg -> 'Tingesten är inte tänd',
      &okayBurnMatchMsg -> 'Du drar an tingesten och tänder en liten låga',
      &okayExtinguishMatchMsg -> 'Du släcker tingesten, som försvinner i en moln av aska.',
      &candleOutOfFuelMsg -> 'Tingesten är för nedbrunnen; den kan inte tändas.',
      &okayBurnCandleMsg -> 'Du tänder tingesten.',
      &candleNotLitMsg -> 'Tingesten är inte tänd.',
      &okayExtinguishCandleMsg -> 'Gjort.',
      &cannotConsultMsg -> 'Den är ingenting du kan konsultera.',
      &cannotTypeOnMsg -> 'Du kan inte skriva någonting på den.',
      &cannotEnterOnMsg -> 'Du kan inte knappa in någonting på den.',
      &cannotSwitchMsg -> 'Du kan inte ändra på den.',
      &cannotFlipMsg -> 'Du kan inte vända den.',
      &cannotTurnOnMsg -> 'Den är inte någonting som du kan slå på.',
      &cannotTurnOffMsg -> 'Den är inte någonting som du kan stänga av.',
      &cannotLightMsg -> 'Du kan inte tända den.',
      &cannotBurnMsg -> 'Den är inte någonting du kan elda',
      &cannotBurnWithMsg -> 'Du kan inte elda någonting med den',
      &cannotBurnDobjWithMsg -> 'Du kan inte tända tingesten med saken.',
      &alreadyBurningMsg -> 'Tingesten brinner redan.',
      &cannotExtinguishMsg -> 'Du kan inte släcka den.',
      &cannotPourMsg -> 'Den är inte någonting du kan hälla.',
      &cannotPourIntoMsg -> 'Du kan inte hälla någonting i den.',
      &cannotPourOntoMsg -> 'Du kan inte hälla någonting på den.',
      &cannotAttachMsg -> 'Du kan inte fästa den på någonting.',
      &cannotAttachToMsg -> 'Du kan inte fästa någonting på den.',
      &cannotAttachToSelfMsg -> 'Du kan inte fästa tingesten på sig själv.',
      &alreadyAttachedMsg -> 'Tingesten är redan fäst med saken.',
      &wrongAttachmentMsg -> 'Du kan inte fästa den på saken.',
      &wrongDetachmentMsg -> 'Du kan inte koppla loss den från saken.',
      &okayAttachToMsg -> 'Gjort.',
      &okayDetachFromMsg -> 'Gjort.',
      &cannotDetachMsg -> 'Du kan inte koppla loss den.',
      &cannotDetachFromMsg -> 'Du kan inte ta loss någonting från den.',
      &cannotDetachPermanentMsg -> 'Det finns inget uppenbart sätt att ta loss den.',
      &notAttachedToMsg -> 'Tingesten sitter inte fast i den.',
      &shouldNotBreakMsg -> 'Att ha sönder den skulle inte tjäna något syfte.',
      &cutNoEffectMsg -> 'Saken verkar inte kunna skära tingesten.',
      &cannotCutWithMsg -> 'Du kan inte skära någonting med saken.',
      &cannotClimbMsg -> 'Den är inte någonting du kan klättra på.',
      &cannotOpenMsg -> 'Den är inte någonting du kan öppna.',
      &cannotCloseMsg -> 'Den är inte någonting du kan stänga.',
      &alreadyOpenMsg -> 'Tingesten är redan öppen.',
      &alreadyClosedMsg -> 'Tingesten är redan stängd.',
      &alreadyLockedMsg -> 'Tingesten är redan låst.',
      &alreadyUnlockedMsg -> 'Tingesten är redan olåst.',
      &cannotLookInClosedMsg -> 'Tingesten är stängd.',
      &cannotLockMsg -> 'Den är inte någonting du kan låsa.',
      &cannotUnlockMsg -> 'Den är inte någonting du kan låsa upp.',
      &cannotOpenLockedMsg -> 'Tingesten verkar vara låst.',
      &unlockRequiresKeyMsg -> 'Du verkar behöva en nyckel för att låsa upp tingesten.',
      &cannotLockWithMsg -> 'Saken ser inte lämplig ut att kunna låsa tingesten med.',
      &cannotUnlockWithMsg -> 'Saken ser inte lämplig ut att kunna låsa upp tingesten med.',
      &unknownHowToLockMsg -> 'Det är inte tydligt på vilket sätt tingesten ska låsas.',
      &unknownHowToUnlockMsg -> 'Det är inte tydligt på vilket sätt tingesten ska låsas upp.',
      &keyDoesNotFitLockMsg -> 'Saken passar inte låset.',
      &cannotEatMsg -> 'Tingesten verkar inte vara ätbar.',
      &cannotDrinkMsg -> 'Tingesten verkar inte vara något du kan dricka.',
      &cannotCleanMsg -> 'Du skulle inte veta hur den skulle rengöras.',
      &cannotCleanWithMsg -> 'Du kan inte rengöra någonting med den.',
      &cannotAttachKeyToMsg -> 'Du kan inte fästa tingesten i den.',
      &cannotSleepMsg -> 'Du behöver inte sova just nu.',
      &cannotSitOnMsg -> 'Den är inte någonting som du kan sitta på.',
      &cannotLieOnMsg -> 'Den är inte någonting som du kan ligga på.',
      &cannotStandOnMsg -> 'Du kan inte stå på den.',
      &cannotBoardMsg -> 'Du kan inte kliva ombord på den.',
      &cannotUnboardMsg -> 'Du kan inte kliva ut ur den.',
      &cannotGetOffOfMsg -> 'Du kan inte kliva av från den.',
      &cannotStandOnPathMsg -> 'Om du vill följa tingesten, säg bara det.',
      &cannotEnterHeldMsg -> 'Du kan inte göra det medan du håller i tingesten.',
      &cannotGetOutMsg -> 'Du är inte i någonting som du kan kliva ur från.',
      &alreadyInLocMsg -> 'Du är redan i tingesten.',
      &alreadyStandingMsg -> 'Du står redan.',
      &alreadyStandingOnMsg -> 'Du står redan i tingesten.',
      &alreadySittingMsg -> 'Du sitter redan ner.',
      &alreadySittingOnMsg -> 'Du sitter redan i tingesten.',
      &alreadyLyingMsg -> 'Du ligger redan ner.',
      &alreadyLyingOnMsg -> 'Du ligger redan ner i tingesten.',
      &notOnPlatformMsg -> 'Du är inte i tingesten.',
      &noRoomToStandMsg -> 'Det finns inte rum för dig att stå i tingesten.',
      &noRoomToSitMsg -> 'Det finns inte rum för dig att sitta i tingesten.',
      &noRoomToLieMsg -> 'Det finns inte rum för dig att ligga i tingesten.',
      &okayNotStandingOnMsg -> 'Ok, du är inte längre i tingesten.',
      &cannotFastenMsg -> 'Du kan inte fästa tingesten',
      &cannotFastenToMsg -> 'Du kan inte fästa någonting på saken.',
      &cannotUnfastenMsg -> 'Du kan inte ta loss tingesten.',
      &cannotUnfastenFromMsg -> 'Du kan inte ta loss någonting från saken.',
      &cannotPlugInMsg -> 'Du ser inget sätt att koppla in tingesten.',
      &cannotPlugInToMsg -> 'Du ser inget sätt att koppla in någonting i saken.',
      &cannotUnplugMsg -> 'Du ser inget sätt att koppla loss tingesten.',
      &cannotUnplugFromMsg -> 'Du ser inget sätt att la loss någonting från saken.',
      &cannotScrewMsg -> 'Du ser inget sätt att skruva tingesten.',
      &cannotScrewWithMsg -> 'Du kan inte skruva något med saken.',
      &cannotUnscrewMsg -> 'Du vet inget sätt att skruva loss tingesten.',
      &cannotUnscrewWithMsg -> 'Du kan inte skruva loss något med saken.',
      &cannotEnterMsg -> 'Den är inte någonting du kan gå in i.',
      &cannotGoThroughMsg -> 'Den är inte någonting du kan gå genom.',
      &cannotThrowAtSelfMsg -> 'Du kan inte kasta den på dig själv.',
      &cannotThrowAtContentsMsg -> 'Du behöver ta bort saken från tingesten före du kan göra det.',
      &shouldNotThrowAtFloorMsg -> 'Du bör bara lägga ner den istället.',
      &dontThrowDirMsg -> 'Du behöver vara mer specifik om vad du ska kasta tingesten mot.',
      &cannotThrowToMsg -> 'Du kan inte kasta någonting till en sak.',
      &cannotKissMsg -> 'Att kyssa tingesten har ingen uppenbar effekt.',
      &cannotKissSelfMsg -> 'Du kan inte kyssa dig själv.',
      &newlyDarkMsg -> 'Det är nu kolsvart.'
  ];
  pairs.forEachAssoc(function(msg, expectedOutput) {
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
     "<<playerActionMessages.(msg)>>";
     
    local str = o.findReplace('  ', ' ', ReplaceAll);
    
    assertThat(str).startsWith(expectedOutput);
  });
};


TestUnit 'npcActionMessages' run {
    //mainOutputStream.hideOutput = nil;
    setPlayer(pirat);
    gActor = spelare3dePerspektiv;
    gAction = UnlockWithAction.createActionInstance();
    gAction.setCurrentObjects([tingest, sak]);
    local pairs = [
      &cannotDoThatMsg -> 'Bob kan inte göra det.',
      &tooDarkMsg -> 'Det är för mörkt för att göra det.',
      &noKeyNeededMsg -> 'Tingesten verkar inte behöva en nyckel',
      &mustBeStandingMsg -> 'Bob behöver stå upp före han kan göra det.',
      &nothingInsideMsg -> 'Det är inget ovanligt i tingesten.',
      &nothingUnderMsg -> 'Bob ser inget ovanligt under tingesten.',
      &nothingBehindMsg -> 'Bob ser inget ovanligt bakom tingesten',
      &nothingThroughMsg -> 'Bob ser ingenting genom tingesten',
      &cannotLookBehindMsg -> 'Bob kan inte se bakom tingesten',
      &cannotLookUnderMsg -> 'Bob kan inte se under tingesten',
      &cannotLookThroughMsg -> 'Bob kan inte se genom tingesten',
      &nothingThroughPassageMsg -> 'Bob kan inte se mycket genom tingesten härifrån',
      &nothingBeyondDoorMsg -> 'Bob öppnar tingesten och finner ingenting ovanligt.',

      &nothingToSmellMsg -> 'Bob känner ingen oväntad lukt.',
      &nothingToHearMsg -> 'Bob hör inget oväntat.',
      &notWearableMsg -> 'Den där är inte någonting som Bob kan klä på sig.',
      &notDoffableMsg -> 'Den där är inte någonting som Bob kan ta av sig.',
      &alreadyWearingMsg -> 'Bob bär redan tingesten.',
      &notWearingMsg -> 'Bob har inte på sig den.',
      &okayWearMsg -> 'Bob klär på sig tingesten',
      &okayDoffMsg -> 'Bob tar av sig tingesten',
      &okayOpenMsg -> 'Bob öppnar tingesten.',
      &okayCloseMsg -> 'Bob stänger tingesten.',
      &okayLockMsg -> 'Bob låser tingesten.',
      &okayUnlockMsg -> 'Bob låser upp tingesten.',
      &cannotDigMsg -> 'Bob har ingen anledning att gräva i den där.',
      &cannotDigWithMsg -> 'Bob ser inget sätt att använda den så som en spade.',
      &alreadyHoldingMsg -> 'Bob har redan tingesten.',
      &takingSelfMsg -> 'Bob kan inte plocka upp sig själv',
      &notCarryingMsg -> 'Bob bär inte på den.',
      &droppingSelfMsg -> 'Bob kan inte släppa sig själv.',
      &puttingSelfMsg -> 'Bob kan inte göra det med sig själv.',
      &throwingSelfMsg -> 'Bob kan inte kasta sig själv.',
      &alreadyPutInMsg -> 'Tingesten är redan i saken.',
      &alreadyPutOnMsg -> 'Tingesten är redan på saken.',
      &alreadyPutUnderMsg -> 'Tingesten är redan under saken.',
      &alreadyPutBehindMsg -> 'Tingesten är redan bakom saken.',
      &cannotMoveFixtureMsg -> 'Bob kan inte flytta den.',
      &cannotTakeFixtureMsg -> 'Bob kan inte ta den.',
      &cannotPutFixtureMsg -> 'Bob kan inte stoppa tingesten någonstans',
      &cannotTakeImmovableMsg -> 'Bob kan inte ta den.',
      &cannotMoveImmovableMsg -> 'Bob kan inte flytta tingesten.',
      &cannotPutImmovableMsg -> 'Bob kan inte stoppa tingesten någonstans',
      &cannotTakeHeavyMsg -> 'Den är för tung för Bob att ta.',
      &cannotMoveHeavyMsg -> 'Den är för tung för Bob att flytta.',
      &cannotPutHeavyMsg -> 'Den är för tung för Bob att flytta.',
      &cannotTakePushableMsg -> 'Bob kan inte ta den, men det kan vara möjligt att knuffa den någonstans.',
      &cannotMovePushableMsg -> 'Det skulle inte åstadkomma någonting att flytta runt tingesten riktningslöst, men det kanske är möjligt att flytta den i en specifik riktning.',
      &cannotPutPushableMsg -> 'Bob kan inte stoppa den någonstans, men det kan vara möjligt att knuffa den någonstans.',
      &cannotTakeLocationMsg -> 'Bob kan inte plocka upp den medan Bob uppehåller den',
      &cannotRemoveHeldMsg -> 'Det finns ingenting att ta bort tingesten ifrån.',
      &okayTakeMsg -> 'Bob tar tingesten.',
      &okayDropMsg -> 'Bob sätter ner tingesten.',
      &okayPutInMsg -> 'Bob sätter tingesten i saken.',
      &okayPutOnMsg -> 'Bob sätter tingesten på saken.',
      &okayPutUnderMsg -> 'Bob sätter tingesten under saken.',
      &okayPutBehindMsg -> 'Bob sätter tingesten bakom saken.',

      &cannotTakeActorMsg -> 'Tingesten låter inte Bob göra det.',
      &cannotMoveActorMsg -> 'Tingesten låter inte Bob göra det.',
      &cannotPutActorMsg -> 'Tingesten låter inte Bob göra det.',
      &cannotTasteActorMsg -> 'Tingesten låter inte Bob göra det.',
      &cannotTakePersonMsg -> 'Tingesten skulle antagligen inte uppskatta det.',
      &cannotMovePersonMsg -> 'Tingesten skulle antagligen inte uppskatta det.',
      &cannotPutPersonMsg -> 'Tingesten skulle antagligen inte uppskatta det.',
      &cannotTastePersonMsg -> 'Tingesten skulle antagligen inte uppskatta det.',

      &notAContainerMsg -> 'Bob kan inte stoppa någonting i saken.',
      &notASurfaceMsg -> 'Det finns ingen bra yta på saken.',
      &cannotPutUnderMsg -> 'Bob kan inte stoppa någonting under den.',
      &cannotPutBehindMsg -> 'Bob kan inte stoppa in någonting bakom saken.',
      &cannotPutInSelfMsg -> 'Bob kan inte stoppa tingesten i sig själv.',
      &cannotPutOnSelfMsg -> 'Bob kan inte stoppa tingesten på sig själv.',
      &cannotPutUnderSelfMsg -> 'Bob kan inte stoppa tingesten under sig själv.',
      &cannotPutBehindSelfMsg -> 'Bob kan inte stoppa tingesten bakom sig själv.',
      &cannotPutInRestrictedMsg -> 'Bob kan inte stoppa den i saken.',
      &cannotPutOnRestrictedMsg -> 'Bob kan inte stoppa den på saken.',
      &cannotPutUnderRestrictedMsg -> 'Bob kan inte stoppa den under saken.',
      &cannotPutBehindRestrictedMsg -> 'Bob kan inte stoppa den bakom saken.',
      &cannotReturnToDispenserMsg -> 'Bob kan inte stoppa tillbaka en tingest i saken.',
      &cannotPutInDispenserMsg -> 'Bob kan inte stoppa en tingest i saken.',
      &objNotForKeyringMsg -> 'Bob kan inte göra det för att den får inte plats i saken.',
      &keyNotOnKeyringMsg -> 'Tingesten sitter inte fast i saken.',
      &keyNotDetachableMsg -> 'Tingesten sitter inte fast i någonting.',
      &takeFromNotInMsg -> 'Bob kan inte göra det för att tingesten är inte i den.',
      &takeFromNotOnMsg -> 'Bob kan inte göra det för att tingesten är inte på den.',
      &takeFromNotUnderMsg -> 'Bob kan inte göra det för att tingesten är inte under den.',
      &takeFromNotBehindMsg -> 'Bob kan inte göra det för att tingesten är inte bakom den.',
      &takeFromNotInActorMsg -> 'Saken har inte den.',
      &whereToGoMsg -> 'Du skulle behöva säga vilken väg Bob skulle gå.',
      &cannotGoThatWayMsg -> 'Bob kan inte gå ditåt.',
      &cannotGoThatWayInDarkMsg -> 'Det är för mörkt; Bob kan inte se var han går.',
      &cannotGoBackMsg -> 'Bob vet inte hur man återvänder härifrån.',
      &cannotDoFromHereMsg -> 'Bob kan inte göra det härifrån.',
      &stairwayNotUpMsg -> 'Tingesten går bara ner härifrån.',
      &stairwayNotDownMsg -> 'Tingesten går bara upp härifrån.',
      //&timePassesMsg -> 'Tiden går...',
      &sayHelloMsg -> 'Bob behöver vara mer specifik om vem han vill prata med.',
      &sayGoodbyeMsg -> 'Bob behöver vara mer specifik om vem han vill prata med.',
      &sayYesMsg -> 'Bob behöver vara mer specifik om vem han vill prata med.',
      &sayNoMsg -> 'Bob behöver vara mer specifik om vem han vill prata med.',
      &okayYellMsg -> 'Bob skriker så högt han bara kan.',
      &okayJumpMsg -> 'Bob hoppar och landar på samma ställe.',
      &cannotJumpOverMsg -> 'Bob kan inte hoppa över den.',
      &cannotJumpOffMsg -> 'Bob kan inte hoppa av den.',
      &cannotJumpOffHereMsg -> 'Det finns ingenstans för Bob att hoppa av.',
      &cannotFindTopicMsg -> 'Bob verkar inte kunna hitta det i tingesten.',
      &giveAlreadyHasMsg -> 'Saken har redan den.',
      &cannotTalkToSelfMsg -> 'Bob kommer inte åstadkomma någonting genom att prata med sig själv.',
      &cannotAskSelfMsg -> 'Bob kommer inte åstadkomma någonting genom att prata med sig själv.',
      &cannotAskSelfForMsg -> 'Bob kommer inte åstadkomma någonting genom att prata med sig själv.',
      &cannotTellSelfMsg -> 'Bob kommer inte åstadkomma någonting genom att prata med sig själv.',
      &cannotGiveToSelfMsg -> 'Bob kommer inte åstadkomma någonting genom att ge tingesten till sig själv.',
      &cannotGiveToItselfMsg -> 'Att ge tingesten till sig själv kommer inte åstadkomma någonting.',
      &cannotShowToSelfMsg -> 'Bob kommer inte åstadkomma någonting genom att visa tingesten för sig själv.',
      &cannotShowToItselfMsg -> 'Att visa tingesten för sig själv kommer inte åstadkomma någonting.',
      &cannotGiveToMsg -> 'Bob kan inte ge någonting till en sak',
      &cannotShowToMsg -> 'Bob kan inte visa någonting för en sak',
      //&askVagueMsg -> '-',
      //&tellVagueMsg -> '-',
      &notFollowableMsg -> 'Bob kan inte följa den.',
      &cannotFollowSelfMsg -> 'Bob kan inte följa sig själv.',
      &followAlreadyHereMsg -> 'Tingesten är precis här.',
      &followAlreadyHereInDarkMsg -> 'Tingesten bör vara precis här, men Bob kan inte se den.',
      &followUnknownMsg -> 'Bob är inte säker på var tingesten har gått härifrån.',
      &notAWeaponMsg -> 'Bob kan inte attackera någonting med saken',
      &uselessToAttackMsg -> 'Bob kan inte attackera den.',
      &pushNoEffectMsg -> 'Bob försöker att knuffa tingesten, utan någon uppenbar effekt.',
      //&okayPushButtonMsg -> '-',
      &alreadyPushedMsg -> 'Tingesten är redan intryckt så långt det går.',
      &okayPushLeverMsg -> 'Bob trycker tingesten till dess stopp.',
      &pullNoEffectMsg -> 'Bob försöker att dra tingesten, utan någon uppenbar effekt.',
      &alreadyPulledMsg -> 'Tingesten är redan dragen så långt det går.',
      &okayPullLeverMsg -> 'Bob drar tingesten till dess stopp.',
      &okayPullSpringLeverMsg -> 'Bob drar tingesten, som fjädrar tillbaka till dess startposition så snart som Bob släpper taget om den.',
      &moveNoEffectMsg -> 'Bob försöker att flytta tingesten, utan någon uppenbar effekt.',
      &moveToNoEffectMsg -> 'Bob lämnar tingesten där tingesten är.',
      &cannotPushTravelMsg -> 'Detta skulle inte åstadkomma någonting.',
      &cannotMoveWithMsg -> 'Bob kan inte flytta någonting med saken.',
      &cannotSetToMsg -> 'Bob kan inte ställa den till någonting.',
      &setToInvalidMsg -> 'Tingesten har ingen sådan inställning.',
      &cannotTurnMsg -> 'Bob kan inte vrida den.',
      &mustSpecifyTurnToMsg -> 'Bob behöver vara tydlig med vilken inställning Bob vill sätta den till.',
      &cannotTurnWithMsg -> 'Bob kan inte vrida någonting med den.',
      &turnToInvalidMsg -> 'Tingesten har ingen sådan inställning.',
      &alreadySwitchedOnMsg -> 'Tingesten är redan på.',
      &alreadySwitchedOffMsg -> 'Tingesten är redan av.',
      &okayTurnOnMsg -> 'Bob slår på tingesten',
      &okayTurnOffMsg -> 'Bob slår av tingesten',
      &flashlightOnButDarkMsg -> 'Bob slår på tingesten, men ingenting verkar hända.',
      &okayEatMsg -> 'Bob äter tingesten.',
      &matchNotLitMsg -> 'Tingesten är inte tänd',
      &okayBurnMatchMsg -> 'Bob drar an tingesten och tänder en liten låga',
      &okayExtinguishMatchMsg -> 'Bob släcker tingesten, som försvinner i en moln av aska.',
      &candleOutOfFuelMsg -> 'Tingesten är för nedbrunnen; den kan inte tändas.',
      &okayBurnCandleMsg -> 'Bob tänder tingesten.',
      &candleNotLitMsg -> 'Tingesten är inte tänd.',
      &okayExtinguishCandleMsg -> 'Bob släcker tingesten.',
      &cannotConsultMsg -> 'Den är ingenting Bob kan konsultera.',
      &cannotTypeOnMsg -> 'Bob kan inte skriva någonting på den.',
      &cannotEnterOnMsg -> 'Bob kan inte knappa in någonting på den.',
      &cannotSwitchMsg -> 'Bob kan inte ändra på den.',
      &cannotFlipMsg -> 'Bob kan inte vända den.',
      &cannotTurnOnMsg -> 'Den är inte någonting som Bob kan slå på.',
      &cannotTurnOffMsg -> 'Den är inte någonting som Bob kan stänga av.',
      &cannotLightMsg -> 'Bob kan inte tända den.',
      &cannotBurnMsg -> 'Den är inte någonting Bob kan elda',
      &cannotBurnWithMsg -> 'Bob kan inte elda någonting med den',
      &cannotBurnDobjWithMsg -> 'Bob kan inte tända tingesten med saken.',
      &alreadyBurningMsg -> 'Tingesten brinner redan.',
      &cannotExtinguishMsg -> 'Bob kan inte släcka den.',
      &cannotPourMsg -> 'Den är inte någonting Bob kan hälla.',
      &cannotPourIntoMsg -> 'Bob kan inte hälla någonting i den.',
      &cannotPourOntoMsg -> 'Bob kan inte hälla någonting på den.',
      &cannotAttachMsg -> 'Bob kan inte fästa den på någonting.',
      &cannotAttachToMsg -> 'Bob kan inte fästa någonting på den.',
      &cannotAttachToSelfMsg -> 'Bob kan inte fästa tingesten på sig själv.',
      &alreadyAttachedMsg -> 'Tingesten är redan fäst med saken.',
      &wrongAttachmentMsg -> 'Bob kan inte fästa den på saken.',
      &wrongDetachmentMsg -> 'Bob kan inte koppla loss den från saken.',
      &okayAttachToMsg -> 'Bob fäster tingesten till saken.',
      &okayDetachFromMsg -> 'Bob tar loss tingesten från saken.',
      &cannotDetachMsg -> 'Bob kan inte koppla loss den.',
      &cannotDetachFromMsg -> 'Bob kan inte ta loss någonting från den.',
      &cannotDetachPermanentMsg -> 'Det finns inget uppenbart sätt att ta loss den.',
      &notAttachedToMsg -> 'Tingesten sitter inte fast i den.',
      &shouldNotBreakMsg -> 'Bob vill inte förstöra den.',
      &cutNoEffectMsg -> 'Saken verkar inte kunna skära tingesten.',
      &cannotCutWithMsg -> 'Bob kan inte skära någonting med saken.',
      &cannotClimbMsg -> 'Den är inte någonting Bob kan klättra på.',
      &cannotOpenMsg -> 'Den är inte någonting Bob kan öppna.',
      &cannotCloseMsg -> 'Den är inte någonting Bob kan stänga.',
      &alreadyOpenMsg -> 'Tingesten är redan öppen.',
      &alreadyClosedMsg -> 'Tingesten är redan stängd.',
      &alreadyLockedMsg -> 'Tingesten är redan låst.',
      &alreadyUnlockedMsg -> 'Tingesten är redan olåst.',
      &cannotLookInClosedMsg -> 'Tingesten är stängd.',
      &cannotLockMsg -> 'Den är inte någonting Bob kan låsa.',
      &cannotUnlockMsg -> 'Den är inte någonting Bob kan låsa upp.',
      &cannotOpenLockedMsg -> 'Tingesten verkar vara låst.',
      &unlockRequiresKeyMsg -> 'Bob verkar behöva en nyckel för att låsa upp tingesten.',
      &cannotLockWithMsg -> 'Saken ser inte lämplig ut att kunna låsa tingesten med.',
      &cannotUnlockWithMsg -> 'Saken ser inte lämplig ut att kunna låsa upp tingesten med.',
      &unknownHowToLockMsg -> 'Det är inte tydligt på vilket sätt tingesten ska låsas.',
      &unknownHowToUnlockMsg -> 'Det är inte tydligt på vilket sätt tingesten ska låsas upp.',
      &keyDoesNotFitLockMsg -> 'Bob provar saken, men den passar inte till låset.',
      &cannotEatMsg -> 'Tingesten verkar inte vara ätbar.',
      &cannotDrinkMsg -> 'Tingesten verkar inte vara något Bob kan dricka.',
      &cannotCleanMsg -> 'Bob skulle inte veta hur den skulle rengöras.',
      &cannotCleanWithMsg -> 'Bob kan inte rengöra någonting med den.',
      &cannotAttachKeyToMsg -> 'Bob kan inte fästa tingesten i den.',
      &cannotSleepMsg -> 'Bob behöver inte sova just nu.',
      &cannotSitOnMsg -> 'Den är inte någonting som Bob kan sitta på.',
      &cannotLieOnMsg -> 'Den är inte någonting som Bob kan ligga på.',
      &cannotStandOnMsg -> 'Bob kan inte stå på den.',
      &cannotBoardMsg -> 'Bob kan inte kliva ombord på den.',
      &cannotUnboardMsg -> 'Bob kan inte kliva ut ur den.',
      &cannotGetOffOfMsg -> 'Bob kan inte kliva av från den.',
      &cannotStandOnPathMsg -> 'Om Bob vill följa tingesten, säg bara det.',
      &cannotEnterHeldMsg -> 'Bob kan inte göra det medan Bob håller i tingesten.',
      &cannotGetOutMsg -> 'Bob är inte i någonting som Bob kan kliva ur från.',
      &alreadyInLocMsg -> 'Bob är redan i tingesten.',
      &alreadyStandingMsg -> 'Bob står redan.',
      &alreadyStandingOnMsg -> 'Bob står redan i tingesten.',
      &alreadySittingMsg -> 'Bob sitter redan ner.',
      &alreadySittingOnMsg -> 'Bob sitter redan i tingesten.',
      &alreadyLyingMsg -> 'Bob ligger redan ner.',
      &alreadyLyingOnMsg -> 'Bob ligger redan ner i tingesten.',
      &notOnPlatformMsg -> 'Bob är inte i tingesten.',
      &noRoomToStandMsg -> 'Det finns inte rum för Bob att stå i tingesten.',
      &noRoomToSitMsg -> 'Det finns inte rum för Bob att sitta i tingesten.',
      &noRoomToLieMsg -> 'Det finns inte rum för Bob att ligga i tingesten.',
      &okayNotStandingOnMsg -> 'Bob kliver ut ur tingesten.',
      &cannotFastenMsg -> 'Bob kan inte fästa tingesten',
      &cannotFastenToMsg -> 'Bob kan inte fästa någonting på saken.',
      &cannotUnfastenMsg -> 'Bob kan inte ta loss tingesten.',
      &cannotUnfastenFromMsg -> 'Bob kan inte ta loss någonting från saken.',
      &cannotPlugInMsg -> 'Bob ser inget sätt att koppla in tingesten.',
      &cannotPlugInToMsg -> 'Bob ser inget sätt att koppla in någonting i saken.',
      &cannotUnplugMsg -> 'Bob ser inget sätt att koppla loss tingesten.',
      &cannotUnplugFromMsg -> 'Bob ser inget sätt att la loss någonting från saken.',
      &cannotScrewMsg -> 'Bob ser inget sätt att skruva tingesten.',
      &cannotScrewWithMsg -> 'Bob kan inte skruva något med saken.',
      &cannotUnscrewMsg -> 'Bob vet inget sätt att skruva loss tingesten.',
      &cannotUnscrewWithMsg -> 'Bob kan inte skruva loss något med saken.',
      &cannotEnterMsg -> 'Den är inte någonting Bob kan gå in i.',
      &cannotGoThroughMsg -> 'Den är inte någonting Bob kan gå genom.',
      &cannotThrowAtSelfMsg -> 'Bob kan inte kasta den på sig själv.',
      &cannotThrowAtContentsMsg -> 'Bob behöver ta bort saken från tingesten före han kan göra det.',
      &shouldNotThrowAtFloorMsg -> 'Bob bör bara lägga ner den istället.',
      &dontThrowDirMsg -> 'Du behöver vara mer specifik om vad du vill att Bob ska kasta tingesten mot.',
      &cannotThrowToMsg -> 'Bob kan inte kasta någonting till en sak.',
      &cannotKissMsg -> 'Att kyssa tingesten har ingen uppenbar effekt.',
      &cannotKissSelfMsg -> 'Bob kan inte kyssa sig själv.',
      &newlyDarkMsg -> 'Det är nu kolsvart.'
  ];
  pairs.forEachAssoc(function(msg, expectedOutput) {
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
     "<<npcActionMessages.(msg)>>";
     
    local str = o.findReplace('  ', ' ', ReplaceAll);
    
    assertThat(str).startsWith(expectedOutput);
  });
};



TestUnit 'roomLister' run {
  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  setPlayer(spelare2aPerspektiv);
  gActor = spelare2aPerspektiv;
  roomLister.showListPrefixWide(0, nil, spelare2aPerspektiv);
  assertThat(o).startsWith('Du ser');

  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  roomLister.showListSuffixWide(0, nil, spelare2aPerspektiv);
  assertThat(o).startsWith(' här.');

  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  roomLister.showListPrefixTall(0, nil, spelare2aPerspektiv);
  assertThat(o).startsWith('Du ser:');

  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  roomLister.showListContentsPrefixTall(0, nil, spelare2aPerspektiv);
  assertThat(o).startsWith('Du ser:');

};


TestUnit 'darkRoomLister' run {
  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  darkRoomLister.showListPrefixWide(0, nil, spelare2aPerspektiv);
  assertThat(o).startsWith('I mörkret kan du se');

  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  darkRoomLister.showListSuffixWide(0, nil, spelare2aPerspektiv);
  assertThat(o).startsWith('.');

  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  darkRoomLister.showListPrefixTall(0, nil, spelare2aPerspektiv);
  assertThat(o).startsWith('I mörkret kan du se:');

  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  darkRoomLister.showListContentsPrefixTall(0, nil, spelare2aPerspektiv);
  assertThat(o).startsWith('I mörkret kan du se:');

};


TestUnit 'RemoteRoomLister' run {
  local lister = new RemoteRoomLister(baren);
  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  lister.showListPrefixWide(0, nil, spelare2aPerspektiv);
  assertThat(o).startsWith('\^i baren, ser du');

  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  lister.showListSuffixWide(0, nil, spelare2aPerspektiv);
  assertThat(o).startsWith('.');

  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  lister.showListPrefixTall(0, nil, spelare2aPerspektiv);
  assertThat(o).startsWith('\^i baren, ser du:');

  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  lister.showListContentsPrefixTall(0, nil, spelare2aPerspektiv);
  assertThat(o).startsWith('\^i baren, ser du:');

};



TestUnit 'actorSingleInventoryLister' run {
  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  actorSingleInventoryLister.showListPrefixWide(0, nil, spelare2aPerspektiv);
  assertThat(o).startsWith('Du bär på');

  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  actorSingleInventoryLister.showListSuffixWide(0, nil, spelare2aPerspektiv);
  assertThat(o).startsWith('.');

  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  actorSingleInventoryLister.showListPrefixTall(0, nil, spelare2aPerspektiv);
  assertThat(o).startsWith('Du bär på:');

  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  actorSingleInventoryLister.showListContentsPrefixTall(0, nil, spelare2aPerspektiv);
  assertThat(o).startsWith('Du, som bär på:');

  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  actorSingleInventoryLister.showListEmpty(nil, spelare2aPerspektiv);
  assertThat(o).startsWith('Du är tomhänt');
};



TestUnit 'actorInventoryLister.showCombinedInventoryList 2a-perspektiv' run {
  actorInventoryLister.showCombinedInventoryList(spelare2aPerspektiv, 'en jacka', 'en mössa');
  assertThat(o).startsWith('Du bär på en jacka, och du har på dig en mössa.');
};

TestUnit 'LiteralTAction.getOtherMessageObjectPronoun(which)' run {
  actorInventoryLister.showCombinedInventoryList(spelare2aPerspektiv, '', 'en mössa');
  assertThat(o).startsWith('Du bär inte på någonting, och har på dig en mössa.');
};

TestUnit 'LiteralTAction.getOtherMessageObjectPronoun(which)' run {
  actorInventoryLister.showCombinedInventoryList(spelare2aPerspektiv, 'en jacka', '');
  assertThat(o).startsWith('Du bär på en jacka.');
};

TestUnit 'LiteralTAction.getOtherMessageObjectPronoun(which)' run {
  actorInventoryLister.showCombinedInventoryList(spelare2aPerspektiv, '', '');
  assertThat(o).startsWith('Du är tomhänt.');
};



TestUnit 'actorInventoryLister.showCombinedInventoryList 3e-perspektiv' run {
  actorInventoryLister.showCombinedInventoryList(spelare3dePerspektiv, 'en jacka', 'en mössa');
  assertThat(o).startsWith('Bob bär på en jacka, och han har på sig en mössa.');
};

TestUnit 'LiteralTAction.getOtherMessageObjectPronoun(which)' run {
  actorInventoryLister.showCombinedInventoryList(spelare3dePerspektiv, '', 'en mössa');
  assertThat(o).startsWith('Bob bär inte på någonting, och har på sig en mössa.');
};

TestUnit 'LiteralTAction.getOtherMessageObjectPronoun(which)' run {
  actorInventoryLister.showCombinedInventoryList(spelare3dePerspektiv, 'en jacka', '');
  assertThat(o).startsWith('Bob bär på en jacka.');
};

TestUnit 'LiteralTAction.getOtherMessageObjectPronoun(which)' run {
  actorInventoryLister.showCombinedInventoryList(spelare3dePerspektiv, '', '');
  assertThat(o).startsWith('Bob är tomhänt.');
};




TestUnit 'actorHoldingDescInventoryListerLong 2a-person' run {
  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  actorHoldingDescInventoryListerLong.showInventoryWearingOnly(spelare2aPerspektiv, 'en mössa');
  assertThat(o).contains('Du har på dig en mössa.');

  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  actorHoldingDescInventoryListerLong.showInventoryCarryingOnly(spelare2aPerspektiv, 'en mössa');
  assertThat(o).contains('Du bär på en mössa.');

  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  actorHoldingDescInventoryListerLong.showInventoryShortLists(spelare2aPerspektiv, 'en mössa', 'en jacka');
  assertThat(o).contains('Du bär på en mössa, och du har på dig en jacka.');

  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  actorHoldingDescInventoryListerLong.showInventoryLongLists(spelare2aPerspektiv, 'en mössa', 'en jacka');
  assertThat(o).contains('Du bär på en mössa.');
  assertThat(o).contains('Du har på dig en jacka.');
  
};


TestUnit 'actorHoldingDescInventoryListerLong 3e-person' run {
  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  actorHoldingDescInventoryListerLong.showInventoryWearingOnly(spelare3dePerspektiv, 'en mössa');
  assertThat(o).contains('Bob har på sig en mössa.');

  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  actorHoldingDescInventoryListerLong.showInventoryCarryingOnly(spelare3dePerspektiv, 'en mössa');
  assertThat(o).contains('Bob bär på en mössa.');

  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  actorHoldingDescInventoryListerLong.showInventoryShortLists(spelare3dePerspektiv, 'en mössa', 'en jacka');
  assertThat(o).contains('Bob bär på en mössa, och han har på sig en jacka.');

  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  actorHoldingDescInventoryListerLong.showInventoryLongLists(spelare3dePerspektiv, 'en mössa', 'en jacka');
  assertThat(o).contains('Bob bär på en mössa.');
  assertThat(o).contains('Han har på sig en jacka.');
  
};

TestUnit 'actorHoldingDescInventoryListerShort' run {
  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  actorHoldingDescInventoryListerShort.showInventoryWearingOnly(spelare3dePerspektiv, 'en mössa');
  assertThat(o).contains('Han har på sig en mössa.');

  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  actorHoldingDescInventoryListerShort.showInventoryCarryingOnly(spelare3dePerspektiv, 'en mössa');
  assertThat(o).contains('Han bär på en mössa.');

  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  actorHoldingDescInventoryListerShort.showInventoryShortLists(spelare3dePerspektiv, 'en mössa', 'en jacka');
  assertThat(o).contains('Han bär på en mössa, och han har på sig en jacka.');

  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  actorHoldingDescInventoryListerShort.showInventoryLongLists(spelare3dePerspektiv, 'en mössa', 'en jacka');
  assertThat(o).contains('Han bär på en mössa.');
  assertThat(o).contains('Han har på sig en jacka.');
  
};



TestUnit 'actorHoldingDescInventoryListerShort' run {
  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  actorHoldingDescInventoryListerShort.showInventoryWearingOnly(spelare3dePerspektiv, 'en mössa');
  assertThat(o).contains('Han har på sig en mössa.');

  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  actorHoldingDescInventoryListerShort.showInventoryCarryingOnly(spelare3dePerspektiv, 'en mössa');
  assertThat(o).contains('Han bär på en mössa.');

  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  actorHoldingDescInventoryListerShort.showInventoryShortLists(spelare3dePerspektiv, 'en mössa', 'en jacka');
  assertThat(o).contains('Han bär på en mössa, och han har på sig en jacka.');

  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  actorHoldingDescInventoryListerShort.showInventoryLongLists(spelare3dePerspektiv, 'en mössa', 'en jacka');
  assertThat(o).contains('Han bär på en mössa.');
  assertThat(o).contains('Han har på sig en jacka.');
  
};


TestUnit 'BaseThingContentsLister' run {
  local lister = new BaseThingContentsLister();
  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  lister.showListPrefixWide(0, nil, skapetObjNeutrumSingular);
  assertThat(o).startsWith('\^skåpet innehåller');

  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  lister.showListSuffixWide(0, nil, skapetObjNeutrumSingular);
  assertThat(o).startsWith('.');

  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  lister.showListPrefixTall(0, nil, skapetObjNeutrumSingular);
  assertThat(o).startsWith('\^skåpet innehåller:');

  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  lister.showListContentsPrefixTall(0, nil, skapetObjNeutrumSingular);
  assertThat(o).startsWith('ett skåp, som innehåller:');

};



TestUnit 'thingDescContentsLister' run {
  thingDescContentsLister.showListPrefixWide(0, nil, skapetObjNeutrumSingular);
  assertThat(o).startsWith('\^det innehåller');

};

TestUnit 'openableDescContentsLister' run {
  openableDescContentsLister.showListEmpty(0, skapetObjNeutrumSingular);
  assertThat(o).startsWith('\^det är öppet.');

  mainOutputStream.capturedOutputBuffer = new StringBuffer();
  openableDescContentsLister.showListPrefixWide(0, nil, skapetObjNeutrumSingular);
  assertThat(o).startsWith('\^det är öppet, och innehåller');

};

TestUnit 'LookWhereContentsLister' run {
    new LookWhereContentsLister().showListEmpty(nil, skapetObjNeutrumSingular);
    gTranscript.showReports(true);
    gTranscript.clearReports();  
    assertThat(o).contains('Du ser ingenting i skåpet.');

};


TestUnit 'LookWhereContentsLister' run {
    thingLookInLister.showListEmpty(nil, skapetObjNeutrumSingular);    
    gTranscript.showReports(true);
    gTranscript.clearReports();  
    assertThat(o).contains('Du ser inget ovanligt i skåpet.');
};

// ---

TestUnit 'openableOpeningLister.showListPrefixWide' run {
    setPlayer(spelare3dePerspektiv);
    gActor = spelare3dePerspektiv;
    openableOpeningLister.showListPrefixWide(0, spelare3dePerspektiv, skapetObjNeutrumSingular);    
    assertThat(o).contains('Bob öppnar skåpet och finner');
};


TestUnit 'BaseContentsLister' run {
    local lister = new BaseContentsLister();
    setPlayer(spelare3dePerspektiv);
    gActor = spelare3dePerspektiv;
    lister.showListPrefixWide(0, spelare3dePerspektiv, skapetObjNeutrumSingular);    
    assertThat(o).contains('\^i skåpet är');

    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    lister.showListPrefixTall(0, nil, skapetObjNeutrumSingular);
    assertThat(o).startsWith('\^i skåpet är:');

    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    lister.showListContentsPrefixTall(0, nil, skapetObjNeutrumSingular);
    assertThat(o).startsWith('ett skåp, i vilket är:');

};



TestUnit 'BaseContentsLister' run {
    local lister = new BaseUndersideContentsLister();
    setPlayer(spelare3dePerspektiv);
    gActor = spelare3dePerspektiv;
    lister.showListPrefixWide(0, spelare3dePerspektiv, skapetObjNeutrumSingular);    
    assertThat(o).contains('\^i skåpet är');

    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    lister.showListPrefixTall(0, nil, skapetObjNeutrumSingular);
    assertThat(o).startsWith('\^i skåpet är:');

    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    lister.showListContentsPrefixTall(0, nil, skapetObjNeutrumSingular);
    assertThat(o).startsWith('ett skåp, i vilket är:');

};


TestUnit 'undersideAbandonContentsLister' run {
    local lister = undersideAbandonContentsLister;

    setPlayer(spelare3dePerspektiv);
    gActor = spelare3dePerspektiv;
    lister.showListPrefixWide(0, spelare3dePerspektiv, skapetObjNeutrumSingular);    
    assertThat(o).contains('Vid flytten av skåpet avslöjas');

    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    lister.showListSuffixWide(0, nil, skapetObjNeutrumSingular);
    assertThat(o).startsWith(' nedanför.');

    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    lister.showListPrefixTall(0, nil, skapetObjNeutrumSingular);
    assertThat(o).startsWith('Vid flytten av skåpet avslöjas:');

};

TestUnit 'rearAbandonContentsLister' run {
    local lister = rearAbandonContentsLister;

    setPlayer(spelare3dePerspektiv);
    gActor = spelare3dePerspektiv;
    lister.showListPrefixWide(0, spelare3dePerspektiv, skapetObjNeutrumSingular);    
    assertThat(o).contains('Vid flytten av skåpet avslöjas');

    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    lister.showListSuffixWide(0, nil, skapetObjNeutrumSingular);
    assertThat(o).startsWith(' bakom det.');

    mainOutputStream.capturedOutputBuffer = new StringBuffer();
    lister.showListPrefixTall(0, nil, skapetObjNeutrumSingular);
    assertThat(o).startsWith('Vid flytten av skåpet avslöjas:');

};



TestUnit 'rearDescContentsLister' run {
    local lister = rearDescContentsLister;

    setPlayer(spelare3dePerspektiv);
    gActor = spelare3dePerspektiv;
    lister.showListPrefixWide(0, spelare3dePerspektiv, skapetObjNeutrumSingular);    
    assertThat(o).contains('Bakom skåpet är');
};



TestUnit 'BaseInlineContentsLister' run {
    local lister = new BaseInlineContentsLister();

    setPlayer(spelare3dePerspektiv);
    gActor = spelare3dePerspektiv;
    lister.showListPrefixWide(0, spelare3dePerspektiv, skapetObjNeutrumSingular);    
    assertThat(o).contains(' (i vilket är');
};

TestUnit 'inlineListingContentsLister' run {
    local lister = inlineListingContentsLister;

    setPlayer(spelare3dePerspektiv);
    gActor = spelare3dePerspektiv;
    lister.showListPrefixWide(0, spelare3dePerspektiv, skapetObjNeutrumSingular);    
    assertThat(o).contains(' (som innehåller');
};



TestUnit 'libMessages (objects)' run {
    local pairs = [
      [&currentlyOpen, skapetObjNeutrumSingular]  -> 'Det är för närvarande öppet.',
      [&currentlyClosed, skapetObjNeutrumSingular] -> 'Det är för närvarande stängt.',
      [&currentlyOpen, dorrenObjUtrumSingular]  -> 'Den är för närvarande öppen.',
      [&currentlyClosed, dorrenObjUtrumSingular] -> 'Den är för närvarande stängd.',
      [&currentlyOpen, skapenObjNeuterPlural]  -> 'De är för närvarande öppna.',
      [&currentlyClosed, skapenObjNeuterPlural] -> 'De är för närvarande stängda.',

      [&currentlyUnlocked, skapetObjNeutrumSingular]  -> 'Det är för närvarande olåst.',
      [&currentlyLocked, skapetObjNeutrumSingular] -> 'Det är för närvarande låst.',
      [&currentlyUnlocked, dorrenObjUtrumSingular]  -> 'Den är för närvarande olåst.',
      [&currentlyLocked, dorrenObjUtrumSingular] -> 'Den är för närvarande låst.',
      [&currentlyUnlocked, skapenObjNeuterPlural]  -> 'De är för närvarande olåsta.',
      [&currentlyLocked, skapenObjNeuterPlural] -> 'De är för närvarande låsta.'

  ];
  pairs.forEachAssoc(function(pair, expectedOutput) {
    local prop = pair[1];
    local obj = pair[2];

    gAction = DoffAction.createActionInstance();
    gAction.setCurrentObjects([obj]);
    mainOutputStream.capturedOutputBuffer = new StringBuffer();
     "<<libMessages.(prop)>>";
    assertThat(o).startsWith(expectedOutput);
  });
};


TestUnit 'npcMessages.commandNotHeard(actor)' run {
  npcMessages.commandNotHeard(pirat);
  assertThat(o).startsWith('\^piraten svarar ej.');
};

TestUnit 'libMessages.noMatchCannotSee' run {
  npcMessages.noMatchCannotSee(pirat, 'xyzzy');
  assertThat(o).startsWith('\^piraten ser inget liknande xyzzy.');
};

TestUnit 'npcMessages.noMatchNotAware' run {
  npcMessages.noMatchNotAware(pirat, 'xyzzy');
  assertThat(o).startsWith('\^piraten är inte medveten om något liknande xyzzy.');
};

TestUnit 'npcMessages.ambiguousNounPhrase okänt' run {  
  npcMessages.ambiguousNounPhrase(pirat, 'xyzzy', nil, nil);
  assertThat(o).contains('piraten förstår inte vad du menar med det.');
};

TestUnit 'npcMessages.ambiguousNounPhrase neutrum' run {  
  npcMessages.ambiguousNounPhrase(pirat, 'äpple', nil, nil);
  assertThat(o).contains('piraten förstår inte vilket äpple du menar.');
};

TestUnit 'npcMessages.ambiguousNounPhrase utrum' run {  
  npcMessages.ambiguousNounPhrase(pirat, 'nyckel', nil, nil);
  assertThat(o).contains('piraten förstår inte vilken nyckel du menar.');
};

TestUnit 'npcMessages.ambiguousNounPhrase plural' run {  
  npcMessages.ambiguousNounPhrase(pirat, 'sopor', nil, nil);
  assertThat(o).contains('piraten förstår inte vilka sopor du menar.');
};


TestUnit 'npcDeferredMessagesDirect.ambiguousNounPhrase okänt' run {  
  npcDeferredMessagesDirect.ambiguousNounPhrase(pirat, 'xyzzy', nil, nil);
  assertThat(o).contains('\^piraten säger, <q>Jag kan inte avgöra vad du menar.</q>');
};

TestUnit 'npcDeferredMessagesDirect.ambiguousNounPhrase neutrum' run {  
  npcDeferredMessagesDirect.ambiguousNounPhrase(pirat, 'äpple', nil, nil);
  assertThat(o).contains('\^piraten säger, <q>Jag kan inte avgöra vilket äpple du menar.</q>');
};

TestUnit 'npcDeferredMessagesDirect.ambiguousNounPhrase utrum' run {  
  npcDeferredMessagesDirect.ambiguousNounPhrase(pirat, 'nyckel', nil, nil);
  assertThat(o).contains('\^piraten säger, <q>Jag kan inte avgöra vilken nyckel du menar.</q>');
};

TestUnit 'npcDeferredMessagesDirect.ambiguousNounPhrase plural' run {  
  npcDeferredMessagesDirect.ambiguousNounPhrase(pirat, 'sopor', nil, nil);
  assertThat(o).contains('\^piraten säger, <q>Jag kan inte avgöra vilka sopor du menar.</q>');
};


