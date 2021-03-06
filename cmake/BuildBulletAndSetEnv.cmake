function(build_bullet_and_set_env)
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
	
	#expose variables to global scope
	set(BULLET_INCLUDE_DIRS "${BULLET_ROOT_DIR}/${BULLET_INCLUDE_DIRS}" CACHE INTERNAL "Bullet include directory")
	set(BULLET_LIBRARY_DIRS "${BULLET_ROOT_DIR}/${BULLET_LIBRARY_DIRS}" CACHE INTERNAL "Bullet .lib directory")
	file(GLOB BULLET_LIBRARIES ${BULLET_LIBRARY_DIRS}/*.lib)
	set(BULLET_LIBRARIES  ${BULLET_LIBRARIES} CACHE INTERNAL "Bullet .lib files for static compilation")
endfunction(build_bullet_and_set_env)