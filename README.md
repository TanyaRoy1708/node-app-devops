# Node.js Docker Project (Production Ready)

This repository contains a simple Node.js application containerized using industry-standard best practices for production environments.

## Docker Architecture

The `Dockerfile` is designed with security, performance, and reliability in mind. Key features include:

### 1. Multi-Stage Build
We use a two-stage build process:
- **Build Stage**: Installs dependencies and prepares artifacts.
- **Runtime Stage**: A clean, minimal image that only contains the production `node_modules` and the application code.
- **Benefit**: Significantly reduced image size and smaller security attack surface.

### 2. Security (Non-Root User)
The container runs as the `node` user instead of the default `root`.
- **Instruction**: `USER node`
- **Benefit**: Protects the host system by limiting the container's privileges if the application is compromised.

### 3. Deterministic Builds (`npm ci`)
We use `npm ci` instead of `npm install` for dependency management.
- **Benefit**: Ensures the exact same dependency versions are installed every time, preventing "it works on my machine" issues. Requires a `package-lock.json` file.

### 4. Signal Handling & Reliability
The application is started using `node` directly (`CMD ["node", "app/server.js"]`) instead of `npm start`.
- **Benefit**: Allows Node.js to receive OS signals (like `SIGTERM`) directly, enabling graceful shutdowns and better integration with orchestrators like Kubernetes.

### 5. Production Optimization
- `NODE_ENV` is set to `production`.
- Development dependencies are omitted using `--omit=dev`.

---

## Getting Started

### Prerequisites
- [Docker](https://www.docker.com/get-started)
- [Node.js](https://nodejs.org/) (for local development)

### Building the Image
```bash
docker build -t node-app-production .
```

### Running the Container
```bash
docker run -p 3000:3000 node-app-production
```

## Project Structure
- `app/`: Source code directory.
- `Dockerfile`: Production-grade container configuration.
- `.dockerignore`: Files to exclude from the build context.
- `package.json` & `package-lock.json`: Dependency manifests.
