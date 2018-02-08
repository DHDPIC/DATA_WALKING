# EXAMPLE WORKFLOW 3:
# SOUND DATA & HEAT MAP
This workflow shows you how to collect sound data using an Electret MAX4466 microphone from [Adafruit](https://www.adafruit.com/product/1063) and then create a heatmap of the data in Processing using a Heatmap class I have made. The sound data could be swapped for any data you are interested in. A heatmap, or height map, can be used in 3D graphics for displacement mapping/bump mapping; modifying a three dimensional form based on the image.

### INPUT
Input_1 is a basic Arduino program to capture the GPS data and a microphone inputs into analog an pin. Check the wiring diagram on how to build the circuit.

###OUTPUT
Output_1 plots all the data points from the microphone. Make sure you have the Unfolding Maps library downloaded and installed in Processing, available using the Sketch>Import Library>Add Library... menu function. Press 'r' to render a .tiff of the canvas output. Press 'h' to create and render the heat map. This can be a slow process with large datasets and a large output canvas. Inside the Processing GUI console area a % readout should show you the progress of creating the heat map. Once the heat map is shown in the output canvas, then press 'r' again to save a .tiff of this. The heat map is rendered in grayscale so it can be used as a height map for 3D manipulation. You can modify the Heatmap class to output colours or use an application like Photoshop to map a colour gradient to the grayscale values.

From the heat map, we can use it as a height map in Blender (a free 3D modelling software) to generate a 3D version of the heat map to 3D print, mill, or use on-screen in some way.


###EXTENDING
We could increase fidelity of our data by not only measuring the amplitude of the sound coming in, but by running an FFT (fast-fourier transform) on the incoming sounds and extract data on the different frequency bands. Are there more high pitched sounds or deep bass sounds?

We could take it one step further and use full audio recordings, not just looking at amplitude and fequency spectrum but the types of sounds, what produces them, and what meaning they have.

Heat maps are widely employed in spatial data visualisations of scalar data, so could be used to display different aspects you want to collect and examine. We can use heat maps and their data to build isoline maps. Choropleth maps are a related visual form to consider. 

Finally heat maps can be rendered in everything from flat colour artwork through to data sculptures, animations, and beyond... what materials and dimensions relate to the data you have gathered?

Project website: [http://datawalking.com/](http://datawalking.com/)