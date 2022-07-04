'======================================================================='

' Title:  Uart Communication to EEPROM
' Last Updated :  01.2022
' Author : A.Hossein.Khalilian
' Program code  : BASCOM-AVR 2.0.8.5
' Hardware req. : Atmega16 + 24LC256

'======================================================================='

$regfile = "m16def.dat"
$crystal = 8000000

Config Lcdpin = Pin Db4 = Porta.4 , Db5 = Porta.5 , Db6 = Porta.6 , _
Db7 = Porta.7 , E = Porta.3 , Rs = Porta.2
Config Lcd = 20 * 2

$baud = 9600
Config Serialout = Buffered , Size = 254
Config Sda = Porta.0
Config Scl = Porta.1
Config I2cdelay = 1
Const Xeeread = 161
Const Xeewrite = 160

Dim Address As Word
Dim Aa As Byte
Dim Bb As Byte
Dim Tmp As Byte
Dim C As Byte

Cursor Off
Cls

'-----------------------------------------------------------

Address = 20 : C = 0
While Address < 30
Tmp = Lookup(c , Text)
Aa = High(address)
Bb = Low(address)
Gosub Writeeepromserial
Incr Address
Incr C
Wend

Locate 1 , 5 : Lcd "Writing Finish"
Wait 1
Locate 1 , 5 : Lcd "Reading ...   "
Wait 1
Locate 1 , 5 : Lcd "              "

Address = 20 : C = 5
While Address < 30
Aa = High(address)
Bb = Low(address)
Gosub Readeepromserial
Locate 1 , C : Lcd Tmp
Incr Address
Incr C
Wend
Locate 1 , 9 : Lcd "/"
Locate 1 , 12 : Lcd "/"

End

'-----------------------------------------------------------

Readeepromserial:
I2cstart
I2cwbyte Xeewrite
I2cwbyte Aa
I2cwbyte Bb
I2cstart
I2cwbyte Xeeread
I2crbyte Tmp , Nack
I2cstop
Waitms 5
Return

''''''''''''''''''''''''''''''

Writeeepromserial:
I2cstart
I2cwbyte Xeewrite
I2cwbyte Aa
I2cwbyte Bb
I2cwbyte Tmp
I2cstop
Waitms 5
Return

''''''''''''''''''''''''''''''

Text:
Data 1 , 3 , 7 , 8 , 0 , 0 , 5 , 0 , 1 , 9

'-----------------------------------------------------------