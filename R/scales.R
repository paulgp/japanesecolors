# ggplot2 scales ---------------------------------------------------------------

.require_ggplot2 <- function() {
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("ggplot2 is needed for japanesecolors scales. Install it with ",
         "install.packages(\"ggplot2\").", call. = FALSE)
  }
}

#' A palette function
#'
#' Returns a function of `n` that gives the first `n` colours of a palette.
#' This is the form ggplot2's [ggplot2::discrete_scale()] and a number of other
#' packages expect, and is what the `japanesecolors` scales use internally.
#'
#' The palettes are curated categorical sets, so the returned function never
#' interpolates or recycles: asking for more colours than the palette holds is
#' an error rather than a silently repeated or blended colour.
#'
#' @param palette A palette ID, such as `"kawaii_tri_07"`.
#' @param reverse Whether to reverse the colour order.
#'
#' @return A function taking a single argument `n`, returning `n` hex colours.
#' @seealso [scale_colour_japanesecolors()], [get_palette()]
#' @examples
#' pal <- japanesecolors_pal("retro_four_03")
#' pal(2)
#' pal(4)
#' @export
japanesecolors_pal <- function(palette, reverse = FALSE) {
  colours <- get_palette(palette, reverse = reverse)
  force(palette)
  function(n) {
    if (!is.numeric(n) || length(n) != 1L || is.na(n) || n < 0) {
      stop("`n` must be a single non-negative number.", call. = FALSE)
    }
    if (n > length(colours)) {
      stop(sprintf(paste0("Palette \"%s\" has %d colours, but %d are needed. ",
                          "Choose a larger palette -- japanesecolors palettes are curated ",
                          "categorical sets and are not interpolated or recycled. ",
                          "See palettes(n = %d) for palettes that are big enough."),
                   palette, length(colours), as.integer(n), as.integer(n)),
           call. = FALSE)
    }
    colours[seq_len(n)]
  }
}

#' Discrete colour and fill scales
#'
#' Discrete ggplot2 scales using a `japanesecolors` palette.
#' `scale_color_japanesecolors()` is an alias for `scale_colour_japanesecolors()`.
#'
#' Palettes are curated categorical sets and are used in their printed order.
#' If the data have more levels than the palette has colours, ggplot2 raises an
#' error rather than recycling or interpolating; use [palettes()] with the `n`
#' argument to find a palette large enough.
#'
#' @param palette A palette ID, such as `"kawaii_tri_07"`. See
#'   [palette_names()].
#' @param ... Passed on to [ggplot2::scale_colour_manual()] or
#'   [ggplot2::scale_fill_manual()], for example `name`, `labels` or `guide`.
#' @param reverse Whether to reverse the colour order.
#' @param na.value Colour used for missing values.
#'
#' @return A ggplot2 scale, to add to a plot.
#' @seealso [japanesecolors_pal()], [palettes()]
#' @examples
#' \donttest{
#' if (requireNamespace("ggplot2", quietly = TRUE)) {
#'   library(ggplot2)
#'
#'   ggplot(iris, aes(Sepal.Length, Sepal.Width, colour = Species)) +
#'     geom_point(size = 2) +
#'     scale_colour_japanesecolors("kawaii_tri_07")
#'
#'   ggplot(mpg, aes(class, fill = drv)) +
#'     geom_bar() +
#'     scale_fill_japanesecolors("avantgarde_four_04")
#' }
#' }
#' @name scale_japanesecolors
#' @export
scale_colour_japanesecolors <- function(palette, ..., reverse = FALSE,
                                        na.value = "grey50") {
  .require_ggplot2()
  ggplot2::scale_colour_manual(
    values = get_palette(palette, reverse = reverse),
    na.value = na.value,
    ...
  )
}

#' @rdname scale_japanesecolors
#' @export
scale_color_japanesecolors <- scale_colour_japanesecolors

#' @rdname scale_japanesecolors
#' @export
scale_fill_japanesecolors <- function(palette, ..., reverse = FALSE,
                                      na.value = "grey50") {
  .require_ggplot2()
  ggplot2::scale_fill_manual(
    values = get_palette(palette, reverse = reverse),
    na.value = na.value,
    ...
  )
}
