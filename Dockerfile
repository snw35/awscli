FROM alpine:3.15.3

WORKDIR /opt

# Install glibc
ENV GLIBC_VERSION 2.35-r0
ENV GLIBC_URL https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}
ENV GLIBC_FILENAME glibc-${GLIBC_VERSION}.apk
ENV GLIBC_SHA256 02fe2d91f53eab93c64d74485b80db575cfb4de40bc0d12bf55839fbe16cb041

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
  && wget $GLIBC_URL/$GLIBC_FILENAME \
  && wget $GLIBC_URL/glibc-bin-${GLIBC_VERSION}.apk \
  && echo "$GLIBC_SHA256  ./$GLIBC_FILENAME" | sha256sum -c - \
  && apk add --no-cache ./$GLIBC_FILENAME ./glibc-bin-${GLIBC_VERSION}.apk \
  && rm -f ./$GLIBC_FILENAME \
  && rm -f glibc-bin-${GLIBC_VERSION}.apk

# Install AWS CLI v2
ENV AWS_CLI_VERSION 2.5.2
ENV AWS_CLI_URL https://awscli.amazonaws.com
ENV AWS_CLI_FILENAME awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip
ENV AWS_CLI_SHA256 d0f8324e0ad09c5802853ef60afc07c9a31e0c08d0b5a8e97031ae2fa03e4182

RUN wget $AWS_CLI_URL/$AWS_CLI_FILENAME \
  && echo "$AWS_CLI_SHA256  ./$AWS_CLI_FILENAME" | sha256sum -c - \
  && unzip ./$AWS_CLI_FILENAME \
  && rm -f ./$AWS_CLI_FILENAME \
  && ./aws/install \
  && rm -rf ./aws

COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN apk --update --no-cache add \
    bash \
  && chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["aws"]
