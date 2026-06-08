[toc]





以下面的配置代码片段(放在`com_com.conf`文件中)为例:

```bash
# com_com.conf
# 引入cf可信ip配置(普通服务器建议定期自动调用更新脚本更新,特殊解析服务器不要使用)
## 适用于cloudflare cdn解析.
include /www/server/nginx/conf/cf-realip.conf;

## 仅当特殊解析服务器才使用下面的方式:
# include real_cdn_ip.conf;

```

变成:(注释掉第1个include,并且启用第2个include语句)

```nginx
# com_com.conf
# 引入cf可信ip配置(普通服务器建议定期自动调用更新脚本更新,特殊解析服务器不要使用)
## 适用于cloudflare cdn解析.
# include /www/server/nginx/conf/cf-realip.conf;

## 仅当特殊解析服务器才使用下面的方式:
include real_cdn_ip.conf;
```

解决方案:(多种写法),直接原地修改

```bash
# 逐行处理
sed -i '\|include /www/.*/cf-realip.conf;| s/^/# /' com_com.conf
sed -i -E 's|#[[:space:]]*(include real_cdn_ip.conf;)|\1|' com_com.conf

# 合并处理(换行符分隔不同的sed语句行,使用-E启用扩展正则,省去反斜杠转义括号组'()'):
sed -i -E '
  \|include /www/.*/cf-realip.conf;| s/^/# /
  s|#[[:space:]]*(include real_cdn_ip\.conf;)|\1|
' com_com.conf

```

## 注释时对齐(移除多余空格)

将下面的`r.conf`注释,并尽可能左对齐:

```
map_hash_bucket_size 128;
 map_hash_max_size 65536;
```

```bash
sed -i -E 's|^[[:space:]]*(map_hash_bucket_size.*)|# \1|' r.conf
sed -i -E 's|^[[:space:]]*(map_hash_max_size.*)|# \1| ' r.conf

```

