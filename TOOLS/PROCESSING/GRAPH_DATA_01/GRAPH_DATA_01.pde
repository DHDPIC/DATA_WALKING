//

Table data;
PGraphics graph;

int rowLight = 17;
int rowSound = 18;
int rowSndAvg = 19;
int rowSndPek = 20;
int rowTemp = 21;

void setup() {
  //
  size(1280,800);
  //
  data = loadTable("20160127.csv");
  println(data.getRowCount());
  //
  graph = createGraphics(data.getRowCount(), 800);
  //
  graph.beginDraw();
  for(int i=0; i<data.getRowCount(); i++) {
    
    float d = data.getFloat(i, rowSndPek);
    println(d);
    
    graph.line(i,0,i,map(d,0,512,0,800));
    
  }
  graph.endDraw();
  image(graph,float(mouseX)/width*-graph.width,0);
}

void draw() {
  //
  background(255);
  image(graph,float(mouseX)/width*-graph.width,0);
}