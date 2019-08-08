$(document).on "turbolinks:load", ->

  App.cable.subscriptions.create { channel: 'CommentsChannel', question_id: gon.question_id },
    connected: ->
      @perform 'follow'

    received: (data) ->
      data = JSON.parse(data)
      comment = data['comment']
      commentableLabel = comment['commentable_label']
      if gon.current_user_id isnt comment.user_id
        $('#comments_' + commentableLabel).append JST['templates/comment'](comment: comment)
