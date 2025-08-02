[toc]

## powershell@输入法管理

### ref

-  [Default input profiles (input locales) in Windows | Microsoft Learn](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/default-input-locales-for-windows-language-packs?view=windows-11)

## WinuserLanguageList

- `Get-WinUserLanguageList|gm|ft -wrap `查询可用方法


## powershell函数

- 下面这几个函数可用在powershell7下调用

  - 它是通过调用windows自带的`powershell 5`来执行相关的设置(poweshell7中相关命令可能缺失的)

  - 如果无法成功执行,那么原因可能有多种,而下面的脚本假设输入法环境是这样的


### 查看已安装的语言列表和输入法代号

- ```cmd
  
  LanguageTag     : en-US
  Autonym         : English (United States)
  EnglishName     : English
  LocalizedName   : English (United States)
  ScriptName      : Latin
  InputMethodTips : {0409:00000409}
  Spellchecking   : True
  Handwriting     : False
  
  LanguageTag     : zh-Hans-CN
  Autonym         : 中文(中华人民共和国)
  EnglishName     : Chinese
  LocalizedName   : Chinese (Simplified, China)
  ScriptName      : Chinese (Simplified)
  InputMethodTips : {0804:{E7EA138E-69F8-11D7-A6EA-00065B844310}{E7EA138F-69F8-11D7-A6EA-000
                    65B844311}, 0804:{81D4E9C9-1D3B-41BC-9E6C-4B40BF79E35E}{FA550B04-5AD7-41
                    1F-A5AC-CA038EC515D7}}
  Spellchecking   : True
  Handwriting     : True
  ```

#### 添加或删除搜狗输入法

- 本代码使用了较多的硬编码(因为相关接口提供的信息有限),

```powershell

function check_keyboards
{
    powershell.exe { 
        Write-Output $(get-winUserLanguageList);
        #  $zh = $l[1].inputMethodTips;
    }
}
function check_zh_keyboards
{
    powershell.exe { 
        $l = get-winUserLanguageList
        $zh = $l | Where-Object { $_.languageTag -match 'zh-hans-cn' }
        return $zh
    }
}
function remove_sogou_keyboard
{
    powershell.exe { 
        $l = get-winUserLanguageList; 
        # $zh = $l[1].inputMethodTips;
        # $zh = check_zh_keyboards#无法直接从pwsh5传递对象回pwsh7
        $zh = $l | Where-Object { $_.languageTag -match 'zh-hans-cn' }
        $zhTips=$zh.inputMethodTips
        Write-Output "list:$l; `nzh:$zh"
        # $sogou_keyboard = $zhTips[1]
        $sogou_keyboard = $zhTips | Where-Object { $_ -like '*e7ea*'}
        Write-Output "sogou:$sogou_keyboard"
        $zhTips.remove($sogou_keyboard)
        Write-Output "now:$zh"

        Set-WinUserLanguageList -LanguageList $l -Force }
}
function add_sogou_keyboard
{
    # param ()
    powershell.exe {
        $sogou_keyboard_tips = '0804:{E7EA138E-69F8-11D7-A6EA-00065B844310}{E7EA138F-69F8-11D7-A6EA-00065B844311}'
        $l = get-winUserLanguageList; $zh = $l[1].inputMethodTips;
        Write-Output "list:$l; `nzh:$zh;`nsogou_keyboard_tips:$sogou_keyboard_tips"
        $zh.add($sogou_keyboard_tips)
        Write-Output "now:zh:$zh"
        Set-WinUserLanguageList -LanguageList $l -Force
    }

}
```

#### 运行结果

- 添加Sogou键盘

- ```powershell
  PS C:\Users\cxxu\Desktop> add_sogou_keyboard
  list:Microsoft.InternationalSettings.Commands.WinUserLanguage Microsoft.InternationalSettings.Commands.WinUserLanguage;
  zh:Microsoft.InternationalSettings.Commands.WinUserLanguage;
  sogou_keyboard_tips:0804:{E7EA138E-69F8-11D7-A6EA-00065B844310}{E7EA138F-69F8-11D7-A6EA-00065B844311}
  now:zh:Microsoft.InternationalSettings.Commands.WinUserLanguage
  WARNING: If the Windows Display Language has changed, it will take effect after the next
  sign-in.
  WARNING: If the Windows Display Language has changed, it will take effect after the next
  sign-in.
  ```

  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/bf6a7480fa644fcf85aa38fb5ba32aaa.png)

- 临时移除Sogou键盘

  - ```cmd
    PS C:\Users\cxxu\Desktop> add_sogou_keyboard^C
    PS C:\Users\cxxu\Desktop> remove_sogou_keyboard
    list:Microsoft.InternationalSettings.Commands.WinUserLanguage Microsoft.InternationalSettings.Commands.WinUserLanguage;
    zh:Microsoft.InternationalSettings.Commands.WinUserLanguage
    sogou:0804:{E7EA138E-69F8-11D7-A6EA-00065B844310}{E7EA138F-69F8-11D7-A6EA-00065B844311}
    True
    now:Microsoft.InternationalSettings.Commands.WinUserLanguage
    WARNING: If the Windows Display Language has changed, it will take effect after the next
    sign-in.
    WARNING: If the Windows Display Language has changed, it will take effect after the next
    sign-in.
    ```

    ![在这里插入图片描述](https://img-blog.csdnimg.cn/1e96c438e4cc4992a0f3b6f365caee10.png)

## 移除指定键盘输入法

- 如果是英文系统,移除英文键盘比较困难(会自动恢复),但是可以将其从默认键盘顶替掉
- 可以借助搜狗输入法的输入法管理器设置将en-us键盘移除,但是重启后会恢复

```powershell
powershell.exe { 
    
    $zh = 'zh-hans-cn'
    $en='en-US'
    $lang=$en
    
    $l = Get-WinUserLanguageList; 
    $Lang = $l | Where-Object { $_.languageTag -match $lang }
    $LangTips = $Lang.inputMethodTips
    # 具体的输入法
    $sogou_keyboard = $LangTips | Where-Object { $_ -like '*e7ea*' }
    $en_us_keyboard = $LangTips | Where-Object { $_ -like '*0409:00000409*' }
    $wetype_keyboard = $LangTips | Where-Object { $_ -like '*86598FB9*' }
    $IME = $en_us_keyboard

    Write-Output "IME:$IME"

    $LangTips.remove($IME)
    Write-Output $l

    Set-WinUserLanguageList -LanguageList $l -Force -Verbose
}
```



## 扩展功能

- 如果您还使用其他键盘,可以按照上述方法,记录下来它们的键盘ID,自定义自己的powershell开关



## powershell5@WinuserLanguageList操作输入法列表布局

- 获取当前用户的(已启用/添加的)输入法列表

  ```cmd
  PS C:\> $l=Get-WinUserLanguageList
  PS C:\> $l
  
  
  LanguageTag     : en-US
  Autonym         : English (United States)
  EnglishName     : English
  LocalizedName   : English (United States)
  ScriptName      : Latin
  InputMethodTips : {0409:00000409}
  Spellchecking   : True
  Handwriting     : False
  
  LanguageTag     : zh-Hans-CN
  Autonym         : 中文(中华人民共和国)
  EnglishName     : Chinese
  LocalizedName   : Chinese (Simplified, China)
  ScriptName      : Chinese (Simplified)
  InputMethodTips : {0804:{81D4E9C9-1D3B-41BC-9E6C-4B40BF79E35E}{FA550B04-5AD7-411F-A5AC-CA038EC515D7},
                    0804:{E7EA138E-69F8-11D7-A6EA-00065B844310}{E7EA138F-69F8-11D7-A6EA-00065B844311}}
  Spellchecking   : True
  Handwriting     : True
  ```

  

### 修改列表

- 移除列表中的某个语言下的所有输入法

```cmd

PS C:\> $l.remove($l[1])
True
PS C:\> $l


LanguageTag     : en-US
Autonym         : English (United States)
EnglishName     : English
LocalizedName   : English (United States)
ScriptName      : Latin
InputMethodTips : {0409:00000409}
Spellchecking   : True
Handwriting     : False

#保存修改!
PS C:\> Set-WinUserLanguageList -LanguageList $l -Force
WARNING: If the Windows Display Language has changed, it will take effect after the next sign-in.

```

- 检查当前输入法列表(确认修改是否成功)

- ```
  
  PS C:\>  Get-WinUserLanguageList
  
  
  LanguageTag     : en-US
  Autonym         : English (United States)
  EnglishName     : English
  LocalizedName   : English (United States)
  ScriptName      : Latin
  InputMethodTips : {0409:00000409}
  Spellchecking   : True
  Handwriting     : False
  
  ```

- 添加某个语言的输入法

- ```cmd
  
  PS C:\> $l.Add('zh-hans-cn')
  PS C:\> $l
  
  
  LanguageTag     : en-US
  Autonym         : English (United States)
  EnglishName     : English
  LocalizedName   : English (United States)
  ScriptName      : Latin
  InputMethodTips : {0409:00000409}
  Spellchecking   : True
  Handwriting     : False
  
  LanguageTag     : zh-hans-cn
  Autonym         : 中文(中华人民共和国)
  EnglishName     : Chinese
  LocalizedName   : Chinese (Simplified, China)
  ScriptName      : Chinese (Simplified)
  InputMethodTips : {0804:{81D4E9C9-1D3B-41BC-9E6C-4B40BF79E35E}{FA550B04-5AD7-411F-A5AC-CA038EC515D7}}
  Spellchecking   : True
  Handwriting     : True
  
  
  
  PS C:\> Set-WinUserLanguageList -LanguageList $l -Force
  WARNING: If the Windows Display Language has changed, it will take effect after the next sign-in.
  WARNING: If the Windows Display Language has changed, it will take effect after the next sign-in.
  ```

### 增加或修改某个语言下的键盘(输入法)👺

```cmd
PS C:\> $l=Get-WinUserLanguageList
PS C:\> $l


LanguageTag     : en-US
Autonym         : English (United States)
EnglishName     : English
LocalizedName   : English (United States)
ScriptName      : Latin
InputMethodTips : {0409:00000409}
Spellchecking   : True
Handwriting     : False

LanguageTag     : zh-Hans-CN
Autonym         : 中文(中华人民共和国)
EnglishName     : Chinese
LocalizedName   : Chinese (Simplified, China)
ScriptName      : Chinese (Simplified)
InputMethodTips : {0804:{81D4E9C9-1D3B-41BC-9E6C-4B40BF79E35E}{FA550B04-5AD7-411F-A5AC-CA038EC515D7}, 0804:{E7EA138E-69F8-11D7-A6EA-00065B844310}{E7EA138F-69F8-11D7-A6EA-00065B844311}}
Spellchecking   : True
Handwriting     : True



PS C:\> $targetStr=$l[1].InputMethodTips
PS C:\> $targetStr
0804:{81D4E9C9-1D3B-41BC-9E6C-4B40BF79E35E}{FA550B04-5AD7-411F-A5AC-CA038EC515D7}
0804:{E7EA138E-69F8-11D7-A6EA-00065B844310}{E7EA138F-69F8-11D7-A6EA-00065B844311}
PS C:\> $targetStr|gm|select -First 2


   TypeName: System.String

Name      MemberType Definition
----      ---------- ----------
Clone     Method     System.Object Clone(), System.Object ICloneable.Clone()
CompareTo Method     int CompareTo(System.Object value), int CompareTo(string strB), in...


PS C:\> $targetStr[1]
0804:{E7EA138E-69F8-11D7-A6EA-00065B844310}{E7EA138F-69F8-11D7-A6EA-00065B844311}
PS C:\> $targetStr[0]
0804:{81D4E9C9-1D3B-41BC-9E6C-4B40BF79E35E}{FA550B04-5AD7-411F-A5AC-CA038EC515D7}
PS C:\> $l[1].InputMethodTips.remove($targetStr[1])
True
PS C:\> $l


LanguageTag     : en-US
Autonym         : English (United States)
EnglishName     : English
LocalizedName   : English (United States)
ScriptName      : Latin
InputMethodTips : {0409:00000409}
Spellchecking   : True
Handwriting     : False

LanguageTag     : zh-Hans-CN
Autonym         : 中文(中华人民共和国)
EnglishName     : Chinese
LocalizedName   : Chinese (Simplified, China)
ScriptName      : Chinese (Simplified)
InputMethodTips : {0804:{81D4E9C9-1D3B-41BC-9E6C-4B40BF79E35E}{FA550B04-5AD7-411F-A5AC-CA0
                  38EC515D7}}
Spellchecking   : True
Handwriting     : True



PS C:\> Set-WinUserLanguageList $l -Force

WARNING: If the Windows Display Language has changed, it will take effect after the next
sign-in.
WARNING: If the Windows Display Language has changed, it will take effect after the next
sign-in.
PS C:\>
```

### Note

- 修改过程中需要注意对象类型,有些属性是字符串类型或只读类型的,对它们进行直接赋值的方法会报错

  - ```powershell
    PS C:\>  $l[1].InputMethodTips=""
    'InputMethodTips' is a ReadOnly property.
    At line:1 char:2
    +  $l[1].InputMethodTips=""
    +  ~~~~~~~~~~~~~~~~~~~~~~~~
        + CategoryInfo          : InvalidOperation: (:) [], RuntimeException
        + FullyQualifiedErrorId : PropertyAssignmentException
    ```

  - 但不一定真的不可修改,只不过需要调用对象的方法才可以修改成功

- 另一个建议是,有些属性它是字符,字符串包含了多个值,有时我们需要引用该属性的某一个值(而不是全部),为例保证不出错,建议索引某个元素前将其打印出来

  - ```cmd
    PS C:\> $target=$l[1].InputMethodTips
    
    PS C:\> $target.GetType()
    
    IsPublic IsSerial Name                                     BaseType
    -------- -------- ----                                     --------
    True     True     List`1                                   System.Object
    ```

    

