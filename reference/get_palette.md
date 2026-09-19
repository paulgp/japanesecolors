# Get a palette's colours by ID

Looks a palette up by its ID string. Useful when the palette is chosen
programmatically; when you know the palette at the time of writing, just
use the exported object (`kawaii_tri_07`) directly.

## Usage

``` r
get_palette(palette, n = NULL, reverse = FALSE)
```

## Arguments

- palette:

  A single palette ID, such as `"kawaii_tri_07"`.

- n:

  Optional number of colours to return, taken from the start of the
  palette. Colours are never recycled or interpolated, so `n` may not
  exceed the palette's length.

- reverse:

  Whether to reverse the colour order.

## Value

An unnamed character vector of hex colours.

## See also

[`palettes()`](https://paulgp.github.io/japanese-colors/reference/palettes.md),
[`palette_info()`](https://paulgp.github.io/japanese-colors/reference/palette_info.md),
[`show_palette()`](https://paulgp.github.io/japanese-colors/reference/show_palette.md)

## Examples

``` r
get_palette("kawaii_tri_07")
#> [1] "#3D7EB4" "#DF4472" "#E68C5F"
get_palette("retro_multi_01", n = 3)
#> [1] "#F8CCD1" "#D8B77C" "#E60E39"
get_palette("minimalism_bi_01", reverse = TRUE)
#> [1] "#DD6D83" "#5CB3CE"
```
