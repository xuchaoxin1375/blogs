# powershell_获取相对路径对应的绝对路径

## reference

- [Get Absolute Path from Relative Path in PowerShell - snippset](https://snippset.com/get-absolute-path-from-relative-path-in-powershell-e1605)

```
PS D:\repos\blogs> help path|sort category

Name                              Category  Module                    Synopsis
----                              --------  ------                    --------
Convert-Path                      Cmdlet    Microsoft.PowerShell.Man… Converts a path from a PowerShell path to a PowerShell provider path.
Join-Path                         Cmdlet    Microsoft.PowerShell.Man… Combines a path and a child path into a single path.
Resolve-Path                      Cmdlet    Microsoft.PowerShell.Man… Resolves the wildcard characters in a path, and displays the path contents.
Split-Path                        Cmdlet    Microsoft.PowerShell.Man… Returns the specified part of a path.
Test-Path                         Cmdlet    Microsoft.PowerShell.Man… Determines whether all elements of a path exist.
backupEnvs_regeditPrintPath       Function  functionsByCxxu           …
Get-PromptPath                    Function  posh-git                  …
Get-CMsmqMessageQueuePath         Function  Carbon                    …
```


从上述信息来看,`resolve-path` 似乎会是我们需要的cmdlet

- 通过该命令查看用例 `help Resolve-Path -Examples`
  - 确实是我们想要的
  - ```bash

    NAME
        Resolve-Path
      
    SYNOPSIS
        Resolves the wildcard characters in a path, and displays the path contents.
      
      
        ----------- Example 1: Resolve the home folder path -----------
      
        PS C:\> Resolve-Path ~
      
        Path
        ----
        C:\Users\User01
      
      
        ------ Example 2: Resolve the path of the Windows folder ------
      
        PS C:\> Resolve-Path -Path "windows"
      
        Path
        ----
        C:\Windows
      
        When run from the root of the C: drive, this command returns the path of the Windows folder in the C: drive.
        -------- Example 3: Get all paths in the Windows folder --------
      
        PS C:\> "C:\windows\*" | Resolve-Path
      
        This command returns all of the folders in the C:\Windows folder. The command uses a pipeline operator (|) to send a path string to `Resolve-Path`.
        ---------------- Example 4: Resolve a UNC path ----------------
      
        PS C:\> Resolve-Path -Path "\\Server01\public"
      
        This command resolves a Universal Naming Convention (UNC) path and returns the shares in the path.
        ---------------- Example 5: Get relative paths ----------------
      
        PS C:\> Resolve-Path -Path "c:\prog*" -Relative
      
        .\Program Files
        .\Program Files (x86)
        .\programs.txt
      
        This command returns relative paths for the directories at the root of the C: drive.
        -------- Example 6: Resolve a path containing brackets --------
      
        PS C:\> Resolve-Path -LiteralPath 'test[xml]'
      
      



    ```
