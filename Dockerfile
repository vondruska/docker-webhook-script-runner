FROM vondruska/pistache:latest
WORKDIR /build
COPY server.cc /build
RUN g++ -v -o demo -static server.cc -I/usr/local/include/pistache -lpistache --std=c++11  -lpthread


FROM alpine:latest  
EXPOSE 9080
WORKDIR /root/
COPY --from=0 /build/demo .
ENTRYPOINT ["./demo"]  