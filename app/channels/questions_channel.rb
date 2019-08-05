class QuestionsChannel < ApplicationCable::Channel
  def follow
    # подпись на канал
    stream_from "questions"
  end
end
