class LoadDay{
  String[] day, colors;
  ArrayList<Integer> allTimes = new ArrayList<Integer>();
  HashMap<Integer, Integer> colorGroups = new HashMap<Integer, Integer>();
  float maxX, maxY;
  
  LoadDay(String[] tempDay, String[] tempColors){
    day = tempDay;
    colors = tempColors;
    colorGroupings();
  }
  
  private void colorGroupings(){ 
    for (int i = 1; i < colors.length; i++){
      String[] IDgroups = colors[i].split(",");
      if(IDgroups[1].equals("59")){
        colorGroups.put(Integer.parseInt(IDgroups[0]), color(0,255,0));
      }
      else if(IDgroups[1].equals("4")){
        colorGroups.put(Integer.parseInt(IDgroups[0]), color(0,255,255));
      }
      else{
        colorGroups.put(Integer.parseInt(IDgroups[0]), color(220,220,200));
      }
    }
  }
  
  void createPeople(HashMap<Integer, Person> IDtoPeople, ArrayList<Hour> allHours, HashMap<Position, Location> positionToLocations){
    Position tempPosition = new Position(0.0, 0.0);
    for (int i = 1; i < day.length; i++){
      String[] initialData = day[i].split("\\s")[1].split(",");
      int[] times = stringTimeConversion(initialData[0]);
      int hour = times[0];
      //Finds out how many hours there are
      int h = hour / 3600;
      if(allHours.get(allHours.size()-1).hour!=h){
        allHours.add(new Hour(h));
      }
      int ID = Integer.parseInt(initialData[1]);
      float[] coord = checkMaxDim(initialData[3], initialData[4]);
      color clr;
      if (colorGroups.get(ID) != null){
         clr = colorGroups.get(ID);
      }
      else{
        clr = color(220,220,200);
      }
    
      if(IDtoPeople.containsKey(ID)){
        Person p = IDtoPeople.get(ID);
        p.addEntry(times[0], new Position(coord[0], coord[1]));
      }
      else{
        Person p = new Person(ID, clr);
        p.addEntry(times[0], new Position(coord[0], coord[1]));
        IDtoPeople.put(ID, p);
      }
      
      int locCount = 1;
      tempPosition.setXAndY(coord[0], coord[1]);
      if(positionToLocations.containsKey(tempPosition)){
        positionToLocations.get(tempPosition).addEntry(h);
      }
      else{
        Position pop = new Position(coord[0], coord[1]);
        positionToLocations.put(pop, new Location(locCount, pop));
        locCount ++;
      }
      
      for (Person entry: IDtoPeople.values()){
        for (Position pos: entry.positionOrder){
          pos.scalePositionToCanvas(maxX, maxY);
        }
      }
      for (Location entry: positionToLocations.values()){
        entry.pos.scalePositionToCanvas(maxX, maxY);
      }
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
      int j = floor(i / 2);
      if (i % 2 == 0){
        x = width/2 - bWidth*2 - 10.0;
        y = 10 + bWidth*j;
      }
      else{
        x = width/2 - bWidth - 10.0;
        y = 10 + bWidth*j;
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
    int time = hour * 3600 + min * 100 + sec;
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
}