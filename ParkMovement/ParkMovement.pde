void setup() { 
  size(200, 200);
  // Load text file as a String
  String[] friString = loadStrings("data.csv");
  String[] satString = loadStrings("data.csv");
  String[] sunString = loadStrings("data.csv");
  DataDict friData = new DataDict(friString);
  DataDict satData = new DataDict(satString);
  DataDict sunData = new DataDict(sunString);
  // Convert string into an array of integers using ',' as a delimiter
  //data = int(split(stuff[0], ','));
}