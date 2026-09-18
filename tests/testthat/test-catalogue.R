# Discovery, filtering and lookup functions.

test_that("palettes() returns the whole catalogue with the documented columns", {
  p <- palettes()
  expect_s3_class(p, "data.frame")
  expect_identical(names(p),
                   c("id", "name", "name_status", "collection", "collection_label",
                     "family", "type", "n_colors", "status", "note"))
  expect_identical(nrow(p), length(palette_names()))
  expect_false(anyNA(p$id))
  expect_type(p$n_colors, "integer")
})

test_that("collection filtering works and is case-insensitive", {
  for (coll in c("retro", "minimalism", "kawaii", "avantgarde")) {
    sub <- palettes(coll)
    expect_gt(nrow(sub), 0)
    expect_true(all(sub$collection == coll))
    expect_true(all(startsWith(sub$id, paste0(coll, "_"))))
  }
  expect_identical(palettes("KAWAII"), palettes("kawaii"))

  # the four collections partition the catalogue
  expect_identical(
    sum(vapply(c("retro", "minimalism", "kawaii", "avantgarde"),
               function(x) nrow(palettes(x)), integer(1))),
    nrow(palettes())
  )

  # several collections at once
  expect_identical(
    nrow(palettes(c("retro", "kawaii"))),
    nrow(palettes("retro")) + nrow(palettes("kawaii"))
  )
})

test_that("type filtering accepts both printed names and short codes", {
  expect_identical(palettes(type = "tricolor"), palettes(type = "tri"))
  expect_identical(palettes(type = "four-color"), palettes(type = "four"))
  expect_true(all(palettes(type = "bicolor")$n_colors == 2L))
  expect_true(all(palettes(type = "multicolor")$n_colors >= 5L))
  expect_identical(
    nrow(palettes(type = c("bi", "tri"))),
    nrow(palettes(type = "bi")) + nrow(palettes(type = "tri"))
  )
})

test_that("n filtering returns only palettes of that size", {
  for (k in c(2L, 3L, 4L, 5L)) {
    expect_true(all(palettes(n = k)$n_colors == k))
  }
  expect_true(all(palettes(n = c(6, 7))$n_colors %in% c(6L, 7L)))
  expect_identical(nrow(palettes(n = 999)), 0L)
})

test_that("filters combine", {
  sub <- palettes("kawaii", type = "tri")
  expect_true(all(sub$collection == "kawaii"))
  expect_true(all(sub$family == "tri"))
  expect_true(all(sub$n_colors == 3L))
})

test_that("include_review controls whether provisional palettes are listed", {
  all_p <- palettes(include_review = TRUE)
  clean <- palettes(include_review = FALSE)
  expect_true(nrow(clean) < nrow(all_p))
  expect_true(all(clean$status == "transcribed"))
  expect_identical(nrow(all_p) - nrow(clean), sum(all_p$status == "review"))
})

test_that("palettes() rejects unknown filter values", {
  expect_error(palettes("not-a-collection"), "Unknown collection")
  expect_error(palettes(type = "quintcolor"), "Unknown matching type")
  expect_error(palettes(n = -1), "positive whole")
  expect_error(palettes(n = 2.5), "positive whole")
  expect_error(palettes(include_review = NA), "TRUE or FALSE")
  expect_error(palettes(include_review = "yes"), "TRUE or FALSE")
})

test_that("palette_names() agrees with palettes()", {
  expect_identical(palette_names(), palettes()$id)
  expect_identical(palette_names("avantgarde"), palettes("avantgarde")$id)
  expect_identical(palette_names("minimalism", type = "bicolor"),
                   palettes("minimalism", type = "bicolor")$id)
  expect_type(palette_names(), "character")
})

test_that("collections() describes exactly the four collections", {
  cl <- collections()
  expect_s3_class(cl, "data.frame")
  expect_identical(cl$collection, c("retro", "minimalism", "kawaii", "avantgarde"))
  expect_identical(cl$label, c("Retro", "Minimalism", "Kawaii", "Avant Garde"))

  # the advertised counts must match the catalogue
  for (i in seq_len(nrow(cl))) {
    expect_identical(cl$n_palettes[i], nrow(palettes(cl$collection[i])),
                     info = cl$collection[i])
    expect_identical(cl$n_review[i],
                     sum(palettes(cl$collection[i])$status == "review"),
                     info = cl$collection[i])
  }
  expect_identical(sum(cl$n_palettes), nrow(palettes()))
})

test_that("get_palette() looks palettes up by ID", {
  expect_identical(get_palette("kawaii_tri_07"), kawaii_tri_07)
  expect_identical(get_palette("retro_four_03"), retro_four_03)
  expect_identical(get_palette("minimalism_bi_01"), minimalism_bi_01)
  expect_identical(get_palette("avantgarde_multi_01"), avantgarde_multi_01)
  expect_null(names(get_palette("kawaii_tri_07")))
})

test_that("get_palette() honours n and reverse", {
  full <- get_palette("retro_multi_01")
  expect_identical(get_palette("retro_multi_01", n = 3), full[1:3])
  expect_identical(get_palette("retro_multi_01", reverse = TRUE), rev(full))
  # reverse is applied before n
  expect_identical(get_palette("retro_multi_01", n = 2, reverse = TRUE), rev(full)[1:2])
})

test_that("get_palette() never recycles or interpolates", {
  n_avail <- length(get_palette("minimalism_bi_01"))
  expect_error(get_palette("minimalism_bi_01", n = n_avail + 1L),
               "not recycled or interpolated")
})

test_that("get_palette() errors informatively on bad input", {
  expect_error(get_palette("nope"), "Unknown palette")
  expect_error(get_palette(c("a", "b")), "single palette ID")
  expect_error(get_palette(1), "single palette ID")
  expect_error(get_palette(NA_character_), "single palette ID")
  # a near miss suggests the real name
  expect_error(get_palette("kawaii_tri_7"), "Did you mean")
})

test_that("palette_info() returns one row with the colours attached", {
  info <- palette_info("retro_bi_01")
  expect_identical(nrow(info), 1L)
  expect_identical(info$id, "retro_bi_01")
  expect_identical(info$colors[[1]], retro_bi_01)
  expect_identical(info$collection, "retro")
  expect_identical(info$type, "bicolor")
  expect_error(palette_info("nope"), "Unknown palette")
})

test_that("monochrome() returns separate single-colour references", {
  m <- monochrome()
  expect_s3_class(m, "data.frame")
  expect_gt(nrow(m), 0)
  expect_true(all(grepl("^#[0-9A-F]{6}$", m$hex)))
  expect_true(all(m$collection %in% c("minimalism", "kawaii")))
  expect_identical(nrow(monochrome("kawaii")),
                   sum(m$collection == "kawaii"))
  expect_error(monochrome("nope"), "Unknown collection")
})
