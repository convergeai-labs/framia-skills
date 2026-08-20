# framia-skills

[中文](README.md) | **English**

![banner](assets/readme-banner.png)

<p>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-0ea5b7" alt="MIT"></a>
  <a href="https://framia.pro"><img src="https://img.shields.io/badge/built%20for-Framia-e0218a" alt="Framia"></a>
  <img src="https://img.shields.io/badge/skills-2-f5c518" alt="2 skills">
</p>

**Let AI agents make videos for you on [Framia](https://framia.pro) — from one sentence to final cut, every step reproducible.**

This is not a "write me a prompt" toy. It's a **complete production pipeline** battle-tested over a dozen iterations on real projects: storyboard gates, model routing, browser-automated canvas operation, deterministic ffmpeg finishing, and independent audits. The agent executes; you make decisions and review.

![pipeline](assets/readme-pipeline.png)

## What these skills save you from

- 🔥 **"The agent said it's done" ≠ done** — the editor AI hallucinates assembly (claims 5 clips placed; actually the same clip ×5). The skills enforce export + ffprobe + contact sheet as the only acceptance.
- 💸 **Burning credits without a target** — no generation before storyboard approval; probe-first, retry breakers, and budget guardrails built in.
- 🎭 **Stale platform assumptions** — plan gates and the model catalog can flip within a week (Kling 3.0 moved from Free to Basic+ mid-project, observed). The skills teach probe-first on every session.
- 🎬 **Beautiful-but-empty montage** — the "can a stranger understand it on mute" test plus a story-carries-the-selling-point methodology, distilled from public promo teardowns.
- 🔤 **Generated text always breaks** — all text goes through a deterministic local SVG → transparent PNG → time-windowed overlay pipeline.

## Skills

| Skill | Description |
|---|---|
| [`framia-creative-video`](framia-creative-video/) | **Brief to final cut**: storyboard → canvas generation (model routing / failure taxonomy) → editor assembly & export → local finishing → audit gates |
| [`framia-video-project-ops`](framia-video-project-ops/) | **Audit & repair existing projects**: two evidence lanes, effect acceptance matrix, debugging patterns (empty timeline / export 404 / render timeout), bounded optimization rounds |

Each skill lives in its own top-level directory with `SKILL.md` + references + scripts. More Framia skills are coming.

## Up and running in 60 seconds

```bash
git clone https://github.com/convergeai-labs/framia-skills.git
cd framia-skills

# Claude Code
cp -r framia-creative-video framia-video-project-ops ~/.claude/skills/

# Codex
cp -r framia-creative-video framia-video-project-ops ~/.codex/skills/
```

Then just say: **"Make me a creative short video with Framia"** — the agent will show you a storyboard first, and won't touch credits until you approve.

## Prerequisites

- A Framia account (Free tier can generate and download node outputs; some models require Basic+ — live probe method included);
- `ffmpeg` / `ffprobe` locally;
- Browser automation (Playwright MCP for Claude Code, or the Codex equivalent);
- Optional: headless Chrome (for SVG caption card rendering).

## Proof it works

Real videos produced with these skills — final cuts, storyboards, prompts, and pitfall logs all public:

👉 **[convergeai-labs/framia-examples](https://github.com/convergeai-labs/framia-examples)** — including a complete case produced at zero cost on the Free plan.

## License

[MIT](LICENSE)
