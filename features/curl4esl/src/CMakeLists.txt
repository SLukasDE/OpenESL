file(GLOB_RECURSE SRC ${CMAKE_CURRENT_SOURCE_DIR}/*.cpp)

# load CURL
find_package_CURL()

if(OPENESL_BUILD_ALL_IN_ONE)
	target_sources(OpenESL PRIVATE ${SRC})

	target_include_directories(OpenESL
		PUBLIC
			$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
			$<INSTALL_INTERFACE:include>
	)

	target_link_libraries(OpenESL
		PUBLIC CURL::libcurl
	)
else()
	add_library(curl4esl ${SRC})
	#add_library(curl4esl STATIC ${SRC})

	target_include_directories(curl4esl
		PUBLIC
			$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
			$<INSTALL_INTERFACE:include>
	)

	install(TARGETS curl4esl
		EXPORT OpenESLTargets
		LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
		ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
		RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
		INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
	)

	target_link_libraries(curl4esl
		PRIVATE esl common4esl
		PUBLIC CURL::libcurl
	)

	#target_link_libraries(curl4esl PUBLIC "z")
	#target_link_libraries(curl4esl PUBLIC "idn2")
	#target_link_libraries(curl4esl PUBLIC "nettle")

	target_link_libraries(OpenESL PUBLIC curl4esl)
endif()

target_compile_definitions(OpenESL PUBLIC HAS_CURL4ESL)

# Install curl4esl headers
install(DIRECTORY ./esl/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/esl
    FILES_MATCHING
    PATTERN "*.h"
    PATTERN "*.hpp"
)
