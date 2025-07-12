cmake_minimum_required(VERSION 2.8.12...3.10)

project(example_pitch_adpcm C)

function(raw2c filename)
	add_custom_command(
		OUTPUT ${filename}.c
		COMMAND "${RAW2C_EXE}" "${CMAKE_CURRENT_SOURCE_DIR}/data/${filename}.dsp"
		DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/data/${filename}.dsp
		VERBATIM
	)
endfunction()

raw2c(C4L)
raw2c(C4R)

add_executable(example_pitch_adpcm 
	${CMAKE_CURRENT_SOURCE_DIR}/src/main.c
	${CMAKE_CURRENT_BINARY_DIR}/C4L.c
	${CMAKE_CURRENT_BINARY_DIR}/C4R.c
)

target_include_directories(example_pitch_adpcm PRIVATE
	${CMAKE_SOURCE_DIR}/include
	${CMAKE_CURRENT_SOURCE_DIR}/include
	${CMAKE_CURRENT_BINARY_DIR}
)

target_link_libraries(example_pitch_adpcm ansnd ogc)

create_dol(example_pitch_adpcm)