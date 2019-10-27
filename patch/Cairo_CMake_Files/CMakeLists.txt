# Copyright (c) 2019, NikitaFeodonit. All rights reserved.
#
## Cairo build file for CMake build tools

# CMake files for Cairo are based on the original Cairo build system
# and on the codes from
#   https://github.com/CMakePorts/cairo
#   https://github.com/mvakulich/cairo
#   https://github.com/solvespace/cairo/tree/1.15.2+cmake


cmake_minimum_required(VERSION 3.0)

project(cairo C)

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")

include(${CMAKE_CURRENT_LIST_DIR}/configure.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/src/CMakeLists.txt)
