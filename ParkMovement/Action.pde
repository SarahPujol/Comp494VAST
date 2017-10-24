class Action{
  int ID;
  float x, y;
  String moveType;
  
  Action(String tempID, float tempX, float tempY, String tempMoveType){
    ID =  Integer.parseInt(tempID);
    x =  tempX;
    y =  tempY;
    moveType = tempMoveType;
  }
  
  void drawAction(float maxX, float maxY){
    stroke(0);
    fill(0);
    ellipse(x/maxX*width, height - y/maxY*height, 10, 10);
  }
  
  int getID(){
    return ID;
  }
  
  float getX(){
    return x;
  }
  
  float getY(){
    return y;
  }
  
  String getMoveType(){
    return moveType;
  }
  
  String toString(){
    String s = "ID: " + ID + ", x: " + x + ", y:" + ", action: " + moveType + "\n";
    return s;
  }
}