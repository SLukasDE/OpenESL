#include <HTTPRequestHandler.h>
#include <Logger.h>

namespace {
Logger logger("HTTPRequestHandler");
}

HTTPRequestHandler::HTTPRequestHandler() {
}

esl::io::Input HTTPRequestHandler::accept(esl::com::http::server::RequestContext&) const {
	logger.info << "accept\n";
	return esl::io::Input();
}

