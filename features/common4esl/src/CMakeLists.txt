file(GLOB_RECURSE SRC ${CMAKE_CURRENT_SOURCE_DIR}/*.cpp)

# load TinyXML2
find_package_TinyXML2()

if(OPENESL_BUILD_ALL_IN_ONE)
	target_sources(OpenESL PRIVATE ${SRC})

	target_include_directories(OpenESL
		PUBLIC
			$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
			$<INSTALL_INTERFACE:include>
	)

	target_link_libraries(OpenESL
		PUBLIC tinyxml2::tinyxml2
	)
else()
	add_library(common4esl ${SRC})
	#add_library(common4esl STATIC ${SRC})

	target_include_directories(common4esl
		PUBLIC
			$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
			$<INSTALL_INTERFACE:include>
	)

	install(TARGETS common4esl
		EXPORT OpenESLTargets
		LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
		ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
		RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
		INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
	)

	# this is important to find header files of esl and TinyXML2
	target_link_libraries(common4esl
		PRIVATE esl
		PUBLIC tinyxml2::tinyxml2
	)

	# Set config-flag and library dependency for OpenESL
	target_link_libraries(OpenESL PUBLIC common4esl)
endif()

target_compile_definitions(OpenESL PUBLIC HAS_COMMON4ESL)

# Install common4esl headers
install(DIRECTORY ./
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    FILES_MATCHING
    PATTERN "*.h"
    PATTERN "*.hpp"
)
