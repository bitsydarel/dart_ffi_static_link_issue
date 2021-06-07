cmake_minimum_required(VERSION 3.11.0)

project(pdfium)

add_library(
        pdfium
        SHARED
        IMPORTED
)

set_target_properties(
        pdfium
        PROPERTIES IMPORTED_LOCATION
        android/${ANDROID_ABI}/libpdfium.cr.so
)

target_include_directories(pdfium INTERFACE include)
