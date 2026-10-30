# Run all necessary scripts and replicate analyses, figures, and tables.

# 01_create_replication_data.R is not run here: it creates data/input/survey/ from the raw survey data, which are not uploaded.

root <- rprojroot::find_rstudio_root_file()

#   21 federal data preparation -> 22 federal descriptives -> 23 federal analysis
#   31 Saxony data preparation  -> 32 Saxony descriptives  -> 33 Saxony analysis
#   40 combined figures of both elections (needs 22, 23, 32, 33)


scripts <- c(
  "21_federal_data_preparation.Rmd",
  "22_federal_descriptives.Rmd",
  "23_federal_analysis.Rmd",
  "31_saxony_data_preparation.Rmd",
  "32_saxony_descriptives.Rmd",
  "33_saxony_analysis.Rmd",
  "40_combine_figures.Rmd"
)

# Figures and tables are written to output/figures/ and output/tables/, the knitted HTML reports next to the scripts in code/.
for (s in scripts) {
  rm(list = setdiff(ls(globalenv(), all.names = TRUE), c("root", "scripts", "s")), envir = globalenv()) # Each script is knitted into a cleared global environment.
  message("== ", s, " (start ", format(Sys.time(), "%H:%M"), ")")   # script name and start time
  t0 <- Sys.time()
  rmarkdown::render(file.path(root, "code", s), envir = globalenv(), quiet = TRUE) # knit the script in the global environment, HTML report next to the script in code/
  message("   done in ", round(as.numeric(difftime(Sys.time(), t0, units = "mins")), 1), " min")   # run time of the script in minutes
}

# Save R and package versions of the run
writeLines(capture.output(sessionInfo()), file.path(root, "output", "session_info.txt"))
message("All scripts rendered.")
