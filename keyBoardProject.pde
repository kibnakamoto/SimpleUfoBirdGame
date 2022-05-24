

String ufoOrBird = "";
float playerX;
float playerY;
float eUfoY;
float dec; // decrement shooting laserX
float laserX;
float laserY;
boolean upPressed = false;
boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;
long score = 0;
boolean playerShot = false;
long prevScore = score;
boolean resettedPlayerShot;

void setup() {
    size(400,400);
    
    // player starting location
    playerX = width/10*2;
    playerY = height/10*5;
    eUfoY = playerY;
}

// draw UFO that follows keys. Move up and down like flappy bird
void drawUFO(float ufoX, float ufoY) {
    push();
    rectMode(CENTER);
    
    // draw body
    fill(148, 142, 142);
    ellipse(ufoX,ufoY,width/10*2,height/10*.8);
    
    // draw green lights
    fill(44, 237, 40);
    ellipse(ufoX-width/10*.53,ufoY*.99,width/10*.4,
            height/10*.4);
    ellipse(ufoX,ufoY*.99,width/10*.4,height/10*.4);
    ellipse(ufoX+width/10*.53,ufoY*.99,width/10*.4,
            height/10*.4);
    
    // draw glass
    fill(6, 144, 199,99);
    arc(ufoX,ufoY-height/10*.3,width/10*1.5,
        height/10*2,PI,TWO_PI);
    pop();
}

// difficulty
long difficulty = 2000; // choose difficulty using mouse input

// laser timer
float millis = millis();


// shooting enemy ufo. Avoid its shots
void drawEnemyUfo(float ufoX,float ufoY) {
    drawUFO(ufoX,ufoY); // body of ufo
    /* x coordinate should be constant */

    if(millis() <= millis+2000) {
      // draw lasers
      fill(199, 22, 6);
      rect(laserX,laserY,width/10*1,
           height/10*.1,10);
      if(laserX > -width/10) {
          laserX-=3.5;
      }
      
    } else {
        laserX = ufoX-width/10;
        laserY = ufoY;
        millis = millis(); // reset millis
    }
    
    // laser shooting gun
    fill(20,20,20);
    rect(ufoX-width/10*1.5,ufoY+height/10*.05,width/10*.8,height/10*.08,4);
    
}

void drawBird(float birdX, float birdY) {
    // body
    fill(219, 191, 29);
    ellipse(birdX,birdY,width/10,height/10*.8);
    
    // eyes
    fill(0xff,0xff,0xff);
    ellipse(birdX+width/10*.2,birdY-height/10*.1,width/10*.25,height/10*.22);
    fill(5,5,5);
    ellipse(birdX+width/10*.2,birdY-height/10*.1,width/10*.1,height/10*.09);
    
    // nose
    fill(219, 144, 22);
    triangle(birdX+width/10*.75,birdY,birdX+width/10*.45,
             birdY+height/10*.05,birdX+width/10*.45,birdY-height/10*.05);
    
    // feet
    fill(0,0,0);
    rect(birdX+width/10*.1,birdY+height/10*.4,width/10*.03,height/10*.3);
    
    push();
    noStroke();
    translate(birdX+width/10*.1,birdY+height/10*.5);
    for(int c=1;c<4;c++) {
      if(c != 3) {
          rotate(40 + 30/c);
          rect(0,0,width/10*.03,height/10*.2);
      }
    }
    pop();
    fill(0,0,0);
    rect(birdX-width/10*.2,birdY+height/10*.4,width/10*.03,height/10*.3);
    
    push();
    noStroke();
    translate(birdX-width/10*.2,birdY+height/10*.5);
    for(int c=1;c<4;c++) {
      if(c != 3) {
          rotate(40 + 30/c);
          rect(0,0,width/10*.03,height/10*.2);
      }
    }
    pop();
}

void drawBackground() {
    background(#87ceeb);

    // draw grass
    fill(#567d46);
    rect(0,height/10*8,width,height/10*2);
}

boolean started = false;
float strokeWeight1 = 3;
float strokeWeight2 = 3;
boolean mouseMoved;

void drawStartMenu() {
    background(50, 141, 168);
    textSize(20);
    push();
    fill(52, 219, 235);
    stroke(1);
    strokeWeight(strokeWeight1);
    rect(width/10*1.2,height/10*7.8,width/10*3,height/10*1);
    strokeWeight(strokeWeight2);
    rect(width/10*6,height/10*7.8,width/10*3,height/10*1);
    pop();
    fill(0,0,0);
    text("START", width/10*2,height/10*8.5);
    text("EXIT", width/10*7,height/10*8.5);
    
    textSize(30);
    text("          Welcome\n   to Keyboard Project!", width/10*.5,height/10*3.5);
    
    /* click start on screen, to start, exit to exit */
}

void drawPauseMenu() {
    background(50, 141, 168);
    textSize(40);
    text("PAUSED", width/10*3,height/10*5);
    textSize(25);
    text("press \"ENTER\" to continue", width/10*1,height/10*7);
}

float currentUfoX;
float currentUfoY;
int scoreCount = 0;

void draw() {     
    if(started) {
        drawBackground();
        
        // press u or type ufo for ufo and b or type bird for bird or use top nav bar
        if(ufoOrBird.contains("b") || ufoOrBird.contains("bird")) {
            drawBird(playerX,playerY);
        } else { // ufo as default game character
            drawUFO(playerX,playerY); // player UFO
        }
        playerY+=3;
        // if crashed on grass
        if(playerY >= height/10*8) {
            playerY = height/10*8;
            playerX = currentUfoX;
            if(playerY <= height/10*9 || playerX <= currentUfoX) {
                playerY = height/10*8.5;
            }
            playerShot = true;
            laserX = -width/10*1;
            fill(0,0,0);
            textSize(25);
            text("GAME OVER", width/10*3,height/10*5);
        } else {
            currentUfoX = playerX;
            currentUfoY = playerY;
            
            // flappy bird style animation
            if(keyPressed && !playerShot) {
                if(upPressed) {
                  if(playerY >= height-height/10*8) {
                      for(int c=0;c<40;c+=10)
                          playerY-=c;
                  }
                    upPressed=false;
                }
                if (downPressed) {
                    playerY+=10;
                    downPressed = false;
                }
                if(leftPressed){
                    if(playerX >= width-width/10*9.5)
                        playerX-=3;
                }
                if(rightPressed){
                    playerX+=3;
                }
            }
        }
        drawEnemyUfo(width/10*8.2,eUfoY);
        
        if(eUfoY <= playerY) {
            if(eUfoY <= height/10*7.5)
               eUfoY+=1.8;
        } else {
            eUfoY-=1.8;
        }
        
        // press control to reset to ofu or inputted keys
        if(keyCode == CONTROL) {
            ufoOrBird = "";
        }
        
        // more gravity
        if(playerY <= height/10*6 && playerY >= height/10*8) {
            playerY+=1.5;
        } else if(playerY <= height/10*4 && playerY >= height/10*6) {
            playerY+=1;
        }  else if(playerY <= height/10*2 && playerY >= height/10*4) {
            playerY+=.6;
        }  else if(playerY <= height && playerY >= height/10*8) {
            playerY-=2;
        }
        
        // screen limit with enemy ufo
        if(playerX >= width-width/3 && playerY <= height-height/10*.8) {
            playerX-=3;
        }
        
        // game over if player is shot
        if(ufoOrBird.contains("b") || ufoOrBird.contains("bird")) { // if bird
            if(playerX-3 <= laserX+width/10*.8 &&
               playerX-3 >= laserX-width/10*.8 &&
               playerY <= laserY+height/10*.2 &&
               playerY >= laserY-height/10*.6) {
               laserX = -width/10*1;
               playerX-=1.5;
               playerShot = true;
            }
        } else { // if ufo
            if(playerX <= laserX+width/10*1 &&
               playerX >= laserX-width/10*1 &&
               playerY <= laserY+height/10*1 &&
               playerY >= laserY-height/10*.1) {
               laserX = -width/10*1;
               playerShot = true;
               playerX-=1.5;
            }
        }
        
        // should player get point?
        if(laserX <= -width/10*1 && !playerShot) {
             scoreCount++;
             if(score < prevScore+10) {
                 score++;
             } else {
                 laserX = width/10*20;
                 laserY = height/10*20;
                 prevScore = score;
                 if(scoreCount*10 != score && prevScore%10 != 0) {
                     score -= score % 10;
                 }  else if(prevScore >= score || scoreCount*10 < score) {
                     prevScore -= score-prevScore;
                 }
             }
        }
        
        // print current input
        println("current input:\t" + ufoOrBird);
        
        // print score on screen
        push();
        textSize(25);
        fill(0xf0,0,0);
        text("score: " + score, width/10*6,height/10*1.5);
        pop();
    } else {
        drawStartMenu();
    }
     if(ufoOrBird.contains("exit")) {
         exit();
     }
}

// if key = r, reset game
void keyPressed() {
    if(key == 'r') {
        playerX = width/10*2;
        playerY = height/10*2;
        playerShot = false;
        score = 0;
        prevScore = score;
    }
    
    if(keyCode == ENTER) {
        playerX = width/10*2;
        playerY = height/10*2;
        playerShot = false;
        score = 0;
        prevScore = score;
        if(looping) {
            noLoop();
            drawPauseMenu();
        } else {
            loop();
        }
    }
    
    if (keyCode == UP) {
        upPressed = true;
    }
    else if (keyCode == DOWN) {
        downPressed = true;
    }
    else if (keyCode == LEFT) {
        leftPressed = true;
    }
    else if (keyCode == RIGHT) {
        rightPressed = true;
  }
}

void keyReleased() {
    if (keyCode == UP) {
      upPressed = false;
    }
    else if (keyCode == DOWN) {
      downPressed = false;
    }
    else if (keyCode == LEFT) {
      leftPressed = false;
    }
    else if (keyCode == RIGHT) {
      rightPressed = false;
    }
    
}

// get bird/b for ufo
void keyTyped() {
    ufoOrBird += key;
}

// set difficulty
void mouseWheel(MouseEvent event) {
    float upOrDown = event.getCount();
    if(upOrDown < 0) {
        difficulty -= 3;
    } else if(upOrDown > 0) {
        difficulty += 3;
    }
}

void mouseMoved() {
    if(mouseX <= width/10*4.2 && mouseX > width/10*1.2 &&
       mouseY > height/10*7.8 && mouseY <= height/10*8.8) {
       strokeWeight1 = 1.5;
    } else {
       strokeWeight1 = 3;
    }
    
    if(mouseX <= width/10*9 && mouseX > width/10*6 &&
       mouseY > height/10*7.8 && mouseY <= height/10*8.8) {
       strokeWeight2 = 1.5;
    } else {
       strokeWeight2 = 3;
    }
}

void mousePressed() {
    if(mouseX <= width/10*4.2 && mouseX > width/10*1.2 &&
       mouseY > height/10*7.8 && mouseY <= height/10*8.8) {
        if(mouseButton == LEFT) {
            started = true;
        }
    }
    
    if(mouseX <= width/10*9 && mouseX > width/10*6 &&
       mouseY > height/10*7.8 && mouseY <= height/10*8.8) {
        if(mouseButton == LEFT) {
            exit();
        }
    }
}
