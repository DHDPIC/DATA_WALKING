# EXAMPLE WORKFLOW 4:
# SLIT-SCAN
This workflow shows you how to capture a slit-scan where each strip of the slit-scan is GPS tagged. It needs two sketches one for Arduino to get the GPS data, and Processing sketch to use the webcam as a slit-scan. It also has a Processing sketch to plot that slit-scan.

### INPUT
Input_1A is a basic Arduino program to capture the GPS data and send it over serial communication (keep the Arduino plugged in to the laptop via a usb cable) to the Processing sketch. No circuit diagram is needed, just plug the shield onto the Arduino, plug the Arduino into the laptop, load the code, and are ready to go.

Input_1B is a Processing sketch that needs the input from the Arduino file, and also a webcam to work properly. It exports a .csv file with the GPS, date & time data, and RGB hexadecimal colour values for the 'slit' so each scan can be reconstructed. It is possible to export each slit as a 1 pixel wide image (but I found this fiddly to use with github, creating thousands of jpg files!) and it is commented out in the code. There are probably other methods of storing each slit-scan, let me know your methods.

Note that because the GPS is only updated every second you get lots of slits with the same location. It would be possible (but beyond this quick test) to afterwards change those to interpolated values between GPS points, or to change the program and do that on the fly.

The size of the slit depends on the height of the sketch. The larger the size, the greater the volume of data and larger storage required. I have kept it fairly small (180px high) but larger is quite possible, and leave it to you to experiment with and judge.

The Processing sketch also renders the slit-scan to its canvas and an image when the canvas fills to allow it to reset. You could stitch these images together in another program (like photoshop) and rebuild the whole slit-scan as one seemless image.

Notice how the image is quite jerky, this is due to your natural cadence when walking; perhaps try putting it on a bicycle to smooth it out.

###OUTPUT
Output_1_1 renders a map and plots points of the route walked with the slit-scan. You can vary the detail it renders by the number of points. The more points the more sluggish the performance, but greater detail. Press 'p' to plot the slit-scans, and 's' to render a .tiff.

Output_1_2 takes the saved canvas exports from Input_1B and stitches them together to create a very long .png.

###EXTENDING
What other way could the slit-scan be captured? Perhaps using a kinect, or conversly a low tech approach? How can we improve the jerkiness of the image? Use a bicycle or trolley, make a steadicam rig, sense movement with an accelerometer?

How else could we render the data? Could a 3D plane be used and apply a large texture to it? Could the output be mapped allowing a user to virtually move around the slit-scan in three dimensions? How might we make the slit-scan physically exist and using what materials?

Project website: [http://datawalking.com/](http://datawalking.com/)