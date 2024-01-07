#ifndef OPENESL_INIT_H_
#define OPENESL_INIT_H_

#include <memory>
#include <string>
#include <utility>
#include <vector>

namespace openesl {
inline namespace v1_6 {

class Init {
public:
	struct Settings {
		Settings() = default;
		Settings(const std::vector<std::pair<std::string, std::string>>& settings);

		bool stacktraceFactory = true;

		enum LoggerMimeType {
			xmlData, xmlFile, jsonData, jsonFile
		};
		std::unique_ptr<std::vector<std::pair<LoggerMimeType, std::string>>> logging;

		enum SignalHandler {
			none, nonthreaded, threaded
		};
		SignalHandler signalHandler = SignalHandler::threaded;
	};

	static std::unique_ptr<Init> create(const std::vector<std::pair<std::string, std::string>>& settings);
	static std::unique_ptr<Init> create(const Settings& settings);
	static std::unique_ptr<Init> createSimple();

	virtual ~Init();

private:
	Init(const Settings& settings);
};

} /* inline namespace v1_6 */
} /* namespace openesl */

#endif /* OPENESL_INIT_H_ */
