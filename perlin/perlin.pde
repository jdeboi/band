
PImage img;
PImage img2;
int zVal = -10000;

void setup() {
  img = loadImage("/Users/jdeboi/Documents/Processing/projects/band/media/images/swirl.png");
  img2 = loadImage("/Users/jdeboi/Documents/Processing/projects/band/media/images/galaxy2.jpg");
  img.loadPixels();
  size(1200, 800, P3D);
  
  gridSetup(2000, 1600, 20);
  setupSound();
}

void draw() {
  background(0);
  strokeWeight(1);
  image(img2, 0, 0,width,height);

  
  setBands();
  drawGrid();
  
  // double grid
  //pushMatrix();
  //translate(width/2, height/2+350);
  //rotateZ(radians(180));
  //drawGrid();  
  //popMatrix();
  zVal+=15;
}

void keyPressed() {
  if (keyCode == UP) {
    zVal = -1000;
  }
}


color getVertexColor(int x, int y) {
  int tempx = int(x * (1.0* myNumBands/cols));
  if(y < bands[tempx]/1.6) {
  // return color(Wheel(int(tempx * 256.0/myNumBands)));         // rainbow
  // return color(Wheel(int(map(tempx,0,myNumBands,60,190))));   // green blue
    return img.pixels[img.width/cols*x+ y*img.width];            // image
  //return color(255,255,255);
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