
cmake_minimum_required(VERSION 3.4)

project(SFMLPlaygGround)

set(SFML_DIR "${CMAKE_CURRENT_SOURCE_DIR}/external/SFML-2.5.1")
set(SFML_DLL "${CMAKE_CURRENT_SOURCE_DIR}/external/SFML-2.5.1/bin")
set(SFML_INCLUDE "${SFML_DIR}/include")

set(ASSETS "${CMAKE_CURRENT_SOURCE_DIR}/assets")

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${SFML_DIR}/lib/cmake/SFML")
include(SFMLSharedTargets)


include_directories(${SFML_INCLUDE})
link_libraries(sfml-graphics sfml-audio)

add_subdirectory(source)