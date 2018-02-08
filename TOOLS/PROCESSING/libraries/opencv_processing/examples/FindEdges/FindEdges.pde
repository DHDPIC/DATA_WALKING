import gab.opencv.*;

OpenCV opencv;
PImage src, canny, scharr, sobel;

void setup() {
  src = loadImage("test.jpg");
  size(src.width, src.height);
  
  opencv = new OpenCV(this, src);
  opencv.findCannyEdges(20,75);
  canny = opencv.getSnapshot();
  
  opencv.loadImage(src);
  opencv.findScharrEdges(OpenCV.HORIZONTAL);
  scharr = opencv.getSnapshot();
  
  opencv.loadImage(src);
  opencv.findSobelEdges(1,0);
  sobel = opencv.getSnapshot();
}


void draw() {
  pushMatrix();
  scale(0.5);
  image(src, 0, 0);
  image(canny, src.width, 0);
  image(scharr, 0, src.height);
  image(sobel, src.width, src.height);
  popMatrix();

  text("Source", 10, 25); 
  text("Canny", src.width/2 + 10, 25); 
  text("Scharr", 10, src.height/2 + 25); 
  text("Sobel", src.width/2 + 10, src.height/2 + 25);
}

