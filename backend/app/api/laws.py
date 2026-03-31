"""API endpoints for law documents."""
from fastapi import APIRouter, Depends, HTTPException, Query
from starlette.concurrency import run_in_threadpool

from backend.app.bootstrap.error_handling import map_exception_to_http
from backend.app.application.use_cases.law_queries import (
    GetLawArticleUseCase,
    GetLawChapterUseCase,
    GetLawChaptersUseCase,
    SearchLawArticlesUseCase,
)
from backend.app.services.law_service import LawService

router = APIRouter()


def get_law_service() -> LawService:
    """Provide law service dependency."""
    return LawService()


def get_law_chapters_use_case(
    service: LawService = Depends(get_law_service),
) -> GetLawChaptersUseCase:
    return GetLawChaptersUseCase(service)


def get_law_chapter_use_case(
    service: LawService = Depends(get_law_service),
) -> GetLawChapterUseCase:
    return GetLawChapterUseCase(service)


def get_law_article_use_case(
    service: LawService = Depends(get_law_service),
) -> GetLawArticleUseCase:
    return GetLawArticleUseCase(service)


def get_search_law_articles_use_case(
    service: LawService = Depends(get_law_service),
) -> SearchLawArticlesUseCase:
    return SearchLawArticlesUseCase(service)


@router.get("/chapters")
async def get_chapters(
    use_case: GetLawChaptersUseCase = Depends(get_law_chapters_use_case),
):
    """Get all law chapters."""
    try:
        return await run_in_threadpool(use_case.execute)
    except Exception as e:
        raise map_exception_to_http(e)


@router.get("/chapters/{chapter_number}")
async def get_chapter(
    chapter_number: str,
    use_case: GetLawChapterUseCase = Depends(get_law_chapter_use_case),
):
    """Get specific chapter with articles."""
    try:
        chapter = await run_in_threadpool(use_case.execute, chapter_number)
        if chapter is None:
            raise HTTPException(status_code=404, detail="Chapter not found")
        return chapter
    except HTTPException:
        raise
    except Exception as e:
        raise map_exception_to_http(e)


@router.get("/articles/{article_number}")
async def get_article(
    article_number: str,
    use_case: GetLawArticleUseCase = Depends(get_law_article_use_case),
):
    """Get specific article."""
    try:
        article = await run_in_threadpool(use_case.execute, article_number)
        if article is None:
            raise HTTPException(status_code=404, detail="Article not found")
        return article
    except HTTPException:
        raise
    except Exception as e:
        raise map_exception_to_http(e)


@router.get("/search")
async def search_articles(
    q: str = Query(..., min_length=2),
    use_case: SearchLawArticlesUseCase = Depends(get_search_law_articles_use_case),
):
    """Search articles by text or concept."""
    try:
        return await run_in_threadpool(use_case.execute, q)
    except Exception as e:
        raise map_exception_to_http(e)
