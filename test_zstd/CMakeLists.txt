cmake_minimum_required(VERSION 3.14)

find_package(zstd CONFIG REQUIRED)

message(STATUS "Found zstd: ${zstd_DIR}")
