class Vehicle {  
  //Bil - indeholder position & hastighed & "tegning"
  PVector pos;
  PVector vel;
  int n;
  float angle;
  int r;
  
  Vehicle(PVector startPos, PVector Hastighed){
    this.n = int(random(1,5.9));
    
    this.pos = startPos;
    this.vel = Hastighed;
    this.r = int(random(15,25));
  }
  
  void turnCar(float turnAngle){
    vel.rotate(turnAngle);
  }

  void displayCar() {
    
    if(pos.y>height/2){
      pushMatrix();
      scale(-1,1);
      image(pickCar(n), -pos.x, pos.y);
      popMatrix();
    }else{
      image(pickCar(n), pos.x, pos.y);
    }
    
    /*
    stroke(1);
    fill(255);
    circle(pos.x, pos.y, r);
    */
  }
    
    
  
  void update() {
    pos.add(vel);
  }
  
  
}
