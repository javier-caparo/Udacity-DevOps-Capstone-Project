FROM node:14-alpine AS stage1

# set maintainer
LABEL maintainer "javier.caparo@gmail.com"

RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app

WORKDIR /home/node/app

COPY package*.json ./
COPY .eslintrc.json ./

USER node

RUN npm install

COPY --chown=node:node ./src .


#Second Stage us
FROM gcr.io/distroless/nodejs:14-debug

COPY --from=stage1 /home/node/app /app
WORKDIR /app
EXPOSE 3000
CMD [ "app.js" ]