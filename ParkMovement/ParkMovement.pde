import java.util.Map;

Map<String, TimeStamp> friTimes = new HashMap<String, TimeStamp>();
Map<String, TimeStamp> satTimes = new HashMap<String, TimeStamp>();
Map<String, TimeStamp> sunTimes = new HashMap<String, TimeStamp>();

void setup() { 
  size(200, 200);
  // Load text file as a String
  String[] friString = loadStrings("park-movement-Fri-FIXED-2.0.csv");
  String[] satString = loadStrings("park-movement-Sat.csv");
  String[] sunString = loadStrings("park-movement-Sun.csv");
  
  ArrayList<Action> actions = new ArrayList<Action>();
  String currentTime = friString[0].split("\\s*")[1].split(",")[0];
  for (int i = 0; i < friString.length; i++){
    String[] initialData = friString[i].split("\\s*")[1].split(",");
    if(initialData[0].equals(currentTime)){
      actions.add(new Action(initialData[1], initialData[3], initialData[4], initialData[2]));
    }
    else{
      TimeStamp t = new TimeStamp("Friday", currentTime, actions);
      friTimes.put(currentTime, t);
      actions.clear();
      currentTime = initialData[0];
      actions.add(new Action(initialData[1], initialData[3], initialData[4], initialData[2]));
    }
  }
  
  for(Map.Entry<String, TimeStamp> entry : friTimes.entrySet()){
      System.out.println(entry.getKey() + "/" + entry.getValue().toString());
  }

  
  // Convert string into an array of integers using ',' as a delimiter
  //data = int(split(stuff[0], ','));
}