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

void setup() {
  //
  size(1280,900,OPENGL);
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
  // set map to london
  map.zoomAndPanTo(10, new Location(51.5f, -0.118f));
}

void draw() {
  // use blend modes to render map as flat...
  blendMode(BLEND);
  background(0);
  map.draw();
  this.loadPixels();
  // ...and then lines overlayed
  blendMode(ADD);
  // PLOT A ROUTE/LIGHT (as thickness of line)
  for (int i=100; i<locs.length; i+=100) {
    ScreenPosition pos1 = map.getScreenPosition(locs[i-100]);
    ScreenPosition pos2 = map.getScreenPosition(locs[i]);
    float l = map(table.getFloat(i,colLight),700,0,0,255);
    strokeWeight(5);
    stroke(255,l);
    line(pos1.x, pos1.y, pos2.x, pos2.y);
  }
  
  // PLOT LIGHT
  /*for (int i=0; i<locs.length; i+=1) {
    ScreenPosition pos1 = map.getScreenPosition(locs[i]);
    
    float l = map(table.getFloat(i,colLight),1024,0,0,32);
    fill(255,255,51);
    ellipse(pos1.x, pos1.y, l, l);
  }*/
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

