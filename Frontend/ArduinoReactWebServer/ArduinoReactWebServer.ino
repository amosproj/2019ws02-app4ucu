#include <WiFi.h>
#include "aWOT.h"
#include "StaticFiles.h"
#include   "driver/spi_slave.h"

#define WIFI_SSID "App4UCU"
#define WIFI_PASSWORD "12345678"
// spi includes, definitions and globals start


#define GPIO_MOSI 23
#define GPIO_MISO 19
#define GPIO_SCLK 18
#define GPIO_CS 5

#define RCV_HOST    HSPI_HOST
#define DMA_CHAN    2
const uint8_t CRC7_POLY = 0x91;
//WORD_ALIGNED_ATTR char sendbuf[129]="";
uint32_t sendData = 0;
uint32_t recvData = 0;
uint32_t* sendbuf = &sendData;
uint32_t* recvbuf = & recvData ;
int n = 0;
spi_slave_transaction_t t;
esp_err_t ret;
// spi includes, definitions and globals end
WiFiServer server(80);
Application app;
bool switchButtonOn;
String intValue;
String floatValue;
String inputFieldValue;
uint32_t getCRC(uint32_t message[], uint32_t length)
{
  uint8_t i, j, crc = 0;

  for (i = 0; i < length; i++)
  {
    crc ^= message[i];
    for (j = 0; j < 32; j++)
    {
      if (crc & 1)
        crc ^= CRC7_POLY;
      crc >>= 1;
    }
  }
  return crc;
}
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

void readFloatValue(Request &req, Response &res) {
  res.println(floatValue);
}

 void updateFloatValue(Request &req, Response &res) {
  floatValue = req.read();
  sendData = floatValue;
  return readFloatValue(req, res);
}

void readInputFieldIntegerValue(Request &req, Response &res) {
  res.println(inputFieldValue);
}

 void updateInputFieldIntegerValue(Request &req, Response &res) {
  inputFieldValue = req.read();
  sendData = inputFieldValue.toInt();
  return readInputFieldIntegerValue(req, res);
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
  app.get("/fv", &readFloatValue);
  app.get("/ifv", &readInputFieldIntegerValue);
 

  app.put("/sb", &updateSwitchButtonValue);
  app.put("/sv", &updateIntegerValue);
  app.put("/fv", &updateFloatValue);
  app.put("/ifv", &updateInputFieldIntegerValue);
 

  app.route(staticFiles());
  //Configuration for the SPI bus
  spi_bus_config_t buscfg = {
mosi_io_num : GPIO_MOSI,
miso_io_num : GPIO_MISO,
sclk_io_num : GPIO_SCLK,
quadwp_io_num : -1,
quadhd_io_num : -1,
  };

  //Configuration for the SPI slave interface

  spi_slave_interface_config_t slvcfg;
  slvcfg.mode = 0;
  slvcfg.spics_io_num = GPIO_CS;
  slvcfg.queue_size = 3;
  slvcfg.flags = 0;

  //Initialize SPI slave interface
  ret = spi_slave_initialize(RCV_HOST, &buscfg, &slvcfg, DMA_CHAN);
  assert(ret == ESP_OK);
  memset(&t, 0, sizeof(t));
  server.begin();
}

void loop() {
  WiFiClient client = server.available();
  //bytes to send to APP
  uint32_t numArrToApp[8];

  // bytes to receive from APP
  uint32_t numArrFromApp[8];
  //CrcChecksum
  uint32_t CrcChecksum = 0;
  if (client.connected()) {
    Serial.println("New Client has connected.");
    app.process(&client);
  }
  t.length = 32;
  t.tx_buffer = sendbuf;
  t.rx_buffer = recvbuf;
  recvData = 0;
  //sendData=7;
  //ret=spi_slave_transmit(RCV_HOST, &t, portMAX_DELAY); //geht

  // send/receive data to UCU
  for (char counterSpi = 0; counterSpi < 8; counterSpi++) {
    t.tx_buffer = &numArrFromApp[counterSpi];
    t.rx_buffer = &numArrToApp[counterSpi];
    spi_slave_queue_trans(RCV_HOST, &t, portMAX_DELAY);
  }
  //send /receive CRC
  t.rx_buffer = &CrcChecksum;
  uint32_t crcSendData = getCRC(numArrFromApp, 8);
  t.tx_buffer = &crcSendData;
  spi_slave_queue_trans(RCV_HOST, &t, portMAX_DELAY);

  //wait for completing transaction
  spi_slave_transaction_t* pt = &t;

  spi_slave_get_trans_result(RCV_HOST, &pt, portMAX_DELAY);

  //make something with crc result
}
