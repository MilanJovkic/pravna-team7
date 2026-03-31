import unittest
from xml.etree import ElementTree as ET

from backend.app.services.verdict_service import VerdictService


class _FakeVerdictRepository:
    def __init__(self):
        self.iter_called = False
        self.load_called = False

    def iter_verdict_documents(self):
        self.iter_called = True
        xml = """
        <akomaNtoso>
          <judgment name="CASE-1">
            <docNumber>K-1/26</docNumber>
            <docTitle>Osnovni sud</docTitle>
            <docDate date="2026-03-31" />
            <judge>Sudija 1</judge>
            <block name="summary"><p>Kratak opis</p></block>
            <block name="verdict" outcome="osudjen"><p>Presuda</p></block>
            <block name="fullText"><p>Presuda sa detaljima i kazna zatvora.</p></block>
          </judgment>
        </akomaNtoso>
        """
        root = ET.fromstring(xml)
        yield "CASE-1", {"file": "fake.xml", "tree": None, "root": root}

    def load_verdict_documents(self):
        self.load_called = True
        raise AssertionError("load_verdict_documents should not be used in lazy path")

    def load_annotations(self):
        return {}


class _FakeOverrideRepository:
    overrides_file_path = "overrides.json"
    audit_file_path = "overrides_audit.json"

    def load_overrides(self):
        return {}, "rev0"

    def save_overrides(self, data, expected_revision):
        return "rev1"

    def load_audit(self):
        return {}, "rev0"

    def save_audit(self, data, expected_revision):
        return "rev1"


class TestVerdictServiceLazyIteration(unittest.TestCase):
    def test_get_all_and_search_use_iterator_path(self):
        verdict_repo = _FakeVerdictRepository()
        service = VerdictService(
            verdict_repository=verdict_repo,
            override_repository=_FakeOverrideRepository(),
        )

        all_items = service.get_all_verdicts()
        self.assertEqual(len(all_items), 1)
        self.assertTrue(verdict_repo.iter_called)
        self.assertFalse(verdict_repo.load_called)

        results = service.search_verdicts("K-1/26")
        self.assertEqual(len(results), 1)


if __name__ == "__main__":
    unittest.main()