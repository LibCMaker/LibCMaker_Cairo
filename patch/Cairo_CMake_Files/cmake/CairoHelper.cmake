# Copyright (c) 2019, NikitaFeodonit. All rights reserved.
#
## Cairo build file for CMake build tools

# CMake files for Cairo are based on the original Cairo build system
# and on the codes from
#   https://github.com/CMakePorts/cairo
#   https://github.com/mvakulich/cairo
#   https://github.com/solvespace/cairo/tree/1.15.2+cmake


include(AutoconfHelper)
include(CMakeParseArguments)
include(CheckCSourceCompiles)


# TODO: change to function
macro(check_freetype_struct_has_member struct member out_var)
  file(WRITE "${PROJECT_BINARY_DIR}/try_compile_${struct}_${member}.c"
  "
      #include <ft2build.h>
      #include FT_FREETYPE_H
      #include FT_TRUETYPE_TABLES_H

      int main()
      {
         (void)sizeof(((${struct} *)0)->${member});
         return 0;
      }
  ")
  try_compile(_${out_var}
    ${PROJECT_BINARY_DIR}/try_compile_${struct}_${member}
    SOURCES ${PROJECT_BINARY_DIR}/try_compile_${struct}_${member}.c
    CMAKE_FLAGS "-DINCLUDE_DIRECTORIES=${FREETYPE_INCLUDE_DIRS}"
#    LINK_LIBRARIES ${cxx_std_libs}
    OUTPUT_VARIABLE build_OUT
  )
  if(_${out_var})
    set(${out_var} 1)
    # set(${out_var} 1 PARENT_SCOPE) # PARENT_SCOPE needed for function.
    message(STATUS "Looking for ${out_var} - found")
  else()
    message(STATUS "Looking for ${out_var} - not found")
    if(FC_TRY_COMPILE_DEBUG)
      message(STATUS ${build_OUT})
    endif()
  endif()
endmacro()


# TODO: change to function
macro(check_freetype_symbol_exists name out_var)
  file(WRITE "${PROJECT_BINARY_DIR}/try_compile_${name}.c"
  "
      #include <ft2build.h>
      #include FT_FREETYPE_H
      #include FT_BDF_H
      #include FT_TYPE1_TABLES_H
      #include FT_FONT_FORMATS_H

      int main(int argc, char** argv)
      {
        (void)argv;
      #ifndef ${name}
        return ((int*)(&${name}))[argc];
      #else
        (void)argc;
        return 0;
      #endif
      }
  ")

  try_compile(_${out_var}
    ${PROJECT_BINARY_DIR}/try_compile_${name}
    SOURCES ${PROJECT_BINARY_DIR}/try_compile_${name}.c
#    CMAKE_FLAGS
#      "-DINCLUDE_DIRECTORIES=${FREETYPE_INCLUDE_DIRS}"
##      "-DLINK_DIRECTORIES=${CMAKE_INSTALL_PREFIX}/lib"
    LINK_LIBRARIES Freetype::Freetype
    OUTPUT_VARIABLE build_OUT
  )

  if(_${out_var})
    set(${out_var} 1)
    # set(${out_var} 1 PARENT_SCOPE) # PARENT_SCOPE needed for function.
    message(STATUS "Looking for ${out_var} - found")
  else()
    message(STATUS "Looking for ${out_var} - not found")
    if(FC_TRY_COMPILE_DEBUG)
      message(STATUS ${build_OUT})
    endif()
  endif()
endmacro()


# TODO: change to function
macro(check_freetype_FT_HAS_COLOR out_var)
  file(WRITE "${PROJECT_BINARY_DIR}/try_compile_FT_HAS_COLOR.c"
  "
      #include <ft2build.h>
      #include FT_FREETYPE_H
      #include FT_BDF_H
      #include FT_TYPE1_TABLES_H
      #include FT_FONT_FORMATS_H

      int main(int argc, char** argv)
      {
        (void)argv;
        (void)argc;
        FT_Long has_color = FT_HAS_COLOR( ((FT_Face)NULL) );
        return 0;
      }
  ")

  try_compile(_${out_var}
    ${PROJECT_BINARY_DIR}/try_compile_FT_HAS_COLOR
    SOURCES ${PROJECT_BINARY_DIR}/try_compile_FT_HAS_COLOR.c
#    CMAKE_FLAGS
#      "-DINCLUDE_DIRECTORIES=${FREETYPE_INCLUDE_DIRS}"
##      "-DLINK_DIRECTORIES=${CMAKE_INSTALL_PREFIX}/lib"
    LINK_LIBRARIES Freetype::Freetype
    OUTPUT_VARIABLE build_OUT
  )

  if(_${out_var})
    message(STATUS "Looking for ${out_var} - found")
  else()
    message(STATUS "Looking for ${out_var} - not found")

    set(${out_var} "(0)")
    # set(${out_var} "(0)" PARENT_SCOPE) # PARENT_SCOPE needed for function.

    if(FC_TRY_COMPILE_DEBUG)
      message(STATUS ${build_OUT})
    endif()
  endif()
endmacro()


# Find a -Werror for catching warnings.
function(pixman_check_werror_c_flag)
  set(program_src
    "int main(int argc, char **argv) { (void)argc; (void)argv; return 0; }"
  )

  foreach(FLAG "-Werror" "-errwarn")
    string(REPLACE "-" "_" ESCAPED_FLAG ${FLAG})
    set(CMAKE_REQUIRED_FLAGS ${FLAG})
    check_c_source_compiles("${program_src}" HAS${ESCAPED_FLAG})
    ac_msg_checking("whether the compiler supports ${FLAG}" ${HAS${ESCAPED_FLAG}})
    if(HAS${ESCAPED_FLAG})
      set(PIXMAN_WERROR_C_FLAG "${FLAG}" PARENT_SCOPE)
      break()
    endif()
  endforeach()
endfunction()


# pixman_check_c_flag(flag, [program])
# Adds flag to PIXMAN_C_FLAGS if the given program links
# without warnings or errors.
function(pixman_check_c_flag FLAG)
  set(program_src
    "int main(int argc, char **argv) { (void)argc; (void)argv; return 0; }"
  )
  if(ARGC GREATER 1)
    set(program_src "${ARGV1}\n${program_src}")
  endif()

  string(REPLACE "-" "_" ESCAPED_FLAG ${FLAG})
  string(REPLACE "=" "_" ESCAPED_FLAG ${ESCAPED_FLAG})

  set(CMAKE_REQUIRED_FLAGS "${PIXMAN_WERROR_C_FLAG} ${FLAG}")
  check_c_source_compiles("${program_src}" HAS${ESCAPED_FLAG})
  ac_msg_checking("whether the compiler supports ${FLAG}" ${HAS${ESCAPED_FLAG}})
  if(HAS${ESCAPED_FLAG})
    list(APPEND PIXMAN_C_FLAGS ${FLAG})
    set(PIXMAN_C_FLAGS ${PIXMAN_C_FLAGS} PARENT_SCOPE)
  endif()
endfunction()


function(pixman_check_target_feature SOURCE FLAGS RESULT_VAR DESCRIPTION MESSAGE)
  cmake_parse_arguments("ctf" "" "MSVC" "" ${ARGN})
  # -> ctf_MSVC

  if(DEFINED ${RESULT_VAR})
    # We got a -D${RESULT_VAR}=... on command line; just put it into the cache.
  elseif(MSVC AND DEFINED ctf_MSVC)
    # Win32 has hardcoded default values
    if(${ctf_MSVC})
      set(${RESULT_VAR} ON)
    else()
      set(${RESULT_VAR} OFF)
    endif()
  else()
    # Autodetect the feature (and then put it into cache).
    if(FLAGS MATCHES -x)
      # Only pass -x to compiler, not linker.
      set(CMAKE_REQUIRED_DEFINITIONS "${FLAGS}")
    else()
      set(CMAKE_REQUIRED_FLAGS "${FLAGS}")
    endif()
    check_c_source_compiles("${SOURCE}" ${RESULT_VAR})
  endif()
  if(${RESULT_VAR})
    set(${RESULT_VAR} "1" CACHE STRING ${DESCRIPTION})
  endif()
  ac_msg_checking(${MESSAGE} ${${RESULT_VAR}})
endfunction()
