[toc]

# vscode@typora正则文本替换@处理

- vscode replace content partically

## refs

- [Case changing in regex replace#](https://code.visualstudio.com/docs/editor/codebasics#_case-changing-in-regex-replace)
- [Search - Typora Support](https://support.typora.io/Search/)

## 正则替换

- `ctrl+H`

###  案例1@分组替换

- 实验文本

```
* abc 12_3_4_ To_uPPer
```

- 实验正则式

  - `(\d_)(\d_)\s(\w+)`(匹配被处理文本)

  - `$2$1 \u\L$3`(指示如何操做被匹配了的文本(此处将第一次和第二组组交换,第三组的首字母大写,其余小写))

  ![image-20220404150444655](https://img-blog.csdnimg.cn/img_convert/417385419996ca98d42b1560dcbd4f6b.png)

###  案例2

- 假设谋篇markdown文章中出现了一些问题,内容如下
- 试验文本:(假设文笔文件中有多段类似的结构)
```
**函数应用**
**![图片](http://mmbiz.qpic.cn/mmbiz/nFzVLSBz3eNjYb0z0ibhOAicxv0icUUVXrxfR1V2KLxDnExp91iamT2ImefZzqOSltWMvhFB8MB4vOdT7z6wbZf6kA/640?wxfrom=5&wx_lazy=1&wx_co=1)**
```
- 目标:替换为(markdown形式)
```
## 函数应用
![图片](http://mmbiz.qpic.cn/mmbiz/nFzVLSBz3eNjYb0z0ibhOAicxv0icUUVXrxfR1V2KLxDnExp91iamT2ImefZzqOSltWMvhFB8MB4vOdT7z6wbZf6kA/640?wxfrom=5&wx_lazy=1&wx_co=1)
```
- solution:
	- match:`(\*\*)([^!].*)(\*\*)`
	- replacement:`## $2`
	- match2:`(\*\*)(!.*)(\*\*)`
	- replacement2:`$2`
	- 经过两轮替换,基本可以达到目的了
### 案例3

- 只保留每行的`【xxx】`部分

  ```txt
  莆仙戏【刘邦惭内侄】全剧高清清晰…024942
  莆仙戏【牧郎情怨】全剧高清清晰480P.mp4
  莆仙戏【千岁审万岁】国美剧团高清…02:38:48
  莆仙戏【三穿状元袍】一团演出高清清晰480…
  莆仙戏【三夫人审子】全剧高清清晰480P.mp4
  莆仙戏【三媳妇】嘉庆剧团高清清晰480P.mp4
  .莆仙戏【天娇风云】高清清晰480P.mp4
  莆仙戏【天下第一案】越群剧团高清清晰480…
  .莆仙戏【同心锁】芳华剧团高清清晰480P.mp4
  0.莆仙戏【万花归唐】全剧高清清晰480P.mp4
  1.莆仙戏【光宋风云】2020-6明建剧团湄洲剧院…
  2.莆仙戏【甄妃传】水仙花剧团高清清晰480P…
  3.莆仙戏2021-1【御宴风波】TV版芳华剧团高清。…
  4.莆仙戏2021-8【孝从何来】TV版~明哲剧团高…
  16.莆仙戏【状元乞雨】文平剧团高清流畅360P…
  17.莆仙戏【公主又嫁】特声大剧团高清清晰480,
  18.莆仙山戏【激战蒙云关】芳华剧团高清清晰480…
  19.莆仙戏【金殿认母】高清清晰480P.mp4
  ```

#### solution

- find:`(.*)(【.*】)(.*)`
- replace:`$2`

#### result

- ```
  【刘邦惭内侄】
  【牧郎情怨】
  【千岁审万岁】
  【三穿状元袍】
  【三夫人审子】
  【三媳妇】
  【天娇风云】
  【天下第一案】
  【同心锁】
  【万花归唐】
  【光宋风云】
  【甄妃传】
  【御宴风波】
  【孝从何来】
  【状元乞雨】
  【公主又嫁】
  【激战蒙云关】
  【金殿认母】
  ```

### 案例4

- 去掉每行的中括号

- ```text
  【刘邦惭内侄】
  【牧郎情怨】
  【千岁审万岁】
  【三穿状元袍】
  【三夫人审子】
  ```

#### solution

- find:`【(.*)】`
- replace:`$1`

#### result

- ```text
  刘邦惭内侄
  牧郎情怨
  千岁审万岁
  三穿状元袍
  三夫人审子
  ```


### 转义`$`

- 分组替换中如果要插入`$`,可以用`$$`来表示一个`$`

## 局部替换

### 方式1

- 键入`ctrl+h`

- 键入要被替换的内容(模式串)

- 选中要被替换处理的文本区域

- 打开`find in selection`功能开关(默认快捷键为`alt+l`)

  - (只有在上述操作中选中了某一部分区域后)才可以有效的打开该开关

  - 如果此前已经将开关置于开启状态,则需要将开关切换为关有在开启才是有效的


- 执行替换



### 方式2

- 选中需要替换的文本
- 键入`ctrl+H`(默认的替换按钮)
- 确保`find in selection `功能开启(默认快捷键为`alt+l`)
- 键入要被替换的内容(模式串)
  - $\ce{O2+\ce{}}$

- 键入用于替换旧内容的新串

## vscode 目录检索_模糊匹配工作空间的目录

- `ctrl+p`启动`go to file`
- 匹配目录的时候在目录名后面追加`/`来表示目录名

- ![](https://img-blog.csdnimg.cn/img_convert/8e3b3dbc8fc99c389c8bcf8ab6c0a56c.png)

## 相似变量名统一

- 想要把代码中的x_array和x_arrays等统一替换为x_arrays:
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210620173409966.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

the solution regex:

- `x_array(\b|\w)`
- 或者更通用的分组替换

## 辅助的powershell 函数

### powrshell搜索带有关键字的目录

```powershell
function searchDirectories
{
    <#     
    .synopsis
    从当前目录开始递归查找具有指定名称的目录
    .Example 
    searchDirectories 'css' 
    searchDirectories -dirFrom_optional ./dir1/  -pattern css 
     #>
    param(
        $pattern,
        $dirFrom_optional = './',
        $isWildcard_optional = 'y',
        $maxDepth=3
    )
    printWorkingDir $dirFrom_optional
    write "max-depth=$maxDepth;if you want to search deeper directory,please modify the maxDepth as you want(0 will be equivalent 10)"
    # $wildPattern="*$pattern*"
    # Write-Output 'searching...'
    if ($isWildcard_optional -eq 'y')
    {
        $pattern = "*$pattern*"

    }
    if($maxDepth -eq 0){
        $maxDepth=10
    }
    Get-ChildItem -Path $Dir -Directory -Recurse -Filter $pattern -followSymlink  -Depth $maxDepth| Select-Object name, FullName 

  
}
```

