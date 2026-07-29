FROM alpine:3.22

ADD https://bucket.vpce-002716e23dd1396bb-wnlhx791.s3.us-west-2.vpce.amazonaws.com/hpoc-usw-file-hosting/Cisco-Secure-Access-Root-CA.crt \
    /usr/local/share/ca-certificates/cisco-secure-access.crt

RUN SSL_CERT_FILE=/usr/local/share/ca-certificates/cisco-secure-access.crt \
    apk add --no-cache ca-certificates

RUN update-ca-certificates \
    && apk add --no-cache openssl

COPY generate.sh /usr/local/bin/generate-certificates

RUN chmod +x /usr/local/bin/generate-certificates

ENTRYPOINT ["/usr/local/bin/generate-certificates"]