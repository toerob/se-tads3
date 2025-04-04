#charset "utf-8"
#include <adv3.h>
#include <sv_se.h> 

emma: Actor 'Emma' 'Emma'
    "Emma är din fru.  "   
    isProperName = true
    isHer = true
    location = kitchen
;

+emmaSearchingState: ActorState
    specialDesc = "Emma är här. Hennes mål verkar var att hitta något i ditt bagage."
    isInitState = true
;


++HelloTopic, StopEventList
    eventList = [
     
     '<q>Hej älskling! Har du någon aning om var vi la pizzastenen?</q>, frågar hon med ett leende. <.convnode pizzasten>',
     
     '<q>Hej igen!</q>
        \b<q>
        Hej!</q>'
    ];

++ConvNode 'pizzasten';
+++NoTopic 'Nej'
    "<q>Nej, tror du inte att den hamnade med de övriga köksgrejerna som flyttgubbarna kommer med imorgon?</q> frågar du tillbaka.\b
    <q>Hmm, nej det tror jag inte. Jag minns att jag var rädd att den skulle spricka så jag har för mig jag la den i i någon av dina väskor</q>, svarar hon. \b
    <q>Är det inte mycket det äktenskapet handlar om? Att maken bär fruns stenar?</q> retas du och duckar när det kommer en socke flygandes. ";




/*
"<q>Hey darling!</q> Do you have any idea where we put the wine bottle we bought on our way here? She asks. ";
*/

// Försvenska