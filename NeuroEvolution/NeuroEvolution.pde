//
int menu = 1;
Button btn1;

PImage trackImage;


void setup() {
  size(1000, 800);
  frameRate(240);
  trackImage = loadImage("Track.png");

  btn1 = new Button(width/2, height/2, 200, 80, "Start", 1);
}

void draw() {

  switch(menu) {
  case 1:
    background(255);
    drawMenu();

    break;
  case 2:
    //Do something
    image(trackImage,0,0);
    drawEvolution();

    break;

  default:
    println("Something gone bad");
  }
}

void mouseClicked() {
  btn1.clicked();
}

void drawMenu() {
  btn1.display();
}

void drawEvolution(){
  fill(1);
}
