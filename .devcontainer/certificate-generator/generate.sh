#!/bin/sh
set -eu

CERT_DIR=/certificates

CA_CERT="${CERT_DIR}/ca.crt"
CA_KEY="${CERT_DIR}/ca.key"
SERVER_CERT="${CERT_DIR}/api.anthropic.com.crt"
SERVER_KEY="${CERT_DIR}/api.anthropic.com.key"

mkdir -p "${CERT_DIR}"

if [ -s "${CA_CERT}" ] &&
   [ -s "${CA_KEY}" ] &&
   [ -s "${SERVER_CERT}" ] &&
   [ -s "${SERVER_KEY}" ]; then
    echo "MITM certificates already exist."
    exit 0
fi

echo "Generating local development CA and server certificate..."

rm -f \
  "${CERT_DIR}/ca.crt" \
  "${CERT_DIR}/ca.key" \
  "${CERT_DIR}/ca.srl" \
  "${CERT_DIR}/api.anthropic.com.crt" \
  "${CERT_DIR}/api.anthropic.com.key"

openssl req \
  -x509 \
  -newkey rsa:2048 \
  -sha256 \
  -nodes \
  -days 365 \
  -keyout "${CA_KEY}" \
  -out "${CA_CERT}" \
  -subj "/CN=NAI Devcontainer MITM CA" \
  -addext "basicConstraints=critical,CA:TRUE" \
  -addext "keyUsage=critical,keyCertSign,cRLSign"

cat >/tmp/server.ext <<'EOF'
subjectAltName=DNS:api.anthropic.com
basicConstraints=critical,CA:FALSE
keyUsage=critical,digitalSignature,keyEncipherment
extendedKeyUsage=serverAuth
EOF

openssl req \
  -new \
  -newkey rsa:2048 \
  -nodes \
  -keyout "${SERVER_KEY}" \
  -out /tmp/api.anthropic.com.csr \
  -subj "/CN=api.anthropic.com"

openssl x509 \
  -req \
  -sha256 \
  -days 365 \
  -in /tmp/api.anthropic.com.csr \
  -CA "${CA_CERT}" \
  -CAkey "${CA_KEY}" \
  -CAcreateserial \
  -out "${SERVER_CERT}" \
  -extfile /tmp/server.ext

chmod 600 "${CA_KEY}" "${SERVER_KEY}"
chmod 644 "${CA_CERT}" "${SERVER_CERT}"

echo "Certificates generated in ${CERT_DIR}."