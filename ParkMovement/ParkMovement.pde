import java.util.Map;

Map<String, TimeStamp> friTimes = new HashMap<String, TimeStamp>();
Map<String, TimeStamp> satTimes = new HashMap<String, TimeStamp>();
Map<String, TimeStamp> sunTimes = new HashMap<String, TimeStamp>();
ArrayList<String> allTimeKeys = new ArrayList<String>();
float maxY;
float maxX;
int timeCount = 0;
PImage img;


void setup() {
  img = loadImage("map.PNG");
  size(1500, 1500);
  img.resize(width, height);
  background(img);
  frameRate(20);
  loadData();
  System.out.println("Finished");
}

void draw(){
  background(img);
  friTimes.get(allTimeKeys.get(timeCount)).drawActions(maxX,maxY);
  timeCount++;
}

void loadData(){
  String[] friString = loadStrings("park-movement-Fri-FIXED-2.0.csv");
  String[] satString = loadStrings("park-movement-Sat.csv");
  String[] sunString = loadStrings("park-movement-Sun.csv");
  
  for (int i = 1; i < friString.length; i++){
    String[] initialData = friString[i].split("\\s")[1].split(",");
    String currentTime = initialData[0];
    if(friTimes.containsKey(currentTime)){
      TimeStamp t = friTimes.get(currentTime);
      float[] coord = checkMaxDim(initialData[3], initialData[4]);
      t.addAction(new Action(initialData[1], coord[0], coord[1], initialData[2]));
      friTimes.put(initialData[0], t);
    }
    else{
      ArrayList<Action> action = new ArrayList<Action>();
      float[] coord = checkMaxDim(initialData[3], initialData[4]);
      action.add((new Action(initialData[1], coord[0], coord[1], initialData[2])));
      TimeStamp t = new TimeStamp("Friday", currentTime, action);
      friTimes.put(currentTime, t);
      allTimeKeys.add(currentTime);
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