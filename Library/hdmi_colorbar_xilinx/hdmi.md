# HDMI 介绍
HDMI（High-Denfinition Multiface Ineterfaces）音视频传输协议，传输是基于TMDS协议。
## TMDS协议介绍
<div align=center>
<a href="https://sm.ms/image/buoIZaO6dhvqi57" target="_blank"><img src="https://s2.loli.net/2022/08/09/buoIZaO6dhvqi57.png" width="800px"></a>  
 </div> 
 <div align=center>
图 1 HDMI示意图
 </div> 
        音频、视频和辅助数据通过三个TMDS数据通道传输，通常以视频的像素运行的TMDS时钟作为TMDS的传输时钟，并作为接收端恢复数据的频率参考，其中三个通道分别用于传输视频中每个像素点的红、绿、蓝三个颜色 分量（RGB 4:4:4 格式或YCrCb 4:4:4 or 4:2:2格式）
<div align=center>
<a href="https://sm.ms/image/zfLWSrXd9AeVnEB" target="_blank"><img src="https://s2.loli.net/2022/08/09/zfLWSrXd9AeVnEB.png" width="800px"></a>  
 </div> 
 <div align=center>
图2 HDMI接口引脚  
 </div> 
1-9位数据传输引脚，10-12为时钟传输引脚，13位CEC引脚是一种消费电子兼容的传输协议，15-16为IIC传输协议引脚。19为热插拔引脚。  
 <div align=center>
<a href="https://sm.ms/image/HMfxvym3ptFQoUw" target="_blank"><img src="https://s2.loli.net/2022/08/09/HMfxvym3ptFQoUw.png" width="800px"></a>
 </div> 
 <div align=center>
图三 HDMI Encoder/Decoder 示意图
 </div> 
若采用24位的颜色深度，每个通道的颜色数据占8位，那么每个通道上的颜色数据需要通过一个8B/10B的编码器（Encoder）来转换成一个10位的像素字符，然后通过并串转换器来转换成串行数据，通过TMDS通道发送出去，因此，这个串并转换过程生成的串行数据速率是实际像素时钟速率的10倍。

## Encoder简介

 <div align=center>
<a href="https://sm.ms/image/ixwFbu9SHNTAfmO" target="_blank"><img src="https://s2.loli.net/2022/08/09/ixwFbu9SHNTAfmO.png" width ="800px"></a>
 </div> 
 <div align=center>
图3 Encoder 编码器算法示意图
 </div> 
在编码器的工作下，每个通道输入的像素数据都会被编码成460个特定的10-bit字符中的一个，这个编码机制也实现了传输过程中的直流均衡（即每个编码的高电平和低电平数相同，且翻转次数在五次以内），Xilinx应用笔记XAPP460中提供了该编码模块，具体实现代码见文件encoder_1中。

## Xilinx 串并转换原语OSERDESE2介绍

OSERDESE2是一种专用的并-串转换器，每个OSERDESE2模块都包括一个专用串行化程序用于数据和3状态控制。数据和3状态序列化程序都可以工作在SDR和DDR模式。数据串行化的位宽可以达到8:1（如果使用原语模块级联，则可以到10:1和14:1）。3状态序列化最高可达14:1，有一个专用的DDR3模式可用于支持高速内存应用程序。，，内部具有自带的分频时钟。
 <div align=center>
<a href="https://sm.ms/image/cPuGSlOYw3UReCV" target="_blank"><img src="https://s2.loli.net/2022/08/09/cPuGSlOYw3UReCV.png" width ="800px"></a>
 </div> 
接口介绍如下  

 <div align=center>
<a href="https://sm.ms/image/Io5th8evFZSKHG3" target="_blank"><img src="https://s2.loli.net/2022/08/09/Io5th8evFZSKHG3.png" width ="800px"></a>
 </div> 
需要实例化的可用属性如下  

 <div align=center>
<a href="https://sm.ms/image/tBAWvL8VEgNzC7b" target="_blank"><img src="https://s2.loli.net/2022/08/09/tBAWvL8VEgNzC7b.png" width ="800px"></a>
 </div> 
DDR时序图如下  

 <div align=center>
<a href="https://sm.ms/image/kcIUtbFCQV87BmH" target="_blank"><img src="https://s2.loli.net/2022/08/09/kcIUtbFCQV87BmH.png" width ="800px"></a>
 </div> 
实际仿真波形如下，与数据手册中提供的时序图吻合  

 <div align=center>
<a href="https://sm.ms/image/c9ApeHi8tay4MvJ" target="_blank"><img src="https://s2.loli.net/2022/08/09/c9ApeHi8tay4MvJ.png" ></a>
 </div> 
