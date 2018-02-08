import gab.opencv.*;

PImage img;
OpenCV opencv;

void setup(){
  img = loadImage("test.jpg");
  size(img.width, img.height);
  opencv = new OpenCV(this, img);  
}

void draw(){
  opencv.loadImage(img);
  opencv.brightness((int)map(mouseX, 0, width, -255, 255));
  image(opencv.getOutput(),0,0);
}

