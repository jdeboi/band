class Button {
  
  int x, y, w, h;
  Boolean pressed;
  int pressCount = 0;
  
  Button(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    pressed = false;
  }
  
  Boolean contains(int xPos, int yPos) {
    if(xPos>x && xPos<x+w && yPos>y && yPos<y+h){
      println("hand on button");
      return true;
    }
    return false;
  }
  
  Boolean isPressed(int xPos, int yPos) {
    if(contains(xPos, yPos)) {
      pressCount++;
      if(pressCount > 5) {
        pressed =! pressed;
        return true;
      }
    }
    else {
      pressCount = 0;
    }
    return false;
  }
  
  void drawButton() {
    if(pressed) fill(#79C6FF);
    else fill(0,0,255);
    stroke(0, 0, 255);
    strokeWeight(3);
    rect(x,y,w,h);
  }
}