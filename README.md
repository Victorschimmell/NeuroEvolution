# NeuroEvolution

## De vigtigste ting i vores specifikke løsning:

### Kort beskrivelse af vigtige klasser:

#### CarController: 
Denne klasse forbinder sensorerne, hjernen og bilen.
Vi opdaterer bil, sensorer og så beregner hjernen hvor meget der skal drejes.

#### Neuralnetwork:
Det neurale netværk er det som vi kender som hjernen.
Her defineres alle weights og biases. 
Det Neurale netværk er et nætværk bestående/konstrueret af de her neuroner i 3 lag: input-laget, mellem-laget og output-laget

#### Sensors:
Sensorerne er laves gennem et helt sensorsystem, hvor disse sensorer bruges til at kunne styre bilen og udregne deres fitness.
Sensorsystemet er for alle biler, selv også dem som ikke bruges af vores neurale netværk - hjernen.
Her kan væggene opdages - altså vejens kanter, hvor den kan opfange om den crasher.

#### Vehicle:
Vores biler indeholder en position og hastighed, hvor de også kan dreje til venstre og højre 

#### Population:
