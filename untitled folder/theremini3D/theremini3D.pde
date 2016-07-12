
// MIDIBus library
import themidibus.*; //Import the library
import javax.sound.midi.MidiMessage; //Import the MidiMessage classes http://java.sun.com/j2se/1.5.0/docs/api/javax/sound/midi/MidiMessage.html
import javax.sound.midi.SysexMessage;
import javax.sound.midi.ShortMessage;
int lastMidi = 0;
MidiBus myBus; // The MidiBus

MidiObj [] midiObjs = new MidiObj[128];
int currPitch = 50;
long lastUpdated = 0;

void setup() {
  size(900, 600, P3D);
  background(0);
  initMidi();
  initMidiObjs();
  //colorMode(HSB, 127);
}

void draw() {
  background(127,127);
  sendMidi();
  
  for(int i = midiObjs.length -1; i >= 0; i--) {
    midiObjs[i].display();
  }
}


void midiMessage(MidiMessage message) {  
  if(message.getStatus() == 144) {
    midiObjs[(int)(message.getMessage()[1] & 0xFF)].noteOn((int)(message.getMessage()[2] & 0xFF));
  }
  else {
    //midiObjs[(int)(message.getMessage()[1] & 0xFF)].noteOff();
  }
}

void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}

void sendMidi() {
  if(millis() - lastUpdated > 1000) {
    currPitch++;
    if(currPitch > 127) currPitch = 0;
    myBus.sendNoteOn(0,currPitch,127); // Send a Midi noteOn
    if(currPitch - 5 < 0) myBus.sendNoteOff(0,127-currPitch,0); // Send a Midi nodeOff
    else myBus.sendNoteOff(0,currPitch -5,0); 
  }
}

void initMidi() {
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  myBus = new MidiBus(this, 0, 1); // Create a new MidiBus object
  // On mac you will need to use MMJ since Apple's MIDI subsystem doesn't properly support SysEx. 
  // However MMJ doesn't support sending timestamps so you have to turn off timestamps.
  myBus.sendTimestamps(false);
}

void initMidiObjs() {
  for (int i = 0; i < midiObjs.length; i++) {
    midiObjs[i] = new MidiObj(0, (int)(height/128.0*i), 0, i);
  }
}