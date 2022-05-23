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

# library(ggchicklet)

# functions ---------------------------------------------------------------


# database ----------------------------------------------------------
cards <- read_excel("data/cards.xlsx") |>
  mutate(across(.cols = title:description,
                .fns = ~str_wrap(.x, width = 25)),
         narrative = NA)

# Cards -------------------------------------------------------------



base_card <- ggplot() +
  geom_rect(mapping = aes(fill = "red"),
            xmin = 0, xmax = 10,
            ymin = 0, ymax= 15,
            alpha =0.7 ) +
  geom_hline(yintercept = 10) +
  # annotation_custom(lak, xmin=7, xmax=9, ymin=12, ymax=14) +
  scale_x_continuous(limits = c(0, 10)) +
  scale_y_continuous(limits = c(0, 15)) +
  coord_fixed() +
  guides(fill = "none") +
  theme_void()

# Variables generales ------------------

appname <- "Cartas de narración"
instruction <- read_file("data/instruction.html")
# lak <- rasterGrob(readPNG("data/lak.png"), interpolate = TRUE)
