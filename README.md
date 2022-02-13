# NeuroEvolution

## De vigtigste ting i vores specifikke løsning:

#### Vehicle: 
Denne klasse forbinder sensorerne, hjernen og bilen.
Vi opdaterer bil, sensorer og så beregner hjernen hvor meget der skal drejes.

#### dnaNeuralnetwork:
Det neurale netværk er det som vi kender som hjernen.
Her defineres alle weights og biases. 
Disse weights og biases er hvad der bruges som DNA i vores genetiske algoritme.
Det Neurale netværk er et nætværk bestående/konstrueret af de her neuroner i 3 lag: input-laget, mellem-laget og output-laget

#### Sensors:
Sensorerne er laves gennem et helt sensorsystem, hvor disse sensorer bruges til at kunne styre bilen og udregne deres fitness.
Sensorsystemet er for alle biler, selv også dem som ikke bruges af vores neurale netværk - hjernen.
Her kan væggene opdages - altså vejens kanter, hvor den kan opfange om den crasher.

#### Car:
Vores biler indeholder en position og hastighed, hvor de også kan dreje til venstre og højre 

#### Population:
Vi har 2 vigtige arraylist inde i selve Populations filen. Heri findes "population" og "matingpool". Population indeholder alle "Vehicle" objecter som vi simulerer. Matingpoolen bliver skabt efter hver generation. Matingpoolen er baseret på fitness. Fitness bliver tildelt til vores Vehicles gennem vores sensorer, alt efter om de kører galt, kører den forkerte vej, samt hvor hurtigt de kører den optimale rute på. Denne fitness bliver "map'et" ud gennem processings map funktion. Her scalerer den vores fitness til en værdi mellem 1 og 0 baseret på alle andre Vehicles fitness og maxfitness. Med det tildeler den nu et bestemt antal af tilfælde til de givne objecter i vores matingpool baseret på hvor god deres fitness, i forhold til alle andres er. Med flere tilfælde i matingpoolen, følger en højere tilfældig chance til at parre sig og reproducere med et andet object, som så fører videre til næste generations population. Og sådan udvikler vores program sig, og prøver at fidne dn optimale rute.