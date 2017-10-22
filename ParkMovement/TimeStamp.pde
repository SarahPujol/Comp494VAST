class TimeStamp{
  String day;
  int time, hour, min, sec;
  ArrayList<Action> actions = new ArrayList<Action>();
  
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
    time = hour * 10000 + min * 100 + sec;
  }

  String toString(){
    String s = String.valueOf(time) + "/" + String.valueOf(actions.size());
    return s;
  }
  
  
}