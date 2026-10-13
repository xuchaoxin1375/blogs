---
name: prompt-template
description: >
  首轮对话输入模板：复制对应代码块、改话题或开发目标后直接发给 AI。
  技术学习走 tech-learning-research，构建 Web 应用走 arena-ai-code，
  两份完整提示词均通过 GitHub raw 链接引用，无需粘贴全文。
---

[toc]

## 用法

按任务选一节，复制其中代码块全文，替换尖括号占位后直接作为第一次对话输入发给 AI；完整提示词由 AI 按块内 raw 链接自行读取。若 AI 无法访问 raw 链接，改把对应文件全文作为附件发送。

## 技术学习与信息调研

```markdown
请读取并遵守以下提示词全文展开本轮对话：

https://raw.githubusercontent.com/xuchaoxin1375/blogs/refs/heads/main/prompts/tech-learning-research%40prompt.md

本轮话题：<替换为你的话题，例如：sqlite 在 Windows 与 Linux 下的换行与编码差异>
联网搜索深度：a
默认详略等级：1
```

- `联网搜索深度`填 `a`(正常1轮)或 `b`(深度多轮)；`默认详略等级`填 `1`(完整)、`2`(精简)或 `3`(提纲)，不填按默认值执行。

## 构建 Web 应用

```markdown
请读取并遵守以下提示词全文展开本轮对话：

https://raw.githubusercontent.com/xuchaoxin1375/blogs/refs/heads/main/prompts/arena.ai-code%40prompt.md

开发目标：<一句话说明构建什么、给谁用、解决什么问题，例如：为个人记账做的单页工具，支持导入导出 CSV>
```

- 开发目标后可继续填写该提示词“请根据以下信息构建应用”表格中的行（用户与主流程、必须实现、范围边界、数据与能力、参考与风格、运行与适配），不填的非关键项 AI 会取合理默认值并声明假设。
