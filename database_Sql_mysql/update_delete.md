## mysql update/delete

- update 和delete远比select 要简单
- 但是update/delete在使用的时候却要十分小心
  - 应该在执行相应update/delete前使用select 来测试以下对应的where条件,看看命中的数据(记录)是否同预期的那样,否则将会造成不可挽回的损失!
-
