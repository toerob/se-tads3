#charset "UTF-8"

/*
 *   Copyright (c) 1999, 2002 by Michael J. Roberts.  Permission is
 *   granted to anyone to copy and use this file for any purpose.  
 *   
 *   This is a starter TADS 3 source file.  This is a complete TADS game
 *   that you can compile and run.
 */

#include <adv3.h>

#include "sv_se.h" //en_us.t



   

gameMain: GameMainDef
    //initialPlayerChar = me
    //initialPlayerChar = argon
    //initialPlayerChar = maria
    initialPlayerChar = karl
    //initialPlayerChar = emma
    //initialPlayerChar = julia
    usePastTense = true    
    

    showIntro() {

        if(initialPlayerChar == emma) {
            sommarsagaGlobal.showIntro();
        }
        if(initialPlayerChar == julia) {
            juliaGlobal.showIntro();
        }

        tadsSay('*****', new SwedishInflector().inflect('stol[b,ut,s]'));
        tadsSay('*****', new SwedishInflector().get_all_forms('stol')['indefinite_singular']);
        tadsSay('*****', new SwedishInflector().get_all_forms('stol')['definite_singular']);
        tadsSay('*****', new SwedishInflector().get_all_forms('stol')['indefinite_plural']);
        tadsSay('*****', new SwedishInflector().get_all_forms('stol')['definite_plural']);
    }
;


translateManager: PreinitObject
    //execAfterMe = [adv3LibPreinit]
    execute() {

        "<<stugdorrenOutside.theName>>";
    }

    readDictionaryFile(filename) {
        local result = new LookupTable();
        try {
            local file = File.openTextFile(filename, FileAccessRead);
            if(file) {
                local row;
                while((row = file.readFile()) != nil) {
                    if(row) {
                        local information = row.split('/');
                        if(information.length==2) {
                            result[information[1]] = information[2];
                        }
                        //"<<row>>";
                    }
                }
               
                file.closeFile();
            }
        }
        catch(FileNotFoundException e) {
        // Noop - since no file has been created yet, this exception is expected first time around.
        } catch(FileException e) {
            "File expection occured when trying read last location from <<filename>>: <<e.exceptionMessage>> ";
        }
        return result;
    }


    readDataFile(filename) {
        local result = [];
        try {
            local file = File.openTextFile(filename, FileAccessRead);
            if(file) {
                local row;
                while((row = file.readFile()) != nil) {
                    if(!row.startsWith('#')) {

                        if(row.startsWith('SFX')) {
                            result += row;

                            local column = row.split(' ');
                            if(column.length >= 1) {
                                "<<column[2]>>";
                            }
                        }
                    }
                }
               
                file.closeFile();
            }
        }
        catch(FileNotFoundException e) {
        // Noop - since no file has been created yet, this exception is expected first time around.
        } catch(FileException e) {
            "File expection occured when trying read last location from <<filename>>: <<e.exceptionMessage>> ";
        }
        return result;
    }
    
;


versionInfo: GameID
    IFID = '' // obtain IFID from http://www.tads.org/ifidgen/ifidgen
    name = 'Exempel 1'
    byline = 'av Tomas Öberg'
    htmlByline = 'av <a href="mailto:tomaserikoberg@gmail.com">Tomas Öberg</a>'
    version = '1'
    authorEmail = 'Tomas Öberg tomaserikoberg@gmail.com'
    desc = 'Exempel 2'
    htmlDesc = 'Exempel 2'
;

me: Actor 'du' 'du' @labbet;



//FIXME: x stol (om det finns flera att välja på)