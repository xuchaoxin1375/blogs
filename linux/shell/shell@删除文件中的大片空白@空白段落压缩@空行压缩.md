[toc]



# shell移除文本文件多余空白行

## powershell方案

```powershell
$content=cat file -raw
$content = $content -replace '[\s\n]*\n', "`n"
```



## 基础方案：压缩多个空行为一个

### 方法1：使用 `cat -s`（最简单）
```bash
cat -s input.txt > output.txt
```

### 方法2：使用 `sed`
```bash
sed '/^$/N;/^\n$/d' input.txt > output.txt
```

### 方法3：使用 `awk`
```bash
awk 'NF || !blank++; !NF{blank=1}' input.txt > output.txt
```

---

## 进阶方案：处理含空白字符的"伪空行"

> 这些行看起来是空的，但包含空格、Tab等

### 推荐：`sed` 一步到位
```bash
sed '/^[[:space:]]*$/{ N; /^[[:space:]]*\n[[:space:]]*$/D }' input.txt > output.txt
```

### 更彻底的方案：先清理再压缩
```bash
# 1. 删除行内的前导/尾随空白 + 2. 压缩空行
sed 's/^[[:space:]]*$//g' input.txt | cat -s > output.txt
```

### 使用 `awk`（最灵活）
```bash
awk '
    /^[[:space:]]*$/ { if (!blank) { print ""; blank=1 } next }
    { blank=0; print }
' input.txt > output.txt
```

---

## 原地修改文件

```bash
# sed 直接修改（GNU sed）
sed -i 's/^[[:space:]]*$//g; /^$/N; /^\n$/d' file.txt

# 或者使用 sponge（需安装 moreutils）
cat -s file.txt | sponge file.txt
```

---

## 效果示例

**处理前：**
```
第一行

   
		
第二行


第三行
```

**处理后：**
```
第一行

第二行

第三行
```

---

## 快速选择

| 需求               | 命令                                       |
| ------------------ | ------------------------------------------ |
| 简单压缩空行       | `cat -s file`                              |
| 处理含空白的伪空行 | `sed 's/^[[:space:]]*$//g' file \| cat -s` |
| 完全删除所有空行   | `grep -v '^[[:space:]]*$' file`            |