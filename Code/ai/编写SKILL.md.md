[toc]



## SKILL.md 简单示例

### 最简单的示例

```
---  
name: hello_world  
description: A simple skill that says hello.  
---  
  
# Hello World Skill  
  
When the user asks for a greeting, use the `echo` tool to say  
"Hello from your custom skill!".
```



### 带基本元数据的示例

```
---  
name: image-lab  
description: Generate or edit images via a provider-backed image workflow  
metadata:  
  {  
    "openclaw":  
      {  
        "requires": { "bins": ["uv"], "env": ["GEMINI_API_KEY"], "config": ["browser.enabled"] },  
        "primaryEnv": "GEMINI_API_KEY",  
      },  
  }  
---
```



## SKILL.md 模板结构

### 必需字段

| 字段          | 类型   | 说明                                                      |
| ------------- | ------ | --------------------------------------------------------- |
| `name`        | string | 技能的唯一标识符（使用 snake_case） creating-skills.md:90 |
| `description` | string | 向 AI 展示的单行描述，用于触发技能 creating-skills.md:91  |

### 常用可选字段

| 字段                                | 说明               | 示例                                        |
| ----------------------------------- | ------------------ | ------------------------------------------- |
| `metadata.openclaw.requires.bins`   | 需要的二进制文件   | `["git", "node"]` creating-skills.md:93     |
| `metadata.openclaw.requires.env`    | 需要的环境变量     | `["API_KEY"]`                               |
| `metadata.openclaw.requires.config` | 需要的配置项       | `["browser.enabled"]` creating-skills.md:94 |
| `metadata.openclaw.os`              | OS 限制            | `["darwin", "linux"]` creating-skills.md:92 |
| `user-invocable`                    | 是否可作为用户命令 | `true`（默认） skills.md:97                 |

### 完整技能目录结构

```
skill-name/  
├── SKILL.md (必需)  
└── 可选资源/  
    ├── scripts/          # 可执行脚本  
    ├── references/       # 参考文档  
    └── assets/           # 资源文件  
```



## 创建技能的步骤

1. **创建目录**

   ```
   mkdir -p ~/.openclaw/workspace/skills/your-skill
   ```



1. **编写 SKILL.md** - 使用上面的模板

2. **加载技能** - 重启会话或网关

   ```
   openclaw gateway restart
   ```



1. **验证加载**

   ```
   openclaw skills list
   ```



## Notes

- SKILL.md 使用 YAML frontmatter 和 Markdown 正文
- metadata 必须是单行 JSON 对象 skills.md:93
- 在指令中可使用 `{baseDir}` 引用技能目录路径 skills.md:94
- 技能加载优先级：工作区 > 托管/本地 > 内置 skills.md:21-23

Wiki pages you might want to explore:

- [Getting Started (openclaw/openclaw)](https://deepwiki.com/openclaw/openclaw/1.1-getting-started)
- [Skills System (openclaw/openclaw)](https://deepwiki.com/openclaw/openclaw/5.2-skills-system)