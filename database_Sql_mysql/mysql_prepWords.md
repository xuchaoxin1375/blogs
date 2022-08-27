## 命令和分句

- command
- clause
- where 引导 条件从句(分句)

## mysql 中的常用介词

- for
- by
- on
  - grant... on...
- to
  - grant(授权)...on ...to...;
  - rename table... to...;
- from
  - select... from...
  - revoke(撤权)... from...
- into
  - insert

## 副词

- where
  - select ... from...where
  - update... set...where
  - delete from... where
- inner
  - 连接 inner join

## 名词

- value

## 动词组

- update set
- set
- show
- grant
- revoke
- drop
  - drop table
  - drop user

## 修改&更新

> 执行表的修改前,应当备份表!

- 表的结构的修改(字段)()
  - 可以是删除字段(add)(需要指定列名以及对应的数据类型)
  - 可以是增加字段(drop column)
- 表内记录的更新

## 删除

- 删除表
- 删除表中的若干条记录
- 在删除一条记录的时候,由于不需要指定替换数据,所以可以比更新表更加简短一些.
