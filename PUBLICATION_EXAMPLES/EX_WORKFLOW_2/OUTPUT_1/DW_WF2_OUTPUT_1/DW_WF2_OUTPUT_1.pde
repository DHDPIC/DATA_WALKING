// FOR NEW DATA SCHEMA

import processing.pdf.*;

import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;

import de.fhpotsdam.unfolding.providers.Microsoft;

UnfoldingMap map;

int colPeople = 6; // count of people in a location
int colTemp = 5;
int colLight = 4;
int colLat = 0;
int colLng = 1;

Table table;

ArrayList<PeopleDataNode> peopleList;
Location[] locs;

Boolean saver = false;

color c1 = color(39, 109, 255);
color c2 = color(255, 109, 39);
color c3 = color(255, 255, 204);

void setup() {
  size(1280, 900, OPENGL);
  // setup map
  map = new UnfoldingMap(this, new Microsoft.AerialProvider());
  map.setTweening(true);
  MapUtils.createDefaultEventDispatcher(this, map);
  // load data
  table = loadTable("GPSLOG02.csv", "header");
  println(table.getRowCount());
  // get locations for light & temperature data
  locs = new Location[table.getRowCount()];
  // get people
  peopleList = new ArrayList<PeopleDataNode>();

  for (int r=0; r<table.getRowCount (); r++) {
    // get lat lng from table
    float lat = table.getFloat(r, colLat);
    float lon = table.getFloat(r, colLng);
    // create location
    Location l = new Location(lat, lon);
    // assign location to array for retrieving light/temperature
    locs[r] = l;
    // get number of people
    int v = table.getInt(r, "people");
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
  if (saver) {
    saveFrame("fr-####.tiff"); // render to tiff for reference
  }

  background(0);
  map.draw(); // display map

  if (saver) {
    map.draw();
    filter(GRAY); // make map greyscale for engraving on laser cutter
    save("bw-map.tiff"); // save greyscale map
    beginRecord(PDF, "light.pdf"); // create pdf to record circles to
  }

  // PLOT LIGHT
  // lines of varying darkness
  strokeWeight(5);
  int inc = 100;
  for (int i=inc; i<locs.length; i+=inc) {
    ScreenPosition pos1 = map.getScreenPosition(locs[i-inc]);
    ScreenPosition pos2 = map.getScreenPosition(locs[i]);
    float l = table.getFloat(i-inc, colLight);
    float v = map(l, 20, 30, 255, 0);
    stroke(v);
    line(pos1.x, pos1.y, pos2.x, pos2.y);
  }
  if (saver) {
    endRecord();
    beginRecord(PDF, "temperature.pdf");
  }
  // PLOT TEMPERATURE
  // ellipsis with divergent gradient
  noStroke();
  for (int i=0; i<locs.length; i+=1) {
    ScreenPosition pos1 = map.getScreenPosition(locs[i]);
    color c;
    float t = table.getFloat(i, colTemp);
    float v = norm(t, 0, 40);
    if (v<=0.5) {
      v = norm(v, 0, 0.5);
      c = lerpColor(c1, c3, v);
    } else {
      v = norm(v, 0.5, 1);
      c = lerpColor(c3, c2, v);
    }
    fill(c);
    ellipse(pos1.x, pos1.y, 8, 8);
  }
  if (saver) {
    endRecord();
    beginRecord(PDF, "people.pdf");
  }
  // PLOT PEOPLE
  noStroke();
  for (int i=0; i<peopleList.size (); i+=1) {
    PeopleDataNode p = peopleList.get(i);
    Location l = new Location(p.lat, p.lng);
    ScreenPosition pos1 = map.getScreenPosition(l);//map.getScreenPosition(locationList.get(i));

    float v = norm(p.people, 0, 20); // normalise to data range
    float d = 2*sqrt(v/PI); // calculate diameter for value as area
    d = d*20; // multiply so maximum value in range 0-20 equates to 20px ellipse
    fill(52, 250, 138, 255);
    ellipse(pos1.x, pos1.y, d, d);
  }
  // end recording to pdf
  if (saver) {
    endRecord();
    saver = false;
  }
}

void keyPressed() {
  if (key=='s' || key=='S') {
    saver = true;
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

