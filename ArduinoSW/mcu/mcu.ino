#include <ESP8266WiFi.h>
#include<SPI.h>

// Replace with your network credentials
const char* ssid = "App4UCU";
const char* password = "WIFIPASSWORD";
volatile byte Slavereceived


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
 SPI.attachInterrupt();
}
 ISR (SPI_STC_vect){                       //Inerrrput routine function 
  Slavereceived = SPDR;                   // Value received from master if store in variable slavereceived
  Serial.print(Slavereceived);
}

void loop(void){
  
}
