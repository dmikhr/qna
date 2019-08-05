$(document).on "turbolinks:load", ->

  App.cable.subscriptions.create 'QuestionsChannel',
    connected: ->
      @perform 'follow'

    received: (data) ->
      $('.questions').append JST['templates/question'](question: JSON.parse(data)['question'])
