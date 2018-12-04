import processing.pdf.*;
import g4p_controls.*;

final int FAST_PARTICLES_COUNT = 7000;
final int SLOW_PARTICLES_COUNT = 15000;

float BUBBLE_RADIUS; // set in setup after size initialization
int FAST_PARTICLES_COLOR_BEGIN = 200;
int FAST_PARTICLES_COLOR_END = 200;
int SLOW_PARTICLES_COLOR_BEGIN = 180;
int SLOW_PARTICLES_COLOR_END = 230;

GSlider  fastParticlesColorBegin;
GSlider  fastParticlesColorEnd;
GSlider  slowParticlesColorBegin;
GSlider  slowParticlesColorEnd;

class Particle {
  float x;
  float y;
  color c;
  float distanceFromCenter = 0;
  float t;
  float speed;
  float size;
  float life;
  
  color generateColor() {
    if (FAST_PARTICLES_COLOR_BEGIN <= FAST_PARTICLES_COLOR_END) {
      return color(random(FAST_PARTICLES_COLOR_BEGIN, FAST_PARTICLES_COLOR_END), 80, 100);
    }
    else {
      return color(random(FAST_PARTICLES_COLOR_BEGIN, FAST_PARTICLES_COLOR_END + 360), 80, 100);
    }
  }
  
  void reset() {
    x = width / 2;
    y = height / 2 + BUBBLE_RADIUS;
    c = generateColor();
    distanceFromCenter = random(-BUBBLE_RADIUS, +BUBBLE_RADIUS);
    speed = random(0.0001, 0.03);
    size = random(1, 2);
    life = random(1.4 * PI, random(0.9, PI));
    t = 0;
  }

  void update() {
    float angle = PI * 0.5;
    angle += (distanceFromCenter < 0 ? -t : +t);
    float amplitude = abs(distanceFromCenter);
    
    x = cos(angle) * amplitude + width / 2;
    y = sin(angle) * BUBBLE_RADIUS + height / 2;  
    
    if ((int)t % 50 == 0) {
      c = generateColor();
    }
    float addspeed = speed + map(mouseY, 0, height, 0.0, 0.1);
    t += addspeed;
    speed *= 1.0001;
    if (t >= life){
      reset();
    }
  }

  void draw() {
    fill(c, (PI - t - PI / 25) * 255); 
    float drawSize = abs(sin(t)) * size + 1;
    rect(x, y, drawSize, drawSize);
  }
}

class SlowParticle extends Particle {
  
  color generateColor() {
    if (SLOW_PARTICLES_COLOR_BEGIN <= SLOW_PARTICLES_COLOR_END) {
      return color(random(SLOW_PARTICLES_COLOR_BEGIN, SLOW_PARTICLES_COLOR_END), 80, 100);
    }
    else {
      return color(random(SLOW_PARTICLES_COLOR_BEGIN, SLOW_PARTICLES_COLOR_END + 360), 80, 100);
    }
  }
  
  void reset() {
    x = width / 2;
    y = height / 2 + BUBBLE_RADIUS;
    c = generateColor();
    distanceFromCenter = random(-BUBBLE_RADIUS, +BUBBLE_RADIUS);
    speed =random(0.001, 0.01);
    size = random(1, 2.4);
    life = random(0, 0.5 * PI * pow((abs(distanceFromCenter) / BUBBLE_RADIUS), 3.5)) + random(0.2 * PI, 0.4 * PI);
    t = 0;
  }
  
  void update() {
    float angle = PI * 0.5;
    angle += (distanceFromCenter < 0 ? -t : +t);
    float amplitude = abs(distanceFromCenter);

    x = cos(angle) * amplitude + width / 2;
    y = sin(angle) * BUBBLE_RADIUS + height / 2;  
    if ((int)t % 50 == 0) {
      c = generateColor();
    }
    t += size * 0.002 + map(mouseX, 0, width, 0.0, 0.1);
    speed *= 1.0001;
    if (t >= life){
      reset();
    }
  }
  
  void draw() {
    fill(c, (PI - t - PI / 25) * 255);
    float drawSize = abs(sin(t)) * size + 1;
    rect(x, y, drawSize, drawSize);
  }
}

class Bubble {
  Particle[] particles = new Particle[FAST_PARTICLES_COUNT];
  SlowParticle[] slowParticles = new SlowParticle[SLOW_PARTICLES_COUNT];
  
  Bubble() { 
    for (int i = 0; i < particles.length; i++) {
      Particle p = new Particle();
      p.reset();
      particles[i] = p;
    }
    
    for (int i = 0; i < slowParticles.length; i++) {
      SlowParticle p = new SlowParticle();
      p.reset();
      slowParticles[i] = p;
    }
  }
  
  void update() {
    for (SlowParticle p : slowParticles) {
      p.update();
    }
    
    for (Particle p : particles) {
      p.update();
    }
  }
  
  void draw() {
    noStroke();
    for (Particle p : slowParticles) {
      p.draw();
    }
    
    for (Particle p : particles) {
      p.draw();
    }
    
    noFill();
    strokeWeight(1);
    stroke(#0099FF, 128);
   // ellipse(width / 2, height / 2, BUBBLE_RADIUS, BUBBLE_RADIUS);
  }
}

Bubble bubble;
boolean takeScreenshot = false;
boolean isGUIVisible = false;
boolean isHelpAlwaysVisible = true;
boolean isRecording = false;

void setup() {
  //fullScreen(P3D);
  size(800, 600, P3D);
  colorMode(HSB, 360, 100, 100, 100);
  ellipseMode(RADIUS);
  rectMode(CENTER);
  blendMode(ADD);
  textAlign(LEFT, TOP);
  frameRate(60);
  background(0);
  
  BUBBLE_RADIUS = height * 0.45;
  bubble = new Bubble();
  
  float sliderWidth = width * 0.3;
  float sliderHeight = height * 0.02;
  
  fastParticlesColorBegin = new GSlider(this, 0, sliderHeight * 1, sliderWidth, 10, 7);
  fastParticlesColorBegin.setLimits(FAST_PARTICLES_COLOR_BEGIN, 0, 360);
  fastParticlesColorBegin.addEventHandler(this, "changeFastParticlesColorBegin");
  fastParticlesColorBegin.setShowValue(true);
  
  fastParticlesColorEnd = new GSlider(this, 0, sliderHeight * 3, sliderWidth, 10, 7);
  fastParticlesColorEnd.setLimits(FAST_PARTICLES_COLOR_END, 0, 360);
  fastParticlesColorEnd.addEventHandler(this, "changeFastParticlesColorEnd");
  
  slowParticlesColorBegin = new GSlider(this, 0, sliderHeight * 5, sliderWidth, 10, 7);
  slowParticlesColorBegin.setLimits(SLOW_PARTICLES_COLOR_BEGIN, 0, 360);
  slowParticlesColorBegin.addEventHandler(this, "changeSlowParticlesColorBegin");
  
  slowParticlesColorEnd = new GSlider(this, 0, sliderHeight * 7, sliderWidth, 10, 7);
  slowParticlesColorEnd.setLimits(SLOW_PARTICLES_COLOR_END, 0, 360);
  slowParticlesColorEnd.addEventHandler(this, "changeSlowParticlesColorEnd");
  
  changeVisibilityGUI();
}

void draw() {
  if (takeScreenshot) {
    beginRecord(PDF, "screenshot-####.pdf");
  }
  noStroke();
  //fill(#000000, 192);
  //rect(width / 2, height / 2, width, height);
  background(0);
  
  if (!isGUIVisible) {
    fill(#ffffff);
    if (isHelpAlwaysVisible) {
      text("Mouse adds speed to particles on both axes. Press v to show/hide options.", 0, 0);
      text("Press c to hide this.", 0, 15);
      text("Press s to take screenshot to pdf.", 0, 30);
      text("Press r to start/stop recording frames to png.", 0, 30);
    }  
  }
  else {
    fill(#ffffff);
    float sliderHeight = height * 0.02;
    text("Fast particles color begin", 0, sliderHeight * 0);
    text("Fast particles color end", 0, sliderHeight * 2);
    text("Slow particles color begin", 0, sliderHeight * 4);
    text("Slow particles color end", 0, sliderHeight * 6);
  }

  bubble.update();
  bubble.draw();
  
  if (takeScreenshot) {
    endRecord();
    takeScreenshot = false;
  }
  
  if (isRecording) {
    saveFrame("frame-####.png");
    noStroke();
    fill(#ff0000);
    ellipse(width - 15, 15, 7, 7);
  }
  println(frameRate);
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    takeScreenshot = true;
  }
  
  if (key == 'v' || key == 'V') {
    isGUIVisible = !isGUIVisible;
    changeVisibilityGUI();
  }
  
  if (key == 'c' || key == 'C') {
    isHelpAlwaysVisible = !isHelpAlwaysVisible;
  }
  
  if (key == 'r' || key == 'R') {
    isRecording = !isRecording;
  }
}

void changeVisibilityGUI() {
  fastParticlesColorBegin.setVisible(isGUIVisible);
  fastParticlesColorEnd.setVisible(isGUIVisible);
  slowParticlesColorBegin.setVisible(isGUIVisible);
  slowParticlesColorEnd.setVisible(isGUIVisible);
}

void changeFastParticlesColorBegin(GSlider source, GEvent event) {
  FAST_PARTICLES_COLOR_BEGIN = source.getValueI();
}

void changeFastParticlesColorEnd(GSlider source, GEvent event) {
  FAST_PARTICLES_COLOR_END = source.getValueI();
}

void changeSlowParticlesColorBegin(GSlider source, GEvent event) {
  SLOW_PARTICLES_COLOR_BEGIN = source.getValueI();
}

void changeSlowParticlesColorEnd(GSlider source, GEvent event) {
  SLOW_PARTICLES_COLOR_END = source.getValueI();
}
