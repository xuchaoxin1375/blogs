[toc]



## help help

### help -category ` <values>` 

> `help -category` 后 `table键`可以提示参数(psReadline/keyhandler)(相关功能打开的话)

- 譬如:`help -category helpFile`
  - 该命令返回一系列 `powershell 语法以及powershell规范的帮助信息`
    - ```
      PS C:\Users\cxxu> h -Category HelpFile
      
      Name                              Category  Module                    Synopsis
      ----                              --------  ------                    --------
      default                           HelpFile                            SHORT DESCRIPTION
      about_Aliases                     HelpFile
      about_Alias_Provider              HelpFile
      about_Arithmetic_Operators        HelpFile
      about_Arrays                      HelpFile
      about_Assignment_Operators        HelpFile
      about_Automatic_Variables         HelpFile
      about_Booleans                    HelpFile
      about_Break                       HelpFile
      about_Calculated_Properties       HelpFile
      about_Certificate_Provider        HelpFile
      ...
      ```

>
> -Category <System.String[]>
>         Displays help only for items in the specified category and their aliases. Conceptual articles are in the HelpFile category.
>
>     ! The acceptable values for this parameter(Category) are as follows:
>
>     - Alias
>    
>     - Cmdlet
>    
>     - Provider
>    
>     - General
>    
>     - FAQ
>    
>     - Glossary
>    
>     - HelpFile
>    
>     - ScriptCommand
>    
>     - Function
>    
>     - Filter
>    
>     - ExternalScript
>    
>     - All
>    
>     - DefaultHelp
>    
>     - Workflow
>    
>     - DscResource
>    
>     - Class
>    
>     - Configuration
