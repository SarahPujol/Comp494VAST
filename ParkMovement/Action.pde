class Action{
  int ID, x, y;
  String moveType;
  
  Action(String tempID, String tempX, String tempY, String tempMoveType){
    ID =  Integer.parseInt(tempID);
    x =  Integer.parseInt(tempX);
    y =  Integer.parseInt(tempY);
    moveType = tempMoveType;
  }
}