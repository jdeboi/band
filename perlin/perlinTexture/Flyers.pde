class Flyers {
  
  Flyer[] flyers;
  int currentFlyer = 0;
  
  Flyers(int num) {
    flyers = new Flyer[num];
    for(int i = 0; i < flyers.length; i++ ) {
      flyers[i] = new Flyer(int(random(18,40)));
    }
  }
  
  void drawFlyers() {
    for(int i = 0; i < flyers.length; i++ ) {
      flyers[i].drawFlyer();
    }
  }
  
  void activateFlyer() {
    flyers[currentFlyer].activate();
    if(currentFlyer > 0) flyers[currentFlyer - 1].selected = false;
    else flyers[flyers.length-1].selected = false;
    currentFlyer++;
    if(currentFlyer == flyers.length) currentFlyer = 0;
    flyers[currentFlyer].reset();
  }
  
  
  void resetFlyers() {
    for(int i = 0; i < flyers.length; i++) {
      flyers[i].reset();
    }
  }
}
  