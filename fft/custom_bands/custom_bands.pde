import ddf.minim.*;
import ddf.minim.analysis.*;

Minim       minim;
AudioPlayer myAudio;
FFT         myAudioFFT;

int         myAudioRange     = 256;
int         myNumBands       = 11;
int         myAudioMax       = 100;
int[]       bandBreaks       = {20, 50, 60, 80, 100, 150, 175, 200, 225, 255};

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

int         stageMargin      = 100;
int         stageWidth       = (880) - (2*stageMargin);
int         stageHeight      = 700;

int         rectSize         = stageWidth/(bandBreaks.length);
float       rect2Size        = stageWidth/256.0;

float       xStart           = stageMargin;
float       yStart           = stageMargin;
int         xSpacing         = rectSize;
float       x2Spacing        = rect2Size;



// ************************************************************************************

color       bgColor          = #DDDDDD;

// ************************************************************************************

void setup() {
  size(880, 700);
  background(bgColor);
  

  minim   = new Minim(this);
  myAudio = minim.loadFile("/Users/jdeboi/Documents/Processing/projects/band/media/music/crushproof.mp3");
  myAudio.play();

  myAudioFFT = new FFT(myAudio.bufferSize(), myAudio.sampleRate());
  myAudioFFT.linAverages(myAudioRange);
  myAudioFFT.window(FFT.GAUSS);
}

void draw() {
  noStroke();
  if (!transparentMode) background(bgColor);

  myAudioFFT.forward(myAudio.mix);
  
  int bandIndex = 0;
  while(bandIndex < bandBreaks.length) {
    fill(255,5);
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
    for(int j = startB+1; j <= endB; j++) {
      
      if (!transparentMode) {
        fill(bgColor);
        rect ( xStart + (j*x2Spacing), yStart, stageWidth, 200);
      }
      if (showSpectrum) {
        if(!transparentMode) fill (Wheel(int(bandIndex*(255.0/bandBreaks.length))));
        else fill (Wheel(int(bandIndex*(255.0/bandBreaks.length))),5);
        rect( xStart + (j*x2Spacing), yStart, rect2Size, myAudioFFT.getAvg(j)*myAudioAmp2*myAudioIndexAmp2);
        myAudioIndexAmp2 += myAudioIndexStep2;
      }
      temp += myAudioFFT.getAvg(j);
    }
    temp /= endB - startB;
    temp *= myAudioAmp*myAudioIndexAmp;
    myAudioIndexAmp+=myAudioIndexStep;
    if(!transparentMode) fill (Wheel(int(bandIndex*(255.0/bandBreaks.length))));
    else fill (Wheel(int(bandIndex*(255.0/bandBreaks.length))),5);
    rect( xStart + (bandIndex*xSpacing), yStart+200, rectSize, temp);
    bandIndex++;
  }
  myAudioIndexAmp = myAudioIndex;
  myAudioIndexAmp2 = myAudioIndex2;

  stroke(#FF3300); noFill();
  line(stageMargin, stageMargin+myAudioMax+200, 880-stageMargin, stageMargin+myAudioMax+200);
  
  if(mouseX > stageMargin && mouseX < stageWidth+stageMargin) {
    stroke(0);
    fill(0);
    text((int)map(mouseX, stageMargin, stageWidth+stageMargin, 0, 256), mouseX, mouseY);
  }
}

void stop() {
  myAudio.close();
  minim.stop();  
  super.stop();
}

// modified from Adafruit Industries Neopixel Library
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