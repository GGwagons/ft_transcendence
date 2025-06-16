FROM node:slim

WORKDIR /app

# Install OpenSSL
RUN apt-get update && apt-get install -y openssl

RUN mkdir -p /etc/ssl/private

COPY ./ssl/localhost.crt /etc/ssl/private
COPY ./ssl/localhost.key /etc/ssl/private

COPY package*.json /app

RUN npm install

COPY . /app

RUN npm run build

CMD ["npm", "run", "start"]
