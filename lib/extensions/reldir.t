#charset "utf-8"

property pointingChange;

/*
 *   Relative Direction System for TADS 3
 *.  Copyright 2003 Michael J. Roberts
 *   
 *   This is a TADS 3 library extension that implements a relative
 *   direction mode, where room descriptions and travel commands use
 *   directions relative to a character's orientation rather than absolute
 *   compass directions: "to the left," "behind you" rather than "to the
 *   north."  In addition, the player can switch at any time between
 *   compass directions and relative directions.
 *   
 *   License terms: Everyone is granted permission to use this code or
 *   modified versions of it in any way they like, free of charge,
 *   provided the copyright notice is preserved in the source code
 *   file(s).  A credit in the compiled ("binary") form of any game
 *   constructed using this code would be appreciated but is not required.
 *   Because this code is provided free of charge, it is provided with
 *   absolutely NO WARRANTY.  
 */

#include <adv3.h>
#include <sv_se.h>

/* ------------------------------------------------------------------------ */
/*
 *   Actor extensions for RELATIVE direction mode.
 *   
 *   Directions in RELATIVE mode are relative to a character's current
 *   orientation.  We need to keep track of which way we're pointing, and
 *   we must provide the necessary routines to adjust directions from the
 *   absolute directions we use internally to the actor-relative
 *   directions we want to display.
 *   
 *   For the most part, the player character's orientation is the most
 *   important.  However, we define these mechanisms generically in Actor
 *   to allow for things like giving relative-direction travel orders to
 *   other characters.  
 */
modify Actor
    /* the direction we're currently pointing */
    pointing = northDirection

    /* 
     *   on travel, orient ourselves so that we're pointing in the arrival
     *   direction of the connector we arrived via
     */
    travelTo(dest, connector, backConnector)
    {
        /*
         *   If the connector has an explicit resulting orientation
         *   associated with it, apply that orientation.  Otherwise, look
         *   at our back-connector, find the direction it uses, and orient
         *   ourselves 180 degrees to it - the direction it uses is the
         *   direction going *in* to the back-connector, and since we're
         *   coming *out* of the connector, we want to use the opposite.  
         */
        if (dest != nil && connector != nil
            && connector.pointingChange != nil)
        {
            /* use the new pointing direction specified in the connector */
            pointing = connector.pointingChange;
        }
        else if (dest != nil && backConnector != nil)
        {
            local dir;
            
            /* find the direction for the back-connector */
            dir = dest.directionForConnector(backConnector, self);

            /* 
             *   If we found it, turn it around 180 degrees - if the
             *   connector back goes east, then we're pointing west when we
             *   come out of it.  Only do this if it's a compass direction.
             */
            if (dir != nil && dir.ofKind(CompassDirection))
                pointing = rotateDir(dir, 180/45);
        }

        /* do the main travel */
        inherited(dest, connector, backConnector);
    }

    /* 
     *   rotate a direction clockwise by the given number of 45-degree
     *   increments 
     */
    rotateDir(dir, inc)
    {
        /* directions, clockwise from north */
        local dirs = [northDirection, northeastDirection, eastDirection,
                      southeastDirection, southDirection, southwestDirection,
                      westDirection, northwestDirection];
        local idx;

        /* find the original direction in our vector */
        idx = dirs.indexOf(dir);

        /* apply the clockwise rotation */
        idx += inc;

        /* adjust to keep it in the index range */
        while (idx > 8)
            idx -= 8;
        while (idx < 1)
            idx += 8;

        /* return the new direction */
        return dirs[idx];
    }

    /* 
     *   Are we in compass direction mode?  If not, we're in relative mode.
     *   
     *   Note that this property is queried fairly frequently, so it would
     *   probably be better not to override it with a method that computes
     *   anything complex.  For example, suppose we wanted to enable
     *   compass mode automatically any time the character has access to a
     *   compass object in the game.  It might be tempting to do this by
     *   overriding this property with a method that returns something
     *   like (compass.isIn(self) && canSee(compass)).  That approach
     *   isn't recommended, though, because canSee() involves fairly
     *   complex computation, and we call this routine frequently enough
     *   that doing so much computation here might be an excessive load on
     *   slower machines.  A better approach would be to write a daemon
     *   that checks at the end of each turn for access to the compass,
     *   and sets this property accordingly.  That would greatly reduce
     *   the amount of work we perform to make the check, since we'd only
     *   check once per turn, while still catching the change as soon as
     *   it matters.  
     */
    absDirMode = nil

    /* 
     *   direction phrases - we map these through the normal language
     *   builder {xxx} mechanism to generate the proper relative or
     *   compass direction phrases 
     */
    dirNameNorth = (relDir(northDirection).name)
    dirNameSouth = (relDir(southDirection).name)
    dirNameEast = (relDir(eastDirection).name)
    dirNameWest = (relDir(westDirection).name)
    
    toTheNorth = (relDir(northDirection).toTheName)
    toTheSouth = (relDir(southDirection).toTheName)
    toTheEast = (relDir(eastDirection).toTheName)
    toTheWest = (relDir(westDirection).toTheName)

    /* "<direction> side" */
    northSide = (relDir(northDirection).sideName)
    southSide = (relDir(southDirection).sideName)
    eastSide = (relDir(eastDirection).sideName)
    westSide = (relDir(westDirection).sideName)

    /* 
     *   Given a compass direction, figure the corresponding compass or
     *   relative direction according to our current mode and rotational
     *   orientation.  
     */
    relDir(dir)
    {
        /* if we're in compass mode, just return the compass direction */
        if (absDirMode)
            return dir;

        /* 
         *   Compute the difference between our "straight ahead" angle
         *   relative to north and the desired direction relative to
         *   north.  This will give us the angle between our "straight
         *   ahead" direction and the desired direction.  After finding
         *   the difference add one, since our list is indexed from 1.  
         */
        local dirFromAhead = getAngleFromNorth(dir)
                             - getAngleFromNorth(pointing) + 1;

        /* relative directions, clockwise from straight ahead */
        local relDirs = [aheadDirection, aheadrightDirection, rightDirection,
                         backrightDirection, backDirection,
                         backleftDirection, leftDirection,
                         aheadleftDirection];

        /* 
         *   adjust our angle from straight ahead to be in the right range
         *   (rotational arithmetic is inherently modular, since if you go
         *   past the limit in one direction, you just wrap around back to
         *   the starting point) 
         */
        while (dirFromAhead > 8)
            dirFromAhead -= 8;
        while (dirFromAhead < 1)
            dirFromAhead += 8;

        /* we now know our relative direction, so get it from the list */
        return relDirs[dirFromAhead];
    }

    /*
     *   Given a direction relative to our "straight ahead" position, find
     *   the corresponding compass direction.  
     */
    relToCompass(dir)
    {
        local relDirs = [aheadDirection, aheadrightDirection, rightDirection,
                         backrightDirection, backDirection,
                         backleftDirection, leftDirection,
                         aheadleftDirection];

        /* 
         *   calculate the angle between "straight ahead" and the given
         *   relative direction 
         */
        local dirAngle = relDirs.indexOf(dir) - 1;

        /* rotate the direction we're pointing by the relative amount */
        return rotateDir(pointing, dirAngle);
    }

    /* 
     *   Get the angle of our pointing position, in 45-degree increments
     *   from north.  Straight ahead = 1, directly right = 3, etc.  
     */
    getAngleFromNorth(dir)
    {
        /* compass directions, clockwise from north */
        local dirs = [northDirection, northeastDirection, eastDirection,
                      southeastDirection, southDirection, southwestDirection,
                      westDirection, northwestDirection];

        /* return the index of of our direction in the list */
        return dirs.indexOf(dir);
    }

;


/* ------------------------------------------------------------------------ */
/*
 *   Add some special language builder {xxx} strings for directional
 *   substitutions.  These allow us to write room description that work in
 *   both absolute and relative direction modes, and that automatically
 *   adjust in relative mode to our rotational orientation. 
 */
modify langMessageBuilder
    paramList_ = static (inherited() + [
        ['north', &dirNameNorth, 'actor', nil, nil],
        ['south', &dirNameSouth, 'actor', nil, nil],
        ['east', &dirNameEast, 'actor', nil, nil],
        ['west', &dirNameWest, 'actor', nil, nil],
    
        ['to-the-north', &toTheNorth, 'actor', nil, nil],
        ['to-the-south', &toTheSouth, 'actor', nil, nil],
        ['to-the-east', &toTheEast, 'actor', nil, nil],
        ['to-the-west', &toTheWest, 'actor', nil, nil],

        ['north-side', &northSide, 'actor', nil, nil],
        ['south-side', &southSide, 'actor', nil, nil],
        ['east-side', &eastSide, 'actor', nil, nil],
        ['west-side', &westSide, 'actor', nil, nil]
    ])
;


/* ------------------------------------------------------------------------ */
/*
 *   The actor-relative direction objects.  Note that these aren't based
 *   on the real Direction class, since they're not real directions;
 *   whenever we use one of these in a command, we'll adjust it to the
 *   actual compass direction according to the player character's
 *   orientation.  
 */
class ActorRelativeDirection: object
    /* the plain name */
    name = nil

    /* the name for 'to the <dir>' phrases */
    toTheName = nil

    /* the '<dir> side' name */
    sideName = nil
;

aheadDirection: ActorRelativeDirection
    name = 'framåt'
    toTheName = 'framför dig'
    sideName = 'framsida'
;

backDirection: ActorRelativeDirection
    name = 'tillbaka'
    toTheName = 'bakom dig'
    sideName = 'baksida'
;

leftDirection: ActorRelativeDirection
    name = 'vänster'
    toTheName = 'till vänster'
    sideName = 'vänstra sidan'
;

rightDirection: ActorRelativeDirection
    name = 'höger'
    toTheName = 'till höger'
    sideName = 'högra sidan'
;

/*
 *   Include the diagnoal relative directions for good measure, but note
 *   that support for these is somewhat limited; in particular, we don't
 *   provide verbs for these, since the phrasing would be awfully awkward,
 *   and we don't provide automatic library text substitutions for these.
 *   Games that use the relative direction system should probably avoid
 *   diagonal directions in constructing room connections.  
 */
aheadrightDirection: ActorRelativeDirection
    name = 'diagonally ahead and to the right'
    toTheName = 'diagonally ahead of you and to your right'
    sideName = 'right front corner'
;

aheadleftDirection: ActorRelativeDirection
    name = 'diagonally ahead and to the left'
    toTheName = 'diagonally ahead of you and to your left'
    sideName = 'left front corner'
;

backrightDirection: ActorRelativeDirection
    name = 'diagonall back and to the right'
    toTheName = 'diagonally behind you and to your right'
    sideName = 'back right corner'
;

backleftDirection: ActorRelativeDirection
    name = 'diagonally back and to the left'
    toTheName = 'diagonally behind you and to your left'
    sideName = 'back left corner'
;

/* ------------------------------------------------------------------------ */
/*
 *   Add some phrasings to the absolute directions 
 */
modify Direction
    toTheName = ('till ' + name)
    sideName = (name + ' sidan')
;

/*
 *   When we're in relative mode, modify the names of the compass
 *   directions so that we refer to them in relative notation. 
 */
modify CompassDirection
    effectiveName(absName)
    {
        /* 
         *   if we're in absolute mode, use the normal name; otherwise,
         *   translate to the relative direction and use that name 
         */
        if (gPlayerChar.absDirMode)
            return absName;
        else
            return gPlayerChar.relDir(self).name;
    }
;
modify northDirection name = effectiveName(inherited());
modify southDirection name = effectiveName(inherited());
modify eastDirection name = effectiveName(inherited());
modify westDirection name = effectiveName(inherited());


/* ------------------------------------------------------------------------ */
/*
 *   Define the grammar rules for the relative direction commands.  Note
 *   that 'L' is already taken as an abbreviation for 'LOOK', so we have
 *   to use a two-letter abbreviation for 'LEFT'.  
 */
#define DefineLangRelativeDir(root, dirNames) \
grammar directionName(root): dirNames: DirectionProd \
   isRelativeDir = true \
   dir = (gActor.relToCompass(root##Direction)) \
; \

DefineLangRelativeDir(ahead, 'framåt' | 'fram' | 'f' );
DefineLangRelativeDir(back, 'bakåt' | 'backa' | 'back' | 'tillbaka' | 'b');
DefineLangRelativeDir(left, 'vänster' | 'v' );
DefineLangRelativeDir(right, 'höger' | 'h');

/* 
 *   delete the grammar for 'aft', which uses 'a' - we want to take over
 *   'a' for 'ahead', and we don't need shipboard directions anyway, so
 *   just dump that rule 
 */
replace grammar directionName(aft): ' ': DirectionProd ;

/* 
 *   delete the grammar for the regular 'go back', since we use 'back' as a
 *   relative direction command instead 
 */
replace VerbRule(GoBack) ' ' : GoBackAction;


/* ------------------------------------------------------------------------ */
/*
 *   Modify the base travel action to disable compass directional travel
 *   while in relative mode.  
 */
modify TravelAction
    execAction()
    {
        local dir = getDirection();
        
        /*
         *   If the direction is a compass direction, check our mode.  If
         *   our mode doesn't match the direction type, don't allow it.
         *   Don't make this check for non-compass directions (such as
         *   up/down or in/out directions), as only compass directions are
         *   affected by the mode.  
         */
        if (dir.ofKind(CompassDirection)
            && (dirMatch.isRelativeDir
                ? gActor.absDirMode : !gActor.absDirMode))
        {
            reportFailure('Den typen av resande är inte tillåten nu - använd istället '
                + (gActor.absDirMode
                   ? 'kompassriktningar (norr, söder, väster, öster)'
                   : 'relativa riktningar (framåt, bakåt, vänster, höger)')
                + '. ');
            return;
        }

        /* it's okay, so proceed */
        inherited();
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   Actions for changing orientation (TURN LEFT, TURN RIGHT, TURN AROUND) 
 */
DefineAction(TurnBy, IAction)
    execAction()
    {
        if (gActor.absDirMode)
        {
            "{Du/han} behöv{er|de} inte oroa dig om riktningen som {jag} {står|stod} vänd mot just nu. ";
        }
        else
        {
            /* acknowledge it */
            mainReport(okayMsg);

            /* rotate the actor's pointing direction by our turn increment */
            gActor.pointing = gActor.rotateDir(gActor.pointing,
                                               turnIncrement);
        }
    }

    /* our acknowledgment message */
    okayMsg = 'Okej. '

    /* our turning amount, in 45-degree increments clockwise */
    turnIncrement = 0
;

DefineAction(TurnAround, TurnByAction)
    okayMsg = '{Du/han} vänd{er|e} {dig} om. '
    turnIncrement = 180/45
;

DefineAction(TurnLeft, TurnByAction)
    okayMsg = '{Du/han} vänd{er|e} {dig} en kvart till vänster. '
    turnIncrement = -90/45
;

DefineAction(TurnRight, TurnByAction)
    okayMsg = '{Du/han} vänd{er|e} {dig} en kvart till höger. '
    turnIncrement = 90/45
;

VerbRule(TurnAround) ('vänd'|'ställ') ('mig'|'dig') ('helt'|) 'om' : TurnAroundAction
    verbPhrase = 'vända/vänder (sig) om'
;

VerbRule(TurnLeft) ('vänd'|'ställ') ('mig'|'dig') ('mot'|) 'vänster' : TurnLeftAction
    verbPhrase = 'vända/vänder (sig) mot vänster'
;

VerbRule(TurnRight) ('vänd'|'ställ') ('mig'|'dig') ('mot'|) 'höger' : TurnRightAction
    verbPhrase = 'vända/vänder (sig) mot höger'
;

/* ------------------------------------------------------------------------ */
/*
 *   System actions for switching direction modes
 */
DefineSystemAction(ChangeDirectionMode)
    execSystemAction()
    {
        me.absDirMode = absDirMode;
        mainReport(okayMsg);
    }
;

VerbRule(CompassMode) 'kompass' : ChangeDirectionModeAction
    absDirMode = true
    okayMsg = 'Nu i riktningsläge: KOMPASS. '
;

VerbRule(RelativeMode) 'relativ' : ChangeDirectionModeAction
    absDirMode = nil
    okayMsg = 'Nu i riktningsläge: RELATIV. '
;

