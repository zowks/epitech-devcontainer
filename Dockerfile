# This image will be used to copy Epitech's vera++ set of rules
FROM ghcr.io/epitech/coding-style-checker:latest AS coding-style-checker

# Install packages
FROM ubuntu:mantic AS base
LABEL maintainer="zowks <https://github.com/zowks>"
LABEL org.opencontainers.image.source="https://github.com/zowks/epitech-devcontainer"

COPY ./apt.packages /tmp/apt.packages
RUN yes | unminimize \
    && apt install -y $(cat /tmp/apt.packages) \
    && rm /tmp/apt.packages

RUN localedef -i en_US -f UTF-8 en_US.UTF-8

RUN curl -sSL https://get.haskellstack.org/ | sh

RUN npm install -g bun \
    && npm cache clean --force

# Build Epitech's vera++ binary in parallel
FROM base AS banana
RUN git clone "https://github.com/Epitech/banana-vera.git" /tmp/banana-vera \
    && cd /tmp/banana-vera \
    && cmake . -DVERA_LUA=OFF -DPANDOC=OFF -DVERA_USE_SYSTEM_BOOST=ON \
    && make -j \
    && make install

# Build lambdananas binary in parallel
FROM base AS lambdananas
RUN git clone "https://github.com/Epitech/lambdananas.git" /tmp/lambdananas \
    && cd /tmp/lambdananas \
    && stack build \
    && cp $(stack path --local-install-root)/bin/lambdananas-exe /usr/local/bin/lambdananas

# Build Criterion
FROM base
RUN git clone "https://github.com/Snaipe/Criterion.git" /tmp/criterion \
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
COPY --from=coding-style-checker /usr/local/lib/vera++ /usr/local/lib/vera++
COPY --from=lambdananas /usr/local/bin/lambdananas /usr/local/bin/lambdananas

# Create tek user and finalize image
RUN userdel -r ubuntu \
    && groupadd --gid 1000 tek \
    && useradd -m tek --uid 1000 --gid tek --password "" \
    && usermod -aG sudo tek
USER tek

RUN git clone "https://github.com/Epitech/banana-vera.git" /tmp/banana-vera \
    && cd /tmp/banana-vera \
    && cmake . -DVERA_LUA=OFF -DPANDOC=OFF -DVERA_USE_SYSTEM_BOOST=ON \
    && make -j \
    && make install \
    && rm -rf /tmp/banana-vera /usr/local/lib/vera++
COPY --from=coding-style-checker /usr/local/lib/vera++ /usr/local/lib/vera++

RUN git clone "https://github.com/Epitech/lambdananas.git" /tmp/lambdananas \
    && cd /tmp/lambdananas \
    && stack build \
    && cp "$(stack path --local-install-root)"/bin/lambdananas-exe /usr/local/bin/lambdananas \
    && rm -rf /root/.stack /tmp/lambdananas

ENV LANG=en_US.utf8 LANGUAGE=en_US:en LC_ALL=en_US.utf8 PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

RUN sh -c "$(curl -fsSL https://install.ohmyz.sh/)" "" --unattended
