// make giant image from slitscans

PGraphics pg;

void setup() {
  size(640, 360);
  // set the file to search for images
  File dir = new File( dataPath("grabs2") );
  String[] list = dir.list();

  if (list == null) {
    println("Folder does not exist or cannot be accessed.");
  } else {
    println(list);
  }
  // create a container as long as all the images put end to end
  pg = createGraphics(list.length*640, 360);
  pg.beginDraw();
  int i=0;
  for (int x=0; x<pg.width; x+=640) {
    // load image and draw it
    String url = "data/grabs2/" + list[i];
    PImage img = loadImage(url);
    pg.image(img, x, 0);
    i++;
  }
  pg.endDraw();
  // png only format capable of such large image.
  pg.save("mega4.png"); 
  noLoop();
  exit();
}

void draw() {
  // not using draw
}

