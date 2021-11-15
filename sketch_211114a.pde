/**
 * Bouncy Bubbles  
 * based on code from Keith Peters. 
 * 
 * Multiple-object collision.
 */
 
 
int numBalls = 100;
float spring = 0.05;
float gravity = 0.03;
float friction = -0.9;
Ball[] balls = new Ball[numBalls];


void setup() {
  size(1900,2200);
  for (int i = 0; i < numBalls; i++) {
    balls[i] = new Ball(random(width), random(height), random(40, 40), i, balls);
  }
  
  noStroke();
  fill(255, 204);
  balls[0].store(new Message("tests"));

}

void draw() {
  line(0, 0, 500, 500);

  background(0);
  for (Ball ball : balls) {
    ball.collide();
    ball.move();
    ball.display();  
  }
  

}



class Message {
  String content;
 
  Message(String input) {
    content = input;
  }
}

class house
{
  float x, y;
  float w;
  float h;
  color houseColor=color(235,10,15);
  
  house(float xin, float yin, float win, float hin)
  {
    x=xin;
    y=yin;
    w=win;
    h=hin;
    
  }
}

class Ball {
  
  float x, y;
  float diameter;
  float speedMult = 2;
  float vx = random(-speedMult,speedMult);
  float vy = random(-speedMult,speedMult);
  int id;
  color ballColor = color(235, 10, 15);
  Message messageStore;
  Ball[] others;
 
  Ball(float xin, float yin, float din, int idin, Ball[] oin) {
    x = xin;
    y = yin;
    diameter = din;
    id = idin;
    others = oin;
  } 
  

  
  void collide() {
    for (int i = id + 1; i < numBalls; i++) {
      float dx = others[i].x - x;
      float dy = others[i].y - y;
      float distance = sqrt(dx*dx + dy*dy);
      float minDist = others[i].diameter/2 + diameter/2;
      //float minDist = 10;
      if (distance < 100 && distance > minDist && others[i].messageStore != null) {
        stroke(ballColor);
        line(others[i].x, others[i].y, this.x, this.y);
      }
      if (distance < minDist) { 
        stroke(30, 255, 0);
        line(others[i].x, others[i].y, this.x, this.y);
        passOn(others[i]);
        float angle = atan2(dy, dx);
        float targetX = x + cos(angle) * minDist;
        float targetY = y + sin(angle) * minDist;
        float ax = (targetX - others[i].x) * spring;
        float ay = (targetY - others[i].y) * spring;
        vx -= ax;
        vy -= ay;
        others[i].vx += ax;
        others[i].vy += ay;
      }
    }   
  }
  
  void passOn(Ball them) {
    if (!(messageStore == null)) {
      them.store(messageStore);
    }
    if (!(them.messageStore == null)) {
      this.store(them.messageStore);
    }
  }
  
  void store(Message input) {
    messageStore = input;
    ballColor = color(230);
  }
  
  void move() {
    x += vx;
    y += vy;
    if (x + diameter/2 > width) {
      x = width - diameter/2;
      vx *= friction; 
    }
    
    //if (x + diameter/2 > width/2 && x + diameter/2 < width/2 + 20 && y + diameter/2 > height/2) {
    //  vx *= friction; 
    //}
    //if (x + diameter/2 > width/2 && x + diameter/2 < width/2 + 20 && y + diameter/2 < height/2 + 40) {
    //  vx *= friction; 
    //}
    else if (x - diameter/2 < 0) {
      x = diameter/2;
      vx *= friction;
    }
    if (y + diameter/2 > height) {
      y = height - diameter/2;
      vy *= friction; 
    } 
    else if (y - diameter/2 < 0) {
      y = diameter/2;
      vy *= friction;
    }
  }
  
  void display() {
    stroke(0);
    fill(ballColor);
    ellipse(x, y, diameter, diameter);
  }
}
