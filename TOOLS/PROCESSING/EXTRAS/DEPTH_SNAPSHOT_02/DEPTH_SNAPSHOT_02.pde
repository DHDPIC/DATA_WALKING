import SimpleOpenNI.*;
SimpleOpenNI kinect;

PrintWriter output;

String folder;

Boolean record = false;

PGraphics prgb, pdep;

void setup()
{
  size(1280, 480, P3D);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableRGB();
  kinect.alternativeViewPointDepthToImage();

  // data writer controlled on button
  //folder = timestamp();
  //output = createWriter(folder+"/data/depthscan-"+folder+".csv");
  //
  stroke(255);
  strokeWeight(2);
  prgb = createGraphics(640,480);
  pdep = createGraphics(640,480);
}

void draw()
{
  kinect.update();

  background(0);

  // draw rgb image...
  PImage rgb = kinect.rgbImage();//.get(320,0,1,480);
  prgb.beginDraw();
  prgb.image(rgb, 0, 0);
  prgb.beginDraw();
  // draw depth image
  PImage dep = kinect.depthImage();//.get(320,0,1,480);
  pdep.beginDraw();
  pdep.image(dep, 0, 0);
  pdep.beginDraw();
  // draw depth points...
  PVector[] depthMap = kinect.depthMapRealWorld();
  translate(width*0.5, height*0.5, 500);
  rotateX(radians(180));
  stroke(255,255,0);
  line(0,-height,-500,0,height,-500);
  
  for (int i=0; i<depthMap.length; i+=7) {
    PVector currentPoint = depthMap[i];
    stroke(rgb.pixels[i]);
    point(currentPoint.x, currentPoint.y, currentPoint.z);
    //output.print(distance + ",");
  }
  

  // save data
  if (record) {
    folder = timestamp();
    output = createWriter(folder+"/depthscan-"+folder+".csv");
    output.println("real world depth map");
    for (int i=0; i<depthMap.length; i+=1) {
      PVector cp = depthMap[i];
      output.print(cp.x+"," + cp.y+"," + cp.z+",");
    }
    output.println("");
    output.flush(); // Writes the remaining data to the file
    output.close();
    
    prgb.save(folder+"/rgb-"+folder+".tiff");
    pdep.save(folder+"/dep-"+folder+".tiff");

    record = false;
  }
}

void keyPressed() {
  record = true;
}

String timestamp() {
  return str(year()) + "_" + str(month()) + "_" + str(day()) + "_" + nf(hour(), 2) + "_" + nf(minute(), 2) + "_" + nf(second(), 2);
}

