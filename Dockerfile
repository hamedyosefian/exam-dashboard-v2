# Use the base image with Node.js 18
FROM 192.168.0.5:8082/node:18-alpine AS base

# Install dependencies only when needed
FROM base AS deps
# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
RUN apk add --no-cache libc6-compat

WORKDIR /app

# Copy package files
COPY package.json yarn.lock* package-lock.json* pnpm-lock.yaml* ./

# Set Verdaccio as the npm registry
RUN npm config set registry http://192.168.0.5:8081/repository/npmg/

# Install dependencies with error handling
# Check the lock file to determine which package manager to use
RUN \
  if [ -f yarn.lock ]; then yarn --frozen-lockfile || true; \
  elif [ -f package-lock.json ]; then npm ci || true; \
  elif [ -f pnpm-lock.yaml ]; then yarn global add pnpm && pnpm i || true; \
  else echo "Lockfile not found." && exit 1; \
  fi

# Rebuild the source code only when needed
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Build the Next.js app
RUN yarn build

# Set up the production environment
FROM base AS runner
WORKDIR /app

# Set production environment variables
ENV NODE_ENV=production

RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001

COPY --from=builder /app/public ./public

COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 3000

ENV PORT 3000
ENV HOSTNAME "0.0.0.0"

CMD ["node", "server.js"]
