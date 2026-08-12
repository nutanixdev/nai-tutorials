FROM ghcr.io/open-webui/open-webui:main-slim@sha256:f67aea542a85e82cfab8c1de0719487b1566bffbb53c2b5448223611a16889dc

ADD https://bucket.vpce-002716e23dd1396bb-wnlhx791.s3.us-west-2.vpce.amazonaws.com/hpoc-usw-file-hosting/Cisco-Secure-Access-Root-CA.crt \
    /usr/local/share/ca-certificates/cisco-secure-access.crt

COPY certificates/ca.crt /usr/local/share/ca-certificates/nai-mitm-ca.crt

RUN update-ca-certificates

COPY open-webui/functions/show_actual_backend_model.py \
    /opt/nai/functions/show_actual_backend_model.py

COPY open-webui/bootstrap-function.py \
    /opt/nai/bootstrap-function.py

COPY open-webui/start-with-bootstrap.sh \
    /opt/nai/start-with-bootstrap.sh

RUN chmod +x /opt/nai/start-with-bootstrap.sh

ENV PYTHONPATH=/app/backend

CMD ["/opt/nai/start-with-bootstrap.sh"]