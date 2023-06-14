import processing.core.*;

public class EngeldenZiplamaOyunu2 extends PApplet {

  // Oyun alanı boyutları
  private final int WIDTH = displayWidth;
  private final int HEIGHT = displayHeight;

  // Karakterin boyutu ve konumu
  private final int CHARACTER_RADIUS = 30;
  private final int CHARACTER_START_X = 100;
  private final int CHARACTER_START_Y = HEIGHT / 2;
  private float characterX;
  private float characterY;

  // Engellerin boyutu ve konumu
  private int obstacleSize;
  private int obstacleGap;
  private int obstacleSpeed;
  private float obstacleX;
  private float obstacleY;

  // Ek engellerin boyutu ve konumu
  private int additionalObstacleSize;
  private int additionalObstacleGap;
  private float additionalObstacleX1;
  private float additionalObstacleX2;
  private float additionalObstacleY;

  // Oyun durumu
  private boolean gameOver;
  private boolean gameWin;
  private int score;
  private int level;
  private int timer;

  public static void main(String[] args) {
    PApplet.main("EngeldenZiplamaOyunu2");
  }

  public void settings() {
    size(WIDTH, HEIGHT, P3D);
  }

  public void setup() {
    fullScreen();
    characterX = CHARACTER_START_X;
    characterY = CHARACTER_START_Y;
    obstacleX = WIDTH;
    obstacleY = HEIGHT / 2;
    additionalObstacleX1 = WIDTH + additionalObstacleGap;
    additionalObstacleX2 = WIDTH + additionalObstacleGap * 2;
    additionalObstacleY = HEIGHT / 2;
    gameOver = false;
    gameWin = false;
    score = 0;
    level = 1;
    timer = 0;

    updateLevelSettings();
  }

  public void draw() {
    background(0);

    if (!gameOver && !gameWin) {
      moveCharacter();
      moveObstacle();
      moveAdditionalObstacles();
      checkCollision();
      updateTimer();
      displayScore();
      displayLevel();
    } else if (gameOver) {
      displayGameOver();
    } else if (gameWin) {
      displayWin();
    }

    drawCharacter();
    drawObstacle();
    drawAdditionalObstacles();
  }

  public void moveCharacter() {
    if (keyPressed && key == 'w') {
      characterY -= 5; // Karakterin yukarı doğru hareket etmesi
    }

    characterY += 2; // Karakterin yer çekimi etkisiyle aşağı doğru hareket etmesi

    // Karakterin oyun alanından çıkmaması için sınırların kontrol edilmesi
    characterY = constrain(characterY, 0, HEIGHT - CHARACTER_RADIUS);
  }

  public void moveObstacle() {
    obstacleX -= obstacleSpeed;

    // Engel oyun alanından çıktığında yeni bir engel oluşturulması
    if (obstacleX < -obstacleSize) {
      obstacleX = WIDTH;
      obstacleY = random(0, HEIGHT - obstacleGap);
      score++; // Skoru artırma
    }
  }

  public void moveAdditionalObstacles() {
    additionalObstacleX1 -= obstacleSpeed;
    additionalObstacleX2 -= obstacleSpeed;

    // Ek engeller oyun alanından çıktığında yeni ek engeller oluşturulması
    if (additionalObstacleX1 < -additionalObstacleSize) {
      additionalObstacleX1 = WIDTH + additionalObstacleGap;
      additionalObstacleY = random(0, HEIGHT - additionalObstacleGap);
      score++; // Skoru artırma
    }

    if (additionalObstacleX2 < -additionalObstacleSize) {
      additionalObstacleX2 = WIDTH + additionalObstacleGap * 2;
      additionalObstacleY = random(0, HEIGHT - additionalObstacleGap);
      score++; // Skoru artırma
    }
  }

  public void checkCollision() {
    // Karakter ve engel arasındaki çarpışmanın kontrol edilmesi
    if (dist(characterX, characterY, obstacleX, obstacleY) < CHARACTER_RADIUS + obstacleSize / 2) {
      gameOver = true;
    }

    // Karakter ve ek engeller arasındaki çarpışmanın kontrol edilmesi
    if (dist(characterX, characterY, additionalObstacleX1, additionalObstacleY) < CHARACTER_RADIUS + additionalObstacleSize / 2) {
      gameOver = true;
    }

    if (dist(characterX, characterY, additionalObstacleX2, additionalObstacleY) < CHARACTER_RADIUS + additionalObstacleSize / 2) {
      gameOver = true;
    }
  }

  public void updateTimer() {
  if (frameCount % 60 == 0) { // Her saniye için
    timer++;

    if (timer % 30 == 0) { // Her 30 saniye için
      level++;
      updateLevelSettings();
    }

    if (timer >= 90 && !gameOver && !gameWin) {
      gameWin = true;
    }
  }
}
  public void updateLevelSettings() {
    obstacleSize = 50 + (level - 1) * 25;
    obstacleGap = 250 - (level - 1) * 100;
    obstacleSpeed = 5 + (level - 1) * 3;
    additionalObstacleSize = 40 + (level - 1) * 15;
    additionalObstacleGap = 300 - (level - 1) * 100;
  }

  public void displayScore() {
  textSize(32);
  fill(255);
  text("Score: " + score, 20, 40);
  text("Time: " + timer + "s", 20, 80); // Saniye sayacını ekle
}


  public void displayLevel() {
    textSize(24);
    fill(255);
    text("Level: " + level, width - 120, 40);
  }

  public void displayGameOver() {
    textSize(64);
    fill(255, 0, 0);
    textAlign(CENTER, CENTER);
    text("Game Over", WIDTH / 2, HEIGHT / 2);
    textSize(32);
    fill(255);
    text("Press 'r' to restart", WIDTH / 2, HEIGHT / 2 + 60);
  }

  public void displayWin() {
    textSize(64);
    fill(0, 255, 0);
    textAlign(CENTER, CENTER);
    text("Congrats You Win", WIDTH / 2, HEIGHT / 2);
  }

  public void drawCharacter() {
    pushMatrix();
    translate(characterX, characterY);
    fill(0, 0, 255);
    sphere(CHARACTER_RADIUS);
    popMatrix();
  }

  public void drawObstacle() {
    pushMatrix();
    translate(obstacleX, obstacleY);
    fill(255, 0, 0);
    box(obstacleSize, obstacleSize, obstacleSize);
    popMatrix();
  }

  public void drawAdditionalObstacles() {
    pushMatrix();
    translate(additionalObstacleX1, additionalObstacleY);
    fill(0, 255, 0);
    box(additionalObstacleSize, additionalObstacleSize, additionalObstacleSize);
    popMatrix();

    pushMatrix();
    translate(additionalObstacleX2, additionalObstacleY);
    fill(0, 255, 0);
    box(additionalObstacleSize, additionalObstacleSize, additionalObstacleSize);
    popMatrix();
  }

  public void keyPressed() {
    if (key == 'r' && (gameOver || gameWin)) {
      setup();
    }
  }
}
