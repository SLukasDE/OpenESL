#ifndef HTTPREQUESTHANDLER_H_
#define HTTPREQUESTHANDLER_H_

#include <esl/com/http/server/RequestHandler.h>
#include <esl/com/http/server/RequestContext.h>
#include <esl/io/Input.h>
#include <esl/object/Object.h>

class HTTPRequestHandler : public esl::com::http::server::RequestHandler {
public:
	HTTPRequestHandler();

	esl::io::Input accept(esl::com::http::server::RequestContext&) const override;
};

#endif /* HTTPREQUESTHANDLER_H_ */
