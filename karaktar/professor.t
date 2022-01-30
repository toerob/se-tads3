#charset "UTF-8"
#include <adv3.h>
#include <sv_se.h>



professor:Actor 'p/professor/professorn*professorerna' 'professor' @labbet
    theName = 'professorn'
    isHim = true
;

+professorState: ActorState 
    isInitState = true
    specialDesc = "En galen professor står här och mixtrar med kemikalier. "
;


++HelloTopic "<q>Hej!</q>, säger du. Professorn muttrar något obegripligt till svar. ";
++ByeTopic "<q>Vi hörs!</q>, säger du. Professorn viftar med handen, <q>Jaja! Visstvisst!</q>";
