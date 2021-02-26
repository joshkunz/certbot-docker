FROM alpine:3.13

RUN apk --no-cache update && \
    apk --no-cache upgrade && \
    apk --no-cache add \
        certbot \
        fish \
        jq \
        tini

COPY crontab /crontabs/root
COPY renew-all /run/
COPY start.fish /run/

VOLUME /certs

ENTRYPOINT ["tini", "--", "/run/start.fish"]
