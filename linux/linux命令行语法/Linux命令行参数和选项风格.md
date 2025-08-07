[toc]



#### 命令行的参数和选项参数

- 不妨将命令行工具(比如`sed`)中的参数分为两类
  - 命令行本身的参数(不妨称为一级参数,记为`non-option parameter`或`command parameter`)
  - 命令行选项的参数,(不妨称为二级参数`option parameter`或`command option parameter`)
  
  



### options🎈

- 上述文档中的选项有两种

  - 短选项`-...`
  - 长选项`--...`
  - **同一行**的短选项和长选项效果是一样的,短选项是长选项的简写形式,可能有多个短选项和长选项,它们效果一样
    - 例如`-s --separate`是一样的
  - 长选项和段选项各有好处
    - 简写的短选项比较适合熟练的用户,可以达到提高脚本编写效率和编码简洁的效果
    - 长选项则比较适合初学者,别写出来的脚本虽然比较长,但是可读性更好,更容易理解脚本的含义
  - 但是有的选项是没有简写形式,则相应的缺失短选项,只提供长选项,
    - 例如`--vesion`,没有相应的短选项

- 对于没有参数(形参)的选项,我们可以理解为<u>bool型选项,表示功能开关</u>

  - 例如`-s --separate`

- 有的选项是带有参数的,使用这类选项,需要进一步指定参数,告诉选项作用的对象是谁

  - 例如

    - ```bash
      -e script, --expression=script
                      add the script to the commands to be executed
       -f script-file, --file=script-file
                      add the contents of script-file to the commands to be executed
      ```

    - `-e`,`-f`都要求传入参数

    - 并且,对于长选项,还要求使用`=`号来指定的取值,例如:`--expression=script`

    - 短选项指定参数通常是用空格,但是有时候也不用空格,直接将选项的参数(实参)紧跟在选项后面

      - 例如:` -i[SUFFIX], --in-place[=SUFFIX]`

      - 又例如7zip的选项

        - ```bash
          -o{Directory} : set Output directory
           -p{Password} : set Password
          ```

- 参数可选(具有默认行为)的选项

  - 例如

    - ```bash
      -i[SUFFIX], --in-place[=SUFFIX]
                      edit files in place (makes backup if SUFFIX supplied)
      ```

    - 选项的参数使用中括号`[]`包裹,说明是可选的

- 同类型参数重复

  - `[input-file]...`
  - 中括号表明**参数**`input-file`是可选的
  - 同时,后面的`...`表示这个类型的参数可以指定多个
  - 综合来看,就是允许你指定0或者多个文件作为输入数据源