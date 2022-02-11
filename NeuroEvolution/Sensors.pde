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
  boolean GreenDetection;
  boolean blueDe;
  boolean redDe;
  int     lastTimeInFrames      = 0;
  int     lapTimeInFrames       = 10000;
  
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
    //Laptime calculation
    boolean currentGreenDetection =false;
    
        if(red(color_car_position) == 63 && blue(color_car_position) == 204 && green(color_car_position) == 72){
      blueDe = true;
      SensorFitnessUpdate+=100;
    }
    if(red(color_car_position) == 236 && green(color_car_position) == 28 && blue(color_car_position) == 36 && blueDe == true){
      redDe = true;
      SensorFitnessUpdate+=100;
      
    }

    if (red(color_car_position)==14 && blue(color_car_position)==69 && green(color_car_position)==209 && blueDe == true && redDe == true) {//den grønne målstreg er detekteret
      currentGreenDetection = true;
      SensorFitnessUpdate+=100;
      GreenDetection = currentGreenDetection; //Husker om der var grønt sidst
    }
    if(red(color_car_position)==14 && blue(color_car_position)==69 && green(color_car_position)==209 && !blueDe && !redDe ){
      SensorFitnessUpdate-=3;
    }
    
    if(red(color_car_position)==236 && blue(color_car_position)==36 && green(color_car_position)==28 && !blueDe ){
      SensorFitnessUpdate-=3;
    }
    
    if (GreenDetection && !currentGreenDetection) {  //sidst grønt - nu ikke -vi har passeret målstregen 
      lapTimeInFrames = frameCount - lastTimeInFrames; //LAPTIME BEREGNES - frames nu - frames sidst
      lastTimeInFrames = frameCount;
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
    SensorFitness=SensorFitnessUpdate/(lapTimeInFrames);
    
    SensorFitness=pow(SensorFitness, 4); // To make the good even better, make thier genes much more
    
    if(this.whiteSensorFrameCount > 0) SensorFitness*=0.1; // if whitespace touched remove 90% of fitness
    if(whiteSensorFrameCount <=0) SensorFitness*=2; // if no whitespace detected * 2 fitness
   
    return SensorFitness+1;
  }
}
