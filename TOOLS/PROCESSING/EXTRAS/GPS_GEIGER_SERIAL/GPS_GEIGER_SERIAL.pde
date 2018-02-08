import processing.serial.*;

Serial myPort;  // Create object from Serial class
Serial myGPSPort;  // Create object from Serial class
String val = "test";
String valGPS = "GPStest";

PrintWriter data;
String startTime;
int mil;
int pmil;
int psecond;

void setup()
{
  printArray(Serial.list());
  // I know that the first port in the serial list on my mac
  // is Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  String portName = Serial.list()[2]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 9600);
  myGPSPort = new Serial(this, Serial.list()[1], 115200);
  //
  startTime = timestamp();
  data = createWriter("data"+startTime+".csv");
}

void draw()
{
  
  if ( myGPSPort.available() > 0) 
  {  // If data is available,
    valGPS = myGPSPort.readStringUntil(124);         // read it and store it in val
    if(valGPS != null) {
      String[] s = split(valGPS,"|");
      //print(s[0]+", ");
      data.print(s[0]+", ");
      //data.flush();
   }
  }
  
  if ( myPort.available() > 0) 
  {  // If data is available,
    val = myPort.readStringUntil('\n');         // read it and store it in val
    if(val != null) {
      //print(val);
      data.print(val);
      //data.flush();
   }
  }
  data.flush();
  
  

  mil = millis() - pmil;
  if (second() != psecond) {
    pmil = millis();
    psecond = second();
  }
}

String timestamp() {
  return year()+"_"+month()+"_"+day()+"_"+hour()+"_"+minute()+"_"+second()+"_"+mil;
}

