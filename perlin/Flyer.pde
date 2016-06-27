class Flyer {
  
  int x, y, z, scale, mode;
  int rot = 0;
  boolean hidden;
  
  Flyer(int scale) {
    this.scale = scale;
    reset();
  }
  
  void drawFlyer() {
    if(!hidden) {
      pushMatrix();
        //translate(width/2, height/2, 0);
        translate(x,y,z);
        rotateZ(radians(rot));
        //translate(x, y, z);
        rot++;
        z+=10; 
        if(mode == 0) setPyramid();
        else if (mode == 1) box(scale);
        else if (mode == 2) setDiamond();
      popMatrix();
    }
  }
  
  
  void setPyramid() {
    beginShape();
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
    beginShape();
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
    
    vertex(-1 * scale, -1* scale, -1* scale);
    vertex( 1* scale, -1* scale, -1* scale);
    vertex(   0,    0,  -scale);
    
    vertex( scale, -scale, -scale);
    vertex( scale,  scale, -scale);
    vertex(   0,    0,  -scale);
    
    vertex( scale, scale, -scale);
    vertex(-scale, scale, -scale);
    vertex(   0,   0,  -scale);
    
    vertex(-scale,  scale, -scale);
    vertex(-scale, -scale, -scale);
    vertex(   0,    0,  -scale);
    endShape();
  }
  
  void reset() {
    hidden = true;
    x = int(random(width/2) + width/4);
    y = int(random(height/4)+height/8);
    z = -400;
    rot = 0;
    mode = int(random(3));
  }
}