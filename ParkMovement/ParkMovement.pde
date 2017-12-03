import java.util.Map;
//Parallel Coord Visualization

//Movement Visualization
HashMap<Integer, Person> IDtoPeople = new HashMap<Integer, Person>();
ArrayList<Hour> allHours = new ArrayList<Hour>();
HashMap<Position, Location> positionToLocations = new HashMap<Position, Location>();
TimeBox[] timeBoxes;
final float BOXWIDTH = 50;
int timeCount = 8*3600;
PImage img;

void setup() {
  img = loadImage("map.PNG");
  size(3000, 1500);
  img.resize(width/2, height);
  background(0);
  frameRate(100);
  loadData();
  println("Finished");
  fill(225);
  textAlign(LEFT, TOP);
  textSize(60);
  text("People Per Location Over Time", 30, 30);
  displayTimeOptions();
}

void draw(){
  displayMovement();
}

void displayMovement(){
  if(timeCount % 30 == 0){
    stroke(100);
    strokeWeight(2);
    fill(0);
    rect(width/2-10, 0, width/2+10, height);
    
    String timeClock = createClock();
    fill(225);
    textAlign(LEFT, TOP);
    textSize(40);
    text(timeClock, width/2+10, 20);
    for(HashMap.Entry<Integer, Person> entry: IDtoPeople.entrySet()){
      entry.getValue().display(timeCount);
    }
  }
  timeCount++;
  if(timeCount == 24*3600){
    timeCount = 8*3600;
  }
}

void displayTimeOptions(){
  strokeWeight(1.5);
  textSize(25);
  stroke(100);
  for(TimeBox tB: timeBoxes){
    float x = tB.getX();
    float y = tB.getY();
    fill(75);
    rect(x, y, BOXWIDTH, BOXWIDTH, 3);
    fill(255);
    textAlign(CENTER, CENTER);
    text(tB.getHour(), x + BOXWIDTH/2, y + BOXWIDTH/2);
  }
}

String createClock(){
  String hour = Integer.toString(timeCount / 3600);
  String minute = Integer.toString((timeCount % 3600)/60);
  String second = Integer.toString((timeCount % 3600)%60);
  String timeClock = "";
  if (hour.length() == 1){
    timeClock += "0" + hour + ":";
  }
  else{
    timeClock += hour + ":";
  }
  if (minute.length() == 1){
    timeClock += "0" + minute + ":";
  }
  else{
    timeClock += minute + ":";
  }
  if (second.length() == 1){
    timeClock += "0" + second;
  }
  else{
    timeClock += second;
  }
  return timeClock;
}

void loadData(){
  LoadDay friDay = new LoadDay(loadStrings("park-movement-Fri-FIXED-2.0.csv"), loadStrings("comnodes.csv"));
  friDay.createPeople(IDtoPeople, allHours, positionToLocations);
  timeBoxes = friDay.createBoxes();
  print("sogood");
}

void mouseClicked(){
  for(TimeBox tB: timeBoxes){
    float x = tB.getX();
    float y = tB.getY();
    if(mouseX >= x && mouseX <= x+BOXWIDTH && mouseY >= y && mouseY <= y+BOXWIDTH){
      timeCount = int(tB.getHour()) * 3600;
    }
  }
}