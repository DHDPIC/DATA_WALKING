import isolines.*;
import channels.*;
// the Processing PDF exporter
import processing.pdf.*;

Isolines finder;
PImage img;
int threshold = 0;
boolean exporting = true;
// number of steps of threshold to skip
// per layer, lower this for more layers
int layerResolution = 26;

void setup() {
  // load the image and scale
  // the sketch to the image size
  img = loadImage("walkscore.png");
  size(img.width, img.height);
  // initialize an isolines finder based on img dimensions
  finder = new Isolines(this, img.width, img.height);
}

void draw() {
  image(img, 0, 0);
  // update the threshold
  //finder.setThreshold(threshold);
  // Use the Channels library to extract
  // the hue channel as an int array
  //int[] pix = Channels.hue(img.pixels);
  // find the isolines in the hue pixels
  //finder.find(pix);

  // draw the contours
  stroke(0);
  // if we're exporting
  if (exporting) {
    // start a new pdf file named after
    // the current threshold
    beginRecord(PDF, "exp/layer_"+threshold+".pdf");
    println("exporting layer at: " + threshold);
  }

  noFill();
  while (threshold < 255) {
    finder.setThreshold(threshold);
    // Use the Channels library to extract
    // the hue channel as an int array
    int[] pix = Channels.hue(img.pixels);
    // find the isolines in the hue pixels
    finder.find(pix);
    for (int k = 0; k < finder.getNumContours (); k++) {

      // get each contour as an array of PVectors
      // so we can work with the individual points
      PVector[] points = finder.getContourPoints(k);

      // draw a shape for each contour
      beginShape();
      for (int i = 0; i < points.length; i++) {
        PVector p = points[i];
        // add a vertex to the shape corresponding to
        // each PVector in the the contour
        vertex(p.x, p.y);
      }
      // close the shape
      endShape(CLOSE);
    }
    threshold += layerResolution;
  }

  if (exporting) {
    // stop drawing to the PDF file
    //endRecord();
    // if we're under  255, we still
    // have more layers to go,
    // so increase the threshold and go again
    // otherwise stop exporting
    if (threshold < 255) {
      threshold += layerResolution;
    } else {
      exporting = false;
      endRecord();
      println("exporting complete");
    }
  }

  text("threshold: " + threshold, width-150, 20);
}

// when they hit the spacebar
// start exporting at threshold of 0
void keyPressed() {
  if (key == ' ') {
    println("exporting layers");
    threshold = 0;
    exporting = true;
  }
}

