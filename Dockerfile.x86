FROM alpine

RUN apk --no-cache add bash git

COPY sync.sh /sync.sh

ENTRYPOINT ["bash", "/sync.sh"]
