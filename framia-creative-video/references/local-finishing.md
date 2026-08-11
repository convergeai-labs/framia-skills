# 本地确定性精修(ffmpeg)

Framia 导出只负责"运动素材 + BGM 原料";**文字、披露、遮罩、节奏统一全部本地做**。原因:生成模型输出文字不可靠(伪字母、抖动),且 Framia 导出可能丢失编辑器文字层。

## 规格基线(社交竖屏)

- 1080×1920,9:16,30fps,H.264 High + AAC 48kHz stereo,`-movflags +faststart`
- 编码建议:`-c:v libx264 -preset medium -crf 17 -pix_fmt yuv420p -c:a aac -b:a 192k`

## Overlay 管线(SVG → 透明 PNG → 时间窗叠加)

1. 每屏文字做一个全尺寸透明底 SVG(persistent 披露条 + 每场一个 scene card);
2. SVG→PNG 推荐 headless Chrome(透明通道可靠):`chrome --headless=new --disable-gpu --hide-scrollbars --screenshot=out.png --window-size=1080,1920 --default-background-color=00000000 file://$PWD/in.svg`;`sips -s format png` 在含文字/透明底时不稳定,仅作兜底;
3. ffmpeg `-loop 1 -t <段时长> -i overlay.png` 输入,`overlay=0:0:enable='between(t,START,END)'` 按时间窗叠加;persistent 层 `shortest=1` 全程。

## 遮不稳定生成文字

画面内生成文字(号码、招牌)会抖动变形。用**不透明 title card**(实底色块+文字)在对应时间段盖在上面——保留底层运动,只遮住缺陷区域。不要为遮文字而冻结或替换画面。

## BGM

- 源短于成片:`-stream_loop -1 -i bgm` + `atrim=duration=N,asetpts=PTS-STARTPTS`;
- 淡入淡出:`afade=t=in:st=0:d=0.35,afade=t=out:st=N-1.2:d=1.2`,可 `volume=0.92` 留余量防爆音;
- 只有视频源里内嵌了想要的 BGM 时,可以从已验收导出里提取音轨复用;
- 用 Framia 音乐节点(如 Suno)生成 BGM 时,本地裁剪+淡入淡出后再上传编辑器(见 editor-assembly「编辑器内挂 BGM」)。

## 横屏素材转竖屏(兜底,非首选)

- 中轴裁切:`crop=607:1080:(iw-607)/2:0,scale=1080:1920` —— 主体居中时可用;
- 模糊填充:背景 `scale=increase,crop=1080:1920,boxblur=36:5`,前景等比缩放置中 overlay —— 保留全画面构图时用;
- 两者都是补救,观感仍弱于原生 9:16;新项目应直接原生竖屏生成。

## 结尾 hero hold

最后一帧定格 ≤0.7s,用 `tpad=stop_mode=clone:stop_duration=1` 类方式延长时注意:不要超过 freezedetect 阈值,审计会判冻结。

## 多段拼接(分段中间件 + concat demuxer)

不要把整条时间线塞进一个 filter_complex 的 concat filter——VFR 素材 + 静态图片段混排会产生坏 PTS,症状是"第一段之后全片冻结"(实测:freezedetect 在段 1 结束处报 freeze_start,后续段全部丢帧)。稳定做法:

1. **每段单独渲染成统一中间件**(同分辨率/帧率/编码参数,如 1080×1920 30fps yuv420p crf 18);
2. `ffmpeg -f concat -safe 0 -i list.txt -c copy joined.mp4` 拼接;
3. **终出时重编码**(不要 `-c:v copy`):concat copy 在段边界留下 non-monotonic DTS,平台转码可能拒收;重编码同时规范化时间戳。

两个实测踩过的坑:

- **`-loop 1` 图片输入不加 `-t` 会让 filtergraph 永不 EOF**:overlay 的副输入无限时,主输入结束后 filter 仍无限重复最后一帧(全片冻结的根因;单段渲染时则表现为输出文件无限膨胀)。所有 `-loop 1 -i png` 都必须带 `-t <段时长>`。
- contact sheet 用 `select='not(mod(n,K))'` 时,DTS 不连续会让 select 的 `n` 在段边界归零,抽帧结果集中在片尾——看到 contact sheet 只有末尾几格时先怀疑时间戳,不要直接判内容缺失。

## 审计(每次交付前必跑)

优先用 `scripts/audit-video.sh VIDEO [OUT_DIR]`,等价手动命令:

```bash
ffprobe -v error -show_entries format=duration,size -show_entries stream=codec_name,width,height,r_frame_rate,sample_rate,channels -of json VIDEO
ffmpeg -i VIDEO -vf blackdetect=d=0.5:pix_th=0.10 -an -f null - 2>&1 | grep blackdetect
ffmpeg -i VIDEO -vf freezedetect=n=-60dB:d=0.5 -an -f null - 2>&1 | grep freeze
ffmpeg -i VIDEO -af silencedetect=n=-45dB:d=0.5 -vn -f null - 2>&1 | grep silence
ffmpeg -i VIDEO -vf "fps=1,scale=270:-1,tile=6x4" -frames:v 1 contact-sheet.png   # 1fps 全片
```

三项检测为 0 + contact sheet 无异常帧 + 常速播放到结尾 + 本地播放器打开,才算通过。
