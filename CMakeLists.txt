cmake_minimum_required(VERSION 3.16)

project(
    OpenESL
    VERSION 1.6.0
    LANGUAGES C CXX)

# C++ Standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

#set(BUILD_SHARED_LIBS OFF CACHE BOOL "Build shared libs" FORCE)
#set(CMAKE_POSITION_INDEPENDENT_CODE ON)

set(OPENESL_ENABLE_FEATURES "common4esl;logbook4esl;zsystem4esl;opengtx4esl;curl4esl;mhd4esl;sqlite4esl;odbc4esl" CACHE STRING "List of optional features to build OpenESL library")
set(OPENESL_USE_SYSTEM_LIBS "" CACHE STRING "List of 3rd party libs to use from system")
option(OPENESL_BUILD_ALL_IN_ONE  "Enable to build all sources into one signel library" ON)
option(OPENESL_ENABLE_TEST       "Enable to build and execute unit tests" ON)
option(OPENESL_USE_OFFLINE_LIBS  "Enable to use the pre-downloaded binaries/sources. Disable to download binaries/source code. This only effects to non-sysm-libs"   OFF)

# remaining third party libs:
option(OPENESL_ENABLE_ZLIB         "Add ZLib"                          OFF)
option(OPENESL_ENABLE_IDN2         "Add IDN2"                          OFF)
option(OPENESL_ENABLE_NETTLE       "Add NETTLE"                        OFF)

include(FetchContent)

# Configure some variables for installation pathes, like CMAKE_INSTALL_BINDIR, CMAKE_INSTALL_LIBDIR, ...
# This shoud work for Windows as well. But on Windows DLLs (not .lib) should be put into bin-dir :-/
include(GNUInstallDirs)

# Load helper functions 'configure_package_config_file' and 'write_basic_package_version_file'
include(CMakePackageConfigHelpers)

# Functions to load 3rd party libraries
include(cmake/Packages.cmake)

# validate system libs
foreach(lib ${OPENESL_USE_SYSTEM_LIBS})
	if(NOT lib STREQUAL "" AND
	   NOT lib STREQUAL "GnuTLS" AND
	   NOT lib STREQUAL "libmicrohttpd" AND
	   NOT lib STREQUAL "CURL" AND
	   NOT lib STREQUAL "ODBC" AND
	   NOT lib STREQUAL "SQLite3" AND
	   NOT lib STREQUAL "TinyXML2")
		message(WARNING "OpenESL: Definition of unknown system library '${lib}'.\nPlease check the settings of 'OPENESL_USE_SYSTEM_LIBS'.\n'OPENESL_USE_SYSTEM_LIBS'=${OPENESL_USE_SYSTEM_LIBS}")
	endif()
endforeach()


# validate and update enabled features
#set(OPENESL_ENABLE_FEATURE_LOGBOOK4ESL OFF CACHE BOOL "build logbook4esl enabled" FORCE)
#set(OPENESL_ENABLE_FEATURE_COMMON4ESL  OFF CACHE BOOL "build common4esl enabled"  FORCE)
#set(OPENESL_ENABLE_FEATURE_MHD4ESL     OFF CACHE BOOL "build mhd4esl enabled"     FORCE)
#set(OPENESL_ENABLE_FEATURE_OPENGTX4ESL OFF CACHE BOOL "build opengtx4esl enabled" FORCE)
set(OPENESL_ENABLE_FEATURE_LOGBOOK4ESL OFF)
set(OPENESL_ENABLE_FEATURE_COMMON4ESL  OFF)
set(OPENESL_ENABLE_FEATURE_MHD4ESL     OFF)
set(OPENESL_ENABLE_FEATURE_OPENGTX4ESL OFF)
set(OPENESL_ENABLE_FEATURE_ZSYSTEM4ESL OFF)
set(OPENESL_ENABLE_FEATURE_CURL4ESL    OFF)
set(OPENESL_ENABLE_FEATURE_SQLITE4ESL  OFF)
set(OPENESL_ENABLE_FEATURE_ODBC4ESL    OFF)

foreach(feature ${OPENESL_ENABLE_FEATURES})
	if(feature STREQUAL "")
	elseif(feature STREQUAL "logbook4esl")
		#set(OPENESL_ENABLE_FEATURE_LOGBOOK4ESL ON CACHE BOOL "build ${feature} enabled" FORCE)
		set(OPENESL_ENABLE_FEATURE_LOGBOOK4ESL ON)
		
		# dependencies of logbook4esl:
		# - common4esl
        message(STATUS "OpenESL: implicitly enabling common4esl by ${feature}")
		#set(OPENESL_ENABLE_FEATURE_COMMON4ESL ON CACHE BOOL "build common4esl enabled" FORCE)
		set(OPENESL_ENABLE_FEATURE_COMMON4ESL ON)
	elseif(feature STREQUAL "zsystem4esl")
		#set(OPENESL_ENABLE_FEATURE_ZSYSTEM4ESL ON CACHE BOOL "build ${feature} enabled" FORCE)
		set(OPENESL_ENABLE_FEATURE_ZSYSTEM4ESL ON)
		
		# dependencies of zsystem4esl:
		# - common4esl: esl/system/ZSSignalManager.cpp ->  #include <esl/utility/String.h>
        message(STATUS "OpenESL: implicitly enabling common4esl by ${feature}")
		#set(OPENESL_ENABLE_FEATURE_COMMON4ESL ON CACHE BOOL "build common4esl enabled" FORCE)
		set(OPENESL_ENABLE_FEATURE_COMMON4ESL ON)
	elseif(feature STREQUAL "curl4esl")
		#set(OPENESL_ENABLE_FEATURE_CURL4ESL ON CACHE BOOL "build ${feature} enabled" FORCE)
		set(OPENESL_ENABLE_FEATURE_CURL4ESL ON)
		
		# dependencies of curl4esl:
		# - common4esl
        message(STATUS "OpenESL: implicitly enabling common4esl by ${feature}")
		#set(OPENESL_ENABLE_FEATURE_COMMON4ESL ON CACHE BOOL "build common4esl enabled" FORCE)
		set(OPENESL_ENABLE_FEATURE_COMMON4ESL ON)
	elseif(feature STREQUAL "mhd4esl")
		#set(OPENESL_ENABLE_FEATURE_MHD4ESL ON CACHE BOOL "build ${feature} enabled" FORCE)
		set(OPENESL_ENABLE_FEATURE_MHD4ESL ON)
		
		# dependencies of mhd4esl:
		# - common4esl: esl/com/http/server/MHDSocket.cpp -> #include <esl/utility/String.h>
		# - opengtx4esl
        message(STATUS "OpenESL: implicitly enabling common4esl by ${feature}")
		#set(OPENESL_ENABLE_FEATURE_COMMON4ESL ON CACHE BOOL "build common4esl enabled" FORCE)
		set(OPENESL_ENABLE_FEATURE_COMMON4ESL ON)
        message(STATUS "OpenESL: implicitly enabling opengtx4esl by ${feature}")
		#set(OPENESL_ENABLE_FEATURE_OPENGTX4ESL ON CACHE BOOL "build opengtx4esl enabled" FORCE)
		set(OPENESL_ENABLE_FEATURE_OPENGTX4ESL ON)
	elseif(feature STREQUAL "common4esl")
		set(OPENESL_ENABLE_FEATURE_COMMON4ESL ON)
	elseif(feature STREQUAL "opengtx4esl")
		set(OPENESL_ENABLE_FEATURE_OPENGTX4ESL ON)
	elseif(feature STREQUAL "sqlite4esl")
		set(OPENESL_ENABLE_FEATURE_SQLITE4ESL ON)
	elseif(feature STREQUAL "odbc4esl")
		set(OPENESL_ENABLE_FEATURE_ODBC4ESL ON)
	else()
		message(FATAL_ERROR "OpenESL: Definition of unknown feature '${feature}'. Please check your settings of 'OPENESL_ENABLE_FEATURES'")
	endif()
endforeach()


# thirdparty:
if(OPENESL_ENABLE_ZLIB)
    message(STATUS "OpenESL: ZLib enabled")
#    add_subdirectory(thirdparty/esl_zlib)
endif()

if(OPENESL_ENABLE_IDN2)
    message(STATUS "OpenESL: IDN2 enabled")
#    add_subdirectory(thirdparty/esl_idn2)
endif()

if(OPENESL_ENABLE_NETTLE)
    message(STATUS "OpenESL: NETTLE enabled")
#    add_subdirectory(thirdparty/esl_nettle)
endif()




add_library(OpenESL "")
#add_library(OpenESL STATIC "")


# always add esl
add_subdirectory(esl)


# common4esl:
#if("common4esl" IN_LIST OPENESL_ENABLE_FEATURES)
if(OPENESL_ENABLE_FEATURE_COMMON4ESL)
    message(STATUS "OpenESL: common4esl enabled")
    add_subdirectory(features/common4esl)
endif()

# opengtx4esl:
#if("opengtx4esl" IN_LIST OPENESL_ENABLE_FEATURES)
if(OPENESL_ENABLE_FEATURE_OPENGTX4ESL)
    message(STATUS "OpenESL: opengtx4esl enabled")
    add_subdirectory(features/opengtx4esl)
endif()

# logbook4esl:
#if("logbook4esl" IN_LIST OPENESL_ENABLE_FEATURES)
if(OPENESL_ENABLE_FEATURE_LOGBOOK4ESL)
    message(STATUS "OpenESL: logbook4esl enabled")
    add_subdirectory(features/logbook4esl)
endif()

# mhd4esl:
#if("mhd4esl" IN_LIST OPENESL_ENABLE_FEATURES)
if(OPENESL_ENABLE_FEATURE_MHD4ESL)
    message(STATUS "OpenESL: mhd4esl enabled")
    add_subdirectory(features/mhd4esl)
endif()

# zsystem4esl:
#if("zsystem4esl" IN_LIST OPENESL_ENABLE_FEATURES)
if(OPENESL_ENABLE_FEATURE_ZSYSTEM4ESL)
    message(STATUS "OpenESL: zsystem4esl enabled")
    add_subdirectory(features/zsystem4esl)
endif()

# curl4esl:
#if("curl4esl" IN_LIST OPENESL_ENABLE_FEATURES)
if(OPENESL_ENABLE_FEATURE_CURL4ESL)
    message(STATUS "OpenESL: curl4esl enabled")
    add_subdirectory(features/curl4esl)
endif()

# sqlite4esl:
#if("sqlite4esl" IN_LIST OPENESL_ENABLE_FEATURES)
if(OPENESL_ENABLE_FEATURE_SQLITE4ESL)
    message(STATUS "OpenESL: sqlite4esl enabled")
    add_subdirectory(features/sqlite4esl)
endif()

# odbc4esl:
#if("odbc4esl" IN_LIST OPENESL_ENABLE_FEATURES)
if(OPENESL_ENABLE_FEATURE_ODBC4ESL)
    message(STATUS "OpenESL: odbc4esl enabled")
    add_subdirectory(features/odbc4esl)
endif()


# finally we need to add openesl to glue everthing together
add_subdirectory(openesl)




# Export targets
install(EXPORT OpenESLTargets
    FILE OpenESLTargets.cmake
    NAMESPACE OpenESL::
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/OpenESL
)

# Create config file
configure_package_config_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/OpenESLConfig.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/OpenESLConfig.cmake"
    INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/OpenESL
)

# Create version file
write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/OpenESLConfigVersion.cmake"
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY AnyNewerVersion
)

# Install config file and version file
install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/OpenESLConfig.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/OpenESLConfigVersion.cmake"
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/OpenESL
)
