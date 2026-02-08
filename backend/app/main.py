"""FastAPI application for legal document annotation system."""
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from backend.app.api import laws, verdicts

app = FastAPI(
    title="Legal Annotation API",
    description="API za pristup anotiranim zakonima i sudskim presudama",
    version="1.0.0"
)

# CORS middleware za Angular frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:4200"],  # Angular dev server
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(laws.router, prefix="/api/laws", tags=["Laws"])
app.include_router(verdicts.router, prefix="/api/verdicts", tags=["Verdicts"])


@app.get("/")
async def root():
    """Root endpoint."""
    return {
        "message": "Legal Annotation API",
        "version": "1.0.0",
        "endpoints": {
            "laws": "/api/laws",
            "verdicts": "/api/verdicts"
        }
    }


@app.get("/health")
async def health_check():
    """Health check endpoint."""
    return {"status": "healthy"}
