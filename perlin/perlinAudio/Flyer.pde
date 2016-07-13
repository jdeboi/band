int wheelP = 0;

int flyerCount = 0;
class Flyer {
  
  int x, y, z, scale, mode;
  int rot = 0;
  boolean hidden;
  int timeStamp = 0;
  boolean selected = false;
  color c;
  
  Flyer(int scale) {
    this.scale = scale;
    reset();
  }
  
  void drawFlyer() {
    if(!hidden) {
      if(flyersFlash) {
        stroke(0);
        fill(0,255,255);
      }
      else {
        stroke(0);
        //fill(c,255-rot*4);
        fill(255);
        if(defaultGridMode == 2 || defaultGridMode == 3) {
          stroke(255);
          fill(0);
        }
      }
      pushMatrix();
        //translate(width/2, height/2, 0);
        translate(x,y,z);
        rotateZ(radians(rot));
        rotateX(radians(rot/2));
        rotateY(radians(rot/-2));
        //translate(x, y, z);
        rot++;
        z+=10; 
        if(mode == 0) setPyramid();
        else if (mode == 1) box(scale);
        else if (mode == 2) setDiamond();
      popMatrix();
    }
  }
  
  void draw2Flyer() {
    
    if(!hidden) {
      
      flyerCount++;
      pushMatrix();
        translate(width/2, height/2, 0);
        if(flyerCount <8) 
        pointLight(red(c), green(c), blue(c), x, y, z);
        z+=10; 
        
      popMatrix();
    }
  }
  
  void setPyramid() {
    beginShape(TRIANGLES);
    vertex(-1 * scale, -1* scale, -1* scale);
    vertex( 1* scale, -1* scale, -1* scale);
    vertex(   0,    0,  scale);
    
    vertex( scale, -scale, -scale);
    vertex( scale,  scale, -scale);
    vertex(   0,    0,  scale);
    
    vertex( scale, scale, -scale);
    vertex(-scale, scale, -scale);
    vertex(   0,   0,  scale);
    
    vertex(-scale,  scale, -scale);
    vertex(-scale, -scale, -scale);
    vertex(   0,    0,  scale);
    endShape();
  }
  
  
  void setDiamond() {
    beginShape(TRIANGLES);
    vertex(-scale, -scale, -scale);
    vertex(scale, -scale, -scale);
    vertex(   0,    0,  scale);
    
    vertex( scale, -scale, -scale);
    vertex( scale,  scale, -scale);
    vertex(   0,    0,  scale);
    
    vertex( scale, scale, -scale);
    vertex(-scale, scale, -scale);
    vertex(   0,   0,  scale);
    
    vertex(-scale,  scale, -scale);
    vertex(-scale, -scale, -scale);
    vertex(   0,    0,  scale);
    
    vertex(-scale, -scale, -scale);
    vertex( scale, -scale, -scale);
    vertex(   0,    0,  -2*scale);
    
    vertex( scale, -scale, -scale);
    vertex( scale,  scale, -scale);
    vertex(   0,    0,  -2*scale);
    
    vertex( scale, scale, -scale);
    vertex(-scale, scale, -scale);
    vertex(   0,   0,  -2*scale);
    
    vertex(-scale,  scale, -scale);
    vertex(-scale, -scale, -scale);
    vertex(   0,    0,  -2*scale);
    endShape();
  }
  
  void reset() {
    hidden = true;
    x = int(random(3*width/4) + width/8);
    y = int(random(height/5)+height/12);
    z = -800;
    rot = 0;
    mode = int(random(3));
    selected = false;
  }
  
  void activate() {
    hidden = false;
    selected = true;
    //c = Wheel(int(random(190,220)));
    c = 0;
    if(defaultGridMode == 2 || defaultGridMode == 3) {
      c = color(255);
    }
  }
}