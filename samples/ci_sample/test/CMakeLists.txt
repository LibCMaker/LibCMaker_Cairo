# ****************************************************************************
#  Project:  LibCMaker_Cairo
#  Purpose:  A CMake build script for Cairo library
#  Author:   NikitaFeodonit, nfeodonit@yandex.com
# ****************************************************************************
#    Copyright (c) 2017-2020 NikitaFeodonit
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

# Testing with Google Test.
if(BUILD_TESTING)
  cmr_common_sample_test_1st_part()

  target_sources(${test_NAME}
    PRIVATE
      ${test_src_DIR}/snippets.c
      ${test_src_DIR}/snippets.h
      ${test_src_DIR}/example_test.c
      ${test_src_DIR}/example_test.h
      ${test_src_DIR}/example_test_to_gtest.cpp
  )
  set_target_properties(${test_NAME} PROPERTIES
    CXX_STANDARD 11
    C_STANDARD 11
  )

  # Cairo
  target_link_libraries(${test_NAME} PRIVATE Cairo::Cairo)

  # Pixman
  target_link_libraries(${test_NAME} PRIVATE Pixman::Pixman)

  # FontConfig
  target_link_libraries(${test_NAME} PRIVATE Fontconfig::Fontconfig)

  # unistd.h -- only for examles from FontConfig.
  if(MSVC)
    set(unistd_INCLUDE_DIR "${lib_SRC_DIR}/src/msvc")
    target_include_directories(${test_NAME} PRIVATE ${unistd_INCLUDE_DIR})
  endif()

  # FreeType
  target_link_libraries(${test_NAME} PRIVATE Freetype::Freetype)

  # HarfBuzz
  if(FT_WITH_HARFBUZZ)
    target_include_directories(${test_NAME} PRIVATE ${HARFBUZZ_INCLUDE_DIR})
    # From <freetype sources>/docs/CHANGES:
    #  Note that HarfBuzz depends on FreeType.
    target_link_libraries(${test_NAME} PRIVATE
      ${HARFBUZZ_LIBRARY} Freetype::Freetype
    )
    # HarfBuzz is C++ library.
    set_target_properties(${test_NAME} PROPERTIES LINKER_LANGUAGE CXX)
  endif()

  # Expat
  target_include_directories(${test_NAME} PRIVATE ${EXPAT_INCLUDE_DIR})
  target_link_libraries(${test_NAME} PRIVATE ${EXPAT_LIBRARY})

  # Dirent
  if(MSVC)
    target_include_directories(${test_NAME} PRIVATE ${DIRENT_INCLUDE_DIR})
  endif()

  # libpng
  target_link_libraries(${test_NAME} PRIVATE PNG::PNG)

  # zlib
  target_link_libraries(${test_NAME} PRIVATE ZLIB::ZLIB)  # icluded in PNG::PNG

  # Threads, pthread
  if(CMAKE_USE_PTHREADS_INIT)
    target_link_libraries(${test_NAME} PRIVATE Threads::Threads)
  endif()

  if(ANDROID AND ANDROID_NATIVE_API_LEVEL LESS 21)
    target_link_libraries(${test_NAME} PRIVATE android_support)
  endif()

  cmr_common_sample_test_2nd_part()
endif()
