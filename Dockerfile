FROM node:20-bookworm AS dev

WORKDIR /app

COPY . .

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git 

RUN npm install && npm install -g @nestjs/cli


FROM node:20-bookworm-slim AS build

WORKDIR /app

COPY --from=dev /app .
RUN npm run build

FROM node:20-bookworm-slim AS prod

WORKDIR /app
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/package.json ./package.json
COPY --from=build /app/dist ./dist
COPY .env .env

EXPOSE 8080

CMD [ "node", "dist/main.js"]