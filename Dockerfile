FROM node:20 as builder

LABEL version="1.0.0"
LABEL description="Consumet API (fastify) Docker Image"

# update packages, to reduce risk of vulnerabilities
RUN apt-get update && apt-get upgrade -y && apt-get autoclean -y && apt-get autoremove -y

# set a non privileged user to use when running this image
RUN groupadd -r nodejs && useradd -g nodejs -s /bin/bash -d /home/nodejs -m nodejs
USER nodejs

# set right (secure) folder permissions
RUN mkdir -p /home/nodejs/app/node_modules && chown -R nodejs:nodejs /home/nodejs/app

WORKDIR /home/nodejs/app

# set default node env
ARG NODE_ENV=PROD
ARG PORT=3000

# environment variables
ENV NODE_ENV=${NODE_ENV}
ENV PORT=${PORT}
ENV REDIS_HOST=${REDIS_HOST}
ENV REDIS_PORT=${REDIS_PORT}
ENV REDIS_PASSWORD=${REDIS_PASSWORD}

ENV NPM_CONFIG_LOGLEVEL=warn

# copy project definition/dependencies files first
COPY --chown=nodejs:nodejs package*.json ./

# 🔹 Fix SSH Git URLs (important for Render)
RUN git config --global url."https://github.com/".insteadOf "git@github.com:"

# install dependencies
RUN npm install && npm update && npm cache clean --force

# copy all sources in the container
COPY --chown=nodejs:nodejs . .

# exposed port
EXPOSE 3000

# healthcheck (optional)
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s CMD npm run healthcheck-manual

# default command
CMD [ "npm", "start" ]
