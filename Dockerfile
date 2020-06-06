FROM alpine AS builder

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

# Multi-stage builds

# Build tools and deps
RUN apk --no-cache --update add \
    gcc \
    git \
    jq \
    libx11-dev \
    libxkbfile-dev \
    libsecret-dev \
    make \
    nodejs-current \
    pkgconf \
    python3 \
    yarn

RUN mkdir ~/src \
    cd ~/src \
    git clone https://github.com/cdr/code-server.git \
    cd ~/src/code-server

# Build package
RUN yarn \
    yarn vscode \
    yarn build \
    yarn build:vscode \
    yarn release \
    cd release \
    yarn --production


# Build result image
FROM martinussuherman/alpine-tz-ep

WORKDIR /root/

COPY --from=builder /go/src/github.com/alexellis/href-counter/app .

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
