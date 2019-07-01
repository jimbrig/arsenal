#' Pipe operator
#'
#' See \code{magrittr::\link[magrittr]{\%>\%}} for details.
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
NULL

## quiets concerns of R CMD check re: the .'s that appear in pipelines
if (getRversion() >= "2.15.1")  utils::globalVariables(c("."))




#' #' Pull numbers from a string
#' #'
#' #' @param string String to pull numbers from
#' #'
#' #' @return String of numbers
#' #' @export
#' #'
#' #' @examples
#' pullNum <- function(string){
#'
#'   str_extract(string, "\\-*\\d+\\.*\\d*")
#'
#'
#' }
#'
#' #' Pull date from a string
#' #'
#' #' converts a string containing a date in several different formats to a date with format
#' #' string of the form "%yyyy-%mm-%dd
#' #'
#' #' @param string
#' #'
#' #' @return
#' #' @export
#' #'
#' #' @examples
#' #'
#' #' test1 <- "mysamepl/1-1-18.xlsx"
#' #'
#' #' pullDate(test1)
#' #'
#' pullDate <- function(string){
#'
#'   # pull date
#'   paste0(
#'     unlist(str_extract_all(string, "[0-9]{1,2}[-./][0-9]{1,2}[-./][0-9]{2,4}"), recursive = TRUE),
#'     collapse = ""
#'   ) %>%
#'     mdy() %>%
#'     as.character()
#'
#' }
#'
#' #' Pull Unique Values from a dataframe
#' #'
#' #' @param df Dataframe
#' #' @param var Quoted named of variable
#' #'
#' #' @return Character vector of unique, sorted values from specified column
#' #' @export
#' #'
#' #' @examples
#' pullUniq <- function(df, var){
#'   df[[var]] %>%
#'     unique() %>%
#'     sort()
#' }
#'
#' #' Coalesce Join
#' #'
#' #' @param x
#' #' @param y
#' #' @param by
#' #' @param suffix
#' #' @param join
#' #' @param ...
#' #'
#' #' @return
#' #' @export
#' #'
#' #' @examples
#' coalesceJoin <- function(x,
#'                          y,
#'                          by = NULL,
#'                          suffix = c(".x", ".y"),
#'                          join = dplyr::full_join,
#'                          ...) {
#'
#'   joined <- join(y, x, by = by, suffix = suffix, ...)
#'   # names of desired output
#'   cols <- union(names(x), names(y))
#'
#'   to_coalesce <- names(joined)[!names(joined) %in% cols]
#'   suffix_used <-
#'     suffix[ifelse(endsWith(to_coalesce, suffix[1]), 1, 2)]
#'   # remove suffixes and deduplicate
#'   to_coalesce <- unique(substr(to_coalesce,
#'                                1,
#'                                nchar(to_coalesce) - nchar(suffix_used)))
#'
#'   coalesced <- purrr::map_dfc(to_coalesce, ~ dplyr::coalesce(joined[[paste0(.x, suffix[1])]],
#'                                                              joined[[paste0(.x, suffix[2])]]))
#'   names(coalesced) <- to_coalesce
#'
#'   dplyr::bind_cols(joined, coalesced)[cols]
#' }
#'
#' #' three_evals
#' #'
#' #' returns the 3 eval dates that (current, 1 month prior, and 1 year prior) given
#' #' a single eval date
#' #'
#' #' @param eval_ the "current" eval
#' #'
#' #' @examples
#' #' eval_ <- as.Date("2018-12-30")
#' #' three_evals(eval_)
#' #'
#' #'
#' #' # even works for leap year
#' #' eval_ <- as.Date("2017-02-28")
#' #' three_evals(eval_)
#' #'
#' three_evals <- function(eval_) {
#'   eval_
#'
#'   # always get last day of month (even in leap year)
#'   eval_prior_month <- (eval_ %m-% months(1)) %>%
#'     ceiling_date(unit = "month")
#'
#'   eval_prior_month <- eval_prior_month - days(1)
#'
#'
#'   eval_prior_year <- (eval_ %m-% years(1)) %>%
#'     ceiling_date(unit = "month")
#'
#'   eval_prior_year <- eval_prior_year - days(1)
#'
#'
#'   c(
#'     "current" = eval_,
#'     "prior_month" = eval_prior_month,
#'     "prior_year" = eval_prior_year
#'   )
#' }
#'
#' #' deriveEvals
#' #'
#' #' @param eval_ <date> vector of eval dates
#' #'
#' #' @import lubridate
#' #'
#' #' @return a list of the form:
#' #' list(
#' #'   "current" = list(
#' #'     "date" = <date>: the eval dates passed to this function,
#' #'     "txt_s" = <chr>: for displaying the eval
#' #'     "txt_1" = <chr>: longer format for displaying the eval
#' #'   ),
#' #'   "prior" = list(
#' #'     "date" = <date>: the month prior eval dates to the evals passed to this function,
#' #'     "txt_s" = <chr>: for displaying the eval
#' #'     "txt_1" = <chr>: longer format for displaying the eval
#' #'   ),
#' #'   "year_prior" = list(
#' #'     "date" = <date>: the year prior eval dates to the evals passed to this function,
#' #'     "txt_s" = <chr>: for displaying the eval
#' #'     "txt_1" = <chr>: longer format for displaying the eval
#' #'   )
#' #' )
#' #'
#' #' @examples
#' #' out <- deriveEvals(as.Date("2018-09-30"))
#' deriveEvals <- function(eval_){
#'
#'   evals_out <- three_evals(eval_)
#'
#'   curr_eval <- evals_out["current"]
#'   pr_eval <- evals_out["prior_month"]
#'   yr_pr_eval <- evals_out["prior_year"]
#'
#'   list(
#'     current = list(
#'       date = curr_eval,
#'       txt_s = as.character(format(curr_eval, format = "%m/%d/%y")),
#'       txt_l = as.character(format(curr_eval, format = "%B %d, %Y"))
#'     ),
#'     prior = list(
#'       date = pr_eval,
#'       txt_s = as.character(format(pr_eval, format = "%m/%d/%y")),
#'       txt_l = as.character(format(pr_eval, format = "%B %d, %Y"))
#'     ),
#'     year_prior = list(
#'       date = yr_pr_eval,
#'       txt_s = as.character(format(yr_pr_eval, format = "%m/%d/%y")),
#'       txt_l = as.character(format(yr_pr_eval, format = "%B %d, %Y"))
#'     )
#'   )
#'
#' }
#'
#' #' by_occurrence
#' #'
#' #' show lodd_data by occurrence
#' #'
#' #' @param dat lodd_data by claim
#' #'
#' #' @examples
#' #'
#' #' dat <- readRDS("data/shiny-data.rds") %>%
#' #'   filter(
#' #'     eval_dt == as.Date("2018-12-31"),
#' #'     member == "Ace Endico Corporation"
#' #'   )
#' #' test <- by_occurrence(dat)
#' #'
#' by_occurrence <- function(dat) {
#'
#'   # create a temporary open/closed column for arranging
#'   dat_arranged <- dat %>%
#'     mutate(
#'       open_closed = substr(status, 1, 1),
#'       open_closed = ifelse(open_closed %in% c("O", "R"), 1, 2)) %>%
#'     arrange(open_closed, desc(last_dt)) %>%
#'     select(-open_closed)
#'
#'   dat_occ <- dat_arranged %>%
#'     group_by(eval_dt, occ_num) %>%
#'     summarise_at(vars(med_pd:subro), sum, na.rm = TRUE) %>%
#'     ungroup()
#'
#'   # just get 1 value for each value that should be static.  By getting only
#'   # one value we avoid the problem where an occurrence with 2 claims with different values for a
#'   # variable (e.g. status) will be counted twice
#'   static_vals <- dat_arranged %>%
#'     group_by(eval_dt, occ_num) %>%
#'     slice(1L) %>%
#'     ungroup() %>%
#'     select(-c(med_pd:subro), -clsd_dt, -last_dt, -reopen_dt, -rept_dt, -rept_lag)
#'
#'
#'   # adjust dates: for all dates EXCEPT report date want to take max of all claims
#'   # in occurrence. For Report date take minimum
#'   dates_data <- dat %>%
#'     select(occ_num, eval_dt, clsd_dt, last_dt, reopen_dt, rept_dt, rept_lag) %>%
#'     group_by(occ_num, eval_dt) %>%
#'     summarise(clsd_dt = if(all(is.na(clsd_dt))) NA else max(clsd_dt, na.rm = TRUE),
#'               last_dt = if(all(is.na(last_dt))) NA else max(last_dt, na.rm = TRUE),
#'               reopen_dt = if(all(is.na(reopen_dt))) NA else max(reopen_dt, na.rm = TRUE),
#'               rept_dt = if(all(is.na(rept_dt))) NA else min(rept_dt, na.rm = TRUE),
#'               rept_lag = if(all(is.na(rept_lag))) NA else min(as.numeric(rept_lag), na.rm = TRUE)) %>%
#'     ungroup()
#'
#'   dat_occ %>%
#'     left_join(static_vals, by = c("eval_dt", "occ_num")) %>%
#'     left_join(dates_data, by = c("eval_dt", "occ_num")) %>%
#'     # convert `clsd_dt` and `last_dt` to NA if the occurrence is open
#'     mutate(open_closed = substr(status, 1, 1)) %>%
#'     mutate_at(vars(clsd_dt, last_dt), list(~ifelse(open_closed %in% c("O", "R"), NA_character_, as.character(.)))) %>%
#'     mutate_at(vars(clsd_dt, last_dt), list(~ymd(.))) %>%
#'     select(-open_closed) %>%
#'     mutate(reopen_dt = openxlsx::convertToDate(reopen_dt, origin = "1970-01-01"),
#'            rept_dt = ymd(as.character(rept_dt)))
#'
#' }
#'
#' #' Collapse Rows
#' #'
#' #' for each group, sets the top row of the group to the group's value.  All other
#' #' rows in the group are set to "".  See the example
#' #'
#' #' @param df a data frame
#' #' @param variable group variable to be collapsed
#' #'
#' #' @return a data frame with an updated `variable` column
#' #'
#' #' @examples
#' #' dat <- tibble(
#' #'   group_name = c("a", "a", "b", "b"),
#' #'   x = 1:4
#' #' )
#' #'
#' #' collapseRows(dat, group_name)
#' #'
#' collapseRows <- function(df, variable){
#'
#'   group_var <- enquo(variable)
#'
#'   df %>%
#'     group_by(!! group_var) %>%
#'     mutate(groupRow = 1:n()) %>%
#'     ungroup() %>%
#'     mutate(!!quo_name(group_var) := ifelse(groupRow == 1, as.character(!! group_var), "")) %>%
#'     select(-c(groupRow))
#' }
#'
#'
#' #' deriveData
#' #'
#' #' @param data <tibble> of loss data for all members (TODO: should probably do filtering for member outside of this
#' #' function)
#' #' @param eval_ <date> vector of eval dates.  Passed to `deriveEvals()`.
#' #' @param member_ <chr> scalar. The name of the member
#' #' @param occurrence_ <logical> optional. defaults to FALSE
#' #' @param rm_incidents_ <logical> optional. defaults to FALSE
#' #'
#' #' @import dplyr
#' #'
#' #' @examples
#' #' data_ <- readRDS("shiny_data.rds")
#' #' eval_ <- as.Date("2018-12-31")
#' #' member_ <- "Ace Endico Corporation"
#' #' occurrence_ <- FALSE
#' #' rm_incidents_ <- FALSE
#' #'
#' #'
#' # deriveData <- function(data_,
#' #                        eval_,
#' #                        member_,
#' #                        occurrence_ = FALSE,
#' #                        rm_incidents_ = FALSE){
#' #
#' #   eval_lst <- deriveEvals(eval_)
#' #   curr_eval <- eval_lst$current$date
#' #   pr_eval <- eval_lst$prior$date
#' #   yr_pr_eval <- eval_lst$year_prior$date
#' #
#' #   member_data <- data_ %>%
#' #     dplyr::filter(
#' #       member == member_,
#' #       eval_dt %in% c(curr_eval, pr_eval, yr_pr_eval)
#' #     )
#' #
#' #   if(occurrence_ == TRUE){
#' #     member_data_occ <- member_data %>%
#' #       group_by(eval, occ_num, occ_status) %>%
#' #       summarise_at(vars(med_pd:subro),
#' #                    funs(sum(., na.rm = TRUE))) %>%
#' #       ungroup()
#' #
#' #     member_data <- left_join(member_data_occ,
#' #                              select(member_data, -med_pd:subro),
#' #                              by = c("eval", "occ_num", "occ_status"))
#' #   }
#' #
#' #   if(rm_incidents_ == TRUE){
#' #
#' #     member_data <- member_data %>%
#' #       filter(status != "I")
#' #
#' #   }
#' #
#' #   list(
#' #     current = dplyr::filter(member_data, eval_dt == curr_eval),
#' #     month_prior = dplyr::filter(member_data, eval_dt == pr_eval),
#' #     year_prior = dplyr::filter(member_data, eval_dt == yr_pr_eval)
#' #   )
#' # }

# dirCreate <- function(dir){
#   if(!dir.exists(dir)) dir.create(dir)
# }

# display_mutates <- function(df_) {
#   df_ %>%
#     mutate(
#       cov = case_when(
#         cov == "AL" ~ "Auto Liability",
#         cov == "APD" ~ "Auto Physical Damage",
#         cov == "GL" ~ "General Liability",
#         cov == "PR" ~ "Products Liability",
#         cov == "WC" ~ "Worker's Compensation"
#       ),
#       status = case_when(
#         status == "C" ~ "Closed",
#         status == "I" ~ "Incident",
#         status == "O" ~ "Open",
#         status == "R" ~ "Re-Opened"
#       )
#     )
# }

