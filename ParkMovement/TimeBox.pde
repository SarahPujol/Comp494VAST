class TimeBox{
  float x,y;
  String hour;
  
  TimeBox(String tempHour, float tempX, float tempY){
    x = tempX;
    y = tempY;
    hour = tempHour;
  }
  
  float getX(){
    return x;
  }
  
  float getY(){
    return y;
  }
  
  String getHour(){
    return hour;
  }
}