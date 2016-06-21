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
#include <math.h>
#include <stdio.h>
#include <string.h>


//**********************************************
//**********************************************
// 1. Declaracion de variables


char   ACC_detection[10];                                             
char*  NODE_ID="N01";               //Seleccionar el  ID de la lanza smartium


char*  sleepTime = "00:01:00:00";   //Selecciona la frecuencia de mmuestreo/ sensado de variables   


char aux1[15];               //variable auxiliar 
char aux2[15];               //variable auxiliar 

float TemperatureFloatValue;  //valor temperatura - grado celsious 
float HumidityFloatValue;     //valor humedad relativa - adimensional
float CO2FloatValue;          //valor Voltaje de sensor CO2
float dioxidoValue;             //Valor CO2 en partes por millon - ppm

//Idem valores declarados anteriormente pero en formato char
char  TemperatureString[10];  
char  HumidityString[10];   
char  CO2String[10];
char  dioxidoString[10];  

//Valores de movimiento de acelerometro en eje X, Y, Z
int accelerometerX;
int accelerometerY;
int accelerometerZ;

//Idem anterior pero en formato char
char accelerometerXString[10];
char accelerometerYString[10];
char accelerometerZString[10];

int   batteryLevel;              //nivel de bateria
int   sequenceNumber=0;          //Secuencia de la trama. Sirve para reconocer si se reinicia el waspmote
char  sequenceNumberString[10];  //idem anterior formato Char
char  batteryLevelString[10];     //nivel de bateria formato char
char  BATTERY[4] = "BAT";         //etiqueta 

char  TIME_STAMP[3] = "TS";       //etiqueta

float ValueOnNormalConditions=0.2; //Valor en [V] que el sensor entrega a 350 ppm CO2


//***************************************
//***************************************
//++++++++++IMPORTANTE++++++++++++++++++
// El valor de la mac address destino debe coincidir con el valor de la mac del Meshlium
//El siguiente valor se modifica en cada cliente/campo/parcela
char* MAC_ADDRESS ="0013A20040794B8C"; //MAC address destino 
//++++++++++++++++++++++++++++++++++++++
//**************************************

packetXBee* packet;

//Configuraciones iniciales
void setup() 
{

    RTC.ON();
    RTC.setTime("13:01:11:06:12:33:00");
    ACC.ON(); 
    USB.ON();
    xbee900.ON();
    strcpy(ACC_detection,"FALSE");
    frame.setID( NODE_ID );
    frame.setFrameSize(XBEE_900, DISABLED, DISABLED);
    // las funciones relacionadas con USB, no influyen en el funcionamiento del waspmote
    //y tiene por objeto imprimir mensajes usando la consola serial (puerto USB) para debuggind del codigo
    USB.print(F("\nframe size (900, UNICAST_64B, XBee encryp Disabled, AES encryp Disabled):"));
    USB.println(frame.getFrameSize(),DEC);  
    USB.println(); 
    frame.createFrame(ASCII);  
    frame.addSensor(SENSOR_STR, (char*) "Rutina de inicio");
    frame.showFrame();
    
    
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
    free(packet);
    packet=NULL;

    xbee900.OFF();
    delay(100);
    USB.OFF();
    delay(100);

}

//Programa Principal
void loop()
{
    SensorGasv20.ON();
    RTC.ON();
    delay(100);
    ACC.ON();
    delay(1000);
    ACC.setIWU(100); //Configuración de la Interrupcion IWU a una sensibilidad de 100 mg
    USB.ON();
    USB.println(RTC.getTime());
    USB.println(RTC_INT);
    Creat_frame();
    frame.showFrame();
    Send_frame();
    strcpy(ACC_detection,"FALSE");
    USB.println(F("Hibernando..."));
    PWR.deepSleep(sleepTime, RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);
    if( intFlag & RTC_INT )
    {    
    intFlag &= ~(RTC_INT);
    } 
    Detecting_IWUInterrupt();
    clearIntFlag();
    PWR.clearInterruptionPin();
}

void Creat_frame()
{
    USB.println(F("Midiendo Sensores..."));
   //Acelerometro - Reading
    sequenceNumber++;
    itoa(sequenceNumber, sequenceNumberString, 10);
    accelerometerX = ACC.getX();
    itoa(accelerometerX, accelerometerXString, 10);
    accelerometerY = ACC.getY();
    itoa(accelerometerY, accelerometerYString, 10);
    accelerometerZ = ACC.getZ();
    itoa(accelerometerZ, accelerometerZString, 10);
    
    //Batery level - Reading
    PWR.getBatteryLevel();
    batteryLevel = PWR.getBatteryLevel();
    itoa(batteryLevel, batteryLevelString, 10);

    //Temperature - Reading
    TemperatureFloatValue = SensorGasv20.readValue(SENS_TEMPERATURE);
    Utils.float2String(TemperatureFloatValue, TemperatureString, 2);

    //Humedity - Reading
    HumidityFloatValue = SensorGasv20.readValue(SENS_HUMIDITY);
    Utils.float2String(HumidityFloatValue, HumidityString, 2);

    //C02 - Reading 
    SensorGasv20.configureSensor(SENS_CO2, 1);
    SensorGasv20.setSensorMode(SENS_ON, SENS_CO2);    
    delay(40000); //necesario para sensar Co2
    dioxidoValue= SensorGasv20.readValue(SENS_CO2);
    Utils.float2String(dioxidoValue, dioxidoString, 4);
    SensorGasv20.setSensorMode(SENS_OFF, SENS_CO2); 
    USB.print(F("\nValor:"));
    USB.println(dioxidoValue);
    USB.println(dioxidoString);
    //Calibracion
    dioxidoValue=(ValueOnNormalConditions-dioxidoValue)*1000;
    CO2FloatValue= pow(10, (dioxidoValue + 158.631) / 62.877 );
    Utils.float2String(CO2FloatValue, CO2String, 2);

    USB.println(F("Creando Frame..."));
    
    frame.createFrame(ASCII); 
    //frame.addSensor(SENSOR_ACC, accelerometerX, accelerometerY, accelerometerZ);
    //frame.addSensor(SENSOR_TIME, RTC.hour, RTC.minute, RTC.second );
    frame.addSensor(SENSOR_BAT, PWR.getBatteryLevel() );
    frame.addSensor(SENSOR_TCA, TemperatureFloatValue );
    frame.addSensor(SENSOR_HUMA, HumidityFloatValue );
    frame.addSensor(SENSOR_CO2, CO2FloatValue );
    USB.println(ACC_detection);
    //sprintf(aux1, "ACC: %s", (char*) ACC_detection);
    strcpy(aux1, "ACC=");
    USB.println(aux1);
    strcat(aux1, ACC_detection);
    USB.println(aux1);
    frame.addSensor(SENSOR_STR, aux1);
    USB.println(dioxidoString);
    strcpy(aux2,"C02V= ");
    USB.println(aux2);
    strcat(aux2, dioxidoString);
    //sprintf(aux2, "CO2V: %s", (char*) dioxidoString);
    frame.addSensor(SENSOR_STR, aux2);
    USB.println(aux2);
    
}


void Send_frame()
{
  int flag_aux=0;
  int contador=0;
  //El codigo esta dentro de un do-while. Si el paquete no es enviado xbee900.error_TX == 1
  //el waspmote intenta enviar nuevamente el paquete cinco veces (contador <= 5). La cantidad de veces que 
  //se desea retransmitir es configurable. Si es muy grande, la batería se termina con mayor facilidad.
  do{
      USB.println(F("Enviando Frame..."));
      packet=(packetXBee*) calloc(1,sizeof(packetXBee));
      packet->mode=UNICAST;
      USB.println(F("Enviando Frame..."));
      xbee900.setDestinationParams( packet, MAC_ADDRESS, frame.buffer, frame.length);
      xbee900.ON();
      xbee900.sendXBee(packet);
      if( xbee900.error_TX == 0 ) {
          USB.println(F("ok"));
          flag_aux = 0;}
      else {
          USB.println(F("error"));
          flag_aux = 1;}
  
      free(packet);
      packet=NULL;
      xbee900.OFF();
      delay(100);
      contador=contador+1;
  }while(flag_aux == 1 && contador <= 5);

}

void Detecting_IWUInterrupt()
{

   if( intFlag & ACC_INT )
    {
      // print info
      ACC.unsetIWU();
      USB.ON();
      USB.println(F("++++++++++++++++++++++++++++"));
      USB.println(F("++ ACC interrupt detected ++"));
      USB.println(F("++++++++++++++++++++++++++++")); 
      USB.println();
      strcpy(ACC_detection,"TRUE");
      
  
      // blink LEDs
      for(int i=0; i<10; i++)
        {
          Utils.blinkLEDs(50);
        }
      intFlag &= ~(ACC_INT);
      }
}
