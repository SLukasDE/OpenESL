cmake_minimum_required(VERSION 3.23)

project(tinyxml2 VERSION 2.0.0
            LANGUAGES CXX)

#include(FetchContent)
#FetchContent_Declare(
#  catch
#  GIT_REPOSITORY https://github.com/catchorg/Catch2.git
#  GIT_TAG        v2.13.6
#)
#FetchContent_MakeAvailable(catch)


# The compiled library code is here
#add_subdirectory(src/main)
# STATIC, SHARED, MODULE, INTERFACE
add_library(tinyxml2 STATIC
        ./src/main/tinyxml2/tinyxml2.cpp
        ./src/main/tinyxml2/tinyxml2.h
)

target_include_directories(tinyxml2 PUBLIC ./src/main)
target_compile_features(tinyxml2 PUBLIC cxx_std_11)
set_property(TARGET tinyxml2 PROPERTY POSITION_INDEPENDENT_CODE ON)

install(TARGETS tinyxml2
        EXPORT tinyxml2-export
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib
)

install(EXPORT      tinyxml2-export
        FILE        tinyxml2Targets.cmake
        NAMESPACE   tinyxml2::
        DESTINATION lib/cmake
)

install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/tinyxml2Config.cmake
        DESTINATION "lib/cmake"
)

