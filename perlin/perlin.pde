
PImage img;
PImage img2;
int zVal = -10000;

void setup() {
  img = loadImage("/Users/jdeboi/Documents/Processing/projects/band/media/images/swirl.png");
  img2 = loadImage("/Users/jdeboi/Documents/Processing/projects/band/media/images/yoda2.png");
  img.loadPixels();
  size(1200, 800, P3D);
  
  gridSetup(1000, 1600, 40);
  setupSound();
}

void draw() {
  background(0);
  strokeWeight(1);
  //image(img, 0, 0,width,height);

  
  setBands();
  drawGrid();

  pushMatrix();
  translate(width/2,0,zVal);
  image(img2, 0, 0);   
  popMatrix();
  zVal+=15;
}

void keyPressed() {
  if (keyCode == UP) {
    zVal = -1000;
  }
}




color getVertexRainbow(int col, int row) {
  // 100 bands and 60 cols. 
  int tempx = int(col * (1.0* myNumBands/cols));
  if(row < bands[tempx]/1.6) {
    return color(Wheel(int(tempx * 256.0/myNumBands)));
  }
  else return color(0);
}

color getVertexGreenBlue(int x, int y) {
  int tempx = int(x * (1.0* myNumBands/cols));
  if(y < bands[tempx]/1.6) {
    return color(Wheel(int(map(tempx,0,myNumBands,60,90))));
  }
  else return color(0);
}

color getVertexImage(int x, int y) {
  int tempx = int(x * (1.0* myNumBands/cols));
  if(y < bands[tempx]/1.6) {
    return img.pixels[img.width/cols*x+ y*img.width];
  }
  else return color(0);
}

// modified from Adafruit Industries Neopixel library
color Wheel(int WheelPos) {
  WheelPos = 255 - WheelPos;
  if(WheelPos < 85) {
   return color(255 - WheelPos * 3, 0, WheelPos * 3);
  } 
  else if(WheelPos < 170) {
    WheelPos -= 85;
   return color(0, WheelPos * 3, 255 - WheelPos * 3);
  } 
  else {
   WheelPos -= 170;
   return color(WheelPos * 3, 255 - WheelPos * 3, 0);
  }
}