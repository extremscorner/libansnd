cmake_minimum_required(VERSION 2.8.12...3.10)

project(example_simple_playback C)

add_executable(example_simple_playback 
	${CMAKE_CURRENT_SOURCE_DIR}/src/main.c
)

target_include_directories(example_simple_playback PRIVATE
	${CMAKE_SOURCE_DIR}/include
	${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_link_libraries(example_simple_playback ansnd ogc)

create_dol(example_simple_playback)