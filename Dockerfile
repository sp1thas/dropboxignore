FROM alpine:3.17

ENV BATS_SUPPORT_VERSION='0.3.0'
ENV BATS_ASSERT_VERSION='2.1.0'
ENV BATS_FILE_VERSION='0.4.0'

RUN apk add --no-cache \
    attr \
    bats \
    coreutils \
    diffutils \
    grep \
    make


WORKDIR /opt

RUN wget -q "https://github.com/bats-core/bats-support/archive/refs/tags/v${BATS_SUPPORT_VERSION}.zip" -O support.zip && \
    unzip -q support.zip && \
    mv bats-support-${BATS_SUPPORT_VERSION} bats-support && \
    rm support.zip && \
    wget -q "https://github.com/bats-core/bats-assert/archive/refs/tags/v${BATS_ASSERT_VERSION}.zip" -O assert.zip && \
    unzip -q assert.zip && \
    mv bats-assert-${BATS_ASSERT_VERSION} bats-assert && \
    rm assert.zip && \
    wget -q "https://github.com/bats-core/bats-file/archive/refs/tags/v${BATS_FILE_VERSION}.zip" -O file.zip && \
    unzip -q file.zip && \
    mv bats-file-${BATS_FILE_VERSION} bats-file && \
    rm file.zip

CMD bash -c 'bats tests'