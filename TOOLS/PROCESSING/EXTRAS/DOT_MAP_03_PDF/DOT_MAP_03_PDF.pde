// dot map based on heat map

import processing.pdf.*;

PImage img;
int gs = 10;

void setup() {
  size(800, 800, PDF, "output.pdf");
  //background(0);
  noStroke();



  img = loadImage("2016_12_15_22_36_47-exp-soundpeak-p5-m0m500.tiff");

  img.loadPixels();

  for (int y=0; y<img.height; y+=gs) {
    for (int x=0; x<img.width; x+=gs) {
      //
      float b = average(x, y);
      float s = map(b, 0, 255, 0, gs);
      ellipse(x+gs/2, y+gs/2, s, s);
      //
    }
  }
  //
  println("done...");
  exit();
}

void draw() {
  // empty
}

float average(int _x, int _y) {
  //
  float b = 0;
  for (int y=0; y<gs; y+=1) {
    for (int x=0; x<gs; x+=1) {
      color c = img.get(x+_x, y+_y);
      b += brightness(c);
    }
  }
  b /= (gs*gs);
  return b;
}