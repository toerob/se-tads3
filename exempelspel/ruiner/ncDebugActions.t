#charset "utf-8"

/*
 * Real NC Debug Actions Module, version 1.1
 * Copyright (C) 2002, Nikos Chantziaras.
 * Comments and bug reports should be sent to:
 * realnc@lycos.de
 *
 * The copyright holder hereby grants the rights of usage, distribution
 * and modification of this software to everyone and for any purpose, as
 * long as this license and the copyright notice above are preserved and
 * not modified.  There is no warranty for this software.  By using,
 * distributing or modifying this software, you indicate that you accept
 * the terms and conditions of this license.
 */

/*
 * The documentation of this module is based on the documentation for
 * Neil K. Guy's and Neil deMause's "wizard.t" module for Tads 2.
 * Although this module is inspired by "wizard.t", no code from it is
 * used here, which is natural, since this is Tads 3 code.
 */

/*
 * Sometimes, when debugging an adventure, it's useful to have a small
 * set of special verbs that let you do things the player can't
 * ordinarily do.  These shortcuts can be extremely useful in cutting
 * down test time, as they help you skip sections of a game that you
 * know are fine.  Here are a few verbs that I've found quite helpful
 * for testing games.
 *
 * "Snarf" lets you pick up any takeable object, regardless of whether
 * it's visible and in scope or not.  "Zarvo" reports on the location
 * of any specified object.  "Pow" transports the player directly to
 * any location in the game.  And "Mega" and "Unmega" turn the player
 * into a glowing superhuman, or revert the player to normal.
 *
 * To use this module, just compile it together with your game's source
 * file(s).  Don't forget to compile for debugging (by using the
 * compiler's -d option).  When you compile for release, the module
 * won't be included in your game.
 *
 * Implemented and tested with Tads v3.0.5 using a GNU/Linux system.
 */

/*

Version history
===============

1.1
---

 - None of the actions can now be directed to actors other than the
   player character.  This is especially important for the pow action;
   pow would result in a run-time error if directed to an NPC.

 - Fixed the pow action.
   Powing to a location now calls the travelerLeaving() method of the
   current location and the travelerArriving() method of the
   destination.  Also, the powing is done with moveIntoForTravel(), not
   with moveInto().

 - Fixed the snarf action.
   The snarf action wasn't able to remove an object from a closed
   container if the player character and the container were both in the
   same location.

 - Intangible and Distant items are now allowed with pow and zarvo.

 - Fixed som stoopid end very embarasing dokumentation typoes and
   speling mistacles, althu meny ar steel thear. ;-)

 - Added version history.

1.0
---

 - ???

*/


#ifdef __DEBUG


#include <adv3.h>
#include <sv_se.h>


/* --------------------------------------------------------------------
 * Snarf
 *
 * This verb lets you pick up any takeable item, even if it's not
 * accessible to you - say it's in a different room or inside a closed
 * container or whatever.
 *
 * I gave it the silly name "snarf" as "snarf" is not a verb I'm likely
 * to use in the actual game for anything.  You can, of course, change
 * this to something more serious.
 *
 * Essentially, all this verb does is call the dobjFor(Take) handler.
 * The reason I have it do that instead of, say, moving the object
 * directly into the player's inventory, is because this way I can rely
 * on the standard Take checks to ensure that the player isn't trying
 * to pick up a fixed or decoration object or whatever.  Also, the
 * player can't pick up more items than he or she normally can (unless
 * the "mega" verb has been used; see below.)
 *
 * However, "snarf" differs from the normal take verb in that instead
 * of checking to see if the object in question is in scope or not, it
 * simply lets you take any object that's anywhere in the game.  It
 * does this by overriding the objInScope() method of TAction.  Snarf
 * also doesn't care if the object is in a closed container.  This is
 * done by modifying the checkMoveViaPath() method of Container.
 * Furthermore, the only preconditions for snarf are objNotWorn (the
 * object must not currently being worn) and roomToHoldObj (there must
 * be enough room for the object in the PC's inventory).
 */

DefineTAction(Snarf)
	// We want all objects to be in scope, so we always return true
	// here.
	objInScope( obj ) { return obj.ofKind(Thing); }

	execAction()
	{
		if (!gActor.isPlayerChar) {
			libMessages.systemActionToNPC();
			exit;
		}
		inherited;
	}
;

VerbRule(Snarf)
	('snarf' | 'snarfa' | 'purloin' | 'pn') dobjList
	: SnarfAction
	verbPhrase = 'snarfa/snarfar (vad)'
;

modify Thing {
	dobjFor(Snarf)
	{
		// We do not require the object to be touchable to snarf it.
		// But we still require that it's not being worn, and that the
		// PC has enough room in his inventory to hold it.
		preCond = [objNotWorn, roomToHoldObj];

		// Everything else works the same as with the Take action.
		verify() { verifyDobjTake(); }
		remap() { return remapDobjTake(); }
		check() { checkDobjTake(); }
		action() {
		           if( ofKind(Hidden) ) discover;
		             moveIntoForTravel(gActor); 
		             "{Ref dobj/den} dyker upp i {dina} händer. ";
		          }
	}
}

modify TravelPushable
  dobjFor(Snarf)
  {
     verify() { delegated Thing.verifyDobjTake(); }
  }
;



modify Container {
	// checkMoveViaPath() is defined in the Thing class, but the
	// Container class overrides this method to check if the container
	// is closed and, if it is, disallows the action.  Since snarf must
	// be able to take objects even from closed containers, we need to
	// modify this method.
	checkMoveViaPath( obj, dest, op )
	{
		// Allow the operation if the current action is snarf.
		if (gActionIs(Snarf)) return checkStatusSuccess;

		// Otherwise, do whatever was the default.
		return inherited(obj, dest, op);
	}
}



/* --------------------------------------------------------------------
 * Zarvo
 *
 * Another useful verb with a silly name.  Zarvo lets you find an
 * object anywhere in the game without touching it.  Zarvoing an object
 * simply prints that object's current location's `name' property.
 */

DefineTAction(Zarvo)
	objInScope( obj ) { return true; }

	execAction()
	{
		if (!gActor.isPlayerChar) {
			libMessages.systemActionToNPC();
			exit;
		}
		inherited;
	}
;

VerbRule(Zarvo)
	('zarvo' | 'v') dobjList
	: ZarvoAction
	verbPhrase = 'zarvo/zarvoerar (vad)'
;

modify Thing {
	dobjFor(Zarvo)
	{
		preCond = [];

		verify() {}
		check() {}

		action()
		{
			"\^<<self.theName>> ";
			if (!self.location) {
				"flyter omkring i intet av den yttre rymden. ";
			} else {
				"<<self.verbToBe>> på platsen som kallas <q><<self.location.name>></q>. ";
			}
		}
	}
}

/* We want Decoration, Intangible and Distant items to work with zarvo,
 * so we also define dobjFor(Zarvo) handlers for them.
 */
modify Decoration {
	dobjFor(Zarvo)
	{
		// Just do what we defined in Thing.
		preCond() { return inherited; }
		verify() { inherited; }
		check() { inherited; }
		action() { inherited; }
	}
}

modify Intangible {
	dobjFor(Zarvo)
	{
		preCond() { return inherited; }
		verify() { inherited; }
		check() { inherited; }
		action() { inherited; }
	}
}

modify Distant {
	dobjFor(Zarvo)
	{
		preCond() { return inherited; }
		verify() { inherited; }
		check() { inherited; }
		action() { inherited; }
	}
}


/* --------------------------------------------------------------------
 * Pow
 *
 * This is a particularly useful verb when testing that zaps you
 * directly to a specific location as though you'd teleported there.
 * Saves a lot of walking around.  To use it, simply type "pow"
 * followed by the location to which you wish to pow, or by an object
 * that is contained either directly or indirectly in this location, so
 * that typing "pow item" for non-room objects will take you to that
 * object's location.  This means that you can "pow" to any room with
 * at least one object in it, even if you haven't taken the step of
 * assigning nouns to your rooms.  If the specified object is nested
 * inside multiple containers, we simply traverse the locations
 * upwards, until we find one that can contain actors.  Only
 * BasicLocation objects can do that, so we simply pow the PC to the
 * first BasicLocation we found.
 *
 * We require that the player isn't seated (by specifying the
 * actorStanding precondition) to avoid problems.  This means that the
 * PC will attempt to stand up before we pow him to the new location.
 * Then we transport them directly to the chosen location by using the
 * actor's moveInto() method.  In homage to the classic "Adventure", we
 * surround the player with a nice orange cloud of smoke.
 *
 * There's one more time-consuming thing that you, as implementor, have
 * to do to be able to use this verb directly with rooms.  And that is
 * you have to assign appropriate nouns and adjectives to each room you
 * want to be powable.  If you don't, then the only way to pow to a
 * location is by using an item in that location as the direct object
 * of the verb.  This can be a bit awkward, since interactive
 * disambiguation is sometimes impossible with some objects, most
 * probably with decoration and fixed objects ("Which door do you mean,
 * the door, the door, the door, or the door?").
 *
 * So, how should you assign vocabulary words to your rooms?  They
 * shouldn't be available in the release version of your game, only in
 * the debug version.  Tads 3 defines the preprocessor symbol "__DEBUG"
 * when it compiles a game with debug information.  You could simply
 * define a macro like this:
 *
 *   #ifdef __DEBUG
 *     #define dbgNoun(x) vocabWords = x
 *   #else
 *     #define dbgNoun(x)
 *   #endif
 *
 * And assign nouns to your rooms like this:
 *
 *   kitchen: Room {
 *     'Kitchen'  'the kitchen'
 *     "You are not in front of a white house, but in the kitchen of a
 *     yellow one. "
 *     dbgNoun('kitchen-room');
 *   }
 *
 * Now you can pow to the kitchen like this:
 *
 *   >POW KITCHEN-ROOM
 */

DefineTAction(Pow)
	objInScope( obj ) { return obj.ofKind(Thing); }

	execAction()
	{
		if (!gActor.isPlayerChar) {
			libMessages.systemActionToNPC();
			exit;
		}
		inherited;
	}
;

VerbRule(Pow)
	('pow'|'gonear'|'gn') singleDobj | 'pow' 'till' singleDobj
	: PowAction
	verbPhrase = 'pow/powerar till (var)'
;

modify Thing {
	dobjFor(Pow)
	{
		// We must be standing to be able to pow.
//		preCond = [actorStanding];

		verify() {}

		check() {}

		action()
		{
			// Destination.
			local dest = gDobj.ofKind(BasicLocation) ? gDobj : gDobj.location;

			// We do a "location rewind" until we find a location that
			// can contain actors.
			while (dest) {
				if (dest == gPlayerChar.location) {
					// The location we found is the same as the PC's
					// current location.  No need to pow.
					"You are already there. ";
					return;
				}
				if (dest.ofKind(Room)) {
				    
				    if(gActor.posture != standing)
				      gActor.makePosture(standing); 
				    
					// We found a BasicLocation.  Let's pow there.
					"Du omsluts av ett moln av orange rök. Hostande och flämtande 
     			kommer du ut ur röken och upptäcker att din omgivning har förändrats... ";
		
					// Remember my original location - this is the
					// location where the PC was before he powed.
					local origin = gPlayerChar.location;

					// Tell the old room we're leaving.
					if (origin) origin.travelerLeaving(gPlayerChar, dest, nil);

					// Move to the destination.
					gPlayerChar.moveIntoForTravel(dest);

					// Tell the new room we're arriving, if we changed
					// locations.
					if (gPlayerChar.location)
						gPlayerChar.location.travelerArriving(gPlayerChar, origin, nil, nil);

					// We're done.
					return;
				}
				// One level up.
				dest = dest.location;
			}
			// We didn't find a BasicLocation.  We can't pow.
			"JAg kan inte powa dig dit. ";
		}
	}
}

/* We want Decoration, Intangible and Distant items to work with pow,
 * so we also define dobjFor(Pow) handlers for them.
 */
modify Decoration {
	dobjFor(Pow)
	{
		preCond() { return inherited; }
		verify() { inherited; }
		check() { inherited; }
		action() { inherited; }
	}
}

modify Intangible {
	dobjFor(Pow)
	{
		preCond() { return inherited; }
		verify() { inherited; }
		check() { inherited; }
		action() { inherited; }
	}
}

modify Distant {
	dobjFor(Pow)
	{
		preCond() { return inherited; }
		verify() { logicalRank(70, 'avlägsen'); }		
		check() { inherited; }
		action() { inherited; }
	}
}


/* --------------------------------------------------------------------
 * Mega
 *
 * Sometimes, in a game, you need to pick up and carry a whole plethora
 * of items, as the standard definition for the player character object
 * has set limits as to the number of objects (bulkCapacity), the
 * maximum bulk of any one object (maxSingleBulk) and the total weight
 * of objects (weightCapacity) the player can carry.  This is obviously
 * important from both a realism standpoint and also a puzzle-making
 * one.  However, it can be a total pain in the neck when testing.
 *
 * One of the features of the mega verb is that it increases the
 * strength and carrying ability of the player to superhuman levels.
 * Use the unmega command to restore the player to his or her normal
 * abilities.
 *
 * The other feature of the verb involves dark rooms.  Sometimes, when
 * playing, it's a hassle to have to carry a torch or other light
 * source all the time.  However, through the miracle of the mega verb,
 * the player can set him or herself literally glowing, thereby
 * obviating the light source problem.  People who've played any of the
 * Infocom fantasies will recognize this as a kind of "frotz me"
 * command.  Again, unmega makes the player normal once more.
 */

class MegaAction: IAction {
	// Is the PC currently in Mega mode? (Class property)
	playerIsMega = nil;

	// We save the old values so that we can restore them later with
	// the Unmega action. (Class properties)
	oldBulkCapacity   = gPlayerChar.bulkCapacity;
	oldMaxSingleBulk  = gPlayerChar.maxSingleBulk;
	oldWeightCapacity = gPlayerChar.weightCapacity;
	oldBrightness     = gPlayerChar.brightness;

	execAction()
	{
		if (!gActor.isPlayerChar) {
			libMessages.systemActionToNPC();
			exit;
		}

		if (MegaAction.playerIsMega) {
			"Du genomsyras redan av supermänskliga färdigheter. ";
		} else {
			MegaAction.oldBulkCapacity   = gPlayerChar.bulkCapacity;
			MegaAction.oldMaxSingleBulk  = gPlayerChar.maxSingleBulk;
			MegaAction.oldWeightCapacity = gPlayerChar.weightCapacity;
			MegaAction.oldBrightness     = gPlayerChar.brightness;

			gPlayerChar.bulkCapacity   = 65535;
			gPlayerChar.maxSingleBulk  = 65535;
			gPlayerChar.weightCapacity = 65535;
			gPlayerChar.brightness     = 4;

			MegaAction.playerIsMega = true;

			"Phreeeow! Du har plötsligt supermänsklig styrka, och du är omgiven av ett
			märklig etersisk lyster som tillåter dig att beträda mörka platser ostraffat! ";
		}
	}
}

VerbRule(Mega)
	'mega'
	: MegaAction
	verbPhrase = 'mega/transformerar dig till en lysande supermänniska'
;


/* --------------------------------------------------------------------
 * Unmega
 *
 * Reverses the effects of Mega.
 */

class UnmegaAction: IAction {
	execAction()
	{
		if (!gActor.isPlayerChar) {
			libMessages.systemActionToNPC();
			exit;
		}

		if (!MegaAction.playerIsMega) {
			"Du är redan en vanlig dödlig! ";
		} else {
			gPlayerChar.bulkCapacity   = MegaAction.oldBulkCapacity;
			gPlayerChar.maxSingleBulk  = MegaAction.oldMaxSingleBulk;
			gPlayerChar.weightCapacity = MegaAction.oldWeightCapacity;
			gPlayerChar.brightness     = MegaAction.oldBrightness;

			MegaAction.playerIsMega = nil;

			"Phreeeow! Du är åter en vanlig dödlig! Du har dessutom tappat din förmåga att agera mänsklig glödlampa. ";
		}
	}
}

VerbRule(Unmega)
	'unmega'
	: UnmegaAction
	VerbPhrase = 'unmega/transformerar dig till en vanlig dödlig'
;


#endif // __DEBUG

