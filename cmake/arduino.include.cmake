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

set(KALEIDOSCOPE_DOWNLOAD_ARDUINO FALSE CACHE BOOL "If this flag is \
enabled, the build system downloads Arduino.")

if(KALEIDOSCOPE_DOWNLOAD_ARDUINO)

   if(NOT EXISTS "${travis_arduino_path}")
      message("Installing Arduino...")
      message("   Downloading ${travis_arduino_download_url}")
      file(DOWNLOAD "${travis_arduino_download_url}" "${CMAKE_BINARY_DIR}/${travis_arduino_file}")
      
      execute_process(
         COMMAND "${CMAKE_COMMAND}" -E tar xf "${CMAKE_BINARY_DIR}/${travis_arduino_file}"
         RESULT_VARIABLE result
         OUTPUT_VARIABLE output
         ERROR_VARIABLE error
         WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
      )
      
      if(NOT result EQUAL 0)
         message("Extraction of Arduino archive ${CMAKE_BINARY_DIR}/${travis_arduino_file} failed")
         message("   result: ${result}")
         message("   output: ${output}")
         message("   error: ${error}")
         message(FATAL_ERROR "Bailing out.")
      endif()
   endif()
   
   set(ARDUINO_SDK_PATH "${travis_arduino_path}" CACHE PATH "")
endif()

# Make sure that the correct avr-gcc of the arduino installation
# is found. To achieve this we add the path to the Arduino SDK to
# CMAKE_PREFIX_PATH, which is the path list that CMake uses to search for
# binaries, libraries, etc.
#
# Note: To do this right the toolchain file would need to be modified
#       to use the actually determined ARDUINO_SDK_PATH to 
#       define CMAKE_PREFIX_PATH.
#
if(KALEIDOSCOPE_DOWNLOAD_ARDUINO OR (NOT "${ARDUINO_SDK_PATH}" STREQUAL ""))
   set(CMAKE_PREFIX_PATH "${ARDUINO_SDK_PATH}/hardware/tools/avr;${CMAKE_PREFIX_PATH}")
elseif(NOT "$ENV{ARDUINO_PATH}" STREQUAL "")
   set(CMAKE_PREFIX_PATH "$ENV{ARDUINO_PATH}/hardware/tools/avr;${CMAKE_PREFIX_PATH}")
elseif(NOT "$ENV{ARDUINO_SDK_PATH}" STREQUAL "")
   set(CMAKE_PREFIX_PATH "$ENV{ARDUINO_SDK_PATH}/hardware/tools/avr;${CMAKE_PREFIX_PATH}")
endif()