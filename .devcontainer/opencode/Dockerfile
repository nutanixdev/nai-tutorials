FROM ghcr.io/anomalyco/opencode:1.18.9@sha256:f958f81ae08f5f9bf16e2bb3cd6e472b2ce6aa024a741c3e2dec1ed89ea69232

RUN install -d -m 0755 /etc/opencode

COPY --chown=root:root --chmod=0444 \
    opencode/opencode.jsonc \
    /etc/opencode/opencode.jsonc

ADD https://bucket.vpce-002716e23dd1396bb-wnlhx791.s3.us-west-2.vpce.amazonaws.com/hpoc-usw-file-hosting/Cisco-Secure-Access-Root-CA.crt \
    /usr/local/share/ca-certificates/cisco-secure-access.crt

COPY certificates/ca.crt /usr/local/share/ca-certificates/nai-mitm-ca.crt
    
RUN SSL_CERT_FILE=/usr/local/share/ca-certificates/cisco-secure-access.crt \
    apk add --no-cache bash ca-certificates \
    && update-ca-certificates

ARG REMOTE_USER=nutanix

RUN addgroup -g 1000 ${REMOTE_USER} \
    && adduser -u 1000 -G ${REMOTE_USER} -s /bin/sh -D ${REMOTE_USER}

RUN install -d -o 1000 -g 1000 -m 0755 \
    /home/${REMOTE_USER}/.vscode-server \
    /home/${REMOTE_USER}/.config \
    /home/${REMOTE_USER}/.cache \
    /home/${REMOTE_USER}/.local/share \
    /home/${REMOTE_USER}/.local/state \
    /var/devcontainer

COPY opencode/apply-security.sh /tmp/apply-security.sh
RUN chmod +x /tmp/apply-security.sh \
    && /tmp/apply-security.sh \
    && rm /tmp/apply-security.sh \
    && test "$(id -u nutanix)" = "1000" \
    && test "$(id -g nutanix)" = "1000" \
    && test "$(stat -c '%U:%G' /etc/opencode/opencode.jsonc)" = "root:root" \
    && test "$(stat -c '%a' /etc/opencode/opencode.jsonc)" = "444" \
    && test "$(getent passwd root | cut -d: -f7)" = "/usr/local/sbin/block-root-login" \
    && ! test -e /usr/bin/sudo \
    && ! test -e /usr/bin/sudoedit \
    && ! test -e /usr/bin/su \
    && ! test -e /bin/su

USER ${REMOTE_USER}