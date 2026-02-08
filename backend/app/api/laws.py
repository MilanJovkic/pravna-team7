"""API endpoints for law documents."""
from fastapi import APIRouter, HTTPException, Query
from typing import List
from backend.app.models.schemas import LawChapter, LawArticle
from backend.app.services.law_service import LawService

router = APIRouter()
law_service = LawService()


@router.get("/chapters")
async def get_chapters():
    """Get all law chapters."""
    try:
        chapters = law_service.get_all_chapters()
        return {"chapters": chapters, "total": len(chapters)}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/chapters/{chapter_number}")
async def get_chapter(chapter_number: str):
    """Get specific chapter with articles."""
    try:
        chapter = law_service.get_chapter(chapter_number)
        if chapter is None:
            raise HTTPException(status_code=404, detail="Chapter not found")
        return chapter
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/articles/{article_number}")
async def get_article(article_number: str):
    """Get specific article."""
    try:
        article = law_service.get_article(article_number)
        if article is None:
            raise HTTPException(status_code=404, detail="Article not found")
        return article
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/search")
async def search_articles(q: str = Query(..., min_length=2)):
    """Search articles by text or concept."""
    try:
        results = law_service.search_articles(q)
        return {"total": len(results), "results": results}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
