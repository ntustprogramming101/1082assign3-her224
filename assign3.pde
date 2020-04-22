//game state
final int GAME_START = 0, GAME_RUN = 1, GAME_OVER = 2;
int gameState = 0;
//grass
final int GRASS_HEIGHT = 15;
//button
final int START_BUTTON_W = 144;
final int START_BUTTON_H = 60;
final int START_BUTTON_X = 248;
final int START_BUTTON_Y = 360;
//image
PImage title, gameover, startNormal, startHovered, restartNormal, restartHovered;
PImage bg, soil8x24, cabbage, ghDown, ghIdle, ghLeft, ghRight, life, soldier;
PImage soil0, soil1, soil2, soil3, soil4, soil5, stone1, stone2;
//key
boolean upPressed = false;
boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;
//general
int frame = 0;
float baseLine = 2.0;
float baseLineLast = 0.0;
final float blockSize = 80.0;
float blockCoordinateX = 4.0;
float blockCoordinateY = 1.0;
int timeNow, timeLast;
//groundHog
float ghX = blockCoordinateX * blockSize;
float ghY = blockCoordinateY * blockSize;

// For debug function; DO NOT edit or remove this!
int playerHealth = 0;
float cameraOffsetY = 0;
boolean debugMode = false;

void setup() {
	size(640, 480, P2D);
  // Initial health.
  playerHealth = 2;
  // Load images.
	bg = loadImage("img/bg.jpg");
  cabbage = loadImage("img/cabbage.png"); 
  ghDown = loadImage("img/groundhogDown.png"); 
  ghIdle = loadImage("img/groundhogIdle.png"); 
  ghLeft = loadImage("img/groundhogLeft.png"); 
  ghRight = loadImage("img/groundhogRight.png");
  life = loadImage("img/life.png"); 
  soldier = loadImage("img/soldier.png"); 
	title = loadImage("img/title.jpg");
	gameover = loadImage("img/gameover.jpg");
	startNormal = loadImage("img/startNormal.png");
	startHovered = loadImage("img/startHovered.png");
	restartNormal = loadImage("img/restartNormal.png");
	restartHovered = loadImage("img/restartHovered.png");
	soil8x24 = loadImage("img/soil8x24.png");
  soil0 = loadImage("img/soil0.png");
  soil1 = loadImage("img/soil1.png");
  soil2 = loadImage("img/soil2.png");
  soil3 = loadImage("img/soil3.png");
  soil4 = loadImage("img/soil4.png");
  soil5 = loadImage("img/soil5.png");
  stone1 = loadImage("img/stone1.png");
  stone2 = loadImage("img/stone2.png");
}

void draw() {
    /* ------ Debug Function ------ 

      Please DO NOT edit the code here.
      It's for reviewing other requirements when you fail to complete the camera moving requirement.

    */
    if (debugMode) {
      pushMatrix();
      translate(0, cameraOffsetY);
    }
    /* ------ End of Debug Function ------ */

	switch (gameState) {
    // Game start stage.
		case GAME_START: 
		image(title, 0, 0);

		if(START_BUTTON_X + START_BUTTON_W > mouseX && START_BUTTON_X < mouseX && START_BUTTON_Y + START_BUTTON_H > mouseY && START_BUTTON_Y < mouseY) {
			image(startHovered, START_BUTTON_X, START_BUTTON_Y);
			if(mousePressed){
				gameState = GAME_RUN;
				mousePressed = false;
			}
		}else{
			image(startNormal, START_BUTTON_X, START_BUTTON_Y);
		}
		break;

    // Game run stage.
		case GAME_RUN: 
      drawBG(); // Background involve sky, sun and grass.
      drawSoil(); // Draw different layer soil and stone.
      drawGH(); // Using key pressed and framecount to control groundhog.
      drawLife(); // Draw life by life count.
      
      // If life count down to zero then game is over.
      if(playerHealth == 0){gameState = GAME_OVER;} 
    break;
    
    // Game over stage.
		case GAME_OVER: 
		image(gameover, 0, 0);
		
		if(START_BUTTON_X + START_BUTTON_W > mouseX && START_BUTTON_X < mouseX && START_BUTTON_Y + START_BUTTON_H > mouseY && START_BUTTON_Y < mouseY) {
			image(restartHovered, START_BUTTON_X, START_BUTTON_Y);
			if(mousePressed){
				gameState = GAME_RUN;
				mousePressed = false;
        // Initial.
				ghX = 4 * blockSize;
        ghY = 1 * blockSize;
        playerHealth = 2;
        baseLine = 2;
        downPressed = false;
        leftPressed = false;
        rightPressed = false;
        frame = 0;
			}
		}
    else{
			image(restartNormal, START_BUTTON_X, START_BUTTON_Y);
		}
		break;
	}

    // DO NOT REMOVE OR EDIT THE FOLLOWING 3 LINES
    if (debugMode) {
        popMatrix();
    }
}

void drawBG(){
    // Background
    image(bg, 0, 0);
    // Sun
    stroke(255,255,0);
    strokeWeight(5);
    fill(253,184,19);
    ellipse(590,50,120,120);
    // Grass should move with base line.
    fill(124, 204, 25);
    noStroke();
    rect(0, baseLine * blockSize - GRASS_HEIGHT, width, GRASS_HEIGHT);
}

void drawSoil(){
  // Two dimensions soil layer and size is 8 x 24.
  for(int y = 0; y < 24; y++){
    for(int x = 0; x < 8; x++){
      // First layer
      if(y < 8){
        // Draw different soil layer.
        if(y < 4){image(soil0, x * blockSize, (y + baseLine) * blockSize);}
        else{image(soil1, x * blockSize, (y + baseLine) * blockSize);}
        
        // Rule : follow diagonal line.
        if(x == y){
          image(stone1, x * blockSize, (y + baseLine) * blockSize);
        }
      }
      // Second layer
      else if(y < 16){
        // Draw different soil layer.
        if(y < 12){image(soil2, x * blockSize, (y + baseLine) * blockSize);}
        else{image(soil3, x * blockSize, (y + baseLine) * blockSize);}
        
        // Rule : follow diagonal line and use the difference between x and y as tag to check.
        if(abs((y - 8) - x) == 1 || abs((y - 8) - x) == 5){
          // This diagonal line begin with a stone and follow with a blank.
          if((x + y) % 4 == 1){
            image(stone1, x * blockSize, (y + baseLine) * blockSize);
          }
        }
        // This diagonal line full of stone.
        else if(abs((y - 8) - x) == 2 || abs((y - 8) - x) == 6){
          image(stone1, x * blockSize, (y + baseLine) * blockSize);
        }
        // This diagonal line begin with a blank and follow with a stone.
        else if(abs((y - 8) - x) == 3){
          if((x + y) % 4 == 1){
            image(stone1, x * blockSize, (y + baseLine) * blockSize);
          }
        }
      }
      // Third layer
      else{
        // Draw different soil layer.
        if(y < 20){image(soil4, x * blockSize, (y + baseLine) * blockSize);}
        else{image(soil5, x * blockSize, (y + baseLine) * blockSize);}
        
        // Rule : follow anti-diagonal line.
        if(!((y - 16 + x) == 0 || (y - 16 + x) == 3 || (y - 16 + x) == 6 || (y - 16 + x) == 9 || (y - 16 + x) == 12)){ 
          image(stone1, x * blockSize, (y + baseLine) * blockSize);
        }
        // Rule : follow anti-diagonal line.
        if((y - 16 + x) == 2 || (y - 16 + x) == 5 || (y - 16 + x) == 8 || (y - 16 + x) == 11 || (y-16 + x) == 14){ 
          image(stone2, x * blockSize, (y + baseLine) * blockSize);
        }
      }
    }
  }
}

void drawLife(){
  // Set max limit of health
  if(playerHealth > 5){
    playerHealth = 5;
  }
  //Draw different number and position of life.
  for(int i = 0; i < playerHealth; ++i){
    image(life, i * (life.width+20)+10, 10);
  }
}

void drawGH(){ 
  if (downPressed) {
    frame += 1;
    // If grounghog higher than 20 layers.
    if(baseLine > -18){
      if(frame < 15){
        // Groundhog still at same position.
        image(ghDown, ghX, ghY);
        // Base line move upward in 15 frames.
        baseLine -= (1.0/ 15.0);
      }
      else{
        downPressed = false;
        frame = 0;
        baseLine = (baseLineLast - 1);
      }
    }
    // Groundhog reach the last layer.
    else{
      // Divide a block into 15 sections, start counting frame numbers when key pressed and moving one section each frame.
      if(frame < 15){
        image(ghDown, ghX, ghY += (blockSize / 15.0));
      }
      // After 15 frames, groundhog move one block and turn to IDLE.
      else{
        downPressed = false;
        ghY = (blockCoordinateY + 1)* 80.0;
        frame = 0;
      } 
    }
  }
  
  else if (leftPressed) {
    frame += 1;
    if(frame < 15){image(ghLeft, ghX -= (blockSize / 15.0), ghY);}
    else{
      leftPressed = false;
      ghX = (blockCoordinateX - 1) * 80.0;
      frame = 0;
    } 
  }
  else if (rightPressed) {
    frame += 1;
    if(frame < 15){image(ghRight, ghX += (blockSize / 15.0), ghY);}
    else{
      rightPressed = false;
      ghX = (blockCoordinateX + 1) * 80.0;
      frame = 0;
    }
  } 
  else{
    image(ghIdle, ghX, ghY);
    // Record block coordinate.
    blockCoordinateX = floor(ghX / 80.0);
    blockCoordinateY = floor(ghY / 80.0);
    // Record base line.
    baseLineLast = baseLine;
  }
  
  //boundary detection
  if(ghX + blockSize > width){ //detect right boundary.
    ghX = width - blockSize;
    rightPressed = false; //if touch boundary, release key to avoid continue moving. 
  }
  else if(ghX < 0){ //detect left boundary.
    ghX = 0;
    leftPressed = false;
  }
  else if(ghY + blockSize > height){ //detect down boundary.
    ghY = height - blockSize;
    downPressed = false;
  }
}

void keyPressed(){
  timeNow = millis(); //get latest time.
  
  if((timeNow - timeLast) >=  250){ //at least 250ms between two clicks.
    timeLast = timeNow; //update time record only when successful click. 
    if(key == CODED){
      switch (keyCode) {
        case DOWN:
          downPressed = true;
          break;
        case LEFT:
          leftPressed = true;
          break;
        case RIGHT:
          rightPressed = true;
          break;
      }
    }
  }

	// DO NOT REMOVE OR EDIT THE FOLLOWING SWITCH/CASES
    switch(key){
      case 'w':
      debugMode = true;
      cameraOffsetY += 25;
      break;

      case 's':
      debugMode = true;
      cameraOffsetY -= 25;
      break;

      case 'a':
      if(playerHealth > 0) playerHealth --;
      break;

      case 'd':
      if(playerHealth < 5) playerHealth ++;
      break;
    }
}
