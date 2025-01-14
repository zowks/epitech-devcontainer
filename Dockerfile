# This image will be used to copy Epitech's vera++ set of rules
FROM ghcr.io/epitech/coding-style-checker:latest AS vera-rules

# Install packages
FROM ubuntu:mantic AS epitech-devcontainer
LABEL maintainer="zowks <https://github.com/zowks>"
LABEL org.opencontainers.image.source="https://github.com/zowks/epitech-devcontainer"

COPY ./apt.packages /tmp/apt.packages
# Ubuntu mantic reached EOL, so we need to change the sources.list to use old-releases.ubuntu.com instead
RUN sed -i 's/archive\.ubuntu\.com\/ubuntu\|security\.ubuntu\.com\/ubuntu\|ports\.ubuntu\.com\/ubuntu-ports/old-releases\.ubuntu\.com\/ubuntu/g' /etc/apt/sources.list \
    && apt update \
    && apt install --no-install-recommends -y $(cat /tmp/apt.packages) \
    && yes | unminimize \
    && rm -rf /var/lib/apt/lists/* \
    && rm /tmp/apt.packages

RUN localedef -i en_US -f UTF-8 en_US.UTF-8

RUN curl -sSL https://get.haskellstack.org/ | sh

RUN curl -fsSL https://bun.sh/install | bash \
    && mv /root/.bun/bin/bun /usr/local/bin/bun

# Build Epitech's vera++ binary in parallel
FROM epitech-devcontainer AS banana
RUN git clone "https://github.com/Epitech/banana-vera.git" --branch "v1.3.0-ubuntu" --depth 1 /tmp/banana-vera \
    && cd /tmp/banana-vera \
    && cmake . -DVERA_LUA=OFF -DPANDOC=OFF -DVERA_USE_SYSTEM_BOOST=ON \
    && make -j \
    && make install

# Build lambdananas binary in parallel
FROM epitech-devcontainer AS lambdananas
# No branch specified for now as the latest release does not include arm64 support
RUN git clone "https://github.com/Epitech/lambdananas.git" --depth 1 /tmp/lambdananas \
    && cd /tmp/lambdananas \
    && stack build \
    && cp $(stack path --local-install-root)/bin/lambdananas-exe /usr/local/bin/lambdananas

# Bundle coding-style cli in parallel
FROM epitech-devcontainer AS coding-style-checker
COPY ./coding-style-checker /tmp/coding-style-checker
RUN cd /tmp/coding-style-checker \
    && bun run bundle

# Build Criterion
FROM epitech-devcontainer
RUN git clone "https://github.com/Snaipe/Criterion.git" --branch "v2.4.2" --depth 1 /tmp/criterion \
    && cd /tmp/criterion \
    && meson setup build \
    && meson compile -C build \
    && meson install -C build \
    && ldconfig -N \
    && rm -rf /tmp/criterion \
    && echo "/usr/local/lib" > /etc/ld.so.conf.d/criterion.conf \
    && ldconfig

# Merge previous stages work
COPY --from=banana /usr/local/bin/vera++ /usr/local/bin/vera++
COPY --from=vera-rules /usr/local/lib/vera++ /usr/local/lib/vera++
COPY --from=lambdananas /usr/local/bin/lambdananas /usr/local/bin/lambdananas
COPY --from=coding-style-checker /tmp/coding-style-checker/dist/main.js /usr/local/bin/coding-style

# Create a shorter symlink to the coding-style cli
RUN ln -s /usr/local/bin/coding-style /usr/local/bin/cs

# Create tek user and finalize image
RUN userdel -r ubuntu \
    && groupadd --gid 1000 tek \
    && useradd -m tek --uid 1000 --gid tek --password "" -s /bin/bash \
    && usermod -aG sudo tek \
    && usermod -aG audio tek
USER tek

ENV LANG=en_US.utf8 LANGUAGE=en_US:en LC_ALL=en_US.utf8 PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

RUN sh -c "$(curl -fsSL https://install.ohmyz.sh/)" "" --unattended
