cmake_minimum_required(VERSION 3.16)

add_executable(ion-smc-scanner
    src/main.cpp
    src/SmcScanner.cpp
    src/PostgreSQLInserter.cpp
)

target_include_directories(ion-smc-scanner
    PUBLIC external/ton
    PUBLIC external/libpqxx
    PUBLIC src/
    PUBLIC iondb-scanner/src
)

target_link_directories(ion-smc-scanner
    PUBLIC external/ton
    PUBLIC external/libpqxx
)

target_compile_features(ion-smc-scanner PRIVATE cxx_std_17)
target_link_libraries(ion-smc-scanner iondb-scanner overlay tdutils tdactor adnl tl_api dht ton_crypto
        catchain validatorsession validator-disk ton_validator validator-disk smc-envelope pqxx)

install(TARGETS ion-smc-scanner RUNTIME DESTINATION bin)
