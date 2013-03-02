
import ddf.minim.*;
import controlP5.*;


Minim       minim;
AudioPlayer jingle;
PImage meinBild,vorher,bg;
ControlP5 cp5;

int v  = 0;
int durchgang = 10;
int teiler = 2;
int halb, voll=0;
float fader = 10;
float fade,wert1,wert2,faktor = 1;
int delay = 0;
String name= "result.bmp";
void setup() {
  size(390+320+10, 300, P3D);
    bg = loadImage("bg.png");

    this.setupGUI();


byte b[] = loadBytes("test.bmp"); 
byte a[] = loadBytes("test.wav"); 

fadeit(a,b);

}

public void fadeit(byte[] a,byte[] b) {
   if (a.length <= b.length) {
    halb = a.length/teiler;
    voll = b.length;
  }
  else {
    halb = b.length/teiler;
    voll = a.length;
  } 
  println("Laenge: " + voll);

  float[] c= new float[voll];
  byte[] d= new byte[voll];
    byte[] e= new byte[voll];

  for (int i =0; i < voll; i++) {
    if ( i < 55+halb) {
      c[i]=(b[i]& 0xff)*1000;
    }

    else {
      if (fade/fader == 1) {
        c[i]=a[i]& 0xff*1000;
      }
      else if (i < halb*teiler) {
       wert1 = float(b[i] & 0xff)*1000;
       wert2 = float(a[i] & 0xff)*1000;      
       faktor = fade/fader;
       
          c[i]=((wert1 / (1-faktor))+(wert2 / faktor))/2;

        if (i % 50==0) {
          println("C:" + c[i] + " a:" + (a[i]& 0xff) + " b:" + (b[i]& 0xff) + " Gewicht:" + (fade/fader) + " teil1:" + (float(b[i] & 0xff) / (1-(fade/fader))) + " teil2:" + (float(a[i] & 0xff)/(fade/fader)));
          if (fade < fader) {
            fade++;
          }
        }
      }
    }
  }

  for (int z=0; z < c.length; z++) {
    d[z]=byte(c[z]/1000);
    if (z < 500) {
      e[z]=a[z];
    }
    else {
    e[z]=byte(c[z]/1000);}
  }
  name=str(hour())+str(minute())+str(second())+str(year())+str(month())+str(day());
  
  saveBytes(name+".bmp", d);
//  saveBytes(name+".wav", e);

      meinBild = loadImage(name+".bmp");
      vorher = loadImage("test.bmp");
             cp5.getController("Teiler").setValue(teiler);
                          cp5.getController("Haerte").setValue(fader);

 
  
}
void setupGUI() {
  cp5 = new ControlP5(this);

  cp5.addSlider("Teiler")
    .setPosition(10, 270)
      .setRange(1, 16)
        .setSize(100, 20)
          .setId(1)
          .setValue(2)
               .setNumberOfTickMarks(16)


            ;

  cp5.addSlider("Haerte")
    .setPosition(210, 270)
      .setRange(100, 100000000)
        .setValue(100000)
          .setSize(100, 20)
          .setNumberOfTickMarks(20)
            .setId(2)

              ;
              
                cp5.addButton("Standard")
    .setValue(0)
      .setPosition(410, 270)
        .setSize(100, 20)
          ;
          
                          cp5.addButton("Again")
    .setValue(0)
      .setPosition(610, 270)
        .setSize(100, 20)
          ;
}



void draw() {

image(meinBild,10,0,320,240);
image(vorher,390,0,320,240);
if (v<durchgang) {
fader=fader*10;
this.Again(1);
v++;
} 
}

//Gui Controller

public void Standard(int theValue) {
        teiler = 2;
        fader = 100000.00;
        cp5.getController("Haerte").setValue(fader);
        cp5.getController("Teiler").setValue(teiler);


}

public void Again(int value) {
print("bam oilder");
byte b[] = loadBytes("test.bmp"); 
byte a[] = loadBytes("test.wav"); 
this.fadeit(a,b);


}


void controlEvent(ControlEvent theEvent) {
  switch(theEvent.getController().getId()) {
    
    case(1)://Teiler
      
      teiler=(int)theEvent.getValue();
    

    break;

    case(2)://haerte
      fader = (Float)theEvent.getValue();
//        cp5.getController("Teiler").setValue(borderV*100);

      
    break;



  }
}


