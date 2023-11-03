

## 命令行对象

- ```cmd
  PS D:\repos\scripts> gcm code|fl
  
  Name            : code.cmd
  CommandType     : Application
  Definition      : C:\Program Files\Microsoft VS Code\bin\code.cmd
  Extension       : .cmd
  Path            : C:\Program Files\Microsoft VS Code\bin\code.cmd
  FileVersionInfo : File:             C:\Program Files\Microsoft VS Code\bin\code.cmd
                    InternalName:
                    OriginalFilename:
                    FileVersion:
                    FileDescription:
                    Product:
                    ProductVersion:
                    Debug:            False
                    Patched:          False
                    PreRelease:       False
                    PrivateBuild:     False
                    SpecialBuild:     False
                    Language:
  
  ```

  - 注意是安装目录下的`bin`目录下的`code.cmd`,而不是上一层的`code.exe`
  - 只有前者是可以接收命令行参数的!