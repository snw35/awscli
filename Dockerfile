FROM debian:trixie-20260713-slim

WORKDIR /opt

RUN apt-get update \
  && apt-get install -y \
    bash \
  && apt clean

# Install AWS CLI v2
ENV AWS_CLI_VERSION 2.36.8
ENV AWS_CLI_URL https://awscli.amazonaws.com
ENV AWS_CLI_FILENAME awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip
ENV AWS_CLI_SHA256 829a2bbad5b4821a8d006a133c34fa5ce2f362ae003ac39aa0865a6d1e1711f2

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
