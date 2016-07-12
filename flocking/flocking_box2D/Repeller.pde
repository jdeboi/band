
// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Particles + Forces

// A very basic Repeller class
class Repeller {
  
  // Gravitational Constant
  float G = 100;
  // Location
  PVector location;
  float r = 100;

  Repeller(float x, float y)  {
    location = new PVector(x,y);
  }

  void display() {
    location.x = mouseX;
    location.y = mouseY;
    stroke(0);
    strokeWeight(2);
    noFill();
    ellipse(location.x,location.y,r*2,r*2);
  }

  // Calculate a force to push particle away from repeller
  PVector repel(Boid b) {
    PVector dir = PVector.sub(location,b.location);      // Calculate direction of force
    float d = dir.mag();                       // Distance between objects
    dir.normalize();                           // Normalize vector (distance doesn't matter here, we just want this vector for direction)
    //d = constrain(d,5,100);                    // Keep distance within a reasonable range
    //float force = -1 * G / (d * d);            // Repelling force is inversely proportional to distance
    float force = 0; 
    if(!attractMode) {
      if(d < r+5) force = -10;
    }
    else {
      if (d < r) force = map(d, 0, r, -2, 0);
      else force = map(d, r, width/2, 0, 2);
      println(force);
    }
    dir.mult(force);                           // Get force vector --> magnitude * direction
    return dir;
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