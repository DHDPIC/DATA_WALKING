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

ArrayList<Person> persons;
Boolean calculate = false;

Boolean jostlePersons = false;

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

  fill(40, 186, 165, 255);
  noStroke();
  // PLOT PEOPLE

  // create person list
  if (calculate) {
    calculatePersons();
  }
  if (jostlePersons) {
    for (int i=0; i<persons.size (); i++) {
      Person p = persons.get(i);
      Boolean check = p.checkAll();
      if (check) {
        p.jostle();
        //break;
      }
      p.render();
    }
  }
  /*for (int i=0; i<peopleList.size (); i+=1) {
   PeopleDataNode p = peopleList.get(i);
   Location l = new Location(p.lat, p.lng);
   ScreenPosition pos1 = map.getScreenPosition(l);//map.getScreenPosition(locationList.get(i));
   
   //float v = norm(p.people, 0, 20);
   //float d = p.people*4;// 2*sqrt(v/PI);
   float v = p.people;
   for (int n=0; n<v; n++) {
   ellipse(pos1.x+random(-5, 5), pos1.y+random(-5, 5), 3, 3);
   }
   }*/



  // end recording to pdf
  if (render) {
    endRecord();
    render = false;
  }
}

void keyPressed() {
  if (key=='r' || key=='R') {
    render = true;
  }

  if (key=='c' || key=='C') {
    calculate = true;
  }
}

void calculatePersons() {
  persons = new ArrayList<Person>();
  int id = 0;
  for (int i=0; i<peopleList.size (); i+=1) {
    PeopleDataNode p = peopleList.get(i);
    Location l = new Location(p.lat, p.lng);
    ScreenPosition pos1 = map.getScreenPosition(l);//map.getScreenPosition(locationList.get(i));

    //float v = norm(p.people, 0, 20);
    //float d = p.people*4;// 2*sqrt(v/PI);
    float v = p.people;
    for (int n=0; n<v; n++) {
      //ellipse(pos1.x+random(-5, 5), pos1.y+random(-5, 5), 3, 3);
      Person pers = new Person(id, pos1.x, pos1.y);
      persons.add(pers);
      id++;
    }
  }
  calculate = false;
  jostlePersons = true;
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

// class to represent each person
class Person {
  int id;
  float x;
  float y;
  float d;

  Person(int id_, float x_, float y_) {
    id = id_;
    x = x_;
    y = y_;
    d = 3;
  }

  void render() {
    ellipse(x, y, d, d);
  }

  void jostle() {
    x += random(-1, 1);
    y += random(-1, 1);
  }

  Boolean checkAll() {
    Boolean checker = false;
    for (int i=0; i<persons.size (); i++) {
      if (i != id) {
        Person p = persons.get(i);

        checker = checkOverlap(p.x, p.y);
        if (checker) {
          break;
        }
      }
    }
    return checker;
  }

  Boolean checkOverlap(float x_, float y_) {
    // check if circles are overlapping using dist()
    Boolean check = false;
    float prox = dist(x, y, x_, y_);
    if (prox < d) {
      check = true;
    }
    return check;
  }
}

