// FOR NEW DATA SCHEMA

import processing.pdf.*;

import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;

import de.fhpotsdam.unfolding.providers.Microsoft;

UnfoldingMap map;

int colPeople = 4; // count of people in a location

int colLat = 0;
int colLng = 1;

ArrayList<Location> locationList;

Table table;

Boolean render = false;

void setup() {
  //
  size(1280,900,OPENGL);
  //
  map = new UnfoldingMap(this, new Microsoft.AerialProvider());
  map.setTweening(true);
  MapUtils.createDefaultEventDispatcher(this, map);
  //
  table = loadTable("merged-environment.csv", "header");
  println(table.getRowCount());
  //
  locationList = new ArrayList<Location>();
  
  for(int r=0; r<table.getRowCount(); r++) {
    // get lat lng from table
    float lat = table.getFloat(r,colLat);
    float lon = table.getFloat(r,colLng);
    // create location
    Location l = new Location(lat,lon);
    // get number of people
    //int v = table.getInt(r,colPeople);
    // check it is at least one person or more
    String d = table.getString(r,3);
    String s[] = splitTokens(d,"/");
    
    // select month to render
    if(s[1].equals("12")) {
      // create new data object and add it and location to arraylist
      locationList.add(l);
    }
    // error checking for rogue data!
    if(lat < 51.2) {
      println(r+"!!!");
      println(lat);
    }
  }
  // set map to london
  map.zoomAndPanTo(10, new Location(51.5f, -0.118f));
}

void draw() {
  background(0);
  // display map
  map.draw();
  
  // render to tiff
  if(render) {
    saveFrame("fr-####.tiff");
  }
  
  // render pdf
  if(render) {
    beginRecord(PDF, "output.pdf");
  }
  
  // PLOT A ROUTE
  for (int i=1; i<locationList.size(); i+=1) {
    ScreenPosition pos1 = map.getScreenPosition(locationList.get(i-1));
    ScreenPosition pos2 = map.getScreenPosition(locationList.get(i));
    stroke(255,0,0);
    line(pos1.x, pos1.y, pos2.x, pos2.y);
  }
  
  // end pdf render
  if(render) {
    endRecord();
    render = false;
  }
}

void keyPressed() {
  if(key=='r' || key=='R') {
    render = true;
  }
}


