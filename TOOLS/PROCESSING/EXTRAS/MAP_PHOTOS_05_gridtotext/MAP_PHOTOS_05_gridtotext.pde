// plot the photos
// output the names of photos contained in each grid square

import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;

import de.fhpotsdam.unfolding.providers.Microsoft;

UnfoldingMap map;

FloatList lats;
FloatList lons;

Location[] locs;
String[] filenames;

PrintWriter output;

Table table;

float gw = 0;
float gh = 0;

float dw = 8;
float dh = 7;

void setup() {
  //
  size(1400, 1400);
  //
  map = new UnfoldingMap(this, new Microsoft.AerialProvider());
  map.setTweening(true);
  MapUtils.createDefaultEventDispatcher(this, map);
  //
  lats = new FloatList();
  lons = new FloatList();
  //
  table = loadTable("datanew.csv", "header");
  println(table.getRowCount());
  locs = new Location[table.getRowCount()];
  filenames = new String[table.getRowCount()];
  for (int r=0; r<table.getRowCount (); r++) {
    float lat = table.getFloat(r, "GPSLatitude");
    float lon = table.getFloat(r, "GPSLongitude");
    //println(lon);
    lats.append(lat);
    lons.append(lon);
    Location l = new Location(lat, lon);
    locs[r] = l;
    filenames[r] = table.getString(r, "FileName");
  }
  //
  stroke(255, 102, 102);
  strokeWeight(1);
  //
  gw = width/dw;
  gh = height/dh;
  //
  output = createWriter("output.txt");
}

void draw() {
  //
  map.draw();
  //
  //println("W= "+gw);
  //println("H= "+gh);
  noFill();
  stroke(102, 102, 255);
  for (int y=0; y<height; y+=gh) {
    line(0, y, width, y);
  }
  for (int x=0; x<width; x+=gw) {
    line(x, 0, x, height);
  }
  //
  fill(102, 102, 255);
  for (int y=0; y<height; y+=gh) {
    for (int x=0; x<width; x+=gw) {
      String sx = str(int(x/gw));
      String sy = str(int(y/gh));
      text(sy+":"+sx, x+5, y+15);
    }
  }

  //
  stroke(255, 102, 102);
  noFill();
  // PLOT A ROUTE
  for (int i=1; i<locs.length; i+=1) {
    ScreenPosition pos1 = map.getScreenPosition(locs[i-1]);
    ScreenPosition pos2 = map.getScreenPosition(locs[i]);
    //line(pos1.x, pos1.y, pos2.x, pos2.y);
  }
  // PLOT POINTS
  for (int i=1; i<locs.length; i+=1) {
    ScreenPosition pos1 = map.getScreenPosition(locs[i-1]);
    ScreenPosition pos2 = map.getScreenPosition(locs[i]);
    ellipse(pos1.x, pos1.y, 5, 5);
  }
}

void keyPressed() {
  if (key=='s') {
    // take a photo!
    save("referencemap.png");
    // write some text!
    for (int y=0; y<height; y+=gh) {
      for (int x=0; x<width; x+=gw) {
        String sx = str(int(x/gw));
        String sy = str(int(y/gh));
        output.println("");
        output.println(">");
        output.println("grid "+sy+":"+sx);
        for (int i=0; i<locs.length; i+=1) {
          ScreenPosition pos = map.getScreenPosition(locs[i]);
          if (pos.x > x && pos.x <= x+gw && pos.y > y && pos.y <= y+gh) {
            output.println(filenames[i]);
          }
        }
      }
    }
    output.flush();
    output.close();
    //
  }
}

