cmake_minimum_required(VERSION 3.14...${CMAKE_VERSION})

set(CMAKE_CURRENT_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/flac)
set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")

include(${CMAKE_CURRENT_SOURCE_DIR}/CMakeLists.txt)
