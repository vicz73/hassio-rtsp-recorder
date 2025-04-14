#!/usr/bin/with-contenv bash

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "Leggo le opzioni da /data/options.yaml"

RTSP_URL=$(jq -r '.rtsp_url' /data/options.json)
OUTPUT_PATH=$(jq -r '.output_path' /data/options.json)
CLIP_DURATION=$(jq -r '.clip_duration' /data/options.json)
RETENTION_DAYS=$(jq -r '.retention_days' /data/options.json)

log "Inizio esecuzione script"
log "RTSP_URL=$RTSP_URL"
log "OUTPUT_PATH=$OUTPUT_PATH"
log "CLIP_DURATION=$CLIP_DURATION"
log "RETENTION_DAYS=$RETENTION_DAYS"

# Controllo variabili
if [[ -z "$RTSP_URL" || -z "$OUTPUT_PATH" ]]; then
  log "❌ Errore: RTSP_URL o OUTPUT_PATH non settati. Uscita."
  exit 1
fi

mkdir -p "$OUTPUT_PATH"

while true; do
  TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
  
  OUTPUT_FILE="$OUTPUT_PATH/$TIMESTAMP.mp4"

  log "🎥 Inizio registrazione: $OUTPUT_FILE"
  
  ffmpeg -rtsp_transport tcp -i "$RTSP_URL" -t "$CLIP_DURATION" -vcodec copy -acodec copy "$OUTPUT_PATH/$TIMESTAMP.mp4"

  
  if [[ $? -ne 0 ]]; then
    log "⚠️ Errore durante la registrazione con ffmpeg"
  else
    log "✅ Registrazione completata: $OUTPUT_FILE"
  fi


  # Rimuove file più vecchi di X giorni
  log "🧹 Pulizia file più vecchi di $RETENTION_DAYS giorni"
  find "$OUTPUT_PATH" -type f -mtime +"$RETENTION_DAYS" -delete
done
