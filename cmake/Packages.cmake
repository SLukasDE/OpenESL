include(FetchContent)

#find_package_logbook()
#find_package_zsystem()
#find_package_GnuTLS()
#find_package_CURL()
#find_package_libmicrohttpd()
#find_package_SQLite3()
#find_package_ODBC()
#find_package_TinyXML2()
#find_package_RapidJSON()

function(find_package_logbook)
	include(FetchContent)

	message(STATUS "OpenESL: Finding logbook dependency")

	if(NOT TARGET logbook::logbook)
		if("logbook" IN_LIST OPENESL_USE_SYSTEM_LIBS)
			message(FATAL_ERROR "OpenESL: Logbook is not available as system library. Remove 'logbook' from OPENESL_USE_SYSTEM_LIBS and try again.")
		else()
			if(OPENESL_USE_OFFLINE_LIBS)
				FetchContent_Declare(
					logbook
					SOURCE_DIR "${CMAKE_SOURCE_DIR}/thirdparty/logbook"
					OVERRIDE_FIND_PACKAGE # 'find_package(...)' will call 'FetchContent_MakeAvailable(...)'
				)
			else()
				message(STATUS "OpenESL: Try to fetch source code of logbook from github")
				FetchContent_Declare(
					logbook
					GIT_REPOSITORY https://github.com/SLukasDE/logbook
					GIT_TAG master
					GIT_SHALLOW TRUE
					OVERRIDE_FIND_PACKAGE # 'find_package(...)' will call 'FetchContent_MakeAvailable(...)'
				)
			endif()
			find_package(logbook REQUIRED)
		
			# Install logbook library (important for dependent projects)
			install(TARGETS logbook
				EXPORT OpenESLTargets
				LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
				ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
				RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
				INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
			)
		endif()
		
		if(NOT logbook_FOUND)
			message(FATAL_ERROR "OpenESL: Logbook NOT found")
		endif()
		message(STATUS "OpenESL: Logbook has been found")

		# Set config-flag for OpenESL
		target_compile_definitions(OpenESL PUBLIC HAS_LOGBOOK)
	else()
		message(STATUS "OpenESL: Logbook has been loaded already")
	endif()
endfunction()

function(find_package_zsystem)
	include(FetchContent)

	message(STATUS "OpenESL: Finding zsystem dependency")

	if(NOT TARGET zsystem::zsystem)
		if("zsystem" IN_LIST OPENESL_USE_SYSTEM_LIBS)
			message(FATAL_ERROR "OpenESL: ZSystem is not available as system library. Remove 'zsystem' from OPENESL_USE_SYSTEM_LIBS and try again.")
		else()
			if(OPENESL_USE_OFFLINE_LIBS)
				FetchContent_Declare(
					zsystem
					SOURCE_DIR "${CMAKE_SOURCE_DIR}/thirdparty/zsystem"
					OVERRIDE_FIND_PACKAGE # 'find_package(...)' will call 'FetchContent_MakeAvailable(...)'
				)
			else()
				message(STATUS "OpenESL: Try to fetch source code of zsystem from github")
				FetchContent_Declare(
					zsystem
					GIT_REPOSITORY https://github.com/SLukasDE/zsystem
					GIT_TAG master
					GIT_SHALLOW TRUE
					OVERRIDE_FIND_PACKAGE # 'find_package(...)' will call 'FetchContent_MakeAvailable(...)'
				)
			endif()
			find_package(zsystem REQUIRED)
		
			# Install zsystem library (important for dependent projects)
			install(TARGETS zsystem
				EXPORT OpenESLTargets
				LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
				ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
				RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
				INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
			)
		endif()
		
		if(NOT zsystem_FOUND)
			message(FATAL_ERROR "OpenESL: ZSystem NOT found")
		endif()
		message(STATUS "OpenESL: ZSystem has been found")

		# Set config-flag for OpenESL
		target_compile_definitions(OpenESL PUBLIC HAS_ZSYSTEM)
	else()
		message(STATUS "OpenESL: ZSystem has been loaded already")
	endif()
endfunction()

function(find_package_GnuTLS)
	include(FetchContent)	
	
	if(WIN32)
		set(OPENESL_FEATURE_PATH "${CMAKE_BINARY_DIR}/external/gnutls-3.7.5-w64")
#	elseif(UNIX OR APPLE)
	else()
		set(OPENESL_FEATURE_PATH "${CMAKE_BINARY_DIR}/external/gnutls")
	endif()
	
	if(EXISTS "${OPENESL_FEATURE_PATH}")
		message(STATUS "OpenESL: GnuTLS has been loaded already")
	else()
		if(WIN32)
			if("GnuTLS" IN_LIST OPENESL_USE_SYSTEM_LIBS)
				find_package(GnuTLS REQUIRED)
				
				# Add "GnuTLS" to ${OPENESL_DEPENDENCIES}, to call "find_package(GnuTLS REQUIRED)"
				# again when using OpenESL in other projects.
				set(OPENESL_DEPENDENCIES ${OPENESL_DEPENDENCIES} "GnuTLS" CACHE INTERNAL "External dependencies of OpenESL" FORCE)
			else()
				if(OPENESL_USE_OFFLINE_LIBS)
					if(NOT EXISTS "${CMAKE_BINARY_DIR}/external/gnutls-3.7.5-w64")
						execute_process(
							COMMAND $ENV{ProgramFiles}/7-Zip/7z x "${CMAKE_SOURCE_DIR}/thirdparty/GnuTLS/gnutls-3.7.5-w64.zip" "-o${CMAKE_BINARY_DIR}/external/*"
						)
					endif()
				else()
					message(STATUS "OpenESL: Try to fetch prebuild binaries of GnuTLS from original website")
					if(NOT EXISTS "${CMAKE_BINARY_DIR}/external/gnutls-3.7.5-w64.zip")
						file(
							DOWNLOAD "https://www.gnupg.org/ftp/gcrypt/gnutls/v3.7/gnutls-3.7.5-w64.zip" "${CMAKE_BINARY_DIR}/external/gnutls-3.7.5-w64.zip"
							EXPECTED_HASH MD5=d8bbbc6e0d168f0274eabba934e283cc
							#SHOW_PROGRESS
							)
					endif()
					if(NOT EXISTS "${CMAKE_BINARY_DIR}/external/gnutls-3.7.5-w64")
						execute_process(
							COMMAND $ENV{ProgramFiles}/7-Zip/7z x "${CMAKE_BINARY_DIR}/external/gnutls-3.7.5-w64.zip" "-o${CMAKE_BINARY_DIR}/external/*"
						)
					endif()
				endif()
				if(NOT EXISTS "${CMAKE_BINARY_DIR}/external/gnutls-3.7.5-w64")
					message(FATAL_ERROR "OpenESL: Failed to get GnuTLS")
				endif()
				
				if(EXISTS "${CMAKE_BINARY_DIR}/external/gnutls-3.7.5-w64/win64-build/lib/includes")
					file(RENAME ${CMAKE_BINARY_DIR}/external/gnutls-3.7.5-w64/win64-build/lib/includes ${CMAKE_BINARY_DIR}/external/gnutls-3.7.5-w64/win64-build/lib/gnutls)
				endif()
					
				add_library(GnuTLS INTERFACE)
				target_link_libraries(GnuTLS INTERFACE
					$<BUILD_INTERFACE:${CMAKE_BINARY_DIR}/external/gnutls-3.7.5-w64/win64-build/bin/libgnutls-30.dll>
					$<INSTALL_INTERFACE:${CMAKE_INSTALL_PREFIX}/lib/libgnutls-30.dll>
				)
				target_include_directories(GnuTLS INTERFACE
					$<BUILD_INTERFACE:${CMAKE_BINARY_DIR}/external/gnutls-3.7.5-w64/win64-build/lib>
					$<INSTALL_INTERFACE:include>
				)
				add_library(GnuTLS::GnuTLS ALIAS GnuTLS)
				
				install(TARGETS GnuTLS
					EXPORT OpenESLTargets
					LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
					ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
					RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
#					INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
				)
				set(GNUTLS_FOUND TRUE)
			endif()
		elseif(UNIX OR APPLE)
			##############################################
			# ToDo: Apple lib has suffix .dylib, not .so #
			##############################################
			if("GnuTLS" IN_LIST OPENESL_USE_SYSTEM_LIBS)
				find_package(GnuTLS REQUIRED)
				
				# Add "GnuTLS" to ${OPENESL_DEPENDENCIES}, to call "find_package(GnuTLS REQUIRED)"
				# again when using OpenESL in other projects.
				set(OPENESL_DEPENDENCIES ${OPENESL_DEPENDENCIES} "GnuTLS" CACHE INTERNAL "External dependencies of OpenESL" FORCE)
			else()
				if(OPENESL_USE_OFFLINE_LIBS)
					if(NOT EXISTS "${CMAKE_BINARY_DIR}/external/gnutls-3.7.5")
						file(ARCHIVE_EXTRACT INPUT "${CMAKE_SOURCE_DIR}/thirdparty/GnuTLS/gnutls-3.7.5.tar.xz" DESTINATION "${CMAKE_BINARY_DIR}/external")
					endif()
				else()
					message(STATUS "OpenESL: Try to fetch source code of GnuTLS from original website")
					if(NOT EXISTS "${CMAKE_BINARY_DIR}/external/gnutls-3.7.5.tar.xz")
						file(
							DOWNLOAD "https://www.gnupg.org/ftp/gcrypt/gnutls/v3.7/gnutls-3.7.5.tar.xz" "${CMAKE_BINARY_DIR}/external/gnutls-3.7.5.tar.xz"
							EXPECTED_HASH MD5=749eb6f0e5646b90dd00521b7853b7c7
							#SHOW_PROGRESS
							)
					endif()
					if(NOT EXISTS "${CMAKE_BINARY_DIR}/external/gnutls-3.7.5")
						file(ARCHIVE_EXTRACT INPUT "${CMAKE_BINARY_DIR}/external/gnutls-3.7.5.tar.xz" DESTINATION "${CMAKE_BINARY_DIR}/external")
					endif()
				endif()
				if(NOT EXISTS "${CMAKE_BINARY_DIR}/external/gnutls-3.7.5")
					message(FATAL_ERROR "OpenESL: Failed to get GnuTLS")
				endif()
				if(NOT EXISTS "${CMAKE_BINARY_DIR}/external/gnutls")
					execute_process(
						COMMAND "${CMAKE_BINARY_DIR}/external/gnutls-3.7.5/configure" --prefix=${CMAKE_BINARY_DIR}/external/gnutls
						WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/external/gnutls-3.7.5"
					)
					execute_process(
						COMMAND make
						WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/external/gnutls-3.7.5"
					)
					execute_process(
						COMMAND make install
						WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/external/gnutls-3.7.5"
					)

					install(DIRECTORY
						"${CMAKE_BINARY_DIR}/external/gnutls/lib/"
						DESTINATION lib)
					install(DIRECTORY
						"${CMAKE_BINARY_DIR}/external/gnutls/include/"
						DESTINATION include)
				endif()
				
				add_library(GnuTLS INTERFACE)
				target_link_directories(GnuTLS INTERFACE
					$<BUILD_INTERFACE:${CMAKE_BINARY_DIR}/external/gnutls/lib>
					$<INSTALL_INTERFACE:${CMAKE_INSTALL_PREFIX}/lib>
				)
				target_link_libraries(GnuTLS INTERFACE gnutls)
				target_include_directories(GnuTLS INTERFACE
					$<BUILD_INTERFACE:${CMAKE_BINARY_DIR}/external/gnutls/include>
					$<INSTALL_INTERFACE:include>
				)
				add_library(GnuTLS::GnuTLS ALIAS GnuTLS)
				
				install(TARGETS GnuTLS
					EXPORT OpenESLTargets
					LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
					ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
					RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
#					INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
				)
				set(GNUTLS_FOUND TRUE)
			endif()
		else()
			message(FATAL_ERROR "OpenESL: GnuTLS not available for unknown OS")
		endif()

		if(NOT GNUTLS_FOUND)
			message(FATAL_ERROR "OpenESL: GnuTLS not found")
		endif()

		# Set config-flag for OpenESL
		target_compile_definitions(OpenESL PUBLIC HAS_GNUTLS)
	endif()
endfunction()

function(find_package_libmicrohttpd)
	include(FetchContent)

	if(WIN32)
		set(OPENESL_FEATURE_PATH "${CMAKE_BINARY_DIR}/external/libmicrohttpd-0.9.77-w32-bin")
#	elseif(UNIX OR APPLE)
	else()
		set(OPENESL_FEATURE_PATH "${CMAKE_BINARY_DIR}/external/libmicrohttpd")
	endif()
	
	if(EXISTS "${OPENESL_FEATURE_PATH}")
		message(STATUS "OpenESL: libmicrohttpd has been loaded already")
	else()
		if(WIN32)
			if("libmicrohttpd" IN_LIST OPENESL_USE_SYSTEM_LIBS)
				find_package(libmicrohttpd REQUIRED)
				
				# Add "libmicrohttpd" to ${OPENESL_DEPENDENCIES}, to call "find_package(libmicrohttpd REQUIRED)"
				# again when using OpenESL in other projects.
				set(OPENESL_DEPENDENCIES ${OPENESL_DEPENDENCIES} "libmicrohttpd" CACHE INTERNAL "External dependencies of OpenESL" FORCE)
			else()
				if(OPENESL_USE_OFFLINE_LIBS)
					if(NOT EXISTS "${CMAKE_BINARY_DIR}/external/libmicrohttpd-0.9.77-w32-bin")
						execute_process(
							COMMAND $ENV{ProgramFiles}/7-Zip/7z x "${CMAKE_SOURCE_DIR}/thirdparty/libmicrohttpd/libmicrohttpd-0.9.77-w32-bin.zip" "-o${CMAKE_BINARY_DIR}/external/*"
						)
					endif()
				else()
					message(STATUS "OpenESL: Try to fetch prebuild binaries of libmicrohttpd from original website")
					if(NOT EXISTS "${CMAKE_BINARY_DIR}/external/libmicrohttpd-0.9.77-w32-bin.zip")
						file(
							DOWNLOAD "https://ftp.fau.de/gnu/libmicrohttpd/libmicrohttpd-0.9.77-w32-bin.zip" "${CMAKE_BINARY_DIR}/external/libmicrohttpd-0.9.77-w32-bin.zip"
							EXPECTED_HASH MD5=100379141a825e3258e276069f2bb542
							#SHOW_PROGRESS
							)
					endif()
					if(NOT EXISTS "${CMAKE_BINARY_DIR}/external/libmicrohttpd-0.9.77-w32-bin")
						execute_process(
							COMMAND $ENV{ProgramFiles}/7-Zip/7z x "${CMAKE_BINARY_DIR}/external/libmicrohttpd-0.9.77-w32-bin.zip" "-o${CMAKE_BINARY_DIR}/external/*"
						)
					endif()
				endif()
				if(NOT EXISTS "${CMAKE_BINARY_DIR}/external/libmicrohttpd-0.9.77-w32-bin")
					message(FATAL_ERROR "OpenESL: Failed to get libmicrohttpd")
				endif()
				
				add_library(libmicrohttpd INTERFACE)
				target_link_libraries(libmicrohttpd INTERFACE
					$<BUILD_INTERFACE:${CMAKE_BINARY_DIR}/external/libmicrohttpd-0.9.77-w32-bin/libmicrohttpd-0.9.77-w32-bin/x86_64/MinGW/shared/mingw64/bin/libmicrohttpd-12.dll>
					$<INSTALL_INTERFACE:${CMAKE_INSTALL_PREFIX}/lib/libmicrohttpd-12.dll>
				)
				target_include_directories(libmicrohttpd INTERFACE
					$<BUILD_INTERFACE:${CMAKE_BINARY_DIR}/external/libmicrohttpd-0.9.77-w32-bin/libmicrohttpd-0.9.77-w32-bin/x86_64/MinGW/shared/mingw64/include>
					$<INSTALL_INTERFACE:include>
				)
				add_library(libmicrohttpd::libmicrohttpd ALIAS libmicrohttpd)
				
				install(TARGETS libmicrohttpd
					EXPORT OpenESLTargets
					LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
					ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
					RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
#					INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
				)
				set(libmicrohttpd_FOUND TRUE)
			endif()
		elseif(UNIX OR APPLE)
			##############################################
			# ToDo: Apple lib has suffix .dylib, not .so #
			##############################################
			if("libmicrohttpd" IN_LIST OPENESL_USE_SYSTEM_LIBS)
				find_package(PkgConfig REQUIRED)
				pkg_check_modules(MICROHTTPD REQUIRED libmicrohttpd)
				#find_library(MICROHTTPD_LIBRARIES microhttpd)
				#find_path(MICROHTTPD_INCLUDE_DIRS microhttpd.h)
				
				add_library(libmicrohttpd INTERFACE)
				target_include_directories(libmicrohttpd INTERFACE ${MICROHTTPD_INCLUDE_DIRS})
				target_link_directories(libmicrohttpd INTERFACE ${MICROHTTPD_LIBRARY_DIRS})
				target_link_libraries(libmicrohttpd INTERFACE ${MICROHTTPD_LIBRARIES})				
				add_library(libmicrohttpd::libmicrohttpd ALIAS libmicrohttpd)
				
				install(TARGETS libmicrohttpd
					EXPORT OpenESLTargets
					LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
					ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
					RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
#					INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
				)
				set(libmicrohttpd_FOUND TRUE)

				message(STATUS "OpenESL: MICROHTTPD_INCLUDE_DIRS = ${MICROHTTPD_INCLUDE_DIRS}")
				message(STATUS "OpenESL: MICROHTTPD_LIBRARY_DIRS = ${MICROHTTPD_LIBRARY_DIRS}")
				message(STATUS "OpenESL: MICROHTTPD_LIBRARIES = ${MICROHTTPD_LIBRARIES}")
			else()
				find_package_GnuTLS()
				
				if(OPENESL_USE_OFFLINE_LIBS)
					if(NOT EXISTS "${CMAKE_BINARY_DIR}/external/libmicrohttpd-0.9.77")
						file(ARCHIVE_EXTRACT INPUT "${CMAKE_SOURCE_DIR}/thirdparty/libmicrohttpd/libmicrohttpd-0.9.77.tar.gz" DESTINATION "${CMAKE_BINARY_DIR}/external")
					endif()
				else()
					message(STATUS "Try to fetch source code of libmicrohttpd from original website")
					if(NOT EXISTS "${CMAKE_BINARY_DIR}/external/libmicrohttpd-0.9.77.tar.gz")
						file(
							DOWNLOAD "https://ftp.fau.de/gnu/libmicrohttpd/libmicrohttpd-0.9.77.tar.gz" "${CMAKE_BINARY_DIR}/external/libmicrohttpd-0.9.77.tar.gz"
							EXPECTED_HASH MD5=bc1b407093459ff5e7af2e3c0634d220
							#SHOW_PROGRESS
							)
					endif()
					if(NOT EXISTS "${CMAKE_BINARY_DIR}/external/libmicrohttpd-0.9.77")
						file(ARCHIVE_EXTRACT INPUT "${CMAKE_BINARY_DIR}/external/libmicrohttpd-0.9.77.tar.gz" DESTINATION "${CMAKE_BINARY_DIR}/external")
					endif()
				endif()
				if(NOT EXISTS "${CMAKE_BINARY_DIR}/external/libmicrohttpd-0.9.77")
					message(FATAL_ERROR "OpenESL: Failed to get libmicrohttpd")
				endif()
				if(NOT EXISTS "${CMAKE_BINARY_DIR}/external/libmicrohttpd")
					if(NOT DEFINED GNUTLS_LIBRARY OR "${GNUTLS_LIBRARY}" STREQUAL "")
						######################################################
						# "GnuTLS" is NOT in list ${OPENESL_USE_SYSTEM_LIBS} #
						# -> libmicrohttpd will be configured to GnuTLS path #
						#    '${CMAKE_BINARY_DIR}/external/gnutls'           #
						######################################################
						message(STATUS "OpenESL: MHD -> GNUTLS_LIBRARY=<empty>")
						execute_process(
							COMMAND "${CMAKE_BINARY_DIR}/external/libmicrohttpd-0.9.77/configure" --prefix=${CMAKE_BINARY_DIR}/external/libmicrohttpd --with-gnutls=${CMAKE_BINARY_DIR}/external/gnutls --enable-static=no
							WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/external/libmicrohttpd-0.9.77"
						)
					else()
						############################################################
						# "GnuTLS" is in list ${OPENESL_USE_SYSTEM_LIBS}           #
						# -> libmicrohttpd must be configured to other GnuTLS path #
						############################################################
						get_filename_component(GNUTLS_LIBRARY_DIR "${GNUTLS_LIBRARY}" DIRECTORY)
						
						message(STATUS "OpenESL: MHD -> GNUTLS_INCLUDE_DIR=${GNUTLS_INCLUDE_DIR}")
						message(STATUS "OpenESL: MHD -> GNUTLS_LIBRARY=${GNUTLS_LIBRARY}")
						message(STATUS "OpenESL: MHD -> GNUTLS_LIBRARY_DIR=${GNUTLS_LIBRARY_DIR}")

						set(ENV{CPPFLAGS} "-I${GNUTLS_INCLUDE_DIR}")
						set(ENV{LDFLAGS}  "-L${GNUTLS_LIBRARY_DIR}")
						execute_process(
							COMMAND "${CMAKE_BINARY_DIR}/external/libmicrohttpd-0.9.77/configure" --prefix=${CMAKE_BINARY_DIR}/external/libmicrohttpd --with-gnutls --enable-static=no
							WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/external/libmicrohttpd-0.9.77"
							RESULT_VARIABLE res
						)
						if(NOT res EQUAL 0)
							message(FATAL_ERROR "OpenESL: libmicrohttpd-configure failed with exit code ${res}.")
						endif()
					endif()
					execute_process(
						COMMAND make
						WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/external/libmicrohttpd-0.9.77"
					)
					execute_process(
						COMMAND make install
						WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/external/libmicrohttpd-0.9.77"
					)
					
					install(DIRECTORY
						"${CMAKE_BINARY_DIR}/external/libmicrohttpd/lib/"
						DESTINATION lib)
					install(DIRECTORY
						"${CMAKE_BINARY_DIR}/external/libmicrohttpd/include/"
						DESTINATION include)
				endif()
				
				add_library(libmicrohttpd INTERFACE)
				target_link_directories(libmicrohttpd INTERFACE
					$<BUILD_INTERFACE:${CMAKE_BINARY_DIR}/external/libmicrohttpd/lib>
					$<INSTALL_INTERFACE:${CMAKE_INSTALL_PREFIX}/lib>
				)
				target_link_libraries(libmicrohttpd INTERFACE microhttpd)
				target_link_libraries(libmicrohttpd INTERFACE GnuTLS::GnuTLS)
				target_include_directories(libmicrohttpd INTERFACE
					$<BUILD_INTERFACE:${CMAKE_BINARY_DIR}/external/libmicrohttpd/include>
					$<INSTALL_INTERFACE:include>
				)
				add_library(libmicrohttpd::libmicrohttpd ALIAS libmicrohttpd)
				
				install(TARGETS libmicrohttpd
					EXPORT OpenESLTargets
					LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
					ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
					RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
#					INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
				)
				set(libmicrohttpd_FOUND TRUE)
			endif()
		else()
			message(FATAL_ERROR "OpenESL: libmicrohttpd not available for unknown OS")
		endif()

		if(NOT libmicrohttpd_FOUND)
			message(FATAL_ERROR "OpenESL: libmicrohttpd not found")
		endif()

		# Set config-flag for OpenESL
		target_compile_definitions(OpenESL PUBLIC HAS_LIBMICROHTTPD)
		target_compile_definitions(OpenESL PUBLIC HAS_MHD)
	endif()
endfunction()


function(find_package_CURL)
	include(FetchContent)
	
	if(NOT "CURL" IN_LIST OPENESL_USE_SYSTEM_LIBS)
		find_package_GnuTLS()
	endif()
	
	if(WIN32)
		set(OPENESL_FEATURE_PATH "${CMAKE_BINARY_DIR}/external/curl")
#	elseif(UNIX OR APPLE)
	else()
		set(OPENESL_FEATURE_PATH "${CMAKE_BINARY_DIR}/external/curl")
	endif()
	
	if(EXISTS "${OPENESL_FEATURE_PATH}")
		message(STATUS "OpenESL: CURL has been loaded already")
	else()
		if(WIN32)
		elseif(UNIX OR APPLE)
			##############################################
			# ToDo: Apple lib has suffix .dylib, not .so #
			##############################################
			if("CURL" IN_LIST OPENESL_USE_SYSTEM_LIBS)
				find_package(CURL REQUIRED)
				
				# Add "CURL" to ${OPENESL_DEPENDENCIES}, to call "find_package(CURL REQUIRED)"
				# again when using OpenESL in other projects.
				set(OPENESL_DEPENDENCIES ${OPENESL_DEPENDENCIES} "CURL" CACHE INTERNAL "External dependencies of OpenESL" FORCE)
			else()
				if(OPENESL_USE_OFFLINE_LIBS)
					if(NOT EXISTS "${CMAKE_BINARY_DIR}/external/curl-8.5.0")
						file(ARCHIVE_EXTRACT INPUT "${CMAKE_SOURCE_DIR}/thirdparty/CURL/curl-8.5.0.tar.gz" DESTINATION "${CMAKE_BINARY_DIR}/external")
					endif()
				else()
					message(STATUS "OpenESL: Try to fetch source code of CURL from original website")
					if(NOT EXISTS "${CMAKE_BINARY_DIR}/external/curl-8.5.0.tar.gz")
						file(
							DOWNLOAD "https://curl.se/download/curl-8.5.0.tar.gz" "${CMAKE_BINARY_DIR}/external/curl-8.5.0.tar.gz"
							#SHOW_PROGRESS
						)
					endif()
					if(NOT EXISTS "${CMAKE_BINARY_DIR}/external/curl-8.5.0")
						file(ARCHIVE_EXTRACT INPUT "${CMAKE_BINARY_DIR}/external/curl-8.5.0.tar.gz" DESTINATION "${CMAKE_BINARY_DIR}/external")
					endif()
				endif()
				if(NOT EXISTS "${CMAKE_BINARY_DIR}/external/curl-8.5.0")
					message(FATAL_ERROR "OpenESL: Failed to get CURL")
				endif()
				if(NOT EXISTS "${CMAKE_BINARY_DIR}/external/curl")
					######################################################################
					# ToDo: Check 'if("GnuTLS" IN_LIST OPENESL_USE_SYSTEM_LIBS)'         #
					#       If TRUE, then CURL must be configured to other path #
					######################################################################
					execute_process(
						COMMAND "${CMAKE_BINARY_DIR}/external/curl-8.5.0/configure" --prefix=${CMAKE_BINARY_DIR}/external/curl --with-gnutls=${CMAKE_BINARY_DIR}/external/gnutls --without-libidn2 --without-zlib --without-zstd --without-brotli --disable-ftp --disable-ldap --disable-ldaps --disable-pop3 --disable-imap --disable-smb --disable-smtp --disable-rtsp --disable-mqtt --disable-telnet --disable-tftp --disable-dict --disable-gopher
						WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/external/curl-8.5.0"
					)
					execute_process(
						COMMAND make
						WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/external/curl-8.5.0"
					)
					execute_process(
						COMMAND make install
						WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/external/curl-8.5.0"
					)
					
					install(DIRECTORY
						"${CMAKE_BINARY_DIR}/external/curl/lib/"
						DESTINATION lib)
					install(DIRECTORY
						"${CMAKE_BINARY_DIR}/external/curl/include/"
						DESTINATION include)
				endif()
				
				add_library(libcurl INTERFACE)
				target_link_directories(libcurl INTERFACE
					$<BUILD_INTERFACE:${CMAKE_BINARY_DIR}/external/curl/lib>
					$<INSTALL_INTERFACE:${CMAKE_INSTALL_PREFIX}/lib>
				)
				target_link_libraries(libcurl INTERFACE curl)
				target_include_directories(libcurl INTERFACE
					$<BUILD_INTERFACE:${CMAKE_BINARY_DIR}/external/curl/include>
					$<INSTALL_INTERFACE:include>
				)
				add_library(CURL::libcurl ALIAS libcurl)
				
				install(TARGETS libcurl
					EXPORT OpenESLTargets
					LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
					ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
					RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
#					INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
				)
				set(CURL_FOUND TRUE)
			endif()
		else()
			message(FATAL_ERROR "OpenESL: CURL not available for unknown OS")
		endif()

		if(NOT CURL_FOUND)
			message(FATAL_ERROR "OpenESL: CURL not found")
		endif()

		# Set config-flag for OpenESL
		target_compile_definitions(OpenESL PUBLIC HAS_CURL)
	endif()
endfunction()


function(find_package_ODBC)
	include(FetchContent)
	
	if(WIN32)
		set(OPENESL_FEATURE_PATH "${CMAKE_BINARY_DIR}/external/ODBC")
	elseif(APPLE)
		set(OPENESL_FEATURE_PATH "${CMAKE_BINARY_DIR}/external/iODBC")
#	elseif(UNIX)
	else()
		set(OPENESL_FEATURE_PATH "${CMAKE_BINARY_DIR}/external/unixODBC")
	endif()
	
	if(EXISTS "${OPENESL_FEATURE_PATH}")
		message(STATUS "OpenESL: ODBC has been loaded already")
	else()
		if(WIN32)
		elseif(APPLE)
			# https://github.com/openlink/iODBC
			message(STATUS "OpenESL: Try to fetch source code of iODBC from original website")
			# ...
		elseif(UNIX)
			if("ODBC" IN_LIST OPENESL_USE_SYSTEM_LIBS)
				find_package(ODBC REQUIRED)
				
				# Add "ODBC" to ${OPENESL_DEPENDENCIES}, to call "find_package(ODBC REQUIRED)"
				# again when using OpenESL in other projects.
				set(OPENESL_DEPENDENCIES ${OPENESL_DEPENDENCIES} "ODBC" CACHE INTERNAL "External dependencies of OpenESL" FORCE)
			else()
				if(OPENESL_USE_OFFLINE_LIBS)
					if(NOT EXISTS "${CMAKE_BINARY_DIR}/external/unixODBC-2.3.12")
						file(ARCHIVE_EXTRACT INPUT "${CMAKE_SOURCE_DIR}/thirdparty/unixODBC/unixODBC-2.3.12.tar.gz" DESTINATION "${CMAKE_BINARY_DIR}/external")
					endif()
				else()
					message(STATUS "OpenESL: Try to fetch source code of unixODBC from original website")
					if(NOT EXISTS "${CMAKE_BINARY_DIR}/external/unixODBC-2.3.12.tar.gz")
						file(
							DOWNLOAD "https://www.unixodbc.org/unixODBC-2.3.12.tar.gz" "${CMAKE_BINARY_DIR}/external/unixODBC-2.3.12.tar.gz"
							EXPECTED_HASH MD5=d62167d85bcb459c200c0e4b5a63ee48
							#SHOW_PROGRESS
						)
					endif()
					if(NOT EXISTS "${CMAKE_BINARY_DIR}/external/unixODBC-2.3.12")
						file(ARCHIVE_EXTRACT INPUT "${CMAKE_BINARY_DIR}/external/unixODBC-2.3.12.tar.gz" DESTINATION "${CMAKE_BINARY_DIR}/external")
					endif()
				endif()
				if(NOT EXISTS "${CMAKE_BINARY_DIR}/external/unixODBC-2.3.12")
					message(FATAL_ERROR "OpenESL: Failed to get ODBC")
				endif()
				if(NOT EXISTS "${CMAKE_BINARY_DIR}/external/unixODBC")
					execute_process(
						COMMAND "${CMAKE_BINARY_DIR}/external/unixODBC-2.3.12/configure" --prefix=${CMAKE_BINARY_DIR}/external/unixODBC --disable-gui
						WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/external/unixODBC-2.3.12"
					)
					execute_process(
						COMMAND make
						WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/external/unixODBC-2.3.12"
					)
					execute_process(
						COMMAND make install
						WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/external/unixODBC-2.3.12"
					)
					
					install(DIRECTORY
						"${CMAKE_BINARY_DIR}/external/unixODBC/lib/"
						DESTINATION lib)
					install(DIRECTORY
						"${CMAKE_BINARY_DIR}/external/unixODBC/include/"
						DESTINATION include)
				endif()
				
				add_library(ODBC INTERFACE)
				target_link_directories(ODBC INTERFACE
					$<BUILD_INTERFACE:${CMAKE_BINARY_DIR}/external/unixODBC/lib>
					$<INSTALL_INTERFACE:${CMAKE_INSTALL_PREFIX}/lib>
				)
				target_link_libraries(ODBC INTERFACE odbc)
				target_include_directories(ODBC INTERFACE
					$<BUILD_INTERFACE:${CMAKE_BINARY_DIR}/external/unixODBC/include>
					$<INSTALL_INTERFACE:include>
				)
				add_library(ODBC::ODBC ALIAS ODBC)
				
				install(TARGETS ODBC
					EXPORT OpenESLTargets
					LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
					ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
					RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
#					INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
				)
				set(ODBC_FOUND TRUE)
			endif()
		else()
			message(FATAL_ERROR "OpenESL: unixODBC not available for unknown OS")
		endif()

		if(NOT ODBC_FOUND)
			message(FATAL_ERROR "OpenESL: ODBC not found")
		endif()

		# Set config-flag for OpenESL
		target_compile_definitions(OpenESL PUBLIC HAS_ODBC)
	endif()
endfunction()


function(find_package_SQLite3)
	include(FetchContent)
	
	if(WIN32)
		set(OPENESL_FEATURE_PATH "${CMAKE_BINARY_DIR}/external/SQLite3")
#	elseif(UNIX OR APPLE)
	else()
		set(OPENESL_FEATURE_PATH "${CMAKE_BINARY_DIR}/external/SQLite3")
	endif()
	
	if(EXISTS "${OPENESL_FEATURE_PATH}")
		message(STATUS "OpenESL: SQLite has been loaded already")
	else()
		if(WIN32)
		elseif(APPLE OR UNIX)
			if("SQLite3" IN_LIST OPENESL_USE_SYSTEM_LIBS)
				find_package(SQLite3 REQUIRED)
				
				# Add "SQLite3" to ${OPENESL_DEPENDENCIES}, to call "find_package(SQLite3 REQUIRED)"
				# again when using OpenESL in other projects.
				set(OPENESL_DEPENDENCIES ${OPENESL_DEPENDENCIES} "SQLite3" CACHE INTERNAL "External dependencies of OpenESL" FORCE)
			else()
				if(OPENESL_USE_OFFLINE_LIBS)
					if(NOT EXISTS "${CMAKE_BINARY_DIR}/external/sqlite-src-3500400")
						file(ARCHIVE_EXTRACT INPUT "${CMAKE_SOURCE_DIR}/thirdparty/SQLite/sqlite-src-3500400.zip" DESTINATION "${CMAKE_BINARY_DIR}/external")
					endif()
				else()
					message(STATUS "OpenESL: Try to fetch source code of SQLite3 from original website")
					if(NOT EXISTS "${CMAKE_BINARY_DIR}/external/sqlite-src-3500400.zip")
						file(
							DOWNLOAD "https://www.sqlite.org/2025/sqlite-src-3500400.zip" "${CMAKE_BINARY_DIR}/external/sqlite-src-3500400.zip"
							#SHOW_PROGRESS
						)
					endif()
					if(NOT EXISTS "${CMAKE_BINARY_DIR}/external/sqlite-src-3500400")
						file(ARCHIVE_EXTRACT INPUT "${CMAKE_BINARY_DIR}/external/sqlite-src-3500400.zip" DESTINATION "${CMAKE_BINARY_DIR}/external")
					endif()
				endif()
				if(NOT EXISTS "${CMAKE_BINARY_DIR}/external/sqlite-src-3500400")
					message(FATAL_ERROR "OpenESL: Failed to get SQLite3")
				endif()
				if(NOT EXISTS "${CMAKE_BINARY_DIR}/external/SQLite3")
					execute_process(
						COMMAND "${CMAKE_BINARY_DIR}/external/sqlite-src-3500400/configure" --prefix=${CMAKE_BINARY_DIR}/external/SQLite3 --memsys5 --fts3 --fts4 --fts5 --update-limit --geopoly --rtree --session --scanstatus
						WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/external/sqlite-src-3500400"
					)
					execute_process(
						COMMAND make
						WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/external/sqlite-src-3500400"
					)
					execute_process(
						COMMAND make install
						WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/external/sqlite-src-3500400"
					)
					
					install(DIRECTORY
						"${CMAKE_BINARY_DIR}/external/SQLite3/lib/"
						DESTINATION lib)
					install(DIRECTORY
						"${CMAKE_BINARY_DIR}/external/SQLite3/include/"
						DESTINATION include)
				endif()
				
				add_library(SQLite3 INTERFACE)
				target_link_directories(SQLite3 INTERFACE
					$<BUILD_INTERFACE:${CMAKE_BINARY_DIR}/external/SQLite3/lib>
					$<INSTALL_INTERFACE:${CMAKE_INSTALL_PREFIX}/lib>
				)
				target_link_libraries(SQLite3 INTERFACE sqlite3)
				target_include_directories(SQLite3 INTERFACE
					$<BUILD_INTERFACE:${CMAKE_BINARY_DIR}/external/SQLite3/include>
					$<INSTALL_INTERFACE:include>
				)
				add_library(SQLite::SQLite3 ALIAS SQLite3)
				
				install(TARGETS SQLite3
					EXPORT OpenESLTargets
					LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
					ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
					RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
#					INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
				)
				set(SQLITE3_FOUND TRUE)
			endif()
		else()
			message(FATAL_ERROR "OpenESL: SQLite3 not available for unknown OS")
		endif()

		if(NOT SQLITE3_FOUND)
			message(FATAL_ERROR "OpenESL: SQLite3 not found")
		endif()

		# Set config-flag for OpenESL
		target_compile_definitions(OpenESL PUBLIC HAS_SQLITE3)
	endif()
endfunction()


function(find_package_TinyXML2)
	include(FetchContent)

	message(STATUS "OpenESL: Finding TinyXML2 dependency")

	if(NOT TARGET tinyxml2::tinyxml2)
		if("TinyXML2" IN_LIST OPENESL_USE_SYSTEM_LIBS)
#			set(OPENESL_DEPENDENCIES ${OPENESL_DEPENDENCIES} "tinyxml2" CACHE INTERNAL "External dependencies of OpenESL" FORCE)
			
			find_package(PkgConfig REQUIRED)
			pkg_check_modules(TINYXML2 REQUIRED tinyxml2)
			
			add_library(libtinyxml2 INTERFACE)
			target_include_directories(libtinyxml2 INTERFACE ${TINYXML2_INCLUDE_DIRS})
			target_link_directories(libtinyxml2 INTERFACE ${TINYXML2_LIBRARY_DIRS})
			target_link_libraries(libtinyxml2 INTERFACE ${TINYXML2_LIBRARIES})				
			add_library(tinyxml2::tinyxml2 ALIAS libtinyxml2)
				
			install(TARGETS libtinyxml2
				EXPORT OpenESLTargets
				LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
				ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
				RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
#				INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
			)
			set(tinyxml2_FOUND TRUE)

			message(STATUS "OpenESL: TINYXML2_INCLUDE_DIRS = ${TINYXML2_INCLUDE_DIRS}")
			message(STATUS "OpenESL: TINYXML2_LIBRARY_DIRS = ${TINYXML2_LIBRARY_DIRS}")
			message(STATUS "OpenESL: TINYXML2_LIBRARIES = ${TINYXML2_LIBRARIES}")
		else()
			if(OPENESL_USE_OFFLINE_LIBS)
				FetchContent_Declare(
					tinyxml2
					SOURCE_DIR "${CMAKE_SOURCE_DIR}/thirdparty/TinyXML2"
					OVERRIDE_FIND_PACKAGE # 'find_package(...)' will call 'FetchContent_MakeAvailable(...)'
				)
			else()
				message(STATUS "OpenESL: Try to fetch source code of TinyXML2 from github")
				FetchContent_Declare(
					tinyxml2
					GIT_REPOSITORY https://github.com/leethomason/TinyXML2
					GIT_TAG 10.0.0
					GIT_SHALLOW TRUE
					OVERRIDE_FIND_PACKAGE # 'find_package(...)' will call 'FetchContent_MakeAvailable(...)'
				)
			endif()
			find_package(tinyxml2 REQUIRED)
			

			# TinyXML2 Headers installieren
			get_target_property(TINYXML2_INCLUDE_DIRS tinyxml2 INTERFACE_INCLUDE_DIRECTORIES)
			if(TINYXML2_INCLUDE_DIRS)
				install(DIRECTORY ${TINYXML2_INCLUDE_DIRS}/
					DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
					FILES_MATCHING PATTERN "*.h"
				)
			endif()
				
			# Install TinyXML2 library (important for dependent projects)
			install(TARGETS tinyxml2
				EXPORT OpenESLTargets
				LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
				ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
				RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
				INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
			)
		endif()
		
		if(NOT tinyxml2_FOUND)
			message(FATAL_ERROR "OpenESL: TinyXML2 NOT found")
		endif()	
		message(STATUS "OpenESL: TinyXML2 has been found")

		# Set config-flag for OpenESL
		target_compile_definitions(OpenESL PUBLIC HAS_TINYXML2)
	else()
		message(STATUS "OpenESL: TinyXML2 has been loaded already")
	endif()
endfunction()







if(ESL_DEPENDENCIES_USE_CONAN)
    message(STATUS "Using Conan")
    include(${CMAKE_BINARY_DIR}/conan/conan_toolchain.cmake)
endif()

#include(FindPkgConfig)
if(ESL_DEPENDENCIES_USE_VCPKG)
    message(STATUS "Using VCPKG")
    if(WIN32)
        set(USER_HOME_DIRECTORY $ENV{USERPROFILE})
    else()
        set(USER_HOME_DIRECTORY $ENV{HOME})
    endif()
    message(STATUS "User Home Directory: ${USER_HOME_DIRECTORY}")
    include(${USER_HOME_DIRECTORY}/opt/vcpkg/scripts/buildsystems/vcpkg.cmake)
endif()


function(find_package_RapidJSON)
    # Default, try 'find_package'. VCPKG or Conan may be used, if enabled
    if(NOT RapidJSON_FOUND)
        message(STATUS "Try to find RapidJSON by find_package")
        find_package(RapidJSON QUIET)
        if(RapidJSON_FOUND)
            message(STATUS "RapidJSON has been found by using find_package")
        endif()
    endif()

    if(NOT RapidJSON_FOUND)
        message(STATUS "Try to find RapidJSON by FetchContent")

        set(RAPIDJSON_BUILD_DOC OFF CACHE BOOL "" FORCE)
        set(RAPIDJSON_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
        set(RAPIDJSON_BUILD_TESTS OFF CACHE BOOL "" FORCE)
        #set(RAPIDJSON_BUILD_CXX17 ON CACHE BOOL "" FORCE)
        
        FetchContent_Declare(
            RapidJSON
            GIT_REPOSITORY https://github.com/Tencent/rapidjson.git
            GIT_TAG v1.1.0
            GIT_SHALLOW TRUE
            OVERRIDE_FIND_PACKAGE # 'find_package(...)' will call 'FetchContent_MakeAvailable(...)'
        )
        find_package(RapidJSON QUIET)
        #message(STATUS "XXXXXXXXXXXXXXXXXXXXXXXX rapidjson_SOURCE_DIR: ${rapidjson_SOURCE_DIR}")
        #message(STATUS "RapidJSON_DIR:        ${RapidJSON_DIR}")

        #add_library(RapidJSON::RapidJSON UNKNOWN IMPORTED)
        add_library(RapidJSON::RapidJSON INTERFACE IMPORTED)
        set_target_properties(RapidJSON::RapidJSON PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${rapidjson_SOURCE_DIR}/include")

        if(RapidJSON_FOUND)
            message(STATUS "RapidJSON has been found by using FetchContent")
        endif()
    endif()

    #if(TARGET RapidJSON::RapidJSON)
    #    message(STATUS "TARGET RapidJSON::RapidJSON exists")
    #else()
    #    message(FATAL_ERROR "TARGET RapidJSON::RapidJSON does not exists")
    #endif()

    if(NOT RapidJSON_FOUND)
        message(FATAL_ERROR "RapidJSON NOT found")
    endif()
endfunction()
