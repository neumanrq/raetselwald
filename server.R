library(shiny)

new.exercise = function(env) {
  env <- new.env()
  env$a <- sample(1:10, 1)
  env$b <- sample(1:10, 1)
  env$expectedResult <- env$a * env$b
  env$answered <- FALSE
  env
}

shinyServer(function(input, output, session) {
  exercise <- new.exercise()

  observeEvent(input$go, {
    newExercise <- new.exercise()

    currentExercise$a              <- newExercise$a
    currentExercise$b              <- newExercise$b
    currentExercise$expectedResult <- newExercise$expectedResult
    currentExercise$answered       <- newExercise$answered

    updateTextInput(session, "answer", value = "")
  })

  currentExercise <- reactiveValues(
    a              = exercise$a,
    b              = exercise$b,
    expectedResult = exercise$expectedResult,
    answered       = FALSE
  )

  score <- reactiveValues(
    total = 0
  )

  observeEvent(input$answer, {
    answer = input$answer

    if (answer != '' && (as.numeric(answer) == currentExercise$expectedResult) && (currentExercise$answered == FALSE)) {
      score$total <- score$total + 1
      currentExercise$answered <- TRUE
    }
  })

  output$equation <- renderText({
    paste(
      toString(currentExercise$a), " ∙ ", toString(currentExercise$b), " = "
    )
  })


  output$response <- renderText({
    answer = input$answer

    feedback <- if ((answer == '') && (currentExercise$answered == FALSE)) {
      "Schuuhuu! Naaa... weißt du es?"
    } else if ((answer != '') && (currentExercise$answered == FALSE)) {
      "Hhhhm… da stimmt was noch nicht! Du kommst bestimmt gleich drauf."
    } else if (currentExercise$answered == TRUE) {
      "Schuhuuuuu! Super, das ist richtig!"
    } else {
      "Schuuuhhuuu!"
    }

    feedback
  })

  output$score <- renderText({
    paste(
      toString(score$total), " Punkte"
    )
  })

})
