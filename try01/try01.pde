
import ddf.minim.*;

Minim       minim;
AudioPlayer jingle;

int halb, voll=0;
int fader = 100000000;
int fade = 1;
int delay = 0;

void setup() {
  size(640, 480, P3D);

  byte b[] = loadBytes("test.bmp"); 
  byte a[] = loadBytes("test.mp3"); 

  if (a.length <= b.length) {
    halb = a.length/2;
    voll = b.length;
  }
  else {
    halb = b.length/2;
    voll = a.length;
  } 

  float[] c= new float[voll];
  byte[] d= new byte[voll];
  for (int i =0; i < voll; i++) {
    if ( i < 55+halb) {
      c[i]=b[i];
    }
    else {
      if (i < 2*halb) {
        c[i]=(float(b[i])+(float(a[i])/fade)/1+fade);
        if (i % 50 == 0) {
        fade++;}
      }
      else {
        c[i]=a[i];
      }
    }
  }
  
  for (int z=0; z < c.length; z++) {
    d[z]=byte(c[z]);
  }
  saveBytes("numbers.bmp", d);

}





void draw() {
  print("ready");
}

