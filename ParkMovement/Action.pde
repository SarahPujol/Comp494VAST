class Action{
  int ID;
  float x, y;
  String clr;
  String moveType;
  
  Action(String tempID, float tempX, float tempY, String tempMoveType){
    ID =  Integer.parseInt(tempID);
    x =  tempX;
    y =  tempY;
    moveType = tempMoveType;
  }
  
  void drawAction(float maxX, float maxY){
    if (moveType.equals("movement")){
      fill(0,252,0);
    }
    else{
      fill(252,0,0);
    }
    stroke(0);
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