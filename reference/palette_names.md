# Palette names

The stable IDs of the palettes matching a filter. Each ID is also the
name of an exported object, so `get_palette(palette_names("kawaii")[1])`
and `kawaii_bi_01` give the same colours.

## Usage

``` r
palette_names(collection = NULL, type = NULL, n = NULL, include_review = TRUE)
```

## Arguments

- collection:

  Optional collection name(s) to keep: `"retro"`, `"minimalism"`,
  `"kawaii"` and/or `"avantgarde"`. `NULL` (default) keeps all four.

- type:

  Optional matching type(s) to keep. Accepts either the printed names
  (`"bicolor"`, `"tricolor"`, `"four-color"`, `"multicolor"`) or the
  short codes used in palette IDs (`"bi"`, `"tri"`, `"four"`,
  `"multi"`).

- n:

  Optional palette size(s) to keep, as a number of colours.

- include_review:

  Whether to include palettes that contain a provisional swatch reading.
  `TRUE` by default, so nothing is hidden; the `status` column marks
  them and
  [`palettes_needing_review()`](https://paulgp.github.io/japanese-colors/reference/palettes_needing_review.md)
  lists them.

## Value

A character vector of palette IDs.

## See also

[`palettes()`](https://paulgp.github.io/japanese-colors/reference/palettes.md)
for the full catalogue.

## Examples

``` r
palette_names("avantgarde")
#>  [1] "avantgarde_bi_01"    "avantgarde_bi_02"    "avantgarde_bi_03"   
#>  [4] "avantgarde_bi_04"    "avantgarde_bi_05"    "avantgarde_bi_06"   
#>  [7] "avantgarde_bi_07"    "avantgarde_bi_08"    "avantgarde_tri_01"  
#> [10] "avantgarde_tri_02"   "avantgarde_tri_03"   "avantgarde_tri_04"  
#> [13] "avantgarde_tri_05"   "avantgarde_tri_06"   "avantgarde_tri_07"  
#> [16] "avantgarde_tri_08"   "avantgarde_tri_09"   "avantgarde_tri_10"  
#> [19] "avantgarde_tri_11"   "avantgarde_four_01"  "avantgarde_four_02" 
#> [22] "avantgarde_four_03"  "avantgarde_four_04"  "avantgarde_four_05" 
#> [25] "avantgarde_four_06"  "avantgarde_four_07"  "avantgarde_multi_01"
#> [28] "avantgarde_multi_02" "avantgarde_multi_03" "avantgarde_multi_04"
#> [31] "avantgarde_multi_05" "avantgarde_multi_06" "avantgarde_multi_07"
#> [34] "avantgarde_multi_08" "avantgarde_multi_09" "avantgarde_multi_10"
palette_names("minimalism", type = "bicolor")
#>  [1] "minimalism_bi_01" "minimalism_bi_02" "minimalism_bi_03" "minimalism_bi_04"
#>  [5] "minimalism_bi_05" "minimalism_bi_06" "minimalism_bi_07" "minimalism_bi_08"
#>  [9] "minimalism_bi_09" "minimalism_bi_10" "minimalism_bi_11" "minimalism_bi_12"
length(palette_names())
#> [1] 149
```
