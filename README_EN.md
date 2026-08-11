# framia-skills

[中文](README.md) | **English**

![banner](assets/readme-banner.png)

A collection of agent skills that let AI agents (Claude Code, Codex, etc.) create videos for you on [Framia](https://framia.pro).

Each skill is a workflow validated on real projects: storyboard-first design, browser-automated operation of the Framia canvas and editor, deterministic local ffmpeg finishing, and independent audit gates — turning "let an agent make a video" from a gamble into a reproducible pipeline.

## Skills

| Skill | Status | Description |
|---|---|---|
| [`framia-creative-video`](framia-creative-video/) | ✅ Released | From brief to final cut: storyboard → canvas generation (model routing) → editor assembly & export → local finishing → audit gates |
| [`framia-video-project-ops`](framia-video-project-ops/) | ✅ Released | Audit, repair and optimize existing Framia projects: two evidence lanes, acceptance matrix, debugging patterns, bounded optimization rounds |

More Framia skills will be added over time. Each skill lives in its own top-level directory with its `SKILL.md` and required references/scripts.

## Install

```bash
# Claude Code (install either or both)
cp -r framia-creative-video ~/.claude/skills/
cp -r framia-video-project-ops ~/.claude/skills/

# Codex
cp -r framia-creative-video ~/.codex/skills/
cp -r framia-video-project-ops ~/.codex/skills/
```

Then just say "make a creative short video with Framia" in your conversation to trigger the skill.

## Prerequisites

- A Framia account (the Free tier can generate; downloading/exporting requires a paid plan — details inside the skills);
- `ffmpeg` / `ffprobe` installed locally;
- Browser automation (Playwright MCP for Claude Code, or the Codex equivalent) to operate the Framia web app;
- Optional: headless Chrome (for rasterizing SVG title cards into transparent PNGs).

## Examples

Real works created with these skills live in the companion repository: [convergeai-labs/framia-examples](https://github.com/convergeai-labs/framia-examples).

## License

[MIT](LICENSE)
