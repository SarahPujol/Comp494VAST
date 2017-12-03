class Location{
  HashMap<Integer, Integer> hourToNumPeople;
  Integer locNum;
  Position pos;
  color clr;
  boolean isChosen;
  
  Location(int tempNum, Position tempP){
    hourToNumPeople = new HashMap<Integer, Integer>();
    locNum = tempNum;
    clr = color(0);
    pos = tempP;
    isChosen = false;
  }
  
  void setColor(color tempColor){
    clr = tempColor;
  }
  
  void addEntry(int hour){
    if (hourToNumPeople.containsKey(hour)){
      int count = hourToNumPeople.get(hour);
      hourToNumPeople.put(hour, count+1);
    }
    else{
      hourToNumPeople.put(hour, 1);
    }
  }
  
  void displayPosition(){
    if(isChosen){
      fill(255);
    }
    else{
      fill(125);
    }
  }
  
  void setChosen(boolean fate){
    isChosen = fate;
  }
}