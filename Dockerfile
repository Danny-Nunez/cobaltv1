FROM node:20-slim

WORKDIR /app

# Install pnpm and git
RUN npm install -g pnpm && \
    apt-get update && \
    apt-get install -y git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy the entire project
COPY . .

# Initialize git repository with remote
RUN git init && \
    git config --global init.defaultBranch main && \
    git config --global user.email "deploy@render.com" && \
    git config --global user.name "Render Deploy" && \
    git remote add origin https://github.com/Danny-Nunez/cobaltv1.git && \
    git add . && \
    git commit -m "Initial commit" || true

# Create version info directory and file with more complete information
RUN mkdir -p packages/version-info && \
    echo '{"version":"10.9.1","commit":"deploy","branch":"main","remote":"origin","buildTime":"'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'","nodeVersion":"'$(node --version)'"}' > packages/version-info/version.json

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
