
import ddf.minim.*;

Minim       minim;
AudioPlayer jingle;
PImage meinBild;


int teiler = 2;
int halb, voll=0;
float fader = 100000;
float fade,wert1,wert2,faktor = 1;
int delay = 0;
String name= "result.bmp";
void setup() {
  size(640, 480, P3D);

  byte b[] = loadBytes("test.bmp"); 
  byte a[] = loadBytes("test.wav"); 

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
  saveBytes(name+".wav", e);

      meinBild = loadImage(name+".bmp");

}





void draw() {
  print("ready");
  image(meinBild,0,0);

  
}

