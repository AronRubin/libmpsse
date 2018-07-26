# FindLibUSB.cmake
#
# CMake support for LibUSB.
#
# License:
#
#   Copyright (c) 2018 Aron Rubin <aronrubin@gmail.com>
#
#   Permission is hereby granted, free of charge, to any person
#   obtaining a copy of this software and associated documentation
#   files (the "Software"), to deal in the Software without
#   restriction, including without limitation the rights to use, copy,
#   modify, merge, publish, distribute, sublicense, and/or sell copies
#   of the Software, and to permit persons to whom the Software is
#   furnished to do so, subject to the following conditions:
#
#   The above copyright notice and this permission notice shall be
#   included in all copies or substantial portions of the Software.
#
#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
#   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#   NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
#   HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
#   WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
#   DEALINGS IN THE SOFTWARE.

macro(hexchar2dec VAR VAL)
    if (${VAL} MATCHES "[0-9]")
        set(${VAR} ${VAL})
    elseif(${VAL} MATCHES "[aA]")
        set(${VAR} 10)
    elseif(${VAL} MATCHES "[bB]")
        set(${VAR} 11)
    elseif(${VAL} MATCHES "[cC]")
        set(${VAR} 12)
    elseif(${VAL} MATCHES "[dD]")
        set(${VAR} 13)
    elseif(${VAL} MATCHES "[eE]")
        set(${VAR} 14)
    elseif(${VAL} MATCHES "[fF]")
        set(${VAR} 15)
    else()
        message(FATAL_ERROR "Invalid format for hexidecimal character")
    endif()
endmacro()

function(hex2dec VAR HEXVAL)
  set(decval 0)
  if (NOT ${HEXVAL} EQUAL 0)
    set(CURINDEX 0)
    string(LENGTH "${HEXVAL}" CURLENGTH)
    while (CURINDEX LESS CURLENGTH)
      string(SUBSTRING "${HEXVAL}" ${CURINDEX} 1 CHAR)
      hexchar2dec(CHAR ${CHAR})
      math(EXPR POWAH "(1 << ((${CURLENGTH} - ${CURINDEX} - 1)*4))")
      math(EXPR CHAR "(${CHAR}*${POWAH})")
      math(EXPR decval "${decval} + ${CHAR}")
      math(EXPR CURINDEX "${CURINDEX} + 1")
    endwhile()
  endif()
  set(${VAR} ${decval} PARENT_SCOPE)
endfunction()

find_package(PkgConfig)

if(PKG_CONFIG_FOUND)
  pkg_check_modules(LibUSB_PKG libusb-1.0)
endif()

find_library(LibUSB_LIBRARY usb-1.0 HINTS ${LibUSB_PKG_LIBRARY_DIRS})

if(LibUSB_LIBRARY)
  add_library(libusb1 SHARED IMPORTED)
  set_property(TARGET libusb1 PROPERTY IMPORTED_LOCATION "${LibUSB_LIBRARY}")
  set_property(TARGET libusb1 PROPERTY INTERFACE_COMPILE_OPTIONS "${LibUSB_PKG_CFLAGS_OTHER}")

  set(LibUSB_INCLUDE_DIRS)

  find_path(LibUSB_INCLUDE_DIR "libusb.h"
    HINTS ${LibUSB_PKG_INCLUDE_DIRS})

  if(LibUSB_INCLUDE_DIR)
    file(STRINGS "${LibUSB_INCLUDE_DIR}/libusb.h" LibUSB_VERSION_HEX REGEX "^#define LIBUSB_API_VERSION +\\(?(0x[0-9]+)\\)?$")
    if(LibUSB_VERSION_HEX MATCHES "^#define LIBUSB_API_VERSION 0x([0-9A-Za-z][0-9A-Za-z])([0-9A-Za-z][0-9A-Za-z])([0-9A-Za-z][0-9A-Za-z][0-9A-Za-z][0-9A-Za-z])$")
      hex2dec(LibUSB_VERSION_MAJOR ${CMAKE_MATCH_1})
      hex2dec(LibUSB_VERSION_MINOR ${CMAKE_MATCH_2})
      hex2dec(LibUSB_VERSION_MICRO ${CMAKE_MATCH_3})
      set(LibUSB_VERSION "${LibUSB_VERSION_MAJOR}.${LibUSB_VERSION_MINOR}.${LibUSB_VERSION_MICRO}")
      unset(LibUSB_VERSION_MAJOR)
      unset(LibUSB_VERSION_MINOR)
      unset(LibUSB_VERSION_MICRO)
    else()
      set(LibUSB_VERSION "1.0")
    endif()
    list(APPEND LibUSB_INCLUDE_DIRS ${LibUSB_INCLUDE_DIR})
    set_property(TARGET libusb1 PROPERTY INTERFACE_INCLUDE_DIRECTORIES "${LibUSB_INCLUDE_DIR}")
  endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(LibUSB
    REQUIRED_VARS
      LibUSB_LIBRARY
      LibUSB_INCLUDE_DIRS
    VERSION_VAR
      LibUSB_VERSION)
