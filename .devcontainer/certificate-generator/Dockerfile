FROM alpine:3.22

ADD https://bucket.vpce-002716e23dd1396bb-wnlhx791.s3.us-west-2.vpce.amazonaws.com/hpoc-usw-file-hosting/Cisco-Secure-Access-Root-CA.crt \
    /usr/local/share/ca-certificates/cisco-secure-access.crt

# SSL_CERT_FILE replaces the trust store, so the bootstrap bundle must include
# the public roots as well as the Cisco root - otherwise the build fails on any
# network that does not TLS-intercept the Alpine CDN.
RUN cat /etc/ssl/certs/ca-certificates.crt \
        /usr/local/share/ca-certificates/*.crt > /tmp/ca-bootstrap.crt \
    && SSL_CERT_FILE=/tmp/ca-bootstrap.crt apk add --no-cache ca-certificates \
    && rm -f /tmp/ca-bootstrap.crt

RUN update-ca-certificates \
    && apk add --no-cache openssl

COPY generate.sh /usr/local/bin/generate-certificates

RUN chmod +x /usr/local/bin/generate-certificates

ENTRYPOINT ["/usr/local/bin/generate-certificates"]