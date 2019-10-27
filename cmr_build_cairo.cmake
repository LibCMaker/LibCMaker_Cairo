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

#-----------------------------------------------------------------------
# The file is an example of the convenient script for the library build.
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# Lib's name, version, paths
#-----------------------------------------------------------------------

set(CAIRO_lib_NAME      "Cairo")
set(CAIRO_lib_VERSION   "1.17.2")
set(CAIRO_lib_DIR       "${CMAKE_CURRENT_LIST_DIR}")

# To use our Find<LibName>.cmake.
list(APPEND CMAKE_MODULE_PATH "${CAIRO_lib_DIR}/cmake/modules")


#-----------------------------------------------------------------------
# LibCMaker_<LibName> specific vars and options
#-----------------------------------------------------------------------

set(COPY_CAIRO_CMAKE_BUILD_SCRIPTS ON)

# Used in 'cmr_build_rules_cairo.cmake'.
set(LIBCMAKER_ZLIB_SRC_DIR ${ZLIB_lib_DIR})
set(LIBCMAKER_LIBPNG_SRC_DIR ${LIBPNG_lib_DIR})
if(MSVC)
  set(LIBCMAKER_DIRENT_SRC_DIR "${DIRENT_lib_DIR}")
endif()
set(LIBCMAKER_EXPAT_SRC_DIR "${EXPAT_lib_DIR}")
if(FT_WITH_HARFBUZZ)
  set(LIBCMAKER_HARFBUZZ_SRC_DIR "${HB_lib_DIR}")
  # To use our FindHarfBuzz.cmake.
  list(APPEND CMAKE_MODULE_PATH "${LIBCMAKER_HARFBUZZ_SRC_DIR}/cmake/modules")
endif()
set(LIBCMAKER_FREETYPE_SRC_DIR "${FT_lib_DIR}")
set(LIBCMAKER_FONTCONFIG_SRC_DIR ${FONTCONFIG_lib_DIR})
set(LIBCMAKER_PIXMAN_SRC_DIR ${PIXMAN_lib_DIR})


#-----------------------------------------------------------------------
# Library specific vars and options
#-----------------------------------------------------------------------

# TODO: all for Cairo

# TODO:
#option(CAIRO_DISABLE_ATOMIC "disable use of native atomic operations" OFF)
option(CAIRO_DISABLE_ATOMIC "disable use of native atomic operations" ON)
option(CAIRO_ENABLE_GCOV "Enable gcov" OFF)
# TODO:
#option(CAIRO_DISABLE_VALGRIND "Disable valgrind support" OFF)
option(CAIRO_DISABLE_VALGRIND "Disable valgrind support" ON)
option(CAIRO_DISABLE_SOME_FLOATING_POINT
"Disable certain code paths that rely heavily on
double precision floating-point calculation. This
option can improve performance on systems without a
double precision floating-point unit, but might
degrade performance on those that do."
  OFF
)

# TODO:
#set(CAIRO_ENABLE_XLIB "auto" CACHE STRING
#  "[no/auto/yes] Enable cairo's Xlib surface backend feature [default=auto]"
#)
set(CAIRO_ENABLE_XLIB "no" CACHE STRING
  "[no/auto/yes] Enable cairo's Xlib surface backend feature [default=auto]"
)
# TODO:
#set(CAIRO_ENABLE_XLIB_XRENDER "auto" CACHE STRING
#  "[no/auto/yes] Enable cairo's Xlib Xrender surface backend feature [default=auto]"
#)
set(CAIRO_ENABLE_XLIB_XRENDER "no" CACHE STRING
  "[no/auto/yes] Enable cairo's Xlib Xrender surface backend feature [default=auto]"
)
# TODO:
#set(CAIRO_ENABLE_XCB "auto" CACHE STRING
#  "[no/auto/yes] Enable cairo's XCB surface backend feature [default=auto]"
#)
set(CAIRO_ENABLE_XCB "no" CACHE STRING
  "[no/auto/yes] Enable cairo's XCB surface backend feature [default=auto]"
)
set(CAIRO_ENABLE_XLIB_XCB "no" CACHE STRING
  "[no/auto/yes] Enable cairo's Xlib/XCB functions feature [default=no]"
)
# TODO:
#set(CAIRO_ENABLE_XCB_SHM "auto" CACHE STRING
#  "[no/auto/yes] Enable cairo's XCB/SHM functions feature [default=auto]"
#)
set(CAIRO_ENABLE_XCB_SHM "no" CACHE STRING
  "[no/auto/yes] Enable cairo's XCB/SHM functions feature [default=auto]"
)
set(CAIRO_ENABLE_PNG "yes" CACHE STRING
  "[no/auto/yes] Enable cairo's PNG functions feature [default=yes]"
)
set(CAIRO_ENABLE_SCRIPT "yes" CACHE STRING
  "[no/auto/yes] Enable cairo's script surface backend feature [default=yes]"
)
set(CAIRO_ENABLE_FT "auto" CACHE STRING
  "[no/auto/yes] Enable cairo's FreeType font backend feature [default=auto]"
)
set(CAIRO_ENABLE_FC "auto" CACHE STRING
  "[no/auto/yes] Enable cairo's Fontconfig font backend feature [default=auto]"
)
set(CAIRO_ENABLE_PS "yes" CACHE STRING
  "[no/auto/yes] Enable cairo's PostScript surface backend feature [default=yes]"
)
set(CAIRO_ENABLE_PDF "yes" CACHE STRING
  "[no/auto/yes] Enable cairo's PDF surface backend feature [default=yes]"
)
set(CAIRO_ENABLE_SVG "yes" CACHE STRING
  "[no/auto/yes] Enable cairo's SVG surface backend feature [default=yes]"
)
set(CAIRO_ENABLE_TEE "no" CACHE STRING
  "[no/auto/yes] Enable cairo's tee surface backend feature [default=no]"
)
set(CAIRO_ENABLE_XML "no" CACHE STRING
  "[no/auto/yes] Enable cairo's xml surface backend feature [default=no]"
)
set(CAIRO_ENABLE_PTHREAD "auto" CACHE STRING
  "[no/auto/yes] Enable cairo's pthread feature [default=auto]"
)


#-----------------------------------------------------------------------
# Build, install and find the library
#-----------------------------------------------------------------------

cmr_find_package(
  LibCMaker_DIR   ${LibCMaker_DIR}
  NAME            ${CAIRO_lib_NAME}
  VERSION         ${CAIRO_lib_VERSION}
  LIB_DIR         ${CAIRO_lib_DIR}
  REQUIRED
)
