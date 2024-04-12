[toc]

## refs

- [How to Get the Current Location of the PowerShell Script | Delft Stack](https://www.delftstack.com/howto/powershell/get-the-current-location-of-the-powershell-script/#:~:text=A simple remedy to fix the issue is,when testing in the PowerShell ISE. Split-Path %24psISE.CurrentFile.FullPath)

## 方法小结

- ```powershell
  
  #方法1
  # $path_relative = Split-Path -Parent $($global:MyInvocation.MyCommand.Definition)
  #方法2
  #$path_relative = $PSScriptRoot
  
  #解析绝对路径
  Resolve-Path $path_relative
  
  ```

- 编写为函数

  - ```powershell 
    function get_script_root_abs
    {
        Resolve-Path $PSScriptRoot
    }
    ```

    