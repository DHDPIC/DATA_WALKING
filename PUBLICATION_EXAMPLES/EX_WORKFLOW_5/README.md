# EXAMPLE WORKFLOW 5:
# GET GREEN
This workflow uses photos taken on a smartphone and extracts the pixels that are of an organic green colour. This way we can crudely estimage how much foliage and plantlife there is in each picture. The final part of the workflow maps the image locations.

### INPUT
For input use a smartphone or digital camera, or a film camera and scan them. For part 2 output, mapping the photos make sure your smartphone allows the GPS to be used by the camera, such as switching on "location services". Take photos during your walk. Consider how you want to take photos. Bear in mind keeping similar distance/height/angle from a subject if you are trying to measure the size of plants. Maybe use a timer if you are trying to assess how much plantlife is in view at a regular intervals along a walk.

ExifTool (make sure you download and install this from Phil Harvey's [website](https://www.sno.phy.queensu.ca/~phil/exiftool/)) can be used to get the GPS data from the photos. Use Terminal (on Mac OSX) or another UNIX command line application to change the directory [cd command] to the one with the walk photos. Then run this exiftool command:

```exiftool -csv -filename -datetimeoriginal -gpslatitude -gpslongitude -n ./ > data.csv```

Check the data.csv file created in the images directory. It should contain GPS data for those images which can be used to map them. If it doesn't then it is likely that the images failed to record the GPS data; check your phone settings.

###OUTPUT
Output_1_1 takes the photos from the data folder and extracts pixels that fit within a certain range of hue, saturation, and brightness. You may want to tweak these values according to the types of plants that grow in your area and the lighting conditions. The program creates and saves a version of the image with only the green pixels, and then a image with all the green pixels compacted into a square, and a composite of these images to see a comparison.

Similar colour extraction functions can be performed by the OpenCV library, and a number of other programs. But there is merit in writing and exploring our own methods!

Output_1_2 uses the data.csv file created using the photos and Exiftool to map the photo locations in Processing using the Unfolding Maps library.

Output_1_3 adapts Output_1_2 to map the photo locations and render the square boxes of organic green pixels in Processing using the Unfolding Maps library.

###EXTENDING
Photography opens up a world of potential in terms of data extraction and visualisation, and geolocation allows us to easily and accurately situate photos in the world. Computational image analysis is an interesting and evolving field with many powerful tools available in libraries like OpenCV and new abilities emerging from machine learning, all in an effort to extract meaning from images.

The power of photography in data visualisation is covered extensively in the inspiring book PhotoViz by Nicholas Felton.

Project website: [http://datawalking.com/](http://datawalking.com/)