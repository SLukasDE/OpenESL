file(GLOB_RECURSE SRC ${CMAKE_CURRENT_SOURCE_DIR}/*.cpp)

# load Lib Micro-HTTP-Daemon
find_package_libmicrohttpd()

# mhd4esl needs itself GnuTLS for SNI-Lookup
find_package_GnuTLS()

if(OPENESL_BUILD_ALL_IN_ONE)
	target_sources(OpenESL PRIVATE ${SRC})

	target_include_directories(OpenESL
		PUBLIC
			$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
			$<INSTALL_INTERFACE:include>
	)

	target_link_libraries(OpenESL
		PUBLIC libmicrohttpd::libmicrohttpd GnuTLS::GnuTLS
	)
else()
	add_library(mhd4esl ${SRC})
	#add_library(mhd4esl STATIC ${SRC})

	target_include_directories(mhd4esl
		PUBLIC
			$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
			$<INSTALL_INTERFACE:include>
	)

	# this is important to find header files of esl, microhttpd, common4esl and opengtx4esl
	target_link_libraries(mhd4esl
		PRIVATE esl common4esl opengtx4esl
		PUBLIC  libmicrohttpd::libmicrohttpd GnuTLS::GnuTLS
	)

	install(TARGETS mhd4esl
		EXPORT OpenESLTargets
		LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
		ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
		RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
		INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
	)

	target_link_libraries(OpenESL PUBLIC mhd4esl)
endif()

target_compile_definitions(OpenESL PUBLIC HAS_MHD4ESL)

# Install mhd4esl headers
install(DIRECTORY ./esl/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/esl
    FILES_MATCHING
    PATTERN "*.h"
    PATTERN "*.hpp"
)
