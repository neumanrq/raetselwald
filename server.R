library(shiny)
library(magrittr)

new.exercise = function(env) {
  env                <- new.env()
  env$x              <- sample(1:10, 1)
  env$y              <- sample(1:10, 1)
  env$z              <- env$x * env$y
  env$sampling       <- sample(c(env$x, env$y, env$z))
  env$expectedResult <- env$sampling[1]
  env$solved         <- FALSE

  env$equation.first <- if (env$expectedResult == env$z) {
    env$x
  } else if (env$expectedResult == env$x) {
    env$z
  } else if (env$expectedResult == env$y) {
    env$z
  }

  env$equation.second <- if (env$expectedResult == env$z) {
    env$y
  } else if (env$expectedResult == env$x) {
    env$y
  } else if (env$expectedResult == env$y) {
    env$x
  }

  env$operator <- if (env$expectedResult == env$z) {
    " ✖️ "
  } else if (env$expectedResult == env$x) {
    " ➗ "
  } else if (env$expectedResult == env$y) {
    " ➗ "
  }

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

    currentExercise$equation.first  <- newExercise$equation.first
    currentExercise$equation.second <- newExercise$equation.second
    currentExercise$expectedResult  <- newExercise$expectedResult
    currentExercise$solved          <- newExercise$solved
    currentExercise$operator        <- newExercise$operator

    session %>% updateTextInput("answer", value = "")
  })

  currentExercise <- reactiveValues(
    equation.first  = exercise$equation.first,
    equation.second = exercise$equation.second,
    expectedResult  = exercise$expectedResult,
    operator        = exercise$operator,
    solved          = FALSE
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
      toString(currentExercise$equation.first),
      enc2utf8(toString(currentExercise$operator)),
      toString(currentExercise$equation.second),
      " = "
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
