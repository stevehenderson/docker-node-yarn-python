FROM ubuntu:20.04


# Dockerfile originally based on https://github.com/nodejs/docker-node/blob/master/6.11/slim/Dockerfile
# gpg keys listed at https://github.com/nodejs/node#release-team

ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 16.9.0
ENV YARN_VERSION 1.22.5

ARG PLATFORM="x64"
RUN buildDeps='xz-utils curl ca-certificates gnupg2 dirmngr git net-tools python3 python3-dev jq openssh-client' \
  && set -x \
  && apt-get update && apt-get upgrade -y && apt-get install -y $buildDeps --no-install-recommends 
RUN rm -rf /var/lib/apt/lists/* 
RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-$PLATFORM.tar.xz" 
RUN sha256sum node-v$NODE_VERSION-linux-$PLATFORM.tar.xz >  node-v$NODE_VERSION-linux-$PLATFORM.tar.xz.sha
RUN tar -xJf "node-v$NODE_VERSION-linux-$PLATFORM.tar.xz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-$PLATFORM.tar.xz" \
 && apt-get purge -y --auto-remove $buildDeps \
 && ln -s /usr/local/bin/node /usr/local/bin/nodejs

RUN npm install -g yarn
RUN npm install -g pm2
  

CMD [ "npm", "--version" ]
