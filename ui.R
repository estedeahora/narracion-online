ui <- fluidPage(
  shinyFeedback::useShinyFeedback(),
  # waiter::use_waitress(),
  useShinyjs(),

  tabsetPanel(
    id = "switcher",
    type = "hidden",
    tabPanelBody("PRINCIPAL",
                 fluidRow(
                          h1(appname ),
                   ),
                 column(width = 4,
                        HTML("<p>&nbsp</p>"),
                        HTML("<p>¿Listo para jugar?\n Presione 'Comenzar a jugar'</p>"),
                        HTML("<p>&nbsp</p>"),
                        switchInput(
                          inputId = "Id015",
                          label = "Modalidad",
                          labelWidth = "80px",
                          onLabel = "Completo",
                          onStatus = "danger",
                          offLabel = "Básico" ),
                        HTML("<p>&nbsp</p>"),
                        actionBttn("start",
                                     "Comenzar a jugar",
                                     style = "stretch",
                                     color = "success"),
                        HTML("<p>&nbsp</p>"),
                        actionBttn("instruction",
                                   "Instrucciones",
                                   style = "stretch",
                                   color = "success"),
                        # textOutput("txtinstr"),
                 ),
                 column(width = 6, offset = 1,
                   tabsetPanel(
                     id = "instr",
                     type = "hidden",
                     tabPanelBody(value = "VACIO",
                                  HTML("<p>&nbsp</p>"),
                                  img(src = here::here('data/lak.png'))
                     ),
                     tabPanelBody(value = "INSTRUCCIONES",
                                  # style = "background-color:#DADADA; padding:35px;",
                                  wellPanel(
                                    style = "overflow-y:scroll; max-height: 600px",
                                    HTML(instruction)
                                  )


                                  )

                   )
                 )
    ),
    tabPanelBody("JUEGO",
                 fluidRow(
                   # column(width = 7,
                          h1(appname)
                   #),
                   # column(width = 2),
                 ),
                 # sidebarLayout(
                 # Cartas
                 column(width = 3,
                        plotOutput("card"),
                        textOutput("ronda"),
                        HTML("<p>&nbsp</p>"),
                        actionButton("restart", "Nuevo juego"),
                        actionButton("menu1", "Volver al menú")),
                 column(width = 4,
                        disabled(
                          textAreaInput("new_narration", label = "",
                                        height = '300px', width = '100%',
                                        resize = "vertical",
                                        placeholder = "Escriba su historia")
                        ),
                        actionButton("play", "Nueva carta"),
                        radioGroupButtons(inputId = "mazo",
                                          label = "Elija el mazo",
                                          choices = 1,
                                          selected = 1, #character(0),
                                          disabled = T,
                                          individual = T,
                                          justified = F)
                        ),
                 column(width = 5,
                        downloadButton("download",
                                       label = "Descargar historia"),
                        HTML("<p>&nbsp</p>"),
                        uiOutput("history"))

                 )
    # tabPanelBody("INSTRUCCIONES",
    #              fluidRow(
    #                column(width = 7,
    #                       h1(appname)),
    #                column(width = 2),
    #                column(width = 3,
    #                       HTML("<p>&nbsp</p>"),
    #                       actionButton("menu2", "Volver al menú")
    #                )
    #              ),
    #              column(width = 6,
    #                     HTML(instruction)
    #              ),
    #              column(width = 4,
    #                     # img(src = here::here("data/lak.png"),
    #                     #     height = 140, width = 400)
    #              )
    # )
  )
)
