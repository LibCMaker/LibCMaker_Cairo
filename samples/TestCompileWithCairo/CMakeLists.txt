# ****************************************************************************
#  Project:  LibCMaker_Cairo
#  Purpose:  A CMake build script for Cairo library
#  Author:   NikitaFeodonit, nfeodonit@yandex.com
# ****************************************************************************
#    Copyright (c) 2017-2019 NikitaFeodonit
#
#    This file is part of the LibCMaker_Cairo project.
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published
#    by the Free Software Foundation, either version 3 of the License,
#    or (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#    See the GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program. If not, see <http://www.gnu.org/licenses/>.
# ****************************************************************************

cmake_minimum_required(VERSION 3.4)

project(LibCMaker_Cairo_Compile_Test CXX C)

option(CMAKE_VERBOSE_MAKEFILE "CMAKE_VERBOSE_MAKEFILE" OFF)
option(cmr_PRINT_DEBUG "cmr_PRINT_DEBUG" OFF)


#-----------------------------------------------------------------------
# Configure to find_package()
#-----------------------------------------------------------------------

# Set CMake's search path for find_*() commands.
list(APPEND CMAKE_PREFIX_PATH "${CMAKE_INSTALL_PREFIX}")

if(ANDROID OR IOS)
  list(APPEND CMAKE_FIND_ROOT_PATH "${CMAKE_INSTALL_PREFIX}")
endif()


#-----------------------------------------------------------------------
# Set path vars
#-----------------------------------------------------------------------

set(LibCMaker_LIB_DIR "${CMAKE_CURRENT_LIST_DIR}/libs")
set(cmr_INSTALL_DIR "${CMAKE_INSTALL_PREFIX}")

if(NOT cmr_UNPACKED_DIR)
  set(cmr_UNPACKED_DIR "${PROJECT_BINARY_DIR}/download/unpacked")
endif()


#-----------------------------------------------------------------------
# LibCMaker settings
#-----------------------------------------------------------------------

set(LibCMaker_DIR "${LibCMaker_LIB_DIR}/LibCMaker")
list(APPEND CMAKE_MODULE_PATH "${LibCMaker_DIR}/cmake")
include(cmr_find_package)


#-----------------------------------------------------------------------
# Download, configure, build, install and find the required libraries
#-----------------------------------------------------------------------

option(BUILD_TESTING "Build the testing tree." OFF)
if(BUILD_TESTING)
  enable_testing()
  include(${LibCMaker_LIB_DIR}/LibCMaker_GoogleTest/cmr_build_googletest.cmake)
endif()

# Used in Cairo
find_package(Threads)

include(${LibCMaker_LIB_DIR}/LibCMaker_zlib/cmr_build_zlib.cmake)
include(${LibCMaker_LIB_DIR}/LibCMaker_libpng/cmr_build_libpng.cmake)
if(MSVC)
  include(${LibCMaker_LIB_DIR}/LibCMaker_Dirent/cmr_build_dirent.cmake)
endif()
include(${LibCMaker_LIB_DIR}/LibCMaker_Expat/cmr_build_expat.cmake)
if(FT_WITH_HARFBUZZ)
#  include(${LibCMaker_LIB_DIR}/LibCMaker_HarfBuzz/cmr_build_harfbuzz.cmake)
endif()
include(
  ${LibCMaker_LIB_DIR}/LibCMaker_FreeType/cmr_build_freetype_with_harfbuzz.cmake
)
include(${LibCMaker_LIB_DIR}/LibCMaker_FontConfig/cmr_build_fontconfig.cmake)

include(${LibCMaker_LIB_DIR}/LibCMaker_Pixman/cmr_build_pixman.cmake)
include(${LibCMaker_LIB_DIR}/LibCMaker_Cairo/cmr_build_cairo.cmake)


#-----------------------------------------------------------------------
# Build the executable of the example
#-----------------------------------------------------------------------

set(example_src_DIR "${CMAKE_CURRENT_LIST_DIR}/src")

add_executable(${PROJECT_NAME}
  ${example_src_DIR}/snippets.c
  ${example_src_DIR}/snippets.h
  ${example_src_DIR}/cairo_snippets_png.c
#  ${example_src_DIR}/cairo_snippets_pdf.c
#  ${example_src_DIR}/cairo_snippets_ps.c
)
set_property(TARGET ${PROJECT_NAME} PROPERTY C_STANDARD 11)
if(NOT MINGW AND NOT ANDROID AND NOT IOS
    AND NOT (APPLE AND CMAKE_GENERATOR MATCHES "Unix Makefiles"))
  set_target_properties(${PROJECT_NAME} PROPERTIES
    # Link all libraries into the target so as not to use LD_LIBRARY_PATH.
    LINK_WHAT_YOU_USE ON
  )
endif()


#-----------------------------------------------------------------------
# Link to the libraries
#-----------------------------------------------------------------------

# Cairo
target_link_libraries(${PROJECT_NAME} PRIVATE Cairo::Cairo)

# Pixman
target_link_libraries(${PROJECT_NAME} PRIVATE Pixman::Pixman)

# FontConfig
target_link_libraries(${PROJECT_NAME} PRIVATE Fontconfig::Fontconfig)

# unistd.h -- only for examles from FontConfig.
if(MSVC)
  set(unistd_INCLUDE_DIR "${lib_SRC_DIR}/src/msvc")
  target_include_directories(${PROJECT_NAME} PRIVATE ${unistd_INCLUDE_DIR})
endif()

# FreeType
target_link_libraries(${PROJECT_NAME} PRIVATE Freetype::Freetype)

# HarfBuzz
if(FT_WITH_HARFBUZZ)
  target_include_directories(${PROJECT_NAME} PRIVATE ${HARFBUZZ_INCLUDE_DIR})
  # From <freetype sources>/docs/CHANGES:
  #  Note that HarfBuzz depends on FreeType.
  target_link_libraries(${PROJECT_NAME} PRIVATE
    ${HARFBUZZ_LIBRARY} Freetype::Freetype
  )
  # HarfBuzz is C++ library.
  set_target_properties(${PROJECT_NAME} PROPERTIES LINKER_LANGUAGE CXX)
endif()

# Expat
target_include_directories(${PROJECT_NAME} PRIVATE ${EXPAT_INCLUDE_DIR})
target_link_libraries(${PROJECT_NAME} PRIVATE ${EXPAT_LIBRARY})

# Dirent
if(MSVC)
  target_include_directories(${PROJECT_NAME} PRIVATE ${DIRENT_INCLUDE_DIR})
endif()

# libpng
target_link_libraries(${PROJECT_NAME} PRIVATE PNG::PNG)

# zlib
target_link_libraries(${PROJECT_NAME} PRIVATE ZLIB::ZLIB)  # icluded in PNG::PNG

# Threads, pthread
if(CMAKE_USE_PTHREADS_INIT)
  target_link_libraries(${PROJECT_NAME} PRIVATE Threads::Threads)
endif()

if(ANDROID AND ANDROID_NATIVE_API_LEVEL LESS 21)
  target_link_libraries(${PROJECT_NAME} PRIVATE android_support)
endif()


#-----------------------------------------------------------------------
# Testing
#-----------------------------------------------------------------------

set(test_src_DIR "${CMAKE_CURRENT_LIST_DIR}/src")
add_subdirectory(test)
