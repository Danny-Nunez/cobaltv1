FROM node:18-slim

WORKDIR /app

# Install pnpm
RUN npm install -g pnpm

# Copy package files
COPY api/package.json api/pnpm-lock.yaml ./

# Install dependencies
RUN pnpm install --no-frozen-lockfile

# Copy source files
COPY api/src ./src

# Set environment variables
ENV NODE_ENV=production
ENV API_URL=https://cobaltv1.onrender.com/

# Start the application
CMD ["node", "src/cobalt.js"]
