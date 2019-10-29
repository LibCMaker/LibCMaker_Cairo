# Copyright (c) 2019, NikitaFeodonit. All rights reserved.
#
## Cairo build file for CMake build tools

# CMake files for Cairo are based on the original Cairo build system
# and on the codes from
#   https://github.com/CMakePorts/cairo
#   https://github.com/mvakulich/cairo
#   https://github.com/solvespace/cairo/tree/1.15.2+cmake


include(AutoconfHelper)
include(CairoHelper)

include(CheckIncludeFile)
include(CheckFileOffsetBits)
include(CheckFunctionExists)
include(CheckLibraryExists)
include(CheckTypeSize)
include(TestLargeFiles)


# ===========================================================================
# Part of 'configure --help' output:
#

#Optional Features:
#[...]
#  --enable-gtk-doc        use gtk-doc to build documentation [[default=no]]
#  --disable-largefile     omit support for large files
#  --disable-atomic        disable use of native atomic operations
#  --enable-gcov           Enable gcov
#  --disable-valgrind      Disable valgrind support
#  --enable-xlib=[no/auto/yes]
#                          Enable cairo's Xlib surface backend feature
#                          [default=auto]
#  --enable-xlib-xrender=[no/auto/yes]
#                          Enable cairo's Xlib Xrender surface backend feature
#                          [default=auto]
#  --enable-xcb=[no/auto/yes]
#                          Enable cairo's XCB surface backend feature
#                          [default=auto]
#  --enable-xlib-xcb=[no/auto/yes]
#                          Enable cairo's Xlib/XCB functions feature
#                          [default=no]
#  --enable-xcb-shm=[no/auto/yes]
#                          Enable cairo's XCB/SHM functions feature
#                          [default=auto]
#  --enable-qt=[no/auto/yes]
#                          Enable cairo's Qt surface backend feature
#                          [default=no]
#  --enable-quartz=[no/auto/yes]
#                          Enable cairo's Quartz surface backend feature
#                          [default=auto]
#  --enable-quartz-font=[no/auto/yes]
#                          Enable cairo's Quartz font backend feature
#                          [default=auto]
#  --enable-quartz-image=[no/auto/yes]
#                          Enable cairo's Quartz Image surface backend feature
#                          [default=no]
#  --enable-win32=[no/auto/yes]
#                          Enable cairo's Microsoft Windows surface backend
#                          feature [default=auto]
#  --enable-win32-font=[no/auto/yes]
#                          Enable cairo's Microsoft Windows font backend
#                          feature [default=auto]
#  --enable-os2=[no/auto/yes]
#                          Enable cairo's OS/2 surface backend feature
#                          [default=no]
#  --enable-beos=[no/auto/yes]
#                          Enable cairo's BeOS/Zeta surface backend feature
#                          [default=no]
#  --enable-drm=[no/auto/yes]
#                          Enable cairo's DRM surface backend feature
#                          [default=no]
#  --enable-gallium=[no/auto/yes]
#                          Enable cairo's Gallium3D surface backend feature
#                          [default=no]
#  --enable-png=[no/auto/yes]
#                          Enable cairo's PNG functions feature [default=yes]
#  --enable-gl=[no/auto/yes]
#                          Enable cairo's OpenGL surface backend feature
#                          [default=no]
#  --enable-glesv2=[no/auto/yes]
#                          Enable cairo's OpenGLESv2 surface backend feature
#                          [default=no]
#  --enable-glesv3=[no/auto/yes]
#                          Enable cairo's OpenGLESv3 surface backend feature
#                          [default=no]
#  --enable-cogl=[no/auto/yes]
#                          Enable cairo's Cogl surface backend feature
#                          [default=no]
#  --enable-directfb=[no/auto/yes]
#                          Enable cairo's directfb surface backend feature
#                          [default=no]
#  --enable-vg=[no/auto/yes]
#                          Enable cairo's OpenVG surface backend feature
#                          [default=no]
#  --enable-egl=[no/auto/yes]
#                          Enable cairo's EGL functions feature [default=auto]
#  --enable-glx=[no/auto/yes]
#                          Enable cairo's GLX functions feature [default=auto]
#  --enable-wgl=[no/auto/yes]
#                          Enable cairo's WGL functions feature [default=auto]
#  --enable-script=[no/auto/yes]
#                          Enable cairo's script surface backend feature
#                          [default=yes]
#  --enable-ft=[no/auto/yes]
#                          Enable cairo's FreeType font backend feature
#                          [default=auto]
#  --enable-fc=[no/auto/yes]
#                          Enable cairo's Fontconfig font backend feature
#                          [default=auto]
#  --enable-ps=[no/auto/yes]
#                          Enable cairo's PostScript surface backend feature
#                          [default=yes]
#  --enable-pdf=[no/auto/yes]
#                          Enable cairo's PDF surface backend feature
#                          [default=yes]
#  --enable-svg=[no/auto/yes]
#                          Enable cairo's SVG surface backend feature
#                          [default=yes]
#  --enable-test-surfaces=[no/auto/yes]
#                          Enable cairo's test surfaces feature [default=no]
#  --enable-tee=[no/auto/yes]
#                          Enable cairo's tee surface backend feature
#                          [default=no]
#  --enable-xml=[no/auto/yes]
#                          Enable cairo's xml surface backend feature
#                          [default=no]
#  --enable-pthread=[no/auto/yes]
#                          Enable cairo's pthread feature [default=auto]
#  --enable-gobject=[no/auto/yes]
#                          Enable cairo's gobject functions feature
#                          [default=auto]
#  --enable-full-testing   Sets the test suite to perform full testing by
#                          default, which will dramatically slow down make
#                          check, but is a *requirement* before release.
#  --enable-trace=[no/auto/yes]
#                          Enable cairo's cairo-trace feature [default=auto]
#  --enable-interpreter=[no/auto/yes]
#                          Enable cairo's cairo-script-interpreter feature
#                          [default=yes]
#  --enable-symbol-lookup=[no/auto/yes]
#                          Enable cairo's symbol-lookup feature [default=auto]
#  --disable-some-floating-point
#                          Disable certain code paths that rely heavily on
#                          double precision floating-point calculation. This
#                          option can improve performance on systems without a
#                          double precision floating-point unit, but might
#                          degrade performance on those that do.
#
#Optional Packages:
#  --with-aix-soname=aix|svr4|both
#                          shared library versioning (aka "SONAME") variant to
#                          provide on AIX, [default=aix].
#  --with-gnu-ld           assume the C compiler uses GNU ld [default=no]
#  --with-sysroot[=DIR]    Search for dependent libraries within DIR (or the
#                          compiler's sysroot if not specified).
#  --with-html-dir=PATH    path to installed docs
#  --with-x                use the X Window System
#  --with-gallium=/path/to/mesa
#                          directory to find gallium enabled mesa


set(CAIRO_DEFS)
set(CAIRO_INC_DIRS)
set(CAIRO_LIBS)


# ===========================================================================
#                             configure.ac
# ===========================================================================

set(PACKAGE_BUGREPORT "https://bugs.freedesktop.org/enter_bug.cgi?product=cairo")
set(PACKAGE_URL       "https://cairographics.org/")

# TODO:
# define AC_APPLE_UNIVERSAL_BUILD

#AC_USE_SYSTEM_EXTENSIONS
# TODO:

check_include_file("unistd.h" HAVE_UNISTD_H)
check_include_file("sys/ioctl.h" HAVE_SYS_IOCTL_H)

#AC_C_TYPEOF()
# TODO:
#set(HAVE_TYPEOF 1)
#set(typeof "TODO")

# Api documentation
#GTK_DOC_CHECK([1.15],[--flavour no-tmpl])
option(CAIRO_ENABLE_GTK_DOC "use gtk-doc to build documentation [[default=no]]" OFF)
set(enable_gtk_doc "no")
# TODO:

option(CAIRO_DISABLE_LARGEFILE "omit support for large files" OFF)
if(NOT CAIRO_DISABLE_LARGEFILE)
  if(NOT ANDROID OR NOT ANDROID_NATIVE_API_LEVEL LESS 21)
    check_file_offset_bits()
    # set _FILE_OFFSET_BITS=64

    test_large_files(HAVE_OFF_T_64_FSEEKO_FTELLO)
    # set (_FILE_OFFSET_BITS=64 OR _LARGE_FILES=1
    #     OR _LARGEFILE_SOURCE=1 OR HAVE__FSEEKI64=1)
    # AND HAVE_FSEEKO=1
  endif()
endif()


# ===========================================================================
#                             configure.ac.version
# ===========================================================================

file(READ cairo-version.h cairo_version_h)
string(REGEX REPLACE ".*#define CAIRO_VERSION_MAJOR ([0-9]+)\n.*" "\\1"
  CAIRO_VERSION_MAJOR ${cairo_version_h}
)
string(REGEX REPLACE ".*#define CAIRO_VERSION_MINOR ([0-9]+)\n.*" "\\1"
  CAIRO_VERSION_MINOR ${cairo_version_h}
)
string(REGEX REPLACE ".*#define CAIRO_VERSION_MICRO ([0-9]+)\n.*" "\\1"
  CAIRO_VERSION_MICRO ${cairo_version_h}
)


# ===========================================================================
#                             configure.ac.tools
# ===========================================================================

ac_c_inline()  # set inline


# ===========================================================================
#                             configure.ac.features
# ===========================================================================

# ===========================================================================
#
# Generate src/cairo-features.h, src/cairo-supported-features.h, and
# src/cairo-features-win32.h
# TODO:


# ===========================================================================
#
# Report
#
function(cairo_report)
  set(CAIRO_VERSION
    "${CAIRO_VERSION_MAJOR}.${CAIRO_VERSION_MINOR}.${CAIRO_VERSION_MICRO}"
  )

  message(STATUS "")
  message(STATUS "cairo (version ${CAIRO_VERSION}) will be compiled with:")
  message(STATUS "")
  message(STATUS "The following surface backends:")
  message(STATUS "  Image:         yes (always builtin)")
  message(STATUS "  Recording:     yes (always builtin)")
  message(STATUS "  Observer:      yes (always builtin)")
  message(STATUS "  Mime:          yes (always builtin)")
  message(STATUS "  Tee:           ${use_tee}")
  message(STATUS "  XML:           ${use_xml}")
  #message(STATUS "  Skia:          ${use_skia}")
  message(STATUS "  Xlib:          ${use_xlib}")
  message(STATUS "  Xlib Xrender:  ${use_xlib_xrender}")
  message(STATUS "  Qt:            ${use_qt}")
  message(STATUS "  Quartz:        ${use_quartz}")
  message(STATUS "  Quartz-image:  ${use_quartz_image}")
  message(STATUS "  XCB:           ${use_xcb}")
  message(STATUS "  Win32:         ${use_win32}")
  message(STATUS "  OS2:           ${use_os2}")
  message(STATUS "  CairoScript:   ${use_script}")
  message(STATUS "  PostScript:    ${use_ps}")
  message(STATUS "  PDF:           ${use_pdf}")
  message(STATUS "  SVG:           ${use_svg}")
  message(STATUS "  OpenGL:        ${use_gl}")
  message(STATUS "  OpenGL ES 2.0: ${use_glesv2}")
  message(STATUS "  OpenGL ES 3.0: ${use_glesv3}")
  message(STATUS "  BeOS:          ${use_beos}")
  message(STATUS "  DirectFB:      ${use_directfb}")
  message(STATUS "  OpenVG:        ${use_vg}")
  message(STATUS "  DRM:           ${use_drm}")
  message(STATUS "  Cogl:          ${use_cogl}")
  message(STATUS "")
  message(STATUS "The following font backends:")
  message(STATUS "  User:          yes (always builtin)")
  message(STATUS "  FreeType:      ${use_ft}")
  message(STATUS "  Fontconfig:    ${use_fc}")
  message(STATUS "  Win32:         ${use_win32_font}")
  message(STATUS "  Quartz:        ${use_quartz_font}")
  message(STATUS "")
  message(STATUS "The following functions:")
  message(STATUS "  PNG functions:   ${use_png}")
  message(STATUS "  GLX functions:   ${use_glx}")
  message(STATUS "  WGL functions:   ${use_wgl}")
  message(STATUS "  EGL functions:   ${use_egl}")
  message(STATUS "  X11-xcb functions: ${use_xlib_xcb}")
  message(STATUS "  XCB-shm functions: ${use_xcb_shm}")
  message(STATUS "")
  message(STATUS "The following features and utilities:")
  message(STATUS "  cairo-trace:                ${use_trace}")
  message(STATUS "  cairo-script-interpreter:   ${use_interpreter}")
  message(STATUS "")
  message(STATUS "And the following internal features:")
  message(STATUS "  pthread:       ${use_pthread}")
  message(STATUS "  gtk-doc:       ${enable_gtk_doc}")
  message(STATUS "  gcov support:  ${use_gcov}")
  message(STATUS "  symbol-lookup: ${use_symbol_lookup}")
  message(STATUS "  test surfaces: ${use_test_surfaces}")
  message(STATUS "  ps testing:    ${test_ps}")
  message(STATUS "  pdf testing:   ${test_pdf}")
  message(STATUS "  svg testing:   ${test_svg}")
  if(use_win32)
    message(STATUS "  win32 printing testing:    ${test_win32_printing}")
  endif()
  message(STATUS "${CAIRO_WARNING_MESSAGE}")
  message(STATUS "")
endfunction()


# ===========================================================================
#                             configure.ac.warnings
# ===========================================================================

# Use lots of warning flags with with gcc and compatible compilers

# TODO:
#set(WARN_UNUSED_RESULT "TODO")

# TODO:
#if(CMAKE_COMPILER_IS_GNUCC)
#  set(COMMON_WARNINGS "-Wall -Wextra \
#    -Wmissing-declarations -Werror-implicit-function-declaration \
#    -Wpointer-arith -Wwrite-strings -Wsign-compare -Wpacked \
#    -Wswitch-enum -Wmissing-format-attribute -Wvolatile-register-var \
#    -Wstrict-aliasing=2 -Winit-self -Wunsafe-loop-optimizations \
#    -Wno-missing-field-initializers -Wno-unused-parameter \
#    -Wno-attributes -Wno-long-long -Winline -Wno-unused-but-set-variable"
#  )
#  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${COMMON_WARNINGS}
#    -Wold-style-definition -Wdeclaration-after-statement -Wstrict-prototypes \
#    -Wmissing-prototypes -Wbad-function-cast -Wnested-externs"
#  )
#  add_compile_options(-fno-strict-aliasing -fno-common)
#endif()


# ===========================================================================
#                             configure.ac.system
# ===========================================================================

#
# Non-failing checks for functions, headers, libraries, etc go here
#

# ====================================================================
# Feature checks
# ====================================================================

ac_c_bigendian()  # set WORDS_BIGENDIAN
# TODO:
#set(FLOAT_WORDS_BIGENDIAN 1)

option(CAIRO_DISABLE_ATOMIC "disable use of native atomic operations" OFF)
# TODO:
#define ATOMIC_OP_NEEDS_MEMORY_BARRIER
#set(HAVE_CXX11_ATOMIC_PRIMITIVES 1)
#set(HAVE_GCC_LEGACY_ATOMICS 1)
#set(HAVE_LIB_ATOMIC_OPS 1)
#set(HAVE_OS_ATOMIC_OPS 1)

check_type_size("void *"    SIZEOF_VOID_P)
check_type_size("int"       SIZEOF_INT)
check_type_size("long"      SIZEOF_LONG)
check_type_size("long long" SIZEOF_LONG_LONG)
check_type_size("size_t"    SIZEOF_SIZE_T)

set(STDC_HEADERS 1)

if(CMAKE_HOST_WIN32)
  set(cairo_os_win32 "yes")
else()
  set(cairo_os_win32 "no")
endif()


# ====================================================================
# Library checks
# ====================================================================

find_package(LibM)
if(LIBM_FOUND)
  list(INSERT CAIRO_LIBS 0 LIBM::LIBM)
endif()


# ====================================================================
# Header/function checks
# ====================================================================

# check if we have a __builtin_return_address for the cairo-trace utility.
ac_try_compile(" " "__builtin_return_address(0);" HAVE_BUILTIN_RETURN_ADDRESS)

# Checks for precise integer types
check_include_file("stdint.h" HAVE_STDINT_H)
check_include_file("inttypes.h" HAVE_INTTYPES_H)
check_include_file("sys/int_types.h" HAVE_SYS_INT_TYPES_H)
check_type_size("uint64_t" SIZEOF_UINT64_T)
if(SIZEOF_UINT64_T)
  set(HAVE_UINT64_T 1)
endif()
check_type_size("uint128_t" SIZEOF_UINT128_T)
if(SIZEOF_UINT128_T)
  set(HAVE_UINT128_T 1)
endif()
check_type_size("__uint128_t" SIZEOF___UINT128_T)
if(SIZEOF___UINT128_T)
  set(HAVE___UINT128_T 1)
endif()

# Check for socket support for any2ppm daemon
check_include_file("fcntl.h" HAVE_FCNTL_H)
check_include_file("signal.h" HAVE_SIGNAL_H)
check_include_file("sys/stat.h" HAVE_SYS_STAT_H)
check_include_file("sys/socket.h" HAVE_SYS_SOCKET_H)
check_include_file("sys/poll.h" HAVE_SYS_POLL_H)
check_include_file("sys/un.h" HAVE_SYS_UN_H)

# Check for infinite loops
check_function_exists(alarm HAVE_ALARM)

# TODO:
#set(HAVE_BFD 1)

# check for CPU affinity support
check_include_file("sched.h" HAVE_SCHED_H)
if(HAVE_SCHED_H)
  check_function_exists(sched_getaffinity HAVE_SCHED_GETAFFINITY)
endif()

# check for mmap support
check_include_file("sys/mman.h" HAVE_SYS_MMAN_H)
if(HAVE_SYS_MMAN_H)
  check_function_exists(mmap HAVE_MMAP)
endif()

# check for clock_gettime() support
check_include_file("time.h" HAVE_TIME_H)
if(HAVE_TIME_H)
  check_function_exists(clock_gettime HAVE_CLOCK_GETTIME)
endif()

# check for GNU-extensions to fenv
check_include_file("fenv.h" HAVE_FENV_H)
if(HAVE_FENV_H)
  check_function_exists(feenableexcept HAVE_FEENABLEEXCEPT)
  check_function_exists(fedisableexcept HAVE_FEDISABLEEXCEPT)
  check_function_exists(feclearexcept HAVE_FECLEAREXCEPT)
endif()

# check for misc headers and functions
check_include_file("libgen.h" HAVE_LIBGEN_H)
check_include_file("byteswap.h" HAVE_BYTESWAP_H)
check_include_file("setjmp.h" HAVE_SETJMP_H)
check_include_file("sys/wait.h" HAVE_SYS_WAIT_H)
check_function_exists(ctime_r HAVE_CTIME_R)
check_function_exists(localtime_r HAVE_LOCALTIME_R)
check_function_exists(gmtime_r HAVE_GMTIME_R)
check_function_exists(drand48 HAVE_DRAND48)
check_function_exists(flockfile HAVE_FLOCKFILE)
check_function_exists(funlockfile HAVE_FUNLOCKFILE)
check_function_exists(getline HAVE_GETLINE)
check_function_exists(link HAVE_LINK)
check_function_exists(strndup HAVE_STRNDUP)

# Check if the runtime platform is a native Win32 host.
if(WIN32)
  set(have_windows "yes")
else()
  set(have_windows "no")
endif()

# Possible headers for mkdir
check_include_file("io.h" HAVE_IO_H)
# TODO: on Linux was set HAVE_MKDIR to 2, see configure.ac
check_function_exists(mkdir HAVE_MKDIR)


# ===========================================================================
#
# Test for the tools required for building one big test binary
#

check_function_exists(fork HAVE_FORK)
check_function_exists(waitpid HAVE_WAITPID)
check_function_exists(raise HAVE_RAISE)


# ===========================================================================
#                             configure.ac.analysis
# ===========================================================================

# ===========================================================================
#
# LCOV
#
option(CAIRO_ENABLE_GCOV "Enable gcov" OFF)
set(use_gcov "no")
check_function_exists(gcov HAVE_GCOV)
# TODO:


# ===========================================================================
# Check for some custom valgrind modules

option(CAIRO_DISABLE_VALGRIND "Disable valgrind support" OFF)
set(use_valgrind "no")
# TODO:
#set(HAVE_VALGRIND 1)
#set(HAVE_LOCKDEP 1)
#set([HAVE_MEMFAULT 1)


# ===========================================================================
#                             configure.ac.noversion
# ===========================================================================

set(PACKAGE_VERSION USE_cairo_version_OR_cairo_version_string_INSTEAD)
set(PACKAGE_STRING  USE_cairo_version_OR_cairo_version_string_INSTEAD)
set(PACKAGE_NAME    USE_cairo_INSTEAD)
set(PACKAGE_TARNAME USE_cairo_INSTEAD)


# ===========================================================================
#                             configure.ac.pthread
# ===========================================================================


# ===========================================================================
#                             configure.ac
# ===========================================================================

#AC_CHECK_LIB(z, compress,
set(have_libz "no (requires zlib http://www.gzip.org/zlib/)")
find_package(ZLIB REQUIRED)
if(ZLIB_FOUND)
  set(have_libz "yes")
  set(HAVE_ZLIB 1)
endif()

#AC_CHECK_LIB(lzo2, lzo2a_decompress,
set(have_lzo "no")
# TODO:
#set(HAVE_LZO 1)

# TODO:
#AC_CHECK_LIB(dl, dlsym,
set(have_dlsym "no")
set(have_dl "no")
#set(HAVE_DLFCN_H 1)
#set(CAIRO_HAS_DL 1)
#set(CAIRO_HAS_DLSYM 1)

check_include_file("xlocale.h" HAVE_XLOCALE_H)
check_function_exists(newlocale HAVE_NEWLOCALE)
check_function_exists(strtod_l HAVE_STRTOD_L)


# ===========================================================================

#CAIRO_ENABLE_SURFACE_BACKEND(xlib, Xlib, auto,
set(CAIRO_ENABLE_XLIB "auto" CACHE STRING
  "[no/auto/yes] Enable cairo's Xlib surface backend feature [default=auto]"
)
set(use_xlib "no (requires X development libraries)")
if(CAIRO_ENABLE_XLIB)
  find_package(X11)
  if(CAIRO_ENABLE_XLIB STREQUAL "yes" AND NOT X11_Xlib_INCLUDE_PATH)
    message(FATAL_ERROR "Xlib surface backend feature could not be enabled")
  endif()
  if(X11_FOUND AND X11_Xlib_INCLUDE_PATH)
    set(use_xlib "yes")
    set(CAIRO_HAS_XLIB_SURFACE 1)
    list(INSERT CAIRO_LIBS 0 X11::X11)
  #else()
    #AC_PATH_XTRA
    # TODO:
    #set(X_DISPLAY_MISSING 1)
  endif()
endif()

# TODO:
#AC_CHECK_HEADER(sys/ipc.h)
#AC_CHECK_HEADER(sys/shm.h)
#AC_CHECK_HEADERS([X11/extensions/XShm.h X11/extensions/shmproto.h X11/extensions/shmstr.h], [], [],
#     [#include <X11/Xlibint.h>
##include <X11/Xproto.h>])
#
#set(IPC_RMID_DEFERRED_RELEASE 1)
#set(HAVE_X11_EXTENSIONS_XSHM_H 1)
#set(HAVE_X11_EXTENSIONS_SHMPROTO_H 1)
#set(HAVE_X11_EXTENSIONS_SHMSTR_H 1)


#CAIRO_ENABLE_SURFACE_BACKEND(xlib_xrender, Xlib Xrender, auto,
set(CAIRO_ENABLE_XLIB_XRENDER "auto" CACHE STRING
  "[no/auto/yes] Enable cairo's Xlib Xrender surface backend feature [default=auto]"
)
if(NOT CAIRO_ENABLE_XLIB_XRENDER)
  set(use_xlib_xrender "no (requires CAIRO_ENABLE_XLIB_XRENDER)")
else()
  find_package(X11)
  if(CAIRO_ENABLE_XLIB_XRENDER STREQUAL "yes" AND NOT X11_Xrender_FOUND)
    message(FATAL_ERROR "Xlib Xrender surface backend feature could not be enabled")
  endif()
  if(X11_Xrender_FOUND)
    set(use_xlib_xrender "yes")
    set(CAIRO_HAS_XLIB_XRENDER_SURFACE 1)
    # TODO:
    #AC_CHECK_FUNCS([XRenderCreateSolidFill XRenderCreateLinearGradient XRenderCreateRadialGradient XRenderCreateConicalGradient])
    #set(HAVE_XRENDERCREATESOLIDFILL 1)
    #set(HAVE_XRENDERCREATELINEARGRADIENT 1)
    #set(HAVE_XRENDERCREATERADIALGRADIENT 1)
    #set(HAVE_XRENDERCREATECONICALGRADIENT 1)
    list(INSERT CAIRO_LIBS 0 X11::Xrender)
  else()
    set(use_xlib_xrender "no (requires $xlib_xrender_REQUIRES https://freedesktop.org/Software/xlibs)")
  endif()
endif()


# ===========================================================================

#CAIRO_ENABLE_SURFACE_BACKEND(xcb, XCB, auto,
set(CAIRO_ENABLE_XCB "auto" CACHE STRING
  "[no/auto/yes] Enable cairo's XCB surface backend feature [default=auto]"
)
set(use_xcb "no (requires $xcb_REQUIRES https://xcb.freedesktop.org)")
if(CAIRO_ENABLE_XCB)
  find_package(XCB)
  if(CAIRO_ENABLE_XCB STREQUAL "yes" AND NOT XCB_FOUND)
    message(FATAL_ERROR "XCB surface backend feature could not be enabled")
  endif()
  if(XCB_FOUND)
    set(use_xcb "yes")
    set(CAIRO_HAS_XCB_SURFACE 1)
    list(INSERT CAIRO_INC_DIRS 0 ${XCB_INCLUDE_DIRS})
    list(INSERT CAIRO_LIBS 0 ${XCB_LIBRARIES})
  endif()
endif()


#CAIRO_ENABLE_FUNCTIONS(xlib_xcb, Xlib/XCB, no,
set(CAIRO_ENABLE_XLIB_XCB "no" CACHE STRING
  "[no/auto/yes] Enable cairo's Xlib/XCB functions feature [default=no]"
)
set(use_xlib_xcb "no")
if(CAIRO_ENABLE_XLIB_XCB)
  if(XCB_FOUND AND X11_FOUND AND X11_Xlib_INCLUDE_PATH)
    find_package(X11_XCB)
  endif()
  if(CAIRO_ENABLE_XLIB_XCB STREQUAL "yes" AND NOT X11_XCB_FOUND)
    message(FATAL_ERROR "Xlib/XCB functions feature could not be enabled")
  endif()
  if(X11_XCB_FOUND)
    set(use_xlib_xcb "yes")
    set(CAIRO_HAS_XLIB_XCB_FUNCTIONS 1)
    list(INSERT CAIRO_LIBS 0 X11::XCB)
  endif()
endif()


#CAIRO_ENABLE_FUNCTIONS(xcb_shm, XCB/SHM, auto,
set(CAIRO_ENABLE_XCB_SHM "auto" CACHE STRING
  "[no/auto/yes] Enable cairo's XCB/SHM functions feature [default=auto]"
)
set(use_xcb_shm "no")
if(CAIRO_ENABLE_XCB_SHM)
  if(XCB_FOUND)
    find_package(XCB COMPONENTS SHM)
  endif()
  if(CAIRO_ENABLE_XCB_SHM STREQUAL "yes" AND NOT XCB_SHM_FOUND)
    message(FATAL_ERROR "XCB/SHM functions feature could not be enabled")
  endif()
  if(XCB_SHM_FOUND)
    set(use_xcb_shm "yes")
    set(CAIRO_HAS_XCB_SHM_FUNCTIONS 1)
    list(INSERT CAIRO_LIBS 0 XCB::SHM)
  endif()
endif()


# ===========================================================================

#CAIRO_ENABLE_SURFACE_BACKEND(qt, Qt, no,
set(CAIRO_ENABLE_QT "no" CACHE STRING
  "[no/auto/yes] Enable cairo's Qt surface backend feature [default=no]"
)
set(use_qt "no (requires Qt4 development libraries)")
# TODO:
#set(CAIRO_HAS_QT_SURFACE 1)


# ===========================================================================

#CAIRO_ENABLE_SURFACE_BACKEND(quartz, Quartz, auto,
set(CAIRO_ENABLE_QUARTZ "auto" CACHE STRING
  "[no/auto/yes] Enable cairo's Quartz surface backend feature [default=auto]"
)
set(use_quartz "no")
# TODO:
#set(CAIRO_HAS_QUARTZ_SURFACE 1)


#CAIRO_ENABLE_FONT_BACKEND(quartz_font, Quartz, auto,
set(CAIRO_ENABLE_QUARTZ_FONT "auto" CACHE STRING
  "[no/auto/yes] Enable cairo's Quartz font backend feature [default=auto]"
)
set(use_quartz_font ${use_quartz})
# TODO:
#set(CAIRO_HAS_QUARTZ_FONT 1)


#CAIRO_ENABLE_SURFACE_BACKEND(quartz_image, Quartz Image, no,
set(CAIRO_ENABLE_QUARTZ_IMAGE "no" CACHE STRING
  "[no/auto/yes] Enable cairo's Quartz Image surface backend feature [default=no]"
)
set(use_quartz_image ${use_quartz})
# TODO:
#set(CAIRO_HAS_QUARTZ_IMAGE_SURFACE 1)


# ===========================================================================

#CAIRO_ENABLE_SURFACE_BACKEND(win32, Microsoft Windows, auto,
set(CAIRO_ENABLE_WIN32 "auto" CACHE STRING
  "[no/auto/yes] Enable cairo's Microsoft Windows surface backend feature [default=auto]"
)
set(use_win32 "no")
# TODO:
#set(CAIRO_HAS_WIN32_SURFACE 1)


#CAIRO_ENABLE_FONT_BACKEND(win32_font, Microsoft Windows, auto,
set(CAIRO_ENABLE_WIN32_FONT "auto" CACHE STRING
  "[no/auto/yes] Enable cairo's Microsoft Windows font backend feature [default=auto]"
)
set(use_win32_font ${use_win32})
# TODO:
#set(CAIRO_HAS_WIN32_FONT 1)


set(test_win32_printing "no")
# TODO:
#set(CAIRO_CAN_TEST_WIN32_PRINTING_SURFACE 1)


# ===========================================================================

#CAIRO_ENABLE_SURFACE_BACKEND(os2, OS/2, no,
set(CAIRO_ENABLE_OS2 "no" CACHE STRING
  "[no/auto/yes] Enable cairo's OS/2 surface backend feature [default=no]"
)
set(use_os2 "no")
# TODO:
#set(CAIRO_HAS_OS2_SURFACE 1)


# ===========================================================================

#CAIRO_ENABLE_SURFACE_BACKEND(beos, BeOS/Zeta, no,
set(CAIRO_ENABLE_BEOS "no" CACHE STRING
  "[no/auto/yes] Enable cairo's BeOS/Zeta surface backend feature [default=no]"
)
set(use_beos "no")
# TODO:
#set(CAIRO_HAS_BEOS_SURFACE 1)


# ===========================================================================

#CAIRO_ENABLE_SURFACE_BACKEND(drm, DRM, no,
set(CAIRO_ENABLE_DRM "no" CACHE STRING
  "[no/auto/yes] Enable cairo's DRM surface backend feature [default=no]"
)
set(use_drm "no")
# TODO:
#set(CAIRO_HAS_DRM_SURFACE 1)


#CAIRO_ENABLE_SURFACE_BACKEND(gallium, Gallium3D, no,
set(CAIRO_ENABLE_GALLIUM "no" CACHE STRING
  "[no/auto/yes] Enable cairo's Gallium3D surface backend feature [default=no]"
)
set(CAIRO_WITH_GALLIUM "TODO" CACHE STRING
  "[/path/to/mesa] directory to find gallium enabled mesa"
)
set(use_gallium "no")
# TODO:
#set(CAIRO_HAS_GALLIUM_SURFACE 1)


# ===========================================================================

#CAIRO_ENABLE_FUNCTIONS(png, PNG, yes,
set(CAIRO_ENABLE_PNG "yes" CACHE STRING
  "[no/auto/yes] Enable cairo's PNG functions feature [default=yes]"
)
set(use_png "no")
if(CAIRO_ENABLE_PNG)
  find_package(PNG)
  if(CAIRO_ENABLE_PNG STREQUAL "yes" AND NOT PNG_FOUND)
    message(FATAL_ERROR "PNG functions feature could not be enabled")
  endif()
  if(PNG_FOUND)
    set(use_png "yes")
    set(CAIRO_HAS_PNG_FUNCTIONS 1)
    list(INSERT CAIRO_LIBS 0 PNG::PNG)
  endif()
endif()


# ===========================================================================

#CAIRO_ENABLE_SURFACE_BACKEND(gl, OpenGL, no,
set(CAIRO_ENABLE_GL "no" CACHE STRING
  "[no/auto/yes] Enable cairo's OpenGL surface backend feature [default=no]"
)
set(use_gl "no")
# TODO:
#set(CAIRO_HAS_GL_SURFACE 1)


# ===========================================================================

#CAIRO_ENABLE_SURFACE_BACKEND(glesv2, OpenGLESv2, no,
set(CAIRO_ENABLE_GLESV2 "no" CACHE STRING
  "[no/auto/yes] Enable cairo's OpenGLESv2 surface backend feature [default=no]"
)
set(use_glesv2 "no")
# TODO:
#set(CAIRO_HAS_GLESV2_SURFACE 1)


# ===========================================================================

#CAIRO_ENABLE_SURFACE_BACKEND(glesv3, OpenGLESv3, no,
set(CAIRO_ENABLE_GLESV3 "no" CACHE STRING
  "[no/auto/yes] Enable cairo's OpenGLESv3 surface backend feature [default=no]"
)
set(use_glesv3 "no")
# TODO:
#set(CAIRO_HAS_GLESV3_SURFACE 1)


# ===========================================================================

#CAIRO_ENABLE_SURFACE_BACKEND(cogl, Cogl, no,
set(CAIRO_ENABLE_COGL "no" CACHE STRING
  "[no/auto/yes] Enable cairo's Cogl surface backend feature [default=no]"
)
set(use_cogl "no")
# TODO:
#set(CAIRO_HAS_COGL_SURFACE 1)


# ===========================================================================

#CAIRO_ENABLE_SURFACE_BACKEND(directfb, directfb, no,
set(CAIRO_ENABLE_DIRECTFB "no" CACHE STRING
  "[no/auto/yes] Enable cairo's directfb surface backend feature [default=no]"
)
set(use_directfb "no")
# TODO:
#set(CAIRO_HAS_DIRECTFB_SURFACE 1)


# ===========================================================================

#CAIRO_ENABLE_SURFACE_BACKEND(vg, OpenVG, no,
set(CAIRO_ENABLE_VG "no" CACHE STRING
  "[no/auto/yes] Enable cairo's OpenVG surface backend feature [default=no]"
)
set(use_vg "no")
# TODO:
#set(CAIRO_HAS_VG_SURFACE 1)


#CAIRO_ENABLE_FUNCTIONS(egl, EGL, auto,
set(CAIRO_ENABLE_EGL "auto" CACHE STRING
  "[no/auto/yes] Enable cairo's EGL functions feature [default=auto]"
)
set(use_egl "no")
# TODO:
#set(CAIRO_HAS_EGL_FUNCTIONS 1)


#CAIRO_ENABLE_FUNCTIONS(glx, GLX, auto,
set(CAIRO_ENABLE_GLX "auto" CACHE STRING
  "[no/auto/yes] Enable cairo's GLX functions feature [default=auto]"
)
set(use_glx "no")
# TODO:
#set(CAIRO_HAS_GLX_FUNCTIONS 1)


#CAIRO_ENABLE_FUNCTIONS(wgl, WGL, auto,
set(CAIRO_ENABLE_WGL "auto" CACHE STRING
  "[no/auto/yes] Enable cairo's WGL functions feature [default=auto]"
)
set(use_wgl "no")
check_include_file("windows.h" HAVE_WINDOWS_H)
# TODO:
#set(CAIRO_HAS_WGL_FUNCTIONS 1)


# ===========================================================================

#CAIRO_ENABLE_SURFACE_BACKEND(script, script, yes,
set(CAIRO_ENABLE_SCRIPT "yes" CACHE STRING
  "[no/auto/yes] Enable cairo's script surface backend feature [default=yes]"
)
set(use_script "no")
if(CAIRO_ENABLE_SCRIPT)
  if(CAIRO_ENABLE_SCRIPT STREQUAL "yes" AND NOT ZLIB_FOUND)
    message(FATAL_ERROR "script surface backend feature could not be enabled")
  endif()
  if(ZLIB_FOUND)
    set(use_script "yes")
    set(CAIRO_HAS_SCRIPT_SURFACE 1)
    list(APPEND CAIRO_LIBS ZLIB::ZLIB)
  endif()
endif()


# ===========================================================================

#CAIRO_ENABLE_FONT_BACKEND(ft, FreeType, auto,
set(CAIRO_ENABLE_FT "auto" CACHE STRING
  "[no/auto/yes] Enable cairo's FreeType font backend feature [default=auto]"
)
set(use_ft "no")
if(CAIRO_ENABLE_FT)
  find_package(Freetype)
  if(CAIRO_ENABLE_FT STREQUAL "yes" AND NOT FREETYPE_FOUND)
    message(FATAL_ERROR "FreeType font backend feature could not be enabled")
  endif()
  if(FREETYPE_FOUND)
    set(use_ft "yes")
    set(CAIRO_HAS_FT_FONT 1)
    list(INSERT CAIRO_LIBS 0 Freetype::Freetype)

    list(APPEND CMAKE_REQUIRED_LIBRARIES ${FREETYPE_LIBRARIES})
    list(APPEND CMAKE_REQUIRED_INCLUDES ${FREETYPE_INCLUDE_DIR})

    check_freetype_symbol_exists(FT_Get_X11_Font_Format HAVE_FT_GET_X11_FONT_FORMAT)
    check_freetype_symbol_exists(FT_GlyphSlot_Embolden HAVE_FT_GLYPHSLOT_EMBOLDEN)
    check_freetype_symbol_exists(FT_GlyphSlot_Oblique HAVE_FT_GLYPHSLOT_OBLIQUE)
    check_freetype_symbol_exists(FT_Load_Sfnt_Table HAVE_FT_LOAD_SFNT_TABLE)
    check_freetype_symbol_exists(FT_Library_SetLcdFilter HAVE_FT_LIBRARY_SETLCDFILTER)
    check_freetype_symbol_exists(FT_Get_Var_Design_Coordinates HAVE_FT_GET_VAR_DESIGN_COORDINATES)
    check_freetype_symbol_exists(FT_Done_MM_Var HAVE_FT_DONE_MM_VAR)
    # TODO: check if is without quotes, value must be (0) , not "(0)"
    check_freetype_FT_HAS_COLOR(FT_HAS_COLOR)

    # Rest from CMakePorts
    check_freetype_symbol_exists(FT_Get_BDF_Property HAVE_FT_GET_BDF_PROPERTY)
    check_freetype_symbol_exists(FT_Get_Next_Char HAVE_FT_GET_NEXT_CHAR)
    check_freetype_symbol_exists(FT_Get_PS_Font_Info HAVE_FT_GET_PS_FONT_INFO)
    check_freetype_symbol_exists(FT_Has_PS_Glyph_Names HAVE_FT_HAS_PS_GLYPH_NAMES)
    check_freetype_symbol_exists(FT_Select_Size HAVE_FT_SELECT_SIZE)
  endif()
endif()


#CAIRO_ENABLE_FONT_BACKEND(fc, Fontconfig, auto,
set(CAIRO_ENABLE_FC "auto" CACHE STRING
  "[no/auto/yes] Enable cairo's Fontconfig font backend feature [default=auto]"
)
set(use_fc "no")
if(CAIRO_ENABLE_FC)
  find_package(Fontconfig)
  if(CAIRO_ENABLE_FC STREQUAL "yes" AND NOT Fontconfig_FOUND)
    message(FATAL_ERROR "Fontconfig font backend feature could not be enabled")
  endif()
  if(Fontconfig_FOUND)
    set(use_fc "yes")
    set(CAIRO_HAS_FC_FONT 1)
    list(INSERT CAIRO_LIBS 0 Fontconfig::Fontconfig)

    list(APPEND CMAKE_REQUIRED_LIBRARIES ${Fontconfig_LIBRARIES})
    list(APPEND CMAKE_REQUIRED_INCLUDES ${Fontconfig_INCLUDE_DIRS})

    # TODO: check and compare with CAIRO_CHECK_FUNCS_WITH_FLAGS(FcInit FcFini, [$FONTCONFIG_CFLAGS], [$FONTCONFIG_LIBS])
    check_function_exists(FcInit HAVE_FCINIT)
    check_function_exists(FcFini HAVE_FCFINI)
  endif()
endif()


# ===========================================================================

#CAIRO_ENABLE_SURFACE_BACKEND(ps, PostScript, yes,
set(CAIRO_ENABLE_PS "yes" CACHE STRING
  "[no/auto/yes] Enable cairo's PostScript surface backend feature [default=yes]"
)
set(use_ps "no")
if(CAIRO_ENABLE_PS)
  if(CAIRO_ENABLE_PS STREQUAL "yes" AND NOT ZLIB_FOUND)
    message(FATAL_ERROR "PostScript surface backend feature could not be enabled")
  endif()
  if(ZLIB_FOUND)
    # The ps backend requires zlib.
    set(use_ps "yes")
    set(CAIRO_HAS_PS_SURFACE 1)
    list(APPEND CAIRO_LIBS ZLIB::ZLIB)
  endif()
endif()


# ===========================================================================

set(test_ps "no")
# TODO:
#set(CAIRO_CAN_TEST_PS_SURFACE 1)
#set(CAIRO_HAS_SPECTRE 1)


# ===========================================================================

#CAIRO_ENABLE_SURFACE_BACKEND(pdf, PDF, yes,
set(CAIRO_ENABLE_PDF "yes" CACHE STRING
  "[no/auto/yes] Enable cairo's PDF surface backend feature [default=yes]"
)
set(use_pdf "no")
if(CAIRO_ENABLE_PDF)
  if(CAIRO_ENABLE_PDF STREQUAL "yes" AND NOT ZLIB_FOUND)
    message(FATAL_ERROR "PDF surface backend feature could not be enabled")
  endif()
  if(ZLIB_FOUND)
    # The pdf backend requires zlib.
    set(use_pdf "yes")
    set(CAIRO_HAS_PDF_SURFACE 1)
    list(APPEND CAIRO_LIBS ZLIB::ZLIB)
  endif()
endif()


# ===========================================================================

set(test_pdf "no")
# TODO:
#set(CAIRO_CAN_TEST_PDF_SURFACE 1)


# ===========================================================================

#CAIRO_ENABLE_SURFACE_BACKEND(svg, SVG, yes,
set(CAIRO_ENABLE_SVG "yes" CACHE STRING
  "[no/auto/yes] Enable cairo's SVG surface backend feature [default=yes]"
)
set(use_svg "no (requires CAIRO_ENABLE_PNG)")
if(CAIRO_ENABLE_SVG)
  if(CAIRO_ENABLE_SVG STREQUAL "yes" AND NOT PNG_FOUND)
    message(FATAL_ERROR "SVG surface backend feature could not be enabled")
  endif()
  if(PNG_FOUND)
    set(use_svg "yes")
    set(CAIRO_HAS_SVG_SURFACE 1)
  endif()
endif()

set(test_svg "no")
# TODO:
#set(CAIRO_CAN_TEST_SVG_SURFACE 1)


# ===========================================================================

#CAIRO_ENABLE(test_surfaces, test surfaces, no)
set(CAIRO_ENABLE_TEST_SURFACES "no" CACHE STRING
  "[no/auto/yes] Enable cairo's test surfaces feature [default=no]"
)
set(test_surfaces "no")
# TODO:
#set(CAIRO_HAS_TEST_SURFACES 1)


# ===========================================================================

#CAIRO_ENABLE_SURFACE_BACKEND(image, image, always,
set(Pixman_REG_VER 0.36.0)
set(use_image "no (requires Pixman ${Pixman_REG_VER} https://cairographics.org/releases/)")
find_package(Pixman ${Pixman_REG_VER})
if(NOT PIXMAN_FOUND)
  message(FATAL_ERROR "image surface backend feature could not be enabled")
endif()
if(PIXMAN_FOUND)
  set(use_image "yes")
  set(CAIRO_HAS_IMAGE_SURFACE 1)
  list(INSERT CAIRO_LIBS 0 Pixman::Pixman)

  if(NOT PIXMAN_VERSION VERSION_LESS 0.27.1)
    set(HAS_PIXMAN_GLYPHS 1)
  endif()
endif()


# ===========================================================================

#CAIRO_ENABLE_SURFACE_BACKEND(mime, mime, always)
set(CAIRO_HAS_MIME_SURFACE 1)

#CAIRO_ENABLE_SURFACE_BACKEND(recording, recording, always)
set(CAIRO_HAS_RECORDING_SURFACE 1)

#CAIRO_ENABLE_SURFACE_BACKEND(observer, observer, always)
set(CAIRO_HAS_OBSERVER_SURFACE 1)

#CAIRO_ENABLE_SURFACE_BACKEND(tee, tee, no)
set(CAIRO_ENABLE_TEE "no" CACHE STRING
  "[no/auto/yes] Enable cairo's tee surface backend feature [default=no]"
)
set(use_tee "no")
if(CAIRO_ENABLE_TEE)
  if(CAIRO_ENABLE_TEE STREQUAL "yes" AND NOT ZLIB_FOUND)
    message(FATAL_ERROR "tee surface backend feature could not be enabled")
  endif()
  if(ZLIB_FOUND)
    set(use_tee "yes")
    set(CAIRO_HAS_TEE_SURFACE 1)
    list(APPEND CAIRO_LIBS ZLIB::ZLIB)
  endif()
endif()

#CAIRO_ENABLE_SURFACE_BACKEND(xml, xml, no,
set(CAIRO_ENABLE_XML "no" CACHE STRING
  "[no/auto/yes] Enable cairo's xml surface backend feature [default=no]"
)
set(use_xml "no")
if(CAIRO_ENABLE_XML)
  if(CAIRO_ENABLE_XML STREQUAL "yes" AND NOT ZLIB_FOUND)
    message(FATAL_ERROR "xml surface backend feature could not be enabled")
  endif()
  if(ZLIB_FOUND)
    set(use_xml "yes")
    set(CAIRO_HAS_XML_SURFACE 1)
    list(APPEND CAIRO_LIBS ZLIB::ZLIB)
  endif()
endif()


# ===========================================================================

#CAIRO_ENABLE_FONT_BACKEND(user, user, always)
set(CAIRO_HAS_USER_FONT 1)


# ===========================================================================
#
# This needs to be last on our list of features so that the pthread libs and flags
# gets prefixed in front of everything else in CAIRO_{CFLAGS,LIBS}.
#
#CAIRO_ENABLE(pthread, pthread, auto,
set(CAIRO_ENABLE_PTHREAD "auto" CACHE STRING
  "[no/auto/yes] Enable cairo's pthread feature [default=auto]"
)
set(use_pthread "no")
if(CAIRO_ENABLE_PTHREAD)
  find_package(Threads)
  if(CAIRO_ENABLE_PTHREAD STREQUAL "yes" AND NOT CMAKE_USE_PTHREADS_INIT)
    message(FATAL_ERROR "pthread requested but not found")
  endif()
  if(CMAKE_USE_PTHREADS_INIT)
    set(CAIRO_HAS_REAL_PTHREAD 1)
    set(CAIRO_HAS_PTHREAD 1)
    set(use_pthread "yes")
    if(use_pthread STREQUAL "yes" AND CAIRO_HAS_REAL_PTHREAD)
      set(HAVE_REAL_PTHREAD 1)
    endif()
    if(use_pthread STREQUAL "yes")
      set(HAVE_PTHREAD 1)
    endif()

    list(INSERT CAIRO_LIBS 0 Threads::Threads)
  endif()
endif()


# ===========================================================================
# Build gobject integration library

#CAIRO_ENABLE_FUNCTIONS(gobject, gobject, auto,
set(CAIRO_ENABLE_GOBJECT "auto" CACHE STRING
  "[no/auto/yes] Enable cairo's gobject functions feature [default=auto]"
)
set(use_gobject "no")
# TODO:
#set(CAIRO_HAS_GOBJECT_FUNCTIONS 1)


# ===========================================================================
# Default to quick testing during development, but force a full test before
# release

#AC_ARG_ENABLE(full-testing,
option(CAIRO_ENABLE_FULL_TESTING
"Sets the test suite to perform full testing by
default, which will dramatically slow down make
check, but is a *requirement* before release."
  OFF
)
# TODO:


# ===========================================================================
# Build the external converter if we have any of the test backends
# TODO:


# ===========================================================================
# Some utilities need to dlopen the shared libraries, so they need to
# know how libtools will name them
# TODO:
#set(SHARED_LIB_EXT "TODO")


# ===========================================================================
# The tracing utility requires LD_PRELOAD, so only build it for systems
# that are known to work.
# TODO:

#CAIRO_ENABLE(trace, cairo-trace, auto,
set(CAIRO_ENABLE_TRACE "auto" CACHE STRING
  "[no/auto/yes] Enable cairo's cairo-trace feature [default=auto]"
)
set(use_trace "no")
# TODO:
#set(CAIRO_HAS_TRACE 1)

#CAIRO_ENABLE(interpreter, cairo-script-interpreter, yes,
set(CAIRO_ENABLE_INTERPRETER "yes" CACHE STRING
  "[no/auto/yes] Enable cairo's cairo-script-interpreter feature [default=yes]"
)
set(use_interpreter "no")
# TODO:

#AC_CHECK_LIB(bfd, bfd_openr,
# TODO:
#set(CAIRO_HAS_INTERPRETER 1)
#set(HAVE_BFD 1)

#CAIRO_ENABLE(symbol_lookup, symbol-lookup, auto,
set(CAIRO_ENABLE_SYMBOL_LOOKUP "auto" CACHE STRING
  "[no/auto/yes] Enable cairo's symbol-lookup feature [default=auto]"
)
set(use_symbol_lookup "no")
# TODO:
#set(CAIRO_HAS_SYMBOL_LOOKUP 1)

#AM_CONDITIONAL(BUILD_SPHINX
# TODO:

#AC_CHECK_LIB(rt, shm_open, shm_LIBS="-lrt")
# TODO:
#set(HAVE_LIBRT 1)


# ===========================================================================

#AC_ARG_ENABLE(some-floating-point,
option(CAIRO_DISABLE_SOME_FLOATING_POINT
"Disable certain code paths that rely heavily on
double precision floating-point calculation. This
option can improve performance on systems without a
double precision floating-point unit, but might
degrade performance on those that do."
  OFF
)
if(CAIRO_DISABLE_SOME_FLOATING_POINT)
  set(DISABLE_SOME_FLOATING_POINT 1)
endif()


# ===========================================================================

# Extra stuff we need to do when building C++ code
# TODO:


# ===========================================================================

# We use GTK+ for some utility/debugging tools
# TODO:


# ===========================================================================
# From CMakePorts, used in config.h.cmake

check_include_file("memory.h" HAVE_MEMORY_H)
check_include_file("stdlib.h" HAVE_STDLIB_H)
check_include_file("strings.h" HAVE_STRINGS_H)
check_include_file("string.h" HAVE_STRING_H)
check_include_file("sys/types.h" HAVE_SYS_TYPES_H)

check_function_exists(poppler_page_render HAVE_POPPLER_PAGE_RENDER)
check_function_exists(rsvg_pixbuf_from_file HAVE_RSVG_PIXBUF_FROM_FILE)


# ===========================================================================

list(APPEND CAIRO_DEFS HAVE_CONFIG_H)

configure_file(
  ${CMAKE_CURRENT_LIST_DIR}/config.h.cmake
  ${PROJECT_BINARY_DIR}/config.h
)

configure_file(
  ${CMAKE_CURRENT_LIST_DIR}/cairo-features.h.cmake
  ${PROJECT_BINARY_DIR}/src/cairo-features.h
)

cairo_report()
