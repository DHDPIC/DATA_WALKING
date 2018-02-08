# EXAMPLE WORKFLOW 1:
# BASIC DATA GATHERING & CHARTING
This workflow shows you how to make a basic circuit to collect light data with a photoresistor connected to an arduino with Adafruit GPS Shield. Then the data is used in Processing to create a chart of that data.

### INPUT
Input_1 is a basic Arduino program to capture the GPS data and a sensor input into analog pin. In this example we are gathering light data using a photoresistor. Photoresistors are very cheap and often included with an Arduino starter kit. Check the wiring diagram on how to connect the photoresistor to the Arduino. 

The sensor data (as well as time and location data) is written to the GPS Shield SD card as a .txt file. This file can be saved or converted to .csv file by using a text editor (such as Sublime Text) or just by changing the file extension to .csv as the data points are already separated by commas.

###OUTPUT
Output_1_1 renders all the data points (in this case light, but other data could be used) as single pixel lines from the top of the screen down, akin to an area chart. It is extremely basic, and lacking things like axis and key but it should get you started. The data values are mapped from a range of 0-255, to 0-height of the sketch. The graphic is likely longer than the output canvas so the chart is made as large as necessary to show all data points. By moving the mouse across the canvas, the chart scrolls horizontally. Press 's' to render a .tiff of the chart.

Output_1_2 renders all the data points (in this case light, but other data could be used) in a circular fashion, like a radial column chart. The data values are mapped from a range of 0-255, to 0-height of the sketch. in Processing an angle of 0° is facing off to the right at 3pm, rather than upwards at 12pm; a red marker is added to show where the first data point is plotted, going clockwise. Press 's' to render a .tiff of the chart.

###EXTENDING
There are a huge range of sensors and creative uses of sensors to measure the world around you. Make sure you connect them to the arduino correctly and take note of the range they return data in, eg. analog 0–1024, digital 0–255, or something else. We use the map() function to convert the data value into a useable range. You might want to adjust the mapping range based on the values you record. Some people who work with data scientists disagree with this and believe your axis should always start at 0, but there are many use cases where this may not be the case. Adjusting the range allows you to focus on and magnify subtle but important changes that might be too difficult to visually perceive otherwise. Ultimately you have to judge (and test) that your chart communicates effectively and is not misleading.

How could you tie the circular chart to the time a datapoint was captured? Could you make a three-dimensional spiral? How can we use small multiples to compare multiple walks or datasets?

Project website: [http://datawalking.com/](http://datawalking.com/)