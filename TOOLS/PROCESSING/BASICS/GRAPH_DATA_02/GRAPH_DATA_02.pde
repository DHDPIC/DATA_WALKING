// GRAPH FOR SIMPLE SINGLE DATA INPUT

Table data; // to store data
PGraphics graph; // to render graph to
int dataColumn = 4; // column data is stored in

void setup() {
  size(1280, 800);
  data = loadTable("20160923-reg-sensors.csv", "header"); // load the data from csv file
  println(data.getRowCount());
  graph = createGraphics(data.getRowCount(), height); // create graphics to size of data
  graph.beginDraw(); // start drawing
  for (int i=0; i<data.getRowCount (); i++) { // loop through data
    float d = data.getFloat(i, dataColumn); // get data value
    println(d); // print to console so we can see values
    float m = map(d, 0, 1024, 0, height); // translate value from one range to another
    graph.line(i, 0, i, m); //draw a line of data
  }
  graph.endDraw(); // end drawing to graph
  background(255);
  image(graph, float(mouseX)/width*-graph.width, 0); // render graph
}

void draw() {
  if (graph.width > width) { // if the graph is too big to fit then allow mouse interaction
    background(255);
    // draw graph so mouse x position scrolls the graph
    image(graph, (float(mouseX)/width*-graph.width)+(width*float(mouseX)/width), 0);
  }
}

