
import ddf.minim.*;
import ddf.minim.analysis.*;

import processing.video.*;
Movie movie;

Minim       minim;
AudioPlayer myAudio;
FFT         myAudioFFT;

int         myAudioRange     = 256;
int         myNumBands       = 50;
int         myAudioMax       = 100;
boolean     linearAvg        = true;
int[]       bandBreaks       = {20, 50, 60, 80, 100, 150, 175, 200, 225, 255};
float[]     bands;

float       myAudioAmp       = 170.0;
float       myAudioIndex     = 0.2;
float       myAudioIndexAmp  = myAudioIndex;
float       myAudioIndexStep = 0.55;

float       myAudioAmp2       = 30.0;
float       myAudioIndex2     = 0.05;
float       myAudioIndexAmp2  = 0.05;
float       myAudioIndexStep2 = 0.025;

boolean     showSpectrum     = true;
boolean     transparentMode  = false;
// ************************************************************************************

int         stageMargin      = 0;
float       stageWidth       = (880) - (2*stageMargin);
int         stageHeight      = 700;

float       rectSize         = stageWidth*1.0/(bandBreaks.length*1.0);
float       rect2Size        = stageWidth/256.0;

float       xStart           = stageMargin;
float       yStart           = stageMargin;
float       xSpacing         = rectSize*1.0;
float       x2Spacing        = rect2Size;



// ************************************************************************************

color       bgColor          = #DDDDDD;

// ************************************************************************************

void setup() {
  size(880, 700);
  background(bgColor);


  minim   = new Minim(this);
  myAudio = minim.loadFile("crushproof.mp3");
  myAudio.play();

  myAudioFFT = new FFT(myAudio.bufferSize(), myAudio.sampleRate());
  myAudioFFT.linAverages(myAudioRange);
  myAudioFFT.window(FFT.GAUSS);
  
  if(!linearAvg) bands = new float[bandBreaks.length];
  else {
    myAudioFFT.linAverages(myNumBands);
    bands = new float[myNumBands];
    rectSize = stageWidth/myNumBands;
    xSpacing = rectSize;
  }
}

void draw() {
  image(movie, 0, 0, width, height);
  setBands();
  drawStrips();
}

void stop() {
  myAudio.close();
  minim.stop();  
  super.stop();
}

void movieEvent(Movie m) {
  m.read();
}

void drawStrips() {
  int endIndex = bands.length;
  if (linearAvg) endIndex = myNumBands;
  for(int i = 0; i < endIndex; i++) {
    fill(0,150);
    stroke(Wheel(int(i*256.0/myNumBands)));
    rect(xStart + i * xSpacing, 0, rectSize, height/2 - bands[i]*3.5);
    rect(xStart + i * xSpacing, height/2 + bands[i]*3.5, rectSize, height/2);
    //pushMatrix();
    //translate(xStart + i * xSpacing, height/4, 0);
    //box(rectSize, height/2,3);
    //println(height/2);
    //popMatrix();
    //pushMatrix();
    ////translate(xStart + i * xSpacing, height/2 + bands[i]*3.5, 0);
    ////box(rectSize, height/2 + bands[i]*3.5,3);
    //popMatrix();
  }
}

void setBands() {
  myAudioFFT.forward(myAudio.mix);
  if (!linearAvg) customBands();
  else {
    for (int i = 0; i < myNumBands; ++i) {
    float tempIndexAvg = (myAudioFFT.getAvg(i) * myAudioAmp) * myAudioIndexAmp;
    float tempIndexCon = constrain(tempIndexAvg, 0, myAudioMax);
    bands[i] = tempIndexCon;
    myAudioIndexAmp+=myAudioIndexStep;
  }
  myAudioIndexAmp = myAudioIndex;
  }
}

void customBands() {
 int bandIndex = 0;
  while(bandIndex < bandBreaks.length) {
    float temp = 0;
    int startB = 0; 
    int endB = 0;
    if (bandIndex == 0) {
      startB = -1;
      endB = bandBreaks[bandIndex];
    }
    else if (bandIndex < bandBreaks.length) {
      startB = bandBreaks[bandIndex-1];
      endB = bandBreaks[bandIndex];
    }
    for(int j = startB+1; j <= endB; j++) temp += myAudioFFT.getAvg(j);
    temp /= endB - startB;
    temp *= myAudioAmp*myAudioIndexAmp;
    float tempCon = constrain(temp, 0, myAudioMax);
    bands[bandIndex] = tempCon;
    
    myAudioIndexAmp+=myAudioIndexStep;
    bandIndex++;
  }
  myAudioIndexAmp = myAudioIndex; 
}

// credit: Adafruit
color Wheel(int WheelPos) {
  WheelPos = 255 - WheelPos;
  if(WheelPos < 85) {
   return color(255 - WheelPos * 3, 0, WheelPos * 3);
  } else if(WheelPos < 170) {
    WheelPos -= 85;
   return color(0, WheelPos * 3, 255 - WheelPos * 3);
  } else {
   WheelPos -= 170;
   return color(WheelPos * 3, 255 - WheelPos * 3, 0);
  }
}