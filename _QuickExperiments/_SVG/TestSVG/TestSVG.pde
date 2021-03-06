PShape bot, chessboard, usa;
PShape chessK, circles, check, checkGR;
float angle;
boolean bStatic = true;

void setup()
{
  size(800, 800);
  smooth();

  bot = LoadSVG("bot1.svg");
  usa = LoadSVG("usa-wikipedia.svg");
  // Chess shapes from Wikipedia
  chessboard = LoadSVG("Chess_Board.svg");
  // This one is modified so it doesn't appear all black
  // Change "black" to "#000000" and "white" to "#FFFFFF"
  chessK = LoadSVG("Chess_klt45+.svg");
//  PShape chessB = loadShape("Chess_blt45.svg"); // Uses unsupported arc
  circles = LoadSVG("ThreeCircles.svg");
  // Custom personal shape
  check = LoadSVG("Check.svg");
  // Idem, with gradient
  checkGR = LoadSVG("Check_gr.svg");

  DrawEverything();
}

void draw()
{
  if (bStatic)
    return;

  shape(chessboard, 0, 0, width, height);
  shape(usa, 0, 0, width, height);

  // Put in place
  translate(mouseX, mouseY);
  // Do the rotation around the top-left corner
  rotate(angle);
  angle += 0.01;
  // Re-center the shape
  translate(-bot.width / 2, -bot.height / 2);
  // Draw it
  shape(bot, 0, 0);
}

void mousePressed()
{
  bStatic = !bStatic;
  if (bStatic)
  {
    resetMatrix();
    DrawEverything();
  }
}

PShape LoadSVG(String name)
{
  File path = new File(sketchPath);
  // data path common to several sketches
  String dataPath = path.getParent() + File.separator + "data" + File.separator + name;
  return loadShape(dataPath);
}

void DrawEverything()
{
  background(#DDEEFF);

  chessboard.disableStyle();
  fill(#884422); noStroke();
  shape(chessboard, 0, 0, width, height);
  shape(usa, 0, 0, width, height);

  fill(#FFAA55);
  DrawShapeAndOrigin(circles, 10, 10, #FFAA55);
  DrawShapeAndOrigin(check, 100, 300, 200, 200, #FFAA55);
  DrawShapeAndOrigin(check, 300, 300, 500, 500, #FFAA55);
  DrawShapeAndOrigin(checkGR, 100, 600, checkGR.width / 3, checkGR.height / 3, #00FF55);

  bot.disableStyle();
  stroke(#FF0000);
  fill(#88EEFF);
  shapeMode(CENTER);
  shape(bot, 100, 100, 100, 100);

  bot.enableStyle();
  shapeMode(CORNER);
  DrawShapeAndOrigin(bot, 100, 100, 100, 100, #FF0055);
  DrawShapeAndOrigin(bot, 500, 400, 200, 200, #FF0055);

  DrawShapeAndOrigin(chessK, 20, 700, #00FF55);
  DrawShapeAndOrigin(chessK, 100, 500, 100, 100, #00FF55);
  DrawShapeAndOrigin(chessK, 500, 50, 200, 200, #00FF55);
  DrawShapeAndOrigin(chessK, 250, 70, 300, 300, #00FF55);
}

void DrawShapeAndOrigin(PShape shape, float xPos, float yPos, float sWidth, float sHeight, color originColor)
{
  shape(shape, xPos, yPos, sWidth, sHeight);
  pushStyle();
  fill(originColor); noStroke();
  ellipse(xPos, yPos, sWidth / 25, sHeight / 25);
  popStyle();
}

void DrawShapeAndOrigin(PShape shape, float xPos, float yPos, color originColor)
{
  shape(shape, xPos, yPos);
  pushStyle();
  fill(originColor); noStroke();
  ellipse(xPos, yPos, 5, 5);
  popStyle();
}

