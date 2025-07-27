# Svensk översättning av standardbiblioteket Adv3 till Tads3

Detta bibliotek möjliggör skapandet av Tads3-spel på svenska.

# Installation

1. Kopiera katalogen `sv_se` till din Tads3-installation, vanligtvis i `/usr/local/share/frobtads/tads3/lib/adv3`.
2. Alternativt, skapa en symbolisk länk:

```bash
  sudo ln -s /absolut/sökväg/till/se-tads3/lib/adv3/sv_se/ /usr/local/share/frobtads/tads3/lib/adv3/sv_se
```  

Detta alternativ kan vara fördelaktigt för att det då är lätt att hålla sig à jour med de senaste förändringar i detta repository utan att behöva kopiera något till din tads3-installation.

(TIPS: använd absolut sökväg om du skapar symbolisk länk, inte relativ.)

# Kom igång!

1. Navigera till se-tads3/exempel/snabbstart.
2. Anpassa sökvägarna i Makefile.t3m om det behövs. Följande rader måste peka på rätt plats för din maskin:

  ```t3m
  -FI /usr/local/share/frobtads/tads3/include
  -Fs /usr/local/share/frobtads/tads3/lib
  ```

3. Kör run.sh (använd chmod +x run.sh om nödvändigt).

(Kommandot `rlwrap frob -k utf8 -i plain snabbstart.t3` i `run.sh` gör att svenska tecken fungerar att läsa/skriva direkt i terminalen. `rlwrap` är en optionell wrapper som ger dig historik i dina kommandon. Du kan givetvis även använda en annan interpreter också. T ex fungerar `spatterlight`, `gargoyle` eller `lectrote` alldeles utmärkt, för att nämna några.)

# Teckenkodning

1. Använd #charset "utf-8" eller #charset "latin-1" i början av dina .t-filer för svenska tecken. (Se exempelspelen.)
2. Standardinställningen i biblioteket är utf-8.

# Hantera sammansatta ord

I den svenska översättningen finnns en speciell notation för att enkelt hantera sammansatta ord och ändelser. Till skillnad från engelska, där ord som "tea kettle" skrivs isär och saknar ändelser som "tekannan", behöver vi i svenskan hantera både sammansättningar och ändelser.

Här är grunderna, när du skriver in ett objekts vocabWords:

* Använd + för att markera ändelser och sammansättningar.
* Använd ^s för foge-s.
* Använd : för att ange alternativa ändelser.
* Använd | för att skapa sammansatta ord utan att generera delkomponenter som egna ord.

## Exempel

```tads3
  apple: Thing 'äpple+t'; 
```

Detta sätter automatiskt `apple.isNeuter=true` genom att ändelsen `t` automatiskt identifieras som neutrum. Detta skapar också upp orden `äpple` och `äpplet` och knyter dessa till objektet. isNeuter är en boolesk variabel på objektnivå som sätts för att bestäma grammatiskt genus på objektet, så som `en` om `isNeuter=nil` eller `ett` om `isNeuter=true`.  Så länge det finns en slutändelse med i ordet, kommer grammatiskt genus att härledas utifrån den ändelsen. Som minst bör du därför _alltid_ ange ordet i sin obestämda form samt den ändelse som gör ordet bestämt.

Exempel på ändelser: `cykel+n`, `väg+en` eller `dike+t` för singular, och `cyklar+na`, `vägar+na` eller `diken+a` för plural. Adjektiv kan kan vara t ex: `grön+a`, `glad+a`.

Du kan så klart alltid skriva in `isNeuter=true` och/eller `isPlural=true` manuellt i din objektdeklaration också. I så fall kommer det värdet gälla främst och ingen härledning utifrån ändelsen kommer att göras.

TIPS: Du kan titta i [exempeltabellen](#notationsexempel) längre ned med olika exempel för att snabbt få en intuitiv förståelse för hur detta ska användas.

Nästa exempel:

```tads3
  apple: Thing 'röda smakfulla äpple+t/frukt+en*äpplen+a frukter+na';
```

Detta skapar adjektiv, substantiv-variationer och olika pluralformer automatiskt. (t ex: `röda smakfulla, äpple, äpplet, frukt, frukten, äpplen, äpplena, frukter, frukterna`). Med ENDAST några välplacerade plustecken har du automatiskt tagit hand om neutrum/utrum och alla ordens variationer.

För att hantera foge-s används `^s`, DVS: när vi behöver binda ihop orden med ett extra `s`, vilket händer lite överallt i svenskan:

```tads3
  tranbarsjuice: Thing 'tranbär^s+juice+n';
```

Detta skapar upp fyra substantiv i utrum: `tranbär, tranbären, tranbärsjuice, tranbärsjuicen.` och knyter dem till vårat objekt.

För att ändra grammatiskt genus i vissa komponenter men inte det sammansatta ordet kan `:` användas:

```tads3
  ansvarskanslan: Thing 'ansvar:et^s+känsla+n';
```

Detta ger oss fyra substantiv i blandat neutrum och utrum: `ansvar, ansvaret` och `ansvarskänsla, ansvarskänslan`.

För att enkelt skapa alternativ bestämd form kan även `:` användas till att ange den obestämda formen.
OBS: detta sätt för att beteckna en obestämd form med `:` fungerar bara när ordet består av _två_ delar, så som i följande exempel:

```tads3
  fonstret: Thing 'fönst:er+et';
```

Detta ger oss ett enkelt sätt att skapa upp: `fönster, fönstret`.

En liten minnesregel här för vilken ordning `:` och `+` skrivs, är att den bestämda formen alltid kommer sist med `+`, (så att som sagt neutrum/utrum kan avgöras). Vill vi som i detta fall skriva en alternativ böjning av ordet gör vi det innan med hjälp av `:`. Alltså: obestämd form: `fönster`, bestämd form: `fönstret`.

Sista exemplet:

I fallen ovan där `+` används så kommer separata ord att skapas upp för varje komponent som ingår. Om du inte vill att
delkomponter ska sättas ihop med andra ord, använder du `|` som skiljetecken istället för `+`. T ex:

```tads3
  cykelslang: Thing 'cykel|slang+en';
```

Här kommer bara följande ord skapas: `cykelslang, cykelslangen, slang och slangen`.
DVS: `cykel` och `cykeln` kommer _INTE_ skapas som enskilda ord.

## combineVocabWords-flaggan

Den särskilda notationen för vocabWords fungerar när `combineVocabWords = true` är satt (vilket den är som standard). Sätt den till `nil` för att stänga av funktionaliteten. Nu måste du dock utförligt skriva in alla variationer själv.

```tads3
  fonster: Thing '+tecknet/+tecken/+-tecken/+-tecknet/plustecken/plustecknet'
    combineVocabWords = true
  ;
```

Detta kan exempelvis bli aktuellt om du någon gång behöver använda något av tecknen: "`^:+|`" i ditt ord.

För att debugga, använd flaggan "-D __DEBUG" vid kompilering och använd verbet "ord <valfritt substantiv>" i spelet för att granska vilka ord som genererats för samma objekt. Detta kan vara mycket användbart i början för att lära känna hur du använder notationen.

Här nedan följer en tabell med några exempel på vad du får beroende på vad du skriver:

### Notationsexempel

| Notation                     | Exempel                                               | Genererade ord                                                                      |
|------------------------------|-------------------------------------------------------|-------------------------------------------------------------------------------------|
| Enkel ändelse                | 'äpple+t'                                             | äpple, äpplet                                                                       |
| Sammansatt ord med adjektiv  | 'röda smakfulla äpple+t/frukt+en*äpplen+a frukter+na' | röda, smakfulla, äpple, äpplet, äpplen, äpplena, frukt, frukten, frukter, frukterna |
| Foge-s                       | 'tranbär^s+juice+n'                                   | juice, juicen, tranbärsjuicen, tranbärsjuice, tranbären, tranbär                    |
| Genusändring med kolon       | 'ansvar:et^s+känsla+n'                                | ansvarskänslan, ansvarskänsla, ansvaret, ansvar, känslan, känsla                    |
| Utan genusändring            | 'ansvar^s+känsla+n'                                   | ansvarskänslan, ansvarskänsla, ansvaren, ansvar, känslan, känsla                    |
| Delkomponenter inte egna ord | 'cykel\|slang+en'                                     | cykelslang, cykelslangen, slang, slangen                                            |
| Alternativ bestämd form      | 'fönst:er+ret'                                        | fönster, fönstret                                                                   |
| Kolon utan foge-S            | 'video:+förstärkare+n'                                | video, förstärkare, förstärkaren, videoförstärkare, videoförstärkaren               |

Det finns även gott om exempel för hur detta används även i `tester/initialize-tests.t` samt i `exempel/ruiner/ruiner.t`.

# Stränginterpolation med parameteriserade substitutionssträngar

Parameteriserade substitutionssträngar i den svenska översättningen av Tads3 används för att dynamiskt infoga text baserat på spelets tillstånd och objektens egenskaper. Det är kanske inte det vanligaste i ett spel där färdiga strängar oftast redan skrivs ut som de är direkt, men om du utvecklar egna bibliotek där du vill skapa upp generella strängar som ska fungera oavsett för vilket objekt de än används till, då är det värt att titta närmare på hur dessa meddelanden skrivs på just svenska. Här följer en översikt över de vanligaste användningsfallen.

## Grundläggande användning

Den grundläggande syntaxen för stränginterpolation är att använda klammerparenteser `{}` runt uttrycket som ska utvärderas.

### Exempel på grundläggande användning

| Sträng               | Resultat            | Villkor                                                         |
|----------------------|---------------------|-----------------------------------------------------------------|
| `{Jag} öppnar dörren`  | "Jag öppnar dörren"   | Något beskrivs i 1a person, DVS: `referralPerson = FirstPerson` |
| `{Du} öppnar dörren`   | "Du öppnar dörren"    | Något beskrivs i 2a person, DVS: `referralPerson = Seconderson` |
| `{Ref} öppnar dörren`  | "Bob öppnar dörren"   | Något beskrivs i 3e person, DVS: `referralPerson = ThirdPerson` |

Valfri form av `{jag}`, `{du}` och `{ref}` kan användas så som i exemplen. De är alla synonymer för samma funktion bakom ändå (nämligen `theName`) och det är villkoren i den funktionen som styr vilken text som produceras för det givna objektet. Formvariationerna vi ser ovan är till för att man ska välja valfri men förhoppningsvis enhetlig stil i sina generella substitutionssträngar.

Till exempel, om följande sträng är specificerad i koden:

----

 `{Jag} gick upp för trappan, {mina} tunga andetag hördes.`:

----

* Så kommer texten generera följande för `Alice` i tredjeperson:  `Alice gick upp för trappan, hennes tunga andetag hördes.`
* För `Bob` i tredjeperson: `Bob gick upp för trappan, hans tunga andetag hördes.`
* För `dig` i andra person: `Du gick upp för trappan, dina tunga andetag hördes.`
* Eller för `artisterna` i andra person: `Ni gick upp för trappan, era tunga andetag hördes.`

## Användning av pronomen

För att hantera pronomen korrekt, använd följande syntax:

### Subjektform (nominativ)

| Sträng          | Resultat     | Villkor                                                                |
|-----------------|--------------|------------------------------------------------------------------------|
| `{Han} hoppade` | "Han hoppade"| `isHim = true`                                                         |
| `{Hon} hoppade` | "Hon hoppade"| `isHer = true`                                                         |
| `{Den} hoppade` | "Den hoppade"| `isIt = true` (Utrum är standard, `isNeuter=nil` behöver ej sättas)    |
| `{Det} hoppade` | "Det hoppade"| `isIt = true, isNeuter = true`                                         |
| `{Vi} hoppade`  | "Vi hoppade" | `isPlural = true, referralPerson = FirstPerson`                        |
| `{Ni} hoppade`  | "Ni hoppade" | `isPlural = true, referralPerson = SecondPerson`                       |
| `{De} hoppade`  | "De hoppade" | `isPlural = true, referralPerson = ThirdPerson`                        |

(Om inget anges inom klamrarna, så som t ex `{Den grodan} hoppade` så kommer gActor antas gälla istället.)

### Objektform

| Sträng                        | Resultat           | Förklaring                               |
|-------------------------------|--------------------|------------------------------------------|
| `Ser {det tradet/honom} falla`| "Ser det falla"    | För neutrum `isNeuter=true`.             |
| `Ser {det Alice/henne} falla` | "Ser henne falla"  | För femininum `isHer=true`               |
| `Ser {ref Bob/honom} falla`   | "Ser Bob falla"    | För egennamn `isProperName = true`       |

OBS: `ref */honom` används i sista exemplet. Den tar hänsyn till egennamn till skillnad från `{det */honom}` som bara skriver ut pronomen.

### Reflexiva former

| Sträng           | Resultat | Villkor                                           |
|------------------|----------|---------------------------------------------------|
| `{mig bob}`      | "mig"    | `referralPerson = FirstPerson`                    |
| `{dig alice}`    | "dig"    | `referralPerson = SecondPerson`                   |
| `{sig artister}` | "sig"    | `referralPerson = ThirdPerson`                    |
| `{oss artister}` | "oss"    | `isPlural = true, referralPerson = FirstPerson`   |
| `{er artister}`  | "er"     | `isPlural = true, referralPerson = SecondPerson`  |

### Förslag till vidare läsning

Detta är inte en helt utförlig instruktion. Tids nog kanske det kommer vara det.
Jag rekommenderar därför att titta närmare i filen `msg_neu.t` och kanske även testerna i `satsdelar.t` för mer inspiration.

# Tester och bidrag

Tester finns i tester-katalogen. Kör dem med `run.sh`. Hittar du fel eller har förbättringsförslag, skapa gärna en issue eller pull request.

# För andra nordiska språk

Känner du dig inspirerad att översätta till andra nordiska språk? Använd gärna detta bibliotek som utgångspunkt!

# Till sist

Jag har skrivit nästan alla översättningarna i biblioteket för hand. Detta för att de flesta av dem skrevs innan det kom AI-verktyg som kan göra detta jobb åt en. Strängarna däremot i filen `instruct.t` är översatt helt och hållet av Copilot. Spelet `Ruiner` av Graham Nelson likaså. Därefter har jag förbättrat många av meningarna som blev "svengelska" på olika sätt. Här har det varit mycket behändigt med ChatGPT som bollplank att diskutera vad som blir rätt utifrån orignalstilen på engelska.

Arbetet med biblioteket har tagit väldigt lång tid och kommer fortsätta vara ett kontinuerligt arbete, då jag garanterat har gjort missar här och var. Hjälp därför gärna till med att rapportera buggar och konstiga texter/grammatik allt medan du finner dem!
