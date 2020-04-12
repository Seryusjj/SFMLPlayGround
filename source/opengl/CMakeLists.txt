
set(CHAPTER_NAME opengl)
file(GLOB CODE *.cpp)
file(GLOB HEADER *.h)
file(GLOB GLAD_SOURCE ${GLAD_SRC_DIR}/*)

set(SRCS ${CODE} ${HEADER} ${GLAD_SOURCE})
add_executable(${CHAPTER_NAME} ${SRCS})

target_include_directories(${CHAPTER_NAME} PUBLIC ${BULLET_INCLUDE_DIRS} ${STB_INCLUDE} ${GLAD_INCLUDE_DIR})
target_link_libraries(${CHAPTER_NAME} ${BULLET_LIBRARIES} freetype)

#define workind dir for visual studio
set_property(TARGET ${CHAPTER_NAME} PROPERTY VS_DEBUGGER_WORKING_DIRECTORY $<TARGET_FILE_DIR:${CHAPTER_NAME}>)

#copy dll to build dir			
add_custom_command(TARGET ${CHAPTER_NAME} PRE_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy
			${GLFW_DLL} ${FREETYPE_DLL}
			$<TARGET_FILE_DIR:${CHAPTER_NAME}>)		
		
#copy assets
add_custom_command(TARGET ${CHAPTER_NAME} PRE_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
			${ASSETS}
			$<TARGET_FILE_DIR:${CHAPTER_NAME}>/Assets)
