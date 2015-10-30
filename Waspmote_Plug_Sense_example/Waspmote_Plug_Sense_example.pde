/*
 *  -------- Waspmote - Plug & Sense! - Code Generator ------------ 
 *
 *  Code generated with Waspmote Plug & Sense! Code Generator. 
 *  This code is intended to be used only with Waspmote Plug & Sense!
 *  series (encapsulated line) and is not valid for Waspmote. Use only
 *  with Waspmote Plug & Sense! IDE (do not confuse with Waspmote IDE).
 *
 *  Copyright (C) 2012 Libelium Comunicaciones Distribuidas S.L.
 *  http://www.libelium.com
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 * 
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 * 
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 *  Version:		0.1
 *  Generated:		21/10/2015
 *
 */

// Step 1. Includes of the Sensor Board and Communications modules used

#include <WaspSensorGas_v20.h>
#include <WaspXBee900.h>
#include <WaspFrame.h>

// Step 2. Variables declaration

char  CONNECTOR_A[3] = "CA";      
char  CONNECTOR_B[3] = "CB";    
char  CONNECTOR_C[3] = "CC";
char  CONNECTOR_D[3] = "CD";
char  CONNECTOR_E[3] = "CE";
char  CONNECTOR_F[3] = "CF";

long  sequenceNumber = 0;   
                                               
char* NODE_ID="N01";   

char* sleepTime = "00:00:00:30";       

char data[100];     

float connectorAFloatValue; 
float connectorBFloatValue;  
float connectorCFloatValue;    
float connectorDFloatValue;   
float connectorEFloatValue;
float connectorFFloatValue;

int connectorAIntValue;
int connectorBIntValue;
int connectorCIntValue;
int connectorDIntValue;
int connectorEIntValue;
int connectorFIntValue;

char  connectorAString[10];  
char  connectorBString[10];   
char  connectorCString[10];
char  connectorDString[10];
char  connectorEString[10];
char  connectorFString[10];

char  ACC_X[3] = "AX";
char  ACC_Y[3] = "AY";
char  ACC_Z[3] = "AZ";

int accelerometerX;
int accelerometerY;
int accelerometerZ;

char accelerometerXString[10];
char accelerometerYString[10];
char accelerometerZString[10];

int   batteryLevel;
char  batteryLevelString[10];
char  BATTERY[4] = "BAT";

char  TIME_STAMP[3] = "TS";

char* MAC_ADDRESS ="0013A20040794B8C";

packetXBee* packet;


void setup() 
{

// Step 3. Communication module initialization

// Step 4. Communication module to ON


 // store Waspmote identifier in EEPROM memory
    frame.setID( NODE_ID );
    frame.setFrameSize(XBEE_900, DISABLED, DISABLED);
    USB.print(F("\nframe size (900, UNICAST_64B, XBee encryp Disabled, AES encryp Disabled):"));
    USB.println(frame.getFrameSize(),DEC);  
    USB.println(); 
    frame.createFrame(ASCII);  
    frame.addSensor(SENSOR_STR, (char*) "Esto es un ejemplo");
    frame.showFrame();
    
    
    xbee900.ON();

// Step 5. Initial message composition
    // Memory allocation
    packet=(packetXBee*) calloc(1,sizeof(packetXBee));
    // Choose transmission mode: UNICAST or BROADCAST
    packet->mode=UNICAST;
    // Set destination XBee parameters to packet
    xbee900.setDestinationParams( packet, MAC_ADDRESS, frame.buffer, frame.length);

// Step 6. Initial message transmission

    xbee900.sendXBee(packet);
    
  if( xbee900.error_TX == 0 ) 
  {
    USB.println(F("ok"));
  }
  else 
  {
    USB.println(F("error"));
  }

    // Free variables
    free(packet);
    packet=NULL;

// Step 7. Communication module to OFF

    xbee900.OFF();*/
    delay(100);

}

void loop()
{
// Step 8. Turn on the Sensor Board

    //Turn on the sensor board
    SensorGasv20.ON();
    //Turn on the RTC
    RTC.ON();
    //supply stabilization delay
    delay(100);

//Turn on the accelerometer
    ACC.ON();

// Step 9. Turn on the sensors

    //En el caso de la placa de eventos no aplica

    delay(10000);

// Step 10. Read the sensors

    

    //Reading acceleration in X axis
    accelerometerX = ACC.getX();
    //Conversion into a string
    itoa(accelerometerX, accelerometerXString, 10);
  
    //Reading acceleration in Y axis
    accelerometerY = ACC.getY();
    //Conversion into a string
    itoa(accelerometerY, accelerometerYString, 10);
  
    //Reading acceleration in Z axis
    accelerometerZ = ACC.getZ();
    //Conversion into a string
    itoa(accelerometerZ, accelerometerZString, 10);

    // First dummy reading for analog-to-digital converter channel selection
    PWR.getBatteryLevel();
    // Getting Battery Level
    batteryLevel = PWR.getBatteryLevel();
    // Conversion into a string
    itoa(batteryLevel, batteryLevelString, 10);

    //First dummy reading for analog-to-digital converter channel selection
    SensorGasv20.readValue(SENS_TEMPERATURE);
    //Sensor temperature reading
    connectorAFloatValue = SensorGasv20.readValue(SENS_TEMPERATURE);
    //Conversion into a string
    Utils.float2String(connectorAFloatValue, connectorAString, 2);

    //First dummy reading for analog-to-digital converter channel selection
    SensorGasv20.readValue(SENS_HUMIDITY);
    //Sensor temperature reading
    connectorBFloatValue = SensorGasv20.readValue(SENS_HUMIDITY);
    //Conversion into a string
    Utils.float2String(connectorBFloatValue, connectorBString, 2);

    //Configure and turn on the CO2 sensor  
    SensorGasv20.configureSensor(SENS_CO2, 7);
    SensorGasv20.setSensorMode(SENS_ON, SENS_CO2);    
    delay(30000);
    //First dummy reading to set analog-to-digital channel
    SensorGasv20.readValue(SENS_CO2);
    connectorCFloatValue = SensorGasv20.readValue(SENS_CO2);  
    SensorGasv20.setSensorMode(SENS_OFF, SENS_CO2);        
    //Conversion into a string
    Utils.float2String(connectorCFloatValue, connectorCString, 2);

// Step 11. Turn off the sensors

    //En el caso de la placa de eventos no aplica

// Step 12. Message composition
   USB.println(F("Measuring sensors..."));

  frame.createFrame(ASCII); 
  frame.addSensor(SENSOR_ACC, accelerometerX, accelerometerY, accelerometerZ);
  frame.addSensor(SENSOR_TIME, RTC.hour, RTC.minute, RTC.second );
  frame.addSensor(SENSOR_BAT, PWR.getBatteryLevel() );
  frame.addSensor(SENSOR_TCA, connectorAFloatValue );
  frame.addSensor(SENSOR_HUMA, connectorBFloatValue );
  frame.addSensor(SENSOR_CO2, connectorCFloatValue );
  
  frame.showFrame();
    //Data payload composition
   /* sprintf(data,"I:%s#N:%li#%s:%s#%s:%s#%s:%s#%s:%s#%s:%s#%s:%s#%s:%s#%s:%s\r\n",
	nodeID ,
	sequenceNumber,
	ACC_X, accelerometerXString,
	ACC_Y, accelerometerYString,
	ACC_Z , accelerometerZString,
	BATTERY, batteryLevelString,
	TIME_STAMP, RTC.getTimestamp(),
	CONNECTOR_A , connectorAString,
	CONNECTOR_B , connectorBString,
	CONNECTOR_C , connectorCString);*/

    // Memory allocation
    packet=(packetXBee*) calloc(1,sizeof(packetXBee));
    // Choose transmission mode: UNICAST or BROADCAST
    packet->mode=UNICAST;
    // Set destination XBee parameters to packet
    xbee900.setDestinationParams( packet, MAC_ADDRESS, frame.buffer, frame.length);  

// Step 13. Communication module to ON

    xbee900.ON();

// Step 14. Message transmission

    xbee900.sendXBee(packet);
    
  // 5.6 Check TX flag
  if( xbee900.error_TX == 0 ) 
  {
    USB.println(F("ok"));
  }
  else 
  {
    USB.println(F("error"));
  }

    // Free variables
    free(packet);
    packet=NULL;

// Step 15. Communication module to OFF

    xbee900.OFF();
    delay(100);


  USB.println(F("Going to sleep..."));
  USB.println();
// Step 16. Entering Sleep Mode

  PWR.deepSleep(sleepTime, RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);
    /*PWR.deepSleep(sleepTime,RTC_OFFSET,RTC_ALM1_MODE1,ALL_OFF);
    //Increase the sequence number after wake up
    sequenceNumber++;*/

}
