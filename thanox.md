[toc]

# thanox灭霸自动任务小脚本案例

### doc

- [欢迎使用Thanox - Thanox (tornaco.github.io)](https://tornaco.github.io/Thanox/)

- 情景模式Profile
  - [Profile - Thanox (tornaco.github.io)](https://tornaco.github.io/Thanox/docs/profile)

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

  - https://tornaco.github.io/Thanox/docs/profile#0515-%E5%BF%AB%E6%8D%B7%E6%96%B9%E5%BC%8F
    - 例如
    - ![image-20221006192543907](D:\repos\blogs\assets\image-20221006192543907.png)

  

### 息屏关闭NFC

```json
[
    {
        "name": "sn",
        "description": "sn",
        "priority": 1,
        "condition": "screenOff==true",
        "actions": [

            "if(hw.isNfcEnabled()==true){ringtone.dingdingding()+ui.showShortToast('Nfc was on before screenOff🎅,try to turn off nfc!🛑')+hw.disableNfc()}",
            ""
        ]
    }
]
```



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

## thanox常驻后台

- 上述网络切换中用到后台切换的监视:frontPkgChanged,这需要thanox保持后台活跃,否则无法捕获到相关信号导致无法执行自动任务

## miui自带的自动任务

- 2022年的miui手机管家已经支持比较基础的自动任务,也可以完成nfc/导航的条件触发,但是还不如thanox的情景触发强大
- 但是胜在方便(名牌专用软件)/thanox是android通用的(却有root风险)



