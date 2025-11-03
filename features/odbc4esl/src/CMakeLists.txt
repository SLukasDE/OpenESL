file(GLOB_RECURSE SRC ${CMAKE_CURRENT_SOURCE_DIR}/*.cpp)

# load ODBC
find_package_ODBC()

if(OPENESL_BUILD_ALL_IN_ONE)
	target_sources(OpenESL PRIVATE ${SRC})

	target_include_directories(OpenESL
		PUBLIC
			$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
			$<INSTALL_INTERFACE:include>
	)

	target_link_libraries(OpenESL
		PUBLIC ODBC::ODBC
	)
else()
	add_library(odbc4esl ${SRC})
	#add_library(odbc4esl STATIC ${SRC})

	target_include_directories(odbc4esl
		PUBLIC
			$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
			$<INSTALL_INTERFACE:include>
	)

	target_link_libraries(odbc4esl
		PRIVATE esl
		PUBLIC ODBC::ODBC
	)

	install(TARGETS odbc4esl
		EXPORT OpenESLTargets
		LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
		ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
		RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
		INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
	)

	target_link_libraries(OpenESL PUBLIC odbc4esl)
endif()

target_compile_definitions(OpenESL PUBLIC HAS_ODBC4ESL)

# Install odbc4esl headers
install(DIRECTORY ./esl/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/esl
    FILES_MATCHING
    PATTERN "*.h"
    PATTERN "*.hpp"
)
