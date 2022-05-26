# Packages ---------------------------------------------------------------

library(shiny)
library(shinyWidgets)
library(shinyFeedback)
# library(waiter)
# library(reactable)
library(shinyjs)

library(tidyverse)
library(readxl)

library(ggsci)
library(patchwork)
library(png)
library(grid)

library(ggchicklet)

# functions ---------------------------------------------------------------

plot_card <- function(card, pallete){

  color <- pallete[card$group]

  card |>
    ggplot() +
    ggchicklet:::geom_rrect(fill = color,
                            xmin = 0, xmax = 10,
                            ymin = 0, ymax = 15,
                            alpha = 0.5, radius = unit(.1, 'npc')) +
    geom_segment(aes(x = 0, xend = 10, y = 10, yend = 10)) +
    # annotation_custom(lak, xmin=7, xmax=9, ymin=12, ymax=14) +
    scale_x_continuous(limits = c(0, 10)) +
    scale_y_continuous(limits = c(0, 15)) +
    coord_fixed() +
    guides(fill = "none") +
    theme_void() +
    geom_text(aes(label = title), x = 5, y = 12, size = 8) +
    geom_text(aes(label = description), x = 5, y = 7) +
    geom_text(aes (label = name), x = 1.2, y = 14, size = 7)
}

# database ----------------------------------------------------------

cards <- read_excel("data/cards.xlsx") |>
  mutate(across(.cols = title:description,
                .fns = ~str_wrap(.x, width = 25)),
         narrative = NA)

colores <- ggsci::pal_igv(alpha = 0.6)(4)

# Variables generales ------------------

appname <- "Cartas de narración"
instruction <- read_file("data/instruction.html")
# lak <- rasterGrob(readPNG("data/lak.png"), interpolate = TRUE)
