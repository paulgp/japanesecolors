# Visual display ---------------------------------------------------------------

# Accept either a palette object (character vector of hex) or an ID string,
# so show_palette(kawaii_tri_07) and show_palette("kawaii_tri_07") both work.
.as_colours <- function(x, arg = "x") {
  if (is.character(x) && length(x) == 1L && !is.na(x) &&
        x %in% names(.japanesecolors_palettes)) {
    return(list(colours = .japanesecolors_palettes[[x]], id = x))
  }
  if (!is.character(x) || !length(x) || anyNA(x)) {
    stop(sprintf("`%s` must be a palette ID or a character vector of colours.", arg),
         call. = FALSE)
  }
  bad <- !grepl("^#[0-9A-Fa-f]{6}([0-9A-Fa-f]{2})?$", x) & !(x %in% grDevices::colors())
  if (any(bad)) {
    stop(sprintf("`%s` contains values that are not colours: %s.",
                 arg, paste(dQuote(utils::head(x[bad], 3), FALSE), collapse = ", ")),
         call. = FALSE)
  }
  id <- .match_known_palette(x)
  list(colours = x, id = id)
}

# If the vector happens to be a known palette, we can label the plot with it.
.match_known_palette <- function(x) {
  hit <- vapply(.japanesecolors_palettes, function(p) identical(unname(p), unname(toupper(x))),
                logical(1))
  if (any(hit)) names(.japanesecolors_palettes)[which(hit)[1]] else NA_character_
}

# Pick black or white text for legibility on a given background colour,
# using the WCAG relative-luminance formula.
.contrast_text <- function(hex) {
  rgb <- grDevices::col2rgb(hex) / 255
  lin <- ifelse(rgb <= 0.03928, rgb / 12.92, ((rgb + 0.055) / 1.055)^2.4)
  lum <- 0.2126 * lin[1, ] + 0.7152 * lin[2, ] + 0.0722 * lin[3, ]
  ifelse(lum > 0.45, "#000000", "#FFFFFF")
}

#' Draw a palette's swatches
#'
#' Plots a palette as a row of colour swatches, optionally labelled with the
#' hex values. Uses base graphics, so it has no dependencies beyond R itself.
#'
#' @param x A palette object (a character vector of colours, such as
#'   `kawaii_tri_07`), or a palette ID string (`"kawaii_tri_07"`).
#' @param labels Whether to print the hex value on each swatch.
#' @param title A title for the plot. By default the palette ID is used when
#'   `x` is a recognised palette, and no title otherwise. Use `NULL` for none.
#' @param border Colour of the swatch borders, or `NA` for none.
#'
#' @return `x`, invisibly. Called for its plot.
#' @seealso [palettes()], [get_palette()]
#' @examples
#' show_palette(kawaii_tri_07)
#' show_palette("retro_multi_01")
#' show_palette(avantgarde_four_04, labels = FALSE)
#' @export
show_palette <- function(x, labels = TRUE, title = NULL, border = "#FFFFFF") {
  parsed <- .as_colours(x)
  colours <- parsed$colours
  .check_flag(labels, "labels")

  if (missing(title)) title <- NULL
  if (is.null(title) && !is.na(parsed$id)) {
    info <- .japanesecolors_catalogue[.japanesecolors_catalogue$id == parsed$id, ]
    title <- parsed$id
    # plain ASCII: some graphics devices cannot encode typographic dashes
    if (!identical(info$name, info$id)) title <- sprintf("%s - %s", parsed$id, info$name)
    if (identical(info$status, "review")) title <- paste0(title, " (provisional reading)")
  }

  n <- length(colours)
  op <- graphics::par(mar = c(0.2, 0.2, if (is.null(title)) 0.2 else 1.6, 0.2))
  on.exit(graphics::par(op), add = TRUE)

  graphics::plot(NA, xlim = c(0, n), ylim = c(0, 1), type = "n",
                 axes = FALSE, xlab = "", ylab = "", xaxs = "i", yaxs = "i")
  graphics::rect(seq_len(n) - 1, 0, seq_len(n), 1, col = colours, border = border,
                 lwd = if (is.na(border)) 0 else 2)
  if (labels) {
    graphics::text(seq_len(n) - 0.5, 0.5, labels = colours, srt = 90,
                   col = .contrast_text(colours), cex = min(1, 8 / n), font = 2)
  }
  if (!is.null(title)) graphics::title(main = title, cex.main = 1, font.main = 1, line = 0.4)
  invisible(x)
}
