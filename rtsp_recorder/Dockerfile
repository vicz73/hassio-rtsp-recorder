FROM alpine:latest

RUN apk add --no-cache ffmpeg bash findutils

COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
