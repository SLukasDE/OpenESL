#include <HTTPRequestHandler.h>
#include <HTTPServer.h>
#include <Logger.h>

#include <esl/com/http/server/MHDSocket.h>

#include <chrono>
#include <string>
#include <utility>
#include <vector>

namespace {
Logger logger("HTTPServer");
}

HTTPServer::HTTPServer()
: socket(esl::com::http::server::MHDSocket::create({
	{"https", "false"},
	{"port", "8080"}
  }))
{
	logger.info << "HTTP-Server\n";
}

void HTTPServer::run() {
	HTTPRequestHandler httpRequestHandler;
	socket->listen(httpRequestHandler, nullptr);
	std::this_thread::sleep_for(std::chrono::seconds(10));
}

