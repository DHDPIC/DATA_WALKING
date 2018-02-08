import isolines.*;
import channels.*;

Isolines finder;
PImage img;
int threshold = 200;

void setup() {
  // load the image and scale
  // the sketch to the image size
  img = loadImage("walkscore.png");
  size(img.width, img.height);
  // initialize an isolines finder based on img dimensions
  finder = new Isolines(this, img.width, img.height);
}

void draw() {
  image(img, 0,0);
  // update the threshold
  finder.setThreshold(threshold);
  // Use the Channels library to extract
  // the hue channel as an int array
  int[] pix = Channels.hue(img.pixels);
  // find the isolines in the hue pixels
  finder.find(pix);

  // draw the contours
  stroke(0);
  for (int k = 0; k < finder.getNumContours(); k++) {
    finder.drawContour(k);
  }
  
  text("threshold: " + threshold, width-150, 20);
}

void keyPressed() {
  if (key == '-') {
    threshold-=5;
    if (threshold < 0) {
      threshold = 0;
    }
  }
  if (key == '=') {
    threshold+=5;
  }
}
