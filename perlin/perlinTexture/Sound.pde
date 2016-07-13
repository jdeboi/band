
import ddf.minim.*;
import ddf.minim.analysis.*;

// Credit for audio analysis from 
// Programming Graphics III: Painting with Sound / tier 2 / code + videos
// By  Joshua Davis

Minim       minim;
AudioPlayer myAudio;
FFT         myAudioFFT;

int         myAudioRange     = 256;
int         myNumBands       = 256;
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
  
void setupSound() {
  minim   = new Minim(this);
  myAudio = minim.loadFile("/Users/jdeboi/Documents/Processing/projects/band/media/music/crushproof.mp3");
  myAudio.play();

  myAudioFFT = new FFT(myAudio.bufferSize(), myAudio.sampleRate());
  myAudioFFT.linAverages(myAudioRange);
  myAudioFFT.window(FFT.GAUSS);
  
  if(!linearAvg) bands = new float[bandBreaks.length];
  else {
    myAudioFFT.linAverages(myNumBands);
    bands = new float[myNumBands];
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

void stop() {
  myAudio.close();
  minim.stop();  
  //super.stop();
}