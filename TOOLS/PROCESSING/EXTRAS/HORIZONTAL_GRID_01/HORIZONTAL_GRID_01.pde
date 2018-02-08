//
import processing.pdf.*;

PImage img;
PGraphics pg;

int gsize = 50;

void setup() {
  size(200,200);
  //
  img = loadImage("ppm-co2-fr-0794.tiff");
  pg = createGraphics(img.width,img.height, PDF, "co2-5-50.pdf");
  pg.beginDraw();
  pg.background(255);
  pg.fill(0);
  analyse();
  pg.dispose();
  pg.endDraw();
  //
  //pg.save("blah.jpg");
  
}

void draw() {
}

void analyse() {
  //
  img.loadPixels();
  //
  pg.noStroke();
  for(int gy=0; gy<img.height; gy+=gsize) {
    for(int gx=0; gx<img.width; gx+= gsize) {
      int pTotal = 0;
      int vTotal = 0;
      for(int y=gy; y<gy+gsize; y++) {
        for(int x=gx; x<gx+gsize; x++) {
          color c = img.get(x,y);
          vTotal += brightness(c);
          pTotal++;
        }
      }
      //
      vTotal/=pTotal;
      
      // make a filled rect
      //pg.fill(vTotal);
      //pg.rect(gx,gy,gsize,gsize);
      
      // make lines
      pg.stroke(0);
      pg.strokeWeight( max(map(vTotal,0,255,0,5),0) );
      int lines = 4;
      // pg.strokeWeight(random(20));
      for(int i=0; i<lines; i++) {
        pg.line(gx,gy+(i*gsize/lines),gx+gsize,gy+(i*gsize/lines));
      }
      
      // add text
      /*String s = str(vTotal);
      pg.textSize(6);
      pg.textAlign(CENTER,CENTER);
      pg.text(s,gx,gy, gsize,gsize);
      */
    }
  }
  
}
