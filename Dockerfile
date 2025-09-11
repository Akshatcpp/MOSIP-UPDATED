# Multi-stage Dockerfile for OCR Document Processor

# Stage 1: Build the React frontend
FROM node:18-alpine as frontend-build
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy source code
COPY src/ ./src/
COPY public/ ./public/
COPY index.html ./
COPY vite.config.ts ./
COPY tailwind.config.ts ./
COPY postcss.config.js ./
COPY tsconfig*.json ./

# Build the React application
RUN npm run build

# Stage 2: Setup Python backend with built frontend
FROM python:3.10-slim

# Install system dependencies required for the backend
RUN apt-get update && apt-get install -y \
    poppler-utils \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgomp1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy backend requirements and install Python dependencies
COPY backend/requirements.txt ./backend/
RUN pip install --no-cache-dir -r backend/requirements.txt

# Copy backend source code
COPY backend/ ./backend/

# Copy built frontend from the previous stage
COPY --from=frontend-build /app/dist ./static

# Create a simple Flask app to serve both API and static files
RUN cat > serve.py << 'EOF'
import os
import sys
sys.path.append('/app')
from flask import Flask, send_from_directory
from backend.app import app as backend_app, extract_text, verify_data, health_check

app = Flask(__name__, static_folder='static')

# Copy routes from backend app
app.add_url_rule('/api/extract', 'extract_text', extract_text, methods=['POST'])
app.add_url_rule('/api/verify', 'verify_data', verify_data, methods=['POST'])
app.add_url_rule('/api/health', 'health_check', health_check, methods=['GET'])

# Serve React app static files
@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def serve_frontend(path):
    if path and os.path.exists(os.path.join(app.static_folder, path)):
        return send_from_directory(app.static_folder, path)
    return send_from_directory(app.static_folder, 'index.html')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int(os.environ.get('PORT', 5000)))
EOF

# Expose the port
EXPOSE 5000

# Set environment variables
ENV PYTHONPATH=/app
ENV PORT=5000

# Use gunicorn for production
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "--timeout", "120", "serve:app"]
