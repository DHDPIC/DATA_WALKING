// FOR NEW DATA SCHEMA

import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;

import de.fhpotsdam.unfolding.providers.Microsoft;

UnfoldingMap map;

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
  table = loadTable("2016_10_6_16_7_54_0_clean.csv");
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
    //line(pos1.x, pos1.y, pos2.x, pos2.y);
  }
  
  // PLOT RADIATION
  for (int i=1; i<locs.length; i+=1) {
    ScreenPosition pos1 = map.getScreenPosition(locs[i-1]);
    ScreenPosition pos2 = map.getScreenPosition(locs[i]);
    
    float s = map(table.getFloat(i,5),0,100,0,60);
    fill(138,250,52);
    noStroke();
    ellipse(pos1.x, pos1.y, s, s);
  }
}

void keyPressed() {
  if(key=='r' || key=='R') {
    saveFrame("fr-####.tiff");
  }
}

