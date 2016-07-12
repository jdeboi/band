class Joint {

  String id;
  int num;
  float posX = 0.0, posY = 0.0, posZ = 0.0; 
  int requiredLength = 0; 
  int pointHis = 5;
  Boolean track = false;
  String hitStatus = "";

  Joint(String id, int num) {
    this.id = id;
    this.num = num;
  }

 int  checkOsc(OscMessage theOscMessage) {
   hitStatus = "";
   // [up,down,left,right,forward,back]   
   // Sent when we detect a “hit” event, such as a punch forward, 
   // which would be “righthand forward”.
   if(theOscMessage.checkAddrPattern(id)) {   
     hitStatus = theOscMessage.get(0).stringValue();
     return 1;
   }
   // The x,y,z position of the joint 
   // relative to the torso, projected on the screen, or in the world
   else if(theOscMessage.checkAddrPattern(id+"_pos_screen")) {
     posX = theOscMessage.get(0).floatValue();
     posY = theOscMessage.get(1).floatValue();
     posZ = theOscMessage.get(2).floatValue();
     //println(posX + " " + posY + " " + posZ);
     
     return 2;
   }
   return 0;
 }
   
  void drawJoint() {
    if(track) {
      //pushMatrix();
      //translate(posX,posY,posZ);
      //println("screenX: " + screenX + ", screenY: " + screenY + ", screenZ: " + screenZ);
      fill(0,255,0);
      ellipse(posX,posY, 15, 15);
      //popMatrix();
    // TODO - world and position mode
    }
  }
  
  // This is the keepalive to cause joint positions to 
  // continue being spit out (more about this below).  
  // Valid values to pass are: 1, to get _pos_body positions; 
  // 2, to get _pos_world positions; and 3, to get _pos_screen positions.
  void setTrackJointPos(int pos) {
    if(track) {
      String message = id + "_trackjointpos";
      OscMessage myMessage = new OscMessage(message);
      myMessage.add(pos); 
      oscP5.send(myMessage, myRemoteLocation); 
    }
  }
  
  float getX() {
    return posX;
  }
  
  float getY() {
    return posY;
  }
  
  // Use this to change how many points are being tracked 
  // for hit event detection.  This is essentially a control 
  // for how fast you must move your hand to cause a hit event, 
  // lower means you must do it faster.  Defaults to 5.
  void setPointHistorySize(int size) {
    String message = id + "_pointhistorysize";
    OscMessage myMessage = new OscMessage(message);
    myMessage.add(size); 
    oscP5.send(myMessage, myRemoteLocation); 
  }
  
  // Use this to change how far you must move this joint 
  // in a direction (in mm) to trigger a hit event.  Defaults to 150
  void setRequiredLen(float dis) {
    String message = id + "_requiredlength";
    OscMessage myMessage = new OscMessage(message);
    myMessage.add(dis); 
    oscP5.send(myMessage, myRemoteLocation); 
  }
  
  // This causes the _requiredlength and _pointhistorysize 
  // messages to be sent from Synapse, so that you can see what the 
  // current values are.
  void getTuningPoints() {
    String message = id + "_gettuninginfo";
    OscMessage myMessage = new OscMessage(message);
    oscP5.send(myMessage, myRemoteLocation); 
  }

}