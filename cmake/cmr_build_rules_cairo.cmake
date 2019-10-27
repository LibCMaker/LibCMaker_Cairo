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

# Part of "LibCMaker/cmake/cmr_build_rules.cmake".

  if(NOT LIBCMAKER_ZLIB_SRC_DIR)
    cmr_print_error(
      "Please set LIBCMAKER_ZLIB_SRC_DIR with path to LibCMaker_zlib root.")
  endif()
  cmr_print_value(LIBCMAKER_ZLIB_SRC_DIR)
  # To use our FindZLIB.cmake in Cairo's CMakeLists.txt
  list(APPEND CMAKE_MODULE_PATH "${LIBCMAKER_ZLIB_SRC_DIR}/cmake/modules")

  if(NOT LIBCMAKER_LIBPNG_SRC_DIR)
    cmr_print_error(
      "Please set LIBCMAKER_LIBPNG_SRC_DIR with path to LibCMaker_libpng root.")
  endif()
  cmr_print_value(LIBCMAKER_LIBPNG_SRC_DIR)
  # To use our FindPNG.cmake in Cairo's CMakeLists.txt
  list(APPEND CMAKE_MODULE_PATH "${LIBCMAKER_LIBPNG_SRC_DIR}/cmake/modules")

  if(MSVC)
    if(NOT LIBCMAKER_DIRENT_SRC_DIR)
      cmr_print_error(
        "Please set LIBCMAKER_DIRENT_SRC_DIR with path to LibCMaker_Dirent root.")
    endif()
    cmr_print_value(LIBCMAKER_DIRENT_SRC_DIR)
    # To use our FindDirent.cmake in FontConfig's CMakeLists.txt
    list(APPEND CMAKE_MODULE_PATH "${LIBCMAKER_DIRENT_SRC_DIR}/cmake/modules")
  endif()

  if(NOT LIBCMAKER_EXPAT_SRC_DIR)
    cmr_print_error(
      "Please set LIBCMAKER_EXPAT_SRC_DIR with path to LibCMaker_Expat root.")
  endif()
  cmr_print_value(LIBCMAKER_EXPAT_SRC_DIR)
  # To use our FindEXPAT.cmake in FontConfig's CMakeLists.txt
  list(APPEND CMAKE_MODULE_PATH "${LIBCMAKER_EXPAT_SRC_DIR}/cmake/modules")

  if(WITH_HARFBUZZ)
    if(NOT LIBCMAKER_HARFBUZZ_SRC_DIR)
      cmr_print_error(
        "Please set LIBCMAKER_HARFBUZZ_SRC_DIR with path to LibCMaker_HarfBuzz root.")
    endif()
    cmr_print_value(LIBCMAKER_HARFBUZZ_SRC_DIR)
    # To use our FindHarfBuzz.cmake in FreeType's CMakeLists.txt
    list(APPEND CMAKE_MODULE_PATH "${LIBCMAKER_HARFBUZZ_SRC_DIR}/cmake/modules")

    cmr_print_status(
      "Overwrite FindHarfBuzz.cmake from LibCMaker_HarfBuzz in unpacked sources.")
    execute_process(
      COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${LIBCMAKER_HARFBUZZ_SRC_DIR}/cmake/modules/FindHarfBuzz.cmake
        ${lib_SRC_DIR}/builds/cmake/
    )
  endif()

  if(NOT LIBCMAKER_FREETYPE_SRC_DIR)
    cmr_print_error(
      "Please set LIBCMAKER_FREETYPE_SRC_DIR with path to LibCMaker_FreeType root.")
  endif()
  cmr_print_value(LIBCMAKER_FREETYPE_SRC_DIR)
  # To use our FindFreetype.cmake in Cairo's CMakeLists.txt
  list(APPEND CMAKE_MODULE_PATH "${LIBCMAKER_FREETYPE_SRC_DIR}/cmake/modules")

  if(NOT LIBCMAKER_FONTCONFIG_SRC_DIR)
    cmr_print_error(
      "Please set LIBCMAKER_FONTCONFIG_SRC_DIR with path to LibCMaker_FontConfig root.")
  endif()
  cmr_print_value(LIBCMAKER_FONTCONFIG_SRC_DIR)
  # To use our FindFontconfig.cmake in Cairo's CMakeLists.txt
  list(APPEND CMAKE_MODULE_PATH "${LIBCMAKER_FONTCONFIG_SRC_DIR}/cmake/modules")

  if(NOT LIBCMAKER_PIXMAN_SRC_DIR)
    cmr_print_error(
      "Please set LIBCMAKER_PIXMAN_SRC_DIR with path to LibCMaker_Pixman root.")
  endif()
  cmr_print_value(LIBCMAKER_PIXMAN_SRC_DIR)
  # To use our FindPixman.cmake in Cairo's CMakeLists.txt
  list(APPEND CMAKE_MODULE_PATH "${LIBCMAKER_PIXMAN_SRC_DIR}/cmake/modules")


  # Copy CMake build scripts.
  if(COPY_CAIRO_CMAKE_BUILD_SCRIPTS)
    cmr_print_status("Copy CMake build scripts to unpacked sources.")
    execute_process(
      COMMAND ${CMAKE_COMMAND} -E copy_directory
        ${lib_BASE_DIR}/patch/Cairo_CMake_Files
        ${lib_SRC_DIR}/
    )
  endif()

  # Configure library.
  add_subdirectory(${lib_SRC_DIR} ${lib_VERSION_BUILD_DIR})
