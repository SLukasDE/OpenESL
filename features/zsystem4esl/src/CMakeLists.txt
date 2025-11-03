file(GLOB_RECURSE SRC ${CMAKE_CURRENT_SOURCE_DIR}/*.cpp)

find_package_zsystem()

if(OPENESL_BUILD_ALL_IN_ONE)
	target_sources(OpenESL PRIVATE ${SRC})

	target_include_directories(OpenESL
		PUBLIC
			$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
			$<INSTALL_INTERFACE:include>
	)

	target_link_libraries(OpenESL
		PUBLIC zsystem::zsystem
	)
else()
	add_library(zsystem4esl ${SRC})

	target_include_directories(zsystem4esl
		PUBLIC
			$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
			$<INSTALL_INTERFACE:include>
	)

	target_link_libraries(zsystem4esl
		PRIVATE esl common4esl
		PUBLIC zsystem::zsystem
	)

	install(TARGETS zsystem4esl
		EXPORT OpenESLTargets
		LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
		ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
		RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
		INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
	)

	target_link_libraries(OpenESL PUBLIC zsystem4esl)
endif()

target_compile_definitions(OpenESL PUBLIC HAS_ZSYSTEM4ESL)

# Install zsystem4esl headers
install(DIRECTORY ./esl/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/esl
    FILES_MATCHING
    PATTERN "*.h"
    PATTERN "*.hpp"
)
