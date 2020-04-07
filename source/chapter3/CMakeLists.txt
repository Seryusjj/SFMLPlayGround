
set(CHAPTER_NAME chapter3)

set(SRCS Source.cpp)

add_executable(${CHAPTER_NAME} ${SRCS})

#define workind dir for visual studio
set_property(TARGET ${CHAPTER_NAME} PROPERTY VS_DEBUGGER_WORKING_DIRECTORY $<TARGET_FILE_DIR:${CHAPTER_NAME}>)

#copy dll to build dir
add_custom_command(TARGET ${CHAPTER_NAME} PRE_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
        "${SFML_DLL}"
        $<TARGET_FILE_DIR:${CHAPTER_NAME}>)
		
#copy assets
add_custom_command(TARGET ${CHAPTER_NAME} PRE_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
        "${ASSETS}"
        $<TARGET_FILE_DIR:${CHAPTER_NAME}>/Assets)
