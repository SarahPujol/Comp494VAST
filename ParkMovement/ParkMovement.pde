import java.util.Arrays;
ArrayList<TimeStamp> friTimes = new ArrayList<TimeStamp>();
ArrayList<TimeStamp> satTimes = new ArrayList<TimeStamp>();
ArrayList<TimeStamp> sunTimes = new ArrayList<TimeStamp>();

void setup() { 
  size(200, 200);
  // Load text file as a String
  String[] friString = loadStrings("park-movement-Fri-FIXED-2.0.csv");
  String[] satString = loadStrings("park-movement-Sat.csv");
  String[] sunString = loadStrings("park-movement-Sun.csv");
  
  for (int i = 0; i < friString.length; i++){
    System.out.println(friString[i]);
  }
  
  // Convert string into an array of integers using ',' as a delimiter
  //data = int(split(stuff[0], ','));
}