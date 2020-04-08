
set(CHAPTER_NAME chapter6.2)

set(SRCS Source.cpp Camera.cpp Camera.h LightRenderer.cpp LightRenderer.h Mesh.cpp Mesh.h ShaderLoader.cpp ShaderLoader.h)

add_executable(${CHAPTER_NAME} ${SRCS})

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
