FROM node:9-alpine

RUN apk update && apk add curl
RUN mkdir /app
WORKDIR /app
COPY ./ /app/
RUN npm install

CMD DEBUG=express:* & npm run deploy
