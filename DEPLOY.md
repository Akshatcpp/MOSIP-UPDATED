# Deployment Guide

This guide provides instructions for deploying the OCR Document Processor using Docker for self-hosting. Cloud providers like Vercel or Netlify are not used for this solution.

## Docker Deployment

### Prerequisites
- Docker and Docker Compose installed on your server
- At least 4GB RAM (recommended for TrOCR models)
- 10GB+ free disk space

### Quick Start

1. Build the Docker image:
```bash
docker build -t ocr-document-processor .
```

2. Run the container:
```bash
docker run -d -p 5000:5000 --name ocr-app ocr-document-processor
```

3. Access the application at http://localhost:5000

### Production Deployment

For production environments, create a `docker-compose.yml` file:

```yaml
version: '3.8'
services:
  ocr-app:
    build: .
    ports:
      - "5000:5000"
    environment:
      - FLASK_ENV=production
    volumes:
      - ./uploads:/app/uploads  # Optional: persist uploaded files
    restart: unless-stopped
```

Run with:
```bash
docker-compose up -d
```

### Environment Variables

The application supports the following environment variables:

- `PORT`: Server port (default: 5000)
- `FLASK_ENV`: Flask environment (production/development)
- `PYTHONPATH`: Python path (set to /app)

### Resource Requirements

Minimum requirements:
- CPU: 2 cores
- RAM: 4GB
- Storage: 10GB
- Network: 1GB/month (depending on usage)

Recommended for production:
- CPU: 4+ cores
- RAM: 8GB+
- Storage: 20GB+
- Network: Unlimited

### Security Considerations

1. Use HTTPS in production (configure reverse proxy)
2. Set appropriate file upload limits
3. Monitor resource usage
4. Implement rate limiting for API endpoints
5. Use a firewall to restrict access

### Monitoring

Monitor the application with:

```bash
# View container logs
docker logs ocr-app

# Check container health
docker stats ocr-app

# Access container shell
docker exec -it ocr-app /bin/bash
```

### Troubleshooting

Common issues:

1. **Out of Memory**: Increase container memory limit
2. **Model Loading Slow**: First request takes 30-60 seconds for model loading
3. **Port Already in Use**: Change the port mapping in docker run command

### Scaling

For high-traffic deployments:

1. Use Docker Swarm or Kubernetes for container orchestration
2. Add load balancer (nginx, HAProxy)
3. Consider GPU acceleration for faster OCR processing
4. Implement Redis for caching model outputs

### Backup and Updates

1. Backup strategy:
   - No persistent data by default
   - Consider backing up uploaded files if volume is mounted

2. Update process:
   - Build new image with updates
   - Stop old container: `docker stop ocr-app`
   - Remove old container: `docker rm ocr-app`
   - Run new container with same configuration

### Self-Hosting Options

This application can be deployed on:

- VPS/Dedicated servers (DigitalOcean, Linode, AWS EC2)
- On-premises servers
- Docker-compatible hosting platforms
- Local development/demo environments

**Note**: This solution is designed for self-hosting and does not use cloud platforms like Vercel or Netlify as specified in the requirements.
