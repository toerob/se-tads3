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
    initialPlayerChar = testPlayer2stPerspective
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

testPlayer1stPerspective: Actor 'jag' 'jag'
  pcReferralPerson = FirstPerson
  isProperName = true
  isHim = true
;

testPlayer2stPerspective: Actor 'du' 'du'
  pcReferralPerson = SecondPerson
  isProperName = true
  isHim = true
;
testPlayer3stPerspective: Actor 'bob' 'Bob'
  pcReferralPerson = ThirdPerson
  isProperName = true
  isHim = true
;

appletObjNeutrumSingular: Thing 'äpple[-t]' 'äpple';
jordgubbeObjUterumSingular: Thing 'jordgubbe[-n]' 'jordgubbe';
vindruvorObjNeutrumPlural: Thing 'vindruva*vindruvor[-na]' 'vindruvor' isPlural=true;

bokenObjUterumSingular: Thing 'bok[-en]' 'bok';
papperetObjNeutrumSingular: Thing 'papper[-et]' 'papper';
skyltarObjUterumPlural: Thing 'skylt*skyltar[-na]' 'skyltar' isPlural=true;

dorrenObjUterSingular: Thing 'dörr[-en]' 'dörr';
skapetObjNeutrumSingular: Thing 'skåp[-et]' 'skåp';

dorrarObjUterPlural: Thing 'dörr*dörr[-ar]' 'dörrar' isPlural = true isUter = true;
skapenObjNeuterPlural: Thing 'skåp[-et]*skåp[-en]' 'skåpen' isPlural = true isUter = nil;

hobbit: Actor 'hobbit[-en]' 'hobbit' isHim = true isProperName = nil;
baren: Room 'baren' 'baren' 
  theName = 'baren'
;

musikenObjUterumSingular: Thing 'musik[-en]' 'musik';
matosetObjUterumSingular: Thing 'matos[-et]' 'matos';

// Test Assertions
UnitTest 'openMsg - uterum singular' run {
  assertThat(libMessages.openMsg(dorrenObjUterSingular)).isEqualTo('öppen');
};
UnitTest 'openMsg - neutrum singular' run {
  assertThat(libMessages.openMsg(skapetObjNeutrumSingular)).isEqualTo('öppet');
};
UnitTest 'openMsg - uterum plural' run {
  assertThat(libMessages.openMsg(dorrarObjUterPlural)).isEqualTo('öppnade');
};
UnitTest 'openMsg - neutrum plural' run {
  assertThat(libMessages.openMsg(skapenObjNeuterPlural)).isEqualTo('öppnade');
};

UnitTest 'distantThingDesc - neutrum plural' run {
  libMessages.distantThingDesc(dorrenObjUterSingular);
  assertThat(o).startsWith('Den är för långt borta för att kunna utgöra några detaljer'); 
};


UnitTest 'obscuredThingDesc first person' run {
  gPlayerChar = testPlayer1stPerspective;
  libMessages.obscuredThingDesc(skapenObjNeuterPlural, skapenObjNeuterPlural);
  assertThat(o).startsWith('Jag kunde inte utgöra några detaljer genom skåpen.');
};

UnitTest 'obscuredThingDesc second person' run {
  gPlayerChar = testPlayer2stPerspective;
  libMessages.obscuredThingDesc(skapenObjNeuterPlural, skapenObjNeuterPlural);
  assertThat(o).startsWith('Du kunde inte utgöra några detaljer genom skåpen.');
};

UnitTest 'obscuredThingDesc second person' run {
  gPlayerChar = testPlayer3stPerspective;
  libMessages.obscuredThingDesc(skapenObjNeuterPlural, skapenObjNeuterPlural);
  assertThat(o).startsWith('Bob kunde inte utgöra några detaljer genom skåpen.');
};


UnitTest 'thingTasteDesc neuter singular' run {
  gPlayerChar = testPlayer2stPerspective;
  libMessages.thingTasteDesc(skapetObjNeutrumSingular);
  assertThat(o).startsWith('Det smakade ungefär som du hade förväntat dig.');
};

UnitTest 'thingTasteDesc uterum singular' run {
  gPlayerChar = testPlayer2stPerspective;
  libMessages.thingTasteDesc(dorrenObjUterSingular);
  assertThat(o).startsWith('Den smakade ungefär som du hade förväntat dig.');
};

UnitTest 'thingTasteDesc plural' run {
  gPlayerChar = testPlayer2stPerspective;
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


UnitTest 'announceRemappedAction uterum dobj' run {
  //mainOutputStream.hideOutput = nil;
  gAction = OpenAction.createActionInstance();
  gAction.setCurrentObjects([dorrenObjUterSingular]);
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

UnitTest 'announceImplicitAction uterum dobj tryingImpCtx' run {
  //mainOutputStream.hideOutput = nil;
  gAction = OpenAction.createActionInstance();
  gAction.setCurrentObjects([dorrenObjUterSingular]);
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
  gPlayerChar = testPlayer1stPerspective;
  libMessages.obscuredThingSoundDesc(appletObjNeutrumSingular, skapetObjNeutrumSingular);
  assertThat(o).startsWith('Jag kunde inte höra något detaljerat genom skåpet.');
};

UnitTest 'obscuredThingSmellDesc first person uterum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = testPlayer1stPerspective;
  libMessages.obscuredThingSmellDesc(appletObjNeutrumSingular, dorrenObjUterSingular);
  assertThat(o).startsWith('Jag kunde inte känna så mycket lukt genom dörren.');
};

UnitTest 'obscuredReadDesc first person uterum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = testPlayer1stPerspective;
  libMessages.obscuredReadDesc(papperetObjNeutrumSingular);
  assertThat(o).startsWith('Jag kunde inte se det bra nog för att kunna läsa det.');
};

UnitTest 'obscuredReadDesc 1a person uterum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = testPlayer2stPerspective;
  libMessages.obscuredReadDesc(bokenObjUterumSingular);
  assertThat(o).startsWith('Du kunde inte se den bra nog för att kunna läsa den.');
};

UnitTest 'obscuredReadDesc 3ee person uterum plural' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = testPlayer3stPerspective;
  libMessages.obscuredReadDesc(skyltarObjUterumPlural);
  assertThat(o).startsWith('Bob kunde inte se dem bra nog för att kunna läsa dem.');
};

UnitTest 'obscuredThingSmellDesc 2a person uterum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = testPlayer2stPerspective;
  libMessages.thingTasteDesc(appletObjNeutrumSingular);
  assertThat(o).startsWith('Det smakade ungefär som du hade förväntat dig.');
};

UnitTest 'dimReadDesc 2a person neutrum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = testPlayer2stPerspective;
  libMessages.dimReadDesc(papperetObjNeutrumSingular);
  assertThat(o).startsWith('Det fanns inte ljus bra nog att läsa det.');
};

UnitTest 'cannotReachObject 1a person dobj: uterum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = testPlayer1stPerspective;
  libMessages.cannotReachObject(appletObjNeutrumSingular);
  assertThat(o).startsWith('Jag kunde inte nå äpplet.');
};

UnitTest 'cannotReachObject 2nd person dobj: uterum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = testPlayer2stPerspective;
  libMessages.cannotReachObject(appletObjNeutrumSingular);
  assertThat(o).startsWith('Du kunde inte nå äpplet.');
};

UnitTest 'cannotReachObject 3e person dobj: uterum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = testPlayer3stPerspective;
  libMessages.cannotReachObject(appletObjNeutrumSingular);
  assertThat(o).startsWith('Bob kunde inte nå äpplet.');
};

UnitTest 'cannotReachContents 1a person dobj: uterum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = testPlayer1stPerspective;
  local str = libMessages.cannotReachContents(appletObjNeutrumSingular, skapetObjNeutrumSingular);
  "<<str>>";
  assertThat(o).startsWith('Jag kunde inte nå det genom skåpet.');
};

UnitTest 'cannotReachContents 2a person dobj: uterum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = testPlayer2stPerspective;
  local str = libMessages.cannotReachContents(appletObjNeutrumSingular, skapetObjNeutrumSingular);
  "<<str>>";
  assertThat(o).startsWith('Du kunde inte nå det genom skåpet.');
};

UnitTest 'cannotReachContents 3e person dobj: uterum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = testPlayer3stPerspective;
  local str = libMessages.cannotReachContents(appletObjNeutrumSingular, skapetObjNeutrumSingular);
  "<<str>>";
  assertThat(o).startsWith('Bob kunde inte nå det genom skåpet.');
};


UnitTest 'cannotReachOutside 2a person dobj: uterum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = testPlayer3stPerspective;
  local str = libMessages.cannotReachOutside(appletObjNeutrumSingular, skapetObjNeutrumSingular);
  "<<str>>";
  assertThat(o).startsWith('Bob kunde inte nå det genom skåpet.');
};


UnitTest 'soundIsFromWithin 2a person dobj: uterum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = testPlayer2stPerspective;
  libMessages.soundIsFromWithin(musikenObjUterumSingular, skapetObjNeutrumSingular);
  assertThat(o).startsWith('\^musiken verkade komma från insidan skåpet.');
};


UnitTest 'soundIsFromWithout 2a person dobj: uterum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = testPlayer2stPerspective;
  libMessages.soundIsFromWithout(musikenObjUterumSingular, skapetObjNeutrumSingular);
  assertThat(o).startsWith('\^musiken verkade komma från utsidan skåpet.');
};

UnitTest 'smellIsFromWithin 2a person dobj: uterum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = testPlayer2stPerspective;
  libMessages.smellIsFromWithin(matosetObjUterumSingular, skapetObjNeutrumSingular);
  assertThat(o).startsWith('\^matoset verkade komma från insidan skåpet.');
};

UnitTest 'smellIsFromWithout 2a person dobj: uterum singular' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = testPlayer2stPerspective;
  libMessages.smellIsFromWithout(matosetObjUterumSingular, skapetObjNeutrumSingular);
  assertThat(o).startsWith('\^matoset verkade komma från utsidan skåpet.');
};

UnitTest 'pcDesc 1a person' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = testPlayer1stPerspective;
  libMessages.pcDesc(gPlayerChar);
  assertThat(o).startsWith('\^jag såg likadan ut som vanligt.');
};
UnitTest 'pcDesc 2a person' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = testPlayer2stPerspective;
  libMessages.pcDesc(gPlayerChar);
  assertThat(o).startsWith('\^du såg likadan ut som vanligt.');
};

UnitTest 'pcDesc 3e person' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = testPlayer3stPerspective;
  libMessages.pcDesc(gPlayerChar);
  assertThat(o).startsWith('\^Bob såg likadan ut som vanligt.');
};

UnitTest 'roomActorStatus actor (ingen output om stående)' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = testPlayer2stPerspective;
  hobbit.posture = standing;
  libMessages.roomActorStatus(hobbit);
  assertThat(o).isEqualTo('');
};

UnitTest 'roomActorStatus actor (sitter)' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = testPlayer2stPerspective;
  hobbit.posture = sitting;
  libMessages.roomActorStatus(hobbit);
  assertThat(o).isEqualTo(' (sitter)');
};

UnitTest 'roomActorStatus actor (ligger)' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = testPlayer2stPerspective;
  hobbit.posture = lying;
  libMessages.roomActorStatus(hobbit);
  assertThat(o).isEqualTo(' (ligger)');
};


UnitTest 'roomActorHereDesc actor (ligger)' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = testPlayer2stPerspective;
  hobbit.posture = standing;
  libMessages.roomActorHereDesc(hobbit);
  assertThat(o).contains('\^hobbiten står där.');
};

UnitTest 'roomActorHereDesc actor (ligger)' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = testPlayer2stPerspective;
  hobbit.posture = sitting;
  libMessages.roomActorHereDesc(hobbit);
  assertThat(o).startsWith('\^hobbiten sitter där.');
};

UnitTest 'roomActorHereDesc actor (ligger)' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = testPlayer2stPerspective;
  hobbit.posture = lying;
  libMessages.roomActorHereDesc(hobbit);
  assertThat(o).startsWith('\^hobbiten ligger där.');
};



UnitTest 'roomActorThereDesc actor (ligger)' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = testPlayer2stPerspective;
  hobbit.posture = standing;
  libMessages.roomActorThereDesc(hobbit);
  assertThat(o).contains('\^hobbiten står i närheten.'); // TODO: OK mening?
};

UnitTest 'roomActorThereDesc actor (ligger)' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = testPlayer2stPerspective;
  hobbit.posture = sitting;
  libMessages.roomActorThereDesc(hobbit);
  assertThat(o).startsWith('\^hobbiten sitter i närheten.'); // TODO: OK mening?
};

UnitTest 'roomActorThereDesc actor (ligger)' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = testPlayer2stPerspective;
  hobbit.posture = lying;
  libMessages.roomActorThereDesc(hobbit);
  assertThat(o).startsWith('\^hobbiten ligger i närheten.'); // TODO: OK mening?
};


// TODO: kan testas betydligt mera
UnitTest 'actorInRoom' run {
  //mainOutputStream.hideOutput = nil;
  gPlayerChar = testPlayer2stPerspective;
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

/* TODO:
UnitTest 'sayArriving' run {
  //mainOutputStream.hideOutput = nil;
  gActor = hobbit;
  hobbit.posture = sitting;
  libMessages.sayArriving(hobbit); 
  assertThat(o).startsWith('Han sitter.');
};*/


// TODO:
/*
actorInRemoteRoom(actor, room, pov)
actorInRemoteNestedRoom(actor, inner, outer, pov)
actorInGroupSuffix(posture, cont, lst)
actorInRemoteGroupSuffix(pov, posture, cont, remote, lst)
actorHereGroupSuffix(posture, lst)
actorThereGroupSuffix(pov, posture, remote, lst)
--sayArriving(traveler)
sayDeparting(traveler)
sayArrivingLocally(traveler, dest)
sayDepartingLocally(traveler, dest)
sayTravelingRemotely(traveler, dest)
sayArrivingDir(traveler, dirName)
sayDepartingDir(traveler, dirName)
sayArrivingShipDir(traveler, dirName)
sayDepartingShipDir(traveler, dirName)
sayDepartingAft(traveler)
sayDepartingFore(traveler)
sayDepartingThroughPassage(traveler, passage)
sayArrivingThroughPassage(traveler, passage)
sayDepartingViaPath(traveler, passage)
sayArrivingViaPath(traveler, passage)
sayDepartingUpStairs(traveler, stairs)
sayDepartingDownStairs(traveler, stairs)
sayArrivingUpStairs(traveler, stairs)
sayArrivingDownStairs(traveler, stairs)
sayDepartingWith(traveler, lead)
sayDepartingWithGuide(guide, lead)
sayOpenDoorRemotely(door, stat)
matchBurnedOut(obj)
candleBurnedOut(obj)
objBurnedOut(obj)
inputFileScriptWarning(warning, filename)
commandNotUnderstood(actor)
specialTopicInactive(actor)
allNotAllowed(actor)
noMatchForAll(actor)
noMatchForAllBut(actor)
noMatchForPronoun(actor, typ, pronounWord)
askMissingObject(actor, action, which)
missingObject(actor, action, which)
askMissingLiteral(actor, action, which)
missingLiteral(actor, action, which)
reflexiveNotAllowed(actor, typ, pronounWord)
wrongReflexive(actor, typ, pronounWord)
noMatchForPossessive(actor, owner, txt)
noMatchForPluralPossessive(actor, txt)
noMatchForLocation(actor, loc, txt)
nothingInLocation(actor, loc)
noMatchDisambig(actor, origPhrase, disambigResponse)
emptyNounPhrase(actor)
zeroQuantity(actor, txt)
insufficientQuantity(actor, txt, matchList, requiredNum)
uniqueObjectRequired(actor, txt, matchList)
singleObjectRequired(actor, txt)
disambigOrdinalOutOfRange(actor, ordinalWord, originalText)
requiredNum, askingAgain, dist)
ambiguousNounPhrase(actor, originalText, matchList, fullMatchList)
missingActor(actor)
singleActorRequired(actor)
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
askMissingObject(actor, action, which)
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
wordIsUnknown(actor, txt)
mustBeHoldingMsg(obj)
mustBeVisibleMsg(obj)
heardButNotSeenMsg(obj)
smelledButNotSeenMsg(obj)
cannotHearMsg(obj)
cannotSmellMsg(obj)
cannotTasteMsg(obj)
cannotBeWearingMsg(obj)
mustBeEmptyMsg(obj)
mustBeOpenMsg(obj)
mustBeClosedMsg(obj)
mustBeUnlockedMsg(obj)
mustSitOnMsg(obj)
mustLieOnMsg(obj)
mustGetOnMsg(obj)
mustBeInMsg(obj, loc)
mustBeCarryingMsg(obj, actor)
decorationNotImportantMsg(obj)
unthingNotHereMsg(obj)
tooDistantMsg(obj)
notWithIntangibleMsg(obj)
notWithVaporousMsg(obj)
lookInVaporousMsg(obj)
cannotReachObjectMsg(obj)
cannotReachThroughMsg(obj, loc)
thingDescMsg(obj)
npcDescMsg(npc)
noiseSourceMsg(src)
odorSourceMsg(src)
cannotMoveComponentMsg(loc)
cannotTakeComponentMsg(loc)
cannotPutComponentMsg(loc)
droppingObjMsg(dropobj)
floorlessDropMsg(dropobj)
cannotMoveThroughMsg(obj, obs)
cannotMoveThroughContainerMsg(obj, cont)
cannotMoveThroughClosedMsg(obj, cont)
cannotFitIntoOpeningMsg(obj, cont)
cannotFitOutOfOpeningMsg(obj, cont)
cannotTouchThroughContainerMsg(obj, cont)
cannotTouchThroughClosedMsg(obj, cont)
cannotReachIntoOpeningMsg(obj, cont)
cannotReachOutOfOpeningMsg(obj, cont)
tooLargeForActorMsg(obj)
handsTooFullForMsg(obj)
becomingTooLargeForActorMsg(obj)
handsBecomingTooFullForMsg(obj)
tooHeavyForActorMsg(obj)
totalTooHeavyForMsg(obj)
tooLargeForContainerMsg(obj, cont)
tooLargeForUndersideMsg(obj, cont)
tooLargeForRearMsg(obj, cont)
containerTooFullMsg(obj, cont)
surfaceTooFullMsg(obj, cont)
undersideTooFullMsg(obj, cont)
rearTooFullMsg(obj, cont)
becomingTooLargeForContainerMsg(obj, cont)
containerBecomingTooFullMsg(obj, cont)
takenAndMovedToKeyringMsg(keyring)
movedKeyToKeyringMsg(keyring)
movedKeysToKeyringMsg(keyring, keys)
circularlyInMsg(x, y)
circularlyOnMsg(x, y)
circularlyUnderMsg(x, y)
circularlyBehindMsg(x, y)
willNotLetGoMsg(holder, obj)
cannotGoThroughClosedDoorMsg(door)
invalidStagingContainerMsg(cont, dest)
invalidStagingContainerActorMsg(cont, dest)
invalidStagingLocationMsg(dest)
nestedRoomTooHighMsg(obj)
nestedRoomTooHighToExitMsg(obj)
cannotDoFromMsg(obj)
vehicleCannotDoFromMsg(obj)
cannotGoThatWayInVehicleMsg(traveler)
cannotPushObjectThatWayMsg(obj)
cannotPushObjectNestedMsg(obj)
cannotEnterExitOnlyMsg(obj)
mustOpenDoorMsg(obj)
doorClosesBehindMsg(obj)
refuseCommand(targetActor, issuingActor)
notAddressableMsg(obj)
noResponseFromMsg(other)
notInterestedMsg(actor)
objCannotHearActorMsg(obj)
actorCannotSeeMsg(actor, obj)
cannotFollowFromHereMsg(srcLoc)
okayFollowInSightMsg(loc)
okayPushTravelMsg(obj)
mustBeBurningMsg(obj)
mustDetachMsg(obj)
foundKeyOnKeyringMsg(ring, key)
foundNoKeyOnKeyringMsg(ring)
roomOkayPostureChangeMsg(posture, obj)
cannotThrowThroughMsg(target, loc)
throwHitMsg(projektilen, target)
throwFallMsg(projektilen, target)
throwHitFallMsg(projektilen, target, dest)
throwShortMsg(projektilen, target)
throwFallShortMsg(projektilen, target, dest)
throwCatchMsg(obj, target)
willNotCatchMsg(catcher)
cannotMoveComponentMsg(loc)
tooLargeForContainerMsg(obj, cont)
tooLargeForUndersideMsg(obj, cont)
tooLargeForRearMsg(obj, cont)
containerTooFullMsg(obj, cont)
surfaceTooFullMsg(obj, cont)
roomOkayPostureChangeMsg(posture, obj)
construct(prefix, suffix)
showCombinedInventoryList(parent, carrying, wearing)
countPhrases(txt)
showInventoryEmpty(parent)
showInventoryWearingOnly(parent, wearing)
showInventoryCarryingOnly(parent, carrying)
showInventoryShortLists(parent, carrying, wearing)
showInventoryLongLists(parent, carrying, wearing)
showInventoryEmpty(parent)
showInventoryWearingOnly(parent, wearing)
showInventoryCarryingOnly(parent, carrying)
showInventoryShortLists(parent, carrying, wearing)
showInventoryLongLists(parent, carrying, wearing)
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
cannotTalkTo(targetActor, issuingActor)
alreadyTalkingTo(actor, greeter)
oopsNote()
acknowledgeVerboseMode(verbose)
showNotifyStatus(stat)
acknowledgeNotifyStatus(stat)
announceMultiActionObject(obj, whichObj, action)
announceAmbigActionObject(obj, whichObj, action)
announceDefaultObject(obj, whichObj, action, resolvedAllObjects)
noCommandForAgain()
againCannotChangeActor()
againCannotTalkToTarget(issuer, target)
againNotPossible(issuer)
systemActionToNPC()
confirmQuit()
notTerminating()
confirmRestart()
saveFailed(exc)
saveFailedOnServer(exc)
makeSentence(msg)
restoreFailedOnServer(exc)
restoreInvalidFile()
restoreCorruptedFile()
restoreInvalidMatch()
restoreFailed(exc)
filePromptFailed()
filePromptFailedMsg(msg)
pausePrompt()
pauseSaving()
pauseEnded()
inputScriptOkay(fname)
inputScriptFailedException(exc)
scriptingOkay()
scriptingOkayWebTemp()
scriptingFailedException(exc)
recordingFailedException(exc)
undoOkay(actor, cmd)
undoFailed()
invalidFinishOption(resp)
exitsOnOffOkay(stat, look)
explainExitsOnOff()
currentExitsSettings(statusLine, roomDesc)
mentionFullScore()
savedDefaults()
restoredDefaults()
defaultsFileReadError(exc)
textMenuMainPrompt(keylist)
textMenuTopicPrompt()
menuInstructions(keylist, prevLink)
menuNextChapter(keylist, title, hrefNext, hrefUp)

*/