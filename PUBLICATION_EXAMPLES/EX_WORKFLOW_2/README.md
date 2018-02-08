# EXAMPLE WORKFLOW 2:
# DATA GATHERING & MAPPING
This workflow builds on Workflow 1 and adds a temperature sensor and push button to the light sensor circuit. The button can be used for counting instances of something. That something might be people, types of objects, or occurrences of a phenomena. Then the data is used in Processing to map the data using the Unfolding Maps Library.

### INPUT
Input_1 is a basic Arduino program to capture the GPS data and sensor inputs into analog and digital pins. In this example we are gathering light data using a photoresistor, temperature sensor, and a push button. All these components are often included with an Arduino starter kit. Check the wiring diagram on how to build it.

The push button data is recorded as the number of presses between readings. If no presses are made a 0 is recorded. For example if you were recording people you walked past, and passed a single person then the button should be pressed once to record 1, and if you passed a couple then the button should be pushed to record 2. This allows to record the amount of 'something' in a location at a time.

The sensor data (as well as time and location data) is written to the GPS Shield SD card as a .txt file. This file can be saved or converted to .csv file by using a text editor (such as Sublime Text) or just by changing the file extension to .csv as the data points are already separted by commas.

###OUTPUT
Output_1 renders all the data points from one of the datasets we are recording on a map. Make sure you have the Unfolding Maps library downloaded and installed in Processing, available using the Sketch>Import Library>Add Library... menu function. Changing the column used can visualise the different datasets.  Press 's' to render the map and data visualisation. Notice it renders the map as a .tiff image, then each data layer as a .pdf. This allows us to visualise datasets on separate layers and use different materials or machines to render different data layers.

It's worth mentioning data literacy at this point. Looking at the data of the test file, the temperature reading seems very high; at the time of the recording the temperature for London was 17°C not 30+°C! Perhaps the sensor is faulty, not connected properly, or not getting enough power? Further to this when mapping the data some appears in the middle of buildings or off the path walked. GPS is only accurate to about 5m, and can be further out when signal is weak or obstructed by large structures. It is necessary to understand that data isn't the absolute truth, have a pinch of salt and common sense approach to whether results seem plausible, and remember double-triple-many-more-times-checking is a worthwhile.


###EXTENDING
Here is another opportunity to experiment with different sensor types and how you use them creatively to measure the world around you.

Counting and being able to tie that count to a specific time and location is a simple but surprising powerful method, and can be used across all observable or perceptible phenomena. Add more buttons to count more things or different categorisations of things such as people dressed for different roles, different vehicle types, different tree species.

Combining datasets in one visualisation affords an almost never ending world of combinations exploring the relationships between datasets, and experimenting with machines, materials and interactions appropriate to communicate the dataset effectively.

How can multilayered visualisations work physically, as three dimensional objects, as tactile experiences, as tangible objects that can be interacted with? What is the potential of LED, projected or on-screen interactives with your data? Where should an outcome be situated?

Project website: [http://datawalking.com/](http://datawalking.com/)