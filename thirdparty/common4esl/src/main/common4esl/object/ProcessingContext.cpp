#include <common4esl/object/ProcessingContext.h>
#include <common4esl/config/context/Context.h>

#include <esl/com/http/server/exception/StatusCode.h>
#include <esl/database/exception/SqlError.h>
#include <esl/Logger.h>
#include <esl/monitoring/Logging.h>
#include <esl/object/Value.h>

#include <exception>
#include <sstream>
#include <stdexcept>

namespace common4esl {
inline namespace v1_6 {
namespace object {

namespace {
esl::Logger logger("common4esl::object::ProcessingContext");
} /* anonymous namespace */

ProcessingContext::IdElement::IdElement(std::unique_ptr<esl::object::Object> aObject)
: object(std::move(aObject)),
  refObject(*object),
  initializeContext(dynamic_cast<esl::object::InitializeContext*>(&refObject))
{ }

ProcessingContext::IdElement::IdElement(esl::object::Object& refObject)
: refObject(refObject),
  initializeContext(nullptr)
{ }

ProcessingContext::ProcessingContext(const esl::object::SimpleProcessingContext::Settings& aSettings)
: settings(aSettings)
{ }

void ProcessingContext::setParentObjectContext(esl::object::Context*) {
}

void ProcessingContext::setParent(Context* parentContext) {
	parent = parentContext;
}

void ProcessingContext::addObject(const std::string& id, std::unique_ptr<esl::object::Object> object) {
	ProcessingContext* context = dynamic_cast<ProcessingContext*>(object.get());

	if(id.empty()) {
		entries.push_back(std::unique_ptr<ProcessingContextEntry>(new ProcessingContextEntry(std::move(object))));
	}
	else if(objects.insert(std::make_pair(id, IdElement(std::move(object)))).second == false) {
        throw std::runtime_error("Cannot add object with id '" + id + "' because there exists already an object with same id.");
	}

	if(context) {
		context->setParent(this);
	}
}

std::unique_ptr<esl::object::Object> ProcessingContext::runCommand(const std::string& command, esl::object::Object* argument) {
	if(command == "load-xml-data") {
		if(!argument) {
			throw std::runtime_error("Arguments missing on calling runCommand(\"" + command + "\", <argument>)");
		}

		{
			esl::object::Value<std::string>* stringPtr = dynamic_cast<esl::object::Value<std::string>*>(argument);
			if(stringPtr) {
				config::context::Context context(false, stringPtr->get());

				context.loadLibraries();
				context.install(*this);

				return nullptr;
			}
		}

		{
			esl::object::Value<std::vector<std::pair<std::string, std::string>>>* settingsPtr = dynamic_cast<esl::object::Value<std::vector<std::pair<std::string, std::string>>>*>(argument);
			if(settingsPtr) {
				std::vector<std::pair<std::string, std::string>>& settings = settingsPtr->get();
				std::string tag;
				std::string data;

				for(const auto& setting : settings) {
					if(setting.first == "data") {
						if(!data.empty()) {
							throw std::runtime_error("Multiple definition of key \"" + setting.first + "\" on calling runCommand(\"" + command + "\", esl::object::VectorPairStringStringValue* settings)");
						}
						data = setting.second;
						if(data.empty()) {
							throw std::runtime_error("Invalid value \"" + setting.second + "\" for key \"" + setting.first + "\" on calling runCommand(\"" + command + "\", esl::object::VectorPairStringStringValue* settings)");
						}
					}
					else if(setting.first == "tag") {
						if(!tag.empty()) {
							throw std::runtime_error("Multiple definition of key \"" + setting.first + "\" on calling runCommand(\"" + command + "\", esl::object::VectorPairStringStringValue* settings)");
						}
						tag = setting.second;
						if(tag.empty()) {
							throw std::runtime_error("Invalid value \"" + setting.second + "\" for key \"" + setting.first + "\" on calling runCommand(\"" + command + "\", esl::object::VectorPairStringStringValue* settings)");
						}
					}
					else {
						throw std::runtime_error("Unknown key \"" + setting.first + "\" on calling runCommand(\"" + command + "\", esl::object::VectorPairStringStringValue* settings)");
					}
				}

				if(data.empty()) {
					throw std::runtime_error("Key \"data\" is missing in settings on calling runCommand(\"" + command + "\", esl::object::VectorPairStringStringValue* settings)");
				}

				config::context::Context context(false, data);

				context.loadLibraries();
				context.install(*this);

				return nullptr;
			}

			throw std::runtime_error("Wrong type of argument on calling runCommand(\"" + command + "\", <argument>). Type of argument should be esl::object::StringValue or esl::object::VectorPairStringStringValue.");
		}
	}
	else if(command == "load-xml-file") {
		if(!argument) {
			throw std::runtime_error("Arguments missing on calling runCommand(\"" + command + "\", <argument>)");
		}

		{
			esl::object::Value<std::string>* stringPtr = dynamic_cast<esl::object::Value<std::string>*>(argument);
			if(stringPtr) {
				config::context::Context context(true, stringPtr->get());

				context.loadLibraries();
				context.install(*this);

				return nullptr;
			}
		}

		{
			esl::object::Value<std::vector<std::pair<std::string, std::string>>>* settingsPtr = dynamic_cast<esl::object::Value<std::vector<std::pair<std::string, std::string>>>*>(argument);
			if(settingsPtr) {
				std::vector<std::pair<std::string, std::string>>& settings = settingsPtr->get();
				std::string tag;
				std::string filename;

				for(const auto& setting : settings) {
					if(setting.first == "filename") {
						if(!filename.empty()) {
							throw std::runtime_error("Multiple definition of key \"" + setting.first + "\" on calling runCommand(\"" + command + "\", esl::object::VectorPairStringStringValue* settings)");
						}
						filename = setting.second;
						if(filename.empty()) {
							throw std::runtime_error("Invalid value \"" + setting.second + "\" for key \"" + setting.first + "\" on calling runCommand(\"" + command + "\", esl::object::VectorPairStringStringValue* settings)");
						}
					}
					else if(setting.first == "tag") {
						if(!tag.empty()) {
							throw std::runtime_error("Multiple definition of key \"" + setting.first + "\" on calling runCommand(\"" + command + "\", esl::object::VectorPairStringStringValue* settings)");
						}
						tag = setting.second;
						if(tag.empty()) {
							throw std::runtime_error("Invalid value \"" + setting.second + "\" for key \"" + setting.first + "\" on calling runCommand(\"" + command + "\", esl::object::VectorPairStringStringValue* settings)");
						}
					}
					else {
						throw std::runtime_error("Unknown key \"" + setting.first + "\" on calling runCommand(\"" + command + "\", esl::object::VectorPairStringStringValue* settings)");
					}
				}

				if(filename.empty()) {
					throw std::runtime_error("Key \"filename\" is missing in settings on calling runCommand(\"" + command + "\", esl::object::VectorPairStringStringValue* settings)");
				}

				config::context::Context context(true, filename);

				context.loadLibraries();
				context.install(*this);

				return nullptr;
			}

			throw std::runtime_error("Wrong type of argument on calling runCommand(\"" + command + "\", <argument>). Type of argument should be esl::object::StringValue or esl::object::VectorPairStringStringValue.");
		}
	}

	throw std::runtime_error("Unknown command on calling runCommand(\"" + command + "\", <argument>)");
}

void ProcessingContext::addAlias(const std::string& destinationId, const std::string& sourceId) {
	esl::object::Object* object = findRawObject(sourceId);

	if(object == nullptr) {
        throw std::runtime_error("Cannot add reference with id '" + destinationId + "' because source object with id '" + sourceId + "' does not exists.");
	}

	if(destinationId.empty()) {
		entries.push_back(std::unique_ptr<ProcessingContextEntry>(new ProcessingContextEntry(*object)));
	}
	else {
		if(objects.count(destinationId) == 0) {
	        throw std::runtime_error("Cannot add reference with id '" + destinationId + "' because there exists already an object with same id.");
		}
		objects.insert(std::make_pair(destinationId, IdElement(*object)));
	}
}

int ProcessingContext::getReturnCode() const {
	return returnCode;
}

std::set<std::string> ProcessingContext::getObjectIds() const {
	std::set<std::string> rv;

	for(const auto& object : objects) {
		rv.insert(object.first);
	}

	return rv;
}

void ProcessingContext::procedureRun(esl::object::Context& context) {
	if(!isInitialized) {
		initializeContext(*this);
	}

	for(auto& entry : entries) {
		if(!exceptionHandler) {
			entry->procedureRun(context);
			continue;
		}

		try {
			entry->procedureRun(context);
		}
		catch(...) {
			esl::object::Object* object = context.findObject<esl::object::Object>("exception");
			esl::object::Value<std::exception_ptr>* exceptionObjectPtr = nullptr;

			if(object) {
				exceptionObjectPtr = dynamic_cast<esl::object::Value<std::exception_ptr>*>(object);
				if(!exceptionObjectPtr) {
					logger.warn << "Object with id \"exception\" is not Value<std::exception_ptr>\n";
				}
			}
			else {
				context.addObject("exception", std::unique_ptr<esl::object::Value<std::exception_ptr>>(new esl::object::Value<std::exception_ptr>(std::current_exception())));
				exceptionObjectPtr = context.findObject<esl::object::Value<std::exception_ptr>>("exception");
			}

			exceptionHandler->procedureRun(context);

			if(exceptionObjectPtr && **exceptionObjectPtr) {
				break;
			}
		}
	}

	/* check if there is a return-code available */
	esl::object::Object* returnCodeObject = context.findObject<esl::object::Object>("return-code");
	if(returnCodeObject) {
		esl::object::Value<int>* returnCodeInt = dynamic_cast<esl::object::Value<int>*>(returnCodeObject);
		if(returnCodeInt) {
			returnCode = **returnCodeInt;
			logger.trace << "Found object \"return-code\" has integer value " << returnCode << "\n";
		}
		else {
			logger.warn << "Object with id \"return-code\" is not Value<int>\n";
		}
	}
}

esl::io::Input ProcessingContext::accept(esl::com::common::server::RequestContext& requestContext) {
	return esl::io::Input();
}

std::set<std::string> ProcessingContext::getNotifiers() const {
	return {};
}

void ProcessingContext::initializeContext(esl::object::Context& context) {
	isInitialized = true;
	if(!settings.exceptionHandlerId.empty()) {
		exceptionHandler = &getObject<esl::object::Procedure>(settings.exceptionHandlerId);
	}

	for(auto& entry : entries) {
		entry->initializeContext(context);
	}
	for(auto& object : objects) {
		if(object.second.initializeContext) {
			object.second.initializeContext->initializeContext(context);
			object.second.initializeContext = nullptr;
		}
	}
}

esl::object::Object* ProcessingContext::findRawObject(const std::string& id) {
	auto iter = objects.find(id);
	esl::object::Object* object = iter == std::end(objects) ? nullptr : &iter->second.refObject;
	if(object) {
		return object;
	}
	if(parent) {
		parent->findObject<esl::object::Object>(id);
	}
	return nullptr;
}

const esl::object::Object* ProcessingContext::findRawObject(const std::string& id) const {
	auto iter = objects.find(id);
	esl::object::Object* object = iter == std::end(objects) ? nullptr : &iter->second.refObject;
	if(object) {
		return object;
	}
	if(parent) {
		parent->findObject<esl::object::Object>(id);
	}
	return nullptr;
}

} /* namespace object */
} /* inline namespace v1_6 */
} /* namespace common4esl */
