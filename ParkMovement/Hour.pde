class Hour{
  Integer hour;
  float xCoord = -1.0;
  color clr;
  boolean filter;
  float max;
  float min;
  
  Hour(Integer tempHour){
    hour = tempHour;
    filter = false;
    clr = color(255);
  }
  
  void setX(float newX){
    xCoord = newX;
  }
  
  void setMaxMin(float tempMax, float tempMin){
    max = tempMax;
    min = tempMin;
  }
  
  void displayBar(){
  }
  
  void changeFilter(boolean filterB){
    filter = filterB;
  }
  
  void setColor(color newClr){
    clr = newClr;
  }
}