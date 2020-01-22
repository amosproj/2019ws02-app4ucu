#include <WiFi.h>
#include "aWOT.h"
#include "StaticFiles.h"

#define WIFI_SSID "App4UCU"
#define WIFI_PASSWORD "12345678"
// spi includes, definitions and globals start
#include <stdio.h>
#include <stdint.h>
#include <stddef.h>
#include <string.h>

#include   "freertos/FreeRTOS.h"
#include   "freertos/task.h"
#include   "freertos/semphr.h"
#include   "freertos/queue.h"

#include   "lwip/sockets.h"
#include   "lwip/dns.h"
#include   "lwip/netdb.h"
#include   "lwip/igmp.h"

#include   "esp_wifi.h"
#include   "esp_system.h"
#include   "esp_event.h"
#include   "nvs_flash.h"
#include   "soc/rtc_periph.h"
#include   "driver/spi_slave.h"
#include   "esp_log.h"
#include   "esp_spi_flash.h"
#include   "driver/gpio.h"

#define GPIO_MOSI 23
#define GPIO_MISO 19
#define GPIO_SCLK 18
#define GPIO_CS 5

#define RCV_HOST    HSPI_HOST
#define DMA_CHAN    2
 //WORD_ALIGNED_ATTR char sendbuf[129]="";
 uint32_t sendData=0;
 uint32_t recvData=0;
   uint32_t* sendbuf= &sendData;
     uint32_t* recvbuf=& recvData ;
     int n=0;
      spi_slave_transaction_t t;
       esp_err_t ret;
// spi includes, definitions and globals end
WiFiServer server(80);
Application app;
bool switchButtonOn;
String intValue;

 void readSwitchButtonValue(Request &req, Response &res) {
 res.print(switchButtonOn);
}

 void updateSwitchButtonValue(Request &req, Response &res) {
  switchButtonOn = (req.read() != '0');
  return readSwitchButtonValue(req, res);
}

void readIntegerValue(Request &req, Response &res) {
  res.println(intValue);
}

 void updateIntegerValue(Request &req, Response &res) {
  intValue = req.read();
  sendData = intValue.toInt();
  return readIntegerValue(req, res);
}


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
  IPAddress Ip(192, 168, 10, 10);
  IPAddress NMask(255, 255, 255, 0);
  WiFi.softAPConfig(Ip, Ip, NMask);
  delay(100);
  IPAddress IP = WiFi.softAPIP();
  Serial.print("AP IP address: ");
  Serial.println(IP);

  
 app.get("/sb", &readSwitchButtonValue);
 app.get("/sv", &readIntegerValue);
 
 app.put("/sb", &updateSwitchButtonValue);
 app.put("/sv", &updateIntegerValue);
 
  app.route(staticFiles());
  //Configuration for the SPI bus
    spi_bus_config_t buscfg={
        mosi_io_num : GPIO_MOSI,
        miso_io_num : GPIO_MISO,
        sclk_io_num : GPIO_SCLK,
        quadwp_io_num : -1,
        quadhd_io_num : -1,
    };

    //Configuration for the SPI slave interface

      spi_slave_interface_config_t slvcfg;
        slvcfg.mode =0;
        slvcfg.spics_io_num = GPIO_CS;
        slvcfg.queue_size = 3;
        slvcfg.flags = 0;

    //Initialize SPI slave interface
    ret=spi_slave_initialize(RCV_HOST, &buscfg, &slvcfg, DMA_CHAN);
    assert(ret==ESP_OK);
 memset(&t, 0, sizeof(t));
  server.begin();
}

void loop() {
  WiFiClient client = server.available();

  if (client.connected()) {
    Serial.println("New Client has connected.");   
    app.process(&client);
  }
        t.length=32;
        t.tx_buffer=sendbuf;
        t.rx_buffer=recvbuf;
        recvData=0;
        //sendData=7;
        ret=spi_slave_transmit(RCV_HOST, &t, portMAX_DELAY);
        intValue=String(recvData);
         Serial.println(recvData,HEX);
}
