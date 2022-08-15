## **LCD屏幕触摸芯片GT1151Q介绍**

I2C协议控制，全程均作为从设备，I2C的通讯速度为400Kbps或以下。

设备有如下几个模式：

**a.普通模式 (Normal mode)**

GT1151Q 在 Normal mode 时，坐标刷新周期为 5ms-20ms 间（依赖于配置信息的设定，配置信息可控周期步进长度为 1ms）。

**b.节能模式 (Green mode)**

Normal mode 状态下，一段时间无触摸事件发生，GT1151Q 将自动转入Green mode，以降低功耗。GT1151Q 无触摸自动进入 Green mode 的时间可通过配置信息设置，范围为 0~14s，步进为 1s，Green mode 可关闭。在 Green mode 下，GT1151Q扫描周期约为 40ms，若检测到有触摸动作发生，自动进入 Normal mode。

**c.手势模式(Gesture mode)**

若主 CPU 通过 I2C 命令，GT1151Q 进入 Gesture 模式后，可通过滑动屏体、双击或者在屏体上书写特定字符实现唤醒。

在 Gesture 模式下， GT1151Q 检测到手指在屏体上滑动足够的长度、双击动作、书写特定字符、书写自定义字符，INT 就会输出一个 250us 以上（配置可配）的脉冲或一直维持高，主控收到脉冲后醒来亮屏。

**d.睡眠模式(Sleep mode)**

主 CPU 通过 I2C 命令，使 GT1151Q 进入 Sleep mode。当需要GT1151Q退出Sleepmode 时，主机对 GT1151Q 执行复位操作。复位后 GT1151Q 将进入Normal mode。下发命令与复位之间的时间间隔要求大于 58ms。

接口说明：有如下6个PIN，分别为VDD、GND、SCL、SDA、INT、RESET。

操作时序为标准IIC时序，不进行赘述。

寄存器列表：详细见数据手册

## 操作时序：

**1.上电时序**
<a href="https://sm.ms/image/h6cP1EVIXLmRsrN" target="_blank"><img src="https://s2.loli.net/2022/08/15/h6cP1EVIXLmRsrN.png"  width = '800'></a>

**2.复位时序**
<a href="https://sm.ms/image/zQPwOGfLVkF26Rl" target="_blank"><img src="https://s2.loli.net/2022/08/15/zQPwOGfLVkF26Rl.png" width = '800'></a>

**3.掉电时序**
<a href="https://sm.ms/image/i8eXraPLzUE6xsp" target="_blank"><img src="https://s2.loli.net/2022/08/15/i8eXraPLzUE6xsp.png" width = '800'></a>

**4.上电发送配置信息**

主机控制 GT1151Q 上电过程中，当主控拉高 RESET 后，需要延时 60ms 再判断是否需要发送配  置信息。如果收到了“0x01”请求，就需要发送配置信息，否则不需要。

**5.坐标读取**

BUFFER STATUS 为0X814E的最高位

<a href="https://sm.ms/image/RKAsgpSxqE5Ml1r" target="_blank"><img src="https://s2.loli.net/2022/08/15/RKAsgpSxqE5Ml1r.png" width = '800'></a>

<a href="https://sm.ms/image/fbHCcIYnRZXh5E1" target="_blank"><img src="https://s2.loli.net/2022/08/15/fbHCcIYnRZXh5E1.png" width = '800'></a>

## 代码设计思路：
<a href="https://sm.ms/image/cJNfs7XwIMVS49t" target="_blank"><img src="https://s2.loli.net/2022/08/15/cJNfs7XwIMVS49t.jpg" width ='1000' ></a>

总体的构架框图如上，时钟生成模块产生50M的IIC驱动时钟和33M的LCD驱动时钟，通过触摸驱动模块产生IIC的读写信号以及触摸屏的RST以及INT信号，对触摸芯片的状态寄存器进行轮询，有触摸后获取其触摸信息，根据触摸信息确定触摸点位，将触摸点位信息发送给像素信息生成模块（跨时钟域的传输采用FIFO来进行通信），像素生成模块根据获得的位置信息来输出给屏幕特定的显示数据，然后通过LCD驱动模块来驱动显示屏显示

<a href="https://sm.ms/image/KhwlnuZ43xLDGHU" target="_blank"><img src="https://s2.loli.net/2022/08/15/KhwlnuZ43xLDGHU.jpg" width ='1000' ></a>

其中的LCD显示驱动同VGA显示驱动类似，IIC也为标准的IIC接口时序，器件地址和寄存器地址都如之前介绍，上图为在设计触摸驱动时所作的草图（波形图与最终程序存在一些差距）
