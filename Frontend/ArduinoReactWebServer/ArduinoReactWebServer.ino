#include <WiFi.h>
#include "aWOT.h"
#include "StaticFiles.h"

#define WIFI_SSID "App4UCU"
#define WIFI_PASSWORD "12345678"

WiFiServer server(80);
Application app;

void setup() {
  Serial.begin(115200);

  // Connect to Wi-Fi network with SSID and password
  Serial.print("Setting AP (Access Point)…");
  // Remove the password parameter, if you want the AP (Access Point) to be open
  WiFi.softAP(WIFI_SSID, WIFI_PASSWORD);

  //There are also other optional parameters you can pass to the softAP() method.
      //SSID name of WiFi Network: maximum of 63 characters;
    //Password of the WiFi: minimum of 8 characters; set to NULL if you want the access point to be open
    //channel: Wi-Fi channel number (1-13)
    //ssid_hidden: (0 = broadcast SSID, 1 = hide SSID)
    //max_connection: maximum simultaneous connected clients (1-4)

  IPAddress IP = WiFi.softAPIP();
  Serial.print("AP IP address: ");
  Serial.println(IP);
  
  app.route(staticFiles());

  server.begin();
}

void loop() {
  WiFiClient client = server.available();

  if (client.connected()) {
    Serial.println("New Client has connected.");   
    app.process(&client);
  }
}
