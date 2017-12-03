class Person{
  int ID;
  float x, y;
  HashMap<Integer, Integer> timeToOrder = new HashMap<Integer, Integer>();
  ArrayList<Position> positionOrder = new ArrayList<Position>();
  int lastTime = -1;
  int positionCount = 0;
  color clr;
  int pastTime = -1;
  
  Person(int tempID, color tempColor){
    ID =  tempID;
    clr = tempColor;
  }
  
  void display(int currentTime){
    fill(clr, 191);
    stroke(clr, 191);
    strokeWeight(5);
    if(timeToOrder.containsKey(currentTime)){
      fill(clr, 191);
      stroke(clr, 191);
      if(timeToOrder.get(currentTime)+1 < positionOrder.size()){
        drawArrow(positionOrder.get(timeToOrder.get(currentTime)), positionOrder.get(timeToOrder.get(currentTime)+1), maxX, maxY);
        pastTime = currentTime;
      }
      else{
        drawArrow(positionOrder.get(timeToOrder.get(currentTime)), positionOrder.get(timeToOrder.get(currentTime)), maxX, maxY);
      }
    }
    else if (currentTime > lastTime || pastTime > currentTime){
      pastTime = -1;
    }
    else if (pastTime != -1){
      fill(clr, 50);
      stroke(clr, 50);
      ellipse(positionOrder.get(timeToOrder.get(pastTime)).getCanvX()-2.5, positionOrder.get(timeToOrder.get(pastTime)).getCanvY()-2.5, 5,5);
    }
  }
  
  void drawArrow(Position currP, Position newP, float maxX, float maxY){
    
    //float[] center = {maxX/2, maxY/2};
    float currX = currP.getCanvX();
    float currY = currP.getCanvY();
    float newPX = newP.getCanvX();
    float newPY = newP.getCanvY();
    float distance = sqrt(sq(newPX-currX)+ sq(newPY-currY));
    float newX = currX+((newPX-currX)*15/distance);
    float newY = currY+((newPY-currY)*15/distance);
    PVector v1 = new PVector(15,0);
    PVector v2 = new PVector(newX, newY);
    v1.normalize();
    v2.normalize();
    float a = PVector.angleBetween(v1, v2);
    //print(a);
    float sinValue = sin(a);
    float cosValue = cos(a); 
    float[] originalTriangle = {10,-5,10,5};
    float wing1X = originalTriangle[0]*cosValue - originalTriangle[1]*sinValue + currX;
    float wing1Y = originalTriangle[0]*sinValue + originalTriangle[1]*cosValue + currY;
    float wing2X = originalTriangle[2]*cosValue - originalTriangle[3]*sinValue + currX;
    float wing2Y = originalTriangle[2]*sinValue + originalTriangle[3]*cosValue + currY;
    
    line(currX, currY, newX, newY);
    //println();
    //println("NextTriangle");
    //println(newX, newY);
    //println(wing1X, wing1Y);
    //println(wing2X, wing2Y);
    //triangle(newX, newY, wing1X, wing1Y, wing2X, wing2Y);
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