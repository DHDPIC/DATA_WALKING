// FOR NEW DATA SCHEMA

import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;

import de.fhpotsdam.unfolding.providers.Microsoft;

import processing.pdf.*;

UnfoldingMap map;

int colData = 4; // val hi = 0; lo = 1024

int colLat = 0;
int colLng = 1;

FloatList lats;
FloatList lons;

Location[] locs;

Table table;

Boolean render = false;

void setup() {
  //
  size(800, 800, OPENGL);
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
    lats.append(lat);
    lons.append(lon);
    Location l = new Location(lat, lon);
    locs[r] = l;
  }
  //
  //fill(250,138,52);
  fill(255, 0, 0);
  noStroke();
  // set map to london
  map.zoomAndPanTo(10, new Location(51.5f, -0.118f));
}

void draw() {
  background(100);
  map.draw();
  //for exporting a pdf
  if(render) {
    saveFrame("exp-####-map.jpg");
    beginRecord(PDF, "exp-####-vector.pdf");
  }
  // PLOT A ROUTE/LIGHT (as thickness of line)
  for (int i=10; i<locs.length; i+=10) {
    ScreenPosition pos1 = map.getScreenPosition(locs[i-10]);
    ScreenPosition pos2 = map.getScreenPosition(locs[i]);
    float d1 = map(table.getFloat(i-10, colData), 64, 0, 0, 5);
    float d2 = map(table.getFloat(i, colData), 64, 0, 0, 5);
    d1 = constrain(d1,0,5);
    d2 = constrain(d2,0,5);
    //stroke(255);
    PVector v1 = new PVector(pos1.x, pos1.y);
    PVector v2 = new PVector(pos2.x, pos2.y);
    renderVWP(v1, v2, d1, d2);
  }
  if (render) {
    endRecord();
    render = false;
    saveFrame("exp-####-all.jpg");
  }
}

void keyPressed() {
  if (key=='r' || key=='R') {
    render = true;
  }
}

void renderVWP(PVector v1, PVector v2, float d1, float d2) {
  PVector h = PVector.sub(v2, v1);
  float heading = h.heading();
  float ax, ay, bx, by, cx, cy, dx, dy;

  ax = v1.x + cos(heading-HALF_PI)*d1;
  ay = v1.y + sin(heading-HALF_PI)*d1;
  bx = v2.x + cos(heading-HALF_PI)*d2;
  by = v2.y + sin(heading-HALF_PI)*d2;
  cx = v2.x + cos(heading+HALF_PI)*d2;
  cy = v2.y + sin(heading+HALF_PI)*d2;
  dx = v1.x + cos(heading+HALF_PI)*d1;
  dy = v1.y + sin(heading+HALF_PI)*d1;

  ellipse(v1.x, v1.y, d1*2, d1*2);
  beginShape();
  vertex(ax, ay);
  vertex(bx, by);
  vertex(cx, cy);
  vertex(dx, dy);
  endShape(CLOSE);
}

