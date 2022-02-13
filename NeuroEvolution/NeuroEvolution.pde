//
int menu = 1;
Button btn1, btn2, btn3, btn4, btn5;

PImage trackImage;
PImage car_1, car_2, car_3, car_4, car_5;

int populationSize  = 100;     

//CarSystem: Indholder en population af "controllere" 
Population carSystem;

float spawn_x;
float spawn_y;
boolean scannedMap = false;

int lifecycle;          // Timer for cycle of generation
float record = 100000;

int lifetime;  // How long should each generation live
float mutationrate = 0.01;
float varians  = 2; //hvor stor er variansen på de tilfældige vægte og bias
int recordholder;

int lastTimeInFrames;
int fastLap;

boolean showAll = true;
boolean showSen = false;

String track;

void setup() {
  size(1000, 800);
  frameRate(60);
  loadImages();

  // The number of cycles we will allow a generation to live
  lifetime = 900;

  // Initialize variables
  lifecycle = 0;

  btn1 = new Button(width/2, height/2, 200, 80, "Start", 1);

  btn2 = new Button(width/2, height/2+100, 200, 80, "Options", 2);

  btn3 = new Button(70, height/20, 100, 40, "Back", 3);

  btn4 = new Button(width/4, height/2, 200, 80, "Track 1", 4);

  btn5 = new Button(width/4*3, height/2, 200, 80, "Track 2", 5);
}

void draw() {

  switch(menu) {
  case 1:
    background(255);
    drawMenu();

    break;
  case 2:
    //Do something
    image(trackImage, width/2, height/2);
    drawEvolution();
    btn3.display();

    break;
  case 3:
    drawCustom();
    btn3.display();
    break;

  default:
    println("Something gone bad");
  }
}

void mouseClicked() {
  if (menu == 1 ) {
    btn1.clicked();
    btn2.clicked();
  }
  if (menu == 2  || menu == 3) {
    btn3.clicked();
  }

  if (menu == 3) {
    btn4.clicked();
    btn5.clicked();
  }
}

void drawMenu() {
  textSize(70);
  fill(1);
  text("NeuroEvolution", width/2, height/5);
  btn1.display();
  btn2.display();
}

void drawCustom() {
  background(255);
  btn4.display();
  btn5.display();
}

void drawEvolution() {


  if (scannedMap) {
    if (lifecycle < lifetime) {
      carSystem.getMaxFitness();
      carSystem.updateAndDisplay();

      lifecycle++;
      // Otherwise a new generation
    } else {
      lifecycle = 0;
      try{
      carSystem.fitness();
      carSystem.selection();
      carSystem.reproduction();
      } catch (Exception e){
        println(e);
        carSystem = new Population(populationSize, mutationrate);
      }
      lastTimeInFrames = frameCount;
    }
    fill(1);
    textSize(13);
    text(round(frameRate) + " FPS", width-100, 20);
    text("Generation #: " + carSystem.getGenerations(), width-100, 40);
    text("Cycles left: " + (lifetime-lifecycle)+ "/900", width-100, 60);
    for (int i = 0; i < carSystem.population.size(); i++) {

      if (record > carSystem.population.get(i).sensorSystem.getLapTime()) {
        record = carSystem.population.get(i).sensorSystem.getLapTime();
      }
    }
    text("Best Lap: " + record + " frames", width-100, 80);
    text("Population Size: "+ carSystem.population.size(), width-100, 100);
    text("Toggle Sensors: m", width-100, 120);
    text("Toggle highest fitness: n", width-100, 140);
  }
}


void loadImages() {
  imageMode(CENTER);
  trackImage = loadImage("Track.png");
  trackImage.resize(width, height);

  car_1 = loadImage("Red_CAR.png");
  car_2 = loadImage("Blue_CAR.png");
  car_3 = loadImage("Purple_CAR.png");
  car_4 = loadImage("Green_CAR.png");
  car_5 = loadImage("Orange_CAR.png");
}

PImage pickCar(int n) {
  PImage ximage = null;
  switch(n) {
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
  }
  if (ximage != null) {
    ximage.resize(32, 16);
  } 
  return ximage;
}

void keyPressed() {

  if (key== 'n') showAll = !showAll;
  if(key == 'm') showSen = !showSen;
}

void scanMap() {
  int pixel_x = 0;
  int pixel_y = 0;
  for (pixel_x=0; pixel_x<width; pixel_x+=10) {
    for (pixel_y=0; pixel_y<height; pixel_y+=10) {
      if (get(pixel_x, pixel_y) == color(184, 61, 186)) {
        spawn_x = pixel_x;
        spawn_y = pixel_y;
        scannedMap = true;
        carSystem = new Population(populationSize, mutationrate);
        break;
      }
    }
  }
}
