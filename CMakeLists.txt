cmake_minimum_required(VERSION 2.8.12...3.10)

project(libansnd C)

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
	set(CMAKE_INSTALL_PREFIX "${OGC_ROOT}" CACHE PATH "" FORCE)
	set(CMAKE_INSTALL_LIBDIR "lib/${OGC_SUBDIR}" CACHE PATH "" FORCE)
endif()

if (NOT CMAKE_BUILD_TYPE)
	set(CMAKE_BUILD_TYPE "Release")
endif()

message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")

option(BUILD_EXAMPLES "Build example programs" ON)

add_custom_command(
	OUTPUT dspmixer.h
	COMMAND "${GCDSPTOOL_EXE}" -c "${CMAKE_CURRENT_SOURCE_DIR}/src/dspmixer.s" -o "dspmixer.h"
	DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/src/dspmixer.s
	VERBATIM
)

add_library(ansnd STATIC
	${CMAKE_CURRENT_SOURCE_DIR}/src/ansndlib.c
	dspmixer.h
)

target_compile_options(ansnd PRIVATE
	-fno-math-errno
)

target_include_directories(ansnd PRIVATE
	${CMAKE_CURRENT_SOURCE_DIR}/include
	${CMAKE_CURRENT_BINARY_DIR}
)

# check if library is being built as a submodule
string(COMPARE EQUAL "${CMAKE_CURRENT_SOURCE_DIR}" "${CMAKE_SOURCE_DIR}" ANSND_STANDALONE)

if(ANSND_STANDALONE)
	set_target_properties(ansnd
		PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib/
	)

	if (BUILD_EXAMPLES)
		add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/examples)
	endif()
endif()

include(GNUInstallDirs)

install(
	TARGETS ansnd
	ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

install(
	DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/include/
	DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
	FILES_MATCHING
		PATTERN ansndlib.h
)
