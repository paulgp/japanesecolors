# show_palette() draws to a device; these tests check that it accepts the
# documented inputs, rejects bad ones, and leaves graphics state alone.

with_null_device <- function(code) {
  path <- tempfile(fileext = ".pdf")
  grDevices::pdf(path)
  on.exit({
    grDevices::dev.off()
    unlink(path)
  }, add = TRUE)
  force(code)
}

test_that("show_palette() accepts a palette object and returns it invisibly", {
  with_null_device({
    expect_invisible(show_palette(kawaii_tri_07))
    expect_identical(withVisible(show_palette(kawaii_tri_07))$value, kawaii_tri_07)
  })
})

test_that("show_palette() accepts a palette ID string", {
  with_null_device({
    expect_silent(show_palette("kawaii_tri_07"))
    expect_silent(show_palette("retro_multi_01"))
  })
})

test_that("show_palette() accepts a bare vector of colours", {
  with_null_device({
    expect_silent(show_palette(c("#FF0000", "#00FF00", "#0000FF")))
    expect_silent(show_palette(c("red", "blue")))
  })
})

test_that("show_palette() honours its display arguments", {
  with_null_device({
    expect_silent(show_palette(kawaii_tri_07, labels = FALSE))
    expect_silent(show_palette(kawaii_tri_07, title = "Custom"))
    expect_silent(show_palette(kawaii_tri_07, title = NULL))
    expect_silent(show_palette(kawaii_tri_07, border = NA))
  })
})

test_that("show_palette() restores graphics parameters", {
  with_null_device({
    before <- graphics::par("mar")
    show_palette(kawaii_tri_07)
    expect_identical(graphics::par("mar"), before)
  })
})

test_that("show_palette() rejects things that are not colours", {
  with_null_device({
    expect_error(show_palette(c("#FF0000", "not-a-colour")), "not colours")
    expect_error(show_palette(1:3), "palette ID or a character vector")
    expect_error(show_palette(character(0)), "palette ID or a character vector")
    expect_error(show_palette(NA_character_), "palette ID or a character vector")
    expect_error(show_palette(kawaii_tri_07, labels = "yes"), "TRUE or FALSE")
  })
})

test_that("every palette in the catalogue can be drawn", {
  with_null_device({
    for (id in palette_names()) {
      expect_silent(show_palette(id))
    }
  })
})
