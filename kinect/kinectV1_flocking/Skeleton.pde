class Skeleton {
  
  int numTrackJoints = 0;
  Joint joints[];
  long lastTime = 0;
  public String [] jointNames = {
    "/righthand",     // 0 -> 2 (right elbow) 
    "/lefthand",      // 1
    "/rightelbow",    // 2 -> 11 (right shoulder)
    "/leftelbow",     // 3 -> 1 (left hand)
    "/rightfoot",     // 4 -> 6 (right knee)
    "/leftfoot",      // 5 -> 7 (left knee)
    "/rightknee",     // 6 -> 13 (right hip)
    "/leftknee",      // 7 -> 12 (left hip)
    "/head",          // 8
    "/torso",         // 9 -> 8 (torso)
    "/leftshoulder",  // 10 -> 3 (left elbow) && -> 9 (torso)
    "/rightshoulder",  // 11 -> 10 (left shoulder) && -> 9 (torso)
    "/lefthip",       // 12 -> 9(torso)
    "/righthip",      // 13 -> 9 (torso)
    "/closesthand"    // 14
  };
  
  Skeleton() {
    initJoints();
    trackBody();
  }
  
  void initJoints() {
    joints = new Joint[jointNames.length]; 
    for(int i = 0; i < joints.length; i++) {
      joints[i] = new Joint(jointNames[i], i); 
    }
  }

  void drawJoints() {
    for(int i = 0; i < joints.length; i++) {
      joints[i].drawJoint();
    }
  }
  
  float getRightHandX() {
    return joints[0].getX();
  }
  
  float getRightHandY() {
    return joints[0].getY();
  }
  
  float getLeftHandX() {
    return joints[1].getX();
  }
  
  float getLeftHandY() {
    return joints[1].getY();
  }
  // /<joint>_trackjointpos works as a keepalive to keep joint 
  // positions spitting out of the Synapse app. I do this 
  // because I want to avoid spewing out every joint position 
  // in every space every frame, because that could potentially 
  // cause packet loss. 
  // Instead, you pick and choose which joint positions you 
  // want to track. You must tell Synapse every 2-3 seconds that
  // you want to track a joint position to keep it spewing joint 
  // positions out. 
  // Valid values to pass are: 1, to get _pos_body positions; 
  // 2, to get _pos_world positions; and 3, to get _pos_screen positions.
  void pingJoints(int mode) {
    for(int i = 0; i < joints.length; i++) {
      joints[i].setTrackJointPos(mode);
    }
  }
  
  void check(OscMessage theOscMessage) {
    for(int i = 0; i < joints.length; i++) {
     if(joints[i].checkOsc(theOscMessage) != 0) return;
    }
  }
  
  void update() {
    if(millis() - lastTime > 2000) {
      // get screen points
      pingJoints(3);
      lastTime = millis();
    }
  }
  
  void drawSkeleton() {
    
    drawJoints();
    drawBones();
  }

  void drawBones() {
    // right hand to right elbow
    if(joints[0].track && joints[2].track) {
      line(joints[0].posX, joints[0].posY, joints[2].posX,joints[2].posY);
    }
    // right elbow to right hand
    if(joints[2].track && joints[11].track) {
      line(joints[2].posX, joints[2].posY, joints[11].posX,joints[11].posY);
    }
    // left elbow to left hand
    if(joints[3].track && joints[1].track) {
      line(joints[3].posX, joints[3].posY, joints[1].posX,joints[1].posY);
    }
    // left shoulder to torso
    if(joints[10].track && joints[3].track) {
      line(joints[10].posX, joints[10].posY, joints[3].posX,joints[3].posY);
    }
    // right shoulder to torso
    if(joints[11].track && joints[9].track) {
      line(joints[11].posX, joints[11].posY, joints[9].posX,joints[9].posY);
    }
    // left shoulder to right shoulder
    if(joints[10].track && joints[11].track) {
      line(joints[10].posX, joints[10].posY, joints[11].posX,joints[11].posY);
    }
    // left shoulder to torso
    if(joints[10].track && joints[9].track) {
      line(joints[10].posX, joints[10].posY, joints[9].posX,joints[9].posY);
    }
    // torso to head
    if(joints[9].track && joints[8].track) {
      line(joints[9].posX, joints[9].posY, joints[8].posX,joints[8].posY);
    }
    // left hip to torso
    if(joints[12].track && joints[9].track) {
      line(joints[12].posX, joints[12].posY, joints[9].posX,joints[9].posY);
    }
    // right hip to torso
    if(joints[13].track && joints[9].track) {
      line(joints[13].posX, joints[13].posY, joints[9].posX,joints[9].posY);
    }
    // right hip to right knee
    if(joints[13].track && joints[6].track) {
      line(joints[13].posX, joints[13].posY, joints[6].posX,joints[6].posY);
    }
    // left hip to left knee
    if(joints[12].track && joints[7].track) {
      line(joints[12].posX, joints[12].posY, joints[7].posX,joints[7].posY);
    }
    // right foot to right knee
    if(joints[4].track && joints[6].track) {
      line(joints[4].posX, joints[4].posY, joints[6].posX,joints[6].posY);
    }
    // left foot to left knee
    if(joints[5].track && joints[7].track) {
      line(joints[5].posX, joints[5].posY, joints[7].posX,joints[7].posY);
    }
  }
  
  void trackHands() {
    numTrackJoints = 2;
    joints[0].track = true;
    joints[1].track = true;
    for(int i = 2; i < joints.length; i++) {
      joints[i].track = false;
    }
  }
  
  void trackBody() {
    numTrackJoints = joints.length;
    for(int i = 0; i < joints.length; i++) {
      joints[i].track = true;
    }
  }

}