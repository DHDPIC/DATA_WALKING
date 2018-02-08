// heatmap

PVector[] points;
float[] values;

Heatmap h;

void setup() {
  size(1200,1200);
  points = new PVector[100];
  values = new float[100];
  for(int i=0; i<points.length; i++) {
    PVector v = new PVector(random(width), random(height));
    points[i] = v;
    float f = random(255);
    values[i] = f;
  }
  h = new Heatmap(points, values);
  h.power = 2;
  h.generate();
  noStroke();
}

void draw() {
  for(int i=0; i<points.length; i++) {
    fill(values[i]);
    ellipse(points[i].x, points[i].y, 10,10);
  }
  h.render();
}