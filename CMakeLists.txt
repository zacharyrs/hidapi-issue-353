cmake_minimum_required(VERSION 3.0.0)
project(upsc VERSION 0.1.0)

add_library(hidapi "${PROJECT_SOURCE_DIR}/hidapi/linux/hid.c")

add_executable(upsc upsc.c)

target_link_libraries(upsc hidapi)
target_link_libraries(upsc udev)
include_directories(upsc "${PROJECT_SOURCE_DIR}/hidapi/hidapi")
