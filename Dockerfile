FROM alpine:3.18.4

WORKDIR /opt

# Install glibc
ENV GLIBC_VERSION 2.35-r1
ENV GLIBC_URL https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}
ENV GLIBC_FILENAME glibc-${GLIBC_VERSION}.apk
ENV GLIBC_SHA256 276f43ce9b2d5878422bca94ca94e882a7eb263abe171d233ac037201ffcaf06

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
  && wget $GLIBC_URL/$GLIBC_FILENAME \
  && wget $GLIBC_URL/glibc-bin-${GLIBC_VERSION}.apk \
  && echo "$GLIBC_SHA256  ./$GLIBC_FILENAME" | sha256sum -c - \
  && apk add --no-cache --force-overwrite ./$GLIBC_FILENAME ./glibc-bin-${GLIBC_VERSION}.apk \
  && rm -f /lib64/ld-linux-x86-64.so.2 \
  && ln -s /usr/glibc-compat/lib/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2 \
  && rm -f ./$GLIBC_FILENAME \
  && rm -f glibc-bin-${GLIBC_VERSION}.apk

# Install AWS CLI v2
ENV AWS_CLI_VERSION 2.13.34
ENV AWS_CLI_URL https://awscli.amazonaws.com
ENV AWS_CLI_FILENAME awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip
ENV AWS_CLI_SHA256 8b4e19b97f977acbace45a128f0488c8d40007696e551f178ec86208315699bb

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
