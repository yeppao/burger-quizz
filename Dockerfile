FROM node:22-alpine


# Clone the repository as root first
COPY app /app

# Set working directory
WORKDIR /app

# Change ownership to node user
RUN chown -R node:node /app

# Switch to node user
USER node

# Install dependencies
RUN yarn install

# Expose port
EXPOSE 3000

# Default command
CMD ["yarn", "dev"]