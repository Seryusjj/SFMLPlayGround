
cmake_minimum_required(VERSION 3.8)

project(SFMLPlayGround)
#Only x64 is supported
set(CMAKE_GENERATOR_PLATFORM x64)
#options
set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "set Debug or Release build, the 3rd party will be compiled as such")

set(ASSETS "${CMAKE_CURRENT_SOURCE_DIR}/assets")

set(SFML_DIR "${CMAKE_CURRENT_SOURCE_DIR}/external/SFML-2.5.1")
set(SFML_DLL "${CMAKE_CURRENT_SOURCE_DIR}/external/SFML-2.5.1/bin")
set(SFML_INCLUDE "${SFML_DIR}/include")

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${SFML_DIR}/lib/cmake/SFML")
include(SFMLSharedTargets)
include(ExternalProject)

#glad opengl loader (can replace GLEW)
set(GLAD_DIR ${CMAKE_CURRENT_SOURCE_DIR}/external/glad)
set(GLAD_INCLUDE_DIR ${GLAD_DIR}/include)
set(GLAD_SRC_DIR ${GLAD_DIR}/src)

#shared GLEW precompiled
set(GLEW_DIR "${CMAKE_CURRENT_SOURCE_DIR}/external/glew-2.1.0")
set(GLEW_DLL "${GLEW_DIR}/bin/Release/x64/glew32.dll")
set(GLEW_LIB "${GLEW_DIR}/lib/Release/x64/glew32.lib")
set(GLEW_INCLUDE "${GLEW_DIR}/include")

#shared lib GLFW
set(GLFW_DIR ${CMAKE_CURRENT_SOURCE_DIR}/external/glfw)
set(GLFW_BUILD_DIR ${GLFW_DIR}/build)
set(GLFW_INSTALL_DIR ${GLFW_BUILD_DIR}/install)
set(GLFW_CONFIG ${GLFW_INSTALL_DIR}/lib/cmake/glfw3/glfw3Config.cmake)
set(GLFW_INCLUDE ${GLFW_INSTALL_DIR}/include)
#if not found just build the lib
if(NOT EXISTS ${GLFW_CONFIG})    
    set(GLFW_CACHE_ARGS 
            -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
			-DBUILD_SHARED_LIBS:BOOL=ON
			-DGLFW_INSTALL:BOOL=ON
			-DUSE_MSVC_RUNTIME_LIBRARY_DLL:BOOL=ON
            -DCMAKE_INSTALL_PREFIX:STRING=${GLFW_INSTALL_DIR}
            -DCMAKE_GENERATOR_PLATFORM:STRING=${CMAKE_GENERATOR_PLATFORM}
            -DCMAKE_GENERATOR:STRING=${CMAKE_GENERATOR}
			-DGLFW_BUILD_DOCS:BOOL=OFF
			-DGLFW_BUILD_EXAMPLES:BOOL=OFF
			-DGLFW_BUILD_TEST:BOOL=OFF)
    file(MAKE_DIRECTORY ${GLFW_BUILD_DIR})	
	#configure glfw
	execute_process(
		COMMAND ${CMAKE_COMMAND} ../ ${GLFW_CACHE_ARGS}
		WORKING_DIRECTORY ${GLFW_BUILD_DIR}	
	)
	#build glfw
	execute_process(
		COMMAND ${CMAKE_COMMAND} --build ${GLFW_BUILD_DIR} --target INSTALL --config ${CMAKE_BUILD_TYPE}
		WORKING_DIRECTORY ${GLFW_BUILD_DIR}	
	)    
endif()

#this will create the freetype target
include(${GLFW_CONFIG})
file(GLOB GLFW_DLL ${GLFW_INSTALL_DIR}/bin/*)


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
		COMMAND ${CMAKE_COMMAND} ../ ${BULET_CACHE_ARGS}
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

file(GLOB BULLET_LIBRARIES ${BULLET_LIBRARY_DIRS}/*.lib )

#include STB lib header only lib
set(STB_INCLUDE ${CMAKE_CURRENT_SOURCE_DIR}/external/stb)

#build and add freetype
set(FREETYPE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/external/freetype2)
set(FREETYPE_BUILD_DIR ${FREETYPE_DIR}/build)
set(FREETYPE_INSTALL_DIR ${FREETYPE_BUILD_DIR}/install)
set(FREETYPE_CONFIG ${FREETYPE_INSTALL_DIR}/lib/cmake/freetype/freetype-config.cmake)

#if not found just build the lib
if(NOT EXISTS ${FREETYPE_CONFIG})    
    set(FREETYPE_CACHE_ARGS 
            -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
			-DBUILD_SHARED_LIBS:BOOL=true
            -DCMAKE_INSTALL_PREFIX:STRING=${FREETYPE_INSTALL_DIR}
            -DCMAKE_GENERATOR_PLATFORM:STRING=${CMAKE_GENERATOR_PLATFORM}
            -DCMAKE_GENERATOR:STRING=${CMAKE_GENERATOR})
    file(MAKE_DIRECTORY ${FREETYPE_BUILD_DIR})	
	#configure freetype
	execute_process(
		COMMAND ${CMAKE_COMMAND} ../ ${FREETYPE_CACHE_ARGS}
		WORKING_DIRECTORY ${FREETYPE_BUILD_DIR}	
	)
	#build freetype
	execute_process(
		COMMAND ${CMAKE_COMMAND} --build ${FREETYPE_BUILD_DIR} --target INSTALL --config ${CMAKE_BUILD_TYPE}
		WORKING_DIRECTORY ${FREETYPE_BUILD_DIR}	
	)    
endif()

#this will create the freetype target
include(${FREETYPE_CONFIG})
file(GLOB FREETYPE_DLL ${FREETYPE_INSTALL_DIR}/bin/*)




include_directories(${SFML_INCLUDE} ${GLEW_INCLUDE} ${GLFW_INCLUDE} ${GLM_INCLUDE})
link_libraries(sfml-graphics sfml-audio ${GLEW_LIB} glfw ${OPENGL_LIBRARIES} ${FREETYPE_LIBRARIES})

add_subdirectory(source)