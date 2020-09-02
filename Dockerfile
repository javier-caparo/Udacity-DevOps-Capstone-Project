FROM node:14-alpine

# set maintainer
LABEL maintainer "javier.caparo@gmail.com"

RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app

WORKDIR /home/node/app

COPY package*.json ./
COPY .eslintrc.json ./

USER node

RUN npm install

COPY --chown=node:node ./src .

EXPOSE 3000

CMD [ "node", "app.js" ]