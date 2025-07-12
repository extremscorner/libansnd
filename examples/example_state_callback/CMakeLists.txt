cmake_minimum_required(VERSION 2.8.12...3.10)

project(example_state_callback C)

add_executable(example_state_callback 
	${CMAKE_CURRENT_SOURCE_DIR}/src/main.c
)

target_include_directories(example_state_callback PRIVATE
	${CMAKE_SOURCE_DIR}/include
	${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_link_libraries(example_state_callback ansnd ogc)

create_dol(example_state_callback)