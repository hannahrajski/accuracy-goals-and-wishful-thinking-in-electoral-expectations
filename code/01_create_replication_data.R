# Create data needed for analyses.

# The survey data (data/confidential/, not uploaded) are subsetted to only contain first-time respondents and the variables needed for the analyses. 
# The response times, exported separately by the survey software, are joined to the survey data.
# It writes two files to data/input/survey/, which are part of the replication files:
#
#   survey_federal.rdata   2025 federal survey, one row per respondent 
#   survey_saxony.rdata    2024 Saxony survey, one row per respondent
#
# The script is run once by the authors and is not part of 00_run_all.R, because the raw data are not public.

library(tidyverse)

root <- rprojroot::find_rstudio_root_file()
dir_raw <- file.path(root, "data/confidential")
dir_out <- file.path(root, "data/input/survey")


# New IDs ----------------------------------------------------------------------

# Replaces each original ID by a sequential ID with a prefix, e.g. "F00001".
# The new IDs keep the sort order of the original IDs.
make_id_lookup <- function(ids, prefix) {
  ids_sorted <- sort(unique(ids), method = "radix") # radix sort = C locale
  set_names(sprintf("%s%05d", prefix, seq_along(ids_sorted)), ids_sorted)
}


# Federal election 2025 --------------------------------------------------------

load(file.path(dir_raw, "voters.rdata"))          # voters: all interviews
load(file.path(dir_raw, "voters_w1_time.rdata"))  # voters_w1_time: response times, wave 1
load(file.path(dir_raw, "voters_w2_time.rdata"))  # voters_w2_time: response times, wave 2

voters <- voters %>%
  select(
    # IDs and interview
    ResponseId,           # interview ID (one per interview), links the survey to the response times
    id_unique,            # respondent ID (same for all interviews of a respondent)
    source,               # sample and wave: bilendi_w1, bilendi_w2 (online access panel), sm_w1-sm_w3 (social media)
    StartDate,            # start of the interview (date and time)
    EndDate,              # end of the interview (date and time)
    # Experiment
    group,                # experimental group: control, treatment_small (5 euros), treatment (500 euros)
    pledge_expectations,  # pledge not to consult outside sources before the expectation item (yes/no)
    # Demographics
    age,                  # age in years
    gender,               # gender (Männlich, Weiblich, Divers)
    education,            # highest school-leaving qualification
    bula,                 # federal state (Bundesland)
    # Political variables
    pol_interest,         # political interest (5 categories)
    turnout_int,          # turnout intention (1-10, or already voted by mail)
    list_vote_int,        # second-vote intention (party)
    ptv_cdu, ptv_spd, ptv_afd, ptv_gruene, ptv_fdp, ptv_linke, ptv_bsw, # propensity to vote for each party (1-11)
    pid,                  # party identification (asked in the re-interviews of wave 2 only, joined below)
    # Vote share expectations: expected second-vote share of each party in % (sliders 0-50)
    list_votes_exp_cdu,   # CDU/CSU
    list_votes_exp_spd,   # SPD
    list_votes_exp_afd,   # AfD
    list_votes_exp_gruene, # Greens
    list_votes_exp_fdp,   # FDP
    list_votes_exp_linke, # Left
    list_votes_exp_bsw,   # BSW
    list_votes_exp_other  # all other parties
  ) %>%
  arrange(id_unique, StartDate) %>%
  group_by(id_unique) %>%
  mutate(participation_count = row_number()) %>% # 1 = first participation
  ungroup()

# Bilendi respondents' first participation (no re-interviews), social media respondents were not treated.
survey_federal <- voters %>%
  filter(participation_count == 1 & source %in% c("bilendi_w1", "bilendi_w2"))

# Party identification was asked only in the re-interviews of wave 2.
# It is taken from a respondent's second participation and joined to the first participation.
# pid_date (date of the re-interview) is missing for respondents without a re-interview.
pid_federal <- voters %>%
  filter(participation_count == 2 & source == "bilendi_w2" & id_unique %in% survey_federal$id_unique) %>%
  transmute(id_unique, pid, pid_date = as.Date(StartDate))

survey_federal <- survey_federal %>%
  select(-pid, -participation_count) %>%
  left_join(pid_federal, by = "id_unique")

# Response times in seconds (page submit time of an item), joined by interview ID.
time_vars <- c(
  "t_list_votes_exp_Page_Submit", # vote share expectations (dependent variable of H1)
  # Filler items for the baseline speed (computed in 22 and 32):
  "t_year_birth_Page_Submit",     # birth year
  "t_list_vote_int_Page_Submit",  # vote intention
  "t_eligible_Page_Submit",       # eligibility
  "t_turnout_int_Page_Submit",    # turnout intention
  "t_pol_interest_Page_Submit"    # political interest
)

times_federal <- bind_rows(
  voters_w1_time %>% select(ResponseId, all_of(time_vars)),
  voters_w2_time %>% select(ResponseId, all_of(time_vars))
)

survey_federal <- survey_federal %>%
  left_join(times_federal, by = "ResponseId")

# Interview date and duration instead of the exact start and end times (time of day is not needed and could help identify respondents)
survey_federal <- survey_federal %>%
  mutate(
    interview_date = as.Date(StartDate),                                                   # date of the interview
    duration = as.numeric(difftime(EndDate, StartDate, units = "mins")),                   # interview duration in minutes
    lead_time = as.numeric(difftime(as.Date("2025-02-23"), as.Date(StartDate), units = "days")), # days before the election (23 February 2025)
    .after = source
  ) %>%
  select(-StartDate, -EndDate)

# New IDs: interview IDs "RF00001", respondent IDs "F00001"
ids_response_federal <- make_id_lookup(survey_federal$ResponseId, "RF")
ids_unique_federal <- make_id_lookup(survey_federal$id_unique, "F")

survey_federal <- survey_federal %>%
  mutate(
    ResponseId = unname(ids_response_federal[ResponseId]),
    id_unique = unname(ids_unique_federal[id_unique])
  )

save(survey_federal, file = file.path(dir_out, "survey_federal.rdata"))
rm(voters, voters_w1_time, voters_w2_time, pid_federal, times_federal)


# Saxon state election 2024 ----------------------------------------------------

load(file.path(dir_raw, "data_saxony_complete.rdata")) # data_saxony_complete: all interviews
load(file.path(dir_raw, "saxony_all_time.rdata"))      # saxony_all_time: response times

survey_saxony_all <- data_saxony_complete %>%
  select(
    # IDs and interview
    ResponseId,           # interview ID (one per interview), links the survey to the response times
    id_unique,            # respondent ID (same for all interviews of a respondent)
    source,               # sample and wave: bilendi_w1-bilendi_w4 (online access panel), sm_w1, sm_w2 (social media)
    StartDate,            # start of the interview (date and time)
    EndDate,              # end of the interview (date and time)
    # Experiment
    group,                # experimental group: control, treatment (500 euros)
    pledge_expectations,  # pledge not to consult outside sources before the expectation item (yes/no)
    # Demographics
    age,                  # age in years
    gender,               # gender (Männlich, Weiblich, Divers)
    education,            # highest school-leaving qualification
    # Political variables
    pol_interest,         # political interest (5 categories)
    turnout_int,          # turnout intention (5 categories, or already voted by mail)
    list_vote_int_major,  # list-vote intention (party, smaller parties as "Eine andere Partei")
    ptv_cdu, ptv_afd, ptv_linke, ptv_gruene, ptv_spd, ptv_fdp, ptv_fw, ptv_bsw, # propensity to vote for each party (1-11)
    pid,                  # party identification (joined below from all interviews of a respondent)
    pid_other,            # party identification, party named under "other party" (coded party names)
    # Vote share expectations: expected list-vote share of each party in % (sliders 0-100)
    list_votes_exp_cdu,   # CDU
    list_votes_exp_afd,   # AfD
    list_votes_exp_linke, # Left
    list_votes_exp_gruene, # Greens
    list_votes_exp_spd,   # SPD
    list_votes_exp_fdp,   # FDP
    list_votes_exp_fw,    # Free Voters
    list_votes_exp_bsw,   # BSW
    list_votes_exp_other  # all other parties
  ) %>%
  # For some interviews the treatment was not shown correctly. They are dropped, because their experimental condition is unclear.
  filter(!group %in% c("treatment not shown", "broken_control", "broken_treatment"))

# Sample: each respondent's first participation 
# then respondents whose first participation has no experimental group are dropped.
survey_saxony <- survey_saxony_all %>%
  arrange(id_unique, StartDate) %>%
  group_by(id_unique) %>%
  slice(1) %>%
  ungroup() %>%
  filter(group %in% c("control", "treatment")) %>%
  mutate(group = fct_drop(group))

# Party identification: the non-missing value of any interview of a respondent, joined to the first participation.
pid_saxony <- survey_saxony_all %>%
  filter(!is.na(pid), id_unique %in% survey_saxony$id_unique) %>%
  distinct(id_unique, pid)

survey_saxony <- survey_saxony %>%
  select(-pid) %>%
  left_join(pid_saxony, by = "id_unique")

# Response times in seconds, as in the federal data (time_vars).
# Fix 2 typos (eiligible, list_vote_exp)
times_saxony <- saxony_all_time %>%
  rename(
    t_eligible_Page_Submit = t_eiligible_Page_Submit,
    t_list_votes_exp_Page_Submit = t_list_vote_exp_Page_Submit
  ) %>%
  select(ResponseId, all_of(time_vars))

survey_saxony <- survey_saxony %>%
  left_join(times_saxony, by = "ResponseId")

# Interview date and duration instead of the exact start and end times
survey_saxony <- survey_saxony %>%
  mutate(
    interview_date = as.Date(StartDate),                                                   # date of the interview
    duration = as.numeric(difftime(EndDate, StartDate, units = "mins")),                   # interview duration in minutes
    lead_time = as.numeric(difftime(as.Date("2024-09-01"), as.Date(StartDate), units = "days")), # days before the election (1 September 2024)
    .after = source
  ) %>%
  select(-StartDate, -EndDate)

# New IDs: interview IDs "RS00001", respondent IDs "S00001"
ids_response_saxony <- make_id_lookup(survey_saxony$ResponseId, "RS")
ids_unique_saxony <- make_id_lookup(survey_saxony$id_unique, "S")

survey_saxony <- survey_saxony %>%
  mutate(
    ResponseId = unname(ids_response_saxony[ResponseId]),
    id_unique = unname(ids_unique_saxony[id_unique])
  )

save(survey_saxony, file = file.path(dir_out, "survey_saxony.rdata"))
rm(data_saxony_complete, saxony_all_time, survey_saxony_all, pid_saxony, times_saxony)
