# Palettes containing provisional readings

Colour values were transcribed by hand from printed RGB labels. Where a
printed digit was not reliably legible, the reading is recorded as
provisional rather than being treated as confirmed. This function
reports every such swatch so the uncertainty stays visible.

## Usage

``` r
palettes_needing_review()
```

## Value

A data frame with one row per provisional **swatch**, giving the palette
ID, collection, swatch position, the candidate RGB and hex values, and
why the reading is uncertain.

## Details

These palettes are exported and usable like any other; the values are
the best available reading, not a guess at a nicer colour.

## See also

[`palettes()`](https://paulgp.github.io/japanese-colors/reference/palettes.md),
[`palette_info()`](https://paulgp.github.io/japanese-colors/reference/palette_info.md)

## Examples

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

# how many palettes are affected
length(unique(palettes_needing_review()$palette_id))
#> [1] 13
```
