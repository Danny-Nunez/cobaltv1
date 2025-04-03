FROM node:18-slim

WORKDIR /app

# Install pnpm
RUN npm install -g pnpm

# Copy the entire api directory
COPY api/ ./

# Install dependencies
RUN pnpm install --no-frozen-lockfile

# Set environment variables
ENV NODE_ENV=production
ENV API_URL=https://cobaltv1.onrender.com/

# Expose the port
EXPOSE 9000

# Start the application
CMD ["node", "src/cobalt.js"]
