#!/bin/bash

RTSP_URL="${RTSP_URL:-rtsp://}"
TARGET_DIR="${TARGET_DIR:-/media/Videosorveglianza_Cam06}"

mkdir -p "$TARGET_DIR"

echo "Starting recording from $RTSP_URL to $TARGET_DIR..."

while true; do
  TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
  ffmpeg -rtsp_transport tcp -i "$RTSP_URL" -vcodec copy -acodec copy     -t 1800 "$TARGET_DIR/rec_$TIMESTAMP.mp4"
  find "$TARGET_DIR" -name "*.mp4" -mtime +30 -delete
done
