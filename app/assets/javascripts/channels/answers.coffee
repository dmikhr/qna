$(document).on "turbolinks:load", ->

  App.cable.subscriptions.create 'AnswersChannel',
    connected: ->
      @perform 'follow'

    received: (data) ->
      data = JSON.parse(data)
      answer = data['answer']
      links = data['links']
      # чтобы у автора ответ не добавился 2-ой раз
      if gon.current_user_id isnt answer.user_id
        $('.answers').append JST['templates/answer'](answer: answer, links: links)
