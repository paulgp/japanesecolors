# ggplot2 scale helpers and the palette function behind them.

test_that("japanesecolors_pal() returns the first n colours", {
  pal <- japanesecolors_pal("retro_four_03")
  expect_type(pal, "closure")
  expect_identical(pal(4), retro_four_03)
  expect_identical(pal(2), retro_four_03[1:2])
  expect_identical(pal(0), character(0))
})

test_that("japanesecolors_pal() can reverse", {
  expect_identical(japanesecolors_pal("retro_four_03", reverse = TRUE)(4),
                   rev(retro_four_03))
})

test_that("japanesecolors_pal() refuses to stretch a palette", {
  pal <- japanesecolors_pal("kawaii_tri_07")
  expect_error(pal(4), "has 3 colours, but 4 are needed")
  expect_error(pal(4), "not interpolated or recycled")
  expect_error(pal(-1), "non-negative")
  expect_error(japanesecolors_pal("nope"), "Unknown palette")
})

test_that("scale constructors build ggplot2 scales", {
  skip_if_not_installed("ggplot2")

  sc <- scale_colour_japanesecolors("kawaii_tri_07")
  expect_s3_class(sc, "Scale")
  expect_identical(sc$aesthetics, "colour")

  sf <- scale_fill_japanesecolors("kawaii_tri_07")
  expect_s3_class(sf, "Scale")
  expect_identical(sf$aesthetics, "fill")
})

test_that("scale_color_japanesecolors() is an alias of the colour spelling", {
  skip_if_not_installed("ggplot2")
  expect_identical(scale_color_japanesecolors, scale_colour_japanesecolors)
  expect_identical(scale_color_japanesecolors("retro_bi_01")$aesthetics, "colour")
})

test_that("scales carry the palette's colours", {
  skip_if_not_installed("ggplot2")
  sc <- scale_colour_japanesecolors("kawaii_tri_07")
  # scale_*_manual stores the values it was given
  expect_identical(unname(sc$palette(3)), kawaii_tri_07)

  rev_sc <- scale_colour_japanesecolors("kawaii_tri_07", reverse = TRUE)
  expect_identical(unname(rev_sc$palette(3)), rev(kawaii_tri_07))
})

test_that("scales pass extra arguments through to ggplot2", {
  skip_if_not_installed("ggplot2")
  sc <- scale_colour_japanesecolors("kawaii_tri_07", name = "Group")
  expect_identical(sc$name, "Group")
  expect_identical(scale_fill_japanesecolors("retro_bi_01", na.value = "black")$na.value,
                   "black")
})

test_that("scales reject unknown palettes", {
  skip_if_not_installed("ggplot2")
  expect_error(scale_colour_japanesecolors("nope"), "Unknown palette")
  expect_error(scale_fill_japanesecolors("nope"), "Unknown palette")
})

test_that("a discrete plot using a japanesecolors scale builds successfully", {
  skip_if_not_installed("ggplot2")

  d <- data.frame(x = 1:3, y = 1:3, g = factor(c("a", "b", "c")))

  p <- ggplot2::ggplot(d, ggplot2::aes(x, y, colour = g)) +
    ggplot2::geom_point() +
    scale_colour_japanesecolors("kawaii_tri_07")
  built <- ggplot2::ggplot_build(p)
  expect_setequal(unique(built$data[[1]]$colour), kawaii_tri_07)

  pf <- ggplot2::ggplot(d, ggplot2::aes(x, y, fill = g)) +
    ggplot2::geom_col() +
    scale_fill_japanesecolors("kawaii_tri_07")
  expect_setequal(unique(ggplot2::ggplot_build(pf)$data[[1]]$fill), kawaii_tri_07)
})

test_that("a plot with more groups than colours fails rather than recycling", {
  skip_if_not_installed("ggplot2")
  d <- data.frame(x = 1:4, y = 1:4, g = factor(letters[1:4]))
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y, colour = g)) +
    ggplot2::geom_point() +
    scale_colour_japanesecolors("kawaii_tri_07")
  expect_error(ggplot2::ggplot_build(p))
})
