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

ArrayList<PeopleDataNode> peopleList;
Table table;

Boolean render = false;

void setup() {
  size(1280, 900, OPENGL);
  // setup map
  map = new UnfoldingMap(this, new Microsoft.AerialProvider());
  map.setTweening(true);
  MapUtils.createDefaultEventDispatcher(this, map);
  // load data
  table = loadTable("merged-people.csv", "header");
  println(table.getRowCount());
  //
  peopleList = new ArrayList<PeopleDataNode>();

  for (int r=0; r<table.getRowCount (); r++) {
    // get lat lng from table
    float lat = table.getFloat(r, colLat);
    float lon = table.getFloat(r, colLng);
    // create location
    Location l = new Location(lat, lon);
    // get number of people
    int v = table.getInt(r, "number people");
    // check it is at least one person or more
    if (v>0) {
      // create new data object and add it and to arraylist
      PeopleDataNode p = new PeopleDataNode( lat, lon, v );
      peopleList.add(p);
    }
    // error checking for rogue data!
    if (lat < 51.2) {
      println(r+"!!!");
      println(lat);
    }
  }
  // set init drawing styles
  fill(250, 138, 52);
  noStroke();
  // set map to london
  map.zoomAndPanTo(10, new Location(51.5f, -0.118f));
}

void draw() {
  if (render) {
    saveFrame("fr-####.tiff"); // render to tiff for reference
  }

  background(0);
  map.draw(); // display map

  if (render) {
    map.draw();
    filter(GRAY); // make map greyscale for engraving on laser cutter
    save("bw-map.tiff"); // save greyscale map
    beginRecord(PDF, "output.pdf"); // create pdf to record circles to
  }

  // PLOT PEOPLE
  for (int i=0; i<peopleList.size (); i+=1) {
    PeopleDataNode p = peopleList.get(i);
    Location l = new Location(p.lat,p.lng);
    ScreenPosition pos1 = map.getScreenPosition(l);//map.getScreenPosition(locationList.get(i));
    
    float v = norm(p.people, 0, 20);
    float d = p.people*4;// 2*sqrt(v/PI);
    if (!render) {
      fill(52, 250, 138, 255);
      noStroke();
    } else {
      fill(255);
      stroke(255, 0, 0); // rgb red for cut stroke on laser cutter
      strokeWeight(0.001); // cut stroke size is 0.001pt on laser cutter
    }
    ellipse(pos1.x, pos1.y, d, d);
  }
  // end recording to pdf
  if (render) {
    endRecord();
    render = false;
  }
}

void keyPressed() {
  if (key=='r' || key=='R') {
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

