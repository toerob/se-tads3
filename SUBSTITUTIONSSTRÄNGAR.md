# Guide: Substitutionssträngar i adv3/sv_se

Den här guiden vänder sig till dig som skriver ett eget spel eller bibliotek med sv_se och behöver använda dynamiska strängar som anpassar sig efter spelarkaraktärens person och genus.

> **TL;DR** — Ägaren är subjektet i meningen → `{sin}`/`{sitt}`/`{sina}`. Ägaren är _inte_ subjektet → `{hans}`/`{hennes}`/`{deras}`/`{dess}`.

---

## Aktörens egenskaper styr allt

Alla substitutionssträngar läser av följande egenskaper på det aktuella Actor-objektet:

| Egenskap               | Beskrivning                                         |
|------------------------|-----------------------------------------------------|
| `pcReferralPerson`     | `FirstPerson`, `SecondPerson` eller `ThirdPerson`   |
| `isHim = true`         | Maskulinum (han)                                    |
| `isHer = true`         | Femininum (hon)                                     |
| `isIt = true`          | Genus-neutralt/sak (den/det/de)                     |
| `isNeuter = true`      | Neutrum (det) — kombineras med `isIt`               |
| `isPlural = true`      | Plural (vi / ni / de)                               |
| `isProperName = true`  | Egennamn — skrivs ut direkt utan artikel            |

**Minimal aktörsdefinition:**

```tads
bob: Actor 'bob' 'Bob'
  pcReferralPerson = ThirdPerson
  isProperName = true
  isHim = true
;
```

---

## Namnformer — {jag}, {du}, {ref}

Dessa ger aktörens namn i subjektsposition (`theName`). De är synonymer; välj den som passar stilen i din text.

| Sträng      | Exempelresultat           | Används när                              |
|-------------|---------------------------|------------------------------------------|
| `{Jag}`     | `"Jag"` / `"Du"` / `"Bob"` | Typisk 1:a-persons-stil i strängar      |
| `{Du}`      | `"Jag"` / `"Du"` / `"Bob"` | Typisk 2:a-persons-stil                 |
| `{Ref}`     | `"Jag"` / `"Du"` / `"Bob"` | Typisk 3:e-persons-stil                 |
| `{Du/han}`  | (samma som ovan)           | Synonym med lite annan hint om avsett genus |
| `{Du/hon}`  | (samma som ovan)           | Synonym                                  |

```tads
// Bibliotekssträngar kan skrivas i valfri stil:
"{Du} öppnar dörren."
// → "Du öppnar dörren."  (om spelaren är 2:a person)
// → "Bob öppnar dörren." (om spelaren är 3:e person)
```

---

## Subjektform (nominativ) — han, hon, den, det, vi, ni, de

Ger rätt subjektspronomen baserat på aktörens genus och person.

| Sträng  | isHim | isHer | isIt (utrum) | isIt + isNeuter | isPlural |
|---------|-------|-------|--------------|-----------------|----------|
| `{Han}` | han   | hon   | den          | det             | de       |
| `{Hon}` | (samma som {Han}) ||||| |
| `{Den}` | (samma som {Han}) ||||| |
| `{Det}` | (samma som {Han}) ||||| |
| `{Vi}`  | vi (1p) | vi | vi          | vi              | vi       |
| `{Ni}`  | ni (2p) | ni | ni          | ni              | ni       |
| `{De}`  | de (3p) | de | de          | de              | de       |

> Alla dessa är egentligen synonymer och ger samma resultat — parametern du väljer är bara en stilmarkör i texten.

```tads
"{Han} hittar nyckeln."
// Bob: "Han hittar nyckeln."
// Alice: "Hon hittar nyckeln."
// Astronauten: "Den hittar nyckeln."
// Trädet: "Det hittar nyckeln."
```

**Explicit form** (ange ett specifikt objekt, inte `actor`):

```tads
"{Det/han tradet} sjunger."   // → "Det sjunger." (neutrum)
"{Den/hon astronauten} går."  // → "Den går."     (utrum)
```

---

## Objektform — mig, dig, honom, henne, dem …

| Sträng         | 1p sg | 1p pl | 2p sg | 2p pl | 3p mask | 3p fem | 3p neutrum | 3p pl |
|----------------|-------|-------|-------|-------|---------|--------|------------|-------|
| `{mig}`        | mig   | mig   | dig   | er    | sig     | sig    | sig        | sig   |
| `{dig}`        | (samma)||||||||
| `{sig}`        | (samma)||||||||
| `{oss}`        | oss   | oss   | er    | er    | dem     | dem    | dem        | dem   |
| `{er}`         | (samma som {oss}) |||||||||
| `{honom}`      | mig   | oss   | dig   | er    | honom   | henne  | det/den    | dem   |
| `{henne}`      | (samma som {honom}) |||||||||
| `{dem}`        | (samma som {honom}) |||||||||

```tads
"Jag {såg} {honom bob} rymma."
// Bob: "Jag såg honom rymma."
// Alice: "Jag såg henne rymma."
// Du: "Jag såg dig rymma."
```

**Med `/obj`-suffix** (explicit objekt, inte `actor`):

```tads
"Det gick inte att lyfta {det/obj skapet}."
// → "Det gick inte att lyfta det."  (neutrum)

"Hon tog {dem/obj smyckena} utan lov."
// → "Hon tog dem utan lov."
```

**Med `ref/…`** (egennamn visas, annars pronomen):

```tads
"Jag {hör} {ref/honom bob} sjunga."
// Bob: "Jag hörde Bob sjunga."  (egennamn eftersom isProperName=true)
// En vanlig npc: "Jag hörde honom sjunga."
```

---

## Reflexiva konstruktioner — sig själv, mig själv …

| Sträng          | 1p sg     | 1p pl      | 2p sg      | 2p pl      | 3p          |
|-----------------|-----------|------------|------------|------------|-------------|
| `{sig_själv}`   | mig själv | oss själva | dig själv  | er själva  | sig självt/själv/själva |
| `{mig_själv}`   | (samma)   |            |            |            |             |
| `{dig_själv}`   | (samma)   |            |            |            |             |
| `{oss_själva}`  | (samma)   |            |            |            |             |
| `{er_själva}`   | (samma)   |            |            |            |             |

```tads
"{Du} {såg} {sig_själv} i spegeln."
// Du: "Du såg dig själv i spegeln."
// Bob: "Han såg sig själv i spegeln."
```

---

## Possessiva adjektiv — den viktigaste delen

Det finns **två helt olika typer** av possessiva adjektiv i svenska:

| Typ           | Fråga                                    | Form                        |
|---------------|------------------------------------------|-----------------------------|
| **Reflexivt** | Ägaren = subjektet i meningen            | sin / sitt / sina           |
| **Icke-reflexivt** | Ägaren ≠ subjektet                  | hans / hennes / dess / deras |

### Reflexivt possessivt adjektiv — {sin}, {sitt}, {sina}

Använd när ägaren ÄR subjektet. Välj form efter det **ägda substantivets** genus:

| Det ägda substantivet är… | Sträng         | 3:e person | 1:a person | 2:a person |
|---------------------------|----------------|-----------|------------|------------|
| Utrum singular (en-ord)   | `{sin actor}`  | sin       | min        | din        |
| Neutrum singular (ett-ord) | `{sitt actor}` | sitt      | mitt       | ditt       |
| Plural                    | `{sina actor}` | sina      | mina       | dina       |

```tads
// Ägaren är subjektet → sin/mitt/sina
"{Du} {såg} inte {sina actor} saker."
// Bob:  "Bob såg inte sina saker."
// Alice: "Alice såg inte sina saker."
// Du:   "Du såg inte dina saker."
// Jag:  "Jag såg inte mina saker."

"{Du} missade {sitt actor} tåg."
// Bob:  "Bob missade sitt tåg."
// Du:   "Du missade ditt tåg."

"{Du} lämnade {sin actor} bok på bänken."
// Alice: "Alice lämnade sin bok på bänken."
// Jag:   "Jag lämnade min bok på bänken."
```

> **Minnesregel:** `{sin}` = utrum, `{sitt}` = neutrum, `{sina}` = plural. Titta på det ägda ordet, inte på ägaren.

---

### Icke-reflexivt possessivt adjektiv — {hans}, {hennes}, {dess}, {deras}

Använd när ägaren **inte** är subjektet i meningen. Alla fyra parametrar är synonymer — det är aktörens genus som avgör utdata, inte vilket ord du skriver i strängen.

| Sträng          | 1p sg | 1p pl | 2p sg | 2p pl | 3p mask | 3p fem | 3p neutrum | 3p pl |
|-----------------|-------|-------|-------|-------|---------|--------|------------|-------|
| `{hans actor}`  | min   | vår   | din   | er    | hans    | hans   | dess       | deras |
| `{hennes actor}`| min   | vår   | din   | er    | hans    | hennes | dess       | deras |
| `{deras actor}` | min   | vår   | din   | er    | hans    | hennes | dess       | deras |
| `{dess actor}`  | min   | vår   | din   | er    | hans    | hennes | dess       | deras |

> I praktiken ger alla fyra samma resultat — välj den som läses naturligast i din källkod för en tredjepersonskaraktär.

```tads
// Ägaren är INTE subjektet → hans/hennes
"Det var inte {hans actor} saker."
// Bob:   "Det var inte hans saker."
// Alice: "Det var inte hennes saker."
// Du:    "Det var inte dina saker."
// Jag:   "Det var inte mina saker."

"Du hittade {hennes alice} plånbok."
// Alice: "Du hittade hennes plånbok."
```

---

### Snabbguide: reflexivt eller icke-reflexivt?

```
Meningen: "Bob såg [Bobs] saker."
          ägare=Bob, subjekt=Bob → samma person → reflexivt → {sina actor}

Meningen: "Du hittade [Bobs] saker."
          ägare=Bob, subjekt=Du → olika → icke-reflexivt → {hans actor}
```

---

### Possessivt pronomen (predikativ form, utan substantiv)

När det possessiva pronomenet står ensamt (utan efterföljande substantiv) används `itPossNoun`, via parametrar som `{din/hans}`, `{din/hennes}` m.fl. Dessa anpassar sig efter det direkta objektets genus.

```tads
"Boken {är} {din/hans}."
// Bob (3p mask): "Boken var hans."
// Alice (3p fem): "Boken var hennes."
// Du (2p):        "Boken var din."
// Jag (1p):       "Boken var min."

// Neutrum (gDobj är ett neutrum-objekt):
"Huset {är} {din/erat}."
// 2p plural: "Huset var ert."
// Bob:       "Huset var hans."
```

---

### Possessiva adjektiv med egennamn — {ref/din}

När du vill skriva ut aktörens namn i genitiv (ägande) istället för ett pronomen:

```tads
"{Ref/din} sko {går} sönder."
// Bob (egennamn): "Bobs sko gick sönder."
// Du:             "Din sko gick sönder."
```

---

## Demonstrativa pronomen — {den/obj}, {det/obj} …

| Sträng              | Exempel-resultat                              |
|---------------------|-----------------------------------------------|
| `{den/obj X}`       | `den` (utrum), `det` (neutrum), `dem` (plural) |
| `{det/obj X}`       | (samma)                                        |
| `{dem/obj X}`       | (samma)                                        |

```tads
"Hon tog {det/obj skrin} {där} utan lov."
// → "Hon tog det där utan lov."

"Jag gillar inte {dem/obj smycken} {där}."
// → "Jag gillar inte dem där."
```

---

## Verb — tidsstyrda former

Verbparametrarna anpassar sig automatiskt till `usePastTense`-inställningen i `gameMain`.

| Sträng      | Presens  | Preteritum |
|-------------|----------|------------|
| `{är}`      | är       | var        |
| `{var}`     | (synonym) |           |
| `{har}`     | har      | hade       |
| `{tar}`     | tar      | tog        |
| `{ser}`     | ser      | såg        |
| `{hör}`     | hör      | hörde      |
| `{går}`     | går      | gick       |
| `{kommer}`  | kommer   | kom        |
| `{lämnar}`  | lämnar   | lämnade    |
| `{säg}`     | säger    | sade       |
| `{gör}`     | gör      | gjorde     |
| `{kan}`     | kan      | kunde      |
| `{måste}`   | måste    | måste      |
| `{verkar}`  | verkar   | verkade    |

```tads
"{Du} {går} mot utgången."
// Presens: "Du går mot utgången."
// Preteritum: "Du gick mot utgången."
```

**Verbändelse-parametrar** (för egna verb):

| Sträng       | Presens | Preteritum | Exempel              |
|--------------|---------|------------|----------------------|
| `{er/te}`    | -er     | -te        | `tryck{er/te}` → trycker/tryckte |
| `{er/e}`     | -er     | -e         | `tänd{er/e}` → tänder/tände |

```tads
"Dörren öppn{ar|ades} med ett knarrande."
// Presens: "Dörren öppnar med ett knarrande."
// Preteritum: "Dörren öppnades med ett knarrande."
```

---

## Artikelformer — bestämd och obestämd form

I substitutionssträngar används inte `{aname}` / `{thename}` som i engelska — istället används `{ref/...}` för bestämd form och `{en/...}` / `{ett/...}` för obestämd.

### Bestämd form — {ref/den}, {ref/det}, {ref/de}

Dessa anropar `theName` på det angivna objektet (t ex `"boken"`, `"huset"`, `"böckerna"`).

| Sträng           | Används för              | Exempel                       |
|------------------|--------------------------|-------------------------------|
| `{ref/den X}`    | Utrum singular           | `"boken"`, `"stolen"`         |
| `{ref/det X}`    | Neutrum singular         | `"huset"`, `"bordet"`         |
| `{ref/de X}`     | Plural                   | `"böckerna"`, `"stolarna"`    |
| `{ref/han X}`    | Synonym för utrum/mask.  | (samma som `{ref/den X}`)     |
| `{ref/hon X}`    | Synonym för utrum/fem.   | (samma som `{ref/den X}`)     |

```tads
"Du tar upp {ref/det dobj}."
// dobj = huset  → "Du tar upp huset."
// dobj = boken  → "Du tar upp boken."   (funkar oavsett /det eller /den)

"Du ser {ref/den dobj} på golvet."
// → "Du ser stolen på golvet."
```

### Obestämd form — {en/han}, {ett/han}

Dessa anropar `aName` och lägger till rätt obestämd artikel.

| Sträng           | Används för              | Exempel                       |
|------------------|--------------------------|-------------------------------|
| `{en/han X}`     | Utrum singular           | `"en bok"`, `"en stol"`       |
| `{en/hon X}`     | Synonym (utrum/fem.)     | (samma som `{en/han X}`)      |
| `{ett/han X}`    | Neutrum singular         | `"ett hus"`, `"ett bord"`     |
| `{ett/hon X}`    | Synonym                  | (samma som `{ett/han X}`)     |

```tads
"Här ligger {en/han dobj}."
// dobj = bok+en  → "Här ligger en bok."
// dobj = stol+en → "Här ligger en stol."

"Du hittar {ett/han dobj} på golvet."
// dobj = hus+et  → "Du hittar ett hus på golvet."
```

> I TADS-kod (utanför substitutionssträngar) kan du komma åt `obj.aName` och `obj.theName` direkt. För att dessa ska ge rätt resultat behöver objektets vokabulär ha `+`-notation (t ex `'bok+en'` eller `'hus+et'`) så att `definiteForm` sätts automatiskt. Se [README.md](README.md).

---

## Samlad referenstabell

| Kategori                    | Parametrar                                                |
|-----------------------------|-----------------------------------------------------------|
| **Namn/referent**           | `{Jag}`, `{Du}`, `{Ref}`, `{Du/han}`, `{Du/hon}`         |
| **Subjektform**             | `{Han}`, `{Hon}`, `{Den}`, `{Det}`, `{Vi}`, `{Ni}`, `{De}` |
| **Objektform**              | `{mig}`, `{dig}`, `{sig}`, `{oss}`, `{er}`, `{honom}`, `{henne}`, `{dem}` |
| **Objektform (explicit)**   | `{ref/honom X}`, `{den/obj X}`, `{det/obj X}`, `{dem/obj X}` |
| **Reflexivt pronomen**      | `{sig_själv}`, `{mig_själv}`, `{dig_själv}`, `{oss_själva}`, `{er_själva}` |
| **Reflexivt poss.adj (utrum sg)** | `{sin}`, `{min}`, `{din}`, `{vår}`                |
| **Reflexivt poss.adj (neutrum sg)** | `{sitt}`, `{mitt}`, `{ditt}`, `{vårt}`          |
| **Reflexivt poss.adj (plural)** | `{sina}`, `{mina}`, `{dina}`, `{våra}`              |
| **Icke-reflexivt poss.adj** | `{hans}`, `{hennes}`, `{deras}`, `{dess}`                |
| **Poss.adj med egennamn**   | `{ref/din X}`                                             |
| **Predikativt poss.pron**   | `{din/hans}`, `{din/hennes}`, `{din/erat}`, `{dess/hennes}` |
| **Verb (tidsstyrda)**       | `{är}`, `{har}`, `{tar}`, `{ser}`, `{går}`, `{hör}`, m.fl. |
| **Verbändelser**            | `{er/te}`, `{er/e}`                                       |
| **Demonstrativa**           | `{den/obj}`, `{det/obj}`, `{dem/obj}`                     |
| **Bestämd form (theName)**  | `{ref/den X}`, `{ref/det X}`, `{ref/de X}`, `{ref/han X}`, `{ref/hon X}` |
| **Obestämd form (aName)**   | `{en/han X}`, `{en/hon X}`, `{ett/han X}`, `{ett/hon X}` |

---

## Se även

- [README.md](README.md) — installation, vokabulärnotation och `+`-systemet
- `tester/satsdelar.t` — körbara exempel på alla possessiva och pronominella former
- `tester/additional-tests.t` — tester för `aNameFrom`, `theNameFrom` och ljusformer
- `lib/adv3/sv_se/msg_neu.t` — alla biblioteksmeddelanden som använder dessa parametrar
