# framia-skills

让 AI Agent(Claude Code / Codex 等)帮你在 [Framia](https://framia.pro) 上完成创意视频创作的 Agent Skill 集合。

每个 Skill 都是一套经过真实项目验证的工作流:storyboard 先行、浏览器自动化操作 Framia 画布与编辑器、本地 ffmpeg 确定性精修、独立审计门禁——把"让 Agent 做视频"从碰运气变成可复现的管线。

## Skills

| Skill | 状态 | 说明 |
|---|---|---|
| [`framia-creative-video`](framia-creative-video/) | ✅ 已发布 | 从 brief 到出片:storyboard → 画布生成(模型路由)→ 编辑器排片导出 → 本地精修 → 审计门禁 |
| [`framia-video-project-ops`](framia-video-project-ops/) | ✅ 已发布 | 已有 Framia 项目的审计、修复与优化:双证据车道、验收矩阵、调试模式、有界优化轮次 |

仓库会持续增加新的 Framia 相关 Skill,每个 Skill 一个顶层目录,自带 `SKILL.md` 与所需 references/scripts。

## 安装

```bash
# Claude Code(二选一或都装)
cp -r framia-creative-video ~/.claude/skills/
cp -r framia-video-project-ops ~/.claude/skills/

# Codex
cp -r framia-creative-video ~/.codex/skills/
cp -r framia-video-project-ops ~/.codex/skills/
```

然后在对话中直接说"用 Framia 做一条创意短视频"即可触发。

## 前置条件

- 一个 Framia 账号(免费套餐可生成,下载/导出需要付费套餐——Skill 内有详细说明);
- 本机安装 `ffmpeg` / `ffprobe`;
- 浏览器自动化能力(Claude Code 的 Playwright MCP,或 Codex 等价工具),用于操作 Framia 网页端;
- 可选:headless Chrome(用于把 SVG 文字卡渲染成透明 PNG)。

## 示例

用这些 Skill 创作的真实案例见姊妹仓库:[convergeai-labs/framia-examples](https://github.com/convergeai-labs/framia-examples)。

## License

[MIT](LICENSE)
