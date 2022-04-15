# VGA接口
## 项目一：[VGA_COLORBAR](https://github.com/siimnzou/FPGA_learning/edit/main/Library/VGA/VGA_COLORBAR)
主要实现了通过VGA显示等宽10色彩条，了解VGA的接口时序。
### 一、介绍
VGA的显示原理: 采用扫描的方式，将像素点在行同步信号和场同步信号的同步下，按照从上到下，从左到右的顺序扫描到显示屏上，扫描完一帧后重新回到最开始进行扫描。
### 二、 时序标准
根据VESA VGA时序标准，VGA的时序可以分为行同步时序和场同步时序。  
<div align=center>
<a href="https://sm.ms/image/rY3j5ApebN2qTQi" target="_blank"><img src="https://s2.loli.net/2022/04/15/rY3j5ApebN2qTQi.png"  ></a>
图一 VGA接口时序图
</div>  


在一个行扫描周期中，一共分为6个阶段：Sync, Back porch, Left Border, “Addressable” Video, Right Border ,Front Porch。 行同步信号Hsync在Sync阶段内拉高，其余时间均为低电平，直到下一个行扫描周期的Sync阶段到来时再次拉高，标志着一个行扫描周期的结束。而输出的图像信息，只有在“Addressable” Video期间才有效，其余时间无效。  

同理，一个场扫描周期中也分为6个阶段：Sync, Back porch, Top Border, “Addressable” Video, Bottom Border ,Front Porch。场同步信号VSync会在Sync阶段拉高，图像信息只在“Addressable” Video期间有效，其余时间无效。  

而各阶段的参数根据分辨率以及刷新频率的不同都有着严格的定义，本次实验工程采取的是1280x1024@60Hz，根据参数配置表可以得出相关参数。  

<div align=center>
<a href="https://sm.ms/image/HK9AC35TBMqoJNu" target="_blank"><img src="https://s2.loli.net/2022/04/15/HK9AC35TBMqoJNu.png" width="500px"></a>  

图2 VESA VGA时序标准（1280 x 1024 @ 60Hz）
</div> 

**时钟(Pixel Clock):108Mhz**

**行扫描周期数(Hor Total Time): 1688 pixels**

**行同步阶段（Hor Sync Time ）: 112 pixels**

**行有效图像(Hor Addr Time): 1280 pixels**

根据 Blank Start = “Addressable” Video + Right Border = 1280 pixels 可以得出
**右边框（Right Border） = 0 pixels**

根据 Sync Start = “Addressable” Video + Right Border + Front Porch= 1328 pixels 可以得出
**前沿（Front Porch） = 48 pixels**

根据 Blank Time = Front Porch + Sync + Back Porch = 408 pixels 可以得出
 **后沿（Back Porch） = 248 pixels**

故其行时序图如下
<div align=center>
<a href="https://sm.ms/image/XR8bIjBviW6SoQ2" target="_blank"><img src="https://s2.loli.net/2022/04/15/XR8bIjBviW6SoQ2.png" ></a>
图3 行时序标准
</div> 

同理可以得出场时序图如下
<div align=center>
<a href="https://sm.ms/image/4ticNGqlpuM7BSk" target="_blank"><img src="https://s2.loli.net/2022/04/15/4ticNGqlpuM7BSk.png" ></a>
图4 场时序标准
</div> 

### 三、硬件部分
<div align=center>
<a href="https://sm.ms/image/5FrvpMBPVbz8NGt" target="_blank"><img src="https://s2.loli.net/2022/04/15/5FrvpMBPVbz8NGt.png" width="800px" ></a>  
  
 图5 VGA接口图
</div> 
VGA 接口共有15个引脚,其中123 分别为红基色，绿基色，蓝基色通道，负责三原色的信号传输，传递的是模拟信号，引脚13 和 14 分别为行同步信号以及场同步信号，4、11、12、15为地址码，6、7、8、9为接地端口，5、9为自测试和预留端口。
<div align=center>
<a href="https://sm.ms/image/BjFMb3U7AuqHsQT" target="_blank"><img src="https://s2.loli.net/2022/04/15/BjFMb3U7AuqHsQT.png" ></a>
图6 硬件原理图
</div> 

采用野火征途系列开发板，传入三基色通道的信号为FPGA的数字信号经过权电阻网络转换为模拟信号后传入，采用的图像显示模式为RGB565模式，三路模拟输入的电压范围为0-0.714V,从低到高颜色分别加深。

### 四、设计框图
<a href="https://sm.ms/image/yvOSts6HpJhNiBV" target="_blank"><img src="https://s2.loli.net/2022/04/15/yvOSts6HpJhNiBV.png" ></a>
