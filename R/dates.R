#' Start / End of Month Functions
#'
#' @param date date
#'
#' @name dates
#'
#' @return start or end of month as a date
#'
#' @examples
#' start_of_month(Sys.Date())
#' end_of_month(Sys.Date())
NULL

#' @rdname dates
#' @export
start_of_month <- function(date){
  as.Date(format(date, "%Y-%m-01"))
}

#' @rdname dates
#' @importFrom lubridate ceiling_date
#' @export
end_of_month <- function(date){
  lubridate::ceiling_date(date, unit = "month") - 1
}
