FROM node:lts-trixie-slim AS builder

ENV NODE_ENV production

# Add a work directory
WORKDIR /app

# Cache and Install dependencies
COPY package.json .
COPY package-lock.json .

RUN npm install

# Copy app files
COPY . .

# Build the app
RUN npm run-script build

# Bundle static assets with nginx
FROM nginx:mainline-alpine3.22-perl AS production

# Copy built assets from builder
COPY --from=builder /app/build /usr/share/nginx/html

# Add your nginx.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]