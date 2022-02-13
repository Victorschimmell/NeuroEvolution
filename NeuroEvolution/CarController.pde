class CarController {
  //Forbinder - Sensorer & Hjerne & Bil
  Vehicle bil = new Vehicle(new PVector(spawn_x,spawn_y), new PVector(0, 5));
  NeuralNetwork hjerne;
  Sensors  Sensors = new Sensors();
  
  float fitness;
  float turnAngle = 0;
  
  CarController(){
    hjerne = new NeuralNetwork(varians); 
    
  }
  
  CarController(float[] DNA1, float[] DNA2){
    
    hjerne = new NeuralNetwork(DNA1, DNA2); 
  }
      
  void update() {
    //1.)opdtarer bil   
    bil.update();
    //2.)opdaterer sensorer    
    Sensors.updateSensorsignals(bil.pos, bil.vel);
    //3.)hjernen beregner hvor meget der skal drejes
    
    float x1 = int(Sensors.lSensor);
    float x2 = int(Sensors.fSensor);
    float x3 = int(Sensors.rSensor);    
    turnAngle = hjerne.getOutput(x1, x2, x3);    
    //4.)bilen drejes
    bil.turnCar(turnAngle);
  }
  
  void display(){
    if(showSen){
    Sensors.displaySensors();
    noStroke();
    }
    bil.displayCar();
  }
  
  
  float getFitness(){
    fitness = Sensors.senFitness();
   return fitness;
  }
  
  float[] getDNA1(){
    return hjerne.weights;
  }
   float[] getDNA2(){
    return hjerne.biases;
  }
  
 
}
