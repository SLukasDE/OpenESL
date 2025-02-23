#include <HTTPServer.h>
#include <Logger.h>

#include <openesl/Plugin.h>

#include <esl/com/http/client/CURLConnectionFactory.h>
#include <esl/com/http/client/exception/NetworkError.h>
#include <esl/database/exception/SqlError.h>
#include <esl/monitoring/LogbookLogging.h>
#include <esl/object/SimpleContext.h>
#include <esl/plugin/exception/PluginNotFound.h>
#include <esl/plugin/Registry.h>
#include <esl/system/Stacktrace.h>

#include <fstream>
#include <iostream>
#include <stdexcept>

namespace {
Logger logger("main");
}

int main(int argc, const char* argv[]) {
    struct RegistryGuard {
        ~RegistryGuard() {
            esl::plugin::Registry::cleanup();
        }
    } registryGuard;

    int rc = -1;

    try {
		esl::plugin::Registry& registry(esl::plugin::Registry::get());
        openesl::Plugin::install(registry, nullptr);

		auto logging = esl::monitoring::LogbookLogging::createNative();
        std::ifstream f("logger.xml");
        if(f.good())
        {
            logging->addFile("logger.xml");
        }
        f.close();
		registry.setObject(std::move(logging));

		logger.info << "Test\n";

        HTTPServer httpServer;
        httpServer.run();
        rc = 0;
    }
    catch(const esl::com::http::client::exception::NetworkError& e) {
        std::cerr << "HTTP client exception occurred: " << e.what() << "\n";
        std::cerr << "- Error code: " << e.getErrorCode() << "\n";
        if(const auto* s = esl::system::Stacktrace::get(e)) {
            s->dump(std::cerr);
        }
    }
    catch(const esl::database::exception::SqlError& e) {
        std::cerr << "SQL error exception occurred: " << e.what() << "\n";
        std::cerr << "- SQL return code: " << e.getSqlReturnCode() << "\n";
        e.getDiagnostics().dump(std::cerr);
        if(const auto* s = esl::system::Stacktrace::get(e)) {
            s->dump(std::cerr);
        }
    }
    catch(const esl::plugin::exception::PluginNotFound& e) {
        std::cerr << "Plugin not found exception occurred: " << e.what() << "\n";
        const esl::plugin::Registry::BasePlugins& basePlugins = esl::plugin::Registry::get().getPlugins(e.getTypeIndex());
        if(basePlugins.empty()) {
            std::cerr << "No implementations available.\n";
        }
        else {
            std::cerr << "Implementations available:\n";
            for(const auto& basePlugin : basePlugins) {
                std::cerr << "- " << basePlugin.first << "\n";
            }
        }
    }
    catch(const std::runtime_error& e) {
        std::cerr << "Exception of type 'std::runtime_error' occurred: " << e.what() << "\n";
        if(const auto* s = esl::system::Stacktrace::get(e)) {
            s->dump(std::cerr);
        }
    }
    catch(const std::exception& e) {
        std::cerr << "Exception of type 'std::exception' occurred: " << e.what() << "\n";
        if(const auto* s = esl::system::Stacktrace::get(e)) {
            s->dump(std::cerr);
        }
    }
    catch(...) {
        std::cerr << "Unknown exception occurred.\n";
    }

    return rc;
}
