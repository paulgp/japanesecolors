"""matplotlib helpers.

matplotlib is an optional dependency: the rest of the package works without
it. Install with ``pip install japanesecolors[plot]``.
"""

from __future__ import annotations

from ._palettes import CATALOGUE, PALETTES

#: distinguishes "derive a title" (default) from an explicit title=None
_AUTO = object()
_CATALOGUE_BY_ID = {c["id"]: c for c in CATALOGUE}


def _require_matplotlib():
    try:
        import matplotlib  # noqa: F401
    except ImportError:  # pragma: no cover - exercised only without matplotlib
        raise ImportError(
            "matplotlib is needed for japanesecolors plotting helpers. "
            'Install it with: pip install "japanesecolors[plot]"'
        ) from None
    return matplotlib


def _resolve(x, argname: str = "x"):
    """Accept a palette ID or a sequence of colours, and report which it was."""
    if isinstance(x, str):
        if x in PALETTES:
            return list(PALETTES[x]), x
        raise KeyError(
            f"Unknown palette {x!r}. Use japanesecolors.palette_names() to list them."
        )
    try:
        colours = list(x)
    except TypeError:
        raise TypeError(
            f"{argname} must be a palette ID or a sequence of colours"
        ) from None
    if not colours:
        raise ValueError(f"{argname} must not be empty")

    upper = [str(c).upper() for c in colours]
    for known_id, known in PALETTES.items():
        if upper == list(known):
            return [str(c) for c in colours], known_id
    return [str(c) for c in colours], None


def _contrast_text(hex_colour: str) -> str:
    """Black or white, whichever reads better on the swatch (WCAG luminance)."""
    from matplotlib.colors import to_rgb

    chan = []
    for v in to_rgb(hex_colour):
        chan.append(v / 12.92 if v <= 0.03928 else ((v + 0.055) / 1.055) ** 2.4)
    lum = 0.2126 * chan[0] + 0.7152 * chan[1] + 0.0722 * chan[2]
    return "#000000" if lum > 0.45 else "#FFFFFF"


def cmap(palette, reverse: bool = False, name: str | None = None):
    """Return a :class:`matplotlib.colors.ListedColormap` for a palette."""
    _require_matplotlib()
    from matplotlib.colors import ListedColormap

    colours, pid = _resolve(palette, "palette")
    if reverse:
        colours = list(reversed(colours))
    if name is None:
        name = (pid or "japanesecolors") + ("_r" if reverse else "")
    return ListedColormap(colours, name=name)


def register_cmaps(prefix: str = "jc") -> list[str]:
    """Register every palette with matplotlib as ``<prefix>:<palette_id>``.

    Registered names can then be used anywhere matplotlib accepts a colormap
    name, for example ``plt.scatter(..., cmap="jc:kawaii_tri_07")``.

    Returns the list of registered names. Re-registering is a no-op.
    """
    mpl = _require_matplotlib()

    registered = []
    for pid in PALETTES:
        name = f"{prefix}:{pid}"
        try:
            mpl.colormaps.register(cmap(pid, name=name), name=name)
        except ValueError:
            pass  # already registered
        registered.append(name)
    return registered


def color_cycler(palette, reverse: bool = False):
    """Return a :func:`cycler.cycler` over a palette's colours."""
    _require_matplotlib()
    from cycler import cycler

    colours, _ = _resolve(palette, "palette")
    if reverse:
        colours = list(reversed(colours))
    return cycler(color=colours)


def set_palette(palette, reverse: bool = False) -> list[str]:
    """Set matplotlib's default colour cycle (``axes.prop_cycle``).

    Returns the colours that were applied.
    """
    mpl = _require_matplotlib()

    colours, _ = _resolve(palette, "palette")
    if reverse:
        colours = list(reversed(colours))
    mpl.rcParams["axes.prop_cycle"] = color_cycler(colours)
    return colours


def show_palette(x, labels: bool = True, title=_AUTO, border: str = "#FFFFFF", ax=None):
    """Draw a palette as a row of swatches.

    Parameters
    ----------
    x:
        A palette ID (``"kawaii_tri_07"``) or a sequence of colours.
    labels:
        Whether to print the hex value on each swatch.
    title:
        Title for the plot. By default the palette ID is used when ``x`` is a
        recognised palette. Pass ``None`` for no title.
    border:
        Colour of the swatch borders, or ``None`` for none.
    ax:
        Existing axes to draw on. A new figure is created if omitted.

    Returns
    -------
    matplotlib.axes.Axes
    """
    _require_matplotlib()
    import matplotlib.pyplot as plt
    from matplotlib.patches import Rectangle

    colours, pid = _resolve(x)

    if title is _AUTO:
        title = None
        if pid is not None:
            info = _CATALOGUE_BY_ID[pid]
            title = pid
            if info["name"] != info["id"]:
                title = f"{pid} - {info['name']}"
            if info["status"] == "review":
                title += " (provisional reading)"

    if ax is None:
        _, ax = plt.subplots(figsize=(min(12, 1.1 * len(colours) + 1), 1.35))

    for i, colour in enumerate(colours):
        ax.add_patch(
            Rectangle(
                (i, 0), 1, 1,
                facecolor=colour,
                edgecolor=border if border else "none",
                linewidth=1.5 if border else 0,
            )
        )
        if labels:
            ax.text(
                i + 0.5, 0.5, colour,
                ha="center", va="center", rotation=90,
                color=_contrast_text(colour),
                fontsize=min(9, 72 / max(len(colours), 1)),
                fontweight="bold",
                family="monospace",
            )

    ax.set_xlim(0, len(colours))
    ax.set_ylim(0, 1)
    ax.set_xticks([])
    ax.set_yticks([])
    for spine in ax.spines.values():
        spine.set_visible(False)
    if title:
        ax.set_title(title, fontsize=10, loc="left")
    return ax


__all__ = [
    "cmap",
    "register_cmaps",
    "color_cycler",
    "set_palette",
    "show_palette",
]
