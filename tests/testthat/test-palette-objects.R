# Every palette in the catalogue must exist as an exported object, hold valid
# hex colours, and agree with the catalogue in every respect.

test_that("every catalogued palette is an exported object", {
  ids <- palette_names()
  expect_gt(length(ids), 0)

  exported <- getNamespaceExports("japanesecolors")
  missing <- setdiff(ids, exported)
  expect_identical(missing, character(0),
                   info = paste("not exported:", paste(missing, collapse = ", ")))
})

test_that("every exported palette object resolves to a character vector", {
  for (id in palette_names()) {
    obj <- get(id, envir = asNamespace("japanesecolors"))
    expect_type(obj, "character")
    expect_gt(length(obj), 0)
    expect_false(anyNA(obj))
  }
})

test_that("exported palette objects match the catalogue exactly", {
  cat_df <- palettes()
  for (i in seq_len(nrow(cat_df))) {
    id <- cat_df$id[i]
    obj <- get(id, envir = asNamespace("japanesecolors"))
    expect_identical(obj, get_palette(id), info = id)
    expect_identical(length(obj), cat_df$n_colors[i], info = id)
  }
})

test_that("all hex values are valid six-digit uppercase hex", {
  for (id in palette_names()) {
    obj <- get(id, envir = asNamespace("japanesecolors"))
    expect_true(all(grepl("^#[0-9A-F]{6}$", obj)),
                info = paste(id, ":", paste(obj, collapse = " ")))
    # R itself must be able to parse every value as a colour
    expect_silent(grDevices::col2rgb(obj))
  }
})

test_that("palette lengths match the matching type", {
  cat_df <- palettes()
  expected <- c(bi = 2L, tri = 3L, four = 4L)

  for (fam in names(expected)) {
    rows <- cat_df[cat_df$family == fam, ]
    expect_true(all(rows$n_colors == expected[[fam]]),
                info = paste(fam, "palettes must have", expected[[fam]], "colours"))
  }
  # multicolor is everything with five or more
  multi <- cat_df[cat_df$family == "multi", ]
  expect_true(all(multi$n_colors >= 5L))

  # and family always agrees with the human-readable type
  expect_identical(
    unname(c(bi = "bicolor", tri = "tricolor",
             four = "four-color", multi = "multicolor")[cat_df$family]),
    cat_df$type
  )
})

test_that("palette IDs are unique and well formed", {
  ids <- palettes()$id
  expect_identical(anyDuplicated(ids), 0L)
  id_pattern <- "^(retro|minimalism|kawaii|avantgarde)_(bi|tri|four|multi)_[0-9]{2}$"
  expect_true(all(grepl(id_pattern, ids)))

  # the ID's own segments must agree with the metadata columns
  parts <- do.call(rbind, strsplit(ids, "_", fixed = TRUE))
  expect_identical(parts[, 1], palettes()$collection)
  expect_identical(parts[, 2], palettes()$family)
})

test_that("palette numbering is contiguous within each collection and type", {
  cat_df <- palettes()
  groups <- split(cat_df, list(cat_df$collection, cat_df$family), drop = TRUE)
  for (g in groups) {
    nums <- sort(as.integer(sub("^.*_", "", g$id)))
    expect_identical(nums, seq_len(nrow(g)),
                     info = paste(g$collection[1], g$family[1]))
  }
})

test_that("no palette object shadows a base or stats function", {
  # the previous build exported `family`, `status`, `name` and friends, which
  # masked stats::family among others
  risky <- c("id", "name", "family", "status", "note", "collection",
             "n_colors", "type", "note")
  expect_identical(intersect(getNamespaceExports("japanesecolors"), risky), character(0))
})
