import java.util.Map;
//Parallel Coord Visualization
ArrayList<Hour> allHours = new ArrayList<Hour>();
HashMap<Position, Location> positionToLocations = new HashMap<Position, Location>();

final float HIGH = 1200; //bottom of bar
final float LOW = 300; //top of bar
final float WIDTHPAD = 100;
final int BARWIDTH = 8;
float barSpace;
int BARCOUNT;
boolean locHighlighting = false;
boolean barHighlighting = false;
int barHighlighted = -1;
int clickCount = 0;
int[] clicked = {0, 0};
  int popMax = 0;


boolean moved = false; //if toggle is being moved is true
int filterBarMoved = 0; //the category who's filter bar is being moved
final float FILTERBARHALFWIDTH = 10;
final float FILTERBARLENGTH = 8;

//Movement Visualization
HashMap<Integer, Person> IDtoPeople = new HashMap<Integer, Person>();
TimeBox[] timeBoxes;
final float BOXWIDTH = 50;
int timeCount = 8*3600;
PImage img;

void setup() {
  //img = loadImage("map.PNG");
  size(3000, 1500);
  //img.resize(width/2, height);
  background(0);
  frameRate(100);
  loadData();
  println("Data Loaded");
  
  barSpace = (width/2-2*WIDTHPAD)/(BARCOUNT - 1);
  //Designates the positions of each bar
  for(int i = 0; i < BARCOUNT; i++){
    float xPos = i*barSpace+WIDTHPAD;
    allHours.get(i).setX(xPos);
  }
  
  fill(225);
  textAlign(LEFT, TOP);
  textSize(60);
  text("Location Distribution Over Time", 30, 30);
  displayTimeOptions();
  displayParallelCoords();
}





void draw(){
  displayMovement();
  displayParallelCoords();
}

void displayParallelCoords(){
  stroke(0);
  fill(0);
  rect(0, LOW-50, width/2-50, height);
  strokeWeight(2);
  
  //Draw individual lines between columns
  for (int i = 0; i < BARCOUNT-1; i++){
    Hour h = allHours.get(i);
    for (Location l: positionToLocations.values()){
      if(!l.isFiltered){
        float oppacity = 255.0;
        //Checks if a location is being highlighted
        if(locHighlighting && !l.isChosen){
          oppacity = 50.0;
        }
        stroke(l.clr, oppacity);
        float lY = HIGH;
        if(l.hourToYCoord.get(h.hour)!=null){
          lY = l.hourToYCoord.get(h.hour);
        }

        Hour h2 = allHours.get(i+1);
        float lY2 = HIGH;
        if(l.hourToNumPeople.get(h2.hour)!=null){
          lY2 = l.hourToYCoord.get(h2.hour);
        }
        line(h.xCoord+BARWIDTH/2, lY,  h2.xCoord+BARWIDTH/2, lY2);
      }
    }
  }
  stroke(255);
  fill(255);
  
  //Checks if a bar is being moved and checks where it should be drawn
  if(moved){
    allHours.get(filterBarMoved).setFilter(mouseY, 0.5*FILTERBARLENGTH);
  }
  
  //Draw the hour columns
  for(Hour h: allHours){
    float x = h.xCoord;
    textSize(16);
    textAlign(CENTER,BOTTOM);
    fill(255);
    text(h.hour, x+BARWIDTH/2, LOW - 25);
    //Draw Labels
    textSize(12);
    textAlign(RIGHT,BOTTOM);
    
    float lenSec = (HIGH - LOW)/10;
    for(int i = 0; i <= 10; i++){
      if(h.xCoord!=100){
        text(" -", h.xCoord, int((10-i)*lenSec + LOW)+7);
      }
      else{
        text(Integer.toString(int((float)i*popMax/10))+" -", h.xCoord, int((10-i)*lenSec + LOW)+7);
      }
    }
    
    
    fill(h.clr);
    rect(x, LOW, BARWIDTH, HIGH-LOW);
    //Create the boxes that show to where the bars are being filtered
    rect(x + 0.5*BARWIDTH - FILTERBARHALFWIDTH, h.filterUpper-FILTERBARLENGTH, 2* FILTERBARHALFWIDTH , FILTERBARLENGTH);
    rect(x + 0.5*BARWIDTH - FILTERBARHALFWIDTH, h.filterLower, 2* FILTERBARHALFWIDTH , FILTERBARLENGTH);
  }
}

void displayMovement(){
  if(timeCount % 10 == 0){
    stroke(100);
    strokeWeight(2);
    fill(0);
    rect(width/2-10, 0, width/2+10, height);
    for (Location l: positionToLocations.values()){
      l.displayPosition();
    }
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
  BARCOUNT = allHours.size();
   popMax = friDay.getPopMax();
   println(popMax);
}

 

//Parallel Coords Methods

//To filter the data with toggles on the bars
void mouseDragged(){
  if(!moved){
    for (int i = 0; i < BARCOUNT; i++){
      Hour h = allHours.get(i);
      if (mouseX >= h.xCoord+0.5*BARWIDTH -FILTERBARHALFWIDTH && mouseX <= h.xCoord+0.5*BARWIDTH + FILTERBARHALFWIDTH&&
          mouseY >= h.filterUpper-FILTERBARLENGTH && mouseY <= h.filterUpper){
        h.setIsUpper(true);
        filterBarMoved = i;
        moved = true;
        break;
      }
      else if (mouseX >= h.xCoord+0.5*BARWIDTH -FILTERBARHALFWIDTH && mouseX <= h.xCoord+0.5*BARWIDTH + FILTERBARHALFWIDTH&&
                mouseY <= h.filterLower+FILTERBARLENGTH && mouseY >=h.filterLower){
        h.setIsUpper(false);
        filterBarMoved = i;
        moved = true;
        break;
      }
    }
  }
  
  if (moved){
    Hour h = allHours.get(filterBarMoved);
    for (Location l: positionToLocations.values()){
      float lY = HIGH;
      if(l.hourToYCoord.get(h.hour)!=null){
        lY = l.hourToYCoord.get(h.hour);
      }
      if (lY >= h.filterUpper && lY <= h.filterLower){
        l.setFiltered(false);
      }
      else{
        l.setFiltered(true);
      }
    }
  }
}

void mouseReleased(){
  moved = false;
}

void mouseClicked(){
  for(TimeBox tB: timeBoxes){
    float x = tB.getX();
    float y = tB.getY();
    if(mouseX >= x && mouseX <= x+BOXWIDTH && mouseY >= y && mouseY <= y+BOXWIDTH){
      timeCount = int(tB.getHour()) * 3600;
    }
  }
  
  for(int i = 0; i < BARCOUNT; i++){
    //Use 2 as a area for easier selection
    Hour h = allHours.get(i);
    if(mouseX >= h.xCoord && mouseX <= h.xCoord + BARWIDTH+2 && mouseY >= LOW && mouseY <= HIGH){
      if(clickCount == 0){
        h.setColor(color(255));
        clicked[0] = i;
      }
      else{
        clicked[1] = i;
      }
      clickCount ++;
    }
  }
  
  if(clickCount == 2){
    allHours.get(clicked[0]).setColor(175);
    swapColumn();
    clickCount = 0;
  }
}

void mouseMoved(){
  //Checks to see if a location is being hovered over
  if(mouseX > width/2){
    for(Location l: positionToLocations.values()){
      //Use 2 as a area for easier selection
      if(mouseX >= l.boxX && mouseX <= l.boxX+l.boxSize && mouseY >= l.boxY && mouseY <= l.boxY+l.boxSize){
        locHighlighting = true;
        l.setChosen(true);
        break;
      }
      else{
        locHighlighting = false;
        l.setChosen(false);
      }
    }
  }
}

//Swaps two columns after they've been selected
void swapColumn(){
  float x0 = allHours.get(clicked[0]).xCoord;
  float x1 = allHours.get(clicked[1]).xCoord;
  allHours.get(clicked[1]).setX(x0);
  allHours.get(clicked[0]).setX(x1);
  Hour swap = allHours.get(clicked[0]);
  allHours.set(clicked[0], allHours.get(clicked[1]));
  allHours.set(clicked[1], swap);
}