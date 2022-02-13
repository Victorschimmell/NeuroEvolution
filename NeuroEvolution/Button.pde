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
    rectMode(CORNER);
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

      if (selected) {
        currentColor = highlighted;

        switch(id) {
        case 1:
          // code block
          menu = 2;
          image(trackImage, width/2, height/2);
          scanMap();
          lifecycle = 0;
          record = 100000;
          selected = false;
          break;
        case 2:
          menu = 3;
          // code block
          selected = false;
          break;
        case 3: 
          menu = 1;

          selected = false;
          break;
        case 4: 
          if(currentTrack<8){
            currentTrack= currentTrack+1;
            String track = "track_" + currentTrack + ".png";
            trackImage = loadImage(track);
            trackImage.resize(width, height);
            displayImage = loadImage(track);
            displayImage.resize(width/2,height/2);
            println("track_"+currentTrack);

            selected = false;
            break;
          }else{
            println("Track 1");
            currentTrack=1;
            String track = "track_" + currentTrack + ".png";
            
            trackImage = loadImage(track);
            displayImage = loadImage(track);
            displayImage.resize(width/2,height/2);
          }


        default:
          // Do nothing
        }
      } else {
        currentColor = defaultColor;
      }
    }
  }
}
