# Downloaded from https://panthema.net/2012/1119-eSAIS-Inducing-Suffix-and-LCP-Arrays-in-External-Memory/eSAIS-DC3-LCP-0.5.4/stxxl/misc/cmake/TestLargeFiles.cmake.html

# That project's license is Boost Software License, Version 1.0.

# - Define macro to check large file support
#
#  TEST_LARGE_FILES(VARIABLE)
#
#  VARIABLE will be set to true if off_t is 64 bits, and fseeko/ftello present.
#  This macro will also set defines necessary enable large file support, for instance
#  _LARGE_FILES
#  _LARGEFILE_SOURCE
#  _FILE_OFFSET_BITS 64
#  HAVE_FSEEKO
#
#  However, it is YOUR job to make sure these defines are set in a cmakedefine so they
#  end up in a config.h file that is included in your source if necessary!

set(_test_large_files_dir "${CMAKE_CURRENT_LIST_DIR}")

macro(TEST_LARGE_FILES VARIABLE)
  if(NOT DEFINED ${VARIABLE})

    # On most platforms it is probably overkill to first test the flags for 64-bit off_t,
    # and then separately fseeko. However, in the future we might have 128-bit filesystems
    # (ZFS), so it might be dangerous to indiscriminately set e.g. _FILE_OFFSET_BITS=64.

    message(STATUS "Checking for 64-bit off_t")

    # First check without any special flags
    try_compile(FILE64_OK "${PROJECT_BINARY_DIR}"
      "${_test_large_files_dir}/TestFileOffsetBits.c")
    if(FILE64_OK)
      message(STATUS "Checking for 64-bit off_t - success")
    endif()

    if(NOT FILE64_OK)
      # Test with _FILE_OFFSET_BITS=64
      try_compile(FILE64_OK "${PROJECT_BINARY_DIR}"
        "${_test_large_files_dir}/TestFileOffsetBits.c"
        COMPILE_DEFINITIONS "-D_FILE_OFFSET_BITS=64" )
      if(FILE64_OK)
        message(STATUS "Checking for 64-bit off_t - success with _FILE_OFFSET_BITS=64")
        set(_FILE_OFFSET_BITS 64)
      endif()
    endif()

    if(NOT FILE64_OK)
      # Test with _LARGE_FILES
      try_compile(FILE64_OK "${PROJECT_BINARY_DIR}"
        "${_test_large_files_dir}/TestFileOffsetBits.c"
        COMPILE_DEFINITIONS "-D_LARGE_FILES" )
      if(FILE64_OK)
        message(STATUS "Checking for 64-bit off_t - success with _LARGE_FILES")
        set(_LARGE_FILES 1)
      endif()
    endif()

    if(NOT FILE64_OK)
      # Test with _LARGEFILE_SOURCE
      try_compile(FILE64_OK "${PROJECT_BINARY_DIR}"
        "${_test_large_files_dir}/TestFileOffsetBits.c"
        COMPILE_DEFINITIONS "-D_LARGEFILE_SOURCE" )
      if(FILE64_OK)
        message(STATUS "Checking for 64-bit off_t - success with _LARGEFILE_SOURCE")
        set(_LARGEFILE_SOURCE 1)
      endif()
    endif()

    if(NOT FILE64_OK)
      # now check for Windows stuff
      try_compile(FILE64_OK "${PROJECT_BINARY_DIR}"
        "${_test_large_files_dir}/TestWindowsFSeek.c")
      if(FILE64_OK)
        message(STATUS "Checking for 64-bit off_t - success with _fseeki64")
        set(HAVE__FSEEKI64 1)
      endif()
    endif()

    if(NOT FILE64_OK)
      message(STATUS "Checking for 64-bit off_t - failed")
    else()

      # Set the flags we might have determined to be required above
      configure_file("${_test_large_files_dir}/TestLargeFiles.c.cmakein"
                     "${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/TestLargeFiles.c")

      message(STATUS "Checking for fseeko/ftello")
      # Test if ftello/fseeko are available
      try_compile(FSEEKO_COMPILE_OK "${PROJECT_BINARY_DIR}"
        "${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/TestLargeFiles.c")
      if(FSEEKO_COMPILE_OK)
        message(STATUS "Checking for fseeko/ftello - success")
      endif()

      if(NOT FSEEKO_COMPILE_OK)
        # glibc 2.2 neds _LARGEFILE_SOURCE for fseeko (but not 64-bit off_t...)
        try_compile(FSEEKO_COMPILE_OK "${PROJECT_BINARY_DIR}"
          "${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/TestLargeFiles.c"
          COMPILE_DEFINITIONS "-D_LARGEFILE_SOURCE" )
        if(FSEEKO_COMPILE_OK)
          message(STATUS "Checking for fseeko/ftello - success with _LARGEFILE_SOURCE")
          set(_LARGEFILE_SOURCE 1)
        endif()
      endif()

    endif()

    if(FSEEKO_COMPILE_OK)
      set(${VARIABLE} 1 CACHE INTERNAL "Result of test for large file support" FORCE)
      set(HAVE_FSEEKO 1)
    else()
      if(HAVE__FSEEKI64)
        set(${VARIABLE} 1 CACHE INTERNAL "Result of test for large file support" FORCE)
        set(HAVE__FSEEKI64 1 CACHE INTERNAL "Windows 64-bit fseek" FORCE)
      else()
        message(STATUS "Checking for fseeko/ftello - not found")
        set(${VARIABLE} 0 CACHE INTERNAL "Result of test for large file support" FORCE)
      endif()
    endif()

  endif()
endmacro()
