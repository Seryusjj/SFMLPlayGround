
cmake_minimum_required(VERSION 3.8)

project(SFMLPlayGround)
#Only x64 is supported
set(CMAKE_GENERATOR_PLATFORM x64)
#options
set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "set Debug or Release build, the 3rd party will be compiled as such")

#SFML lib
set(SFML_DIR "${CMAKE_CURRENT_SOURCE_DIR}/external/SFML-2.5.1")
set(SFML_DLL "${CMAKE_CURRENT_SOURCE_DIR}/external/SFML-2.5.1/bin")
set(SFML_INCLUDE "${SFML_DIR}/include")

#enable differt modules and custom functions
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${SFML_DIR}/lib/cmake/SFML")
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
include(SFMLSharedTargets)
include(ExternalProject)
include(BuildFreetypeAndSetEnv)
include(BuildGLFWAndSetEnv)
include(BuildBulletAndSetEnv)

#Assets folder
set(ASSETS "${CMAKE_CURRENT_SOURCE_DIR}/assets")

#glad opengl loader (can replace GLEW)
set(GLAD_DIR ${CMAKE_CURRENT_SOURCE_DIR}/external/glad)
set(GLAD_INCLUDE_DIR ${GLAD_DIR}/include)
set(GLAD_SRC_DIR ${GLAD_DIR}/src)

#shared GLEW precompiled -> TODO: replace with glad
set(GLEW_DIR "${CMAKE_CURRENT_SOURCE_DIR}/external/glew-2.1.0")
set(GLEW_DLL "${GLEW_DIR}/bin/Release/x64/glew32.dll")
set(GLEW_LIB "${GLEW_DIR}/lib/Release/x64/glew32.lib")
set(GLEW_INCLUDE "${GLEW_DIR}/include")

#shared lib GLFW
build_glfw_and_set_env()

#glm header only lib
set(GLFM_DIR "${CMAKE_CURRENT_SOURCE_DIR}/external/glm")
set(GLM_INCLUDE "${GLFM_DIR}")
find_package(OpenGL REQUIRED)


#bullet 3
build_bullet_and_set_env()

#include STB lib header only lib
set(STB_INCLUDE ${CMAKE_CURRENT_SOURCE_DIR}/external/stb)

#build and add freetype
build_freetype_and_set_env()

#global includes and links for all projects
include_directories(${SFML_INCLUDE} ${GLEW_INCLUDE} ${GLFW_INCLUDE} ${GLM_INCLUDE})
link_libraries(sfml-graphics sfml-audio ${GLEW_LIB} glfw ${OPENGL_LIBRARIES} ${FREETYPE_LIBRARIES})

#add different projects
add_subdirectory(source)