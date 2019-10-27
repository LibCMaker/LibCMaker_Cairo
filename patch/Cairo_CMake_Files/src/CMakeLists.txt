# Copyright (c) 2019, NikitaFeodonit. All rights reserved.
#
## Cairo build file for CMake build tools

# CMake files for Cairo are based on the original Cairo build system
# and on the codes from
#   https://github.com/CMakePorts/cairo
#   https://github.com/mvakulich/cairo
#   https://github.com/solvespace/cairo/tree/1.15.2+cmake


# Note: All source files are listed in CMakeLists.sources.cmake.

include(${CMAKE_CURRENT_LIST_DIR}/CMakeLists.features.cmake)

set(__enabled_cairo_headers)
foreach(src_file IN LISTS enabled_cairo_headers)
  list(APPEND __enabled_cairo_headers "${CMAKE_CURRENT_LIST_DIR}/${src_file}")
endforeach()
set(enabled_cairo_headers ${__enabled_cairo_headers})

set(__enabled_cairo_private)
foreach(src_file IN LISTS enabled_cairo_private)
  list(APPEND __enabled_cairo_private "${CMAKE_CURRENT_LIST_DIR}/${src_file}")
endforeach()
set(enabled_cairo_private ${__enabled_cairo_private})

set(__enabled_cairo_sources)
foreach(src_file IN LISTS enabled_cairo_sources)
  list(APPEND __enabled_cairo_sources "${CMAKE_CURRENT_LIST_DIR}/${src_file}")
endforeach()
set(enabled_cairo_sources ${__enabled_cairo_sources})


if(BUILD_SHARED_LIBS)
  set(CAIRO_TARGET cairo)
else()
  set(CAIRO_TARGET cairo-static)
  #set(STATIC_SOURCES cairo-system.c)
endif()

add_library(${CAIRO_TARGET} "")

target_sources(${CAIRO_TARGET}
  PUBLIC
    ${enabled_cairo_headers}
  PRIVATE
    ${enabled_cairo_private}
    ${enabled_cairo_sources}
    ${STATIC_SOURCES}
)

target_compile_definitions(${CAIRO_TARGET}
  PUBLIC
    ${CAIRO_DEFS}
)

if(NOT BUILD_SHARED_LIBS)
  if(WIN32)
    target_compile_definitions(${CAIRO_TARGET} PUBLIC CAIRO_WIN32_STATIC_BUILD)
  endif()
endif()

target_include_directories(${CAIRO_TARGET}
  PUBLIC
    ${PROJECT_BINARY_DIR}
    ${PROJECT_BINARY_DIR}/src
    ${PROJECT_SOURCE_DIR}/src
    ${CAIRO_INC_DIRS}
)

target_link_libraries(${CAIRO_TARGET}
  PUBLIC
    ${CAIRO_LIBS}
)


include(GNUInstallDirs)

install(TARGETS ${CAIRO_TARGET}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

install(
  FILES
    ${PROJECT_SOURCE_DIR}/cairo-version.h
    ${PROJECT_BINARY_DIR}/config.h
    ${PROJECT_BINARY_DIR}/src/cairo-features.h
    ${enabled_cairo_headers}
  DESTINATION
    ${CMAKE_INSTALL_INCLUDEDIR}/cairo
)
