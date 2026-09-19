# japanesecolors

149 curated colour palettes in four collections: **Retro**,
**Minimalism**, **Kawaii** and **Avant Garde**.

Every palette is an exported character vector of hex colours, so the API
is just the palette’s name.

Available for **R** and **Python**.

## Installation

``` r

# install.packages("pak")
pak::pak("paulgp/japanesecolors")
```

``` bash
# Python
pip install "japanesecolors[plot]"
```

## Usage

``` r

library(japanesecolors)

kawaii_tri_07
#> [1] "#3D7EB4" "#DF4472" "#E68C5F"
```

Which means palettes work anywhere R takes colours:

``` r

barplot(c(6, 9, 4, 7), col = avantgarde_four_04, border = NA, axes = FALSE)
```

![Bar chart of four bars coloured with the avantgarde_four_04
palette.](reference/figures/README-barplot-1.png)

``` r

show_palette(minimalism_multi_02)
```

![The seven swatches of minimalism_multi_02, each labelled with its hex
value.](reference/figures/README-show-1.png)

### ggplot2

``` r

library(ggplot2)

ggplot(iris, aes(Sepal.Length, Sepal.Width, colour = Species)) +
  geom_point(size = 2.5) +
  scale_colour_japanesecolors("kawaii_tri_07") +
  theme_minimal()
```

![Scatter plot of iris sepal measurements, the three species coloured
with kawaii_tri_07.](reference/figures/README-ggplot-1.png)

[`scale_fill_japanesecolors()`](https://paulgp.com/japanesecolors/reference/scale_japanesecolors.md)
and
[`scale_color_japanesecolors()`](https://paulgp.com/japanesecolors/reference/scale_japanesecolors.md)
work the same way, or pass the vector straight to
`scale_colour_manual(values = kawaii_tri_07)`.

## The collections

| Collection  | Palettes | Provisional |
|:------------|---------:|------------:|
| Retro       |       55 |           7 |
| Minimalism  |       28 |           0 |
| Kawaii      |       30 |           2 |
| Avant Garde |       36 |           4 |

![Two example palettes from each of the four collections, shown as rows
of colour swatches.](reference/figures/README-collection-examples-1.png)

## Browsing

IDs are `<collection>_<type>_<nn>`, where type is `bi`, `tri`, `four` or
`multi`. They are stable API.

``` r

palettes("kawaii", type = "tricolor")[, c("id", "n_colors", "status")]
#>               id n_colors      status
#> 1  kawaii_tri_01        3 transcribed
#> 2  kawaii_tri_02        3 transcribed
#> 3  kawaii_tri_03        3 transcribed
#> 4  kawaii_tri_04        3 transcribed
#> 5  kawaii_tri_05        3 transcribed
#> 6  kawaii_tri_06        3 transcribed
#> 7  kawaii_tri_07        3 transcribed
#> 8  kawaii_tri_08        3 transcribed
#> 9  kawaii_tri_09        3 transcribed
#> 10 kawaii_tri_10        3 transcribed
#> 11 kawaii_tri_11        3 transcribed
#> 12 kawaii_tri_12        3 transcribed
#> 13 kawaii_tri_13        3 transcribed
#> 14 kawaii_tri_14        3 transcribed
#> 15 kawaii_tri_15        3 transcribed
#> 16 kawaii_tri_16        3 transcribed
#> 17 kawaii_tri_17        3 transcribed
#> 18 kawaii_tri_18        3 transcribed
#> 19 kawaii_tri_19        3      review

# find one big enough for seven groups
palette_names(n = 7)
#> [1] "minimalism_multi_02" "minimalism_multi_05" "minimalism_multi_06"
#> [4] "kawaii_multi_03"

# look up by ID when the palette is chosen at runtime
get_palette("minimalism_multi_02")
#> [1] "#E66A5F" "#EDC2B6" "#CBB493" "#9E809B" "#395642" "#BFE3E7" "#CEBD35"
```

The visual gallery of all 149 palettes is on the [package
website](https://paulgp.com/japanesecolors/articles/gallery.html).

## Python

The same palettes, generated from the same canonical data, are available
for matplotlib:

``` python
import japanesecolors as jc

jc.kawaii_tri_07                  # ['#3D7EB4', '#DF4472', '#E68C5F']
plt.bar(range(3), y, color=jc.kawaii_tri_07)

jc.set_palette("avantgarde_four_04")   # default colour cycle
jc.register_cmaps()                    # then cmap="jc:retro_multi_01"
```

See
[`python/README.md`](https://paulgp.com/japanesecolors/python/README.md).
A test asserts the R and Python packages carry identical colour values.

## Provenance

Colour values were manually transcribed from the **printed RGB labels**
in *Japanese Color Matching*, edited and published by SendPoints
(Sendpoints Publishing Company Limited), 2022, ISBN 978-988-760-879-0.
Hex is computed from those triplets; nothing was sampled from
photographs or converted from CMYK, and no value was adjusted because
another colour looked more plausible.

`japanesecolors` is an independent, unaffiliated project. It is not
associated with, licensed by, endorsed by or approved by SendPoints. It
distributes this project’s transcription of RGB/hex colour values and
its own metadata — not the book’s text, layouts, photographs,
advertisements or other artwork — and is no substitute for the book
itself.

15 readings were not reliably legible and are marked provisional rather
than treated as confirmed:

``` r

palettes_needing_review()[, c("palette_id", "order", "hex")]
#>             palette_id order     hex
#> 1          retro_bi_13     1 #F4C03A
#> 2          retro_bi_14     1 #3071B9
#> 3          retro_bi_14     2 #E34950
#> 4         retro_tri_04     2 #00A9C4
#> 5         retro_tri_04     3 #EEC66F
#> 6         retro_tri_05     3 #E50D2B
#> 7         retro_tri_06     3 #659930
#> 8       retro_multi_04     2 #FFF100
#> 9       retro_multi_07     2 #EDE6C7
#> 10       kawaii_tri_19     2 #006356
#> 11     kawaii_multi_02     6 #F0C82B
#> 12    avantgarde_bi_08     2 #EFE531
#> 13 avantgarde_multi_05     6 #FAD8BC
#> 14 avantgarde_multi_06     2 #FFF208
#> 15 avantgarde_multi_10     4 #F7DCEA
```

They are still exported and usable; the value is the best available
reading of the printed label, not a guess at a nicer colour, and the
flag records that it could not be confirmed. The citation is available
at runtime as `japanesecolors:::SOURCE` in R and `japanesecolors.SOURCE`
in Python.

The MIT licence covers this package’s code, metadata and documentation.
It confers no rights in the source work.
