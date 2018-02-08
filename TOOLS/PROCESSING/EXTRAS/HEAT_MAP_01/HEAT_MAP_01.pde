import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;

import de.fhpotsdam.unfolding.providers.Microsoft;

import java.util.*;


UnfoldingMap map;

FloatList lats;
FloatList lons;

Location[] locs;
ArrayList locslist;
float[] vals;

Table table;

float maxDist = 0;
float pe = 5; // how much to multiply power by //default was 2
PImage heat;
int num;

boolean render = false;

boolean normalise = false;

String timestamp = "";


void setup() {
  //
  size(800, 800);
  //
  map = new UnfoldingMap(this, new Microsoft.AerialProvider());
  map.setTweening(true);
  MapUtils.createDefaultEventDispatcher(this, map);
  //
  lats = new FloatList();
  lons = new FloatList();
  // LIKELY ISSUE WITH DATA IN COMBINED NORTH GREENWICH FILE !!!
  Table table2 = loadTable("merged/merged-air-quality.csv","header");
  table = new Table();
  int inc = 1;
  for(int j=0; j<table2.getRowCount(); j+=inc) {
    TableRow row = table2.getRow(j);
    float st = row.getFloat(8);
    // check the data is a number
    if(st < 0 || st >= 0) {
      //println(row.getString(17));
      if(st < -10) {
        println(j + " : " + st);
      }
      table.addRow(row);
    }
  }
  println(table.getRowCount());
  num = table.getRowCount();
  println(num);
  //num = 4;
  locs = new Location[num];
  vals = new float[num];

  // add columns for normalised x and y position
  table.addColumn("normX");
  table.addColumn("normY");
  
  float vmax=0;
  float vmin=1024;
  
  for (int r=0; r<num; r+=1) {
    float lat = table.getFloat(r, 0); //col 0 
    float lon = table.getFloat(r, 1); //col 1
    if(lat < 50) {
      println(r + " : " + lat);
    }
    lats.append(lat);
    lons.append(lon);
    Location l = new Location(lat, lon);
    locs[r] = l;
    // environment 4=light 5=sound 6=sound average 7=sound peak 8=temp
    // gas 4=MQ135 5=average 6=peak 7=MQ2 8=average 9=peak 10=dust
    float v = table.getFloat(r, 10);
    vals[r] = map(v,0,65000,0,255); 
    vmax = max(vmax,v);
    vmin = min(vmin,v);
  }
  println("max = "+vmax);
  println("min = "+vmin);
  //
  stroke(255, 102, 102);
  strokeWeight(2);
  noStroke();
  //
  heat = createImage(width, height, ARGB);
  heat.loadPixels();
  //
  maxDist = sqrt((width*width)+(height*height));//dist(0, 0, width, height);
  println(maxDist);
  //
  //map.zoomAndPanTo( new Location(52.35, 4.89), 11);
  locslist = new ArrayList();
  for (int l=0; l<num; l++) {
    locslist.add( locs[l] );
  }
  //map.zoomAndPanToFit( 10, locslist.get(0) );
}

void draw() {
  //
  map.draw();
  if (render) {
    timestamp = currentDate();
    save("exports3/"+timestamp+"-map.tiff");
  }
  // PLOT A ROUTE
  /*for (int i=1; i<locs.length; i+=1) {
   ScreenPosition pos1 = map.getScreenPosition(locs[i-1]);
   ScreenPosition pos2 = map.getScreenPosition(locs[i]);
   line(pos1.x, pos1.y, pos2.x, pos2.y);
   }*/
  //background(0);
  
  // PLOT POINTS
  for (int i=0; i<locs.length; i+=1) {
    ScreenPosition pos1 = map.getScreenPosition(locs[i]);
    //fill(vals[i]);
    //ellipse(pos1.x, pos1.y, 12, 12);
    fill(255, 0, 0);
    ellipse(pos1.x, pos1.y, vals[i]/255.0*10, vals[i]/255.0*10);
  }
  // get screen coords for each point, normalise, and then add to the file
  if (normalise) {
    for (int i=0; i<locs.length; i+=1) {
      ScreenPosition pos1 = map.getScreenPosition(locs[i]);
      float sX = pos1.x - width/2;
      float sY = pos1.y - height/2;
      //
      sX = norm(sX, 0,width/2);
      sY = norm(sY, 0,height/2);
      //
      table.setFloat(i,"normX",sX);
      table.setFloat(i,"normY",sY);
    }
    saveTable(table,"adjusted-ams-bin-norm-1.csv");
    normalise = false;
  }
  //
  if (render) {
    save("exports3/"+timestamp+"-dat.tiff");
    println("render = " + render);
    int starttime = millis();
    for (int y=0; y<height; y++) {
      // trace out percentage and elapsed time as minutes decimal
      println("render progress = " + int(1000*(float(y)/height))/10.0 + "%");
      println((millis()-starttime)/60000.0); 
      for (int x=0; x<width; x++) {

        //
        ArrayList<DistanceObject> distances = new ArrayList<DistanceObject>();

        for (int d=0; d<num; d+=1) {
          // get distances
          ScreenPosition pos = map.getScreenPosition(locs[d]);
          // FOR SOME REASON THIS IS ACTUALLY WORKING!!!
          //DistanceObject distobj = new DistanceObject( d, int(pos.x), int(pos.y), maxDist / max(dist(x, y, pos.x, pos.y), 1) );
          // more intense version higher power number more extreme
          DistanceObject distobj = new DistanceObject( d, int(pos.x), int(pos.y), maxDist / pow(max(dist(x, y, pos.x, pos.y), 1), pe) );

          // assign colours
          //distobj.r = vals[d];
          //distobj.g = vals[d];
          //distobj.b = vals[d];
          distobj.v = vals[d];
          distances.add( distobj );
        }
        //float tr=0;
        //float tg=0;
        //float tb=0;
        float tv=0;
        float t=0;
        for (int i=0; i<distances.size (); i+=1) {
          DistanceObject distobj = distances.get(i);
          //tr += distobj.r * distobj.distance;
          //tg += distobj.g * distobj.distance;
          //tb += distobj.b * distobj.distance;
          tv += distobj.v * distobj.distance;
          t += distobj.distance;
        }
        //tr /= t;
        //tg /= t;
        //tb /= t;
        tv /= t;
        //
        color c = color(tv);//color(tr, tg, tb);
        heat.set(x, y, c);
      }
    }
    // draw heatmap image
    image(heat, 0, 0);
    render = false;
    println("render = " + render);
    save("exports3/"+timestamp+"-exp.tiff");
    noLoop();
  }
}

// - - -

class DistanceObject {
  //
  int id;
  int x;
  int y;
  float distance;
  float r;
  float g;
  float b;
  float v;

  DistanceObject(int i, int xx, int yy, float dd) {
    //
    id = i;
    x = xx;
    y = yy;
    distance = dd;
  }
}

String currentDate() {
  String s = year()+"_"+month()+"_"+day()+"_"+hour()+"_"+minute()+"_"+second();
  return s;
}

void keyPressed() {
  if (key == 'r') {
    render = true;
  }
  if (key == 'n') {
    normalise = true;
  }
}

