#charset "utf-8"
/* 
 *   Copyright 2003, 2013 Michael J. Roberts
 *   
 *   Return to Ditch Day - "About" information (credits, version, help,
 *   and so on).  
 */

#include <adv3.h>
#include <sv_se.h>

/*
 *   versionInfo - The library expects us to provide an object with this
 *   name to supply some basic information about the game: the name,
 *   version number, author, and so on.  This object also provides methods
 *   for handling a few standard system verbs, such as CREDITS and ABOUT.
 *   The library uses the information here to generate a GameInfo.txt file,
 *   which we store in the compiled .t3 file as a resource for use by the
 *   HTML TADS Game Chest feature and any other tools that wish to extract
 *   the information.  
 */
versionInfo: GameID
    name = 'Tillbaka till Skolkdagen'
    version = '2-sv1'
    byline = 'av Michael J.\ Roberts'
    htmlByline = 'av <a href="mailto:mjr_@hotmail.com">'
                 + 'Michael J.\ Roberts</a>'
    authorEmail = 'M.J. Roberts <mjr_@hotmail.com>'
    desc = 'Det har gått ett decennium sedan du tog examen, men nu
        ser det ut som att du måste lösa ytterligare en
        Stapelutmaning.
        \\nDu spelar en Caltech-alumn vars arbetsgivare, ett stort företag, 
        skickar dig tillbaka till campus för att rekrytera en stjärnstudent. Men
        när du kommer dit, finner du rollerna omvända när din
        kandidat sätter dig på prov för att få bli hans arbetsgivare. Vad måste
        du lyckas med för att vinna din nya rekryt? Bara lösa en liten Stapelutmaning, förstås.
        \\nTillbaka till Skolkdagen är ett omfattande interaktivt
        äventyr, delvis skattjakt, delvis mysterium, delvis science
        fiction. Det skrevs som en demonstration och exempel
        på TADS 3, den senaste generationen av TADS författarverktyg
        för Interaktiv Fiktion, men det är inte bara en demo -
        det är ett fullfjädrat spel, med en expansiv och detaljerad
        miljö, en fängslande handling, en uppsättning excentriska karaktärer,
        och massor av utmanande och logiska pussel. Och spelet
        ger dig en ovanlig mängd kontroll över hur
        historien utvecklas: du kan helt enkelt sträva efter dina "officiella" mål,
        eller så kan du också undersöka ett invecklat dolt mysterium.'
    firstPublished = '2005'
    genre = 'Collegiate, Science Fiction, Akademiskt'
    IFID = 'TADS3-8D099951E22943028997AFE0FAA294FD'
    
    

    /* a "serial number" constructed from the date */
#ifdef QA_TEST_MODE
    serialNum = 'QA-TEST-BUILD'
#else
    serialNum = static releaseDate.findReplace('-', '', ReplaceAll, 1)
#endif

    /* 
     *   show the version information - override this to use a special
     *   format that includes the date-based serial number 
     */
    showVersion()
    {
        "<i><<name>></i> Version <<version>> (<<serialNum>>)\n";
    }

    /* 
     *   Handle the CREDITS command.  We show our production credits,
     *   acknowledgments, and disclaimers here.  
     */
    showCredit()
    {
        "<i>Tillbaka till Skolkdagen</i> skrevs ursprungligen av Michael J.\ Roberts och denna 
         översättning av mig Tomas Öberg har publicerades med hans vänliga godkännande.
         Översättningen är till stor del genomförd med hjälp av Tabnine/Claude och ChatGpt. 
         Därefter har jag själv sett över textöversättningarna efteråt för att se till att 
         formuleringar och uttryckssätt låter svenska. 
        <br><br>
         Här nedan följer originaltexten från Michael J.\ Roberts själv: <br><br>

        <i>Return to Ditch day</i> skrevs och programmerades av
        Michael J.\ Roberts, med hjälp av <font size=-1>TADS</font> 3
        interaktivt fiktionssystem.
        <br><br>
        Detta spel testades av Steve Breslin, Eric Eve, Kevin Forchione,
        Stephen Granade, Andreas Sewe, Dan Shiovitz och Brett Witty.
        Jag kan inte tacka dessa personer tillräckligt för att ha uthärdat de
        tidiga versionerna och erbjudit så mycket hjälpsam feedback och så
        många fantastiska idéer för förbättringar. Spelet är enormt mycket bättre
        tack vare deras generösa insatser. Tack också till Mark Engelberg,
        Tommy Herbert, Valentine Kopteltsev, Matt McGlone, Michel
        Nizette, Emily Short och Mike Snyder för att ha upptäckt ett antal
        betydande buggar i de släppta versionerna.
        <br><br>
        En del av graffittin i återgivningen här av Dabney House
        är baserad på eller (oftare) skamlöst kopierad från det verkliga
        huset. På liknande sätt är några av stackrummen löst baserade på
        verkliga 'stacks' från det förflutna. I alla fall är originalen
        mycket bättre än de dåliga imitationerna här.
        <br><br>
        Detta spel skrevs parallellt med det sista året eller så
        av arbetet med <font size=-1>TADS</font> 3 själv, så på sätt och vis
        är det en del av den insatsen. Jag vill därför tacka alla
        som bidrog via tads3-listan---era råd, idéer och
        praktiska erfarenheter av att använda systemet i dess utdragna halvfärdiga
        tillstånd har gjort hela skillnaden.
        <br><br>
        Omegatron, Mitachron, Netbisco, ToxiCola och Bioventics är
        varumärken tillhörande respektive fiktiva företag.
        J.R.R.\ Tobacco är ett varumärke tillhörande SG Naming Consultants, använt med
        tillstånd. DEI, DabniCorp och elefant-och-sköld-designen
        är varumärken tillhörande Dabney Hovse.
        <br><br>
        <b>Detta är ett fiktivt verk.</b> Alla personer, platser, organisationer
        och händelser i denna berättelse är produkter av författarens fantasi
        eller används fiktivt, och all likhet med verkligheten är helt
        slumpmässig. Inget i detta spel är menat att på något sätt reflektera
        det verkliga Caltech eller någon associerad med det. Självfallet så var inte Caltech involverat i skapandet av detta verk.
        Men nästa gång du planerar att söka en högre utbildning, varför inte
        överväga Caltech? Beläget nära foten av San Gabriel-bergen
        i Pasadena erbjuder Caltech en unik studentupplevelse
        som sällan sägs orsaka bestående skador.
        Besök <a href='http://www.caltech.edu'>www.caltech.edu</a> idag.
        <br><br>
        För information om att skriva ditt eget spel med
        <font size=-1>TADS</font>, besök den officiella webbplatsen på
        <a href='http://www.tads.org'>www.tads.org</a>.
        <br><br>
        Copyright &copy;2004, 2013 Michael J.\ Roberts. Alla rättigheter förbehållna.
        Skriv <<aHref('copyright', 'COPYRIGHT')>> för licensinformation. ";

    }


    /* 
     *   Handle the COPYRIGHT command.  We show our copyright message and
     *   license terms here. 
     */
    showCopyright()
    {
        "Copyright &copy;2004, 2013 Michael J.\ Roberts.
        Alla rättigheter förbehållna.
        <p>
        <b>Fri programvarulicens</b><br>
        Detta är ett upphovsrättsskyddat verk, vilket innebär att det är mot
        lagen att kopiera eller distribuera detta paket utan författarens
        skriftliga tillstånd. Författaren ger dig härmed
        tillstånd att använda, kopiera och vidaredistribuera denna programvara, utan
        kostnad, med följande villkor: du får inte ändra eller ta bort
        någon upphovsrättsnotis eller licensnotis i verket; du får inte
        ta ut en avgift för kopior av denna programvara, förutom en nominell
        avgift för att täcka kostnaden för att fysiskt göra kopian; du får
        inte distribuera modifierade eller ofullständiga versioner; och du får inte
        påtvinga några ytterligare licensvillkor med avseende på detta verk
        på mottagare av kopior du gör eller distribuerar.

        <p>Denna programvara har INGEN GARANTI av något slag, uttryckt eller
        underförstådd, inklusive utan begränsning de underförstådda garantierna
        om säljbarhet och lämplighet för ett visst syfte.

        <p>
        Om du har några frågor om denna licens, vänligen kontakta
        författaren på
        <a href='mailto:mjr_@hotmail.com'>mjr_@hotmail.com</a>. 
        
        Denna översättning är gjord med tillstånd från upphovsrättsinnehavaren. Vid tveksamhet gäller den engelska originaltexten, som följer:

        Copyright &copy;2004, 2013 Michael J.\ Roberts.
        All rights reserved.
        <p>
        <b>Free Software License</b><br>
        This is a copyrighted work, which means that it's against the
        law to copy or distribute this package without the author's
        written permission.  The author hereby grants you
        permission to use, copy, and redistribute this software, without
        charge, with the following conditions: you may not alter or remove
        any copyright notice or license notice in the work; you may not
        collect a fee for copies of this software, except for a nominal
        fee to cover the cost of physically making the copy; you may
        not distribute modified or incomplete versions; and you may not
        impose any additional license terms with respect to this work
        on recipients of copies you make or distribute.

        <p>This software has NO WARRANTY of any kind, expressed or
        implied, including without limitation the implied warranties
        of merchantability and fitness for a particular purpose.

        <p>
        If you have any questions about this license, please contact
        the author at
        <a href='mailto:mjr_@hotmail.com'>mjr_@hotmail.com</a>.
        ";
    }

    /* 
     *   Handle the ABOUT command.  By convention, this command gives the
     *   player a brief summary of anything unusual about the game - not
     *   full instructions on how to play, but a mention of any commands or
     *   other features that differ from the typical conventions of modern
     *   IF.  The idea is that we assume the player is already familiar
     *   with IF in general, so we just want to alert her to any quirks
     *   this game has.  Frequently, the command also provides a bit of
     *   background information about the game.  
     */
    showAbout()
    {
        "<img src='.system/CoverArt.jpg?id=<<rand('z{32}')>>'><br>";
        "Välkommen till <i>Tillbaka till skolkdagen</i>!
        <.p>
        Om du är nybörjare inom Interaktiv Fiktion kan det vara 
        hjälpsamt att läsa vår IF-instruktionsmanual---skriv bara
        <<aHref('instructions', 'INSTRUKTIONER')>> vid kommandoprompten.

        <.p>
        Detta spel använder standardkommandon som de flesta IF-spel använder,
        men det finns några extrafunktioner som är värda att nämna.
        Du kan <b>PRATA MED</b> en karaktär för att hälsa på dem (detta är
        valfritt, dock: du kan alltid bara FRÅGA eller BERÄTTA FÖR dem
        om något istället). När du pratar med någon kan du
        förkorta <b>FRÅGA person OM ämne</b> till helt enkelt
        <b>F ämne</b>, och <b>BERÄTTA FÖR person OM ämne</b> till
        <b>B ämne</b>. <b>ÄMNEN</b> visar dig en lista över saker
        din karaktär är intresserad av att diskutera---men notera
        att du aldrig är begränsad till vad som finns på listan, och listan
        kanske inte visar allt som är viktigt att prata om.

        <.p>Berättelsen kan ibland ge några speciella
        förslag när du pratar med någon, som detta:

        \b\t(Du skulle kunna be om ursäkt för att ha sönder vasen, eller berätta 
        \n\tom utomjordingarna.)

        <.p>Dessa är speciella alternativ som du kan använda i det ögonblick
        de föreslås. Du behöver inte oroa dig för att memorera
        dem eller försöka använda dem vid andra slumpmässiga tillfällen i berättelsen; de
        fungerar bara under den tur de erbjuds. Om du vill använda ett
        av förslagen, skriv bara in det; du kan vanligtvis förkorta
        till det första ordet eller två när förslaget är långt:

        \b\t&gt;BE OM URSÄKT

        <.p>Observera att du aldrig är begränsad till de erbjudna förslagen.
        Du kan alltid använda ett vanligt kommando istället, som FRÅGA eller
        BERÄTTA, eller till och med ignorera karaktären helt.

        <.p>För många år sedan skrev jag ett spel som hette <i>Ditch Day Drifter</i>
        som ett exempelspel för den första versionen av <font size=-1>TADS</font>,
        mitt IF-utvecklingssystem. Detta är väldigt löst en uppföljare till det
        spelet, men om du inte har spelat originalet, oroa dig inte---du
        kan spela det här spelet helt på egen hand. Det finns inget du behöver
        veta från det tidigare spelet för att spela detta.
        
        <.p>Det finns inga situationer <q>omöjliga att överkomma</q>  i detta spel:
        det finns inget sätt för din karaktär att dödas, och du kan inte
        av misstag låsa dig ute från att slutföra berättelsen. Om du
        någonsin fastnar ordentligt kan du skriva <<aHref('hint', 'LEDTRÅD')>>
        för att få tillgång till inbyggda ledtrådar. ";
    }
;

/* ------------------------------------------------------------------------ */
/*
 *   Provide a HELP command.  A player who's completely lost might think to
 *   try typing HELP, so it's best to offer some assistance here.  Since we
 *   have a number of special commands that provide specific kinds of help,
 *   we'll simply list those other commands here.  
 */
DefineSystemAction(Help)
    execSystemAction()
    {
        "För mer information kan du skriva något av 
        följande i valfri kommandoprompt:

        \b<<aHref('about', 'OM')>> - för lite allmän bakgrundsinformation
        om detta spel

        \n<<aHref('copyright', 'COPYRIGHT')>> - för att visa upphovsrätts- och
        licensinformation

        \n<<aHref('credits', 'CREDITS')>> - för att visa spelets eftertexter
        
        \n<<aHref('hints', 'LEDTRÅD')>> - för att få tillgång till de inbyggda ledtrådarna

        \n<<aHref('instructions', 'INSTRUKTIONER')>> - för allmänna
        instruktioner om hur man spelar detta spel ";
    }
;
VerbRule(Help) 'hjälp' : HelpAction
    verbPhrase = 'visa/visar hjälpinformation'
;

/* ------------------------------------------------------------------------ */
/* 
 *   Provide a COPYRIGHT command.  This simply shows the license
 *   information from the versionInfo object. 
 */
DefineSystemAction(Copyright)
    execSystemAction() { versionInfo.showCopyright(); }
;
VerbRule(Copyright) 'copyright' | 'licens' : CopyrightAction
    verbPhrase = 'visa/visar copyrightinformation'
;
