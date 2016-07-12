
// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Particles + Forces

// A very basic Repeller class
class Attractor {
  
  // Gravitational Constant
  float G = 100;
  // Location
  PVector location;
  int w = 700;
  int h = 40;

  Attractor(float x, float y)  {
    location = new PVector(x,y);
  }

  void display() {
    stroke(0);
    strokeWeight(2);
    noFill();
    rect(location.x,location.y,w,h);
  }

  // Calculate a force to push particle away from repeller
  PVector attract(Boid b, int index) {
    PVector spot = new PVector((w*1.0/flock.getSize())*index+location.x,location.y);
    PVector dir = PVector.sub(spot,b.location);      // Calculate direction of force
    float d = dir.mag();                       // Distance between objects
    dir.normalize();                           // Normalize vector (distance doesn't matter here, we just want this vector for direction)
    //d = constrain(d,5,100);                    // Keep distance within a reasonable range
    //float force = -1 * G / (d * d);            // Repelling force is inversely proportional to distance
    float force = 2;

    dir.mult(force);                           // Get force vector --> magnitude * direction
    return dir;
  }  
  
  void switchMode() {
    attractMode =! attractMode;
  }
  
  Boolean onLanding(Boid b, int index) {
    PVector spot = new PVector((w*1.0/flock.getSize())*index+location.x,location.y);
    PVector dir = PVector.sub(spot,b.location);      // Calculate direction of force
    float d = dir.mag();  
    return d < 5;
  }
  
  /*PVector getLanding(Boid b) {
    PVector dir = PVector.sub(location,b.location);      // Calculate direction of force
    float d = dir.mag();                       // Distance between objects
    dir.normalize();                           // Normalize vector (distance doesn't matter here, we just want this vector for direction)
    //d = constrain(d,5,100);                    // Keep distance within a reasonable range
    //float force = -1 * G / (d * d);            // Repelling force is inversely proportional to distance
    float force = 0; 
    if (d > r-5 && d < r+5) return true;
      else force = map(d, r, width/2, 0, 10);
      println(force);
    }
    dir.mult(force);                           // Get force vector --> magnitude * direction
    return dir;
  }  */
}