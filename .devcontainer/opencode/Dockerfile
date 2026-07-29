FROM ghcr.io/anomalyco/opencode:1.18.9@sha256:f958f81ae08f5f9bf16e2bb3cd6e472b2ce6aa024a741c3e2dec1ed89ea69232

COPY certificates/*.crt /usr/local/share/ca-certificates/

RUN SSL_CERT_FILE=/usr/local/share/ca-certificates/cisco-secure-access.crt \
    apk add --no-cache ca-certificates

RUN update-ca-certificates
