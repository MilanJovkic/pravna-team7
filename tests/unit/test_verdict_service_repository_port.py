import unittest
from xml.etree import ElementTree as ET

from backend.app.services.verdict_service import VerdictService


class _FakeVerdictRepository:
    def __init__(self):
        xml = """
        <akomaNtoso xmlns=\"http://docs.oasis-open.org/legaldocml/ns/akn/3.0/WD17\">
          <judgment name=\"CASE-1\">
            <meta>
              <identification>
                <FRBRWork><FRBRthis value=\"/cg/judgment/CASE-1\"/></FRBRWork>
              </identification>
            </meta>
            <docTitle>Osnovni sud</docTitle>
            <docNumber>K-1</docNumber>
            <docDate date=\"2026-03-31\" />
            <body>
              <block name=\"fullText\"><p>Tekst</p></block>
            </body>
          </judgment>
        </akomaNtoso>
        """
        root = ET.fromstring(xml)
        self._docs = {"CASE-1": {"file": "fake.xml", "tree": ET.ElementTree(root), "root": root}}
        self._annotations = {
            "CASE-1": {
                "verdict_summary": "Sažetak",
                "case_outcome": "osudjen",
                "legal_issues": ["povreda"],
                "applied_laws": ["Krivicni zakonik"],
                "applied_articles": ["Clan 151"],
            }
        }

    def load_verdict_documents(self):
        return self._docs

    def load_annotations(self):
        return self._annotations


class _FakeOverrideRepository:
    @property
    def overrides_file_path(self):
        return "overrides.json"

    @property
    def audit_file_path(self):
        return "audit.json"

    def load_overrides(self):
        return {}, "missing"

    def save_overrides(self, data, expected_revision):
        _ = data
        _ = expected_revision
        return "rev1"

    def load_audit(self):
        return {}, "missing"

    def save_audit(self, data, expected_revision):
        _ = data
        _ = expected_revision
        return "rev2"


class TestVerdictServiceRepositoryPort(unittest.TestCase):
    def test_reads_verdicts_via_repository_port(self):
        service = VerdictService(
            verdict_repository=_FakeVerdictRepository(),
            override_repository=_FakeOverrideRepository(),
        )

        verdicts = service.get_all_verdicts()

        self.assertEqual(1, len(verdicts))
        self.assertEqual("CASE-1", verdicts[0]["case_id"])
        self.assertEqual("K-1", verdicts[0]["case_number"])
        self.assertEqual("osudjen", verdicts[0]["outcome"])


if __name__ == "__main__":
    unittest.main()
