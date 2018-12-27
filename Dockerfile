FROM node:alpine
RUN apk add --no-cache git curl
ENV TOKEN=thisisunsafe WEBHOOK_SCRIPT=/scripts/helloworld.sh XDG_CONFIG_HOME=/config

# setup XDG_CONFIG_HOME directories and make it able to write from anyone.
# it is up to whatever puts files into this directory to protect them
RUN mkdir -p /config && chmod 777 /config
EXPOSE 9080
WORKDIR /scripts
COPY scripts/helloworld.sh /scripts/helloworld.sh
COPY scripts/startup-wrapper.sh /app/startup-wrapper.sh
RUN chmod +x /scripts/helloworld.sh && chmod +x /app/startup-wrapper.sh
COPY src /app
CMD ["sh","-c","/app/startup-wrapper.sh && node /app/server.js"]
