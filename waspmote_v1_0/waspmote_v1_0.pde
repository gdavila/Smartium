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

#include <WaspSensorGas_v20.h>
#include <WaspXBee900.h>
#include <WaspFrame.h>

long  sequenceNumber = 0;                                               
char* NODE_ID="N01";   
char* sleepTime = "00:00:00:30";       
char data[100];   

float temperatureVal;
char  temperatureValString[10]; 

float humidityVal;
char  humidityValString[10]; 

float dioxidoVal;
char  dioxidoValString[10]; 


char  ACC_X[3] = "AX";
char  ACC_Y[3] = "AY";
char  ACC_Z[3] = "AZ";

char  T[2] = "T";
char  H[2] = "H";
char  CO2[4] = "C02";

char accelerometerXString[10];
char accelerometerYString[10];
char accelerometerZString[10];

int accelerometerX;
int accelerometerY;
int accelerometerZ;


int   batteryLevel;
char  batteryLevelString[10];
char  BATTERY[4] = "BAT";

char  TIME_STAMP[3] = "TS";
char* MAC_ADDRESS ="0013A20040794B8C";
packetXBee* packet;


void setup() 
{
    frame.setID(NODE_ID);
    frame.setFrameSize(XBEE_900, DISABLED, DISABLED);
    USB.print(F("\nRutina de Setup")); 
    USB.println(); 
    frame.createFrame(ASCII);  
    frame.addSensor(SENSOR_STR, (char*) "setup_example_value");
    frame.showFrame();
    
    
    /*
    xbee900.ON();
    packet=(packetXBee*) calloc(1,sizeof(packetXBee));
    packet->mode=UNICAST;
    xbee900.setDestinationParams( packet, MAC_ADDRESS, frame.buffer, frame.length);
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
  
    //Turn on the sensor board
    SensorGasv20.ON();
    //Turn on the RTC
    RTC.ON();
    //supply stabilization delay
    delay(100);
    //Turn on the accelerometer
    ACC.ON();
    //Turn on the sensors
    delay(10000);
    
    // Configure the CO2 sensor socket
    SensorGasv20.configureSensor(SENS_CO2, 1);
    SensorGasv20.setSensorMode(SENS_ON, SENS_CO2);
    delay(40000); 
    
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
    

    batteryLevel = PWR.getBatteryLevel();
    itoa(batteryLevel, batteryLevelString, 10);

    temperatureVal = SensorGasv20.readValue(SENS_TEMPERATURE);
    Utils.float2String(temperatureVal, temperatureValString, 2);


    humidityVal = SensorGasv20.readValue(SENS_HUMIDITY);
    Utils.float2String(humidityVal, humidityValString, 2);
   
    delay(60000);
    dioxidoVal = SensorGasv20.readValue(SENS_CO2);         
    //Conversion into a string
    //dioxidoVal = 0.2-dioxidoVal
    Utils.float2String(dioxidoVal, dioxidoValString, 2);
    

    USB.println(F("midiendo sensores..."));

    frame.createFrame(ASCII); 
    frame.addSensor(SENSOR_ACC, accelerometerX, accelerometerY, accelerometerZ);
    frame.addSensor(SENSOR_TIME, RTC.hour, RTC.minute, RTC.second );
    frame.addSensor(SENSOR_BAT, PWR.getBatteryLevel() );
    frame.addSensor(SENSOR_TCA, temperatureVal );
    frame.addSensor(SENSOR_HUMA, humidityVal);
    frame.addSensor(SENSOR_CO2, dioxidoVal);
  
    frame.showFrame();
    //Data payload composition
    sprintf(data,"I:%s#N:%li#%s:%s#%s:%s#%s:%s#%s:%s#%s:%s#%s:%s#%s:%s#%s:%s\r\n",
    NODE_ID ,
    sequenceNumber,
    ACC_X, accelerometerXString,
    ACC_Y, accelerometerYString,
    ACC_Z , accelerometerZString,
    BATTERY, batteryLevelString,
    TIME_STAMP, RTC.getTimestamp(),
    T , temperatureValString,
    H , humidityValString,
    CO2 , dioxidoValString);
    /*
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
    delay(100); */

  
    USB.println(F("Hibernando..."));
    USB.println();


  PWR.deepSleep(sleepTime, RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);
    //Increase the sequence number after wake up
    //sequenceNumber++;

}
