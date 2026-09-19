# A palette function

Returns a function of `n` that gives the first `n` colours of a palette.
This is the form ggplot2's
[`ggplot2::discrete_scale()`](https://ggplot2.tidyverse.org/reference/discrete_scale.html)
and a number of other packages expect, and is what the `japanesecolors`
scales use internally.

## Usage

``` r
japanesecolors_pal(palette, reverse = FALSE)
```

## Arguments

- palette:

  A palette ID, such as `"kawaii_tri_07"`.

- reverse:

  Whether to reverse the colour order.

## Value

A function taking a single argument `n`, returning `n` hex colours.

## Details

The palettes are curated categorical sets, so the returned function
never interpolates or recycles: asking for more colours than the palette
holds is an error rather than a silently repeated or blended colour.

## See also

[`scale_colour_japanesecolors()`](https://paulgp.github.io/japanese-colors/reference/scale_japanesecolors.md),
[`get_palette()`](https://paulgp.github.io/japanese-colors/reference/get_palette.md)

## Examples

``` r
pal <- japanesecolors_pal("retro_four_03")
pal(2)
#> [1] "#E72922" "#1E53A4"
pal(4)
#> [1] "#E72922" "#1E53A4" "#006637" "#CAB06B"
```
