class Car {  
  //Bil - indeholder position & hastighed & "tegning"
  PVector pos = new PVector(60, 232);
  PVector vel = new PVector(0, 5);
  int n = int(random(1,5.9));
  
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
