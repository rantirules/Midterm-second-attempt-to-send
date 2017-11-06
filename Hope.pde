
import org.openkinect.processing.*;

// Kinect Library object
Kinect2 kinect2;

// Angle for rotation
float rotationRads = 3.1;
float spacing = width;

ParticleSystem ps;

import ddf.minim.*;

Minim minim;
AudioPlayer player;


void setup() {

  // Rendering in P3D
  //fullScreen(P3D);
  size(800, 424, P3D);

  kinect2 = new Kinect2(this);
  kinect2.initDepth();
  kinect2.initDevice();

  smooth(16);
    ps = new ParticleSystem(new PVector(width/2, 50));
    minim = new Minim(this);
    //player = minim.loadFile()******************

}


void draw() {
  background(0);
ps.addParticle(mouseX, mouseY);
  ps.run();
fill(102);
  stroke(255);
  for( float line_x = 0; line_x < width; line_x = line_x + spacing) {
    line(line_x, 0, line_x, height);
fill(255, 0, 0);
rect(120, 50, 50, 75);

  // Translate and rotate
  pushMatrix();
  translate(width/2, height/2, 50);
  rotateY(rotationRads);

  // We're just going to calculate and draw every 2nd pixel
  int skip = 5;

  // Get the raw depth as array of integers
  int[] depth = kinect2.getRawDepth();

  stroke(255);
  beginShape(POINTS);
  for (int x = 0; x < kinect2.depthWidth; x += skip) {
    for (int y = 0; y < kinect2.depthHeight; y += skip) {
      int offset = x + y * kinect2.depthWidth;

      //calculte the x, y, z camera position based on the raw depth data
      PVector point = depthToPointCloudPos(x, y, depth[offset]);

      // Draw a point
      //print(point.z);
      vertex(point.x, point.y, point.z);
    }
  }
  endShape();

  //pop the matrix scene, reset translation and rotation
  popMatrix();


  //drawFrustum();
  
  //Rotate()
  //rotationRads += 0.0015f;
}

//draw camera frustum
//void drawFrustum(){

}

//calculation the xyz camera position based on the depth data
PVector depthToPointCloudPos(int x, int y, float depthValue) {
  PVector point = new PVector();
  point.z = (depthValue);// / (1.0f); // Convert from mm to meters
  point.x = (x - CameraParams.cx) * point.z / CameraParams.fx;
  point.y = (y - CameraParams.cy) * point.z / CameraParams.fy;
  return point;
}
