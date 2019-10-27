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

# Part of "LibCMaker/cmake/cmr_get_download_params.cmake".

  if(version VERSION_EQUAL "1.17.2")
    set(arch_file_sha
      "c5d6f12701f23b2dc2988a5a5586848e70e858fe")
  endif()

  # https://www.cairographics.org/releases/cairo-1.16.0.tar.xz
  # https://cairographics.org/snapshots/cairo-1.17.2.tar.xz

  set(base_url "https://cairographics.org/snapshots")
  set(src_dir_name    "cairo-${version}")
  set(arch_file_name  "${src_dir_name}.tar.xz")
  set(unpack_to_dir   "${unpacked_dir}/${src_dir_name}")

  set(${out_ARCH_SRC_URL}   "${base_url}/${arch_file_name}" PARENT_SCOPE)
  set(${out_ARCH_DST_FILE}  "${download_dir}/${arch_file_name}" PARENT_SCOPE)
  set(${out_ARCH_FILE_SHA}  "${arch_file_sha}" PARENT_SCOPE)
  set(${out_SHA_ALG}        "SHA1" PARENT_SCOPE)
  set(${out_UNPACK_TO_DIR}  "${unpack_to_dir}" PARENT_SCOPE)
  set(${out_UNPACKED_SOURCES_DIR}
    "${unpack_to_dir}/${src_dir_name}" PARENT_SCOPE
  )
  set(${out_VERSION_BUILD_DIR} "${build_dir}/${src_dir_name}" PARENT_SCOPE)
