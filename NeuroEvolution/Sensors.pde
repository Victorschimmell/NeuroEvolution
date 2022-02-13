class Sensors {
  //Sensors - alle bilens sensorer - ogå dem der ikke bruges af "hjernen"

  //wall detectors
  float sensorMag = 50;
  float sensorAngle = PI*2/8;

  PVector anchorPos = new PVector();

  PVector fSensorPos = new PVector(0, sensorMag), lSensorPos = new PVector(0, sensorMag), rSensorPos = new PVector(0, sensorMag);

  boolean fSensor = false, lSensor= false, rSensor = false;

  //crash detection
  int whiteFrame    = 0; //udenfor banen

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
    stroke(1);
    strokeWeight(0.5);
    if (fSensor) { 
      fill(255, 0, 0);
      ellipse(anchorPos.x+fSensorPos.x, anchorPos.y+fSensorPos.y, 8, 8);
    }
    if (lSensor) { 
      fill(255, 0, 0);
      ellipse( anchorPos.x+lSensorPos.x, anchorPos.y+lSensorPos.y, 8, 8);
    }
    if (rSensor) { 
      fill(255, 0, 0);
      ellipse( anchorPos.x+rSensorPos.x, anchorPos.y+rSensorPos.y, 8, 8);
    }
    line(anchorPos.x, anchorPos.y, anchorPos.x+fSensorPos.x, anchorPos.y+fSensorPos.y);
    line(anchorPos.x, anchorPos.y, anchorPos.x+lSensorPos.x, anchorPos.y+lSensorPos.y);
    line(anchorPos.x, anchorPos.y, anchorPos.x+rSensorPos.x, anchorPos.y+rSensorPos.y);

    strokeWeight(2);
    if (whiteFrame>0) {
      fill(whiteFrame*10, 0, 0);
    } else {
      fill(0, clockWiseRotationFrameCounter, 0);
    }
    //ellipse(anchorPos.x, anchorPos.y, 10, 10);
  }

  void updateSensorsignals(PVector pos, PVector vel) {
    //Collision detectors
    fSensor = get(int(pos.x+fSensorPos.x), int(pos.y+fSensorPos.y))==-1?true:false;
    lSensor = get(int(pos.x+lSensorPos.x), int(pos.y+lSensorPos.y))==-1?true:false;
    rSensor = get(int(pos.x+rSensorPos.x), int(pos.y+rSensorPos.y))==-1?true:false;  
    //Crash detector
    color color_car_position = get(int(pos.x), int(pos.y));
    if (color_car_position ==-1) {
      whiteFrame = whiteFrame+1;
    }

    if (red(color_car_position) == 63  && green(color_car_position) == 72 && blue(color_car_position) == 204 && !disqual && !greenDe) { // Blå målstreg
      blueDe = true;
      SensorFitnessUpdate=50;
    }

    if (red(color_car_position) == 236 && green(color_car_position) == 28 && blue(color_car_position) == 36 && blueDe && !greenDe) { // RØD målstreg
      redDe = true;
      SensorFitnessUpdate=100;
    }


    if (red(color_car_position)==14  && green(color_car_position)==209 && blue(color_car_position)==69 && blueDe && redDe && !greenDe) {//den grønne målstreg er detekteret
      SensorFitnessUpdate=200;
      lapTimeInFrames = frameCount - lastTimeInFrames; //LAPTIME BEREGNES - frames nu - frames sidst
      greenDe = true;
    }

    if (red(color_car_position)==14 && blue(color_car_position)==69 && green(color_car_position)==209 && !blueDe && !redDe ) { // Hvis den rammer den grønne målstreg uden at have den blå og røde
      SensorFitnessUpdate=1;
      disqual = true;
    }

    if (red(color_car_position)==236 && blue(color_car_position)==36 && green(color_car_position)==28 && !blueDe ) {// Hvis den rammer den røde målstreg uden at have den blå.
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

    anchorPos.set(pos.x, pos.y);
  }

  void updateSensorVectors(PVector vel) {
    if (vel.mag()!=0) {
      fSensorPos.set(vel);
      fSensorPos.normalize();
      fSensorPos.mult(sensorMag);
    }
    lSensorPos.set(fSensorPos);
    lSensorPos.rotate(-sensorAngle);
    rSensorPos.set(fSensorPos);
    rSensorPos.rotate(sensorAngle);
  }

  float senFitness() {

    SensorFitness=SensorFitnessUpdate/(lapTimeInFrames/60);

    // remove the ones that touch the white, but that also makes the arraylist smaller, which is bad.

    for (int i = carSystem.population.size()-1; i >= 0; i--) { // removes cars that go the wrong way.
      if (carSystem.population.get(i).Sensors.disqual == true) {
        carSystem.population.remove(carSystem.population.get(i));
      } else if (carSystem.population.get(i).Sensors.whiteFrame > 0) {
        carSystem.population.remove(carSystem.population.get(i));
      }else{
        
      }
    }

    SensorFitness = pow(SensorFitness, 4);// makes it exponential, so that good scores are even better ( 2^4 = 8 while 8^4 = 4096)

    /*
    if (whiteFrame > 60) SensorFitness*=0.1; // romoves 90% fitness if they go offroad
     if (whiteFrame < 60) SensorFitness*=2; // double fitness if they stay on road
     */

    return SensorFitness+1/(lapTimeInFrames/60);
  }


  float getLapTime() {
    return lapTimeInFrames;
  }
}
