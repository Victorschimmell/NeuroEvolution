class Vehicle {
  //Forbinder - Sensorer & Hjerne & Bil
  car bil = new car(new PVector(spawn_x,spawn_y), new PVector(0, 5));
  dnaNeuralNetwork hjerne;
  Sensors  Sensors = new Sensors();
  
  float fitness;
  float turnAngle = 0;
  
  Vehicle(){
    hjerne = new dnaNeuralNetwork(varians); 
    
  }
  
  Vehicle(float[] DNA1, float[] DNA2){
    
    hjerne = new dnaNeuralNetwork(DNA1, DNA2); 
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
