// poisson disk sampling
// stippling
// attempting...

// DOES NOT WORK FULLY
// algo runs away and still fills in light areas as if dark
// not getting active list to zero?

// ignore columns and grid
// check against rendered pixels in region of image
// get r value from darkness of image at current sample

import processing.pdf.*;

float r = 10;
float k = 30;//30; 

PVector[] grid;
float w;


int cols, rows;

PVector pos;

ArrayList<PVector> active;

PImage src, buf, out;
PGraphics pg;

int stipMin = 4; // as close as points can be (shouldn't be less than 3)
int stipMax = 20; // as far away as points can be

void setup() {
  size(1600,800);
  //background(0,102,102);
  background(255);

  src = loadImage("2016_12_15_22_36_47-exp-soundpeak-p5-m0m500.tiff");
  buf = createImage(800, 800, ARGB);
  out = createImage(800, 800, ARGB);
  pg = createGraphics(800,800, PDF, "output-inv.pdf");
  pg.beginDraw();
  pg.background(255);
  pg.stroke(0);
  pg.endDraw();
  color c = (255);
  out.loadPixels();
  //out.pixels[10+10*out.width] = color(255, 255, 255);
  out.updatePixels();
  scanAreaClear(10, 10, 50);
  //image(out,0,0);

  w = floor(r/sqrt(2));
  println(w);

  active = new ArrayList<PVector>();




  int x = floor(out.width/2);//floor(random(width));
  int y = floor(out.height/2);//floor(random(height));
  pos = new PVector(x, y);

  active.add(pos);

  //buf.pixels[x+y*buf.width] = color(255, 0, 0);
}

void draw() {
  //noLoop();
  //background(100,100,0);
  //image(src, 0, 0);

  //image(buf,0,400);
  image(out, 0, 0);
  image(src, 800, 0);
  //image(pg,400,400);

  println("a: " + active.size());

  while (active.size() > 0) {

    int randIndex = floor(random(active.size()));
    PVector pos = active.get(randIndex);
    Boolean found = false;

    for (int n=0; n<k; n++) {
      float a = random(TWO_PI);
      float offsetX = cos(a);
      float offsetY = sin(a);
      color pix = src.get(int(pos.x), int(pos.y));
      float density = brightness(pix);
      //println("d= " + density);
      r = constrain(map(density, 0, 255, stipMin, stipMax),stipMin,stipMax);
      //println("r= " + r);
      float m = random(r, r*2);
      //PVector sample = new PVector(pos.x+offsetX*m, pos.y+offsetY*m);
      PVector sample = new PVector(offsetX, offsetY);
      sample.setMag(m);
      sample.add(pos);
      int xs = floor(sample.x);
      int ys = floor(sample.y);
      if (xs > 0 && xs < buf.width && ys > 0 && ys < buf.height) {
      //if (xs+ys*buf.width > 0 && xs+ys*buf.width < buf.pixels.length) {
        buf.pixels[xs+ys*buf.width] = color(0, 255, 255); // THIS NEEDS FIXING
        buf.updatePixels();
        if (scanAreaClear(floor(xs-r/2), floor(ys-r/2), floor(r))) {
          //println("do something");
          Boolean ok = true;

          PVector neighbour = scanAreaCandidate(floor(xs-r), floor(ys-r), floor(r*2));
          if (neighbour.x != -1) {
            float d = dist(sample.x, sample.y, neighbour.x, neighbour.y);
            if (d<r) {
              ok = false;
            }
          }
          if (ok) {
            found = true;
            out.pixels[xs+ys*out.width] = color(0);//color(255, 178, 220);
            out.updatePixels();
            active.add(sample);
            pg.beginDraw();
            //pg.strokeWeight((255-density)/100);
            pg.point(xs,ys);
            pg.endDraw();
          }
        }
      }
    } // xs ys if statement
    if (!found) {
      active.remove(randIndex);
      buf.pixels[int(pos.x)+int(pos.y)*buf.width] = color(0);
      buf.updatePixels();
    }
  }
  
  if(active.size() == 0) {
    image(out, 0, 0);
    image(src, 800, 0);
    save("test2.jpg");
    pg.dispose();
    //pg.save("pg2.jpg");
    exit();
  }
}

Boolean scanAreaClear(int x, int y, int r) {
  //
  Boolean empty = true;
  color tmp = color(0, random(255), random(255));
  
  for (int i=y; i<y+r; i++) {
    for (int j=x; j<x+r; j++) {
      if (j+i*out.width > 0 && j+i*out.width < out.pixels.length) {
        color c = out.pixels[j+i*out.width];
        if (alpha(c) > 0) {
          //println("region full");
          empty = false;
        } else {
          //out.pixels[j+i*out.width] = tmp;
        }
      }
    }
  }
  return empty;
}

PVector scanAreaCandidate(int x, int y, int r) {
  PVector pos = new PVector(-1, -1);
  //color tmp = color(0,random(255),random(255));
  
  for (int i=y; i<y+r; i++) {
    for (int j=x; j<x+r; j++) {
      if (j+i*out.width > 0 && j+i*out.width < out.pixels.length) {
        color c = out.pixels[j+i*out.width];
        if (alpha(c) > 0) {
          //println("region already");
          pos = new PVector(j, i);
        } else {
          //out.pixels[j+i*out.width] = tmp;
        }
      }
    }
  }
  return pos;
}

