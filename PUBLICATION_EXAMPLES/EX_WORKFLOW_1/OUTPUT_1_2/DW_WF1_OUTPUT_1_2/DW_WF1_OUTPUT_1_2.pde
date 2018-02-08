// RENDER A RADIAL-COLUMN-LIKE CHART OF THE DATA

Table data;
PGraphics graph;

int rowLight = 4;

void setup() {
  size(800, 800);
  // load the data into a table
  data = loadTable("GPSLOG00.csv");
  println(data.getRowCount());
  // make the chart as long as number of data rows
  graph = createGraphics(800, 800);
  graph.beginDraw();
  graph.background(0);
  
  graph.stroke(255);
  for (int i=0; i<data.getRowCount (); i++) {
    // get the light data
    float d = data.getFloat(i, rowLight);
    // calculate angle based on number of data points
    float a = radians(float(i)/data.getRowCount()*360);
    // calculate position of line
    float x = width/2 + cos(a)*200;
    float y = height/2 + sin(a)*200;
    // translate to correct position
    graph.pushMatrix();
    graph.translate(x, y);
    graph.rotate(a);
    // for the first data point make a red marker to show where the data plot starts
    if(i==0) {
      graph.stroke(255,0,0);
      graph.line(0,0,-20,0);
      graph.stroke(255);
    }
    // draw a line according to the data
    graph.line(0, 0, map(d, 0, 255, 0, width/2), 0);
    graph.popMatrix();
  }
  graph.endDraw();
}

void draw() {
  background(255);
  // render the chart
  image(graph, 0, 0);
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    // export the chart as a tiff to print
    graph.save("chart.tiff");
  }
}

