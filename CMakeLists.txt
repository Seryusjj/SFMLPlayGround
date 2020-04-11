
cmake_minimum_required(VERSION 3.8)

project(SFMLPlayGround)
#Only x64 is supported
set(CMAKE_GENERATOR_PLATFORM x64)
#options
set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "se Debug or Release build, the 3trd party will be compiled as such")

set(ASSETS "${CMAKE_CURRENT_SOURCE_DIR}/assets")

set(SFML_DIR "${CMAKE_CURRENT_SOURCE_DIR}/external/SFML-2.5.1")
set(SFML_DLL "${CMAKE_CURRENT_SOURCE_DIR}/external/SFML-2.5.1/bin")
set(SFML_INCLUDE "${SFML_DIR}/include")

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${SFML_DIR}/lib/cmake/SFML")
include(SFMLSharedTargets)
include(ExternalProject)


#shared GLEW precompiled
set(GLEW_DIR "${CMAKE_CURRENT_SOURCE_DIR}/external/glew-2.1.0")
set(GLEW_DLL "${GLEW_DIR}/bin/Release/x64/glew32.dll")
set(GLEW_LIB "${GLEW_DIR}/lib/Release/x64/glew32.lib")
set(GLEW_INCLUDE "${GLEW_DIR}/include")


#shared lib GLFW precompiled
set(GLFW_DIR "${CMAKE_CURRENT_SOURCE_DIR}/external/glfw-3.3.2")
set(GLFW_DLL "${GLFW_DIR}/lib-vc2017/glfw3.dll")
set(GLFW_LIB "${GLFW_DIR}/lib-vc2017/glfw3dll.lib")
set(GLFW_INCLUDE "${GLFW_DIR}/include")

#glm header only lib
set(GLFM_DIR "${CMAKE_CURRENT_SOURCE_DIR}/external/glm")
set(GLM_INCLUDE "${GLFM_DIR}")
find_package(OpenGL REQUIRED)


#bullet 3
set(BULLET_DIR ${CMAKE_CURRENT_SOURCE_DIR}/external/bullet3)
set(BULLET_BUILD_DIR ${BULLET_DIR}/build)
set(BULLET_INSTALL_DIR ${BULLET_BUILD_DIR}/install)

set(BULET_CACHE_ARGS 
        -DBUILD_SHARED_LIBS:BOOL=OFF 
        -DINSTALL_LIBS:BOOL=ON
		-DUSE_MSVC_RUNTIME_LIBRARY_DLL:BOOL=ON
        -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX:STRING=${BULLET_INSTALL_DIR}
        -DCMAKE_GENERATOR_PLATFORM:STRING=${CMAKE_GENERATOR_PLATFORM}
        -DCMAKE_GENERATOR:STRING=${CMAKE_GENERATOR}		
        -DBUILD_CPU_DEMOS:BOOL=OFF
        -DBUILD_OPENGL3_DEMOS:BOOL=OFF
        -DBUILD_UNIT_TESTS:BOOL=OFF
        -DBUILD_PYBULLET:BOOL=OFF
        -DBUILD_CLSOCKET:BOOL=OFF
        -DUSE_GRAPHICAL_BENCHMARK:BOOL=OFF
        -DBUILD_ENET:BOOL=OFF
        -DBUILD_BULLET2_DEMOS:BOOL=OFF	
        -DBUILD_EXTRAS:BOOL=OFF)
set(BULLET_CONFIG "${BULLET_INSTALL_DIR}/lib/cmake/bullet/BulletConfig.cmake")
# configure static bullet library
if (EXISTS ${BULLET_CONFIG})
	include(${BULLET_CONFIG})
elseif(NOT EXISTS ${BULLET_BUILD_DIR})
	file(MAKE_DIRECTORY ${BULLET_BUILD_DIR})
endif()

if(NOT BULLET_FOUND)
	#configure bullet
	execute_process(
		COMMAND ${CMAKE_COMMAND} .. ${BULET_CACHE_ARGS}
		WORKING_DIRECTORY ${BULLET_BUILD_DIR}	
	)
	#build bullet
	execute_process(
		COMMAND ${CMAKE_COMMAND} --build ${BULLET_BUILD_DIR} --target INSTALL --config ${CMAKE_BUILD_TYPE}
		WORKING_DIRECTORY ${BULLET_BUILD_DIR}	
	)
	include(${BULLET_CONFIG})
endif()

set(BULLET_INCLUDE_DIRS "${BULLET_ROOT_DIR}/${BULLET_INCLUDE_DIRS}")
set(BULLET_LIBRARY_DIRS "${BULLET_ROOT_DIR}/${BULLET_LIBRARY_DIRS}")
message(${BULLET_LIBRARY_DIRS})
file(GLOB BULLET_LIBRARIES ${BULLET_LIBRARY_DIRS}/*.lib )
message(${BULLET_LIBRARIES})
#include STB lib header only lib
set(STB_INCLUDE ${CMAKE_CURRENT_SOURCE_DIR}/external/stb)

message(${BULLET_LIBRARY_DIRS})

#this will compile the lib when compileing the project, I wnated to compile dependencies at config time so used execute_process instead
#ExternalProject_Add (
#    bullet3    
#	
#    PREFIX            ""
#    SOURCE_DIR        ${BULLET_3_DIR}
#	 BINARY_DIR		  ${BULLET_3_DIR}/build	
#
#    BUILD_ALWAYS      OFF
#    INSTALL_DIR       ${BULLET_INSTALL_DIR}
#	
#	 CMAKE_CACHE_ARGS ${BULET_CACHE_ARGS}
#
#    BUILD_COMMAND ${CMAKE_COMMAND} --build ${BULLET_3_DIR}/build --target INSTALL --config Release
#)
#once bullet3 is compiled tell cmake how to use the generated libs


include_directories(${SFML_INCLUDE} ${GLEW_INCLUDE} ${GLFW_INCLUDE} ${GLM_INCLUDE})
link_libraries(sfml-graphics sfml-audio ${GLEW_LIB} ${GLFW_LIB} ${OPENGL_LIBRARIES})

add_subdirectory(source)