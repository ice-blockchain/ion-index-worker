cmake_minimum_required(VERSION 3.16)

add_executable(ion-integrity-checker
    src/main.cpp
    src/IntegrityChecker.cpp
)

target_include_directories(ion-integrity-checker
    PUBLIC external/ton
    PUBLIC external/libpqxx
    PUBLIC src/
    PUBLIC iondb-scanner/src
)

target_link_directories(ion-integrity-checker
    PUBLIC external/ton
    PUBLIC external/libpqxx
)

target_compile_features(ion-integrity-checker PRIVATE cxx_std_17)
target_link_libraries(ion-integrity-checker iondb-scanner overlay tdutils tdactor adnl tl_api dht ton_crypto
        catchain validatorsession validator-disk ton_validator validator-disk smc-envelope pqxx)

install(TARGETS ion-integrity-checker RUNTIME DESTINATION bin)
