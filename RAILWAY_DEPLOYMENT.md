# Railway Deployment Guide for Opik

## 🚀 Full Stack Deploy (Recommended)

Railway supports deploying multiple services from docker-compose.yml files. This is the easiest way to deploy the complete Opik platform.

### Steps:
1. **Connect your GitHub repo** to Railway
2. **Create a new Railway project**
3. **Upload the docker-compose.yml** file (drag & drop into Railway dashboard)
4. **Railway will automatically create all services**:
   - Frontend (opik-frontend:5173)
   - Backend (opik-backend:8080) 
   - Python Backend (opik-python-backend:8000)
   - MySQL database
   - ClickHouse database
   - Redis cache
   - MinIO object storage
   - ZooKeeper (for ClickHouse)

### What Railway Does Automatically:
- ✅ Builds all Docker images
- ✅ Sets up internal networking between services
- ✅ Manages service dependencies and startup order
- ✅ Provides public URLs for web services
- ✅ Handles environment variable injection

## Environment Variables (Optional Customization)

You can override these in Railway's dashboard:

```
OPIK_VERSION=latest
OPIK_USAGE_REPORT_ENABLED=true
MINIO_ROOT_USER=THAAIOSFODNN7EXAMPLE
MINIO_ROOT_PASSWORD=LESlrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
PYTHON_CODE_EXECUTOR_STRATEGY=process
```

## Alternative: Individual Service Deployment

If you prefer to deploy services individually:

### Backend Only
1. Deploy using root `Dockerfile` 
2. Set up external databases manually

### Manual Service Setup
1. **Backend**: Deploy using `apps/opik-backend/Dockerfile`
2. **Frontend**: Deploy using `apps/opik-frontend/Dockerfile`  
3. **Python Backend**: Deploy using `apps/opik-python-backend/Dockerfile`

## Production Considerations

For production deployments, consider:
- **External managed databases** (PlanetScale MySQL, Railway PostgreSQL)
- **ClickHouse Cloud** for analytics
- **AWS S3** or **Railway volumes** for file storage
- **Separate environments** for staging/production

## Expected Services After Deployment

After successful deployment, you'll have:
- **Frontend**: `https://your-frontend.railway.app` (main UI)
- **Backend API**: `https://your-backend.railway.app` (REST API)
- **Python Backend**: `https://your-python-backend.railway.app` (evaluation engine)
- **Databases**: Internal networking (not publicly accessible)

## Troubleshooting

- **Service startup order**: Railway respects the `depends_on` configuration
- **Internal networking**: Services communicate using service names (e.g., `mysql:3306`)
- **Health checks**: Railway monitors service health automatically
- **Logs**: Available in Railway dashboard for each service