# 測試用的小工具

# 一個 tag 轉成 HTML 字串
html <- function(x) as.character(htmltools::renderTags(x)$html)

# 假的 Shiny session：記下送出去的訊息（MockShinySession 的 sendCustomMessage 什麼都不做）
fake_session <- function(prefix = "mod") {
  e <- new.env()
  e$messages <- list()
  e$inputs <- list()
  e$flushed <- list()
  e$notes <- list()
  e$ns <- function(id) paste0(prefix, "-", id)
  e$sendCustomMessage <- function(type, message) {
    e$messages[[length(e$messages) + 1]] <- list(type = type, message = message)
  }
  e$sendInputMessage <- function(inputId, message) {
    e$inputs[[length(e$inputs) + 1]] <- list(id = inputId, message = message)
  }
  e$sendNotification <- function(type, message) {
    e$notes[[length(e$notes) + 1]] <- list(type = type, message = message)
  }
  e$onFlushed <- function(fun, once = TRUE) {
    e$flushed[[length(e$flushed) + 1]] <- fun
    invisible(function() NULL)
  }
  e$run_flushed <- function() {
    cbs <- e$flushed
    e$flushed <- list()
    for (f in cbs) f()
  }
  class(e) <- "ShinySession"
  e
}
