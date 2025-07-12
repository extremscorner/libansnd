cmake_minimum_required(VERSION 2.8.12...3.10)

project(examples C)

function(create_dol target)
	if (NOT ELF2DOL_EXE)
		message(FATAL_ERROR "Could not find elf2dol: try installing gamecube-tools")
	endif()
	
	add_custom_command(TARGET ${target} POST_BUILD
		COMMAND "${ELF2DOL_EXE}" "$<TARGET_FILE:${target}>" "${CMAKE_BINARY_DIR}/bin/examples/${target}.dol"
		BYPRODUCTS "${target}.dol"
		COMMENT "Converting ${target} to .dol format"
		VERBATIM
		WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/bin/examples
	)
	dkp_set_target_file(${target} "${target}.dol")
endfunction()

find_program(RAW2C_EXE NAMES raw2c HINTS "${DEVKITPRO}/tools/bin")

file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/bin/examples)
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/example_simple_playback)
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/example_simple_looping)
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/example_pitch)
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/example_pitch_adpcm)
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/example_state_callback)

find_library(LIBVORBISIDEC
	NAMES libvorbisidec.a
	NO_PACKAGE_ROOT_PATH
	PATHS ${DEVKITPRO}/portlibs/ppc/lib
)
find_library(LIBOGG
	NAMES libogg.a
	NO_PACKAGE_ROOT_PATH
	PATHS ${DEVKITPRO}/portlibs/ppc/lib
)
if (LIBVORBISIDEC AND LIBOGG)
	add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/example_streaming)
else()
	if (NOT LIBVORBISIDEC)
		message(NOTICE "Could not find libvorbisidec, install it via pacman to compile example_streaming")
	endif()
	if (NOT LIBOGG)
		message(NOTICE "Could not find libogg, install it via pacman to compile example_streaming")
	endif()
endif()