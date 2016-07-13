
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
  
  void update() {
    vel--;
    if(vel < 0) vel = 0;
  }
  
  void display() {
    
    
    //stroke(0,50);
    noStroke();
    fill(pitch, 127, 127, 10);
    
    
    pushMatrix();
    int xVal = 600;
    int yVal = vel*(int)(height/127.0);
    translate(width/2-xVal/2, height/2-yVal/2, -pitch*20);
    //rotateY(radians(85)); 
    //rotateZ(radians(45));
    rotateX(radians(50));
    translate(0,200,0);
    int zVal = 20;
    rect(0, 0, xVal, yVal);
    popMatrix();
    
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