FROM alpine:latest

RUN apk add --no-cache ca-certificates curl unzip nginx su-exec

RUN adduser -D -u 1001 xray && \
    mkdir -p /www /etc/xray /var/log/nginx /tmp/nginx && \
    chown -R xray:xray /www /etc/xray /var/log/nginx /tmp/nginx

RUN mkdir /tmp/xray && \
    curl -L -o /tmp/xray/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip /tmp/xray/xray.zip -d /tmp/xray && \
    mv /tmp/xray/xray /usr/local/bin/ai-core && \
    chmod +x /usr/local/bin/ai-core && \
    rm -rf /tmp/xray

RUN echo '<h1>AI Chatbot Service</h1>' > /www/index.html

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER xray
EXPOSE 7860
ENTRYPOINT ["/entrypoint.sh"]
