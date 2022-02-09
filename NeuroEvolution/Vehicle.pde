class Car {  
  //Bil - indeholder position & hastighed & "tegning"
  PVector pos;
  PVector vel;
  int n;
  float angle;
  
  Car(PVector startPos, PVector Hastighed){
    this.n = int(random(1,5.9));
    
    this.pos = startPos;
    this.vel = Hastighed;
    
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
  }
    
    
  
  void update() {
    pos.add(vel);
  }
  
  
}
