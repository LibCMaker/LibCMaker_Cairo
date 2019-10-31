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
include(CheckIncludeFile)


function(cairo_check_native_atomic_primitives)
  set(cairo_cv_atomic_primitives "none")


  ac_try_compile(
    [===[
int atomic_add(int i) { return __sync_fetch_and_add (&i, 1); }
int atomic_cmpxchg(int i, int j, int k) { return __sync_val_compare_and_swap (&i, j, k); }
    ]===]
    " "
    _gcc_legacy
  )
  if(_gcc_legacy)
    set(cairo_cv_atomic_primitives "gcc-legacy")
  endif()


  ac_try_compile(
    [===[
int atomic_add(int i) { return __atomic_fetch_add(&i, 1, __ATOMIC_SEQ_CST); }
int atomic_cmpxchg(int i, int j, int k) { return __atomic_compare_exchange_n(&i, &j, k, 0, __ATOMIC_SEQ_CST, __ATOMIC_SEQ_CST); }
    ]===]
    " "
    _cxx11
  )
  if(_cxx11)
    set(cairo_cv_atomic_primitives "cxx11")
  endif()


  if(cairo_cv_atomic_primitives STREQUAL "none")
    check_include_file("atomic_ops.h" HAVE_ATOMIC_OPS_H)
    if(HAVE_ATOMIC_OPS_H)
      set(cairo_cv_atomic_primitives "libatomic-ops")
    endif()
  endif()

  if(cairo_cv_atomic_primitives STREQUAL "none")
    check_include_file("libkern/OSAtomic.h" HAVE_LIBKERN_OSATOMIC_H)
    if(HAVE_LIBKERN_OSATOMIC_H)
      set(cairo_cv_atomic_primitives "OSAtomic")
    endif()
  endif()


  if(cairo_cv_atomic_primitives STREQUAL "cxx11")
    set(HAVE_CXX11_ATOMIC_PRIMITIVES 1 PARENT_SCOPE)
  endif()
  if(cairo_cv_atomic_primitives STREQUAL "gcc-legacy")
    set(HAVE_GCC_LEGACY_ATOMICS 1 PARENT_SCOPE)
  endif()
  if(cairo_cv_atomic_primitives STREQUAL "libatomic-ops")
    set(HAVE_LIB_ATOMIC_OPS 1 PARENT_SCOPE)
  endif()
  if(cairo_cv_atomic_primitives STREQUAL "OSAtomic")
    set(HAVE_OS_ATOMIC_OPS 1 PARENT_SCOPE)
  endif()
endfunction()


function(cairo_check_atomic_op_needs_memory_barrier)
  if(ANDROID)
    # ANDROID_SYSROOT_ABI: arm, arm64, x86, x86_64
    set(host_cpu ${ANDROID_SYSROOT_ABI})
  elseif(IOS)
    # CMAKE_OSX_ARCHITECTURES:
    #   armv7, armv7s, armv7k, arm64, arm64_32, i386, x86_64
    set(host_cpu ${CMAKE_OSX_ARCHITECTURES})
  else()
    # CMAKE_SYSTEM_PROCESSOR:
    #   Intel 32-bit: IA-32, x86, i386, i486, i586, i686.
    #   Intel 64-bit: Intel 64, AMD64, amd64, EM64T, IA-32e, x86_64, x86-64, x64.
    #   TODO: "arm"
    set(host_cpu ${CMAKE_SYSTEM_PROCESSOR})
  endif()

  if(host_cpu STREQUAL "IA-32"
      OR host_cpu STREQUAL "x86" OR host_cpu MATCHES "i?86")
    set(cairo_cv_atomic_op_needs_memory_barrier "yes")
  elseif(host_cpu STREQUAL "Intel 64"
      OR host_cpu STREQUAL "AMD64" OR host_cpu STREQUAL "amd64"
      OR host_cpu STREQUAL "EM64T" OR host_cpu STREQUAL "IA-32e"
      OR host_cpu STREQUAL "x86_64" OR host_cpu STREQUAL "x86-64"
      OR host_cpu STREQUAL "x64")
    set(cairo_cv_atomic_op_needs_memory_barrier "no")
  elseif(host_cpu MATCHES "arm")
    set(cairo_cv_atomic_op_needs_memory_barrier "yes")
  else()
    set(cairo_cv_atomic_op_needs_memory_barrier "yes")
  endif()

  if(cairo_cv_atomic_op_needs_memory_barrier STREQUAL "yes")
    set(ATOMIC_OP_NEEDS_MEMORY_BARRIER 1 PARENT_SCOPE)
  endif()
endfunction()


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


function(check_fontconfig_function_exists name out_var)
  file(WRITE "${PROJECT_BINARY_DIR}/try_compile_${name}.c"
  "
      #include <fontconfig/fontconfig.h>

      int main(int argc, char** argv)
      {
        (void)argv;
        (void)argc;
        ${name}();
        return 0;
      }
  ")

  set(fc_try_compile_LIBS)

  # FontConfig
  list(APPEND fc_try_compile_LIBS Fontconfig::Fontconfig)

  # FreeType
  find_package(Freetype)
  if(FREETYPE_FOUND)
    list(APPEND fc_try_compile_LIBS Freetype::Freetype)
  endif()

  # HarfBuzz
  # From <freetype sources>/docs/CHANGES:
  #  Note that HarfBuzz depends on FreeType.
  find_package(HarfBuzz)
  if(HarfBuzz_FOUND)
    list(APPEND fc_try_compile_LIBS ${HARFBUZZ_LIBRARY} Freetype::Freetype)
    # HarfBuzz is C++ library.
# TODO:
#    set_target_properties(${PROJECT_NAME} PROPERTIES LINKER_LANGUAGE CXX)
  endif()

  # Expat
  find_package(EXPAT REQUIRED)
  if(EXPAT_FOUND)
    list(APPEND fc_try_compile_LIBS ${EXPAT_LIBRARY})
  endif()

  # Android support
  if(ANDROID AND ANDROID_NATIVE_API_LEVEL LESS 21)
    list(APPEND fc_try_compile_LIBS android_support)
  endif()

  try_compile(_${out_var}
    ${PROJECT_BINARY_DIR}/try_compile_${name}
    SOURCES ${PROJECT_BINARY_DIR}/try_compile_${name}.c
    LINK_LIBRARIES ${fc_try_compile_LIBS}
    OUTPUT_VARIABLE build_OUT
  )

  if(_${out_var})
    set(${out_var} 1 PARENT_SCOPE)
    message(STATUS "Looking for ${out_var} - found")
  else()
    message(STATUS "Looking for ${out_var} - not found")
    if(FC_TRY_COMPILE_DEBUG)
      message(STATUS ${build_OUT})
    endif()
  endif()
endfunction()


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
