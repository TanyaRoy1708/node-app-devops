# Stage 1: Build & Dependencies
FROM node:18-alpine AS build

WORKDIR /app

# Copy dependency manifests
COPY package*.json ./

# Install only production dependencies
# npm ci is used for faster, deterministic builds when package-lock exists
RUN npm ci --omit=dev

# ---

# Stage 2: Runtime (Production Image)
FROM node:18-alpine AS runtime

# 1. Set Production Environment
ENV NODE_ENV=production

WORKDIR /app

# 2. Security: Step away from root
# The 'node' user is built into the official Alpine image
USER node

# 3. Copy only necessary files from build stage
COPY --from=build --chown=node:node /app/node_modules ./node_modules
COPY --from=build --chown=node:node /app/package*.json ./

# Copy source code
COPY --chown=node:node app ./app

# 4. Consistency: Expose the same port
EXPOSE 3000

# 5. Reliability: Run 'node' directly to handle signals correctly
CMD ["node", "app/server.js"]
