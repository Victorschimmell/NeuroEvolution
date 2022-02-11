//
int menu = 1;
Button btn1, btn2;

PImage trackImage;
PImage car_1, car_2, car_3, car_4, car_5;

int populationSize  = 200;     

//CarSystem: Indholder en population af "controllere" 
Population carSystem;

float spawn_x;
float spawn_y;
boolean scannedMap = false;

int lifecycle;          // Timer for cycle of generation
int recordtime;         // Fastest time to target
int lifetime;  // How long should each generation live
float mutationrate = 0.005;
float varians  = 2; //hvor stor er variansen på de tilfældige vægte og bias
int recordholder;

boolean showAll;

void setup() {
  size(1000, 800);
  frameRate(60);
  loadImages();

  // The number of cycles we will allow a generation to live
  lifetime = 900;

  // Initialize variables
  lifecycle = 0;
  recordtime = lifetime;

  btn1 = new Button(width/2, height/2, 200, 80, "Start", 1);

  btn2 = new Button(width/2, height/2+100, 200, 80, "Options", 2);
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

    break;
  case 3:
    drawCustom();
    break;

  default:
    println("Something gone bad");
  }
}

void mouseClicked() {
  btn1.clicked();
  btn2.clicked();
}

void drawMenu() {
  btn1.display();
  btn2.display();
}

void drawCustom() {
  background(255);
}

void drawEvolution() {

  if (scannedMap) {
    if (lifecycle < lifetime) {
      carSystem.getMaxFitness();
      carSystem.updateAndDisplay();
      if ((lifecycle < recordtime)) {
        recordtime = lifecycle;
      }
      lifecycle++;
      // Otherwise a new generation
    } else {
      lifecycle = 0;
      carSystem.fitness();
      carSystem.selection();
      carSystem.reproduction();
    }
    fill(1);
    textSize(13);
    text(frameRate, width-100, 20);
  }
}


void loadImages() {
  imageMode(CENTER);
  trackImage = loadImage("track_2.png");
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

  if (key== 'n') {
    if (showAll) showAll = false;
  } else {
    showAll = true;
  }
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
