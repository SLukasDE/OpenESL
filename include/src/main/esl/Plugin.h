#ifndef ESL_PLUGIN_H_
#define ESL_PLUGIN_H_

#include <esl/plugin/Registry.h>

namespace esl {
inline namespace v1_6 {

class Plugin final {
public:
	Plugin() = delete;
	static void install(esl::plugin::Registry& registry, const char* data);
};

} /* inline namespace v1_6 */
} /* namespace esl */

#endif /* ESL_PLUGIN_H_ */
