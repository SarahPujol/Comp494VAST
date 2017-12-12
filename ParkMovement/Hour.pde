class Hour{
  Integer hour;
  float xCoord = -1.0;
  color clr;
  final float HIGH = 1225; //bottom of bar
  final float LOW = 325; //top of bar
  float filterUpper = LOW;
  float filterLower = HIGH;
  boolean isUpper = false;
  
  Hour(Integer tempHour){
    hour = tempHour;
    clr = color(150);
  }
  
  void setX(float newX){
    xCoord = newX;
  }
  
  //sets the new upper filter point
  void setFilterUpper(float newU){
    //Check if the new position has passed or on the other limit
    float newUpper = newU;
    if (! (newUpper>=filterLower || newUpper < LOW || newUpper > HIGH)){
      filterUpper = newUpper;
    }
  }
  
  //sets the new lower filter point
  void setFilterLower(float newL){
    //Check if the new position has passed or on the other limit
    float newLower = newL;
    if (! (newLower<=filterUpper || newLower < LOW || newLower > HIGH)){
      filterLower = newLower;
    }
  }
  
  //Checks wich filter to change
  void setFilter(float mouse, float filterBarSize){
    if(isUpper){
      if((mouse+filterBarSize)>=filterLower){
        isUpper = false;
      }
      setFilterUpper(mouse+filterBarSize);
    }
    else{
      if((mouse-filterBarSize)<=filterUpper){
        isUpper = true;
      }
      setFilterLower(mouse-filterBarSize);
    }
  }
  
  void setIsUpper(boolean isIt){isUpper = isIt;}
  
  void setColor(color newClr){
    clr = newClr;
  }
}