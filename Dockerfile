FROM node:20-alpine AS dev

WORKDIR /app

COPY . .
RUN npm install && npm install -g @nestjs/cli

FROM node:20-alpine AS builder

WORKDIR /app

COPY . .
COPY --from=dev /app/node_modules ./node_modules
RUN npm run build

FROM node:20-alpine AS prod

WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/dist ./dist
COPY .env .env

EXPOSE 8080

CMD [ "node", "dist/main.js"]