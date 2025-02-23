#ifndef HTTPSERVER_H_
#define HTTPSERVER_H_

#include <esl/com/http/server/Socket.h>

#include <memory>

class HTTPServer {
public:
	HTTPServer();

	void run();

private:
	std::unique_ptr<esl::com::http::server::Socket> socket;
};

#endif /* HTTPSERVER_H_ */
