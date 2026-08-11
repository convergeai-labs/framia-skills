# Framia 编辑器排片与导出(VideoEditor 节点实战)

> 核心教训:**编辑器 AI 对话会幻觉排片,手动排片才是可靠路径;导出后必须 ffprobe 验证分辨率,比例会静默重置。**

## 编辑器 AI 对话不可信(最重要)

编辑器内 AI 对话声称"已按顺序放入 5 条素材",甚至能产出带 5 个不同 resource ID 的"自查表"——但时间线实际仍是同一片段重复 5 次。**两次导出字节级相同**(同尺寸同 hash)是铁证。

教训:

- AI 说"已放置/已修复"≠ 时间线真的变了;它的"自查表"也可以是编的。
- AI 的排片操作可能**异步落地**(延迟几十秒才出现在时间线),期间手动操作会与之交错——先等它落完,或彻底手动。
- 唯一可信验证:**导出 → ffprobe + contact sheet 目检**。快照里 `video-tracks` 区域的片段列表也可信(以片段标题/资源 ID 为准)。

## 手动排片(可靠,推荐)

1. **素材进库**:素材 tab → 「上传」→「从本地上传」→ file chooser。**一次传一个文件最稳**:多文件批量上传曾导致整个浏览器崩溃重启(内存会话全丢,需重新恢复登录态)。隐藏 `input[type=file]` 直接 JS click 的方式不可靠(文件不落库)。
2. **加入时间线**:首个上传的素材会自动进时间线;之后的上传只进素材库,需**左键单击素材库条目 = 追加到时间线末尾**。按目标顺序依次单击即完成排序(拖拽不生效,右键无菜单)。
3. **删除片段**:单击时间线片段选中 → 按 `Delete` 键。逐条删,删完确认 `video-tracks` 为空。
4. **轨道检查**:编辑器会给上传自动配一条 BGM 轨(每次上传都可能新增)。来源不明的 BGM 轨整条**静音**(轨道头静音按钮,确认按钮变「取消静音」)。

## 比例会静默重置(不只在清空时间线时)

清空/重建时间线后项目画幅会静默回退 16:9;**上传素材/排片过程中也会静默回退**(项目创建时是 9:16,导出对话框打开时头部按钮已变 16:9)。对策只有一条:

- **每次点「导出」前,瞄一眼头部比例按钮,不对就先改回来再导出**;
- 每次导出后 `ffprobe` 验证 width×height 是 1080×1920,不是凭导出对话框的"1080p"字样想当然。

## 导出对话框行为

- 帧率 30fps / MP4 默认保持;**文件名不跨导出保留,每次重填**;画质默认 720p,要 1080p 需手动选(listbox option,不是 `<select>`);隐藏水印开关状态不保留时每次确认。
- **「发布到社媒」按钮绝不替用户点**——发布一律人工,自动化只到导出+下载。

## 字幕/文字能力边界

字幕 tab **只有语音自动字幕,没有自由文本 overlay**。字卡、角标、数据卡的选择:

- 烘进导出成片:Framia 编辑器导出 → 本地按场景时间窗 overlay(**推荐**);
- 烘进素材:本地把 overlay 烧进片段再上传(所见即所得,但每镜要重传);
- 或靠发布平台文案/评论区承担全部文字信息。

**本地烘字管线(本机 ffmpeg 无 drawtext/libfreetype 时)**:全屏 1080×1920 透明 SVG(每场景一张,含常驻披露角标)→ headless Chrome 渲染透明 PNG:`chrome --headless=new --disable-gpu --hide-scrollbars --screenshot=ov.png --window-size=1080,1920 --default-background-color=00000000 file://$PWD/ov.svg`(验证 hasAlpha)→ ffmpeg 一次成型:`[0:v][1:v]overlay=0:0:enable='between(t,0,4.8)'[v1];[v1][2:v]overlay=...` 链式叠加,`-c:a copy`。SVG 文字宽度估算:latin ~0.55em + CJK 1em,rect 留 padding,否则右缘溢出裁字。

## 编辑器内挂 BGM(实战)

1. **BGM 先在本地裁好长度+淡入淡出**(ffmpeg `afade`),编辑器内裁音频不可靠;长度对齐成片(如 26s 配 25.1s 片)。
2. 素材库**单击音频素材 = 追加到既有 BGM 轨末尾**(接在旧片段后面,不是 0 点)。正确做法:先把 BGM 轨上的旧片段逐条选中 Delete 清空,再单击素材——空轨追加即落 0 点。用 `getBoundingClientRect()` 对比 BGM 片段与首视频片段的 x 坐标验证对齐。
3. 轨道头按钮显示「取消静音」= 当前静音,必须点击使 BGM 可闻;视频轨自带环境音可保留(与 BGM 混音)。
4. BGM 比视频轨长会把导出撑长(尾部黑帧+BGM 尾音):导出后本地 `-t <视频轨时长>` 裁回,再 ffprobe + blackdetect 复验。
5. 音乐节点(如 Suno)在画布对话里直接起(prompt 写明"无人声、无歌词、风格、时长"),节点工具栏「下载音频」直接得 mp3;**音乐生成单价显著高于短视频镜头**,生成前先确认余额。

## 真实画面嵌入生成镜头(换屏)

需求:镜头保持生成风格,但画面中手机屏幕显示真实录屏(如游戏实录)。

1. **生成绿幕镜头**(Kling 3.0 实测可靠):prompt 关键要素——`hand holds a smartphone steady in vertical orientation, screen facing the camera straight on, screen displays a solid bright pure green color filling the entire screen, phone stays almost still, camera locked on tripod, no text/logos`。
2. **先采样实际绿色再 key**:生成的"纯绿"实测可能偏色(如 0x73DF5F,不是 0x00FF00)。用 `ffmpeg -ss T -i clip -vf "crop=4:4:X:Y" -f rawvideo -pix_fmt rgb24 - | xxd` 取屏幕中心色。
3. **colorkey 参数宁紧勿松**:`colorkey=0x73DF5F:0.16:0.02` 实测干净;similarity 太大会把绿色溢色的手指一并抠掉,blend 太大会留鬼影。
4. **对齐方法**:实录(横屏)按屏幕纵横比 crop → scale 到全屏 → 作为底层,绿幕片 key 后 overlay 在上。屏幕区域自动跟随移动中的手机,无需逐帧追踪。
5. 合成命令骨架:
   ```
   ffmpeg -i phone-green.mp4 -i gameplay.mp4 -filter_complex "
   [1:v]crop=414:900:593:0,scale=1080:1920,setsar=1,fps=30[game];
   [0:v]colorkey=0x73DF5F:0.16:0.02,format=yuva420p,scale=1080:1920,setsar=1,fps=30[keyed];
   [game][keyed]overlay=0:0,format=yuv420p[v]" -map "[v]" -c:v libx264 -crf 18 -t 5 -an out.mp4
   ```
6. 合成片**无音轨**(-an)——导出后 silencedetect 会报该段无声,属预期,由 BGM 或站内音源覆盖;不算审计失败,但要在交付说明里写明。
