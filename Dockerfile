# Use an official Node.js image as a base
FROM node:18-alpine

WORKDIR /stagehand

COPY stagehand/ .

RUN npm install

RUN npm run build

EXPOSE 3000

ENTRYPOINT ["node", "dist/index.js"]