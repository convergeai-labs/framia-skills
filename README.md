# framia-skills

**中文** | [English](README_EN.md)

![banner](assets/readme-banner.png)

<p>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-0ea5b7" alt="MIT"></a>
  <a href="https://framia.pro"><img src="https://img.shields.io/badge/built%20for-Framia-e0218a" alt="Framia"></a>
  <img src="https://img.shields.io/badge/skills-2-f5c518" alt="2 skills">
</p>

**让 AI Agent 帮你在 [Framia](https://framia.pro) 上做视频——从一句话到成片，每一步都可复现。**

不是"帮你写个 prompt"级别的玩具:这是一套经过真实项目十余轮迭代验证的**完整制片管线**——storyboard 门禁、模型路由、浏览器自动化画布操作、ffmpeg 确定性精修、独立审计。Agent 按它执行，你只做决策和复核。

![pipeline](assets/readme-pipeline.png)

## 这套 Skill 帮你避开什么

- 🔥 **"Agent 说做完了"≠ 做完了** —— 编辑器 AI 会幻觉排片(声称放好 5 条实际是同一片段×5);Skill 强制以导出物 + ffprobe + contact sheet 为唯一验收
- 💸 **无目标烧 credit** —— storyboard 不经批准不生成;探针先行、重试熔断、预算护栏全部内置
- 🎭 **平台结论过期** —— 套餐门禁和模型目录一周内就能翻面(Kling 3.0 从 Free 转 Basic+ 实测);Skill 教你每次开工先探针
- 🎬 **空镜 MV 没人看** —— "静音播放能否看懂"判据 + 故事承载卖点方法论,来自公开宣发案例拆解
- 🔤 **生成文字必翻车** —— 全部文字走本地 SVG→透明 PNG→时间窗 overlay 确定性管线

## Skills

| Skill | 说明 |
|---|---|
| [`framia-creative-video`](framia-creative-video/) | **从 brief 到出片**:storyboard → 画布生成(模型路由/失败分类学)→ 编辑器排片导出 → 本地精修 → 审计门禁 |
| [`framia-video-project-ops`](framia-video-project-ops/) | **已有项目的审计与修复**:双证据车道、效果验收矩阵、调试模式(空时间线/导出 404/渲染超时)、有界优化轮次 |

每个 Skill 一个顶层目录,自带 `SKILL.md` + references + scripts。更多 Framia Skill 持续增加中。

## 60 秒上手

```bash
git clone https://github.com/convergeai-labs/framia-skills.git
cd framia-skills

# Claude Code
cp -r framia-creative-video framia-video-project-ops ~/.claude/skills/

# Codex
cp -r framia-creative-video framia-video-project-ops ~/.codex/skills/
```

然后直接说:**「用 Framia 给我做一条创意短视频」**——Agent 会先给你 storyboard,你批准后才动 credit。

## 前置条件

- Framia 账号(Free 套餐即可生成与节点下载,部分模型需 Basic+——Skill 内有实时探针方法);
- 本机 `ffmpeg` / `ffprobe`;
- 浏览器自动化(Claude Code 的 Playwright MCP 或 Codex 等价物);
- 可选:headless Chrome(SVG 字幕卡渲染)。

## 效果证明

用这套 Skill 真实产出的视频(成片 + storyboard + prompt + 踩坑记录全公开):

👉 **[convergeai-labs/framia-examples](https://github.com/convergeai-labs/framia-examples)** — 含 Free 套餐零付费出片的完整案例。

## License

[MIT](LICENSE)
