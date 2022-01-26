class Button {
  
  PVector pos; //position
  float w, h; //size
  boolean selected; //is the button selected / on? true/false
  private color highlighted, defaultColor, currentColor;
  String label; 

  int id;

  Button(int x, int y, int w, int h, String input, int id) {
    noStroke();
    rectMode(CORNER);

    pos = new PVector(x, y);
    this.w = w;
    this.h = h;

    label = input;
    selected = false;

    highlighted = color(60); 
    defaultColor = color(100); //slightly darker?
    currentColor = defaultColor;

    this.id = id;
  }

  void display() {
    if ( mouseX > pos.x-w/2 && mouseX <  pos.x-w/2 + w  && mouseY > pos.y-h/2 && mouseY < pos.y-h/2+h) {
      currentColor = highlighted;
    } else {
      currentColor = defaultColor;
    }

    fill(currentColor);
    rect(pos.x-w/2, pos.y-h/2, w, h);
    textSize(40);
    textAlign(CENTER, CENTER);
    fill(255);
    text(label, pos.x, pos.y);
  }

  void clicked() {
    if ( mouseX > pos.x-w/2 && mouseX < pos.x-w/2 + w  && mouseY > pos.y-h/2 && mouseY < pos.y-h/2+h) {
      //mouse has been clicked
      selected = !selected;  //toggle the value between true and false
      if ( selected) {
        currentColor = highlighted;

        switch(id) {
        case 1:
          // code block
          menu = 2;
          break;
        case 2:
          // code block
          
          break;
        default:
          // Do nothing
        }
      } else {
        currentColor = defaultColor;
      }
    }
  }
}
