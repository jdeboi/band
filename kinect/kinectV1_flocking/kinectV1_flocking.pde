/**
 * Chris Kalani - http://synapsekinect.tumblr.com/
 *
 *
 * oscP5sendreceive by andreas schlegel
 * oscP5 website at http://www.sojamo.de/oscP5
 *
 * Daniel Shiffman http://natureofcode.com
 * Array of Images for particle textures
 */
 
// Shiffman
import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.*;
// A reference to our box2d world
Box2DProcessing box2d;
// An object to store information about the uneven surface
Surface surface;

Flock flock;

 
import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;
  float deg;
  boolean ir = false;
  boolean colorDepth = false;

 
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress myRemoteLocation;


Skeleton skeleton;


Boolean tracking = false;
Boolean land = false;

// Which pixels do we care about?
int minDepth =  860;
int maxDepth = 960;
// Depth image
PImage depthImg;



void setup() {
  size(600,600,P3D);
  //frameRate(25);
  // start oscP5, listening for incoming messages from Synapse
  oscP5 = new OscP5(this,12347);
  // send messages to Synapse on port 12346
  myRemoteLocation = new NetAddress("127.0.0.1",12346);
  
  skeleton = new Skeleton();
  
   kinect = new Kinect(this);
    //kinect.initDepth();
    //kinect.initVideo();
    //kinect.enableIR(ir);
    //kinect.enableColorDepth(colorDepth);

    deg = kinect.getTilt();
    // kinect.tilt(deg);
    kinect.enableMirror(true);
  
  
  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < 150; i++) {
    flock.addBoid(new Boid(width/2,height/2));
  }
  
   // Create the surface
  surface = new Surface();
}


void draw() {
  
  if(tracking) {
    background(0);  
  }
  else {
    background(255);  
  }
  //skeleton.drawSkeleton();
  //skeleton.update();
  
  //if(land) flock.land();
  //else 
  flock.run();
  
  // We must always step through time!
  box2d.step();
  // Draw the surface
  surface.display();
}

void oscEvent(OscMessage theOscMessage) {
 if(theOscMessage.checkAddrPattern("/tracking_skeleton")) { 
   if(theOscMessage.get(0).intValue()==1) tracking = true;
   else tracking = false;
 }
 else {
   skeleton.check(theOscMessage);
 }
 return;
 
 
}


void drawSkin() {
  // Threshold the depth image
    PImage colorKinect = kinect.getVideoImage(); 
    int[] rawDepth = kinect.getRawDepth();
    for (int i=0; i < rawDepth.length; i++) {
      if (rawDepth[i] >= minDepth && rawDepth[i] <= maxDepth) {
        depthImg.pixels[i] = colorKinect.pixels[i];
      } else {
        depthImg.pixels[i] = color(0);
      }
    }
    image(depthImg, 0, 0);
    // Draw the thresholded image
    depthImg.updatePixels();
}

// This allows you to cut the background out of the 
// depth image and only see the user.  Valid values to pass are: 
// 0 to see the whole depth buffer, 1 to see only the tracked 
// user (or all person-shaped things if no one is tracked), 
// 2 to see all person-shaped things even if a user is tracked.
void setDepthMode(int mode) {
  String message = "/depth_mode";
  OscMessage myMessage = new OscMessage(message);
  if(mode >= 0 && mode <= 2) {
    myMessage.add(mode); 
    oscP5.send(myMessage, myRemoteLocation); 
  }
  else println("mode must be 0, 1, or 2");
}