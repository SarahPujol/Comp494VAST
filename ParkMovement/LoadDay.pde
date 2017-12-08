

class LoadDay{
  String[] day, names;
  ArrayList<Integer> allTimes = new ArrayList<Integer>();
  HashMap<Integer, Integer> hourToMaxPop = new HashMap<Integer, Integer>();
  float maxX, maxY = 0;
  int popMax = 680;
  HashMap<Position, String> positionToLocName = new HashMap<Position,String>();
  
  LoadDay(String[] tempDay, String[]tempLocName){
    day = tempDay;
    names = tempLocName;
  }
  
  void createPeople(HashMap<Integer, Person> IDtoPeople, ArrayList<Hour> allHours, HashMap<Position, Location> positionToLocations){
    Position tempPosition = new Position(0.0, 0.0);
    for(int i=0; i<names.length; i++){
      String[]initialData = names[i].split(",");
      String locName = initialData[0];
      Position locPos = new Position(Float.parseFloat(initialData[1]), Float.parseFloat(initialData[2]));
      positionToLocName.put(locPos, locName);
    }
    for (int i = 1; i < day.length; i++){
      String[] initialData = day[i].split("\\s")[1].split(",");
      int[] times = stringTimeConversion(initialData[0]);
      int hour = times[0];
      //Finds out how many hours there are
      int h = hour / 3600;
      if(allHours.size() == 0 || allHours.get(allHours.size()-1).hour!=h){
        allHours.add(new Hour(h));
      }
      int ID = Integer.parseInt(initialData[1]);
      float[] coord = checkMaxDim(initialData[3], initialData[4]);
    
      if(IDtoPeople.containsKey(ID)){
        Person p = IDtoPeople.get(ID);
        p.addEntry(times[0], new Position(coord[0], coord[1]));
      }
      else{
        Person p = new Person(ID);
        p.addEntry(times[0], new Position(coord[0], coord[1]));
        IDtoPeople.put(ID, p);
      }
      
      if(initialData[2].equals("check-in")){
        
        tempPosition.setXAndY(coord[0], coord[1]);
        if(positionToLocations.containsKey(tempPosition)){
          positionToLocations.get(tempPosition).addEntry(h);
        }
        else{
          Position pop = new Position(coord[0], coord[1]);
          Location l = new Location( pop);
          l.addEntry(h);
          positionToLocations.put(pop, l);
        }
      }
    }
    
    for (Person entry: IDtoPeople.values()){
      for (Position pos: entry.positionOrder){
        pos.scalePositionToCanvas(maxX, maxY);
      }
    }
    
  
    
    
     for (int i=0; i<allHours.size(); i++){
         Hour h = allHours.get(i);
         int hourMax = 0;
      for(Map.Entry<Position, Location> entry : positionToLocations.entrySet()){
        Location l = entry.getValue();
        if (positionToLocName.containsKey(entry.getKey())){  
          l.setLocationName(positionToLocName.get(entry.getKey()));
        }
        if (l.hourToNumPeople.get(h.hour)!= null){    
          if (l.hourToNumPeople.get(h.hour)>popMax){
              l.hourToNumPeople.put(h.hour, popMax);
            }
          if (l.hourToNumPeople.get(h.hour)>hourMax){
             hourMax = l.hourToNumPeople.get(h.hour);
            }
        }
      }
      
      hourToMaxPop.put(h.hour, hourMax);
     
     }
    //Sets up the colors for each location
    int i = 0;
    for(Location entry: positionToLocations.values()){
      if(i % 2 == 0){
        LABColor red = new LABColor(color(255,0,0));
        LABColor blue = new LABColor(color(0,255,255));
        color c = red.lerp(blue, float(i)/float(positionToLocations.size())).rgb;
        entry.setColor(c);
      }
      else{
        LABColor green = new LABColor(color(0, 255,0));
        LABColor purple = new LABColor(color(255,0,255));
        color c = green.lerp(purple, float(i)/float(positionToLocations.size())).rgb;
        entry.setColor(c);
      }
  
      entry.pos.scalePositionToCanvas(maxX, maxY);
      entry.scaleYCoord(popMax);
      entry.setBoxBounds();
      i++;
    }
}
  TimeBox[] createBoxes(){
    TimeBox[] timeBoxes;
  
    //Instantiate the number of timeBoxes
    timeBoxes = new TimeBox[allHours.size()];
    float x = 0;
    float y = 0;
    float bWidth = BOXWIDTH+10.0;
    for(int i = 0; i < timeBoxes.length; i++){
      //int j = floor(i / 8);
      if (i < 8){
        x = width/2 - bWidth*(8-i) - 10.0;
        y = 150;
      }
      else{
        x = width/2 - bWidth*(8-i+8) - 10.0;
        y = 150 + bWidth;
      }
    
      TimeBox tB = new TimeBox(str(i+8), x, y);
      timeBoxes[i] = tB;
    }
    
    return timeBoxes;
  }
  
  private int[] stringTimeConversion(String tempTime){
    String[] times = tempTime.split(":");
    int hour = Integer.parseInt(times[0]);
    int min = Integer.parseInt(times[1]);
    int sec = Integer.parseInt(times[2]);
    int time = hour * 3600 + min * 60 + sec;
    return new int[]{time, hour, min, sec};
  }
  
  private float[] checkMaxDim(String x, String y){
    float actionX = Float.valueOf(x);
    float actionY = Float.valueOf(y);
    if(actionX > maxX){
      maxX = actionX;
    }
    if(actionY > maxY){
      maxY = actionY;
    }
    return new float[]{actionX, actionY};
  }
  
  int getPopMax(){return popMax;}
 
}