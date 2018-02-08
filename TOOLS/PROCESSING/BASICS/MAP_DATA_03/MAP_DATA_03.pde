// FOR FOR SUPER SIMPLE SINGLE DATA INPUT

import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;

import de.fhpotsdam.unfolding.providers.Microsoft;

UnfoldingMap map;

int dataColumn = 4; // val hi = 0; lo = 1024 

int rowLat = 0;
int rowLng = 1;

FloatList lats;
FloatList lons;

Location[] locs;

Table table;

void setup() {
  //
  size(1280,900);
  //
  map = new UnfoldingMap(this, new Microsoft.AerialProvider());
  map.setTweening(true);
  MapUtils.createDefaultEventDispatcher(this, map);
  //
  lats = new FloatList();
  lons = new FloatList();
  //
  table = loadTable("20161020-gas-sensors.csv", "header");
  println(table.getRowCount());
  locs = new Location[table.getRowCount()];
  for(int r=0; r<table.getRowCount(); r++) {
    float lat = table.getFloat(r,rowLat);
    float lon = table.getFloat(r,rowLng);
    //println(lon);
    lats.append(lat);
    lons.append(lon);
    Location l = new Location(lat,lon);
    locs[r] = l;
  }
  //
  fill(250,138,52);
  noStroke();
}

void draw() {
  //
  map.draw();
  // PLOT A ROUTE
  for (int i=1; i<locs.length; i+=1) {
    ScreenPosition pos1 = map.getScreenPosition(locs[i-1]);
    ScreenPosition pos2 = map.getScreenPosition(locs[i]);
    stroke(255,0,0);
    line(pos1.x, pos1.y, pos2.x, pos2.y);
  }
  
  // PLOT DATA
  for (int i=1; i<locs.length; i+=1) {
    ScreenPosition pos1 = map.getScreenPosition(locs[i-1]);
    ScreenPosition pos2 = map.getScreenPosition(locs[i]);
    
    float l = map(table.getFloat(i,dataColumn),0,1024,1,32);
    fill(252,95,109);
    ellipse(pos1.x, pos1.y, l, l);
  }
}

void keyPressed() {
  if(key=='r' || key=='R') {
    saveFrame("fr-####.tiff");
  }
}

