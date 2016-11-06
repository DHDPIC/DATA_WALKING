// FOR SUPER SIMPLE SINGLE DATA INPUT

Table data;
PGraphics graph;

int dataColumn = 4;

void setup() {
  //
  size(1280, 800);
  //
  data = loadTable("GPS-test-data.csv");
  println(data.getRowCount());
  //
  graph = createGraphics(data.getRowCount(), height);
  //
  graph.beginDraw();
  for (int i=0; i<data.getRowCount (); i++) {

    float d = data.getFloat(i, dataColumn);
    println(d);

    graph.line(i, 0, i, map(d, 0, 1024, 0, height));
  }
  graph.endDraw();
  background(255);
  image(graph, float(mouseX)/width*-graph.width, 0);
}

void draw() {
  if (graph.width > width) {
    background(255);
    image(graph, (float(mouseX)/width*-graph.width)+(width*float(mouseX)/width), 0);
  }
}

