float BUBBLE_RADIUS;
float PARTICLE_SIZE;

class Particle {
  float x;
  float y;
  color c;
  float distanceFromCenter = 0;
  float t;
  float speed;
  float s;
  float life;
  float ax = 0;
  float ay = 0;

  color generateColor() {
    //return color(random(rmin, rmax), random(gmin, gmax), random(bmin, bmax));
    return color(random(180, 330), 80, 100);
  }
  
  
  void reset() {
    x = width / 2;
    y = height / 2 + BUBBLE_RADIUS;
    c = generateColor();
    distanceFromCenter = random(-BUBBLE_RADIUS, +BUBBLE_RADIUS);//random((2 * BUBBLE_RADIUS / (particles.length - 1)) * i - BUBBLE_RADIUS);
    speed = /*pow((BUBBLE_RADIUS - abs(distanceFromCenter)) / abs(distanceFromCenter), 1.1) * 0.25 + 0.01;*/random(0.0001, 0.03);//map(abs(distanceFromCenter), 0, 240, 0.00001, 0.03);//random(0.005, 0.05);
    s = random(1, 3);
    life = random(1.4 * PI, random(0.9, PI));
    t = 0;
  }

  void update() {
    float angle = PI * 0.5;
    angle += (distanceFromCenter < 0 ? -t : +t);
    float amplitude = abs(distanceFromCenter);
    
    float dx = x - mouseX;
    float dy = y - mouseY;
    float r = 200;
    float rr = r * r;
    float dd = (dx * dx) + (dy * dy);
    float d = sqrt(dd);
    float sx = sin(angle) * BUBBLE_RADIUS;
    float sy = cos(angle) * BUBBLE_RADIUS;
    
    x = cos(angle) * amplitude + width / 2;
    y = sin(angle) * BUBBLE_RADIUS + height / 2;  
    
    //println(x, y);  
    
    
    if ((int)t % 50 == 0) {
      c = generateColor();
    }
    float addspeed = speed  + map(mouseY, 0, height, 0.0, 0.1);
    t += addspeed;//s * 0.0035 + /*pow(abs(sin(frameCount * 0.05)), 2)*/ + map(mouseY, 0, height, 0.0, 0.1);
    speed *= 1.0001;
    if (t >= life){
      reset();
    }
  }

  void draw() {
    fill(c, (PI - t - PI / 25) * 255); //, (PI - t - PI / 20) * 255
    float size = abs(sin(t)) * s + 1;//sin(t) * PARTICLE_SIZE + 1;
    rect(x, y, size, size);
  }
}

class SlowParticle extends Particle {
  color generateColor() {
    //return color(random(rmin, rmax), random(gmin, gmax), random(bmin, bmax));
    return color(random(180, 230), 80, 100);
  }
  
  void reset() {
    x = width / 2;
    y = height / 2 + BUBBLE_RADIUS;
    c = generateColor();
    distanceFromCenter = random(-BUBBLE_RADIUS, +BUBBLE_RADIUS);//random((2 * BUBBLE_RADIUS / (particles.length - 1)) * i - BUBBLE_RADIUS);
    speed =random(0.001, 0.01);//map(abs(distanceFromCenter), 0, 240, 0.00001, 0.03);//random(0.005, 0.05);
    s = random(1, 3);
    float f = 3.5;
    life = random(0, 0.5 * PI * pow((abs(distanceFromCenter) / BUBBLE_RADIUS), f)) + random(0.2 * PI, 0.4 * PI);
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
    t += s * 0.002 + /*pow(abs(sin(frameCount * 0.05)), 2)*/ + map(mouseX, 0, width, 0.0, 0.1);
    speed *= 1.0001;
    if (t >= life){
      reset();
    }
  }
  
  void draw() {
    fill(c, (PI - t - PI / 25) * 255); //, (PI - t - PI / 20) * 255
    float size = s;//sin(t) * PARTICLE_SIZE + 1;
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
    /*beginShape(LINES);
    int sidesCount = 50;
    for (int i = 0; i < sidesCount; i++) {
      for (int j = 0; j < 2; j++) {
        float angle = TWO_PI * 10 / sidesCount * (i + j);
        float x = cos(angle) * BUBBLE_RADIUS + (cos(frameCount * 0.05 + angle)) * 15 + width / 2;
        float y = sin(angle) * BUBBLE_RADIUS + (sin(frameCount * 0.05 + angle)) * 15 + height / 2;
        vertex(x, y);
        println(x, y);
      }
    }
    endShape();*/
   // ellipse(width / 2, height / 2, BUBBLE_RADIUS, BUBBLE_RADIUS);
  }
}

Bubble bubble;

void setup() {
  fullScreen(P2D);
  //size(1500, 1500, P3D);
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
  noStroke();
  //fill(#000000, 192);
  //rect(width / 2, height / 2, width, height);
  background(0);

  bubble.update();
  bubble.draw();
  
  println(frameRate);
}
