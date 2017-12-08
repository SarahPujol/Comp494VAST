class Person{
  int ID;
  float x, y;
  HashMap<Integer, Integer> timeToOrder = new HashMap<Integer, Integer>();
  ArrayList<Position> positionOrder = new ArrayList<Position>();
  int lastTime = -1;
  int positionCount = 0;
  color clr = color(0, 191, 255);
//  int pastTime = -1;
  
  Person(int tempID){
    ID =  tempID;
  }
  
  void display(int currentTime){
    fill(clr, 191);
    stroke(clr, 191);
    strokeWeight(5);
    if(timeToOrder.containsKey(currentTime)){
      fill(clr, 191);
      stroke(clr, 191);
      if(timeToOrder.get(currentTime)+1 < positionOrder.size()){
        drawArrow(positionOrder.get(timeToOrder.get(currentTime)), positionOrder.get(timeToOrder.get(currentTime)+1));
       // pastTime = currentTime;
      }
      else{
        drawArrow(positionOrder.get(timeToOrder.get(currentTime)), positionOrder.get(timeToOrder.get(currentTime)));
      }
    }
    //else if (currentTime > lastTime || pastTime > currentTime){
     // pastTime = -1;
    //}
    //else if (pastTime != -1){
   //   fill(clr, 50);
   //   stroke(clr, 50);
   //   ellipse(positionOrder.get(timeToOrder.get(pastTime)).getCanvX()-2.5, positionOrder.get(timeToOrder.get(pastTime)).getCanvY()-2.5, 5,5);
   // }
  }
  
  void drawArrow(Position currP, Position newP){
    float currX = currP.getCanvX();
    float currY = currP.getCanvY();
    float newPX = newP.getCanvX();
    float newPY = newP.getCanvY();
    float distance = sqrt(sq(newPX-currX)+ sq(newPY-currY));
    float newX = currX+((newPX-currX)*15/distance);
    float newY = currY+((newPY-currY)*15/distance);
    
    ellipse(currX+((newPX-currX)*14/distance),currY+((newPY-currY)*14/distance),5,5);
    line(currX, currY, newX, newY);
  }
  
  int getID(){
    return ID;
  }
  
  ArrayList<Position> getPositions(){
    return positionOrder;
  }
  
  void addEntry(int pTime, Position p){
    positionOrder.add(p);
    timeToOrder.put(pTime, positionCount);
    lastTime = pTime;
    positionCount ++;
  }
  
  color getColor(){
    return clr;
  }
}