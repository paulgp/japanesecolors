"""Discovery, lookup, and the matplotlib helpers."""

from __future__ import annotations

import pytest

import japanesecolors as jc

matplotlib = pytest.importorskip("matplotlib")
matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402

# -- discovery ---------------------------------------------------------------

def test_palettes_returns_documented_keys():
    rows = jc.palettes()
    assert rows
    assert set(rows[0]) == {
        "id", "name", "name_status", "collection", "collection_label",
        "family", "type", "n_colors", "status", "note",
    }


def test_collection_filtering_partitions_the_catalogue():
    total = 0
    for coll in jc.COLLECTION_IDS:
        rows = jc.palettes(coll)
        assert rows
        assert all(r["collection"] == coll for r in rows)
        assert all(r["id"].startswith(coll + "_") for r in rows)
        total += len(rows)
    assert total == len(jc.palettes())


def test_collection_filtering_is_case_insensitive():
    assert jc.palettes("KAWAII") == jc.palettes("kawaii")


def test_multiple_collections():
    assert len(jc.palettes(["retro", "kawaii"])) == len(jc.palettes("retro")) + len(
        jc.palettes("kawaii")
    )


def test_type_filtering_accepts_names_and_codes():
    assert jc.palettes(type="tricolor") == jc.palettes(type="tri")
    assert jc.palettes(type="four-color") == jc.palettes(type="four")
    assert all(r["n_colors"] == 2 for r in jc.palettes(type="bicolor"))
    assert all(r["n_colors"] >= 5 for r in jc.palettes(type="multicolor"))


def test_size_filtering():
    for k in (2, 3, 4, 5):
        assert all(r["n_colors"] == k for r in jc.palettes(n=k))
    assert all(r["n_colors"] in (6, 7) for r in jc.palettes(n=[6, 7]))
    assert jc.palettes(n=999) == []


def test_filters_combine():
    rows = jc.palettes("kawaii", type="tri")
    assert all(r["collection"] == "kawaii" and r["n_colors"] == 3 for r in rows)


def test_include_review():
    everything = jc.palettes(include_review=True)
    clean = jc.palettes(include_review=False)
    assert len(clean) < len(everything)
    assert all(r["status"] == "transcribed" for r in clean)
    assert len(everything) - len(clean) == sum(
        1 for r in everything if r["status"] == "review"
    )


def test_bad_filters_raise():
    with pytest.raises(ValueError, match="Unknown collection"):
        jc.palettes("nope")
    with pytest.raises(ValueError, match="Unknown matching type"):
        jc.palettes(type="quintcolor")
    with pytest.raises(ValueError, match="positive whole"):
        jc.palettes(n=0)
    with pytest.raises(TypeError, match="True or False"):
        jc.palettes(include_review="yes")


def test_palette_names_agrees_with_palettes():
    assert jc.palette_names() == [r["id"] for r in jc.palettes()]
    assert jc.palette_names("avantgarde") == [r["id"] for r in jc.palettes("avantgarde")]


def test_collections_counts_match():
    for row in jc.collections():
        assert row["n_palettes"] == len(jc.palettes(row["collection"]))
        assert row["n_review"] == sum(
            1 for r in jc.palettes(row["collection"]) if r["status"] == "review"
        )
    assert sum(r["n_palettes"] for r in jc.collections()) == len(jc.palettes())


# -- lookup ------------------------------------------------------------------

def test_get_palette():
    assert jc.get_palette("kawaii_tri_07") == jc.kawaii_tri_07
    assert jc.get_palette("retro_multi_01", n=3) == jc.retro_multi_01[:3]
    assert jc.get_palette("retro_multi_01", reverse=True) == list(
        reversed(jc.retro_multi_01)
    )
    # reverse applies before n
    assert jc.get_palette("retro_multi_01", n=2, reverse=True) == list(
        reversed(jc.retro_multi_01)
    )[:2]


def test_get_palette_returns_a_copy():
    pal = jc.get_palette("kawaii_tri_07")
    pal.append("#000000")
    assert jc.kawaii_tri_07 == jc.get_palette("kawaii_tri_07")


def test_get_palette_never_stretches():
    with pytest.raises(ValueError, match="not recycled or interpolated"):
        jc.get_palette("kawaii_tri_07", n=4)


def test_get_palette_errors():
    with pytest.raises(KeyError, match="Unknown palette"):
        jc.get_palette("nope")
    with pytest.raises(TypeError):
        jc.get_palette(1)
    with pytest.raises(KeyError, match="Did you mean"):
        jc.get_palette("kawaii_tri_7")


def test_palette_info():
    info = jc.palette_info("retro_bi_01")
    assert info["id"] == "retro_bi_01"
    assert info["colors"] == jc.retro_bi_01
    assert info["type"] == "bicolor"
    with pytest.raises(KeyError):
        jc.palette_info("nope")


def test_monochrome():
    mono = jc.monochrome()
    assert mono
    assert all(m["collection"] in ("minimalism", "kawaii") for m in mono)
    assert len(jc.monochrome("kawaii")) == sum(
        1 for m in mono if m["collection"] == "kawaii"
    )
    with pytest.raises(ValueError):
        jc.monochrome("nope")


# -- plotting ----------------------------------------------------------------

def test_cmap():
    from matplotlib.colors import ListedColormap

    cm = jc.cmap("kawaii_tri_07")
    assert isinstance(cm, ListedColormap)
    assert cm.N == 3
    assert jc.cmap("kawaii_tri_07", reverse=True).colors == list(
        reversed(jc.kawaii_tri_07)
    )


def test_register_cmaps():
    names = jc.register_cmaps()
    assert "jc:kawaii_tri_07" in names
    assert len(names) == len(jc.palette_names())
    # registering twice must not raise
    jc.register_cmaps()
    assert matplotlib.colormaps["jc:kawaii_tri_07"].N == 3


def test_color_cycler_and_set_palette():
    cyc = jc.color_cycler("retro_four_03")
    assert [d["color"] for d in cyc] == jc.retro_four_03

    original = matplotlib.rcParams["axes.prop_cycle"]
    try:
        applied = jc.set_palette("kawaii_tri_07")
        assert applied == jc.kawaii_tri_07
        assert matplotlib.rcParams["axes.prop_cycle"].by_key()["color"] == jc.kawaii_tri_07
    finally:
        matplotlib.rcParams["axes.prop_cycle"] = original


def test_show_palette_accepts_ids_vectors_and_options():
    for arg in ("kawaii_tri_07", jc.kawaii_tri_07, ["#FF0000", "#00FF00"]):
        expected = len(jc.get_palette(arg)) if isinstance(arg, str) else len(arg)
        ax = jc.show_palette(arg)
        assert len(ax.patches) == expected
        plt.close(ax.figure)

    ax = jc.show_palette("retro_bi_01", labels=False, title="Custom", border=None)
    assert ax.get_title(loc="left") == "Custom"
    plt.close(ax.figure)

    # title=None means no title, distinct from the default
    ax = jc.show_palette("retro_bi_01", title=None)
    assert ax.get_title(loc="left") == ""
    plt.close(ax.figure)


def test_show_palette_titles_known_palettes():
    ax = jc.show_palette("retro_bi_01")
    assert "retro_bi_01" in ax.get_title(loc="left")
    plt.close(ax.figure)

    ax = jc.show_palette("kawaii_tri_19")  # a flagged palette
    assert "provisional" in ax.get_title(loc="left")
    plt.close(ax.figure)


def test_show_palette_rejects_bad_input():
    with pytest.raises(KeyError):
        jc.show_palette("not-a-palette")
    with pytest.raises(ValueError):
        jc.show_palette([])
    with pytest.raises(TypeError):
        jc.show_palette(3)


def test_every_palette_can_be_drawn():
    fig, ax = plt.subplots()
    for pid in jc.palette_names():
        ax.clear()
        jc.show_palette(pid, ax=ax)
    plt.close(fig)


def test_palettes_work_directly_in_matplotlib():
    fig, ax = plt.subplots()
    bars = ax.bar(range(3), [1, 2, 3], color=jc.kawaii_tri_07)
    assert len(bars) == 3
    plt.close(fig)
