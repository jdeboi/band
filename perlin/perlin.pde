
PImage img;
PImage bkimg;
int zVal = -10000;
Flyers fly;
int defaultGridMode = 0;
int colorMode = 0;
color defaultColor = color(0);
int gridOpacity = 70;

void setup() {
  img = loadImage("/Users/jdeboi/Documents/Processing/projects/band/media/images/swirl.png");
  bkimg = loadImage("/Users/jdeboi/Documents/Processing/projects/band/media/images/galaxy2.jpg");
  img.loadPixels();
  size(1200, 800, P3D);
  
  gridSetup(2000, 1600, 20);
  setupSound();
  
  fly = new Flyers(100);
}

void draw() {

  setBands();
  setDefaultGrid();
  drawGrid();
  
  fly.drawFlyers();
  
  zVal+=15;
}

void setDefaultGrid() {
  switch(defaultGridMode) {
    
    case 0: {
      defaultColor = color(255);
      background(255);
      strokeWeight(1);
      stroke(0);
      break;
    }
    case 1: {
      defaultColor = color(255);
      background(255);
      strokeWeight(1);
      stroke(255);
      break;
    }
    case 2: {
      defaultColor = color(0);
      background(0);
      strokeWeight(1);
      stroke(255);
      break;
    }
    case 3: {
      defaultColor = color(0);
      background(0);
      strokeWeight(1);
      stroke(0);
      break;
    }
    // image background
    case 4: {
      defaultColor = color(0);
      background(0);
      image(bkimg,0,0,width,height);
      strokeWeight(1);
      stroke(0);
      break;
    }
    // double grid
    case 5: {
      defaultColor = color(0);
      background(0);
      image(bkimg,0,0,width,height);
      strokeWeight(1);
      stroke(0);
      pushMatrix();
      translate(width/2, height/2+350);
      rotateZ(radians(180));
      drawGrid();  
      popMatrix();
      break;
    }
  }
}

void keyPressed() {
  if (keyCode == UP) fly.activateFlyer();
  else if(key == '0') defaultGridMode = 0;
  else if(key == '1') defaultGridMode = 1;
  else if(key == '2') defaultGridMode = 2;
  else if(key == '3') defaultGridMode = 3;
  else if(key == '4') defaultGridMode = 4;
  else if(key == '5') defaultGridMode = 5;
  else if(key == 'q') colorMode = 0;
  else if(key == 'w') colorMode = 1;
  else if(key == 'e') colorMode = 2;
  else if(key == 'r') colorMode = 3;
}


color getVertexColor(int x, int y) {
  int tempx = int(x * (1.0* myNumBands/cols));
  if(y < bands[tempx]/1.6) {
    if(colorMode == 0) return img.pixels[img.width/cols*x+ y*img.width];           // image (rainbow swirl)
    else if(colorMode == 1) return color(Wheel(int(map(tempx,0,myNumBands,60,90))));   // green blue
    else if(colorMode == 2) return color(Wheel(int(tempx * 256.0/myNumBands)));         // rainbow
    else if(colorMode == 3) return color(255,255,255);
    else return color(0,255,255);
  }
  else return defaultColor;
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