class SensorSystem {
  //SensorSystem - alle bilens sensorer - ogå dem der ikke bruges af "hjernen"
  
  //wall detectors
  float sensorMag = 50;
  float sensorAngle = PI*2/8;
  
  PVector anchorPos           = new PVector();
  
  PVector sensorVectorFront   = new PVector(0, sensorMag);
  PVector sensorVectorLeft    = new PVector(0, sensorMag);
  PVector sensorVectorRight   = new PVector(0, sensorMag);

  boolean frontSensorSignal   = false;
  boolean leftSensorSignal    = false;
  boolean rightSensorSignal   = false;

  //crash detection
  int whiteSensorFrameCount    = 0; //udenfor banen

  //clockwise rotation detection
  PVector centerToCarVector     = new PVector();
  float   lastRotationAngle   = -1;
  float   clockWiseRotationFrameCounter  = 0;

  //lapTime calculation
  boolean greenDe;
  boolean blueDe;
  boolean redDe;
  boolean disqual;
  int     lapTimeInFrames       = 100000;
  
  float SensorFitness;
  float SensorFitnessUpdate;
  


  void displaySensors() {
    strokeWeight(0.5);
    if (frontSensorSignal) { 
     fill(255, 0, 0);
      ellipse(anchorPos.x+sensorVectorFront.x, anchorPos.y+sensorVectorFront.y, 8, 8);
    }
    if (leftSensorSignal) { 
      fill(255, 0, 0);
      ellipse( anchorPos.x+sensorVectorLeft.x, anchorPos.y+sensorVectorLeft.y, 8, 8);
    }
    if (rightSensorSignal) { 
      fill(255, 0, 0);
      ellipse( anchorPos.x+sensorVectorRight.x, anchorPos.y+sensorVectorRight.y, 8, 8);
    }
    line(anchorPos.x, anchorPos.y, anchorPos.x+sensorVectorFront.x, anchorPos.y+sensorVectorFront.y);
    line(anchorPos.x, anchorPos.y, anchorPos.x+sensorVectorLeft.x, anchorPos.y+sensorVectorLeft.y);
    line(anchorPos.x, anchorPos.y, anchorPos.x+sensorVectorRight.x, anchorPos.y+sensorVectorRight.y);

    strokeWeight(2);
    if (whiteSensorFrameCount>0) {
      fill(whiteSensorFrameCount*10, 0, 0);
    } else {
      fill(0, clockWiseRotationFrameCounter, 0);
    }
    //ellipse(anchorPos.x, anchorPos.y, 10, 10);
    
  }

  void updateSensorsignals(PVector pos, PVector vel) {
    //Collision detectors
    frontSensorSignal = get(int(pos.x+sensorVectorFront.x), int(pos.y+sensorVectorFront.y))==-1?true:false;
    leftSensorSignal = get(int(pos.x+sensorVectorLeft.x), int(pos.y+sensorVectorLeft.y))==-1?true:false;
    rightSensorSignal = get(int(pos.x+sensorVectorRight.x), int(pos.y+sensorVectorRight.y))==-1?true:false;  
    //Crash detector
    color color_car_position = get(int(pos.x), int(pos.y));
    if (color_car_position ==-1) {
      whiteSensorFrameCount = whiteSensorFrameCount+1;
    }
    
        if(red(color_car_position) == 63 && blue(color_car_position) == 204 && green(color_car_position) == 72 && !disqual){ // Blå målstreg
      blueDe = true;
      SensorFitnessUpdate=50;
    }
    
    if(red(color_car_position) == 236 && green(color_car_position) == 28 && blue(color_car_position) == 36 && blueDe){ // RØD målstreg
      redDe = true;
      SensorFitnessUpdate=100;
    }
    

    if (red(color_car_position)==14 && blue(color_car_position)==69 && green(color_car_position)==209 && blueDe && redDe && !greenDe) {//den grønne målstreg er detekteret
      SensorFitnessUpdate=200;
      lapTimeInFrames = frameCount - lastTimeInFrames; //LAPTIME BEREGNES - frames nu - frames sidst
      println(lapTimeInFrames);
      greenDe = true;
    }
    
    if(red(color_car_position)==14 && blue(color_car_position)==69 && green(color_car_position)==209 && !blueDe && !redDe ){ // Hvis den rammer den grønne målstreg uden at have den blå og røde
      SensorFitnessUpdate=1;
      disqual = true;
    }
    
    if(red(color_car_position)==236 && blue(color_car_position)==36 && green(color_car_position)==28 && !blueDe ){// Hvis den rammer den røde målstreg uden at have den blå.
      SensorFitnessUpdate=1;
      disqual = true;
    }
    
    //count clockWiseRotationFrameCounter
    centerToCarVector.set((height/2)-pos.x, (width/2)-pos.y);    
    float currentRotationAngle =  centerToCarVector.heading();
    float deltaHeading   =  lastRotationAngle - centerToCarVector.heading();
    clockWiseRotationFrameCounter  =  deltaHeading>0 ? clockWiseRotationFrameCounter + 1 : clockWiseRotationFrameCounter -1;
    lastRotationAngle = currentRotationAngle;
    
    updateSensorVectors(vel);
    
    anchorPos.set(pos.x,pos.y);
  }

  void updateSensorVectors(PVector vel) {
    if (vel.mag()!=0) {
      sensorVectorFront.set(vel);
      sensorVectorFront.normalize();
      sensorVectorFront.mult(sensorMag);
    }
    sensorVectorLeft.set(sensorVectorFront);
    sensorVectorLeft.rotate(-sensorAngle);
    sensorVectorRight.set(sensorVectorFront);
    sensorVectorRight.rotate(sensorAngle);
  }
  
  float senFitness(){
    
    SensorFitness=SensorFitnessUpdate/(lapTimeInFrames/60);
    /* // remove the ones that touch the white, but that also makes the arraylist smaller, which is bad.
    for (int i = carSystem.population.size()-1 ; i >= 0;  i--) { // removes cars that go offroad.
        SensorSystem s = carSystem.population.get(i).sensorSystem;
        if(s.whiteSensorFrameCount > 60){
          carSystem.population.remove(carSystem.population.get(i));
         }
    }
    */
    
    SensorFitness = pow(SensorFitness, 4);// makes it exponential, so that good scores are even better ( 2^4 = 8 while 8^4 = 4096)

    if(whiteSensorFrameCount > 60) SensorFitness*=0.1; // romoves 90% fitness if they go offroad
    if(whiteSensorFrameCount < 60) SensorFitness*=2; // double fitness if they stay on road
   
    return SensorFitness+1/(lapTimeInFrames/60);
  }

}
