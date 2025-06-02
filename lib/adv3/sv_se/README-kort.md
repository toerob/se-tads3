# Svensk översättning av standardbiblioteket Adv3 till Tads3

I den svenska översättningen har ett designval gjorts gällande sammansatta ord och ändelser. Till skillnad från engelska, där ord som "tea kettle" skrivs isär och saknar ändelser som "tekannan", behöver vi i svenskan hantera både sammansättningar och ändelser.

För att lösa detta introduceras "plusnotationen" i vocabWords. Genom att ange ändelser och sammansättningar med plustecken kan vi automatiskt generera olika former av ord.

## Hur du skapar upp objekt

Designprinciper:

1. Behåller det gamla sättet att skriva: 'adj adj adj noun/noun/noun*plural plural'
2. Tillåter en plusnotation per objekt för att skapa flera varianter av sammansatta ord.

Exempel:

```tads3
apple: Thing 'äpple+t'; 
```

Detta sätter automatiskt `apple.isNeuter=true` och skapar orden 'äpple' och 'äpplet'.

```tads3
apple: Thing 'röda smakfulla äpple+t/frukt+en*äpplen+a frukter+na';
```

Detta skapar adjektiv, substantiv och pluralformer automatiskt.

För att hantera foge-s används "^s":

```tads3
tranbarsjuice: Thing 'tranbär^s+juice+n';
```

För att ändra genus under skapandet används kolon:

```tads3
ansvarskanslan: Thing 'ansvar:et^s+känsla+n';
```

## combineVocabWords-flaggan

Plusnotation fungerar när `combineVocabWords = true` (standard). Sätt till `nil` för att stänga av funktionaliteten.

För att debugga, använd flaggan "-D __DEBUG" vid kompilering och använd verbet "ord" i spelet.



| Notation                    | Exempel                                               | Genererade ord                                                                      |
|-----------------------------|-------------------------------------------------------|-------------------------------------------------------------------------------------|
| Enkel ändelse               | 'äpple+t'                                             | äpple, äpplet                                                                       |
| Sammansatt ord med adjektiv | 'röda smakfulla äpple+t/frukt+en*äpplen+a frukter+na' | röda, smakfulla, äpple, äpplet, äpplen, äpplena, frukt, frukten, frukter, frukterna |
| Foge-s                      | 'tranbär^s+juice+n'                                   | juice, juicen, tranbärsjuicen, tranbärsjuice, tranbären, tranbär                    |
| Genusändring med kolon      | 'ansvar:et^s+känsla+n'                                | ansvarskänslan, ansvarskänsla, ansvaret, ansvar, känslan, känsla                    |
| Utan genusändring           | 'ansvar^s+känsla+n'                                   | ansvarskänslan, ansvarskänsla, ansvaren, ansvar, känslan, känsla                    |

Förbättringsförslag:
1. Lägg till fler konkreta exempel på hur man kan använda plusnotationen i olika situationer.
2. Skapa en tabell som visar hur olika notationer påverkar ordgenereringen.
3. Inkludera en kort sektion om vanliga fallgropar eller misstag att undvika.
4. Överväg att lägga till en "Snabbstartsguide" i början för de som vill komma igång snabbt.