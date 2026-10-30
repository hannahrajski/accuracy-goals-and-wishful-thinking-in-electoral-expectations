# Packages, colors, themes and functions shared by all scripts (21-23, 31-33, 40).

# Packages ---------------------------------------------------------------------

options(pkgType = "binary") # install precompiled packages, no source builds

p_required <- c(
  "tidyverse",
  "knitr",
  "rmarkdown",
  "rprojroot",
  "haven",
  "labelled",
  "readxl",
  "ggridges",
  "ggtext",
  "ggalluvial",
  "viridis",
  "scales",
  "patchwork",
  "marginaleffects",
  "sandwich",
  "lmtest",
  "texreg",
  "gt"
)

# Install missing packages, then load all
# Base R here: the tidyverse may not be installed yet
p_to_install <- p_required[!(p_required %in% rownames(installed.packages()))]
if (length(p_to_install) > 0) {
  install.packages(p_to_install)
}
invisible(sapply(p_required, require, character.only = TRUE))
rm(p_required, p_to_install) # keep the workspace clean

# simloglm is not on CRAN:
# remotes::install_github("mneunhoe/simloglm")
library(simloglm)



# Colors -----------------------------------------------------------------------

# Treatment groups (viridis) and their differences to the control group
color_t5        <- "#440154FF"
color_t500      <- "#31688EFF"
color_diff_t5   <- "#29af7f"
color_diff_t500 <- "#bddf26"

# Party colors, CDU (Saxony) and CDU/CSU (federal) share one color
color_parties <- c(
  "CDU/CSU"     = "#2d3c4b",
  "CDU"         = "#2d3c4b",
  "SPD"         = "#E3000F",
  "Greens"      = "#3EAE2C",
  "FDP"         = "#FFED00",
  "Left"        = "#8100A1",
  "AfD"         = "#009EE0",
  "BSW"         = "#CD5E89",
  "Free Voters" = "#e59736",
  "Others"      = "grey50"
)

# Federal: three experimental groups
# Shapes 21-25 are fillable: circle, square, diamond, triangle up, triangle down
groups_colors_federal <- c("C" = "#999999", "T(5)" = color_t5, "T(500)" = color_t500)
groups_shapes_federal <- c("C" = 21,        "T(5)" = 22,         "T(500)" = 23)

# Pairwise differences between the groups
diffs_colors_federal <- c("T(5) - C" = color_diff_t5, "T(500) - C" = color_diff_t500, "T(500) - T(5)" = "#BBBBBB")
diffs_fill_federal   <- c("T(5) - C" = color_diff_t5, "T(500) - C" = "white",         "T(500) - T(5)" = "#BBBBBB")
diffs_shapes_federal <- c("T(5) - C" = 17,            "T(500) - C" = 24,              "T(500) - T(5)" = 25)

# Saxony: two experimental groups
groups_colors_saxony <- c("C" = "#999999", "T(500)" = color_t500)
groups_shapes_saxony <- c("C" = 21,        "T(500)" = 23)

diffs_colors_saxony <- c("T(500) - C" = color_diff_t500)
diffs_fill_saxony   <- c("T(500) - C" = "white")
diffs_shapes_saxony <- c("T(500) - C" = 24)

# Main sample vs. sample without exclusions (Figure C.7)
# Black triangles: filled = main sample, hollow = no exclusions
sample_colors <- c("Main" = "black", "No excl." = "black")
sample_shapes <- c("Main" = 24,      "No excl." = 24)
sample_fills  <- c("Main" = "black", "No excl." = "white")

# Recruitment channel in Saxony (Figure C.8)
# Filled = online access panel (OAP), hollow = social media (SM)
recruit_colors <- c("OAP" = "black", "SM" = "black")
recruit_shapes <- c("OAP" = 24,      "SM" = 24)
recruit_fills  <- c("OAP" = "black", "SM" = "white")

# Panels of Figures C.7 and C.8
sample_outcome_levels <- c(
  "H1: Response Time (s, median)", "H2: MAE",
  "H3: Forecast Error (PTV): Preferred", "H3: Forecast Error (PTV): Other"
)


# Themes -----------------------------------------------------------------------

# Point estimates with confidence intervals
theme_estimates <- function(legend_position = "none") {
  ggplot2::theme_minimal() +
    ggplot2::theme(
      plot.title       = ggplot2::element_text(face = "bold",  size = 20),
      plot.subtitle    = ggplot2::element_text(face = "plain", size = 16),
      panel.background = ggplot2::element_blank(),
      panel.grid       = ggplot2::element_blank(),
      axis.line.y      = ggplot2::element_blank(),
      axis.ticks.y     = ggplot2::element_blank(),
      axis.line.x      = ggplot2::element_line(),
      axis.text.x      = ggplot2::element_text(size = 16),
      axis.text.y      = ggplot2::element_text(size = 16),
      axis.title.x     = ggplot2::element_text(size = 17),
      axis.title.y     = ggplot2::element_text(size = 17),
      legend.position  = legend_position,
      legend.text      = ggplot2::element_text(size = 14),
      legend.title     = ggplot2::element_text(size = 14),
      strip.text       = ggplot2::element_text(size = 16),
      plot.margin      = ggplot2::margin(10, 30, 10, 10)
    )
}

# Other figures
theme_basic <- function(base_size = 14, grid = FALSE, axis_lines = TRUE,
                       legend_position = "none") {
  th <- ggplot2::theme_minimal(base_size = base_size) +
    ggplot2::theme(
      plot.title      = ggplot2::element_text(face = "bold", size = 20),
      axis.text.x     = ggplot2::element_text(size = 16, face = "plain"),
      axis.text.y     = ggplot2::element_text(size = 16, face = "plain"),
      axis.title.x    = ggplot2::element_text(size = 17, face = "plain"),
      axis.title.y    = ggplot2::element_text(size = 17, face = "plain"),
      legend.position = legend_position,
      plot.margin     = ggplot2::margin(10, 30, 10, 10)
    )
  if (axis_lines) {
    th <- th + ggplot2::theme(
      axis.line.y  = ggplot2::element_blank(),
      axis.ticks.y = ggplot2::element_blank(),
      axis.line.x  = ggplot2::element_line()
    )
  }
  if (grid) {
    th <- th + ggplot2::theme(
      panel.grid.major.y = ggplot2::element_line(color = "gray85", linewidth = 0.4),
      panel.grid.major.x = ggplot2::element_line(color = "gray85", linewidth = 0.4),
      panel.grid.minor   = ggplot2::element_blank()
    )
  }
  th
}


# Saving Figures ---------------------------------------------------------------

# Printed widths in the paper (A4, 25 mm side margins)
# \textwidth = 16 cm, landscape pages: \linewidth = 25.2 cm
figure_widths <- c( # in cm
  subfigure = 0.48 * 16,    # 0.48\textwidth (most figures)
  half      = 0.50 * 16,    # Figure 1
  boxplot   = 0.70 * 16,    # Figures B.5, B.6
  landscape = 0.48 * 25.2,  # Figures B.3, B.4
  full      = 16            # Figures C.7, C.8
)

# The canvas is figure_scale times the printed size
# So the 16 pt theme text prints at 8 pt in every figure
figure_scale <- 2

# Saves the plot object with its printed size to data/processed/figures/
# and, for figures of one election only, a PDF at the printed width to output/figures/
# Subfigures of the combined figures (letter after the number, e.g. figure_2a_..., figure_B1b_...)
# get no PDF of their own: 40_combine_figures.Rmd combines them into output/figures/
# aspect: height / width
save_figure <- function(plot, name, election, width = "subfigure", aspect) {
  stopifnot(width %in% names(figure_widths),
            election %in% c("federal", "saxony"))
  printed_width <- figure_widths[[width]] # in cm
  dir.create(file.path("data", "processed", "figures"), recursive = TRUE, showWarnings = FALSE)
  saveRDS(list(plot = plot, width = printed_width, aspect = aspect),
          file.path("data", "processed", "figures", paste0(name, ".rds")))
  file <- file.path("output", "figures", name)
  if (!grepl("^figure_[A-Z]?[0-9]+[a-z]_", name)) { # not a subfigure of a combined figure
    ggplot2::ggsave(paste0(file, ".pdf"), plot, device = grDevices::cairo_pdf, # cairo: embeds fonts and Unicode (e.g. "−")
                    width = printed_width, height = printed_width * aspect, units = "cm",
                    scale = figure_scale)
  }
  invisible(file)
}


# Printing Results -------------------------------------------------------------

# Rounds all numeric columns and prints the whole data frame
# cols: only these columns, if given
print_values <- function(data, cols = NULL, digits = 2) {
  data <- as.data.frame(data)
  if (!is.null(cols)) data <- select(data, any_of(cols))
  data %>%
    mutate(across(where(is.numeric), ~ round(.x, digits))) %>%
    print(row.names = FALSE, digits = 10) # digits = 10: print() does not round again
  invisible(NULL)
}

# Estimate columns of marginaleffects output, for print_values(cols = ...)
est_cols <- c("estimate", "conf.low", "conf.high")


# LaTeX Tables -----------------------------------------------------------------

## Shared Layout (Tables B.5, B.6, C.1-C.7) ------------------------------------

# \centering instead of a center environment and a small caption skip
table_caption_skip <- "3pt"

# lines: LaTeX table, one element per line
tighten_table <- function(lines, skip = table_caption_skip) {
  lines <- if_else(str_trim(lines) == "\\begin{center}", "\\centering", lines) # center environment adds vertical space
  lines <- purrr::discard(lines, ~ str_trim(.x) == "\\end{center}") # purrr::, scales::discard() masks it
  cap <- str_which(lines, "^\\\\caption\\{")[1]
  stopifnot(!is.na(cap))
  append(lines, paste0("\\captionsetup{skip=", skip, "}"), after = cap - 1) # right before the caption
}


## Balance Tables (Tables B.3, B.4) --------------------------------------------

# Shares per category of var, overall and by group
# Denominators: all rows of the sample / group, including respondents with NA on var
# groups: column key -> value of the column by, e.g. c(control = "Control", t500 = "Treatment (500)")
# Returns category, share_full and one column share_<key> per group (0 if a category is missing in a group)
compute_shares <- function(data, var, groups, by = "treatment") {
  data <- data %>% mutate(category = .data[[var]]) # column var as category
  # Shares of the categories in one subsample d, named share_<key>
  count_shares <- function(d, key) {
    d %>%
      filter(!is.na(category)) %>%
      count(category) %>%
      transmute(category, "share_{key}" := n / nrow(d))
  }
  per_group <- imap(groups, ~ count_shares(filter(data, .data[[by]] == .x), .y))
  reduce(per_group, left_join, by = "category", .init = count_shares(data, "full")) %>% # all categories of the sample
    mutate(across(starts_with("share_"), ~ coalesce(.x, 0)))
}

# Shares per category by experimental group
# Federal: All | C | T(5) | T(500), Saxony: All | C | T(500)
compute_group_shares <- function(data, var, var_label, election) {
  compute_shares(data, var, get_election_style(election)$treatment_groups) %>%
    mutate(variable = var_label, .after = category)
}

# Shares of the variables in specs (tibble var, label) by experimental group
# Turnout intention: only "Yes"
# Men* = men and diverse
compute_balance_shares <- function(data, specs, election) {
  map2_dfr(specs$var, specs$label, function(v, l) { # one block of rows per variable
    compute_group_shares(data, v, l, election) %>% mutate(category = as.character(category)) # character: factors differ between variables
  }) %>%
    filter(!(variable == "Turnout Intention" & category != "Yes")) %>%
    mutate(category = if_else(variable == "Gender" & category == "Men", "Men*", category))
}

# Saxony: shares by experimental group and by recruitment channel (OAP, SM)
compute_balance_shares_recruit_saxony <- function(data, specs) {
  recruit <- map2_dfr(specs$var, specs$label, function(v, l) {
    compute_shares(data, v, c(oap = "OAP", sm = "SM"), by = "recruit") %>%
      select(-share_full) %>%
      mutate(category = as.character(category), variable = l)
  }) %>%
    mutate(category = if_else(variable == "Gender" & category == "Men", "Men*", category))
  compute_balance_shares(data, specs, "saxony") %>% # by experimental group
    left_join(recruit, by = c("variable", "category")) # plus the channel columns (turnout: "Yes" only via this join)
}

# Number of respondents in one experimental group
count_group <- function(data, group) sum(data$treatment == group)

# Column sizes of the tables (Saxony also by recruitment channel)
count_by_group <- function(data, election) {
  get_election_style(election) # checks the election name
  if (election == "federal") {
    c(full = nrow(data), control = count_group(data, "Control"), t5 = count_group(data, "Treatment (5)"), t500 = count_group(data, "Treatment (500)"))
  } else {
    c(full = nrow(data), oap = sum(data$recruit == "OAP"), sm = sum(data$recruit == "SM"),
      control = count_group(data, "Control"), t500 = count_group(data, "Treatment (500)"))
  }
}

# Tables B.3 and B.4
# Left block: sample before exclusions
#   each cell "share (difference to the benchmark)"
#   shaded by the absolute difference (0-20 pp)
# Right block: main sample
#   each cell "share (difference to the same column before exclusions)"
#   shaded by the absolute change (0-5 pp)
# data: one row per category
#   columns variable, category, benchmark, and before_<key> and main_<key> for every key in names(groups)
# groups: key = column label
# n_before / n_main: n per key
# note: LaTeX note
write_balance_table <- function(data, groups, n_before, n_main, caption, label,
                                note, file, font_px = 11, tabcolsep_pt = 3) {
  keys        <- names(groups)
  before_cols <- paste0("before_", keys)
  main_cols   <- paste0("main_", keys)
  stopifnot(all(c(before_cols, main_cols, "benchmark") %in% names(data)))

  # Cell formatting: alignment tokens (@...@) are replaced by LaTeX at the end
  format_num <- function(x, latex) { # number in %, in LaTeX padded so decimal points line up
    s <- sprintf("%.1f", abs(x))
    if (latex) if_else(abs(x) < 9.95, paste0("@P@", s), s) else s # @P@ = invisible digit
  }
  format_cell <- function(share, diff, latex) { # "share (+diff)"
    d    <- round(diff * 100, 1) + 0 # in pp, + 0 turns -0 into 0
    sgn  <- case_when( # @S@ = invisible sign
      d > 0 ~ if (latex) "@+@" else "+",
      d < 0 ~ if (latex) "@-@" else "-",
      TRUE  ~ if (latex) "@S@" else ""
    )
    cell <- paste0(format_num(share * 100, latex), " (", sgn, format_num(d, latex), ")")
    if_else(is.na(d), format_num(share * 100, latex), cell) # no benchmark: share only
  }
  # Differences per column key: before exclusions - benchmark, main sample - before exclusions
  compute_diff_bench <- function(key) data[[paste0("before_", key)]] - data$benchmark
  compute_diff_excl  <- function(key) data[[paste0("main_", key)]] - data[[paste0("before_", key)]]

  # Formatted cells, one column per block and key (LaTeX or HTML version)
  create_table_data <- function(latex) {
    tbl <- data %>% dplyr::transmute(
      variable, category,
      Benchmark = if_else(is.na(benchmark), "", format_num(benchmark * 100, latex))
    )
    # left block: difference to the benchmark
    before <- map(keys, ~ format_cell(data[[paste0("before_", .x)]], compute_diff_bench(.x), latex)) %>%
      set_names(before_cols)
    # right block: change through the exclusions
    main <- map(keys, ~ format_cell(data[[paste0("main_", .x)]], compute_diff_excl(.x), latex)) %>%
      set_names(main_cols)
    bind_cols(tbl, as_tibble(before), as_tibble(main))
  }

  create_n_label <- function(key, n, n_ref = NULL) { # column label with n, e.g. "n = 5,562 (-97)"
    diff <- if (is.null(n_ref)) "" else {
      d <- n[[key]] - n_ref[[key]]
      paste0(" (", if (d > 0) "+" else "", format(d, big.mark = ","), ")")
    }
    gt::md(paste0(groups[[key]], " <br>n = ", format(n[[key]], big.mark = ","), diff))
  }
  # Column labels: before block with n, main block with n and the change in n
  col_labels <- c(
    list(category = "", Benchmark = gt::md("Bench- <br>mark")),
    map(keys, create_n_label, n = n_before) %>% set_names(before_cols),
    map(keys, create_n_label, n = n_main, n_ref = n_before) %>% set_names(main_cols)
  )

  shade_bench <- scales::col_numeric(c("white", "gray", "darkgray"), domain = c(0, 0.2))  # shading up to 20 pp
  shade_excl  <- scales::col_numeric(c("white", "gray", "darkgray"), domain = c(0, 0.05)) # shading up to 5 pp

  # gt table, one row group per variable
  create_gt_table <- function(tbl) {
    gt_tbl <- tbl %>%
      gt::gt(groupname_col = "variable") %>%
      gt::tab_caption(caption) %>%
      gt::cols_label(.list = col_labels) %>%
      gt::tab_spanner("Before Exclusions (Difference to Benchmark)", columns = dplyr::all_of(before_cols), id = "before") %>%
      gt::tab_spanner("Main Sample (Difference to Before Exclusions)", columns = dplyr::all_of(main_cols), id = "main") %>%
      gt::tab_style(gt::cell_text(weight = "bold"), gt::cells_column_labels(dplyr::everything())) %>%
      gt::tab_style(gt::cell_text(weight = "bold"), gt::cells_column_spanners()) %>%
      gt::tab_style(gt::cell_text(weight = "bold"), gt::cells_row_groups()) %>%
      gt::tab_style(gt::cell_text(align = "center"), gt::cells_body(columns = -category)) %>%
      gt::tab_source_note("Note: ") %>% # placeholder, replaced by the note in the LaTeX version
      gt::tab_options(latex.use_longtable = TRUE, table.font.size = gt::px(font_px))

    # Shading per column key, each column with its own colors
    reduce(keys, function(g, key) {
      colors_before <- shade_bench(pmin(dplyr::coalesce(abs(compute_diff_bench(key)), 0), 0.2))
      colors_main   <- shade_excl(pmin(abs(compute_diff_excl(key)), 0.05))
      g %>%
        gt::data_color(columns = dplyr::all_of(paste0("before_", key)), colors = function(x) colors_before) %>%
        gt::data_color(columns = dplyr::all_of(paste0("main_", key)), colors = function(x) colors_main)
    }, .init = gt_tbl)
  }

  # LaTeX version: gt output with own label, note and column spacing
  tex <- create_gt_table(create_table_data(latex = TRUE)) %>%
    gt::as_latex() %>%
    as.character() %>%
    str_replace("\\\\caption\\{\\\\label\\{[^{}]*\\}", "\\\\caption{") %>% # drop gt's label (knitting)
    str_replace( # own label, without trailing spaces
      paste0(str_escape(paste0("\\caption{", caption, "} \\\\")), " *"),
      str_replace_all(paste0("\\caption{", caption, "}\n\\label{", label, "} \\\\"), "\\\\", "\\\\\\\\")
    ) %>%
    str_replace(fixed("Note: \\\\"), paste0(note, " \\\\")) %>% # placeholder -> note
    str_replace_all("\\\\shortstack\\[l\\]\\{\\\\parbox\\{\\\\linewidth\\}\\{([^{}]*)\\}\\}", # centered two-line headers
                    "\\\\shortstack{\\1}") %>%
    reduce2( # alignment tokens to LaTeX, one token after the other
      c("@P@", "@S@", "@+@", "@-@"),
      c("\\phantom{0}", "\\phantom{$+$}", "$+$", "$-$"),
      function(x, token, latex) str_replace_all(x, fixed(token), latex),
      .init = .
    ) %>%
    str_replace(fixed("\\begingroup"), paste0("\\begingroup\n\\setlength{\\tabcolsep}{", tabcolsep_pt, "pt}")) # narrower columns
  stopifnot(str_count(tex, fixed(paste0("\\label{", label, "}"))) == 1) # label replaced exactly once
  write_lines(tex, file)

  create_gt_table(create_table_data(latex = FALSE)) # HTML version
}


## Accuracy Tables (Tables B.5, B.6) -------------------------------------------

# Footnote of Tables B.5, B.6
note_accuracy <- "Dev. = Mean - Result. The mean of the individual expectations equals the citizen forecast. The 'MAE' / 'RMSE' rows give the accuracy of these group-level vote share forecasts."

# Tables B.5 / B.6: mean, deviation, SD, MAE and RMSE per party for one group
# Columns are suffixed with group_name
# Adds the MAE / RMSE of the mean expectations (citizen forecast)
compute_accuracy_by_group <- function(data, group_name, election) {
  st <- get_election_style(election)
  # Per party: individual expectations vs. result
  per_party <- data %>%
    group_by(party) %>%
    summarize(
      mean = mean(list_votes_exp, na.rm = TRUE),
      sd = sd(list_votes_exp, na.rm = TRUE),
      mae = mean(abs(list_votes_exp - list_votes_result), na.rm = TRUE),
      rmse = sqrt(mean((list_votes_exp - list_votes_result)^2, na.rm = TRUE)),
      list_votes_result = first(list_votes_result),
      .groups = "drop"
    ) %>%
    mutate(dev = mean - list_votes_result) # error of the citizen forecast

  # Accuracy of the citizen forecast over all parties
  summary_rows <- tibble::tibble(
    party             = c("MAE of the Means", "RMSE of the Means"),
    mean              = NA_real_,
    sd                = NA_real_,
    mae               = c(mean(abs(per_party$dev), na.rm = TRUE), NA_real_),
    rmse              = c(NA_real_, sqrt(mean(per_party$dev^2, na.rm = TRUE))),
    list_votes_result = NA_real_,
    dev               = NA_real_
  )

  bind_rows(per_party, summary_rows) %>%
    mutate(dev = round(dev, 2)) %>%
    select(party, list_votes_result, mean, dev, sd, mae, rmse) %>%
    mutate(party = factor(party, levels = c(st$party_levels_accuracy, "MAE of the Means", "RMSE of the Means"))) %>% # table row order
    rename( # group suffix, so several groups can be joined side by side
      !!paste0("avg_", group_name) := mean,
      !!paste0("sd_", group_name) := sd,
      !!paste0("mae_", group_name) := mae,
      !!paste0("rmse_", group_name) := rmse,
      !!paste0("dev_", group_name) := dev
    )
}

# Tables B.5 / B.6 as LaTeX
# data: output of compute_accuracy_by_group(), one set of columns per group
# groups: named list of group suffixes and spanner labels
#   e.g. c(all = "Full Sample", c = "Control", t500 = "Treatment (500)")
# note: footnote of the Dev. column
write_accuracy_table <- function(data, groups, caption, label, note, file) {
  summary_raw <- c("MAE of the Means", "RMSE of the Means") # summary rows in data
  summary_lab <- c("MAE", "RMSE")                           # their labels in the table
  keys <- names(groups)
  pad  <- function(i) str_dup(" ", i)   # distinct column names per group

  # MAE / RMSE of the means into the Dev. column
  display <- reduce(keys, function(d, k) {
    d %>% mutate(!!paste0("dev_", k) := case_when(
      party == summary_raw[1] ~ .data[[paste0("mae_", k)]],
      party == summary_raw[2] ~ .data[[paste0("rmse_", k)]],
      TRUE ~ .data[[paste0("dev_", k)]]
    ))
  }, .init = data) %>%
    mutate(party = dplyr::recode(as.character(party), !!!set_names(summary_lab, summary_raw)))

  # Displayed columns: Party, Result, then Mean / Error / SD per group (displayed name = data column)
  # gt needs unique names, so the labels of later groups get trailing spaces
  group_cols <- map(seq_along(keys), function(i) {
    set_names(paste0(c("avg_", "dev_", "sd_"), keys[i]),
              paste0(c(if (i == 1) "Mean" else "Avg.", "Error", "SD"), pad(i - 1)))
  })
  display <- display %>% select(all_of(c(Party = "party", Result = "list_votes_result", list_c(group_cols))))
  err_cols <- paste0("Error", pad(seq_along(keys) - 1))
  sd_cols  <- paste0("SD", pad(seq_along(keys) - 1))
  group_cols <- map(group_cols, names) # the 3 columns under each spanner

  color_dev <- scales::col_numeric(
    palette = c("#3d3d3d", "#888888", "white", "#bbbbbb", "#e8e8e8"),
    domain  = c(-10, 10)
  )
  data_party_rows <- data %>% filter(!party %in% summary_raw) # summary rows are not shaded

  g <- display %>%
    gt() %>%
    tab_caption(caption) %>%
    fmt_number(columns = where(is.numeric), decimals = 2) %>%
    sub_missing(everything(), missing_text = "") %>%
    tab_style(style = cell_text(weight = "bold"), locations = cells_column_labels(everything())) %>%
    tab_style(style = cell_text(weight = "bold"), locations = cells_body(columns = c(Party, Result))) %>%
    tab_style(style = cell_text(align = "center"), locations = cells_body(columns = -Party))
  g <- reduce(seq_along(keys), function(g, i) { # spanner and Dev. shading per group
    dev_i <- pull(data_party_rows, paste0("dev_", keys[i]))
    g %>%
      tab_spanner(label = groups[[i]], columns = all_of(group_cols[[i]])) %>%
      data_color(columns = all_of(err_cols[i]), rows = !Party %in% summary_lab,
                 colors = function(x) color_dev(dev_i))
  }, .init = g) %>%
    tab_style(style = cell_text(weight = "bold"), locations = cells_column_spanners(everything())) %>%
    tab_style(style = cell_borders(sides = "right", color = "#888888", weight = px(1.5)), # lines between groups
              locations = cells_body(columns = all_of(head(sd_cols, -1)))) %>%
    tab_style(style = cell_borders(sides = "right", color = "#888888", weight = px(1.5)),
              locations = cells_column_labels(columns = all_of(head(sd_cols, -1)))) %>%
    tab_style(style = cell_borders(sides = c("left", "right"), color = "white", weight = px(1)), # summary rows without inner lines
              locations = cells_body(columns = -c(Party, Result), rows = Party %in% summary_lab)) %>%
    tab_style(style = list(cell_borders(sides = "top", color = "#888888", weight = px(1)),
                           cell_text(weight = "bold")),
              locations = cells_body(rows = Party == "MAE")) %>%
    tab_style(style = cell_text(weight = "bold"), locations = cells_body(rows = Party %in% summary_lab)) %>%
    cols_label(.list = set_names(as.list(paste0("Dev.", pad(seq_along(keys) - 1))), err_cols)) %>% # "Error" columns shown as "Dev."
    tab_footnote(footnote = note, locations = cells_column_labels(all_of(err_cols[1])))

  # gt's LaTeX without its own table float, caption and font size
  tex <- g %>%
    as_latex() %>%
    as.character() %>%
    str_remove("\\\\begin\\{table\\}\\[t\\]\n") %>%
    str_remove("\\\\caption\\{(\\\\label\\{[^}]*\\})?[^}]*\\} ?\n?") %>% # drop gt's caption
    str_remove("\\\\fontsize\\{[^}]*\\}\\{[^}]*\\}\\\\selectfont\n") %>%
    str_remove("\\\\end\\{table\\}\n?$")

  write_lines(paste0(
    "\\begin{table}[h!]\n",
    "\\captionsetup{skip=", table_caption_skip, "}\n",
    "\\caption{", caption, "}\n",
    "\\label{", label, "}\n",
    "\\resizebox{\\linewidth}{!}{%\n",
    "\\begin{minipage}{2\\linewidth}\n",
    tex,
    "\\end{minipage}%\n",
    "}\n",
    "\\end{table}\n"
  ), file)
  g # HTML version
}


## Regression Tables (Tables C.1, C.2, C.5, C.6, C.7) --------------------------

# Regression tables (Tables C.1, C.2, C.5, C.6, C.7)
# Adds rows for date and party fixed effects and clustered standard errors
# Adds "Num. respondents" below "Num. obs."
# cluster_idx: models whose standard errors are clustered by respondent
# note: LaTeX note below the table
# groups: named vector of the number of columns per spanner (top row, e.g. H1 | H2 | H3), NULL = no spanner row
# col_width: width of every model column, NULL = texreg's columns
write_models_table <- function(models, header, coef_map, caption, label,
                               note, file, cluster_idx = integer(0),
                               scalebox = NULL, font_size = "footnotesize",
                               arraystretch = 0.9,
                               model_names = paste0("(", seq_along(models), ")"),
                               groups = NULL, col_width = "2cm",
                               note_width = "\\dimexpr\\linewidth-2\\tabcolsep\\relax") {
  k  <- length(models)
  # Clustered standard errors and p-values, NULL elements keep texreg's defaults
  ct_cluster <- map(seq_len(k), function(j) {
    if (j %in% cluster_idx) lmtest::coeftest(models[[j]], vcov = sandwich::vcovCL(models[[j]], cluster = ~ResponseId))
  })
  se <- map(ct_cluster, ~ if (is.null(.x)) NULL else .x[, "Std. Error"])
  pv <- map(ct_cluster, ~ if (is.null(.x)) NULL else .x[, 4]) # column 4: p-value
  tex <- as.character(texreg::texreg(
    models,
    stars              = c(0.05, 0.01, 0.001),
    custom.header      = set_names(as.list(seq_len(k)), header),
    custom.model.names = model_names,
    custom.note        = "NOTE_PLACEHOLDER", # replaced by the wrapped note below
    override.se        = se,
    override.pvalues   = pv,
    custom.coef.map    = coef_map,
    caption            = caption,
    caption.above      = TRUE,
    label              = label,
    booktabs           = TRUE,
    float.pos          = "t",
    use.packages       = FALSE,
    scalebox           = scalebox
  ))
  lines <- str_split_1(str_remove(tex, "\n$"), fixed("\n")) # no empty last line

  # Spanner row below \toprule, e.g. " & \multicolumn{1}{c}{H1} & \multicolumn{2}{c}{H2} \\"
  if (!is.null(groups)) {
    stopifnot(sum(groups) == k)
    ends   <- cumsum(groups) + 1   # +1: first column holds the row labels
    starts <- ends - groups + 1
    spanner <- paste0(" & ", paste0("\\multicolumn{", groups, "}{c}{", names(groups), "}", collapse = " & "), " \\\\")
    rules   <- paste(paste0("\\cmidrule(lr){", starts, "-", ends, "}"), collapse = " ")
    top <- str_which(lines, fixed("\\toprule"))[1]
    lines <- append(lines, c(spanner, rules), after = top)
  }
  # Equal model column widths: replaces texreg's column spec, e.g. {l c c c}
  if (!is.null(col_width)) {
    i <- str_which(lines, "^\\\\begin\\{tabular\\}\\{l( c)+\\}")[1]
    stopifnot(!is.na(i))
    lines <- modify_at(lines, i, ~ paste0("\\begin{tabular}{l *{", k, "}{>{\\centering\\arraybackslash}p{", col_width, "}}}"))
  }
  # Tight caption, smaller font and rows
  lines <- tighten_table(lines)
  centering <- detect_index(lines, ~ .x == "\\centering")
  stopifnot(centering > 0)
  lines <- append(lines, c(paste0("\\", font_size),
                           paste0("\\renewcommand{\\arraystretch}{", arraystretch, "}")),
                  after = centering)

  has_var <- function(v) map_lgl(models, ~ v %in% all.vars(stats::formula(.x))) # variable in the model formula?
  create_check_row <- function(name, x) { # one row: checkmark where x is TRUE
    paste0(name, " & ", paste(if_else(x, "\\checkmark", "-"), collapse = " & "), " \\\\")
  }
  gof_midrule <- max(str_which(lines, fixed("\\midrule"))) # last midrule: start of the fit statistics
  lines <- append(lines, # fixed-effects rows
                  c(create_check_row("Date Fixed Effects", has_var("lead_time")),
                    create_check_row("Party Fixed Effects", has_var("party")),
                    create_check_row("Clustered SE", seq_len(k) %in% cluster_idx)),
                  after = gof_midrule - 1)

  n_resp <- map_dbl(seq_len(k), function(j) { # number of respondents
    if (j %in% cluster_idx) {
      n_distinct(stats::expand.model.frame(models[[j]], ~ResponseId)$ResponseId) # long data: one row per respondent and party
    } else {
      stats::nobs(models[[j]]) # wide data: one row per respondent
    }
  })
  nobs_line <- str_which(lines, "^Num\\. obs\\.")
  stopifnot(length(nobs_line) == 1)
  lines <- append(lines, paste0("Num. respondents & ", paste0("$", n_resp, "$", collapse = " & "), " \\\\"),
                  after = nobs_line)

  note_line <- str_which(lines, fixed("NOTE_PLACEHOLDER"))
  stopifnot(length(note_line) == 1)
  lines <- modify_at(lines, note_line, ~ paste0("\\multicolumn{", k + 1, "}{l}{\\parbox{", note_width, "}{\\scriptsize{", note, "}}}")) # note wraps at note_width

  write_lines(lines, file)
  invisible(lines)
}

# Column labels, spanners and headers of Tables C.1, C.2, C.5, C.6
labels_models <- c("(1)", "(2a)", "(2b)", "(3a)", "(3b)", "(3c)", "(3d)", "(3e)")
groups_models <- c(H1 = 1, H2 = 2, H3 = 5)
header_models <- c(
  "Time", "MAE", "RMSE",
  "PTV Dummy",
  "\\makecell{PTV Dummy \\\\ (incl. Ties)}",
  "VI Dummy",
  "PID Dummy",
  "PTV Score"
)

note_models <- paste(
  "Note: * p < 0.05, ** p < 0.01, *** p < 0.001.",
  "Different linear regression models have been estimated. All include survey date fixed effects.",
  "The first \\textit{Time} model (1) has response latency (log(s)) as the dependent variable to test H1.",
  "Models (2a) and (2b) are concerned with overall accuracy, measured as \\textit{MAE} and, as a robustness check, \\textit{RMSE}, to test H2.",
  "For H3, the dependent variable is the forecast error (difference between respondents' expected vote share for a party and the actual result).",
  "Models include party fixed effects and standard errors are clustered by respondent.",
  "In Model (3a), the \\textit{preferred party} is the party to which respondents assign the highest PTV; respondents who give the highest PTV to more than one party are not included.",
  "As robustness checks, the preferred party is operationalized as the party with the highest PTV including ties (Model (3b)),",
  "the party respondents intend to vote for (Model (3c)) or the party respondents identify with (Model (3d)).",
  "Model (3e) assesses degrees of party preference through the propensity to vote (measure from 1 to 11).",
  "For Models (3a)--(3e), \\textit{Num. obs.} counts respondent $\\times$ party observations and \\textit{Num. respondents} the respondents."
)

# Coefficient labels of the regression tables
# Federal: Tables C.1, C.5
# Saxony: Tables C.2, C.6, C.7
coef_map_federal <- list(
  "(Intercept)"              = "Intercept",
  "treatmentTreatment (5)"   = "T(5) (ref: C)",
  "treatmentTreatment (500)" = "T(500)",
  "baseline_speed"           = "Baseline Speed",
  "duration"                 = "Survey Duration",
  "preferred_party_ptv_dummy"      = "Preferred Party",
  "preferred_party_ptv_dummy_ties" = "Preferred Party",
  "preferred_party_vi_dummy"       = "Preferred Party",
  "preferred_party_pid_dummy"      = "Preferred Party",
  "treatmentTreatment (5):preferred_party_ptv_dummy"        = "T(5) x Preferred Party",
  "treatmentTreatment (500):preferred_party_ptv_dummy"      = "T(500) x Preferred Party",
  "treatmentTreatment (5):preferred_party_ptv_dummy_ties"   = "T(5) x Preferred Party",
  "treatmentTreatment (500):preferred_party_ptv_dummy_ties" = "T(500) x Preferred Party",
  "treatmentTreatment (5):preferred_party_vi_dummy"         = "T(5) x Preferred Party",
  "treatmentTreatment (500):preferred_party_vi_dummy"       = "T(500) x Preferred Party",
  "treatmentTreatment (5):preferred_party_pid_dummy"        = "T(5) x Preferred Party",
  "treatmentTreatment (500):preferred_party_pid_dummy"      = "T(500) x Preferred Party",
  "ptv_score"                          = "PTV Score",
  "treatmentTreatment (5):ptv_score"   = "T(5) x PTV Score",
  "treatmentTreatment (500):ptv_score" = "T(500) x PTV Score"
)

coef_map_saxony <- list(
  "(Intercept)"              = "Intercept",
  "treatmentTreatment (500)" = "T(500) (ref: C)",
  "baseline_speed"           = "Baseline Speed",
  "duration"                 = "Survey Duration",
  "preferred_party_ptv_dummy"      = "Preferred Party",
  "preferred_party_vi_dummy"       = "Preferred Party",
  "preferred_party_pid_dummy"      = "Preferred Party",
  "preferred_party_ptv_dummy_ties" = "Preferred Party",
  "treatmentTreatment (500):preferred_party_ptv_dummy"      = "T(500) x Preferred Party",
  "treatmentTreatment (500):preferred_party_vi_dummy"       = "T(500) x Preferred Party",
  "treatmentTreatment (500):preferred_party_pid_dummy"      = "T(500) x Preferred Party",
  "treatmentTreatment (500):preferred_party_ptv_dummy_ties" = "T(500) x Preferred Party",
  "ptv_score"                          = "PTV Score",
  "treatmentTreatment (500):ptv_score" = "T(500) x PTV Score"
)


## Logit Tables (Tables C.3, C.4) ----------------------------------------------

# Logit of being excluded (Tables C.3, C.4)
# Coefficients not in coef_map are left out
# fe: variables shown as one fixed-effects row instead
write_logit_table <- function(model, coef_map, caption, label, note, file,
                              fe = NULL, font_size = "footnotesize",
                              arraystretch = 0.9, note_width = "10cm") {
  # texreg table with one model column, without AIC, BIC and deviance
  lines <- str_split_1(str_remove(as.character(texreg::texreg(
    model,
    stars              = c(0.05, 0.01, 0.001),
    custom.model.names = "Excluded",
    custom.coef.map    = coef_map,
    custom.note        = "NOTE_PLACEHOLDER", # replaced by the wrapped note below
    include.aic        = FALSE,
    include.bic        = FALSE,
    include.deviance   = FALSE,
    caption            = caption,
    caption.above      = TRUE,
    label              = label,
    booktabs           = TRUE,
    float.pos          = "t",
    use.packages       = FALSE
  )), "\n$"), fixed("\n")) # no empty last line
  # Layout: tight caption, smaller font and rows
  lines <- tighten_table(lines)
  centering <- detect_index(lines, ~ .x == "\\centering")
  stopifnot(centering > 0)
  lines <- append(lines, c(paste0("\\", font_size),
                           paste0("\\renewcommand{\\arraystretch}{", arraystretch, "}")),
                  after = centering)
  if (!is.null(fe)) { # one row per fixed effect: checkmark if it is in the model
    vars <- all.vars(stats::formula(model))
    fe_rows <- paste0(names(fe), " & ", if_else(fe %in% vars, "\\checkmark", "-"), " \\\\")
    gof_midrule <- max(str_which(lines, fixed("\\midrule"))) # last midrule: start of the fit statistics
    lines <- append(lines, fe_rows, after = gof_midrule - 1)
  }
  note_line <- str_which(lines, fixed("NOTE_PLACEHOLDER"))
  stopifnot(length(note_line) == 1)
  lines <- modify_at(lines, note_line, ~ paste0("\\multicolumn{2}{l}{\\parbox{", note_width, "}{\\scriptsize{", note, "}}}")) # note wraps at note_width
  write_lines(lines, file)
  invisible(lines)
}


# Recoding ---------------------------------------------------------------------

# Party names from the survey and the official results to English
# Federal: CDU and CSU combined
recode_party_names_federal <- function(x) {
  dplyr::case_when(
    x == "Die Linke"                            ~ "Left",
    x == "GRÜNE" | x == "B'90/Die Grünen"       ~ "Greens",
    x == "Sonstige" | x == "Eine andere Partei" ~ "Others",
    x %in% c("CDU", "CSU")                      ~ "CDU/CSU",
    TRUE ~ x # other parties keep their name
  )
}

# Saxony: CDU only
recode_party_names_saxony <- function(x) {
  dplyr::case_when(
    x == "DIE LINKE"          ~ "Left",
    x == "GRÜNE"              ~ "Greens",
    x == "B'90/Die Grünen"    ~ "Greens",
    x == "FREIE WÄHLER"       ~ "Free Voters",
    x == "Sonstige"           ~ "Others",
    x == "Eine andere Partei" ~ "Others",
    x %in% c("CDU", "CSU")    ~ "CDU",
    TRUE ~ x # other parties keep their name
  )
}

# Experimental groups to short labels (C, T(5), T(500))
recode_groups_federal <- function(x) {
  dplyr::recode(x,
    "Control"          = "C",
    "Treatment (5)"    = "T(5)",
    "Treatment (500)"  = "T(500)"
  )
}

# The same as a factor in plot order
factor_groups_federal <- function(x) {
  factor(recode_groups_federal(x), levels = c("C", "T(5)", "T(500)"))
}

recode_groups_saxony <- function(x) {
  dplyr::recode(x,
    "Control"         = "C",
    "Treatment (500)" = "T(500)"
  )
}

# Difference labels of marginaleffects to short labels, e.g. "Treatment (500) - Control" -> "T(500) - C"
recode_diff_short <- function(x) {
  x %>%
    str_remove_all("treatment \\[|\\]") %>% # drop "treatment [...]" around the difference
    str_replace_all(fixed("Treatment (500)"), "T(500)") %>% # 500 before 5
    str_replace_all(fixed("Treatment (5)"), "T(5)") %>%
    str_replace_all(fixed("Control"), "C")
}

# Political interest from German answer labels to English
recode_pol_interest <- function(x, levels_de) {
  factor(x, levels = levels_de,
         labels = c("Very strongly", "Strongly", "Moderately", "Not very", "Not at all"))
}

# Labels of the preference dummy (0, 1)
pref_label <- c("Other", "Preferred")


# Parties and Analysis Data ----------------------------------------------------

# Parties of the preference measures (PTV, vote intention, party ID)
parties_7_federal <- c("AfD", "BSW", "CDU/CSU", "FDP", "Greens", "Left", "SPD")
parties_8_saxony  <- c("AfD", "BSW", "CDU", "FDP", "Greens", "Left", "SPD", "Free Voters")


# Election-Specific Settings ---------------------------------------------------

# Colors, shapes, labels and axis settings of one election
get_election_style <- function(election) {
  if (!election %in% c("federal", "saxony")) stop("election must be \"federal\" or \"saxony\"")
  if (election == "federal") {
    # groups_* / diffs_*: experimental groups / their differences
    # party_levels_*: plot and table order
    list(groups_colors    = groups_colors_federal,    groups_shapes    = groups_shapes_federal,
         diffs_colors     = diffs_colors_federal,     diffs_fill       = diffs_fill_federal,
         diffs_shapes     = diffs_shapes_federal,     recode_groups    = recode_groups_federal,
         treatment_labels   = c("C", "T(5)", "T(500)"),
         recode_party       = recode_party_names_federal,
         treatment_groups   = c(control = "Control", t5 = "Treatment (5)", t500 = "Treatment (500)"),
         party_levels_vote_share = c("Others", "BSW", "Left", "FDP", "Greens", "AfD", "SPD", "CDU/CSU"),
         vote_share_x_limits = c(0, 55), vote_share_x_breaks = seq(0, 50, 10),
         party_levels_accuracy  = c("AfD", "BSW", "CDU/CSU", "FDP", "Greens", "Left", "SPD", "Others"))
  } else {
    list(groups_colors    = groups_colors_saxony,     groups_shapes    = groups_shapes_saxony,
         diffs_colors     = diffs_colors_saxony,      diffs_fill       = diffs_fill_saxony,
         diffs_shapes     = diffs_shapes_saxony,      recode_groups    = recode_groups_saxony,
         treatment_labels   = c("C", "T(500)"),
         recode_party       = recode_party_names_saxony,
         treatment_groups   = c(control = "Control", t500 = "Treatment (500)"),
         party_levels_vote_share = c("Others", "BSW", "Free Voters", "FDP", "SPD", "Greens", "Left", "AfD", "CDU"),
         vote_share_x_limits = c(0, 100), vote_share_x_breaks = seq(0, 100, 10),
         party_levels_accuracy  = c("AfD", "BSW", "CDU", "FDP", "Greens", "Left", "SPD", "Free Voters", "Others"))
  }
}


# Descriptives (22 / 32) -------------------------------------------------------

## Response Times: Baseline Speed and Outliers ---------------------------------

# Response times of the five filler items of the baseline speed
baseline_speed_vars <- c(
  "t_year_birth_Page_Submit",
  "t_list_vote_int_Page_Submit",
  "t_eligible_Page_Submit",
  "t_turnout_int_Page_Submit",
  "t_pol_interest_Page_Submit"
)

# Baseline speed: log of the mean response time of the filler items (vars)
# Times more than 2 SD from the item mean are set to NA before averaging
add_baseline_speed <- function(data, vars = baseline_speed_vars) {
  data %>%
    mutate(across( # clean_<item>: outliers set to NA
      all_of(vars),
      ~ if_else(. > mean(., na.rm = TRUE) + 2 * sd(., na.rm = TRUE) |
        . < mean(., na.rm = TRUE) - 2 * sd(., na.rm = TRUE),
      NA, .
      ),
      .names = "clean_{.col}"
    )) %>%
    mutate(baseline_speed = rowMeans(across(starts_with("clean_")), na.rm = TRUE) %>% log()) # mean over the remaining items
}

# Upper outlier cutoff of the response time: mean + 2 SD
compute_time_cutoff <- function(t) mean(t, na.rm = TRUE) + 2 * sd(t, na.rm = TRUE)


## Response Times (Figures B.1, B.2) -------------------------------------------

# Figure B.1: individual response times (jittered)
# Grayscale-safe: gray points kept, black points outliers
# Dashed line: mean, solid line: outlier cutoff (mean + 2 SD)
# data needs t_outlier
plot_time_outliers <- function(data, t_mean, cutoff) {
  ggplot(data, aes(x = "", y = t_list_votes_exp_Page_Submit)) +
    geom_jitter(aes(color = t_outlier, alpha = t_outlier), width = 0.2, size = 0.5) +
    geom_hline(yintercept = cutoff, linetype = "solid", color = "black", size = 0.5) +
    geom_hline(yintercept = t_mean, linetype = "dashed", color = "black", size = 0.5) +
    annotate("text",
      x = Inf, y = cutoff, # right-aligned at the panel edge, so the label is not cut off
      label = paste0("Outliers > ", round(cutoff, 0), "s"),
      color = "black", hjust = 1, vjust = -0.4, size = 3
    ) +
    annotate("text",
      x = Inf, y = t_mean,
      label = paste0("Mean: ", round(t_mean, 0), "s"),
      color = "black", hjust = 1, vjust = -0.4, size = 3
    ) +
    scale_color_manual(values = c("FALSE" = "gray60", "TRUE" = "black")) +
    scale_alpha_manual(values = c("FALSE" = 0.4, "TRUE" = 1)) + # outliers fully opaque
    scale_y_continuous(limits = c(0, 7500), expand = expansion(mult = c(0.015, 0.03))) + 
    labs(x = NULL, y = "Time in Seconds") +
    theme_minimal(base_size = 14) +
    theme(
      legend.position = "none",
      plot.title = element_text(face = "bold"),
      axis.text.x = element_blank(),
      axis.ticks.x = element_blank()
    )
}

# Figure B.2: histogram of the response times
# var: seconds or logged
# The federal y axis starts at 0 without padding
plot_time_hist <- function(data, var, x_label, election) {
  get_election_style(election) # checks the election name
  ggplot(data, aes(x = .data[[var]])) +
    geom_histogram(bins = 30, fill = viridis(5, option = "D")[4], alpha = 0.8, color = "gray30") +
    scale_y_continuous(expand = expansion(mult = c(0, 0.05))) + # bars start on the x-axis
    coord_cartesian(ylim = c(0, 6500)) +
    labs(x = x_label, y = "Frequency") +
    theme(
      legend.position  = "none",
      plot.title       = element_markdown(face = "bold", size = 20),
      plot.subtitle    = element_markdown(size = 17),
      plot.caption     = element_markdown(size = 14, margin = margin(t = 6)),
      axis.text.x      = element_text(size = 16, color = "black"),
      axis.text.y      = element_text(size = 16, color = "black"),
      axis.title.x     = element_text(size = 17, color = "black"),
      axis.title.y     = element_text(size = 17, color = "black"),
      axis.ticks.y     = element_blank(),
      axis.line.y      = element_blank(),
      axis.line.x      = element_line(color = "black", linewidth = 0.4),
      plot.margin      = margin(10, 10, 10, 10),
      panel.background = element_blank(),
      panel.grid.major.y = element_line(color = "gray85", linewidth = 0.4),
      panel.grid.major.x = element_blank(),
      panel.grid.minor   = element_blank()
    )
}


## Preferred Party (PTV, Vote Intention, Party Identification) -----------------

# PTVs in long format: one row per respondent and rated party (party, ptv)
# ptv_col_by_party: party -> PTV column, e.g. c("AfD" = "ptv_afd")
create_ptv_long_data <- function(data, ptv_col_by_party) {
  data %>%
    select(ResponseId, all_of(unname(ptv_col_by_party))) %>%
    distinct() %>% # long data: the same PTVs in every party row of a respondent
    pivot_longer(-ResponseId, names_to = "ptv_col", values_to = "ptv") %>%
    filter(!is.na(ptv)) %>%
    inner_join(enframe(ptv_col_by_party, name = "party", value = "ptv_col"), by = "ptv_col") %>% # column -> party name
    transmute(ResponseId, party, ptv = as.numeric(ptv))
}

# Party with the highest PTV per respondent (comma-separated if tied, in the order of ptv_col_by_party)
# Respondents without any PTV are dropped
add_ptv_top <- function(data, ptv_col_by_party) {
  ptv_top <- create_ptv_long_data(data, ptv_col_by_party) %>%
    group_by(ResponseId) %>%
    filter(ptv == max(ptv)) %>% # all parties with the highest PTV
    summarize(
      preferred_party       = str_c(party, collapse = ", "),
      preferred_party_score = first(ptv),
      .groups = "drop"
    )
  data %>%
    inner_join(ptv_top, by = "ResponseId") %>% # at least one PTV
    select(ResponseId, excluded, preferred_party, preferred_party_score)
}

# 1 if the row's party is the preferred party, 0 if not
# NA if there is no preferred party among `parties`
create_pref_dummy <- function(party, pref_name, parties) {
  if_else(is.na(pref_name) | !(pref_name %in% parties), NA_integer_, as.integer(party == pref_name))
}

# Long data of the H3 models: one row per respondent and party (without Others)
# Adds the PTV score and the preference dummies (PTV, PTV incl. ties, VI, PID)
# data: long data with the clear preferred party (preferred_party, NA if tied), vote intention (zs_int) and PID
# ptv_top: output of add_ptv_top() (preferred_party incl. tied parties, comma-separated)
create_pref_long_data <- function(data, ptv_top, ptv_col_by_party, parties) {
  # PTV score of the party in each row (NA for unrated parties)
  ptv_scores <- create_ptv_long_data(data, ptv_col_by_party) %>%
    rename(ptv_score = ptv)
  data %>%
    filter(party != "Others") %>%
    left_join(ptv_top %>% select(ResponseId, preferred_party_ptv_name_ties = preferred_party), # tied version
              by = "ResponseId") %>%
    left_join(ptv_scores, by = c("ResponseId", "party")) %>%
    rename(preferred_party_ptv_name = preferred_party, # parallel names for the three measures
           preferred_party_vi_name  = zs_int,
           preferred_party_pid_name = pid) %>%
    mutate( # 1 = this row's party is the preferred party
      preferred_party_ptv_dummy = if_else(is.na(ptv_score), NA_integer_, # unrated party: NA
                                          create_pref_dummy(party, preferred_party_ptv_name, parties)),
      preferred_party_ptv_dummy_ties = if_else(
        is.na(preferred_party_ptv_name_ties), NA_integer_,
        as.integer(str_detect(preferred_party_ptv_name_ties, fixed(party))) # party is among the tied top parties
      ),
      preferred_party_vi_dummy  = create_pref_dummy(party, preferred_party_vi_name, parties),
      preferred_party_pid_dummy = create_pref_dummy(party, preferred_party_pid_name, parties)
    ) %>%
    select(ResponseId, id_unique, excluded, party, list_votes_result, treatment, lead_time, # model variables only
           list_votes_exp, list_votes_exp_diff, starts_with("preferred_party_"), ptv_score)
}

# Model data of the H3 models, one data set per preference measure
# Complete cases of the measure, unused factor levels dropped
# ptvscore: every party row with a PTV score, also from respondents with a tied highest PTV
create_pref_model_data <- function(data) {
  finalize <- function(d) { # factors without unused levels (no empty fixed effects)
    d %>% mutate(lead_time = droplevels(factor(lead_time)),
                 party     = droplevels(factor(party)))
  }
  list(
    ptv      = data %>% filter(!is.na(preferred_party_ptv_dummy)) %>% finalize(),
    ptvties  = data %>% filter(!is.na(preferred_party_ptv_dummy_ties)) %>% finalize(),
    vi       = data %>% filter(!is.na(preferred_party_vi_dummy)) %>% finalize(),
    pid      = data %>% filter(!is.na(preferred_party_pid_dummy)) %>% finalize(),
    ptvscore = data %>% filter(!is.na(ptv_score)) %>% finalize()
  )
}

# One row per respondent: only the row of the preferred party (column var)
create_pref_party_data <- function(data, var, parties) {
  data %>%
    filter(!is.na(.data[[var]]), .data[[var]] %in% parties, party == .data[[var]]) %>% # preferred party among parties, its row only
    select(-starts_with("ptv_")) # PTV columns not needed
}


## Preference Measures (Figures B.3, B.4) --------------------------------------

# Agreement of the preference measures (PTV, VI, PID)
# Pairwise among the respondents with both measures, and among those with all three
# data: one row per respondent with the columns ptv, vi, pid (preferred party per measure)
compute_pref_agreement <- function(data, parties) {
  data <- data %>% mutate(has_ptv = ptv %in% parties, has_vi = vi %in% parties, has_pid = pid %in% parties) # preferred party on the measure
  bind_rows( # one row per pair: n respondents and % with the same party
    data %>% filter(has_ptv, has_vi)  %>% summarize(pair = "PTV and VI",  n = n(), pct_agree = 100 * mean(ptv == vi)),
    data %>% filter(has_ptv, has_pid) %>% summarize(pair = "PTV and PID", n = n(), pct_agree = 100 * mean(ptv == pid)),
    data %>% filter(has_vi, has_pid)  %>% summarize(pair = "VI and PID",  n = n(), pct_agree = 100 * mean(vi == pid)),
    data %>% filter(has_ptv, has_vi, has_pid) %>%
      summarize(pair = "All three", n = n(), pct_agree = 100 * mean(ptv == vi & vi == pid))
  )
}

# Figures B.3 / B.4: flow of the preferred party between the three measures
# data: one row per respondent with ptv, vi, pid (preferred party per measure)
# parties: in plot order
# Percentages per measure among the respondents with a value on it
plot_pref_flow <- function(data, parties) {
  data <- data %>%
    mutate(across(c(ptv, vi, pid), as.character)) %>%
    pivot_longer(cols = c(ptv, vi, pid), names_to = "axis", values_to = "party") %>% # one row per respondent and measure
    filter(!is.na(party), party %in% parties) %>%
    mutate(
      axis  = factor(axis, levels = c("pid", "ptv", "vi")),
      party = factor(party, levels = parties)
    ) %>%
    group_by(axis) %>%
    mutate(n_axis = n()) %>% # respondents with a value on the measure
    group_by(axis, party) %>%
    mutate(pct_label = paste0(party, " (", round(n() / n_axis * 100), "%)")) %>% # e.g. "SPD (14%)"
    ungroup()
  # One stratum per party and measure, flows follow each respondent between the measures
  ggplot(data, aes(x = axis, stratum = party, alluvium = ResponseId, fill = party, label = pct_label)) +
    scale_x_discrete(
      expand = c(.1, .1),
      labels = c("pid" = "Party ID", "ptv" = "PTV", "vi" = "Vote Intention")
    ) +
    geom_flow() +
    geom_stratum(alpha = .5) +
    geom_text(stat = "stratum", size = 2, color = "black") +
    scale_fill_manual(values = color_parties) +
    theme_basic(base_size = 11) +
    scale_y_continuous(expand = expansion(mult = 0)) +
    labs(x = NULL)
}


## Vote Share Expectations (Figure 1) ------------------------------------------

# Figure 1: distribution of the expected vote shares per party
# Solid black line: election result
# Dashed gray line: mean expectation, same width, drawn on top
plot_vote_share_dist <- function(data, election) {
  st <- get_election_style(election)
  data <- data %>% mutate(party = factor(st$recode_party(party), levels = st$party_levels_vote_share))

  # Per party: mean expectation (citizen forecast) and result
  cf <- data %>%
    group_by(party) %>%
    summarize(
      mean_forecast = mean(list_votes_exp, na.rm = TRUE),
      result        = first(list_votes_result),
      .groups = "drop"
    ) %>%
    mutate(across(c(mean_forecast, result), ~ round(.x, 1)))

  theme_figure <- theme_minimal() +
    theme(
      axis.line.y    = element_blank(),
      axis.ticks.y   = element_blank(),
      panel.grid.major.y = element_blank(), # would sit on the ridge baselines
      panel.grid.minor   = element_blank(), # vertical lines only at the breaks (every 10)
      axis.line.x    = element_line(),
      axis.text.x    = element_text(size = 16),
      axis.text.y    = element_text(size = 16),
      axis.title.x   = element_text(size = 17),
      axis.title.y   = element_text(size = 17),
      legend.position = "none",
      plot.margin    = margin(10, 30, 10, 10)
    )

  ggplot(data, aes(x = list_votes_exp, y = party, fill = party)) +
    geom_density_ridges(scale = 1, rel_min_height = 0.01, alpha = 0.7, size = 1) +
    geom_segment(
      data = cf,
      aes(x = result, xend = result,
          y = as.numeric(party), yend = as.numeric(party) + 0.95),
      inherit.aes = FALSE, color = "black", linetype = "solid", linewidth = 0.6
    ) +
    geom_segment(
      data = cf,
      aes(x = mean_forecast, xend = mean_forecast,
          y = as.numeric(party), yend = as.numeric(party) + 0.95),
      inherit.aes = FALSE, color = "gray50", linetype = "dashed", linewidth = 0.6
    ) +
    scale_x_continuous(limits = st$vote_share_x_limits, expand = c(0, 0), breaks = st$vote_share_x_breaks) +
    scale_y_discrete(limits = levels(data$party), expand = expansion(mult = 0, add = c(0, 0.6))) +
    scale_fill_manual(values = color_parties) +
    labs(x = "Expected Vote Share (in %)", y = "") +
    theme_figure
}


## Forecast Error for the Preferred Party (Figures B.5, B.6) -------------------

# Figures B.5 / B.6: forecast error for the preferred party
plot_pref_boxplot <- function(data) {
  ggplot(data, aes(x = reorder(party, list_votes_exp_diff, FUN = median),
                y = list_votes_exp_diff, fill = party)) +
    geom_boxplot() +
    scale_fill_manual(values = color_parties) +
    labs(x = "", y = "Forecast Error (in Percentage Points)") +
    theme_basic() +
    coord_flip()
}


# Analysis (23 / 33) -----------------------------------------------------------

## Predictions and First Differences -------------------------------------------

# newdata for avg_predictions() / avg_comparisons(): the sample of the model
# Only model variables (plus the cluster variable ResponseId)
# Unused factor levels dropped (especially relevant for the lead time)
# Predicted values use the observed-value approach:
#   every respondent is set to each treatment level,
#   all other variables stay at their observed values,
#   and the predictions are averaged over the sample
create_model_data <- function(model, data, extra = "ResponseId") {
  # Variables of the model formula that are columns of data
  # all.vars() returns variable names only, e.g. log(t) -> t
  vars <- intersect(names(data), all.vars(stats::formula(model)))
  data %>%
    drop_na(all_of(vars)) %>% # rows complete on these variables = the rows lm() used
    select(any_of(c(vars, extra))) %>% # model variables plus extra (ResponseId, needed for clustered standard errors)
    droplevels() # no empty factor levels, e.g. lead times that occur only in dropped rows
}

# Result of marginaleffects as a plain data frame
# Drops the "marginaleffects" attribute: it holds the model and its data (hundreds of MB),
# which would otherwise be saved with every plot of the results (see save_figure())
as_estimates <- function(x) {
  x <- as.data.frame(x)
  attr(x, "marginaleffects") <- NULL
  x
}

# Predicted values (pred) and pairwise treatment differences (diff) of one model
# by: moderators
# vcov: ~ResponseId for clustered standard errors
compute_treatment_effects <- function(model, data, by = NULL, vcov = TRUE) {
  # Estimation sample of the model (see create_model_data())
  nd <- create_model_data(model, data)
  list(
    # Predicted values per experimental group (observed-value approach):
    #   variables = "treatment": every respondent in nd is set to each treatment level in turn
    #   by: the predictions are averaged per treatment level (and per value of the moderators)
    #   vcov: TRUE = classical standard errors, ~ResponseId = clustered by respondent
    #   confidence intervals: delta method (marginaleffects default)
    pred = marginaleffects::avg_predictions(model, newdata = nd, variables = "treatment",
                                            by = c("treatment", by), vcov = vcov) %>%
      as_estimates(),
    # Differences between the groups (treatment effects):
    #   "pairwise": every pair of treatment levels, e.g. T(500) - C
    #   per respondent: prediction under one level minus prediction under the other
    #   by = TRUE: averaged over the whole sample, by = moderator: averaged per moderator value
    #   (by = FALSE would return one row per respondent)
    diff = marginaleffects::avg_comparisons(model, newdata = nd, variables = list(treatment = "pairwise"),
                                            by = if (is.null(by)) TRUE else by, vcov = vcov) %>%
      as_estimates() %>%
      rename_diff()
  )
}

# Difference column of marginaleffects ("contrast") as diff, with short labels
# e.g. "Treatment (500) - Control" -> "T(500) - C"
rename_diff <- function(data) {
  data %>%
    rename(diff = contrast) %>%
    mutate(diff = recode_diff_short(diff))
}

# Number of respondents and observations a model uses
# model: fitted with lm() on data
count_model_n <- function(model, data) {
  # Row names of the model frame = numbers of the rows of data that lm() used
  # (assumes data has the default row names 1, 2, ..., as when it was passed to lm())
  rows <- as.integer(rownames(stats::model.frame(model)))
  # Respondents: distinct IDs among these rows (long data has one row per respondent and party)
  # Observations: number of rows
  data %>%
    slice(rows) %>%
    summarize(respondents = n_distinct(ResponseId), observations = n())
}


## H1: Response Latency (Figures 2, C.1) ---------------------------------------

# Same axes for both elections
# One scale for the median, one for the mean
x_limits_time_median    <- c(40, 115)
x_breaks_time_median    <- seq(40, 110, by = 10)
x_limits_time_mean      <- c(40, 140)
x_breaks_time_mean      <- seq(40, 140, by = 10)
x_limits_time_fd_median <- c(0, 13)
x_breaks_time_fd_median <- seq(0, 12, by = 4)
x_limits_time_fd        <- c(0, 16)
x_breaks_time_fd        <- seq(0, 16, by = 4)

# Conditional medians or means and their first differences from a simloglm simulation
# stat: "median" or "mean"
# diffs: named list of scenario pairs, e.g. list("T(500) - C" = c(1, 3))
compute_time_effects <- function(sim, stat, diffs) {
  list(
    # Conditional median or mean response time per scenario (one scenario per experimental group)
    # simloglm simulates the coefficients of the log-time model and transforms back to seconds
    # point_estimate and quantiles (95% simulation interval) per scenario
    summary = simloglm::get_summary(sim, which_qoi = stat),
    # First differences: per simulation draw, the value of one scenario minus the other,
    # summarized as point estimate and 95% simulation interval
    diff    = map(diffs, function(s) { # one element per scenario pair, named by the difference
      if (is.null(s)) { # NULL: simloglm default, scenarios 1 and 2
        simloglm::get_first_difference(sim, which_qoi = stat)
      } else {
        simloglm::get_first_difference(sim, which_qoi = stat, which_scenarios = s)
      }
    })
  )
}

# Plot data from a simloglm summary
# stat: label, e.g. "Cond. Median"
# as.numeric(): some simloglm versions return point_estimate as a 1 x k matrix
create_time_pred_data <- function(sim_summary, stat, election) {
  # The scenarios of the simulation are in group order (C, T(5), T(500) / C, T(500))
  labels <- get_election_style(election)$treatment_labels
  estimate <- as.numeric(sim_summary$point_estimate) # one value per scenario
  stopifnot(length(estimate) == length(labels)) # one scenario per group
  tibble(
    Group    = factor(labels, levels = labels),
    Type     = stat,
    Estimate = estimate,
    Lower    = as.numeric(sim_summary$quantiles[1, ]), # quantiles: row 1 = lower bound,
    Upper    = as.numeric(sim_summary$quantiles[2, ])  #   row 2 = upper bound, one column per scenario
  )
}

# Plot data from a named list of simloglm::get_first_difference() results
# stat: label, e.g. "FD Median"
create_time_diff_data <- function(diff_list, stat) {
  tibble( # one row per difference
    Comparison = factor(names(diff_list), levels = names(diff_list)), # difference labels in list order
    Type       = stat,
    FD         = map_dbl(diff_list, ~ as.numeric(.x$fd)[1]), # point estimate, x$fd: simloglm's element name
    Lower      = map_dbl(diff_list, ~ as.numeric(.x$quantiles)[1]), # lower bound of the 95% interval
    Upper      = map_dbl(diff_list, ~ as.numeric(.x$quantiles)[2])  # upper bound
  )
}

# Conditional median / mean response latency by group
plot_time_pred <- function(pred, stat, election,
                           x_limits = x_limits_time_mean,
                           x_breaks = x_breaks_time_mean) {
  st <- get_election_style(election)
  dd <- pred %>%
    filter(Type == stat) %>%
    mutate(Group = factor(Group, levels = st$treatment_labels))
  if (min(dd$Lower) < x_limits[1] || max(dd$Upper) > x_limits[2]) { # fixed axis would cut an interval
    message("WARNING: ", stat, " runs from ", round(min(dd$Lower), 1),
            " to ", round(max(dd$Upper), 1), " s, outside the axis limits ",
            x_limits[1], "-", x_limits[2], ".")
  }
  ggplot(dd, aes(x = Group, y = Estimate, ymin = Lower, ymax = Upper,
                 color = Group, fill = Group, shape = Group)) +
    geom_hline(yintercept = x_breaks, color = "gray85", linewidth = 0.4) +
    geom_pointrange(size = 1, stroke = 1) +
    scale_color_manual(values = st$groups_colors, name = NULL) +
    scale_fill_manual(values  = st$groups_colors, name = NULL) +
    scale_shape_manual(values = st$groups_shapes, name = NULL) +
    scale_y_continuous( # y is the horizontal axis after coord_flip()
      limits = x_limits,
      breaks = x_breaks,
      labels = function(x) if_else(x %% 20 == 0, as.character(x), ""),
      expand = expansion(mult = 0.02)
    ) +
    labs(y = paste0(if (str_detect(stat, "Median")) "Median" else "Mean", # axis title from the stat label
                    " Response Latency\n(Seconds, with 95% CI)"), x = "") +
    theme_estimates() +
    coord_flip()
}

# First differences of the conditional median / mean
plot_time_diff <- function(diff, stat, names_vec, election,
                           x_limits = x_limits_time_fd,
                           x_breaks = x_breaks_time_fd) {
  st <- get_election_style(election)
  dd <- diff %>%
    filter(Type == stat) %>%
    mutate(Comparison = factor(Comparison, levels = names_vec)) # names_vec: plot order of the comparisons
  if (min(dd$Lower) < x_limits[1] || max(dd$Upper) > x_limits[2]) { # fixed axis would cut an interval
    message("WARNING: ", stat, " runs from ", round(min(dd$Lower), 1),
            " to ", round(max(dd$Upper), 1), " s, outside the axis limits ",
            x_limits[1], "-", x_limits[2], ".")
  }
  ggplot(dd, aes(x = Comparison, y = FD, ymin = Lower, ymax = Upper,
                 color = Comparison, fill = Comparison, shape = Comparison)) +
    geom_hline(yintercept = x_breaks, color = "gray85", linewidth = 0.4) +
    geom_pointrange(size = 1, stroke = 1) +
    geom_hline(yintercept = 0, linetype = "dashed", color = "black") +
    scale_color_manual(values = st$diffs_colors, name = NULL) +
    scale_fill_manual(values  = st$diffs_fill,   name = NULL) +
    scale_shape_manual(values = st$diffs_shapes, name = NULL) +
    scale_y_continuous(limits = x_limits, breaks = x_breaks, expand = expansion(mult = 0.02)) +
    labs(y = paste0("Difference in ", if (str_detect(stat, "Median")) "Median" else "Mean",
                    " Response Latency\n(Seconds, with 95% CI)"), x = "") +
    theme_estimates() +
    coord_flip()
}


## H2: Overall Accuracy (Figures 3, C.2, C.9, C.10) ----------------------------

# Figures 3 and C.2: predicted MAE / RMSE by group
plot_accuracy_pred <- function(pred, y_label, y_limits, y_breaks, election) {
  st <- get_election_style(election)
  pred <- pred %>% mutate(treatment = factor(st$recode_groups(as.character(treatment)), # short labels in group order
                                             levels = st$treatment_labels))
  ggplot(pred, aes(x = treatment, y = estimate, ymin = conf.low, ymax = conf.high,
                   color = treatment, fill = treatment, shape = treatment)) +
    geom_hline(yintercept = y_breaks, color = "gray85", linewidth = 0.4) +
    geom_pointrange(size = 1, stroke = 1) +
    scale_color_manual(values = st$groups_colors, name = NULL) +
    scale_fill_manual(values  = st$groups_colors, name = NULL) +
    scale_shape_manual(values = st$groups_shapes, name = NULL) +
    scale_y_continuous(limits = y_limits, breaks = y_breaks, expand = expansion(mult = 0.02)) +
    labs(y = y_label, x = "") +
    theme_estimates() +
    coord_flip()
}

# Figures 3 and C.2: differences between the groups, ordered by size
plot_accuracy_diff <- function(diff, y_label, y_limits, y_breaks, election) {
  st <- get_election_style(election)
  diff <- diff %>% mutate(diff = reorder(diff, -estimate))
  # As in the submitted figures: Saxony draws a thicker zero line below the points, federal a default one on top
  zero_line <- geom_hline(yintercept = 0, linetype = "dashed", color = "black",
                          linewidth = if (election == "saxony") 0.6 else 0.5)
  ggplot(diff, aes(x = diff, y = estimate, ymin = conf.low, ymax = conf.high,
                   color = diff, fill = diff, shape = diff)) +
    geom_hline(yintercept = y_breaks, color = "gray85", linewidth = 0.4) +
    (if (election == "saxony") zero_line) +
    geom_pointrange(size = 1, stroke = 1) +
    (if (election == "federal") zero_line) +
    scale_color_manual(values = st$diffs_colors, name = NULL) +
    scale_fill_manual(values  = st$diffs_fill,   name = NULL) +
    scale_shape_manual(values = st$diffs_shapes, name = NULL) +
    scale_y_continuous(limits = y_limits, breaks = y_breaks, expand = expansion(mult = 0.02)) +
    labs(y = y_label, x = "") +
    theme_estimates() +
    coord_flip()
}

# Figures C.9-C.12: estimates by a moderator (column var)
# estimates: predicted values (diff = FALSE) or differences between the groups (diff = TRUE)
# facet = TRUE: one panel per value of the preference dummy (H3)
# y_limits / y_breaks: NULL = pretty breaks over the confidence intervals
plot_by_moderator <- function(estimates, var, x_label, y_label, election, diff = FALSE,
                              y_limits = NULL, y_breaks = NULL, n_breaks = 5,
                              facet = FALSE, reverse_x = FALSE) {
  st <- get_election_style(election)
  group <- if (diff) "diff" else "treatment" # column for colors and shapes
  if (is.null(y_breaks)) { # breaks over all intervals, for differences also include 0
    y_breaks <- scales::pretty_breaks(n = n_breaks)(c(estimates$conf.low, estimates$conf.high, if (diff) 0))
  }
  p <- ggplot(estimates, aes(x = .data[[var]], y = estimate, ymin = conf.low, ymax = conf.high,
                             color = .data[[group]], fill = .data[[group]], shape = .data[[group]])) +
    geom_hline(yintercept = y_breaks, color = "gray85", linewidth = 0.4)
  if (diff) p <- p + geom_hline(yintercept = 0, linetype = "dashed", color = "black", linewidth = 0.6)
  p <- p +
    geom_pointrange(position = position_dodge(width = if (diff) 0.5 else 0.4), size = 0.9, stroke = 1) +
    scale_color_manual(values = if (diff) st$diffs_colors else st$groups_colors, name = NULL) +
    scale_fill_manual(values  = if (diff) st$diffs_fill   else st$groups_colors, name = NULL) +
    scale_shape_manual(values = if (diff) st$diffs_shapes else st$groups_shapes, name = NULL) +
    scale_y_continuous(limits = y_limits, breaks = y_breaks, expand = expansion(mult = 0.02))
  if (reverse_x) p <- p + scale_x_discrete(limits = rev)
  p <- p +
    labs(x = x_label, y = y_label) +
    theme_estimates(legend_position = "bottom")
  if (facet) p <- p + facet_wrap(~ preferred_party_ptv_dummy, ncol = 1) # Other above Preferred, shared axis
  p + coord_flip()
}


## H3: Wishful Thinking (Figures 4, 5, B.7, C.3-C.6, C.11, C.12) ---------------

# Figures 4 and B.7: one model per party, forecast error on "is this the preferred party"
# var: preference dummy
# Parties without both supporters and non-supporters are left out
# Party order: federal fixed, Saxony by the size of the difference
# Returns pred (supporters and non-supporters) and diff (difference) per party
fit_wt_by_party <- function(data, var, parties, election) {
  get_election_style(election) # checks the election name
  # Keep parties with both supporters (1) and non-supporters (0), otherwise there is no difference to estimate
  parties <- keep(parties, function(p) {
    data %>%
      filter(party == p) %>%
      summarize(n = n_distinct(.data[[var]], na.rm = TRUE)) %>%
      pull(n) == 2
  })
  # One data set per party: one row per respondent with the forecast error for that party
  # yes = the respondent prefers this party (supporter), no = prefers another party
  # character, so lm() treats it as a factor with "no" as the reference
  per_party <- map(parties, function(p) {
    data %>%
      filter(party == p) %>%
      mutate(preferred_party_dummy = if_else(.data[[var]] == 1L, "yes", "no"))
  })
  # One model per party: forecast error (expected - actual vote share) on the supporter dummy
  # No controls and no treatment: the descriptive gap between supporters and non-supporters
  fits <- map(per_party, ~ lm(list_votes_exp_diff ~ preferred_party_dummy, data = .x))
  # Differences per party: supporters - non-supporters ("yes - no"), classical standard errors
  # With only the dummy in the model, this equals the dummy's coefficient
  diff <- map2_dfr(fits, parties, function(m, p) {
    avg_comparisons(m, variables = list(preferred_party_dummy = "pairwise")) %>%
      as_estimates() %>%
      select(diff = contrast, estimate, conf.low, conf.high) %>% # marginaleffects calls the difference "contrast"
      mutate(party = p)
  }) %>%
    mutate(party = reorder(party, -estimate)) # factor levels by the size of the difference (Saxony order)
  party_levels <- if (election == "federal") {
    c("AfD", "BSW", "Left", "Greens", "SPD", "CDU/CSU", "FDP")
  } else {
    levels(diff$party)
  }
  # Predicted values per party: mean forecast error of supporters and of non-supporters
  # (with only the dummy in the model, these equal the two group means)
  pred <- map2_dfr(fits, parties, function(m, p) {
    marginaleffects::avg_predictions(m, by = "preferred_party_dummy") %>%
      as_estimates() %>%
      mutate(party = p)
  }) %>%
    mutate(
      preferred_party_dummy = forcats::fct_rev(factor(preferred_party_dummy, levels = c("yes", "no"))), # levels: no, yes
      party = factor(party, levels = party_levels)
    )
  list(pred = pred, diff = diff)
}

# Figure B.7a / B.7c: supporters (diamonds) vs. non-supporters (circles)
plot_wt_by_party_pred <- function(pred, election) {
  get_election_style(election) # checks the election name
  y_scale <- if (election == "federal") {
    scale_y_continuous(limits = c(-4, 8), breaks = seq(-4, 8, by = 2),
                       minor_breaks = seq(-4, 8, by = 1))
  } else {
    scale_y_continuous(breaks = scales::breaks_width(2))
  }
  ggplot(pred, aes(x = party, y = estimate, ymin = conf.low, ymax = conf.high)) +
    geom_pointrange(
      data = filter(pred, preferred_party_dummy == "no"),
      aes(color = party), shape = 21, fill = "white",
      position = position_dodge(width = 0), size = 1, stroke = 1
    ) +
    geom_hline(yintercept = 0, linetype = "dashed", color = "black") +
    geom_pointrange(
      data = filter(pred, preferred_party_dummy == "yes"),
      aes(color = party, fill = party), shape = 23,
      position = position_dodge(width = 0), size = 1, stroke = 1
    ) +
    scale_color_manual(values = color_parties, guide = "none") +
    scale_fill_manual(values = color_parties, guide = "none") +
    labs(x = "", y = "Average Predicted Forecast Error\n(with 95% CI)") +
    y_scale +
    theme_basic(grid = TRUE, legend_position = "right") +
    coord_flip()
}

# Figures 4 and B.7b / B.7d: difference supporters - non-supporters
plot_wt_by_party_diff <- function(diff, election,
                                  y_label = "Difference in Average Predicted Forecast\nError: Supporters − Non-Supporters\n(with 95% CI)") {
  get_election_style(election) # checks the election name
  y_breaks <- if (election == "federal") c(0, 2, 4, 6, 8) else scales::breaks_width(2)
  ggplot(diff, aes(x = party, color = party, fill = party,
                   y = estimate, ymin = conf.low, ymax = conf.high)) +
    geom_pointrange(position = position_dodge(width = 0.3), shape = 17,
                    size = 1, stroke = 1, fill = "black") +
    scale_color_manual(values = color_parties, guide = "none") +
    scale_fill_manual(values = color_parties, guide = "none") +
    geom_hline(yintercept = 0, linetype = "dashed", color = "black") +
    labs(x = " ", y = y_label) +
    scale_y_continuous(breaks = y_breaks) +
    theme_basic(grid = TRUE, legend_position = "right") +
    coord_flip()
}

# Figures 5 and C.3-C.5: predicted forecast error for the preferred and the other parties, by group
# var: preference dummy
plot_wishful_thinking_pred <- function(pred, var, election,
                                       y_limits = c(-2.5, 7),
                                       y_breaks = seq(-2, 7, by = 1)) {
  st <- get_election_style(election)
  pred <- pred %>% mutate(treatment = st$recode_groups(treatment)) # short group labels
  ggplot(
    pred,
    aes(
      x     = factor(.data[[var]], labels = pref_label), # 0 / 1 -> Other / Preferred
      y     = estimate,
      ymin  = conf.low,
      ymax  = conf.high,
      color = treatment,
      fill  = treatment,
      shape = treatment
    )
  ) +
    geom_hline(yintercept = y_breaks, color = "gray85", linewidth = 0.4) +
    geom_hline(yintercept = 0, linetype = "dashed", color = "black", linewidth = 0.6) +
    geom_pointrange(position = position_dodge(width = 0.5), size = 1, stroke = 0.4) +
    scale_color_manual(values = st$groups_colors, name = NULL) +
    scale_fill_manual(values  = st$groups_colors, name = NULL) +
    scale_shape_manual(values = st$groups_shapes, name = NULL) +
    scale_y_continuous(limits = y_limits, breaks = y_breaks, expand = expansion(mult = c(0.02, 0.08))) +
    labs(x = "", y = "Average Predicted Forecast Error\n(with 95% CI)") +
    coord_flip() +
    theme_estimates(legend_position = "bottom")
}

# The same for the differences between the groups
plot_wishful_thinking_diff <- function(diff, var, election,
                                       y_limits = c(-0.8, 0.4),
                                       y_breaks = seq(-0.8, 0.4, by = 0.2)) {
  st <- get_election_style(election)
  ggplot(
    diff,
    aes(
      x     = factor(.data[[var]], labels = pref_label),
      y     = estimate,
      ymin  = conf.low,
      ymax  = conf.high,
      color = diff,
      fill  = diff,
      shape = diff
    )
  ) +
    geom_hline(yintercept = y_breaks, color = "gray85", linewidth = 0.4) +
    geom_hline(yintercept = 0, linetype = "dashed", color = "black", linewidth = 0.6) +
    geom_pointrange(position = position_dodge(width = 0.5), size = 1, stroke = 0.4) +
    scale_color_manual(values = st$diffs_colors, name = NULL) +
    scale_fill_manual(values  = st$diffs_fill,   name = NULL) +
    scale_shape_manual(values = st$diffs_shapes, name = NULL) +
    scale_y_continuous(limits = y_limits, breaks = y_breaks, expand = expansion(mult = c(0.02, 0.08))) +
    labs(x = "", y = "Difference in Average Predicted Forecast Error\n(with 95% CI)") +
    coord_flip() +
    theme_estimates(legend_position = "bottom")
}

# Figure C.6: estimates by PTV score
# estimates: predicted forecast error (diff = FALSE) or differences between the groups (diff = TRUE)
plot_ptv_score <- function(estimates, election, diff = FALSE) {
  st <- get_election_style(election)
  if (diff) { # styles, axis and label for differences or predicted values
    group    <- "diff"
    colors   <- st$diffs_colors
    fills    <- st$diffs_colors
    shapes   <- st$diffs_shapes
    y_limits <- c(-1.4, 0.6)
    y_breaks <- round(seq(-1.4, 0.6, by = 0.4), 1)
    y_label <- "Difference in Average Predicted Forecast Error\n(with 95% CI)"
  } else {
    group    <- "treatment"
    colors   <- st$groups_colors
    fills    <- st$groups_colors
    shapes   <- st$groups_shapes
    y_limits <- c(-3, 6)
    y_breaks <- seq(-3, 6, by = 1)
    y_label <- "Average Predicted Forecast Error\n(with 95% CI)"
  }
  ggplot(estimates, aes(x = ptv_score, y = estimate, ymin = conf.low, ymax = conf.high,
                        color = .data[[group]], fill = .data[[group]], shape = .data[[group]])) +
    geom_hline(yintercept = y_breaks, color = "gray85", linewidth = if (diff && election == "federal") 0.6 else 0.4) +
    geom_hline(yintercept = 0, linetype = "dashed", color = "black", linewidth = 0.6) +
    geom_linerange(linewidth = 0.5, position = position_dodge(width = if (diff) 0.4 else 0.6)) +
    geom_point(size = 3, position = position_dodge(width = 0.6)) +
    scale_color_manual(values = colors, name = NULL) +
    scale_fill_manual(values  = fills,  name = NULL) +
    scale_shape_manual(values = shapes, name = NULL) +
    scale_x_continuous(limits = c(0.5, 11.5), breaks = 1:11, expand = expansion(mult = 0)) +
    scale_y_continuous(limits = y_limits, breaks = y_breaks, expand = expansion(mult = 0)) +
    labs(x = "Propensity to Vote (PTV)", y = y_label) +
    theme_estimates(legend_position = "bottom") +
    coord_flip()
}


## Robustness: Comparison of Samples (Figures C.7, C.8) ------------------------

# Rows of the respondents in ids
filter_ids <- function(data, ids) filter(data, ResponseId %in% ids)

# Treatment effects of one model in one sample, for the comparison of samples
# Figures C.7 (main sample vs. no exclusions) and C.8 (OAP vs. SM)
compute_sample_effects <- function(model,     # fitted lm()
                                   data,      # data the model was estimated on
                                   sample,    # label of the sample (e.g. "Main", "No excl.", "OAP", "SM")
                                   outcome,   # label of the figure panel (e.g. "H2: MAE")
                                   by = NULL, # moderator: NULL or the preference dummy for H3 (effects for the preferred and the other parties)
                                   by_labels = c("1" = "Preferred", "0" = "Other"), # panel names of the moderator values, other values are dropped
                                   vcov = TRUE) { # TRUE = classical, ~ResponseId = clustered by respondent
  # Adds the sample and outcome columns, so the results of several models can be stacked
  add_labels <- function(d) {
    d <- as_estimates(d) %>% mutate(sample = sample, outcome = outcome)
    if (is.null(by)) return(d)
    d %>% # H3: one panel per moderator value
      filter(as.character(.data[[by]]) %in% names(by_labels)) %>% # keep the labelled values only
      mutate(outcome = paste0(outcome, ": ", recode(as.character(.data[[by]]), !!!by_labels))) # e.g. "H3: ...: Preferred"
  }
  # Predicted values and differences between the groups, see compute_treatment_effects()
  effects <- compute_treatment_effects(model, data, by = by, vcov = vcov)
  map(effects, add_labels) # pred and diff
}

# The same for H1, from a simloglm simulation of the log-time model
# Same columns as compute_sample_effects()
compute_sample_effects_time <- function(sim,        # simloglm() result
                                        treatments, # group names in the scenario order of sim
                                        diff_list,  # named list of simloglm::get_first_difference() results (names = difference labels, e.g. "T(500) - C")
                                        sample,     # label of the sample, as above
                                        outcome) {  # label of the figure panel, as above
  # Conditional median response time per scenario (= experimental group), in seconds,
  # with the 95% simulation interval (see compute_time_effects())
  med <- simloglm::get_summary(sim, which_qoi = "median")
  list(
    # Predicted values: one row per group, columns named like the marginaleffects output
    pred = tibble(
      treatment = treatments, # scenario order of sim
      estimate  = as.numeric(med$point_estimate),
      conf.low  = as.numeric(med$quantiles[1, ]), # quantiles: row 1 = lower bound,
      conf.high = as.numeric(med$quantiles[2, ]), #   row 2 = upper bound, one column per scenario
      sample = sample, outcome = outcome
    ),
    # Differences of the medians: one row per difference, from the first differences of the simulation
    diff = tibble(
      diff      = names(diff_list),
      estimate  = unname(map_dbl(diff_list, ~ as.numeric(.x$fd)[1])), # x$fd: simloglm's element name
      conf.low  = unname(map_dbl(diff_list, ~ as.numeric(.x$quantiles)[1])),
      conf.high = unname(map_dbl(diff_list, ~ as.numeric(.x$quantiles)[2])),
      p.value   = NA_real_, # simloglm gives simulation intervals only
      sample = sample, outcome = outcome
    )
  )
}

# Figures C.7 and C.8: first differences of two samples side by side
# One box per hypothesis: H1 | H2 in the top row, both H3 panels below
plot_sample_diff <- function(diff, colors = sample_colors, shapes = sample_shapes,
                             fills = sample_fills) {
  plot_panel <- function(outcomes, ncol, x_title) {
    ggplot(droplevels(dplyr::filter(diff, outcome %in% outcomes)),
           aes(x = estimate, y = diff, xmin = conf.low, xmax = conf.high,
               color = sample, shape = sample, fill = sample)) +
      geom_vline(xintercept = 0, linetype = "dashed", color = "black", linewidth = 0.6) +
      geom_pointrange(orientation = "y", position = position_dodge(width = 0.5), size = 0.9, stroke = 1) +
      facet_wrap(~ outcome, ncol = ncol) +
      scale_color_manual(values = colors, name = NULL) +
      scale_shape_manual(values = shapes, name = NULL) +
      scale_fill_manual(values = fills, name = NULL) +
      scale_x_continuous(breaks = scales::pretty_breaks(n = 5),
                         labels = function(x) format(x, drop0trailing = TRUE, trim = TRUE),
                         expand = expansion(mult = 0.1)) +
      labs(x = x_title, y = "") +
      theme_estimates(legend_position = "bottom") +
      theme(panel.grid.major.x = element_line(color = "gray85", linewidth = 0.4),
            strip.text      = element_text(size = 14),
            plot.background = element_rect(color = "black", fill = NA, linewidth = 0.8))
  }
  h1 <- plot_panel(sample_outcome_levels[1], ncol = 1,
              x_title = "Difference in Median Response Latency\n(Seconds, with 95% CI)")
  h2 <- plot_panel(sample_outcome_levels[2], ncol = 1,
              x_title = "Difference in Average Predicted MAE\n(with 95% CI)")
  h3 <- plot_panel(sample_outcome_levels[3:4], ncol = 2,
              x_title = "Difference in Average Predicted Forecast Error (with 95% CI)")
  (h1 | h2) / h3 +
    plot_layout(guides = "collect") &
    theme(legend.position = "bottom")
}
