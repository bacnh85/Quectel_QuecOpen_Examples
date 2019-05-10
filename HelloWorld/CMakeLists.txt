cmake_minimum_required (VERSION 2.6)

set(APP_NAME HelloWorld)

project (${APP_NAME} )

add_executable(${APP_NAME}  main.c)
target_link_libraries (${APP_NAME} )