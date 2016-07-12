
class MidiObj {
  
  long timeOn;
  int vel, pitch, x, y;
  boolean noteOn;
  
  MidiObj(int x, int y, int vel, int pitch) {
    this.x = x;
    this.y = y;
    timeOn = millis();
    this.vel = vel;
    this.pitch = pitch;
    noteOn = false;
  }
  
  void display() {
    vel--;
    if(vel < 0) vel = 0;
    colorMode(HSB, 127);
    noStroke();
    fill(pitch, 127, 127, 10);
    
    
    pushMatrix();
    int xVal = 600;
    int yVal = vel*2;
    translate(width/2-xVal/2, height/2-yVal/2, -pitch*20+150);
     
    
    int zVal = 20;
    rect(0, 0, xVal, yVal);
    popMatrix();
    /* 
    beginShape(QUADS);
    vertex(-xVal,  yVal,  zVal);
    vertex( xVal,  yVal,  zVal);
    vertex( xVal,  -yVal,  zVal);
    vertex(-xVal,  -yVal,  zVal);
  
    vertex( xVal,  yVal,  zVal);
    vertex( xVal,  yVal,  -zVal);
    vertex( xVal,  -yVal,  -zVal);
    vertex( xVal,  -yVal,  zVal);
  
    vertex( -xVal,  yVal,  -zVal);
    vertex(-xVal,  yVal,  -zVal);
    vertex(-xVal,  -yVal,  -zVal);
    vertex( xVal,  -yVal,  -zVal);
  
    vertex(-xVal,  yVal,  -zVal);
    vertex(-xVal,  yVal,  zVal);
    vertex(-xVal,  -yVal,  zVal);
    vertex(-xVal,  -yVal,  -zVal);
  
    vertex(-xVal,  yVal,  -zVal);
    vertex(xVal,  yVal,  -zVal);
    vertex( xVal,  yVal,  zVal);
    vertex(-xVal,  yVal,  zVal);

    vertex(-xVal,  -yVal,  -zVal);
    vertex( xVal,  -yVal,  -zVal);
    vertex( xVal,  -yVal,  zVal);
    vertex(-xVal,  -yVal,  zVal);

    endShape();
    popMatrix();
    //printNote();
    */
  }
  
  void noteOff() {
    noteOn = false;
    vel = 0;
  }
  
  void noteOn(int vel) {
    this.vel = vel;
    noteOn = true;
    timeOn = millis();
  }
  
  void printNote() {
    println("------");
    if(noteOn) println("NOTEON");
    else println("NOTEOFF");
    println("Pitch: " + pitch);
    println("Velocity: " + vel);
  }
    
}