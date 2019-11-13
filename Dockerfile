FROM archlinux/base

COPY ncurses5-compat-libs-6.1-1-x86_64.pkg.tar.xz /

ARG local_gid
ARG local_uid

WORKDIR /aosp/
ENV PATH="/android_build/bin:${PATH}"

RUN groupadd -g $local_gid local && \
    useradd -m -s /bin/bash -r -u $local_uid -g $local_gid local

# xorgproto libx11
RUN pacman --noconfirm --needed -Syu \
    git glibc zip unzip curl  libxml2 libxslt gawk which procps-ng diffutils \
    python python2 python2-virtualenv python-protobuf ccache wget openssl m4 && \
    pacman --noconfirm -U /ncurses5-compat-libs-6.1-1-x86_64.pkg.tar.xz && \
    rm -rf /ncurses5-compat-libs-6.1-1-x86_64.pkg.tar.xz && \
    mkdir -p /android_build/bin && \
    curl https://storage.googleapis.com/git-repo-downloads/repo > /android_build/bin/repo && \
    chmod a+x /android_build/bin/repo && \
    rm -rf /var/cache/pacman/pkg/* && \
    rm -rf /var/lib/pacman/sync/*.db

USER local

RUN cd /home/local && \
    virtualenv2 --system-site-packages aospenv && \
    touch ~/.bashrc && \
    echo 'alias xxd="prebuilts/build-tools/linux-x86/bin/toybox xxd"' >> ~/.bashrc && \
    echo 'source ~/aospenv/bin/activate' >> ~/.bashrc

ENTRYPOINT [ "bash" ]
