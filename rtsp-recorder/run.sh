#!/usr/bin/with-contenv bash

RTSP_URL=$(jq -r '.rtsp_url' /data/options.json)
OUTPUT_PATH=$(jq -r '.output_path' /data/options.json)
CLIP_DURATION=$(jq -r '.clip_duration' /data/options.json)
RETENTION_DAYS=$(jq -r '.retention_days' /data/options.json)

echo "Using RTSP_URL=$RTSP_URL and OUTPUT_PATH=$OUTPUT_PATH"

mkdir -p "$OUTPUT_PATH"

while true; do
  TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

  ffmpeg -rtsp_transport tcp -i "$RTSP_URL" -t "$CLIP_DURATION" -vcodec copy -acodec copy "$OUTPUT_PATH/$TIMESTAMP.mp4"

  # Rimuove file più vecchi di X giorni
  find "$OUTPUT_PATH" -type f -mtime +"$RETENTION_DAYS" -delete
done
