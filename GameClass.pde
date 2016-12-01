public class GameClass {

  public class Ball {

    public PVector ballPos, pballPos;
    private float speedX, speedY; 
    public boolean goRight, goUp;
    private float i, j;
    public boolean visible;

    Ball() {
      ballPos = new PVector(random(0, 200), random(0, 200));
      pballPos = new PVector(random(0, 200), random(0, 200));
      speedX = speedY = 2;
      goUp = goRight = false;
      visible = true;
    }

    private void reset() {
      ballPos = new PVector(random(0, 200), random(0, 200));
      pballPos = new PVector(random(0, 200), random(0, 200));
      speedX = speedY = 2;
    }

    private void calcBallSpeed() {
      a = dist(ballPos.x, ballPos.y, constrain(mouseX, 50, 350), 570);   
      speedX = map(a, 0, 70, 1.5, 6 + timeElapsed()); 
      speedY = map(dist(200, 325, mouseX, mouseY), 0, 390, 1.5, 5 + timeElapsed());


      if (speedY > speedX)
        --speedY;
    }

    private void calcBallPos() {
      if (goRight)
        ballPos.x += (speedX + pSpeed);
      else 
        ballPos.x -= (speedX + pSpeed);

      if (goUp)
        ballPos.y -= (speedY + pSpeed);
      else 
        ballPos.y += (speedY + pSpeed);
    }

    public void drawBall() {

      pballPos = ballPos;

      fill(255, 255, 0);

      if (goRight)
        for (i = pballPos.x; i <= ballPos.x; ++i) {    
          //println(pballPos.x + " " + ballPos.x + " " + speedX + " " + speedY);  
          if (i >= (400 - BALL_SIZE)) { 
            if (soundEffect)             
              playPong();                   
            goRight = false;          
            break;
          }
        }
      else for (i = pballPos.x; i >= ballPos.x; --i) {  
        //println(pballPos.x + " " + ballPos.x + " " + speedX + " " + speedY);  
        if (i <= BALL_SIZE) { 
          if (soundEffect)         
            playPong();     
          goRight = true;        
          break;
        }
      }

      if (goUp)
        for (j = pballPos.y; j >= ballPos.y; --j) {      
          //println(pballPos.x + " " + ballPos.x + " " + speedX + " " + speedY);  
          if (j <= BALL_SIZE) {    
            if (soundEffect)        
              playPong();         
            goUp = false;          
            break;
          }
        }
      else for (j = pballPos.y; j <= ballPos.y; ++j) {       
        //println(pballPos.x + " " + ballPos.x + " " + speedX + " " + speedY);  
        if ((j >= (570 - BALL_SIZE)) && (ballPos.x > mouseX - PAD_SIZE/2 && ballPos.x < mouseX + PAD_SIZE/2)) { 
          if (soundEffect)        
            playPong();          
          goUp = true;        
          calcBallSpeed();
          increaseScore();
          break;
        } 
        else if (j > 575) {
          if (splitBall) {
            balllost.play();
            visible = false;
            reset();
            playBall2 = true;
            splitBall = false;
          }
          else {
            decreaseLife();
            ballPos.x = random(0, 200);
            ballPos.y = random(0, 200);
            running = false;
          }
        }
      }
      calcBallPos();

      ellipse(i, j, BALL_SIZE, BALL_SIZE);
    }
  }

  public class Item {   

    private PVector position;
    private PImage item_image;
    private int id;   
    public boolean visible;


    Item(int id) {   
      this.id = id;   
      switch(id)
      {    
      case 0:
        item_image = loadImage("items/fast_ball.png");
        break;
      case 1:
        item_image = loadImage("items/shrink_paddle.png");
        break;
      case 2:
        item_image = loadImage("items/mini_ball.png");
        break;
      case 3:
        item_image = loadImage("items/kill_paddle.png");
        break;
      case 4:
        item_image = loadImage("items/split_ball.png");
        break;
      case 5:
        item_image = loadImage("items/expand_paddle.png");
        break;
      case 6:
        item_image = loadImage("items/increase_life.png");
        break;
      case 7:
        item_image = loadImage("items/big_ball.png");
        break;
      case 8:
        item_image = loadImage("items/slow_ball.png");
        break;
      };      
      position = new PVector(random(0, 360), -40);
      visible = false;
    }

    private void resetItem() {
      position.x = random(0, 360);
      position.y = -40;      
      visible = false;
      if (item_count > -1)
        --item_count;
    }

    public void update() {      
      position.y += 2;      
      image(item_image, position.x, position.y);
    }

    public void checkBounds() {
      if (position.y > 580) 
        resetItem();
      if ((position.y + 20 >= 570 && position.y + 20 <= 580) && (position.x >= mouseX - PAD_SIZE/2 && position.x <= mouseX + PAD_SIZE/2)) {
        resetItem();       
        switch(id)
        {       
        case 0:     
          badpowerup.play();     
          pSpeed = 2;              
          break;
        case 1:
          badpowerup.play();
          if (PAD_SIZE > 50)
            PAD_SIZE -= 50;            
          break;
        case 2:
          badpowerup.play();
          if (BALL_SIZE > 5)
            BALL_SIZE -= 5;
          break;
        case 3:         
          decreaseLife();
          break;
        case 4: 
          splitball.play();
          splitBall = true;
          ball[1].visible = true;
          ball[0].visible = true;
          break;
        case 5:
          expandpaddle.play();
          if (PAD_SIZE < 200)
            PAD_SIZE += 50;
          break;
        case 6:
          extralife.play();
          lives += 1;
          break;
        case 7:
          goodpowerup.play();
          if (BALL_SIZE < 15)
            BALL_SIZE += 5;
          break;
        case 8:       
          goodpowerup.play();    
          pSpeed = -2;      

          break;
        }
      }
    }
  }

  private boolean count, splitBall;
  private int score, pSpeed, lives, lifeCount, slowCount, item_id, countDown, score_tens, score_units, score_hundreds, score_temp, item_count, ItemRateCount;  
  private float red, green, blue;     
  private Button backButton, settingsButton;
  private PImage [] score_images;
  private int PAD_SIZE;
  private int BALL_SIZE; 
  private Item [] item = new Item[9];
  private Ball [] ball = new Ball[2];
  private float a;

  public boolean running, playBall2;   
  public int framecount;  

  GameClass(float red, float green, float blue) {

    framecount = 0;

    //Game variable
    item_id = 0;
    count = true;
    running = true;       
    a = 0f;       
    playBall2 = false;
    score = score_tens = score_units = score_hundreds = score_temp = 0;
    lives = 3;        
    countDown = 3;
    this.red = red;
    this.green = green;    
    this.blue = blue;          
    splitBall = false;
    item_count = 0;
    ItemRateCount = 0;    
    PAD_SIZE = 100;
    BALL_SIZE = 10;
    lifeCount = slowCount = 0;    
    ball[0] = new Ball();
    ball[1] = new Ball();

    for (int i = 0; i < 9; ++i)       
      item[i] = new Item(i);

    //Game resources
    score_images = loadImages("png/score_", ".png", 10);  
    backButton = new Button("back", 20, 620, 25, 20);
    settingsButton = new Button("settings", 50, 620, 25, 20);
    backButton.setImage(loadImage("png/back.png"));
    settingsButton.setImage(loadImage("png/settings.png"));
  }  

  private void toggleRunning() {
    running = !running;
  }

  public int getLives() {
    return lives;
  }

  private void increaseScore() {
    score += 1;
    score_units = score % 10;
    score_temp = score / 10;
    score_tens = score_temp % 10;
    score_hundreds = score_temp / 10;
  }

  private void  decreaseLife() {    
    killpaddle.play();
    ball[0].reset();
    ball[1].reset();
    ball[0].visible = true;
    ball[1].visible = false;
    for (int i = 0; i < 9 ; ++i)
      item[i].resetItem();
    lives -= 1;    
    count = true;
    PAD_SIZE = 100;
    splitBall = false;
    BALL_SIZE = 10;
    lifeCount = slowCount = pSpeed = 0;
  }   

  private float timeElapsed() {
    return framecount/1500;
  }

  private void playPong() {
    pong.play();
  }   

  public void mouseReleased() {
    if (backButton.mouseReleased()) {    
      toggleRunning();  
      count = !count;
      startGame = false;
      showMainMenuGUI = true;
      frameRate(60);
    }

    if (settingsButton.mouseReleased()) {  
      toggleRunning();
      count = !count;
      startGame = false;
      showSettingsGUI = true;
      frameRate(60);
    }
  }

  private void createItems() {
    if (ItemRateCount > 20 && item_count < 10) {
      ItemRateCount = 0; 
      item_id = (int)random(0, 9);
      if (!item[item_id].visible) {
        if (item_id == 6) {
          if (lifeCount < 5) {
            ++lifeCount;
            item_id = (int)random(0, 9);
          }
          else 
            lifeCount = 0;
        }
        if (item_id == 8) {
          if (slowCount < 3) {
            ++slowCount;
            item_id = (int)random(0, 9);
          }
          else 
            slowCount = 0;
        }
        item[item_id].visible = true;
        ++item_count;
      }
    }
    else {
      ++ItemRateCount;
    }
  }

  private void drawLoop() {

    background(red, green, blue);    

    fill(255, 0, 0);
    line(0, 580, 480, 580);   


    if (ball[0].visible)
      ball[0].drawBall();

    if (splitBall || playBall2)
      if (ball[1].visible)  
        ball[1].drawBall();

    fill(0, 255, 0);
    rect(constrain(mouseX - PAD_SIZE/2, 0, 400 - PAD_SIZE), 570, PAD_SIZE, 5);

    ++framecount;
  }

  private void showScore() {    
    text("Score: ", 225, 605);

    image(score_images[score_hundreds], 280, 585);
    image(score_images[score_tens], 310, 585);
    image(score_images[score_units], 340, 585);
  }

  private void showLives() {   
    text("Lives remaining: ", 160, 633);

    image(score_images[lives], 280, 615);
  }

  public  void mainGameLoop() {    
    if (
    count) {  
      mouseX = 200;
      drawLoop();                    
      backButton.display();
      settingsButton.display();
      showScore();
      showLives();
      frameRate(1);
      fill(255);
      textSize(50);    
      text(countDown, 190, 320);
      --countDown;
      if (countDown == -1) {
        count = false;     
        countDown = 3;
        frameRate(60);
        running = true;
      }
      textFont(fontCSMS, 16);
      fill(200);
    }
    else {
      if (running) { 
        createItems();     
        drawLoop();                    
        backButton.display();
        settingsButton.display();
        showScore();
        showLives();
        for (int i = 0; i < 9; ++i)
          if (item[i] != null)
            if (item[i].visible) {              
              item[i].update();
              item[i].checkBounds();
            }
      }
    }

    //minGameLoop
  }

  //class
}
