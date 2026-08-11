FROM ghcr.io/anomalyco/opencode:1.18.9@sha256:f958f81ae08f5f9bf16e2bb3cd6e472b2ce6aa024a741c3e2dec1ed89ea69232

# 1. Build Arguments
ARG REMOTE_USER=nutanix
ARG REMOTE_UID=1000
ARG REMOTE_GID=1000

# Runtime shell and writable direnv approval storage.
ENV SHELL=/bin/bash \
    XDG_DATA_HOME=/tmp/xdg-data

# 2. Configuration & Certificate Setup
RUN install -d -m 0755 /etc/opencode

COPY --chown=root:root --chmod=0444 \
    opencode/opencode.jsonc \
    /etc/opencode/opencode.jsonc

ADD https://bucket.vpce-002716e23dd1396bb-wnlhx791.s3.us-west-2.vpce.amazonaws.com/hpoc-usw-file-hosting/Cisco-Secure-Access-Root-CA.crt \
    /usr/local/share/ca-certificates/cisco-secure-access.crt

COPY certificates/ca.crt \
    /usr/local/share/ca-certificates/nai-mitm-ca.crt

RUN SSL_CERT_FILE=/usr/local/share/ca-certificates/cisco-secure-access.crt \
    apk add --no-cache \
        bash \
        ca-certificates \
        direnv \
    && update-ca-certificates

# 3. User, Home Directories & Bash Configuration
RUN addgroup -g "${REMOTE_GID}" "${REMOTE_USER}" \
    && adduser \
        -u "${REMOTE_UID}" \
        -G "${REMOTE_USER}" \
        -s /bin/bash \
        -D \
        "${REMOTE_USER}" \
    && install -d -o "${REMOTE_USER}" -g "${REMOTE_USER}" -m 0755 \
        "/home/${REMOTE_USER}/.vscode-server" \
        "/home/${REMOTE_USER}/.config" \
        "/home/${REMOTE_USER}/.cache" \
        "/home/${REMOTE_USER}/.local" \
        "/home/${REMOTE_USER}/.npm" \
        "/home/${REMOTE_USER}/.devcontainer" \
        /var/devcontainer \
    && ln -sf /tmp/environment /etc/environment \
    && ln -sf /tmp/.gitconfig "/home/${REMOTE_USER}/.gitconfig"

COPY --chown=${REMOTE_UID}:${REMOTE_GID} --chmod=0444 \
    opencode/bashrc \
    /home/${REMOTE_USER}/.bashrc

RUN install -d -o root -g root -m 0755 /etc/devcontainer
COPY --chown=root:root --chmod=0444 \
    opencode/check-repo-updates.sh \
    /etc/devcontainer/check-repo-updates.sh

# 4. Apply Security & Validation
COPY opencode/apply-security.sh /tmp/apply-security.sh
RUN chmod +x /tmp/apply-security.sh \
    && /tmp/apply-security.sh \
    && rm -f /tmp/apply-security.sh \
    && test "$(getent passwd "${REMOTE_USER}" | cut -d: -f7)" = "/bin/bash" \
    && test "$(getent passwd root | cut -d: -f7)" = "/usr/local/sbin/block-root-login" \
    && ! test -e /usr/bin/sudo \
    && ! test -e /usr/bin/sudoedit \
    && ! test -e /usr/bin/su \
    && ! test -e /bin/su

USER ${REMOTE_USER}