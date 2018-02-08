//

Table data;
PGraphics graph;

int rowLight = 17;
int rowSound = 18;
int rowSndAvg = 19;
int rowSndPek = 20;
int rowTemp = 21;

// new data scheme
int dust = 10;
int gas = 9;
int soundav = 6;
int soundpk = 7;
int people = 9;

void setup() {
  //
  size(1280,800);
  //
  data = loadTable("20160825-reg-sensors.csv");
  println(data.getRowCount());
  //
  graph = createGraphics(data.getRowCount(), 800);
  //
  graph.beginDraw();
  for(int i=0; i<data.getRowCount(); i++) {
    
    float d = data.getFloat(i, soundav);
    println(d);
    
    graph.line(i,0,i,map(d,0,255,0,800));
    
  }
  graph.endDraw();
  image(graph,float(mouseX)/width*-graph.width,0);
}

void draw() {
  //
  background(255);
  image(graph,(float(mouseX)/width*-graph.width)+(width*float(mouseX)/width),0);
}