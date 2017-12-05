class Location{
  HashMap<Integer, Integer> hourToNumPeople;
  HashMap<Integer, Float> hourToYCoord;
  final float HIGH = 1200; //bottom of bar
  final float LOW = 300; //top of bar
  Integer locNum;
  Position pos;
  color clr;
  boolean isFiltered = false;
  boolean isChosen = false;
  float boxX, boxY = -1.0;
  float boxSize = 15;
  
  Location(int tempNum, Position tempP){
    hourToNumPeople = new HashMap<Integer, Integer>();
    hourToYCoord = new HashMap<Integer, Float>();
    locNum = tempNum;
    clr = color(0);
    pos = tempP;
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
  
  void scaleYCoord(int popMax){
    for(HashMap.Entry<Integer, Integer> entry: hourToNumPeople.entrySet()){
      hourToYCoord.put(entry.getKey(), (1-((float)entry.getValue())/popMax)*(HIGH-LOW)+LOW);
    }
  }
  
  void displayPosition(){
    if(isChosen){
      fill(200);
    }
    else{
      fill(50);
    }
    rect(boxX, boxY, boxSize, boxSize);
  }
  
  void setBoxBounds(){
    boxX = pos.getCanvX() - 7.0;
    boxY = pos.getCanvY() - 7.0;
  }
  
  void setChosen(boolean fate){
    isChosen = fate;
  }
  
  void setFiltered(boolean fate){
    isFiltered = fate;
  }
}