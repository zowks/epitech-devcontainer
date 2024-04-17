FROM fedora:38
LABEL maintainer="zowks <https://github.com/zowks>"
LABEL org.opencontainers.image.source="https://github.com/zowks/epitech-devcontainer"
ARG TARGETPLATFORM

COPY ./dnf.conf /etc/dnf/dnf.conf

RUN dnf upgrade -y \
    && if [ $TARGETPLATFORM == "linux/amd64" ] ; then curl -sSL "https://get.haskellstack.org/" | sh ; fi \
    && dnf install -y \
    allegro5 \
    allegro5-devel \
    autoconf \
    automake \
    bc \
    boost \
    boost-devel \
    boost-graph \
    boost-math \
    boost-static \
    ca-certificates.noarch \
    cargo \
    clang-analyzer \
    clang \
    cmake \
    CSFML-devel \
    CSFML \
    curl \
    diffutils \
    elfutils-libelf-devel \
    fish \
    gcc-c++ \
    gcc \
    gdb \
    ghc \
    git \
    glibc-devel \
    glibc-locale-source \
    glibc \
    gmp-devel \
    java-17-openjdk \
    java-17-openjdk-devel \
    ksh \
    langpacks-en \
    libasan \
    libcaca-devel \
    libcaca \
    libconfig \
    libconfig-devel \
    libjpeg-turbo-devel \
    libtsan \
    libubsan \
    libuuid libuuid-devel \
    libX11-devel \
    libXcursor-devel \
    libXext-devel \
    libXi-devel \
    libXinerama-devel \
    libXrandr-devel \
    llvm-devel \
    llvm \
    ltrace \
    make \
    nasm \
    nc \
    ncurses-devel \
    ncurses-libs \
    ncurses \
    net-tools \
    nodejs \
    openal-soft-devel \
    openssl-devel \
    patch \
    php-bcmath \
    php-cli \
    php-devel \
    php-devel \
    php-gd \
    php-gettext-gettext.noarch \
    php-mbstring \
    php-mysqlnd \
    php-pdo \
    php-pdo \
    php-pear.noarch \
    php-phar-io-version.noarch \
    php-theseer-tokenizer.noarch \
    php-xml \
    php \
    procps-ng \
    python3-devel \
    python3 \
    rlwrap \
    ruby \
    rust \
    SDL2 \
    SDL2_gfx \
    SDL2_gfx-devel \
    SDL2_image-devel \
    SDL2_image \
    SDL2_mixer \
    SDL2_mixer-devel \
    SDL2_ttf \
    SDL2_ttf-devel \
    SDL2-devel \
    SDL2-static \
    SFML-devel \
    SFML \
    strace \
    sudo \
    systemd-devel \
    tar \
    tcsh \
    tmux \
    tree \
    unzip \
    valgrind \
    vim \
    wget \
    which \
    xcb-util-image-devel \
    xcb-util-image \
    xz \
    zip \
    zsh \
    && dnf clean all

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
