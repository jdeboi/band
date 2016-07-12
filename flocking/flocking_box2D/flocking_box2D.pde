
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

Repeller repeller;
Attractor attractor;

Boolean attractMode = false;


void setup() {
  size(700, 600);
  
  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  // We are setting a custom gravity
  box2d.setGravity(0, -10);
  
  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < 150; i++) {
    flock.addBoid(new Boid(random(width),random(height)));
  }
  
  // Create the surface
  surface = new Surface();
  
  repeller = new Repeller(width/2-20,height/2);
  attractor = new Attractor(50,height/2);
  
}

void draw() {
  background(255);
  flock.run();
  
  // We must always step through time!
  box2d.step();
  // Draw the surface
  //surface.display();
  if(attractMode) {
    flock.applyAttractor(attractor);
    flock.checkLanding(attractor);
    attractor.display();
  }
  else {
    flock.applyRepeller(repeller);
    repeller.display();
  }
}

// Add a new boid into the System
void mousePressed() {
  flock.addBoid(new Boid(mouseX,mouseY));
}

void keyPressed() {
  if(key == 'l') {
    attractMode =! attractMode;
    if(!attractMode) flock.startFlying();
  }
}