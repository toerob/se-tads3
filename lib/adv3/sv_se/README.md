# Svensk översättning av standardbiblioteket Adv3 till programmeringsspråket Tads3

I den svenska översättningen har gjort ett designval gjorts när det gäller våra sammansatta ord i svenskan. Jag förklarar detta lättast genom att kontrastera med engelskan.

Engelskan har som bekant i regel ett mellanslag mellan varje sammansättning, t ex: "tea kettle" vs "tekanna" samt att de inte har samma typ av ändelse-morfism på alla sina substantiv som vi har i svenskan. "kettle" är "the kettle" medan "tekanna" har "tekannan".

När vi i svenskan skriver ordet "äpple", menar vi även implicit att även "äpplet" ska referera till samma sak när vi pratar om det i bestämd form. Här har engelskan det lätt för sig eftersom där man bara behöver skriva "apple" samt "the apple" för att få till samma effekt. Men i svenskan kan vi inte bara skriva "äpple" och anta att ändelsen "t" ska gå lätt att lista ut för en avancerad räknemaskin. Våra substantivs ändelser är som bekant helt oregelbundna och följer med varandra utan logik. Engelskan har dessutom ett enkelt system när det kommer till att lista ut artikel för ordet. Men i svenskan är det inte bara att analysera om ordet inleds med en vokal för att lista ut neutrum/utrum. Ena gången är det "tekanna+n" med artikeln "en", andra gånger är "vattentrycket" med artikeln "ett".

MEN _om_ vi anger ändelsen på ordet så kan artikeln härleda programmatiskt. Därför kom "plusnotationen" till i vocabWords. Om man vi tillåter det lilla ofoget att som minst behöva skriva "äpple+t" så kan vi få artikel och definitiv form av ordet automatiskt genererat åt oss. Men varför bara stanna vid ändelser? Det finns mängder med sammansatta ord så förutom att bestämma grammatiskt genus kan även flera varianter skapas upp av ett ord genom att tillåta plustecknet på fler ställen än i slutet.

Som vanligt är det enklast att illustrera med ett exempel. Ta ordet "pappersflygplanet". 
Om vi väljer att dela upp det i tre komponenter, har vi "papper", "flyg" och "plan".  

Om vi inleder med att ange "papper+flyg+plan+et" så kommer vi automatiskt få flera varianter uppskapade. Men det kommer inte se helt rätt ut:

  `"planet, papperflygplanet, papperflygplan, papperflyg, papperet, papper, flyget, plan, flyg"`

Vi saknar limmet "s". Lösningen är enkel. Skriv in "^s" där limmet ska användas vid sammanfogningar så kommer det försvinna i vissa lägen och dyka upp i andra. 

Exempelvis "papper^s+flyg+plan+et" skapar upp följande varianter:
  `"planet, pappersflygplanet, pappersflygplan, pappersflyg, papperet, papper, flyget, plan, flyg"`

"Foge-s" används när vi vill limma ihop vissa ord med 's' men inte när orden står isolerade från varandra. Därför används "limmet" i "pappersflyg" men inte i "papper", eller "papperet".

Hur gör vi om en enskilt komponent behöver annan ändelse? Sista tricket i verktygslådan är att specifiera avvikande ändelser med ":" på det enskilda förekommande fenomenet. T ex:  "ansvar:et+s+känsla+n"
Detta ger oss följande former: `ansvarskänslan, ansvarskänsla, ansvaret, ansvar, känslan, känsla`

Härnäst kommer fullständiga kodexempel.

## Hur du skapar upp objekt

För att snabbt komma igång följer här några exempel.


Designprincipen är följande:

1. Det ska hedra det gamla sättet att skriva i formen 'adj adj adj noun/noun/noun*plural plural'
  ```tads3
    stege: Thing 'ranglig rangliga stege/stegen*stegar' 'stege' definiteForm = 'stegen'; 
  ```
1. Det ska tillåta en plusnotation per objekt. plusnotationen tillåter oss att snabbt sätta samman större ord till många varianter av samma. T ex uttrycket "tomat+plantor+na".

I följande exempel sätts automatiskt apple.isNeuter=true samt att de två orden 'äpple', 'äpplet' som refererar till objektet _apple_ skapas och läggs till i cmdDict.

```tads3
apple: Thing 'äpple+t'; 
```

Det härleder dessutom från den bestämda formen om ordet är neutrum/utrum och sätter isNeuter=true om så är fallet.
Objekt kommer som default att ugtå från att de är i utrum-form (isNeuter=nil) eftersom det är den vanligaste formen.
OBS: Detta betyder att man som minst bör skriva 'äpple+t' för att härledningen skall fungera automatiskt.

Observera att vi längre måste ange namn (läs name) direkt efter vocabWords när det gäller typen Thing, så som annars är standard i engelska adv3. Om inget namn anges efteråt härleds det nämligen från vocabWords-fältet. Det ord som bestäms är i så fall det första sammansatta substantivet/pluralordet utan ändelse. I propertyn 'definiteForm' tilldelas även name+ändelsen för det första sammansatta substantivet/pluralordet. theName kommer tilldelas denna form om den finns angiven.


I det följande exemplet blir det ungefär samma sak, men med än mer ord skapade, utifrån '+' används. 

```tads3
  apple: Thing 'röda smakfulla äpple+t/frukt+en*äpplen+a frukter+na';
```

Detta sätter automatiskt ihop sammansatta ord så som:

* adjektiv: "röda, smakfulla"
* substantiv: "äpple, äpplet, äpplen, äpplena, frukt, frukten"
* samt pluralformerna: "frukter, frukterna"

Så notera att + kan användas inom vilket som helst av de angivna adjektiv- substantiv eller pluralblocken, så länge de placerade mitt i ordet utan mellanslag.


Detta skapar upp adjektiv: röda, substantiv: äpple, äpplet, frukt, frukten samt plural: äpplen, äpplena.

I nästa exempel ges stöd för att skapa kombinationer med _foge-s_ ("^s"), t ex i detta fall: tranbär, tranbären, tranbärsjuice, tranbärsjuicen, juice samt juicen.

```tads3
      tranbarsjuice: Thing 'tranbär^s+juice+n';
```
#### Resultat:
* juice (substantiv)
* juicen (substantiv)
* tranbärsjuicen (substantiv)
* tranbärsjuice (substantiv)
* tranbären (substantiv)
* tranbär (substantiv)

I ovan fall behövde inget av ordet byta genus, dvs alla ändelser slutar på en för den mängd ord som skapas.
Om vi vill ändra det under skapandets gång, kan vi nytta kolon, ":" samt den alternativa ändelse vi vill använda.


```tads3
      ansvarskanslan: Thing 'ansvar:et^s+känsla+n';
```

Detta ger följande ord:

  ansvarskänslan (substantiv)
  ansvarskänsla (substantiv)
  ansvaret (substantiv)      <-----
  ansvar (substantiv)
  känslan (substantiv)
  känsla (substantiv)

Hade vi bara angett:

```tads3
      ansvarskanslan: Thing 'ansvar^s+känsla+n';
```
Hade det resulterat i:
  ansvarskänslan (substantiv)
  ansvarskänsla (substantiv)
  ansvaren (substantiv)      <-----
  ansvar (substantiv)
  känslan (substantiv)
  känsla (substantiv)

vilket så klart kan vara vad vi är ute efter i vissa fall, andra gånger inte. 

Du kan ta reda på hur väl du lyckats skapa ett ord om du kör med följande flagga när du kompilerar eller i din Makefile: "-D __DEBUG". Med den flaggan finns verbet "ord" tillgängligt inne i spelet, 

skriv t ex:
```
 "ord ansvar" 
 ```

 eller :
 ```
 "ord känsla" 
 ```
så kommer rätt ord att letas upp i cmDict och alla dess synonymer och adjektiv att printas ut på skärmen.

## Några korta ord om combineVocabWords-flaggan per objekt

Plusnotation fungerar givet att combineVocabWords = true per objekt. Detta är default och inget du behöver ändra annat än om du vill stänga av denna funktionalitet. T ex om vill du kunna ange '+' som ett token för ordet. Så om combineVocabWords sätts till `nil`, är det fritt fram att skriva vad du vill i vocabWords enligt det gamla sättet.

Plustecknet valdes för att det ligger nära till pass och ökar flytet i skrivandet. Men vill du ändra den så är det fritt fram att modifiera det reguljära uttrycket:
```
  plusNotationPat = static new RexPattern('.+(<plus>.+)+') 
```
där <plus> i så fall kan byta till ett nytt valfritt tecken som passar med Tads3 reguljära uttrycksmotor.

