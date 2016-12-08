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

int rowLat = 1;
int rowLng = 2;

int rowCol = 4;

FloatList lats;
FloatList lons;

Location[] locs;

color[] cols;

Table table;

Boolean plot = false;

void setup() {
  //
  size(1280, 900);
  //
  map = new UnfoldingMap(this, new Microsoft.AerialProvider());
  map.setTweening(true);
  MapUtils.createDefaultEventDispatcher(this, map);
  //
  lats = new FloatList();
  lons = new FloatList();
  //
  table = loadTable("data2016_11_24_14_56_3_0.csv");
  println(table.getColumnCount());
  locs = new Location[table.getRowCount()];
  cols = new color[table.getRowCount()];
  for (int r=0; r<table.getRowCount (); r++) {
    float lat = table.getFloat(r, rowLat);
    float lon = table.getFloat(r, rowLng);
    //println(lon);
    lats.append(lat);
    lons.append(lon);
    Location l = new Location(lat, lon);
    locs[r] = l;
    String s = table.getString(r, rowCol);
    //println(s);
    s = s.substring(1);
    cols[r] = color(unhex("FF"+s));
  }
  //
  fill(250, 138, 52);
  noStroke();
}

void draw() {
  //

  // PLOT A ROUTE
  if (!plot) {
    map.draw();
    for (int i=1; i<locs.length; i+=1) {
      ScreenPosition pos1 = map.getScreenPosition(locs[i-1]);
      ScreenPosition pos2 = map.getScreenPosition(locs[i]);
      stroke(255, 0, 0);
      line(pos1.x, pos1.y, pos2.x, pos2.y);
    }
  } else {
    background(0);
    for (int i=1; i<locs.length; i+=1) {
      ScreenPosition pos1 = map.getScreenPosition(locs[i-1]);
      ScreenPosition pos2 = map.getScreenPosition(locs[i]);
      //stroke(255,0,0);
      for (int x=0; x<89; x++) {
        //stroke(cols[i]);

        String s = table.getString(i, rowCol+x);
        s = s.substring(1);
        color c = color(unhex("FF"+s));

        stroke(c);
        line(pos1.x, pos1.y+x, pos2.x, pos2.y+x);
      }
    }
  }
}

void keyPressed() {
  if (key=='r' || key=='R') {
    saveFrame("fr-####.tiff");
  }

  if (key=='p' || key=='P') {
    plot = !plot;
  }
}

