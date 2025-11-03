#include <openesl/Plugin.h>

#if __has_include(<openesl/Config.hpp>)
/* if we build with CMake */
#include <openesl/Config.hpp>
#endif

#include <esl/object/Object.h>
#include <esl/object/ProcessingContext.h>
#include <esl/system/TaskFactory.h>

#if HAS_COMMON4ESL
// std4esl
#include <esl/object/IntValue.h>
#include <esl/object/MapStringStringValue.h>
#include <esl/object/SetIntValue.h>
#include <esl/object/SetStringValue.h>
#include <esl/object/StringValue.h>
#include <esl/object/VectorIntValue.h>
#include <esl/object/VectorPairStringStringValue.h>
#include <esl/object/VectorStringValue.h>

// common4esl
#include <esl/monitoring/MemBufferAppender.h>
#include <esl/monitoring/OStreamAppender.h>
#include <esl/monitoring/SimpleLayout.h>
#include <esl/object/ExceptionHandlerProcedure.h>
#include <esl/object/SimpleContext.h>
#include <esl/object/SimpleProcessingContext.h>
#include <esl/system/DefaultTaskFactory.h>
#endif

#if HAS_CURL4ESL
// curl4esl
#include <esl/com/http/client/CURLConnectionFactory.h>
#endif

// logbook4esl
#if HAS_LOGBOOK4ESL
#include <esl/monitoring/LogbookLogging.h>
#endif

// mhd4esl
#if HAS_MHD4ESL
#include <esl/com/http/server/MHDSocket.h>
#endif

// sqlite4esl
#if HAS_SQLITE4ESL
#include <esl/database/SQLiteConnectionFactory.h>
#endif

// odbc4esl
#if HAS_ODBC4ESL
#include <esl/database/ODBCConnectionFactory.h>
#endif

// zsystem4esl
#if HAS_ZSYSTEM4ESL
#include <esl/system/ZSProcess.h>
#include <esl/system/ZSSignalManager.h>
#include <esl/system/ZSStacktraceFactory.h>
#endif

// opengtx4esl
#if HAS_OPENGTX4ESL
#include <esl/crypto/GTXKeyStore.h>
#endif

#include <esl/object/ProcessingContext.h>

#include <memory>

namespace openesl {
inline namespace v1_6 {

namespace {
template <class InterfaceClass, class ImplementationClass, class Settings>
std::unique_ptr<InterfaceClass> create(const std::vector<std::pair<std::string, std::string>>& settings) {
	return std::unique_ptr<InterfaceClass>(new ImplementationClass(Settings(settings)));
}
}

void Plugin::install(esl::plugin::Registry& registry, const char* data) {
	esl::plugin::Registry::set(registry);

#if HAS_COMMON4ESL
	// std4esl
	registry.addPlugin("esl/object/int", esl::object::IntValue::create);
	registry.addPlugin("esl/object/map<string,string>", esl::object::MapStringStringValue::create);
	registry.addPlugin("esl/object/set<int>", esl::object::SetIntValue::create);
	registry.addPlugin("esl/object/set<string>", esl::object::SetStringValue::create);
	registry.addPlugin("esl/object/string", esl::object::StringValue::create);
	registry.addPlugin("esl/object/vector<int>", esl::object::VectorIntValue::create);
	registry.addPlugin("esl/object/vector<pair<string,string>>", esl::object::VectorPairStringStringValue::create);
	registry.addPlugin("esl/object/vector<string>", esl::object::VectorStringValue::create);


	// common4esl
	registry.addPlugin("esl/monitoring/MemBufferAppender", esl::monitoring::MemBufferAppender::create);
	registry.addPlugin("esl/monitoring/OStreamAppender", esl::monitoring::OStreamAppender::create);
	registry.addPlugin("esl/monitoring/SimpleLayout", esl::monitoring::SimpleLayout::create);
	registry.addPlugin("esl/object/ExceptionHandlerProcedure", esl::object::ExceptionHandlerProcedure::create);
	registry.addPlugin("esl/object/SimpleContext", esl::object::SimpleContext::create);
	registry.addPlugin("esl/object/SimpleProcessingContext", esl::object::SimpleProcessingContext::create);
	registry.addPlugin<esl::object::ProcessingContext, esl::object::ProcessingContext, esl::object::SimpleProcessingContext::create>("esl/object/SimpleProcessingContext");
	registry.addPlugin("esl/system/DefaultTaskFactory", esl::system::DefaultTaskFactory::create);
	registry.addPlugin<esl::object::Object, esl::system::TaskFactory, esl::system::DefaultTaskFactory::create>("esl/system/DefaultTaskFactory");
#endif

	// curl4esl
#if HAS_CURL4ESL
	registry.addPlugin("esl/com/http/client/CURLConnectionFactory", create<esl::com::http::client::ConnectionFactory, esl::com::http::client::CURLConnectionFactory, esl::com::http::client::CURLConnectionFactory::Settings>);
//	registry.addPlugin("esl/com/http/client/CURLConnectionFactory", esl::com::http::client::CURLConnectionFactory::create);
#endif

	// logbook4esl
#if HAS_LOGBOOK4ESL
	registry.addPlugin("esl/monitoring/LogbookLogging", esl::monitoring::LogbookLogging::create);
#endif


	// mhd4esl
#if HAS_MHD4ESL
	registry.addPlugin("esl/com/http/server/MHDSocket", esl::com::http::server::MHDSocket::create);
#endif


	// sqlite4esl
#if HAS_SQLITE4ESL
	registry.addPlugin("esl/database/SQLiteConnectionFactory", esl::database::SQLiteConnectionFactory::create);
#endif


	// odbc4esl
#if HAS_ODBC4ESL
	registry.addPlugin("esl/database/ODBCConnectionFactory", esl::database::ODBCConnectionFactory::create);
#endif


	// zsystem4esl
#if HAS_ZSYSTEM4ESL
	registry.addPlugin("esl/system/ZSProcess", esl::system::ZSProcess::create);
	registry.addPlugin("esl/system/ZSSignalManager", esl::system::ZSSignalManager::create);
	registry.addPlugin("esl/system/ZSStacktraceFactory", esl::system::ZSStacktraceFactory::create);

	registry.setObject(esl::system::ZSStacktraceFactory::createNative());
#endif


	// opengtx4esl
#if HAS_OPENGTX4ESL
	registry.addPlugin("esl/crypto/GTXKeyStore", esl::crypto::GTXKeyStore::create);
#endif
}

} /* inline namespace v1_6 */
} /* namespace openesl */
