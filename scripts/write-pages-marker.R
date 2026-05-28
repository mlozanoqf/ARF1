writeLines("", file.path("docs", ".nojekyll"), useBytes = TRUE)

html_files <- list.files("docs", pattern = "\\.html$", full.names = TRUE)

remove_home_sidebar_entry <- function(html) {
  sidebar_home_pattern <- paste0(
    '<li class="sidebar-item">\\s*',
    '<div class="sidebar-item-container">\\s*',
    '<a href="\\./index\\.html" class="sidebar-item-text sidebar-link(?: active)?">',
    '<span class="chapter-title">index\\.html</span></a>\\s*',
    '</div>\\s*</li>\\s*'
  )

  home_breadcrumb_pattern <- paste0(
    '<nav class="quarto-page-breadcrumbs" aria-label="breadcrumb">',
    '<ol class="breadcrumb"><li class="breadcrumb-item">',
    '<a href="\\./index\\.html"><span class="chapter-title">index\\.html</span></a>',
    '</li></ol></nav>\\s*'
  )

  previous_home_pattern <- paste0(
    '<div class="nav-page nav-page-previous">\\s*',
    '<a href="\\./index\\.html" class="pagination-link" aria-label="index\\.html">\\s*',
    '<i class="bi bi-arrow-left-short"></i>\\s*',
    '<span class="nav-page-text"><span class="chapter-title">index\\.html</span></span>\\s*',
    '</a>\\s*</div>'
  )

  html <- gsub(sidebar_home_pattern, "", html, perl = TRUE)
  html <- gsub(home_breadcrumb_pattern, "", html, perl = TRUE)
  gsub(previous_home_pattern, '<div class="nav-page nav-page-previous">\n  </div>', html, perl = TRUE)
}

for (html_file in html_files) {
  html <- paste(readLines(html_file, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
  cleaned_html <- remove_home_sidebar_entry(html)

  if (!identical(html, cleaned_html)) {
    writeLines(cleaned_html, html_file, useBytes = TRUE)
  }
}
