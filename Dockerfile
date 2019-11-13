FROM ubuntu:19.04

WORKDIR /aosp/
ENV PATH="/android_build/bin:${PATH}"

RUN apt-get update && \
    apt-get install -y git-core libc6-dev zip curl zlib1g-dev libc6-dev-i386 lib32ncurses5-dev lib32z-dev x11proto-core-dev libx11-dev libxml2-utils xsltproc unzip python && \
    mkdir -p /android_build/bin && \
    curl https://storage.googleapis.com/git-repo-downloads/repo > /android_build/bin/repo && \
    chmod a+x /android_build/bin/repo && \
    rm -rf /var/cache/apt && \
    rm -rf /var/lib/apt/lists

RUN apt-get update && \
    apt-get install -y bc ccache python-protobuf wget libssl-dev && \
    rm -rf /var/cache/apt && \
    rm -rf /var/lib/apt/lists

ENTRYPOINT [ "sh", "-c" ]
