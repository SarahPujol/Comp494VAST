class Position{
  float canvX, canvY = 0;
  float coordX, coordY;
  
  Position(float tempX, float tempY){
    coordX = tempX;
    coordY = tempY;
  }

  void scalePositionToCanvas(float maxX, float maxY)  {
    canvX = coordX/maxX * width/2 + width/2;
    canvY = height - coordY/maxY * height;
  }
  
  float getCoordX(){
    return coordX;
  }
  
  float getCoordY(){
    return coordY;
  }
  
  float getCanvX(){
    return canvX;
  }
  
  float getCanvY(){
    return canvY;
  }
  
  void setXAndY(float newX, float newY){
    coordX = newX;
    coordY = newY;
  }
  
  @Override
  int hashCode(){
    return Float.hashCode(coordX) + Float.hashCode(coordY);
    
  }
  
  @Override
  boolean equals(Object value){
    if (value != null && value instanceof Position){
      Position p = (Position) value;
      return abs(this.coordY - p.getCoordY()) < .001 && abs(this.coordX - p.getCoordX()) < .001;
    }
    else{
      return false;
    }
  }
}