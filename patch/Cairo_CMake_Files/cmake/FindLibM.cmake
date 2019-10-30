#.rst:
# FindLibM
# --------
#
# Find the native realtime includes and library.
#
# IMPORTED Targets
# ^^^^^^^^^^^^^^^^
#
# This module defines :prop_tgt:`IMPORTED` target ``LIBM::LIBM``,
# if LIBM has been found.
#
# Result Variables
# ^^^^^^^^^^^^^^^^
#
# This module defines the following variables:
#
# ::
#
#   LIBM_LIBRARIES     - List of libraries when using libm.
#   LIBM_FOUND         - True if math library found.

find_library(LIBM_LIBRARIES
  NAMES m
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(LibM DEFAULT_MSG LIBM_LIBRARIES)
mark_as_advanced(LIBM_LIBRARIES)

if(LIBM_FOUND)
  if(NOT TARGET LIBM::LIBM)
    add_library(LIBM::LIBM UNKNOWN IMPORTED)
    set_target_properties(LIBM::LIBM PROPERTIES
      IMPORTED_LOCATION "${LIBM_LIBRARIES}"
    )
  endif()
endif()
