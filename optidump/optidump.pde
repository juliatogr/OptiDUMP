/* Code for project OptiDUMP. Tested with Android 8.
Requirements:
Arduino Board
Grove Board
Bluetooth shield
Android Smartphone
Ketai library for processing
Jumper D0 to TX
Jumper D1 to RX
Led Bar connected on D12/D13
Light sensor connected on A0
Distance sensor connected on A2
Set bluetooth, bluetooth admin and internet sketch permissions in processing.
Processing Code:
*/

//required for BT enabling on startup

import android.content.Intent;
import android.os.Bundle;
import ketai.net.bluetooth.*;
import ketai.ui.*;
import ketai.net.*;

KetaiBluetooth bt;
boolean isConfiguring = false;
String info = "";
KetaiList klist;
ArrayList devicesDiscovered = new ArrayList();

//********************************************************************
// The following code is required to enable bluetooth at startup.
//********************************************************************

void onCreate(Bundle savedInstanceState) {
  super.onCreate(savedInstanceState);
  bt = new KetaiBluetooth(this);
}

void onActivityResult(int requestCode, int resultCode, Intent data) {
  bt.onActivityResult(requestCode, resultCode, data);
}
//********************************************************************

// Window info
final int W_WIDTH = 1079;
final int W_HEIGHT = 1918;

// Format variables (background image and font types)
PImage bg;

final int TEXT_SIZE = 50;
PFont fnt_titles;
PFont fnt_sug;
PFont fnt_rest;


// Variables to know the state of the app
boolean isCon = false;
boolean isSug = false;


// Buttons info

// Button connect
final int BTN_CON_X = 50;
final int BTN_CON_Y = 320;
final int BTN_CON_WIDTH = 350;
final int BTN_CON_HEIGHT = 150;
final int BTN_CON_R = 130;
final int BTN_CON_G = 130;
final int BTN_CON_B = 130;

// Button suggests / Go back

final int BTN_SUG_WIDTH = W_WIDTH;
final int BTN_SUG_HEIGHT = 300;
final int BTN_SUG_X = 0;
final int BTN_SUG_Y = W_HEIGHT - BTN_SUG_HEIGHT;
final int BTN_SUG_R = 80;
final int BTN_SUG_G = 150;
final int BTN_SUG_B = 100;

// Buttons form1 && form 2

final int BTN_FORM_R = 255;
final int BTN_FORM_G = 255;
final int BTN_FORM_B = 255;
final int BTN_FORM_WIDTH = W_WIDTH;
final int BTN_FORM_HEIGHT = 150;
final int BTN_FORM_X = 0;
final int BTN_FORM1_Y = 300;
final int BTN_FORM2_Y = BTN_FORM1_Y + BTN_FORM_HEIGHT;


// Variables where we save the data about if the dumpsters are full or not.

int lightIsFull;  
int distIsFull;


// Code methods

void setup() {
  size(1079, 1918);
  bg = loadImage("AppTemplate.jpg");
  fnt_titles = createFont("ariblk.ttf", TEXT_SIZE);
  fnt_sug = createFont("arial.ttf", 100);
  fnt_rest = createFont("arial.ttf", TEXT_SIZE);
 
  //start listening for BT connections
  bt.start();
  
  background(bg);
}

void draw() {
  // When button "Connect" is clicked, select device and connect Bluetooth
  if (isConfiguring) {
    klist = new KetaiList(this, bt.getPairedDeviceNames());
    isConfiguring = false;
  }
  
  // variables to print at the end of each mode opt or this method
  String sug_text = "";
  String st = "";
  String dump1_text = "";
  String dump2_text = "";
  
  // Clean background
  background(bg);
  
  // clean button suggests/go back
  stroke(0);
  fill(BTN_SUG_R,BTN_SUG_G,BTN_SUG_B);
  rect(BTN_SUG_X, BTN_SUG_Y, BTN_SUG_WIDTH, BTN_SUG_HEIGHT);
  
  if (isSug){
    
    sug_text = "Go back";
    
    // Draw form buttons
    fill(BTN_FORM_R,BTN_FORM_G,BTN_FORM_B);
    rect(BTN_FORM_X, BTN_FORM1_Y, BTN_FORM_WIDTH, BTN_FORM_HEIGHT);
    rect(BTN_FORM_X, BTN_FORM2_Y, BTN_FORM_WIDTH, BTN_FORM_HEIGHT);
    
    // Write form texts
    fill(0);
    textFont(fnt_titles);
    textAlign(CENTER);
    text("Personal suggestions and comments", W_WIDTH/2, BTN_FORM1_Y + BTN_FORM_HEIGHT/2);
    text("Evaluation test", W_WIDTH/2, BTN_FORM2_Y + BTN_FORM_HEIGHT/2);
    
  } else{
    
    sug_text = "Suggest";
    
    // Draw Connect button
    fill(BTN_CON_R,BTN_CON_G,BTN_CON_B);
    rect(BTN_CON_X, BTN_CON_Y, BTN_CON_WIDTH, BTN_CON_HEIGHT);
    
    // Write Connect button text
    textFont(fnt_rest);
    textAlign(CENTER);
    fill(255);
    text("Connect", BTN_CON_X + BTN_CON_WIDTH/2, BTN_CON_Y + BTN_CON_HEIGHT/2);
    
    // Draw dumpster list
    fill(255);
    rect(0, 500, W_WIDTH, 300);
    rect(0, 800, W_WIDTH, 300);
   
    // Write dumpster titles
    textFont(fnt_titles);
    textAlign(LEFT);
    fill(0);
    text("Dumpster in Bac de Roda 80", 10, 570);
    text("Dumpster in Peru 100", 10, 870);
    
    // Prepare the rest of the text
    textFont(fnt_rest);
    fill(100);
    
    if (isCon) {               // if the mobile is connected
      st = "Connected";        // state is connected
      
      // Check if dumpsters are full
      if (lightIsFull == 0) dump1_text = "The dumpster is not full.";
      else dump1_text = "The dumpster is full.\nBetter go to another dumpster.";
      
      if (distIsFull == 0) dump2_text = "The dumpster is not full.";
      else dump2_text = "The dumpster is full.\nBetter go to another dumpster.";
      
    } else {                  // if mobile is not connected
      st = "Disconnected";    // state is disconnected
      dump1_text = dump2_text = "Lost connection.";
    }

    text("State: " + st, BTN_CON_X + BTN_CON_WIDTH + 10, BTN_CON_Y + BTN_CON_HEIGHT/2+5);
    text(dump1_text, 100, 660);
    text(dump2_text, 100, 960);
    
  } 
  
  // Write suggest/go back button text
  textFont(fnt_sug);
  textAlign(CENTER);
  fill(255);
  text(sug_text, W_WIDTH/2, BTN_SUG_Y + BTN_SUG_HEIGHT/2);

}

void mousePressed(){   

  isConfiguring = false;
  
  if (isSug){      // Check buttons in suggesting mode
  
    // Form 1 button
    if (mouseX >= BTN_FORM_X && mouseY >= BTN_FORM1_Y && mouseX <= BTN_FORM_WIDTH && mouseY <= BTN_FORM1_Y + BTN_FORM_HEIGHT){ 
        link("https://forms.gle/ABn1mRGKMxtjY59RA");
    }
    
    // Form 2 button
    if (mouseX >= BTN_FORM_X && mouseY >= BTN_FORM2_Y && mouseX <= BTN_FORM_WIDTH && mouseY <= BTN_FORM2_Y + BTN_FORM_HEIGHT){ 
        link("https://forms.gle/GC4BdXwf47GF8htNA");
    }
    
    // Go back button
    if (mouseX >= BTN_SUG_X && mouseY >= BTN_SUG_Y && mouseX <= BTN_SUG_X+BTN_SUG_WIDTH && mouseY <= BTN_SUG_Y + BTN_SUG_HEIGHT){ 
       isSug = false;
    }
    
  } else{         // check buttons in home mode
  
    // Connect button
    if (mouseX >= BTN_CON_X && mouseY >= BTN_CON_Y && mouseX <= BTN_CON_X+BTN_CON_WIDTH && mouseY <= BTN_CON_Y + BTN_CON_HEIGHT){ 
       isConfiguring = true;
    }
    
    // Suggest button
    if (mouseX >= BTN_SUG_X && mouseY >= BTN_SUG_Y && mouseX <= BTN_SUG_X+BTN_SUG_WIDTH && mouseY <= BTN_SUG_Y + BTN_SUG_HEIGHT){ 
        isSug = true;
    }
  }
}

void onKetaiListSelection(KetaiList klist) {
  String selection = klist.getSelection();
  bt.connectToDeviceByName(selection);
  klist = null;  //dispose of list for now
  isCon = true;
}

//Call back method to manage data received
void onBluetoothDataEvent(String who, byte[] data) {
  if (isConfiguring) return; //received
  if (data!=null){
    info = new String(data);
    
    if (info.charAt(0) == '|' && info.length()>=3){  // '|' = separator
      lightIsFull = Integer.valueOf(info.substring(1, 2));
      distIsFull = Integer.valueOf(info.substring(2, 3));
    }
  }
}

// Arduino+Bluetooth+Processing 
// Arduino-Android Bluetooth communication
