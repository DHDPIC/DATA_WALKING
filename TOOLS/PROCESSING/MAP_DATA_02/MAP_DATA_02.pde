// FOR NEW DATA SCHEMA

import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;

import de.fhpotsdam.unfolding.providers.Microsoft;

UnfoldingMap map;

int rowLight = 4; // val hi = 0; lo = 1024 
int rowSound = 5; // 1024
int rowSndAvg = 6; // 1024
int rowSndPek = 7; // 1024
int rowTemp = 8; // vals in celcius
int rowPeople = 9;

int dust = 10;
int gasMQ135 = 6;

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
  table = loadTable("20160825-gas-sensors.csv");
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
    //line(pos1.x, pos1.y, pos2.x, pos2.y);
  }
  // PLOT LIGHT
  for (int i=1; i<locs.length; i+=1) {
    ScreenPosition pos1 = map.getScreenPosition(locs[i-1]);
    ScreenPosition pos2 = map.getScreenPosition(locs[i]);
    
    float l = map(table.getFloat(i,rowLight),1024,0,1,32);
    //fill(252,95,109);
    //ellipse(pos1.x, pos1.y, l, l);
  }
  
  // PLOT TEMP
  for (int i=1; i<locs.length; i+=1) {
    ScreenPosition pos1 = map.getScreenPosition(locs[i-1]);
    ScreenPosition pos2 = map.getScreenPosition(locs[i]);
    
    float t = map(table.getFloat(i,rowTemp),0,30,1,32);
    fill(53,170,178);
    //ellipse(pos1.x, pos1.y, t, t);
  }
  
  // PLOT SOUND
  for (int i=1; i<locs.length; i+=1) {
    ScreenPosition pos1 = map.getScreenPosition(locs[i-1]);
    ScreenPosition pos2 = map.getScreenPosition(locs[i]);
    
    float s = map(table.getFloat(i,rowSndAvg),0,124,1,64);
    fill(250,138,52);
    //ellipse(pos1.x, pos1.y, s, s);
  }
  
  // PLOT PEOPLE
  for (int i=1; i<locs.length; i+=1) {
    ScreenPosition pos1 = map.getScreenPosition(locs[i-1]);
    ScreenPosition pos2 = map.getScreenPosition(locs[i]);
    
    float s = map(table.getFloat(i,rowPeople),0,20,0,60);
    fill(250,138,52);
    //ellipse(pos1.x, pos1.y, s, s);
  }
  
  // PLOT DUST
  for (int i=1; i<locs.length; i+=1) {
    ScreenPosition pos1 = map.getScreenPosition(locs[i-1]);
    ScreenPosition pos2 = map.getScreenPosition(locs[i]);
    
    float s = map(table.getFloat(i,dust),0,40000,0,60);
    fill(250,138,52);
    //ellipse(pos1.x, pos1.y, s, s);
  }
  
  // PLOT DUST
  for (int i=1; i<locs.length; i+=1) {
    ScreenPosition pos1 = map.getScreenPosition(locs[i-1]);
    ScreenPosition pos2 = map.getScreenPosition(locs[i]);
    
    float s = map(table.getFloat(i,gasMQ135),0,200,0,60);
    fill(138,250,52);
    ellipse(pos1.x, pos1.y, s, s);
  }
}

void keyPressed() {
  if(key=='r' || key=='R') {
    saveFrame("fr-####.tiff");
  }
}

