
long lastPress = millis();
long lastBeat = millis();
int averageTempo = 0; 
int millisPerBeat = 0;

void setup(){
  size(600,600);
}

void draw() {
  background(0);
  checkBeat();
 // ellipse(width/2, height/2, getHeight(),getHeight());
 plotCosine();
}

void keyPressed() {
  if (key == 'g') {
    if(millis() - lastPress < 3000) {
      millisPerBeat = int((millis()-lastPress)*.7 + millisPerBeat * .3);
      averageTempo = int(averageTempo*.3 + (1000*60/(millis() - lastPress))*.7);
    }
    lastPress = millis();
  }
}

void checkBeat() {
  if(millis() - lastBeat > millisPerBeat) {
    lastBeat = millis();
  }
}

float getHeight() {
  if(averageTempo > 20) {
    if(millis() < lastBeat + millisPerBeat/2) {
      return map(millis(), lastBeat, lastBeat + millisPerBeat/2, 0, 200);
    }
    else {
      return map(millis(), lastBeat + millisPerBeat/2.0, lastBeat + millisPerBeat, 200.0, 0.0);
    }
  }
  return 0;
}

void plotCosine() {
  for(int i = 0; i < width; i++) {
    ellipse(i, width/2+40*cos(2*PI/100*i), 5, 5);
  }
}