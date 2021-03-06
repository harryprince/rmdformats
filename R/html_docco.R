#' Convert to an HTML document
#'
#' Format for converting from R Markdown to an HTML document.
#'
#' @param fig_width Default width (in inches) for figures
#' @param fig_height Default width (in inches) for figures
#' @param fig_caption \code{TRUE} to render figures with captions
#' @param highlight Syntax highlighting style. Supported styles include
#'   "default", "tango", "pygments", "kate", "monochrome", "espresso",
#'   "zenburn", "haddock", and "textmate". Pass \code{NULL} to prevent syntax
#'   highlighting.
#' @param lightbox if TRUE, add lightbox effect to content images
#' @param thumbnails if TRUE display content images as thumbnails
#' @param gallery if TRUE and lightbox is TRUE, add a gallery navigation between images in lightbox display
#' @param pandoc_args arguments passed to the pandoc_args argument of rmarkdown \code{\link{html_document}}
#' @param ... Additional function arguments passed to rmarkdown \code{\link{html_document}}
#' @return R Markdown output format to pass to \code{\link{render}}
#' @import rmarkdown
#' @importFrom htmltools htmlDependency
#' @export

html_docco <- function(fig_width = 6,
                       fig_height = 6,
                       fig_caption = TRUE,
                       highlight = "pygments",
                       lightbox = TRUE,
                       thumbnails = TRUE,
                       gallery = FALSE,
                       pandoc_args = NULL,
                       ...) {
  
  ## js and css dependencies
  extra_dependencies <- list(html_dependency_jquery(),
                             html_dependency_bootstrap("bootstrap"),
                             html_dependency_magnific_popup(),
                             html_dependency_docco())
  
  ## Force mathjax arguments
  pandoc_args <- c(pandoc_args, 
                   "--mathjax", 
                   "--variable", paste0("mathjax-url:", default_mathjax()))
  if (lightbox) { pandoc_args <- c(pandoc_args, "--variable", "lightbox:true") }
  if (thumbnails) { pandoc_args <- c(pandoc_args, "--variable", "thumbnails:true") }  
  if (gallery) {
    pandoc_args <- c(pandoc_args, "--variable", "gallery:true")
  } else {
    pandoc_args <- c(pandoc_args, "--variable", "gallery:false")
  }
  
  
  rmarkdown::html_document(
    template = system.file("templates/html_docco/html_docco.html", package = "rmdformats"),
    extra_dependencies = extra_dependencies,
    fig_width = fig_width,
    fig_height = fig_height,
    fig_caption = fig_caption,
    highlight = highlight,
    pandoc_args = pandoc_args,
    ...
  )
  
}


# html_docco js and css
html_dependency_docco <- function() {
  htmltools::htmlDependency(name = "docco",
                 version = "0.1",
                 src = system.file("templates/html_docco", package = "rmdformats"),
                 script = "docco.js",
                 stylesheet = "docco.css")
}
