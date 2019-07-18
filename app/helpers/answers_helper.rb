module AnswersHelper
  def show_select_best_option?(answer)
    current_user&.author_of?(answer.question) && !answer.best
  end
end
