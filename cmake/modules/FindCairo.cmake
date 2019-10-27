# - Try to find Cairo
# This module defines the following variables:
#
#  CAIRO_FOUND - Cairo was found
#  CAIRO_INCLUDE_DIRS - the Cairo include directories
#  CAIRO_LIBRARIES - link these to use Cairo
#  Cairo::Cairo - imported target
#

find_path(CAIRO_INCLUDE_DIRS
  NAMES cairo.h
  PATH_SUFFIXES cairo
  NO_CMAKE_ENVIRONMENT_PATH
  NO_SYSTEM_ENVIRONMENT_PATH
  NO_CMAKE_SYSTEM_PATH
)

find_library(CAIRO_LIBRARIES
  NAMES cairo cairo-static
  NO_CMAKE_ENVIRONMENT_PATH
  NO_SYSTEM_ENVIRONMENT_PATH
  NO_CMAKE_SYSTEM_PATH
)

if(CAIRO_INCLUDE_DIRS)
  if(EXISTS "${CAIRO_INCLUDE_DIRS}/cairo-version.h")
    file(READ "${CAIRO_INCLUDE_DIRS}/cairo-version.h" CAIRO_VERSION_CONTENT)

    string(REGEX MATCH "#define +CAIRO_VERSION_MAJOR +([0-9]+)" _dummy "${CAIRO_VERSION_CONTENT}")
    set(CAIRO_VERSION_MAJOR "${CMAKE_MATCH_1}")

    string(REGEX MATCH "#define +CAIRO_VERSION_MINOR +([0-9]+)" _dummy "${CAIRO_VERSION_CONTENT}")
    set(CAIRO_VERSION_MINOR "${CMAKE_MATCH_1}")

    string(REGEX MATCH "#define +CAIRO_VERSION_MICRO +([0-9]+)" _dummy "${CAIRO_VERSION_CONTENT}")
    set(CAIRO_VERSION_MICRO "${CMAKE_MATCH_1}")

    set(CAIRO_VERSION "${CAIRO_VERSION_MAJOR}.${CAIRO_VERSION_MINOR}.${CAIRO_VERSION_MICRO}")
  endif ()
endif ()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Cairo
  REQUIRED_VARS
  CAIRO_INCLUDE_DIRS
  CAIRO_LIBRARIES
  VERSION_VAR
  CAIRO_VERSION
)

if(CAIRO_FOUND AND NOT TARGET Cairo::Cairo)
  add_library(Cairo::Cairo UNKNOWN IMPORTED)
  set_target_properties(Cairo::Cairo PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${CAIRO_INCLUDE_DIRS}"
    IMPORTED_LOCATION "${CAIRO_LIBRARIES}"
  )
endif()

mark_as_advanced(
  CAIRO_INCLUDE_DIRS
  CAIRO_LIBRARIES
)
