import java.util.Map;
import java.util.Iterator;
//Parallel Coord Visualization
ArrayList<Hour> allHours = new ArrayList<Hour>();
HashMap<Position, Location> positionToLocations = new HashMap<Position, Location>();
ArrayList<HashMap<Integer, Location>> hourtoLocation = new ArrayList<HashMap<Integer,Location>>();
final float HIGH = 1225; //bottom of bar
final float LOW = 325; //top of bar
final float WIDTHPAD = 100;
final int BARWIDTH = 8;
float barSpace;
int BARCOUNT;
boolean locHighlighting = false;
boolean barHighlighting = false;
int barHighlighted = -1;
int popMax = 0;
float FRAME_RATE = 40;
//Location selectedLocation;

LoadDay friDay;
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
  friDay  = new LoadDay(loadStrings("park-movement-Fri-FIXED-2.0.csv"), loadStrings("locNumtoLocation.csv"));
  loadData();
  img = loadImage("map.PNG");
  
  for(int i=0; i < allHours.size(); i++){
    HashMap<Integer, Location> hourMap = new HashMap<Integer, Location>();
    hourtoLocation.add(hourMap);
  }
  
  for(Location l: positionToLocations.values()){
    for(HashMap.Entry<Integer, Float> entry: l.hourToYCoord.entrySet()){
      hourtoLocation.get(entry.getKey()-8).put(Math.round(entry.getValue()), l);
    }
      
  
  
  }  
  size(2700, 1350, P3D);
  //img.resize(width/2, height);
  background(0);
  frameRate(FRAME_RATE);
  
  println("Data Loaded");
  
  barSpace = (width/2-2*WIDTHPAD)/(BARCOUNT - 1);
  //Designates the positions of each bar
  for(int i = 0; i < BARCOUNT; i++){
    float xPos = i*barSpace+WIDTHPAD;
    allHours.get(i).setX(xPos);
  }
  
  fill(225);
  textAlign(LEFT, TOP);
  textSize(55);
  text("Visitor Distribution Over Time", 30, 80);
   textSize(30);
   textAlign(LEFT, BOTTOM);
  text("     Visitors \n per Location", 5,LOW-20);
  displayTimeOptions();
  displayTimeController();
  displayParallelCoords();
}

void draw(){
  tint(255, 100); 
  displayMovement();
  displayParallelCoords();
}

void displayParallelCoords(){
   stroke(0);
  fill(0);
  rect(0, LOW-20, width/2-50, height);
  fill(255);
  
  textAlign(CENTER, TOP);
  textSize(30);
  text("Hour", 0.25*width,1280 );
 
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
    textSize(20);
    textAlign(CENTER,TOP);
    fill(255);
    text(h.hour, x+BARWIDTH/2, HIGH+10);
    //Draw Labels
    textSize(18);
    
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
  if(timeCount % 1 == 0){
    stroke(100);
    strokeWeight(2);
    fill(0);
    beginShape();
      texture(img);
      vertex(width/2-8, 0, 0, 0);
      vertex(width+15,0, 658, 0);
      vertex(width+15, height+5, 658,654);
      vertex(width/2-8, height+5, 0,654);
    endShape();
   // rect(width/2-10, 0, width/2+10, height);
 
   
    for (Location l: positionToLocations.values()){
      
      l.displayPosition(timeCount/3600, friDay.hourToMaxPop.get(timeCount/3600));
    }
    String timeClock = createClock();
    fill(0);
    textAlign(LEFT, TOP);
    textSize(40);
    text(timeClock, width/2+10, 20);
    for(HashMap.Entry<Integer, Person> entry: IDtoPeople.entrySet()){
      entry.getValue().display(timeCount);
    }
  }
  timeCount++;
  if(timeCount == 24*3600-1){
    timeCount = 8*3600;
  }
}

void displayTimeOptions(){
  textSize(25);
  textAlign(LEFT, BOTTOM);
  fill(255);
  text("Skip to Hour", width/2 - (10+BOXWIDTH) * 8 - 10.0,140);
  //draw boxes;
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

void displayTimeController(){
  textSize(25);
  textAlign(LEFT, BOTTOM);
  fill(255);
  text("Speed Adjustment", width/2 - (10+BOXWIDTH) * 8 - 10.0,140-2*BOXWIDTH);
   
    //faster!!!!!!!!
    
    fill(75);
    rect(width/2 - (10+BOXWIDTH) * 8 - 10.0, 140 - 1.7*BOXWIDTH , BOXWIDTH, BOXWIDTH, 3);
    fill(255);
    triangle(width/2 - (10+BOXWIDTH) * 8 - 2.0,140 - 1.7*BOXWIDTH +8.0 ,width/2 - (10+BOXWIDTH) * 8 - 2.0, 140 - 1.7*BOXWIDTH+BOXWIDTH-8, width/2 - (10+BOXWIDTH) * 8 - 10.0+ 0.5*BOXWIDTH ,140 - 1.2*BOXWIDTH);
    triangle(width/2 - (10+BOXWIDTH) * 8 - 10.0+0.5* BOXWIDTH ,140 - 1.7*BOXWIDTH +8.0 ,width/2 - (10+BOXWIDTH) * 8 - 10.0+ 0.5*BOXWIDTH, 140 - 1.7*BOXWIDTH+BOXWIDTH-8, width/2 - (10+BOXWIDTH) * 8 + BOXWIDTH -18,140 - 1.2*BOXWIDTH);
    
    //slower!!!!!!
    fill(75);
     rect(width/2 - (10+BOXWIDTH) * 6 - 10.0, 140 - 1.7*BOXWIDTH , BOXWIDTH, BOXWIDTH, 3);
       fill(255);
    triangle(width/2 - (10+BOXWIDTH) * 6 - 10.0+0.5* BOXWIDTH ,140 - 1.7*BOXWIDTH +8.0 ,width/2 - (10+BOXWIDTH) * 6 - 10.0+ 0.5*BOXWIDTH, 140 - 1.7*BOXWIDTH+BOXWIDTH-8, width/2 - (10+BOXWIDTH) * 6 + BOXWIDTH -18,140 - 1.2*BOXWIDTH);
    rect(width/2 - (10+BOXWIDTH) * 6 + 2,140 - 1.7*BOXWIDTH +8.0 ,5, BOXWIDTH-16);
    
    //reset!!!!!
     fill(75);
     rect(width/2 - (10+BOXWIDTH) * 4 - 10.0, 140 -1.7* BOXWIDTH , BOXWIDTH, BOXWIDTH, 3);     
    stroke(255);
    strokeWeight(5);
     arc(width/2 - (10+BOXWIDTH) * 4 - 10.0 + 0.5* BOXWIDTH, 140 -1.2* BOXWIDTH, BOXWIDTH -16, BOXWIDTH -16, QUARTER_PI,2*PI , OPEN);
     fill(255);
     strokeWeight(1);
     triangle(width/2 - (10+BOXWIDTH) * 4 - 10.0 +BOXWIDTH - 14,140 -1.2* BOXWIDTH,width/2 - (10+BOXWIDTH) * 4 - 10.0 +BOXWIDTH - 2, 140 -1.2* BOXWIDTH ,  width/2 - (10+BOXWIDTH) * 4 - 10.0 +BOXWIDTH - 8 , 140 -1.2* BOXWIDTH +8);
     
     
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
  
  friDay.createPeople(IDtoPeople, allHours, positionToLocations);
  timeBoxes = friDay.createBoxes();
  BARCOUNT = allHours.size();
   popMax = friDay.getPopMax();

  
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
  if ( mouseY >=140 - 1.7*BOXWIDTH &&   mouseY <=140 - 0.7*BOXWIDTH ){
    if(mouseX>=width/2 - (10+BOXWIDTH) * 8 - 10.0 &&mouseX<=width/2 - (10+BOXWIDTH) * 8 - 10.0 + BOXWIDTH ){
      frameRate(1.2*frameRate );
    }
    else if(mouseX >=width/2 - (10+BOXWIDTH) * 6 - 10.0 &&mouseX <=width/2 - (10+BOXWIDTH) * 6 - 10.0 + BOXWIDTH){
      frameRate(0.8*frameRate);
    }
    else if(mouseX >=width/2 - (10+BOXWIDTH) * 4 - 10.0 && mouseX <= width/2 - (10+BOXWIDTH) * 4 - 10.0 + BOXWIDTH ){
      frameRate(FRAME_RATE);
    }
    println(frameRate);
  }
}

ArrayList<Location> locationChosen = new ArrayList<Location>();
void mouseMoved(){
  if (!locationChosen.isEmpty()){
    ArrayList<Integer> indexToRemove = new ArrayList<Integer>();
    for(int j = 0 ; j < locationChosen.size(); j++){
      boolean stillChecked = false;
     for(int i = 0; i < BARCOUNT; i++){
        Hour h = allHours.get(i);
        if((mouseX >= h.xCoord && mouseX <= h.xCoord + BARWIDTH+2) && ((hourtoLocation.get(i).containsKey(Math.round(mouseY)) )|| hourtoLocation.get(i).containsKey(Math.round(mouseY)+1)||hourtoLocation.get(i).containsKey(Math.round(mouseY)-1))){
          stillChecked = true;
        }
        else{
        }
      }
      if(!stillChecked){
        indexToRemove.add(j);
      }
   }
   for (int i = indexToRemove.size()-1 ; i >=0 ; i --){
       locationChosen.get(i).setChosen(false);
       locationChosen.remove(i);
     }
  }
  boolean lineChecked = false;
  //Checks to see if a location is being hovered over
  if(mouseX > width/2){
    for(Location l: positionToLocations.values()){
      //Use 2 as a area for easier selection
      if(mouseX >= l.boxX && mouseX <= l.boxX+l.boxSize && mouseY >= l.boxY && mouseY <= l.boxY+l.boxSize){
        locHighlighting = true;
        lineChecked = true;
        l.setChosen(true);
        break;
      }
      else{
        locHighlighting = false;
        l.setChosen(false);
      }
    }
  }
  
   for(int i = 0; i < BARCOUNT; i++){
    //Use 2 as a area for easier selection
    Hour h = allHours.get(i);
    if(mouseX >= h.xCoord && mouseX <= h.xCoord + BARWIDTH+2 && mouseY >= LOW && mouseY <= HIGH){
      if(hourtoLocation.get(i).containsKey(Math.round(mouseY))){
        Location selectedLocation = hourtoLocation.get(i).get(Math.round(mouseY));
        selectedLocation.setChosen(true);
        locHighlighting = true;
        locationChosen.add(selectedLocation);
        lineChecked = true;
      }
      if(hourtoLocation.get(i).containsKey(Math.round(mouseY)+1)){
        Location selectedLocation = hourtoLocation.get(i).get(Math.round(mouseY)+1);
        selectedLocation.setChosen(true);
        locHighlighting = true;
         locationChosen.add(selectedLocation);
        lineChecked = true;
      }
      if(hourtoLocation.get(i).containsKey(Math.round(mouseY)-1)){
        Location selectedLocation = hourtoLocation.get(i).get(Math.round(mouseY)-1);
        selectedLocation.setChosen(true);
        locHighlighting = true;
        locationChosen.add(selectedLocation);
        lineChecked = true; 
      }
     }
    if (lineChecked){break;}
  }
  if(!lineChecked){
    locHighlighting = false;
  }
}