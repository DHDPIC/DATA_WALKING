import isolines.*;
import channels.*;
import processing.pdf.*;

Isolines finder;
PImage img;
int threshold = 200;
int layerResolution = 10;
boolean recording = false;

void setup() {
  // load the image and scale
  // the sketch to the image size
  size(1280, 800);
  img = loadImage("ppm-CO2-heat.tiff");
  // initialize an isolines finder based on img dimensions
  finder = new Isolines(this, img.width, img.height);
}

void draw() {
  image(img, 0, 0);
  // if ready to render a pdf
  if(recording) {
    beginRecord(PDF, "isoline.pdf");
  }
  // this loop slows the program down a lot
  // but it lets you see the isoline output
  for (int i=0; i<255; i+= layerResolution) {
    // update the threshold
    finder.setThreshold(i);
    // Use the Channels library to extract
    // the brightness channel as an int array
    int[] pix = Channels.brightness(img.pixels);
    // find the isolines in the hue pixels
    finder.find(pix);
    // draw the contours
    stroke(255, 0, 0);
    noFill();
    for (int k = 0; k < finder.getNumContours (); k++) {
      //finder.drawContour(k); // quicker but makes many individual lines rather than joined shape for each contour
      PVector[] points = finder.getContourPoints(k);
      beginShape();
      // do a loop through points
      for(int j=0; j<points.length; j++) {
        PVector p = points[j];
        vertex(p.x,p.y);
      }
      endShape(CLOSE);
    }
  }
  if(recording) {
    endRecord();
    recording = false;
  }
}

void keyPressed() {
  if (key == '-') {
    layerResolution -=5;
    if (layerResolution < 5) {
      layerResolution = 5;
    }
    println(layerResolution);
  }
  if (key == '=') {
    layerResolution +=5;
    println(layerResolution);
  }
  if (key == 'r' || key == 'R') {
    recording  = true;
  }
}

