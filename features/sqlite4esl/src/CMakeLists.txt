file(GLOB_RECURSE SRC ${CMAKE_CURRENT_SOURCE_DIR}/*.cpp)

# load SQLite3
find_package_SQLite3()

if(OPENESL_BUILD_ALL_IN_ONE)
	target_sources(OpenESL PRIVATE ${SRC})

	target_include_directories(OpenESL
		PUBLIC
			$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
			$<INSTALL_INTERFACE:include>
	)

	target_link_libraries(OpenESL
		PUBLIC SQLite::SQLite3
	)
else()
	add_library(sqlite4esl ${SRC})
	#add_library(sqlite4esl STATIC ${SRC})

	target_include_directories(sqlite4esl
		PUBLIC
			$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
			$<INSTALL_INTERFACE:include>
	)

	target_link_libraries(sqlite4esl
		PRIVATE esl
		PUBLIC SQLite::SQLite3
	)

	install(TARGETS sqlite4esl
		EXPORT OpenESLTargets
		LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
		ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
		RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
		INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
	)

	target_link_libraries(OpenESL PUBLIC sqlite4esl)
endif()

target_compile_definitions(OpenESL PUBLIC HAS_SQLITE4ESL)

# Install sqlite4esl headers
install(DIRECTORY ./esl/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/esl
    FILES_MATCHING
    PATTERN "*.h"
    PATTERN "*.hpp"
)
