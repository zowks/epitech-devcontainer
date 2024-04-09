FROM fedora:38

RUN dnf upgrade -y \
    && dnf install -y dnf-plugins-core \
    && dnf clean all

RUN dnf install --refresh --setopt=tsflags= -y \
    allegro5 \
    allegro5-devel.x86_64 \
    autoconf \
    automake \
    bc \
    boost \
    boost-devel.x86_64 \
    boost-graph \
    boost-math \
    boost-static.x86_64 \
    ca-certificates.noarch \
    cargo \
    clang-analyzer \
    clang.x86_64 \
    cmake.x86_64 \
    CSFML-devel.x86_64 \
    CSFML.x86_64 \
    curl.x86_64 \
    diffutils \
    elfutils-libelf-devel.x86_64 \
    fish \
    gcc-c++.x86_64 \
    gcc.x86_64 \
    gdb.x86_64 \
    ghc \
    git \
    glibc-devel.x86_64 \
    glibc-locale-source.x86_64 \
    glibc.x86_64 \
    gmp-devel.x86_64 \
    java-17-openjdk \
    java-17-openjdk-devel \
    ksh.x86_64 \
    langpacks-en \
    libasan.x86_64 \
    libcaca-devel.x86_64 \
    libcaca.x86_64 \
    libconfig \
    libconfig-devel \
    libjpeg-turbo-devel.x86_64 \
    libtsan \
    libtsan.x86_64 \
    libubsan.x86_64 \
    libuuid libuuid-devel \
    libX11-devel.x86_64 \
    libXcursor-devel.x86_64 \
    libXext-devel.x86_64 \
    libXi-devel.x86_64 \
    libXinerama-devel.x86_64 \
    libXrandr-devel.x86_64 \
    llvm-devel.x86_64 \
    llvm.x86_64 \
    ltrace.x86_64 \
    make.x86_64 \
    nasm.x86_64 \
    nc \
    ncurses-devel.x86_64 \
    ncurses-libs \
    ncurses.x86_64 \
    net-tools.x86_64 \
    nodejs \
    openal-soft-devel.x86_64 \
    openssl-devel \
    patch \
    php-bcmath.x86_64 \
    php-cli.x86_64 \
    php-devel.x86_64 \
    php-devel.x86_64 \
    php-gd.x86_64 \
    php-gettext-gettext.noarch \
    php-mbstring.x86_64 \
    php-mysqlnd.x86_64 \
    php-pdo.x86_64 \
    php-pdo.x86_64 \
    php-pear.noarch \
    php-phar-io-version.noarch \
    php-theseer-tokenizer.noarch \
    php-xml.x86_64 \
    php.x86_64 \
    procps-ng.x86_64 \
    python3-devel.x86_64 \
    python3.x86_64 \
    rlwrap.x86_64 \
    ruby.x86_64 \
    rust \
    SDL2 \
    SDL2_gfx \
    SDL2_gfx-devel.x86_64 \
    SDL2_image-devel.x86_64 \
    SDL2_image.x86_64 \
    SDL2_mixer \
    SDL2_mixer-devel.x86_64 \
    SDL2_ttf \
    SDL2_ttf-devel.x86_64 \
    SDL2-devel.x86_64 \
    SDL2-static.x86_64 \
    SFML-devel.x86_64 \
    SFML.x86_64 \
    strace.x86_64 \
    sudo.x86_64 \
    systemd-devel \
    tar.x86_64 \
    tcsh.x86_64 \
    tmux.x86_64 \
    tree.x86_64 \
    unzip.x86_64 \
    valgrind.x86_64 \
    vim \
    wget.x86_64 \
    which.x86_64 \
    xcb-util-image-devel.x86_64 \
    xcb-util-image.x86_64 \
    xz.x86_64 \
    zip.x86_64 \
    zsh.x86_64 \
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

RUN curl -sSL "https://get.haskellstack.org/" | sh \
    && dnf clean all

ENV LANG=en_US.utf8 LANGUAGE=en_US:en LC_ALL=en_US.utf8 PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
