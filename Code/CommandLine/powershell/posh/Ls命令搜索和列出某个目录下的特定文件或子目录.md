[toc]



## 搜索符合特定条件的文件或目录

### 例:找出我最近编辑过的Markdown文件

- ```powershell
   $res=ls *md  -Recurse |sort -Property LastWriteTime -Descending|select Name ,Directory,LastAccessTime,LastWriteTime |select -First 10;$res
  ```

- 例如这里我指定了列出当前目录(`C:\repos\blogs`)下及其子目录中距离现在最近的被编辑过的头十个文件