# perturbatr: analysis of high-throughput gene perturbation screens
#
# Copyright (C) 2018 Simon Dirmeier
#
# This file is part of perturbatr
#
# perturbatr is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# perturbatr is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with perturbatr. If not, see <http://www.gnu.org/licenses/>.


#' @include class_data.R
#' @include class_analysed.R


#' @title Plot perturbation data
#'
#' @description Creates a barplot of replicate and gene counts of a
#'  \code{PerturbationData} object.
#'
#' @method plot PerturbationData
#' @export
#'
#' @import tibble
#' @import ggplot2
#' @importFrom dplyr summarize
#' @importFrom dplyr group_by
#' @importFrom tidyr gather
#' @importFrom scales pretty_breaks
#' @importFrom rlang .data
#'
#' @param x  the object to plot
#' @param size  size of letters
#' @param ...  additional parameters
#'
#' @return  returns a plot object
#'
plot.PerturbationData <- function(x, size=10, ...)
{
  dat <- dataSet(x)
  dat <-
    dplyr::group_by(dat, .data$Condition) %>%
    dplyr::summarize("Replicates" = length(unique(.data$Replicate)),
                     "Genes"      = length(unique(.data$GeneSymbol))) %>%
    tidyr::gather("Type", "Count", .data$Replicates, .data$Genes) %>%
    dplyr::mutate("Count" = as.integer(.data$Count))

  pl <-
    ggplot2::ggplot(dat, ggplot2::aes(x = dat$Condition, y = dat$Count)) +
    ggplot2::geom_bar(ggplot2::aes(fill = dat$Condition), stat="identity") +
    ggplot2::scale_fill_grey(start=0.3) +
    ggplot2::scale_x_discrete("") +
    ggplot2::scale_y_continuous("Count", breaks=scales::pretty_breaks(5)) +
    ggplot2::facet_grid(Type ~ ., scales='free_y') +
    ggplot2::geom_text(ggplot2::aes(label = dat$Count, y = dat$Count),
                                    size = floor(size/3), vjust=0) +
    ggplot2::theme_minimal() +
    ggplot2::theme(strip.text      = ggplot2::element_text(size = size),
                   text            = ggplot2::element_text(size = size),
                   panel.grid.major= ggplot2::element_blank(),
                   panel.spacing.y = ggplot2::unit(2, "lines")) +
    ggplot2::guides(fill=FALSE)

  pl
}
