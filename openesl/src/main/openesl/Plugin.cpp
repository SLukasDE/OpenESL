#include <openesl/Plugin.h>

#include <esl/plugin/Registry.h>
#include <esl/object/Object.h>
#include <esl/object/ProcessingContext.h>
#include <esl/system/TaskFactory.h>

// std4eslx
#include <esl/object/IntValue.h>
#include <esl/object/MapStringStringValue.h>
#include <esl/object/SetIntValue.h>
#include <esl/object/SetStringValue.h>
#include <esl/object/StringValue.h>
#include <esl/object/VectorIntValue.h>
#include <esl/object/VectorPairStringStringValue.h>
#include <esl/object/VectorStringValue.h>

// common4eslx
#include <esl/monitoring/MemBufferAppender.h>
#include <esl/monitoring/OStreamAppender.h>
#include <esl/monitoring/SimpleLayout.h>
#include <esl/object/ExceptionHandlerProcedure.h>
#include <esl/object/SimpleContext.h>
#include <esl/object/SimpleProcessingContext.h>
#include <esl/system/DefaultTaskFactory.h>

// curl4eslx
#include <esl/com/http/client/CURLConnectionFactory.h>

// logbook4eslx
#include <esl/monitoring/LogbookLogging.h>

// mhd4eslx
#include <esl/com/http/server/MHDSocket.h>

// rdkafka4eslx
#include <esl/com/basic/client/KafkaConnectionFactory.h>
#include <esl/com/basic/server/KafkaSocket.h>
#include <esl/object/KafkaClient.h>

// sqlite4eslx
#include <esl/database/SQLiteConnectionFactory.h>

// unixODBC4eslx
#include <esl/database/ODBCConnectionFactory.h>

// zsystem4eslx
#include <esl/system/DefaultProcess.h>
#include <esl/system/DefaultSignalManager.h>
#include <esl/system/DefaultStacktraceFactory.h>


#include <esa/object/ProcessingContext.h>

#include <memory>

namespace openesl {
inline namespace v1_6 {

void Plugin::install(esl::plugin::Registry& registry, const char* data) {
	esl::plugin::Registry::set(registry);

	// std4eslx
	registry.addPlugin("esl/object/int", esl::object::IntValue::create);
	registry.addPlugin("esl/object/map<string,string>", esl::object::MapStringStringValue::create);
	registry.addPlugin("esl/object/set<int>", esl::object::SetIntValue::create);
	registry.addPlugin("esl/object/set<string>", esl::object::SetStringValue::create);
	registry.addPlugin("esl/object/string", esl::object::StringValue::create);
	registry.addPlugin("esl/object/vector<int>", esl::object::VectorIntValue::create);
	registry.addPlugin("esl/object/vector<pair<string,string>>", esl::object::VectorPairStringStringValue::create);
	registry.addPlugin("esl/object/vector<string>", esl::object::VectorStringValue::create);

	//boostst4esl::Plugin::install(registry, data);


	// common4esl
	registry.addPlugin("esl/monitoring/MemBufferAppender", esl::monitoring::MemBufferAppender::create);
	registry.addPlugin("esl/monitoring/OStreamAppender", esl::monitoring::OStreamAppender::create);
	registry.addPlugin("esl/monitoring/SimpleLayout", esl::monitoring::SimpleLayout::create);
	registry.addPlugin("esl/object/ExceptionHandlerProcedure", esl::object::ExceptionHandlerProcedure::create);
	registry.addPlugin("esl/object/SimpleContext", esl::object::SimpleContext::create);
	registry.addPlugin("esl/object/SimpleProcessingContext", esl::object::SimpleProcessingContext::create);
	registry.addPlugin<esa::object::ProcessingContext, esl::object::ProcessingContext, esl::object::SimpleProcessingContext::create>("esl/object/SimpleProcessingContext");
	registry.addPlugin("esl/system/DefaultTaskFactory", esl::system::DefaultTaskFactory::create);
	registry.addPlugin<esl::object::Object, esl::system::TaskFactory, esl::system::DefaultTaskFactory::create>("esl/system/DefaultTaskFactory");


	// curl4esl
	registry.addPlugin("esl/com/http/client/CURLConnectionFactory", esl::com::http::client::CURLConnectionFactory::create);


	// logbook4esl
	registry.addPlugin("esl/monitoring/LogbookLogging", esl::monitoring::LogbookLogging::create);


	// mhd4esl
	registry.addPlugin("esl/com/http/server/MHDSocket", esl::com::http::server::MHDSocket::create);


	// rdkafka4esl
	registry.addPlugin("esl/com/basic/client/KafkaConnectionFactory", esl::com::basic::client::KafkaConnectionFactory::create);
	registry.addPlugin("esl/com/basic/server/KafkaSocket", esl::com::basic::server::KafkaSocket::create);
	registry.addPlugin("esl/object/KafkaClient", esl::object::KafkaClient::create);


	// sqlite4esl
	registry.addPlugin("esl/database/SQLiteConnectionFactory", esl::database::SQLiteConnectionFactory::create);

	// unixODBC4esl
	registry.addPlugin("esl/database/ODBCConnectionFactory", esl::database::ODBCConnectionFactory::create);

	// zsystem4esl
	registry.addPlugin("esl/system/DefaultProcess", esl::system::DefaultProcess::create);
	registry.addPlugin("esl/system/DefaultSignalManager", esl::system::DefaultSignalManager::create);
	registry.addPlugin("esl/system/DefaultStacktraceFactory", esl::system::DefaultStacktraceFactory::create);
}

} /* inline namespace v1_6 */
} /* namespace openesl */
