@[toc]

# thanox灭霸自动任务小脚本案例

### doc

- [欢迎使用Thanox - Thanox (tornaco.github.io)](https://tornaco.github.io/Thanox/)

- 情景模式Profile
  - [Profile - Thanox (tornaco.github.io)](https://tornaco.github.io/Thanox/docs/profile)
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

## miui自带的自动任务

- 2022年的miui手机管家已经支持比较基础的自动任务,也可以完成nfc/导航的条件触发,但是还不如thanox的情景触发强大
- 但是胜在方便(名牌专用软件)/thanox是android通用的(却有root风险)
