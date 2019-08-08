$(document).on "turbolinks:load", ->

  App.cable.subscriptions.create 'QuestionsChannel',
    connected: ->
      @perform 'follow'

    received: (data) ->
      question = JSON.parse(data)['question']
      $('.questions').append JST['templates/question'](question: question)
