#
# Copyright (C) 2015 Mark Charlebois. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright
#	notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#	notice, this list of conditions and the following disclaimer in
#	the documentation and/or other materials provided with the
#	distribution.
# 3. Neither the name ATLFlight nor the names of its contributors may be
#	used to endorse or promote products derived from this software
#	without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
# OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
# AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#

include(CMakeForceCompiler)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/../cmake)

set(TOOLS_ERROR_MSG
	"The Hexagon SDK 3.2 must be installed and the environment variable HEXAGON_SDK_ROOT must be set"
	"(e.g. export HEXAGON_SDK_ROOT=${HOME}/Qualcomm/Hexagon_SDK/3.2)")

if ("$ENV{HEXAGON_SDK_ROOT}" STREQUAL "")
	message(FATAL_ERROR ${TOOLS_ERROR_MSG})
else()
	set(HEXAGON_TOOLS_ROOT $ENV{HEXAGON_SDK_ROOT}/tools/HEXAGON_Tools/8.0.10/Tools)
endif()

macro (list2string out in)
	set(list ${ARGV})
	list(REMOVE_ITEM list ${out})
	foreach(item ${list})
		set(${out} "${${out}} ${item}")
	endforeach()
endmacro(list2string)

set(V_ARCH "v5")
set(CROSSDEV "hexagon-")

# Detect compiler version
if(${HEXAGON_TOOLS_ROOT} MATCHES "HEXAGON_Tools/8.0")

	# Use the HexagonTools compiler (7.2.12) from Hexagon 3.0 SDK
	set(HEXAGON_BIN	${HEXAGON_TOOLS_ROOT}/bin)
	set(HEXAGON_ISS_DIR ${HEXAGON_TOOLS_ROOT}/lib/iss)
set(TOOLSLIB ${HEXAGON_TOOLS_ROOT}/target/hexagon/lib/${V_ARCH}/G0/pic)

	set(CMAKE_C_COMPILER	${HEXAGON_BIN}/${CROSSDEV}clang)
	set(CMAKE_CXX_COMPILER  ${HEXAGON_BIN}/${CROSSDEV}clang++)

	set(CMAKE_AR	  ${HEXAGON_BIN}/${CROSSDEV}ar CACHE FILEPATH "Archiver")
	set(CMAKE_RANLIB  ${HEXAGON_BIN}/${CROSSDEV}ranlib)
	set(CMAKE_NM	  ${HEXAGON_BIN}/${CROSSDEV}nm)
	set(CMAKE_OBJDUMP ${HEXAGON_BIN}/${CROSSDEV}objdump)
	set(CMAKE_OBJCOPY ${HEXAGON_BIN}/${CROSSDEV}objcopy)
	set(HEXAGON_LINK  ${HEXAGON_BIN}/${CROSSDEV}link)
set(HEXAGON_ARCH_FLAGS
	-march=hexagon
	-mcpu=hexagonv5
	)

else()
	message(FATAL_ERROR ${TOOLS_ERROR_MSG})
endif()

set(CMAKE_SKIP_RPATH TRUE CACHE BOOL SKIP_RPATH FORCE)

# where is the target environment
set(CMAKE_FIND_ROOT_PATH  get_file_component(${C_COMPILER} PATH))

set(CMAKE_C_COMPILER_ID, "Clang")
set(CMAKE_CXX_COMPILER_ID, "Clang")

# search for programs in the build host directories
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)

# for libraries and headers in the target directories
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# The Hexagon compiler doesn't support the -rdynamic flag and this is set
# in the base cmake scripts. We have to redefine the __linux_compiler_gnu
# macro for cmake 2.8 to work
set(__LINUX_COMPILER_GNU 1)

macro(__linux_compiler_gnu lang)
	set(CMAKE_SHARED_LIBRARY_LINK_${lang}_FLAGS "")
endmacro()

