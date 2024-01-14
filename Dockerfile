FROM debian:bookworm-20240110-slim

WORKDIR /opt

RUN apt-get update \
  && apt-get install -y \
    bash \
  && apt clean

# Install AWS CLI v2
ENV AWS_CLI_VERSION 2.15.10
ENV AWS_CLI_URL https://awscli.amazonaws.com
ENV AWS_CLI_FILENAME awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip
ENV AWS_CLI_SHA256 7977a518102a45f53df2c732559d443df1d8eb7f3006d3e492096ab1fc88f866

RUN apt-get install -y \
    wget \
    unzip \
  && wget $AWS_CLI_URL/$AWS_CLI_FILENAME \
  && echo "$AWS_CLI_SHA256  ./$AWS_CLI_FILENAME" | sha256sum -c - \
  && unzip ./$AWS_CLI_FILENAME \
  && rm -f ./$AWS_CLI_FILENAME \
  && ./aws/install \
  && rm -rf ./aws \
  && apt-get remove -y \
    wget \
    unzip \
  && apt clean

COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh \
  && aws --version

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["aws"]
