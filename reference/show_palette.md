# Draw a palette's swatches

Plots a palette as a row of colour swatches, optionally labelled with
the hex values. Uses base graphics, so it has no dependencies beyond R
itself.

## Usage

``` r
show_palette(x, labels = TRUE, title = NULL, border = "#FFFFFF")
```

## Arguments

- x:

  A palette object (a character vector of colours, such as
  `kawaii_tri_07`), or a palette ID string (`"kawaii_tri_07"`).

- labels:

  Whether to print the hex value on each swatch.

- title:

  A title for the plot. By default the palette ID is used when `x` is a
  recognised palette, and no title otherwise. Use `NULL` for none.

- border:

  Colour of the swatch borders, or `NA` for none.

## Value

`x`, invisibly. Called for its plot.

## See also

[`palettes()`](https://paulgp.com/japanesecolors/reference/palettes.md),
[`get_palette()`](https://paulgp.com/japanesecolors/reference/get_palette.md)

## Examples

``` r
show_palette(kawaii_tri_07)

show_palette("retro_multi_01")

show_palette(avantgarde_four_04, labels = FALSE)
```
