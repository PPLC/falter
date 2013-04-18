import ddf.minim.*;
import controlP5.*;

//----------------------------------------------------

Minim minim;
PImage vorher, bild;
ControlP5 cp5;
AudioInput input;

String quellenname = "quelle.jpg";
Boolean offset = false, musik = false, multiply=false, decon=false;
int offsetZ = 100, modFilter = 1028;
//----------------------------------------------------

void setup() {

  minim = new Minim (this);
  input = minim.getLineIn (Minim.STEREO, 512);
  size(660, 420, P3D);

  this.setupGUI();
  
    vorher = loadImage(quellenname);
    bild = loadImage(quellenname);
  
}
//----------------------------------------------------



//----------------------------------------------------

void setupGUI() {
  cp5 = new ControlP5(this);
  //
  cp5.addSlider("SOffset")
    .setPosition(10, 320)
      .setRange(1, 255)
        .setSize(100, 20)
          .setValue(100.0)
            .setNumberOfTickMarks(255)
              .showTickMarks(false)
                .setId(1)
                  ;

  cp5.addSlider("SmodFilter")
    .setPosition(130, 320)
      .setRange(64, 65535)
        .setSize(100, 20)
          .setValue(1028)
            .setNumberOfTickMarks(16)
              .showTickMarks(false)
                .setId(2)
                  ;
  cp5.addTextlabel("label2", "Bend all the Pictures v003a")
    .setPosition(250, 270)
      ;


  cp5.addTextlabel("label1", "Press Space to Save Picture to Disk.")
    .setPosition(250, 320)
      ;
  cp5.addTextlabel("labe3l", "All Rights Reserved PPLC http://www.papaloco.net/pplc")
    .setPosition(250, 370)
      ;

  cp5.addToggle("Offset")
    .setValue(0)
      .setPosition(10, 270)
        .setSize(100, 20)
          ;
  cp5.addToggle("Music")
    .setValue(0)
      .setPosition(130, 270)
        .setSize(100, 20)
          ;
  cp5.addToggle("Multiply")
    .setValue(0)
      .setPosition(10, 370)
        .setSize(100, 20)
          ;
  cp5.addToggle("Deconstruct")
    .setValue(0)
      .setPosition(130, 370)
        .setSize(100, 20)
          ;
  cp5.addButton("Load")
    .setPosition(550, 270)
      .setSize(100, 20)
        ;
  cp5.addButton("Reset")
    .setPosition(550, 320)
      .setSize(100, 20)
        ;
  cp5.addButton("Quit")
    .setPosition(550, 370)
      .setSize(100, 20)
        ;

  cp5.getController("SmodFilter").getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  cp5.getController("SOffset").getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  background(150);
  fill(190);
  stroke(255);
  rect(125, 260, 115, 150); 
  rect(5, 260, 110, 150);
} 

//----------------------------------------------------
void draw() {
  //  frameRate(5);
  //  background(72);
  if (musik) {
    bild = loadImage(quellenname);
    bild = summon(bild);
  }

  image(vorher, 0, 0, 320, 240);
  image(bild, 350, 0, 320, 240);

}
//----------------------------------------------------

public void Offset(boolean theValue) {
  offset = theValue;
  if (offset) {
    cp5.getController("Music").setValue(0);
  }
}

public void Music(boolean theValue) {
  musik = theValue;
  if (musik) {
    cp5.getController("Offset").setValue(0);
  }
}

public void Multiply(boolean theValue) {
  multiply = theValue;
}

public void Deconstruct(boolean theValue) {
  decon = theValue;
}

public void Load() {
  selectInput("Select a file to process:", "fileSelected");
}

public void Quit() {
  exit();
}

public void Reset() {
  bild = loadImage(quellenname);
}

void controlEvent(ControlEvent theEvent) {

  switch(theEvent.getController().getId()) {

    case(1)://OffsetZ
    offsetZ = int(theEvent.getValue());
    bild = summon(bild);
    break;

    case(2)://ModFilter
    modFilter = int(theEvent.getValue());
    break;
  }
}

//--------------------------------------------------

public PImage summon(PImage p) {
  p.loadPixels();

  if (offset) {
    for (int i=0; i < p.pixels.length; i++) {
      if (multiply) {
        p.pixels[i] = ((p.pixels[i] * offsetZ));
      }
      else {
        p.pixels[i] = ((p.pixels[i] + offsetZ));
      }
    }
  }

  else if (musik) {
    float halter=1;
    float[] buffer = input.mix.toArray ();
    for (int i=0; i < p.pixels.length; i++) {
      for (int x=0; x < buffer.length; x++) {
        halter = halter+buffer[x];
      }  
      //     if (i % 100 == 0) {println("halter:" + halter + " pixel:" + p.pixels[i]);}
      if (decon) {
        p.pixels[i] = (p.pixels[i] * (int(halter))%(modFilter));
      }
      else {
        p.pixels[i] = (p.pixels[i] + (int(halter))%(modFilter));
      }
    }
  }
  else {
    p = loadImage(quellenname);
  }
  p.updatePixels();

  return p;
}

//--------------------------------------------------

void keyPressed()
{
  switch(key)
  {
  case ' ':
    bild.save(str(year())+str(month())+str(day())+"-"+str(hour())+str(minute())+str(second())+".jpg");
    break;
  case 'l':
    selectInput("Select a file to process:", "fileSelected");
  }
}

//-----------------------

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } 
  else {
    quellenname = (selection.getAbsolutePath());
    vorher = loadImage(quellenname);
    bild = loadImage(quellenname);
  }
}

