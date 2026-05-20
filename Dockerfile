FROM node:lts-trixie-slim

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY bin /app/bin/
COPY routes /app/routes/
COPY app.js /app/

CMD ["node", "bin/www"]