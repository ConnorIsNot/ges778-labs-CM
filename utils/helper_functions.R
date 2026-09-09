percent1 <- function(x) {
  paste0(formatC(round(x, digits = 2) * 100, format = "d"), "%")
}

dollar1 <- function(x) {
  paste0("$",formatC(round(x, digits = 0), format = "d", big.mark = ",", big.interval = 3))
}

comma1 <- function(x) {
  paste0(formatC(round(x, digits = 0), format = "d", big.mark = ",", big.interval = 3))
}
