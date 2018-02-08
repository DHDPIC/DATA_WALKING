class Heatmap {
  
  int id;
  PImage img;
  
  PVector[] points;
  float[] values;
  
  float power;
  float maxdist;
  
  Heatmap(PVector[] ps, float[] vs) {
    id = 0;
    power = 3;
    maxdist = sqrt((width*width)+(height*height)); 
    img = createImage(width,height,ARGB);
    for(int i=0;i<img.pixels.length;i++) {
      img.pixels[i] = color(random(255),random(255),random(255));
    }
    //
    this.points = ps;
    this.values = vs;
  }
  
  void update() {
    println("update");
  }
  
  void render() {
    image(img,0,0);
  }
  
  void render(float x,float y) {
    image(img,x,y);
  }
  
  void generate() {
    int starttime = millis();
    
    for(int y=0; y<img.height; y++) {
      
      println("render progress = " + int(1000*(float(y)/height))/10.0 + "%");
      println((millis()-starttime)/60000.0);
      
      for(int x=0; x<img.width; x++) {
        
        float tv = 0;
        float t = 0;
        
        for(int i=0; i<points.length; i++) {
          PVector p = points[i];
          float d = maxdist / pow(max(dist(x,y,p.x,p.y),1),power);
          tv += values[i] * d;
          t += d;
        }
        
        tv /= t;
        color c = color(tv);
        img.set(x,y,c);
        
      }
    }
    
  }
}
