cmake_minimum_required(VERSION 3.16)

add_library(ion-trace-emulator-core STATIC
    src/TraceEmulator.cpp
    src/OverlayListener.cpp
    src/BlockEmulator.cpp
    src/TraceInterfaceDetector.cpp
)
target_include_directories(ion-trace-emulator-core
    PUBLIC external/ton
    PUBLIC src/
    PUBLIC tondb-scanner/src
)
target_link_directories(ion-trace-emulator-core
    PUBLIC external/ton
)
target_link_libraries(ion-trace-emulator-core tondb-scanner overlay ton_validator emulator)
target_compile_features(ion-trace-emulator-core PRIVATE cxx_std_17)

add_executable(ion-trace-emulator
    src/main.cpp
    src/TraceScheduler.cpp
    src/TraceInserter.cpp
)
target_include_directories(ion-trace-emulator
    PUBLIC external/ton
    PUBLIC src/
    PUBLIC tondb-scanner/src
    PUBLIC external/hiredis
    PUBLIC external/redis-plus-plus/src
    PUBLIC ${CMAKE_BINARY_DIR}/external/redis-plus-plus/src
    PUBLIC external/msgpack-c
)
target_link_directories(ion-trace-emulator
    PUBLIC external/ton
    PUBLIC external/hiredis
    PUBLIC external/redis-plus-plus
    PUBLIC external/msgpack-c
)
target_compile_features(ion-trace-emulator PRIVATE cxx_std_17)
target_link_libraries(ion-trace-emulator ton_validator ion-trace-emulator-core hiredis redis++ msgpack-cxx)
target_link_options(ion-trace-emulator PUBLIC -rdynamic)
install(TARGETS ion-trace-emulator RUNTIME DESTINATION bin)
