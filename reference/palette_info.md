# Metadata for one palette

Metadata for one palette

## Usage

``` r
palette_info(palette)
```

## Arguments

- palette:

  A single palette ID, such as `"kawaii_tri_19"`.

## Value

A one-row data frame with the same columns as
[`palettes()`](https://paulgp.github.io/japanese-colors/reference/palettes.md),
plus a `colors` list-column holding the palette's hex vector.

## See also

[`palettes()`](https://paulgp.github.io/japanese-colors/reference/palettes.md),
[`palettes_needing_review()`](https://paulgp.github.io/japanese-colors/reference/palettes_needing_review.md)

## Examples

``` r
palette_info("retro_bi_01")
#>            id          name name_status collection collection_label family
#> 1 retro_bi_01 Ochre & brick   editorial      retro            Retro     bi
#>      type n_colors      status note           colors
#> 1 bicolor        2 transcribed      #EBB845, #C5351E

# provenance and the reason a reading is provisional
palette_info("kawaii_tri_19")$note
#> [1] "Swatch 2: The blue-channel final digit is blurred in the photograph. RGB (0, 99, 86) is the provisional reading; 86 versus 85 needs a closer source image. R and G are legible."
```
