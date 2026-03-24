FROM node:20 as builder

LABEL version="1.0.0"
LABEL description="Consumet API (fastify) Docker Image"

# Update packages
RUN apt-get update && apt-get upgrade -y && apt-get autoclean -y && apt-get autoremove -y

# Create non-privileged user
RUN groupadd -r nodejs && useradd -g nodejs -s /bin/bash -d /home/nodejs -m nodejs
USER nodejs

# Set folder permissions
RUN mkdir -p /home/nodejs/app/node_modules && chown -R nodejs:nodejs /home/nodejs/app

WORKDIR /home/nodejs/app

# Environment variables
ARG NODE_ENV=PROD
ARG PORT=3000
ENV NODE_ENV=${NODE_ENV}
ENV PORT=${PORT}
ENV REDIS_HOST=${REDIS_HOST}
ENV REDIS_PORT=${REDIS_PORT}
ENV REDIS_PASSWORD=${REDIS_PASSWORD}
ENV NPM_CONFIG_LOGLEVEL=warn

# Copy package files first
COPY --chown=nodejs:nodejs package*.json ./

# Install dependencies via SSH
# Make sure SSH key is added in Render settings
RUN npm install

# Copy all source files
COPY --chown=nodejs:nodejs . .

# Expose port
EXPOSE 3000

# Optional healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s CMD npm run healthcheck-manual

# Default command
CMD [ "npm", "start" ]
