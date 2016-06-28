

ArrayList particles;
boolean flag=false;
int distance=50; 
boolean starsOn = false;
boolean starsBright = false;

void setupParticles(int num) {
  particles = new ArrayList();
  for (int i = 0; i < num; i++) {
    Particle P = new Particle();
    particles.add(P);
  }  
}
  
void drawParticles() {
  if(starsOn) {
    for (int i = 0; i < particles.size(); i++) {
      Particle Pn1 = (Particle) particles.get(i);
      Pn1.display();
      Pn1.update();
    }
  }
}


// credit: http://www.openprocessing.org/sketch/113507 
class Particle {
  float x, y, z, r, fx, fy;
  color c;
  int i=1, j=1;
  
  Particle( ) {
    x = random(0, width);
    y = random(0, height/2);
    r = random(1, 4);
    fx = random(-0.9, 0.9);
    fy = random(-0.9, 0.9);
  }
 
  void display() {
    //---------------blur/glow ----------
    float h = 3;
    float start = r * 4;
    if(starsBright) start = r*10;
    for (float r1 = start; r1 > 0; --r1) {
      fill(255, h);
      noStroke();
      pushMatrix();
      translate(0,0,-50);
      ellipse(x, y, r1, r1);
      popMatrix();
      h=(h+10);
    }
    noStroke();
    int t=0;
    int ik = (int)random(0, 2);
    if (ik==0) t=0;
    if (ik==1) t=255;
    fill(t);
    pushMatrix();
    translate(0,0,-50);
    ellipse(x, y, r, r);
    popMatrix();
  }
 
  void update() {
    x = x + j*fx;
    y = y + i*fy;
    if (y > height-r) i=-1;
    if (y < 0+r) i=1;
    if (x > width-r) j=-1;
    if (x < 0+r) j=1;
  }
}