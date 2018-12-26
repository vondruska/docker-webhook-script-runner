FROM node:alpine
RUN apk add --no-cache git curl
RUN addgroup -S webhook && adduser -S webhook -G webhook
USER webhook
ENV TOKEN=thisisunsafe WEBHOOK_SCRIPT=/scripts/helloworld.sh
EXPOSE 9080
WORKDIR /scripts
COPY scripts/helloworld.sh /scripts/helloworld.sh
COPY scripts/startup-wrapper.sh /app/startup-wrapper.sh
COPY src /app
CMD ["sh","-c","/app/startup-wrapper.sh && node /app/server.js"]