FROM alpine:latest
RUN apk add --no-cache ca-certificates curl unzip nginx
RUN mkdir -p /www && echo 'OK' > /www/index.html
RUN curl -L -o /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && unzip /tmp/xray.zip -d /tmp && mv /tmp/xray /usr/local/bin/ai-core && chmod +x /usr/local/bin/ai-core
RUN echo '#!/bin/sh' > /entrypoint.sh && echo 'set -e' >> /entrypoint.sh && echo 'if [ -z "$UUID" ]; then echo "UUID required"; exit 1; fi' >> /entrypoint.sh && echo 'WSPATH=${WSPATH:-/api/v1/chat}' >> /entrypoint.sh && echo 'cat > /etc/xray/config.json << EOF' >> /entrypoint.sh && echo '{"log":{"loglevel":"warning"},"inbounds":[{"port":9000,"listen":"127.0.0.1","protocol":"vless","settings":{"clients":[{"id":"${UUID}"}],"decryption":"none"},"streamSettings":{"network":"ws","wsSettings":{"path":"${WSPATH}"}}}],"outbounds":[{"protocol":"freedom"}]}' >> /entrypoint.sh && echo 'EOF' >> /entrypoint.sh && echo 'ai-core run -config /etc/xray/config.json &' >> /entrypoint.sh && echo 'nginx -g "daemon off;"' >> /entrypoint.sh && chmod +x /entrypoint.sh
EXPOSE 7860
ENTRYPOINT ["/entrypoint.sh"]
