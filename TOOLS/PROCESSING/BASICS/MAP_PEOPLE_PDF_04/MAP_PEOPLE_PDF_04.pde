// FOR NEW DATA SCHEMA

import processing.pdf.*;

import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;

import de.fhpotsdam.unfolding.providers.Microsoft;

UnfoldingMap map;

int colPeople = 4; // count of people in a location
int colLat = 0;
int colLng = 1;

ArrayList<PeopleDataNode> peopleList;
Table table;

Boolean render = false;
Boolean calculate = false;

int gsize = 25;

void setup() {
  size(800, 800, OPENGL);
  // setup map
  map = new UnfoldingMap(this, new Microsoft.AerialProvider());
  map.setTweening(true);
  MapUtils.createDefaultEventDispatcher(this, map);
  // load data
  table = loadTable("merged-people.csv", "header");
  println(table.getRowCount());
  //
  peopleList = new ArrayList<PeopleDataNode>();

  for (int r=0; r<table.getRowCount (); r++) {
    // get lat lng from table
    float lat = table.getFloat(r, colLat);
    float lon = table.getFloat(r, colLng);
    // create location
    Location l = new Location(lat, lon);
    // get number of people
    int v = table.getInt(r, "number people");
    // check it is at least one person or more
    if (v>0) {
      // create new data object and add it and to arraylist
      PeopleDataNode p = new PeopleDataNode( lat, lon, v );
      peopleList.add(p);
    }
    // error checking for rogue data!
    if (lat < 51.2) {
      println(r+"!!!");
      println(lat);
    }
  }
  // set init drawing styles
  fill(250, 138, 52);
  noStroke();
  // set map to london
  map.zoomAndPanTo(10, new Location(51.5f, -0.118f));
}

void draw() {
  if (render) {
    saveFrame("fr-####.tiff"); // render to tiff for reference
  }

  background(0);
  map.draw(); // display map

  if (render) {
    map.draw();
    filter(GRAY); // make map greyscale for engraving on laser cutter
    save("bw-map.tiff"); // save greyscale map
    beginRecord(PDF, "output.pdf"); // create pdf to record circles to
  }

  // PLOT PEOPLE per grid
  if (calculate) {
    fill(40, 186, 165, 255);
    noStroke();
    for (int yy=0; yy<height; yy += gsize) {
      for (int xx=0; xx<width; xx += gsize) {
        int pTotal = 0;
        for (int i=0; i<peopleList.size (); i+=1) {
          PeopleDataNode p = peopleList.get(i);
          Location l = new Location(p.lat, p.lng);
          ScreenPosition pos1 = map.getScreenPosition(l);//map.getScreenPosition(locationList.get(i));
          if (pos1.x >= xx && pos1.x < xx+gsize && pos1.y >= yy && pos1.y < yy+gsize) {
            pTotal += p.people;
          }

          /*float v = norm(p.people, 0, 20);
           float d = 30*sqrt(v/PI);//p.people*4;// 2*sqrt(v/PI);
           if (!render) {
           fill(40, 186, 165, 255);
           noStroke();
           } else {
           fill(40, 186, 165, 255);
           noStroke();
           //stroke(255, 0, 0); // rgb red for cut stroke on laser cutter
           //strokeWeight(0.001); // cut stroke size is 0.001pt on laser cutter
           }
           ellipse(pos1.x, pos1.y, d, d);
           */
        }
        if (pTotal > 0) {
          println(pTotal);
          float v = norm(pTotal, 1, 150);
          float d = 20*sqrt(v/PI)*2;
          ellipse(xx+gsize*0.5, yy+gsize*0.5, d, d);
        }
      }
    }
  }
  // end recording to pdf
  if (render) {
    endRecord();
    render = false;
  }
  if (calculate) {
    //exit();
  }
}

void keyPressed() {
  if (key=='r' || key=='R') {
    render = true;
  }
  if (key=='c' || key=='C') {
    calculate = !calculate;
  }
}

// class to hold people count data
class PeopleDataNode {
  float lat;
  float lng;
  int people;

  PeopleDataNode(float lat_, float lng_, int p) {
    lat = lat_;
    lng = lng_;
    people = p;
  }
}

