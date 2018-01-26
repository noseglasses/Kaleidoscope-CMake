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

# Travis testing settings
#
set(travis_arduino "arduino-1.8.5")

if(CMAKE_HOST_UNIX)
   set(travis_arduino_file "${travis_arduino}-linux64.tar.xz")
elseif(CMAKE_HOST_APPLE)
   set(travis_arduino_file "${travis_arduino}-macosx.zip")
elseif(CMAKE_HOST_WIN32)
   set(travis_arduino_file "${travis_arduino}-windows.zip")
endif()

set(travis_arduino_path "${CMAKE_BINARY_DIR}/${travis_arduino}")
set(travis_arduino_download_url "http://downloads.arduino.cc/${travis_arduino_file}")