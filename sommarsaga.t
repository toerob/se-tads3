#charset "utf-8"
#include <adv3.h>
#include <sv_se.h>

sommarsagaGlobal: object
	showIntro() {
		"Det var en varm sommardag (1925). Emma var ensam ute på gården. Mamma var inne och bakade. Pappa var i kyrkan. "; // Begravning
	}
;

tradgarden: OutdoorRoom 'Trädgården' 'trädgården'
	south = husdorrenUtsida
	northwest = kallkallaredorrUtsida
	east = vedboddorrUtsida
;

+villan: Decoration 'villa[-an]*villor[-na]' 'villan';
+husdorrenUtsida: Door -> husdorrenInsida 'dörr[-en]*dörrar[-na]' 'dörr';
+kallkallaredorrUtsida: Door  'dörr[-en]*dörrar[-na]' 'dörr';
+vedboddorrUtsida: Door -> vedboddorrInsida 'dörr[-en]*dörrar[-na]' 'dörr';


farstu: Room 'Farstun' 'farstun'
	north = husdorrenInsida
;
+husdorrenInsida: Door -> husdorrenUtsida 'dörr[-en]*dörrar[-na]' 'dörr'
;

kallkallare: Room 'kallkällare' 'kallkällaren'
	"Kallkällaren var fuktig och Emma möttes av rå luft då hon gick in. Det var ett litet rektangulärt utrymme där det fanns treplanshyllor mot vardera vägg. "
	southeast = kallkallardorrInsida
;

+kallkallardorrInsida: Door -> kallkallaredorrUtsida 'dörr[-en]*dörrar[-na]' 'dörr';

+lingonberries: Food 'lingon[-en]*lingon' 'lingon'
	initSpecialDesc = "Några glasburkar lingon"
	isPlural = true
;

emma: Actor 'Emma' 'Emma' @tradgarden
	isProperName = true
	referralPerson = ThirdPerson
	beforeAction {
		if(getOutermostRoom == tradgarden && gActionIs(South)) {
		"Emma kände inte för att gå in. Då skulle bara hennes mamma be henne hjälpa till. ";
		exit;
		}
		inherited;
	}
;

vedbod: Room 'Vedboden' 'vedboden'
	"Vedboden hade ganska lite ved kvar. Den mesta hade använts upp under vintern. "
;

+vedboddorrInsida: Door 'dörr[-en]*dörrar[-na]' 'dörr';

+tomte: Actor 'tomte[-n]' 'tomte'
	isHe = true
	isHer = nil
	isProperName = nil // TODO: fungerar inte. "Tomte står där."
;
