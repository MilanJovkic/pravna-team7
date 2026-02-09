import sys
import requests

BASE_URL = "http://localhost:8000"


def assert_true(condition: bool, message: str):
    if not condition:
        raise AssertionError(message)


def get_json(path: str):
    response = requests.get(f"{BASE_URL}{path}", timeout=10)
    assert_true(response.status_code == 200, f"{path} status {response.status_code}")
    return response.json()


def main():
    print("Running API smoke tests...")

    health = get_json("/health")
    assert_true(health.get("status") == "healthy", "health status not healthy")

    chapters = get_json("/api/laws/chapters")
    assert_true("chapters" in chapters, "chapters key missing")
    assert_true(chapters.get("total", 0) > 0, "no chapters returned")

    article_144 = get_json("/api/laws/articles/144")
    assert_true(article_144.get("number") == "144", "article 144 not returned")
    assert_true("content" in article_144 and len(article_144["content"]) > 0, "article 144 content missing")

    verdicts = get_json("/api/verdicts")
    assert_true("verdicts" in verdicts, "verdicts key missing")
    verdict_list = verdicts.get("verdicts", [])
    assert_true(len(verdict_list) >= 5, "expected at least 5 verdicts")

    first = verdict_list[0]
    case_id = first.get("case_id")
    assert_true(case_id, "case_id missing in verdict list")

    detail = get_json(f"/api/verdicts/{case_id}")
    assert_true(detail.get("case_id") == case_id, "verdict detail mismatch")
    assert_true(detail.get("summary") is not None, "summary missing")
    assert_true(detail.get("applied_laws") is not None, "applied_laws missing")
    assert_true(detail.get("applied_articles") is not None, "applied_articles missing")

    search = get_json("/api/verdicts/search/?q=Krivični")
    assert_true("results" in search, "search results missing")

    print("✅ All API smoke tests passed.")


if __name__ == "__main__":
    try:
        main()
    except Exception as exc:
        print(f"❌ Test failed: {exc}")
        sys.exit(1)
