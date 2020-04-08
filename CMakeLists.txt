
cmake_minimum_required(VERSION 3.8)

project(SFMLPlayGround)

set(ASSETS "${CMAKE_CURRENT_SOURCE_DIR}/assets")

set(SFML_DIR "${CMAKE_CURRENT_SOURCE_DIR}/external/SFML-2.5.1")
set(SFML_DLL "${CMAKE_CURRENT_SOURCE_DIR}/external/SFML-2.5.1/bin")
set(SFML_INCLUDE "${SFML_DIR}/include")

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${SFML_DIR}/lib/cmake/SFML")
include(SFMLSharedTargets)


#shared GLEW
set(GLEW_DIR "${CMAKE_CURRENT_SOURCE_DIR}/external/glew-2.1.0")
set(GLEW_DLL "${GLEW_DIR}/bin/Release/x64/glew32.dll")
set(GLEW_LIB "${GLEW_DIR}/lib/Release/x64/glew32.lib")
set(GLEW_INCLUDE "${GLEW_DIR}/include")


#shared lib GLFW
set(GLFW_DIR "${CMAKE_CURRENT_SOURCE_DIR}/external/glfw-3.3.2")
set(GLFW_DLL "${GLFW_DIR}/lib-vc2017/glfw3.dll")
set(GLFW_LIB "${GLFW_DIR}/lib-vc2017/glfw3dll.lib")
set(GLFW_INCLUDE "${GLFW_DIR}/include")

#glm header only lib
set(GLFM_DIR "${CMAKE_CURRENT_SOURCE_DIR}/external/glm")
set(GLM_INCLUDE "${GLFM_DIR}")
find_package(OpenGL REQUIRED)

include_directories(${SFML_INCLUDE} ${GLEW_INCLUDE} ${GLFW_INCLUDE} ${GLM_INCLUDE})
link_libraries(sfml-graphics sfml-audio ${GLEW_LIB} ${GLFW_LIB} ${OPENGL_LIBRARIES})

add_subdirectory(source)