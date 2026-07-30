FROM ghcr.io/open-webui/open-webui:main-slim

ADD https://bucket.vpce-002716e23dd1396bb-wnlhx791.s3.us-west-2.vpce.amazonaws.com/hpoc-usw-file-hosting/Cisco-Secure-Access-Root-CA.crt \
    /usr/local/share/ca-certificates/cisco-secure-access.crt

COPY certificates/ca.crt /usr/local/share/ca-certificates/nai-mitm-ca.crt

RUN update-ca-certificates
