
// Credit for Perlin field: Daniel Shiffman
// Code for: https://youtu.be/IKB1hWWedMk

  
int spacing, cols, rows;
float[][] grid;
float flying = 0;
float flyingInc = 0.05;

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
  flying -= flyingInc;
}

void drawGrid() {
  setGrid();
  pushMatrix();
  translate(width/2,height/2);
  rotateX(radians(80));
  translate(-cols*spacing/2, -rows*spacing/2);

  for(int y = 0; y < rows-1; y++) {
    beginShape(TRIANGLE_STRIP);
    for(int x = 0; x < cols; x++) {
      fill(getVertexColor(x,y),100);
      vertex(x * spacing, y * spacing, grid[x][y]);
      vertex(x * spacing, (y+1) * spacing, grid[x][y+1]);
    }
    endShape();
  }
  popMatrix();
}