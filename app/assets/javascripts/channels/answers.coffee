$(document).on "turbolinks:load", ->

  App.cable.subscriptions.create { channel: 'AnswersChannel', question_id: gon.question_id },
    connected: ->
      @perform 'follow'

    received: (data) ->
      data = JSON.parse(data)
      answer = data['answer']
      links = data['links']
      files = data['files']
      # чтобы у автора ответ не добавился 2-ой раз
      if gon.current_user_id isnt answer.user_id
        $('.answers').append JST['templates/answer'](answer: answer, links: links, files: files)
