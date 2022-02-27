#charset "UTF-8"
#include <adv3.h>
#include <sv_se.h> 

//TODO: *brevbärare[#e-na]

mailman:Actor 'b/brevis/brevbärare[-n]*brevbärarna' 'brevbärare' @labbet
    isHim = true
    
;

+mailmanState: ActorState 
    isInitState = true
    specialDesc = "En brevbärare står här redo att dela ut brev. "
;

+mailmanAgenda: AgendaItem
    initiallyActive = true
    agendaOrder = 150
    //isReady = gPlayerChar.canSee(mailman)
    invokeItem() {
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