class Location{
  HashMap<Integer, Integer> hourToNumPeople;
  HashMap<Integer, Float> hourToYCoord;
  final float HIGH = 1225; //bottom of bar
  final float LOW = 325; //top of bar
  Integer locNum;
  Position pos;
  color clr;
  boolean isFiltered = false;
  boolean isChosen = false;
  float boxX, boxY = -1.0;
  float boxSize = 15;
   String locationName = "";
  
  
  Location(Position tempP){
    hourToNumPeople = new HashMap<Integer, Integer>();
    hourToYCoord = new HashMap<Integer, Float>();

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
  
  void displayPosition(int hour, int max){
    if(isChosen){
      //TODO color
      fill(199, 21, 133);
      textSize(20);
      float textX = pos.getCanvX();
      if(pos.getCoordX()>50){
        textAlign(RIGHT, CENTER);
        textX -= 20;
      }
      else{
        textAlign(LEFT, CENTER);
        textX += 20;
      }
      text(locationName,textX,pos.getCanvY());
      fill(199, 21, 133);
    }
    //TODO the color need to change to make it more obvious
    else{
      if (hourToNumPeople.containsKey(hour)){
        fill((float)hourToNumPeople.get(hour)/max * 255 );
        
      }
      else{
      fill(0);
    }
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
  
    void setLocationName (String newName){
    locationName = newName;
  }
}