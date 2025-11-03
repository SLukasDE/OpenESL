file(GLOB_RECURSE SRC ${CMAKE_CURRENT_SOURCE_DIR}/*.cpp)

find_package_logbook()

# load TinyXML2, because of config/Appender.cpp
find_package_TinyXML2()

if(OPENESL_BUILD_ALL_IN_ONE)
	target_sources(OpenESL PRIVATE ${SRC})

	target_include_directories(OpenESL
		PUBLIC
			$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
			$<INSTALL_INTERFACE:include>
	)

	target_link_libraries(OpenESL
		PUBLIC logbook::logbook tinyxml2::tinyxml2
	)
else()
	add_library(logbook4esl ${SRC})
	#add_library(logbook4esl STATIC ${SRC})

	target_include_directories(logbook4esl
		PUBLIC
			$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
			$<INSTALL_INTERFACE:include>
	)

	install(TARGETS logbook4esl
		EXPORT OpenESLTargets
		LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
		ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
		RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
		INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
	)

	target_link_libraries(logbook4esl
		PRIVATE esl common4esl
		PUBLIC logbook::logbook tinyxml2::tinyxml2
	)
	
	target_link_libraries(OpenESL PUBLIC logbook4esl)
endif()

target_compile_definitions(OpenESL PUBLIC HAS_LOGBOOK4ESL)

# Install logbook4esl headers
install(DIRECTORY ./esl/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/esl
    FILES_MATCHING
    PATTERN "*.h"
    PATTERN "*.hpp"
)
