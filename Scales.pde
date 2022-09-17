void setup() {
  size(800, 800);
  noLoop();
}

int bgR = 25;
int bgG = 25;
int bgB = 125;
float grassColor = 128.0;

void draw() {
  strokeWeight(2);
  stroke(255);
  
  float xOff = 0;
  float yOff = 0;
  
  clear();

  //night sky (shouldve used lerpColor! but distance formula works...)
  for (float bgGrad = height; bgGrad > 0; bgGrad--) {
    stroke(3 * bgR * bgGrad/height, bgG * bgGrad/height, bgB * bgGrad/height);
    line(0, bgGrad, width, bgGrad);
  }

  noFill();
  
  //star trails

  for (float radius = 0; radius < 1000; radius++) { // center, going out
    for (float degree = 0; degree < 360; degree++) { // turning
      translate(width/2, 3*height/8); //center
      rotate(degrees(degree));
      
      if (Math.random() < 0.001) { //stars
        stroke(255, 255, 255, 50);
        point(0, radius);
      }
      
      if (Math.random() < 0.001) { //star trails
        stroke(255, 255, 255, 10);
        arc(0, 0, radius, radius, 0, (float)(Math.random()));
        radius++;
      }
      resetMatrix();
    }
  }
  
  //title & moon
  textAlign(RIGHT, TOP);
  textSize(25);
  fill(255, 255, 255, 125);
  text("\"Trail of Stars\"", width-25, 0+25);
  fill(65, 65, 55);
  text('\u25CF', 2*width/7.0, 1*height/6);

  //ground gradient
  for (float bgGrad = height; bgGrad > 3 * height/8; bgGrad--) {
    stroke((0.0-(bgR * 5.0/8.0))/((3.0*height/8.0)- height)*((5*height/8)-bgGrad), (grassColor - (bgG * 5.0/8.0))/((3.0*height/8.0) - height)*((5*height/8)-bgGrad), (0.0 - (bgB * 5.0/8.0))/((3.0*height/8.0)- height)*((5*height/8)-bgGrad));
    line(0, bgGrad, width, bgGrad);
  }

  //field distribution
  for (float y = 3 * height / 8; y < (height * 1.2); y+= (5 +  yOff)) { // this 5 tells distribution

    for (float x = width/2; x < (width * 1.1); x += (5 + xOff)) { //this 5 tells distribution
      //right field
      point(x, y);
      blade(x, y, xOff, yOff);
      
      if (Math.random() < 0.05) {
        bud(x, y, xOff, yOff);
      }
      if (Math.random() < 0.1) {
        grain(x, y, xOff, yOff);
      }
      
      //left field
      point( width - x + 5 + xOff, y);
      blade(width - x + 5 + xOff, y, xOff, yOff);

      if (Math.random() < 0.05) {
        bud(width - x + 5 + xOff, y, xOff, yOff);
      }
      if (Math.random() < 0.1) {
        grain(width - x + 5 + xOff, y, xOff, yOff);
      }      
    }

    xOff+= 0.1;
    yOff+= 0.1;
  }
}

void keyPressed() {
  redraw();
}

void blade(float xPos, float yPos, float offX, float offY) {
  strokeWeight(1);


  // (final color - starting color) / (final color y level - starting color y level) * (final color y level - iterator)
  float greenColorGradient = (grassColor - bgG / ((3 * height / 8) - 0));


  color satColor = color(0 * (offY/4), (float)Math.random()* (offY / 4) * greenColorGradient + 25, 0 * (offY/4));
  float leftEdge = xPos + ((float)Math.random() - 0.5 )* offX;
  float rightEdge = xPos + ((float)Math.random() - 0.5 )* offX;
  float tipX = xPos + ((float)Math.random() - 0.5 )* offX * 2.5;
  float tipY = yPos - ((float)Math.random() + 1 ) * offY * 10 - (int)(Math.random()*20) ;
  //tipY affects grass height



  fill(satColor);
  stroke(satColor);

  beginShape();
  curveVertex(leftEdge, yPos);
  curveVertex(leftEdge, yPos);
  curveVertex(xPos - (float)Math.random(), (yPos + tipY - (float)Math.random()) / 2);
  curveVertex(tipX, tipY);
  curveVertex(tipX, tipY);  
  curveVertex(xPos + (float)Math.random(), (yPos + tipY + (float)Math.random()) / 2);
  curveVertex(rightEdge, yPos);
  curveVertex(rightEdge, yPos);
  endShape();
}

void bud(float corollaX, float corollaY, float corollaOffX, float corollaOffY) {
  
  //center corolla
  fill(0 * (corollaOffY/4), (float)Math.random()* (corollaOffY / 4) * (grassColor - bgG / ((3 * height / 8) - 0)), 0 * (corollaOffY/4));
  line(corollaX, corollaY, corollaX, corollaY+5);
  noStroke();
  fill(125, 125, 25, 250);
  ellipse(corollaX, corollaY, corollaOffX, corollaOffY);

  //random petals
  for (int petals = 0; petals < (int)(Math.random()*5); petals++) {
    fill(125 + (int)(Math.random()*20) - 5, 125 + (int)(Math.random()*20) - 5, 25, 250);
    ellipse(corollaX+(float)(Math.random()-0.5)*5, corollaY+(float)(Math.random()-0.5)*5, corollaOffX*0.9, corollaOffY*0.9);
  }
}

void grain(float stemX, float stemY, float stemOffX, float stemOffY) {

   //random offset from grass
  stemX += Math.random() - 0.5;

  float tilt = degrees((float)(Math.random()-0.5)/400);
  float stemHeight = (float)Math.random()*stemOffY*20;
  
  float grainColorGradient = (grassColor - bgG / ((3 * height / 8) - 0));

  color satColor = color((float)Math.random()* (stemOffY / 8) * grainColorGradient + 50, (float)Math.random()* (stemOffY / 6) * grainColorGradient + 40, 0 * (stemOffY/4));

  stroke(satColor);
  strokeWeight(2.5);

  //stems
  translate(stemX,stemY);
  rotate(tilt);
  line(0, 0, 0, 0 - stemHeight);
  resetMatrix();
  
  float tip = stemOffY/2;
  float gwidth = stemOffY/12;

  //grains
  for (float grainOS = stemY - stemHeight; grainOS < stemY - stemHeight*3/4;grainOS+=(gwidth*8)) {
    stroke(lerpColor(satColor,color(50,40,0),(grainOS - (stemY-stemHeight))/(stemY-grainOS)));
    translate(stemX,stemY);
    rotate(tilt);
    translate(0,grainOS-stemY);
    beginShape();
    vertex(0,0);
    vertex( tip/2 - gwidth,tip/2 - gwidth);
    vertex(0+tip,0-tip);
    vertex( tip)/2 + gwidth,tip/2 + gwidth);
    vertex(0,0);
    vertex( tip)/2 + gwidth,tip/2 - gwidth);
    vertex(0-tip,0-tip);
    vertex( tip/2 - gwidth,tip/2 + gwidth);
    vertex(0,0);
    endShape();
    resetMatrix();
  }
}
