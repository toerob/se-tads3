/*
 *   Copyright 2003, 2013 Michael J. Roberts
 *   
 *   Return to Ditch Day - Bridge Lab.  Bridge has a fairly large internal
 *   geography, so we split this off into its own separate file.  This
 *   also includes some of the steam tunnels accessible from Bridge.  
 */

#include <adv3.h>
#include <en_us.h>
#include <bignum.h>

/* ------------------------------------------------------------------------ */
/*
 *   Bridge entryway 
 */
bridgeEntry: Room 'Bridge Lab Entryway' 'the Bridge entryway' 'hall'
    "This entry hall reflects the different sense of proportion 
    architects had in the 1920s: it's a bit too narrow and a bit too
    tall to the modern eye.  At the south end of the hall, stairs
    lead up and down, and a doorway at the north end leads outside.
    A display case is set into the east wall. "

    vocabWords = 'bridge lab laboratory entry entryway/hall'

    north = millikanPond
    out asExit(north)
    up = beStairsUp
    down = beStairsDown

    roomParts = (inherited() - defaultEastWall)
;

+ ExitPortal 'doorway' 'doorway'
    "The doorway leads outside to the north. "
;

+ Decoration 'east e wall*walls' 'east wall'
    "A display case is set into the wall. "
;

++ Fixture, Container 'display case/glass' 'display case'
    "The case contains an assortment of items of historical
    significance in physics.  Among other things, there's a lab
    notebook, a tiny motor, and various bits of experimental
    equipment. "
    isOpen = nil
    material = glass

    /* 
     *   since we list our contents explicitly, don't mention them again in
     *   the generated description 
     */
    examineListContents() { }
    contentsListed = nil

    dobjFor(Break)
    {
        verify() { }
        action() { "There's no reason to vandalize this display. "; }
    }
;

+++ Readable
    'robert a. millikan\'s lab laboratory cursive
    page/book/notebook/tables/calculations/data/handwriting' 'lab notebook'
    "The notebook is open to a page showing a series of 
    tables and calculations in precise cursive handwriting.
    The caption reads:
    <q>Robert A.\ Millikan's laboratory notebook, 1910.
    These pages show data taken during his famous <q>oil drop
    experiment,</q> in which he determined for the first time the
    charge of the electron.  This work led to the Nobel Prize in
    Physics in 1924.</q> "

    isListed = nil
;

+++ Thing 'tiny world\'s smallest magnifying motor/engine/(glass)'
    'tiny motor'
    "A magnifying glass positioned in front of the tiny device
    makes it recognizable as an electric motor.  The caption reads:
    <q>In 1959, Richard Feynman offered a prize of $1,000 to the first
    person who could build a working motor that fit into a 1/64th-inch
    cube.  William McLellan, a Caltech graduate, took the prize
    in 1960 with this motor, which is only 15 thousandths of an
    inch on a side.  (Unfortunately, the motor no longer works.)</q> "

    isListed = nil
;

+++ Thing 'various experimental bits/equipment' 'experimental equipment'
    "The equipment is all hand-built stuff from the early 20th
    century. "
    isMassNoun = true

    isListed = nil
;

+ beStairsUp: StairwayUp ->b201Stairs
    'stair stairs stairway up' 'stairs up' "The stairs lead up. "
    isPlural = true
;

+ beStairsDown: StairwayDown ->bbeStairs
    'stair stairs stairway down' 'stairs down' "The stairs lead down. "
    isPlural = true
;

/* ------------------------------------------------------------------------ */
/*
 *   201 Bridge lecture hall
 */
bridge201: Room 'Lecture Hall' '201 Bridge' 'lecture hall'
    "This is 201 Bridge, the lecture hall where the freshman physics
    class is taught.  About 250 austere wooden seats, arranged in
    steeply-raked rows, face a lab bench that runs the width of the
    room and a wall of sliding blackboards behind the bench.  The
    exit is a stairway leading down, on the south side of the room. "

    vocabWords = '201 bridge lecture hall'

    down = b201Stairs
    south asExit(down)
;

+ b201Stairs: StairwayDown 'stair stairs stairway down' 'stairs down'
    "The stairs lead down. "
    isPlural = true
;

+ Fixture, Surface 'lab laboratory bench' 'lab bench'
    "The lab bench runs the width of the room.  It serves as a
    platform for equipment used in demonstrations, and also as an
    oversized podium for the lecturer. "
;

+ Fixture 'steeply-raked austere wooden seat/seats/row/rows' 'seats'
    "The seats are unpadded wood.  They're not designed for comfort,
    perhaps a minor reflection of the overall Phys 1 <i>gestalt</i>. "
    isPlural = true

    dobjFor(SitOn)
    {
        verify() { }
        check()
        {
            "There's no lecture going on right now, and, frankly,
            standing is more comfortable. ";
            exit;
        }
    }
;

+ Fixture, Readable
    'elaborate sliding black blackboards/board/boards/panel/(wall)/(set)'
    'blackboards'
    "The wall behind the lab bench is hung with an elaborate set
    of blackboards that slide up and down on rollers, like double-hung
    windows.  After the lecturer fills up one panel, he or she can
    push it up and pull a fresh panel down to replace it. "

    readDesc = "You see a few miscellaneous differential equations and
        integrals left over from a recent lecture. "

    isPlural = true

    dobjFor(PushTravel)
    {
        verify()
        {
            /* we can only move the blackboards up and down */
            if (gAction.getDirection() not in (upDirection, downDirection))
                illogical('The blackboards only move up and down. ');
        }
        action() { "You slide the blackboards around a little for fun. "; }
    }
    dobjFor(Move)
    {
        verify() { }
        action() { "You slide the blackboards around a little for fun. "; }
    }
    dobjFor(Push) asDobjFor(Move)
    dobjFor(Pull) asDobjFor(Move)
;
++ Decoration
    'miscellaneous differential equations/integrals/formulas/formulae'
    'formulas'
    "It's hard to tell what the formulas relate to without knowing
    the context of the lecture. "
    isPlural = true
;

/* ------------------------------------------------------------------------ */
/*
 *   Bridge basement - east end
 */
bridgeBasementEast: Room 'Basement Hall' 'the basement hall' 'hallway'
    "It's just the basement, but this hallway has an almost
    oppressively subterranean feel, as though it were buried
    deep underground: the air is damp and musty, the lighting
    dim, the slightly-arched ceiling so low that you can't quite
    stand up straight.  The hall continues west, and ends to the
    east in a stairway leading up, back to the land of the
    surface dwellers.

    <.p>A door labeled 021 leads south, and another numbered
    022 leads north.  The hall continues to the west. "

    vocabWords = 'basement hall/hallway'

    south = door021
    north = door022
    up = bbeStairs
    east asExit(up)
    west = bridgeBasementWest

    roomParts = static (inherited() - defaultCeiling)
;

+ SimpleOdor
    desc = "The air here is noticeably damp and musty. "
;

+ Decoration 'low arched ceiling' 'ceiling'
    "The ceiling is slightly arched, and it's so low that you
    have to keep your head down just a bit to avoid bumping it. "
;

+ bbeStairs: StairwayUp 'stair stairs stairway up' 'stairs'
    "The stairs lead up. "
    isPlural = true
;

+ door021: AlwaysLockedDoor 'south s 021 o21 21 door*doors' 'door 021'
    "It's a wide, low door, labeled with the room number 021. "
    theName = 'door 021'
;

+ door022: LockableWithKey, Door ->blDoor
    'north n 022 o22 22 door*doors' 'door 022'
    "It's a wide, low door, marked with the room number 022. "
    theName = 'door 022'

    keyList = [labKey]

    /* the lab key is marked as such, so we should know it's the one */
    knownKeyList = [labKey]
;

/* ------------------------------------------------------------------------ */
/*
 *   Stamer's lab 
 */
basementLab: Room 'Lab 022' 'the lab' 'lab'
    "Improvised equipment is packed into this small lab, which feels
    a bit like an underground parking garage thanks to the low ceiling
    and concrete surfaces.  The room is dominated by a big steel lab
    bench roughly in the center of the lab, and pieces of equipment are
    arrayed around the bench and along the walls.  A set of shelves
    on the back wall are laden with yet more equipment. "

    vocabWords = '022 lab/laboratory'

    south = blDoor
    out asExit(south)

    /* on first arrival, finalize Belker's setting up shop at the stack */
    afterTravel(traveler, conn)
    {
        /* do the normal work first */
        inherited(traveler, conn);

        /* if this is the first time, Belker's finished setting up now */
        if (!belkerDone)
        {
            /* the movers are done - remove them and related objects */
            PresentLater.makePresentByKeyIf(MitaMovers, nil);

            /* move belker's equipment into the game */
            PresentLater.makePresentByKey('pro3000');

            /* put belker in the stack-solving state */
            frosst.setCurState(frosstSolving);

            /* set up the new xojo to appear */
            xojo2.addToAgenda(xojoIntroAgenda);

            /* belker's now done setting up */
            belkerDone = true;
        }
    }

    /* have we finished belker's setting up yet? */
    belkerDone = nil

    roomParts = static (inherited - defaultNorthWall - defaultCeiling)
;

+ Fixture 'low ceiling' 'ceiling' "The ceiling is uncomfortably low. "
;
+ Decoration 'concrete surface/surfaces' 'concrete surfaces'
    "Everything is made of concrete, making the lab feel a lot like
    a parking garage. "
    isPlural = true
;

+ blDoor: Lockable, Door 'door' 'door'
    "The door leads out to the south. "
;

+ Fixture, Surface 'big steel lab laboratory bench/table' 'lab bench'
    "The bench is ten feet on a side, so it takes up most of the
    room.  There's a lot of equipment on it, which all looks
    carefully set up for an experiment.  The main part of the
    experiment is a ring of what look like big electromagnets. "

    lookInDesc = "A lot of equipment is on the bench, looking carefully
        set up for an experiment.<.p>"
;

++ calculator: Keypad, Thing, OnOffControl, QuantumItem
    '4-function four-function pocket calculator' 'pocket calculator'
    desc()
    {
        "It's a simple four-function pocket calculator, with buttons
        for the digits, the decimal point, and the arithmetic operators
        <q>+</q>, <q>-</q>, <q>*</q>, <q>/</q>, and <q>=</q>.  There's
        also a button marked <q>C</q> for <q>clear.</q>  It's currently
        turned <<onDesc>>";

        if (isOn)
            ", and the display reads <q><tt><<curDisplay>></tt></q>";

        ". ";
    }

    /* it's a "pocket" calculator, after all */
    okayForPocket = true

    /* do we have our special programming-by-Jay yet? */
    isProgrammed = nil

    /* when first taken, make a comment about ethics */
    moveInto(obj)
    {
        /* rationalize purloining this item if this is the first time */
        if (!moved)
            extraReport('Technically, Stamer\'s note only invited you to
                help yourself to what\'s on the shelves, but you doubt anyone
                would mind if you borrowed the calculator for the day.<.p>');

        /* do the normal work */
        inherited(obj);
    }

    dobjFor(TurnOn)
    {
        action()
        {
            /* turn it on */
            makeOn(true);

            /* if we're on, reset the calculator */
            if (isOn)
            {
                /* reset the calculator */
                clearKey();

                /* 
                 *   Mention that it's on, but only as a default report.
                 *   This will suppress the report if this is an implied
                 *   action, which is what we want in this case.  If we
                 *   turned on the calculator implicitly in the course of
                 *   entering a sequence of keys, it's confusing to have
                 *   the report about the display show up, since we'll
                 *   immediately chime in with the final display after
                 *   entering the keys.  
                 */
                defaultReport('The calculator is now on.  The
                    display reads <q><tt>' + curDisplay + '</tt></q> ');

                /* if we don't have a Hovarth table yet, create one now */
                if (hovarthTab == nil)
                {
                    local e = BigNumber.getE(maxDigits);
                    local pi = BigNumber.getPi(maxDigits);
                                            
                    /* create a lookup table */
                    hovarthTab = new LookupTable(16, 32);

                    /* populate the special values */
                    hovarthTab[0.0] = new BigNumber(0, maxDigits);
                    hovarthTab[1.0] = new BigNumber(1, maxDigits);
                    hovarthTab[-1.0] = new BigNumber(-1, maxDigits);
                    hovarthTab[e] = -pi;
                    hovarthTab[-e] = pi;
                    hovarthTab[new BigNumber(infoKeys.hovarthIn, maxDigits)]
                        = new BigNumber(infoKeys.hovarthOut, maxDigits);
                }
            }
        }
    }

    /*
     *   The current mode.  The calculator can be in one of these modes:
     *   
     *   1 - digit entry mode.  Pressing a digit or the decimal point adds
     *   the digit to the display number under construction.  Pressing an
     *   operator key or the '=' key commits the number under entry to the
     *   display register, then completes the pending operation, if any.
     *   If the key is an operator, we go to mode 2; if '=', mode 3.
     *   
     *   2 - awaiting second operand.  This mode exists immediately after
     *   an operator key is pressed.  Pressing a digit key goes into digit
     *   entry mode.  Pressing an operator key replaces the pending
     *   operator with the new operator key.  Pressing the '=' key copies
     *   the first operand into the second operand and completes the
     *   pending operator, then goes to mode 3.
     *   
     *   3 - chaining calculation mode.  This mode exists after pressing
     *   the '=' button.  Pressing a digit key clears the pending operator
     *   and goes to mode 1.  Pressing an operand key copies the current
     *   display register into operand 1 and goes to mode 2.  Pressing '='
     *   copies the display register into operand 1 and repeats the last
     *   calculation, if any.
     *   
     *   4 - error mode.  This mode exists after any calculation error
     *   occurs (such as division by zero).  We display 'E' and ignore key
     *   presses except for the 'clear' key.  
     */
    curMode = 3

    /* the contents of the display */
    curDisplay = '0.'

    /* number of *digits* in the current display (not counting any '.') */
    curDisplayDigitCount()
    {
        /* 
         *   The display can only contain digits, plus zero or one decimal
         *   point, plus zero or one minus sign.  So, simply return the
         *   display length, but deduct one for the decimal point if it's
         *   present, and another one for the sign if it's present.  
         */
        return (curDisplay.length()
                - (curDisplay.find('.', 1) != nil ? 1 : 0)
                - (curDisplay.startsWith('-') ? 1 : 0));
    }

    /* is there a decimal point in the display currently? */
    curDisplayHasDecimal() { return (curDisplay.find('.', 1) != nil); }

    /* maximum number of digits in the display, and our magnitude range */
    maxDigits = 10
    maxVal =  9999999999.0
    minVal = -9999999999.0

    /*
     *   The internal registers.  dispReg is the display register; this is
     *   the internal value we are showing on the display.  firstOperand is
     *   the first operand for the next calculation, and secondOperand is
     *   the second operand.  
     */
    displayReg = static (initDisplayReg)
    firstOperand = nil
    secondOperand = nil

    /* the initial/cleared display register value */
    initDisplayReg = 0.000000000000

    /* 
     *   Pending operator.  When we press an operator key, we'll store the
     *   operator key here.  This lets us remember what operator we're
     *   supposed to perform when we finish entering the second operand
     *   and then press '=' or another operator key.  
     */
    pendingOperator = nil

    /* 
     *   when we're programmed properly, three plus's in a row kicks off
     *   the quantum Hovarth calculation 
     */
    plusCount = 0

    /*
     *   Our table of previous Hovarth results.  Whenever we hand out a
     *   Hovarth number, we'll store it here, so that if we're asked to
     *   calculate the same value again we'll give a consistent answer.
     *   Apart from the values for 0, 1, -1, e, and -e, we simply
     *   calculate large random numbers for our Hovarth numbers.  We'll
     *   initialize this the first time we turn the calculator on.  
     */
    hovarthTab = nil

    /*
     *   Apply the pending operator. 
     */
    calcPendingOperator()
    {
        local didCalc = nil;
        
        /* 
         *   if there's a pending operator, and we have both operands,
         *   carry out the operation 
         */
        if (pendingOperator != nil
            && firstOperand != nil
            && secondOperand != nil)
        {
            /* note that we're doing a calculation */
            didCalc = true;

            /* catch any errors that occur during the calculation */
            try
            {
                local a, b;
                
                /* get the two operands as BigNumbers */
                a = new BigNumber(firstOperand, maxDigits + 2);
                b = new BigNumber(secondOperand, maxDigits + 2);
                
                /* carry out the pending operator */
                switch (pendingOperator)
                {
                case '+':
                    displayReg = a + b;
                    break;
                    
                case '-':
                    displayReg = a - b;
                    break;
                    
                case '*':
                    displayReg = a * b;
                    break;
                    
                case '/':
                    displayReg = a / b;
                    break;
                }
            }
            catch (Exception exc)
            {
                /* on any error, simply go into error mode */
                curMode = 4;
            }
        }

        /* update the display to reflect the new display register */
        displayRegToDisplay();

        /* tell the caller whether or not we did a calculation */
        return didCalc;
    }

    /*
     *   Update the display to reflect the current contents of the display
     *   register. 
     */
    displayRegToDisplay()
    {
        /* if the result is outside our range, it's an error */
        if (displayReg > maxVal || displayReg < minVal)
        {
            /* we're out of range - go into error mode */
            curMode = 4;
        }

        /* if we're in error mode, simply show "E" */
        if (curMode == 4)
        {
            /* show error mode */
            curDisplay = 'E';
        }
        else
        {
            /* convert the result back to a string */
            curDisplay = displayReg.formatString(maxDigits, BignumPoint);

            /* 
             *   If it contains an exponent, it means we have a number with
             *   an absolute value so small that no significant figures
             *   will appear in the available number of digits (that is, we
             *   have a number like ".00000...").  (We know it's too small
             *   because we've already tested for the case that the
             *   magnitude is too large.)  In this case, just show the
             *   result as zero.  
             */
            if (curDisplay.find('e'))
                curDisplay = '0.';
        }
    }

    /* process the Clear key */
    clearKey()
    {
        /* reset the display to zero */
        displayReg = initDisplayReg;

        /* clear the previous operator and operands */
        firstOperand = nil;
        pendingOperator = nil;
        secondOperand = nil;
        
        /* we're now in mode 3, awaiting the start of a new calculation */
        curMode = 3;

        /* bring the display up to date with the internal status */
        displayRegToDisplay();
    }

    /* handle entry of a literal string on the calculator */
    dobjFor(EnterOn)
    {
        preCond = static (inherited + [objTurnedOn])
        verify() { }
        action()
        {
            local str;
            local gotStackNum = nil;
            
            /* remove spaces from the string */
            str = gLiteral.findReplace(' ', '', ReplaceAll, 1);

            /* ensure we have a valid string */
            if (rexMatch('[-+/*=0-9.Cc]+$', str, 1) == nil)
            {
                "The calculator only has the digit keys, the decimal
                point, the arithmetic operator keys (<q>+</q>, <q>-</q>,
                <q>*</q>, and <q>/</q>), and the <q>C</q> key. ";
                return;
            }

            /* process the string one character at a time */
            for (local i = 1, local len = str.length() ; i <= len ; ++i)
            {
                /* get the current character */
                local ch = str.substr(i, 1);

                /* 
                 *   if it's a plus, and we're programmed, check for the
                 *   special "+++" sequence 
                 */
                if (ch == '+' && isProgrammed)
                {
                    /* 
                     *   count the added plus; if it makes three, kick off
                     *   the special programming, otherwise just proceed
                     *   with the normal calculator functions 
                     */
                    if (++plusCount == 3)
                    {
                        /* 
                         *   If we're in the quantum machinery, and the
                         *   quantum machinery is on, reveal the Hovarth
                         *   number of the current display register;
                         *   otherwise, just shut off, since the odds of
                         *   randomly guessing the right result in
                         *   non-quantum mode are effectively zero. 
                         */
                        if (isIn(quantumPlatform) && quantumButton.isOn)
                        {
                            local res;

                            /*
                             *   If this is the stack input, we're about
                             *   to reveal the answer to the stack,
                             *   assuming no other operations are
                             *   attempted after this.  Make a note that
                             *   we found the stack number if so.  
                             */
                            gotStackNum = (displayReg ==
                                           new BigNumber(infoKeys.hovarthIn));
                            
                            /* 
                             *   Quantum mode - calculate the result.  If
                             *   we've already calculated a result for
                             *   this number before, use the same result
                             *   as last time, to create the impression
                             *   that we're calculating Hovarth numbers
                             *   for real by at least giving consistent
                             *   results.  Otherwise, pick a random
                             *   16-digit number.
                             */
                            if ((res = hovarthTab[displayReg]) == nil)
                            {
                                /* 
                                 *   Invent a random number.  Do this by
                                 *   stringing together maxDigits random
                                 *   digits.  If the input is an integer,
                                 *   make the result an integer;
                                 *   otherwise, put a decimal point
                                 *   somewhere randomly in the result. 
                                 */
                                for (local i = 1, res = '' ;
                                     i <= maxDigits ; ++i)
                                {
                                    /* add a random digit to the string */
                                    res += rand('0', '1', '2', '3', '4',
                                                '5', '6', '7', '8', '9');
                                }

                                /* turn it into a BigNumber */
                                res = new BigNumber(res, maxDigits);

                                /* 
                                 *   insert a decimal point randomly if
                                 *   the input wasn't an integer 
                                 */
                                if (displayReg.getFraction() != 0.0)
                                    res = res.scaleTen(-rand(maxDigits));

                                /* store the result */
                                hovarthTab[displayReg] = res;
                            }

                            /* make the result current */
                            displayReg = res;
                            displayRegToDisplay();

                            /* go to '=' mode with no prior operator */
                            curMode = 3;
                            pendingOperator = nil;
                        }
                        else
                        {
                            /* classical mode - simply go into error mode */
                            curMode = 4;
                            displayRegToDisplay();
                        }

                        /* we've fully handled this keystroke */
                        continue;
                    }
                }
                else
                {
                    /* 
                     *   it's either not a plus or we're not programmed;
                     *   in either case, reset the plus counter 
                     */
                    plusCount = 0;
                }

                /* see what we have */
                switch (ch)
                {
                case '0':
                case '1':
                case '2':
                case '3':
                case '4':
                case '5':
                case '6':
                case '7':
                case '8':
                case '9':
                case '.':
                    /* a digit key will remove the winning stack answer */
                    gotStackNum = nil;

                    /* digit or decimal point entry - check the mode */
                    switch (curMode)
                    {
                    case 1:
                        /* 
                         *   Digit entry mode - accept another digit.  
                         *   
                         *   If it's a decimal point, add it only if we
                         *   don't have a decimal point already.
                         *   
                         *   Otherwise, it's a digit, so add the digit to
                         *   the display as long as we have room.  Do not
                         *   allow more than maxDigits digits; if we go
                         *   over that limit, simply ignore additional
                         *   digits.  If there's a decimal point in the
                         *   display, don't count it against the digit
                         *   limit.  
                         */
                        if (ch == '.'
                            ? !curDisplayHasDecimal()
                            : curDisplayDigitCount() < maxDigits)
                            curDisplay += ch;

                        /* done */
                        break;

                    case 3:
                        /*
                         *   Chaining calculation mode.  Entering a new
                         *   number cancels the old calculation and starts
                         *   a new one.  Switch to digit entry mode, forget
                         *   any pending operator, clear the display, and
                         *   accept the digit.
                         *   
                         *   We observe that this is everything we do from
                         *   mode 2, plus clearing the pending operator -
                         *   so just clear the pending operator and fall
                         *   through to the mode 2 handling.  
                         */
                        pendingOperator = nil;

                        /* FALL THROUGH... */

                    case 2:
                        /* 
                         *   Awaiting second operand.  Enter a new number
                         *   goes back into digit entry mode to allow us to
                         *   obtain the second operand.  Simply switch to
                         *   digit entry mode, clear the display, and
                         *   accept the new digit 
                         */
                        curMode = 1;
                        curDisplay = ch;
                        break;
                    }
                    break;
                    
                case 'c':
                case 'C':
                    /* Clear key - set the display to zero */
                    clearKey();

                    /* this clears away the winning stack answer */
                    gotStackNum = nil;
                    break;

                case '*':
                case '/':
                case '+':
                case '-':
                case '=':
                    /* operator or '=' key - check the mode */
                    switch (curMode)
                    {
                    case 1:
                        /*
                         *   We're in digit entry mode.  Commit the current
                         *   display to the display register. 
                         */
                        displayReg = new BigNumber(curDisplay, maxDigits + 2);

                        /* 
                         *   the display register is the second operand of
                         *   any pending operator 
                         */
                        secondOperand = displayReg;

                        /* carry out any pending operator */
                        if (calcPendingOperator())
                        {
                            /* we've now removed the winning stack number */
                            gotStackNum = nil;
                        }

                        /* if that yielded an error, we're done */
                        if (curMode == 4)
                            break;

                        /* check if we have an operator or '=' */
                        if (ch == '=')
                        {
                            /* it's '=', so switch to mode 3 */
                            curMode = 3;
                        }
                        else
                        {
                            /* 
                             *   it's an operator, so this operator is now
                             *   pending - remember it 
                             */
                            pendingOperator = ch;

                            /* the display is the first operand */
                            firstOperand = displayReg;

                            /* switch to mode 2 - awaiting second operand */
                            curMode = 2;
                        }

                        /* done */
                        break;

                    case 2:
                        /*
                         *   We were awaiting a second operand.  If this is
                         *   an operator, simply replace the pending
                         *   operator with the new one.  If it's '=', carry
                         *   out the operator, repeating the first operand
                         *   as the second operand.  
                         */
                        if (ch == '=')
                        {
                            /* copy the first operand to the second */
                            secondOperand = firstOperand;

                            /* carry out the operation */
                            if (calcPendingOperator())
                                gotStackNum = nil;

                            /* 
                             *   if that didn't result in an error, switch
                             *   to mode 3, since we're done with the
                             *   calculation 
                             */
                            if (curMode != 4)
                                curMode = 3;
                        }
                        else
                        {
                            /* 
                             *   it's an operator, so it simply replaces
                             *   the current pending operator 
                             */
                            pendingOperator = ch;
                        }
                        break;

                    case 3:
                        /* 
                         *   Chained calculation mode - we're either
                         *   repeating the last calculation (with '=') or
                         *   applying a new operator to the last result.
                         *   In either case, the display register becomes
                         *   the first operand for the next calculation.  
                         */
                        firstOperand = displayReg;

                        /* check what we have next */
                        if (ch == '=')
                        {
                            /*
                             *   They simply want to chain the previous
                             *   calculation, which means that we repeat it
                             *   with the current display as the first
                             *   operand. 
                             */
                            if (calcPendingOperator())
                                gotStackNum = nil;
                        }
                        else
                        {
                            /*
                             *   They want to start a new calculation.
                             *   Remember the new operator as the pending
                             *   operator and switch to mode 2 to await the
                             *   second operand. 
                             */
                            pendingOperator = ch;
                            curMode = 2;
                        }
                        break;
                    }
                    break;
                }
            }

            /* 
             *   show the result; if we're in quantum mode, our message is
             *   special because of the quantum effects
             */
            if (isIn(quantumPlatform) && quantumButton.isOn)
            {
                "Your hand becomes slightly blurry as you reach into
                the shimmering air over the platform.  This makes it
                hard to be sure you're finding the right key<<
                  str.length() == 1 ? '' : 's'>>, but you try your best.
                You pull your hand back as soon as you're done.
                <.p>The calculator's display blurs, the digits turning
                into fuzzy blobs of light.  For that matter, the entire
                calculator seems oddly out of focus.
                <.p>The humming of the equipment starts dropping in
                pitch like a turbine winding down.  The calculator
                suddenly snaps into sharp focus, the display 
                reading <q><tt><<curDisplay>></tt></q>.  The noise of the
                equipment fades out and then stops entirely. ";

                /* this immediately turns off the equipment */
                quantumButton.isOn = nil;
            }
            else
                "You press the key<<
                  str.length() == 1 ? '' : 's in sequence'>>.
                The display now reads <q><tt><<curDisplay>></tt></q>. ";

            /* if we got the winning stack number, say so */
            if (gotStackNum)
            {
                "<.p>Assuming Jay's programming worked, that should be
                the number for the stack.  Now you just have to go enter
                it into the black box.  Fortunately, that should be
                relatively easy: earlier, when you were looking at the
                black box with the oscilloscope, you noticed that part
                of the circuit was a ten-level voltage digitizer.  That
                must be the input device.  All you need is a way to
                produce voltages in the right range, which you should be
                able to do with the signal generator.
                <.reveal hovarth-solved> ";

                /* 
                 *   make sure the signal generator is detached from the
                 *   black box and powered off - we'll give some extra
                 *   instructions on attaching it and turning it on 
                 */
                signalGen.detachFrom(blackBox);
                signalGen.makeOn(nil);

                /* score this achievement */
                scoreMarker.awardPointsOnce();
            }
        }
    }
    dobjFor(TypeLiteralOn) asDobjFor(EnterOn)

    /* an achievement for getting the Hovarth number for the stack */
    scoreMarker: Achievement { +10 "calculating the Hovarth number" }

    /* a game-clock event for solving the hovarth puzzle */
    readPlotEvent: ClockEvent { eventTime = [2, 16, 22] }
;
+++ ComponentDeferrer, Component, Readable
    'calculator display' 'calculator display'
    desc()
    {
        if (location.isOn)
            "The display currently reads
            <q><tt><<location.curDisplay>></tt></q>. ";
        else
            "The display is currently blank (probably because the
            calculator is turned off). ";
    }
;
class CalcButton: Button, Component
    'calculator key/button*keys*buttons'

    name = perInstance('calculator <q>' + calcStr + '</q> button')
    desc = "The button is marked <q><<calcStr>></q>. "

    /* the string I enter on the calculator when pushed */
    calcStr = nil

    dobjFor(Push)
    {
        preCond = [touchObj]
        verify()
        {
            /* 
             *   downgrade the likelihood, since we usually don't push
             *   these buttons individually - we'd rather pick another
             *   in-scope button if there's any ambiguity 
             */
            logicalRank(80, 'group button');
        }
        action()
        {
            /* enter my string */
            nestedAction(TypeLiteralOn, location, calcStr);

            /* 
             *   if this is the first time I've been pushed, mention that
             *   it's easier to enter whole strings 
             */
            if (CalcButton.pushCount++ == 0)
                "<.p>(Rather than pressing keys individually, you can
                simply ENTER a formula on the calculator, if you prefer.) ";
        }
    }

    /* treat ENTER the same as pressing the button */
    dobjFor(Enter) asDobjFor(Push)

    /* class variable: number of times we've pushed a button */
    pushCount = 0

    /* defer to our collective group object for some actions */
    collectiveGroups = [calcButtonGroup]
;
+++ CalcButton '"c" "clear" -' calcStr = 'c';
+++ CalcButton '"+" "plus" -' calcStr = '+';
+++ CalcButton '"-" "minus" -' calcStr = '-';
+++ CalcButton '"*" "times" -' calcStr = '*';
+++ CalcButton '"/" "divide" "divided by" -' calcStr = '/';
+++ CalcButton '"=" "equals" -' calcStr = '=';
+++ CalcButton '"." "decimal point" "point" -' calcStr = '=';

+++ CalcButton '0 -' calcStr = '0';
+++ CalcButton '1 -' calcStr = '1';
+++ CalcButton '2 -' calcStr = '2';
+++ CalcButton '3 -' calcStr = '3';
+++ CalcButton '4 -' calcStr = '4';
+++ CalcButton '5 -' calcStr = '5';
+++ CalcButton '6 -' calcStr = '6';
+++ CalcButton '7 -' calcStr = '7';
+++ CalcButton '8 -' calcStr = '8';
+++ CalcButton '9 -' calcStr = '9';

/* a collective group for the buttons */
+++ calcButtonGroup: CollectiveGroup, Component
    'calculator key/button*keys*buttons' 'calculator buttons'
    "The calculator has a button for each digit, a decimal
    point button labeled <q>.</q>, arithmetic buttons labeled
    <q>+</q>, <q>-</q>, <q>*</q>, <q>/</q>, and <q>=</q>, and
    a <q>C</q> button. "

    /* take over Examine, Push, and Enter */
    isCollectiveAction(action, whichObj)
    {
        return (action.ofKind(ExamineAction)
                || action.ofKind(PushAction)
                || action.ofKind(EnterAction));
    }

    /* take over singular and unspecified quantities */
    isCollectiveQuant(np, requiredNum) { return requiredNum is in (nil, 1); }

    /* for Push and Enter, just say they need to say which button */
    dobjFor(Push)
    {
        verify() { logicalRank(70, 'calc button entry'); }
        action() { "(If you want to use the calculator, you can just
            ENTER a formula on it.) "; }
    }
    dobjFor(Enter) asDobjFor(Push)

    /* don't allow this collective object as a default for ENTER */
    hideFromDefault(action)
    {
        /* hide from ENTER, as well as any inherited hiding */
        return action.ofKind(EnterAction) || inherited(action);
    }
;

class ExperimentPart: CustomImmovable
    cannotTakeMsg = 'You don\'t want to disturb the experiment. '
;

++ ExperimentPart 'thick black electrical cabling/cables/(cable)/wires/wire'
    'electrical cabling'
    "The cables are huge; they must have to carry a lot of current. "
;

++ quantumButton: ExperimentPart
    'big giant green mushroom electrical junction button/(box)'
    'green mushroom button'
    "It's a two-inch-diameter green mushroom button, like the big
    emergency stop buttons on industrial equipment.  It's part of
    what looks like an electrical junction box, which is tethered to
    the other equipment with one of the same thick black cables
    that connects the electromagnets together. "

    dobjFor(Push)
    {
        verify() { }
        action()
        {
            local plc;
            
            /* if I'm already on, nothing extra happens */
            if (isOn)
            {
                "The equipment keeps humming away, but nothing more
                seems to happen. ";
                return;
            }

            /* start the show */
            "You push down on the giant button.  There's an immediate
            clunk from somewhere in the room, then a deep humming
            sound that gradually rises in pitch.  The humming keeps
            rising and getting louder until it sounds like a car
            horn.
            <.p>The air over the glass platform in the center of
            the ring of magnets starts to shimmer. ";

            /* check to see if we have a special item on the dinner plate */
            if ((plc = quantumPlatform.contents).length() == 0
                || !plc[1].ofKind(QuantumItem))
            {
                /* 
                 *   There's nothing special on the plate.  To avoid
                 *   having to describe quantum effects for everything,
                 *   simply power down the machine immediately.  
                 */
                "<.p>The machinery continues to hum for a few moments,
                then the noise starts dropping in pitch like a turbine
                winding down, until it ceases completely. ";
            }
            else
            {
                /* 
                 *   we have a quantum item on the dinner plate, so we get
                 *   the full show: start up the machine, leave it running
                 *   for one turn, and set up a fuse to stop us once the
                 *   one turn is up 
                 */

                /* set up the fuse to turn us off in one turn */
                new SenseFuse(self, &turnOff, 1, self, sight);

                /* note that we're on */
                isOn = true;
            }
        }
    }

    /* fuse - turn off the machine */
    turnOff()
    {
        /* 
         *   if we haven't already turned off by virtue of having done
         *   something special to what's on the platform, show a message
         */
        if (isOn)
        {
            "<.p>The noise from the experiment's machinery starts to
            drop in pitch like a turbine winding down.  After a few
            more moments, it ceases completely. ";

            /* we're no longer on */
            isOn = nil;
        }
    }

    afterAction()
    {
        /* 
         *   if we examined something that's on the platform, and we're
         *   turned on, mention the shimmering air 
         */
        if (isOn
            && gActionIs(Examine)
            && (gDobj.isIn(quantumPlatform) || gDobj == quantumPlatform))
            "<.p>The air all around {the dobj/him} is shimmering
            strangely. ";
    }

    /* did we turn the equipment on? */
    isOn = nil
;

+++ SimpleNoise
    desc = "The experiment's machinery is humming loudly.  It sounds
        like a nearby car horn. "
        
    /* we're only here if the machine is on */
    soundPresence = (location.isOn)
;

/* 
 *   a class for an item with special quantum behavior when on the
 *   experimental platform 
 */
class QuantumItem: object;

++ ExperimentPart
    'fine metal tire-sized big experiment/(ring)/coil/coils/(wire)/
    tube/tubes/frameworks/electromagnets/magnets/machine/machinery'
    'ring of electromagnets'
    "The focus of the experiment looks to be a ring of about a dozen
    big devices that are probably electromagnets---tire-sized coils of
    fine wire wrapped around and through frameworks of metal tubes,
    with a tangle of thick black electrical cabling interconnecting
    them and the other equipment.  One of the cables leads to an
    electrical junction box with a big green mushroom button protruding.
    A glass platform that looks like a dinner plate is at the center
    of the ring. "
    
    isPlural = true

    /* 
     *   specifically show the contents of the platform as part of our
     *   Examine description - it doesn't normally show its contents as
     *   part of room or container descriptions, but we want to override
     *   that here to show the contents 
     */
    examineStatus()
    {
        /* specifically show the contents of the platform */
        "<.p>";
        quantumPlatform.examineListContents();
    }
;

+++ quantumPlatform: ExperimentPart, Surface
    'thick round clear glass dinner platform/plate/pillar' 'glass platform'
    "The platform looks to be clear glass.  It's about the size and
    shape of a dinner plate, and it's raised up a few inches above
    the surface of the bench by a thick glass pillar. "

    /* only allow one thing at a time on the platform */
    iobjFor(PutOn) { preCond { return inherited() + objEmpty; }}

    /* only allow small objects */
    maxSingleBulk = 1

    /* 
     *   don't show my contents in the room description; this is pretty
     *   deeply buried in a cluttered room, so it doesn't make sense to
     *   mention our contents until we're examined specifically 
     */
    contentsListed = nil
;

++++ QuantumItem, Thing, Container 'clear plastic dice-o-matic/dome'
    name = (described ? 'dice-o-matic' : 'clear plastic dome')
    desc = "It's a dome of clear plastic with <q>Dice-O-Matic</q>
        faintly inscribed on the top.  Inside are two six-sided
        dice.
        <.p>You can't remember which one it is, but there's a
        classic board game that came with the Dice-O-Matic.  You
        just push down on the dome, and a little spring-loaded
        mechanism in the bottom tosses the dice into the air. "

    /* we're transparent but unopenable */
    material = glass
    isOpen = nil

    /* don't show my contents in container/room listings */
    contentsListed = nil

    dobjFor(Roll) asDobjFor(Push)
    dobjFor(Push)
    {
        verify() { }
        action()
        {
            /* select new values */
            die1 = rand(6) + 1;
            die2 = rand(6) + 1;

            /* check to see if we do quantum rolling */
            if (isIn(quantumPlatform) && quantumButton.isOn)
            {
                "It's a little weird reaching into the shimmering
                air over the platform; your hand seems to become
                a bit of a blur.  You push down on the dome---you
                try to, at least; it's actually kind of hard to tell,
                with everything getting blurrier and blurrier and
                your hand tingling and feeling strangely disconnected
                from your arm.
                <.p>You snap your hand away from the Dice-O-Matic
                and see just a blur of dice inside---not the kind of
                blur you'd see if they were moving really fast, but
                the kind you see when cross-eyed, or in a photograph
                that's been exposed over and over.  You can clearly
                see dozens of different dice lying there, others
                tumbling, others bouncing, all sharing the little
                bubble and overlapping like ghosts.
                <.p>The humming of the equipment starts dropping
                in pitch like a turbine winding down, then ceases
                entirely.  The jumble of ghostly dice becomes
                two ordinary dice showing <<die1>> and <<die2>>;
                the change is sudden and undramatic, as though
                your eyes just snapped into focus. ";

                /* this immediately turns off the equipment */
                quantumButton.isOn = nil;
            }
            else
                "You push down on the dome until it clicks, then
                release.  The dice pop into the air, tumble around
                inside the dome for a moment, and land showing <<die1>>
                and <<die2>>. ";
        }
    }

    /* the numbers shown on my dice */
    die1 = 3
    die2 = 1

    /* 
     *   Do not list my contents when I'm described - we show them
     *   specifically as part of the description, and they never change,
     *   so we don't need to list them separately here.  
     */
    examineListContents() { }
;
+++++ Thing 'white six-sided pair/dice' 'dice'
    "They're white six-sided dice like you'd find packaged
    in any board game.  They're currently showing <<location.die1>>
    and <<location.die2>>. "
    isPlural = true

    /* to roll the dice, push on the dome */
    dobjFor(Roll) remapTo(Push, location)
;

++ researchReport: Readable
    'light blue stamer\'s research report 6 paper/folder/draft'
    name = (isRead ? 'research paper' : 'report folder')

    desc = "It's a light blue report folder, with <q>DRAFT 6</q>
        written across the cover.  The report within looks to
        be about thirty pages. "

    /* make an ethical comment when first taken */
    moveInto(obj)
    {
        /* rationalize it */
        if (!moved)
            extraReport('You figure no one will need this today; you\'ll
                just have to remember to return it later.<.p>');
        
        /* do the normal work */
        inherited(obj);
    }

    readDesc()
    {
        local extraRef = nil;
        
        "<q>Spin Decorrelation and Bulk Matter Decoherence
        Isolation - DRAFT.</q>  It seems to be a recent draft of
        a research paper that Stamer's lab group is working on.<.p>";

        /* check our background knowledge */
        if (gRevealed('decoherence')
            && gRevealed('spin-decorr')
            && gRevealed('QM-intro'))
        {
            /* we have the full background, so we can understand a lot */
            "Parts of the paper are well beyond your grasp of the
            subject, but all of the background reading you've done
            actually lets you follow a lot of the material.  Stamer's
            group is apparently working on a way to prevent a quantum
            system from <q>decohering,</q> not only when it comes into
            contact with its surroundings, but when parts of the system
            itself interact with one another.  According to the paper,
            they've successfully suppressed decoherence for a matter
            of seconds at a time throughout tens of grams of
            material---apparently quite stunning results in a realm
            more typically numbered in femtoseconds and picograms.
            They hope to use this to create large-scale quantum
            computers built out of ordinary components.
            <.p>At the end are some bibliographic references, including
            the <q>introductory</q> material you've already seen: ";

            /* award some points for this */
            scoreMarker.awardPointsOnce();

            /* show the extra reference */
            extraRef = true;
        }
        else if (gRevealed('decoherence')
                 || gRevealed('spin-decorr')
                 || gRevealed('QM-intro'))
        {
            /* some background - we understand a bit, but not all */
            "It helps a bit that you've been reading some background
            material; at least you know what some of the words mean
            now, and you can follow bits and pieces of the paper.  You
            can see it has a lot to do with quantum computation, but
            you still can't figure out what it all means.  You come
            again to the references at the end, and scan the ones
            called out as <q>introductory</q>: ";
        }
        else
        {
            /* we have no background - we're basically baffled */
            "You make it about halfway into the abstract before you
            realize you have no idea what it's about.  You flip through
            the paper a bit, but the only thing you really remember about
            quantum physics is some stuff about semiconductor band-gaps
            from EE 11.
            <.p>At the back are a bunch of bibliographic references that
            mostly look as intimidating as the paper itself, although a
            couple are called out as <q>introductory</q>: ";
        }

        "a paper in the journal <i>Quantum Review Letters</i> number
        70:11c, an article in <i>Science &amp; Progress</i> magazine
        number XLVI-3, and a chapter in a textbook, <i>Introductory
        Quantum Physics</i> by Bl&ouml;mner.
        <.reveal bibliography> ";

        /* show the extra reference if appropriate */
        if (extraRef)
            "<.p>You notice a reference to another article by Stamer's
            group, this one published in <i>Quantum Review Letters</i>
            number 73:9a.<.reveal understood-stamer-article> ";
    }

    /* 
     *   Reveal one of the report references, then check for comprehension.
     *   Each time we read one of the introductory references, we'll call
     *   this to check to see if we've read enough background information.
     *   If so, we'll mention specifically that we should go back and read
     *   through the report again, since doing so reveals a key clue.  
     */
    checkComprehension(topic)
    {
        /* first, reveal the topic */
        gReveal(topic);
        
        /* 
         *   Now, if all intro knowledge has been revealed, mention that we
         *   now want to go back and read the report again.  Don't do this
         *   if we've already gone back and read the report, though, for
         *   obvious reasons.  
         */
        if (gRevealed('decoherence')
            && gRevealed('spin-decorr')
            && gRevealed('QM-intro')
            && !gRevealed('understood-stamer-article'))
            "<.p>You feel like you're starting to catch on to some of
            the ideas in Stamer's research report.  You make a mental
            note to go back and read the report again in more detail,
            when you have the time. ";
    }

    /* points for understanding the paper */
    scoreMarker: Achievement { +5 "figuring out the research report" }

    /* OPEN REPORT is just like reading it, as is LOOK IN REPORT */
    dobjFor(Open) asDobjFor(Read)
    dobjFor(LookIn) asDobjFor(Read)

    /* on reading, note that we've been read */
    dobjFor(Read)
    {
        action()
        {
            inherited();
            isRead = true;
        }
    }

    isRead = nil
;

++ Decoration
    'improvised signal electronic vacuum power stepping extra
    piece/pieces/equipment/generators/oscilloscopes/meter/meters/
    instruments/pump/laser/lasers/motor/motors/supply/supplies/
    microscope/part/parts/panel/panels/innard/innards/device/devices'
    'equipment'
    "Most of the equipment around the lab is electronic---signal
    generators, oscilloscopes, various meters and instruments, power
    supplies.  There's also a vacuum pump, a couple of lasers, stepping
    motors, and a microscope.  Many of the devices look like they've
    been modified: panels are missing, exposing the innards of the
    equipment, and extra parts have been added in and clamped on. "

    isMassNoun = true
    notImportantMsg = 'You don\'t want to disturb anything, since it\'s
        probably all set up for an experiment. '

    /* 
     *   This object represents equipment all over the room, including on
     *   the shelves.  So, we're nominally in the room, on the shelves,
     *   and on the bench.  (This is important mostly because it lets the
     *   player refer to us as EQUIPMENT ON SHELVES.)  
     */
    isNominallyIn(obj) { return inherited(obj) || obj == blShelves; }
;

+ Fixture 'back north n wall*walls' 'north wall'
    "A set of metal shelves are fastened to the north wall. "
;

++ blShelves: Fixture, Surface 'metal shelf/shelves' 'shelves'
    "The metal shelves are fastened to the north wall, and run all
    the way up to the low ceiling.  Like all of the other horizontal
    surfaces in the lab, the shelves are packed with equipment. "
    isPlural = true

    /* 
     *   Use a special prefix message for listing our contents (either by
     *   EXAMINE or LOOK IN) - this lets us add the extra equipment we want
     *   to mention but which we don't really implement.  
     */
    descContentsLister: surfaceDescContentsLister {
        showListPrefixWide(itemCount, pov, parent)
            { "Among the piles of equipment, you notice "; }
    }
    lookInLister: surfaceLookInLister {
        showListPrefixWide(itemCount, pov, parent)
            { "Among the piles of equipment, you notice "; }
    }

    /* don't show our contents with the room message */
    contentsListed = nil
;

/*
 *   A mix-in class for the special equipment items on the shelf in the
 *   lab.  When we first move one of these items, we'll discover the
 *   entangled camera. 
 */
class LabShelfItem: object
    /* when we first move it, find the camera if we haven't already */
    moveInto(obj)
    {
        /* do the normal work first */
        inherited(obj);

        /* 
         *   Check for finding the camera.  Do this after we've moved the
         *   object, in case there are any side effects of moving it; the
         *   disentangling comes essentially after we've done most of the
         *   normal moving already, so it works better if this comes after
         *   any messages generated while moving the object. 
         */
        if (!spy9.isFound)
        {
            local moveObj = self;
            gMessageParams(moveObj);
            extraReport('You start to lift {the moveObj/him} off the shelf,
                but {it/he} get{s} stuck on something.  You feel around
                the sides and find some tangled cords, and finally manage
                to get {the/him} free.  As you pull {it/him} away from
                the shelf, you notice a small white ball, connected
                to a blue cable, dropping onto the shelf. <.p>');

            /* mark the camera as found, and move it here */
            spy9.isFound = true;
            spy9.makePresent();
        }
        
        /* if we've acquired all of the needed devices, award some points */
        if (!blackBox.equipHintNeeded)
            scoreMarker.awardPointsOnce();
    }

    scoreMarker: Achievement { +2 "gathering the test equipment" }
;
    

/*
 *   A class for the testing gear (oscilloscope, signal generator).  These
 *   objects can be attached to testable equipment; they have to be
 *   located right next to the equipment being tested (i.e., in the same
 *   container), which we enforce by making these NearbyAttachable
 *   objects.  
 */
class TestGear: PlugAttachable, NearbyAttachable
    /* we can attach to anything that's a test-gear-attachable object */
    canAttachTo(obj)
    {
        return obj.ofKind(TestGearAttachable) || obj.ofKind(TestGear);
    }
    explainCannotAttachTo(other)
    {
        gMessageParams(self, other);
        "{The other/he} do{es}n't seem to have any suitable
        place to connect {the self/him}. ";
    }

    /* 
     *   We can only be attached to one thing at once, so add a
     *   precondition to ATTACH TO requiring that we're not attached to
     *   anything.
     */
    dobjFor(AttachTo) { preCond = (inherited() + objNotAttached) }
    iobjFor(AttachTo) { preCond = (inherited() + objNotAttached) }

    /* for electrical safety, turn off the test equipment before unplugging */
    dobjFor(Detach) { preCond = (inherited() + objTurnedOff) }
    dobjFor(DetachFrom) { preCond = (inherited() + objTurnedOff) }
    iobjFor(DetachFrom) { preCond = (inherited() + objTurnedOff) }

    /* USE ON is the same as ATTACH TO for us */
    dobjFor(UseOn) remapTo(AttachTo, self, IndirectObject)
    iobjFor(UseOn) remapTo(AttachTo, DirectObject, self)

    /* TEST obj WITH gear is the same as ATTACH gear TO obj */
    iobjFor(TestWith) remapTo(AttachTo, self, DirectObject)

    /* 
     *   Get the equipment we're attached to.  We can only be attached to
     *   one thing at a time, other than our permanent attachments, so this
     *   returns either nil or the single piece of equipment we're probing.
     */
    getAttachedEquipment()
    {
        local lst;

        /* get the list of non-permanent attachments */
        lst = attachedObjects.subset({x: !isPermanentlyAttachedTo(x)});

        /* 
         *   there can be no more than one, so if we have anything in our
         *   list, return the first one; if not, return nil 
         */
        return (lst.length() != 0 ? lst[1] : nil);
    }

    /* show what happens when we probe with the oscilloscope */
    probeWithScope() { "The oscilloscope screen just shows a flat line. "; }

    /* show what happens we we turn on the signal generator attached here */
    turnOnSignalGen() { }
;

/*
 *   Our test gear tends to have attached connectors.  We include these for
 *   completeness; they really don't do much apart from reflect commands
 *   back to the test gear container. 
 */
class PluggableComponent: PlugAttachable, Component
    /* attaching the probe really attaches the containing test gear */
    dobjFor(AttachTo) remapTo(AttachTo, location, IndirectObject)
    iobjFor(AttachTo) remapTo(AttachTo, DirectObject, location)

    /* using the probe on something attaches it */
    dobjFor(UseOn) remapTo(UseOn, location, IndirectObject)
    iobjFor(UseOn) remapTo(UseOn, DirectObject, location)

    /* defer to the parent for status, for the attachment list */
    examineStatus() { location.examineStatus(); }
;

/* 
 *   a probe for a piece of test gear - this is a test gear component
 *   that's also a permanent attachment child 
 */
class TestGearProbe: PermanentAttachmentChild, PluggableComponent
    /* putting the probe on something is equivalent to attaching it */
    dobjFor(PutOn) remapTo(AttachTo, location, IndirectObject)
;

/*
 *   A class representing objects that can attach to the testing gear
 *   (such as the oscilloscope and the signal generator).  These are all
 *   NearbyAttachments, because the test gear has to be placed right next
 *   to them (i.e., in the same container) to be attached.  Apart from
 *   making the object attachable, this is essentially just a marker class
 *   that we recognize in the test gear, to make sure that the object is
 *   something the scope can attach to.  
 */
class TestGearAttachable: NearbyAttachable
    /* show what happens when we probe with the oscilloscope */
    probeWithScope() { "The oscilloscope screen just shows a flat line. "; }

    /* show what happens when we attach the signal generator */
    probeWithSignalGen() { }

    /* show what happens we we turn on the signal generator attached here */
    turnOnSignalGen() { }

    /* testing this kind of thing is likely */
    dobjFor(Test) { verify() { } }

    /*
     *   These objects are always the "major" items when attached to test
     *   gear: "the oscilloscope is attached to the box," not vice versa.  
     */
    isMajorItemFor(obj) { return obj.ofKind(TestGear); }
;

/* a transient object to keep track of our scope notes per session */
+++ transient oscilloscopeNoteTracker: object
    noteCount = 0
;

+++ oscilloscope: LabShelfItem, TestGear, OnOffControl
    'portable solid-state oscilloscope/scope' 'oscilloscope'
    "This is a relatively small solid-state model, easily portable.
    On the top are a display screen and the controls, and a probe
    is attached with a coaxial cable.  <<screenDesc>> "

    /* this item is a little larger than the default */
    bulk = 2

    /* make it a precondition of attaching that we're turned on */
    dobjFor(AttachTo) { preCond = (inherited() + objTurnedOn) }
    iobjFor(AttachTo) { preCond = (inherited() + objTurnedOn) }

    /* handle attaching to another object */
    handleAttach(other)
    {
        /*
         *   If they're saying something about PLUG or ATTACH, note that
         *   we can't actually attach the scope to anything, to avoid
         *   confusion.  To avoid being annoying, have this note show up
         *   only a few times each session.  
         */
        if (rexSearch('attach|plug', gAction.getOrigText()) != nil
            && oscilloscopeNoteTracker.noteCount++ < 3)
            "(Note that you can't permanently attach the scope to
            anything, since its needle tip only allows momentary
            contact with the circuit you're probing.)<.p>";
        
        /* let the other object tell us what happens */
        other.probeWithScope();

        /* 
         *   We don't actually stay attached; attaching to us is just
         *   momentary probing.  So mark us as no longer attached.
         */
        detachFrom(other);
    }

    screenDesc()
    {
        if (!isOn)
            "The scope is currently turned off. ";
        else
            "The display screen shows a flat line. ";
    }

    dobjFor(TurnOn)
    {
        action()
        {
            /* 
             *   announce this only if we're an explicit action; turning
             *   the scope on is a pretty simple action, so it's not worth
             *   a mention when it's done incidentally to another action 
             */
            if (!gAction.isImplicit)
            {
                "You turn on the oscilloscope, and it comes to life
                almost instantly. ";

                if (timesOn++ == 0)
                    "You adjust the controls a bit and get a nice
                    flat line; it looks like it's working properly,
                    at least as far as you can tell without connecting
                    it to something. ";
            }

            /* mark it as on */
            makeOn(true);
        }
    }

    /* number of times we've turned it on */
    timesOn = 0

    dobjFor(TurnOff)
    {
        action()
        {
            /* do the normal work */
            inherited();

            /* 
             *   if we're not running as an implied action, mention that
             *   the screen goes dark 
             */
            if (!gAction.isImplicit)
                "You turn off the scope, and the screen goes dark. ";
        }
    }
;
++++ Component
    '(oscilloscope) (scope) control/controls'
    'oscilloscope controls'
    "The controls let you turn the scope on and off, and make
    various adjustments to the display, such as the time and voltage
    scales and the DC offset. "

    dobjFor(Push)
    {
        verify() { }
        action() { "You don't need to make any adjustments to the
            oscilloscope settings right now. "; }
    }
    dobjFor(Pull) asDobjFor(Push)
    dobjFor(Turn) asDobjFor(Push)
    dobjFor(Move) asDobjFor(Push)
;
++++ Component
    '(oscilloscope) (scope) display screen/display' 'oscilloscope display'
    desc()
    {
        if (location.isOn)
            location.screenDesc();
        else
            "The screen is blank. ";
    }

    isOn = nil
;
++++ ComponentDeferrer, TestGearProbe
    '(oscilloscope) (scope) long metal coaxial insulated sharp pointed needle
    grip/probe/cable/pin/(tip)'
    'oscilloscope probe'
    "The probe consists of an insulated grip with a two-inch metal pin
    protruding.  The pin has a sharp, pointed tip to allow precise
    positioning when working with small circuitry.  The probe is
    attached to the oscilliscope with a coaxial cable. "
;

+++ signalGen: LabShelfItem, TestGear, OnOffControl
    'signal function generator' 'signal generator'
    "The signal generator lets you feed different waveforms into a
    circuit, to test how the circuit behaves electrically.  This is
    a compact model, the size of a hardback book.  It has a set of
    buttons on the front, an amplitude knob, and a connector. It's
    currently turned <<onDesc>>. "

    /* this item is a little larger than the default */
    bulk = 2

    probeWithScope()
    {
        if (isOn)
            "You run through a few different waveform patterns on the
            signal generator to check that they're all displayed properly
            on the scope.  Everything looks fine. ";
        else
            inherited();
    }

    handleAttach(other)
    {
        /* let the other equipment handle it */
        other.probeWithSignalGen();
    }

    killDaemon()
    {
        /* kill the data entry daemon if it's running */
        eventManager.removeMatchingEvents(blackBox, &digitEntryDaemon);
    }

    handleDetach(other)
    {
        /* on detaching, kill the data entry daemon */
        killDaemon();
    }

    dobjFor(TurnOn)
    {
        action()
        {
            local equip = getAttachedEquipment();

            /* switch it on */
            "You switch on the signal generator. ";
            makeOn(true);
            
            /* if we're attached to anything, let it know */
            if (equip != nil)
                equip.turnOnSignalGen();
        }
    }

    dobjFor(TypeLiteralOn)
    {
        verify() { logicalRank(50, 'not a keypad'); }
        action()
        {
            "The signal generator doesn't have anything like a keypad,
            but it does have a knob you can turn to different settings. ";
        }
    }
    dobjFor(EnterOn) asDobjFor(TypeLiteralOn)
    dobjFor(TypeOn) asDobjFor(TypeLiteralOn)
;
++++ signalGenKnob: NumberedDial, Component
    '(signal) (generator) amplitude knob/dial' 'amplitude knob'
    "It's a knob numbered from 0 to 9.  It adjusts the voltage level
    of the signal being generated, within the range selected by the
    current waveform parameters. It's currently set to <<curSetting>>. "
    curSetting = '3'
    minSetting = 0
    maxSetting = 9

    /* handle ENTER ON as TURN TO */
    dobjFor(EnterOn) asDobjFor(TurnTo)
;
++++ Component '(signal) (generator) button/buttons/set'
    'signal generator buttons'
    "The buttons let you select the shape of the waveform being
    generated and adjust its parameters. "

    dobjFor(Push)
    {
        verify()
        {
            /* 
             *   we never really need to push these buttons, so downgrade
             *   them in the logical rankings 
             */
            logicalRank(50, 'decoration-only');
        }
        
        action() { "There are no changes you need to make to the
            signal generator output right now. "; }
    }
;
++++ TestGearProbe
    '(signal) (generator) connector/lead/leads'
    'signal generator connector'
    "The connector is a simple set of leads connected to the
    signal generator. "
;
    
+++ spy9: PresentLater, PermanentAttachment, Immovable
    'small white plastic spy-9 camera/ball'
    name = (described ? 'SPY-9 camera' : 'small white ball')
    shortName = (described ? 'camera' : 'white plastic ball')
    desc = "It's a small white ball, about the size of a golf ball
        but made of smooth plastic.  A blue network cable comes out
        the back, and <<
          described
          ? "a tiny lens is in front.  You recognize it as a
            SPY-9 camera"
          : "there's a small clear spot in front---a lens.  You
            suddenly realize what this is: it's a SPY-9 camera"
          >>, that heinous product marketed with a ceaseless barrage
        of pop-up internet ads, designed for such virtuous uses as
        spying on your nanny, spouse, employees, boss, or the women's
        locker room. "

    /* 
     *   it's immovable, but this isn't obvious looking at it, so list it
     *   as though it were portable 
     */
    isListedInContents = true
    
    /* we haven't found it yet */
    isFound = nil

    /* we can't be moved because of the cable tethering us to the wall */
    cannotTakeMsg = 'You can\'t get {the dobj/him} free of the cable. '
    cannotMoveMsg = 'The cable doesn\'t let you move {the dobj/him} more
        than a few inches. '
    cannotPutMsg = (cannotTakeMsg)

    /* we can't detach from the cable */
    cannotDetachMsg(obj)
    {
        return 'There\'s no obvious way to disconnect the cable; it seems
            to be an integral part of ' + theNameObj + '. ';
    }

    /* pulling on the camera is just like pulling on the wire */
    dobjFor(Pull) remapTo(Pull, spy9Wire)
;
++++ Component 'clear tiny (camera) (spy-9) spot/lens/(camera)' 'spy-9 lens'
    "It's the tiny lens of the camera. "
;
++++ spy9Wire: PermanentAttachment, Immovable
    '(spy-9) (camera) blue network cable/wire/insulation' 'network cable'
    "It looks like a fairly standard blue network cable.  It seems to
    be hard-wired to the <<location.shortName>>, and at the other end
    feeds into a wall plate.  Strangely, it runs directly through the
    wall plate---there's no plug.  This cable probably runs all the way
    to the wiring closet down in the sub-basement. <<tagNote>> "

    tagNote()
    {
        /* add a note about the tag if the tag has been exposed */
        if (spy9Tag.isIn(self))
            "A bright green tag, marked with the digits
            <<infoKeys.spy9JobNumber>>, is wrapped around the wire
            near the wall plate.";
    }

    dobjFor(Pull)
    {
        verify() { }
        action()
        {
            if (bwirBlueWire.location == nil)
            {
                "You pull the wire away from the wall plate, not hard
                enough to break it but enough to take up any slack in
                the behind-the-wall wiring.  You pull it a couple of
                inches, and a little paper tag wrapped around the
                wire pops out from behind the wall plate.  You get
                a couple more inches of wire before the runs out of
                slack. ";

                /* reveal the tag */
                spy9Tag.makePresent();

                /* reveal the wire in the sub-basement */
                bwirBlueWire.makePresent();
                bwirHole.makePresent();
            }
            else
                "You give it a tug, but there's no more play in the wire. ";
        }
    }

    cannotTakeMsg = 'The cable feeds through the wall plate; there\'s no
        obvious way to remove it. '
    cannotMoveMsg = 'There\'s very little play in the cable. '
    cannotPutMsg = (cannotTakeMsg)

    attachedObjects = [spy9, spy9WallPlate]
    cannotDetachMsg(obj)
    {
        return (obj == nil
                ? 'The cable seems to be permanently attached. '
                : obj.cannotDetachMsg(self));
    }

    dobjFor(Follow)
    {
        verify() { logicalRank(50, 'not followable'); }
        action() { "You can only follow it as far as the wall plate. "; }
    }
;
+++++ spy9Tag: PresentLater, PermanentAttachment, CustomImmovable, Readable
    'bright green little small paper tag' 'paper tag'
    "The bright green tag is marked with the digits
    <<infoKeys.spy9JobNumber>>.  You can also make out faint, tiny
    type on the edge reading <q>NIC.</q>  The tag is folded over the
    wire and glued in place with a strong adhesive. "

    attachedObjects = [spy9Wire]
    cannotDetachMsg(obj) { return cannotTakeMsg; }
    cannotTakeMsg = 'The tag seems to be thoroughly stuck to the wire. '
;
    
++++ spy9WallPlate: PermanentAttachment, Fixture
    'wall plate' 'wall plate'
    "The blue cable feeds into the wall plate without any plug or
    connector.  Someone must have set this up as part of the room
    wiring for some reason---the cable must run all the way down to
    the wiring closet in the sub-basement. "

    cannotDetachMsg(obj) { return 'The cable feeds into the wall plate
        without any obvious plug, so there\'s no way to detach it. '; }

    dobjFor(LookBehind) { action() { "You can't see behind the plate
        without removing it, but there's no obvious way to do that. "; } }
;

/* ------------------------------------------------------------------------ */
/*
 *   Bridge basement hall - west end 
 */
bridgeBasementWest: Room 'Basement Hall West'
    'the west basement hallway' 'hallway'
    "The low, dimly-lit hallway ends here and continues to the east.
    On the south side of the hall is a door labeled 023, and on the
    north side another labeled 024.  At the west end of the hall,
    a very narrow, steep stairway leads down into shadow. "

    vocabWords = 'basement hall/hallway'

    east = bridgeBasementEast
    south = door023
    north = door024
    west asExit(down)
    down = bbwStair
;

+ bbwStair: StairwayDown ->bsubStair
    'very narrow steep concrete stairs/stairway/shaft' 'stairs'
    "The concrete stairway is so narrow it almost looks like it's
    descending straight down a shaft. "
    isPlural = true
;

+ SimpleOdor
    desc = "The air here is damp and musty. "
;

+ door023: AlwaysLockedDoor 'south s 023 door*doors' 'door 023'
    "It's labeled with room number 023. "
    theName = 'door 023'
;

+ door024: AlwaysLockedDoor 'north n 024 door*doors' 'door 024'
    "The door is labeled with room number 024. "
    theName = 'door 024'
;

/* ------------------------------------------------------------------------ */
/*
 *   Bridge sub-basement hall
 */
bridgeSubHall: Room 'Sub-basement Hall' 'the sub-basement hall' 'hallway'
    "The ceiling in this short hallway is too low for you to
    stand up straight, and the walls are just unpainted concrete.
    It would be too cruel to put anyone's office down here---even
    grad students---so this sub-basement is used mainly for storage
    and the building's systems.  The hall is piled with junk,
    evidently overflow from the storage rooms.  Faded lettering on
    the north door reads <q>Electro-Mechanical,</q> and the east
    and south doors are unlabeled.  To the west, a steep stairway
    leads up. "

    vocabWords = 'sub-basement subbasement hall/hallway'

    up = bsubStair
    west asExit(up)
    north = bsubNorthDoor
    east = bsubEastDoor
    south = bsubSouthDoor

    roomParts = [defaultFloor]
;

+ Fixture 'low ceiling' 'ceiling' "The ceiling is so low you can't
    stand up straight. "
;
+ Fixture 'north south east west n s e w concrete wall/walls' 'wall'
    "The walls here are unpainted concrete. "
;

+ Decoration
    'leftover construction
    materials/junk/pile/piles/sheetrock/piece/pieces/wood/pipe/pipes/lengths'
    'junk'
    "It looks like leftover construction materials, mostly: pieces of
    sheetrock and wood, lengths of pipe, that sort of thing. "
    
    isMassNoun = true

    dobjFor(Take)
    {
        verify() { }
        action() { "You take a quick look through the
            junk to see if there's anything useful you could borrow,
            but you find nothing interesting. "; }
    }
    dobjFor(Search) asDobjFor(Take)
;

+ bsubStair: StairwayUp 'very narrow steep uneven concrete stairs/stairway'
    'stairs'
    "The uneven concrete stairs lead up. "
    isPlural = true
;

+ SimpleOdor
    desc = "The air here is dry and stale. "
;

+ bsubNorthDoor: Door ->bwirDoor
    'north n electro-mechanical door' 'north door'
    "Faded lettering on the door reads <q>Electro-Mechanical.</q> "
;
++ Component 'hand-painted faded lettering' 'faded lettering'
    "<q>Electro-Mechanical.</q>  The faded lettering looks
    like it was hand-painted a long time ago. "
;

+ bsubEastDoor: Door ->bstorWestDoor 'east e door' 'east door'
    "The door is unmarked. "
;

+ bsubSouthDoor: AlwaysLockedDoor 'south s door' 'south door'
    "The door is unmarked. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Bridge sub-basement wiring closet 
 */
bridgeWiringCloset: Room 'Wiring Closet' 'the wiring closet'
    "When you were a student, you helped wire a couple of the Bridge
    labs for a primitive computer network, which involved pulling a
    bunch of garden-hose-sized cables through the walls and connecting
    them to a bank of transponder boxes in this wiring closet.  All of
    that has been long since ripped out and replaced with more modern
    phone-style wiring.
    <.p>A door leads south, out to the hall. "

    vocabWords = 'wiring closet'

    south = bwirDoor
    out asExit(south)

    roomParts = static [defaultFloor]
;

+ bwirDoor: Door 'south s door' 'door' "The door leads out to the south. "
;

+ bsubWiring: Immovable, Consultable
    'blue red white yellow orange green
    modern phone phone-style network wire/wires/wiring/mass' 'wiring'
    "There's a huge mass of wires here, mostly along the north wall,
    coming into the room through small openings in the ceiling and
    walls.  The wires are in numerous colors: blue, red, white, yellow,
    orange, green. <<
      bwirBlueWire.location != nil
      ? "One blue wire stands out, because it's been pulled tight---you
        can see it's the one you tugged on upstairs. " : "" >> "
    isMassNoun = true

    lookInDesc() { searchResponse(); }
    searchResponse()
    {
        "There are so many wires, you really don't have any chance
        of finding a specific one without something that would
        really set it apart. ";

        /* if we haven't found the blue wire yet, hint how we could */
        if (bwirBlueWire.location == nil)
            "Back when you were helping with the Bridge wiring project,
            for example, the easiest way of sorting out what went where
            was to have someone upstairs give their end of a wire a good
            tug, and see which one down here moved. ";
        else
            "You can pick out the blue wire you pulled on, though,
            since it's the one that's been pulled tight enough to
            stand out in front of the others. ";
    }
    dobjFor(Follow) asDobjFor(LookIn)
    
    dobjFor(Pull)
    {
        verify() { }
        action() { "Better not; you don't want to run the risk of
            accidentally disconnecting something. "; }
    }
    dobjFor(Move) asDobjFor(Pull)
    dobjFor(Push) asDobjFor(Pull)

    isNominallyIn(obj)
        { return isIn(obj) || obj == bwirWalls || obj == bwirOpenings; }
;

++ DefaultConsultTopic
    topicResponse = (location.searchResponse())
;

+ bwirBlueWire: PresentLater, Immovable
    'blue network pulled tight wire/cable/insulation'
    'blue cable'
    "It's a blue network cable, pulled tight so that it stands
    by itself in front of the mass of wire.
    Like many of the other wires, it threads in through an opening
    in the ceiling.  You trace the wire through the mass of
    cabling to see where it's connected, and find that it disappears
    into a tiny hole drilled in the north wall.
    <<traceIntoTunnel()>> "

    /* trace the wire into the steam tunnels */
    traceIntoTunnel()
    {
        /* if we haven't already done so, reveal the tunnel-side wiring */
        if (!traceDone)
        {
            /* move the steam tunnel wires into position */
            PresentLater.makePresentByKey('stWire');

            /* no need to do this again */
            traceDone = true;
        }
    }

    /* flag: we've traced the wire into the tunnel */
    traceDone = nil

    /* 
     *   If we find a resolve list that includes both this wire and the
     *   bunch-of-wires object, throw out the generic object, unless they
     *   don't call us the 'blue' wire.  
     */
    filterResolveList(lst, action, whichObj, np, requiredNum)
    {
        local idx;

        /* check for the generic wire object */
        if ((idx = lst.indexWhich({x: x.obj_ == bsubWiring})) != nil)
        {
            /* 
             *   if they didn't say 'blue', drop me; otherwise, drop the
             *   generic wire object 
             */
            if (np.getOrigTokenList()
                .indexWhich({x: getTokVal(x) == 'blue'}) != nil)
            {
                /* they said 'blue' - throw out the generic wiring */
                lst = lst.removeElementAt(idx);
            }
            else
            {
                /* no 'blue' - throw me out */
                idx = lst.indexWhich({x: x.obj_ == self});
                if (idx != nil)
                    lst = lst.removeElementAt(idx);
            }
        }

        /* return the new list */
        return lst;
    }

    dobjFor(Pull)
    {
        verify() { }
        action() { "Better not; you might lose it in the crowd if
            you added the slack back into it again. "; }
    }

    isNominallyIn(obj)
    {
        return isIn(obj) || obj == bwirWalls || obj == bwirOpenings
            || obj == bwirHole;
    }
;

+ bwirWalls: Fixture
    'north south east west n s e w wall/walls/ceiling' 'ceiling'
    "A lot of wires are threaded into the room through openings in
    the walls and ceiling. "
;
++ bwirOpenings: Fixture 'small openings' 'openings'
    "The openings lead into conduits running through the walls,
    providing a wiring path from labs from labs on other floors
    to this wiring closet.  All of the openings are jam-packed with wires. "
    isPlural = true

    lookInDesc = "The openings are packed with wires. "
;
++ bwirHole: PresentLater, Fixture 'small tiny drill-hole/hole' 'drill-hole'
    "It's a tiny hole drilled in the north wall, seemingly deliberately
    concealed behind the mass of wiring.  A single blue wire is
    threaded through the hole. "

    lookInDesc = "A single blue wire is threaded into the hole. "
    dobjFor(LookThrough) { action() { "The hole is too small to see
        anything on the other side. "; } }
;

/* ------------------------------------------------------------------------ */
/*
 *   Sub-basement storage room 
 */
bridgeStorage: Room 'Storage Room' 'the storage room'
    "This is a huge storage area, mostly for old furniture: the
    room is stacked with desks, file cabinets, bookcases.  Cardboard
    boxes are also piled here and there, and a bunch of scrap
    wood is leaning against the wall in the northwest corner<<
      bstorNorthDoor.isIn(self)
      ? bstorWood.pathCleared
      ? ", next to door leading north"
      : ", in front of a door leading north"
      : " of the room"
      >>.  A door leads out to the west. "

    vocabWords = 'storage room'

    west = bstorWestDoor
    out asExit(west)
;

+ bstorWestDoor: Door 'west w door' 'west door' "The door leads west. "
;

+ bstorNorthDoor: PresentLater, Door
    'north n door' 'north door' "The door leads north. "
    /* find the door */
    makeFound()
    {
        if (location == nil)
        {
            /* move me into my location */
            makePresent();

            /* set up a north travel link and a northwest alias */
            bridgeStorage.north = self;
            bridgeStorage.northwest = createUnlistedProxy();
        }
    }

    dobjFor(Open)
    {
        /* we can't open the door until the path has been cleared */
        check()
        {
            if (!bstorWood.pathCleared)
            {
                "You can't get the door open with all the sheets of
                scrap wood in the way. ";
                exit;
            }
        }
    }
;

+ bstorWood: CustomImmovable
    'large scrap bunch/piece/pieces/plywood/wood/sheet/sheets' 'scrap wood'
    desc()
    {
        "The wood looks like assorted leftovers from construction
        projects, mostly sheets of plywood around six feet by eight
        feet, leaning against the wall. ";

        if (!pathCleared)
        {
            "On closer inspection, you notice that the wood is stacked
            in front of a door leading north. ";
            bstorNorthDoor.makeFound();
        }
    }

    isMassNoun = true

    cannotTakeMsg = 'The sheets of wood are too large and heavy to
        carry; at most you could move them a few feet. '

    /* flag: a path has been cleared to the door */
    pathCleared = nil

    dobjFor(LookBehind)
    {
        action()
        {
            if (!pathCleared)
            {
                "You notice that the wood is stacked in front of a door
                leading north. ";
                bstorNorthDoor.makeFound();
            }
            else
                inherited();
        }
    }
    dobjFor(Move)
    {
        verify() { nonObvious; }
        action()
        {
            if (!pathCleared)
            {
                "You manage to shove the pile of wood a couple of
                feet over, <<
                  bstorNorthDoor.location != nil
                  ? "clearing the way to the door. "
                  : "which reveals a door leading north.
                    You move the wood far enough to clear the way to
                    the door. "
                  >>";
                
                pathCleared = true;
                bstorNorthDoor.makeFound();
            }
            else
                "There's no room to move it any further. ";
        }
    }
    dobjFor(Push) asDobjFor(Move)
    dobjFor(Pull) asDobjFor(Move)
    dobjFor(PushTravel) asDobjFor(Move)
    dobjFor(Remove) asDobjFor(Move)
;

+ Decoration
    'file furniture/desk/desks/cabinets/bookcases/pile/piles/stack/stacks'
    'furniture'
    "The furniture is stacked up two or three high in places and packed
    together without a lot of leftover space. "
    isMassNoun = true

    lookInDesc = "You look look through some of the piles, but
        it's just old furniture; you find nothing interesting. "

    dobjFor(Search) asDobjFor(LookIn)
    
    notImportantMsg = 'The furniture is all packed in tightly; it
        would take a huge effort to do anything with it. '
;

+ Decoration
    'cardboard box/boxes' 'cardboard boxes'
    "They look like they've been here quite a while.  They're all
    sealed up, and there's no indication what's inside. "
    
    isPlural = true

    lookInDesc = "They're all sealed up; you wouldn't want to disturb them. "

    dobjFor(Open) asDobjFor(LookIn)
    dobjFor(Search) asDobjFor(LookIn)
    dobjFor(Read)
    {
        verify() { }
        action() { "The boxes are unlabeled. "; }
    }

    dobjFor(Take)
    {
        verify() { }
        action() { "There are far too many boxes to carry around. "; }
    }
    dobjFor(Move)
    {
        verify() { }
        action() { "There are so many boxes that all you can do is
            shift them around a little. "; }
    }
    dobjFor(Pull) asDobjFor(Move)
    dobjFor(Push) asDobjFor(Move)
    dobjFor(PushTravel) asDobjFor(Move)
    
    notImportantMsg = 'You really shouldn\'t disturb the boxes. '
;

/* ------------------------------------------------------------------------ */
/*
 *   A class for steam tunnel locations
 */
class SteamTunnelRoom: Room
    atmosphereList: ShuffledEventList { [
        'A tapping noise echoes down one of the pipes for a few
        moments, then stops. ',
        'A deep rumbling reverberates briefly through the tunnel. ',
        'A wave of hot, dry air blows past. ',
        'One of the pipes makes a sudden loud hissing noise. ',
        'A distant rumbling, like the sound of a big truck,
        comes closer and closer until you\'re sure one of the pipes
        is about to burst, but it goes right past and fades into
        the distance. ',
        'One of the pipes vibrates visibly for a few moments. ',
        'It seems to be getting a little warmer. ',
        'A sharp clang sounds right beside you, as though someone
        smacked one of the pipes with a wrench. ',
        'Something creaks and groans overhead. ']

        eventPercent = 80
        eventReduceAfter = 5
        eventReduceTo = 60
    }

    name = 'steam tunnel'
    vocabWords = 'steam tunnel'

    /* what we see when we look behind the steam pipes */
    lookBehindPipes() { "You give the pipes a cursory examination,
        but there are a lot of them packed closely together---it'd
        be easy to miss something unless you knew exactly where
        to look. "; }
;

MultiLoc, SimpleOdor
    initialLocationClass = SteamTunnelRoom
    desc = "The air is very warm and dry, and smells of dust and metal. "
;

MultiInstance
    initialLocationClass = SteamTunnelRoom
    instanceObject: Fixture {
        'steam two-inch big huge pvc pipe/pipes/conduits/plumbing'
        'steam pipes'
        "Numerous pipes and conduits run along the walls, ranging
        from ordinary two-inch PVC plumbing like you'd find in a house,
        to huge, industrial-strength pipes two feet in diameter. "
        isPlural = true
        
        dobjFor(LookBehind)
        {
            action() { gActor.location.getOutermostRoom().lookBehindPipes(); }
        }
        dobjFor(LookUnder) asDobjFor(LookBehind)
        dobjFor(Search) asDobjFor(LookBehind)
    }
;
+ SimpleNoise
    initialLocationClass = SteamTunnelRoom
    desc = "Hissing, rumbling, and tapping noises echo intermittently
        through the pipes. "
;

MultiInstance
    initialLocationClass = SteamTunnelRoom
    instanceObject: Decoration {
        'bare low-wattage light protective wire
        lightbulb/bulb/bulbs/cage/cages'
        'light bulb'
        "The bulbs emit a feeble yellow light from within their
        protective wire cages. "

        notImportantMsg = 'The light bulbs aren\'t important (apart
            from helping you see where you\'re going, of course). '

        dobjFor(Take)
        {
            verify() { }
            action() { "How many Techers does it take to change a light
                bulb?  Now that you think about it, you've never heard
                a Caltech light bulb joke, amazingly enough.  In any case,
                these light bulbs aren't important. "; }
        }
        dobjFor(Unscrew) asDobjFor(Take)
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   Steam tunnel near storage room 
 */
steamTunnel1: SteamTunnelRoom 'Steam Tunnel at Door'
    'the steam tunnel near the door'
    "This is a section of steam tunnel running east and west past
    a door, which leads out of the tunnel to the south.  Pipes and
    conduits run along the walls, and bare, low-wattage light bulbs
    are spaced every ten feet or so along the ceiling, providing just
    enough light to see by. "

    east = steamTunnel2
    west = steamTunnel5
    south = st1Door
    out asExit(south)

    roomParts = static (inherited - defaultEastWall - defaultWestWall)
;

+ st1Door: Door ->bstorNorthDoor 'south s door' 'south door'
    "The door leads out of the tunnel to the south. "
;

+ st1Wire: PresentLater, Unthing 'blue network cable/wire' 'blue wire'
    "You don't see the wire here, but if you have your bearings correct,
    you wouldn't expect to---the wiring closet ought to be just west of
    here. "

    plKey = 'stWire'
;

/* ------------------------------------------------------------------------ */
/*
 *   narrow tunnel 
 */
steamTunnel5: SteamTunnelRoom 'Narrow Tunnel' 'the narrow tunnel'
    "The steam tunnel is quite narrow here; it widens a bit to the
    east and west.
    <<st5Hole.isIn(self)
      ? "<.p>You notice a tiny point of light in the south wall---a
        small hole, almost hidden behind one of the big steam pipes.
        You never would have noticed it, except that you have the
        sense this spot is roughly aligned with the wiring closet. "
      : ""
      >> "

    lookBehindPipes()
    {
        if (st5Hole.isIn(self))
            "You find a blue wire fastened along the back of one of the
            big pipes. ";
        else
            inherited();
    }

    east = steamTunnel1
    west = steamTunnel6
    roomParts = [defaultFloor, defaultCeiling, defaultNorthWall]
;

+ Fixture 'south s wall*walls' 'south wall'
    desc()
    {
        if (st5Hole.isIn(self))
            "You notice a small hole in the wall, admitting a little
            pinprick of light from the other side. ";
        else
            "You see nothing unusual about it, although you have the
            sense the wiring closet should be on the other side. ";
    }
;

++ st5Hole: PresentLater, Fixture
    'small tiny hole/pinpoint/(light)' 'small hole'
    "The hole is almost completely hidden behind one of the big
    steam pipes.  A blue wire comes in through the hole, and then
    snakes along the back of one of the big pipes, running down
    the tunnel to the west. "

    plKey = 'stWire'

    lookInDesc = "A single blue wire is threaded into the hole. "
    dobjFor(LookThrough) { action() { "All you can see is a pinpoint
        of light. "; } }
;

+ st5Wire: PresentLater, Immovable 'blue network cable/wire' 'blue wire'
    "The wire comes in through the small hole in the south wall,
    then snakes along the back of one of the big steam pipes,
    stretching down the tunnel to the west. "

    plKey = 'stWire'

    /* we nominally run through the hole */
    isNominallyIn(obj) { return obj == st5Hole || inherited(obj); }

    dobjFor(Follow)
    {
        verify() { }
        action() { "The wire continue down the tunnel to the west,
            and leaves the tunnel through the small hole. "; }
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   Intersection 
 */
steamTunnel6: SteamTunnelRoom 'T-Intersection' 'the T-intersection'
    "This is a T-intersection, with a north-south tunnel meeting another
    tunnel continuing east.  The pipes are arranged in an elaborate
    network of crossings, some going straight past the intersection,
    others turning the corner.
    <<st6Wire.isIn(self)
      ? "<.p>You notice a blue wire concealed behind one of the
        large-diameter steam pipes. "
      : "">> "

    lookBehindPipes()
    {
        if (st6Wire.isIn(self))
            "There's a blue wire concealed behind a large pipe.
            <<st6Wire.wireDesc>> ";
        else
            inherited();
    }

    east = steamTunnel5
    south = steamTunnel7
    north = steamTunnel13
;

+ st6Wire: PresentLater, Immovable 'blue network cable/wire' 'blue wire'
    "The wire is concealed behind the steam pipes. <<wireDesc>> "
    wireDesc = "You trace its path and find that it follows a large
        steam pipe going down the tunnel to the east, runs up another
        pipe, crosses overhead, runs down a pipe on the west side, and
        then follows a pipe down the tunnel south. "

    plKey = 'stWire'

    dobjFor(Follow) asDobjFor(Examine)
;

/* ------------------------------------------------------------------------ */
/*
 *   Musty tunnel 
 */
steamTunnel13: SteamTunnelRoom 'Musty Tunnel' 'the musty tunnel'
    "This dimly-lit section of tunnel has a slight musty
    odor.  The tunnel runs north and south from here. "

    south = steamTunnel6
    north = steamTunnel14

    roomParts = static (inherited - [defaultNorthWall, defaultSouthWall])
;

+ SimpleOdor 'musty odor/air' 'musty odor'
    "A slightly musty odor is in the air. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Corner at stairs 
 */
steamTunnel14: SteamTunnelRoom
    'Tunnel at Stairs' 'the tunnel near the stairs'
    "This is the north end of a north-south section of tunnel.
    To the east, a steep stairway leads down into a side passage. "

    south = steamTunnel13
    east = st14Stairs
    down asExit(east)

    roomParts = static (inherited - defaultSouthWall)
;

+ EntryPortal ->(location.east) 'east e narrow side passage' 'side passage'
    "A steep stairway descends into the passage. "
;

+ st14Stairs: StairwayDown ->st15Stairs
    'steep stair/stairs/stairway' 'steep stairway'
    "The stairs lead down into the east passage. "
;
    
/* ------------------------------------------------------------------------ */
/*
 *   North-south crawl
 */
steamTunnel15: SteamTunnelRoom
    'Tunnel at Crawl' 'the tunnel at the north-south crawl'
    "This is an older section of steam tunnel, running east and
    west.  The tunnel ascends a steep stairway to the west.
    <.p>Cut into the north wall is a low, narrow service tunnel;
    a pair of giant asbestos-wrapped pipes, each almost a meter
    in diameter, turn the corner into the service tunnel, leaving
    just enough space for a person to snake through by lying down
    flat on top of the steam pipe.  This is what you referred to
    as the north-south crawl in your undergraduate years: the only
    known connection between the north and south tunnel systems. "

    west = st15Stairs
    up asExit(west)
    east = steamTunnel16
    north: NoTravelMessage { "You snaked your way through the crawlway
        several times in your undergraduate years, and it was a tight
        squeeze then; you really doubt you'd fit any more. " }

    roomParts = static (inherited - [defaultEastWall, defaultWestWall,
                                     defaultNorthWall])
;

+ st15Stairs: StairwayUp 'steep stair/stairs/stairway' 'steep stairway'
    "The stairs lead up to the west. "
;

+ Fixture 'north n wall*walls' 'north wall'
    "A service tunnel, known as the north-south crawl, is cut
    into the north wall. "
;

+ EntryPortal ->(location.north)
    'narrow north-south service crawl/crawlway/tunnel'
    'north-south crawl'
    "Two large asbestos-wrapped pipes run through the tunnel,
    leaving barely enough room for a person to fit through by
    snaking one's way along the top of the pipes. "
;

+ Fixture 'giant asbestos-wrapped pipe/pipes' 'asbestos-wrapped pipes'
    "The pipes are roughly three feet in diameter.  They run through
    the service tunnel branching off to the north. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Older tunnel 
 */
steamTunnel16: SteamTunnelRoom
    'Older Tunnel' 'the older tunnel'
    "This section of tunnel runs east and west.  The tunnel looks
    especially old here.  On the south wall, next to what looks like
    a circuit-breaker box, the stenciled letters <i>DEI</i> are painted. "

    west = steamTunnel15
    east = steamTunnel9

    roomParts = static (inherited - [defaultEastWall, defaultWestWall,
                                     defaultSouthWall])
;

+ Fixture 'south s wall*walls' 'south wall'
    "The stenciled letters <i>DEI</i> are painted next to an
    electrical junction box. "

    /* read wall -> read letters */
    dobjFor(Read) remapTo(Read, dei)
;

++ dei: Fixture 'stenciled painted letters "dei" dei' 'stenciled letters'
    "<q>DEI</q> is a Techer inside joke that's so inside that no one
    even knows exactly what it means.  It's widely supposed to stand
    for <q>Dabney eats it,</q> which is widely supposed to refer to
    some food-service incident from the misty past, but there's no
    definitive record of exactly when or why or who or what. Despite
    its mysterious origins, the trigraph has long been used as a
    sort of secret handshake to covertly identify something as
    Caltech-related.  The steam tunnel DEI's come from decades ago
    when the TV show <i>Operation: Danger</i> filmed an episode down
    here, and some students took the opportunity to sneak the insignia
    into the show. "
    
    isPlural = true
;
+ Fixture 'circuit breaker electrical junction (dei) ("dei") box'
    'electrical box'
    "It's an electrical junction box of some kind. "

    /* read wall -> read letters */
    dobjFor(Read) remapTo(Read, dei)

    dobjFor(Open)
    {
        verify() { }
        action() { "There's no obvious way to open the box, at least
            without special tools. "; }
    }
    dobjFor(LookIn)
    {
        preCond = [objOpen]
        verify() { }
    }
    isOpen = nil
;


/* ------------------------------------------------------------------------ */
/*
 *   Wide tunnel 
 */
steamTunnel7: SteamTunnelRoom 'Dim Tunnel' 'the dim tunnel'
    "The lights must be spaced out a little more widely than usual
    here, because this section of north-south tunnel seems especially
    dark.
    <<st7Crawl.isIn(self)
      ? "In the shadows, low on the west wall, an opening is just
        barely visible. " : "">>
    <<st7Wire.isIn(self)
      ? "You can make out a blue wire concealed behind one of the
        large pipes. " : "">> "

    lookBehindPipes()
    {
        if (st7Wire.isIn(self))
        {
            "You find a blue wire concealed behind one of the
            large steam pipes. ";
            st7Wire.descWire;
        }
        else
            inherited();
    }

    north = steamTunnel6
    west = (st7Crawl.isIn(self) ? st7Crawl : inherited)
    south = steamTunnel12

    roomParts = [defaultFloor, defaultCeiling, defaultEastWall]
;

+ st7Wire: PresentLater, Immovable 'blue network cable/wire' 'blue wire'
    "The wire is concealed behind one of the large pipes. <<descWire>> "
    descWire = "It follows the pipe to the north<<revealCrawl>> "
    revealCrawl()
    {
        if (!st7Crawl.isIn(location))
        {
            ", but it seems to disappear to the south.  You trace it
            carefully, and discover that it goes into an opening low
            in the west wall.  The opening is well concealed in
            shadows under the pipes; you wouldn't even have seen it
            if you hadn't been following the wire. ";

            st7Crawl.makePresent();
        }
        else
            ", and goes into an opening low in the west wall. ";
    }
    dobjFor(Follow) asDobjFor(Examine)

    plKey = 'stWire'
;

+ Fixture 'west w wall*walls' 'west wall'
    desc()
    {
        if (st7Crawl.isIn(self))
            "An opening is just barely visible low on the wall. ";
        else
            "You see nothing unusual about it. ";
    }
;

++ st7Crawl: PresentLater, TravelWithMessage, ThroughPassage ->st8Crawl
    'dark opening/crawlspace' 'opening'
    "The opening is well concealed in shadows under the steam pipes.
    It must have been intended to accommodate a couple of the large
    pipes, but it looks like it's empty right now except for the blue
    wire, so there might be enough space for you to squeeze through. "

    travelDesc = "You crouch down on the floor and crawl into the
        opening head-first.  It's an uncomfortably tight squeeze,
        but you manage to work your way through the eight feet or so
        of the passage, finally emerging into another tunnel. "

    /* treat LOOK IN the same as EXAMINE */
    dobjFor(LookIn) asDobjFor(Examine)
;

/* ------------------------------------------------------------------------ */
/*
 *   Tunnel at door
 */
steamTunnel12: SteamTunnelRoom 'Tunnel at Door' 'the tunnel near the door'
    "This section of tunnel ends to the south at a wide metal door
    marked <q>Steam Plant.</q>  The tunnel continues to the north. "

    north = steamTunnel7
    south = st12Door
    
    roomParts = static (inherited - defaultNorthWall)
;

+ st12Door: AlwaysLockedDoor 'wide metal steam plant door' 'metal door'
    "It's a wide metal door marked <q>Steam Plant.</q> "
;

/* ------------------------------------------------------------------------ */
/*
 *   Sloping tunnel 
 */
steamTunnel2: SteamTunnelRoom 'Sloping Tunnel' 'the sloping tunnel'
    "This section of tunnel runs east and west, sloping sharply down
    to the east.  The steam pipes follow the slope of the tunnel. "

    west = steamTunnel1
    up asExit(west)
    east = steamTunnel3
    down asExit(east)

    roomParts = static (inherited - defaultEastWall - defaultWestWall)
;

/* ------------------------------------------------------------------------ */
/*
 *   Tunnel corner 
 */
steamTunnel3: SteamTunnelRoom 'Bend in Tunnel'
    'the bend in the tunnel'
    "The steam tunnel turns a corner here, continuing to the north
    and to the west.  The pipes and conduits running in from each
    branch of the tunnel intersect, some making the turn and others
    continuing straight on through the walls. "

    north = steamTunnel4
    west = steamTunnel2
;

/* ------------------------------------------------------------------------ */
/*
 *   Tunnel T
 */
steamTunnel4: SteamTunnelRoom 'T-Intersection' 'the T-intersection'
    "Two steam tunnels meet here, forming a <font face='tads-sans'>T</font>:
    one tunnel runs north and south, and another tunnel continues off to
    the east. "

    north = steamTunnel9
    south = steamTunnel3
    east = steamTunnel10

    roomParts = static (inherited - defaultSouthWall - defaultNorthWall)
;

/* ------------------------------------------------------------------------ */
/*
 *   Dead end 
 */
steamTunnel9: SteamTunnelRoom 'Tunnel Corner' 'the corner in the tunnel'
    "The steam tunnel turns a corner here, one branch running
    south, the other running west. "

    south = steamTunnel4
    west = steamTunnel16

    roomParts = static (inherited - [defaultSouthWall, defaultWestWall])
;

/* ------------------------------------------------------------------------ */
/*
 *   Under quad manhole
 */
steamTunnel10: SteamTunnelRoom 'Bottom of Shaft' 'the bottom of the shaft'
    "A column of sunlight spills in from a shaft above, piercing
    the gloom of the tunnel.  A ladder built into the wall ascends
    into the shaft.  The tunnel continues west, and descends a
    few concrete steps to the east. "

    west = steamTunnel4
    east = st10Stairs
    down asExit(east)
    up = st10Ladder

    roomParts = [defaultFloor, defaultNorthWall, defaultSouthWall]

    afterTravel(trav, conn)
    {
        /* do the normal work */
        inherited(trav, conn);

        /* 
         *   if the PC is coming into the room, and plisnik isn't here,
         *   and we haven't talked to the workers above yet, have them ask
         *   if everything's okay 
         */
        if (trav == me
            && !plisnik.isIn(self)
            && !gRevealed('plisnik-checked'))
        {
            /* make sure the workers are here, and have them call down */
            st10QuadWorkers.makePresent();
            st10QuadWorkers.initiateConversation(nil, 'plisnik-check');
        }
    }
;

+ st10Stairs: StairwayDown ->st11Stairs
    'short concrete step/steps/stair/stairs/stairway' 'concrete stairs'
    "The stairway leads a few steps down to the east. "
;

+ Vaporous 'column/sunlight/light' 'column of sunlight'
    "The sunlight spills into the tunnel from the opening at
    the top of the shaft above. "
;

+ Fixture 'tunnel ceiling' 'ceiling'
    "A shaft above the tunnel leads up to the surface. "
;

+ workOrders: Readable, Consultable
    'work order overstuffed three-ring thick brown binder/form/forms'
    'three-ring binder'
    "It's a brown three-ring binder, bulging with papers. "

    /* 
     *   this is the kind of thing that takes some effort to read as
     *   opposed to just looking at it, so we have a separate read desc 
     */
    readDesc = "The binder is stuffed with paper.  Flipping through,
        it seems to be a collection of official Network Installer
        Company <q>Work Order</q> forms.  You sample a few at random,
        and find they're all pretty much the same: install network
        port wiring for office X in building Y.  These guys must have
        a contract to rewire the whole campus, from the looks of it.
        The forms seem to be sorted in order of the Job Number stamped
        at the top of each form, so it'd be easy to look up a specific
        one given the number. "
    
    topicNotFound()
    {
        local jobnum = gTopic.getTopicText();
        
        if (rexMatch('(job<space>+)?(number<space>+)?[0-9]{4}-[0-9]{4}$',
                     jobnum) != jobnum.length())
        {
            /* it's not even the right format */
            "You don't see any job numbers like that; they all seem
            to be in the format 1234-5678. ";
        }
        else
        {
            /* pull out the job number from the string */
            rexMatch('.*([0-9]{4}-[0-9]{4}$', jobnum);
            jobnum = rexGroup(1)[3];

            /* 
             *   The format's right: with a 33% chance, if we haven't
             *   filled out the three random responses yet, pick one and
             *   fill it out.  The extra random responses don't tell us
             *   anything; they're just there for fun, so that we actually
             *   get non-trivial responses for trying random numbers.
             *   However, if we've previously claimed this number doesn't
             *   exist, then we want to claim this again.  
             */
            if (randomJob3.jobNumber == nil && !jobNotFound[jobnum])
            {
                /* only do this with a 33% chance */
                if (rand(100) < 33)
                {
                    local t;

                    /* find the first available random job entry */
                    t = [randomJob1, randomJob2, randomJob3]
                        .valWhich({x: x.jobNumber == nil});

                    /* set the topic's job number to what we looked up */
                    t.setJobNumber(jobnum);

                    /* show the response */
                    t.handleTopic(gActor, gTopic);

                    /* we've handled it */
                    return;
                }

                /* 
                 *   we're electing not to find it even though we could,
                 *   so for consistency, enter it in our table of jobs we
                 *   can never find 
                 */
                jobNotFound[jobnum] = true;
            }

            /* it's a valid number, but it's not there... */
            "There doesn't seem to be a work order form with
            that number. ";
        }
    }

    /* 
     *   a table of job numbers we've claimed do not exist - we keep this
     *   table to ensure that we don't later change our minds and decide
     *   to allow the job number as part of our random job responses 
     */
    jobNotFound = static new LookupTable(16, 16)

    /* 
     *   we're initially described with the spools of wire, so don't list
     *   me separately if we haven't been moved yet 
     */
    isListed = (moved)
    spoolDesc()
    {
        /* if we haven't been moved yet, add our description to the spools */
        if (!moved)
            "An overstuffed three-ring binder is on the floor next
            to the spools. ";
    }

    /* OPEN and LOOK IN are the same as READ for this */
    dobjFor(Open) asDobjFor(Read)
    dobjFor(LookIn) asDobjFor(Read)

    dobjFor(Read)
    {
        /* 
         *   this is the sort of big, heavy book one has to be holding in
         *   order to read 
         */
        preCond = (inherited() + objHeld)

        /* the first time we read it, the instruction sheet falls out */
        action()
        {
            /* if we haven't found the instruction sheet yet, find it now */
            if (!foundSheet)
            {
                local dest, nomDest;
                
                /* 
                 *   get the actor's "drop destination," which is where
                 *   things land when the actor drops them right now, and
                 *   the "nominal" drop destination, which is where we
                 *   *say* things land 
                 */
                dest = gActor.getDropDestination(netAnInstructions, nil);
                nomDest = dest.getNominalDropDestination();
                
                /* mention that the sheet falls out of the binder */
                "As you open the binder, a dingy sheet of paper falls
                out and flutters <<nomDest.putInName()>>.<.p>";

                /* move the instruction sheet to the drop destination */
                netAnInstructions.moveInto(dest);

                /* note that we've found it */
                foundSheet = true;
            }

            /* do the normal work */
            inherited();
        }
    }

    /* as with reading, consulting requires holding the binder */
    dobjFor(ConsultAbout) { preCond = (inherited() + objHeld); }

    /* flag: we've found the instruction sheet */
    foundSheet = nil
        
;

class JobOrderTopic: ConsultTopic
    topicResponse = "You scan through the binder and find a page
        with that job number:
        <.p><.blockquote><tt><i><b>ATTENTION</b>: All IP address
        assignments <b>MUST</b> be made through the Campus Network
        Office (Jorgensen Lab).  Report <b>ALL</b> IP changes to the
        CNO.</i>
        <.p>Job desc: <<jobDesc>>
        <br><br>Special notes: <<jobNotes>></tt><./blockquote>
        <<jobExtra>> "

    jobNumber = nil

    /* on setting the job number dynamically, rebuild the match pattern */
    setJobNumber(num)
    {
        /* remember the new job number */
        jobNumber = num;

        /* build the new match pattern */
        matchPattern = buildMatchPattern();
    }

    /* 
     *   build the match pattern as "job number xxx", with "job" and
     *   "number" being optional 
     */
    matchPattern = perInstance(buildMatchPattern())
    buildMatchPattern()
    {
        return (jobNumber == nil
                ? nil
                : new RexPattern(
                    '(job<space>+)?(number<space>+)?' + jobNumber + '$'));
    }
;

/* 
 *   Set up three topics for random things we look up, to surprise the
 *   user with actual results for looking up random numbers.  These don't
 *   tell us anything useful - they're just here for fun, to surprise the
 *   player with non-trivial feedback for trying random numbers.
 *   
 *   These don't have any match pattern initially.  When we decide to use
 *   one, we'll assign whatever number the player typed in as the match
 *   pattern, ensuring that they'll get the same response if they ask
 *   about the same number again.  
 */
++ randomJob1: JobOrderTopic
    jobDesc = "Install new Gb FO connection in Athenaeum, room 271.
        Std FO cabling.  Std wall plate parts."
    jobNotes = "Do not drill in N wall w/o checking studs."
;
++ randomJob2: JobOrderTopic
    jobDesc = "Repair 100TX wiring, Bridge Lab, room 023."
    jobNotes = "No voltage. Checked wall wiring 4/17, bad conn
        prob.\ in s/b wiring closet."
;
++ randomJob3: JobOrderTopic
    jobDesc = "Add 2 new ports, Steele 237. Std cat5e cabling.
        Std wall plate parts."
    jobNotes = "Need conduit if possible."
;
++ JobOrderTopic
    jobNumber = static (infoKeys.spy9JobNumber)
    jobDesc = "Install SPY-9 in Bridge Lab, room 022.  Std cat5
        cabling.  Std cam wiring profile - pull via s/b wiring
        closet, tunnel 7g, term at router S-24."
    jobNotes = "NITE CREW ONLY.  Position cam for clear view of
        main bench area.  REF <<infoKeys.spy9IPJobNumber>>."
;
++ JobOrderTopic
    jobNumber = static (infoKeys.spy9IPJobNumber)
    jobDesc = "Need static IP address for SPY-9."
    jobExtra = "<.p>Below this are big hand-written numbers:
        <<infoKeys.spy9IPDec>>.<.reveal spy9-ip> "
;
++ JobOrderTopic
    jobNumber = static (infoKeys.syncJobNumber)
    jobDesc = "Install new network port, Sync Lab Office (2nd floor)."
    jobNotes = "Door combo is <<infoKeys.syncLabCombo>>."

    topicResponse()
    {
        /* show the description */
        inherited();

        /* award our points */
        scoreMarker.awardPointsOnce();
    }

    scoreMarker: Achievement { +10 "finding out about the Sync Lab Office" }
;

+ st10Ladder: StairwayUp 'iron ladder/rung/rungs' 'ladder'
    "The ladder consists of a series of iron rungs embedded in the
    wall.  It goes up the wall into the tunnel. "

    dobjFor(TravelVia)
    {
        action()
        {
            "You climb the ladder, emerging into the sunlight on
            the Quad.  Just as you get to the top of the ladder,
            two big guys in bright green jumpsuits grab you by
            the arms and lift you out of the shaft.
            <.p><q>What the heck do you think you're doing down
            there?</q> one of the bearded workers asks.  They
            hustle you past the yellow tape they've set up around
            the shaft and give you a shove.
            <.p><q>I'm sick of you people getting in our way all
            the time,</q> the worker says, jabbing his index finger
            at you.  <q>You're lucky I don't call the cops.</q>  He
            stomps back to the edge of the shaft. ";

            /* off to the quad */
            gActor.travelTo(quad, self, nil);
        }
    }
;

+ st10Spools: CustomImmovable
    'big phone network wooden spool/spools/wire/(pile)/(piles)'
    'spools of wire'
    "They're two-foot-diameter wooden spools wound with wire,
    which looks like some kind of phone or network wire. "

    specialDesc = "Several big wooden spools of wire are piled up
        along the tunnel wall. <<workOrders.spoolDesc>> "

    isPlural = true

    cannotTakeMsg = 'The spools of wire are big and heavy, and you\'d
        rather not waste a lot effort moving them around. '
;

+ OutOfReach, Fixture 'shaft/top/opening' 'shaft'
    "It's a rectangular shaft that rises from the ceiling of
    the tunnel to the surface above.  The shaft is open at
    the top.  A ladder built into the wall ascends into the shaft. "

    dobjFor(Enter) remapTo(ClimbUp, st10Ladder)
    dobjFor(Board) remapTo(ClimbUp, st10Ladder)
    dobjFor(GoThrough) remapTo(ClimbUp, st10Ladder)
    dobjFor(ClimbUp) remapTo(ClimbUp, st10Ladder)
    dobjFor(Climb) remapTo(ClimbUp, st10Ladder)

    dobjFor(LookThrough) { action() { "You can't see anything beyond
        the shaft except sunlight. "; } }
    dobjFor(LookIn) asDobjFor(LookThrough)

    cannotReachFromOutsideMsg(dest) { return 'You can\'t quite reach
        the shaft from here. '; }
;

/* 
 *   The quad workers above, as seen from the bottom of the shaft.  We're
 *   not even here initially - we don't show up until we make some mention
 *   of the workers above.  
 */
++ st10QuadWorkers: PresentLater, Actor
    'big heavy unruly workers/man/men/beard/beards' 'workers'
    "You can't see them from here; the only thing you see through the
    shaft is sunlight. "

    isPlural = true

    /* they're not in sight, so we don't need to mention them */
    specialDesc = ""

    /* as these guys are out of view, downgrade conversational actions */
    dobjFor(AskAbout)
        { verify() { logicalRank(70, 'out of view'); inherited(); } }
    dobjFor(TellAbout)
        { verify() { logicalRank(70, 'out of view'); inherited(); } }
    iobjFor(ShowTo)
        { verify() { logicalRank(70, 'out of view'); inherited(); } }
    iobjFor(GiveTo)
        { verify() { logicalRank(70, 'out of view'); inherited(); } }
;

/* we don't want to allow talking to them while Plisnik is here */
+++ TopicGroup
    isActive = (plisnik.inOrigLocation)
;
++++ DefaultAnyTopic, ShuffledEventList
    ['<q>Hey, Plisnik,</q> one of the workers above calls down,
    <q>you got someone down there with you?  Better make sure it\'s
    not a giant talking rat!  Har! Har!</q> ',

     '<q>Shut up, Plisnik,</q> one of the workers calls down,
     <q>we\'re on break!</q> ',

     '<q>Who\'s down there with you, Plisnik?</q> one of the
     workers above calls down. <q>Tell whoever it is to get lost!
     You got work to do.</q> ']
;

/*
 *   Have the workers check on the commotion in the tunnels after Plisnik
 *   leaves.  The purpose of this brief conversation is to ensure that the
 *   player realizes that it's possible to talk to the workers through the
 *   shaft, since we have to talk to them to solve the network analyzer
 *   puzzle.  
 */
+++ ConvNode 'plisnik-check'
    npcGreetingMsg = "<.p>You hear a worker above call down. <q>Hey,
        Plisnik, what\'s going on down there?</q>  His voice becomes
        taunting. <q>You see a rat or something?</q> He chuckles. "
;
++++ YesTopic
    "<q>Yeah, a big, ugly one, but he's gone now,</q> you say, hoping
    they don't notice it's not Plisnik's voice.  You hear the workers
    above laugh and laugh.
    <.reveal plisnik-checked> "
;
++++ NoTopic
    "<q>No, no problem down here,</q> you say.
    <.p><q>Hey,</q> one of them calls down, <q>I think I see one
    now!</q>  You can hear the two of them laugh and laugh.
    <.reveal plisnik-checked> "
;

/* once plisnik is gone, the conversation changes a bit.. */
+++ TopicGroup
    isActive = (!plisnik.inOrigLocation)
;
++++ AskTellAboutForTopic @quadAnalyzer
    topicResponse()
    {
        "<q>Hey, can you hand down the Netbisco?</q> you call up
        to the workers above.
        <.p>One of them reaches down into the shaft, lowering the
        network box.  <q>Watch out, Plisnik,</q> he says. <q>I think
        I saw a rat inside it earlier.  Har! Har!</q> ";

        /* 
         *   Get rid of the fake analyzer on the quad, move the real
         *   analyzer into our location, then take it.  Note that we
         *   interrupt the dialog to take the analyzer so that any
         *   implicit action (such as hands-freeing bag-of-holding
         *   insertions) will be described just before our 'take'
         *   description below, rather than after the entire message.  
         */
        quadAnalyzer.moveInto(nil);
        netAnalyzer.moveInto(steamTunnel10);
        nestedAction(Take, netAnalyzer);

        /* and now we can mention that we took it, assuming we did */
        if (netAnalyzer.isIn(me))
            "You reach up and take it from him, being careful to stay
            in shadow. ";

        /* this is worth some points */
        scoreMarker.awardPointsOnce();

        /* make the new, real analyzer 'it' */
        me.setPronounObj(netAnalyzer);
    }

    scoreMarker: Achievement { +10 "obtaining the Netbisco 9099"; }
;
+++++ AltTopic
    "<q>Hey, guys, how do I work the Netbisco?</q> you say.
    <.p><q>Working that thing's your job, Plisnik,</q> one of the
    workers calls down. "

    /* this topic takes over once we get the analyzer */
    isActive = (quadAnalyzer.location == nil)
;

++++ AskTellTopic @supplyRoomTopic
    "<q>Hey,</q> you call to the workers above, <q>what's the
    combo to the supply room?</q>
    <.p><q>How should I know?</q> one of the workers shouts.
    <q>You're the one who works down in the tunnels.</q> "
;

++++ AskForTopic @st10Spools
    "You call up to the workers above. <q>Could you guys hand down
    some more wire?</q>
    <.p><q>What do I look like, a delivery man?</q> shouts one of
    the workers. <q>You got tons of wire down there already.</q> "
;

++++ DefaultAnyTopic
    "<q>You sound funny, Plisnik,</q> one of the workers shouts
    down the shaft. <q>That rat must have scared you good.</q> "
;

+ plisnik: IntroPerson
    'nervous-looking jittery pale gaunt stringy
    worker/man/beard/plisnik*men'
    'worker'
    "He's a pale, gaunt, nervous-looking man with a stringy beard.
    He's wearing the same sort of green overalls and hardhat as the
    workers you saw on the Quad. "

    isHim = true

    properName = 'Plisnik'
    specialDescName = (introduced
                       ? properName
                       : 'a heavy, bearded man in green overalls')

    /* am I in my original location? */
    inOrigLocation = (isIn(steamTunnel10))

    /* 
     *   use a global parameter name, so we can use {plisnik} in messages
     *   to refer to our current name, which depends on whether we've been
     *   introduced or not 
     */
    globalParamName = 'plisnik'

    beforeAction()
    {
        /* do the normal work */
        inherited();

        /* if they're trying to get my binder or spools, don't let them */
        if (gActionIs(Take) && gDobj is in(st10Spools, workOrders))
        {
            "<q>Hey,</q> {the plisnik/he} shouts, standing in your
            way, <q>that's my stuff!</q> ";
            exit;
        }
    }

    afterTravel(traveler, connector)
    {
        /* do the normal work */
        inherited(traveler, connector);

        /* if the PC just showed up, kick off our conversation */
        if (traveler == me)
            initiateConversation(plisnikTalking,
                                 introduced
                                 ? 'plisnik-rat' : 'plisnik-intro');
    }

    /* the toy car+rat combo will call this when it comes into our presence */
    eekARat()
    {
        "<.p>You hear girlish shrieking from nearby, then {a plisnik/he}
        comes running down the tunnel in a panic.  He practically
        crashes into you, but stops and grabs you by the arms.
        <q>Rat!</q> he shouts at you. <q>Huge, ugly, mean!
        It's not safe down here!</q>  He lets you go and continues
        running, disappearing down the tunnel. ";

        /* make this the current 'him', since we're mentioned prominently */
        me.setPronounObj(self);

        /* track our departure for "follow", but then disappear */
        trackAndDisappear(self, location.south);
    }

    /* receive notification that the toy car is leaving under its own power */
    ratLeaving()
    {
        "<.p>{The plisnik/he} watches the rat leave. <q>Your pet rat
        just left!</q> he says, sounding a little frantic.  <q>You'd
        better go catch him before he gets away.</q> ";
    }

    /* receive notification that the rat is moving around locally */
    ratMoving() { ratMovingScript.doScript(); }
    ratMovingScript: StopEventList { [
        '<.p>{The plisnik/he} shrinks back a little, being careful
        to keep his distance from the rat. <q>You shouldn\'t let your
        pet rat wander around down here without a leash on,</q> he
        says.  <q>It\'s a good thing I saw you come in carrying him.
        I don\'t know what I would have done if that were a <i>wild</i>
        rat.</q> ',

        '<.p>{The plisnik/he} watches nervously as the rat toy
        moves around. <q>I wish you\'d get that thing out of here,</q>
        he says. <q>Even if he is a pet, I still don\'t trust rats.</q> ',

        '<.p>{The plisnik/he} watches the rat toy nervously.  <q>I wish
        you\'d get that rat out of here,</q> he says. ']
    }

    /* get hit with a thrown object */
    throwTargetHitWith(projectile, path)
    {
        if (projectile == ratPuppet)
        {
            /* move the rat to the floor here */
            ratPuppet.moveInto(location);

            /* show our special message */
            ratScript.doScript();
        }
        else
            inherited(projectile, path);
    }

    ratScript: StopEventList { [
        'The rat puppet hits {the plisnik/him} and falls to the
        floor.  He sees what it is and shrinks back in horror,
        but only for a moment; his expression turns suspicious,
        and he goes in for a closer look.  <q>That\'s not very
        nice,</q> he says, <q>throwing a fake rat at someone.  Rats
        are no joking matter.</q> ',

        'The rat puppet hits {the plisnik/him} and falls to the
        floor.  He\'s startled, but only for a moment.  <q>I didn\'t
        think it was very funny the first time,</q> he says. ']
    }
;
++ InitiallyWorn 'bright green hard overalls/hardhat/uniform/hat'
    'uniform'
    "His bright green overalls and matching hardhat are marked
    <q>Network Installer Company</q> in blocky white letters.
    <.reveal NIC> "
    isListedInInventory = nil
;

/* since we mention his hand... */
++ DisambigDeferrer, Decoration
    'his plisnik\'s man\'s worker\'s hand/hands' 'his hand'
    "There's nothing remarkable about his hands. "
    isQualifiedName = true

    /* never confuse this with the PC's hands */
    disambigDeferTo = [myHands]
;

++ plisnikTalking: InConversationState
    specialDesc = "\^<<getActor().specialDescName>> is standing
        here watching you warily. "

    /* infinite timeout - he never stops talking to us while we're here */
    attentionSpan = nil
;
+++ ConversationReadyState
    isInitState = true
    specialDesc = "\^<<getActor().specialDescName>> is doing some kind
        of work on the wiring in the tunnel. "
;
    
++ ConvNode 'plisnik-intro'
    npcGreetingMsg = "<.p>\^<<getActor().theName>> abruptly drops
        what he's doing and turns to face you, taking a step back.
        <q>Who are you?</q> he asks. "
;
+++ SpecialTopic 'ask who he is'
    ['ask', 'the', 'man', 'him', 'who', 'he', 'is', 'are', 'you']
    "<q>Who are you?</q> you ask right back.
    <.p>He squints and eyes you suspiciously. <q>I'm Plisnik,</q>
    he says. <q>You haven't seen any rats down here, have you?</q>
    <<getActor().setIntroduced()>>
    <.convnode plisnik-rat> "
;
+++ HelloTopic
    topicResponse() { replaceAction(TellAbout, plisnik, me); }
;
+++ SpecialTopic 'introduce yourself'
    ['introduce','myself','me','you','yourself']
    topicResponse() { replaceAction(TellAbout, plisnik, me); }
;
+++ GiveShowTopic [alumniID, driverLicense]
    topicResponse() { replaceAction(TellAbout, plisnik, me); }
;
+++ TellTopic @me
    "<q>I'm Doug,</q> you say.
    <.p>He eyes you suspiciously. <q>I'm Plisnik,</q> he says
    at last. <q>You haven't seen any rats  down here, have you?</q>
    <<getActor().setIntroduced()>>
    <.convnode plisnik-rat> "
;
+++ DefaultAnyTopic
    "<q>I want to know who you are first,</q> he says nervously.
    <.convstay> "

    /* let the rat puppet through to the enclosing topic database */
    excludeMatch = [ratPuppet]
;

++ ConvNode 'plisnik-rat'
    npcGreetingMsg = "<.p>Plisnik drops what he's doing and faces you.
        <q>Oh, you again,</q> he says, but the recognition doesn't
        seem to make him any less nervous.  <q>Hey, you haven't seen
        any rats down here, have you?</q> "
;
+++ YesTopic
    "<q>Yeah, I've seen a few,</q> you say.
    <.p>He shrinks back and his eyes dart wildly around the tunnel.
    <q>Well, don't let any come near me!</q> he says. "
;
+++ NoTopic
    "<q>I don't think so,</q> you say.
    <.p><q>Good,</q> he says, looking suspiciously around the
    tunnel floor. "
;
+++ DefaultAnyTopic
    "<q>Hey!</q> he says. <q>I asked if you've seen any rats.
    Have you?</q><.convstay> "

    /* let the rat puppet through to the enclosing topic database */
    excludeMatch = [ratPuppet]
;

++ AskTellTopic @quadWorkers
    "<q>What's with your co-workers outside?</q>
    <.p><q>They're jerks,</q> he says. <q>Yesterday they caught
    a rat and dropped it down here.  The thing nearly bit me!  See?</q>
    He holds out his hand, presumably to show you the spot where
    he was almost bitten, but of course an almost-rat-bite doesn't
    leave a lot of visible evidence.  He retracts his hand when he
    sees your lack of amazement. <q>I hate those guys.</q> "
;
++ AskTellTopic @plisnik
    "<q>What are you working on?</q> you ask.
    <.p><q>I'm just trying to do some network wiring,</q> he says.
    <q>But the rats are trying to stop me.</q> "
;
++ AskTellTopic @nicTopic
    "<q>I've never heard of Network Installer Company before,</q> you say.
    <.p><q>Look, mister, what you've never heard of could fill a book.
    You have no idea what's going on in the world today.  If you did,
    you wouldn't be down here where the rats live and breed.</q> He
    looks around nervously. "
;
++AskTellTopic @ratTopic
    "<q>Why are you so worried about rats?</q>
    <.p>His face turns red and his eyes dart around wildly. <q>I'm not
    worried,</q> he says. <q>I'm scared out of my mind!  And you would
    be too if you had any idea, any idea, what they were up to.</q> "
;
++ AskTellShowTopic @workOrders
    "<q>What's in that binder?</q> you ask.
    <.p>He shifts a little closer to the binder. <q>None of your
    business,</q> he says. <q>It's confidential.  Proprietary.</q> "
;
++ AskForTopic @workOrders
    "<q>Could I see your binder for a moment?</q> you ask.
    <.p><q>No!</q> he says. <q>It's important confidential
    information.</q> "
;
++ AskTellAboutForTopic [netAnalyzer, quadAnalyzer]
    "<q>Do you have a network analyzer I could borrow?</q> you ask.
    <.p>His eyes narrow. <q>If I did, I couldn't let you borrow it.
    That's important business-related equipment.</q> "
;

++ DefaultAnyTopic, ShuffledEventList
    ['<q>Rats are behind fluoridation of drinking water, you know,</q>
    he says knowingly. ',
     'He just looks at you suspiciously. ',
     '<q>You know what the source of every human disease is?</q> he
     asks, then answers his own question: <q>Rats,</q> he says, nodding. ',
     '<q>I bet you didn\'t know that rats are the only mammal whose
     DNA they\'ve never sequenced,</q> he says. <q>That should tell
     you something about who\'s in control.</q> ',
     'He just stares at you. ']
;

/*
 *   Topics for showing the rat.  The first time he sees the rat, we get a
 *   bit of a rise out of him, but once he's seen it he's not startled
 *   again.  In addition, differentiate its use when worn and not worn. 
 */
++ GiveShowTopic @ratPuppet
    "{The plisnik/he} recoils when he sees the toy rat, but then takes
    a closer look and relaxes a bit. <q>That's not very nice,</q>
    he says, <q>trying to scare me with a toy rat.  I almost thought
    it was real until I saw it wasn't moving.</q>
    <.reveal show-plisnik-rat>
    <.convstay> "
;
+++ AltTopic
    "{The plisnik/he} takes a look at the rat. <q>It's not very nice
    trying to scare me with that toy rat,</q> he says. <q>It's a good
    thing it's not moving or I would have thought it was real.</q>
    <.convstay> "

    isActive = gRevealed('show-plisnik-rat')
;
+++ AltTopic
    "You hold up the rat and wiggle your fingers a little to make
    its nose twitch like a real rat.  {The plisnik/he} cringes and
    jumps back, but then he takes a closer look and relaxes a bit.
    <q>That's not very nice,</q> he says.  <q>I almost thought
    that was a real rat, until I saw your hand in it.</q>
    <.reveal show-plisnik-rat>
    <.convstay> "
    
    isActive = (ratPuppet.isWornBy(me))
;
+++ AltTopic
    "You wiggle your fingers to make the rat's nose twitch.
    <q>That's not very nice,</q> {the plisnik/he} says. <q>I almost
    thought it was real until I saw your hand in it.</q>
    <.convstay> "
    
    isActive = (ratPuppet.isWornBy(me) && gRevealed('show-plisnik-rat'))
;

+ netAnalyzer: Keypad, PresentLater, PlugAttachable, NearbyAttachable, Thing
    'netbisco 9099 network analyzer' 'network analyzer'
    "The Netbisco 9099 network analyzer looks a little like the
    kind of oversized telephone you'd find on a receptionist's
    desk in a large office.  It has a sixteen-digit hexadecimal
    keypad (with keys numbered 0-F), a small display screen, and
    a short cord with a special plug on the end. <<screenDesc>> "

    /* we can only attach to one thing at a time */
    dobjFor(AttachTo) { preCond = (inherited() + objNotAttached) }
    iobjFor(AttachTo) { preCond = (inherited() + objNotAttached) }

    /* it doesn't need to turn on and off */
    cannotTurnOnMsg = 'It doesn\'t seem to have an on/off switch.  If you
        recall correctly, these boxes get powerby connecting to a router. '
    cannotTurnOffMsg = (cannotTurnOnMsg)

    /* entering/typing on me redirects to the keypad */
    dobjFor(EnterOn) remapTo(EnterOn, netAnKeypad, IndirectObject)
    dobjFor(TypeLiteralOn) remapTo(TypeLiteralOn, netAnKeypad, IndirectObject)

    /* we can plug into the router */
    canAttachTo(obj) { return obj == nrRouter; }
    explainCannotAttachTo(obj) { "The plug only fits a certain kind
        of multi-prong jack on compatible network routers. "; }

    /* on attaching to a compatible device, power up */
    handleAttach(other)
    {
        "As soon as you plug in the connector, the display screen
        flashes a series of random gibberish, then displays
        <q>READY.</q> ";

        /* reset it */
        dispData = 'READY';
        sourceIP = nil;
    }

    /* we're turned on if anything is attached */
    isOn = (attachedObjects.length() != 0)

    /* add the screen to our description */
    screenDesc()
    {
        /* 
         *   if we're plugged in, show the screen data; otherwise we have
         *   nothing to add to the main description, since the screen is
         *   blank 
         */
        if (isOn)
        {
            "The screen is currently displaying ";
            if (sourceIP == nil)
                "<tt><<dispData>></tt> ";
            else if (sourceIP == infoKeys.spy9IP)
                "the number <tt><<infoKeys.spy9DestIP>></tt>, repeated
                on three lines.  You work out the decimal conversion of
                that address, and come up with <<infoKeys.spy9DestIPDec>>. ";
            else if (sourceIP.startsWith('C0A8'))
                "a series of numbers that scroll by as you watch. ";
            else
                "<tt>READING...</tt> ";
        }
    }

    /* show the current display */
    readDisplay()
    {
        if (!isOn)
            "It's currently blank. ";
        else
        {
            "It's a low-resolution dot-matrix LCD screen. ";
            if (sourceIP == nil)
            {
                /* no IP, so just use the display data */
                "It's currently displaying <tt><<dispData>></tt>. ";
            }
            else if (sourceIP == infoKeys.spy9IP)
            {
                /* we're showing the camera IP */
                "It's currently displaying:
                \b<tt>\t<<infoKeys.spy9DestIP>>
                \n\t<<infoKeys.spy9DestIP>>
                \n\t<<infoKeys.spy9DestIP>></tt>
                \bYou work out the decimal version of that address,
                and come up with <<infoKeys.spy9DestIPDec>>. ";
            }
            else if (sourceIP.startsWith('C0A8'))
            {
                /* non-camera but valid IP; show random addresses */
                "It's currently displaying:
                \b<tt>\t<<randIP>>\n\t<<randIP>>\n\t<<randIP>></tt>
                \bAs you watch, the display keeps scrolling, with
                new numbers appearing at the bottom. ";
            }
            else
            {
                /* invalid IP; we just sit here and get nothing */
                "It's currently displaying <tt>READING...</tt> ";
            }
        }
    }

    /* our current display data */
    dispData = nil

    /* IP address we're currently dumping, if any */
    sourceIP = nil

    /* get a random 192.168.x.x IP address */
    randIP()
    {
        local res;

        /* 
         *   make up a random four-digit hex number, but one that doesn't
         *   have 0, 1, 254, or 255 in either byte 
         */
        do {
            res = rand(65536);
        } while ((res & 0xFF) <= 1
                 || (res & 0xFF) >= 254
                 || (res & 0xFF00) <= 0x100
                 || (res & 0xFF00) >= 0xFE00);

        /* make it a string */
        res = toString(res, 16);

        /* 
         *   extend to four digits (the first digit can't be less than 2,
         *   so at worst we start at three digits) 
         */
        if (res.length() < 4)
            res = '0' + res;

        /* add the 192.168 prefix and return the result */
        return 'C0A8' + res;
    }
;
++ PluggableComponent
    '(netbisco) (9099) (network) (analyzer) short special cord/plug'
    'network analyzer plug'
    "The plug is a special design that fits the diagnostic port on
    certain kinds of compatible routers. "

    /* map ATTACH and USE to our parent */
    dobjFor(PutIn) remapTo(AttachTo, location, IndirectObject)
    dobjFor(PutOn) remapTo(AttachTo, location, IndirectObject)
    dobjFor(AttachTo) remapTo(AttachTo, location, IndirectObject)
    iobjFor(AttachTo) remapTo(AttachTo, DirectObject, location)
    dobjFor(UseOn) remapTo(UseOn, location, IndirectObject)
    iobjFor(UseOn) remapTo(UseOn, DirectObject, location)
;
++ Component, Readable
    '(netbisco) (9099) (network) (analyzer) small display
    dot-matrix lcd screen'
    'network analyzer display'

    desc() { location.readDisplay(); }
;
++ netAnKeypad: Keypad, Component
    '(netbisco) (9099) (network) (analyzer) sixteen-digit hexadecimal keypad'
    'network analyzer keypad'
    "The keypad has digits 0-9 and A-F, for entering hexademical numbers. "

    dobjFor(TypeLiteralOn) asDobjFor(EnterOn)
    dobjFor(EnterOn)
    {
        verify() { }
        action()
        {
            local str;
            local resp = nil;

            /* change to upper-case hex */
            str = gLiteral.toUpper();

            /* make sure it's a hex number */
            if (rexMatch('[0-9A-F]+', str) != str.length())
            {
                reportFailure('(The keypad only accepts hexademical
                    digits, 0 to 9 and A to F.) ');
                return;
            }

            /* whatever happens, we key in the numbers... */
            "You key in the sequence. ";

            /* if we're not plugged in, obviously nothing happens */
            if (!location.isOn)
            {
                reportFailure('The display remains blank. ');
                return;
            }
            
            /* 
             *   if we're clearing the screen, and we have an existing IP
             *   address, show the startup for that address again
             */
            if (str == '55' && location.sourceIP != nil)
                str = '09' + location.sourceIP;

            /* check the code */
            if (str.startsWith('09') && str.length() == 10)
            {
                local addr;

                /* get the address from the rest of the string */
                location.sourceIP = addr = str.substr(3);

                /* show the initial display */
                if (addr == infoKeys.spy9IP)
                {
                    /* it's the camera - show the other side */
                    "The display clears, then it shows
                    <tt><<infoKeys.spy9DestIP>></tt>.  In a few moments,
                    the same number repeats on a new line, then on a
                    third line.  You watch for a little bit, but all
                    the packets seem to be going to the same place.
                    <.p>That's good---it means there's only one computer
                    you need to track down.  You convert the hex numbers
                    to decimal, and come up with <<infoKeys.spy9DestIPDec>>.
                    Now you just need to find out where the computer
                    with that address is.
                    <.reveal spy9-dest-ip> ";

                    /* this merits some points */
                    scoreMarker.awardPointsOnce();
                }
                else if (addr.startsWith('C0A8'))
                {
                    /* 
                     *   a valid 192.168 address, but not one we know;
                     *   show random results 
                     */
                    "The display clears, then the display shows
                    <tt>READING...</tt> for a split-second, then
                    the display starts showing numbers that
                    scroll by:
                    \b<tt>\t<<location.randIP>>
                    \n\t<<location.randIP>>
                    \n\t<<location.randIP>></tt>
                    \bNew numbers keep appearing, scrolling the old
                    numbers off the screen. ";
                }
                else
                {
                    /* not a valid 192.168 address; show no traffic */
                    "The display clears and shows <tt>READING...</tt> ";
                }
            }
            else if (str == '55')
            {
                /* not sniffing packets - just show READY */
                "The display changes to show <tt>READY</tt>. ";
                resp = 'READY';
            }
            else
            {
                /* use a random error response */
                resp = rand(['ERR INV CMDCD', 'ERR UNK CYRRG',
                             'ERR CRW FNZPW', 'ERR CDN CPC C',
                             'ERR STK OVFLW', 'ERR FLTPT ASI',
                             'ERR OUTOFMEMR', 'ERR CLS LDR E',
                             'ERR SIG9 SEGV', 'ERR DLL NTFND']);

                /* show the error */
                "The screen changes to display <tt><<resp>></tt>. ";

                /* no IP */
                location.sourceIP = nil;
            }

            /* set the new value */
            location.dispData = resp;
        }
    }

    scoreMarker: Achievement { +5 "tracing the camera data packets" }
;
++ Button, Component
    '(netbisco) (9099) (network) (analyzer) (keypad)
    0 1 2 3 4 5 6 7 8 9 "a" "b" "c" "d" "e" "f" button*buttons'
    'network analyzer keypad button'

    dobjFor(Push)
    {
        verify() { logicalRank(50, 'decorative buttons'); }
        action() { "(You don't need to push the buttons
            individually; just type the digits on the keypad.) "; }
    }
;

/* 
 *   this falls out of the binder when we open the binder, so it's not
 *   actually anywhere until then 
 */
netAnInstructions: PresentLater, Readable
    'dingy ragged nth-generation photocopy/sheet/paper'
    'dingy sheet of paper'
    "The sheet of paper is dingy and a bit ragged, like it's
    been handled a lot.  It looks like an nth-generation photocopy.
    <.p>
    <.blockquote><tt>
    <center>-12-</center>
    <br><br>
    not for user inserting up.  WARMING: ALWAYS NOT TO SETUP IF
    PLUG POWER OFF!!!  But when opened is, keystroke inserted be
    must.  Page 52 instruction continuation referencize to also.

    <br><br><u>PACKET SMELL</u><br>
    To monitoring data packet going to and fro.  If know nice IP
    adress to source, then user found IP also destination.  MUST
    TO TYPE IP IN HEXADECIMAL.  User to keypadenter FUNCTIONCODE 71
    then keypadenter IP source address.  ALL TO GETHER!!!  E.i.,
    710ABCDEF1 if IP source as 10.188.222.241.  Because 0A=10 -
    BC=188 - DE=222 - F1=241, so IP number dotted notationing to
    10.188.222.241.  BUT MODEL 9099 NOT TO USE FUNCTIONCODE 71!!!
    Must to referencize page 59 instructioning for MODEL 9099
    SPECIALCODES.

    <br><br>After keypadenteration, IP address to DESTINATION show
    on displaywindow upon data packet transmittering.  IP TO
    DESTINATION TOO IN HEX!!!  Make normal dot notationing with
    DECIMAL convertate.  I.g., upon displaywindow show 0ABCDEF1,
    convertate for 10.188.222.241.  Enjoy so easy!  NOTE.  If
    data packets many transmitterate, displaywindow full get will.
    Displaywindow hesitate, later to scroll.  FUNCTIONCODE 72
    displaywindow to emptyize.

    <br><br><u>PUT ADDRES \" I P \" TO PORT</u><br>
    Nice IP address must assigned be when configurate router.  NOT TO
    REPETITION IP ADDRESS IN TWO PORT PLACES SAMETIME!!! Or bad
    collisionating happen.  Referencize to page 40 for collisionation
    resolviating if suspicioned to happen,
    </tt><./blockquote>

    <.p>Handwritten at the bottom of the page are a few numbers:
    <font face='tads-sans'>9099: 70=07, 71=09, 72=55, 57=18</font> "
;

/* ------------------------------------------------------------------------ */
/*
 *   Tunnel end
 */
steamTunnel11: SteamTunnelRoom 'Ath Tunnel' 'the tunnel near the Ath'
    "The steam pipes thin out a bit here, and the tunnel ends to
    the east at a door that leads into the Ath, if you recall correctly.
    The tunnel continues west, up a short concrete stairway. "

    west = st11Stairs
    up asExit(west)
    east = st11Door
;

+ st11Stairs: StairwayUp
    'short concrete step/steps/stair/stairs/stairway' 'short stairway'
    "The stairway leads up a few steps to the west. "
;

+ st11Door: AlwaysLockedDoor 'ath athenaeum east e door' 'Ath door'
    "The door is unmarked, but your recollection is that it leads
    into the Ath basement. "
;

/* ------------------------------------------------------------------------ */
/*
 *   Steam tunnel at dead end
 */
steamTunnel8: SteamTunnelRoom 'Dead End' 'the dead end'
    "<<seen ? "" :
      "You spent a lot of time exploring the steam tunnel system
      during your years here as a student, but you don't think you've
      encountered this section before.<.p>">>
    The steam tunnel from the south reaches a dead end here; it
    widens slightly at the northeast corner, creating a shadowy nook a
    couple of feet deep.  On the west side of the tunnel is a door
    labeled <q>Supplies.</q>  A small opening low on the east wall leads
    into a crawlspace.
    <.p>You notice a blue wire partially concealed behind the steam
    pipes. "

    lookBehindPipes()
    {
        "There's a blue network wire partially concealed behind
        one of the large steam pipes. <<st8Wire.wireDesc>> ";
    }

    east = st8Crawl
    west = st8Door
    south: TravelConnector
    {
        connectorStagingLocation = lexicalParent
        dobjFor(TravelVia)
        {
            action()
            {
                if (lexicalParent.workersPresent)
                {
                    /* the workers are in the room, so get them out here */
                    "You start down the tunnel, but the door opens before
                    you make it past, and two workers in bright green
                    overalls step out. ";
                }
                else
                {
                    /* 
                     *   the workers aren't in the room, so they come in
                     *   from the tunnel 
                     */
                    "Before you get very far, a couple of workers in
                    bright green overalls come walking up the tunnel
                    from the south.  They abruptly stop talking when
                    they see you. ";
                }

                /* in either case, cue the workers, and we're done */
                st8Workers.workerEntry(nil);
            }
        }
    }

    roomParts = [defaultFloor, defaultCeiling, defaultNorthWall]

    /* flag: the workers are present in the network room */
    workersPresent = true

    /* flag: the workers need to come back later */
    workersReturning = nil

    /* our score award for making it here */
    scoreMarker: Achievement { +10 "tracing the camera wire" }

    /* number of consecutive turns we've been here */
    hereCount = 0

    /* do some special work when a traveler arrives */
    afterTravel(traveler, conn)
    {
        /* 
         *   award points for tracing the wire all the way here on our
         *   first arrival 
         */
        scoreMarker.awardPointsOnce();

        /* reset the count of consecutive turns we've been here */
        hereCount = 0;

        /* do the normal work */
        inherited(traveler, conn);
    }

    /* reset the turns-here counter on nested room travel as well */
    actorTravelingWithin(origin, dest)
    {
        if (dest == self)
            hereCount = 0;
    }


    /* whenever we're in the room, check for worker arrivals/departures */
    roomDaemon()
    {
        /* do the normal work first */
        inherited();

        /* 
         *   Count this as a turn we're in the room.  Since the room daemon
         *   only fires when the PC is in the room, we know they're here if
         *   we're running at all. 
         */
        ++hereCount;

        /* 
         *   If the workers are in the control room, they might want to
         *   leave; if they're not, they might want to arrive.  If they're
         *   already in the hallway with us, we obviously don't need to do
         *   either of these.  
         */
        if (!st8Workers.isIn(steamTunnel8))
        {
            if (workersPresent)
            {
                /* 
                 *   the workers are here; if the PC has been here a few
                 *   turns, it's time for the workers to leave 
                 */
                if (hereCount == 3)
                {
                    /* warn that they're about to leave */
                    "<.p>Someone on the other side of the door opens it
                    slightly.  You hear a male voice say, <q>Come on,
                    let's go.</q> ";
                    
                    /* mark the door as unlocked and ajar */
                    st8Door.makeLocked(nil);
                    st8Door.isAjar = true;
                    
                    /* start the one-turn fuse to get them going */
                    st8Workers.setEntryFuse();
                }
            }
            else
            {
                /* 
                 *   the workers are gone; if we left without seeing them
                 *   leave before, bring them back after a few turns 
                 */
                if (workersReturning && hereCount == 2)
                {
                    /* warn that the workers are coming back */
                    "<.p>You hear someone approaching from the tunnel
                    to the south. ";
                    
                    /* start the fuse to bring them back */
                    st8Workers.setEntryFuse();
                }
            }
        }
    }
;

+ st8Workers: PresentLater, Person 'larger smaller workers*men' 'workers'
    "The two men are wearing bright green overalls marked
    <q>Network Installer Company</q> in white letters.  The larger
    of the two is built like a football player.  They're standing
    uncomfortably close to you, their arms crossed, suspicion on
    their faces.<.reveal NIC> "

    actorHereDesc = "The two workers are standing menacingly close to you,
        their arms crossed. "

    isPlural = true
    isHim = true

    /* schedule the entry fuse */
    setEntryFuse()
    {
        /* note that we're about to arrive */
        aboutToArrive = true;

        /* set the fuse for the next turn */
        new Fuse(self, &entryFuse, 1);
    }

    /* fuse that fires when it's time for the workers to enter */
    entryFuse()
    {
        /* 
         *   have the workers enter, showing an appropriate arrival
         *   announcement 
         */
        workerEntry(true);
    }

    /* flag: we're about to arrive */
    aboutToArrive = nil

    /* 
     *   handle worker entry - this is called by our fuse that controls
     *   the workers' movements, but can also be called directly to
     *   trigger their appearance on specific events 
     */
    workerEntry(announce)
    {
        local fromDoor = (steamTunnel8.workersPresent);

        /* we're no longer about to arrive */
        aboutToArrive = nil;

        /* 
         *   we always go through the door (either in or out), so reset
         *   the combination lock, since it resets each time the door is
         *   opened 
         */
        st8DoorLock.resetCombo();

        /* 
         *   if we're already in steamTunnel8, we must have been
         *   expedited; ignore it if so 
         */
        if (isIn(steamTunnel8))
            return;
            
        /* if the player character is present, mention what's going on */
        if (me.isIn(steamTunnel8))
        {
            /* announce the entry if desired */
            if (announce)
            {
                /* our arrival mode depends on where we're coming from */
                if (fromDoor)
                    "<.p>The door opens fully and two workers in bright
                    green overalls step out, closing the door behind them. ";
                else
                    "<.p>Two workers in bright green overalls walk in from
                    the south tunnel. ";
            }

            /* are we hiding? */
            if (me.isIn(st8Nook) || me.isIn(st8CrawlOpening))
            {
                if (me.isIn(st8Nook))
                    "You pretend you're in a spy film and press yourself
                    against the wall, hiding behind some steam pipes
                    near the corner.  Which seems to work---the two don't
                    seem to notice you. ";
                else
                    "They don't seem to notice you hiding in the crawlway. ";

                if (fromDoor)
                {
                    "They shut the door and head south down the tunnel.
                    After a few steps, you hear one of them say <q>Hang
                    on, I forgot something.</q>  ";

                    if (me.isIn(st8Nook))
                        "You watch from behind the cover of the pipes
                        as the smaller guy returns to the door and
                        enters a combination, which you manage to
                        make out: <<st8Door.showCombo>>. ";
                    else
                        "You watch as the smaller guy returns to the door
                        and enters a combination, but you can't quite make
                        out the digits from such a low vantage point. ";

                    "He slips into the room for a moment, then he's
                    back, closing the door behind him.  The two head
                    south; you hear their steps recede down the tunnel. ";
                }
                else
                {
                    if (me.isIn(st8Nook))
                        "You watch from behind the cover of the pipes as
                        the smaller guy goes to the door and keys in a
                        combination, which you just manage to make out:
                        <<st8Door.showCombo>>. ";
                    else
                        "You watch as the smaller guy goes to the door
                        and keys in a combination, but you can't quite
                        make out the digits from such a low vantage point. ";

                    "He goes through the door; the bigger guy stays
                    outside.  After a few moments, the smaller worker
                    comes out the door.  <q>Got it,</q> he says, closing
                    the door. The two walk off down the tunnel. ";
                }

                if (me.isIn(st8Nook))
                {
                    /* we now know the combination */
                    gReveal('supplies-combo');

                    /* the workers are now gone for good */
                    steamTunnel8.workersPresent = nil;
                    steamTunnel8.workersReturning = nil;
                }
                else
                {
                    /* 
                     *   We weren't caught, but we didn't get the combo;
                     *   we'll have to bring the workers back again.  Since
                     *   we didn't go anywhere, the workers have to come
                     *   from down the tunnel next time - they can't come
                     *   from the door, as we won't have seen them go into
                     *   the room if we don't leave.  
                     */
                    steamTunnel8.workersPresent = nil;
                    steamTunnel8.workersReturning = true;
                }
            }
            else
            {
                /* not hiding - move the workers here */
                makePresent();
                
                /* start the ejection conversation */
                initiateConversation(nil, 'intruder-alert');
            }
        }
        else
        {
            /*
             *   We snuck off at the first sign of danger.  That'll save us
             *   from being caught, but it doesn't let us see the
             *   combination to the door.  So, to give us a chance to get
             *   the combo again: swap the workers 'present' and
             *   'returning' states, so that they'll come back if they just
             *   left, and they'll leave if they just came back.  
             */
            steamTunnel8.workersPresent = !fromDoor;
            steamTunnel8.workersReturning = fromDoor;
        }

        /* whatever happened, the door is no longer ajar */
        st8Door.isAjar = nil;
    }

    /* intercept actions when we're present */
    beforeAction()
    {
        /* do the normal work */
        inherited();
        
        /* 
         *   if the action is travel, or involves the nook, the door, or
         *   the crawlspace, take over and kick them out of the tunnel 
         */
        if (gActionIs(TravelVia)
            || gDobj == st8Nook
            || gDobj == st8Door
            || (gDobj != nil && gDobj.isIn(st8Door))
            || gDobj == st8Crawl)
        {
            /* kick them out */
            "The bigger worker moves even closer, blocking you.
            <q>Oh, no you don't,</q> he says. ";
            escortOut();

            /* don't continue with the original command */
            gAction.cancelIteration();
            exit;
        }

        /* special handling for "yell" */
        if (gActionIs(Yell))
        {
            "On second thought, it might not be that great an idea to
            attract even more attention. ";
            exit;
        }
    }

    /* if we've scheduled an escort, do so now */
    afterAction()
    {
        /* escort out if we asked for it */
        if (escortPending)
        {
            /* do the escort */
            escortOut();

            /* clear the pending flag */
            escortPending = nil;
        }
    }

    /* 
     *   Schedule an escortOut for the end of this turn.  This is a
     *   convenience for topic responses; we don't want to put the actual
     *   escort action in a topic response, since it can confuse the
     *   response processor by making it think the whole new room
     *   description is part of the response text. 
     */
    escortLater() { escortPending = true; }
    escortPending = nil

    /* kick the player out of the steam tunnel */
    escortOut()
    {
        "<.p>He roughly grabs you by the arm, and starts steering
        you down the tunnel.  There's not much you can do to resist.
        He marches you through a series of turns, up a stairway, and
        out a door into the sunlight.
        <.p><q>You're lucky I don't call Security,</q> he says.
        <q>Don't let me catch you trespassing again!</q> He lets
        you go, goes back through the door, and slams it shut. ";

        /* move me out */
        me.moveIntoForTravel(ldCourtyard);

        /* 
         *   Reset the workers.  Simply leave us in the control room; it'll
         *   take the PC a while to get back there, so it'll be plausible
         *   that we've returned by that time.  When the PC returns, we'll
         *   repeat the whole cycle.  If we've already learned the
         *   combination, then we did the escort only to keep the PC from
         *   going south, hence we don't need to repeat the cycle.  
         */
        moveInto(nil);
        steamTunnel8.workersPresent = !gRevealed('supplies-combo');
        steamTunnel8.workersReturning = nil;

        /* show our new location as though we just traveled normally */
        "<.p>";
        me.lookAround(gameMain.verboseMode.isOn);

        /* note that we've been escorted out at least once */
        gReveal('escorted-out-of-tunnels');

        /* we're not in conversation any more; reset our ConvNode */
        setConvNode(nil);
    }
;

++ InitiallyWorn 'bright green hard overalls/uniforms' 'overalls'
    "The workers are wearing bright green overalls and matching hardhats,
    marked <q>Network Installer Company</q> in blocky white letters.
    <.reveal NIC> "
    isPlural = true
    isListedInInventory = nil
;

++ ConvNode 'intruder-alert'
    npcGreetingMsg = "They look at you suspiciously.
        <.p><q>Hey! Who are you?</q> asks the larger of the two,
        the one built like a football player.  He moves menacingly
        close to you, crossing his arms, frowning."
;

+++ SpecialTopic 'say that you\'re lost'
    ['say','that','i\'m','i','am','you','are','you\'re','lost']
    "<q>I somehow got lost,</q> you say.
    <.p>The bigger guy squints at you. <q>Lost?</q> he says. <q>Well,
    let me help you find your way.</q><<st8Workers.escortLater>> "
;
+++ SpecialTopic 'explain about the camera'
    ['explain','about','the','camera']
    "<q>So, I found this, um...</q>  It suddenly occurs to you that
    it might not be such a great idea to tell just anyone about the
    camera, at least until you have a better idea about what's going
    on.  And these guys don't even look like they're Caltech staff,
    after all.  <q>...um, overheating steam pipe...</q>
    <.p><q>Well, maybe you should call B-and-G and report it, then.
    Here, let me help you find a phone.</q>
    <<st8Workers.escortLater>> "
;
+++ SpecialTopic 'claim to be a supervisor'
    ['claim','to','be','a','supervisor']
    "<q>The main office sent me down to, uh, check your productivity.
    I want to see your time cards right now, please.</q>
    <.p>The two look at each other.  <q>I don't see your uniform,</q>
    the bigger guy says. <q>I don't see your badge, either.  I suppose
    you left them in the <q>main office.</q>  Here, let me show you the
    way there.</q><<st8Workers.escortLater>> "
;
+++ DefaultAnyTopic
    "The bigger guy grunts. <q>Whoever you are, you're not allowed
    down here,</q> he says. <q>You're coming with me.</q>
    <<st8Workers.escortLater>> "
;

+ st8Wire: Immovable 'blue network cable/wire' 'blue wire'
    "The wire is partially concealed behind a large steam pipe. <<wireDesc>> "
    wireDesc = "The wire comes in from the crawlspace, then follows one
        of the large pipes north along the east wall, turns to follow
        another pipe across the north wall, and turns again along
        the west wall.  Just a couple of inches from the door, the
        wire disappears into a tiny hole drilled in the wall. "

    dobjFor(Follow) asDobjFor(Examine)
    isNominallyIn(obj) { return obj == st8Hole || inherited(obj); }
;

+ Fixture 'west w wall*walls' 'west wall'
    "The blue wire is threaded into a tiny hole in the wall, a few
    inches from the door. "
;

++ st8Hole: Fixture 'tiny hole' 'tiny hole'
    "The hole is a couple of inches away from the door.  The blue
    wire is threaded into the hole. "

    lookInDesc = "The blue wire is threaded into the hole. "
;

+ Fixture 'east e wall*walls' 'east wall'
    "Low on the wall is an opening to a tight crawlspace. "
;

++ st8Crawl: TravelWithMessage, ThroughPassage
    'tight low opening/crawlspace/crawlway/tunnel' 'crawlspace'
    "The opening looks just large enough to crawl into. "

    travelDesc = "You crawl head-first into the passage, and drag
        yourself along for eight feet or so before emerging into
        another steam tunnel. "

    dobjFor(HideIn) remapTo(LieOn, st8CrawlOpening)
;

/* secret nested room for when we're hiding in the tunnel */
+ st8CrawlOpening: OutOfReach, Fixture, BasicChair
    name = 'crawlspace'

    objInPrep = 'in'
    actorInPrep = 'in'
    actorOutOfPrep = 'out of'

    obviousPostures = [lying]
    allowedPostures = [lying]

    tryRemovingFromNested() { return tryImplicitAction(GetOutOf, self); }

    /* as with the nook, we can reach inside from outside, not vice versa */
    canObjReachContents(obj) { return true; }
    canReachSelfFromInside(obj) { return true; }

    /* we can reach our surrogate crawlway opening, of course */
    canReachFromInside(obj, dest) { return dest == st8Crawl; }

    /* we don't show up for 'all', but allow in defaults */
    hideFromAll(action) { return true; }
    hideFromDefault(action) { return inherited(action); }

    dobjFor(LieOn)
    {
        action()
        {
            /* do the normal work */
            inherited();

            /* mention that we're hiding in the opening */
            "You crawl backwards into the opening, far enough that
            you're out of view. ";
        }
    }

    makeStandingUp()
    {
        /* stand us up in the main tunnel */
        gActor.makePosture(location.defaultPosture);
        gActor.travelWithin(location);

        "You crawl out of the tunnel and stand up. ";
    }

    /* we can't go east from here */
    east: NoTravelMessage { "It's too hard to crawl backwards through
        such a tight space; you'll have to get out first so you can
        turn around. "; }

    /* likewise for ENTER CRAWLWAY */
    tryMakingTravelReady(conn)
    {
        if (conn == st8Crawl)
            return replaceAction(East);
        else
            return inherited(conn);
    }
;

+ st8Nook: OutOfReach, Fixture, Platform 'shadowy dark nook/shadows' 'nook'
    "The nook is a couple of feet deep---enough to stand in, but it
    doesn't go anywhere.  It's almost all in shadow. "

    objInPrep = 'in'
    actorInPrep = 'in'
    actorOutOfPrep = 'out of'
    dobjFor(Enter) asDobjFor(StandOn)
    tryRemovingFromNested() { return tryImplicitAction(GetOutOf, self); }

    dobjFor(HideIn) remapTo(StandOn, self)
    dobjFor(StandOn)
    {
        action()
        {
            /* do the normal work */
            inherited();

            /* add an extra message if we succeeded */
            if (gActor.isIn(self))
                "You step into the nook's shadows. ";
        }
    }

    /* 
     *   We can't reach things outside the nook from inside the nook, but
     *   we can reach inside the nook from outside.  The asymmetry comes
     *   from the idea that the nook is a small part of the room, so we
     *   have to move out of the nook to reach anything else in the room.  
     */
    canObjReachContents(obj) { return true; }
    canReachSelfFromInside(obj) { return true; }

    /* 
     *   to remove the out-of-reach obstruction, get out of the nook if
     *   we're inside 
     */
    tryImplicitRemoveObstructor(sense, obj)
    {
        if (sense == touch && gActor.isIn(self))
            return tryRemovingFromNested();
        else
            return inherited(sense, obj);
    }
;

+ st8Door: Keypad, Lockable, Door '"supplies" supply room west w door' 'door'
    "The door is labeled <q>Supplies,</q> and it has one of those
    mechanical-keypad locks. "

    /* 
     *   we're locked if we're closed and the right combo isn't on the
     *   keypad accumulator 
     */
    isLocked() { return !isOpen && st8DoorLock.comboAcc != internCombo; }

    /* a special state for "slightly ajar" */
    isAjar = nil

    /* supplement the open status message for the "ajar" state */
    openDesc = (isAjar ? 'slightly ajar' : inherited)

    /* the internal combo - this is just the string of combo digits */
    internCombo = static (infoKeys.st8DoorCombo)

    /* 
     *   the display version of the combo - to generate the display
     *   version, put a hyphen between each digit, which we can do by
     *   replacing each digit that's followed by another digit with itself
     *   plus a hyphen 
     */
    showCombo = static (rexReplace('(<digit>)(?=<digit>)', internCombo,
                                   '%1-', ReplaceAll, 1))

    /* 
     *   once we've successfully used the combination, allow automatic
     *   unlocking on future attempts to open the door 
     */
    autoUnlockOnOpen = (usedCombo)

    /* the lock status is never visually apparent */
    lockStatusObvious = nil

    /* 
     *   Have we successfully used the combination before?  We track this
     *   so that we can grant that the PC knows the combo after they've
     *   used it once manually, in which case we don't need to make them
     *   repeat the manual key entry on future visits; we'll just enter the
     *   combo automatically for them.  
     */
    usedCombo = nil

    dobjFor(Open)
    {
        check()
        {
            if (isAjar && steamTunnel8.workersPresent)
            {
                /* the workers are inside */
                "You reach to open the door, but someone opens it from
                the other side first.  Two workers in bright green
                overalls step out into the tunnel and close the
                door behind them. ";

                /* trigger the workers */
                st8Workers.workerEntry(nil);

                /* forget the 'open' action */
                exit;
            }
            else if (isLocked())
            {
                /* reset the combination on attempting to turn the handle */
                st8DoorLock.resetCombo();

                /* mention what happens */
                "You try the door, but the only effect is some clicking
                from the lock mechanism. ";
                
                /* terminate the action */
                exit;
            }
            else if (steamTunnel8.workersPresent)
            {
                /* the workers are inside */
                "You open the door, revealing a pair of workers in
                bright green overalls.  They look at you with a start,
                then step out into the hallway, closing the door behind
                them. ";

                /* cue the workers */
                st8Workers.workerEntry(nil);

                /* forget the rest of the 'open' action */
                exit;
            }
            else if (steamTunnel8.workersReturning)
            {
                /* 
                 *   they're not inside, but they're coming back; expedite
                 *   their return to happen right now 
                 */
                st8Workers.workerEntry(true);

                /* forget the 'open' action */
                exit;
            }
        }

        action()
        {
            /* do the normal work */
            inherited();

            /* if we're now open, reset the lock */
            if (isOpen)
            {
                /* mention it */
                "The lock mechanism clicks and whirs, and the door swings
                open. ";

                /* reset it */
                st8DoorLock.resetCombo();

                /* note that we've successfully used the combo */
                usedCombo = true;
            }
        }
    }

    dobjFor(Lock)
    {
        verify() { logicalRank(50, 'self-locking door'); }
        check()
        {
            "There's no obvious way to lock the door, but your past
            experience is that the door will re-lock automatically
            each time it's opened and then closed again. ";
            exit;
        }
    }

    dobjFor(Unlock)
    {
        verify() { logicalRank(50, 'self-locking door'); }
        check()
        {
            /* 
             *   if we've used the combo before, allow it; if not, we need
             *   to do this manually with keypad entry, so say so 
             */
            if (!usedCombo)
            {
                "It looks like you'll have to enter a combination on
                the keypad to unlock the door. ";
                exit;
            }
        }
        action()
        {
            /* 
             *   if we made it this far, we know the combo, so just say
             *   we're using it 
             */
            "You key in the combination on the keypad. ";
            st8DoorLock.resetCombo();
            st8DoorLock.addToCombo(internCombo);
        }
    }

    dobjFor(EnterOn) remapTo(EnterOn, st8DoorLock, IndirectObject)
    dobjFor(TypeLiteralOn) remapTo(TypeLiteralOn, st8DoorLock, IndirectObject)

    dobjFor(Knock)
    {
        action()
        {
            "The sound of your knocking echoes down the tunnel. ";

            if (steamTunnel8.workersPresent)
            {
                "The door opens, revealing a large man in bright green
                overalls.  He steps out, along with another, shorter
                man dressed the same way, and they close the door. ";

                st8Workers.workerEntry(nil);
            }
            else
                "There doesn't seem to be any response. ";
        }
    }
;

++ st8DoorLock: Keypad, Fixture
    'mechanical-keypad keypad (door) lock locking (key)
    key-pad/pad/lock/mechanism/keypad'
    'keypad lock'
    "It's a kind of lock you've seen before in offices and other
    public buildings.  The keypad has push-buttons labeled 0 to 9,
    arranged in two columns, plus a larger <q>Reset</q> button at
    the bottom. "

    /* reset the combination */
    resetCombo() { comboAcc = ''; }

    /* add a string of digits to the combination */
    addToCombo(digits) { comboAcc += digits; }

    /* 
     *   the combination accumulator - as buttons are pressed, we keep
     *   track of the combination so far 
     */
    comboAcc = ''

    dobjFor(EnterOn)
    {
        verify() { }
        action()
        {
            local combo;

            /* get the literal string we're entering */
            combo = gLiteral;

            /* remove spaces and dashes */
            combo = rexReplace('<space|->', combo, '', ReplaceAll, 1);

            /* make sure it looks valid */
            if (rexMatch('[0-9]+', combo, 1) != combo.length())
            {
                "You can only enter digits on the keypad. ";
                return;
            }

            /* add the digits */
            addToCombo(combo);

            /* let them know it worked */
            "You push the buttons in sequence: ";
            for (local i = 1, local len = combo.length() ; i <= len ; ++i)
            {
                say(combo.substr(i, 1));
                if (i != len)
                    "-";
            }
            ". The mechanism in the keypad clicks with each button push. ";
        }
    }
    dobjFor(TypeLiteralOn) asDobjFor(EnterOn)
;
+++ Button, Component
    '(lock) (keypad) numbered metal 0 1 2 3 4 5 6 7 8 9 "reset"
    push-button/button*buttons*push-buttons'
    'lock keypad button'
    "Numbered buttons labeled 0 to 9 are arranged in two columns, and
    at the bottom is a larger button labeled <q>Reset.</q> "

    dobjFor(Push) { action() { "(You don't need to push the buttons
        individually; just enter the combination on the keypad.) "; } }
;

+++ Button, Component
    '"reset" metal push-button/button*buttons*push-buttons'
    '<q>Reset</q> button'
    "It's a metal push-button labeled <q>Reset.</q> "

    dobjFor(Push)
    {
        action()
        {
            "The mechanism inside the lock clicks several times as
            you push in the button. ";
            location.resetCombo();
        }
    }
;

++ SimpleNoise
    desc = "You think you hear voices on the other side of the door. "
    soundPresence = (steamTunnel8.workersPresent)
;

/* ------------------------------------------------------------------------ */
/*
 *   The network room in the tunnels 
 */
networkRoom: Room 'Network Room' 'the network room'
    "The door outside is labeled <q>Supplies,</q> but that's apparently
    out of date; it looks like this is actually being used as a network
    control room.  The room is dominated by a floor-standing network
    router box, connected to which are hundreds of orange, white,
    and yellow network cables.  The cables are gathered into giant
    bundles the size of fire hoses, which feed into conduits leading
    out through the walls.
    <.p>A lone blue network cable comes in through a small hole in
    the wall next to the door, which leads out of the room to the east. "

    vocabWords = 'network room'

    east = nrDoor
    out asExit(east)

    /* award points on first arrival */
    afterTravel(traveler, conn)
    {
        scoreMarker.awardPointsOnce();
        inherited(traveler, conn);
    }
    scoreMarker: Achievement { +5 "getting into the network room" }

    roomParts = static (inherited - defaultEastWall)
;

+ nrDoor: Door ->st8Door 'east e door' 'door'
    "The door leads out of the room to the east. "

    dobjFor(Lock)
    {
        verify() { logicalRank(50, 'auto-locking'); }
        action() { "There's no obvious way to lock the door; it probably
            locks automatically when closed. "; }
    }
    dobjFor(Unlock)
    {
        verify() { logicalRank(50, 'auto-locking'); }
        action() { "There's no obvious way to unlock it, but the door
            can be opened from this side without unlocking it. "; }
    }
;

+ Fixture 'east e wall*walls' 'east wall'
    "A blue wire is threaded through a small hole in the wall next
    to the door. "
;
++ nrHole: Fixture 'small tiny hole' 'small hole'
    "The hole is right next to the door.  A blue network cable comes
    in through the hole. "
    lookInDesc = "A blue network wire is threaded through the hole. "
;

+ PlugAttachable, PermanentAttachment, Immovable
    'lone blue network wire/cable' 'blue network cable'
    "The blue wire is threaded through a small hole in the wall,
    next to the door.  It joins into one of the big bundles of
    cables---but it's the only blue wire, so it's easy to follow it to
    the router box, where it terminates in one of the router sockets.
    <.p>There's obviously no way to trace the blue wire's physical
    connection any further; the router must connect to the main
    campus network, so the camera is effectively connected to every
    computer on campus.  The only way to trace it from here would be
    to hook up a network analyzer and see where the data packets are
    going.
    <.reveal need-net-analyzer> "

    attachedObjects = [nrRouter, nrRouterSockets]
    cannotDetachMsg(obj) { return 'You\'re probably better leaving it as
        it is, so no one gets suspicious that you\'re snooping around. '; }

    isNominallyIn(obj) { return obj == nrHole || inherited(obj); }
;

+ nrConduits: Fixture 'conduits' 'conduits'
    "Big bundles of network cable feed through the conduits, which
    presumably lead out to nearby buildings. "
    isPlural = true

    dobjFor(LookIn) asDobjFor(Examine)
;

+ PlugAttachable, PermanentAttachment, Immovable
    'big giant white yellow orange network wire/wires/cable/cables/bundles'
    'bundles of cable'
    "Hundreds of white, yellow, and orange cables are connected to the
    router.  The cables are gathered into giant bundles, which feed into
    conduits. "
    isPlural = true

    isNominallyIn(obj)
    {
        return obj == nrConduits || obj == nrRouterSockets || inherited(obj);
    }

    attachedObjects = [nrRouter, nrRouterSockets]
    cannotDetachMsg(obj) { return 'You shouldn\'t do that; you don\'t want
        to interrupt anyone\'s network service. '; }
;

+ nrRouter: PlugAttachable, NearbyAttachable, Heavy
    'floor-standing network router box' 'network router'
    "It's a big piece of equipment, the size of a tall bookcase.
    Hundreds of network wires are connected to sockets arrayed across
    the front of the box.  One one side is a multi-prong diagnostic jack. "

    cannotDetachMsg(obj) { return 'You shouldn\'t do that; you don\'t
        want to interrupt anyone\'s network service. '; }

    iobjFor(PutIn) remapTo(PlugInto, DirectObject, self)
;

/* 
 *   An object representing all of the sockets, and any individual socket
 *   that we don't otherwise enumerate with its own object.
 */
++ nrRouterSockets: PermanentAttachment, Component
    'network socket/sockets' 'network sockets'
    "The router has hundreds of sockets; wires are connected to most
    of them. "

    isPlural = true

    dobjFor(LookIn) asDobjFor(Examine)
    iobjFor(PutIn) { verify() { illogical('{That dobj/he} doesn\'t
        look like it will fit any of the network sockets. '); } }
    iobjFor(PlugInto) asIobjFor(PutIn)
    iobjFor(AttachTo) asIobjFor(PutIn)
;

++ PluggableComponent
    'diagnostic multi-prong jack/port/socket' 'diagnostic jack'
    "It's a jack for a special kind of connector, probably for
    a network analyzer.<.reveal need-net-analyzer> "

    iobjFor(PutIn) remapTo(AttachTo, DirectObject, self)
;

