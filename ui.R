library(shiny)

shinyUI(
  fluidPage(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "stylesheet.css")
    ),

    fluidRow(
      column(12,
        tags$div(class = "owl", "🦉"),
        tags$div(class = "messages",
          textOutput("response")
        ),
        tags$div(class = "wood", "🌲🌲🌲🌲")
      ),
      column(12,
        tags$div(class="equation-container", checked=NA,
          list(
            textOutput("equation"),
            textInput("answer", label = NULL)
          )
        )
      ),
      column(12,
        tags$div(class="button-container",
          list(
            actionButton("go", "Nächste Aufgabe stellen")
          )
        )
      ),
      column(12,
        tags$div(class = "wood", "🌲🌲🌲🌲")
      )
    )
  )
)
