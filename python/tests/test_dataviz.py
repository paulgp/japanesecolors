"""The dataviz_friendly flag and the measurements behind it."""

from __future__ import annotations

import pytest

import japanesecolors as jc

METRICS = ("min_delta_e", "min_delta_e_cvd", "min_delta_e_white")


def test_catalogue_carries_the_dataviz_fields():
    for row in jc.palettes():
        assert isinstance(row["dataviz_friendly"], bool)
        for key in METRICS:
            assert isinstance(row[key], (int, float)), key
            assert row[key] >= 0


def test_some_pass_and_some_fail():
    rows = jc.palettes()
    assert 0 < sum(r["dataviz_friendly"] for r in rows) < len(rows)


def test_flag_agrees_with_measurements_and_thresholds():
    t = jc.DATAVIZ["thresholds"]
    for row in jc.palettes():
        expected = (
            row["min_delta_e"] >= t["min_delta_e"]
            and row["min_delta_e_cvd"] >= t["min_delta_e_cvd"]
            and row["min_delta_e_white"] >= t["min_delta_e_white"]
        )
        assert row["dataviz_friendly"] is expected, row["id"]


def test_cvd_separation_does_not_substantially_exceed_normal_vision():
    """Sanity check on the simulation: dichromacy should not pull colours apart.

    The Machado matrices are fitted linear approximations rather than strict
    projections onto a dichromat gamut, so with sRGB clamping a distance can
    creep up marginally -- retro_tri_11 goes 37.0 to 37.1. A large increase
    would mean the simulation is wrong, so the check allows slack but not much.
    """
    for row in jc.palettes():
        assert row["min_delta_e_cvd"] <= row["min_delta_e"] + 2.0, row["id"]


def test_filtering():
    yes = jc.palettes(dataviz_friendly=True)
    no = jc.palettes(dataviz_friendly=False)
    assert all(r["dataviz_friendly"] for r in yes)
    assert not any(r["dataviz_friendly"] for r in no)
    assert len(yes) + len(no) == len(jc.palettes())
    assert jc.palette_names(dataviz_friendly=True) == [r["id"] for r in yes]

    with pytest.raises(TypeError, match="True, False or None"):
        jc.palettes(dataviz_friendly="yes")


def test_filter_combines_with_others():
    rows = jc.palettes("retro", n=4, dataviz_friendly=True)
    assert all(
        r["collection"] == "retro" and r["n_colors"] == 4 and r["dataviz_friendly"]
        for r in rows
    )


def test_r_and_python_agree_on_the_flag():
    """The scores are computed once and shared, so the packages must match."""
    import json
    import pathlib

    shipped = pathlib.Path(jc.__file__).resolve().parents[3] / "inst" / "extdata" / (
        "japanesecolors-palettes.json"
    )
    if not shipped.exists():
        pytest.skip("not running from the source tree")
    with shipped.open(encoding="utf-8") as fh:
        r_rows = {p["id"]: p for p in json.load(fh)["palettes"]}

    for row in jc.palettes():
        r = r_rows[row["id"]]
        assert r["dataviz_friendly"] == row["dataviz_friendly"], row["id"]
        for key in METRICS:
            assert r[key] == pytest.approx(row[key]), f"{row['id']}/{key}"


def test_known_good_reference_palette_would_pass():
    """Sanity-check the thresholds against Okabe-Ito, which they are tuned to."""
    t = jc.DATAVIZ["thresholds"]
    assert t["min_delta_e"] <= 21.7
    assert t["min_delta_e_cvd"] <= 11.1
