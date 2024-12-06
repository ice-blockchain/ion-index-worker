cmake_minimum_required(VERSION 3.16)

add_executable(ion-index-clickhouse 
    src/main.cpp
    src/InsertManagerClickhouse.cpp
    src/IndexScheduler.cpp
)

target_include_directories(ion-index-clickhouse 
    PUBLIC external/ton
    PUBLIC external/clickhouse-cpp
    PUBLIC iondb-scanner/src
    PUBLIC src/
)

target_link_directories(ion-index-clickhouse
    PUBLIC external/ton
    PUBLIC external/clickhouse-cpp
)
target_compile_features(ion-index-clickhouse PRIVATE cxx_std_17)
target_link_libraries(ion-index-clickhouse iondb-scanner overlay tdutils tdactor adnl tl_api dht ton_crypto
        catchain validatorsession validator-disk ton_validator validator-disk smc-envelope
        clickhouse-cpp-lib)

install(TARGETS ion-index-clickhouse RUNTIME DESTINATION bin)
