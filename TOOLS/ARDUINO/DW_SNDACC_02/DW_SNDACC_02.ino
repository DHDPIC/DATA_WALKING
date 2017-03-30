#include <SPI.h>
#include <Adafruit_GPS.h>
#include <SoftwareSerial.h>
#include <SD.h>
#include <avr/sleep.h>

// USING TWO ARDUINOS WITH TX RX COMMS TO GET PARTICLES DATA

// Ladyada's logger modified by Bill Greiman to use the SdFat library
//
// This code shows how to listen to the GPS module in an interrupt
// which allows the program to have more 'freedom' - just parse
// when a new NMEA sentence is available! Then access data when
// desired.
//
// Tested and works great with the Adafruit Ultimate GPS Shield
// using MTK33x9 chipset
//    ------> http://www.adafruit.com/products/
// Pick one up today at the Adafruit electronics shop 
// and help support open source hardware & software! -ada

SoftwareSerial mySerial(8, 7);
Adafruit_GPS GPS(&mySerial);

// Set GPSECHO to 'false' to turn off echoing the GPS data to the Serial console
// Set to 'true' if you want to debug and listen to the raw GPS sentences
#define GPSECHO  false
/* set to true to only log to SD when GPS has a fix, for debugging, keep it false */
#define LOG_FIXONLY false 

// this keeps track of whether we're using the interrupt
// off by default!
boolean usingInterrupt = false;
void useInterrupt(boolean); // Func prototype keeps Arduino 0023 happy

// Set the pins used
#define chipSelect 10
#define ledPin 13

File logfile;


int sound = 10;
float soundAcc = 0;
int soundInc = 0;
int soundPek = 0;

// read a Hex value and return the decimal equivalent
uint8_t parseHex(char c) {
  if (c < '0')
    return 0;
  if (c <= '9')
    return c - '0';
  if (c < 'A')
    return 0;
  if (c <= 'F')
    return (c - 'A')+10;
}

// blink out an error code
void error(uint8_t errno) {
/*
  if (SD.errorCode()) {
    putstring("SD error: ");
    Serial.print(card.errorCode(), HEX);
    Serial.print(',');
    Serial.println(card.errorData(), HEX);
  }
  */
  while(1) {
    uint8_t i;
    for (i=0; i<errno; i++) {
      digitalWrite(ledPin, HIGH);
      delay(100);
      digitalWrite(ledPin, LOW);
      delay(100);
    }
    for (i=errno; i<10; i++) {
      delay(200);
    }
  }
}

void setup() {
  // for Leonardos, if you want to debug SD issues, uncomment this line
  // to see serial output
  //while (!Serial);
  
  // connect at 115200 so we can read the GPS fast enough and echo without dropping chars
  // also spit it out
  Serial.begin(115200);
  //Serial.println("\r\nUltimate GPSlogger Shield");
  Serial.println("\r\nGPShield");
  pinMode(ledPin, OUTPUT);

  // make sure that the default chip select pin is set to
  // output, even if you don't use it:
  pinMode(10, OUTPUT);
  
  
  // see if the card is present and can be initialized:
//  if (!SD.begin(chipSelect, 11, 12, 13)) {
    if (!SD.begin(chipSelect)) {      // if you're using an UNO, you can use this line instead
    //Serial.println("Card init. failed!");
    Serial.println("CF");
    error(2);
  }
  char filename[15];
  strcpy(filename, "GPSLOG00.TXT");
  for (uint8_t i = 0; i < 100; i++) {
    filename[6] = '0' + i/10;
    filename[7] = '0' + i%10;
    // create if does not exist, do not open existing, write, sync after write
    if (! SD.exists(filename)) {
      break;
    }
  }

  logfile = SD.open(filename, FILE_WRITE);
  if( ! logfile ) {
    Serial.print("fail "); Serial.println(filename);
    error(3);
  }
  Serial.print("write "); Serial.println(filename);
  
  // connect to the GPS at the desired rate
  GPS.begin(9600);

  // uncomment this line to turn on RMC (recommended minimum) and GGA (fix data) including altitude
  GPS.sendCommand(PMTK_SET_NMEA_OUTPUT_RMCGGA);
  // uncomment this line to turn on only the "minimum recommended" data
//GPS.sendCommand(PMTK_SET_NMEA_OUTPUT_RMCONLY);
  // For logging data, we don't suggest using anything but either RMC only or RMC+GGA
  // to keep the log files at a reasonable size
  // Set the update rate
  GPS.sendCommand(PMTK_SET_NMEA_UPDATE_1HZ);   // 1 or 5 Hz update rate

  // Turn off updates on antenna status, if the firmware permits it
  GPS.sendCommand(PGCMD_NOANTENNA);
  

  // the nice thing about this code is you can have a timer0 interrupt go off
  // every 1 millisecond, and read data from the GPS for you. that makes the
  // loop code a heck of a lot easier!
  useInterrupt(true);
  Serial.println("go");

}

void loop() {
  
  // get values
  int n = analogRead(3);
  n  = abs(n - 512 - 0); // Center on zero
  n   = (n <= 10) ? 0 : (n - 10);             // Remove noise/hum
  sound = ((sound * 7) + n) >> 3;    // "Dampened" reading (else looks twitchy)
  soundAcc += abs(sound);
  soundInc++;
  soundPek = max(soundPek, sound);
  
  Serial.println(sound);

  // if a sentence is received, we can check the checksum, parse it...
  if (GPS.newNMEAreceived()) {
    // a tricky thing here is if we print the NMEA sentence, or data
    // we end up not listening and catching other sentences! 
    // so be very wary if using OUTPUT_ALLDATA and trying to print out data
    //Serial.println(GPS.lastNMEA());   // this also sets the newNMEAreceived() flag to false
        
    if (!GPS.parse(GPS.lastNMEA()))   // this also sets the newNMEAreceived() flag to false
      return;  // we can fail to parse a sentence in which case we should just wait for another
    
    // Sentence parsed! 
    //Serial.println("OK");
    if (LOG_FIXONLY && !GPS.fix) {
        Serial.print("FF");
        return;
    }

    // Rad. lets log it!
    //Serial.println("log");
    
    // my stuff!
    float lat = GPS.latitudeDegrees;
    float lon = GPS.longitudeDegrees;
    
    int hour = GPS.hour; //Serial.print(':');
    int mins = GPS.minute; //Serial.print(':');
    int secs = GPS.seconds; //Serial.print('.');
    
    int day = GPS.day; //Serial.print('/');
    int month = GPS.month; //Serial.print("/20");
    int year = GPS.year;
    
    //Serial.println(day);
    
    soundAcc /= soundInc;
    
    char *stringptr = GPS.lastNMEA();
    uint8_t stringsize = strlen(stringptr) - 1; //subtract 2 to eliminate <cr>
    //if (stringsize != logfile.write((uint8_t *)stringptr, stringsize))    //write the string to the SD file
      //error(4);
    //logfile.print(",");
    logfile.print(lat,10); logfile.print(","); logfile.print(lon,10); logfile.print(",");
    logfile.print(hour); logfile.print(":"); logfile.print(mins); logfile.print(":"); logfile.print(secs);logfile.print(",");
    logfile.print(day); logfile.print("/"); logfile.print(month); logfile.print("/20"); logfile.print(year); logfile.print(","); 
    //logfile.print(t,2);logfile.print(","); logfile.println(h,2); //append humidity and temp
    logfile.print(sound); //append sound
    logfile.print(",");
    logfile.print(soundAcc); //append sound
    logfile.print(",");
    logfile.print(soundPek); //append sound
    logfile.println("");
    if (strstr(stringptr, "RMC") || strstr(stringptr, "GGA"))   logfile.flush();
    //
    // reset sound vars
    soundAcc = 0.0;
    soundInc = 0;
    soundPek = 0;
  }
}



// Interrupt is called once a millisecond, looks for any new GPS data, and stores it
SIGNAL(TIMER0_COMPA_vect) {
  char c = GPS.read();
  // if you want to debug, this is a good time to do it!
#ifdef UDR0
  if (GPSECHO)
  #ifdef UDR0
    if (c) UDR0 = c;  
    // writing direct to UDR0 is much much faster than Serial.print 
    // but only one character can be written at a time.
  #else
    Serial.write(c);
  #endif
#endif
}

void useInterrupt(boolean v) {
  if (v) {
    // Timer0 is already used for millis() - we'll just interrupt somewhere
    // in the middle and call the "Compare A" function above
    OCR0A = 0xAF;
    TIMSK0 |= _BV(OCIE0A);
    usingInterrupt = true;
  } else {
    // do not call the interrupt function COMPA anymore
    TIMSK0 &= ~_BV(OCIE0A);
    usingInterrupt = false;
  }
}

/* End code */
