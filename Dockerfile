FROM archlinux/base

ARG local_gid
ARG local_uid

WORKDIR /aosp/
ENV PATH="/android_build/bin:${PATH}"

RUN groupadd -g $local_gid local && \
    useradd -m -s /bin/bash -r -u $local_uid -g $local_gid local

RUN pacman --noconfirm --needed -Syu \
    git glibc zip unzip curl  libxml2 libxslt gawk which procps-ng diffutils \
    python python2 freetype2 ttf-dejavu python-protobuf wget openssl m4 rsync vim && \
    # until https://github.com/ccache/ccache/issues/489 is fixed:
    pacman --noconfirm -U https://archive.archlinux.org/packages/c/ccache-3.7.4-1-x86_64.pkg.tar.xz && \
    # otherwise, we would have to build from the AUR to provide libncurses.so.5:
    pacman-key --init && pacman-key --populate &&\
    pacman-key -r 83F817213361BF5F02E7E124F9F9FA97A403F63E && \
    pacman -U  --noconfirm https://repo.archlinuxcn.org/x86_64/archlinuxcn-keyring-20191029-1-any.pkg.tar.xz && \
    pacman-key -u && \
    pacman --noconfirm -U https://repo.archlinuxcn.org/x86_64/ncurses5-compat-libs-6.1-1-x86_64.pkg.tar.xz && \
    mkdir -p /android_build/bin && \
    curl https://storage.googleapis.com/git-repo-downloads/repo > /android_build/bin/repo && \
    chmod a+x /android_build/bin/repo && \
    rm -rf /var/cache/pacman/pkg/* && \
    rm -rf /var/lib/pacman/sync/*.db

USER local

ENTRYPOINT [ "bash" ]
