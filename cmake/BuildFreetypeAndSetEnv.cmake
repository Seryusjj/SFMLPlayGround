function(build_freetype_and_set_env)
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
	
	#expose variables to global scope
	set(FREETYPE_DLL  ${FREETYPE_DLL} CACHE INTERNAL "Freetype shared libraries")
endfunction(build_freetype_and_set_env)