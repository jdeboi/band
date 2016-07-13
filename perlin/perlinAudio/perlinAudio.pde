import camera3D.Camera3D;
PGraphics label;
Camera3D camera3D;  

PImage gridImg, bkImg, gridTexture;
int zVal = -10000;
Flyers fly;
int defaultGridMode = 0;
int colorMode = 0;
color defaultColor = color(0);
int gridOpacity = 70;
boolean flyersFlash = false;
boolean flyingOn = true;

void setup() {
  size(1200, 800, P3D);

  // 3D stuff
  //camera3D = new Camera3D(this);
  //camera3D.setBackgroundColor(color(0));
  //camera3D.renderDefaultAnaglyph().setDivergence(1);

  gridImg = loadImage("/Users/jdeboi/Documents/Processing/projects/band/media/images/swirl.png");
  bkImg = loadImage("/Users/jdeboi/Documents/Processing/projects/band/media/images/galaxy3.jpg");
  gridTexture = loadImage("/Users/jdeboi/Documents/Processing/projects/band/media/images/galaxy3.jpg");
  gridImg.loadPixels();

  gridSetup(2048, 1152, 20);
  setupSound();

  fly = new Flyers(100);

  setupParticles(100);
  
  beat = new BeatDetect(myAudio.bufferSize(), myAudio.sampleRate());
  beat.setSensitivity(300);  
  kickSize = snareSize = hatSize = 16;
  // make a new beat listener, so that we won't miss any buffers for the analysis
  bl = new BeatListener(beat, myAudio);  
}


//void preDraw() { 
//}

void draw() {

  setBands();
  setDefaultGrid();
  zVal+=15;
  if(colorMode == 4) drawTexturedGrid();
  else drawGrid();
  fly.drawFlyers();

  if(beat.isHat()) starsBright = true;
  else starsBright = false;
  drawParticles();
}

void setDefaultGrid() {
  switch(defaultGridMode) {
    // white with black lines
  case 0: {
      defaultColor = color(255);
      background(255);
      strokeWeight(1);
      stroke(0);
      break;
    }
    
  // all white  
  case 1: {
      defaultColor = color(255);
      background(255);
      strokeWeight(1);
      stroke(255);
      if(colorMode == 3) stroke(0);
      break;
    }
  // black with white lines  
  case 2: {
      defaultColor = color(0);
      background(0);
      strokeWeight(1);
      stroke(255);
      break;
    }
  // all black  
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
      pushMatrix();
      translate(-750,-600,-900);
      tint(255, 127); 
      image(bkImg, 0, 0, width*3, height*3);
      popMatrix();
      strokeWeight(1);
      stroke(0);
      break;
    }
    // double grid
  case 5: {
      defaultColor = color(0);
      background(0);
      pushMatrix();
      translate(-750,-600,-900);
      tint(255, 127); 
      image(bkImg, 0, 0, width*3, height*3);
      popMatrix();
      strokeWeight(1);
      stroke(0);
      pushMatrix();
      translate(width/2, height/2);
      rotateZ(radians(180));
      translate(-350, -350);
      drawGrid();  
      popMatrix();
      break;
    }
  }
}

void keyPressed() {
  if (keyCode == UP) fly.activateFlyer();
  else if (key == '0') defaultGridMode = 0;  // white with black lines
  else if (key == '1') defaultGridMode = 1;  // all white
  else if (key == '2') defaultGridMode = 2;  // black with white lines
  else if (key == '3') defaultGridMode = 3;  // all black
  else if (key == '4') defaultGridMode = 4;  // image
  else if (key == '5') defaultGridMode = 5;  // double grids
  
  else if (key == 'q') colorMode = 0;        // rainbow swirl image
  else if (key == 'w') colorMode = 1;        // green blue
  else if (key == 'e') colorMode = 2;        // rainbow
  else if (key == 'r') colorMode = 3;                      // white
  else if (key == 't') colorMode = 4;                      // textured mode
           
  else if (key == 's') starsOn =! starsOn;
  else if (key == 'f') flyingOn =! flyingOn;
}


color getVertexColor(int x, int y) {
  int tempx = int(x * (1.0* myNumBands/cols));
  if (y < bands[tempx]/1.6) {
    if (colorMode == 0) return gridImg.pixels[gridImg.width/cols*x+ y*gridImg.width];           // image (rainbow swirl)
    else if (colorMode == 1) return color(Wheel(int(map(tempx, 0, myNumBands, 60, 90))));   // green blue
    else if (colorMode == 2) return color(Wheel(int(tempx * 256.0/myNumBands)));         // rainbow
    else if (colorMode == 3) return color(255, 255, 255);
    else return color(0, 255, 255);
  } 
  else return defaultColor;
}




// modified from Adafruit Industries Neopixel library
color Wheel(int WheelPos) {
  WheelPos = 255 - WheelPos;
  if (WheelPos < 85) {
    return color(255 - WheelPos * 3, 0, WheelPos * 3);
  } else if (WheelPos < 170) {
    WheelPos -= 85;
    return color(0, WheelPos * 3, 255 - WheelPos * 3);
  } else {
    WheelPos -= 170;
    return color(WheelPos * 3, 255 - WheelPos * 3, 0);
  }
}