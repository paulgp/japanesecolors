# japanesecolors (Python)

149 curated colour palettes in four collections — **Retro**, **Minimalism**,
**Kawaii** and **Avant Garde** — for matplotlib and general plotting.

This is the Python build of the [`japanesecolors`](https://github.com/paulgp/japanese-colors)
project. Both it and the R package are generated from the same canonical
palette data, so the two always agree.

## Install

```bash
pip install "japanesecolors[plot]"   # with matplotlib helpers
pip install japanesecolors           # data only, no dependencies
```

## Use

A palette is a list of hex colours, exported under its own name:

```python
from japanesecolors import kawaii_tri_07

kawaii_tri_07
# ['#3D7EB4', '#DF4472', '#E68C5F']
```

So it drops straight into matplotlib:

```python
import matplotlib.pyplot as plt
import japanesecolors as jc

plt.bar(range(3), [5, 8, 3], color=jc.kawaii_tri_07)
```

### Colour cycles and colormaps

```python
import japanesecolors as jc

# use a palette for every subsequent plot
jc.set_palette("avantgarde_four_04")

# a ListedColormap
jc.cmap("minimalism_multi_05")

# register all 149 for use by name
jc.register_cmaps()
plt.scatter(x, y, c=z, cmap="jc:retro_multi_01")
```

### Browsing

IDs are `<collection>_<type>_<nn>`, where type is `bi`, `tri`, `four` or
`multi`. They are stable API.

```python
import japanesecolors as jc

jc.palette_names("kawaii", type="tricolor")
jc.palettes(n=7)                      # wide enough for seven groups
jc.get_palette("retro_four_03", n=2)  # first two colours
jc.show_palette("retro_four_03")      # draw the swatches
jc.collections()
```

Palettes are curated categorical sets and are never stretched — asking for more
colours than a palette holds raises rather than recycling or interpolating.

## Provenance

Colour values were manually transcribed from *Japanese Color Matching*, edited
and published by SendPoints (Sendpoints Publishing Company Limited), 2022,
ISBN 978-988-760-879-0.

`japanesecolors` is an independent, unaffiliated project. It is not associated
with, licensed by, endorsed by or approved by SendPoints. It distributes this
project's transcription of RGB/hex colour values and its own metadata — not the
book's text, layouts, photographs, advertisements or other artwork — and is no
substitute for the book itself. The citation is available at runtime as
`japanesecolors.SOURCE`.

Some printed digits were not reliably legible. Those readings are recorded as
provisional rather than treated as confirmed:

```python
jc.palettes_needing_review()
```

They are still exported and usable; the value is the best available reading of
the printed label, not a guess at a nicer colour.

## Licence

MIT, covering this package's code, metadata and documentation. It confers no
rights in the source work.
