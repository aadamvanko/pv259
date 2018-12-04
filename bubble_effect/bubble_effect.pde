import processing.pdf.*;

float BUBBLE_RADIUS; // set in setup after size initialization
final int FAST_PARTICLES_COLOR_BEGIN = 180;
final int FAST_PARTICLES_COLOR_END = 330;
final int SLOW_PARTICLES_COLOR_BEGIN = 180;
final int SLOW_PARTICLES_COLOR_END = 230;

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
    return color(random(FAST_PARTICLES_COLOR_BEGIN, FAST_PARTICLES_COLOR_END), 80, 100);
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
    return color(random(SLOW_PARTICLES_COLOR_BEGIN, SLOW_PARTICLES_COLOR_END), 80, 100);
  }
  
  void reset() {
    x = width / 2;
    y = height / 2 + BUBBLE_RADIUS;
    c = generateColor();
    distanceFromCenter = random(-BUBBLE_RADIUS, +BUBBLE_RADIUS);
    speed =random(0.001, 0.01);
    size = random(1, 3);
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
    rect(x, y, size, size);
  }
}

class Bubble {
  Particle[] particles = new Particle[7000];
  SlowParticle[] slowParticles = new SlowParticle[15000];
  
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

void setup() {
  //fullScreen(P2D);
  size(800, 600, P3D);
  colorMode(HSB, 360, 100, 100, 100);
  ellipseMode(RADIUS);
  rectMode(CENTER);
  blendMode(ADD);
  frameRate(60);
  background(0);
  
  BUBBLE_RADIUS = height * 0.45;
  bubble = new Bubble();
}

void draw() {
  if (takeScreenshot) {
    beginRecord(PDF, "frame-####.pdf");
  }
  noStroke();
  //fill(#000000, 192);
  //rect(width / 2, height / 2, width, height);
  background(0);

  bubble.update();
  bubble.draw();
  
  if (takeScreenshot) {
    endRecord();
    takeScreenshot = false;
  }
  println(frameRate);
}

void keyPressed() {
  if (key == 's' || key == 'S') takeScreenshot = true;
}
