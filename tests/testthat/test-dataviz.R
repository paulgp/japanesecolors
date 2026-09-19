# The dataviz_friendly flag and the measurements behind it.

test_that("the catalogue carries the dataviz columns", {
  p <- palettes()
  expect_type(p$dataviz_friendly, "logical")
  expect_false(anyNA(p$dataviz_friendly))
  for (col in c("min_delta_e", "min_delta_e_cvd", "min_delta_e_white")) {
    expect_type(p[[col]], "double")
    expect_false(anyNA(p[[col]]), info = col)
    expect_true(all(p[[col]] >= 0), info = col)
  }
})

test_that("some palettes pass and some fail", {
  # a flag that is constant would be useless
  p <- palettes()
  expect_gt(sum(p$dataviz_friendly), 0)
  expect_gt(sum(!p$dataviz_friendly), 0)
})

test_that("the flag agrees with the measurements and the shipped thresholds", {
  skip_if_not_installed("jsonlite")
  path <- system.file("extdata", "japanesecolors-palettes.json", package = "japanesecolors")
  skip_if(path == "", "canonical JSON not installed")
  thresholds <- jsonlite::fromJSON(path, simplifyVector = TRUE)$dataviz$thresholds

  p <- palettes()
  expected <- p$min_delta_e >= thresholds$min_delta_e &
    p$min_delta_e_cvd >= thresholds$min_delta_e_cvd &
    p$min_delta_e_white >= thresholds$min_delta_e_white

  expect_identical(p$dataviz_friendly, expected)
})

test_that("CVD separation does not substantially exceed normal-vision separation", {
  # Sanity check on the simulation: dichromacy should not pull colours apart.
  # The Machado matrices are fitted linear approximations rather than strict
  # projections onto a dichromat gamut, so with sRGB clamping a distance can
  # creep up marginally (retro_tri_11 goes 37.0 to 37.1). A large increase would
  # mean the simulation is wrong, so allow slack but not much.
  p <- palettes()
  expect_true(all(p$min_delta_e_cvd <= p$min_delta_e + 2))
})

test_that("dataviz_friendly filters the catalogue", {
  yes <- palettes(dataviz_friendly = TRUE)
  no <- palettes(dataviz_friendly = FALSE)
  expect_true(all(yes$dataviz_friendly))
  expect_false(any(no$dataviz_friendly))
  expect_identical(nrow(yes) + nrow(no), nrow(palettes()))

  expect_identical(palette_names(dataviz_friendly = TRUE), yes$id)
  expect_error(palettes(dataviz_friendly = "yes"), "TRUE or FALSE")
  expect_error(palettes(dataviz_friendly = NA), "TRUE or FALSE")
})

test_that("dataviz_friendly combines with the other filters", {
  sub <- palettes("retro", n = 4, dataviz_friendly = TRUE)
  expect_true(all(sub$collection == "retro"))
  expect_true(all(sub$n_colors == 4L))
  expect_true(all(sub$dataviz_friendly))
})

test_that("every flagged palette really is separable", {
  # guards against the flag drifting away from the data it summarises
  thresholds_cvd <- 10
  for (i in seq_len(nrow(palettes(dataviz_friendly = TRUE)))) {
    row <- palettes(dataviz_friendly = TRUE)[i, ]
    expect_gte(row$min_delta_e_cvd, thresholds_cvd, label = row$id)
  }
})
