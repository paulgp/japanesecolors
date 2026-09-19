# The palette catalogue

Returns the palette catalogue as a data frame, optionally filtered. This
is the main way to browse what is in the package.

## Usage

``` r
palettes(
  collection = NULL,
  type = NULL,
  n = NULL,
  include_review = TRUE,
  dataviz_friendly = NULL
)
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

- dataviz_friendly:

  Optionally keep only palettes that screen well for data visualisation
  (`TRUE`), or only those that do not (`FALSE`). `NULL`, the default,
  keeps both. See the Data visualisation section.

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

- dataviz_friendly:

  Whether the palette screens well for categorical data visualisation.
  See the Data visualisation section.

- min_delta_e, min_delta_e_cvd, min_delta_e_white:

  The measurements behind that flag.

- note:

  Free text, including why any swatch is provisional.

## Data visualisation

These are design palettes, chosen to look good together rather than to
encode categories, so many are unsuitable for charts. `dataviz_friendly`
screens for the two things that decide it:

- **Colour-vision deficiency.** Colours that separate for a trichromat
  can collapse for a dichromat, so each palette is re-measured under
  simulated deuteranopia, protanopia and tritanopia.

- **Perceptual separation.** Categories have to read as different at a
  glance, in small marks.

Both use CIEDE2000 on a palette's closest pair, since a palette is only
as readable as the two colours most easily confused. A third check stops
a near-white colour from vanishing against the page. `min_delta_e`,
`min_delta_e_cvd` and `min_delta_e_white` report the measurements, so
you can apply a stricter or looser bar than the shipped thresholds.

Thresholds are calibrated so that the Okabe-Ito palette, designed for
colour-vision deficiency, passes. Treat the flag as a screening aid: it
judges separability only, and cannot know whether a palette suits your
chart, audience or medium.

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
#>      type n_colors      status dataviz_friendly min_delta_e min_delta_e_cvd
#> 1 bicolor        2 transcribed             TRUE        42.0            24.9
#> 2 bicolor        2 transcribed             TRUE        48.3            23.6
#> 3 bicolor        2 transcribed             TRUE        47.6            15.6
#> 4 bicolor        2 transcribed             TRUE        69.9            67.6
#> 5 bicolor        2 transcribed             TRUE        17.5            16.6
#> 6 bicolor        2 transcribed            FALSE        38.4             7.5
#>   min_delta_e_white note
#> 1              29.7     
#> 2              35.2     
#> 3              41.3     
#> 4              25.2     
#> 5              49.5     
#> 6              42.0     

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
#>    family       type n_colors      status dataviz_friendly min_delta_e
#> 1      bi    bicolor        2 transcribed             TRUE        72.6
#> 2     tri   tricolor        3 transcribed            FALSE        32.2
#> 3     tri   tricolor        3 transcribed            FALSE        19.3
#> 4     tri   tricolor        3 transcribed            FALSE        14.7
#> 5     tri   tricolor        3 transcribed            FALSE        25.1
#> 6     tri   tricolor        3 transcribed             TRUE        36.9
#> 7     tri   tricolor        3 transcribed             TRUE        41.4
#> 8     tri   tricolor        3 transcribed             TRUE        27.9
#> 9     tri   tricolor        3 transcribed            FALSE        16.2
#> 10    tri   tricolor        3 transcribed             TRUE        33.6
#> 11    tri   tricolor        3 transcribed            FALSE        17.5
#> 12    tri   tricolor        3 transcribed            FALSE        23.7
#> 13    tri   tricolor        3 transcribed            FALSE        35.9
#> 14    tri   tricolor        3 transcribed             TRUE        32.6
#> 15    tri   tricolor        3 transcribed             TRUE        41.5
#> 16    tri   tricolor        3 transcribed             TRUE        33.5
#> 17    tri   tricolor        3 transcribed            FALSE        27.8
#> 18    tri   tricolor        3 transcribed            FALSE        35.1
#> 19    tri   tricolor        3 transcribed            FALSE        16.1
#> 20    tri   tricolor        3      review             TRUE        47.6
#> 21   four four-color        4 transcribed             TRUE        30.8
#> 22   four four-color        4 transcribed            FALSE        32.6
#> 23  multi multicolor        5 transcribed            FALSE        32.2
#> 24  multi multicolor        6      review            FALSE         9.9
#> 25  multi multicolor        7 transcribed            FALSE         8.0
#> 26  multi multicolor        5 transcribed            FALSE        13.8
#> 27  multi multicolor        5 transcribed            FALSE        14.8
#> 28  multi multicolor        5 transcribed            FALSE        10.5
#> 29  multi multicolor        5 transcribed            FALSE        22.7
#> 30  multi multicolor        5 transcribed            FALSE        16.6
#>    min_delta_e_cvd min_delta_e_white
#> 1             42.8              28.0
#> 2              8.2              19.6
#> 3              7.2              29.6
#> 4              8.3              11.3
#> 5              7.0              19.7
#> 6             20.6              28.3
#> 7             10.7              29.9
#> 8             13.7              32.6
#> 9              6.3              13.4
#> 10            10.5              13.4
#> 11             5.3              12.9
#> 12            11.0              11.0
#> 13            11.4              10.7
#> 14            14.5              28.1
#> 15            15.7              27.4
#> 16            17.3              19.7
#> 17            22.8               7.6
#> 18            30.6               7.4
#> 19             7.4              19.8
#> 20            14.1              27.9
#> 21            10.3              20.3
#> 22             2.0              26.5
#> 23             6.9              19.6
#> 24             5.9              26.2
#> 25             6.5              24.8
#> 26             5.6              22.3
#> 27             8.8              30.2
#> 28            10.4              12.4
#> 29             6.0              28.6
#> 30             5.6              29.7
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
#>    collection_label family     type n_colors      status dataviz_friendly
#> 1             Retro    tri tricolor        3 transcribed             TRUE
#> 2             Retro    tri tricolor        3 transcribed             TRUE
#> 3             Retro    tri tricolor        3 transcribed             TRUE
#> 4             Retro    tri tricolor        3      review             TRUE
#> 5             Retro    tri tricolor        3      review            FALSE
#> 6             Retro    tri tricolor        3      review             TRUE
#> 7             Retro    tri tricolor        3 transcribed             TRUE
#> 8             Retro    tri tricolor        3 transcribed            FALSE
#> 9             Retro    tri tricolor        3 transcribed            FALSE
#> 10            Retro    tri tricolor        3 transcribed             TRUE
#> 11            Retro    tri tricolor        3 transcribed             TRUE
#> 12            Retro    tri tricolor        3 transcribed            FALSE
#> 13            Retro    tri tricolor        3 transcribed             TRUE
#> 14            Retro    tri tricolor        3 transcribed            FALSE
#> 15            Retro    tri tricolor        3 transcribed             TRUE
#> 16            Retro    tri tricolor        3 transcribed             TRUE
#> 17            Retro    tri tricolor        3 transcribed            FALSE
#> 18            Retro    tri tricolor        3 transcribed             TRUE
#> 19            Retro    tri tricolor        3 transcribed             TRUE
#> 20            Retro    tri tricolor        3 transcribed            FALSE
#> 21            Retro    tri tricolor        3 transcribed             TRUE
#> 22       Minimalism    tri tricolor        3 transcribed            FALSE
#> 23       Minimalism    tri tricolor        3 transcribed             TRUE
#> 24           Kawaii    tri tricolor        3 transcribed            FALSE
#> 25           Kawaii    tri tricolor        3 transcribed            FALSE
#> 26           Kawaii    tri tricolor        3 transcribed            FALSE
#> 27           Kawaii    tri tricolor        3 transcribed            FALSE
#> 28           Kawaii    tri tricolor        3 transcribed             TRUE
#> 29           Kawaii    tri tricolor        3 transcribed             TRUE
#> 30           Kawaii    tri tricolor        3 transcribed             TRUE
#> 31           Kawaii    tri tricolor        3 transcribed            FALSE
#> 32           Kawaii    tri tricolor        3 transcribed             TRUE
#> 33           Kawaii    tri tricolor        3 transcribed            FALSE
#> 34           Kawaii    tri tricolor        3 transcribed            FALSE
#> 35           Kawaii    tri tricolor        3 transcribed            FALSE
#> 36           Kawaii    tri tricolor        3 transcribed             TRUE
#> 37           Kawaii    tri tricolor        3 transcribed             TRUE
#> 38           Kawaii    tri tricolor        3 transcribed             TRUE
#> 39           Kawaii    tri tricolor        3 transcribed            FALSE
#> 40           Kawaii    tri tricolor        3 transcribed            FALSE
#> 41           Kawaii    tri tricolor        3 transcribed            FALSE
#> 42           Kawaii    tri tricolor        3      review             TRUE
#> 43      Avant Garde    tri tricolor        3 transcribed             TRUE
#> 44      Avant Garde    tri tricolor        3 transcribed             TRUE
#> 45      Avant Garde    tri tricolor        3 transcribed             TRUE
#> 46      Avant Garde    tri tricolor        3 transcribed             TRUE
#> 47      Avant Garde    tri tricolor        3 transcribed            FALSE
#> 48      Avant Garde    tri tricolor        3 transcribed             TRUE
#> 49      Avant Garde    tri tricolor        3 transcribed            FALSE
#> 50      Avant Garde    tri tricolor        3 transcribed            FALSE
#> 51      Avant Garde    tri tricolor        3 transcribed            FALSE
#> 52      Avant Garde    tri tricolor        3 transcribed             TRUE
#> 53      Avant Garde    tri tricolor        3 transcribed            FALSE
#>    min_delta_e min_delta_e_cvd min_delta_e_white
#> 1         31.0            13.6              20.6
#> 2         37.1            32.9              24.5
#> 3         33.3            15.6              20.7
#> 4         27.0            12.2              25.9
#> 5         30.4             5.4              41.9
#> 6         31.6            16.1              25.5
#> 7         45.3            22.1              24.7
#> 8         13.0            10.5              29.2
#> 9         25.6            24.2               5.2
#> 10        21.2            14.0              19.9
#> 11        37.0            37.1              29.7
#> 12        19.1             4.6              28.7
#> 13        31.1            15.1              33.3
#> 14        17.6             8.1              19.6
#> 15        20.4            11.7              24.7
#> 16        30.1            11.8              14.7
#> 17         9.5             8.5               6.2
#> 18        29.1            27.0              14.2
#> 19        48.0            23.5              31.1
#> 20        10.9             5.1              32.3
#> 21        19.7            14.9              20.6
#> 22        14.5             6.6              25.2
#> 23        25.4            15.9              12.6
#> 24        32.2             8.2              19.6
#> 25        19.3             7.2              29.6
#> 26        14.7             8.3              11.3
#> 27        25.1             7.0              19.7
#> 28        36.9            20.6              28.3
#> 29        41.4            10.7              29.9
#> 30        27.9            13.7              32.6
#> 31        16.2             6.3              13.4
#> 32        33.6            10.5              13.4
#> 33        17.5             5.3              12.9
#> 34        23.7            11.0              11.0
#> 35        35.9            11.4              10.7
#> 36        32.6            14.5              28.1
#> 37        41.5            15.7              27.4
#> 38        33.5            17.3              19.7
#> 39        27.8            22.8               7.6
#> 40        35.1            30.6               7.4
#> 41        16.1             7.4              19.8
#> 42        47.6            14.1              27.9
#> 43        45.8            33.5              12.8
#> 44        37.6            29.8              18.2
#> 45        21.2            11.6              20.7
#> 46        37.4            15.4              30.3
#> 47        25.6             6.8               9.3
#> 48        55.9            22.4              30.3
#> 49        31.2            13.1               8.5
#> 50        20.7             9.9              33.1
#> 51        25.4             6.4              32.6
#> 52        57.4            37.3              30.3
#> 53        30.7            24.4              11.2
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

# palettes that screen well for charts
head(palettes(dataviz_friendly = TRUE)[, c("id", "n_colors", "min_delta_e_cvd")])
#>            id n_colors min_delta_e_cvd
#> 1 retro_bi_01        2            24.9
#> 2 retro_bi_02        2            23.6
#> 3 retro_bi_03        2            15.6
#> 4 retro_bi_04        2            67.6
#> 5 retro_bi_05        2            16.6
#> 6 retro_bi_07        2            24.3
```
