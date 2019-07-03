#' List directories excluding temporary, Rproj, and git removing internal
#' undesired files
#'
#' @param path (String) Valid path
#' @param pat (String) Pattern to match. Defaults to NULL.
#' @param full (Logical) Return full path? Defaults to FALSE.
#' @param named (Logical) Add names? Defaults to FALSE.
#'
#' @return A character vector containing the files in the specified directory
#' excluding any temporary unwanted files (i.e. "~$file.xlsx"), Rproj files, and git files.
#'
#' @importFrom purrr discard
#' @importFrom stringr str_detect fixed
#'
#' @export
#'
#' @examples
#' list_files(getwd())
#' @importFrom purrr discard
#' @importFrom stringr str_detect fixed
list_files <- function(path, pat = NULL, full = FALSE, named = FALSE){

  hold <- list.files(path, pattern = pat, full.names = full) %>%
    purrr::discard(stringr::str_detect(string = .,
                                       pattern = stringr::fixed("~$"))) %>%
    purrr::discard(stringr::str_detect(string = .,
                                       pattern = stringr::fixed(".Rproj"))) %>%
    purrr::discard(stringr::str_detect(string = .,
                                       pattern = stringr::fixed(".git")))

  if (named) names(hold) <- list.files(path, pattern = pat, full.names = FALSE)

  return(hold)

}

#' Backup Raw Data Files
#'
#' This function simply copies files from a "raw" data directory
#' (usually a client's folder on the network) into a project specific directory.
#' Data takes a long time to read from the network directly and it is also a good
#' practice to keep unmodified backup versions of raw data stored locally in the
#' project repo for reproducibility purposes.
#'
#' @param add_link a
#' @param raw_path b
#' @param proj_path c
#' @param link_name f
#' @param add_readme g
#'
#' @seealso \code{link[base]{files}} for important documentation regarding files.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' raw_path <- "H:/ATLRFI/Client_Folder/Raw_Data"
#' proj_path <- "data-raw/lossruns"
#'
#' backup_raw(network_root_path, project_path, add_link = TRUE)
#' }
#' @importFrom purrr pwalk
#' @importFrom R.utils createLink
copy_files <- function(raw_path, proj_path, add_link = TRUE,
                       link_name = "Raw_Data_Link", add_readme = TRUE) {

  if (right(raw_path, 1) != "/") raw_path <- paste0(raw_path, "/")
  if (right(proj_path, 1) != "/") proj_path <- paste0(proj_path, "/")

  if (!dir.exists(proj_path)) dir.create(proj_path, recursive = TRUE)

  from_files <- list_files(raw_path, full = TRUE, pat = pat, named = TRUE)
  to_files <- paste0(proj_path, names(from_files))

  args <- list(from = from_files, to = to_files)
  purrr::pwalk(args, file.copy, ...)

  if (add_link) {

    link <- paste0(proj_path, link_name, ".lnk")

    try({

      R.utils::createLink(link = link,
                          target = normalizePath(raw_path),
                          overwrite = TRUE,
                          methods = c("windows-shortcut"))

    }, silent = TRUE)
  }
}

# copy_files("//owg.ds.corp/data/Atlanta/Data3/ATLANTA/ATLRFI/FSRM/R Data Reporting/RAW DATA/Sedgwick", "data-raw/lossruns/sedgwick/")

# system2("Set-Shortcut", args = c("data/DataLink.lnk"
#
# Set-ShortCut  "C:\Path\To\Program.exe"
#
# path <- normalizePath(proj_path, winslash = "\\")
# pathname <- "data\\LinktoData.LNK"
# target <- normalizePath(raw_path, winslash = "\\")
#
# tryCatch({
#   # Will only work on Windows systems with support for VB scripting
#   createWindowsShortcut(pathname, target=target)
# }, error = function(ex) {
#   print(ex)
# })
#
# if (isFile(pathname)) {
#   cat("Created link file: ", pathname, "\n", sep="")
#
#   # Validate that it points to the correct target
#   dest <- filePath(pathname, expandLinks="any")
#   cat("Available target: ", dest, "\n", sep="")
#
#   res <- all.equal(tolower(dest), tolower(target))
#   if (!isTRUE(res)) {
#     msg <- sprintf("Link target does not match expected target: %s != %s", dest, target)
#     cat(msg, "\n")
#     warning(msg)
#   }
#
#   # Cleanup
#   file.remove(pathname)
# }
#
# createWindowsShortcut(path, target)
#
# pathname <- sprintf("%s.LNK", path_name)
#
# targetpath <-  gsub("/", "\\", raw_path, fixed = TRUE)
#
# for (kk in seq_along(targets)) {
#   cat("Link #", kk, "\n", sep="")
#
#   target <- targets[[kk]]
#   cat("Target: ", target, "\n", sep="")
#
#   # Name of *.lnk file
#   pathname <-
#
#   tryCatch({
#     # Will only work on Windows systems with support for VB scripting
#     createWindowsShortcut(pathname, target=target)
#   }, error = function(ex) {
#     print(ex)
#   })
#
#   # Was it created?
#   if (isFile(pathname)) {
#     cat("Created link file: ", pathname, "\n", sep="")
#
#     # Validate that it points to the correct target
#     dest <- filePath(pathname, expandLinks="any")
#     cat("Available target: ", dest, "\n", sep="")
#
#     res <- all.equal(tolower(dest), tolower(target))
#     if (!isTRUE(res)) {
#       msg <- sprintf("Link target does not match expected target: %s != %s", dest, target)
#       cat(msg, "\n")
#       warning(msg)
#     }
#
#     # Cleanup
#     file.remove(pathname)
#   }
# }
