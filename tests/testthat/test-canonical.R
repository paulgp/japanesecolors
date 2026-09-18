# inst/extdata/japanesecolors-palettes.json is the canonical record that ships
# with the package; every generated artefact is derived from it. These tests
# re-derive the expected values from that JSON, so a generated file that has
# drifted -- or been hand-edited -- fails here.

canonical <- function() {
  testthat::skip_if_not_installed("jsonlite")
  path <- system.file("extdata", "japanesecolors-palettes.json", package = "japanesecolors")
  testthat::skip_if(path == "", "canonical JSON not installed")
  jsonlite::fromJSON(path, simplifyVector = FALSE)
}

test_that("the canonical JSON ships with the package", {
  path <- system.file("extdata", "japanesecolors-palettes.json", package = "japanesecolors")
  expect_true(nzchar(path))
  expect_true(file.exists(path))
})

test_that("every exported object matches the canonical transcription", {
  src <- canonical()
  expect_identical(length(src$palettes), nrow(palettes()))

  for (p in src$palettes) {
    expected <- toupper(vapply(p$colors, function(s) s$hex, character(1)))
    obj <- get(p$id, envir = asNamespace("japanesecolors"))
    expect_identical(obj, expected, info = p$id)
  }
})

test_that("catalogue metadata matches the canonical transcription", {
  src <- canonical()
  cat_df <- palettes()

  for (p in src$palettes) {
    row <- cat_df[cat_df$id == p$id, ]
    expect_identical(nrow(row), 1L, info = p$id)
    expect_identical(row$collection, p$collection, info = p$id)
    expect_identical(row$family, p$family, info = p$id)
    expect_identical(row$n_colors, length(p$colors), info = p$id)
    expect_identical(row$status, p$status, info = p$id)
    expect_identical(row$name, p$name, info = p$id)
  }
})

test_that("RGB and hex agree throughout the canonical data", {
  src <- canonical()
  for (p in src$palettes) {
    for (s in p$colors) {
      rgb <- unlist(s$rgb)
      expect_length(rgb, 3L)
      expect_true(all(rgb >= 0 & rgb <= 255), info = p$id)
      expect_identical(toupper(s$hex),
                       sprintf("#%02X%02X%02X", rgb[1], rgb[2], rgb[3]),
                       info = paste(p$id, s$order))
    }
  }
})

test_that("review status is consistent between swatches, palettes and the QA report", {
  src <- canonical()
  review_ids <- character()

  for (p in src$palettes) {
    any_review <- any(vapply(p$colors, function(s) s$status == "review", logical(1)))
    # a palette is flagged exactly when one of its swatches is
    expect_identical(p$status == "review", any_review, info = p$id)
    if (any_review) review_ids <- c(review_ids, p$id)

    # and every flagged swatch explains itself
    for (s in p$colors) {
      if (s$status == "review") {
        expect_true(nzchar(s$note), info = paste(p$id, s$order))
      }
    }
  }

  flagged <- palettes(include_review = TRUE)
  expect_setequal(review_ids, flagged$id[flagged$status == "review"])
  expect_setequal(unique(palettes_needing_review()$palette_id), review_ids)
})

test_that("palettes_needing_review() reports every provisional swatch", {
  src <- canonical()
  expected <- do.call(rbind, lapply(src$palettes, function(p) {
    rows <- Filter(function(s) s$status == "review", p$colors)
    if (!length(rows)) return(NULL)
    data.frame(palette_id = p$id,
               order = vapply(rows, function(s) as.integer(s$order), integer(1)),
               hex = toupper(vapply(rows, function(s) s$hex, character(1))),
               stringsAsFactors = FALSE)
  }))

  got <- palettes_needing_review()
  expect_identical(nrow(got), nrow(expected))
  expect_identical(got$palette_id, expected$palette_id)
  expect_identical(got$order, expected$order)
  expect_identical(got$hex, expected$hex)
  expect_true(all(nzchar(got$note)))

  # the reported RGB must reconstruct the reported hex
  expect_identical(got$hex, sprintf("#%02X%02X%02X", got$red, got$green, got$blue))
})

test_that("the shipped CSV agrees with the exported objects", {
  path <- system.file("extdata", "japanesecolors-palettes.csv", package = "japanesecolors")
  skip_if(path == "", "canonical CSV not installed")
  csv <- utils::read.csv(path, stringsAsFactors = FALSE)

  expect_identical(nrow(csv), sum(palettes()$n_colors))
  by_pal <- split(csv, csv$palette_id)
  for (id in names(by_pal)) {
    rows <- by_pal[[id]][order(by_pal[[id]]$order), ]
    expect_identical(toupper(rows$hex), get_palette(id), info = id)
  }
})

test_that("no source-location metadata is shipped in the package", {
  # the source book's page structure is not part of the distributed package
  leaked <- intersect(names(palettes()),
                      c("design_ref", "source_photo", "reference_sheet",
                        "source_position"))
  expect_identical(leaked, character(0))

  json <- readLines(
    system.file("extdata", "japanesecolors-palettes.json", package = "japanesecolors"),
    warn = FALSE
  )
  for (field in c("IMG_", "source_photo", "source_position", "reference_sheet",
                  "design_ref")) {
    expect_false(any(grepl(field, json, fixed = TRUE)), info = field)
  }
})

`%||%` <- function(x, y) if (is.null(x)) y else x
