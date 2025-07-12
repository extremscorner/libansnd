cmake_minimum_required(VERSION 2.8.12...3.10)

project(example_pitch C)

add_custom_command(
	OUTPUT C4.c
	COMMAND "${RAW2C_EXE}" "${CMAKE_CURRENT_SOURCE_DIR}/data/C4.wav"
	DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/data/C4.wav
	VERBATIM
)

add_executable(example_pitch 
	${CMAKE_CURRENT_SOURCE_DIR}/src/main.c
	${CMAKE_CURRENT_BINARY_DIR}/C4.c
)

target_include_directories(example_pitch PRIVATE
	${CMAKE_SOURCE_DIR}/include
	${CMAKE_CURRENT_SOURCE_DIR}/include
	${CMAKE_CURRENT_BINARY_DIR}
)

target_link_libraries(example_pitch ansnd ogc)

create_dol(example_pitch)