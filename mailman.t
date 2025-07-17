#charset "UTF-8"
#include <adv3.h>
#include <sv_se.h> 

tVader: Topic vocabWords = 'vädret';
tPolitik: Topic vocabWords = 'politik';
tMeningenMedLivet: Topic vocabWords = 'meningen/livet';

mailman:Actor 'b/brevis/brevbärare+n*brevbärarna' 'brevbärare' @labbet
    isHim = true
    globalParamName = 'bob'
;

+ bobTalking: InConversationState
    attentionSpan = 5
    specialDesc = "Brevbäraren väntar på att du ska tala. "
    stateDesc = "Han väntar på att du ska tala. "
;

++mailmanState: ConversationReadyState 
    isInitState = true
    specialDesc = "En brevbärare står här redo att dela ut brev. "
;

+++ HelloTopic, StopEventList [
    '<q>Hej!</q> säger du.\b
    <q>Hej!</q> svarar Bob och vänder sig mot dig med ett galet leende. ',
    '<q>Hej igen,</q> hälsar du.\b
    <q>Ja?</q> svarar han och vänder sig tillbaka mot dig. '
];

+++ ByeTopic "<q>Nåväl, vi ses!</q> säger du.\b
    <q>Hej så länge,</q> svarar brevbäraren och vänder sig från dig.";

+++ BoredByeTopic "Brevbäraren tröttnar på att vänta på att du ska tala och börjar kontrollera sina brev.";
+++ LeaveByeTopic "Brevbäraren ser på när du går iväg och börjar kontrollera sina brev. ";

+++ ActorByeTopic "<q>Oj! Är det redan så sent?</q> utbrister brevbäraren och tittar på sin klocka,
<q>Jag måste göra annat! Hejdå!</q>.";

+ GiveTopic @peng 
topicResponse() {
    "Du ger  {ref bob/honom} {ref dobj/han} som han accepterar med en artig nickning. ";
    peng.moveInto(mailman);
}
;

+AskTopic @tVader
    "<q>Hur är vädret</q> frågar du.\b
    <q>Inte värst bra,</q> svarar brevbäraren kyligt. "
;


+mailmanAgenda: AgendaItem
    initiallyActive = true
    agendaOrder = 150
    //isReady = gPlayerChar.canSee(mailman)
    invokeItem() {
        
        mailman.getOutermostRoom();// TODO: Fixa detta först

        local facingCurrentDoor = mailman.getOutermostRoom() == labbet? labbetDoorInside: labbetDoorOutside;

        if(facingCurrentDoor.isLocked) {
            nestedActorAction(mailman, UnlockWith, facingCurrentDoor, labbnyckel);
        } else if (!facingCurrentDoor.isOpen){
            nestedActorAction(mailman, Open, facingCurrentDoor);
        } else if (mailman.getOutermostRoom() == labbet) {
            nestedActorAction(mailman, East);
        } else if (mailman.getOutermostRoom() == korridor) {
            //"HEY!";
            nestedActorAction(mailman, West);
        }
    }
;

/*
+mailmanAgenda2: AgendaItem
    initiallyActive = true
    isReady = labbnyckel.isIn(mailman)
    invokeItem() {
        isDone = true;
    }
;*/



/*
Take
TakeFrom
Remove
Drop
Examine
Read
LookIn
Search
LookThrough
LookUnder
LookBehind
Feel
Taste
Smell
SmellImplicit
ListenTo
ListenImplicit
PutIn
PutOn
PutUnder
PutBehind
PutInWhat
Wear
Doff
Kiss
AskFor
AskWhomFor
AskAbout
AskAboutImplicit
AskAboutWhat
TellAbout
TellAboutImplicit
TellAboutWhat
AskVague
TellVague
TalkTo
TalkToWhat
Topics
Hello
Goodbye
Yes
No
Yell
GiveTo
GiveToType2
GiveToWhom
ShowTo
ShowToType2
ShowToWhom
Throw
ThrowAt
ThrowTo
ThrowToType2
ThrowDir
ThrowDirDown
Follow
Attack
AttackWith
Inventory
InventoryTall
InventoryWide
Wait
Look
Quit
Again
Footnote
FootnotesFull
FootnotesMedium
FootnotesOff
FootnotesStatus
TipsOn
TipsOff
Verbose
Terse
Score
FullScore
Notify
NotifyOn
NotifyOff
Save
SaveString
Restore
RestoreString
SaveDefaults
RestoreDefaults
Restart
Pause
Undo
Version
Credits
About
Script
ScriptString
ScriptOff
Record
RecordString
RecordEvents
RecordEventsString
RecordOff
ReplayString
ReplayQuiet
VagueTravel
Travel
Port
Starboard
In
Out
GoThrough
Enter
GoBack
Dig
DigWith
Jump
JumpOffI
JumpOff
JumpOver
Push
Pull
Move
MoveTo
MoveWith
Turn
TurnWith
TurnTo
Set
SetTo
TypeOn
TypeLiteralOn
TypeLiteralOnWhat
EnterOn
EnterOnWhat
Consult
ConsultAbout
ConsultWhatAbout
Switch
Flip
TurnOn
TurnOff
Light
Strike
Burn
BurnWith
Extinguish
Break
CutWithWhat
CutWith
Eat
Drink
Pour
PourInto
PourOnto
Climb
ClimbUp
ClimbUpWhat
ClimbDown
ClimbDownWhat
Clean
CleanWith
AttachTo
AttachToWhat
DetachFrom
Detach
Open
Close
Lock
Unlock
LockWith
UnlockWith
SitOn
Sit
LieOn
Lie
StandOn
Stand
GetOutOf
GetOffOf
GetOut
Board
Sleep
Fasten
FastenTo
Unfasten
UnfastenFrom
PlugInto
PlugIntoWhat
PlugIn
UnplugFrom
Unplug
Screw
ScrewWith
Unscrew
UnscrewWith
PushTravelDir
PushTravelThrough
PushTravelEnter
PushTravelGetOutOf
PushTravelClimbUp
PushTravelClimbDown
Exits
ExitsMode
HintsOff
Hint
Oops
OopsOnly
Debug
DoffPerson
WearPerson
WearWhat
AskAboutWhat
*/