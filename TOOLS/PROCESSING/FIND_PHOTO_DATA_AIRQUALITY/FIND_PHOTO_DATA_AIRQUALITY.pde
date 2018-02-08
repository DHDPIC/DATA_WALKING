// FOR NEW DATA SCHEMA

import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;

import de.fhpotsdam.unfolding.providers.Microsoft;

UnfoldingMap map;

int colLight = 4; // val hi = 0; lo = 1024

int colLat = 0;
int colLng = 1;

FloatList lats;
FloatList lons;

Location[] locs;

Table table;

Boolean render = false;

//
//

float photoLat =  51.5000333333333;
float photoLng = 0.00540833333333333;
Location photoLoc;
Location minLoc;
int id = 0; // store id 

Boolean findClosest = false;

void setup() {
  //
  size(1280, 900, OPENGL);
  //
  map = new UnfoldingMap(this, new Microsoft.AerialProvider());
  map.setTweening(true);
  MapUtils.createDefaultEventDispatcher(this, map);
  //
  photoLoc = new Location(photoLat, photoLng);
  minLoc = new Location(photoLat, photoLng);
  //
  lats = new FloatList();
  lons = new FloatList();
  //
  table = loadTable("20160825-gas-sensors.csv", "header");
  println(table.getRowCount());
  locs = new Location[table.getRowCount()];
  for (int r=0; r<table.getRowCount (); r++) {
    float lat = table.getFloat(r, colLat);
    float lon = table.getFloat(r, colLng);
    //println(lon);
    lats.append(lat);
    lons.append(lon);
    Location l = new Location(lat, lon);
    locs[r] = l;
  }
  //
  fill(255, 51, 255);
  noStroke();
  // set map to london
  map.zoomAndPanTo(10, new Location(51.5f, -0.118f));
}

void draw() {
  background(0);
  map.draw();
  ScreenPosition photoPos = map.getScreenPosition(photoLoc);
  ellipse(photoPos.x, photoPos.y, 4, 4);
  if (findClosest) {
    double minDist = 10000;
    for (int i=0; i<locs.length; i+=100) {
      double d = GeoUtils.getDistance(photoLoc, locs[i]);
      if (d<minDist) {
        minDist = d;
        minLoc = locs[i];
        id = i;
      }
    }
    //
    findClosest = false;
    println("data id = " + id);
    print("MQ135 value: " + table.getFloat(id, 4)+", ");
    print("MQ135 average: " + table.getFloat(id, 5)+", ");
    print("MQ135 peak: " + table.getFloat(id, 6)+", ");
    print("MQ2 value: " + table.getFloat(id, 7)+", ");
    print("MQ2 average: " + table.getFloat(id, 8)+" ");
    print("MQ2 peak: " + table.getFloat(id, 9)+" ");
    print("Dust: " + table.getFloat(id, 10)+" ");
  }
  //
  ScreenPosition dataPos = map.getScreenPosition(minLoc);
  stroke(255, 255, 0);
  line(photoPos.x, photoPos.y, dataPos.x, dataPos.y);
}

void keyPressed() {

  if (key=='f' || key=='F') {
    findClosest = true;
  }
}

