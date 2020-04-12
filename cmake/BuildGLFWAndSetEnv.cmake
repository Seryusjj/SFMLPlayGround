function(build_glfw_and_set_env)
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

	#expose variables to global scope
	include(${GLFW_CONFIG})
	file(GLOB GLFW_DLL ${GLFW_INSTALL_DIR}/bin/*)	
	set(GLFW_DLL  ${GLFW_DLL} CACHE INTERNAL "GLFW shared library files")
	set(GLFW_INCLUDE  ${GLFW_INCLUDE} CACHE INTERNAL "GLFW include dir")
endfunction(build_glfw_and_set_env)