library(shiny)
library(magrittr)


multiplicationExercise.new <- function() {
  env                <- new.env()
  env$x              <- sample(1:10, 1)
  env$y              <- sample(1:10, 1)
  env$v              <- env$x * env$y
  env$sampling       <- sample(c(env$x, env$y, env$v))
  env$expectedResult <- env$sampling[1]
  env$solved         <- FALSE

  env$equation.first <- if (env$expectedResult == env$v) {
    env$x
  } else if (env$expectedResult == env$x) {
    env$v
  } else if (env$expectedResult == env$y) {
    env$v
  }

  env$equation.second <- if (env$expectedResult == env$v) {
    env$y
  } else if (env$expectedResult == env$x) {
    env$y
  } else if (env$expectedResult == env$y) {
    env$x
  }

  env$operator <- if (env$expectedResult == env$v) {
    "\\cdot"
  } else if (env$expectedResult == env$x) {
    ":"
  } else if (env$expectedResult == env$y) {
    ": "
  }

  env
}

additionExercise.new <- function() {
  env                 <- new.env()
  env$x               <- sample(1:10, 1)
  env$y               <- sample(1:10, 1)
  env$expectedResult  <- env$x + env$y
  env$solved          <- FALSE
  env$equation.first  <- env$x
  env$equation.second <- env$y
  env$operator        <- " + "
  env
}

new.exercise = function(level = 0) {
  env <- if (level == 1) {
    additionExercise.new()
  } else {
    multiplicationExercise.new()
  }

  env
}

feedback.for <- function(answer, currentExercise) {
  if ((answer == '') && (currentExercise$solved == FALSE)) {
    "Schuhuuu! Diese Aufgabe habe ich gerade eben im Wald aufgeschnappt:"
  } else if ((answer != '') && (currentExercise$solved == FALSE)) {
    "Hhhhm… da stimmt was noch nicht! Du kommst bestimmt gleich drauf."
  } else if (currentExercise$solved == TRUE) {
    "Schuhuuuuu! Super, das ist richtig!"
  } else {
    "Schuuuhhuuu!"
  }
}

shinyServer(function(input, output, session) {
  score <- reactiveValues(
    total = 0,
    level = 0
  )
  exercise <- new.exercise(level = isolate(score$level))

  observeEvent(input$go, {
    newExercise <- new.exercise(level = score$level)

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


  observeEvent(input$answer, {
    answer <- input$answer

    if (answer != '' && (as.numeric(answer) == currentExercise$expectedResult) && (currentExercise$solved == FALSE)) {
      score$total <- score$total + 1

      if (score$total > 0 && score$total %% 10 == 0) {
        score$level <- score$level + 1
      }

      currentExercise$solved <- TRUE
    }
  })

  output$equation <- renderUI({
    formula <- paste(
      "$$\\",
      toString(currentExercise$equation.first),
      enc2native(toString(currentExercise$operator)),
      toString(currentExercise$equation.second),
      " = ",
      "$$"
    )

    withMathJax(helpText(formula))
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
