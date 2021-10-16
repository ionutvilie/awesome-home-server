# rclone multi-stage build
# get the arm64 binary from github in a different image
FROM alpine:latest as rclone-getter
RUN apk --no-cache add curl

ARG RCLONE_VERSION
ARG RCLONE_ARCH
RUN curl -L "https://github.com/rclone/rclone/releases/download/v${RCLONE_VERSION}/rclone-v${RCLONE_VERSION}-linux-${RCLONE_ARCH}.zip" -o rclone.zip && \
    unzip rclone.zip

# build the main image (official docker file with some asmall changes)
FROM alpine:latest
RUN apk --no-cache add tini ca-certificates fuse
# copy from first image rclone binary
COPY --from=rclone-getter rclone*/rclone /usr/local/bin/

ENTRYPOINT ["/sbin/tini", "--"]
CMD [ "rclone","serve","dlna","/media/","--addr",":8090","--name","rpi-dlna","--read-only" ]

WORKDIR /media
ENV XDG_CONFIG_HOME=/config