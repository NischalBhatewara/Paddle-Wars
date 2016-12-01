static boolean showMainMenuGUI, showSettingsGUI, showDead, showHelpGUI;
static boolean soundEffect;
static PFont fontCSMS, fontFSS, fontAUMS;
static Maxim maxim;
static AudioPlayer pong, gameMusic, splitball, killpaddle, goodpowerup, extralife, expandpaddle, balllost, badpowerup;

boolean startGame;
PImage volume_on, volume_muted;
float red, green, blue;

Button backButton, resetButton, ok, help;
MultipleButtons mainMenuMultiButton;
RadioButtons soundSettings;
Slider soundSlider;
MultiSlider backgroundColor;

GameClass newGame;

void setup() {

  size(400, 650);  

  //Fonts 
  fontCSMS = loadFont("ComicSansMS-Italic-48.vlw");
  fontFSS = loadFont("FreestyleScript-Regular-72.vlw");
  fontAUMS = loadFont("ArialUnicodeMS-20.vlw"); 

  //Images
  volume_on = loadImage("png/volume_on.png");
  volume_muted = loadImage("png/volume_muted.png");

  //Misc. variables
  soundEffect = true;   
  red = 98.260864;
  green =  137.39131;
  blue = 180.86957;  

  //GUI toggles
  showHelpGUI = false;
  showMainMenuGUI = true;
  showSettingsGUI = false;
  startGame = false; 
  showDead = false;

  //Radio Buttons and normal buttons
  ok = new Button("Main menu", 150, 600, 100, 30);
  help = new Button("HELP!", 50, 550, 80, 25);
  backButton = new Button("back", 200, 550, 25, 20);
  resetButton = new Button("Reset Game", 150, 300, 100, 30);
  mainMenuMultiButton = new MultipleButtons(3, 150, 250, 100, 30, VERTICAL);  
  soundSettings = new RadioButtons(2, 230, 115, 25, 20, HORIZONTAL);  

  //Sliders 
  soundSlider = new Slider("Volume", 1f, 0f, 1.5f, 80, 145, 200, 13, HORIZONTAL);
  backgroundColor = new MultiSlider(3, 0f, 200f, 80, 190, 200, 13, HORIZONTAL);

  //Attributes for widgets
  String [] radioNames = {
    "Play Game", "Settings", "Exit"
  };  
  mainMenuMultiButton.setNames(radioNames);
  String [] sliderNames = {
    "Red", "Green", "Blue"
  };  
  backgroundColor.setNames(sliderNames);
  backgroundColor.set(0, red);
  backgroundColor.set(1, green);
  backgroundColor.set(2, blue); 

  //Setting images to buttons  
  soundSettings.setImage(0, volume_on);
  soundSettings.setImage(1, volume_muted);
  backButton.setImage(loadImage("png/back.png"));

  //Audio Resources
  maxim = new Maxim(this);   
  pong = maxim.loadFile("sfx/pong.wav");
  pong.setLooping(false);  
  splitball = maxim.loadFile("sfx/splitball.wav");
  splitball.setLooping(false);
  killpaddle = maxim.loadFile("sfx/killpaddle.wav");
  killpaddle.setLooping(false);
  goodpowerup = maxim.loadFile("sfx/goodpowerup.wav");
  goodpowerup.setLooping(false);
  extralife = maxim.loadFile("sfx/extralife.wav");
  extralife.setLooping(false);
  expandpaddle = maxim.loadFile("sfx/expandpaddle.wav");
  expandpaddle.setLooping(false);
  balllost = maxim.loadFile("sfx/balllost.wav");
  balllost.setLooping(false);
  badpowerup = maxim.loadFile("sfx/badpowerup.wav");
  badpowerup.setLooping(false); 

  gameMusic = maxim.loadFile("sfx/gameMusic.wav");

  gameMusic.play();
}

void draw() { 

  background(red, green, blue); 

  if (startGame) {   
    showMainMenuGUI = false;
    showSettingsGUI = false;    
    if (newGame == null) {
      newGame = new GameClass(red, green, blue);
    }    
    if (newGame.getLives() == 0) {      
      newGame = null;
      showDead = true;
      startGame = false;
    }
    else
      newGame.mainGameLoop();
  }  

  else {

    if (showMainMenuGUI) {     
      MainMenuGUI();
    }

    if (showSettingsGUI) {     
      SettingsGUI();
    }

    if (showDead) {
      textFont(fontFSS, 72);
      fill(50, 90, 200);
      text("Game Over!", 100, 200);
      textFont(fontAUMS, 15); 
      ok.display();
    }
  }

  if (showHelpGUI)
    helpMe();
}

void mouseReleased() {

  //Main Menu
  if (showMainMenuGUI) {
    if (mainMenuMultiButton.mouseReleased()) {     
      if (mainMenuMultiButton.get() == 0) {
        startGame = true;
      }      
      if (mainMenuMultiButton.get() == 1) {
        showSettingsGUI = true;
        showMainMenuGUI = false;
      }
      if (mainMenuMultiButton.get() == 2) {        
        exit();
      }
    }

    if (help.mousePressed()) {
      showMainMenuGUI = false;
      showSettingsGUI = false;
      showHelpGUI = true;
    }
  } 

  //Dead or help
  if (showDead || showHelpGUI)
    if (ok.mouseReleased()) {     
      showDead = false;
      showMainMenuGUI = true;
      showHelpGUI = false;
    }

  //Settings
  if (showSettingsGUI) { 
    //Sound effect radio
    if (soundSettings.mouseReleased()) {
      if (soundSettings.get() == 1) {
        soundEffect = false;        
        gameMusic.stop();
        gameMusic.cue(0);
      }
      if (soundSettings.get() == 0) {
        soundEffect = true;           
        pong.play();
        gameMusic.play();
      }
    }
  }

  if (backgroundColor.mouseReleased())   
    if (soundSlider.mouseReleased()) {
      gameMusic.volume(soundSlider.get());
      pong.volume(soundSlider.get());
    } 

  //Backbutton
  if (backButton.mouseReleased()) {
    showMainMenuGUI = true;
    showSettingsGUI = false;
  }

  //Reset Button
  if (resetButton.mouseReleased()) {
    if (newGame != null)
      newGame = null;
  }

  //In game
  if (startGame && newGame != null)
    newGame.mouseReleased();
}

void mouseDragged() {

  //Settings
  backgroundColor.mouseDragged();   

  if (soundSlider.mouseDragged()) {
    gameMusic.volume(soundSlider.get());
    pong.volume(soundSlider.get());
    splitball.volume(soundSlider.get());
    killpaddle.volume(soundSlider.get());
    goodpowerup.volume(soundSlider.get());
    extralife.volume(soundSlider.get());
    expandpaddle.volume(soundSlider.get());
    balllost.volume(soundSlider.get());
    badpowerup.volume(soundSlider.get());
  }
}

void MainMenuGUI() {

  textFont(fontFSS, 72);
  fill(50, 90, 200);
  text("Paddle War!", 90, 200);

  textFont(fontCSMS, 12);

  if (newGame != null)  
    mainMenuMultiButton.setOneName("Resume Game", 0);
  else 
    mainMenuMultiButton.setOneName("Play Game", 0);

  mainMenuMultiButton.display();
  help.display();
}

void SettingsGUI() {

  textFont(fontAUMS, 15);  

  //For sound effects
  text("Enable sound? (currently ", 30, 130);
  if (soundEffect)
    text("on) ", 195, 130);
  else
    text("off) ", 195, 130);  
  soundSettings.display();  
  if (soundEffect)
    soundSlider.display();

  //Background color multi slider  
  backgroundColor.display();
  red = backgroundColor.get(0);
  green = backgroundColor.get(1); 
  blue = backgroundColor.get(2);

  //Reset Button
  resetButton.display();

  //Back button
  backButton.display();
}

void helpMe() {  

  textFont(fontFSS, 72);
  fill(50, 90, 200);
  text("Objective", 100, 60);

  textFont(fontCSMS, 15);    

  text("The objective is to score as much as you can before", 20, 120);
  text("you loose all your lives. Simple, isnt it?", 20, 140);

  fill(0, 255, 0);
  text("Good Stuff", 50, 180);

  fill(255, 255, 0);
  text("Bad Stuff", 255, 180);  

  fill(255);
  image(loadImage("png/increase_life.png"), 71, 190);
  text("+1 Life", 65, 250);
  image(loadImage("png/big_ball.png"), 71, 270);
  text("Big Ball", 65, 330);
  image(loadImage("png/slow_ball.png"), 71, 350);
  text("Slow Ball", 59, 410);
  image(loadImage("png/expand_paddle.png"), 71, 430);
  text("Expand paddle", 43, 490);

  image(loadImage("png/split_ball.png"), 271, 190);
  text("Two Balls", 258, 250);
  image(loadImage("png/fast_ball.png"), 271, 270);
  text("Fast Ball", 260, 330);
  image(loadImage("png/shrink_paddle.png"), 271, 350);
  text("Shrink Paddle", 245, 410);
  image(loadImage("png/mini_ball.png"), 271, 430);
  text("Mini Ball", 260, 490);
  image(loadImage("png/kill_paddle.png"), 271, 510);
  text("Kill Paddle", 255, 570);

  ok.display();
}

PImage [] loadImages(String stub, String extension, int numImages)
{
  PImage [] images = new PImage[0];
  for (int i =0; i < numImages; i++)
  {
    PImage img = loadImage(stub+i+extension);
    if (img != null)
    {
      images = (PImage [])append(images, img);
    }
    else
    {
      break;
    }
  }
  return images;
}
