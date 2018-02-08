// RENDER A CHART OF THE DATA

Table data;
PGraphics graph;

int rowLight = 4;


void setup() {
  size(1280,800);
  // load the data into a table
  data = loadTable("GPSLOG00.csv", "header");
  println(data.getRowCount());
  // make the chart as long as number of data rows
  graph = createGraphics(data.getRowCount(), 800);
  graph.beginDraw();
  graph.background(0);
  graph.stroke(255);
  for(int i=0; i<data.getRowCount(); i++) {
    // get the light data
    float d = data.getFloat(i, rowLight);
    graph.line(i,0,i,map(d,0,255,0,800)); 
  }
  graph.endDraw();
}

void draw() {
  background(0);
  // render the chart
  // scroll it horizontally according to mouse position.
  if(graph.width > width) {
    image(graph,(float(mouseX)/width*-graph.width)+(width*float(mouseX)/width),0);
  } else {
    image(graph,0,0);
  }
}

void keyPressed() {
  if(key == 's' || key == 'S') {
    // export the chart as a tiff to print
    graph.save("chart.tiff");
  }
}
