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
      "Naaa... weißt du es? Versuche die Aufgabe zu lösen."
    } else if (answer != '' && (as.numeric(answer) == currentExercise$expectedResult)) {
      "Super, das ist korrekt 👍"
    } else {
      "Hm... da musst du nochmal überlegen 🤔"
    }
  })

})
