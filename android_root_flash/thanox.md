@[toc]

# thanox灭霸自动任务小脚本案例

### doc

- [欢迎使用Thanox - Thanox (tornaco.github.io)](https://tornaco.github.io/Thanox/)

- 情景模式Profile
  - [Profile - Thanox (tornaco.github.io)](https://tornaco.github.io/Thanox/docs/profile)
- 仓库中的代码:(thanox api)
  - [Thanox/android/android_framework/base/src/main/java/github/tornaco/android/thanos/core at 2fa3808d4158c1dfd937172636c0e2e9bb27d305 · Tornaco/Thanox](https://github.com/Tornaco/Thanox/tree/2fa3808d4158c1dfd937172636c0e2e9bb27d305/android/android_framework/base/src/main/java/github/tornaco/android/thanos/core)
  - [Thanox/android/android_framework/base/src/main/java/github/tornaco/android/thanos/core at 2fa3808d4158c1dfd937172636c0e2e9bb27d305 · Tornaco/Thanox](https://github.com/Tornaco/Thanox/tree/2fa3808d4158c1dfd937172636c0e2e9bb27d305/android/android_framework/base/src/main/java/github/tornaco/android/thanos/core)

- 仓库中的参考情景(json)
  - [Thanox/android/modules/module_profile/src/main/assets/prebuilt_profile at 91abb67b2e899aaf70665d57c2ec5fa619d33acc · Tornaco/Thanox · GitHub](https://github.com/Tornaco/Thanox/tree/91abb67b2e899aaf70665d57c2ec5fa619d33acc/android/modules/module_profile/src/main/assets/prebuilt_profile)


## 情景模式语法

- 情景模式语法估计是java
  - 在`condition`和`actions`对应的值就是java代码
  - 但是由于情景模式内容要求是json(或者yaml)的形式,
    - java代码需要先处理成字符串,然后交给thanox解析
    - 有thanox请求虚拟机代为执行

## thanox 自带示例

- 除了参考文档,从thanox app 中可以导入在线案例,可以进一步了解情景模式写法

## 延迟执行的方法和案例

- 主要有两类控制延迟执行的方式

### delay

- 可以使用`delay`字段控制延迟(by thanox)

#### 息屏2秒后自动关闭NFC

```json
[
  {
    "name": " off NFC",
    "description": "turn NFC off after screenoff(锁屏2s后关闭NFC)",
    "priority": 1,
    "delay": 2000,
    "condition": "screenOff&&hw.isNfcEnabled()",
    "actions": [
      "ui.showShortToast('关闭NFC')+hw.disableNfc()"
    ]
  }
]

```

### Thread.sleep

- 也可以使用`Thread.sleep()`控制延迟执行(by java)

#### 解锁亮屏自动开启NFC

- 解锁亮屏自动开启NFC,3秒自动后关闭NFC



```json
[
  {
    "name": " flash NFC",
    "description": "turn NFC on temporarily after screenOn(NFC)",
    "priority": 1,
    "delay": 1,
    "condition": "screenOn==true&&!hw.isNfcEnabled()",
    "actions": [
      "ui.showShortToast('🎈开启NFC，保持3s后关闭')",
      "hw.enableNfc();",
      "ui.showShortToast(\"🎢关闭NFC\")",
      "Thread.sleep(3000)",
      "hw.disableNfc()"
    ]
  }
]
```



## 利用java API来编写自动化任务

### 时间段(时间区间)执行任务(情景模式)

- 时间区间判断

```json
[
  {
    "name": "设定时间段，在指定时间段执行任务(亮屏/息屏5g为例)",
    "description": "采用一天24时记法;本例子中，在早上5:10分～22:40内，亮屏开启5g，息屏关闭5g（变成4g）其余时间，不作妖;可以自行设定延时执行delay字段(单位是毫秒，也就是说1分钟要设置成60*1000=60000秒)，或者讲代码中的时间点改成你想要的;如果需要秒级精确度，可以照样子添加条件链    您可在代码中找到start_hour,start_minute,end_hour,end_minute变量(默认值分别为5,10,22,40,将这几个值修改为你需要的时间段,分别代表开始时间的小时,分钟;结束时间的小时,分钟)",
    "priority": 2,
    "delay": 500,
    "condition": "if(screenOn||screenOff){import java.util.Date;Date date=new Date();int hour=date.getHours(),minute=date.getMinutes(),second=date.getSeconds();int start_hour=5,start_minute=10,end_hour=22,end_minute=40,start_minute_of_day=start_hour*60+start_minute*1,end_minute_of_day=(end_hour)*60+(end_minute)*1,now_minute_of_day=hour*60+minute;ui.showShortToast(\"🎈now_time:\"+hour+\":\"+minute+\":\"+second);if(start_minute_of_day<=now_minute_of_day&&now_minute_of_day<=end_minute_of_day){ui.showShortToast('🎉当前时刻处于情景有效期,执行任务:'+'...');ui.showShortToast('🎁调试信息:任务有效时间[分钟化统计]:'+start_minute_of_day+' ~ '+end_minute_of_day+' 👓now:'+now_minute_of_day);if(screenOn){su.exe('service call miui.radio.extphone 28 i32 1 i32 0');ui.showShortToast('亮屏，5g打开')} else if(screenOff){su.exe('service call miui.radio.extphone 28 i32 0 i32 0');ui.showShortToast('息屏，关闭5g'))};}}",
    "actions": [
      ""
    ]
  }
]

```

- 下面是一个逻辑判断错误的版本:

  - `if( hour>=start_hour&&hour<=end_hour&&minute>=start_minute&&minute<=end_minute){......}`

    

    





## 桌面快捷方式创建(行为触发器)

### NFC桌面开关

- 旧版本

- ```json
  [
      {
          "name": "nfc",
          "description": "nfc",
          "priority": 2,
          "condition": "if(shortcutLaunched == true && shortcutValue == 'NFC'&& hw.isNfcEnabled() == false){(ui.showShortToast('打开NFC✔️✅') + hw.enableNfc()+ringtone.dingdingding(2))}else if (shortcutLaunched == true && shortcutValue == 'NFC'&& hw.isNfcEnabled() == true) {(ui.showShortToast('关闭NFC🧔👲')+hw.disableNfc()+ringtone.dingdingding(1))}",
          "actions": [
              ""
          ]
      }
  ]
  ```

  

- 桌面快捷方式需要创建快捷方式,通过value来对应情景模式

- 给与thanox必要的创建桌面快捷方式才行

  - [🎈🎈🎈doc of thanox](https://tornaco.github.io/Thanox/docs/profile#0515-%E5%BF%AB%E6%8D%B7%E6%96%B9%E5%BC%8F)
    - 例如
    - ![在这里插入图片描述](https://img-blog.csdnimg.cn/78e6f290932e484685ee7bc785ec60b7.png)

### 采用adb 命令方式执行NFC开关控制

- 您可以使用`anywhere`这个app 方便地创建adb 命令的开关
  - 并且开关是**带有状态**的
  - 事实上,NFC可以通过`svc`命令开控制:
    -  `svc nfc enable`
    - `svc nfc disable`

### 息屏关闭NFC

```json
[
    {
        "name": "sn",
        "description": "turn off nfc at once if the screenOff",
        "priority": 1,
        "condition": "screenOff==true",
        "actions": [
            "if(hw.isNfcEnabled()==true){ringtone.dingdingding()+ui.showShortToast('Nfc was on before screenOff🎅,try to turn off nfc!🛑')+hw.disableNfc()}",
            ""
        ]
    }
]
```





## 执行脚本

### 自动化网络切换

#### sh.exe()/su.exe()使用案例:5G/4G网络自动切换

- 根据某个应用(这里以com.zfsoft.newzjgs为例)的启动（切入和杀死来开启或者关闭5g网络（到4g）

```json
[
    {
        "name": "s5gzjgsu",
        "description": "根据某个应用(这里以com.zfsoft.newzjgs为例)的启动（切入和杀死来开启或者关闭5g网络（到4g）",
        "priority": 1,
        "condition":  "if (frontPkgChanged == true && to == 'com.zfsoft.newzjgs'){su.exe('service call miui.radio.extphone 28 i32 1 i32 0')} else if(taskRemoved==true && pkgName=='com.zfsoft.newzjgs'){su.exe('service call miui.radio.extphone 28 i32 0 i32 0')})",
      "actions": [
			""

       ]
    }
]
```



#### 进入应用商店后自动切换5g

```json

[
  {
    "name": "5g appMarket",
    "description": "打开应用商店后开启5g网络，杀掉应用商店是将网络切换为4g，适合于平常不用5g，但是流量充足的用户",
    "priority": 1,
    "condition": "if (frontPkgChanged == true && to == 'com.xiaomi.market'){su.exe('service call miui.radio.extphone 28 i32 1 i32 0');ui.showShortToast('5g打开')} else if(taskRemoved == true && pkgName == 'com.xiaomi.market'){su.exe('service call miui.radio.extphone 28 i32 0 i32 0');ui.showShortToast('关闭5g'))};",
    "actions": [
      ""
    ]
  }
]


[
  {
    "name": "nokeep",
    "description": "nokeep",
    "priority": 2,
    "condition": "screenOff==true",
    "actions": [
      "foreach(tsk:globalVarOf$nokeep){killer.killPackage(tsk)}",
      "ui.showShortToast('kill nokeep apps')"
    ]
  }
]


```

#### 自动打开定位

- 如果某个app在自动打开定位的清单里,打开app后自动打开定位

  - 杀掉app后,关闭定位

  - 但是如果有导航app在运行,就不关定位

    - 这里用的api不是很准确,有空在琢磨(thanox.ActivityManager?)

  - ```json
    [
      {
        "name": "为定位打卡签到类和导航APP自动启动定位 v1",
        "description": "需要创建叫locationapps的全局变量!（往里面添加需要启动后需要自动打开导航的APP）   默认情况下，如果划掉后台相应APP后台，会被认为不再需要导航了，会关闭导航。  为了不影响导航地图类APP使用，建立另一个全局变量keepLocation,用来指定豁免清单(可讲高德或者百度地图加入其中)，（使用thanox的pick来添加APP包名到环境变量里比较方便.)",
        "priority": 1,
        "delay": 0,
        "condition": " if(frontPkgChanged&&globalVarOf$locationApps.contains(to)){ui.showShortToast(\"即将开启定位,for\"+to);hw.enableLocation();} if(taskRemoved == true && globalVarOf$locationApps.contains(pkgName) ){foreach(app:globalVarOf$keepLocation){if(task.hasTaskFromPackage(app)){ui.showShortToast(\"地图类APP在运行，不关闭导航\");break}}ui.showShortToast(\"即将关闭定位,by\"+pkgName);hw.disableLocation();}}",
        "actions": [
          ""
        ]
      }
    ]
    ```

    

#### 错误(失败案例)

- 下面这段代码不能够实现目的,有空在琢磨

```json
[
  {
    "name": "为打卡签到类APP自动启动定位",
    "description": "息屏时立即杀死全局变量中的进程名(需要创建叫locationapps的全局变量，并且讲需要自动打开定位的APP加入（pick到里面)",
    "priority": 1,
    "delay": 0,
    "condition": "if (frontPkgChanged==true){foreach(locApp:globalVarOf$locationApps){if(to==locApp){ui.showShortToast(\"即将开启定位,for\"+locApp);hw.enableLocation();}else if(taskRemoved == true && pkgName == locApp){ui.showShortToast(\"即将关闭定位,by\"+locApp);hw.disableLocation();}}}",
    "actions": [
      ""
    ]
  }
]
```



- su.exe()是以root权限运行的,所以不像sh.exe()那样容易遇到权限不足而无法运行
- 这里包名的获取方案有多种,比如三方app
  - thanox自带开发者工具可以
  - android开发者电量性能检查也相关功能
  - MT管理器
  - 爱玩机等

##  遍历(powered by java)

- foreach循环遍历全局变量实例
### 锁屏杀死不必要后台(nokeep)

```json
[
  {
    "name": "nokeep",
    "description": "nokeep",
    "priority": 1,
    "condition": "screenOff==true",
    "actions": [
      "foreach(tsk:globalVarOf$nokeep){killer.killPackage(tsk)}",
      "ui.showShortToast('kill nokeep apps')"
    ]
  }
]
```

## 全局变量

### 创建全局变量

- 上面的锁屏杀后台需要创建一个全局变量,名为nokeep
  - 创建的时候,可以直接`pick app`,选择需要锁屏杀死的app(包名)
  - 也可以在进程管理哪里单击,然后选择加入到指定的全局变量中

### 充电时保证scene在后台运行

- 如果scene没有运行,则拉起充电统计的activity
  - 保证充电过程可以记录下来
  - 检查充电是否异常

```json
[
  {
    "name": "chg",
    "description": "chg",
    "priority": 1,
    "condition": "battery.getBatteryState().isCharging &&!task.hasTaskFromPackage('com.omarea.vtools')",
    "actions": [
      "ui.showShortToast('scene not actived')",
      "su.exe('am start -n com.omarea.vtools/com.omarea.vtools.activities.ActivityCharge')",
      "ui.showLongToast('try to active scene done ')"
    ]
  }
]

```



## thanox常驻后台

- 上述网络切换中用到后台切换的监视:frontPkgChanged,这需要thanox保持后台活跃,否则无法捕获到相关信号导致无法执行自动任务

### 利用thaox 保持指定应用集合后台活跃

- 本功能不同于后台保活,但是可以在app被杀掉后立刻重启(比如通讯软件,以免遗漏消息接受)

```json

[
    {
        "name": "keepbg保持进程活跃v1",
        "description": "keepbg;保持指定应用活跃在后台😂😂😂主要是聊天通讯软件以及一些需要常驻后台的进程😂task.hasTaskFromPackage('com.tencent.mm')==false不靠谱 注意，只有开机手动启动过一次的软件才可以后续的活跃保持，否则无法保持活跃 👿👿需要创建环境变量Keepbg，将需要活跃的APP包名pick到里面，作为需要保持活跃的清单",
        "priority": 1,
        "condition": "pkgKilled == true &&globalVarOf$keepbg.contains(pkgName)",
        "actions": [
            "//ui.showShortToast('😱😣<'+pkgName+' >was killed,try to arouse it 🍅₍˄·͈༝·͈˄*₎◞ ̑̑')",
            "activity.launchProcessForPackage(pkgName)",
            "/*Thread.sleep(1000)*/",
            "//ui.showShortToast('try to active< '+pkgName+'>done 🍔=͟͟͞͞=͟͟͞͞(●⁰ꈊ⁰● ')",
            "return"
        ]
    }
]
```



## miui自带的自动任务

- 2022年的miui手机管家已经支持比较基础的自动任务,也可以完成nfc/导航的条件触发,但是还不如thanox的情景触发强大
- 但是胜在方便(名牌专用软件)/thanox是android通用的(却有root风险)

