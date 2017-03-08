# DATA WALKING
A research project exploring environmental data gathering & data visualisation

Project website: [http://datawalking.com/](http://datawalking.com/)

### ABOUT:
The aim of the Data Walking research project is to collect environmental data while walking around North Greenwich, to build a rich picture of that area over time. There was one walk per month for the whole of 2016 and open to anyone who wanted to join and explore the area, ideas on data gathering techniques, and the field of data visualisation.

Before each walk there was a session to help make different data gathering devices including sensors on micro controllers, smart phones, and hand recorded notes.

The data gathered on each walk will then be used to create maps, charts, data experiences, or artistic works by participants to represent the area and the process of the project. Data will be shared and made publicly available here on github.

Contributed work will feature on the website, and there is a facebook group for general notifications on the project, please join [here](https://www.facebook.com/groups/1044556812269511/)

A publication is now in the works featuring writing on the project, technical advice on making data gathering devices and visualisations, and contributed visualisations and graphic responses from students, staff, and established designers and studios who have visited the Peninsula to give talks or run workshops at Ravensbourne.

Following the completion of the book there will be a launch and exhibition event!

Data Walking is a research project by [David Hunter](http://davidhunterdesign.com), funded by the [Ravensbourne Research Office](https://www.ravensbourne.ac.uk/research/).


---

### DATA:
All the data and photographs are gathered and shared freely here on github.

##### Download Everything
* You can download the whole lot to your machine using the _'clone or download'_ button and _'download the zip'_.

##### Individual Files
* If you want an individual file, navigate to the file, press the _'raw'_ button and you can save the page in your browser (in this case most likely a csv file).

##### All Sensor Data
* Navigate to _WALKS>ALL-DATA_ and there are three files accounting for: 

   Merged environmental data (light, sound, temperature)

   Merged air quality (MQ135, MQ2, dust sensor)

   Merged people (number of people counted in a specific location along the walk) 

##### All Photos
* I have created a zip of all photos, they are in one folder with 3 letter month prefix and original file name intact eg. MAR-IMG_1348.JPG.
* There is also a csv file listing all the images and their time and GPS latitude & longitude files data.
* If you would like this zip (3GB) then please message me and I can trasfer you the file or alternatively download the whole github repository as detailed above where photos are included. I will try to post this onto a google drive asap.

Please use the data to create visualisations, maps, artistic responses, and even tools in the creation of more creative outcomes using data. Let us know what you come up with and we can try to include it in the project publication!


---

### VALUE RANGES
Different sensors collect data within different value ranges. Most of the data is the raw analog signal coming from the sensor and has a value between 0-1024. 

Other sensors have different value ranges;  temperature data is in degrees celsius;  the dust sensor reports in particle concentration with a range of 0-8000. The values picked up by the sensor are at times much higher than this; it is noted that this sensor is not really suitable for mobile data gathering but perhaps something indicitive can be taken from the data.

People are counted in terms of number of people existing in a certain place at a certain time. People who qualified to be counted were determined that I should cross their path or be close enough to be able to interact with them, such as calling out across a road so within a few metres. People were not double/multiple counted.

##### Value ranges for different sensors

* Light: levels raw signal low=1024 high=0
* Sound: amplitude raw signal low=0 high=1024
* Temperature: degrees celcius 
* MQ135: gas level raw signal low=0 high=1024
* MQ2: gas level raw signal low=0 high=1024
* Dust: particle concentration raw signal low=0 high=8000
* People: number of people in location at that time

For sound and gas values in each csv file there is the exact reading taken at the time, an average of the values between readings (readings are taken approximately once per second) and a peak value for the maximum value recorded between readings.


---

### SENSORS
We have used a variety of sensors to collect data.

* Basic LDR (light dependent resistor) to measure light levels as found in an [Oomlout ARDX kit](http://www.oomlout.com/a/products/ardx/) and similar kits.
* [Adafruit Electret MAX4466 microphone](https://www.adafruit.com/product/1063) to gather sound amplitude data.
* Basic temperature sensor as found in an [Oomlout ARDX kit](http://www.oomlout.com/a/products/ardx/) and similar kits.
* [MQ135 gas sensor](http://playground.arduino.cc/Main/MQGasSensors), which is sensitive to air quality and Benzene, Alcohol, smoke.
* [MQ2 gas sensor](http://playground.arduino.cc/Main/MQGasSensors), which is sensitive to combustible gases, Methane, Butane, LPG, smoke.
* [Shinyei Model PPD42NS Dust Sensor](http://wiki.seeed.cc/Grove-Dust_Sensor/).
* [Adafruit GPS shield](https://www.adafruit.com/product/1272)
* Photographs were taken on an iPhone 4S and iPhone 6


---

### TOOLS
There is a tools folder which contains code for [Arduino](https://www.arduino.cc/) and [Processing](https://www.processing.org/) sketches so you can gather your own data and visualise it.

With the Arduino sketches there are different ones for different sensors. Be sure to check everything is wired correctly so the correct data is written to the SD card and please note not all the sketches write data in the order that appears in github. Libraries for using the Adafruit GPS and SD shield are included and necessary.

We are using version 2 of Processing as we make use of the [Unfolding Maps](http://unfoldingmaps.org/) library by Til Nagel. This library is heavily used to map the data using the GPS latitude and longitude data. There are example sketches to map all the data collected. Feel free to use and adapt these scripts to create your own outcomes or just simply to acquaint yourself with the data. There is also a sketch to graph data too, animate the routes taken, render data to a pdf, and some special experiments like rendering Gieger counter data or working with a custom slitscanning application.

There is also a text file containing the command to take a folder of images and extract the time, date, and GPS data and create a csv file of the data. This is done using [ExifTool](http://www.sno.phy.queensu.ca/~phil/exiftool/) by Phil Harvey, which you will need to download and install.

Of course you are free to use whatever tools you are comfortable or keen on experimenting with to gather and visualise data!


---

### COMPLETED WALKS:

1. ~~27/01/2016~~
2. ~~24/02/2016~~
3. ~~23/03/2016~~
4. ~~20/04/2016~~
5. ~~18/05/2016~~
6. ~~15/06/2016~~
7. ~~28/07/2016~~
8. ~~25/08/2016~~
9. ~~22/09/2016~~
10. ~~20/10/2016~~
11. ~~18/11/2016~~
12. ~~08/12/2016~~