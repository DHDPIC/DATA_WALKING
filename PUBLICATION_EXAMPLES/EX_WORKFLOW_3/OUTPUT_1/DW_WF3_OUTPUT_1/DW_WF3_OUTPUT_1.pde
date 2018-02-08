// FOR FOR SUPER SIMPLE SINGLE DATA INPUT

import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;

import de.fhpotsdam.unfolding.providers.Microsoft;

UnfoldingMap map;

int dataColumn = 5;//4; // val hi = 0; lo = 1024 

int rowLat = 0;
int rowLng = 1;

Location[] locs;

Table table;

Heatmap h;
Boolean heat = false;

void setup() {
  //
  size(1280, 800);
  //
  map = new UnfoldingMap(this, new Microsoft.AerialProvider());
  map.setTweening(true);
  MapUtils.createDefaultEventDispatcher(this, map);
  //
  table = loadTable("GPSLOG03.csv", "header");
  println(table.getRowCount());
  locs = new Location[table.getRowCount()];
  for (int r=0; r<table.getRowCount (); r+=1) {
    float lat = table.getFloat(r, rowLat);
    float lon = table.getFloat(r, rowLng);
    Location l = new Location(lat, lon);
    locs[r] = l;
  }
  //
  fill(250, 138, 52);
  noStroke();
}

void draw() {
  map.draw();
  // PLOT DATA
  for (int i=0; i<locs.length; i+=1) {
    ScreenPosition pos = map.getScreenPosition(locs[i]);
    float v = norm(table.getFloat(i, dataColumn), 0, 500); //normalise data
    float d = 2*sqrt(v/PI); // calculate diameter for value as area
    d = d*20; // multiply so maximum value in range 0-500 equates to 20px ellipse
    fill(252, 95, 109);
    ellipse(pos.x, pos.y, d, d);
  }
  
  if(heat) {
    h.render();
  }
}

void keyPressed() {
  if (key=='s' || key=='S') {
    saveFrame("fr-####.tiff");
  }

  if (key=='h' || key=='H') {
    heat = !heat;
    if(heat) {
      makeHeatmap();
    }
  }
}

void makeHeatmap() {
  PVector[] points;
  float[] values;
  int len = locs.length;
  points = new PVector[len];
  values = new float[len];
  for (int i=0; i<len; i+=1) {
    ScreenPosition pos = map.getScreenPosition(locs[i]);
    PVector p = new PVector(pos.x,pos.y);
    points[i] = p;
    // map the value range to 0-255 for grayscale values
    float v = map(table.getFloat(i, dataColumn), 0, 300, 0, 255);
    v = constrain(v,0,255);
    values[i] = v;
    println(v);
  }
  
  h = new Heatmap(points, values);
  h.power = 5;
  h.generate();
  h.render();
}

