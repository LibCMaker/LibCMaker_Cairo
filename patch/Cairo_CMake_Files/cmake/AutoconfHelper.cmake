# Copyright (c) 2019, NikitaFeodonit. All rights reserved.
#
## Helper functions for translating autoconf projects to CMake

# The main idea and part of the source codes are from
# https://github.com/tomhughes/libdwarf/blob/master/cmake/AutoconfHelper.cmake

# Helper functions for translating autoconf projects.
# Several functions are lifted from the Mono sources.

include(CheckCSourceCompiles)  # check_c_source_compiles()
include(CheckCSourceRuns)      # check_c_source_runs()
include(CheckIncludeFile)      # check_include_file()
include(CheckIncludeFiles)     # check_include_files()
include(CheckSymbolExists)     # check_symbol_exists()
include(CheckTypeSize)         # check_type_size()
include(TestBigEndian)         # test_big_endian()


# Deliver the message to the user.
function(ac_msg_notice message)
  message(STATUS "${message}")
endfunction()


# Notify the user of an error that prevents configure from completing.
function(ac_msg_error error_description)
  if(ANDROID)
    # Duplicate a message to build with Gradle and CMake in server mode.
    message(STATUS "ERROR: ${error_description}")
  endif()
  message(FATAL_ERROR "${error_description}")
endfunction()


# Notify the user that configure is checking for a particular feature.
function(ac_msg_checking feature_description)
  if(ARGC GREATER 1)
    set(var ${ARGV1})
  endif()
  if(var)
    set(res "yes")
  else()
    set(res "no")
  endif()
  message(STATUS "Checking ${feature_description} ... ${res}")
endfunction()


# AC_INIT (package, version, [bug-report], [tarname], [url])
function(ac_init package, version)
  if(ARGC GREATER 2)
    set(bug_report ${ARGV2})
  endif()
  if(ARGC GREATER 3)
    set(tarname ${ARGV3})
  endif()
  if(ARGC GREATER 4)
    set(url ${ARGV4})
  endif()

  set(PACKAGE_NAME "\"${package}\"" PARENT_SCOPE)
  set(PACKAGE_VERSION "\"${version}\"" PARENT_SCOPE)
  set(VERSION "\"${version}\"" PARENT_SCOPE)
  if(version)
    set(PACKAGE_STRING "\"${package} ${version}\"" PARENT_SCOPE)
  else()
    set(PACKAGE_STRING "\"${package}\"" PARENT_SCOPE)
  endif()

  if(bug_report)
    set(PACKAGE_BUGREPORT "\"${bug_report}\"" PARENT_SCOPE)
  endif()

  if(NOT tarname)
    string(REGEX REPLACE "[^a-zA-Z0-9_]" "-" tarname "${package}")
  endif()
  set(PACKAGE_TARNAME "\"${tarname}\"" PARENT_SCOPE)

  if(url)
    set(PACKAGE_URL "\"${url}\"" PARENT_SCOPE)
  endif()
endfunction()


# Check if a symbol exists as a function, variable, or macro in C
# and defines the VARIABLE to 1 if exists.
function(ac_check_symbol SYMBOL FILES VARIABLE)
  unset(acs_var CACHE)
  check_symbol_exists("${SYMBOL}" "${FILES}" acs_var)
  if(acs_var)
    set(${VARIABLE} "1" PARENT_SCOPE)
  endif()
  ac_msg_checking("for ${SYMBOL}" ${acs_var})
  unset(acs_var CACHE)
endfunction()

#check_symbol_exists  (FE_DIVBYZERO fenv.h HAVE_FEDIVBYZERO)

function(ac_check_header HEADER VARIABLE)
  unset(ach_var CACHE)
  check_include_file(${HEADER} ach_var)
  if(ach_var)
    set(${VARIABLE} "1" PARENT_SCOPE)
  endif()
  ac_msg_checking("for ${HEADER}" ${ach_var})
  unset(ach_var CACHE)
endfunction()


function(ac_check_headers HEADERS VARIABLE)
  unset(achs_var CACHE)
  check_include_files("${HEADER}" achs_var)
  if(achs_var)
    set(${VARIABLE} "1" PARENT_SCOPE)
  endif()
  ac_msg_checking("for ${HEADERS}" ${achs_var})
  unset(achs_var CACHE)
endfunction()


# Check if function func exists in library lib
function(ac_check_lib LIB FUNC FILES VARIABLE)
  unset(acl_var CACHE)
  set(CMAKE_REQUIRED_LIBRARIES ${LIB})
  check_symbol_exists(${FUNC} "${FILES}" acl_var)
  if(acl_var)
    set(${VARIABLE} "1" PARENT_SCOPE)
  endif()
  ac_msg_checking("for function ${FUNC} in library ${LIB}" ${acl_var})
  unset(acl_var CACHE)
endfunction()


function(ac_search_libs FUNC LIBS FILES VARIABLE)
  unset(asls_var CACHE)
  check_symbol_exists(${FUNC} "${FILES}" asls_var)
  if(asls_var)
    set(${VARIABLE} "1" PARENT_SCOPE)
  else()
    foreach(lib IN LISTS ${LIBS})
      unset(asls_var CACHE)
      set(CMAKE_REQUIRED_LIBRARIES ${lib})
      check_symbol_exists(${FUNC} "${FILES}" asls_var)
      if(asls_var)
        set(${VARIABLE} "1" PARENT_SCOPE)
        break()
      endif()
    endforeach()
  endif()
  ac_msg_checking("for function ${FUNC} in libraries ${LIBS}" ${asls_var})
  unset(asls_var CACHE)
endfunction()


# If words are stored with the most significant byte first (like Motorola
# and SPARC CPUs), defines the variable WORDS_BIGENDIAN to 1.
# If words are stored with the least significant byte first (like Intel
# and VAX CPUs), do nothing.
function(ac_c_bigendian)
  test_big_endian(HOST_BIGENDIAN)
  if(HOST_BIGENDIAN)
    set(WORDS_BIGENDIAN "1" PARENT_SCOPE)
  endif()
  ac_msg_checking("for bigendian" ${WORDS_BIGENDIAN})
endfunction()


# If the C compiler supports the keyword inline, do nothing.
# Otherwise define inline to __inline__ or __inline if it accepts one of those,
# otherwise define inline to be empty.
function(ac_c_inline)
  foreach(keyword inline __inline__ __inline)
    set(CMAKE_REQUIRED_DEFINITIONS "-Dinline=${keyword}")
    check_c_source_compiles(
"static inline void x(){}
int main(int argc, char **argv) { (void)argc; (void)argv; return 0; }"
      USE_INLINE_${keyword}
    )
    if(USE_INLINE_${keyword})
      set(USE_INLINE ${keyword})
      break()
    endif()
  endforeach()

  if(NOT USE_INLINE)
    set(inline " " PARENT_SCOPE)  # TODO: check if empty string
  elseif(NOT USE_INLINE STREQUAL "inline")
    set(inline ${USE_INLINE} PARENT_SCOPE)
  endif()
endfunction()


# Obtain size of an 'type' and define as SIZEOF_TYPE
function(ac_check_sizeof typename)
  string(TOUPPER "SIZEOF_${typename}" varname)
  string(REPLACE " " "_" varname "${varname}")
  string(REPLACE "*" "p" varname "${varname}")
  check_type_size("${typename}" ${varname} BUILTIN_TYPES_ONLY)
  if(NOT ${varname})
    set(${varname} 0 PARENT_SCOPE)
  endif()
endfunction()


# Also from the mono sources, kind of implements AC_SYS_LARGEFILE
function(ac_sys_largefile)
  option(AC_DISABLE_LARGEFILE "omit support for large files" OFF)
  if(AC_DISABLE_LARGEFILE)
    return()
  endif()

  check_c_source_runs("
#include <sys/types.h>
#define BIG_OFF_T (((off_t)1<<62)-1+((off_t)1<<62))
int main (int argc, char **argv) {
    int big_off_t=((BIG_OFF_T%2147483629==721) &&
                   (BIG_OFF_T%2147483647==1));
    return big_off ? 0 : 1;
}
" HAVE_LARGE_FILE_SUPPORT
)

# Check if it makes sense to define _LARGE_FILES or _FILE_OFFSET_BITS
  if(HAVE_LARGE_FILE_SUPPORT)
    return()
  endif()

  set(_LARGE_FILE_EXTRA_SRC "
#include <sys/types.h>
int main (int argc, char **argv) {
  return sizeof(off_t) == 8 ? 0 : 1;
}
")
  check_c_source_runs("#define _LARGE_FILES\n${_LARGE_FILE_EXTRA_SRC}"
    HAVE_USEFUL_D_LARGE_FILES
  )
  if(NOT HAVE_USEFUL_D_LARGE_FILES)
    if(NOT DEFINED HAVE_USEFUL_D_FILE_OFFSET_BITS)
      set(SHOW_LARGE_FILE_WARNING TRUE)
    endif()
    check_c_source_runs("#define _FILE_OFFSET_BITS 64\n${_LARGE_FILE_EXTRA_SRC}"
      HAVE_USEFUL_D_FILE_OFFSET_BITS
    )
    if(HAVE_USEFUL_D_FILE_OFFSET_BITS)
      set(_FILE_OFFSET_BITS 64 PARENT_SCOPE)
    elseif(SHOW_LARGE_FILE_WARNING)
      message(WARNING "No 64 bit file support through off_t available.")
    endif()
  else()
    set(_LARGE_FILES 1 PARENT_SCOPE)
  endif()
endfunction()


function(ac_try_compile includes function_body out_var)
  set(tc_bin_dir "${PROJECT_BINARY_DIR}/try_compile_${out_var}")
  set(c_file "${PROJECT_BINARY_DIR}/try_compile_${out_var}.c")
  file(WRITE ${c_file}
  "
      ${includes}
      int main(int argc, char** argv)
      {
        (void)argv;
        (void)argc;
        ${function_body}
        return 0;
      }
  ")

  try_compile(_${out_var}
    ${tc_bin_dir}
    SOURCES ${c_file}
    OUTPUT_VARIABLE build_OUT
  )

  if(_${out_var})
    set(${out_var} 1 PARENT_SCOPE)
    message(STATUS "Looking for ${out_var} - found")
  else()
    message(STATUS "Looking for ${out_var} - not found")
    if(AC_TRY_COMPILE_DEBUG)
      message(STATUS ${build_OUT})
    endif()
  endif()
endfunction()



# ========================================================================
# Below codes are not used in Cairo and are from
# https://github.com/tomhughes/libdwarf/blob/master/cmake/AutoconfHelper.cmake
#


# Function to get the version information from the configure.ac file in the
# current directory. Its argument is the name of the library as passed to
# AC_INIT. It will set the variables ${LIBNAME}_VERSION and ${LIBNAME}_SOVERSION
function(ac_get_version libname)
  string(TOUPPER "${libname}" libname_upper)

  # Read the relevant content from configure.ac
  file(STRINGS configure.ac tmp_configure_ac
    REGEX "${libname_upper}_[_A-Z]+=[ \\t]*[0-9]+"
  )

  # Product version
  string(REGEX REPLACE
    ".+MAJOR[_A-Z]+=([0-9]+).+MINOR[_A-Z]+=([0-9]+).+MICRO[_A-Z]+=([0-9]+).*"
    "\\1.\\2.\\3" ${libname_upper}_VERSION "${tmp_configure_ac}"
  )

  # Library version for libtool
  string(REGEX REPLACE ".+CURRENT=([0-9]+).+REVISION=([0-9]+).+AGE=([0-9]+).*"
    "\\1.\\2.\\3" ${libname_upper}_SOVERSION "${tmp_configure_ac}"
  )

  # Checks if the string needs to be displayed
  set(${libname_upper}_DISPLAYSTR_AUX
    "Found ${libname} version ${${libname_upper}_VERSION}, soversion ${${libname_upper}_SOVERSION} from configure.ac"
  )
  if((NOT ${libname_upper}_DISPLAYSTR)
      OR (NOT ${libname_upper}_DISPLAYSTR
          STREQUAL ${libname_upper}_DISPLAYSTR_AUX))
    set(${libname_upper}_DISPLAYSTR ${${libname_upper}_DISPLAYSTR_AUX}
      CACHE INTERNAL "Version string from ${libname}" FORCE
    )
    message(STATUS ${${libname_upper}_DISPLAYSTR})
  endif()

  # Export the result to the caller
  set(${libname_upper}_VERSION "${${libname_upper}_VERSION}" PARENT_SCOPE)
  set(${libname_upper}_SOVERSION "${${libname_upper}_SOVERSION}" PARENT_SCOPE)
endfunction()


# Also from mono's source code
# Implementation of AC_CHECK_HEADERS
# In addition, it also records the list of variables in the variable
# 'autoheader_vars', and for each variable, a documentation string in the
# variable ${var}_doc
#function(ac_check_headers)
#  foreach(header ${ARGV})
#    string(TOUPPER ${header} header_var)
#    string(REPLACE "." "_" header_var ${header_var})
#    string(REPLACE "/" "_" header_var ${header_var})
#    set(header_var "HAVE_${header_var}")
#    check_include_file(${header} ${header_var})
#    set("${header_var}_doc"
#      "Define to 1 if you have the <${header}> header file." PARENT_SCOPE
#    )
#    if(${header_var})
#      set("${header_var}_defined" "1" PARENT_SCOPE)
#    endif()
#    set("${header_var}_val" "1" PARENT_SCOPE)
#    set(autoheader_vars ${autoheader_vars} ${header_var})
#  endforeach()
#  set(autoheader_vars ${autoheader_vars} PARENT_SCOPE)
#endfunction()


# Specifically, this macro checks for stdlib.h', stdarg.h',
# string.h', and float.h'; if the system has those, it probably
# has the rest of the ANSI C header files.  This macro also checks
# whether string.h' declares memchr' (and thus presumably the
# other mem' functions), whether stdlib.h' declare free' (and
# thus presumably malloc' and other related functions), and whether
# the ctype.h' macros work on characters with the high bit set, as
# ANSI C requires.
function(ac_header_stdc)
  if(STDC_HEADERS)
    return()
  endif()
  message(STATUS "Looking for ANSI-C headers")
  set(code "
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <float.h>

int main(int argc, char **argv)
{
  void *ptr;
  free((void*)1);
  ptr = memchr((void*)1, 0, 0);

  return (int)ptr;
}
")
  # FIXME Check the ctype.h high bit
  check_c_source_compiles("${code}" STDC_HEADERS)
  if(STDC_HEADERS)
    set(STDC_HEADERS 1 PARENT_SCOPE)
    message(STATUS "Looking for ANSI-C headers - found")
  else()
    message(STATUS "Looking for ANSI-C headers - not found")
  endif()
endfunction()


# Checks for the const keyword, defining "HAS_CONST_SUPPORT"
# If it does not have support, defines "const" to 0 in the parent scope
function(ac_c_const)
  check_c_source_compiles(
    "int main(int argc, char **argv){const int r = 0;return r;}"
    HAS_CONST_SUPPORT
  )
  if(NOT HAS_CONST_SUPPORT)
    set(const 0 PARENT_SCOPE)
  endif()
endfunction()


# Test if you can safely include both <sys/time.h> and <time.h>
function(ac_header_time)
  check_c_source_compiles(
    "#include <sys/time.h>\n#include <time.h>\nint main(int argc, char **argv) { return 0; }"
    TIME_WITH_SYS_TIME
  )
  set(TIME_WITH_SYS_TIME ${TIME_WITH_SYS_TIME} PARENT_SCOPE)
endfunction()


# Check for off_t, setting "off_t" in the parent scope
function(ac_type_off_t)
  check_type_size("off_t" SIZEOF_OFF_T)
  if(NOT SIZEOF_OFF_T)
    set(off_t "long int")
  endif()
  set(off_t ${off_t} PARENT_SCOPE)
endfunction()


# Check for size_t, setting "size_t" in the parent scope
function(ac_type_size_t)
  check_type_size("size_t" SIZEOF_SIZE_T)
  if(NOT SIZEOF_SIZE_T)
    set(size_t "unsigned int")
  endif()
  set(size_t ${size_t} PARENT_SCOPE)
endfunction()


# Define "TM_IN_SYS_TIME" to 1 if <sys/time.h> declares "struct tm"
function(ac_struct_tm)
  check_c_source_compiles(
    "#include <sys/time.h>\nint main(int argc, char **argv) { struct tm x; return 0; }"
    TM_IN_SYS_TIME
  )
  if(TM_IN_SYS_TIME)
    set(TM_IN_SYS_TIME 1 PARENT_SCOPE)
  endif()
endfunction()


# Check if the type exists, defines HAVE_<type>
function (ac_check_type typename)
  string(TOUPPER "${typename}" varname)
  string(REPLACE " " "_" varname "${varname}")
  string(REPLACE "*" "p" varname "${varname}")
  check_type_size("${typename}" ${varname})
  if(NOT "${varname}" STREQUAL "")
    set("HAVE_${varname}" 1 PARENT_SCOPE)
    set("${varname}" "${typename}" PARENT_SCOPE)
  else()
    set("${varname}" "unknown" PARENT_SCOPE)
  endif()
endfunction()


# Verifies if each type on the list exists, using the given prelude
function(ac_check_types type_list prelude)
  foreach(typename ${type_list})
    string(TOUPPER "HAVE_${typename}" varname)
    string(REPLACE " " "_" varname "${varname}")
    string(REPLACE "*" "p" varname "${varname}")
    check_c_source_compiles("${prelude}\n ${typename} foo;" ${varname})
  endforeach()
endfunction()


function(ac_path_prog variable prog_to_check_for value_if_not_found env_var)
  find_program(${variable}
    NAMES ${prog_to_check_for}
    PATHS ENV ${env_var}
    NO_DEFAULT_PATH
  )
  if(NOT ${variable})
    message(STATUS "Looking for ${prog_to_check_for} - not found")
    set(${variable} ${value_if_not_fount} PARENT_SCOPE)
  else()
    message(STATUS "Looking for ${prog_to_check_for} - ${variable}")
    set(${variable} ${${variable}} PARENT_SCOPE)
  endif()
endfunction()


# check if source compiles without linking
function(ac_try_compile SOURCE VAR)
  set(CMAKE_TMP_DIR ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp)
  if(NOT DEFINED "${VAR}")
    file(WRITE
      "${CMAKE_TMP_DIR}/src.c"
      "${SOURCE}\n"
    )

    if(NOT CMAKE_REQUIRED_QUIET)
      message(STATUS "Performing Test ${VAR}")
    endif()
    # Set up CMakeLists.txt for static library:
    file(WRITE
      ${CMAKE_TMP_DIR}/CMakeLists.txt
      "add_library(compile STATIC src.c)"
    )

    # Configure:
    execute_process(
      COMMAND ${CMAKE_COMMAND} -G "${CMAKE_GENERATOR}" .
      WORKING_DIRECTORY ${CMAKE_TMP_DIR}
    )

    # Build:
    execute_process(
      COMMAND ${CMAKE_COMMAND} --build ${CMAKE_TMP_DIR}
      RESULT_VARIABLE RESVAR
      OUTPUT_VARIABLE OUTPUT
      ERROR_VARIABLE OUTPUT
    )

    # Set up result:
    if(RESVAR EQUAL 0)
      set(${VAR} 1 CACHE INTERNAL "Test ${VAR}")
      if(NOT CMAKE_REQUIRED_QUIET)
        message(STATUS "Performing Test ${VAR} - Success")
      endif()

      file(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeOutput.log
        "Performing C SOURCE FILE Test ${VAR} succeded with the following output:\n"
        "${OUTPUT}\n"
        "Source file was:\n${SOURCE}\n"
      )
    else()
      if(NOT CMAKE_REQUIRED_QUIET)
        message(STATUS "Performing Test ${VAR} - Failed")
      endif()
      set(${VAR} "" CACHE INTERNAL "Test ${VAR}")
      file(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeError.log
        "Performing C SOURCE FILE Test ${VAR} failed with the following output:\n"
        "${OUTPUT}\n"
        "Source file was:\n${SOURCE}\n"
      )
    endif()
  endif()
endfunction()
