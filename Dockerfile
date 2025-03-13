FROM node:20-alpine AS base

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install

FROM node:20-alpine AS builder

WORKDIR /app
COPY . .
COPY --from=base /app/node_modules ./node_modules
RUN npm run build

FROM node:20-alpine AS runner

WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/dist ./dist
COPY .env .env

EXPOSE 8080

CMD [ "node", "dist/main.js"]