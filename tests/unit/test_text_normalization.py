from src.verdict_annotation.text_normalization import normalize_legal_text


def test_normalization_fixes_glued_names_and_roles() -> None:
    text = (
        "uz uče šć e namještenika suda RadevićSanje, JovićDragoja, "
        "kao predsjednika vijeća i sudija ĐuranovićDragane i AleksićSnežane."
    )

    normalized = normalize_legal_text(text)

    assert "učešće" in normalized
    assert "Radević Sanje" in normalized
    assert "Jović Dragoja" in normalized
    assert "Đuranović Dragane" in normalized
    assert "Aleksić Snežane" in normalized


def test_normalization_fixes_glued_name_with_internal_space_after_uppercase() -> None:
    text = "komisije vještaka psihijatra GolubovićŽ eljka i psihologa"

    normalized = normalize_legal_text(text)

    assert "Golubović Željka" in normalized


def test_normalization_preserves_space_before_initials() -> None:
    text = "u krivičnom predmetu protiv okrivljenogČ. S. iz P."

    normalized = normalize_legal_text(text)

    assert "okrivljenog Č.S." in normalized


def test_normalization_fixes_digit_prefixed_split_and_two_part_suffix() -> None:
    text = "trag br. 1puš ka kalibra 22 i u konkretnom sluč aj u tjelesni integritet"

    normalized = normalize_legal_text(text)

    assert "1puška" in normalized
    assert "slučaju" in normalized


def test_normalization_does_not_reglue_uppercase_initial_suffix() -> None:
    text = "čuo je da mu je rekao taćešA. više"

    normalized = normalize_legal_text(text)

    assert "taćeš A." in normalized


def test_normalization_merges_titlecase_suffix_fragment() -> None:
    text = "trag koji obiljež Ja predmet napada"

    normalized = normalize_legal_text(text)

    assert "obilježja" in normalized


def test_normalization_fixes_split_suffixes_and_kao_glue() -> None:
    text = "predsjednika vijeć a, sudija N.R. i N.T., kaočlanova vijeća, izvrš io radnju"

    normalized = normalize_legal_text(text)

    assert "vijeća" in normalized
    assert "kao članova" in normalized
    assert "izvršio" in normalized


def test_normalization_preserves_initials_spacing() -> None:
    text = "sudija M T, uz uče šć e zapisničara V T"

    normalized = normalize_legal_text(text)

    assert "M T" in normalized
    assert "V T" in normalized
    assert "učešće" in normalized
