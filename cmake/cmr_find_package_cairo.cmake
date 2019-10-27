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

# Part of "LibCMaker/cmake/cmr_find_package.cmake".

  #-----------------------------------------------------------------------
  # Library specific build arguments
  #-----------------------------------------------------------------------

## +++ Common part of the file 'cmr_find_package_<lib_name>' +++
  set(find_LIB_VARS
    COPY_CAIRO_CMAKE_BUILD_SCRIPTS

    LIBCMAKER_ZLIB_SRC_DIR
    LIBCMAKER_LIBPNG_SRC_DIR
    LIBCMAKER_DIRENT_SRC_DIR
    LIBCMAKER_EXPAT_SRC_DIR
    LIBCMAKER_HARFBUZZ_SRC_DIR
    LIBCMAKER_FREETYPE_SRC_DIR
    LIBCMAKER_FONTCONFIG_SRC_DIR
    LIBCMAKER_PIXMAN_SRC_DIR

    CAIRO_DISABLE_ATOMIC
    CAIRO_ENABLE_GCOV
    CAIRO_DISABLE_VALGRIND
    CAIRO_DISABLE_SOME_FLOATING_POINT

    CAIRO_ENABLE_XLIB
    CAIRO_ENABLE_XLIB_XRENDER
    CAIRO_ENABLE_XCB
    CAIRO_ENABLE_XLIB_XCB
    CAIRO_ENABLE_XCB_SHM
    CAIRO_ENABLE_PNG
    CAIRO_ENABLE_SCRIPT
    CAIRO_ENABLE_FT
    CAIRO_ENABLE_FC
    CAIRO_ENABLE_PS
    CAIRO_ENABLE_PDF
    CAIRO_ENABLE_SVG
    CAIRO_ENABLE_TEE
    CAIRO_ENABLE_XML
    CAIRO_ENABLE_PTHREAD

    # TODO: all for Cairo
  )

  foreach(d ${find_LIB_VARS})
    if(DEFINED ${d})
      list(APPEND find_CMAKE_ARGS
        -D${d}=${${d}}
      )
    endif()
  endforeach()
## --- Common part of the file 'cmr_find_package_<lib_name>' ---


  #-----------------------------------------------------------------------
  # Building
  #-----------------------------------------------------------------------

## +++ Common part of the file 'cmr_find_package_<lib_name>' +++
  cmr_lib_cmaker_main(
    LibCMaker_DIR ${find_LibCMaker_DIR}
    NAME          ${find_NAME}
    VERSION       ${find_VERSION}
    LANGUAGES     C
    BASE_DIR      ${find_LIB_DIR}
    DOWNLOAD_DIR  ${cmr_DOWNLOAD_DIR}
    UNPACKED_DIR  ${cmr_UNPACKED_DIR}
    BUILD_DIR     ${lib_BUILD_DIR}
    CMAKE_ARGS    ${find_CMAKE_ARGS}
    INSTALL
  )
## --- Common part of the file 'cmr_find_package_<lib_name>' ---
