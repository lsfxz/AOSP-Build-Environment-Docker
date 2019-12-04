FROM archlinux/base

ARG local_gid
ARG local_uid

WORKDIR /aosp/
ENV PATH="/android_build/bin:${PATH}"

RUN groupadd -g $local_gid local && \
    useradd -m -s /bin/bash -r -u $local_uid -g $local_gid local

RUN pacman --noconfirm --needed -Syu \
    # base requirements for building aosp:
    git glibc zip unzip curl  libxml2 libxslt gawk which procps-ng diffutils \
    python2 freetype2 ttf-dejavu wget openssl m4 rsync \
    # you can omit those if you don't want to extract the vendor files in the container:
    perl python2-protobuf tar \
    # you can omit those if you don't want to run script/release.sh in the container:
    python python-protobuf vim \
    # ccache:
    ccache \
    # you can omit those if you don't want to build the kernel inside the container:
    bc gcc && \
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

RUN touch ~/.bashrc && \
    # only required to build the kernel
    # NOTE: way too much of a hassle, easier to just install gcc with pacman
    # => we could, for example, somehow include /aosp/kernel/google/[yourkernel]/tools/include/linux/, but in the end that would be more trouble than it's worth
    # echo 'export PATH=$PATH:/aosp/prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.17-4.8/libexec/gcc/x86_64-linux/4.8.3'
    # can we include this in a more generic way (glibc-version-path)?
    # echo 'export PATH=$PATH:/aosp/prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.17-4.8/x86_64-linux/bin/' >> ~/.bashrc  && \
    # for make:
    echo 'export PATH=$PATH:/aosp/prebuilts/build-tools/linux-x86/bin/' >> ~/.bashrc  && \
    #
    # only required to extract vendor files
    echo 'export PATH=$PATH:/aosp/prebuilts/jdk/jdk9/linux-x86/bin' >> ~/.bashrc && \
    echo 'source /etc/profile.d/perlbin.sh' >> ~/.bashrc

ENTRYPOINT [ "bash" ]
