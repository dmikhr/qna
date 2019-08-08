json.set! :question do
  json.set! :title, question.title
  json.set! :path, question_path(question)
end
