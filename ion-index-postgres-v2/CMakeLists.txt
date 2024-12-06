cmake_minimum_required(VERSION 3.16)

add_executable(ion-index-postgres-v2
    src/main.cpp
    src/InsertManagerPostgres.cpp
    src/IndexScheduler.cpp
)

target_include_directories(ion-index-postgres-v2
    PUBLIC external/ton
    PUBLIC external/libpqxx
    PUBLIC tondb-scanner/src
    PUBLIC src/
)

target_link_directories(ion-index-postgres-v2
    PUBLIC external/ton
    PUBLIC external/libpqxx
)

target_compile_features(ion-index-postgres-v2 PRIVATE cxx_std_17)
target_link_libraries(ion-index-postgres-v2 tondb-scanner overlay tdutils tdactor adnl tl_api dht ton_crypto
        catchain validatorsession validator-disk ton_validator validator-disk smc-envelope pqxx)
target_link_options(ion-index-postgres-v2 PUBLIC -rdynamic)

install(TARGETS ion-index-postgres-v2 RUNTIME DESTINATION bin)
