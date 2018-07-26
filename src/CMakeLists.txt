find_package(LibUSB REQUIRED)
find_package(libftdi1 REQUIRED)
find_package(SWIG QUIET)

add_library(mpsse SHARED
  mpsse.c
  support.c
  fast.c
)

add_definitions(-DLIBFTDI1=1)

configure_file(config.h.in config.h)

target_sources(mpsse PRIVATE mpsse.h)
target_sources(mpsse PRIVATE support.h)
target_link_libraries(mpsse libusb-1.0 libftdi1::core)
target_include_directories(mpsse PRIVATE ${CMAKE_CURRENT_BINARY_DIR})

option(BUILD_PYTHON_BINDINGS "Build Python bindings" ON)
if(SWIG_FOUND AND BUILD_PYTHON_BINDINGS)
  find_package(Python COMPONENTS Interpreter Development)
  if(Python_FOUND)
    include(UseSWIG)
    swig_add_library(pylibmpsse LANGUAGE python SOURCES mpsse.i)
    swig_link_libraries(pylibmpsse mpsse Python::Python)
  endif()
endif()

