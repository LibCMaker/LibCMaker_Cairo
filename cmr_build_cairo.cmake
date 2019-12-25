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
  set(LIBCMAKER_HARFBUZZ_SRC_DIR "${LibCMaker_LIB_DIR}/LibCMaker_HarfBuzz")
  # To use our FindHarfBuzz.cmake.
  list(APPEND CMAKE_MODULE_PATH "${LIBCMAKER_HARFBUZZ_SRC_DIR}/cmake/modules")
endif()
set(LIBCMAKER_FREETYPE_SRC_DIR "${FT_lib_DIR}")
set(LIBCMAKER_FONTCONFIG_SRC_DIR ${FONTCONFIG_lib_DIR})
set(LIBCMAKER_PIXMAN_SRC_DIR ${PIXMAN_lib_DIR})


#-----------------------------------------------------------------------
# Library specific vars and options
#-----------------------------------------------------------------------

option(CAIRO_ENABLE_GTK_DOC "use gtk-doc to build documentation [[default=no]]" OFF)
option(CAIRO_DISABLE_LARGEFILE "omit support for large files" OFF)
option(CAIRO_DISABLE_ATOMIC "disable use of native atomic operations" OFF)
option(CAIRO_ENABLE_GCOV "Enable gcov" OFF)
option(CAIRO_DISABLE_VALGRIND "Disable valgrind support" OFF)
set(CAIRO_ENABLE_XLIB "no" CACHE STRING
  "[no/auto/yes] Enable cairo's Xlib surface backend feature [default=auto]"
)
set(CAIRO_ENABLE_XLIB_XRENDER "no" CACHE STRING
  "[no/auto/yes] Enable cairo's Xlib Xrender surface backend feature [default=auto]"
)
set(CAIRO_ENABLE_XCB "no" CACHE STRING
  "[no/auto/yes] Enable cairo's XCB surface backend feature [default=auto]"
)
set(CAIRO_ENABLE_XLIB_XCB "no" CACHE STRING
  "[no/auto/yes] Enable cairo's Xlib/XCB functions feature [default=no]"
)
set(CAIRO_ENABLE_XCB_SHM "no" CACHE STRING
  "[no/auto/yes] Enable cairo's XCB/SHM functions feature [default=auto]"
)
set(CAIRO_ENABLE_QT "no" CACHE STRING
  "[no/auto/yes] Enable cairo's Qt surface backend feature [default=no]"
)
set(CAIRO_ENABLE_QUARTZ "no" CACHE STRING
  "[no/auto/yes] Enable cairo's Quartz surface backend feature [default=auto]"
)
set(CAIRO_ENABLE_QUARTZ_FONT "no" CACHE STRING
  "[no/auto/yes] Enable cairo's Quartz font backend feature [default=auto]"
)
set(CAIRO_ENABLE_QUARTZ_IMAGE "no" CACHE STRING
  "[no/auto/yes] Enable cairo's Quartz Image surface backend feature [default=no]"
)
set(CAIRO_ENABLE_WIN32 "no" CACHE STRING
  "[no/auto/yes] Enable cairo's Microsoft Windows surface backend feature [default=auto]"
)
set(CAIRO_ENABLE_WIN32_FONT "no" CACHE STRING
  "[no/auto/yes] Enable cairo's Microsoft Windows font backend feature [default=auto]"
)
set(CAIRO_ENABLE_OS2 "no" CACHE STRING
  "[no/auto/yes] Enable cairo's OS/2 surface backend feature [default=no]"
)
set(CAIRO_ENABLE_BEOS "no" CACHE STRING
  "[no/auto/yes] Enable cairo's BeOS/Zeta surface backend feature [default=no]"
)
set(CAIRO_ENABLE_DRM "no" CACHE STRING
  "[no/auto/yes] Enable cairo's DRM surface backend feature [default=no]"
)
set(CAIRO_ENABLE_GALLIUM "no" CACHE STRING
  "[no/auto/yes] Enable cairo's Gallium3D surface backend feature [default=no]"
)
set(CAIRO_WITH_GALLIUM "TODO" CACHE STRING
  "[/path/to/mesa] directory to find gallium enabled mesa"
)
set(CAIRO_ENABLE_PNG "yes" CACHE STRING
  "[no/auto/yes] Enable cairo's PNG functions feature [default=yes]"
)
set(CAIRO_ENABLE_GL "no" CACHE STRING
  "[no/auto/yes] Enable cairo's OpenGL surface backend feature [default=no]"
)
set(CAIRO_ENABLE_GLESV2 "no" CACHE STRING
  "[no/auto/yes] Enable cairo's OpenGLESv2 surface backend feature [default=no]"
)
set(CAIRO_ENABLE_GLESV3 "no" CACHE STRING
  "[no/auto/yes] Enable cairo's OpenGLESv3 surface backend feature [default=no]"
)
set(CAIRO_ENABLE_COGL "no" CACHE STRING
  "[no/auto/yes] Enable cairo's Cogl surface backend feature [default=no]"
)
set(CAIRO_ENABLE_DIRECTFB "no" CACHE STRING
  "[no/auto/yes] Enable cairo's directfb surface backend feature [default=no]"
)
set(CAIRO_ENABLE_VG "no" CACHE STRING
  "[no/auto/yes] Enable cairo's OpenVG surface backend feature [default=no]"
)
set(CAIRO_ENABLE_EGL "no" CACHE STRING
  "[no/auto/yes] Enable cairo's EGL functions feature [default=auto]"
)
set(CAIRO_ENABLE_GLX "no" CACHE STRING
  "[no/auto/yes] Enable cairo's GLX functions feature [default=auto]"
)
set(CAIRO_ENABLE_WGL "no" CACHE STRING
  "[no/auto/yes] Enable cairo's WGL functions feature [default=auto]"
)
set(CAIRO_ENABLE_SCRIPT "yes" CACHE STRING
  "[no/auto/yes] Enable cairo's script surface backend feature [default=yes]"
)
set(CAIRO_ENABLE_FT "yes" CACHE STRING
  "[no/auto/yes] Enable cairo's FreeType font backend feature [default=auto]"
)
set(CAIRO_ENABLE_FC "yes" CACHE STRING
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
set(CAIRO_ENABLE_TEST_SURFACES "no" CACHE STRING
  "[no/auto/yes] Enable cairo's test surfaces feature [default=no]"
)
set(CAIRO_ENABLE_TEE "no" CACHE STRING
  "[no/auto/yes] Enable cairo's tee surface backend feature [default=no]"
)
set(CAIRO_ENABLE_XML "no" CACHE STRING
  "[no/auto/yes] Enable cairo's xml surface backend feature [default=no]"
)
set(_enable_pthread "yes")
if(MSVC)
  set(_enable_pthread "auto")
endif()
set(CAIRO_ENABLE_PTHREAD ${_enable_pthread} CACHE STRING
  "[no/auto/yes] Enable cairo's pthread feature [default=auto]"
)
set(CAIRO_ENABLE_GOBJECT "no" CACHE STRING
  "[no/auto/yes] Enable cairo's gobject functions feature [default=auto]"
)
option(CAIRO_ENABLE_FULL_TESTING
"Sets the test suite to perform full testing by
default, which will dramatically slow down make
check, but is a *requirement* before release."
  OFF
)
set(CAIRO_ENABLE_TRACE "no" CACHE STRING
  "[no/auto/yes] Enable cairo's cairo-trace feature [default=auto]"
)
set(CAIRO_ENABLE_INTERPRETER "no" CACHE STRING
  "[no/auto/yes] Enable cairo's cairo-script-interpreter feature [default=yes]"
)
set(CAIRO_ENABLE_SYMBOL_LOOKUP "no" CACHE STRING
  "[no/auto/yes] Enable cairo's symbol-lookup feature [default=auto]"
)
option(CAIRO_DISABLE_SOME_FLOATING_POINT
"Disable certain code paths that rely heavily on
double precision floating-point calculation. This
option can improve performance on systems without a
double precision floating-point unit, but might
degrade performance on those that do."
  OFF
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
