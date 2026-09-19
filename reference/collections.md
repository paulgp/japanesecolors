# The palette collections

The palette collections

## Usage

``` r
collections()
```

## Value

A data frame with one row per collection, giving its ID, display label,
number of palettes, number of palettes containing a provisional reading,
and a short provenance note.

## See also

[`palettes()`](https://paulgp.com/japanesecolors/reference/palettes.md)

## Examples

``` r
collections()
#>   collection       label n_palettes n_review
#> 1      retro       Retro         55        7
#> 2 minimalism  Minimalism         28        0
#> 3     kawaii      Kawaii         30        2
#> 4 avantgarde Avant Garde         36        4
#>                                                                                                                                           source_note
#> 1 User-provided photographs of the Retro Sense section. Full book title, author, publisher, edition, and reuse permissions have not been established.
#> 2        User identified this collection as Minimalism. Full book title, author, publisher, edition, and reuse permissions have not been established.
#> 3            User identified this collection as Kawaii. Full book title, author, publisher, edition, and reuse permissions have not been established.
#> 4                                                                                                     User identified this collection as Avant Garde.
```
