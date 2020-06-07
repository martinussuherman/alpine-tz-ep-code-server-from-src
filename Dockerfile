FROM alpine AS builder

# Multi-stage builds

# Build dependencies
RUN apk --no-cache --update add \
    bash \
    g++ \
    gcc \
    git \
    jq \
    libx11-dev \
    libxkbfile-dev \
    libsecret-dev \
    make \
    nodejs-current \
    npm \
    pkgconf \
    python3 \
    rsync \
    yarn

# Nodejs dependencies
RUN npm install -g node-gyp

RUN ln -s /usr/bin/python3.8 /usr/bin/python && \
    mkdir ~/src && \
    cd ~/src && \
    git clone https://github.com/cdr/code-server.git

WORKDIR /root/src/code-server

# Build package
RUN yarn && \
    yarn vscode && \
    yarn build && \
    yarn build:vscode && \
    yarn release && \
    cd release && \
    yarn --production
RUN yarn release:standalone && \
    yarn test:standalone-release


# Build result image
ENV LABEL_MAINTAINER="Martinus Suherman" \
    LABEL_VENDOR="martinussuherman" \
    LABEL_IMAGE_NAME="martinussuherman/alpine-tz-ep-code-server" \
    LABEL_URL="https://hub.docker.com/r/martinussuherman/alpine-tz-ep-code-server/" \
    LABEL_VCS_URL="https://github.com/martinussuherman/alpine-tz-ep-code-server" \
    LABEL_DESCRIPTION="Code-server based on Alpine Linux, build from source." \
    LABEL_LICENSE="GPL-3.0" \
    # container/su-exec UID \
    EUID=1001 \
    # container/su-exec GID \
    EGID=1001 \
    # container/su-exec user name \
    EUSER=vscode \
    # container/su-exec group name \
    EGROUP=vscode \
    # container user home dir \
    EHOME=/home/vscode \
    # additional directories to create + chown (space separated) \
    ECHOWNDIRS= \
    # additional files to create + chown (space separated) \
    ECHOWNFILES= \
    # container timezone \
    TZ=UTC 

FROM martinussuherman/alpine-tz-ep

RUN apk --no-cache --update add \
    nodejs-current

COPY --from=builder /root/src/code-server/code-server-linux-amd64.tar.gz /root/

# TODO : create script to run code server via nodejs 
RUN mkdir -p /root/.local/lib /root/.local/bin && \
    tar x -f /root/code-server-linux-amd64.tar.gz -C /root/.local/lib -xz && \
    rm /root/code-server-linux-amd64.tar.gz && \
    mv /root/.local/lib/release-standalone /root/.local/lib/code-server-3.4.1 && \
    ln -s /root/.local/lib/code-server-3.4.1/bin/code-server /root/.local/bin/code-server && \
    PATH="/root/.local/bin:$PATH"

ENTRYPOINT ["/entrypoint_su-exec.sh", "code-server"]
CMD ["--bind-addr 0.0.0.0:8080"]

#
ARG LABEL_VERSION="latest"
ARG LABEL_BUILD_DATE
ARG LABEL_VCS_REF

# Build-time metadata as defined at http://label-schema.org
LABEL maintainer=$LABEL_MAINTAINER \
      org.label-schema.build-date=$LABEL_BUILD_DATE \
      org.label-schema.description=$LABEL_DESCRIPTION \
      org.label-schema.name=$LABEL_IMAGE_NAME \
      org.label-schema.schema-version="1.0" \
      org.label-schema.url=$LABEL_URL \
      org.label-schema.license=$LABEL_LICENSE \
      org.label-schema.vcs-ref=$LABEL_VCS_REF \
      org.label-schema.vcs-url=$LABEL_VCS_URL \
      org.label-schema.vendor=$LABEL_VENDOR \
      org.label-schema.version=$LABEL_VERSION
