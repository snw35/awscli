FROM alpine:3.16.2

WORKDIR /opt

# Install glibc
ENV GLIBC_VERSION 2.34-r0
ENV GLIBC_URL https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}
ENV GLIBC_FILENAME glibc-${GLIBC_VERSION}.apk
ENV GLIBC_SHA256 3ef4a8d71777b3ccdd540e18862d688e32aa1c7bc5a1c0170271a43d0e736486
ENV GLIBC_UPGRADE false

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
  && wget $GLIBC_URL/$GLIBC_FILENAME \
  && wget $GLIBC_URL/glibc-bin-${GLIBC_VERSION}.apk \
  && echo "$GLIBC_SHA256  ./$GLIBC_FILENAME" | sha256sum -c - \
  && apk add --no-cache ./$GLIBC_FILENAME ./glibc-bin-${GLIBC_VERSION}.apk \
  && rm -f ./$GLIBC_FILENAME \
  && rm -f glibc-bin-${GLIBC_VERSION}.apk

# Install AWS CLI v2
ENV AWS_CLI_VERSION 2.8.9
ENV AWS_CLI_URL https://awscli.amazonaws.com
ENV AWS_CLI_FILENAME awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip
ENV AWS_CLI_SHA256 66ce7e305a8fa4e8a140ed30766e6d67a39e299ad2413fdf347da176890597d9

RUN wget $AWS_CLI_URL/$AWS_CLI_FILENAME \
  && echo "$AWS_CLI_SHA256  ./$AWS_CLI_FILENAME" | sha256sum -c - \
  && unzip ./$AWS_CLI_FILENAME \
  && rm -f ./$AWS_CLI_FILENAME \
  && ./aws/install \
  && rm -rf ./aws

COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN apk --update --no-cache add \
    bash \
  && chmod +x /docker-entrypoint.sh \
  && aws --version

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["aws"]
