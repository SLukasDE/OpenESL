#include <openesl/Init.h>
#include <openesl/Plugin.h>

#include <esl/crypto/GTXKeyStore.h>
#include <esl/monitoring/LogbookLogging.h>
#include <esl/plugin/Registry.h>
#include <esl/system/DefaultSignalManager.h>
#include <esl/system/DefaultStacktraceFactory.h>

#include <fstream>

namespace openesl {
inline namespace v1_6 {

Init::Settings::Settings(const std::vector<std::pair<std::string, std::string>>& settings) {
}

Init::Init(const Settings& settings) {
	esl::plugin::Registry& registry = esl::plugin::Registry::get();

	openesl::Plugin::install(registry, nullptr);

	esl::plugin::Registry::get().setObject(esl::crypto::GTXKeyStore::createNative(std::vector<std::pair<std::string, std::string>>()));

	if(settings.stacktraceFactory) {
		esl::plugin::Registry::get().setObject(esl::system::DefaultStacktraceFactory::createNative());
	}

	{
		esl::system::DefaultSignalManager::Settings aSettings;
		aSettings.isThreaded = (settings.signalHandler == Settings::SignalHandler::threaded);
		esl::plugin::Registry::get().setObject(esl::system::DefaultSignalManager::createNative(aSettings));
	}

	if(settings.logging) {
		auto logging = esl::monitoring::LogbookLogging::createNative();

		for(const auto& entry : *settings.logging) {
			if(entry.first == Settings::LoggerMimeType::xmlData) {
				logging->addData(entry.second);
			}
			else if(entry.first == Settings::LoggerMimeType::xmlFile) {
				logging->addFile(entry.second);
			}
		}

		esl::plugin::Registry::get().setObject(std::move(logging));
	}
}

Init::~Init() {
	esl::plugin::Registry::cleanup();
}

std::unique_ptr<Init> Init::create(const std::vector<std::pair<std::string, std::string>>& settings) {
	return std::unique_ptr<Init>(new Init(Settings(settings)));
}

std::unique_ptr<Init> Init::create(const Settings& settings) {
	return std::unique_ptr<Init>(new Init(settings));
}

std::unique_ptr<Init> Init::createSimple() {
	Settings settings;
	settings.stacktraceFactory = true;
	settings.signalHandler = Settings::SignalHandler::threaded;
	settings.logging.reset(new std::vector<std::pair<Settings::LoggerMimeType, std::string>>);
	if(!std::ifstream("logger.xml").fail()) {
		settings.logging->emplace_back(Settings::LoggerMimeType::xmlFile, "logger.xml");
	}
	return std::unique_ptr<Init>(new Init(settings));
}

} /* inline namespace v1_6 */
} /* namespace openesl */
