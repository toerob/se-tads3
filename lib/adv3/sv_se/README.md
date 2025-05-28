# Svensk översättning av standardbiblioteket Adv3 till programmeringsspråket Tads3


## Hur du skapar upp objekt


Designprincipen har varit följande:

1. Det ska hedra det gamla sättet att skriva i formen 'adj adj adj noun/noun/noun*plural plural'
  ```tads3
    stege: Thing 'ranglig rangliga stege/stegen*stegar' 'stege' definitiveForm = 'stegen'; 
  ```

1. Det ska tillåta en +notation per objekt, givet att combineVocabWords = true (vilket är default)
plusnotationen tillåter oss att snabbt sätta samman större ord till många varianter av samma.
Exempel:
- 'röda smakfulla äpple+t/frukt+en*äpplen+a frukter+na' sätter automatiskt ihop sammansatta ord så som:
   ajektiv: "röda, smakfulla"
   substantiv: "äpple, äpplet, äpplen, äpplena, frukt, frukten"
   pluralformer: "frukter, frukterna"

Det härleder dessutom från den bestämda formen om ordet är neutrum/utrum och sätter isNeuter=true om så är fallet.
Objekt kommer som default att ugtå från att de är i utrum-form (isNeuter=nil) eftersom det är den vanligaste formen.
OBS: Detta betyder att man som minst bör skriva 'äpple+t' för att härledningen skall fungera automatiskt

```tads3
apple: Thing 'äpple+t'; 
```

Exemplet ivan sätter automatiskt apple.isNeuter=true och skapar upp två ord 'äpple', 'äpplet' som refererar till objektet _apple_.

```tads3
  apple: Thing 'röda smakfulla äpple+t/frukt+en*äpplen+a frukter+na';
```

Samma som tidigare exemplet, men med än mer ord skapade, utifrån '+' används.

```tads3
      tranbarsjuice: Thing 'tranbär^s+juice+n' 'tranbärsjuice';
```

Ovan exempel ger stöd för att skapa kombinationer med _foge-s_ ("^s") eller utan, t ex i detta fall: tranbär, tranbären, tranbärsjuice, tranbärsjuicen, juice samt juicen.
