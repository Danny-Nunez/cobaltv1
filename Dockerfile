FROM node:20-slim

WORKDIR /app

# Install pnpm
RUN npm install -g pnpm

# Copy the entire project
COPY . .

# Create version info directory and file with more complete information
RUN mkdir -p packages/version-info && \
    echo '{"version":"10.9.1","commit":"deploy","branch":"main","remote":"deploy","buildTime":"'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'","nodeVersion":"'$(node --version)'"}' > packages/version-info/version.json

# Install dependencies
WORKDIR /app/api
RUN pnpm install --no-frozen-lockfile

# Set environment variables
ENV NODE_ENV=production
ENV API_URL=https://cobaltv1.onrender.com/
ENV VERSION_INFO_PATH=/app/packages/version-info/version.json

# Expose the port
EXPOSE 9000

# Start the application
CMD ["node", "src/cobalt.js"]
