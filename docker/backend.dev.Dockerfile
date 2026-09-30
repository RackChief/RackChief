FROM node:24-bookworm-slim

WORKDIR /app
EXPOSE 3000

COPY package.json package-lock.json ./
RUN npm ci
COPY tsconfig.json ./
COPY src ./src
COPY drizzle ./drizzle
COPY vendor ./vendor
RUN npm run build

CMD ["npm", "run", "dev"]
