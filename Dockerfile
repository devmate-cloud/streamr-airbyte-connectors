FROM node:14-alpine

WORKDIR /home/node/airbyte
# RUN npm install -g yarn
RUN apk add --update python make g++\
   && rm -rf /var/cache/apk/*

COPY lerna.json .tsconfig.json package.json package-lock.json ./
RUN sed -i "/eslint\|husky\|jest\|lint-staged\|mockttp\|prettier/d" package.json
COPY ./faros-airbyte-cdk ./faros-airbyte-cdk
# COPY ./sources ./sources
COPY ./destinations ./destinations
RUN yarn

ARG path
RUN test -n "$path" || (echo "'path' argument is not set, e.g --build-arg path=destinations/faros-destination" && false)
ENV CONNECTOR_PATH $path

RUN ln -s "/home/node/airbyte/$CONNECTOR_PATH/bin/main" "/home/node/airbyte/main"

ENV AIRBYTE_ENTRYPOINT "/home/node/airbyte/main"
ENTRYPOINT ["/home/node/airbyte/main"]
