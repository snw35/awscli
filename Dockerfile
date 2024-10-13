FROM debian:bookworm-20240926-slim

WORKDIR /opt

RUN apt-get update \
  && apt-get install -y \
    bash \
  && apt clean

# Install AWS CLI v2
ENV AWS_CLI_VERSION 2.18.5
ENV AWS_CLI_URL https://awscli.amazonaws.com
ENV AWS_CLI_FILENAME awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip
ENV AWS_CLI_SHA256 41ced963f9c2193fe875d7b21c5873980cc482ae7f054e5db9a7f66b11069624

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
