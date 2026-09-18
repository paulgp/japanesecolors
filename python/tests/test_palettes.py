"""Palette objects, catalogue agreement, and data integrity."""

from __future__ import annotations

import json
import pathlib
import re

import pytest

import japanesecolors as jc

HEX = re.compile(r"^#[0-9A-F]{6}$")
EXPECTED_N = {"bi": 2, "tri": 3, "four": 4}

REPO_ROOT = pathlib.Path(__file__).resolve().parents[2]
CANONICAL = REPO_ROOT / "inst" / "extdata" / "japanesecolors-palettes.json"


def canonical_palettes():
    """The canonical record that ships with the package, keyed by palette ID."""
    if not CANONICAL.exists():
        pytest.skip("not running from the source tree")
    with CANONICAL.open(encoding="utf-8") as fh:
        return {p["id"]: p for p in json.load(fh)["palettes"]}


def test_every_catalogued_palette_is_a_module_attribute():
    for pid in jc.palette_names():
        assert hasattr(jc, pid), f"{pid} is not exported"
        assert pid in jc.__all__


def test_palette_objects_are_lists_of_valid_hex():
    for pid in jc.palette_names():
        pal = getattr(jc, pid)
        assert isinstance(pal, list)
        assert pal
        for colour in pal:
            assert isinstance(colour, str)
            assert HEX.match(colour), f"{pid}: {colour!r}"


def test_palette_objects_match_the_catalogue():
    for row in jc.palettes():
        pal = getattr(jc, row["id"])
        assert pal == jc.get_palette(row["id"])
        assert len(pal) == row["n_colors"]


def test_palette_lengths_match_matching_type():
    for row in jc.palettes():
        if row["family"] in EXPECTED_N:
            assert row["n_colors"] == EXPECTED_N[row["family"]], row["id"]
        else:
            assert row["n_colors"] >= 5, row["id"]


def test_ids_are_unique_and_well_formed():
    ids = [row["id"] for row in jc.palettes()]
    assert len(ids) == len(set(ids))
    pattern = re.compile(r"^(retro|minimalism|kawaii|avantgarde)_(bi|tri|four|multi)_[0-9]{2}$")
    for row in jc.palettes():
        assert pattern.match(row["id"]), row["id"]
        collection, family, _ = row["id"].split("_")
        assert collection == row["collection"]
        assert family == row["family"]


def test_numbering_is_contiguous_within_collection_and_type():
    groups: dict[tuple[str, str], list[int]] = {}
    for row in jc.palettes():
        groups.setdefault((row["collection"], row["family"]), []).append(
            int(row["id"].rsplit("_", 1)[1])
        )
    for key, nums in groups.items():
        assert sorted(nums) == list(range(1, len(nums) + 1)), key


def test_matches_the_canonical_transcription():
    canon = canonical_palettes()
    assert len(canon) == len(jc.palettes())
    for pid, p in canon.items():
        expected = [sw["hex"].upper() for sw in p["colors"]]
        assert getattr(jc, pid) == expected, pid


def test_rgb_and_hex_agree_in_canonical_data():
    for pid, p in canonical_palettes().items():
        for sw in p["colors"]:
            r, g, b = sw["rgb"]
            assert 0 <= r <= 255 and 0 <= g <= 255 and 0 <= b <= 255
            assert sw["hex"].upper() == f"#{r:02X}{g:02X}{b:02X}", pid


def test_python_and_r_packages_agree():
    """Both languages are generated from the same canonical JSON."""
    canon = canonical_palettes()
    r_palettes = {pid: [c["hex"].upper() for c in p["colors"]] for pid, p in canon.items()}
    assert r_palettes == jc.PALETTES


def test_review_status_is_consistent():
    canon = canonical_palettes()
    flagged = {row["id"] for row in jc.palettes() if row["status"] == "review"}
    from_canon = {
        pid
        for pid, p in canon.items()
        if any(sw["status"] == "review" for sw in p["colors"])
    }
    assert flagged == from_canon
    assert {r["palette_id"] for r in jc.palettes_needing_review()} == flagged


def test_every_provisional_swatch_explains_itself():
    review = jc.palettes_needing_review()
    assert review
    for row in review:
        assert row["note"].strip(), row["palette_id"]
        assert row["hex"] == f"#{row['red']:02X}{row['green']:02X}{row['blue']:02X}"


def test_no_source_location_metadata_is_shipped():
    """The source book's page structure must not reach the distributed package."""
    leaked = {"design_ref", "source_photo", "reference_sheet", "source_position"}
    for row in jc.palettes():
        assert not (leaked & set(row))
    module = pathlib.Path(jc._palettes.__file__).read_text(encoding="utf-8")
    for field in (*leaked, "IMG_"):
        assert field not in module, field


def test_source_citation_is_present():
    src = jc.SOURCE
    assert src["title"] == "Japanese Color Matching"
    assert "SendPoints" in src["publisher"]
    assert src["isbn"] == "978-988-760-879-0"
    assert src["year"] == 2022
    # the disclaimer must not be softened away
    for phrase in ("independent", "unaffiliated", "not associated with"):
        assert phrase in src["relationship"].lower()
