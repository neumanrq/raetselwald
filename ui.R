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
          column(10,
            list(
              column(8, uiOutput('equation')),
              column(2, textInput("answer", label = NULL))
            )
          )
        ),
        tags$div(class = "score-container",
          textOutput("score")
        )
      ),
      column(12,
        tags$div(class="button-container",
          list(
            actionLink("go", "Ok, stell' mir die nächste Aufgabe!")
          )
        )
      )
    )
  )
)
