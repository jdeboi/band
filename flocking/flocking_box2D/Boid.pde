

// The Boid class

class Boid {

  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  Boolean wingUp = false;
  int wingCount;
  Boolean noBoundaries = false;
  Boolean landed = false;

  Boid(float x, float y) {
    r = 6.0;
    maxspeed = 3;
    maxforce = 0.03;
    location = new PVector(x, y);
    initVel();
  }
  
  void initVel() {
    acceleration = new PVector(0, 0);

    float angle = random(TWO_PI);
    velocity = new PVector(cos(angle), sin(angle));
    
    wingCount = int(random(10));
  }

  void run(ArrayList<Boid> boids) {
    if(!landed) {
      flock(boids);
      update();
      borders();
    }
    render();
    
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Boid> boids) {
    PVector sep = separate(boids);   // Separation
    PVector ali = align(boids);      // Alignment
    PVector coh = cohesion(boids);   // Cohesion
    //PVector scat = scatter(boids);   // Scatter
    // Arbitrarily weight these forces
    sep.mult(1.5);
    ali.mult(1.0);
    coh.mult(1.0);
    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }

  // Method to update location
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    location.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, location);  // A vector pointing from the location to the target
    // Scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);

    // Above two lines of code below could be condensed with new PVector setMag() method
    // Not using this method until Processing.js catches up
    // desired.setMag(maxspeed);

    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    return steer;
  }

  void render() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading() + radians(90);

    fill(0, 100);
    noStroke();
    pushMatrix();
    translate(location.x, location.y);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();
    if (landed) {
      int wc = 13;
      if (wingCount++%wc == 0) wingUp =! wingUp;
    }
    else if(velocity.y > .3) {
      wingCount = 10;
      wingUp = true;
    }
    else {
      int wc = int((map(velocity.x,-maxspeed,maxspeed,10,5)));
      if (wingCount++%wc == 0) wingUp =! wingUp;
    }
    if(wingUp) {
      beginShape(TRIANGLES);
      vertex(0, -r);
      vertex(-r*2, r);
      vertex(r*2, r);
      endShape();
    }
    popMatrix();
  }

  
  void borders() {
    if(noBoundaries) {
      if (location.x < -r) location.x = width+r; // velocity = new PVector(-velocity.x,velocity.y); //
      if (location.y < -r) location.y = height+r; // velocity = new PVector(velocity.x,-velocity.y); // 
      if (location.x > width+r) location.x = -r; // velocity = new PVector(-velocity.x,velocity.y);  //
      if (location.y > height+r) location.y = -r; // velocity = new PVector(velocity.x,-velocity.y);  //
    }
    else {
      PVector desired = null;
      int buffer = 30;
      if (location.x < buffer) {
        desired = new PVector(maxspeed, velocity.y);
      } 
      else if (location.x > width -buffer) {
        desired = new PVector(-maxspeed, velocity.y);
      } 
  
      if (location.y < buffer) {
        desired = new PVector(velocity.x, maxspeed);
      } 
      else if (location.y > height-buffer) {
        desired = new PVector(velocity.x, -maxspeed);
      } 
  
      if (desired != null) {
        desired.normalize();
        desired.mult(maxspeed);
        PVector steer = PVector.sub(desired, velocity);
        steer.limit(maxforce*3l);
        applyForce(steer);
      }
    }
  }
  /*
  void touchBody() {
    if(insideBody(location.x, location.y)) 
      PVector desired = null;
      int buffer = 30;
      if (location.x < buffer) {
        desired = new PVector(maxspeed, velocity.y);
      } 
      else if (location.x > width -buffer) {
        desired = new PVector(-maxspeed, velocity.y);
      } 
  
      if (location.y < buffer) {
        desired = new PVector(velocity.x, maxspeed);
      } 
      else if (location.y > height-buffer) {
        desired = new PVector(velocity.x, -maxspeed);
      } 
  
      if (desired != null) {
        desired.normalize();
        desired.mult(maxspeed);
        PVector steer = PVector.sub(desired, velocity);
        steer.limit(maxforce+10);
        applyForce(steer);
      }
    }
  } */

  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList<Boid> boids) {
    float desiredseparation = 25.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Boid other : boids) {
      float d = PVector.dist(location, other.location);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // steer.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Boid> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // sum.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return steer;
    } 
    else {
      return new PVector(0, 0);
    }
  }

  // Cohesion
  // For the average location (i.e. center) of all nearby boids, calculate steering vector towards that location
  PVector cohesion (ArrayList<Boid> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all locations
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.location); // Add location
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the location
    } 
    else {
      return new PVector(0, 0);
    }
  }
  void landed() {
    landed = true;
    acceleration = new PVector(0,0);
    //PVector up = new PVector(0,
    velocity = new PVector(0,-1);
    
  }
  
  void startFlying() {
    initVel();
    landed = false;
  }
}