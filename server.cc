#include "pistache/endpoint.h"
#include <stdlib.h>

using namespace Pistache;

class HelloHandler : public Http::Handler {
public:

    HTTP_PROTOTYPE(HelloHandler)

    void onRequest(const Http::Request& request, Http::ResponseWriter response) {
        if (request.resource() == "/ping") {
            response.send(Pistache::Http::Code::Ok, "pong\n");
            return;
        }

        else if(request.resource() == std::string("/") + getenv("TOKEN")) {
            response.send(Pistache::Http::Code::Ok, "winner!\n");
            return;
        }
        response.send(Pistache::Http::Code::Forbidden, "You are not worthy.\n");
    }
};

int main() {
    Pistache::Address addr(Pistache::Ipv4::any(), Pistache::Port(9080));
    auto opts = Pistache::Http::Endpoint::options()
        .threads(1);

    Http::Endpoint server(addr);
    server.init(opts);
    server.setHandler(Http::make_handler<HelloHandler>());
    server.serve();

    server.shutdown();
}