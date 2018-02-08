// FOR NEW DATA SCHEMA

import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;

import de.fhpotsdam.unfolding.providers.Microsoft;

UnfoldingMap map;

int colData = 7; // 6=average, 7=peak; val lo = 0, hi = 1024;

int colLat = 0;
int colLng = 1;

FloatList lats;
FloatList lons;

Location[] locs;

Table table;

Boolean render = false;

Boolean animate = false;
int frame = 0;

color c1 = color(255,0,51);
color c2 = color(51,51,255);

void setup() {
  //
  size(800, 800, OPENGL);
  smooth(8);
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
  for (int r=0; r<table.getRowCount (); r++) {
    
    float lat = table.getFloat(r, colLat);
    float lon = table.getFloat(r, colLng);
    //println(lon);
    lats.append(lat);
    lons.append(lon);
    Location l = new Location(lat, lon);
    locs[r] = l;
      
  }
  //
  fill(250, 138, 52);
  noStroke();
  strokeWeight(2);
  noFill();
  // set map to london
  map.zoomAndPanTo(10, new Location(51.5f, -0.118f));
  
}

void draw() {
  //
  map.draw();
  // PLOT A ROUTE
  if (animate) {
    blendMode(BLEND);
    background(0);
    blendMode(ADD);
    int l = 30;
    for (int i=l; i<frame; i+=l) {
      ScreenPosition pos1 = map.getScreenPosition(locs[i-l]);
      ScreenPosition pos2 = map.getScreenPosition(locs[i]);
      // simple grey stroke
      //stroke(102,51);
      //stroke(255,102,51,255);
      
      // lerp between colours
      //float d = float(i)/locs.length;
      //color c = lerpColor(c1,c2,d);
      //stroke(c);
      
      // simple formula
      //float g = float(i)/locs.length*255;
      //stroke(255, g-51, 51);
      //stroke(255-g, g*0.5, 51+max(0,g-51));
   
      // change weight according to data
      float v = map(table.getFloat(i,colData),0,128,1,5);
      strokeWeight(v);
      stroke(0,102,255);
      
      line(pos1.x, pos1.y, pos2.x, pos2.y);
    }
    // save it frame by frame
    saveFrame("frames2/fr-####.tiff");
    frame+=l;
    if (frame >= locs.length) {
      frame = 0;
      animate = false;
      //save final image and exit program
      saveFrame("fr-####.tiff");
      exit();
    }
  }

  if (render) {
    render = false;
    saveFrame("fr-####.tiff");
  }
}

void keyPressed() {
  if (key=='r' || key=='R') {
    render = true;
  }

  if (key=='a' || key=='A') {
    animate = !animate;
  }
}

