#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Usage: $0 VIDEO [OUT_DIR]" >&2
  exit 2
fi

video_path=$1
if [[ ! -f "$video_path" ]]; then
  echo "Video not found: $video_path" >&2
  exit 2
fi

for required_cmd in ffmpeg ffprobe; do
  if ! command -v "$required_cmd" >/dev/null 2>&1; then
    echo "Missing required command: $required_cmd" >&2
    exit 3
  fi
done

if [[ $# -eq 2 ]]; then
  audit_out_dir=$2
  mkdir -p "$audit_out_dir"
else
  audit_out_dir=$(mktemp -d "${TMPDIR:-/tmp}/framia-video-audit.XXXXXX")
fi

probe_path="$audit_out_dir/ffprobe.json"
contact_sheet_path="$audit_out_dir/contact-sheet.png"
black_log_path="$audit_out_dir/blackdetect.log"
freeze_log_path="$audit_out_dir/freezedetect.log"
silence_log_path="$audit_out_dir/silencedetect.log"
summary_path="$audit_out_dir/summary.txt"

ffprobe -v error -show_format -show_streams -of json "$video_path" >"$probe_path"

duration=$(
  ffprobe -v error -show_entries format=duration \
    -of default=noprint_wrappers=1:nokey=1 "$video_path"
)
video_streams=$(
  ffprobe -v error -select_streams v -show_entries stream=index \
    -of csv=p=0 "$video_path" | wc -l | tr -d ' '
)
audio_streams=$(
  ffprobe -v error -select_streams a -show_entries stream=index \
    -of csv=p=0 "$video_path" | wc -l | tr -d ' '
)

ffmpeg -hide_banner -loglevel error -y -i "$video_path" \
  -vf "fps=1/3,scale=480:-2,tile=4x2" -frames:v 1 "$contact_sheet_path"

ffmpeg -hide_banner -nostats -i "$video_path" \
  -vf "blackdetect=d=0.5:pix_th=0.10" -an -f null - \
  > /dev/null 2>"$black_log_path" || true

ffmpeg -hide_banner -nostats -i "$video_path" \
  -vf "freezedetect=n=-50dB:d=2" -an -f null - \
  > /dev/null 2>"$freeze_log_path" || true

if [[ "$audio_streams" -gt 0 ]]; then
  ffmpeg -hide_banner -nostats -i "$video_path" \
    -af "silencedetect=n=-45dB:d=1.5" -vn -f null - \
    > /dev/null 2>"$silence_log_path" || true
else
  printf '%s\n' "No audio stream." >"$silence_log_path"
fi

{
  printf 'video=%s\n' "$video_path"
  printf 'duration_seconds=%s\n' "$duration"
  printf 'video_streams=%s\n' "$video_streams"
  printf 'audio_streams=%s\n' "$audio_streams"
  printf 'probe=%s\n' "$probe_path"
  printf 'contact_sheet=%s\n' "$contact_sheet_path"
  printf 'blackdetect=%s\n' "$black_log_path"
  printf 'freezedetect=%s\n' "$freeze_log_path"
  printf 'silencedetect=%s\n' "$silence_log_path"
} >"$summary_path"

cat "$summary_path"
