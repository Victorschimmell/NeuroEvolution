//
int menu = 1;
Button btn1;


void setup() {
  size(640, 360);
  frameRate(240);

  btn1 = new Button(width/2, height/2, 100, 40, "Start", 1);
}

void draw() {

  switch(menu) {
  case 1:
    background(255);
    drawMenu();

    break;
  case 2:
    //Do something
    background(255);
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
  text("Hello World!", width/2, height/2);
}
