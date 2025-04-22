# Use an official Node.js image as a base
FROM node:18-alpine AS builder

# Set the working directory for stagehand
WORKDIR /app/stagehand

# Copy package.json and package-lock.json from stagehand directory
COPY stagehand/package.json stagehand/package-lock.json ./

# Install dependencies within stagehand directory
RUN npm install

# Copy the rest of the application source code from stagehand
COPY stagehand/ .

# Build the TypeScript source code
RUN npm run build

# Create the final image from a smaller Node.js runtime
FROM node:18-alpine

# Set the working directory
WORKDIR /app/stagehand

# Copy built files from the builder stage
COPY --from=builder /app/stagehand/dist ./dist
COPY --from=builder /app/stagehand/package.json ./package.json
COPY --from=builder /app/stagehand/package-lock.json ./package-lock.json

# Set environment variables (to be configured at runtime)
ENV STAGEHAND_API_KEY=<YOUR_STAGEHAND_API_KEY>
ENV STAGEHAND_PROJECT_ID=<YOUR_STAGEHAND_PROJECT_ID>

# Expose the port the app runs on (adjust if your app uses a different port)
EXPOSE 3000

# Set the entry point
ENTRYPOINT ["node", "./dist/index.js"]