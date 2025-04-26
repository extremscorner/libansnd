cmake_minimum_required(VERSION 2.8.12)

project(example_streaming C)

add_custom_command(
	OUTPUT Canon.c
	COMMAND "${RAW2C_EXE}" "${CMAKE_CURRENT_SOURCE_DIR}/data/Canon.ogg"
	DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/data/Canon.ogg
	VERBATIM
)

add_executable(example_streaming 
	${CMAKE_CURRENT_SOURCE_DIR}/src/main.c
	${CMAKE_CURRENT_BINARY_DIR}/Canon.c
)

target_include_directories(example_streaming PRIVATE
	${CMAKE_SOURCE_DIR}/include
	${CMAKE_CURRENT_SOURCE_DIR}/include
	${CMAKE_CURRENT_BINARY_DIR}
	${DEVKITPRO}/portlibs/ppc/include
)

target_link_libraries(example_streaming vorbisidec ogg ansnd ogc)

create_dol(example_streaming)