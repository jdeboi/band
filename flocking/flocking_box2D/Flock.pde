
// The Flock (a list of Boid objects)

class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids

  Flock() {
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
  }

  int getSize() {
    return boids.size();
  }
  
  void run() {
    for (Boid b : boids) {
      b.run(boids);  // Passing the entire list of boids to each boid individually
    }
  }

  void addBoid(Boid b) {
    boids.add(b);
  }
  
  void startFlying() {
    for (Boid b : boids) {
      b.startFlying();
    }
  }
  
  void applyRepeller(Repeller r) {
    for (Boid b: boids) {
      PVector force = r.repel(b);        
      b.applyForce(force);
    }
  }
  
  void applyAttractor(Attractor a) {
    for (int i = 0; i < boids.size(); i++) {
      PVector force = a.attract(boids.get(i),i);        
      boids.get(i).applyForce(force);
    }
  }
  
  void checkLanding(Attractor a) {
    for (int i = 0; i < boids.size(); i++) {
      if (a.onLanding(boids.get(i),i)) {
        boids.get(i).landed();
      }
    }
  }
}