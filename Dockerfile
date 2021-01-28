FROM node:15.7.0-alpine3.12

# Update distro
RUN apk update && apk upgrade

# install pyhton
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 make git && ln -sf python3 /usr/bin/python

# Create app directory
WORKDIR /usr/src/electron-release-server

# Install app dependencies
COPY package.json .bowerrc bower.json /usr/src/electron-release-server/
RUN npm install \
  && ./node_modules/.bin/bower install --allow-root \
  && npm cache clean --force \
  && npm prune --production

# Bundle app source
COPY . /usr/src/electron-release-server

COPY config/docker.js config/local.js

RUN chown -R 1101:2000 /usr/src/electron-release-server

CMD [ "npm", "start", "--prod" ]
