cmake_minimum_required(VERSION 3.0.0)
set(CMAKE_GNUtoMS 1)
project(libmpsse
        VERSION 1.4.0)

set(CMAKE_CXX_STANDARD 11)
include(InstallRequiredSystemLibraries)

set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake/modules ${CMAKE_MODULE_PATH})

add_subdirectory(src)


