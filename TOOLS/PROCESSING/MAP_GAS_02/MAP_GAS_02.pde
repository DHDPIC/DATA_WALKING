// FOR NEW DATA SCHEMA

import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;

import de.fhpotsdam.unfolding.providers.Microsoft;

UnfoldingMap map;

int colGas = 6; // MQ135 5=average, 6=peak; MQ2 8=average, 9=peak; val lo = 0, hi = 1024;

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
  table = loadTable("GPSLOG59.csv", "header");
  println(table.getRowCount());
  locs = new Location[table.getRowCount()];
  
  float maxG = 0;
  float minG = 1024;
  
  for(int r=0; r<table.getRowCount(); r++) {
    float lat = table.getFloat(r,colLat);
    float lon = table.getFloat(r,colLng);
    //println(lon);
    lats.append(lat);
    lons.append(lon);
    Location l = new Location(lat,lon);
    locs[r] = l;
    //
    float v = table.getFloat(r,colGas);
    maxG = max(maxG,v);
    minG = min(minG,v);
  }
  //
  println("max = " + maxG);
  println("min = " + minG);
  //
  fill(250,138,52);
  noStroke();
  // set map to london
  map.zoomAndPanTo(10, new Location(51.5f, -0.118f));
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
  
  // PLOT GAS
  for (int i=0; i<locs.length; i+=1) {
    ScreenPosition pos1 = map.getScreenPosition(locs[i]);
    
    float v = norm(table.getFloat(i,colGas),0,1024);
    float d = 2*sqrt(v/PI);
    //fill(0,255,102);
    //ellipse(pos1.x, pos1.y, d*16, d*16);
    float r = map(table.getFloat(i,colGas),80,120,0,255);
    color c = color(r,0,255-r);
    fill(c);
    //fill(255);
    //ellipse(pos1.x, pos1.y,5,5);
    //fill(255,0,255,r);
    ellipse(pos1.x, pos1.y,5,5);
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

