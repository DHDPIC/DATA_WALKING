// TAKE SLITSCAN DATA, PLOT A ROUTE, RENDER THE SLIT LINES IN SPACE
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;

import de.fhpotsdam.unfolding.providers.Microsoft;

UnfoldingMap map;
Location[] locs;
Table table;
Boolean plot = false;
int colorCol = 4; // column that starts storing colour data from

void setup() {
  size(1280, 900);
  // create new map instance
  map = new UnfoldingMap(this, new Microsoft.AerialProvider());
  map.setTweening(true);
  MapUtils.createDefaultEventDispatcher(this, map);
  // load data
  table = loadTable("data2016_11_24_14_56_3_0.csv");
  println(table.getRowCount());
  locs = new Location[table.getRowCount()];
  for (int r=0; r<table.getRowCount (); r++) {
    float lat = table.getFloat(r, 1);
    float lon = table.getFloat(r, 2);
    Location l = new Location(lat, lon);
    locs[r] = l;
  }
}

void draw() {
  // how many points to plot
  int inc = 10;
  // plot a route
  if (!plot) {
    map.draw();
    for (int i=inc; i<locs.length; i+=inc) {
      ScreenPosition pos1 = map.getScreenPosition(locs[i-inc]);
      ScreenPosition pos2 = map.getScreenPosition(locs[i]);
      stroke(255, 0, 0);
      line(pos1.x, pos1.y, pos2.x, pos2.y);
    }
    // plot the slits
  } else { 
    background(255);
    for (int i=inc; i<locs.length; i+=inc) {
      ScreenPosition pos1 = map.getScreenPosition(locs[i-inc]);
      ScreenPosition pos2 = map.getScreenPosition(locs[i]);
      // get data along the row for as many columns as there are starting from colorCol
      for (int x=0; x<table.getColumnCount()-colorCol; x+=1) {
        String s = table.getString(i, colorCol+x);
        s = s.substring(1); // remove #
        color c = color(unhex("FF"+s)); // convert to colour
        stroke(c);
        // use the x row value to then plot to 1px height increments
        line(pos1.x, pos1.y+x, pos2.x, pos2.y+x);
      }
    }
  }
}

void keyPressed() {
  if (key=='s' || key=='S') {
    saveFrame("fr-####.tiff");
  }
  if (key=='p' || key=='P') {
    plot = !plot;
  }
}

