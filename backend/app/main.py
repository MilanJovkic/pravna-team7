"""FastAPI application for legal document annotation system."""
from dotenv import load_dotenv
from fastapi import FastAPI
from fastapi import Response
from fastapi.middleware.cors import CORSMiddleware

from backend.app.bootstrap.error_handling import configure_error_handling
from backend.app.bootstrap.logging import configure_logging
from backend.app.bootstrap.settings import get_settings
from backend.app.api import laws, verdicts, reasoning, cases
from backend.app.api import verdict_generation

load_dotenv()
settings = get_settings()
configure_logging(settings.log_level)

app = FastAPI(
    title=settings.app_name,
    description=settings.app_description,
    version=settings.app_version,
)
configure_error_handling(app)

# CORS middleware za Angular frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(laws.router, prefix="/api/laws", tags=["Laws"])
app.include_router(verdicts.router, prefix="/api/verdicts", tags=["Verdicts"])
app.include_router(reasoning.router, prefix="/api/reasoning", tags=["Reasoning"])
app.include_router(cases.router, prefix="/api/cases", tags=["Cases"])
app.include_router(verdict_generation.router, prefix="/api/verdict-generation", tags=["Verdict Generation"])


@app.get("/")
async def root():
    """Root endpoint."""
    return {
        "message": settings.app_name,
        "version": settings.app_version,
        "endpoints": {
            "laws": "/api/laws",
            "verdicts": "/api/verdicts"
        }
    }


@app.get("/health")
async def health_check():
    """Health check endpoint."""
    return {"status": "healthy"}


@app.get("/favicon.ico", include_in_schema=False)
async def favicon() -> Response:
    """Return empty favicon response to avoid 404 noise in browser console."""
    return Response(status_code=204)
