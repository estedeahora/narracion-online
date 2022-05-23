server <- function(input, output, session) {


  # reactiveValues -------------------------------------------------

  # Suma de resultados historicos
  history <- reactiveValues(narrat = cards |> filter(F),
                            nueva  = cards |> filter(F))

  # Contador de rondas
  counter <- reactiveValues(countervalue = 0)

  # power card
  power <- reactiveValues(used = F)

  # observeEvent ----------------------------------------------------

  # MENU: PRINCIPAL

  # Botón start
  observeEvent(input$start, {
    updateTabsetPanel(inputId = "switcher", selected = "JUEGO")
    counter$countervalue <- 0
    history$narrat <- cards |> filter(F)
    history$nueva <-  cards |> filter(F)
    power$used <- F
    updateRadioGroupButtons(inputId = "mazo", disabled = T, choices = 1)
    disable(id = "new_narration")
  })

  # Botón instruction
  observeEvent(input$instruction, {
    updateTabsetPanel(inputId = "instr",
                      selected = if(input$instr == "INSTRUCCIONES"){"VACIO"}else{"INSTRUCCIONES"}
                      )
  })

  # MENU: JUEGO
  observeEvent(input$menu1, {
    updateTabsetPanel(inputId = "switcher", selected = "PRINCIPAL")
  })
  # Botón play
  # observeEvent(input$play, {
  observeEvent(input$play, {

    if(counter$countervalue > 0){
      cat("Suma historia\n")
      nueva <- history$nueva |>
        mutate(narrative = input$new_narration)

      history$narrat <- rbind(history$narrat, nueva )
    }else{
      history$narrat <- cards |> filter(F)
    }


    # Habilitar casilla de texto
    enable("new_narration")

    # Vaciar casilla de texto
    updateTextAreaInput(session, "new_narration", value = "")

    # Sumar contador
    cat("sumar contador\n")
    a <- counter$countervalue + 1
    counter$countervalue <- a

    # Habilitar mazos según ronda de juego
    if(input$mazo == 4){
      power$used <- T
    }

    if(a == 0){
      updateRadioGroupButtons(inputId = "mazo", disabled = T, choices = 1)
    }else if(a == 1){
      updateRadioGroupButtons(inputId = "mazo", disabled = F, choices = 1)
    }else if(a <= 3){
      updateRadioGroupButtons(inputId = "mazo", choices = 1:a)
    }else{
      if(power$used){
        updateRadioGroupButtons(inputId = "mazo", disabled = F, choices = 1:3)
      }else{
        updateRadioGroupButtons(inputId = "mazo", disabled = F, choices = 1:4)
      }
    }



    # Elegir carta
    cat("elegir carta\n")
    if(counter$countervalue == 1){
      history$nueva <- cards |>
          filter(name == "1A")
    }else{
      history$nueva <- cards |>
          filter(group == input$mazo) |>
        sample_n(1, weight = p)
    }
  })

  # Restart
  observeEvent(input$restart, {
    counter$countervalue <- 0
    history$narrat <- cards |> filter(F)
    history$nueva <-  cards |> filter(F)
    power$used <- F
    updateRadioGroupButtons(inputId = "mazo", disabled = T, choices = 1)
    disable(id = "new_narration")

  })

  # # MENU: INSTRUCCIONES
  # observeEvent(input$menu2, {
  #   updateTabsetPanel(inputId = "switcher", selected = "PRINCIPAL")
  # })

  # Armar carta -----------------------------------------------

  card <- reactive({

    if(counter$countervalue == 0){
      cat("Juego nuevo\n")
      ggplot() +
        geom_rect(aes(xmin = 0, xmax = 10,
                      ymin = 0, ymax= 15),
                  alpha = 0.7, fill = "white" ) +
        geom_text(aes(label = "¿Listo para jugar?\n Presione 'Nueva carta'"),
                  x = 5, y = 10, size = 8) +
        theme_void()
    }else{
      sel <- history$nueva
      base_card +
        geom_text(data = sel,
                  aes(label = title), x = 5, y = 12, size = 8) +
        geom_text(data = sel,
                  aes(label = description), x = 5, y = 5) +
        geom_text(data = sel,
                  aes (label = name), x = 1, y = 14, size = 5)
    }

  })

  # past <- reactive({
  #   if(a == 1){
  #     card()
  #   }else{
  #     past + card()
  #   }
  # })

  # Outputs --------------------------------------

  output$card <- renderPlot({
    card()
  })

  output$ronda <- renderText({
    paste("Ronda:", counter$countervalue)
  })

  his <- reactive({
    res <- history$narrat |>
      mutate(p = paste0("<p><b>", title, ": </b><br>", narrative, "</p>"))
    HTML(paste(res$p, collapse = ""))
  })


  output$history <- renderText({
    his()
    # res <- history$narrat |>
    #   mutate(p = paste0("<p><b>", title, ": </b><br>", narrative, "</p>"))
    # HTML(paste(res$p, collapse = ""))
  })

  output$download <- downloadHandler(
    filename = function() {
      paste0(input$dataset, ".html")
    },
    content = function(file) {
      write_file(his(), file)
    }
  )




}
