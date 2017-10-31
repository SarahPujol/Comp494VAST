import java.util.Map;

Map<Integer, TimeStamp> friTimes = new HashMap<Integer, TimeStamp>();
Map<String, TimeStamp> satTimes = new HashMap<String, TimeStamp>();
Map<String, TimeStamp> sunTimes = new HashMap<String, TimeStamp>();
//ArrayList<String> allTimeKeys = new ArrayList<String>();
float maxY;
float maxX;
int timeCount = 0;
PImage img;
int timeStay = 0;


void setup() {
  img = loadImage("map.PNG");
  size(1500, 1500);
  img.resize(width, height);
  background(0);
  frameRate(20);
  loadData();
  System.out.println("Finished");
}

void draw(){
  background(0);
  fill(0, 102, 153);
  textSize(40);
  text(timeCount, 10,30);
  if (friTimes.containsKey(timeCount)){
    friTimes.get(timeCount).drawActions(maxX,maxY);
    timeStay = timeCount;
  }
  else{
    if(friTimes.containsKey(timeStay)){
      friTimes.get(timeStay).drawActions(maxX,maxY);
    }
  }
  timeCount++;
}

void loadData(){
  String[] friString = loadStrings("park-movement-Fri-FIXED-2.0.csv");
 // String[] satString = loadStrings("park-movement-Sat.csv");
 // String[] sunString = loadStrings("park-movement-Sun.csv");
  
  for (int i = 1; i < friString.length; i++){
    String[] initialData = friString[i].split("\\s")[1].split(",");
    String currentTime = initialData[0];
    String[] times = currentTime.split(":");
    int tsec =  (Integer.parseInt(times[0])-8)*3600+Integer.parseInt(times[1])*60 + Integer.parseInt(times[2]);
   
    if(friTimes.containsKey(tsec)){
      TimeStamp t = friTimes.get(tsec);
      float[] coord = checkMaxDim(initialData[3], initialData[4]);
      t.addAction(new Action(initialData[1], coord[0], coord[1], initialData[2]));
      friTimes.put(tsec, t);
    }
    else{
      ArrayList<Action> action = new ArrayList<Action>();
      float[] coord = checkMaxDim(initialData[3], initialData[4]);
      action.add((new Action(initialData[1], coord[0], coord[1], initialData[2])));
      TimeStamp t = new TimeStamp("Friday", currentTime, action);
      friTimes.put(tsec, t);
    //  allTimeKeys.add(currentTime);
    }
  }
}

float[] checkMaxDim(String x, String y){
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