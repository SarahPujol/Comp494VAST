class TimeStamp{
  String day;
  int time, hour, min, sec;
  ArrayList<Action> actions;
  
  TimeStamp(String tempDay, String tempTime, ArrayList<Action> tempActions){
    day = tempDay;
    stringTimeConversion(tempTime);
    actions = tempActions;
  }
  
  void stringTimeConversion(String tempTime){
    String[] times = tempTime.split(":");
    hour = Integer.parseInt(times[0]);
    min = Integer.parseInt(times[1]);
    sec = Integer.parseInt(times[2]);
    time = hour * 3600 + min * 100 + sec;
  }
  
  void drawActions(float maxX, float maxY){
    for(Action a: actions){
      a.drawAction(maxX, maxY);
    }
  }
  
  void addAction(Action a){
    actions.add(a);
  }
  
  int getSec(){
    return sec;
  }
  
  int getMin(){
    return min;
  } 
  
  int getHour(){
    return hour;
  }
  
  int getTime(){
    return time;
  }
  
  String getDay(){
    return day;
  }
  
  ArrayList<Action> getActions(){
    return actions;
  }
  
  void printActions(){
    for(Action a: actions){
      System.out.print(a);
    }
  }

  String toString(){
    String s = String.valueOf(time) + "/" + actions.size();
    return s;
  }
  
  
}