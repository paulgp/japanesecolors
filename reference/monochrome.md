# Monochrome reference swatches

Single-colour references printed alongside the matching palettes in the
Minimalism and Kawaii sections. They are recorded separately because
they are not matching palettes and are deliberately not combined into
one.

## Usage

``` r
monochrome(collection = NULL)
```

## Arguments

- collection:

  Optional collection name(s) to keep: `"retro"`, `"minimalism"`,
  `"kawaii"` and/or `"avantgarde"`. `NULL` (default) keeps all four.

## Value

A data frame with one row per monochrome swatch.

## Examples

``` r
monochrome()
#>                    id collection red green blue     hex      status
#> 1  minimalism_mono_01 minimalism 164    31   37 #A41F25 transcribed
#> 2  minimalism_mono_02 minimalism   0   143  208 #008FD0 transcribed
#> 3  minimalism_mono_03 minimalism 219    50   54 #DB3236 transcribed
#> 4  minimalism_mono_04 minimalism 235   111   35 #EB6F23 transcribed
#> 5  minimalism_mono_05 minimalism   1   154  123 #019A7B transcribed
#> 6  minimalism_mono_06 minimalism  31    49  143 #1F318F transcribed
#> 7  minimalism_mono_07 minimalism 233   220    1 #E9DC01 transcribed
#> 8  minimalism_mono_08 minimalism 239   147  187 #EF93BB transcribed
#> 9  minimalism_mono_09 minimalism 120   196  151 #78C497 transcribed
#> 10 minimalism_mono_10 minimalism  62    98   93 #3E625D transcribed
#> 11 minimalism_mono_11 minimalism  82    54   48 #523630 transcribed
#> 12 minimalism_mono_12 minimalism 255    64    0 #FF4000 transcribed
#> 13 minimalism_mono_13 minimalism  79   178   51 #4FB233 transcribed
#> 14 minimalism_mono_14 minimalism 255   255  255 #FFFFFF transcribed
#> 15     kawaii_mono_01     kawaii 128   201  236 #80C9EC transcribed
#> 16     kawaii_mono_02     kawaii 117    38   52 #752634 transcribed
#> 17     kawaii_mono_03     kawaii  38    90   65 #265A41 transcribed
#> 18     kawaii_mono_04     kawaii  45    68  134 #2D4486 transcribed
#> 19     kawaii_mono_05     kawaii 227   206   96 #E3CE60 transcribed
monochrome("kawaii")
#>               id collection red green blue     hex      status
#> 1 kawaii_mono_01     kawaii 128   201  236 #80C9EC transcribed
#> 2 kawaii_mono_02     kawaii 117    38   52 #752634 transcribed
#> 3 kawaii_mono_03     kawaii  38    90   65 #265A41 transcribed
#> 4 kawaii_mono_04     kawaii  45    68  134 #2D4486 transcribed
#> 5 kawaii_mono_05     kawaii 227   206   96 #E3CE60 transcribed
```
