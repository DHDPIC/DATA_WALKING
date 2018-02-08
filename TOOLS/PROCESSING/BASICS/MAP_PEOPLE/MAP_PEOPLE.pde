// FOR NEW DATA SCHEMA

import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;

import de.fhpotsdam.unfolding.providers.Microsoft;

UnfoldingMap map;

int colPeople = 4; // count of people in a location

int colLat = 0;
int colLng = 1;

ArrayList<PeopleDataNode> peopleList;
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
  table = loadTable("merged-people.csv", "header");
  println(table.getRowCount());
  //
  peopleList = new ArrayList<PeopleDataNode>();
  locationList = new ArrayList<Location>();
  
  for(int r=0; r<table.getRowCount(); r++) {
    // get lat lng from table
    float lat = table.getFloat(r,colLat);
    float lon = table.getFloat(r,colLng);
    // create location
    Location l = new Location(lat,lon);
    // get number of people
    int v = table.getInt(r,colPeople);
    // check it is at least one person or more
    if(v>0) {
      // create new data object and add it and location to arraylist
      PeopleDataNode p = new PeopleDataNode( lat,lon,v );
      peopleList.add(p);
      locationList.add(l);
    }
    // error checking for rogue data!
    if(lat < 51.2) {
      println(r+"!!!");
      println(lat);
    }
  }
  // set init drawing styles
  fill(250,138,52);
  noStroke();
  // set map to london
  map.zoomAndPanTo(10, new Location(51.5f, -0.118f));
}

void draw() {
  blendMode(BLEND);
  background(0);
  // display map
  map.draw();
  
  blendMode(ADD);
  // PLOT A ROUTE
  /*
  for (int i=1; i<locs.length; i+=1) {
    ScreenPosition pos1 = map.getScreenPosition(locs[i-1]);
    ScreenPosition pos2 = map.getScreenPosition(locs[i]);
    stroke(255,0,0);
    line(pos1.x, pos1.y, pos2.x, pos2.y);
  }
  */
  
  // PLOT PEOPLE
  for (int i=0; i<peopleList.size(); i+=1) {
    ScreenPosition pos1 = map.getScreenPosition(locationList.get(i));
    PeopleDataNode p = peopleList.get(i);
    float v = norm(p.people, 0, 20);
    float d = 2*sqrt(v/PI);
    fill(52,250,138,51);
    noStroke();
    ellipse(pos1.x, pos1.y, d*50, d*50);
  }
  
  // render to tiff
  if(render) {
    render = false;
    saveFrame("fr-####.tiff");
  }
}

void keyPressed() {
  if(key=='r' || key=='R') {
    render = true;
  }
}

// class to hold people count data

class PeopleDataNode {
  
  float lat;
  float lng;
  int people;
  
  PeopleDataNode(float lat_, float lng_, int p) {
    lat = lat_;
    lng = lng_;
    people = p;
  }
}

