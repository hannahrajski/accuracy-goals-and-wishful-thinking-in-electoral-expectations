# Accuracy Goals and Wishful Thinking in Electoral Expectations

Replication files for the paper *Accuracy Goals and Wishful Thinking in Electoral Expectations* published in Electoral Studies.

The paper analyzes two original survey experiments conducted before the 2025 German federal election
(more than 28,000 respondents) and the 2024 Saxon state election (more than 5,000 respondents).
Respondents were randomly offered a monetary reward for accurate vote share expectations.
The analyses test whether the incentive increases response times (H1), improves the accuracy of individual expectations (H2) and reduces wishful thinking toward the preferred party (H3).

## Repository Structure

```
code/
  00_run_all.R                      runs scripts 21-40 in order and knits each into an HTML report (code/*.html)
  01_create_replication_data.R      creates the survey data in data/input/survey/, including only relevant respondents and variables
  10_helpers.R                      packages, colors, themes and functions used by all scripts
  21_federal_data_preparation.Rmd   federal: official election results, recodes of the survey data, response times,
                                    expectations per party with forecast errors (long data), individual accuracy (MAE, RMSE)
  22_federal_descriptives.Rmd       federal: exclusion of satisficers, benchmarks and sample composition (Table B.3),
                                    baseline speed and response time outliers, preferred party (PTV, vote intention,
                                    party ID) and H3 model data, descriptive figures and tables (federal parts of Figures 1, B.1
                                    and B.2, Figures B.3 and B.5, Tables B.3 and B.5)
  23_federal_analysis.Rmd           federal: analyses H1-H3, robustness checks, regression tables and figures (federal parts of
                                    Figures 2-5, B.7, C.1-C.7 and C.9-C.12, Tables C.1, C.3 and C.5)
  31_saxony_data_preparation.Rmd    Saxony: as 21
  32_saxony_descriptives.Rmd        Saxony: as 22 (Saxon parts of Figures 1, B.1 and B.2, Figures B.4 and B.6, Tables B.4 and B.6)
  33_saxony_analysis.Rmd            Saxony: as 23, plus models by recruitment channel (Saxon parts of Figures 2-5, B.7,
                                    C.1-C.7 and C.9-C.12, Figure C.8, Tables C.2, C.4, C.6 and C.7)
  40_combine_figures.Rmd            figures with both elections (federal and Saxony), combined from the subfigures of 22, 23, 32, 33
data/
  confidential/      original survey data (not uploaded, read only by 01)
  input/survey/      survey data used in this paper (federal: survey_federal.rdata, Saxony: survey_saxony.rdata)
  input/results/     official final results of the 2025 federal and the 2024 Saxon state election
  input/benchmark/   electoral and census statistics for the sample composition tables
  processed/         data written by the scripts (created when the code is run),
                     figures/: plot objects of all subfigures (.rds), combined by 40
output/
  figures/           all figures of the paper (PDF)
  tables/            all tables of the paper produced by the code (LaTeX)
  session_info.txt   R and package versions of the last full run
```

## How to Run

1. Open `accuracy-goals-and-wishful-thinking-in-electoral-expectations.Rproj` in RStudio
   (all paths are relative to the project root).
2. Install `simloglm`, which is not on CRAN, in the version used for the paper (this needs the package `remotes`):
   ```r
   install.packages("remotes")
   remotes::install_github("mneunhoe/simloglm@8b32f4791c74ff6006ee2579a33947c9ee9eab64")
   ```
   All other packages are installed automatically by `code/10_helpers.R` on the first run.
3. Run
   ```r
   source("code/00_run_all.R")
   ```

It overwrites the figures and tables in `output/`,
writes the knitted reports to `code/` and
the R and package versions to `output/session_info.txt`.
The results were produced with R 4.6.1.

The scripts depend on each other: 21 → 22 → 23 and 31 → 32 → 33, and 40 needs 22, 23, 32 and 33. 
The data preparation scripts (21, 31) write `data/processed/data_federal.rdata` and `data_federal_long.rdata` (Saxony: `data_saxony*`).
The descriptives scripts (22, 32) save the analysis data sets to `data/processed/`, one file each
(e.g. `data_federal_main.rdata`, the sample after excluding satisficers; the full list is in the last chunk of 22 and 32),
which the analysis scripts (23, 33) load.
The figures with both elections are combined by 40 from the plot objects that 22, 23, 32 and 33 save to `data/processed/figures/`.
Numbers reported in the text are printed in the knitted reports next to the figure or table they belong to.

## Figures and Tables

Figures are in `output/figures/` (PDF), tables in `output/tables/` (LaTeX).
Figures with both elections are combined by 40 from the subfigures computed by 22 / 23 / 32 / 33.

| Paper | File | Script |
|---|---|---|
| Figure 1 | `figure_1_desc_voteshare_dist` | 22 / 32, 40 |
| Figure 2 | `figure_2_h1_median` | 23 / 33, 40 |
| Figure 3 | `figure_3_h2_mae` | 23 / 33, 40 |
| Figure 4 | `figure_4_h3_wt_byparty_fd` | 23 / 33, 40 |
| Figure 5 | `figure_5_h3_ptv` | 23 / 33, 40 |
| Tables B.3, B.4 | `table_B3/B4_balance_demographics` | 22 / 32 |
| Figures B.1, B.2 | `figure_B1_desc_time_dist`, `figure_B2_desc_time_hist` | 22 / 32, 40 |
| Tables B.5, B.6 | `table_B5/B6_accuracy` | 22 / 32 |
| Figures B.3, B.4 | `figure_B3/B4_desc_pref_comparison` | 22 / 32 |
| Figures B.5, B.6 | `figure_B5/B6_desc_pref_boxplot_ptv` | 22 / 32 |
| Figure B.7 | `figure_B7_h3_wt_byparty` | 23 / 33, 40 |
| Tables C.1, C.2 | `table_C1/C2_models` | 23 / 33 |
| Figures C.1-C.6 | `figure_C1*` (mean latency) to `figure_C6*` (PTV score) | 23 / 33, 40 |
| Tables C.3, C.4 | `table_C3/C4_exclusions_logit` | 23 / 33 |
| Tables C.5, C.6, Figure C.7 | `table_C5/C6_models_noexcl`, `figure_C7_h123_noexcl_fd` | 23 / 33, 40 |
| Table C.7, Figure C.8 | `table_C7_models_recruit_saxony`, `figure_C8_h123_recruit_fd_saxony` | 33 |
| Figures C.9-C.12 | `figure_C9*`-`figure_C12*` (heterogeneity by education and political interest) | 23 / 33, 40 |

## Data Sources

**Survey data** (`data/input/survey/`): two original online surveys, recruited through the online
access panel of Bilendi and, in Saxony, also through social media advertisements.
The files contain only the respondents and variables used in the analyses.
`code/01_create_replication_data.R` documents how the files were created from the original survey data, which are not uploaded.

| File | Content |
|---|---|
| `survey_federal.rdata` | federal election 2025, one row per respondent  |
| `survey_saxony.rdata` | Saxon state election 2024, one row per respondent |

**Official Election Results**

| Data | Source | Used in |
|---|---|---|
| 2025 federal election, final second-vote result (`results/btw25_second_votes_federal.csv`, copied from the website) | Federal Returning Officer: [Bundestag election 2025, results Germany](https://www.bundeswahlleiterin.de/en/bundestagswahlen/2025/ergebnisse/bund-99.html#zweitstimmen-prozente11) | 21 |
| 2024 Saxon state election, final list-vote result (`results/statistik-sachsen_LW24_endgErgebniss.xlsx`) | Statistisches Landesamt des Freistaates Sachsen: [Landtagswahl 2024, Informationen und Downloads](https://wahlen.sachsen.de/landtagswahlen-2024-informationen-und-downloads.html) ([file](https://wahlen.sachsen.de/download/Landtag/statistik-sachsen_LW24_endgErgebniss.xlsx)) | 31 |

**Benchmarks of the Sample Composition** (`data/input/benchmark/`)

| Data | Source | Used in |
|---|---|---|
| Eligible voters by gender, age and state, 2025 federal election (`btw25_rws_bw2.csv`) | Federal Returning Officer: [Representative electoral statistics](https://www.bundeswahlleiterin.de/bundestagswahlen/2025/ergebnisse/repraesentative-wahlstatistik.html) ([file](https://www.bundeswahlleiterin.de/dam/jcr/677acfc3-fc2b-4614-aaaf-aab9a1ad05ce/btw25_rws_bw2.csv)) | 22 |
| Population aged 15 and over by school-leaving qualification, Germany, 2025 (`12211-0100_de_2025.xlsx`) | Federal Statistical Office (Destatis), Mikrozensus: [GENESIS-Online table 12211-0100](https://genesis.destatis.de/datenbank/online/statistic/12211/table/12211-0100) | 22 |
| Eligible voters by gender and age, 2024 Saxon state election (`statistik-sachsen_bVII2-3_saechsischer-landtag-repraesentative-wahlstatistik.xlsx`) | Statistisches Landesamt des Freistaates Sachsen: [Representative electoral statistics](https://wahlen.sachsen.de/landtagswahlen-2024-repraesentative-wahlstatistik.html) ([file](https://wahlen.sachsen.de/download/Landtag/statistik-sachsen_bVII2-3_saechsischer-landtag-repraesentative-wahlstatistik.xlsx)) | 32 |
| Population aged 15 and over by school-leaving qualification, Saxony, 2024 (`12211-1100_de.xlsx`) | Federal Statistical Office (Destatis), Mikrozensus: [GENESIS-Online table 12211-1100, filtered to Saxony 2024](https://genesis.destatis.de/datenbank/online/statistic/12211/table/12211-1100/table-toolbar/search/a/c2NodWxhdXNiaWxkdW5nJTIwYnVuZGVzbGFuZA%3D%3D#filter=JTdCJTIyaGlkZUVtcHR5Q29scyUyMiUzQWZhbHNlJTJDJTIyaGlkZUVtcHR5Um93cyUyMiUzQWZhbHNlJTJDJTIyY2FwdGlvbiUyMiUzQSU1QiU3QiUyMnZhcmlhYmxlSWQlMjIlM0ElMjIxMjIxMSUyMiUyQyUyMmlkJTIyJTNBJTIyZmlsdGVyLjAlMjIlMkMlMjJ2YWx1ZXNJZHMlMjIlM0ElNUIlMjIxMjIxMSUyMiU1RCUyQyUyMmNoaWxkcmVuJTIyJTNBJTVCJTdCJTIydmFyaWFibGVJZCUyMiUzQSUyMkJFVjAzNyUyMiUyQyUyMmlkJTIyJTNBJTIyZmlsdGVyLjAuMCUyMiUyQyUyMnZhbHVlc0lkcyUyMiUzQSU1QiUyMlFNVSUyMiU1RCUyQyUyMmNoaWxkcmVuJTIyJTNBJTVCJTVEJTJDJTIyc2hvd0FzSW50ZXJsaW5lJTIyJTNBZmFsc2UlMkMlMjJpc0hpZGRlbiUyMiUzQWZhbHNlJTJDJTIyYmxvY2tDb2RlJTIyJTNBJTIyYzElMjIlMkMlMjJwb3NzaWJsZVBsYWNlcyUyMiUzQSU1QiU1RCU3RCU1RCUyQyUyMnNob3dBc0ludGVybGluZSUyMiUzQWZhbHNlJTJDJTIyaXNIaWRkZW4lMjIlM0FmYWxzZSUyQyUyMmJsb2NrQ29kZSUyMiUzQSUyMnMxJTIyJTJDJTIycG9zc2libGVQbGFjZXMlMjIlM0ElNUIlNUQlN0QlNUQlMkMlMjJyb3dIZWFkZXIlMjIlM0ElNUIlN0IlMjJ2YXJpYWJsZUlkJTIyJTNBJTIySkFIUiUyMiUyQyUyMmlkJTIyJTNBJTIycm93VGl0bGUuMCUyMiUyQyUyMnZhbHVlc0lkcyUyMiUzQSU1QiUyMjIwMjQlMjIlNUQlMkMlMjJjaGlsZHJlbiUyMiUzQSU1QiU3QiUyMnZhcmlhYmxlSWQlMjIlM0ElMjJETEFORCUyMiUyQyUyMmlkJTIyJTNBJTIycm93VGl0bGUuMC4wJTIyJTJDJTIydmFsdWVzSWRzJTIyJTNBJTVCJTIyMTQlMjIlNUQlMkMlMjJjaGlsZHJlbiUyMiUzQSU1QiU3QiUyMnZhcmlhYmxlSWQlMjIlM0ElMjJHRVMlMjIlMkMlMjJpZCUyMiUzQSUyMnJvd1RpdGxlLjAuMC4wJTIyJTJDJTIydmFsdWVzSWRzJTIyJTNBJTVCJTIyR0VTTSUyMiUyQyUyMkdFU1clMjIlMkMlMjIlMjVUT1RBTCUyNSUyMiU1RCUyQyUyMmNoaWxkcmVuJTIyJTNBJTVCJTdCJTIydmFyaWFibGVJZCUyMiUzQSUyMkFMVDA2NSUyMiUyQyUyMmlkJTIyJTNBJTIycm93VGl0bGUuMC4wLjAuMCUyMiUyQyUyMnZhbHVlc0lkcyUyMiUzQSU1QiUyMkFMVDAxNUIyNSUyMiUyQyUyMkFMVDAyNUIzNSUyMiUyQyUyMkFMVDAzNUI0NSUyMiUyQyUyMkFMVDA0NUI1NSUyMiUyQyUyMkFMVDA1NUI2NSUyMiUyQyUyMkFMVDA2NUI3NSUyMiUyQyUyMkFMVDA3NVVNJTIyJTJDJTIyJTI1VE9UQUwlMjUlMjIlNUQlMkMlMjJjaGlsZHJlbiUyMiUzQSU1QiU1RCUyQyUyMnNob3dBc0ludGVybGluZSUyMiUzQWZhbHNlJTJDJTIyc2hvd1ZhcmlhYmxlJTIyJTNBdHJ1ZSUyQyUyMnNob3dWYXJpYWJsZVZhbHVlJTIyJTNBJTVCJTIyTEFCRUwlMjIlNUQlMkMlMjJzb3J0JTIyJTNBJTIyQ29kZUFzYyUyMiUyQyUyMmlzSGlkZGVuJTIyJTNBZmFsc2UlMkMlMjJibG9ja0NvZGUlMjIlM0ElMjJ2NSUyMiUyQyUyMnBvc3NpYmxlUGxhY2VzJTIyJTNBJTVCJTdCJTIycHJldlBhcmVudCUyMiUzQSU3QiUyMmJsb2NrQ29kZSUyMiUzQSUyMnY0JTIyJTJDJTIyaWQlMjIlM0ElMjJyb3dUaXRsZS4wLjAuMCUyMiU3RCUyQyUyMm5ld1BhcmVudCUyMiUzQSU3QiUyMmJsb2NrQ29kZSUyMiUzQSUyMnYzJTIyJTJDJTIyaWQlMjIlM0ElMjJyb3dUaXRsZS4wLjAlMjIlN0QlMkMlMjJlbGVtZW50QWJvdmUlMjIlM0ElN0IlMjJibG9ja0NvZGUlMjIlM0ElMjJ2MyUyMiUyQyUyMmlkJTIyJTNBJTIycm93VGl0bGUuMC4wJTIyJTdEJTJDJTIyZWxlbWVudEJlbG93JTIyJTNBJTdCJTIyYmxvY2tDb2RlJTIyJTNBJTIydjQlMjIlMkMlMjJpZCUyMiUzQSUyMnJvd1RpdGxlLjAuMC4wJTIyJTdEJTJDJTIybmV3U2libGluZ0luZGV4JTIyJTNBMCUyQyUyMmhhc1RyYW5zcG9zZVBhcnQlMjIlM0FmYWxzZSU3RCUyQyU3QiUyMnByZXZQYXJlbnQlMjIlM0ElN0IlMjJibG9ja0NvZGUlMjIlM0ElMjJ2NCUyMiUyQyUyMmlkJTIyJTNBJTIycm93VGl0bGUuMC4wLjAlMjIlN0QlMkMlMjJlbGVtZW50QWJvdmUlMjIlM0FudWxsJTJDJTIyZWxlbWVudEJlbG93JTIyJTNBJTdCJTIyYmxvY2tDb2RlJTIyJTNBJTIydjIlMjIlMkMlMjJpZCUyMiUzQSUyMmNvbFRpdGxlLjAlMjIlN0QlMkMlMjJuZXdTaWJsaW5nSW5kZXglMjIlM0EwJTJDJTIyaGFzVHJhbnNwb3NlUGFydCUyMiUzQXRydWUlN0QlMkMlN0IlMjJwcmV2UGFyZW50JTIyJTNBJTdCJTIyYmxvY2tDb2RlJTIyJTNBJTIydjQlMjIlMkMlMjJpZCUyMiUzQSUyMnJvd1RpdGxlLjAuMC4wJTIyJTdEJTJDJTIybmV3UGFyZW50JTIyJTNBJTdCJTIyYmxvY2tDb2RlJTIyJTNBJTIydjIlMjIlMkMlMjJpZCUyMiUzQSUyMmNvbFRpdGxlLjAlMjIlN0QlMkMlMjJlbGVtZW50QWJvdmUlMjIlM0ElN0IlMjJibG9ja0NvZGUlMjIlM0ElMjJ2MiUyMiUyQyUyMmlkJTIyJTNBJTIyY29sVGl0bGUuMCUyMiU3RCUyQyUyMmVsZW1lbnRCZWxvdyUyMiUzQW51bGwlMkMlMjJuZXdTaWJsaW5nSW5kZXglMjIlM0EwJTJDJTIyaGFzVHJhbnNwb3NlUGFydCUyMiUzQXRydWUlN0QlNUQlN0QlNUQlMkMlMjJzaG93QXNJbnRlcmxpbmUlMjIlM0FmYWxzZSUyQyUyMnNob3dWYXJpYWJsZSUyMiUzQXRydWUlMkMlMjJzaG93VmFyaWFibGVWYWx1ZSUyMiUzQSU1QiUyMkxBQkVMJTIyJTVEJTJDJTIyc29ydCUyMiUzQSUyMkNvZGVBc2MlMjIlMkMlMjJpc0hpZGRlbiUyMiUzQWZhbHNlJTJDJTIyYmxvY2tDb2RlJTIyJTNBJTIydjQlMjIlMkMlMjJwb3NzaWJsZVBsYWNlcyUyMiUzQSU1QiU3QiUyMnByZXZQYXJlbnQlMjIlM0ElN0IlMjJibG9ja0NvZGUlMjIlM0ElMjJ2MyUyMiUyQyUyMmlkJTIyJTNBJTIycm93VGl0bGUuMC4wJTIyJTdEJTJDJTIybmV3UGFyZW50JTIyJTNBJTdCJTIyYmxvY2tDb2RlJTIyJTNBJTIydjUlMjIlMkMlMjJpZCUyMiUzQSUyMnJvd1RpdGxlLjAuMC4wLjAlMjIlN0QlMkMlMjJlbGVtZW50QWJvdmUlMjIlM0ElN0IlMjJibG9ja0NvZGUlMjIlM0ElMjJ2NSUyMiUyQyUyMmlkJTIyJTNBJTIycm93VGl0bGUuMC4wLjAuMCUyMiU3RCUyQyUyMmVsZW1lbnRCZWxvdyUyMiUzQW51bGwlMkMlMjJuZXdTaWJsaW5nSW5kZXglMjIlM0EwJTJDJTIyaGFzVHJhbnNwb3NlUGFydCUyMiUzQWZhbHNlJTdEJTJDJTdCJTIycHJldlBhcmVudCUyMiUzQSU3QiUyMmJsb2NrQ29kZSUyMiUzQSUyMnYzJTIyJTJDJTIyaWQlMjIlM0ElMjJyb3dUaXRsZS4wLjAlMjIlN0QlMkMlMjJlbGVtZW50QWJvdmUlMjIlM0FudWxsJTJDJTIyZWxlbWVudEJlbG93JTIyJTNBJTdCJTIyYmxvY2tDb2RlJTIyJTNBJTIydjIlMjIlMkMlMjJpZCUyMiUzQSUyMmNvbFRpdGxlLjAlMjIlN0QlMkMlMjJuZXdTaWJsaW5nSW5kZXglMjIlM0EwJTJDJTIyaGFzVHJhbnNwb3NlUGFydCUyMiUzQXRydWUlN0QlMkMlN0IlMjJwcmV2UGFyZW50JTIyJTNBJTdCJTIyYmxvY2tDb2RlJTIyJTNBJTIydjMlMjIlMkMlMjJpZCUyMiUzQSUyMnJvd1RpdGxlLjAuMCUyMiU3RCUyQyUyMm5ld1BhcmVudCUyMiUzQSU3QiUyMmJsb2NrQ29kZSUyMiUzQSUyMnYyJTIyJTJDJTIyaWQlMjIlM0ElMjJjb2xUaXRsZS4wJTIyJTdEJTJDJTIyZWxlbWVudEFib3ZlJTIyJTNBJTdCJTIyYmxvY2tDb2RlJTIyJTNBJTIydjIlMjIlMkMlMjJpZCUyMiUzQSUyMmNvbFRpdGxlLjAlMjIlN0QlMkMlMjJlbGVtZW50QmVsb3clMjIlM0FudWxsJTJDJTIybmV3U2libGluZ0luZGV4JTIyJTNBMCUyQyUyMmhhc1RyYW5zcG9zZVBhcnQlMjIlM0F0cnVlJTdEJTVEJTdEJTVEJTJDJTIyc2hvd0FzSW50ZXJsaW5lJTIyJTNBdHJ1ZSUyQyUyMnNob3dWYXJpYWJsZSUyMiUzQXRydWUlMkMlMjJzaG93VmFyaWFibGVWYWx1ZSUyMiUzQSU1QiUyMkxBQkVMJTIyJTVEJTJDJTIyaXNIaWRkZW4lMjIlM0FmYWxzZSUyQyUyMmJsb2NrQ29kZSUyMiUzQSUyMnYzJTIyJTJDJTIycG9zc2libGVQbGFjZXMlMjIlM0ElNUIlNUQlN0QlNUQlMkMlMjJzaG93QXNJbnRlcmxpbmUlMjIlM0F0cnVlJTJDJTIyc2hvd1ZhcmlhYmxlJTIyJTNBdHJ1ZSUyQyUyMnNob3dWYXJpYWJsZVZhbHVlJTIyJTNBJTVCJTIyTEFCRUwlMjIlNUQlMkMlMjJpc0hpZGRlbiUyMiUzQWZhbHNlJTJDJTIyYmxvY2tDb2RlJTIyJTNBJTIydjElMjIlMkMlMjJwb3NzaWJsZVBsYWNlcyUyMiUzQSU1QiU1RCU3RCU1RCUyQyUyMmNvbHVtbkhlYWRlciUyMiUzQSU1QiU3QiUyMnZhcmlhYmxlSWQlMjIlM0ElMjJCSUxBUzQlMjIlMkMlMjJpZCUyMiUzQSUyMmNvbFRpdGxlLjAlMjIlMkMlMjJ2YWx1ZXNJZHMlMjIlM0ElNUIlMjJCSUwtQUJTMDQlMjIlMkMlMjJCSUwtQUJTMDglMjIlMkMlMjJCSUwtQUJTMDklMjIlMkMlMjJCSUwtQUJTMDIlMjIlMkMlMjJCSUwtQUJTMDMlMjIlMkMlMjJCSUwtT0ElMjIlMkMlMjJCSUwtQUJTMTAlMjIlMkMlMjIlMjVUT1RBTCUyNSUyMiU1RCUyQyUyMmNoaWxkcmVuJTIyJTNBJTVCJTVEJTJDJTIyc2hvd0FzSW50ZXJsaW5lJTIyJTNBZmFsc2UlMkMlMjJzaG93VmFyaWFibGUlMjIlM0F0cnVlJTJDJTIyc2hvd1ZhcmlhYmxlVmFsdWUlMjIlM0ElNUIlMjJMQUJFTCUyMiU1RCUyQyUyMmlzSGlkZGVuJTIyJTNBZmFsc2UlMkMlMjJibG9ja0NvZGUlMjIlM0ElMjJ2MiUyMiUyQyUyMnBvc3NpYmxlUGxhY2VzJTIyJTNBJTVCJTVEJTdEJTVEJTJDJTIyZml4Rmlyc3RDb2x1bW5zJTIyJTNBZmFsc2UlN0Q=&sortByValue=default) | 32 |

Turnout benchmarks: 82.5% in the 2025 federal election ([Federal Returning Officer](https://www.bundeswahlleiterin.de/en/bundestagswahlen/2025/ergebnisse/bund-99.html)) and 74.4% in the 2024 Saxon state election (final result file above), typed into scripts 22 and 32.
## License

- **Code and its outputs** (`code/`, including the knitted reports, and the figures and tables in `output/`): [MIT License](LICENSE), © 2026 Hannah Rajski.
  The code was partially written with the assistance of Claude (Anthropic).
- **Survey data** (`data/input/survey/`):
  [CC BY 4.0](LICENSE-DATA), Team Zweitstimme.org (Hannah Rajski, Thomas Gschwend, Simon Munzert, Elias Koch, Lukas Stötzer, Cornelius Erfort).
  Please cite the paper when you use the data.
- **Official election results and statistics** (`data/input/results/`, `data/input/benchmark/`): not covered by these licenses;
  they remain under the terms of their providers listed under Data Sources above.
