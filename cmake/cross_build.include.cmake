#  -*- mode: cmake -*-
# Leidokos-CMake -- An alternative build system that
#    enables building Kaleidoscope with CMake
# Copyright (C) 2017 noseglasses <shinynoseglasses@gmail.com>
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# The toolchain file is used when the project is initialized using
# the project(...) directive further down.
#
set(KALEIDOSCOPE_HOST_BUILD FALSE CACHE BOOL "Enable this flag in the \
rare case that you want to build for the host system instead of the \
Arduino architecture (virtual builds).")

if(NOT KALEIDOSCOPE_HOST_BUILD)
   set(CMAKE_TOOLCHAIN_FILE 
      "${LEIDOKOS_CMAKE_SOURCE_DIR}/3rd_party/arduino-cmake/cmake/ArduinoToolchain.cmake")

   # Add some additional compiler command line flags that are needed
   # to build Kaleidoscope.
   #
   set(ARDUINO_C_FLAGS "\
   -std=gnu11 \
   -mcall-prologues \
   -ffunction-sections \
   -fdata-sections \
   " CACHE INTERNAL "")
   
   set(ARDUINO_CXX_FLAGS "\
   -std=gnu++11 \
   -Wall \
   -Wextra \
   -fno-threadsafe-statics \
   -fno-exceptions \
   -ffunction-sections \
   -fdata-sections\
   "
	CACHE INTERNAL "")

   set(ARDUINO_LIBRARIES_PATH 
"$ENV{ARDUINO_SDK_PATH}/hardware/arduino/avr/libraries" CACHE INTERNAL "")
else()

   # Define empty flags. Else Arduino-CMake will define something Arduino
   # specific, which we have to avoid for host builds.
   #
   set(ARDUINO_C_FLAGS "\
   -std=gnu11 \
   -DARDUINO_VIRTUAL\
   " CACHE INTERNAL "")
   
   # Note: -Wno-missing-braces is necessary to build with clang/XCode
   #       as most definitions of instances of class Key in Kaleidoscope
   #       are ill-formed.
   #
   # Note: -Wnoc++11-narrowing: We have to silence a lot of narrowing conversion errors issued by
   # clang that are due to missing casts in most of Kaleidoscope's Key defintions.
   #
   set(ARDUINO_CXX_FLAGS "\
   -std=gnu++11 \
   -Wall \
   -Wextra \
   -Wno-missing-braces \
   -Wno-c++11-narrowing \
   -DARDUINO_VIRTUAL \
   " CACHE INTERNAL "")
   
   set(ARDUINO_LIBRARIES_PATH "___dummy__")
   set(ARDUINO_SDK_PATH "___dummy__")
   set(ARDUINO_CMAKE_SKIP_DETECT_VERSION TRUE CACHE INTERNAL "")
   set(ARDUINO_CMAKE_SKIP_TEST_SETUP TRUE CACHE INTERNAL "")
   set(ARDUINO_PLATFORM_LIBRARIES_PATH CACHE INTERNAL "")
   
   # Include Arduino.cmake directly to avoid Arduino toolchain setup as
   # it would be performed through defining CMAKE_TOOLCHAIN_FILE
   # as done in the platform build setup above.
   #
   include("${LEIDOKOS_CMAKE_SOURCE_DIR}/3rd_party/arduino-cmake/cmake/Platform/Arduino.cmake")
endif()
