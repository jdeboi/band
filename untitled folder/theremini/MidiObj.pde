
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
    fill(255);
    if (pitch % 12 == 0) fill(0, 255, 255);
    if(noteOn) rect(x, y, (millis() - timeOn)/4, 10);
    printNote();
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