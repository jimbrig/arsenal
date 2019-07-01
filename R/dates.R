#' Start / End of Month Functions
#'
#' @param date Input date (can be character string or a date object)
#'
#' @name dates
#'
#' @return Date object containing the Start or End Date of the specified input date's month.
#'
#' @importFrom lubridate ceiling_date is.Date
#' @importFrom flipTime AsDate
#'
#' @examples
#' start_of_month(Sys.Date())
#' end_of_month(Sys.Date())
#'
#' start_of_month("2019-05-31")
#' end_of_month("January 15, 2001")
NULL

#' @rdname dates
#' @export
start_of_month <- function(date){

  if (!length(date)) return(date)

  if (!lubridate::is.Date(date)) date <- flipTime::AsDate(date)

  as.Date(format(date, "%Y-%m-01"))

}

#' @rdname dates
#' @export
end_of_month <- function(date){

  if (!length(date)) return(date)

  if (!lubridate::is.Date(date)) date <- flipTime::AsDate(date)

  lubridate::ceiling_date(date, unit = "month") - 1

}
