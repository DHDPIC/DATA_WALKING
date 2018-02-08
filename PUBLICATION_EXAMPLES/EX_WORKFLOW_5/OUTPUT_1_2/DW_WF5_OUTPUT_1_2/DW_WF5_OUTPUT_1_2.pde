// FOR NEW DATA SCHEMA

import processing.pdf.*;

import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;

import de.fhpotsdam.unfolding.providers.Microsoft;

UnfoldingMap map;


int colLat = 3;
int colLng = 4;

Table table;

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
  table = loadTable("data.csv", "header");
  println(table.getRowCount());
  // get locations for light & temperature data
  locs = new Location[table.getRowCount()];

  for (int r=0; r<table.getRowCount (); r++) {
    // get lat lng from table
    float lat = table.getFloat(r, colLat);
    float lon = table.getFloat(r, colLng);
    // create location
    Location l = new Location(lat, lon);
    // assign location to array for retrieving light/temperature
    locs[r] = l;
  }
  // set init drawing styles
  stroke(250, 138, 52);
  strokeWeight(3);
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
    //filter(GRAY); // make map greyscale for engraving on laser cutter
    save("bw-map.tiff"); // save greyscale map
    beginRecord(PDF, "photo-locations.pdf"); // create pdf to record circles to
    stroke(250, 138, 52);
    strokeWeight(3);
  }

  // PLOT PHOTOS
  int inc = 1;
  for (int i=0; i<locs.length; i+=inc) {
    ScreenPosition pos1 = map.getScreenPosition(locs[i]);
    line(pos1.x-4, pos1.y-4, pos1.x+4, pos1.y+4);
    line(pos1.x+4, pos1.y-4, pos1.x-4, pos1.y+4);
  }
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

