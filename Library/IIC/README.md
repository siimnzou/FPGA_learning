
#  IIC协议介绍以及Verilog代码实现
## 一.IIC-eeprom 
### 实验目标
本实验工程目的主要是使用IIC协议实现对EEPRPOM的读写功能，通过按键Key_wr按下后向EEPROM写入10个数据，然后按下Key_rd依次读出刚才写入的十个数据，并通过数码管进行显示。
### 硬件及代码参考
本实验工程中使用的FPGA是Altera公司 Cyclone IV EP4CE10F17CB野火征途Pro开发板。     
EEPROM为ATMEL 公司 AT24C64芯片。  
代码编写参考野火《FPGA Verilog 开发实战指南 基于 Intel Cyclone IV》  以及[【接口时序】6、IIC总线的原理与Verilog实现](https://www.cnblogs.com/liujinggang/p/9656358.html)。
### SignalTap II 波形抓取

以下为实验上板后对于单字节读写时序的波形抓取
**读时序**

![IIC读时序.png](https://s2.loli.net/2022/03/30/FED2bOBuwfIUXpy.png)

**写时序**
![IIC写时序.png](https://s2.loli.net/2022/03/30/tfyl64Svs2CbGBd.png)
