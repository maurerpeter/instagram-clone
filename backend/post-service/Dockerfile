FROM node:12.13.0-alpine AS Base
WORKDIR /usr/src/app
COPY package.json ./

FROM Base AS Build
WORKDIR /usr/src/app
COPY ./src src
COPY tsconfig.json .
RUN npm install --silent
RUN npm run build

FROM Base AS Production
WORKDIR /usr/src/app
COPY --from=Build /usr/src/app/build .
RUN npm install --production --silent

EXPOSE 3001

CMD [ "node", "index.js" ]
