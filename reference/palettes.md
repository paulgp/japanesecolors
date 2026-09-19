# The palette catalogue

Returns the palette catalogue as a data frame, optionally filtered. This
is the main way to browse what is in the package.

## Usage

``` r
palettes(collection = NULL, type = NULL, n = NULL, include_review = TRUE)
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
  [`palettes_needing_review()`](https://paulgp.com/japanesecolors/reference/palettes_needing_review.md)
  lists them.

## Value

A data frame with one row per palette and the columns:

- id:

  Stable palette ID, and the name of the exported object.

- name:

  Display name, or the ID where no name has been assigned.

- name_status:

  `"editorial"` for names written by this project, `"pending"` where
  none has been assigned.

- collection, collection_label:

  Collection ID and display label.

- family, type:

  Matching type, as a short code and printed name.

- n_colors:

  Number of colours.

- status:

  `"transcribed"` or `"review"`.

- note:

  Free text, including why any swatch is provisional.

## See also

[`palette_names()`](https://paulgp.com/japanesecolors/reference/palette_names.md)
for just the IDs,
[`get_palette()`](https://paulgp.com/japanesecolors/reference/get_palette.md)
to fetch colours,
[`show_palette()`](https://paulgp.com/japanesecolors/reference/show_palette.md)
to draw them.

## Examples

``` r
head(palettes())
#>            id            name name_status collection collection_label family
#> 1 retro_bi_01   Ochre & brick   editorial      retro            Retro     bi
#> 2 retro_bi_02  Plum & apricot   editorial      retro            Retro     bi
#> 3 retro_bi_03  Violet & olive   editorial      retro            Retro     bi
#> 4 retro_bi_04      Gold & ink   editorial      retro            Retro     bi
#> 5 retro_bi_05 Blue & charcoal   editorial      retro            Retro     bi
#> 6 retro_bi_06     Moss & clay   editorial      retro            Retro     bi
#>      type n_colors      status note
#> 1 bicolor        2 transcribed     
#> 2 bicolor        2 transcribed     
#> 3 bicolor        2 transcribed     
#> 4 bicolor        2 transcribed     
#> 5 bicolor        2 transcribed     
#> 6 bicolor        2 transcribed     

# everything in one collection
palettes("kawaii")
#>                 id            name name_status collection collection_label
#> 1     kawaii_bi_01    kawaii_bi_01     pending     kawaii           Kawaii
#> 2    kawaii_tri_01   kawaii_tri_01     pending     kawaii           Kawaii
#> 3    kawaii_tri_02   kawaii_tri_02     pending     kawaii           Kawaii
#> 4    kawaii_tri_03   kawaii_tri_03     pending     kawaii           Kawaii
#> 5    kawaii_tri_04   kawaii_tri_04     pending     kawaii           Kawaii
#> 6    kawaii_tri_05   kawaii_tri_05     pending     kawaii           Kawaii
#> 7    kawaii_tri_06   kawaii_tri_06     pending     kawaii           Kawaii
#> 8    kawaii_tri_07   kawaii_tri_07     pending     kawaii           Kawaii
#> 9    kawaii_tri_08   kawaii_tri_08     pending     kawaii           Kawaii
#> 10   kawaii_tri_09   kawaii_tri_09     pending     kawaii           Kawaii
#> 11   kawaii_tri_10   kawaii_tri_10     pending     kawaii           Kawaii
#> 12   kawaii_tri_11   kawaii_tri_11     pending     kawaii           Kawaii
#> 13   kawaii_tri_12   kawaii_tri_12     pending     kawaii           Kawaii
#> 14   kawaii_tri_13   kawaii_tri_13     pending     kawaii           Kawaii
#> 15   kawaii_tri_14   kawaii_tri_14     pending     kawaii           Kawaii
#> 16   kawaii_tri_15   kawaii_tri_15     pending     kawaii           Kawaii
#> 17   kawaii_tri_16   kawaii_tri_16     pending     kawaii           Kawaii
#> 18   kawaii_tri_17   kawaii_tri_17     pending     kawaii           Kawaii
#> 19   kawaii_tri_18   kawaii_tri_18     pending     kawaii           Kawaii
#> 20   kawaii_tri_19   kawaii_tri_19     pending     kawaii           Kawaii
#> 21  kawaii_four_01  kawaii_four_01     pending     kawaii           Kawaii
#> 22  kawaii_four_02  kawaii_four_02     pending     kawaii           Kawaii
#> 23 kawaii_multi_01 kawaii_multi_01     pending     kawaii           Kawaii
#> 24 kawaii_multi_02 kawaii_multi_02     pending     kawaii           Kawaii
#> 25 kawaii_multi_03 kawaii_multi_03     pending     kawaii           Kawaii
#> 26 kawaii_multi_04 kawaii_multi_04     pending     kawaii           Kawaii
#> 27 kawaii_multi_05 kawaii_multi_05     pending     kawaii           Kawaii
#> 28 kawaii_multi_06 kawaii_multi_06     pending     kawaii           Kawaii
#> 29 kawaii_multi_07 kawaii_multi_07     pending     kawaii           Kawaii
#> 30 kawaii_multi_08 kawaii_multi_08     pending     kawaii           Kawaii
#>    family       type n_colors      status
#> 1      bi    bicolor        2 transcribed
#> 2     tri   tricolor        3 transcribed
#> 3     tri   tricolor        3 transcribed
#> 4     tri   tricolor        3 transcribed
#> 5     tri   tricolor        3 transcribed
#> 6     tri   tricolor        3 transcribed
#> 7     tri   tricolor        3 transcribed
#> 8     tri   tricolor        3 transcribed
#> 9     tri   tricolor        3 transcribed
#> 10    tri   tricolor        3 transcribed
#> 11    tri   tricolor        3 transcribed
#> 12    tri   tricolor        3 transcribed
#> 13    tri   tricolor        3 transcribed
#> 14    tri   tricolor        3 transcribed
#> 15    tri   tricolor        3 transcribed
#> 16    tri   tricolor        3 transcribed
#> 17    tri   tricolor        3 transcribed
#> 18    tri   tricolor        3 transcribed
#> 19    tri   tricolor        3 transcribed
#> 20    tri   tricolor        3      review
#> 21   four four-color        4 transcribed
#> 22   four four-color        4 transcribed
#> 23  multi multicolor        5 transcribed
#> 24  multi multicolor        6      review
#> 25  multi multicolor        7 transcribed
#> 26  multi multicolor        5 transcribed
#> 27  multi multicolor        5 transcribed
#> 28  multi multicolor        5 transcribed
#> 29  multi multicolor        5 transcribed
#> 30  multi multicolor        5 transcribed
#>                                                                                                                                                                                                                                                 note
#> 1                                                                                                                                                                                                                                                   
#> 2                                                                                                                                                                                                                                                   
#> 3                                                                                                                                                                                                                                                   
#> 4                                                                                                                                                                                                                                                   
#> 5                                                                                                                                                                                                                                                   
#> 6                                                                                                                                                                                                                                                   
#> 7                                                                                                                                                                                                                                                   
#> 8                                                                                                                                                                                                                                                   
#> 9                                                                                                                                                                                                                                                   
#> 10                                                                                                                                                                                                                                                  
#> 11                                                                                                                                                                                                                                                  
#> 12                                                                                                                                                                                                                                                  
#> 13                                                                                                                                                                                                                                                  
#> 14                                                                                                                                                                                                                                                  
#> 15                                                                                                                                                                                                                                                  
#> 16                                                                                                                                                                                                                                                  
#> 17                                                                                                                                                                                                                                                  
#> 18                                                                                                                                                                                                                                                  
#> 19                                                                                                                                                                                                                                                  
#> 20                                                                   Swatch 2: The blue-channel final digit is blurred in the photograph. RGB (0, 99, 86) is the provisional reading; 86 versus 85 needs a closer source image. R and G are legible.
#> 21                                                                                                                                                                                                                                                  
#> 22                                                                                                                                                                                                                                                  
#> 23                                                                                                                                                                                                       Reference-sheet page number is not visible.
#> 24 Reference-sheet page number is not visible. Swatch 6: The faint yellow label appears to read RGB (240, 200, 43), but the last blue-channel digit is not reliably legible. This triplet is a provisional candidate, not a confirmed transcription.
#> 25                                                                                               Reference-sheet page number is not visible. One seven-color palette: six swatches on the first line, then the seventh at the left of the next line.
#> 26                                                                                                                                                                                                       Reference-sheet page number is not visible.
#> 27                                                                                                                                                                                                       Reference-sheet page number is not visible.
#> 28                                                                                                                                                                                                       Reference-sheet page number is not visible.
#> 29                                                                                                                                                                                                       Reference-sheet page number is not visible.
#> 30                                                                                                                                                                                                       Reference-sheet page number is not visible.

# three-colour palettes, any collection
palettes(type = "tricolor")
#>                   id                 name name_status collection
#> 1       retro_tri_01         Meadow & sky   editorial      retro
#> 2       retro_tri_02               Harbor   editorial      retro
#> 3       retro_tri_03             Poolside   editorial      retro
#> 4       retro_tri_04          Orange soda   editorial      retro
#> 5       retro_tri_05 Plum, blue & crimson   editorial      retro
#> 6       retro_tri_06        Peach orchard   editorial      retro
#> 7       retro_tri_07       Crimson garden   editorial      retro
#> 8       retro_tri_08              Harvest   editorial      retro
#> 9       retro_tri_09         Steel & rust   editorial      retro
#> 10      retro_tri_10     Evergreen studio   editorial      retro
#> 11      retro_tri_11  Blue, walnut & lime   editorial      retro
#> 12      retro_tri_12         Garden party   editorial      retro
#> 13      retro_tri_13               Velvet   editorial      retro
#> 14      retro_tri_14          Coffeehouse   editorial      retro
#> 15      retro_tri_15          Sunny field   editorial      retro
#> 16      retro_tri_16      Sky, leaf & red   editorial      retro
#> 17      retro_tri_17          Quiet olive   editorial      retro
#> 18      retro_tri_18       Forest & brass   editorial      retro
#> 19      retro_tri_19        Primary print   editorial      retro
#> 20      retro_tri_20            Blue hour   editorial      retro
#> 21      retro_tri_21             Woodland   editorial      retro
#> 22 minimalism_tri_01    minimalism_tri_01     pending minimalism
#> 23 minimalism_tri_02    minimalism_tri_02     pending minimalism
#> 24     kawaii_tri_01        kawaii_tri_01     pending     kawaii
#> 25     kawaii_tri_02        kawaii_tri_02     pending     kawaii
#> 26     kawaii_tri_03        kawaii_tri_03     pending     kawaii
#> 27     kawaii_tri_04        kawaii_tri_04     pending     kawaii
#> 28     kawaii_tri_05        kawaii_tri_05     pending     kawaii
#> 29     kawaii_tri_06        kawaii_tri_06     pending     kawaii
#> 30     kawaii_tri_07        kawaii_tri_07     pending     kawaii
#> 31     kawaii_tri_08        kawaii_tri_08     pending     kawaii
#> 32     kawaii_tri_09        kawaii_tri_09     pending     kawaii
#> 33     kawaii_tri_10        kawaii_tri_10     pending     kawaii
#> 34     kawaii_tri_11        kawaii_tri_11     pending     kawaii
#> 35     kawaii_tri_12        kawaii_tri_12     pending     kawaii
#> 36     kawaii_tri_13        kawaii_tri_13     pending     kawaii
#> 37     kawaii_tri_14        kawaii_tri_14     pending     kawaii
#> 38     kawaii_tri_15        kawaii_tri_15     pending     kawaii
#> 39     kawaii_tri_16        kawaii_tri_16     pending     kawaii
#> 40     kawaii_tri_17        kawaii_tri_17     pending     kawaii
#> 41     kawaii_tri_18        kawaii_tri_18     pending     kawaii
#> 42     kawaii_tri_19        kawaii_tri_19     pending     kawaii
#> 43 avantgarde_tri_01    avantgarde_tri_01     pending avantgarde
#> 44 avantgarde_tri_02    avantgarde_tri_02     pending avantgarde
#> 45 avantgarde_tri_03    avantgarde_tri_03     pending avantgarde
#> 46 avantgarde_tri_04    avantgarde_tri_04     pending avantgarde
#> 47 avantgarde_tri_05    avantgarde_tri_05     pending avantgarde
#> 48 avantgarde_tri_06    avantgarde_tri_06     pending avantgarde
#> 49 avantgarde_tri_07    avantgarde_tri_07     pending avantgarde
#> 50 avantgarde_tri_08    avantgarde_tri_08     pending avantgarde
#> 51 avantgarde_tri_09    avantgarde_tri_09     pending avantgarde
#> 52 avantgarde_tri_10    avantgarde_tri_10     pending avantgarde
#> 53 avantgarde_tri_11    avantgarde_tri_11     pending avantgarde
#>    collection_label family     type n_colors      status
#> 1             Retro    tri tricolor        3 transcribed
#> 2             Retro    tri tricolor        3 transcribed
#> 3             Retro    tri tricolor        3 transcribed
#> 4             Retro    tri tricolor        3      review
#> 5             Retro    tri tricolor        3      review
#> 6             Retro    tri tricolor        3      review
#> 7             Retro    tri tricolor        3 transcribed
#> 8             Retro    tri tricolor        3 transcribed
#> 9             Retro    tri tricolor        3 transcribed
#> 10            Retro    tri tricolor        3 transcribed
#> 11            Retro    tri tricolor        3 transcribed
#> 12            Retro    tri tricolor        3 transcribed
#> 13            Retro    tri tricolor        3 transcribed
#> 14            Retro    tri tricolor        3 transcribed
#> 15            Retro    tri tricolor        3 transcribed
#> 16            Retro    tri tricolor        3 transcribed
#> 17            Retro    tri tricolor        3 transcribed
#> 18            Retro    tri tricolor        3 transcribed
#> 19            Retro    tri tricolor        3 transcribed
#> 20            Retro    tri tricolor        3 transcribed
#> 21            Retro    tri tricolor        3 transcribed
#> 22       Minimalism    tri tricolor        3 transcribed
#> 23       Minimalism    tri tricolor        3 transcribed
#> 24           Kawaii    tri tricolor        3 transcribed
#> 25           Kawaii    tri tricolor        3 transcribed
#> 26           Kawaii    tri tricolor        3 transcribed
#> 27           Kawaii    tri tricolor        3 transcribed
#> 28           Kawaii    tri tricolor        3 transcribed
#> 29           Kawaii    tri tricolor        3 transcribed
#> 30           Kawaii    tri tricolor        3 transcribed
#> 31           Kawaii    tri tricolor        3 transcribed
#> 32           Kawaii    tri tricolor        3 transcribed
#> 33           Kawaii    tri tricolor        3 transcribed
#> 34           Kawaii    tri tricolor        3 transcribed
#> 35           Kawaii    tri tricolor        3 transcribed
#> 36           Kawaii    tri tricolor        3 transcribed
#> 37           Kawaii    tri tricolor        3 transcribed
#> 38           Kawaii    tri tricolor        3 transcribed
#> 39           Kawaii    tri tricolor        3 transcribed
#> 40           Kawaii    tri tricolor        3 transcribed
#> 41           Kawaii    tri tricolor        3 transcribed
#> 42           Kawaii    tri tricolor        3      review
#> 43      Avant Garde    tri tricolor        3 transcribed
#> 44      Avant Garde    tri tricolor        3 transcribed
#> 45      Avant Garde    tri tricolor        3 transcribed
#> 46      Avant Garde    tri tricolor        3 transcribed
#> 47      Avant Garde    tri tricolor        3 transcribed
#> 48      Avant Garde    tri tricolor        3 transcribed
#> 49      Avant Garde    tri tricolor        3 transcribed
#> 50      Avant Garde    tri tricolor        3 transcribed
#> 51      Avant Garde    tri tricolor        3 transcribed
#> 52      Avant Garde    tri tricolor        3 transcribed
#> 53      Avant Garde    tri tricolor        3 transcribed
#>                                                                                                                                                                               note
#> 1                                                                                                                                                                                 
#> 2                                                                                                                                                                                 
#> 3                                                                                                                                                                                 
#> 4                            Swatch 2: Provisional blue channel; the printed number may end in 5 or 6. Swatch 3: Provisional RGB reading; confirm the blurred golden swatch label.
#> 5                                                                                          Swatch 3: Provisional RGB reading; confirm the small red label at the curved page edge.
#> 6                                                                                             Swatch 3: Provisional RGB reading; confirm the blurred green label at the page edge.
#> 7                                                                                                                                                                                 
#> 8                                                                                                                                                                                 
#> 9                                                                                                                                                                                 
#> 10                                                                                                                                                                                
#> 11                                                                                                                                                                                
#> 12                                                                                                                                                                                
#> 13                                                                                                                                                                                
#> 14                                                                                                                                                                                
#> 15                                                                                                                                                                                
#> 16                                                                                                                                                                                
#> 17                                                                                                                                                                                
#> 18                                                                                                                                                                                
#> 19                                                                                                                                                                                
#> 20                                                                                                                                                                                
#> 21                                                                                                                                                                                
#> 22                                                                                                                                                                                
#> 23                                                                                                                                                                                
#> 24                                                                                                                                                                                
#> 25                                                                                                                                                                                
#> 26                                                                                                                                                                                
#> 27                                                                                                                                                                                
#> 28                                                                                                                                                                                
#> 29                                                                                                                                                                                
#> 30                                                                                                                                                                                
#> 31                                                                                                                                                                                
#> 32                                                                                                                                                                                
#> 33                                                                                                                                                                                
#> 34                                                                                                                                                                                
#> 35                                                                                                                                                                                
#> 36                                                                                                                                                                                
#> 37                                                                                                                                                                                
#> 38                                                                                                                                                                                
#> 39                                                                                                                                                                                
#> 40                                                                                                                                                                                
#> 41                                                                                                                                                                                
#> 42 Swatch 2: The blue-channel final digit is blurred in the photograph. RGB (0, 99, 86) is the provisional reading; 86 versus 85 needs a closer source image. R and G are legible.
#> 43                                                                                                                                                                                
#> 44                                                                                                                                                                                
#> 45                                                                                                                                                                                
#> 46                                                                                                                                                                                
#> 47                                                                                                                                                                                
#> 48                                                                                                                                                                                
#> 49                                                                                                                                                                                
#> 50                                                                                                                                                                                
#> 51                                                                                                                                                                                
#> 52                                                                                                                                                                                
#> 53                                                                                                                                                                                

# only fully transcribed palettes
nrow(palettes(include_review = FALSE))
#> [1] 136
```
