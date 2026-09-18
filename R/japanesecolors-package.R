#' @keywords internal
"_PACKAGE"

#' @details
#' Every palette is an exported character vector of hex colours, so the primary
#' interface is the palette's name:
#'
#' ```r
#' kawaii_tri_07
#' #> [1] "#3D7EB4" "#DF4472" "#E68C5F"
#' ```
#'
#' IDs have the form `<collection>_<type>_<nn>`, where `<type>` is `bi`
#' (bicolor), `tri` (tricolor), `four` (four-color) or `multi` (multicolor).
#' They are stable API.
#'
#' Browse with [palettes()], [palette_names()] and [collections()]; look up with
#' [get_palette()] and [palette_info()]; draw with [show_palette()]. For ggplot2,
#' see [scale_colour_japanesecolors()]. ggplot2 is suggested, not required.
#'
#' Values were transcribed by hand from printed RGB labels. Readings that were
#' not reliably legible are marked `"review"` rather than treated as confirmed;
#' [palettes_needing_review()] lists them.
#'
#' @section Source and attribution:
#' Colour values were manually transcribed from *Japanese Color Matching*,
#' edited and published by SendPoints (Sendpoints Publishing Company Limited),
#' 2022, ISBN 978-988-760-879-0.
#'
#' `japanesecolors` is an independent, unaffiliated project. It is not
#' associated with, licensed by, endorsed by or approved by SendPoints. It
#' distributes this project's transcription of RGB/hex colour values and its
#' own metadata -- not the book's text, layouts, photographs, advertisements or
#' other artwork -- and is no substitute for the book.
#' @name japanesecolors-package
NULL
