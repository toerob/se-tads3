#charset "utf-8"
#include <adv3.h>
#include <sv_se.h> 

// Attention: requires "-source dynfunc" in your Makefile.


/*
 *   ************************************************************************
 *   eval.t (copy-pasted from debug.t and modified quite a bit)
 *  
 *   (c) 2012-13 Eric Eve (but based partly on code borrowed from the Mercury
 *   library (c) Michael J. Roberts).
 *   
 *   Inspired from the the code in adv3Lite/Mercury library by Eric Eve and 
 *   Michael J. Roberts, and adapted to adv3 by Tomas Öberg
 *
 */

#ifdef __DEBUG

evaluatePreParser: StringPreParser 
    doParsing(str, which) {
        if(str.toLower.startsWith('eval ') && !str.endsWith('"')) {
            str = str.splice(6, 0, '"') + '"';
        }
        return str;
    }
;
/* The EVALUATE action allows any expression to be evaluated */
DefineLiteralAction(Evaluate)
    
    /* 
     *   Do we want to use Compiler.compile rather than Compiler.eval()? By default we do since this
     *   circumvents a bug on FrobTADS for Limux users.
     */
    
    useCompile = true
    
    execAction() {
        try {
             
            // Try using the Compiler object to evaluate the expression
            // contained in the name property of the direct object of this
            // command (i.e. the string literal it was executed upon).
            local str = stripQuotesFrom(gLiteral);
            if(str == '') {
                tadsSay('[Uttryck saknas. Användningsexempel, "eval 5+5" eller "eval gPlayerChar.theName()"]\n');
                return;
                
            }

            local res;
            if(useCompile) {
                local func = Compiler.compile(str);
                res = func();
            }
            else {
               res = Compiler.eval(str);
            }
            
            if(dataType(res) == TypeEnum) {
                local str = 'TODO: handle enums. Adv3Lite: enumTabObj.enumTab[res]';
                if(str) res = str;
            }
            
            /* Display a string version of the result */
            say(toString(res));
        }
        /* 
         *   If the attempt to evaluate the expression caused a compiler error,
         *   display the exception message.
         */
        catch (CompilerException cex) {           
            cex.displayException();
        }
        
        /* 
         *   If the attempt to evaluate the expression caused any other kind of
         *   error, display the exception message.
         */
        catch (Exception ex) {
            ex.displayException();
        }
        
    }
    includeInUndo = true
    afterAction() {}
    beforeAction() { }    
    turnSequence() { }
;

VerbRule(Evaluate)
    'eval' singleLiteral  // literalPhrase->literalMatch
    : EvaluateAction
    verbPhrase = 'evaluera/evaluering (vad)'
;

#endif // __DEBUG

