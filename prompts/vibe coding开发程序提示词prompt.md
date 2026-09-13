

## api 中转站排行榜参考

可以找多个榜单都有的中转站,降低评价偏差

- [AI API中转站收录与评测](https://hvoy.ai/APIreview.html)
- [API中转平台测评_中转站测试工具_模型真伪检测【LLM大模型照妖镜】](https://llmtest.cn/leaderboard)
- [AI中转站评测排名 · API中转站自费亲测·无中转赞助合作 | Help AIO](https://www.helpaio.com/transit)

### 试用中的中转站

- https://www.cctq.ai/
- https://api.api2cn.com/

## ai agent脚本编写

> 以python为例,让agent编写一个规范且可维护的脚本

> 防假死:为了避免agent工作过程中卡死但用户不能及时发现的问题,请尽可能展示处理过程或日志,让我知道agent在工作.

请编写或改造一个 Python 命令行脚本，要求如下：

1. 功能要求
   - 明确列出支持的运行模式。
   - 对破坏性操作提供 --dry-run。
   - 对批量操作提供进度输出和汇总统计。
   - 支持非交互式参数，避免只能人工输入。

2. 命令行设计
   - 使用 argparse。
   - 重要参数同时提供短选项和长选项。
   - 提供 --help 和 --version。
   - 参数冲突要提前校验并给出清晰错误。

3. 配置与安全
   - 支持配置文件。
   - 支持命令行覆盖配置。
   - 不要硬编码密钥。
   - 日志和输出中必须脱敏 token/key/password。

4. 并发与中断
   - 如使用多线程，必须支持 Ctrl+C 安全停止。
   - 使用 stop_event 协作退出。
   - pending futures 需要取消。
   - HTTP 请求必须设置 timeout。

5. 外部 API
   - 查询并遵循 API 限流规则。
   - 支持主动限流。
   - 支持 429 / Retry-After / 5xx 重试。
   - 并发和限流策略应可配置。

6. 日志与审计
   - 引入 logging。
   - 提供 --log-file、--log-level。
   - 默认不写日志或默认追加。
   - 日志应包含时间、级别、线程名、关键操作。
   - 敏感信息必须脱敏。

7. 代码质量
   - 使用类型注解。
   - 使用 dataclass 表达结构化结果。
   - 函数职责清晰，避免超大函数。
   - 语言工具:
     - 考虑使用适当的语言服务器(language server),例如使用对应语言的lsp辅助代码分析.
     - 使用代码检查工具检查代码. 例如,对于python,运行 ruff/pyright/py_compile 这类工具检查代码问题。
   - 根据检查反馈修复问题。

8. 文档
   - 提供 ReadMe.md。
   - 包含安装、配置、参数表、示例、风险说明。
   - 对复杂流程提供 Mermaid 图。
   - 说明设计取舍和维护注意事项。

请最终给出：

- 修改后的代码文件
- README
- 检查命令和检查结果
- 关键设计说明