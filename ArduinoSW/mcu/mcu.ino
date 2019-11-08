#include <ESP8266WiFi.h>


// Replace with your network credentials
const char* ssid = "App4UCU";
const char* password = "WIFIPASSWORD";



String page = "";
int LEDPin = 13;
void setup(void){
  //the HTML of the web page
 
  WiFi.softAP(ssid, password); //begin WiFi access point

  // Wait for connection
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
 
}
 
void loop(void){
  
}
