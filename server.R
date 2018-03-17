library(shiny)
library(magrittr)

new.exercise = function(env) {
  env                <- new.env()
  env$a              <- sample(1:10, 1)
  env$b              <- sample(1:10, 1)
  env$expectedResult <- env$a * env$b
  env$solved         <- FALSE
  env
}

feedback.for <- function(answer, currentExercise) {
  if ((answer == '') && (currentExercise$solved == FALSE)) {
    "Schuuhuu! Naaa... weißt du es?"
  } else if ((answer != '') && (currentExercise$solved == FALSE)) {
    "Hhhhm… da stimmt was noch nicht! Du kommst bestimmt gleich drauf."
  } else if (currentExercise$solved == TRUE) {
    "Schuhuuuuu! Super, das ist richtig!"
  } else {
    "Schuuuhhuuu!"
  }
}

shinyServer(function(input, output, session) {
  exercise <- new.exercise()

  observeEvent(input$go, {
    newExercise <- new.exercise()

    currentExercise$a              <- newExercise$a
    currentExercise$b              <- newExercise$b
    currentExercise$expectedResult <- newExercise$expectedResult
    currentExercise$solved       <- newExercise$solved

    session %>% updateTextInput("answer", value = "")
  })

  currentExercise <- reactiveValues(
    a              = exercise$a,
    b              = exercise$b,
    expectedResult = exercise$expectedResult,
    solved         = FALSE
  )

  score <- reactiveValues(
    total = 0
  )

  observeEvent(input$answer, {
    answer <- input$answer

    if (answer != '' && (as.numeric(answer) == currentExercise$expectedResult) && (currentExercise$solved == FALSE)) {
      score$total            <- score$total + 1
      currentExercise$solved <- TRUE
    }
  })

  output$equation <- renderText({
    paste(
      toString(currentExercise$a), " ∙ ", toString(currentExercise$b), " = "
    )
  })

  output$response <- renderText({
    input$answer %>% feedback.for(currentExercise)
  })

  output$score <- renderText({
    paste(
      toString(score$total), " Punkt(e)"
    )
  })

})
