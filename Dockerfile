FROM ubuntu:22.04 as builder
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get update && apt-get -y install tzdata && rm -rf /var/lib/{apt,dpkg,cache,log}/
RUN apt update -y \
    && apt install -y build-essential cmake clang openssl libssl-dev zlib1g-dev \
                   gperf wget git curl ccache libmicrohttpd-dev liblz4-dev \
                   pkg-config libsecp256k1-dev libsodium-dev python3-dev libpq-dev \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

# building
COPY external/ /app/external/
COPY pgton/ /app/pgton/
COPY sandbox-cpp/ /app/sandbox-cpp/
COPY ion-index-clickhouse/ /app/ion-index-clickhouse/
COPY ion-index-postgres/ /app/ion-index-postgres/
COPY ion-index-postgres-v2/ /app/ion-index-postgres-v2/
COPY ton-integrity-checker/ /app/ton-integrity-checker/
COPY ton-smc-scanner/ /app/ton-smc-scanner/
COPY ton-trace-emulator/ /app/ton-trace-emulator/
COPY iondb-scanner/ /app/iondb-scanner/
COPY CMakeLists.txt /app/

WORKDIR /app/build
RUN cmake -DCMAKE_BUILD_TYPE=Release ..
RUN make -j$(nproc)

FROM ubuntu:22.04
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get update && apt-get -y install tzdata && rm -rf /var/lib/{apt,dpkg,cache,log}/
RUN apt update -y \
    && apt install -y dnsutils libpq-dev libsecp256k1-dev libsodium-dev \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

COPY scripts/entrypoint.sh /entrypoint.sh
COPY --from=builder /app/build/external/libpqxx/src/libpqxx.so /usr/lib/libpqxx.so
COPY --from=builder /app/build/external/libpqxx/src/libpqxx-*.so /usr/lib/
COPY --from=builder /app/build/ion-index-postgres/ion-index-postgres /usr/bin/ion-index-postgres
COPY --from=builder /app/build/ion-index-postgres-v2/ion-index-postgres-v2 /usr/bin/ion-index-postgres-v2
COPY --from=builder /app/build/ion-index-clickhouse/ion-index-clickhouse /usr/bin/ion-index-clickhouse
COPY --from=builder /app/build/ton-smc-scanner/ton-smc-scanner /usr/bin/ton-smc-scanner
COPY --from=builder /app/build/ton-integrity-checker/ton-integrity-checker /usr/bin/ton-integrity-checker
COPY --from=builder /app/build/ton-trace-emulator/ton-trace-emulator /usr/bin/ton-trace-emulator

ENTRYPOINT [ "/entrypoint.sh" ]
