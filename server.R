library(shiny)

new.exercise = function(env) {
  env = new.env()
  env$a <- sample(1:10, 1)
  env$b <- sample(1:10, 1)
  env$expectedResult <- env$a * env$b
  env
}

shinyServer(function(input, output, session) {
  exercise <- new.exercise()

  observeEvent(input$go, {
    newExercise <- new.exercise()
    currentExercise$a <- newExercise$a
    currentExercise$b <- newExercise$b
    currentExercise$expectedResult <- newExercise$expectedResult
    updateTextInput(session, "answer", value = "")
  })

  currentExercise <- reactiveValues(
    a              = exercise$a,
    b              = exercise$b,
    expectedResult = exercise$expectedResult
  )

  output$equation <- renderText({
    paste(
      toString(currentExercise$a), " ∙ ", toString(currentExercise$b), " = "
    )
  })

  output$response <- renderText({
    answer = input$answer

    if (answer == '') {
      "Schuuhuu! Naaa... weißt du es?"
    } else if (answer != '' && (as.numeric(answer) == currentExercise$expectedResult)) {
      "Schuhuuuuu! Super, das ist richtig! 👍"
    } else {
      "*Grummel* Hm... da musst du nochmal überlegen 🤔"
    }
  })

})
