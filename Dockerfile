FROM fedora:38
LABEL maintainer="zowks <https://github.com/zowks>"
LABEL org.opencontainers.image.source="https://github.com/zowks/epitech-devcontainer"

COPY ./dnf.conf /etc/dnf/dnf.conf
COPY ./dnf.packages /tmp/dnf.packages

RUN dnf upgrade -y \
    && dnf install -y $(cat /tmp/dnf.packages) \
    && stack upgrade --binary-only \
    && dnf clean all \
    && rm /tmp/dnf.packages

RUN python3 -m pip install --no-cache-dir --upgrade pip
RUN python3 -m pip install --no-cache-dir -Iv gcovr==6.0 pycryptodome==3.18.0 requests==2.31.0 pyte==0.8.1 numpy==1.25.2
RUN localedef -i en_US -f UTF-8 en_US.UTF-8

RUN npm install -g bun \
    && npm cache clean --force

RUN curl -sSL "https://github.com/Snaipe/Criterion/releases/download/v2.4.2/criterion-2.4.2-linux-x86_64.tar.xz" -o /tmp/criterion.tar.xz \
    && tar xf /tmp/criterion.tar.xz -C /tmp/ \
    && cp -r /tmp/criterion-2.4.2/* /usr/local/ \
    && rm -rf /tmp/*

RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/criterion.conf
RUN ldconfig

ENV LANG=en_US.utf8 LANGUAGE=en_US:en LC_ALL=en_US.utf8 PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

RUN groupadd --gid 1000 tek \
    && useradd tek --uid 1000 --gid tek --password "" \
    && usermod -aG wheel tek
USER tek

RUN sh -c "$(curl -fsSL https://install.ohmyz.sh/)" "" --unattended
