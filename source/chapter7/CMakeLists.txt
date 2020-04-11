
set(CHAPTER_NAME chapter7)

set(SRCS Source.cpp 
		 Camera.cpp
		 Camera.h 
		 LightRenderer.cpp 
		 LightRenderer.h 
		 Mesh.cpp 
		 Mesh.h
		 MeshRenderer.cpp
		 MeshRenderer.h		 
		 ShaderLoader.cpp 
		 ShaderLoader.h
		 TextureLoader.cpp
		 TextureLoader.h)

add_executable(${CHAPTER_NAME} ${SRCS})

target_include_directories(${CHAPTER_NAME} PUBLIC ${BULLET_INCLUDE_DIRS} ${STB_INCLUDE})
target_link_libraries(${CHAPTER_NAME} ${BULLET_LIBRARIES})

#define workind dir for visual studio
set_property(TARGET ${CHAPTER_NAME} PROPERTY VS_DEBUGGER_WORKING_DIRECTORY $<TARGET_FILE_DIR:${CHAPTER_NAME}>)

#copy dll to build dir			
add_custom_command(TARGET ${CHAPTER_NAME} PRE_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy
			${GLEW_DLL} ${GLFW_DLL}
			$<TARGET_FILE_DIR:${CHAPTER_NAME}>)
		
#copy assets
add_custom_command(TARGET ${CHAPTER_NAME} PRE_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
			${ASSETS}
			$<TARGET_FILE_DIR:${CHAPTER_NAME}>/Assets)
