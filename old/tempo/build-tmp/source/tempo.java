import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class tempo extends PApplet {


long lastPress = millis();
long lastBeat = millis();
int averageTempo = 0; 
int millisPerBeat = 0;

public void setup(){
  
}

public void draw() {
  background(0);
  checkBeat();
 // ellipse(width/2, height/2, getHeight(),getHeight());
 plotCosine();
}

public void keyPressed() {
  if (key == 'g') {
    if(millis() - lastPress < 3000) {
      millisPerBeat = PApplet.parseInt((millis()-lastPress)*.7f + millisPerBeat * .3f);
      averageTempo = PApplet.parseInt(averageTempo*.3f + (1000*60/(millis() - lastPress))*.7f);
    }
    lastPress = millis();
  }
}

public void checkBeat() {
  if(millis() - lastBeat > millisPerBeat) {
    lastBeat = millis();
  }
}

public float getHeight() {
  if(averageTempo > 20) {
    if(millis() < lastBeat + millisPerBeat/2) {
      return map(millis(), lastBeat, lastBeat + millisPerBeat/2, 0, 200);
    }
    else {
      return map(millis(), lastBeat + millisPerBeat/2.0f, lastBeat + millisPerBeat, 200.0f, 0.0f);
    }
  }
  return 0;
}

public void plotCosine() {
  for(int i = 0; i < width; i++) {
    ellipse(i, width/2+40*cos(2*PI/100*i), 5, 5);
  }
}
  public void settings() {  size(600,600); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "tempo" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
