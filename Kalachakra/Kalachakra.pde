import themidibus.*; //Import the midi library

MidiBus myBus; // The MidiBus
PImage img, display_img;
int timer, ticksPerRev, groove, w, h, channel, pitch, velocity;
float degPerFrame, fr, rpm, duration, durFrames;
float grooveWidth, radiusOffset;

void setup () {
 myBus = new MidiBus(this, 0, 1); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.
 channel = 0;
 velocity = 50;
 img = loadImage("Kalachakra-centered_half.tga");
 img.loadPixels();
 w = img.width;
 h = img.height;
 display_img = createImage(600, 600, RGB);
 display_img.copy(img, 0, 0, w, h, 0, 0, 600, 600);
 imageMode(CENTER);
 fr = 60.0;
 frameRate(fr);
 size (600, 600);
 timer = 0;
 rpm = 33.3;
 float rps = rpm/60;
 float rpf = rps/fr;
 ticksPerRev = int(60 * rpm);
 degPerFrame = 360 * rpf;
 duration = 18;  //duration in minutes
 int grooves = int(duration * rpm);
 grooveWidth = w/2/grooves;
 groove = 0;
 durFrames = int(18 * 60 * fr);
 radiusOffset = grooveWidth * (rps/fr);
 //noLoop();
 println(img.pixels.length);
 println(rps);
 println(rpf);
 println("deg per frame = " + 360  * rpf);
 println("durFrames: " + durFrames);
 println("grooveWidth: " + grooveWidth);
 println("radiusOffset: " + radiusOffset);
 println("width: " + w);
}

void draw() {
  background(26, 33, 49);
  pushMatrix();
  translate(display_img.width/2, display_img.height/2);
  rotate( radians(timer * degPerFrame));
  image(display_img, 0, 0);;
  popMatrix();
  float currAngle = radians(timer * degPerFrame);
  float currRadius = (w/2 - (timer * radiusOffset));
  int imgX = int((w/2) + (currRadius * cos(currAngle))); 
  int imgY = int((h/2) + (currRadius * sin(currAngle)));
  color currColor = img.get(imgX, imgY);
  fill(currColor);
  ellipse(300 + int((300*currRadius)/(w/2)), 300, 20, 20);
  pitch = int(hue(currColor));
  myBus.sendNoteOn(channel, pitch, velocity); // Send a Midi noteOn
  delay(50);
  myBus.sendNoteOff(channel, pitch, velocity); // Send a Midi nodeOff

  timer++;
  //println(currRadius);
}

void mousePressed() {
  noLoop();
}

void mouseReleased() {
  loop();
}

void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}
