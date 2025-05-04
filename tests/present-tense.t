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
    usePastTense = nil
;


// Test arrangements

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

testObjUterSingular: Thing 'dörr[-en]' 'dörr';
testObjNeuterSingular: Thing 'skåp[-et]' 'skåp';

testObjUterPlural: Thing 'dörr**dörr[-ar]' 'dörrar' isPlural = true isUter = true;
testObjNeuterPlural: Thing 'skåp[-et]**skåp[-en]' 'skåpen' isPlural = true isUter = nil;


// Test Assertions

UnitTest 'openMsg - uterum singular' run {
  assertThat(libMessages.openMsg(testObjUterSingular)).isEqualTo('öppen');
};
UnitTest 'openMsg - neutrum singular' run {
  assertThat(libMessages.openMsg(testObjNeuterSingular)).isEqualTo('öppet');
};
UnitTest 'openMsg - uterum plural' run {
  assertThat(libMessages.openMsg(testObjUterPlural)).isEqualTo('öppnade');
};
UnitTest 'openMsg - neutrum plural' run {
  assertThat(libMessages.openMsg(testObjNeuterPlural)).isEqualTo('öppnade');
};

UnitTest 'distantThingDesc - neutrum plural' run {
  libMessages.distantThingDesc(testObjUterSingular);
  assertThat(o).startsWith('Den är för långt borta för att kunna utgöra några detaljer'); 
};


UnitTest 'obscuredThingDesc first person' run {
  gPlayerChar = testPlayer1stPerspective;
  libMessages.obscuredThingDesc(testObjNeuterPlural, testObjNeuterPlural);
  assertThat(o).startsWith('Jag kan inte utgöra några detaljer genom dem.');
};

UnitTest 'obscuredThingDesc second person' run {
  gPlayerChar = testPlayer2stPerspective;
  libMessages.obscuredThingDesc(testObjNeuterPlural, testObjNeuterPlural);
  assertThat(o).startsWith('Du kan inte utgöra några detaljer genom dem.');
};

UnitTest 'obscuredThingDesc third person' run {
  gPlayerChar = testPlayer3stPerspective;
  libMessages.obscuredThingDesc(testObjNeuterPlural, testObjNeuterPlural);
  assertThat(o).startsWith('Bob kan inte utgöra några detaljer genom dem.');
};


UnitTest 'thingTasteDesc neuter singular' run {
  gPlayerChar = testPlayer2stPerspective;
  libMessages.thingTasteDesc(testObjNeuterSingular);
  assertThat(o).startsWith('Det smakar ungefär som du förväntade dig.');
};

UnitTest 'thingTasteDesc uterum singular' run {
  gPlayerChar = testPlayer2stPerspective;
  libMessages.thingTasteDesc(testObjUterSingular);
  assertThat(o).startsWith('Den smakar ungefär som du förväntade dig.');
};

UnitTest 'thingTasteDesc plural' run {
  gPlayerChar = testPlayer2stPerspective;
  libMessages.thingTasteDesc(testObjNeuterPlural);
  assertThat(o).startsWith('De smakar ungefär som du förväntade dig.');
};

UnitTest 'announceRemappedAction neutrum dobj' run {
  mainOutputStream.hideOutput = nil;
  gAction = OpenAction.createActionInstance();
  gAction.setCurrentObjects([testObjNeuterSingular]);
  assertThat(libMessages.announceRemappedAction(gAction))
    .contains('öppnar skåpet');
};


UnitTest 'announceRemappedAction uterum dobj' run {
  mainOutputStream.hideOutput = nil;
  gAction = OpenAction.createActionInstance();
  gAction.setCurrentObjects([testObjUterSingular]);
  assertThat(libMessages.announceRemappedAction(gAction))
    .contains('öppnar dörren');
};


UnitTest 'announceRemappedAction plural dobj' run {
  mainOutputStream.hideOutput = nil;
  gAction = OpenAction.createActionInstance();
  gAction.setCurrentObjects([testObjNeuterPlural]);
  assertThat(libMessages.announceRemappedAction(gAction))
    .contains('öppnar skåpen');
};

UnitTest 'announceImplicitAction neutrum dobj tryingImpCtx' run {
  mainOutputStream.hideOutput = nil;
  gAction = OpenAction.createActionInstance();
  gAction.setCurrentObjects([testObjNeuterSingular]);
  assertThat(libMessages.announceImplicitAction(gAction, tryingImpCtx))
    .contains('försöker öppna skåpet först');
};

UnitTest 'announceImplicitAction uterum dobj tryingImpCtx' run {
  mainOutputStream.hideOutput = nil;
  gAction = OpenAction.createActionInstance();
  gAction.setCurrentObjects([testObjUterSingular]);
  assertThat(libMessages.announceImplicitAction(gAction, tryingImpCtx))
    .contains('försöker öppna dörren först');
};

UnitTest 'announceImplicitAction plural dobj tryingImpCtx' run {
  mainOutputStream.hideOutput = nil;
  gAction = OpenAction.createActionInstance();
  gAction.setCurrentObjects([testObjNeuterPlural]);
  assertThat(libMessages.announceImplicitAction(gAction, tryingImpCtx))
    .contains('försöker öppna skåpen först');
};


UnitTest 'announceMoveToBag plural dobj tryingImpCtx' run {
  mainOutputStream.hideOutput = nil;
  gAction = MoveAction.createActionInstance();
  gAction.setCurrentObjects([testObjNeuterPlural]);
  assertThat(libMessages.announceMoveToBag(gAction, tryingImpCtx))
    .contains('försöker flytta skåpen för att göra plats först');
};

// TODO:
/*
announceMoveToBag(action, ctx)
obscuredThingSoundDesc(obj, obs)
obscuredThingSmellDesc(obj, obs)
thingTasteDesc(obj)
obscuredReadDesc(obj)
dimReadDesc(obj)
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
cannotReachObject(obj)
cannotReachContents(obj, loc)
cannotReachOutside(obj, loc)
soundIsFromWithin(obj, loc)
soundIsFromWithout(obj, loc)
smellIsFromWithin(obj, loc)
smellIsFromWithout(obj, loc)
pcDesc(actor)
roomActorStatus(actor)
roomActorHereDesc(actor)
roomActorThereDesc(actor)
actorInRoom(actor, cont)
actorInRoomPosture(actor, room)
roomActorPostureDesc(actor)
actorInRemoteRoom(actor, room, pov)
actorInRemoteNestedRoom(actor, inner, outer, pov)
actorInGroupSuffix(posture, cont, lst)
actorInRemoteGroupSuffix(pov, posture, cont, remote, lst)
actorHereGroupSuffix(posture, lst)
actorThereGroupSuffix(pov, posture, remote, lst)
sayArriving(traveler)
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
*/