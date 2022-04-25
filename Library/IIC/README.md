
#  IIC协议介绍以及Verilog代码实现
## 项目一：IIC EEPROM读写控制器 （[IIC-eeprom ](https://github.com/siimnzou/FPGA_learning/tree/main/Library/IIC/iic_eeprom)）
### 一、 实验目标
本实验工程目的主要是使用IIC协议实现对EEPRPOM的读写功能，通过按键Key_wr按下后向EEPROM写入10个数据，然后按下Key_rd依次读出刚才写入的十个数据，并通过数码管进行显示。
### 二、硬件及代码参考
本实验工程中使用的FPGA是Altera公司 Cyclone IV EP4CE10F17CB野火征途Pro开发板。     
EEPROM为ATMEL 公司 AT24C64芯片。  
代码编写参考野火《FPGA Verilog 开发实战指南 基于 Intel Cyclone IV》  以及[【接口时序】6、IIC总线的原理与Verilog实现](https://www.cnblogs.com/liujinggang/p/9656358.html)。
### 三、SignalTap II 波形抓取

以下为实验上板后对于单字节读写时序的波形抓取  
**读时序**

![IIC读时序.png](https://s2.loli.net/2022/03/30/FED2bOBuwfIUXpy.png)

**写时序**
![IIC写时序.png](https://s2.loli.net/2022/03/30/tfyl64Svs2CbGBd.png)

## 项目二： I2S 音频回环实验（[IIC_audio](https://github.com/siimnzou/FPGA_learning/tree/main/Library/IIC/iic_audio)）
### 一、音频信号的获取 
模拟音频信号的获取主要通过采样——量化——编码后获得，其中，每秒钟采样的个数称之为采样频率，采样频率越高，声音的质量也会越高，每个采样点用多少位的二进制数表示称之为量化位数，一般有8位（256个等级）、16位（65536个等级）。  
### 二、I2S总线介绍
I2S总线，是飞利浦公司为数字音频之间的数据传输而制定的一种总线标准，I2S总线的接口有SD/SCK/WS。

**SD为串行数据线**：用于数据的收发，最先发送最高位

**SCK为串行时钟线**：每个数据SCK都需要产生一个脉冲，SCK的采样频率为（2*采样频率*采样位数）

**WS字段选择线**：表明当前传输的声道。
### 三、 WM8978芯片
<a href="https://sm.ms/image/ZPnU2W9Si583z4H" target="_blank"><img src="https://s2.loli.net/2022/04/25/ZPnU2W9Si583z4H.png" ></a>
WM8978芯片的左侧为输入部分，可以用于模拟声音的输入，三个接口分别为：LIN、LIP、RIN 和 RIP组合而成的伪差分立体声麦克风输入，L2和R2组合的立体声麦克风输入，AUXL和AUXR组合的线输入或用来传输警告声的输入。

WM8978结构图的右侧为输出部分LOUT1和ROUT1用于耳机的驱动，LOUT2和ROUT2用于扬声器驱动，OUT3和OUT4也可以配置成立体声线输出，OUT4也可以用于提供一个左右声道的单声道混合。

ADC和DAC部分，为芯片的核心部分，进行声音信号的AD和DA转换。

WM8978有两个通信接口，一个为数字音频通信接口一个为控制接口。音频通信接口可选用I2S接口，控制接口用于控制器发送控制命令配置WM8978运行状态，芯片的固定地址为0011010，通过控制接口可以访问WM8978内部寄存器，实现工作环境配置。
<a href="https://sm.ms/image/Dy9Q7gXziBNbcAa" target="_blank"><img src="https://s2.loli.net/2022/04/25/Dy9Q7gXziBNbcAa.png" ></a>

其时序图如上所示，可以发现I2S和I2C的时序十分类似，WM8978的30多个接口中，有ADCDAT输出接口，通过这个接口将ADC音频数据传回FPGA，同时有个DACDAT输入接口，FPGA通过这个接口将DAC数据传给WM8978，达到音频回环效果。
<a href="https://sm.ms/image/SbCxNZiYa5jluqe" target="_blank"><img src="https://s2.loli.net/2022/04/25/SbCxNZiYa5jluqe.png" ></a>

WM8978寄存器配置，寄存器为16bit长度，高7位表示寄存器地址，低9位用于表示控制指令，下表中列出了本次实验工程中需要配置到的寄存器以及其功能信息
<div align=center>
<a href="https://sm.ms/image/XzeZjWson7grmQu" target="_blank"><img src="https://s2.loli.net/2022/04/25/XzeZjWson7grmQu.png" width="800px"></a>
 </div>  
<div align=center>
<a href="https://sm.ms/image/6kbgDz8BxaLvl4M" target="_blank"><img src="https://s2.loli.net/2022/04/25/6kbgDz8BxaLvl4M.png" width="800px"></a>  
 </div>  

更多寄存器配置详见Datasheet
