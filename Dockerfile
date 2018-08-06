FROM ubuntu:16.04

# add user group, user and make user home dir
RUN groupadd --gid 1000 easy-mock && \
    useradd --uid 1000 --gid easy-mock --shell /bin/bash --create-home easy-mock

# set pwd to easy-mock home dir
WORKDIR /home/easy-mock

# install dependencies
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    build-essential \
    python \
    wget \
    jq \
    git \
    apt-transport-https \
    ca-certificates

# install nodejs
RUN wget http://cdn.npm.taobao.org/dist/node/v8.4.0/node-v8.4.0-linux-x64.tar.gz && \
    tar -xzvf node-v8.4.0-linux-x64.tar.gz && \
    ln -s /home/easy-mock/node-v8.4.0-linux-x64/bin/node /usr/local/bin/node && \
    ln -s /home/easy-mock/node-v8.4.0-linux-x64/bin/npm /usr/local/bin/npm

# download easy-mock source code
USER easy-mock

RUN mkdir easy-mock && \
    wget https://github.com/easy-mock/easy-mock/archive/v1.6.0.tar.gz && \
    tar -xzvf v1.6.0.tar.gz -C easy-mock --strip-components 1

# npm install dependencies and run build
WORKDIR /home/easy-mock/easy-mock

RUN jq '.db = "mongodb://mongodb/easy-mock"' config/default.json > config/tmp.json && \
    mv config/tmp.json config/default.json
RUN jq '.redis = { port: 6379, host: "redis" }' config/default.json > config/tmp.json && \
    mv config/tmp.json config/default.json

RUN npm install && npm run build
