library(shiny)

shinyUI(
  fluidPage(
    fluidRow(
      column(12,
        column(4,
          titlePanel('Hallo 👋')
        )
      ),

      column(12,
        br(),
        column(12,
          column(12, h1(textOutput("equation"))),
          column(2, textInput("answer", label = NULL)),
          column(1, actionButton("go", "Nächste Aufgabe"))
        ),

        column(12,
          h1(textOutput("response"))
        )
      )
    )
  )
)
