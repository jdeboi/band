
// Credit for Perlin field: Daniel Shiffman
// Code for: https://youtu.be/IKB1hWWedMk

  
int spacing, cols, rows;
float[][] grid;
float flying = 0;
float flyingInc = 0.08;

void gridSetup(int w, int h, int spacing) {
  this.cols = w/spacing;
  this.rows = h/spacing;
  this.spacing = spacing;
  grid = new float[cols][rows];
}
  
void setGrid() {  
  float yoff = flying;
  for(int y = 0; y < rows; y++) {
    float xoff = 0;
    for(int x = 0; x < cols; x++) {
      grid[x][y] = map(noise(xoff, yoff), 0, 1, -100, 100);
      xoff += .2;
    }
    yoff += .2;
  }
  if(flyingOn) flying -= flyingInc;
}

void setAudioGrid() {  
  flyingOn = false;
  for(int y = 0; y < rows/2; y++) {
    for(int x = 0; x < cols; x++) {
      float f = getFreq(map(x, 0, cols, 0, 100));
      grid[x][y] = f*y/10.0;
    }
  }
  for(int y = rows/2; y < rows; y++) {
    for(int x = 0; x < cols; x++) {
      float f = getFreq(map(x, 0, cols, 0, 100));
      grid[x][y] = f*(y - rows)/10.0;
    }
  }
}


void drawGrid() {
  //setGrid();
  setAudioGrid();
  pushMatrix();
  translate(width/2,height/2);
  rotateX(radians(80));
  translate(-cols*spacing/2, -rows*spacing/2);
  for(int y = 0; y < rows-1; y++) {
    beginShape(TRIANGLE_STRIP);
    for(int x = 0; x < cols; x++) {
      fill(getVertexColor(x,y),gridOpacity);
      vertex(x * spacing, y * spacing, grid[x][y]);
      vertex(x * spacing, (y+1) * spacing, grid[x][y+1]);
    }
    endShape();
  }
  popMatrix();
}

void drawTexturedGrid() {
  setAudioGrid();
  pushMatrix();
  translate(width/2,height/2);
  rotateX(radians(80));
  translate(-cols*spacing/2, -rows*spacing/2);
  for(int y = 0; y < rows-1; y++) {
    beginShape(TRIANGLE_STRIP);
    if(flyingOn) fill(255, 155);
    texture(gridTexture);
    for(int x = 0; x < cols; x++) {
      //fill(getVertexColor(x,y),gridOpacity);
      vertex(x * spacing, y * spacing, grid[x][y],x*(gridTexture.width*1.0/cols),y*(gridTexture.height*1.0/rows));
      vertex(x * spacing, (y+1) * spacing, grid[x][y+1],x*(gridTexture.width*1.0/cols),(y+1)*(gridTexture.height*1.0/rows));
    }
    endShape();
  }
  popMatrix();
}