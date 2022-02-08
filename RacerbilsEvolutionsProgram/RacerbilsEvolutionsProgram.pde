//populationSize: Hvor mange "controllere" der genereres, controller = bil & hjerne & sensorer
int       populationSize  = 100;     

//CarSystem: Indholder en population af "controllere" 
CarSystem carSystem       = new CarSystem(populationSize);

//trackImage: RacerBanen , Vejen=sort, Udenfor=hvid, Målstreg= 100%grøn 
PImage    trackImage;
PImage    car_1, car_2, car_3, car_4, car_5, car_6, car_7;

void setup() {
  size(500, 600);
  loadImages();
}

void draw() {
  clear();
  fill(255);
  rect(0,50,1000,1000);
  image(trackImage,width/2,height/2);  

  carSystem.updateAndDisplay();
  
  //TESTKODE: Frastortering af dårlige biler, for hver gang der går 200 frame - f.eks. dem der kører uden for banen
  if (frameCount%200==0) {
      println("FJERN DEM DER KØRER UDENFOR BANEN frameCount: " + frameCount);
      for (int i = carSystem.CarControllerList.size()-1 ; i >= 0;  i--) {
        SensorSystem s = carSystem.CarControllerList.get(i).sensorSystem;
        if(s.whiteSensorFrameCount > 0){
          carSystem.CarControllerList.remove(carSystem.CarControllerList.get(i));
         }
      }
    }
    //
}

void loadImages(){
  imageMode(CENTER);
  trackImage = loadImage("track.png");
  car_1 = loadImage("Red_CAR.png");
  car_2 = loadImage("Blue_CAR.png");
  car_3 = loadImage("Neon_CAR.png");
  car_4 = loadImage("Black_CAR.png");
  car_5 = loadImage("Orange_CAR.png");
  car_6 = loadImage("Green_CAR.png");
  car_7 = loadImage("Purple_CAR.png");
  car_1.resize(50,25);
  car_2.resize(50,25);
  car_3.resize(50,25);
  car_4.resize(50,25);
  car_5.resize(50,25);
  car_6.resize(50,25);
  car_7.resize(50,25);
}

PImage pickCar(int n){
  PImage ximage = null;
  switch(n){
    case 1:
      ximage= car_1;
      break;
    case 2:
      ximage= car_2;
      break;
    case 3:
      ximage= car_3;
      break;
    case 4:
      ximage= car_4;
      break;
    case 5:
      ximage= car_5;
      break;
    case 6:
      ximage= car_6;
      break;
    case 7:
      ximage= car_7;
      break;
  }
  return ximage;
}
