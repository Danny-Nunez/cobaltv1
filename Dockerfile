FROM node:18-slim

WORKDIR /app

# Install pnpm and git
RUN npm install -g pnpm && \
    apt-get update && \
    apt-get install -y git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy the entire project
COPY . .

# Set up git configuration
RUN git config --global init.defaultBranch main && \
    git config --global user.email "deploy@render.com" && \
    git config --global user.name "Render Deploy" && \
    git init && \
    git add . && \
    git commit -m "Initial commit" || true

# Create version info fallback
RUN echo '{"version":"10.9.1","commit":"deploy","branch":"main","remote":"deploy"}' > packages/version-info/version.json

# Install dependencies
WORKDIR /app/api
RUN pnpm install --no-frozen-lockfile

# Set environment variables
ENV NODE_ENV=production
ENV API_URL=https://cobaltv1.onrender.com/

# Expose the port
EXPOSE 9000

# Start the application
CMD ["node", "src/cobalt.js"]
