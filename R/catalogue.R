# Discovery and lookup ---------------------------------------------------------

COLLECTION_IDS <- c("retro", "minimalism", "kawaii", "avantgarde")

# printed matching type -> the short code used in palette IDs
.family_from_type <- c(
  bicolor      = "bi",
  tricolor     = "tri",
  `four-color` = "four",
  multicolor   = "multi"
)
FAMILY_IDS <- unname(.family_from_type)
TYPE_IDS <- names(.family_from_type)

.check_collection <- function(collection) {
  if (is.null(collection)) return(NULL)
  if (!is.character(collection) || !length(collection) || anyNA(collection)) {
    stop("`collection` must be a character vector of collection names.", call. = FALSE)
  }
  collection <- tolower(collection)
  bad <- setdiff(collection, COLLECTION_IDS)
  if (length(bad)) {
    stop(sprintf("Unknown collection%s: %s. Available: %s.",
                 if (length(bad) > 1L) "s" else "",
                 paste(sQuote(bad), collapse = ", "),
                 paste(COLLECTION_IDS, collapse = ", ")),
         call. = FALSE)
  }
  collection
}

# Accepts either the short family code ("tri") or the printed type name
# ("tricolor"), since both appear in the catalogue.
.check_type <- function(type) {
  if (is.null(type)) return(NULL)
  if (!is.character(type) || !length(type) || anyNA(type)) {
    stop("`type` must be a character vector of matching types.", call. = FALSE)
  }
  type <- tolower(type)
  out <- ifelse(type %in% FAMILY_IDS, type, .family_from_type[type])
  if (anyNA(out)) {
    stop(sprintf("Unknown matching type%s: %s. Available: %s (or %s).",
                 if (sum(is.na(out)) > 1L) "s" else "",
                 paste(sQuote(type[is.na(out)]), collapse = ", "),
                 paste(TYPE_IDS, collapse = ", "),
                 paste(FAMILY_IDS, collapse = ", ")),
         call. = FALSE)
  }
  unname(out)
}

.check_n <- function(n) {
  if (is.null(n)) return(NULL)
  if (!is.numeric(n) || !length(n) || anyNA(n) || any(!is.finite(n)) ||
        any(n != floor(n)) || any(n < 1)) {
    stop("`n` must be one or more positive whole numbers.", call. = FALSE)
  }
  as.integer(n)
}

.check_flag <- function(x, arg) {
  if (!is.logical(x) || length(x) != 1L || is.na(x)) {
    stop(sprintf("`%s` must be TRUE or FALSE.", arg), call. = FALSE)
  }
  x
}

.filter_catalogue <- function(collection, type, n, include_review) {
  collection <- .check_collection(collection)
  type <- .check_type(type)
  n <- .check_n(n)
  .check_flag(include_review, "include_review")

  cat_df <- .japanesecolors_catalogue
  keep <- rep(TRUE, nrow(cat_df))
  if (!is.null(collection)) keep <- keep & cat_df$collection %in% collection
  if (!is.null(type))       keep <- keep & cat_df$family %in% type
  if (!is.null(n))          keep <- keep & cat_df$n_colors %in% n
  if (!include_review)      keep <- keep & cat_df$status == "transcribed"

  out <- cat_df[keep, , drop = FALSE]
  rownames(out) <- NULL
  out
}

#' The palette catalogue
#'
#' Returns the palette catalogue as a data frame, optionally filtered. This is
#' the main way to browse what is in the package.
#'
#' @param collection Optional collection name(s) to keep: `"retro"`,
#'   `"minimalism"`, `"kawaii"` and/or `"avantgarde"`. `NULL` (default) keeps
#'   all four.
#' @param type Optional matching type(s) to keep. Accepts either the printed
#'   names (`"bicolor"`, `"tricolor"`, `"four-color"`, `"multicolor"`) or the
#'   short codes used in palette IDs (`"bi"`, `"tri"`, `"four"`, `"multi"`).
#' @param n Optional palette size(s) to keep, as a number of colours.
#' @param include_review Whether to include palettes that contain a provisional
#'   swatch reading. `TRUE` by default, so nothing is hidden; the `status`
#'   column marks them and [palettes_needing_review()] lists them.
#'
#' @return A data frame with one row per palette and the columns:
#'   \describe{
#'     \item{id}{Stable palette ID, and the name of the exported object.}
#'     \item{name}{Display name, or the ID where no name has been assigned.}
#'     \item{name_status}{`"editorial"` for names written by this project,
#'       `"pending"` where none has been assigned.}
#'     \item{collection, collection_label}{Collection ID and display label.}
#'     \item{family, type}{Matching type, as a short code and printed name.}
#'     \item{n_colors}{Number of colours.}
#'     \item{status}{`"transcribed"` or `"review"`.}
#'     \item{note}{Free text, including why any swatch is provisional.}
#'   }
#'
#' @seealso [palette_names()] for just the IDs, [get_palette()] to fetch
#'   colours, [show_palette()] to draw them.
#' @examples
#' head(palettes())
#'
#' # everything in one collection
#' palettes("kawaii")
#'
#' # three-colour palettes, any collection
#' palettes(type = "tricolor")
#'
#' # only fully transcribed palettes
#' nrow(palettes(include_review = FALSE))
#' @export
palettes <- function(collection = NULL, type = NULL, n = NULL,
                     include_review = TRUE) {
  .filter_catalogue(collection, type, n, include_review)
}

#' Palette names
#'
#' The stable IDs of the palettes matching a filter. Each ID is also the name
#' of an exported object, so `get_palette(palette_names("kawaii")[1])` and
#' `kawaii_bi_01` give the same colours.
#'
#' @inheritParams palettes
#' @return A character vector of palette IDs.
#' @seealso [palettes()] for the full catalogue.
#' @examples
#' palette_names("avantgarde")
#' palette_names("minimalism", type = "bicolor")
#' length(palette_names())
#' @export
palette_names <- function(collection = NULL, type = NULL, n = NULL,
                          include_review = TRUE) {
  .filter_catalogue(collection, type, n, include_review)$id
}

#' The palette collections
#'
#' @return A data frame with one row per collection, giving its ID, display
#'   label, number of palettes, number of palettes containing a provisional
#'   reading, and a short provenance note.
#' @seealso [palettes()]
#' @examples
#' collections()
#' @export
collections <- function() {
  out <- .japanesecolors_collections
  rownames(out) <- NULL
  out
}

#' Get a palette's colours by ID
#'
#' Looks a palette up by its ID string. Useful when the palette is chosen
#' programmatically; when you know the palette at the time of writing, just
#' use the exported object (`kawaii_tri_07`) directly.
#'
#' @param palette A single palette ID, such as `"kawaii_tri_07"`.
#' @param n Optional number of colours to return, taken from the start of the
#'   palette. Colours are never recycled or interpolated, so `n` may not
#'   exceed the palette's length.
#' @param reverse Whether to reverse the colour order.
#'
#' @return An unnamed character vector of hex colours.
#' @seealso [palettes()], [palette_info()], [show_palette()]
#' @examples
#' get_palette("kawaii_tri_07")
#' get_palette("retro_multi_01", n = 3)
#' get_palette("minimalism_bi_01", reverse = TRUE)
#' @export
get_palette <- function(palette, n = NULL, reverse = FALSE) {
  if (!is.character(palette) || length(palette) != 1L || is.na(palette)) {
    stop("`palette` must be a single palette ID, such as \"kawaii_tri_07\".",
         call. = FALSE)
  }
  .check_flag(reverse, "reverse")
  if (!palette %in% names(.japanesecolors_palettes)) {
    stop(sprintf("Unknown palette \"%s\".%s Use palette_names() to list them.",
                 palette, .did_you_mean(palette)),
         call. = FALSE)
  }
  colours <- .japanesecolors_palettes[[palette]]
  if (reverse) colours <- rev(colours)
  if (!is.null(n)) {
    n <- .check_n(n)
    if (length(n) != 1L) stop("`n` must be a single number.", call. = FALSE)
    if (n > length(colours)) {
      stop(sprintf(paste0("\"%s\" has %d colours; %d requested. ",
                          "Pick a larger palette -- colours are not recycled or interpolated."),
                   palette, length(colours), n),
           call. = FALSE)
    }
    colours <- colours[seq_len(n)]
  }
  unname(colours)
}

# Suggest a close ID when a lookup fails; purely cosmetic.
.did_you_mean <- function(x) {
  ids <- names(.japanesecolors_palettes)
  d <- utils::adist(x, ids, ignore.case = TRUE)[1, ]
  near <- ids[d <= 3 & d == min(d)]
  if (!length(near)) return("")
  sprintf(" Did you mean %s?", paste(dQuote(utils::head(near, 3), FALSE), collapse = ", "))
}

#' Metadata for one palette
#'
#' @param palette A single palette ID, such as `"kawaii_tri_19"`.
#' @return A one-row data frame with the same columns as [palettes()], plus a
#'   `colors` list-column holding the palette's hex vector.
#' @seealso [palettes()], [palettes_needing_review()]
#' @examples
#' palette_info("retro_bi_01")
#'
#' # provenance and the reason a reading is provisional
#' palette_info("kawaii_tri_19")$note
#' @export
palette_info <- function(palette) {
  if (!is.character(palette) || length(palette) != 1L || is.na(palette)) {
    stop("`palette` must be a single palette ID.", call. = FALSE)
  }
  if (!palette %in% .japanesecolors_catalogue$id) {
    stop(sprintf("Unknown palette \"%s\".%s Use palette_names() to list them.",
                 palette, .did_you_mean(palette)),
         call. = FALSE)
  }
  out <- .japanesecolors_catalogue[.japanesecolors_catalogue$id == palette, , drop = FALSE]
  out$colors <- list(.japanesecolors_palettes[[palette]])
  rownames(out) <- NULL
  out
}

#' Palettes containing provisional readings
#'
#' Colour values were transcribed by hand from printed RGB labels. Where a
#' printed digit was not reliably legible, the reading is recorded as
#' provisional rather than being treated as confirmed. This function reports
#' every such swatch so the uncertainty stays visible.
#'
#' These palettes are exported and usable like any other; the values are the
#' best available reading, not a guess at a nicer colour.
#'
#' @return A data frame with one row per provisional **swatch**, giving the
#'   palette ID, collection, swatch position, the candidate RGB and hex values,
#'   and why the reading is uncertain.
#' @seealso [palettes()], [palette_info()]
#' @examples
#' palettes_needing_review()[, c("palette_id", "order", "hex")]
#'
#' # how many palettes are affected
#' length(unique(palettes_needing_review()$palette_id))
#' @export
palettes_needing_review <- function() {
  sw <- .japanesecolors_swatches[.japanesecolors_swatches$status == "review", , drop = FALSE]
  meta <- .japanesecolors_catalogue[
    match(sw$palette_id, .japanesecolors_catalogue$id),
    c("collection_label", "type"),
    drop = FALSE
  ]
  out <- data.frame(
    palette_id       = sw$palette_id,
    collection       = sw$collection,
    collection_label = meta$collection_label,
    type             = meta$type,
    order            = sw$order,
    red              = sw$red,
    green            = sw$green,
    blue             = sw$blue,
    hex              = sw$hex,
    note             = sw$note,
    stringsAsFactors = FALSE
  )
  rownames(out) <- NULL
  out
}

#' Monochrome reference swatches
#'
#' Single-colour references printed alongside the matching palettes in the
#' Minimalism and Kawaii sections. They are recorded separately because they
#' are not matching palettes and are deliberately not combined into one.
#'
#' @inheritParams palettes
#' @return A data frame with one row per monochrome swatch.
#' @examples
#' monochrome()
#' monochrome("kawaii")
#' @export
monochrome <- function(collection = NULL) {
  collection <- .check_collection(collection)
  out <- .japanesecolors_monochrome
  if (!is.null(collection)) out <- out[out$collection %in% collection, , drop = FALSE]
  rownames(out) <- NULL
  out
}
