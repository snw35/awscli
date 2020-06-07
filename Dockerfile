FROM python:3.8.3-alpine3.12

WORKDIR /opt

# Install AWS CLI v2
ENV AWSCLI_VERSION 2.0.19
ENV AWSCLI_URL https://github.com/aws/aws-cli/archive/
ENV AWSCLI_FILENAME ${AWSCLI_VERSION}.tar.gz
ENV AWSCLI_SHA256 d675c45d140114a12a1e69d5027eef194c7c7317e819eae3210f7043d8b12ac5

RUN apk --update --no-cache add --virtual build.deps \
    build-base \
    python3-dev \
    openssl-dev \
    libffi-dev \
  && ln -s /usr/bin/python3 /usr/bin/python \
  && wget $AWSCLI_URL/$AWSCLI_FILENAME \
  && echo "$AWSCLI_SHA256  ./$AWSCLI_FILENAME" | sha256sum -c - \
  && tar -xzf ./$AWSCLI_FILENAME \
  && pip3 install --no-cache-dir -r /opt/aws-cli-${AWSCLI_VERSION}/requirements.txt \
  && pip3 install --no-cache-dir /opt/aws-cli-${AWSCLI_VERSION}/ \
  && mv -f /opt/aws-cli-${AWSCLI_VERSION}/bin/* /usr/local/bin/ \
  && rm -rf /opt/${AWSCLI_VERSION}.tar.gz \
  && rm -rf /opt/aws-cli-${AWSCLI_VERSION} \
  && apk del build.deps \
  && apk --update --no-cache add \
    groff

ENTRYPOINT ["aws"]
