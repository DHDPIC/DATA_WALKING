// analyse image for amount of organic green
// not perfect but a start!
// run through all files in data folder

import java.io.File;

PImage src;
PImage out;
PImage out2;
PImage out3;
// track accumulated pixels
int total=0;

void setup() {
  size(1542, 2046); //make a size to accommodate your image
  // load files
  File dir = new File( dataPath("JPEG") );
  String[] list = dir.list();
  if (list == null) {
    println("Folder does not exist or cannot be accessed.");
  } else {
    println(list);
  }
  // set to HSB, easier to work with tones
  colorMode(HSB, 360, 100, 100);
  background(0, 0, 100);
  // make things half size for composite images
  scale(0.5);
  // process all images in folder
  for (int i=0; i<list.length; i++) {
    String name = list[i];
    if (name.charAt(0) != '.') {
      src = loadImage("JPEG/"+list[i]);
      src.loadPixels();
      out = createImage(1512, 2016, ARGB);
      out2 = createImage(1512, 2016, ARGB);
      analyse(i);
      total = 0;
      // render
      background(0, 0, 100);
      image(src, 20, 20);
      image(out, 1552, 20);
      image(out2, 1552, 2056);
      image(out3, 1532-out3.width, 2056);
      // save: composite of 4 parts, just the organic pixels, square of organic pixels
      name = name.replaceFirst("\\.jpg", "");
      save("output-images/composites/"+ name +"-comp.jpg");
      out.save("output-images/isolated/"+ name +"-isolated.png");
      out3.save("output-images/boxes/"+ name +"-box.jpg");
    }
  }
  // draw isn't used
  noLoop();
  exit();
}

void draw() {
  
}

void analyse(int id) {
  // analyse pictures for organic toned green pixels
  println(id + " start analysis...");
  int perc = 0;
  for (int i=0; i<src.pixels.length; i++) {
    int curr = round(float(i)/src.pixels.length*100);
    if(curr >= perc+10) {
      print(perc + "% ");
      perc = curr;
    }
    // get pixel data
    color c = src.pixels[i];
    float h = hue(c);
    float s = saturation(c);
    float b = brightness(c);
    // check if pixel is in organic tone bounds
    if (h>=60 && h<=120 && s>=20 && s<=100 && b>=10 && b<=100) {
      // render pixel to different output images
      out.pixels[i] = c;//color(0); // can set pixels to black or any other colour if desired
      out2.pixels[total] = c;
      total++;
    }
  }
  // create image with square dimensions of total number of organic green pixels
  int sq = floor(sqrt(total));
  out3 = createImage(sq, sq, ARGB);
  // deposit pixels from out2 to out3
  for (int i=0; i<sq*sq; i++) {
    color c = out2.pixels[i];
    //out3.set(x, y, c);
    out3.pixels[i] = c;
  }
  println("..." + id + " finished analysis.");
}
