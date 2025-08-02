[toc]

## refs

- [关于哈希表 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_hash_tables?view=powershell-7.4)

- 获取内建的参考手册:`help about_hash_tables`

  

## HashTable迭代键和值

- 迭代方法写法有许多,主要分为`keys`迭代和`GetEnumerator()`迭代

- 前者获得值的方式不如后者方便

  - ```powershell
    foreach ($Key in $hash.Keys) {
        "The value of '$Key' is: $($hash[$Key])"
    }
    ```

  - ```powershell
    $hash.Keys | ForEach-Object {
        "The value of '$_' is: $($hash[$_])"
    }
    ```

    

  - ```powershell
    $hash.GetEnumerator() | ForEach-Object {
        "The value of '$_.Key' is: $_.Value"
    }
    ```

  - ```powershell
    $hash.GetEnumerator().ForEach({"The value of '$($_.Key)' is: $($_.Value)"})
    ```

## 排序

- [关于哈希表 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_hash_tables?view=powershell-7.4#sorting-keys-and-values)





