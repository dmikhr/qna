json.set! :answer do
  json.set! :id, answer.id
  json.set! :body, answer.body
  json.set! :best, answer.best
  json.set! :user_id, answer.user_id
  json.set! :question_id, answer.question_id
  json.set! :select_best_answer_path, select_best_answer_path(answer)
  json.set! :vote_item_id, vote_item_id(answer)
  json.set! :score, answer.score
end

json.links answer.links do |link|
  json.id link.id
  json.name link.name
  json.url link.url
  json.gist_contents link.gist_contents
  json.gist_link link.gist_link?
end

json.files answer.files do |file|
  json.id file.id
  json.filename file.filename.to_s
  json.url url_for(file)
end
