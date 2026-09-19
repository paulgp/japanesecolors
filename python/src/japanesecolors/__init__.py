"""Curated colour palettes in four collections.

Every palette is a module-level list of hex colours, so the primary interface
is just the palette's name::

    from japanesecolors import kawaii_tri_07
    kawaii_tri_07
    # ['#3D7EB4', '#DF4472', '#E68C5F']

Palette IDs have the form ``<collection>_<type>_<nn>``, where ``<type>`` is
``bi`` (bicolor), ``tri`` (tricolor), ``four`` (four-color) or ``multi``
(multicolor). They are stable API.

Colour values were manually transcribed from *Japanese Color Matching*, edited
and published by SendPoints (Sendpoints Publishing Company Limited), 2022,
ISBN 978-988-760-879-0. This is an independent, unaffiliated project, not
licensed or endorsed by the publisher; see ``japanesecolors.SOURCE``.
"""

from __future__ import annotations

import difflib
from collections.abc import Iterable

from ._palettes import *  # noqa: F401,F403
from ._palettes import (  # noqa: F401
    CATALOGUE,
    COLLECTIONS,
    DATAVIZ,
    MONOCHROME,
    PALETTES,
    SOURCE,
    SWATCHES,
)
from ._palettes import __all__ as _DATA_ALL

__version__ = "0.6.0"

COLLECTION_IDS = tuple(c["collection"] for c in COLLECTIONS)

#: printed matching type -> the short code used in palette IDs
_FAMILY_FROM_TYPE = {
    "bicolor": "bi",
    "tricolor": "tri",
    "four-color": "four",
    "multicolor": "multi",
}
FAMILY_IDS = tuple(_FAMILY_FROM_TYPE.values())
TYPE_IDS = tuple(_FAMILY_FROM_TYPE)

_CATALOGUE_BY_ID = {c["id"]: c for c in CATALOGUE}


def _as_tuple(x, argname: str) -> tuple | None:
    if x is None:
        return None
    if isinstance(x, str):
        return (x,)
    if isinstance(x, Iterable):
        return tuple(x)
    raise TypeError(f"{argname} must be a string or an iterable of strings")


def _check_collections(collection) -> tuple[str, ...] | None:
    vals = _as_tuple(collection, "collection")
    if vals is None:
        return None
    vals = tuple(str(v).lower() for v in vals)
    bad = [v for v in vals if v not in COLLECTION_IDS]
    if bad:
        raise ValueError(
            f"Unknown collection(s): {', '.join(map(repr, bad))}. "
            f"Available: {', '.join(COLLECTION_IDS)}."
        )
    return vals


def _check_types(type) -> tuple[str, ...] | None:  # noqa: A002 - matches the R argument name
    vals = _as_tuple(type, "type")
    if vals is None:
        return None
    out = []
    bad = []
    for v in (str(v).lower() for v in vals):
        if v in FAMILY_IDS:
            out.append(v)
        elif v in _FAMILY_FROM_TYPE:
            out.append(_FAMILY_FROM_TYPE[v])
        else:
            bad.append(v)
    if bad:
        raise ValueError(
            f"Unknown matching type(s): {', '.join(map(repr, bad))}. "
            f"Available: {', '.join(TYPE_IDS)} (or {', '.join(FAMILY_IDS)})."
        )
    return tuple(out)


def _check_sizes(n) -> tuple[int, ...] | None:
    if n is None:
        return None
    vals = (n,) if isinstance(n, int) and not isinstance(n, bool) else _as_tuple(n, "n")
    try:
        out = tuple(int(v) for v in vals)
    except (TypeError, ValueError):
        raise ValueError("n must be one or more positive whole numbers") from None
    if any(v < 1 for v in out):
        raise ValueError("n must be one or more positive whole numbers")
    return out


def _suggest(name: str) -> str:
    near = difflib.get_close_matches(name, list(PALETTES), n=3, cutoff=0.7)
    return f" Did you mean {', '.join(map(repr, near))}?" if near else ""


def palettes(  # noqa: A002
    collection=None, type=None, n=None, include_review=True, dataviz_friendly=None
):
    """Return the palette catalogue, optionally filtered.

    Parameters
    ----------
    collection:
        Collection name(s) to keep: ``"retro"``, ``"minimalism"``, ``"kawaii"``
        and/or ``"avantgarde"``. ``None`` keeps all four.
    type:
        Matching type(s) to keep. Accepts the printed names (``"bicolor"``,
        ``"tricolor"``, ``"four-color"``, ``"multicolor"``) or the short codes
        used in palette IDs (``"bi"``, ``"tri"``, ``"four"``, ``"multi"``).
    n:
        Palette size(s) to keep, as a number of colours.
    include_review:
        Whether to include palettes containing a provisional reading. ``True``
        by default so nothing is hidden; the ``status`` key marks them and
        :func:`palettes_needing_review` lists them.
    dataviz_friendly:
        Keep only palettes that screen well for data visualisation (``True``),
        or only those that do not (``False``). ``None``, the default, keeps
        both.

    Returns
    -------
    list of dict
        One dict per palette, with keys ``id``, ``name``, ``name_status``,
        ``collection``, ``collection_label``, ``family``, ``type``,
        ``n_colors``, ``status``, ``note``, ``dataviz_friendly``,
        ``min_delta_e``, ``min_delta_e_cvd`` and ``min_delta_e_white``.

    Notes
    -----
    These are design palettes, chosen to look good together rather than to
    encode categories, so many are unsuitable for charts. ``dataviz_friendly``
    screens for the two things that decide it: whether the colours stay
    separable under simulated deuteranopia, protanopia and tritanopia, and
    whether they are far enough apart to read as different at a glance. Both
    use CIEDE2000 on a palette's closest pair, since a palette is only as
    readable as the two colours most easily confused; a third check stops a
    near-white colour from vanishing against the page.

    Thresholds are calibrated so the Okabe-Ito palette, designed for
    colour-vision deficiency, passes; see :data:`DATAVIZ`. The underlying
    measurements ship with each palette, so a stricter or looser bar can be
    applied. Treat the flag as a screening aid, not a guarantee.
    """
    colls = _check_collections(collection)
    fams = _check_types(type)
    sizes = _check_sizes(n)
    if not isinstance(include_review, bool):
        raise TypeError("include_review must be True or False")
    if dataviz_friendly is not None and not isinstance(dataviz_friendly, bool):
        raise TypeError("dataviz_friendly must be True, False or None")

    out = []
    for row in CATALOGUE:
        if colls is not None and row["collection"] not in colls:
            continue
        if fams is not None and row["family"] not in fams:
            continue
        if sizes is not None and row["n_colors"] not in sizes:
            continue
        if not include_review and row["status"] != "transcribed":
            continue
        if dataviz_friendly is not None and row["dataviz_friendly"] is not dataviz_friendly:
            continue
        out.append(dict(row))
    return out


def palette_names(  # noqa: A002
    collection=None, type=None, n=None, include_review=True, dataviz_friendly=None
):
    """Return the stable IDs of the palettes matching a filter."""
    return [
        row["id"]
        for row in palettes(collection, type, n, include_review, dataviz_friendly)
    ]


def collections():
    """Return the four collections with their sizes."""
    return [dict(c) for c in COLLECTIONS]


def get_palette(palette: str, n: int | None = None, reverse: bool = False) -> list[str]:
    """Look a palette up by ID.

    Colours are never recycled or interpolated, so ``n`` may not exceed the
    palette's length.
    """
    if not isinstance(palette, str):
        raise TypeError('palette must be a single palette ID, such as "kawaii_tri_07"')
    if palette not in PALETTES:
        raise KeyError(
            f"Unknown palette {palette!r}.{_suggest(palette)} "
            "Use palette_names() to list them."
        )
    colours = list(PALETTES[palette])
    if reverse:
        colours.reverse()
    if n is not None:
        sizes = _check_sizes(n)
        if len(sizes) != 1:
            raise ValueError("n must be a single number")
        if sizes[0] > len(colours):
            raise ValueError(
                f"{palette!r} has {len(colours)} colours; {sizes[0]} requested. "
                "Pick a larger palette -- colours are not recycled or interpolated."
            )
        colours = colours[: sizes[0]]
    return colours


def palette_info(palette: str) -> dict:
    """Return metadata for one palette, with its colours attached."""
    if not isinstance(palette, str):
        raise TypeError("palette must be a single palette ID")
    if palette not in _CATALOGUE_BY_ID:
        raise KeyError(
            f"Unknown palette {palette!r}.{_suggest(palette)} "
            "Use palette_names() to list them."
        )
    out = dict(_CATALOGUE_BY_ID[palette])
    out["colors"] = list(PALETTES[palette])
    return out


def palettes_needing_review() -> list[dict]:
    """Return every provisional swatch reading.

    Colour values were transcribed by hand from printed RGB labels. Where a
    printed digit was not reliably legible, the reading is recorded as
    provisional rather than treated as confirmed. These palettes are exported
    and usable like any other; the value is the best available reading, not a
    guess at a nicer colour.
    """
    out = []
    for sw in SWATCHES:
        if sw["status"] != "review":
            continue
        meta = _CATALOGUE_BY_ID[sw["palette_id"]]
        row = dict(sw)
        row["collection_label"] = meta["collection_label"]
        row["type"] = meta["type"]
        out.append(row)
    return out


def monochrome(collection=None) -> list[dict]:
    """Return the single-colour reference swatches.

    These are printed alongside the matching palettes but are not palettes, so
    they are kept separate rather than merged into one.
    """
    colls = _check_collections(collection)
    return [
        dict(m) for m in MONOCHROME if colls is None or m["collection"] in colls
    ]


def _lazy(name: str):
    from . import plotting

    return getattr(plotting, name)


_AUTO_TITLE = object()


def show_palette(x, labels: bool = True, title=_AUTO_TITLE, border: str = "#FFFFFF", ax=None):
    """Draw a palette's swatches. Requires matplotlib."""
    from . import plotting

    if title is _AUTO_TITLE:
        title = plotting._AUTO
    return plotting.show_palette(x, labels=labels, title=title, border=border, ax=ax)


def cmap(palette: str, reverse: bool = False, name: str | None = None):
    """Return a matplotlib ``ListedColormap`` for a palette."""
    return _lazy("cmap")(palette, reverse=reverse, name=name)


def register_cmaps(prefix: str = "jc") -> list[str]:
    """Register every palette with matplotlib as ``<prefix>:<palette_id>``."""
    return _lazy("register_cmaps")(prefix=prefix)


def set_palette(palette: str, reverse: bool = False) -> list[str]:
    """Set matplotlib's default colour cycle to a palette."""
    return _lazy("set_palette")(palette, reverse=reverse)


def color_cycler(palette: str, reverse: bool = False):
    """Return a matplotlib ``cycler`` over a palette's colours."""
    return _lazy("color_cycler")(palette, reverse=reverse)


__all__ = [
    "palettes",
    "palette_names",
    "collections",
    "get_palette",
    "palette_info",
    "palettes_needing_review",
    "monochrome",
    "show_palette",
    "cmap",
    "register_cmaps",
    "set_palette",
    "color_cycler",
    "COLLECTION_IDS",
    "DATAVIZ",
    "FAMILY_IDS",
    "TYPE_IDS",
    "__version__",
    *_DATA_ALL,
]
