FROM node:alpine
RUN apk add --no-cache git curl && \
    addgroup -S webhook && adduser -S webhook -G webhook
ENV TOKEN=thisisunsafe WEBHOOK_SCRIPT=/scripts/helloworld.sh
EXPOSE 9080
WORKDIR /scripts
COPY scripts/helloworld.sh /scripts/helloworld.sh
COPY scripts/startup-wrapper.sh /app/startup-wrapper.sh
RUN chmod +x /scripts/helloworld.sh && chmod +x /app/startup-wrapper.sh
USER webhook
COPY src /app
CMD ["sh","-c","/app/startup-wrapper.sh && node /app/server.js"]
