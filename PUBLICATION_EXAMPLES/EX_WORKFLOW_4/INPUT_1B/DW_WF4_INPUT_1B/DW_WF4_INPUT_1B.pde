// to be used with DW_GPS_ONLY_01 arduino sketch to send in gps location

import processing.serial.*;
import processing.video.*;

Serial myPort;
String val = "test";
String[] loc = {"",""};

Capture cam;
int x = 0;

PrintWriter data;

int mil,pmil,psecond,ssecond,pmin;

void setup() {
  size(320,180);
  // set up serial comm
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[1], 115200);
  // setup camera
  String[] cameras = Capture.list();
  cam = new Capture(this,width,height);
  cam.start();
  // setup data recorder
  data = createWriter("data"+timestamp()+".csv");
  // set time vars values
  mil = 0;
  pmil = 0;
  pmin = minute();
  ssecond = second();
}

void draw() {
  // if data is available
  if ( myPort.available() > 0) {  
    // read until '|' char and store it in val
    val = myPort.readStringUntil(124);      
  }
  if (val != null) {
    // store 
    loc = splitTokens(val, ",|");
  }
  // get camera image
  if (cam.available() == true) {
    cam.read();
    cam.loadPixels();
  }
  // get 1px slit from centre of image
  PImage line = cam.get(width/2,0,1,height);
  image(line,x,0);
  x++;
  // if rendering canvas filled, save and start again from screen left edge
  if(x>width) {
    save("grabs/"+timestamp()+".tiff");
    x=0;
  }
  // check to see GPS data has two data points (lat,lon)
  if(loc.length >= 2) {
    // write data to file
    data.print(timestamp()+",");
    data.print(loc[0]+","+loc[1]);
    line.loadPixels();
    for(int i=0; i<line.pixels.length; i++) {
      String h = hex(line.pixels[i],6);
      String d = ",#"+h;
      data.print(d);
    }
    data.println();
    // uncomment the below line to export 1px image slit
    //line.save("lines/"+timestamp()+".jpg");
  }
  // timing vars to get current milliseconds
  mil = millis() - pmil;
  if(second() != psecond) {
    pmil = millis();
    psecond = second();
  }
}

// return the current time
String timestamp() {
  return year()+"_"+month()+"_"+day()+"_"+hour()+"_"+minute()+"_"+second()+"_"+mil;
}
