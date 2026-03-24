FROM node:20 as builder

LABEL version="1.0.0"
LABEL description="Consumet API (fastify) Docker Image"

# update packages
RUN apt-get update && apt-get upgrade -y && apt-get autoclean -y && apt-get autoremove -y

# create non-privileged user
RUN groupadd -r nodejs && useradd -g nodejs -s /bin/bash -d /home/nodejs -m nodejs
USER nodejs

# set folder permissions
RUN mkdir -p /home/nodejs/app/node_modules && chown -R nodejs:nodejs /home/nodejs/app

WORKDIR /home/nodejs/app

# environment variables
ARG NODE_ENV=PROD
ARG PORT=3000
ENV NODE_ENV=${NODE_ENV}
ENV PORT=${PORT}
ENV REDIS_HOST=${REDIS_HOST}
ENV REDIS_PORT=${REDIS_PORT}
ENV REDIS_PASSWORD=${REDIS_PASSWORD}
ENV NPM_CONFIG_LOGLEVEL=warn

# copy dependency files first
COPY --chown=nodejs:nodejs package*.json ./

# 🔹 rewrite any SSH Git URLs to HTTPS (safety net)
RUN git config --global url."https://github.com/".insteadOf "git@github.com:"

# install dependencies
RUN npm install

# copy all source files
COPY --chown=nodejs:nodejs . .

# expose port
EXPOSE 3000

# healthcheck (optional)
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s CMD npm run healthcheck-manual

# default command
CMD [ "npm", "start" ]
