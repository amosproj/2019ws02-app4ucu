## App4UCU
Imagine the situation where you want to present the UCU to a customer. 
Wouldn't it be nice to have an application, which interacts with the core functions of it and shows internal signals?
To see and understand modern vehicle interfaces and software, an understandment of the level of a software engineer is needed.
However, not only engineers are interested in taking a look under the hood. People who are technically challenged struggle when it comes down to visualizing of the internals.
Real-time monitoring of the UCU function status could help such people understanding internals.
By adding a modern Web Interface to the UCU it would be possible to configure the UCU internals signals with any Wifi Device that has an acces to a web browser. 
The App4UCU, enables not only engineers to interact with such devices in a innovative way and also allows debugging.


In the project directory, you can run:
### `yarn install`
### `yarn start`

Runs the app in the development mode.<br />
Open [http://localhost:3000](http://localhost:3000) to view it in the browser.

The page will reload if you make edits.<br />
You will also see any lint errors in the console.

### `yarn test`

Launches the test runner in the interactive watch mode.<br />
See the section about [running tests](https://facebook.github.io/create-react-app/docs/running-tests) for more information.

# How to get Arduino and ESP running

-  https://www.teachmemicro.com/nodemcu-wifi-access-point/ 
-  https://github.com/esp8266/Arduino/tree/master/libraries/ESP8266WiFi 
-  https://blog.opendatalab.de/codeforbuga/2016/07/02/arduino-ide-mit-nodemcu-esp8266 
-  https://github.com/me-no-dev/arduino-esp32fs-plugin/releases/tag/1.0 
-  https://github.com/me-no-dev/arduino-esp32fs-plugin 
-  https://techtutorialsx.com/2019/03/24/esp32-arduino-serving-a-react-js-app/ 
-  https://blog.opendatalab.de/codeforbuga/2016/07/02/arduino-ide-mit-nodemcu-esp8266 

I used the newest version of ESP8266WiFi.h

## Note

The USB wire tends to make thinks difficult. One shall try short wires and unplugging from time to time. 
I think this will not be an issue once the project runs on its own HW.