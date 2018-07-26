# FindLibftdi1.cmake
#
# CMake support for Ftdi.
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

find_package(libftdi1 CONFIG)

if(libftdi1_FIND_VERSION)
  set(libftdi1_FAILED_VERSION_CHECK true)
  
  if(libftdi1_FIND_VERSION_EXACT)
    if(LIBFTDI_VERSION_STRING  VERSION_EQUAL  libftdi1_FIND_VERSION)
      set(libftdi1_FAILED_VERSION_CHECK false)
    endif()
  else()
    if(LIBFTDI_VERSION_STRING  VERSION_EQUAL  libftdi1_FIND_VERSION OR
       LIBFTDI_VERSION_STRING VERSION_GREATER libftdi1_FIND_VERSION)
      set(libftdi1_FAILED_VERSION_CHECK false)
    endif()
  endif()

  if(libftdi1_FAILED_VERSION_CHECK)
    if(libftdi1_FIND_REQUIRED AND NOT libftdi1_FIND_QUIETLY)
      if(libftdi1_FIND_VERSION_EXACT)
        message(FATAL_ERROR "libftdi1 version check failed.  Version ${LIBFTDI_VERSION_STRING} was found, version ${libftdi1_FIND_VERSION} is needed exactly.")
      else()
        message(FATAL_ERROR "GStreamer version check failed.  Version ${LIBFTDI_VERSION_STRING} was found, at least version ${libftdi1_FIND_VERSION} is required")
      endif()
    endif()    
    
    # If the version check fails, exit out of the module here
    return()
  endif()
endif()

if(LIBFTDI_FOUND)
  set(libftdi1_FOUND 1)
  add_library(libftdi1::core SHARED IMPORTED)
  set_property(TARGET libftdi1::core PROPERTY
        INTERFACE_INCLUDE_DIRECTORIES
          ${LIBFTDI_INCLUDE_DIRS}
      )
  if(LIBFTDI_LIBRARIES)
    list(REMOVE_ITEM LIBFTDI_LIBRARIES ${LIBFTDI_LIBRARY})
    set_property(TARGET libftdi1::core PROPERTY
        TARGET_LINK_LIBRARIES
          ${LIBFTDI_LIBRARIES}
      )
  endif()

  add_library(libftdi1::pp SHARED IMPORTED)
  set_property(TARGET libftdi1::pp PROPERTY
        INTERFACE_INCLUDE_DIRECTORIES
          ${LIBFTDI_INCLUDE_DIRS}
  )
  if(LIBFTDIPP_LIBRARIES)
    list(REMOVE_ITEM LIBFTDIPP_LIBRARIES ${LIBFTDI_LIBRARY})
    set_property(TARGET libftdi1::pp PROPERTY
        TARGET_LINK_LIBRARIES
          ${LIBFTDIPP_LIBRARIES}
        )
    endif()
  
  if(DEFINED CMAKE_IMPORT_LIBRARY_SUFFIX)
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_IMPORT_LIBRARY_SUFFIX})
    find_library(LIBFTDI1_LIBRARY_IMPLIB NAMES ${LIBFTDI_LIBRARY}
      PATHS
        ${LIBFTDI1_ROOT}/lib
        ${LIBFTDI_LIBRARY_DIRS}
    )
    if(LIBFTDI1_LIBRARY_IMPLIB)
      set_property(TARGET libftdi1::core PROPERTY IMPORTED_IMPLIB "${LIBFTDI1_LIBRARY_IMPLIB}")
      set(LIBFTDI1_LIBRARIES ${LIBFTDI1_LIBRARIES} ${LIBFTDI1_LIBRARY_IMPLIB})
      mark_as_advanced(LIBFTDI1_LIBRARY_IMPLIB)
    endif()

    find_library(LIBFTDI1PP_LIBRARY_IMPLIB NAMES ${LIBFTDIPP_LIBRARY}
      PATHS
        ${LIBFTDI1_ROOT}/lib
        ${LIBFTDI_LIBRARY_DIRS}
    )
    if(LIBFTDI1PP_LIBRARY_IMPLIB)
      set_property(TARGET libftdi1::pp PROPERTY IMPORTED_IMPLIB "${LIBFTDI1PP_LIBRARY_IMPLIB}")
      set(LIBFTDI1_LIBRARIES ${LIBFTDI1_LIBRARIES} ${LIBFTDI1PP_LIBRARY_IMPLIB})
      mark_as_advanced(LIBFTDI1PP_LIBRARY_IMPLIB)
    endif()
  endif()
  
  set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_SHARED_LIBRARY_SUFFIX})
  find_library(LIBFTDI1_LIBRARY_SHARED
    NAMES
      ${LIBFTDI_LIBRARY}
      ${CMAKE_SHARED_LIBRARY_PREFIX}${LIBFTDI_LIBRARY}
    PATHS 
      ${LIBFTDI_LIBRARY_DIRS}
      ${LIBFTDI1_ROOT}
    PATH_SUFFIXES
      lib
      bin
  )
  if(LIBFTDI1_LIBRARY_SHARED)
    set_property(TARGET libftdi1::core PROPERTY IMPORTED_LOCATION "${LIBFTDI1_LIBRARY_SHARED}")
    if(NOT LIBFTDI1_LIBRARY_IMPLIB)
      set(LIBFTDI1_LIBRARIES ${LIBFTDI1_LIBRARIES} ${LIBFTDI1_LIBRARY_SHARED})
    endif()
    mark_as_advanced(LIBFTDI1_LIBRARY_SHARED)
  endif()

  find_library(LIBFTDI1PP_LIBRARY_SHARED
    NAMES
      ${LIBFTDIPP_LIBRARY}
      ${CMAKE_SHARED_LIBRARY_PREFIX}${LIBFTDIPP_LIBRARY}
    PATHS 
      ${LIBFTDI_LIBRARY_DIRS}
      ${LIBFTDI1_ROOT}
    PATH_SUFFIXES
      lib
      bin
  )
  if(LIBFTDI1PP_LIBRARY_SHARED)
    set_property(TARGET libftdi1::pp PROPERTY IMPORTED_LOCATION "${LIBFTDI1PP_LIBRARY_SHARED}")
    if(NOT LIBFTDI1PP_LIBRARY_IMPLIB)
      set(LIBFTDI1_LIBRARIES ${LIBFTDI1_LIBRARIES} ${LIBFTDI1PP_LIBRARY_SHARED})
    endif()
    mark_as_advanced(LIBFTDI1PP_LIBRARY_SHARED)
  endif()
endif(LIBFTDI_FOUND)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(libftdi1
    REQUIRED_VARS
      LIBFTDI1_LIBRARIES
      LIBFTDI_INCLUDE_DIRS
    VERSION_VAR
      LIBFTDI_VERSION_STRING)

