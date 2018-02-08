// dot map based on heat map

size(1000,1000);
background(0);
noStroke();

int gs = 20;

PImage img = loadImage("snd-0-100-exp2016_6_28_9_45_56.tiff");

img.loadPixels();

for(int y=0; y<img.height; y+=gs) {
  for(int x=0; x<img.width; x+=gs) {
    //
    color c = img.get(x,y);
    float b = brightness(c);
    float s = map(b,0,255,0,gs);
    ellipse(x,y,s,s);
    //
  }
}
