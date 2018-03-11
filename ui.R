library(shiny)

shinyUI(
  fluidPage(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "stylesheet.css")
    ),

    fluidRow(
      column(12,
        tags$div(class = "owl", "🦉"),
        tags$div(class = "branch"),
        tags$div(class = "tree-top"),
        tags$div(class = "tree-top-2"),
        tags$div(class = "tree"),
        tags$div(class = "tree-2"),
        tags$div(class = "messages",
          textOutput("response")
        ),
        tags$div(class = "soil")
      ),
      column(12,
        tags$div(class="equation-container",
          list(
            textOutput("equation"),
            textInput("answer", label = NULL)
          )
        )
      ),
      column(12,
        tags$div(class="button-container",
          list(
            actionLink("go", "Nächste Aufgabe stellen!")
          )
        )
      )
    )
  )
)
