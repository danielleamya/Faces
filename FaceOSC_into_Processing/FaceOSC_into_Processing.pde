/*

Danielle McPhatter | 2018 | Faces Assignment

An interactive audio tour through the main area on my apartment, 
where I do most, if not all, of my work in.

Sketch connects FaceOSC with Minim to create a real-time mixing 
experience through various field recordings of areas within the space.
 
*/


import oscP5.*;
OscP5 oscP5;

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim minim;
AudioPlayer roomSound;

AudioPlayer sink;
AudioPlayer microwave;
AudioPlayer fridge;

AudioPlayer tv;
AudioPlayer wine;

AudioPlayer keyboard;

// num faces found
int found;

// pose
float poseScale;
PVector posePosition = new PVector();
PVector poseOrientation = new PVector();

PImage room;


void setup() {
  room = loadImage("Room.JPG");
  size(640, 480);
  frameRate(30);

  minim = new Minim(this);
  roomSound = minim.loadFile("../Audio Files/Room Ambience.wav", 2048);
  keyboard = minim.loadFile("../Audio Files/Keyboard.wav", 2048);

  sink = minim.loadFile("../Audio Files/Sink.wav", 2048);
  microwave = minim.loadFile("../Audio Files/Microwave.wav", 2048);
  fridge = minim.loadFile("../Audio Files/Fridge.wav", 2048);

  tv = minim.loadFile("../Audio Files/TV.wav", 2048);
  wine = minim.loadFile("../Audio Files/Wine.wav", 2048);

  oscP5 = new OscP5(this, 8338);
  oscP5.plug(this, "found", "/found");
  oscP5.plug(this, "poseScale", "/pose/scale");
  oscP5.plug(this, "posePosition", "/pose/position");
  oscP5.plug(this, "poseOrientation", "/pose/orientation");

  keyboard.loop();

  sink.loop();
  microwave.loop();
  fridge.loop();

  tv.loop();
  wine.loop();
}

void draw() {  
  background(255);
  stroke(0);
  image(room, 0, 0);

  //--------------- LEFT SIDE ---------------\\

  // Sink
  if (posePosition.x > width/2 && posePosition.y > height/2) {
    float sinkX = map(posePosition.x, width - width/8, width/2, 6, -48);
    float sinkY = map(posePosition.y, height - height/8, height/2, 6, -48);
    float sinkVal = (sinkX+sinkY)/2;
    sink.setGain(sinkVal);
  } else {
    float sinkVal = -48; 
    sink.setGain(sinkVal);
  }

  // Microwave
  if (posePosition.x > width/2 && posePosition.x < width - width/4 && posePosition.y > height/4 && posePosition.y < height/2) {
    float microwaveX = map(posePosition.x, width - width/6, width/2, 48, -48);
    float microwaveY = map(posePosition.y, height/8, height/2, 48, -48);
    if (microwaveX > 0) {
      microwaveX = -microwaveX;
    }
    if (microwaveY > 0) {
      microwaveY = -microwaveY;
    }
    float microwaveVal = (microwaveX+microwaveY)/2;
    microwave.setGain(microwaveVal);
  } else {
    float microwaveVal = -48; 
    microwave.setGain(microwaveVal);
  }

  // Fridge
  if (posePosition.x < width*2/3 && posePosition.x > width/2 && posePosition.y > height/4 && posePosition.y < (height*4)/5) {
    float fridgeX = map(posePosition.x, width/2, width*2/3, 48, -48);
    float fridgeY = map(posePosition.y, height/4, height*4/5, 48, -48);
    if (fridgeX > 0) {
      fridgeX = -fridgeX;
    }
    if (fridgeY > 0) {
      fridgeY = -fridgeY;
    }
    float fridgeVal = (fridgeX+fridgeY)/2;
    println(fridgeVal);
    fridge.setGain(fridgeVal);
  } else {
    float fridgeVal = -48; 
    fridge.setGain(fridgeVal);
  }

  //----------------- CENTER -----------------\\

  // KEYBOARD
  if (posePosition.x <= width*2/3 && posePosition.x >= width/3 && posePosition.y > height/2) {
    float keyboardX = map(posePosition.x, width/3, width*2/3, 48, -48);
    float keyboardY = map(posePosition.y, height - height/8, height/3, 0, -48);
    if (keyboardX > 0) {
      keyboardX = -keyboardX;
    }
    float keyboardVal = (keyboardX+keyboardY)/2;
    keyboard.setGain(keyboardVal);
  } else {
    float keyboardVal = -48; 
    keyboard.setGain(keyboardVal);
  }

  //--------------- RIGHT SIDE ---------------\\

  // TV
  if (posePosition.x < width/2 && posePosition.y >= height/4 && posePosition.y <= (height*3/4)) {
    float tvX = map(posePosition.x, 0 + width/8, width/2 + width/8, -12, -48);
    float tvY = map(posePosition.y, height/4, height*3/4, 48, -48);
    if (tvY > 0) {
      tvY = -tvY;
    }
    float tvVal = (tvX+tvY)/2;
    tv.setGain(tvVal);
  } else {
    float tvVal = -48; 
    tv.setGain(tvVal);
  } 

  // Wine
  if (posePosition.x < width/2 && posePosition.x > width/3 && posePosition.y > height/3 && posePosition.y < (height*2)/3) {
    float wineX = map(posePosition.x, width/2, width/3, 48, -48);
    float wineY = map(posePosition.y, height/3, height*2/3, 48, -48);
    if (wineX > 0) {
      wineX = -wineX;
    }
    if (wineY > 0) {
      wineY = -wineY;
    }
    float wineVal = (wineX+wineY)/2;
    println(wineVal);
    wine.setGain(wineVal);
  } else {
    float wineVal = -48; 
    wine.setGain(wineVal);
  }
}

// OSC CALLBACK FUNCTIONS

public void found(int i) {
  println("found: " + i);
  found = i;
}

public void poseScale(float s) {
  println("scale: " + s);
  poseScale = s;
}

public void posePosition(float x, float y) {
  println("pose position\tX: " + x + " Y: " + y );
  posePosition.set(x, y, 0);
}

public void poseOrientation(float x, float y, float z) {
  println("pose orientation\tX: " + x + " Y: " + y + " Z: " + z);
  poseOrientation.set(x, y, z);
}
