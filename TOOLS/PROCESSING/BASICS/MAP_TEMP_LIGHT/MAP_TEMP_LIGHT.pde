// FOR NEW DATA SCHEMA

import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;

import de.fhpotsdam.unfolding.providers.Microsoft;

UnfoldingMap map;

int colTemp = 8; // val Celcius 0 : 30
int colLight = 4; // val hi = 0; lo = 1024

int colLat = 0;
int colLng = 1;

FloatList lats;
FloatList lons;

Location[] locs;

Table table;

Boolean render = false;

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
  table = loadTable("merged-environment.csv", "header");
  println(table.getRowCount());
  locs = new Location[table.getRowCount()];
  for(int r=0; r<table.getRowCount(); r++) {
    float lat = table.getFloat(r,colLat);
    float lon = table.getFloat(r,colLng);
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
  /*
  for (int i=1; i<locs.length; i+=1) {
    ScreenPosition pos1 = map.getScreenPosition(locs[i-1]);
    ScreenPosition pos2 = map.getScreenPosition(locs[i]);
    stroke(255,0,0);
    line(pos1.x, pos1.y, pos2.x, pos2.y);
  }
  */
  
  // PLOT LIGHT
  for (int i=0; i<locs.length; i+=1) {
    ScreenPosition pos1 = map.getScreenPosition(locs[i]);
    
    float t = map(table.getFloat(i,colTemp),0,30,0,255);
    float l = map(table.getFloat(i,colLight),1024,0,0,16);
    fill(t,0,0,51);
    ellipse(pos1.x, pos1.y, l, l);
  }
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

