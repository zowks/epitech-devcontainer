FROM ghcr.io/epitech/coding-style-checker:latest as coding-style-checker

FROM fedora:38
LABEL maintainer="zowks <https://github.com/zowks>"
LABEL org.opencontainers.image.source="https://github.com/zowks/epitech-devcontainer"
ARG TARGETPLATFORM

COPY ./dnf.conf /etc/dnf/dnf.conf
COPY ./dnf.packages /tmp/dnf.packages
RUN dnf upgrade -y \
    && dnf install -y $(cat /tmp/dnf.packages) \
    && stack upgrade --binary-only \
    || dnf clean all \
    && rm /tmp/dnf.packages

COPY ./python.packages /tmp/python.packages
RUN python3 -m pip install --no-cache-dir --upgrade pip \
    && python3 -m pip install --no-cache-dir -Iv $(cat /tmp/python.packages) \
    && localedef -i en_US -f UTF-8 en_US.UTF-8 \
    && rm /tmp/python.packages

RUN npm install -g bun \
    && npm cache clean --force

RUN git clone "https://github.com/Snaipe/Criterion.git" /tmp/criterion \
    && cd /tmp/criterion \
    && meson setup build \
    && meson compile -C build \
    && meson install -C build \
    && ldconfig -N \
    && rm -rf /tmp/criterion

RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/criterion.conf
RUN ldconfig

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
    && cp $(stack path --local-install-root)/bin/lambdananas-exe /usr/local/bin/lambdananas \
    && rm -rf /root/.stack /tmp/lambdananas

ENV LANG=en_US.utf8 LANGUAGE=en_US:en LC_ALL=en_US.utf8 PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

RUN groupadd --gid 1000 tek \
    && useradd tek --uid 1000 --gid tek --password "" \
    && usermod -aG wheel tek
USER tek

RUN sh -c "$(curl -fsSL https://install.ohmyz.sh/)" "" --unattended
