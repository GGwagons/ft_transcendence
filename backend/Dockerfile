FROM node:slim

WORKDIR /app

# Install debugging tools and OpenSSL
RUN apt-get update && apt-get install -y iputils-ping dnsutils openssl

ENV NODE_ENV development

# Generate SSL/TLS keys
RUN mkdir -p /etc/ssl/private

COPY ./ssl/localhost.crt /etc/ssl/private

COPY ./ssl/localhost.key /etc/ssl/private

COPY package*.json /app

RUN npm install

COPY . /app

EXPOSE 8080

CMD ["npm", "run", "start"]