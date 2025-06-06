file(GLOB_RECURSE OPENESL_MAIN_SRC ${CMAKE_CURRENT_SOURCE_DIR}/*.cpp)
file(GLOB_RECURSE OPENESL_MAIN_INC ${CMAKE_CURRENT_SOURCE_DIR}/*.h ${CMAKE_CURRENT_SOURCE_DIR}/*.hpp)
set(OPENESL_MAIN_INC_DIRS  ${CMAKE_CURRENT_SOURCE_DIR})


if(ALL_IN_ONE_ESL)
    list(APPEND OPENESL_MAIN_SRC ${ALL_ESL_MAIN_SRC})
    list(APPEND OPENESL_MAIN_INC ${ALL_ESL_MAIN_INC})
    list(APPEND OPENESL_MAIN_INC_DIRS ${ALL_ESL_MAIN_INC_DIRS})
endif(ALL_IN_ONE_ESL)


if(MSVC)
   	set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
endif()

if(OPENESL_MAIN_SRC)
    if (BUILD_SHARED_LIBS)
        message(STATUS "-> lib type is SHARED")
        add_library(${PROJECT_NAME} SHARED)
    else (BUILD_SHARED_LIBS)
       	message(STATUS "-> lib type is STATIC")
   	    add_library(${PROJECT_NAME} STATIC)
    endif (BUILD_SHARED_LIBS)
    target_sources(${PROJECT_NAME} PRIVATE ${OPENESL_MAIN_SRC})
else(OPENESL_MAIN_SRC)
    if (BUILD_SHARED_LIBS)
       	message(STATUS "-> lib type is INTERFACE (but SHARED has been requested)")
    else (BUILD_SHARED_LIBS)
       	message(STATUS "-> lib type is INTERFACE")
   	endif (BUILD_SHARED_LIBS)
   	add_library(${PROJECT_NAME} INTERFACE)
endif(OPENESL_MAIN_SRC)
	
configure_file(openesl/Config.hpp.in ${CMAKE_BINARY_DIR}/configured_files/openesl/Config.hpp ESCAPE_QUOTES)
target_include_directories(${PROJECT_NAME} PRIVATE ${CMAKE_BINARY_DIR}/configured_files/ )

target_sources(${PROJECT_NAME} PUBLIC FILE_SET HEADERS BASE_DIRS ${OPENESL_MAIN_INC_DIRS} FILES ${OPENESL_MAIN_INC})

add_library(${PROJECT_NAME}::${PROJECT_NAME} ALIAS ${PROJECT_NAME})

message(STATUS "ALL_ESL_MAIN_LIBS: ${ALL_ESL_MAIN_LIBS}")
target_link_libraries(${PROJECT_NAME} PUBLIC ${ALL_ESL_MAIN_LIBS})


install(TARGETS ${PROJECT_NAME}
    EXPORT ${PROJECT_NAME}Targets
    FILE_SET HEADERS
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
    INCLUDES DESTINATION include)
