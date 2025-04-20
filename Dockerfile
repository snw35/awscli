FROM debian:bookworm-20250407-slim

WORKDIR /opt

RUN apt-get update \
  && apt-get install -y \
    bash \
  && apt clean

# Install AWS CLI v2
ENV AWS_CLI_VERSION 2.26.5
ENV AWS_CLI_URL https://awscli.amazonaws.com
ENV AWS_CLI_FILENAME awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip
ENV AWS_CLI_SHA256 c07fd534a79d560bb1abab63e89d3b30f95754c6530aab31daa74156d8d58aee

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
