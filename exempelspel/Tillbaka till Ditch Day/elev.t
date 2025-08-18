#charset "utf-8"
/*
 *   Copyright 2003, 2013 Michael J. Roberts
 *   
 *   Return to Ditch Day - elevator class.  This is a set of classes for
 *   implementing a typical modern elevator.
 *   
 *   These classes are meant to be reusable in a range of games; they're a
 *   little too specialized for the main system library, but other authors
 *   might find them helpful in creating their own elevators.  Read the
 *   comments carefully, since the various objects make a certain number of
 *   assumptions about their location/contents relationships to one
 *   another; you can override most of these assumptions with methods near
 *   the start of each class, but the default assumptions are probably
 *   suitable for many situations.
 *   
 *   To improve playability, we by default travel between any pair of
 *   floors, no matter how far apart, in a single turn.  You can override
 *   this to take one turn per floor, or any other pace you like, but the
 *   standard pacing is probably the best compromise between playability
 *   and realistic timing, at least for most cases.  There's still some
 *   feeling of a real elevator's cadence, since it always takes an extra
 *   turn for doors to close.  Also, since the elevator moves around in the
 *   background when it has work to do, it'll take extra time when it has
 *   extra stops to make; for example, if you push all of the buttons and
 *   get out on the first stop, then call the elevator, it'll take a while
 *   to get there because it'll actually have to service all of those other
 *   stops.  
 */

#include <adv3.h>
#include <sv_se.h>

/*
 *   An elevator.  This is a mix-in class that should be combined with
 *   Room or a Room subclass to create the elevator's interior.  Place an
 *   ElevatorInnerDoor directly within this object to serve as the
 *   elevator door.  
 */
class Elevator: object
    /* 
     *   the standard amount of time (in turns) to leave the doors open
     *   each time we respond to a call 
     */
    doorOpenTime = 2

    /*
     *   Continue the elevator's motion.  'curFloorNum' is the current
     *   floor number, and 'targetFloorNum' is the target floor number.
     *   This method should move the elevator as far as we can go in one
     *   turn, and return the *actual* new floor number - this need not be
     *   the same as the target floor, since the elevator can limit its
     *   pace as it sees fit.  For example, you could implement this
     *   routine so that it moves the elevator only one floor per turn.
     *   
     *   In addition to moving the elevator, this routine should comment on
     *   any changes that occur in the course of the travel.  For example,
     *   if the elevator has a display showing the current floor number,
     *   this routine should comment on the change in the displayed floor
     *   number.  We don't assume a display by default, so we don't say
     *   anything here.
     *   
     *   By default, we'll move the elevator the entire distance to the new
     *   floor.  Some people might find it more realistic to move the
     *   elevator one turn per floor, since then the time required in turns
     *   would scale with the length of the journey; but I like the instant
     *   travel for two reasons.
     *   
     *   First, it's simply more playable; I think it's better in general
     *   not to let reality trump playability for reality's sake alone, and
     *   in this regard, gratuitous 'wait' commands are as bad as
     *   gratuitous sleeping and eating.  The only reason I'd slow down the
     *   elevator is for the sake of the game design; for example, this
     *   could be useful if you have a timed puzzle that depends on
     *   visiting floors in an optimized order.
     *   
     *   Second, even though one-floor-per-turn seems superficially
     *   "realistic," I don't think it actually is.  Trying to tie 'turns'
     *   to any concrete measure of real-world time almost always makes a
     *   game less realistic, not more; to a player, different commands
     *   ought to take radically different amounts of time to be realistic.
     *   Game time is almost always better handled as a "narrative" or
     *   "subjective" time, where the amount of time that passes depends on
     *   the amount of *interesting* stuff that happens, not on the number
     *   or types of commands entered.  
     */
    continueElevatorMotion(curFloorNum, targetFloorNum)
    {
        /* 
         *   by default, travel directly - all in this one turn - to the
         *   target floor 
         */
        return targetFloorNum;
    }

    /* 
     *   Announce that we're starting to move.  'dir' is the direction of
     *   movement: 1 is up, -1 is down.  
     */
    announceStart(dir)
    {
        "Hissen börjar röra sig. ";
    }

    /* 
     *   Announce that we're stopping at a floor and opening our doors.
     *   'moving' indicates whether or not we were moving before this stop;
     *   if not, it means we're simply opening our doors at the floor where
     *   we already were located.  'newDir' is the direction we'll be going
     *   after this floor: 1 is up, -1 is down, and 0 means we're just
     *   opening our doors with nowhere to go.  
     */
    announceStop(moving, newDir)
    {
        /* if we were moving, we're moving no longer */
        if (moving)
            "Hissen stannar, och dörrarna skjuts upp. ";
        else
            "Hissens dörrar skjuts upp. ";
    }

    /* 
     *   Get my door.  By default, this is simply the ElevatorDoor object
     *   directly within our contents.  Override this if the relationship
     *   to the elevator door is different (if it's in an intermediate
     *   container, for example). 
     */
    getElevatorDoor()
        { return contents.valWhich({x: x.ofKind(ElevatorDoor)}); }

    /* 
     *   The direct container of my buttons.  By default, that's just me.
     *   You can override this if you want to create an intermediate
     *   object to hold the buttons - a control panel object, for example.
     */
    buttonContainer = (self)

    /* get a list of my floor buttons */
    getButtonList()
    {
        /* 
         *   return all of the ElevatorButton objects among the contents
         *   of the container of my buttons 
         */
        return buttonContainer.contents.subset({x: x.ofKind(ElevatorButton)});
    }

    /* get the current floor number */
    getFloorNum()
    {
        /* read the floor number from the outer door where we're parked */
        return getElevatorDoor().otherSide.floorNum;
    }

    /* 
     *   get the current floor name - we'll get this from the button for
     *   the current floor 
     */
    getFloorName()
    {
        /* return the name for the current floor */
        return getNameForFloor(getFloorNum);
    }

    /* get the name for the given floor */
    getNameForFloor(floor)
    {
        /* get the button for this floor, and return its name */
        return getButtonList().valWhich({x: x.floorNum == floor}).floorName;
    }

    /* note that a floor button inside the elevator has been lit */
    noteButtonLit()
    {
        local door = getElevatorDoor();
        
        /* 
         *   If the doors are open, speed up the close timer.  In real
         *   elevators, pushing a floor button tends to close the doors
         *   more or less right away. 
         */
        if (door.isOpen && doorTimer > 1)
            doorTimer = 1;

        /* if the elevator daemon isn't running, start it up */
        startElevatorDaemon();
    }

    /* extend the door timer to the maximum timeout */
    extendDoorTimer()
    {
        /* set the door timer to the standard open time */
        doorTimer = doorOpenTime;
    }

    /* note a call from a floor button */
    noteFloorCall(floor, dir, lit)
    {
        local btn;
        
        /* 
         *   find the floor button corresponding to this floor, and set
         *   the call for the given direction 
         */
        btn = getButtonList().valWhich({x: x.floorNum == floor});

        /* mark it as called or not, according to the new status */
        if (dir == 1)
            btn.calledGoingUp = lit;
        else
            btn.calledGoingDown = lit;

        /* if the daemon isn't running, start it up */
        startElevatorDaemon();
    }

    /* cancel our call button for the current floor in the given direction */
    cancelCallButton(door, dir)
    {
        local btn;
        
        /* find the appropriate button on the outside of the elevator */
        btn = door.otherSide.buttonContainer.contents.valWhich(
            {x: x.ofKind(ElevatorCallButton) && x.buttonDir == dir});

        /* turn off this button's floor call */
        btn.setFloorCall(nil);
    }

    /* start the elevator daemon, if it's not already running */
    startElevatorDaemon()
    {
        if (!elevatorDaemonRunning)
        {
            /* start the daemon */
            new SenseDaemon(self, &elevatorDaemon, 1, self, sight);

            /* note that it's running so that we don't start it again */
            elevatorDaemonRunning = true;
        }
    }

    /*
     *   The main elevator daemon.  We keep this running whenever we have
     *   any pending work: specifically, our door is open, or we have any
     *   active floor call pending.  When we have no work, we cancel the
     *   daemon.  
     */
    elevatorDaemon()
    {
        local door = getElevatorDoor();
        local lst;
        local len;
        local i;
        local btn;
        local lastCallBtn;
        local floor;
        local iter;

        /* note our current floor */
        floor = door.otherSide.floorNum;

        /* if the door is open, consider closing it */
        if (door.isOpen)
        {
            /* decrement the timer; close the doors if it's reached zero */
            if (doorTimer-- <= 0)
            {
                /* close the doors */
                door.makeOpen(nil);

                /* mention it */
                "Hissdörrarna skjuts ihop tätt. ";
            }

            /* 
             *   When the doors are open, we can't move; even if we just
             *   closed them, wait a turn before considering any motion,
             *   to simulate the timing of real elevators.  
             */
            return;
        }

        /* get a list of my floor buttons, in order of floor number */
        lst = getButtonList.sort(SortAsc, {a, b: a.floorNum - b.floorNum});

        /* get the list's length */
        len = lst.length();

        /*
         *   Keep going until we either find a floor-call to respond to,
         *   or figure out that we have no pending work.  We have to loop
         *   because we might have to reverse our direction and try again. 
         */
        for (iter = 1 ; ; ++iter)
        {
            local newDir;
            
            /* if we have no pending work, we're done  */
            if (lst.indexWhich({x: x.isCalling}) == nil)
            {
                /* 
                 *   Since we have no pending work, we can cancel the
                 *   daemon.  Any sort of floor call will start the daemon
                 *   again, so we don't need it as long as we're idle. 
                 */
                eventManager.removeCurrentEvent();
                elevatorDaemonRunning = nil;

                /* we're not going in any direction now */
                currentDir = 0;

                /* we're done */
                return;
            }

            /* 
             *   if we're not going in any direction, select one according
             *   to any available call 
             */
            if (currentDir == 0)
            {
                /* 
                 *   Find any button on another floor with a call.  If the
                 *   current floor has a call, we won't need a direction,
                 *   as we'll start with the current floor's called
                 *   direction. 
                 */
                btn = lst.valWhich({x: x.isCalling && x.floorNum != floor});

                /* go in that direction */
                if (btn != nil)
                    currentDir = (btn.floorNum < floor ? -1 : 1);
            }

            /* we don't know the new direction after the call yet */
            newDir = nil;

            /*
             *   We have a pending call somewhere, so find the next one to
             *   service and go service it.  Starting at the current
             *   floor, and working in the current direction, check each
             *   floor until we find one where we want to stop.  
             */
            for (i = lst.indexWhich({x: x.floorNum == floor}),
                 lastCallBtn = nil ;
                 i >= 1 && i <= len ; i += currentDir)
            {
                /* get the current floor button */
                btn = lst[i];

                /* 
                 *   If this is the first pass, and we have a direction,
                 *   ignore the current floor.  This ensures that we don't
                 *   get called back to the current floor by a button push
                 *   right after we close the doors and prepare to leave.
                 *   Real elevators tend to ignore calls to the current
                 *   floor as long as they have somewhere else to go.  
                 */
                if (iter == 1 && btn.floorNum == floor && currentDir != 0)
                    continue;
                
                /* 
                 *   If the button has a floor call in our current
                 *   direction, we want to stop here.  Note that if we
                 *   don't have a direction, we'll take either one.  
                 */
                if (currentDir >= 0 && btn.calledGoingUp)
                {
                    /* 
                     *   we're answering a going-up call, so the new
                     *   direction after the call is definitely 'up'
                     */
                    newDir = 1;
                    break;
                }
                if (currentDir <= 0 && btn.calledGoingDown)
                {
                    /* we're answering a going-down call */
                    newDir = -1;
                    break;
                }

                /* if the button is lit, we want to stop here */
                if (btn.isLit)
                    break;

                /* 
                 *   If this button is on floor call in the *opposite*
                 *   direction, we don't necessarily want to stop here,
                 *   since we could have another floor further in the
                 *   current direction to visit first.  However, if we
                 *   eventually discover that we *don't* have any more
                 *   calls in the current direction, we'll want to proceed
                 *   to this floor to handle its call the other way.  So,
                 *   note it as the last on-call floor, so that we can
                 *   visit it if we don't find anything else in this
                 *   direction.  
                 */
                if (btn.calledGoingUp || btn.calledGoingDown)
                    lastCallBtn = btn;

                /* this button isn't on call, so forget it */
                btn = nil;
            }

            /*
             *   If we found anything, and we haven't already decided on
             *   the new direction, determine the direction we'll be going
             *   after answering the call.  If we have a direction, and
             *   there's any call in the current direction beyond the floor
             *   we're going to, we'll continue in the current direction.
             *   Otherwise, we have no direction.  
             */
            if (newDir == nil && (btn != nil || lastCallBtn != nil))
            {
                if (btn != nil)
                {
                    local c;
                    
                    /*
                     *   We're answering an in-elevator call.  These are by
                     *   themselves non-directional; they just ask us to go
                     *   to the given floor and stop.
                     *   
                     *   If we have no direction, we must be stopping at
                     *   the same floor, so this establishes no new
                     *   direction.
                     *   
                     *   Otherwise, if there are any other floors called in
                     *   the same direction, we want to continue in the
                     *   same direction.  If not, we have no new direction
                     *   on reaching the called floor.  
                     */
                    if (currentDir == 0)
                    {
                        /* no direction now, so none after the call */
                        newDir = 0;
                    }
                    else
                    {
                        local target = btn.floorNum;
                        
                        /* scan for calls above/below */
                        if (currentDir == 1)
                            c = lst.indexWhich(
                                {x: x.floorNum > target && x.isCalling});
                        else
                            c = lst.indexWhich(
                                {x: x.floorNum < target && x.isCalling});

                        /* 
                         *   if we found anything, continue in the same
                         *   direction; if not, there's no new direction 
                         */
                        newDir = (c != nil ? currentDir : 0);
                    }
                }
                else
                {
                    /* 
                     *   We're answering a last-call button, so the new
                     *   direction is the always reverse of the current
                     *   one.  (We only answer last-call buttons when we
                     *   have no one calling us for travel in the same
                     *   direction, so this always requires a reversal.)  
                     */
                    newDir = -currentDir;
                }
            }

            /* if we're going to the last-call button, use it */
            if (btn == nil)
                btn = lastCallBtn;

            /* if we found a floor to visit, go there now */
            if (btn != nil)
            {
                /* 
                 *   travel to this floor, answering the call in the
                 *   current direction 
                 */
                goTowardFloor(door, btn, newDir, lst);

                /* we're done */
                return;
            }

            /*
             *   We didn't find any floors further along in the current
             *   direction that are calling us.  So, reverse direction,
             *   un-light all of the buttons (which real elevators always
             *   do on a direction reversal), and loop back for another
             *   try with the new direction.  
             */
            currentDir = -currentDir;
            unlightAllButtons(lst);
        }
    }

    /* 
     *   Move in the current direction, with the given floor button as the
     *   goal.  We're answering the button's call in the direction
     *   'answerDir', which might not be the same as the direction we're
     *   moving; for example, if we're answering a 'going down' call on a
     *   floor above us, we'll have to travel up to get there, but we'll be
     *   going down as soon as we answer the call.  
     */
    goTowardFloor(door, btn, answerDir, btnList)
    {
        local newFloorNum;
        
        /* if we're not already at the target floor, move the elevator */
        if (btn.floorNum != door.otherSide.floorNum)
        {
            /* if we're not already in motion, start moving */
            if (!isInMotion)
            {
                /* mention that we're now moving */
                announceStart(currentDir);

                /* we're now in motion */
                isInMotion = true;
            }

            /* proceed as far as possible toward the new floor */
            newFloorNum = continueElevatorMotion(
                door.otherSide.floorNum, btn.floorNum);
        }
        else
        {
            /* we're already there, so the new floor is the current floor */
            newFloorNum = btn.floorNum;
        }

        /*
         *   Set our door's other-side property to point to the outer door
         *   on the new floor.  To do this, find an ElevatorDoor object
         *   that has our door as its other side and which has the new
         *   floor number.  
         */
        forEachInstance(ElevatorDoor, new function(obj) {
            if (obj.otherSide == door && obj.floorNum == newFloorNum)
                door.otherSide = obj;
        });

        /* if we've reached the new floor, stop moving and open the doors */
        if (newFloorNum == btn.floorNum)
        {
            /* announce that we're stopping */
            announceStop(isInMotion, answerDir);

            /* we're no longer moving, if we were */
            isInMotion = nil;

            /* un-light the button for this floor inside the elevator */
            btn.isLit = nil;

            /* also remove the floor call for our current direction */
            if (answerDir != 0)
                cancelCallButton(door, answerDir);

            /* if we're changing directions, unlight the buttons */
            if (answerDir != currentDir)
            {
                /* put the new direction into effect */
                currentDir = answerDir;

                /* unlight all of the internal buttons */
                unlightAllButtons(btnList);
            }

            /* open the doors */
            door.makeOpen(true);
        }
    }

    /* unlight all of the buttons that are currently lit */
    unlightAllButtons(lst)
    {
        /* check to see if any are lit */
        if (lst.indexWhich({x: x.isLit}) != nil)
        {
            /* mention it */
            "Alla knappar slocknar. ";

            /* turn them all off */
            lst.forEach({x: x.isLit = nil});
        }
    }

    /* flag: our daemon is running */
    elevatorDaemonRunning = nil

    /* the number of turns remaining until we close the door */
    doorTimer = nil

    /* our current direction: 1 is up, -1 is down, 0 is neutral */
    currentDir = 0

    /* flag: we're currently in motion */
    isInMotion = nil
;

/* ------------------------------------------------------------------------ */
/* 
 *   A class for standard sliding elevator doors.  The master object must
 *   be set to the interior door of the associated elevator.  
 */
class ElevatorDoor: Door
    /* 
     *   Get our associated elevator room.  This is the object that
     *   contains the interior door of the elevator.  By default, this is
     *   simply the direct container of the other side of the door; you
     *   can override this if there's some other relationship to the
     *   elevator room.  
     */
    getElevator() { return otherSide.location; }

    /*
     *   Get the direct container of our up/down call buttons.  By
     *   default, this is simply our direct location.  Override this if
     *   you have some other arrangement, such as an intermediate object
     *   that contains the buttons (a control panel, for example).  
     */
    buttonContainer = (location)

    /* describe our buttons - look for our buttons in our container */
    buttonDesc()
    {
        local btns;
        
        /* scan our container's contents for our buttons */
        btns = buttonContainer.contents.subset(
            {x: x.ofKind(ElevatorCallButton)});

        /* if we have just one, say which kind; otherwise, say we have both */
        if (btns.length() == 1)
            "Bredvid dörrarna finns <<btns[1].aDesc>>. ";
        else if (btns.length() == 2)
            "Bredvid dörrarna finns både en <q>upp</q> och <q>ner</q>-knapp. ";
    }

    /* start out closed by default */
    initiallyOpen = nil

    /* 
     *   we're only open if the master side is open AND we're the master
     *   side's other side (i.e., the elevator is at this floor) 
     */
    isOpen = (inherited()
              && (masterObject == self || masterObject.otherSide == self))

    /* we can't manually open or close the doors */
    dobjFor(Open) { action() { "Hissdörrarna är automatiska;
        du kan inte öppna dem manuellt."; } }
    dobjFor(Close) { action() { "Hissdörrarna öppnas och stängs 
        automatiskt."; } }

    /* 
     *   since we can't open the doors manually, don't make opening the
     *   doors a precondition of travel 
     */
    getDoorOpenPreCond() { return nil; }

    /* if we can't travel, it's because the doors are closed */
    cannotTravel() { "Hissdörrarna är stängda. "; }

    /* 
     *   Customize the message for remote opening and closing.  This is
     *   the message that will always be used for the outside doors (i.e.,
     *   the doors to the elevator on a floor outside the elevator),
     *   because the interior side of the door always controls the door.  
     */
    noteRemoteOpen(stat)
    {
        /* note the elevator's direction */
        local dir = getElevator().currentDir;
        
        callWithSenseContext(self, sight,
                             {: announceRemoteOpen(stat, dir) });
    }

    /* announce that the doors are opening automatically */
    announceRemoteOpen(stat, dir)
    {
        "Hissens dörrar skjuts <<stat ? 'upp' : 'ihop'>>. ";
    }

    /* the floor number on which this door is located */
    floorNum = 0

    /* "get in elevator" is the same as "go through doors" */
    dobjFor(Board) asDobjFor(GoThrough)
;

/*
 *   Elevator call button.  This is a button positioned alongside an
 *   elevator door, outside the elevator, to summon the elevator to this
 *   floor.
 *   
 *   You must locate these buttons in the same immediate location as the
 *   associated elevator door.  Other parts of the elevator will find
 *   these buttons by looking in the door's location.  
 */
class ElevatorCallButton: Button, Fixture
    '(hissens) (liftens) hiss|knapp+en*hiss|knappar+na' 'hissknappen'
    "Den är <<isLit ? '' : 'o'>>tänd. "

    dobjFor(Switch) asDobjFor(Push)
    dobjFor(Push)
    {
        action()
        {
            local door;
            
            /* 
             *   If one of our doors is already open on this floor, simply
             *   extend its timer.  Otherwise, if we're not already lit,
             *   light up and notify the elevator of the call; otherwise,
             *   do nothing.  
             */
            if ((door = getElevatorDoors().valWhich(
                {x: x.otherSide.otherSide == x && x.isOpen}))
                != nil
                && door.otherSide.getElevator.currentDir is in (0, buttonDir))
            {
                /* extend the timer on the inner door */
                door.otherSide.getElevator.extendDoorTimer();

                /* nothing really happens */
                "Knappen lyser upp tillfälligt och slocknar sedan. ";
            }
            else if (!isLit)
            {
                /* light it up */
                "Du trycker på knappen, som lyser upp. ";

                /* notify our elevator(s) */
                setFloorCall(true);
            }
            else
            {
                /* 
                 *   we're already lit, and no elevator is here, so this
                 *   has no effect at all
                 */
                "Du trycker på knappen igen, men den lyser redan, så
                det har ingen uppenbar effekt. ";
            }

        }
    }

    /* clear our floor call */
    setFloorCall(lit)
    {
        /* note our new 'lit' status */
        isLit = lit;

        /* notify each elevator in my list */
        foreach (local door in getElevatorDoors())
        {
            /* let this door's elevator know about the change */
            door.getElevator().noteFloorCall(door.floorNum, buttonDir, lit);
        }
    }

    /* 
     *   Get my associated elevator door(s).  This returns a list, to
     *   allow for elevator lobbies where a single call button summons any
     *   of a bank of available elevators.  By default, we return a list
     *   of all of the ElevatorDoor objects in our direct location.  
     */
    getElevatorDoors()
    {
        /* find the elevator door among our location's contents */
        return location.contents.subset({x: x.ofKind(ElevatorDoor)});
    }

    /* the direction of travel we request - 1 for up, -1 for down */
    buttonDir = nil

    /* flag: we're currently lit */
    isLit = nil
;

/* an "up" call button */
class ElevatorUpButton: ElevatorCallButton '"upp" -' '<q>upp</q>-knapp'
    "Den visar en pil som pekar uppåt. "
    aDesc = "an <q>up</q> button"
    buttonDir = 1
;

/* a "down" call button */
class ElevatorDownButton: ElevatorCallButton '"ner" "ned" "nedåt" -' '<q>ned</q>-knapp'
    "Den visar en pil som pekar nedåt. "
    buttonDir = -1
;

/* ------------------------------------------------------------------------ */
/*
 *   Elevator inner door - this is a subclass of the elevator door for use
 *   on the *inside* of an elevator. 
 */
class ElevatorInnerDoor: ElevatorDoor
    /*
     *   Each instance must initialize otherSide to point to the outer
     *   door on the floor where the elevator starts. 
     */
    otherSide = nil

    /* our elevator - this is by default simply our location */
    getElevator = (location)

    /* open the door */
    makeOpen(flag)
    {
        local wasOpen = isOpen;
        local elev = getElevator;
        
        /* do the normal work */
        inherited(flag);
        
        /* 
         *   if we just opened, set the elevator's door timer to its
         *   standard open timeout 
         */
        if (!wasOpen && isOpen)
            elev.extendDoorTimer();
    }

    /*
     *   Because our destination changes a lot, make it not apparent what
     *   our destination is when our doors are closed. 
     */
    getApparentDestination(loc, actor)
    {
        /* 
         *   use the inherited apparent destination if we're open; when
         *   we're closed, our destination is not apparent at all, so
         *   simply return nil 
         */
        return isOpen ? inherited(loc, actor) : nil;
    }

    /*
     *   Our 'otherSide' changes dynamically as we move between floors; we
     *   must initialize it explicitly in each instance to the starting
     *   floor.  The different floors will try to tell us about
     *   themselves, so ignore the initMasterObject() and just use our
     *   fixed initial value.  
     */
    initMasterObject(other) { }
;

/*
 *   An elevator button.  This is for floor buttons with in the elevator. 
 */
class ElevatorButton: Button, Fixture 'hiss+knapp+en/lift+knapp+en*hiss+knappar+na'
    /* button name - by default, this is just 'button' and the floor name */
    name = ('hissknapp ' + floorName)
    theName = (name)
    aName = (name)

    /* 
     *   The floor number we're associated with - this must be set for
     *   each button instance.  The floor numbers should always be
     *   contiguous integers ascending in order of the 'up' direction.
     *   Note that you can give your floors names different from the floor
     *   numbers; simply use floorName to give the floor its name.  
     */
    floorNum = 0

    /* 
     *   The name of the floor.  By default, this simply returns the floor
     *   number as a string.  This can be overridden if the floor names
     *   are different than their numbers; for example, you might want to
     *   use 'G' for the ground floor and 'B' for the basement.  
     */
    floorName = (toString(floorNum))

    /* 
     *   Our elevator room object - by default, this is simply our
     *   location.  Override this if the button has some other
     *   relationship to the room (for example, you'll need to override
     *   this if you create an intermediate container, such as a control
     *   panel object that contains the buttons).  
     */
    getElevator = (location)

    /* flag: we're lit */
    isLit = nil

    /* 
     *   flags: this floor is on call from the floor itself (so we're not
     *   lit, but the elevator is on call for the floor), with a request
     *   to go up or down 
     */
    calledGoingUp = nil
    calledGoingDown = nil

    /* 
     *   are we calling the elevator to our floor, either by being lit
     *   inside the elevator or having an up or down button lit on our
     *   floor?  
     */
    isCalling = (isLit || calledGoingUp || calledGoingDown)

    dobjFor(Push)
    {
        action()
        {
            if (isLit)
            {
                /* we're already lit, so just say so */
                "Du trycker på knappen en gång till, men den är redan tänd. ";

                /* 
                 *   Let the elevator know a button is lit.  Do this even
                 *   though the button was already lit, as pressing a
                 *   button has the side effect of closing the doors
                 *   earlier.  
                 */
                getElevator.noteButtonLit();
            }
            else if (getElevator.getFloorNum() == floorNum
                     && getElevator.getElevatorDoor().isOpen)
            {
                /* 
                 *   the door is already open at our floor; just extend the
                 *   door-open timer 
                 */
                getElevator.extendDoorTimer();

                /* the visible effects are minimal, though */
                "Knappen tänds tillfälligt när du trycker på den,
                och slocknar sedan. ";
            }
            else
            {
                /* note that we're lit */
                isLit = true;

                /* mention it */
                "Knappen tänds när du trycker på den. ";

                /* tell the elevator about the change */
                getElevator.noteButtonLit();
            }
        }
    }
;

/*
 *   It's often nice to use a collective group to field references to an
 *   unspecified button.  Elevator button groups tend to be large, so
 *   disambiguation questions involving them can get unwieldy; the
 *   collective object avoids that by using a single, unambiguous object
 *   to represent the whole collection when no particular button is called
 *   out by name.
 *   
 *   Always put the group in the same location as the individual buttons;
 *   we'll look for our individual buttons among our direct container's
 *   contents.  
 */
class ElevatorButtonGroup: CollectiveGroup, Fixture
    'hiss|knapp+en/lift|knapp+en*hiss|knappar+na liftknappar+na' 'hissknappar'

    /* list the list buttons */
    listLit()
    {
        local lst;
        
        /* get the list of lit call buttons */
        lst = location.contents.subset(
            {x: x.ofKind(ElevatorButton) && x.isLit});

        /* show the list */
        litLister.showList(nil, nil, lst, 0, 0, nil, nil);
    }

    /* a lister for the lit buttons */
    litLister: Lister {
        showListEmpty(pov, parent) { }
        showListPrefixWide(cnt, pov, parent)
            { "Knapp<<cnt == 1 ? '' : 'ar'>> "; }
        showListSuffixWide(cnt, pov, parent)
            { " är tänd<<cnt == 1 ? '' : 'a'>>. "; }

        isListed(obj) { return true; }
        showListItem(obj, options, pov, info) { say(obj.floorNum); }
    }

    /* take over all actions */
    isCollectiveAction(action, whichObj) { return true; }

    /* take over all singular and unspecified quantities */
    isCollectiveQuant(np, requiredNum) { return requiredNum is in (nil, 1); }

    /* for Push, don't ask which button; just say they need to say */
    dobjFor(Push)
    {
        verify() { }
        action() { "Du behöver säga vilken knapp du menar. "; }
    }
;
