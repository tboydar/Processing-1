String textToDisplay =
"Basic examples introduce the primary elements of computer programming and the fundamental elements of drawing with Processing. If you are new to programming, these examples can be a part of the learning process, but they are not detailed or descriptive enough to be used alone. If you have prior experience, they will show you how to apply what you know to using Processing.\n" +
"Topic examples build on the basics; they demonstate code for animation, drawing, interaction, interface, motion, simulation, file i/o, cellular automata, fractals, and l-systems.\n" +
"3D examples show the basics of drawing in 3D. Processing has two 3D renderers that can draw 3D shapes on screen and control lighting and camera parameters. The P3D renderer is an optimized software renderer and the OPENGL renderer uses JOGL to access OpenGL accelerated graphics cards (this creates an enormous speed improvement on computers with supported graphics cards.)" +
"Libraries examples demonstrate how to use some of Processing's many libraries. The libraries enable Processing to capture and play video, import SVG files, export PDF files, communicate using the Internet and RS-232 protocols, create and play sound files, and more... ";

void setup()
{
  size(500, 800);
//  smooth();
  noLoop();
  background(#AAFFEE);

//  PFont f = loadFont("Silkscreen-8.vlw");
  PFont fa = loadFont("Arial-Black-12.vlw");
  textFont(fa);
  textAlign(CENTER);

  fill(#000055);
  text(textToDisplay, 10, 10, width - 10, height - 10);
  
  textAlign(LEFT);
//  textMode(MODEL);
  String msg = "Processing is awesome!";
  int ml = msg.length();
  PFont fi = loadFont("Impact-48.vlw");
  textFont(fi);
  char[] msgChars = new char[ml];
  msg.getChars(0, ml, msgChars, 0);
  float pos1 = 10, pos2 = 10;
  for (int i = 0; i < ml; i++)
  {
    char c = msgChars[i];
    fill(60, 90, map(i, 0, ml, 0, 255));
    text(c, 10 + 18 * i, 400);
    
    text(c, pos1, 480);
    pos1 += fi.width[c];
    text(c, pos2, 520);
    pos2 += textWidth(c);
    println(c + " " + textWidth(c) + " " + fi.width[c]);
  }
}
