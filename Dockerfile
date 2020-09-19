FROM node:12.18-alpine3.12

# Update distro
RUN apk update && apk upgrade

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
