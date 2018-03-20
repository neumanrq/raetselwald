library(shiny)
library(magrittr)

new.exercise = function(level = 1) {
  env                <- new.env()
  env$x              <- sample(1:10, 1)
  env$y              <- sample(1:10, 1)
  env$u              <- env$x + env$y
  env$v              <- env$x * env$y

  env$sampling.u     <- sample(c(env$x, env$y, env$u))
  env$sampling.v     <- sample(c(env$x, env$y, env$v))

  env$expectedResult.u <- env$sampling.u[1]
  env$expectedResult.v <- env$sampling.v[1]
  env$solved           <- FALSE

  if (level == 1) {
    env$equation.first    <- env$x
    env$equation.second   <- env$y
    env$expectedResult.u  <- env$u
    env$operator          <- " + "
  } else {
     env$equation.first <- if (env$expectedResult.v == env$v) {
       env$x
     } else if (env$expectedResult.v == env$x) {
       env$v
     } else if (env$expectedResult.v == env$y) {
       env$v
     }

     env$equation.second <- if (env$expectedResult.v == env$v) {
        env$y
      } else if (env$expectedResult.v == env$x) {
        env$y
      } else if (env$expectedResult.v == env$y) {
        env$x
      }

    env$operator <- if (env$expectedResult.v == env$v) {
        " ✖️ "
      } else if (env$expectedResult.v == env$x) {
        " ➗ "
      } else if (env$expectedResult.v == env$y) {
        " ➗ "
      }
  }

  env$expectedResult <- if (env$operator == " + ") {
      env$expectedResult.u
    } else {
      env$expectedResult.v
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
  exercise <- new.exercise(level = 0)

  observeEvent(input$go, {
    newExercise <- new.exercise(level = 1)

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
      enc2native(toString(currentExercise$operator)),
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
