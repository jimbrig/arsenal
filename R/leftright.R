#' Left Right
#'
#' R functions mirroring Excel's left() and right() functions.
#'
#' @param string Character string to pull from.
#' @param num_chars Number of characters to pull.
#'
#' @name leftright
#'
#' @return Adjusted character string.
#'
#' @examples
#' left("leftright", 4)
#' right("leftright", 5)
NULL

#' @rdname leftright
#' @export
left <- function(string, num_chars) {
  substr(string, 1, num_chars)
}

#' @rdname leftright
#' @export
right <- function(string, num_chars) {
  substr(string, nchar(string) - (num_chars - 1), nchar(string))
}
