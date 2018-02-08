// FOR NEW DATA SCHEMA

import processing.pdf.*;

import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;

import de.fhpotsdam.unfolding.providers.Microsoft;

UnfoldingMap map;

int colLat = 3;
int colLng = 4;

Table table;
Location[] locs;
PImage[] imgs;
Boolean saver = false;

void setup() {
  size(1280, 900, OPENGL);
  // setup map
  map = new UnfoldingMap(this, new Microsoft.AerialProvider());
  map.setTweening(true);
  MapUtils.createDefaultEventDispatcher(this, map);
  // load data
  table = loadTable("data.csv", "header");
  println(table.getRowCount());
  // get locations for light & temperature data
  locs = new Location[table.getRowCount()];
  imgs = new PImage[table.getRowCount()];

  for (int r=0; r<table.getRowCount (); r++) {
    // get lat lng from table
    float lat = table.getFloat(r, colLat);
    float lon = table.getFloat(r, colLng);
    // create location
    Location l = new Location(lat, lon);
    // assign location to array for retrieving light/temperature
    locs[r] = l;
    // get file name from csv file chop off .jpg extension
    String name = table.getString(r,"FileName");
    name = name.replaceFirst("\\.jpg", "");
    // load corresponding image from green boxes folder
    PImage tmp = loadImage("output-images/boxes/"+name+"-box.jpg");
    // scale to manageable size and populate array
    imgs[r] = createImage(int(tmp.width*0.05), int(tmp.height*0.05), ARGB);
    imgs[r].copy(tmp,0,0,tmp.width,tmp.height,0,0,imgs[r].width,imgs[r].height); 
  }
  // set init drawing styles
  stroke(250, 138, 52);
  strokeWeight(3);
  // set map to london
  map.zoomAndPanTo(10, new Location(51.5f, -0.118f));
}

void draw() {
  background(255);
  map.draw(); // display map
  if(saver) {
    background(255);
  }

  // PLOT PHOTOS
  int inc = 1;
  for (int i=0; i<locs.length; i+=inc) {
    ScreenPosition pos1 = map.getScreenPosition(locs[i]);
    image(imgs[i],pos1.x,pos1.y);
  }
  if (saver) {
    save("photo-map-w.tiff");
    saver = false;
  }
}

void keyPressed() {
  if (key=='s' || key=='S') {
    saver = true;
  }
}

