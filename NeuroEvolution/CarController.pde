class CarController {
  //Forbinder - Sensorer & Hjerne & Bil
  Car bil = new Car(new PVector(60, 232), new PVector(0, 5));
  NeuralNetwork hjerne;
  SensorSystem  sensorSystem = new SensorSystem();
  
  float fitness;
  
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
    sensorSystem.updateSensorsignals(bil.pos, bil.vel);
    //3.)hjernen beregner hvor meget der skal drejes
    float turnAngle = 0;
    float x1 = int(sensorSystem.leftSensorSignal);
    float x2 = int(sensorSystem.frontSensorSignal);
    float x3 = int(sensorSystem.rightSensorSignal);    
    turnAngle = hjerne.getOutput(x1, x2, x3);    
    //4.)bilen drejes
    bil.turnCar(turnAngle);
  }
  
  void display(){
    bil.displayCar();
    //sensorSystem.displaySensors();
  }
  
  
  float getFitness(){
    fitness = sensorSystem.senFitness();
   return fitness;
  }
  
  float[] getDNA1(){
    return hjerne.weights;
  }
    float[] getDNA2(){
    return hjerne.biases;
  }
  
 
}
