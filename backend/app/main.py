"""FastAPI application for legal document annotation system."""
from dotenv import load_dotenv
from fastapi import FastAPI
from fastapi import Response
from fastapi.middleware.cors import CORSMiddleware
from backend.app.api import laws, verdicts, reasoning, cases
from backend.app.api import verdict_generation

load_dotenv()

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
app.include_router(reasoning.router, prefix="/api/reasoning", tags=["Reasoning"])
app.include_router(cases.router, prefix="/api/cases", tags=["Cases"])
app.include_router(verdict_generation.router, prefix="/api/verdict-generation", tags=["Verdict Generation"])


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


@app.get("/favicon.ico", include_in_schema=False)
async def favicon() -> Response:
    """Return empty favicon response to avoid 404 noise in browser console."""
    return Response(status_code=204)
